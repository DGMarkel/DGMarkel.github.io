class RecipesController < ApiController
  before_action :require_login, except: [:index, :show]

  def index
    recipes = Recipe.all
    render json: recipes
  end

  def show
    recipe = Recipe.find(params[:id])
    render json: recipe
  end

  def create
    recipe = Recipe.new(title: recipe_params[:title], description: recipe_params[:description], image_url: recipe_params[:image_url], servings: recipe_params[:servings])
    recipe.user = current_user
    if recipe.save
      recipe.ingredients.create(recipe_params[:ingredients])
      render json: {
      message: 'ok',
      recipe: recipe
      }
    else
      render json: {
        message: 'Could not create recipe'
      }
    end
  end

  def update
    recipe = Recipe.find(recipe_params[:id])
    if recipe.update(title: recipe_params[:title], description: recipe_params[:description], image_url: recipe_params[:image_url], servings: recipe_params[:servings])
      recipe.ingredients.create(recipe_params[:ingredients])
      render json: {
      message: 'ok',
      recipe: recipe
      }
    else
      render json: {
        message: 'Could not update recipe'
      }
    end
  end

  private

    def recipe_params
      params.require(:recipe).permit(
        :id,
        :title,
        :description,
        :image_url,
        :servings,
        ingredients: [
          :food_name,
          :serving_qty,
          :serving_unit,
          :calories,
          :cholesterol,
          :dietary_fiber,
          :food_name,
          :potassium,
          :protein,
          :saturated_fat,
          :serving_qty,
          :serving_unit,
          :sodium,
          :sugars,
          :total_carbohydrate,
          :total_fat
        ]
      )
    end

end
