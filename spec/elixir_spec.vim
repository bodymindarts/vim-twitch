source spec/helper.vim

describe "Elixir"

  before
    cd spec/fixtures/elixir
  end

  after
    call Teardown()
    cd -
  end

  it "switches to the spec file"
    edit lib/potion.ex

    Twitch

    Expect expand('%:p:t') == 'potion_test.exs'
  end

  it "finds the production file"
    edit test/potion_test.exs

    Twitch

    Expect expand('%:p:t') == 'potion.ex'
  end
end
