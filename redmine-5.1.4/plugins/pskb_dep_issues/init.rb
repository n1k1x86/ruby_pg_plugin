
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
end

require File.dirname(__FILE__) + '/lib/pskb_dep_issues'
require File.dirname(__FILE__) + '/lib/pskb_dep_issues/hooks'
