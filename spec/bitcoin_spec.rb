require 'spec_helper'

feature "Bitcoin Exchange Rate Search" do

	before do |example|
	  unless example.metadata[:skip_before]
			visit 'https://www.coinbr.net/bitcoins/o-mercado-de-bitcoins/'
			within("#market-table") do
				all(:xpath, "//table/tbody/tr").each do |a|
					if a.text.match(/^Foxbit/)
						@foxbit = a.text.split(" ")[0]
						@foxbit_min_value = a.text.split(" ")[-2]
						@foxbit_max_value = format("R$%.2f",((a.text.split(" ")[1].gsub(/[^\d\.]/, '').to_f / 1.0124) / 1.0124).round(2))
					end
				end
			end
			visit "/"
			fill_in "LoginDialog_loginInput", with: ENV['SPEEDY_USR']
			fill_in "LoginDialog_passwordInput", with: ENV['SPEEDY_PWD']
			find("#LoginDialog_cmdLogin").click
			@bitcoin_price = find("#base_currentprice").text
			@min_cotacao = (@foxbit_min_value.gsub(/[^\d\.]/, '').to_f / @bitcoin_price.to_f).round(4)
			@max_cotacao = (@foxbit_max_value.gsub(/[^\d\.]/, '').to_f / @bitcoin_price.to_f).round(4)
			@time = Time.now.strftime("%d/%m/%Y %H:%M")
	  end
	end

	it "sends an email" do
		visit "https://mandrillapp.com/compose"
		fill_in "username", with: ENV['MANDRILL_USR']
		fill_in "password", with: ENV['MANDRILL_PWD']
		find_button("Log In").click
		fill_in "from", with: "bitcoin@leandroalemao.co.uk"
		fill_in "to", with: "leandro.costantini@gmail.com"
		fill_in "subject", with: "Bitcoin Ticker: " + @time
		@email_text = [@foxbit, @foxbit_min_value, @foxbit_max_value, @bitcoin_price, @min_cotacao, @min_cotacao].join(" ")
		page.execute_script("$(tinyMCE.editors[0].setContent('#{@email_text}'))")
		find_button("Send").click
	end
end
