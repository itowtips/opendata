class Opendata::Agents::Parts::DatasetGroupController < ApplicationController
  include Cms::PartFilter::View
  helper Opendata::UrlHelper

  public
    def index
      cond = {}
      if @cate = category
        cond[:category_ids] = @cate.id
      end

      @items = Opendata::DatasetGroup.site(@cur_site).public.
        where(cond).
        order_by(created: -1).
        limit(10)

      render
    end

  private
    def category
      return nil unless @cur_node = cur_node
      return nil if @cur_node.route != "opendata/dataset_category"
      name = File.basename(File.dirname(@cur_path))
      Opendata::Node::Category.site(@cur_site).public.where(filename: /\/#{name}$/).first
    end
end