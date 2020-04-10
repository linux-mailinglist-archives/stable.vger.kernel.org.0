Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2511A4354
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 10:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgDJIJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 04:09:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56969 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgDJIJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 04:09:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CE7355C0206;
        Fri, 10 Apr 2020 04:09:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 10 Apr 2020 04:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=x9uBsS
        be1W5Hz8YEUDvd2KjhD9NyvHSZRCewmdQXE1A=; b=cr8LPJkOrYcVy2Z+BHv/dW
        2xbYgH8Hh2Nb/l00pFYHpla3JQVya66sKnfLQ2EA/TZaSHiHwEhCyANtC01+baq6
        VErM2Kt0aOFFCIgmtAR93rblBxUfucbYRV3VkK1621K8AWq6gk+mlPBwiue2zAYU
        2WxnW6C9svPksS9/iCKM2QT5RpavJbswUJc65+cs3dO6TtUQn78lENMPAOdWP7yK
        uw9yuqXbC3lDSU+SIwTs1iNaeYlzV4DIP1UBEkLycCyqrSogXpnfLHfNMgJo/PCB
        zP5WnHFs0iehZmQkjEpoLn9FPlgUbO2sxoU1KL2ucVLSdjCZfZBd6HWVytKkFUYA
        ==
X-ME-Sender: <xms:oCmQXvGzmgaGeTyn8lBTJmJS-mJWz5z5ik-UFdDz-q1yyKYNDnUVwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvddvgddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepihhnfhhoshgvtghttggsrhdrtghomhdrrghupdhkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:oCmQXjEXh0MrxRaorPsePeo8gWJSkFMKbzXX5EnXtEcKU__bpcZxJQ>
    <xmx:oCmQXvDithjD9lhnH2yelzDdSxquhaIUG1_U-0ksjIs5yd-uGxyGqw>
    <xmx:oCmQXoFVCHrI2zQVnOqt6RT9v1QE-UFINWeivru3ScCcgt6KvF8sYQ>
    <xmx:oSmQXqeEHA_pgS1nq0VKFUFDtUyR5VHWRnukNveD_WvMGlD9yF7zFA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 295473060066;
        Fri, 10 Apr 2020 04:09:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] slub: improve bit diffusion for freelist ptr obfuscation" failed to apply to 4.19-stable tree
To:     keescook@chromium.org, akpm@linux-foundation.org, cl@linux.com,
        iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com,
        silvio.cesare@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Apr 2020 10:09:02 +0200
Message-ID: <1586506142226229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 1ad53d9fa3f6168ebcf48a50e08b170432da2257 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Wed, 1 Apr 2020 21:04:23 -0700
Subject: [PATCH] slub: improve bit diffusion for freelist ptr obfuscation

Under CONFIG_SLAB_FREELIST_HARDENED=y, the obfuscation was relatively weak
in that the ptr and ptr address were usually so close that the first XOR
would result in an almost entirely 0-byte value[1], leaving most of the
"secret" number ultimately being stored after the third XOR.  A single
blind memory content exposure of the freelist was generally sufficient to
learn the secret.

Add a swab() call to mix bits a little more.  This is a cheap way (1
cycle) to make attacks need more than a single exposure to learn the
secret (or to know _where_ the exposure is in memory).

kmalloc-32 freelist walk, before:

ptr              ptr_addr            stored value      secret
ffff90c22e019020@ffff90c22e019000 is 86528eb656b3b5bd (86528eb656b3b59d)
ffff90c22e019040@ffff90c22e019020 is 86528eb656b3b5fd (86528eb656b3b59d)
ffff90c22e019060@ffff90c22e019040 is 86528eb656b3b5bd (86528eb656b3b59d)
ffff90c22e019080@ffff90c22e019060 is 86528eb656b3b57d (86528eb656b3b59d)
ffff90c22e0190a0@ffff90c22e019080 is 86528eb656b3b5bd (86528eb656b3b59d)
...

after:

ptr              ptr_addr            stored value      secret
ffff9eed6e019020@ffff9eed6e019000 is 793d1135d52cda42 (86528eb656b3b59d)
ffff9eed6e019040@ffff9eed6e019020 is 593d1135d52cda22 (86528eb656b3b59d)
ffff9eed6e019060@ffff9eed6e019040 is 393d1135d52cda02 (86528eb656b3b59d)
ffff9eed6e019080@ffff9eed6e019060 is 193d1135d52cdae2 (86528eb656b3b59d)
ffff9eed6e0190a0@ffff9eed6e019080 is f93d1135d52cdac2 (86528eb656b3b59d)

[1] https://blog.infosectcbr.com.au/2020/03/weaknesses-in-linux-kernel-heap.html

Fixes: 2482ddec670f ("mm: add SLUB free list pointer obfuscation")
Reported-by: Silvio Cesare <silvio.cesare@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/202003051623.AF4F8CB@keescook
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/slub.c b/mm/slub.c
index fc911c222b11..bc949e3428c9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -259,7 +259,7 @@ static inline void *freelist_ptr(const struct kmem_cache *s, void *ptr,
 	 * freepointer to be restored incorrectly.
 	 */
 	return (void *)((unsigned long)ptr ^ s->random ^
-			(unsigned long)kasan_reset_tag((void *)ptr_addr));
+			swab((unsigned long)kasan_reset_tag((void *)ptr_addr)));
 #else
 	return ptr;
 #endif

