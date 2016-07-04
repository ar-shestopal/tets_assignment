class User < ActiveRecord::Base
  include UserRoles

  has_many :articles
  has_many :comments

  attr_accessor :password

  before_validation :set_default_role, if: lambda { |user| user.new_record? && !user.role.present? }

  EMAIL_REGEXP = /\A[A-Za-z0-9][\w\-\.]*[A-Za-z0-9]*@[A-Za-z0-9]*([\w\-\.]*[A-Za-z0-9]\.)+([A-Za-z]){2,4}\z/i
  ROLES_KEYS = %w(admin regular_user)

  validates :name,     presence: true, length: { in: 3..50 }
  validates :email,    presence: true, uniqueness: true, format: { with: EMAIL_REGEXP }
  validates :password, presence: true, length: { in: 6..20 }, if: lambda { |user| user.new_record? }
  validates :role,     presence: true, inclusion: ROLES_KEYS

  before_save :encrypt_password
  after_save  :clear_password

  # Roles
  def role? role_key
    self.role == role_key.to_s
  end

  def admin?
    role? :admin
  end

  def regular_user?
    role? :regular_user
  end

  def set_default_role
    self.role = :regular_user
  end

  # Roles End

  def comments_count
    result = 0
    if comments.empty?
      result = 0
    else
      if admin?
        result =  0
      else
        sum = 0
        result = articles.each do |article|
          sum = sum + article.comments.size
        end
        result = sum
      end
      return result
    end
  end

  def self.authenticate email, password
    if user = self.find_by(email: email)
      user if user.encrypted_password == BCrypt::Engine.hash_secret(password, user.salt)
    else
      nil
    end
  end

private

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end
end
