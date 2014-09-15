# coding: utf-8
class Category::Task::Node::NodesController < ApplicationController
  include Cms::ReleaseFilter::Page

  public
    def generate(task, node)
      task.log "#{node.url}"

      generate_node node
    end
end
