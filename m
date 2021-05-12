Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995A037B997
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhELJuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:50:00 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:59017 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELJt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:49:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 9178B1465;
        Wed, 12 May 2021 05:48:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 12 May 2021 05:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8udKXj
        gFN731cMVHhOIORR54Bp73qV1TfXFE6k/4oOU=; b=JirXUrJtDA5TkJ6GiDnCZC
        /l4QIpIBe/uAYvrTCMYwv1T5BcLowUNdajwJgYFj2tcr2KXcdSoBkHMtFgHX32QI
        T95mniDnTsndGhv+DMJIxeNI62IzSbThrQnDwXz+5JQIndtW306mR4SGbNWEo29I
        2L1+BF1grXNJ4q0LYJCGZINw2Khn4n0OocnPVO+bYTE7AaPJkhmY8aXeCzEVOarj
        mlVUqjy/CGtCR8jpwkfF00e45HoosOS4u6EyThvJ4acS4wmGn8Zijg3UJWgRK1IO
        +4Hh/ZGTIvSIZkY59kxHw541fi72yqjydPvLM4Ynhf1xyzF5zlKEyWQkG6NktHpg
        ==
X-ME-Sender: <xms:g6SbYLJWXv8dooUhk5SXmsiBtAgOMUBcgjthbcdFoc_YoHV0JIv5Cw>
    <xme:g6SbYPLxHA0IHXct7ELkTiS_-7eF4kGNN0NroPm4cglJtSFUPkdkIWsOcfefrzqdz
    675LySOx7UQiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:g6SbYDvIKnUjMeTYc2gwJHudGWnGW1tZm1MdG1gzqK95RLqUHq5heA>
    <xmx:g6SbYEavY1iWB__LnalH3NZcqdwqDwVRhCIyFhOpouUVzychENR4qQ>
    <xmx:g6SbYCZJtrakUDClOHOlcuECDAv05yzKm_4l28VD0dEmJ1ZTNVL38Q>
    <xmx:g6SbYFwdKzne2izDTq7_TtFwF2pPtuFWSZOjdiiWwhVw1Kh4vyJ2hAkL3S8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:48:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Disable LTTPR support when the DPCD rev < 1.4" failed to apply to 5.12-stable tree
To:     imre.deak@intel.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:48:49 +0200
Message-ID: <16208129296775@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 264613b406eb0d74cd9ca582c717c5e2c5a975ea Mon Sep 17 00:00:00 2001
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

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index d46cd205241c..2c98335c260c 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3709,9 +3709,7 @@ intel_dp_get_dpcd(struct intel_dp *intel_dp)
 {
 	int ret;
 
-	intel_dp_lttpr_init(intel_dp);
-
-	if (drm_dp_read_dpcd_caps(&intel_dp->aux, intel_dp->dpcd))
+	if (intel_dp_init_lttpr_and_dprx_caps(intel_dp) < 0)
 		return false;
 
 	/*
diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index c0e25c75c105..f14ac2694183 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -35,6 +35,11 @@ intel_dp_dump_link_status(struct drm_device *drm,
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
@@ -96,8 +101,7 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
 
 	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
 					  intel_dp->lttpr_common_caps) < 0) {
-		memset(intel_dp->lttpr_common_caps, 0,
-		       sizeof(intel_dp->lttpr_common_caps));
+		intel_dp_reset_lttpr_common_caps(intel_dp);
 		return false;
 	}
 
@@ -119,30 +123,49 @@ intel_dp_set_lttpr_transparent_mode(struct intel_dp *intel_dp, bool enable)
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
@@ -182,7 +205,7 @@ int intel_dp_lttpr_init(struct intel_dp *intel_dp)
 
 	return lttpr_count;
 }
-EXPORT_SYMBOL(intel_dp_lttpr_init);
+EXPORT_SYMBOL(intel_dp_init_lttpr_and_dprx_caps);
 
 static u8 dp_voltage_max(u8 preemph)
 {
@@ -817,7 +840,10 @@ void intel_dp_start_link_train(struct intel_dp *intel_dp,
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

