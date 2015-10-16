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
    edit app/model/monkey.rb

    Expect expand('%:p:t') == 'monkey.rb'
  end
end
