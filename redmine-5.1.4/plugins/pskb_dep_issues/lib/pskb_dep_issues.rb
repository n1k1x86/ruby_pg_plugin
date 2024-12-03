module PskbDepIssues
end


PSKB_DEP_ISSUES_REQUIRED_FILES = [
  
]

base_url = File.dirname(__FILE__)
PSKB_DEP_ISSUES_REQUIRED_FILES.each { |file| require(base_url + '/' + file) }