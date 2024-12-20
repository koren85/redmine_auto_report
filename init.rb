require 'redmine'

Rails.application.config.eager_load_paths += Dir["#{File.dirname(__FILE__)}/app/models"]

require_dependency 'auto_report'
# require_dependency 'report'
 require_dependency 'version'
# require_dependency 'shared_hours'
require_dependency 'auto_report/hooks/version_hooks'
require_dependency 'auto_report/hooks/issues_hook'
require_dependency 'auto_report/hooks'

require_dependency 'auto_report/patches'

Redmine::Plugin.register :redmine_auto_report do
  name 'Redmine Auto Report. plugin'
  author 'Your Name'
  description 'Автоматическое формирование отчетов по работам в версиях'
  version '0.0.1'

  menu :top_menu, :reports,
       { controller: 'reports', action: 'index' },
       caption: 'Отчеты',
       if: Proc.new { User.current.allowed_to?(:view_auto_reports, nil, global: true) }

  project_module :auto_reports do
    permission :view_auto_reports, reports: [:index, :show]
    permission :manage_auto_reports, reports: [:new, :create, :edit, :update, :destroy]
    permission :manage_contract_works, { contract_works: [:index, :show, :new, :create, :edit, :update, :destroy, :sort] }
  end

  settings default: {
    'telegram_bot_token' => '',
    'telegram_chat_id' => ''
  }, partial: 'settings/auto_report_settings'
end

Rails.configuration.to_prepare do
  require_dependency 'version'
  require_dependency 'journal_detail'
  require_dependency 'issue'
  require_dependency 'issues_controller'

  Version.send(:include, AutoReport::VersionPatch)
  JournalDetail.send(:include, AutoReport::JournalDetailPatch)
  Issue.send(:include, AutoReport::IssuePatch)
  IssuesController.send(:include, AutoReport::IssuesControllerPatch)
end
