(:~

    Transformation module generated from TEI ODD extensions for processing models.
    ODD: /db/apps/tei-publisher/odd/docx-output.odd
 :)
xquery version "3.1";

module namespace model="http://www.tei-c.org/pm/models/docx-output/epub";

declare default element namespace "http://www.tei-c.org/ns/1.0";

declare namespace xhtml='http://www.w3.org/1999/xhtml';

declare namespace xi='http://www.w3.org/2001/XInclude';

declare namespace pb='http://teipublisher.com/1.0';

import module namespace css="http://www.tei-c.org/tei-simple/xquery/css";

import module namespace html="http://www.tei-c.org/tei-simple/xquery/functions";

import module namespace epub="http://www.tei-c.org/tei-simple/xquery/functions/epub";

(: generated template function for element spec: anchor :)
declare %private function model:template-anchor($config as map(*), $node as node()*, $params as map(*)) {
    <t xmlns=""><a rel="footnote">{$config?apply-children($config, $node, $params?content)}</a></t>/*
};
(: generated template function for element spec: hi :)
declare %private function model:template-hi($config as map(*), $node as node()*, $params as map(*)) {
    <t xmlns=""><span class="{$config?apply-children($config, $node, $params?rend)}">{$config?apply-children($config, $node, $params?content)}</span></t>/*
};
(:~

    Main entry point for the transformation.
    
 :)
declare function model:transform($options as map(*), $input as node()*) {
        
    let $config :=
        map:merge(($options,
            map {
                "output": ["epub","web"],
                "odd": "/db/apps/tei-publisher/odd/docx-output.odd",
                "apply": model:apply#2,
                "apply-children": model:apply-children#3
            }
        ))
    
    return (
        html:prepare($config, $input),
    
        let $output := model:apply($config, $input)
        return
            html:finish($config, $output)
    )
};

declare function model:apply($config as map(*), $input as node()*) {
        let $parameters := 
        if (exists($config?parameters)) then $config?parameters else map {}
        let $get := 
        model:source($parameters, ?)
    return
    $input !         (
            let $node := 
                .
            return
                            typeswitch(.)
                    case element(castItem) return
                        (: Insert item, rendered as described in parent list rendition. :)
                        html:listItem($config, ., ("tei-castItem"), ., ())
                    case element(item) return
                        html:listItem($config, ., ("tei-item"), ., ())
                    case element(figure) return
                        if (head or @rendition='simple:display') then
                            epub:block($config, ., ("tei-figure1"), .)
                        else
                            html:inline($config, ., ("tei-figure2"), .)
                    case element(teiHeader) return
                        if ($parameters?header='short') then
                            epub:block($config, ., ("tei-teiHeader3"), .)
                        else
                            html:metadata($config, ., ("tei-teiHeader4"), .)
                    case element(supplied) return
                        html:inline($config, ., ("tei-supplied"), .)
                    case element(milestone) return
                        html:inline($config, ., ("tei-milestone"), .)
                    case element(label) return
                        html:inline($config, ., ("tei-label"), .)
                    case element(signed) return
                        if (parent::closer) then
                            epub:block($config, ., ("tei-signed1"), .)
                        else
                            html:inline($config, ., ("tei-signed2"), .)
                    case element(pb) return
                        epub:break($config, ., css:get-rendition(., ("tei-pb")), ., 'page', (concat(if(@n) then concat(@n,' ') else '',if(@facs) then                   concat('@',@facs) else '')))
                    case element(pc) return
                        html:inline($config, ., ("tei-pc"), .)
                    case element(anchor) return
                        if (@type='note') then
                            let $params := 
                                map {
                                    "content": let $nr := count(./preceding::note[@target]) let $ch := codepoints-to-string(string-to-codepoints("a") + $nr mod 26) return  $ch || '-'
                                }

                                                        let $content := 
                                model:template-anchor($config, ., $params)
                            return
                                                        html:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-anchor1", "note"), $content)
                        else
                            html:anchor($config, ., ("tei-anchor2"), ., @xml:id)
                    case element(TEI) return
                        html:document($config, ., ("tei-TEI"), .)
                    case element(formula) return
                        if (@rendition='simple:display') then
                            epub:block($config, ., ("tei-formula1"), .)
                        else
                            html:inline($config, ., ("tei-formula2"), .)
                    case element(choice) return
                        if (sic and corr) then
                            epub:alternate($config, ., ("tei-choice4"), ., corr[1], sic[1])
                        else
                            if (abbr and expan) then
                                epub:alternate($config, ., ("tei-choice5"), ., expan[1], abbr[1])
                            else
                                if (orig and reg) then
                                    epub:alternate($config, ., ("tei-choice6"), ., reg[1], orig[1])
                                else
                                    $config?apply($config, ./node())
                    case element(hi) return
                        if (@rend) then
                            let $params := 
                                map {
                                    "rend": @rend,
                                    "content": .
                                }

                                                        let $content := 
                                model:template-hi($config, ., $params)
                            return
                                                        html:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-hi1"), $content)
                        else
                            if (@rend='b') then
                                html:inline($config, ., ("tei-hi2"), .)
                            else
                                if (@rendition) then
                                    html:inline($config, ., css:get-rendition(., ("tei-hi3")), .)
                                else
                                    if (not(@rendition)) then
                                        html:inline($config, ., ("tei-hi4"), .)
                                    else
                                        $config?apply($config, ./node())
                    case element(code) return
                        html:inline($config, ., ("tei-code"), .)
                    case element(note) return
                        if (@target) then
                            epub:note($config, ., ("tei-note1"), ., (), let $nr := count(./preceding::note[@target]) let $ch := codepoints-to-string(string-to-codepoints("a") + $nr mod 26) return  '-' || $ch)
                        else
                            if (@place) then
                                epub:note($config, ., ("tei-note2"), ., @place, @n)
                            else
                                if (parent::div and not(@place)) then
                                    epub:block($config, ., ("tei-note3"), .)
                                else
                                    if (not(@place)) then
                                        html:inline($config, ., ("tei-note4"), .)
                                    else
                                        $config?apply($config, ./node())
                    case element(dateline) return
                        epub:block($config, ., ("tei-dateline"), .)
                    case element(back) return
                        epub:block($config, ., ("tei-back"), .)
                    case element(del) return
                        html:inline($config, ., ("tei-del"), .)
                    case element(trailer) return
                        epub:block($config, ., ("tei-trailer"), .)
                    case element(titlePart) return
                        epub:block($config, ., css:get-rendition(., ("tei-titlePart")), .)
                    case element(ab) return
                        html:paragraph($config, ., ("tei-ab"), .)
                    case element(revisionDesc) return
                        html:omit($config, ., ("tei-revisionDesc"), .)
                    case element(am) return
                        html:inline($config, ., ("tei-am"), .)
                    case element(subst) return
                        html:inline($config, ., ("tei-subst"), .)
                    case element(roleDesc) return
                        epub:block($config, ., ("tei-roleDesc"), .)
                    case element(orig) return
                        html:inline($config, ., ("tei-orig"), .)
                    case element(opener) return
                        epub:block($config, ., ("tei-opener"), .)
                    case element(speaker) return
                        epub:block($config, ., ("tei-speaker"), .)
                    case element(imprimatur) return
                        epub:block($config, ., ("tei-imprimatur"), .)
                    case element(publisher) return
                        if (ancestor::teiHeader) then
                            (: Omit if located in teiHeader. :)
                            html:omit($config, ., ("tei-publisher"), .)
                        else
                            $config?apply($config, ./node())
                    case element(figDesc) return
                        html:inline($config, ., ("tei-figDesc"), .)
                    case element(rs) return
                        html:inline($config, ., ("tei-rs"), .)
                    case element(foreign) return
                        html:inline($config, ., ("tei-foreign"), .)
                    case element(fileDesc) return
                        if ($parameters?header='short') then
                            (
                                epub:block($config, ., ("tei-fileDesc1", "header-short"), titleStmt),
                                epub:block($config, ., ("tei-fileDesc2", "header-short"), editionStmt),
                                epub:block($config, ., ("tei-fileDesc3", "header-short"), publicationStmt)
                            )

                        else
                            html:title($config, ., ("tei-fileDesc4"), titleStmt)
                    case element(seg) return
                        html:inline($config, ., css:get-rendition(., ("tei-seg")), .)
                    case element(profileDesc) return
                        html:omit($config, ., ("tei-profileDesc"), .)
                    case element(email) return
                        html:inline($config, ., ("tei-email"), .)
                    case element(text) return
                        html:body($config, ., ("tei-text"), .)
                    case element(floatingText) return
                        epub:block($config, ., ("tei-floatingText"), .)
                    case element(sp) return
                        epub:block($config, ., ("tei-sp"), .)
                    case element(abbr) return
                        html:inline($config, ., ("tei-abbr"), .)
                    case element(table) return
                        html:table($config, ., ("tei-table"), .)
                    case element(cb) return
                        epub:break($config, ., ("tei-cb"), ., 'column', @n)
                    case element(group) return
                        epub:block($config, ., ("tei-group"), .)
                    case element(licence) return
                        if (@target) then
                            html:link($config, ., ("tei-licence1", "licence"), 'Licence', @target, (), map {})
                        else
                            html:omit($config, ., ("tei-licence2"), .)
                    case element(editor) return
                        if (ancestor::teiHeader) then
                            html:omit($config, ., ("tei-editor1"), .)
                        else
                            html:inline($config, ., ("tei-editor2"), .)
                    case element(c) return
                        html:inline($config, ., ("tei-c"), .)
                    case element(listBibl) return
                        if (bibl) then
                            html:list($config, ., ("tei-listBibl1"), bibl, ())
                        else
                            epub:block($config, ., ("tei-listBibl2"), .)
                    case element(address) return
                        epub:block($config, ., ("tei-address"), .)
                    case element(g) return
                        if (not(text())) then
                            html:glyph($config, ., ("tei-g1"), .)
                        else
                            html:inline($config, ., ("tei-g2"), .)
                    case element(author) return
                        if (ancestor::teiHeader) then
                            epub:block($config, ., ("tei-author1"), .)
                        else
                            html:inline($config, ., ("tei-author2"), .)
                    case element(castList) return
                        if (child::*) then
                            html:list($config, ., css:get-rendition(., ("tei-castList")), castItem, ())
                        else
                            $config?apply($config, ./node())
                    case element(l) return
                        epub:block($config, ., css:get-rendition(., ("tei-l")), .)
                    case element(closer) return
                        epub:block($config, ., ("tei-closer"), .)
                    case element(rhyme) return
                        html:inline($config, ., ("tei-rhyme"), .)
                    case element(list) return
                        if (@rendition) then
                            html:list($config, ., css:get-rendition(., ("tei-list1")), item, ())
                        else
                            if (not(@rendition)) then
                                html:list($config, ., ("tei-list2"), item, ())
                            else
                                $config?apply($config, ./node())
                    case element(p) return
                        html:paragraph($config, ., css:get-rendition(., ("tei-p")), .)
                    case element(measure) return
                        html:inline($config, ., ("tei-measure"), .)
                    case element(q) return
                        if (l) then
                            epub:block($config, ., css:get-rendition(., ("tei-q1")), .)
                        else
                            if (ancestor::p or ancestor::cell) then
                                html:inline($config, ., css:get-rendition(., ("tei-q2")), .)
                            else
                                epub:block($config, ., css:get-rendition(., ("tei-q3")), .)
                    case element(actor) return
                        html:inline($config, ., ("tei-actor"), .)
                    case element(epigraph) return
                        epub:block($config, ., ("tei-epigraph"), .)
                    case element(s) return
                        html:inline($config, ., ("tei-s"), .)
                    case element(docTitle) return
                        epub:block($config, ., css:get-rendition(., ("tei-docTitle")), .)
                    case element(lb) return
                        epub:break($config, ., css:get-rendition(., ("tei-lb")), ., 'line', @n)
                    case element(w) return
                        html:inline($config, ., ("tei-w"), .)
                    case element(stage) return
                        epub:block($config, ., ("tei-stage"), .)
                    case element(titlePage) return
                        epub:block($config, ., css:get-rendition(., ("tei-titlePage")), .)
                    case element(name) return
                        html:inline($config, ., ("tei-name"), .)
                    case element(front) return
                        epub:block($config, ., ("tei-front"), .)
                    case element(lg) return
                        epub:block($config, ., ("tei-lg"), .)
                    case element(publicationStmt) return
                        epub:block($config, ., ("tei-publicationStmt1"), availability/licence)
                    case element(biblScope) return
                        html:inline($config, ., ("tei-biblScope"), .)
                    case element(desc) return
                        html:inline($config, ., ("tei-desc"), .)
                    case element(role) return
                        epub:block($config, ., ("tei-role"), .)
                    case element(docEdition) return
                        html:inline($config, ., ("tei-docEdition"), .)
                    case element(num) return
                        html:inline($config, ., ("tei-num"), .)
                    case element(docImprint) return
                        html:inline($config, ., ("tei-docImprint"), .)
                    case element(postscript) return
                        epub:block($config, ., ("tei-postscript"), .)
                    case element(edition) return
                        if (ancestor::teiHeader) then
                            epub:block($config, ., ("tei-edition"), .)
                        else
                            $config?apply($config, ./node())
                    case element(cell) return
                        (: Insert table cell. :)
                        html:cell($config, ., ("tei-cell"), ., ())
                    case element(relatedItem) return
                        html:inline($config, ., ("tei-relatedItem"), .)
                    case element(div) return
                        if (@type='title_page') then
                            epub:block($config, ., ("tei-div1"), .)
                        else
                            if (parent::body or parent::front or parent::back) then
                                html:section($config, ., ("tei-div2"), .)
                            else
                                epub:block($config, ., ("tei-div3"), .)
                    case element(graphic) return
                        html:graphic($config, ., ("tei-graphic"), ., @url, @width, @height, @scale, desc)
                    case element(reg) return
                        html:inline($config, ., ("tei-reg"), .)
                    case element(ref) return
                        if (not(@target)) then
                            html:inline($config, ., ("tei-ref1"), .)
                        else
                            if (not(node())) then
                                html:link($config, ., ("tei-ref2"), @target, @target, (), map {})
                            else
                                html:link($config, ., ("tei-ref3"), ., @target, (), map {})
                    case element(pubPlace) return
                        if (ancestor::teiHeader) then
                            (: Omit if located in teiHeader. :)
                            html:omit($config, ., ("tei-pubPlace"), .)
                        else
                            $config?apply($config, ./node())
                    case element(add) return
                        html:inline($config, ., ("tei-add"), .)
                    case element(docDate) return
                        html:inline($config, ., ("tei-docDate"), .)
                    case element(head) return
                        if ($parameters?header='short') then
                            html:inline($config, ., ("tei-head1"), replace(string-join(.//text()[not(parent::ref)]), '^(.*?)[^\w]*$', '$1'))
                        else
                            if (parent::figure) then
                                epub:block($config, ., ("tei-head2"), .)
                            else
                                if (parent::table) then
                                    epub:block($config, ., ("tei-head3"), .)
                                else
                                    if (parent::lg) then
                                        epub:block($config, ., ("tei-head4"), .)
                                    else
                                        if (parent::list) then
                                            epub:block($config, ., ("tei-head5"), .)
                                        else
                                            if (parent::div) then
                                                html:heading($config, ., ("tei-head6"), ., count($get(.)/ancestor::div))
                                            else
                                                epub:block($config, ., ("tei-head7"), .)
                    case element(ex) return
                        html:inline($config, ., ("tei-ex"), .)
                    case element(castGroup) return
                        if (child::*) then
                            (: Insert list. :)
                            html:list($config, ., ("tei-castGroup"), castItem|castGroup, ())
                        else
                            $config?apply($config, ./node())
                    case element(time) return
                        html:inline($config, ., ("tei-time"), .)
                    case element(bibl) return
                        if (parent::listBibl) then
                            html:listItem($config, ., ("tei-bibl1"), ., ())
                        else
                            html:inline($config, ., ("tei-bibl2"), .)
                    case element(salute) return
                        if (parent::closer) then
                            html:inline($config, ., ("tei-salute1"), .)
                        else
                            epub:block($config, ., ("tei-salute2"), .)
                    case element(unclear) return
                        html:inline($config, ., ("tei-unclear"), .)
                    case element(argument) return
                        epub:block($config, ., ("tei-argument"), .)
                    case element(date) return
                        if (@when) then
                            epub:alternate($config, ., ("tei-date3"), ., ., @when)
                        else
                            if (text()) then
                                html:inline($config, ., ("tei-date4"), .)
                            else
                                $config?apply($config, ./node())
                    case element(title) return
                        if ($parameters?header='short') then
                            html:heading($config, ., ("tei-title1"), ., 5)
                        else
                            if (parent::titleStmt/parent::fileDesc) then
                                (
                                    if (preceding-sibling::title) then
                                        html:text($config, ., ("tei-title2"), ' — ')
                                    else
                                        (),
                                    html:inline($config, ., ("tei-title3"), .)
                                )

                            else
                                if (not(@level) and parent::bibl) then
                                    html:inline($config, ., ("tei-title4"), .)
                                else
                                    if (@level='m' or not(@level)) then
                                        (
                                            html:inline($config, ., ("tei-title5"), .),
                                            if (ancestor::biblFull) then
                                                html:text($config, ., ("tei-title6"), ', ')
                                            else
                                                ()
                                        )

                                    else
                                        if (@level='s' or @level='j') then
                                            (
                                                html:inline($config, ., ("tei-title7"), .),
                                                if (following-sibling::* and     (  ancestor::biblFull)) then
                                                    html:text($config, ., ("tei-title8"), ', ')
                                                else
                                                    ()
                                            )

                                        else
                                            if (@level='u' or @level='a') then
                                                (
                                                    html:inline($config, ., ("tei-title9"), .),
                                                    if (following-sibling::* and     (    ancestor::biblFull)) then
                                                        html:text($config, ., ("tei-title10"), '. ')
                                                    else
                                                        ()
                                                )

                                            else
                                                html:inline($config, ., ("tei-title11"), .)
                    case element(corr) return
                        if (parent::choice and count(parent::*/*) gt 1) then
                            (: simple inline, if in parent choice. :)
                            html:inline($config, ., ("tei-corr1"), .)
                        else
                            html:inline($config, ., ("tei-corr2"), .)
                    case element(cit) return
                        if (child::quote and child::bibl) then
                            (: Insert citation :)
                            html:cit($config, ., ("tei-cit"), ., ())
                        else
                            $config?apply($config, ./node())
                    case element(titleStmt) return
                        if ($parameters?mode='title') then
                            html:heading($config, ., ("tei-titleStmt3"), title[not(@type)], 5)
                        else
                            if ($parameters?header='short') then
                                (
                                    html:link($config, ., ("tei-titleStmt4"), title[1], $parameters?doc, (), map {}),
                                    epub:block($config, ., ("tei-titleStmt5"), subsequence(title, 2)),
                                    epub:block($config, ., ("tei-titleStmt6"), author)
                                )

                            else
                                epub:block($config, ., ("tei-titleStmt7"), .)
                    case element(sic) return
                        if (parent::choice and count(parent::*/*) gt 1) then
                            html:inline($config, ., ("tei-sic1"), .)
                        else
                            html:inline($config, ., ("tei-sic2"), .)
                    case element(expan) return
                        html:inline($config, ., ("tei-expan"), .)
                    case element(body) return
                        (
                            html:index($config, ., ("tei-body1"), 'toc', .),
                            epub:block($config, ., ("tei-body2"), .)
                        )

                    case element(spGrp) return
                        epub:block($config, ., ("tei-spGrp"), .)
                    case element(fw) return
                        if (ancestor::p or ancestor::ab) then
                            html:inline($config, ., ("tei-fw1"), .)
                        else
                            epub:block($config, ., ("tei-fw2"), .)
                    case element(encodingDesc) return
                        html:omit($config, ., ("tei-encodingDesc"), .)
                    case element(addrLine) return
                        epub:block($config, ., ("tei-addrLine"), .)
                    case element(gap) return
                        if (desc) then
                            html:inline($config, ., ("tei-gap1"), .)
                        else
                            if (@extent) then
                                html:inline($config, ., ("tei-gap2"), @extent)
                            else
                                html:inline($config, ., ("tei-gap3"), .)
                    case element(quote) return
                        if (ancestor::p) then
                            (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                            html:inline($config, ., css:get-rendition(., ("tei-quote1")), .)
                        else
                            (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                            epub:block($config, ., css:get-rendition(., ("tei-quote2")), .)
                    case element(row) return
                        if (@role='label') then
                            html:row($config, ., ("tei-row1"), .)
                        else
                            (: Insert table row. :)
                            html:row($config, ., ("tei-row2"), .)
                    case element(docAuthor) return
                        html:inline($config, ., ("tei-docAuthor"), .)
                    case element(byline) return
                        epub:block($config, ., ("tei-byline"), .)
                    case element(gi) return
                        html:inline($config, ., ("tei-gi"), .)
                    case element(placeName) return
                        if (@rend='smallcaps') then
                            html:link($config, ., ("tei-placeName1"), ., 'https://www.google.de/maps/place/' || @ref, '_blank', map {})
                        else
                            html:inline($config, ., ("tei-placeName2"), .)
                    case element(persName) return
                        if (@ref) then
                            html:link($config, ., ("tei-persName1"), ., @ref, '_blank', map {})
                        else
                            html:inline($config, ., ("tei-persName2"), .)
                    case element(tag) return
                        html:inline($config, ., ("tei-tag"), .)
                    case element(eg) return
                        epub:block($config, ., ("tei-eg"), .)
                    case element(exist:match) return
                        html:match($config, ., .)
                    case element() return
                        if (namespace-uri(.) = 'http://www.tei-c.org/ns/1.0') then
                            $config?apply($config, ./node())
                        else
                            .
                    case text() | xs:anyAtomicType return
                        html:escapeChars(.)
                    default return 
                        $config?apply($config, ./node())

        )

};

declare function model:apply-children($config as map(*), $node as element(), $content as item()*) {
        
    if ($config?template) then
        $content
    else
        $content ! (
            typeswitch(.)
                case element() return
                    if (. is $node) then
                        $config?apply($config, ./node())
                    else
                        $config?apply($config, .)
                default return
                    html:escapeChars(.)
        )
};

declare function model:source($parameters as map(*), $elem as element()) {
        
    let $id := $elem/@exist:id
    return
        if ($id and $parameters?root) then
            util:node-by-id($parameters?root, $id)
        else
            $elem
};

