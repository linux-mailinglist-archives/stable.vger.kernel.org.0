Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29680D00C8
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 20:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfJHSoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 14:44:16 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41411 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbfJHSoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 14:44:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 61E7121785;
        Tue,  8 Oct 2019 14:44:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 14:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GVxgzG
        YUMCspn8M6BCU7j0tfw4K9wS4Tbf2ZV0ZagaI=; b=UaUHt6TVJ3eMiiO+4ARmWw
        cL8GkZMaaTykfFY+E9lwZyJUk0UVSOztHRdc3fXbldtAGC3cBNqcRZUqzDI4wCd+
        HEEgLA9KuZWpAXpMi00sNbf/T2V4xGg6QhkJzJlUyT5ZVazzeDWWd4XbRY3dX1rt
        U3KE8y9EqG1iZ9x5Hlxctx6OyD5Gw31d14+uXb3d1gBqC+fgX3iJjPfeJL6dfoCo
        W9FojqVUfd6ERKMESs1zp6Je0b6vXoyO2Z2SXL2Eq63tKaLY4OtxNz9U1HmYhaEF
        Jf+OKPNxLea14AyErLrNxEUk9tVy4JJ3t44CXkQiaivdrYzCZwDRr4Cjke80RLvQ
        ==
X-ME-Sender: <xms:_ticXXCCFWpIgpg0Vr7hnaE34P7IxcxRuKDDdBlcsDN51c9WgcVV3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgddufeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:_ticXYDRVIjgzBddzJlMlUbYEGd9lCjo93oO88Mm0wYBvZVnJoQtYQ>
    <xmx:_ticXfjQe6iv-xXDraoKpqReB81RcSPPXhk_mFnbf1YpKXx72aqBog>
    <xmx:_ticXceQg8ptbwNRuTbuPJYCqCAaUwWj6p7FTrn4vrmmXXJ57Xo8Mw>
    <xmx:_9icXTDYjwQl_EpBFvMoy0c4kgT-EDZfxjlpnrNMaMQvTT4M5utN9g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F0F5D60066;
        Tue,  8 Oct 2019 14:44:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Flush extra hard after writing relocations through" failed to apply to 5.3-stable tree
To:     chris@chris-wilson.co.uk, prathap.kumar.valsan@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 20:44:12 +0200
Message-ID: <157056025210325@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 576f05865581f82ac988ffec70e4e2ebd31165db Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 30 Jul 2019 12:21:51 +0100
Subject: [PATCH] drm/i915: Flush extra hard after writing relocations through
 the GTT

Recently discovered in commit bdae33b8b82b ("drm/i915: Use maximum write
flush for pwrite_gtt") was that we needed to our full write barrier
before changing the GGTT PTE to ensure that our indirect writes through
the GTT landed before the PTE changed (and the writes end up in a
different page). That also applies to our GGTT relocation path.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Reviewed-by: Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190730112151.5633-4-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index cbd7c6e3a1f8..4db4463089ce 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -1014,11 +1014,12 @@ static void reloc_cache_reset(struct reloc_cache *cache)
 		kunmap_atomic(vaddr);
 		i915_gem_object_finish_access((struct drm_i915_gem_object *)cache->node.mm);
 	} else {
-		wmb();
+		struct i915_ggtt *ggtt = cache_to_ggtt(cache);
+
+		intel_gt_flush_ggtt_writes(ggtt->vm.gt);
 		io_mapping_unmap_atomic((void __iomem *)vaddr);
-		if (cache->node.allocated) {
-			struct i915_ggtt *ggtt = cache_to_ggtt(cache);
 
+		if (cache->node.allocated) {
 			ggtt->vm.clear_range(&ggtt->vm,
 					     cache->node.start,
 					     cache->node.size);
@@ -1073,6 +1074,7 @@ static void *reloc_iomap(struct drm_i915_gem_object *obj,
 	void *vaddr;
 
 	if (cache->vaddr) {
+		intel_gt_flush_ggtt_writes(ggtt->vm.gt);
 		io_mapping_unmap_atomic((void __force __iomem *) unmask_page(cache->vaddr));
 	} else {
 		struct i915_vma *vma;
@@ -1114,7 +1116,6 @@ static void *reloc_iomap(struct drm_i915_gem_object *obj,
 
 	offset = cache->node.start;
 	if (cache->node.allocated) {
-		wmb();
 		ggtt->vm.insert_page(&ggtt->vm,
 				     i915_gem_object_get_dma_address(obj, page),
 				     offset, I915_CACHE_NONE, 0);

