Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE955B4470
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 08:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiIJG3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 02:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIJG3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 02:29:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C11A9FE8
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 23:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B00B60BED
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 06:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7035C433C1;
        Sat, 10 Sep 2022 06:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662791372;
        bh=ZsO15zVycPJPJpBtLzyhY9Js6Z2FhQG+YNKavQ9D+H0=;
        h=Subject:To:Cc:From:Date:From;
        b=V/KLEO7WqNhQNAGx+Ysko8FUVNJqjIJyot+OVM3wRSoKBWZ7KtaDiOy1I75LsizFJ
         y3JeUpZ3nmZ9WF8D2F88+1HEPGRWWHZDS2tBMAY5VtOXCRgmPkoI13Mjpp0NERx/Co
         zd67d19euu3FXo0akSqgDkeD/SI2MokP9JNJw4dQ=
Subject: FAILED: patch "[PATCH] drm/i915/slpc: Let's fix the PCODE min freq table setup for" failed to apply to 5.15-stable tree
To:     rodrigo.vivi@intel.com, ashutosh.dixit@intel.com,
        stable@vger.kernel.org, sushma.venkatesh.reddy@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Sep 2022 08:29:54 +0200
Message-ID: <166279139419416@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e1cab970574c ("drm/i915/slpc: Let's fix the PCODE min freq table setup for SLPC")
4dd4375bc4ff ("drm/i915: split out intel_pcode.[ch] to separate file")
1eecf31e3c96 ("drm/i915: split out vlv sideband to a separate file")
5f5ada0bae45 ("drm/i915: De-wrapper bxt_ddi_phy_set_signal_levels()")
193299ad9d85 ("drm/i915: Nuke useless .set_signal_levels() wrappers")
e722ab8b6968 ("drm/i915: Generalize .set_signal_levels()")
5bafd85dd770 ("drm/i915: Introduce has_buf_trans_select()")
f820693bc238 ("drm/i915: Introduce has_iboost()")
80e77e30a212 ("drm/i915/dpll: move dpll modeset asserts to intel_dpll.c")
aa0813b1ba31 ("drm/i915/pps: move pps (panel) modeset asserts to intel_pps.c")
e04a911f4366 ("drm/i915/fdi: move fdi modeset asserts to intel_fdi.c")
e505d76404b1 ("drm/i915: s/ddi_translations/trans/")
4360a2b54fd7 ("drm/i915/display: add intel_fdi_link_train wrapper.")
8c66081b0b32 ("drm/i915: s/pipe/transcoder/ when dealing with PIPECONF/TRANSCONF")
a338847abc8e ("drm/i915: Call {vlv,chv}_prepare_pll() from {vlv,chv}_enable_pll()")
510e890e8222 ("drm/i915: Remove the 'reg' local variable")
8a3b3df39757 ("drm/i915: Clean up variable names in old dpll functions")
6205372b4b6d ("drm/i915: Clean dpll calling convention")
24951b5813c1 ("drm/i915: Constify struct dpll all over")
b294425e9091 ("drm/i915: Extract ilk_update_pll_dividers()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e1cab970574c001d83e59ca8388c474a57a1afb6 Mon Sep 17 00:00:00 2001
From: Rodrigo Vivi <rodrigo.vivi@intel.com>
Date: Wed, 31 Aug 2022 17:45:38 -0400
Subject: [PATCH] drm/i915/slpc: Let's fix the PCODE min freq table setup for
 SLPC

We need to inform PCODE of a desired ring frequencies so PCODE update
the memory frequencies to us. rps->min_freq and rps->max_freq are the
frequencies used in that request. However they were unset when SLPC was
enabled and PCODE never updated the memory freq.

v2 (as Suggested by Ashutosh): if SLPC is in use, let's pick the right
   frequencies from the get_ia_constants instead of the fake init of
   rps' min and max.

v3: don't forget the max <= min return

v4: Move all the freq conversion to intel_rps.c. And the max <= min
    check to where it belongs.

v5: (Ashutosh) Fix old comment s/50 HZ/50 MHz and add a doc explaining
    the "raw format"

Fixes: 7ba79a671568 ("drm/i915/guc/slpc: Gate Host RPS when SLPC is enabled")
Cc: <stable@vger.kernel.org> # v5.15+
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Tested-by: Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220831214538.143950-1-rodrigo.vivi@intel.com
(cherry picked from commit 018a7bdbb090b9155a6509a0d1a684db4afaa5b1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_llc.c b/drivers/gpu/drm/i915/gt/intel_llc.c
index 14fe65812e42..1d19c073ba2e 100644
--- a/drivers/gpu/drm/i915/gt/intel_llc.c
+++ b/drivers/gpu/drm/i915/gt/intel_llc.c
@@ -12,6 +12,7 @@
 #include "intel_llc.h"
 #include "intel_mchbar_regs.h"
 #include "intel_pcode.h"
+#include "intel_rps.h"
 
 struct ia_constants {
 	unsigned int min_gpu_freq;
@@ -55,9 +56,6 @@ static bool get_ia_constants(struct intel_llc *llc,
 	if (!HAS_LLC(i915) || IS_DGFX(i915))
 		return false;
 
-	if (rps->max_freq <= rps->min_freq)
-		return false;
-
 	consts->max_ia_freq = cpu_max_MHz();
 
 	consts->min_ring_freq =
@@ -65,13 +63,8 @@ static bool get_ia_constants(struct intel_llc *llc,
 	/* convert DDR frequency from units of 266.6MHz to bandwidth */
 	consts->min_ring_freq = mult_frac(consts->min_ring_freq, 8, 3);
 
-	consts->min_gpu_freq = rps->min_freq;
-	consts->max_gpu_freq = rps->max_freq;
-	if (GRAPHICS_VER(i915) >= 9) {
-		/* Convert GT frequency to 50 HZ units */
-		consts->min_gpu_freq /= GEN9_FREQ_SCALER;
-		consts->max_gpu_freq /= GEN9_FREQ_SCALER;
-	}
+	consts->min_gpu_freq = intel_rps_get_min_raw_freq(rps);
+	consts->max_gpu_freq = intel_rps_get_max_raw_freq(rps);
 
 	return true;
 }
@@ -130,6 +123,12 @@ static void gen6_update_ring_freq(struct intel_llc *llc)
 	if (!get_ia_constants(llc, &consts))
 		return;
 
+	/*
+	 * Although this is unlikely on any platform during initialization,
+	 * let's ensure we don't get accidentally into infinite loop
+	 */
+	if (consts.max_gpu_freq <= consts.min_gpu_freq)
+		return;
 	/*
 	 * For each potential GPU frequency, load a ring frequency we'd like
 	 * to use for memory access.  We do this by specifying the IA frequency
diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index fb3f57ee450b..7bb967034679 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -2126,6 +2126,31 @@ u32 intel_rps_get_max_frequency(struct intel_rps *rps)
 		return intel_gpu_freq(rps, rps->max_freq_softlimit);
 }
 
+/**
+ * intel_rps_get_max_raw_freq - returns the max frequency in some raw format.
+ * @rps: the intel_rps structure
+ *
+ * Returns the max frequency in a raw format. In newer platforms raw is in
+ * units of 50 MHz.
+ */
+u32 intel_rps_get_max_raw_freq(struct intel_rps *rps)
+{
+	struct intel_guc_slpc *slpc = rps_to_slpc(rps);
+	u32 freq;
+
+	if (rps_uses_slpc(rps)) {
+		return DIV_ROUND_CLOSEST(slpc->rp0_freq,
+					 GT_FREQUENCY_MULTIPLIER);
+	} else {
+		freq = rps->max_freq;
+		if (GRAPHICS_VER(rps_to_i915(rps)) >= 9) {
+			/* Convert GT frequency to 50 MHz units */
+			freq /= GEN9_FREQ_SCALER;
+		}
+		return freq;
+	}
+}
+
 u32 intel_rps_get_rp0_frequency(struct intel_rps *rps)
 {
 	struct intel_guc_slpc *slpc = rps_to_slpc(rps);
@@ -2214,6 +2239,31 @@ u32 intel_rps_get_min_frequency(struct intel_rps *rps)
 		return intel_gpu_freq(rps, rps->min_freq_softlimit);
 }
 
+/**
+ * intel_rps_get_min_raw_freq - returns the min frequency in some raw format.
+ * @rps: the intel_rps structure
+ *
+ * Returns the min frequency in a raw format. In newer platforms raw is in
+ * units of 50 MHz.
+ */
+u32 intel_rps_get_min_raw_freq(struct intel_rps *rps)
+{
+	struct intel_guc_slpc *slpc = rps_to_slpc(rps);
+	u32 freq;
+
+	if (rps_uses_slpc(rps)) {
+		return DIV_ROUND_CLOSEST(slpc->min_freq,
+					 GT_FREQUENCY_MULTIPLIER);
+	} else {
+		freq = rps->min_freq;
+		if (GRAPHICS_VER(rps_to_i915(rps)) >= 9) {
+			/* Convert GT frequency to 50 MHz units */
+			freq /= GEN9_FREQ_SCALER;
+		}
+		return freq;
+	}
+}
+
 static int set_min_freq(struct intel_rps *rps, u32 val)
 {
 	int ret = 0;
diff --git a/drivers/gpu/drm/i915/gt/intel_rps.h b/drivers/gpu/drm/i915/gt/intel_rps.h
index 1e8d56491308..4509dfdc52e0 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.h
+++ b/drivers/gpu/drm/i915/gt/intel_rps.h
@@ -37,8 +37,10 @@ u32 intel_rps_get_cagf(struct intel_rps *rps, u32 rpstat1);
 u32 intel_rps_read_actual_frequency(struct intel_rps *rps);
 u32 intel_rps_get_requested_frequency(struct intel_rps *rps);
 u32 intel_rps_get_min_frequency(struct intel_rps *rps);
+u32 intel_rps_get_min_raw_freq(struct intel_rps *rps);
 int intel_rps_set_min_frequency(struct intel_rps *rps, u32 val);
 u32 intel_rps_get_max_frequency(struct intel_rps *rps);
+u32 intel_rps_get_max_raw_freq(struct intel_rps *rps);
 int intel_rps_set_max_frequency(struct intel_rps *rps, u32 val);
 u32 intel_rps_get_rp0_frequency(struct intel_rps *rps);
 u32 intel_rps_get_rp1_frequency(struct intel_rps *rps);

