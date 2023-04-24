Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC0B6ED0C2
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 16:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjDXO4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 10:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjDXO4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 10:56:21 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F65291
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:56:20 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2eed43bfa4bso4118638f8f.2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682348178; x=1684940178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkHCYERs2BBljlMhTBXSsH1O7MGi6nIkW/+6aA/eVI4=;
        b=AMtqW2anwPxEtt1nIPkqEb6zxDh5CmujpHp4xtyatQhVMicApCxvlg6Cf0ClG2xiJ8
         jibt4iTTDk+ceeazxAJgI+OTqyPQBv51gSAFAwekSsa+DpJIK39Smn3z4FgAQ1RpAQ+b
         OFnpFEXffd049x9gE3YRADXxmFHF7cyshahEiYcQWxiJY3wlUohgTX9rp+ldw1jeoEbU
         Bok6zIbF+WMs/jHfCM2IxOuE0OF/fIjpV3NiA6zycN/V/5XYQYiUmn7FAI0bUsBDGLau
         q0c9IZjFdmAr5+M5gb0/gU9ndSJoSCTwn/C46BjX+F77UTk6v+liiCEgmuiQaKJnfXDJ
         s3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682348178; x=1684940178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nkHCYERs2BBljlMhTBXSsH1O7MGi6nIkW/+6aA/eVI4=;
        b=iO7ID60qucOx0I8b34NePKxFZkXnGXrSx3RGfd2Yhz+7z7RwYBA3fqqy09B87AB3WK
         SilwqrlkDy+n2QOivdbwa3JU4Aruu5LlVcX27c750UghVsmGO0pcsoRH7YYlQs+gRr3b
         kHWRk3Sk7+p7oGRez06ixlKcM0SH03B4rTUjXlTgBFQM09p7UZG9/9RBRMIAA43kuVR4
         wK47C5XM/H8xic9ryOAeP86uqgSEq5CGfgzIxg8QzE2hV7Gpfxl40RCAWhDp3rccAD3R
         dvAFRFy9JXnFG/7y5YQJrkAoiWMgce1sazdsskLy9Z1K1BN+/pbJ7k1l6jfVaQtet+mK
         eYGw==
X-Gm-Message-State: AAQBX9cDHgoUs2z8lQ8bMF1BA5iEixxd9EBP4Gk5nGdyvDb/y/ufZkRo
        VQFHEcfGRQeRFJMrvPcCeiI08onBMlUGqYHSyGc=
X-Google-Smtp-Source: AKy350a7CXylYmdCIXqMxkRrBhD3hSQIPpcttjQAQHWE8y0FyDQVIgp3/KKYrmPvrszEBPhK8XjpEw==
X-Received: by 2002:adf:eb86:0:b0:2f9:f05:e4f8 with SMTP id t6-20020adfeb86000000b002f90f05e4f8mr9430289wrn.18.1682348178203;
        Mon, 24 Apr 2023 07:56:18 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id l18-20020a05600012d200b002ceacff44c7sm10957646wrx.83.2023.04.24.07.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:56:17 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 6.1.24 1/3] riscv: Move early dtb mapping into the fixmap region
Date:   Mon, 24 Apr 2023 16:55:00 +0200
Message-Id: <20230424145502.194770-2-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230424145502.194770-1-alexghiti@rivosinc.com>
References: <20230424145502.194770-1-alexghiti@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ef69d2559fe91f23d27a3d6fd640b5641787d22e upstream.

riscv establishes 2 virtual mappings:

- early_pg_dir maps the kernel which allows to discover the system
  memory
- swapper_pg_dir installs the final mapping (linear mapping included)

We used to map the dtb in early_pg_dir using DTB_EARLY_BASE_VA, and this
mapping was not carried over in swapper_pg_dir. It happens that
early_init_fdt_scan_reserved_mem() must be called before swapper_pg_dir is
setup otherwise we could allocate reserved memory defined in the dtb.
And this function initializes reserved_mem variable with addresses that
lie in the early_pg_dir dtb mapping: when those addresses are reused
with swapper_pg_dir, this mapping does not exist and then we trap.

The previous "fix" was incorrect as early_init_fdt_scan_reserved_mem()
must be called before swapper_pg_dir is set up otherwise we could
allocate in reserved memory defined in the dtb.

So move the dtb mapping in the fixmap region which is established in
early_pg_dir and handed over to swapper_pg_dir.

This patch had to be backported because:
- the documentation for sv57 is not present here (as sv48/57 are not
  present)

Fixes: 922b0375fc93 ("riscv: Fix memblock reservation for device tree blob")
Fixes: 8f3a2b4a96dc ("RISC-V: Move DT mapping outof fixmap")
Fixes: 50e63dd8ed92 ("riscv: fix reserved memory setup")
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/all/f8e67f82-103d-156c-deb0-d6d6e2756f5e@microchip.com/
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Cc: <stable@vger.kernel.org> # 6.1.x
---
 Documentation/riscv/vm-layout.rst |  4 +-
 arch/riscv/include/asm/fixmap.h   |  8 ++++
 arch/riscv/include/asm/pgtable.h  |  8 +++-
 arch/riscv/kernel/setup.c         |  1 -
 arch/riscv/mm/init.c              | 61 +++++++++++++++++--------------
 5 files changed, 50 insertions(+), 32 deletions(-)

diff --git a/Documentation/riscv/vm-layout.rst b/Documentation/riscv/vm-layout.rst
index 5b36e45fef60..edb533128712 100644
--- a/Documentation/riscv/vm-layout.rst
+++ b/Documentation/riscv/vm-layout.rst
@@ -47,7 +47,7 @@ RISC-V Linux Kernel SV39
                                                               | Kernel-space virtual memory, shared between all processes:
   ____________________________________________________________|___________________________________________________________
                     |            |                  |         |
-   ffffffc6fee00000 | -228    GB | ffffffc6feffffff |    2 MB | fixmap
+   ffffffc6fea00000 | -228    GB | ffffffc6feffffff |    6 MB | fixmap
    ffffffc6ff000000 | -228    GB | ffffffc6ffffffff |   16 MB | PCI io
    ffffffc700000000 | -228    GB | ffffffc7ffffffff |    4 GB | vmemmap
    ffffffc800000000 | -224    GB | ffffffd7ffffffff |   64 GB | vmalloc/ioremap space
@@ -83,7 +83,7 @@ RISC-V Linux Kernel SV48
                                                               | Kernel-space virtual memory, shared between all processes:
   ____________________________________________________________|___________________________________________________________
                     |            |                  |         |
-   ffff8d7ffee00000 |  -114.5 TB | ffff8d7ffeffffff |    2 MB | fixmap
+   ffff8d7ffea00000 |  -114.5 TB | ffff8d7ffeffffff |    6 MB | fixmap
    ffff8d7fff000000 |  -114.5 TB | ffff8d7fffffffff |   16 MB | PCI io
    ffff8d8000000000 |  -114.5 TB | ffff8f7fffffffff |    2 TB | vmemmap
    ffff8f8000000000 |  -112.5 TB | ffffaf7fffffffff |   32 TB | vmalloc/ioremap space
diff --git a/arch/riscv/include/asm/fixmap.h b/arch/riscv/include/asm/fixmap.h
index 5c3e7b97fcc6..0a55099bb734 100644
--- a/arch/riscv/include/asm/fixmap.h
+++ b/arch/riscv/include/asm/fixmap.h
@@ -22,6 +22,14 @@
  */
 enum fixed_addresses {
 	FIX_HOLE,
+	/*
+	 * The fdt fixmap mapping must be PMD aligned and will be mapped
+	 * using PMD entries in fixmap_pmd in 64-bit and a PGD entry in 32-bit.
+	 */
+	FIX_FDT_END,
+	FIX_FDT = FIX_FDT_END + FIX_FDT_SIZE / PAGE_SIZE - 1,
+
+	/* Below fixmaps will be mapped using fixmap_pte */
 	FIX_PTE,
 	FIX_PMD,
 	FIX_PUD,
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 92ec2d9d7273..2aeaf8e3a4ab 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -87,9 +87,13 @@
 
 #define FIXADDR_TOP      PCI_IO_START
 #ifdef CONFIG_64BIT
-#define FIXADDR_SIZE     PMD_SIZE
+#define MAX_FDT_SIZE	 PMD_SIZE
+#define FIX_FDT_SIZE	 (MAX_FDT_SIZE + SZ_2M)
+#define FIXADDR_SIZE     (PMD_SIZE + FIX_FDT_SIZE)
 #else
-#define FIXADDR_SIZE     PGDIR_SIZE
+#define MAX_FDT_SIZE	 PGDIR_SIZE
+#define FIX_FDT_SIZE	 MAX_FDT_SIZE
+#define FIXADDR_SIZE     (PGDIR_SIZE + FIX_FDT_SIZE)
 #endif
 #define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
 
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 86acd690d529..ef98db2826fc 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -283,7 +283,6 @@ void __init setup_arch(char **cmdline_p)
 	else
 		pr_err("No DTB found in kernel mappings\n");
 #endif
-	early_init_fdt_scan_reserved_mem();
 	misc_mem_init();
 
 	init_resources();
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 50a1b6edd491..5570c52deb0b 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -57,7 +57,6 @@ unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)]
 EXPORT_SYMBOL(empty_zero_page);
 
 extern char _start[];
-#define DTB_EARLY_BASE_VA      PGDIR_SIZE
 void *_dtb_early_va __initdata;
 uintptr_t _dtb_early_pa __initdata;
 
@@ -236,6 +235,14 @@ static void __init setup_bootmem(void)
 	set_max_mapnr(max_low_pfn - ARCH_PFN_OFFSET);
 
 	reserve_initrd_mem();
+
+	/*
+	 * No allocation should be done before reserving the memory as defined
+	 * in the device tree, otherwise the allocation could end up in a
+	 * reserved region.
+	 */
+	early_init_fdt_scan_reserved_mem();
+
 	/*
 	 * If DTB is built in, no need to reserve its memblock.
 	 * Otherwise, do reserve it but avoid using
@@ -279,9 +286,6 @@ pgd_t trampoline_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
 static pte_t fixmap_pte[PTRS_PER_PTE] __page_aligned_bss;
 
 pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
-static p4d_t __maybe_unused early_dtb_p4d[PTRS_PER_P4D] __initdata __aligned(PAGE_SIZE);
-static pud_t __maybe_unused early_dtb_pud[PTRS_PER_PUD] __initdata __aligned(PAGE_SIZE);
-static pmd_t __maybe_unused early_dtb_pmd[PTRS_PER_PMD] __initdata __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_XIP_KERNEL
 #define pt_ops			(*(struct pt_alloc_ops *)XIP_FIXUP(&pt_ops))
@@ -626,9 +630,6 @@ static void __init create_p4d_mapping(p4d_t *p4dp,
 #define trampoline_pgd_next	(pgtable_l5_enabled ?			\
 		(uintptr_t)trampoline_p4d : (pgtable_l4_enabled ?	\
 		(uintptr_t)trampoline_pud : (uintptr_t)trampoline_pmd))
-#define early_dtb_pgd_next	(pgtable_l5_enabled ?			\
-		(uintptr_t)early_dtb_p4d : (pgtable_l4_enabled ?	\
-		(uintptr_t)early_dtb_pud : (uintptr_t)early_dtb_pmd))
 #else
 #define pgd_next_t		pte_t
 #define alloc_pgd_next(__va)	pt_ops.alloc_pte(__va)
@@ -636,7 +637,6 @@ static void __init create_p4d_mapping(p4d_t *p4dp,
 #define create_pgd_next_mapping(__nextp, __va, __pa, __sz, __prot)	\
 	create_pte_mapping(__nextp, __va, __pa, __sz, __prot)
 #define fixmap_pgd_next		((uintptr_t)fixmap_pte)
-#define early_dtb_pgd_next	((uintptr_t)early_dtb_pmd)
 #define create_p4d_mapping(__pmdp, __va, __pa, __sz, __prot) do {} while(0)
 #define create_pud_mapping(__pmdp, __va, __pa, __sz, __prot) do {} while(0)
 #define create_pmd_mapping(__pmdp, __va, __pa, __sz, __prot) do {} while(0)
@@ -859,32 +859,28 @@ static void __init create_kernel_page_table(pgd_t *pgdir, bool early)
  * this means 2 PMD entries whereas for 32-bit kernel, this is only 1 PGDIR
  * entry.
  */
-static void __init create_fdt_early_page_table(pgd_t *pgdir, uintptr_t dtb_pa)
+static void __init create_fdt_early_page_table(pgd_t *pgdir,
+					       uintptr_t fix_fdt_va,
+					       uintptr_t dtb_pa)
 {
-#ifndef CONFIG_BUILTIN_DTB
 	uintptr_t pa = dtb_pa & ~(PMD_SIZE - 1);
 
-	create_pgd_mapping(early_pg_dir, DTB_EARLY_BASE_VA,
-			   IS_ENABLED(CONFIG_64BIT) ? early_dtb_pgd_next : pa,
-			   PGDIR_SIZE,
-			   IS_ENABLED(CONFIG_64BIT) ? PAGE_TABLE : PAGE_KERNEL);
-
-	if (pgtable_l5_enabled)
-		create_p4d_mapping(early_dtb_p4d, DTB_EARLY_BASE_VA,
-				   (uintptr_t)early_dtb_pud, P4D_SIZE, PAGE_TABLE);
-
-	if (pgtable_l4_enabled)
-		create_pud_mapping(early_dtb_pud, DTB_EARLY_BASE_VA,
-				   (uintptr_t)early_dtb_pmd, PUD_SIZE, PAGE_TABLE);
+#ifndef CONFIG_BUILTIN_DTB
+	/* Make sure the fdt fixmap address is always aligned on PMD size */
+	BUILD_BUG_ON(FIX_FDT % (PMD_SIZE / PAGE_SIZE));
 
-	if (IS_ENABLED(CONFIG_64BIT)) {
-		create_pmd_mapping(early_dtb_pmd, DTB_EARLY_BASE_VA,
+	/* In 32-bit only, the fdt lies in its own PGD */
+	if (!IS_ENABLED(CONFIG_64BIT)) {
+		create_pgd_mapping(early_pg_dir, fix_fdt_va,
+				   pa, MAX_FDT_SIZE, PAGE_KERNEL);
+	} else {
+		create_pmd_mapping(fixmap_pmd, fix_fdt_va,
 				   pa, PMD_SIZE, PAGE_KERNEL);
-		create_pmd_mapping(early_dtb_pmd, DTB_EARLY_BASE_VA + PMD_SIZE,
+		create_pmd_mapping(fixmap_pmd, fix_fdt_va + PMD_SIZE,
 				   pa + PMD_SIZE, PMD_SIZE, PAGE_KERNEL);
 	}
 
-	dtb_early_va = (void *)DTB_EARLY_BASE_VA + (dtb_pa & (PMD_SIZE - 1));
+	dtb_early_va = (void *)fix_fdt_va + (dtb_pa & (PMD_SIZE - 1));
 #else
 	/*
 	 * For 64-bit kernel, __va can't be used since it would return a linear
@@ -1054,7 +1050,8 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 	create_kernel_page_table(early_pg_dir, true);
 
 	/* Setup early mapping for FDT early scan */
-	create_fdt_early_page_table(early_pg_dir, dtb_pa);
+	create_fdt_early_page_table(early_pg_dir,
+				    __fix_to_virt(FIX_FDT), dtb_pa);
 
 	/*
 	 * Bootime fixmap only can handle PMD_SIZE mapping. Thus, boot-ioremap
@@ -1096,6 +1093,16 @@ static void __init setup_vm_final(void)
 	u64 i;
 
 	/* Setup swapper PGD for fixmap */
+#if !defined(CONFIG_64BIT)
+	/*
+	 * In 32-bit, the device tree lies in a pgd entry, so it must be copied
+	 * directly in swapper_pg_dir in addition to the pgd entry that points
+	 * to fixmap_pte.
+	 */
+	unsigned long idx = pgd_index(__fix_to_virt(FIX_FDT));
+
+	set_pgd(&swapper_pg_dir[idx], early_pg_dir[idx]);
+#endif
 	create_pgd_mapping(swapper_pg_dir, FIXADDR_START,
 			   __pa_symbol(fixmap_pgd_next),
 			   PGDIR_SIZE, PAGE_TABLE);
-- 
2.37.2

