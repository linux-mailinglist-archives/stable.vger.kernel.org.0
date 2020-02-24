Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D059316AF7E
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 19:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgBXSnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 13:43:19 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:41329 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBXSnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 13:43:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582569798; x=1614105798;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kPyje+/XOfEjQdrB7QTRmuFrsxAG+rYH9AL0PQwvdNE=;
  b=qbWjfI+6xOnIu+BkowwJ5oPn7QoBMRskc2LJfqHjK5DwdDqswUQ9r8Nn
   hlMIlLDyp8jssIwhA7/r67Qg+Z32BY4oXzm6qgXb4acuDEIWz/TkvwooN
   NuPTjLeloJxs5MY6Ei6DZ6uFnoVe5WZaYT00ihgn6DhsAvzEMoe2jF9l/
   OnakMBccvmrzeAix9B4ESy7bLUJmERP4f1uYs+9TzBMY3c0HpyezHilMl
   GG/HfMRtB69qI08kCw7FnidjqpvLd5vLJIA/egmbc6VhcmKrqhBjCAVUN
   IgP2BHliCQUESHviDka3BM85GSH8foJBRzfdutn/wY3uz0icv2uyetZ8j
   g==;
IronPort-SDR: PKOens8HtCWSPXRHT+9chLEHrx5TVpPfwo1UjdGkU7mF+3Wqo7Dx17i5I1mXgGPZwhE/dqSjeC
 aWUtpqcqSsHQrHdsyBTDs3hEUWiuudeCUWf9Fp4f8SPEIH9nfmi92OssqHqaru4+38RoA4KXhe
 vFHfYmTv9ztaEmMkLB2nl8CCfffpGupDFjopLt5nUGeJNaoOtkgJvbQ+xp4Hdn4koEnCaFoPQQ
 NP8bmyc2XbmuX/4AD8cQOwp+HMivDMeMgO6Pv9qqYaadsCaJvFiwYB1zfo3bytvxEao141BihL
 5OI=
X-IronPort-AV: E=Sophos;i="5.70,481,1574092800"; 
   d="scan'208";a="238740716"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2020 02:43:18 +0800
IronPort-SDR: JMZKU+0ns5toAul+ecPakvLPvsjxXsv2zO6wCsuZa78ifjIZOU9usRcaSSmtQoeW1WbzYXuh+V
 Po6eBrhz2VIqPiwLi7UJdAN/ULj/ZRT8xYcP5F9J/aRoX4eFJxJ207sFq1Tp/le3deUgUCZS/i
 /hbdiJg9mUampAAiZD0RdWsBmtoDcM4PnE3mmNHF9q2/NhGcJ9uuAAjXB/37vqF1o/vUZsqwoY
 8frhIK7iRc9ljH61WWl4PxYpO5U67yDtl8Oxm1lwuT/Q7u+NJoYoNeBf2yP6C0YFWU3MbzWXyV
 fk4RgtvJvhLKBpz+srkD6JaV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 10:35:47 -0800
IronPort-SDR: RvOASzMMFrpqcJKQRou53cbpJNlIhHrZFzRY3bUxKARWEjJNy8WSarN8sQ88As6whP842ilc17
 z9nvmWKl9Jq73GJMV/KPZ08I844CxZ+fEgPhi1Kb+Z72cA1p+CubGxn1SsAnju2kPNLMWTKgZ+
 vseEr/hMdL2XYrABSqqW8QU10EAop4+AocB+ofcYZTnVNS8L76yzmAobZhaNCuckkVzzMJfpMB
 y3uozCvxYPFJ8Jauf1V1gCCPt/Bsi7CGYEMyfKCe72kim4k/rx0JXn05m86Wv/aMw2sEBFlbr4
 f98=
WDCIronportException: Internal
Received: from yoda.sdcorp.global.sandisk.com (HELO yoda.int.fusionio.com) ([10.196.158.80])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Feb 2020 10:43:19 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     atish.patra@wdc.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] RISC-V: Move all address space definition macros to one place
Date:   Mon, 24 Feb 2020 10:43:17 -0800
Message-Id: <20200224184317.16946-1-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If both CONFIG_KASAN and CONFIG_SPARSEMEM_VMEMMAP is set, we get the
following compilation error.

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
macros macros before including pgtable-64.h.

Cc: stable@vger.kernel.org
Fixes: 8ad8b72721d0 (riscv: Add KASAN support)

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/include/asm/pgtable.h | 78 +++++++++++++++++---------------
 1 file changed, 41 insertions(+), 37 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 453afb0a570a..4f6ee48a42e8 100644
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
@@ -452,18 +468,6 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
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
2.25.0

