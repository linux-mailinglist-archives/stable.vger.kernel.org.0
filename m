Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E112432D575
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhCDOiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:38:12 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:38129 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233216AbhCDOh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:37:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 757D119408FD;
        Thu,  4 Mar 2021 09:37:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 04 Mar 2021 09:37:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eBq44b
        Kn5nrwPzJyEZ2Tc+/N/L4+5Zibs5GQo8uyCe0=; b=Nd/NVa4degXtMXX8q/dvGS
        pOTs5+vbKzB2ewstbBFNudojKVw/1ylH3whUJW7luoKNxDLlGUyS7PDFG/RFxaTI
        PlTnMY7ULIq+pAbV/SR4Hq525wvB/t8AEapXFRwNdiGGa0/LVTIsj4ICRGVv4a3r
        4FWDe41NdZ1zX7H5Skss/hqmvPPv5sSgr9HYZjgwk8qTABMyxHz0whuamtaMH3a9
        WsD8SR4gTNVB3a8tYeKzk7CUDirTIxCjKKzFZXMGdL73beC1o1s811+ElNWw11PZ
        ycFZ3xx9YbvpL0gmiUoBxpvvelWr8Jlf+vU0JA6/pdVbgj/y4f9kgEHxUZy30aUw
        ==
X-ME-Sender: <xms:lfBAYMvQeifFcIk4rREmxu71kV6fJkmoXgR6iuM21sR7RIK7x-M7SA>
    <xme:lfBAYJdk-_Psq-26H7MHTufXJkK6OMYWzJlM1d9AJsWM0T4hN1dRTifvVwHJIai_N
    bFtldgq8qFoWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:lfBAYHzW_WIY7Kpae4KRgbJxJCv0Db6yr1X5yCrum_HOu-Lk0JUW_w>
    <xmx:lfBAYPMm-7s2gC13plJhx8TD8-OzYAlPh01JZazxPG8AjkVJOqolVA>
    <xmx:lfBAYM-rNY2aBIRHuYMpMbA9zoLVjXRvGaqM9Y2-ffpbxWijfgRsbg>
    <xmx:lvBAYOLDVqyuiI-EVwkr2EZx0nrWvB4qcdYN23HS5G_XyYh_bwvfQQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 09E2B24005B;
        Thu,  4 Mar 2021 09:37:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] vfio/type1: Use follow_pte()" failed to apply to 5.4-stable tree
To:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        peterx@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 15:35:40 +0100
Message-ID: <1614868540160240@kroah.com>
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

From 07956b6269d3ed05d854233d5bb776dca91751dd Mon Sep 17 00:00:00 2001
From: Alex Williamson <alex.williamson@redhat.com>
Date: Tue, 16 Feb 2021 15:49:34 -0700
Subject: [PATCH] vfio/type1: Use follow_pte()

follow_pfn() doesn't make sure that we're using the correct page
protections, get the pte with follow_pte() so that we can test
protections and get the pfn from the pte.

Fixes: 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b3df383d7028..ed03f3fcb07e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -24,6 +24,7 @@
 #include <linux/compat.h>
 #include <linux/device.h>
 #include <linux/fs.h>
+#include <linux/highmem.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -462,9 +463,11 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
 			    bool write_fault)
 {
+	pte_t *ptep;
+	spinlock_t *ptl;
 	int ret;
 
-	ret = follow_pfn(vma, vaddr, pfn);
+	ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
 	if (ret) {
 		bool unlocked = false;
 
@@ -478,9 +481,17 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 		if (ret)
 			return ret;
 
-		ret = follow_pfn(vma, vaddr, pfn);
+		ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
+		if (ret)
+			return ret;
 	}
 
+	if (write_fault && !pte_write(*ptep))
+		ret = -EFAULT;
+	else
+		*pfn = pte_pfn(*ptep);
+
+	pte_unmap_unlock(ptep, ptl);
 	return ret;
 }
 

