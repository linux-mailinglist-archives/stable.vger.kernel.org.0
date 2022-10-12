Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFCA5FC28B
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 10:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJLI6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 04:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJLI5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 04:57:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA28B1A223;
        Wed, 12 Oct 2022 01:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 545C7B81929;
        Wed, 12 Oct 2022 08:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5086DC433D6;
        Wed, 12 Oct 2022 08:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665565063;
        bh=vqA4n2PJxadCafZEf2r1MASvaRoDTKGmnKPZzvm8ShI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/xvduEdY+AsV9JSy+6SAfomc3bdWUC7QdbKf0zNcjiZ3JUXlh9LX8dZ+p8Hui1FO
         Neb8l8tVB625YjQR7bsxTODLHZE6nkdPCsyuXcrnrCJxL8PghhJoi+aA+9Oq/pDc8f
         SS08rO0SaS9Dipm7ehGwtR2goN0eQthCtus0t/PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.73
Date:   Wed, 12 Oct 2022 10:58:19 +0200
Message-Id: <1665565098112181@kroah.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <166556509845128@kroah.com>
References: <166556509845128@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
index 8a9f3559335b..7e14e26676ec 100644
--- a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
+++ b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
@@ -34,8 +34,8 @@ Example:
 Use specific request line passing from dma
 For example, MMC request line is 5
 
-	sdhci: sdhci@98e00000 {
-		compatible = "moxa,moxart-sdhci";
+	mmc: mmc@98e00000 {
+		compatible = "moxa,moxart-mmc";
 		reg = <0x98e00000 0x5C>;
 		interrupts = <5 0>;
 		clocks = <&clk_apb>;
diff --git a/Documentation/process/code-of-conduct-interpretation.rst b/Documentation/process/code-of-conduct-interpretation.rst
index e899f14a4ba2..4f8a06b00f60 100644
--- a/Documentation/process/code-of-conduct-interpretation.rst
+++ b/Documentation/process/code-of-conduct-interpretation.rst
@@ -51,7 +51,7 @@ the Technical Advisory Board (TAB) or other maintainers if you're
 uncertain how to handle situations that come up.  It will not be
 considered a violation report unless you want it to be.  If you are
 uncertain about approaching the TAB or any other maintainers, please
-reach out to our conflict mediator, Mishi Choudhary <mishi@linux.com>.
+reach out to our conflict mediator, Joanna Lee <joanna.lee@gesmer.com>.
 
 In the end, "be kind to each other" is really what the end goal is for
 everybody.  We know everyone is human and we all fail at times, but the
diff --git a/Makefile b/Makefile
index 19c18204d165..fc47032dabb8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 72
+SUBLEVEL = 73
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/moxart-uc7112lx.dts b/arch/arm/boot/dts/moxart-uc7112lx.dts
index eb5291b0ee3a..e07b807b4cec 100644
--- a/arch/arm/boot/dts/moxart-uc7112lx.dts
+++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
@@ -79,7 +79,7 @@ &clk_pll {
 	clocks = <&ref12>;
 };
 
-&sdhci {
+&mmc {
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/moxart.dtsi b/arch/arm/boot/dts/moxart.dtsi
index f5f070a87482..764832ddfa78 100644
--- a/arch/arm/boot/dts/moxart.dtsi
+++ b/arch/arm/boot/dts/moxart.dtsi
@@ -93,8 +93,8 @@ watchdog: watchdog@98500000 {
 			clock-names = "PCLK";
 		};
 
-		sdhci: sdhci@98e00000 {
-			compatible = "moxa,moxart-sdhci";
+		mmc: mmc@98e00000 {
+			compatible = "moxa,moxart-mmc";
 			reg = <0x98e00000 0x5C>;
 			interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk_apb>;
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 795d18a84f55..a339cb5de5dd 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -954,15 +954,6 @@ pmd_t radix__pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long addre
 	pmd = *pmdp;
 	pmd_clear(pmdp);
 
-	/*
-	 * pmdp collapse_flush need to ensure that there are no parallel gup
-	 * walk after this call. This is needed so that we can have stable
-	 * page ref count when collapsing a page. We don't allow a collapse page
-	 * if we have gup taken on the page. We can ensure that by sending IPI
-	 * because gup walk happens with IRQ disabled.
-	 */
-	serialize_against_pte_lookup(vma->vm_mm);
-
 	radix__flush_tlb_collapsed_pmd(vma->vm_mm, address);
 
 	return pmd;
diff --git a/arch/um/Makefile b/arch/um/Makefile
index f2fe63bfd819..f1d4d67157be 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -132,10 +132,18 @@ export LDS_ELF_FORMAT := $(ELF_FORMAT)
 # The wrappers will select whether using "malloc" or the kernel allocator.
 LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
 
+# Avoid binutils 2.39+ warnings by marking the stack non-executable and
+# ignorning warnings for the kallsyms sections.
+LDFLAGS_EXECSTACK = -z noexecstack
+ifeq ($(CONFIG_LD_IS_BFD),y)
+LDFLAGS_EXECSTACK += $(call ld-option,--no-warn-rwx-segments)
+endif
+
 LD_FLAGS_CMDLINE = $(foreach opt,$(KBUILD_LDFLAGS),-Wl,$(opt))
 
 # Used by link-vmlinux.sh which has special support for um link
 export CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
+export LDFLAGS_vmlinux := $(LDFLAGS_EXECSTACK)
 
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
diff --git a/arch/x86/um/shared/sysdep/syscalls_32.h b/arch/x86/um/shared/sysdep/syscalls_32.h
index 68fd2cf526fd..f6e9f84397e7 100644
--- a/arch/x86/um/shared/sysdep/syscalls_32.h
+++ b/arch/x86/um/shared/sysdep/syscalls_32.h
@@ -6,10 +6,9 @@
 #include <asm/unistd.h>
 #include <sysdep/ptrace.h>
 
-typedef long syscall_handler_t(struct pt_regs);
+typedef long syscall_handler_t(struct syscall_args);
 
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	((long (*)(struct syscall_args)) \
-	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
+	((*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
diff --git a/arch/x86/um/tls_32.c b/arch/x86/um/tls_32.c
index ac8eee093f9c..66162eafd8e8 100644
--- a/arch/x86/um/tls_32.c
+++ b/arch/x86/um/tls_32.c
@@ -65,9 +65,6 @@ static int get_free_idx(struct task_struct* task)
 	struct thread_struct *t = &task->thread;
 	int idx;
 
-	if (!t->arch.tls_array)
-		return GDT_ENTRY_TLS_MIN;
-
 	for (idx = 0; idx < GDT_ENTRY_TLS_ENTRIES; idx++)
 		if (!t->arch.tls_array[idx].present)
 			return idx + GDT_ENTRY_TLS_MIN;
@@ -240,9 +237,6 @@ static int get_tls_entry(struct task_struct *task, struct user_desc *info,
 {
 	struct thread_struct *t = &task->thread;
 
-	if (!t->arch.tls_array)
-		goto clear;
-
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
diff --git a/arch/x86/um/vdso/Makefile b/arch/x86/um/vdso/Makefile
index 5943387e3f35..5ca366e15c76 100644
--- a/arch/x86/um/vdso/Makefile
+++ b/arch/x86/um/vdso/Makefile
@@ -62,7 +62,7 @@ quiet_cmd_vdso = VDSO    $@
 		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^) && \
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
-VDSO_LDFLAGS = -fPIC -shared -Wl,--hash-style=sysv
+VDSO_LDFLAGS = -fPIC -shared -Wl,--hash-style=sysv -z noexecstack
 GCOV_PROFILE := n
 
 #
diff --git a/drivers/clk/ti/clk-44xx.c b/drivers/clk/ti/clk-44xx.c
index 868bc7af21b0..d078e5d73ed9 100644
--- a/drivers/clk/ti/clk-44xx.c
+++ b/drivers/clk/ti/clk-44xx.c
@@ -56,7 +56,7 @@ static const struct omap_clkctrl_bit_data omap4_aess_bit_data[] __initconst = {
 };
 
 static const char * const omap4_func_dmic_abe_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0018:26",
+	"abe_cm:clk:0018:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -76,7 +76,7 @@ static const struct omap_clkctrl_bit_data omap4_dmic_bit_data[] __initconst = {
 };
 
 static const char * const omap4_func_mcasp_abe_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0020:26",
+	"abe_cm:clk:0020:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -89,7 +89,7 @@ static const struct omap_clkctrl_bit_data omap4_mcasp_bit_data[] __initconst = {
 };
 
 static const char * const omap4_func_mcbsp1_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0028:26",
+	"abe_cm:clk:0028:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -102,7 +102,7 @@ static const struct omap_clkctrl_bit_data omap4_mcbsp1_bit_data[] __initconst =
 };
 
 static const char * const omap4_func_mcbsp2_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0030:26",
+	"abe_cm:clk:0030:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -115,7 +115,7 @@ static const struct omap_clkctrl_bit_data omap4_mcbsp2_bit_data[] __initconst =
 };
 
 static const char * const omap4_func_mcbsp3_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0038:26",
+	"abe_cm:clk:0038:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -183,18 +183,18 @@ static const struct omap_clkctrl_bit_data omap4_timer8_bit_data[] __initconst =
 
 static const struct omap_clkctrl_reg_data omap4_abe_clkctrl_regs[] __initconst = {
 	{ OMAP4_L4_ABE_CLKCTRL, NULL, 0, "ocp_abe_iclk" },
-	{ OMAP4_AESS_CLKCTRL, omap4_aess_bit_data, CLKF_SW_SUP, "abe-clkctrl:0008:24" },
+	{ OMAP4_AESS_CLKCTRL, omap4_aess_bit_data, CLKF_SW_SUP, "abe_cm:clk:0008:24" },
 	{ OMAP4_MCPDM_CLKCTRL, NULL, CLKF_SW_SUP, "pad_clks_ck" },
-	{ OMAP4_DMIC_CLKCTRL, omap4_dmic_bit_data, CLKF_SW_SUP, "abe-clkctrl:0018:24" },
-	{ OMAP4_MCASP_CLKCTRL, omap4_mcasp_bit_data, CLKF_SW_SUP, "abe-clkctrl:0020:24" },
-	{ OMAP4_MCBSP1_CLKCTRL, omap4_mcbsp1_bit_data, CLKF_SW_SUP, "abe-clkctrl:0028:24" },
-	{ OMAP4_MCBSP2_CLKCTRL, omap4_mcbsp2_bit_data, CLKF_SW_SUP, "abe-clkctrl:0030:24" },
-	{ OMAP4_MCBSP3_CLKCTRL, omap4_mcbsp3_bit_data, CLKF_SW_SUP, "abe-clkctrl:0038:24" },
-	{ OMAP4_SLIMBUS1_CLKCTRL, omap4_slimbus1_bit_data, CLKF_SW_SUP, "abe-clkctrl:0040:8" },
-	{ OMAP4_TIMER5_CLKCTRL, omap4_timer5_bit_data, CLKF_SW_SUP, "abe-clkctrl:0048:24" },
-	{ OMAP4_TIMER6_CLKCTRL, omap4_timer6_bit_data, CLKF_SW_SUP, "abe-clkctrl:0050:24" },
-	{ OMAP4_TIMER7_CLKCTRL, omap4_timer7_bit_data, CLKF_SW_SUP, "abe-clkctrl:0058:24" },
-	{ OMAP4_TIMER8_CLKCTRL, omap4_timer8_bit_data, CLKF_SW_SUP, "abe-clkctrl:0060:24" },
+	{ OMAP4_DMIC_CLKCTRL, omap4_dmic_bit_data, CLKF_SW_SUP, "abe_cm:clk:0018:24" },
+	{ OMAP4_MCASP_CLKCTRL, omap4_mcasp_bit_data, CLKF_SW_SUP, "abe_cm:clk:0020:24" },
+	{ OMAP4_MCBSP1_CLKCTRL, omap4_mcbsp1_bit_data, CLKF_SW_SUP, "abe_cm:clk:0028:24" },
+	{ OMAP4_MCBSP2_CLKCTRL, omap4_mcbsp2_bit_data, CLKF_SW_SUP, "abe_cm:clk:0030:24" },
+	{ OMAP4_MCBSP3_CLKCTRL, omap4_mcbsp3_bit_data, CLKF_SW_SUP, "abe_cm:clk:0038:24" },
+	{ OMAP4_SLIMBUS1_CLKCTRL, omap4_slimbus1_bit_data, CLKF_SW_SUP, "abe_cm:clk:0040:8" },
+	{ OMAP4_TIMER5_CLKCTRL, omap4_timer5_bit_data, CLKF_SW_SUP, "abe_cm:clk:0048:24" },
+	{ OMAP4_TIMER6_CLKCTRL, omap4_timer6_bit_data, CLKF_SW_SUP, "abe_cm:clk:0050:24" },
+	{ OMAP4_TIMER7_CLKCTRL, omap4_timer7_bit_data, CLKF_SW_SUP, "abe_cm:clk:0058:24" },
+	{ OMAP4_TIMER8_CLKCTRL, omap4_timer8_bit_data, CLKF_SW_SUP, "abe_cm:clk:0060:24" },
 	{ OMAP4_WD_TIMER3_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ 0 },
 };
@@ -287,7 +287,7 @@ static const struct omap_clkctrl_bit_data omap4_fdif_bit_data[] __initconst = {
 
 static const struct omap_clkctrl_reg_data omap4_iss_clkctrl_regs[] __initconst = {
 	{ OMAP4_ISS_CLKCTRL, omap4_iss_bit_data, CLKF_SW_SUP, "ducati_clk_mux_ck" },
-	{ OMAP4_FDIF_CLKCTRL, omap4_fdif_bit_data, CLKF_SW_SUP, "iss-clkctrl:0008:24" },
+	{ OMAP4_FDIF_CLKCTRL, omap4_fdif_bit_data, CLKF_SW_SUP, "iss_cm:clk:0008:24" },
 	{ 0 },
 };
 
@@ -320,7 +320,7 @@ static const struct omap_clkctrl_bit_data omap4_dss_core_bit_data[] __initconst
 };
 
 static const struct omap_clkctrl_reg_data omap4_l3_dss_clkctrl_regs[] __initconst = {
-	{ OMAP4_DSS_CORE_CLKCTRL, omap4_dss_core_bit_data, CLKF_SW_SUP, "l3-dss-clkctrl:0000:8" },
+	{ OMAP4_DSS_CORE_CLKCTRL, omap4_dss_core_bit_data, CLKF_SW_SUP, "l3_dss_cm:clk:0000:8" },
 	{ 0 },
 };
 
@@ -336,7 +336,7 @@ static const struct omap_clkctrl_bit_data omap4_gpu_bit_data[] __initconst = {
 };
 
 static const struct omap_clkctrl_reg_data omap4_l3_gfx_clkctrl_regs[] __initconst = {
-	{ OMAP4_GPU_CLKCTRL, omap4_gpu_bit_data, CLKF_SW_SUP, "l3-gfx-clkctrl:0000:24" },
+	{ OMAP4_GPU_CLKCTRL, omap4_gpu_bit_data, CLKF_SW_SUP, "l3_gfx_cm:clk:0000:24" },
 	{ 0 },
 };
 
@@ -372,12 +372,12 @@ static const struct omap_clkctrl_bit_data omap4_hsi_bit_data[] __initconst = {
 };
 
 static const char * const omap4_usb_host_hs_utmi_p1_clk_parents[] __initconst = {
-	"l3-init-clkctrl:0038:24",
+	"l3_init_cm:clk:0038:24",
 	NULL,
 };
 
 static const char * const omap4_usb_host_hs_utmi_p2_clk_parents[] __initconst = {
-	"l3-init-clkctrl:0038:25",
+	"l3_init_cm:clk:0038:25",
 	NULL,
 };
 
@@ -418,7 +418,7 @@ static const struct omap_clkctrl_bit_data omap4_usb_host_hs_bit_data[] __initcon
 };
 
 static const char * const omap4_usb_otg_hs_xclk_parents[] __initconst = {
-	"l3-init-clkctrl:0040:24",
+	"l3_init_cm:clk:0040:24",
 	NULL,
 };
 
@@ -452,14 +452,14 @@ static const struct omap_clkctrl_bit_data omap4_ocp2scp_usb_phy_bit_data[] __ini
 };
 
 static const struct omap_clkctrl_reg_data omap4_l3_init_clkctrl_regs[] __initconst = {
-	{ OMAP4_MMC1_CLKCTRL, omap4_mmc1_bit_data, CLKF_SW_SUP, "l3-init-clkctrl:0008:24" },
-	{ OMAP4_MMC2_CLKCTRL, omap4_mmc2_bit_data, CLKF_SW_SUP, "l3-init-clkctrl:0010:24" },
-	{ OMAP4_HSI_CLKCTRL, omap4_hsi_bit_data, CLKF_HW_SUP, "l3-init-clkctrl:0018:24" },
+	{ OMAP4_MMC1_CLKCTRL, omap4_mmc1_bit_data, CLKF_SW_SUP, "l3_init_cm:clk:0008:24" },
+	{ OMAP4_MMC2_CLKCTRL, omap4_mmc2_bit_data, CLKF_SW_SUP, "l3_init_cm:clk:0010:24" },
+	{ OMAP4_HSI_CLKCTRL, omap4_hsi_bit_data, CLKF_HW_SUP, "l3_init_cm:clk:0018:24" },
 	{ OMAP4_USB_HOST_HS_CLKCTRL, omap4_usb_host_hs_bit_data, CLKF_SW_SUP, "init_60m_fclk" },
 	{ OMAP4_USB_OTG_HS_CLKCTRL, omap4_usb_otg_hs_bit_data, CLKF_HW_SUP, "l3_div_ck" },
 	{ OMAP4_USB_TLL_HS_CLKCTRL, omap4_usb_tll_hs_bit_data, CLKF_HW_SUP, "l4_div_ck" },
 	{ OMAP4_USB_HOST_FS_CLKCTRL, NULL, CLKF_SW_SUP, "func_48mc_fclk" },
-	{ OMAP4_OCP2SCP_USB_PHY_CLKCTRL, omap4_ocp2scp_usb_phy_bit_data, CLKF_HW_SUP, "l3-init-clkctrl:00c0:8" },
+	{ OMAP4_OCP2SCP_USB_PHY_CLKCTRL, omap4_ocp2scp_usb_phy_bit_data, CLKF_HW_SUP, "l3_init_cm:clk:00c0:8" },
 	{ 0 },
 };
 
@@ -530,7 +530,7 @@ static const struct omap_clkctrl_bit_data omap4_gpio6_bit_data[] __initconst = {
 };
 
 static const char * const omap4_per_mcbsp4_gfclk_parents[] __initconst = {
-	"l4-per-clkctrl:00c0:26",
+	"l4_per_cm:clk:00c0:26",
 	"pad_clks_ck",
 	NULL,
 };
@@ -570,12 +570,12 @@ static const struct omap_clkctrl_bit_data omap4_slimbus2_bit_data[] __initconst
 };
 
 static const struct omap_clkctrl_reg_data omap4_l4_per_clkctrl_regs[] __initconst = {
-	{ OMAP4_TIMER10_CLKCTRL, omap4_timer10_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0008:24" },
-	{ OMAP4_TIMER11_CLKCTRL, omap4_timer11_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0010:24" },
-	{ OMAP4_TIMER2_CLKCTRL, omap4_timer2_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0018:24" },
-	{ OMAP4_TIMER3_CLKCTRL, omap4_timer3_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0020:24" },
-	{ OMAP4_TIMER4_CLKCTRL, omap4_timer4_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0028:24" },
-	{ OMAP4_TIMER9_CLKCTRL, omap4_timer9_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0030:24" },
+	{ OMAP4_TIMER10_CLKCTRL, omap4_timer10_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0008:24" },
+	{ OMAP4_TIMER11_CLKCTRL, omap4_timer11_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0010:24" },
+	{ OMAP4_TIMER2_CLKCTRL, omap4_timer2_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0018:24" },
+	{ OMAP4_TIMER3_CLKCTRL, omap4_timer3_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0020:24" },
+	{ OMAP4_TIMER4_CLKCTRL, omap4_timer4_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0028:24" },
+	{ OMAP4_TIMER9_CLKCTRL, omap4_timer9_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0030:24" },
 	{ OMAP4_ELM_CLKCTRL, NULL, 0, "l4_div_ck" },
 	{ OMAP4_GPIO2_CLKCTRL, omap4_gpio2_bit_data, CLKF_HW_SUP, "l4_div_ck" },
 	{ OMAP4_GPIO3_CLKCTRL, omap4_gpio3_bit_data, CLKF_HW_SUP, "l4_div_ck" },
@@ -588,14 +588,14 @@ static const struct omap_clkctrl_reg_data omap4_l4_per_clkctrl_regs[] __initcons
 	{ OMAP4_I2C3_CLKCTRL, NULL, CLKF_SW_SUP, "func_96m_fclk" },
 	{ OMAP4_I2C4_CLKCTRL, NULL, CLKF_SW_SUP, "func_96m_fclk" },
 	{ OMAP4_L4_PER_CLKCTRL, NULL, 0, "l4_div_ck" },
-	{ OMAP4_MCBSP4_CLKCTRL, omap4_mcbsp4_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:00c0:24" },
+	{ OMAP4_MCBSP4_CLKCTRL, omap4_mcbsp4_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:00c0:24" },
 	{ OMAP4_MCSPI1_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MCSPI2_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MCSPI3_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MCSPI4_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MMC3_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MMC4_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
-	{ OMAP4_SLIMBUS2_CLKCTRL, omap4_slimbus2_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0118:8" },
+	{ OMAP4_SLIMBUS2_CLKCTRL, omap4_slimbus2_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0118:8" },
 	{ OMAP4_UART1_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_UART2_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_UART3_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
@@ -630,7 +630,7 @@ static const struct omap_clkctrl_reg_data omap4_l4_wkup_clkctrl_regs[] __initcon
 	{ OMAP4_L4_WKUP_CLKCTRL, NULL, 0, "l4_wkup_clk_mux_ck" },
 	{ OMAP4_WD_TIMER2_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ OMAP4_GPIO1_CLKCTRL, omap4_gpio1_bit_data, CLKF_HW_SUP, "l4_wkup_clk_mux_ck" },
-	{ OMAP4_TIMER1_CLKCTRL, omap4_timer1_bit_data, CLKF_SW_SUP, "l4-wkup-clkctrl:0020:24" },
+	{ OMAP4_TIMER1_CLKCTRL, omap4_timer1_bit_data, CLKF_SW_SUP, "l4_wkup_cm:clk:0020:24" },
 	{ OMAP4_COUNTER_32K_CLKCTRL, NULL, 0, "sys_32k_ck" },
 	{ OMAP4_KBD_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ 0 },
@@ -644,7 +644,7 @@ static const char * const omap4_pmd_stm_clock_mux_ck_parents[] __initconst = {
 };
 
 static const char * const omap4_trace_clk_div_div_ck_parents[] __initconst = {
-	"emu-sys-clkctrl:0000:22",
+	"emu_sys_cm:clk:0000:22",
 	NULL,
 };
 
@@ -662,7 +662,7 @@ static const struct omap_clkctrl_div_data omap4_trace_clk_div_div_ck_data __init
 };
 
 static const char * const omap4_stm_clk_div_ck_parents[] __initconst = {
-	"emu-sys-clkctrl:0000:20",
+	"emu_sys_cm:clk:0000:20",
 	NULL,
 };
 
@@ -716,73 +716,73 @@ static struct ti_dt_clk omap44xx_clks[] = {
 	 * hwmod support. Once hwmod is removed, these can be removed
 	 * also.
 	 */
-	DT_CLK(NULL, "aess_fclk", "abe-clkctrl:0008:24"),
-	DT_CLK(NULL, "cm2_dm10_mux", "l4-per-clkctrl:0008:24"),
-	DT_CLK(NULL, "cm2_dm11_mux", "l4-per-clkctrl:0010:24"),
-	DT_CLK(NULL, "cm2_dm2_mux", "l4-per-clkctrl:0018:24"),
-	DT_CLK(NULL, "cm2_dm3_mux", "l4-per-clkctrl:0020:24"),
-	DT_CLK(NULL, "cm2_dm4_mux", "l4-per-clkctrl:0028:24"),
-	DT_CLK(NULL, "cm2_dm9_mux", "l4-per-clkctrl:0030:24"),
-	DT_CLK(NULL, "dmic_sync_mux_ck", "abe-clkctrl:0018:26"),
-	DT_CLK(NULL, "dmt1_clk_mux", "l4-wkup-clkctrl:0020:24"),
-	DT_CLK(NULL, "dss_48mhz_clk", "l3-dss-clkctrl:0000:9"),
-	DT_CLK(NULL, "dss_dss_clk", "l3-dss-clkctrl:0000:8"),
-	DT_CLK(NULL, "dss_sys_clk", "l3-dss-clkctrl:0000:10"),
-	DT_CLK(NULL, "dss_tv_clk", "l3-dss-clkctrl:0000:11"),
-	DT_CLK(NULL, "fdif_fck", "iss-clkctrl:0008:24"),
-	DT_CLK(NULL, "func_dmic_abe_gfclk", "abe-clkctrl:0018:24"),
-	DT_CLK(NULL, "func_mcasp_abe_gfclk", "abe-clkctrl:0020:24"),
-	DT_CLK(NULL, "func_mcbsp1_gfclk", "abe-clkctrl:0028:24"),
-	DT_CLK(NULL, "func_mcbsp2_gfclk", "abe-clkctrl:0030:24"),
-	DT_CLK(NULL, "func_mcbsp3_gfclk", "abe-clkctrl:0038:24"),
-	DT_CLK(NULL, "gpio1_dbclk", "l4-wkup-clkctrl:0018:8"),
-	DT_CLK(NULL, "gpio2_dbclk", "l4-per-clkctrl:0040:8"),
-	DT_CLK(NULL, "gpio3_dbclk", "l4-per-clkctrl:0048:8"),
-	DT_CLK(NULL, "gpio4_dbclk", "l4-per-clkctrl:0050:8"),
-	DT_CLK(NULL, "gpio5_dbclk", "l4-per-clkctrl:0058:8"),
-	DT_CLK(NULL, "gpio6_dbclk", "l4-per-clkctrl:0060:8"),
-	DT_CLK(NULL, "hsi_fck", "l3-init-clkctrl:0018:24"),
-	DT_CLK(NULL, "hsmmc1_fclk", "l3-init-clkctrl:0008:24"),
-	DT_CLK(NULL, "hsmmc2_fclk", "l3-init-clkctrl:0010:24"),
-	DT_CLK(NULL, "iss_ctrlclk", "iss-clkctrl:0000:8"),
-	DT_CLK(NULL, "mcasp_sync_mux_ck", "abe-clkctrl:0020:26"),
-	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe-clkctrl:0028:26"),
-	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe-clkctrl:0030:26"),
-	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe-clkctrl:0038:26"),
-	DT_CLK(NULL, "mcbsp4_sync_mux_ck", "l4-per-clkctrl:00c0:26"),
-	DT_CLK(NULL, "ocp2scp_usb_phy_phy_48m", "l3-init-clkctrl:00c0:8"),
-	DT_CLK(NULL, "otg_60m_gfclk", "l3-init-clkctrl:0040:24"),
-	DT_CLK(NULL, "per_mcbsp4_gfclk", "l4-per-clkctrl:00c0:24"),
-	DT_CLK(NULL, "pmd_stm_clock_mux_ck", "emu-sys-clkctrl:0000:20"),
-	DT_CLK(NULL, "pmd_trace_clk_mux_ck", "emu-sys-clkctrl:0000:22"),
-	DT_CLK(NULL, "sgx_clk_mux", "l3-gfx-clkctrl:0000:24"),
-	DT_CLK(NULL, "slimbus1_fclk_0", "abe-clkctrl:0040:8"),
-	DT_CLK(NULL, "slimbus1_fclk_1", "abe-clkctrl:0040:9"),
-	DT_CLK(NULL, "slimbus1_fclk_2", "abe-clkctrl:0040:10"),
-	DT_CLK(NULL, "slimbus1_slimbus_clk", "abe-clkctrl:0040:11"),
-	DT_CLK(NULL, "slimbus2_fclk_0", "l4-per-clkctrl:0118:8"),
-	DT_CLK(NULL, "slimbus2_fclk_1", "l4-per-clkctrl:0118:9"),
-	DT_CLK(NULL, "slimbus2_slimbus_clk", "l4-per-clkctrl:0118:10"),
-	DT_CLK(NULL, "stm_clk_div_ck", "emu-sys-clkctrl:0000:27"),
-	DT_CLK(NULL, "timer5_sync_mux", "abe-clkctrl:0048:24"),
-	DT_CLK(NULL, "timer6_sync_mux", "abe-clkctrl:0050:24"),
-	DT_CLK(NULL, "timer7_sync_mux", "abe-clkctrl:0058:24"),
-	DT_CLK(NULL, "timer8_sync_mux", "abe-clkctrl:0060:24"),
-	DT_CLK(NULL, "trace_clk_div_div_ck", "emu-sys-clkctrl:0000:24"),
-	DT_CLK(NULL, "usb_host_hs_func48mclk", "l3-init-clkctrl:0038:15"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3-init-clkctrl:0038:13"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3-init-clkctrl:0038:14"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3-init-clkctrl:0038:11"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3-init-clkctrl:0038:12"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3-init-clkctrl:0038:8"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3-init-clkctrl:0038:9"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3_init-clkctrl:0038:10"),
-	DT_CLK(NULL, "usb_otg_hs_xclk", "l3-init-clkctrl:0040:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3-init-clkctrl:0048:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3-init-clkctrl:0048:9"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3-init-clkctrl:0048:10"),
-	DT_CLK(NULL, "utmi_p1_gfclk", "l3-init-clkctrl:0038:24"),
-	DT_CLK(NULL, "utmi_p2_gfclk", "l3-init-clkctrl:0038:25"),
+	DT_CLK(NULL, "aess_fclk", "abe_cm:0008:24"),
+	DT_CLK(NULL, "cm2_dm10_mux", "l4_per_cm:0008:24"),
+	DT_CLK(NULL, "cm2_dm11_mux", "l4_per_cm:0010:24"),
+	DT_CLK(NULL, "cm2_dm2_mux", "l4_per_cm:0018:24"),
+	DT_CLK(NULL, "cm2_dm3_mux", "l4_per_cm:0020:24"),
+	DT_CLK(NULL, "cm2_dm4_mux", "l4_per_cm:0028:24"),
+	DT_CLK(NULL, "cm2_dm9_mux", "l4_per_cm:0030:24"),
+	DT_CLK(NULL, "dmic_sync_mux_ck", "abe_cm:0018:26"),
+	DT_CLK(NULL, "dmt1_clk_mux", "l4_wkup_cm:0020:24"),
+	DT_CLK(NULL, "dss_48mhz_clk", "l3_dss_cm:0000:9"),
+	DT_CLK(NULL, "dss_dss_clk", "l3_dss_cm:0000:8"),
+	DT_CLK(NULL, "dss_sys_clk", "l3_dss_cm:0000:10"),
+	DT_CLK(NULL, "dss_tv_clk", "l3_dss_cm:0000:11"),
+	DT_CLK(NULL, "fdif_fck", "iss_cm:0008:24"),
+	DT_CLK(NULL, "func_dmic_abe_gfclk", "abe_cm:0018:24"),
+	DT_CLK(NULL, "func_mcasp_abe_gfclk", "abe_cm:0020:24"),
+	DT_CLK(NULL, "func_mcbsp1_gfclk", "abe_cm:0028:24"),
+	DT_CLK(NULL, "func_mcbsp2_gfclk", "abe_cm:0030:24"),
+	DT_CLK(NULL, "func_mcbsp3_gfclk", "abe_cm:0038:24"),
+	DT_CLK(NULL, "gpio1_dbclk", "l4_wkup_cm:0018:8"),
+	DT_CLK(NULL, "gpio2_dbclk", "l4_per_cm:0040:8"),
+	DT_CLK(NULL, "gpio3_dbclk", "l4_per_cm:0048:8"),
+	DT_CLK(NULL, "gpio4_dbclk", "l4_per_cm:0050:8"),
+	DT_CLK(NULL, "gpio5_dbclk", "l4_per_cm:0058:8"),
+	DT_CLK(NULL, "gpio6_dbclk", "l4_per_cm:0060:8"),
+	DT_CLK(NULL, "hsi_fck", "l3_init_cm:0018:24"),
+	DT_CLK(NULL, "hsmmc1_fclk", "l3_init_cm:0008:24"),
+	DT_CLK(NULL, "hsmmc2_fclk", "l3_init_cm:0010:24"),
+	DT_CLK(NULL, "iss_ctrlclk", "iss_cm:0000:8"),
+	DT_CLK(NULL, "mcasp_sync_mux_ck", "abe_cm:0020:26"),
+	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe_cm:0028:26"),
+	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe_cm:0030:26"),
+	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe_cm:0038:26"),
+	DT_CLK(NULL, "mcbsp4_sync_mux_ck", "l4_per_cm:00c0:26"),
+	DT_CLK(NULL, "ocp2scp_usb_phy_phy_48m", "l3_init_cm:00c0:8"),
+	DT_CLK(NULL, "otg_60m_gfclk", "l3_init_cm:0040:24"),
+	DT_CLK(NULL, "per_mcbsp4_gfclk", "l4_per_cm:00c0:24"),
+	DT_CLK(NULL, "pmd_stm_clock_mux_ck", "emu_sys_cm:0000:20"),
+	DT_CLK(NULL, "pmd_trace_clk_mux_ck", "emu_sys_cm:0000:22"),
+	DT_CLK(NULL, "sgx_clk_mux", "l3_gfx_cm:0000:24"),
+	DT_CLK(NULL, "slimbus1_fclk_0", "abe_cm:0040:8"),
+	DT_CLK(NULL, "slimbus1_fclk_1", "abe_cm:0040:9"),
+	DT_CLK(NULL, "slimbus1_fclk_2", "abe_cm:0040:10"),
+	DT_CLK(NULL, "slimbus1_slimbus_clk", "abe_cm:0040:11"),
+	DT_CLK(NULL, "slimbus2_fclk_0", "l4_per_cm:0118:8"),
+	DT_CLK(NULL, "slimbus2_fclk_1", "l4_per_cm:0118:9"),
+	DT_CLK(NULL, "slimbus2_slimbus_clk", "l4_per_cm:0118:10"),
+	DT_CLK(NULL, "stm_clk_div_ck", "emu_sys_cm:0000:27"),
+	DT_CLK(NULL, "timer5_sync_mux", "abe_cm:0048:24"),
+	DT_CLK(NULL, "timer6_sync_mux", "abe_cm:0050:24"),
+	DT_CLK(NULL, "timer7_sync_mux", "abe_cm:0058:24"),
+	DT_CLK(NULL, "timer8_sync_mux", "abe_cm:0060:24"),
+	DT_CLK(NULL, "trace_clk_div_div_ck", "emu_sys_cm:0000:24"),
+	DT_CLK(NULL, "usb_host_hs_func48mclk", "l3_init_cm:0038:15"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3_init_cm:0038:13"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3_init_cm:0038:14"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3_init_cm:0038:11"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3_init_cm:0038:12"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3_init_cm:0038:8"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3_init_cm:0038:9"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3_init_cm:0038:10"),
+	DT_CLK(NULL, "usb_otg_hs_xclk", "l3_init_cm:0040:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3_init_cm:0048:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3_init_cm:0048:9"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3_init_cm:0048:10"),
+	DT_CLK(NULL, "utmi_p1_gfclk", "l3_init_cm:0038:24"),
+	DT_CLK(NULL, "utmi_p2_gfclk", "l3_init_cm:0038:25"),
 	{ .node_name = NULL },
 };
 
diff --git a/drivers/clk/ti/clk-54xx.c b/drivers/clk/ti/clk-54xx.c
index b4aff76eb373..90e0a9ea6351 100644
--- a/drivers/clk/ti/clk-54xx.c
+++ b/drivers/clk/ti/clk-54xx.c
@@ -50,7 +50,7 @@ static const struct omap_clkctrl_bit_data omap5_aess_bit_data[] __initconst = {
 };
 
 static const char * const omap5_dmic_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0018:26",
+	"abe_cm:clk:0018:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -70,7 +70,7 @@ static const struct omap_clkctrl_bit_data omap5_dmic_bit_data[] __initconst = {
 };
 
 static const char * const omap5_mcbsp1_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0028:26",
+	"abe_cm:clk:0028:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -83,7 +83,7 @@ static const struct omap_clkctrl_bit_data omap5_mcbsp1_bit_data[] __initconst =
 };
 
 static const char * const omap5_mcbsp2_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0030:26",
+	"abe_cm:clk:0030:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -96,7 +96,7 @@ static const struct omap_clkctrl_bit_data omap5_mcbsp2_bit_data[] __initconst =
 };
 
 static const char * const omap5_mcbsp3_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0038:26",
+	"abe_cm:clk:0038:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -136,16 +136,16 @@ static const struct omap_clkctrl_bit_data omap5_timer8_bit_data[] __initconst =
 
 static const struct omap_clkctrl_reg_data omap5_abe_clkctrl_regs[] __initconst = {
 	{ OMAP5_L4_ABE_CLKCTRL, NULL, 0, "abe_iclk" },
-	{ OMAP5_AESS_CLKCTRL, omap5_aess_bit_data, CLKF_SW_SUP, "abe-clkctrl:0008:24" },
+	{ OMAP5_AESS_CLKCTRL, omap5_aess_bit_data, CLKF_SW_SUP, "abe_cm:clk:0008:24" },
 	{ OMAP5_MCPDM_CLKCTRL, NULL, CLKF_SW_SUP, "pad_clks_ck" },
-	{ OMAP5_DMIC_CLKCTRL, omap5_dmic_bit_data, CLKF_SW_SUP, "abe-clkctrl:0018:24" },
-	{ OMAP5_MCBSP1_CLKCTRL, omap5_mcbsp1_bit_data, CLKF_SW_SUP, "abe-clkctrl:0028:24" },
-	{ OMAP5_MCBSP2_CLKCTRL, omap5_mcbsp2_bit_data, CLKF_SW_SUP, "abe-clkctrl:0030:24" },
-	{ OMAP5_MCBSP3_CLKCTRL, omap5_mcbsp3_bit_data, CLKF_SW_SUP, "abe-clkctrl:0038:24" },
-	{ OMAP5_TIMER5_CLKCTRL, omap5_timer5_bit_data, CLKF_SW_SUP, "abe-clkctrl:0048:24" },
-	{ OMAP5_TIMER6_CLKCTRL, omap5_timer6_bit_data, CLKF_SW_SUP, "abe-clkctrl:0050:24" },
-	{ OMAP5_TIMER7_CLKCTRL, omap5_timer7_bit_data, CLKF_SW_SUP, "abe-clkctrl:0058:24" },
-	{ OMAP5_TIMER8_CLKCTRL, omap5_timer8_bit_data, CLKF_SW_SUP, "abe-clkctrl:0060:24" },
+	{ OMAP5_DMIC_CLKCTRL, omap5_dmic_bit_data, CLKF_SW_SUP, "abe_cm:clk:0018:24" },
+	{ OMAP5_MCBSP1_CLKCTRL, omap5_mcbsp1_bit_data, CLKF_SW_SUP, "abe_cm:clk:0028:24" },
+	{ OMAP5_MCBSP2_CLKCTRL, omap5_mcbsp2_bit_data, CLKF_SW_SUP, "abe_cm:clk:0030:24" },
+	{ OMAP5_MCBSP3_CLKCTRL, omap5_mcbsp3_bit_data, CLKF_SW_SUP, "abe_cm:clk:0038:24" },
+	{ OMAP5_TIMER5_CLKCTRL, omap5_timer5_bit_data, CLKF_SW_SUP, "abe_cm:clk:0048:24" },
+	{ OMAP5_TIMER6_CLKCTRL, omap5_timer6_bit_data, CLKF_SW_SUP, "abe_cm:clk:0050:24" },
+	{ OMAP5_TIMER7_CLKCTRL, omap5_timer7_bit_data, CLKF_SW_SUP, "abe_cm:clk:0058:24" },
+	{ OMAP5_TIMER8_CLKCTRL, omap5_timer8_bit_data, CLKF_SW_SUP, "abe_cm:clk:0060:24" },
 	{ 0 },
 };
 
@@ -268,12 +268,12 @@ static const struct omap_clkctrl_bit_data omap5_gpio8_bit_data[] __initconst = {
 };
 
 static const struct omap_clkctrl_reg_data omap5_l4per_clkctrl_regs[] __initconst = {
-	{ OMAP5_TIMER10_CLKCTRL, omap5_timer10_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0008:24" },
-	{ OMAP5_TIMER11_CLKCTRL, omap5_timer11_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0010:24" },
-	{ OMAP5_TIMER2_CLKCTRL, omap5_timer2_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0018:24" },
-	{ OMAP5_TIMER3_CLKCTRL, omap5_timer3_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0020:24" },
-	{ OMAP5_TIMER4_CLKCTRL, omap5_timer4_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0028:24" },
-	{ OMAP5_TIMER9_CLKCTRL, omap5_timer9_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0030:24" },
+	{ OMAP5_TIMER10_CLKCTRL, omap5_timer10_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0008:24" },
+	{ OMAP5_TIMER11_CLKCTRL, omap5_timer11_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0010:24" },
+	{ OMAP5_TIMER2_CLKCTRL, omap5_timer2_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0018:24" },
+	{ OMAP5_TIMER3_CLKCTRL, omap5_timer3_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0020:24" },
+	{ OMAP5_TIMER4_CLKCTRL, omap5_timer4_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0028:24" },
+	{ OMAP5_TIMER9_CLKCTRL, omap5_timer9_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0030:24" },
 	{ OMAP5_GPIO2_CLKCTRL, omap5_gpio2_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
 	{ OMAP5_GPIO3_CLKCTRL, omap5_gpio3_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
 	{ OMAP5_GPIO4_CLKCTRL, omap5_gpio4_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
@@ -345,7 +345,7 @@ static const struct omap_clkctrl_bit_data omap5_dss_core_bit_data[] __initconst
 };
 
 static const struct omap_clkctrl_reg_data omap5_dss_clkctrl_regs[] __initconst = {
-	{ OMAP5_DSS_CORE_CLKCTRL, omap5_dss_core_bit_data, CLKF_SW_SUP, "dss-clkctrl:0000:8" },
+	{ OMAP5_DSS_CORE_CLKCTRL, omap5_dss_core_bit_data, CLKF_SW_SUP, "dss_cm:clk:0000:8" },
 	{ 0 },
 };
 
@@ -378,7 +378,7 @@ static const struct omap_clkctrl_bit_data omap5_gpu_core_bit_data[] __initconst
 };
 
 static const struct omap_clkctrl_reg_data omap5_gpu_clkctrl_regs[] __initconst = {
-	{ OMAP5_GPU_CLKCTRL, omap5_gpu_core_bit_data, CLKF_SW_SUP, "gpu-clkctrl:0000:24" },
+	{ OMAP5_GPU_CLKCTRL, omap5_gpu_core_bit_data, CLKF_SW_SUP, "gpu_cm:clk:0000:24" },
 	{ 0 },
 };
 
@@ -389,7 +389,7 @@ static const char * const omap5_mmc1_fclk_mux_parents[] __initconst = {
 };
 
 static const char * const omap5_mmc1_fclk_parents[] __initconst = {
-	"l3init-clkctrl:0008:24",
+	"l3init_cm:clk:0008:24",
 	NULL,
 };
 
@@ -405,7 +405,7 @@ static const struct omap_clkctrl_bit_data omap5_mmc1_bit_data[] __initconst = {
 };
 
 static const char * const omap5_mmc2_fclk_parents[] __initconst = {
-	"l3init-clkctrl:0010:24",
+	"l3init_cm:clk:0010:24",
 	NULL,
 };
 
@@ -430,12 +430,12 @@ static const char * const omap5_usb_host_hs_hsic480m_p3_clk_parents[] __initcons
 };
 
 static const char * const omap5_usb_host_hs_utmi_p1_clk_parents[] __initconst = {
-	"l3init-clkctrl:0038:24",
+	"l3init_cm:clk:0038:24",
 	NULL,
 };
 
 static const char * const omap5_usb_host_hs_utmi_p2_clk_parents[] __initconst = {
-	"l3init-clkctrl:0038:25",
+	"l3init_cm:clk:0038:25",
 	NULL,
 };
 
@@ -494,8 +494,8 @@ static const struct omap_clkctrl_bit_data omap5_usb_otg_ss_bit_data[] __initcons
 };
 
 static const struct omap_clkctrl_reg_data omap5_l3init_clkctrl_regs[] __initconst = {
-	{ OMAP5_MMC1_CLKCTRL, omap5_mmc1_bit_data, CLKF_SW_SUP, "l3init-clkctrl:0008:25" },
-	{ OMAP5_MMC2_CLKCTRL, omap5_mmc2_bit_data, CLKF_SW_SUP, "l3init-clkctrl:0010:25" },
+	{ OMAP5_MMC1_CLKCTRL, omap5_mmc1_bit_data, CLKF_SW_SUP, "l3init_cm:clk:0008:25" },
+	{ OMAP5_MMC2_CLKCTRL, omap5_mmc2_bit_data, CLKF_SW_SUP, "l3init_cm:clk:0010:25" },
 	{ OMAP5_USB_HOST_HS_CLKCTRL, omap5_usb_host_hs_bit_data, CLKF_SW_SUP, "l3init_60m_fclk" },
 	{ OMAP5_USB_TLL_HS_CLKCTRL, omap5_usb_tll_hs_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
 	{ OMAP5_SATA_CLKCTRL, omap5_sata_bit_data, CLKF_SW_SUP, "func_48m_fclk" },
@@ -519,7 +519,7 @@ static const struct omap_clkctrl_reg_data omap5_wkupaon_clkctrl_regs[] __initcon
 	{ OMAP5_L4_WKUP_CLKCTRL, NULL, 0, "wkupaon_iclk_mux" },
 	{ OMAP5_WD_TIMER2_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ OMAP5_GPIO1_CLKCTRL, omap5_gpio1_bit_data, CLKF_HW_SUP, "wkupaon_iclk_mux" },
-	{ OMAP5_TIMER1_CLKCTRL, omap5_timer1_bit_data, CLKF_SW_SUP, "wkupaon-clkctrl:0020:24" },
+	{ OMAP5_TIMER1_CLKCTRL, omap5_timer1_bit_data, CLKF_SW_SUP, "wkupaon_cm:clk:0020:24" },
 	{ OMAP5_COUNTER_32K_CLKCTRL, NULL, 0, "wkupaon_iclk_mux" },
 	{ OMAP5_KBD_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ 0 },
@@ -549,58 +549,58 @@ const struct omap_clkctrl_data omap5_clkctrl_data[] __initconst = {
 static struct ti_dt_clk omap54xx_clks[] = {
 	DT_CLK(NULL, "timer_32k_ck", "sys_32k_ck"),
 	DT_CLK(NULL, "sys_clkin_ck", "sys_clkin"),
-	DT_CLK(NULL, "dmic_gfclk", "abe-clkctrl:0018:24"),
-	DT_CLK(NULL, "dmic_sync_mux_ck", "abe-clkctrl:0018:26"),
-	DT_CLK(NULL, "dss_32khz_clk", "dss-clkctrl:0000:11"),
-	DT_CLK(NULL, "dss_48mhz_clk", "dss-clkctrl:0000:9"),
-	DT_CLK(NULL, "dss_dss_clk", "dss-clkctrl:0000:8"),
-	DT_CLK(NULL, "dss_sys_clk", "dss-clkctrl:0000:10"),
-	DT_CLK(NULL, "gpio1_dbclk", "wkupaon-clkctrl:0018:8"),
-	DT_CLK(NULL, "gpio2_dbclk", "l4per-clkctrl:0040:8"),
-	DT_CLK(NULL, "gpio3_dbclk", "l4per-clkctrl:0048:8"),
-	DT_CLK(NULL, "gpio4_dbclk", "l4per-clkctrl:0050:8"),
-	DT_CLK(NULL, "gpio5_dbclk", "l4per-clkctrl:0058:8"),
-	DT_CLK(NULL, "gpio6_dbclk", "l4per-clkctrl:0060:8"),
-	DT_CLK(NULL, "gpio7_dbclk", "l4per-clkctrl:00f0:8"),
-	DT_CLK(NULL, "gpio8_dbclk", "l4per-clkctrl:00f8:8"),
-	DT_CLK(NULL, "mcbsp1_gfclk", "abe-clkctrl:0028:24"),
-	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe-clkctrl:0028:26"),
-	DT_CLK(NULL, "mcbsp2_gfclk", "abe-clkctrl:0030:24"),
-	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe-clkctrl:0030:26"),
-	DT_CLK(NULL, "mcbsp3_gfclk", "abe-clkctrl:0038:24"),
-	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe-clkctrl:0038:26"),
-	DT_CLK(NULL, "mmc1_32khz_clk", "l3init-clkctrl:0008:8"),
-	DT_CLK(NULL, "mmc1_fclk", "l3init-clkctrl:0008:25"),
-	DT_CLK(NULL, "mmc1_fclk_mux", "l3init-clkctrl:0008:24"),
-	DT_CLK(NULL, "mmc2_fclk", "l3init-clkctrl:0010:25"),
-	DT_CLK(NULL, "mmc2_fclk_mux", "l3init-clkctrl:0010:24"),
-	DT_CLK(NULL, "sata_ref_clk", "l3init-clkctrl:0068:8"),
-	DT_CLK(NULL, "timer10_gfclk_mux", "l4per-clkctrl:0008:24"),
-	DT_CLK(NULL, "timer11_gfclk_mux", "l4per-clkctrl:0010:24"),
-	DT_CLK(NULL, "timer1_gfclk_mux", "wkupaon-clkctrl:0020:24"),
-	DT_CLK(NULL, "timer2_gfclk_mux", "l4per-clkctrl:0018:24"),
-	DT_CLK(NULL, "timer3_gfclk_mux", "l4per-clkctrl:0020:24"),
-	DT_CLK(NULL, "timer4_gfclk_mux", "l4per-clkctrl:0028:24"),
-	DT_CLK(NULL, "timer5_gfclk_mux", "abe-clkctrl:0048:24"),
-	DT_CLK(NULL, "timer6_gfclk_mux", "abe-clkctrl:0050:24"),
-	DT_CLK(NULL, "timer7_gfclk_mux", "abe-clkctrl:0058:24"),
-	DT_CLK(NULL, "timer8_gfclk_mux", "abe-clkctrl:0060:24"),
-	DT_CLK(NULL, "timer9_gfclk_mux", "l4per-clkctrl:0030:24"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3init-clkctrl:0038:13"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3init-clkctrl:0038:14"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p3_clk", "l3init-clkctrl:0038:7"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3init-clkctrl:0038:11"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3init-clkctrl:0038:12"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p3_clk", "l3init-clkctrl:0038:6"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3init-clkctrl:0038:8"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3init-clkctrl:0038:9"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3init-clkctrl:0038:10"),
-	DT_CLK(NULL, "usb_otg_ss_refclk960m", "l3init-clkctrl:00d0:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3init-clkctrl:0048:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3init-clkctrl:0048:9"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3init-clkctrl:0048:10"),
-	DT_CLK(NULL, "utmi_p1_gfclk", "l3init-clkctrl:0038:24"),
-	DT_CLK(NULL, "utmi_p2_gfclk", "l3init-clkctrl:0038:25"),
+	DT_CLK(NULL, "dmic_gfclk", "abe_cm:0018:24"),
+	DT_CLK(NULL, "dmic_sync_mux_ck", "abe_cm:0018:26"),
+	DT_CLK(NULL, "dss_32khz_clk", "dss_cm:0000:11"),
+	DT_CLK(NULL, "dss_48mhz_clk", "dss_cm:0000:9"),
+	DT_CLK(NULL, "dss_dss_clk", "dss_cm:0000:8"),
+	DT_CLK(NULL, "dss_sys_clk", "dss_cm:0000:10"),
+	DT_CLK(NULL, "gpio1_dbclk", "wkupaon_cm:0018:8"),
+	DT_CLK(NULL, "gpio2_dbclk", "l4per_cm:0040:8"),
+	DT_CLK(NULL, "gpio3_dbclk", "l4per_cm:0048:8"),
+	DT_CLK(NULL, "gpio4_dbclk", "l4per_cm:0050:8"),
+	DT_CLK(NULL, "gpio5_dbclk", "l4per_cm:0058:8"),
+	DT_CLK(NULL, "gpio6_dbclk", "l4per_cm:0060:8"),
+	DT_CLK(NULL, "gpio7_dbclk", "l4per_cm:00f0:8"),
+	DT_CLK(NULL, "gpio8_dbclk", "l4per_cm:00f8:8"),
+	DT_CLK(NULL, "mcbsp1_gfclk", "abe_cm:0028:24"),
+	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe_cm:0028:26"),
+	DT_CLK(NULL, "mcbsp2_gfclk", "abe_cm:0030:24"),
+	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe_cm:0030:26"),
+	DT_CLK(NULL, "mcbsp3_gfclk", "abe_cm:0038:24"),
+	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe_cm:0038:26"),
+	DT_CLK(NULL, "mmc1_32khz_clk", "l3init_cm:0008:8"),
+	DT_CLK(NULL, "mmc1_fclk", "l3init_cm:0008:25"),
+	DT_CLK(NULL, "mmc1_fclk_mux", "l3init_cm:0008:24"),
+	DT_CLK(NULL, "mmc2_fclk", "l3init_cm:0010:25"),
+	DT_CLK(NULL, "mmc2_fclk_mux", "l3init_cm:0010:24"),
+	DT_CLK(NULL, "sata_ref_clk", "l3init_cm:0068:8"),
+	DT_CLK(NULL, "timer10_gfclk_mux", "l4per_cm:0008:24"),
+	DT_CLK(NULL, "timer11_gfclk_mux", "l4per_cm:0010:24"),
+	DT_CLK(NULL, "timer1_gfclk_mux", "wkupaon_cm:0020:24"),
+	DT_CLK(NULL, "timer2_gfclk_mux", "l4per_cm:0018:24"),
+	DT_CLK(NULL, "timer3_gfclk_mux", "l4per_cm:0020:24"),
+	DT_CLK(NULL, "timer4_gfclk_mux", "l4per_cm:0028:24"),
+	DT_CLK(NULL, "timer5_gfclk_mux", "abe_cm:0048:24"),
+	DT_CLK(NULL, "timer6_gfclk_mux", "abe_cm:0050:24"),
+	DT_CLK(NULL, "timer7_gfclk_mux", "abe_cm:0058:24"),
+	DT_CLK(NULL, "timer8_gfclk_mux", "abe_cm:0060:24"),
+	DT_CLK(NULL, "timer9_gfclk_mux", "l4per_cm:0030:24"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3init_cm:0038:13"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3init_cm:0038:14"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p3_clk", "l3init_cm:0038:7"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3init_cm:0038:11"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3init_cm:0038:12"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p3_clk", "l3init_cm:0038:6"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3init_cm:0038:8"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3init_cm:0038:9"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3init_cm:0038:10"),
+	DT_CLK(NULL, "usb_otg_ss_refclk960m", "l3init_cm:00d0:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3init_cm:0048:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3init_cm:0048:9"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3init_cm:0048:10"),
+	DT_CLK(NULL, "utmi_p1_gfclk", "l3init_cm:0038:24"),
+	DT_CLK(NULL, "utmi_p2_gfclk", "l3init_cm:0038:25"),
 	{ .node_name = NULL },
 };
 
diff --git a/drivers/clk/ti/clkctrl.c b/drivers/clk/ti/clkctrl.c
index 08a85c559f79..864c484bde1b 100644
--- a/drivers/clk/ti/clkctrl.c
+++ b/drivers/clk/ti/clkctrl.c
@@ -511,6 +511,10 @@ static void __init _ti_omap4_clkctrl_setup(struct device_node *node)
 	char *c;
 	u16 soc_mask = 0;
 
+	if (!(ti_clk_get_features()->flags & TI_CLK_CLKCTRL_COMPAT) &&
+	    of_node_name_eq(node, "clk"))
+		ti_clk_features.flags |= TI_CLK_CLKCTRL_COMPAT;
+
 	addrp = of_get_address(node, 0, NULL, NULL);
 	addr = (u32)of_translate_address(node, addrp);
 
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index a4450bc95466..4273150b68dc 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3037,9 +3037,10 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
 	/* Request and map I/O memory */
 	xdev->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(xdev->regs))
-		return PTR_ERR(xdev->regs);
-
+	if (IS_ERR(xdev->regs)) {
+		err = PTR_ERR(xdev->regs);
+		goto disable_clks;
+	}
 	/* Retrieve the DMA engine properties from the device tree */
 	xdev->max_buffer_len = GENMASK(XILINX_DMA_MAX_TRANS_LEN_MAX - 1, 0);
 	xdev->s2mm_chan_id = xdev->dma_config->max_channels / 2;
@@ -3067,7 +3068,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		if (err < 0) {
 			dev_err(xdev->dev,
 				"missing xlnx,num-fstores property\n");
-			return err;
+			goto disable_clks;
 		}
 
 		err = of_property_read_u32(node, "xlnx,flush-fsync",
@@ -3087,7 +3088,11 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		xdev->ext_addr = false;
 
 	/* Set the dma mask bits */
-	dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
+	err = dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
+	if (err < 0) {
+		dev_err(xdev->dev, "DMA mask error %d\n", err);
+		goto disable_clks;
+	}
 
 	/* Initialize the DMA engine */
 	xdev->common.dev = &pdev->dev;
@@ -3134,7 +3139,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	for_each_child_of_node(node, child) {
 		err = xilinx_dma_child_probe(xdev, child);
 		if (err < 0)
-			goto disable_clks;
+			goto error;
 	}
 
 	if (xdev->dma_config->dmatype == XDMA_TYPE_VDMA) {
@@ -3169,12 +3174,12 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
 	return 0;
 
-disable_clks:
-	xdma_disable_allclks(xdev);
 error:
 	for (i = 0; i < xdev->dma_config->max_channels; i++)
 		if (xdev->chan[i])
 			xilinx_dma_chan_remove(xdev->chan[i]);
+disable_clks:
+	xdma_disable_allclks(xdev);
 
 	return err;
 }
diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index 492f3a9197ec..e76194a60edf 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -315,9 +315,13 @@ static int scmi_clock_count_get(const struct scmi_protocol_handle *ph)
 static const struct scmi_clock_info *
 scmi_clock_info_get(const struct scmi_protocol_handle *ph, u32 clk_id)
 {
+	struct scmi_clock_info *clk;
 	struct clock_info *ci = ph->get_priv(ph);
-	struct scmi_clock_info *clk = ci->clk + clk_id;
 
+	if (clk_id >= ci->num_clocks)
+		return NULL;
+
+	clk = ci->clk + clk_id;
 	if (!clk->name[0])
 		return NULL;
 
diff --git a/drivers/firmware/arm_scmi/scmi_pm_domain.c b/drivers/firmware/arm_scmi/scmi_pm_domain.c
index d5dee625de78..0e05a79de82d 100644
--- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
+++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
@@ -112,9 +112,28 @@ static int scmi_pm_domain_probe(struct scmi_device *sdev)
 	scmi_pd_data->domains = domains;
 	scmi_pd_data->num_domains = num_domains;
 
+	dev_set_drvdata(dev, scmi_pd_data);
+
 	return of_genpd_add_provider_onecell(np, scmi_pd_data);
 }
 
+static void scmi_pm_domain_remove(struct scmi_device *sdev)
+{
+	int i;
+	struct genpd_onecell_data *scmi_pd_data;
+	struct device *dev = &sdev->dev;
+	struct device_node *np = dev->of_node;
+
+	of_genpd_del_provider(np);
+
+	scmi_pd_data = dev_get_drvdata(dev);
+	for (i = 0; i < scmi_pd_data->num_domains; i++) {
+		if (!scmi_pd_data->domains[i])
+			continue;
+		pm_genpd_remove(scmi_pd_data->domains[i]);
+	}
+}
+
 static const struct scmi_device_id scmi_id_table[] = {
 	{ SCMI_PROTOCOL_POWER, "genpd" },
 	{ },
@@ -124,6 +143,7 @@ MODULE_DEVICE_TABLE(scmi, scmi_id_table);
 static struct scmi_driver scmi_power_domain_driver = {
 	.name = "scmi-power-domain",
 	.probe = scmi_pm_domain_probe,
+	.remove = scmi_pm_domain_remove,
 	.id_table = scmi_id_table,
 };
 module_scmi_driver(scmi_power_domain_driver);
diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index cdbb287bd8bc..1ed66d13c06c 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -631,6 +631,10 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 {
 	int ret;
 	struct scmi_xfer *t;
+	struct sensors_info *si = ph->get_priv(ph);
+
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
 
 	ret = ph->xops->xfer_get_init(ph, SENSOR_CONFIG_GET,
 				      sizeof(__le32), sizeof(__le32), &t);
@@ -640,7 +644,6 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 	put_unaligned_le32(sensor_id, t->tx.buf);
 	ret = ph->xops->do_xfer(ph, t);
 	if (!ret) {
-		struct sensors_info *si = ph->get_priv(ph);
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
 		*sensor_config = get_unaligned_le64(t->rx.buf);
@@ -657,6 +660,10 @@ static int scmi_sensor_config_set(const struct scmi_protocol_handle *ph,
 	int ret;
 	struct scmi_xfer *t;
 	struct scmi_msg_sensor_config_set *msg;
+	struct sensors_info *si = ph->get_priv(ph);
+
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
 
 	ret = ph->xops->xfer_get_init(ph, SENSOR_CONFIG_SET,
 				      sizeof(*msg), 0, &t);
@@ -669,7 +676,6 @@ static int scmi_sensor_config_set(const struct scmi_protocol_handle *ph,
 
 	ret = ph->xops->do_xfer(ph, t);
 	if (!ret) {
-		struct sensors_info *si = ph->get_priv(ph);
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
 		s->sensor_config = sensor_config;
@@ -700,8 +706,11 @@ static int scmi_sensor_reading_get(const struct scmi_protocol_handle *ph,
 	int ret;
 	struct scmi_xfer *t;
 	struct scmi_msg_sensor_reading_get *sensor;
+	struct scmi_sensor_info *s;
 	struct sensors_info *si = ph->get_priv(ph);
-	struct scmi_sensor_info *s = si->sensors + sensor_id;
+
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
 
 	ret = ph->xops->xfer_get_init(ph, SENSOR_READING_GET,
 				      sizeof(*sensor), 0, &t);
@@ -710,6 +719,7 @@ static int scmi_sensor_reading_get(const struct scmi_protocol_handle *ph,
 
 	sensor = t->tx.buf;
 	sensor->id = cpu_to_le32(sensor_id);
+	s = si->sensors + sensor_id;
 	if (s->async) {
 		sensor->flags = cpu_to_le32(SENSOR_READ_ASYNC);
 		ret = ph->xops->do_xfer_with_response(ph, t);
@@ -764,9 +774,13 @@ scmi_sensor_reading_get_timestamped(const struct scmi_protocol_handle *ph,
 	int ret;
 	struct scmi_xfer *t;
 	struct scmi_msg_sensor_reading_get *sensor;
+	struct scmi_sensor_info *s;
 	struct sensors_info *si = ph->get_priv(ph);
-	struct scmi_sensor_info *s = si->sensors + sensor_id;
 
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
+
+	s = si->sensors + sensor_id;
 	if (!count || !readings ||
 	    (!s->num_axis && count > 1) || (s->num_axis && count > s->num_axis))
 		return -EINVAL;
@@ -817,6 +831,9 @@ scmi_sensor_info_get(const struct scmi_protocol_handle *ph, u32 sensor_id)
 {
 	struct sensors_info *si = ph->get_priv(ph);
 
+	if (sensor_id >= si->num_sensors)
+		return NULL;
+
 	return si->sensors + sensor_id;
 }
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e3dfea3d44a4..c826fc493e0f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5442,7 +5442,7 @@ fill_dc_plane_info_and_addr(struct amdgpu_device *adev,
 	plane_info->visible = true;
 	plane_info->stereo_format = PLANE_STEREO_FORMAT_NONE;
 
-	plane_info->layer_index = 0;
+	plane_info->layer_index = plane_state->normalized_zpos;
 
 	ret = fill_plane_color_attributes(plane_state, plane_info->format,
 					  &plane_info->color_space);
@@ -5509,7 +5509,7 @@ static int fill_dc_plane_attributes(struct amdgpu_device *adev,
 	dc_plane_state->global_alpha = plane_info.global_alpha;
 	dc_plane_state->global_alpha_value = plane_info.global_alpha_value;
 	dc_plane_state->dcc = plane_info.dcc;
-	dc_plane_state->layer_index = plane_info.layer_index; // Always returns 0
+	dc_plane_state->layer_index = plane_info.layer_index;
 	dc_plane_state->flip_int_enabled = true;
 
 	/*
@@ -10828,6 +10828,14 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		}
 	}
 
+	/*
+	 * DC consults the zpos (layer_index in DC terminology) to determine the
+	 * hw plane on which to enable the hw cursor (see
+	 * `dcn10_can_pipe_disable_cursor`). By now, all modified planes are in
+	 * atomic state, so call drm helper to normalize zpos.
+	 */
+	drm_atomic_normalize_zpos(dev, state);
+
 	/* Remove exiting planes if they are modified */
 	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
 		ret = dm_update_plane_state(dc, state, plane,
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 6d5dc5ab3d8c..a6ff1b17fd22 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3703,6 +3703,14 @@ bool dp_retrieve_lttpr_cap(struct dc_link *link)
 				lttpr_dpcd_data[DP_PHY_REPEATER_EXTENDED_WAIT_TIMEOUT -
 								DP_LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV];
 
+		/* If this chip cap is set, at least one retimer must exist in the chain
+		 * Override count to 1 if we receive a known bad count (0 or an invalid value) */
+		if (link->chip_caps & EXT_DISPLAY_PATH_CAPS__DP_FIXED_VS_EN &&
+				(dp_convert_to_count(link->dpcd_caps.lttpr_caps.phy_repeater_cnt) == 0)) {
+			ASSERT(0);
+			link->dpcd_caps.lttpr_caps.phy_repeater_cnt = 0x80;
+		}
+
 		/* Attempt to train in LTTPR transparent mode if repeater count exceeds 8. */
 		is_lttpr_present = (dp_convert_to_count(link->dpcd_caps.lttpr_caps.phy_repeater_cnt) != 0 &&
 				link->dpcd_caps.lttpr_caps.max_lane_count > 0 &&
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 62d595ded866..46d7e75e4553 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -2108,7 +2108,8 @@ static void dce110_setup_audio_dto(
 			continue;
 		if (pipe_ctx->stream->signal != SIGNAL_TYPE_HDMI_TYPE_A)
 			continue;
-		if (pipe_ctx->stream_res.audio != NULL) {
+		if (pipe_ctx->stream_res.audio != NULL &&
+			pipe_ctx->stream_res.audio->enabled == false) {
 			struct audio_output audio_output;
 
 			build_audio_output(context, pipe_ctx, &audio_output);
@@ -2156,7 +2157,8 @@ static void dce110_setup_audio_dto(
 			if (!dc_is_dp_signal(pipe_ctx->stream->signal))
 				continue;
 
-			if (pipe_ctx->stream_res.audio != NULL) {
+			if (pipe_ctx->stream_res.audio != NULL &&
+				pipe_ctx->stream_res.audio->enabled == false) {
 				struct audio_output audio_output;
 
 				build_audio_output(context, pipe_ctx, &audio_output);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 9f8d7f92300b..0de1bbbabf9a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1513,6 +1513,7 @@ static void dcn20_update_dchubp_dpp(
 	/* Any updates are handled in dc interface, just need
 	 * to apply existing for plane enable / opp change */
 	if (pipe_ctx->update_flags.bits.enable || pipe_ctx->update_flags.bits.opp_changed
+			|| pipe_ctx->update_flags.bits.plane_changed
 			|| pipe_ctx->stream->update_flags.bits.gamut_remap
 			|| pipe_ctx->stream->update_flags.bits.out_csc) {
 		/* dpp/cm gamut remap*/
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 7e8d4abed602..86a8a1f56583 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -863,7 +863,8 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 	 * the CCS bit is set as well. We deliberately deviate from the spec in
 	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr && (*rocr & 0x01000000)) {
+	if (!mmc_host_is_spi(host) && (ocr & SD_OCR_S18R) &&
+	    rocr && (*rocr & SD_ROCR_S18A)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index e22935ce9573..f069312463fb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -89,11 +89,8 @@ static int aq_ndev_close(struct net_device *ndev)
 	int err = 0;
 
 	err = aq_nic_stop(aq_nic);
-	if (err < 0)
-		goto err_exit;
 	aq_nic_deinit(aq_nic, true);
 
-err_exit:
 	return err;
 }
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index a250d394da38..a8d7b889ebee 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -815,6 +815,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xCC1E) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 0fbb239559f3..5f8b7f3735b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -691,30 +691,32 @@ static void mlx5_ldev_add_netdev(struct mlx5_lag *ldev,
 				 struct net_device *netdev)
 {
 	unsigned int fn = PCI_FUNC(dev->pdev->devfn);
+	unsigned long flags;
 
 	if (fn >= MLX5_MAX_PORTS)
 		return;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev->pf[fn].netdev = netdev;
 	ldev->tracker.netdev_state[fn].link_up = 0;
 	ldev->tracker.netdev_state[fn].tx_enabled = 0;
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 }
 
 static void mlx5_ldev_remove_netdev(struct mlx5_lag *ldev,
 				    struct net_device *netdev)
 {
+	unsigned long flags;
 	int i;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	for (i = 0; i < MLX5_MAX_PORTS; i++) {
 		if (ldev->pf[i].netdev == netdev) {
 			ldev->pf[i].netdev = NULL;
 			break;
 		}
 	}
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 }
 
 static void mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
@@ -855,12 +857,13 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_roce(ldev);
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -869,12 +872,13 @@ EXPORT_SYMBOL(mlx5_lag_is_roce);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_active(ldev);
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -883,13 +887,14 @@ EXPORT_SYMBOL(mlx5_lag_is_active);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res = ldev && __mlx5_lag_is_active(ldev) &&
 		dev == ldev->pf[MLX5_LAG_P1].dev;
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -898,12 +903,13 @@ EXPORT_SYMBOL(mlx5_lag_is_master);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_sriov(ldev);
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -912,12 +918,13 @@ EXPORT_SYMBOL(mlx5_lag_is_sriov);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res = ldev && __mlx5_lag_is_sriov(ldev) && ldev->shared_fdb;
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -965,8 +972,9 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 {
 	struct net_device *ndev = NULL;
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 
 	if (!(ldev && __mlx5_lag_is_roce(ldev)))
@@ -983,7 +991,7 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 		dev_hold(ndev);
 
 unlock:
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return ndev;
 }
@@ -993,9 +1001,10 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 			   struct net_device *slave)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	u8 port = 0;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	if (!(ldev && __mlx5_lag_is_roce(ldev)))
 		goto unlock;
@@ -1008,7 +1017,7 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 	port = ldev->v2p_map[port];
 
 unlock:
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 	return port;
 }
 EXPORT_SYMBOL(mlx5_lag_get_slave_port);
@@ -1017,8 +1026,9 @@ struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_dev *peer_dev = NULL;
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	if (!ldev)
 		goto unlock;
@@ -1028,7 +1038,7 @@ struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev)
 			   ldev->pf[MLX5_LAG_P1].dev;
 
 unlock:
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 	return peer_dev;
 }
 EXPORT_SYMBOL(mlx5_lag_get_peer_mdev);
@@ -1041,6 +1051,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	int outlen = MLX5_ST_SZ_BYTES(query_cong_statistics_out);
 	struct mlx5_core_dev *mdev[MLX5_MAX_PORTS];
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	int num_ports;
 	int ret, i, j;
 	void *out;
@@ -1051,7 +1062,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 
 	memset(values, 0, sizeof(*values) * num_counters);
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	if (ldev && __mlx5_lag_is_active(ldev)) {
 		num_ports = MLX5_MAX_PORTS;
@@ -1061,7 +1072,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 		num_ports = 1;
 		mdev[MLX5_LAG_P1] = dev;
 	}
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	for (i = 0; i < num_ports; ++i) {
 		u32 in[MLX5_ST_SZ_DW(query_cong_statistics_in)] = {};
diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 05533c71b10e..13c31372337a 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1488,7 +1488,7 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 	cancel_work_sync(&channel->intent_work);
 
 	if (channel->rpdev) {
-		strncpy(chinfo.name, channel->name, sizeof(chinfo.name));
+		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
 		chinfo.src = RPMSG_ADDR_ANY;
 		chinfo.dst = RPMSG_ADDR_ANY;
 
diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index c1c07ff39a79..56bc622de25e 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1089,7 +1089,7 @@ static int qcom_smd_create_device(struct qcom_smd_channel *channel)
 
 	/* Assign public information to the rpmsg_device */
 	rpdev = &qsdev->rpdev;
-	strncpy(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
+	strscpy_pad(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
 	rpdev->src = RPMSG_ADDR_ANY;
 	rpdev->dst = RPMSG_ADDR_ANY;
 
@@ -1320,7 +1320,7 @@ static void qcom_channel_state_worker(struct work_struct *work)
 
 		spin_unlock_irqrestore(&edge->channels_lock, flags);
 
-		strncpy(chinfo.name, channel->name, sizeof(chinfo.name));
+		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
 		chinfo.src = RPMSG_ADDR_ANY;
 		chinfo.dst = RPMSG_ADDR_ANY;
 		rpmsg_unregister_device(&edge->dev, &chinfo);
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 544401f76c07..73c7197081ea 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3686,11 +3686,6 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 err1:
 	scsi_host_put(lport->host);
 err0:
-	if (qedf) {
-		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe done.\n");
-
-		clear_bit(QEDF_PROBING, &qedf->flags);
-	}
 	return rc;
 }
 
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index f48a23adbc35..094e812e9e69 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1268,6 +1268,11 @@ static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	/* don't do anything here: "fault" will set up page table entries */
 	vma->vm_ops = &mon_bin_vm_ops;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+
+	vma->vm_flags &= ~VM_MAYWRITE;
 	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = filp->private_data;
 	mon_bin_vma_open(vma);
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index a2ecb3b5d13e..49448cdbe998 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1319,8 +1319,7 @@ static u32 get_ftdi_divisor(struct tty_struct *tty,
 		case 38400: div_value = ftdi_sio_b38400; break;
 		case 57600: div_value = ftdi_sio_b57600;  break;
 		case 115200: div_value = ftdi_sio_b115200; break;
-		} /* baud */
-		if (div_value == 0) {
+		default:
 			dev_dbg(dev, "%s - Baudrate (%d) requested is not supported\n",
 				__func__,  baud);
 			div_value = ftdi_sio_b9600;
diff --git a/fs/inode.c b/fs/inode.c
index ea380e3a4db1..8279c700a2b7 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -167,8 +167,6 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_wb_frn_history = 0;
 #endif
 
-	if (security_inode_alloc(inode))
-		goto out;
 	spin_lock_init(&inode->i_lock);
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
@@ -205,11 +203,12 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_fsnotify_mask = 0;
 #endif
 	inode->i_flctx = NULL;
+
+	if (unlikely(security_inode_alloc(inode)))
+		return -ENOMEM;
 	this_cpu_inc(nr_inodes);
 
 	return 0;
-out:
-	return -ENOMEM;
 }
 EXPORT_SYMBOL(inode_init_always);
 
diff --git a/include/linux/scmi_protocol.h b/include/linux/scmi_protocol.h
index 80e781c51ddc..d22f62203ee3 100644
--- a/include/linux/scmi_protocol.h
+++ b/include/linux/scmi_protocol.h
@@ -74,7 +74,7 @@ struct scmi_protocol_handle;
 struct scmi_clk_proto_ops {
 	int (*count_get)(const struct scmi_protocol_handle *ph);
 
-	const struct scmi_clock_info *(*info_get)
+	const struct scmi_clock_info __must_check *(*info_get)
 		(const struct scmi_protocol_handle *ph, u32 clk_id);
 	int (*rate_get)(const struct scmi_protocol_handle *ph, u32 clk_id,
 			u64 *rate);
@@ -452,7 +452,7 @@ enum scmi_sensor_class {
  */
 struct scmi_sensor_proto_ops {
 	int (*count_get)(const struct scmi_protocol_handle *ph);
-	const struct scmi_sensor_info *(*info_get)
+	const struct scmi_sensor_info __must_check *(*info_get)
 		(const struct scmi_protocol_handle *ph, u32 sensor_id);
 	int (*trip_point_config)(const struct scmi_protocol_handle *ph,
 				 u32 sensor_id, u8 trip_id, u64 trip_value);
diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index d0d188c3294b..a8994f307fc3 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -15,6 +15,22 @@
 #ifndef IEEE802154_NETDEVICE_H
 #define IEEE802154_NETDEVICE_H
 
+#define IEEE802154_REQUIRED_SIZE(struct_type, member) \
+	(offsetof(typeof(struct_type), member) + \
+	sizeof(((typeof(struct_type) *)(NULL))->member))
+
+#define IEEE802154_ADDR_OFFSET \
+	offsetof(typeof(struct sockaddr_ieee802154), addr)
+
+#define IEEE802154_MIN_NAMELEN (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, addr_type))
+
+#define IEEE802154_NAMELEN_SHORT (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, short_addr))
+
+#define IEEE802154_NAMELEN_LONG (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, hwaddr))
+
 #include <net/af_ieee802154.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
@@ -165,6 +181,27 @@ static inline void ieee802154_devaddr_to_raw(void *raw, __le64 addr)
 	memcpy(raw, &temp, IEEE802154_ADDR_LEN);
 }
 
+static inline int
+ieee802154_sockaddr_check_size(struct sockaddr_ieee802154 *daddr, int len)
+{
+	struct ieee802154_addr_sa *sa;
+
+	sa = &daddr->addr;
+	if (len < IEEE802154_MIN_NAMELEN)
+		return -EINVAL;
+	switch (sa->addr_type) {
+	case IEEE802154_ADDR_SHORT:
+		if (len < IEEE802154_NAMELEN_SHORT)
+			return -EINVAL;
+		break;
+	case IEEE802154_ADDR_LONG:
+		if (len < IEEE802154_NAMELEN_LONG)
+			return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
 static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,
 					   const struct ieee802154_addr_sa *sa)
 {
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index f9869d9ce57d..7517f4faf6b3 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -87,7 +87,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 						struct xdp_umem *umem);
 int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
-int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 			 struct net_device *dev, u16 queue_id);
 int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs);
 void xp_destroy(struct xsk_buff_pool *pool);
diff --git a/mm/gup.c b/mm/gup.c
index 05068d3d2557..1a23cd0b4fba 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2266,8 +2266,28 @@ static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
 }
 
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
-static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
-			 unsigned int flags, struct page **pages, int *nr)
+/*
+ * Fast-gup relies on pte change detection to avoid concurrent pgtable
+ * operations.
+ *
+ * To pin the page, fast-gup needs to do below in order:
+ * (1) pin the page (by prefetching pte), then (2) check pte not changed.
+ *
+ * For the rest of pgtable operations where pgtable updates can be racy
+ * with fast-gup, we need to do (1) clear pte, then (2) check whether page
+ * is pinned.
+ *
+ * Above will work for all pte-level operations, including THP split.
+ *
+ * For THP collapse, it's a bit more complicated because fast-gup may be
+ * walking a pgtable page that is being freed (pte is still valid but pmd
+ * can be cleared already).  To avoid race in such condition, we need to
+ * also check pmd here to make sure pmd doesn't change (corresponds to
+ * pmdp_collapse_flush() in the THP collapse code path).
+ */
+static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+			 unsigned long end, unsigned int flags,
+			 struct page **pages, int *nr)
 {
 	struct dev_pagemap *pgmap = NULL;
 	int nr_start = *nr, ret = 0;
@@ -2312,7 +2332,8 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			goto pte_unmap;
 		}
 
-		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
+		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
+		    unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_compound_head(head, 1, flags);
 			goto pte_unmap;
 		}
@@ -2357,8 +2378,9 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
  * get_user_pages_fast_only implementation that can pin pages. Thus it's still
  * useful to have gup_huge_pmd even if we can't operate on ptes.
  */
-static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
-			 unsigned int flags, struct page **pages, int *nr)
+static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+			 unsigned long end, unsigned int flags,
+			 struct page **pages, int *nr)
 {
 	return 0;
 }
@@ -2667,7 +2689,7 @@ static int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr, unsigned lo
 			if (!gup_huge_pd(__hugepd(pmd_val(pmd)), addr,
 					 PMD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pte_range(pmd, addr, next, flags, pages, nr))
+		} else if (!gup_pte_range(pmd, pmdp, addr, next, flags, pages, nr))
 			return 0;
 	} while (pmdp++, addr = next, addr != end);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8cc150a88361..07941a1540cb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2879,14 +2879,15 @@ static void split_huge_pages_all(void)
 	unsigned long total = 0, split = 0;
 
 	pr_debug("Split all THPs\n");
-	for_each_populated_zone(zone) {
+	for_each_zone(zone) {
+		if (!managed_zone(zone))
+			continue;
 		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++) {
-			if (!pfn_valid(pfn))
-				continue;
+			int nr_pages;
 
-			page = pfn_to_page(pfn);
-			if (!get_page_unless_zero(page))
+			page = pfn_to_online_page(pfn);
+			if (!page || !get_page_unless_zero(page))
 				continue;
 
 			if (zone != page_zone(page))
@@ -2897,8 +2898,10 @@ static void split_huge_pages_all(void)
 
 			total++;
 			lock_page(page);
+			nr_pages = thp_nr_pages(page);
 			if (!split_huge_page(page))
 				split++;
+			pfn += nr_pages - 1;
 			unlock_page(page);
 next:
 			put_page(page);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8a8b3aa92937..dd069afd9cb9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1146,10 +1146,12 @@ static void collapse_huge_page(struct mm_struct *mm,
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
-	 * After this gup_fast can't run anymore. This also removes
-	 * any huge TLB entry from the CPU so we won't allow
-	 * huge and small TLB entries for the same virtual address
-	 * to avoid the risk of CPU bugs in that area.
+	 * This removes any huge TLB entry from the CPU so we won't allow
+	 * huge and small TLB entries for the same virtual address to
+	 * avoid the risk of CPU bugs in that area.
+	 *
+	 * Parallel fast GUP is fine since fast GUP will back off when
+	 * it detects PMD is changed.
 	 */
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 7bb9ef35c570..fd5862f9e26a 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -200,8 +200,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *_uaddr, int len)
 	int err = 0;
 	struct net_device *dev = NULL;
 
-	if (len < sizeof(*uaddr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(uaddr, len);
+	if (err < 0)
+		return err;
 
 	uaddr = (struct sockaddr_ieee802154 *)_uaddr;
 	if (uaddr->family != AF_IEEE802154)
@@ -493,7 +494,8 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 
 	ro->bound = 0;
 
-	if (len < sizeof(*addr))
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
 		goto out;
 
 	if (addr->family != AF_IEEE802154)
@@ -564,8 +566,9 @@ static int dgram_connect(struct sock *sk, struct sockaddr *uaddr,
 	struct dgram_sock *ro = dgram_sk(sk);
 	int err = 0;
 
-	if (len < sizeof(*addr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
+		return err;
 
 	if (addr->family != AF_IEEE802154)
 		return -EINVAL;
@@ -604,6 +607,7 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	struct ieee802154_mac_cb *cb;
 	struct dgram_sock *ro = dgram_sk(sk);
 	struct ieee802154_addr dst_addr;
+	DECLARE_SOCKADDR(struct sockaddr_ieee802154*, daddr, msg->msg_name);
 	int hlen, tlen;
 	int err;
 
@@ -612,10 +616,20 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		return -EOPNOTSUPP;
 	}
 
-	if (!ro->connected && !msg->msg_name)
-		return -EDESTADDRREQ;
-	else if (ro->connected && msg->msg_name)
-		return -EISCONN;
+	if (msg->msg_name) {
+		if (ro->connected)
+			return -EISCONN;
+		if (msg->msg_namelen < IEEE802154_MIN_NAMELEN)
+			return -EINVAL;
+		err = ieee802154_sockaddr_check_size(daddr, msg->msg_namelen);
+		if (err < 0)
+			return err;
+		ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
+	} else {
+		if (!ro->connected)
+			return -EDESTADDRREQ;
+		dst_addr = ro->dst_addr;
+	}
 
 	if (!ro->bound)
 		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);
@@ -651,16 +665,6 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	cb = mac_cb_init(skb);
 	cb->type = IEEE802154_FC_TYPE_DATA;
 	cb->ackreq = ro->want_ack;
-
-	if (msg->msg_name) {
-		DECLARE_SOCKADDR(struct sockaddr_ieee802154*,
-				 daddr, msg->msg_name);
-
-		ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
-	} else {
-		dst_addr = ro->dst_addr;
-	}
-
 	cb->secen = ro->secen;
 	cb->secen_override = ro->secen_override;
 	cb->seclevel = ro->seclevel;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4ddc269164f8..cb15d7f4eb05 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1353,7 +1353,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 		 25599, /*  4.166666... */
 		 17067, /*  2.777777... */
 		 12801, /*  2.083333... */
-		 11769, /*  1.851851... */
+		 11377, /*  1.851725... */
 		 10239, /*  1.666666... */
 		  8532, /*  1.388888... */
 		  7680, /*  1.250000... */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 9b55ca27cccf..10c302f9c6d7 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -968,8 +968,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 				goto out_unlock;
 			}
 
-			err = xp_assign_dev_shared(xs->pool, umem_xs->umem,
-						   dev, qid);
+			err = xp_assign_dev_shared(xs->pool, umem_xs, dev,
+						   qid);
 			if (err) {
 				xp_destroy(xs->pool);
 				xs->pool = NULL;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index ccedbbd27692..2aa559f1c185 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -206,17 +206,18 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	return err;
 }
 
-int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 			 struct net_device *dev, u16 queue_id)
 {
 	u16 flags;
+	struct xdp_umem *umem = umem_xs->umem;
 
 	/* One fill and completion ring required for each queue id. */
 	if (!pool->fq || !pool->cq)
 		return -EINVAL;
 
 	flags = umem->zc ? XDP_ZEROCOPY : XDP_COPY;
-	if (pool->uses_need_wakeup)
+	if (umem_xs->pool->uses_need_wakeup)
 		flags |= XDP_USE_NEED_WAKEUP;
 
 	return xp_assign_dev(pool, dev, queue_id, flags);
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 8be892887d71..f182700e0ac1 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -52,6 +52,7 @@ KBUILD_CFLAGS += -Wno-format-zero-length
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
+KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
 endif
 
 endif
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index d3da42e0e7b3..1994a83fa391 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1270,6 +1270,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 	set_bit(pcm_idx, &spec->pcm_in_use);
 	per_pin = get_pin(spec, pin_idx);
 	per_pin->cvt_nid = per_cvt->cvt_nid;
+	per_pin->silent_stream = false;
 	hinfo->nid = per_cvt->cvt_nid;
 
 	/* flip stripe flag for the assigned stream if supported */
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index d94e48e1ff9b..467a426205a0 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -183,6 +183,11 @@ group_def ':' PE_MODIFIER_EVENT
 	err = parse_events__modifier_group(list, $3);
 	free($3);
 	if (err) {
+		struct parse_events_state *parse_state = _parse_state;
+		struct parse_events_error *error = parse_state->error;
+
+		parse_events__handle_error(error, @3.first_column,
+					   strdup("Bad modifier"), NULL);
 		free_list_evsel(list);
 		YYABORT;
 	}
@@ -240,6 +245,11 @@ event_name PE_MODIFIER_EVENT
 	err = parse_events__modifier_event(list, $2, false);
 	free($2);
 	if (err) {
+		struct parse_events_state *parse_state = _parse_state;
+		struct parse_events_error *error = parse_state->error;
+
+		parse_events__handle_error(error, @2.first_column,
+					   strdup("Bad modifier"), NULL);
 		free_list_evsel(list);
 		YYABORT;
 	}
