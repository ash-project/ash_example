defmodule Helpdesk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Helpdesk.Repo,
      # Start the Telemetry supervisor
      HelpdeskWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Helpdesk.PubSub},
      # Start the Endpoint (http/https)
      HelpdeskWeb.Endpoint
      # Start a worker by calling: Helpdesk.Worker.start_link(arg)
      # {Helpdesk.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Helpdesk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HelpdeskWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
