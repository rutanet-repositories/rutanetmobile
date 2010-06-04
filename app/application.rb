require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  
  
  TABS = [{ :label => "Buscar", :action => '/app/Freight/search',:icon => "/public/images/search.png", :reload => true }, 
           { :label => "Mis cargas", :action => '/app/Freight/index', :icon => "/public/images/truck.png", :reload => true },
           { :label => "Salir", :action => '/app/Settings/logout',       :icon => "/public/images/settings.png", :reload => true }]
   
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    unless User.find(:first).nil?
     @tabs = TABS
    end
    @@toolbar = nil
    @@tabbar = nil
    super
  end
  
end
