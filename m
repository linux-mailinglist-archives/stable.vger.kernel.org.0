Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941265E7F49
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 18:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiIWQIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 12:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiIWQIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 12:08:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D2FE4DA0;
        Fri, 23 Sep 2022 09:08:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7+0RZOfGEukyU+/G5U2xpEnXkeLBxQ0oKOfEyWidfWYP8uCA1C2b62JPYo2tnJk6S4e2fopHjJN2wUl028zSNFj6mzZJ/pQAfFY9mqQ9yw7XllxWPssCT+LpvpZhophvNOafjS9T0nHKYGstsFVxYhJeoaN+MOG2O/v4JFAhW/nYO/wrXC+cum1Momgvl8HHrpPdSUZSa1r3C8exxrzXQGY6StmNbu32QZCPeoqIJamKTmVLb9bLRfW6oDDmHtnJwlE85XJf1YcJXlKq6ZWGtU97iPmMfiZc3c3TKyz2ijKY0j11y6B5r1qkAwxuhR4WT6HdjgHuc14msdd3MgWYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/HktOpkO6ahHiNqZEDKK0MbByOdxoEWGS0EYr4Gcts=;
 b=aGBC5ypb1Gm6HRbm24O5Fhy/SUxDna2WQQc1lUgOrwzHdWvcu3rO/rPuFlvzDJxs6T9KETzenqjLXmxjjoC2YAhUKlmAQh66DOkSoWSuyPhgobB++mMYeDNhBWx/ksoUMMVosmCSt7QnL8qucKT3wYzPe9Wb99R5D55CZ9ngzbnqRoEU27sKamjTRakSWGUcFDXDhM6eR+1osrynILXC+GVX+TyiomyHWhYvhuG0JkZBBnzXLINH8kYCzPEbr/N5qvrCpI+PTQ+0ufyYubWEL+56YKbXwu+oUwEFJw8IgYu7PBcZGsumH1nf5syA4B4MhRzvc7e3/bVEAUeLA4LXYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/HktOpkO6ahHiNqZEDKK0MbByOdxoEWGS0EYr4Gcts=;
 b=1peswC+novullwt3zQUdhIkAU9d9DP9esFSirOZoQ8XWQA52QLNtF+mdxpcrZBrqkYlgfifCa1ZUk+qNn6L8nfqSB0IrMLxN/UIBbRSqM5CX+XA/0XLmgwbS05yZa9PQ0Nvs73oQ6nLLPZ9hIu2yx0mhIms772lfKRMXNlZ/Rgs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 16:08:32 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%7]) with mapi id 15.20.5654.017; Fri, 23 Sep 2022
 16:08:32 +0000
Message-ID: <7c0623f8-5274-c7ee-71a7-3e0fab918f97@amd.com>
Date:   Fri, 23 Sep 2022 11:08:30 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v2] thunderbolt: Explicitly enable lane adapter hotplug
 events at startup
Content-Language: en-US
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mehta Sanju <Sanju.Mehta@amd.com>, stable@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220922160730.898-1-mario.limonciello@amd.com>
 <Yy15gKzHyMcitY/N@black.fi.intel.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <Yy15gKzHyMcitY/N@black.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0316.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::21) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|DM6PR12MB4042:EE_
X-MS-Office365-Filtering-Correlation-Id: bced7454-1bf3-4140-5d70-08da9d7ddca7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NdZ0M/BBJZFBUvggbxJ73RcLkG7bKTWZCmeyCyWOaowWTvorXPwrn/4mojNdsg8MZr0qZWWKwiqUXad2cHkXc3R+nPfM2V5Hdqc3xLIAOWxiU+/hvxICl7Fx2CIBJ21FTS/8QrNs/Ony17tnNBaJbCTUyOz0dwU1FDCylwLJfFNjIqo0iFWxXvW3WQ+6zrGio4BVLwu+gkltArzLHxYlUu/iVRC277xo0Qg38E0WDyG1C3o8qt67xsqmjm5RY4MV7KKp6qiBi9s1iOdYxKD/mS4FE0FA5nRRlFlUni/99AdsBeljeLKgn4BcrSsj0ksRkgppxv9NmkidMBqokMNH9GAPDVM1pURXn44YjnL0gYTixBGNrZ3PDzSEBtHAvvpP4dwDjPBvH/YO/qMvR/c36F/X91dePR1AQJoHkAYuAD7/tHUqXlr9OKTyzxXdU9Uja4XJ/SoF7zlviM+R2MX1QQ/9/Oqt7M4OL7iEYWxlBXEN6X0RNH2DbtS6r+sK5INYJ+ff6nn8sqGyjMjcxQ0VVtiik762B4dEbW2BQ6xqWrXXCVZE1q+LI9cBMeLKvaR1R6fLGNW7+RG03WjAlwc68guBV8jFwsVYFr9z6vzYncCXDNu+Oyt/FoQbiNPX/WnqjUPQkTJ+u0rz+gmPRaP/5zR1s7zbUMfEWaoWPx9TYDgv1Pdggl75N83O3DfFsqcGxj2UXQhA7ZyEpRS5tX4ieF1zaPWVK7Ruor4i75ehA6cgGJXlcaTtBbRrOMxKhHJT+MLLPGw6InIZTf+cf4JyGYmYKbEJBfSHEOkt6BM60CU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199015)(6512007)(26005)(6916009)(2906002)(36756003)(6506007)(54906003)(53546011)(2616005)(31696002)(86362001)(186003)(66946007)(4326008)(66556008)(66476007)(83380400001)(316002)(41300700001)(8676002)(8936002)(5660300002)(38100700002)(478600001)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXVnRDZKMFhYTWt3SkNTMjFNWWY2b3ptZTMvbGdOb1AyNUUzT3c4cXFHNTQ5?=
 =?utf-8?B?NWs0UldUcVdrWmdWMU0yNjNlK1kxUWFPU3JnRGhkbkRGT0R5V0hMWXVGTFhK?=
 =?utf-8?B?eVBDOGcraXZ6OGhPcGNuR3k4ZG1oOGlwYzViNC9kOXZLZkxmRGFoWFRzdmk4?=
 =?utf-8?B?MmlQeklidC9VNk96aVF5VmZKbVF2Wisva00vNVJMMld2S1NsdGtjQkw2UUgv?=
 =?utf-8?B?N0FiQWwyTmRoNStGRWM4U0cxeldpd1RNN2t5czhuTlVDZDNZUExCdnB1eVE0?=
 =?utf-8?B?OVQ4MjF0R3M2U2RwU3ZEaVIxVXRBanYxN3lhMVNyMHdydk95WndpZlM4UE0r?=
 =?utf-8?B?NkNEcTJhbWZXM1BHT1J6MEs1YmxMSW9XMkRPeGhKMGdRNDZ1M3d1RDBwR1da?=
 =?utf-8?B?SzA2Z0o5eEhyc0NvT3ZLR1RNaTZvdzJ3R3FQbDBZcUs1eDlMZVZCcmlNQlM3?=
 =?utf-8?B?Z3luZHVQcDJYdnoyVVRGNEpOVXlzZTZtd3JiNWNVNVNWSVhMMG1YVDlnRzc5?=
 =?utf-8?B?OWpsWjQ2OWxvem5OVC9ZY3JSWFFqRHVkWnBvNVYxUjZVOXpFdUUyak9ITkVY?=
 =?utf-8?B?S1pJMW81WTRJZk1zbkhXYS9ITnlJTUIwR0RNbWpiWEVBYXlZYkRTTTBROUhi?=
 =?utf-8?B?TWNNWFBJQnc3QzBhWTkxYUY0SEVrTnpCVnFERllhdEVPckpRd2FTR2JqYjNq?=
 =?utf-8?B?UnkrTXBJRjFyekdPMzJreTMxUzdHcFdGYkt6ZUJ5aEtVdkY2dUZEUWUyUm9Z?=
 =?utf-8?B?K28ycUxta1ZyMWh3cFZ2U21sS2dYWkZESWtIRXNBZkllOExPUllsZGhrZXF6?=
 =?utf-8?B?NlpWMWdHMmdSOFhjcjVudlRFN1E4TDl1UmF1YXhLVVE5amFoZU45SDVoN2Yy?=
 =?utf-8?B?akx5RWQ4Tnpld2tLRDJhMFJxc01OT2pMYzdzMHBWcVN6MmJpK1lVbzgyUWU2?=
 =?utf-8?B?R0ludGFOSlAvUFlKSm9OVmZPUTByejc2bHdxRGRteWtVeG90QUlHbXhrTndC?=
 =?utf-8?B?SkE2aStrRGJlamV3bFh6SXdvOGhrdkNtbWQ0ckRKREZVY1NodEJzbStpRFA2?=
 =?utf-8?B?UkRSUTdlVDgvU0ZTRXNheUZJOWpDd3RhaFdNV0Y3VDAzZEI2b2F5N0Jpemhx?=
 =?utf-8?B?c01BekNOY3JwajhPZWwrMno5Qkl0ditTZGlRcGZBRW9kT25tTkJMVHVva2ly?=
 =?utf-8?B?aE5oTUcxeVdHbWhPQWRnMEhpSXVtall5SURIaUZBa2R2TStHTzlWd2NHVFNk?=
 =?utf-8?B?MjZxWnNSbFg0aG1rUE9oclF6YjkrTU5MRTJ0UEZTamJjREZuV1U2L3A1Q1Iz?=
 =?utf-8?B?dGpRL2lzQnBJOVEvVGJVM2dpcy9YVFl5Yy8xM2xvM2FVaGliME1vMDl2aDlB?=
 =?utf-8?B?cXNLNnJEM0dSelU3Q3V0QzEzdXZoa1Z4TnZEbkdMNDZvRmVrMVZDaXBZL3FO?=
 =?utf-8?B?S1VlVE04b29JaXhOOWM4cEZ3czNnelVrLzZ5a2pRUXN3cWFrbFhlRGYyNUE3?=
 =?utf-8?B?TXJxajZtcEUvQXQwaTd2M0FYOXRPY2MvUHZtbWpuMy8vSjIyc2hwTEF3NkYy?=
 =?utf-8?B?QXRjbHRkeXMvcTVNcmg3VGxYekI5MDJLZjF2UE8vQkljaGQ5UXBxWjNhZDBS?=
 =?utf-8?B?ZUliaHJuQ3RvRVNyTXUyWC9NSFhFVjA5YUxCRGpkRjRVN0tldkxzSmQ3SDY0?=
 =?utf-8?B?cHBEd2F3MTBSQlRWRk5TalFaamUwOGY5aDhnTDFIOUJURWZuQ0duSmtUWlhV?=
 =?utf-8?B?dEhOV3Rmc1JwdEViRE9Eb2taLzBDdnMwMS9tUzNDVzJIek1pQlEzSlhpS0h2?=
 =?utf-8?B?R01YYllBYm9KZXpNM3FPN3l5ckJpMmJMSms0QWF5TGx3clZjZzNTakN2SGww?=
 =?utf-8?B?RzNhaHBNVzM1SC9LaW16akw1Y2o4SVZFeTMyOThRRFFSTkRka3dOSHA2SEtM?=
 =?utf-8?B?eGpybkdOTDAvdVhwV3hkWUNLNkxDd0JzMllsQ0JpTVhjalVEb1IySVN3NUxL?=
 =?utf-8?B?SGl5aDI5dE5NczVJYVN3bDh2NCtPeVRIL3MwanovOXN1U1FSY1UyTFJSYXBL?=
 =?utf-8?B?ZXZubks1R2xSQmUwZFdPYkd4VVBiMDd3M1BJb0hCSW9TS0k2S3h4Ym1Jc2lR?=
 =?utf-8?Q?7SC43u8vl3LiqjLWSq1ENfnPI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bced7454-1bf3-4140-5d70-08da9d7ddca7
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:08:32.6181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9G6rVn8wbz44/DiLVRjAyAXJFBke8FdiGQtRLWWRH8fXgv2OavXmNgtI7Acu/geTj+OUff6x3Y74I9V5flBm2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/23/2022 04:16, Mika Westerberg wrote:
> Hi Mario,
> 
> On Thu, Sep 22, 2022 at 11:07:29AM -0500, Mario Limonciello wrote:
>> Software that has run before the USB4 CM in Linux runs may have disabled
>> hotplug events for a given lane adapter.
>>
>> Other CMs such as that one distributed with Windows 11 will enable hotplug
>> events. Do the same thing in the Linux CM which fixes hotplug events on
>> "AMD Pink Sardine".
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>> v1->v2:
>>   * Only send second patch as first was merged already
>>   * s/usb4_enable_hotplug/usb4_port_hotplug_enable/
>>   * Clarify intended users in documentation comment
>>   * Only call for lane adapters
>>   * Add stable tag
>>
>>   drivers/thunderbolt/switch.c  |  4 ++++
>>   drivers/thunderbolt/tb.h      |  1 +
>>   drivers/thunderbolt/tb_regs.h |  1 +
>>   drivers/thunderbolt/usb4.c    | 20 ++++++++++++++++++++
>>   4 files changed, 26 insertions(+)
>>
>> diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
>> index 77d7f07ca075..3213239d12c8 100644
>> --- a/drivers/thunderbolt/switch.c
>> +++ b/drivers/thunderbolt/switch.c
>> @@ -778,6 +778,10 @@ static int tb_init_port(struct tb_port *port)
>>   
>>   			if (!tb_port_read(port, &hop, TB_CFG_HOPS, 0, 2))
>>   				port->ctl_credits = hop.initial_credits;
>> +
>> +			res = usb4_port_hotplug_enable(port);
>> +			if (res)
> 
> I think this does not belong here in tb_init_port(). This is called from
> both FW and SW CM paths and we don't want to confuse the FW CM more than
> necessary ;-)
> 
> So instead I think this should be added to tb_plug_events_active().
> 

The problem with that location is that tb_plug_events_active() is called 
from tb_switch_configure() which is before tb_switch_add() is called.
tb_switch_add() calls tb_init_port() which reads port->config for the 
first time.

So if this is only to be called in tb_switch_configure() it means 
reading port->config "earlier" too.

So it definitely needs to be called in tb_init_port() or a later 
function but before the device is announced to satisfy only running on 
the appropriate port types.

tb_init_port() or tb_switch_add feels like the right place to me.  How 
about leaving it where it is but guarding with a "if 
(!tb_switch_is_icm())" to avoid the risk to the FW CM case?

> Otherwise looks good to me.
> 
>> +				return res;
>>   		}
>>   		if (!port->ctl_credits)
>>   			port->ctl_credits = 2;
>> diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
>> index 5db76de40cc1..332159f984fc 100644
>> --- a/drivers/thunderbolt/tb.h
>> +++ b/drivers/thunderbolt/tb.h
>> @@ -1174,6 +1174,7 @@ int usb4_switch_add_ports(struct tb_switch *sw);
>>   void usb4_switch_remove_ports(struct tb_switch *sw);
>>   
>>   int usb4_port_unlock(struct tb_port *port);
>> +int usb4_port_hotplug_enable(struct tb_port *port);
>>   int usb4_port_configure(struct tb_port *port);
>>   void usb4_port_unconfigure(struct tb_port *port);
>>   int usb4_port_configure_xdomain(struct tb_port *port);
>> diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
>> index 166054110388..bbe38b2d9057 100644
>> --- a/drivers/thunderbolt/tb_regs.h
>> +++ b/drivers/thunderbolt/tb_regs.h
>> @@ -308,6 +308,7 @@ struct tb_regs_port_header {
>>   #define ADP_CS_5				0x05
>>   #define ADP_CS_5_LCA_MASK			GENMASK(28, 22)
>>   #define ADP_CS_5_LCA_SHIFT			22
>> +#define ADP_CS_5_DHP				BIT(31)
>>   
>>   /* TMU adapter registers */
>>   #define TMU_ADP_CS_3				0x03
>> diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
>> index 3a2e7126db9d..f0b5a8f1ed3a 100644
>> --- a/drivers/thunderbolt/usb4.c
>> +++ b/drivers/thunderbolt/usb4.c
>> @@ -1046,6 +1046,26 @@ int usb4_port_unlock(struct tb_port *port)
>>   	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_4, 1);
>>   }
>>   
>> +/**
>> + * usb4_port_hotplug_enable() - Enables hotplug for a port
>> + * @port: USB4 port to operate on
>> + *
>> + * Enables hot plug events on a given port. This is only intended
>> + * to be used on lane, DP-IN, and DP-OUT adapters.
>> + */
>> +int usb4_port_hotplug_enable(struct tb_port *port)
>> +{
>> +	int ret;
>> +	u32 val;
>> +
>> +	ret = tb_port_read(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	val &= ~ADP_CS_5_DHP;
>> +	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
>> +}
>> +
>>   static int usb4_port_set_configured(struct tb_port *port, bool configured)
>>   {
>>   	int ret;
>> -- 
>> 2.34.1

