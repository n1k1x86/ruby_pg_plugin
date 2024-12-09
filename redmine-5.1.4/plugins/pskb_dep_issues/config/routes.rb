# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :pskb_dep_issues, only: [:index, :new, :show, :update, :edit, :destroy, :create]

  resources :issues do 
    member do 
      post :approve_issue
      post :reject_issue
    end
  end
end
