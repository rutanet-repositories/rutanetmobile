require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  
  
  TABS = [  { :action => '/app/Freight/search',:icon => "/public/images/search.png"},
            { :action => :separator}, 
            { :action => '/app/MyFreight', :icon => "/public/images/truck.png"},
            { :action => :separator},
            {:action => '/app/Settings/logout',       :icon => "/public/images/settings.png"}]
   
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    unless User.find(:first).nil?
     @@toolbar = TABS
    end
    @@tabbar = nil
    super
  end
  
end
