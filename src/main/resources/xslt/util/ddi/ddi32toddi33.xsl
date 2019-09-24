<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:d32="ddi:datacollection:3_2" xmlns:r32="ddi:reusable:3_2" xmlns:l32="ddi:logicalproduct:3_2" xmlns:g32="ddi:group:3_2" xmlns:s32="ddi:studyunit:3_2"
    xmlns:d="ddi:datacollection:3_3" xmlns:r="ddi:reusable:3_3" xmlns:l="ddi:logicalproduct:3_3" xmlns:g="ddi:group:3_3" xmlns:s="ddi:studyunit:3_3"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs d32 r32 l32 g32 s32 xsl xd"
    version="2.0">

    <xsl:output indent="yes"/>
    <xd:doc>
        <xd:desc>root template : DDIInstance with DDI 3.3 namespaces</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <DDIInstance xmlns="ddi:instance:3_3"
            xmlns:d="ddi:datacollection:3_3" xmlns:r="ddi:reusable:3_3" xmlns:l="ddi:logicalproduct:3_3" xmlns:g="ddi:group:3_3" xmlns:s="ddi:studyunit:3_3"
            xmlns:a="ddi:archive:3_3" xmlns:pr="ddi:ddiprofile:3_3" xmlns:c="ddi:conceptualcomponent:3_3" xmlns:cm="ddi:comparative:3_3">
            <xsl:apply-templates select="*/*"/>
        </DDIInstance>
    </xsl:template>

    <xd:doc>
        <xd:desc>default template : keep the same</xd:desc>
    </xd:doc>
    <xsl:template match="@* | node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xd:doc>
        <xd:desc>DDI 3.2 namespaces to DDI 3.3 ones</xd:desc>
    </xd:doc>
    <xsl:template match="d32:*">
        <xsl:element name="d:{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="r32:*">
        <xsl:element name="r:{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="l32:*">
        <xsl:element name="l:{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="g32:*">
        <xsl:element name="g:{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="s32:*">
        <xsl:element name="s:{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xd:doc>
        <xd:desc>xhtml namespace keeps the same</xd:desc>
    </xd:doc>
    <xsl:template match="xhtml:*">
        <xsl:element name="xhtml:{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xd:doc>
        <xd:desc>real evolutions</xd:desc>
    </xd:doc>
    <xsl:template match="@codeListID">
        <xsl:attribute name="controlledVocabularyID">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xd:doc>
        <xd:desc>https://ddi-alliance.atlassian.net/projects/DDILIFE/issues/DDILIFE-3526</xd:desc>
    </xd:doc>
    <xsl:template match="d32:GridResponseDomain">
        <xsl:element name="d:GridResponseDomainInMixed">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xd:doc>
        <xd:desc>https://ddi-alliance.atlassian.net/projects/DDILIFE/issues/DDILIFE-3523</xd:desc>
    </xd:doc>
    <xsl:template match="d32:ComputationItem">
        <xsl:element name="d:ComputationItem">
            <xsl:apply-templates select="@*"/>
            <xsl:element name="d:TypeOfComputationItem">
                <xsl:value-of select="'informational'"/>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

    <xd:doc>
        <xd:desc>https://ddi-alliance.atlassian.net/projects/DDILIFE/issues/DDILIFE-3523</xd:desc>
    </xd:doc>
    <xsl:template match="d32:IfThenElse/d32:IfCondition">
        <xsl:element name="d:TypeOfIfThenElse">
            <xsl:choose>
                <xsl:when test="//d32:Sequence[r32:ID=current()/parent::d32:IfThenElse/d32:ThenConstructReference/r32:ID]/d32:TypeOfSequence='deactivatable'">
                    <xsl:value-of select="'greyedout'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'hideable'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="d:IfCondition">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="d32:CodeDomain">
        <xsl:element name="d:CodeDomain">
            <xsl:attribute name="displayCode" select="'false'"/>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xd:doc>
        <xd:desc>https://ddi-alliance.atlassian.net/browse/DDILIFE-3532</xd:desc>
    </xd:doc>
    <xsl:template match="l32:VariableRepresentation[r32:MeasurementUnit]">
        <xsl:variable name="QID" select="../r32:QuestionReference/r32:ID"/>
        <xsl:variable name="QOPID" select="../r32:SourceParameterReference/r32:ID"/>
        <xsl:variable name="RDOPID" select="//*[not(ends-with(name(),'Reference')) and r32:ID=$QID]/r32:Binding[r32:TargetParameterReference/r32:ID=$QOPID]/r32:SourceParameterReference/r32:ID"/>
        <xsl:variable name="domain" select="//*[not(ends-with(name(),'Reference')) and r32:ID=$QID]//*[(ends-with(name(),'Domain') or  ends-with(name(),'DomainReference')) and r32:OutParameter/r32:ID=$RDOPID]" as="node()"/>
        <xsl:variable name="domain-root">
            <xsl:choose>
                <xsl:when test="$domain/local-name()='NumericDomain'">
                    <xsl:value-of select="'d:NumericDomain'"/>
                </xsl:when>
                <xsl:when test="$domain/local-name()='NumericDomainReference'">
                    <xsl:value-of select="'r:NumericDomainReference'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'UNKNWON'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="l:VariableRepresentation">
            <xsl:element name="{$domain-root}">
                <xsl:apply-templates select="$domain/@*"/>
                <xsl:element name="r:MeasurementUnit">
                    <xsl:value-of select="r32:MeasurementUnit"/>
                </xsl:element>
                <xsl:apply-templates select="$domain/*[not(self::r32:OutParameter)]"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xd:doc>
        <xd:desc>Variables without representation : not new with DDI 3.3, but forgotten till now + evolution needed for MeasurementUnit</xd:desc>
        <xd:desc>Works only for collected variables</xd:desc>
    </xd:doc>
    <xsl:template match="l32:VariableRepresentation[not(*) and ../r32:SourceParameterReference]">
        <xsl:variable name="QID" select="../r32:QuestionReference/r32:ID"/>
        <xsl:variable name="QOPID" select="../r32:SourceParameterReference/r32:ID"/>
        <xsl:variable name="RDOPID" select="//*[not(ends-with(name(),'Reference')) and r32:ID=$QID]/r32:Binding[r32:TargetParameterReference/r32:ID=$QOPID]/r32:SourceParameterReference/r32:ID"/>
        <xsl:variable name="domain" select="//*[not(ends-with(name(),'Reference')) and r32:ID=$QID]//*[(ends-with(name(),'Domain') or  ends-with(name(),'DomainReference')) and r32:OutParameter/r32:ID=$RDOPID]" as="node()"/>
        <xsl:variable name="domain-root">
            <xsl:choose>
                <xsl:when test="ends-with($domain/local-name(),'Domain')">
                    <xsl:value-of select="concat('d:',$domain/local-name())"/>
                </xsl:when>
                <xsl:when test="ends-with($domain/local-name(),'DomainReference')">
                    <xsl:value-of select="concat('r:',$domain/local-name())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'UNKNWON'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="l:VariableRepresentation">
            <xsl:element name="{$domain-root}">
                <xsl:apply-templates select="$domain/@*"/>
                <xsl:apply-templates select="$domain/*[not(self::r32:OutParameter)]"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>https://ddi-alliance.atlassian.net/projects/DDILIFE/issues/DDILIFE-3590</xd:desc>
    </xd:doc>
    <xsl:template match="d32:ExternalAid[r32:Description]">
        <xsl:element name="d:ExternalAid">
            <xsl:element name="r:OtherMaterial">
                <xsl:apply-templates select="node()"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>