class User < ApplicationRecord
  has_many :tasks

  has_secure_password
  #validates :name, :email, :password, presence: true
  #validates_format_of :email, with: /\A([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})\z/i

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:password] }

  validates :name, uniqueness: true

  before_save { name.downcase!  }
  before_create -> {self.token = generate_token}
  before_save :default_values

  def default_values
    self.role = role.presence || 0
  end

  private

  def generate_token
    loop do
      token = SecureRandom.hex
      return token unless User.exists?({token: token})
    end
  end
end

