package org.mulesoft.doc;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.URL;

import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.text.IsEmptyString.isEmptyOrNullString;

public class TransformationTestCase {

    public static final String MULE_CORE_SCHEMA = "http://www.mulesoft.org/schema/mule/core/3.5/mule.xsd";

    public static final String MULE_TRANSPORT_SCHEMA = "META-INF/mule-jms.xsd";

    public static final String MULE_MODULE_SCHEMA = "META-INF/mule-xml.xsd";

    public static final String SCHEMA_TRANSFORMER = "schemadoc.xsl";

    public static final String SCHEMA_INCLUSION_PARAMETER_1 = "includedSchema1";

    final Logger logger = LoggerFactory.getLogger(getClass());

    @Test
    public void testTransport() throws TransformerException
    {
        TransformerFactory factory = TransformerFactory.newInstance();

        Source template = createSourceFromSystemId(SCHEMA_TRANSFORMER);
        Source input = createSourceFromSystemId(MULE_TRANSPORT_SCHEMA);

        StringWriter result = new StringWriter();
        Transformer transformer = factory.newTransformer(template);

        transformer.setParameter(SCHEMA_INCLUSION_PARAMETER_1, MULE_CORE_SCHEMA);
        transformer.transform(input, new StreamResult(result));
        System.out.println(result.toString());

        logger.info(result.toString());
        assertThat(result.toString(), not(isEmptyOrNullString()));
    }

    @Test
    public void testModule() throws TransformerException
    {
        TransformerFactory factory = TransformerFactory.newInstance();

        Source template = createSourceFromSystemId(SCHEMA_TRANSFORMER);
        Source input = createSourceFromSystemId(MULE_MODULE_SCHEMA);

        StringWriter result = new StringWriter();
        Transformer transformer = factory.newTransformer(template);

        transformer.setParameter(SCHEMA_INCLUSION_PARAMETER_1, MULE_CORE_SCHEMA);
        transformer.transform(input, new StreamResult(result));

        System.out.println(result.toString());

        logger.info(result.toString());
        assertThat(result.toString(), not(isEmptyOrNullString()));
    }

    protected Source createSourceFromSystemId(String systemID)
    {
        ClassLoader cl = this.getClass().getClassLoader();
        InputStream in = cl.getResourceAsStream(systemID);
        URL url = cl.getResource(systemID);
        Source source = new StreamSource(in);
        source.setSystemId(url.toExternalForm());
        return source;
    }

}
