require 'natto'

module MecabNatto
  AMOUNT_SAVE_WORDS = 500

  def analysis_text(text)
    natto     = Natto::MeCab.new
    word_hash = {}

    natto.parse(text) do |n|
      word_hash[n.surface] ? word_hash[n.surface] += 1 : word_hash[n.surface] = 1 if should_extract?(n.feature, n.surface)
    end

    words = word_hash.sort_by { |k, v| -v }
    delete_rare_used_words(words)
    words
  end

  private

  def should_extract?(feature, surface)
    feature =~ /名詞|形容詞|動詞/ &&
      feature !~ /非自立/ &&
      # surface.size > 1 &&
      surface !~ /\Aです\z|#|\Aない\z|\Aなっ\z|\Aます\z|\Aだっ\z|\Aたら\z|\Aなる\z|\Aある\z|\Aでし\z|\Aまし\z|\Aそう\z|\Aれる\z|\Aいっ\z|\Aする\z|\Aさん\z|\Aたい\z|\A[あ-んa-z〜ー\.\d]\z/
  end

  def delete_rare_used_words(words)
    words.delete_if { |k, v| v < 2 }
    words
  end
end
