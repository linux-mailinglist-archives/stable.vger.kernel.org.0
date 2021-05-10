Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F643378FF7
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 16:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhEJN6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242963AbhEJNxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 09:53:52 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9853DC06137F;
        Mon, 10 May 2021 06:33:28 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so10332317pjv.1;
        Mon, 10 May 2021 06:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e961IvvDlCBFXI/0k42PMsomsMORfO1QUJjExHw3DxE=;
        b=HuqUYh+2ldg9oWj+uawQaI2k/BV92K2Dldh39uWAtLV6I0Gr7po8bjIKH9m7TnscV+
         21PxxxjLC/oHrpGT3Kzu7js1Iq3vvsupTpyv4DLc+XIH1bWtS+mYqyFe8lEZy0/TRk4f
         xInWO8z4pfw5y9YzEozHBg3IkQB0uVeHHVT86asA5dGXlv402EiLeIHdb4xwnjLSRxVQ
         B1xJz6RMY1WpDrJHNcfOc5b4k9+m41W3bAllCBlgWgmMilUxCyXkbsQ596VvsWhtZ665
         OWRnuWbDvazP718qJA3DMRxFj+ixQRYCvsUXeut48DO4BUOS9uqVhQHofjYkHWf/e5p1
         F3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e961IvvDlCBFXI/0k42PMsomsMORfO1QUJjExHw3DxE=;
        b=EREYDi5FoiNQB0FLdRvPXAiklV4gq9RRaGf7Ii3aWt1AptgFxkkBkKL16P/mx0FSE1
         JLKStZungtU1HhQkYzlxdOATjJajbhLIuwh3Twvo9y2xuOVPQTrVz5Fmfiil463s8HAS
         G1gc0GFqHFcsVa87xdCgDTZeGdx914XXFuMTV7usBrCzaM2GMwVakybOeZkYlQA/sbbR
         fVwd9T2+XpQM5RTJnOixbUkHOwOzTyKTm2UdgGKL1zOY+j7yKF4ADNoP8bOBxGqAV8c0
         sMluqDfb8FiaiVL4BiXJvSps3d3zdbBS5W1Ha/+Ygo1vM0Kb1GxKs2Ko8Hpr6wJLzvCT
         Gm7w==
X-Gm-Message-State: AOAM533+0OFmgD1+D4tNbE3Ur6MrFwBq3Cvbig5qdCxfsOBkxr8EltM5
        XJyewKoTd0MYfrMdGN2051/nxtOWWwk=
X-Google-Smtp-Source: ABdhPJwugICuQsrb60cCGL2hx1saXoIVPQ/7hZByhdlIAh/7jVVhSslYzT5be5Ueiuvc6J/jCVMLmA==
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr10736269pja.181.1620653607590;
        Mon, 10 May 2021 06:33:27 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w127sm7906564pfw.4.2021.05.10.06.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:33:27 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH stable 5.4 v2 1/4] ARM: 9011/1: centralize phys-to-virt conversion of DT/ATAGS address
Date:   Mon, 10 May 2021 06:33:18 -0700
Message-Id: <20210510133321.1790243-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210510133321.1790243-1-f.fainelli@gmail.com>
References: <20210510133321.1790243-1-f.fainelli@gmail.com>
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
index ce02f92f4ab2..8288151631fc 100644
--- a/arch/arm/kernel/atags_parse.c
+++ b/arch/arm/kernel/atags_parse.c
@@ -176,7 +176,7 @@ static void __init squash_mem_tags(struct tag *tag)
 }
 
 const struct machine_desc * __init
-setup_machine_tags(phys_addr_t __atags_pointer, unsigned int machine_nr)
+setup_machine_tags(void *atags_vaddr, unsigned int machine_nr)
 {
 	struct tag *tags = (struct tag *)&default_tags;
 	const struct machine_desc *mdesc = NULL, *p;
@@ -197,8 +197,8 @@ setup_machine_tags(phys_addr_t __atags_pointer, unsigned int machine_nr)
 	if (!mdesc)
 		return NULL;
 
-	if (__atags_pointer)
-		tags = phys_to_virt(__atags_pointer);
+	if (atags_vaddr)
+		tags = atags_vaddr;
 	else if (mdesc->atag_offset)
 		tags = (void *)(PAGE_OFFSET + mdesc->atag_offset);
 
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 39c978698406..4e09883c276d 100644
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
index d0a464e317ea..d0cad48ff83b 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -89,6 +89,7 @@ unsigned int cacheid __read_mostly;
 EXPORT_SYMBOL(cacheid);
 
 unsigned int __atags_pointer __initdata;
+void *atags_vaddr __initdata;
 
 unsigned int system_rev;
 EXPORT_SYMBOL(system_rev);
@@ -1075,19 +1076,22 @@ void __init hyp_mode_check(void)
 
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
index 48c2888297dd..e1cd9a05be04 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1512,7 +1512,7 @@ static void __init map_lowmem(void)
 }
 
 #ifdef CONFIG_ARM_PV_FIXUP
-extern unsigned long __atags_pointer;
+extern void *atags_vaddr;
 typedef void pgtables_remap(long long offset, unsigned long pgd, void *bdata);
 pgtables_remap lpae_pgtables_remap_asm;
 
@@ -1543,7 +1543,7 @@ static void __init early_paging_init(const struct machine_desc *mdesc)
 	 */
 	lpae_pgtables_remap = (pgtables_remap *)(unsigned long)__pa(lpae_pgtables_remap_asm);
 	pa_pgd = __pa(swapper_pg_dir);
-	boot_data = __va(__atags_pointer);
+	boot_data = atags_vaddr;
 	barrier();
 
 	pr_info("Switching physical address space to 0x%08llx\n",
-- 
2.25.1

