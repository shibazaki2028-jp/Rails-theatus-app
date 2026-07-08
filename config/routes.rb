Rails.application.routes.draw do
  root "top#index"

  resources :movies, only: [:index, :show] do
    get "search", on: :collection #映画検索
  end

  resources :theaters do
    get "search", on: :collection #映画館検索
    #映画館から上映スケジュールを探す導線
    resources :screens, only: [:index, :show]
  end

  #上映スケジュールのidを予約画面へ渡すための導線
  resources :schedules, only: [] do
    resources :reservations, only: [:new, :create, :show] do
      post :confirm, on: :collection
    end
  end

  resources :reservations
  resources :accounts
  resource :password, only: [:show, :edit, :update]
  resource :session, only: [:new, :create, :destroy]

  #システム管理者の機能
  namespace :system_admin do
    root "top#index"
    resources :accounts do
      get "search", on: :collection
      resources :reservations
    end
    resources :movies
    resources :theaters do#, only: [:index, :show, :new, :create, :edit] do
      resources :screens do
        resources :seats
      end
    end
    resources :prices #料金マスタ(priceテーブル)
    resources :schedules #各映画館のスケジュールにアクセスできる
    resources :reservations
  end

  #セッション(ログイン)のルーティング
  resource :session, only: [:new, :create, :destroy]

end
