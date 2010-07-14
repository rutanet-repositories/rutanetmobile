require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  
  
  TABS = [  { :label => "Buscar", :action => '/app/Freight/search',:icon => "/public/images/search.png", :reload => true},
            { :label => "Mis cargas",:action => '/app/MyFreight', :icon => "/public/images/truck.png"},
            { :label => "Salir",:action => '/app/Settings/logout', :icon => "/public/images/logout.png"}]
   
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    @@toolbar = nil
    @@tabbar = nil
    unless User.find(:first).nil?
     @tabs = TABS
    end
    super
  end
  
end
