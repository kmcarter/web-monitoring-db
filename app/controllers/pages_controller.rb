PAGE_SIZE = 500

class PagesController < ApplicationController
  def index
    @paging = pagination(VersionistaPage.all)
    @pages = VersionistaPage.order(updated_at: :desc).limit(PAGE_SIZE).offset(@paging[:offset])

    respond_to do |format|
      format.html
      format.json do
        render json: {
          links: @paging[:links],
          data: @pages
        }
      end
    end
  end

  def show
    @page = VersionistaPage.find(params[:id])
    respond_to do |format|
      format.html do
        @paging = pagination(@page.versions, :pages_page_path)
        @versions = @page.versions.limit(PAGE_SIZE).offset(@paging[:offset])
      end

      format.json do
        render json: {
          data: @page.as_json(include: :versions)
        }
      end
    end
  end

  protected

  # Undoubtedly there is a gem that makes this nicer
  def pagination(collection=nil, path_resolver=nil)
    unless collection
      collection = @collection || VersionistaPage.all
    end

    unless path_resolver
      path_resolver = :pages_path
    end

    if path_resolver.kind_of? Symbol
      resolver_symbol = path_resolver
      path_resolver = lambda {|*args| self.send resolver_symbol, *args}
    end

    format_type = request.format.to_sym
    total_items = collection.count
    total_pages = total_items == 0 ? 1 : (total_items / PAGE_SIZE.to_f).ceil
    page_number = (params[:page] || 1).to_i.clamp(1, total_pages)
    page_offset = (page_number - 1) * PAGE_SIZE

    links = {
      first: path_resolver.call(nil, page: 1, format: format_type),
      last: path_resolver.call(nil, page: total_pages, format: format_type),
      prev: nil,
      next: nil
    }
    if page_number > 1
      links[:prev] = path_resolver.call(nil, page: page_number - 1, format: format_type)
    end
    if page_number < total_pages
      links[:next] = path_resolver.call(nil, page: page_number + 1, format: format_type)
    end

    {
      pages: total_pages,
      page_number: page_number,
      offset: page_offset,
      total_items: total_items,
      page_items: PAGE_SIZE,
      links: links
    }
  end

  def pages_page_path(item, *args)
    page_path(@page, *args)
  end
end
