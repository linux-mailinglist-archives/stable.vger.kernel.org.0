Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FCE3B4077
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 11:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhFYJ2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 05:28:37 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:33525 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230328AbhFYJ2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 05:28:35 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 90EFE194014F;
        Fri, 25 Jun 2021 05:26:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 25 Jun 2021 05:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=srQuYg
        xyUuJDZtOvZynF1zBcMmTqwddv5U+jcpNT4i8=; b=NRP4gqErAo73k2C4b1/Xnf
        Vjgfz0fxY8BSBKSf3k6yeBfU0f8mRsYhbwaK8glpOLT9zanU7NinHm0yVf49vjO+
        SWPSs1Pv2Qwnd8sfqmn3oqIWFS2/+Zv4bebuKWnoE1DvDzmH46/6S0G5y9LCqcHa
        0lD7Skr6E756/4JRRRYLDVgEPXTqlMMg3I7Apxfi+RFC5O+/p7XvBWZfxforGo67
        ik3ZI82tK8q6bwbRt1oOw9C9BzHIqAvWhpXb2FMJi0/uC3qRkjMlGlHNAzVQyJwF
        qZnJaBqCJ02rBXCuxJ42DaDpxXuxA33WOPji4u+p0wmKLtZypGS4VM2BmItAhaYA
        ==
X-ME-Sender: <xms:NaHVYFH-Hzn-aRpazFn_TZ-fqO2o4UgRLeZ6cdpeeFwBLSQoCcwxQg>
    <xme:NaHVYKUqvgl2KUHkbEDx6PEcW-Wbu7M9zs_1aSOm-Ar97qd9hS9Dcyb9QUgNFF9Lw
    _8d2xhvxD40Gw>
X-ME-Received: <xmr:NaHVYHK-xF3EZvqTn0a0BS_0XHlDxNyUaHGw9XJatbYZp90_bxB8dxJfgrBQ0Dnps-Q4E9ZpuAI332JPdnnmD91IxMWVt2AJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegjedguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:NaHVYLHu2mFm_UU_mIWHC5brX_EijfrShyLAiJ3qcuzZBzduAs8fkQ>
    <xmx:NaHVYLVrGiJ5wgREuyjz4zJvHeQXUeuARcsbPBB1uXUnC4WnDuTevA>
    <xmx:NaHVYGMWxwNmgLA08ihFaMpm6QyaUY_xEgasIZ0Bb3BoMx1oYNS8KA>
    <xmx:NqHVYBfxJoW2oD6KKzTUSci7GRnivpU3SpCvcG3di2RB5p6bimRQ0Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Jun 2021 05:26:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset" failed to apply to 5.12-stable tree
To:     bumyong.lee@samsung.com, chanho61.park@samsung.com,
        dominique.martinet@atmark-techno.com, hch@lst.de,
        horia.geanta@nxp.com, konrad.wilk@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Jun 2021 11:26:03 +0200
Message-ID: <16246131632380@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5f89468e2f060031cd89fd4287298e0eaf246bf6 Mon Sep 17 00:00:00 2001
From: Bumyong Lee <bumyong.lee@samsung.com>
Date: Mon, 10 May 2021 18:10:04 +0900
Subject: [PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

in case of driver wants to sync part of ranges with offset,
swiotlb_tbl_sync_single() copies from orig_addr base to tlb_addr with
offset and ends up with data mismatch.

It was removed from
"swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single",
but said logic has to be added back in.

From Linus's email:
"That commit which the removed the offset calculation entirely, because the old

        (unsigned long)tlb_addr & (IO_TLB_SIZE - 1)

was wrong, but instead of removing it, I think it should have just
fixed it to be

        (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);

instead. That way the slot offset always matches the slot index calculation."

(Unfortunatly that broke NVMe).

The use-case that drivers are hitting is as follow:

1. Get dma_addr_t from dma_map_single()

dma_addr_t tlb_addr = dma_map_single(dev, vaddr, vsize, DMA_TO_DEVICE);

    |<---------------vsize------------->|
    +-----------------------------------+
    |                                   | original buffer
    +-----------------------------------+
  vaddr

 swiotlb_align_offset
     |<----->|<---------------vsize------------->|
     +-------+-----------------------------------+
     |       |                                   | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

2. Do something
3. Sync dma_addr_t through dma_sync_single_for_device(..)

dma_sync_single_for_device(dev, tlb_addr + offset, size, DMA_TO_DEVICE);

  Error case.
    Copy data to original buffer but it is from base addr (instead of
  base addr + offset) in original buffer:

 swiotlb_align_offset
     |<----->|<- offset ->|<- size ->|
     +-------+-----------------------------------+
     |       |            |##########|           | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

    |<- size ->|
    +-----------------------------------+
    |##########|                        | original buffer
    +-----------------------------------+
  vaddr

The fix is to copy the data to the original buffer and take into
account the offset, like so:

 swiotlb_align_offset
     |<----->|<- offset ->|<- size ->|
     +-------+-----------------------------------+
     |       |            |##########|           | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

    |<- offset ->|<- size ->|
    +-----------------------------------+
    |            |##########|           | original buffer
    +-----------------------------------+
  vaddr

[One fix which was Linus's that made more sense to as it created a
symmetry would break NVMe. The reason for that is the:
 unsigned int offset = (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);

would come up with the proper offset, but it would lose the
alignment (which this patch contains).]

Fixes: 16fc3cef33a0 ("swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single")
Signed-off-by: Bumyong Lee <bumyong.lee@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reported-by: Dominique MARTINET <dominique.martinet@atmark-techno.com>
Reported-by: Horia Geantă <horia.geanta@nxp.com>
Tested-by: Horia Geantă <horia.geanta@nxp.com>
CC: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8ca7d505d61c..e50df8d8f87e 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -334,6 +334,14 @@ void __init swiotlb_exit(void)
 	io_tlb_default_mem = NULL;
 }
 
+/*
+ * Return the offset into a iotlb slot required to keep the device happy.
+ */
+static unsigned int swiotlb_align_offset(struct device *dev, u64 addr)
+{
+	return addr & dma_get_min_align_mask(dev) & (IO_TLB_SIZE - 1);
+}
+
 /*
  * Bounce: copy the swiotlb buffer from or back to the original dma location
  */
@@ -346,10 +354,17 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	size_t alloc_size = mem->slots[index].alloc_size;
 	unsigned long pfn = PFN_DOWN(orig_addr);
 	unsigned char *vaddr = phys_to_virt(tlb_addr);
+	unsigned int tlb_offset;
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
 
+	tlb_offset = (tlb_addr & (IO_TLB_SIZE - 1)) -
+		     swiotlb_align_offset(dev, orig_addr);
+
+	orig_addr += tlb_offset;
+	alloc_size -= tlb_offset;
+
 	if (size > alloc_size) {
 		dev_WARN_ONCE(dev, 1,
 			"Buffer overflow detected. Allocation size: %zu. Mapping size: %zu.\n",
@@ -390,14 +405,6 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 
 #define slot_addr(start, idx)	((start) + ((idx) << IO_TLB_SHIFT))
 
-/*
- * Return the offset into a iotlb slot required to keep the device happy.
- */
-static unsigned int swiotlb_align_offset(struct device *dev, u64 addr)
-{
-	return addr & dma_get_min_align_mask(dev) & (IO_TLB_SIZE - 1);
-}
-
 /*
  * Carefully handle integer overflow which can occur when boundary_mask == ~0UL.
  */

