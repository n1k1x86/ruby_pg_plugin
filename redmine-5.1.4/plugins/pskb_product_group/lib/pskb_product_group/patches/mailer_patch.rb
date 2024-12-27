module PskbProductGroup
  module Patches
    module MailerPatch

      module ClassMethods
        def deliver_product_groups_added(user, subject, message, issue)
          product_groups_added(user, subject, message, issue).deliver_later
        end

        def deliver_product_groups_pg_approved(user, subject, message, issue, pg_owner)
          product_groups_pg_approved(user, subject, message, issue, pg_owner).deliver_later
        end

        def deliver_product_groups_pg_rejected(user, subject, message, issue, pg_owner)
          product_groups_pg_rejected(user, subject, message, issue, pg_owner).deliver_later
        end
      end

      module InstanceMethods
        def product_groups_added(user, subject, message, issue_obj)
          @subject = subject
          @issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue_obj.id)
          @issue = issue_obj

          mail :to => user, :subject => subject
        end

        def product_groups_pg_approved(user, subject, message, issue_obj, pg_owner)
          @subject = subject
          @issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue_obj.id)
          @issue = issue_obj
          
          if !pg_owner.nil?
            @pg_owner = pg_owner
            @pg_owner_url = url_for(:controller => 'users', :action => 'show', :id => pg_owner.id)
          end

          mail :to => user, :subject => subject
        end

        def product_groups_pg_rejected(user, subject, message, issue_obj, pg_owner)
          @subject = subject
          @issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue_obj.id)
          @issue = issue_obj
          @comment = comment

          if !pg_owner.nil?
            @pg_owner = pg_owner
            @pg_owner_url = url_for(:controller => 'users', :action => 'show', :id => pg_owner.id)
          end

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
