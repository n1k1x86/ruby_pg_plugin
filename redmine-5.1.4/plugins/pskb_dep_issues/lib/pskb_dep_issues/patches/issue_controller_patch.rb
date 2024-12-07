module PskbDepIssues
  module Patches
    module IssueControllerPatch
      def self.included(base)
        base.class_eval do
          before_action :save_dep_id, only: [:create, :update]
          after_action :send_mail_to_dep_owner, only: [:create, :update]

          private

          def save_dep_id
            @issue.department_id = params[:issue][:department_id]
          end

          def send_mail_to_dep_owner
            Mailer.deliver_department_set(User.find(PskbDepIssue.find_by(dep_id: @issue.department_id).user_id), "Подразделения", @issue)
          end
        end
      end
    end
  end
end


IssuesController.send(:include, PskbDepIssues::Patches::IssueControllerPatch)
