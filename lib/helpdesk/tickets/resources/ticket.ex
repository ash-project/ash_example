defmodule Helpdesk.Tickets.Ticket do
  # lib/helpdesk/tickets/resources/ticket.ex
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      AshPolicyAuthorizer.Authorizer
    ],
    notifiers: [
      Ash.Notifier.PubSub
    ],
    extensions: [
      AshGraphql.Resource,
      AshJsonApi.Resource,
      AshBrowser.Resource
    ]

  pub_sub do
    prefix "ticket"
    module HelpdeskWeb.Endpoint

    publish :assign, ["assigned_to", :representative_id]
  end

  graphql do
    type :ticket

    fields [:subject, :description, :response, :status, :reporter]

    queries do
      get :get_ticket, :read
      list :list_tickets, :read
    end

    mutations do
      create :create_ticket, :create
      update :update_ticket, :update
      destroy :destroy_ticket, :destroy
    end
  end

  browser do
    alias Helpdesk.Tickets.Components.Ticket

    components do
      index :assigned, Ticket.Assigned do
        live(page: :keep)
      end
    end
  end

  json_api do
    type "ticket"

    routes do
      base "/tickets"

      get :read
      index :reported, route: "/reported"
      index :read
      post :open, route: "/open"
      patch :update
      delete :destroy
    end

    fields [:subject, :description, :response, :status, :reporter]

    includes [
      :reporter
    ]
  end

  policies do
    bypass always() do
      authorize_if actor_attribute_equals(:admin, true)
    end

    policy action_type(:read) do
      authorize_if actor_attribute_equals(:representative, true)
      authorize_if relates_to_actor_via(:reporter)
    end

    policy changing_relationship(:reporter) do
      authorize_if relating_to_actor(:reporter)
    end
  end

  actions do
    read :reported, filter: [reporter: actor(:id)]
    read :assigned, filter: [representative: actor(:id)]

    read :read do
      primary? true
    end

    create :open do
      accept [:subject, :reporter]
    end

    update :update, primary?: true

    update :assign do
      accept [:representative]
    end

    destroy :destroy
  end

  postgres do
    table "tickets"
    repo Helpdesk.Repo
  end

  validations do
    validate one_of(:status, ["new", "investigating", "closed"])
  end

  attributes do
    attribute :id, :uuid do
      primary_key? true
      default &Ecto.UUID.generate/0
    end

    attribute :subject, :string do
      allow_nil? false
      constraints min_length: 5
    end

    attribute :description, :string

    attribute :response, :string

    attribute :status, :string do
      allow_nil? false
      default "new"
    end
  end

  relationships do
    belongs_to :reporter, Helpdesk.Tickets.Customer

    belongs_to :representative, Helpdesk.Tickets.Representative
  end
end
