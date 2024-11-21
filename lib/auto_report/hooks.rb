# plugins/redmine_auto_report/lib/auto_report/hooks.rb
module AutoReport
  module Hooks
    class ViewListener < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        stylesheet = stylesheet_link_tag('auto_report', plugin: 'redmine_auto_report')
        javascript = javascript_include_tag('auto_report', plugin: 'redmine_auto_report')
        "#{stylesheet}\n#{javascript}"
      end
    end

    class VersionHooks < Redmine::Hook::ViewListener
      def view_versions_show_bottom(context = {})
        context[:controller].send(:render_to_string, {
          partial: 'versions/contract_works_list',
          locals: {
            version: context[:version],
            project: context[:project]
          }
        })
      end

      def view_versions_show_contextual(context = {})
        context[:controller].send(:render_to_string, {
          partial: 'versions/contract_works_actions',
          locals: {
            version: context[:version],
            project: context[:project]
          }
        })
      end
    end
  end
end