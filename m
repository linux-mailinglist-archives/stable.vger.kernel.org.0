Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868B26DAB07
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 11:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjDGJl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 05:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDGJl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 05:41:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4E7469B
        for <stable@vger.kernel.org>; Fri,  7 Apr 2023 02:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680860517; x=1712396517;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Umdf+WrtVaCXcXNccqMf3nnDEeQUFd+irEeOsTP+iB8=;
  b=hG2jgx82eZxwpja2L6fA1qF03JYJtfAMR7FvK0b7isLwnwih/976zkeN
   hHvsAXMZ5MVWmKmIjeaLNHnTKNesI3OW6VHJPSy02tXRPEDMKihtJJ37c
   ZtWHXull5gjZClJbdxiFIZy9bDc//5wGXCcydiMdKtAbqagvnUyyaTUp0
   8MVCD8K+LTsh12DRH4LWPGXIXpcGpSi0tTycYv/mk3f/BG3o5HYNkT1Q7
   PHfLny/42DRfWh0z3qC1ug66UudtMoLla+wAW0+vEMA8b7vIVBjzhDgW6
   PszP6HpLvfPX/suOcGuNUind8GD3paSe8ovG1ZNl5qoGrVJ8oJn32UJjh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="429245556"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="429245556"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 02:41:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="720020676"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="720020676"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 07 Apr 2023 02:41:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 02:41:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 02:41:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 02:41:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rgm9XE9BWYhSBXIHVZ49F2P7yIFS8CfuUcWUy6u43LubPni9Svs0tpHC8c0JE3YuCyw8XvqR2c83YOYgkNAGH44PzDuTwh6eh6UVUkfYrN3PZQuroMcP92zyf+ulnzKhdpIKtUoKYKQwCnAOE+M3Ot5DCiuGNWA4BjYpfoD07jCHXEaN/NrMYYROPdtfgbufmLKBbYfLBWXWfYbpIqISCUlOK7Mr/doQ6YbzWnQSJ5+PSDI81got9G82jZe/ATvq4fBgBg2RaNusCbWx2lb5RGhlQNNcOCEox7GbjIRFcQs9M3xxTUkL3LXH/Pe+LcaJ/5+liAB1zOsHFW3wyJuzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0GTXnPNReWYk8vmYoiijPPImLycysMJDdIy08bwtDI=;
 b=WT0AURGC9j4pBLWCl+vbk7LVior95YMjvMBn4R2TJB8ueMSZvKfhRQHWKL3DTwfGX0MtkvJNDz/moapCTRsmleMUGMviqgpiQ9k397qMXxirRSxwA7o0zJfzAQJZK9UpDEj1OAy0iHMrYfdojfSlIXJZAD/LtjEicAE7AwRCYywmUFxYAJC//uaztv6Yp0Hz+4zeRju1DBtjkKKW2FXP8S+5iNEXTEdZMbEtZbPiKpqe2JZTXlOMMZ/hAmfJiTzDkVqChKlBrjymgnSIoDqfOFI6Er+4yC6uAty8YKrob8wE7WI+Qu9LT+KMmkTjQSHLpUbHn4GreChCOCdjQku5FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN6PR11MB8146.namprd11.prod.outlook.com (2603:10b6:208:470::9)
 by SA0PR11MB4751.namprd11.prod.outlook.com (2603:10b6:806:73::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.33; Fri, 7 Apr
 2023 09:41:53 +0000
Received: from MN6PR11MB8146.namprd11.prod.outlook.com
 ([fe80::ab78:f580:c203:edb8]) by MN6PR11MB8146.namprd11.prod.outlook.com
 ([fe80::ab78:f580:c203:edb8%5]) with mapi id 15.20.6277.031; Fri, 7 Apr 2023
 09:41:53 +0000
Message-ID: <21e7787d-d332-f3be-f2d8-3241492b30e6@intel.com>
Date:   Fri, 7 Apr 2023 12:41:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH] drm/i915: disable sampler indirect state in bindless heap
To:     <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>,
        Haridhar Kalvala <haridhar.kalvala@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>
References: <20230407093237.3296286-1-lionel.g.landwerlin@intel.com>
Content-Language: en-US
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
In-Reply-To: <20230407093237.3296286-1-lionel.g.landwerlin@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0038.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::11) To MN6PR11MB8146.namprd11.prod.outlook.com
 (2603:10b6:208:470::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN6PR11MB8146:EE_|SA0PR11MB4751:EE_
X-MS-Office365-Filtering-Correlation-Id: 4de6b288-1297-4719-7008-08db374c5134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jz3dujF2vAiFK6009AiVJp0eK7R461YUrsOdITdHRKovUBzbQsZPnGuEaNDbCIZDL0CHCXTyz+DNEV9E0WvhXlUtwXd8hmdTI8zvY4P+X++jYT0GtwJHU8nLryCJzv+oAQo5kuaExU+V/LQTWQqu/9XZ4BGsptWkMFEc12GGEKn6QVNa9FDLoOVPsybqbh/K+NvtjH3TyEyCjrcW33Gt52IU194u7vW0ig8Eaxgwl8ewXjOTX9p66GmmsJXx4Zg5Ks2pwMHUPYZA2VDr6J60IOuPoOMU+ty2B5CXutYJzZbx43PnlcEWi479n806AnXHJ2voVjSxPgKWA4S8nU+6zZt0QMYEdxnTlo/rRvpkUB4zY1SYdp86sfYw26g2zmJD2WEF/U5mahK+IZ+SRHzGrTTgOu+oBPyzurIvjRnjn2w5iBDgXiKnRo0WFB1D613fFIqZ13BUwSRbLJt6TExDad02Ty21Y+h2Aqeofpp8qRIzMIqHphY3+JLl44WaE1TLwAlCxM8lXCPTQZH98lsC344jYtZffbH9lFCsj+uwDC+Cs32Uh+mwhKF9No+4tAPPGvXJfVOcVzWIW0mVCKigm1MWQ13LyWHFyOPwFaG1Cm7T7EdJYETbtg1oGzV3oKpypzvHoQuQL+cYe2E7A+ySA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN6PR11MB8146.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199021)(316002)(36756003)(107886003)(41300700001)(8936002)(38100700002)(6486002)(5660300002)(83380400001)(86362001)(31686004)(2616005)(186003)(54906003)(31696002)(53546011)(82960400001)(6506007)(26005)(6512007)(2906002)(66946007)(478600001)(6916009)(4326008)(66556008)(66476007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmhybWowNWZ3a3dUVUZ3L3RlS0R3dUNsZm9NRDdHZ01WYkI1RXBRU1NPaGEw?=
 =?utf-8?B?ZDk3TVpXMXE5WEJFQmh2bzkzSUwyTUczd2pFOGcyOHI2T1h2OGJvdTRXRzZi?=
 =?utf-8?B?VG81T210SFR5T3loaUk4ejhSWWxMRXpxbkpIT09kbUVJdUUrek95dXZwZ05s?=
 =?utf-8?B?WFFDeFRYSXpMU3F4enNTWG1WakdYOXVhRTZkL3NjMHczZE1CSkVjR3hvQnVj?=
 =?utf-8?B?Z1hteGJlSDhQSHlYVnJCbFRkK1IyWUNoMWx1QUFHc2c2bnpNdkZKK0U4emNM?=
 =?utf-8?B?akNLaWptUjdleGtoNGJKOHZjajdUM0FvWHVTTisyMWVCREtJdEwvZlNJWFdB?=
 =?utf-8?B?Y0FlTVRGL01GdHZPZFJvN2pPMU1leXV1UDBIbzA0MjlmMGRYN0lGMnF0cklQ?=
 =?utf-8?B?dkhTOUk0YUhDSGNQVVFFMzBieWRQMmpiUkJPNHYwbjVEOFVNMFgzN1VhNGdC?=
 =?utf-8?B?VXNsejBOZTg4Q3JHaExkd0wrWnFReUZvNU8yNWhrY2ROeXovK1gvYjR3NDU2?=
 =?utf-8?B?a1VCM3lCczRjSXE0UXVaR2krOG9uT1ZKUW1hbWpJaTRmUTJ1WGt6OFJKMHNP?=
 =?utf-8?B?eFhyTTVpd2RTT0MzRlRDOXZRNXBHb1dYcHpPZS9SVU5Ud2xsV29icDV0S3kw?=
 =?utf-8?B?a0ZDNzMyaERvMnhlUUpVUkhSbkRNU2FFQkVXc2Q3VFBubU8veW05WExCWEpm?=
 =?utf-8?B?VkMycW8rU2dtdVZSNlozZzZYOXNPcFV2ZXVrMWRnbWFVaUp1WU8zTVRUaE9Y?=
 =?utf-8?B?MVk5MWQ3Sit6blVKeHQ5RXlxVm5HeWhEMkk4UENBSlpWcytOQy9FU1Ria1pW?=
 =?utf-8?B?OVdqZlFYc0dLZzArNGR0bzBjak1TT2JHamJMeUU0U3FwM2xzNHIzWmpLWWs1?=
 =?utf-8?B?ejJscmRZT1psa2ZiOFZqMU04ZEN3SDhUdWQwQ2k4a2RMMmFXN1UxK1Q3Skgz?=
 =?utf-8?B?NUtCV2JzV0ZhNUh1TENPYkZ3Kzk0L1l3NTcyZlV6VUxBNm1CRUNSbXJ4eXN2?=
 =?utf-8?B?aHJaOEFnc2hFdkZUQmhEdWwycFVjOUZhOGtTNEpMS3hTc0tXWlBhQUtYUVBz?=
 =?utf-8?B?L25IQXNXTUd5K1VtRUxvdy80UFRHbFNPZjJqaUt6Z1FKZDBZYnhDTjFoejFj?=
 =?utf-8?B?eElXNXFINTVTQ2R0VmZqRi9EVG1VSUxxdS9xN0FhWG9RS1p1V2I4cm4xL2di?=
 =?utf-8?B?cy9YcUdGR2ZEeWdLK3dkR3EzVDZxVVQ5YmUzdTdzVkRLV0d4QVZIaXEzUUtF?=
 =?utf-8?B?ZGN3SG51eUlBQXZzT3J1UDc1R2dOc1ZLYkpZd0loU1JYbGJ1c29paUNjbW5Q?=
 =?utf-8?B?aDFVbVlmRXUzbVpUcmpldXYzbXl4dHEzWm1ZQzlxV3EzT0xKT3RCMUFxSVNU?=
 =?utf-8?B?K2JzU2dvY3BXZ0R4MkU1ZEduNGRzTE9SdEp0YWtEQ0lKYWkvNVJEcXFXVERv?=
 =?utf-8?B?WE5kbVZsWFhpMmZVV1owMytQdlMzamZpNWphT1MzNUg4VDgrQVFvb2NqZnVV?=
 =?utf-8?B?MHRkcFd0UnlSMW14UVUrQmllY3lwS0VmOVJsampqVjU2dzY5T2EyNTRFZTFM?=
 =?utf-8?B?V1pEeTlwYXJqT2lyNTh1NXoyaElsUUtLQnFuN1FLU0t0RlFFNGs4ZXd6OUk1?=
 =?utf-8?B?Y0pIKzBzdnBkTkN5UXRSOU4zTVhyK0ZKcERIYitkazFRUnJ1aUxORnZRdzds?=
 =?utf-8?B?M2MxSHNaa1phZUF5YWFTVU54RWxTNFN1WlRhVEpOdnVoZ3NIeWFVQXhuY29N?=
 =?utf-8?B?YWZ3WWQxWVVib29SVWIydmo2SEZWeXdDNEUrVXdtSmZPRFJWUE5JSkdwSXBs?=
 =?utf-8?B?eExlVUk4b2l3c2txem5jNzhlSnNvbjhkZ0xpL0hLMTdwSG1MOEJLTlFaNzhu?=
 =?utf-8?B?V202WHc4ZWRtc2UvdjlRS0hHZzM5VEFIbTZpQTg3Y2tBQ0M0WGNYMzRHV040?=
 =?utf-8?B?TCtyb2xJK2N1b0wrdWgrNFhvZE4yVWw3dXl1Tk9Mdmh1TGdxaVNGQStDMWJu?=
 =?utf-8?B?QUpsc2JOSFU1cElua3pFWXJiTERBSHR1djFRNTRISlk2Y2lvTjRhbkFNRVNq?=
 =?utf-8?B?Ni8vYzhTbXJERk1IL1VzanJFOFdUcHAwR1FTV2t3bS9JU2lRMXRoZllFcUV6?=
 =?utf-8?B?dGxQRjFKNkZMQ0llRmxMZWMrbVc4emwzc3JEZFA5enUvbDlKRThhRXQ2aFdz?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de6b288-1297-4719-7008-08db374c5134
X-MS-Exchange-CrossTenant-AuthSource: MN6PR11MB8146.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 09:41:52.4041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ui5f9PhTHX46kMwJl73HkyB2uNe4KSKqCwa4HM3dlG8Z9tnlK1NhW9Wd7qHALmX794L2wk5q4ZSHHql23ykL8ts9L/MaqIIv+LzsvkkVWDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4751
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/04/2023 12:32, Lionel Landwerlin wrote:
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
> BSpec: 46052
>
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Haridhar Kalvala <haridhar.kalvala@intel.com>


Screwed up the subject-prefix, but this is v4.

Rebased due to another change touching the same register.


-Lionel


> ---
>   drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>   drivers/gpu/drm/i915/gt/intel_workarounds.c | 19 +++++++++++++++++++
>   2 files changed, 20 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> index 492b3de6678d7..fd1f9cd35e9d7 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> @@ -1145,6 +1145,7 @@
>   #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
>   #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
>   #define   MTL_DISABLE_SAMPLER_SC_OOO		REG_BIT(3)
> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
>   
>   #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
>   #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> index 6ea453ddd0116..b925ef47304b6 100644
> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> @@ -2971,6 +2971,25 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
>   
>   	add_render_compute_tuning_settings(i915, wal);
>   
> +	if (GRAPHICS_VER(i915) >= 11) {
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
> +		 *
> +		 * BSpec: 46052
> +		 */
> +		wa_mcr_masked_en(wal,
> +				 GEN10_SAMPLER_MODE,
> +				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
> +	}
> +
>   	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_B0, STEP_FOREVER) ||
>   	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_B0, STEP_FOREVER))
>   		/* Wa_14017856879 */


