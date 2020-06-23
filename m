Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FC72050E4
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbgFWLhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:37:05 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52267 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732493AbgFWLgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:36:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 89243A4B;
        Tue, 23 Jun 2020 07:36:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:36:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=l0cW7x
        sjdgQwKs6qQEyAwTFDnYFHtSSlI9wfyXGUZnQ=; b=fTAAMooI6c4XGqMPBADhf2
        azzh8XN2f/sbuFazPTnNol8lcAl3Hs1OHmdZWBpzgUvwWPGXObv4Ivexz5/k8t8G
        bdr5/yjCC49QbquDVuK13kMCkvqLiuZve3cJiadfjs+rCUIj3Tiibte077IdFsNO
        TW+k5CeYhvVX9BwzrBb5AhwDo7pZZ8I61oupG1AJmbNJFfel0V30hCumgfly8nMw
        CUdF7V8twH6rEHPJav485rOxFW1uAE2Orwixp7SE82+db2pZY9VzYnFR40vjhmNB
        ta1qmhIDU/G8WfitXj9KXmwTFLvBJdsuWdYIvmT5kXTiiZ4i4YJufuuABp9uu64g
        ==
X-ME-Sender: <xms:P-nxXqupY-7aZR2r78uCIclxeqmTjkLZsUTFsklLcUmUAuYx5nHttQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:P-nxXvf7eAZ92mfaEO9QX_-byc-TiaxrKh1YMlJGreX_jTIm8UVKbQ>
    <xmx:P-nxXlyK9-RJeWCAoDSG0n32sO5DwGz0eGwMFCbRwci4-MUgXrtSAA>
    <xmx:P-nxXlP9Z32Onv7CmVrxT4gS-k_acmUpS_22fD720lJ_so1J4xZn-Q>
    <xmx:P-nxXvEWcY5Z3TXsBbBvoMDZ8FYs6gqFozs3vIz_a9nYbfCBnid0aQPSLrs>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BBFD730674BE;
        Tue, 23 Jun 2020 07:36:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Move ilk GT workarounds from init_clock_gating" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:36:21 +0200
Message-ID: <159291218123158@kroah.com>
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

From eacf21040aa97fd1b3c6bb201bfd43820e1c49be Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 11 Jun 2020 09:01:39 +0100
Subject: [PATCH] drm/i915/gt: Move ilk GT workarounds from init_clock_gating
 to workarounds

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-5-chris@chris-wilson.co.uk
(cherry picked from commit 806a45c0838d253e306a6384057e851b65d11099)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index c2d57f65b147..5ccfe36c2978 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -692,6 +692,18 @@ int intel_engine_emit_ctx_wa(struct i915_request *rq)
 	return 0;
 }
 
+static void
+ilk_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	wa_masked_en(wal, _3D_CHICKEN2, _3D_CHICKEN2_WM_READ_PIPELINED);
+
+	/* WaDisableRenderCachePipelinedFlush:ilk */
+	wa_masked_en(wal, CACHE_MODE_0, CM0_PIPELINED_RENDER_FLUSH_DISABLE);
+
+	/* WaDisable_RenderCache_OperationalFlush:ilk */
+	wa_masked_dis(wal, CACHE_MODE_0, RC_OP_FLUSH_ENABLE);
+}
+
 static void
 snb_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
@@ -1173,6 +1185,8 @@ gt_init_workarounds(struct drm_i915_private *i915, struct i915_wa_list *wal)
 		ivb_gt_workarounds_init(i915, wal);
 	else if (IS_GEN(i915, 6))
 		snb_gt_workarounds_init(i915, wal);
+	else if (IS_GEN(i915, 5))
+		ilk_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 5db0ebe5eee0..7ebe4fa3a162 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6830,16 +6830,6 @@ static void ilk_init_clock_gating(struct drm_i915_private *dev_priv)
 	I915_WRITE(ILK_DISPLAY_CHICKEN2,
 		   I915_READ(ILK_DISPLAY_CHICKEN2) |
 		   ILK_ELPIN_409_SELECT);
-	I915_WRITE(_3D_CHICKEN2,
-		   _3D_CHICKEN2_WM_READ_PIPELINED << 16 |
-		   _3D_CHICKEN2_WM_READ_PIPELINED);
-
-	/* WaDisableRenderCachePipelinedFlush:ilk */
-	I915_WRITE(CACHE_MODE_0,
-		   _MASKED_BIT_ENABLE(CM0_PIPELINED_RENDER_FLUSH_DISABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:ilk */
-	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
 
 	g4x_disable_trickle_feed(dev_priv);
 

