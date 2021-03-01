Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11391327CEF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhCALRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:17:37 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:56041 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232000AbhCALRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:17:36 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2B19B1940F4E;
        Mon,  1 Mar 2021 06:16:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 01 Mar 2021 06:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ey+T3S
        6bG1GaTHTOVchZ17Y3nw3buLxDjbXcEmzUvMI=; b=uT+5fFERCq0wia7abhGIhv
        PutfEFdeEPHCHjZSo1HuTMNIJ7vsqWj+U1l/j+/QRaq0mUbhG6jQBlUnW+HC00pp
        l0HI4kP9XXtsA7Tt1MJkzRDURrh7pv5dVaGCkzQkDNH5CPubKEjWcqCS6itAN5iG
        s3+icmfTLwWqiXhuKZhog6ZiTvB5hSpqD4ow2zdY50w+BirjnjIIBiE42TUkTMx+
        DmGsOpmHnTXLgOpobpOAZpHsrk5pQcPil4Uaqw8XvummUMxe+w+R/0dRHYL27reX
        9zb4pCwVMLtbQXmh1G52Wjm0xOwB8n3D9lUVQkMaB/BijgP8CqpUAJZrDelQdFOQ
        ==
X-ME-Sender: <xms:H808YGLaVi82oy2-ZbyVrd0uLv3eB9idBhrwsCzM18fj-aBai6B-Pg>
    <xme:H808YO11Ng1-bMfIek4rTimaUs6YOUDsy5zIPcXiRiCoCtbIn1zCLYrSCzYKpRqxn
    qKFQXYS9W-51Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:H808YE74UxKj_X4pofPv-pgO4lwP4p7oBODmwp4U7nQAY_avVtBDdg>
    <xmx:H808YP8sDB3tsmOQQ1ZhTMeI52SbNXG7vcDe6m6kCdMkyWO0_CqTaA>
    <xmx:H808YDWeil_7omL03xgI8T7zvEtYe1Fu6-KhXKRPZYzCx_7v8OJrkA>
    <xmx:IM08YJMrRFsmww8weAfTZxBRjCUHQU2K15Hl72k1Aj7YPBHC18kNWg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0682B240064;
        Mon,  1 Mar 2021 06:16:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] floppy: reintroduce O_NDELAY fix" failed to apply to 4.19-stable tree
To:     jkosina@suse.cz, efremov@linux.com, kurt@garloff.de,
        wim@djo.tudelft.nl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:16:34 +0100
Message-ID: <1614597394187145@kroah.com>
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

