Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E48C2E3608
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgL1KrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:47:09 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:33087 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727094AbgL1KrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:47:09 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id AA4E72D0;
        Mon, 28 Dec 2020 05:46:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 28 Dec 2020 05:46:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pGApwR
        QvM5xQZVA7xBvXIy2O2FpV9MaovvfPtf5Bi7o=; b=QfNjzYRlcO8H/p+HupagrJ
        uX3W9TVMCzDAFZ6pKvqAvWED76kl/aILMtLzbgSeunyZzM9otLlmT/PxUwJxB0Nq
        4nCmAQhsW8vXL0Is1iML0wfIzkF+RZelfIfABGPv1pRV6rtUZBnv4D8RkFBqqNC5
        zX7L8pPI0TWQ6W9XloeVrYTmLwISxLyrPdR/a1/kcbXidUgxrIT0pMod2h1NPJ2q
        cysQdDhG+HOqsVOZmeRLTf08cUefjC94qUirE1MKV7/NFbbuJtOqfFUDo/NuB1Zg
        nCdEHBcXz6ATUSwJMkmg18qzV+4eAdd253EJScfK5sjw4Javo4paSrXl8NklJtIw
        ==
X-ME-Sender: <xms:arfpX3apUDb3sx8G67gXwxPCM75Itz-df85Rw308B5aW2egd2eahyA>
    <xme:arfpXwDe9ABfhF5eryZ-wdLwocu0aXd6j40KjTUHoZVcYDfGujNTBBDV3zHpAPlx2
    bDZrCaWHwK4Mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:arfpX599iMGpUNNkU1_1vH2cJNN95YwyT8oFinnSzxPQxoDER7-O9g>
    <xmx:arfpXw9fDO2N2_c1Ho_edYFTrylRWEdTdkJmeNpJTU3xnPlb0fZaNQ>
    <xmx:arfpXwd3SpjLQlw186OVJDO6KZ_rkVDe59CDDzU9FbK4SorkP_crdQ>
    <xmx:a7fpX8lDwkb0zsqAreKXiQrPd7vwpBbYlCy26wfTQI-Z5EwEz2TXkd9SofA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 92BF3108005B;
        Mon, 28 Dec 2020 05:46:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Fix mismatch between misplaced vma check and vma" failed to apply to 4.19-stable tree
To:     chris@chris-wilson.co.uk, cq.tang@intel.com, jani.nikula@intel.com,
        matthew.auld@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:47:24 +0100
Message-ID: <1609152444157128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0e53656ad8abc99e0a80c3de611e593ebbf55829 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Wed, 16 Dec 2020 09:29:51 +0000
Subject: [PATCH] drm/i915: Fix mismatch between misplaced vma check and vma
 insert

When inserting a VMA, we restrict the placement to the low 4G unless the
caller opts into using the full range. This was done to allow usersapce
the opportunity to transition slowly from a 32b address space, and to
avoid breaking inherent 32b assumptions of some commands.

However, for insert we limited ourselves to 4G-4K, but on verification
we allowed the full 4G. This causes some attempts to bind a new buffer
to sporadically fail with -ENOSPC, but at other times be bound
successfully.

commit 48ea1e32c39d ("drm/i915/gen9: Set PIN_ZONE_4G end to 4GB - 1
page") suggests that there is a genuine problem with stateless addressing
that cannot utilize the last page in 4G and so we purposefully excluded
it. This means that the quick pin pass may cause us to utilize a buggy
placement.

Reported-by: CQ Tang <cq.tang@intel.com>
Testcase: igt/gem_exec_params/larger-than-life-batch
Fixes: 48ea1e32c39d ("drm/i915/gen9: Set PIN_ZONE_4G end to 4GB - 1 page")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: CQ Tang <cq.tang@intel.com>
Reviewed-by: CQ Tang <cq.tang@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v4.5+
Link: https://patchwork.freedesktop.org/patch/msgid/20201216092951.7124-1-chris@chris-wilson.co.uk
(cherry picked from commit 5f22cc0b134ab702d7f64b714e26018f7288ffee)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index b07dc1156a0e..bcc80f428172 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -382,7 +382,7 @@ eb_vma_misplaced(const struct drm_i915_gem_exec_object2 *entry,
 		return true;
 
 	if (!(flags & EXEC_OBJECT_SUPPORTS_48B_ADDRESS) &&
-	    (vma->node.start + vma->node.size - 1) >> 32)
+	    (vma->node.start + vma->node.size + 4095) >> 32)
 		return true;
 
 	if (flags & __EXEC_OBJECT_NEEDS_MAP &&

