class SearchController < ApplicationController
  before_filter :authenticate_user!
  
  def content_search
    @content_query = params[:content_query]
    @contents = DataContent.search_by_stream_name(@content_query).page(params[:page]).per(30) if @content_query.present?
  end
  
end
