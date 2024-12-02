module PskbProductGroup
  module Patches
    module MailerPatch
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def send_msg_to_pg_owners(user, subject, message)
          Rails.logger.info("user mail")
          Rails.logger.info(user)
          Rails.logger.info('subject mail')
          Rails.logger.info(subject)
          Rails.logger.info('message mail')
          Rails.logger.info(message)
          
          mail(
            to: user.mail,
            subject: subject,
            body: message,
            content_type: "text/plain"
          )
        end
      end
    end
  end
end
