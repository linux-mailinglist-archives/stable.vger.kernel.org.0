Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980F764A558
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 17:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbiLLQzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 11:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbiLLQzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 11:55:22 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17386275
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 08:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670864121; x=1702400121;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=COuSRcHdDHU2vlcvSq9Py/RPRSOHfyWnseXB6aYIILw=;
  b=Ss3FdtKCp5WcqfJpH83uRs/nKyPYJwif8LUYZAiVhMjWzVhqQM0ircpd
   t6nF/sgCNVAqUyYrCWTaE1NGGZMljG6MZBnjb+glS/kIJ96NsxOgzGvkU
   BF+muYjlfSvg/QtrAuRTjroclhR/WMU+naeg7jubttbHuZAleb8guc44H
   6IrGs94hSYYARhtkkm3h3j4FP4Dk/iTKM4kvN6DdblPA/k3TJyyd8dGfA
   Iofrwa6nuP+w94NaM/PtdksDoe+iKyrg0kzM0fh9ywSUiOz4WT05Nn9FV
   0QefpQ0kwhUNSwQE5IRhAZqInZAS2DI1iBtdHFpIfXNyAI7MgLQgO3LX5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="380113742"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="380113742"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 08:55:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="977112745"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="977112745"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 12 Dec 2022 08:55:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 08:55:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 08:55:18 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 08:55:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hobSJFDawGeyuFvZ3axSvekqjO0EAFcPLwmxqMrwB3YWHlN8xJF85mcCcH7ke6DwKATfmjAhrYoIZlgXd8XhOTEbDKdAWmsODfy9cbCc28DTL5Hj/CGlFWL0m1b6Marv254bpQ6eI53KgTsIvDtmaQ7E9WpdzKw+Mgx+yOrYCI2Uzo3BC3amKqydDQjVABU1BckTFLfeU/95xzgoNaVqztpkU1zTUKt6cIfSVOo80AQJcv8MsW2gIV5WDiqaS5VoABx/MgW7010WPEXYXOu4hfxu63T7Ns0mJHQXZMKlxcqWCodA+By//6yXnaYcFvNbv5BXi0t/pRm5BJsHPv8LfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TyEB9+inSLCckfIQGap+IXumQUO1tSWS14XzyTOOcQ=;
 b=nsAgk/PBneGbgmT+tEiUV9zrSF7ahQ2nCUdNlgKgsqm/GC8DHQQvUSHKhn3U0YekYW0nt04v02203WYMkwK1O+OZky9FBK+vE3d78cVXhLji4D+pFs8WF549OYirxXvCtcBwBQ3cXxZszHMjFcixNzZlqnJxk7NIDWgGXnXfr/bop2HIL6cooUUrz/aY53fZgQ92tPH79CdDr2C/J9qyFrYef/FxFDcAIaduDU0h6dArKo6dFYIEuMV9ngIwdzLKihuAsmKI2qkujWIC+AazdZm4KONLadu4s4SB6DC428G8Qbs7/eJVn3VmP7I6tr5NpZC7+4r8XzKlMd/jE8WpKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by DM8PR11MB5685.namprd11.prod.outlook.com (2603:10b6:8:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 16:55:16 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808%9]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 16:55:16 +0000
Date:   Mon, 12 Dec 2022 11:55:10 -0500
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Andi Shyti <andi.shyti@linux.intel.com>
CC:     <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <stable@vger.kernel.org>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        "Andi Shyti" <andi@etezian.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915/gt: Reset twice
Message-ID: <Y5dc7vhfh6yixFRo@intel.com>
References: <20221212161338.1007659-1-andi.shyti@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221212161338.1007659-1-andi.shyti@linux.intel.com>
X-ClientProxiedBy: BY5PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:a03:180::36) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|DM8PR11MB5685:EE_
X-MS-Office365-Filtering-Correlation-Id: a378611d-55f4-4322-6e22-08dadc61a3e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DejaZGL7CIobeE5x/YHrNIFPKKxkMl882ZGRiVnq7e2pyNHSXCSPktmeqcE/fiEQDoNwgmVJmgoFeItKomVBqoPo5dmzwUqRHQTFQD/jOnnzCyauzRzO6LtjUBGpNFGiYmi07joBrXCUvOgX11TiSUFvVBz9CgBILLZgtE1NWTRANBcua1q6f0zdKMxRNT1tqagC+ojeNarcLMGkiEJX2AUv2SePmURnwZUGZqABb9ngIg5uVmsEf+yc63xF31TT6JKY5sMxQ4vQKz5a8y9fqVuYD4tGKDHEAY6iuTW3NJ/A3DJT+PRNXJPZYV6+d3XRHJaHHs9dxC7Vayrk8VR7VuZSprTpvWgMkIj6Z8QELnHu2nCrtFBcxjLi2gToIPWrpIalSELVLkW7/wUOwgwGPmu/7yOsXg/scaiK5FkB0xYAbOCJGZ5Ebb6Nl+09bFfYpyydNIHY9eyqqPxG58a0KRif27LVSvLg7+0Dt3C+5UPuGY4HpiGv5tkHFK0mKmyxgqoTIWEEX14CahtNXQFNhjfadTQnP8+c2+0eGlt0nj9slULjxLkqbv0WR2x1ALUa2xfSeD3EUPWmQl9OGAV5MmxKG61hzFPJo+WF1nr6oooXnVnAxrh8+YN9kHOny2qBX8VzzVMeCWHgN9aYEEqyhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(82960400001)(38100700002)(86362001)(8676002)(316002)(4326008)(186003)(6916009)(2906002)(66946007)(44832011)(66556008)(478600001)(5660300002)(8936002)(41300700001)(66476007)(2616005)(83380400001)(26005)(6512007)(54906003)(6506007)(6666004)(6486002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hlzJBThdL4HGQ1OGwlM68iEM2OmEoiBDP80QCynyl59fDfzXNZGFJlFQ0ZQn?=
 =?us-ascii?Q?6EXyEScryur+QDSqhLIC93AkLBMYGTT8eThbaJSSL1dOE5kCRUwLr0t79nf2?=
 =?us-ascii?Q?TSLrwulFzEAS84fpNNIbc6t9FnzwuuJUzBlFAInvWhZsov6YaAIivGuF6JJp?=
 =?us-ascii?Q?D38CrvIwatnTR9+QTb46fZkppxfC3+rOPLexwNbB+xCqIfKMFosPr02E4Py8?=
 =?us-ascii?Q?kxo7u2v1IIxBDEnOGW09j9siNYzBHC+7Q10zCzxIN4BL8AtxLc/SbdSMy2YO?=
 =?us-ascii?Q?8CqnhKFTjOoMTTNGS2E1KWW23dy7zJ8Vt6c+WiocVIT6JaDPqNoMXkX8vF+M?=
 =?us-ascii?Q?XJvmqe5BrvIonpoqiDA7Ias/aawiv2tD956wHrIC2tEN4uuWHYQ2C2UQV/zW?=
 =?us-ascii?Q?EYw9LcZAcM4GbUfpo/N73E8Xa9fAmqxXAkR1qZmiQytjSdqSwQovzGHgs2cl?=
 =?us-ascii?Q?4z5a38jMGEbu7yySEvmSqQWvslq3Hs7GDcg90H6H6sf0DIJtWRnC3iW9yYQn?=
 =?us-ascii?Q?qLqiNTUu3ysdVzd3sb5zJIgeb/zAyKFpIcmWKVjkVU6SrT+XJSn9k9jk319B?=
 =?us-ascii?Q?Gtw+owBYQIp12//BUKTGwhWnAKXQ97PWbFfxc1KLISeOaVDI6nkEZ0gbejaL?=
 =?us-ascii?Q?GpHNHbUgsl1UPbhOLtSNUtzuYNcrncevgy2+wnDp280gJsfxDb+TvCv7dUjw?=
 =?us-ascii?Q?m4JejB5V0FmMoPNLSxCyYFI3GqtdC/AAMeE0l1t6NHVrIV9spdSzOyKjmaJN?=
 =?us-ascii?Q?OLu3IH9Y6yq7mnz8N/06uvmTnM7ZTNpuZzv/cuCMW51xSGtONsLZSp7Y0h6D?=
 =?us-ascii?Q?x+PwWFxuyA6SUW/CDosX+AKUljrCRxuoilnF7oN3ne76bO45Km4ws6G+n/mW?=
 =?us-ascii?Q?XdybZgzpJu1wJXzS5+c0x1busL0BR2EWfrmgVcEWyvLBeo9enN/vqfQkL94/?=
 =?us-ascii?Q?K/NEVKs7Nd3pwBRwNhTKgjG/tLeP1YBA8wFtkbnXlbeT6D5JLlShgPG5dbfD?=
 =?us-ascii?Q?0KnnOFylr1rcadTFUvJWdaYXDW+ggWxgJ4PSJeFFnm5+Y/7C8yDoSfB1+72W?=
 =?us-ascii?Q?d+FK2ltkt0FQVt3yrlhVdL8lpdUrPMHnA2watQu6SmUr1jBqhfEG70nCoLNG?=
 =?us-ascii?Q?ls25KfSa6LR0IvaO9fZaliiSWWYwpI6UAeuht/Ma3T5oYkTrCrVpA4p9gx/z?=
 =?us-ascii?Q?FDZw3RLmTBpt71cto7txUZsid4FflnHHXRmCMQQCOnAwH4KJymkvwWYJipcu?=
 =?us-ascii?Q?gTnpjYltUeyFkjmS4wZXj08322Ew+yVIz4Pv7JoOU4ge5uQ52QcmicfVNuji?=
 =?us-ascii?Q?CYaPWmuXudr8VHN2PxnDr+mKRpMs+5cT6zKRJX836d45hUA0fxghM0kpG33c?=
 =?us-ascii?Q?862E0sw9Tvv7K1DE1sDkFNIv7KmJCCyZVFL0YzfzZH1vN53iH5FkH69eg8zM?=
 =?us-ascii?Q?g7nKpWSdmoOrXub61WMTO/fCP6uFrvlPa28Vsl1lKPyGl2vSEYfPxSHbNWY0?=
 =?us-ascii?Q?tEt8VBepy/t39mjXdpXQ5pryjX+zoXdLppxOW6cigxKsw8eFazNdtSHO9hiZ?=
 =?us-ascii?Q?teG60lkH40G0GEsEOAiRAWW1W9shnSdltVheOrWooieChOEzHtFbqklmfVMC?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a378611d-55f4-4322-6e22-08dadc61a3e9
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 16:55:16.1905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXk2x0liueRYjXYAXtnmO2xLUZ+w2L5yzgFD30JdhgWl7xkjSoeGiCLE6Bg3lJto2jQxeRBUS8EMtkHZAqEUNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5685
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 05:13:38PM +0100, Andi Shyti wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> After applying an engine reset, on some platforms like Jasperlake, we
> occasionally detect that the engine state is not cleared until shortly
> after the resume. As we try to resume the engine with volatile internal
> state, the first request fails with a spurious CS event (it looks like
> it reports a lite-restore to the hung context, instead of the expected
> idle->active context switch).
> 
> Signed-off-by: Chris Wilson <hris@chris-wilson.co.uk>

There's a typo in the signature email I'm afraid...

Other than that, have we checked the possibility of using the driver-initiated-flr bit
instead of this second loop? That should be the right way to guarantee everything is
cleared on gen11+...

> Cc: stable@vger.kernel.org
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/gt/intel_reset.c | 34 ++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
> index ffde89c5835a4..88dfc0c5316ff 100644
> --- a/drivers/gpu/drm/i915/gt/intel_reset.c
> +++ b/drivers/gpu/drm/i915/gt/intel_reset.c
> @@ -268,6 +268,7 @@ static int ilk_do_reset(struct intel_gt *gt, intel_engine_mask_t engine_mask,
>  static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
>  {
>  	struct intel_uncore *uncore = gt->uncore;
> +	int loops = 2;
>  	int err;
>  
>  	/*
> @@ -275,18 +276,39 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
>  	 * for fifo space for the write or forcewake the chip for
>  	 * the read
>  	 */
> -	intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
> +	do {
> +		intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
>  
> -	/* Wait for the device to ack the reset requests */
> -	err = __intel_wait_for_register_fw(uncore,
> -					   GEN6_GDRST, hw_domain_mask, 0,
> -					   500, 0,
> -					   NULL);
> +		/*
> +		 * Wait for the device to ack the reset requests.
> +		 *
> +		 * On some platforms, e.g. Jasperlake, we see see that the
> +		 * engine register state is not cleared until shortly after
> +		 * GDRST reports completion, causing a failure as we try
> +		 * to immediately resume while the internal state is still
> +		 * in flux. If we immediately repeat the reset, the second
> +		 * reset appears to serialise with the first, and since
> +		 * it is a no-op, the registers should retain their reset
> +		 * value. However, there is still a concern that upon
> +		 * leaving the second reset, the internal engine state
> +		 * is still in flux and not ready for resuming.
> +		 */
> +		err = __intel_wait_for_register_fw(uncore, GEN6_GDRST,
> +						   hw_domain_mask, 0,
> +						   2000, 0,
> +						   NULL);
> +	} while (err == 0 && --loops);
>  	if (err)
>  		GT_TRACE(gt,
>  			 "Wait for 0x%08x engines reset failed\n",
>  			 hw_domain_mask);
>  
> +	/*
> +	 * As we have observed that the engine state is still volatile
> +	 * after GDRST is acked, impose a small delay to let everything settle.
> +	 */
> +	udelay(50);
> +
>  	return err;
>  }
>  
> -- 
> 2.38.1
> 
