<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="no"/>

<xsl:param name="transport_file" select="'default'"/>
<xsl:variable name="tport_filename"><xsl:value-of select='$transport_file'/></xsl:variable>

<xsl:template match="fix">
<xsl:text disable-output-escaping="yes">
/*
 * FieldDefs.h
 *
 *  AUTO-GENERATED file. Do not edit. 
 *      Author: Wei Liew (wei@onesixeightsolutions.com)
 *
 *  Copyright Wei Liew 2012 - 2014.
 *  Distributed under the Boost Software License, Version 1.0.
 *  (See http://www.boost.org/LICENSE_1_0.txt)
 *
 *  Note: This file is auto generated from the script genDefs.xslt. 
 *  Do not edit this file directly.
 */
 
#ifndef FIELDDEFS_H_
#define FIELDDEFS_H_

#include "utilities/StringConstant.h"

using namespace vf_common;

namespace vf_fix { namespace fix_defs {
    extern constexpr StringConstant BeginString("8=FIX.</xsl:text>
    <xsl:value-of select="@major"/><xsl:text disable-output-escaping="yes">.</xsl:text>
    <xsl:value-of select="@minor"/><xsl:text disable-output-escaping="yes">\0019=");
} } // vf_fix::fix_defs
        
#include "apps/fix_engine/static_dictionary/SFIXFields.h"
#include "apps/fix_engine/static_dictionary/SFIXGroups.h"
#include "apps/fix_engine/static_dictionary/SFIXCollections.h"
#include "apps/fix_engine/static_dictionary/SFIXMessages.h"

namespace vf_fix
{

namespace fix_defs
{
</xsl:text>
<xsl:apply-templates select="fields"/>
<xsl:choose>
<xsl:when test="$transport_file != 'default'">
    <xsl:apply-templates select="document($transport_file)/fix/header"/>
    <xsl:apply-templates select="document($transport_file)/fix/trailer"/>
    <xsl:apply-templates select="document($transport_file)/fix/messages"/>
</xsl:when>
<xsl:otherwise>
    <xsl:apply-templates select="header"/>
    <xsl:apply-templates select="trailer"/>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="messages"/>
<xsl:text disable-output-escaping="yes">
} // fix_defs

} // vf_fix

#endif /* FIELDDEFS_H_ */

</xsl:text>
</xsl:template>

<!-- create a key to use.. -->
<xsl:key name="keyFieldByType" match="//field" use="@type"/>
<xsl:key name="keyFieldByMsgType" match="//message" use="@msgtype"/>

<!-- fields -->
<xsl:template match="fields">
<xsl:text disable-output-escaping="yes">
namespace fieldNames
{</xsl:text>
<xsl:for-each select="field">
    extern constexpr StringConstant <xsl:value-of select="@name"/>_FID_STR("<xsl:value-of select="@number"/>=");
    extern constexpr StringConstant <xsl:value-of select="@name"/>("<xsl:value-of select="@name"/>");</xsl:for-each>
<xsl:text disable-output-escaping="yes">
} // fields

namespace fieldTypes
{</xsl:text>
<xsl:for-each select="//field[generate-id() = generate-id(key('keyFieldByType', @type)[1])]">
    extern constexpr StringConstant <xsl:value-of select="@type"/>("<xsl:value-of select="@type"/>");</xsl:for-each>
<xsl:text disable-output-escaping="yes">
} // fieldTypes
</xsl:text>
<xsl:text disable-output-escaping="yes">
namespace arrays
{
    StringConstantArr EmptyArray;
</xsl:text>    
<xsl:for-each select="field">
<xsl:if test="value">
    StringConstant ArrEnum_<xsl:value-of select="@number"/>[] = {<xsl:for-each select="value">
        StringConstant("<xsl:value-of select="@enum"/>")<xsl:if test="not(position()=last())">,</xsl:if>
</xsl:for-each>    
<xsl:text disable-output-escaping="yes">
    };</xsl:text>
    StringConstantArr StrArrEnum_<xsl:value-of select="@number"/>(ArrEnum_<xsl:value-of select="@number"/>);
    
    StringConstant ArrDesc_<xsl:value-of select="@number"/>[] = {<xsl:for-each select="value">
        StringConstant("<xsl:value-of select="@description"/>")<xsl:if test="not(position()=last())">,</xsl:if>
</xsl:for-each>    
<xsl:text disable-output-escaping="yes">
    };</xsl:text>
    StringConstantArr StrArrDesc_<xsl:value-of select="@number"/>(ArrDesc_<xsl:value-of select="@number"/>);
</xsl:if></xsl:for-each>
<xsl:text disable-output-escaping="yes">
} // arrays
</xsl:text>
<xsl:text disable-output-escaping="yes">
namespace fields
{</xsl:text>
<xsl:for-each select="field">
<xsl:if test="@type != 'NUMINGROUP'">
<xsl:text disable-output-escaping="yes">
    template&#60;typename Required = std::false_type, typename Validate = std::false_type&#62;</xsl:text>
    using SFIXField_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes"> = SFIXField&#60;</xsl:text>
        <xsl:value-of select="@number"/>, fieldNames::<xsl:value-of select="@name"/>_FID_STR, fieldNames::<xsl:value-of select="@name"/>, fieldTypes::<xsl:value-of select="@type"/>,<xsl:choose>
<xsl:when test="value"> arrays::StrArrEnum_<xsl:value-of select="@number"/>, arrays::StrArrDesc_<xsl:value-of select="@number"/>,</xsl:when>
<xsl:otherwise> arrays::EmptyArray, arrays::EmptyArray, </xsl:otherwise>
</xsl:choose><xsl:text disable-output-escaping="yes"> Required, Validate&#62;;
</xsl:text>
</xsl:if>
</xsl:for-each>                                    
<xsl:text disable-output-escaping="yes">} // fields
</xsl:text>
</xsl:template>

<!-- group deinition -->
<xsl:template match="group">
<xsl:apply-templates select="group"/>

<xsl:variable name="fieldname"><xsl:value-of select="@name"/></xsl:variable>
<xsl:variable name="groupfid" select="//fields/field[@name = $fieldname]/@number"/>

<xsl:text disable-output-escaping="yes">
        template&#60;typename Required = std::false_type, typename Validate = std::false_type, unsigned int Capacity = 50&#62;</xsl:text>
        using SFIXGroup_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes"> = SFIXGroup&#60;</xsl:text>
            <xsl:value-of select="$groupfid"/>, fieldNames::<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">, Required, Validate, Capacity
</xsl:text>
<xsl:for-each select="*">
<xsl:choose>
<xsl:when test="name() = 'field'">            , fields::SFIXField_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&#60;</xsl:text>
<xsl:choose>
<xsl:when test="@required = Y">std::true_type</xsl:when>
<xsl:otherwise>std::false_type</xsl:otherwise>
</xsl:choose>
<xsl:text disable-output-escaping="yes">, Validate&#62;
</xsl:text></xsl:when>
<xsl:when test="name() = 'group'">            , SFIXGroup_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&#60;</xsl:text>
<xsl:choose>
<xsl:when test="@required = Y">std::true_type</xsl:when>
<xsl:otherwise>std::false_type</xsl:otherwise>
</xsl:choose>
<xsl:text disable-output-escaping="yes">, Validate, Capacity&#62;
</xsl:text></xsl:when>
</xsl:choose>
</xsl:for-each>
<xsl:text disable-output-escaping="yes">            &#62;;
</xsl:text>
</xsl:template>

<!-- messages -->
<xsl:template match="messages">
<xsl:text disable-output-escaping="yes">
namespace messages
{
    namespace message_type
    {</xsl:text>
<xsl:for-each select="//message[generate-id() = generate-id(key('keyFieldByMsgType', @msgtype)[1])]">
        extern constexpr StringConstant msg_<xsl:value-of select="@msgtype"/>("<xsl:value-of select="@msgtype"/>");</xsl:for-each>
<xsl:for-each select="//message[generate-id() = generate-id(key('keyFieldByMsgType', @msgtype)[1])]">
        extern constexpr StringConstant msg_str_<xsl:value-of select="@msgtype"/>("\00135=<xsl:value-of select="@msgtype"/>\001");</xsl:for-each>
<xsl:text disable-output-escaping="yes">
    } // message_type
</xsl:text>

<xsl:for-each select="message">
<xsl:text disable-output-escaping="yes">
    namespace </xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">
    {</xsl:text>
        StringConstant <xsl:value-of select="@name"/>("<xsl:value-of select="@name"/>");
<!--create all groups -->
<xsl:apply-templates select="group"/>

<xsl:text disable-output-escaping="yes">
        template&#60;typename Validate = std::false_type, unsigned int Capacity = 50&#62;</xsl:text>
        using SFIXMessage_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes"> = SFIXMessage&#60;</xsl:text>
            <xsl:value-of select="@name"/>, message_type::msg_str_<xsl:value-of select="@msgtype"/>, Validate<xsl:text disable-output-escaping="yes">
            , header::SFIXMessageHeader&#60;Validate, Capacity&#62;
            , trailer::SFIXMessageTrailer&#60;Validate, Capacity&#62;
</xsl:text>
<xsl:for-each select="*">
<xsl:choose>
<xsl:when test="name() = 'field'">            , fields::SFIXField_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&#60;</xsl:text>
<xsl:choose>
<xsl:when test="@required = Y">std::true_type</xsl:when>
<xsl:otherwise>std::false_type</xsl:otherwise>
</xsl:choose>
<xsl:text disable-output-escaping="yes">, Validate&#62;
</xsl:text></xsl:when>
<xsl:when test="name() = 'group'">            , SFIXGroup_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&#60;</xsl:text>
<xsl:choose>
<xsl:when test="@required = Y">std::true_type</xsl:when>
<xsl:otherwise>std::false_type</xsl:otherwise>
</xsl:choose>
<xsl:text disable-output-escaping="yes">, Validate, Capacity&#62;
</xsl:text></xsl:when>
</xsl:choose>
</xsl:for-each><xsl:text disable-output-escaping="yes">&#62;;
    } 
</xsl:text>
</xsl:for-each>
<xsl:text disable-output-escaping="yes">
} // messages
</xsl:text>

</xsl:template>


<!-- header -->
<xsl:template match="header">
<xsl:text disable-output-escaping="yes">
namespace header
{</xsl:text>

<xsl:apply-templates select="group"/>

<xsl:text disable-output-escaping="yes">
        template&#60;typename Validate, unsigned int Capacity&#62;
        using SFIXMessageHeader = SFIXCollection&#60;Validate
</xsl:text>
<xsl:for-each select="*">
<xsl:choose>
<xsl:when test="name() = 'field' and @name != 'BeginString' and @name != 'BodyLength' and @name != 'MsgType'">            , fields::SFIXField_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&#60;</xsl:text>
<xsl:choose>
<xsl:when test="@required = 'Y'">std::true_type</xsl:when>
<xsl:otherwise>std::false_type</xsl:otherwise>
</xsl:choose>
<xsl:text disable-output-escaping="yes">, Validate&#62;
</xsl:text></xsl:when>
<xsl:when test="name() = 'group'">            , SFIXGroup_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&#60;</xsl:text>
<xsl:choose>
<xsl:when test="@required = 'Y'">std::true_type</xsl:when>
<xsl:otherwise>std::false_type</xsl:otherwise>
</xsl:choose>
<xsl:text disable-output-escaping="yes">, Validate, Capacity&#62;
</xsl:text></xsl:when>
</xsl:choose>
</xsl:for-each><xsl:text disable-output-escaping="yes">            &#62;;
} // header
</xsl:text>
</xsl:template>

<!-- trailer -->
<xsl:template match="trailer">
<xsl:text disable-output-escaping="yes">
namespace trailer
{</xsl:text>

<xsl:apply-templates select="group"/>

<xsl:text disable-output-escaping="yes">
        template&#60;typename Validate, unsigned int Capacity&#62;
        using SFIXMessageTrailer = SFIXCollection&#60;Validate
</xsl:text>
<xsl:for-each select="*">
<xsl:choose>
<xsl:when test="name() = 'field'">            , fields::SFIXField_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&#60;</xsl:text>
<xsl:choose>
<xsl:when test="@required = 'Y'">std::true_type</xsl:when>
<xsl:otherwise>std::false_type</xsl:otherwise>
</xsl:choose>
<xsl:text disable-output-escaping="yes">, Validate&#62;
</xsl:text></xsl:when>
<xsl:when test="name() = 'group'">            , SFIXGroup_<xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&#60;</xsl:text>
<xsl:choose>
<xsl:when test="@required = 'Y'">std::true_type</xsl:when>
<xsl:otherwise>std::false_type</xsl:otherwise>
</xsl:choose>
<xsl:text disable-output-escaping="yes">, Validate, Capacity&#62;
</xsl:text></xsl:when>
</xsl:choose>
</xsl:for-each><xsl:text disable-output-escaping="yes">            &#62;;
} // trailer
</xsl:text>
</xsl:template>

<!--TODO - validate groups and hdrs and trailers -->

</xsl:stylesheet> 

