Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FD932D579
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhCDOio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:38:44 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:56093 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232085AbhCDOiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:38:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 4964214E6;
        Thu,  4 Mar 2021 09:37:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Mar 2021 09:37:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ipo1fd
        N4DytCd8WzA1WtIEpPg3lvXa4S3/4usOQHpfU=; b=Wt5JvrWedilCBo/tmZ7nel
        nIWIFkl3o0EkO62HFxk/TcJVo9IDzdoVtE6x6hZwylear/JbhaaxY+gZ27kgwed+
        MJJQ/btr1jjOYXBfxjt38OXtRVRzWc95FU1m0IegF2DYeZGpJn8emy4Q1EXMu2Q1
        IK711B7kmJjkJ+vINPJqsPWG3QPxyTvSiJQREbPnrfoMun63QltfiyLE8PFkW3uz
        H48UKM44jPfNb2zVIw4K+AyVpSm7xZEm/DSly1dyPCpPxsMkxIqRQIQdpURDXIYe
        sHvTdhlW9D6TgsnHJtCLOkg7NXd1DZp2fifOrLfb38+IwYXaQJKb3v8elTQatwKg
        ==
X-ME-Sender: <xms:kvBAYNUi5GZaXBxy-TvASPA6padqJ_myUnLBKbhb_YBhcn4fyI3UvQ>
    <xme:kvBAYCsnKbNgCxf0EUHeY4iWurr9jC3aNvpHYD5fuKWLDV-aSyD7cRoKN8lusul_z
    -_sZDO-mMvMDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:kvBAYMUmLCS2NRwS_tKDQpkma2sX3j6XYTfX0dGPjqHiLhvOsMbCbw>
    <xmx:kvBAYGXIidjMxKv9Y3jHkyPWfh1T0jShEBdwfj9qUkTZH5CFPcHU3A>
    <xmx:kvBAYOdf1CsCvXZ1xwmxgbphfZeQP9toLKIHxP85gsNAdgpxVYmEIg>
    <xmx:kvBAYJv-MqP2OpwNXfvoljERxK66Csj3uB46qb2v9JGf0hWz4tbpl2NgekE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9ED21080057;
        Thu,  4 Mar 2021 09:37:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] vfio/type1: Use follow_pte()" failed to apply to 5.10-stable tree
To:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        peterx@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 15:35:40 +0100
Message-ID: <161486854071160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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
 

