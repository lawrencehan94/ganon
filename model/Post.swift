// We want to create a model / object of post that will store the stuff from Firebase

class Post: NSObject {
  var author: String!
  var caption: String!
  var likes: Int!
  var pathToImage: String!
  var postID: String!
  var userID: String!
}
