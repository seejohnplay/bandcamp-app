class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :set_role, :if => :new_record?

  validates :name, presence: true, uniqueness: true

  has_many :ratings

  enum role: [:reader, :contributor, :admin]

  def set_role
    if User.exists?
      self.role = :contributor
    else
      self.role = :admin
    end
  end
end
