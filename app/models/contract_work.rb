# plugins/redmine_auto_report/app/models/contract_work.rb
class ContractWork < ActiveRecord::Base
  belongs_to :version
  has_many :issues
  has_one :contract_work_merge
  has_one :merged_hours, through: :contract_work_merge

  validates :name, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
  validate :hours_validation

  before_validation :set_position

  def effective_hours
    merged_hours&.hours || planned_hours
  end

  private

  def hours_validation
    return true if planned_hours.present? || group_hours.present?
    errors.add(:base, :requires_hours)
  end

  def set_position
    if position.nil?
      max_position = version.contract_works.maximum(:position) || 0
      self.position = max_position + 1
    end
  end
end