# frozen_string_literal: true

class GamesController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'date'

  def new
    @start_time = Time.now
    @score = params[:score]
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample
      @letters.sort!
    end
  end

  def score
    end_time = Time.now
    raise
    @attempt = params['word']
    start_time = params['start_time']
    grid = params['grid']
    @score = params['score'].to_f
    start_time = Time.parse(start_time)
    @result = { time: (end_time - start_time).round(2) }

    if english_word?(@attempt) == false
      @result[:message] = "Sorry but #{@attempt} does not seems to be an English word"
      @result[:score] = @score
    elsif check_grid?(@attempt, grid) == false
      @result[:message] = "Sorry but #{@attempt} can't be built out of #{grid}"
      @result[:score] = @score
    else

      @result[:score] = (((1 / @result[:time]) * @attempt.length) * 100).round(2) + @score
      @result[:message] = "CONGRATULATION, #{@attempt} is a valid English word"
    end
    @result
  end

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

  def check_grid?(attempt, grid)
    answer_array = attempt.upcase.split('')
    grid = grid.upcase.split('')
    answer_array.all? { |letter| answer_array.count(letter) <= grid.count(letter) }
  end
end
