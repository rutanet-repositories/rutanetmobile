module BrowserHelper
  
  def format_city(str)
    city, state = str.split(',')
    city.capitalize!
    state.upcase!
    "#{city}, #{state}"
  end
  
  def format_date(str)
    year, month, day = str.split('/')
    "#{day}/#{month}/#{year}"
  end

  def placeholder(label=nil)
    "placeholder='#{label}'" if platform == 'apple'
  end

  def platform
    System::get_property('platform').downcase
  end

  def selected(option_value,object_value)
    "selected=\"yes\"" if option_value == object_value
  end

  def checked(option_value,object_value)
    "checked=\"yes\"" if option_value == object_value
  end
end