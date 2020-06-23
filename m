Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F992050E0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgFWLgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:36:48 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:51117 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732532AbgFWLgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:36:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id CBBABA50;
        Tue, 23 Jun 2020 07:36:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RS5Kel
        ZV74vh9qYHSYEGKJELnui7W/U5lZIls2zK9BA=; b=Sh5Pf41iO2gm1pc5KSXEBF
        Myl6Ym0wjsIwbVVI2ugTl6E++AyUMAffMST7Bgg0tbV/K9FK751l1dHaFcMOjLC5
        wXPlCNPqIrTw43PxNa7A/24Hs4MlQ2VZjaqVnH4vyCkS2rQxur/US+Nvxj4jViT+
        nJndxLdJR9En0nSJWNh3PEOAtYKSPLUCBUyB8vYRtJ0Lz2p2FM4hMtwwKDIe68cS
        u9ptLY5JqSY44D8S3snLgCEwIjSxpoFmHUrZYxgZpGFhtlq0FclM0Y9VVv+Dfd4Q
        YdeOWhwVY8rGf4ggaMKmn8sLgND9/L7xfywVuvknlHDuSZU3/AuiRSV3vPJ8RYrg
        ==
X-ME-Sender: <xms:QunxXg0dKKtKGZXa31w0KbUtuwVnrMrlTBQ1QCPHUUaMcDl5v9HKUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeehnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QunxXrEoIEB5mODRVpdLSnt8iNqWq7ba1EEIKR6NdQEozdQolKW7ig>
    <xmx:QunxXo6xzCqwtDXcb-vDULljW9CYz_DJVvNwzYcTbLjBmG3pFIDJcw>
    <xmx:QunxXp2ZeDhrLDmMgkxa9ABoNxl-l5uUjwftokGQlOaXf4txVnAF-Q>
    <xmx:QunxXmMyfao45hVo1DLItZtCB9IVjKh8eiyp42HD9zHf5c46qOeu0YFwX3Y>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D94903280063;
        Tue, 23 Jun 2020 07:36:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Move snb GT workarounds from init_clock_gating" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:36:22 +0200
Message-ID: <159291218212162@kroah.com>
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

From fd2599bda5a989c3332f4956fd7760ec32bd51ee Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 11 Jun 2020 09:01:38 +0100
Subject: [PATCH] drm/i915/gt: Move snb GT workarounds from init_clock_gating
 to workarounds

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-4-chris@chris-wilson.co.uk
(cherry picked from commit c3b93a943f2c9ee4a106db100a2fc3b2f126bfc5)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 9923ff1a3982..c2d57f65b147 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -692,6 +692,45 @@ int intel_engine_emit_ctx_wa(struct i915_request *rq)
 	return 0;
 }
 
+static void
+snb_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	/* WaDisableHiZPlanesWhenMSAAEnabled:snb */
+	wa_masked_en(wal,
+		     _3D_CHICKEN,
+		     _3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB);
+
+	/* WaDisable_RenderCache_OperationalFlush:snb */
+	wa_masked_dis(wal, CACHE_MODE_0, RC_OP_FLUSH_ENABLE);
+
+	/*
+	 * BSpec recommends 8x4 when MSAA is used,
+	 * however in practice 16x4 seems fastest.
+	 *
+	 * Note that PS/WM thread counts depend on the WIZ hashing
+	 * disable bit, which we don't touch here, but it's good
+	 * to keep in mind (see 3DSTATE_PS and 3DSTATE_WM).
+	 */
+	wa_add(wal,
+	       GEN6_GT_MODE, 0,
+	       _MASKED_FIELD(GEN6_WIZ_HASHING_MASK, GEN6_WIZ_HASHING_16x4),
+	       GEN6_WIZ_HASHING_16x4);
+
+	wa_masked_dis(wal, CACHE_MODE_0, CM0_STC_EVICT_DISABLE_LRA_SNB);
+
+	wa_masked_en(wal,
+		     _3D_CHICKEN3,
+		     /* WaStripsFansDisableFastClipPerformanceFix:snb */
+		     _3D_CHICKEN3_SF_DISABLE_FASTCLIP_CULL |
+		     /*
+		      * Bspec says:
+		      * "This bit must be set if 3DSTATE_CLIP clip mode is set
+		      * to normal and 3DSTATE_SF number of SF output attributes
+		      * is more than 16."
+		      */
+		   _3D_CHICKEN3_SF_DISABLE_PIPELINED_ATTR_FETCH);
+}
+
 static void
 ivb_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
@@ -1132,6 +1171,8 @@ gt_init_workarounds(struct drm_i915_private *i915, struct i915_wa_list *wal)
 		vlv_gt_workarounds_init(i915, wal);
 	else if (IS_IVYBRIDGE(i915))
 		ivb_gt_workarounds_init(i915, wal);
+	else if (IS_GEN(i915, 6))
+		snb_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index cea7923c9cd6..5db0ebe5eee0 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6902,27 +6902,6 @@ static void gen6_init_clock_gating(struct drm_i915_private *dev_priv)
 		   I915_READ(ILK_DISPLAY_CHICKEN2) |
 		   ILK_ELPIN_409_SELECT);
 
-	/* WaDisableHiZPlanesWhenMSAAEnabled:snb */
-	I915_WRITE(_3D_CHICKEN,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB));
-
-	/* WaDisable_RenderCache_OperationalFlush:snb */
-	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
-	/*
-	 * BSpec recoomends 8x4 when MSAA is used,
-	 * however in practice 16x4 seems fastest.
-	 *
-	 * Note that PS/WM thread counts depend on the WIZ hashing
-	 * disable bit, which we don't touch here, but it's good
-	 * to keep in mind (see 3DSTATE_PS and 3DSTATE_WM).
-	 */
-	I915_WRITE(GEN6_GT_MODE,
-		   _MASKED_FIELD(GEN6_WIZ_HASHING_MASK, GEN6_WIZ_HASHING_16x4));
-
-	I915_WRITE(CACHE_MODE_0,
-		   _MASKED_BIT_DISABLE(CM0_STC_EVICT_DISABLE_LRA_SNB));
-
 	I915_WRITE(GEN6_UCGCTL1,
 		   I915_READ(GEN6_UCGCTL1) |
 		   GEN6_BLBUNIT_CLOCK_GATE_DISABLE |
@@ -6945,18 +6924,6 @@ static void gen6_init_clock_gating(struct drm_i915_private *dev_priv)
 		   GEN6_RCPBUNIT_CLOCK_GATE_DISABLE |
 		   GEN6_RCCUNIT_CLOCK_GATE_DISABLE);
 
-	/* WaStripsFansDisableFastClipPerformanceFix:snb */
-	I915_WRITE(_3D_CHICKEN3,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN3_SF_DISABLE_FASTCLIP_CULL));
-
-	/*
-	 * Bspec says:
-	 * "This bit must be set if 3DSTATE_CLIP clip mode is set to normal and
-	 * 3DSTATE_SF number of SF output attributes is more than 16."
-	 */
-	I915_WRITE(_3D_CHICKEN3,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN3_SF_DISABLE_PIPELINED_ATTR_FETCH));
-
 	/*
 	 * According to the spec the following bits should be
 	 * set in order to enable memory self-refresh and fbc:

