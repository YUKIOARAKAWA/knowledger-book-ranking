namespace :slide_share_api do
  # bundle exec rake slide_share_api:slide_share
  desc "slide_shareのAPIたたく"
  task :slide_share => :environment do

    client = SlideShareApiClient.new
    res_body = client.search
    doc = Nokogiri::XML(res_body)
    # ページのURL、view数、like数、作成日にちを取得
    # 全文検索するためにメタ情報も取得しておく

    # 検索ワード
    doc.xpath("//Meta").xpath("//Query").text
    # 取得件数
    get_count = doc.xpath("//Meta").xpath("//NumResults").text.to_i
    # トータル件数
    doc.xpath("//Meta").xpath("//TotalResults").text


    title_list = doc.xpath("//Title")
    url_list = doc.xpath("//URL")
    num_download_list = doc.xpath("//NumDownloads")
    num_view_list = doc.xpath("//NumViews")
    num_favorite_list = doc.xpath("//NumFavorites")

    # DBに保存
    get_count.times do |i|
      title_list[i].text
    end


  end
end
