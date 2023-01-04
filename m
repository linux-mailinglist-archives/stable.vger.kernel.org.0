Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA19465D7C7
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjADQCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbjADQCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:02:35 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8231B9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672848153; x=1704384153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JhV81kMA/G8bwiJIDO3RUAdAC3yJX6bX7Gs4inpBBVk=;
  b=SCyI97QqG3f8joL60oshM2DuJMTSyIQ7NdP/RzLb3fW9WC2Ni2eDt7Uh
   igNvyCiPQ65Kjk03yN5hMhNdAWpWJcVjQqEWigcDXnDKjuoscruV4/EGG
   lYczKopzF8mk4Fry845pWy/apvzEZ/Mow6FR7k9xLUc9watYfIWhYL/G1
   PRBHfzXnj7PtCdvXuxjExp/hVfVHSbyNIg3D/CHXYj6xqx75P9wQ3rZjZ
   Mr6ERzxQramBX9fNCVel7loZ5nJMXylxAmAs3w4UnpJkIEfleusEgjczE
   Qr6ADTrvKGTjr0f+DTYd92Cd4tqdoIuvANL5KxVYgDPEAVZiHS0oIvhvb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="384258625"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="384258625"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 08:02:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="687570089"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="687570089"
Received: from atroka-mobl.ger.corp.intel.com (HELO jkrzyszt-mobl1.ger.corp.intel.com) ([10.213.19.88])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 08:02:13 -0800
From:   Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
To:     andrzej.hajda@intel.com, rodrigo.vivi@intel.com,
        tvrtko.ursulin@intel.com, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org,
        Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Subject: Re: FAILED: patch "[PATCH] drm/i915: Never return 0 if not all requests retired" failed to apply to 5.10-stable tree
Date:   Wed, 04 Jan 2023 17:02:10 +0100
Message-ID: <13175047.uLZWGnKmhe@jkrzyszt-mobl1.ger.corp.intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <16728431552714@kroah.com>
References: <16728431552714@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wednesday, 4 January 2023 15:39:15 CET gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.

FYI, I can see it already added to v5.10.158, commit 
648b92e5760721fbf230e242950182d7e9222143.  The same for other stable trees 
as well as my other fixes for which I received such failure reports from you 
today.

Thanks,
Janusz

> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 35aba5f51a39 ("drm/i915: Never return 0 if not all requests retired")
> b97060a99b01 ("drm/i915/guc: Update intel_gt_wait_for_idle to work with GuC")
> f4eb1f3fe946 ("drm/i915/guc: Ensure G2H response has space in buffer")
> e0717063ccb4 ("drm/i915/guc: Defer context unpin until scheduling is disabled")
> 3a4cdf1982f0 ("drm/i915/guc: Implement GuC context operations for new inteface")
> 925dc1cf58ed ("drm/i915/guc: Implement GuC submission tasklet")
> 27213d79b384 ("drm/i915/guc: Add LRC descriptor context lookup array")
> 7518d9b67cf5 ("drm/i915/guc: Remove GuC stage descriptor, add LRC descriptor")
> 56bc88745e73 ("drm/i915/guc: Add new GuC interface defines and structures")
> 75452167a279 ("drm/i915/guc: Optimize CTB writes and reads")
> b43b9950486e ("drm/i915/guc: Add stall timer to non blocking CTB send function")
> 1681924d8bde ("drm/i915/guc: Add non blocking CTB send function")
> c26e289f1d8d ("drm/i915/guc: Increase size of CTB buffers")
> 572f2a5cd974 ("drm/i915/guc: Update firmware to v62.0.0")
> 22916bad07a5 ("drm/i915: Move submission tasklet to i915_sched_engine")
> d2a31d026492 ("drm/i915: Update i915_scheduler to operate on i915_sched_engine")
> 71ed60112d5d ("drm/i915: Add kick_backend function to i915_sched_engine")
> 3f623e06cd56 ("drm/i915: Move engine->schedule to i915_sched_engine")
> 349a2bc5aae4 ("drm/i915: Move active tracking to i915_sched_engine")
> c4fd7d8cc3ca ("drm/i915: Reset sched_engine.no_priolist immediately after dequeue")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 35aba5f51a39fb95351844ffb14ec02b8970e19f Mon Sep 17 00:00:00 2001
> From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
> Date: Mon, 21 Nov 2022 15:56:55 +0100
> Subject: [PATCH] drm/i915: Never return 0 if not all requests retired
> 
> Users of intel_gt_retire_requests_timeout() expect 0 return value on
> success.  However, we have no protection from passing back 0 potentially
> returned by a call to dma_fence_wait_timeout() when it succedes right
> after its timeout has expired.
> 
> Replace 0 with -ETIME before potentially using the timeout value as return
> code, so -ETIME is returned if there are still some requests not retired
> after timeout, 0 otherwise.
> 
> v3: Use conditional expression, more compact but also better reflecting
>     intention standing behind the change.
> 
> v2: Move the added lines down so flush_submission() is not affected.
> 
> Fixes: f33a8a51602c ("drm/i915: Merge wait_for_timelines with retire_request")
> Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
> Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
> Cc: stable@vger.kernel.org # v5.5+
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20221121145655.75141-3-janusz.krzysztofik@linux.intel.com
> (cherry picked from commit f301a29f143760ce8d3d6b6a8436d45d3448cde6)
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_requests.c b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
> index edb881d75630..1dfd01668c79 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt_requests.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
> @@ -199,7 +199,7 @@ out_active:	spin_lock(&timelines->lock);
>  	if (remaining_timeout)
>  		*remaining_timeout = timeout;
>  
> -	return active_count ? timeout : 0;
> +	return active_count ? timeout ?: -ETIME : 0;
>  }
>  
>  static void retire_work_handler(struct work_struct *work)
> 
> 




