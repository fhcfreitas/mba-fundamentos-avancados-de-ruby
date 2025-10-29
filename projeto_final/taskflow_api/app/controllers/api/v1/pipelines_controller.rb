
module Api
  module V1
    class PipelinesController < ApplicationController
    # GET /pipelines
      def index
        @pipelines = Pipeline.active
        render json: @pipelines
      end

      # GET /pipelines/:id
      def show
        @pipeline = Pipeline.find(params[:id])
        render json: @pipeline.as_json(
          include: {
            tasks: {
              except: [:created_at, :updated_at, :pipeline_id]
            }
          }
        )
      end

      # POST /pipelines
      def create
        @pipeline = Pipeline.new(pipeline_params)
        if @pipeline.save
          render json: @pipeline, status: :created
        else
          render json: @pipeline.errors, status: :unprocessable_entity
        end
      end

      # PUT /pipelines/:id
      def update
        @pipeline = Pipeline.find(params[:id])
        if @pipeline.update(pipeline_params)
          render json: @pipeline
        else
          render json: @pipeline.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @pipeline = Pipeline.find(params[:id])
        @pipeline.update(status: false)
        head :no_content
      end

      private

      def pipeline_params
        params.require(:pipeline).permit(:name, :description, :configuration, :status)
      end
    end
  end
end
