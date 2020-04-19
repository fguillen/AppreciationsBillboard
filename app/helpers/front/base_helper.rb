module Front::BaseHelper
  include ApplicationHelper

  def front_menu_class(actual_menu_name)
    menus = {
      :appreciations => ["/front/appreciations.*"],
    }

    menu_class(menus, actual_menu_name)
  end

  def appreciation_pic(appreciation)
    if appreciation.pic.attached?
      appreciation.pic
    else
      select_default_pic(appreciation)
    end
  end

  def select_default_pic(appreciation)
    index = appreciation.uuid.each_byte.inject( &:+ )
    files = Dir["#{Rails.roog}/public/assets/app/front/appreciation_default_pics/*"]

    files[index % files.length]
  end
end

