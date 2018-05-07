class SlideShareApiClient
  attr_accessor :api_key, :secret_key, :ts, :hash, :url

  def initialize
    @api_key = Settings.slide_share_api.key
    @secret_key = Settings.slide_share_api.secret
    @ts = Time.current.to_i
    @hash = Digest::SHA1.hexdigest("#{@secret_key}#{@ts}")
    @url = 'https://www.slideshare.net/'
  end

  def search(page: 1, q:)
    conn = Faraday::Connection.new(:url => url) do |builder|
        ## URLをエンコードする
        builder.use Faraday::Request::UrlEncoded
        ## ログを標準出力に出したい時(本番はコメントアウトでいいかも)
        builder.use Faraday::Response::Logger
        ## アダプター選択（選択肢は他にもあり）
        builder.use Faraday::Adapter::NetHttp
    end

    res = conn.get do |req|
      req.url 'api/2/search_slideshows', {:api_key => api_key, :ts => ts, :hash => hash}
      req.params[:lang] = :ja
      req.params[:q] = q
      req.params[:detailed] = 1
      req.params[:page] = page #件数制限があって一度に全件取得できない
    end

    body = res.body
  end
end
