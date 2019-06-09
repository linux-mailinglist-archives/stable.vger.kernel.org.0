Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21653A48E
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfFIJpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:45:33 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:52893 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:45:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E64123E1;
        Sun,  9 Jun 2019 05:45:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:45:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=A/VUrg
        iB3WL/anY0PDMhMnNW4p8LPTy80voJK8wSe4g=; b=v1gusSYKDqTRXbPS7xwnoB
        KNVvuPefLuoVOv/WyEghvhKqaP6ds/7yk87RYbiBghelq9iM0uj3jA8AUdI1yp6o
        19qjQZY4QYXfL5M691x+u+x3MAAEwNYQing1i8qaV3YjKf2QhM6bctYpq3AUXXQJ
        7egrPS7zI9i8QEtJXzS7WHwV/Q8PHUXLIFu/1QOKOqMwldoSisV+tV60isbKzryS
        vwJ20pn8NCx0GLmMCLdoEAwXWzHpSJikydf+9DdXfbdHlDlLsqGYwU1xWYTMH8z4
        j0JFupVT5PowkHmaiEUXvk53crd2UsCUV6ixju3BnVODDjvJS/Kwu93AL/X6u/JQ
        ==
X-ME-Sender: <xms:O9X8XLZoizIz_BXaYKm1NoyObMyqVcgvegElJW7QUJzVcY45g4UZhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:O9X8XNohtVUjkNF8nLzc9WsaFHBZyMFvlHRfSjgc7tpo_HypcJIq2g>
    <xmx:O9X8XHbJS2RTNaqPhI88QPubB71GpuD4DtWG_5CJlPMjMEZiuUGPIA>
    <xmx:O9X8XNRGbkL1NLkpUDyO3mWEwJLkE8u8ov5yFqElevS01rMgt-EMKg>
    <xmx:O9X8XBjVK0Dxqypp9ki_ZvrxBtJiSpo5WdK5Vp8Yo1dzc_n4x3kQmg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D32CB380083;
        Sun,  9 Jun 2019 05:45:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls" failed to apply to 5.1-stable tree
To:     amir73il@gmail.com, david@fromorbit.com, mszeredi@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:45:29 +0200
Message-ID: <1560073529193139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b21d9c435f935014d3e3fa6914f2e4fbabb0e94d Mon Sep 17 00:00:00 2001
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 26 May 2019 09:28:25 +0300
Subject: [PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls

They are the extended version of FS_IOC_FS[SG]ETFLAGS ioctls.
xfs_io -c "chattr <flags>" uses the new ioctls for setting flags.

This used to work in kernel pre v4.19, before stacked file ops
introduced the ovl_ioctl whitelist.

Reported-by: Dave Chinner <david@fromorbit.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 540a8b845145..340a6ad45914 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -426,7 +426,8 @@ static unsigned int ovl_get_inode_flags(struct inode *inode)
 	return ovl_iflags;
 }
 
-static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
+static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
@@ -456,7 +457,7 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
 	if (ret)
 		goto unlock;
 
-	ret = ovl_real_ioctl(file, FS_IOC_SETFLAGS, arg);
+	ret = ovl_real_ioctl(file, cmd, arg);
 
 	ovl_copyflags(ovl_inode_real(inode), inode);
 unlock:
@@ -474,11 +475,13 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
+	case FS_IOC_FSGETXATTR:
 		ret = ovl_real_ioctl(file, cmd, arg);
 		break;
 
 	case FS_IOC_SETFLAGS:
-		ret = ovl_ioctl_set_flags(file, arg);
+	case FS_IOC_FSSETXATTR:
+		ret = ovl_ioctl_set_flags(file, cmd, arg);
 		break;
 
 	default:

