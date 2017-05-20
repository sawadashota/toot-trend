namespace :toots do
  require ENV['PWD'] + '/app/controllers/concerns/mecab_natto'
  require ENV['PWD'] + '/app/controllers/concerns/request_mastodon'
  include RequestMastodon
  include MecabNatto

  desc 'Fetch toots'

  task fetch: :environment do
    old_date = Time.current.ago(3.days).strftime('%Y-%m-%d %T')
    toots    = Toot.where(:updated_at.lt => old_date) + Toot.where(:words.exists => false)

    toots.each do |toot|
      toot.update(updating: true)
      puts toot.instance + ' : ' + toot.updated_at.strftime('%Y.%m.%d %T')
      words = analysis_text(fetch_posts(toot.instance))
      toot.update(words: words, updating: false)
    end
  end
end
