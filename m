Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16C4249BAD
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHSLZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:25:19 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:35023 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726710AbgHSLZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:25:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id BB9771941FBF;
        Wed, 19 Aug 2020 07:25:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xGw5rN
        Zvcv0dtToOIbc5ZC3Qo0FotPfaIi/J7Sls98M=; b=JSpEnlThRXM3WiWl9PibwY
        8TpU7cMPWDMrILG3U4d8JIdnQ65Wou7opsDZD7ybW73394q68hLwSC3dz7jsI0vT
        b0891J3sByVFci8Q8znxKfdy/6zxI6K2EvF9629QBObYhiLdcTIE221T4n3nD4Rp
        y34DVRqArTZ5mwEif1e8M4gk3THFwwugp98KAPTGqiIRwjt/gH2hdSkZQXItStKP
        WsxCQOiPv9k13rhdsMe8y0vfY26VLdleLX8FOnxq3ds5HTtpXnz74YbQbFSYXxeU
        MOOLylcQOgdZmuRXSkBUkHaRgPCQlH5BLt1NW/3RJzenDVLkQmgIHq4vfjK9/+Gg
        ==
X-ME-Sender: <xms:GAw9X-fDIYCymR4xcdOQQdwattX7e61o2H0HsPMrHnHIM7nshK_jQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptdevtefhjeffvdefuedvgfefueektddthffhtdegie
    ffvedvtdekffehueejfefhnecuffhomhgrihhnpehophgvnhhsuhhsvgdrohhrghenucfk
    phepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:GAw9X4MPTBeav5QzkuoQw3KeqagaF4QLjdzmjmmzLjW8dSmYbeZYIA>
    <xmx:GAw9X_ikdh8FjT2c8mueZCa5zmckj3POguVuWdjuER1BNoqt9Q5juA>
    <xmx:GAw9X795PmfYZOHsB3WpDNv7buPjRoUZ9BIcTb0fJmm9iO2qef-dEA>
    <xmx:GAw9Xw1p5sZ9E_W2oZSAr45302oQ7946or_8eMAOe-eiJiFU3Nbvtg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EFE63280064;
        Wed, 19 Aug 2020 07:25:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: return EROFS for BTRFS_FS_STATE_ERROR cases" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, esandeen@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:25:35 +0200
Message-ID: <159783633527237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From fbabd4a36faaf74c83142d0b3d950c11ec14fda1 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 21 Jul 2020 10:38:37 -0400
Subject: [PATCH] btrfs: return EROFS for BTRFS_FS_STATE_ERROR cases

Eric reported seeing this message while running generic/475

  BTRFS: error (device dm-3) in btrfs_sync_log:3084: errno=-117 Filesystem corrupted

Full stack trace:

  BTRFS: error (device dm-0) in btrfs_commit_transaction:2323: errno=-5 IO failure (Error while writing out transaction)
  BTRFS info (device dm-0): forced readonly
  BTRFS warning (device dm-0): Skipping commit of aborted transaction.
  ------------[ cut here ]------------
  BTRFS: error (device dm-0) in cleanup_transaction:1894: errno=-5 IO failure
  BTRFS: Transaction aborted (error -117)
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c6480 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c6488 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c6490 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c6498 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64a0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64a8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64b0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64b8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64c0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3572 rw 0,0 sector 0x1b85e8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3572 rw 0,0 sector 0x1b85f0 len 4096 err no 10
  WARNING: CPU: 3 PID: 23985 at fs/btrfs/tree-log.c:3084 btrfs_sync_log+0xbc8/0xd60 [btrfs]
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d4288 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d4290 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d4298 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42a0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42a8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42b0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42b8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42c0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42c8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42d0 len 4096 err no 10
  CPU: 3 PID: 23985 Comm: fsstress Tainted: G        W    L    5.8.0-rc4-default+ #1181
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
  RIP: 0010:btrfs_sync_log+0xbc8/0xd60 [btrfs]
  RSP: 0018:ffff909a44d17bd0 EFLAGS: 00010286
  RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
  RDX: ffff8f3be41cb940 RSI: ffffffffb0108d2b RDI: ffffffffb0108ff7
  RBP: ffff909a44d17e70 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000037988 R12: ffff8f3bd20e4000
  R13: ffff8f3bd20e4428 R14: 00000000ffffff8b R15: ffff909a44d17c70
  FS:  00007f6a6ed3fb80(0000) GS:ffff8f3c3dc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f6a6ed3e000 CR3: 00000000525c0003 CR4: 0000000000160ee0
  Call Trace:
   ? finish_wait+0x90/0x90
   ? __mutex_unlock_slowpath+0x45/0x2a0
   ? lock_acquire+0xa3/0x440
   ? lockref_put_or_lock+0x9/0x30
   ? dput+0x20/0x4a0
   ? dput+0x20/0x4a0
   ? do_raw_spin_unlock+0x4b/0xc0
   ? _raw_spin_unlock+0x1f/0x30
   btrfs_sync_file+0x335/0x490 [btrfs]
   do_fsync+0x38/0x70
   __x64_sys_fsync+0x10/0x20
   do_syscall_64+0x50/0xe0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f6a6ef1b6e3
  Code: Bad RIP value.
  RSP: 002b:00007ffd01e20038 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
  RAX: ffffffffffffffda RBX: 000000000007a120 RCX: 00007f6a6ef1b6e3
  RDX: 00007ffd01e1ffa0 RSI: 00007ffd01e1ffa0 RDI: 0000000000000003
  RBP: 0000000000000003 R08: 0000000000000001 R09: 00007ffd01e2004c
  R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000009f
  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  irq event stamp: 0
  hardirqs last  enabled at (0): [<0000000000000000>] 0x0
  hardirqs last disabled at (0): [<ffffffffb007fe0b>] copy_process+0x67b/0x1b00
  softirqs last  enabled at (0): [<ffffffffb007fe0b>] copy_process+0x67b/0x1b00
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  ---[ end trace af146e0e38433456 ]---
  BTRFS: error (device dm-0) in btrfs_sync_log:3084: errno=-117 Filesystem corrupted

This ret came from btrfs_write_marked_extents().  If we get an aborted
transaction via EIO before, we'll see it in btree_write_cache_pages()
and return EUCLEAN, which gets printed as "Filesystem corrupted".

Except we shouldn't be returning EUCLEAN here, we need to be returning
EROFS because EUCLEAN is reserved for actual corruption, not IO errors.

We are inconsistent about our handling of BTRFS_FS_STATE_ERROR
elsewhere, but we want to use EROFS for this particular case.  The
original transaction abort has the real error code for why we ended up
with an aborted transaction, all subsequent actions just need to return
EROFS because they may not have a trans handle and have no idea about
the original cause of the abort.

After patch "btrfs: don't WARN if we abort a transaction with EROFS" the
stacktrace will not be dumped either.

Reported-by: Eric Sandeen <esandeen@redhat.com>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add full test stacktrace ]
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 73c9c59cd535..3fbc37692592 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4119,7 +4119,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 	if (!test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
 		ret = flush_write_bio(&epd);
 	} else {
-		ret = -EUCLEAN;
+		ret = -EROFS;
 		end_write_bio(&epd, ret);
 	}
 	return ret;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d935ac06323f..5a6cb9db512e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3691,7 +3691,7 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
-		return -EIO;
+		return -EROFS;
 
 	/* Seed devices of a new filesystem has their own generation. */
 	if (scrub_dev->fs_devices != fs_info->fs_devices)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index efafc286323c..20c6ac1a5de7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -937,7 +937,10 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	if (TRANS_ABORTED(trans) ||
 	    test_bit(BTRFS_FS_STATE_ERROR, &info->fs_state)) {
 		wake_up_process(info->transaction_kthread);
-		err = -EIO;
+		if (TRANS_ABORTED(trans))
+			err = trans->aborted;
+		else
+			err = -EROFS;
 	}
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);

