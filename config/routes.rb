Rails.application.routes.draw do
  resources :versions do
    resources :contract_works do
      member do
        post :update_issues
      end
      collection do
        post :sort
        get :for_version
      end
    end
  end

  resources :'reports' do
    member do
      put :approve
      put :reject
    end
    collection do
      get :export
    end
  end
end