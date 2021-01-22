defmodule Helpdesk.Tickets.Customer do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      AshPolicyAuthorizer.Authorizer
    ],
    extensions: [
      AshJsonApi.Resource
    ]

  resource do
    base_filter representative: false
  end

  multitenancy do
    strategy :context
  end

  json_api do
    type "customer"

    routes do
      base "/customers"

      get :read
      index :read
    end
  end

  postgres do
    table "users"
    repo Helpdesk.Repo
  end

  policies do
    bypass always() do
      authorize_if actor_attribute_equals(:admin, true)
    end

    policy action_type(:read) do
      authorize_if attribute(:id, not: [eq: actor(:id)])
      authorize_if relates_to_actor_via([:reported_tickets, :representative])
    end
  end

  actions do
    read :read
  end

  attributes do
    uuid_primary_key :id

    attribute :first_name, :string
    attribute :last_name, :string
    attribute :representative, :boolean
  end

  relationships do
    has_many :reported_tickets, Helpdesk.Tickets.Ticket do
      destination_field :reporter_id
    end
  end
end
