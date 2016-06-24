RakutenWebService.configuration do |c|
  # rakuten_web_serviceのGemを使用するには初期起動時に取得したアプリIDを設定する必要あり
  c.application_id = Rails.application.secrets.rakuten_application_id
  c.affiliate_id = Rails.application.secrets.rakuten_affiliate_id
end