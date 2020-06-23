Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408D52050E2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732525AbgFWLgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:36:47 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:55391 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732432AbgFWLgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:36:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 0D8A6A38;
        Tue, 23 Jun 2020 07:36:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hkB6sA
        3CCynzTRoExHTgHrd/oayFvxxkiZ3ruiNyJyo=; b=S7fWhHCW33dHlsZJkSFXgS
        XcSPOMTbxJNayNJJl5N9np/l6zYE4HQU1FX5g3Zv6gLr0vVeVnVqokalor9hTrvt
        nbYg+PT48b+IfduYkkKTnKPYJhOPmbAltMFThnVg7+y4l5yQclolxpKfukeV/ipY
        pU9vRtQanIfABA9xV4ju/vl537/M0WdqEhdGRXfYO9yydOAtusBqBnOhoWqj5O/p
        hWqNJ+PXuVz4zmuVZ2JsikJ75ai/tmtQMzVH/66Lj+4kCp4PtxbIz9HvyfSvmAgI
        iGix/qi8LrJjvhroyx1eeJ4PnkXpuU1ahbAYo638PYm0YVBGqARbVSKVu10T/Aaw
        ==
X-ME-Sender: <xms:PenxXshWMqsxOLuIesq3W7ydKLPi8kFFSk4g3Io5eKkBNs7kfCT5aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PenxXlC_vNYb5nMiacMmNWelpy1eqfT536oj8VuPPXYIbXW9Q0C5jg>
    <xmx:PenxXkGtX7e283HE_eNYKRUTELY2DcajLZedzjwlsA1jGEzBZCd0mw>
    <xmx:PenxXtSWNGTSJrQISqtPBx05JtUvvDj0GTuzSqj-lT0wn67AE_u2Jw>
    <xmx:PenxXnbRoqF8v4en32Im6hVkghFQrUfcplg7knbhNlQkiSMjPPqPafdznuA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1045E30674BE;
        Tue, 23 Jun 2020 07:36:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Move ivb GT workarounds from init_clock_gating" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:36:21 +0200
Message-ID: <159291218114698@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7237b190add0794bd95979018a23eda698f2705d Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 11 Jun 2020 09:01:36 +0100
Subject: [PATCH] drm/i915/gt: Move ivb GT workarounds from init_clock_gating
 to workarounds

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-2-chris@chris-wilson.co.uk
(cherry picked from commit 19f1f627b33385a2f0855cbc7d33d86d7f4a1e78)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index b5d0fbe3b211..d9b72679ca82 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -692,6 +692,66 @@ int intel_engine_emit_ctx_wa(struct i915_request *rq)
 	return 0;
 }
 
+static void
+ivb_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	/* WaDisableEarlyCull:ivb */
+	wa_masked_en(wal, _3D_CHICKEN3, _3D_CHICKEN_SF_DISABLE_OBJEND_CULL);
+
+	/* WaDisablePSDDualDispatchEnable:ivb */
+	if (IS_IVB_GT1(i915))
+		wa_masked_en(wal,
+			     GEN7_HALF_SLICE_CHICKEN1,
+			     GEN7_PSD_SINGLE_PORT_DISPATCH_ENABLE);
+
+	/* WaDisable_RenderCache_OperationalFlush:ivb */
+	wa_masked_dis(wal, CACHE_MODE_0_GEN7, RC_OP_FLUSH_ENABLE);
+
+	/* Apply the WaDisableRHWOOptimizationForRenderHang:ivb workaround. */
+	wa_masked_dis(wal,
+		      GEN7_COMMON_SLICE_CHICKEN1,
+		      GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC);
+
+	/* WaApplyL3ControlAndL3ChickenMode:ivb */
+	wa_write(wal, GEN7_L3CNTLREG1, GEN7_WA_FOR_GEN7_L3_CONTROL);
+	wa_write(wal, GEN7_L3_CHICKEN_MODE_REGISTER, GEN7_WA_L3_CHICKEN_MODE);
+
+	/* WaForceL3Serialization:ivb */
+	wa_write_clr(wal, GEN7_L3SQCREG4, L3SQ_URB_READ_CAM_MATCH_DISABLE);
+
+	/*
+	 * WaVSThreadDispatchOverride:ivb,vlv
+	 *
+	 * This actually overrides the dispatch
+	 * mode for all thread types.
+	 */
+	wa_write_masked_or(wal, GEN7_FF_THREAD_MODE,
+			   GEN7_FF_SCHED_MASK,
+			   GEN7_FF_TS_SCHED_HW |
+			   GEN7_FF_VS_SCHED_HW |
+			   GEN7_FF_DS_SCHED_HW);
+
+	if (0) { /* causes HiZ corruption on ivb:gt1 */
+		/* enable HiZ Raw Stall Optimization */
+		wa_masked_dis(wal, CACHE_MODE_0_GEN7, HIZ_RAW_STALL_OPT_DISABLE);
+	}
+
+	/* WaDisable4x2SubspanOptimization:ivb */
+	wa_masked_en(wal, CACHE_MODE_1, PIXEL_SUBSPAN_COLLECT_OPT_DISABLE);
+
+	/*
+	 * BSpec recommends 8x4 when MSAA is used,
+	 * however in practice 16x4 seems fastest.
+	 *
+	 * Note that PS/WM thread counts depend on the WIZ hashing
+	 * disable bit, which we don't touch here, but it's good
+	 * to keep in mind (see 3DSTATE_PS and 3DSTATE_WM).
+	 */
+	wa_add(wal, GEN7_GT_MODE, 0,
+	       _MASKED_FIELD(GEN6_WIZ_HASHING_MASK, GEN6_WIZ_HASHING_16x4),
+	       GEN6_WIZ_HASHING_16x4);
+}
+
 static void
 hsw_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
@@ -1011,6 +1071,8 @@ gt_init_workarounds(struct drm_i915_private *i915, struct i915_wa_list *wal)
 		skl_gt_workarounds_init(i915, wal);
 	else if (IS_HASWELL(i915))
 		hsw_gt_workarounds_init(i915, wal);
+	else if (IS_IVYBRIDGE(i915))
+		ivb_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 7717581350bd..06cd1d28a176 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7896,7 +7896,7 @@ enum {
 
 /* GEN7 chicken */
 #define GEN7_COMMON_SLICE_CHICKEN1		_MMIO(0x7010)
-  #define GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC	((1 << 10) | (1 << 26))
+  #define GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC	(1 << 10)
   #define GEN9_RHWO_OPTIMIZATION_DISABLE	(1 << 14)
 
 #define COMMON_SLICE_CHICKEN2					_MMIO(0x7014)
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 0b7a4c5f179d..7236644af40b 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -7247,32 +7247,11 @@ static void ivb_init_clock_gating(struct drm_i915_private *dev_priv)
 
 	I915_WRITE(ILK_DSPCLK_GATE_D, ILK_VRHUNIT_CLOCK_GATE_DISABLE);
 
-	/* WaDisableEarlyCull:ivb */
-	I915_WRITE(_3D_CHICKEN3,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN_SF_DISABLE_OBJEND_CULL));
-
 	/* WaDisableBackToBackFlipFix:ivb */
 	I915_WRITE(IVB_CHICKEN3,
 		   CHICKEN3_DGMG_REQ_OUT_FIX_DISABLE |
 		   CHICKEN3_DGMG_DONE_FIX_DISABLE);
 
-	/* WaDisablePSDDualDispatchEnable:ivb */
-	if (IS_IVB_GT1(dev_priv))
-		I915_WRITE(GEN7_HALF_SLICE_CHICKEN1,
-			   _MASKED_BIT_ENABLE(GEN7_PSD_SINGLE_PORT_DISPATCH_ENABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:ivb */
-	I915_WRITE(CACHE_MODE_0_GEN7, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
-	/* Apply the WaDisableRHWOOptimizationForRenderHang:ivb workaround. */
-	I915_WRITE(GEN7_COMMON_SLICE_CHICKEN1,
-		   GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC);
-
-	/* WaApplyL3ControlAndL3ChickenMode:ivb */
-	I915_WRITE(GEN7_L3CNTLREG1,
-			GEN7_WA_FOR_GEN7_L3_CONTROL);
-	I915_WRITE(GEN7_L3_CHICKEN_MODE_REGISTER,
-		   GEN7_WA_L3_CHICKEN_MODE);
 	if (IS_IVB_GT1(dev_priv))
 		I915_WRITE(GEN7_ROW_CHICKEN2,
 			   _MASKED_BIT_ENABLE(DOP_CLOCK_GATING_DISABLE));
@@ -7284,10 +7263,6 @@ static void ivb_init_clock_gating(struct drm_i915_private *dev_priv)
 			   _MASKED_BIT_ENABLE(DOP_CLOCK_GATING_DISABLE));
 	}
 
-	/* WaForceL3Serialization:ivb */
-	I915_WRITE(GEN7_L3SQCREG4, I915_READ(GEN7_L3SQCREG4) &
-		   ~L3SQ_URB_READ_CAM_MATCH_DISABLE);
-
 	/*
 	 * According to the spec, bit 13 (RCZUNIT) must be set on IVB.
 	 * This implements the WaDisableRCZUnitClockGating:ivb workaround.
@@ -7302,29 +7277,6 @@ static void ivb_init_clock_gating(struct drm_i915_private *dev_priv)
 
 	g4x_disable_trickle_feed(dev_priv);
 
-	gen7_setup_fixed_func_scheduler(dev_priv);
-
-	if (0) { /* causes HiZ corruption on ivb:gt1 */
-		/* enable HiZ Raw Stall Optimization */
-		I915_WRITE(CACHE_MODE_0_GEN7,
-			   _MASKED_BIT_DISABLE(HIZ_RAW_STALL_OPT_DISABLE));
-	}
-
-	/* WaDisable4x2SubspanOptimization:ivb */
-	I915_WRITE(CACHE_MODE_1,
-		   _MASKED_BIT_ENABLE(PIXEL_SUBSPAN_COLLECT_OPT_DISABLE));
-
-	/*
-	 * BSpec recommends 8x4 when MSAA is used,
-	 * however in practice 16x4 seems fastest.
-	 *
-	 * Note that PS/WM thread counts depend on the WIZ hashing
-	 * disable bit, which we don't touch here, but it's good
-	 * to keep in mind (see 3DSTATE_PS and 3DSTATE_WM).
-	 */
-	I915_WRITE(GEN7_GT_MODE,
-		   _MASKED_FIELD(GEN6_WIZ_HASHING_MASK, GEN6_WIZ_HASHING_16x4));
-
 	snpcr = I915_READ(GEN6_MBCUNIT_SNPCR);
 	snpcr &= ~GEN6_MBC_SNPCR_MASK;
 	snpcr |= GEN6_MBC_SNPCR_MED;

