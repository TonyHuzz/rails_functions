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
    hashIV = 'CAH4OMANQgPLuYXP'

    data = "MerchantID=#{merchantID}&RespondType=#{respondType}&TimeStamp=#{timeStamp}&Version=#{version}&MerchantOrderNo=#{merchantOrderNo}&Amt=#{amt}&ItemDesc=#{itemDesc}"

    data = addpadding(data)
    aes = encrypt_data(data, hashKey, hashIV, 'AES-256-CBC')
    checkValue = "HashKey=#{hashKey}&#{aes}&HashIV=#{hashIV}"

    @merchantID = merchantID
    @tradeInfo = aes
    @tradeSha = Digest::SHA256.hexdigest(checkValue).upcase
    @version = version
  end

  def notify
    hashKey = '0YInfrMwAlOxmtvzM6zFzmcqw5zKfAAa'
    hashIV = 'CAH4OMANQgPLuYXP'

    if params["Status"] == "SUCCESS"

      tradeInfo = params["TradeInfo"]
      tradeSha = params["TradeSha"]

      checkValue = "HashKey=#{hashKey}&#{tradeInfo}&HashIV=#{hashIV}"
      if tradeSha == Digest::SHA256.hexdigest(checkValue).upcase
        rawTradeInfo = decrypt_data(tradeInfo, hashKey, hashIV, 'AES-256-CBC')
        result = JSON.parse(rawTradeInfo)
        Logger.new("#{Rails.root}/notify.log").try("info", result)
      end
    end

    respond_to do |format|
      format.json {render json: {result: "success"}}
    end
  end

  def return
    hashKey = '0YInfrMwAlOxmtvzM6zFzmcqw5zKfAAa'
    hashIV = 'CAH4OMANQgPLuYXP'

    if params["Status"] == "SUCCESS"

      tradeInfo = params["TradeInfo"]
      tradeSha = params["TradeSha"]

      checkValue = "HashKey=#{hashKey}&#{tradeInfo}&HashIV=#{hashIV}"
      if tradeSha == Digest::SHA256.hexdigest(checkValue).upcase
        rawTradeInfo = decrypt_data(tradeInfo, hashKey, hashIV, 'AES-256-CBC')
        result = JSON.parse(rawTradeInfo)
        Logger.new("#{Rails.root}/return.log").try("info", result)
      end
    end

    redirect_to :root
  end

  def customer
    hashKey = '0YInfrMwAlOxmtvzM6zFzmcqw5zKfAAa'
    hashIV = 'CAH4OMANQgPLuYXP'

    if params["Status"] == "SUCCESS"

      tradeInfo = params["TradeInfo"]
      tradeSha = params["TradeSha"]

      checkValue = "HashKey=#{hashKey}&#{tradeInfo}&HashIV=#{hashIV}"
      if tradeSha == Digest::SHA256.hexdigest(checkValue).upcase
        rawTradeInfo = decrypt_data(tradeInfo, hashKey, hashIV, 'AES-256-CBC')
        result = JSON.parse(rawTradeInfo)
        Logger.new("#{Rails.root}/customer.log").try("info", result)
      end
    end

    redirect_to :root
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

  def removedPadding(data)
    blocksize = 32
    loop do
      lastHex = data.last.bytes.first
      break if lastHex >= blocksize
      data = data[0...-1]
    end
    return data
  end

  def decrypt_data(data, key, iv, cipher_type)
    cipher = OpenSSL::Cipher.new(cipher_type)
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv
    packedData = [data.downcase].pack('H*')
    data = removedPadding(cipher.update(packedData))
    return data + cipher.final
  end

end
