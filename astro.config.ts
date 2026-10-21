import { defineConfig } from "astro/config";
import mdx from "@astrojs/mdx";
import svelte from "@astrojs/svelte";
import sitemap from "@astrojs/sitemap";
import tailwindcss from "@tailwindcss/vite";
import { rehypeHeadingIds, unified } from "@astrojs/markdown-remark";
import rehypeAutolinkHeadings from "rehype-autolink-headings";
import rehypeKatex from "rehype-katex";
import remarkMath from "remark-math";

import { permalinkIcon } from "./src/lib/markdown/permalink-icon";
import { lintLines } from "./src/lib/markdown/shiki-lint-lines";

export default defineConfig({
  site: "https://maximefilippini.me",
  integrations: [mdx(), svelte(), sitemap()],
  vite: {
    plugins: [tailwindcss()],
    // Mermaid is large, but it is lazy-loaded only on pages with diagrams.
    build: { chunkSizeWarningLimit: 2000 },
  },
  markdown: {
    // Astro 7 defaults to its new "Sätteri" pipeline. We use the classic
    // remark/rehype one so the wider plugin ecosystem (KaTeX, etc.) works.
    processor: unified({
      remarkPlugins: [remarkMath],
      rehypePlugins: [
        rehypeKatex,
        rehypeHeadingIds,
        [
          rehypeAutolinkHeadings,
          {
            behavior: "append",
            properties: { class: "heading-anchor", ariaLabel: "Permalink" },
            content: permalinkIcon,
          },
        ],
      ],
    }),
    // Mermaid diagrams are rendered in the browser (see src/scripts/mermaid.ts).
    syntaxHighlight: { type: "shiki", excludeLangs: ["mermaid", "math"] },
    shikiConfig: {
      themes: { light: "catppuccin-latte", dark: "catppuccin-mocha" },
      // Colours come from CSS variables so they follow the site's theme toggle.
      defaultColor: false,
      langAlias: { pytb: "python" },
      transformers: [lintLines()],
    },
  },
});
