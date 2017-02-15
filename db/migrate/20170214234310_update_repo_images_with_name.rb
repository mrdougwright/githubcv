class UpdateRepoImagesWithName < ActiveRecord::Migration[5.0]
  def change
    rename_column :repo_images, :file, :name
    add_column :repo_images, :image_url, :string
    add_column :repo_images, :desc, :string
  end
end
