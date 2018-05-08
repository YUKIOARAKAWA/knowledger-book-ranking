namespace :amazon_api do
  # bundle exec rake amazon_api:item_search
  desc "amazonのAPIたたく"
  task :item_search, ['q'] => :environment do |task, args|
    # 初期設定　起動時に
    Amazon::Ecs.configure do |options|
      options[:AWS_access_key_id] = Settings.amazon_api.access_key
      options[:AWS_secret_key] = Settings.amazon_api.secret_key
      options[:associate_tag] = Settings.amazon_api.associate_tag
    end

    # res = Amazon::Ecs.item_search('ruby', :search_index => 'All', :country => 'jp')
  end
end
