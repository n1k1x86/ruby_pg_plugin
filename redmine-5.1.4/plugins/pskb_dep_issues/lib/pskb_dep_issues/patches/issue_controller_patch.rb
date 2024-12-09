module PskbDepIssues
  module Patches
    module IssueControllerPatch
      def self.prepended(base)
        base.class_eval do
          before_action :save_dep_id, only: [:create, :update]
          before_action :find_project, only: [:approve_issue, :reject_issue]
          before_action :authorize, only: [:approve_issue, :reject_issue]
          after_action :send_mail_to_dep_owner, only: [:create, :update]

          def approve_issue
            @issue = Issue.find(params[:id])
            @issue.approved_owner = true
            @issue.save 
            redirect_to @issue
          end

          def reject_issue
            # @issue = Issue.find(params[:id])
            # @issue.approved_owner = false
            # @issue.save
            render json: {"success": "good"}, status: 200
          end

          private

          def find_project 
            @issue = Issue.find(params[:id])
            @project = Project.find(@issue.project_id)
          end

          def save_dep_id
            @issue.department_id = params[:issue][:department_id]
          end

          def send_mail_to_dep_owner
            if !@issue.errors.any?
              Mailer.deliver_department_set(User.find(PskbDepIssue.find_by(dep_id: @issue.department_id).user_id), "Подразделения", @issue)
            end
          end
        end
      end
    end
  end
end


IssuesController.send(:prepend, PskbDepIssues::Patches::IssueControllerPatch)
