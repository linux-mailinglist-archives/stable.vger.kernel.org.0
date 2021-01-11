Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FF02F0EA5
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbhAKJAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 04:00:19 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:38433 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727623AbhAKJAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 04:00:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E75D5257F;
        Mon, 11 Jan 2021 03:59:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:59:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DUu/lk
        1yFTf6oQl4/F7joxrg8HoKL78pCTT7IiN1sd4=; b=qOqwJ5pDZGUaPFtlyHl5lk
        3w8ZAPjd998SBbtsKVmlx9v25+xvaiifuvIeOms7zg3eQF0a12b/4cJXhZ1UEmOR
        oGePc40wpqxghd0ofgnKBsu79gG8WT8CXBYQpy/vsicW2L5cIUpiyjA+mIwNnDE5
        rwPLD4UavbOBI5wV2y2mEJF+LzgUEMq/1Q05zPt/swL2xi415qtZ/xFM0AJTl5mb
        XetF/NrciIxxUjSZqtvqG8/w9ivkscfnZDR4d80NYoxpyOXtJUGbB+0J+JNFOQ31
        IRcUGt0QBLmrqQmA0TwxU5bxJsTfy2RTsO7KXMY1rPrDpeBmf2Plg8d6jlYwb9ng
        ==
X-ME-Sender: <xms:XxP8X7GI30CAIvuPSUY7bstBMdjmxrCQdmnqjP64q_I4b2AF3tZ0lQ>
    <xme:XxP8X4VVHj2eHgDxX7Dj6DFwoobnUjVv9H_UuTMRJGogokhJsKQdQfAHQIqH9x-Cp
    Kfrv1Bc5qQlVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:XxP8X9I_vGrqWvqzKIbLBky4yh12HS1BUBgzT86BM3pp4kTQ5_8Rdw>
    <xmx:XxP8X5FE-cl392XZ2zqhuDlLnLihcvTS9X8pMop6II_9v32qFU8u9w>
    <xmx:XxP8XxU8rCLMWlmsVfBE80gfJlu-AWaRGhFaw12hPw5mlSZ4LAsvxw>
    <xmx:YBP8XwfxA-5xbhHEZLvrnKqqowaCzVLH1NL1_sBWcZLb8RLzJcLgIQyY6lA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DB131080066;
        Mon, 11 Jan 2021 03:59:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: clear the shadow batch" failed to apply to 4.4-stable tree
To:     matthew.auld@intel.com, chris@chris-wilson.co.uk,
        jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 10:00:24 +0100
Message-ID: <161035562449124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

