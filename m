Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946373777CD
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 19:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhEIRbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 13:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhEIRbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 13:31:51 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433F9C061573;
        Sun,  9 May 2021 10:30:48 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s20so7984909plr.13;
        Sun, 09 May 2021 10:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJde47Wq0rf2XMZB1hY/M/nmKRYQKW0Fzh4LJ2sjgec=;
        b=gx3oVHdKR1r/JvschhmPCn/QisOb3aTMBxUOVyhcVCa7mRcRGfVIXL71ivShVa3/fD
         UB72Pt2pQOtUz1dc/89idwL0oI68Z7KLnRNzJl/qc85jolcYQzli041scVogbRLj4KMY
         M0QlOExaifKwIh3n29qgwUs+nGERMvuXdQUhqSNXA7wYrBq68D5WDb22+ctipgXdXNyO
         d6pbUPlyqptq51796ozjbgZuELOaxKFNIrE72lVqr1RoaPpOinQKY+fLtbDPbjPQLD8b
         C6w3gOYxLlDOphfIjGXqmIAX89v6kfFwbThwLHbjztvLaET2I2gw/+ZzG9W52ztcDfdb
         AcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJde47Wq0rf2XMZB1hY/M/nmKRYQKW0Fzh4LJ2sjgec=;
        b=Yskl8BH6ezcl5u2X+3Jt8fH0/CEuckbPeXw3/Rq5SSYAlnL/Yrk6zggz3iuo7NeJ4C
         aMbW8EhgqOCT7X3zhdzVlKZDRvpajcsbekpuIUXbAS+Noupu05JVpN0yUPQX8xz1api7
         oziK8e4+XhtYzOyFLxnGqFpFdtJ98HnhIN6QWBLizW2tb4EHMSXDfl57p51eDKQZc+YM
         wsdjIylZ2tjhyN4J3umHwYvmgbnB6+GFe/Keq+Hy4HN1EWuzkFCIFcBON61WiX+AtBIZ
         DOPHRqe+W3LckzkcB5YGG18zKWHKSf6yDsFU8HoMzEHEjE3ySq8kQnzNYNeOgEmAX4LQ
         lgJA==
X-Gm-Message-State: AOAM533aMH9QzEOgSnUj3zzA9Hkd1CIipP0mokPD6rLnVzd55gugurKM
        0l4QzftEyukVJy3rnlijA0D8dQnKFx4=
X-Google-Smtp-Source: ABdhPJzmwg6fLtbh8uSUdKo2ig2WIvNIQ9tklpvKVvCPM+P0/ZVWPEK+YQohb0B/R4G+VbqtVeQFEA==
X-Received: by 2002:a17:902:59dc:b029:ed:7e32:ff4a with SMTP id d28-20020a17090259dcb02900ed7e32ff4amr20394761plj.50.1620581447060;
        Sun, 09 May 2021 10:30:47 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d129sm2637918pfa.6.2021.05.09.10.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 10:30:46 -0700 (PDT)
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
Subject: [PATCH stable 5.10 1/3] ARM: 9011/1: centralize phys-to-virt conversion of DT/ATAGS address
Date:   Sun,  9 May 2021 10:30:27 -0700
Message-Id: <20210509173029.1653182-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210509173029.1653182-1-f.fainelli@gmail.com>
References: <20210509173029.1653182-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit e9a2f8b599d0bc22a1b13e69527246ac39c697b4 upstream

Before moving the DT mapping out of the linear region, let's prepare
for this change by removing all the phys-to-virt translations of the
__atags_pointer variable, and perform this translation only once at
setup time.

Tested-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/prom.h   |  4 ++--
 arch/arm/kernel/atags.h       |  4 ++--
 arch/arm/kernel/atags_parse.c |  6 +++---
 arch/arm/kernel/devtree.c     |  6 +++---
 arch/arm/kernel/setup.c       | 14 +++++++++-----
 arch/arm/mm/mmu.c             |  4 ++--
 6 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
index 1e36c40533c1..402e3f34c7ed 100644
--- a/arch/arm/include/asm/prom.h
+++ b/arch/arm/include/asm/prom.h
@@ -9,12 +9,12 @@
 
 #ifdef CONFIG_OF
 
-extern const struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
+extern const struct machine_desc *setup_machine_fdt(void *dt_virt);
 extern void __init arm_dt_init_cpu_maps(void);
 
 #else /* CONFIG_OF */
 
-static inline const struct machine_desc *setup_machine_fdt(unsigned int dt_phys)
+static inline const struct machine_desc *setup_machine_fdt(void *dt_virt)
 {
 	return NULL;
 }
diff --git a/arch/arm/kernel/atags.h b/arch/arm/kernel/atags.h
index 067e12edc341..f2819c25b602 100644
--- a/arch/arm/kernel/atags.h
+++ b/arch/arm/kernel/atags.h
@@ -2,11 +2,11 @@
 void convert_to_tag_list(struct tag *tags);
 
 #ifdef CONFIG_ATAGS
-const struct machine_desc *setup_machine_tags(phys_addr_t __atags_pointer,
+const struct machine_desc *setup_machine_tags(void *__atags_vaddr,
 	unsigned int machine_nr);
 #else
 static inline const struct machine_desc * __init __noreturn
-setup_machine_tags(phys_addr_t __atags_pointer, unsigned int machine_nr)
+setup_machine_tags(void *__atags_vaddr, unsigned int machine_nr)
 {
 	early_print("no ATAGS support: can't continue\n");
 	while (true);
diff --git a/arch/arm/kernel/atags_parse.c b/arch/arm/kernel/atags_parse.c
index 6c12d9fe694e..373b61f9a4f0 100644
--- a/arch/arm/kernel/atags_parse.c
+++ b/arch/arm/kernel/atags_parse.c
@@ -174,7 +174,7 @@ static void __init squash_mem_tags(struct tag *tag)
 }
 
 const struct machine_desc * __init
-setup_machine_tags(phys_addr_t __atags_pointer, unsigned int machine_nr)
+setup_machine_tags(void *atags_vaddr, unsigned int machine_nr)
 {
 	struct tag *tags = (struct tag *)&default_tags;
 	const struct machine_desc *mdesc = NULL, *p;
@@ -195,8 +195,8 @@ setup_machine_tags(phys_addr_t __atags_pointer, unsigned int machine_nr)
 	if (!mdesc)
 		return NULL;
 
-	if (__atags_pointer)
-		tags = phys_to_virt(__atags_pointer);
+	if (atags_vaddr)
+		tags = atags_vaddr;
 	else if (mdesc->atag_offset)
 		tags = (void *)(PAGE_OFFSET + mdesc->atag_offset);
 
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 7f0745a97e20..28311dd0fee6 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -203,12 +203,12 @@ static const void * __init arch_get_next_mach(const char *const **match)
 
 /**
  * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
- * @dt_phys: physical address of dt blob
+ * @dt_virt: virtual address of dt blob
  *
  * If a dtb was passed to the kernel in r2, then use it to choose the
  * correct machine_desc and to setup the system.
  */
-const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
+const struct machine_desc * __init setup_machine_fdt(void *dt_virt)
 {
 	const struct machine_desc *mdesc, *mdesc_best = NULL;
 
@@ -221,7 +221,7 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 	mdesc_best = &__mach_desc_GENERIC_DT;
 #endif
 
-	if (!dt_phys || !early_init_dt_verify(phys_to_virt(dt_phys)))
+	if (!dt_virt || !early_init_dt_verify(dt_virt))
 		return NULL;
 
 	mdesc = of_flat_dt_match_machine(mdesc_best, arch_get_next_mach);
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f65d0ac9f63..306bcd9844be 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -89,6 +89,7 @@ unsigned int cacheid __read_mostly;
 EXPORT_SYMBOL(cacheid);
 
 unsigned int __atags_pointer __initdata;
+void *atags_vaddr __initdata;
 
 unsigned int system_rev;
 EXPORT_SYMBOL(system_rev);
@@ -1081,19 +1082,22 @@ void __init hyp_mode_check(void)
 
 void __init setup_arch(char **cmdline_p)
 {
-	const struct machine_desc *mdesc;
+	const struct machine_desc *mdesc = NULL;
+
+	if (__atags_pointer)
+		atags_vaddr = phys_to_virt(__atags_pointer);
 
 	setup_processor();
-	mdesc = setup_machine_fdt(__atags_pointer);
+	if (atags_vaddr)
+		mdesc = setup_machine_fdt(atags_vaddr);
 	if (!mdesc)
-		mdesc = setup_machine_tags(__atags_pointer, __machine_arch_type);
+		mdesc = setup_machine_tags(atags_vaddr, __machine_arch_type);
 	if (!mdesc) {
 		early_print("\nError: invalid dtb and unrecognized/unsupported machine ID\n");
 		early_print("  r1=0x%08x, r2=0x%08x\n", __machine_arch_type,
 			    __atags_pointer);
 		if (__atags_pointer)
-			early_print("  r2[]=%*ph\n", 16,
-				    phys_to_virt(__atags_pointer));
+			early_print("  r2[]=%*ph\n", 16, atags_vaddr);
 		dump_machine_table();
 	}
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index ab69250a86bc..55991fe60054 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1489,7 +1489,7 @@ static void __init map_lowmem(void)
 }
 
 #ifdef CONFIG_ARM_PV_FIXUP
-extern unsigned long __atags_pointer;
+extern void *atags_vaddr;
 typedef void pgtables_remap(long long offset, unsigned long pgd, void *bdata);
 pgtables_remap lpae_pgtables_remap_asm;
 
@@ -1520,7 +1520,7 @@ static void __init early_paging_init(const struct machine_desc *mdesc)
 	 */
 	lpae_pgtables_remap = (pgtables_remap *)(unsigned long)__pa(lpae_pgtables_remap_asm);
 	pa_pgd = __pa(swapper_pg_dir);
-	boot_data = __va(__atags_pointer);
+	boot_data = atags_vaddr;
 	barrier();
 
 	pr_info("Switching physical address space to 0x%08llx\n",
-- 
2.25.1

