class Session < ActiveRecord::Base
  attr_accessible :data, :user_id

  belongs_to :user

  before_save :manage_sessions

  private

  def manage_sessions
    p "==========================================================================="
    p "id: #{self.id}"
    p "kmxksmkxms"
    p "==========================================================================="
  end
end
