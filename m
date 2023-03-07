Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1241F6ADAD1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjCGJrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjCGJrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:47:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D7B5BCBC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:46:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90243612A0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F870C4339B;
        Tue,  7 Mar 2023 09:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182418;
        bh=nBNtZMljxrXim9BYmomE+VBxv51Erw8KOWdWKDJIsOw=;
        h=Subject:To:Cc:From:Date:From;
        b=hkbxdqOt6hwWSLDSYrHiqP5T+aRQSFXrGQVS4aV3JzNCFqhfqsG9AhZf8skj5HvGh
         iwQe4VjDs3Ysiqu1yIDVleeGIk3Hdzaf/kifdGKpijuCQkqWzJFd8dQFNyDDtS6EiR
         yHlJQGYr5L4lXK+Z+fzP5BJW/zUP6bicQY9G/+/s=
Subject: FAILED: patch "[PATCH] block: fix scan partition for exclusively open device again" failed to apply to 5.15-stable tree
To:     yukuai3@huawei.com, axboe@kernel.dk, hch@lst.de, jack@suse.cz,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:46:55 +0100
Message-ID: <167818241553113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x e5cfefa97bccf956ea0bb6464c1f6c84fd7a8d9f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167818241553113@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

e5cfefa97bcc ("block: fix scan partition for exclusively open device again")
0f77b29ad14e ("block: Revert "block: Do not reread partition table on exclusively open device"")
36369f46e917 ("block: Do not reread partition table on exclusively open device")
704b914f15fb ("blk-mq: move srcu from blk_mq_hw_ctx to request_queue")
2a904d00855f ("blk-mq: remove hctx_lock and hctx_unlock")
1e9c23034d7b ("blk-mq: move more plug handling from blk_mq_submit_bio into blk_add_rq_to_plug")
0c5bcc92d94a ("blk-mq: simplify the plug handling in blk_mq_submit_bio")
e16e506ccd67 ("block: merge disk_scan_partitions and blkdev_reread_part")
95febeb61bf8 ("block: fix missing queue put in error path")
b637108a4022 ("blk-mq: fix filesystem I/O request allocation")
b131f2011115 ("blk-mq: rename blk_attempt_bio_merge")
9ef4d0209cba ("blk-mq: add one API for waiting until quiesce is done")
900e08075202 ("block: move queue enter logic into blk_mq_submit_bio()")
c98cb5bbdab1 ("block: make bio_queue_enter() fast-path available inline")
71539717c105 ("block: split request allocation components into helpers")
a1cb65377e70 ("blk-mq: only try to run plug merge if request has same queue with incoming bio")
781dd830ec4f ("block: move RQF_ELV setting into allocators")
a2247f19ee1c ("block: Add independent access ranges support")
e94f68527a35 ("block: kill extra rcu lock/unlock in queue enter")
179ae84f7ef5 ("block: clean up blk_mq_submit_bio() merging")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e5cfefa97bccf956ea0bb6464c1f6c84fd7a8d9f Mon Sep 17 00:00:00 2001
From: Yu Kuai <yukuai3@huawei.com>
Date: Fri, 17 Feb 2023 10:22:00 +0800
Subject: [PATCH] block: fix scan partition for exclusively open device again

As explained in commit 36369f46e917 ("block: Do not reread partition table
on exclusively open device"), reread partition on the device that is
exclusively opened by someone else is problematic.

This patch will make sure partition scan will only be proceed if current
thread open the device exclusively, or the device is not opened
exclusively, and in the later case, other scanners and exclusive openers
will be blocked temporarily until partition scan is done.

Fixes: 10c70d95c0f2 ("block: remove the bd_openers checks in blk_drop_partitions")
Cc: <stable@vger.kernel.org>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230217022200.3092987-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/genhd.c b/block/genhd.c
index 820e27d88cbf..c0a73cd76bb1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -359,6 +359,7 @@ EXPORT_SYMBOL_GPL(disk_uevent);
 int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device *bdev;
+	int ret = 0;
 
 	if (disk->flags & (GENHD_FL_NO_PART | GENHD_FL_HIDDEN))
 		return -EINVAL;
@@ -368,11 +369,27 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 		return -EBUSY;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
-	bdev = blkdev_get_by_dev(disk_devt(disk), mode, NULL);
+	/*
+	 * If the device is opened exclusively by current thread already, it's
+	 * safe to scan partitons, otherwise, use bd_prepare_to_claim() to
+	 * synchronize with other exclusive openers and other partition
+	 * scanners.
+	 */
+	if (!(mode & FMODE_EXCL)) {
+		ret = bd_prepare_to_claim(disk->part0, disk_scan_partitions);
+		if (ret)
+			return ret;
+	}
+
+	bdev = blkdev_get_by_dev(disk_devt(disk), mode & ~FMODE_EXCL, NULL);
 	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
-	blkdev_put(bdev, mode);
-	return 0;
+		ret =  PTR_ERR(bdev);
+	else
+		blkdev_put(bdev, mode);
+
+	if (!(mode & FMODE_EXCL))
+		bd_abort_claiming(disk->part0, disk_scan_partitions);
+	return ret;
 }
 
 /**
@@ -494,6 +511,11 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 		if (ret)
 			goto out_unregister_bdi;
 
+		/* Make sure the first partition scan will be proceed */
+		if (get_capacity(disk) && !(disk->flags & GENHD_FL_NO_PART) &&
+		    !test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+			set_bit(GD_NEED_PART_SCAN, &disk->state);
+
 		bdev_add(disk->part0, ddev->devt);
 		if (get_capacity(disk))
 			disk_scan_partitions(disk, FMODE_READ);
diff --git a/block/ioctl.c b/block/ioctl.c
index 6dd49d877584..9c5f637ff153 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -528,7 +528,7 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 			return -EACCES;
 		if (bdev_is_partition(bdev))
 			return -EINVAL;
-		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL);
+		return disk_scan_partitions(bdev->bd_disk, mode);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:

