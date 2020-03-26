Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF8B194BD8
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 23:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgCZWzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 18:55:50 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:13638 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZWzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 18:55:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585263349; x=1616799349;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mjWweq6vKQe1KU4jUKpwBak5e4w+99oGd+5jnkC15WI=;
  b=nCbpvAAus8TtNEhAIxkJLXm993Tfzkt/vothGSMOyCjCQc+ylNQjiJdL
   iRNndMX2Igtvp2BPN6JpnxqT6hsE8b0gihCmTUxzL2DCRI5OgMsIHBtbO
   ESuXx89cOZ0MJGh26ZgpfCAZLY9pPag+fYKymLevZSI0SgenOs4rcPm28
   cGYGwn9pW0c+H9BddzWz5W3bzB0DKHkghPNbwTa+zoKgkej8NEKM20tc0
   LN7Sfs638NWh2CLjb1i7szNBPynskqMDyFbyb53VNxYdBoOPrdtFAQq4H
   /HzmqbMPyjDMYZlI9pELz7TQSecEV7Evc0j6T1mSv1kDuamY49UzT6Vl6
   Q==;
IronPort-SDR: kFjfheMPlvMycIwEdaTDC5ndHkKQQYyiMwZjxI5GJfFngXtmikx/PWKPu7a6e2P7EgnxRZ3Geq
 UPR/t7AVqV/Ag6IuUHl40VyhI4m9z7LhYHaGo31hwLfwKboetFjaqE8ZSdAxEFnMBKkJB6RFFd
 sJdRj2PgEbmpvFCmeYI/ZEPJgi0E2QQnHGouFWt0XZtyk7HJw7xvNE5FtvHnBNvTj4H3RPRvxr
 v9DARMEo9NaQTcAGk1+Gruri3ssns6C17FgR5efYQFmSOCSkI3Oc/Jv0lEEErgri2yd191JDtM
 NcY=
X-IronPort-AV: E=Sophos;i="5.72,310,1580745600"; 
   d="scan'208";a="135062675"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2020 06:55:49 +0800
IronPort-SDR: KyaZhbpuThMMLO2ihdUmR88HzGERWMtXq1LX5pE7hjof/q7heo+z+RkK+8SuZ6/mLSdL0uYcvL
 lH5c2nPdmpEePlN9czMz2iQaecTjjo3GlXMiqYKYgAh74PJ2uPvv6dEshDO8O3QD5yMrB7bLFg
 MpSbn+J9pbuKJ1Ej5oqjvcSrw+6zNNqpsgCakxlEnVfZwXl27InuVfo4lcKfNVC3H1jKBeCPb8
 HSyLz7bUR280SoopSH6AarZ00SPt095VJwZkuvlc4LMVS4SejtxwDUkSOgrVtvHQYC7vdosyUk
 YQtbtZQ6NENaOAb6Oki/GRbR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 15:46:50 -0700
IronPort-SDR: 4+eWXov323OMMXGWI5WnHrjL0z96tBhZxdEnOt+ic195WuK5Bv7pDhJGayUUV/ZljmpbR7M7SH
 u/k7jH1ItiL3HrU1jMtxN65CQAV3VyWLfPKdOkkFCaQ61yv5iui1cvVnGOS79l3a8YiLU01nue
 ADzzJ7L4QPHq8BCEk8yjkXGyAlo0RSb0qksCfegmkGGas0vnEXy1wb8cJLU+2cwgTsY7mARiAS
 kYybxKPO17BeuzZn0IpJWDudQOh43o9YpvhgzOecTb+HYGtRrV3Omne0bweFfcnAvfuBsGEXtQ
 MyA=
WDCIronportException: Internal
Received: from 6hj08h2.ad.shared (HELO yoda.hgst.com) ([10.86.54.191])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Mar 2020 15:55:48 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>, stable@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        linux-riscv@lists.infradead.org, Nick Hu <nickhu@andestech.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] RISC-V: Move all address space definition macros to one place
Date:   Thu, 26 Mar 2020 15:55:46 -0700
Message-Id: <20200326225546.499343-1-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We get the following compilation error if CONFIG_SPARSEMEM_VMEMMAP is set.

---------------------------------------------------------------
./arch/riscv/include/asm/pgtable-64.h: In function ‘pud_page’:
./include/asm-generic/memory_model.h:54:29: error: ‘vmemmap’ undeclared
(first use in this function); did you mean ‘mem_map’?
 #define __pfn_to_page(pfn) (vmemmap + (pfn))
                             ^~~~~~~
./include/asm-generic/memory_model.h:82:21: note: in expansion of
macro ‘__pfn_to_page’

 #define pfn_to_page __pfn_to_page
                     ^~~~~~~~~~~~~
./arch/riscv/include/asm/pgtable-64.h:70:9: note: in expansion of macro
‘pfn_to_page’
  return pfn_to_page(pud_val(pud) >> _PAGE_PFN_SHIFT);
---------------------------------------------------------------

Fix the compliation errors by moving all the address space definition
macros before including pgtable-64.h.

Cc: stable@vger.kernel.org
Fixes: 8ad8b72721d0 (riscv: Add KASAN support)

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
---
 arch/riscv/include/asm/pgtable.h | 78 +++++++++++++++++---------------
 1 file changed, 41 insertions(+), 37 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index e43041519edd..393f2014dfee 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -19,6 +19,47 @@
 #include <asm/tlbflush.h>
 #include <linux/mm_types.h>
 
+#ifdef CONFIG_MMU
+
+#define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
+#define VMALLOC_END      (PAGE_OFFSET - 1)
+#define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
+
+#define BPF_JIT_REGION_SIZE	(SZ_128M)
+#define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
+#define BPF_JIT_REGION_END	(VMALLOC_END)
+
+/*
+ * Roughly size the vmemmap space to be large enough to fit enough
+ * struct pages to map half the virtual address space. Then
+ * position vmemmap directly below the VMALLOC region.
+ */
+#define VMEMMAP_SHIFT \
+	(CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
+#define VMEMMAP_SIZE	BIT(VMEMMAP_SHIFT)
+#define VMEMMAP_END	(VMALLOC_START - 1)
+#define VMEMMAP_START	(VMALLOC_START - VMEMMAP_SIZE)
+
+/*
+ * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
+ * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
+ */
+#define vmemmap		((struct page *)VMEMMAP_START)
+
+#define PCI_IO_SIZE      SZ_16M
+#define PCI_IO_END       VMEMMAP_START
+#define PCI_IO_START     (PCI_IO_END - PCI_IO_SIZE)
+
+#define FIXADDR_TOP      PCI_IO_START
+#ifdef CONFIG_64BIT
+#define FIXADDR_SIZE     PMD_SIZE
+#else
+#define FIXADDR_SIZE     PGDIR_SIZE
+#endif
+#define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
+
+#endif
+
 #ifdef CONFIG_64BIT
 #include <asm/pgtable-64.h>
 #else
@@ -90,31 +131,6 @@ extern pgd_t swapper_pg_dir[];
 #define __S110	PAGE_SHARED_EXEC
 #define __S111	PAGE_SHARED_EXEC
 
-#define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
-#define VMALLOC_END      (PAGE_OFFSET - 1)
-#define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
-
-#define BPF_JIT_REGION_SIZE	(SZ_128M)
-#define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
-#define BPF_JIT_REGION_END	(VMALLOC_END)
-
-/*
- * Roughly size the vmemmap space to be large enough to fit enough
- * struct pages to map half the virtual address space. Then
- * position vmemmap directly below the VMALLOC region.
- */
-#define VMEMMAP_SHIFT \
-	(CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
-#define VMEMMAP_SIZE	BIT(VMEMMAP_SHIFT)
-#define VMEMMAP_END	(VMALLOC_START - 1)
-#define VMEMMAP_START	(VMALLOC_START - VMEMMAP_SIZE)
-
-/*
- * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
- * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
- */
-#define vmemmap		((struct page *)VMEMMAP_START)
-
 static inline int pmd_present(pmd_t pmd)
 {
 	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
@@ -432,18 +448,6 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-#define PCI_IO_SIZE      SZ_16M
-#define PCI_IO_END       VMEMMAP_START
-#define PCI_IO_START     (PCI_IO_END - PCI_IO_SIZE)
-
-#define FIXADDR_TOP      PCI_IO_START
-#ifdef CONFIG_64BIT
-#define FIXADDR_SIZE     PMD_SIZE
-#else
-#define FIXADDR_SIZE     PGDIR_SIZE
-#endif
-#define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
-
 /*
  * Task size is 0x4000000000 for RV64 or 0x9fc00000 for RV32.
  * Note that PGDIR_SIZE must evenly divide TASK_SIZE.
-- 
2.25.1

