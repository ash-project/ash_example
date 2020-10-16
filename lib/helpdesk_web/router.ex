defmodule HelpdeskWeb.Router do
  use HelpdeskWeb, :router
  require AshBrowser
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

    forward "/playground",
            Absinthe.Plug.GraphiQL,
            schema: Helpdesk.Schema,
            interface: :playground
  end

  scope "/" do
    pipe_through :browser
    AshBrowser.routes(Helpdesk.Tickets.Api)
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

  # AshBrowser.forward("/", Helpdesk.Tickets.Api)
end
