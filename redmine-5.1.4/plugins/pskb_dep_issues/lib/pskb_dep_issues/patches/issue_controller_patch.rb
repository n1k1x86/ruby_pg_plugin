module PskbDepIssues
  module Patches
    module IssueControllerPatch
      def self.prepended(base)
        base.class_eval do
          before_action :save_dep_id, only: [:create, :update]
          skip_before_action :authorize, only: [:approve_issue, :reject_issue]
          after_action :send_mail_to_dep_owner, only: [:create, :update]

          def approve_issue
            @issue = Issue.find(params[:id])
            @project = Project.find(@issue.project_id)

            if User.current.allowed_to?(:approve_issue_perm, @project)
              Rails.logger.info "Permission check passed"
              redirect_to @issue
            else
              Rails.logger.info "Permission check failed"
              render plain: "Доступ запрещен", status: :forbidden
            end
          end

          def reject_issue
            @issue = Issue.find(params[:id])
            @project = Project.find(@issue.project_id)

            if User.current.allowed_to?(:approve_issue_perm, @project)
              Rails.logger.info "Permission check passed"
              redirect_to @issue
            else
              Rails.logger.info "Permission check failed"
              render plain: "Доступ запрещен", status: :forbidden
            end
          end

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


IssuesController.send(:prepend, PskbDepIssues::Patches::IssueControllerPatch)
