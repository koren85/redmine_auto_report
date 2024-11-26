module AutoReport
  module IssuesControllerPatch
    def self.included(base)
      base.class_eval do
        alias_method :old_update_from_params, :build_new_issue_from_params

        def build_new_issue_from_params
          old_update_from_params
          if @issue.fixed_version
            @available_works = @issue.fixed_version.contract_works.order(:position)
          end
        end
      end
    end
  end
end