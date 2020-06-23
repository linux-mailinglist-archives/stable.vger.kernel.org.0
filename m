Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38422050E3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732539AbgFWLgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:36:47 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:40373 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732525AbgFWLgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:36:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 44D8EA47;
        Tue, 23 Jun 2020 07:36:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:36:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=noNk+V
        zn1HZgVb/9khCBHge+Ug0p99u7Jy8yWYJgeJw=; b=QTsJWC2Jf8idnV2qaQSkTQ
        w36/g42VlyhtkxvFPoWJ/b6VxYVnLgtH8M1gK8B1q2woOiK/520ld4aZOeTfPl52
        fMB6GkJRBulOL6KpkpObykqLpCUSZEwPnaVHb1/o8YgyfzxR49DvZ1Ua6Kwfg2ac
        y59TMW05k+Qgo/fEivufXhmz3Hphup23ehJ7kgX+dmmSQsfDulNy0DzbAPLvJ5Yb
        53/+Sa7OYxbNboyp88J/UqEGAwab6ZKbrJvVFyV8egnUCT31TnjkeuzZ9vIJMWox
        jZh8bgBfMIO2TxNFDopmHO2xz+utkuJ0grk4eEGY+bLPMgFlDpEH0xh1NRfZSEvg
        ==
X-ME-Sender: <xms:O-nxXnLwVmp4TJlyb3TDQFLbGf0-m6mC5u5UM2b7Kpsi4BF0UbuZ_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:O-nxXrLoGDCyry13PPZCj6QDkq5e0HJGjoOyMjlrtWp90qGDw1d-3w>
    <xmx:O-nxXvtXI7Mu3IUuzbUeGZSV0Do33JMaUeu3Z2yGv-7wmHS4ZafYgA>
    <xmx:O-nxXgZkXxEHDU7TjCtO2OLC00i15RLPrS46I6Q84VYD-0_H3ZBX6g>
    <xmx:O-nxXnBZx88QXhRrlL-NlBO7VtqfWKlwc4yq0sV3FNkZPaw08g-CqfX28ZM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8327330674D2;
        Tue, 23 Jun 2020 07:36:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Move hsw GT workarounds from init_clock_gating" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:36:20 +0200
Message-ID: <1592912180113204@kroah.com>
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

From ef50fa9bd17d13d0611e39e13b37bbd3e1ea50bf Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 11 Jun 2020 10:30:15 +0100
Subject: [PATCH] drm/i915/gt: Move hsw GT workarounds from init_clock_gating
 to workarounds

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

v2: Leave HSW_SCRATCH to set an explicit value, not or in our disable
bit.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2011
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611093015.11370-1-chris@chris-wilson.co.uk
(cherry picked from commit f93ec5fb563779bda4501890b1854526de58e0f1)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 90a2b9e399b0..b5d0fbe3b211 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -178,6 +178,12 @@ wa_write_or(struct i915_wa_list *wal, i915_reg_t reg, u32 set)
 	wa_write_masked_or(wal, reg, set, set);
 }
 
+static void
+wa_write_clr(struct i915_wa_list *wal, i915_reg_t reg, u32 clr)
+{
+	wa_write_masked_or(wal, reg, clr, 0);
+}
+
 static void
 wa_masked_en(struct i915_wa_list *wal, i915_reg_t reg, u32 val)
 {
@@ -686,6 +692,46 @@ int intel_engine_emit_ctx_wa(struct i915_request *rq)
 	return 0;
 }
 
+static void
+hsw_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	/* L3 caching of data atomics doesn't work -- disable it. */
+	wa_write(wal, HSW_SCRATCH1, HSW_SCRATCH1_L3_DATA_ATOMICS_DISABLE);
+
+	wa_add(wal,
+	       HSW_ROW_CHICKEN3, 0,
+	       _MASKED_BIT_ENABLE(HSW_ROW_CHICKEN3_L3_GLOBAL_ATOMICS_DISABLE),
+		0 /* XXX does this reg exist? */);
+
+	/* WaVSRefCountFullforceMissDisable:hsw */
+	wa_write_clr(wal, GEN7_FF_THREAD_MODE, GEN7_FF_VS_REF_CNT_FFME);
+
+	wa_masked_dis(wal,
+		      CACHE_MODE_0_GEN7,
+		      /* WaDisable_RenderCache_OperationalFlush:hsw */
+		      RC_OP_FLUSH_ENABLE |
+		      /* enable HiZ Raw Stall Optimization */
+		      HIZ_RAW_STALL_OPT_DISABLE);
+
+	/* WaDisable4x2SubspanOptimization:hsw */
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
+	/* WaSampleCChickenBitEnable:hsw */
+	wa_masked_en(wal, HALF_SLICE_CHICKEN3, HSW_SAMPLE_C_PERFORMANCE);
+}
+
 static void
 gen9_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
@@ -963,6 +1009,8 @@ gt_init_workarounds(struct drm_i915_private *i915, struct i915_wa_list *wal)
 		bxt_gt_workarounds_init(i915, wal);
 	else if (IS_SKYLAKE(i915))
 		skl_gt_workarounds_init(i915, wal);
+	else if (IS_HASWELL(i915))
+		hsw_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 696491d71a1d..0b7a4c5f179d 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -7230,45 +7230,10 @@ static void bdw_init_clock_gating(struct drm_i915_private *dev_priv)
 
 static void hsw_init_clock_gating(struct drm_i915_private *dev_priv)
 {
-	/* L3 caching of data atomics doesn't work -- disable it. */
-	I915_WRITE(HSW_SCRATCH1, HSW_SCRATCH1_L3_DATA_ATOMICS_DISABLE);
-	I915_WRITE(HSW_ROW_CHICKEN3,
-		   _MASKED_BIT_ENABLE(HSW_ROW_CHICKEN3_L3_GLOBAL_ATOMICS_DISABLE));
-
 	/* This is required by WaCatErrorRejectionIssue:hsw */
 	I915_WRITE(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG,
-			I915_READ(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG) |
-			GEN7_SQ_CHICKEN_MBCUNIT_SQINTMOB);
-
-	/* WaVSRefCountFullforceMissDisable:hsw */
-	I915_WRITE(GEN7_FF_THREAD_MODE,
-		   I915_READ(GEN7_FF_THREAD_MODE) & ~GEN7_FF_VS_REF_CNT_FFME);
-
-	/* WaDisable_RenderCache_OperationalFlush:hsw */
-	I915_WRITE(CACHE_MODE_0_GEN7, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
-	/* enable HiZ Raw Stall Optimization */
-	I915_WRITE(CACHE_MODE_0_GEN7,
-		   _MASKED_BIT_DISABLE(HIZ_RAW_STALL_OPT_DISABLE));
-
-	/* WaDisable4x2SubspanOptimization:hsw */
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
-	/* WaSampleCChickenBitEnable:hsw */
-	I915_WRITE(HALF_SLICE_CHICKEN3,
-		   _MASKED_BIT_ENABLE(HSW_SAMPLE_C_PERFORMANCE));
+		   I915_READ(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG) |
+		   GEN7_SQ_CHICKEN_MBCUNIT_SQINTMOB);
 
 	/* WaSwitchSolVfFArbitrationPriority:hsw */
 	I915_WRITE(GAM_ECOCHK, I915_READ(GAM_ECOCHK) | HSW_ECOCHK_ARB_PRIO_SOL);

