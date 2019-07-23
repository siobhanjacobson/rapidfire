module Rapidfire
  class AttemptsController < Rapidfire::ApplicationController
    if Rails::VERSION::MAJOR ==  5
      before_action :find_survey!
    else
      before_filter :find_survey!
    end

    def show
      @attempt = @survey.attempts.find_by(attempt_params_for_find)
    end

    def new
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def create
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        redirect_to after_answer_path_for
      else
        render :new
      end
    end

    def edit
      p '!!!!!!!!!!!!!!!!'
      p attempt_params
      @attempt_builder = AttemptBuilder.new(attempt_params)
      # return unless @attempt_builder.answers.empty?
      #
      # attempt_params[:survey].questions.collect do |question|
      #   @attempt_builder.answers.build(question_id: question.id)
      # end
    end

    def update
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        redirect_to after_answer_path_for
      else
        render :edit
      end
    end

    private

    def find_survey!
      @survey = Survey.find(params[:survey_id])
    end

    def attempt_params
      answer_params = { params: (params[:attempt] || {}) }
      survey_user = if params[:id].nil?
                      current_user
                    else
                      Attempt.find_by(id: params[:id]).user
                    end
      answer_params.merge(user: survey_user, survey: @survey, attempt_id: params[:id])
    end

    def attempt_params_for_find
      these_params = attempt_params
      these_params[:id] = these_params.delete(:attempt_id)
      these_params
    end

    # Override path to redirect after answer the survey
    # Write:
    #   # my_app/app/decorators/controllers/rapidfire/answer_groups_controller_decorator.rb
    #   Rapidfire::AnswerGroupsController.class_eval do
    #     def after_answer_path_for
    #       main_app.root_path
    #     end
    #   end
    def after_answer_path_for
      surveys_path
    end

    def rapidfire_current_scoped
      send 'current_' + scoped.to_s
    end
  end
end
