class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :email, format: Devise.email_regexp

  has_many :posts, dependent: :destroy

  has_many :sent_requests,
           foreign_key: :requestor_id,
           class_name: :Request,
           dependent: :destroy

  has_many :received_requests,
           foreign_key: :receiver_id,
           class_name: :Request

  has_many :likes, as: :likeable, dependent: :destroy

  def friends
    sent = User.joins(:received_requests).where('accepted = true').where('requestor_id = ?', id)
    received = User.joins(:sent_requests).where('accepted = true').where('receiver_id = ?', id)
    sent + received
  end

  def pending_friends
    sent = User.joins(:received_requests).where('accepted = false').where('requestor_id = ?', id)
    received = User.joins(:sent_requests).where('accepted = false').where('receiver_id = ?', id)
    sent + received
  end
end
