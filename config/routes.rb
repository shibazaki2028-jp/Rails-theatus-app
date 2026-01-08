Rails.application.routes.draw do
  root "top#index"

  resources :movies, only: [:iudex, :show] do
    get "search", on: :collection #映画検索
    #映画から上映スケジュールを探す導線
    resources :schedules, only: [:index]
  end

  resources :theaters do
    get "search", on: :collection #映画館検索
    #映画館から上映スケジュールを探す導線
    resources :schedules, only: [:index]
    resources :screens, only: [:index, :show]
  end

  #上映スケジュールのidを予約画面へ渡すための導線
  resources :schedules, only: [] do
    resources :reservations, only: [:new, :create, :show]
  end

  resources :reservations
  resource :account
  resource :password, only: [:show, :edit, :update]
  resource :session, only: [:new, :create, :destroy]

  #システム管理者の機能
  namespace :system_admin do
    root "top#index"
    resources :members do
      get "search", on: :collection
      resources :reservations
    end
    resources :movies
    resources :theaters, only: [:index, :show, :new, :create] do
      resources :screens do
        resources :seats
      end
    end
    resources :prices #料金マスタ(priceテーブル)
    resources :schedules #各映画館のスケジュールにアクセスできる
    resources :reservations
  end

  #映画館管理者の機能
  namespace :theater_admin do
    root "top#index"
    resources :screens do
      resources :seats
    end
    #自分の担当している映画館のスケジュール・予約のみアクセス可能
    resources :schedules 
    resources :reservations, only: [:show, :edit, :update, :destroy]
  end

  #セッション(ログイン)のルーティング
  resource :session, only: [:new, :create, :destroy]

end
