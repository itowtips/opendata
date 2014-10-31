module Opendata::Agents::Nodes::Resource
  class ViewController < ApplicationController
    include Cms::NodeFilter::View
    include Opendata::UrlHelper

    before_action :accept_cors_request
    before_action :set_dataset

    private
      def set_dataset
        @dataset_path = @cur_path.sub(/\/resource\/.*/, "")

        @dataset = Opendata::Dataset.site(@cur_site).public.
          filename(@dataset_path).
          first

        raise "404" unless @dataset
      end

    public
      def index
        redirect_to @dataset_path
      end

      def download
        @item = @dataset.resources.find_by id: params[:id], filename: params[:filename]
        @item.dataset.inc downloaded: 1

        send_file @item.file.path, type: @item.content_type, filename: @item.filename,
          disposition: :attachment, x_sendfile: true
      end
  end
end