Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407B11A4355
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 10:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgDJIJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 04:09:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33485 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgDJIJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 04:09:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 618AA5C01E3;
        Fri, 10 Apr 2020 04:09:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 10 Apr 2020 04:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cBRM6a
        DxuPfefsCLUHT7XdhR1EZyx6MW54sOflHPOKM=; b=NUziR4cGZkgoNe+xEEUBTk
        TTGpN8elL15RrgRQ7I0eIU7zu4tccCax2ZP5SnelpUs+y6+LdJbzVzMLWxtsxqlz
        9aXwhKg7qT8jZCvYJpVBUgH/NCNyAoHy+8gseOhqze8D/2cWTravIRZrdC1wsCgn
        x/ZUFBZUA1drMfOQVFYQ9pKpQ2LjfmQ3mqfg4wUwvfYxGn7nP6FnHk80g8B8Lofl
        AM3+HWCBJg7l2U7LMsmYfyurk7kwiAfpzwJ6pEi3pZP+FjzpgmCzwGP1VI4wGiiA
        xqMVfgdIHaIK88A9vpukov8R1irY9/ac9QxiZMQ88j+BmZHf1FuTmZej4GdQpVmQ
        ==
X-ME-Sender: <xms:qSmQXmt3EpyXmnrQC-dAwuPVsHPVUrWJQM9AuCOQnjJqN1LjXmXwIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvddvgddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepihhnfhhoshgvtghttggsrhdrtghomhdrrghupdhkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgep
    udenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:qSmQXvvv74zcIvypd8YDYIemBDMFepy4h63vxV_d0oRs6-H7F2V5Vw>
    <xmx:qSmQXsyc0zq6OYp9RtPnbTOVMNQuflIFXcKdTCKXldQzDBPxftpVxw>
    <xmx:qSmQXlgUCK6MChPcX6zq8UmP0WCzrxrpT_0dmu8dGdC2NXpSF7kwjQ>
    <xmx:qSmQXvmTNO4Ml1WouXqtQoqGh8u4tNeEw7hhd2cLc0cDOPFjRU_h5A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF73B328005E;
        Fri, 10 Apr 2020 04:09:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] slub: improve bit diffusion for freelist ptr obfuscation" failed to apply to 4.14-stable tree
To:     keescook@chromium.org, akpm@linux-foundation.org, cl@linux.com,
        iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com,
        silvio.cesare@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Apr 2020 10:09:03 +0200
Message-ID: <158650614326180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

