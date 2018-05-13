namespace :slide_share_api do
  # bundle exec rake slide_share_api:slide_share[Ruby]
  # Rails　完了
  # Ruby　完了
  desc "slide_shareのAPIたたく"
  task :slide_share, ['q'] => :environment do |task, args|
    # 1回目
    page = 1
    get_c, total_c = search_slide_and_create!(page, args[:q])
    puts "取得件数#{get_c}件"
    puts "トータル件数#{total_c}件"

    # 2回目以降
    #
    page = (total_c / get_c.to_f).ceil
    2.upto(page) do |page|
      # 負荷考慮
      sleep(5)
      search_slide_and_create!(page, args[:q])
      puts "#{page}ページ目完了"
    end

  end
end


def search_slide_and_create!(page, q)
  client = SlideShareApiClient.new
  res_body = client.search(page: page, q: q)
  doc = Nokogiri::XML(res_body)
  # ページのURL、view数、like数、作成日にちを取得
  # 全文検索するためにメタ情報も取得しておく

  # 検索ワード
  query = doc.xpath("//Meta").xpath("//Query").text
  # 取得件数
  get_c = doc.xpath("//Meta").xpath("//NumResults").text.to_i
  # トータル件数
  total_c = doc.xpath("//Meta").xpath("//TotalResults").text.to_i
  return if get_c == 0

  title_list = doc.xpath("//Title")
  url_list = doc.xpath("//URL")
  num_download_list = doc.xpath("//NumDownloads")
  num_view_list = doc.xpath("//NumViews")
  num_favorite_list = doc.xpath("//NumFavorites")
  slide_created_at = doc.xpath("//Created")

  # DBに保存
  get_c.times do |i|
    slide = Slide.new(
      title: title_list[i].text,
      url: url_list[i].text,
      num_download: num_download_list[i].text,
      num_view: num_view_list[i].text,
      num_favorite: num_favorite_list[i].text,
      slide_created_at: slide_created_at[i].text,
      q: query
    )
    # urlでユニークか確認したほうが良さそう
    begin
      slide.save!
    rescue => e
      puts e
      puts "エラー#{page}ページの#{i}番目"
    end

  end

  return get_c, total_c
end
