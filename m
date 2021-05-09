Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06253777CF
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 19:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEIRb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 13:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhEIRb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 13:31:58 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79332C061573;
        Sun,  9 May 2021 10:30:54 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m37so11645028pgb.8;
        Sun, 09 May 2021 10:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Nb89vbEryB72DxR+ygHAFRrSJe422UKLD3iZ2RGOvk=;
        b=Q5VDFY7KNDw5hfUqhiW/b5teymKYEEGimRIA4IJABt2heMJ0re4Wqy89JzO7YNyF+a
         lcyz23vCiNtz3fHqMnNGtAZJOSUj6fad5GxpAzfRG8XUrs90i2nsoND9GbgcCMcOU0Ad
         ak1yeuZW3I7zff4CH/7o71EjKFtQIY1ZC0peGclbjQzU3JuYuuXXEDfd6s92AoQC9/Xb
         cyTzbIjnfF1YkYxJ7IgqqZ9Ilm24+Lq28SpHKZ3r9UMbvhq4ndERLY1+I8PlsHEdS2tZ
         84Ff8KRCdnnL9s5gu+RKhKDz6OYV37w0BxKCeG0SzMYUT0r/EEX5oytCp8cHsh+D7AgN
         SDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Nb89vbEryB72DxR+ygHAFRrSJe422UKLD3iZ2RGOvk=;
        b=q+7rZ401ajOkD7EUs7Jj1tg1CNPJjZPaEPyYod4s5mO2WUbpzYZlWdVLoSP1YHFfWm
         3rvewk6aFLyWIVFZv8ECZf9nShZZCRcjRUoA+goWs22NEMNKwrqMl8eRz+cwDp0JQirP
         MsFaeUwGTM6L5orm92XK32bKXQUt40dVWVs58/czKZNQ2ci6HqMdBhcSGSzQ+eLOhktP
         byijtEf4wy6dUXONim8eLiwaJ437GsN3vinhqHbFQOX+BtJzz+pw3q38Kf4Es9bWAAiu
         zvgZ55TAl3iwwDwwlkYrowKYrp3zy2y5jCzhghGW+ufE7zETJCocgb/WYcbPi0CR5/CS
         9LVQ==
X-Gm-Message-State: AOAM531WUSEqhv9/sK4D+ADwMPyERlibMdJnP7DLtA3kijV4CwqT39ke
        LZWhl995uu70WfYWvV7LjfaWsqPSTKY=
X-Google-Smtp-Source: ABdhPJysTvO/myEsso7v+v4d3MfYKJ8z1x7YQAUrCYVCmGrD/aTxOgqckVFMtdJbRZYDaDLCVfCeJw==
X-Received: by 2002:aa7:8d4c:0:b029:21c:104b:f6cb with SMTP id s12-20020aa78d4c0000b029021c104bf6cbmr20911873pfe.26.1620581453471;
        Sun, 09 May 2021 10:30:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d129sm2637918pfa.6.2021.05.09.10.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 10:30:52 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@gooogle.com>,
        Joe Perches <joe@perches.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.10 2/3] ARM: 9012/1: move device tree mapping out of linear region
Date:   Sun,  9 May 2021 10:30:28 -0700
Message-Id: <20210509173029.1653182-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210509173029.1653182-1-f.fainelli@gmail.com>
References: <20210509173029.1653182-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 7a1be318f5795cb66fa0dc86b3ace427fe68057f upstream

On ARM, setting up the linear region is tricky, given the constraints
around placement and alignment of the memblocks, and how the kernel
itself as well as the DT are placed in physical memory.

Let's simplify matters a bit, by moving the device tree mapping to the
top of the address space, right between the end of the vmalloc region
and the start of the the fixmap region, and create a read-only mapping
for it that is independent of the size of the linear region, and how it
is organized.

Since this region was formerly used as a guard region, which will now be
populated fully on LPAE builds by this read-only mapping (which will
still be able to function as a guard region for stray writes), bump the
start of the [underutilized] fixmap region by 512 KB as well, to ensure
that there is always a proper guard region here. Doing so still leaves
ample room for the fixmap space, even with NR_CPUS set to its maximum
value of 32.

Tested-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/arm/memory.rst  |  7 ++++++-
 arch/arm/include/asm/fixmap.h |  2 +-
 arch/arm/include/asm/memory.h |  5 +++++
 arch/arm/kernel/head.S        |  5 ++---
 arch/arm/kernel/setup.c       | 11 ++++++++---
 arch/arm/mm/init.c            |  1 -
 arch/arm/mm/mmu.c             | 20 ++++++++++++++------
 arch/arm/mm/pv-fixup-asm.S    |  4 ++--
 8 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/Documentation/arm/memory.rst b/Documentation/arm/memory.rst
index 0521b4ce5c96..34bb23c44a71 100644
--- a/Documentation/arm/memory.rst
+++ b/Documentation/arm/memory.rst
@@ -45,9 +45,14 @@ fffe8000	fffeffff	DTCM mapping area for platforms with
 fffe0000	fffe7fff	ITCM mapping area for platforms with
 				ITCM mounted inside the CPU.
 
-ffc00000	ffefffff	Fixmap mapping region.  Addresses provided
+ffc80000	ffefffff	Fixmap mapping region.  Addresses provided
 				by fix_to_virt() will be located here.
 
+ffc00000	ffc7ffff	Guard region
+
+ff800000	ffbfffff	Permanent, fixed read-only mapping of the
+				firmware provided DT blob
+
 fee00000	feffffff	Mapping of PCI I/O space. This is a static
 				mapping within the vmalloc space.
 
diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index fc56fc3e1931..9575b404019c 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -2,7 +2,7 @@
 #ifndef _ASM_FIXMAP_H
 #define _ASM_FIXMAP_H
 
-#define FIXADDR_START		0xffc00000UL
+#define FIXADDR_START		0xffc80000UL
 #define FIXADDR_END		0xfff00000UL
 #define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 99035b5891ef..bb79e52aeb90 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -67,6 +67,10 @@
  */
 #define XIP_VIRT_ADDR(physaddr)  (MODULES_VADDR + ((physaddr) & 0x000fffff))
 
+#define FDT_FIXED_BASE		UL(0xff800000)
+#define FDT_FIXED_SIZE		(2 * PMD_SIZE)
+#define FDT_VIRT_ADDR(physaddr)	((void *)(FDT_FIXED_BASE | (physaddr) % PMD_SIZE))
+
 #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 /*
  * Allow 16MB-aligned ioremap pages
@@ -107,6 +111,7 @@ extern unsigned long vectors_base;
 #define MODULES_VADDR		PAGE_OFFSET
 
 #define XIP_VIRT_ADDR(physaddr)  (physaddr)
+#define FDT_VIRT_ADDR(physaddr)  ((void *)(physaddr))
 
 #endif /* !CONFIG_MMU */
 
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 98c1e68bdfcb..8cd968199e2c 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -275,9 +275,8 @@ __create_page_tables:
 	 */
 	mov	r0, r2, lsr #SECTION_SHIFT
 	movs	r0, r0, lsl #SECTION_SHIFT
-	subne	r3, r0, r8
-	addne	r3, r3, #PAGE_OFFSET
-	addne	r3, r4, r3, lsr #(SECTION_SHIFT - PMD_ORDER)
+	ldrne	r3, =FDT_FIXED_BASE >> (SECTION_SHIFT - PMD_ORDER)
+	addne	r3, r3, r4
 	orrne	r6, r7, r0
 	strne	r6, [r3], #1 << PMD_ORDER
 	addne	r6, r6, #1 << SECTION_SHIFT
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 306bcd9844be..694aa6b4bd03 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -18,6 +18,7 @@
 #include <linux/of_platform.h>
 #include <linux/init.h>
 #include <linux/kexec.h>
+#include <linux/libfdt.h>
 #include <linux/of_fdt.h>
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
@@ -89,7 +90,6 @@ unsigned int cacheid __read_mostly;
 EXPORT_SYMBOL(cacheid);
 
 unsigned int __atags_pointer __initdata;
-void *atags_vaddr __initdata;
 
 unsigned int system_rev;
 EXPORT_SYMBOL(system_rev);
@@ -1083,13 +1083,18 @@ void __init hyp_mode_check(void)
 void __init setup_arch(char **cmdline_p)
 {
 	const struct machine_desc *mdesc = NULL;
+	void *atags_vaddr = NULL;
 
 	if (__atags_pointer)
-		atags_vaddr = phys_to_virt(__atags_pointer);
+		atags_vaddr = FDT_VIRT_ADDR(__atags_pointer);
 
 	setup_processor();
-	if (atags_vaddr)
+	if (atags_vaddr) {
 		mdesc = setup_machine_fdt(atags_vaddr);
+		if (mdesc)
+			memblock_reserve(__atags_pointer,
+					 fdt_totalsize(atags_vaddr));
+	}
 	if (!mdesc)
 		mdesc = setup_machine_tags(atags_vaddr, __machine_arch_type);
 	if (!mdesc) {
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index c23dbf8bebee..d54d69cf1732 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -223,7 +223,6 @@ void __init arm_memblock_init(const struct machine_desc *mdesc)
 	if (mdesc->reserve)
 		mdesc->reserve();
 
-	early_init_fdt_reserve_self();
 	early_init_fdt_scan_reserved_mem();
 
 	/* reserve memory for DMA contiguous allocations */
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 55991fe60054..fa259825310c 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -39,6 +39,8 @@
 #include "mm.h"
 #include "tcm.h"
 
+extern unsigned long __atags_pointer;
+
 /*
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
@@ -946,7 +948,7 @@ static void __init create_mapping(struct map_desc *md)
 		return;
 	}
 
-	if ((md->type == MT_DEVICE || md->type == MT_ROM) &&
+	if (md->type == MT_DEVICE &&
 	    md->virtual >= PAGE_OFFSET && md->virtual < FIXADDR_START &&
 	    (md->virtual < VMALLOC_START || md->virtual >= VMALLOC_END)) {
 		pr_warn("BUG: mapping for 0x%08llx at 0x%08lx out of vmalloc space\n",
@@ -1333,6 +1335,15 @@ static void __init devicemaps_init(const struct machine_desc *mdesc)
 	for (addr = VMALLOC_START; addr < (FIXADDR_TOP & PMD_MASK); addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 
+	if (__atags_pointer) {
+		/* create a read-only mapping of the device tree */
+		map.pfn = __phys_to_pfn(__atags_pointer & SECTION_MASK);
+		map.virtual = FDT_FIXED_BASE;
+		map.length = FDT_FIXED_SIZE;
+		map.type = MT_ROM;
+		create_mapping(&map);
+	}
+
 	/*
 	 * Map the kernel if it is XIP.
 	 * It is always first in the modulearea.
@@ -1489,8 +1500,7 @@ static void __init map_lowmem(void)
 }
 
 #ifdef CONFIG_ARM_PV_FIXUP
-extern void *atags_vaddr;
-typedef void pgtables_remap(long long offset, unsigned long pgd, void *bdata);
+typedef void pgtables_remap(long long offset, unsigned long pgd);
 pgtables_remap lpae_pgtables_remap_asm;
 
 /*
@@ -1503,7 +1513,6 @@ static void __init early_paging_init(const struct machine_desc *mdesc)
 	unsigned long pa_pgd;
 	unsigned int cr, ttbcr;
 	long long offset;
-	void *boot_data;
 
 	if (!mdesc->pv_fixup)
 		return;
@@ -1520,7 +1529,6 @@ static void __init early_paging_init(const struct machine_desc *mdesc)
 	 */
 	lpae_pgtables_remap = (pgtables_remap *)(unsigned long)__pa(lpae_pgtables_remap_asm);
 	pa_pgd = __pa(swapper_pg_dir);
-	boot_data = atags_vaddr;
 	barrier();
 
 	pr_info("Switching physical address space to 0x%08llx\n",
@@ -1556,7 +1564,7 @@ static void __init early_paging_init(const struct machine_desc *mdesc)
 	 * needs to be assembly.  It's fairly simple, as we're using the
 	 * temporary tables setup by the initial assembly code.
 	 */
-	lpae_pgtables_remap(offset, pa_pgd, boot_data);
+	lpae_pgtables_remap(offset, pa_pgd);
 
 	/* Re-enable the caches and cacheable TLB walks */
 	asm volatile("mcr p15, 0, %0, c2, c0, 2" : : "r" (ttbcr));
diff --git a/arch/arm/mm/pv-fixup-asm.S b/arch/arm/mm/pv-fixup-asm.S
index 8eade0416739..5c5e1952000a 100644
--- a/arch/arm/mm/pv-fixup-asm.S
+++ b/arch/arm/mm/pv-fixup-asm.S
@@ -39,8 +39,8 @@ ENTRY(lpae_pgtables_remap_asm)
 
 	/* Update level 2 entries for the boot data */
 	add	r7, r2, #0x1000
-	add	r7, r7, r3, lsr #SECTION_SHIFT - L2_ORDER
-	bic	r7, r7, #(1 << L2_ORDER) - 1
+	movw	r3, #FDT_FIXED_BASE >> (SECTION_SHIFT - L2_ORDER)
+	add	r7, r7, r3
 	ldrd	r4, r5, [r7]
 	adds	r4, r4, r0
 	adc	r5, r5, r1
-- 
2.25.1

