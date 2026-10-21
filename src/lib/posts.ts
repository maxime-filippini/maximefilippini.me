import { getCollection, type CollectionEntry } from "astro:content";
import { SHOW_DRAFTS } from "./site";

export type Post = CollectionEntry<"posts">;

/** Posts visible in this build, most recently updated first. */
export async function getPosts(): Promise<Post[]> {
  const posts = await getCollection("posts", ({ data }) => SHOW_DRAFTS || !data.draft);
  return posts.sort(
    (a, b) => b.data.last_update.getTime() - a.data.last_update.getTime(),
  );
}

export function formatDate(date: Date): string {
  return date.toISOString().slice(0, 10);
}
