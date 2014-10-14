# Mule SchemaDoc Tool


The **Mule SchemaDoc tool** is a XSL transformer to **generate Confluence [Wiki Markup](https://confluence.atlassian.com/display/CONF34/Confluence+Notation+Guide+Overview)** (a derivate of textile) **from** a MuleESB core, transport or module **XSD**.

It can generate full _transport or module_ documentation aswell as _specific_ element documentation.

## Signature
- **XSLT source**: should point to the _core_, _module_ or _transport_ XSD file that will be documented.
- **display**: define which elements should be displayed.
    - *all*: render all elements (common first). ***Default value***.
    - *common*: render connector, inbound-endpoint, outbound-endpoint and endpoint elements.
    - *transformers*: renders only the transformers.
    - *filters*: renders only the filters.
    - *specific*: all other elements specific to the schema being processed.
    - *element name*: The name of a single element to render.
- **schemaType**: defines the type of schema this XSLT is processing.
    - *transport*: will treat the XSD as a Mule's transport. ***Default value***.
    - *module*: will treat the XSD as a Mule's module.
    - *single*: will only render one single element of the schema.
- **singleElementName**: *in case the schemaType is defined as single* the singleElementName should specify the exact single element that should be shown.
- **includedSchema1**: Absolute URL of an Schema that is included in the source.
- **includedSchema2**: Absolute URL of an Schema that is included in the source.
- **includedSchema3**: Absolute URL of an Schema that is included in the source.
- **includedSchema4**: Absolute URL of an Schema that is included in the source.
- **includedSchema5**: Absolute URL of an Schema that is included in the source.
- **includedSchema6**: Absolute URL of an Schema that is included in the source.

    

## Confluence XSLT Macro

This transformer is meant to be used within MuleSoft's confluence instance. In order to do so an [XSLT macro plugin](https://bobswift.atlassian.net/wiki/display/HTML/XSLT+Macro) is used.
The transformer is a single file for a number or reasons:

- The XSLT macro for Confluence does not provide an `URLResolver`, and therefore is incapable of include files without an absolute URL, see [this](https://bobswift.atlassian.net/wiki/questions/73924665/answers/73924676) for more information .
- Absolute URL lead to incluions of old versions. This was a predominant problem in all of the entrypoints of the [schemadocs](https://github.com/mulesoft/mule/tree/mule-3.5.0/tools/schemadocs) (see the history section).

Typically the following parameter will be used in the macro, in the following sections we'll find how to adapt this signature to this transformer needs:

| Parameter  | Observation     | Description |
|:-----------|:------------|:-------------|
| output     | html        | Determines how the transformed output is to be treated. (html, xhtml, wiki)|
| style      | required    | #url poting to the style to be used |
| source     | required    |              |
| parameter1 |             |              |
| parameter2 |             |              |
| parameterN |             |              |

Where parameter1..N, would be the parameters defined in the *signature* section.  
The same conventions to pass parameters as any other confluence macro should be honored. For instance a call a transformation of the Mule HTTP schema and its two included schemas would look like this:

```
{xslt:output=wiki|style=#https://raw.githubusercontent.com/mulesoft/mule-tool-schema-doc/master/src/main/resources/schemadoc.xsl|source=#http://www.mulesoft.org/schema/mule/http/3.5/mule-http.xsd|includedSchema1=http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd|includedSchema2=http://www.mulesoft.org/schema/mule/tcp/3.5/mule-tcp.xsd}
{xslt}
```

### Transport documentation

Transport documentation includes the following:

- Page title, in *common* or *all* mode. (schemadoc:page-title)
- Transport documentation, in *common* or *all* mode. (xsd:annotation/xsd:documentation)
- Connectors, in *common* or *all* mode.
- Endpoints, in *common* or *all* mode.
- Transformers, in *transformer* or *all* mode.
- Filters, in *filter* or *all* mode. 
- Specifics, (not any of the previous) in *specific* or *all* mode. (not any of the previous) 

#### Transport documentation example

Show all elements from the Mule HTTP schema:

```
{xslt:output=wiki|style=#https://raw.githubusercontent.com/mulesoft/mule-tool-schema-doc/master/src/main/resources/schemadoc.xsl|source=#http://www.mulesoft.org/schema/mule/http/3.5/mule-http.xsd|includedSchema1=http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd|includedSchema2=http://www.mulesoft.org/schema/mule/tcp/3.5/mule-tcp.xsd}
{xslt}
```
Here the outstanding elements are:

- includedSchema1, as *http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd*. This is the core schema of Mule, all the transports and modules will require this  schema.
- includeSchema2, as *http://www.mulesoft.org/schema/mule/tcp/3.5/mule-tcp.xsd*.
- schemaType, is absent as the default value is *transport*.
- display, is absent as the default value is *all*.

Show common elements from the Mule HTTP schema:

```
{xslt:output=wiki|style=#https://raw.githubusercontent.com/mulesoft/mule-tool-schema-doc/master/src/main/resources/schemadoc.xsl|source=#http://www.mulesoft.org/schema/mule/http/3.5/mule-http.xsd|includedSchema1=http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd|includedSchema2=http://www.mulesoft.org/schema/mule/tcp/3.5/mule-tcp.xsd|display=common}
{xslt}
```

Where:

- includedSchema1, as *http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd*. This is the core schema of Mule, all the transports and modules will require this  schema.
- includeSchema2, as *http://www.mulesoft.org/schema/mule/tcp/3.5/mule-tcp.xsd*.
- schemaType, is absent as the default value is *transport*.
- display, is specified as *common* as the default value is *all*.

### Module documentation

Module documentation includes the following:

- Page title, in *common* or *all* mode. (schemadoc:page-title)
- Module, documentation in *common* or *all* mode. (xsd:annotation/xsd:documentation)
- Components, in *common* or *all* mode.
- Transformers, in *common* or *all* mode.
- Filters, in *common* or *all* mode.
- Specifics, (not any of the previous) in *specific* or *all* mode. (not any of the previous)

#### Module documentation example

Show all elements from the XML module schema:

```
{xslt:output=wiki|style=#https://raw.githubusercontent.com/mulesoft/mule-tool-schema-doc/master/src/main/resources/schemadoc.xsl|source=#http://www.mulesoft.org/schema/mule/xml/3.5/mule-xml.xsd|includedSchema1=http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd|schemaType=module}
{xslt}
```

Here the outstanding elements are:

- includedSchema1, as *http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd*. This is the core schema of Mule, all the transports and modules will require this  schema.
- schemaType, as *module*. We need to specify the *schemaType* as module because the default value is *transport*.

Show specific elements from the XML module schema:

```
{xslt:output=wiki|style=#https://raw.githubusercontent.com/mulesoft/mule-tool-schema-doc/master/src/main/resources/schemadoc.xsl|source=#http://www.mulesoft.org/schema/mule/xml/3.5/mule-xml.xsd|includedSchema1=http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd|schemaType=module|display=specific}
{xslt}
```
Here the outstanding elements are:

- display, as *specific*. We are requiring the transformer to only render the specific elements.


### Single Element documentation

Single element documentation includes just the following:

- The element requested using the parameter *singleElementName*.

#### Single element documentation example

Show a selected transformer from the Mule XML Module.

```
{xslt:output=wiki|style=#https://raw.githubusercontent.com/mulesoft/mule-tool-schema-doc/master/src/main/resources/schemadoc.xsl|source=#http://www.mulesoft.org/schema/mule/xml/3.5/mule-xml.xsd|includedSchema1=http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd|includedSchema2=http://www.mulesoft.org/schema/mule/tcp/3.5/mule-tcp.xsd|schemaType=single|singleElementName=dom-to-xml-transformer}
{xslt}
```

Where:

- includedSchema1, as *http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd*. This is the core schema of Mule, all the transports and modules will require this  schema.
-includedSchema2, as *http://www.mulesoft.org/schema/mule/tcp/3.5/mule-tcp.xsd*.
- schemaType, as *single*. We need to specify the *schemaType* as *single* because the default value is *transport*.
- display, is nor required at all.
- singleElementName, as *dom-to-xml-transformer* the element to show.


## History 

This project is derivated from a previously existing [MuleESB](https://github.com/mulesoft/mule) module (year 2007) called the [schemadocs](https://github.com/mulesoft/mule/tree/mule-3.5.0/tools/schemadocs). The schemadocs module was abusing the capabilities or XSLT to do more than should be done.

A number fail-prone or not yet completed features of the previous module were removed from this project:

- Generate links between elements for HyperMedia documentation
- Aggregation of schema documents (CE only) into one big ball
- Site deployment (only actually worked till 3.1)
- Transport feature matrix. This is a two rows table showing the capabilities of transports.
- Generation of confluence`{snippets}` from the schema extracting `schemadoc:snippet` elements.

The old project is represented in the following tree. Only files marked with * were preserved.

```
.  
├── pom.xml  
└── src   
    ├── main  
    │   ├── java  
    │   │   └── org  
    │   │       └── mule  
    │   │           └── tools  
    │   │               └── schemadocs  
    │   │                   └── SchemaDocsMain.java  
    │   └── resources  
    │       ├── default-links.xsl  
    │       ├── full-doc-html.xsl  
    │       ├── links.xml  
    │       ├── log4j.properties  
    │       ├── mule-30-index.xml  
    │       ├── mule-31-index.xml  
    │       ├── rename-tag.xsl  
    │       ├── schemadoc-postfix.txt  
    │       ├── schemadoc-prefix.txt  
    │       ├── transport-to-links.xsl  
    │       ├── transport-to-wiki.xsl  
    │       └── xslt  
    │           ├── individual-module-wiki.xsl  *
    │           ├── individual-transport-or-module-wiki.xsl *
    │           ├── individual-transport-or-module.xsl  *
    │           ├── schemadoc-core-wiki.xsl * 
    │           ├── schemadoc-core.xsl  
    │           ├── single-element-wiki.xsl  *
    │           ├── single-element.xsl  
    │           ├── transport-feature-matrix.xsl (to be fixed)  
    │           └── transport-or-module.xsl  
    └── test  
        └── java  
            └── org  
                └── mule  
                    └── tools  
                        └── schemadocs  
                            └── PathTestCase.java                                  
```




