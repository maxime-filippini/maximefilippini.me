# maximefilippini.me

Personal site and blog. Built with [Astro](https://astro.build) (static output),
MDX for posts, Svelte for interactive components, Tailwind + daisyUI for styling.
Hosted on Cloudflare Workers as static assets.

```
content/posts/        Blog posts (one folder per post, with its images and components)
src/pages/            Site pages: home, CV, contact, blog index, post template, RSS
src/components/mdx/   Components available in every post without importing them
src/lib/site.ts       Draft / production flags and site-wide constants
astro.config.ts       Markdown pipeline (code highlighting, maths, heading links)
wrangler.jsonc        Cloudflare Workers config
```

## Writing

```sh
bun install
bun run new "My post title"   # creates content/posts/my-post-title/index.mdx (as a draft)
bun run dev                   # http://localhost:4321, reloads as you type
```

Front matter:

```yaml
title: My post title
posted_on: 2026-10-21
last_update: 2026-11-02   # optional, defaults to posted_on
draft: true               # drafts never appear on the live site
abstract: >
    Shown on the blog index, in RSS and in link previews.
```

The folder name is the URL: `content/posts/my-post/` → `/posts/my-post/`.

### What you can use in a post

- **Images**: put them in the post folder and write `![alt](./image.png)`. They are
  resized and converted to WebP at build time; clicking opens the original.
- **Code**: fenced blocks are highlighted (Catppuccin Latte/Mocha). Flag lines as
  errors with `` ```ts lint="3 4" ``.
- **Diagrams**: `` ```mermaid `` blocks render in the browser and follow the theme.
- **Maths**: `$inline$` and `$$display$$` (KaTeX, rendered at build time).
- **Built-in components** (no import needed):
  `<Note>…</Note>`, `<Callout>…</Callout>`, `<YouTube url="https://www.youtube.com/embed/…" />`.
  Leave a blank line after the opening tag and before the closing tag so the
  content inside is parsed as Markdown.
- **Interactive components**: write a `.svelte` file next to the post, import it
  at the top of the MDX file and use it with a `client:` directive:

  ```mdx
  import MyChart from "./MyChart.svelte";

  <MyChart client:visible />
  ```

  `client:visible` loads its JavaScript only when it scrolls into view. See the
  draft `content/posts/interactive-var-explorer/` for a full example. Components
  reused across posts can live in `src/components/`.

## Publishing

Publishing is `git push`. Cloudflare Workers Builds watches the GitHub repo:

- **Push to `main`** → builds and deploys the live site. Drafts are excluded.
- **Push any other branch** → builds a preview with drafts included, at its own
  preview URL (marked `noindex`). Use this to proof-read a draft before merging.

To see the production build locally: `bun run preview` (builds, then serves with
Wrangler on http://localhost:8787). To include drafts in any build, set `SHOW_DRAFTS=true`.

## One-time Cloudflare setup

1. Push this repo to GitHub.
2. Cloudflare dashboard → **Workers & Pages** → **Create** → **Import a repository**,
   pick the repo, then set:
   - Build command: `bun run build`
   - Deploy command: `npx wrangler deploy` (default)
   - Preview (non-production branch) command: leave the default
   - Production branch: `main`
3. After the first deploy, check the site on its `*.workers.dev` URL.
4. To move the domain off the VPS, uncomment the `routes` entry in
   `wrangler.jsonc` and push. Cloudflare then points `maximefilippini.me` at the
   Worker (the domain's DNS is already on Cloudflare).
5. Once everything works, the VPS, the old webhook, and the `blog` R2 bucket
   (`r2.blog.maximefilippini.me`) can be retired. All images now live in this repo.
