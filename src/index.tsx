import { Hono } from "hono";
import type { FC } from "hono/jsx";
import { RootLayout } from "./layouts";

const app = new Hono();

const Top: FC<{ messages: string[] }> = (props: { messages: string[] }) => {
  return (
    <RootLayout title="hi" description="hi">
      <h1>Hello Hono!</h1>
      <ul>
        {props.messages.map((message) => {
          return <li>{message}!!</li>;
        })}
      </ul>
    </RootLayout>
  );
};

app.get("/", (c) => {
  const messages = ["Good Morning", "Good Evening", "Good Night"];
  return c.html(<Top messages={messages} />);
});

export default app;
