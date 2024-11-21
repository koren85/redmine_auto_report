# plugins/redmine_auto_report/db/migrate/001_create_contract_works.rb
class CreateContractWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :contract_works do |t|
      t.references :version, null: false, index: true
      t.string :name, null: false
      t.float :planned_hours
      t.date :start_date
      t.date :due_date
      t.integer :position, null: false
      t.timestamps
    end
  end
end