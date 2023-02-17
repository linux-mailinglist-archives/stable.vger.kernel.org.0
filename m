Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960DB69AFC5
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 16:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjBQPuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 10:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjBQPuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 10:50:23 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE2A28D11
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 07:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676649022; x=1708185022;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PXenijcoyLi8DFz0rerNy/QINKJVpgZ992X2lNJp2EE=;
  b=Pvr5e/77l3TZrjqigV+zCTWKXCG+8+U1lzH2LVFkyRANnWi8ceF7ug1x
   eEceWYdi0364gii+0Ft2uIjZiYUPR8Uk1gy2YOE5Ql4rl8envTTcnrFzA
   mEny4juJ6kMiJZYb5y46vf1H/Zh/vKmexIHEJVr66InD1fqsUuuK0m6TR
   YazHmuLj29jTjJEWkkBCgTMd+g8jYwPTKAspgo5+k5NM9oA1sPulr1lZ6
   b2uYKpvigyo8Sv+aVZxfnXn52DE7SUhs2w1b+aqUa7iG8AMkPpyQ/BT3y
   QUIEZaOb62punsuQf7KzOPH/JkhNqLE1QI8aPtngzFniFtn0ETPo3AYqx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="330675939"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="330675939"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 07:50:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="759411419"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="759411419"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Feb 2023 07:50:22 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 07:50:21 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 07:50:21 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 07:50:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gy8e5Cc/TU/NbIeho1SKnCBCsVZF6RB6zUmulKZQ50O3YBXSd9NcFujPVP524BsAF+BVhSF0+xQ/hOU2Pjbk9biD7YqWWJTQMQByiHsasvmeaP2XalKOETy1gsgJAcbYuLKlC3yyDpMC+4Fuuf/tZsAbLPp/XUFFNCQ6sTysUI4BD1Vj7wf6RUGRv/maMGsfMRHClTDRCjrFUa+A3ptZiAlhlBldfuyDJUWsndgw9scn9/5748xpDgMcN24xHTxQ4sjR3s99EgaUbWjZ+DmhsNkYgDp5KDUafVpQ6+dZjvdS86PRjP8kCF5J0fYQuWshSEoIIBUWbEz2nR6GRPPstA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQlGgoyHwrBOlILbtH05lJzy+ZFr7fJygt31KafuXio=;
 b=E3tjsz6IkgRPjJpxNdffaLRTVEvWaxMHGg5E4D1XL9gv+wgPL0/Q/7i6jdaQtHt/EIUz+twapB9DvTxlMXUo1GoQKR/NItqUof5w7P3o9mtLYChZkgiMMpSujkvbyiDwUvABBsXl2suzjhya4bjh6cst2UDpIffYs2ne7DZWNH2vO5vyxR7gWrjrH7dVRoT5ePYuJWiUsXCEfdo4kYjNkHGxr0SEN0ZfzdWugdo8Ih4DBbV7i9Six/gMD5OipS4t7uEx2bGPaJ/YqOgSgamh2JKe7enl6+CTQqrqPRVBcLkVxds7j7/YoKHNkSlmn9zWcpMxF7uvpFgyoygarRfm0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5488.namprd11.prod.outlook.com (2603:10b6:5:39d::5) by
 DS0PR11MB7508.namprd11.prod.outlook.com (2603:10b6:8:152::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Fri, 17 Feb 2023 15:50:20 +0000
Received: from DM4PR11MB5488.namprd11.prod.outlook.com
 ([fe80::218f:c449:80c8:7ad9]) by DM4PR11MB5488.namprd11.prod.outlook.com
 ([fe80::218f:c449:80c8:7ad9%5]) with mapi id 15.20.6111.015; Fri, 17 Feb 2023
 15:50:20 +0000
Message-ID: <2eb8eb46-277c-55fb-d2cb-7f02ac503500@intel.com>
Date:   Fri, 17 Feb 2023 07:50:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 2/2] drm/i915: Don't use BAR mappings for ring buffers
 with LLC
Content-Language: en-US
To:     <John.C.Harrison@Intel.com>, <Intel-GFX@Lists.FreeDesktop.Org>
CC:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        <DRI-Devel@Lists.FreeDesktop.Org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, <stable@vger.kernel.org>
References: <20230216011101.1909009-1-John.C.Harrison@Intel.com>
 <20230216011101.1909009-3-John.C.Harrison@Intel.com>
From:   "Ceraolo Spurio, Daniele" <daniele.ceraolospurio@intel.com>
In-Reply-To: <20230216011101.1909009-3-John.C.Harrison@Intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:a03:114::13) To DM4PR11MB5488.namprd11.prod.outlook.com
 (2603:10b6:5:39d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5488:EE_|DS0PR11MB7508:EE_
X-MS-Office365-Filtering-Correlation-Id: 13a2a0ae-101f-484c-6ad9-08db10feac1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U8xf5M1neA+aaj9jrouc3CU834bv0+U1XojkgrOI3oGOr3x9FI3gkvpgytIY0pg4k9hvWSFggKaTesMqSxUTkjvBOeuadI1vnHb6lcGUw84zTFNTEpKikahILSk3rxeaL/ZbLxx3+B4dxIoanWe8ekVD5Bs84AuMx7KuPD+FkxJrtoZJ2qJ7X4mPxzt66Q0518f6BZCf7zp7jPriZXS2QChdMUTXrd08RsconlaeEuA/NsnyoxgrBWiKJd/orq1ZXkD3UtbJCZPrWsBLyeor7NZxIDH6TPIbFw6mVsexwiN7trdjqWnJvd1tUGi868WAbNQo4CWonaKQb1nA1OboIn9WXI+WGrgk68XTDxLgf0QbHYuQlrn3nGgcG+slrCCusg47n7Gj4R+QvaqoqWsA3F/UW9IYgHkZsbBZbQTOGSBayBcflVdCWg8jvb+zHsZr+L8rusOk7o+MTlcJFrqlcubjbcjnILSG4L+wZYbRndDhrYCqRMoZETQnKcOhZvYES4sbehr9CjXJtE4Bu2iUJZ33Ona4nuCRcr1n4QqTwth3C5WnGyOHA7Qn94F8HXk1eo2XU/FyPUPqo/CM6bLseHWYpSf9nWKq056LvJ60hg7sDE8R06EQRmF80qeOs8eEx+9IcLay0bjvKbZNzB3kbDLAkVwNoO6eN9LVxqIODwLYE0j4ow7Ca77NbBOGn53j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199018)(31686004)(31696002)(86362001)(36756003)(38100700002)(6486002)(82960400001)(478600001)(6666004)(2616005)(53546011)(6506007)(186003)(26005)(6512007)(83380400001)(41300700001)(66556008)(66476007)(54906003)(5660300002)(316002)(66946007)(8676002)(2906002)(4326008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEZTVHVub0orMWNPVTJacEdWZnZMRmUzR2FpVkZ3dHlUTG1ScERxTTUrTEZo?=
 =?utf-8?B?YldQSS9IdjJCWEc3blNuWW9jV296U3VWcTE1NHRjaHo4ZVJsa0hQczBHTXZZ?=
 =?utf-8?B?V3Zta1ZzZTkyN2FFMFJQdVVzYmFRZE5sOUhXa05xbjVIVVJqNXVXVHF0T3JM?=
 =?utf-8?B?N1U5N1pQYjNJL1RncE1Bd2xXRHdldGRhdUN3TTJQNjh4d200TXV6VmtuZ1RE?=
 =?utf-8?B?TDd2TVVjTFlyUTJTRXg2RU1RemVSUnpJQjFUci9uWHBvRllUT2VvZ0o0MHlx?=
 =?utf-8?B?cjhqM3JQMUIwYUhnL0tnWUFoZzRWTW1wYy9lRm1lU3ltSkUwSm9RZWRHOXZO?=
 =?utf-8?B?UmU1am5iYjdKL3Yvcjg2K3NBODRPZnlWNEEyWmVOKzFLaEJhTmc5dVV4d005?=
 =?utf-8?B?aHRzdW9RWW95RXRuY3RJWVFWc3Vja3BhSU5tYnU5eVlqWnIvcTVaWWZ2ejR5?=
 =?utf-8?B?cmdITFJRclcyeUxkTGYvU0VYT1pxanZ0UUptSGNDcU5wTE84dmErLzRGalIx?=
 =?utf-8?B?R1ByWnl6N2Q2OXF6S1VNSURZQ3pkdFhQZHhCMWl6RHYvTkVQYlhiQjc1Q2J3?=
 =?utf-8?B?eFNvRDdPMUJ4NHRtNlNGS000Q1hFZndMOStqbXFlUVhjK3FkWGZxa0o3SUpP?=
 =?utf-8?B?MVg0T2dMRmRaR216RkU5R0F3dUNXMGg1bW04SFl2dFV0SThkZWZCTnBTbGpN?=
 =?utf-8?B?K1p3OHFUdmErUkYxU0pOTFNBdEY1akkzcnJwMVVBdVBxdEJ6OGl0eTlQWk85?=
 =?utf-8?B?TDNIUW1sVWsvMUtXb0hscHFQNkVTQmtFckZtb1JTVTh0b0dtNWdBWk9RSU9y?=
 =?utf-8?B?RXFLeUtGQXQ4VmdpcEdhQWRxalJKendUdnJVWGNqMjBza0Z2TVM4TXIrM0t4?=
 =?utf-8?B?NGl3YzJZL2UzeVBXRURSMnN0dWxjSkpuRWtxcm1RaklyT1dsdDJveUtKYUl5?=
 =?utf-8?B?VGNMemdLVXR1dnVXWS9wOGczaER3Slp4NmZiNUg5d2xwTmpvMFg2aXpmUDRi?=
 =?utf-8?B?WjV2QmkvY1NwQ2o1NXVaVGlMZUl6UThySWw4dmZ6c3p3Yld6SHQ3UEhUVDgr?=
 =?utf-8?B?bDN4WVVHUEtKNnRQSG13cUlEbm03dFZJRjU0b2lFcitqWlVvbzNidFhZd0U3?=
 =?utf-8?B?cyszalNOWFN6NVZabFRZUXJXWDlac1BHalZINWNYUjcxZ285WWhQSTA2R1F5?=
 =?utf-8?B?WEF2enpOeUVJRGdvbnYzWCs3Qll2ckxqN0VtSHhmbDY4WHJDcGpXKzc5dFFR?=
 =?utf-8?B?cGtaUkxOOElmSVJ1MldhNWp4N3J0UUdLbVUxR3MwWC9BTllYWnVIWnZWVENX?=
 =?utf-8?B?dzR6NzZMMUtxTU5Vd3p1L3JJMXQ4eTlPdEFjSTJqbzFXYjQrSk50WXZSbUxX?=
 =?utf-8?B?SFY4REdOUEI0eDVhekc3UWpwanFaU2RDdDhJcmZDTm5GbmVmc1dXOS84Vk9y?=
 =?utf-8?B?UkRhN2tMRXQrLzVEdjk4WWY1UVFkUS8ydGl5SFY5bDRLZUVJS2VHOTZrNUla?=
 =?utf-8?B?TEJaa3ZNWmpibEVhUUE2L1FzRlJ4cGR3T0p3N0p3bWd2SkdrWWNEZkhLdFI4?=
 =?utf-8?B?K0ttMmRJUk9FWXVVVDJzM2Y0NGdwMHd0NW51UytsVjRvdi9pTldNSXVqRVE5?=
 =?utf-8?B?ZmdYY0hSeTlkSjBISmJrNXRWbzUySzhKaGQ2aWlheFBSUHQxZUR0TitZNnlL?=
 =?utf-8?B?YmJ4b2lXME5XUCt1NUNTbUhQQWFUSTJQR3lydHErR2JZdERqODVBRTBaSUlW?=
 =?utf-8?B?YmllMFdRU3ZCNTIxRmtveXFWNGp6cEFuSnZNc1Q0OVJNamExbFdXK3U5RTZV?=
 =?utf-8?B?RWJZU1gycldVWUNvdTF6ZmtYSDJ6c25HbklkSmE2ZVIrQytidWdtczZCME1y?=
 =?utf-8?B?VEI5S0ZlU2o5RzdHZVlRbmZxUVpTQ3BObEhXUTc2eUhLYWE0NndYT0JkVlhE?=
 =?utf-8?B?UnRRWmFaSDBJUUFkZmdpNTBwM1BMSUxCVFArclBXMWpyTXR3am5QSnVTYktq?=
 =?utf-8?B?OWtKY0FKK3hCZGZPR0xMSll5SjZqKzhYVGZNa2d5K0lQZmI0b1lOd2hGQkpa?=
 =?utf-8?B?Y01ML0xHOTZGOGk1RTZhaG9hY1RWOXp4aUhRNTh3YkZINUtkcTE3V0FtNzUw?=
 =?utf-8?B?d0wwOGluSUpWNEtSL2NDblBLdTVrSHNLc2JLTXc4U3Q2dExNZXFIUGhIWHZq?=
 =?utf-8?Q?h/z3mDg27EZ9eecI5fChkT4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a2a0ae-101f-484c-6ad9-08db10feac1c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 15:50:20.0694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7egAvVXWoj5RlRf4CJvR7Io46AXBgNs89rZPCPlitAz+3FwUxoCDg+R1cmvLYXo5ucc09Coc8WecXCuFN3Uy+tjrMRHSvwHGQy3ufHoGxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7508
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/15/2023 5:11 PM, John.C.Harrison@Intel.com wrote:
> From: John Harrison <John.C.Harrison@Intel.com>
>
> Direction from hardware is that ring buffers should never be mapped
> via the BAR on systems with LLC. There are too many caching pitfalls
> due to the way BAR accesses are routed. So it is safest to just not
> use it.
>
> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywhere")
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v4.9+

I've double-checked the original patches to make sure the 4.9 fixes tag 
was correct for both (which dim confirmed), because if we backport this 
fix without the previous one then the driver would break. Also, the 
original patches were merged as part of the same series 
(https://patchwork.freedesktop.org/series/11278/), so we should be 
guaranteed that they're always there as a pair.

Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

Daniele

> ---
>   drivers/gpu/drm/i915/gt/intel_ring.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
> index fb1d2595392ed..fb99143be98e7 100644
> --- a/drivers/gpu/drm/i915/gt/intel_ring.c
> +++ b/drivers/gpu/drm/i915/gt/intel_ring.c
> @@ -53,7 +53,7 @@ int intel_ring_pin(struct intel_ring *ring, struct i915_gem_ww_ctx *ww)
>   	if (unlikely(ret))
>   		goto err_unpin;
>   
> -	if (i915_vma_is_map_and_fenceable(vma)) {
> +	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915)) {
>   		addr = (void __force *)i915_vma_pin_iomap(vma);
>   	} else {
>   		int type = i915_coherent_map_type(vma->vm->i915, vma->obj, false);
> @@ -98,7 +98,7 @@ void intel_ring_unpin(struct intel_ring *ring)
>   		return;
>   
>   	i915_vma_unset_ggtt_write(vma);
> -	if (i915_vma_is_map_and_fenceable(vma))
> +	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
>   		i915_vma_unpin_iomap(vma);
>   	else
>   		i915_gem_object_unpin_map(vma->obj);

