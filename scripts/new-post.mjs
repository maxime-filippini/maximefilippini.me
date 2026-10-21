#!/usr/bin/env node
// Scaffolds a new draft post: `bun run new "My post title"`
import { existsSync, mkdirSync, writeFileSync } from "node:fs";

const title = process.argv.slice(2).join(" ").trim();
if (!title) {
  console.error('Usage: bun run new "My post title"');
  process.exit(1);
}

const slug = title
  .toLowerCase()
  .normalize("NFKD")
  .replace(/[̀-ͯ]/g, "")
  .replace(/[^a-z0-9]+/g, "-")
  .replace(/^-|-$/g, "");
const dir = `content/posts/${slug}`;

if (existsSync(dir)) {
  console.error(`${dir} already exists`);
  process.exit(1);
}

const today = new Date().toISOString().slice(0, 10);
mkdirSync(dir, { recursive: true });
writeFileSync(
  `${dir}/index.mdx`,
  `---
title: ${JSON.stringify(title)}
posted_on: ${today}
draft: true
abstract: >
    One or two sentences shown on the blog index and in link previews.
---

Start writing here.
`,
);
console.log(`Created ${dir}/index.mdx`);
