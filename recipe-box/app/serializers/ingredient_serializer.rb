class IngredientSerializer < ActiveModel::Serializer
  attributes :food_name, :serving_qty, :serving_unit, :calories, :total_fat, :cholesterol, :sodium,
  :total_carbohydrate, :dietary_fiber, :sugars, :protein, :potassium
end
