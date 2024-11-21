# plugins/redmine_auto_report/db/migrate/004_add_total_planned_hours_to_versions.rb
class AddTotalPlannedHoursToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :total_planned_hours, :float

    # Обновляем существующие версии
    Version.reset_column_information
    Version.find_each do |version|
      total = version.contract_works.sum(:planned_hours)
      version.update_column(:total_planned_hours, total)
    end
  end
end