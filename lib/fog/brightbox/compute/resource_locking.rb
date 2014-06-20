module ResourceLocking
  def locked?
    false
  end

  def lock!
    requires :identity
    service.send(:"lock_resource_#{resource_name}", identity)
  end

  def unlock!
    requires :identity
    service.send(:"unlock_resource_#{resource_name}", identity)
  end
end
