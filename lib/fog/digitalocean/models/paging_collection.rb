module Fog
  module Compute
    class DigitalOcean
=begin

The links object is returned as part of the response body when pagination is enabled. By default, 25 objects are returned per page. If the response contains 25 objects or fewer, no links object will be returned. If the response contains more than 25 objects, the first 25 will be returned along with the links object.

You can request a different pagination limit or force pagination by appending ?per_page= to the request with the number of items you would like per page. For instance, to show only two results per page, you could add ?per_page=2 to the end of your query. The maximum number of results per page is 200.

The links object contains a pages object. The pages object, in turn, contains keys indicating the relationship of additional pages. The values of these are the URLs of the associated pages. The keys will be one of the following:

first: The URI of the first page of results.
prev: The URI of the previous sequential page of results.
next: The URI of the next sequential page of results.
last: The URI of the last page of results.
The pages object will only include the links that make sense. So for the first page of results, no first or prev links will ever be set. This convention holds true in other situations where a link would not make sense.

=end
      class PagingCollection < Fog::Collection

        attribute :next
        attribute :last

        def next_page(filters={})
          all(filters.merge({page: @next})) if @next && @next > 0 && @next <= @last
        end

        def previous_page(filters={})
          if @next > 2
            all(filters.merge({page: @next - 2}))
          end
        end

        private

        def deep_fetch(hash, *path)
          path.inject(hash) do |acc, key|
            acc.respond_to?(:keys) ? acc[key] : nil
          end
        end

        def get_page(link)
          if match = link.match(/page=(?<page>\d+)/)
            match.captures.last
          end
        end

        def get_paged_links(links)
          if links && links.size > 0
            next_link = deep_fetch(links, "pages", "next").to_s
            last_link = deep_fetch(links, "pages", "last").to_s
            @next = get_page(next_link).to_i || @next
            @last = get_page(last_link).to_i || @last
          else
            @next = 0
            @last = 0
          end
        end
      end
    end
  end
end
