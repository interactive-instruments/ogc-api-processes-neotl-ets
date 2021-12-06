(:~
 : XQuery extension functions for OGC API - processes tests 
 :)

module namespace oapip = 'https://etf-validator.net/neotl/ext/ogc-api-processes';

(:~
 : Check if schema defines a Qualified Value.
 :
 : see https://docs.ogc.org/DRAFTS/18-062.html#req_core_process-execute-input-inline-object
 :)
declare %private function oapip:mustBeQualified($schema) {
  exists($schema[type='object' and not(properties/bbox)]) or exists($schema[oneOf or anyOf or allOf])
};

(:~
 : Wraps each qualified value into a 'value' JSON object
 :
 : see https://docs.ogc.org/DRAFTS/18-062.html#req_core_process-execute-input-inline-object
 :)
declare function oapip:qualifiedSampleValues($nodes, $genFct as function(item()) as item()* ) {
  for $n in $nodes/*
      return element { $n/name() } {
        let $generated := $genFct($n/schema)
        return if (oapip:mustBeQualified($n/schema)) then
          (attribute type {"object"},
            element { "value" } {
                (: qualified value :)
                $generated
          })
        else
          $generated
      }
};