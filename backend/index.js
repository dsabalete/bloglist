const config = require('./utils/config.js')
const logger = require('./utils/logger.js')
const seed = require('./utils/seed.js')

const start = async () => {
  await seed()

  const app = require('./app.js')

  app.listen(config.PORT, () => {
    logger.info(`Server running on port ${config.PORT}`)
  })
}

start()