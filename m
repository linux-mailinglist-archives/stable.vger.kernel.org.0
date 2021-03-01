Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECEE327CED
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhCALRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:17:35 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:37771 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231913AbhCALRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:17:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id AA92D194113E;
        Mon,  1 Mar 2021 06:16:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:16:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8i5Y7B
        XlGu4kh7git4VNF5bQ0dOQEKQura8p4nJ8FgI=; b=XoZ3x9ZeYMD1+5j51CGc9W
        ngxJjzlUZrNE933q0+C2zurI8lFDqOnUN3FI0H7WnnLJ2WnS3k2/2gcNCU/7mIZt
        JHN6XKw2clRrAvk6nqhLIihfZad6zRQ7bRLUv7tV9Mr+kBtN5sunPjp9Zqg/FAQR
        W//lv9Jag4Pm9MLHby8y/6OsdEHEX5yQnDNttjkr8nyxKofKMRT72hKOvz4jvMJW
        D/ODYZ0sYrdB3dy/jNvMbybRg62HU3GCjOwHoAjsa3h+Uq570re10AjnFKSMS/KD
        3CGIbY2u4VvSJoqwdYl46Ea8t8IkUnU0EgDUJF9JJGoRtgMb+03fzvN+KsEJvF6w
        ==
X-ME-Sender: <xms:Hc08YNtiiqttJLe0BnMkQKHcjMTS_9lcIH8s3dbv2lx0CyjCU-NpEA>
    <xme:Hc08YGf1lrJrbx7saeG5bwLJbyKvGwS_TqhbvH4xjHdIZ0D6jKo2QuW_cClGba0Vt
    swTgIqc1WXXmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Hc08YAxfFS8RjImPI_T2KGf4WHB-yAeSqE6ZIEgjFnTPa8-RQSP25g>
    <xmx:Hc08YEOscYsbaHIRoIUBhJIIAGU9wOMxXK0LU2NizJiSreySwvioFA>
    <xmx:Hc08YN9OMqQg9jKZe3rb0w0EmfqoBOnwLuQ1xpTWzG6G-4ttEEhFzw>
    <xmx:Hc08YPK4fg3FtN8REEmNu3KWSE2PQh3HfbcADdeOYS-IEPAIuXy0_Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3BFEC1080054;
        Mon,  1 Mar 2021 06:16:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] floppy: reintroduce O_NDELAY fix" failed to apply to 4.14-stable tree
To:     jkosina@suse.cz, efremov@linux.com, kurt@garloff.de,
        wim@djo.tudelft.nl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:16:33 +0100
Message-ID: <1614597393200208@kroah.com>
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

