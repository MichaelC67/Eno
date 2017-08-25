<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:eno="http://xml.insee.fr/apps/eno" xmlns:g="ddi:group:3_2"
    xmlns:d="ddi:datacollection:3_2" xmlns:s="ddi:studyunit:3_2" xmlns:r="ddi:reusable:3_2"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:a="ddi:archive:3_2"
    xmlns:l="ddi:logicalproduct:3_2" xmlns:enoddi32="http://xml.insee.fr/apps/eno/out/ddi32"
    exclude-result-prefixes="xs" version="2.0">


    <xd:doc>
        <xd:desc>
            <xd:p>The highest driver, which starts the generation of the xforms.</xd:p>
            <xd:p>It writes codes on different levels for a same driver by adding an element to the
                virtuel tree :</xd:p>
            <xd:p>- Instance : to write the main instance</xd:p>
            <xd:p>- Bind : to writes the binds associated to the elements of the instance</xd:p>
            <xd:p>- Resource : an instance which stores the externalized texts used in the body part
                (xforms labels, hints, helps, alerts)</xd:p>
            <xd:p>- ResourceBind : to write the few binds of the elements of the resource instance
                which are calculated</xd:p>
            <xd:p>- Body : to write the fields</xd:p>
            <xd:p>- Model : to write model elements of the instance which could be potentially added
                by the user in the instance</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="Form" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:variable name="citation" select="enoddi32:get-citation($source-context)" as="xs:string"/>
        <xsl:variable name="agency" select="enoddi32:get-agency($source-context)" as="xs:string"/>
        <DDIInstance xmlns="ddi:instance:3_2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:g="ddi:group:3_2" xmlns:d="ddi:datacollection:3_2" xmlns:s="ddi:studyunit:3_2"
            xmlns:r="ddi:reusable:3_2" xmlns:xhtml="http://www.w3.org/1999/xhtml"
            xmlns:a="ddi:archive:3_2" xmlns:l="ddi:logicalproduct:3_2"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xsi:schemaLocation="ddi:instance:3_2 ../../../schema/instance.xsd" isMaintainable="true">
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="concat('INSEE-', enoddi32:get-id($source-context))"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:Citation>
                <r:Title>
                    <r:String>
                        <xsl:value-of select="$citation"/>
                    </r:String>
                </r:Title>
            </r:Citation>
            <g:ResourcePackage isMaintainable="true" versionDate="{current-date()}">
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID><xsl:value-of select="concat('RessourcePackage-', enoddi32:get-id($source-context))"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <d:InterviewerInstructionScheme>
                    <r:Agency>
                        <xsl:value-of select="$agency"/>
                    </r:Agency>
                    <r:ID><xsl:value-of select="concat('InterviewerInstructionScheme-', enoddi32:get-id($source-context))"/></r:ID>
                    <r:Version>
                        <xsl:value-of select="enoddi32:get-version($source-context)"/>
                    </r:Version>
                    <r:Label>
                        <r:Content xml:lang="{enoddi32:get-lang($source-context)}">A
                            définir</r:Content>
                    </r:Label>
                    <xsl:apply-templates select="enoddi32:get-instructions($source-context)"
                        mode="source">
                        <xsl:with-param name="driver"
                            select="eno:append-empty-element('driver-InterviewerInstructionScheme', .)"
                            tunnel="yes"/>
                        <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
                    </xsl:apply-templates>
                </d:InterviewerInstructionScheme>
                <d:ControlConstructScheme>
                    <r:Agency>
                        <xsl:value-of select="$agency"/>
                    </r:Agency>
                    <r:ID><xsl:value-of select="concat('ControlConstructScheme-', enoddi32:get-id($source-context))"/></r:ID>
                    <r:Version>
                        <xsl:value-of select="enoddi32:get-version($source-context)"/>
                    </r:Version>
                    <d:Sequence>
                        <r:Agency>
                            <xsl:value-of select="$agency"/>
                        </r:Agency>
                        <r:ID><xsl:value-of select="concat('Sequence-', enoddi32:get-id($source-context))"/></r:ID>
                        <r:Version>
                            <xsl:value-of select="enoddi32:get-version($source-context)"/>
                        </r:Version>
                        <r:Label>
                            <r:Content xml:lang="{enoddi32:get-lang($source-context)}">
                                <xsl:value-of select="enoddi32:get-label($source-context)"/>
                            </r:Content>
                        </r:Label>
                        <d:TypeOfSequence>template</d:TypeOfSequence>
                        <!--creation of references of direct children-->
                        <xsl:apply-templates select="eno:child-fields($source-context)"
                            mode="source">
                            <xsl:with-param name="driver"
                                select="eno:append-empty-element('Sequence', .)"
                                tunnel="yes"/>
                            
                            <xsl:with-param name="agency" select="$agency" as="xs:string"
                                tunnel="yes"/>
                        </xsl:apply-templates>
                    </d:Sequence>
                    <!--creation of control construct from children (everything since we are at the root node), whose reference were created sooner-->
                    <xsl:apply-templates select="enoddi32:get-sequences($source-context)"
                        mode="source">
                        <xsl:with-param name="driver"
                            select="eno:append-empty-element('driver-ControlConstructScheme', .)"
                            tunnel="yes"/>
                        <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="enoddi32:get-questions($source-context)"
                        mode="source">
                        <xsl:with-param name="driver"
                            select="eno:append-empty-element('driver-ControlConstructScheme', .)"
                            tunnel="yes"/>
                        <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
                    </xsl:apply-templates>
                </d:ControlConstructScheme>
                <d:QuestionScheme>
                    <r:Agency>
                        <xsl:value-of select="$agency"/>
                    </r:Agency>
                    <r:ID><xsl:value-of select="concat('QuestionScheme-',enoddi32:get-id($source-context))"/></r:ID>
                    <r:Version>
                        <xsl:value-of select="enoddi32:get-version($source-context)"/>
                    </r:Version>
                    <r:Label>
                        <r:Content xml:lang="{enoddi32:get-lang($source-context)}">A
                            définir</r:Content>
                    </r:Label>
                    <xsl:apply-templates select="enoddi32:get-questions($source-context)"
                        mode="source">
                        <xsl:with-param name="driver"
                            select="eno:append-empty-element('driver-QuestionScheme', .)"
                            tunnel="yes"/>
                        <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
                    </xsl:apply-templates>
                </d:QuestionScheme>
                <l:CategoryScheme>
                    <r:Agency>
                        <xsl:value-of select="enoddi32:get-agency($source-context)"/>
                    </r:Agency>
                    <r:ID><xsl:value-of select="concat('CategoryScheme-',enoddi32:get-id($source-context))"/></r:ID>
                    <r:Version>
                        <xsl:value-of select="enoddi32:get-version($source-context)"/>
                    </r:Version>
                    <r:Label>
                        <r:Content xml:lang="{enoddi32:get-lang($source-context)}">A
                            définir</r:Content>
                    </r:Label>
                    <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                        <xsl:with-param name="driver"
                            select="eno:append-empty-element('driver-CategoryScheme', .)"
                            tunnel="yes"/>
                        <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
                    </xsl:apply-templates>
                    <xsl:if test="enoddi32:exist-boolean($source-context)">
                        <l:Category>		
                            <r:Agency>
                                <xsl:value-of select="$agency"/>
                            </r:Agency>
                            <r:ID>INSEE-COMMUN-CA-Booleen-1</r:ID>	
                            <r:Version>
                                <xsl:value-of select="enoddi32:get-version($source-context)"/>
                            </r:Version>
                            <r:Label>	
                                <r:Content xml:lang="{enoddi32:get-lang($source-context)}"/>
                            </r:Label>	
                        </l:Category>		
                    </xsl:if>
                </l:CategoryScheme>
                <l:CodeListScheme>
                    <r:Agency>
                        <xsl:value-of select="$agency"/>
                    </r:Agency>
                    <r:ID><xsl:value-of select="concat('CodeListScheme-',enoddi32:get-id($source-context))"/></r:ID>
                    <r:Version>
                        <xsl:value-of select="enoddi32:get-version($source-context)"/>
                    </r:Version>
                    <r:Label>
                        <r:Content xml:lang="{enoddi32:get-lang($source-context)}">Codelists for the
                            survey</r:Content>
                    </r:Label>
                    <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                        <xsl:with-param name="driver"
                            select="eno:append-empty-element('driver-CodeListScheme', .)"
                            tunnel="yes"/>
                        <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
                    </xsl:apply-templates>
                    <xsl:if test="enoddi32:exist-boolean($source-context)">
                        <l:CodeList>
                            <r:Agency><xsl:value-of select="$agency"/></r:Agency>
                            <r:ID>INSEE-COMMUN-CL-Booleen-1</r:ID>
                            <r:Version><xsl:value-of select="enoddi32:get-version($source-context)"/></r:Version>
                            <l:Code levelNumber="1" isDiscrete="true">		
                                <r:Agency>
                                    <xsl:value-of select="$agency"/>
                                </r:Agency>
                                <r:ID>INSEE-COMMUN-CL-C-Booleen-1</r:ID>	
                                <r:Version>
                                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                                </r:Version>
                                <r:CategoryReference>	
                                    <r:Agency>
                                        <xsl:value-of select="$agency"/>
                                    </r:Agency>
                                    <r:ID>INSEE-COMMUN-CA-Booleen-1</r:ID>
                                    <r:Version>
                                        <xsl:value-of select="enoddi32:get-version($source-context)"/>
                                    </r:Version>
                                    <r:TypeOfObject>Category</r:TypeOfObject>                                    
                                </r:CategoryReference>	
                                <r:Value>1</r:Value>	
                            </l:Code>
                        </l:CodeList>
                    </xsl:if>
                </l:CodeListScheme>
                <l:VariableScheme>
                    <r:Agency>
                        <xsl:value-of select="$agency"/>
                    </r:Agency>
                    <r:ID><xsl:value-of select="concat('VariableScheme-',enoddi32:get-id($source-context))"/></r:ID>
                    <r:Version>
                        <xsl:value-of select="enoddi32:get-version($source-context)"/>
                    </r:Version>
                    <r:Label>
                        <r:Content xml:lang="{enoddi32:get-lang($source-context)}">Variable Scheme
                            for the survey</r:Content>
                    </r:Label>
                </l:VariableScheme>
            </g:ResourcePackage>
            <s:StudyUnit xmlns="ddi:studyunit:3_2">
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID><xsl:value-of select="concat('StudyUnit-',enoddi32:get-id($source-context))"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:ExPostEvaluation/>
                <d:DataCollection>
                    <r:Agency>
                        <xsl:value-of select="$agency"/>
                    </r:Agency>
                    <r:ID><xsl:value-of select="concat('DataCollection-',enoddi32:get-id($source-context))"/></r:ID>
                    <r:Version>
                        <xsl:value-of select="enoddi32:get-version($source-context)"/>
                    </r:Version>
                    <r:QuestionSchemeReference>
                        <r:Agency>
                            <xsl:value-of select="$agency"/>
                        </r:Agency>
                        <r:ID><xsl:value-of select="concat('QuestionScheme-',enoddi32:get-id($source-context))"/></r:ID>
                        <r:Version>
                            <xsl:value-of select="enoddi32:get-version($source-context)"/>
                        </r:Version>
                        <r:TypeOfObject>QuestionScheme</r:TypeOfObject>
                    </r:QuestionSchemeReference>
                    <r:ControlConstructSchemeReference>
                        <r:Agency>
                            <xsl:value-of select="$agency"/>
                        </r:Agency>
                        <r:ID><xsl:value-of select="concat('ControlConstructScheme-',enoddi32:get-id($source-context))"/></r:ID>
                        <r:Version>
                            <xsl:value-of select="enoddi32:get-version($source-context)"/>
                        </r:Version>
                        <r:TypeOfObject>ControlConstructScheme</r:TypeOfObject>
                    </r:ControlConstructSchemeReference>
                    <r:InterviewerInstructionSchemeReference>
                        <r:Agency>
                            <xsl:value-of select="$agency"/>
                        </r:Agency>
                        <r:ID><xsl:value-of select="concat('InterviewerInstructionScheme-',enoddi32:get-id($source-context))"/></r:ID>
                        <r:Version>
                            <xsl:value-of select="enoddi32:get-version($source-context)"/>
                        </r:Version>
                        <r:TypeOfObject>InterviewerInstructionScheme</r:TypeOfObject>
                    </r:InterviewerInstructionSchemeReference>
                    <d:InstrumentScheme xml:lang="{enoddi32:get-lang($source-context)}">
                        <r:Agency>
                            <xsl:value-of select="$agency"/>
                        </r:Agency>
                        <r:ID><xsl:value-of select="concat('InstrumentScheme-',enoddi32:get-id($source-context))"/></r:ID>
                        <r:Version>
                            <xsl:value-of select="enoddi32:get-version($source-context)"/>
                        </r:Version>
                        <d:Instrument xmlns:pogues="http://xml.insee.fr/schema/applis/pogues"
                            xmlns:pr="ddi:ddiprofile:3_2" xmlns:c="ddi:conceptualcomponent:3_2"
                            xmlns:cm="ddi:comparative:3_2">
                            <r:Agency>
                                <xsl:value-of select="$agency"/>
                            </r:Agency>
                            <r:ID><xsl:value-of select="concat('Instrument-',enoddi32:get-id($source-context))"/></r:ID>
                            <r:Version>
                                <xsl:value-of select="enoddi32:get-version($source-context)"/>
                            </r:Version>
                            <r:Label>
                                <r:Content xml:lang="{enoddi32:get-lang($source-context)}"
                                        ><xsl:value-of select="enoddi32:get-label($source-context)"
                                    /> questionnaire</r:Content>
                            </r:Label>
                            <d:TypeOfInstrument>A définir</d:TypeOfInstrument>
                            <d:ControlConstructReference>
                                <r:Agency>
                                    <xsl:value-of select="$agency"/>
                                </r:Agency>
                                <r:ID><xsl:value-of select="concat('Sequence-',enoddi32:get-id($source-context))"/></r:ID>
                                <r:Version>
                                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                                </r:Version>
                                <r:TypeOfObject>Sequence</r:TypeOfObject>
                            </d:ControlConstructReference>
                        </d:Instrument>
                    </d:InstrumentScheme>
                </d:DataCollection>
            </s:StudyUnit>
        </DDIInstance>
    </xsl:template>


    <!--    <xsl:template match="driver-InterviewerInstructionScheme//* | driver-CodeListScheme//* | driver-CategoryScheme//*" mode="model" priority="3">        
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>        
        <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
            <xsl:with-param name="driver" select="." tunnel="yes"/>
            <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
        </xsl:apply-templates>        
    </xsl:template>-->

    <xsl:template match="driver-InterviewerInstructionScheme//Instruction" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:Instruction>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <d:InstructionName>
                <r:String xml:lang="{enoddi32:get-lang($source-context)}">
                    <xsl:value-of select="enoddi32:get-name($source-context)"/>
                </r:String>
            </d:InstructionName>
            <d:InstructionText>
                <d:LiteralText>
                    <d:Text xml:lang="{enoddi32:get-lang($source-context)}">
                        <xsl:value-of select="enoddi32:get-text($source-context)"/>
                    </d:Text>
                </d:LiteralText>
            </d:InstructionText>
        </d:Instruction>
    </xsl:template>

    <xsl:template match="driver-InterviewerInstructionReference//*" mode="model" priority="2">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
    </xsl:template>


    <!--creation de la reference de l'InterviwerInstruction-->
    <xsl:template match="driver-InterviewerInstructionReference//Instruction" mode="model" priority="3">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:InterviewerInstructionReference>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:TypeOfObject>Instruction</r:TypeOfObject>
        </d:InterviewerInstructionReference>
    </xsl:template>

    <xsl:template match="driver-CodeListScheme//CodeList" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <l:CodeList>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:Label>
                <r:Content xml:lang="{enoddi32:get-lang($source-context)}">
                    <xsl:value-of select="enoddi32:get-label($source-context)"/>
                </r:Content>
            </r:Label>
            <!--TODO define HierarchyType-->
            <!-- Enumeration:            
            "Regular" A hierarchy where each section has the same number of nested levels, i.e., the lowest level represents the most discrete values.
            "Irregular" A hierarchy where each section can vary in the number of nested levels it contains. The most discrete objects in an irregular hierarchy must be individually identified.
            -->
            <l:HierarchyType>Regular</l:HierarchyType>
            <!--TODO : define levelNumber-->
            <l:Level levelNumber="0">
                <!--TODO : Enumeration:	
"Nominal" A relationship of less than, or greater than, cannot be established among the included categories. This type of relationship is also called categorical or discrete.
"Ordinal" The categories in the domain have a rank order.
"Interval" The categories in the domain are in rank order and have a consistent interval between each category so that differences between arbitrary pairs of measurements can be meaningfully compared.
"Ratio" The categories have all the features of interval measurement and also have meaningful ratios between arbitrary pairs of numbers.
"Continuous" May be used to identify both interval and ratio classification levels, when more precise information is not available.-->
                
                <l:CategoryRelationship>Nominal</l:CategoryRelationship>
            </l:Level>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver" select="." tunnel="yes"/>
            </xsl:apply-templates>
        </l:CodeList>
    </xsl:template>

    <xsl:template match="driver-CodeListScheme//Code" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <!--TODO : define levelNumber-->
        <l:Code levelNumber="0" isDiscrete="{enoddi32:is-discrete($source-context)}">
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:CategoryReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>CA-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>Category</r:TypeOfObject>
            </r:CategoryReference>
            <r:Value>
                <xsl:value-of select="enoddi32:get-value($source-context)"/>
            </r:Value>
        </l:Code>
    </xsl:template>

    <xsl:template match="Code" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <l:Code levelNumber="1" isDiscrete="true">
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:CategoryReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>CA-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
            </r:CategoryReference>
            <r:Value>Code.Value</r:Value>
        </l:Code>
    </xsl:template>

    <xsl:template match="driver-CategoryScheme//CodeList" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
            <xsl:with-param name="driver" select="." tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="driver-CategoryScheme//Code" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <l:Category>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>CA-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:Label>
                <r:Content xml:lang="{enoddi32:get-lang($source-context)}">
                    <xsl:value-of select="enoddi32:get-label($source-context)"/>
                </r:Content>
            </r:Label>
        </l:Category>
    </xsl:template>

    <xsl:template match="driver-ControlConstructScheme//Sequence" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:Sequence>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:Label>
                <r:Content xml:lang="{enoddi32:get-lang($source-context)}">
                    <xsl:value-of select="enoddi32:get-label($source-context)"/>
                </r:Content>
            </r:Label>
            <d:TypeOfSequence>
                <xsl:value-of select="enoddi32:get-sequence-type($source-context)"/>
            </d:TypeOfSequence>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver" select="." tunnel="yes"/>
            </xsl:apply-templates>
        </d:Sequence>
    </xsl:template>

    <xsl:template match="Sequence//Sequence" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:ControlConstructReference>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:TypeOfObject>Sequence</r:TypeOfObject>
        </d:ControlConstructReference>
    </xsl:template>

    <!-- <!-\-ne sert peut etre a rien-\->
    <xsl:template match="Sequence" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:ControlConstructReference>	
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:TypeOfObject>Sequence</r:TypeOfObject>
        </d:ControlConstructReference>	
    </xsl:template>-->

    <xsl:template match="driver-ControlConstructScheme//QuestionSimple" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:QuestionConstruct>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QC-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:QuestionReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>QI-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>QuestionItem</r:TypeOfObject>
            </r:QuestionReference>
        </d:QuestionConstruct>
    </xsl:template>

    <xsl:template match="driver-QuestionScheme//QuestionSimple" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:QuestionItem>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QI-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-OutParameter', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-Binding', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
            <d:QuestionText>
                <d:LiteralText>
                    <d:Text xml:lang="{enoddi32:get-lang($source-context)}">
                        <xsl:value-of select="enoddi32:get-label($source-context)"/>
                    </d:Text>
                </d:LiteralText>
            </d:QuestionText>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver" select="." tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-InterviewerInstructionReference', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
        </d:QuestionItem>
    </xsl:template>
    

    <xsl:template match="Sequence//QuestionSimple" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:ControlConstructReference>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QC-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:TypeOfObject>QuestionConstruct</r:TypeOfObject>
        </d:ControlConstructReference>
    </xsl:template>

    <xsl:template match="QuestionSimple//ResponseDomain" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
            <xsl:with-param name="driver" select="." tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="QuestionSimple//driver-OutParameter//*" mode="model" priority="2">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
    </xsl:template>
    
    <xsl:template match="QuestionSimple//driver-Binding//*" mode="model" priority="2">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
    </xsl:template>
    
    
    <xsl:template match="QuestionSimple//driver-OutParameter//ResponseDomain" mode="model" priority="3">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:OutParameter isArray="false">
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:ParameterName>
                <r:String xml:lang="{enoddi32:get-lang($source-context)}">A définir</r:String>
            </r:ParameterName>
        </r:OutParameter>
    </xsl:template>
    
    <xsl:template match="QuestionSimple//driver-Binding//ResponseDomain" mode="model" priority="3">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:Binding>
            <r:SourceParameterReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>OutParameter</r:TypeOfObject>
            </r:SourceParameterReference>
            <r:TargetParameterReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>QOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>OutParameter</r:TypeOfObject>
            </r:TargetParameterReference>
        </r:Binding>
    </xsl:template>
    
    
    
    


    <xsl:template match="driver-QuestionScheme//QuestionSingleChoice" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:QuestionItem>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QI-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>  
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-OutParameter', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-Binding', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
            <d:QuestionText>
                <d:LiteralText>
                    <d:Text xml:lang="{enoddi32:get-lang($source-context)}">
                        <xsl:value-of select="enoddi32:get-label($source-context)"/>
                    </d:Text>
                </d:LiteralText>
            </d:QuestionText>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver" select="." tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-InterviewerInstructionReference', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
        </d:QuestionItem>
    </xsl:template>

    <xsl:template match="driver-ControlConstructScheme//QuestionSingleChoice" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:QuestionConstruct>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QC-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:QuestionReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>QI-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>QuestionItem</r:TypeOfObject>
            </r:QuestionReference>
        </d:QuestionConstruct>
    </xsl:template>


    <xsl:template match="Sequence//QuestionSingleChoice" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:ControlConstructReference>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QC-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:TypeOfObject>QuestionConstruct</r:TypeOfObject>
        </d:ControlConstructReference>
    </xsl:template>

    
    <xsl:template match="QuestionSingleChoice//ResponseDomain" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:CodeDomain>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver" select="." tunnel="yes"/>
            </xsl:apply-templates>
            <r:OutParameter isArray="false">
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:CodeRepresentation>
                    <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                        <xsl:with-param name="driver"
                            select="eno:append-empty-element('driver-CodeListReference', .)"
                            tunnel="yes"/>
                        <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
                    </xsl:apply-templates>
                </r:CodeRepresentation>
            </r:OutParameter>
            <r:ResponseCardinality maximumResponses="1"/>
        </d:CodeDomain>
    </xsl:template>
    
    
    <xsl:template match="QuestionSingleChoice//driver-OutParameter//*" mode="model" priority="2">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
    </xsl:template>
    
    <xsl:template match="QuestionSingleChoice//driver-Binding//*" mode="model" priority="2">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
    </xsl:template>
    
    
    <xsl:template match="QuestionSingleChoice//driver-OutParameter//ResponseDomain" mode="model" priority="3">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:OutParameter isArray="false">
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:ParameterName>
                <r:String xml:lang="{enoddi32:get-lang($source-context)}">A définir</r:String>
            </r:ParameterName>
        </r:OutParameter>
    </xsl:template>
    
    <xsl:template match="QuestionSingleChoice//driver-Binding//ResponseDomain" mode="model" priority="3">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:Binding>
            <r:SourceParameterReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>OutParameter</r:TypeOfObject>
            </r:SourceParameterReference>
            <r:TargetParameterReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>QOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>OutParameter</r:TypeOfObject>
            </r:TargetParameterReference>
        </r:Binding>
    </xsl:template>
    

    <xsl:template name="CodeRepresentation_CodeListReference">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:CodeListReference>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:TypeOfObject>CodeList</r:TypeOfObject>
        </r:CodeListReference>
    </xsl:template>

    <xsl:template match="driver-QuestionScheme//QuestionMultipleChoice" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:QuestionGrid>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QI-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-OutParameter', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-Binding', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
            <d:QuestionText>
                <d:LiteralText>
                    <d:Text xml:lang="{enoddi32:get-lang($source-context)}">
                        <xsl:value-of select="enoddi32:get-label($source-context)"/>
                    </d:Text>
                </d:LiteralText>
            </d:QuestionText>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver" select="." tunnel="yes"/>
            </xsl:apply-templates>
            <d:StructuredMixedGridResponseDomain>
                <xsl:for-each select="eno:child-fields($source-context)[local-name() = 'Response']">
                    <d:GridResponseDomain>
                        <d:CodeDomain>
                            <r:OutParameter isArray="false">
                                <r:Agency>
                                    <xsl:value-of select="$agency"/>
                                </r:Agency>
                                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                                <r:Version>
                                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                                </r:Version>
                                <r:CodeRepresentation>
                                    <xsl:apply-templates select="eno:child-fields($source-context)"
                                        mode="source">
                                        <xsl:with-param name="driver"
                                            select="eno:append-empty-element('driver-CodeListReference', .)"
                                            tunnel="yes"/>
                                        <xsl:with-param name="agency" select="$agency"
                                            as="xs:string" tunnel="yes"/>
                                    </xsl:apply-templates>
                                </r:CodeRepresentation>
                            </r:OutParameter>
                            <r:ResponseCardinality maximumResponses="1"/>
                            <!--TODO : vérifier commentaire et si actif : redéfinir contexte-->
                            <!-- xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                                <xsl:with-param name="driver" select="." tunnel="yes"/>
                            </xsl:apply-templates-->
                        </d:CodeDomain>
                    </d:GridResponseDomain>
                </xsl:for-each>
            </d:StructuredMixedGridResponseDomain>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-InterviewerInstructionReference', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
        </d:QuestionGrid>
    </xsl:template>

    <xsl:template match="driver-ControlConstructScheme//QuestionMultipleChoice" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:QuestionConstruct>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QC-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:QuestionReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>QI-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>QuestionGrid</r:TypeOfObject>
            </r:QuestionReference>
        </d:QuestionConstruct>
    </xsl:template>


    <xsl:template match="Sequence//QuestionMultipleChoice" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:ControlConstructReference>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QC-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:TypeOfObject>QuestionConstruct</r:TypeOfObject>
        </d:ControlConstructReference>
    </xsl:template>
    
    <xsl:template match="QuestionMultipleChoice//driver-OutParameter//*" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
    </xsl:template>
    
    <xsl:template match="QuestionMultipleChoice//driver-Binding//*" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
    </xsl:template>

    
    <xsl:template match="QuestionMultipleChoice//driver-OutParameter//ResponseDomain" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:OutParameter isArray="false">
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:ParameterName>
                <r:String xml:lang="{enoddi32:get-lang($source-context)}">A définir</r:String>
            </r:ParameterName>
        </r:OutParameter>
    </xsl:template>
    
    <xsl:template match="QuestionMultipleChoice//driver-Binding//ResponseDomain" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:Binding>
            <r:SourceParameterReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>OutParameter</r:TypeOfObject>
            </r:SourceParameterReference>
            <r:TargetParameterReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>QOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>OutParameter</r:TypeOfObject>
            </r:TargetParameterReference>
        </r:Binding>
    </xsl:template>


    <xsl:template match="driver-QuestionScheme//QuestionTable" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:QuestionGrid>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QI-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-OutParameter', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-Binding', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
            <d:QuestionText>
                <d:LiteralText>
                    <d:Text xml:lang="{enoddi32:get-lang($source-context)}">
                        <xsl:value-of select="enoddi32:get-label($source-context)"/>
                    </d:Text>
                </d:LiteralText>
            </d:QuestionText>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver" select="." tunnel="yes"/>
            </xsl:apply-templates>
            <d:StructuredMixedGridResponseDomain>
                <xsl:for-each select="eno:child-fields($source-context)[local-name() = 'Response']">
                    <xsl:variable name="NResponse" select="position()"/>
                    <d:GridResponseDomain>
                        <d:CodeDomain>
                            <r:OutParameter isArray="false">
                                <r:Agency><xsl:value-of select="$agency"/></r:Agency>
                                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                                <r:Version><xsl:value-of select="enoddi32:get-version($source-context)"/></r:Version>
                                <r:CodeRepresentation>
                                    <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                                        <xsl:with-param name="driver"
                                            select="eno:append-empty-element('driver-CodeListReference', .)"
                                            tunnel="yes"/>
                                        <xsl:with-param name="agency" select="$agency"
                                            as="xs:string" tunnel="yes"/>
                                    </xsl:apply-templates>
                                </r:CodeRepresentation>
                            </r:OutParameter>
                            <r:ResponseCardinality maximumResponses="1"/>
                            <!--TODO vérifier commentaire-->
                            <!--xsl:apply-templates select="eno:child-fields($source-context)"
                                mode="source">
                                <xsl:with-param name="driver" select="." tunnel="yes"/>
                            </xsl:apply-templates-->
                        </d:CodeDomain>
                        <d:GridAttachment>
                            <d:CellCoordinatesAsDefined>
                                <d:SelectDimension rank="1" rangeMinimum="{$NResponse}"
                                    rangeMaximum="{$NResponse}"/>
                            </d:CellCoordinatesAsDefined>
                        </d:GridAttachment>
                    </d:GridResponseDomain>
                </xsl:for-each>
            </d:StructuredMixedGridResponseDomain>
            <xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
                <xsl:with-param name="driver"
                    select="eno:append-empty-element('driver-InterviewerInstructionReference', .)"
                    tunnel="yes"/>
                <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
        </d:QuestionGrid>
    </xsl:template>

    <xsl:template match="driver-ControlConstructScheme//QuestionTable" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:QuestionConstruct>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QC-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:QuestionReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>QI-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>QuestionGrid</r:TypeOfObject>
            </r:QuestionReference>
        </d:QuestionConstruct>
    </xsl:template>


    <xsl:template match="Sequence//QuestionTable" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:ControlConstructReference>
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QC-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:TypeOfObject>QuestionConstruct</r:TypeOfObject>
        </d:ControlConstructReference>
    </xsl:template>
    
    
    <xsl:template match="QuestionTable//driver-OutParameter//*" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
    </xsl:template>
    
    <xsl:template match="QuestionTable//driver-Binding//*" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
    </xsl:template>


    <xsl:template match="QuestionTable//driver-OutParameter//ResponseDomain" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:OutParameter isArray="false">
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>QOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:ParameterName>
                <r:String xml:lang="{enoddi32:get-lang($source-context)}">A définir</r:String>
            </r:ParameterName>
        </r:OutParameter>
    </xsl:template>
    
    <xsl:template match="QuestionTable//driver-Binding//ResponseDomain" mode="model" priority="1">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:Binding>
            <r:SourceParameterReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>OutParameter</r:TypeOfObject>
            </r:SourceParameterReference>
            <r:TargetParameterReference>
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>QOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TypeOfObject>OutParameter</r:TypeOfObject>
            </r:TargetParameterReference>
        </r:Binding>
    </xsl:template>

    <xsl:template match="driver-CodeListReference//*" mode="model"/>
    

    <xsl:template match="driver-CodeListReference//CodeListReference" mode="model" priority="2">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:CodeListReference>	
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID><xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
            <r:Version>
                <xsl:value-of select="enoddi32:get-version($source-context)"/>
            </r:Version>
            <r:TypeOfObject>CodeList</r:TypeOfObject>
        </r:CodeListReference>
    </xsl:template>

    <xsl:template match="Goto" mode="model"/>
    <xsl:template match="DataCollection" mode="model"/>
    <xsl:template match="ComponentGroup" mode="model"/>
    <xsl:template match="MemberReference" mode="model"/>

    <xsl:template match="TextDomain" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:TextDomain maxLength="{enoddi32:get-max-length($source-context)}">
            <r:OutParameter isArray="false">
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:TextRepresentation maxLength="{enoddi32:get-max-length($source-context)}"/>
            </r:OutParameter>
        </d:TextDomain>
    </xsl:template>

    <xsl:template match="NumericDomain" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:NumericDomain>
            <xsl:variable name="decimalPositions"
                select="enoddi32:get-decimal-positions($source-context)"/>
            <xsl:if test="number($decimalPositions) = number($decimalPositions)">
                <xsl:attribute name="decimalPositions" select="$decimalPositions"/>
            </xsl:if>
            <r:NumberRange>
                <r:Low isInclusive="true">
                    <xsl:value-of select="enoddi32:get-low($source-context)"/>
                </r:Low>
                <r:High isInclusive="true">
                    <xsl:value-of select="enoddi32:get-high($source-context)"/>
                </r:High>
            </r:NumberRange>
            <r:NumericTypeCode codeListID="INSEE-CIS-NTC-CV">Decimal</r:NumericTypeCode>
            <r:OutParameter isArray="false">
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
            </r:OutParameter>
        </d:NumericDomain>
    </xsl:template>

    <xsl:template match="DateTimeDomain" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:DateTimeDomain>
            <r:DateFieldFormat>jj/mm/aaaa</r:DateFieldFormat>
            <r:DateTypeCode codeListID="INSEE-DTC-CV">date</r:DateTypeCode>
            <r:OutParameter isArray="false">
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:DateTimeRepresentation>
                    <r:DateFieldFormat>jj/mm/aaaa</r:DateFieldFormat>
                    <r:DateTypeCode codeListID="INSEE-DTC-CV">date</r:DateTypeCode>
                </r:DateTimeRepresentation>
            </r:OutParameter>
        </d:DateTimeDomain>
    </xsl:template>

    <xsl:template match="BooleanDomain" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:NominalDomain>
            <r:GenericOutputFormat codeListID="INSEE-GOF-CV">checkbox</r:GenericOutputFormat>
            <r:OutParameter isArray="false">
                <r:Agency>
                    <xsl:value-of select="$agency"/>
                </r:Agency>
                <r:ID>RDOP-<xsl:value-of select="enoddi32:get-id($source-context)"/></r:ID>
                <r:Version>
                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                </r:Version>
                <r:CodeRepresentation>
                    <r:CodeSubsetInformation>
                        <r:IncludedCode>
                            <r:CodeReference>
                                <r:Agency>
                                    <xsl:value-of select="$agency"/>
                                </r:Agency>
                                <r:ID>INSEE-COMMUN-CL-Booleen-1</r:ID>
                                <r:Version>
                                    <xsl:value-of select="enoddi32:get-version($source-context)"/>
                                </r:Version>
                                <r:TypeOfObject>Code</r:TypeOfObject>
                            </r:CodeReference>
                        </r:IncludedCode>
                    </r:CodeSubsetInformation>
                </r:CodeRepresentation>
                <r:DefaultValue/>
            </r:OutParameter>
            <r:ResponseCardinality maximumResponses="1"/>
        </d:NominalDomain>

    </xsl:template>

    <xsl:template match="RadioDomain" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:GenericOutputFormat codeListID="INSEE'-GOF-CV'">radio-button</r:GenericOutputFormat>
    </xsl:template>

    <xsl:template match="CheckBoxDomain" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:GenericOutputFormat codeListID="INSEE'-GOF-CV'">checkbox</r:GenericOutputFormat>
    </xsl:template>

    <xsl:template match="DropDownListDomain" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <r:GenericOutputFormat codeListID="INSEE'-GOF-CV'">drop-down-list</r:GenericOutputFormat>
    </xsl:template>

    <xsl:template match="RosterDimension" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <!--TODO : find rank value-->
        <d:GridDimension>
            <xsl:attribute name="rank"><xsl:value-of select="1"/></xsl:attribute>
            <!--xsl:attribute name="displayCode"><xsl:value-of select=""/></xsl:attribute>
            <xsl:attribute name="displayLabel"><xsl:value-of select=""/></xsl:attribute-->
        <d:Roster baseCodeValue="1" codeIterationValue="1">
            <xsl:attribute name="minimumRequired">
                <xsl:value-of select="substring-before(enoddi32:get-dynamic($source-context), '-')"
                />
            </xsl:attribute>
            <xsl:attribute name="maximumAllowed">
                <xsl:value-of select="substring-after(enoddi32:get-dynamic($source-context), '-')"/>
            </xsl:attribute>
        </d:Roster>
        </d:GridDimension>
    </xsl:template>

    <xsl:template match="UnknownDimension" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>

    </xsl:template>

    <xsl:template match="CodeDomainDimension" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:CodeDomain>
            <xsl:copy-of select="./*"/>
        </d:CodeDomain>
    </xsl:template>


</xsl:stylesheet>
