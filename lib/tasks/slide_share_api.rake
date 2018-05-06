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
    slide_created_at = doc.xpath("//Created")

    # DBに保存
    get_count.times do |i|
      slide = Slide.new(
        title: title_list[i].text,
        url: url_list[i].text,
        num_download: num_download_list[i].text,
        num_view: num_view_list[i].text,
        num_favorite: num_favorite_list[i].text,
        slide_created_at: slide_created_at[i].text,
        q: "Ruby"
      )
      slide.save!
    end


  end
end
