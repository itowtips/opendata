# coding: utf-8
class Cms::GeneratePagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::TaskFilter

  navi_view "cms/main/navi"

  private
    def task_name
      "cms:generate_pages"
    end

    def set_item
      @item = Cms::Task.find_or_create_by name: task_name, site_id: @cur_site.id, node_id: nil
    end

    def set_command
      @cmd = %(rake #{task_name} site="#{@cur_site.host}" &)
    end
end
