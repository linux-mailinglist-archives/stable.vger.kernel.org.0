Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A596DA499
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 23:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDFVWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 17:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjDFVWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 17:22:32 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FBDAD3D
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 14:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680816151; x=1712352151;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZBbnf9b2DenVObQJ5GLLXUJ2Xl1fLp5KiKGfkY6G2Jc=;
  b=nNXgfA0faZESgWxPFB+SM9+onosuY2/TH6LUnmfihFT4hIMLlSjTY0F8
   EZyMiAjCqVsiS28BxOBeFW97IBkPRwXzHfyZlG8KuoUDVAUbgmQur810C
   +JlyQG0hPSP9NtNYM+C8kZYIv8mjrNOblD5ca3h363vNNn+XlVnMoWOZv
   SGm693FqqVRtYPwR/druH+idkyFOmE3Ga412cdCB1lasWMNw0x7YD9IiF
   L6DdP6jXu128shQukD2bj0Hdu4LTBlqA3uHhJJA1pUuSitR3b3tXxKioA
   kbSvxOsb7zVxv8db4h+7j7vskTv6HiVcBoI11It6I8tKwynxK0/xSa7F8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="340336382"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="340336382"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 14:22:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="664647397"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="664647397"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 06 Apr 2023 14:22:30 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 14:22:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 14:22:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 14:22:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyKJhwbjwmrpuD6WgD39yoZ1kaLkFfLVUy7E4OBJJrRNCdKa+fkBj1dfnMWIOcZVB9elUz55DPJ/spkVAeDwYwQ0zPeqrmo1M8GQE80FyIxMU+M+DvyC/wue2dBSvAZHkR6r6Q649PCUV5zT7FE5w1tZtneGWiPerWLY2BLjRyNCgA8mygLjoXDD/m2Q1VM/HNkyZ4N8aklqe3DanARVxqW1xezfv6AcTtCz8N2K6SvuDF7laxwVQs6rMUjKxjZyGO1/k1X0DPnirisT2Jj9vEXlQmF2Mo02i/PPaH+NcEHdP5LjTNOpHPmiztZ8TggdfvVFxfnsfQu7bmZ3qQbfgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b7sFMHnZ2wovgFPost03tONGMsyPBd2MYOQIzD7yK78=;
 b=Wu1T7Qake/1zY/36JWZxXyWJAbm3duJ6CheSoLdPVWO/Nz2E8EqRm2qUV/mIyj7Xy0T6oDzjlFGH5X9SZsJYy2+hjvCm/VDgRyGJUR8rbJ+URXaY7RwA7NDFwy+eiDHCjPlsUupG8zi5WF+DRe/PCj135atSb+Ug0x/YO00IRMLCvT1PAtUM1v8Yw55474vgbNKww6e67UxX4QN0ewvJlHqsXXSrqk/AkmpZVYyNncDwW8KFDF9IMYztexXTckmXYYD6roCfGdDIcdl1KF0k5CxNR15TSQSdOmBLVU41Go3px/DZUHIfsRqbebs/vueFuqP31Lix9hMhXGvDueMJ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB4239.namprd11.prod.outlook.com (2603:10b6:208:192::20)
 by IA0PR11MB7791.namprd11.prod.outlook.com (2603:10b6:208:401::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 21:22:27 +0000
Received: from MN2PR11MB4239.namprd11.prod.outlook.com
 ([fe80::4c7:f160:a73c:86d7]) by MN2PR11MB4239.namprd11.prod.outlook.com
 ([fe80::4c7:f160:a73c:86d7%6]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 21:22:27 +0000
Date:   Thu, 6 Apr 2023 14:22:18 -0700
From:   Matt Atwood <matthew.s.atwood@intel.com>
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <intel-gfx@lists.freedesktop.org>, <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [v3] drm/i915: disable sampler indirect state in
 bindless heap
Message-ID: <ZC84Crz39RzoXebd@msatwood-mobl>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
 <20230330204228.2781676-1-lionel.g.landwerlin@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230330204228.2781676-1-lionel.g.landwerlin@intel.com>
X-ClientProxiedBy: BYAPR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:a03:114::23) To MN2PR11MB4239.namprd11.prod.outlook.com
 (2603:10b6:208:192::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB4239:EE_|IA0PR11MB7791:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d12777f-cb6a-4d26-a31c-08db36e5057c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCqsZckdBHBipslwQgrsQ6xPG3ha7Ad8OXa4FIZ/hz1AB1sXdvqcnhkoQ9SbmRJGeGtOD5YlY1R426OKucjiA3PYdSIv6YDXIUsTKrmOoRsV2H73tnlap4t87kRUHxcVD+TkEZvLxeJ66dVFaFGCE3rIZbby5SuUQ1ZVEymwZG8fI+zyQ1ovaPcHhjTvzB7HxgCtpg5AWoT7+Xes0V5cgaBB5a2e4Z0OZahEOUSgqtYO8eSNOvroA7MX0OUzUBaZG6gIeWCyKVbNDDtjKvKBeqYYPqr0VJ79SupRiN1HqdJ4sMvlsPA1hyOaLz3jeLopC+t++Z7QFel4CWvIEqq6dyJ55I1gmgE5yrAixrpMck/AsXhvsbON5+rsStUkU8bA1q1y/LJ9aWeGbr/Y0JucoxirLRfAXpGViklt7zQGD6d+mt/Hp6CWnmE35aFElmcxu3mwtEwwm+k/Zqp4Bhg+PO7ng6hB9EnvNSisLnmnEwT5N2/j/c9z4hOwp0celz+7MlmQRQRLSdj7PTS0NcrzHTCRWpPFAKFT0whGMio9X4UQj1BiSO3IJnu/hRWQor4m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4239.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199021)(6666004)(478600001)(6486002)(316002)(6512007)(6506007)(9686003)(186003)(2906002)(5660300002)(33716001)(66476007)(66946007)(41300700001)(66556008)(8676002)(8936002)(4326008)(38100700002)(82960400001)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1Izb1NQVWlTbnhUNmJSWFlnTldTNWFJd3MvSkZsYkFpSlRXVTNMVXp5a3ZD?=
 =?utf-8?B?M3piUnV5RzdTN0dkV2JoL0FKNlRMMkUzUlB0TWFaSURYSTZpNnJUVmN0WldH?=
 =?utf-8?B?VkdyZkY2YU9ySDlyU1ZOVzZ1K3gwSHZoT0tSWHZ3aExWc2h5YlUxZHpCMUNO?=
 =?utf-8?B?UC9OZ2kzVTZaRkRQaUZ1ZFMreHUxdndYMVdaYkp0MXJZamI1bEZRYmJKTDZK?=
 =?utf-8?B?Tnp2OWRIcGJMZTFHejkvOEl4RnQ2T2FBWXV0ZS84ZmJPWTFxTXgvSW9Yc2FS?=
 =?utf-8?B?aS9jRzVDdEMzN3pVcnBYTXVITWxiWWpyWS9uS3B0cng0NlJzT0hRUDNrbG05?=
 =?utf-8?B?blV2bTRva05LbUd5bnk0ZGVBUVlvYWRUYmFROGJ1eTNyQ09HUlNMRFdOUGVk?=
 =?utf-8?B?RXBDa3ROZy9CaitnMEtrQnhJMGE1SVZBZXV3TGdzK1NuYWMxLzhQNGRPR2Z4?=
 =?utf-8?B?bHgrdGFGbzRQKy9aYzErbldSUDFFa2xrM0p0Rlc3eFJxVUtlZ2VkZzJnL1Rv?=
 =?utf-8?B?V2FOR1V2YnpEQlB5aGYvMnVTOUlRRTF6QTRpNG9MeWh0S1R4Vkx6VDNEa2dW?=
 =?utf-8?B?UHg0bDFEbzBLdjRBTEFuaU1KeU1nVE1SV2hFMmxTQUVMUnc3dkZhOGhORUVE?=
 =?utf-8?B?N1dJUHFVSmhscFhpbUxhaGxqRjJxaWtsZW81ZmszdUViOWJzMjJkMTlESnFw?=
 =?utf-8?B?NFVRYTMxOHFscEMvQ2RrWUpVZlRkcVc5RUZEbEMrK1RUUjhCNm5qdmxGOHAr?=
 =?utf-8?B?b3gybEcrWi9jMDRqdnhpS0Uvd3ppQVVtYWtKTHl5VTNxeHl6SDh1RHlXa3N0?=
 =?utf-8?B?MFkwNkg5RW1aRmJDMGRqT3pNOHlkT004eEx6T1A4WTF2QlVQRUUySUVnK0hY?=
 =?utf-8?B?NE5JNE5nYnIxeXlscHpxSmdQSXhkU3F1N2RESEw4aTdFV01obkc0YlNsb0JR?=
 =?utf-8?B?bENmcTI1enY3cFBiYVk0M0NsTnQ3cUF2NGR1bDJQbDlKcUhnQzA0QW1JQm1F?=
 =?utf-8?B?bUREUjE4RHpiOUsxWTVyUi83c1lGUlpUdHFjK3gydFVWRXI4eWdqbG4rV0ZM?=
 =?utf-8?B?NjNFMUxHYUJXeFdQYWNaUTBuRnBsRmhZcjdVOCtTSFh2eU93RGtEM1Y1S1lC?=
 =?utf-8?B?bWJVekQ0VGdZODA4OE92WU81UzZCNlFxWkVzbFNaTGVaa1pFQ1FIUU1YSEIv?=
 =?utf-8?B?QU5nRnE2VXpNS3kxYTQ0TjVhdXFmdU9QQzhVYjZ2VG5jS25wSEF1cC8rWHRZ?=
 =?utf-8?B?SG5SZnBva0tSVU5VYlAwNFVNSUJ4akhkQS9hbVVueUFmM1A5QVNjSG5qcHhY?=
 =?utf-8?B?MEJGeVdsUWsxMXlUem5aV1lIWHI3UHZ1djNaVkd5ME10L0pNd1RZK3lZRzY4?=
 =?utf-8?B?MUtocFlVYmRtUm9tZEptMXZ3OFJISGc2S2ZGa2s0N1Y3OWNxRWdKaEhrRWVp?=
 =?utf-8?B?QmFMTU9PMkNrQ3JHcE5CeEp6L0MzTnRsMUhrWHRNMDh5aHVLUTVUUzV2KzR0?=
 =?utf-8?B?SHUzMFM1VEd6ZHNMTHZ5TkFFSWpLc0wzMkxXUGxPdjlKVzZsOXlHNkhWY2l5?=
 =?utf-8?B?N3lrZFNURitxREJRdHZBYTVQNFovajJRdk1ZM2RzL21kelcySDF1L2RheHdv?=
 =?utf-8?B?c2wvTlBtcE9ON29VWGxVbFEzOWhWUitZSEVPdXJrbGJmRXRIVzNCdFU0dGcr?=
 =?utf-8?B?QjVwcEczL3BJR1FaMFFRbGhmYm5UUGR3aHdZK1Aya2VCMVZpeGliRnQ1SlQx?=
 =?utf-8?B?MnNrckh5aSt6czR3WUtkUVRNMHdqaTFLOXpOZ0o1ZnUwVUZKN1JjdEs3STlv?=
 =?utf-8?B?ZFZZVnVVbmdvRndLcFV2Slpxc01oSkN1MFVMUE5RS0pzeWJUU0xWYisxbS9k?=
 =?utf-8?B?bDYybEd1QnJSY0VPZHBxOW1MYVRHWUUrU2lORXRyNGxxOUpKWjlaWUpFZHg2?=
 =?utf-8?B?MW9Wb0I4cVdmOUdFUWNMY3ZQSVFzdi9Fc294K2pwb2NtL0VobmZtbUgrOXYw?=
 =?utf-8?B?Zks1TlZhcUwvSGV4SUNWK0NMNkUweDFHZmJTVXJrZTFBSnVXMlF5b0U1ajVO?=
 =?utf-8?B?bEpXeE1UcGliQ3FYWTdnQ3JkdXFsdFBLcG8vK2RobFcxQmlLUFM0QkVUREFn?=
 =?utf-8?B?TDhkUTVQOEwzOFVMc2NlbWo5QWRPQlVuVG9Uc1U3dkZud29FMVNUM25ldFRk?=
 =?utf-8?Q?+9+yrSimik5lYN/YU/GwhLI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d12777f-cb6a-4d26-a31c-08db36e5057c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4239.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 21:22:27.3707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dCFBUOTY3ToxwpYuHCX51kFFA2eBhrHFV5MfOE1RTzElg+ruMLqaCR7xrC2hzymUDo10jAHTpmZY1wABuAxXfdnpWRh/XYXBWUSH5QFrR+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7791
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 11:42:28PM +0300, Lionel Landwerlin wrote:
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
ci failed to build, respin and submit
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>  drivers/gpu/drm/i915/gt/intel_workarounds.c | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> index 4aecb5a7b6318..f298dc461a72f 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> @@ -1144,6 +1144,7 @@
>  #define   ENABLE_SMALLPL			REG_BIT(15)
>  #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
>  #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
>  
>  #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
>  #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> index e7ee24bcad893..5bfc864d5fcc0 100644
> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> @@ -2971,6 +2971,25 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
>  
>  	add_render_compute_tuning_settings(i915, wal);
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
>  	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
>  	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0) ||
>  	    IS_DG2_GRAPHICS_STEP(i915, G10, STEP_B0, STEP_FOREVER) ||
> -- 
> 2.34.1
> 
