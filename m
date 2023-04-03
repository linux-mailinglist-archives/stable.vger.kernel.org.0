Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9AF6D3E94
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjDCIGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDCIGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:06:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E3C10E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD74ECE0EE9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4500C433D2;
        Mon,  3 Apr 2023 08:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680509196;
        bh=9pZrVC2Rq73Akut8p4lAHDlKF22O5pBfA7Pqa9mDKWY=;
        h=Subject:To:Cc:From:Date:From;
        b=kzY35gF1fHQUAUvG4NmK/4sC3o0vf1pGAKFvSeOz+KV+F5OU2wLDIGq0xvOMONGKB
         2I/4HI/Vv0DTLk7EXgkz6RydKoyBqaMvdbm/qY+QVUy6SHDjLGl4p26ZBZRtb2uicF
         oRb63hym7cQBDTCwItsOm43S2JMnaKxgBn91k1sI=
Subject: FAILED: patch "[PATCH] btrfs: scan device in non-exclusive mode" failed to apply to 5.4-stable tree
To:     anand.jain@oracle.com, dsterba@suse.com, oliver.sang@intel.com,
        sherry.yang@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:06:33 +0200
Message-ID: <2023040333-vanquish-wriggle-e007@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 50d281fc434cb8e2497f5e70a309ccca6b1a09f0
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040333-vanquish-wriggle-e007@gregkh' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

50d281fc434c ("btrfs: scan device in non-exclusive mode")
12659251ca5d ("btrfs: implement log-structured superblock for ZONED mode")
5d1ab66c56fe ("btrfs: disallow space_cache in ZONED mode")
b70f509774ad ("btrfs: check and enable ZONED mode")
5b316468983d ("btrfs: get zone information of zoned block devices")
bacce86ae8a7 ("btrfs: drop unused argument step from btrfs_free_extra_devids")
96c2e067ed3e ("btrfs: skip devices without magic signature when mounting")
c3e1f96c37d0 ("btrfs: enumerate the type of exclusive operation in progress")
944d3f9fac61 ("btrfs: switch seed device to list api")
c4989c2fd0eb ("btrfs: simplify setting/clearing fs_info to btrfs_fs_devices")
54eed6ae8d8e ("btrfs: make close_fs_devices return void")
3712ccb7f1cc ("btrfs: factor out loop logic from btrfs_free_extra_devids")
dc0ab488d2cb ("btrfs: factor out reada loop in __reada_start_machine")
adca4d945c8d ("btrfs: qgroup: remove ASYNC_COMMIT mechanism in favor of reserve retry-after-EDQUOT")
3092c68fc58c ("btrfs: sysfs: add bdi link to the fsid directory")
998a0671961f ("btrfs: include non-missing as a qualifier for the latest_bdev")
1ed802c972c6 ("btrfs: drop useless goto in open_fs_devices")
b335eab890ed ("btrfs: make btrfs_read_disk_super return struct btrfs_disk_super")
c4a816c67c39 ("btrfs: introduce chunk allocation policy")
9a8658e33d8f ("btrfs: open code trivial helper btrfs_header_fsid")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 50d281fc434cb8e2497f5e70a309ccca6b1a09f0 Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Thu, 23 Mar 2023 15:56:48 +0800
Subject: [PATCH] btrfs: scan device in non-exclusive mode

This fixes mkfs/mount/check failures due to race with systemd-udevd
scan.

During the device scan initiated by systemd-udevd, other user space
EXCL operations such as mkfs, mount, or check may get blocked and result
in a "Device or resource busy" error. This is because the device
scan process opens the device with the EXCL flag in the kernel.

Two reports were received:

 - btrfs/179 test case, where the fsck command failed with the -EBUSY
   error

 - LTP pwritev03 test case, where mkfs.vfs failed with
   the -EBUSY error, when mkfs.vfs tried to overwrite old btrfs filesystem
   on the device.

In both cases, fsck and mkfs (respectively) were racing with a
systemd-udevd device scan, and systemd-udevd won, resulting in the
-EBUSY error for fsck and mkfs.

Reproducing the problem has been difficult because there is a very
small window during which these userspace threads can race to
acquire the exclusive device open. Even on the system where the problem
was observed, the problem occurrences were anywhere between 10 to 400
iterations and chances of reproducing decreases with debug printk()s.

However, an exclusive device open is unnecessary for the scan process,
as there are no write operations on the device during scan. Furthermore,
during the mount process, the superblock is re-read in the below
function call chain:

  btrfs_mount_root
   btrfs_open_devices
    open_fs_devices
     btrfs_open_one_device
       btrfs_get_bdev_and_sb

So, to fix this issue, removes the FMODE_EXCL flag from the scan
operation, and add a comment.

The case where mkfs may still write to the device and a scan is running,
the btrfs signature is not written at that time so scan will not
recognize such device.

Reported-by: Sherry Yang <sherry.yang@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202303170839.fdf23068-oliver.sang@intel.com
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6d0124b6e79e..ac0e8fb92fc8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1366,8 +1366,17 @@ struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
 	 * So, we need to add a special mount option to scan for
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
-	flags |= FMODE_EXCL;
 
+	/*
+	 * Avoid using flag |= FMODE_EXCL here, as the systemd-udev may
+	 * initiate the device scan which may race with the user's mount
+	 * or mkfs command, resulting in failure.
+	 * Since the device scan is solely for reading purposes, there is
+	 * no need for FMODE_EXCL. Additionally, the devices are read again
+	 * during the mount process. It is ok to get some inconsistent
+	 * values temporarily, as the device paths of the fsid are the only
+	 * required information for assembling the volume.
+	 */
 	bdev = blkdev_get_by_path(path, flags, holder);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);

