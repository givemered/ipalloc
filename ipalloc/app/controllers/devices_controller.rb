class DevicesController < ApplicationController
  def show
    ipblock = Ipblock.find(params[:address])
    if ipblock
      render json: ipblock, status: :ok
    else
      render json: {ip: params[:address], error: "NotFound"}, status: :not_found
    end
  end
end
