Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B90E1A9C7A
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897085AbgDOLfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:35:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43365 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2897072AbgDOLfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:35:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0E5925C01D6;
        Wed, 15 Apr 2020 07:35:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PvSQ+8
        9nrRv1yrdiaiWs6/WAyakY6Cw+6Hub8KPaQHM=; b=tTuoSgL01YNqtknXvMtOqi
        XxGViXHxyRuIjXkc8bGqumCUdKPwoAnYKrOGsdbBTjI5UdUqlFTtLAxemU2eH5Dl
        IjpSiO8w1AmH8EOsaHa5z4AfeHLl5HLdCUISRWPtaTXqFymtfRpWzaIR0htfaygr
        Bop9B1oxQWP02lbeo4NL/lLMznOksjiSBBzyiER9A3MGqKMh/Gxp75ghcxqkVeyZ
        HruN8LWbcWH7rE77QMZqqVEtnRuKaBnSGdeOWgFoJ5S8SC5VHDlng0TDqMwzyp0d
        cejFM8rTrFrpHcmWq79Xg3USHnKB7t3eQj79wSLkBRcaqLkn+kVwhZG2uLENe2+g
        ==
X-ME-Sender: <xms:jPGWXuVTFuSlnx5c58ypxb8nBluSgmojOuWek4W7vhAS0yiIsV4XPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:jPGWXtiU_ilFtjL2GD-7fVtmOB-bJfOMhFx5eQC-EWnN9LJ-56YCDg>
    <xmx:jPGWXqnEB394rd4KiohvxUGdqtnus5jSGKqfEM5CNcqaweGfZqcVqg>
    <xmx:jPGWXkI2xIcvsCn4GGAbIhsgL60y7hb5u9RJnuDW7usSazNjkH_zqA>
    <xmx:jfGWXllei8cfxqxjrv1x7u4vWFFCLiKG-1uT-sdQ7UxygF3r-h65JQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B5373280060;
        Wed, 15 Apr 2020 07:35:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Fill all the unused space in the GGTT" failed to apply to 5.6-stable tree
To:     chris@chris-wilson.co.uk, imre.deak@intel.com,
        matthew.auld@intel.com, rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:35:39 +0200
Message-ID: <1586950539224114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0b72a251bf92ca2378530fa1f9b35a71830ab51c Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 31 Mar 2020 16:23:48 +0100
Subject: [PATCH] drm/i915/gt: Fill all the unused space in the GGTT

When we allocate space in the GGTT we may have to allocate a larger
region than will be populated by the object to accommodate fencing. Make
sure that this space beyond the end of the buffer points safely into
scratch space, in case the HW tries to access it anyway (e.g. fenced
access to the last tile row).

v2: Preemptively / conservatively guard gen6 ggtt as well.

Reported-by: Imre Deak <imre.deak@intel.com>
References: https://gitlab.freedesktop.org/drm/intel/-/issues/1554
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200331152348.26946-1-chris@chris-wilson.co.uk
(cherry picked from commit 4d6c18590870fbac1e65dde5e01e621c8e0ca096)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt.c b/drivers/gpu/drm/i915/gt/intel_ggtt.c
index aed498a0d032..4c5a209cb669 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt.c
@@ -191,10 +191,11 @@ static void gen8_ggtt_insert_entries(struct i915_address_space *vm,
 				     enum i915_cache_level level,
 				     u32 flags)
 {
-	struct i915_ggtt *ggtt = i915_vm_to_ggtt(vm);
-	struct sgt_iter sgt_iter;
-	gen8_pte_t __iomem *gtt_entries;
 	const gen8_pte_t pte_encode = gen8_ggtt_pte_encode(0, level, 0);
+	struct i915_ggtt *ggtt = i915_vm_to_ggtt(vm);
+	gen8_pte_t __iomem *gte;
+	gen8_pte_t __iomem *end;
+	struct sgt_iter iter;
 	dma_addr_t addr;
 
 	/*
@@ -202,10 +203,17 @@ static void gen8_ggtt_insert_entries(struct i915_address_space *vm,
 	 * not to allow the user to override access to a read only page.
 	 */
 
-	gtt_entries = (gen8_pte_t __iomem *)ggtt->gsm;
-	gtt_entries += vma->node.start / I915_GTT_PAGE_SIZE;
-	for_each_sgt_daddr(addr, sgt_iter, vma->pages)
-		gen8_set_pte(gtt_entries++, pte_encode | addr);
+	gte = (gen8_pte_t __iomem *)ggtt->gsm;
+	gte += vma->node.start / I915_GTT_PAGE_SIZE;
+	end = gte + vma->node.size / I915_GTT_PAGE_SIZE;
+
+	for_each_sgt_daddr(addr, iter, vma->pages)
+		gen8_set_pte(gte++, pte_encode | addr);
+	GEM_BUG_ON(gte > end);
+
+	/* Fill the allocated but "unused" space beyond the end of the buffer */
+	while (gte < end)
+		gen8_set_pte(gte++, vm->scratch[0].encode);
 
 	/*
 	 * We want to flush the TLBs only after we're certain all the PTE
@@ -241,13 +249,22 @@ static void gen6_ggtt_insert_entries(struct i915_address_space *vm,
 				     u32 flags)
 {
 	struct i915_ggtt *ggtt = i915_vm_to_ggtt(vm);
-	gen6_pte_t __iomem *entries = (gen6_pte_t __iomem *)ggtt->gsm;
-	unsigned int i = vma->node.start / I915_GTT_PAGE_SIZE;
+	gen6_pte_t __iomem *gte;
+	gen6_pte_t __iomem *end;
 	struct sgt_iter iter;
 	dma_addr_t addr;
 
+	gte = (gen6_pte_t __iomem *)ggtt->gsm;
+	gte += vma->node.start / I915_GTT_PAGE_SIZE;
+	end = gte + vma->node.size / I915_GTT_PAGE_SIZE;
+
 	for_each_sgt_daddr(addr, iter, vma->pages)
-		iowrite32(vm->pte_encode(addr, level, flags), &entries[i++]);
+		iowrite32(vm->pte_encode(addr, level, flags), gte++);
+	GEM_BUG_ON(gte > end);
+
+	/* Fill the allocated but "unused" space beyond the end of the buffer */
+	while (gte < end)
+		iowrite32(vm->scratch[0].encode, gte++);
 
 	/*
 	 * We want to flush the TLBs only after we're certain all the PTE

