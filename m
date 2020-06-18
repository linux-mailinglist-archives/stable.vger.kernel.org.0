Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524D31FF58E
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbgFROrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:47:32 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39507 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731221AbgFROql (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 10:46:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D797C1943E0F;
        Thu, 18 Jun 2020 10:46:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 10:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=L5y8aZ
        a6KngGfQM1/2NrHerQPzzdJoTVIHwwfFcJ1as=; b=U1k7Cnjj4ELbs7wH1UZQgL
        TGLX+KoygctF4z4nOL3fby8iy1OX1vx7d5Fdx9kqB/xpIb2wJoI9JWgr/RTY5wyQ
        /IyoUtKEeuo80xdo8MLUiSZ+GwiwT7LUDR+fY8rQWjKSvpvLiuhTPf+6ELthAPdz
        TXrS/kfjoj7MFsqCBk4yQz1XmeMJx/ykNF+6GrnT7NTeT7wLNzHclvmM5n2CaTiP
        mwPkM0maV54/wG0uhQWVwJQiOBSylMDTCc/2Vjk41IknL6VUNzAf5NsEIx2CHUvF
        bOLMqN8V2ci387CdIwsp6JzUExK9zPtt8RGUVBzXEiyzqDTfnTl2AaTaK/3ddMlg
        ==
X-ME-Sender: <xms:TX7rXpw2Mh_51rK296B3lMmXUng3YRScui9-kh-PRmHIV4QZ_eZxHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:TX7rXpSEN01-bAy_MhzjORcYq2OXihHRwSOYU78hvl5R6ehtoSLK0g>
    <xmx:TX7rXjXDkEkTx36uTgqVKzSNwUFosx2mNSUJprMkUe1xN_X5ClGjag>
    <xmx:TX7rXrgnxJEpLzyYy5KJRS-e64xdTZlv_xXEP2VRYutzRRYU1BaYzg>
    <xmx:TX7rXuMQ4xbvWF5_UnU2a0OEtGkJo0COf-xfo3AObWByqhcQ_0c9JA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6ED193280060;
        Thu, 18 Jun 2020 10:46:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix error handling when submitting direct I/O bio" failed to apply to 4.4-stable tree
To:     osandov@fb.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        josef@toxicpanda.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 16:46:27 +0200
Message-ID: <1592491587156144@kroah.com>
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

From 6d3113a193e3385c72240096fe397618ecab6e43 Mon Sep 17 00:00:00 2001
From: Omar Sandoval <osandov@fb.com>
Date: Thu, 16 Apr 2020 14:46:12 -0700
Subject: [PATCH] btrfs: fix error handling when submitting direct I/O bio

In btrfs_submit_direct_hook(), if a direct I/O write doesn't span a RAID
stripe or chunk, we submit orig_bio without cloning it. In this case, we
don't increment pending_bios. Then, if btrfs_submit_dio_bio() fails, we
decrement pending_bios to -1, and we never complete orig_bio. Fix it by
initializing pending_bios to 1 instead of incrementing later.

Fixing this exposes another bug: we put orig_bio prematurely and then
put it again from end_io. Fix it by not putting orig_bio.

After this change, pending_bios is really more of a reference count, but
I'll leave that cleanup separate to keep the fix small.

Fixes: e65e15355429 ("btrfs: fix panic caused by direct IO")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 259239b33370..b628c319a5b6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7939,7 +7939,6 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 
 	/* bio split */
 	ASSERT(geom.len <= INT_MAX);
-	atomic_inc(&dip->pending_bios);
 	do {
 		clone_len = min_t(int, submit_len, geom.len);
 
@@ -7989,7 +7988,8 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 	if (!status)
 		return 0;
 
-	bio_put(bio);
+	if (bio != orig_bio)
+		bio_put(bio);
 out_err:
 	dip->errors = 1;
 	/*
@@ -8030,7 +8030,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	bio->bi_private = dip;
 	dip->orig_bio = bio;
 	dip->dio_bio = dio_bio;
-	atomic_set(&dip->pending_bios, 0);
+	atomic_set(&dip->pending_bios, 1);
 	io_bio = btrfs_io_bio(bio);
 	io_bio->logical = file_offset;
 

