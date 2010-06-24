require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'date'

class FreightController < Rho::RhoController
  include BrowserHelper

  #GET /Freight
  def index
    @msg = @params['message'] || ''
    @no_more_freights = (@params["no_more_freights"] == "true")
    @search = Search.find(:first)
    @freights = Freight.find(:all).sort_by{|f| f.object.gsub(/[{}]/,"") }.reverse
    render
  end

  # GET /Freight/{1}
  def show
    puts 'entrando a show'
    @freight = Freight.find(@params['id'])
    if @freight
      render :action => :show
    else
      redirect :action => :index
    end
  end

  def search
    render
  end
  
  def do_search
    do_not_destroy = ""
    if (Search.find(:first) and @params["search"])
      search = Search.find(:first)
      search.update_attributes(@params["search"])
    elsif(@params["search"])
      search = Search.new(@params["search"])
      search.save
    else
      search = Search.find(:first)
      search.page = 1
      if @params["page"]
        search.page = @params["page"] 
        search.save
        do_not_destroy = "?do_not_destroy=true&msg=freightsloaded"
      end
    end
    Rho::AsyncHttp.post(
      :url => "http://#{application_url}/search_freights.json",
      :body => "search_freight[origin]=#{search.origin}&search_freight[destination]=#{search.destination}&search_freight[finish]=#{search.finish}&search_freight[maximum_weight]=#{search.maximum_weight}&search_freight[weight_unit]=Tn&page=#{search.page}&per_page=10",
      :headers => {'Cookie' => User.find(:first).cookie },
      :callback => "/app/Freight/search_callback#{do_not_destroy}")
    if do_not_destroy.empty?
      WebView.navigate(url_for(:controller => :Settings, :action => 'wait'), 0)
    else
      @msg = ''
      @search = Search.find(:first)
      @freights = Freight.find(:all)
      render :action => :index
    end
  end
  
  def search_callback
    errCode = @params['error_code'].to_i
    if errCode == 0
      Freight.delete_all unless @params["do_not_destroy"]
      no_more_freights = @params['body'].empty?
      @params['body'].each do |attributes|
        freight = Freight.new(attributes)
        freight.save
      end
      WebView.navigate(url_for :controller => :Freight, :action => :index, :query =>{:no_more_freights => no_more_freights, :message => @params['msg']} )
    else
      error_message = error_messages(@params['http_error'])
      WebView.navigate ( url_for :action => :index, :query => {:message => error_message})
    end
  end
  
  def buy_contact
    Rho::AsyncHttp.post(
      :url => "http://#{application_url}/freights/#{@params['offer_id']}/tickets.json",
      :headers => {'Cookie' => User.find(:first).cookie },
      :callback => '/app/Freight/buy_contact_callback')
    WebView.navigate(url_for(:controller => :Settings, :action => 'wait'), 0)
  end
  
  def buy_contact_callback
    errCode = @params['error_code'].to_i
    if errCode == 0
      bought_freight = MyFreight.new(@params['body'])
      bought_freight.save if MyFreight.find(:all, :conditions => {:id => bought_freight.id}).empty?
      WebView.navigate(url_for(:controller => :MyFreight, :action => :index, 
                                                          :query => {:just_bought =>true}), 1)
      NativeBar.switch_tab(1)
    else
      error_message = error_messages(@params['http_error'])
      WebView.navigate( url_for :action => :index, :query => {:message => error_message} )
    end
  end
end
