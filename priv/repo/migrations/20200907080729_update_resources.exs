defmodule Helpdesk.Repo.Migrations.UpdateResources do
  use Ecto.Migration

  def up() do
    create table("users", primary_key: false) do
      add(:admin, :boolean, null: false, default: false, primary_key: false)
      add(:first_name, :string, null: true, default: nil, primary_key: false)
      add(:id, :binary_id, null: true, default: nil, primary_key: true)
      add(:last_name, :string, null: true, default: nil, primary_key: false)
      add(:representative, :boolean, null: false, default: false, primary_key: false)
    end

    create table("tickets", primary_key: false) do
      add(:description, :string, null: true, default: nil, primary_key: false)
      add(:id, :binary_id, null: true, default: nil, primary_key: true)
      add(:reporter_id, :binary_id, null: true, default: nil, primary_key: false)
      add(:representative_id, :binary_id, null: true, default: nil, primary_key: false)
      add(:response, :string, null: true, default: nil, primary_key: false)
      add(:status, :string, null: false, default: "new", primary_key: false)
      add(:subject, :string, null: false, default: nil, primary_key: false)
    end

    alter table("tickets") do
      modify(:reporter_id, references("users", type: :binary_id, column: :id),
        default: nil,
        primary_key: false
      )
    end

    alter table("tickets") do
      modify(:representative_id, references("users", type: :binary_id, column: :id),
        default: nil,
        primary_key: false
      )
    end
  end

  def down() do
    alter table("tickets") do
      modify(:representative_id, :binary_id, null: true, default: nil, primary_key: false)
    end

    alter table("tickets") do
      modify(:reporter_id, :binary_id, null: true, default: nil, primary_key: false)
    end

    drop(table("tickets"))

    drop(table("users"))
  end
end
