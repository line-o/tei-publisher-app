require("../util.js");
var assert = require('assert');
var path = require('path');

describe('browsing text', function() {

    browser.windowHandleSize({width: 1200, height: 1024});

    it('open document', function() {
        browser.url(process.env.WDIO_PROTOCOL + "://" + process.env.WDIO_SERVER + ":" +
            process.env.WDIO_PORT + "/exist/apps/tei-publisher/index.html");

        browser.click("a[href*='kant_rvernunft_1781.TEI-P5.xml']")
        browser.waitForVisible(".col-title h5");
        assert.equal(browser.getText(".col-title h5"), "Critik der reinen Vernunft");
    });

    it("table of contents", function() {
        browser.click(".toc-toggle")
            .waitForExist("#toc ul li");

        browser.click("#toc li:nth-child(3) a")
            .waitForVisible("a[data-div='3.4.4.8.7']");
        browser.click("a[data-div='3.4.4.8.7']")
            .pause(200);
        browser.waitForExist(".content h1");

        assert.equal(browser.getText(".content h1"), "Einleitung.");
    });

    it("next page", function() {
        browser.click(".hidden-xs .nav-next").pause(400);
        browser.waitForExist(".content .tei-corr1");
        assert.equal(browser.getText(".content .tei-corr1"), "Erkentniſſe");
    });

    it("previous page", function() {
        browser.click(".hidden-xs .nav-prev").pause(400);

        browser.waitForExist(".content h1");

        assert.equal(browser.getText(".content h1"), "Einleitung.");
    });

    it("reload", function() {
        browser.refresh();

        assert.equal(browser.getText(".content h1"), "Einleitung.");
    });

    it("next page", function() {
        browser.click(".hidden-xs .nav-next").pause(400);
        browser.waitForExist(".content .tei-corr1");
        assert.equal(browser.getText(".content .tei-corr1"), "Erkentniſſe");
    });

    it("reload", function() {
        browser.refresh();

        assert.equal(browser.getText(".content .tei-corr1"), "Erkentniſſe");
    });

    it("search", function() {
        browser.setValue("#searchPageForm input[name='query']", "urtheile");
        browser.submitForm("#searchPageForm");

        var hits = browser.getText("#hit-count");
        assert.equal(hits, 26);

        browser.click("#results tr:nth-child(2) .hi a");
        assert(browser.isExisting("mark"));

        browser.back();

        browser.click("#results tr:nth-child(3) .hi a");
        assert(browser.isExisting("mark"));
    });

    it("start page", function() {
        browser.click("#about a");
        assert(browser.isExisting("a[href*='kant_rvernunft_1781.TEI-P5.xml']"));
    });
});