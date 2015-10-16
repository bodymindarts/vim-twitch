source spec/helper.vim

describe "RSpec"

  before
    cd spec/fixtures/rspec
  end

  after
    call Teardown()
    cd -
  end

  it "switches to the spec file"
    edit ./lib/monkey_service.rb

    Twitch

    Expect expand('%:p:t') == 'monkey_service_spec.rb'
  end

  it "finds the production file"
    edit spec/monkey_service_spec.rb

    Twitch

    Expect expand('%:p:t') == 'monkey_service.rb'
  end

  it "works for rails folder structure"
    edit app/models/monkey.rb

    Twitch

    Expect expand('%:p:t') == 'monkey_spec.rb'
  end
end
