require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # TODO: generate random letters of letters
    @letters = Array.new(10)
    @letters.length.times do |row|
      @letters[row] = ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @chars = @word.upcase.chars

    @lts = params[:letters].gsub(' ', '').dup.chars

    @ans = true
    @chars.each do |c|
      @lts.include?(c) ? @lts.delete_at(@lts.index(c)) : @ans = false
    end

    @word_check = api_check(@word)['found']
    if @word_check == true && @ans == true
      @score = 100
    else
      @score = 0
    end

    if @word_check == true && @ans == true
      @message1 = 'can be made from'
      @message = 'Well done!'
    elsif @word_check == false && @ans == true
      @message1 = 'not an english word but CAN be made from'
      @message = 'not an english word'
    elsif @word_check == true && @ans == false
      @message1 = "can't be made from"
      @message = 'not in the grid'
    end
  end

  def api_check(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    JSON.parse(user_serialized)
  end
end
