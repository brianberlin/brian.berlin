defmodule Mix.Tasks.CoverageReporter do
  @shortdoc "List of changed files in a pull github_request"
  @moduledoc false
  use Mix.Task

  @switches [
    github_token: :string,
    pull_number: :integer,
    repository: :string,
    head_branch: :string,
    commit_sha: :string
  ]

  def run(args) do
    Mix.Task.run("compile")

    {opts, _, _} = OptionParser.parse(args, strict: @switches)

    pull_number = Keyword.get(opts, :pull_number)
    repository = Keyword.get(opts, :repository)
    github_token = Keyword.get(opts, :github_token)
    head_branch = Keyword.get(opts, :head_branch)

    %{
      changed_apps: changed_apps,
      changed_files: changed_files
    } = get_changed_files(repository, pull_number, github_token)

    changed_modules = changed_files |> Map.values() |> List.flatten()

    setup_cover(changed_apps)

    generate_lcov_file(changed_modules)

    {total, module_results} = get_coverage_reports(changed_modules)

    summary = create_summary(total, module_results)

    coverage_reports = create_coverage_reports(changed_modules)

    text = Enum.join([summary, coverage_reports], "\n\n")

    params = %{
      name: "Code Coverage Report",
      head_sha: head_branch,
      status: "completed",
      conclusion: get_conclusion(total),
      output: %{
        title: "Code Coverage Report",
        summary: "Below is a summary of code coverages.",
        text: String.slice(text, 0..65_500),
        annotations: create_annotations(changed_files)
      }
    }

    github_request(:post, "#{repository}/check-runs", github_token, params)

    opts
    |> Keyword.put(:summary, summary)
    |> create_or_update_review_comment()

    Enum.each(changed_files, &create_pull_request_annotations(&1, opts))

    File.mkdir_p!("cover/reports")
    File.write!("cover/reports/coverage_report.txt", text)
  end

  defp create_annotations(changed_files) do
    changed_files
    |> Enum.filter(fn {_, changed_modules} -> length(changed_modules) > 0 end)
    |> Enum.flat_map(fn {changed_file, changed_modules} ->
      {:result, results, _fail} =
        changed_modules
        |> Enum.map(&:"Elixir.#{&1}")
        |> :cover.analyse(:coverage, :line)

      results
      |> Enum.filter(fn {{_mod, line}, {_cov, _not_cov}} -> line > 1 end)
      |> Enum.chunk_by(fn {{_mod, _line}, {cov, _not_cov}} -> cov == 1 end)
      |> Enum.reject(fn [{{_mod, _line}, {cov, _not_cov}} | _] -> cov == 1 end)
      |> Enum.map(fn lines ->
        {{_mod, first_line}, _} = List.first(lines)
        {{_mod, last_line}, _} = List.last(lines)

        %{
          title: "Code Coverage",
          message: "Lines #{first_line}-#{last_line} not covered by tests.",
          start_line: first_line,
          end_line: last_line,
          annotation_level: "warning",
          path: changed_file
        }
      end)
    end)
  end

  defp create_pull_request_annotations({path, changed_modules}, opts) do
    pull_number = Keyword.get(opts, :pull_number)
    repository = Keyword.get(opts, :repository)
    github_token = Keyword.get(opts, :github_token)
    commit_sha = Keyword.get(opts, :commit_sha)

    body =
      Enum.reduce(changed_modules, "", fn changed_module, acc ->
        case File.read("cover/reports/#{changed_module}.txt") do
          {:ok, coverage_report} ->
            """
            #{acc}
            <details>
              <summary>#{changed_module}</summary>

              ```
              #{coverage_report}
              ```
            </details>
            """

          _ ->
            acc
        end
      end)

    params = %{
      path: path,
      subject_type: "file",
      body: body,
      commit_id: commit_sha
    }

    github_request(:post, "#{repository}/pulls/#{pull_number}/comments", github_token, params)
  end

  defp create_or_update_review_comment(opts) do
    %{
      repository: repository,
      pull_number: pull_number,
      github_token: github_token,
      summary: summary
    } = Map.new(opts)

    {:ok, {{_, 200, ~c"OK"}, _headers, body}} =
      github_request(:get, "#{repository}/pulls/#{pull_number}/reviews?per_page=100", github_token)

    review =
      body
      |> to_string()
      |> Jason.decode!()
      |> Enum.find(&(&1["body"] =~ "Code Coverage Report"))

    if is_nil(review) do
      github_request(:post, "#{repository}/pulls/#{pull_number}/reviews", github_token, %{
        body: summary,
        event: "COMMENT"
      })
    else
      github_request(:put, "#{repository}/pulls/#{pull_number}/reviews/#{review["id"]}", github_token, %{
        body: summary
      })
    end
  end

  defp generate_lcov_file(changed_modules) do
    changed_modules = Enum.map(changed_modules, &:"Elixir.#{&1}")
    covered_modules = MapSet.intersection(MapSet.new(:cover.modules()), MapSet.new(changed_modules))

    lcov =
      covered_modules
      |> Enum.sort()
      |> Enum.map(fn mod ->
        path =
          mod.module_info(:compile)[:source]
          |> to_string()
          |> Path.relative_to(File.cwd!())

        {:ok, fun_data} = :cover.analyse(mod, :calls, :function)
        {functions_coverage, %{fnf: fnf, fnh: fnh}} = LcovEx.Stats.function_coverage_data(fun_data)
        {:ok, lines_data} = :cover.analyse(mod, :calls, :line)
        {lines_coverage, %{lf: lf, lh: lh}} = LcovEx.Stats.line_coverage_data(lines_data)
        LcovEx.Formatter.format_lcov(mod, path, functions_coverage, fnf, fnh, lines_coverage, lf, lh)
      end)

    File.mkdir_p!("cover")
    File.write!("cover/lcov.info", lcov, [:write])
  end

  defp create_summary(total, module_results) do
    Enum.join(
      [
        "[Code Coverage Report](#report)",
        "",
        "| Percentage | Module |",
        "|-----------|--------------------------|",
        create_module_results(module_results),
        "-----------|--------------------------",
        display({total, "Total"})
      ],
      "\n"
    )
  end

  defp create_module_results([]), do: "| No Changes |  |"

  defp create_module_results(module_results) do
    Enum.map_join(module_results, "\n", &display(&1))
  end

  defp create_coverage_reports(changed_modules) do
    File.mkdir_p!("cover/reports")

    Mix.shell().info("Writing Coverage Files")

    for mod <- changed_modules do
      Mix.shell().info(" - #{mod}")
      :cover.analyse_to_file(:"Elixir.#{mod}", ~c"cover/reports/#{mod}.txt")
    end

    Mix.shell().info("")

    Enum.reduce(changed_modules, "", fn changed_module, acc ->
      case File.read("cover/reports/#{changed_module}.txt") do
        {:ok, coverage_report} ->
          """
          #{acc}

          ----------------------------------------

          [#{changed_module}](##{changed_module})

          ```
          #{coverage_report}
          ```
          """

        _ ->
          acc
      end
    end)
  end

  defp get_conclusion(total) do
    if total >= 90 do
      "success"
    else
      "neutral"
    end
  end

  defp display({percentage, name}) do
    "| #{format_number(percentage, 9)}% | #{format_name(name)} |"
  end

  defp format_number(number, length), do: :io_lib.format("~#{length}.2f", [number])

  defp format_name(name) when is_binary(name), do: name
  defp format_name(mod) when is_atom(mod), do: inspect(mod)

  defp get_changed_files(repository, pull_number, github_token) do
    {:ok, {{_, 200, ~c"OK"}, _headers, body}} =
      github_request(:get, "#{repository}/pulls/#{pull_number}/files", github_token)

    body
    |> to_string()
    |> Jason.decode!()
    |> do_get_changed_files()
  end

  defp do_get_changed_files(changed_files) do
    changed_files =
      changed_files
      |> Enum.reject(&String.equivalent?(&1["status"], "removed"))
      |> Enum.map(& &1["filename"])
      |> Enum.filter(&String.ends_with?(&1, ".ex"))

    changed_apps =
      changed_files
      |> Enum.map(&Regex.scan(~r/apps\/([a-z_]+)\/.+/, &1, capture: :all_but_first))
      |> List.flatten()
      |> Enum.uniq()

    %{
      changed_apps: changed_apps,
      changed_files:
        Map.new(changed_files, fn file ->
          {file, get_modules(file)}
        end)
    }
  end

  defp get_modules(file_path) do
    app_dir = File.cwd!()
    absolute_file_path = Path.join([app_dir, file_path])

    if File.exists?(absolute_file_path) do
      {:ok, contents} = File.read(absolute_file_path)

      ~r{defmodule \s+ (\S+) }x
      |> Regex.scan(contents, capture: :all_but_first)
      |> List.flatten()
      |> Enum.reject(&String.equivalent?(&1, "\\s+"))
    else
      []
    end
  end

  defp get_coverage_reports(changed_modules) do
    {:result, results, _fail} = :cover.analyse(:coverage, :line)
    changed_modules = Enum.map(changed_modules, &:"Elixir.#{&1}")
    table = :ets.new(__MODULE__, [:set, :private])

    for {{module, line}, cov} <- results, module in changed_modules, line != 0 do
      case cov do
        {1, 0} ->
          :ets.insert(table, {{module, line}, true})

        {0, 1} ->
          :ets.insert_new(table, {{module, line}, false})
      end
    end

    percentage = fn
      0, 0 -> 100.0
      covered, not_covered -> covered / (covered + not_covered) * 100
    end

    module_results =
      for module <- changed_modules do
        covered = :ets.select_count(table, [{{{module, :_}, true}, [], [true]}])
        not_covered = :ets.select_count(table, [{{{module, :_}, false}, [], [true]}])
        {percentage.(covered, not_covered), module}
      end

    covered = :ets.select_count(table, [{{{:_, :_}, true}, [], [true]}])
    not_covered = :ets.select_count(table, [{{{:_, :_}, false}, [], [true]}])
    total = percentage.(covered, not_covered)

    {total, module_results}
  end

  defp github_request(method, path, github_token, params \\ %{}) do
    :inets.start()
    :ssl.start()

    url = ~c"https://api.github.com/repos/#{path}"

    headers = [
      {~c"Authorization", ~c"Bearer #{github_token}"},
      {~c"Accept", ~c"application/vnd.github+json"},
      {~c"X-GitHub-Api-Version", ~c"2022-11-28"},
      {~c"User-Agent", ~c"CoverageReporter"}
    ]

    request =
      case method do
        :get ->
          {url, headers}

        :post ->
          {url, headers, ~c"application/json", Jason.encode!(params)}

        :put ->
          {url, headers, ~c"application/json", Jason.encode!(params)}
      end

    ssl = [
      verify: :verify_peer,
      cacerts: :public_key.cacerts_get(),
      customize_hostname_check: [
        match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
      ]
    ]

    :httpc.request(method, request, [ssl: ssl], [])
  end

  defp setup_cover(changed_apps) do
    _ = :cover.stop()
    {:ok, pid} = :cover.start()

    config = Mix.Project.config()

    compile_paths = apps_paths(config)

    changed_paths =
      Enum.filter(compile_paths, &Enum.any?(changed_apps, fn app -> String.contains?(&1, "lib/#{app}") end))

    {:ok, string_io} = StringIO.open("")

    Process.group_leader(pid, string_io)

    Mix.shell().info("Cover Compiling")

    for compile_path <- changed_paths do
      Mix.shell().info(" - #{compile_path}")

      case :cover.compile_beam(beams(compile_path)) do
        results when is_list(results) ->
          :ok

        {:error, reason} ->
          Mix.raise(
            "Failed to cover compile directory #{inspect(Path.relative_to_cwd(compile_path))} " <>
              "with reason: #{inspect(reason)}"
          )
      end
    end

    Mix.shell().info("")

    for entry <- Path.wildcard("**/*.coverdata") do
      entry
      |> String.to_charlist()
      |> :cover.import()
    end

    pid
  end

  defp apps_paths(config) do
    if apps_paths = Mix.Project.apps_paths(config) do
      build_path = Mix.Project.build_path(config)

      Enum.map(apps_paths, fn {app, _} ->
        Path.join([build_path, "lib", Atom.to_string(app), "ebin"])
      end)
    else
      [Mix.Project.compile_path(config)]
    end
  end

  # Pick beams from the compile_path but if by any chance it is a protocol,
  # gets its path from the code server (which will most likely point to
  # the consolidation directory as long as it is enabled).
  defp beams(dir) do
    consolidation_dir = Mix.Project.consolidation_path()

    consolidated =
      case File.ls(consolidation_dir) do
        {:ok, files} -> files
        _ -> []
      end

    for file <- File.ls!(dir), Path.extname(file) == ".beam" do
      with true <- file in consolidated,
           [_ | _] = path <- :code.which(file |> Path.rootname() |> String.to_atom()) do
        path
      else
        _ -> String.to_charlist(Path.join(dir, file))
      end
    end
  end
end
