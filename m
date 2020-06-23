Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D112050DC
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732533AbgFWLgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:36:42 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:36553 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732524AbgFWLga (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:36:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 0C413A33;
        Tue, 23 Jun 2020 07:36:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/ZAUjy
        Eii4fNg/fX7Xp+gH1gNrjnRo/AKnJEKcVNf0k=; b=SXWNwY/DWOTCnvaClKONVk
        q6n2k/phDK47hNWy1lm2VD2P7Tl6j0k9N/wQnrh7QsVZ7rb7uAcvqrtGN8c9iOe2
        HCoSn9rblLL1ISpi1+tjEWfuK8C27LJYog8/N/0J/3HwAvU4wWfS8t9jjbUFji4f
        hW1xB7XhJg6GWXpFICHIOo4hS6iYQs+2xg4YSz3tvOCdD5K7fB8xioMMhrwtcSeI
        rnR+SKhtL45oxgRdYmowZ2RzuuTfDlZ1p+JJTPF2XKPyDWRzG7hMNVLyPNykXW22
        tVWEdsaHNFfzo7v7W+yxQOuZxDlWjZ3l3Kv5MXegMej+RUsDh3QQepy+sL7LJtnw
        ==
X-ME-Sender: <xms:OunxXq6Etg56IyguWTH8GsTOASBj-6-j07gawHcdlhTxWY4fIDamgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OunxXj7uSLtyB4jfriKgZ1ReD10PT7KtJnlU9Lp0EvHgF248Q1-0Pw>
    <xmx:OunxXpd8oaB4Q7-FvOlclvp8O1O2cLA-_vv0kS_FiJ7fhFz4k7mjFQ>
    <xmx:OunxXnIiyYyDz4uNhzVbmaZkAynXFbnVSgqyhahFLYH-Rrq6VaX_IQ>
    <xmx:OunxXoz1UvSj3Yu0bQzesi88wAPgOB0Low0QrJuywc4J1PgwL8dNa3oC-VE>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C26FF30674C9;
        Tue, 23 Jun 2020 07:36:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Move gen4 GT workarounds from init_clock_gating" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:36:19 +0200
Message-ID: <1592912179152240@kroah.com>
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

From 27582a9c917940bc71c0df0b8e022cbde8d735d2 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 11 Jun 2020 09:01:40 +0100
Subject: [PATCH] drm/i915/gt: Move gen4 GT workarounds from init_clock_gating
 to workarounds

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-6-chris@chris-wilson.co.uk
(cherry picked from commit 2bcefd0d263ab4a72f0d61921ae6b0dc81606551)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 5ccfe36c2978..85d2bef51524 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -693,15 +693,28 @@ int intel_engine_emit_ctx_wa(struct i915_request *rq)
 }
 
 static void
-ilk_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+gen4_gt_workarounds_init(struct drm_i915_private *i915,
+			 struct i915_wa_list *wal)
 {
-	wa_masked_en(wal, _3D_CHICKEN2, _3D_CHICKEN2_WM_READ_PIPELINED);
+	/* WaDisable_RenderCache_OperationalFlush:gen4,ilk */
+	wa_masked_dis(wal, CACHE_MODE_0, RC_OP_FLUSH_ENABLE);
+}
+
+static void
+g4x_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	gen4_gt_workarounds_init(i915, wal);
 
-	/* WaDisableRenderCachePipelinedFlush:ilk */
+	/* WaDisableRenderCachePipelinedFlush:g4x,ilk */
 	wa_masked_en(wal, CACHE_MODE_0, CM0_PIPELINED_RENDER_FLUSH_DISABLE);
+}
 
-	/* WaDisable_RenderCache_OperationalFlush:ilk */
-	wa_masked_dis(wal, CACHE_MODE_0, RC_OP_FLUSH_ENABLE);
+static void
+ilk_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	g4x_gt_workarounds_init(i915, wal);
+
+	wa_masked_en(wal, _3D_CHICKEN2, _3D_CHICKEN2_WM_READ_PIPELINED);
 }
 
 static void
@@ -1187,6 +1200,10 @@ gt_init_workarounds(struct drm_i915_private *i915, struct i915_wa_list *wal)
 		snb_gt_workarounds_init(i915, wal);
 	else if (IS_GEN(i915, 5))
 		ilk_gt_workarounds_init(i915, wal);
+	else if (IS_G4X(i915))
+		g4x_gt_workarounds_init(i915, wal);
+	else if (IS_GEN(i915, 4))
+		gen4_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 7ebe4fa3a162..07f663cd2d1c 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -7308,13 +7308,6 @@ static void g4x_init_clock_gating(struct drm_i915_private *dev_priv)
 		dspclk_gate |= DSSUNIT_CLOCK_GATE_DISABLE;
 	I915_WRITE(DSPCLK_GATE_D, dspclk_gate);
 
-	/* WaDisableRenderCachePipelinedFlush */
-	I915_WRITE(CACHE_MODE_0,
-		   _MASKED_BIT_ENABLE(CM0_PIPELINED_RENDER_FLUSH_DISABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:g4x */
-	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
 	g4x_disable_trickle_feed(dev_priv);
 }
 
@@ -7330,11 +7323,6 @@ static void i965gm_init_clock_gating(struct drm_i915_private *dev_priv)
 	intel_uncore_write(uncore,
 			   MI_ARB_STATE,
 			   _MASKED_BIT_ENABLE(MI_ARB_DISPLAY_TRICKLE_FEED_DISABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:gen4 */
-	intel_uncore_write(uncore,
-			   CACHE_MODE_0,
-			   _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
 }
 
 static void i965g_init_clock_gating(struct drm_i915_private *dev_priv)
@@ -7347,9 +7335,6 @@ static void i965g_init_clock_gating(struct drm_i915_private *dev_priv)
 	I915_WRITE(RENCLK_GATE_D2, 0);
 	I915_WRITE(MI_ARB_STATE,
 		   _MASKED_BIT_ENABLE(MI_ARB_DISPLAY_TRICKLE_FEED_DISABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:gen4 */
-	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
 }
 
 static void gen3_init_clock_gating(struct drm_i915_private *dev_priv)

