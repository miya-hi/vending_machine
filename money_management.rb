require './vending_machine'
require './sleep'

class MoneyManagement
  include Sleep

  attr_accessor :slot_money, :sales_total_amount

  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    # 自動販売機に入っている金額
    @slot_money = 0
    #　売り上げ金額
    @sales_total_amount = 0
  end

  # 自動販売機に入っているお金を表示する
  def current_slot_money
    @slot_money
  end

  # 自動販売機にお金を入れる
  def money_entry
    money = gets.tr('０-９','0-9').to_i
    if MONEY.include?(money)
      @slot_money += money
      payment_sound(money)
    else
      puts "釣り銭: ¥#{money}"
    end
    sleep_time(1)
  end

  # お釣りを返して、自動販売機に入れたお金を０にする
  def return_money
    puts "釣り銭: ¥#{@slot_money}"
    @slot_money = 0
  end

  # 現在の売り上げ総額を出力する
  def current_sales
    puts "売り上げ総額: ¥#{@sales_total_amount}"
    sleep_time(2)
  end

  # お札を入れるとウィーン、小銭を入れるとチャリンと出力する
  def  payment_sound(money)
    if money == 1000
      puts "ウィーン"
    else
      puts "チャリン"
    end
  end

end

#　なぜtapメソッドが効かないのか？
  # def money_entry
  #   money = gets.to_i
  #   if MONEY.include?(money)
  #     "チャリン".tap { @slot_money += money }
  #   else
  #     p "入りません"
  #   end
  # end
