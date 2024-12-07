module PskbDepIssues
end


PSKB_DEP_ISSUES_REQUIRED_FILES = [
  'pskb_dep_issues/patches/issue_patch',
  'pskb_dep_issues/patches/issue_controller_patch',
  'pskb_dep_issues/patches/mailer_patch'
]

base_url = File.dirname(__FILE__)
PSKB_DEP_ISSUES_REQUIRED_FILES.each { |file| require(base_url + '/' + file) }