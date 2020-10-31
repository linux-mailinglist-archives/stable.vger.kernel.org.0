Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E495D2A1512
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 11:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgJaKDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 06:03:09 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:36883 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726475AbgJaKDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 06:03:08 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id AD13519425B6;
        Sat, 31 Oct 2020 06:03:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 31 Oct 2020 06:03:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Mzpo0+
        uOCgEAtBykeLlc11IpRdOtGQLmfqbyf7cMGEA=; b=IeBO3njblf/oNOhaSzh6Vi
        sXraabEV59Dfc59L7Ii++MGt2hXPEYjvJip1Vf4pH6KF58rvGZX3Pg+ZKcMHYDgt
        JIAPmqm06bNmD9LPYG7d0inWDetFxxay4ya7TEO72mhXycKjR/VZYRne1izBSS0R
        HVYXMhP/gokFhbDng5usTsoxRGTTb/EseLqKK/MF7r8F/gAG+KvcNH4SB2IBHsf3
        SiqiqsWH8i/mXla0SbY4q/xFNQqIxyQga0rikQYSmhFS+71rmOq7P8x1BmTf742F
        A4eYvq40a4RxghtXEgd0inkTxov/NR4oNIF4wPUi2z1pdqKM8BoKQiHpDXyRLQnQ
        ==
X-ME-Sender: <xms:WzadX_3tQu5E7lNi7_cR7GQ2nVa6P1aGhhDaOnmjOCrt6uiImcL-3A>
    <xme:WzadX-G-gqfp_0Oa8RvjegnOA_MZTlMOCPFUQW6WFsN-ydZjYpZGM39HYVUNv21EF
    4yconeCvI0zBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleejgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:WzadX_7D9dYwltdCUjeKyw15B5FeDeNhp5js1dx4_rTyTgGfWdDRtA>
    <xmx:WzadX00Txou6IB9YYz0hgB9CjX8qjeJlRL94ZvnzAOhcsY32KDi-iA>
    <xmx:WzadXyEq7UW5uTlqkTxJZtzFzZTBqWCxBz4fvCN6SW4G6YZFimQsmg>
    <xmx:WzadX-DkuToBABJMuowvXy-JOKoetDe259oMoqTmYJJORA9XHtZLJw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F7303064684;
        Sat, 31 Oct 2020 06:03:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen/gntdev.c: Mark pages as dirty" failed to apply to 4.9-stable tree
To:     jrdr.linux@gmail.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, jgross@suse.com, jhubbard@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 31 Oct 2020 11:03:46 +0100
Message-ID: <160413862616810@kroah.com>
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

From 779055842da5b2e508f3ccf9a8153cb1f704f566 Mon Sep 17 00:00:00 2001
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Sun, 6 Sep 2020 12:21:53 +0530
Subject: [PATCH] xen/gntdev.c: Mark pages as dirty

There seems to be a bug in the original code when gntdev_get_page()
is called with writeable=true then the page needs to be marked dirty
before being put.

To address this, a bool writeable is added in gnt_dev_copy_batch, set
it in gntdev_grant_copy_seg() (and drop `writeable` argument to
gntdev_get_page()) and then, based on batch->writeable, use
set_page_dirty_lock().

Fixes: a4cdb556cae0 (xen/gntdev: add ioctl for grant copy)
Suggested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1599375114-32360-1-git-send-email-jrdr.linux@gmail.com
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 64a9025a87be..1f32db7b72b2 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -720,17 +720,18 @@ struct gntdev_copy_batch {
 	s16 __user *status[GNTDEV_COPY_BATCH];
 	unsigned int nr_ops;
 	unsigned int nr_pages;
+	bool writeable;
 };
 
 static int gntdev_get_page(struct gntdev_copy_batch *batch, void __user *virt,
-			   bool writeable, unsigned long *gfn)
+				unsigned long *gfn)
 {
 	unsigned long addr = (unsigned long)virt;
 	struct page *page;
 	unsigned long xen_pfn;
 	int ret;
 
-	ret = get_user_pages_fast(addr, 1, writeable ? FOLL_WRITE : 0, &page);
+	ret = get_user_pages_fast(addr, 1, batch->writeable ? FOLL_WRITE : 0, &page);
 	if (ret < 0)
 		return ret;
 
@@ -746,9 +747,13 @@ static void gntdev_put_pages(struct gntdev_copy_batch *batch)
 {
 	unsigned int i;
 
-	for (i = 0; i < batch->nr_pages; i++)
+	for (i = 0; i < batch->nr_pages; i++) {
+		if (batch->writeable && !PageDirty(batch->pages[i]))
+			set_page_dirty_lock(batch->pages[i]);
 		put_page(batch->pages[i]);
+	}
 	batch->nr_pages = 0;
+	batch->writeable = false;
 }
 
 static int gntdev_copy(struct gntdev_copy_batch *batch)
@@ -837,8 +842,9 @@ static int gntdev_grant_copy_seg(struct gntdev_copy_batch *batch,
 			virt = seg->source.virt + copied;
 			off = (unsigned long)virt & ~XEN_PAGE_MASK;
 			len = min(len, (size_t)XEN_PAGE_SIZE - off);
+			batch->writeable = false;
 
-			ret = gntdev_get_page(batch, virt, false, &gfn);
+			ret = gntdev_get_page(batch, virt, &gfn);
 			if (ret < 0)
 				return ret;
 
@@ -856,8 +862,9 @@ static int gntdev_grant_copy_seg(struct gntdev_copy_batch *batch,
 			virt = seg->dest.virt + copied;
 			off = (unsigned long)virt & ~XEN_PAGE_MASK;
 			len = min(len, (size_t)XEN_PAGE_SIZE - off);
+			batch->writeable = true;
 
-			ret = gntdev_get_page(batch, virt, true, &gfn);
+			ret = gntdev_get_page(batch, virt, &gfn);
 			if (ret < 0)
 				return ret;
 

