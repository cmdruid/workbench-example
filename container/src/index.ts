import { exec } from 'child_process'
import express, { Request, Response } from 'express'

const app  = express()
const port = 3300

app.use(express.text({ type: 'text/plain' }))

app.get('/ping', async (
  req : Request,
  res : Response
) => {
  return res.status(200).send('pong!')
})

app.get('/getinfo', async (
  req : Request,
  res : Response
) => {
  const cmd = 'bitcoin-cli -regtest -rpccookiefile=$DATA/bitcoin/regtest/.cookie getblockchaininfo'
  exec(cmd, (error, stdout, stderr) => {
    if (error) {
      console.error(`exec error: ${error}`)
      return res.status(500).send(`Server error: ${error}`)
    }
    if (stderr) {
      console.error(`stderr: ${stderr}`)
      return res.status(500).send(`Server error: ${stderr}`)
    }
    res.status(200).json(JSON.parse(stdout))
  })
})

app.listen(port, () => {
  console.log(`Listening on port ${port}...`)
})
