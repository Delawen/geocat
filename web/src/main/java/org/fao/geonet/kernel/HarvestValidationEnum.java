package org.fao.geonet.kernel;

import jeeves.server.context.ServiceContext;

import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.jdom.Element;

public enum HarvestValidationEnum {

	NOVALIDATION {

		public void validate(DataManager dataMan, ServiceContext context, Element xml) throws Exception {
			return;
		}
	},
	
	/**
	 * Process validation against schema
	 */
	XSDVALIDATION {

		public void validate(DataManager dataMan, ServiceContext context, Element xml) throws Exception {
			dataMan.setNamespacePrefix(xml);
			
			String schema=((GeonetContext)context.getHandlerContext(Geonet.CONTEXT_NAME)).getSchemamanager().autodetectSchema(xml);
			dataMan.validate(schema, xml);
			
		}
		
	},
	
	/**
	 * Process validation against schematron and XSD
	 */
	SCHEMATRONVALIDATION {

		public void validate(DataManager dataMan, ServiceContext context, Element xml) throws Exception {
			String schema=((GeonetContext)context.getHandlerContext(Geonet.CONTEXT_NAME)).getSchemamanager().autodetectSchema(xml);
			DataManager.validateMetadata(schema, xml, context);			
		}
		
	};
	
	public abstract void validate(DataManager dataMan, ServiceContext context, Element xml) throws Exception;
	
	public static HarvestValidationEnum lookup(final String name) {
		if("true".equals(name)) {
			return HarvestValidationEnum.XSDVALIDATION;
		}
		if("false".equals(name)) {
			return HarvestValidationEnum.NOVALIDATION;
		}
		if(HarvestValidationEnum.NOVALIDATION.name().equals(name)) {
			return HarvestValidationEnum.NOVALIDATION;
		}
		if(HarvestValidationEnum.XSDVALIDATION.name().equals(name)) {
			return HarvestValidationEnum.XSDVALIDATION;
		}
		if(HarvestValidationEnum.SCHEMATRONVALIDATION.name().equals(name)) {
			return HarvestValidationEnum.SCHEMATRONVALIDATION;
		}
		return HarvestValidationEnum.NOVALIDATION;
	}
}
