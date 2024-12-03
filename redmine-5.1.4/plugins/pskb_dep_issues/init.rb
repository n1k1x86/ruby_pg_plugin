Redmine::Plugin.register :pskb_dep_issues do
  name 'Pskb Dep Issues plugin'
  author 'Moiseev Nikita'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end

require File.dirname(__FILE__) + '/lib/pskb_dep_issues'
