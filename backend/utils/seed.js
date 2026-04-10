const bcrypt = require('bcrypt')
const mongoose = require('mongoose')
const User = require('../models/user.js')
const Blog = require('../models/blog.js')
const config = require('./config.js')

const seed = async () => {
  const isConnected = mongoose.connection.readyState === 1
  let shouldDisconnect = false

  if (!isConnected) {
    await mongoose.connect(config.MONGODB_URI)
    shouldDisconnect = true
  }

  const existingUsers = await User.countDocuments()
  if (existingUsers > 0) {
    console.log('Database already has data, skipping seed')
    if (shouldDisconnect) {
      await mongoose.disconnect()
    }
    return false
  }

  const passwordHash = await bcrypt.hash('password123', 10)

  const user1 = new User({ username: 'david', name: 'David Sabalete', passwordHash })
  const user2 = new User({ username: 'alice', name: 'Alice Johnson', passwordHash })
  const user3 = new User({ username: 'bob', name: 'Bob Smith', passwordHash })

  const savedUsers = await User.insertMany([user1, user2, user3])

  const blogData = [
    { title: 'Getting Started with Docker', author: 'David Sabalete', url: 'https://blog.davidsabalete.com/docker-getting-started', likes: 42, user: savedUsers[0]._id },
    { title: 'Understanding React Hooks', author: 'Alice Johnson', url: 'https://blog.alice.com/react-hooks-guide', likes: 28, user: savedUsers[1]._id },
    { title: 'Node.js Best Practices', author: 'Bob Smith', url: 'https://bob.dev/nodejs-best-practices', likes: 15, user: savedUsers[2]._id },
    { title: 'Express.js Middleware Explained', author: 'David Sabalete', url: 'https://blog.davidsabalete.com/express-middleware', likes: 33, user: savedUsers[0]._id },
    { title: 'MongoDB Indexing Strategies', author: 'Alice Johnson', url: 'https://blog.alice.com/mongodb-indexing', likes: 19, user: savedUsers[1]._id },
    { title: 'Building a REST API from Scratch', author: 'Bob Smith', url: 'https://bob.dev/rest-api-guide', likes: 56, user: savedUsers[2]._id },
  ]

  const savedBlogs = await Blog.insertMany(blogData)

  await User.findByIdAndUpdate(savedUsers[0]._id, { blogs: [savedBlogs[0]._id, savedBlogs[3]._id] })
  await User.findByIdAndUpdate(savedUsers[1]._id, { blogs: [savedBlogs[1]._id, savedBlogs[4]._id] })
  await User.findByIdAndUpdate(savedUsers[2]._id, { blogs: [savedBlogs[2]._id, savedBlogs[5]._id] })

  console.log('Database seeded with sample data')
  console.log('Users: david, alice, bob (password: password123)')

  if (shouldDisconnect) {
    await mongoose.disconnect()
  }
  return true
}

module.exports = seed