<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:schemadoc="http://www.mulesoft.org/schema/mule/schemadoc">

    <!-- We're rendering Confluence's Wiki Markup, a derivative of textile.
     For more information about it visit:
     https://confluence.atlassian.com/display/CONF34/Confluence+Notation+Guide+Overview -->
    <xsl:output method="text" standalone="no" indent="no" use-character-maps="escape-wiki-chars" />

    <!-- Escape map for special characters of wiki markup -->
    <xsl:character-map name="escape-wiki-chars">
        <xsl:output-character character="[" string="[["/>
        <xsl:output-character character="]" string="]]"/>
    </xsl:character-map>


    <!-- which elements should be displayed. Value can be one of:
      - all: render all elements (common first). Default value.
      - common: render connector, inbound-endpoint, outbound-endpoint and endpoint elements
      - transformers: renders only the transformers
      - filters: renders only the filters
      - specific: all other elements specific to the schema being processed
      - 'element name': The name of a single element to render -->
    <xsl:param name="display" select="'all'"/>

    <!-- defines the type of schema this XSLT is processing. It could be:
      - transport: will treat the XSD as a Mule's transport. Default value.
      - module: will treat the XSD as a Mule's transport
      - single: will only render one single element of the schema -->
    <xsl:param name="schemaType" select="'transport'"/>

    <!-- in case we defined the schemaType as single the singleElementName should be defined
        to specify the exact single element that should be shown -->
    <xsl:param name="singleElementName"/>

    <!-- Absolute URL of an Schema that is included in the source -->
    <!-- this parameter intentionally does not have a default value pointing to mule-core.xsd as
        the version path of the url would soon become outdated creating confusion for the user of this schema -->
    <xsl:param name="includedSchema1"/>

    <!-- Absolute URL of an Schema that is included in the source -->
    <xsl:param name="includedSchema2"/>

    <!-- Absolute URL of an Schema that is included in the source -->
    <xsl:param name="includedSchema3"/>

    <!-- Absolute URL of an Schema that is included in the source -->
    <xsl:param name="includedSchema4"/>

    <!-- Absolute URL of an Schema that is included in the source -->
    <xsl:param name="includedSchema5"/>

    <!-- Absolute URL of an Schema that is included in the source -->
    <xsl:param name="includedSchema6"/>


    <!-- ################################################  MAIN ################################################ -->

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$schemaType = 'transport'">
                <xsl:call-template name="transportTemplate"/>
            </xsl:when>
            <xsl:when test="$schemaType = 'module'">
                <xsl:call-template name="moduleTemplate"/>
            </xsl:when>
            <xsl:when test="$schemaType = 'single'">
                <xsl:call-template name="singleTemplate"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">ERROR: 'schemaType' parameter is invalid. It should be 'transport', 'module' or 'single' but instead it was <xsl:value-of select="$schemaType"/>.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- ################################################  MODULE ################################################ -->

    <xsl:template name="moduleTemplate">

        <xsl:if test="$display = 'common' or $display = 'all'">
            <xsl:choose>
                <xsl:when test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:page-title">
                    <xsl:text>h1. </xsl:text><xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:page-title"/><xsl:text>&#xA;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">ERROR: 'schemadoc:page-title' is not defined in the source XSD, please report an issue.</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="normalize-space(/xsd:schema/xsd:annotation/xsd:documentation)"/>

            <xsl:if test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='before-common-elements']">
                <xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='before-common-elements']"/>
            </xsl:if>

            <xsl:apply-templates select="/xsd:schema/xsd:element[@name='component']" mode="single-element"/>

            <xsl:if test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='after-common-elements']">
                <xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='after-common-elements']"/>
            </xsl:if>
        </xsl:if>

        <xsl:if test="$display = 'transformers' or $display = 'all'">
            <xsl:apply-templates select="/xsd:schema/xsd:element[@name='transformer']" mode="single-element"/>
        </xsl:if>

        <xsl:if test="$display = 'filters' or $display = 'all'">
            <xsl:apply-templates select="/xsd:schema/xsd:element[@name='filter']" mode="single-element"/>
        </xsl:if>

        <xsl:if test="$display = 'specific' or $display = 'all'">

            <xsl:if test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='before-specific-elements']">
                <xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='before-specific-elements']"/>
            </xsl:if>

            <xsl:apply-templates select="/xsd:schema/xsd:element[
                    @name!='transformer' and
                    @name!='component' and
                    @name!='filter']" mode="single-element"/>

            <xsl:if test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='after-specific-elements']">
                <xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='after-specific-elements']"/>
            </xsl:if>
        </xsl:if>

    </xsl:template>


    <!-- ################################################  TRANSPORT ################################################ -->

    <xsl:template name="transportTemplate">

        <xsl:if test="$display = 'common' or $display = 'all'">
            <xsl:choose>
                <xsl:when test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:page-title">h1. <xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:page-title"/></xsl:when>
                <xsl:otherwise>h1. Transport (schemadoc:page-title not set)</xsl:otherwise>
            </xsl:choose>
            \\
            <xsl:value-of select="normalize-space(/xsd:schema/xsd:annotation/xsd:documentation)"/>

            <xsl:if test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='before-common-elements']">
                <xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='before-common-elements']"/>
            </xsl:if>

            <xsl:apply-templates select="/xsd:schema/xsd:element[@name='connector']" mode="single-element"/>
            <xsl:apply-templates select="/xsd:schema/xsd:element[@name='inbound-endpoint']" mode="single-element"/>
            <xsl:apply-templates select="/xsd:schema/xsd:element[@name='outbound-endpoint']" mode="single-element"/>
            <xsl:apply-templates select="/xsd:schema/xsd:element[@name='endpoint']" mode="single-element"/>

            <xsl:if test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='after-common-elements']">
                <xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='after-common-elements']"/>
            </xsl:if>
        </xsl:if>

        <xsl:if test="$display = 'transformers' or $display = 'all'">
            <xsl:if test="/xsd:schema/xsd:element[contains(@substitutionGroup,'abstract-transformer')]">
                <xsl:call-template name="transformers"/>
            </xsl:if>
        </xsl:if>

        <xsl:if test="$display = 'filters' or $display = 'all'">
            <xsl:if test="/xsd:schema/xsd:element[contains(@substitutionGroup,'abstract-filter')]">
                <xsl:call-template name="filters"/>
            </xsl:if>
        </xsl:if>

        <xsl:if test="$display = 'specific' or $display = 'all'">

            <xsl:if test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='before-specific-elements']">
                <xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='before-specific-elements']"/>
            </xsl:if>

            <xsl:apply-templates select="/xsd:schema/xsd:element[
                    @name!='connector' and
                    @name!='endpoint' and
                    @name!='inbound-endpoint' and
                    @name!='outbound-endpoint' and
                    not(starts-with(@name, 'abstract')) and
                    not(contains(@substitutionGroup,'abstract-transformer')) and
                    not(contains(@substitutionGroup,'abstract-filter'))]" mode="single-element"/>

            <xsl:if test="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='after-specific-elements']">
                <xsl:value-of select="/xsd:schema/xsd:annotation/xsd:appinfo/schemadoc:additional-documentation[@where='after-specific-elements']"/>
            </xsl:if>
        </xsl:if>

    </xsl:template>

    <!-- ################################################  SINGLE ################################################ -->

    <xsl:template name="singleTemplate">
        <xsl:apply-templates select="//xsd:element[@name=$singleElementName]" mode="single-element"/>
    </xsl:template>


    <!-- ################################################  COMMON ################################################ -->

    <!-- The header tag that will precede parent elements, e.g. &#10;h2., h2. Connector -->
    <xsl:variable name="parentHeaderLevel">&#10;h2. </xsl:variable>

    <!-- The header tag that will precede child elements, e.g. for &#10;h3, h3. Attributes of <connector...> -->
    <xsl:variable name="childHeaderLevel">&#10;h3. </xsl:variable>

    <xsl:template match="xsd:element" mode="single-element">

        <xsl:variable name="temp" select="translate(@name, '-', ' ')"/>
        <xsl:variable name="t" select="concat( translate( substring( $temp, 1, 1 ),'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' ), substring( $temp, 2, string-length( $temp )))"/>

        <xsl:value-of select="$parentHeaderLevel"/><xsl:value-of select="$t"/>
        <xsl:value-of select="xsd:annotation/xsd:documentation"/>

        <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

        <xsl:apply-templates select="//xsd:complexType[@name=$type]" mode="table">
            <xsl:with-param name="name"><xsl:value-of select="@name"/></xsl:with-param>
        </xsl:apply-templates>

        <xsl:if test="@type">
            <xsl:value-of select="$childHeaderLevel"/>Child Elements of &lt;<xsl:value-of select="@name"/>...&gt;
            ||Name||Cardinality||Description||
            <xsl:variable name="type" select="@type"/>
            <xsl:apply-templates select="/xsd:schema/xsd:complexType[@name=$type]" mode="elements"/>      
        </xsl:if>
    </xsl:template>

    <xsl:template match="xsd:complexType" mode="table">
        <xsl:param name="name"/>
        <xsl:value-of select="$childHeaderLevel"/>
        <xsl:text>Attributes of &lt;</xsl:text><xsl:value-of select="$name"/><xsl:text>...&gt;&#xA;</xsl:text>
        <xsl:text>||Name||Type||Required||Default||Description||&#xA;</xsl:text>
        <xsl:apply-templates select="." mode="attributes"/>
    </xsl:template>

    <!-- TRANSFORMERS -->
    <xsl:template name="transformers">
        <xsl:value-of select="$childHeaderLevel"/>
        <xsl:text disable-output-escaping="yes">Transformers&#xA;These are transformers specific to this transport. Note that these are added automatically to the Mule registry at start up. When doing automatic transformations these will be included when searching for the correct transformers.&#xA;</xsl:text>
        <xsl:text disable-output-escaping="yes">||Name||Description||&#xA;</xsl:text>
        <xsl:apply-templates select="//xsd:element[contains(@substitutionGroup,'abstract-transformer')]" mode="transformer"/>
    </xsl:template>

    <xsl:template match="xsd:element" mode="transformer">
        <xsl:text disable-output-escaping="yes">|</xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">|</xsl:text>
        <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/><xsl:text disable-output-escaping="yes">|&#xA;</xsl:text>
    </xsl:template>

    <!-- FILTERS -->
    <xsl:template name="filters">
        <xsl:value-of select="$childHeaderLevel"/>
        <xsl:text disable-output-escaping="yes">Filters&#xA;Filters can be used to control which data is allowed to continue in the flow.&#xA;</xsl:text>
        <xsl:text disable-output-escaping="yes">||Name||Description||&#xA;</xsl:text>
        <xsl:apply-templates select="//xsd:element[contains(@substitutionGroup,'abstract-filter')]" mode="filter"/>
    </xsl:template>

    <xsl:template match="xsd:element" mode="filter">
        <xsl:text disable-output-escaping="yes">|</xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">|</xsl:text>
        <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/><xsl:text disable-output-escaping="yes">|&#xA;</xsl:text>
    </xsl:template>


    <!-- end AppInfo processng -->


    <!-- documentation

       we need to collect documentation from:
       - the ref
       - the element
       - the type
       we don't use extension or substitution here -->

    <xsl:template match="xsd:element[@ref]" mode="documentation">
        <xsl:if test="xsd:annotation/xsd:documentation/text()|xsd:annotation/xsd:documentation/*">
            <xsl:apply-templates select="xsd:annotation/xsd:documentation/*|xsd:annotation/xsd:documentation/text()" mode="copy"/>
            <xsl:call-template name="attribution">
                <xsl:with-param name="text">From reference for element<xsl:value-of select="@ref"/>.</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="ref" select="@ref"/>
        <xsl:apply-templates select="/xsd:schema/xsd:element[@name=$ref]" mode="documentation"/>
    </xsl:template>

    <xsl:template match="xsd:element[@name]" mode="documentation">
        <xsl:if test="xsd:annotation/xsd:documentation/text()|xsd:annotation/xsd:documentation/*">
            <xsl:apply-templates select="xsd:annotation/xsd:documentation/*|xsd:annotation/xsd:documentation/text()" mode="copy"/>
            <xsl:call-template name="attribution">
                <xsl:with-param name="text">From declaration of element <xsl:value-of select="@name"/>.</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="@type">
            <xsl:variable name="type" select="@type"/>
            <xsl:apply-templates select="/xsd:schema/xsd:complexType[@name=$type]" mode="documentation"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@*|node()" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="copy"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:complexType" mode="documentation">
        <xsl:if test="xsd:annotation/xsd:documentation/text()|xsd:annotation/xsd:documentation/*">
            <xsl:apply-templates select="xsd:annotation/xsd:documentation/*|xsd:annotation/xsd:documentation/text()" mode="copy"/>
            <xsl:call-template name="attribution">
                <xsl:with-param name="text">
                    <xsl:choose>
                        <xsl:when test="@name">From declaration of type<xsl:value-of select="@name"/>.</xsl:when>
                        <xsl:otherwise>From type declaration.</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <!-- attributes -->

    <xsl:template match="xsd:attribute[@name]" mode="attributes">
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="string-length(@type)">
                    <xsl:call-template name="rewrite-type">
                        <xsl:with-param name="type" select="@type"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="xsd:simpleType/xsd:restriction/xsd:enumeration">enumeration</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="required">
            <xsl:choose>
                <xsl:when test="@use='required'">yes</xsl:when>
                <xsl:otherwise>no</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="default">
            <xsl:if test="@default">
                <xsl:value-of select="@default"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="doc">
            <xsl:if test="xsd:annotation/xsd:documentation/text()|xsd:annotation/xsd:documentation/*">
                <xsl:apply-templates select="xsd:annotation/xsd:documentation/*|xsd:annotation/xsd:documentation/text()" mode="copy"/>
            </xsl:if>
        <!-- leave this line as-is -->
        </xsl:variable>|<xsl:value-of select="@name"/> |<xsl:value-of select="$type"/> |<xsl:value-of select="$required"/> |<xsl:value-of select="$default"/> |<xsl:value-of select="normalize-space($doc)"/>|
    </xsl:template>


    <xsl:template match="xsd:element" mode="attributes">
        <xsl:call-template name="attribute-children"/>
        <xsl:if test="@ref">
            <xsl:variable name="ref" select="@ref"/>
            <xsl:apply-templates select="/xsd:schema/xsd:element[@name=$ref]" mode="attributes"/>
        </xsl:if>
        <xsl:if test="@type">
            <xsl:variable name="type" select="@type"/>
            <xsl:apply-templates select="/xsd:schema/xsd:complexType[@name=$type]" mode="attributes"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="attribute-children">
        <xsl:apply-templates select="xsd:attribute" mode="attributes"/>
        <xsl:apply-templates select="xsd:attributeGroup" mode="attributes"/>
        <xsl:apply-templates select="xsd:sequence" mode="attributes"/>
        <xsl:apply-templates select="xsd:choice" mode="attributes"/>
        <xsl:apply-templates select="xsd:complexType" mode="attributes"/>
        <xsl:apply-templates select="xsd:complexContent" mode="attributes"/>
        <xsl:apply-templates select="xsd:extension" mode="attributes"/>
    </xsl:template>

    <xsl:template name="attributes-from-parent-schema">
        <xsl:param name="parentSchema"/>
        <xsl:param name="typeLocalName"/>
        <xsl:param name="typeNamespace"/>

        <xsl:if test="$parentSchema">
            <xsl:if test="document($parentSchema)/*/@targetNamespace=$typeNamespace">
                <xsl:apply-templates select="document($parentSchema)/xsd:schema/xsd:complexType[@name=$typeLocalName]" mode="attributes"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="elements-from-parent-schema">
        <xsl:param name="parentSchema"/>
        <xsl:param name="typeLocalName"/>
        <xsl:param name="typeNamespace"/>
        <xsl:if test="$parentSchema">
            <xsl:if test="document($parentSchema)/*/@targetNamespace=$typeNamespace">
                <xsl:apply-templates select="document($parentSchema)/xsd:schema/xsd:complexType[@name=$typeLocalName]" mode="elements"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xsd:attributeGroup" mode="attributes">
        <xsl:if test="@ref">
            <xsl:variable name="ref" select="@ref"/>
            <xsl:apply-templates select="/xsd:schema/xsd:attributeGroup[@name=$ref]" mode="attributes"/>
        </xsl:if>
        <xsl:call-template name="attribute-children"/>
    </xsl:template>

    <xsl:template match="xsd:sequence" mode="attributes">
        <xsl:call-template name="attribute-children"/>
    </xsl:template>

    <xsl:template match="xsd:choice" mode="attributes">
        <xsl:call-template name="attribute-children"/>
    </xsl:template>

    <xsl:template match="xsd:complexType" mode="attributes">
        <xsl:call-template name="attribute-children"/>
    </xsl:template>

    <xsl:template match="xsd:complexContent" mode="attributes">
        <xsl:call-template name="attribute-children"/>
    </xsl:template>

    <xsl:template match="xsd:extension" mode="attributes">
        <xsl:variable name="base" select="@base"/>
        <xsl:variable name="topElement" select="ancestor::xsd:schema"/>
        <xsl:variable name="schemaNs" select="$topElement/@targetNamespace"/>
        <xsl:variable name="prefix" select="substring-before($base, ':')"/>

        <xsl:variable name="local">
            <xsl:choose>
                <xsl:when test="contains($base, ':')"><xsl:value-of select="substring-after($base, ':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$base"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="itemNs">
            <xsl:choose>
                <xsl:when test="$prefix"><xsl:value-of select="$topElement/namespace::*[local-name()=$prefix]"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$schemaNs"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="/*/@targetNamespace=$itemNs">
            <xsl:apply-templates select="/xsd:schema/xsd:complexType[@name=$base]" mode="attributes"/>
        </xsl:if>

        <xsl:call-template name ="attributes-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema1"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="attributes-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema2"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="attributes-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema3"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="attributes-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema4"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="attributes-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema5"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="attributes-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema6"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name="attribute-children"/>
    </xsl:template>


    <!-- child elements -->
    <!-- documentation here more restricted than "documentation" mode -->


    <xsl:template match="xsd:element[@ref]" mode="elements">
        <!-- cardinality i.e. minoccurs/maxoccurs -->
        <xsl:variable name="min">
            <xsl:choose>
                <xsl:when test="@minOccurs"><xsl:value-of select="@minOccurs"/></xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="max">
            <xsl:choose>
                <xsl:when test="@maxOccurs='unbounded'">*</xsl:when>
                <xsl:when test="@maxOccurs"><xsl:value-of select="@maxOccurs"/></xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ref" select="@ref"/>
        <xsl:variable name="doc">
            <xsl:apply-templates select="." mode="elements-doc"/>
            <xsl:apply-templates select="/xsd:schema/xsd:element[@name=$ref]" mode="elements-doc"/>
            <xsl:apply-templates select="/xsd:schema/xsd:element[@name=$ref]" mode="elements-abstract"/>
        </xsl:variable>
        <xsl:text>|</xsl:text><xsl:value-of select="@ref"/>
        <xsl:text> |</xsl:text><xsl:value-of select="$min"/><xsl:text>..</xsl:text><xsl:value-of select="$max"/>
        <xsl:text> |</xsl:text><xsl:value-of select="normalize-space($doc)"/><xsl:text> |&#xA;</xsl:text>
    </xsl:template>

    <xsl:template match="xsd:element[contains(@name, ':abstract-')]" mode="elements-abstract">
        <xsl:variable name="name" select="@name"/>
        <xsl:choose>
            <!-- this should always be true when using the normalized schema -->
            <xsl:when test="/xsd:schema/xsd:element[@substitutionGroup=$name]">
                <xsl:text>The following elements can be used here:</xsl:text>
                <xsl:apply-templates select="/xsd:schema/xsd:element[@substitutionGroup=$name]" mode="elements-list"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>This is an abstract element; another element with a compatible type must be used in its place. However, no replacements were found when generating this documentation.</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- otherwise, do nothing -->
    <xsl:template match="xsd:element" mode="elements-abstract"/>

    <xsl:template match="xsd:element[@name]" mode="elements-list">
        <xsl:value-of select="@name"/>
    </xsl:template>

    <xsl:template match="xsd:element" mode="elements-doc">
        <xsl:if test="xsd:annotation/xsd:documentation/text()|xsd:annotation/xsd:documentation/*">
            <xsl:apply-templates select="xsd:annotation/xsd:documentation/*|xsd:annotation/xsd:documentation/text()" mode="copy"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="element-children">
        <xsl:apply-templates select="xsd:element" mode="elements"/>
        <xsl:apply-templates select="xsd:group" mode="elements"/>
        <xsl:apply-templates select="xsd:sequence" mode="elements"/>
        <xsl:apply-templates select="xsd:choice" mode="elements"/>
        <xsl:apply-templates select="xsd:complexType" mode="elements"/>
        <xsl:apply-templates select="xsd:complexContent" mode="elements"/>
        <xsl:apply-templates select="xsd:extension" mode="elements"/>
    </xsl:template>

    <xsl:template match="xsd:element[@name]" mode="elements">
        <!-- cardinality i.e. minoccurs/maxoccurs -->
        <xsl:variable name="min">
            <xsl:choose>
                <xsl:when test="@minOccurs">
                    <xsl:value-of select="@minOccurs"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="max">
            <xsl:choose>
                <xsl:when test="@maxOccurs='unbounded'">*</xsl:when>
                <xsl:when test="@maxOccurs">
                    <xsl:value-of select="@maxOccurs"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ref" select="@ref"/>
        <xsl:variable name="doc">
            <xsl:apply-templates select="." mode="elements-doc"/>
        </xsl:variable>
        <!-- don't show annotations tag, it's for third party documentation only -->
        <xsl:if test="@name != 'annotations'">
            <xsl:text>|</xsl:text><xsl:value-of select="@name"/><xsl:text>|</xsl:text><xsl:value-of select="$min"/><xsl:text>..</xsl:text><xsl:value-of select="$max"/><xsl:text>|</xsl:text><xsl:value-of select="normalize-space($doc)"/><xsl:text>|&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xsd:group" mode="elements">
        <xsl:if test="@ref">
            <xsl:variable name="ref" select="@ref"/>
            <xsl:apply-templates select="/xsd:schema/xsd:group[@name=$ref]" mode="elements"/>
        </xsl:if>
        <xsl:call-template name="element-children"/>
    </xsl:template>

    <xsl:template match="xsd:sequence" mode="elements">
        <xsl:call-template name="element-children"/>
    </xsl:template>

    <xsl:template match="xsd:choice" mode="elements">
        <xsl:call-template name="element-children"/>
    </xsl:template>

    <xsl:template match="xsd:complexType" mode="elements">
        <xsl:call-template name="element-children"/>
    </xsl:template>

    <xsl:template match="xsd:complexContent" mode="elements">
        <xsl:call-template name="element-children"/>
    </xsl:template>

    <xsl:template match="xsd:extension" mode="elements">
        <!--extension <xsl:value-of select="@name"/>-->
        <xsl:variable name="base" select="@base"/>
        <xsl:variable name="topElement" select="ancestor::xsd:schema"/>
        <xsl:variable name="schemaNs" select="$topElement/@targetNamespace"/>
        <xsl:variable name="prefix" select="substring-before($base, ':')"/>

        <xsl:variable name="local">
            <xsl:choose>
                <xsl:when test="contains($base, ':')"><xsl:value-of select="substring-after($base, ':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$base"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="itemNs">
            <xsl:choose>
                <xsl:when test="$prefix"><xsl:value-of select="$topElement/namespace::*[local-name()=$prefix]"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$schemaNs"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="/*/@targetNamespace=$itemNs">
            <xsl:apply-templates select="/xsd:schema/xsd:complexType[@name=$base]" mode="elements"/>
        </xsl:if>

        <xsl:call-template name ="elements-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema1"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="elements-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema2"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="elements-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema3"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="elements-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema4"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="elements-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema5"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name ="elements-from-parent-schema">
            <xsl:with-param name="parentSchema" select="$includedSchema6"/>
            <xsl:with-param name="typeLocalName" select="$local"/>
            <xsl:with-param name="typeNamespace" select="$itemNs"/>
        </xsl:call-template>
        <xsl:call-template name="element-children"/>
        <!--extension done-->
    </xsl:template>


    <!-- substitution -->
    <xsl:template match="xsd:element[@substitutionGroup]" mode="substitution">
        <xsl:variable name="sub" select="@substitutionGroup"/>
        This element can be used as a substitute for &lt;<xsl:value-of select="$sub"/>...&gt;
        <xsl:apply-templates select="/xsd:schema/xsd:element[@name=$sub]" mode="documentation"/>
    </xsl:template>


    <!-- Convert Mule or XSD specific types to a human readable form.
        This is accomplished by first removing the mule: or xsd: prefix in case it exists, to then translate:
        substitutableInt -> integer, substitutableBoolean -> boolean, substitutableLong -> long, substitutablePortNumber -> port number
        substitutableClass -> class name, substitutableName or NMTOKEN or IDREF -> name (no spaces), nonBlankString -> name
        NMTOKENS -> list of names, otherwise leave the name as is -->
    <xsl:template name="rewrite-type">
        <xsl:param name="type"/>
        <xsl:variable name="simpleType">
            <xsl:choose>
                <xsl:when test="starts-with($type, 'mule:')"><xsl:value-of select="substring($type, 6)"/></xsl:when>
                <xsl:when test="starts-with($type, 'xsd:')"><xsl:value-of select="substring($type, 5)"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$simpleType='substitutableInt'">integer</xsl:when>
            <xsl:when test="$simpleType='substitutableBoolean'">boolean</xsl:when>
            <xsl:when test="$simpleType='substitutableLong'">long</xsl:when>
            <xsl:when test="$simpleType='substitutablePortNumber'">port number</xsl:when>
            <xsl:when test="$simpleType='substitutableClass'">class name</xsl:when>
            <xsl:when test="$simpleType='substitutableName' or $simpleType='NMTOKEN' or $simpleType='IDREF'">name (no spaces)</xsl:when>
            <xsl:when test="$simpleType='nonBlankString'">name</xsl:when>
            <xsl:when test="$simpleType='NMTOKENS'">list of names</xsl:when>
            <xsl:otherwise><xsl:value-of select="$simpleType"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- add attribution (from declaration of element...) -->
    <xsl:template name="attribution">
        <xsl:param name="text"/>
    </xsl:template>

</xsl:stylesheet>
