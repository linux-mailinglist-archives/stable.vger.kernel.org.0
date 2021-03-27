Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCE634B789
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 15:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhC0OUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 10:20:19 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:56741 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230030AbhC0OUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 10:20:08 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C20091643;
        Sat, 27 Mar 2021 10:20:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 27 Mar 2021 10:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YGa8sY
        xsYzrO74+mbLD/DdBWpQHvR9ge7PMDqLHGPv4=; b=D7cn1m98b2HmvZ5L0GGnjn
        /wpJcMRiULxHWj8SDzqPGtw/vYkmrM5Hzp1WLkL2hYO5RqpRxJhSpObh2kJAbg9J
        +0oEk3ATYhWhsXAlgBJ2yb4O97AwtdS83yhFAxNSRSTktxFVlIO68Dpy9TngvRNh
        3zxh3xuOVwxw4rkFAxkqWVefw0j9iKUgt7OvV1rXCaOoa4d65q1kq3L8XhgUM1dm
        O5SAftQsBWaXE7ImjnSpiI00n91aXM9rkneN/6MgS5KINHfdf9t1Q9AoX09NbToz
        hQ+rwnOK0cH4yCjxDji/ZXVMzlQg4pCgT3XpVOkrwPrBYo1iBDKvNJLct02Um4FQ
        ==
X-ME-Sender: <xms:Fj9fYFmD0TtohwR9RkemQ4BGMdWrju153UclJdKpIZ6pUIj3LQNTzw>
    <xme:Fj9fYC1OZXSBe9R8kT9X4PIPCQgPdl7TfMFcrUGLUJhHqKsQ7h5VPmIg5rjc1ZFlG
    GylXfIGESjxAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehgedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Fj9fYFA4UBOfMHO50Gb56BhS-1_dHAzVSGJzenyVSjQTs368m83N7A>
    <xmx:Fj9fYHzPpDZBPPEb9JygxErMs9roPqFFYasLBaoD8EhoLFCQaaHZqw>
    <xmx:Fj9fYLmskOZleW6A2xpQl-kv1uozV4vfKLBQo5ckwgr97gZUeEqCQQ>
    <xmx:Fz9fYKkDbeLHoas4jQpP0sNsKtKcm7kTjB92SQJyiWo0l0guuXFx8tDJbs4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77749240054;
        Sat, 27 Mar 2021 10:20:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Disable LTTPR support when the DPCD rev < 1.4" failed to apply to 5.11-stable tree
To:     imre.deak@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Mar 2021 15:20:05 +0100
Message-ID: <1616854805147121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7dffbdedb96a076843719d4ea5b2cd666481c416 Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Wed, 17 Mar 2021 21:01:49 +0200
Subject: [PATCH] drm/i915: Disable LTTPR support when the DPCD rev < 1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

By the specification the 0xF0000-0xF02FF range is only valid when the
DPCD revision is 1.4 or higher. Disable LTTPR support if this isn't so.

Trying to detect LTTPRs returned corrupted values for the above DPCD
range at least on a Skylake host with an LG 43UD79-B monitor with a DPCD
revision 1.2 connected.

v2: Add the actual version check.
v3: Fix s/DRPX/DPRX/ typo.

Fixes: 7b2a4ab8b0ef ("drm/i915: Switch to LTTPR transparent mode link training")
Cc: <stable@vger.kernel.org> # v5.11
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210317190149.4032966-1-imre.deak@intel.com
(cherry picked from commit 264613b406eb0d74cd9ca582c717c5e2c5a975ea)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 8c12d5375607..775d89b6c3fc 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3619,9 +3619,7 @@ intel_dp_get_dpcd(struct intel_dp *intel_dp)
 {
 	int ret;
 
-	intel_dp_lttpr_init(intel_dp);
-
-	if (drm_dp_read_dpcd_caps(&intel_dp->aux, intel_dp->dpcd))
+	if (intel_dp_init_lttpr_and_dprx_caps(intel_dp) < 0)
 		return false;
 
 	/*
diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index 35cda72492d7..c10e81a3d64f 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -34,6 +34,11 @@ intel_dp_dump_link_status(const u8 link_status[DP_LINK_STATUS_SIZE])
 		      link_status[3], link_status[4], link_status[5]);
 }
 
+static void intel_dp_reset_lttpr_common_caps(struct intel_dp *intel_dp)
+{
+	memset(&intel_dp->lttpr_common_caps, 0, sizeof(intel_dp->lttpr_common_caps));
+}
+
 static void intel_dp_reset_lttpr_count(struct intel_dp *intel_dp)
 {
 	intel_dp->lttpr_common_caps[DP_PHY_REPEATER_CNT -
@@ -95,8 +100,7 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
 
 	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
 					  intel_dp->lttpr_common_caps) < 0) {
-		memset(intel_dp->lttpr_common_caps, 0,
-		       sizeof(intel_dp->lttpr_common_caps));
+		intel_dp_reset_lttpr_common_caps(intel_dp);
 		return false;
 	}
 
@@ -118,30 +122,49 @@ intel_dp_set_lttpr_transparent_mode(struct intel_dp *intel_dp, bool enable)
 }
 
 /**
- * intel_dp_lttpr_init - detect LTTPRs and init the LTTPR link training mode
+ * intel_dp_init_lttpr_and_dprx_caps - detect LTTPR and DPRX caps, init the LTTPR link training mode
  * @intel_dp: Intel DP struct
  *
- * Read the LTTPR common capabilities, switch to non-transparent link training
- * mode if any is detected and read the PHY capabilities for all detected
- * LTTPRs. In case of an LTTPR detection error or if the number of
+ * Read the LTTPR common and DPRX capabilities and switch to non-transparent
+ * link training mode if any is detected and read the PHY capabilities for all
+ * detected LTTPRs. In case of an LTTPR detection error or if the number of
  * LTTPRs is more than is supported (8), fall back to the no-LTTPR,
  * transparent mode link training mode.
  *
  * Returns:
- *   >0  if LTTPRs were detected and the non-transparent LT mode was set
+ *   >0  if LTTPRs were detected and the non-transparent LT mode was set. The
+ *       DPRX capabilities are read out.
  *    0  if no LTTPRs or more than 8 LTTPRs were detected or in case of a
- *       detection failure and the transparent LT mode was set
+ *       detection failure and the transparent LT mode was set. The DPRX
+ *       capabilities are read out.
+ *   <0  Reading out the DPRX capabilities failed.
  */
-int intel_dp_lttpr_init(struct intel_dp *intel_dp)
+int intel_dp_init_lttpr_and_dprx_caps(struct intel_dp *intel_dp)
 {
 	int lttpr_count;
 	bool ret;
 	int i;
 
 	ret = intel_dp_read_lttpr_common_caps(intel_dp);
+
+	/* The DPTX shall read the DPRX caps after LTTPR detection. */
+	if (drm_dp_read_dpcd_caps(&intel_dp->aux, intel_dp->dpcd)) {
+		intel_dp_reset_lttpr_common_caps(intel_dp);
+		return -EIO;
+	}
+
 	if (!ret)
 		return 0;
 
+	/*
+	 * The 0xF0000-0xF02FF range is only valid if the DPCD revision is
+	 * at least 1.4.
+	 */
+	if (intel_dp->dpcd[DP_DPCD_REV] < 0x14) {
+		intel_dp_reset_lttpr_common_caps(intel_dp);
+		return 0;
+	}
+
 	lttpr_count = drm_dp_lttpr_count(intel_dp->lttpr_common_caps);
 	/*
 	 * Prevent setting LTTPR transparent mode explicitly if no LTTPRs are
@@ -181,7 +204,7 @@ int intel_dp_lttpr_init(struct intel_dp *intel_dp)
 
 	return lttpr_count;
 }
-EXPORT_SYMBOL(intel_dp_lttpr_init);
+EXPORT_SYMBOL(intel_dp_init_lttpr_and_dprx_caps);
 
 static u8 dp_voltage_max(u8 preemph)
 {
@@ -816,7 +839,10 @@ void intel_dp_start_link_train(struct intel_dp *intel_dp,
 	 * TODO: Reiniting LTTPRs here won't be needed once proper connector
 	 * HW state readout is added.
 	 */
-	int lttpr_count = intel_dp_lttpr_init(intel_dp);
+	int lttpr_count = intel_dp_init_lttpr_and_dprx_caps(intel_dp);
+
+	if (lttpr_count < 0)
+		return;
 
 	if (!intel_dp_link_train_all_phys(intel_dp, crtc_state, lttpr_count))
 		intel_dp_schedule_fallback_link_training(intel_dp, crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.h b/drivers/gpu/drm/i915/display/intel_dp_link_training.h
index 6a1f76bd8c75..9cb7c28027f0 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.h
@@ -11,7 +11,7 @@
 struct intel_crtc_state;
 struct intel_dp;
 
-int intel_dp_lttpr_init(struct intel_dp *intel_dp);
+int intel_dp_init_lttpr_and_dprx_caps(struct intel_dp *intel_dp);
 
 void intel_dp_get_adjust_train(struct intel_dp *intel_dp,
 			       const struct intel_crtc_state *crtc_state,

