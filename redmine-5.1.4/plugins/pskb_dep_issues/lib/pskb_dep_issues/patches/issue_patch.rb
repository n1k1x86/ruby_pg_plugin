module PskbDepIssues
  module Patches
    module IssuePatch
      def self.included(base)
        base.class_eval do
          belongs_to :pskb_dep_issues
          attribute :approved_owner

          validate :is_department_id_null, if: :tracker_23?
          
          private

          def is_department_id_null 
            if department_id.blank?
              errors.add(:department_id, "должно быть заполнено")
            end 
          end

          def tracker_23? 
            tracker_id == 1
          end
        end
      end
    end
  end
end

Issue.include PskbDepIssues::Patches::IssuePatch
