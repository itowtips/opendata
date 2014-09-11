# coding: utf-8
module Opendata::Part
  class MypageLogin
    include Cms::Part::Model

    default_scope ->{ where(route: "opendata/mypage_login") }
  end

  class Dataset
    include Cms::Part::Model
    include Cms::Addon::PageList

    default_scope ->{ where(route: "opendata/dataset") }

    def condition_hash
      {} # TODO:
    end
  end

  class Group
    include Cms::Part::Model
    include Cms::Addon::NodeList

    default_scope ->{ where(route: "opendata/group") }

    def condition_hash
      {} # TODO:
    end
  end

  class App
    include Cms::Part::Model
    include Cms::Addon::PageList

    default_scope ->{ where(route: "opendata/app") }

    def condition_hash
      {} # TODO:
    end
  end

  class Idea
    include Cms::Part::Model
    include Cms::Addon::PageList

    default_scope ->{ where(route: "opendata/idea") }

    def condition_hash
      {} # TODO:
    end
  end
end
