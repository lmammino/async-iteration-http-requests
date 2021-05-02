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
