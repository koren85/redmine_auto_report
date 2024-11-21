module AutoReport
  module IssuePatch
    def self.included(base)
      base.class_eval do
        belongs_to :contract_work

        # Добавляем поля для отчетных периодов
        safe_attributes 'contract_work_id', 'report_period', 'report_hours'
        after_save :update_version_hours
        def update_version_hours
          if contract_work && contract_work.version
            contract_work.version.update_total_planned_hours
          end
        end
      end
    end
  end
end