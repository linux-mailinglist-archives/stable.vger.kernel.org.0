Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F6433015F
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhCGNsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:48:42 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39211 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231439AbhCGNsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:48:22 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 315ED1A46;
        Sun,  7 Mar 2021 08:48:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:48:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IhjcGp
        uXlwrL+C2Vf4gE7bJC/RFeTE3M9f2QO0J1Ax4=; b=tjCS8AFUkjEv0kXVZcGU2c
        fa9j8/98onWCfDAf2PhywfYQDQHzu2b/RYLVGc3LyWtOVUXASWE/5fwSSpCO8BOn
        jYFaoxAMX0YraGQewYxTUUUN9/0pYRBrlgbRXvJEhObX8Ik4sgnNJOhnyJqzKHmM
        zMYpahGOdN9MJ4x4nxhO2N//LJAi0Jf0CbgRCyIKYUSCPZKbFUJ5J8xY3skBbO+o
        y4a0eYqfdoeMejCI5FNq0vuetB4BxR0kRJQsH1vKj3Ww+l0ZoWepPhvedeaVs0jH
        beFXVX0FVYUeAaCymMLgmvEJ+L9H77X0nh6UiPAhts2s6STBkRmJpnTucIeL/5nQ
        ==
X-ME-Sender: <xms:pdlEYKn0cNkcZ4XZ-hjCLEu8nlr1EoGJD7TpNV2qdQ186t9IuLAgdA>
    <xme:pdlEYB0eqnIgsNSSZkNXRJzMS2rXDHxv_to9Yqa4k7Kb9QdxR3gOJ8xgih2g5fGOs
    F0hRY8s3kIz5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:pdlEYIo4mYloXSGFd36GQaYVYHbkO8q65vPPmbkjS5xWCKGMI3xYnA>
    <xmx:pdlEYOl6JE8beEoO7TuhvlFKRCu1pqldVlzVwbGTYUzpoOSVwcXKyQ>
    <xmx:pdlEYI1vBRIt_4LW8V_SZYOmH9yi-pW5-_d1CWdhdY9h6Ec3EhPSAQ>
    <xmx:pdlEYF-aDnITGTHg_rRD3vqZBisUMNLCTTOOHvNEXHIfKvLHJBWiNa_6A3Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7BE8B240054;
        Sun,  7 Mar 2021 08:48:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix stale data exposure after cloning a hole with" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:48:20 +0100
Message-ID: <1615124900162136@kroah.com>
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

From 3660d0bcdb82807d434da9d2e57d88b37331182d Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Tue, 16 Feb 2021 11:09:25 +0000
Subject: [PATCH] btrfs: fix stale data exposure after cloning a hole with
 NO_HOLES enabled

When using the NO_HOLES feature, if we clone a file range that spans only
a hole into a range that is at or beyond the current i_size of the
destination file, we end up not setting the full sync runtime flag on the
inode. As a result, if we then fsync the destination file and have a power
failure, after log replay we can end up exposing stale data instead of
having a hole for that range.

The conditions for this to happen are the following:

1) We have a file with a size of, for example, 1280K;

2) There is a written (non-prealloc) extent for the file range from 1024K
   to 1280K with a length of 256K;

3) This particular file extent layout is durably persisted, so that the
   existing superblock persisted on disk points to a subvolume root where
   the file has that exact file extent layout and state;

4) The file is truncated to a smaller size, to an offset lower than the
   start offset of its last extent, for example to 800K. The truncate sets
   the full sync runtime flag on the inode;

6) Fsync the file to log it and clear the full sync runtime flag;

7) Clone a region that covers only a hole (implicit hole due to NO_HOLES)
   into the file with a destination offset that starts at or beyond the
   256K file extent item we had - for example to offset 1024K;

8) Since the clone operation does not find extents in the source range,
   we end up in the if branch at the bottom of btrfs_clone() where we
   punch a hole for the file range starting at offset 1024K by calling
   btrfs_replace_file_extents(). There we end up not setting the full
   sync flag on the inode, because we don't know we are being called in
   a clone context (and not fallocate's punch hole operation), and
   neither do we create an extent map to represent a hole because the
   requested range is beyond eof;

9) A further fsync to the file will be a fast fsync, since the clone
   operation did not set the full sync flag, and therefore it relies on
   modified extent maps to correctly log the file layout. But since
   it does not find any extent map marking the range from 1024K (the
   previous eof) to the new eof, it does not log a file extent item
   for that range representing the hole;

10) After a power failure no hole for the range starting at 1024K is
   punched and we end up exposing stale data from the old 256K extent.

Turning this into exact steps:

  $ mkfs.btrfs -f -O no-holes /dev/sdi
  $ mount /dev/sdi /mnt

  # Create our test file with 3 extents of 256K and a 256K hole at offset
  # 256K. The file has a size of 1280K.
  $ xfs_io -f -s \
              -c "pwrite -S 0xab -b 256K 0 256K" \
              -c "pwrite -S 0xcd -b 256K 512K 256K" \
              -c "pwrite -S 0xef -b 256K 768K 256K" \
              -c "pwrite -S 0x73 -b 256K 1024K 256K" \
              /mnt/sdi/foobar

  # Make sure it's durably persisted. We want the last committed super
  # block to point to this particular file extent layout.
  sync

  # Now truncate our file to a smaller size, falling within a position of
  # the second extent. This sets the full sync runtime flag on the inode.
  # Then fsync the file to log it and clear the full sync flag from the
  # inode. The third extent is no longer part of the file and therefore
  # it is not logged.
  $ xfs_io -c "truncate 800K" -c "fsync" /mnt/foobar

  # Now do a clone operation that only clones the hole and sets back the
  # file size to match the size it had before the truncate operation
  # (1280K).
  $ xfs_io \
        -c "reflink /mnt/foobar 256K 1024K 256K" \
        -c "fsync" \
        /mnt/foobar

  # File data before power failure:
  $ od -A d -t x1 /mnt/foobar
  0000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab
  *
  0262144 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  *
  0524288 cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd
  *
  0786432 ef ef ef ef ef ef ef ef ef ef ef ef ef ef ef ef
  *
  0819200 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  *
  1310720

  <power fail>

  # Mount the fs again to replay the log tree.
  $ mount /dev/sdi /mnt

  # File data after power failure:
  $ od -A d -t x1 /mnt/foobar
  0000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab
  *
  0262144 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  *
  0524288 cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd
  *
  0786432 ef ef ef ef ef ef ef ef ef ef ef ef ef ef ef ef
  *
  0819200 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  *
  1048576 73 73 73 73 73 73 73 73 73 73 73 73 73 73 73 73
  *
  1310720

The range from 1024K to 1280K should correspond to a hole but instead it
points to stale data, to the 256K extent that should not exist after the
truncate operation.

The issue does not exists when not using NO_HOLES, because for that case
we use file extent items to represent holes, these are found and copied
during the loop that iterates over extents at btrfs_clone(), and that
causes btrfs_replace_file_extents() to be called with a non-NULL
extent_info argument and therefore set the full sync runtime flag on the
inode.

So fix this by making the code that deals with a trailing hole during
cloning, at btrfs_clone(), to set the full sync flag on the inode, if the
range starts at or beyond the current i_size.

A test case for fstests will follow soon.

Backporting notes: for kernel 5.4 the change goes to ioctl.c into
btrfs_clone before the last call to btrfs_punch_hole_range.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index b24396cf2f99..5413578d2c32 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -553,6 +553,24 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		 */
 		btrfs_release_path(path);
 
+		/*
+		 * When using NO_HOLES and we are cloning a range that covers
+		 * only a hole (no extents) into a range beyond the current
+		 * i_size, punching a hole in the target range will not create
+		 * an extent map defining a hole, because the range starts at or
+		 * beyond current i_size. If the file previously had an i_size
+		 * greater than the new i_size set by this clone operation, we
+		 * need to make sure the next fsync is a full fsync, so that it
+		 * detects and logs a hole covering a range from the current
+		 * i_size to the new i_size. If the clone range covers extents,
+		 * besides a hole, then we know the full sync flag was already
+		 * set by previous calls to btrfs_replace_file_extents() that
+		 * replaced file extent items.
+		 */
+		if (last_dest_end >= i_size_read(inode))
+			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+				&BTRFS_I(inode)->runtime_flags);
+
 		ret = btrfs_replace_file_extents(inode, path, last_dest_end,
 				destoff + len - 1, NULL, &trans);
 		if (ret)

