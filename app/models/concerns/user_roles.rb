module UserRoles
  ROLES_KEYS = %w(admin regular_user)

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
end
