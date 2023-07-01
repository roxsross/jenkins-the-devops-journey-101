const express = require('express');
const swaggerUI = require('swagger-ui-express');
const swaggerJsDoc = require('swagger-jsdoc');
const postsRouter = require("./routes/posts");

const option = {
	definition: {
		openapi: "3.0.0",
		info: {
			title: "Interview API",
			version: "1.0.0",
			description: "REST API node express for interview cde."
		},
		servers: [
			{
				url: "http://localhost:8080"
			}
		]
	},
	apis: ["./routes/*.js"]
}

const specs = swaggerJsDoc(option);

const app = express();
const port = process.env.PORT || 8080;

app.use("/api-docs/", swaggerUI.serve, swaggerUI.setup(specs));
app.use(express.json());
app.use("/posts", postsRouter);
app.get('/*', function (req, res) {
	res.sendFile(__dirname + '/public/index.html')
  });

app.listen(port, () => console.log(`http://localhost:${port}`));