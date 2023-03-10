Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FC76B3E1E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCJLip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjCJLim (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:38:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE507B12E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65D9EB82277
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB70C4339B;
        Fri, 10 Mar 2023 11:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448316;
        bh=FAp4ir9ubx9UyUB63wkzpzB/uZUuUfnxOEJnd0dw1mw=;
        h=Subject:To:Cc:From:Date:From;
        b=z2WY27X6KgzQyETX8AmljFdGaqX12kBv4nlqPfbWjg+5ZQV6V2Ou9pO1fcFVvkrG1
         nH2aEYSZPMLDqHcjj345kH2PAHr8AFO8Vkti3Dzvq7HfmGVyymiv04dSNJRnphEh0M
         Hm0DHPenZCMXN8WSNOqww+nPNgz/246KtGsxJI5Y=
Subject: FAILED: patch "[PATCH] drm/i915/gt: Reset twice" failed to apply to 4.14-stable tree
To:     chris@chris-wilson.co.uk, andi.shyti@linux.intel.com,
        gwan-gyeong.mun@intel.com, mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:38:08 +0100
Message-ID: <1678448288166151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 3db9d590557da3aa2c952f2fecd3e9b703dad790
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678448288166151@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

3db9d590557d ("drm/i915/gt: Reset twice")
cb823ed9915b ("drm/i915/gt: Use intel_gt as the primary object for handling resets")
f2db53f14d3d ("drm/i915: Replace "_load" with "_probe" consequently")
b5893ffc274b ("drm/i915: Drop extern qualifiers from header function prototypes")
2a98f4e65bba ("drm/i915: add infrastructure to hold off preemption on a request")
b8cade5959ac ("drm/i915: Show instdone for each engine in debugfs")
63251685c141 ("drm/i915/selftests: Common live setup/teardown")
092be382a260 ("drm/i915: Lift intel_engines_resume() to callers")
18398904ca9e ("drm/i915: Only recover active engines")
faaa2902b5a9 ("drm/i915/selftests: Fixup atomic reset checking")
1e5deb263265 ("drm/i915/selftests: Drop manual request wakerefs around hangcheck")
d84747956654 ("drm/i915/selftests: Serialise nop reset with retirement")
5f22e5b3116c ("drm/i915: Rename intel_wakeref_[is]_active")
0c91621cad49 ("drm/i915/gt: Pass intel_gt to pm routines")
a93615f900bd ("drm/i915: Throw away the active object retirement complexity")
db56f974941b ("drm/i915: Eliminate dual personality of i915_scratch_offset")
f0c02c1b9188 ("drm/i915: Rename i915_timeline to intel_timeline and move under gt")
4c6d51ea2a68 ("drm/i915: Make timelines gt centric")
ba4134a41931 ("drm/i915: Save trip via top-level i915 in a few more places")
390c82055b74 ("drm/i915: Compartmentalize timeline_init/park/fini")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3db9d590557da3aa2c952f2fecd3e9b703dad790 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 12 Dec 2022 17:13:38 +0100
Subject: [PATCH] drm/i915/gt: Reset twice

After applying an engine reset, on some platforms like Jasperlake, we
occasionally detect that the engine state is not cleared until shortly
after the resume. As we try to resume the engine with volatile internal
state, the first request fails with a spurious CS event (it looks like
it reports a lite-restore to the hung context, instead of the expected
idle->active context switch).

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221212161338.1007659-1-andi.shyti@linux.intel.com

diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index ffde89c5835a..0bb9094fdacd 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -268,6 +268,7 @@ static int ilk_do_reset(struct intel_gt *gt, intel_engine_mask_t engine_mask,
 static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 {
 	struct intel_uncore *uncore = gt->uncore;
+	int loops = 2;
 	int err;
 
 	/*
@@ -275,18 +276,39 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 	 * for fifo space for the write or forcewake the chip for
 	 * the read
 	 */
-	intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
+	do {
+		intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
 
-	/* Wait for the device to ack the reset requests */
-	err = __intel_wait_for_register_fw(uncore,
-					   GEN6_GDRST, hw_domain_mask, 0,
-					   500, 0,
-					   NULL);
+		/*
+		 * Wait for the device to ack the reset requests.
+		 *
+		 * On some platforms, e.g. Jasperlake, we see that the
+		 * engine register state is not cleared until shortly after
+		 * GDRST reports completion, causing a failure as we try
+		 * to immediately resume while the internal state is still
+		 * in flux. If we immediately repeat the reset, the second
+		 * reset appears to serialise with the first, and since
+		 * it is a no-op, the registers should retain their reset
+		 * value. However, there is still a concern that upon
+		 * leaving the second reset, the internal engine state
+		 * is still in flux and not ready for resuming.
+		 */
+		err = __intel_wait_for_register_fw(uncore, GEN6_GDRST,
+						   hw_domain_mask, 0,
+						   2000, 0,
+						   NULL);
+	} while (err == 0 && --loops);
 	if (err)
 		GT_TRACE(gt,
 			 "Wait for 0x%08x engines reset failed\n",
 			 hw_domain_mask);
 
+	/*
+	 * As we have observed that the engine state is still volatile
+	 * after GDRST is acked, impose a small delay to let everything settle.
+	 */
+	udelay(50);
+
 	return err;
 }
 

