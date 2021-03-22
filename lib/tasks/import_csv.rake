require 'csv'

namespace :import_csv do
  
  desc "CSVデータをインポートするタスク"

  task users: :environment do
    #インポートするファイルのパスを取得
    path = "db/csv_data/csv_data.csv"
    #インポートするデータを格納するための配列
    list = []
    #csvファイルから1行ずつデータを取得し、ハッシュ化して配列に格納
    CSV.foreach(path, headers: true) do |row|
      list << row.to_h
    end
    puts "インポート処理を開始"
    begin
      User.transaction do
        User.create!(list)
      end
      puts "インポート完了".green
    rescue StandardError => e
      # 例外が発生した場合の処理
      # インポートができなかった場合の例外処理
      puts "#{e.class}: #{e.message}".red
      puts "-------------------------"
      puts e.backtrace # 例外が発生した位置情報
      puts "-------------------------"
      puts "インポートに失敗".red
    end
  end
end
