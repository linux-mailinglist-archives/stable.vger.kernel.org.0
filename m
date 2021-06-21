Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AAA3AE9B6
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 15:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhFUNIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 09:08:21 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:34473 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhFUNIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 09:08:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3C7A419403BD;
        Mon, 21 Jun 2021 09:06:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 21 Jun 2021 09:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OdeaTT
        dKKivheUzJINWY7e+MXezPguKMMZ7/It4M6D4=; b=EHNvu39cjBtf5LaKrHpuba
        B77rBR/yqPvHdLUXWzUoBlWDdrIfcb1rbte/J5PxUwM8SPCMdaht/t3H23VfjKHg
        4GzWExP5ylj6ZHy1y2Ij3OcMFLo6/i6dImDMS1wdiz+4vvYFP9OoT8vOYhZgqNvK
        6Po80x7xggNdkG5iaKt6zb7ULoJ2WU3EFiCRVMBbhfUrP9ZCk/LPRDOsAmyRM9JN
        NRMEupx/RATsvFMlkXXXCqn3vr5o7/5qrG6us/Fxjzr+SKF2qvkSEnoH1ZCTTO2w
        OawJ3jcZW4nG7LOEAZSxb2TB/CMZBaNbCKG/6qZqwT/HI0m5VGdRUKj4keUJd0Ig
        ==
X-ME-Sender: <xms:v47QYDjFJb20cXhiFYfXrpV_eKvbozWxFqVb1o7yGMVCjCnJqWWv-A>
    <xme:v47QYABl2x97eUs0AgOPM_1fN7aY5RpY9wPnSEGnQWQcZaifoqjzMuYaC6KUSS3Vk
    rWEBcmIBd1ILA>
X-ME-Received: <xmr:v47QYDFZiMAO5wydnqp8hrTh_xyOoE8NmtVAE45szjLs4xkslJ1K_2_7oOzECynsmAlojNWDgx1e2SdDgCU-gbsscZ4xpYro>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:v47QYARsP3Yg0er7e6620As1Zv8cRoKNUK0rLg00Iyp-hIzLy2dekw>
    <xmx:v47QYAxaAJzAS_5jpPQgKXZ1xGSFNScIZemVmuklfKLOzmJezsnfzg>
    <xmx:v47QYG67A6liCFcVU45AID4uzAmnhebFNVV2wv3IhW4FkGob4CN2Dg>
    <xmx:v47QYK6F113UHn_jf5nHfG6rZU6t2p1oweBXBh6BGAC6IO4lhm-Sdr5P650>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 09:06:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/slub: fix redzoning for small allocations" failed to apply to 4.9-stable tree
To:     keescook@chromium.org, akpm@linux-foundation.org, cl@linux.com,
        elver@google.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, zplin@psu.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 15:05:57 +0200
Message-ID: <1624280757155123@kroah.com>
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

From 74c1d3e081533825f2611e46edea1fcdc0701985 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Tue, 15 Jun 2021 18:23:22 -0700
Subject: [PATCH] mm/slub: fix redzoning for small allocations

The redzone area for SLUB exists between s->object_size and s->inuse
(which is at least the word-aligned object_size).  If a cache were
created with an object_size smaller than sizeof(void *), the in-object
stored freelist pointer would overwrite the redzone (e.g.  with boot
param "slub_debug=ZF"):

  BUG test (Tainted: G    B            ): Right Redzone overwritten
  -----------------------------------------------------------------------------

  INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
  INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
  INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620

  Redzone  (____ptrval____): bb bb bb bb bb bb bb bb    ........
  Object   (____ptrval____): f6 f4 a5 40 1d e8          ...@..
  Redzone  (____ptrval____): 1a aa                      ..
  Padding  (____ptrval____): 00 00 00 00 00 00 00 00    ........

Store the freelist pointer out of line when object_size is smaller than
sizeof(void *) and redzoning is enabled.

Additionally remove the "smaller than sizeof(void *)" check under
CONFIG_DEBUG_VM in kmem_cache_sanity_check() as it is now redundant:
SLAB and SLOB both handle small sizes.

(Note that no caches within this size range are known to exist in the
kernel currently.)

Link: https://lkml.kernel.org/r/20210608183955.280836-3-keescook@chromium.org
Fixes: 81819f0fc828 ("SLUB core")
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Lin, Zhenpeng" <zplin@psu.edu>
Cc: Marco Elver <elver@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/slab_common.c b/mm/slab_common.c
index a4a571428c51..7cab77655f11 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -97,8 +97,7 @@ EXPORT_SYMBOL(kmem_cache_size);
 #ifdef CONFIG_DEBUG_VM
 static int kmem_cache_sanity_check(const char *name, unsigned int size)
 {
-	if (!name || in_interrupt() || size < sizeof(void *) ||
-		size > KMALLOC_MAX_SIZE) {
+	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
 		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
 		return -EINVAL;
 	}
diff --git a/mm/slub.c b/mm/slub.c
index f91d9fe7d0d8..f58cfd456548 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3734,15 +3734,17 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	 */
 	s->inuse = size;
 
-	if (((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
-		s->ctor)) {
+	if ((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
+	    ((flags & SLAB_RED_ZONE) && s->object_size < sizeof(void *)) ||
+	    s->ctor) {
 		/*
 		 * Relocate free pointer after the object if it is not
 		 * permitted to overwrite the first word of the object on
 		 * kmem_cache_free.
 		 *
 		 * This is the case if we do RCU, have a constructor or
-		 * destructor or are poisoning the objects.
+		 * destructor, are poisoning the objects, or are
+		 * redzoning an object smaller than sizeof(void *).
 		 *
 		 * The assumption that s->offset >= s->inuse means free
 		 * pointer is outside of the object is used in the

