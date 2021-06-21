Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD393AE9B2
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 15:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFUNIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 09:08:14 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:52371 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhFUNIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 09:08:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id E3994194025A;
        Mon, 21 Jun 2021 09:05:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 21 Jun 2021 09:05:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=beQ4sO
        GFbnCDn7REXrgJ3vGo4WHGObEf32b42ZgVAdY=; b=kNjc9qmF0s4TI+mp1Mq/i2
        jnUmR/WA6ikAs4XG3/oScp1Jee0uT1UVU0s2jL8WCts2zaeEnLs+DVyt7yZ5v8Lq
        iXRj0m3/THXHBOY3qMFd3e+oC91lSWgXERQwgqZteMIEl9rQLMsV6pxy6jpozonB
        ZVkHxJL/hSUUhMKgHbhtLq0XGUGHE2wCROFjRw8TtX5O0IMEolSh36VOrOs95IwA
        zhXAeYpI+kueTvGpnl3jIT/TSAPzPZl6ZFxZ8KHEk1p5P50KKNum7KTdl3bWQUmw
        k2MBe1wG2GAfXpBKxCbyxjeJnGSEA3QB+ed5nH/InAHmX5d/petp2FkQkScSPCIQ
        ==
X-ME-Sender: <xms:tY7QYAjb6ti-fbdzM3d8dIM14VJBy5rocXw50AlmYIMpRFYID13c1w>
    <xme:tY7QYJCOHoAQ1FhsBcDty8KvpG3egf0jRpgqLiWGehPK-0XGqZy_kdRT2jmCdQ9zM
    daYRIQG6Axmew>
X-ME-Received: <xmr:tY7QYIFrOEWecgwuNoaqzdjrGr1DSiffrOAafPEOr2YwbmbhA2rhawtvNRvDPPbctSpNH3xXGC0JR0lJDiUu19n5cce_Re_G>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:tY7QYBQYa2epBfL2YPdf_BR0vHDm2IiWFRBjH6fvy29JtnspyVnB1w>
    <xmx:tY7QYNz87gYZo4AqYIdZ-K4XHQxpiLRWGk9JAXHLR9wUf5Q0Ngqymg>
    <xmx:tY7QYP7tpQ6ksqnxJUNKa7fotmrVcRjrDdROZQJDYURzcMzwO8RCqg>
    <xmx:t47QYD58q1kCh4jbWQqKSOg4s5CcSa-aIK33j4gbVcwps2kTrLvaVDTJcUg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 09:05:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/slub: fix redzoning for small allocations" failed to apply to 4.4-stable tree
To:     keescook@chromium.org, akpm@linux-foundation.org, cl@linux.com,
        elver@google.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, zplin@psu.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 15:05:56 +0200
Message-ID: <1624280756185160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

