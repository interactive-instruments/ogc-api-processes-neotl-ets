# Writing Tests with NeoTL

## Structure

### Test Suites

An Executable Test Suite is composed of several test cases.

### Test Cases

 A specific test of an implementation to meet the specific requirements
 as stated in the specification containing the requirements.

 Not all validation steps have to be executed within a test case.
 This can be the case, for example, if the test object does not
 satisfy certain characteristics and thus the test case is not
 applicable to the test object.

 The test case fails if at least one test condition is not met.

### Validation Step

A single validation step within an execution flow.

 If all preconditions in the "given" section are met, then the action
 defined in the "when" section is executed. The intermediate result
 of the action must pass all Assertions defined in the "then"
 section.

 A validation step can perform only one action and check its result.

 Results of other actions can be defined as preconditions in the
 "when" section and used in variables. The actions cannot be referenced
 directly, other validation steps must be specified instead. This
 ensures that only validated results can be accessed.

## Actions

 A Validation Step is structured with the Given-When-Then style.

 The when section describes exactly one action that is executed
 during this validation step.

### Request

 **Request Query** :

 The query string that is appended to the request.

 Parameter name and values must be specified in the form
 `- name = value`.

 Variables from upstream validation steps can also be used as
 values:
 `- name = ${value}`.

 It is also possible to specify a mapping of multiple names
 to parameters:
 `- ${names = values}`.

 The query string including the ?-character is appended to the path
 including the &-separator. If necessary, the key-value pairs
 are escaped.

  **URL path of the this Request** :

 An absolute path including http(s) scheme can be specified or a
 relative path.

 The relative path is supplemented during the test run with the
 path to the test object specified by the user.

 Variables from upstream validation steps can be used in the path:
 `/path/service/${subPath}/resourceX`.

 By default, all queries are removed from the path. If the
 queries should not be removed from a parameterized path,
 `contains queries` must be appended:

 `path: "${urlWithQueries}" includes queries`

 Queries specified in the **query** section have priority and
 overwrite the queries from the dynamic path.

 **Dynamic Parameters for this Request** :

 If the request is parameterized, it is possible to specify here
 which parameters are mandatory and which are optional. For
 optional parameters, a fallback value must be specified.

 All parameters not listed here are treated as mandatory. Mandatory
 parameters must be passed within a TestCase to the Validations
 Step that uses this request definition.

 **Body of this Request** :

 Defines the data that will be sent to the endpoint. The data can
 be specified in three different ways.

 1.) A file can be specified, which must be parallel to the
 current definition file or in a subdirectory:
 `body from "./file.txt" as "text/plain; charset=utf-8"`

 2.) The data can be specified as a string:
 `body "<message>Hello!</message>" as application/xml`

 3.) JSON data can be specified inline:
  `body { "message" : "Hello!" } as application/json`


 Supported formats are:
 
 - application/json
 - application/geo+json
 - application/stac+json
 - application/geo+json-seq
 - application/gml+xml;version=3.2
 - text/csv
 - application/xml

 Formats not listed must be specified as a string, however,
 no replacements are made.

## Extractor

Used to extract one single value or a list of values that are consumed by one single Validation Step.

Example:

```
Extractor "Extract ..." {
    id: myExtractor

    from RESPONSE 
        as ${idXorY} query $.*[?(@.id == 'id_X' || @.id == 'id_Y')].id
}
```

This will evaluate the JSON Path expression and store either the 
value 'id_X' or 'id_Y' in the variable `${idXorY}`.


## Generators

Used to perform a validation step for each value from a list.

Example:

```
Generator "Generate multiple Requests" {
    id: myGenerator

    from RESPONSE 
        as ${links} query $.links[?(@.rel=='alternate')].href
}
```

This will evaluate the JSON Path expression and store a list of links
in the variable `${links}`


Usage in Validation Steps:

```
// Generator Step
    ValidationStep "Generate ..." {
        id: generatorStep
        description: "..."

        given:
            - Response from anotherStep
        // the response from the given part will be consumed
        when: Generator myGenerator executed
        then:
            // make sure to validate the output of the generator
    }

    ValidationStep "Check that ..." {
        id: ...
        description: "..."

        given:
            // For each link in Links a separate isolated ValidationsStep 
            // and the corresponding action (here a request) is created.
            // This means no iteration is performed. If one ValidationStep 
            // fails, the others will be executed anyway.
            - One ${link} of ${links} from generatorStep
        when: Request ... executed
        then:
            // validate responses
    }
```

Todo:

- describe variables with multiple responses
- describe yield variables
- currently only a JsonPath is supported in the query.

## Validations

The following section describes all types of checks that can be applied to the result.

### HTML

Validates the response against the W3C markup rules using the [W3C Markup Validation Service](https://validator.w3.org/)

Example:

```
then:
    - Assert HTML is valid
```

### HTTP

Checks specific properties of a HTTP response.

Example:

```
then:
    - Assert HTTP { statusCode "200" }
    - Assert HTTP { contentType "text/html" }
```

### Manual

If there are tests that cannot be automated, instructions can be issued in the report that the tester must perform manually.

If an execution definition has even a single manual test, the aggregated status of the execution definition can always be PASSED_MANUAL instead of PASSED.

Example:

```
then:
    - Assert Manual {
        "Validate that ..."
        "...second instruction..."
        "...third instruction..."
    }
```

Todo: describe all ETF Status Codes.

### JSON

Example:

```
then:
    - Assert JSON {
        $.links exists
        and $.link not exists
        and $.array not empty
        or ( 
            $.array contains some "item"
            or $.propX equals "item"
        )
        and $.array not contains "other-item"
        or $.array contains ${myVariable}
        otherwise FAIL with "No conformance links could be found"
    } 
```

The JSON path is converted to an internal query language. The implementation is very 
close to the Jetway JSONPath implementation, which can be tried out online [here](http://jsonpath.herokuapp.com/). 
Please note that the other implementations have partly a very limited functions (e.g. logical operators are not 
supported in the filters)


### XQuery

Can be used to call XQuery functions or to proxy specific Java library calls (the assertion can be used to 
extend the validation functionality of the language).

Example:

```
then:
    - Assert XQ {
        call "functionX"
        parameters:
            - "paramX" = ""
                
        otherwise FAIL with "message"
}
```
