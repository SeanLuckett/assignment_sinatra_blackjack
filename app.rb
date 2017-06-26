require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'

require 'pry-byebug'

enable :sessions

# Avoid warning: http://stackoverflow.com/a/18047653/5113832
set :session_secret, '*&(^B234'

get '/' do
  session[:deck] = [].to_json
  erb :home
end

get '/blackjack' do
  deck = Deck.new(JSON.parse(session[:deck]))
  player_hand = []
  dealer_hand = []

  2.times do
    player_hand << deck.top_card
    dealer_hand << deck.top_card
  end

  session[:deck] = deck.cards.to_json

  erb :blackjack, locals: { player_hand: player_hand, dealer_hand: dealer_hand }
end

class Deck
  attr_reader :cards

  def initialize(deck)
    @cards = deck.empty? ? build_deck.shuffle : deck
  end

  def top_card
    @cards.pop
  end

  private

  def build_deck
    ranks = %w(A 1 2 3 4 5 6 7 8 9 10 J K Q)
    suits = %w(&heartsuit; &diamondsuit; &spadesuit; &clubsuit;)
    ranks.product(suits)
  end

end