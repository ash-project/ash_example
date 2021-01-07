defmodule HelpdeskWeb.Router do
  use HelpdeskWeb, :router
  require AshJsonApi

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HelpdeskWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelpdeskWeb.Plugs.FakeUser
  end

  pipeline :ash_admin do
    plug AshAdmin.SessionPlug
  end

  pipeline :playground do
    plug :accepts, ["html"]
    plug :fetch_session
    plug HelpdeskWeb.Plugs.FakeUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug HelpdeskWeb.Plugs.FakeUser
  end

  scope "/json_api" do
    pipe_through(:api)

    AshJsonApi.forward("/helpdesk", Helpdesk.Helpdesk.Api)
  end

  scope "/" do
    pipe_through(:api)

    forward "/gql", Absinthe.Plug, schema: Helpdesk.Schema
  end

  scope "/" do
    pipe_through(:playground)

    forward "/playground",
            Absinthe.Plug.GraphiQL,
            schema: Helpdesk.Schema,
            interface: :playground
  end

  scope "/" do
    pipe_through [:browser, :ash_admin]
    import AshAdmin.Router

    ash_admin("/admin", apis: [Helpdesk.Accounts.Api, Helpdesk.Tickets.Api])
  end

  scope "/", HelpdeskWeb do
    pipe_through :browser

    live "/", HomeLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelpdeskWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HelpdeskWeb.Telemetry
    end
  end
end
