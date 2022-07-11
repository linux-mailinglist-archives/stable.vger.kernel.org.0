Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C09570D75
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 00:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiGKWhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 18:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiGKWhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 18:37:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7964AD70
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 15:37:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFp+4KLvl+OZxZlTUDTR1MWGlN76+362iCzFimSoCGhIjaUSfgaRgL1vR1EumZ++5pe4a18Flf6jYdAjFiS//oY4sWZJ55WvCZwjG2V2MEkrlTaQPimpyg1SAY7Pj3mL56h/mauIbsSe398XtYmAcbvsvZ+qYE0a2hhGz1TC4iN2DHN6P88WrZ2tP3nDPIjydHr1rJ9wat3I2UCf+3HuYQRn/uw65SqD2UBTkq9mTXnxDMtzOY7T6WImgBN4WcW5QDgQGeIyqKSWs7wpfg80UQJHrBfLj6auEw22DtGK0maUUtWCTBWNQDm3CLMJX8PtBS1fmAlkPFz/i2yBo6dG9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBKRNcLVeYJHnn9tuz4vudYtodcPUVM4nRy50725zDA=;
 b=I3jmMMZP1wx8eRJZU2M3JG3k91wxosV/g0PQFqtDjgv9mKRJzqiYK8wvhABoTRG78fsueyKBtCkYbUvdKdGfU6xbQbo/4Ozsf00C+3MO3a2twUFataBqT3gmmeM68THqZX5JRMadWhJLyzwT4qsR3QPgz7UTYIuxuJ3FoHBGMJ4fGz4y8UOOREdIfZIlTTsMj6IzkYA7za6OsN8Wizxbk9QgelQGzVWXExZUiyROJUr6+0cdpPyILRWmCMluU9/fKEcBmOqJcqfDys/JhTf4pR4lYprpsRmZ33uCXTD+qEc/fgA6vnalFCMt48TQSNqi7HXzRzUv8El4jNXmaBH78A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBKRNcLVeYJHnn9tuz4vudYtodcPUVM4nRy50725zDA=;
 b=KAiWR9NgJVk3fKfMo0wcw4O8g4zoDfehqeNlj6ZqK8x0Oc/fJ4uNDONTBxm6SWpxYQnBIJkG923BJZRXEurGV7b2Y3SHEC2B9fQXjaYhVdbMRJ2Bfsoy+rpJvhJI6ThOjBq8kj32x7/uxbX5G9owi+/VKuta+Gau84DBHmanKlA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MWHPR12MB1568.namprd12.prod.outlook.com (2603:10b6:301:e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Mon, 11 Jul
 2022 22:37:28 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 22:37:28 +0000
Message-ID: <5a83c921-ca07-06f3-0f4f-261f242c2488@amd.com>
Date:   Mon, 11 Jul 2022 17:37:26 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] drm/amd/display: Ignore First MST Sideband Message
 Return Error
Content-Language: en-US
To:     Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Qian Fu <Qian.Fu@dell.com>, stable@vger.kernel.org
References: <20220711221051.89665-1-Rodrigo.Siqueira@amd.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20220711221051.89665-1-Rodrigo.Siqueira@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR12CA0026.namprd12.prod.outlook.com
 (2603:10b6:610:57::36) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f2afddb-2cf0-4b4c-72f4-08da638def31
X-MS-TrafficTypeDiagnostic: MWHPR12MB1568:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hu6y4j9RPM5bDaNUg/2PxV/HNoi/ia3FiV42Vm9g4U+PyeVrWeGZsrZsfkIshbA6tYTdA/QZER5AwKYqSrnI2gsR6d0gbFsanXiYGlBk1LonEEzxjujCMG3KJAMNS4H83ZNaxeX8fEpvVXB2QiHDxGn42Daoqk3u+JEI/J2RpE1NjL82If4wAWfDM8EWh0S/GfAl726Y1Y8Fjpdl6FqATMy+gqr9STbnLno35NIB5/vnXPCd8evxuyZakMRUTM0+1dCQmdyu9+43eZszDe/OZ3BsPziUJHOM0qJVPWSecb3IN9cJpVoyPNYShCwM0kbFbG9p0GmSsESNmzUEB8jgiuQxWnGKOj/dadwLV0onQrahpQE7y7f89XyFkS3q3mCdNReSN3uRCI+wCFjr8Q6jGapin8gWt0tXEoUU+VvrlfYJHyXxWjpnEvrEczxajxN0n2QT7a0BZw0DTPed+DPcak07esj4srcufGBT0Pmvp+RYhJxgNgdtnEqLADbpu30VTTMoK0fkDJzHU+cI/E7anXeZLmjmXp1A2vK+LAdDITuYocjURxTd6DjCJy19xxcYRItlmBQfk/upgiqxbpj2qFSE8Y61ayTPcCHCCsLlLdOEQLZwLPYGFlFDlgGzrnrnYy9b2wHSuk/OjCTBOBRPlq4JwpyCwByys4aNTsZMupoubgFO+k6UH+hvse+DMq6lhNLsTrw1rAzpJiIFVFI0H4PMQiCj4fIiqcDzYcde5b+TQ7TwPrasnOgGpsgE9w3caBJKzb7t24e594jUsVc/pfLLAg6wb76Bvbt2NX8LelavB14dx3tHR9GPOtBhyGO+xiqQnSalgcU9qqTBc6aGDAh7JY3OjPYfmZmEPMPT1og=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(31696002)(6486002)(2906002)(186003)(478600001)(8936002)(5660300002)(15650500001)(36756003)(54906003)(2616005)(41300700001)(6506007)(66946007)(53546011)(6512007)(66556008)(38100700002)(66476007)(4326008)(8676002)(83380400001)(316002)(31686004)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmhQN0RGQ1V3VEpOZ3VGRWhOVysrZ1h3NFJmS3lPeStKWDRNaUtuUy9UeldM?=
 =?utf-8?B?K1B5K0ppK0ttbUZxU3VtTnRrY1NsTWRWeEU1ZjNNS1V3bzV4WGZ4bXVxS1hn?=
 =?utf-8?B?RkNIM3ZrRktndU0vVDkrRGIzV1k1Tkg3dXZ2dWdkM0doOWxUMSt6d2xCVUFC?=
 =?utf-8?B?RzJ6Y1gvZ0lsc1djSlpka2pTK0RFQjJsK1Btc3VrVXhac2F0bXpyNy9xOFFn?=
 =?utf-8?B?YUViZ3VpWFNPdElYUHhtMkpya3VkWnRZNmt5OGpvVjUrRzZ2a2hHMnAzQkgr?=
 =?utf-8?B?ZjZEZ1V3M2tuQnd6ODU2bE53UlhZUVplcFFVdG0wSEJ0NzB6Ym5oUFQ5aXVm?=
 =?utf-8?B?OW1zK0RjYitVQUkrTnZsUE0wOUtpUUZzSUhQMVBiYlpLNTJLbWNCZ0xUUTQ5?=
 =?utf-8?B?Y3FwOWRIMXJYTkxYT21NN1ZXdkJ5TC9YU2FsNVhDNERlTnJVSVJzcHZVOFJP?=
 =?utf-8?B?cThneml6aXBUTXl6V1Z1QURmVFlxUGxzb1NPN0lHWHB2SkFHOVc4clRSZjRP?=
 =?utf-8?B?dUFQWlNiWmEwQmc5YUpsYWZPRXZBd3VaektCU0hGdldJb0dxOWpPUGkwZXJ5?=
 =?utf-8?B?SzRscXZaNTU3QSswYlYxbitFa3h4MDFYS25RQjM0aklsbENhN2NEWE9zS2ta?=
 =?utf-8?B?cWVzK3B0UXpZYlBxTVUyVUZMQlpzSlNPSXpOYm56K3dpdTNNRnZGdWZmQm9m?=
 =?utf-8?B?NWNtUitoNSt4M3lZZHdjcHR6VWVLb3pPbHREYlBCM0wraDg1c2tKbGlKQzlY?=
 =?utf-8?B?TkNtZkxNTHpzMHA1d1dKTlBCbmU5RU1rcU1nKzYrbTM3ZzJpcnFMTU9VTmVw?=
 =?utf-8?B?OUFwQ0J5bUZ1WVRRbSsxV0cvUWNDL0FCSUtzNGZTeFNER0NTZ2JQVkpSdkxp?=
 =?utf-8?B?QUtaa1lJZVphb05Wazh2UGs2dGNuVmU1aWpUbStLQllRVUdkeVh3NG9YWTJ1?=
 =?utf-8?B?L3FTVEkyV2ZIVENRVmNnRjdLK293VFo5czUyalJKMU9YOXlKazJjZzg0bEFj?=
 =?utf-8?B?V2FsN0k2VTdEbGdjcGRZbVVOUjUrQmw3SE9KejFpQUhTcGhiTHdHb2l6di9K?=
 =?utf-8?B?K1lSSEo0eksyUUd6MHFLbjF4SGZQck9NeXFXaWt4SFRpWmJ4cWZFWHVLU1hJ?=
 =?utf-8?B?Vm9PUHZSOC9sejhsOFhuUFpOOGF4MHh0NWNtMDQ0SGRoL2I4UU5YUkVmV3BH?=
 =?utf-8?B?L2d2Wkxxa3hvb2RHTVprZlg2U21EUm9MdDhGbTRURE1VTWZDbWZDa3BhcE5z?=
 =?utf-8?B?R2k4clNvS0FpaVVQY2FycUpoS3k1Qm5UamxiOFg0SlVBYytySzNyUWZPMXhN?=
 =?utf-8?B?NFBPM1FkczhEeHhqOGc2WGhsa3l1K1Q3VnhCaUs4S1BvbmRkS1haNXJ3c3BX?=
 =?utf-8?B?V1hXWExvUjJUMUxJczNzUGxndU1MZUlzYlpCM1UzRE00ODZ6Qnh3RTFkazF2?=
 =?utf-8?B?MFloRFdXMmM2VzQ1bTJRaWExcXk5ZVZLcEgwWVloZjRlSlZhcURCeEsxVmRG?=
 =?utf-8?B?ZkJHdU9GRnorT2NkRDRGMnVkRFBTYWtUNHllelJkaGFicWpCVTZ2S1pma05l?=
 =?utf-8?B?VlFpQk9IN3k4Mk04OEx5UGo0T2hxcUVvdWlBRk9tMWlhWmRtTTNFdnpoUTl2?=
 =?utf-8?B?d3Q1SVF2aWFkNnNySWZuMG1ZZjFORGxiK2I2eitETUswU2FTcEoyVlpkYTJp?=
 =?utf-8?B?TVVMOTcwbVhmci9wSkJVYWpneU5aSExZVWhMTlN2MkRRM2RDUG00UUpCSm1W?=
 =?utf-8?B?Y0h2c3lvaEZqdHZ5UTRzQnF6Nk55TlhCL2s5clZvYlFjUjZxeWVLL0FBWUh3?=
 =?utf-8?B?a2J2Zlc2SWxST2RrNXJXUWk5QlJsT2lzODlVaWlJVGJna1JNcndTcDJjMThZ?=
 =?utf-8?B?aUJNZ2pkV0ZRSE9ad1E4d0xrM2RIVmtjSEl6TmNLWEZsREZLZlNkcVplZEpU?=
 =?utf-8?B?bUFsOWIzdldodU45cTNRM2dKWFhBZHlLaU1NWE56R3FFS2tGYmlLYlQ2Ry95?=
 =?utf-8?B?VTN3SWJsUGhsd3FHZTFxL1c0V0F5dTRTSVVyVzZHV2VDdmRWaXlsTzJXaHY5?=
 =?utf-8?B?YVoycit3ZS90YzgyRm9oZ29BenRFbDEyUzBralN1NWoyYjNia0JMQlBCWlVW?=
 =?utf-8?Q?rpBR17PEZjCRWBfwRjE4YkH2E?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2afddb-2cf0-4b4c-72f4-08da638def31
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 22:37:28.2454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o85n0vdQ3jEivWG6KZjBHKe+Hkn5hegY40dcGtXQSE6/9pp+BpAPjFf60mG1gWrXyCGPUMeAiJx9R/Z4LYNdRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1568
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/2022 17:10, Rodrigo Siqueira wrote:
> From: Fangzhi Zuo <Jerry.Zuo@amd.com>
> 
> [why]
> The first MST sideband message returns AUX_RET_ERROR_HPD_DISCON on
> a certain Intel platform. Aux transaction is considered a failure if HPD
> unexpectedly pulled low. The actual aux transaction success in such
> case, hence do not return an error. Several Dell Intel-based Precision
> systems had this issue, for example, Precision 3260 and 3460.
> 
> [how]
> Not returning error when AUX_RET_ERROR_HPD_DISCON detected
> on the first sideband message.
> 
> Changes since v1:
> * Add two missing products
> 
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Cc: Qian Fu <Qian.Fu@dell.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
> ---
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 29 +++++++++++++++++++
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  8 +++++
>   .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 17 +++++++++++
>   3 files changed, 54 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index de1c139ae279..3c7f6920f71f 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -72,6 +72,7 @@
>   #include <linux/pci.h>
>   #include <linux/firmware.h>
>   #include <linux/component.h>
> +#include <linux/dmi.h>
>   
>   #include <drm/drm_atomic.h>
>   #include <drm/drm_atomic_uapi.h>
> @@ -1400,6 +1401,31 @@ static bool dm_should_disable_stutter(struct pci_dev *pdev)
>   	return false;
>   }
>   
> +static const struct dmi_system_id hpd_disconnect_quirk_table[] = {
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3260"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
> +		},
> +	},
> +	{}
> +};
> +

This still isn't formulated correctly unfortunately to match all 3 
systems.  They need to be their own DMI matches.
It should be like this:

static const struct dmi_system_id hpd_disconnect_quirk_table[] = {
	{
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
		},
	},
	{
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3260"),
		},
	},
	{
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
		},
	},
	{}
};


> +void retrieve_dmi_info(struct amdgpu_display_manager *dm)
> +{
> +	const struct dmi_system_id *dmi_id;
> +
> +	dm->aux_hpd_discon_quirk = false;
> +
> +	dmi_id = dmi_first_match(hpd_disconnect_quirk_table);
> +	if (dmi_id) {
> +		dm->aux_hpd_discon_quirk = true;
> +		DRM_INFO("aux_hpd_discon_quirk attached\n");
> +	}
> +}
> +
>   static int amdgpu_dm_init(struct amdgpu_device *adev)
>   {
>   	struct dc_init_data init_data;
> @@ -1528,6 +1554,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
>   	init_data.flags.enable_mipi_converter_optimization = true;
>   
>   	INIT_LIST_HEAD(&adev->dm.da_list);
> +
> +	retrieve_dmi_info(&adev->dm);
> +
>   	/* Display Core create. */
>   	adev->dm.dc = dc_create(&init_data);
>   
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
> index e04e6b3f609f..33d66d4897dc 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
> @@ -547,6 +547,14 @@ struct amdgpu_display_manager {
>   	 * last successfully applied backlight values.
>   	 */
>   	u32 actual_brightness[AMDGPU_DM_MAX_NUM_EDP];
> +
> +	/**
> +	 * @aux_hpd_discon_quirk:
> +	 *
> +	 * quirk for hpd discon while aux is on-going.
> +	 * occurred on certain intel platform
> +	 */
> +	bool aux_hpd_discon_quirk;
>   };
>   
>   enum dsc_clock_force_state {
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> index 8237029cedf5..168d5676b657 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> @@ -56,6 +56,8 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
>   	ssize_t result = 0;
>   	struct aux_payload payload;
>   	enum aux_return_code_type operation_result;
> +	struct amdgpu_device *adev;
> +	struct ddc_service *ddc;
>   
>   	if (WARN_ON(msg->size > 16))
>   		return -E2BIG;
> @@ -74,6 +76,21 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
>   	result = dc_link_aux_transfer_raw(TO_DM_AUX(aux)->ddc_service, &payload,
>   				      &operation_result);
>   
> +	/*
> +	 * w/a on certain intel platform where hpd is unexpected to pull low during
> +	 * 1st sideband message transaction by return AUX_RET_ERROR_HPD_DISCON
> +	 * aux transaction is succuess in such case, therefore bypass the error
> +	 */
> +	ddc = TO_DM_AUX(aux)->ddc_service;
> +	adev = ddc->ctx->driver_context;
> +	if (adev->dm.aux_hpd_discon_quirk) {
> +		if (msg->address == DP_SIDEBAND_MSG_DOWN_REQ_BASE &&
> +			operation_result == AUX_RET_ERROR_HPD_DISCON) {
> +			result = 0;
> +			operation_result = AUX_RET_SUCCESS;
> +		}
> +	}
> +
>   	if (payload.write && result >= 0)
>   		result = msg->size;
>   

