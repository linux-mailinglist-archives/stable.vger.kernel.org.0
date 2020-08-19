Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A32249B6C
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHSLOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:14:25 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:40443 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726710AbgHSLOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:14:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 303171942747;
        Wed, 19 Aug 2020 07:14:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pmLqwf
        qJ/6SzS9SAO3F/87ImkfJAUyhBb9QTRXIfvL8=; b=dU92fHYj0eHu9Lsl1unkyf
        3M3XuPcu+6y4vW6tPiXJWEi+cs1L1Qh/7sPgojAixBIgdULWKPaV75LmGsndxLug
        r+NTTFHxRKtwfYfH/gVT54jJyW3S1cNIZpM36TPOwiCsj1Um2XI55tP+iXTI2O7/
        lTa4u16Uhnuq2KLEb3XNwey6OeZpZlV0n1WhmIPIlX7ksXX/exIFkkKP+tGBn/F4
        8+bbDrmNnXGl2pcnJIV6HoqvcJTQmd0yIMiuVNElsX/kn3Dju9wzRWGwQr5F2glT
        rNSgr4AnlmC1ahNS5wA+WPmTT/GjJ/FlSoY994qQ2mznoOCnfm44DW515CtPrCxQ
        ==
X-ME-Sender: <xms:jgk9XzZaGzUmVn0iCdlQ_HkwPmIw-phmGIC8kGpayhhkf043BiSP5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:jgk9XyYJcHX_37Uq-348GCPrstbN73vL5rDSdWo-UHhZ_X3_yrV17A>
    <xmx:jgk9X19hVAMMQwEGHUmd-HexgbYGOAQ3C_axidqXv8EWkkZxJVpBbw>
    <xmx:jgk9X5o74KQWyobFAjZOz18saL3prQjSFQNIcUds4aRlBuvUjmFe-Q>
    <xmx:jwk9XzBgheRY2iltpTl3nX7JzeRuJaFcho01GgbFXJbJJROYfJTs7A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4318930600A9;
        Wed, 19 Aug 2020 07:14:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: don't allocate anonymous block device for user" failed to apply to 4.4-stable tree
To:     wqu@suse.com, dsterba@suse.com, greedrong@gmail.com,
        josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:14:45 +0200
Message-ID: <1597835685194255@kroah.com>
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

From 851fd730a743e072badaf67caf39883e32439431 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Tue, 16 Jun 2020 10:17:34 +0800
Subject: [PATCH] btrfs: don't allocate anonymous block device for user
 invisible roots

[BUG]
When a lot of subvolumes are created, there is a user report about
transaction aborted:

  BTRFS: Transaction aborted (error -24)
  WARNING: CPU: 17 PID: 17041 at fs/btrfs/transaction.c:1576 create_pending_snapshot+0xbc4/0xd10 [btrfs]
  RIP: 0010:create_pending_snapshot+0xbc4/0xd10 [btrfs]
  Call Trace:
   create_pending_snapshots+0x82/0xa0 [btrfs]
   btrfs_commit_transaction+0x275/0x8c0 [btrfs]
   btrfs_mksubvol+0x4b9/0x500 [btrfs]
   btrfs_ioctl_snap_create_transid+0x174/0x180 [btrfs]
   btrfs_ioctl_snap_create_v2+0x11c/0x180 [btrfs]
   btrfs_ioctl+0x11a4/0x2da0 [btrfs]
   do_vfs_ioctl+0xa9/0x640
   ksys_ioctl+0x67/0x90
   __x64_sys_ioctl+0x1a/0x20
   do_syscall_64+0x5a/0x110
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  ---[ end trace 33f2f83f3d5250e9 ]---
  BTRFS: error (device sda1) in create_pending_snapshot:1576: errno=-24 unknown
  BTRFS info (device sda1): forced readonly
  BTRFS warning (device sda1): Skipping commit of aborted transaction.
  BTRFS: error (device sda1) in cleanup_transaction:1831: errno=-24 unknown

[CAUSE]
The error is EMFILE (Too many files open) and comes from the anonymous
block device allocation. The ids are in a shared pool of size 1<<20.

The ids are assigned to live subvolumes, ie. the root structure exists
in memory (eg. after creation or after the root appears in some path).
The pool could be exhausted if the numbers are not reclaimed fast
enough, after subvolume deletion or if other system component uses the
anon block devices.

[WORKAROUND]
Since it's not possible to completely solve the problem, we can only
minimize the time the id is allocated to a subvolume root.

Firstly, we can reduce the use of anon_dev by trees that are not
subvolume roots, like data reloc tree.

This patch will do extra check on root objectid, to skip roots that
don't need anon_dev.  Currently it's only data reloc tree and orphan
roots.

Reported-by: Greed Rong <greedrong@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CA+UqX+NTrZ6boGnWHhSeZmEY5J76CTqmYjO2S+=tHJX7nb9DPw@mail.gmail.com/
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dbf90cd49513..c90edf04a9db 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1424,9 +1424,16 @@ static int btrfs_init_fs_root(struct btrfs_root *root)
 	spin_lock_init(&root->ino_cache_lock);
 	init_waitqueue_head(&root->ino_cache_wait);
 
-	ret = get_anon_bdev(&root->anon_dev);
-	if (ret)
-		goto fail;
+	/*
+	 * Don't assign anonymous block device to roots that are not exposed to
+	 * userspace, the id pool is limited to 1M
+	 */
+	if (is_fstree(root->root_key.objectid) &&
+	    btrfs_root_refs(&root->root_item) > 0) {
+		ret = get_anon_bdev(&root->anon_dev);
+		if (ret)
+			goto fail;
+	}
 
 	mutex_lock(&root->objectid_mutex);
 	ret = btrfs_find_highest_objectid(root,

