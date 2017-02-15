class UpdateRepoImageUidRepo < ActiveRecord::Migration[5.0]
  def change
    remove_column :repo_images, :user_id, :integer
    add_column :repo_images, :repo_name, :string
  end
end
