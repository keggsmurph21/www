"use strict";

const bootstrapUrl =
    "https://raw.githubusercontent.com/keggsmurph21/dotfiles/master/install";

module.exports = (app) => {
    // redirects
    app.get("/bootstrap", (req, res) => { res.redirect(bootstrapUrl); });
    app.get("/catonline",
            (req, res) => { res.redirect("http://catonline.murp.us/"); });

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
