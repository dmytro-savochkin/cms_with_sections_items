module ApplicationHelper
  def link_color?(hidden)
    return "muted" if hidden
    ""
  end

  def mark_required(class_object, attribute)
    return "*" if class_object.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
    ""
  end

  def errors_messages(errors, except)
    errors.
        messages.
        except(*except).
        to_a.map {|elem| elem.first.to_s + " " + elem.last.join(', ') + "<br>" unless elem.last.empty? }
  end

end
