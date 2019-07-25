module Rapidfire
  class Attempt < ActiveRecord::Base
    belongs_to :survey
    belongs_to :user, polymorphic: true
    has_many   :answers, inverse_of: :attempt, autosave: true

    validates_uniqueness_of :user, scope: :survey

    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :user
    end
  end
end
