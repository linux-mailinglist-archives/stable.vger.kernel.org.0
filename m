Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6FF4D8370
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiCNMOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240870AbiCNMNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:13:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0474237A33;
        Mon, 14 Mar 2022 05:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81E596139D;
        Mon, 14 Mar 2022 12:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD51FC340E9;
        Mon, 14 Mar 2022 12:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259879;
        bh=A24FmMd7vt1lS1maBrE5RGj5ZNFwkVthlWYuCHVRsow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1E+PIUOsEiQze+Jod9ffEGahkwBnn481rIFb9Nz1/sqLFUC2VeJD2AwpwyFGG+/B0
         vC+wlq/D0TLr2nYzv1wrgXcV1x/xou4QNHYQnNyJID5tjOU85oZqAoi+XU21XNTubB
         AUmC61bl+yaoUdlNzKeCwsUCpxclX85Kcq3GXOeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.15 109/110] block: drop unused includes in <linux/genhd.h>
Date:   Mon, 14 Mar 2022 12:54:51 +0100
Message-Id: <20220314112746.068969821@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit b81e0c2372e65e5627864ba034433b64b2fc73f5 upstream.

Drop various include not actually used in genhd.h itself, and
move the remaning includes closer together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20210920123328.1399408-15-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>a
Reported-by: "H. Nikolaus Schaller" <hns@goldelico.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
[ resolves MIPS build failure by luck, root cause needs to be fixed in
  Linus's tree properly, but this is needed for now to fix the build - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/ubd_kern.c      |    1 +
 block/genhd.c                   |    1 +
 block/holder.c                  |    1 +
 block/partitions/core.c         |    1 +
 drivers/block/amiflop.c         |    1 +
 drivers/block/ataflop.c         |    1 +
 drivers/block/floppy.c          |    1 +
 drivers/block/swim.c            |    1 +
 drivers/block/xen-blkfront.c    |    1 +
 drivers/md/md.c                 |    1 +
 drivers/s390/block/dasd_genhd.c |    1 +
 drivers/scsi/sd.c               |    1 +
 drivers/scsi/sg.c               |    1 +
 drivers/scsi/sr.c               |    1 +
 drivers/scsi/st.c               |    1 +
 include/linux/genhd.h           |   14 ++------------
 include/linux/part_stat.h       |    1 +
 17 files changed, 18 insertions(+), 12 deletions(-)

--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -27,6 +27,7 @@
 #include <linux/blk-mq.h>
 #include <linux/ata.h>
 #include <linux/hdreg.h>
+#include <linux/major.h>
 #include <linux/cdrom.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/kmod.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/log2.h>
--- a/block/holder.c
+++ b/block/holder.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/genhd.h>
+#include <linux/slab.h>
 
 struct bd_holder_disk {
 	struct list_head	list;
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2020 Christoph Hellwig
  */
 #include <linux/fs.h>
+#include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -61,6 +61,7 @@
 #include <linux/hdreg.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/fs.h>
 #include <linux/blk-mq.h>
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -68,6 +68,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/blk-mq.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
 #include <linux/wait.h>
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -184,6 +184,7 @@ static int print_unex = 1;
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/major.h>
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/mutex.h>
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -16,6 +16,7 @@
 #include <linux/fd.h>
 #include <linux/slab.h>
 #include <linux/blk-mq.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/hdreg.h>
 #include <linux/kernel.h>
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -42,6 +42,7 @@
 #include <linux/cdrom.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <linux/bitmap.h>
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -51,6 +51,7 @@
 #include <linux/hdreg.h>
 #include <linux/proc_fs.h>
 #include <linux/random.h>
+#include <linux/major.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/file.h>
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -14,6 +14,7 @@
 #define KMSG_COMPONENT "dasd"
 
 #include <linux/interrupt.h>
+#include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/blkpg.h>
 
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -48,6 +48,7 @@
 #include <linux/blkpg.h>
 #include <linux/blk-pm.h>
 #include <linux/delay.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 #include <linux/async.h>
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -31,6 +31,7 @@ static int sg_version_num = 30536;	/* 2
 #include <linux/errno.h>
 #include <linux/mtio.h>
 #include <linux/ioctl.h>
+#include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/fcntl.h>
 #include <linux/init.h>
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -44,6 +44,7 @@
 #include <linux/cdrom.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/major.h>
 #include <linux/blkdev.h>
 #include <linux/blk-pm.h>
 #include <linux/mutex.h>
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -32,6 +32,7 @@ static const char *verstr = "20160209";
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/mtio.h>
+#include <linux/major.h>
 #include <linux/cdrom.h>
 #include <linux/ioctl.h>
 #include <linux/fcntl.h>
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -12,12 +12,10 @@
 
 #include <linux/types.h>
 #include <linux/kdev_t.h>
-#include <linux/rcupdate.h>
-#include <linux/slab.h>
-#include <linux/percpu-refcount.h>
 #include <linux/uuid.h>
 #include <linux/blk_types.h>
-#include <asm/local.h>
+#include <linux/device.h>
+#include <linux/xarray.h>
 
 extern const struct device_type disk_type;
 extern struct device_type part_type;
@@ -26,14 +24,6 @@ extern struct class block_class;
 #define DISK_MAX_PARTS			256
 #define DISK_NAME_LEN			32
 
-#include <linux/major.h>
-#include <linux/device.h>
-#include <linux/smp.h>
-#include <linux/string.h>
-#include <linux/fs.h>
-#include <linux/workqueue.h>
-#include <linux/xarray.h>
-
 #define PARTITION_META_INFO_VOLNAMELTH	64
 /*
  * Enough for the string representation of any kind of UUID plus NULL.
--- a/include/linux/part_stat.h
+++ b/include/linux/part_stat.h
@@ -3,6 +3,7 @@
 #define _LINUX_PART_STAT_H
 
 #include <linux/genhd.h>
+#include <asm/local.h>
 
 struct disk_stats {
 	u64 nsecs[NR_STAT_GROUPS];


