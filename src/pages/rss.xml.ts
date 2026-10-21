import rss from "@astrojs/rss";
import type { APIContext } from "astro";
import { getPosts } from "../lib/posts";
import { SITE } from "../lib/site";

export async function GET(context: APIContext) {
  const posts = await getPosts();
  return rss({
    title: `${SITE.author} — Blog`,
    description: SITE.blogDescription,
    site: context.site!,
    items: posts.map((post) => ({
      title: post.data.title,
      description: post.data.abstract,
      pubDate: post.data.posted_on,
      link: `/posts/${post.id}/`,
    })),
  });
}
