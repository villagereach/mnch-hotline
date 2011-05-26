-- MySQL dump 10.11
--
-- Host: localhost    Database: openmrs_1_5
-- ------------------------------------------------------
-- Server version	5.0.67

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `system_id` varchar(50) NOT NULL default '',
  `username` varchar(50) default NULL,
  `password` varchar(128) default NULL,
  `salt` varchar(128) default NULL,
  `secret_question` varchar(255) default NULL,
  `secret_answer` varchar(255) default NULL,
  `creator` int(11) NOT NULL default '0',
  `date_created` datetime NOT NULL default '0000-00-00 00:00:00',
  `changed_by` int(11) default NULL,
  `date_changed` datetime default NULL,
  `voided` smallint(6) NOT NULL default '0',
  `voided_by` int(11) default NULL,
  `date_voided` datetime default NULL,
  `void_reason` varchar(255) default NULL,
  PRIMARY KEY  (`user_id`),
  KEY `user_creator` (`creator`),
  KEY `user_who_changed_user` (`changed_by`),
  KEY `user_who_voided_user` (`voided_by`),
  CONSTRAINT `person_id_for_user` FOREIGN KEY (`user_id`) REFERENCES `person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `user_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_changed_user` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_who_voided_user` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'1-8','admin','4a1750c8607d0fa237de36c6305715c223415189','c788c6ad82a157b712392ca695dfcf2eed193d7f','',NULL,1,'2005-01-01 00:00:00',15878,'2008-04-15 00:00:00',0,NULL,NULL,''),(21,'','mikmck','904bf83b60c821aacc43d601b203b124a63fa08f','laWkLAw6QB',NULL,NULL,1,'2007-10-17 15:01:53',1,'2007-10-17 15:01:53',0,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `global_property`
--

DROP TABLE IF EXISTS `global_property`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `global_property` (
  `property` varchar(255) NOT NULL default '',
  `property_value` mediumtext,
  `description` text,
  `id` int(11) NOT NULL auto_increment,
  `uuid` char(38) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `global_property_uuid_index` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `global_property`
--

LOCK TABLES `global_property` WRITE;
/*!40000 ALTER TABLE `global_property` DISABLE KEYS */;
INSERT INTO `global_property` VALUES ('birt.birtHome','/usr/bin/birt-runtime-2_3_2/ReportEngine','Specifies the absolute path to the BIRT Report Engine.  Should include ReportEngine subdirectory. (ex. C:/birt-runtime-2_2_0/ReportEngine)',1,'b54c8440-2695-102d-b4c2-001d929acb54'),('birt.database_version','1.0.0','DO NOT MODIFY.  Current database version number for the birt module.',2,'b54c8bc0-2695-102d-b4c2-001d929acb54'),('birt.datasetDir','/home/tomcat5/.OpenMRS/birt/datasets','Specifies the absolute path to the reports dataset directory (for CSV/XML data sources). (ex. C:/Documents and Settings/USERNAME/OpenMRS/reports/datasets)',3,'b54c8cb0-2695-102d-b4c2-001d929acb54'),('birt.defaultReportDesignFile','default.rptdesign','Specifies the name of the default report design file.\r\nExample: default.rptdesign',4,'b54c8d82-2695-102d-b4c2-001d929acb54'),('birt.loggingDir','/home/tomcat5/.OpenMRS/birt/logs','Specifies the absolute path for log files written by BIRT Engine.  (ex. C:/tmp/logs)',5,'b54c8e4a-2695-102d-b4c2-001d929acb54'),('birt.outputDir','/home/tomcat5/.OpenMRS/birt/reports/output','Specifies the absolute path to the report output file when reports are generated. (ex. C:/Documents and Settings/USERNAME/OpenMRS/reports/output)',6,'b54c8f1c-2695-102d-b4c2-001d929acb54'),('birt.reportDir','/home/tomcat5/.OpenMRS/birt/reports','Specifies the absolute path where report design files are uploaded.  (ex. C:/Documents and Settings/USERNAME/OpenMRS/reports)',7,'b54c9304-2695-102d-b4c2-001d929acb54'),('birt.reportOutputFile','/home/tomcat5/.OpenMRS/birt/reports/output/ReportOutput.pdf','Specifies the absolute path to the reports output file.  (ex. C:/Documents and Settings/USERNAME/OpenMRS/reports/output/ReportOutput.pdf)',8,'b54c93d6-2695-102d-b4c2-001d929acb54'),('birt.reportOutputFormat','pdf','Specifies the absolute path to the reports output format.(ex. pdf)',9,'b54c94a8-2695-102d-b4c2-001d929acb54'),('birt.reportPreviewFile','/home/tomcat5/.OpenMRS/birt/reports/output/ReportPreview.pdf','Specifies the absolute path to the report preview file.  (ex. C:/Documents and Settings/USERNAME/OpenMRS/reports/output/ReportPreview.pdf)',10,'b54c9570-2695-102d-b4c2-001d929acb54'),('birt.started','true','DO NOT MODIFY. true/false whether or not the birt module has been started.  This is used to make sure modules that were running  prior to a restart are started again',11,'b54c9638-2695-102d-b4c2-001d929acb54'),('concept.causeOfDeath','5002','Concept id of the concept defining the CAUSE OF DEATH concept',12,'b54c9700-2695-102d-b4c2-001d929acb54'),('concept.cd4_count','5497','Concept id of the concept defining the CD4 count concept',13,'b54c97c8-2695-102d-b4c2-001d929acb54'),('concept.height','5090','Concept id of the concept defining the HEIGHT concept',14,'b54c9890-2695-102d-b4c2-001d929acb54'),('concept.medicalRecordObservations','1238','The concept id of the MEDICAL_RECORD_OBSERVATIONS concept.  This concept_id is presumed to be the generic grouping (obr) concept in hl7 messages.  An obs_group row is not created for this concept.',15,'b54c9958-2695-102d-b4c2-001d929acb54'),('concept.none','1107','Concept id of the concept defining the NONE concept',16,'b54c9a20-2695-102d-b4c2-001d929acb54'),('concept.otherNonCoded','5622','Concept id of the concept defining the OTHER NON-CODED concept',17,'b54ca1f0-2695-102d-b4c2-001d929acb54'),('concept.patientDied','1742','Concept id of the concept defining the PATIEND DIED concept',18,'b54ca2c2-2695-102d-b4c2-001d929acb54'),('concept.reasonExitedCare','1811','Concept id of the concept defining the REASON EXITED CARE concept',19,'b54ca394-2695-102d-b4c2-001d929acb54'),('concept.reasonOrderStopped','1812','Concept id of the concept defining the REASON ORDER STOPPED concept',20,'b54ca452-2695-102d-b4c2-001d929acb54'),('concept.weight','5089','Concept id of the concept defining the WEIGHT concept',21,'b54ca51a-2695-102d-b4c2-001d929acb54'),('concepts.locked','false','true/false whether or not concepts can be edited in this database.',22,'b54ca5e2-2695-102d-b4c2-001d929acb54'),('current_health_center_name','Balaka District Hospital','Sets the current health center using the health center name for Ror.',23,'b54ca6aa-2695-102d-b4c2-001d929acb54'),('dashboard.encounters.showEditLink','true','true/false whether or not to show the \'Edit Encounter\' link on the patient dashboard',24,'b54ca772-2695-102d-b4c2-001d929acb54'),('dashboard.encounters.showEmptyFields','true','true/false whether or not to show empty fields on the \'View Encounter\' window',25,'b54ca83a-2695-102d-b4c2-001d929acb54'),('dashboard.encounters.showViewLink','true','true/false whether or not to show the \'View Encounter\' link on the patient dashboard',26,'b54ca902-2695-102d-b4c2-001d929acb54'),('dashboard.encounters.usePages','smart','true/false/smart on how to show the pages on the \'View Encounter\' window.  \'smart\' means that if > 50% of the fields have page numbers defined, show data in pages',27,'b54ca9d4-2695-102d-b4c2-001d929acb54'),('dashboard.encounters.viewWhere','newWindow','Defines how the \'View Encounter\' link should act. Known values: \'sameWindow\', \'newWindow\', \'oneNewWindow\'',28,'b54caa9c-2695-102d-b4c2-001d929acb54'),('dashboard.overview.showConcepts','5096,6364,6367','Comma delimited list of concepts ids to show on the patient dashboard overview tab',29,'b54cab64-2695-102d-b4c2-001d929acb54'),('dashboard.regimen.displayDrugSetIds','ANTIRETROVIRAL DRUGS,TUBERCULOSIS TREATMENT DRUGS','Drug sets that appear on the Patient Dashboard Regimen tab. Comma separated list of name of concepts that are defined as drug sets.',30,'b54cac2c-2695-102d-b4c2-001d929acb54'),('dashboard.regimen.standardRegimens','<list>  <regimenSuggestion>    <drugComponents>      <drugSuggestion>        <drugId>2</drugId>        <dose>1</dose>        <units>tab(s)</units>        <frequency>2/day x 7 days/week</frequency>        <instructions></instructions>      </drugSuggestion>    </drugComponents>    <displayName>3TC + d4T(30) + NVP (Triomune-30)</displayName>    <codeName>standardTri30</codeName>    <canReplace>ANTIRETROVIRAL DRUGS</canReplace>  </regimenSuggestion>  <regimenSuggestion>    <drugComponents>      <drugSuggestion>        <drugId>3</drugId>        <dose>1</dose>        <units>tab(s)</units>        <frequency>2/day x 7 days/week</frequency>        <instructions></instructions>      </drugSuggestion>    </drugComponents>    <displayName>3TC + d4T(40) + NVP (Triomune-40)</displayName>    <codeName>standardTri40</codeName>    <canReplace>ANTIRETROVIRAL DRUGS</canReplace>  </regimenSuggestion>  <regimenSuggestion>    <drugComponents>      <drugSuggestion>        <drugId>39</drugId>        <dose>1</dose>        <units>tab(s)</units>        <frequency>2/day x 7 days/week</frequency>        <instructions></instructions>      </drugSuggestion>      <drugSuggestion>        <drugId>22</drugId>        <dose>200</dose>        <units>mg</units>        <frequency>2/day x 7 days/week</frequency>        <instructions></instructions>      </drugSuggestion>    </drugComponents>    <displayName>AZT + 3TC + NVP</displayName>    <codeName>standardAztNvp</codeName>    <canReplace>ANTIRETROVIRAL DRUGS</canReplace>  </regimenSuggestion>  <regimenSuggestion>    <drugComponents>      <drugSuggestion reference=\"../../../regimenSuggestion[3]/drugComponents/drugSuggestion\"/>      <drugSuggestion>        <drugId>11</drugId>        <dose>600</dose>        <units>mg</units>        <frequency>1/day x 7 days/week</frequency>        <instructions></instructions>      </drugSuggestion>    </drugComponents>    <displayName>AZT + 3TC + EFV(600)</displayName>    <codeName>standardAztEfv</codeName>    <canReplace>ANTIRETROVIRAL DRUGS</canReplace>  </regimenSuggestion>  <regimenSuggestion>    <drugComponents>      <drugSuggestion>        <drugId>5</drugId>        <dose>30</dose>        <units>mg</units>        <frequency>2/day x 7 days/week</frequency>        <instructions></instructions>      </drugSuggestion>      <drugSuggestion>        <drugId>42</drugId>        <dose>150</dose>        		<units>mg</units>        <frequency>2/day x 7 days/week</frequency>        <instructions></instructions>      </drugSuggestion>      <drugSuggestion reference=\"../../../regimenSuggestion[4]/drugComponents/drugSuggestion[2]\"/>    </drugComponents>    <displayName>d4T(30) + 3TC + EFV(600)</displayName>    <codeName>standardD4t30Efv</codeName>    <canReplace>ANTIRETROVIRAL DRUGS</canReplace>  </regimenSuggestion>  <regimenSuggestion>    <drugComponents>      <drugSuggestion>        <drugId>6</drugId>        <dose>40</dose>        <units>mg</units>        <frequency>2/day x 7 days/week</frequency>        <instructions></instructions>      </drugSuggestion>      <drugSuggestion reference=\"../../../regimenSuggestion[5]/drugComponents/drugSuggestion[2]\"/>      <drugSuggestion reference=\"../../../regimenSuggestion[4]/drugComponents/drugSuggestion[2]\"/>    </drugComponents>    <displayName>d4T(40) + 3TC + EFV(600)</displayName>    <codeName>standardD4t40Efv</codeName>    <canReplace>ANTIRETROVIRAL DRUGS</canReplace>  </regimenSuggestion></list>','XML description of standard drug regimens, to be shown as shortcuts on the dashboard regimen entry tab',31,'b54cad08-2695-102d-b4c2-001d929acb54'),('dashboard.relationships.show_types','','Types of relationships separated by commas.  Doctor/Patient,Parent/Child',32,'b54cb000-2695-102d-b4c2-001d929acb54'),('encounterForm.obsSortOrder','number','The sort order for the obs listed on the encounter edit form.  \'number\' sorts on the associated numbering from the form schema.  \'weight\' sorts on the order displayed in the form schema.',34,'b54cb0d2-2695-102d-b4c2-001d929acb54'),('form2program.database_version','1.0.0','DO NOT MODIFY.  Current database version number for the form2program module.',35,'b54cb1a4-2695-102d-b4c2-001d929acb54'),('form2program.started','true','DO NOT MODIFY. true/false whether or not the form2program module has been started.  This is used to make sure modules that were running  prior to a restart are started again',36,'b54cb276-2695-102d-b4c2-001d929acb54'),('formdataexport.database_version','1.8','DO NOT MODIFY.  Current database version number for the formdataexport module.',37,'b54cb352-2695-102d-b4c2-001d929acb54'),('formdataexport.started','true','DO NOT MODIFY. true/false whether or not the formdataexport module has been started.  This is used to make sure modules that were running  prior to a restart are started again',38,'b54cb424-2695-102d-b4c2-001d929acb54'),('formentry.database_version','2.6','DO NOT MODIFY.  Current database version number for the formentry module.',39,'b54cb4f6-2695-102d-b4c2-001d929acb54'),('formentry.infopath_server_url','http://neno.apzunet:8080/openmrs','When uploading an XSN, this url is used as the \"base path\".  (Should be something like http://localhost:8080/openmrs)',41,'b54cb5be-2695-102d-b4c2-001d929acb54'),('formentry.infopath_taskpane_caption','Welcome!','The text seen in the infopath taskpane upon first logging in',42,'b54cb690-2695-102d-b4c2-001d929acb54'),('formentry.infopath_taskpane_keepalive_min','','The number of minutes to keep refreshing the taskpane before allowing \r\nthe login to lapse',43,'b54cb758-2695-102d-b4c2-001d929acb54'),('formentry.infopath_taskpane_refresh_sec','','The number of seconds between taskpane refreshes.  This keeps the taskpane from\r\nlogging people out on longer forms',44,'b54cba00-2695-102d-b4c2-001d929acb54'),('formentry.patientForms.goBackOnEntry','false','\'true\' means have the browser go back to the find patient page after picking a form\r\nfrom the patientForms tab on the patient dashboard page',45,'b54cbad2-2695-102d-b4c2-001d929acb54'),('formentry.queue_archive_dir','formentry/archive/%Y/%M','Directory containing the formentry archive items.  This will contain xml files that have\r\nbeen submitted by infopath and then processed sucessfully into hl7.\r\nCertain date parameters will be replaced with the current date:\r\n%Y = four digit year\r\n%M = two digit month\r\n%D = two digit date of the month\r\n%w = week of the year\r\n     %W = week of the month',46,'b54cbb9a-2695-102d-b4c2-001d929acb54'),('formentry.queue_dir','/home/tomcat5/.OpenMRS/formentry/queue','Directory containing the formentry queue items. This will contain xml files submitted by\r\ninfopath.  These items are awaiting processing to be turned into hl7 queue items',47,'b54cbc80-2695-102d-b4c2-001d929acb54'),('formentry.started','true','DO NOT MODIFY. true/false whether or not the formentry module has been started.  This is used to make sure modules that were running  prior to a restart are started again',48,'b54cbf28-2695-102d-b4c2-001d929acb54'),('formimportexport.parentConceptServer.batchSize','50','',49,'b54cbff0-2695-102d-b4c2-001d929acb54'),('formimportexport.parentConceptServer.password','','Password to use when logging in to the parent concept server. Could be blank if the parent allows unauthenticated users to browse the concept dictionary.',50,'b54cc34c-2695-102d-b4c2-001d929acb54'),('formimportexport.parentConceptServer.url','http://196.216.13.206:8180/openmrs','',51,'b54cc414-2695-102d-b4c2-001d929acb54'),('formimportexport.parentConceptServer.username','','Username to use when logging in to the parent concept server. Could be blank if the parent allows unauthenticated users to browse the concept dictionary.',52,'b54cc4dc-2695-102d-b4c2-001d929acb54'),('formimportexport.started','true','DO NOT MODIFY. true/false whether or not the formimportexport module has been started.  This is used to make sure modules that were running  prior to a restart are started again',53,'b54cc784-2695-102d-b4c2-001d929acb54'),('gzip.enabled','false','Set to \'true\' to turn on OpenMRS\'s gzip filter, and have the webapp compress data before sending it to any client that supports it. Generally use this if you are running Tomcat standalone. If you are running Tomcat behind Apache, then you\'d want to use Apache to do gzip compression.',54,'b54cc856-2695-102d-b4c2-001d929acb54'),('last_error_reported','2009-11-27T23:51:02+02:00','',55,'b54ccafe-2695-102d-b4c2-001d929acb54'),('layout.address.format','malawi','Format in which to display the person addresses.  Valid values are general, kenya, rwanda, usa, and lesotho',56,'b54ccbd0-2695-102d-b4c2-001d929acb54'),('layout.name.format','short','Format in which to display the person names.  Valid values are short, long',57,'b54ccc98-2695-102d-b4c2-001d929acb54'),('log.level.openmrs','info','log level used by the logger \'org.openmrs\'. This value will override the log4j.xml value. Valid values are trace, debug, info, warn, error or fatal',58,'b54ccd60-2695-102d-b4c2-001d929acb54'),('mail.debug','true','true/false whether to print debugging information during mailing',59,'b54cd012-2695-102d-b4c2-001d929acb54'),('mail.default_content_type','text/plain','Content type to append to the mail messages',60,'b54cd152-2695-102d-b4c2-001d929acb54'),('mail.from','info@openmrs.org','Email address to use as the default from address',61,'b54cd27e-2695-102d-b4c2-001d929acb54'),('mail.password','','Password for the SMTP user (if smtp_auth is enabled)',62,'b54cd59e-2695-102d-b4c2-001d929acb54'),('mail.smtp_auth','true','true/false whether the smtp host requires authentication',63,'b54cd6ca-2695-102d-b4c2-001d929acb54'),('mail.smtp_host','209.85.133.111','SMTP host name',64,'b54cd9ea-2695-102d-b4c2-001d929acb54'),('mail.smtp_port','465','SMTP port',65,'b54cdb16-2695-102d-b4c2-001d929acb54'),('mail.transport_protocol','smtp','Transport protocol for the messaging engine. Valid values: smtp',66,'b54cde36-2695-102d-b4c2-001d929acb54'),('mail.user','evan.waters','Username of the SMTP user (if smtp_auth is enabled)',67,'b54ce14c-2695-102d-b4c2-001d929acb54'),('module_repository_folder','modules','Name of the folder in which to store the modules',68,'b54ce476-2695-102d-b4c2-001d929acb54'),('new_patient_form.showRelationships','false','true/false whether or not to show the relationship editor on the addPatient.htm screen',69,'b54cebc4-2695-102d-b4c2-001d929acb54'),('patient.defaultPatientIdentifierValidator','org.openmrs.patient.impl.LuhnIdentifierValidator','This property sets the default patient identifier validator.  The default validator is only used in a handful of (mostly legacy) instances.  For example, it\'s used to generate the isValidCheckDigit calculated column and to append the string \"(default)\" to the name of the default validator on the editPatientIdentifierType form.',70,'b54ced2c-2695-102d-b4c2-001d929acb54'),('patient.displayAttributeTypes','Birthplace','',71,'b54cee94-2695-102d-b4c2-001d929acb54'),('patient.identifierPrefix','','This property is only used if patient.identifierRegex is empty.  The string here is prepended to the sql indentifier search string.  The sql becomes \"... where identifier like \'<PREFIX><QUERY STRING><SUFFIX>\';\".  Typically this value is either a percent sign (%) or empty.',72,'b54cefde-2695-102d-b4c2-001d929acb54'),('patient.identifierRegex','^0*@SEARCH@([A-Z]+-[0-9])?$','A MySQL regular expression for the patient identifier search strings.  The @SEARCH@ string is replaced at runtime with the user\'s search string.  An empty regex will cause a simply \'like\' sql search to be used',73,'b54cf18c-2695-102d-b4c2-001d929acb54'),('patient.identifierSuffix','%','This property is only used if patient.identifierRegex is empty.  The string here is prepended to the sql indentifier search string.  The sql becomes \"... where identifier like \'<PREFIX><QUERY STRING><SUFFIX>\';\".  Typically this value is either a percent sign (%) or empty.',74,'b54cf2e0-2695-102d-b4c2-001d929acb54'),('patient.listingAttributeTypes','Health Center','',75,'78edc559-254f-4a25-a6d3-6a9c21e5a6a8'),('patient.searchMaxResults','1000','The maximum number of results returned by patient searches',76,'b54cf57e-2695-102d-b4c2-001d929acb54'),('patient.viewingAttributeTypes','Health Center','',77,'ad400343-abe7-4253-a696-f68b3fc2abac'),('patientmatching.started','true','DO NOT MODIFY. true/false whether or not the patientmatching module has been started.  This is used to make sure modules that were running  prior to a restart are started again',78,'b54cf704-2695-102d-b4c2-001d929acb54'),('patientsummary.adultconceptIdsToGraph','5090,5089,5497','Ordered, comma separated list of concept ids to graph in patient summary for patients > 5 years old\r\nDefault: height (5090), weight (5089), cd4 (5497).',79,'b54cf7d6-2695-102d-b4c2-001d929acb54'),('patientsummary.adultconceptIdsToWatch','12,5497','Comma delimited list of concept ids to trigger alerts for patients > 5 years old\r\nAlerts trigger when concepts are empty or have not been updated in six months.\r\nDefaults: x-ray chest (12), cd4 (5497).',80,'b54cf8a8-2695-102d-b4c2-001d929acb54'),('patientsummary.adverseEffectConceptId','1297','Adverse effect concept id. Default: 1297.',81,'b54cf970-2695-102d-b4c2-001d929acb54'),('patientsummary.arvDrugsConceptId','1085','ARV Drugs concept id. Default: 1085.',82,'b54cfc40-2695-102d-b4c2-001d929acb54'),('patientsummary.childconceptIdsToGraph','5090,5089,5497','Ordered, comma separated list of concept ids to graph in patient summary. \r\nDefault: height (5090), weight (5089), cd4 (5497).',83,'b54cfd12-2695-102d-b4c2-001d929acb54'),('patientsummary.childconceptIdsToWatch','12,730,5497,5089,5090','Comma delimited list of concept ids to trigger alerts.\r\nAlerts trigger when concepts are empty or have not been updated in one month.\r\nDefaults: x-ray chest (12), cd4 (5497), cd4% (730), weight (5089), height (5090)',84,'b54cfdda-2695-102d-b4c2-001d929acb54'),('patientsummary.hivTestResultConceptId','2169','HIV Test concept id. Default: 2169.',85,'b54cfea2-2695-102d-b4c2-001d929acb54'),('patientsummary.labTestsConceptId','1337','Laboratory examinations construct concept id. Default: 1337.',86,'b54cff6a-2695-102d-b4c2-001d929acb54'),('patientsummary.previousDiagnosisConceptId','992','Problem list construct concept id. Default: 992.',87,'b54d0032-2695-102d-b4c2-001d929acb54'),('patientsummary.started','true','DO NOT MODIFY. true/false whether or not the patientsummary module has been started.  This is used to make sure modules that were running  prior to a restart are started again',88,'b54d00f0-2695-102d-b4c2-001d929acb54'),('patientsummary.symptomPresentConceptId','1293','Review of symptoms on presentation concept id. Default: 1293.',89,'b54d01b8-2695-102d-b4c2-001d929acb54'),('patientsummary.vitalSigns','5089,5090','Comma delimited list of concept ids for vital signs\r\nDefaults: weight (5089), height (5090)',90,'b54d0280-2695-102d-b4c2-001d929acb54'),('patient_identifier.importantTypes','ARV Number,National id,PART Number,District TB Number,EID Number,KS Number,VHW ID','',91,'b54d033e-2695-102d-b4c2-001d929acb54'),('pihmalawihacks.started','true','DO NOT MODIFY. true/false whether or not the pihmalawihacks module has been started.  This is used to make sure modules that were running  prior to a restart are started again',92,'b54d0406-2695-102d-b4c2-001d929acb54'),('report.xmlMacros','macroPrefix=#\r\nmacroSuffix=#\r\n\r\nadultAtStart=[AgeOnDate|minAge=15|maxAge=|effectiveDate=${report.startDate}]\r\nadultAtEnd=[AgeOnDate|minAge=15|maxAge=|effectiveDate=${report.endDate}]\r\n\r\nchildAtStart=[AgeOnDate|minAge=0|maxAge=14|effectiveDate=${report.startDate}]\r\nchildAtEnd=[AgeOnDate|minAge=0|maxAge=14|effectiveDate=${report.endDate}]\r\n\r\naliveAtStart=[Alive|effectiveDate=${report.startDate}]\r\naliveAtEnd=[Alive|effectiveDate=${report.endDate]\r\n\r\nmaleAdult=#adultAtStart# AND [Male]\r\nmaleChild=#childAtStart# AND [Male]\r\n\r\nfemaleAdult=#adultAtStart# AND [Female]\r\nfemaleChild=#childAtStart# AND [Female]\r\n\r\n//Encounter Macros\r\n\r\nhadArtInitial=[ART_INITIAL|sinceDate=${report.startDate}|untilDate=${report.endDate}]\r\nhadArtFollowup=[ART_FOLLOWUP|sinceDate=${report.startDate}|untilDate=${report.endDate}]\r\n\r\nhadArtEncounter=#hadArtInitial# OR #hadArtFollowup#\r\n\r\nartRegLastWeek=[REGISTRATION|location=9|withinLastDays=7]\r\nartRegTwoWeeks=[REGISTRATION|location=9|withinLastDays=14]\r\nartRegWeekAgo=#artRegTwoWeeks# NOT #artRegLastWeek#\r\n\r\nartAptLastWeek=[APPOINTMENT|location=9|withinLastDays=7]\r\nartAptTwoWeeks=[APPOINTMENT|location=9|withinLastDays=14]\r\nartAptWeekAgo=#artAptTwoWeeks# NOT #artAptLastWeek#\r\n\r\nartScanWeekAgo = #artRegWeekAgo# OR #artAptWeekAgo#\r\nanyHIV = [Patients in HIV Program] OR [EID Program] OR [KS Program]\r\n\r\nartVisitNotEnrolled = #artScanWeekAgo# NOT #anyHIV#\r\n\r\n//Status Macros\r\ntransferredIn=[Transfer_In|sinceDate=${report.startDate}|untilDate=${report.endDate}]\r\ntransfInArt=#transferredIn#\r\n\r\nnewArt=#hadArtInitial# OR #transfInArt#\r\n\r\n//Drug Regimen Macros\r\n\r\n//First Line Sets\r\nonT30=[Drug|drugList=2|sinceDate=${report.startDate}|untilDate=${report.endDate}]\r\neverOnT30=[Drug|drugList=2|sinceDate=${report.startDate}|untilDate=${report.endDate}]\r\nonT40=[Drug|drugList=3|sinceDate=${report.startDate}|untilDate=${report.endDate}]\r\nonLS30=[currDrug|drugList=70|]\r\nonLamBaby=[Drug|drugList=71|sinceDate=${report.startDate}|untilDate=${report.endDate}]\r\nonTriBaby=[Drug|drugList=72|sinceDate=${report.startDate}|untilDate=${report.endDate}]\r\n\r\n//Second Line Sets\r\nonEFV=[Drug|drugList=11|drugList=28|drugList=29|drugList=30|sinceDate=${report.startDate}|untilDate=${report.endDate}]\r\n\r\n//Program State Sets\r\nhivDeadLowerLimit=[progStateOnOrBefore|program=1|stateList=3|untilDate=${report.startDate-1}]\r\nhivDeadOnOrAfter=[progStateOnOrAfter|program=1|stateList=3|sinceDate=${report.startDate}]\r\nhivDeadUpperLimit=[progStateOnOrAfter|program=1|stateList=3|sinceDate=${report.endDate+1}]\r\nhivDeadRange=#hivDeadOnOrAfter# NOT (#hivDeadLowerLimit# OR #hivDeadUpperLimit#)','',93,'b54d04ce-2695-102d-b4c2-001d929acb54'),('scheduler.password','pa55ionFruit','Password for the OpenMRS user that will perform the scheduler activities',94,'b54d0640-2695-102d-b4c2-001d929acb54'),('scheduler.username','admin','Username for the OpenMRS user that will perform the scheduler activities',95,'b54d0708-2695-102d-b4c2-001d929acb54'),('smtp_server','localhost','',96,'b54d07c6-2695-102d-b4c2-001d929acb54'),('user.listingAttributeTypes','','',97,'23dbfc81-f578-4ab2-8331-1dc8ce839fc3'),('user.viewingAttributeTypes','','',98,'b1b13950-e89b-4218-afb1-5bd54540391c'),('use_patient_attribute.healthCenter','false','Indicates whether or not the \'health center\' attribute is shown when viewing/searching for patients',99,'b54d09ec-2695-102d-b4c2-001d929acb54'),('use_patient_attribute.mothersName','false','Indicates whether or not mother\'s name is able to be added/viewed for a patient',100,'b54d0ab4-2695-102d-b4c2-001d929acb54'),('use_patient_attribute.tribe','true','Indicates whether or not the \'tribe\' attribute is shown when viewing/searching for patients',101,'b54d0b7c-2695-102d-b4c2-001d929acb54'),('smtp_username','baobabhealth','',102,'b54d0cb2-2695-102d-b4c2-001d929acb54'),('mdrtb.database_version','1.0.3','DO NOT MODIFY.  Current database version number for the mdrtb module.',103,'b54d0d84-2695-102d-b4c2-001d929acb54'),('mdrtb.started','false','DO NOT MODIFY. true/false whether or not the mdrtb module has been started.  This is used to make sure modules that were running  prior to a restart are started again',104,'b54d0e4c-2695-102d-b4c2-001d929acb54'),('mdrtb.program_name','MDR-TB PROGRAM','MDR-TB program name.',105,'b54d1112-2695-102d-b4c2-001d929acb54'),('mdrtb.treatment_supporter_person_attribute_type','Treatment Supporter','The person attribute type that corresponds to being a treatment supporter/acompanateur/dots worker.',106,'b54d11e4-2695-102d-b4c2-001d929acb54'),('mdrtb.patient_identifier_type_list','','Pipe delimited list of all patient identifier types associated with the MDRTB program.',107,'b54d12b6-2695-102d-b4c2-001d929acb54'),('mdrtb.location_list','','Pipe delimited list of all locations that you want to choose from in the add patient dialogs in the mdrtb module.  This will generally correspond to the health centers that are participating in an mdrtb program.  If blank, all openMRS locations will be displayed.',108,'b54d1388-2695-102d-b4c2-001d929acb54'),('mdrtb.lab_list','Unknown Location','Pipe delimited list of all labs that will be performing any tests associated with MDRTB.  These are expected to be locations in openMRS.',109,'b54d1464-2695-102d-b4c2-001d929acb54'),('mdrtb.culture_method_concept','TUBERCULOSIS CULTURE METHOD','The Concept question for which the answers are all possible culture methods.  This must be a ConceptSet.',110,'b54d1540-2695-102d-b4c2-001d929acb54'),('mdrtb.DST_methods','TUBERCULOSIS DRUG SENSITIVITY TEST METHOD','The ConceptSet who\'s answers are all possible DST laboratory test methods.',111,'b54d1612-2695-102d-b4c2-001d929acb54'),('mdrtb.smear_method_concept','TUBERCULOSIS SMEAR MICROSCOPY METHOD','The Concept question for which the answers are all possible smear laboratory test methods.',112,'b54d16ee-2695-102d-b4c2-001d929acb54'),('mdrtb.anatomical_locations_concept','TUBERCULOSIS SAMPLE SOURCE','The Concept question for which the answers are all possible anatomical locations from which an MDR-TB related lab sample can be taken.\r\nProbably \'sputum\'.  This must be a ConceptSet.',113,'b54d19c8-2695-102d-b4c2-001d929acb54'),('mdrtb.DST_drug_list','DST TEST COMPONENTS','The ConceptSet containing all of the ordered drug concepts that are used as a row in a DST test, OR a list of concepts delimited by |.',114,'b54d1ac2-2695-102d-b4c2-001d929acb54'),('mdrtb.DST_result_list','TUBERCULOSIS DST RESULT','ConceptSet containing all possible DST results concepts (in a DST result, the result concept gets the result, the valueCoded concept is the drug).  Can also be a list of concepts by name, delimited by |.',115,'b54d1b9e-2695-102d-b4c2-001d929acb54'),('mdrtb.culture_result_list','TUBERCULOSIS CULTURE RESULT','Concept with possible valueCoded answers that are all possible culture results.  Can also be a list of concepts by name, delimited by |.',116,'b54d1c70-2695-102d-b4c2-001d929acb54'),('mdrtb.smear_result_list','TUBERCULOSIS SMEAR RESULT','Concept with possible valueCoded answers that are all possible smear results.  Can also be a list of concepts by name, delimited by |.',117,'b54d1d38-2695-102d-b4c2-001d929acb54'),('mdrtb.test_result_encounter_type_DST','DST Result','This should be the name of the encounter type that you want to use for encounters wrapping DST results.',118,'b54d1e0a-2695-102d-b4c2-001d929acb54'),('mdrtb.test_result_encounter_type_bacteriology','Bacteriology Result','This should be the name of the encounter type that you want to use for encounters wrapping bacteriology (smear+culture) results.',119,'b54d1f7c-2695-102d-b4c2-001d929acb54'),('mdrtb.mdrtb_forms_list','','List all MDR-TB forms by name, pipe delimited.  These will appear in the form list on the MDR-TB home.',120,'b54d204e-2695-102d-b4c2-001d929acb54'),('mdrtb.mdrtb_default_provider','provider','This will be used to mark the default provider in MDR-TB related encounters, if none is already provided.',121,'b54d2120-2695-102d-b4c2-001d929acb54'),('mdrtb.birt_report_list','','List all BIRT reports by name that correspond to the MDR-TB program.  Pipe delimited.',122,'b54d21f2-2695-102d-b4c2-001d929acb54'),('mdrtb.mdrtb_drugs','TUBERCULOSIS DRUGS','Name of the ConceptSet that contains all Tuberculosis Drugs',123,'b54d22c4-2695-102d-b4c2-001d929acb54'),('mdrtb.first_line_drugs','FIRST-LINE TUBERCULOSIS DRUGS','Name of the ConceptSet that contains all first line Tuberculosis Treatment Drugs',124,'b54d23a0-2695-102d-b4c2-001d929acb54'),('mdrtb.injectible_drugs','INJECTIBLE TUBERCULOSIS DRUGS','Name of the ConceptSet that contains all injectible Tuberculosis Treatement Drugs',125,'b54d2468-2695-102d-b4c2-001d929acb54'),('mdrtb.quinolones','TUBERCULOSIS QUINOLONES','Name of the ConceptSet that contains all quinolones Tuberculosis Treatement Drugs',126,'b54d2544-2695-102d-b4c2-001d929acb54'),('mdrtb.other_second_line','OTHER SECOND-LINE TUBERCULOSIS DRUGS','Name of the ConceptSet that contains all other second-line Tuberculosis Treatement Drugs',127,'b54d260c-2695-102d-b4c2-001d929acb54'),('mdrtb.discontinue_drug_order_reasons','REASON TUBERCULOSIS TREATMENT CHANGED OR STOPPED','Name of the ConceptSet that contains all of the value-coded concepts representing reasons why\r\nyou would want to discontinue a TB drug order.',128,'b54d26e8-2695-102d-b4c2-001d929acb54'),('mdrtb.max_num_bacteriologies_or_dsts_to_add_at_once','4','Expects an integer value.  Represents the maximum number of smears, cultures, or DSTs that you would ever want to add at one time \r\nfor a given sputum sample.',129,'b54d27c4-2695-102d-b4c2-001d929acb54'),('mdrtb.organism_type','TYPE OF ORGANISM','A concept set of possible TB culture organism types, or a | delimited list of organism concepts',130,'b54d28a0-2695-102d-b4c2-001d929acb54'),('mdrtb.webserver_port',':8080','This is meant to give you a little bit of flexibility with hosting configurations.  For tomcat, the listener port is :8080 by default.',131,'b54d2968-2695-102d-b4c2-001d929acb54'),('mdrtb.positive_culture_concepts','WEAKLY POSITIVE|STRONGLY POSITIVE|MODERATELY POSITIVE|SCANTY','These are the concepts that signify a positive bacteriology result.  Pipe delimited.',132,'b54d2a44-2695-102d-b4c2-001d929acb54'),('mdrtb.ART_identifier_type','ARV Number','Set this to the patient identifier type for the ART program',133,'b54d2b16-2695-102d-b4c2-001d929acb54'),('mdrtb.treatment_supporter_relationship_type','Treatment Supporter/Treatment Supportee','The relationship type used to describe the relationship from a treatment supporter (A) to a patient (B)',134,'b54d2be8-2695-102d-b4c2-001d929acb54'),('mdrtb.patient_contact_id_attribute_type','MDR-TB Patient Contact ID Number','The person attribute type corresponding to a patient contact\'s ID number.',135,'b54d2cba-2695-102d-b4c2-001d929acb54'),('mdrtb.dst_color_coding_red','RESISTANT TO TUBERCULOSIS DRUG','The DST result value that will be coded with the color red (Resistant).',136,'b54d2d8c-2695-102d-b4c2-001d929acb54'),('mdrtb.dst_color_coding_green','SUSCEPTIBLE TO TUBERCULOSIS DRUG','The DST result value that will be coded with the color green (Susceptible).',137,'b54d2e5e-2695-102d-b4c2-001d929acb54'),('mdrtb.dst_color_coding_yellow','INTERMEDIATE TO TUBERCULOSIS DRUG','The DST result value that will be coded with the color yellow (Intermediate).',138,'b54d2f30-2695-102d-b4c2-001d929acb54'),('mdrtb.in_mdrtb_program_cohort_definition_id','9','The ID of the saved cohort definition for all patients in the mdr-tb program.  This is used by the forecasting requirements links on the homepage.',139,'b54d3002-2695-102d-b4c2-001d929acb54'),('smtp_password','b40b4bhealth','',140,'b54d3386-2695-102d-b4c2-001d929acb54'),('clinic_hours','7:30am-3:45pm','',141,'b54d344e-2695-102d-b4c2-001d929acb54'),('clinic_breaks','12:30pm-1:00pm,1:00pm-1:15pm','',142,'b54d350c-2695-102d-b4c2-001d929acb54'),('current_health_center_id','37','',143,'b54d35d4-2695-102d-b4c2-001d929acb54'),('dataimport.started','true','DO NOT MODIFY. true/false whether or not the dataimport module has been started.  This is used to make sure modules that were running  prior to a restart are started again',144,'b54d38a4-2695-102d-b4c2-001d929acb54'),('dataimport.dataImportDir','','Specifies the absolute path where data import files are uploaded.  (ex. /home/user/dataImports).',145,'b54d398a-2695-102d-b4c2-001d929acb54'),('locale.allowed.list','en','Comma delimited list of locales allowed for use on system',146,'b54d3a5c-2695-102d-b4c2-001d929acb54'),('newPatientForm.relationships','','Comma separated list of the RelationshipTypes to show on the new/short patient form.  The list is defined like \'3a, 4b, 7a\'.  The number is the RelationshipTypeId and the \'a\' vs \'b\' part is which side of the relationship is filled in by the user.',147,'b54d3b2e-2695-102d-b4c2-001d929acb54'),('formentry.infopath_taskpane.showAllUsersOnLoad','true','When you view the \'users.htm\' page in the taskpane, i.e. by clicking on the Choose a Provider\r\nbutton, should the system automatically preload a list of all users?',148,'b54d3c0a-2695-102d-b4c2-001d929acb54'),('dashboard.header.programs_to_show','','List of programs to show Enrollment details of in the patient header. (Should be an ordered comma-separated list of program_ids or names.)',149,'b54d3cdc-2695-102d-b4c2-001d929acb54'),('dashboard.header.workflows_to_show','','List of programs to show Enrollment details of in the patient header. List of workflows to show current status of in the patient header. These will only be displayed if they belong to a program listed above. (Should be a comma-separated list of program_workflow_ids.)',150,'b54d3db8-2695-102d-b4c2-001d929acb54'),('concept.problemList','1284','The concept id of the PROBLEM LIST concept.  This concept_id is presumed to be the generic grouping (obr) concept in hl7 messages.  An obs_group row is not created for this concept.',151,'b54d3e8a-2695-102d-b4c2-001d929acb54'),('mail.smtp_quitwait','false','',152,'b54d3f5c-2695-102d-b4c2-001d929acb54'),('mail.smtp_socketFactory_fallback','false','',153,'b54d401a-2695-102d-b4c2-001d929acb54'),('mail.smtp_socketFactory_class','javax.net.ssl.SSLSocketFactory','',154,'b54d40e2-2695-102d-b4c2-001d929acb54'),('mail.smtp_socketFactory_port','465','',155,'b54d41aa-2695-102d-b4c2-001d929acb54'),('mail.smtp_starttls_enable','true','',156,'b54d4272-2695-102d-b4c2-001d929acb54'),('simplelabentry.started','true','DO NOT MODIFY. true/false whether or not the simplelabentry module has been started.  This is used to make sure modules that were running  prior to a restart are started again',157,'b54d433a-2695-102d-b4c2-001d929acb54'),('simplelabentry.supportedTests','657,1019','',158,'b54d4402-2695-102d-b4c2-001d929acb54'),('simplelabentry.labOrderType','4','',159,'b54d44ca-2695-102d-b4c2-001d929acb54'),('simplelabentry.labTestEncounterType','13','',160,'b54d4588-2695-102d-b4c2-001d929acb54'),('simplelabentry.patientIdentifierType','3','',161,'b54d4650-2695-102d-b4c2-001d929acb54'),('simplelabentry.patientHealthCenterAttributeType','7','',162,'b54d470e-2695-102d-b4c2-001d929acb54'),('simplelabentry.programToDisplay','1','',163,'b54d47d6-2695-102d-b4c2-001d929acb54'),('simplelabentry.workflowToDisplay','1','',164,'b54d4894-2695-102d-b4c2-001d929acb54'),('demographics.home_village','yes','',165,'b54d4952-2695-102d-b4c2-001d929acb54'),('demographics.mothers_surname','yes','',166,'b54d4a1a-2695-102d-b4c2-001d929acb54'),('htmlformentry.database_version','1.0.0','DO NOT MODIFY.  Current database version number for the htmlformentry module.',167,'b54d4ae2-2695-102d-b4c2-001d929acb54'),('htmlformentry.started','true','DO NOT MODIFY. true/false whether or not the htmlformentry module has been started.  This is used to make sure modules that were running  prior to a restart are started again',168,'b54d4bb4-2695-102d-b4c2-001d929acb54'),('dashboard.identifiers','{\"9\":[\"PART Number\",\"ARV Number\",\"EID Number\",\"KS Number\"]}','',169,'b54d4f60-2695-102d-b4c2-001d929acb54'),('formentry.infopath_archive_dir','','This property should point to a filesystem directory. If undefined (empty), XSNs will not be archived.\r\nIf the directory is defined and available, every time an XSN is uploaded the old XSN\r\nwill be renamed and copied to this directory.',170,'b54d5032-2695-102d-b4c2-001d929acb54'),('remoteformentry.database_version','1.0.0','DO NOT MODIFY.  Current database version number for the remoteformentry module.',171,'b54d510e-2695-102d-b4c2-001d929acb54'),('remoteformentry.started','true','DO NOT MODIFY. true/false whether or not the remoteformentry module has been started.  This is used to make sure modules that were running  prior to a restart are started again',172,'b54d51e0-2695-102d-b4c2-001d929acb54'),('remoteformentry.generated_return_data_dir','remoteformentry/generatedReturnData','Directory where the generated return data will be stored',173,'b54d52b2-2695-102d-b4c2-001d929acb54'),('remoteformentry.pending_queue_dir','remoteformentry/pendingQueue','Directory where the pending queue items will be stored',174,'b54d5384-2695-102d-b4c2-001d929acb54'),('remoteformentry.ack_dir','remoteformentry/ackDir','Directory where the acks to be returned to remote sites are stored',175,'b54d5668-2695-102d-b4c2-001d929acb54'),('remoteformentry.remote_locations','3','List of remote sites. It is a comma separated list of space separated groups. \r\ne.g.: \"1,2,10,23\" or \"1 3 10, 4 5 7, 18, 21\".  (In the latter, locations 3 and \r\n10 are sublocations of 1 and all encounters/obs are sent to that same location)',176,'b54d5744-2695-102d-b4c2-001d929acb54'),('remoteformentry.invalid_identifier_type','','A PatientIdentifier.patientIdentifierTypeId of the type that is used to mark \r\nidentifiers with invalid check digits.  If this is non-empty and an patient\'s \r\nidentifier comes in that is invalid, the type of that identifier will be changed to\r\nthis type.  If this is empty and an invalid identifier comes in, the patient will\r\nnot be able to be saved to the database and will end up in the error queue.',177,'b54d5820-2695-102d-b4c2-001d929acb54'),('remoteformentry.generated_return_data_tables_to_ignore','obs, encounter, complex_obs, hl7_in_archive, hl7_in_queue, hl7_in_error, orders, order_type, drug_order, formentry_archive, formentry_error','This gp will contain a comma separated list of tables to ignore when creating the large sql file.\r\nTables like obs and encounter are ignored because they are generated in other files.  Other large \r\ntables that remote sites don\'t care about should be in here as well.',178,'b54d5910-2695-102d-b4c2-001d929acb54'),('remoteformentry.initialEncounterTypes','11,9,20,14,','',181,'b54d5a00-2695-102d-b4c2-001d929acb54'),('patientsummary.mandatory','false','true/false whether or not the patientsummary module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',182,'f27a4899-56f7-412d-95d5-fddb46a462c2'),('FormEntry.enableDashboardTab','true','true/false whether or not to show a Form Entry tab on the patient dashboard',183,'4d7bbc56-0bd9-4803-9835-43fa8c6f0713'),('FormEntry.enableOnEncounterTab','false','true/false whether or not to show a Enter Form button on the encounters tab of the patient dashboard',184,'887a0474-9504-457b-b43a-1e7bb464b4f9'),('patient.headerAttributeTypes','Health Center, Cell Phone Number','',185,'8a7fec88-bcd8-47c9-a0e2-7d734b03511c'),('user.headerAttributeTypes','','A comma delimited list of PersonAttributeType names that will be shown on the user dashboard. (not used in v1.5)',186,'066bdf54-db39-49ea-9182-36d162201c1d'),('patient.identifierSearchPattern','','If this is empty, the regex or suffix/prefix search is used.  Comma separated list of identifiers to check.  Allows for faster searching of multiple options rather than the slow regex. e.g. @SEARCH@,0@SEARCH@,@SEARCH-1@-@CHECKDIGIT@,0@SEARCH-1@-@CHECKDIGIT@ would turn a request for \"4127\" into a search for \"in (\'4127\',\'04127\',\'412-7\',\'0412-7\')\"',187,'03c0b9cf-4125-4830-9bd0-0e9b2a653f77'),('obs.complex_obs_dir','complex_obs','Default directory for storing complex obs.',188,'d2562710-66bc-4d24-87ad-e98b0798fcb1'),('minSearchCharacters','3','Number of characters user must input before searching is started.',189,'328b003c-d95f-4f86-b855-e465c257f230'),('default_locale','en_GB','Specifies the default locale. You can specify both the language code(ISO-639) and the country code(ISO-3166), e.g. \'en_GB\' or just country: e.g. \'en\'',190,'4eec0744-183f-44f1-884c-7b6fa8451a64'),('security.passwordCannotMatchUsername','true','Configure whether passwords must not match user\'s username or system id',191,'201aed68-7612-49f7-9f4b-4d343d9c77f7'),('security.passwordCustomRegex','','Configure a custom regular expression that a password must match',192,'71891840-de49-4215-9334-e7457d05a728'),('security.passwordMinimumLength','7','Configure the minimum length required of all passwords',193,'82d1f6de-2af1-4764-9822-60a9564f19be'),('security.passwordRequiresDigit','true','Configure whether passwords must contain at least one digit',194,'1b1656b2-6641-44c6-add7-a837da1bc8ad'),('security.passwordRequiresNonDigit','true','Configure whether passwords must contain at least one non-digit',195,'4b4ea087-ebb3-4553-aeeb-f2787f913db9'),('security.passwordRequiresUpperAndLowerCase','false','Configure whether passwords must contain both upper and lower case characters',196,'39ef0505-60bd-4f68-a672-9a4b5f30350c'),('hl7_processor.ignore_missing_patient_non_local','false','If true, hl7 messages for patients that are not found and are non-local will silently be dropped/ignored',197,'913377be-710a-477c-a2a6-b53cf534b03a'),('formentry.mandatory','false','true/false whether or not the formentry module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',198,'4db43f2f-c1c5-4887-a0d5-92638bfd951e'),('simplelabentry.mandatory','false','true/false whether or not the simplelabentry module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',199,'9db2b09b-f46c-4695-a3f6-9d3461e57984'),('birt.mandatory','false','true/false whether or not the birt module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',200,'ffb72ce0-c8fe-4cdb-9bd8-af60e6a7c4ec'),('htmlformentry.mandatory','false','true/false whether or not the htmlformentry module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',201,'3ce5a5e5-9c82-46b0-91a8-8e1065e3cdbf'),('remoteformentry.mandatory','false','true/false whether or not the remoteformentry module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',202,'dd86d036-6a83-47a4-9918-e8a77c602e5e'),('formdataexport.mandatory','false','true/false whether or not the formdataexport module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',203,'689c500b-fcb7-4e9a-aff0-c5eef341fafe'),('form2program.mandatory','false','true/false whether or not the form2program module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',204,'2426605e-1819-43fd-8bf4-84801cc8d701'),('formimportexport.mandatory','false','true/false whether or not the formimportexport module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',205,'c092c180-51f8-41f8-a637-afb5387f0ca8'),('serialization.xstream.started','true','DO NOT MODIFY. true/false whether or not the serialization.xstream module has been started.  This is used to make sure modules that were running  prior to a restart are started again',206,'0ec571d3-6b89-4e83-9d2a-7d5d3cc3d915'),('serialization.xstream.mandatory','false','true/false whether or not the serialization.xstream module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',207,'61da9854-305f-4dce-969b-5058fd2ccad6'),('reporting.started','false','DO NOT MODIFY. true/false whether or not the reporting module has been started.  This is used to make sure modules that were running  prior to a restart are started again',208,'cf8ab36a-4262-49be-9b9f-028a4b723aa7'),('reportingcompatibility.started','true','DO NOT MODIFY. true/false whether or not the reportingcompatibility module has been started.  This is used to make sure modules that were running  prior to a restart are started again',209,'079704e8-9549-42d5-b799-65dde6d48f2f'),('reportingcompatibility.mandatory','false','true/false whether or not the reportingcompatibility module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',210,'4283fcb7-fb07-4d11-ab34-442d283c6b4c'),('reporting.database_version','0.1.0','DO NOT MODIFY.  Current database version number for the reporting module.',211,'2841da8e-8dce-44d2-9567-7a1f92a68c5e'),('reporting.mandatory','false','true/false whether or not the reporting module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',212,'e84fff72-08bf-4460-ad47-f79d1972e29d'),('report.deleteReportsAgeInHours','72','Reports that are not explicitly saved are deleted automatically when they are this many hours old. (Values less than or equal to zero means do not delete automatically)',213,'39ca96f0-2f54-46b2-bba6-cf15219b3501'),('dataentrystatistics.started','true','DO NOT MODIFY. true/false whether or not the dataentrystatistics module has been started.  This is used to make sure modules that were running  prior to a restart are started again',214,'d837ad15-4f55-43a6-8909-da84ffac2ddd'),('dataentrystatistics.mandatory','false','true/false whether or not the dataentrystatistics module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',215,'94622b71-93c8-415c-892a-68ef989a725f'),('patientflags.database_version','1.1.4','DO NOT MODIFY.  Current database version number for the patientflags module.',216,'bab0a52f-ef28-4be0-a43f-ef1250ceb0fc'),('patientflags.started','true','DO NOT MODIFY. true/false whether or not the patientflags module has been started.  This is used to make sure modules that were running  prior to a restart are started again',217,'03fdbb98-06cb-4d4a-a140-d84ad9af77de'),('patientflags.mandatory','false','true/false whether or not the patientflags module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',218,'0dfd3d43-b847-4de5-8e7d-ba14d830d38b'),('programlocation.database_version','0.0.1','DO NOT MODIFY.  Current database version number for the programlocation module.',220,'9a3318ba-46d9-484e-8304-fcd9da70167c'),('programlocation.started','true','DO NOT MODIFY. true/false whether or not the programlocation module has been started.  This is used to make sure modules that were running  prior to a restart are started again',221,'f3794472-985f-4ecf-a995-adebe4b79738'),('programlocation.mandatory','false','true/false whether or not the programlocation module MUST start when openmrs starts.  This is used to make sure that mission critical modules are always running if openmrs is running.',222,'2932ce2a-203b-4bb0-97ea-2f077105670e'), ('IVR_ACCESS_CODE_COUNTER','0','Keeps count of IVR Access code', 226,'2932ce2a-203b-4bb0-97ea-2f077105670f'), ('CALL_ID_COUNTER','0','Keeps count of Call ID', 227,'2932ce2a-203b-4bb0-97ea-2f077105670g'), ('interface','fancy','Ensures fancy interface', 228,'2932ce2a-203b-4bb0-97ea-2f077105670h'), ('statistics.show_encounter_types','CHILD HEALTH SYMPTOMS, MATERNAL HEALTH SYMPTOMS, MATERNITY DIAGNOSIS, REGISTRATION, TIPS AND REMINDERS','Shows these encounters on the dashboard', 229,'2932ce2a-203b-4bb0-97ea-2f077105670i'), ('health_facility.clinic_list','ANTENATAL CLINIC, ART CLINIC, HTC CLINIC, MATERNITY CLINIC, NUTRITION CLINIC, OPD CLINIC, POSTNATAL CLINIC, UNDER 5 CLINIC','Health facility clinic list', 230,'2932ce2a-203b-4bb0-97ea-2f077105670j');
/*!40000 ALTER TABLE `global_property` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

LOCK TABLES `patient_identifier_type` WRITE;

/*!40000 ALTER TABLE `patient_identifier_type` DISABLE KEYS */;
INSERT INTO `patient_identifier_type` (`name`,`description`,`check_digit`,`creator`,`date_created`,`required`,`retired`) VALUES('IVR Access Code','Unique identifier for a particular patient. To be used for search purposes',0,1,'2010-11-15T13:18:58',0,0);
UNLOCK TABLES;


LOCK TABLES `location_tag` WRITE;

/*!40000 ALTER TABLE `location_tag` DISABLE KEYS */;
INSERT INTO `location_tag` (`tag`,`description`,`creator`,`date_created`,`uuid`) VALUES('mnch_health_facilities','MNCH Health Facilities',1,'2010-11-15T13:18:58', '2932ce2a-203b-4bb0-97ea-2f077105670j');
UNLOCK TABLES;

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` (`name`,`description`,`creator`,`date_created`,`uuid`) VALUES ('Phimbi','Phimbi Health Centre',1,'2010-11-15T13:18:58', '2932ce2a-203b-4bb0-97ea-2f077105670a'), ('Kalembo','Kalembo Health Centre', 1,'2010-11-15T13:18:58', '2932ce2a-203b-4bb0-97ea-2f077105670b');
UNLOCK TABLES;

LOCK TABLES `encounter_type` WRITE;
/*!40000 ALTER TABLE `encounter_type` DISABLE KEYS */;
INSERT INTO `encounter_type` (`name`,`description`,`creator`,`date_created`) VALUES 
	('CHILD HEALTH SYMPTOMS', 'Child Health Symptoms', 1, NOW()), 
	('MATERNAL HEALTH SYMPTOMS', 'Maternal Health Symptoms', 1, NOW()), 
	('TIPS AND REMINDERS', 'Tips and Reminders', 1, NOW()),
	('PREGNANCY STATUS', 'Pregnancy Status', 1, NOW());
UNLOCK TABLES;

/*LOCK TABLES `location_tag_map` WRITE, `location_tag` WRITE, `location` WRITE;
/*LOCK TABLES `location_tag` WRITE;
LOCK TABLES `location` WRITE;*/

/*!40000 ALTER TABLE `location_tag_map` DISABLE KEYS */;
INSERT INTO `location_tag_map` (`location_id`,`location_tag_id`) VALUES ((SELECT `location_id` FROM `location` WHERE `name` = 'Phimbi'), (SELECT `location_tag_id` FROM `location_tag` WHERE `tag` = 'mnch_health_facilities')), ((SELECT `location_id` FROM `location` WHERE `name` = 'Kalembo'), (SELECT `location_tag_id` FROM `location_tag` WHERE `tag` = 'mnch_health_facilities')) ;
UNLOCK TABLES;

LOCK TABLES `concept` WRITE;

INSERT INTO concept(short_name, description,creator,date_created,class_id,datatype_id) VALUES 
	('ART CLINIC','Art Clinic',1,'2004-01-01T00:00:00',11,4),
	('MATERNITY CLINIC','Maternity Clinic',1,'2004-01-01T00:00:00',11,4), 
	('HTC CLINIC','HTC Clinic',1,'2004-01-01T00:00:00',11,4),
	('NUTRITION CLINIC','Nutrition Clinic',1,'2004-01-01T00:00:00',11,4),
	('OPD CLINIC','OPD Clinic',1,'2004-01-01T00:00:00',11,4),
	('POSTNATAL CLINIC','Postnatal Clinic',1,'2004-01-01T00:00:00',11,4),
	('MONDAY','Monday',1,'2004-01-01T00:00:00',11,4),
	('TUESDAY','Tuesday',1,'2004-01-01T00:00:00',11,4),
	('WEDNESDAY','Wednesday',1,'2004-01-01T00:00:00',11,4),
	('THURSDAY','Thursday',1,'2004-01-01T00:00:00',11,4),
	('FRIDAY','Friday',1,'2004-01-01T00:00:00',11,4),
	('SATURDAY','Saturday',1,'2004-01-01T00:00:00',11,4),
	('SUNDAY','Sunday',1,'2004-01-01T00:00:00',11,4),
	('DIARRHEA','Diarrhea',1,'2004-01-01T00:00:00',12,2),
	('COUGH','Cough',1,'2004-01-01T00:00:00',12,2),
	('CONVULSIONS SIGN','Convulsions SIGN',1,'2004-01-01T00:00:00',12,2),
	('CONVULSIONS SYMPTOM','Convulsions SYMPTOM',1,'2004-01-01T00:00:00',12,2),
	('NOT EATING','Not Eating',1,'2004-01-01T00:00:00',12,2),
	('VOMITING','Vomiting',1,'2004-01-01T00:00:00',12,2),
	('RED EYE','Red Eye',1,'2004-01-01T00:00:00',12,2),
	('FAST BREATHING','Fast Breathing',1,'2004-01-01T00:00:00',12,2),
	('VERY SLEEPY','Very Sleepy',1,'2004-01-01T00:00:00',12,2),
	('UNCONSCIOUS','Unconscious',1,'2004-01-01T00:00:00',12,2),
	('SLEEPING','Sleeping',1,'2004-01-01T00:00:00',12,2),
	('FEEDING PROBLEMS','Feeding Problems',1,'2004-01-01T00:00:00',12,2),
	('CRYING','Crying',1,'2004-01-01T00:00:00',12,2),
	('BOWEL MOVEMENTS','Bowel Movements',1,'2004-01-01T00:00:00',12,2),
	('SKIN RASHES','Skin Rash',1,'2004-01-01T00:00:00',12,2),
	('SKIN INFECTIONS','Skin Infections',1,'2004-01-01T00:00:00',12,2),
	('UMBILICUS INFECTION','Umbilicus Infection',1,'2004-01-01T00:00:00',12,2),
	('GROWTH MILESTONES','Growth Milestones',1,'2004-01-01T00:00:00',12,2),
	('ACCESSING HEALTHCARE SERVICES','Accessing Healthcare services',1,'2004-01-01T00:00:00',12,2),
	('FEVER OF 7 DAYS OR MORE','Fever of 7 days or more',1,'2004-01-01T00:00:00',12,2),
	('DIARRHEA FOR 14 DAYS OR MORE','Diarrhea for 14 days or more',1,'2004-01-01T00:00:00',12,2),
	('BLOOD IN STOOL','Blood in stool',1,'2004-01-01T00:00:00',12,2),
	('COUGH FOR 21 DAYS OR MORE','Cough for 21 days or more',1,'2004-01-01T00:00:00',12,2),
	('NOT EATING OR DRINKING ANYTHING','Not eating or drinking anything',1,'2004-01-01T00:00:00',12,2),
	('VOMITING EVERYTHING','Vomiting everything',1,'2004-01-01T00:00:00',12,2),
	('RED EYE FOR 4 DAYS OR MORE WITH VISUAL PROBLEMS','Red eye for 4 days or more with visual problems',1,'2004-01-01T00:00:00',12,2),
	('POTENTIAL CHEST INDRAWING','Potential Chest Indrawing',1,'2004-01-01T00:00:00',12,2),
	('VAGINAL BLEEDING DURING PREGNANCY','VAGINAL BLEEDING DURING PREGNANCY',1,'2004-01-01T00:00:00',12,2),
	('POSTNATAL BLEEDING','POSTNATAL BLEEDING',1,'2004-01-01T00:00:00',12,2),
	('FEVER DURING PREGNANCY SIGN','FEVER DURING PREGNANCY SIGN',1,'2004-01-01T00:00:00',12,2),
	('FEVER DURING PREGNANCY SYMPTOM','FEVER DURING PREGNANCY SYMPTOM',1,'2004-01-01T00:00:00',12,2),
	('POSTNATAL FEVER SIGN','POSTNATAL FEVER SIGN',1,'2004-01-01T00:00:00',12,2),
	('POSTNATAL FEVER SYMPTOM','POSTNATAL FEVER SYMPTOM',1,'2004-01-01T00:00:00',12,2),
	('HEADACHES','HEADACHES',1,'2004-01-01T00:00:00',12,2),
	('FITS OR CONVULSIONS SIGN','FITS OR CONVULSIONS SIGN',1,'2004-01-01T00:00:00',12,2),
	('FITS OR CONVULSIONS SYMPTOM','FITS OR CONVULSIONS SYMPTOM',1,'2004-01-01T00:00:00',12,2),
	('SWOLLEN HANDS OR FEET SIGN','SWOLLEN HANDS OR FEET SIGN',1,'2004-01-01T00:00:00',12,2),
	('SWOLLEN HANDS OR FEET SYMPTOM','SWOLLEN HANDS OR FEET SYMPTOM',1,'2004-01-01T00:00:00',12,2),
	('PALENESS OF THE SKIN AND TIREDNESS SIGN','PALENESS OF THE SKIN AND TIREDNESS SIGN',1,'2004-01-01T00:00:00',12,2),
	('PALENESS OF THE SKIN AND TIREDNESS SYMPTOM','PALENESS OF THE SKIN AND TIREDNESS SYMPTOM',1,'2004-01-01T00:00:00',12,2),
	('NO FETAL MOVEMENTS SIGN','NO FETAL MOVEMENTS SIGN',1,'2004-01-01T00:00:00',12,2),
	('NO FETAL MOVEMENTS SYMPTOM','NO FETAL MOVEMENTS SYMPTOM',1,'2004-01-01T00:00:00',12,2),
	('WATER BREAKS SIGN','WATER BREAKS SIGN',1,'2004-01-01T00:00:00',12,2),
	('WATER BREAKS SYMPTOM','WATER BREAKS SYMPTOM',1,'2004-01-01T00:00:00',12,2),
	('HEALTHCARE VISITS','HEALTHCARE VISITS',1,'2004-01-01T00:00:00',12,2),
	('NUTRITION','NUTRITION',1,'2004-01-01T00:00:00',12,2),
	('BODY CHANGES','BODY CHANGES',1,'2004-01-01T00:00:00',12,2),
	('DISCOMFORT','DISCONFORT',1,'2004-01-01T00:00:00',12,2),
	('CONCERNS','CONCERNS',1,'2004-01-01T00:00:00',12,2),
	('EMOTIONS','EMOTIONS',1,'2004-01-01T00:00:00',12,2),
	('WARNING SIGNS','WARNING SIGNS',1,'2004-01-01T00:00:00',12,2),
	('ROUTINES','NROUTINES',1,'2004-01-01T00:00:00',12,2),
	('BELIEFS','BELIEFS',1,'2004-01-01T00:00:00',12,2),
	("BABY'S GROWTH","BABY'S GROWTH",1,'2004-01-01T00:00:00',12,2),
	('MILESTONES','MILESTONES',1,'2004-01-01T00:00:00',12,2),
	('PREVENTION','PREVENTION',1,'2004-01-01T00:00:00',12,2),
	('HEAVY VAGINAL BLEEDING DURING PREGNANCY','HEAVY VAGINAL BLEEDING DURING PREGNANCY',1,'2004-01-01T00:00:00',12,2),
	('EXCESSIVE POSTNATAL BLEEDING','EXCESSIVE POSTNATAL BLEEDING',1,'2004-01-01T00:00:00',12,2),
	('SEVERE HEADACHE','SEVERE HEADACHE',1,'2004-01-01T00:00:00',12,2),
	('HEALTH FACILITY NAME','HEALTH FACILITY NAME',1,'2004-01-01T00:00:00',12,2),
	('DELIVERY DATE','DELIVERY DATE',1,'2004-01-01T00:00:00',12,2),
	('CALL ID','CALL ID',1,'2004-01-01T00:00:00',12,2),
	('PREGNANCY','PREGNANCY',1,'2004-01-01T00:00:00',12,2),
	('POSTNATAL','POSTNATAL',1,'2004-01-01T00:00:00',12,2),
	('CHILD','CHILD',1,'2004-01-01T00:00:00',12,2),
	('WCBA','WCBA',1,'2004-01-01T00:00:00',12,2),
	('OBSERVER','OBSERVER',1,'2004-01-01T00:00:00',12,2),
	('SMS','SMS',1,'2004-01-01T00:00:00',12,2),
	('VOICE','VOICE',1,'2004-01-01T00:00:00',12,2),
	('CHICHEWA','CHICHEWA',1,'2004-01-01T00:00:00',12,2),
	('CHIYAO','CHIYAO',1,'2004-01-01T00:00:00',12,2),
	('COMMUNITY PHONE','COMMUNITY PHONE',1,'2004-01-01T00:00:00',12,2),
	('PERSONAL PHONE','PERSONAL PHONE',1,'2004-01-01T00:00:00',12,2),
	('ON TIPS AND REMINDERS PROGRAM', 'ON TIPS AND REMINDERS PROGRAM', 1, '2004-01-01T00:00:00', 12, 2),
	('LANGUAGE PREFERENCE', 'LANGUAGE PREFERENCE', 1, '2004-01-01T00:00:00', 12, 2),
	('TYPE OF MESSAGE', 'TYPE OF MESSAGE', 1, '2004-01-01T00:00:00', 12, 2),
	('TYPE OF MESSAGE CONTENT', 'TYPE OF MESSAGE CONTENT', 1, '2004-01-01T00:00:00', 12, 2),
	('VERY SLEEPY OR UNCONSCIOUS','VERY SLEEPY OR UNCONSCIOUS',1,'2004-01-01T00:00:00',11,4),
	('FAMILY MEMBER PHONE', 'FAMILY MEMBER PHONE',1,'2004-01-01T00:00:00',12,2);
	
LOCK TABLES `concept_name` WRITE;
INSERT INTO concept_name(concept_id,name,locale,creator,date_created) VALUES 
	(1, 'ART CLINIC','en',1,'2004-01-01T00:00:00'),
	(1, 'MATERNITY CLINIC','en',1,'2004-01-01T00:00:00'), 
	(1, 'HTC CLINIC','en',1,'2004-01-01T00:00:00'),
	(1, 'NUTRITION CLINIC','en',1,'2004-01-01T00:00:00'),
	(1, 'OPD CLINIC','en',1,'2004-01-01T00:00:00'),
	(1, 'POSTNATAL CLINIC','en',1,'2004-01-01T00:00:00'),
	(1, 'MONDAY','en',1,'2004-01-01T00:00:00'),
	(1, 'TUESDAY','en',1,'2004-01-01T00:00:00'),
	(1, 'WEDNESDAY','en',1,'2004-01-01T00:00:00'),
	(1, 'THURSDAY','en',1,'2004-01-01T00:00:00'),
	(1, 'FRIDAY','en',1,'2004-01-01T00:00:00'),
	(1, 'SATURDAY','en',1,'2004-01-01T00:00:00'),
	(1, 'SUNDAY','en',1,'2004-01-01T00:00:00'),
	(1,'VAGINAL BLEEDING DURING PREGNANCY','en',1,'2004-01-01T00:00:00'),
	(1,'DIARRHEA','en',1,'2004-01-01T00:00:00'),
	(1,'COUGH','en',1,'2004-01-01T00:00:00'),
	(1,'CONVULSIONS SIGN','en',1,'2004-01-01T00:00:00'),
	(1,'CONVULSIONS SYMPTOM','en',1,'2004-01-01T00:00:00'),
	(1,'NOT EATING','en',1,'2004-01-01T00:00:00'),
	(1,'VOMITING','en',1,'2004-01-01T00:00:00'),
	(1,'RED EYE','en',1,'2004-01-01T00:00:00'),
	(1,'FAST BREATHING','en',1,'2004-01-01T00:00:00'),
	(1,'VERY SLEEPY','en',1,'2004-01-01T00:00:00'),
	(1,'UNCONSCIOUS','en',1,'2004-01-01T00:00:00'),
	(1,'SLEEPING','en',1,'2004-01-01T00:00:00'),
	(1,'FEEDING PROBLEMS','en',1,'2004-01-01T00:00:00'),
	(1,'CRYING','en',1,'2004-01-01T00:00:00'),
	(1,'BOWEL MOVEMENTS','en',1,'2004-01-01T00:00:00'),
	(1,'SKIN RASHES','en',1,'2004-01-01T00:00:00'),
	(1,'SKIN INFECTIONS','en',1,'2004-01-01T00:00:00'),
	(1,'UMBILICUS INFECTION','en',1,'2004-01-01T00:00:00'),
	(1,'GROWTH MILESTONES','en',1,'2004-01-01T00:00:00'),
	(1,'ACCESSING HEALTHCARE SERVICES','en',1,'2004-01-01T00:00:00'),
	(1,'FEVER OF 7 DAYS OR MORE','en',1,'2004-01-01T00:00:00'),
	(1,'DIARRHEA FOR 14 DAYS OR MORE','en',1,'2004-01-01T00:00:00'),
	(1,'BLOOD IN STOOL','en',1,'2004-01-01T00:00:00'),
	(1,'COUGH FOR 21 DAYS OR MORE','en',1,'2004-01-01T00:00:00'),
	(1,'NOT EATING OR DRINKING ANYTHING','en',1,'2004-01-01T00:00:00'),
	(1,'VOMITING EVERYTHING','en',1,'2004-01-01T00:00:00'),
	(1,'RED EYE FOR 4 DAYS OR MORE WITH VISUAL PROBLEMS','en',1,'2004-01-01T00:00:00'),
	(1,'POTENTIAL CHEST INDRAWING','en',1,'2004-01-01T00:00:00'),
	(1,'VERY SLEEPY','en',1,'2004-01-01T00:00:00'),
	(1,'POSTNATAL BLEEDING','en',1,'2004-01-01T00:00:00'),
	(1,'FEVER DURING PREGNANCY SIGN','en',1,'2004-01-01T00:00:00'),
	(1,'FEVER DURING PREGNANCY SYMPTOM','en',1,'2004-01-01T00:00:00'),
	(1,'POSTNATAL FEVER SIGN','en',1,'2004-01-01T00:00:00') ,
	(1,'POSTNATAL FEVER SYMPTOM','en',1,'2004-01-01T00:00:00') ,
	(1,'HEADACHES','en',1,'2004-01-01T00:00:00') ,
	(1,'FITS OR CONVULSIONS SIGN','en',1,'2004-01-01T00:00:00') ,
	(1,'FITS OR CONVULSIONS SYMPTOM','en',1,'2004-01-01T00:00:00') ,
	(1,'SWOLLEN HANDS OR FEET SIGN','en',1,'2004-01-01T00:00:00') ,
	(1,'SWOLLEN HANDS OR FEET SYMPTOM','en',1,'2004-01-01T00:00:00') ,
	(1,'PALENESS OF THE SKIN AND TIREDNESS SIGN','en', 1,'2004-01-01T00:00:00') ,
	(1,'PALENESS OF THE SKIN AND TIREDNESS SYMPTOM','en', 1,'2004-01-01T00:00:00') ,
	(1,'NO FETAL MOVEMENTS SIGN','en', 1,'2004-01-01T00:00:00') ,
	(1,'NO FETAL MOVEMENTS SYMPTOM','en', 1,'2004-01-01T00:00:00') ,
	(1,'WATER BREAKS SIGN','en', 1,'2004-01-01T00:00:00') ,
	(1,'WATER BREAKS SYMPTOM','en', 1,'2004-01-01T00:00:00') ,
	(1,'HEALTHCARE VISITS','en', 1,'2004-01-01T00:00:00') ,
	(1,'NUTRITION','en', 1,'2004-01-01T00:00:00') ,
	(1,'BODY CHANGES','en', 1,'2004-01-01T00:00:00') ,
	(1,'DISCOMFORT','en', 1,'2004-01-01T00:00:00') ,
	(1,'CONCERNS','en', 1,'2004-01-01T00:00:00') ,
	(1,'EMOTIONS','en', 1,'2004-01-01T00:00:00') ,
	(1,'WARNING SIGNS','en', 1,'2004-01-01T00:00:00') ,
	(1,'ROUTINES','en', 1,'2004-01-01T00:00:00') ,
	(1,'BELIEFS','en', 1,'2004-01-01T00:00:00') ,
	(1,'BABYS GROWTH','eN', 1,'2004-01-01T00:00:00') ,
	(1,'MILESTONES','en', 1,'2004-01-01T00:00:00') ,
	(1,'PREVENTION','en', 1,'2004-01-01T00:00:00'),
	(1, 'HEAVY VAGINAL BLEEDING DURING PREGNANCY','en', 1,'2004-01-01T00:00:00'),
	(1, 'EXCESSIVE POSTNATAL BLEEDING','en', 1,'2004-01-01T00:00:00'),
	(1, 'SEVERE HEADACHE','en', 1,'2004-01-01T00:00:00'),
	(1,'CALL ID','en',1,'2004-01-01T00:00:00'),
	(1,"BABY'S GROWTH",'en',1,'2004-01-01T00:00:00'),
	(1,'DELIVERY DATE','en',1,'2004-01-01T00:00:00'),
	(1,'HEALTH FACILITY NAME','en',1,'2004-01-01T00:00:00'),
	(1,'PREGNANCY', 'en', 1,'2004-01-01T00:00:00'),
	(1,'POSTNATAL', 'en', 1,'2004-01-01T00:00:00'),
	(1, 'CHILD','en', 1,'2004-01-01T00:00:00'),
	(1, 'WCBA','en', 1,'2004-01-01T00:00:00'),
	(1, 'OBSERVER','en', 1,'2004-01-01T00:00:00'),
	(1, 'SMS','en', 1,'2004-01-01T00:00:00'),
	(1, 'VOICE','en',1,'2004-01-01T00:00:00'),
	(1, 'CHICHEWA','en',1,'2004-01-01T00:00:00'),
	(1, 'CHIYAO','en',1,'2004-01-01T00:00:00'),
	(1, 'COMMUNITY PHONE','en',1,'2004-01-01T00:00:00'),
	(1, 'PERSONAL PHONE','en',1,'2004-01-01T00:00:00'),
	(1, 'ON TIPS AND REMINDERS PROGRAM','en',1,'2004-01-01T00:00:00'),
	(1, 'LANGUAGE PREFERENCE','en',1,'2004-01-01T00:00:00'),
	(1, 'TYPE OF MESSAGE','en',1,'2004-01-01T00:00:00'),
	(1, 'TYPE OF MESSAGE CONTENT','en',1,'2004-01-01T00:00:00'),
	(1, 'VERY SLEEPY OR UNCONSCIOUS','en',1,'2004-01-01T00:00:00'),
	(1, 'FAMILY MEMBER PHONE','en',1,'2004-01-01T00:00:00');
UNLOCK TABLES;

UPDATE concept_name SET concept_id =(SELECT concept_id FROM concept WHERE concept.short_name = concept_name.name) WHERE concept_id = 1; 


LOCK TABLES `concept_name_tag` WRITE;
INSERT INTO concept_name_tag(tag,description,creator,date_created,voided) VALUES
  ('DANGER SIGN', 'Tag for Danger Signs',1,'2004-01-01T00:00:00',0), 
  ('HEALTH INFORMATION', 'Tag for Health Information',1,'2004-01-01T00:00:00',0), 
  ('HEALTH SYMPTOM', 'Tag for Health Symptoms',1,'2004-01-01T00:00:00',0);
UNLOCK TABLES;

#LOCK TABLES `concept_name_tag_map` WRITE;

INSERT INTO concept_name_tag_map(concept_name_id, concept_name_tag_id) VALUES
  ((SELECT concept_id FROM concept WHERE short_name = "FEVER OF 7 DAYS OR MORE"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")), 
  ((SELECT concept_id FROM concept WHERE short_name = "DIARRHEA FOR 14 DAYS OR MORE"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "BLOOD IN STOOL"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")), 
  ((SELECT concept_id FROM concept WHERE short_name = "COUGH FOR 21 DAYS OR MORE"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "CONVULSIONS SIGN"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")), 
  ((SELECT concept_id FROM concept WHERE short_name = "NOT EATING OR DRINKING ANYTHING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "VOMITING EVERYTHING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "RED EYE FOR 4 DAYS OR MORE WITH VISUAL PROBLEMS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "VERY SLEEPY OR UNCONSCIOUS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "POTENTIAL CHEST INDRAWING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "HEAVY VAGINAL BLEEDING DURING PREGNANCY"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "EXCESSIVE POSTNATAL BLEEDING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")), 
  ((SELECT concept_id FROM concept WHERE short_name = "FEVER DURING PREGNANCY SIGN"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "POSTNATAL FEVER SIGN"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "SEVERE HEADACHE"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "FITS OR CONVULSIONS SIGN"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "SWOLLEN HANDS OR FEET SIGN"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "PALENESS OF THE SKIN AND TIREDNESS SIGN"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "NO FETAL MOVEMENTS SIGN"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "WATER BREAKS SIGN"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "DANGER SIGN")),
  ((SELECT concept_id FROM concept WHERE short_name = "SLEEPING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "FEEDING PROBLEMS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "CRYING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")),
  ((SELECT concept_id FROM concept WHERE short_name = "BOWEL MOVEMENTS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "SKIN RASHES"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "SKIN INFECTIONS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")),
  ((SELECT concept_id FROM concept WHERE short_name = "UMBILICUS INFECTION"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "GROWTH MILESTONES"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")),
  ((SELECT concept_id FROM concept WHERE short_name = "ACCESSING HEALTHCARE SERVICES"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")),
  ((SELECT concept_id FROM concept WHERE short_name = "HEALTHCARE VISITS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "NUTRITION"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "BODY CHANGES"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")),
  ((SELECT concept_id FROM concept WHERE short_name = "DISCOMFORT"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "CONCERNS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "EMOTIONS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")),
  ((SELECT concept_id FROM concept WHERE short_name = "WARNING SIGNS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "ROUTINES"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "BELIEFS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")),
  ((SELECT concept_id FROM concept WHERE short_name = "BABY'S GROWTH"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "MILESTONES"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")), 
  ((SELECT concept_id FROM concept WHERE short_name = "PREVENTION"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH INFORMATION")),
  ((SELECT concept_id FROM concept WHERE short_name = "FEVER"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "DIARRHEA"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "COUGH"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "CONVULSIONS SYMPTOM"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")),
  ((SELECT concept_id FROM concept WHERE short_name = "NOT EATING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "VOMITING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "RED EYE"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")),
  ((SELECT concept_id FROM concept WHERE short_name = "FAST BREATHING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "VERY SLEEPY"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")),
  ((SELECT concept_id FROM concept WHERE short_name = "UNCONSCIOUS"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")),
  ((SELECT concept_id FROM concept WHERE short_name = "VAGINAL BLEEDING DURING PREGNANCY"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")),
  ((SELECT concept_id FROM concept WHERE short_name = "POSTNATAL BLEEDING"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "FEVER DURING PREGNANCY SYMPTOM"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")),
  ((SELECT concept_id FROM concept WHERE short_name = "POSTNATAL FEVER SYMPTOM"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "HEADACHES"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "FITS OR CONVULSIONS SYMPTOM"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")),
  ((SELECT concept_id FROM concept WHERE short_name = "SWOLLEN HANDS OR FEET SYMPTOM"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "PALENESS OF THE SKIN AND TIREDNESS SYMPTOM"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")),
  ((SELECT concept_id FROM concept WHERE short_name = "NO FETAL MOVEMENTS SYMPTOM"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM")), 
  ((SELECT concept_id FROM concept WHERE short_name = "WATER BREAKS SYMPTOM"),(SELECT concept_name_tag_id FROM concept_name_tag WHERE tag = "HEALTH SYMPTOM"));
  
#UNLOCK TABLES;

--
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-03-17 15:18:37

/* INSERT INTO concept(short_name, description,creator,date_created,class_id,datatype_id) VALUES  ('TYPE OF MESSAGE CONTENT','TYPE OF MESSAGE CONTENT', 1, '2004-01-01T00:00:00', 12, 2);

INSERT INTO concept_name(concept_id,name,locale,creator,date_created) VALUES  (1, 'TYPE OF MESSAGE CONTENT','en',1,'2004-01-01T00:00:00');

UPDATE concept_name SET concept_id =(SELECT concept_id FROM concept WHERE concept.short_name = concept_name.name) WHERE concept_id = 1; 

TYPE OF MESSAGE*/
