Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635392F0EB0
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbhAKJA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 04:00:27 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:39643 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728222AbhAKJA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 04:00:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C234125EA;
        Mon, 11 Jan 2021 03:59:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:59:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VXgvNb
        YYVM4rh72wcYATxl9swoY9AW9By6hXxdnoEXw=; b=IlVA/oW98GbsIKZb2BGRE7
        iDZGrTqkOLjrXFtAt4alxQLk72cEFo1nDeKgfFiuTV1u6TZPlSBGnVMvfdJpPQZx
        McZjFIwk6yA1U3d+GoNH+oALGx4l1W/K4FtJqCLqfx20RUWfkaLm/K+JzA28mXs3
        dHpX6prAF5kQ65tAhXhZx0/S5z9r23GxTDcB0+PuYE6ADLU0Ki49c/HF7G+6PXae
        AKu/++AqF527pryc04eYnWB5NBzGqw92HrLrUa8/lrMPlktrGBZNxJT+LDiUm5Og
        Keswaag+2g6rZSt9xOlh3rJ5a+XcjdXneNPmZbB0XWLa3D3E7WKs0bwx5Ib5IqRQ
        ==
X-ME-Sender: <xms:aBP8X67Hw16O5UZb0cZvgj_JjeFUUE4fgt00lCuEEZuI-lqaVXsOLw>
    <xme:aBP8Xz51IH_RpJCRu72QNVZco5GidhTSj3d2dRKD3yenT1wcSF089OVP8BQ1OP7Ni
    C8ogp4rKDXrfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeegnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:aBP8X5f3rxqBRdG9SkDH1p6U2ur4kOeELdIHuk4NScQ1M-Qk4w5i9Q>
    <xmx:aBP8X3KBdetC6ONvDkFwEKcU2HBniPAFkcGYKZ4gKR8otiAvrPJV1w>
    <xmx:aBP8X-JNsEC1fwzB-l2edA4s1gU75YPmYbR75RMK0Byx-2-ERCGImQ>
    <xmx:aBP8XwiJXPRBi6WnfY74_BpY8a-5FPx_z6EZpq0F1xpqnxX4kO7fkQc4jKo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 180B41080059;
        Mon, 11 Jan 2021 03:59:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: clear the shadow batch" failed to apply to 5.4-stable tree
To:     matthew.auld@intel.com, chris@chris-wilson.co.uk,
        jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 10:00:26 +0100
Message-ID: <161035562679104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 75353bcd2184010f08a3ed2f0da019bd9d604e1e Mon Sep 17 00:00:00 2001
From: Matthew Auld <matthew.auld@intel.com>
Date: Thu, 24 Dec 2020 15:13:57 +0000
Subject: [PATCH] drm/i915: clear the shadow batch

The shadow batch is an internal object, which doesn't have any page
clearing, and since the batch_len can be smaller than the object, we
should take care to clear it.

Testcase: igt/gen9_exec_parse/shadow-peek
Fixes: 4f7af1948abc ("drm/i915: Support ro ppgtt mapped cmdparser shadow buffers")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20201224151358.401345-1-matthew.auld@intel.com
Cc: stable@vger.kernel.org
(cherry picked from commit eeb52ee6c4a429ec301faf1dc48988744960786e)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 93265951fdbb..b0899b665e85 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1166,7 +1166,7 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		}
 	}
 	if (IS_ERR(src)) {
-		unsigned long x, n;
+		unsigned long x, n, remain;
 		void *ptr;
 
 		/*
@@ -1177,14 +1177,15 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		 * We don't care about copying too much here as we only
 		 * validate up to the end of the batch.
 		 */
+		remain = length;
 		if (!(dst_obj->cache_coherent & I915_BO_CACHE_COHERENT_FOR_READ))
-			length = round_up(length,
+			remain = round_up(remain,
 					  boot_cpu_data.x86_clflush_size);
 
 		ptr = dst;
 		x = offset_in_page(offset);
-		for (n = offset >> PAGE_SHIFT; length; n++) {
-			int len = min(length, PAGE_SIZE - x);
+		for (n = offset >> PAGE_SHIFT; remain; n++) {
+			int len = min(remain, PAGE_SIZE - x);
 
 			src = kmap_atomic(i915_gem_object_get_page(src_obj, n));
 			if (needs_clflush)
@@ -1193,13 +1194,15 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 			kunmap_atomic(src);
 
 			ptr += len;
-			length -= len;
+			remain -= len;
 			x = 0;
 		}
 	}
 
 	i915_gem_object_unpin_pages(src_obj);
 
+	memset32(dst + length, 0, (dst_obj->base.size - length) / sizeof(u32));
+
 	/* dst_obj is returned with vmap pinned */
 	return dst;
 }
@@ -1392,11 +1395,6 @@ static unsigned long *alloc_whitelist(u32 batch_length)
 
 #define LENGTH_BIAS 2
 
-static bool shadow_needs_clflush(struct drm_i915_gem_object *obj)
-{
-	return !(obj->cache_coherent & I915_BO_CACHE_COHERENT_FOR_WRITE);
-}
-
 /**
  * intel_engine_cmd_parser() - parse a batch buffer for privilege violations
  * @engine: the engine on which the batch is to execute
@@ -1538,16 +1536,9 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 				ret = 0; /* allow execution */
 			}
 		}
-
-		if (shadow_needs_clflush(shadow->obj))
-			drm_clflush_virt_range(batch_end, 8);
 	}
 
-	if (shadow_needs_clflush(shadow->obj)) {
-		void *ptr = page_mask_bits(shadow->obj->mm.mapping);
-
-		drm_clflush_virt_range(ptr, (void *)(cmd + 1) - ptr);
-	}
+	i915_gem_object_flush_map(shadow->obj);
 
 	if (!IS_ERR_OR_NULL(jump_whitelist))
 		kfree(jump_whitelist);

