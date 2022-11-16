Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C8562B277
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 05:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiKPEzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 23:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiKPEzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 23:55:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3325710FF3
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 20:55:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJLFeIjX+OQgL7h/7rm8rR80WajEcGfBbh4TwuifTiG+En5A6+rlih813GrcV+4FKTe5thSJUlQ2/IKNtiNKxV48tNzqVHmww+K0Xfli8N7jaMuhL3+liel9aXzt/44LkEtbsTDBOxRtLHtUJHH/9FlBFfnVrKV02Olp7Bc3l+NBHalWMFc6O86whXw9sdCNjYZWjVebcZHn41Du4yvuy3hQs/8M7ND2jTqCV85Tl8yyu1+VGYExjKsMgHJ2UbKAKRy1irThGN/dT0JX9GbkRsBXv5T6wV8G+DOysCLKQ3Dy0rlJHTzG+SWH6uLXbw6XQxmGeqgKWFOVayLXhoclEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X04Qf0PLtyt30ndwgFUzsgZFuiyQRq4oQ8k+Y+D9SG8=;
 b=lB6Xba46BgQU9g6zVcaNR2GIw/K3DaqZBd51WV2P3VZ7ConH+72o5z40NGvdgQu4YB8/rlqSrmmhSX2w/oKEthrJHSMFhpmDcEab67IQ1BUcgcd0VOzfdi0hwcM1Avs8fnyxMDxZ/HML9yiJegxsoBUe4WnmNeFlT18t/wy5i1hqFXSx43SiLUE5iG1PSN/P+i0X+t1LzjZjs3emb0ONZMpoBO7C4GjdqRCs1ji+EJl13dE8E5cutL1oWn76+TTDMo3zYYtr55Yu4ZNTmSUOp4nI/leQACSItUKjBZtepgq2u65KcEMfqZALJOxKg85BZyzI+2PaRhvG1ApKRpd+Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X04Qf0PLtyt30ndwgFUzsgZFuiyQRq4oQ8k+Y+D9SG8=;
 b=XG7PiMjopV4QVnF8ApQJsM4JtTfeWazlAjin5c19QcQ8nMc8pMVEwfaotyb8TH0tw0O8iOTzY5zn98rrIGlQbQMnPNeWfGnX5qRVLXE8/+vBbUmDndCesKEZ71+EvkrvouFuzfdo5akEDsydeoLMggxcuFK4Q+J0OVSlzbZ6Jd8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN0PR12MB6343.namprd12.prod.outlook.com (2603:10b6:208:3c0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 04:55:46 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::44a:a337:ac31:d657]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::44a:a337:ac31:d657%4]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 04:55:46 +0000
Message-ID: <d4644bfb-9f21-ff7f-93e8-410b34e478bd@amd.com>
Date:   Tue, 15 Nov 2022 22:55:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2] drm/amdgpu: Fix VRAM BO evicition issue on resume
Content-Language: en-US
To:     Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
        christian.koenig@amd.com, alexander.deucher@amd.com,
        gpiccoli@igalia.com
Cc:     stable@vger.kernel.org
References: <20221116045302.1007888-1-Arunpravin.PaneerSelvam@amd.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <20221116045302.1007888-1-Arunpravin.PaneerSelvam@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0338.namprd03.prod.outlook.com
 (2603:10b6:408:f6::13) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|MN0PR12MB6343:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e14ed47-4c5c-4ce0-f738-08dac78ed2b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5rkbj22ykWuexXPHkN1hhuhxGKtRIwMbchv5m5r4KxCIZV3ETzVTc6xiBrxBpU6+xLoFPyYuzkIz4gY0ZT0zIsZujQ6UFo52J6PEi878NCFj/IglbrFAnc6uSDVVSHSc13bJVAEZ0XTDk6wGSNvzEiunAiYAWTd+sERlFdIiuW1JMqeGzusfD5YxtUJGLMwGehqOb6YEcEkWbg8u2gK5lHlgmp6r5nlKkTlht27RX30mxh3Bo73W7BpSJT9NsdzFhzxanSOfPyhTgkw6SrwOvX+fZrUa1TxNgLqU0K5F0JuzOiJiWIKWzee9j09RCZd1slfm69TRC95MGymBL9rRdOjik04ufbQaOaZyX3sfQinLsxzr9L8KrPtDlljLtsjpiozYVAO8MP+ofj06nZaI/+7tVSeohadC4xmydrqbX1Pwqft/SjXKmoyjhsyDlLOkGmIcoNVZaxFBmrnDlSad8PhzBY0gXubO9RVext88IoG6aCbNW9b/WCfI4OK0lsAmlFjKRu71BDvM4aRsX9oSbHxK9mYTWgYut1l5HH8fX62nKZshf72XACdNlSCBXGB/70qQj+BXQerQmBa9FV5yKnZIeNo3lnra5CTUhTayOOcdkzK6WHWJhUIkT+9JYLhCRbi/gSxTGcBQ2T5MjO+OETeWhXUBlCxI2FSFvmwD802TMqnqSyz4VDj8kQdoSVp6N/i17D5QZis/lEXunc0m+3weIt2Hu0i3tvMYDPSYN6ehZWJIQ/hMGvnSdduP8l0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(31686004)(83380400001)(2906002)(4326008)(41300700001)(8676002)(36756003)(66476007)(186003)(2616005)(86362001)(31696002)(53546011)(38100700002)(316002)(5660300002)(6666004)(66556008)(44832011)(966005)(66946007)(8936002)(478600001)(6506007)(6486002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm8zRWZJNUxBNWtjQlNDaWM4Q1V1UmZMQjdNeWNPZTBLMkt4QjdsUC9nR0pS?=
 =?utf-8?B?WWcyNmZJekptMkhIeWFpSkZMOFYzZWpQSUNDam0rQ1ZIYUdjQmpGRGVTYWph?=
 =?utf-8?B?aEZ5Wkw0MDFvczkwWVZBSUIzNEZrbm5ibzNaU1VtVXNsNTZveTZJUDl4LzNn?=
 =?utf-8?B?VUMwbUJBRnRMUDNQaUZSYld3L3NROWl4eHZIZTlvcmloUk14dUM3UkxNSDBq?=
 =?utf-8?B?VEppRllOd3ZrTmJXdkh3QWRvZVVxeGt0TElLT1gyYmxLVytQRVFXN1VtazhN?=
 =?utf-8?B?Y3ZhckVJUmdwaFVoUUkvUUtHSE5VRVArU09Rak1LbzNvTHVjUVVGVmx4QzhP?=
 =?utf-8?B?cnJ6aGhjVnY5Z3NUb3hzRWpMLyswVTRBcXFyMTl5eEZ5Z2I5SUs2Rlh5c3RP?=
 =?utf-8?B?S2NQNURTTjJJbXgycHhPeW56OFMzd3R0c1A2NVVqOXhDU2RIWGtGdGtEUTRj?=
 =?utf-8?B?cjhVTGlaZDZMZ3lVTHhRUXNCUnRNSmdsSCtKajh5WUJvQzdXRytGY3RwcTh1?=
 =?utf-8?B?eE5MRzRqY1lVejBIeHdvV0pSMVNhSXhxeUtKMmlyN2MvL3hhU1FlNVRsZzE4?=
 =?utf-8?B?U21hNXJ5Y1BGTFdIYnRRWUFmZVAybkZ1SUI5S3B1Uk1DVTNWSTZnM1hEaTMz?=
 =?utf-8?B?WElEVm0yenZwQnBSY21aK0pXZWo5TDJaZ0toVFYyVTdZQlFHQ3BDVWdUVjdZ?=
 =?utf-8?B?RGhFTjdkKy8rZUE4MnlxZ3dvd0QrazQ2ZHhCS1Q1SVhxQStyNEtQdXJKbmhL?=
 =?utf-8?B?NFZyQy9oT1BFclRqdUt0b3IyT1ExTE51SEthTFZ3bnNrZHB1SkxZSzJ3dFR5?=
 =?utf-8?B?Y1RLeHk4Qng4TEFGQ0pJTjNYbDBFNkcydk8vZEZGRFI0QXVHVm1DTjRwUnkv?=
 =?utf-8?B?Z3hNZUd1RGZKTm5TUEliY20xM2dkajR3ZFlLUzVuK0JBaXdKeThPdzAwbGU5?=
 =?utf-8?B?WGtQU0xLalBUV2loNVNKcEdBT29YOE5HMUc1dFlJZmVNL1BjTnJweVJCRmJ2?=
 =?utf-8?B?QWNHRzlsR3kzamFNdHpiVVlCODFaZmxmdkpLMDc5c2czditkN2RreFFsdkFh?=
 =?utf-8?B?dHh4ZmlEQWROT29aakhuUG5Td29lUEZkZ1Y0aTAwN0FUWVhXZjBIOWNRbTZY?=
 =?utf-8?B?azJyYVpVN29LNDFQcnRSL1YyQWhBc0VCQjYwbDdpLzVHaUFSRmM4T1VicUtx?=
 =?utf-8?B?YVpuZHJicnU3MTQ4NXdURUQ0d3Y2N3V4eXMvVG1KQWxxaWtiM3k5VHErdWJy?=
 =?utf-8?B?OHhqSytBSlRRWlRrakxmdElkNENJS1o5Uk9rWUZBRVhrNUZ6SUlrSjViOHpP?=
 =?utf-8?B?M1N1bmw1YWxZNUc0cUFISlhXKzRwQ2NBTEw1em8vdXk0blVIK3VVditFTk1j?=
 =?utf-8?B?Lzl6R0E4cllBWVh2b01XVWhLdVRGTjFVVEk4WEd0S3hUdk81R3hUclRUNmVH?=
 =?utf-8?B?NytIN2FlUVJTcU13NXBUMnMxYTFaS2xGYy9HeC95WWhGRXJuRTFFaXFxL1lr?=
 =?utf-8?B?MTNsMVcyd1ZLUUorZkpQOUZpU3dRVTAzdHJqT2ZSd1ZNS1hhUVdVQ3dYYk9B?=
 =?utf-8?B?K3NoQkU0ektGYm5UVEwwVUtwbU1Ia2VRUm1paGp6YnRWNEc4M3lrdHUwUlpr?=
 =?utf-8?B?UnUrWHIrWjJqdzBxM3c2VFZacVY1Vk1iRHRMdVRtU3VnOUtoSkFNcHBZTlpU?=
 =?utf-8?B?WlZ0Y0g4Uld4V3BSbk84VStCTkFubmlQT0hwbzVsUGpyYnl5QThHMHgzNk5w?=
 =?utf-8?B?OXpFUmd1Rm40STN6Yk5yS052NmtmaVQxaWZxNnpPTnZKNW8vdUhQRThleWgw?=
 =?utf-8?B?V0JSTTBaczdDWFFvREE2bjdTL3Y0bHYzaXZjZXg0OWhEV1VabDBIMnlYSTIr?=
 =?utf-8?B?Q2VyRlhaZG9lcXl6WE9aYUZ2TDU0bEhUcE13UTNKejZONndSV0crZlZoTGRC?=
 =?utf-8?B?TlA0WFI1ME1WK2FxZmwrQy80UDdFR0J6c3RyLzVJQW1heTgwY2MyZ2hkWDQr?=
 =?utf-8?B?K3VOL002cDI2SStsMS9INjY1RXd4SGIyckkvbFI5bWd1NkNZYVd6THhUSUs4?=
 =?utf-8?B?UGt2VjkvbzNHOWd2cFVOMnN3VG5kQ0NkN3FnNzVNd0tKUkdHdm5qbEcvRlV0?=
 =?utf-8?B?TXJwNGZ2Q0R1dXBnU3Zma1hpL0x5MWtvSXJZU3Rqc0F4OFdaUllxVTVyYXJl?=
 =?utf-8?Q?LllS31gLkBOTSy5QNvIov4PwxRn3iqvUrWb5pnwmobDJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e14ed47-4c5c-4ce0-f738-08dac78ed2b3
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 04:55:46.1732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjqh5NctE5Ma6g82eb+BrJe2cGNZ5RmSjOhmAIX/mghWSOj8xgVeUJvba2TLVYPcCOjr0v/Dn8bwyEZe6svDmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6343
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/22 22:53, Arunpravin Paneer Selvam wrote:
> This patch fixes the VRAM BO eviction issue during resume when
> playing the steam game cuphead.
> 
> During psp resume, it requests a VRAM buffer of size 10240 KiB for
> the trusted memory region, as part of this memory allocation we are
> trying to evict few user buffers from VRAM to SYSTEM domain, the
> eviction process fails as the selected resource doesn't have contiguous
> blocks. Hence, the TMR memory request fails and the system stuck at
> resume process.
> 
> This change will skip the resource which has non-contiguous blocks and
> goes to the next available resource until it finds the contiguous blocks
> resource and moves the resource from VRAM to SYSTEM domain and proceed
> for the successful TMR allocation in VRAM and thus system comes out of
> resume process.
> 
> Gitlab issue link: https://gitlab.freedesktop.org/drm/amd/-/issues/2213
> 

The right syntax is:
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2213

> v2: Added issue link and fixes tag.
> 

This is normally supposed to be put below the cutlist (---).

> Fixes: c9cad937c0c5 ("drm/amdgpu: add drm buddy support to amdgpu")
> Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
> Cc: stable@vger.kernel.org #6.0

I think you forgot to send this to amd-gfx too.

> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> index aea8d26b1724..1964de6ac997 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> @@ -1369,6 +1369,10 @@ static bool amdgpu_ttm_bo_eviction_valuable(struct ttm_buffer_object *bo,
>   	    amdgpu_bo_encrypted(ttm_to_amdgpu_bo(bo)))
>   		return false;
>   
> +	if (bo->resource->mem_type == TTM_PL_VRAM &&
> +	    !(bo->resource->placement & TTM_PL_FLAG_CONTIGUOUS))
> +		return false;
> +
>   	return ttm_bo_eviction_valuable(bo, place);
>   }
>   

