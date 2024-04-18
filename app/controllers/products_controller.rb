class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show update destroy ]

  # GET /products
  def index
    @products = Product.all
    @products.each do |product|
      puts product.price.class
    end

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    product_params = {
      name: params[:name],
      price: params[:price],
      quantity: params[:quantity],
      category: params[:category]
    }
    puts product_params[:price].class
    @product = Product.new(product_params)
    puts @product.price.class

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy!
  end

  # PATCH/PUT / inceremnt price for multiple products prices by an array of ids
  def update_multiple
    products = Product.where(id: params[:ids])
    products.each do |product|
      product.update!(price: product.price + params[:price])
    end
    render json: products
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :price, :quantity, :category)
    end
end
