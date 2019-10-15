class Ingredient < ApplicationRecord
  validates_presence_of [:food_name]
  belongs_to :recipe

end
