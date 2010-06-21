module BrowserHelper
  
  def application_url
    User.find(:first).email == "test@rutanet.com" ? "stagingrutanet.heroku.com" : "rutanet.com"
  end
  
  def error_messages(code)
    return case code
      when '401' then 'wronglogin'
      when '403' then 'restrictedaccess'
      else 'failedconnection' 
    end
  end
  
  def verbose_error_message(msg)
    return 'Tus datos de acceso son inv&aacute;lidos' if msg == 'wronglogin'
    return 'No tienes permitida esta acci&oacute;n en Rutanet' if msg == 'restrictedaccess'
    return 'Se agregaron cargas al listado' if msg == 'freightsloaded'
    return 'La conecci&oacute;n con Rutanet ha fallado'
  end
  
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
  
  def truncate(string,length)
    return string if string.length < length
    return "#{string[0,length]}..."
  end
end