defmodule BrianWeb.CodeCoverageLive do
  use BrianWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="content">
      <h1>Code Coverage in Elixir</h1>

      <h2>Introduction</h2>

      <p>Elixir has access to code coverage tools built into Erlang. This is a quick guide on how to use them.</p>

      <p>
        The erlang tools for collecting and analyzing code coverage are documented
        <a href="http://erlang.org/doc/apps/tools/cover_chapter.html">here</a>
      </p>

      <h2>Setup</h2>

      <p>Let's setup a new project to play with.</p>

      <.makeup variant="shell">
        ➜  mix new calculator
      </.makeup>

      <p>Now let's add some code and tests to give us some partial coverage.</p>

      <.makeup>
        # test/calculator.exs
        defmodule Calculator do
        def add(a, b) do
        a + b
        end

        def multiply(a, b) do
        a * b
        end
        end
      </.makeup>

      <.makeup>
        # test/calculator_test.exs
        defmodule CalculatorTest do
        use ExUnit.Case

        describe "add/2" do
        test "2 plus 3 is 5" do
        assert Calculator.add(2, 3) == 5
        end

        test "2 plus 2 is 4" do
        assert Calculator.add(2, 2) == 4
        end
        end
        end
      </.makeup>

      <p>Now that we have some code and tests, let's see how we're doing on coverage</p>

      <.makeup variant="shell">
        ➜  mix test --cover
        Cover compiling modules ...
        ..
        Finished in 0.01 seconds (0.00s async, 0.01s sync)
        2 tests, 0 failures

        Randomized with seed 484188

        Generating cover results ...

        Percentage | Module
        -----------|--------------------------
        50.00% | Calculator
        -----------|--------------------------
        50.00% | Total

        Coverage test failed, threshold not met:

        Coverage:   50.00%
        Threshold:  90.00%

        Generated HTML coverage results in "cover" directory

        ➜  echo $?
        3
      </.makeup>

      <p>
        We can see the threshold was not met and exited with exit code 3. Which is useful when running in a CI environment to enforce coverage.
      </p>

      <p>We can lower the threshold for coverage by updating the `mix.exs` file.</p>

      <.makeup>
        def project do
        [
        app: :calculator,
        version: "0.1.0",
        elixir: "~> 1.14",
        start_permanent: Mix.env() == :prod,
        deps: deps(),
        test_coverage: [summary: [threshold: 50]]
        ]
        end
      </.makeup>

      <p>Now we can run the tests again and see that we pass the coverage requirements.</p>

      <p>There's also an html file generated that we can open to see the coverage line by line.</p>

      <.makeup variant="shell">
        ➜  open cover/Elixir.Calculator.html
      </.makeup>

      <p>We can easily see that we're missing coverage on the `multiply/2` function.</p>
    </section>
    """
  end
end
