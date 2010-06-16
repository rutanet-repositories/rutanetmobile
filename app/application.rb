require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  
  
  TABS = [  { :action => '/app/Freight/search',:icon => "/public/images/searchwhite.png"},
            { :action => :separator}, 
            { :action => '/app/MyFreight', :icon => "/public/images/truckwhite.png"},
            { :action => :separator},
            {:action => '/app/Settings/logout',       :icon => "/public/images/logoutwhite.png"}]
   
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    @@toolbar = nil
    @@tabbar = nil
    unless User.find(:first).nil?
     @@toolbar = TABS
    end
    super
  end
  
end
