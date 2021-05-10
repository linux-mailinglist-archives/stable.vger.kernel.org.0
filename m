Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A6F378E81
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242871AbhEJN3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239925AbhEJNWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 09:22:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B008C061760;
        Mon, 10 May 2021 06:21:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id s20so9104646plr.13;
        Mon, 10 May 2021 06:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJde47Wq0rf2XMZB1hY/M/nmKRYQKW0Fzh4LJ2sjgec=;
        b=pFGQQErtCl8iGdQiXOOx2HwnVwfc/4/1HlRdb7rwsibxGP92FFTSFI7zVQlmuNHkXr
         lwXB4CkKD7BAqdiptbu3GwiMj6oXmBUqm8gFGM3tBuKlnUyknvqHKAwrUhWEc81lSf9f
         lK5OVz9QPMTtFXl/8X5PybAfO9+CE7ST2U0Wt60bexacWjWplgNbNjPVct0nfhJZLLuJ
         r/D28h+pzXf0eSHHYGy6x6Rf9y8TpnV6sMD1FXiXzbLsvwiOOjmE8jOLQrEYPoXAOMcs
         VvUnQjJxTv8c6fHWej8nCB5zSxJiCCwKzgPziFEwdMFDUwOmW/XPFpl/Jy7yU5OTLLCE
         eazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJde47Wq0rf2XMZB1hY/M/nmKRYQKW0Fzh4LJ2sjgec=;
        b=AAxvtaSx/QsOIxVMoxwlKgkYBNHDEEvtMxzxkh4XdlARhoBnHAEtLMZePNWvNgx//v
         8JeYvXejlyysaIcmsRfcdCy33Dv2TZaDENRbk8zaK8Sq97/2j3y25wUmE73H4jpCaPAj
         EiM2ZGmjbNLOYUfk261ieQxu44zaReU4kc8UeqJUR17LWh+Fn1iO09f2EgKlLwtAJPI2
         wQTGZmBaFqNmtmpWJ+MiT8vzz2dNCHRgqsb7zq0lkPx7sEasmhT//WXmdczbqDn8h39r
         E8KX4pE4IkUnLrj8diYK4U6VUM5UeuEXlmdyCoXaW4DqOWSCGsUUivYIUaq4SVahxOWT
         1t5A==
X-Gm-Message-State: AOAM532rGl2+hQ2y2XW4rblLnubLEqGcInt8BC9b6k72XuaWvFbG5EH4
        3M9eFkuqJIwKEWyPQvAUr/qOAHAXt/M=
X-Google-Smtp-Source: ABdhPJxYXq6KG8a9iZ6RkY701BZMGR4KW1QkT3YCDx0Q5kZgLsxo9nGaCELn6mDlsjYY2wfXIZ8sQw==
X-Received: by 2002:a17:90b:1050:: with SMTP id gq16mr40960819pjb.227.1620652893652;
        Mon, 10 May 2021 06:21:33 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n8sm11129351pgm.7.2021.05.10.06.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:21:33 -0700 (PDT)
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
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.10 v2 1/4] ARM: 9011/1: centralize phys-to-virt conversion of DT/ATAGS address
Date:   Mon, 10 May 2021 06:21:08 -0700
Message-Id: <20210510132111.1690943-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210510132111.1690943-1-f.fainelli@gmail.com>
References: <20210510132111.1690943-1-f.fainelli@gmail.com>
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

