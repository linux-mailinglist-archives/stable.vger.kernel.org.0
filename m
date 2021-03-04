Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A83832D573
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhCDOiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:38:12 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52037 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232152AbhCDOhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:37:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 378AB1314;
        Thu,  4 Mar 2021 09:37:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Mar 2021 09:37:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nO1URm
        Vc/wOCPs92sRN2pYJ9p3pnQOBlQIMTzvrMheo=; b=AjjZ8ZIJkfId39jV3FGndk
        L7PQwOwK8WYtnlkdvFJgv+3oF5ZE/8yweTThSKSmXjbqfmF7ElSjJnLdIOCkNHXp
        RKS4fBpcSD7/3vaaKygQG1paMhDL2BTsC81U4O584P/gB4R9zgdh7H0Yrk1cYjyG
        KuAnhefLbEm7xoiDqbQ0ui6upWvWG3HocxihYU9MgsikJDbkljOS3MeY6KDvy2KH
        jPC3wZfiXaaWhRRwin3eAJuS0xRKBQ2eyxuJHeMzP+KcBBY0Cx0ZovHxJisGN6Wr
        ChQLlzvtDc4Ssp1BgBHQeXKFeNGICAudK4BlWfjuxLzxCR/Sd4hXOX53x2WSBJPA
        ==
X-ME-Sender: <xms:jPBAYLjkyQXMmK1GjRvueOjKL9X9hNcaYz9QfeqhyRSPSswVkJWHzQ>
    <xme:jPBAYMbrZAzXeeuk7JpvtqjpUP9beCLjc6rYeRcBteITs4GM2AX_v1lfHjq5NJuDo
    934xcGJ3VRP9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:jPBAYI-EAjQ8KdpVFxClZPzlKw9lPpYhQ634zZ4heRmH_wr7oxxIdg>
    <xmx:jPBAYGOBieQEPYpafLbAwFsEUBJfFihIUth8vb_47ARwFSnlgQBLNw>
    <xmx:jPBAYNHaDSUn5lsrDD_JnsLsCXgPo9rwACdl4nH5tVEsiINpmGPrww>
    <xmx:jPBAYADB89riXX82I4I5peMv086eqSJj7teiCLZHYntBPfvYiaGr9gHBtLc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 75CCA108005C;
        Thu,  4 Mar 2021 09:37:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] vfio/type1: Use follow_pte()" failed to apply to 4.4-stable tree
To:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        peterx@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 15:35:38 +0100
Message-ID: <161486853855133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

