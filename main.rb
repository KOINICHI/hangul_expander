class Hangul
	attr_accessor :lead, :vowel, :tail, :code
	
	Leads = ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ']
	Vowels = ['ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ']
	Tails = ['　', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ']

	def initialize(c)
		@code = c.ord
		@lead = 0
		@vowel = 0
		@tail = 0
		if 44032 <= @code && @code <= 55203
			tail = (@code - 44032) % 28
			@tail = Tails[tail]
			@vowel = Vowels[((@code - 44032 - tail)%588)/28]
			@lead = Leads[(@code - 44032)/588]
		end
	end

	def is_hangul?
		@lead != 0
	end
end


class Expander
		
	def expand(str)
		str = str.split('')
		top = ''
		mid = ''
		bot = ''
		str.each do |c|
			h = Hangul.new(c)
			if not h.is_hangul?
				top += ' '
				mid += c
				bot += ' '
				next
			end

			lead1 = ''
			lead2 = h.lead
			if h.lead == 'ㄲ' || h.lead == 'ㄸ' || h.lead == 'ㅃ' || h.lead == 'ㅆ' || h.lead == 'ㅉ'
				lead2 = (lead2.ord - 1).chr('UTF-8')
				lead1 = lead2
			end

			vowel1 = h.vowel
			vowel2 = ''
			if vowel1 == 'ㅘ'
				vowel1 = 'ㅏ'
				vowel2 = 'ㅗ'
			elsif vowel1 == 'ㅙ'
				vowel1 = 'ㅐ'
				vowel2 = 'ㅗ'
			elsif vowel1 == 'ㅚ'
				vowel1 = 'ㅣ'
				vowel2 = 'ㅗ'
			elsif vowel1 == 'ㅝ'
				vowel1 = 'ㅓ'
				vowel2 = 'ㅜ'
			elsif vowel1 == 'ㅞ'
				vowel1 = 'ㅔ'
				vowel2 = 'ㅜ'
			elsif vowel1 == 'ㅟ'
				vowel1 = 'ㅣ'
				vowel2 = 'ㅜ'
			elsif vowel1 == 'ㅢ'
				vowel1 = 'ㅣ'
				vowel2 = 'ㅡ'
			elsif vowel1 == 'ㅗ' || vowel1 == 'ㅛ' || vowel1 == 'ㅜ' || vowel1 == 'ㅠ' || vowel1 == 'ㅡ'
				vowel2 = vowel1
				vowel1 = ''
			else
				vowel2 = ''
			end

			tail1 = ''
			tail2 = h.tail
			if tail2 == 'ㄲ'
				tail1 = 'ㄱ'
				tail2 = 'ㄱ'
			elsif tail2 == 'ㄳ'
				tail1 = 'ㄱ'
				tail2 = 'ㅅ'
			elsif tail2 == 'ㄵ'
				tail1 = 'ㄴ'
				tail2 = 'ㅈ'
			elsif tail2 == 'ㄶ'
				tail1 = 'ㄴ'
				tail2 = 'ㅎ'
			elsif tail2 == 'ㄺ'
				tail1 = 'ㄹ'
				tail2 = 'ㄱ'
			elsif tail2 == 'ㄻ'
				tail1 = 'ㄹ'
				tail2 = 'ㅁ'
			elsif tail2 == 'ㄼ'
				tail1 = 'ㄹ'
				tail2 = 'ㅂ'
			elsif tail2 == 'ㄽ'
				tail1 = 'ㄹ'
				tail2 = 'ㅅ'
			elsif tail2 == 'ㄾ'
				tail1 = 'ㄹ'
				tail2 = 'ㅌ'
			elsif tail2 == 'ㄿ'
				tail1 = 'ㄹ'
				tail2 = 'ㅍ'
			elsif tail2 == 'ㅀ'
				tail1 = 'ㄹ'
				tail2 = 'ㅎ'
			elsif tail2 == 'ㅄ'
				tail1 = 'ㅂ'
				tail2 = 'ㅅ'
			elsif tail2 == 'ㅆ'
				tail1 = 'ㅅ'
				tail2 = 'ㅅ'
			else
				tail1 = ''
			end


			#  '__' + '__' + '__' or
			#  '__' + '__'
			_top = lead1 + lead2 + vowel1
			_mid = (lead1.empty? ? '':'　')
			_bot = (lead1.empty? ? '':'　')
			if vowel2.empty?
				if tail2.empty?
					_mid += '　　'
				elsif tail1.empty?
					_mid += ' ' + tail2 + ' '
				else
					_mid += tail1 + tail2
				end
				_bot += '　　'
			else
				_mid += (vowel1.empty? ? '' : ' ') + vowel2 + (vowel1.empty? ? '' : ' ')
				if tail2.empty?
					_bot += '　　'
				elsif tail1.empty?
					_bot += (vowel1.empty? ? '' : ' ') + tail2 + (vowel1.empty? ? '' : ' ')
				else
					_bot += tail1 + tail2
					_top = ' ' + _top
					_mid = ' ' + _mid
				end
			end

			top += _top
			mid += _mid
			bot += _bot
		end
		top + "\n" + mid + "\n" + bot
	end

end

str = gets.strip

expander = Expander.new
expanded_str = expander.expand(str)
puts expanded_str
