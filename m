Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6E82A46FD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgKCNyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:54:21 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:50869 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729435AbgKCNxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:53:45 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0AD54B12;
        Tue,  3 Nov 2020 08:53:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 08:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=67q760
        aLoDXcQ9UoSQSvAFjBDTNoiZJn3W/r+Mx1bKU=; b=bEfOMAbsTmTxHRQZywUYyu
        x0hVIWUCtVAP8oMjT/gTHw7DwnBv8mqRaVvl0H6esTM9Euz3LN8wJb9RVWVhdN/3
        PC0BAtCw36kN8gX+8ZklUQgAJW29Begd7c1ienATA1R7jP2k02FC6dSTUoje27op
        +NZpvU9l56xRtfRgkEcTKKjdkChwCyI1wSPgReb/cIYypaZQ19zpA78EttqOm6BN
        tnJ0j93t6vSPvog0FWAOs1XVMD70G02xDqsBHIWTrgzlYc/scnCMy9N3WEuKEvD3
        0v3lZptiv6/1A/DdFB85lnjI7ArnNxLpIxgO0hISN1MbY1cQsHs5arhQGxenOkqw
        ==
X-ME-Sender: <xms:52ChX2-8ipo-jY3QDrbEIALUw2bgstwPuFlk2LOqV9D-ogdUeT4X_g>
    <xme:52ChX2sRqLJQLQ-i6x5Hus7unp01w1MVN7jRR-vmt6kHvT_hA-Aebn-k4FournfcO
    LyWYp8u6uwvIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepledthedtvdduudeiffeljeffueduleduvdejkeetud
    euleeiveelvdeigfevtdefnecuffhomhgrihhnpedvheelrdhmvhdpohhpvghrrghtihho
    nhhsrdhmvhenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpe
    dvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:52ChX8DkOeFl4HtBVZu3VNi5tLKtQMHSNPBYqwTzvtgNFAgRrONnLg>
    <xmx:52ChX-dRDo994Fste-FhFPxrptNg7cKhBZXyfvmZekxqOCMlAaEZ6w>
    <xmx:52ChX7Mt5tX8PZJy7DJxj83FbtoZ1l-YCzDWmDuhyNg6qqbKxGMpag>
    <xmx:52ChXx0TccCNviTxcQ_GJK02g0A869E-8e8IXXpR-Qx5SEX9IIXZcp-6UYs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 45D163064685;
        Tue,  3 Nov 2020 08:53:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: send, orphanize first all conflicting inodes when" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 14:54:37 +0100
Message-ID: <1604411677112131@kroah.com>
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

From 98272bb77bf4cc20ed1ffca89832d713e70ebf09 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 21 Sep 2020 14:13:29 +0100
Subject: [PATCH] btrfs: send, orphanize first all conflicting inodes when
 processing references

When doing an incremental send it is possible that when processing the new
references for an inode we end up issuing rename or link operations that
have an invalid path, which contains the orphanized name of a directory
before we actually orphanized it, causing the receiver to fail.

The following reproducer triggers such scenario:

  $ cat reproducer.sh
  #!/bin/bash

  mkfs.btrfs -f /dev/sdi >/dev/null
  mount /dev/sdi /mnt/sdi

  touch /mnt/sdi/a
  touch /mnt/sdi/b
  mkdir /mnt/sdi/testdir
  # We want "a" to have a lower inode number then "testdir" (257 vs 259).
  mv /mnt/sdi/a /mnt/sdi/testdir/a

  # Filesystem looks like:
  #
  # .                           (ino 256)
  # |----- testdir/             (ino 259)
  # |          |----- a         (ino 257)
  # |
  # |----- b                    (ino 258)

  btrfs subvolume snapshot -r /mnt/sdi /mnt/sdi/snap1
  btrfs send -f /tmp/snap1.send /mnt/sdi/snap1

  # Now rename 259 to "testdir_2", then change the name of 257 to
  # "testdir" and make it a direct descendant of the root inode (256).
  # Also create a new link for inode 257 with the old name of inode 258.
  # By swapping the names and location of several inodes and create a
  # nasty dependency chain of rename and link operations.
  mv /mnt/sdi/testdir/a /mnt/sdi/a2
  touch /mnt/sdi/testdir/a
  mv /mnt/sdi/b /mnt/sdi/b2
  ln /mnt/sdi/a2 /mnt/sdi/b
  mv /mnt/sdi/testdir /mnt/sdi/testdir_2
  mv /mnt/sdi/a2 /mnt/sdi/testdir

  # Filesystem now looks like:
  #
  # .                            (ino 256)
  # |----- testdir_2/            (ino 259)
  # |          |----- a          (ino 260)
  # |
  # |----- testdir               (ino 257)
  # |----- b                     (ino 257)
  # |----- b2                    (ino 258)

  btrfs subvolume snapshot -r /mnt/sdi /mnt/sdi/snap2
  btrfs send -f /tmp/snap2.send -p /mnt/sdi/snap1 /mnt/sdi/snap2

  mkfs.btrfs -f /dev/sdj >/dev/null
  mount /dev/sdj /mnt/sdj

  btrfs receive -f /tmp/snap1.send /mnt/sdj
  btrfs receive -f /tmp/snap2.send /mnt/sdj

  umount /mnt/sdi
  umount /mnt/sdj

When running the reproducer, the receive of the incremental send stream
fails:

  $ ./reproducer.sh
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap1'
  At subvol /mnt/sdi/snap1
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap2'
  At subvol /mnt/sdi/snap2
  At subvol snap1
  At snapshot snap2
  ERROR: link b -> o259-6-0/a failed: No such file or directory

The problem happens because of the following:

1) Before we start iterating the list of new references for inode 257,
   we generate its current path and store it at @valid_path, done at
   the very beginning of process_recorded_refs(). The generated path
   is "o259-6-0/a", containing the orphanized name for inode 259;

2) Then we iterate over the list of new references, which has the
   references "b" and "testdir" in that specific order;

3) We process reference "b" first, because it is in the list before
   reference "testdir". We then issue a link operation to create
   the new reference "b" using a target path corresponding to the
   content at @valid_path, which corresponds to "o259-6-0/a".
   However we haven't yet orphanized inode 259, its name is still
   "testdir", and not "o259-6-0". The orphanization of 259 did not
   happen yet because we will process the reference named "testdir"
   for inode 257 only in the next iteration of the loop that goes
   over the list of new references.

Fix the issue by having a preliminar iteration over all the new references
at process_recorded_refs(). This iteration is responsible only for doing
the orphanization of other inodes that have and old reference that
conflicts with one of the new references of the inode we are currently
processing. The emission of rename and link operations happen now in the
next iteration of the new references.

A test case for fstests will follow soon.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 9f1ee52482c9..f9c14c33e753 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3873,52 +3873,56 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 			goto out;
 	}
 
+	/*
+	 * Before doing any rename and link operations, do a first pass on the
+	 * new references to orphanize any unprocessed inodes that may have a
+	 * reference that conflicts with one of the new references of the current
+	 * inode. This needs to happen first because a new reference may conflict
+	 * with the old reference of a parent directory, so we must make sure
+	 * that the path used for link and rename commands don't use an
+	 * orphanized name when an ancestor was not yet orphanized.
+	 *
+	 * Example:
+	 *
+	 * Parent snapshot:
+	 *
+	 * .                                                      (ino 256)
+	 * |----- testdir/                                        (ino 259)
+	 * |          |----- a                                    (ino 257)
+	 * |
+	 * |----- b                                               (ino 258)
+	 *
+	 * Send snapshot:
+	 *
+	 * .                                                      (ino 256)
+	 * |----- testdir_2/                                      (ino 259)
+	 * |          |----- a                                    (ino 260)
+	 * |
+	 * |----- testdir                                         (ino 257)
+	 * |----- b                                               (ino 257)
+	 * |----- b2                                              (ino 258)
+	 *
+	 * Processing the new reference for inode 257 with name "b" may happen
+	 * before processing the new reference with name "testdir". If so, we
+	 * must make sure that by the time we send a link command to create the
+	 * hard link "b", inode 259 was already orphanized, since the generated
+	 * path in "valid_path" already contains the orphanized name for 259.
+	 * We are processing inode 257, so only later when processing 259 we do
+	 * the rename operation to change its temporary (orphanized) name to
+	 * "testdir_2".
+	 */
 	list_for_each_entry(cur, &sctx->new_refs, list) {
-		/*
-		 * We may have refs where the parent directory does not exist
-		 * yet. This happens if the parent directories inum is higher
-		 * than the current inum. To handle this case, we create the
-		 * parent directory out of order. But we need to check if this
-		 * did already happen before due to other refs in the same dir.
-		 */
 		ret = get_cur_inode_state(sctx, cur->dir, cur->dir_gen);
 		if (ret < 0)
 			goto out;
-		if (ret == inode_state_will_create) {
-			ret = 0;
-			/*
-			 * First check if any of the current inodes refs did
-			 * already create the dir.
-			 */
-			list_for_each_entry(cur2, &sctx->new_refs, list) {
-				if (cur == cur2)
-					break;
-				if (cur2->dir == cur->dir) {
-					ret = 1;
-					break;
-				}
-			}
-
-			/*
-			 * If that did not happen, check if a previous inode
-			 * did already create the dir.
-			 */
-			if (!ret)
-				ret = did_create_dir(sctx, cur->dir);
-			if (ret < 0)
-				goto out;
-			if (!ret) {
-				ret = send_create_inode(sctx, cur->dir);
-				if (ret < 0)
-					goto out;
-			}
-		}
+		if (ret == inode_state_will_create)
+			continue;
 
 		/*
-		 * Check if this new ref would overwrite the first ref of
-		 * another unprocessed inode. If yes, orphanize the
-		 * overwritten inode. If we find an overwritten ref that is
-		 * not the first ref, simply unlink it.
+		 * Check if this new ref would overwrite the first ref of another
+		 * unprocessed inode. If yes, orphanize the overwritten inode.
+		 * If we find an overwritten ref that is not the first ref,
+		 * simply unlink it.
 		 */
 		ret = will_overwrite_ref(sctx, cur->dir, cur->dir_gen,
 				cur->name, cur->name_len,
@@ -3997,6 +4001,49 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 			}
 		}
 
+	}
+
+	list_for_each_entry(cur, &sctx->new_refs, list) {
+		/*
+		 * We may have refs where the parent directory does not exist
+		 * yet. This happens if the parent directories inum is higher
+		 * than the current inum. To handle this case, we create the
+		 * parent directory out of order. But we need to check if this
+		 * did already happen before due to other refs in the same dir.
+		 */
+		ret = get_cur_inode_state(sctx, cur->dir, cur->dir_gen);
+		if (ret < 0)
+			goto out;
+		if (ret == inode_state_will_create) {
+			ret = 0;
+			/*
+			 * First check if any of the current inodes refs did
+			 * already create the dir.
+			 */
+			list_for_each_entry(cur2, &sctx->new_refs, list) {
+				if (cur == cur2)
+					break;
+				if (cur2->dir == cur->dir) {
+					ret = 1;
+					break;
+				}
+			}
+
+			/*
+			 * If that did not happen, check if a previous inode
+			 * did already create the dir.
+			 */
+			if (!ret)
+				ret = did_create_dir(sctx, cur->dir);
+			if (ret < 0)
+				goto out;
+			if (!ret) {
+				ret = send_create_inode(sctx, cur->dir);
+				if (ret < 0)
+					goto out;
+			}
+		}
+
 		if (S_ISDIR(sctx->cur_inode_mode) && sctx->parent_root) {
 			ret = wait_for_dest_dir_move(sctx, cur, is_orphan);
 			if (ret < 0)

