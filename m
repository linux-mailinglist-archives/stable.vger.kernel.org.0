Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C28934B78A
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 15:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhC0OUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 10:20:52 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:45551 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229990AbhC0OUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 10:20:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2296C162D;
        Sat, 27 Mar 2021 10:20:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 27 Mar 2021 10:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CKmYuW
        p5MIuUQbZRG10guCIErdaNkeAU8Xj7kqkYPHo=; b=gRbKtwlb7kab+KEi390TCg
        Omun7mcA1DnL06DvnSga/ZrL9tNwC3fl4A8ot2iKNoWd/Mh4ru1Yjd5YN3/wGwkL
        Zp41YmtlOEWlCW2gvoA8mVvWRklEg17IyiCMx5rZlnAyKwzFJwINxvibyYuVMZh9
        1Y0ftoqjYQTVJiVcdsoT4U/xzS97JIt5KEVaoVv/PxlOVB1Z3zShdz+YWOfg3VGk
        ojAZKpK7C6xy7wN0SZ46G+UJhNM0Kyx0OE/TD4wkvFZ/Z+tdxV2jswxbCDGkXknw
        rr03twn8t9q/liEWIW4b5OVvjPMv/st82tplox8TdOoGYfa0hjNVGcVQ44ViHDPw
        ==
X-ME-Sender: <xms:Oz9fYAckWTW43F6SdXYeNP_QqwNdnuhqXyrCKUCQloUZK0Mv8tv_QA>
    <xme:Oz9fYCO9vF2vppnZfHXY4FzvtETWCY01klnReks5F31deCFIIM5fXnR66Ca0MOpTB
    OviRagiy84C0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehgedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Oz9fYBhS7ijqw3lNyqrZD04qNjzMrlxID5BoFj543B7sfOxliGOxTg>
    <xmx:Oz9fYF_wPU5HM9cadDDVulMbV2U5m9z_smTB5e94AWazWQ0hqtJ_zQ>
    <xmx:Oz9fYMt2LCxyAEOJYakhVGip3BLMqzb4PAvH2Kivi2wq4cnGw5Im7Q>
    <xmx:Oz9fYJUIWWgZ71-TuUiO8_dJwJfaGeJorX6oeHaMyNCNwQHy8InJ3ciW9Ck>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6EAC1108005C;
        Sat, 27 Mar 2021 10:20:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Fix the GT fence revocation runtime PM logic" failed to apply to 4.19-stable tree
To:     imre.deak@intel.com, chris@chris-wilson.co.uk,
        rodrigo.vivi@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Mar 2021 15:20:33 +0100
Message-ID: <161685483348122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8840e3bd981f128846b01c12d3966d115e8617c9 Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Mon, 22 Mar 2021 22:28:17 +0200
Subject: [PATCH] drm/i915: Fix the GT fence revocation runtime PM logic

To optimize some task deferring it until runtime resume unless someone
holds a runtime PM reference (because in this case the task can be done
w/o the overhead of runtime resume), we have to use the runtime PM
get-if-active logic: If the runtime PM usage count is 0 (and so
get-if-in-use would return false) the runtime suspend handler is not
necessarily called yet (it could be just pending), so the device is not
necessarily powered down, and so the runtime resume handler is not
guaranteed to be called.

The fence revocation depends on the above deferral, so add a
get-if-active helper and use it during fence revocation.

v2:
- Add code comment explaining the fence reg programming deferral logic
  to i915_vma_revoke_fence(). (Chris)
- Add Cc: stable and Fixes: tags. (Chris)
- Fix the function docbook comment.

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.12+
Fixes: 181df2d458f3 ("drm/i915: Take rpm wakelock for releasing the fence on unbind")
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210322204223.919936-1-imre.deak@intel.com
(cherry picked from commit 9d58aa46291d4d696bb1eac3436d3118f7bf2573)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
index a357bb431815..67de2b189598 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
@@ -316,7 +316,18 @@ void i915_vma_revoke_fence(struct i915_vma *vma)
 	WRITE_ONCE(fence->vma, NULL);
 	vma->fence = NULL;
 
-	with_intel_runtime_pm_if_in_use(fence_to_uncore(fence)->rpm, wakeref)
+	/*
+	 * Skip the write to HW if and only if the device is currently
+	 * suspended.
+	 *
+	 * If the driver does not currently hold a wakeref (if_in_use == 0),
+	 * the device may currently be runtime suspended, or it may be woken
+	 * up before the suspend takes place. If the device is not suspended
+	 * (powered down) and we skip clearing the fence register, the HW is
+	 * left in an undefined state where we may end up with multiple
+	 * registers overlapping.
+	 */
+	with_intel_runtime_pm_if_active(fence_to_uncore(fence)->rpm, wakeref)
 		fence_write(fence);
 }
 
diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.c b/drivers/gpu/drm/i915/intel_runtime_pm.c
index 153ca9e65382..8b725efb2254 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -412,12 +412,20 @@ intel_wakeref_t intel_runtime_pm_get(struct intel_runtime_pm *rpm)
 }
 
 /**
- * intel_runtime_pm_get_if_in_use - grab a runtime pm reference if device in use
+ * __intel_runtime_pm_get_if_active - grab a runtime pm reference if device is active
  * @rpm: the intel_runtime_pm structure
+ * @ignore_usecount: get a ref even if dev->power.usage_count is 0
  *
  * This function grabs a device-level runtime pm reference if the device is
- * already in use and ensures that it is powered up. It is illegal to try
- * and access the HW should intel_runtime_pm_get_if_in_use() report failure.
+ * already active and ensures that it is powered up. It is illegal to try
+ * and access the HW should intel_runtime_pm_get_if_active() report failure.
+ *
+ * If @ignore_usecount=true, a reference will be acquired even if there is no
+ * user requiring the device to be powered up (dev->power.usage_count == 0).
+ * If the function returns false in this case then it's guaranteed that the
+ * device's runtime suspend hook has been called already or that it will be
+ * called (and hence it's also guaranteed that the device's runtime resume
+ * hook will be called eventually).
  *
  * Any runtime pm reference obtained by this function must have a symmetric
  * call to intel_runtime_pm_put() to release the reference again.
@@ -425,7 +433,8 @@ intel_wakeref_t intel_runtime_pm_get(struct intel_runtime_pm *rpm)
  * Returns: the wakeref cookie to pass to intel_runtime_pm_put(), evaluates
  * as True if the wakeref was acquired, or False otherwise.
  */
-intel_wakeref_t intel_runtime_pm_get_if_in_use(struct intel_runtime_pm *rpm)
+static intel_wakeref_t __intel_runtime_pm_get_if_active(struct intel_runtime_pm *rpm,
+							bool ignore_usecount)
 {
 	if (IS_ENABLED(CONFIG_PM)) {
 		/*
@@ -434,7 +443,7 @@ intel_wakeref_t intel_runtime_pm_get_if_in_use(struct intel_runtime_pm *rpm)
 		 * function, since the power state is undefined. This applies
 		 * atm to the late/early system suspend/resume handlers.
 		 */
-		if (pm_runtime_get_if_in_use(rpm->kdev) <= 0)
+		if (pm_runtime_get_if_active(rpm->kdev, ignore_usecount) <= 0)
 			return 0;
 	}
 
@@ -443,6 +452,16 @@ intel_wakeref_t intel_runtime_pm_get_if_in_use(struct intel_runtime_pm *rpm)
 	return track_intel_runtime_pm_wakeref(rpm);
 }
 
+intel_wakeref_t intel_runtime_pm_get_if_in_use(struct intel_runtime_pm *rpm)
+{
+	return __intel_runtime_pm_get_if_active(rpm, false);
+}
+
+intel_wakeref_t intel_runtime_pm_get_if_active(struct intel_runtime_pm *rpm)
+{
+	return __intel_runtime_pm_get_if_active(rpm, true);
+}
+
 /**
  * intel_runtime_pm_get_noresume - grab a runtime pm reference
  * @rpm: the intel_runtime_pm structure
diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.h b/drivers/gpu/drm/i915/intel_runtime_pm.h
index ae64ff14c642..1e4ddd11c12b 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.h
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.h
@@ -177,6 +177,7 @@ void intel_runtime_pm_driver_release(struct intel_runtime_pm *rpm);
 
 intel_wakeref_t intel_runtime_pm_get(struct intel_runtime_pm *rpm);
 intel_wakeref_t intel_runtime_pm_get_if_in_use(struct intel_runtime_pm *rpm);
+intel_wakeref_t intel_runtime_pm_get_if_active(struct intel_runtime_pm *rpm);
 intel_wakeref_t intel_runtime_pm_get_noresume(struct intel_runtime_pm *rpm);
 intel_wakeref_t intel_runtime_pm_get_raw(struct intel_runtime_pm *rpm);
 
@@ -188,6 +189,10 @@ intel_wakeref_t intel_runtime_pm_get_raw(struct intel_runtime_pm *rpm);
 	for ((wf) = intel_runtime_pm_get_if_in_use(rpm); (wf); \
 	     intel_runtime_pm_put((rpm), (wf)), (wf) = 0)
 
+#define with_intel_runtime_pm_if_active(rpm, wf) \
+	for ((wf) = intel_runtime_pm_get_if_active(rpm); (wf); \
+	     intel_runtime_pm_put((rpm), (wf)), (wf) = 0)
+
 void intel_runtime_pm_put_unchecked(struct intel_runtime_pm *rpm);
 #if IS_ENABLED(CONFIG_DRM_I915_DEBUG_RUNTIME_PM)
 void intel_runtime_pm_put(struct intel_runtime_pm *rpm, intel_wakeref_t wref);

