module Blog
  module Routes
    class Assets < Base
      get '/assets/*' do
        p "dupa"
        env['PATH_INFO'].sub!(%r{^/assets}, '')
        settings.assets.call(env)
      end
    end
  end
end