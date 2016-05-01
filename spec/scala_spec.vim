source spec/helper.vim

describe "scala"

  before
    cd spec/fixtures/scala/
  end

  after
    call Teardown()
    cd -
  end

  it "switches to the test file"
    edit src/main/package/Hello.scala

    Twitch

    Expect expand('%') == './src/test/package/HelloTests.scala'
  end

  it "finds the production file"
    edit src/test/package/HelloTests.scala

    Twitch

    Expect expand('%') == 'src/main/package/Hello.scala'
  end
end
