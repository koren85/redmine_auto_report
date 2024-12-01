module AutoReport
  module VersionPatch
    def self.included(base)
      base.class_eval do
        has_many :contract_works, dependent: :destroy
        has_many :merged_hours, class_name: 'MergedHours', dependent: :destroy


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
          individual_hours = contract_works.where.not(planned_hours: nil).sum(:planned_hours)
          merged_hours_sum = merged_hours.sum(:hours)
          update_column(:total_planned_hours, individual_hours + merged_hours_sum)
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