Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8254F2E3602
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgL1KrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:47:08 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:41517 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727094AbgL1KrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:47:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CB6E6378;
        Mon, 28 Dec 2020 05:46:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:46:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cF7S7G
        t6LbGWt32Uk4ExJOJ+x13tLNeNFNUjNcImDOc=; b=XTr/djjIea4s+w/nXl7wIw
        fXK+QFDhDQ9lx1BllTUhpBhHq7mzuTDTcNILvuUvhFn0pn5fYSI7r26IlbKoYOEJ
        nuykBSrPVXOfOPDT0OhMuslYPAHnF5yO66G/4aR1/ogMobKw4wuL4mr3yziLxV8V
        /oy8g2bFflZ2iW2wgtlUJZfKGUNMUmiY8qBGg+bF8jARTvpEf4XIZTBJJuK+o0xF
        bCBSnSQcYqosNaHWedTh2wsx4I4XkxIWmVgSa75buAP/YoNMItOWnln94m86UBFS
        YvhIXmCJG5RcOVxVq7peAMzXLJ++3okKks1rePjJjr2MddR88TKVyphTX7yjjHpg
        ==
X-ME-Sender: <xms:abfpX9XM58Hf4nBZOwQAXLqDP1kDOG2M2sBGuliYLnWiHphFsAtvZQ>
    <xme:abfpX9mwC6TNpVHP2lNho9CyBcZwki02fSLruQXg5SckoGteOD4NrK3yCScVyMQWu
    n-_2q1rRsOm2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:abfpX5aaSYfkJl0AX8tW5-0Vx6fqbeF_9RdzmwT2CRkNtXgCAbRnsg>
    <xmx:abfpXwUCZZa_YJLmDFxUysVjl2wqeCoHyHWhM54Ycsdq_kwEESg62w>
    <xmx:abfpX3kesje9AY--_jXI2ZBb6ZiTdMZXwIy-zSHUYBEtONCgZlrg1A>
    <xmx:abfpX8whKxphHmB3NDApHZxo6XrxAKU47izslE00L1_ooAAAUIlHDOyLJu8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11556240062;
        Mon, 28 Dec 2020 05:46:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Fix mismatch between misplaced vma check and vma" failed to apply to 4.14-stable tree
To:     chris@chris-wilson.co.uk, cq.tang@intel.com, jani.nikula@intel.com,
        matthew.auld@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:47:23 +0100
Message-ID: <160915244322220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

