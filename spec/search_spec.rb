require 'spec_helper'

feature "Google Search" do

	SUBJECT = "Ada Lovelace"

	before do |example|
	  unless example.metadata[:skip_before]
			visit 'https://www.coinbr.net/bitcoins/o-mercado-de-bitcoins/'
			within("#market-table") do
				@foxbit = all(:xpath, "//table/tbody/tr")[2].text.split(" ")[0]
				@foxbit_value = all(:xpath, "//table/tbody/tr")[2].text.split(" ")[-2]
			end
			visit "/"
			fill_in "LoginDialog_loginInput", with: "leandroalemao"
			fill_in "LoginDialog_passwordInput", with: ENV['SPEEDY_PWD']
			find("#LoginDialog_cmdLogin").click
			@bitcoin_price = find("#base_currentprice").text
			@cotacao = (@foxbit_value.gsub(/[^\d\.]/, '').to_f / @bitcoin_price.to_f).round(4)
			@time = Time.now.strftime("%d/%m/%Y %H:%M")
	  end
	end

	it "sends an email" do
		visit "https://mandrillapp.com/compose"
		fill_in "username", with: "leandro.costantini@gmail.com"
		fill_in "password", with: ENV['MANDRILL_PWD']
		find_button("Log In").click
		fill_in "from", with: "bitcoin@leandroalemao.co.uk"
		fill_in "to", with: "leandro.costantini@gmail.com"
		fill_in "subject", with: "Bitcoin Ticker: " + @time
		@email_text = [@foxbit, @foxbit_value, @bitcoin_price, @cotacao].join(" ")
		page.execute_script("$(tinyMCE.editors[0].setContent('#{@email_text}'))")
		find_button("Send").click
	end
end
