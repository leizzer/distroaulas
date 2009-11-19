ActionController::Routing::Routes.draw do |map|
  map.resources :tipoespacios

  map.browse_eventos_by_day '/eventos/browse_by_day', :controller => 'eventos', :action => 'browse_by_day'

  map.browse_eventos_by_space '/eventos/browse_by_space', :controller => 'eventos', :action => 'browse_by_space'

  map.user_reset_pass '/users/reset_pass', :controller => 'users', :action => 'reset_pass'

  map.resources :eventos

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  map.clean_events '/administration/clean_events', :controller => 'administration', :action => 'clean_events'
  map.destroy_subjects '/administration/destroy_subjects', :controller => 'administration', :action => 'destroy_subjects'
  map.destroy_plans '/administration/destroy_plans', :controller => 'administration', :action => 'destroy_plans'
  map.destroy_careers '/administration/destroy_careers', :controller => 'administration', :action => 'destroy_careers'
  map.destroy_extdb '/administration/destroy_extdb', :controller => 'administration', :action => 'destroy_extdb'
  map.destroy_all '/administration/destroy_all', :controller => 'administration', :action => 'destroy_all'

  map.import '/import', :controller => 'import', :action => 'import'

  map.resources :users

  map.resource :session

  map.resources :materias

  map.resources :plans

  map.resources :carreras

  map.resources :espacios

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => 'eventos', :action => 'browse_by_space'

end
