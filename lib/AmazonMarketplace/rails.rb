require 'AmazonMarketplace'
require 'AmazonMarketplace/helpers/rails_helper'
require 'AmazonMarketplace/helpers/notification_helper'

# Inject helper into Rails ActionView.
ActionView::Base.__send__(:include, AmazonMarketplace::Helpers::RailsHelper)

# Inject notification helper into ActionController
ActionController::Base.__send__(:include, AmazonMarketplace::Helpers::NotificationHelper)