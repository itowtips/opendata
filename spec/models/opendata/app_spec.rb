require 'spec_helper'

describe Opendata::App, dbscope: :example do
  context "check attributes with typical url resource" do
    let!(:node_search_app) { create(:opendata_node_search_app) }
    let(:node) { create(:opendata_node_app) }
    subject { create(:opendata_app, node: node) }
    its(:becomes_with_route) { is_expected.not_to be_nil }
    its(:dirname) { is_expected.to eq node.filename }
    its(:basename) { is_expected.to eq subject.filename.split('/').last }
    its(:path) { is_expected.to end_with  "/#{subject.dirname}/#{subject.basename}" }
    its(:url) { is_expected.to eq "/#{subject.dirname}/#{subject.basename}" }
    its(:full_url) { is_expected.to eq "http://#{cms_site.domain}/#{subject.dirname}/#{subject.basename}" }
    its(:parent) { expect(subject.parent.id).to eq node.id }
    its(:point_url) { is_expected.to eq "#{subject.url.sub(/\.html$/, "")}/point.html" }
    its(:point_members_url) { is_expected.to eq "#{subject.url.sub(/\.html$/, "")}/point/members.html" }
    its(:app_ideas_url) { is_expected.to eq "#{subject.url.sub(/\.html$/, "")}/ideas/show.html" }
    its(:zip_url) { is_expected.to eq "#{subject.url.sub(/\.html$/, "")}/zip" }
    its(:executed_show_url) { is_expected.to eq "#{subject.url.sub(/\.html$/, "")}/executed/show.html" }
    its(:executed_add_url) { is_expected.to eq "#{subject.url.sub(/\.html$/, "")}/executed/add.html" }
    its(:contact_present?) { is_expected.to be_falsey }
    it ".zip_dir" do
      expect(described_class.zip_dir_orig).to eq Rails.root.join('tmp', 'opendata')
    end
  end

  describe ".sort_options" do
    it { expect(described_class.sort_options).to include %w(新着順 released) }
  end

  describe ".sort_hash" do
    it { expect(described_class.sort_hash("released")).to include(released: -1).and include(_id: -1) }
    it { expect(described_class.sort_hash("popular")).to include(point: -1).and include(_id: -1) }
    it { expect(described_class.sort_hash("attention")).to include(executed: -1).and include(_id: -1) }
    it { expect(described_class.sort_hash("")).to include(released: -1) }
    it { expect(described_class.sort_hash("foobar")).to include("foobar" => 1) }
  end

  describe ".aggregate_field" do
    it { expect(described_class.aggregate_field(:license, limit: 10)).to be_empty }
  end

  describe ".aggregate_array" do
    it { expect(described_class.aggregate_array(:tags, limit: 10)).to be_empty }
  end

  describe ".search" do
    let(:name_keyword_matcher) do
      include("$and" => include("$or" => include("name" => /\Qキーワード\E/i).and(include("text" => /\Qキーワード\E/i))))
    end
    it { expect(described_class.search({}).selector.to_h).to include("route" => "opendata/app") }
    it { expect(described_class.search(keyword: "キーワード").selector.to_h).to include("$and") }
    it { expect(described_class.search(name: true, keyword: "キーワード").selector.to_h).to name_keyword_matcher }
    it { expect(described_class.search(tag: "タグ").selector.to_h).to include("tags" => "タグ") }
    it { expect(described_class.search(area_id: "43").selector.to_h).to include("area_ids" => 43) }
    it { expect(described_class.search(category_id: "56").selector.to_h).to include("category_ids" => 56) }
    it { expect(described_class.search(license: "ライセンス").selector.to_h).to include("license" => "ライセンス") }
  end

  describe "#create_zip" do
    let!(:node_search_app) { create(:opendata_node_search_app) }
    let!(:node) { create(:opendata_node_app) }
    let!(:app) { create(:opendata_app, node: node) }

    def create_appfile(app, file)
      appfile = app.appfiles.new(text: "aaa", format: "csv")
      appfile.in_file = file
      appfile.save!
      appfile
    end

    def entry_names(zip_filename)
      names = []
      Zip::Archive.open(zip_filename) do |archives|
        archives.each do |ar|
          name = ar.name.encode('utf-8', 'cp932')
          names << name
        end
      end
      names
    end

    context "when there is no appfiles" do
      it do
        zip_filename = app.create_zip
        expect(File.exist?(zip_filename)).to be_falsey
      end
    end

    context "when there is one appfile" do
      let!(:file_path) { Rails.root.join("spec", "fixtures", "opendata", "utf-8.csv") }
      let!(:file) { Fs::UploadedFile.create_from_file(file_path, basename: "spec") }
      let!(:appfile) { create_appfile(app, file) }

      it do
        zip_filename = app.create_zip
        expect(File.exist?(zip_filename)).to be_truthy
      end
    end

    context "when there is one japanese filename" do
      let!(:tmp_dir) { Dir.mktmpdir }
      let!(:tmp_file) { "#{tmp_dir}/日本語ファイル名.csv" }

      before do
        FileUtils.cp(Rails.root.join("spec", "fixtures", "opendata", "utf-8.csv"), tmp_file)
        file = Fs::UploadedFile.create_from_file(tmp_file, basename: "spec")
        create_appfile(app, file)
      end

      after do
        FileUtils.rm_rf(tmp_dir)
      end

      it do
        zip_filename = app.create_zip
        expect(File.exist?(zip_filename)).to be_truthy

        names = entry_names(zip_filename)
        expect(names).to include('日本語ファイル名.csv')
      end
    end

    context "when there is one invalid shift_jis japanese filename" do
      let!(:tmp_dir) { Dir.mktmpdir }
      let!(:tmp_file) { "#{tmp_dir}/\u222D日本語ファイル名.csv" }

      before do
        FileUtils.cp(Rails.root.join("spec", "fixtures", "opendata", "utf-8.csv"), tmp_file)
        file = Fs::UploadedFile.create_from_file(tmp_file, basename: "spec")
        create_appfile(app, file)
      end

      after do
        FileUtils.rm_rf(tmp_dir)
      end

      it do
        zip_filename = app.create_zip
        expect(File.exist?(zip_filename)).to be_truthy

        names = entry_names(zip_filename)
        expect(names).to include('_日本語ファイル名.csv')
      end
    end
  end
end
