# coding: utf-8
module Opendata::Parts::Dataset
  class ViewCell < Cell::Rails
    include Cms::PartFilter::ViewCell
    helper Cms::ListHelper

    public
      def index
        @items = Opendata::Dataset.site(@cur_site).public.
          where(@cur_part.condition_hash).
          order_by(@cur_part.sort_hash).
          page(params[:page]).
          per(@cur_part.limit)

        render
      end
  end
end