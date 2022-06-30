Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EDF5623F5
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 22:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiF3UMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 16:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbiF3UML (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 16:12:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2082.outbound.protection.outlook.com [40.107.100.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DFA43AF1;
        Thu, 30 Jun 2022 13:12:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLABfaSgzZRIXV4dpVJZjwyKxGHU7tcqdhE2A9oCDz4eUDetthJj+DHKOTPuR838rA3AGo4u9R7AMEoF3lLGdfeXmhRPvoLlJ+vuBh7SuAqr4xBIRHogoxH5Qohi9A2EPT1NPS+glwIuTBbLQpR66RaUx+EauhCpOGeeCBuU6Ho7/Rxm7ewoMbsJrTBiWQu64J48vs+/86i0uwWJqQIO96NC30Bf17jJ2VLrVTgD59Egv0fW7fr3O5+rMoHUpTy5IHkHR5XpIwveZZHU5D2zWxyfNMv/0P/x7JfRaiL2GY/rTykYfjyokoo4TVX4x9iCa56dCnL3FVW/Gxci0R5Izw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0pvbcrhJRj/HdBbfvYkg8C0cOF9QTewS86slFgHS4o=;
 b=jPG+6xGsLfEtiv4K9JNPCJCPBE0iY2MsdUtHig640rzsau7ce+PX36ugaVR6s/pcJjWunkL4ruIbUZiS93KpUaNyqz+7rRlBWOz9ly7ajo981JxXVMFICnmY7bXHL/NkLD9rYlzqcrimKfTCCDKXNjgUmXTc2m6HK+ykn9bT/T66aSmoBFs1NmE126EDt7NqR98D2OolaHnDCsn22vdr/v58vHExmPZm4u7YxgOAc//175mdGOXY/Y8tT+vK7PxZQ2NiieOAoDl52HLs/vVQP4J9ru3vWIOprvNCTvAIMLF1le5A1BTMO1zf2wuHxl8lZNt04DenGzzsrrqtEmJ8Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0pvbcrhJRj/HdBbfvYkg8C0cOF9QTewS86slFgHS4o=;
 b=0SK2QnIraKHfoJByFo348HqjLzXt/YLQATsiRzSJ1CIDT1jsJCEHsdy0m5G40b7/+AoUeRi537pZ32HD1BjlqM6KzgpFT4Hpkqzp1e8YWwAn0mn3O8hAKzpFOtBtdQJgtcelo2b/lYeU0J8anNHzmfwZsX93QpAfYcrap99QUok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB6470.namprd12.prod.outlook.com (2603:10b6:8:b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 30 Jun
 2022 20:12:09 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%5]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 20:12:08 +0000
Message-ID: <b84edc24-0a3a-a4d2-6481-fb3d4cee6dda@amd.com>
Date:   Thu, 30 Jun 2022 15:12:07 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5] ACPI: skip IRQ1 override on 3 Ryzen 6000 laptops
Content-Language: en-US
To:     Chuanhong Guo <gch981213@gmail.com>, linux-acpi@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Tighe Donnelly <tighe.donnelly@protonmail.com>,
        Kent Hou Man <knthmn0@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220630022317.15734-1-gch981213@gmail.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20220630022317.15734-1-gch981213@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0048.namprd20.prod.outlook.com
 (2603:10b6:208:235::17) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91ecb7f9-fc40-406e-f386-08da5ad4cf87
X-MS-TrafficTypeDiagnostic: DM4PR12MB6470:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5VadAJLt1GSOq+RFZ7uUezYsHbZDbo6rcEIB0q6zUXDYKAaSr5IGA+ZAssNS2qQJwOzkBWabzKyFp/2pd9JlBMOnCz9xx8/LnxTrbK+mtZyZITAa9aZd6KfGTiFdy+8uh2wLo+47QNL3K9hWoNJUPpPL0fsqnQ6MDDbTPJOgk3APUjeCqL/Exybf31WNPTXHji1j9otpvkjjNzpwXsiJJojUTYCtig9pjDvtTnxnkG2/IARw15f9sknBGblH20QoWcRomH/jh5Rt5L8Wl0DifieL3Ho/92ELBC8MSYRxbMfyRfn7RicTLW2rUfy+ggzHu6qF8aJNRa+r3rU7/9+lv1KfCbWQIkCG696KSDjQSuoeBkCczDEoe7/8fUjxs0bVRS/K+8H0qH85StB49twFwvcAw1EXi2AGmOCNF+/0TT7ZXo9YKFjAQhvQ6XFiYe5CA3x8zk3J6kp6sbsd2uvgB94Ytr8U/FcUHT5Mt5cjwRuV+MbodcOx3JStsPI5fpiKWqcr/wgoYrqADSNKmWBUsrDQVQAI+Cho3o05xtXHxzBAMDQAQIX0l0am3CvRw9LNHaToo103QCzzHAEAUVrhjTNnN35aAkNmIU52BYzFCmd3eijainftnXquzmUwgBwM/bli1TGDErFQdrCh4MuIzAPdhX4jxvUCQ76iXmix/yeyx6qtDwr+4VDneP5Ee1ze8wcsiVSjtwOpev40VltwZ/9AhAH7XbdZ5dIqXA8q17FDDVNOGeMdg7XGyLFFivOyuGVYYu29PC/pPyh78t2yzlB0oANIKdsyBVxrm2BG6Sfm6jRCBQxaq+djA3pp2QUbXuNphqKkYcAr2knFRmrdVovMoaW42HkEywwHXcDL2Ok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(396003)(376002)(366004)(86362001)(2616005)(8676002)(478600001)(26005)(66556008)(36756003)(8936002)(6486002)(38100700002)(53546011)(5660300002)(31686004)(31696002)(4326008)(6506007)(6512007)(66476007)(186003)(54906003)(2906002)(66946007)(41300700001)(83380400001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3NGbGtlalNidm1nQ0JLeUc1NkZJRUVHUDRQUGsyU1pDOWlGY1IvVUVPQVNG?=
 =?utf-8?B?dGxSZ1IvbWEvRkxhd1UxRk1qRWNST0psVndreXM0WWoyd1JrM1U0b05reHBY?=
 =?utf-8?B?OEdoTXdJc1NtTllZWDl0WWJOeTBuazMvV0d0U2IzM2ZtR0oxWmc1cHhXT1NG?=
 =?utf-8?B?ZGJsSVFSRW03dDRycWFrbjY2dzVNN0Nmd3dweTdhZThWOUd5L0F3U1VvS0V1?=
 =?utf-8?B?bGMxbGN3WFFmWWhEWm9CY3g2SzV6U1psaUtJNFpLUy9uMGQvZEk2dmprV1d0?=
 =?utf-8?B?SGx4dktkM2hTbWRWZFAyY1FUM2FaSGFPa0Z3NXZLK0pUeWdTZTdVZTVZeS9R?=
 =?utf-8?B?QmIzNW9MK0lnQ0U1OW9qK0JOVXZybjYxT0FBYnFtZ3hFM1haN3FoMXltalVp?=
 =?utf-8?B?ZkFsWVJKM0huLzVPMGNKdlNPdTJGZllVaGlzRkxIOVFJa0lwdE4vSTlXR0p0?=
 =?utf-8?B?cVlWSW9wNkFnQUdtZXkyV2FaeDhzRnNtUWpjL25MOVBRN1FScnFxd1JRZ2tz?=
 =?utf-8?B?MHhISEo2OCthZmlSSUw3M3RMaDIyRzlJRGg5S0dMWnh2emlyakZwMlYyenhi?=
 =?utf-8?B?VXhSM1h5ZTVTVVZESlVXS0V6MVlQOGgvZ3Nzd3lRbjhEQWtPNlRkb0VGQkph?=
 =?utf-8?B?K1BEcEo5U2doVG9VTXV0QnZvWXJsRGE1NU81YUhCUFVTZVdTc3NJL2xySDBx?=
 =?utf-8?B?WXMrYnNUUTFCMU92YlQrczVWelFDVUl5UnFISUpuZHZSOGNMU0NyQTFUaDdM?=
 =?utf-8?B?amJLUkRFV0t2bHZKZWJMS3VPQ3JWcjJjcDg3Si9MMURwQXNUYzlPcjErT0RS?=
 =?utf-8?B?U3lQazJvb1JueFQ3NHE0aFRTemI5SVhaUVJIaUI5WnN2SjdNWVRkVlBTZ1Fl?=
 =?utf-8?B?U1VsZW40TGlnUFYyUjRrZkJubzlyZUZLUVNyT1drRjNsNXNlODNnRjlrWHVC?=
 =?utf-8?B?Z1puNXhLbk1RcmFNcVpZejU0SG1ZTmtteHA3NVZTWTluV0tyUHpoY0ltN2U1?=
 =?utf-8?B?NjdNUUF0RXJKZ2FXWHJpc1B1bE5pczRFdnpmK2svekJ5YWZra1ZXR3cxdS9V?=
 =?utf-8?B?Vk53NVV5T0hXZFJkazlMOEtXZjk0UDZOMXNlc1JnOG1tQ1JTM3Fjak9USU1K?=
 =?utf-8?B?a0l5MWhRSWl2Sk5rdE0xQlJzOFRvY0NOaEcxVkVFc2VhY1h5eFl6MHZvazVs?=
 =?utf-8?B?ZEYyOUZsclU5dDdBYkU2a293TzNFdXFmakZWSjRGczJqeHY1MGZWRVZjUHQr?=
 =?utf-8?B?NTRXS0UwOFRmMFJlRzVPMVJzaGxVQ0RRb0pPS29tZjZSWHNMU3NjOHFnZS9H?=
 =?utf-8?B?MjdoNHNFYU04S2FTbmg5QTUrSFU2bnF2TDJ0OHg0ZE5iOW9DcFE3a3h2cmhh?=
 =?utf-8?B?SUdWOGppNDRrZVhDaUMyVkFIdFZOaGc0YTNaTWR3VFIrUCttTWxEUTlwa3Nk?=
 =?utf-8?B?U2hwdDVNMjQ0L0p5U05CM0NJRDZydW0wMCtCcllDQ1dWL0ZUZ0Jwb0R1d2Zw?=
 =?utf-8?B?bUZNeHQzeTIzZDBmTEU5K0FINDJFMkJVdjA2aDBJUXFkb2xZc0xLWVZWUFZq?=
 =?utf-8?B?aGhLTlJKUWZaaWxoUzJ2M3h3UFNhUjhsUEEyMDYrc0lHQWgzNnFKNGhwUjNB?=
 =?utf-8?B?aWRORk1CMDBOZU9JaEovOENqTFlVWStWd1I3Qk05VEZXS3dyUFFieENsbHl6?=
 =?utf-8?B?V1BJU0cvNXdlSTlUcHZ2aTdZYjVxdlVWOVFQeitZVjJKZkpYaTFMWnN1ekxD?=
 =?utf-8?B?UHlSZjJkWEFTVGxkNXZCeEpBYmNrb1dSNVU1dWMxWnVqZmJQZHdKYzhBcXNU?=
 =?utf-8?B?eVkrRkUxcFBwNnE1ZWpUNUZyYkxPV2RRKzZKOEpqV2NGdlNYelpDcG1rbm9B?=
 =?utf-8?B?VHFRdmRodkZ1cGhjRzdWRGhNTk9lMlhXbzVCOWsvd1FQWVk3cVBEMVZReUVY?=
 =?utf-8?B?TEkzNXVMcTdXRFJWV0FKYXpsZTBjRGFmL3hGZEZYNmFYaG1peXp6WkFLSlFX?=
 =?utf-8?B?aGYySTVPZ1ZPM3loaGdodzZGNklPUWk1cS9MdTh2alhBYmpuQll3aWRJRjVv?=
 =?utf-8?B?bVMzb1hVaWVoWEFLY3pqOG95ZGhqTkRGcExSLzBydE5raTJ1dzZPbFl6cTAr?=
 =?utf-8?Q?D8XYCBz2F1gkuBiUiAgPoqQ8K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ecb7f9-fc40-406e-f386-08da5ad4cf87
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 20:12:08.8800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3s/s/xqTxgcpIhe8+hItZZ/AtwhduBs9AP4F289RRcCtnAvJlYdROYOwfiLyvNXj1R0p0vezw9YyFkjdmDdLZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6470
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/29/2022 21:23, Chuanhong Guo wrote:
> The IRQ1 of these laptops with Ryzen 6000 and Insyde UEFI are active
> low and defined in legacy format in ACPI DSDT. The kernel override
> makes the keyboard interrupt polarity inverted, resulting in
> non-functional keyboard.
> 
> Skip legacy IRQ override for:
> Lenovo ThinkBook 14G4+ ARA
> Redmi Book Pro 15 2022 Ryzen
> Asus Zenbook S 13 OLED UM5302

It's really unfortunate that these laptops have the bug.  This was found 
and fixed in the reference BIOS for Ryzen 6000 too (via an MADT override 
service) very early in development.  It seems these manufacturers didn't 
pick up (or ignored) the solution.

However I do want to point out that Windows doesn't care about legacy 
format or not.  This bug where keyboard doesn't work only popped up on 
Linux.

Given the number of systems with the bug is appearing to grow I wonder 
if the right answer is actually a new heuristic that doesn't apply the 
kernel override for polarity inversion anymore.  Maybe if the system is 
2022 or newer?  Or on the ACPI version?

> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Tighe Donnelly <tighe.donnelly@protonmail.com>
> Signed-off-by: Kent Hou Man <knthmn0@gmail.com>
> Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
> ---
> Changes since v1:
>   Match DMI_PRODUCT_NAME for ThinkBook because the board name
>   is used for other completely different Lenovo laptops.
>   Add a patch for RedmiBook
> 
> Changes since v2:
>   Fix alphabetical order in skip_override_table
>   Add a patch for Asus Zenbook
> 
> Changes since v3:
>   Merge patches as requested
>   Fix another alphabetical ordering between two structs
> 
> Changes since v4:
>   rename the ident in RedmiBook entry.
>    There's also an Intel version of this series, so
>    rename it to make it specific.
>   reword commit title
> 
>   drivers/acpi/resource.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+) >
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index c2d494784425..0491da180fc5 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -381,6 +381,31 @@ unsigned int acpi_dev_get_irq_type(int triggering, int polarity)
>   }
>   EXPORT_SYMBOL_GPL(acpi_dev_get_irq_type);
>   
> +static const struct dmi_system_id irq1_edge_low_shared[] = {
> +	{
> +		.ident = "Asus Zenbook S 13 OLED UM5302",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +			DMI_MATCH(DMI_BOARD_NAME, "UM5302TA"),
> +		},
> +	},
> +	{
> +		.ident = "Lenovo ThinkBook 14 G4+ ARA",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
> +		},
> +	},
> +	{
> +		.ident = "Redmi Book Pro 15 2022 Ryzen",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "TIMI"),
> +			DMI_MATCH(DMI_BOARD_NAME, "TM2113"),
> +		},
> +	},
> +	{ }
> +};
> +
>   static const struct dmi_system_id medion_laptop[] = {
>   	{
>   		.ident = "MEDION P15651",
> @@ -408,6 +433,7 @@ struct irq_override_cmp {
>   };
>   
>   static const struct irq_override_cmp skip_override_table[] = {
> +	{ irq1_edge_low_shared, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1 },
>   	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
>   };
>   

