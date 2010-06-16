require 'rho'
require 'rho/rhocontroller'
require 'rho/rhoerror'
require 'helpers/browser_helper'
require 'application'

class SettingsController < Rho::RhoController
  include BrowserHelper
  
  def index
    @msg = @params['msg']
    render
  end

  def login
    @msg = @params['message']
    if User.find(:first)
      WebView.navigate url_for(:controller => :Freight, :action => :search)
    else
      render :action => :login, :back => '/app'
    end
  end

  def login_callback
    errCode = @params['error_code'].to_i
    if errCode == 0
      current_user = User.find(:first) || User.new
      current_user.cookie = @params["cookies"]
      current_user.id = @params["body"]["id"]
      current_user.save
      NativeBar.create(AppApplication::TOOLBAR_TYPE, AppApplication::TABS)
      WebView.navigate (url_for(:controller => :Freight, :action => :search))
    else
      error_message = error_messages(@params['http_error'])
      WebView.navigate ( url_for :action => :login, :query => {:message => error_message} )
    end  
  end

  def do_login
    if @params['login'] and @params['password']
      Rho::AsyncHttp.post(
        :url => 'http://rutanet.local/signin/signin.json',
        :body => "email=#{@params['login']}&password=#{@params['password']}",
        :callback => '/app/Settings/login_callback')
      render :action => :wait
    else
      @msg = 'wronglogin'
      render :action => :login
    end
  end
  
  def logout
    current_user = User.find(:first)
    current_user.destroy unless current_user.nil?
    @msg = false
    NativeBar.remove
    WebView.navigate url_for(:controller => :Settings, :action => :login)
  end
  
  def reset
    render :action => :reset
  end
  
  def do_reset
    Rhom::Rhom.database_full_reset
    SyncEngine.dosync
    @msg = "Database has been reset."
    redirect :action => :index, :query => {:msg => @msg}
  end
  
  def do_sync
    SyncEngine.dosync
    @msg =  "Sync has been triggered."
    redirect :action => :index, :query => {:msg => @msg}
  end
end
