require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'Date'

class FreightController < Rho::RhoController
  include BrowserHelper

  #GET /Freight
  def index
    @freights = Freight.find(:all)
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
    begin
      Rho::AsyncHttp.post(
        :url => 'http://rutanet.local/search_freights.json',
        :body => "search_freight[origin]=#{@params['origin']}&search_freight[destination]=#{@params['destination']}&search_freight[finish]=#{@params['finish']}",
        :headers => {'Cookie' => User.find(:first).cookie },
        :callback => '/app/Freight/search_callback')
      render :action => :wait
    rescue Rho::RhoError => e
      @msg = e.message
      render :action => :login
    end
  end
  
  def search_callback
      Freight.delete_all
      @params['body'].each do |attributes|
        freight = Freight.new(attributes)
        freight.save
      end
      WebView.navigate(url_for :controller => :Freight, :action => :index )
  end
  
  def buy_contact
    Rho::AsyncHttp.post(
      :url => "http://rutanet.local/freights/#{@params['offer_id']}/tickets.json",
      :headers => {'Cookie' => User.find(:first).cookie },
      :callback => '/app/Freight/buy_contact_callback')
    render :action => :wait
  end
  
  def buy_contact_callback
    bought_freight = MyFreight.new(@params['body'])
    bought_freight.save if MyFreight.find(:all, :conditions => {:id => bought_freight.id}).empty?
    WebView.navigate url_for(:controller => :MyFreight, :action => :index, 
                                                        :query => {:just_bought =>true})
  end

  # POST /Freight/{1}/delete
  def delete
    @freight = Freight.find(@params['id'])
    @freight.destroy if @freight
    redirect :action => :index
  end
end
