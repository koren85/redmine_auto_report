module AutoReport
  module Hooks
    class VersionHooks < Redmine::Hook::ViewListener
      render_on :view_versions_show_bottom,
                partial: 'versions/contract_works_list'

      render_on :view_versions_show_contextual,
                partial: 'versions/contract_works_actions'

      render_on :view_versions_show_bottom,
                partial: 'versions/work_dates_show'
    end
  end
end