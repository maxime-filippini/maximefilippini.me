import { Child, FC, JSX, ReactElement } from "hono/jsx";

type RootProps = {
  children: any[];
  title: string;
  description: string;
};

export const RootLayout: FC<RootProps> = (props) => {
  return (
    <html>
      <head>
        <meta charset="UTF-8"></meta>
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1.0"
        ></meta>
        <meta property="og:description" content={props.description}></meta>
        <link rel="stylesheet" href="/static/app.css"></link>
        <title>{props.title}</title>
        <link
          rel="icon"
          href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>👨🏼‍💻</text></svg>"
        ></link>
        {/* <script src="/static/htmx.min.js"></script>
        <script
          src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"
          defer
        ></script> */}
      </head>
      <body>{props.children}</body>
    </html>
  );
};

// posthog_script,
// h.script(src=static_url("htmx.min.js")),
// h.script(
//     src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js",
//     defer=True,
// ),
// h.script(src=static_url("js/alpine_stuff.js")),
// h.script(src=static_url("js/theme_init.js")),
