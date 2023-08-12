// function authenticateUser(req, res, next) {
//     if (req.session.user) {
//       next(); // User is authenticated, proceed to the next middleware/route
//     } else {
//       res.status(401).json({ message: 'Unauthorized' }); // User is not authenticated
//     }
//   }
  
//   module.exports = {
//     authenticateUser,
//   };

const jwt = require('jsonwebtoken');

function authenticateUser(req, res, next) {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1]; // Get token from the "Authorization" header

  if (token) {
    try {
      const decodedToken = jwt.verify(token, 'your-secret-key'); // Verify the token using your secret key
      req.user = decodedToken; // Attach the user object to the request for future use
      next(); // User is authenticated, proceed to the next middleware/route
    } catch (error) {
      res.status(401).json({ message: 'Unauthorized' }); // Token is invalid/expired
    }
  } else {
    res.status(401).json({ message: 'Unauthorized' }); // Token is missing
  }
}

module.exports = {
  authenticateUser,
};

  