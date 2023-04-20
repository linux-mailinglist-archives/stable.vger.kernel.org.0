Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CD16E9848
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjDTP2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 11:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjDTP2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 11:28:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C7B40D2;
        Thu, 20 Apr 2023 08:28:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bp+VJVBqCURjRNEZCfoR1hZxw4wPT2pR14cQxEiZlM84qlijiLFwZq3EVgtlLXpXmPGp9Sp9yfsRbxkUhMI2zIANkFjdOaGw7/0nMy1cz7vw/iA1v9Gi/8BEnT7YXxMr2IsiNsb6xjzp1haEMpQ+HBfGwpkWv4A6KJmSmnSZgvr/GY3tAUhDemrfbsUoMcBKieTuCGfT2OEC6L0aV7GVwNbwJ0xZVhCspbxHAuNB1nReV3gQlMJMSkFmDGAbe9kPSj2+GtcOvouhCXjB85GG0c2lKF4A+qxMl0Qf4COo6OdauCrV1iHdj6hGOY9ls1RKXQ3IquaOerm3eI33WcXk0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42JS7JMlQU91XCZfk72iHgMMv2ATWoaOyLghw9p1a4s=;
 b=ODv7T3UYJZCXmYQk96a3i3nowKw4I7usxq7fFFGh++1cnRj2vFBqK8w5bg5pIlhbAYzINux9kGBiu2Ea5QrEsphVqUSqM5aMd9FN2MUCbvD2zj+osZD0hklRWE5fKuiYyPooItLwvwnTICQyUSyfzHVy2sh8ukd7DVVEUtFwzDgONUouo3AZu0Cs0uJEWgXmZK8yBodLwaEAeMws73G7OAsWk52ij8OsxYcUJV7kCRlPDtMhTn22fB00clc7MlT0zUsb9+wQvQ8/bd8gMnvlYKvlhamJnirE8rQfcMPg2XXsfyOZyiDpUIdceL5OFHfPr5UkeNhpfu057mm39kpccQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42JS7JMlQU91XCZfk72iHgMMv2ATWoaOyLghw9p1a4s=;
 b=hlPNyNTVFRVfVJD1DVZT0ew8lFquX2D4mYB3ayQDsJ2000PpReLROY92i0VgG/LUmkQueOnfuAYL3M14KQduHtpSQxmI5HyJ1EGPtH6y4+apzC27B5PI80AeUy2pvhVpv/rlLXvyWeEUE1w/70Pcugo8T/A74gzs/TEcO20u4Yg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by CH3PR12MB8484.namprd12.prod.outlook.com (2603:10b6:610:158::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 15:27:57 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 15:27:56 +0000
Message-ID: <9b99fa5c-5b47-dde5-4c4c-3ae6a8f621e3@amd.com>
Date:   Thu, 20 Apr 2023 17:27:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3] drm/amd/display: fix flickering caused by S/G mode
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
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        hersen wu <hersenxs.wu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230420134414.44538-1-hamza.mahfooz@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20230420134414.44538-1-hamza.mahfooz@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::6) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|CH3PR12MB8484:EE_
X-MS-Office365-Filtering-Correlation-Id: e1bfd39a-15a3-4c64-619d-08db41b3d0fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q4S5IdKE9VCiaMKWMr+sOg0S7iAAhSBod0i7hmEBa4o9/DZ7t0v0BEe8OTQkyrXbdmbk6aA53qHaLQT2IJKly2BEES3e05gRU5whuZqm/gEOyF+iItqk7bLih9CZXFy6QrRsJ+p5BUqtFBSmn/B6Z2JxFDt/eC24CRHDj/3B4sfjZxdU4dWK65qPdnLyCrZRTlB+ynULfqztR/BNc34ApdH9i67Cs7lgbSR1NbXnBJciArDe9s6P6x/yV8unUAfD2qJyQGwOGWMFE1Y5sRdeK3nLLPLb1Ny6O3MUZiFTTmKRl7m2Gqd9Ax1RtacPxGd22aRN5WFapR3X4RfLtJuAXSIiN6XLFCmTAapZsKF7sUPBdoX3E0Ce975WM06m+VMitolJaC+C8wubZmLO0KcfEYsCPZCKw8/fsifH/AMXW78aFH7CJZdn9troYUKGRL38bLI43a+xAAAT2aTACZeLomNyQwjYHdtO9kcBmXFx//NepJ4uoh2j/i3jtIjp4BHJvyAYOqY72V7AGyeDvbfVWZiBTXS+lfBHZ6Cl9QVtsO710gflICK8JgUeUNoejIVa+JbAJwQgcl0TxdYzLB/7Y6iHWF64WxGFeTroRe3NdjM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199021)(38100700002)(8936002)(8676002)(66556008)(66476007)(66946007)(4326008)(41300700001)(316002)(2906002)(5660300002)(186003)(6512007)(6506007)(36756003)(83380400001)(31686004)(2616005)(86362001)(54906003)(6486002)(31696002)(6666004)(966005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVc4VC9Ecm9qL0FRRzlrWm81YUFBMW0rbWdiaUNPR3A3d2ZUNEZKZG5jK0NG?=
 =?utf-8?B?enA5b0tyWmNQYS9jekY0MHRpcW03V1ZPaUZKQnZZMWFmaHVUZEw4V0x4U0Nq?=
 =?utf-8?B?ZnFQM25RMU9lUFhuY3VoTVk4VkNFREtiVncyRFhTc3d6RzNEL0g2bi9OWVpj?=
 =?utf-8?B?WVUrenpwTUhXclA3K0VBaGtRU0xMQ09MalBRK1ZRWEw2c1JOSWdXeStuWFdQ?=
 =?utf-8?B?dnhUR1pSNTFBUHRBNFpNWTNVV3pST0lCQVdsNnpHaGVIMkcwWnh1UTcweVh2?=
 =?utf-8?B?NDZMM3N6WmdJU0tGMTRxS3creEgwVCtWRHlpQUVXUUVLK3VBRlhaN0RzUGdR?=
 =?utf-8?B?OGhIMTA4MmQxa2Erbm1IZDJaUUNLOGtadDlPODkxYXJIYzYxNldRd3NWN2Nr?=
 =?utf-8?B?aHl2UmtycDA1RXl0ZnlXZmtYV1UvaWRyOFJSYzFVY1lyNTFVTWE4ek9XUThG?=
 =?utf-8?B?NUVtWGZ6SWVEN3dmRmNTSGxXa09BQk5lUlFHWTZEQ2k2UFVKOEtZS2tYMnZr?=
 =?utf-8?B?YWpDcStFNWYwSWdhNFVGMmpSWURqcVh5STlVYi9LTnFoaDBaQ0UyYmVkTmZL?=
 =?utf-8?B?amZuM25wdGdYU3hJZDBGR2pQR2RXdWdYeE93RVBmU0VMbitkaXFocFN2azZ2?=
 =?utf-8?B?NWpKZ1FQVGgzdWVrTnVZSSt4V201aTcvQ2J3K0UrKzVDM0x5WkI5aFZ4aFVU?=
 =?utf-8?B?S3RUdWtFL1lZYXowNDNKeXJESjZoNldNejVPbVY1aUNLcmJORFhVVGRadE93?=
 =?utf-8?B?VjhrTXl5VW1XWnQ3VTFmQzM2NDI0TkRMTCtyK2dPeEhyWllJRUN5TFByQWZU?=
 =?utf-8?B?RlUvMENGanF1UHN3M0h2Z0JkZzdFeklLWDhqd2ZwS2tlNkhTYjFNWm5ZM2N6?=
 =?utf-8?B?NmhCMHRSU2V2eEhwVk9ZclhyK1Z4d1p2RW55MFJrTHBYRlBRVHZoUHZuN2tm?=
 =?utf-8?B?MlJZZVNUdmdNV3lFOHJhUGpzL0ord1V6YkdBZG94VkxSYTFwYkhMVVl4MWIx?=
 =?utf-8?B?cFJpeGRqNWhyTm43OEQ4N2JHK1ZOWUlIUWpzdG9hUlhPYzQwZ0RROFg1ZlRl?=
 =?utf-8?B?Y1hNb1pRREVwVzllK2lyc0hLRGROTFEzMkljTkpMRGlCWThYbXh5Ryt3OHVE?=
 =?utf-8?B?blhkTTYrZkpmZUdWbk5DOUNJZkZ6U2pSZkZOR0l3TmFpcm05R0tBcjhhREpN?=
 =?utf-8?B?RnpXZTl4OVhNVnBuZ3BLU3dYN3d0S0xkTXIyR1JKZzRhM2dKQUJjZ1dOU2VP?=
 =?utf-8?B?dnJNY3RVaTdnYnZoTmkwQmFrQ29UQldRZjd3OC91bGs5OFpTNUJtTFcrWEZ5?=
 =?utf-8?B?OGdkTWhDalpRb0NKQWJnT0tqNjlGMFBwUkVNWktRSjdLVTZtOUZoNWZ6bW56?=
 =?utf-8?B?Y3FXTmQ0NTQ4NzdNa0hMUmRnSThFNnd1MjFDYkthYnU0WERJNXdUbnREZDZr?=
 =?utf-8?B?T00rWFdXVklUTHRYZGxEenl2UUhsek52OUpsVlJyWVlRV2FhQytlcSs1NW1t?=
 =?utf-8?B?NUJiS3AxV3pXRHUwNDRXMzFCc1Vkb1NSdUFNdWtGR2RjZWVWWEovTldXMi9S?=
 =?utf-8?B?cHZhdHZvUDh1Yk9nejA5UzlCc0kxandKQTArUEw0N0YwK1NtbmFsOEdxTnp1?=
 =?utf-8?B?SmoxQXQvakZBczVpdkJpazhZM09WMUR1V3ovNDNwNkxpdlcrZGdVaGRXKzRy?=
 =?utf-8?B?MC9laXhPZzFZOUtqWXhCSjQvWHkvSnl3Yk9JeGl2UkdWQlRCSmQzakEvdmlu?=
 =?utf-8?B?bDRpZnNjUnpTRjVTU29pMXpJak12ZDJDbEZHN1VQVERha0MxTWd5c3FmT2pm?=
 =?utf-8?B?Vkl1SEoyekVML0Rad083MUFIeEhsNnZTcTRFSW1PbjU1UHptWEYxUThUNThJ?=
 =?utf-8?B?U0YzeVkxb3pXamdYY1lpcXphc0N1TXUwOGdjbGwzUVl0Q3BxWm9yV0xJTVBh?=
 =?utf-8?B?dCtoSDZ0cnp3WnIrTUhEVUxCRGxSNkJITDVRZi9sOWtmcmNMVmlldHB5TUJD?=
 =?utf-8?B?OEk4MWgxb25mVEFpaVVLcEpUZmV5bFU3dUxUdDRBUy9qeFF4R0RVVkppZm1D?=
 =?utf-8?B?VEF0OXNrWHFxbENCNUw2MjhRNitYV1FTRHdRYmlScXY3bElMR2F2akdJOFBS?=
 =?utf-8?B?Wm1DK2llZ3U3SFpORmNvVkZERldVNGJCS3lIWG15K1hKalJscW1YNWRvOEhM?=
 =?utf-8?Q?x8A+Tk7i1tZ0OQ9//j15NAUdyuuqDDByW8Cz2bKZb/v5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1bfd39a-15a3-4c64-619d-08db41b3d0fe
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 15:27:56.7882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QcWE7B1rY86xgl9u9iNnxwzhKGopo36Xl+GUakL/ltNV84RxBOGu/sadAFL8RiuG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8484
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 20.04.23 um 15:44 schrieb Hamza Mahfooz:
> Currently, on a handful of ASICs. We allow the framebuffer for a given
> plane to exist in either VRAM or GTT. However, if the plane's new
> framebuffer is in a different memory domain than it's previous
> framebuffer, flipping between them can cause the screen to flicker. So,
> to fix this, don't perform an immediate flip in the aforementioned case.
>
> Cc: stable@vger.kernel.org
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2354
> Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible (v2)")
> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
> ---
> v2: make a number of clarifications to the commit message and drop
>      locking.
> v3: use a stronger check
> ---
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index dfcb9815b5a8..875111340203 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -7900,6 +7900,13 @@ static void amdgpu_dm_commit_cursors(struct drm_atomic_state *state)
>   			amdgpu_dm_plane_handle_cursor_update(plane, old_plane_state);
>   }
>   
> +static inline uint32_t get_mem_type(struct drm_framebuffer *fb)
> +{
> +	struct amdgpu_bo *abo = gem_to_amdgpu_bo(fb->obj[0]);
> +
> +	return abo->tbo.resource ? abo->tbo.resource->mem_type : 0;
> +}
> +
>   static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>   				    struct dc_state *dc_state,
>   				    struct drm_device *dev,
> @@ -7919,6 +7926,7 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>   			to_dm_crtc_state(drm_atomic_get_old_crtc_state(state, pcrtc));
>   	int planes_count = 0, vpos, hpos;
>   	unsigned long flags;
> +	uint32_t mem_type;
>   	u32 target_vblank, last_flip_vblank;
>   	bool vrr_active = amdgpu_dm_crtc_vrr_active(acrtc_state);
>   	bool cursor_update = false;
> @@ -8040,13 +8048,17 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>   			}
>   		}
>   
> +		mem_type = get_mem_type(old_plane_state->fb);
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
> +			mem_type && get_mem_type(fb) == mem_type;

I think you can actually drop checking mem_type here.

When the FB has no backing store, we actually don't have anything to 
scan out. In this case flickering is the least of your problems :)

Christian


>   
>   		timestamp_ns = ktime_get_ns();
>   		bundle->flip_addrs[planes_count].flip_timestamp_in_us = div_u64(timestamp_ns, 1000);

