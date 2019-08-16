Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B4F8FFA2
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 12:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfHPKC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 06:02:59 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38955 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727009AbfHPKC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 06:02:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 92E08176B;
        Fri, 16 Aug 2019 06:02:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 16 Aug 2019 06:02:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KfA1fV
        VELloV9WDvDHJpoYBwcXyUG7woDLfz8sPcR0w=; b=ilKncMDQIlVwZ5etcjiSGq
        KZu5MBYEUKMy39HlH/eW4/+hk6zx6zb07HzU2xUwDk8e+HCPhzNyshLLsSBr66t1
        +olBMVz41/4FwwSenc0zhaza829inkinvMbGnqOvvJBvGt7VSaDOeVwGzqJBbE0l
        f8dHMNobeGUf2c4Vay/7GP9QHCOkVtfUSaX3J/aURc3pZ4hI3nv7lQAb1wPlUsS1
        7+K9WaWo0DZY7pZFPkew4+hrmhseT2mSaaVHbngFPdfbE11hzb8u7usUsCH53PEm
        1Hca0Vr9kt0UX0HXd1SYppYbFs3pWPqzicgAO2uSHlxpyI50ktJz3TCrTSSrfURw
        ==
X-ME-Sender: <xms:T39WXSbWTN9iP-jAUBtgF_6TFM6IbTqz3S_UvBY09ZJsN1arxLZ2Ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeffedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:UH9WXWG5HKoiKmXFiukjQ4RQ_Qzbj5M7hN-47E8HmyDoGGtcsILfBg>
    <xmx:UH9WXRfmBKN_vgQDbDChKJm-_HNF1KsedNdSH6J_TExa9F4rWesNRA>
    <xmx:UH9WXVIrVfHlbYA_gBgcg0eIomKzQqeu9Cntk4SIy0ZrZSg38F4Zlw>
    <xmx:UX9WXYnYCAozoQ043CjfYrk2-pFKagPqDFATH3og_qtStSyY88j0rg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 90F8580062;
        Fri, 16 Aug 2019 06:02:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/z3fold.c: fix z3fold_destroy_pool() ordering" failed to apply to 4.19-stable tree
To:     henryburns@google.com, akpm@linux-foundation.org,
        dhowells@redhat.com, henrywolfeburns@gmail.com, jwadams@google.com,
        shakeelb@google.com, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        vitaly.vul@sony.com, vitalywool@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 16 Aug 2019 12:02:54 +0200
Message-ID: <1565949774144187@kroah.com>
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

From 6051d3bd3b91e96c59e62b8be2dba1cc2b19ee40 Mon Sep 17 00:00:00 2001
From: Henry Burns <henryburns@google.com>
Date: Tue, 13 Aug 2019 15:37:21 -0700
Subject: [PATCH] mm/z3fold.c: fix z3fold_destroy_pool() ordering

The constraint from the zpool use of z3fold_destroy_pool() is there are
no outstanding handles to memory (so no active allocations), but it is
possible for there to be outstanding work on either of the two wqs in
the pool.

If there is work queued on pool->compact_workqueue when it is called,
z3fold_destroy_pool() will do:

   z3fold_destroy_pool()
     destroy_workqueue(pool->release_wq)
     destroy_workqueue(pool->compact_wq)
       drain_workqueue(pool->compact_wq)
         do_compact_page(zhdr)
           kref_put(&zhdr->refcount)
             __release_z3fold_page(zhdr, ...)
               queue_work_on(pool->release_wq, &pool->work) *BOOM*

So compact_wq needs to be destroyed before release_wq.

Link: http://lkml.kernel.org/r/20190726224810.79660-1-henryburns@google.com
Fixes: 5d03a6613957 ("mm/z3fold.c: use kref to prevent page free/compact race")
Signed-off-by: Henry Burns <henryburns@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Jonathan Adams <jwadams@google.com>
Cc: Vitaly Vul <vitaly.vul@sony.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/z3fold.c b/mm/z3fold.c
index 1a029a7432ee..43de92f52961 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -818,8 +818,15 @@ static void z3fold_destroy_pool(struct z3fold_pool *pool)
 {
 	kmem_cache_destroy(pool->c_handle);
 	z3fold_unregister_migration(pool);
-	destroy_workqueue(pool->release_wq);
+
+	/*
+	 * We need to destroy pool->compact_wq before pool->release_wq,
+	 * as any pending work on pool->compact_wq will call
+	 * queue_work(pool->release_wq, &pool->work).
+	 */
+
 	destroy_workqueue(pool->compact_wq);
+	destroy_workqueue(pool->release_wq);
 	kfree(pool);
 }
 

