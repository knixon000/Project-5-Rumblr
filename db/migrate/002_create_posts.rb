class CreatePosts < ActiveRecord::Migration[5.0]
  def up
    create_table :posts do |t|
      t.string :text_entry
      t.string :tag
    end
  end
  def down
    drop_table :posts
  end
end
