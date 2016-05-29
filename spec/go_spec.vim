source spec/helper.vim

describe "go"

  before
    cd spec/fixtures/go/
  end

  after
    call Teardown()
    cd -
  end

  it "switches to the test file"
    edit file.go

    Twitch

    Expect expand('%') == './file_test.go'
  end

  it "finds the production file"
    edit file_test.go

    Twitch

    Expect expand('%') == 'file.go'
  end

  it "works in a package"
    edit package/file.go

    Twitch

    Expect expand('%') == './package/file_test.go'
  end

  it "works for in another package"
    edit other/file.go

    Twitch

    Expect expand('%') == './other/file_test.go'
  end
end
