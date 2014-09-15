# coding: utf-8
class Cms::Node::GeneratePagesController < ApplicationController
  include Cms::BaseFilter
  include Cms::TaskFilter

  private
    def task_name
      "cms:page:generate"
    end

    def set_item
      @item = Cms::Task.find_or_create_by name: task_name, site_id: @cur_site.id, node_id: @cur_node.id
    end

    def set_command
      @cmd = %(rake #{task_name} site="#{@cur_site.host}" node="#{@cur_node.filename}" &)
    end
end