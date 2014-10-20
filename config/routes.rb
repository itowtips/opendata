class ActionDispatch::Routing::Mapper
  def content(ns, opts = {}, &block)
    name = opts[:name] || ns.gsub("/", "_")
    mod  = opts[:module] || ns
    namespace(name, path: ".:site/#{ns}:cid", module: mod, cid: /\w+/) { yield }
  end

  def node(ns, &block)
    name = ns.gsub("/", "_")
    path = ".:site/nodes/#{ns}"
    namespace(name, as: "#{name}_node", path: path, module: "cms") { yield }
  end

  def page(ns, &block)
    name = ns.gsub("/", "_")
    path = ".:site/pages/#{ns}"
    namespace(name, as: "#{name}_page", path: path, module: "cms") { yield }
  end

  def part(ns, &block)
    name = ns.gsub("/", "_")
    path = ".:site/parts/#{ns}"
    namespace(name, as: "#{name}_part", path: path, module: "cms") { yield }
  end

  def sys(ns, opts = {}, &block)
    name = opts[:name] || ns.gsub("/", "_")
    mod  = opts[:module] || ns
    namespace(name, as: "#{name}_sys", path: ".sys/#{ns}", module: "#{mod}/sys") { yield }
  end
end

SS::Application.routes.draw do

  SS::Initializer

  get "/auth/:provider/callback" => "authes#callback"
  get "/auth/failure" => "authes#fail"

  namespace "fs" do
    get ":id/:filename" => "files#index", as: :file
    get ":id/thumb/:filename" => "files#thumb", as: :thumb
  end

  namespace "sns", path: ".mypage" do
    get   "/"      => "mypage#index", as: :mypage
    get   "logout" => "login#logout", as: :logout
    match "login"  => "login#login", as: :login, via: [:get, :post]
  end

end
