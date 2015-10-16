source spec/helper.vim

describe "clojure"

  before
    cd spec/fixtures/clojure/
  end

  after
    call Teardown()
    cd -
  end

  it "switches to the test file"
    edit src/namespace/core.clj

    Twitch

    Expect expand('%') == './test/namespace/core_test.clj'
  end

  it "finds the production file"
    edit test/namespace/core_test.clj

    Twitch

    Expect expand('%') == 'src/namespace/core.clj'
  end

  it "works for other namespace"
    edit test/other/core.clj

    Twitch

    Expect expand('%') == './src/other/core.clj'
  end
end
