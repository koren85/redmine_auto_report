# plugins/redmine_auto_report/db/migrate/002_add_customer_fields_to_versions.rb
class AddCustomerFieldsToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :customer_id, :integer
    add_column :versions, :contract_number, :string
    add_column :versions, :contract_date, :date

    add_index :versions, :customer_id
  end
end