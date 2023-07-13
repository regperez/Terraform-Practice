exports.helloWorld = (req, res) => {
  let message = req.query.message || req.body.message || "Hello World!";
  return res.status(200).json({ status: "up", info: message });
};
