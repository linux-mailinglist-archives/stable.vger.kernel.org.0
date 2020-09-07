Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F9125FE6D
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgIGQP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:15:56 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36829 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730500AbgIGQPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 12:15:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E5754C1A;
        Mon,  7 Sep 2020 12:15:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 07 Sep 2020 12:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=XfrIpr
        e+MHDsvqBiymUUYfnu1MLEyNy93040+psolW0=; b=ODpIcE9pXrMo3nGg3E450f
        9VXvFR99MHwpZgQkNmS+KI0A3dbNHPhljSYtLZhj7rr3EEkEK8ZN+ikJuqPzzyll
        2fYF3+RucJfZLpgQcJBhnO9awKQjU9uMwQ3OtbpoMSEymOM4Y+ZLXu7Ar3EnwtsN
        ybWSBSsFhWcRzjhDcws2SI8VtKMlID+B4KB1dwfOFRWvJC6IZLy5Wm7XHhW+CQn5
        N3fAVuX48IlyS8yxdci04RgbHMPbRN0Kuq4xDRV1rkqMiDJCT/mA7ZXqQjSXHlOE
        BJip/XDazTjZEZ7wHQg6oG3J2toIi1w++NsZkJWek7AP6Z1X/2dNSLy0haTbt4Sg
        ==
X-ME-Sender: <xms:tlxWX_udCz6nbBz0nYgqabquOuZYdwD_QMyv5oArDaRaDSIPdvwnVg>
    <xme:tlxWXwfiO3DeIEhk7AT6uw1NkkzNTIvM2JnF5v09Dn4HLQt3IGZuxgjy-a1bLXPA9
    O0pVxa_J8dqFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehtddgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:tlxWXyzfZf6zxK664prvynrkSM9HtaX1rSQRRQtP0OolCzsHG__-9A>
    <xmx:tlxWX-P5VAEUjF2Dnbnj9KbK49ts7uHdiXhIG2vaRF9bpie-jpEnxQ>
    <xmx:tlxWX_8bOF2Lx6M0oOAypXkVUQbQ4gTjxbCDzNQWfvJ_pWUGFV953A>
    <xmx:tlxWX5k-Tim-kdYqey3DIapkEmpp63A4HcgEmErTXGo-UZtAEcGh_7D3ZCY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC3833064674;
        Mon,  7 Sep 2020 12:15:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix potential deadlock in the search ioctl" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Sep 2020 18:16:03 +0200
Message-ID: <15994953632213@kroah.com>
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

From a48b73eca4ceb9b8a4b97f290a065335dbcd8a04 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 10 Aug 2020 11:42:27 -0400
Subject: [PATCH] btrfs: fix potential deadlock in the search ioctl

With the conversion of the tree locks to rwsem I got the following
lockdep splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.8.0-rc7-00165-g04ec4da5f45f-dirty #922 Not tainted
  ------------------------------------------------------
  compsize/11122 is trying to acquire lock:
  ffff889fabca8768 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0x3e/0x90

  but task is already holding lock:
  ffff889fe720fe40 (btrfs-fs-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x39/0x180

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (btrfs-fs-00){++++}-{3:3}:
	 down_write_nested+0x3b/0x70
	 __btrfs_tree_lock+0x24/0x120
	 btrfs_search_slot+0x756/0x990
	 btrfs_lookup_inode+0x3a/0xb4
	 __btrfs_update_delayed_inode+0x93/0x270
	 btrfs_async_run_delayed_root+0x168/0x230
	 btrfs_work_helper+0xd4/0x570
	 process_one_work+0x2ad/0x5f0
	 worker_thread+0x3a/0x3d0
	 kthread+0x133/0x150
	 ret_from_fork+0x1f/0x30

  -> #1 (&delayed_node->mutex){+.+.}-{3:3}:
	 __mutex_lock+0x9f/0x930
	 btrfs_delayed_update_inode+0x50/0x440
	 btrfs_update_inode+0x8a/0xf0
	 btrfs_dirty_inode+0x5b/0xd0
	 touch_atime+0xa1/0xd0
	 btrfs_file_mmap+0x3f/0x60
	 mmap_region+0x3a4/0x640
	 do_mmap+0x376/0x580
	 vm_mmap_pgoff+0xd5/0x120
	 ksys_mmap_pgoff+0x193/0x230
	 do_syscall_64+0x50/0x90
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (&mm->mmap_lock#2){++++}-{3:3}:
	 __lock_acquire+0x1272/0x2310
	 lock_acquire+0x9e/0x360
	 __might_fault+0x68/0x90
	 _copy_to_user+0x1e/0x80
	 copy_to_sk.isra.32+0x121/0x300
	 search_ioctl+0x106/0x200
	 btrfs_ioctl_tree_search_v2+0x7b/0xf0
	 btrfs_ioctl+0x106f/0x30a0
	 ksys_ioctl+0x83/0xc0
	 __x64_sys_ioctl+0x16/0x20
	 do_syscall_64+0x50/0x90
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  other info that might help us debug this:

  Chain exists of:
    &mm->mmap_lock#2 --> &delayed_node->mutex --> btrfs-fs-00

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(btrfs-fs-00);
				 lock(&delayed_node->mutex);
				 lock(btrfs-fs-00);
    lock(&mm->mmap_lock#2);

   *** DEADLOCK ***

  1 lock held by compsize/11122:
   #0: ffff889fe720fe40 (btrfs-fs-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x39/0x180

  stack backtrace:
  CPU: 17 PID: 11122 Comm: compsize Kdump: loaded Not tainted 5.8.0-rc7-00165-g04ec4da5f45f-dirty #922
  Hardware name: Quanta Tioga Pass Single Side 01-0030993006/Tioga Pass Single Side, BIOS F08_3A18 12/20/2018
  Call Trace:
   dump_stack+0x78/0xa0
   check_noncircular+0x165/0x180
   __lock_acquire+0x1272/0x2310
   lock_acquire+0x9e/0x360
   ? __might_fault+0x3e/0x90
   ? find_held_lock+0x72/0x90
   __might_fault+0x68/0x90
   ? __might_fault+0x3e/0x90
   _copy_to_user+0x1e/0x80
   copy_to_sk.isra.32+0x121/0x300
   ? btrfs_search_forward+0x2a6/0x360
   search_ioctl+0x106/0x200
   btrfs_ioctl_tree_search_v2+0x7b/0xf0
   btrfs_ioctl+0x106f/0x30a0
   ? __do_sys_newfstat+0x5a/0x70
   ? ksys_ioctl+0x83/0xc0
   ksys_ioctl+0x83/0xc0
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x50/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

The problem is we're doing a copy_to_user() while holding tree locks,
which can deadlock if we have to do a page fault for the copy_to_user().
This exists even without my locking changes, so it needs to be fixed.
Rework the search ioctl to do the pre-fault and then
copy_to_user_nofault for the copying.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 617ea38e6fd7..c15ab6c1897f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5653,9 +5653,9 @@ void read_extent_buffer(const struct extent_buffer *eb, void *dstv,
 	}
 }
 
-int read_extent_buffer_to_user(const struct extent_buffer *eb,
-			       void __user *dstv,
-			       unsigned long start, unsigned long len)
+int read_extent_buffer_to_user_nofault(const struct extent_buffer *eb,
+				       void __user *dstv,
+				       unsigned long start, unsigned long len)
 {
 	size_t cur;
 	size_t offset;
@@ -5675,7 +5675,7 @@ int read_extent_buffer_to_user(const struct extent_buffer *eb,
 
 		cur = min(len, (PAGE_SIZE - offset));
 		kaddr = page_address(page);
-		if (copy_to_user(dst, kaddr + offset, cur)) {
+		if (copy_to_user_nofault(dst, kaddr + offset, cur)) {
 			ret = -EFAULT;
 			break;
 		}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 00a88f2eb5ab..30794ae58498 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -241,9 +241,9 @@ int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 			unsigned long start,
 			unsigned long len);
-int read_extent_buffer_to_user(const struct extent_buffer *eb,
-			       void __user *dst, unsigned long start,
-			       unsigned long len);
+int read_extent_buffer_to_user_nofault(const struct extent_buffer *eb,
+				       void __user *dst, unsigned long start,
+				       unsigned long len);
 void write_extent_buffer_fsid(const struct extent_buffer *eb, const void *src);
 void write_extent_buffer_chunk_tree_uuid(const struct extent_buffer *eb,
 		const void *src);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bd3511c5ca81..ac45f022b495 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2086,9 +2086,14 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 		sh.len = item_len;
 		sh.transid = found_transid;
 
-		/* copy search result header */
-		if (copy_to_user(ubuf + *sk_offset, &sh, sizeof(sh))) {
-			ret = -EFAULT;
+		/*
+		 * Copy search result header. If we fault then loop again so we
+		 * can fault in the pages and -EFAULT there if there's a
+		 * problem. Otherwise we'll fault and then copy the buffer in
+		 * properly this next time through
+		 */
+		if (copy_to_user_nofault(ubuf + *sk_offset, &sh, sizeof(sh))) {
+			ret = 0;
 			goto out;
 		}
 
@@ -2096,10 +2101,14 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 
 		if (item_len) {
 			char __user *up = ubuf + *sk_offset;
-			/* copy the item */
-			if (read_extent_buffer_to_user(leaf, up,
-						       item_off, item_len)) {
-				ret = -EFAULT;
+			/*
+			 * Copy the item, same behavior as above, but reset the
+			 * * sk_offset so we copy the full thing again.
+			 */
+			if (read_extent_buffer_to_user_nofault(leaf, up,
+						item_off, item_len)) {
+				ret = 0;
+				*sk_offset -= sizeof(sh);
 				goto out;
 			}
 
@@ -2184,6 +2193,10 @@ static noinline int search_ioctl(struct inode *inode,
 	key.offset = sk->min_offset;
 
 	while (1) {
+		ret = fault_in_pages_writeable(ubuf, *buf_size - sk_offset);
+		if (ret)
+			break;
+
 		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
 		if (ret != 0) {
 			if (ret > 0)

