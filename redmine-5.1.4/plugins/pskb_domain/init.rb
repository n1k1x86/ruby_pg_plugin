require File.dirname(__FILE__) + '/constants'

Redmine::Plugin.register :pskb_domain do
  name 'Pskb Domain plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :pskb_obj_type, { controller: 'pskb_obj_type', action: 'index' },
    caption: 'Типы объектов PSKB',
    html: { class: 'icon icon-projects projects' }

    menu.push :pskb_negotiation_stat, { controller: 'pskb_negotiation_stat', action: 'index' },
    caption: 'Статусы согласований',
    html: { class: 'icon icon-issue-edit issue-statuses' }
  end
end
