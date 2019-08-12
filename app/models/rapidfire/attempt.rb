module Rapidfire
  class Attempt < ActiveRecord::Base
    belongs_to :survey
    belongs_to :user, polymorphic: true
    has_many   :answers, -> { ordered }, inverse_of: :attempt, autosave: true

    validates_uniqueness_of :survey_id, scope: %i[user_id user_type]

    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :user
    end

    def complete?
      # Check each answer exists.
      survey.questions.collect do |question|
        return false unless answer.find_by(attempt: self, question: question)
      end
    end
  end
end
