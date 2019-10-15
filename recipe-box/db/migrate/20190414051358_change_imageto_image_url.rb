class ChangeImagetoImageUrl < ActiveRecord::Migration[5.2]
  def change
    rename_column :recipes, :image, :image_url
  end
end
