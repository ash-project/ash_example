defmodule Helpdesk.MixProject do
  use Mix.Project

  def project do
    [
      app: :helpdesk,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Helpdesk.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ash, "~> 1.51"},
      {:ash_postgres, "~> 0.41"},
      {:ash_json_api, "~> 0.29"},
      {:ash_policy_authorizer, "~> 0.16"},
      {:ash_graphql, "~> 0.17"},
      {:ash_phoenix, "~> 0.7"},
      {:gettext, "~> 0.18"},
      {:absinthe, "~> 1.7"},
      {:phoenix, "~> 1.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto, "~> 3.8"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.17"},
      {:floki, ">= 0.32.0", only: :test},
      {:phoenix_html, "~> 3.2"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:jason, "~> 1.3"},
      {:plug_cowboy, "~> 2.5"},
      {:absinthe_plug, "~> 1.5"},
      {:ecto_psql_extras, "~> 0.6"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
