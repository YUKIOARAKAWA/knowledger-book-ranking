class CreateAmazonProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :amazon_products do |t|
      t.string :asin
      t.string :title
      t.string :author
      t.text :url
      t.integer :point
      t.string :q

      t.timestamps
    end
  end
end
