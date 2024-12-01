# plugins/redmine_auto_report/app/models/merged_hours.rb
class MergedHours < ActiveRecord::Base
  belongs_to :version
  has_many :contract_work_merges, dependent: :destroy
  has_many :contract_works, through: :contract_work_merges

  validates :hours, presence: true, numericality: { greater_than_or_equal_to: 0 }
end