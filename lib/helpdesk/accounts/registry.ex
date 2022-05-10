defmodule Helpdesk.Accounts.Registry do
  use Ash.Registry,
    extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry Helpdesk.Accounts.User
  end
end
