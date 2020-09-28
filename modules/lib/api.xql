xquery version "3.1";

declare namespace api="https://tei-publisher.com/xquery/api";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace router="http://exist-db.org/xquery/router";
import module namespace rutil="http://exist-db.org/xquery/router/util";
import module namespace oapi="http://teipublisher.com/api/odd" at "api/odd.xql";
import module namespace dapi="http://teipublisher.com/api/documents" at "api/document.xql";
import module namespace capi="http://teipublisher.com/api/collection" at "api/collection.xql";
import module namespace sapi="http://teipublisher.com/api/search" at "api/search.xql";
import module namespace deploy="http://teipublisher.com/api/generate" at "api/generate.xql";
import module namespace dts="http://teipublisher.com/api/dts" at "api/dts.xql";
import module namespace iapi="http://teipublisher.com/api/info" at "api/info.xql";
import module namespace vapi="http://teipublisher.com/api/view" at "api/view.xql";
import module namespace custom="http://teipublisher.com/api/custom" at "../custom-api.xql";

let $lookup := function($name as xs:string) {
    let $cfun := custom:lookup($name)
    return
        if (empty($cfun)) then
            function-lookup(xs:QName($name), 1)
        else
            $cfun
}
let $resp := router:route(("modules/custom-api.json", "modules/lib/api.json"), $lookup)
return
    $resp