Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0923C6AE602
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCGQLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCGQKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:10:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9542C211C6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:09:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4523EB8190C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC9FC433D2;
        Tue,  7 Mar 2023 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678205397;
        bh=9QgUivoUH8p/FXZl0zTDP/S35ZkRAkmOd/LBIpOaDPI=;
        h=Subject:To:Cc:From:Date:From;
        b=VTdiFI1DG7YVWQwMP7OVjsOpf67EsTa4mgNdgVAZeByPumtuQQdagxwF6pc1DanFF
         tKNmoRRMaRx+mNxZ8vMjUmwQf7R0xMRdHfHmayB0z56fl4KkJg20Bkc1QDh+N+Tw+1
         Z/qYa3yjYcudAZG3WDgPti4MZPac1j/kgpYg60bM=
Subject: FAILED: patch "[PATCH] drm/i915: Don't use stolen memory for ring buffers with LLC" failed to apply to 4.19-stable tree
To:     John.C.Harrison@Intel.com, chris@chris-wilson.co.uk,
        daniele.ceraolospurio@intel.com, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        jouni.hogander@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:09:53 +0100
Message-ID: <16782053932851@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 690e0ec8e63da9a29b39fedc6ed5da09c7c82651
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16782053932851@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

690e0ec8e63d ("drm/i915: Don't use stolen memory for ring buffers with LLC")
0d8ee5ba8db4 ("drm/i915: Don't back up pinned LMEM context images and rings during suspend")
c56ce9565374 ("drm/i915 Implement LMEM backup and restore for suspend / resume")
0d9388635a22 ("drm/i915/ttm: Implement a function to copy the contents of two TTM-based objects")
48b096126954 ("drm/i915: Move __i915_gem_free_object to ttm_bo_destroy")
d8ac30fd479c ("drm/i915/ttm: Reorganize the ttm move code somewhat")
32b7cf51a441 ("drm/i915/ttm: Use TTM for system memory")
3c2b8f326e7f ("drm/i915/ttm: Adjust gem flags and caching settings after a move")
0ff375759f64 ("drm/i915: Update object placement flags to be mutable")
b07a6483839a ("drm/i915/ttm: Fix incorrect assumptions about ttm_bo_validate() semantics")
50331a7b5074 ("drm/i915/ttm: accelerated move implementation")
13c2ceb6addb ("drm/i915/ttm: restore min_page_size behaviour")
d53ec322dc7d ("drm/i915/ttm: switch over to ttm_buddy_man")
687c7d0fcf80 ("drm/i915/ttm: remove node usage in our naming")
38f28c0695c0 ("drm/i915/ttm: Calculate the object placement at get_pages time")
c865204e84a1 ("drm/i915/ttm: Fix memory leaks")
cf3e3e86d779 ("drm/i915: Use ttm mmap handling for ttm bo's.")
2e53d7c1147a ("drm/i915/lmem: Verify checks for lmem residency")
213d50927763 ("drm/i915/ttm: Introduce a TTM i915 gem object backend")
2a7005c8a398 ("Merge tag 'drm-intel-gt-next-2021-06-10' of git://anongit.freedesktop.org/drm/drm-intel into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 690e0ec8e63da9a29b39fedc6ed5da09c7c82651 Mon Sep 17 00:00:00 2001
From: John Harrison <John.C.Harrison@Intel.com>
Date: Wed, 15 Feb 2023 17:11:00 -0800
Subject: [PATCH] drm/i915: Don't use stolen memory for ring buffers with LLC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Direction from hardware is that stolen memory should never be used for
ring buffer allocations on platforms with LLC. There are too many
caching pitfalls due to the way stolen memory accesses are routed. So
it is safest to just not use it.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Fixes: c58b735fc762 ("drm/i915: Allocate rings from stolen")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.9+
Tested-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-2-John.C.Harrison@Intel.com
(cherry picked from commit f54c1f6c697c4297f7ed94283c184acc338a5cf8)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 15ec64d881c4..fb1d2595392e 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -116,7 +116,7 @@ static struct i915_vma *create_ring_vma(struct i915_ggtt *ggtt, int size)
 
 	obj = i915_gem_object_create_lmem(i915, size, I915_BO_ALLOC_VOLATILE |
 					  I915_BO_ALLOC_PM_VOLATILE);
-	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt))
+	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt) && !HAS_LLC(i915))
 		obj = i915_gem_object_create_stolen(i915, size);
 	if (IS_ERR(obj))
 		obj = i915_gem_object_create_internal(i915, size);

