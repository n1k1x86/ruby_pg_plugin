Redmine::Plugin.register :pskb_domain do
  name 'Pskb Domain plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  ISSUE_STATS = {
    "NEG": 2,
    "CLOSED": 3,
    "IN_WORK": 1,
    "NEW": 4
  }

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :pskb_domain, { controller: 'pskb_obj_type', action: 'index' },
    caption: 'Типы объектов PSKB'
  end

end
