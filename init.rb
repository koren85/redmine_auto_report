require 'redmine'

require_dependency 'auto_report/hooks/version_hooks'
require_dependency 'auto_report/hooks'

Redmine::Plugin.register :redmine_auto_report do
  name 'Redmine Auto Report plugin'
  author 'Your Name'
  description 'Автоматическое формирование отчетов по работам в версиях'
  version '0.0.1'

  menu :top_menu, :auto_reports,
       { controller: 'auto_reports', action: 'index' },
       caption: 'Отчеты',
       if: Proc.new { User.current.allowed_to?(:view_auto_reports, nil, global: true) }

  project_module :auto_reports do
    permission :view_auto_reports, auto_reports: [:index, :show]
    permission :manage_auto_reports, auto_reports: [:new, :create, :edit, :update, :destroy]
    permission :manage_contract_works, { contract_works: [:index, :show, :new, :create, :edit, :update, :destroy, :sort] }
  end

  settings default: {
    'telegram_bot_token' => '',
    'telegram_chat_id' => ''
  }, partial: 'settings/auto_report_settings'
end

Rails.configuration.to_prepare do
  require_dependency 'version'
  require_dependency 'issue'

  Version.send(:include, AutoReport::VersionPatch)
  Issue.send(:include, AutoReport::IssuePatch)

end
