package fr.insee.eno.postprocessing.fr;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import fr.insee.eno.Constants;
import fr.insee.eno.postprocessing.Postprocessor;
import fr.insee.eno.transform.xsl.XslTransformation;

public class FRInsertGenericQuestionsPostprocessor implements Postprocessor {

	private static final Logger logger = LoggerFactory.getLogger(FRInsertGenericQuestionsPostprocessor.class);

	// FIXME Inject !
	private static XslTransformation saxonService = new XslTransformation();

	@Override
	public File process(File input, byte[] parameters, String surveyName) throws Exception {

		File outputForFRFile = new File(input.getParent(),"form"+Constants.INSERT_GENERIC_QUESTIONS_FR_EXTENSION);
		
		logger.debug("Output folder for basic-form : " + outputForFRFile.getAbsolutePath());
				
		InputStream inputStream = FileUtils.openInputStream(input);
		OutputStream outputStream = FileUtils.openOutputStream(outputForFRFile);
		
		InputStream FR_XSL = Constants.getInputStreamFromPath(Constants.UTIL_FR_INSERT_GENERIC_QUESTIONS_XSL);

		saxonService.transformFRToFRSimplePost(inputStream,outputStream, FR_XSL,parameters);
		inputStream.close();
		outputStream.close();
		FR_XSL.close();
		logger.info("End of Insert-generic-questions post-processing." + outputForFRFile.getAbsolutePath());

		return outputForFRFile;
	}

}
