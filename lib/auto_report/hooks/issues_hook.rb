module AutoReport
  module Hooks
    class IssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_form_details_bottom,
                partial: 'issues/contract_work_form'

      render_on :view_issues_show_details_bottom,
                partial: 'issues/show_contract_work'

      def view_issues_bulk_edit_details_bottom(context = {})
        template = context[:controller].send(:render_to_string, {
          partial: 'issues/bulk_edit_contract_work',
          locals: {
            issues: context[:issues],
            available_works: available_works(context[:issues])
          }
        })
        return template
      end
      private
      def available_works(issues)
        version_ids = issues.map(&:fixed_version_id).compact.uniq
        return [] if version_ids.empty?
        ContractWork.where(version_id: version_ids).order(:position)
      end
    end
  end
end