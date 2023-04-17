Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6CF6E3F3A
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 07:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjDQF7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 01:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDQF7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 01:59:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9040026BB;
        Sun, 16 Apr 2023 22:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhU6Owv5rTdjIV5RyAIeKazpEHudkEMSaZMV4SUPEwv9L1VP52Yl9W2bNOeCaFBVxeRBKlxi4sgDXslpSi2f5xn1Mml7a8xqDJ59rBT6vB0icAoFWQzRYzgu2g+Z1QnMLjFSOHJKHGSdM0sHrPWAd2xSiWE4jCx2bcgdItsaaGJqLgCo4V5rYkpZTFyItdDqwMzT6S1SC2TjZ+NZhvW7Eh1NqDI1QQYepAfwT8EF9TKuAK3ihvyrk73va+391iFhoOv7r2xbqOi8QQ243g1v0GjIUXJtg3aOfLsaqgZleIBNLitzBAkA8PZLuLc85ShFKHcweI6cJpyVKLJPgnvm2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SROgRE4G+oACm/3ERzYcLWqLe4BeaOBlRhMXsx5Pfs8=;
 b=TTwMkBUNipnT/+/LeWR4NgaJ/XNZJRvPNMNeOm4mDxDuvb58+mfn2szebrfNleIP50gaBHWv6BJfLOvmaFbk2192kuAmOxR1YNk7/I81kRBBbXGDx78hyqdAto4SvY9B5b9rW+aRQihVF+lnbmONc/g/YPl2lRc8fdvApFYAmKCy6h88RGnJCq9pab/WInD+kWeDA0JDfAY5drJrosLjXCAHfF6FyFMqFdqDJxogBcRNnLrugbw4T2C063w8NMBVYA0I5QC1XEMOSb+5GEvYKEMX0EDpSn8CwcGfFYs0fdd8Fp1uFbURx2IH7Fqx+c6Id9MBn2/tWLE4r8UkgDRZig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SROgRE4G+oACm/3ERzYcLWqLe4BeaOBlRhMXsx5Pfs8=;
 b=SYmgqhxO97PHn6We4EEOlGBbqg85Ax6P2hlG1IGnZy9Qf1sG5qkMTm6GN0eYwHOe0ufWhI7Y2hZUmLsXzdhbftAkEoClSr3THfna0i0agmZcqiIFfj8TzZNYjKC3x44B6Sn5uYbN2bGJnHrqRJZD5CDs3jAdNPtn85o0qXhPdPo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by CY5PR12MB6155.namprd12.prod.outlook.com (2603:10b6:930:25::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 05:59:40 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed%3]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 05:59:39 +0000
Message-ID: <4207e848-4e79-29a7-2bb0-44f74a2d62c7@amd.com>
Date:   Mon, 17 Apr 2023 07:59:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] drm/amd/display: fix flickering caused by S/G mode
Content-Language: en-US
To:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230414193331.199598-1-hamza.mahfooz@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20230414193331.199598-1-hamza.mahfooz@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SV0P279CA0054.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:f10:13::23) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|CY5PR12MB6155:EE_
X-MS-Office365-Filtering-Correlation-Id: 38cfd69f-2b04-4dfd-86b4-08db3f08ee13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /D8wSCTjXTVCSfgFjRwgf5UORBfZVGGgbtXlAiFiJGXD73rMmZEGa6WtKRH/QaOt0S5Gc3YMLXpz+txY5I0y7Dnv38JFTTOezT6l03tv/yWHGFjHGIxO4cgdSjHbnmHZHU13b+CStyl+Sfyn9Q9loebMyYEd6hE7UHXn3syqdpJQ8cxMaUcWsqqvlDT7O4oq6Y7KhWcn5Sogk5xXyet4+TkGXdeDQCD1btmjVkGl6bQB5ieuFm5UMEJchPXq+9INvpff5RNBiBHToxCnot2LIh2z74yxmhTCrXsmikQ6OjBORnt6WuhPP7Uj9xbMwv1HMl0XwADilXxgyly3zVjs0QmpNUw6ArDuLH7IhvgMRVQp/8IrSiITDv5bx4ZiymYEd8yFIEqQw+hNBrz4OfpMQesKiAABQBU4JiaY4EXiPhPnmDNJbtXk2Vxb5mLfmwcfOfO1XUKjQYxio1dC2TcQlunQqGydR3jVnfzoMAIsrcS/LxbeiPPK/f3dbTqL0a2u0GZ7AEGWxdBioBnZ3DIKb32q49FP0C0Wqa3hvfckGZXsHFNp73bYbNECGjaH2YpFMn0OUVD4eCFUvCEyWQSN+WaFMks6CiDqf16vIuYEAaOKytWz2He8z1dgLoCE8LI/yGsT1OHiwxjl5Zu9tg62iQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199021)(36756003)(54906003)(4326008)(316002)(66556008)(66476007)(66946007)(6486002)(478600001)(6666004)(5660300002)(8936002)(8676002)(41300700001)(2906002)(86362001)(31696002)(38100700002)(2616005)(26005)(6512007)(6506007)(186003)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGNRQnhXL3pEYkYxSG0zLzREM1BEb0VldHBZV01BOVVuTWJXSjlwby9QdG43?=
 =?utf-8?B?YVAyK3hJWTVJdE1sbmIwT04vemZYNW1MZHJ4R1gvdW0rSzJ2WEtiNkNlQklr?=
 =?utf-8?B?MFBDRUs0cXZPQ2hqbFoybndtcmdQb0dNY2l3Y1JIazFidFY1TVFlYVZGbU95?=
 =?utf-8?B?bnZVb0FsQXBRVzR4N0lxajJ0YnB6NjZGQjNIdU9OaUpwZGJrbVhLeld2UXBU?=
 =?utf-8?B?bDk2RDdKa0NwUkgzQkRQS0RUYnZMMzQ0NGV2QUVmTEZjTUZOSjE0U0xDOUNt?=
 =?utf-8?B?ZDVQZ0ZBdXBkSG5SR3dtZjg2RmFkM3JkUUdqQ2MyajUxbktMdm1pek5tZTJr?=
 =?utf-8?B?Uk43NXVHMmRjOXZ5MFo4WUFNVVZjYi9TMmlDbWFQaUk0UXJXR2V2aDlIN1Mr?=
 =?utf-8?B?WUtpZnZ2STMzQThibEI3OXBJcXVGMUFWbVlWdERjaC81b3FEa0FLK2R3emww?=
 =?utf-8?B?Z1UrZ0hrdU9vdDBpWWlYVStBbFEvUlk3UUZZa3NIYzBpbWFkd3pOeDkxNkZz?=
 =?utf-8?B?N056ZWFXb3lxMk9xMk5JUUlWS2xzRGhuQUx6NE50Smg2L1laZVhqbTZyejJk?=
 =?utf-8?B?UUhpSTFHWlZzQ2xFaWI5S2hNc0krRW90Tk1veGFqOG9tS3RuaTVscG9qU2N6?=
 =?utf-8?B?UXdmRWw1Yy9JeTRrVDBaSWlUN1dWQ0NKcFBuL0Jwa0d4Zm9xWUNMcm9XMGN0?=
 =?utf-8?B?RWt4YWEwYTU4WW40bStqc2F2Q05MVFA0clFOYVZoWndYeXpMTDI2bUIvNE4v?=
 =?utf-8?B?WjJ4aHJWQnFrL3JkY1ZKYkdiM0hzUEZuNUhpRk54Qm9BNmFHdHRxVWVRbkZ1?=
 =?utf-8?B?aDZPbVVnZ2k5Z2JxVGRjTGNSMXorVkgxcG84ZGlWbEYzaTFCekpqZkNxUnRa?=
 =?utf-8?B?cHcwYnZkN3RWbjRpYnZuVGRmM3NIQit4ZUh1YnRZZnJnSHVSc3kyVU1uRHY1?=
 =?utf-8?B?U2lZdVVnOFFtaFVieTVwK1FrMVJCR2xzVTNNYkNBZERVQy8wU1JnUVN6TDM1?=
 =?utf-8?B?ZGVYU3NOdVZOUzlacWtuOXVQdERhcU5BWkI2aFlFT3VEUUJXdXZweDZFTmhW?=
 =?utf-8?B?RHZvaThLSnVucFZtUlpNODJZdjlZakNWY0dWbXd1c09XRWNHcUNqVVFuS0dy?=
 =?utf-8?B?bnM4NU43Yzl2WUdRY2FYMVczeVNQS25xQ3FnZ1lhRlhaeFpIblRxWkdvWFpm?=
 =?utf-8?B?UTh0UmdkM2xZL3lObFRyQlZXNDg3ZS8ra0pwcjY1U1ZtUlREeEFBdm1HT2Yz?=
 =?utf-8?B?YUJWVHNJNWMvbGIzeWhYL2tjc3c0b1NjOUphRTVvbnFxNG50bzY4OHlGMVQv?=
 =?utf-8?B?anN5Nkt6cGwyaVlZeTg0cDYxT2tmY2R5a2xZbTZhbHczT1FrUGNjTVZpRDhL?=
 =?utf-8?B?Y2dGTUlDVXM4ZkIxUEo3dFl1SHAvOGlsYVlmaUd5bm1JR0tDM2RqWEVSR3Jx?=
 =?utf-8?B?ZXBiTXJjb3hySUoxd0RvTnR6TnNjNndRU1Y5YnNSOTFRL3UzYmtIM0FQZUc1?=
 =?utf-8?B?TDJFbTFBVFFEOGI4TStLWFVJVC96RmlDQVpqUlJOWjcrb29jWkM1R2lvTXBP?=
 =?utf-8?B?bHNSaW1iZ2tta2kvWkl0OHd4M2MzdWJ0b1EyTSs5UXladElpaEtIaW5rSDBz?=
 =?utf-8?B?WjFKNlFSa25rcGQ0S0NITlVuM1RuZE9jMnA2ay9ZWnF0cnd4UGtSQmxjb2V6?=
 =?utf-8?B?ZVdCTE43L3U5cVc0QVZSM0xxaDJLQndFVFdHbWFEdmExVlltMnBwdmlwaUJC?=
 =?utf-8?B?MFBESlEwcWkrMFN2N1ZocGpTNnA5ekIvYVg1OUY5UmFOTFVPWDRaaWpvdENX?=
 =?utf-8?B?SnR1N3VUVlFLQ2ZEMWI1NmR0RVpWbEV4ekw0WEVURHdYWGdzVHkzc1I3OTdl?=
 =?utf-8?B?K09XSHl0azRndEpWY1JnRFdKZEFKTHNlT0VWbGdYM3I2cWFkQ1k1NVI3Kyti?=
 =?utf-8?B?ZjFETUhxMXdIblVPWDJSWmEvTWhVQUJKM0Q5UGNhRVlxdi81ZU1RcE5RTS80?=
 =?utf-8?B?WDdTRTN4TlNkbkJwT09OSVdUQnVDMzdkMWNFd1I4QU16bkpDczVQOHhRZGpv?=
 =?utf-8?B?WVVpNXk1RVFtT0hJcFRtY3FGZFhzOVBMRzhhR0hPUG1oY0VsdE9xYTJ0RXNp?=
 =?utf-8?Q?uRFc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38cfd69f-2b04-4dfd-86b4-08db3f08ee13
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 05:59:39.2650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MbjANUPOQhW2OF8MN/TtBjpHqodm4aw8gAPz03IYSsSLfSpyzbAH0D0oM4mGEMPJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6155
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 14.04.23 um 21:33 schrieb Hamza Mahfooz:
> Currently, we allow the framebuffer for a given plane to move between
> memory domains, however when that happens it causes the screen to
> flicker, it is even possible for the framebuffer to change memory
> domains on every plane update (causing a continuous flicker effect). So,
> to fix this, don't perform an immediate flip in the aforementioned case.

That sounds strongly like you just forget to wait for the move to finish!

What is the order of things done here? E.g. who calls amdgpu_bo_pin() 
and who waits for fences for finish signaling? Is that maybe just in the 
wrong order?

Regards,
Christian.

>
> Cc: stable@vger.kernel.org
> Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible (v2)")
> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
> ---
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 41 ++++++++++++++++++-
>   1 file changed, 39 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index da3045fdcb6d..9a4e7408384a 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -7897,6 +7897,34 @@ static void amdgpu_dm_commit_cursors(struct drm_atomic_state *state)
>   			amdgpu_dm_plane_handle_cursor_update(plane, old_plane_state);
>   }
>   
> +static inline uint32_t get_mem_type(struct amdgpu_device *adev,
> +				    struct drm_gem_object *obj,
> +				    bool check_domain)
> +{
> +	struct amdgpu_bo *abo = gem_to_amdgpu_bo(obj);
> +	uint32_t mem_type;
> +
> +	if (unlikely(amdgpu_bo_reserve(abo, true)))
> +		return 0;
> +
> +	if (unlikely(dma_resv_reserve_fences(abo->tbo.base.resv, 1)))
> +		goto err;
> +
> +	if (check_domain &&
> +	    amdgpu_display_supported_domains(adev, abo->flags) !=
> +	    (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT))
> +		goto err;
> +
> +	mem_type = abo->tbo.resource->mem_type;
> +	amdgpu_bo_unreserve(abo);
> +
> +	return mem_type;
> +
> +err:
> +	amdgpu_bo_unreserve(abo);
> +	return 0;
> +}
> +
>   static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>   				    struct dc_state *dc_state,
>   				    struct drm_device *dev,
> @@ -7916,6 +7944,7 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>   			to_dm_crtc_state(drm_atomic_get_old_crtc_state(state, pcrtc));
>   	int planes_count = 0, vpos, hpos;
>   	unsigned long flags;
> +	uint32_t mem_type;
>   	u32 target_vblank, last_flip_vblank;
>   	bool vrr_active = amdgpu_dm_crtc_vrr_active(acrtc_state);
>   	bool cursor_update = false;
> @@ -8035,13 +8064,21 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>   			}
>   		}
>   
> +		mem_type = get_mem_type(dm->adev, old_plane_state->fb->obj[0],
> +					true);
> +
>   		/*
>   		 * Only allow immediate flips for fast updates that don't
> -		 * change FB pitch, DCC state, rotation or mirroing.
> +		 * change memory domain, FB pitch, DCC state, rotation or
> +		 * mirroring.
>   		 */
>   		bundle->flip_addrs[planes_count].flip_immediate =
>   			crtc->state->async_flip &&
> -			acrtc_state->update_type == UPDATE_TYPE_FAST;
> +			acrtc_state->update_type == UPDATE_TYPE_FAST &&
> +			(!mem_type || (mem_type && get_mem_type(dm->adev,
> +								fb->obj[0],
> +								false) ==
> +				       mem_type));
>   
>   		timestamp_ns = ktime_get_ns();
>   		bundle->flip_addrs[planes_count].flip_timestamp_in_us = div_u64(timestamp_ns, 1000);

