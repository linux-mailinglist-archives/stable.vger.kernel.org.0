Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359D065D612
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbjADOkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239670AbjADOjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:39:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE5D6167
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:39:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B2C361748
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750C1C433D2;
        Wed,  4 Jan 2023 14:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843169;
        bh=Yj2Wk5z0dE6ZJivn7If0k4zwYCeJ0FZc4ZmC1XRtV0M=;
        h=Subject:To:Cc:From:Date:From;
        b=iOcQ8lfZJVjewSmJEUYMFBwuyqyLIAgIRlWIyTcnCJVl/mT8Yj4S2W294WArfSyvU
         QdK+HRF4QlkF3rlD9RsOQplz9YVh6gqyF9fFVe79I/5walp0jkK9ZsyGqZm27HDqq9
         B2+hop7yJ2OfFdE8peVBhSUWcgVgj73xQYAq4cTE=
Subject: FAILED: patch "[PATCH] drm/i915: Never return 0 if not all requests retired" failed to apply to 5.10-stable tree
To:     janusz.krzysztofik@linux.intel.com, andrzej.hajda@intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:39:15 +0100
Message-ID: <16728431552714@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

35aba5f51a39 ("drm/i915: Never return 0 if not all requests retired")
b97060a99b01 ("drm/i915/guc: Update intel_gt_wait_for_idle to work with GuC")
f4eb1f3fe946 ("drm/i915/guc: Ensure G2H response has space in buffer")
e0717063ccb4 ("drm/i915/guc: Defer context unpin until scheduling is disabled")
3a4cdf1982f0 ("drm/i915/guc: Implement GuC context operations for new inteface")
925dc1cf58ed ("drm/i915/guc: Implement GuC submission tasklet")
27213d79b384 ("drm/i915/guc: Add LRC descriptor context lookup array")
7518d9b67cf5 ("drm/i915/guc: Remove GuC stage descriptor, add LRC descriptor")
56bc88745e73 ("drm/i915/guc: Add new GuC interface defines and structures")
75452167a279 ("drm/i915/guc: Optimize CTB writes and reads")
b43b9950486e ("drm/i915/guc: Add stall timer to non blocking CTB send function")
1681924d8bde ("drm/i915/guc: Add non blocking CTB send function")
c26e289f1d8d ("drm/i915/guc: Increase size of CTB buffers")
572f2a5cd974 ("drm/i915/guc: Update firmware to v62.0.0")
22916bad07a5 ("drm/i915: Move submission tasklet to i915_sched_engine")
d2a31d026492 ("drm/i915: Update i915_scheduler to operate on i915_sched_engine")
71ed60112d5d ("drm/i915: Add kick_backend function to i915_sched_engine")
3f623e06cd56 ("drm/i915: Move engine->schedule to i915_sched_engine")
349a2bc5aae4 ("drm/i915: Move active tracking to i915_sched_engine")
c4fd7d8cc3ca ("drm/i915: Reset sched_engine.no_priolist immediately after dequeue")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 35aba5f51a39fb95351844ffb14ec02b8970e19f Mon Sep 17 00:00:00 2001
From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Date: Mon, 21 Nov 2022 15:56:55 +0100
Subject: [PATCH] drm/i915: Never return 0 if not all requests retired

Users of intel_gt_retire_requests_timeout() expect 0 return value on
success.  However, we have no protection from passing back 0 potentially
returned by a call to dma_fence_wait_timeout() when it succedes right
after its timeout has expired.

Replace 0 with -ETIME before potentially using the timeout value as return
code, so -ETIME is returned if there are still some requests not retired
after timeout, 0 otherwise.

v3: Use conditional expression, more compact but also better reflecting
    intention standing behind the change.

v2: Move the added lines down so flush_submission() is not affected.

Fixes: f33a8a51602c ("drm/i915: Merge wait_for_timelines with retire_request")
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221121145655.75141-3-janusz.krzysztofik@linux.intel.com
(cherry picked from commit f301a29f143760ce8d3d6b6a8436d45d3448cde6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_requests.c b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
index edb881d75630..1dfd01668c79 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_requests.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
@@ -199,7 +199,7 @@ out_active:	spin_lock(&timelines->lock);
 	if (remaining_timeout)
 		*remaining_timeout = timeout;
 
-	return active_count ? timeout : 0;
+	return active_count ? timeout ?: -ETIME : 0;
 }
 
 static void retire_work_handler(struct work_struct *work)

