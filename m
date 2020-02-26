Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371B616FCAF
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 11:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgBZK4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 05:56:17 -0500
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:36989 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726408AbgBZK4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 05:56:16 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2020 05:56:16 EST
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 1C9916EF;
        Wed, 26 Feb 2020 05:50:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 05:50:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=liscf2
        AgnAP4WeuGtNroeRo0qkTKZOFXGwE4JfrPDbs=; b=a/rfhZdJjBpG/gP3iR/ijo
        kEaAyjkiSY2HF1CTvv2z2TjIsgPP7wZHuoZTbxJHB1G0X3VAZXP7HuZFuyMgN3Y5
        CapIlijPEPUKgaDvG0z1P946I+NlBTKVsCCAVKoW2vc00iCDdlgCBZhEh4WelDol
        gSlGM4ajkrnFlSBnDoLrBpx8sj331KAA67L4h/UUqFHUlIRn15ylm8fDsElfuptl
        lEb7eB4eXMvrEuA3JM+vXZxTQE8sjoTAfgDknbn3TlwC70S1k0toUolA9vGAJmVz
        joIAQayVJ20wrjuzNwqgWBoE+yeRZYbkIiYqkLEvgWxJEL2AuioQfb4VgcYSQ+jQ
        ==
X-ME-Sender: <xms:iE1WXukIvkcnGW_CNqYqnbw_DJ28gi6Tx5K5Lqhm26IA9OhA1nCElA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iE1WXr-QfNbuGAHvr8cyNIIWy_Tk-xy6Ggj7lNbkZ2OEM3SGSKnxAQ>
    <xmx:iE1WXjlgS7ftbS5LCCr_VJdN9b6IW8qgRTxmKGke37WnNd8pO3gmng>
    <xmx:iE1WXpurPbU41h-cY4S76z4XWxEIlGcF05FErjlwZQQ_NrS1Szb-Eg>
    <xmx:iE1WXmPnrSljnw1HIw8AmybWZLjrji-QADzM2rjUKQQ-yYBw3fJl6dzoAnc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41163328005A;
        Wed, 26 Feb 2020 05:50:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] lib/stackdepot.c: fix global out-of-bounds in stack_slabs" failed to apply to 4.14-stable tree
To:     glider@google.com, akpm@linux-foundation.org, dvyukov@google.com,
        gregkh@linuxfoundation.org, jpoimboe@redhat.com,
        kstewart@linuxfoundation.org, matthias.bgg@gmail.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 11:49:43 +0100
Message-ID: <1582714183119146@kroah.com>
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

From 305e519ce48e935702c32241f07d393c3c8fed3e Mon Sep 17 00:00:00 2001
From: Alexander Potapenko <glider@google.com>
Date: Thu, 20 Feb 2020 20:04:30 -0800
Subject: [PATCH] lib/stackdepot.c: fix global out-of-bounds in stack_slabs

Walter Wu has reported a potential case in which init_stack_slab() is
called after stack_slabs[STACK_ALLOC_MAX_SLABS - 1] has already been
initialized.  In that case init_stack_slab() will overwrite
stack_slabs[STACK_ALLOC_MAX_SLABS], which may result in a memory
corruption.

Link: http://lkml.kernel.org/r/20200218102950.260263-1-glider@google.com
Fixes: cd11016e5f521 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index ed717dd08ff3..81c69c08d1d1 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -83,15 +83,19 @@ static bool init_stack_slab(void **prealloc)
 		return true;
 	if (stack_slabs[depot_index] == NULL) {
 		stack_slabs[depot_index] = *prealloc;
+		*prealloc = NULL;
 	} else {
-		stack_slabs[depot_index + 1] = *prealloc;
+		/* If this is the last depot slab, do not touch the next one. */
+		if (depot_index + 1 < STACK_ALLOC_MAX_SLABS) {
+			stack_slabs[depot_index + 1] = *prealloc;
+			*prealloc = NULL;
+		}
 		/*
 		 * This smp_store_release pairs with smp_load_acquire() from
 		 * |next_slab_inited| above and in stack_depot_save().
 		 */
 		smp_store_release(&next_slab_inited, 1);
 	}
-	*prealloc = NULL;
 	return true;
 }
 

