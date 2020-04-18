module Front::BaseHelper
  include ApplicationHelper

  def front_menu_class(actual_menu_name)
    menus = {
      :appreciations => ["/front/appreciations.*"],
    }

    menu_class(menus, actual_menu_name)
  end
end

