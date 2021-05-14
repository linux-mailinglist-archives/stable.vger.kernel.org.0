Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011A6380A96
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 15:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhENNp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 09:45:59 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:50383 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230142AbhENNp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 09:45:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3867819408C0;
        Fri, 14 May 2021 09:44:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 14 May 2021 09:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+K56nN
        BekC/9xzaMi0eh2dfYBnZxp+6HBA2WS3zCuQM=; b=k9D4yaIUMoEZ22r5cPzqGL
        8XT0X3/+hI1i//gx8uEN4HmMUT9ePsxIbjUYfORVhg74VV8IQX1wrWP9VfPYv0Ja
        iQ96YQSxGh9XGRfUB4eSssTSEWzkpZbNE03aODrRyxmhcXzgruJbdyjVbRPgVzV3
        lqu0H/dA/h8FIUhZ+HMEbPvGZHefODRufSpWR61ctu0Qk+tZuCY3is2hgW3BtsHq
        MZFpqyDdydpl+KIrNDmkIkSCsOyPPn8CLOqlM9KP3LvGOjAqiuYNYZO/QkvGUV1c
        K92gyYdB1WkTiwm2F0FkjFYxIbGpHBqsoMLYVjjj4hgIglIFq/NW0n62L0OSf+Tw
        ==
X-ME-Sender: <xms:zn6eYDXnnzoedhoRElDt_Lqi-abQ3uNLbaqMK8FmID8XzqxnSb9RSA>
    <xme:zn6eYLkroQINkIfHkNIE-0eVVCwBc9bW6-Ot9PCVlXs3Vb2HOExDkU3pMxftoXHBI
    kfTmVQ3sO6RBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehjedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:zn6eYPYr1J-XLSHfV6ZHCELjEySgkyJ-dt3lZ44bTqCIzdebL7UcAA>
    <xmx:zn6eYOUngcz7yTI2HuF85GlIH4lqdELB-NSluTRfsYMYAwpTXDSp3g>
    <xmx:zn6eYNl-Nbb2INUtrmDW-9TVtQ64xY7EkEPtlBRDb0tdk7kyhW3RyA>
    <xmx:zn6eYCwu1o98R5VCWxSM2EFg632pUBk72scQIatngBALYvQrd4O42Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 09:44:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix unmountable seed device after fstrim" failed to apply to 4.9-stable tree
To:     anand.jain@oracle.com, dsterba@suse.com, fdmanana@suse.com,
        lists@colorremedies.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 15:44:42 +0200
Message-ID: <16209998823387@kroah.com>
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

