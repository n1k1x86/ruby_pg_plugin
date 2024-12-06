module PskbDepIssues
  class Hooks < Redmine::Hook::ViewListener
    def view_issues_form_details_bottom(context = {})
      context[:controller].send(:render_to_string, {
        partial: 'hooks/department_field/view_issues_form_details_bottom',
        locals: context
      })
    end

    render_on(:view_issues_show_details_bottom, :partial => 'hooks/department_field/view_issue_department')
  end
end