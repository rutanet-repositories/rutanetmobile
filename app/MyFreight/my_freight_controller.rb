require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'Date'

class MyFreightController < Rho::RhoController
  include BrowserHelper

  #GET /MyFreight
  def index
    @just_bought = @params["just_bought"] 
    #Very hacky but we cant WebView.navigate to show a freight
    if @just_bought
      @freight = MyFreight.find(:all).last()
      render :action => :show
    else
      @freights = MyFreight.find(:all)
      if @freights.empty?
        WebView.navigate(url_for(:controller => :MyFreight, :action => :do_search))
      else
        render
      end
    end
  end

  # GET /MyFreight/{1}
  def show
    @freight = MyFreight.find(@params['id'])
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
      Rho::AsyncHttp.get(
        :url => 'http://rutanet.local/tickets.json',
        :headers => {'Cookie' => User.find(:first).cookie },
        :callback => '/app/MyFreight/search_callback')
      render :action => :wait
    rescue Rho::RhoError => e
      @msg = e.message
      render :action => :login
    end
  end
  
  def search_callback
      Rho::AsyncHttp.cancel
      MyFreight.delete_all
      puts "AAAAAAAAAAH#{@params.inspect}"
      @params['body'].each do |attributes|
        freight = MyFreight.new(attributes)
        freight.save
      end
      WebView.navigate (url_for :controller => :MyFreight, :action => :index)
  end

  # POST /MyFreight/{1}/delete
  def delete
    @freight = MyFreight.find(@params['id'])
    @freight.destroy if @freight
    redirect :action => :index
  end
end
