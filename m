Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057393AE9BC
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 15:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhFUNJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 09:09:00 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:54355 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhFUNI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 09:08:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 72ACA1940680;
        Mon, 21 Jun 2021 09:06:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 21 Jun 2021 09:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8uVIUb
        mWP9rVNqsyTlw7q5/wOgaiSBIGoy4mM58JmMc=; b=HDXhMxSCx00UWVXQSI/ov/
        ZoPNg8B5pHuaaVWnX0bhiPvI5+aWarPKOx/ddbJxsxFFjgVYEfYf0zSUM3ROJ8WR
        Gnf1Km4LJTo7SUDSEs85VPu3m42awipO06zpgYPHNIu40Hk9iuRgiet9BLWU0t3G
        ID9rf23005JtILUcS5D1wPTRfTqk8zUoGEJRiviTdUQ7MQ+h6qvLOLwX/kcmyxR1
        DQQ6/H5qhEBF2BI5xTDyMmNdkzwPymJ7mUKEmZzvAkakaPvyj8i9IpgMirnYaQir
        e5l/rqVlUnK5sWVjZZ/dHlPJdGVPSyjwL4IbocM3xwg6/kzj1Qdl3rdg6ejoekyA
        ==
X-ME-Sender: <xms:5I7QYHNFGBW5Fc0ib6797TKm4ZCgPdEdaBwiTg6hcrB3YDm-U1EZiw>
    <xme:5I7QYB8AtdHlHmQIgpOjkhNNxWTo0gkYe_SZSNSB23oDUJF7_SDGR-mFjHXYU7sDX
    5oSyWoeXov78g>
X-ME-Received: <xmr:5I7QYGQ_Id7nme31XPF-ofYVB_uEv6rcwWy6XK2p5iQHdwuked4-mzPf2tTYpKE60bSQKimbFtn1DX7IUgFhlBpd4bTI7_ze>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:5I7QYLtBL-B7DyJjKuBF8y5d5eXGqa8ZyVSU7s0vj-D9zU1M3R_XJg>
    <xmx:5I7QYPfC1OfsWN6WbuaeuGsMcLUYt3vqn3kftHnJlJHJEVfWTTOa-g>
    <xmx:5I7QYH2JW0s2X4JxcPKrP6mH08kJaPreKz-WCFL6QjkLewcRHsIQ4g>
    <xmx:5Y7QYH31ikSdZCC7gTktADLgdQlgxg72MXptBIuBuXfUHuQkLqab7z8_JGw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 09:06:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/slub: actually fix freelist pointer vs redzoning" failed to apply to 5.4-stable tree
To:     keescook@chromium.org, akpm@linux-foundation.org, cl@linux.com,
        elver@google.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, zplin@psu.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 15:06:34 +0200
Message-ID: <162428079422629@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e41a49fadbc80b60b48d3c095d9e2ee7ef7c9a8e Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Tue, 15 Jun 2021 18:23:26 -0700
Subject: [PATCH] mm/slub: actually fix freelist pointer vs redzoning

It turns out that SLUB redzoning ("slub_debug=Z") checks from
s->object_size rather than from s->inuse (which is normally bumped to
make room for the freelist pointer), so a cache created with an object
size less than 24 would have the freelist pointer written beyond
s->object_size, causing the redzone to be corrupted by the freelist
pointer.  This was very visible with "slub_debug=ZF":

  BUG test (Tainted: G    B            ): Right Redzone overwritten
  -----------------------------------------------------------------------------

  INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
  INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
  INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620

  Redzone  (____ptrval____): bb bb bb bb bb bb bb bb               ........
  Object   (____ptrval____): 00 00 00 00 00 f6 f4 a5               ........
  Redzone  (____ptrval____): 40 1d e8 1a aa                        @....
  Padding  (____ptrval____): 00 00 00 00 00 00 00 00               ........

Adjust the offset to stay within s->object_size.

(Note that no caches of in this size range are known to exist in the
kernel currently.)

Link: https://lkml.kernel.org/r/20210608183955.280836-4-keescook@chromium.org
Link: https://lore.kernel.org/linux-mm/20200807160627.GA1420741@elver.google.com/
Link: https://lore.kernel.org/lkml/0f7dd7b2-7496-5e2d-9488-2ec9f8e90441@suse.cz/Fixes: 89b83f282d8b (slub: avoid redzone when choosing freepointer location)
Link: https://lore.kernel.org/lkml/CANpmjNOwZ5VpKQn+SYWovTkFB4VsT-RPwyENBmaK0dLcpqStkA@mail.gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Marco Elver <elver@google.com>
Reported-by: "Lin, Zhenpeng" <zplin@psu.edu>
Tested-by: Marco Elver <elver@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/slub.c b/mm/slub.c
index f58cfd456548..fe30df460fad 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3689,7 +3689,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
 	slab_flags_t flags = s->flags;
 	unsigned int size = s->object_size;
-	unsigned int freepointer_area;
 	unsigned int order;
 
 	/*
@@ -3698,13 +3697,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	 * the possible location of the free pointer.
 	 */
 	size = ALIGN(size, sizeof(void *));
-	/*
-	 * This is the area of the object where a freepointer can be
-	 * safely written. If redzoning adds more to the inuse size, we
-	 * can't use that portion for writing the freepointer, so
-	 * s->offset must be limited within this for the general case.
-	 */
-	freepointer_area = size;
 
 #ifdef CONFIG_SLUB_DEBUG
 	/*
@@ -3730,7 +3722,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 	/*
 	 * With that we have determined the number of bytes in actual use
-	 * by the object. This is the potential offset to the free pointer.
+	 * by the object and redzoning.
 	 */
 	s->inuse = size;
 
@@ -3753,13 +3745,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 		 */
 		s->offset = size;
 		size += sizeof(void *);
-	} else if (freepointer_area > sizeof(void *)) {
+	} else {
 		/*
 		 * Store freelist pointer near middle of object to keep
 		 * it away from the edges of the object to avoid small
 		 * sized over/underflows from neighboring allocations.
 		 */
-		s->offset = ALIGN(freepointer_area / 2, sizeof(void *));
+		s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));
 	}
 
 #ifdef CONFIG_SLUB_DEBUG

