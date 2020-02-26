Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF44B16FCB1
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 11:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgBZK4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 05:56:17 -0500
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:38825 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728014AbgBZK4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 05:56:17 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 542CA6A3;
        Wed, 26 Feb 2020 05:50:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 05:50:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rBRkzD
        WBnCODPnMWTB8M3O7i6dJLlH18o6I0sr/I52E=; b=cPacFVjh2chsAZDjX61g9L
        gYxvt1zNlSYWumttpFv9PD4hrodRvjcch4E5Zj/q9xR8msl69PHKyKH+Eqh4fCbB
        Fp2vRbli641B+TXcHJvnOusCMP9dCsGLCkOxeVr3/Dhke6/G7nMszRn7dZz9M/ry
        3+ZXlK2gQ3ViYHyIFBGsCGXVBuO35JJWlXTJhltAV5mVKJY8TynwCYfQvysDqwDD
        GQlPXyx2qnTBcDDo0SFlMonG5tLex7NKbFP10tFPy2SkfotCBnCkqo9v6y4oq1eC
        WokfvrUXyJCFsA2AiY0DfxqzWLu8xwbaHYvpAEBaFYEe2sxI11wk8S33kuF4i+gg
        ==
X-ME-Sender: <xms:hU1WXk_GmVaPyFrJ0ehlgnNG4dy8_6VdkNwcHulVBGOgk2xGSdxoNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:hU1WXv0X2kWMowmxjt6yKqB664O0HHdr48RneOmSQon3Pb1eekLgiA>
    <xmx:hU1WXhxDC-PR22kY9rvoZKQvzY7YmGE4dT7abFtQfwoiDERW6BHhlA>
    <xmx:hU1WXneyYj9CyVPaiCMaBj11mi6j5G3ZSsNTRJv1zrF8-Ji2CNoBIw>
    <xmx:hU1WXi5GaV4h5qeMb_bMQ_TfJ7aQdq5G5ndpU0x6jyRFcPM3uJ8ZUcXqMGE>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0491B328005E;
        Wed, 26 Feb 2020 05:50:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] lib/stackdepot.c: fix global out-of-bounds in stack_slabs" failed to apply to 4.19-stable tree
To:     glider@google.com, akpm@linux-foundation.org, dvyukov@google.com,
        gregkh@linuxfoundation.org, jpoimboe@redhat.com,
        kstewart@linuxfoundation.org, matthias.bgg@gmail.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 11:49:42 +0100
Message-ID: <1582714182242120@kroah.com>
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
 

