require 'instapaper/http/request'

module Instapaper
  module HTTP
    module Utils
      private

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_post_with_objects(path, options, klass)
        perform_request_with_objects(:post, path, options, klass)
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_get_with_objects(path, options, klass)
        perform_request_with_objects(:get, path, options, klass)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_request_with_objects(request_method, path, options, klass)
        perform_request(request_method, path, options).collect do |element|
          klass.new(coerce_hash(element))
        end
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_post_with_object(path, options, klass)
        perform_request_with_object(:post, path, options, klass)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_request_with_object(request_method, path, options, klass)
        response = perform_request(request_method, path, options)
        response = response.is_a?(Array) ? response.first : response
        klass.new(coerce_hash(response))
      end

      # @param path [String]
      # @param options [Hash]
      def perform_post_with_unparsed_response(path, options)
        perform_request(:post, path, options.merge(raw: true))
      end

      def perform_request(method, path, options)
        Instapaper::HTTP::Request.new(self, method, path, options).perform
      end

      def coerce_hash(response)
        if response.key?('hash')
          response['instapaper_hash'] = response.delete('hash')
        end
        if response.key?('bookmarks')
          response['bookmarks'] = response['bookmarks'].collect {|bookmark|
            coerce_hash(bookmark)
          }
        end
        response
      end
    end
  end
end
