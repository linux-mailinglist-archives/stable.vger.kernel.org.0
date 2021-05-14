Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6FA380A99
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 15:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhENNqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 09:46:07 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:57749 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhENNqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 09:46:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8A1EE194059F;
        Fri, 14 May 2021 09:44:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 14 May 2021 09:44:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PjXznB
        xK/k/otA4c64cFJbr+Y6s1J+sEvqVmn1S0sHA=; b=uHu0fSWadA4Wv8xlGMc/vF
        UOQlDKknVqgi3gSaz+h8AzbJuwaX47xuOU9Nr7I1CZL4eeiQVas43GEigtDqwD3E
        gJe4DJU6CVDKC/ZExLBBEpSQZfbq00LXWywVLHvhPrqpxsXawtlXFcdtHtwXxlxg
        0MzF1hFZwBqBBUsZv2HAw42dx/TtqfA+G8R1rNEIIi8vJ+WzOImb6oZj0fFLrkEr
        fVEkMTv5Ll+brG3dsxZuqAoSLLKHimji0LR+CaD9sLxL1+0bQnS4pHw66GYf7u76
        XVAMOadmyZAXjnDtCIsLLBAAKcH+S+L+xzgvisf7nXdbvpa7DOP0akymp5EoQPCQ
        ==
X-ME-Sender: <xms:136eYC_83bFx3JarguD-1dbmgSsz6BUpvheJ_HINfb9HNi8a0bms1w>
    <xme:136eYCu2YLGETdngcZnjQGckPLc312w1jvWyfSa_6BEKfW-qYc2ScpWWtGQdw-qbV
    YeaEC5aECnkpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehjedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:136eYICK3JpjI5MgOI_R9dmNTJsUalAIwbKat65SbH_VOM8ltxaang>
    <xmx:136eYKdkOQf0KhBjmnTV30nzTdoV4HpqKeaE1O8RPZZOe0FMGn-uqQ>
    <xmx:136eYHOpFXyVUN2zkXiUsR0jTp0m2dk2Cl6GzvDIeexdQR1unyfdOQ>
    <xmx:136eYAZScxpw13RaB1xjOg416iHlyU6FdKe219GahFWqQxkwEQaatg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 09:44:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix unmountable seed device after fstrim" failed to apply to 5.4-stable tree
To:     anand.jain@oracle.com, dsterba@suse.com, fdmanana@suse.com,
        lists@colorremedies.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 15:44:49 +0200
Message-ID: <16209998898217@kroah.com>
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

