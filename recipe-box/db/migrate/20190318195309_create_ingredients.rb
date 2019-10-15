class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :brand_name
      t.integer :serving_qty
      t.string :serving_unit
      t.float :serving_weight_grams
      t.float :calories
      t.float :total_fat
      t.float :saturated_fat
      t.float :cholesterol
      t.float :sodium
      t.float :total_carbohydrate
      t.float :dietary_fiber
      t.float :sugars
      t.float :protein
      t.float :potassium

      t.timestamps
    end
  end
end
