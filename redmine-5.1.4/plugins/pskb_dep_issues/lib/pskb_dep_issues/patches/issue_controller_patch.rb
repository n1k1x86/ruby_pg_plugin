module PskbDepIssues
  module Patches
    module IssueControllerPatch
      def self.prepended(base)
        base.class_eval do
          before_action :save_dep_id, only: [:create, :update]
          before_action :find_project, only: [:approve_issue, :reject_issue]
          before_action :authorize, only: [:approve_issue, :reject_issue]

          after_action :send_mail_to_dep_owner, only: [:create, :update]
          after_action :send_mail_rejection, only: [:reject_issue]

          def approve_issue
            @issue = Issue.find(params[:id])
            @dep_user = User.current
            if all_pg_voices_true?
              @issue.status_id = ISSUE_NEW_STAT
            end
            @issue.approved_owner = true
            @issue.save 
            send_mail_approve
            redirect_to @issue
          end

          def reject_issue
            @issue = Issue.find(params[:id])
            @comment = params[:comment]
            @dep_user = User.current

            @journal = Journal.new(user_id: @dep_user.id, journalized_id: @issue.id, journalized_type: "Issue", notes: @comment)
            @journal.save
            
            reject_reason = "Отказ от реализации"
            @reject_realize = Journal.new(user_id: @dep_user.id, journalized_id: @issue.id, journalized_type: "Issue", notes: reject_reason)
            @reject_realize.save

            @issue.approved_owner = false
            @issue.status_id = ISSUE_CLOSED_STAT
            @issue.save
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
            if !@issue.errors.any? && @issue.tracker_id == 1
              subject = "Подразделения"
              user = User.find(PskbDepIssue.find(@issue.department_id).user_id)
              Mailer.deliver_department_set(user, subject, @issue)
            end
          end

          def send_mail_rejection
            subject = "Подразделения"
            user = User.find(@issue.author_id)
            Mailer.deliver_department_reject_issue(user, subject, @issue, @comment, @dep_user)
          end

          def send_mail_approve 
            subject = "Подразделения"
            user = User.find(@issue.author_id)
            Mailer.deliver_department_approve_issue(user, subject, @issue, nil, @dep_user)
          end

          def all_pg_voices_true?
            neg_records = Negotiation.where(iss_id: @issue.id)
            if neg_records.length != 0
              neg_records.all? {|record| record.state == PskbDomain::NEG_STAT[:APPROVED]}
            end
            false
          end
        end
      end
    end
  end
end


IssuesController.send(:prepend, PskbDepIssues::Patches::IssueControllerPatch)
