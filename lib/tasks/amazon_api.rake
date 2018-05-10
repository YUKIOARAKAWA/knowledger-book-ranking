namespace :amazon_api do
  # bundle exec rake amazon_api:item_search[Ruby]
  desc "amazonのAPIたたく"
  task :item_search, ['q'] => :environment do |task, args|
    # 初期設定　起動時に
    Amazon::Ecs.configure do |options|
      options[:AWS_access_key_id] = Settings.amazon_api.access_key
      options[:AWS_secret_key] = Settings.amazon_api.secret_key
      options[:associate_tag] = Settings.amazon_api.associate_tag
    end

    # res = Amazon::Ecs.item_search('ruby', :search_index => 'All', :country => 'jp', item_page: 1)
    q = args[:q]
    page = 1
    # 全ページとりたいので適当に99999指定
    page.upto(99999) do |page|
      res = item_search_and_create!(q, page)
      break if res == 'no result'
    end

  end
end

def item_search_and_create!(q, page)
  res = Amazon::Ecs.item_search(q, :search_index => 'All', :country => 'jp', item_page: page)
  return 'no result' if res.items.count == 0

  res.items.each do |item|
    amazon_product = AmazonProduct.new(
      asin: item.get('ASIN'),
      url: item.get('DetailPageURL'),
      title: item.get_element('ItemAttributes').get('Title'),
      author: item.get_element('ItemAttributes').get('Author')
    )
    amazon_product.save!
  end
end
