Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BE92F0EA6
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbhAKJAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 04:00:20 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:46647 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728091AbhAKJAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 04:00:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EC2DA2576;
        Mon, 11 Jan 2021 03:59:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:59:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hThMiO
        7QeJuby1lBtDrxHaZVWhfx9nGGWny8nlR0lsw=; b=CGsz6n9qdyNBwvM5fLWbFk
        Y6lVQPzdL0Oc91t2YdBe8C2d6MA0cbDjfAPMRwsdFrg6eSz8BLlQIGwsBJcotLqi
        qdZ/bj4IAbqr0HPpqKgJWIGiC/nJFQR31cclbqcLe2OK1LZ5Ip0zIREx/WprWsRD
        nRxOCiKLUqBhN1w3vLp59F0/tVJiRJGnm/eW2A6dFPh+8O6W9fI20v6Yl4BRRzVa
        yG7eB8sCboItBMWtGpwBDfY8Kr3q5RpNddrMzXYURk2fqXBxbBAluM8+XCILRVBU
        TQ+WzSuWkyHP569zsJEpYkmfkHbBiKi1vybaCo4XYXcjKkvwCtrlrxrZzqwftf/A
        ==
X-ME-Sender: <xms:YRP8X6z2dHLosHDs5ZV7lQLls0RlpKiH-4ilgTWrkCNocBbAxvlZsQ>
    <xme:YRP8X2Sr8aeEnfvaCJAlL_RB9K0kLWwj2BikFb_5eud9CM8y6wZufMCOigRDcKgzt
    K766vwCp5i7Zg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:YRP8X8UpclHoG3fbAU5Nbh-FoKs7CZC1EXugnHdvnAtZDsIX30hiOw>
    <xmx:YRP8Xwgzottpj31FzGnuFcXAWRPC-_Ows68f-Q1kwQrWk90VUvRMpg>
    <xmx:YRP8X8CujHV2EpnPxNRHqQtwskmEZaO0G0egovjsBUWSmISE1_th_A>
    <xmx:YRP8X16XGYG8d-EJBzMcxUBNtpQiQ16CgkUdwgy0BRYlrQQcrYnK-GWBxS8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4174324005D;
        Mon, 11 Jan 2021 03:59:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: clear the shadow batch" failed to apply to 4.9-stable tree
To:     matthew.auld@intel.com, chris@chris-wilson.co.uk,
        jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 10:00:24 +0100
Message-ID: <1610355624149236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

