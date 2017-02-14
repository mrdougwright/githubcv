class CreateRepoImages < ActiveRecord::Migration[5.0]
  def change
    create_table :repo_images do |t|
      t.integer :user_id
      t.string  :file
      t.string  :url

      t.timestamps
    end
  end
end
