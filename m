Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B51D2A4731
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgKCOEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:04:50 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:59979 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729358AbgKCODt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:03:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6095DB74;
        Tue,  3 Nov 2020 09:03:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:03:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ku8V6j
        mfDhF2aZv9F4DKwJJE3VcXRoBPv9f63znk3oQ=; b=HULbG50MkxLC/85q+ipUha
        dtcmHas+XeZtshMLkVDlB1NBI56hadcpJI9DyL8AZReSH4g53g7g/WV6beWdQePZ
        Mkj2Dd4rE4goNxXWX8vooTRn6RgGLv1BhLCZSQreBTMJywm0PW52gJIV6znEevG8
        x0d4eRD7vgy+EEUW8QXErjAltwIR+DBvj5uX1Qs36o1/MSEF9ntitO2qpU/38FUV
        wgEbUoXzoMajM69v2x8q6ko7uMv71RKUQkcvhVYfeXnXScKG1S7cw4Qwzl9LpCrx
        L568tWaa15zblLYJ3njD+q6aZGI6SyPsx65NwyvChKKZBmfHusvm2K6UTH1OCg8w
        ==
X-ME-Sender: <xms:Q2OhX2FUyrfZNscIlbgCwqUck9iIK0dpfYYFsQ9pQgJR5TEHTYdPlg>
    <xme:Q2OhX3UvVzjxZaDkNs5T2npkqYT4v1MEm2Y4DZJ9WyqAh1saFK99yCGwrNiAUxFLL
    qqVP6A0CJ309A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdfhhfeikeffffeifffgkeehffegvdeileethffhge
    efkeejffeiffektdeuudejnecuffhomhgrihhnpehfvddrmhhvnecukfhppeekfedrkeei
    rdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Q2OhXwKr_n4VHM5ObZp2cwV7spaQDvYqMeNxnbJyWRm87jCOGnTC5Q>
    <xmx:Q2OhXwEIzobZ4irZD0F_sSxcXgJ1oiBpQhvLFHYf_bZDGpwBBHe5UQ>
    <xmx:Q2OhX8USGvx5_n2WQVrqNvo05YfOkGeCnaYhkF8RiaqjQZsmW4jIXA>
    <xmx:RGOhX3eyAzotnw_zDyimaTD4AU2PxCWvdBs-ke1Z8Xz4qSJ7dTtBnBzt1-E>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 701083064610;
        Tue,  3 Nov 2020 09:03:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: send, recompute reference path after orphanization of" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:04:34 +0100
Message-ID: <1604412274650@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 9c2b4e0347067396ceb3ae929d6888c81d610259 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 21 Sep 2020 14:13:30 +0100
Subject: [PATCH] btrfs: send, recompute reference path after orphanization of
 a directory

During an incremental send, when an inode has multiple new references we
might end up emitting rename operations for orphanizations that have a
source path that is no longer valid due to a previous orphanization of
some directory inode. This causes the receiver to fail since it tries
to rename a path that does not exists.

Example reproducer:

  $ cat reproducer.sh
  #!/bin/bash

  mkfs.btrfs -f /dev/sdi >/dev/null
  mount /dev/sdi /mnt/sdi

  touch /mnt/sdi/f1
  touch /mnt/sdi/f2
  mkdir /mnt/sdi/d1
  mkdir /mnt/sdi/d1/d2

  # Filesystem looks like:
  #
  # .                           (ino 256)
  # |----- f1                   (ino 257)
  # |----- f2                   (ino 258)
  # |----- d1/                  (ino 259)
  #        |----- d2/           (ino 260)

  btrfs subvolume snapshot -r /mnt/sdi /mnt/sdi/snap1
  btrfs send -f /tmp/snap1.send /mnt/sdi/snap1

  # Now do a series of changes such that:
  #
  # *) inode 258 has one new hardlink and the previous name changed
  #
  # *) both names conflict with the old names of two other inodes:
  #
  #    1) the new name "d1" conflicts with the old name of inode 259,
  #       under directory inode 256 (root)
  #
  #    2) the new name "d2" conflicts with the old name of inode 260
  #       under directory inode 259
  #
  # *) inodes 259 and 260 now have the old names of inode 258
  #
  # *) inode 257 is now located under inode 260 - an inode with a number
  #    smaller than the inode (258) for which we created a second hard
  #    link and swapped its names with inodes 259 and 260
  #
  ln /mnt/sdi/f2 /mnt/sdi/d1/f2_link
  mv /mnt/sdi/f1 /mnt/sdi/d1/d2/f1

  # Swap d1 and f2.
  mv /mnt/sdi/d1 /mnt/sdi/tmp
  mv /mnt/sdi/f2 /mnt/sdi/d1
  mv /mnt/sdi/tmp /mnt/sdi/f2

  # Swap d2 and f2_link
  mv /mnt/sdi/f2/d2 /mnt/sdi/tmp
  mv /mnt/sdi/f2/f2_link /mnt/sdi/f2/d2
  mv /mnt/sdi/tmp /mnt/sdi/f2/f2_link

  # Filesystem now looks like:
  #
  # .                                (ino 256)
  # |----- d1                        (ino 258)
  # |----- f2/                       (ino 259)
  #        |----- f2_link/           (ino 260)
  #        |       |----- f1         (ino 257)
  #        |
  #        |----- d2                 (ino 258)

  btrfs subvolume snapshot -r /mnt/sdi /mnt/sdi/snap2
  btrfs send -f /tmp/snap2.send -p /mnt/sdi/snap1 /mnt/sdi/snap2

  mkfs.btrfs -f /dev/sdj >/dev/null
  mount /dev/sdj /mnt/sdj

  btrfs receive -f /tmp/snap1.send /mnt/sdj
  btrfs receive -f /tmp/snap2.send /mnt/sdj

  umount /mnt/sdi
  umount /mnt/sdj

When executed the receive of the incremental stream fails:

  $ ./reproducer.sh
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap1'
  At subvol /mnt/sdi/snap1
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap2'
  At subvol /mnt/sdi/snap2
  At subvol snap1
  At snapshot snap2
  ERROR: rename d1/d2 -> o260-6-0 failed: No such file or directory

This happens because:

1) When processing inode 257 we end up computing the name for inode 259
   because it is an ancestor in the send snapshot, and at that point it
   still has its old name, "d1", from the parent snapshot because inode
   259 was not yet processed. We then cache that name, which is valid
   until we start processing inode 259 (or set the progress to 260 after
   processing its references);

2) Later we start processing inode 258 and collecting all its new
   references into the list sctx->new_refs. The first reference in the
   list happens to be the reference for name "d1" while the reference for
   name "d2" is next (the last element of the list).
   We compute the full path "d1/d2" for this second reference and store
   it in the reference (its ->full_path member). The path used for the
   new parent directory was "d1" and not "f2" because inode 259, the
   new parent, was not yet processed;

3) When we start processing the new references at process_recorded_refs()
   we start with the first reference in the list, for the new name "d1".
   Because there is a conflicting inode that was not yet processed, which
   is directory inode 259, we orphanize it, renaming it from "d1" to
   "o259-6-0";

4) Then we start processing the new reference for name "d2", and we
   realize it conflicts with the reference of inode 260 in the parent
   snapshot. So we issue an orphanization operation for inode 260 by
   emitting a rename operation with a destination path of "o260-6-0"
   and a source path of "d1/d2" - this source path is the value we
   stored in the reference earlier at step 2), corresponding to the
   ->full_path member of the reference, however that path is no longer
   valid due to the orphanization of the directory inode 259 in step 3).
   This makes the receiver fail since the path does not exists, it should
   have been "o259-6-0/d2".

Fix this by recomputing the full path of a reference before emitting an
orphanization if we previously orphanized any directory, since that
directory could be a parent in the new path. This is a rare scenario so
keeping it simple and not checking if that previously orphanized directory
is in fact an ancestor of the inode we are trying to orphanize.

A test case for fstests follows soon.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f9c14c33e753..340c76a12ce1 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3805,6 +3805,72 @@ static int update_ref_path(struct send_ctx *sctx, struct recorded_ref *ref)
 	return 0;
 }
 
+/*
+ * When processing the new references for an inode we may orphanize an existing
+ * directory inode because its old name conflicts with one of the new references
+ * of the current inode. Later, when processing another new reference of our
+ * inode, we might need to orphanize another inode, but the path we have in the
+ * reference reflects the pre-orphanization name of the directory we previously
+ * orphanized. For example:
+ *
+ * parent snapshot looks like:
+ *
+ * .                                     (ino 256)
+ * |----- f1                             (ino 257)
+ * |----- f2                             (ino 258)
+ * |----- d1/                            (ino 259)
+ *        |----- d2/                     (ino 260)
+ *
+ * send snapshot looks like:
+ *
+ * .                                     (ino 256)
+ * |----- d1                             (ino 258)
+ * |----- f2/                            (ino 259)
+ *        |----- f2_link/                (ino 260)
+ *        |       |----- f1              (ino 257)
+ *        |
+ *        |----- d2                      (ino 258)
+ *
+ * When processing inode 257 we compute the name for inode 259 as "d1", and we
+ * cache it in the name cache. Later when we start processing inode 258, when
+ * collecting all its new references we set a full path of "d1/d2" for its new
+ * reference with name "d2". When we start processing the new references we
+ * start by processing the new reference with name "d1", and this results in
+ * orphanizing inode 259, since its old reference causes a conflict. Then we
+ * move on the next new reference, with name "d2", and we find out we must
+ * orphanize inode 260, as its old reference conflicts with ours - but for the
+ * orphanization we use a source path corresponding to the path we stored in the
+ * new reference, which is "d1/d2" and not "o259-6-0/d2" - this makes the
+ * receiver fail since the path component "d1/" no longer exists, it was renamed
+ * to "o259-6-0/" when processing the previous new reference. So in this case we
+ * must recompute the path in the new reference and use it for the new
+ * orphanization operation.
+ */
+static int refresh_ref_path(struct send_ctx *sctx, struct recorded_ref *ref)
+{
+	char *name;
+	int ret;
+
+	name = kmemdup(ref->name, ref->name_len, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
+	fs_path_reset(ref->full_path);
+	ret = get_cur_path(sctx, ref->dir, ref->dir_gen, ref->full_path);
+	if (ret < 0)
+		goto out;
+
+	ret = fs_path_add(ref->full_path, name, ref->name_len);
+	if (ret < 0)
+		goto out;
+
+	/* Update the reference's base name pointer. */
+	set_ref_path(ref, ref->full_path);
+out:
+	kfree(name);
+	return ret;
+}
+
 /*
  * This does all the move/link/unlink/rmdir magic.
  */
@@ -3939,6 +4005,12 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 				struct name_cache_entry *nce;
 				struct waiting_dir_move *wdm;
 
+				if (orphanized_dir) {
+					ret = refresh_ref_path(sctx, cur);
+					if (ret < 0)
+						goto out;
+				}
+
 				ret = orphanize_inode(sctx, ow_inode, ow_gen,
 						cur->full_path);
 				if (ret < 0)

