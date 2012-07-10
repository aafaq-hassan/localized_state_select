# Include hook code here
require "localized_state_select"

# Load locales for states from +locale+ directory into Rails
I18n.load_path += Dir[ File.join(File.dirname(__FILE__), 'locale', '*.{rb,yml}') ]
