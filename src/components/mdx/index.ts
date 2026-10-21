// Components available in every post without an import.
import Callout from "./Callout.astro";
import Note from "./Note.astro";
import PostImage from "./PostImage.astro";
import YouTube from "./YouTube.astro";

export const mdxComponents = { Note, Callout, YouTube, img: PostImage };
