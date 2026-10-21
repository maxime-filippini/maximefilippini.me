import type { ShikiTransformer } from "shiki";

/**
 * Highlights lines flagged in the code fence meta, e.g.
 *
 *   ```ts lint="11 12 13"
 *
 * Each listed line gets the `lint-error` class (styled in global.css).
 */
export function lintLines(): ShikiTransformer {
  return {
    name: "lint-lines",
    line(node, line) {
      const meta = this.options.meta?.__raw ?? "";
      const match = meta.match(/lint="([\d\s]+)"/);
      if (!match) return;
      const flagged = match[1].trim().split(/\s+/).map(Number);
      if (flagged.includes(line)) this.addClassToHast(node, "lint-error");
    },
  };
}
