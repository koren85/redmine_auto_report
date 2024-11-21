# plugins/redmine_auto_report/app/models/contract_work.rb
class ContractWork < ActiveRecord::Base
  belongs_to :version
  has_many :issues

  validates :name, presence: true
  validates :planned_hours, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :position, presence: true, numericality: { only_integer: true }

  before_validation :set_position

  private

  def set_position
    if position.nil?
      max_position = version.contract_works.maximum(:position) || 0
      self.position = max_position + 1
    end
  end
end