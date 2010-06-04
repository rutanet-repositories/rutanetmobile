require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    @tabs = [{ :label => "Buscar", :action => '/app/Freight/search',:icon => "/public/images/search.png", :reload => true }, 
             { :label => "Mis cargas", :action => '/app/Freight/index', :icon => "/public/images/truck.png", :reload => true },
             { :label => "Salir", :action => '/app/Settings/logout',       :icon => "/public/images/settings.png", :reload => true }] unless User.find(:first).nil?
    @@tabbar = nil
    super
  end
end
