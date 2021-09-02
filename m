Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0ABB3FEF24
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbhIBOIt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 2 Sep 2021 10:08:49 -0400
Received: from mail3.swissbit.com ([176.95.1.57]:33060 "EHLO
        mail3.swissbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbhIBOIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 10:08:47 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2021 10:08:44 EDT
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id A7F66462086;
        Thu,  2 Sep 2021 15:57:14 +0200 (CEST)
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 8CDE446207D;
        Thu,  2 Sep 2021 15:57:14 +0200 (CEST)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail3.swissbit.com (Postfix) with ESMTPS;
        Thu,  2 Sep 2021 15:57:14 +0200 (CEST)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Thu, 2 Sep 2021
 15:57:14 +0200
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0792.015; Thu, 2 Sep 2021 15:57:14 +0200
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] sd: sd_open: prevent device removal during sd_open
Thread-Topic: [PATCH] sd: sd_open: prevent device removal during sd_open
Thread-Index: AQHXoAHu4he04cmBqECW8DEEUakoBQ==
Date:   Thu, 2 Sep 2021 13:57:13 +0000
Message-ID: <98bfca4cbaa24462994bcb533d365414@hyperstone.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.154.1.4]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-8.6.1018-26384.000
X-TMASE-Result: 10--4.691400-10.000000
X-TMASE-MatchedRID: cnNFLnOjrwrzbOda9N/p0UrM69p7lDSsDnVIBRSEqxRUjspoiX02F28C
        jsQp3NpgMB50Ujmy9YkE3B5BW/vdfS+tTtTc2agD3y8BXzybnzxPnKxAOPp4Wb59Yrw3aQCHe6v
        nb9bFMdTZSKc4fEk4dRvYV6pkN/jgUKJZlzyOIwgjCTunWqnclldGlNgipoNlC5L2Og8SQUXlOf
        oLq1j6+Dfttz3MdQ5uFFNUKojE5RNkJbwDA0WnIjiEPRj9j9rvUNr9nJzA3WSExk6c4qzx8s2fh
        /Vuh6xFn27o0Xx1QhZVTvUUakA/KWwxXIAB2+stqJSK+HSPY+/r3E41VlKsfVVkJxysad/ImGTQ
        iVbjdyUCF2h7WO+mNY6C2RetAFWQ6sEU5+BT/F3hPQQVFw3HFIyFtOxfKxTfXs4sv9ryyGM7Q++
        QVT1rUuLzNWBegCW2W+UQGzEy1nULbigRnpKlKWxlRJiH43974nTXLosPHY5slYS54CHCsJNeL6
        cPFMRMBOWNLnOLKpoezy6VHlp0/g==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: 91f1d342-9e76-4ce0-bebf-27fafb0c1b18-0-0-200-0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

sd and parent devices must not be removed as sd_open checks for events

sd_need_revalidate and sd_revalidate_disk traverse the device path
to check for event changes. If during this, e.g. the scsi host is being
removed and its resources freed, this traversal crashes.
Locking with scan_mutex for just a scsi disk open may seem blunt, but there
does not seem to be a more granular option. Also opening /dev/sdX directly
happens rarely enough that this shouldn't cause any issues.

The issue occurred on an older kernel with the following trace:
stack segment: 0000 [#1] PREEMPT SMP PTI
CPU: 1 PID: 121457 Comm: python3 Not tainted 4.14.238hyLinux #1
Hardware name: ASUS All Series/H81M-D, BIOS 0601 02/20/2014
task: ffff888213dbb700 task.stack: ffffc90008c14000
RIP: 0010:kobject_get_path+0x2a/0xe0
...
Call Trace:
kobject_uevent_env+0xe6/0x550
disk_check_events+0x101/0x160
disk_clear_events+0x75/0x100
check_disk_change+0x22/0x60
sd_open+0x70/0x170 [sd_mod]
__blkdev_get+0x3fd/0x4b0
? get_empty_filp+0x57/0x1b0
blkdev_get+0x11b/0x330
? bd_acquire+0xc0/0xc0
do_dentry_open+0x1ef/0x320
? __inode_permission+0x85/0xc0
path_openat+0x5cb/0x1500
? terminate_walk+0xeb/0x100
do_filp_open+0x9b/0x110
? __check_object_size+0xb4/0x190
? do_sys_open+0x1bd/0x250
do_sys_open+0x1bd/0x250
do_syscall_64+0x67/0x120
entry_SYSCALL_64_after_hwframe+0x41/0xa6

and this commit fixed that issue, as there has been no other such
synchronization in place since then, the issue should still be present in
recent kernels.

Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
---
 drivers/scsi/sd.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 610ebba0d66e..ad4da985a473 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1436,6 +1436,16 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
+	/*
+	 * Checking for changes to the device must not race with the device
+	 * or its parent host being removed, so lock until sd_open returns.
+	 */
+	mutex_lock(&sdev->host->scan_mutex);
+	if (sdev->sdev_state != SDEV_RUNNING) {
+		retval = -ERESTARTSYS;
+		goto unlock_scan_error_out;
+	}
+
 	if (sd_need_revalidate(bdev, sdkp))
 		sd_revalidate_disk(bdev->bd_disk);
 
@@ -1444,7 +1454,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	 */
 	retval = -ENOMEDIUM;
 	if (sdev->removable && !sdkp->media_present && !(mode & FMODE_NDELAY))
-		goto error_out;
+		goto unlock_scan_error_out;
 
 	/*
 	 * If the device has the write protect tab set, have the open fail
@@ -1452,7 +1462,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	 */
 	retval = -EROFS;
 	if (sdkp->write_prot && (mode & FMODE_WRITE))
-		goto error_out;
+		goto unlock_scan_error_out;
 
 	/*
 	 * It is possible that the disk changing stuff resulted in
@@ -1462,15 +1472,19 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	 */
 	retval = -ENXIO;
 	if (!scsi_device_online(sdev))
-		goto error_out;
+		goto unlock_scan_error_out;
 
 	if ((atomic_inc_return(&sdkp->openers) == 1) && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	}
 
+	mutex_unlock(&sdev->host->scan_mutex);
 	return 0;
 
+unlock_scan_error_out:
+	mutex_unlock(&sdev->host->scan_mutex);
+
 error_out:
 	scsi_disk_put(sdkp);
 	return retval;	
-- 
2.32.0=
Hyperstone GmbH | Line-Eid-Strasse 3 | 78467 Konstanz
Managing Directors: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

