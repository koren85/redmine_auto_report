# plugins/redmine_auto_report/app/models/report.rb
class Report < ActiveRecord::Base
  self.table_name = 'auto_reports'

  belongs_to :version
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  validates :number, presence: true, uniqueness: true
  validates :name, presence: true
  validates :version, presence: true
  validates :period_type, presence: true, inclusion: { in: %w(month quarter custom) }
  validates :period_start, presence: true
  validates :period_end, presence: true
  validates :status, presence: true, inclusion: { in: %w(draft pending approved rejected) }
  validate :period_end_after_start
  validate :period_within_version_dates

  before_validation :set_number, on: :create
  before_validation :set_name, if: :version_id_changed?
  before_save :calculate_total_hours

  scope :newest_first, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) if status.present? }

  private

  def set_number
    self.number = (self.class.maximum(:number) || 0) + 1
  end

  def set_name
    return unless version
    self.name = "#{version.project.name} - #{version.name} (#{period_start.strftime('%m.%Y')})"
  end

  # def calculate_total_hours
  #   self.total_hours = version.contract_works.sum(:planned_hours) if version
  # end

  def calculate_total_hours
    if version
      self.total_hours = version.total_planned_hours || 0
    end
  end

  def period_end_after_start
    return unless period_start && period_end
    if period_end < period_start
      errors.add(:period_end, :greater_than_start)
    end
  end

  def period_within_version_dates
    return unless version && period_start && period_end
    if version.effective_date && (period_start < version.effective_date || period_end > version.due_date)
      errors.add(:base, :period_outside_version_dates)
    end
  end

  def period_type_name
    I18n.t("auto_report_period_type_#{period_type}")
  end

  def status_name
    I18n.t("auto_report_status_#{status}")
  end

  def editable?
    status == 'draft'
  end

  def approvable?
    status == 'pending'
  end

  def rejectable?
    status == 'pending'
  end

  def approve!
    return false unless approvable?
    update(status: 'approved')
  end

  def reject!(reason)
    return false unless rejectable?
    update(status: 'rejected', rejection_reason: reason)
  end
end