Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572BB302670
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 15:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbhAYOqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:46:19 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42209 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729761AbhAYOqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:46:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 91A19EC4;
        Mon, 25 Jan 2021 09:44:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:44:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=osmfH5
        K9cPeDdQGdA/augmwtw/jdtFm3DCG4zltl0ao=; b=CCiQ8qrdqIuGTRllgi4+wm
        EWBXcQcEtNnej2D8uYIcMpWko+xGVAVr2Uwkq/j/yM8cqMP4Zlnnz0YDyaNV3Cyk
        VyNWBrEyPerSQnqLWFHBUTfzJQnMXICWfsmnB5JMNUmGk8xhwE70Hy2S+CvLh3k2
        zmkwkK+Jo4N+BuBys0+Bm+GTyEB9oC3l88PqkOQl0ouNDMmjr7ass+8w4hhvwMk7
        jt+zwPfnwhjHQhd/7fil84os8yCuqnDYsh/tL7rvDb0ah3JYSslBh5Y2Nptx7OXX
        pGhVx4A5C9+JlnxYjaOwTYD5vOXEexvv0gdJ0glXeA+hXdFA7H1JsiuOIBCA4kxw
        ==
X-ME-Sender: <xms:ZNkOYKULVsrea7VqyO6zzNY4mqjiNcPsMlCYWj46Z9HytpwD7zJdnw>
    <xme:ZNkOYGlPK48p3SOBwjFJZAHzVNlnjMq-lQgWhLm2eKrGM6IhDGH20SJMqC3Tu_ecB
    mIzYn_q6ozSdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ZNkOYOZ99Riy3HQ8qMwFjoP5vjbjHAbVs1Dz2UeyaLBZzqjGbCe37w>
    <xmx:ZNkOYBWrjvikg_hXT_HVu75X_R1ge-ugo3_NeL6Zqm53DsMD1HNYZQ>
    <xmx:ZNkOYEl6EywtDceGl3eZ2yOE_8aeqkEKNW4bj2QAkJ6bcfjJHeO4UQ>
    <xmx:ZdkOYAskBociQvR4Fw_CPiUFFAGbaUV5kVx9r_UkXSU4btdi6646xMDYbaw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 58FF4108005B;
        Mon, 25 Jan 2021 09:44:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/pmu: Don't grab wakeref when enabling events" failed to apply to 5.10-stable tree
To:     tvrtko.ursulin@intel.com, chris@chris-wilson.co.uk,
        jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:44:50 +0100
Message-ID: <1611585890220232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 171a8e99828144050015672016dd63494c6d200a Mon Sep 17 00:00:00 2001
From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Date: Mon, 18 Jan 2021 10:07:24 +0000
Subject: [PATCH] drm/i915/pmu: Don't grab wakeref when enabling events

Chris found a CI report which points out calling intel_runtime_pm_get from
inside i915_pmu_enable hook is not allowed since it can be invoked from
hard irq context. This is something we knew but forgot, so lets fix it
once again.

We do this by syncing the internal book keeping with hardware rc6 counter
on driver load.

v2:
 * Always sync on parking and fully sync on init.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: f4e9894b6952 ("drm/i915/pmu: Correct the rc6 offset upon enabling")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20201214094349.3563876-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit dbe13ae1d6abaab417edf3c37601c6a56594a4cd)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210118100724.465555-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index d76685ce0399..9856479b56d8 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -184,13 +184,24 @@ static u64 get_rc6(struct intel_gt *gt)
 	return val;
 }
 
-static void park_rc6(struct drm_i915_private *i915)
+static void init_rc6(struct i915_pmu *pmu)
 {
-	struct i915_pmu *pmu = &i915->pmu;
+	struct drm_i915_private *i915 = container_of(pmu, typeof(*i915), pmu);
+	intel_wakeref_t wakeref;
 
-	if (pmu->enable & config_enabled_mask(I915_PMU_RC6_RESIDENCY))
+	with_intel_runtime_pm(i915->gt.uncore->rpm, wakeref) {
 		pmu->sample[__I915_SAMPLE_RC6].cur = __get_rc6(&i915->gt);
+		pmu->sample[__I915_SAMPLE_RC6_LAST_REPORTED].cur =
+					pmu->sample[__I915_SAMPLE_RC6].cur;
+		pmu->sleep_last = ktime_get();
+	}
+}
 
+static void park_rc6(struct drm_i915_private *i915)
+{
+	struct i915_pmu *pmu = &i915->pmu;
+
+	pmu->sample[__I915_SAMPLE_RC6].cur = __get_rc6(&i915->gt);
 	pmu->sleep_last = ktime_get();
 }
 
@@ -201,6 +212,7 @@ static u64 get_rc6(struct intel_gt *gt)
 	return __get_rc6(gt);
 }
 
+static void init_rc6(struct i915_pmu *pmu) { }
 static void park_rc6(struct drm_i915_private *i915) {}
 
 #endif
@@ -612,10 +624,8 @@ static void i915_pmu_enable(struct perf_event *event)
 		container_of(event->pmu, typeof(*i915), pmu.base);
 	unsigned int bit = event_enabled_bit(event);
 	struct i915_pmu *pmu = &i915->pmu;
-	intel_wakeref_t wakeref;
 	unsigned long flags;
 
-	wakeref = intel_runtime_pm_get(&i915->runtime_pm);
 	spin_lock_irqsave(&pmu->lock, flags);
 
 	/*
@@ -626,13 +636,6 @@ static void i915_pmu_enable(struct perf_event *event)
 	GEM_BUG_ON(bit >= ARRAY_SIZE(pmu->enable_count));
 	GEM_BUG_ON(pmu->enable_count[bit] == ~0);
 
-	if (pmu->enable_count[bit] == 0 &&
-	    config_enabled_mask(I915_PMU_RC6_RESIDENCY) & BIT_ULL(bit)) {
-		pmu->sample[__I915_SAMPLE_RC6_LAST_REPORTED].cur = 0;
-		pmu->sample[__I915_SAMPLE_RC6].cur = __get_rc6(&i915->gt);
-		pmu->sleep_last = ktime_get();
-	}
-
 	pmu->enable |= BIT_ULL(bit);
 	pmu->enable_count[bit]++;
 
@@ -673,8 +676,6 @@ static void i915_pmu_enable(struct perf_event *event)
 	 * an existing non-zero value.
 	 */
 	local64_set(&event->hw.prev_count, __i915_pmu_event_read(event));
-
-	intel_runtime_pm_put(&i915->runtime_pm, wakeref);
 }
 
 static void i915_pmu_disable(struct perf_event *event)
@@ -1130,6 +1131,7 @@ void i915_pmu_register(struct drm_i915_private *i915)
 	hrtimer_init(&pmu->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	pmu->timer.function = i915_sample;
 	pmu->cpuhp.cpu = -1;
+	init_rc6(pmu);
 
 	if (!is_igp(i915)) {
 		pmu->name = kasprintf(GFP_KERNEL,

