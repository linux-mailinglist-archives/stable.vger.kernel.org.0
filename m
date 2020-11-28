Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A866A2C741C
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732979AbgK1Vtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:47 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39825 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731746AbgK1SE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 13:04:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 80610194491C;
        Sat, 28 Nov 2020 07:25:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 28 Nov 2020 07:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cILo6Y
        VzzlDnGufrLT8UTKciFNOtK7xHZltD9TRB/4Y=; b=V4xfkfUzb//DwBLbkAxUZ2
        zAATUFJWjpZJBc3VXkRtrLvKJcpiw6VoCgDL60hCFOTqvpFFrKNrFZ1aUNS6VI49
        rQEe0H2hwE97KUZu+qH2mvI9XZAHSE7bnqEkUqw2lKJeDaAhBAz+g0LVzgd2/kzq
        jzTaU/kdj0SNoHtWA2nyhJYQMgWN6lyTf1b7mfrt0K1Xi5eoaUDi2myUsr4yD8de
        gZDTSMeSzbT4jGNY/ZY/VxkELGNosFwATUrLpUnO0yqLnfKwfvyBwPB5F95rnPfb
        vI4OB5fmgTszaWYkvWZMV9KtLP8rE+YvRDU9HiehD3WfF6ULq7EJvn65w5zdtryA
        ==
X-ME-Sender: <xms:vkHCX5Nlb3PXwEs99FiV4xTOuxN02ZjpkbxACSZ__Fu4YZkl9AiHKQ>
    <xme:vkHCX79tKqFSemZQ0-1qvlnHBvJobirDr-5MWwcULeRo2Aab-OgGHpFonwWZ86Gpp
    X-SP69Wh_xxTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehiedggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:vkHCX4SsHoNygWf7OBUO--paGg2ihnAvB0jQusElGzlMQV8Q_oz4Yw>
    <xmx:vkHCX1t4oSmCWmU5De-UzBO5M7u7RknTIRa8RW4SvR7KJzLjFVpQjA>
    <xmx:vkHCXxfFCeYD4yJTVA6YAgpW2fkY6OoiVAr6JCXWq08B8r_Gg8v5ew>
    <xmx:vkHCXyq-yTpWOC9eQHXCw1f_FGGu7Id4Chi9dGiZCg_XxMKUMSVBgg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1971F3064AA7;
        Sat, 28 Nov 2020 07:25:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] RDMA/i40iw: Address an mmap handler exploit in i40iw" failed to apply to 5.4-stable tree
To:     shiraz.saleem@intel.com, jgg@nvidia.com, stable@kernel.org,
        zhudi21@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 28 Nov 2020 13:26:36 +0100
Message-ID: <16065663968513@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2ed381439e89fa6d1a0839ef45ccd45d99d8e915 Mon Sep 17 00:00:00 2001
From: Shiraz Saleem <shiraz.saleem@intel.com>
Date: Tue, 24 Nov 2020 18:56:16 -0600
Subject: [PATCH] RDMA/i40iw: Address an mmap handler exploit in i40iw

i40iw_mmap manipulates the vma->vm_pgoff to differentiate a push page mmap
vs a doorbell mmap, and uses it to compute the pfn in remap_pfn_range
without any validation. This is vulnerable to an mmap exploit as described
in: https://lore.kernel.org/r/20201119093523.7588-1-zhudi21@huawei.com

The push feature is disabled in the driver currently and therefore no push
mmaps are issued from user-space. The feature does not work as expected in
the x722 product.

Remove the push module parameter and all VMA attribute manipulations for
this feature in i40iw_mmap. Update i40iw_mmap to only allow DB user
mmapings at offset = 0. Check vm_pgoff for zero and if the mmaps are bound
to a single page.

Cc: <stable@kernel.org>
Fixes: d37498417947 ("i40iw: add files for iwarp interface")
Link: https://lore.kernel.org/r/20201125005616.1800-2-shiraz.saleem@intel.com
Reported-by: Di Zhu <zhudi21@huawei.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 2408b279e4c2..584932d3cc44 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -54,10 +54,6 @@
 #define DRV_VERSION	__stringify(DRV_VERSION_MAJOR) "."		\
 	__stringify(DRV_VERSION_MINOR) "." __stringify(DRV_VERSION_BUILD)
 
-static int push_mode;
-module_param(push_mode, int, 0644);
-MODULE_PARM_DESC(push_mode, "Low latency mode: 0=disabled (default), 1=enabled)");
-
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "debug flags: 0=disabled (default), 0x7fffffff=all");
@@ -1580,7 +1576,6 @@ static enum i40iw_status_code i40iw_setup_init_state(struct i40iw_handler *hdl,
 	if (status)
 		goto exit;
 	iwdev->obj_next = iwdev->obj_mem;
-	iwdev->push_mode = push_mode;
 
 	init_waitqueue_head(&iwdev->vchnl_waitq);
 	init_waitqueue_head(&dev->vf_reqs);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 581ecbadf586..533f3caecb7a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -167,39 +167,16 @@ static void i40iw_dealloc_ucontext(struct ib_ucontext *context)
  */
 static int i40iw_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
-	struct i40iw_ucontext *ucontext;
-	u64 db_addr_offset, push_offset, pfn;
-
-	ucontext = to_ucontext(context);
-	if (ucontext->iwdev->sc_dev.is_pf) {
-		db_addr_offset = I40IW_DB_ADDR_OFFSET;
-		push_offset = I40IW_PUSH_OFFSET;
-		if (vma->vm_pgoff)
-			vma->vm_pgoff += I40IW_PF_FIRST_PUSH_PAGE_INDEX - 1;
-	} else {
-		db_addr_offset = I40IW_VF_DB_ADDR_OFFSET;
-		push_offset = I40IW_VF_PUSH_OFFSET;
-		if (vma->vm_pgoff)
-			vma->vm_pgoff += I40IW_VF_FIRST_PUSH_PAGE_INDEX - 1;
-	}
+	struct i40iw_ucontext *ucontext = to_ucontext(context);
+	u64 dbaddr;
 
-	vma->vm_pgoff += db_addr_offset >> PAGE_SHIFT;
-
-	if (vma->vm_pgoff == (db_addr_offset >> PAGE_SHIFT)) {
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	} else {
-		if ((vma->vm_pgoff - (push_offset >> PAGE_SHIFT)) % 2)
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-		else
-			vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	}
+	if (vma->vm_pgoff || vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
 
-	pfn = vma->vm_pgoff +
-	      (pci_resource_start(ucontext->iwdev->ldev->pcidev, 0) >>
-	       PAGE_SHIFT);
+	dbaddr = I40IW_DB_ADDR_OFFSET + pci_resource_start(ucontext->iwdev->ldev->pcidev, 0);
 
-	return rdma_user_mmap_io(context, vma, pfn, PAGE_SIZE,
-				 vma->vm_page_prot, NULL);
+	return rdma_user_mmap_io(context, vma, dbaddr >> PAGE_SHIFT, PAGE_SIZE,
+				 pgprot_noncached(vma->vm_page_prot), NULL);
 }
 
 /**

