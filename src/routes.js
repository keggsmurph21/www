"use strict";

const bootstrapUrl =
    "https://raw.githubusercontent.com/keggsmurph21/dotfiles/master/install";

module.exports = (app) => {
    app.get("/bootstrap", (req, res) => { res.redirect(bootstrapUrl); });
    app.get("/catonline", (req, res) => { res.redirect("http://catonline.murp.us/"); });
    app.get("/resume", (req, res) => { res.redirect("/resume.html"); });
    app.get("/", (req, res) => { res.redirect("/index.html"); });
};
