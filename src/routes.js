"use strict";

const texts = [
    "lepidopterology", "damp-dirt-dust", "musings-on-museums",
    "scrambled-ramblings"
];
const bootstrapUrl =
    "https://raw.githubusercontent.com/keggsmurph21/dotfiles/master/install";

module.exports = (app) => {
    // redirects
    app.get("/bootstrap", (req, res) => { res.redirect(bootstrapUrl); });
    app.get("/catonline",
            (req, res) => { res.redirect("http://catonline.murp.us/"); });

    // texts :)
    app.get("/texts", (req, res) => { res.render("texts/index.ejs"); });
    texts.forEach((text) => {
        app.get(`/texts/${text}`,
                (req, res) => { res.render(`texts/${text}.ejs`); });
    });

    app.get("/resume", (req, res) => {
        console.log("GET /resume");
        res.render("resume.ejs");
    });

    app.get("/donuts", (req, res) => {
        console.log("GET /donuts");
        res.render("donuts.ejs");
    });

    // home page
    app.get("/", (req, res) => { res.render("index.ejs"); });
};
