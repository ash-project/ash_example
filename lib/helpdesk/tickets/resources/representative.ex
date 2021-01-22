defmodule Helpdesk.Tickets.Representative do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      AshPolicyAuthorizer.Authorizer
    ],
    extensions: [
      AshJsonApi.Resource,
      AshGraphql.Resource
    ]

  resource do
    base_filter representative: true

    identities do
      identity :representative_name, [:first_name, :last_name]
    end
  end

  postgres do
    table "users"
    repo Helpdesk.Repo
    base_filter_sql "representative = true"
  end

  graphql do
    type :representative

    queries do
      get :get_representative, :read
      list :list_representatives, :read
    end
  end

  json_api do
    type "representative"

    routes do
      base "/representatives"

      get :me, route: "/me"
      get :read
      index :read
    end
  end

  policies do
    bypass always() do
      authorize_if actor_attribute_equals(:admin, true)
    end

    policy action_type(:read) do
      authorize_if actor_attribute_equals(:representative, true)
      authorize_if relates_to_actor_via([:assigned_tickets, :reporter])
    end
  end

  actions do
    read :read do
      primary? true
    end

    read :me do
      filter id: actor(:id)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :first_name, :string
    attribute :last_name, :string
    attribute :representative, :boolean
  end

  aggregates do
    count :open_ticket_count, [:assigned_tickets], filter: [not: [status: "closed"]]
  end

  calculations do
    calculate :full_name, :string, concat([:first_name, :last_name], " ")
  end

  relationships do
    has_many :assigned_tickets, Helpdesk.Tickets.Ticket do
      destination_field :representative_id
    end
  end
end
