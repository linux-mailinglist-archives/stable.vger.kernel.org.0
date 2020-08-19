Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BFC249BE6
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgHSLfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:35:32 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:38845 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgHSLfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:35:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 565FD1941DB2;
        Wed, 19 Aug 2020 07:35:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rsHK2O
        fRkw9QN1jv4zc5mWJEyKeaTLBeFqSzrEGCPFA=; b=N1s7D6EvvVoKTtSAIUwnKE
        iw9/XVXZHPLfHVph2DNhLBDt/ZcR98W8xdKFIB8kaPSIsAV2e1ae0ZbSCcRmuu/Q
        9jK1G4sltfg5dLSSROZaYH145UdWm8oNjsDtV42ZwLQVg2/xls7TWlDRatSX/hFh
        KfmPiESsKj2vviJHMAUFnp1iSeqm7PWdJEedhiJG+sahHEmk1J1UDAAT9tHyNGDa
        rH95CodT79TXXogjab72l8XJ5NpJJztY//nzKBAEYIlIJ35/IOx/qtFYvi+qoOxR
        fSXFP7DuD4KD/bkbwga+ViDMV3we80kCC1KyJtjJNHcGWvmcdV2yP4Gk3Gdp2N8A
        ==
X-ME-Sender: <xms:gQ49X8Q9tkg57AiKCvr8gdryGX3s_Xzg2f9nj5eSMkoSSRrTsVjpkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:gQ49X5yAvOEJ3RhRKcvRfRauW84CcDCzg0gfw2vfaXo8MmbfUkJSwg>
    <xmx:gQ49X51C_0d_YGXI6vCWutrniUCwvuZeKRkS5lxTe7s8NM07IsBU6Q>
    <xmx:gQ49XwDXJ9FylPoW9ds71cJd6oSelgJr7L0t2yLhiExJfseKZW7MhQ>
    <xmx:gQ49X1I2RR5Lqm6cE0H1j0c51Cp0pZ7bPBY_OSosQwnrK4d9XoPZKQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2FEA3280066;
        Wed, 19 Aug 2020 07:35:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: inode: fix NULL pointer dereference if inode doesn't" failed to apply to 4.19-stable tree
To:     wqu@suse.com, chavez@us.ibm.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:35:51 +0200
Message-ID: <1597836951172147@kroah.com>
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

From 1e6e238c3002ea3611465ce5f32777ddd6a40126 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Tue, 28 Jul 2020 16:39:26 +0800
Subject: [PATCH] btrfs: inode: fix NULL pointer dereference if inode doesn't
 need compression

[BUG]
There is a bug report of NULL pointer dereference caused in
compress_file_extent():

  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  Workqueue: btrfs-delalloc btrfs_delalloc_helper [btrfs]
  NIP [c008000006dd4d34] compress_file_range.constprop.41+0x75c/0x8a0 [btrfs]
  LR [c008000006dd4d1c] compress_file_range.constprop.41+0x744/0x8a0 [btrfs]
  Call Trace:
  [c000000c69093b00] [c008000006dd4d1c] compress_file_range.constprop.41+0x744/0x8a0 [btrfs] (unreliable)
  [c000000c69093bd0] [c008000006dd4ebc] async_cow_start+0x44/0xa0 [btrfs]
  [c000000c69093c10] [c008000006e14824] normal_work_helper+0xdc/0x598 [btrfs]
  [c000000c69093c80] [c0000000001608c0] process_one_work+0x2c0/0x5b0
  [c000000c69093d10] [c000000000160c38] worker_thread+0x88/0x660
  [c000000c69093db0] [c00000000016b55c] kthread+0x1ac/0x1c0
  [c000000c69093e20] [c00000000000b660] ret_from_kernel_thread+0x5c/0x7c
  ---[ end trace f16954aa20d822f6 ]---

[CAUSE]
For the following execution route of compress_file_range(), it's
possible to hit NULL pointer dereference:

 compress_file_extent()
 |- pages = NULL;
 |- start = async_chunk->start = 0;
 |- end = async_chunk = 4095;
 |- nr_pages = 1;
 |- inode_need_compress() == false; <<< Possible, see later explanation
 |  Now, we have nr_pages = 1, pages = NULL
 |- cont:
 |- 		ret = cow_file_range_inline();
 |- 		if (ret <= 0) {
 |-		for (i = 0; i < nr_pages; i++) {
 |-			WARN_ON(pages[i]->mapping);	<<< Crash

To enter above call execution branch, we need the following race:

    Thread 1 (chattr)     |            Thread 2 (writeback)
--------------------------+------------------------------
                          | btrfs_run_delalloc_range
                          | |- inode_need_compress = true
                          | |- cow_file_range_async()
btrfs_ioctl_set_flag()    |
|- binode_flags |=        |
   BTRFS_INODE_NOCOMPRESS |
                          | compress_file_range()
                          | |- inode_need_compress = false
                          | |- nr_page = 1 while pages = NULL
                          | |  Then hit the crash

[FIX]
This patch will fix it by checking @pages before doing accessing it.
This patch is only designed as a hot fix and easy to backport.

More elegant fix may make btrfs only check inode_need_compress() once to
avoid such race, but that would be another story.

Reported-by: Luciano Chavez <chavez@us.ibm.com>
Fixes: 4d3a800ebb12 ("btrfs: merge nr_pages input and output parameter in compress_pages")
CC: stable@vger.kernel.org # 4.14.x: cecc8d9038d16: btrfs: Move free_pages_out label in inline extent handling branch in compress_file_range
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 611b3412fbfd..9988d754e465 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -653,12 +653,18 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 						     page_error_op |
 						     PAGE_END_WRITEBACK);
 
-			for (i = 0; i < nr_pages; i++) {
-				WARN_ON(pages[i]->mapping);
-				put_page(pages[i]);
+			/*
+			 * Ensure we only free the compressed pages if we have
+			 * them allocated, as we can still reach here with
+			 * inode_need_compress() == false.
+			 */
+			if (pages) {
+				for (i = 0; i < nr_pages; i++) {
+					WARN_ON(pages[i]->mapping);
+					put_page(pages[i]);
+				}
+				kfree(pages);
 			}
-			kfree(pages);
-
 			return 0;
 		}
 	}

