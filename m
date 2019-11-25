Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1652810931A
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfKYRti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:49:38 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45821 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbfKYRti (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 12:49:38 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0EB9922720;
        Mon, 25 Nov 2019 12:49:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 25 Nov 2019 12:49:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NliBHa
        L7tONrKZtTSEW7Z7I72L1fKYtn5Wq00XktTJM=; b=JzwnWjgAHat5nvjrTXPELZ
        6eqfCqfYXR48Q3YF68InjSeoE7X16J9Pt/SlYFUM7dz066Mqz/3Yu2fCkkhptN+l
        ZlO9k5g8P4cVBM842nuGkYt3jpymaV765LHTsvN4tdhBj8jZEPqhJAdf+KGRSubl
        Q3D/yRlsEneS9EatrQYnNz/0CY1+2pRzXSHxW0u6RuwvkLjP5EaC3Z/xXOdF8ThH
        A3xl1TaSWtJ2O3fzvsDknUc7qHcni2YojNGWUmTdHmqvfZQzd2xr4Iy3zJQkpdAi
        lRxljKPCBr3UvsDHAkASv6pnjWKejshI88LZdATq9ZB11wagkC2ivls2YOY1eyYQ
        ==
X-ME-Sender: <xms:MBTcXX55cqTydYsQwAmQwBP6-n1X65J5VikMurK99v23XaosKxg32Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeiuddguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghdpkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:MBTcXfKaUR-dEalSFdLvwrBBV3mkR3Dn0e9nVlYeh9WQ9-5BzNNm5A>
    <xmx:MBTcXeiDS3ir-IRzTJn6HlT6gkPt1RnfkkIU_SGsA0Su7oPxYhw8RA>
    <xmx:MBTcXRGgOgfFjYZ1saZ8H2RLpxZpA5qdUckXrhqNHkCOtp38sbH0eQ>
    <xmx:MRTcXbLId8oEx6OH-s82573d9-G-Nv5nJIEePUMAxZx8yeQd4oB_7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A0E21306005E;
        Mon, 25 Nov 2019 12:49:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/userptr: Try to acquire the page lock around" failed to apply to 4.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        lionel.g.landwerlin@intel.com, rodrigo.vivi@intel.com,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Nov 2019 18:49:27 +0100
Message-ID: <1574704167165126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 2d691aeca4aecbb8d0414a777a46981a8e142b05 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 11 Nov 2019 13:32:03 +0000
Subject: [PATCH] drm/i915/userptr: Try to acquire the page lock around
 set_page_dirty()

set_page_dirty says:

	For pages with a mapping this should be done under the page lock
	for the benefit of asynchronous memory errors who prefer a
	consistent dirty state. This rule can be broken in some special
	cases, but should be better not to.

Under those rules, it is only safe for us to use the plain set_page_dirty
calls for shmemfs/anonymous memory. Userptr may be used with real
mappings and so needs to use the locked version (set_page_dirty_lock).

However, following a try_to_unmap() we may want to remove the userptr and
so call put_pages(). However, try_to_unmap() acquires the page lock and
so we must avoid recursively locking the pages ourselves -- which means
that we cannot safely acquire the lock around set_page_dirty(). Since we
can't be sure of the lock, we have to risk skip dirtying the page, or
else risk calling set_page_dirty() without a lock and so risk fs
corruption.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112012
Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
References: cb6d7c7dc7ff ("drm/i915/userptr: Acquire the page lock around set_page_dirty()")
References: 505a8ec7e11a ("Revert "drm/i915/userptr: Acquire the page lock around set_page_dirty()"")
References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191111133205.11590-1-chris@chris-wilson.co.uk
(cherry picked from commit 0d4bbe3d407f79438dc4f87943db21f7134cfc65)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
(cherry picked from commit cee7fb437edcdb2f9f8affa959e274997f5dca4d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
index 6b3b50f0f6d9..abfbac49b8e8 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -671,8 +671,28 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 		obj->mm.dirty = false;
 
 	for_each_sgt_page(page, sgt_iter, pages) {
-		if (obj->mm.dirty)
+		if (obj->mm.dirty && trylock_page(page)) {
+			/*
+			 * As this may not be anonymous memory (e.g. shmem)
+			 * but exist on a real mapping, we have to lock
+			 * the page in order to dirty it -- holding
+			 * the page reference is not sufficient to
+			 * prevent the inode from being truncated.
+			 * Play safe and take the lock.
+			 *
+			 * However...!
+			 *
+			 * The mmu-notifier can be invalidated for a
+			 * migrate_page, that is alreadying holding the lock
+			 * on the page. Such a try_to_unmap() will result
+			 * in us calling put_pages() and so recursively try
+			 * to lock the page. We avoid that deadlock with
+			 * a trylock_page() and in exchange we risk missing
+			 * some page dirtying.
+			 */
 			set_page_dirty(page);
+			unlock_page(page);
+		}
 
 		mark_page_accessed(page);
 		put_page(page);

