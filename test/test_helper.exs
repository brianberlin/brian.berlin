ExUnit.start()
Mox.defmock(MockWakatime, for: Brian.Wakatime)
Application.put_env(:brian, :wakatime, MockWakatime)
