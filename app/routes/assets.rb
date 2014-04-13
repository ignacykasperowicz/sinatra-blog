module Blog
  module Routes
    class Assets < Base
      get '/assets/*' do
        env['PATH_INFO'].sub!(%r{^/assets}, '')
        settings.assets.call(env)
      end

      get '/to_pdf' do
        html = haml(:pdf)
        kit = PDFKit.new(html)
        kit.to_pdf
      end
    end
  end
end