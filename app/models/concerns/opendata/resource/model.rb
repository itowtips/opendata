module Opendata::Resource::Model
  extend ActiveSupport::Concern
  include SS::Relation::File

  included do
    seqid :id
    field :name, type: String
    field :filename, type: String
    field :text, type: String
    field :format, type: String

    # embedded_in :dataset, class_name: "Opendata::Dataset", inverse_of: :resource
    belongs_to :license, class_name: "Opendata::License"
    belongs_to_file :file
    belongs_to_file :tsv

    validates :name, presence: true
    validates :license_id, presence: true
  end

  def url
    dataset.url.sub(/\.html$/, "") + "#{context_path}/#{id}/#{filename}"
  end

  def full_url
    dataset.full_url.sub(/\.html$/, "") + "#{context_path}/#{id}/#{filename}"
  end

  def content_url
    dataset.full_url.sub(/\.html$/, "") + "#{context_path}/#{id}/content.html"
  end

  def path
    file ? file.path : nil
  end

  def content_type
    file ? file.content_type : nil
  end

  def size
    file ? file.size : nil
  end

  def tsv_present?
    if tsv || %(CSV TSV).index(format.try(:upcase))
      true
    end
  end

  def parse_tsv
    require "nkf"
    require "csv"

    src  = tsv || file
    data = NKF.nkf("-w", src.read)
    sep  = data =~ /\t/ ? "\t" : ","
    CSV.parse(data, col_sep: sep) rescue nil
  end

  def allowed?(action, user, opts = {})
    true
  end

  module ClassMethods
    def allowed?(action, user, opts = {})
      true
    end

    def allow(action, user, opts = {})
      true
    end

    def format_options
      %w(AVI BMP CSV DOC DOCX DOT GIF HTML JPG LZH MOV MP3 MPG ODS
         ODT OTS OTT RAR RTF RDF TAR TGZ TTL TXT WAV XLS XLT XLSX XML ZIP)
    end

    def search(params)
      criteria = self.where({})
      return criteria if params.blank?

      criteria = criteria.where(name: /#{params[:keyword]}/) if params[:keyword].present?
      criteria = criteria.where(format: params[:format].upcase) if params[:format].present?

      criteria
    end
  end
end
