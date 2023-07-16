module ApplicationHelper

  def by_admin?
    user = Thread.current[:user]
    user.try(:admin?)
  end

  def by_customer?
    user = Thread.current[:user]
    user.try(:customer?)
  end
end
