Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868E22A1513
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 11:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgJaKDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 06:03:10 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:46447 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbgJaKDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 06:03:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 54915194268B;
        Sat, 31 Oct 2020 06:03:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 31 Oct 2020 06:03:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Dtn1aZ
        zChSRZGNOoBpAJVcpjKFrQxzle5/8uZWZmMhk=; b=PCcGhFAYYQEp1KjsYdjbFc
        FmMP4To4tkywzfmVB7+LmkT9BbwoEDlQtieaNJoZWCZtICbfJdIYB988wdXP+ZUc
        T9QeLSJbCM59FQETk/HzweoDL0r+QVgk0w+K/coA9HVyyEoGlMRNeAE2u43pSHFe
        LUMOT3PEZHUPb8ibelKXiBjZjBhVG9z+KwEDnuMzvGL+4zd+BJcVJgXWOSmzJr3w
        VBLNzqAKrxARQKn/nG783pU2Sq8qN90Ixl/V6aT613RxvakCIZu86Vm/tRsIvMq6
        dXvmJT8V7mjFSfw7QibNXxZ7JA0Q5f5NhDYo2UYKdYvZ301uVZf0MPuvSSZJfHjg
        ==
X-ME-Sender: <xms:XTadX7TyqGoHJDqdqfLzMqPAIMwGUG4gzs9z-nXI1SYItkT7KmoQdQ>
    <xme:XTadX8wq41GUKbd-lUzbR2m1GFBAknzexLCLs93BUhxnGwBPh-sIwUeMjMUDWExkX
    0GjeQXeP0A-BQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleejgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:XTadXw3ZnEmlZ2pU23nTIhe-tTqzJgurWKndlDDIncTw8pJKEh8GOg>
    <xmx:XTadX7CEqeV-WT9X5e_TRzOMM40o-9IMPa0onVBWawHGtXKXfJ5_QQ>
    <xmx:XTadX0hj50SBDNQAgYARbFVbAk9YclSUaHF6yeWLyPoLXTVNk5F5Hg>
    <xmx:XTadX9t8RTKOfBEqv4-NoMW9INopmsXVB14ZKDzKbY4jQZuib3KBJg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E01FD328005D;
        Sat, 31 Oct 2020 06:03:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen/gntdev.c: Mark pages as dirty" failed to apply to 4.14-stable tree
To:     jrdr.linux@gmail.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, jgross@suse.com, jhubbard@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 31 Oct 2020 11:03:46 +0100
Message-ID: <160413862615166@kroah.com>
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
 

