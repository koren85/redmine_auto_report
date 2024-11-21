# plugins/redmine_auto_report/db/migrate/003_add_report_fields_to_issues.rb
class AddReportFieldsToIssues < ActiveRecord::Migration[5.2]
  def change
    add_reference :issues, :contract_work, index: true
    add_column :issues, :report_period, :string
    add_column :issues, :report_hours, :float
  end
end