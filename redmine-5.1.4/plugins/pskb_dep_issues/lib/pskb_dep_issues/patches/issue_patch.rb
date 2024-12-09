module PskbDepIssues
  module Patches
    module IssuePatch
      def self.included(base)
        base.class_eval do
          belongs_to :department
          attribute :approved_owner

          validates :department_id, presence: true
        end
      end
    end
  end
end

Issue.include PskbDepIssues::Patches::IssuePatch
