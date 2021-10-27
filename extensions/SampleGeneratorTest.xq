(:~
 : Test module for XQuery extension functions for OGC API - processes tests
 :)

module namespace test = 'http://basex.org/modules/xqunit-tests';
import module namespace oapip = 'https://etf-validator.net/neotl/ext/ogc-api-processes' at 'SampleGenerator.xqm';


declare %unit:test function test:qualifiedValues() {
  
  let $json := json:parse(
    '
{
    "id": "echo",
    "inputs": {
        "a": {
            "title": "Literal Input (string)",
            "description": "An input string",
            "maxOccurs": 1,
            "schema": {
                "type": "string",
                "default": "Any value"
            },
            "id": "a"
        },
        "b": {
            "title": "Complex Input",
            "description": "A complex input ",
            "maxOccurs": 1,
            "schema": {
                "oneOf": [{
                    "type": "string",
                    "contentEncoding": "utf-8",
                    "contentMediaType": "text/xml"
                }, {
                    "type": "object"
                }]
            },
            "id": "b"
        },
        "c": {
            "title": "BoundingBox Input ",
            "description": "A boundingbox input ",
            "maxOccurs": 1,
            "schema": {
                "type": "object",
                "required": ["bbox", "crs"],
                "properties": {
                    "bbox": {
                        "type": "array",
                        "oneOf": [{
                            "minItems": 4,
                            "maxItems": 4
                        }, {
                            "minItems": 6,
                            "maxItems": 6
                        }],
                        "items": {
                            "type": "number",
                            "format": "double"
                        }
                    },
                    "crs": {
                        "type": "string",
                        "format": "uri",
                        "default": "urn:ogc:def:crs:EPSG:6.6:4326",
                        "enum": ["urn:ogc:def:crs:EPSG:6.6:4326", "urn:ogc:def:crs:EPSG:6.6:3785"]
                    }
                }
            },
            "id": "c"
        }
      }
    }
    ',
    map { 'format': 'direct' }
  )/json
    
  let $dummyFct := function($x) { $x }
  let $output := <result> { oapip:qualifiedSampleValues($json/inputs, $dummyFct) } </result>
  
  (:
   : a - string
   : b - qualified value
   : c - bbox
   :)
  return (
    unit:assert(
       not($output/a/value)
    ),
    unit:assert(
       $output/b/value
    ),
    unit:assert(
       not($output/c/value)
    )
  )
  
};