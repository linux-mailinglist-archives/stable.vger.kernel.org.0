Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D4E16B055
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 20:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgBXTej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 14:34:39 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30774 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgBXTej (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 14:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582572879; x=1614108879;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TaX3Wv7PyIziT4d1G8a+2bb+qyLwg4X9NtQlx1p7X3Q=;
  b=pWIKHL5pLp3lpk75g+i8mVPHmMAb2bClf739S+9XtaBmGeHl8/LbgT+e
   Z2d2KZzb+lW9uEPoiEzNgx8RmZR5w8TCWjFH6jjgQ9a6Izhbv9x4CZ+IP
   0O49GCNyBPXDLmcAb2b+95jNtWtM2+drd0QTDaDgHe1GV+QRJkptQHu/B
   RhTtBNbXaKccBrDCfQLhfojrIQvDC0rXHT57NuKMRoZH8ckv32qcCTotG
   62IClb8BZBJBSI5Gg7VlMP4pNj1trKKUSmDf9gUDTPK5Oh+oQ05rb09Qo
   DVFxD3WNYgTOqWULyAcm3EDab2pd2dDqVSU3H1nf6In2iDEbTl2imaroV
   Q==;
IronPort-SDR: /GP6jn2SwZSjRQSmLmU2MYE6e6cst6DhkMNRrDaRh9cMgd4+3qy2nRqXmDRJ81IlAOBt9P5KNx
 joPb8nzn+uVi9aNsRzXuyzUcWLaFx+z2u6JmKe1QezZlJrNTnwU6VnJYITxATe4TvJ/suxfRwp
 EhndQl1BXY/IEPB+PLzneERAEVzKahlwPSWVXT40nY2trIqiZtr+mE1Dw3ZvggaocY8flxJ4B+
 fNlFoNUbdfPI49hJUD13sZNrbbGHX74qW8KMjGdJhntHfcuR9C1h9CMk+L6LAKOp88+Nkls2/k
 nJk=
X-IronPort-AV: E=Sophos;i="5.70,481,1574092800"; 
   d="scan'208";a="132056460"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2020 03:34:39 +0800
IronPort-SDR: YG2MsjojoEmZd7aWHauY9CtzTMyU/cjyZxx/I5gFLksZUld+K9jrhlVyQk8RquETIBh+5soJvH
 zMz8dpDKCYbBAKWWA7riYV3fVM1Cdg68Kk5AneZfItIpTrOTODnFiBzUqLrUC7Qywb73MQyrjX
 rXhY4vgzXCmk1QvUebRqd297jfUfm8BUjq+iqbiveZBMgmy6ViBWfDbw1jszcw236Re/xqbEz+
 yq3/ayg+KlUNXH4BSw7eUSG0jnyE5tuaQjkuAoSHgA/4GGItyjtZ59a2mkWEQqVOEAEPLRWtMG
 KNjgIFn8IexulcTKw0RTF7yC
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 11:27:06 -0800
IronPort-SDR: LshLh2Ryp4MLHSTzrZvRnNagIEJVqT3vitq311Cg7HS3btSIzWem6KWLj2Y9gw6moLXBQD7fod
 jcDC6jdh97rNR4tF3uTDPierzwc9cnleC3BOAWeMZMjfvd9hoWCUqel08HYj3PvqoQQ0/j721I
 IfuZjo7wUx74Y1P2TBU09zonoUrf5FZ25qCiA4ecgvYJoG4c0oflw3guWuZsiAbYcKH2Zcp3Rw
 8Dqy89EHkMLPBGLKg4KkD6Kn5R5DqpW0Epb6tsw1zBCssis/eYU7PYuLHHPF0QPklXHpmNVslL
 cic=
WDCIronportException: Internal
Received: from yoda.sdcorp.global.sandisk.com (HELO yoda.int.fusionio.com) ([10.196.158.80])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Feb 2020 11:34:37 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>, stable@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        linux-riscv@lists.infradead.org,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Hu <nickhu@andestech.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] RISC-V: Move all address space definition macros to one place
Date:   Mon, 24 Feb 2020 11:34:36 -0800
Message-Id: <20200224193436.26860-1-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If both CONFIG_KASAN and CONFIG_SPARSEMEM_VMEMMAP are set, we get the
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
macros before including pgtable-64.h.

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

