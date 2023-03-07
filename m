Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0BF6AE608
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCGQLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCGQLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:11:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1601311EB7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DF26B81929
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B75C4339B;
        Tue,  7 Mar 2023 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678205451;
        bh=f/OayzgDLFhTsVXTxLjBENlVayxNz46F0yYtquufrIY=;
        h=Subject:To:Cc:From:Date:From;
        b=AQCScydvOFCuqfSvJpodH/cnUFVQRlRI4589H5aa8Wp+PAVxCzjNBg1sW4IUDxL7t
         WHJ4e6g7gRAwINZC3VZeJg1d8Y9L0kr2ZGqAyL/UrlHgKQMqbKk5OWXUHgilYkrV7Y
         lVqxhG/H9MY8ZLjnpyL+uQyuPbe3Z1bjNiOl/iN4=
Subject: FAILED: patch "[PATCH] drm/i915: Don't use BAR mappings for ring buffers with LLC" failed to apply to 4.19-stable tree
To:     John.C.Harrison@Intel.com, chris@chris-wilson.co.uk,
        daniele.ceraolospurio@intel.com, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        jouni.hogander@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:10:47 +0100
Message-ID: <167820544723615@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
git cherry-pick -x 85636167e3206c3fbd52254fc432991cc4e90194
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167820544723615@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

85636167e320 ("drm/i915: Don't use BAR mappings for ring buffers with LLC")
fa85bfd19c26 ("drm/i915: Update the helper to set correct mapping")
e09e903a6e89 ("drm/i915/selftests: Prepare execlists and lrc selftests for obj->mm.lock removal")
17b7ab92bec3 ("drm/i915/selftests: Prepare hangcheck for obj->mm.lock removal")
d3ad29567d4e ("drm/i915/selftests: Prepare context selftest for obj->mm.lock removal")
c858ffa17716 ("drm/i915: Lock ww in ucode objects correctly")
c05258889ed4 ("drm/i915: Add igt_spinner_pin() to allow for ww locking around spinner.")
6895649bf13f ("drm/i915/selftests: Set error returns")
a0d3fdb628b8 ("drm/i915/gt: Split logical ring contexts from execlist submission")
d0d829e56674 ("drm/i915: split gen8+ flush and bb_start emission functions")
70a2b431c364 ("drm/i915/gt: Rename lrc.c to execlists_submission.c")
d33fcd798cb7 ("drm/i915/gt: Ignore dt==0 for reporting underflows")
09212e81e545 ("drm/i915/gt: Flush xcs before tgl breadcrumbs")
c10f6019d0b2 ("drm/i915/gt: Use the local HWSP offset during submission")
89db95377be4 ("drm/i915/gt: Confirm the context survives execution")
052e04f17056 ("drm/i915/selftests: Fix locking inversion in lrc selftest.")
47b086934f42 ("drm/i915: Make sure execbuffer always passes ww state to i915_vma_pin.")
3999a7087989 ("drm/i915: Rework intel_context pinning to do everything outside of pin_mutex")
2bf541ff6d06 ("drm/i915: Pin engine before pinning all objects, v5.")
b49a7d51c32e ("drm/i915: Nuke arguments to eb_pin_engine")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85636167e3206c3fbd52254fc432991cc4e90194 Mon Sep 17 00:00:00 2001
From: John Harrison <John.C.Harrison@Intel.com>
Date: Wed, 15 Feb 2023 17:11:01 -0800
Subject: [PATCH] drm/i915: Don't use BAR mappings for ring buffers with LLC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Direction from hardware is that ring buffers should never be mapped
via the BAR on systems with LLC. There are too many caching pitfalls
due to the way BAR accesses are routed. So it is safest to just not
use it.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywhere")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.9+
Tested-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-3-John.C.Harrison@Intel.com
(cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851d919)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index fb1d2595392e..fb99143be98e 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -53,7 +53,7 @@ int intel_ring_pin(struct intel_ring *ring, struct i915_gem_ww_ctx *ww)
 	if (unlikely(ret))
 		goto err_unpin;
 
-	if (i915_vma_is_map_and_fenceable(vma)) {
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915)) {
 		addr = (void __force *)i915_vma_pin_iomap(vma);
 	} else {
 		int type = i915_coherent_map_type(vma->vm->i915, vma->obj, false);
@@ -98,7 +98,7 @@ void intel_ring_unpin(struct intel_ring *ring)
 		return;
 
 	i915_vma_unset_ggtt_write(vma);
-	if (i915_vma_is_map_and_fenceable(vma))
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
 		i915_vma_unpin_iomap(vma);
 	else
 		i915_gem_object_unpin_map(vma->obj);

