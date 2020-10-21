defmodule Helpdesk.Accounts.Api do
  use Ash.Api,
    extensions: [
      AshJsonApi.Api,
      AshGraphql.Api
    ]

  graphql do
    authorize? true
  end

  resources do
    resource Helpdesk.Accounts.User
  end
end
