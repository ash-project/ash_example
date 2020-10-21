defmodule HelpdeskWeb.HomeLiveTest do
  use HelpdeskWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, home_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Phoenix!"
    assert render(home_live) =~ "Welcome to Phoenix!"
  end
end
