module ApplicationHelper
  def title
    t = content_for(:title)

    if t.present?
      "#{t} · My MTG"
    else
      "My MTG"
    end
  end
end
