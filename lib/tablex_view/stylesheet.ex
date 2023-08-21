defmodule TablexView.Stylesheet do
  def css do
    """
    table.tablex {
      border: solid;
      border-spacing: 0;
    }

    table.tablex th, table.tablex td {
      text-transform: none;
      vertical-align: middle;
    }

    table.tablex col.output {
      background-color: #EEE;
    }

    table.tablex, table.tablex th, table.tablex td {
      border-collapse: collapse;
    }

    table.tablex th, table.tablex td {
      padding: 0.5em;
      border: 1px solid;
      border-color: #DDD;
    }

    table.tablex.horinzontal th {
      border-bottom: double;
      font-weight: bold;
    }

    table.tablex th .stub-type {
      display: block;
      font-style: italic;
      font-weight: normal;
      color: var(--tablex-stub-type-color);
    }

    table.tablex td.input + td.output {
      border-left: double;
    }

    table.tablex td.rule-number + td.output {
      border-left: double;
    }

    table.tablex th.input + th.output {
      border-left: double;
    }

    table.tablex th.hit-policy {
      border-right: double;
    }

    table.tablex td.rule-number {
      color: var(--tablex-rule-number-color);
      border-right: double;
      text-align: center;
    }

    table.tablex.vertical tbody {
      border-top: double;
    }

    table.tablex.vertical tfoot {
      border-top: double;
    }

    table.tablex.vertical th.output {
      border-right: double;
    }

    table.tablex.vertical th.input {
      border-right: double;
    }

    table.tablex.vertical tfoot {
      background-color: #EEE;
    }

    table.tablex.vertical td[colspan] {
      text-align: center;
    }

    table.tablex.vertical tbody th {
      text-align: left;
    }

    table.tablex.vertical tfoot th {
      text-align: left;
    }

    .tbx-exp-true {
      font-weight: bold;
    }

    .tbx-exp-false {
      font-weight: normal;
      font-style: italic;
    }

    .tbx-exp-number {
      color: var(--tablex-exp-number-color);
    }

    .tbx-exp-string {
      color: var(--tablex-exp-string-color);
    }

    .tbx-exp-any {
      color: var(--tablex-exp-any-color);
    }

    .tbx-exp-list-sep {
      color: var(--tablex-exp-list-sep-color);
    }

    .tbx-square-bracket {
      color: var(--tablex-square-bracket-color);
    }
    """
  end
end
