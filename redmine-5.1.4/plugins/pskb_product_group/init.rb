require 'redmine'
require File.dirname(__FILE__) + '/../pskb_domain/constants'

Redmine::Plugin.register :pskb_product_group do
  name 'Pskb Product Group plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  class ViewHookListner < Redmine::Hook::ViewListener

    def view_issues_show_details_bottom(context = {})
      @issue = context[:issue]
      if @issue.tracker_id == 1
        @issues = Issue.all
        @pskb_product_groups = PskbProductGroups.all
        @product_groups = PskbProductGroupsIssue.where("issue_id = ?", @issue.id)
        pg_percentage_table = []
        for el in @product_groups do
          pg = PskbProductGroups.find_by(id: el.pskb_product_groups_id)
          neg_obj = Negotiation.where(iss_id: @issue.id, value: pg.id)[0]

          if pg.nil? || neg_obj.nil?
            next
          end
          owner = User.find(pg.owner_id)
          pg_percentage_table << [pg.name, pg.id, el.percentage, owner.name, el.id, neg_obj, @issue.id, neg_obj.id]
          puts "INIT RB AFTER"
          p pg_percentage_table
        end
        context[:controller].render_to_string(partial: 'pskb_product_groups/extra_issue_info', locals: { product_groups: pg_percentage_table, issues: @issues, pskb_product_groups: @pskb_product_groups, issue_id: @issue.id })
      end
    end

    def pg_empty_notify(context = {})
      @issue = context[:issue]
      if @issue.tracker_id == 1
        @product_groups = PskbProductGroupsIssue.where("issue_id = ?", @issue.id)
        if @product_groups.length == 0
          context[:controller].render_to_string(partial: 'pskb_product_groups/pg_empty_notify')
        end
      end
    end
  end

  unless Mailer.included_modules.include?(PskbProductGroup::Patches::MailerPatch)
    Mailer.send(:include, PskbProductGroup::Patches::MailerPatch)
  end

  IssuesController.send(:prepend, PskbProductGroup::Patches::IssueControllerPatch)

  unless Issue.included_modules.include?(PskbProductGroup::Patches::IssuePatch)
    Issue.send(:include, PskbProductGroup::Patches::IssuePatch)
  end

  project_module :pskb_product_group do
    permission :approve_issue_by_pg_perm, { issues: [:approve_issue_by_pg, :reject_issue_by_pg] }, require: :loggedin
  end
end
