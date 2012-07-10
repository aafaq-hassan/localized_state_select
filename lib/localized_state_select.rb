module LocalizedStateSelect
  class << self
    # Returns array with codes and localized state names (according to <tt>I18n.locale</tt>)
    # for <tt><option></tt> tags
    def localized_states_array(country)
      I18n.translate("#{country.downcase}_states".to_sym).
        map { |key, value| [value, key.to_s.upcase] }.
        sort_by { |state| state.first.parameterize }
    end
    # Return array with codes and localized state names for array of state codes passed as argument
    # == Example
    #   priority_states_array([:AK, :AL])
    #   # => [ ['ALASKA', 'AK'], ['ALABAMA', 'AL'] ]
    def priority_states_array(country, state_codes=[])
      states = I18n.translate("#{country.downcase}_states".to_sym)
      state_codes.map { |code| [states[code.to_s.upcase.to_sym], code.to_s.upcase] }
    end
  end
end

module ActionView::Helpers::FormOptionsHelper
  
  # Return select and option tags for the given object and method, using state_options_for_select to generate the list of option tags.
  def localized_state_select(object, method, country='US', options = {}, html_options = {})
    ActionView::Helpers::InstanceTag.new(object, method, self, options.delete(:object)).to_state_select_tag(country, options, html_options)
  end
  
  # Returns a string of option tags for states in a country. Supply a state name as +selected+ to
  # have it marked as the selected option tag. 
  #
  # NOTE: Only the option tags are returned, you have to wrap this call in a regular HTML select tag.
  
  def state_options_for_select(selected = nil, country = 'US')
    state_options = "".html_safe
    if country
      #state_options += options_for_select(eval(country.upcase+'_STATES'), selected)
      state_options += options_for_select(
        LocalizedStateSelect::localized_states_array(country), selected)
    end
    return state_options
  end
  
  private

  class ActionView::Helpers::InstanceTag
  
  
    def to_state_select_tag(country, options, html_options)
      html_options = html_options.stringify_keys
      add_default_name_and_id(html_options)
      value = value(object)
      selected_value = options.has_key?(:selected) ? options[:selected] : value
      content_tag("select", add_options(state_options_for_select(selected_value, country), options, value), html_options)
    end
  end


  class ActionView::Helpers::FormBuilder
    def localized_state_select(method, country = 'US', options = {}, html_options = {})
      @template.localized_state_select(@object_name, method, country, options.merge(:object => @object), html_options)
    end
  end 
end
