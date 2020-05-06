class LinksController < ApplicationController

  def create
    link = Link.new link_params
    if link.save
      render json: {code: link.code}, status: :created
    else
      status = :bad_request if link.errors[:url].present?
      status = :conflict if link.errors[:code].include?('has already been taken')
      status = :unprocessable_entity if link.errors[:code].include?('is invalid')

      render json: {}, status: status
    end
  end

  def show
    link = Link.with_code! params[:code]
    link.increment_visits!
    redirect_to link.url
  rescue
    render nothing: true, status: 404
  end

  def stats
    link = Link.with_code! params[:code]
    render json: link.to_json, status: :ok
  rescue
    render nothing: true, status: 404
  end

  private

  def link_params
    params.permit(:code, :url)
  end

end
