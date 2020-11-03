Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEC32A4712
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgKCN5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:57:49 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:41383 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729378AbgKCN5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:57:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C24C3C2A;
        Tue,  3 Nov 2020 08:57:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 08:57:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qpBAHa
        gDqbugiCuPCgJfHPcImnFxS8rEnVvUa7gIPgQ=; b=IxgqO/GWLBwp3Gyk3L3vC9
        lCVxGF9HuaJhx1irdTQ7YYqFzT7akheOSRfMc0m3L865HQe+PsEN1Dx1N9l6MpCx
        wVKJ8Y1LGcHBaiNxTQ7Wzub+DST58J+AKfVjSIL8nTnsoIof91v9lwNwPw+GTMIl
        zUEInmWKnKolmdiEaGYXzgorX7uxmky8jhZNVmnpUAkqJ/ASdxx4s9cFMF6oJzy4
        fREoCpYu+1H7jjqOfFZSrtVqflBacvMUckmV86kUdqFfyKgwsfS7MnlyddZo+cfn
        qYz2KBbcnpvfwQ1bEArfSMPObgff3FMiU9shHJzvsMhXNXwaANZ8yAYXxypbZZQg
        ==
X-ME-Sender: <xms:rWGhX1a_cfP3AaZXRKdeWkxaCOh4NQdGgzUfwb_300zC85Wtwt3OUQ>
    <xme:rWGhX8bXkxhvG8srb-ImcW-n65YUYSGqmT5NBnsFgZeXzDdPWQeytx_pofxwb8GUc
    vPtHEoZTnTJPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:rWGhX38bt-BWdEO_YNI7dQcmfemKXx3XZj-PpcbetgyfJlSMUVlaWA>
    <xmx:rWGhXzo7ovCAQKWRGROWDSR3AgTLd7gCSVtNq-vnGDNye8qHZ_VM4w>
    <xmx:rWGhXwoYBVgRuGirTQAgQAswiE26Sg0pGoQRTK2KkD8IdQb9Kilkag>
    <xmx:rWGhX9Cza3jMu9BKW9L8M2WQGJijJzKwxJOL_sGVx74So0TSJoIpnOhI48w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 057CD306467E;
        Tue,  3 Nov 2020 08:57:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: skip devices without magic signature when mounting" failed to apply to 4.19-stable tree
To:     anand.jain@oracle.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 14:57:47 +0100
Message-ID: <160441186710208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 96c2e067ed3e3e004580a643c76f58729206b829 Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Wed, 30 Sep 2020 21:09:52 +0800
Subject: [PATCH] btrfs: skip devices without magic signature when mounting

Many things can happen after the device is scanned and before the device
is mounted.  One such thing is losing the BTRFS_MAGIC on the device.
If it happens we still won't free that device from the memory and cause
the userland confusion.

For example: As the BTRFS_IOC_DEV_INFO still carries the device path
which does not have the BTRFS_MAGIC, 'btrfs fi show' still lists
device which does not belong to the filesystem anymore:

  $ mkfs.btrfs -fq -draid1 -mraid1 /dev/sda /dev/sdb
  $ wipefs -a /dev/sdb
  # /dev/sdb does not contain magic signature
  $ mount -o degraded /dev/sda /btrfs
  $ btrfs fi show -m
  Label: none  uuid: 470ec6fb-646b-4464-b3cb-df1b26c527bd
	  Total devices 2 FS bytes used 128.00KiB
	  devid    1 size 3.00GiB used 571.19MiB path /dev/sda
	  devid    2 size 3.00GiB used 571.19MiB path /dev/sdb

We need to distinguish the missing signature and invalid superblock, so
add a specific error code ENODATA for that. This also fixes failure of
fstest btrfs/198.

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3d39f5d47ad3..764001609a15 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3424,8 +3424,12 @@ struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
 		return ERR_CAST(page);
 
 	super = page_address(page);
-	if (btrfs_super_bytenr(super) != bytenr ||
-		    btrfs_super_magic(super) != BTRFS_MAGIC) {
+	if (btrfs_super_magic(super) != BTRFS_MAGIC) {
+		btrfs_release_disk_super(super);
+		return ERR_PTR(-ENODATA);
+	}
+
+	if (btrfs_super_bytenr(super) != bytenr) {
 		btrfs_release_disk_super(super);
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 46f4efd58652..58b9c419a2b6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1198,17 +1198,23 @@ static int open_fs_devices(struct btrfs_fs_devices *fs_devices,
 {
 	struct btrfs_device *device;
 	struct btrfs_device *latest_dev = NULL;
+	struct btrfs_device *tmp_device;
 
 	flags |= FMODE_EXCL;
 
-	list_for_each_entry(device, &fs_devices->devices, dev_list) {
-		/* Just open everything we can; ignore failures here */
-		if (btrfs_open_one_device(fs_devices, device, flags, holder))
-			continue;
+	list_for_each_entry_safe(device, tmp_device, &fs_devices->devices,
+				 dev_list) {
+		int ret;
 
-		if (!latest_dev ||
-		    device->generation > latest_dev->generation)
+		ret = btrfs_open_one_device(fs_devices, device, flags, holder);
+		if (ret == 0 &&
+		    (!latest_dev || device->generation > latest_dev->generation)) {
 			latest_dev = device;
+		} else if (ret == -ENODATA) {
+			fs_devices->num_devices--;
+			list_del(&device->dev_list);
+			btrfs_free_device(device);
+		}
 	}
 	if (fs_devices->open_devices == 0)
 		return -EINVAL;

