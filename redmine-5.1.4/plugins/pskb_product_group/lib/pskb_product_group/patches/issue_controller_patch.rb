module PskbProductGroup
  module Patches
    module IssueControllerPatch
      def self.prepended(base)
        base.class_eval do
          before_action :find_project, only: [:approve_issue_by_pg, :reject_issue_by_pg]
          before_action :authorize, only: [:approve_issue_by_pg, :reject_issue_by_pg]

          def approve_issue_by_pg
            id = params[:issue_id]
            pgNegId = params[:pgNegId]

            @pg_owner = User.current

            @issue = Issue.find_by(id: id)
            if @issue.nil?
              render_404
            end
            
            @negObj = Negotiation.find_by(id: pgNegId)
            @negObj.state = PskbDomain::NEG_STAT[:APPROVED]
            @negObj.save

            if all_vote?
              if check_votes
                @issue.status_id = PskbDomain::ISSUE_STATS[:NEW]
                @issue.save
              end
            end

            send_mail_approve_pg

            render json: {"success": "good"}, status: 200
          end

          def reject_issue_by_pg
            @issue = Issue.find(params[:issue_id])
            @comment = params[:comment]
            @pgNegId = params[:neg_id]

            @pg_owner = User.current

            @journal = Journal.new(user_id: @pg_owner.id, journalized_id: @issue.id, journalized_type: "Issue", notes: @comment)
            @journal.save
            
            @negObj = Negotiation.find_by(id: @pgNegId)
            @negObj.state = PskbDomain::NEG_STAT[:REJECTED]
            @negObj.save

            send_mail_rejection_pg

            render json: {"success": "good"}, status: 200
          end

          private

          def all_vote?
            neg_records = Negotiation.where(iss_id: @issue.id)
            neg_records.all? {|record| record.state != PskbDomain::NEG_STAT[:IN_PROG]} and @issue.approved_owner
          end

          def check_votes
            neg_records = Negotiation.where(iss_id: @issue.id)
            neg_records.all? {|record| record.state == PskbDomain::NEG_STAT[:APPROVED]} and @issue.approved_owner
          end

          def find_project 
            @issue = Issue.find(params[:issue_id])
            @project = Project.find(@issue.project_id)
          end

          def send_mail_rejection_pg
            subject = "Согласование продуктовых групп"
            user = User.find(@issue.author_id)
            Mailer.deliver_product_groups_pg_rejected(user, subject, @comment, @issue, @pg_owner)
          end

          def send_mail_approve_pg
            subject = "Согласование продуктовых групп"
            user = User.find(@issue.author_id)
            Mailer.deliver_product_groups_pg_approved(user, subject, nil, @issue, @pg_owner)
          end
        end
      end
    end
  end
end
