Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F871FF55C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbgFROqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:46:42 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:41935 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731237AbgFROqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 10:46:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D31DC1943D47;
        Thu, 18 Jun 2020 10:46:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 10:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0mG2ZE
        HxrUIjQ+4OO1oYAt46JORuz8bLh/RIxeQWqOk=; b=E8Wp7zUqwRjDNRyQag0/VU
        w0Zru75grm7inFUC6aFTdyklW1c7H3Rr/LYSEc9hSM5oaqzITtSmL2pLdVYGp3lp
        WEbr+GONrdgWFXt6lv87vW7THufWiS44eD+S1mY/ZbLULgpf6EFTXPDfNR3DxXVm
        c6xwaUT/Eax3YJerL0D0mSdI6AS/M8RgKOMOnO8TTVzdRMvS6C59soRBw80xuW7F
        Vko9WFeBz6py0v1T1fSsuFK1H+4Lff1RFbdAfM9Yea2/mlFaOv/hjXXEXfaU1YHp
        2HpJWEHrTmCC2KOXgs3JIWIF/Tr1Kx70Wn7YI9r6nVejOdlDxmUXMotOasEG9Sbw
        ==
X-ME-Sender: <xms:S37rXtt0AGuKQbRJU2eUFAS4Zo3BlJkYzIE4WIBnkfrjRG5EUhw_Hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:S37rXmefCOR7uBt0kErj4VeEgnHyUKaOaPsS9_9T4zTGz1ISoqeVdw>
    <xmx:S37rXgzBNhOB0XpyIgKeQQ1MCwHjcE8fu2MO-KBa9M6suuqvRhzPuA>
    <xmx:S37rXkNmtAOGWQoh_RuXtB9KqM6TTI5XQ5VlQoJgwFk51Q9B6YWgzg>
    <xmx:S37rXvIquJGGlywnBy5XMh403bVZLnm62Vla1YZFakmcgv4rAHeVoQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F69F30618B7;
        Thu, 18 Jun 2020 10:46:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix error handling when submitting direct I/O bio" failed to apply to 4.9-stable tree
To:     osandov@fb.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        josef@toxicpanda.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 16:46:26 +0200
Message-ID: <159249158622574@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 

