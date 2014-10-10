# coding: utf-8
module Cms::PublicHelper
  public
    def paginate(*args)
      super.gsub(/href=".*?"/) do |m|
        url  = convert_static_url m.sub(/href="(.*?)"/, '\\1')
        href = %(href="#{url}")
        m.sub(/href=".*?"/, href)
      end.html_safe
    end

  private
    def convert_static_url(url)
      path, query = url.split("?")

      params = Rack::Utils.parse_nested_query(query)
      params.delete("amp")
      params.delete("public_path")
      page = params.delete("page")

      path = @cur_path
      path = path.sub(/\/$/, "/index.html").sub(".html", ".p#{page}.html") if page

      if params.size > 0
        path = "#{path}?" + params.to_query
      end

      path
    end
end
