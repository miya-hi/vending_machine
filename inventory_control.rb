require './vending_machine'
require './sleep'

class InventoryControl
  include Sleep

  attr_accessor :drink

  def initialize
    @drink = {コーラ:{price:120, stock:5}, レッドブル:{price:200, stock:5}, 水:{price:100, stock:5}}
  end

  # 現在、自動販売機にある、商品名、値段、在庫本数を出力する
  def stock_information
    drink_information = []
    @drink.each do |key, value|
       drink_name = key
      value.each_value do |value|
        drink_information.push(value)
      end
      puts "商品名:#{drink_name}, 値段:#{drink_information[0]}円, 在庫本数:#{drink_information[1]}本"
      drink_information.clear
      sleep_time(1)
    end
  end

  # 既存のドリンクを１本増やす
  def existing_stock_addition
    puts "2.商品名を入力してください"
    drink = gets.chomp
    if drink_exists?(drink) == true
      @drink[:"#{drink}"][:stock]+= 1
      puts "ガチャン"
    else
      puts "登録にない商品です"
    end
    sleep_time(1)
  end

  # 自動販売機に登録されていない商品を登録する
  def new_stock_addition
    puts "3.商品名を入力してください"
    drink = gets.chomp
    if drink_exists?(drink) == true
      puts "すでに登録してある商品です"
    else
      puts "値段を入力してください"
      price = gets.tr('０-９','0-9').to_i
      puts "本数を入力してください"
      stock = gets.tr('０-９','0-9').to_i

      @drink[:"#{drink}"] = {price:price,stock:stock}
      puts "#{drink},#{price}円,#{stock}本を追加しました"
    end
    sleep_time(2)
  end

  # 登録しているドリンクの値段を変更できる
  def price_change
    puts "4.商品名を入力してください"
    drink = gets.chomp
    if drink_exists?(drink) == true
      puts "#{drink}の変更後の値段を入力してください"
      price = gets.tr('０-９','0-9').to_i
      @drink[:"#{drink}"][:price] = "#{price}".to_i
      puts "#{drink}の値段を#{price}円に変更しました"
    else
      puts "登録にない商品です"
    end
    sleep_time(1)
  end

  # 自販機にドリンクが登録されているかどうか
  def drink_exists?(drink)
    @drink.has_key?(:"#{drink}")
  end

end
