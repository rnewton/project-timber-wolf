require 'squib'
require_relative 'helpers'

data = Squib.xlsx(file: 'data/data.xlsx') { |col, item| newlineate(col, item) }
total = data['Name'].size
save_json data: data, cards: total, to: 'data/characters.json'

Squib::Deck.new(cards: total) do
  use_layout file: 'layouts/characters.yml'
  background color: :white
  rect layout: :cut
  svg file: 'character.svg'

  text str: data['Name'], layout: :title
  levels = data['Level'].map { |l| l == '1' ? "Amateur" : "Pro" }
  text layout: :Level, str: levels
  text layout: :Memory, str: data['Memory']
  text layout: :Ideas, str: data['Ideas'].map { |i| "#{i}💡"}

  text layout: :Default1, str: data['Default1']
  text layout: :Default2, str: data['Default2']
  text layout: :Default3, str: data['Default3']
  rect range: non_nil_indices(data['Default3']), layout: :Default3Rect

  text layout: :Special, str: data['Special']

  save_png prefix: 'character_'
  save_sheet prefix: 'character_sheet_', trim: '0.125in'
  save_pdf file: 'characters.pdf', trim: '0.125in'

  build :rulebook_figures do
    rect layout: :border
    %i(Level Memory Ideas Action1 Action2 Special Skill1 Skill2).each do |fig|
      text layout: "Figure#{fig}"
    end
    showcase range: 0,
             dir: 'rules', file: 'character_example.png',
             trim: 37.5, fill_color: '#0000', scale: 0.9
  end
end
