module Sleep

  # 引数で受け取った数字の秒数、待つ
  def sleep_time(seconds)
    sleep "#{seconds}".to_i
  end

end
