Redmine::Plugin.register :pskb_biz_domain do
  name 'Pskb Biz Domain plugin'
  author 'Moiseev Nikita'
  description 'This is a Biz Domain plugin'
  version '0.0.1'
end

require File.dirname(__FILE__) + '/lib/pskb_biz_domain'
