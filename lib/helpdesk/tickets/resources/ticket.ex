defmodule Helpdesk.Tickets.Ticket do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      # AshPolicyAuthorizer.Authorizer
    ],
    notifiers: [
      Ash.Notifier.PubSub
    ],
    extensions: [
      AshGraphql.Resource,
      AshJsonApi.Resource
    ]

  pub_sub do
    # A prefix for all messages
    prefix "ticket"
    # The module to call `broadcast/3` on
    module HelpdeskWeb.Endpoint

    # When a ticket is assigned, publish ticket:assigned_to:<representative_id>
    publish :assign, ["assigned_to", :representative_id]
    publish_all(:update, ["updated", :representative_id])
    publish_all(:update, ["updated", :reporter_id])
  end

  graphql do
    type :ticket

    queries do
      get :get_ticket, :read
      list :list_tickets, :read
    end

    mutations do
      create :open_ticket, :open
      update :update_ticket, :update
      destroy :destroy_ticket, :destroy
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

    includes [
      :reporter
    ]
  end

  # policies do
  #   bypass always() do
  #     authorize_if actor_attribute_equals(:admin, true)
  #   end

  #   policy action_type(:read) do
  #     authorize_if actor_attribute_equals(:representative, true)
  #     authorize_if relates_to_actor_via(:reporter)
  #   end

  #   policy changing_relationship(:reporter) do
  #     authorize_if relating_to_actor(:reporter)
  #   end
  # end

  actions do
    read :reported do
      filter reporter: actor(:id)

      pagination offset?: true, countable: true, required?: false
    end

    read :assigned do
      filter representative: actor(:id)
      pagination offset?: true, countable: true, required?: false
    end

    read :read do
      primary? true
      pagination offset?: true, required?: false
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

    attribute :status, :atom do
      allow_nil? false
      default "new"
      constraints one_of: [:new, :investigating, :closed]
    end
  end

  relationships do
    belongs_to :reporter, Helpdesk.Tickets.Customer

    belongs_to :representative, Helpdesk.Tickets.Representative
  end
end
