module Instapaper
  module API
    # Defines methods related to OAuth
    module OAuth
      # Gets an OAuth access token for a user.
      def token(username, password)
        response = perform_post_with_unparsed_response('/api/1/oauth/access_token', x_auth_username: username, x_auth_password: password, x_auth_mode: 'client_auth')
        params = response.split('&')
        values = params.map { |part| part.split('=') }.flatten
        values.unshift('error') if values.length == 1
        Hash[*values]
      end
    end
  end
end
