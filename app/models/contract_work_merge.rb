# plugins/redmine_auto_report/app/models/contract_work_merge.rb
class ContractWorkMerge < ActiveRecord::Base
  belongs_to :merged_hours
  belongs_to :contract_work
end