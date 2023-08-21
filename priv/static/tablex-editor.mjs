function initTablexEditors() {
  document
    .querySelectorAll('.tablex-editor')
    .forEach(el => initVisualEditor(el.id, JSON.parse(el.dataset.sheetData)));
}

function initVisualEditor(id, opts) {
  const el = document.getElementById(id);
  const options = {...opts, oneditionend: dispatch}
  const sheet = jspreadsheet(el, options);
  el.dataset.sheet = sheet;

  function dispatch() {
    const tablex = toTablex(sheet);
    const event = new CustomEvent("tablex:update", {
      bubbles: true,
      cancelable: true,
      detail: {data: tablex}
    });

    el.dispatchEvent(event);
  }

}

function toTablex(sheet) {
  const data = [sheet.getHeaders(true)].concat(sheet.getData());
  const tablex = data.map(row => row.map(function(value) {
    if (value === "") { return "-"; }

    if (typeof(value) === "string") {
      return maybeWrapQuote(value);
    }

    return value;
  }).join(" ")).join("\n");
  return tablex;
}

function maybeWrapQuote(str) {
  if (str[0] === '"' && str[str.length - 1] === '"') {
    return str;
  }

  if (str[0] === '"') {
    str = str.replace(/"/g, '\\"')
    return `"${str}"`;
  }

  if (str.match(/,/)) {
    return str;
  }

  if (str.match(/^\[.+\]$/)) {
    return str;
  }

  if (str.match(/ /)) {
    return `"${str}"`;
  }

  return str;
}

function getTablex(id) {
  return toTablex(document.getElementById(id).dataset.sheet);
}

export { initTablexEditors, getTablex };
