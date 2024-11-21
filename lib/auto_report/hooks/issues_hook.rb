module AutoReport
  module Hooks
    class IssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_form_details_bottom,
                partial: 'issues/contract_work_form'
    end
  end
end