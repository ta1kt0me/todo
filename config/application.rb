require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AwsSNSAuthenticationExt
  private

  def authenticate
    # workaround request.bodyを実行するとデータが再取得できなくなるためraw_postでキャッシュする
    @post_data = request.raw_post
    super
  end
end

module TodoTest
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.to_prepare {
      # https://github.com/rails/rails/issues/35243
      ActionMailbox::Ingresses::Amazon::InboundEmailsController.prepare
      ActionMailbox::Ingresses::Amazon::InboundEmailsController.prepend(AwsSNSAuthenticationExt)
      ActionMailbox::Ingresses::Amazon::InboundEmailsController.class_eval {
        before_action :confirm_subscription
        before_action :set_params_to_content

        private

        def confirm_subscription
          post_data = JSON.parse(@post_data)

          return unless post_data["Type"] == "SubscriptionConfirmation"

          confirm_subscribe_url(post_data["SubscribeURL"])

          render json: { message: "Success!" }, status: :ok
        end

        def set_params_to_content
          message = JSON.parse(@post_data)["Message"]
          content = JSON.parse(message).slice("content")
          params.merge!(content)
        end

        def confirm_subscribe_url(url)
          uri = URI.parse(url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          response = http.get(uri.request_uri)
          raise "Request to SubscriptionConfirmation failed (code: #{response.code})" unless response.code.to_i == 200
        end
      }
    }
  end
end
