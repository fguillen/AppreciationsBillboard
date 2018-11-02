module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def header_content(header_title, header_text = nil)
    @header_title = header_title
    @header_text =  header_text
  end
end
