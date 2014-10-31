class Opendata::Resource
  include SS::Document
  include SS::Relation::File

  seqid :id
  field :name, type: String
  field :filename, type: String
  field :text, type: String
  field :format, type: String

  embedded_in :dataset, class_name: "Opendata::Dataset", inverse_of: :resource
  belongs_to_file :file

  permit_params :name, :text, :format

  validates :name, presence: true
  validates :format, presence: true

  before_validation :set_filename, if: ->{ in_file.present? }
  before_validation :set_format
  before_save :save_fuseki_rdf, if: ->{ in_file.present? }
  before_destroy :remove_fuseki_rdf

  public
    def url
      "#{dataset.url}/resource/#{id}/#{filename}"
    end

    def full_url
      "#{dataset.full_url}/resource/#{id}/#{filename}"
    end

    def graph_name
      "#{dataset.full_url}/resource/#{id}/"
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

    def allowed?(action, user, opts = {})
      true
    end

    def save_fuseki_rdf
      if format.upcase == "TTL"
        Opendata::Sparql.save graph_name, path
      else
        remove_fuseki_rdf
      end
    end

    def remove_fuseki_rdf
      Opendata::Sparql.clear graph_name
    end

  private
    def set_filename
      self.filename = in_file.original_filename
      self.format = filename.sub(/.*\./, "").upcase if format.blank?
    end

    def set_format
      self.format = format.upcase if format.present?
    end

  class << self
    public
      def allowed?(action, user, opts = {})
        true
      end

      def allow(action, user, opts = {})
        true
      end
  end
end