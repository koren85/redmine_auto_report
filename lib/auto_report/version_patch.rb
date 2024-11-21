module AutoReport
  module VersionPatch
    def self.included(base)
      base.class_eval do
        has_many :contract_works, dependent: :destroy

        safe_attributes 'customer_id',
                        'contract_number',
                        'contract_date',
                        'total_planned_hours'

        after_save :update_total_planned_hours

        def update_total_planned_hours
          total = contract_works.sum(:planned_hours)
          update_column(:total_planned_hours, total)
        end
      end
    end
  end
end