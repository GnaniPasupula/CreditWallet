function authenticateUser(req, res, next) {
    if (req.session.user) {
      next(); // User is authenticated, proceed to the next middleware/route
    } else {
      res.status(401).json({ message: 'Unauthorized' }); // User is not authenticated
    }
  }
  
  module.exports = {
    authenticateUser,
  };
  