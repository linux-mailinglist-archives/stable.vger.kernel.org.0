Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1387327CEC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhCALRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:17:32 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59579 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhCALR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:17:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7279A194114A;
        Mon,  1 Mar 2021 06:16:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:16:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QyEUvf
        Wm76rwtR4RfqXZREQ7wFZS8YvK7z2Tz0O9NbY=; b=e/tFpTgzEO5pu2lXMDVOQJ
        pl40sWNPM9RqFyMDF4CdQ/+kJCvn5LLJiL+cCY6D7eSXkNIO5ukPfmAI4jS0cNtT
        ijNRI+WAmlEZ4dS9VvHwdSVlqBmgP/CmKAqRhh+SwK8WumOR6bCmlAehqAqs+7db
        ZkPRW8Jw+wKkSf3EGugkLTEHkHxcrW0nCwYJ8417VdAxfQinluvOp89ymWi6eyH0
        y7kSru52OaGmRPk7goXaebiQZJStkn2M0BQxuq5Sp50ZRdb82UDlTn8FuzNaBv4R
        QLEaed01HwJsgO8ziiWkw7Zdr0CtDM64bi4i4G7SU7ZnH6OXT0sswS21GR5wgyMQ
        ==
X-ME-Sender: <xms:GM08YG5OoS4IVBspI3eOIjv5FXHkZowq0-qPXac-b51AGAlwWiLWFA>
    <xme:GM08YP5Ug8AHfce3czo02ZVMt0tal0MxBB6OCHG56z9bvSrWAn1S0dayt5Iz4PJDA
    2gtEUKfMz2wNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:GM08YFe8z4vW5oze77wvyYVuK_53XjMQmmk6you6mhy5Q0fC7hVeYg>
    <xmx:GM08YDLHwIFcTA3C7optZWHCi8bWPY_eRXIRGzRc6uHCcY2FJhyHLg>
    <xmx:GM08YKKAZ6xINTCProuw0KUqA60w_qEe5pturJrHLGpcP_n0XK1QNw>
    <xmx:Gc08YBVAcXSaS3aEOnsgStwdtmbyEE6lrD4ZI1McFa0KlTggFAzLUg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18C75240057;
        Mon,  1 Mar 2021 06:16:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] floppy: reintroduce O_NDELAY fix" failed to apply to 4.9-stable tree
To:     jkosina@suse.cz, efremov@linux.com, kurt@garloff.de,
        wim@djo.tudelft.nl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:16:32 +0100
Message-ID: <1614597392251148@kroah.com>
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

From 8a0c014cd20516ade9654fc13b51345ec58e7be8 Mon Sep 17 00:00:00 2001
From: Jiri Kosina <jkosina@suse.cz>
Date: Fri, 22 Jan 2021 12:13:20 +0100
Subject: [PATCH] floppy: reintroduce O_NDELAY fix

This issue was originally fixed in 09954bad4 ("floppy: refactor open()
flags handling").

The fix as a side-effect, however, introduce issue for open(O_ACCMODE)
that is being used for ioctl-only open. I wrote a fix for that, but
instead of it being merged, full revert of 09954bad4 was performed,
re-introducing the O_NDELAY / O_NONBLOCK issue, and it strikes again.

This is a forward-port of the original fix to current codebase; the
original submission had the changelog below:

====
Commit 09954bad4 ("floppy: refactor open() flags handling"), as a
side-effect, causes open(/dev/fdX, O_ACCMODE) to fail. It turns out that
this is being used setfdprm userspace for ioctl-only open().

Reintroduce back the original behavior wrt !(FMODE_READ|FMODE_WRITE)
modes, while still keeping the original O_NDELAY bug fixed.

Link: https://lore.kernel.org/r/nycvar.YFH.7.76.2101221209060.5622@cbobk.fhfr.pm
Cc: stable@vger.kernel.org
Reported-by: Wim Osterholt <wim@djo.tudelft.nl>
Tested-by: Wim Osterholt <wim@djo.tudelft.nl>
Reported-and-tested-by: Kurt Garloff <kurt@garloff.de>
Fixes: 09954bad4 ("floppy: refactor open() flags handling")
Fixes: f2791e7ead ("Revert "floppy: refactor open() flags handling"")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Denis Efremov <efremov@linux.com>

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index dfe1dfc901cc..0b71292d9d5a 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4121,23 +4121,23 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	if (fdc_state[FDC(drive)].rawcmd == 1)
 		fdc_state[FDC(drive)].rawcmd = 2;
 
-	if (!(mode & FMODE_NDELAY)) {
-		if (mode & (FMODE_READ|FMODE_WRITE)) {
-			drive_state[drive].last_checked = 0;
-			clear_bit(FD_OPEN_SHOULD_FAIL_BIT,
-				  &drive_state[drive].flags);
-			if (bdev_check_media_change(bdev))
-				floppy_revalidate(bdev->bd_disk);
-			if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
-				goto out;
-			if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
-				goto out;
-		}
-		res = -EROFS;
-		if ((mode & FMODE_WRITE) &&
-		    !test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
+	if (mode & (FMODE_READ|FMODE_WRITE)) {
+		drive_state[drive].last_checked = 0;
+		clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags);
+		if (bdev_check_media_change(bdev))
+			floppy_revalidate(bdev->bd_disk);
+		if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
+			goto out;
+		if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
 			goto out;
 	}
+
+	res = -EROFS;
+
+	if ((mode & FMODE_WRITE) &&
+			!test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
+		goto out;
+
 	mutex_unlock(&open_lock);
 	mutex_unlock(&floppy_mutex);
 	return 0;

