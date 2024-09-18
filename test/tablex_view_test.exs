defmodule TablexViewTest do
  use ExUnit.Case
  doctest TablexView
  doctest_file("README.md")

  describe "Rendering lists" do
    test "works" do
      table =
        Tablex.new("""
        F brand_id (integer) || attempts
        1 700                || 3
        2 152                || 4
        3 153                || 2
        4 150,131            || 3
        4 126,136            || 3
        5 -                  || 0
        """)

      expected = """
      <table class="tablex horizontal"><colgroup>
      <col span="1" class="rule-number">
      <col span="1" class="input">
      <col span="1" class="output">
      </colgroup>
      <thead><tr><th class="hit-policy hit-policy-F">F</th><th class=input>brand_id<span class=stub-type>(integer)</span></th><th class=output>attempts</th></tr></thead><tbody><tr><td class=rule-number>1</td><td class="input"><span class='tbx-exp-number tbx-exp-int'>700</span></td><td class="output"><span class='tbx-exp-number tbx-exp-int'>3</span></td></tr><tr><td class=rule-number>2</td><td class="input"><span class='tbx-exp-number tbx-exp-int'>152</span></td><td class="output"><span class='tbx-exp-number tbx-exp-int'>4</span></td></tr><tr><td class=rule-number>3</td><td class="input"><span class='tbx-exp-number tbx-exp-int'>153</span></td><td class="output"><span class='tbx-exp-number tbx-exp-int'>2</span></td></tr><tr><td class=rule-number>4</td><td class="input"><span class=tbx-exp-list><span class=tbx-square-bracket>[</span><span class='tbx-exp-number tbx-exp-int'>150</span><span class=tbx-exp-list-sep>, </span><span class='tbx-exp-number tbx-exp-int'>131</span><span class=tbx-square-bracket>]</span></span></td><td class="output"><span class='tbx-exp-number tbx-exp-int'>3</span></td></tr><tr><td class=rule-number>4</td><td class="input"><span class=tbx-exp-list><span class=tbx-square-bracket>[</span><span class='tbx-exp-number tbx-exp-int'>126</span><span class=tbx-exp-list-sep>, </span><span class='tbx-exp-number tbx-exp-int'>136</span><span class=tbx-square-bracket>]</span></span></td><td class="output"><span class='tbx-exp-number tbx-exp-int'>3</span></td></tr><tr><td class=rule-number>5</td><td class="input"><span class=tbx-exp-any>-</span></td><td class="output"><span class='tbx-exp-number tbx-exp-int'>0</span></td></tr></tbody></table>
      """

      assert String.trim_trailing(expected) == TablexView.render(table)
    end
  end
end
