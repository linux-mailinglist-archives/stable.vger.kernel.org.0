Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837A132D577
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhCDOiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:38:13 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:47919 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234307AbhCDOiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:38:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8507E14A2;
        Thu,  4 Mar 2021 09:37:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 04 Mar 2021 09:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EkSlke
        HKbhmJd9iDrTBHgrDohk0cD1ahSFRhtSC4iD0=; b=wtmR7DYruVejR7uXl9+M9O
        s5EWo+3GhSxlXfDXR7Eulm566mTs0kV40l5MUZx9iIvHAOKXXbG0GOMA/QB3+QoN
        ACk8J8QnviERUUeukoj9+jKViGP3GCADlLvbFjk5SBKOtDE7CHmC3AqgBF3VBbGK
        yk374ZXsDVH5gsx5DWds1rMlLcRYjWOdIgaDtOx/jdmi/0ddCdHem79kWHLL+GuD
        IJh8qTFhaSIBkkPQVCPEwqNUGstC3MPA9umBBJKnV7kIR55N/XArvmNHaPFHZSpt
        SD85EVe1Q8Ic816ob6XYkbpZH0Z9uo8DmcJVxpzXoy4q4PmSv6BZHaLhZ/SfqNhA
        ==
X-ME-Sender: <xms:kfBAYAXndTTTgBMikSPh5iLjEv9kAFdmV0veXd-HmVFVyGkLzRJi8g>
    <xme:kfBAYKl68Wrj5a8KvZ7VT5QrCoDZXszI6lzJ763GuiHCF2fCTomIJukkk2c1cPToX
    5tpdebJRUZgzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:kfBAYCAGGlP5sayaISEaanPaH6GN3ZWMUEWlsM71gBDKBUj0MAw4nw>
    <xmx:kfBAYKek71BxZCAtb7bL_oPU5z5AvnoL3xo0RAU8LRls0duiqnofcQ>
    <xmx:kfBAYNKisUnZBBSS8zIeby9xsjNy94i4QpdUckYkaJs_UOTKb1O_nw>
    <xmx:kfBAYBZ3PtJmUMUQbOgS2b_vCgpnCHx9BflK2-0SRc89NhgElUA2RSsKXn8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B191C108005C;
        Thu,  4 Mar 2021 09:37:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] vfio/type1: Use follow_pte()" failed to apply to 4.14-stable tree
To:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        peterx@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 15:35:39 +0100
Message-ID: <1614868539248@kroah.com>
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
 

