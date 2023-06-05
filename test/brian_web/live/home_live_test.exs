defmodule BrianWeb.HomeLiveTest do
  use BrianWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  test "it renders", ctx do
    %{conn: conn} = ctx

    expect(MockWakatime, :fetch_activity, fn ->
      activity = [{{2023, 1}, [%{total: 1000, date: ~D[2023-01-01]}]}]
      {:ok, activity}
    end)

    {:ok, view, html} = live(conn, ~p"/")
    assert html =~ "Brian Berlin"
    assert has_element?(view, "#date-2023-01-01")
  end
end
