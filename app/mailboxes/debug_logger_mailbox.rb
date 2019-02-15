class DebugLoggerMailbox < ApplicationMailbox
  def process
    Rails.logger.info("Mail: #{mail}")
  end
end
