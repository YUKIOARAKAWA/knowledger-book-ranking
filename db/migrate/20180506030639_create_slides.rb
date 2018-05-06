class CreateSlides < ActiveRecord::Migration[5.1]
  def change
    create_table :slides do |t|
      t.string :title
      t.string :url
      t.integer :num_download
      t.integer :num_view
      t.integer :num_favorite
      t.datetime :slide_created_at
      t.string :q

      t.timestamps
    end
  end
end
