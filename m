Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A4E528192
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 12:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbiEPKNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 06:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238639AbiEPKNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 06:13:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EDAB7CB
        for <stable@vger.kernel.org>; Mon, 16 May 2022 03:13:12 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GA1xZt027707;
        Mon, 16 May 2022 10:12:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=Vic6PaTSAdRt7hC4aRJ4/5Ang5VIukVR3SKjfP7XSQo=;
 b=SDdiKQ8ieCQ0vZXBIEfN0jWRXWRI9rhzPeXkAeGpkaDY2OfeyuIwoF1Oku98+DmTO4+c
 Lgq7lPjniqT6uFEtggDAtaSlt/esEa3s4QDNOMIb9y1Aed+J5yotj2gNnmt3xnNuzgIm
 NruXcNkdl/9DiSEoD9XJiSgDfMQFU64uvS11H3ahNqcoxBOBzmu2/9u3y07xOtbgsjJ1
 56A6jXIBS+i4eQgCVHb6EoqKgGu522rU8HrAT5tZ2sP30EKT5LaUIZmhZwohX1zsepjv
 cldKwV+HN0vT2uZK+kNbjbapKOUtFgcnYsFsrMyzwzEXG41uFowsfMd8D0og3K3PyRFz EA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3mgm86f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 10:12:55 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GA9gpi032380;
        Mon, 16 May 2022 10:12:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428svy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 10:12:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GACplD46072172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 10:12:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E935611C050;
        Mon, 16 May 2022 10:12:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6B6C11C04C;
        Mon, 16 May 2022 10:12:49 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.161.108])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 16 May 2022 10:12:49 +0000 (GMT)
Date:   Mon, 16 May 2022 13:12:48 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     rppt@kernel.org, akpm@linux-foundation.org, ardb@kernel.org,
        bot@kernelci.org, broonie@kernel.org, catalin.marinas@arm.com,
        linux@armlinux.org.uk, mark-pk.tsai@mediatek.com,
        stable@vger.kernel.org, tony@atomide.com, will@kernel.org
Subject: Re: FAILED: patch "[PATCH] arm[64]/memremap: don't abuse pfn_valid()
 to ensure presence" failed to apply to 5.10-stable tree
Message-ID: <YoIjoM96TItpIT8U@linux.ibm.com>
References: <165268901815650@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165268901815650@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iQttE0dP9BLbH1vqgawjxxanTQF3HQx6
X-Proofpoint-GUID: iQttE0dP9BLbH1vqgawjxxanTQF3HQx6
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_06,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 adultscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 16, 2022 at 10:16:58AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The patch below applies to 5.10.y and 5.4.y.

As for 4.19.y and older kernels, the issue this patch fixes won't reproduce
because these kernels don't have backports of pfn_valid() implementation.
 
From c52469701a0d3f8d8805794f75d8fd135f580010 Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.ibm.com>
Date: Sun, 24 Apr 2022 20:05:57 +0300
Subject: [PATCH] arm[64]/memremap: don't abuse pfn_valid() to ensure presence
 of linear map

The semantics of pfn_valid() is to check presence of the memory map for a
PFN and not whether a PFN is covered by the linear map. The memory map may
be present for NOMAP memory regions, but they won't be mapped in the linear
mapping.  Accessing such regions via __va() when they are memremap()'ed
will cause a crash.

On v5.4.y the crash happens on qemu-arm with UEFI [1]:

<1>[    0.084476] 8<--- cut here ---
<1>[    0.084595] Unable to handle kernel paging request at virtual address dfb76000
<1>[    0.084938] pgd = (ptrval)
<1>[    0.085038] [dfb76000] *pgd=5f7fe801, *pte=00000000, *ppte=00000000

...

<4>[    0.093923] [<c0ed6ce8>] (memcpy) from [<c16a06f8>] (dmi_setup+0x60/0x418)
<4>[    0.094204] [<c16a06f8>] (dmi_setup) from [<c16a38d4>] (arm_dmi_init+0x8/0x10)
<4>[    0.094408] [<c16a38d4>] (arm_dmi_init) from [<c0302e9c>] (do_one_initcall+0x50/0x228)
<4>[    0.094619] [<c0302e9c>] (do_one_initcall) from [<c16011e4>] (kernel_init_freeable+0x15c/0x1f8)
<4>[    0.094841] [<c16011e4>] (kernel_init_freeable) from [<c0f028cc>] (kernel_init+0x8/0x10c)
<4>[    0.095057] [<c0f028cc>] (kernel_init) from [<c03010e8>] (ret_from_fork+0x14/0x2c)

On kernels v5.10.y and newer the same crash won't reproduce on ARM because
commit b10d6bca8720 ("arch, drivers: replace for_each_membock() with
for_each_mem_range()") changed the way memory regions are registered in the
resource tree, but that merely covers up the problem.

On ARM64 memory resources registered in yet another way and there the
issue of wrong usage of pfn_valid() to ensure availability of the linear
map is also covered.

Implement arch_memremap_can_ram_remap() on ARM and ARM64 to prevent access
to NOMAP regions via the linear mapping in memremap().

Link: https://lore.kernel.org/all/Yl65zxGgFzF1Okac@sirena.org.uk
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Tested-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org	# 5.4+
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 arch/arm/include/asm/io.h   | 3 +++
 arch/arm/mm/ioremap.c       | 8 ++++++++
 arch/arm64/include/asm/io.h | 4 ++++
 arch/arm64/mm/ioremap.c     | 9 +++++++++
 4 files changed, 24 insertions(+)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 7a0596fcb2e7..3cc0f6d50883 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -457,6 +457,9 @@ extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
 extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
 extern int devmem_is_allowed(unsigned long pfn);
+extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+					unsigned long flags);
+#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
 #endif
 
 /*
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 513c26b46db3..841b66515b37 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -500,3 +500,11 @@ void __init early_ioremap_init(void)
 {
 	early_ioremap_setup();
 }
+
+bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+				 unsigned long flags)
+{
+	unsigned long pfn = PHYS_PFN(offset);
+
+	return memblock_is_map_memory(pfn);
+}
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 323cb306bd28..8ac55ff3094a 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -204,4 +204,8 @@ extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
 
 extern int devmem_is_allowed(unsigned long pfn);
 
+extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+					unsigned long flags);
+#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
+
 #endif	/* __ASM_IO_H */
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 9be71bee902c..8dac7fcfb4bd 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/io.h>
+#include <linux/memblock.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
@@ -100,3 +101,11 @@ void __init early_ioremap_init(void)
 {
 	early_ioremap_setup();
 }
+
+bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+				 unsigned long flags)
+{
+	unsigned long pfn = PHYS_PFN(offset);
+
+	return memblock_is_map_memory(pfn);
+}
-- 
2.28.0

> thanks,
> 
> greg k-h
> 
-- 
Sincerely yours,
Mike.
