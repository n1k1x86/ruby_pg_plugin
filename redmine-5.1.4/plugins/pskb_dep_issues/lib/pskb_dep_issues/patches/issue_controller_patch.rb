module PskbDepIssues
  module Patches
    module IssueControllerPatch
      def self.included(base)
        base.class_eval do
          before_action :save_dep_id, only: [:create, :update]

          private

          def save_dep_id
            @issue.department_id = params[:issue][:department_id]
          end
        end
      end
    end
  end
end


IssuesController.send(:include, PskbDepIssues::Patches::IssueControllerPatch)
