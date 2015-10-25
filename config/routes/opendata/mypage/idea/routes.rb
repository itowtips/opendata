SS::Application.routes.draw do

  Opendata::Initializer

  concern :deletion do
    get :delete, on: :member
  end

  content "opendata" do
    get "ideas_approve" => "app/apps#index_approve"
    get "ideas_request" => "app/apps#index_request"
    get "ideas_closed" => "app/apps#index_closed"
    resources :my_ideas, concerns: :deletion, module: "mypage/idea"
  end

  node "opendata" do
    resources :ideas, path: "my_idea", controller: "public", cell: "nodes/mypage/idea/my_idea", concerns: :deletion
  end
end
