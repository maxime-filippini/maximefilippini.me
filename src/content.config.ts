import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";

const posts = defineCollection({
  // Each post is either `content/posts/<slug>.mdx` or, when it has images or
  // components of its own, `content/posts/<slug>/index.mdx`.
  loader: glob({
    base: "./content/posts",
    pattern: ["*.{md,mdx}", "*/index.{md,mdx}"],
    generateId: ({ entry }) => entry.replace(/(\/index)?\.mdx?$/, ""),
  }),
  schema: z
    .object({
      title: z.string(),
      abstract: z.string(),
      posted_on: z.coerce.date(),
      last_update: z.coerce.date().optional(),
      draft: z.boolean().default(true),
    })
    .transform((data) => ({
      ...data,
      last_update: data.last_update ?? data.posted_on,
    })),
});

export const collections = { posts };
