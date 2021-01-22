defmodule Helpdesk.Repo.Migrations.MigrateResources6 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:tickets) do
      # Attribute removal has been commented out to avoid data loss. See the migration generator documentation for more
      # If you uncomment this, be sure to also uncomment the corresponding attribute *addition* in the `down` migration
      # remove :barfoo

      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :created_at, :utc_datetime_usec, null: false, default: fragment("now()")
    end
  end

  def down do
    alter table(:tickets) do
      remove :created_at
      remove :updated_at
      # This is the `down` migration of the statement:
      #
      #     remove :barfoo
      #

      # add :barfoo, :binary_id, null: false
    end
  end
end