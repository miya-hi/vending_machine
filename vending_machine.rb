# require '/Users/kanasakakoki/workspace/vending_machine_test/vending_machine.rb'
# machine = VendingMachine.new
# machine.main
# machine.admin_machine

require './inventory_control'
require './money_management'
require './sleep'

class VendingMachine
  include Sleep

  def initialize
    @money_management = MoneyManagement.new
    @inventory_control = InventoryControl.new
  end

  # 一般のお客様用
  def main
    puts "＜メニュー＞"
    puts "1.お金を入れる，2.商品を買う，3.お金払い戻し，9.自販機から離れる"
    puts "【¥#{@money_management.current_slot_money}】"
    number = gets.tr('０-９','0-9').to_i
    case number
    when 1 then
      puts "1.お金を入れる"
      puts "お金を入れてください(10,50,100,500,1000)"
      @money_management.money_entry
      main
    when 2 then
      puts "2.商品を買う"
      puts "【¥#{@money_management.current_slot_money}】"
      purchase if buyable? == true
      main
    when 3 then
      @money_management.return_money
    when 9 then
      puts "またのご利用お待ちしております"
    else
      puts "そんな番号ない"
      main
    end
  end

  # 購入
  def purchase
    puts "当たりでもう一本プレゼント！"
    sleep_time(1)
    puts "購入したいドリンク名を入力してください"
    drink_name = gets.chomp
    if @inventory_control.drink.has_key?(:"#{drink_name}") == false
      puts "#{drink_name}はありません"
    elsif @money_management.slot_money < @inventory_control.drink[:"#{drink_name}"][:price] || @inventory_control.drink[:"#{drink_name}"][:stock] == 0
      puts "購入できません"
    else
      @inventory_control.drink[:"#{drink_name}"][:stock] -= 1
      @money_management.slot_money -= @inventory_control.drink[:"#{drink_name}"][:price]
      @money_management.sales_total_amount += @inventory_control.drink[:"#{drink_name}"][:price]
      puts 'ガタンッ'
      puts '抽選中...'
      sleep_time(2)
      hit_or_miss(drink_name)
    end
    sleep_time(1)
  end

  # 当たりかハズレかを判定する
  def  hit_or_miss(drink_name)
    roulette = ['ハズレ','ハズレ','ハズレ','ハズレ','当たり'].shuffle
    if roulette[0] == '当たり' && @inventory_control.drink[:"#{drink_name}"][:stock] > 0
      @inventory_control.drink[:"#{drink_name}"][:stock] -= 1
      puts "当たり"
      puts "#{drink_name}をもう一本プレゼント！！"
    else
      puts "ハズレ"
    end
    sleep_time(1)
  end

  # 在庫数と投入金額で購入可能なドリンクを出力する
  def buyable?
    drink_buyable = []
    @inventory_control.drink.each do |item|
      drink_name = item[0]
      if @money_management.slot_money >= @inventory_control.drink[:"#{drink_name}"][:price] && @inventory_control.drink[:"#{drink_name}"][:stock] > 0
      drink_buyable << drink_name
      end
    end
    unless drink_buyable.empty?
      puts "#{drink_buyable.join(',')}が購入可能です"
      sleep_time(1)
      return true
    else
      puts "購入可能なドリンクはありません"
      sleep_time(1)
      return false
    end
  end

  # 管理者のパスワード入力
  def admin_machine
    puts "合言葉は？"
    keyword = gets.chomp
    if keyword == "admin"
      admin
    else
      puts "合言葉が間違っています"
    end
  end


  # 管理者用
  def admin
    puts "＜管理者メニュー＞"
    puts "1.在庫確認，2.商品追加，3.新規商品登録，4.値段変更，5.売上金確認，9.自販機から離れる"
    number = gets.tr('０-９','0-9').to_i
    case number
    when 1 then
      @inventory_control.stock_information
      admin
    when 2 then
      @inventory_control.existing_stock_addition
      admin
    when 3 then
      @inventory_control.new_stock_addition
      admin
    when 4 then
      @inventory_control.price_change
      admin
    when 5 then
      @money_management.current_sales
      admin
    when 9 then
      puts "お疲れ様でした"
    else
      puts "そんな番号ない"
      admin
    end
  end

end
