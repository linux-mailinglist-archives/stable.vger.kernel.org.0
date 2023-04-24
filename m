Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9796ECBAA
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 13:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDXL5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 07:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjDXL5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 07:57:39 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A763BE45
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 04:57:23 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f1763ee8f8so28803555e9.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 04:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682337442; x=1684929442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6LY+2v6y8cj7byujw6j5CSOvKcL15X2PT/cRljqLCU4=;
        b=V7WSCnHlNiN3TAnNhSURgIYeeVFWrs5SENzUH4ut7wM/vbQEiG963p6m+NiyfkzLKR
         ezx54QlZ0vfNeU2PdXppjqA1krHMPOiQEC2bsAoQMNhIrrTKDw2cGewKlfctsz58X5EM
         g71hSxO4h+iqITi6I8e/zJJFpxYO+k1+7iho94nRtMPpIRb4+KvkutY0lD0N1W4iDd1m
         S3mY6PubO0tNSjqr6nZtdGIN8zFZuGiINXLpTAcNFE+zavd4CB6LyFpx8Us7YSMoPL1j
         RXw6WEbWwKRKcOT9u+0JNwNR1iOOy8yoxjoFw7ThMT/5o6+sATXc5jMxeKkT/aElpzEB
         L3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682337442; x=1684929442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6LY+2v6y8cj7byujw6j5CSOvKcL15X2PT/cRljqLCU4=;
        b=JjzIOtKsoRJlbsAUCdKYMuAnz+2RkWfGaZu9Yt16FZOomyQ0BTsj9PojFxrlCQPQiG
         xj7zrVgPEoVCP83qfX4pbUG+3z6JvfdLCmfzX3Zn1o3yVYWlYOdvUIGQbbdkVJAeR4ml
         dStv9Kcnkzi/7I3+JvaSLRi80yIuDGdGRlMQtN/bhX30Cku8p8GMLTtThi9pDfjyjz8D
         By2VlysyxpXy/OjMOhYZuu3wksUEqJeVylGCoJgikU1ltVZ3GGch/rUAonVO5HcckcHp
         qVcqoCdaRPnTJPqbr7JBf8pHBeYoR11Fme5Sm9WrbWW631Ei5on7u+ro7yTNnqATM4HC
         hRuQ==
X-Gm-Message-State: AAQBX9fzFi9M19EUv1AYOGHswoeyrbTRWlqedVD7a48uTk8hSwvEAz09
        JgwCAkcR8BGeknXZvSAu9dEbsMO6pyMgDWV5yc0=
X-Google-Smtp-Source: AKy350aLUw0UvPG5vPueDv/bX4rTmeko8ya3Yyb1NusD/bi7gzDQb+jCGHkhDcWlNhBnk0V7muheRg==
X-Received: by 2002:a05:600c:258:b0:3eb:29fe:f922 with SMTP id 24-20020a05600c025800b003eb29fef922mr7015543wmj.29.1682337441823;
        Mon, 24 Apr 2023 04:57:21 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id m5-20020a5d6a05000000b002f01e181c4asm10723583wru.5.2023.04.24.04.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 04:57:21 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 5.15.108 1/3] [ Upstream commit ef69d2559fe9 ]
Date:   Mon, 24 Apr 2023 13:56:16 +0200
Message-Id: <20230424115618.185321-2-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230424115618.185321-1-alexghiti@rivosinc.com>
References: <20230424115618.185321-1-alexghiti@rivosinc.com>
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

riscv: Move early dtb mapping into the fixmap region

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
- handling of sv48/57 is not needed (as not present)

Fixes: 922b0375fc93 ("riscv: Fix memblock reservation for device tree blob")
Fixes: 8f3a2b4a96dc ("RISC-V: Move DT mapping outof fixmap")
Fixes: 50e63dd8ed92 ("riscv: fix reserved memory setup")
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/all/f8e67f82-103d-156c-deb0-d6d6e2756f5e@microchip.com/
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Cc: <stable@vger.kernel.org> # 5.15.x
---
 Documentation/riscv/vm-layout.rst |  2 +-
 arch/riscv/include/asm/fixmap.h   |  8 ++++++
 arch/riscv/include/asm/pgtable.h  |  8 ++++--
 arch/riscv/kernel/setup.c         |  1 -
 arch/riscv/mm/init.c              | 47 ++++++++++++++++++++++---------
 5 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/Documentation/riscv/vm-layout.rst b/Documentation/riscv/vm-layout.rst
index b7f98930d38d..a2ec11da38b0 100644
--- a/Documentation/riscv/vm-layout.rst
+++ b/Documentation/riscv/vm-layout.rst
@@ -48,7 +48,7 @@ RISC-V Linux Kernel SV39
   ____________________________________________________________|___________________________________________________________
                     |            |                  |         |
    ffffffc000000000 | -256    GB | ffffffc7ffffffff |   32 GB | kasan
-   ffffffcefee00000 | -196    GB | ffffffcefeffffff |    2 MB | fixmap
+   ffffffcefea00000 | -196    GB | ffffffcefeffffff |    6 MB | fixmap
    ffffffceff000000 | -196    GB | ffffffceffffffff |   16 MB | PCI io
    ffffffcf00000000 | -196    GB | ffffffcfffffffff |    4 GB | vmemmap
    ffffffd000000000 | -192    GB | ffffffdfffffffff |   64 GB | vmalloc/ioremap space
diff --git a/arch/riscv/include/asm/fixmap.h b/arch/riscv/include/asm/fixmap.h
index 54cbf07fb4e9..8839cd2b28d1 100644
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
 	FIX_TEXT_POKE1,
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 39b550310ec6..397cb945b16e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -66,9 +66,13 @@
 
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
index 14b84d09354a..f874fe07fb78 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -291,7 +291,6 @@ void __init setup_arch(char **cmdline_p)
 	else
 		pr_err("No DTB found in kernel mappings\n");
 #endif
-	early_init_fdt_scan_reserved_mem();
 	misc_mem_init();
 
 	init_resources();
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 830f53b141a0..3f62ff02efc4 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -49,7 +49,6 @@ unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)]
 EXPORT_SYMBOL(empty_zero_page);
 
 extern char _start[];
-#define DTB_EARLY_BASE_VA      PGDIR_SIZE
 void *_dtb_early_va __initdata;
 uintptr_t _dtb_early_pa __initdata;
 
@@ -216,6 +215,14 @@ static void __init setup_bootmem(void)
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
@@ -265,7 +272,6 @@ pgd_t trampoline_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
 static pte_t fixmap_pte[PTRS_PER_PTE] __page_aligned_bss;
 
 pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
-static pmd_t __maybe_unused early_dtb_pmd[PTRS_PER_PMD] __initdata __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_XIP_KERNEL
 #define riscv_pfn_base         (*(unsigned long  *)XIP_FIXUP(&riscv_pfn_base))
@@ -580,24 +586,28 @@ static void __init create_kernel_page_table(pgd_t *pgdir, bool early)
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
-			   IS_ENABLED(CONFIG_64BIT) ? (uintptr_t)early_dtb_pmd : pa,
-			   PGDIR_SIZE,
-			   IS_ENABLED(CONFIG_64BIT) ? PAGE_TABLE : PAGE_KERNEL);
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
@@ -685,7 +695,8 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 	create_kernel_page_table(early_pg_dir, true);
 
 	/* Setup early mapping for FDT early scan */
-	create_fdt_early_page_table(early_pg_dir, dtb_pa);
+	create_fdt_early_page_table(early_pg_dir,
+				    __fix_to_virt(FIX_FDT), dtb_pa);
 
 	/*
 	 * Bootime fixmap only can handle PMD_SIZE mapping. Thus, boot-ioremap
@@ -735,6 +746,16 @@ static void __init setup_vm_final(void)
 	pt_ops.get_pmd_virt = get_pmd_virt_fixmap;
 #endif
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

