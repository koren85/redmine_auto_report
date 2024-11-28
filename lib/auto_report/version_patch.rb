# plugins/redmine_auto_report/lib/auto_report/version_patch.rb
module AutoReport
  module VersionPatch
    def self.included(base)
      base.class_eval do
        has_many :contract_works, dependent: :destroy

        safe_attributes 'customer_id',
                      'contract_number',
                      'contract_date',
                      'total_planned_hours',
                      'work_start_date',
                      'work_end_date'

        validates :work_start_date, :work_end_date, presence: true
        validate :work_end_date_after_start_date

        after_save :update_total_planned_hours


        def update_total_planned_hours
          total = contract_works.sum(:planned_hours)
          update_column(:total_planned_hours, total)
        end

        private

        def work_end_date_after_start_date
          return unless work_start_date && work_end_date
          if work_end_date < work_start_date
            errors.add(:work_end_date, :greater_than_start_date)
          end
        end
      end
    end
  end
end