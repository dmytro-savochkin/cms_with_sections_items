module ApplicationHelper
  def client_panel?
    controller.module_name == "Client"
  end

  def panel_name
    controller.module_name.downcase
  end

  def login_provider_in_brackets(user = current_user)
    bracketize(user.provider.split("_").first.titleize)
  end

  def bracketize(text)
    "[" + text + "]"
  end

  def user_avatar_and_name(user)
    link = ""
    link += user_avatar(user)
    link += user_name(user)
  end

  def user_avatar(user)
    unless user.image.empty?
      return image_tag(user.image, :alt => t('models.item.comment.user.avatar.alt'), :class => %w(pull-left user-avatar))
    end
    ""
  end

  def user_name(user)
    user.name.strip
  end


  def breaking_word_wrap(txt, col = 80)
    txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "\\1\\3\n")
  end







  def link_color?(hidden)
    return "muted" if hidden
    ""
  end

  def mark_required(class_object, attribute)
    return "*" if class_object.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
    ""
  end


  def photo_errors
    photo_errors = []
    @item.errors.keys.select{|e| e.to_s.include?("photo_")}.each do |key|
      photo_errors << @item.errors.messages[key].join(", ").to_s
    end
    return "" if photo_errors.empty?
    t('models.item.photo') + " " + photo_errors.join(', ')
  end

  def errors_messages(errors, except)
    errors.
        messages.
        except(*except).
        to_a.map {|elem| elem.first.to_s + " " + elem.last.join(', ') + "<br>" unless elem.last.empty? }
  end

end
