Redmine::Plugin.register :pskb_dep_issues do
  name 'Pskb Dep Issues plugin'
  author 'Moiseev Nikita'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  
  project_module :dep_issues do
    permission :approve_issue_perm, { issues: [:approve_issue, :reject_issue] }, require: :loggedin
  end

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :pskb_dep_issues, { controller: 'pskb_dep_issues', action: 'index' },
    caption: 'Подразделения' 
  end

  ISSUES_NEGOTIATION_STAT = 2 # id статуса 'согласования' из issues_status
  ISSUE_CLOSED_STAT = 3 # id статуса 'закрыто' из issues_status
  ISSUE_IN_WORK_STAT = 1 # id статуса 'в работе' из issues_status
  ISSUE_NEW_STAT = 4 # id статуса 'новая' из issues_status
end

require File.dirname(__FILE__) + '/lib/pskb_dep_issues'
require File.dirname(__FILE__) + '/lib/pskb_dep_issues/hooks'
