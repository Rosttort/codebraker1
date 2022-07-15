# frozen_string_literal: true

module Codebraker
  include Validation
  include Constants
  RSpec.describe Validation do
    subject(:game) { Game.new name, difficulty }

    let(:name) { FFaker::Name.first_name }
    let(:difficulty) { DIFFICULTIES.keys.sample }

    describe 'player name error' do
      let(:long_name) { ('a'..'z').to_a.sample * MAX_NAME_LENGTH.next }
      let(:short_name) { ('a'..'z').to_a.sample * MIN_NAME_LENGTH.pred }

      it 'player name empty' do
        expect { game.player_name_validate!(short_name) }.to raise_error(WrongNameError)
      end

      it 'player name long' do
        expect { game.player_name_validate!(long_name) }.to raise_error(WrongNameError)
      end
    end

    describe 'code error' do
      let(:invalid_guesses) do
        [
          Validation::CODE_MIN.to_s * Constants::CODE_LENGTH.pred,
          Validation::CODE_MIN.to_s * Constants::CODE_LENGTH.next,
          Validation::CODE_MAX.next.to_s * Constants::CODE_LENGTH,
          ('a'..'z').to_a.sample * Constants::CODE_LENGTH,
          '?' * Constants::CODE_LENGTH
        ]
      end
      let(:empty_string) { ' ' }
      let(:not_string) do
        Array.new(Constants::CODE_LENGTH) do
          rand(Validation::CODE_MIN..Validation::CODE_MAX)
        end.join.to_i
      end

      it 'is empty' do
        expect { game.check_guess empty_string }.to raise_error(EmptyStringError)
      end

      it 'in not string' do
        expect { game.check_guess not_string }.to raise_error(WrongEntityError)
      end

      it 'is wrong code' do
        invalid_guesses.each do |invalid_guess|
          expect { game.check_guess invalid_guess }.to raise_error(InvalidGuessError)
        end
      end
    end

    describe 'difficulty error' do
      let(:player) { FFaker::Name.first_name }
      let(:wrong_difficulty) { FFaker::Internet.password }

      it 'raise error when wrong difficulty' do
        expect { game.validate_data(player, wrong_difficulty) }.to raise_error(WrongDifficultyError)
      end
    end
  end
end
