module AppreciationsBillboard
  def self.slack_notifier
    @slack_notifier ||= Slack::Notifier.new(APP_CONFIG[:slack_notifier]["webhook_url"])
  end
end
