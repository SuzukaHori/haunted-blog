# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }
  scope :visible_to, lambda { |user|
    user ? published.or(where('user_id = ?', user.id)) : published
  }

  scope :search, lambda { |term|
    where('title Like :term OR content LIKE :term', { term: "%#{term}%" })
  }

  scope :default_order, -> { order(id: :desc) }

  def owned_by?(target_user)
    user == target_user
  end
end
