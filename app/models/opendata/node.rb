# coding: utf-8
module Opendata::Node
  class Base
    include Cms::Node::Model
    
    default_scope ->{ where(route: /^opendata\//) }
  end
  
  class Dataset
    include Cms::Node::Model
    
    default_scope ->{ where(route: "opendata/data") }
  end
  
  class App
    include Cms::Node::Model
    
    default_scope ->{ where(route: "opendata/app") }
  end
  
  class Idea
    include Cms::Node::Model
    
    default_scope ->{ where(route: "opendata/idea") }
  end
  
  class Sparql
    include Cms::Node::Model
    
    default_scope ->{ where(route: "opendata/sparql") }
  end
  
  class Api
    include Cms::Node::Model
    
    default_scope ->{ where(route: "opendata/api") }
  end
  
  class User
    include Cms::Node::Model
    
    default_scope ->{ where(route: "opendata/user") }
  end
end
