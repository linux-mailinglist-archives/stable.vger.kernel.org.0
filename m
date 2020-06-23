Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCC22050E5
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbgFWLhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:37:05 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:40131 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732530AbgFWLgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:36:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 14383A48;
        Tue, 23 Jun 2020 07:36:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JhlVOm
        wDBgEOauGMdM/pfTFm6HEDeCV47Bn26wiUxec=; b=oGY36kCY0Y9xrfxnG6R88D
        A8iVjkGBV4z3hzw6EAHenIuNxWPbBovadYEY2tnr4sEsfwpwabxZuwH9G+khME4b
        9HahQnJuBpe7RUHvRKzUbQB+SbpmXZhKuCufTRyluiCBhwLsOKGePx+/D3aqepzC
        Yw+1eW2wL/6HgCUv762MBddcweDRWtzOO0u5y/0unNHRKBde/B8DnIe8O2tAUJeu
        9RBgiVRsaI2+7SvPvvTSqbTgznI1AMvO6+XxhlM1ycWKY1gWKzwsgLUVsDsExvqi
        onjgaZqtWAY9cGqW6+YwkBG3cGNYUkqxSxCUTsQJjoJ7MQvBSb4jM2zqIGWGIsDQ
        ==
X-ME-Sender: <xms:QOnxXmnEXyIcnBy5lpO08A_wa2vozVYztqn-1PXAGCVvDONnt35uHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QOnxXt0S_xMwMNzSltN_JH-6nn9CivdZH_2zwA6r6u8BnBStROza_w>
    <xmx:QOnxXkruqa97NAplIGYtXcNvPaK1Qn826s6NqLQ9zRFiXcl6J0JcNw>
    <xmx:QOnxXqldjJTVN-GZ1VNc7zNfl6S8_PgKLYQIDgHrDzaVrhy8eU6VLg>
    <xmx:QOnxXp_K5r5ukBTmugnTSvl0tKZAnQ0rL6lvrZAY24BShjV2dkoo7dsDnCc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 54E723280063;
        Tue, 23 Jun 2020 07:36:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Move vlv GT workarounds from init_clock_gating" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:36:22 +0200
Message-ID: <159291218215197@kroah.com>
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

From 695a2b11649e99bbf15d278042247042c42b8728 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 11 Jun 2020 09:01:37 +0100
Subject: [PATCH] drm/i915/gt: Move vlv GT workarounds from init_clock_gating
 to workarounds

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-3-chris@chris-wilson.co.uk
(cherry picked from commit 7331c356b6d2d8a01422cacab27478a1dba9fa2a)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index d9b72679ca82..9923ff1a3982 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -752,6 +752,63 @@ ivb_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 	       GEN6_WIZ_HASHING_16x4);
 }
 
+static void
+vlv_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	/* WaDisableEarlyCull:vlv */
+	wa_masked_en(wal, _3D_CHICKEN3, _3D_CHICKEN_SF_DISABLE_OBJEND_CULL);
+
+	/* WaPsdDispatchEnable:vlv */
+	/* WaDisablePSDDualDispatchEnable:vlv */
+	wa_masked_en(wal,
+		     GEN7_HALF_SLICE_CHICKEN1,
+		     GEN7_MAX_PS_THREAD_DEP |
+		     GEN7_PSD_SINGLE_PORT_DISPATCH_ENABLE);
+
+	/* WaDisable_RenderCache_OperationalFlush:vlv */
+	wa_masked_dis(wal, CACHE_MODE_0_GEN7, RC_OP_FLUSH_ENABLE);
+
+	/* WaForceL3Serialization:vlv */
+	wa_write_clr(wal, GEN7_L3SQCREG4, L3SQ_URB_READ_CAM_MATCH_DISABLE);
+
+	/*
+	 * WaVSThreadDispatchOverride:ivb,vlv
+	 *
+	 * This actually overrides the dispatch
+	 * mode for all thread types.
+	 */
+	wa_write_masked_or(wal,
+			   GEN7_FF_THREAD_MODE,
+			   GEN7_FF_SCHED_MASK,
+			   GEN7_FF_TS_SCHED_HW |
+			   GEN7_FF_VS_SCHED_HW |
+			   GEN7_FF_DS_SCHED_HW);
+
+	/*
+	 * BSpec says this must be set, even though
+	 * WaDisable4x2SubspanOptimization isn't listed for VLV.
+	 */
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
+
+	/*
+	 * WaIncreaseL3CreditsForVLVB0:vlv
+	 * This is the hardware default actually.
+	 */
+	wa_write(wal, GEN7_L3SQCREG1, VLV_B0_WA_L3SQCREG1_VALUE);
+}
+
 static void
 hsw_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
@@ -1071,6 +1128,8 @@ gt_init_workarounds(struct drm_i915_private *i915, struct i915_wa_list *wal)
 		skl_gt_workarounds_init(i915, wal);
 	else if (IS_HASWELL(i915))
 		hsw_gt_workarounds_init(i915, wal);
+	else if (IS_VALLEYVIEW(i915))
+		vlv_gt_workarounds_init(i915, wal);
 	else if (IS_IVYBRIDGE(i915))
 		ivb_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 7236644af40b..cea7923c9cd6 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6986,24 +6986,6 @@ static void gen6_init_clock_gating(struct drm_i915_private *dev_priv)
 	gen6_check_mch_setup(dev_priv);
 }
 
-static void gen7_setup_fixed_func_scheduler(struct drm_i915_private *dev_priv)
-{
-	u32 reg = I915_READ(GEN7_FF_THREAD_MODE);
-
-	/*
-	 * WaVSThreadDispatchOverride:ivb,vlv
-	 *
-	 * This actually overrides the dispatch
-	 * mode for all thread types.
-	 */
-	reg &= ~GEN7_FF_SCHED_MASK;
-	reg |= GEN7_FF_TS_SCHED_HW;
-	reg |= GEN7_FF_VS_SCHED_HW;
-	reg |= GEN7_FF_DS_SCHED_HW;
-
-	I915_WRITE(GEN7_FF_THREAD_MODE, reg);
-}
-
 static void lpt_init_clock_gating(struct drm_i915_private *dev_priv)
 {
 	/*
@@ -7290,28 +7272,11 @@ static void ivb_init_clock_gating(struct drm_i915_private *dev_priv)
 
 static void vlv_init_clock_gating(struct drm_i915_private *dev_priv)
 {
-	/* WaDisableEarlyCull:vlv */
-	I915_WRITE(_3D_CHICKEN3,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN_SF_DISABLE_OBJEND_CULL));
-
 	/* WaDisableBackToBackFlipFix:vlv */
 	I915_WRITE(IVB_CHICKEN3,
 		   CHICKEN3_DGMG_REQ_OUT_FIX_DISABLE |
 		   CHICKEN3_DGMG_DONE_FIX_DISABLE);
 
-	/* WaPsdDispatchEnable:vlv */
-	/* WaDisablePSDDualDispatchEnable:vlv */
-	I915_WRITE(GEN7_HALF_SLICE_CHICKEN1,
-		   _MASKED_BIT_ENABLE(GEN7_MAX_PS_THREAD_DEP |
-				      GEN7_PSD_SINGLE_PORT_DISPATCH_ENABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:vlv */
-	I915_WRITE(CACHE_MODE_0_GEN7, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
-	/* WaForceL3Serialization:vlv */
-	I915_WRITE(GEN7_L3SQCREG4, I915_READ(GEN7_L3SQCREG4) &
-		   ~L3SQ_URB_READ_CAM_MATCH_DISABLE);
-
 	/* WaDisableDopClockGating:vlv */
 	I915_WRITE(GEN7_ROW_CHICKEN2,
 		   _MASKED_BIT_ENABLE(DOP_CLOCK_GATING_DISABLE));
@@ -7321,8 +7286,6 @@ static void vlv_init_clock_gating(struct drm_i915_private *dev_priv)
 		   I915_READ(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG) |
 		   GEN7_SQ_CHICKEN_MBCUNIT_SQINTMOB);
 
-	gen7_setup_fixed_func_scheduler(dev_priv);
-
 	/*
 	 * According to the spec, bit 13 (RCZUNIT) must be set on IVB.
 	 * This implements the WaDisableRCZUnitClockGating:vlv workaround.
@@ -7336,30 +7299,6 @@ static void vlv_init_clock_gating(struct drm_i915_private *dev_priv)
 	I915_WRITE(GEN7_UCGCTL4,
 		   I915_READ(GEN7_UCGCTL4) | GEN7_L3BANK2X_CLOCK_GATE_DISABLE);
 
-	/*
-	 * BSpec says this must be set, even though
-	 * WaDisable4x2SubspanOptimization isn't listed for VLV.
-	 */
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
-	/*
-	 * WaIncreaseL3CreditsForVLVB0:vlv
-	 * This is the hardware default actually.
-	 */
-	I915_WRITE(GEN7_L3SQCREG1, VLV_B0_WA_L3SQCREG1_VALUE);
-
 	/*
 	 * WaDisableVLVClockGating_VBIIssue:vlv
 	 * Disable clock gating on th GCFG unit to prevent a delay

