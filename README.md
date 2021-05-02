# async-iteration-http-requests

Playing around with async iterators with HTTP servers.

## Rationale

You can use `for await...of` to handle HTTP requests using the Node.js HTTP server:

```javascript
import { createServer } from 'http'
import { on } from 'events'

const server = createServer()
server.listen(8000, console.log)

for await (const [req, res] of on(server, 'request')) {
  console.log(req.url)
  res.end('hello')
}
```

This is an interesting pattern that has been popularised by the likes of Deno and you can easily achieve the same behaviour also in Node.js.

The problem is that, if you use `await` inside the `for await...of` loop, you essentially end up handling all the incoming requests in series (a.k.a. no concurrency!) and this can severely affect the performance of you server.

For example:

```javascript
import { createServer } from 'http'
import { on } from 'events'
import { setTimeout } from 'timers/promises'

const server = createServer()
server.listen(8000, console.log)

for await (const [, res] of on(server, 'request')) {
  await setTimeout(1000)
  res.end('hello')
}
```

This code is a BAD IDEA for the use case of HTTP servers!

You should not await inside a `for await...of` if you want concurrency!

A better approach would be:

```javascript
import { createServer } from 'http'
import { on } from 'events'
import { setTimeout } from 'timers/promises'

async function handleRequest (req, res) {
  await setTimeout(1000)
  res.end('hello')
}

const server = createServer()
server.listen(8000, console.log)

for await (const [req, res] of on(server, 'request')) {
  handleRequest(req, res) // NOTE: no await!
}
```

Which delegates `handleRequest` to deal with the request but it does not await it's result!

This repository provides a set of examples and a benchmark script to validate what's stated above.

More details are available on Twitter:

  - [Original Tweet](https://twitter.com/loige/status/1388879048617590790)
  - [Second tweet with more details](https://twitter.com/loige/status/1388888755495387137)

Make sure to check out all the awesome comments!

## Install

You will need Node.js 16+.

Then you'll need to install the needed dependencies with:

```bash
npm install
```

## Code examples:

They are all in the [`src`](/src) folder.

  - `http-server-classic.js`: it's a simple server that does not use `for await...of`
  - `http-server-iterator-await.js`: uses `for await...of` and uses `await` inside the loop, therefore exposing the performance degradation discussed above.
  - `http-server-iterator-no-await.js`: uses `for await...of` but does not await inside the loop. In this case performances are not degraded.


## Run the benchmark

On linux or macOs run `./benchmark.sh` or `npm run benchmark`.

## Contributing

Everyone is very welcome to contribute to this project.
You can contribute just by submitting bugs or suggesting improvements by
[opening an issue on GitHub](https://github.com/lmammino/async-iteration-http-requests/issues).

## License

Licensed under [MIT License](LICENSE). © Luciano Mammino.


## Shameless plug 😇

<a href="https://www.nodejsdesignpatterns.com"><img width="240" align="right" src="https://github.com/lmammino/lmammino/blob/master/nodejsdp.jpg?raw=true"></a>

If you like this piece of work, consider supporting me by getting a copy of [Node.js Design Patterns, Third Edition](https://www.nodejsdesignpatterns.com/), which also goes into great depth about Streams and related design patterns.

If you already have this book, **please consider writing a review** on Amazon, Packt, GoodReads or in any other review channel that you generally use. That would support us greatly 🙏.
