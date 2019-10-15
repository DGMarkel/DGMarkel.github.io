class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image_url, :servings, :creator_name
  has_many :ingredients
end
