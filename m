Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D33667AC0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 17:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbjALQ1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 11:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbjALQ1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 11:27:00 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA1C140FA;
        Thu, 12 Jan 2023 08:24:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoqpOF8u4refYVz6odS60Yt19plrDFeXtx8cCASFgqCebXujH4S3RGeIOrsayg6hTZExsnBJiLVduXcIFD5DsPuvZeDKEZo7gU4QJySmDGYqJ3FHwNZ0GU8j2tJk4dMD3nK9ovmOe/Ng432PzLR5pWjAqzLUc49r1EcLuEOgnH/efcasRz3InFVqdvdIbGUVvjrOeGCD4q4TqI3QKUHwWEK3OtbpGIr99hXkhagvBJMU1qh2tVAOxPWwQ61ei5T+IpBs5CJiI3cIDUYBzsIvdgdbjdGG2MT+wVtHY6/G4EdX4R5qP4e2d7e7IpmU6XHUX6ymZlcmO4rMAXNs4ETULQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5TzfwI1zZQoi7/k0z3Ylhe8LIlBUoOxGnIFKxmIZR0=;
 b=UyD8V9dMuFm46X6sMW4RZLaeczgUS8yy2KOnTTZ5Z8EaCTIj5ie8KIixtdXbFKY0THyfjw1kuMFBjuhp3z8M3vOWeGOJkBXiPTs0wQrJ9k6QXOm/Z+lN6G4l5e9eJcurg0L3lLVky3EeQyETG9tqNQEvxk9V790JLa9bEX9uSZIdUz56KWvi+EWPXbulz7lfINoD1ZqWSAW5PSwbixblMKUhEJekYzVNlpFpoNY5IBgcaxuCw/XuMQTEed7KgDcV0PVJRLbyJZsgvETtvMIjbWfw5xcqws+oYh+oHEh3id/MXXKpsuYlamAOX72sPpfLbTvpUHgkWODb/oigAzU9zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5TzfwI1zZQoi7/k0z3Ylhe8LIlBUoOxGnIFKxmIZR0=;
 b=DZv/rhj4x+4W0slZNlbY8losBd7MoHQk5qlq0IOyaSrzna6TDhDqOd1v5dPyqH/f8ljRNYKDaMOPlamriJ0XcPDGQvRlZyuAfOS3Ktl2vc3RaKczkyhJU9+4JFtYTnOytdbkfwpuV+Uowgl2j0dtVXGWe/vIc9MMtDn4+WnTFY8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) by
 DM4PR12MB7621.namprd12.prod.outlook.com (2603:10b6:8:10a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Thu, 12 Jan 2023 16:24:18 +0000
Received: from DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::2fd1:bdaf:af05:e178]) by DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::2fd1:bdaf:af05:e178%3]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 16:24:18 +0000
Message-ID: <663dd4d4-6b82-af8f-f69e-6d3b7742cdbf@amd.com>
Date:   Thu, 12 Jan 2023 11:24:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH AUTOSEL 6.1 5/7] drm/amdgpu: Fix size validation for
 non-exclusive domains (v4)
Content-Language: en-CA
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Alex Deucher <Alexander.Deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        AMD Graphics <amd-gfx@lists.freedesktop.org>,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Felix.Kuehling@amd.com, michael.j.ruhl@intel.com,
        guchun.chen@amd.com, Yuliang.Shi@amd.com,
        rajneesh.bhardwaj@amd.com, Philip.Yang@amd.com, sunpeng.li@amd.com,
        dri-devel@lists.freedesktop.org
References: <20221231200439.1748686-1-sashal@kernel.org>
 <20221231200439.1748686-5-sashal@kernel.org>
From:   Luben Tuikov <luben.tuikov@amd.com>
In-Reply-To: <20221231200439.1748686-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4P288CA0002.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::6) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|DM4PR12MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: 97f06cb2-6ec7-4df3-c951-08daf4b9744e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bOaDwD86PPBu4f27NmVZeceBGKo29vi0fCletYegyfa+Ao/hrkunowpoOUkUTZC37cO7NRjsm0NLKHx9mO0DuzaN2t/MvSI0cDpF36EKvrejg0CmT8L0B+/GYity7tNCw0RLEzb7lbvASK/Du8ef+gSW7xUwN1JAwhR6BdVuLueA5X8dqTtx9cXYWmn9Gx3ATwQq7u0V5QRph1KtmW1nVuXR2Me/SNqYLTrFwHseXVRbfqFtBZQC6eWPVFUhxn8fyILEKqaXEsRJP4EwsRmDCvGAgv6JpJoZdIWEZZEwzwUtWjgOuxFfK85X/NsR4Wlbw/0TotZPUJSIB4MwqSv52/f720meWMXPQCtOJ+Y7HpYqNo/WQsoSCyKvvVyEtgKHkxvhTWpiODb0J2ULkuv7LYaPs2SyM3iAqMbVrQdHKjTSq+mtIb4KdNXqW3uXVum6osD9XuAzP6JOQSKbRcbauZiqjv2f+a22V7kKwFKUbT0IEjdQx2OKL5shrg6kKNddLz2JWugMvbtN1nPIhWRA8RyS0Jhb78y0WLLTmEvIIEam/lpLVOCAVKm2YxO1Bg/th51Qp1gCFw5foEQAX+K+ngR6whGz7LUksRCSRL94uBxGwMp+s6LO8PJdDfOGeE1/Bl7P02MEOez5FviICtrHAw/+TLN5T+R7+hBfvCWezzNO+3xkNW52lFFG4Zp0xXnYlgZfmFmnQhLJ2pG4Aij+g/0zqZZaUNNhXmNmHku08mv0BGDCYLHrA1FjIf8XLy/e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199015)(53546011)(6506007)(2906002)(4001150100001)(6512007)(186003)(6666004)(26005)(478600001)(6486002)(31686004)(966005)(2616005)(66476007)(54906003)(4326008)(66556008)(36756003)(66946007)(8676002)(316002)(66574015)(41300700001)(38100700002)(5660300002)(44832011)(8936002)(83380400001)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkhpdDRWSEx5cjNMYklxUHJoK2Q2MzFsSDFKalljWkFtVEpSQzhDNnBqNWNz?=
 =?utf-8?B?NXBsVVZ5YjgxM1F2TlBQOXhqRjBoQTFRbjl4RzIvbDJUYzAzdUFFNTJ1dk1L?=
 =?utf-8?B?QW5wZ2pGZWxVaFhEVVMwUlBiRDRMclQ1SXNFYVYremY1elZ2MkI4blNqSUZI?=
 =?utf-8?B?RDl5T0pYSzlSUFJ6M1VTZFlLelBkUEJFYkg1T3BjeU1LOVF4UlJtbjFtRTh0?=
 =?utf-8?B?VS8wNWJyaVI0SDcvb25hTHJBTWdYL0E3Z09zZVZJN1N4SSs1ZUx6aHduTDBY?=
 =?utf-8?B?OEhwZDBiSEY3bUd5NWp2b0taN0lqVUtkZUs0RkE4bmk1dVVZQnZmanVBam9n?=
 =?utf-8?B?Tk84TXlTdGdnd0pIcHl6WDNVSW5LQVQ3ZkZDMmZ6bnE1VWE1d3NEYzVMbTUy?=
 =?utf-8?B?UGp2alJISXFpeUQrWllKcXhNY1lnaXlFcGR4NWJGRm1NQTVGQitBczMvUWxt?=
 =?utf-8?B?TnhYdjkraXZrMkZIMXZtK0FESWFVanY3emdRdTZyWTB0dVVPOFJ1cVlDR2Ni?=
 =?utf-8?B?WWcyNEU4aWxEVUo0QmFTcjk4eW16QVZ4RVNVaGJOQjh3c2tpSXlwekt0UDc5?=
 =?utf-8?B?c1NmZE84U0JBZU4rNXNuM1IzZ2NveDI3ekczVy8xU1NER1RXMnhoWGZtQlZT?=
 =?utf-8?B?dWlxWDBUOW1JL1BHVWUreS9DaDg0T01TKzZIMlRtS0JXRW5jWGZlL1hMWHJ0?=
 =?utf-8?B?bHNJZEtDcGI3U1UwWVlkZjMrOUlIUDlNYWZQRThDRGxjSXJtODJ6TkloZHBW?=
 =?utf-8?B?K3NhUm1sR1JxM1czRlR4c1AxNnFKcjBicS8ySTcza1V0ZzFvakdxQmFQMXlj?=
 =?utf-8?B?TWY2aTlNRjRleEcvdDVuaVpxZVQ1QW8wVDlHdnRSK2NEdEY4WnZrMFhnUldD?=
 =?utf-8?B?OWZCdWtXbFJHQUQ0SlZ3QitmSm1GTWsxcSs3Sy8wV2hOcVZDV2VaaFhoeTFa?=
 =?utf-8?B?MnY2d081OVhnWmpUTkpJbE12c1A0VEVCeVg0Z2xzTmo3ZTIvVXMrQVplaUNE?=
 =?utf-8?B?Y1BFT1VpU0pPT1RnSDBudlc2SFRwemVERXMzZEZqVGovZEFnQWxpZlVjMCt1?=
 =?utf-8?B?M1FaY2tSZndDRm1kWDZaSFJ0UW9vd2hKSkZTdG81ZW5XT3FwaXFRZGViMWwr?=
 =?utf-8?B?aStXQTFQZytlOUJVd0NLZFdRdVlrSEE0UW1qUmZNd2o1Q0hkREtlN1ZpRzQy?=
 =?utf-8?B?MXM2bVBobFVmVWF0Z3dFV0dKbk5HMDZHVlRQb1o3V0JHTU1lWjVUQ21rSWhX?=
 =?utf-8?B?WUFKdXhBUkVUNlVLQkVuaDh3V3F2VjhsNVhJcTM2YkppdFRYVjBtWGRTMlJr?=
 =?utf-8?B?NXZDY2Z3MDFJOW1NK0hPTEFvYmtiOGVVdEhrdkw2TUJlZGVGVC9pdHdycHVw?=
 =?utf-8?B?NENhemdXdWRneWtyNWVCd3lPbTZPQzZ1SmFjcTNqcVF3aTlwL1lXTnA3RmJ6?=
 =?utf-8?B?dENEaGVzZjNjWThjbytiTnRWQlJBRlg2L2VpaEdyUU1naThDb0JteXlxdllj?=
 =?utf-8?B?R0xrM3lJRHVXU1BwT3FMQm01VGM1c3ZCK3RBRmZMY1Nvb0cxek94YUZjM3Fq?=
 =?utf-8?B?Tkk4aDRVNlh3WVlyUndjZXd2L3R2RDFFNmt3TGVIVzNMYUZxWnNyWEpSR29X?=
 =?utf-8?B?V2E5Rkc1b2duUk5aME5MeG5uaUtyTWdoZDVoNGlXQW9IU2FIVFVKTWJqZ2p3?=
 =?utf-8?B?dUNuTjdCMkF5VDZVc3IwaDk4bU01WUJlalFVWGVldXJzbWFDMTV4V096MnQ0?=
 =?utf-8?B?SU91NlVkNnRUSC9kSldZOGErb0laZ2Jic3F3cTJ2Mk4xZGJIYXJBT2p0bERt?=
 =?utf-8?B?U0k5bWFZTU5nODNpVUJja1Jka1hrQ00rc08yNW56TWNKQ1Z3aXpPdThmNWxR?=
 =?utf-8?B?Rk9DME5jc3BTV243K1FvaW90UU9rcW5GZkc1MVkzL0k2VDF4OEVLTDRUKzhC?=
 =?utf-8?B?cUJMN1lMaDV2cW1oMWNZSWhkQ0l2T0Z2RFJuazFrYVA0UzZqc2JlTVhkNmpG?=
 =?utf-8?B?R2VlelBFUU9CVGpPVFRPSlZOdzJhejZYU1RDcTQ5Q1crYm5qTGVIWmtrNDFQ?=
 =?utf-8?B?bVBHNURsa2tQQUNzOWd1SFpUbm0yMFQwVkhtY3ZOWlA1L0U3dUJ3UmhMYVI4?=
 =?utf-8?Q?wn5NJtxEQU94GIjCT8gJPMVCa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f06cb2-6ec7-4df3-c951-08daf4b9744e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 16:24:18.6918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JModz1lm8Do88l39Z4rq6hfIvHpJUqJA1aOfwlVzFkyRqj79Szkj5LRhDj5fcpaT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

The patch in the link is a Fixes patch of the quoted patch, and should also go in:

https://lore.kernel.org/all/20230104221935.113400-1-luben.tuikov@amd.com/

Regards,
Luben

On 2022-12-31 15:04, Sasha Levin wrote:
> From: Luben Tuikov <luben.tuikov@amd.com>
> 
> [ Upstream commit 7554886daa31eacc8e7fac9e15bbce67d10b8f1f ]
> 
> Fix amdgpu_bo_validate_size() to check whether the TTM domain manager for the
> requested memory exists, else we get a kernel oops when dereferencing "man".
> 
> v2: Make the patch standalone, i.e. not dependent on local patches.
> v3: Preserve old behaviour and just check that the manager pointer is not
>     NULL.
> v4: Complain if GTT domain requested and it is uninitialized--most likely a
>     bug.
> 
> Cc: Alex Deucher <Alexander.Deucher@amd.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: AMD Graphics <amd-gfx@lists.freedesktop.org>
> Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> index 2e8f6cd7a729..33e266433e9b 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> @@ -446,27 +446,24 @@ static bool amdgpu_bo_validate_size(struct amdgpu_device *adev,
>  
>  	/*
>  	 * If GTT is part of requested domains the check must succeed to
> -	 * allow fall back to GTT
> +	 * allow fall back to GTT.
>  	 */
>  	if (domain & AMDGPU_GEM_DOMAIN_GTT) {
>  		man = ttm_manager_type(&adev->mman.bdev, TTM_PL_TT);
>  
> -		if (size < man->size)
> +		if (man && size < man->size)
>  			return true;
> -		else
> -			goto fail;
> -	}
> -
> -	if (domain & AMDGPU_GEM_DOMAIN_VRAM) {
> +		else if (!man)
> +			WARN_ON_ONCE("GTT domain requested but GTT mem manager uninitialized");
> +		goto fail;
> +	} else if (domain & AMDGPU_GEM_DOMAIN_VRAM) {
>  		man = ttm_manager_type(&adev->mman.bdev, TTM_PL_VRAM);
>  
> -		if (size < man->size)
> +		if (man && size < man->size)
>  			return true;
> -		else
> -			goto fail;
> +		goto fail;
>  	}
>  
> -
>  	/* TODO add more domains checks, such as AMDGPU_GEM_DOMAIN_CPU */
>  	return true;
>  

