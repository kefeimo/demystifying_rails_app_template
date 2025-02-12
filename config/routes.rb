Rails.application.routes.draw do

  # get({"/hello_world" => "application#hello_world"})
  # get "/hello_world" => "application#hello_world"
  # get "/hello_world/:name" => "application#hello_world"
  #
  # get "/list_posts" => "application#list_posts"
  # get "/show_post/:id" => "application#show_post"
  # # get "/show_post?id=:id" => "application#show_post"
  # get "/new_post" => "application#new_post"
  # post "/create_post" => "application#create_post"
  # get "/edit_post/:id" => "application#edit_post"
  # post "/update_post/:id" => "application#update_post"
  # post "/delete_post/:id" => "application#delete_post"

  # post "/create_comment_for_post/:post_id" => "application#create_comment"
  # post '/list_posts/:post_id/delete_comment/:comment_id' => 'application#delete_comment'
  get  '/list_comments' => 'application#list_comments'
  post '/destroy_comment/:id' => 'application#destroy_comment'

  # # posts with convention
  resources :posts do
    resources :comments
  end

  # get "/posts" => "application#list_posts"
  # get "/posts" => "posts#index"
  # get "/posts/new" => "posts#new"
  # get "/posts/:id" => "posts#show", as: "post"
  # post "/posts" => "posts#create"
  # get "/posts/:id/edit" => "posts#edit"
  # put "/posts/:id" => "posts#update"
  # patch "/posts/:id" => "posts#update"
  # delete "/posts/:id" => "posts#delete"
  #
  # # mutlisource, posts, comments with convention
  # post "/posts/:id/comments" => "comments/create"
  # delete "/posts/:post_id/comments/:id" => "comments/delete"
  # get "/comments" => "comments/index"
  # post "/create_comment_for_post/:post_id" => "posts#create_comment"
  # post '/posts/:post_id/delete_comment/:comment_id' => 'posts#delete_comment'

  # for project revisit
  get "list_posts" => "application#list_posts"


  root to: "posts#index"

  # get 'welcome/index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
