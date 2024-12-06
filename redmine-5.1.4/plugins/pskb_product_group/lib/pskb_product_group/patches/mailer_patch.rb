module PskbProductGroup
  module Patches
    module MailerPatch

      module ClassMethods
        def deliver_product_groups_added(user, subject, message, issue)
          product_groups_added(user, subject, message, issue).deliver_later
        end
      end

      module InstanceMethods
        def product_groups_added(user, subject, message, issue_obj)
          @subject = subject
          @issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue_obj.id)
          @issue = issue_obj

          mail :to => user, :subject => subject
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
