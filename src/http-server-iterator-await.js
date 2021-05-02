import { createServer } from 'http'
import { on } from 'events'
import { setTimeout } from 'timers/promises'

const server = createServer()
server.listen(8000, console.log)

for await (const [, res] of on(server, 'request')) {
  await setTimeout(1000)
  res.end('hello')
}
