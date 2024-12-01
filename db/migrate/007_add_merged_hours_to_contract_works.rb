# plugins/redmine_auto_report/db/migrate/007_add_merged_hours_to_contract_works.rb
class AddMergedHoursToContractWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :merged_hours do |t|
      t.references :version, null: false
      t.decimal :hours, precision: 10, scale: 2
      t.timestamps
    end

    create_table :contract_work_merges do |t|
      t.references :merged_hours
      t.references :contract_work
    end
  end
end