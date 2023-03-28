Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D996CBCC0
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 12:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjC1KpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 06:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjC1Ko7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 06:44:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2640119B3
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 03:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680000298; x=1711536298;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eMDAAN9Bjn77n4Cth1X+6X5Nymysnxnmm+iX4KvhUVE=;
  b=lspe9qFAe7rCZTnKMjjeuphETfPM9jd7QY4IX0I9i/FukvFJLyEfPqhL
   POpb4gJy7OtegW98dyBvXIx3ZfgSYbMiByFaaD6X4dCKtKuDron2OExI1
   pag12nZN6FBD/ZI7Elx4xUiRvt0sef9wTqRAbtueAUNIBpS593+io4EM+
   wnELAZpKV//gwfi74ykfnUPPgfeRuGcLNnTSFY5Bkx0MZeOMO50fOLfiI
   zeS/WdsIZx1z07Kgr9WZMDwYg/hA1xh00bRX4S/aWr+32m74GxCOGqwNf
   wcdKOho6IXgPz/Z1L85QBfKhC/u9gmKktF8nP+nr+8ptJ/sd8hlliipSY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="426796413"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="426796413"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 03:44:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="748365583"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="748365583"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 28 Mar 2023 03:44:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 03:44:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 03:44:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 03:44:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCCnMSBq26YA4b8Vl2aUqlwlPYwPajuMtbp8hZm7Qa/FDRIXJaJCWz3SKlWeoQMJnulTJL9GA8thUnW0bhYcgcd92jt9ICUjt5jgEvo6nc2UTBhFqtWCmd9D4TsKfqeLWQJhNH8LROPNLZOr+XKa2XqBxse60xc02Zqvt0k2pKHjApZfW44JAIXV7CsHGe3U4L5QJsKcRNv8cKzGpL2aTtX6sdBwJKOlkn/ID2fnuA5ID6ZY2FEnBet5EeSl5vYISoigUuDVFvvqsaebI7T+eSedu6HzdSMq3wHzTrT8SxQv+bG3y+8EV5k6Bj/Iw4OFgMEC6Fp/hiE4m+6+OyNyWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlGrv8zQqOz3uy16iKXpU3P/yZ3WubwttvezYNHiPx4=;
 b=AlJmM7FJN6fk639j2zHTKaeYV4oc1MFA+7mAg6vHiJlc4Ao3xUqWzzMWZ+/MWxGPMnYrlTYSaF0MDIPZmBiOUSudh2a6ZL6EKJ9G4ERoFefEkZzjN2s+ENHd2nCenyrBorM0dJsKlO3wUfJ1Zs9ijpoIcDikEzcmouYgqciwYYF8siEIlE88gx1gcTOp4cOu5e2YRuAcpeM0+jtHmOCojDeftnRtkKT6rzbX6Qei4FA8VhRm8x6by8a7zQWyIRLqtW0g4dP0hJsjY4Xadira0VW4o372T50osRuOm60rVCeNYC5UJ5G8Urq+f3MGsGrghsDH0/bFBS09ZzYCRCG9xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2907.namprd11.prod.outlook.com (2603:10b6:5:64::33) by
 CY8PR11MB7875.namprd11.prod.outlook.com (2603:10b6:930:6c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.28; Tue, 28 Mar 2023 10:44:43 +0000
Received: from DM6PR11MB2907.namprd11.prod.outlook.com
 ([fe80::22a6:927d:6b03:69ee]) by DM6PR11MB2907.namprd11.prod.outlook.com
 ([fe80::22a6:927d:6b03:69ee%6]) with mapi id 15.20.6222.030; Tue, 28 Mar 2023
 10:44:43 +0000
Message-ID: <5a4a00f4-9641-0c8b-c0f8-2fc47dd91cff@intel.com>
Date:   Tue, 28 Mar 2023 16:14:33 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable sampler indirect state in
 bindless heap
Content-Language: en-US
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
From:   "Kalvala, Haridhar" <haridhar.kalvala@intel.com>
In-Reply-To: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0071.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::18) To DM6PR11MB2907.namprd11.prod.outlook.com
 (2603:10b6:5:64::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2907:EE_|CY8PR11MB7875:EE_
X-MS-Office365-Filtering-Correlation-Id: 37b06cca-767c-477a-ae28-08db2f79706e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5ygbXJsc6pGFBNSnQNmJ1/AXk1GJKKRVL62l1FWzsY8lZx5EBjCGQDHOfOe7OxAeAYKKMuklzDMcquQqrnBhaKGN3bnhp+s8reSplkQbtbibCEh6oA0wWdmCLzoug3r+Y9x11tiSTKizzSBx3Lhbu485YKv+iRIT1O0uWFvyoIDQavy8fGAoBJgIAQ8Gi/lPkE6g3M9rfwDDg3aamVyYoZ5UX6EiLl7JFLatKiD91tviyLKW2vhd9hqSU68UtvcJ0ulBSkah8kAgCk2zlJk9Z2W8QuBugU0rjBkKhbliyizPPMcbYWnWMQciyGsYbqJ6kKsbxh+NYOnCgwQEiS0yC0Vf68yvDJ+QA79LsGDbpsUX8A/MLXMvpsIHDX0NzjIH3mFBcsBRw5fIfM0fGX2EmYmwEK0zR8APahwO6KRlAbB8V8UsTA07XCz8qUW6AZqZ8fw20Oox+m0kOO9R8o20dADBnnMmBnFPTd9rFYqagz/jF4jzYz/f6cEes3AFdn5u7Ntj4sd5lMvA3Z3Vqc7BA9okOdtq/bw/y3VWbAXQgVDVVWNxEhfkU2RoDBD50D5Wl9HBkz9NXj/UQgvGqtBe1SA7VnlpD4e/c8ixOF45Hif/VMNq/gIV6QJn4O14tgUQjkL+QR3Ujh3TsmBO5HtjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2907.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(31686004)(83380400001)(2616005)(41300700001)(31696002)(36756003)(86362001)(38100700002)(5660300002)(6486002)(8936002)(82960400001)(478600001)(66946007)(66556008)(2906002)(8676002)(66476007)(6512007)(4326008)(6666004)(6506007)(186003)(53546011)(316002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amZBRlAzcFNwU3NXTDZ2dnpsQThRQzZVMHlCZUpHcmRvWHJ0UkF4aWFEZExZ?=
 =?utf-8?B?SEMvR0gwWkZUalFacUNlNktKMzBLcDVKUjZ1OVd6enU5TjBFbUsrV1c4YmU1?=
 =?utf-8?B?YVFsMlRjYkYvRU5YYzdEay82T2tlcXRiZEZJbmJiRWVudVY3U2xOdFMrT1g5?=
 =?utf-8?B?WUw4NTMrUGtHWDBJcS9KV2Y4STBYemozMys1WGdHN09QVldqYW5ITTMrbnFl?=
 =?utf-8?B?aXhKK0VWL2hZQlA5NnBuT29UdHBya3ZGNG5PTXYyZG9FQXAwSzhJVzdVUkpw?=
 =?utf-8?B?LzZYU1RDUU05QkozT09TbDNKeHNhd1ZVNUhWNW1EMVFXZDkxTExNbHUvaFpN?=
 =?utf-8?B?cXA2cjRZT3J1L0RxLzBEYXJ3TzYrKzNYUzJNWGh1LzdlQzRDMGJaMkV0SG1v?=
 =?utf-8?B?VzcycUIvekw4OTI4NUowaXlHRHJqV01hWERLWDhFaDAzZ3VtZ1VkNXZ4Y3BL?=
 =?utf-8?B?clErN3picDJQbG9TRlpwcXVsUjlqRnBzN1g5VmdjQkpJZEhXakpuUTJTNUtD?=
 =?utf-8?B?V3cyU3BwWWdzNTJYcTFlaXRPRnllV0dLejZCMG8ybDBGWWlxdUZ0b3BjREt0?=
 =?utf-8?B?SVVnVFFDQ0I4UDdyS2k0dG5nRmdOUG85dVVKVUg1Y041QmlDYTBjdlZhcDQy?=
 =?utf-8?B?bjB1Z0Fmajg3Z1ZFYTVVaytzaDJwbk1aSWk2VWNWQVNUcE1RQVlvNjBUOXRM?=
 =?utf-8?B?aVl1cWVIZ2tLZFZRbW81OHpaSXJrK1R6R3VWQkdPMk9TNGhBaTk1cWp3TlVE?=
 =?utf-8?B?MmxuT1ZJR3FFMUZTa0s1V2dMNFFNQWpNZWJnNDlUd2JIUitHcnhVSW8ydUJL?=
 =?utf-8?B?NFA3RzdXV1pxaklCZWJBNXh2WURZZ0NNN0s5MEZuTkx4c3haTU10Qm12UjUz?=
 =?utf-8?B?TFRuYXB4bFE1d3QyUzJwUnFrL2RKRmJsK290OXBjWGt0RmR3NjF0bmNJOExR?=
 =?utf-8?B?cjBrbWFNN2EzcDF3N1d0N0xWcE5idVRSMVErNno5VG1GdXRnTGNGMDh2YzZ5?=
 =?utf-8?B?WHRiVk1RamdERytWWGN5SEpsc3Q5dnZaMnpQdVIzVS8vcXl1d1NHdW51Vm9U?=
 =?utf-8?B?Wjl5ZFJ0cGJsLzJkdGwvYmtPbk9TT1FkRjRhRUR4bFZYY2RWM2hsUzd0RUtL?=
 =?utf-8?B?QW5NUk8wZDRwN1dBdmRhUWlsOXNkTTkvY2NLTEtocVRJMFJXbituRmN1Ny9q?=
 =?utf-8?B?MXZ2UE5vbytFUUxJMGVFVUlaV3VZaFBiR1FoN2Vnb1ZYbGJGKzM3Z2s2RjVk?=
 =?utf-8?B?K3NrdWdvR0dPaGw5U0s4YW1YSWUvSEhZNlMrcnJUTkZkWCtHaVVORXRxOVhY?=
 =?utf-8?B?QUJ6MjVDcDNFcG0xNjVuVE5vRFFEVGI2TVpmUTc5K24vZzdJNWhFMmIvQ2I5?=
 =?utf-8?B?MGg2RTRNZWVpWEhLSlY3eEdRaTg1d1pGMjFwOHpCc2JZd1QycjhQTE1nK1VU?=
 =?utf-8?B?T080SHNnQWVwaTRmU3FwZzBjUXkyMGl2UXRzdUlmYW5CK1g0bjBQWlc4U3Y3?=
 =?utf-8?B?aDhhaEJFN3NjZk5PZ2dISEUyeEdlR2JlWW0wclREcHhzZWNiSW1GUThEK1BJ?=
 =?utf-8?B?NjVqUGNoNzRQMEFiTW5qdzRURGtVL05hRHVLcVNOdzdXclN3NjBaVzQ4V3VB?=
 =?utf-8?B?ZHJFb0tVWnJXMmJaM3RLSUlZVFJLd2ZFdm9aVnJ3Z0Q1ZTFCY0hjZGJjWElC?=
 =?utf-8?B?NzY5MFI4UjZZekFQWFpPWHRMWVY2dTFuTmFZYkZ4amkxZjBjQUZMa01Bazd1?=
 =?utf-8?B?TlEwcW5LOS9iZGIzL2c4NU1FaWhseXZBMmFhblBpZjEycEhZWmViMHNQU1BN?=
 =?utf-8?B?MFVlWFZRUndWSEhpeUl6T2VSNlE1NVlmWEJUTUVhRE9qZUNXc3l0QXh3cVFs?=
 =?utf-8?B?UytnczM0dlorZGN1K2RxSnRCTHNuL0J0eHVUS3VMckYvYlNkcEJsczkzNVBX?=
 =?utf-8?B?UkNtOGRLeXAvWWxpajM1ejQ4MWhEcXlhbkdLRHhHOWEwOG5ZWDE3ZkRITVZx?=
 =?utf-8?B?SVcrZ0FzMFN0ODNyOXAzb044TnF3aHFmVzJSTlAxdk1pQ3RrdmFjaVBXRmc0?=
 =?utf-8?B?MXV6NHJmRCtNMHc5NjVSMEMrUFY2RTRSV0lHaG9IWnp4QnBGQ2QrSFpQRVQv?=
 =?utf-8?B?b2hSeXQ4QnhMVlZudTgzdFpLa1Nib01CdW9rZVhVSWhQaE5CS0RLSG04azlM?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b06cca-767c-477a-ae28-08db2f79706e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2907.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 10:44:43.0858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMbnXYOqGqlFRdekgKzeq7A4SvFNdt9BIVpZeNlRpf0inu6+crSXYvrZHaDuSThlyOLCFV+48/YJipLiZ6XK1rP+rJIYalZM4OsZalcZ1SU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7875
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/9/2023 8:56 PM, Lionel Landwerlin wrote:
> By default the indirect state sampler data (border colors) are stored
> in the same heap as the SAMPLER_STATE structure. For userspace drivers
> that can be 2 different heaps (dynamic state heap & bindless sampler
> state heap). This means that border colors have to copied in 2
> different places so that the same SAMPLER_STATE structure find the
> right data.
>
> This change is forcing the indirect state sampler data to only be in
> the dynamic state pool (more convinient for userspace drivers, they
> only have to have one copy of the border colors). This is reproducing
> the behavior of the Windows drivers.
>
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>   drivers/gpu/drm/i915/gt/intel_workarounds.c | 17 +++++++++++++++++
>   2 files changed, 18 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> index 08d76aa06974c..1aaa471d08c56 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> @@ -1141,6 +1141,7 @@
>   #define   ENABLE_SMALLPL			REG_BIT(15)
>   #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
>   #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
>   
>   #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
>   #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> index 32aa1647721ae..734b64e714647 100644
> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> @@ -2542,6 +2542,23 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
>   				 ENABLE_SMALLPL);
>   	}
>   
> +	if (GRAPHICS_VER(i915) >= 11) {

Hi Lionel,

Not sure should this implementation be part of "rcs_engine_wa_init" or 
"general_render_compute_wa_init".

> +		/* This is not a Wa (although referred to as
> +		 * WaSetInidrectStateOverride in places), this allows
> +		 * applications that reference sampler states through
> +		 * the BindlessSamplerStateBaseAddress to have their
> +		 * border color relative to DynamicStateBaseAddress
> +		 * rather than BindlessSamplerStateBaseAddress.
> +		 *
> +		 * Otherwise SAMPLER_STATE border colors have to be
> +		 * copied in multiple heaps (DynamicStateBaseAddress &
> +		 * BindlessSamplerStateBaseAddress)
> +		 */
> +		wa_mcr_masked_en(wal,
> +				 GEN10_SAMPLER_MODE,

  since we checking the condition for GEN11 or above, can this register 
be defined as GEN11_SAMPLER_MODE

> +				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
> +	}
> +
>   	if (GRAPHICS_VER(i915) == 11) {
>   		/* This is not an Wa. Enable for better image quality */
>   		wa_masked_en(wal,

-- 
Regards,
Haridhar Kalvala

