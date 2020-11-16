Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823572B49C6
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 16:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbgKPPqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 10:46:35 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:46057 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731035AbgKPPqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 10:46:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BD19EB89;
        Mon, 16 Nov 2020 10:46:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 10:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lr9LHA
        Qm5BpWxvBNXfJ44khbNUG+5tZaXmmLhYS/yxA=; b=KhxZBomxpeSuZRRBYzq7jQ
        zrJX4zAiCxH8/ttvH6jyFULIWhilWrP+dtxq4vMWhGDs3fp6EBzOmXErE418WIK/
        Bt+X9hZzVyC8NknO9hAMRRbRBGOY4AJKUA0AKRV1PHEb3a8V489ISk7s3msHBT2O
        AXVh7/vmuggS/FzxdLvmDenFDNU3mqa1HTud7OoOhXnAqa9gqs64rtE4Q62Q+bWZ
        wJuQXAaLe8KV55uf+QnNGsq21UbRyA6XUkXM6Rh58fUKZXx3cJpKDaSTMtI6wVot
        g3xcqal8O2kG5xLstgMch1kDmm2SYBTUb+mOKo/5+uYAvDG/+8p9Q1nSzpwRWXgA
        ==
X-ME-Sender: <xms:2Z6yX_D3xil-nyTOMxfYuKRR3blUiF_xnH0VRdQVwlpNxl2YKRSFzA>
    <xme:2Z6yX1hNr4Vy6566zbgpHIZ1AeCewMsahk0bXSEKww_vy1S8Cygh4hrM1--dMredN
    kb-rUKlxAAo7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2Z6yX6lWof8D-hrtu9wUDax7dBff_2ZApzuRX4yK7iF4tdHXF6J_qA>
    <xmx:2Z6yXxwoPYKpY9USHI4l-oEmRJz7G1rUzifEdgTitFDZr5d-drqomg>
    <xmx:2Z6yX0QAJ-SkgfbJopxvivp-iRWrwtstYe8zrWn8gjXvMzfQHe427Q>
    <xmx:2p6yX_KaLhF0QBhQKa02rRG11JDMeBhPhuJAPTTue4yUBTG1CpebYriaK7A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 070DF328006D;
        Mon, 16 Nov 2020 10:46:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] erofs: derive atime instead of leaving it empty" failed to apply to 4.19-stable tree
To:     hsiangkao@redhat.com, nl6720@gmail.com, stable@vger.kernel.org,
        yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 16:47:23 +0100
Message-ID: <160554164363107@kroah.com>
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

From d3938ee23e97bfcac2e0eb6b356875da73d700df Mon Sep 17 00:00:00 2001
From: Gao Xiang <hsiangkao@redhat.com>
Date: Sun, 1 Nov 2020 03:51:02 +0800
Subject: [PATCH] erofs: derive atime instead of leaving it empty

EROFS has _only one_ ondisk timestamp (ctime is currently
documented and recorded, we might also record mtime instead
with a new compat feature if needed) for each extended inode
since EROFS isn't mainly for archival purposes so no need to
keep all timestamps on disk especially for Android scenarios
due to security concerns. Also, romfs/cramfs don't have their
own on-disk timestamp, and squashfs only records mtime instead.

Let's also derive access time from ondisk timestamp rather than
leaving it empty, and if mtime/atime for each file are really
needed for specific scenarios as well, we can also use xattrs
to record them then.

Link: https://lore.kernel.org/r/20201031195102.21221-1-hsiangkao@aol.com
[ Gao Xiang: It'd be better to backport for user-friendly concern. ]
Fixes: 431339ba9042 ("staging: erofs: add inode operations")
Cc: stable <stable@vger.kernel.org> # 4.19+
Reported-by: nl6720 <nl6720@gmail.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 139d0bed42f8..3e21c0e8adae 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -107,11 +107,9 @@ static struct page *erofs_read_inode(struct inode *inode,
 		i_gid_write(inode, le32_to_cpu(die->i_gid));
 		set_nlink(inode, le32_to_cpu(die->i_nlink));
 
-		/* ns timestamp */
-		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
-			le64_to_cpu(die->i_ctime);
-		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
-			le32_to_cpu(die->i_ctime_nsec);
+		/* extended inode has its own timestamp */
+		inode->i_ctime.tv_sec = le64_to_cpu(die->i_ctime);
+		inode->i_ctime.tv_nsec = le32_to_cpu(die->i_ctime_nsec);
 
 		inode->i_size = le64_to_cpu(die->i_size);
 
@@ -149,11 +147,9 @@ static struct page *erofs_read_inode(struct inode *inode,
 		i_gid_write(inode, le16_to_cpu(dic->i_gid));
 		set_nlink(inode, le16_to_cpu(dic->i_nlink));
 
-		/* use build time to derive all file time */
-		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
-			sbi->build_time;
-		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
-			sbi->build_time_nsec;
+		/* use build time for compact inodes */
+		inode->i_ctime.tv_sec = sbi->build_time;
+		inode->i_ctime.tv_nsec = sbi->build_time_nsec;
 
 		inode->i_size = le32_to_cpu(dic->i_size);
 		if (erofs_inode_is_data_compressed(vi->datalayout))
@@ -167,6 +163,11 @@ static struct page *erofs_read_inode(struct inode *inode,
 		goto err_out;
 	}
 
+	inode->i_mtime.tv_sec = inode->i_ctime.tv_sec;
+	inode->i_atime.tv_sec = inode->i_ctime.tv_sec;
+	inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec;
+	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec;
+
 	if (!nblks)
 		/* measure inode.i_blocks as generic filesystems */
 		inode->i_blocks = roundup(inode->i_size, EROFS_BLKSIZ) >> 9;

