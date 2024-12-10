module PskbDepIssues
  module Patches
    module MailerPatch

      module ClassMethods
        def deliver_department_set(user, subject, issue, comment=nil, dep_user=nil)
          department_set(user, subject, issue, comment, dep_user).deliver_later
        end

        def deliver_department_reject_issue(user, subject, issue, comment=nil, dep_user=nil)
          department_reject_issue(user, subject, issue, comment, dep_user).deliver_later
        end

        def deliver_department_approve_issue(user, subject, issue, comment=nil, dep_user=nil)
          department_approve_issue(user, subject, issue, comment, dep_user).deliver_later
        end
      end

      module InstanceMethods
        def send_mail(user, subject, issue_obj, comment, dep_user)
          @subject = subject
          @issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue_obj.id)
          @issue = issue_obj
          @comment = comment

          if !dep_user.nil?
            @dep_user = dep_user
            @dep_user_url = url_for(:controller => 'users', :action => 'show', :id => dep_user.id)
          end

          mail :to => user, :subject => subject
        end

        def department_set(user, subject, issue_obj, comment, dep_user)
          send_mail(user, subject, issue_obj, comment, dep_user)
        end

        def department_reject_issue(user, subject, issue_obj, comment, dep_user)
          send_mail(user, subject, issue_obj, comment, dep_user)
        end

        def department_approve_issue(user, subject, issue_obj, comment, dep_user)
          send_mail(user, subject, issue_obj, comment, dep_user)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
        base.class_eval do
          unloadable
        end
      end
    end
  end
end

Mailer.send(:include, PskbDepIssues::Patches::MailerPatch)
