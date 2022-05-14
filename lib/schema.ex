defmodule Helpdesk.Schema do
  use Absinthe.Schema

  @apis [Helpdesk.Tickets.Api, Helpdesk.Accounts.Api]

  use AshGraphql, apis: @apis

  query do
  end

  mutation do
  end

  def context(ctx) do
    AshGraphql.add_context(ctx, @apis)
  end

  def plugins() do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end
end
