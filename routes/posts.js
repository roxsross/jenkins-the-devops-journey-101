const express = require('express');
const router = express.Router();
const fetch = require('node-fetch');

/**
* @swagger
* components:
*   schemas:
*     Posts:
*       type: object
*       required:
*         - userId
*         - title
*         - body
*       properties:
*         id:
*           type: int
*           description: The auto-generated id of the post
*         userId:
*           type: int
*           description: The id of the user
*         title:
*           type: string
*           description: post title
*         body:
*           type: string
*           description: the post description
*       example:
*          data:
*            userId: 12
*            title: this is a title holder
*            body: this is a description holder
*/

/**
* @swagger
* tags:
*   name: Posts
*   descriptions: The posts managing API
*/

/**
* @swagger
* /posts:
*   get:
*     summary: return the list of all the posts
*     tags: [Posts]
*     responses:
*       200:
*         description: The list of the posts
*         content:
*           application/json:
*             schema:
*               type: array
*               items: 
*                 $ref: '#/components/schemas/Posts'
*/

router.get('/', async (req, res) => {
	let data = await fetch('https://jsonplaceholder.typicode.com/posts');
	let json = await data.json();

	res.status(200).send({ success: true, data: json });
});

/**
* @swagger
* /posts/{id}:
*   get:
*     summary: get the post by id
*     tags: [Posts]
*     parameters:
*       - in: path
*         name: id
*         schema:
*           type: string
*         required: true
*         description: The post id
*     responses:
*       200:
*         description: The post description by id
*         contens:
*           application/json:
*             schema:
*               $ref: '#/components/schemas/Posts'
*       404:
*         description: The post was not found
*/

router.get('/:id', async (req, res) => {
	const { id } = req.params;

	let data = await fetch(`https://jsonplaceholder.typicode.com/posts/${id}`);
	let json = await data.json();

	if(!json.id) {
		res.sendStatus(404).send({ success: false, message: 'post no encontrado!'});;
	} else {
		res.status(200).send({ success: true, data: json });
	}
})

/**
* @swagger
* /posts:
*   post:
*     summary: create a new post
*     tags: [Posts]
*     requestBody:
*       required: true
*       content:
*         application/json:
*           schema:
*             $ref: '#/components/schemas/Posts'
*     responses:
*       200:
*         description: The post was created
*         content:
*           application/json:
*             schema:
*               $ref: '#/components/schemas/Posts'
*       400:
*         description: You need to pass some data
*/


router.post('/', async (req, res) => {
	const { data } = req.body;

	if (!data) {
		res.status(400).send({ success: false, message: 'No existe datos!'});
	} else {
		let post = await fetch('https://jsonplaceholder.typicode.com/posts', {
		  method: 'POST',
		  body: JSON.stringify(data),
		  headers: {
		    'Content-type': 'application/json; charset=UTF-8',
		  },
		});
		let json = await post.json();

		res.status(200).send({ success: true, data: json });
	}
})

/**
* @swagger
* /posts/{id}:
*   put:
*     summary: update post by id
*     tags: [Posts]
*     parameters:
*       - in: path
*         name: id
*         schema:
*           type: string
*         required: true
*         description: The post id
*     requestBody:
*       required: true
*       content:
*         application/json:
*           schema:
*             $ref: '#/components/schemas/Posts'
*     responses:
*       200:
*         description: The post was updated
*         content:
*           application/json:
*             schema:
*               $ref: '#/components/schemas/Posts'
*       400:
*         description: You need to pass some data
*/

router.put('/:id', async (req, res) => {
	const { id } = req.params;
	const { data } = req.body;

	if (!data) {
		res.status(400).send({ success: false, message: 'No existe datos!'});
	} else {
		let post = await fetch(`https://jsonplaceholder.typicode.com/posts/${id}`, {
		  method: 'PUT',
		  body: JSON.stringify(data),
		  headers: {
		    'Content-type': 'application/json; charset=UTF-8',
		  },
		});
		let json = await post.json();

		res.status(200).send({ success: true, data: json });
	}
})

/**
* @swagger
* /posts/{id}:
*   patch:
*     summary: patch post by id
*     tags: [Posts]
*     parameters:
*       - in: path
*         name: id
*         schema:
*           type: string
*         required: true
*         description: The post id
*     requestBody:
*       required: true
*       content:
*         application/json:
*           schema:
*             $ref: '#/components/schemas/Posts'
*     responses:
*       200:
*         description: The post was patched
*         content:
*           application/json:
*             schema:
*               $ref: '#/components/schemas/Posts'
*       400:
*         description: You need to pass some data
*/

router.patch('/:id', async (req, res) => {
	const { id } = req.params;
	const { data } = req.body;

	if (!data) {
		res.status(400).send({ success: false, message: 'No existe datos!'});
	} else {
		let post = await fetch(`https://jsonplaceholder.typicode.com/posts/${id}`, {
		  method: 'PATCH',
		  body: JSON.stringify(data),
		  headers: {
		    'Content-type': 'application/json; charset=UTF-8',
		  },
		});
		let json = await post.json();

		res.status(200).send({ success: true, data: json });
	}
})

/**
* @swagger
* /posts/{id}:
*   delete:
*     summary: delete post by id
*     tags: [Posts]
*     parameters:
*       - in: path
*         name: id
*         schema:
*           type: string
*         required: true
*         description: The post id
*     responses:
*       200:
*         description: The post was deleted
*/

router.delete('/:id', async (req, res) => {
	const { id } = req.params;

	let response = await fetch(`https://jsonplaceholder.typicode.com/posts/${id}`, {
	  method: 'DELETE',
	});
	let json = await response.json();

	res.status(200).send({ success: true, data: json });
})

module.exports = router;