module PskbBizDomain
end

PSKB_BIZ_DOMAIN_REQUIRED_FILES = [
  'pskb_departments_issue/init'
]

base_url = File.dirname(__FILE__)
PSKB_BIZ_DOMAIN_REQUIRED_FILES.each { |file| require(base_url + '/' + file) }