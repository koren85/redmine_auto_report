# plugins/redmine_auto_report/db/migrate/006_add_work_dates_to_versions.rb
class AddWorkDatesToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :work_start_date, :date
    add_column :versions, :work_end_date, :date
  end
end