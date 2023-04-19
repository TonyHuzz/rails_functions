class MpgController < ApplicationController
  require 'digest'
  skip_before_action :verify_authenticity_token, only: [:return, :notify]

  def form
    merchantID = 'MS348675033'
    version = '2.0'
    respondType = 'JSON'
    timeStamp = Time.now.to_i.to_s
    merchantOrderNo = "Test" + Time.now.to_i.to_s
    amt = 100
    itemDesc = "金流串接test"
    hashKey = '0YInfrMwAlOxmtvzM6zFzmcqw5zKfAAa'
    hashIv = 'CAH4OMANQgPLuYXP'

    data = "MerchantID=#{merchantID}&RespondType=#{respondType}&TimeStamp=#{timeStamp}&Version=#{version}&MerchantOrderNo=#{merchantOrderNo}&Amt=#{amt}&ItemDesc=#{itemDesc}"

    data = addpadding(data)
    aes = encrypt_data(data, hashKey, hashIv, 'AES-256-CBC')
    checkValue = "HashKey=#{hashKey}&#{aes}&HashIV=#{hashIv}"

    @merchantID = merchantID
    @tradeInfo = aes
    @tradeSha = Digest::SHA256.hexdigest(checkValue).upcase
    @version = version
  end

  def notify
    Logger.new("#{Rails.root}/notify.log").try("info", params)
  end

  def return
    Logger.new("#{Rails.root}/return.log").try("info", params)
  end


  private

  def addpadding(data, blocksize = 32)
    len = data.length
    pad = blocksize - ( len % blocksize )
    data += pad.chr * pad
    return data
  end

  def encrypt_data(data, key, iv, cipher_type)
    cipher = OpenSSL::Cipher.new(cipher_type)
    cipher.encrypt
    cipher.key = key
    cipher.iv = iv
    encrypted = cipher.update(data) + cipher.final
    return encrypted.unpack("H*")[0].upcase
  end

end
