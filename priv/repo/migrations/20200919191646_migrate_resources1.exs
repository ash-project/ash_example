defmodule Helpdesk.Repo.Migrations.MigrateResources1 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up() do
    drop_if_exists(
      unique_index(:users, [:first_name, :last_name],
        name: "users_representative_name_unique_index"
      )
    )

    create(
      unique_index(:users, [:first_name, :last_name],
        name: "users_representative_name_unique_index",
        where: "representative = true"
      )
    )
  end

  def down() do
    drop_if_exists(
      unique_index(:users, [:first_name, :last_name],
        name: "users_representative_name_unique_index"
      )
    )

    create(
      unique_index(:users, [:first_name, :last_name],
        name: "users_representative_name_unique_index"
      )
    )
  end
end
