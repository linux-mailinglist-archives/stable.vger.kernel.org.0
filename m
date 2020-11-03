Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B968C2A4710
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgKCN5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:57:49 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:50411 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729298AbgKCN4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:56:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9C3D2788;
        Tue,  3 Nov 2020 08:56:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 08:56:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+vEUMB
        th6z8380VA6oXRSGCHVyKEZIusV6f+QCXozRY=; b=XtN/NgCiceNV3AoBu09ZQd
        yQAq1st9r753NZFV2difA47rDS33tNXLK9gDeLVe9G1NRMREU4Q0h+uYEc60NjQa
        Bcv4u1eOthbRbzlmWcqb+9oJizOQbfE2pkIBQa+f3XkBbkwhi04Au5PgJJoT2OeX
        a2I3oCOg8yWq/ye1+uo875sP+/UnnXD0bFrmNscY9S06qbY+SVmlMcfVBbq6lyKA
        QFLzxuPGtCjR7gSESrIRCMV6cwwqaW4GkfwU+1ecBqVRzrBUhu7nQc4K0zoTjYu5
        uZI/iIKhaA1BRY/07mLDIMAR8ZtMceMP/zw3/TTOyaScmvVaXgiMgvxmlGZKkcYA
        ==
X-ME-Sender: <xms:pGGhX9OrRQ_jFOMX_HIBG0NNkMNmuEcoRUf7sF5bMGBzRdoZjVzGQQ>
    <xme:pGGhX__Wg8H7hj_9lfRHEdo7uOaDc7XrcEWmYu3IGKXjy4WP1d4yoOAUVTQX0zQph
    H7aRZp7SP0tvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:pGGhX8T8vyQJRCOppklMyZ5xuhkVQhPiq-yMWdVPvUMA0HxMHXSXtA>
    <xmx:pGGhX5sjamTamqXnK2TZ51M1eGeZhmh25E2rPH2h0_oDu-fHYnMuOA>
    <xmx:pGGhX1cvVpY0RcMN3ZlyJ_bpaySu0iGz75WlQjaOZMlR9VBnF3sJyQ>
    <xmx:pGGhX1HniWOZAOJeZFpgQozFxm0ZZZH4p54sBb6OR9SQCHcZNElK8FjYJ8Y>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C4957328005D;
        Tue,  3 Nov 2020 08:56:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: skip devices without magic signature when mounting" failed to apply to 5.4-stable tree
To:     anand.jain@oracle.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 14:57:46 +0100
Message-ID: <16044118666099@kroah.com>
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

