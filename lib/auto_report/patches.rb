# plugins/redmine_auto_report/lib/auto_report/patches.rb
module AutoReport
  module IssuePatch
    def self.included(base)
      base.class_eval do
        belongs_to :contract_work
        safe_attributes 'contract_work_id', 'report_period', 'report_hours'

        after_save :update_version_hours

        def contract_work_id=(val)
          attribute_will_change!('contract_work_id') if contract_work_id != val
          write_attribute(:contract_work_id, val)
        end

        private

        def update_version_hours
          if contract_work && contract_work.version
            contract_work.version.update_total_planned_hours
          end
        end
      end
    end
  end

  module JournalDetailPatch
    def self.included(base)
      base.class_eval do
        def value
          if property == 'attr' && prop_key == 'contract_work_id' && !value_was.blank?
            work = ContractWork.find_by(id: value_was)
            work ? work.name : value_was
          else
            value_was
          end
        end

        def old_value
          if property == 'attr' && prop_key == 'contract_work_id' && !old_value_was.blank?
            work = ContractWork.find_by(id: old_value_was)
            work ? work.name : old_value_was
          else
            old_value_was
          end
        end
      end
    end
  end
end