mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectID = Schema.ObjectID

Image = () ->
  imageSchema = new Schema
    url:
      type: String
      required: true
    tweetMessage:
      type: String
    user:
      type: String
    createdOn:
      type: Date

  imageSchema.pre 'save', (next) ->
    if !@createdAt
      @createdAt = new Date()
      next()
    return

  _model = mongoose.model "Image", imageSchema

  _nextImages = (id, sendImages, latestImage) ->
    mongoose.connect process.env.TWITTER_MONGO
    _model.where('_id').$gt(id).limit(30).run (err, im) ->
      images = []
      images.push img.url for img in im
      sendImages(images)
      latestImage(im[im.length - 1]._id)
      return
    mongoose.disconnect()
    return

  _firstImages = (sendImages, latestImage) ->
    mongoose.connect process.env.TWITTER_MONGO
    _model.where('createdOn').$lt(Date()).desc('createdOn').limit(30).run (err, im) ->
      images = []
      images.push img.url for img in im
      sendImages(images)
      latestImage(im[0]._id)
      return
    mongoose.disconnect()
    return

  return {
    schema: imageSchema
    model: _model
    nextImages: _nextImages
    firstImages: _firstImages
  }

module.exports = Image

