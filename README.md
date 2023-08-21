# TablexView

A render that turns decistion tables in [Tablex][] into HTML.tables.

## Usage

```elixir
iex> table = Tablex.new("""
...>   F   Continent  Country  Province || Feature1 Feature2
...>   1   Asia       Thailand -        || true     true
...>   2   America    Canada   BC,ON    || -        true
...>   3   America    Canada   -        || true     false
...>   4   America    US       -        || false    false
...>   5   Europe     France   -        || true     -
...>   6   Europe     -        -        || false    true
...>   """)
...> 
...> TablexView.render(table)
"<table class=\"tablex horizontal\"><colgroup>\n<col span=\"1\" class=\"rule-number\">\n<col span=\"3\" class=\"input\">\n<col span=\"2\" class=\"output\">\n</colgroup>\n<thead><tr><th class=\"hit-policy hit-policy-F\">F</th><th class=input>Continent</th><th class=input>Country</th><th class=input>Province</th><th class=output>Feature1</th><th class=output>Feature2</th></tr></thead><tbody><tr><td class=rule-number>1</td><td class=\"input\"><span class=tbx-exp-string>Asia</span></td><td class=\"input\"><span class=tbx-exp-string>Thailand</span></td><td class=\"input\"><span class=tbx-exp-any>-</span></td><td class=\"output\"><span class=tbx-exp-true>yes</span></td><td class=\"output\"><span class=tbx-exp-true>yes</span></td></tr><tr><td class=rule-number>2</td><td rowspan=3 class=\"input\"><span class=tbx-exp-string>America</span></td><td rowspan=2 class=\"input\"><span class=tbx-exp-string>Canada</span></td><td class=\"input\"><span class=tbx-exp-list><span class=tbx-square-bracket>[</span><span class=tbx-exp-string>BC</span><span class=tbx-exp-list-sep>, </span><span class=tbx-exp-string>ON</span><span class=tbx-square-bracket>]</span></span></td><td class=\"output\"><span class=tbx-exp-any>-</span></td><td class=\"output\"><span class=tbx-exp-true>yes</span></td></tr><tr><td class=rule-number>3</td><td class=\"input\"><span class=tbx-exp-any>-</span></td><td class=\"output\"><span class=tbx-exp-true>yes</span></td><td class=\"output\"><span class=tbx-exp-false>no</span></td></tr><tr><td class=rule-number>4</td><td class=\"input\"><span class=tbx-exp-string>US</span></td><td class=\"input\"><span class=tbx-exp-any>-</span></td><td class=\"output\"><span class=tbx-exp-false>no</span></td><td class=\"output\"><span class=tbx-exp-false>no</span></td></tr><tr><td class=rule-number>5</td><td rowspan=2 class=\"input\"><span class=tbx-exp-string>Europe</span></td><td class=\"input\"><span class=tbx-exp-string>France</span></td><td class=\"input\"><span class=tbx-exp-any>-</span></td><td class=\"output\"><span class=tbx-exp-true>yes</span></td><td class=\"output\"><span class=tbx-exp-any>-</span></td></tr><tr><td class=rule-number>6</td><td class=\"input\"><span class=tbx-exp-any>-</span></td><td class=\"input\"><span class=tbx-exp-any>-</span></td><td class=\"output\"><span class=tbx-exp-false>no</span></td><td class=\"output\"><span class=tbx-exp-true>yes</span></td></tr></tbody></table>"
```

Output:

<table class="tablex horizontal"><colgroup>
<col span="1" class="rule-number">
<col span="3" class="input">
<col span="2" class="output">
</colgroup>
<thead><tr><th class="hit-policy hit-policy-F">F</th><th class=input>Continent</th><th class=input>Country</th><th class=input>Province</th><th class=output>Feature1</th><th class=output>Feature2</th></tr></thead><tbody><tr><td class=rule-number>1</td><td class="input"><span class=tbx-exp-string>Asia</span></td><td class="input"><span class=tbx-exp-string>Thailand</span></td><td class="input"><span class=tbx-exp-any>-</span></td><td class="output"><span class=tbx-exp-true>yes</span></td><td class="output"><span class=tbx-exp-true>yes</span></td></tr><tr><td class=rule-number>2</td><td rowspan=3 class="input"><span class=tbx-exp-string>America</span></td><td rowspan=2 class="input"><span class=tbx-exp-string>Canada</span></td><td class="input"><span class=tbx-exp-list><span class=tbx-square-bracket>[</span><span class=tbx-exp-string>BC</span><span class=tbx-exp-list-sep>, </span><span class=tbx-exp-string>ON</span><span class=tbx-square-bracket>]</span></span></td><td class="output"><span class=tbx-exp-any>-</span></td><td class="output"><span class=tbx-exp-true>yes</span></td></tr><tr><td class=rule-number>3</td><td class="input"><span class=tbx-exp-any>-</span></td><td class="output"><span class=tbx-exp-true>yes</span></td><td class="output"><span class=tbx-exp-false>no</span></td></tr><tr><td class=rule-number>4</td><td class="input"><span class=tbx-exp-string>US</span></td><td class="input"><span class=tbx-exp-any>-</span></td><td class="output"><span class=tbx-exp-false>no</span></td><td class="output"><span class=tbx-exp-false>no</span></td></tr><tr><td class=rule-number>5</td><td rowspan=2 class="input"><span class=tbx-exp-string>Europe</span></td><td class="input"><span class=tbx-exp-string>France</span></td><td class="input"><span class=tbx-exp-any>-</span></td><td class="output"><span class=tbx-exp-true>yes</span></td><td class="output"><span class=tbx-exp-any>-</span></td></tr><tr><td class=rule-number>6</td><td class="input"><span class=tbx-exp-any>-</span></td><td class="input"><span class=tbx-exp-any>-</span></td><td class="output"><span class=tbx-exp-false>no</span></td><td class="output"><span class=tbx-exp-true>yes</span></td></tr></tbody></table>


## Styles

Use the following code to print the CSS styles:

```elixir
TablexView.stylesheet()
```

There are a couple of color variables that can be defined:

```css
:root {
  --tablex-exp-string-color: blue;
  --tablex-exp-number-color: #aabbcc;
  --tablex-exp-true-color: #2f6f9f;
  --tablex-exp-false-color: #f9f2ce;
  --tablex-exp-any-color: #C0C0C0;
  --tablex-exp-list-sep-color: #333;
}
```

## Installation

```elixir
def deps do
  [
    {:tablex_view, github: "elixir-tablex/tablex_view"}
  ]
end
```

## Interactive Spreadsheet-like Editor

With editor you can modify the table in the browswer.

### Example setup in a Phoenix project

Add the following into your html template:

```html
<link phx-track-static rel="stylesheet" href="https://jsuites.net/v4/jsuites.css" type="text/css" />
<link phx-track-static rel="stylesheet" href="https://bossanova.uk/jspreadsheet/v4/jexcel.css" type="text/css" />

<script defer src="https://bossanova.uk/jspreadsheet/v4/jexcel.js"></script>
<script defer src="https://jsuites.net/v4/jsuites.js"></script>

<div id="my-tablex-editor-container" phx-update="ignore">
  <%= my_table.code |> Tablex.new() |> TablexView.render(mode: :editor, id: "my-tablex-editor") |> raw() %>
</div>
```

Add the following into your JavaScript file:

```js
import { initTablexEditors } from 'tablex_view';

initTablexEditors();
```

You can listen to the updates with:

```js
document.addEventListener('tablex:update', evt => {
  const tablex = evt.detail.data;
  ...
});
```

You can get the data using:

```js
import { getTablex } from 'tablex_view';

getTablex('my-tablex-editor');
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tablex_view>.

