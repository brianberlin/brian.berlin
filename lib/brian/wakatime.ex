defmodule Brian.Wakatime do
  @moduledoc false
  @callback fetch_activity() :: {:ok, map()} | {:error, :not_found}

  def fetch_activity do
    impl().fetch_activity()
  end

  defp impl, do: Application.get_env(:brian, :wakatime, Brian.Wakatime.External)

  defmodule External do
    @moduledoc false
    def fetch_activity do
      url = "https://wakatime.com/share/@7147b01d-e23f-4f70-841a-41eac5c1c21f/155fd3fd-d3b3-44d2-80ba-5e0b307a44b1.json"

      with {:ok, nil} <- Cachex.get(:brian_cache, :activity),
           {:ok, %{body: body}} <- Req.get(url) do
        activity = parse_activity(body)
        Cachex.put(:brian_cache, :activity, activity, ttl: :timer.minutes(10))
        {:ok, activity}
      else
        {:ok, activity} ->
          {:ok, activity}

        _ ->
          {:error, :not_found}
      end
    end

    defp parse_activity(%{"days" => days}) do
      days
      |> Stream.map(&%{total: &1["total"], date: Date.from_iso8601!(&1["date"])})
      |> Enum.to_list()
      |> Enum.group_by(&(&1.date |> Date.to_erl() |> :calendar.iso_week_number()))
      |> Enum.sort()
    end
  end
end
