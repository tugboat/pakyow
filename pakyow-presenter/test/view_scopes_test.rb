require 'support/helper'

class ViewScopesTest < MiniTest::Unit::TestCase

  def setup
    @view = create_view_from_string(<<-D)
    <div data-scope="post">
      <h1 data-prop="title">title</h1>
      <div>
        <p data-prop="body">body</p>
      </div>
      <div data-scope="comment"></div>
      <div data-scope="comment"></div>
    </div>
    D
  end

  def teardown
    # Do nothing
  end

  def test_single_scope_found
    assert_equal 1, @view.scope(:post).length
    assert_equal 1, @view.scope('post').length
  end

  def test_multiple_scopes_found
    assert_equal 2, @view.scope(:post).scope(:comment).length
  end

  def test_nested_scopes_found
    assert_equal 0, @view.scope(:comment).length
    assert_equal 2, @view.scope(:post).scope(:comment).length
  end

  def test_invalid_scopes_not_found
    assert_equal 0, @view.scope(:fail).length
  end

  def test_props_are_found
    assert_equal 'title', @view.scope(:post).prop(:title)[0].content
    assert_equal 'body', @view.scope(:post).prop(:body)[0].content
  end

  private

  def create_view_from_string(string)
    View.new(Nokogiri::HTML.fragment(string))
  end

end
