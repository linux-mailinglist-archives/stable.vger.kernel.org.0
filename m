Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66582E3552
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgL1JLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:11:15 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:39185 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1JLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:11:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E466D78C;
        Mon, 28 Dec 2020 04:10:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:10:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hlgom9
        brtbFUUJf3i8LjzNCB9NhUi4lbCs9tJkAhXxo=; b=eChuTPLMXzBAX2B1397qYH
        e95I4fJWyAOe4RxZ/3orHM+vTFc6xTix4pMKJUhkaDbuUXvK0t20UiJFpDfjWWGF
        W/2w08I9yVlJBAijDPv1DOLcIBzL84zomrVfAtnr6XOczUXhr27yE+gGcXzdTYQ+
        ZGQyER3X+KmTcZmkF37HxsZKAD/yUBxfuA7CnI/fd1wd3Wzi1lY3zd33gX0k+DFI
        duHg6mvE0io0UvbyUq2IF/BRKcHFMHFo0okmF5R91Xfh/H0y8jXFWsDvhYCgESpd
        AVk58lNPc3+E2AZmuVAbhULMUFw0HHrm2f2JGv7bjB3VLvhkRt4t943fC7vz9rkQ
        ==
X-ME-Sender: <xms:BKHpX2Aj-hKA_t0Uy_lMIHQd3hpeH6rkbbjaO23bz1MO7Q8fp7HpUg>
    <xme:BKHpXwhsv_T4JdH4RBmM6MzYekMJ2FfuLkbFz-V3hDYpRLrjpT05zzjBN5JNhPJ_A
    hfl87vU-GXFcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieffvdduffdvhfefffeuvedugfevhfeuiefghedvvd
    ekgfefuddtudehvedtteffnecuffhomhgrihhnpehgnhhurdhorhhgnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BKHpX5mHUK-mGXI_9shhxrKzFAPxCBTDz1qLJQ-4OBLw0pNQ_XgFvg>
    <xmx:BKHpX0yeDPN3vnOuvpk98mvxxHflvcEFa6Xt5y0cGuZpf0dfoU8XhA>
    <xmx:BKHpX7Ry6-R-D9knatYiW6h7RNgZvxmZC6eOy34XfJgkRfDhIXV6rA>
    <xmx:BKHpXyKnRFsnViRzWEm0oE_Z5tNLZGjJm_c30m66EVAp5aTRUXEUBd-CfaU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1392A24005D;
        Mon, 28 Dec 2020 04:10:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: update the number of bytes used by an inode atomically" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:11:51 +0100
Message-ID: <1609146711225144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 2766ff61762c3fa19bf30bc0ff72ea5306229f09 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 4 Nov 2020 11:07:34 +0000
Subject: [PATCH] btrfs: update the number of bytes used by an inode atomically

There are several occasions where we do not update the inode's number of
used bytes atomically, resulting in a concurrent stat(2) syscall to report
a value of used blocks that does not correspond to a valid value, that is,
a value that does not match neither what we had before the operation nor
what we get after the operation completes.

In extreme cases it can result in stat(2) reporting zero used blocks, which
can cause problems for some userspace tools where they can consider a file
with a non-zero size and zero used blocks as completely sparse and skip
reading data, as reported/discussed a long time ago in some threads like
the following:

  https://lists.gnu.org/archive/html/bug-tar/2016-07/msg00001.html

The cases where this can happen are the following:

-> Case 1

If we do a write (buffered or direct IO) against a file region for which
there is already an allocated extent (or multiple extents), then we have a
short time window where we can report a number of used blocks to stat(2)
that does not take into account the file region being overwritten. This
short time window happens when completing the ordered extent(s).

This happens because when we drop the extents in the write range we
decrement the inode's number of bytes and later on when we insert the new
extent(s) we increment the number of bytes in the inode, resulting in a
short time window where a stat(2) syscall can get an incorrect number of
used blocks.

If we do writes that overwrite an entire file, then we have a short time
window where we report 0 used blocks to stat(2).

Example reproducer:

  $ cat reproducer-1.sh
  #!/bin/bash

  MNT=/mnt/sdi
  DEV=/dev/sdi

  stat_loop()
  {
      trap "wait; exit" SIGTERM
      local filepath=$1
      local expected=$2
      local got

      while :; do
          got=$(stat -c %b $filepath)
          if [ $got -ne $expected ]; then
             echo -n "ERROR: unexpected used blocks"
             echo " (got: $got expected: $expected)"
          fi
      done
  }

  mkfs.btrfs -f $DEV > /dev/null
  # mkfs.xfs -f $DEV > /dev/null
  # mkfs.ext4 -F $DEV > /dev/null
  # mkfs.f2fs -f $DEV > /dev/null
  # mkfs.reiserfs -f $DEV > /dev/null
  mount $DEV $MNT

  xfs_io -f -s -c "pwrite -b 64K 0 64K" $MNT/foobar >/dev/null
  expected=$(stat -c %b $MNT/foobar)

  # Create a process to keep calling stat(2) on the file and see if the
  # reported number of blocks used (disk space used) changes, it should
  # not because we are not increasing the file size nor punching holes.
  stat_loop $MNT/foobar $expected &
  loop_pid=$!

  for ((i = 0; i < 50000; i++)); do
      xfs_io -s -c "pwrite -b 64K 0 64K" $MNT/foobar >/dev/null
  done

  kill $loop_pid &> /dev/null
  wait

  umount $DEV

  $ ./reproducer-1.sh
  ERROR: unexpected used blocks (got: 0 expected: 128)
  ERROR: unexpected used blocks (got: 0 expected: 128)
  (...)

Note that since this is a short time window where the race can happen, the
reproducer may not be able to always trigger the bug in one run, or it may
trigger it multiple times.

-> Case 2

If we do a buffered write against a file region that does not have any
allocated extents, like a hole or beyond EOF, then during ordered extent
completion we have a short time window where a concurrent stat(2) syscall
can report a number of used blocks that does not correspond to the value
before or after the write operation, a value that is actually larger than
the value after the write completes.

This happens because once we start a buffered write into an unallocated
file range we increment the inode's 'new_delalloc_bytes', to make sure
any stat(2) call gets a correct used blocks value before delalloc is
flushed and completes. However at ordered extent completion, after we
inserted the new extent, we increment the inode's number of bytes used
with the size of the new extent, and only later, when clearing the range
in the inode's iotree, we decrement the inode's 'new_delalloc_bytes'
counter with the size of the extent. So this results in a short time
window where a concurrent stat(2) syscall can report a number of used
blocks that accounts for the new extent twice.

Example reproducer:

  $ cat reproducer-2.sh
  #!/bin/bash

  MNT=/mnt/sdi
  DEV=/dev/sdi

  stat_loop()
  {
      trap "wait; exit" SIGTERM
      local filepath=$1
      local expected=$2
      local got

      while :; do
          got=$(stat -c %b $filepath)
          if [ $got -ne $expected ]; then
              echo -n "ERROR: unexpected used blocks"
              echo " (got: $got expected: $expected)"
          fi
      done
  }

  mkfs.btrfs -f $DEV > /dev/null
  # mkfs.xfs -f $DEV > /dev/null
  # mkfs.ext4 -F $DEV > /dev/null
  # mkfs.f2fs -f $DEV > /dev/null
  # mkfs.reiserfs -f $DEV > /dev/null
  mount $DEV $MNT

  touch $MNT/foobar
  write_size=$((64 * 1024))
  for ((i = 0; i < 16384; i++)); do
     offset=$(($i * $write_size))
     xfs_io -c "pwrite -S 0xab $offset $write_size" $MNT/foobar >/dev/null
     blocks_used=$(stat -c %b $MNT/foobar)

     # Fsync the file to trigger writeback and keep calling stat(2) on it
     # to see if the number of blocks used changes.
     stat_loop $MNT/foobar $blocks_used &
     loop_pid=$!
     xfs_io -c "fsync" $MNT/foobar

     kill $loop_pid &> /dev/null
     wait $loop_pid
  done

  umount $DEV

  $ ./reproducer-2.sh
  ERROR: unexpected used blocks (got: 265472 expected: 265344)
  ERROR: unexpected used blocks (got: 284032 expected: 283904)
  (...)

Note that since this is a short time window where the race can happen, the
reproducer may not be able to always trigger the bug in one run, or it may
trigger it multiple times.

-> Case 3

Another case where such problems happen is during other operations that
replace extents in a file range with other extents. Those operations are
extent cloning, deduplication and fallocate's zero range operation.

The cause of the problem is similar to the first case. When we drop the
extents from a range, we decrement the inode's number of bytes, and later
on, after inserting the new extents we increment it. Since this is not
done atomically, a concurrent stat(2) call can see and return a number of
used blocks that is smaller than it should be, does not match the number
of used blocks before or after the clone/deduplication/zero operation.

Like for the first case, when doing a clone, deduplication or zero range
operation against an entire file, we end up having a time window where we
can report 0 used blocks to a stat(2) call.

Example reproducer:

  $ cat reproducer-3.sh
  #!/bin/bash

  MNT=/mnt/sdi
  DEV=/dev/sdi

  mkfs.btrfs -f $DEV > /dev/null
  # mkfs.xfs -f -m reflink=1 $DEV > /dev/null
  mount $DEV $MNT

  extent_size=$((64 * 1024))
  num_extents=16384
  file_size=$(($extent_size * $num_extents))

  # File foo has many small extents.
  xfs_io -f -s -c "pwrite -S 0xab -b $extent_size 0 $file_size" $MNT/foo \
      > /dev/null
  # File bar has much less extents and has exactly the same data as foo.
  xfs_io -f -c "pwrite -S 0xab 0 $file_size" $MNT/bar > /dev/null

  expected=$(stat -c %b $MNT/foo)

  # Now deduplicate bar into foo. While the deduplication is in progres,
  # the number of used blocks/file size reported by stat should not change
  xfs_io -c "dedupe $MNT/bar 0 0 $file_size" $MNT/foo > /dev/null  &
  dedupe_pid=$!
  while [ -n "$(ps -p $dedupe_pid -o pid=)" ]; do
      used=$(stat -c %b $MNT/foo)
      if [ $used -ne $expected ]; then
          echo "Unexpected blocks used: $used (expected: $expected)"
      fi
  done

  umount $DEV

  $ ./reproducer-3.sh
  Unexpected blocks used: 2076800 (expected: 2097152)
  Unexpected blocks used: 2097024 (expected: 2097152)
  Unexpected blocks used: 2079872 (expected: 2097152)
  (...)

Note that since this is a short time window where the race can happen, the
reproducer may not be able to always trigger the bug in one run, or it may
trigger it multiple times.

So fix this by:

1) Making btrfs_drop_extents() not decrement the VFS inode's number of
   bytes, and instead return the number of bytes;

2) Making any code that drops extents and adds new extents update the
   inode's number of bytes atomically, while holding the btrfs inode's
   spinlock, which is also used by the stat(2) callback to get the inode's
   number of bytes;

3) For ranges in the inode's iotree that are marked as 'delalloc new',
   corresponding to previously unallocated ranges, increment the inode's
   number of bytes when clearing the 'delalloc new' bit from the range,
   in the same critical section that decrements the inode's
   'new_delalloc_bytes' counter, delimited by the btrfs inode's spinlock.

An alternative would be to have btrfs_getattr() wait for any IO (ordered
extents in progress) and locking the whole range (0 to (u64)-1) while it
it computes the number of blocks used. But that would mean blocking
stat(2), which is a very used syscall and expected to be fast, waiting
for writes, clone/dedupe, fallocate, page reads, fiemap, etc.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 8494f62f8aa4..b4c09a12659c 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -50,7 +50,8 @@ struct btrfs_inode {
 	/*
 	 * Lock for counters and all fields used to determine if the inode is in
 	 * the log or not (last_trans, last_sub_trans, last_log_commit,
-	 * logged_trans).
+	 * logged_trans), to access/update new_delalloc_bytes and to update the
+	 * VFS' inode number of bytes used.
 	 */
 	spinlock_t lock;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3071b0eccd82..228c5df4b17f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1274,6 +1274,11 @@ struct btrfs_drop_extents_args {
 	 * set even if btrfs_drop_extents() returns an error.
 	 */
 	u64 drop_end;
+	/*
+	 * The number of allocated bytes found in the range. This can be smaller
+	 * than the range's length when there are holes in the range.
+	 */
+	u64 bytes_found;
 	/*
 	 * Only set if 'replace_extent' is true. Set to true if we were able
 	 * to insert a replacement extent after dropping all extents in the
@@ -3142,6 +3147,9 @@ extern const struct iomap_dio_ops btrfs_dio_ops;
 
 int btrfs_inode_lock(struct inode *inode, unsigned int ilock_flags);
 void btrfs_inode_unlock(struct inode *inode, unsigned int ilock_flags);
+void btrfs_update_inode_bytes(struct btrfs_inode *inode,
+			      const u64 add_bytes,
+			      const u64 del_bytes);
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
diff --git a/fs/btrfs/extent-io-tree.h b/fs/btrfs/extent-io-tree.h
index cab4273ff8d3..5334b3772f18 100644
--- a/fs/btrfs/extent-io-tree.h
+++ b/fs/btrfs/extent-io-tree.h
@@ -21,10 +21,24 @@ struct io_failure_record;
 #define EXTENT_NORESERVE	(1U << 11)
 #define EXTENT_QGROUP_RESERVED	(1U << 12)
 #define EXTENT_CLEAR_DATA_RESV	(1U << 13)
+/*
+ * Must be cleared only during ordered extent completion or on error paths if we
+ * did not manage to submit bios and create the ordered extents for the range.
+ * Should not be cleared during page release and page invalidation (if there is
+ * an ordered extent in flight), that is left for the ordered extent completion.
+ */
 #define EXTENT_DELALLOC_NEW	(1U << 14)
+/*
+ * When an ordered extent successfully completes for a region marked as a new
+ * delalloc range, use this flag when clearing a new delalloc range to indicate
+ * that the VFS' inode number of bytes should be incremented and the inode's new
+ * delalloc bytes decremented, in an atomic way to prevent races with stat(2).
+ */
+#define EXTENT_ADD_INODE_BYTES  (1U << 15)
 #define EXTENT_DO_ACCOUNTING    (EXTENT_CLEAR_META_RESV | \
 				 EXTENT_CLEAR_DATA_RESV)
-#define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING)
+#define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING | \
+				 EXTENT_ADD_INODE_BYTES)
 
 /*
  * Redefined bits above which are used only in the device allocation tree,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ecca6d6ec90a..3bbb3bdd395b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4423,12 +4423,14 @@ static int try_release_extent_state(struct extent_io_tree *tree,
 		ret = 0;
 	} else {
 		/*
-		 * at this point we can safely clear everything except the
-		 * locked bit and the nodatasum bit
+		 * At this point we can safely clear everything except the
+		 * locked bit, the nodatasum bit and the delalloc new bit.
+		 * The delalloc new bit will be cleared by ordered extent
+		 * completion.
 		 */
 		ret = __clear_extent_bit(tree, start, end,
-				 ~(EXTENT_LOCKED | EXTENT_NODATASUM),
-				 0, 0, NULL, mask, NULL);
+			 ~(EXTENT_LOCKED | EXTENT_NODATASUM | EXTENT_DELALLOC_NEW),
+			 0, 0, NULL, mask, NULL);
 
 		/* if clear_extent_bit failed for enomem reasons,
 		 * we can't allow the release to continue.
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1648b6bfa2e7..8a9056b6e2ad 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -677,6 +677,12 @@ void btrfs_drop_extent_cache(struct btrfs_inode *inode, u64 start, u64 end,
  * If an extent intersects the range but is not entirely inside the range
  * it is either truncated or split.  Anything entirely inside the range
  * is deleted from the tree.
+ *
+ * Note: the VFS' inode number of bytes is not updated, it's up to the caller
+ * to deal with that. We set the field 'bytes_found' of the arguments structure
+ * with the number of allocated bytes found in the target range, so that the
+ * caller can update the inode's number of bytes in an atomic way when
+ * replacing extents in a range to avoid races with stat(2).
  */
 int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct btrfs_inode *inode,
@@ -688,7 +694,6 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	struct btrfs_ref ref = { 0 };
 	struct btrfs_key key;
 	struct btrfs_key new_key;
-	struct inode *vfs_inode = &inode->vfs_inode;
 	u64 ino = btrfs_ino(inode);
 	u64 search_start = args->start;
 	u64 disk_bytenr = 0;
@@ -707,6 +712,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	int leafs_visited = 0;
 	struct btrfs_path *path = args->path;
 
+	args->bytes_found = 0;
 	args->extent_inserted = false;
 
 	/* Must always have a path if ->replace_extent is true */
@@ -894,8 +900,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 							extent_end - args->end);
 			btrfs_mark_buffer_dirty(leaf);
 			if (update_refs && disk_bytenr > 0)
-				inode_sub_bytes(vfs_inode,
-						args->end - key.offset);
+				args->bytes_found += args->end - key.offset;
 			break;
 		}
 
@@ -915,8 +920,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 							args->start - key.offset);
 			btrfs_mark_buffer_dirty(leaf);
 			if (update_refs && disk_bytenr > 0)
-				inode_sub_bytes(vfs_inode,
-						extent_end - args->start);
+				args->bytes_found += extent_end - args->start;
 			if (args->end == extent_end)
 				break;
 
@@ -940,8 +944,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 
 			if (update_refs &&
 			    extent_type == BTRFS_FILE_EXTENT_INLINE) {
-				inode_sub_bytes(vfs_inode,
-						extent_end - key.offset);
+				args->bytes_found += extent_end - key.offset;
 				extent_end = ALIGN(extent_end,
 						   fs_info->sectorsize);
 			} else if (update_refs && disk_bytenr > 0) {
@@ -954,8 +957,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 						key.offset - extent_offset);
 				ret = btrfs_free_extent(trans, &ref);
 				BUG_ON(ret); /* -ENOMEM */
-				inode_sub_bytes(vfs_inode,
-						extent_end - key.offset);
+				args->bytes_found += extent_end - key.offset;
 			}
 
 			if (args->end == extent_end)
@@ -2517,7 +2519,8 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 				     struct inode *inode,
 				     struct btrfs_path *path,
 				     struct btrfs_replace_extent_info *extent_info,
-				     const u64 replace_len)
+				     const u64 replace_len,
+				     const u64 bytes_to_drop)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -2532,8 +2535,10 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 		return 0;
 
 	if (extent_info->disk_offset == 0 &&
-	    btrfs_fs_incompat(fs_info, NO_HOLES))
+	    btrfs_fs_incompat(fs_info, NO_HOLES)) {
+		btrfs_update_inode_bytes(BTRFS_I(inode), 0, bytes_to_drop);
 		return 0;
+	}
 
 	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.type = BTRFS_EXTENT_DATA_KEY;
@@ -2562,10 +2567,12 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 		return ret;
 
 	/* If it's a hole, nothing more needs to be done. */
-	if (extent_info->disk_offset == 0)
+	if (extent_info->disk_offset == 0) {
+		btrfs_update_inode_bytes(BTRFS_I(inode), 0, bytes_to_drop);
 		return 0;
+	}
 
-	inode_add_bytes(inode, replace_len);
+	btrfs_update_inode_bytes(BTRFS_I(inode), replace_len, bytes_to_drop);
 
 	if (extent_info->is_new_extent && extent_info->insertions == 0) {
 		key.objectid = extent_info->disk_offset;
@@ -2660,6 +2667,10 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 	while (cur_offset < end) {
 		drop_args.start = cur_offset;
 		ret = btrfs_drop_extents(trans, root, BTRFS_I(inode), &drop_args);
+		/* If we are punching a hole decrement the inode's byte count */
+		if (!extent_info)
+			btrfs_update_inode_bytes(BTRFS_I(inode), 0,
+						 drop_args.bytes_found);
 		if (ret != -ENOSPC) {
 			/*
 			 * When cloning we want to avoid transaction aborts when
@@ -2717,7 +2728,8 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 					  extent_info->file_offset;
 
 			ret = btrfs_insert_replace_extent(trans, inode, path,
-							extent_info, replace_len);
+							extent_info, replace_len,
+							drop_args.bytes_found);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
 				break;
@@ -2814,7 +2826,8 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 	}
 	if (extent_info) {
 		ret = btrfs_insert_replace_extent(trans, inode, path, extent_info,
-						extent_info->data_len);
+						  extent_info->data_len,
+						  drop_args.bytes_found);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out_trans;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 25764de68b92..2db11ab4ecbf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -223,8 +223,6 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 	if (compressed_size && compressed_pages)
 		cur_size = compressed_size;
 
-	inode_add_bytes(inode, size);
-
 	if (!extent_inserted) {
 		struct btrfs_key key;
 		size_t datasize;
@@ -299,8 +297,6 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 	 * could end up racing with unlink.
 	 */
 	BTRFS_I(inode)->disk_i_size = inode->i_size;
-	ret = btrfs_update_inode(trans, root, inode);
-
 fail:
 	return ret;
 }
@@ -385,6 +381,16 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 start,
 		goto out;
 	}
 
+	btrfs_update_inode_bytes(inode, inline_len, drop_args.bytes_found);
+	ret = btrfs_update_inode(trans, root, &inode->vfs_inode);
+	if (ret && ret != -ENOSPC) {
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	} else if (ret == -ENOSPC) {
+		ret = 1;
+		goto out;
+	}
+
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 out:
@@ -2144,6 +2150,8 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 		spin_lock(&inode->lock);
 		ASSERT(inode->new_delalloc_bytes >= len);
 		inode->new_delalloc_bytes -= len;
+		if (*bits & EXTENT_ADD_INODE_BYTES)
+			inode_add_bytes(&inode->vfs_inode, len);
 		spin_unlock(&inode->lock);
 	}
 }
@@ -2561,9 +2569,11 @@ int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end)
 static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       struct btrfs_inode *inode, u64 file_pos,
 				       struct btrfs_file_extent_item *stack_fi,
+				       const bool update_inode_bytes,
 				       u64 qgroup_reserved)
 {
 	struct btrfs_root *root = inode->root;
+	const u64 sectorsize = root->fs_info->sectorsize;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_key ins;
@@ -2615,7 +2625,24 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
-	inode_add_bytes(&inode->vfs_inode, num_bytes);
+	/*
+	 * If we dropped an inline extent here, we know the range where it is
+	 * was not marked with the EXTENT_DELALLOC_NEW bit, so we update the
+	 * number of bytes only for that range contaning the inline extent.
+	 * The remaining of the range will be processed when clearning the
+	 * EXTENT_DELALLOC_BIT bit through the ordered extent completion.
+	 */
+	if (file_pos == 0 && !IS_ALIGNED(drop_args.bytes_found, sectorsize)) {
+		u64 inline_size = round_down(drop_args.bytes_found, sectorsize);
+
+		inline_size = drop_args.bytes_found - inline_size;
+		btrfs_update_inode_bytes(inode, sectorsize, inline_size);
+		drop_args.bytes_found -= inline_size;
+		num_bytes -= sectorsize;
+	}
+
+	if (update_inode_bytes)
+		btrfs_update_inode_bytes(inode, num_bytes, drop_args.bytes_found);
 
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
@@ -2653,6 +2680,7 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_file_extent_item stack_fi;
 	u64 logical_len;
+	bool update_inode_bytes;
 
 	memset(&stack_fi, 0, sizeof(stack_fi));
 	btrfs_set_stack_file_extent_type(&stack_fi, BTRFS_FILE_EXTENT_REG);
@@ -2668,9 +2696,18 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_compression(&stack_fi, oe->compress_type);
 	/* Encryption and other encoding is reserved and all 0 */
 
+	/*
+	 * For delalloc, when completing an ordered extent we update the inode's
+	 * bytes when clearing the range in the inode's io tree, so pass false
+	 * as the argument 'update_inode_bytes' to insert_reserved_file_extent(),
+	 * except if the ordered extent was truncated.
+	 */
+	update_inode_bytes = test_bit(BTRFS_ORDERED_DIRECT, &oe->flags) ||
+			     test_bit(BTRFS_ORDERED_TRUNCATED, &oe->flags);
+
 	return insert_reserved_file_extent(trans, BTRFS_I(oe->inode),
 					   oe->file_offset, &stack_fi,
-					   oe->qgroup_rsv);
+					   update_inode_bytes, oe->qgroup_rsv);
 }
 
 /*
@@ -2692,10 +2729,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	u64 logical_len = ordered_extent->num_bytes;
 	bool freespace_inode;
 	bool truncated = false;
-	bool range_locked = false;
-	bool clear_new_delalloc_bytes = false;
 	bool clear_reserved_extent = true;
-	unsigned int clear_bits;
+	unsigned int clear_bits = EXTENT_DEFRAG;
 
 	start = ordered_extent->file_offset;
 	end = start + ordered_extent->num_bytes - 1;
@@ -2703,7 +2738,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 	    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) &&
 	    !test_bit(BTRFS_ORDERED_DIRECT, &ordered_extent->flags))
-		clear_new_delalloc_bytes = true;
+		clear_bits |= EXTENT_DELALLOC_NEW;
 
 	freespace_inode = btrfs_is_free_space_inode(BTRFS_I(inode));
 
@@ -2742,7 +2777,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
-	range_locked = true;
+	clear_bits |= EXTENT_LOCKED;
 	lock_extent_bits(io_tree, start, end, &cached_state);
 
 	if (freespace_inode)
@@ -2789,6 +2824,17 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
+	/*
+	 * If this is a new delalloc range, clear its new delalloc flag to
+	 * update the inode's number of bytes. This needs to be done first
+	 * before updating the inode item.
+	 */
+	if ((clear_bits & EXTENT_DELALLOC_NEW) &&
+	    !test_bit(BTRFS_ORDERED_TRUNCATED, &ordered_extent->flags))
+		clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end,
+				 EXTENT_DELALLOC_NEW | EXTENT_ADD_INODE_BYTES,
+				 0, 0, &cached_state);
+
 	btrfs_inode_safe_disk_i_size_write(inode, 0);
 	ret = btrfs_update_inode_fallback(trans, root, inode);
 	if (ret) { /* -ENOMEM or corruption */
@@ -2797,11 +2843,6 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	}
 	ret = 0;
 out:
-	clear_bits = EXTENT_DEFRAG;
-	if (range_locked)
-		clear_bits |= EXTENT_LOCKED;
-	if (clear_new_delalloc_bytes)
-		clear_bits |= EXTENT_DELALLOC_NEW;
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, clear_bits,
 			 (clear_bits & EXTENT_LOCKED) ? 1 : 0, 0,
 			 &cached_state);
@@ -4790,10 +4831,12 @@ static int maybe_insert_hole(struct btrfs_root *root, struct inode *inode,
 
 	ret = btrfs_insert_file_extent(trans, root, btrfs_ino(BTRFS_I(inode)),
 			offset, 0, 0, len, 0, len, 0, 0, 0);
-	if (ret)
+	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-	else
+	} else {
+		btrfs_update_inode_bytes(BTRFS_I(inode), 0, drop_args.bytes_found);
 		btrfs_update_inode(trans, root, inode);
+	}
 	btrfs_end_transaction(trans);
 	return ret;
 }
@@ -8117,6 +8160,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	u64 start;
 	u64 end;
 	int inode_evicting = inode->vfs_inode.i_state & I_FREEING;
+	bool found_ordered = false;
+	bool completed_ordered = false;
 
 	/*
 	 * we have the page locked, so new writeback can't start,
@@ -8138,15 +8183,17 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	start = page_start;
 	ordered = btrfs_lookup_ordered_range(inode, start, page_end - start + 1);
 	if (ordered) {
+		found_ordered = true;
 		end = min(page_end,
 			  ordered->file_offset + ordered->num_bytes - 1);
 		/*
-		 * IO on this page will never be started, so we need
-		 * to account for any ordered extents now
+		 * IO on this page will never be started, so we need to account
+		 * for any ordered extents now. Don't clear EXTENT_DELALLOC_NEW
+		 * here, must leave that up for the ordered extent completion.
 		 */
 		if (!inode_evicting)
 			clear_extent_bit(tree, start, end,
-					 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+					 EXTENT_DELALLOC |
 					 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 					 EXTENT_DEFRAG, 1, 0, &cached_state);
 		/*
@@ -8168,8 +8215,10 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 
 			if (btrfs_dec_test_ordered_pending(inode, &ordered,
 							   start,
-							   end - start + 1, 1))
+							   end - start + 1, 1)) {
 				btrfs_finish_ordered_io(ordered);
+				completed_ordered = true;
+			}
 		}
 		btrfs_put_ordered_extent(ordered);
 		if (!inode_evicting) {
@@ -8198,10 +8247,23 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	 */
 	btrfs_qgroup_free_data(inode, NULL, page_start, PAGE_SIZE);
 	if (!inode_evicting) {
+		bool delete = true;
+
+		/*
+		 * If there's an ordered extent for this range and we have not
+		 * finished it ourselves, we must leave EXTENT_DELALLOC_NEW set
+		 * in the range for the ordered extent completion. We must also
+		 * not delete the range, otherwise we would lose that bit (and
+		 * any other bits set in the range). Make sure EXTENT_UPTODATE
+		 * is cleared if we don't delete, otherwise it can lead to
+		 * corruptions if the i_size is extented later.
+		 */
+		if (found_ordered && !completed_ordered)
+			delete = false;
 		clear_extent_bit(tree, page_start, page_end, EXTENT_LOCKED |
-				 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
-				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 1, 1,
-				 &cached_state);
+				 EXTENT_DELALLOC | EXTENT_UPTODATE |
+				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 1,
+				 delete, &cached_state);
 
 		__btrfs_releasepage(page, GFP_NOFS);
 	}
@@ -8750,6 +8812,7 @@ static int btrfs_getattr(const struct path *path, struct kstat *stat,
 			 u32 request_mask, unsigned int flags)
 {
 	u64 delalloc_bytes;
+	u64 inode_bytes;
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = inode->i_sb->s_blocksize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
@@ -8776,8 +8839,9 @@ static int btrfs_getattr(const struct path *path, struct kstat *stat,
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
+	inode_bytes = inode_get_bytes(inode);
 	spin_unlock(&BTRFS_I(inode)->lock);
-	stat->blocks = (ALIGN(inode_get_bytes(inode), blocksize) +
+	stat->blocks = (ALIGN(inode_bytes, blocksize) +
 			ALIGN(delalloc_bytes, blocksize)) >> 9;
 	return 0;
 }
@@ -9586,7 +9650,8 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 
 	if (trans) {
 		ret = insert_reserved_file_extent(trans, BTRFS_I(inode),
-						  file_offset, &stack_fi, ret);
+						  file_offset, &stack_fi,
+						  true, ret);
 		if (ret)
 			return ERR_PTR(ret);
 		return trans;
@@ -10202,6 +10267,27 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 }
 #endif
 
+/*
+ * Update the number of bytes used in the VFS' inode. When we replace extents in
+ * a range (clone, dedupe, fallocate's zero range), we must update the number of
+ * bytes used by the inode in an atomic manner, so that concurrent stat(2) calls
+ * always get a correct value.
+ */
+void btrfs_update_inode_bytes(struct btrfs_inode *inode,
+			      const u64 add_bytes,
+			      const u64 del_bytes)
+{
+	if (add_bytes == del_bytes)
+		return;
+
+	spin_lock(&inode->lock);
+	if (del_bytes > 0)
+		inode_sub_bytes(&inode->vfs_inode, del_bytes);
+	if (add_bytes > 0)
+		inode_add_bytes(&inode->vfs_inode, add_bytes);
+	spin_unlock(&inode->lock);
+}
+
 static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.lookup		= btrfs_lookup,
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 67728ea3ed47..4bbc5f52b752 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -268,7 +268,7 @@ static int clone_copy_inline_extent(struct inode *dst,
 			    btrfs_item_ptr_offset(path->nodes[0],
 						  path->slots[0]),
 			    size);
-	inode_add_bytes(dst, datal);
+	btrfs_update_inode_bytes(BTRFS_I(dst), datal, drop_args.bytes_found);
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(dst)->runtime_flags);
 	ret = btrfs_inode_set_file_extent_range(BTRFS_I(dst), 0, aligned_end);
 out:
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 89ff063cae24..932a74a236eb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -832,8 +832,8 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	inode_add_bytes(inode, nbytes);
 update_inode:
+	btrfs_update_inode_bytes(BTRFS_I(inode), nbytes, drop_args.bytes_found);
 	ret = btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)
@@ -2598,6 +2598,8 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 							 BTRFS_I(inode),
 							 &drop_args);
 				if (!ret) {
+					inode_sub_bytes(inode,
+							drop_args.bytes_found);
 					/* Update the inode's nbytes. */
 					ret = btrfs_update_inode(wc->trans,
 								 root, inode);

