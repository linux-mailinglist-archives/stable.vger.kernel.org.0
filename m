Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705E63776CA
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 15:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhEINoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 09:44:11 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:33417 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhEINoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 09:44:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 10D771940401;
        Sun,  9 May 2021 09:43:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 09 May 2021 09:43:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7sRxRg
        kUlc0MFereGUL5Eb1Zbw7tksDlpunzA7UDIIU=; b=KNCU78X1UAWMA+fwrhWwhL
        0Qt7BEl+D7WTF7onRDEYYIi3kBCeDT8NmQPiXCo1COFhVZ0wGCPnGdepe9cJlEII
        wQsuir8JqvmUGIYK3k/YW1wwNAjQ8mJYjhlYs1P7J/hk7Rwpsi8ftczZEBctdVzn
        FNfgM83TL9pEKKNfUJDGKPfdxjw8MBPzpP4LvXqTjRdzO45cXkSTlBl4JSTpLHC0
        hUtUWX0+Qim8aS+O8cr5tYApffrmXEneEomHMV7guQiW8rqf02256kJe1D041P74
        ZI/ygfhBd9mkvh5jMKdtqCq0Ji1TzhaW7mzvMpMcATL0j595TgdDXPoWgQQUTkVg
        ==
X-ME-Sender: <xms:6uaXYBFxVoXh6OAQukE0MwfX6R0g3LScgVze2H9fgxhWO_2b9aJGRg>
    <xme:6uaXYGWGBbEghYIi97pRjCTSlFfrd2SdYHUgQMAp3xP24buNwhVW7UMvCOJPu09Ct
    ZkF5q6Jdu-8Xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6uaXYDJPlci0a-k-lRZkYEcrwgVFTXA21TvdsH6v8DyVXZaKvtVOhQ>
    <xmx:6uaXYHEQtS_n_EKsIySAgI74gdip9KUxKyI_OiF96VtMk8W-5HZaCg>
    <xmx:6uaXYHVKTV_RnCkzcuhjx4UAmN0q7Dd0mHMEw37hOCQXPhapPNx7hw>
    <xmx:6-aXYDpo3vJ_nYLW53s7XoGRfGVIYI_5ZIqdydZxKoAgqMRo6sZEVWLe1Q0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 09:43:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iommu/vt-d: Force to flush iotlb before creating superpage" failed to apply to 4.9-stable tree
To:     longpeng2@huawei.com, alex.williamson@redhat.com,
        arei.gonglei@huawei.com, baolu.lu@linux.intel.com,
        dwmw2@infradead.org, joro@8bytes.org, jroedel@suse.de,
        kevin.tian@intel.com, nadav.amit@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 15:43:00 +0200
Message-ID: <1620567780254220@kroah.com>
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

From 38c527aeb41926c71902dd42f788a8b093b21416 Mon Sep 17 00:00:00 2001
From: "Longpeng(Mike)" <longpeng2@huawei.com>
Date: Thu, 15 Apr 2021 08:46:28 +0800
Subject: [PATCH] iommu/vt-d: Force to flush iotlb before creating superpage

The translation caches may preserve obsolete data when the
mapping size is changed, suppose the following sequence which
can reveal the problem with high probability.

1.mmap(4GB,MAP_HUGETLB)
2.
  while (1) {
   (a)    DMA MAP   0,0xa0000
   (b)    DMA UNMAP 0,0xa0000
   (c)    DMA MAP   0,0xc0000000
             * DMA read IOVA 0 may failure here (Not present)
             * if the problem occurs.
   (d)    DMA UNMAP 0,0xc0000000
  }

The page table(only focus on IOVA 0) after (a) is:
 PML4: 0x19db5c1003   entry:0xffff899bdcd2f000
  PDPE: 0x1a1cacb003  entry:0xffff89b35b5c1000
   PDE: 0x1a30a72003  entry:0xffff89b39cacb000
    PTE: 0x21d200803  entry:0xffff89b3b0a72000

The page table after (b) is:
 PML4: 0x19db5c1003   entry:0xffff899bdcd2f000
  PDPE: 0x1a1cacb003  entry:0xffff89b35b5c1000
   PDE: 0x1a30a72003  entry:0xffff89b39cacb000
    PTE: 0x0          entry:0xffff89b3b0a72000

The page table after (c) is:
 PML4: 0x19db5c1003   entry:0xffff899bdcd2f000
  PDPE: 0x1a1cacb003  entry:0xffff89b35b5c1000
   PDE: 0x21d200883   entry:0xffff89b39cacb000 (*)

Because the PDE entry after (b) is present, it won't be
flushed even if the iommu driver flush cache when unmap,
so the obsolete data may be preserved in cache, which
would cause the wrong translation at end.

However, we can see the PDE entry is finally switch to
2M-superpage mapping, but it does not transform
to 0x21d200883 directly:

1. PDE: 0x1a30a72003
2. __domain_mapping
     dma_pte_free_pagetable
       Set the PDE entry to ZERO
     Set the PDE entry to 0x21d200883

So we must flush the cache after the entry switch to ZERO
to avoid the obsolete info be preserved.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Gonglei (Arei) <arei.gonglei@huawei.com>

Fixes: 6491d4d02893 ("intel-iommu: Free old page tables before creating superpage")
Cc: <stable@vger.kernel.org> # v3.0+
Link: https://lore.kernel.org/linux-iommu/670baaf8-4ff8-4e84-4be3-030b95ab5a5e@huawei.com/
Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210415004628.1779-1-longpeng2@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index c981e69bc107..ab2a026dd844 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2301,6 +2301,41 @@ static inline int hardware_largepage_caps(struct dmar_domain *domain,
 	return level;
 }
 
+/*
+ * Ensure that old small page tables are removed to make room for superpage(s).
+ * We're going to add new large pages, so make sure we don't remove their parent
+ * tables. The IOTLB/devTLBs should be flushed if any PDE/PTEs are cleared.
+ */
+static void switch_to_super_page(struct dmar_domain *domain,
+				 unsigned long start_pfn,
+				 unsigned long end_pfn, int level)
+{
+	unsigned long lvl_pages = lvl_to_nr_pages(level);
+	struct dma_pte *pte = NULL;
+	int i;
+
+	while (start_pfn <= end_pfn) {
+		if (!pte)
+			pte = pfn_to_dma_pte(domain, start_pfn, &level);
+
+		if (dma_pte_present(pte)) {
+			dma_pte_free_pagetable(domain, start_pfn,
+					       start_pfn + lvl_pages - 1,
+					       level + 1);
+
+			for_each_domain_iommu(i, domain)
+				iommu_flush_iotlb_psi(g_iommus[i], domain,
+						      start_pfn, lvl_pages,
+						      0, 0);
+		}
+
+		pte++;
+		start_pfn += lvl_pages;
+		if (first_pte_in_page(pte))
+			pte = NULL;
+	}
+}
+
 static int
 __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		 unsigned long phys_pfn, unsigned long nr_pages, int prot)
@@ -2342,22 +2377,11 @@ __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 				return -ENOMEM;
 			/* It is large page*/
 			if (largepage_lvl > 1) {
-				unsigned long nr_superpages, end_pfn;
+				unsigned long end_pfn;
 
 				pteval |= DMA_PTE_LARGE_PAGE;
-				lvl_pages = lvl_to_nr_pages(largepage_lvl);
-
-				nr_superpages = nr_pages / lvl_pages;
-				end_pfn = iov_pfn + nr_superpages * lvl_pages - 1;
-
-				/*
-				 * Ensure that old small page tables are
-				 * removed to make room for superpage(s).
-				 * We're adding new large pages, so make sure
-				 * we don't remove their parent tables.
-				 */
-				dma_pte_free_pagetable(domain, iov_pfn, end_pfn,
-						       largepage_lvl + 1);
+				end_pfn = ((iov_pfn + nr_pages) & level_mask(largepage_lvl)) - 1;
+				switch_to_super_page(domain, iov_pfn, end_pfn, largepage_lvl);
 			} else {
 				pteval &= ~(uint64_t)DMA_PTE_LARGE_PAGE;
 			}

