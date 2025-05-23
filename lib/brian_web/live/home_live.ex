defmodule BrianWeb.HomeLive do
  use BrianWeb, :live_view

  def mount(_params, _session, socket) do
    send(self(), :fetch_data)
    {:ok, socket
      |> assign(:activity, nil)
      |> assign(:page_title, "Brian Berlin - Senior Software Engineer")}
  end

  def render(assigns) do
    ~H"""
    <section>
      <.makeup>
        name = "Brian Berlin"
        pattern = ~r/(Bri)a(n) (Berl)(in)/
        Regex.replace(pattern, name, "Email: \\1@\\2\\3.\\4")
      </.makeup>
    </section>

    <section>
      <h2>
        Coding Activity <span phx-update="ignore" id="activity-total" class="text-sm text-gray-600 block sm:inline"></span>
      </h2>
      <div :if={@activity} class="flex flex-row pt-4 overflow-auto" id="activity-grid" phx-hook="Draggable">
        <div :for={{_week, totals} <- @activity} class="flex flex-col w-full">
          <div
            :for={%{date: date, total: total} <- totals}
            class="mt-0.5 mr-0.5"
            data-total={Float.round(total / 60 / 60, 2)}
            data-date={Calendar.strftime(date, "%b %d, %Y")}
            id={"date-#{to_string(date)}"}
            phx-hook="Activity"
          >
            <div class={"#{color(total)} lg:w-full w-4 h-4"} />
          </div>
        </div>
      </div>
    </section>

    <section>
      <h2>Technical Skills</h2>
      <ul>
        <li>Elixir / Erlang / OTP / Phoenix / GraphQL / Liveview / Nerves</li>
        <li>Javascript / React / Redux / React Native / Ember / NodeJS</li>
        <li>Postgres / MySQL / MongoDB / Redis / DynamoDB / Elasticsearch</li>
        <li>Docker / Kubernetes</li>
        <li>New Relic / Prometheus / Grafana / Observability</li>
      </ul>
    </section>

    <section>
      <h2>Open Source</h2>
      <ul>
        <li>
          <a href="https://github.com/peek-travel/coverage-reporter">Coverage Reporter</a>
          - GitHub Action that analyzes test coverage and adds PR annotations highlighting areas needing additional tests.
        </li>
        <li>
          <a href="https://github.com/brianberlin/fleature">Fleature</a> - A feature flag system for Elixir applications.
        </li>
        <li>
          <a href="https://github.com/nerves-hub/nerves_hub_web/pull/676">
            NervesHubWeb - Ability to delete accounts
          </a>
        </li>
        <li>
          <a href="https://github.com/nerves-hub/nerves_hub_web/pulls?q=is%3Apr+author%3Abrianberlin+is%3Aclosed">
            NervesHubWeb - Other contributions
          </a>
        </li>
      </ul>
    </section>

    <section>
      <h2>Articles</h2>
      <ul>
        <%!-- <li><.link href={~p"/code-coverage"}>Code Coverage in Elixir</.link></li> --%>
        <li>
          <a href="https://revelry.co/resources/development/ecto/" target="_blank">
            Ecto, You Got Some 'Splainin To Do
          </a>
        </li>
        <li>
          <a
            href="https://web.archive.org/web/20210801113025/https://revelry.co/resources/team/brian-berlin/"
            target="_blank"
          >
            Get to Know Brian Berlin: Dad, Amateur Car Racer, and Software Engineer
          </a>
        </li>
      </ul>
    </section>
    """
  end

  def handle_info(:fetch_data, socket) do
    case Brian.Wakatime.fetch_activity() do
      {:ok, activity} ->
        {:noreply, assign(socket, :activity, activity)}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  defp color(seconds) when seconds > 39_600, do: "bg-slate-50"
  defp color(seconds) when seconds > 36_000, do: "bg-slate-100"
  defp color(seconds) when seconds > 32_400, do: "bg-slate-200"
  defp color(seconds) when seconds > 28_800, do: "bg-slate-300"
  defp color(seconds) when seconds > 25_200, do: "bg-slate-400"
  defp color(seconds) when seconds > 21_600, do: "bg-slate-500"
  defp color(seconds) when seconds > 18_000, do: "bg-slate-600"
  defp color(seconds) when seconds > 14_400, do: "bg-slate-700"
  defp color(seconds) when seconds > 10_800, do: "bg-slate-700"
  defp color(seconds) when seconds > 7_200, do: "bg-slate-700"
  defp color(seconds) when seconds > 0, do: "bg-slate-700"
  defp color(_), do: "bg-slate-800"
end
