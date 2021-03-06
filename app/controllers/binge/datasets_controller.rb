module Binge
  class DatasetsController < ApplicationController
    
    layout 'layouts/binge/application'

    def new
      selected_model = find_selected_model(params[:model_name])
      @dataset       = Dataset.new(model: selected_model)
    end

    def create
      @dataset        = Dataset.new(params[:dataset])
      @import_results = @dataset.import_valid
      render :new
    end

    private

    def find_selected_model(model_name)
      return Model.first unless model_name
      Model.find(model_name)
    end
  end
end
