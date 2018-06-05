'use strict';

const bot = require('./groupme-bot');
const texts = [
	'lepidopterology',
	'damp-dirt-dust',
	'musings-on-museums'
];
const etc = 'https://raw.githubusercontent.com/keggsmurph21/etc/master';

module.exports = (app) => {

	// redirects
	app.get('/photo-essay', (req, res) => {
		res.redirect('https://docs.google.com/presentation/d/1OtbrhM4zozMMF8G1_XZrAQqemhGD5vCnUTTCGM7kbVM/');
	});
	app.get('/boot', (req, res) => {
		res.redirect(`${etc}/installers/live/bootstrap.sh`);
	});
	app.get('/botmaker', (req, res) => {
		res.redirect(`${etc}/make-groupme-bot`);
	});
	app.get('/catonline', (req, res) => {
		res.redirect('http://catonline.murp.us/');
	});

	// WhatsApp bot callback
	app.put('/bot/identify', (req, res) => {
		console.log('PUT /bot/identify');
		const data = bot.identify(req.body);
		res.status(data.code).json(data.body);
	});
	app.post('/bot/callback', (req, res) => {
		console.log('POST /bot/callback');
		const data = bot.callback(req.body);
		res.status(data.code).json(data.body);
	});
	app.get('/bot/queue', (req, res) => {
		const data = bot.queue(req.body);
		res.status(data.code).json(data.body);
	});
	app.post('/bot/process', (req, res) => {
		console.log('POST /bot/process');
		const data = bot.process(req.body);
		res.status(data.code).json(data.body);
	});

	// texts :)
	app.get('/texts', (req, res) => {
		res.render('texts/index.ejs');
	});
	texts.forEach((text) => {
		app.get(`/texts/${text}`, (req, res) => {
			res.render(`texts/${text}.ejs`);
		});
	});

	// home page
	app.get('/', (req, res) => {
		res.render('index.ejs');
	});

};
