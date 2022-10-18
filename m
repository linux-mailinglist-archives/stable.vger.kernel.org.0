Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEC16023FE
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 07:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiJRFoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 01:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiJRFoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 01:44:14 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FFC9E2EC
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 22:44:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxnPcQem0Yvg0EhLMPuz9xvql94EttLaE7oJLfwo9HAwaI2s/Ipwl704DE+bn8/uVjAT0a3zxx1ldCfLSM9I/9tovSlr6ay4oRLxndsckFQAvgc+69m0660f0pBv+kCHMi8yFgPdzl0my0TF1lMBZ+ZZ0G2MnS+6R6rSAZdapYT3Zlp2q/1rRPFYvDeAuzNOREvAaS5692SJSnY411YwiYlCsW7uG79nszs8sqCEE0PfJ/r9SOH7E6IIsv9xI2cCDCvc8vcyJiSVTrMLgy9NGXgu+gwzMiVwhSczjJqRtuKEOdFP87N8+y/XDKQdpueqRyDJa0Y3/emM9swkUngb9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6CTGSOt/6O1YvJlVelijfFtqmxXTf5fXHKkTGCso5U=;
 b=MPpp5mAmx7qckYl+1EPd5tbUpGsWjH1LerTlgMObHMsZa3EJyFh+8lYQKLtS0AzF3bZag3ztbMmORTqbs8hKj0JyJ2R+bacLOFVg57L58ID+LBezsKWZn6A7GU98QXMXfMqif2KXAj74m42XBU/qCCJHZkY2YsKY31CHN7oJ48V1cpNBbXSRYs8hyzE/gbke+gcadamcCuewPMQn2X05Q3YEYhV8KVJ6VnEQn1Om4ycEsFwq3phYilgFol45RcWyjwefkViQSDNKsIeAGiS94O2F5iOqjhBCmTjWucGRR5WRMRliEoxv1Z5cfJpP0mEVp3qRWxmLUiMt7yh16SrBHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6CTGSOt/6O1YvJlVelijfFtqmxXTf5fXHKkTGCso5U=;
 b=bGeErx3lx/H8t2k9igjiC7GPzYOrPteaC3uJNlthqrY5U7TJ6Iys2YBeprDffO/frbsktVO5Nc0BLM1qIL6FXfoPPoxfkHM7HFb0gRNTncr6kokYj501uzb/HxsYclSc8E+VG62IawdIdGK/GnBVRdz1jlL3lM6FRFMg1voN8CA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by BL3PR12MB6404.namprd12.prod.outlook.com (2603:10b6:208:3b4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 05:43:57 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::992b:b2b:80dc:86cc]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::992b:b2b:80dc:86cc%4]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 05:43:57 +0000
Message-ID: <113346de-409e-cf30-2e08-4ff1bdc0b823@amd.com>
Date:   Tue, 18 Oct 2022 11:13:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x
Content-Language: en-US
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Alexander.Deucher@amd.com, helgaas@kernel.org,
        stable@vger.kernel.org, Guchun.Chen@amd.com, Hawking.Zhang@amd.com
References: <20221018044724.86179-1-lijo.lazar@amd.com>
In-Reply-To: <20221018044724.86179-1-lijo.lazar@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::11) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB4614:EE_|BL3PR12MB6404:EE_
X-MS-Office365-Filtering-Correlation-Id: d1c23543-7a31-4ded-793f-08dab0cbbfd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: md9S/6Qw0VkNP7sKeYvOUtE9OLUvMh/UXEjdx7iQYiJQ6aRu4Mq00hx/Dx5kVuQeHKwgSUgeNL1tW81xEIyNF/MXYY4Uxr60bD7Mcde6RIcTcbWc2uIlpiYaYXfB3mZCO+F2Q+1JRX6SwuqNmpKUS6+0j5djuggg8xrdmIGXcsgRfq5TQgvkwRBqXQv4pNJ6Q1ETbS+YMbPePTsLZvUSh9fO9+Xqa+KKejfJZpfJVbwGGObKHLmestYQc9L+whQHGASTEBGaj/cuxDXF12qp5ero3/15yVzeNFVEpFQEENNITX0F9xPfW8bSt9kmQPb9EfjicBAHCSWtKFv5l5aJ68Y+1hL7m14l+0UvV7XiOjkr/jGg4R4bK3MmnvXVPZHgnqC0wRh4UqxACKRSeLEWnkak/8YKKTY+nYwKyvRv/vwk3X29rLhNlmBSxb5d21sbvKXsFs72WcdL1uB8oC7VU1+gMP7crWfpRnTjxOVcHIEOlL76G9LmaKaHH/B7TGRKk5jfcZl/6yCFLL8jrgLYITLdZHESlz+rI+/pja9+28jnv/WtJrXHW0qfYsSUgutOisMBpqBE41JESYlFhX5BKL+aU0EVHEPOSShSDapZxOgBBxxMBu9g702qC5zchG+XAnNQmBmbUM6q1NBRUaErGKdXf38KymkPfs3Df91bblrEsJprLn9CtlzG5/wkKMcRsToDHURFb1oz63GOd/3r1s2DqMrwWdxKuk3Liiw+wDMYkhw6SKIgWE0/L/rbDlOzdZM6enA/RoX/IPgyIqbNr4dHg0iO4uLTikWVuAVs7tY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199015)(316002)(186003)(2616005)(36756003)(6506007)(4326008)(6916009)(26005)(2906002)(6512007)(8936002)(41300700001)(83380400001)(19627235002)(86362001)(31696002)(66476007)(66946007)(6666004)(66556008)(8676002)(53546011)(5660300002)(38100700002)(31686004)(6486002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkUwamdBLzhKeWpwYkJkelJTZ1cyWVcrbjVNanoxcUhhTGJzS0RUOHZTRzZk?=
 =?utf-8?B?bU1JZncyTmlVWXdrM2RpNTNmT2ZaKzVjN3FFY0U0VkpTdmF1d2NqdEZ6K1lB?=
 =?utf-8?B?elc1T3pqRGdGNVM3aGVoYmY1MnF5RzBFSUVwYUZGTE4xOUU3N21oUCtFOUk5?=
 =?utf-8?B?Vk9aRmFvVDFJS0syeTJQU25HcWdvRktid2lmb1lsSFZ3SDAyQXZLUEpoNWVM?=
 =?utf-8?B?RmxiRkZseHFDSkJEdGFJbVJUeWxaRDM0TS9wMDMxQ2dta1FGNGM5eDBnZUwy?=
 =?utf-8?B?MTVxWGR3NHJBT2NMaGpzUXd3YmhLUDdVT3EvSFdhRU5zUWs4dGUwaTJHQlky?=
 =?utf-8?B?alhiM2drYXhYNXdqWTV4ZkdveGNHWlA1U0g0eGx4TFBaQWc4SWk0R3BJejFz?=
 =?utf-8?B?NUNkYmFaQ1lzS2NRQS9PclhVQ01vemR3Q3lJcVZqaWtBbmt4a04wMnNPSHJT?=
 =?utf-8?B?aTVLbVFTNzNoNnJPSzQ0SWRYN0pBMWZTT1NGSkpPeGJRMEcxc2JVaHpUWll1?=
 =?utf-8?B?dHMxa2VzZkxIdFgrN0xZUmNTTmVxZUlybWUzc3lJNUpjU1NUK21pcTRob2g4?=
 =?utf-8?B?cEgrSW5tSEFmRnk2VjFWb1BJRkVZWmVjWW9pQ29SY2FsT1E5cGZ6WEdOeTJX?=
 =?utf-8?B?R3RGVU1xYUxLR0JhNUp5ZjZSaFJzRlVEQmJ3bTBIZTI2Slg5dHpmSXBmcTdD?=
 =?utf-8?B?ODJSTGtxOEFTTk05bUNKRUxLbFF6azdwV2NHSk5ROTBNMGZ4Y1ExVitBaE9t?=
 =?utf-8?B?R3A0SXp3b052ZWF2R2g3UEhLWjNyRWlvRWE0eUsxa1BpZUhnU1Nvb1JMb0Rz?=
 =?utf-8?B?M1p4MUdCZ2JaS1kxanlLYXBLdUp4MzhYdXhKdE9RUkNUUkxPR05TSkZtSXRs?=
 =?utf-8?B?QzIrME5GSXVLbmxCd3ZkQXRaelcvYS9kK25zSzdQZThMd01lOElTeGI5Tm44?=
 =?utf-8?B?ajZBSWpCVFNOd25QV1FZU0xWODU2MS9jOUlRaUdnNTFoeUc4dnJDbjZaemRn?=
 =?utf-8?B?OGZSQlBzM01zVVpKMFMwa3ROQmFGTkFaZWg4VnNHM1RZMWxjTFYyc3RmcnVl?=
 =?utf-8?B?L3paUFhMYm9SVmhXakNOMTZVdmU5bmh3S0lKQ2xSSGI0SDZya2ptWHhjS1JV?=
 =?utf-8?B?Y3B6NlF4Yk5XVGYyclN6L1d3d1ZPZGtNL051UkpuejJra3VxL2dNV21uTWhs?=
 =?utf-8?B?YW1CMEhZZ2NQSzFRbFhPN0wyMnJ1ODc4MEJnenFBSjhTdWd5OE9UM0JGTUxy?=
 =?utf-8?B?VWsxNy9nN21zdWpLdDRBR2VGUmZGRkdBd0E5ZjdWU09XVGtKVkpCbktWNHFn?=
 =?utf-8?B?NW1QSm4xTlVCaUp0d3Z1aWNsSFlGTHljNG5GR2V4OTJaSjkwMUcvTy9ubTJv?=
 =?utf-8?B?Qk5XYTRhRGQvTUJoV2FpY0NvdGx5eWlYam1VMnA3aEFpaVZCZ2V3RG5aTTJu?=
 =?utf-8?B?algwYUo1NW1IMVRyZ3lDRHJYQ1lEWTU5TUZ2VTJmQlYwK1RQRnNIZ2VveXBv?=
 =?utf-8?B?Sy9TK3NpcGRVeUpMcTRjQk0vbDZSTDU0OFpuczg1TEVlM3Vrd0VBbXluajFn?=
 =?utf-8?B?V3J2Mkx5Ym54dDNJR0V0RmVCZTZBN3VTWDErdlIzenlBU3luSXRGT1Y0ZzZi?=
 =?utf-8?B?TWdhNUNjaDVRb3F5NXFiTjczb1hySlRFSS9NOWU1OGl6UzREb0Z2cDhvZnU2?=
 =?utf-8?B?UVBteHY1cXpoYmhadW1HRFRYeWFndDZ0YzdrQVNJMjIyYitFZ1MyeWRrWU01?=
 =?utf-8?B?SisxaEd1R2t4Z0ZyOStuenViY2I5NHdOc3pOOEpKcjVOVmgwNW1ZTjdiUHA4?=
 =?utf-8?B?N1JwZDA3b2dLY3BmT2RsRUZ4UFJGL0l2ZEUzSHgwQzZTTTFpRFgzbnpkTkM0?=
 =?utf-8?B?R29zYVVlcXRoUGYySkZqWkROUjFuZHRWOW0xZEpBMWk1MjFGdVFQY28zRG5a?=
 =?utf-8?B?ZUk1Nk9ZSWZWaGU5cXpVanVNZFdVVng3enM3WE1LeXZLdld1VWo1eWlRVkMx?=
 =?utf-8?B?aFhURlloVFhiamo3anNoWEQwOVVMcU1oTDB4K3B1b2YxRjhzeE1TYThLaXNY?=
 =?utf-8?B?U3NjUzhwVnpGV1J0VGJUL1J2VHRoc0pWMDFNZWI5T2RzbkFGcHdXZm5NSCt4?=
 =?utf-8?Q?PBh85VSnmqrxi7sQ/xJVML4YM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c23543-7a31-4ded-793f-08dab0cbbfd9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 05:43:57.3490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFrlbM0CewCO6GrcT4EcE0Vx0SkLBtcdF5U+jB0O9CnKQwu0vVBcFhs1a7jeNeHY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6404
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please ignore this one. A newer one with the correct format is sent.

Thanks,
Lijo


On 10/18/2022 10:17 AM, Lijo Lazar wrote:
> MMHUB 2.1.x versions don't have ATCL2. Remove accesses to ATCL2 registers.
> 
> Since they are non-existing registers, read access will cause a
> 'Completer Abort' and gets reported when AER is enabled with the below patch.
> Tagging with the patch so that this is backported along with it.
> 
> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
> 
> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
> ---
>   drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c | 28 +++++++------------------
>   1 file changed, 8 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
> index 4d304f22889e..5ec6d17fed09 100644
> --- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
> @@ -32,8 +32,6 @@
>   #include "gc/gc_10_1_0_offset.h"
>   #include "soc15_common.h"
>   
> -#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid                      0x064d
> -#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid_BASE_IDX             0
>   #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid                       0x0070
>   #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid_BASE_IDX              0
>   
> @@ -574,7 +572,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating(struct amdgpu_device *ad
>   	case IP_VERSION(2, 1, 0):
>   	case IP_VERSION(2, 1, 1):
>   	case IP_VERSION(2, 1, 2):
> -		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
>   		def1 = data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
>   		break;
>   	default:
> @@ -608,8 +605,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating(struct amdgpu_device *ad
>   	case IP_VERSION(2, 1, 0):
>   	case IP_VERSION(2, 1, 1):
>   	case IP_VERSION(2, 1, 2):
> -		if (def != data)
> -			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
>   		if (def1 != data1)
>   			WREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid, data1);
>   		break;
> @@ -634,8 +629,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep(struct amdgpu_device *ade
>   	case IP_VERSION(2, 1, 0):
>   	case IP_VERSION(2, 1, 1):
>   	case IP_VERSION(2, 1, 2):
> -		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
> -		break;
> +		/* There is no ATCL2 in MMHUB for 2.1.x */
> +		return;
>   	default:
>   		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG);
>   		break;
> @@ -646,18 +641,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep(struct amdgpu_device *ade
>   	else
>   		data &= ~MM_ATC_L2_MISC_CG__MEM_LS_ENABLE_MASK;
>   
> -	if (def != data) {
> -		switch (adev->ip_versions[MMHUB_HWIP][0]) {
> -		case IP_VERSION(2, 1, 0):
> -		case IP_VERSION(2, 1, 1):
> -		case IP_VERSION(2, 1, 2):
> -			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
> -			break;
> -		default:
> -			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
> -			break;
> -		}
> -	}
> +	if (def != data)
> +		WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
>   }
>   
>   static int mmhub_v2_0_set_clockgating(struct amdgpu_device *adev,
> @@ -695,7 +680,10 @@ static void mmhub_v2_0_get_clockgating(struct amdgpu_device *adev, u64 *flags)
>   	case IP_VERSION(2, 1, 0):
>   	case IP_VERSION(2, 1, 1):
>   	case IP_VERSION(2, 1, 2):
> -		data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
> +		/* There is no ATCL2 in MMHUB for 2.1.x. Keep the status
> +		 * based on DAGB
> +		 */
> +		data |= MM_ATC_L2_MISC_CG__ENABLE_MASK;
>   		data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
>   		break;
>   	default:
