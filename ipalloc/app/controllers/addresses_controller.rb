class AddressesController < ApplicationController

  def assign
    device = Ipblock.new(address_params)
    if device.save
      puts "Device saved"
      render json: device, status: :created
    else
      puts "Device not saved"
      render json: device, status: :bad_request
    end
  end

  private

  def address_params
    params.permit(:ip, :device)
  end
end
