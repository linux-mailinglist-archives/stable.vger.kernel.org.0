Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8FCBD00C5
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 20:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfJHSlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 14:41:42 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37657 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbfJHSlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 14:41:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2B0BE21785;
        Tue,  8 Oct 2019 14:41:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 14:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ob9voF
        1+ptJpU0S1MUPZOO30ThihZkhhy1RRJgOTxNM=; b=CuaSlGwLWAYrLxBVv509cy
        d139cpPoHasjfP1k3hrO2RcBKluQGvtsg2JaYWm2uIidNX38ea9XYvpMM6UeIh/+
        1CGqkarZpQNlPebLYkl6A1er+me8VKa7tekP5HjvJ1c7vC4jbgESVQ0EB3rbjaIX
        l4O3UPQhfLsYnjNqP2720HNTDVUBuY9z/YNjJiMyJ8v00hPuyI2vFzPNobS+7n0j
        qalU/KSoHiten3UyJTLutgX8mcW4gS4SxWERfimaikbWYWUtk1YACl9rMPRduaz6
        6pAzqbEt6biJF1GhzqCQ3FD9KX7UwqeoKdghT7BecDsRfUeyn6mR61B5CCiYuzeg
        ==
X-ME-Sender: <xms:ZNicXS38n66D6c9vQMQ3Ss08YNgzVwk4Ey-v6CleZy8wAfMbextSRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:ZNicXfyl0LhBddA_0ZhEaOs82L4hX9Xr6JQryxfvU2LrBuxI5MltHg>
    <xmx:ZNicXRjHBr-amGJG_mi72bNYM1n2BJurMS6m5mbAG48Q8scVZvYzWg>
    <xmx:ZNicXezwCmSIPWSPR6kFoOnsNUTv6RW4vOEMZZDepic1Uxdx1m_CfA>
    <xmx:ZdicXT8qYMixt76hQpUIwX2DNnk2tUPDdH4rT_PY8VeA-kWyQK8JaQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63E5BD60066;
        Tue,  8 Oct 2019 14:41:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Use maximum write flush for pwrite_gtt" failed to apply to 5.3-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        matthew.william.auld@gmail.com, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 20:41:38 +0200
Message-ID: <157056009813660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bdae33b8b82bb379a5b11040b0b37df25c7871c9 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 18 Jul 2019 15:54:05 +0100
Subject: [PATCH] drm/i915: Use maximum write flush for pwrite_gtt
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

As recently disovered by forcing big-core (!llc) machines to use the GTT
paths, we need our full GTT write flush before manipulating the GTT PTE
or else the writes may be directed to the wrong page.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190718145407.21352-2-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index fed0bc421a55..c6ba350e6e4f 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -610,7 +610,8 @@ i915_gem_gtt_pwrite_fast(struct drm_i915_gem_object *obj,
 		unsigned int page_length = PAGE_SIZE - page_offset;
 		page_length = remain < page_length ? remain : page_length;
 		if (node.allocated) {
-			wmb(); /* flush the write before we modify the GGTT */
+			/* flush the write before we modify the GGTT */
+			intel_gt_flush_ggtt_writes(ggtt->vm.gt);
 			ggtt->vm.insert_page(&ggtt->vm,
 					     i915_gem_object_get_dma_address(obj, offset >> PAGE_SHIFT),
 					     node.start, I915_CACHE_NONE, 0);
@@ -639,8 +640,8 @@ i915_gem_gtt_pwrite_fast(struct drm_i915_gem_object *obj,
 	i915_gem_object_unlock_fence(obj, fence);
 out_unpin:
 	mutex_lock(&i915->drm.struct_mutex);
+	intel_gt_flush_ggtt_writes(ggtt->vm.gt);
 	if (node.allocated) {
-		wmb();
 		ggtt->vm.clear_range(&ggtt->vm, node.start, node.size);
 		remove_mappable_node(&node);
 	} else {

