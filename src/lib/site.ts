/**
 * Build-time flags.
 *
 * Drafts are shown in `astro dev`, on Cloudflare preview builds (any branch
 * other than `main`, via the WORKERS_CI_BRANCH variable Workers Builds sets),
 * or when SHOW_DRAFTS=true is set explicitly.
 */
const branch = process.env.WORKERS_CI_BRANCH;

export const SHOW_DRAFTS =
  import.meta.env.DEV ||
  process.env.SHOW_DRAFTS === "true" ||
  (branch !== undefined && branch !== "main");

/** True only for the real production build. Gates analytics and indexing. */
export const IS_LIVE = import.meta.env.PROD && !SHOW_DRAFTS;

export const SITE = {
  author: "Maxime Filippini",
  email: "maxime.filippini@gmail.com",
  linkedin: "https://www.linkedin.com/in/maxime-filippini/",
  blogDescription:
    "Writing on quantitative risk, risk technology, and software systems.",
};
