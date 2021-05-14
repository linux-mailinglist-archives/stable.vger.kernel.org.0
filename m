Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1F380A97
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 15:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhENNqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 09:46:00 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:43111 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230330AbhENNp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 09:45:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1188B194032B;
        Fri, 14 May 2021 09:44:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 14 May 2021 09:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WZCEXw
        SrtcEqBOoBMsu9eMYW4BV+yopxeVo7pZkd9Gc=; b=qFHOA6iM9oDuAZeu97eK74
        8CaUZ7FU1WvM7C/QXcTvfKBkXMFe+zjj/8uD8RWbCqmibV7w6RM2GTWyEpYKnFSh
        hErwUB4kyot1X7138SH0nnBTcX7bIQvncR+QiDpOwWjaD+46SbFd3LYNu328GqAc
        HoaYqeUIf9+0etCPC0U5+Ga+BoOJpEG9xoEar8U+5y6PDf5Q5I4cI+dUNs4yoKPy
        NeY5kw61LK1o1lfLE7jkz71n6EK1b8UNJE8eX5vvIv0wfLWLLvbl5LEMKd4Ff4u1
        PxcV0GO8zDLJcW4DiCCVS1aLEHep6fQXZRh/ZCLmKQDJEMs5Yvi4pZf5aaSYUjYw
        ==
X-ME-Sender: <xms:z36eYCq5VtZNL2PDTGbm5Pi1mq0xd6oAnAY5YmMzFT5Q8ZHgYNfUvw>
    <xme:z36eYAqv9pMcgWtpqoljsO6d2vxU9YddGA9tQbAASHMuLt__VDSy6zKTa18xeH1c7
    TzFE6ngjN5d1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehjedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:z36eYHPb46HRyThrOk9CDjsoYq9-Rll5Ytu2iYQy6IJ4PrFPrGjDBA>
    <xmx:z36eYB4uFfJNVR1x6K6qybOwnHXoRBcevWJUJe4aOLKIzSH0KUsbaQ>
    <xmx:z36eYB5bX94aTBWM-JnqhaAkME_owobckdP31RcYwRn0pS2CUa0qyw>
    <xmx:0H6eYBFuA27MsXHrwlg9asjbiqHA7FevIG-eUH0RVzdmnAmS4k6S1A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 09:44:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix unmountable seed device after fstrim" failed to apply to 4.14-stable tree
To:     anand.jain@oracle.com, dsterba@suse.com, fdmanana@suse.com,
        lists@colorremedies.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 15:44:44 +0200
Message-ID: <1620999884126219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5e753a817b2d5991dfe8a801b7b1e8e79a1c5a20 Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Fri, 30 Apr 2021 19:59:51 +0800
Subject: [PATCH] btrfs: fix unmountable seed device after fstrim

The following test case reproduces an issue of wrongly freeing in-use
blocks on the readonly seed device when fstrim is called on the rw sprout
device. As shown below.

Create a seed device and add a sprout device to it:

  $ mkfs.btrfs -fq -dsingle -msingle /dev/loop0
  $ btrfstune -S 1 /dev/loop0
  $ mount /dev/loop0 /btrfs
  $ btrfs dev add -f /dev/loop1 /btrfs
  BTRFS info (device loop0): relocating block group 290455552 flags system
  BTRFS info (device loop0): relocating block group 1048576 flags system
  BTRFS info (device loop0): disk added /dev/loop1
  $ umount /btrfs

Mount the sprout device and run fstrim:

  $ mount /dev/loop1 /btrfs
  $ fstrim /btrfs
  $ umount /btrfs

Now try to mount the seed device, and it fails:

  $ mount /dev/loop0 /btrfs
  mount: /btrfs: wrong fs type, bad option, bad superblock on /dev/loop0, missing codepage or helper program, or other error.

Block 5292032 is missing on the readonly seed device:

 $ dmesg -kt | tail
 <snip>
 BTRFS error (device loop0): bad tree block start, want 5292032 have 0
 BTRFS warning (device loop0): couldn't read-tree root
 BTRFS error (device loop0): open_ctree failed

From the dump-tree of the seed device (taken before the fstrim). Block
5292032 belonged to the block group starting at 5242880:

  $ btrfs inspect dump-tree -e /dev/loop0 | grep -A1 BLOCK_GROUP
  <snip>
  item 3 key (5242880 BLOCK_GROUP_ITEM 8388608) itemoff 16169 itemsize 24
  	block group used 114688 chunk_objectid 256 flags METADATA
  <snip>

From the dump-tree of the sprout device (taken before the fstrim).
fstrim used block-group 5242880 to find the related free space to free:

  $ btrfs inspect dump-tree -e /dev/loop1 | grep -A1 BLOCK_GROUP
  <snip>
  item 1 key (5242880 BLOCK_GROUP_ITEM 8388608) itemoff 16226 itemsize 24
  	block group used 32768 chunk_objectid 256 flags METADATA
  <snip>

BPF kernel tracing the fstrim command finds the missing block 5292032
within the range of the discarded blocks as below:

  kprobe:btrfs_discard_extent {
  	printf("freeing start %llu end %llu num_bytes %llu:\n",
  		arg1, arg1+arg2, arg2);
  }

  freeing start 5259264 end 5406720 num_bytes 147456
  <snip>

Fix this by avoiding the discard command to the readonly seed device.

Reported-by: Chris Murphy <lists@colorremedies.com>
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7a28314189b4..f1d15b68994a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1340,12 +1340,16 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 		stripe = bbio->stripes;
 		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
 			u64 bytes;
+			struct btrfs_device *device = stripe->dev;
 
-			if (!stripe->dev->bdev) {
+			if (!device->bdev) {
 				ASSERT(btrfs_test_opt(fs_info, DEGRADED));
 				continue;
 			}
 
+			if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
+				continue;
+
 			ret = do_discard_extent(stripe, &bytes);
 			if (!ret) {
 				discarded_bytes += bytes;

