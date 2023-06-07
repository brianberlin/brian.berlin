defmodule BrianWeb.CoreComponentsTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import BrianWeb.CoreComponents

  describe "modal" do
    test "it renders" do
      assigns = %{}

      assert rendered_to_string(~H"""
             <.modal id="test" show>
               Test
             </.modal>
             """) =~ "Test"
    end
  end
end
