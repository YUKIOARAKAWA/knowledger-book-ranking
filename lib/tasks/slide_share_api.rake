namespace :slide_share_api do
  # bundle exec rake slide_share_api:slide_share
  desc "slide_shareのAPIたたく"
  task :slide_share => :environment do

    client = SlideShareApiClient.new
    res_body = client.search
    doc = Nokogiri::XML(res_body)
    # ページのURL、view数、like数、作成日にちを取得
    # DBに保存

  end
end
