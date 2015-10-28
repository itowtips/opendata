class Opendata::Idea::IdeaCommentsController < ApplicationController
  include Cms::BaseFilter
  include Cms::CrudFilter
  include Workflow::PageFilter
  helper Opendata::FormHelper

  model Opendata::IdeaComment

  append_view_path "app/views/cms/pages"
  navi_view "opendata/main/navi"
  menu_view nil

  private
    def render_items(cond)
      @items = @model.where(site_id: @cur_site.id).
        allow(:read, @cur_user).
        search(params[:s]).
        where(cond).
        order_by(:created.desc)
      render file: :index
    end

  public
    def index
      render_items({})
    end
end
