Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CD22E3600
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgL1KrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:47:06 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:49575 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727094AbgL1KrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:47:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 529172DC;
        Mon, 28 Dec 2020 05:46:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:46:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GokFX3
        A2aiXkGCyqs2KkxrEz30KmRufEwGAtvJB0Qrg=; b=PofJofL4SqWc6uwMg4vy6Q
        OE6rkWLKAnjFJ7V2LbI9cuMIw06Kh3c8icFfkHmDgUFgBAi49CIf/Us3emYowt1N
        EuxQQXXtkJYvouDnxc/tLhn+uGGrWIRW6egl/XMeo9ff7VeFEDmPMdScXfzCig1d
        HGzZ4P5SrDnLfWMarZ+m8/sQwSzeROE5OUtl43V3vneSIH8ltU+bRKuFNr3vPQ5x
        dUXdV7XC7fZQKWBZjw122dsaw1894joAZpDnqBrUIhcQZKBk5U3ALznvz0cNgpl8
        VOktJyZ3WYSZW3/afaiuM5AL2uFXn0IUNPfmEG0AdHQ4nHhn4Z7BQI6LCpENjrsQ
        ==
X-ME-Sender: <xms:Z7fpX9GRHblaxO-2qpAeLQvbDxDJjWnYr-jTpz7YeiV6Aiv5IKzEHQ>
    <xme:Z7fpXyX4OlXO51Ith92W9zSfOlW7R0njG9IbA8UgmJK1SMFd6_VBHwP4zkTKsxlA5
    O7YLZhwJd7g9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Z7fpX_I9iRRpFDjk8tOL2EhhJk1rui2Jjthq7DUZE89yvj5RQf2VOA>
    <xmx:Z7fpXzE4EkjvfTlaSfvrjqUOwyY4svp2JUAsOyteXvUAISHTMMh0dQ>
    <xmx:Z7fpXzW3rZWzACrWGBEFuSx-NEZbFw_B0JslOBTKDZLPfs60adHhzg>
    <xmx:Z7fpXwiWolI_E83Aaf58gJxXuPks2oEKnXMkNfODjtXaEaIrO0fBYGGnAdY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E252F108005C;
        Mon, 28 Dec 2020 05:45:58 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Fix mismatch between misplaced vma check and vma" failed to apply to 4.9-stable tree
To:     chris@chris-wilson.co.uk, cq.tang@intel.com, jani.nikula@intel.com,
        matthew.auld@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:47:22 +0100
Message-ID: <160915244223115@kroah.com>
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

