Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD31521E65
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345198AbiEJP2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346306AbiEJP1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:27:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A451B1EEC5;
        Tue, 10 May 2022 08:15:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lp8yuytiPWTZZh6O8jhIx9WFjLVTWCey4p3YOkC8G1kzDSEIHBjFoVHhIpGfxkbaDdhKlOyokR4DEkHZDJ8p7WKcLxXWt6+t0ImP4/1GfEaGUxr7XNC2BBgQyyl+Fhzpia8xyU68vFSNGfHlBbAfmNhE9dSgkQh8eocIVRnlFOSumTGItYbC5SaIP/lG2mAZUuljlX2fV+KDFSZ9Qa2SDUVWvmDCXd0fVUVFEZFXR/vJCuLzxfA+6Lcn/1rsVVzIjiqwROdeWnnDJI63j+bySnSbskpzNqt/pYjLNeZbWUnYdnZkQifrP23DgIcQLLHe/rZXqfisKGqx5xXrDEVRiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QBipr7tykPopiD78sfxzQk8vnpAiSmb3Oa3I8Yc9UE4=;
 b=N06rNajVbIwahA9b3GDQGgrfpcPHNHR8V4806scctkNJnnxuqUg9QgsTol2BrAztJ3jUKERqzdVtyVeF6zsBitY26SFEkThJwdOR2VuI0HknpJSpf8St3y04HK9qJ6QllZUm4x7xdeed8BRdFvNo5D8h09oZf4Tf458sVDFSiwytGKYCrqvlEPeZWoByNmbHA8n6F7mLUVxIWtMBG4boqbAd6IV8Bkt4rFIlKGwY+8jZPPE/bbbClFckRR5rsCtotSmkdoVsEkBBq9MtXZmPlKTEZLUxFHLABsNZ7IHzDFq1xTb1wpJYeeC6kdbVs/+7LGbcBDvomS7Z7AAKYbvsWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBipr7tykPopiD78sfxzQk8vnpAiSmb3Oa3I8Yc9UE4=;
 b=zmB4U6/ngdPMMVOIQjWTCy1jYm/cyvVhas2nJKSlB1Vc1d5B+vnn7phLxbV15olLOOCv3cDmG/MDm9w/KwYLbGzdGvRdaKBN0yfHs+lJ34k2Brq6zIOa0qsG+VuVZQt73usxww55qvBjXKr+zF7vleMld8F8Q9wU4omSn364/2I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by BL3PR12MB6595.namprd12.prod.outlook.com (2603:10b6:208:38e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 15:15:07 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::fdba:2c6c:b9ab:38f]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::fdba:2c6c:b9ab:38f%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 15:15:07 +0000
Message-ID: <ebc2e664-dd4c-d600-b99c-abe104ec76fa@amd.com>
Date:   Tue, 10 May 2022 17:15:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 082/135] drm/amdgpu: unify BO evicting method in
 amdgpu_ttm
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
References: <20220510130740.392653815@linuxfoundation.org>
 <20220510130742.763825220@linuxfoundation.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20220510130742.763825220@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0153.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::17) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef28c9f3-fc9b-4dd8-1caf-08da3297ddf6
X-MS-TrafficTypeDiagnostic: BL3PR12MB6595:EE_
X-Microsoft-Antispam-PRVS: <BL3PR12MB65959648B3CD6C42FE4F3C8A83C99@BL3PR12MB6595.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81QgtJbcxdqad4ABbOoHMjaU+p7IisMf+1aBeHea4eoUgCB2hcHToJ55cY8bD7AXWlm3XivjziThftkrrVcew/b3nSCC0QbprvOfWfWdRz5eTVLuQmWqqJuV+knCcKkxOYQ1ElSFXaclyt4nZN8f1QIi4nxCzjcnnF22kbH3B6F6NplTb1jzQO8kotY+/ZczD4VcfdSpIJh1qchcQj3EQLIGLFOkKorWVzJYluKUdfrGTf/tRnCTnhERnkYnhA2+5ZwJWUWQ2f1EU0x2X55sXeyo9fVYdeUKw4PXLRgKsuJ/ochgGskpD2VLsH+sxi8mengWkbSya6nUT4anspfOmb6IFYlQBfJjavsDXu8hRFAp8T68hwapvpDv0Hf9gibHht27XPe83TCU1R/FaCyAg3WT+8payfp9Ls1Xg6lsCaKBy2Ds/QDnQUB3WlcIeeIeMA/tcN92aasOLj4L6pOYrZKlssn4ezfoLK9SKm/rhxLclhZh2oarSwvi2+wNXkgcnXkU9wwXptlq6eFA9q+f3evIWF0TyNjQ36BKrbv4HdtGmaf07BhjI0awOTThditJAvBfDnhAkk8NRQ+6JjGIXZ0TME/ziaEYbtw/NA/m3hx1lZ6O01nLDRZamseBJSFvOjW6cvElP4tiPisok01IT0ad9CXV2DUowwGbvtKTxFn4fLibAgH5SQ96fEOkn2nVs5yEQJGsRVhuRsHJZQt2ov2jHdMZFWpnuJL0iRjdIu5gQW8zhfLq5VYpkDP/OECZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(6512007)(2616005)(8936002)(31686004)(508600001)(8676002)(2906002)(66556008)(66946007)(66476007)(6666004)(83380400001)(6506007)(4326008)(186003)(5660300002)(6486002)(31696002)(316002)(38100700002)(86362001)(54906003)(66574015)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzB5Wk5QOHhNWFZRdU5ONVlER25VUXBtQTNLTnJmREdyS3E3RU9MZ0RYOFAy?=
 =?utf-8?B?VzBEbVZmdnlxdGVKSWpPZ1A3NVRaYU53dnMvV0c0Qk04RjlPem9MV0ZGZ1VG?=
 =?utf-8?B?YmVSWjFwRDZPa0ZqOGdNcVp3b3FoWkxOWjJFQk9peDlmcnB6SHE2ZnFVaEtH?=
 =?utf-8?B?R0ZUOHIxV2g2aDFSdGNHQjNPT0d4K1JQaDdBSzB4NjlKQUlsWU9weklmWHBt?=
 =?utf-8?B?ZzlaN3JuQ09LSnBJNlVoc2hFMEg4bTVCSG1teGlsTk5WRU95Tk82dFZ3RThl?=
 =?utf-8?B?MmVMcnNZZHhNbGlybDdQSHFRQ3NWbEx5SzZ1b3FXR0FKb1hsazBSeW1hV2xP?=
 =?utf-8?B?MWYrcHliTEdnMnBXTWErbU41RU5pSWd6Um4reFR6UFNyNzdObWE3a0VLVTM2?=
 =?utf-8?B?eU15Q3FCRURkaVJpeTkyaGNLMy92YzBEdSsvR292YXpBYXFGWlZhN3pmeUp0?=
 =?utf-8?B?ZlFCdlU1cmpmTURON2hGYS9hclVSWDZiL29ubm9kQjhZTCtWZmFMNEQ3MnMz?=
 =?utf-8?B?aEVCcnB5MVR1b0FKUERiTGN3S3VwanNLN01HNTFlcnN3bU9Mblpyd2I2SWZB?=
 =?utf-8?B?MExaZzZBOVJUN0pBR1ZFWVNpYnBRN2FqRXVPcUxpcUxNelZ6OTZCRC9pa2k1?=
 =?utf-8?B?UjlYSmxQMzVDMUNiQ3hSNGo0cDdoQnpVZzJUYUlrYW8wb0N5OVhHalNYVTRR?=
 =?utf-8?B?TGxNRnFmbXpmMElDM1dLa3QraVlPMFl3SVp0VUtZTmtzYmNmelFKSzZ6OTdt?=
 =?utf-8?B?WHRFMFJMNTBxWkNPOU1IYVppYTVpT1ZjUlN5UXVwMGRObldrc1lPYTQrWG1J?=
 =?utf-8?B?bFBIT05wUTNjdElPWElwTjlLNC91dWJ6U2l0V1hjUlRvclEybStvOXZLdCta?=
 =?utf-8?B?YWs2dnpXa0JqS2xpcGtLWmQ1cS8zZlRraGc0RUsxUHk2VXRldzFCdWpHczZ0?=
 =?utf-8?B?Y2ZtYUZpb2x1YVJmZjU0djZrOFF0OVp3VXZFVHlDckk1S2lSMU9yMHh2d24x?=
 =?utf-8?B?bHBUWXB5eHhYaDk4VDQxSFN4VnZpQUI5ekdYSi9laUZRdG90U3ZkUnZ6bm5s?=
 =?utf-8?B?S2orOUxzYWRoQmRZTURrdWMrbmRKRms1RktFSGxtQVJqZU84a25pNGJyMFRq?=
 =?utf-8?B?NHFFTzFTZjNQMkorZGVJd3JUaXV5YVhGVHZqeGpWajAzOUQzSjNac2ZEMWdU?=
 =?utf-8?B?M3ZRRWJDY011TWJabzBWR3hQN21GTWJibDduenlBcDBORStmeDRWcjhzSi9p?=
 =?utf-8?B?UERMV0o4T3VrRVVIYTdoVEtDTnRuQ2N2YzIxekRSeTZua1UzR1krWHZzdkJU?=
 =?utf-8?B?dUZCYWJ2UVV2TmJjK2RJeFhud1RLODZWc0J0MGRGUjQyNTVCcWRyOEx0SmtJ?=
 =?utf-8?B?VFVUbllHdWhFcnlucVlWTVBDVHl6emU2UVoyL0x3ZU9yTHE1SkQ5dHhGT05N?=
 =?utf-8?B?VzdhQnJ3N3UwQ1BpWVprb3ZFQ1gxa2hIRDE2NFZWbXFqUzZBRzRiNE1JVTl5?=
 =?utf-8?B?YVJSN1hudHNIVitSTVQyYXJGenNTcFJIVW4xMGlvZmVOY2oxZFZpWGUrS0Rk?=
 =?utf-8?B?bGp1Z1g3VVR1Q1hWU1VKdjd2bGtvMGRJbC9CSCtNcUJzTTcvcFZybStJNktY?=
 =?utf-8?B?bVgzejk4ME1WKzlQdWkwNm9GV2h1dDdVMTUxNk93ZlZnTFJpMTJER3BxTkxY?=
 =?utf-8?B?RmUwWldVT2FWYU81alJuQmptUXBIRDV5Mm1HN2lidkhRRTNiQXhiRkZTOWU3?=
 =?utf-8?B?K2JsMHNLZkJVOW0zSzBJZ0NodEM0Sk5YZEhuMzI3SjBUSzZQRGgrS3hpeGtq?=
 =?utf-8?B?ZWpNd2V2WkpvSUlPbU1NNU5KYUZaZVBYTHN4RDZGa2QzZ0lWQlk2ZEFuOE1r?=
 =?utf-8?B?dnRwc2g0L0tKa1hWWkVQQ0hqa2FWM1krUFVLVHZwQm9JaWRJT2hYWlBQVTRN?=
 =?utf-8?B?bnBQMXdPRWVNK1daQ2kyRjhZUkJXbkVsbnhFbm1mMVJmYnZ0eHZpbU9mMWxP?=
 =?utf-8?B?ekNjV3l5dXlhOVJLRHgxMENFV0tRTGFXYkJOWGxpSHB6cFQ4enlmYmtwRnJw?=
 =?utf-8?B?N1lHbjduNjdidnVWYXlHMnRncVNWS0xvcXNDcWtXODBVWHN5T1lFcitKRHVP?=
 =?utf-8?B?RUI4cUlhRTFpUllpemFVZDNlaEY3K2Fpck9DYmYvWks1SFIybE1kM3BJSTZ6?=
 =?utf-8?B?eElsZzA5TXBrSzZ6NXU0MVZLQi91ZmwvR1VoQ2M2OTg4S20wRlJmdmg0SWZ3?=
 =?utf-8?B?dzlzTEZqbS94OVhwUkRyZUFSOXNpTjFVMnI5ODNuVFlyZkZqV0xTeDlDSXJr?=
 =?utf-8?B?dWVsS0Rxa0I0ZkYzUFZ1eFRVSUxPTS9Tc3JwVVVhdmVKS0ZpZnFVM3ZGZ1dJ?=
 =?utf-8?Q?HykDEJlTuBiAVFKKYrg7ZB3WKZHe0AeJsl9BRbnWdjRFB?=
X-MS-Exchange-AntiSpam-MessageData-1: O3FDqvesC0XZ7w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef28c9f3-fc9b-4dd8-1caf-08da3297ddf6
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 15:15:07.3722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZgEf7YWLbwmWqXmXM1Z2NQq1PwUYk3oVCkGENa0RCXGaSG0WLFuUZcjGnAc4Iyo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6595
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

sorry only noticing this now. Why is that patch backported?

I mean it probably doesn't hurt, but that is just a code cleanup without 
much function difference and not a bug fix.

Regards,
Christian.

Am 10.05.22 um 15:07 schrieb Greg Kroah-Hartman:
> From: Nirmoy Das <nirmoy.das@amd.com>
>
> commit 58144d283712c9e80e528e001af6ac5aeee71af2 upstream.
>
> Unify BO evicting functionality for possible memory
> types in amdgpu_ttm.c.
>
> Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    8 ++-----
>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c  |   30 ++++++++++++++++++++++------
>   drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |   23 ---------------------
>   drivers/gpu/drm/amd/amdgpu/amdgpu_object.h  |    1
>   drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c     |   30 ++++++++++++++++++++++++++++
>   drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h     |    1
>   6 files changed, 58 insertions(+), 35 deletions(-)
>
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
> @@ -1176,7 +1176,7 @@ static int amdgpu_debugfs_evict_vram(voi
>   		return r;
>   	}
>   
> -	*val = amdgpu_bo_evict_vram(adev);
> +	*val = amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM);
>   
>   	pm_runtime_mark_last_busy(dev->dev);
>   	pm_runtime_put_autosuspend(dev->dev);
> @@ -1189,17 +1189,15 @@ static int amdgpu_debugfs_evict_gtt(void
>   {
>   	struct amdgpu_device *adev = (struct amdgpu_device *)data;
>   	struct drm_device *dev = adev_to_drm(adev);
> -	struct ttm_resource_manager *man;
>   	int r;
>   
>   	r = pm_runtime_get_sync(dev->dev);
>   	if (r < 0) {
> -		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
> +		pm_runtime_put_autosuspend(dev->dev);
>   		return r;
>   	}
>   
> -	man = ttm_manager_type(&adev->mman.bdev, TTM_PL_TT);
> -	*val = ttm_resource_manager_evict_all(&adev->mman.bdev, man);
> +	*val = amdgpu_ttm_evict_resources(adev, TTM_PL_TT);
>   
>   	pm_runtime_mark_last_busy(dev->dev);
>   	pm_runtime_put_autosuspend(dev->dev);
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> @@ -3928,6 +3928,25 @@ void amdgpu_device_fini_sw(struct amdgpu
>   
>   }
>   
> +/**
> + * amdgpu_device_evict_resources - evict device resources
> + * @adev: amdgpu device object
> + *
> + * Evicts all ttm device resources(vram BOs, gart table) from the lru list
> + * of the vram memory type. Mainly used for evicting device resources
> + * at suspend time.
> + *
> + */
> +static void amdgpu_device_evict_resources(struct amdgpu_device *adev)
> +{
> +	/* No need to evict vram on APUs for suspend to ram */
> +	if (adev->in_s3 && (adev->flags & AMD_IS_APU))
> +		return;
> +
> +	if (amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM))
> +		DRM_WARN("evicting device resources failed\n");
> +
> +}
>   
>   /*
>    * Suspend & resume.
> @@ -3968,17 +3987,16 @@ int amdgpu_device_suspend(struct drm_dev
>   	if (!adev->in_s0ix)
>   		amdgpu_amdkfd_suspend(adev, adev->in_runpm);
>   
> -	/* evict vram memory */
> -	amdgpu_bo_evict_vram(adev);
> +	/* First evict vram memory */
> +	amdgpu_device_evict_resources(adev);
>   
>   	amdgpu_fence_driver_hw_fini(adev);
>   
>   	amdgpu_device_ip_suspend_phase2(adev);
> -	/* evict remaining vram memory
> -	 * This second call to evict vram is to evict the gart page table
> -	 * using the CPU.
> +	/* This second call to evict device resources is to evict
> +	 * the gart page table using the CPU.
>   	 */
> -	amdgpu_bo_evict_vram(adev);
> +	amdgpu_device_evict_resources(adev);
>   
>   	return 0;
>   }
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> @@ -1038,29 +1038,6 @@ void amdgpu_bo_unpin(struct amdgpu_bo *b
>   	}
>   }
>   
> -/**
> - * amdgpu_bo_evict_vram - evict VRAM buffers
> - * @adev: amdgpu device object
> - *
> - * Evicts all VRAM buffers on the lru list of the memory type.
> - * Mainly used for evicting vram at suspend time.
> - *
> - * Returns:
> - * 0 for success or a negative error code on failure.
> - */
> -int amdgpu_bo_evict_vram(struct amdgpu_device *adev)
> -{
> -	struct ttm_resource_manager *man;
> -
> -	if (adev->in_s3 && (adev->flags & AMD_IS_APU)) {
> -		/* No need to evict vram on APUs for suspend to ram */
> -		return 0;
> -	}
> -
> -	man = ttm_manager_type(&adev->mman.bdev, TTM_PL_VRAM);
> -	return ttm_resource_manager_evict_all(&adev->mman.bdev, man);
> -}
> -
>   static const char *amdgpu_vram_names[] = {
>   	"UNKNOWN",
>   	"GDDR1",
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
> @@ -304,7 +304,6 @@ int amdgpu_bo_pin(struct amdgpu_bo *bo,
>   int amdgpu_bo_pin_restricted(struct amdgpu_bo *bo, u32 domain,
>   			     u64 min_offset, u64 max_offset);
>   void amdgpu_bo_unpin(struct amdgpu_bo *bo);
> -int amdgpu_bo_evict_vram(struct amdgpu_device *adev);
>   int amdgpu_bo_init(struct amdgpu_device *adev);
>   void amdgpu_bo_fini(struct amdgpu_device *adev);
>   int amdgpu_bo_set_tiling_flags(struct amdgpu_bo *bo, u64 tiling_flags);
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> @@ -2036,6 +2036,36 @@ error_free:
>   	return r;
>   }
>   
> +/**
> + * amdgpu_ttm_evict_resources - evict memory buffers
> + * @adev: amdgpu device object
> + * @mem_type: evicted BO's memory type
> + *
> + * Evicts all @mem_type buffers on the lru list of the memory type.
> + *
> + * Returns:
> + * 0 for success or a negative error code on failure.
> + */
> +int amdgpu_ttm_evict_resources(struct amdgpu_device *adev, int mem_type)
> +{
> +	struct ttm_resource_manager *man;
> +
> +	switch (mem_type) {
> +	case TTM_PL_VRAM:
> +	case TTM_PL_TT:
> +	case AMDGPU_PL_GWS:
> +	case AMDGPU_PL_GDS:
> +	case AMDGPU_PL_OA:
> +		man = ttm_manager_type(&adev->mman.bdev, mem_type);
> +		break;
> +	default:
> +		DRM_ERROR("Trying to evict invalid memory type\n");
> +		return -EINVAL;
> +	}
> +
> +	return ttm_resource_manager_evict_all(&adev->mman.bdev, man);
> +}
> +
>   #if defined(CONFIG_DEBUG_FS)
>   
>   static int amdgpu_mm_vram_table_show(struct seq_file *m, void *unused)
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
> @@ -190,6 +190,7 @@ bool amdgpu_ttm_tt_is_readonly(struct tt
>   uint64_t amdgpu_ttm_tt_pde_flags(struct ttm_tt *ttm, struct ttm_resource *mem);
>   uint64_t amdgpu_ttm_tt_pte_flags(struct amdgpu_device *adev, struct ttm_tt *ttm,
>   				 struct ttm_resource *mem);
> +int amdgpu_ttm_evict_resources(struct amdgpu_device *adev, int mem_type);
>   
>   void amdgpu_ttm_debugfs_init(struct amdgpu_device *adev);
>   
>
>

