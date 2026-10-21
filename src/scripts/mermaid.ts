// Renders ```mermaid code blocks in the browser. The mermaid library is only
// downloaded on pages that actually contain a diagram.

const blocks = document.querySelectorAll<HTMLElement>("pre > code.language-mermaid");

if (blocks.length > 0) {
  const { default: mermaid } = await import("mermaid");

  const containers = [...blocks].map((code) => {
    const div = document.createElement("div");
    div.className = "mermaid-diagram";
    div.dataset.source = code.textContent ?? "";
    code.parentElement!.replaceWith(div);
    return div;
  });

  let run = 0;
  const render = async () => {
    const dark = document.documentElement.dataset.theme === "black";
    mermaid.initialize({ startOnLoad: false, theme: dark ? "dark" : "default" });
    run += 1;
    for (const [i, el] of containers.entries()) {
      const { svg } = await mermaid.render(`mermaid-${run}-${i}`, el.dataset.source!);
      el.innerHTML = svg;
    }
  };

  await render();
  document.addEventListener("themechange", render);
}

export {};
