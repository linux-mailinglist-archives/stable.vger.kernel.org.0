Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588A53C3C4F
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhGKMbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:31:06 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47725 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232544AbhGKMbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:31:06 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 9726A1AC0DB3;
        Sun, 11 Jul 2021 08:28:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 08:28:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=I7vlhx
        LAY76QIPTy+5PIgLDXbuNB+EiyY75XJ4+J1Lk=; b=pAzJHYlCABcZeeUKBI7Yst
        IOmvurcEnqL+BgAayhhY/9AAMpR2OK6ddwpdbbCN4Qiv3gh+T9cWuREBT0v3fLGr
        wt0e6yku7Zojw6pup/U4U02/02MIE35dBZ//pewJU5xIocBTw3UI3DJRQpvdjFrV
        1SHRwfcYJiqbdD3mMG9aAo0FBGnQutnVZb0Qtrl19jChssOu8Y4MwXX1WOKRqL7/
        iertk0WlyxZx+3SqNChVJ6KdgoDujVGnyyfPBwNPz2qDdIvxLGZUBmE4oNhYz3bh
        jSvyREVO9Pj76M6tHLQx7xIWE/dm4sOCGU3PJvixKv653N+6F+ZSnoZZPh4O686g
        ==
X-ME-Sender: <xms:4uPqYOZwe_b_Tf50opRfJBtQBgQUHpL4F-SQAA0TdhSOoX7EULhW4g>
    <xme:4uPqYBbS-6kqBvxllv6pCB_5CQpcCePlszBvn_FXK72Ojc5O_8o8B4tS7UoeEMFgy
    kW6TAzcVSeePg>
X-ME-Received: <xmr:4uPqYI-PoFbFGqgXo3JPB6fDxIjs7TCWcevi9YYLDN4gGMoZVaQiyv9aOdpnTsKYs3j2BRC50c-FOvaMn5ZUzoG_lg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4uPqYAoGD8Ljzf_YjKso8MNZ8FBJbUgV-VphWskKvyu7y-EFCBUJwQ>
    <xmx:4uPqYJpSTplE2Tnm6C9DQT0LD-TJkkBycJAfxt4Bjh2BNHR_gRzimg>
    <xmx:4uPqYOQjbtfNHwpdgW14hoCx4SmzKsUVOTvzErDhQmZtyfB1inXcmw>
    <xmx:4-PqYKAIeYkcMCxIzaLl2fvYukmX_2HHwT7dUqk5kpB3wEP0pHbGkEMVMx0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:28:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: send: fix invalid path for unlink operations after" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:28:17 +0200
Message-ID: <162600649710370@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From d8ac76cdd1755b21e8c008c28d0b7251c0b14986 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 9 Jun 2021 11:25:03 +0100
Subject: [PATCH] btrfs: send: fix invalid path for unlink operations after
 parent orphanization

During an incremental send operation, when processing the new references
for the current inode, we might send an unlink operation for another inode
that has a conflicting path and has more than one hard link. However this
path was computed and cached before we processed previous new references
for the current inode. We may have orphanized a directory of that path
while processing a previous new reference, in which case the path will
be invalid and cause the receiver process to fail.

The following reproducer triggers the problem and explains how/why it
happens in its comments:

  $ cat test-send-unlink.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -f $DEV >/dev/null
  mount $DEV $MNT

  # Create our test files and directory. Inode 259 (file3) has two hard
  # links.
  touch $MNT/file1
  touch $MNT/file2
  touch $MNT/file3

  mkdir $MNT/A
  ln $MNT/file3 $MNT/A/hard_link

  # Filesystem looks like:
  #
  # .                                     (ino 256)
  # |----- file1                          (ino 257)
  # |----- file2                          (ino 258)
  # |----- file3                          (ino 259)
  # |----- A/                             (ino 260)
  #        |---- hard_link                (ino 259)
  #

  # Now create the base snapshot, which is going to be the parent snapshot
  # for a later incremental send.
  btrfs subvolume snapshot -r $MNT $MNT/snap1
  btrfs send -f /tmp/snap1.send $MNT/snap1

  # Move inode 257 into directory inode 260. This results in computing the
  # path for inode 260 as "/A" and caching it.
  mv $MNT/file1 $MNT/A/file1

  # Move inode 258 (file2) into directory inode 260, with a name of
  # "hard_link", moving first inode 259 away since it currently has that
  # location and name.
  mv $MNT/A/hard_link $MNT/tmp
  mv $MNT/file2 $MNT/A/hard_link

  # Now rename inode 260 to something else (B for example) and then create
  # a hard link for inode 258 that has the old name and location of inode
  # 260 ("/A").
  mv $MNT/A $MNT/B
  ln $MNT/B/hard_link $MNT/A

  # Filesystem now looks like:
  #
  # .                                     (ino 256)
  # |----- tmp                            (ino 259)
  # |----- file3                          (ino 259)
  # |----- B/                             (ino 260)
  # |      |---- file1                    (ino 257)
  # |      |---- hard_link                (ino 258)
  # |
  # |----- A                              (ino 258)

  # Create another snapshot of our subvolume and use it for an incremental
  # send.
  btrfs subvolume snapshot -r $MNT $MNT/snap2
  btrfs send -f /tmp/snap2.send -p $MNT/snap1 $MNT/snap2

  # Now unmount the filesystem, create a new one, mount it and try to
  # apply both send streams to recreate both snapshots.
  umount $DEV

  mkfs.btrfs -f $DEV >/dev/null

  mount $DEV $MNT

  # First add the first snapshot to the new filesystem by applying the
  # first send stream.
  btrfs receive -f /tmp/snap1.send $MNT

  # The incremental receive operation below used to fail with the
  # following error:
  #
  #    ERROR: unlink A/hard_link failed: No such file or directory
  #
  # This is because when send is processing inode 257, it generates the
  # path for inode 260 as "/A", since that inode is its parent in the send
  # snapshot, and caches that path.
  #
  # Later when processing inode 258, it first processes its new reference
  # that has the path of "/A", which results in orphanizing inode 260
  # because there is a a path collision. This results in issuing a rename
  # operation from "/A" to "/o260-6-0".
  #
  # Finally when processing the new reference "B/hard_link" for inode 258,
  # it notices that it collides with inode 259 (not yet processed, because
  # it has a higher inode number), since that inode has the name
  # "hard_link" under the directory inode 260. It also checks that inode
  # 259 has two hardlinks, so it decides to issue a unlink operation for
  # the name "hard_link" for inode 259. However the path passed to the
  # unlink operation is "/A/hard_link", which is incorrect since currently
  # "/A" does not exists, due to the orphanization of inode 260 mentioned
  # before. The path is incorrect because it was computed and cached
  # before the orphanization. This results in the receiver to fail with
  # the above error.
  btrfs receive -f /tmp/snap2.send $MNT

  umount $MNT

When running the test, it fails like this:

  $ ./test-send-unlink.sh
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap1'
  At subvol /mnt/sdi/snap1
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap2'
  At subvol /mnt/sdi/snap2
  At subvol snap1
  At snapshot snap2
  ERROR: unlink A/hard_link failed: No such file or directory

Fix this by recomputing a path before issuing an unlink operation when
processing the new references for the current inode if we previously
have orphanized a directory.

A test case for fstests will follow soon.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index bd69db72acc5..a2b3c594379d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4064,6 +4064,17 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 				if (ret < 0)
 					goto out;
 			} else {
+				/*
+				 * If we previously orphanized a directory that
+				 * collided with a new reference that we already
+				 * processed, recompute the current path because
+				 * that directory may be part of the path.
+				 */
+				if (orphanized_dir) {
+					ret = refresh_ref_path(sctx, cur);
+					if (ret < 0)
+						goto out;
+				}
 				ret = send_unlink(sctx, cur->full_path);
 				if (ret < 0)
 					goto out;

