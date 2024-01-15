# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  private

  def fetch_limit
    params[:limit].present? ? params[:limit].to_i : 10
  end

  def fetch_page
    params[:page].present? ? params[:page].to_i : 1
  end

  def paginate(query)
    limit = fetch_limit
    page = fetch_page
    offset = page.positive? ? (page - 1) * limit : 0
    query.limit(limit).offset(offset)
  end
end
