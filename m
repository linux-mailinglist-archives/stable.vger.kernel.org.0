Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F1A4D201F
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349548AbiCHSXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241292AbiCHSXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:23:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56E855BD;
        Tue,  8 Mar 2022 10:22:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9125B818A2;
        Tue,  8 Mar 2022 18:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3C9C340EF;
        Tue,  8 Mar 2022 18:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646763749;
        bh=wkOJxpoQ39bI1QOA6w6QrBpyw8m0dJyiROL5YPByPQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDrIN9bSpmgAcYsyrLR4L7oHAhsoyEkPoaoXYb8CagN6WdDGRLo3Gcfvu3/gt3nLL
         fjraOvxbVBNDPJy2dDPyEniBWGEicZOxhkWwQ/2tutzYovRk/eUQgZrK+niKIKvWxX
         ZJD+mPbcIw8kqwlxDabnCVw93XNnnNV7wFiKabAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.16.13
Date:   Tue,  8 Mar 2022 19:22:17 +0100
Message-Id: <164676373716331@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1646763737122246@kroah.com>
References: <1646763737122246@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index bfc28704856c..6e2e416af783 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -23,7 +23,7 @@ There are four components to pagemap:
     * Bit  56    page exclusively mapped (since 4.2)
     * Bit  57    pte is uffd-wp write-protected (since 5.13) (see
       :ref:`Documentation/admin-guide/mm/userfaultfd.rst <userfaultfd>`)
-    * Bits 57-60 zero
+    * Bits 58-60 zero
     * Bit  61    page is file-page or shared-anon (since 3.5)
     * Bit  62    page swapped
     * Bit  63    page present
diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 0ec7b7f1524b..ea281dd75517 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -100,6 +100,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2051678        | ARM64_ERRATUM_2051678       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2077057        | ARM64_ERRATUM_2077057       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2119858        | ARM64_ERRATUM_2119858       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2054223        | ARM64_ERRATUM_2054223       |
diff --git a/Documentation/trace/events.rst b/Documentation/trace/events.rst
index 8ddb9b09451c..c47f381d0c00 100644
--- a/Documentation/trace/events.rst
+++ b/Documentation/trace/events.rst
@@ -198,6 +198,15 @@ The glob (~) accepts a wild card character (\*,?) and character classes
   prev_comm ~ "*sh*"
   prev_comm ~ "ba*sh"
 
+If the field is a pointer that points into user space (for example
+"filename" from sys_enter_openat), then you have to append ".ustring" to the
+field name::
+
+  filename.ustring ~ "password"
+
+As the kernel will have to know how to retrieve the memory that the pointer
+is at from user space.
+
 5.2 Setting filters
 -------------------
 
@@ -230,6 +239,16 @@ Currently the caret ('^') for an error always appears at the beginning of
 the filter string; the error message should still be useful though
 even without more accurate position info.
 
+5.2.1 Filter limitations
+------------------------
+
+If a filter is placed on a string pointer ``(char *)`` that does not point
+to a string on the ring buffer, but instead points to kernel or user space
+memory, then, for safety reasons, at most 1024 bytes of the content is
+copied onto a temporary buffer to do the compare. If the copy of the memory
+faults (the pointer points to memory that should not be accessed), then the
+string compare will be treated as not matching.
+
 5.3 Clearing filters
 --------------------
 
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..9df9eadaeb5c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1391,7 +1391,7 @@ documentation when it pops into existence).
 -------------------
 
 :Capability: KVM_CAP_ENABLE_CAP
-:Architectures: mips, ppc, s390
+:Architectures: mips, ppc, s390, x86
 :Type: vcpu ioctl
 :Parameters: struct kvm_enable_cap (in)
 :Returns: 0 on success; -1 on error
diff --git a/Makefile b/Makefile
index 09a9bb824afa..6702e44821eb 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 16
-SUBLEVEL = 12
+SUBLEVEL = 13
 EXTRAVERSION =
 NAME = Gobble Gobble
 
diff --git a/arch/arm/boot/dts/omap3-devkit8000-common.dtsi b/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
index 5e55198e4576..54cd37336be7 100644
--- a/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
+++ b/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
@@ -158,6 +158,24 @@ &mmc3 {
 	status = "disabled";
 };
 
+/* Unusable as clockevent because if unreliable oscillator, allow to idle */
+&timer1_target {
+	/delete-property/ti,no-reset-on-init;
+	/delete-property/ti,no-idle;
+	timer@0 {
+		/delete-property/ti,timer-alwon;
+	};
+};
+
+/* Preferred timer for clockevent */
+&timer12_target {
+	ti,no-reset-on-init;
+	ti,no-idle;
+	timer@0 {
+		/* Always clocked by secure_32k_fck */
+	};
+};
+
 &twl_gpio {
 	ti,use-leds;
 	/*
diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
index c2995a280729..162d0726b008 100644
--- a/arch/arm/boot/dts/omap3-devkit8000.dts
+++ b/arch/arm/boot/dts/omap3-devkit8000.dts
@@ -14,36 +14,3 @@ aliases {
 		display2 = &tv0;
 	};
 };
-
-/* Unusable as clocksource because of unreliable oscillator */
-&counter32k {
-	status = "disabled";
-};
-
-/* Unusable as clockevent because if unreliable oscillator, allow to idle */
-&timer1_target {
-	/delete-property/ti,no-reset-on-init;
-	/delete-property/ti,no-idle;
-	timer@0 {
-		/delete-property/ti,timer-alwon;
-	};
-};
-
-/* Preferred always-on timer for clocksource */
-&timer12_target {
-	ti,no-reset-on-init;
-	ti,no-idle;
-	timer@0 {
-		/* Always clocked by secure_32k_fck */
-	};
-};
-
-/* Preferred timer for clockevent */
-&timer2_target {
-	ti,no-reset-on-init;
-	ti,no-idle;
-	timer@0 {
-		assigned-clocks = <&gpt2_fck>;
-		assigned-clock-parents = <&sys_ck>;
-	};
-};
diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts b/arch/arm/boot/dts/tegra124-nyan-big.dts
index 1d2aac2cb6d0..fdc1d64dfff9 100644
--- a/arch/arm/boot/dts/tegra124-nyan-big.dts
+++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
@@ -13,12 +13,15 @@ / {
 		     "google,nyan-big-rev1", "google,nyan-big-rev0",
 		     "google,nyan-big", "google,nyan", "nvidia,tegra124";
 
-	panel: panel {
-		compatible = "auo,b133xtn01";
-
-		power-supply = <&vdd_3v3_panel>;
-		backlight = <&backlight>;
-		ddc-i2c-bus = <&dpaux>;
+	host1x@50000000 {
+		dpaux@545c0000 {
+			aux-bus {
+				panel: panel {
+					compatible = "auo,b133xtn01";
+					backlight = <&backlight>;
+				};
+			};
+		};
 	};
 
 	mmc@700b0400 { /* SD Card on this bus */
diff --git a/arch/arm/boot/dts/tegra124-nyan-blaze.dts b/arch/arm/boot/dts/tegra124-nyan-blaze.dts
index 677babde6460..abdf4456826f 100644
--- a/arch/arm/boot/dts/tegra124-nyan-blaze.dts
+++ b/arch/arm/boot/dts/tegra124-nyan-blaze.dts
@@ -15,12 +15,15 @@ / {
 		     "google,nyan-blaze-rev0", "google,nyan-blaze",
 		     "google,nyan", "nvidia,tegra124";
 
-	panel: panel {
-		compatible = "samsung,ltn140at29-301";
-
-		power-supply = <&vdd_3v3_panel>;
-		backlight = <&backlight>;
-		ddc-i2c-bus = <&dpaux>;
+	host1x@50000000 {
+		dpaux@545c0000 {
+			aux-bus {
+				panel: panel {
+					compatible = "samsung,ltn140at29-301";
+					backlight = <&backlight>;
+				};
+			};
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index e6b54ac1ebd1..84e2d24065e9 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -48,6 +48,13 @@ sor@54540000 {
 		dpaux@545c0000 {
 			vdd-supply = <&vdd_3v3_panel>;
 			status = "okay";
+
+			aux-bus {
+				panel: panel {
+					compatible = "lg,lp129qe";
+					backlight = <&backlight>;
+				};
+			};
 		};
 	};
 
@@ -1079,13 +1086,6 @@ power {
 		};
 	};
 
-	panel: panel {
-		compatible = "lg,lp129qe";
-		power-supply = <&vdd_3v3_panel>;
-		backlight = <&backlight>;
-		ddc-i2c-bus = <&dpaux>;
-	};
-
 	vdd_mux: regulator@0 {
 		compatible = "regulator-fixed";
 		regulator-name = "+VDD_MUX";
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index 7bd30c0a4280..22f937e6f3ff 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -154,22 +154,38 @@ static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int instr)
 	return 0;
 }
 
-static struct undef_hook kgdb_brkpt_hook = {
+static struct undef_hook kgdb_brkpt_arm_hook = {
 	.instr_mask		= 0xffffffff,
 	.instr_val		= KGDB_BREAKINST,
-	.cpsr_mask		= MODE_MASK,
+	.cpsr_mask		= PSR_T_BIT | MODE_MASK,
 	.cpsr_val		= SVC_MODE,
 	.fn			= kgdb_brk_fn
 };
 
-static struct undef_hook kgdb_compiled_brkpt_hook = {
+static struct undef_hook kgdb_brkpt_thumb_hook = {
+	.instr_mask		= 0xffff,
+	.instr_val		= KGDB_BREAKINST & 0xffff,
+	.cpsr_mask		= PSR_T_BIT | MODE_MASK,
+	.cpsr_val		= PSR_T_BIT | SVC_MODE,
+	.fn			= kgdb_brk_fn
+};
+
+static struct undef_hook kgdb_compiled_brkpt_arm_hook = {
 	.instr_mask		= 0xffffffff,
 	.instr_val		= KGDB_COMPILED_BREAK,
-	.cpsr_mask		= MODE_MASK,
+	.cpsr_mask		= PSR_T_BIT | MODE_MASK,
 	.cpsr_val		= SVC_MODE,
 	.fn			= kgdb_compiled_brk_fn
 };
 
+static struct undef_hook kgdb_compiled_brkpt_thumb_hook = {
+	.instr_mask		= 0xffff,
+	.instr_val		= KGDB_COMPILED_BREAK & 0xffff,
+	.cpsr_mask		= PSR_T_BIT | MODE_MASK,
+	.cpsr_val		= PSR_T_BIT | SVC_MODE,
+	.fn			= kgdb_compiled_brk_fn
+};
+
 static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 {
 	struct pt_regs *regs = args->regs;
@@ -210,8 +226,10 @@ int kgdb_arch_init(void)
 	if (ret != 0)
 		return ret;
 
-	register_undef_hook(&kgdb_brkpt_hook);
-	register_undef_hook(&kgdb_compiled_brkpt_hook);
+	register_undef_hook(&kgdb_brkpt_arm_hook);
+	register_undef_hook(&kgdb_brkpt_thumb_hook);
+	register_undef_hook(&kgdb_compiled_brkpt_arm_hook);
+	register_undef_hook(&kgdb_compiled_brkpt_thumb_hook);
 
 	return 0;
 }
@@ -224,8 +242,10 @@ int kgdb_arch_init(void)
  */
 void kgdb_arch_exit(void)
 {
-	unregister_undef_hook(&kgdb_brkpt_hook);
-	unregister_undef_hook(&kgdb_compiled_brkpt_hook);
+	unregister_undef_hook(&kgdb_brkpt_arm_hook);
+	unregister_undef_hook(&kgdb_brkpt_thumb_hook);
+	unregister_undef_hook(&kgdb_compiled_brkpt_arm_hook);
+	unregister_undef_hook(&kgdb_compiled_brkpt_thumb_hook);
 	unregister_die_notifier(&kgdb_notifier);
 }
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 274e4f73fd33..5e2be37a198e 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -212,12 +212,14 @@ early_param("ecc", early_ecc);
 static int __init early_cachepolicy(char *p)
 {
 	pr_warn("cachepolicy kernel parameter not supported without cp15\n");
+	return 0;
 }
 early_param("cachepolicy", early_cachepolicy);
 
 static int __init noalign_setup(char *__unused)
 {
 	pr_warn("noalign kernel parameter not supported without cp15\n");
+	return 1;
 }
 __setup("noalign", noalign_setup);
 
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ae0e93871ee5..651bf217465e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -681,6 +681,22 @@ config ARM64_ERRATUM_2051678
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2077057
+	bool "Cortex-A510: 2077057: workaround software-step corrupting SPSR_EL2"
+	help
+	  This option adds the workaround for ARM Cortex-A510 erratum 2077057.
+	  Affected Cortex-A510 may corrupt SPSR_EL2 when the a step exception is
+	  expected, but a Pointer Authentication trap is taken instead. The
+	  erratum causes SPSR_EL1 to be copied to SPSR_EL2, which could allow
+	  EL1 to cause a return to EL2 with a guest controlled ELR_EL2.
+
+	  This can only happen when EL2 is stepping EL1.
+
+	  When these conditions occur, the SPSR_EL2 value is unchanged from the
+	  previous guest entry, and can be restored from the in-memory copy.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_2119858
 	bool "Cortex-A710/X2: 2119858: workaround TRBE overwriting trace data in FILL mode"
 	default y
diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index 6288e104a089..a2635b14da30 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -543,8 +543,7 @@ pcie_ctlr: pcie@40000000 {
 			 <0x02000000 0x00 0x50000000 0x00 0x50000000 0x0 0x08000000>,
 			 <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
 		/* Standard AXI Translation entries as programmed by EDK2 */
-		dma-ranges = <0x02000000 0x0 0x2c1c0000 0x0 0x2c1c0000 0x0 0x00040000>,
-			     <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
+		dma-ranges = <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
 			     <0x43000000 0x8 0x00000000 0x8 0x00000000 0x2 0x00000000>;
 		#interrupt-cells = <1>;
 		interrupt-map-mask = <0 0 0 7>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index c2f3f118f82e..f13d31ebfcbd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -681,7 +681,6 @@ pgc_vpumix: power-domain@6 {
 						clocks = <&clk IMX8MM_CLK_VPU_DEC_ROOT>;
 						assigned-clocks = <&clk IMX8MM_CLK_VPU_BUS>;
 						assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_800M>;
-						resets = <&src IMX8MQ_RESET_VPU_RESET>;
 					};
 
 					pgc_vpu_g1: power-domain@7 {
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
index 45a5ae5d2027..162f08bca0d4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
@@ -286,7 +286,7 @@ max98357a: max98357a {
 
 	sound: sound {
 		compatible = "rockchip,rk3399-gru-sound";
-		rockchip,cpu = <&i2s0 &i2s2>;
+		rockchip,cpu = <&i2s0 &spdif>;
 	};
 };
 
@@ -437,10 +437,6 @@ &i2s0 {
 	status = "okay";
 };
 
-&i2s2 {
-	status = "okay";
-};
-
 &io_domains {
 	status = "okay";
 
@@ -537,6 +533,17 @@ &sdmmc {
 	vqmmc-supply = <&ppvar_sd_card_io>;
 };
 
+&spdif {
+	status = "okay";
+
+	/*
+	 * SPDIF is routed internally to DP; we either don't use these pins, or
+	 * mux them to something else.
+	 */
+	/delete-property/ pinctrl-0;
+	/delete-property/ pinctrl-names;
+};
+
 &spi1 {
 	status = "okay";
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts b/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts
index 4d4b2a301b1a..f6290538c8a4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts
@@ -285,8 +285,6 @@ regulator-state-mem {
 			vcc_ddr: DCDC_REG3 {
 				regulator-always-on;
 				regulator-boot-on;
-				regulator-min-microvolt = <1100000>;
-				regulator-max-microvolt = <1100000>;
 				regulator-initial-mode = <0x2>;
 				regulator-name = "vcc_ddr";
 				regulator-state-mem {
diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index 2fd313a295f8..d91df1cde736 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -32,13 +32,11 @@ gmac0: ethernet@fe2a0000 {
 		clocks = <&cru SCLK_GMAC0>, <&cru SCLK_GMAC0_RX_TX>,
 			 <&cru SCLK_GMAC0_RX_TX>, <&cru CLK_MAC0_REFOUT>,
 			 <&cru ACLK_GMAC0>, <&cru PCLK_GMAC0>,
-			 <&cru SCLK_GMAC0_RX_TX>, <&cru CLK_GMAC0_PTP_REF>,
-			 <&cru PCLK_XPCS>;
+			 <&cru SCLK_GMAC0_RX_TX>, <&cru CLK_GMAC0_PTP_REF>;
 		clock-names = "stmmaceth", "mac_clk_rx",
 			      "mac_clk_tx", "clk_mac_refout",
 			      "aclk_mac", "pclk_mac",
-			      "clk_mac_speed", "ptp_ref",
-			      "pclk_xpcs";
+			      "clk_mac_speed", "ptp_ref";
 		resets = <&cru SRST_A_GMAC0>;
 		reset-names = "stmmaceth";
 		rockchip,grf = <&grf>;
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 066098198c24..b217941713a8 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -600,6 +600,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		CAP_MIDR_RANGE_LIST(trbe_write_out_of_range_cpus),
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2077057
+	{
+		.desc = "ARM erratum 2077057",
+		.capability = ARM64_WORKAROUND_2077057,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2),
+	},
+#endif
 #ifdef CONFIG_ARM64_ERRATUM_2064142
 	{
 		.desc = "ARM erratum 2064142",
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 94f83cd44e50..0ee6bd390bd0 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,7 +33,7 @@
  */
 
 
-void start_backtrace(struct stackframe *frame, unsigned long fp,
+notrace void start_backtrace(struct stackframe *frame, unsigned long fp,
 		     unsigned long pc)
 {
 	frame->fp = fp;
@@ -55,6 +55,7 @@ void start_backtrace(struct stackframe *frame, unsigned long fp,
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
 }
+NOKPROBE_SYMBOL(start_backtrace);
 
 /*
  * Unwind from one frame record (A) to the next frame record (B).
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index adb67f8c9d7d..3ae9c0b94487 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -424,6 +424,24 @@ static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
+static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	/*
+	 * Check for the conditions of Cortex-A510's #2077057. When these occur
+	 * SPSR_EL2 can't be trusted, but isn't needed either as it is
+	 * unchanged from the value in vcpu_gp_regs(vcpu)->pstate.
+	 * Are we single-stepping the guest, and took a PAC exception from the
+	 * active-not-pending state?
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_2077057)		&&
+	    vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP			&&
+	    *vcpu_cpsr(vcpu) & DBG_SPSR_SS				&&
+	    ESR_ELx_EC(read_sysreg_el2(SYS_ESR)) == ESR_ELx_EC_PAC)
+		write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+
+	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -435,7 +453,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * Save PSTATE early so that we can evaluate the vcpu mode
 	 * early on.
 	 */
-	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
+	synchronize_vcpu_pstate(vcpu, exit_code);
 
 	/*
 	 * Check whether we want to repaint the state one way or
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 48c6067fc5ec..f97299268274 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -248,6 +248,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 						    IRQCHIP_STATE_PENDING,
 						    &val);
 			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+		} else if (vgic_irq_is_mapped_level(irq)) {
+			val = vgic_get_phys_line_level(irq);
 		} else {
 			val = irq_is_pending(irq);
 		}
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index e7719e8f18de..9c65b1e25a96 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -55,9 +55,10 @@ WORKAROUND_1418040
 WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
-WORKAROUND_2064142
-WORKAROUND_2038923
 WORKAROUND_1902691
+WORKAROUND_2038923
+WORKAROUND_2064142
+WORKAROUND_2077057
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index f979adfd4fc2..ef73ba1e0ec1 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -803,7 +803,7 @@ early_param("coherentio", setcoherentio);
 
 static int __init setnocoherentio(char *str)
 {
-	dma_default_coherent = true;
+	dma_default_coherent = false;
 	pr_info("Software DMA cache coherency (command line)\n");
 	return 0;
 }
diff --git a/arch/mips/ralink/mt7621.c b/arch/mips/ralink/mt7621.c
index bd71f5b14238..4c8378661219 100644
--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -20,31 +20,41 @@
 
 #include "common.h"
 
-static void *detect_magic __initdata = detect_memory_region;
+#define MT7621_MEM_TEST_PATTERN         0xaa5555aa
+
+static u32 detect_magic __initdata;
 
 phys_addr_t mips_cpc_default_phys_base(void)
 {
 	panic("Cannot detect cpc address");
 }
 
+static bool __init mt7621_addr_wraparound_test(phys_addr_t size)
+{
+	void *dm = (void *)KSEG1ADDR(&detect_magic);
+
+	if (CPHYSADDR(dm + size) >= MT7621_LOWMEM_MAX_SIZE)
+		return true;
+	__raw_writel(MT7621_MEM_TEST_PATTERN, dm);
+	if (__raw_readl(dm) != __raw_readl(dm + size))
+		return false;
+	__raw_writel(~MT7621_MEM_TEST_PATTERN, dm);
+	return __raw_readl(dm) == __raw_readl(dm + size);
+}
+
 static void __init mt7621_memory_detect(void)
 {
-	void *dm = &detect_magic;
 	phys_addr_t size;
 
-	for (size = 32 * SZ_1M; size < 256 * SZ_1M; size <<= 1) {
-		if (!__builtin_memcmp(dm, dm + size, sizeof(detect_magic)))
-			break;
+	for (size = 32 * SZ_1M; size <= 256 * SZ_1M; size <<= 1) {
+		if (mt7621_addr_wraparound_test(size)) {
+			memblock_add(MT7621_LOWMEM_BASE, size);
+			return;
+		}
 	}
 
-	if ((size == 256 * SZ_1M) &&
-	    (CPHYSADDR(dm + size) < MT7621_LOWMEM_MAX_SIZE) &&
-	    __builtin_memcmp(dm, dm + size, sizeof(detect_magic))) {
-		memblock_add(MT7621_LOWMEM_BASE, MT7621_LOWMEM_MAX_SIZE);
-		memblock_add(MT7621_HIGHMEM_BASE, MT7621_HIGHMEM_SIZE);
-	} else {
-		memblock_add(MT7621_LOWMEM_BASE, size);
-	}
+	memblock_add(MT7621_LOWMEM_BASE, MT7621_LOWMEM_MAX_SIZE);
+	memblock_add(MT7621_HIGHMEM_BASE, MT7621_HIGHMEM_SIZE);
 }
 
 void __init ralink_of_remap(void)
diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index 7ebaef10ea1b..ac7a25298a04 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -24,6 +24,9 @@ obj-$(CONFIG_KASAN)   += kasan_init.o
 ifdef CONFIG_KASAN
 KASAN_SANITIZE_kasan_init.o := n
 KASAN_SANITIZE_init.o := n
+ifdef CONFIG_DEBUG_VIRTUAL
+KASAN_SANITIZE_physaddr.o := n
+endif
 endif
 
 obj-$(CONFIG_DEBUG_VIRTUAL) += physaddr.o
diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index 54294f83513d..e26e367a3d9e 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -22,8 +22,7 @@ asmlinkage void __init kasan_early_init(void)
 
 	for (i = 0; i < PTRS_PER_PTE; ++i)
 		set_pte(kasan_early_shadow_pte + i,
-			mk_pte(virt_to_page(kasan_early_shadow_page),
-			       PAGE_KERNEL));
+			pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL));
 
 	for (i = 0; i < PTRS_PER_PMD; ++i)
 		set_pmd(kasan_early_shadow_pmd + i,
diff --git a/arch/s390/include/asm/extable.h b/arch/s390/include/asm/extable.h
index 16dc57dd90b3..8511f0e59290 100644
--- a/arch/s390/include/asm/extable.h
+++ b/arch/s390/include/asm/extable.h
@@ -69,8 +69,13 @@ static inline void swap_ex_entry_fixup(struct exception_table_entry *a,
 {
 	a->fixup = b->fixup + delta;
 	b->fixup = tmp.fixup - delta;
-	a->handler = b->handler + delta;
-	b->handler = tmp.handler - delta;
+	a->handler = b->handler;
+	if (a->handler)
+		a->handler += delta;
+	b->handler = tmp.handler;
+	if (b->handler)
+		b->handler -= delta;
 }
+#define swap_ex_entry_fixup swap_ex_entry_fixup
 
 #endif
diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index 267f70f4393f..6f80ec9c04be 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -47,15 +47,17 @@ struct ftrace_regs {
 
 static __always_inline struct pt_regs *arch_ftrace_get_regs(struct ftrace_regs *fregs)
 {
-	return &fregs->regs;
+	struct pt_regs *regs = &fregs->regs;
+
+	if (test_pt_regs_flag(regs, PIF_FTRACE_FULL_REGS))
+		return regs;
+	return NULL;
 }
 
 static __always_inline void ftrace_instruction_pointer_set(struct ftrace_regs *fregs,
 							   unsigned long ip)
 {
-	struct pt_regs *regs = arch_ftrace_get_regs(fregs);
-
-	regs->psw.addr = ip;
+	fregs->regs.psw.addr = ip;
 }
 
 /*
diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index 4ffa8e7f0ed3..ddb70fb13fbc 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -15,11 +15,13 @@
 #define PIF_EXECVE_PGSTE_RESTART	1	/* restart execve for PGSTE binaries */
 #define PIF_SYSCALL_RET_SET		2	/* return value was set via ptrace */
 #define PIF_GUEST_FAULT			3	/* indicates program check in sie64a */
+#define PIF_FTRACE_FULL_REGS		4	/* all register contents valid (ftrace) */
 
 #define _PIF_SYSCALL			BIT(PIF_SYSCALL)
 #define _PIF_EXECVE_PGSTE_RESTART	BIT(PIF_EXECVE_PGSTE_RESTART)
 #define _PIF_SYSCALL_RET_SET		BIT(PIF_SYSCALL_RET_SET)
 #define _PIF_GUEST_FAULT		BIT(PIF_GUEST_FAULT)
+#define _PIF_FTRACE_FULL_REGS		BIT(PIF_FTRACE_FULL_REGS)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 21d62d8b6b9a..89c0870d5679 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -159,9 +159,38 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
 	return 0;
 }
 
+static struct ftrace_hotpatch_trampoline *ftrace_get_trampoline(struct dyn_ftrace *rec)
+{
+	struct ftrace_hotpatch_trampoline *trampoline;
+	struct ftrace_insn insn;
+	s64 disp;
+	u16 opc;
+
+	if (copy_from_kernel_nofault(&insn, (void *)rec->ip, sizeof(insn)))
+		return ERR_PTR(-EFAULT);
+	disp = (s64)insn.disp * 2;
+	trampoline = (void *)(rec->ip + disp);
+	if (get_kernel_nofault(opc, &trampoline->brasl_opc))
+		return ERR_PTR(-EFAULT);
+	if (opc != 0xc015)
+		return ERR_PTR(-EINVAL);
+	return trampoline;
+}
+
 int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 		       unsigned long addr)
 {
+	struct ftrace_hotpatch_trampoline *trampoline;
+	u64 old;
+
+	trampoline = ftrace_get_trampoline(rec);
+	if (IS_ERR(trampoline))
+		return PTR_ERR(trampoline);
+	if (get_kernel_nofault(old, &trampoline->interceptor))
+		return -EFAULT;
+	if (old != old_addr)
+		return -EINVAL;
+	s390_kernel_write(&trampoline->interceptor, &addr, sizeof(addr));
 	return 0;
 }
 
@@ -188,6 +217,12 @@ static void brcl_enable(void *brcl)
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
+	struct ftrace_hotpatch_trampoline *trampoline;
+
+	trampoline = ftrace_get_trampoline(rec);
+	if (IS_ERR(trampoline))
+		return PTR_ERR(trampoline);
+	s390_kernel_write(&trampoline->interceptor, &addr, sizeof(addr));
 	brcl_enable((void *)rec->ip);
 	return 0;
 }
@@ -291,7 +326,7 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 
 	regs = ftrace_get_regs(fregs);
 	p = get_kprobe((kprobe_opcode_t *)ip);
-	if (unlikely(!p) || kprobe_disabled(p))
+	if (!regs || unlikely(!p) || kprobe_disabled(p))
 		goto out;
 
 	if (kprobe_running()) {
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 39bcc0e39a10..a24177dcd12a 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -27,6 +27,7 @@ ENDPROC(ftrace_stub)
 #define STACK_PTREGS_GPRS	(STACK_PTREGS + __PT_GPRS)
 #define STACK_PTREGS_PSW	(STACK_PTREGS + __PT_PSW)
 #define STACK_PTREGS_ORIG_GPR2	(STACK_PTREGS + __PT_ORIG_GPR2)
+#define STACK_PTREGS_FLAGS	(STACK_PTREGS + __PT_FLAGS)
 #ifdef __PACK_STACK
 /* allocate just enough for r14, r15 and backchain */
 #define TRACED_FUNC_FRAME_SIZE	24
@@ -57,6 +58,14 @@ ENDPROC(ftrace_stub)
 	.if \allregs == 1
 	stg	%r14,(STACK_PTREGS_PSW)(%r15)
 	stosm	(STACK_PTREGS_PSW)(%r15),0
+#ifdef CONFIG_HAVE_MARCH_Z10_FEATURES
+	mvghi	STACK_PTREGS_FLAGS(%r15),_PIF_FTRACE_FULL_REGS
+#else
+	lghi	%r14,_PIF_FTRACE_FULL_REGS
+	stg	%r14,STACK_PTREGS_FLAGS(%r15)
+#endif
+	.else
+	xc	STACK_PTREGS_FLAGS(8,%r15),STACK_PTREGS_FLAGS(%r15)
 	.endif
 
 	lg	%r14,(__SF_GPRS+8*8)(%r1)	# restore original return address
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 225ab2d0a4c6..65a31cb0611f 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -800,6 +800,8 @@ static void __init check_initrd(void)
 static void __init reserve_kernel(void)
 {
 	memblock_reserve(0, STARTUP_NORMAL_OFFSET);
+	memblock_reserve(OLDMEM_BASE, sizeof(unsigned long));
+	memblock_reserve(OLDMEM_SIZE, sizeof(unsigned long));
 	memblock_reserve(__amode31_base, __eamode31 - __samode31);
 	memblock_reserve(__pa(sclp_early_sccb), EXT_SCCB_READ_SCP);
 	memblock_reserve(__pa(_stext), _end - _stext);
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 462dd8e9b03d..f6ccf92203c5 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -239,6 +239,9 @@ static void __init kvmclock_init_mem(void)
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
 {
+	if (!kvm_para_available())
+		return 0;
+
 	kvmclock_init_mem();
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 84e23b9864f4..d70eee9e6716 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3573,7 +3573,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
 
-	return 0;
+	return r;
 }
 
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0714fa0e7ede..c6eb3e45e3d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4163,6 +4163,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SREGS2:
 	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
 	case KVM_CAP_VCPU_ATTRIBUTES:
+	case KVM_CAP_ENABLE_CAP:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
diff --git a/block/blk-map.c b/block/blk-map.c
index 4526adde0156..c7f71d83eff1 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -446,7 +446,7 @@ static struct bio *bio_copy_kern(struct request_queue *q, void *data,
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(GFP_NOIO | gfp_mask);
+		page = alloc_page(GFP_NOIO | __GFP_ZERO | gfp_mask);
 		if (!page)
 			goto cleanup;
 
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index ae8375e9d268..9d371859e81e 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -964,14 +964,14 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 
 	if ((freq >> 12) != 0xABCDE) {
 		int i;
-		u8 sr;
+		u16 sr;
 		u32 total = 0;
 
 		pr_warn("BIOS has not set timing clocks\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for (i = 0; i < 128; i++) {
-			pci_read_config_byte(dev, 0x78, &sr);
+			pci_read_config_word(dev, 0x78, &sr);
 			total += sr & 0x1FF;
 			udelay(15);
 		}
diff --git a/drivers/auxdisplay/lcd2s.c b/drivers/auxdisplay/lcd2s.c
index 38ba08628ccb..2578b2d45439 100644
--- a/drivers/auxdisplay/lcd2s.c
+++ b/drivers/auxdisplay/lcd2s.c
@@ -238,7 +238,7 @@ static int lcd2s_redefine_char(struct charlcd *lcd, char *esc)
 	if (buf[1] > 7)
 		return 1;
 
-	i = 0;
+	i = 2;
 	shift = 0;
 	value = 0;
 	while (*esc && i < LCD2S_CHARACTER_SIZE + 2) {
@@ -298,6 +298,10 @@ static int lcd2s_i2c_probe(struct i2c_client *i2c,
 			I2C_FUNC_SMBUS_WRITE_BLOCK_DATA))
 		return -EIO;
 
+	lcd2s = devm_kzalloc(&i2c->dev, sizeof(*lcd2s), GFP_KERNEL);
+	if (!lcd2s)
+		return -ENOMEM;
+
 	/* Test, if the display is responding */
 	err = lcd2s_i2c_smbus_write_byte(i2c, LCD2S_CMD_DISPLAY_OFF);
 	if (err < 0)
@@ -307,12 +311,6 @@ static int lcd2s_i2c_probe(struct i2c_client *i2c,
 	if (!lcd)
 		return -ENOMEM;
 
-	lcd2s = kzalloc(sizeof(struct lcd2s_data), GFP_KERNEL);
-	if (!lcd2s) {
-		err = -ENOMEM;
-		goto fail1;
-	}
-
 	lcd->drvdata = lcd2s;
 	lcd2s->i2c = i2c;
 	lcd2s->charlcd = lcd;
@@ -321,26 +319,24 @@ static int lcd2s_i2c_probe(struct i2c_client *i2c,
 	err = device_property_read_u32(&i2c->dev, "display-height-chars",
 			&lcd->height);
 	if (err)
-		goto fail2;
+		goto fail1;
 
 	err = device_property_read_u32(&i2c->dev, "display-width-chars",
 			&lcd->width);
 	if (err)
-		goto fail2;
+		goto fail1;
 
 	lcd->ops = &lcd2s_ops;
 
 	err = charlcd_register(lcd2s->charlcd);
 	if (err)
-		goto fail2;
+		goto fail1;
 
 	i2c_set_clientdata(i2c, lcd2s);
 	return 0;
 
-fail2:
-	kfree(lcd2s);
 fail1:
-	kfree(lcd);
+	charlcd_free(lcd2s->charlcd);
 	return err;
 }
 
@@ -349,7 +345,7 @@ static int lcd2s_i2c_remove(struct i2c_client *i2c)
 	struct lcd2s_data *lcd2s = i2c_get_clientdata(i2c);
 
 	charlcd_unregister(lcd2s->charlcd);
-	kfree(lcd2s->charlcd);
+	charlcd_free(lcd2s->charlcd);
 	return 0;
 }
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c3a36cfaa855..fdb4798cb006 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -79,6 +79,7 @@
 #include <linux/ioprio.h>
 #include <linux/blk-cgroup.h>
 #include <linux/sched/mm.h>
+#include <linux/statfs.h>
 
 #include "loop.h"
 
@@ -774,8 +775,13 @@ static void loop_config_discard(struct loop_device *lo)
 		granularity = 0;
 
 	} else {
+		struct kstatfs sbuf;
+
 		max_discard_sectors = UINT_MAX >> 9;
-		granularity = inode->i_sb->s_blocksize;
+		if (!vfs_statfs(&file->f_path, &sbuf))
+			granularity = sbuf.f_bsize;
+		else
+			max_discard_sectors = 0;
 	}
 
 	if (max_discard_sectors) {
diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index 5c40ca1d4740..1fccb457fcc5 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -241,8 +241,7 @@ static void __init dmtimer_systimer_assign_alwon(void)
 	bool quirk_unreliable_oscillator = false;
 
 	/* Quirk unreliable 32 KiHz oscillator with incomplete dts */
-	if (of_machine_is_compatible("ti,omap3-beagle-ab4") ||
-	    of_machine_is_compatible("timll,omap3-devkit8000")) {
+	if (of_machine_is_compatible("ti,omap3-beagle-ab4")) {
 		quirk_unreliable_oscillator = true;
 		counter_32k = -ENODEV;
 	}
diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 7f72b3f4cd1a..19ac95c0098f 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -115,8 +115,10 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 		ret = pm_runtime_get(schan->dev);
 
 		spin_unlock_irq(&schan->chan_lock);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(schan->dev, "%s(): GET = %d\n", __func__, ret);
+			pm_runtime_put(schan->dev);
+		}
 
 		pm_runtime_barrier(schan->dev);
 
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index b406b3f78f46..d76bab3aaac4 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2112,7 +2112,7 @@ static void __exit scmi_driver_exit(void)
 }
 module_exit(scmi_driver_exit);
 
-MODULE_ALIAS("platform: arm-scmi");
+MODULE_ALIAS("platform:arm-scmi");
 MODULE_AUTHOR("Sudeep Holla <sudeep.holla@arm.com>");
 MODULE_DESCRIPTION("ARM SCMI protocol driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 380e4e251399..9c460843442f 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -25,7 +25,7 @@ typedef void __noreturn (*jump_kernel_func)(unsigned int, unsigned long);
 
 static u32 hartid;
 
-static u32 get_boot_hartid_from_fdt(void)
+static int get_boot_hartid_from_fdt(void)
 {
 	const void *fdt;
 	int chosen_node, len;
@@ -33,23 +33,26 @@ static u32 get_boot_hartid_from_fdt(void)
 
 	fdt = get_efi_config_table(DEVICE_TREE_GUID);
 	if (!fdt)
-		return U32_MAX;
+		return -EINVAL;
 
 	chosen_node = fdt_path_offset(fdt, "/chosen");
 	if (chosen_node < 0)
-		return U32_MAX;
+		return -EINVAL;
 
 	prop = fdt_getprop((void *)fdt, chosen_node, "boot-hartid", &len);
 	if (!prop || len != sizeof(u32))
-		return U32_MAX;
+		return -EINVAL;
 
-	return fdt32_to_cpu(*prop);
+	hartid = fdt32_to_cpu(*prop);
+	return 0;
 }
 
 efi_status_t check_platform_features(void)
 {
-	hartid = get_boot_hartid_from_fdt();
-	if (hartid == U32_MAX) {
+	int ret;
+
+	ret = get_boot_hartid_from_fdt();
+	if (ret) {
 		efi_err("/chosen/boot-hartid missing or invalid!\n");
 		return EFI_UNSUPPORTED;
 	}
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index abdc8a6a3963..cae590bd08f2 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -742,6 +742,7 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 {
 	const struct efivar_operations *ops;
 	efi_status_t status;
+	unsigned long varsize;
 
 	if (!__efivars)
 		return -EINVAL;
@@ -764,15 +765,17 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 		return efivar_entry_set_nonblocking(name, vendor, attributes,
 						    size, data);
 
+	varsize = size + ucs2_strsize(name, 1024);
 	if (!block) {
 		if (down_trylock(&efivars_lock))
 			return -EBUSY;
+		status = check_var_size_nonblocking(attributes, varsize);
 	} else {
 		if (down_interruptible(&efivars_lock))
 			return -EINTR;
+		status = check_var_size(attributes, varsize);
 	}
 
-	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
 		up(&efivars_lock);
 		return -ENOSPC;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 0e7dc23f78e7..e73c09d05b6e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -768,11 +768,17 @@ int amdgpu_vm_validate_pt_bos(struct amdgpu_device *adev, struct amdgpu_vm *vm,
  * Check if all VM PDs/PTs are ready for updates
  *
  * Returns:
- * True if eviction list is empty.
+ * True if VM is not evicting.
  */
 bool amdgpu_vm_ready(struct amdgpu_vm *vm)
 {
-	return list_empty(&vm->evicted);
+	bool ret;
+
+	amdgpu_vm_eviction_lock(vm);
+	ret = !vm->evicting;
+	amdgpu_vm_eviction_unlock(vm);
+
+	return ret && list_empty(&vm->evicted);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 94e75199d942..135ea1c422f2 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -4454,7 +4454,9 @@ bool dp_retrieve_lttpr_cap(struct dc_link *link)
 				lttpr_dpcd_data,
 				sizeof(lttpr_dpcd_data));
 		if (status != DC_OK) {
-			dm_error("%s: Read LTTPR caps data failed.\n", __func__);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+			DC_LOG_DP2("%s: Read LTTPR caps data failed.\n", __func__);
+#endif
 			return false;
 		}
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index b55118388d2d..59e1b92f0d27 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -1261,21 +1261,37 @@ static int sienna_cichlid_populate_umd_state_clk(struct smu_context *smu)
 				&dpm_context->dpm_tables.soc_table;
 	struct smu_umd_pstate_table *pstate_table =
 				&smu->pstate_table;
+	struct amdgpu_device *adev = smu->adev;
 
 	pstate_table->gfxclk_pstate.min = gfx_table->min;
 	pstate_table->gfxclk_pstate.peak = gfx_table->max;
-	if (gfx_table->max >= SIENNA_CICHLID_UMD_PSTATE_PROFILING_GFXCLK)
-		pstate_table->gfxclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_GFXCLK;
 
 	pstate_table->uclk_pstate.min = mem_table->min;
 	pstate_table->uclk_pstate.peak = mem_table->max;
-	if (mem_table->max >= SIENNA_CICHLID_UMD_PSTATE_PROFILING_MEMCLK)
-		pstate_table->uclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_MEMCLK;
 
 	pstate_table->socclk_pstate.min = soc_table->min;
 	pstate_table->socclk_pstate.peak = soc_table->max;
-	if (soc_table->max >= SIENNA_CICHLID_UMD_PSTATE_PROFILING_SOCCLK)
+
+	switch (adev->asic_type) {
+	case CHIP_SIENNA_CICHLID:
+	case CHIP_NAVY_FLOUNDER:
+		pstate_table->gfxclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_GFXCLK;
+		pstate_table->uclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_MEMCLK;
 		pstate_table->socclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_SOCCLK;
+		break;
+	case CHIP_DIMGREY_CAVEFISH:
+		pstate_table->gfxclk_pstate.standard = DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_GFXCLK;
+		pstate_table->uclk_pstate.standard = DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_MEMCLK;
+		pstate_table->socclk_pstate.standard = DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_SOCCLK;
+		break;
+	case CHIP_BEIGE_GOBY:
+		pstate_table->gfxclk_pstate.standard = BEIGE_GOBY_UMD_PSTATE_PROFILING_GFXCLK;
+		pstate_table->uclk_pstate.standard = BEIGE_GOBY_UMD_PSTATE_PROFILING_MEMCLK;
+		pstate_table->socclk_pstate.standard = BEIGE_GOBY_UMD_PSTATE_PROFILING_SOCCLK;
+		break;
+	default:
+		break;
+	}
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h
index 38cd0ece24f6..42f705c7a36f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h
@@ -33,6 +33,14 @@ typedef enum {
 #define SIENNA_CICHLID_UMD_PSTATE_PROFILING_SOCCLK    960
 #define SIENNA_CICHLID_UMD_PSTATE_PROFILING_MEMCLK    1000
 
+#define DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_GFXCLK 1950
+#define DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_SOCCLK 960
+#define DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_MEMCLK 676
+
+#define BEIGE_GOBY_UMD_PSTATE_PROFILING_GFXCLK 2200
+#define BEIGE_GOBY_UMD_PSTATE_PROFILING_SOCCLK 960
+#define BEIGE_GOBY_UMD_PSTATE_PROFILING_MEMCLK 1000
+
 extern void sienna_cichlid_set_ppt_funcs(struct smu_context *smu);
 
 #endif
diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 83d06c16d4d7..b7f74c146dee 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -1474,6 +1474,7 @@ static inline void ti_sn_gpio_unregister(void) {}
 
 static void ti_sn65dsi86_runtime_disable(void *data)
 {
+	pm_runtime_dont_use_autosuspend(data);
 	pm_runtime_disable(data);
 }
 
@@ -1533,11 +1534,11 @@ static int ti_sn65dsi86_probe(struct i2c_client *client,
 				     "failed to get reference clock\n");
 
 	pm_runtime_enable(dev);
+	pm_runtime_set_autosuspend_delay(pdata->dev, 500);
+	pm_runtime_use_autosuspend(pdata->dev);
 	ret = devm_add_action_or_reset(dev, ti_sn65dsi86_runtime_disable, dev);
 	if (ret)
 		return ret;
-	pm_runtime_set_autosuspend_delay(pdata->dev, 500);
-	pm_runtime_use_autosuspend(pdata->dev);
 
 	ti_sn65dsi86_debugfs_init(pdata);
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
index 65a3e7fdb2b2..95ff630157b9 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
@@ -133,7 +133,7 @@ static int guc_action_slpc_unset_param(struct intel_guc *guc, u8 id)
 {
 	u32 request[] = {
 		GUC_ACTION_HOST2GUC_PC_SLPC_REQUEST,
-		SLPC_EVENT(SLPC_EVENT_PARAMETER_UNSET, 2),
+		SLPC_EVENT(SLPC_EVENT_PARAMETER_UNSET, 1),
 		id,
 	};
 
diff --git a/drivers/gpu/drm/i915/intel_pch.c b/drivers/gpu/drm/i915/intel_pch.c
index d1d4b97b86f5..287f5a3d0b35 100644
--- a/drivers/gpu/drm/i915/intel_pch.c
+++ b/drivers/gpu/drm/i915/intel_pch.c
@@ -108,6 +108,7 @@ intel_pch_type(const struct drm_i915_private *dev_priv, unsigned short id)
 		/* Comet Lake V PCH is based on KBP, which is SPT compatible */
 		return PCH_SPT;
 	case INTEL_PCH_ICP_DEVICE_ID_TYPE:
+	case INTEL_PCH_ICP2_DEVICE_ID_TYPE:
 		drm_dbg_kms(&dev_priv->drm, "Found Ice Lake PCH\n");
 		drm_WARN_ON(&dev_priv->drm, !IS_ICELAKE(dev_priv));
 		return PCH_ICP;
@@ -123,7 +124,6 @@ intel_pch_type(const struct drm_i915_private *dev_priv, unsigned short id)
 			    !IS_GEN9_BC(dev_priv));
 		return PCH_TGP;
 	case INTEL_PCH_JSP_DEVICE_ID_TYPE:
-	case INTEL_PCH_JSP2_DEVICE_ID_TYPE:
 		drm_dbg_kms(&dev_priv->drm, "Found Jasper Lake PCH\n");
 		drm_WARN_ON(&dev_priv->drm, !IS_JSL_EHL(dev_priv));
 		return PCH_JSP;
diff --git a/drivers/gpu/drm/i915/intel_pch.h b/drivers/gpu/drm/i915/intel_pch.h
index 7c0d83d292dc..994c56fcb199 100644
--- a/drivers/gpu/drm/i915/intel_pch.h
+++ b/drivers/gpu/drm/i915/intel_pch.h
@@ -50,11 +50,11 @@ enum intel_pch {
 #define INTEL_PCH_CMP2_DEVICE_ID_TYPE		0x0680
 #define INTEL_PCH_CMP_V_DEVICE_ID_TYPE		0xA380
 #define INTEL_PCH_ICP_DEVICE_ID_TYPE		0x3480
+#define INTEL_PCH_ICP2_DEVICE_ID_TYPE		0x3880
 #define INTEL_PCH_MCC_DEVICE_ID_TYPE		0x4B00
 #define INTEL_PCH_TGP_DEVICE_ID_TYPE		0xA080
 #define INTEL_PCH_TGP2_DEVICE_ID_TYPE		0x4380
 #define INTEL_PCH_JSP_DEVICE_ID_TYPE		0x4D80
-#define INTEL_PCH_JSP2_DEVICE_ID_TYPE		0x3880
 #define INTEL_PCH_ADP_DEVICE_ID_TYPE		0x7A80
 #define INTEL_PCH_ADP2_DEVICE_ID_TYPE		0x5180
 #define INTEL_PCH_P2X_DEVICE_ID_TYPE		0x7100
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index d3f32ffe299a..2d7fc2c860ea 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -89,6 +89,44 @@ static void amd_stop_all_sensor_v2(struct amd_mp2_dev *privdata)
 	writel(cmd_base.ul, privdata->mmio + AMD_C2P_MSG0);
 }
 
+static void amd_sfh_clear_intr_v2(struct amd_mp2_dev *privdata)
+{
+	if (readl(privdata->mmio + AMD_P2C_MSG(4))) {
+		writel(0, privdata->mmio + AMD_P2C_MSG(4));
+		writel(0xf, privdata->mmio + AMD_P2C_MSG(5));
+	}
+}
+
+static void amd_sfh_clear_intr(struct amd_mp2_dev *privdata)
+{
+	if (privdata->mp2_ops->clear_intr)
+		privdata->mp2_ops->clear_intr(privdata);
+}
+
+static irqreturn_t amd_sfh_irq_handler(int irq, void *data)
+{
+	amd_sfh_clear_intr(data);
+
+	return IRQ_HANDLED;
+}
+
+static int amd_sfh_irq_init_v2(struct amd_mp2_dev *privdata)
+{
+	int rc;
+
+	pci_intx(privdata->pdev, true);
+
+	rc = devm_request_irq(&privdata->pdev->dev, privdata->pdev->irq,
+			      amd_sfh_irq_handler, 0, DRIVER_NAME, privdata);
+	if (rc) {
+		dev_err(&privdata->pdev->dev, "failed to request irq %d err=%d\n",
+			privdata->pdev->irq, rc);
+		return rc;
+	}
+
+	return 0;
+}
+
 void amd_start_sensor(struct amd_mp2_dev *privdata, struct amd_mp2_sensor_info info)
 {
 	union sfh_cmd_param cmd_param;
@@ -193,6 +231,8 @@ static void amd_mp2_pci_remove(void *privdata)
 	struct amd_mp2_dev *mp2 = privdata;
 	amd_sfh_hid_client_deinit(privdata);
 	mp2->mp2_ops->stop_all(mp2);
+	pci_intx(mp2->pdev, false);
+	amd_sfh_clear_intr(mp2);
 }
 
 static const struct amd_mp2_ops amd_sfh_ops_v2 = {
@@ -200,6 +240,8 @@ static const struct amd_mp2_ops amd_sfh_ops_v2 = {
 	.stop = amd_stop_sensor_v2,
 	.stop_all = amd_stop_all_sensor_v2,
 	.response = amd_sfh_wait_response_v2,
+	.clear_intr = amd_sfh_clear_intr_v2,
+	.init_intr = amd_sfh_irq_init_v2,
 };
 
 static const struct amd_mp2_ops amd_sfh_ops = {
@@ -225,6 +267,14 @@ static void mp2_select_ops(struct amd_mp2_dev *privdata)
 	}
 }
 
+static int amd_sfh_irq_init(struct amd_mp2_dev *privdata)
+{
+	if (privdata->mp2_ops->init_intr)
+		return privdata->mp2_ops->init_intr(privdata);
+
+	return 0;
+}
+
 static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct amd_mp2_dev *privdata;
@@ -261,9 +311,20 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 
 	mp2_select_ops(privdata);
 
+	rc = amd_sfh_irq_init(privdata);
+	if (rc) {
+		dev_err(&pdev->dev, "amd_sfh_irq_init failed\n");
+		return rc;
+	}
+
 	rc = amd_sfh_hid_client_init(privdata);
-	if (rc)
+	if (rc) {
+		amd_sfh_clear_intr(privdata);
+		dev_err(&pdev->dev, "amd_sfh_hid_client_init failed\n");
 		return rc;
+	}
+
+	amd_sfh_clear_intr(privdata);
 
 	return devm_add_action_or_reset(&pdev->dev, amd_mp2_pci_remove, privdata);
 }
@@ -290,6 +351,9 @@ static int __maybe_unused amd_mp2_pci_resume(struct device *dev)
 		}
 	}
 
+	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
+	amd_sfh_clear_intr(mp2);
+
 	return 0;
 }
 
@@ -312,6 +376,9 @@ static int __maybe_unused amd_mp2_pci_suspend(struct device *dev)
 		}
 	}
 
+	cancel_delayed_work_sync(&cl_data->work_buffer);
+	amd_sfh_clear_intr(mp2);
+
 	return 0;
 }
 
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index 8a9c544c27ae..97b99861fae2 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -141,5 +141,7 @@ struct amd_mp2_ops {
 	 void (*stop)(struct amd_mp2_dev *privdata, u16 sensor_idx);
 	 void (*stop_all)(struct amd_mp2_dev *privdata);
 	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
+	 void (*clear_intr)(struct amd_mp2_dev *privdata);
+	 int (*init_intr)(struct amd_mp2_dev *privdata);
 };
 #endif
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 7a92e2a04a09..cbd7d318f87c 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -825,7 +825,9 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_F22] = "F22",			[KEY_F23] = "F23",
 	[KEY_F24] = "F24",			[KEY_PLAYCD] = "PlayCD",
 	[KEY_PAUSECD] = "PauseCD",		[KEY_PROG3] = "Prog3",
-	[KEY_PROG4] = "Prog4",			[KEY_SUSPEND] = "Suspend",
+	[KEY_PROG4] = "Prog4",
+	[KEY_ALL_APPLICATIONS] = "AllApplications",
+	[KEY_SUSPEND] = "Suspend",
 	[KEY_CLOSE] = "Close",			[KEY_PLAY] = "Play",
 	[KEY_FASTFORWARD] = "FastForward",	[KEY_BASSBOOST] = "BassBoost",
 	[KEY_PRINT] = "Print",			[KEY_HP] = "HP",
@@ -934,6 +936,7 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_ASSISTANT] = "Assistant",
 	[KEY_KBD_LAYOUT_NEXT] = "KbdLayoutNext",
 	[KEY_EMOJI_PICKER] = "EmojiPicker",
+	[KEY_DICTATE] = "Dictate",
 	[KEY_BRIGHTNESS_MIN] = "BrightnessMin",
 	[KEY_BRIGHTNESS_MAX] = "BrightnessMax",
 	[KEY_BRIGHTNESS_AUTO] = "BrightnessAuto",
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 87fee137ff65..b05d41848cd9 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -994,6 +994,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x0cd: map_key_clear(KEY_PLAYPAUSE);	break;
 		case 0x0cf: map_key_clear(KEY_VOICECOMMAND);	break;
 
+		case 0x0d8: map_key_clear(KEY_DICTATE);		break;
 		case 0x0d9: map_key_clear(KEY_EMOJI_PICKER);	break;
 
 		case 0x0e0: map_abs_clear(ABS_VOLUME);		break;
@@ -1085,6 +1086,8 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 
 		case 0x29d: map_key_clear(KEY_KBD_LAYOUT_NEXT);	break;
 
+		case 0x2a2: map_key_clear(KEY_ALL_APPLICATIONS);	break;
+
 		case 0x2c7: map_key_clear(KEY_KBDINPUTASSIST_PREV);		break;
 		case 0x2c8: map_key_clear(KEY_KBDINPUTASSIST_NEXT);		break;
 		case 0x2c9: map_key_clear(KEY_KBDINPUTASSIST_PREVGROUP);		break;
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index dce392839017..37233bb483a1 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -488,7 +488,7 @@ config I2C_BRCMSTB
 
 config I2C_CADENCE
 	tristate "Cadence I2C Controller"
-	depends on ARCH_ZYNQ || ARM64 || XTENSA
+	depends on ARCH_ZYNQ || ARM64 || XTENSA || COMPILE_TEST
 	help
 	  Say yes here to select Cadence I2C Host Controller. This controller is
 	  e.g. used by Xilinx Zynq.
@@ -680,7 +680,7 @@ config I2C_IMG
 
 config I2C_IMX
 	tristate "IMX I2C interface"
-	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE
+	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE || COMPILE_TEST
 	select I2C_SLAVE
 	help
 	  Say Y here if you want to use the IIC bus controller on
@@ -935,7 +935,7 @@ config I2C_QCOM_GENI
 
 config I2C_QUP
 	tristate "Qualcomm QUP based I2C controller"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Qualcomm SoCs.
diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
index 37443edbf754..ad3b124a2e37 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -23,6 +23,11 @@
 #define BCM2835_I2C_FIFO	0x10
 #define BCM2835_I2C_DIV		0x14
 #define BCM2835_I2C_DEL		0x18
+/*
+ * 16-bit field for the number of SCL cycles to wait after rising SCL
+ * before deciding the slave is not responding. 0 disables the
+ * timeout detection.
+ */
 #define BCM2835_I2C_CLKT	0x1c
 
 #define BCM2835_I2C_C_READ	BIT(0)
@@ -477,6 +482,12 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
 	adap->dev.of_node = pdev->dev.of_node;
 	adap->quirks = of_device_get_match_data(&pdev->dev);
 
+	/*
+	 * Disable the hardware clock stretching timeout. SMBUS
+	 * specifies a limit for how long the device can stretch the
+	 * clock, but core I2C doesn't.
+	 */
+	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_CLKT, 0);
 	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_C, 0);
 
 	ret = i2c_add_adapter(adap);
diff --git a/drivers/input/input.c b/drivers/input/input.c
index ccaeb2426385..c3139bc2aa0d 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2285,6 +2285,12 @@ int input_register_device(struct input_dev *dev)
 	/* KEY_RESERVED is not supposed to be transmitted to userspace. */
 	__clear_bit(KEY_RESERVED, dev->keybit);
 
+	/* Buttonpads should not map BTN_RIGHT and/or BTN_MIDDLE. */
+	if (test_bit(INPUT_PROP_BUTTONPAD, dev->propbit)) {
+		__clear_bit(BTN_RIGHT, dev->keybit);
+		__clear_bit(BTN_MIDDLE, dev->keybit);
+	}
+
 	/* Make sure that bitmasks not mentioned in dev->evbit are clean. */
 	input_cleanse_bitmasks(dev);
 
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 0c607da9ee10..9417ee0b1eff 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -556,7 +556,7 @@ config KEYBOARD_PMIC8XXX
 
 config KEYBOARD_SAMSUNG
 	tristate "Samsung keypad support"
-	depends on HAVE_CLK
+	depends on HAS_IOMEM && HAVE_CLK
 	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the keypad on your Samsung mobile
diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index 47af62c12267..e1758d5ffe42 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -186,55 +186,21 @@ static int elan_get_fwinfo(u16 ic_type, u8 iap_version, u16 *validpage_count,
 	return 0;
 }
 
-static int elan_enable_power(struct elan_tp_data *data)
+static int elan_set_power(struct elan_tp_data *data, bool on)
 {
 	int repeat = ETP_RETRY_COUNT;
 	int error;
 
-	error = regulator_enable(data->vcc);
-	if (error) {
-		dev_err(&data->client->dev,
-			"failed to enable regulator: %d\n", error);
-		return error;
-	}
-
 	do {
-		error = data->ops->power_control(data->client, true);
+		error = data->ops->power_control(data->client, on);
 		if (error >= 0)
 			return 0;
 
 		msleep(30);
 	} while (--repeat > 0);
 
-	dev_err(&data->client->dev, "failed to enable power: %d\n", error);
-	return error;
-}
-
-static int elan_disable_power(struct elan_tp_data *data)
-{
-	int repeat = ETP_RETRY_COUNT;
-	int error;
-
-	do {
-		error = data->ops->power_control(data->client, false);
-		if (!error) {
-			error = regulator_disable(data->vcc);
-			if (error) {
-				dev_err(&data->client->dev,
-					"failed to disable regulator: %d\n",
-					error);
-				/* Attempt to power the chip back up */
-				data->ops->power_control(data->client, true);
-				break;
-			}
-
-			return 0;
-		}
-
-		msleep(30);
-	} while (--repeat > 0);
-
-	dev_err(&data->client->dev, "failed to disable power: %d\n", error);
+	dev_err(&data->client->dev, "failed to set power %s: %d\n",
+		on ? "on" : "off", error);
 	return error;
 }
 
@@ -1399,9 +1365,19 @@ static int __maybe_unused elan_suspend(struct device *dev)
 		/* Enable wake from IRQ */
 		data->irq_wake = (enable_irq_wake(client->irq) == 0);
 	} else {
-		ret = elan_disable_power(data);
+		ret = elan_set_power(data, false);
+		if (ret)
+			goto err;
+
+		ret = regulator_disable(data->vcc);
+		if (ret) {
+			dev_err(dev, "error %d disabling regulator\n", ret);
+			/* Attempt to power the chip back up */
+			elan_set_power(data, true);
+		}
 	}
 
+err:
 	mutex_unlock(&data->sysfs_mutex);
 	return ret;
 }
@@ -1412,12 +1388,18 @@ static int __maybe_unused elan_resume(struct device *dev)
 	struct elan_tp_data *data = i2c_get_clientdata(client);
 	int error;
 
-	if (device_may_wakeup(dev) && data->irq_wake) {
+	if (!device_may_wakeup(dev)) {
+		error = regulator_enable(data->vcc);
+		if (error) {
+			dev_err(dev, "error %d enabling regulator\n", error);
+			goto err;
+		}
+	} else if (data->irq_wake) {
 		disable_irq_wake(client->irq);
 		data->irq_wake = false;
 	}
 
-	error = elan_enable_power(data);
+	error = elan_set_power(data, true);
 	if (error) {
 		dev_err(dev, "power up when resuming failed: %d\n", error);
 		goto err;
diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 416815a525d6..bb95edf74415 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -14,6 +14,7 @@
 extern irqreturn_t amd_iommu_int_thread(int irq, void *data);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_apply_erratum_63(u16 devid);
+extern void amd_iommu_restart_event_logging(struct amd_iommu *iommu);
 extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
 extern int amd_iommu_init_devices(void);
 extern void amd_iommu_uninit_devices(void);
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index ffc89c4fb120..47108ed44fbb 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -110,6 +110,7 @@
 #define PASID_MASK		0x0000ffff
 
 /* MMIO status bits */
+#define MMIO_STATUS_EVT_OVERFLOW_INT_MASK	(1 << 0)
 #define MMIO_STATUS_EVT_INT_MASK	(1 << 1)
 #define MMIO_STATUS_COM_WAIT_INT_MASK	(1 << 2)
 #define MMIO_STATUS_PPR_INT_MASK	(1 << 6)
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index ce952b0afbfd..63146cbf19c7 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -657,6 +657,16 @@ static int __init alloc_command_buffer(struct amd_iommu *iommu)
 	return iommu->cmd_buf ? 0 : -ENOMEM;
 }
 
+/*
+ * This function restarts event logging in case the IOMMU experienced
+ * an event log buffer overflow.
+ */
+void amd_iommu_restart_event_logging(struct amd_iommu *iommu)
+{
+	iommu_feature_disable(iommu, CONTROL_EVT_LOG_EN);
+	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
+}
+
 /*
  * This function resets the command buffer if the IOMMU stopped fetching
  * commands from it.
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 182c93a43efd..1eddf557636d 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -519,12 +519,6 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 
 	dom = container_of(pgtable, struct protection_domain, iop);
 
-	/* Update data structure */
-	amd_iommu_domain_clr_pt_root(dom);
-
-	/* Make changes visible to IOMMUs */
-	amd_iommu_domain_update(dom);
-
 	/* Page-table is not visible to IOMMU anymore, so free it */
 	BUG_ON(pgtable->mode < PAGE_MODE_NONE ||
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
@@ -532,6 +526,12 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 	root = (unsigned long)pgtable->root;
 	freelist = free_sub_pt(root, pgtable->mode, freelist);
 
+	/* Update data structure */
+	amd_iommu_domain_clr_pt_root(dom);
+
+	/* Make changes visible to IOMMUs */
+	amd_iommu_domain_update(dom);
+
 	free_page_list(freelist);
 }
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 461f1844ed1f..a18b549951bb 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -764,7 +764,8 @@ amd_iommu_set_pci_msi_domain(struct device *dev, struct amd_iommu *iommu) { }
 #endif /* !CONFIG_IRQ_REMAP */
 
 #define AMD_IOMMU_INT_MASK	\
-	(MMIO_STATUS_EVT_INT_MASK | \
+	(MMIO_STATUS_EVT_OVERFLOW_INT_MASK | \
+	 MMIO_STATUS_EVT_INT_MASK | \
 	 MMIO_STATUS_PPR_INT_MASK | \
 	 MMIO_STATUS_GALOG_INT_MASK)
 
@@ -774,7 +775,7 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data)
 	u32 status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 
 	while (status & AMD_IOMMU_INT_MASK) {
-		/* Enable EVT and PPR and GA interrupts again */
+		/* Enable interrupt sources again */
 		writel(AMD_IOMMU_INT_MASK,
 			iommu->mmio_base + MMIO_STATUS_OFFSET);
 
@@ -795,6 +796,11 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data)
 		}
 #endif
 
+		if (status & MMIO_STATUS_EVT_OVERFLOW_INT_MASK) {
+			pr_info_ratelimited("IOMMU event log overflow\n");
+			amd_iommu_restart_event_logging(iommu);
+		}
+
 		/*
 		 * Hardware bug: ERBT1312
 		 * When re-enabling interrupt (by writing 1
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index b6a8f3282411..674ee1bc0116 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2773,7 +2773,7 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
 	/* PASID table is mandatory for a PCI device in scalable mode. */
-	if (dev && dev_is_pci(dev) && sm_supported(iommu)) {
+	if (sm_supported(iommu) && !dev_is_real_dma_subdevice(dev)) {
 		ret = intel_pasid_alloc_table(dev);
 		if (ret) {
 			dev_err(dev, "PASID table allocation failed\n");
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index e900e3c46903..2561ce8a2ce8 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -808,8 +808,10 @@ static struct tegra_smmu *tegra_smmu_find(struct device_node *np)
 		return NULL;
 
 	mc = platform_get_drvdata(pdev);
-	if (!mc)
+	if (!mc) {
+		put_device(&pdev->dev);
 		return NULL;
+	}
 
 	return mc->smmu;
 }
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 6382e1937cca..c580acb8b1d3 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -138,6 +138,9 @@ static int com20020pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	ci = (struct com20020_pci_card_info *)id->driver_data;
+	if (!ci)
+		return -EINVAL;
+
 	priv->ci = ci;
 	mm = &ci->misc_map;
 
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index fb07c33ba0c3..78d0a5947ba1 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1787,7 +1787,7 @@ static int es58x_open(struct net_device *netdev)
 	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
 	int ret;
 
-	if (atomic_inc_return(&es58x_dev->opened_channel_cnt) == 1) {
+	if (!es58x_dev->opened_channel_cnt) {
 		ret = es58x_alloc_rx_urbs(es58x_dev);
 		if (ret)
 			return ret;
@@ -1805,12 +1805,13 @@ static int es58x_open(struct net_device *netdev)
 	if (ret)
 		goto free_urbs;
 
+	es58x_dev->opened_channel_cnt++;
 	netif_start_queue(netdev);
 
 	return ret;
 
  free_urbs:
-	if (atomic_dec_and_test(&es58x_dev->opened_channel_cnt))
+	if (!es58x_dev->opened_channel_cnt)
 		es58x_free_urbs(es58x_dev);
 	netdev_err(netdev, "%s: Could not open the network device: %pe\n",
 		   __func__, ERR_PTR(ret));
@@ -1845,7 +1846,8 @@ static int es58x_stop(struct net_device *netdev)
 
 	es58x_flush_pending_tx_msg(netdev);
 
-	if (atomic_dec_and_test(&es58x_dev->opened_channel_cnt))
+	es58x_dev->opened_channel_cnt--;
+	if (!es58x_dev->opened_channel_cnt)
 		es58x_free_urbs(es58x_dev);
 
 	return 0;
@@ -2214,7 +2216,6 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
 	init_usb_anchor(&es58x_dev->tx_urbs_idle);
 	init_usb_anchor(&es58x_dev->tx_urbs_busy);
 	atomic_set(&es58x_dev->tx_urbs_idle_cnt, 0);
-	atomic_set(&es58x_dev->opened_channel_cnt, 0);
 	usb_set_intfdata(intf, es58x_dev);
 
 	es58x_dev->rx_pipe = usb_rcvbulkpipe(es58x_dev->udev,
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index 826a15871573..e5033cb5e695 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -373,8 +373,6 @@ struct es58x_operators {
  *	queue wake/stop logic should prevent this URB from getting
  *	empty. Please refer to es58x_get_tx_urb() for more details.
  * @tx_urbs_idle_cnt: number of urbs in @tx_urbs_idle.
- * @opened_channel_cnt: number of channels opened (c.f. es58x_open()
- *	and es58x_stop()).
  * @ktime_req_ns: kernel timestamp when es58x_set_realtime_diff_ns()
  *	was called.
  * @realtime_diff_ns: difference in nanoseconds between the clocks of
@@ -384,6 +382,10 @@ struct es58x_operators {
  *	in RX branches.
  * @rx_max_packet_size: Maximum length of bulk-in URB.
  * @num_can_ch: Number of CAN channel (i.e. number of elements of @netdev).
+ * @opened_channel_cnt: number of channels opened. Free of race
+ *	conditions because its two users (net_device_ops:ndo_open()
+ *	and net_device_ops:ndo_close()) guarantee that the network
+ *	stack big kernel lock (a.k.a. rtnl_mutex) is being hold.
  * @rx_cmd_buf_len: Length of @rx_cmd_buf.
  * @rx_cmd_buf: The device might split the URB commands in an
  *	arbitrary amount of pieces. This buffer is used to concatenate
@@ -406,7 +408,6 @@ struct es58x_device {
 	struct usb_anchor tx_urbs_busy;
 	struct usb_anchor tx_urbs_idle;
 	atomic_t tx_urbs_idle_cnt;
-	atomic_t opened_channel_cnt;
 
 	u64 ktime_req_ns;
 	s64 realtime_diff_ns;
@@ -415,6 +416,7 @@ struct es58x_device {
 
 	u16 rx_max_packet_size;
 	u8 num_can_ch;
+	u8 opened_channel_cnt;
 
 	u16 rx_cmd_buf_len;
 	union es58x_urb_cmd rx_cmd_buf;
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 4d43aca2ff56..d9e03a7fede9 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -191,8 +191,8 @@ struct gs_can {
 struct gs_usb {
 	struct gs_can *canch[GS_MAX_INTF];
 	struct usb_anchor rx_submitted;
-	atomic_t active_channels;
 	struct usb_device *udev;
+	u8 active_channels;
 };
 
 /* 'allocate' a tx context.
@@ -590,7 +590,7 @@ static int gs_can_open(struct net_device *netdev)
 	if (rc)
 		return rc;
 
-	if (atomic_add_return(1, &parent->active_channels) == 1) {
+	if (!parent->active_channels) {
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
 			u8 *buf;
@@ -691,6 +691,7 @@ static int gs_can_open(struct net_device *netdev)
 
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 
+	parent->active_channels++;
 	if (!(dev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY))
 		netif_start_queue(netdev);
 
@@ -706,7 +707,8 @@ static int gs_can_close(struct net_device *netdev)
 	netif_stop_queue(netdev);
 
 	/* Stop polling */
-	if (atomic_dec_and_test(&parent->active_channels))
+	parent->active_channels--;
+	if (!parent->active_channels)
 		usb_kill_anchored_urbs(&parent->rx_submitted);
 
 	/* Stop sending URBs */
@@ -985,8 +987,6 @@ static int gs_usb_probe(struct usb_interface *intf,
 
 	init_usb_anchor(&dev->rx_submitted);
 
-	atomic_set(&dev->active_channels, 0);
-
 	usb_set_intfdata(intf, dev);
 	dev->udev = interface_to_usbdev(intf);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8a04302018dc..7ab9ab58de65 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -26,7 +26,7 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
 	struct dsa_switch *ds = dev->ds;
 	u8 port_member = 0, cpu_port;
 	const struct dsa_port *dp;
-	int i;
+	int i, j;
 
 	if (!dsa_is_user_port(ds, port))
 		return;
@@ -45,13 +45,33 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
 			continue;
 		if (!dp->bridge_dev || dp->bridge_dev != other_dp->bridge_dev)
 			continue;
+		if (other_p->stp_state != BR_STATE_FORWARDING)
+			continue;
 
-		if (other_p->stp_state == BR_STATE_FORWARDING &&
-		    p->stp_state == BR_STATE_FORWARDING) {
+		if (p->stp_state == BR_STATE_FORWARDING) {
 			val |= BIT(port);
 			port_member |= BIT(i);
 		}
 
+		/* Retain port [i]'s relationship to other ports than [port] */
+		for (j = 0; j < ds->num_ports; j++) {
+			const struct dsa_port *third_dp;
+			struct ksz_port *third_p;
+
+			if (j == i)
+				continue;
+			if (j == port)
+				continue;
+			if (!dsa_is_user_port(ds, j))
+				continue;
+			third_p = &dev->ports[j];
+			if (third_p->stp_state != BR_STATE_FORWARDING)
+				continue;
+			third_dp = dsa_to_port(ds, j);
+			if (third_dp->bridge_dev == dp->bridge_dev)
+				val |= BIT(j);
+		}
+
 		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);
 	}
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index da41eee2f25c..a06003bfa04b 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -3613,6 +3613,8 @@ int t3_prep_adapter(struct adapter *adapter, const struct adapter_info *ai,
 	    MAC_STATS_ACCUM_SECS : (MAC_STATS_ACCUM_SECS * 10);
 	adapter->params.pci.vpd_cap_addr =
 	    pci_find_capability(adapter->pdev, PCI_CAP_ID_VPD);
+	if (!adapter->params.pci.vpd_cap_addr)
+		return -ENODEV;
 	ret = get_vpd_params(adapter, &adapter->params.vpd);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1c6bc69197a5..a8b65c072f64 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -309,7 +309,7 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 	if (adapter->fw_done_rc) {
 		dev_err(dev, "Couldn't map LTB, rc = %d\n",
 			adapter->fw_done_rc);
-		rc = -1;
+		rc = -EIO;
 		goto out;
 	}
 	rc = 0;
@@ -541,13 +541,15 @@ static int init_stats_token(struct ibmvnic_adapter *adapter)
 {
 	struct device *dev = &adapter->vdev->dev;
 	dma_addr_t stok;
+	int rc;
 
 	stok = dma_map_single(dev, &adapter->stats,
 			      sizeof(struct ibmvnic_statistics),
 			      DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, stok)) {
-		dev_err(dev, "Couldn't map stats buffer\n");
-		return -1;
+	rc = dma_mapping_error(dev, stok);
+	if (rc) {
+		dev_err(dev, "Couldn't map stats buffer, rc = %d\n", rc);
+		return rc;
 	}
 
 	adapter->stats_token = stok;
@@ -656,7 +658,7 @@ static int init_rx_pools(struct net_device *netdev)
 	u64 num_pools;
 	u64 pool_size;		/* # of buffers in one pool */
 	u64 buff_size;
-	int i, j;
+	int i, j, rc;
 
 	pool_size = adapter->req_rx_add_entries_per_subcrq;
 	num_pools = adapter->req_rx_queues;
@@ -675,7 +677,7 @@ static int init_rx_pools(struct net_device *netdev)
 				   GFP_KERNEL);
 	if (!adapter->rx_pool) {
 		dev_err(dev, "Failed to allocate rx pools\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	/* Set num_active_rx_pools early. If we fail below after partial
@@ -698,6 +700,7 @@ static int init_rx_pools(struct net_device *netdev)
 					    GFP_KERNEL);
 		if (!rx_pool->free_map) {
 			dev_err(dev, "Couldn't alloc free_map %d\n", i);
+			rc = -ENOMEM;
 			goto out_release;
 		}
 
@@ -706,6 +709,7 @@ static int init_rx_pools(struct net_device *netdev)
 					   GFP_KERNEL);
 		if (!rx_pool->rx_buff) {
 			dev_err(dev, "Couldn't alloc rx buffers\n");
+			rc = -ENOMEM;
 			goto out_release;
 		}
 	}
@@ -719,8 +723,9 @@ static int init_rx_pools(struct net_device *netdev)
 		dev_dbg(dev, "Updating LTB for rx pool %d [%d, %d]\n",
 			i, rx_pool->size, rx_pool->buff_size);
 
-		if (alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
-					 rx_pool->size * rx_pool->buff_size))
+		rc = alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
+					  rx_pool->size * rx_pool->buff_size);
+		if (rc)
 			goto out;
 
 		for (j = 0; j < rx_pool->size; ++j) {
@@ -757,7 +762,7 @@ static int init_rx_pools(struct net_device *netdev)
 	/* We failed to allocate one or more LTBs or map them on the VIOS.
 	 * Hold onto the pools and any LTBs that we did allocate/map.
 	 */
-	return -1;
+	return rc;
 }
 
 static void release_vpd_data(struct ibmvnic_adapter *adapter)
@@ -818,13 +823,13 @@ static int init_one_tx_pool(struct net_device *netdev,
 				   sizeof(struct ibmvnic_tx_buff),
 				   GFP_KERNEL);
 	if (!tx_pool->tx_buff)
-		return -1;
+		return -ENOMEM;
 
 	tx_pool->free_map = kcalloc(pool_size, sizeof(int), GFP_KERNEL);
 	if (!tx_pool->free_map) {
 		kfree(tx_pool->tx_buff);
 		tx_pool->tx_buff = NULL;
-		return -1;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < pool_size; i++)
@@ -915,7 +920,7 @@ static int init_tx_pools(struct net_device *netdev)
 	adapter->tx_pool = kcalloc(num_pools,
 				   sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
 	if (!adapter->tx_pool)
-		return -1;
+		return -ENOMEM;
 
 	adapter->tso_pool = kcalloc(num_pools,
 				    sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
@@ -925,7 +930,7 @@ static int init_tx_pools(struct net_device *netdev)
 	if (!adapter->tso_pool) {
 		kfree(adapter->tx_pool);
 		adapter->tx_pool = NULL;
-		return -1;
+		return -ENOMEM;
 	}
 
 	/* Set num_active_tx_pools early. If we fail below after partial
@@ -1114,7 +1119,7 @@ static int ibmvnic_login(struct net_device *netdev)
 		retry = false;
 		if (retry_count > retries) {
 			netdev_warn(netdev, "Login attempts exceeded\n");
-			return -1;
+			return -EACCES;
 		}
 
 		adapter->init_done_rc = 0;
@@ -1155,25 +1160,26 @@ static int ibmvnic_login(struct net_device *netdev)
 							 timeout)) {
 				netdev_warn(netdev,
 					    "Capabilities query timed out\n");
-				return -1;
+				return -ETIMEDOUT;
 			}
 
 			rc = init_sub_crqs(adapter);
 			if (rc) {
 				netdev_warn(netdev,
 					    "SCRQ initialization failed\n");
-				return -1;
+				return rc;
 			}
 
 			rc = init_sub_crq_irqs(adapter);
 			if (rc) {
 				netdev_warn(netdev,
 					    "SCRQ irq initialization failed\n");
-				return -1;
+				return rc;
 			}
 		} else if (adapter->init_done_rc) {
-			netdev_warn(netdev, "Adapter login failed\n");
-			return -1;
+			netdev_warn(netdev, "Adapter login failed, init_done_rc = %d\n",
+				    adapter->init_done_rc);
+			return -EIO;
 		}
 	} while (retry);
 
@@ -1232,7 +1238,7 @@ static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 		if (!wait_for_completion_timeout(&adapter->init_done,
 						 timeout)) {
 			netdev_err(netdev, "timeout setting link state\n");
-			return -1;
+			return -ETIMEDOUT;
 		}
 
 		if (adapter->init_done_rc == PARTIALSUCCESS) {
@@ -2206,6 +2212,19 @@ static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
 	return "UNKNOWN";
 }
 
+/*
+ * Initialize the init_done completion and return code values. We
+ * can get a transport event just after registering the CRQ and the
+ * tasklet will use this to communicate the transport event. To ensure
+ * we don't miss the notification/error, initialize these _before_
+ * regisering the CRQ.
+ */
+static inline void reinit_init_done(struct ibmvnic_adapter *adapter)
+{
+	reinit_completion(&adapter->init_done);
+	adapter->init_done_rc = 0;
+}
+
 /*
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
@@ -2293,7 +2312,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 				/* If someone else changed the adapter state
 				 * when we dropped the rtnl, fail the reset
 				 */
-				rc = -1;
+				rc = -EAGAIN;
 				goto out;
 			}
 			adapter->state = VNIC_CLOSED;
@@ -2312,6 +2331,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		 */
 		adapter->state = VNIC_PROBED;
 
+		reinit_init_done(adapter);
+
 		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
 			rc = init_crq_queue(adapter);
 		} else if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
@@ -2335,10 +2356,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		}
 
 		rc = ibmvnic_reset_init(adapter, true);
-		if (rc) {
-			rc = IBMVNIC_INIT_FAILED;
+		if (rc)
 			goto out;
-		}
 
 		/* If the adapter was in PROBE or DOWN state prior to the reset,
 		 * exit here.
@@ -2457,7 +2476,8 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	 */
 	adapter->state = VNIC_PROBED;
 
-	reinit_completion(&adapter->init_done);
+	reinit_init_done(adapter);
+
 	rc = init_crq_queue(adapter);
 	if (rc) {
 		netdev_err(adapter->netdev,
@@ -2598,23 +2618,82 @@ static int do_passive_init(struct ibmvnic_adapter *adapter)
 static void __ibmvnic_reset(struct work_struct *work)
 {
 	struct ibmvnic_adapter *adapter;
-	bool saved_state = false;
+	unsigned int timeout = 5000;
 	struct ibmvnic_rwi *tmprwi;
+	bool saved_state = false;
 	struct ibmvnic_rwi *rwi;
 	unsigned long flags;
-	u32 reset_state;
+	struct device *dev;
+	bool need_reset;
 	int num_fails = 0;
+	u32 reset_state;
 	int rc = 0;
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
+		dev = &adapter->vdev->dev;
 
-	if (test_and_set_bit_lock(0, &adapter->resetting)) {
+	/* Wait for ibmvnic_probe() to complete. If probe is taking too long
+	 * or if another reset is in progress, defer work for now. If probe
+	 * eventually fails it will flush and terminate our work.
+	 *
+	 * Three possibilities here:
+	 * 1. Adpater being removed  - just return
+	 * 2. Timed out on probe or another reset in progress - delay the work
+	 * 3. Completed probe - perform any resets in queue
+	 */
+	if (adapter->state == VNIC_PROBING &&
+	    !wait_for_completion_timeout(&adapter->probe_done, timeout)) {
+		dev_err(dev, "Reset thread timed out on probe");
 		queue_delayed_work(system_long_wq,
 				   &adapter->ibmvnic_delayed_reset,
 				   IBMVNIC_RESET_DELAY);
 		return;
 	}
 
+	/* adapter is done with probe (i.e state is never VNIC_PROBING now) */
+	if (adapter->state == VNIC_REMOVING)
+		return;
+
+	/* ->rwi_list is stable now (no one else is removing entries) */
+
+	/* ibmvnic_probe() may have purged the reset queue after we were
+	 * scheduled to process a reset so there maybe no resets to process.
+	 * Before setting the ->resetting bit though, we have to make sure
+	 * that there is infact a reset to process. Otherwise we may race
+	 * with ibmvnic_open() and end up leaving the vnic down:
+	 *
+	 *	__ibmvnic_reset()	    ibmvnic_open()
+	 *	-----------------	    --------------
+	 *
+	 *  set ->resetting bit
+	 *  				find ->resetting bit is set
+	 *  				set ->state to IBMVNIC_OPEN (i.e
+	 *  				assume reset will open device)
+	 *  				return
+	 *  find reset queue empty
+	 *  return
+	 *
+	 *  	Neither performed vnic login/open and vnic stays down
+	 *
+	 * If we hold the lock and conditionally set the bit, either we
+	 * or ibmvnic_open() will complete the open.
+	 */
+	need_reset = false;
+	spin_lock(&adapter->rwi_lock);
+	if (!list_empty(&adapter->rwi_list)) {
+		if (test_and_set_bit_lock(0, &adapter->resetting)) {
+			queue_delayed_work(system_long_wq,
+					   &adapter->ibmvnic_delayed_reset,
+					   IBMVNIC_RESET_DELAY);
+		} else {
+			need_reset = true;
+		}
+	}
+	spin_unlock(&adapter->rwi_lock);
+
+	if (!need_reset)
+		return;
+
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
 		spin_lock_irqsave(&adapter->state_lock, flags);
@@ -2731,12 +2810,23 @@ static void __ibmvnic_delayed_reset(struct work_struct *work)
 	__ibmvnic_reset(&adapter->ibmvnic_reset);
 }
 
+static void flush_reset_queue(struct ibmvnic_adapter *adapter)
+{
+	struct list_head *entry, *tmp_entry;
+
+	if (!list_empty(&adapter->rwi_list)) {
+		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list) {
+			list_del(entry);
+			kfree(list_entry(entry, struct ibmvnic_rwi, list));
+		}
+	}
+}
+
 static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 			 enum ibmvnic_reset_reason reason)
 {
-	struct list_head *entry, *tmp_entry;
-	struct ibmvnic_rwi *rwi, *tmp;
 	struct net_device *netdev = adapter->netdev;
+	struct ibmvnic_rwi *rwi, *tmp;
 	unsigned long flags;
 	int ret;
 
@@ -2755,13 +2845,6 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 		goto err;
 	}
 
-	if (adapter->state == VNIC_PROBING) {
-		netdev_warn(netdev, "Adapter reset during probe\n");
-		adapter->init_done_rc = -EAGAIN;
-		ret = EAGAIN;
-		goto err;
-	}
-
 	list_for_each_entry(tmp, &adapter->rwi_list, list) {
 		if (tmp->reset_reason == reason) {
 			netdev_dbg(netdev, "Skipping matching reset, reason=%s\n",
@@ -2779,10 +2862,9 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	/* if we just received a transport event,
 	 * flush reset queue and process this reset
 	 */
-	if (adapter->force_reset_recovery && !list_empty(&adapter->rwi_list)) {
-		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list)
-			list_del(entry);
-	}
+	if (adapter->force_reset_recovery)
+		flush_reset_queue(adapter);
+
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %s)\n",
@@ -3777,7 +3859,7 @@ static int init_sub_crqs(struct ibmvnic_adapter *adapter)
 
 	allqueues = kcalloc(total_queues, sizeof(*allqueues), GFP_KERNEL);
 	if (!allqueues)
-		return -1;
+		return -ENOMEM;
 
 	for (i = 0; i < total_queues; i++) {
 		allqueues[i] = init_sub_crq_queue(adapter);
@@ -3846,7 +3928,7 @@ static int init_sub_crqs(struct ibmvnic_adapter *adapter)
 	for (i = 0; i < registered_queues; i++)
 		release_sub_crq_queue(adapter, allqueues[i], 1);
 	kfree(allqueues);
-	return -1;
+	return -ENOMEM;
 }
 
 static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
@@ -4225,7 +4307,7 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	if (!adapter->tx_scrq || !adapter->rx_scrq) {
 		netdev_err(adapter->netdev,
 			   "RX or TX queues are not allocated, device login failed\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	release_login_buffer(adapter);
@@ -4345,7 +4427,7 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	kfree(login_buffer);
 	adapter->login_buf = NULL;
 buf_alloc_failed:
-	return -1;
+	return -ENOMEM;
 }
 
 static int send_request_map(struct ibmvnic_adapter *adapter, dma_addr_t addr,
@@ -5317,9 +5399,9 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			}
 
 			if (!completion_done(&adapter->init_done)) {
-				complete(&adapter->init_done);
 				if (!adapter->init_done_rc)
 					adapter->init_done_rc = -EAGAIN;
+				complete(&adapter->init_done);
 			}
 
 			break;
@@ -5342,6 +5424,13 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			adapter->fw_done_rc = -EIO;
 			complete(&adapter->fw_done);
 		}
+
+		/* if we got here during crq-init, retry crq-init */
+		if (!completion_done(&adapter->init_done)) {
+			adapter->init_done_rc = -EAGAIN;
+			complete(&adapter->init_done);
+		}
+
 		if (!completion_done(&adapter->stats_done))
 			complete(&adapter->stats_done);
 		if (test_bit(0, &adapter->resetting))
@@ -5664,10 +5753,6 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	adapter->from_passive_init = false;
 
-	if (reset)
-		reinit_completion(&adapter->init_done);
-
-	adapter->init_done_rc = 0;
 	rc = ibmvnic_send_crq_init(adapter);
 	if (rc) {
 		dev_err(dev, "Send crq init failed with error %d\n", rc);
@@ -5676,18 +5761,20 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	if (!wait_for_completion_timeout(&adapter->init_done, timeout)) {
 		dev_err(dev, "Initialization sequence timed out\n");
-		return -1;
+		return -ETIMEDOUT;
 	}
 
 	if (adapter->init_done_rc) {
 		release_crq_queue(adapter);
+		dev_err(dev, "CRQ-init failed, %d\n", adapter->init_done_rc);
 		return adapter->init_done_rc;
 	}
 
 	if (adapter->from_passive_init) {
 		adapter->state = VNIC_OPEN;
 		adapter->from_passive_init = false;
-		return -1;
+		dev_err(dev, "CRQ-init failed, passive-init\n");
+		return -EINVAL;
 	}
 
 	if (reset &&
@@ -5726,6 +5813,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	struct ibmvnic_adapter *adapter;
 	struct net_device *netdev;
 	unsigned char *mac_addr_p;
+	unsigned long flags;
 	bool init_success;
 	int rc;
 
@@ -5770,6 +5858,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	spin_lock_init(&adapter->rwi_lock);
 	spin_lock_init(&adapter->state_lock);
 	mutex_init(&adapter->fw_lock);
+	init_completion(&adapter->probe_done);
 	init_completion(&adapter->init_done);
 	init_completion(&adapter->fw_done);
 	init_completion(&adapter->reset_done);
@@ -5780,6 +5869,33 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	init_success = false;
 	do {
+		reinit_init_done(adapter);
+
+		/* clear any failovers we got in the previous pass
+		 * since we are reinitializing the CRQ
+		 */
+		adapter->failover_pending = false;
+
+		/* If we had already initialized CRQ, we may have one or
+		 * more resets queued already. Discard those and release
+		 * the CRQ before initializing the CRQ again.
+		 */
+		release_crq_queue(adapter);
+
+		/* Since we are still in PROBING state, __ibmvnic_reset()
+		 * will not access the ->rwi_list and since we released CRQ,
+		 * we won't get _new_ transport events. But there maybe an
+		 * ongoing ibmvnic_reset() call. So serialize access to
+		 * rwi_list. If we win the race, ibvmnic_reset() could add
+		 * a reset after we purged but thats ok - we just may end
+		 * up with an extra reset (i.e similar to having two or more
+		 * resets in the queue at once).
+		 * CHECK.
+		 */
+		spin_lock_irqsave(&adapter->rwi_lock, flags);
+		flush_reset_queue(adapter);
+		spin_unlock_irqrestore(&adapter->rwi_lock, flags);
+
 		rc = init_crq_queue(adapter);
 		if (rc) {
 			dev_err(&dev->dev, "Couldn't initialize crq. rc=%d\n",
@@ -5811,12 +5927,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		goto ibmvnic_dev_file_err;
 
 	netif_carrier_off(netdev);
-	rc = register_netdev(netdev);
-	if (rc) {
-		dev_err(&dev->dev, "failed to register netdev rc=%d\n", rc);
-		goto ibmvnic_register_fail;
-	}
-	dev_info(&dev->dev, "ibmvnic registered\n");
 
 	if (init_success) {
 		adapter->state = VNIC_PROBED;
@@ -5829,6 +5939,16 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	adapter->wait_for_reset = false;
 	adapter->last_reset_time = jiffies;
+
+	rc = register_netdev(netdev);
+	if (rc) {
+		dev_err(&dev->dev, "failed to register netdev rc=%d\n", rc);
+		goto ibmvnic_register_fail;
+	}
+	dev_info(&dev->dev, "ibmvnic registered\n");
+
+	complete(&adapter->probe_done);
+
 	return 0;
 
 ibmvnic_register_fail:
@@ -5843,6 +5963,17 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 ibmvnic_init_fail:
 	release_sub_crqs(adapter, 1);
 	release_crq_queue(adapter);
+
+	/* cleanup worker thread after releasing CRQ so we don't get
+	 * transport events (i.e new work items for the worker thread).
+	 */
+	adapter->state = VNIC_REMOVING;
+	complete(&adapter->probe_done);
+	flush_work(&adapter->ibmvnic_reset);
+	flush_delayed_work(&adapter->ibmvnic_delayed_reset);
+
+	flush_reset_queue(adapter);
+
 	mutex_destroy(&adapter->fw_lock);
 	free_netdev(netdev);
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index b8e42f67d897..549a9b7b1a70 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -933,6 +933,7 @@ struct ibmvnic_adapter {
 
 	struct ibmvnic_tx_pool *tx_pool;
 	struct ibmvnic_tx_pool *tso_pool;
+	struct completion probe_done;
 	struct completion init_done;
 	int init_done_rc;
 
diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index bcf680e83811..13382df2f2ef 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -630,6 +630,7 @@ struct e1000_phy_info {
 	bool disable_polarity_correction;
 	bool is_mdix;
 	bool polarity_correction;
+	bool reset_disable;
 	bool speed_downgraded;
 	bool autoneg_wait_to_complete;
 };
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index c908c84b86d2..d60e2016d03c 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -2050,6 +2050,10 @@ static s32 e1000_check_reset_block_ich8lan(struct e1000_hw *hw)
 	bool blocked = false;
 	int i = 0;
 
+	/* Check the PHY (LCD) reset flag */
+	if (hw->phy.reset_disable)
+		return true;
+
 	while ((blocked = !(er32(FWSM) & E1000_ICH_FWSM_RSPCIPHY)) &&
 	       (i++ < 30))
 		usleep_range(10000, 11000);
@@ -4136,9 +4140,9 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 		return ret_val;
 
 	if (!(data & valid_csum_mask)) {
-		e_dbg("NVM Checksum Invalid\n");
+		e_dbg("NVM Checksum valid bit not set\n");
 
-		if (hw->mac.type < e1000_pch_cnp) {
+		if (hw->mac.type < e1000_pch_tgp) {
 			data |= valid_csum_mask;
 			ret_val = e1000_write_nvm(hw, word, 1, &data);
 			if (ret_val)
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 2504b11c3169..638a3ddd7ada 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -271,6 +271,7 @@
 #define I217_CGFREG_ENABLE_MTA_RESET	0x0002
 #define I217_MEMPWR			PHY_REG(772, 26)
 #define I217_MEMPWR_DISABLE_SMB_RELEASE	0x0010
+#define I217_MEMPWR_MOEM		0x1000
 
 /* Receive Address Initial CRC Calculation */
 #define E1000_PCH_RAICC(_n)	(0x05F50 + ((_n) * 4))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index c063128ed1df..f2db4ff0003f 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6991,8 +6991,21 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct e1000_hw *hw = &adapter->hw;
+	u16 phy_data;
 	int rc;
 
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
+		/* Mask OEM Bits / Gig Disable / Restart AN (772_26[12] = 1) */
+		e1e_rphy(hw, I217_MEMPWR, &phy_data);
+		phy_data |= I217_MEMPWR_MOEM;
+		e1e_wphy(hw, I217_MEMPWR, phy_data);
+
+		/* Disable LCD reset */
+		hw->phy.reset_disable = true;
+	}
+
 	e1000e_flush_lpic(pdev);
 
 	e1000e_pm_freeze(dev);
@@ -7014,6 +7027,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct e1000_hw *hw = &adapter->hw;
+	u16 phy_data;
 	int rc;
 
 	/* Introduce S0ix implementation */
@@ -7024,6 +7039,17 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	if (rc)
 		return rc;
 
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
+		/* Unmask OEM Bits / Gig Disable / Restart AN 772_26[12] = 0 */
+		e1e_rphy(hw, I217_MEMPWR, &phy_data);
+		phy_data &= ~I217_MEMPWR_MOEM;
+		e1e_wphy(hw, I217_MEMPWR, phy_data);
+
+		/* Enable LCD reset */
+		hw->phy.reset_disable = false;
+	}
+
 	return e1000e_pm_thaw(dev);
 }
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 3789269ce741..9a122aea6979 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -188,6 +188,10 @@ enum iavf_state_t {
 	__IAVF_RUNNING,		/* opened, working */
 };
 
+enum iavf_critical_section_t {
+	__IAVF_IN_REMOVE_TASK,	/* device being removed */
+};
+
 #define IAVF_CLOUD_FIELD_OMAC		0x01
 #define IAVF_CLOUD_FIELD_IMAC		0x02
 #define IAVF_CLOUD_FIELD_IVLAN	0x04
@@ -233,7 +237,6 @@ struct iavf_adapter {
 	struct list_head mac_filter_list;
 	struct mutex crit_lock;
 	struct mutex client_lock;
-	struct mutex remove_lock;
 	/* Lock to protect accesses to MAC and VLAN lists */
 	spinlock_t mac_vlan_list_lock;
 	char misc_vector_name[IFNAMSIZ + 9];
@@ -271,6 +274,7 @@ struct iavf_adapter {
 #define IAVF_FLAG_LEGACY_RX			BIT(15)
 #define IAVF_FLAG_REINIT_ITR_NEEDED		BIT(16)
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
+#define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index e4439b095533..138db07bdfa8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -302,8 +302,9 @@ static irqreturn_t iavf_msix_aq(int irq, void *data)
 	rd32(hw, IAVF_VFINT_ICR01);
 	rd32(hw, IAVF_VFINT_ICR0_ENA1);
 
-	/* schedule work on the private workqueue */
-	queue_work(iavf_wq, &adapter->adminq_task);
+	if (adapter->state != __IAVF_REMOVE)
+		/* schedule work on the private workqueue */
+		queue_work(iavf_wq, &adapter->adminq_task);
 
 	return IRQ_HANDLED;
 }
@@ -1072,8 +1073,7 @@ void iavf_down(struct iavf_adapter *adapter)
 		rss->state = IAVF_ADV_RSS_DEL_REQUEST;
 	spin_unlock_bh(&adapter->adv_rss_lock);
 
-	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) &&
-	    adapter->state != __IAVF_RESETTING) {
+	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)) {
 		/* cancel any current operation */
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		/* Schedule operations to close down the HW. Don't wait
@@ -1981,17 +1981,22 @@ static void iavf_watchdog_task(struct work_struct *work)
 	struct iavf_hw *hw = &adapter->hw;
 	u32 reg_val;
 
-	if (!mutex_trylock(&adapter->crit_lock))
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state == __IAVF_REMOVE)
+			return;
+
 		goto restart_watchdog;
+	}
 
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		iavf_change_state(adapter, __IAVF_COMM_FAILED);
 
-	if (adapter->flags & IAVF_FLAG_RESET_NEEDED &&
-	    adapter->state != __IAVF_RESETTING) {
-		iavf_change_state(adapter, __IAVF_RESETTING);
+	if (adapter->flags & IAVF_FLAG_RESET_NEEDED) {
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+		mutex_unlock(&adapter->crit_lock);
+		queue_work(iavf_wq, &adapter->reset_task);
+		return;
 	}
 
 	switch (adapter->state) {
@@ -2014,6 +2019,15 @@ static void iavf_watchdog_task(struct work_struct *work)
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_FAILED:
+		if (test_bit(__IAVF_IN_REMOVE_TASK,
+			     &adapter->crit_section)) {
+			/* Do not update the state and do not reschedule
+			 * watchdog task, iavf_remove should handle this state
+			 * as it can loop forever
+			 */
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
 		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
 			dev_err(&adapter->pdev->dev,
 				"Failed to communicate with PF; waiting before retry\n");
@@ -2030,6 +2044,17 @@ static void iavf_watchdog_task(struct work_struct *work)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ);
 		return;
 	case __IAVF_COMM_FAILED:
+		if (test_bit(__IAVF_IN_REMOVE_TASK,
+			     &adapter->crit_section)) {
+			/* Set state to __IAVF_INIT_FAILED and perform remove
+			 * steps. Remove IAVF_FLAG_PF_COMMS_FAILED so the task
+			 * doesn't bring the state back to __IAVF_COMM_FAILED.
+			 */
+			iavf_change_state(adapter, __IAVF_INIT_FAILED);
+			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
 		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
 			  IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
 		if (reg_val == VIRTCHNL_VFR_VFACTIVE ||
@@ -2099,7 +2124,8 @@ static void iavf_watchdog_task(struct work_struct *work)
 	schedule_delayed_work(&adapter->client_task, msecs_to_jiffies(5));
 	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
-	queue_work(iavf_wq, &adapter->adminq_task);
+	if (adapter->state >= __IAVF_DOWN)
+		queue_work(iavf_wq, &adapter->adminq_task);
 	if (adapter->aq_required)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(20));
@@ -2193,13 +2219,13 @@ static void iavf_reset_task(struct work_struct *work)
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
-	if (mutex_is_locked(&adapter->remove_lock))
-		return;
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state != __IAVF_REMOVE)
+			queue_work(iavf_wq, &adapter->reset_task);
 
-	if (iavf_lock_timeout(&adapter->crit_lock, 200)) {
-		schedule_work(&adapter->reset_task);
 		return;
 	}
+
 	while (!mutex_trylock(&adapter->client_lock))
 		usleep_range(500, 1000);
 	if (CLIENT_ENABLED(adapter)) {
@@ -2254,6 +2280,7 @@ static void iavf_reset_task(struct work_struct *work)
 			reg_val);
 		iavf_disable_vf(adapter);
 		mutex_unlock(&adapter->client_lock);
+		mutex_unlock(&adapter->crit_lock);
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
 
@@ -2262,8 +2289,7 @@ static void iavf_reset_task(struct work_struct *work)
 	 * ndo_open() returning, so we can't assume it means all our open
 	 * tasks have finished, since we're not holding the rtnl_lock here.
 	 */
-	running = ((adapter->state == __IAVF_RUNNING) ||
-		   (adapter->state == __IAVF_RESETTING));
+	running = adapter->state == __IAVF_RUNNING;
 
 	if (running) {
 		netdev->flags &= ~IFF_UP;
@@ -2411,13 +2437,19 @@ static void iavf_adminq_task(struct work_struct *work)
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		goto out;
 
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state == __IAVF_REMOVE)
+			return;
+
+		queue_work(iavf_wq, &adapter->adminq_task);
+		goto out;
+	}
+
 	event.buf_len = IAVF_MAX_AQ_BUF_SIZE;
 	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
 	if (!event.msg_buf)
 		goto out;
 
-	if (iavf_lock_timeout(&adapter->crit_lock, 200))
-		goto freedom;
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
 		v_op = (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
@@ -2433,6 +2465,18 @@ static void iavf_adminq_task(struct work_struct *work)
 	} while (pending);
 	mutex_unlock(&adapter->crit_lock);
 
+	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES)) {
+		if (adapter->netdev_registered ||
+		    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section)) {
+			struct net_device *netdev = adapter->netdev;
+
+			rtnl_lock();
+			netdev_update_features(netdev);
+			rtnl_unlock();
+		}
+
+		adapter->flags &= ~IAVF_FLAG_SETUP_NETDEV_FEATURES;
+	}
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
 	    adapter->state == __IAVF_RESETTING)
@@ -3385,11 +3429,12 @@ static int iavf_close(struct net_device *netdev)
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	int status;
 
-	if (adapter->state <= __IAVF_DOWN_PENDING)
-		return 0;
+	mutex_lock(&adapter->crit_lock);
 
-	while (!mutex_trylock(&adapter->crit_lock))
-		usleep_range(500, 1000);
+	if (adapter->state <= __IAVF_DOWN_PENDING) {
+		mutex_unlock(&adapter->crit_lock);
+		return 0;
+	}
 
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 	if (CLIENT_ENABLED(adapter))
@@ -3436,8 +3481,11 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
 		iavf_notify_client_l2_params(&adapter->vsi);
 		adapter->flags |= IAVF_FLAG_SERVICE_CLIENT_REQUESTED;
 	}
-	adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-	queue_work(iavf_wq, &adapter->reset_task);
+
+	if (netif_running(netdev)) {
+		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
+		queue_work(iavf_wq, &adapter->reset_task);
+	}
 
 	return 0;
 }
@@ -3850,7 +3898,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	mutex_init(&adapter->crit_lock);
 	mutex_init(&adapter->client_lock);
-	mutex_init(&adapter->remove_lock);
 	mutex_init(&hw->aq.asq_mutex);
 	mutex_init(&hw->aq.arq_mutex);
 
@@ -3966,7 +4013,6 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 static void iavf_remove(struct pci_dev *pdev)
 {
 	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
-	enum iavf_state_t prev_state = adapter->last_state;
 	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
@@ -3975,14 +4021,30 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_cloud_filter *cf, *cftmp;
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
-	/* Indicate we are in remove and not to run reset_task */
-	mutex_lock(&adapter->remove_lock);
-	cancel_work_sync(&adapter->reset_task);
+
+	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
+	/* Wait until port initialization is complete.
+	 * There are flows where register/unregister netdev may race.
+	 */
+	while (1) {
+		mutex_lock(&adapter->crit_lock);
+		if (adapter->state == __IAVF_RUNNING ||
+		    adapter->state == __IAVF_DOWN ||
+		    adapter->state == __IAVF_INIT_FAILED) {
+			mutex_unlock(&adapter->crit_lock);
+			break;
+		}
+
+		mutex_unlock(&adapter->crit_lock);
+		usleep_range(500, 1000);
+	}
 	cancel_delayed_work_sync(&adapter->watchdog_task);
-	cancel_delayed_work_sync(&adapter->client_task);
+
 	if (adapter->netdev_registered) {
-		unregister_netdev(netdev);
+		rtnl_lock();
+		unregister_netdevice(netdev);
 		adapter->netdev_registered = false;
+		rtnl_unlock();
 	}
 	if (CLIENT_ALLOWED(adapter)) {
 		err = iavf_lan_del_device(adapter);
@@ -3991,6 +4053,10 @@ static void iavf_remove(struct pci_dev *pdev)
 				 err);
 	}
 
+	mutex_lock(&adapter->crit_lock);
+	dev_info(&adapter->pdev->dev, "Remove device\n");
+	iavf_change_state(adapter, __IAVF_REMOVE);
+
 	iavf_request_reset(adapter);
 	msleep(50);
 	/* If the FW isn't responding, kick it once, but only once. */
@@ -3998,36 +4064,24 @@ static void iavf_remove(struct pci_dev *pdev)
 		iavf_request_reset(adapter);
 		msleep(50);
 	}
-	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 
+	iavf_misc_irq_disable(adapter);
 	/* Shut down all the garbage mashers on the detention level */
-	iavf_change_state(adapter, __IAVF_REMOVE);
+	cancel_work_sync(&adapter->reset_task);
+	cancel_delayed_work_sync(&adapter->watchdog_task);
+	cancel_work_sync(&adapter->adminq_task);
+	cancel_delayed_work_sync(&adapter->client_task);
+
 	adapter->aq_required = 0;
 	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 
 	iavf_free_all_tx_resources(adapter);
 	iavf_free_all_rx_resources(adapter);
-	iavf_misc_irq_disable(adapter);
 	iavf_free_misc_irq(adapter);
 
-	/* In case we enter iavf_remove from erroneous state, free traffic irqs
-	 * here, so as to not cause a kernel crash, when calling
-	 * iavf_reset_interrupt_capability.
-	 */
-	if ((adapter->last_state == __IAVF_RESETTING &&
-	     prev_state != __IAVF_DOWN) ||
-	    (adapter->last_state == __IAVF_RUNNING &&
-	     !(netdev->flags & IFF_UP)))
-		iavf_free_traffic_irqs(adapter);
-
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_q_vectors(adapter);
 
-	cancel_delayed_work_sync(&adapter->watchdog_task);
-
-	cancel_work_sync(&adapter->adminq_task);
-
 	iavf_free_rss(adapter);
 
 	if (hw->aq.asq.count)
@@ -4039,8 +4093,6 @@ static void iavf_remove(struct pci_dev *pdev)
 	mutex_destroy(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 	mutex_destroy(&adapter->crit_lock);
-	mutex_unlock(&adapter->remove_lock);
-	mutex_destroy(&adapter->remove_lock);
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index d60bf7c21200..d3da65d24bd6 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1752,19 +1752,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
 		iavf_process_config(adapter);
-
-		/* unlock crit_lock before acquiring rtnl_lock as other
-		 * processes holding rtnl_lock could be waiting for the same
-		 * crit_lock
-		 */
-		mutex_unlock(&adapter->crit_lock);
-		rtnl_lock();
-		netdev_update_features(adapter->netdev);
-		rtnl_unlock();
-		if (iavf_lock_timeout(&adapter->crit_lock, 10000))
-			dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n",
-				 __FUNCTION__);
-
+		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
 		}
 		break;
 	case VIRTCHNL_OP_ENABLE_QUEUES:
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 5cad31c3c7b0..40dbf4b43234 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -746,8 +746,6 @@ s32 igc_write_phy_reg_gpy(struct igc_hw *hw, u32 offset, u16 data)
 		if (ret_val)
 			return ret_val;
 		ret_val = igc_write_phy_reg_mdic(hw, offset, data);
-		if (ret_val)
-			return ret_val;
 		hw->phy.ops.release(hw);
 	} else {
 		ret_val = igc_write_xmdio_reg(hw, (u16)offset, dev_addr,
@@ -779,8 +777,6 @@ s32 igc_read_phy_reg_gpy(struct igc_hw *hw, u32 offset, u16 *data)
 		if (ret_val)
 			return ret_val;
 		ret_val = igc_read_phy_reg_mdic(hw, offset, data);
-		if (ret_val)
-			return ret_val;
 		hw->phy.ops.release(hw);
 	} else {
 		ret_val = igc_read_xmdio_reg(hw, (u16)offset, dev_addr,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index db2bc58dfcfd..666ff2c07ab9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -390,12 +390,14 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	u32 cmd_type;
 
 	while (budget-- > 0) {
-		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
-		    !netif_carrier_ok(xdp_ring->netdev)) {
+		if (unlikely(!ixgbe_desc_unused(xdp_ring))) {
 			work_done = false;
 			break;
 		}
 
+		if (!netif_carrier_ok(xdp_ring->netdev))
+			break;
+
 		if (!xsk_tx_peek_desc(pool, &desc))
 			break;
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
index 4ce490a25f33..8e56ffa1c4f7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -58,16 +58,6 @@ int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
 	struct sparx5 *sparx5 = port->sparx5;
 	int ret;
 
-	/* Make the port a member of the VLAN */
-	set_bit(port->portno, sparx5->vlan_mask[vid]);
-	ret = sparx5_vlant_set_mask(sparx5, vid);
-	if (ret)
-		return ret;
-
-	/* Default ingress vlan classification */
-	if (pvid)
-		port->pvid = vid;
-
 	/* Untagged egress vlan classification */
 	if (untagged && port->vid != vid) {
 		if (port->vid) {
@@ -79,6 +69,16 @@ int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
 		port->vid = vid;
 	}
 
+	/* Make the port a member of the VLAN */
+	set_bit(port->portno, sparx5->vlan_mask[vid]);
+	ret = sparx5_vlant_set_mask(sparx5, vid);
+	if (ret)
+		return ret;
+
+	/* Default ingress vlan classification */
+	if (pvid)
+		port->pvid = vid;
+
 	sparx5_vlan_port_apply(sparx5, port);
 
 	return 0;
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 32161a56726c..2881f5b2b5f4 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2285,18 +2285,18 @@ static int __init sxgbe_cmdline_opt(char *str)
 	char *opt;
 
 	if (!str || !*str)
-		return -EINVAL;
+		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
 		if (!strncmp(opt, "eee_timer:", 10)) {
 			if (kstrtoint(opt + 10, 0, &eee_timer))
 				goto err;
 		}
 	}
-	return 0;
+	return 1;
 
 err:
 	pr_err("%s: ERROR broken module parameter conversion\n", __func__);
-	return -EINVAL;
+	return 1;
 }
 
 __setup("sxgbeeth=", sxgbe_cmdline_opt);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 873b9e3e5da2..05b5371ca036 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -334,8 +334,8 @@ void stmmac_set_ethtool_ops(struct net_device *netdev);
 int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags);
 void stmmac_ptp_register(struct stmmac_priv *priv);
 void stmmac_ptp_unregister(struct stmmac_priv *priv);
-int stmmac_open(struct net_device *dev);
-int stmmac_release(struct net_device *dev);
+int stmmac_xdp_open(struct net_device *dev);
+void stmmac_xdp_release(struct net_device *dev);
 int stmmac_resume(struct device *dev);
 int stmmac_suspend(struct device *dev);
 int stmmac_dvr_remove(struct device *dev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f4015579e8ad..e2468c3a9a43 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2272,6 +2272,23 @@ static void stmmac_stop_tx_dma(struct stmmac_priv *priv, u32 chan)
 	stmmac_stop_tx(priv, priv->ioaddr, chan);
 }
 
+static void stmmac_enable_all_dma_irq(struct stmmac_priv *priv)
+{
+	u32 rx_channels_count = priv->plat->rx_queues_to_use;
+	u32 tx_channels_count = priv->plat->tx_queues_to_use;
+	u32 dma_csr_ch = max(rx_channels_count, tx_channels_count);
+	u32 chan;
+
+	for (chan = 0; chan < dma_csr_ch; chan++) {
+		struct stmmac_channel *ch = &priv->channel[chan];
+		unsigned long flags;
+
+		spin_lock_irqsave(&ch->lock, flags);
+		stmmac_enable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+		spin_unlock_irqrestore(&ch->lock, flags);
+	}
+}
+
 /**
  * stmmac_start_all_dma - start all RX and TX DMA channels
  * @priv: driver private structure
@@ -2911,8 +2928,10 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
 
 	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
+	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+	}
 
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
@@ -3679,7 +3698,7 @@ static int stmmac_request_irq(struct net_device *dev)
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-int stmmac_open(struct net_device *dev)
+static int stmmac_open(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int mode = priv->plat->phy_interface;
@@ -3768,6 +3787,7 @@ int stmmac_open(struct net_device *dev)
 
 	stmmac_enable_all_queues(priv);
 	netif_tx_start_all_queues(priv->dev);
+	stmmac_enable_all_dma_irq(priv);
 
 	return 0;
 
@@ -3803,7 +3823,7 @@ static void stmmac_fpe_stop_wq(struct stmmac_priv *priv)
  *  Description:
  *  This is the stop entry point of the driver.
  */
-int stmmac_release(struct net_device *dev)
+static int stmmac_release(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
@@ -6473,6 +6493,143 @@ void stmmac_enable_tx_queue(struct stmmac_priv *priv, u32 queue)
 	spin_unlock_irqrestore(&ch->lock, flags);
 }
 
+void stmmac_xdp_release(struct net_device *dev)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	u32 chan;
+
+	/* Disable NAPI process */
+	stmmac_disable_all_queues(priv);
+
+	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
+		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+
+	/* Free the IRQ lines */
+	stmmac_free_irq(dev, REQ_IRQ_ERR_ALL, 0);
+
+	/* Stop TX/RX DMA channels */
+	stmmac_stop_all_dma(priv);
+
+	/* Release and free the Rx/Tx resources */
+	free_dma_desc_resources(priv);
+
+	/* Disable the MAC Rx/Tx */
+	stmmac_mac_set(priv, priv->ioaddr, false);
+
+	/* set trans_start so we don't get spurious
+	 * watchdogs during reset
+	 */
+	netif_trans_update(dev);
+	netif_carrier_off(dev);
+}
+
+int stmmac_xdp_open(struct net_device *dev)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	u32 rx_cnt = priv->plat->rx_queues_to_use;
+	u32 tx_cnt = priv->plat->tx_queues_to_use;
+	u32 dma_csr_ch = max(rx_cnt, tx_cnt);
+	struct stmmac_rx_queue *rx_q;
+	struct stmmac_tx_queue *tx_q;
+	u32 buf_size;
+	bool sph_en;
+	u32 chan;
+	int ret;
+
+	ret = alloc_dma_desc_resources(priv);
+	if (ret < 0) {
+		netdev_err(dev, "%s: DMA descriptors allocation failed\n",
+			   __func__);
+		goto dma_desc_error;
+	}
+
+	ret = init_dma_desc_rings(dev, GFP_KERNEL);
+	if (ret < 0) {
+		netdev_err(dev, "%s: DMA descriptors initialization failed\n",
+			   __func__);
+		goto init_error;
+	}
+
+	/* DMA CSR Channel configuration */
+	for (chan = 0; chan < dma_csr_ch; chan++) {
+		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+	}
+
+	/* Adjust Split header */
+	sph_en = (priv->hw->rx_csum > 0) && priv->sph;
+
+	/* DMA RX Channel Configuration */
+	for (chan = 0; chan < rx_cnt; chan++) {
+		rx_q = &priv->rx_queue[chan];
+
+		stmmac_init_rx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
+				    rx_q->dma_rx_phy, chan);
+
+		rx_q->rx_tail_addr = rx_q->dma_rx_phy +
+				     (rx_q->buf_alloc_num *
+				      sizeof(struct dma_desc));
+		stmmac_set_rx_tail_ptr(priv, priv->ioaddr,
+				       rx_q->rx_tail_addr, chan);
+
+		if (rx_q->xsk_pool && rx_q->buf_alloc_num) {
+			buf_size = xsk_pool_get_rx_frame_size(rx_q->xsk_pool);
+			stmmac_set_dma_bfsize(priv, priv->ioaddr,
+					      buf_size,
+					      rx_q->queue_index);
+		} else {
+			stmmac_set_dma_bfsize(priv, priv->ioaddr,
+					      priv->dma_buf_sz,
+					      rx_q->queue_index);
+		}
+
+		stmmac_enable_sph(priv, priv->ioaddr, sph_en, chan);
+	}
+
+	/* DMA TX Channel Configuration */
+	for (chan = 0; chan < tx_cnt; chan++) {
+		tx_q = &priv->tx_queue[chan];
+
+		stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
+				    tx_q->dma_tx_phy, chan);
+
+		tx_q->tx_tail_addr = tx_q->dma_tx_phy;
+		stmmac_set_tx_tail_ptr(priv, priv->ioaddr,
+				       tx_q->tx_tail_addr, chan);
+
+		hrtimer_init(&tx_q->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		tx_q->txtimer.function = stmmac_tx_timer;
+	}
+
+	/* Enable the MAC Rx/Tx */
+	stmmac_mac_set(priv, priv->ioaddr, true);
+
+	/* Start Rx & Tx DMA Channels */
+	stmmac_start_all_dma(priv);
+
+	ret = stmmac_request_irq(dev);
+	if (ret)
+		goto irq_error;
+
+	/* Enable NAPI process*/
+	stmmac_enable_all_queues(priv);
+	netif_carrier_on(dev);
+	netif_tx_start_all_queues(dev);
+	stmmac_enable_all_dma_irq(priv);
+
+	return 0;
+
+irq_error:
+	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
+		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+
+	stmmac_hw_teardown(dev);
+init_error:
+	free_dma_desc_resources(priv);
+dma_desc_error:
+	return ret;
+}
+
 int stmmac_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
@@ -7337,6 +7494,7 @@ int stmmac_resume(struct device *dev)
 	stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
 
 	stmmac_enable_all_queues(priv);
+	stmmac_enable_all_dma_irq(priv);
 
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
@@ -7353,7 +7511,7 @@ static int __init stmmac_cmdline_opt(char *str)
 	char *opt;
 
 	if (!str || !*str)
-		return -EINVAL;
+		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
 		if (!strncmp(opt, "debug:", 6)) {
 			if (kstrtoint(opt + 6, 0, &debug))
@@ -7384,11 +7542,11 @@ static int __init stmmac_cmdline_opt(char *str)
 				goto err;
 		}
 	}
-	return 0;
+	return 1;
 
 err:
 	pr_err("%s: ERROR broken module parameter conversion", __func__);
-	return -EINVAL;
+	return 1;
 }
 
 __setup("stmmaceth=", stmmac_cmdline_opt);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
index 2a616c6f7cd0..9d4d8c3dad0a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
@@ -119,7 +119,7 @@ int stmmac_xdp_set_prog(struct stmmac_priv *priv, struct bpf_prog *prog,
 
 	need_update = !!priv->xdp_prog != !!prog;
 	if (if_running && need_update)
-		stmmac_release(dev);
+		stmmac_xdp_release(dev);
 
 	old_prog = xchg(&priv->xdp_prog, prog);
 	if (old_prog)
@@ -129,7 +129,7 @@ int stmmac_xdp_set_prog(struct stmmac_priv *priv, struct bpf_prog *prog,
 	priv->sph = priv->sph_cap && !stmmac_xdp_is_enabled(priv);
 
 	if (if_running && need_update)
-		stmmac_open(dev);
+		stmmac_xdp_open(dev);
 
 	return 0;
 }
diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index d037682fb7ad..6782c2cbf542 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -2,7 +2,9 @@ config QCOM_IPA
 	tristate "Qualcomm IPA support"
 	depends on NET && QCOM_SMEM
 	depends on ARCH_QCOM || COMPILE_TEST
+	depends on INTERCONNECT
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
+	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM
 	select QCOM_QMI_HELPERS
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 82bb5ed94c48..c0b8b4aa78f3 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -659,6 +659,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FN990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1071, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 64100e73b5bc..a0d6194f8a52 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
 #include <linux/vmalloc.h>
+#include <linux/err.h>
 #include <linux/ieee80211.h>
 #include <linux/netdevice.h>
 
@@ -1849,7 +1850,6 @@ void iwl_mvm_sta_add_debugfs(struct ieee80211_hw *hw,
 void iwl_mvm_dbgfs_register(struct iwl_mvm *mvm)
 {
 	struct dentry *bcast_dir __maybe_unused;
-	char buf[100];
 
 	spin_lock_init(&mvm->drv_stats_lock);
 
@@ -1930,6 +1930,11 @@ void iwl_mvm_dbgfs_register(struct iwl_mvm *mvm)
 	 * Create a symlink with mac80211. It will be removed when mac80211
 	 * exists (before the opmode exists which removes the target.)
 	 */
-	snprintf(buf, 100, "../../%pd2", mvm->debugfs_dir->d_parent);
-	debugfs_create_symlink("iwlwifi", mvm->hw->wiphy->debugfsdir, buf);
+	if (!IS_ERR(mvm->debugfs_dir)) {
+		char buf[100];
+
+		snprintf(buf, 100, "../../%pd2", mvm->debugfs_dir->d_parent);
+		debugfs_create_symlink("iwlwifi", mvm->hw->wiphy->debugfsdir,
+				       buf);
+	}
 }
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 23219f3747f8..f7cfda9192de 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2336,6 +2336,15 @@ static void hw_scan_work(struct work_struct *work)
 			if (req->ie_len)
 				skb_put_data(probe, req->ie, req->ie_len);
 
+			if (!ieee80211_tx_prepare_skb(hwsim->hw,
+						      hwsim->hw_scan_vif,
+						      probe,
+						      hwsim->tmp_chan->band,
+						      NULL)) {
+				kfree_skb(probe);
+				continue;
+			}
+
 			local_bh_disable();
 			mac80211_hwsim_tx_frame(hwsim->hw, probe,
 						hwsim->tmp_chan);
@@ -3770,6 +3779,10 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 		}
 		txi->flags |= IEEE80211_TX_STAT_ACK;
 	}
+
+	if (hwsim_flags & HWSIM_TX_CTL_NO_ACK)
+		txi->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+
 	ieee80211_tx_status_irqsafe(data2->hw, skb);
 	return 0;
 out:
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index d514d96027a6..039ca902c5bf 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -842,6 +842,28 @@ static int xennet_close(struct net_device *dev)
 	return 0;
 }
 
+static void xennet_destroy_queues(struct netfront_info *info)
+{
+	unsigned int i;
+
+	for (i = 0; i < info->netdev->real_num_tx_queues; i++) {
+		struct netfront_queue *queue = &info->queues[i];
+
+		if (netif_running(info->netdev))
+			napi_disable(&queue->napi);
+		netif_napi_del(&queue->napi);
+	}
+
+	kfree(info->queues);
+	info->queues = NULL;
+}
+
+static void xennet_uninit(struct net_device *dev)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	xennet_destroy_queues(np);
+}
+
 static void xennet_set_rx_rsp_cons(struct netfront_queue *queue, RING_IDX val)
 {
 	unsigned long flags;
@@ -1611,6 +1633,7 @@ static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 }
 
 static const struct net_device_ops xennet_netdev_ops = {
+	.ndo_uninit          = xennet_uninit,
 	.ndo_open            = xennet_open,
 	.ndo_stop            = xennet_close,
 	.ndo_start_xmit      = xennet_start_xmit,
@@ -2103,22 +2126,6 @@ static int write_queue_xenstore_keys(struct netfront_queue *queue,
 	return err;
 }
 
-static void xennet_destroy_queues(struct netfront_info *info)
-{
-	unsigned int i;
-
-	for (i = 0; i < info->netdev->real_num_tx_queues; i++) {
-		struct netfront_queue *queue = &info->queues[i];
-
-		if (netif_running(info->netdev))
-			napi_disable(&queue->napi);
-		netif_napi_del(&queue->napi);
-	}
-
-	kfree(info->queues);
-	info->queues = NULL;
-}
-
 
 
 static int xennet_create_page_pool(struct netfront_queue *queue)
diff --git a/drivers/ntb/hw/intel/ntb_hw_gen4.c b/drivers/ntb/hw/intel/ntb_hw_gen4.c
index fede05151f69..4081fc538ff4 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen4.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen4.c
@@ -168,6 +168,18 @@ static enum ntb_topo gen4_ppd_topo(struct intel_ntb_dev *ndev, u32 ppd)
 	return NTB_TOPO_NONE;
 }
 
+static enum ntb_topo spr_ppd_topo(struct intel_ntb_dev *ndev, u32 ppd)
+{
+	switch (ppd & SPR_PPD_TOPO_MASK) {
+	case SPR_PPD_TOPO_B2B_USD:
+		return NTB_TOPO_B2B_USD;
+	case SPR_PPD_TOPO_B2B_DSD:
+		return NTB_TOPO_B2B_DSD;
+	}
+
+	return NTB_TOPO_NONE;
+}
+
 int gen4_init_dev(struct intel_ntb_dev *ndev)
 {
 	struct pci_dev *pdev = ndev->ntb.pdev;
@@ -183,7 +195,10 @@ int gen4_init_dev(struct intel_ntb_dev *ndev)
 	}
 
 	ppd1 = ioread32(ndev->self_mmio + GEN4_PPD1_OFFSET);
-	ndev->ntb.topo = gen4_ppd_topo(ndev, ppd1);
+	if (pdev_is_ICX(pdev))
+		ndev->ntb.topo = gen4_ppd_topo(ndev, ppd1);
+	else if (pdev_is_SPR(pdev))
+		ndev->ntb.topo = spr_ppd_topo(ndev, ppd1);
 	dev_dbg(&pdev->dev, "ppd %#x topo %s\n", ppd1,
 		ntb_topo_string(ndev->ntb.topo));
 	if (ndev->ntb.topo == NTB_TOPO_NONE)
diff --git a/drivers/ntb/hw/intel/ntb_hw_gen4.h b/drivers/ntb/hw/intel/ntb_hw_gen4.h
index 3fcd3fdce9ed..f91323eaf5ce 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen4.h
+++ b/drivers/ntb/hw/intel/ntb_hw_gen4.h
@@ -49,10 +49,14 @@
 #define GEN4_PPD_CLEAR_TRN		0x0001
 #define GEN4_PPD_LINKTRN		0x0008
 #define GEN4_PPD_CONN_MASK		0x0300
+#define SPR_PPD_CONN_MASK		0x0700
 #define GEN4_PPD_CONN_B2B		0x0200
 #define GEN4_PPD_DEV_MASK		0x1000
 #define GEN4_PPD_DEV_DSD		0x1000
 #define GEN4_PPD_DEV_USD		0x0000
+#define SPR_PPD_DEV_MASK		0x4000
+#define SPR_PPD_DEV_DSD 		0x4000
+#define SPR_PPD_DEV_USD 		0x0000
 #define GEN4_LINK_CTRL_LINK_DISABLE	0x0010
 
 #define GEN4_SLOTSTS			0xb05a
@@ -62,6 +66,10 @@
 #define GEN4_PPD_TOPO_B2B_USD	(GEN4_PPD_CONN_B2B | GEN4_PPD_DEV_USD)
 #define GEN4_PPD_TOPO_B2B_DSD	(GEN4_PPD_CONN_B2B | GEN4_PPD_DEV_DSD)
 
+#define SPR_PPD_TOPO_MASK	(SPR_PPD_CONN_MASK | SPR_PPD_DEV_MASK)
+#define SPR_PPD_TOPO_B2B_USD	(GEN4_PPD_CONN_B2B | SPR_PPD_DEV_USD)
+#define SPR_PPD_TOPO_B2B_DSD	(GEN4_PPD_CONN_B2B | SPR_PPD_DEV_DSD)
+
 #define GEN4_DB_COUNT			32
 #define GEN4_DB_LINK			32
 #define GEN4_DB_LINK_BIT		BIT_ULL(GEN4_DB_LINK)
@@ -112,4 +120,12 @@ static inline int pdev_is_ICX(struct pci_dev *pdev)
 	return 0;
 }
 
+static inline int pdev_is_SPR(struct pci_dev *pdev)
+{
+	if (pdev_is_gen4(pdev) &&
+	    pdev->revision > PCI_DEVICE_REVISION_ICX_MAX)
+		return 1;
+	return 0;
+}
+
 #endif
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 862c84efb718..ce3f9ea41511 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -36,6 +36,13 @@
 #include "../core.h"
 #include "pinctrl-sunxi.h"
 
+/*
+ * These lock classes tell lockdep that GPIO IRQs are in a different
+ * category than their parents, so it won't report false recursion.
+ */
+static struct lock_class_key sunxi_pinctrl_irq_lock_class;
+static struct lock_class_key sunxi_pinctrl_irq_request_class;
+
 static struct irq_chip sunxi_pinctrl_edge_irq_chip;
 static struct irq_chip sunxi_pinctrl_level_irq_chip;
 
@@ -1551,6 +1558,8 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 	for (i = 0; i < (pctl->desc->irq_banks * IRQ_PER_BANK); i++) {
 		int irqno = irq_create_mapping(pctl->domain, i);
 
+		irq_set_lockdep_class(irqno, &sunxi_pinctrl_irq_lock_class,
+				      &sunxi_pinctrl_irq_request_class);
 		irq_set_chip_and_handler(irqno, &sunxi_pinctrl_edge_irq_chip,
 					 handle_edge_irq);
 		irq_set_chip_data(irqno, pctl);
diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 8c74733530e3..11d0f829302b 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/pm_qos.h>
 #include <linux/rtc.h>
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
@@ -79,6 +80,9 @@
 #define PMC_MSG_DELAY_MIN_US		50
 #define RESPONSE_REGISTER_LOOP_MAX	20000
 
+/* QoS request for letting CPUs in idle states, but not the deepest */
+#define AMD_PMC_MAX_IDLE_STATE_LATENCY	3
+
 #define SOC_SUBSYSTEM_IP_MAX	12
 #define DELAY_MIN_US		2000
 #define DELAY_MAX_US		3000
@@ -123,6 +127,7 @@ struct amd_pmc_dev {
 	u8 rev;
 	struct device *dev;
 	struct mutex lock; /* generic mutex lock */
+	struct pm_qos_request amd_pmc_pm_qos_req;
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *dbgfs_dir;
 #endif /* CONFIG_DEBUG_FS */
@@ -459,6 +464,14 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 	rc = rtc_alarm_irq_enable(rtc_device, 0);
 	dev_dbg(pdev->dev, "wakeup timer programmed for %lld seconds\n", duration);
 
+	/*
+	 * Prevent CPUs from getting into deep idle states while sending OS_HINT
+	 * which is otherwise generally safe to send when at least one of the CPUs
+	 * is not in deep idle states.
+	 */
+	cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req, AMD_PMC_MAX_IDLE_STATE_LATENCY);
+	wake_up_all_idle_cpus();
+
 	return rc;
 }
 
@@ -476,17 +489,24 @@ static int __maybe_unused amd_pmc_suspend(struct device *dev)
 	/* Activate CZN specific RTC functionality */
 	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
 		rc = amd_pmc_verify_czn_rtc(pdev, &arg);
-		if (rc < 0)
-			return rc;
+		if (rc)
+			goto fail;
 	}
 
 	/* Dump the IdleMask before we send hint to SMU */
 	amd_pmc_idlemask_read(pdev, dev, NULL);
 	msg = amd_pmc_get_os_hint(pdev);
 	rc = amd_pmc_send_cmd(pdev, arg, NULL, msg, 0);
-	if (rc)
+	if (rc) {
 		dev_err(pdev->dev, "suspend failed\n");
+		goto fail;
+	}
 
+	return 0;
+fail:
+	if (pdev->cpu_id == AMD_CPU_ID_CZN)
+		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
+						PM_QOS_DEFAULT_VALUE);
 	return rc;
 }
 
@@ -507,7 +527,12 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
 	/* Dump the IdleMask to see the blockers */
 	amd_pmc_idlemask_read(pdev, dev, NULL);
 
-	return 0;
+	/* Restore the QoS request back to defaults if it was set */
+	if (pdev->cpu_id == AMD_CPU_ID_CZN)
+		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
+						PM_QOS_DEFAULT_VALUE);
+
+	return rc;
 }
 
 static const struct dev_pm_ops amd_pmc_pm_ops = {
@@ -597,6 +622,7 @@ static int amd_pmc_probe(struct platform_device *pdev)
 	amd_pmc_get_smu_version(dev);
 	platform_set_drvdata(pdev, dev);
 	amd_pmc_dbgfs_register(dev);
+	cpu_latency_qos_add_request(&dev->amd_pmc_pm_qos_req, PM_QOS_DEFAULT_VALUE);
 	return 0;
 }
 
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 0f1b5a7d2a89..17ad5f0d13b2 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -607,7 +607,7 @@ ptp_ocp_settime(struct ptp_clock_info *ptp_info, const struct timespec64 *ts)
 }
 
 static void
-__ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
+__ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u32 adj_val)
 {
 	u32 select, ctrl;
 
@@ -615,7 +615,7 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
 	iowrite32(OCP_SELECT_CLK_REG, &bp->reg->select);
 
 	iowrite32(adj_val, &bp->reg->offset_ns);
-	iowrite32(adj_val & 0x7f, &bp->reg->offset_window_ns);
+	iowrite32(NSEC_PER_SEC, &bp->reg->offset_window_ns);
 
 	ctrl = OCP_CTRL_ADJUST_OFFSET | OCP_CTRL_ENABLE;
 	iowrite32(ctrl, &bp->reg->ctrl);
@@ -624,6 +624,22 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
 	iowrite32(select >> 16, &bp->reg->select);
 }
 
+static void
+ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
+{
+	struct timespec64 ts;
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
+	if (likely(!err)) {
+		timespec64_add_ns(&ts, delta_ns);
+		__ptp_ocp_settime_locked(bp, &ts);
+	}
+	spin_unlock_irqrestore(&bp->lock, flags);
+}
+
 static int
 ptp_ocp_adjtime(struct ptp_clock_info *ptp_info, s64 delta_ns)
 {
@@ -631,6 +647,11 @@ ptp_ocp_adjtime(struct ptp_clock_info *ptp_info, s64 delta_ns)
 	unsigned long flags;
 	u32 adj_ns, sign;
 
+	if (delta_ns > NSEC_PER_SEC || -delta_ns > NSEC_PER_SEC) {
+		ptp_ocp_adjtime_coarse(bp, delta_ns);
+		return 0;
+	}
+
 	sign = delta_ns < 0 ? BIT(31) : 0;
 	adj_ns = sign ? -delta_ns : delta_ns;
 
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 86aa4141efa9..d2553970a67b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -6014,9 +6014,8 @@ core_initcall(regulator_init);
 static int regulator_late_cleanup(struct device *dev, void *data)
 {
 	struct regulator_dev *rdev = dev_to_rdev(dev);
-	const struct regulator_ops *ops = rdev->desc->ops;
 	struct regulation_constraints *c = rdev->constraints;
-	int enabled, ret;
+	int ret;
 
 	if (c && c->always_on)
 		return 0;
@@ -6029,14 +6028,8 @@ static int regulator_late_cleanup(struct device *dev, void *data)
 	if (rdev->use_count)
 		goto unlock;
 
-	/* If we can't read the status assume it's always on. */
-	if (ops->is_enabled)
-		enabled = ops->is_enabled(rdev);
-	else
-		enabled = 1;
-
-	/* But if reading the status failed, assume that it's off. */
-	if (enabled <= 0)
+	/* If reading the status failed, assume that it's off. */
+	if (_regulator_is_enabled(rdev) <= 0)
 		goto unlock;
 
 	if (have_full_constraints()) {
diff --git a/drivers/soc/fsl/guts.c b/drivers/soc/fsl/guts.c
index 072473a16f4d..5ed2fc1c53a0 100644
--- a/drivers/soc/fsl/guts.c
+++ b/drivers/soc/fsl/guts.c
@@ -28,7 +28,6 @@ struct fsl_soc_die_attr {
 static struct guts *guts;
 static struct soc_device_attribute soc_dev_attr;
 static struct soc_device *soc_dev;
-static struct device_node *root;
 
 
 /* SoC die attribute definition for QorIQ platform */
@@ -138,7 +137,7 @@ static u32 fsl_guts_get_svr(void)
 
 static int fsl_guts_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct device_node *root, *np = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
 	const struct fsl_soc_die_attr *soc_die;
 	const char *machine;
@@ -159,8 +158,14 @@ static int fsl_guts_probe(struct platform_device *pdev)
 	root = of_find_node_by_path("/");
 	if (of_property_read_string(root, "model", &machine))
 		of_property_read_string_index(root, "compatible", 0, &machine);
-	if (machine)
-		soc_dev_attr.machine = machine;
+	if (machine) {
+		soc_dev_attr.machine = devm_kstrdup(dev, machine, GFP_KERNEL);
+		if (!soc_dev_attr.machine) {
+			of_node_put(root);
+			return -ENOMEM;
+		}
+	}
+	of_node_put(root);
 
 	svr = fsl_guts_get_svr();
 	soc_die = fsl_soc_die_match(svr, fsl_soc_die);
@@ -195,7 +200,6 @@ static int fsl_guts_probe(struct platform_device *pdev)
 static int fsl_guts_remove(struct platform_device *dev)
 {
 	soc_device_unregister(soc_dev);
-	of_node_put(root);
 	return 0;
 }
 
diff --git a/drivers/soc/fsl/qe/qe_io.c b/drivers/soc/fsl/qe/qe_io.c
index e277c827bdf3..a5e2d0e5ab51 100644
--- a/drivers/soc/fsl/qe/qe_io.c
+++ b/drivers/soc/fsl/qe/qe_io.c
@@ -35,6 +35,8 @@ int par_io_init(struct device_node *np)
 	if (ret)
 		return ret;
 	par_io = ioremap(res.start, resource_size(&res));
+	if (!par_io)
+		return -ENOMEM;
 
 	if (!of_property_read_u32(np, "num-ports", &num_ports))
 		num_par_io_ports = num_ports;
diff --git a/drivers/soc/imx/gpcv2.c b/drivers/soc/imx/gpcv2.c
index 8176380b02e6..4415f07e1fa9 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -382,7 +382,8 @@ static int imx_pgc_power_down(struct generic_pm_domain *genpd)
 	return 0;
 
 out_clk_disable:
-	clk_bulk_disable_unprepare(domain->num_clks, domain->clks);
+	if (!domain->keep_clocks)
+		clk_bulk_disable_unprepare(domain->num_clks, domain->clks);
 
 	return ret;
 }
diff --git a/drivers/thermal/thermal_netlink.c b/drivers/thermal/thermal_netlink.c
index a16dd4d5d710..73e68cce292e 100644
--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -419,11 +419,12 @@ static int thermal_genl_cmd_tz_get_trip(struct param *p)
 	for (i = 0; i < tz->trips; i++) {
 
 		enum thermal_trip_type type;
-		int temp, hyst;
+		int temp, hyst = 0;
 
 		tz->ops->get_trip_type(tz, i, &type);
 		tz->ops->get_trip_temp(tz, i, &temp);
-		tz->ops->get_trip_hyst(tz, i, &hyst);
+		if (tz->ops->get_trip_hyst)
+			tz->ops->get_trip_hyst(tz, i, &hyst);
 
 		if (nla_put_u32(msg, THERMAL_GENL_ATTR_TZ_TRIP_ID, i) ||
 		    nla_put_u32(msg, THERMAL_GENL_ATTR_TZ_TRIP_TYPE, type) ||
diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 2d3fbcbfaf10..93c2a5c95654 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -520,10 +520,22 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	struct circ_buf *xmit = &port->state->xmit;
+	u32 isr;
+	int ret;
 
 	if (port->x_char) {
 		if (stm32_port->tx_dma_busy)
 			stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
+
+		/* Check that TDR is empty before filling FIFO */
+		ret =
+		readl_relaxed_poll_timeout_atomic(port->membase + ofs->isr,
+						  isr,
+						  (isr & USART_SR_TXE),
+						  10, 1000);
+		if (ret)
+			dev_warn(port->dev, "1 character may be erased\n");
+
 		writel_relaxed(port->x_char, port->membase + ofs->tdr);
 		port->x_char = 0;
 		port->icount.tx++;
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 3b58f4fc0a80..25c8809e0a38 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1826,8 +1826,9 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	spin_lock_irq (&dev->lock);
 	value = -EINVAL;
 	if (dev->buf) {
+		spin_unlock_irq(&dev->lock);
 		kfree(kbuf);
-		goto fail;
+		return value;
 	}
 	dev->buf = kbuf;
 
@@ -1874,8 +1875,8 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 
 	value = usb_gadget_probe_driver(&gadgetfs_driver);
 	if (value != 0) {
-		kfree (dev->buf);
-		dev->buf = NULL;
+		spin_lock_irq(&dev->lock);
+		goto fail;
 	} else {
 		/* at this point "good" hardware has for the first time
 		 * let the USB the host see us.  alternatively, if users
@@ -1892,6 +1893,9 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	return value;
 
 fail:
+	dev->config = NULL;
+	dev->hs_config = NULL;
+	dev->dev = NULL;
 	spin_unlock_irq (&dev->lock);
 	pr_debug ("%s: %s fail %zd, %p\n", shortname, __func__, value, dev);
 	kfree (dev->buf);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f8c7f26f1fbb..d19762dc90fe 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1135,14 +1135,25 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			 * is then page aligned.
 			 */
 			load_bias = ELF_PAGESTART(load_bias - vaddr);
-		}
 
-		/*
-		 * Calculate the entire size of the ELF mapping (total_size).
-		 * (Note that load_addr_set is set to true later once the
-		 * initial mapping is performed.)
-		 */
-		if (!load_addr_set) {
+			/*
+			 * Calculate the entire size of the ELF mapping
+			 * (total_size), used for the initial mapping,
+			 * due to load_addr_set which is set to true later
+			 * once the initial mapping is performed.
+			 *
+			 * Note that this is only sensible when the LOAD
+			 * segments are contiguous (or overlapping). If
+			 * used for LOADs that are far apart, this would
+			 * cause the holes between LOADs to be mapped,
+			 * running the risk of having the mapping fail,
+			 * as it would be larger than the ELF file itself.
+			 *
+			 * As a result, only ET_DYN does this, since
+			 * some ET_EXEC (e.g. ia64) may have large virtual
+			 * memory holes between LOADs.
+			 *
+			 */
 			total_size = total_mapping_size(elf_phdata,
 							elf_ex->e_phnum);
 			if (!total_size) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 269094176b8b..fd77eca085b4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -601,6 +601,9 @@ enum {
 	/* Indicate whether there are any tree modification log users */
 	BTRFS_FS_TREE_MOD_LOG_USERS,
 
+	/* Indicate we have half completed snapshot deletions pending. */
+	BTRFS_FS_UNFINISHED_DROPS,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
@@ -1110,8 +1113,15 @@ enum {
 	BTRFS_ROOT_HAS_LOG_TREE,
 	/* Qgroup flushing is in progress */
 	BTRFS_ROOT_QGROUP_FLUSHING,
+	/* This root has a drop operation that was started previously. */
+	BTRFS_ROOT_UNFINISHED_DROP,
 };
 
+static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
+{
+	clear_and_wake_up_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
+}
+
 /*
  * Record swapped tree blocks of a subvolume tree for delayed subtree trace
  * code. For detail check comment in fs/btrfs/qgroup.c.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5f0a879c1043..15ffb237a489 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3665,6 +3665,10 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	set_bit(BTRFS_FS_OPEN, &fs_info->flags);
 
+	/* Kick the cleaner thread so it'll start deleting snapshots. */
+	if (test_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags))
+		wake_up_process(fs_info->cleaner_kthread);
+
 clear_oneshot:
 	btrfs_clear_oneshot_options(fs_info);
 	return 0;
@@ -4348,6 +4352,12 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 */
 	kthread_park(fs_info->cleaner_kthread);
 
+	/*
+	 * If we had UNFINISHED_DROPS we could still be processing them, so
+	 * clear that bit and wake up relocation so it can stop.
+	 */
+	btrfs_wake_unfinished_drop(fs_info);
+
 	/* wait for the qgroup rescan worker to stop */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7b4ee1b2d5d8..852348189ecb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5604,6 +5604,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref, int for_reloc)
 	int ret;
 	int level;
 	bool root_dropped = false;
+	bool unfinished_drop = false;
 
 	btrfs_debug(fs_info, "Drop subvolume %llu", root->root_key.objectid);
 
@@ -5646,6 +5647,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref, int for_reloc)
 	 * already dropped.
 	 */
 	set_bit(BTRFS_ROOT_DELETING, &root->state);
+	unfinished_drop = test_bit(BTRFS_ROOT_UNFINISHED_DROP, &root->state);
+
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		level = btrfs_header_level(root->node);
 		path->nodes[level] = btrfs_lock_root_node(root);
@@ -5820,6 +5823,13 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref, int for_reloc)
 	kfree(wc);
 	btrfs_free_path(path);
 out:
+	/*
+	 * We were an unfinished drop root, check to see if there are any
+	 * pending, and if not clear and wake up any waiters.
+	 */
+	if (!err && unfinished_drop)
+		btrfs_maybe_wake_unfinished_drop(fs_info);
+
 	/*
 	 * So if we need to stop dropping the snapshot for whatever reason we
 	 * need to make sure to add it back to the dead root list so that we
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9234d96a7fd5..5512d7028091 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -6865,14 +6865,24 @@ static void assert_eb_page_uptodate(const struct extent_buffer *eb,
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 
+	/*
+	 * If we are using the commit root we could potentially clear a page
+	 * Uptodate while we're using the extent buffer that we've previously
+	 * looked up.  We don't want to complain in this case, as the page was
+	 * valid before, we just didn't write it out.  Instead we want to catch
+	 * the case where we didn't actually read the block properly, which
+	 * would have !PageUptodate && !PageError, as we clear PageError before
+	 * reading.
+	 */
 	if (fs_info->sectorsize < PAGE_SIZE) {
-		bool uptodate;
+		bool uptodate, error;
 
 		uptodate = btrfs_subpage_test_uptodate(fs_info, page,
 						       eb->start, eb->len);
-		WARN_ON(!uptodate);
+		error = btrfs_subpage_test_error(fs_info, page, eb->start, eb->len);
+		WARN_ON(!uptodate && !error);
 	} else {
-		WARN_ON(!PageUptodate(page));
+		WARN_ON(!PageUptodate(page) && !PageError(page));
 	}
 }
 
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 5a36add21305..c28ceddefae4 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -261,6 +261,7 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 			em->mod_len = (em->mod_len + em->mod_start) - merge->mod_start;
 			em->mod_start = merge->mod_start;
 			em->generation = max(em->generation, merge->generation);
+			set_bit(EXTENT_FLAG_MERGED, &em->flags);
 
 			rb_erase_cached(&merge->rb_node, &tree->map);
 			RB_CLEAR_NODE(&merge->rb_node);
@@ -278,6 +279,7 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 		RB_CLEAR_NODE(&merge->rb_node);
 		em->mod_len = (merge->mod_start + merge->mod_len) - em->mod_start;
 		em->generation = max(em->generation, merge->generation);
+		set_bit(EXTENT_FLAG_MERGED, &em->flags);
 		free_extent_map(merge);
 	}
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 8e217337dff9..d2fa32ffe304 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -25,6 +25,8 @@ enum {
 	EXTENT_FLAG_FILLING,
 	/* filesystem extent mapping type */
 	EXTENT_FLAG_FS_MAPPING,
+	/* This em is merged from two or more physically adjacent ems */
+	EXTENT_FLAG_MERGED,
 };
 
 struct extent_map {
@@ -40,6 +42,12 @@ struct extent_map {
 	u64 ram_bytes;
 	u64 block_start;
 	u64 block_len;
+
+	/*
+	 * Generation of the extent map, for merged em it's the highest
+	 * generation of all merged ems.
+	 * For non-merged extents, it's from btrfs_file_extent_item::generation.
+	 */
 	u64 generation;
 	unsigned long flags;
 	/* Used for chunk mappings, flag EXTENT_FLAG_FS_MAPPING must be set */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3be5735372ee..cc957cce23a1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -61,8 +61,6 @@ struct btrfs_iget_args {
 };
 
 struct btrfs_dio_data {
-	u64 reserve;
-	loff_t length;
 	ssize_t submitted;
 	struct extent_changeset *data_reserved;
 };
@@ -7773,6 +7771,10 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_map *em = *map;
+	int type;
+	u64 block_start, orig_start, orig_block_len, ram_bytes;
+	bool can_nocow = false;
+	bool space_reserved = false;
 	int ret = 0;
 
 	/*
@@ -7787,9 +7789,6 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
 	    ((BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
 	     em->block_start != EXTENT_MAP_HOLE)) {
-		int type;
-		u64 block_start, orig_start, orig_block_len, ram_bytes;
-
 		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
 			type = BTRFS_ORDERED_PREALLOC;
 		else
@@ -7799,53 +7798,92 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 
 		if (can_nocow_extent(inode, start, &len, &orig_start,
 				     &orig_block_len, &ram_bytes, false) == 1 &&
-		    btrfs_inc_nocow_writers(fs_info, block_start)) {
-			struct extent_map *em2;
+		    btrfs_inc_nocow_writers(fs_info, block_start))
+			can_nocow = true;
+	}
+
+	if (can_nocow) {
+		struct extent_map *em2;
 
-			em2 = btrfs_create_dio_extent(BTRFS_I(inode), start, len,
-						      orig_start, block_start,
-						      len, orig_block_len,
-						      ram_bytes, type);
+		/* We can NOCOW, so only need to reserve metadata space. */
+		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), len);
+		if (ret < 0) {
+			/* Our caller expects us to free the input extent map. */
+			free_extent_map(em);
+			*map = NULL;
 			btrfs_dec_nocow_writers(fs_info, block_start);
-			if (type == BTRFS_ORDERED_PREALLOC) {
-				free_extent_map(em);
-				*map = em = em2;
-			}
+			goto out;
+		}
+		space_reserved = true;
 
-			if (em2 && IS_ERR(em2)) {
-				ret = PTR_ERR(em2);
-				goto out;
-			}
-			/*
-			 * For inode marked NODATACOW or extent marked PREALLOC,
-			 * use the existing or preallocated extent, so does not
-			 * need to adjust btrfs_space_info's bytes_may_use.
-			 */
-			btrfs_free_reserved_data_space_noquota(fs_info, len);
-			goto skip_cow;
+		em2 = btrfs_create_dio_extent(BTRFS_I(inode), start, len,
+					      orig_start, block_start,
+					      len, orig_block_len,
+					      ram_bytes, type);
+		btrfs_dec_nocow_writers(fs_info, block_start);
+		if (type == BTRFS_ORDERED_PREALLOC) {
+			free_extent_map(em);
+			*map = em = em2;
 		}
-	}
 
-	/* this will cow the extent */
-	free_extent_map(em);
-	*map = em = btrfs_new_extent_direct(BTRFS_I(inode), start, len);
-	if (IS_ERR(em)) {
-		ret = PTR_ERR(em);
-		goto out;
+		if (IS_ERR(em2)) {
+			ret = PTR_ERR(em2);
+			goto out;
+		}
+	} else {
+		const u64 prev_len = len;
+
+		/* Our caller expects us to free the input extent map. */
+		free_extent_map(em);
+		*map = NULL;
+
+		/* We have to COW, so need to reserve metadata and data space. */
+		ret = btrfs_delalloc_reserve_space(BTRFS_I(inode),
+						   &dio_data->data_reserved,
+						   start, len);
+		if (ret < 0)
+			goto out;
+		space_reserved = true;
+
+		em = btrfs_new_extent_direct(BTRFS_I(inode), start, len);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out;
+		}
+		*map = em;
+		len = min(len, em->len - (start - em->start));
+		if (len < prev_len)
+			btrfs_delalloc_release_space(BTRFS_I(inode),
+						     dio_data->data_reserved,
+						     start + len, prev_len - len,
+						     true);
 	}
 
-	len = min(len, em->len - (start - em->start));
+	/*
+	 * We have created our ordered extent, so we can now release our reservation
+	 * for an outstanding extent.
+	 */
+	btrfs_delalloc_release_extents(BTRFS_I(inode), len);
 
-skip_cow:
 	/*
 	 * Need to update the i_size under the extent lock so buffered
 	 * readers will get the updated i_size when we unlock.
 	 */
 	if (start + len > i_size_read(inode))
 		i_size_write(inode, start + len);
-
-	dio_data->reserve -= len;
 out:
+	if (ret && space_reserved) {
+		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
+		if (can_nocow) {
+			btrfs_delalloc_release_metadata(BTRFS_I(inode), len, true);
+		} else {
+			btrfs_delalloc_release_space(BTRFS_I(inode),
+						     dio_data->data_reserved,
+						     start, len, true);
+			extent_changeset_free(dio_data->data_reserved);
+			dio_data->data_reserved = NULL;
+		}
+	}
 	return ret;
 }
 
@@ -7887,18 +7925,6 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 	if (!dio_data)
 		return -ENOMEM;
 
-	dio_data->length = length;
-	if (write) {
-		dio_data->reserve = round_up(length, fs_info->sectorsize);
-		ret = btrfs_delalloc_reserve_space(BTRFS_I(inode),
-				&dio_data->data_reserved,
-				start, dio_data->reserve);
-		if (ret) {
-			extent_changeset_free(dio_data->data_reserved);
-			kfree(dio_data);
-			return ret;
-		}
-	}
 	iomap->private = dio_data;
 
 
@@ -7939,6 +7965,34 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 	}
 
 	len = min(len, em->len - (start - em->start));
+
+	/*
+	 * If we have a NOWAIT request and the range contains multiple extents
+	 * (or a mix of extents and holes), then we return -EAGAIN to make the
+	 * caller fallback to a context where it can do a blocking (without
+	 * NOWAIT) request. This way we avoid doing partial IO and returning
+	 * success to the caller, which is not optimal for writes and for reads
+	 * it can result in unexpected behaviour for an application.
+	 *
+	 * When doing a read, because we use IOMAP_DIO_PARTIAL when calling
+	 * iomap_dio_rw(), we can end up returning less data then what the caller
+	 * asked for, resulting in an unexpected, and incorrect, short read.
+	 * That is, the caller asked to read N bytes and we return less than that,
+	 * which is wrong unless we are crossing EOF. This happens if we get a
+	 * page fault error when trying to fault in pages for the buffer that is
+	 * associated to the struct iov_iter passed to iomap_dio_rw(), and we
+	 * have previously submitted bios for other extents in the range, in
+	 * which case iomap_dio_rw() may return us EIOCBQUEUED if not all of
+	 * those bios have completed by the time we get the page fault error,
+	 * which we return back to our caller - we should only return EIOCBQUEUED
+	 * after we have submitted bios for all the extents in the range.
+	 */
+	if ((flags & IOMAP_NOWAIT) && len < length) {
+		free_extent_map(em);
+		ret = -EAGAIN;
+		goto unlock_err;
+	}
+
 	if (write) {
 		ret = btrfs_get_blocks_direct_write(&em, inode, dio_data,
 						    start, len);
@@ -7991,14 +8045,8 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			     &cached_state);
 err:
-	if (dio_data) {
-		btrfs_delalloc_release_space(BTRFS_I(inode),
-				dio_data->data_reserved, start,
-				dio_data->reserve, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), dio_data->reserve);
-		extent_changeset_free(dio_data->data_reserved);
-		kfree(dio_data);
-	}
+	kfree(dio_data);
+
 	return ret;
 }
 
@@ -8028,14 +8076,8 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 		ret = -ENOTBLK;
 	}
 
-	if (write) {
-		if (dio_data->reserve)
-			btrfs_delalloc_release_space(BTRFS_I(inode),
-					dio_data->data_reserved, pos,
-					dio_data->reserve, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), dio_data->length);
+	if (write)
 		extent_changeset_free(dio_data->data_reserved);
-	}
 out:
 	kfree(dio_data);
 	iomap->private = NULL;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 541a4fbfd79e..3d3d6e2f110a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -986,8 +986,155 @@ static noinline int btrfs_mksnapshot(const struct path *parent,
 	return ret;
 }
 
+/*
+ * Defrag specific helper to get an extent map.
+ *
+ * Differences between this and btrfs_get_extent() are:
+ *
+ * - No extent_map will be added to inode->extent_tree
+ *   To reduce memory usage in the long run.
+ *
+ * - Extra optimization to skip file extents older than @newer_than
+ *   By using btrfs_search_forward() we can skip entire file ranges that
+ *   have extents created in past transactions, because btrfs_search_forward()
+ *   will not visit leaves and nodes with a generation smaller than given
+ *   minimal generation threshold (@newer_than).
+ *
+ * Return valid em if we find a file extent matching the requirement.
+ * Return NULL if we can not find a file extent matching the requirement.
+ *
+ * Return ERR_PTR() for error.
+ */
+static struct extent_map *defrag_get_extent(struct btrfs_inode *inode,
+					    u64 start, u64 newer_than)
+{
+	struct btrfs_root *root = inode->root;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_path path = { 0 };
+	struct extent_map *em;
+	struct btrfs_key key;
+	u64 ino = btrfs_ino(inode);
+	int ret;
+
+	em = alloc_extent_map();
+	if (!em) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = start;
+
+	if (newer_than) {
+		ret = btrfs_search_forward(root, &key, &path, newer_than);
+		if (ret < 0)
+			goto err;
+		/* Can't find anything newer */
+		if (ret > 0)
+			goto not_found;
+	} else {
+		ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+		if (ret < 0)
+			goto err;
+	}
+	if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
+		/*
+		 * If btrfs_search_slot() makes path to point beyond nritems,
+		 * we should not have an empty leaf, as this inode must at
+		 * least have its INODE_ITEM.
+		 */
+		ASSERT(btrfs_header_nritems(path.nodes[0]));
+		path.slots[0] = btrfs_header_nritems(path.nodes[0]) - 1;
+	}
+	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+	/* Perfect match, no need to go one slot back */
+	if (key.objectid == ino && key.type == BTRFS_EXTENT_DATA_KEY &&
+	    key.offset == start)
+		goto iterate;
+
+	/* We didn't find a perfect match, needs to go one slot back */
+	if (path.slots[0] > 0) {
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.objectid == ino && key.type == BTRFS_EXTENT_DATA_KEY)
+			path.slots[0]--;
+	}
+
+iterate:
+	/* Iterate through the path to find a file extent covering @start */
+	while (true) {
+		u64 extent_end;
+
+		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0]))
+			goto next;
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+
+		/*
+		 * We may go one slot back to INODE_REF/XATTR item, then
+		 * need to go forward until we reach an EXTENT_DATA.
+		 * But we should still has the correct ino as key.objectid.
+		 */
+		if (WARN_ON(key.objectid < ino) || key.type < BTRFS_EXTENT_DATA_KEY)
+			goto next;
+
+		/* It's beyond our target range, definitely not extent found */
+		if (key.objectid > ino || key.type > BTRFS_EXTENT_DATA_KEY)
+			goto not_found;
+
+		/*
+		 *	|	|<- File extent ->|
+		 *	\- start
+		 *
+		 * This means there is a hole between start and key.offset.
+		 */
+		if (key.offset > start) {
+			em->start = start;
+			em->orig_start = start;
+			em->block_start = EXTENT_MAP_HOLE;
+			em->len = key.offset - start;
+			break;
+		}
+
+		fi = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				    struct btrfs_file_extent_item);
+		extent_end = btrfs_file_extent_end(&path);
+
+		/*
+		 *	|<- file extent ->|	|
+		 *				\- start
+		 *
+		 * We haven't reached start, search next slot.
+		 */
+		if (extent_end <= start)
+			goto next;
+
+		/* Now this extent covers @start, convert it to em */
+		btrfs_extent_item_to_extent_map(inode, &path, fi, false, em);
+		break;
+next:
+		ret = btrfs_next_item(root, &path);
+		if (ret < 0)
+			goto err;
+		if (ret > 0)
+			goto not_found;
+	}
+	btrfs_release_path(&path);
+	return em;
+
+not_found:
+	btrfs_release_path(&path);
+	free_extent_map(em);
+	return NULL;
+
+err:
+	btrfs_release_path(&path);
+	free_extent_map(em);
+	return ERR_PTR(ret);
+}
+
 static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start,
-					       bool locked)
+					       u64 newer_than, bool locked)
 {
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
@@ -1002,6 +1149,20 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start,
 	em = lookup_extent_mapping(em_tree, start, sectorsize);
 	read_unlock(&em_tree->lock);
 
+	/*
+	 * We can get a merged extent, in that case, we need to re-search
+	 * tree to get the original em for defrag.
+	 *
+	 * If @newer_than is 0 or em::generation < newer_than, we can trust
+	 * this em, as either we don't care about the generation, or the
+	 * merged extent map will be rejected anyway.
+	 */
+	if (em && test_bit(EXTENT_FLAG_MERGED, &em->flags) &&
+	    newer_than && em->generation >= newer_than) {
+		free_extent_map(em);
+		em = NULL;
+	}
+
 	if (!em) {
 		struct extent_state *cached = NULL;
 		u64 end = start + sectorsize - 1;
@@ -1009,7 +1170,7 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start,
 		/* get the big lock and read metadata off disk */
 		if (!locked)
 			lock_extent_bits(io_tree, start, end, &cached);
-		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, sectorsize);
+		em = defrag_get_extent(BTRFS_I(inode), start, newer_than);
 		if (!locked)
 			unlock_extent_cached(io_tree, start, end, &cached);
 
@@ -1037,7 +1198,12 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em,
 	if (em->start + em->len >= i_size_read(inode))
 		return false;
 
-	next = defrag_lookup_extent(inode, em->start + em->len, locked);
+	/*
+	 * We want to check if the next extent can be merged with the current
+	 * one, which can be an extent created in a past generation, so we pass
+	 * a minimum generation of 0 to defrag_lookup_extent().
+	 */
+	next = defrag_lookup_extent(inode, em->start + em->len, 0, locked);
 	/* No more em or hole */
 	if (!next || next->block_start >= EXTENT_MAP_LAST_BYTE)
 		goto out;
@@ -1188,7 +1354,8 @@ static int defrag_collect_targets(struct btrfs_inode *inode,
 		u64 range_len;
 
 		last_is_target = false;
-		em = defrag_lookup_extent(&inode->vfs_inode, cur, locked);
+		em = defrag_lookup_extent(&inode->vfs_inode, cur,
+					  newer_than, locked);
 		if (!em)
 			break;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 26134b7476a2..4ca809fa80ea 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1196,6 +1196,14 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	if (!fs_info->quota_root)
 		goto out;
 
+	/*
+	 * Unlock the qgroup_ioctl_lock mutex before waiting for the rescan worker to
+	 * complete. Otherwise we can deadlock because btrfs_remove_qgroup() needs
+	 * to lock that mutex while holding a transaction handle and the rescan
+	 * worker needs to commit a transaction.
+	 */
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
 	/*
 	 * Request qgroup rescan worker to complete and wait for it. This wait
 	 * must be done before transaction start for quota disable since it may
@@ -1203,7 +1211,6 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	 */
 	clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	btrfs_qgroup_wait_for_completion(fs_info, false);
-	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 
 	/*
 	 * 1 For the root item
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 33a0ee7ac590..f129e0718b11 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3971,6 +3971,19 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 	int rw = 0;
 	int err = 0;
 
+	/*
+	 * This only gets set if we had a half-deleted snapshot on mount.  We
+	 * cannot allow relocation to start while we're still trying to clean up
+	 * these pending deletions.
+	 */
+	ret = wait_on_bit(&fs_info->flags, BTRFS_FS_UNFINISHED_DROPS, TASK_INTERRUPTIBLE);
+	if (ret)
+		return ret;
+
+	/* We may have been woken up by close_ctree, so bail if we're closing. */
+	if (btrfs_fs_closing(fs_info))
+		return -EINTR;
+
 	bg = btrfs_lookup_block_group(fs_info, group_start);
 	if (!bg)
 		return -ENOENT;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index d20166336557..c6a173e81118 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -278,6 +278,21 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 
 		WARN_ON(!test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state));
 		if (btrfs_root_refs(&root->root_item) == 0) {
+			struct btrfs_key drop_key;
+
+			btrfs_disk_key_to_cpu(&drop_key, &root->root_item.drop_progress);
+			/*
+			 * If we have a non-zero drop_progress then we know we
+			 * made it partly through deleting this snapshot, and
+			 * thus we need to make sure we block any balance from
+			 * happening until this snapshot is completely dropped.
+			 */
+			if (drop_key.objectid != 0 || drop_key.type != 0 ||
+			    drop_key.offset != 0) {
+				set_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
+				set_bit(BTRFS_ROOT_UNFINISHED_DROP, &root->state);
+			}
+
 			set_bit(BTRFS_ROOT_DEAD_TREE, &root->state);
 			btrfs_add_dead_root(root);
 		}
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 29bd8c7a7706..ef7ae20d2b77 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -736,7 +736,7 @@ void btrfs_page_unlock_writer(struct btrfs_fs_info *fs_info, struct page *page,
 	 * Since we own the page lock, no one else could touch subpage::writers
 	 * and we are safe to do several atomic operations without spinlock.
 	 */
-	if (atomic_read(&subpage->writers))
+	if (atomic_read(&subpage->writers) == 0)
 		/* No writers, locked by plain lock_page() */
 		return unlock_page(page);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 27b93a6c41bb..a43c101c5525 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -846,7 +846,37 @@ btrfs_attach_transaction_barrier(struct btrfs_root *root)
 static noinline void wait_for_commit(struct btrfs_transaction *commit,
 				     const enum btrfs_trans_state min_state)
 {
-	wait_event(commit->commit_wait, commit->state >= min_state);
+	struct btrfs_fs_info *fs_info = commit->fs_info;
+	u64 transid = commit->transid;
+	bool put = false;
+
+	while (1) {
+		wait_event(commit->commit_wait, commit->state >= min_state);
+		if (put)
+			btrfs_put_transaction(commit);
+
+		if (min_state < TRANS_STATE_COMPLETED)
+			break;
+
+		/*
+		 * A transaction isn't really completed until all of the
+		 * previous transactions are completed, but with fsync we can
+		 * end up with SUPER_COMMITTED transactions before a COMPLETED
+		 * transaction. Wait for those.
+		 */
+
+		spin_lock(&fs_info->trans_lock);
+		commit = list_first_entry_or_null(&fs_info->trans_list,
+						  struct btrfs_transaction,
+						  list);
+		if (!commit || commit->transid > transid) {
+			spin_unlock(&fs_info->trans_lock);
+			break;
+		}
+		refcount_inc(&commit->use_count);
+		put = true;
+		spin_unlock(&fs_info->trans_lock);
+	}
 }
 
 int btrfs_wait_for_commit(struct btrfs_fs_info *fs_info, u64 transid)
@@ -1309,6 +1339,32 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 	return 0;
 }
 
+/*
+ * If we had a pending drop we need to see if there are any others left in our
+ * dead roots list, and if not clear our bit and wake any waiters.
+ */
+void btrfs_maybe_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
+{
+	/*
+	 * We put the drop in progress roots at the front of the list, so if the
+	 * first entry doesn't have UNFINISHED_DROP set we can wake everybody
+	 * up.
+	 */
+	spin_lock(&fs_info->trans_lock);
+	if (!list_empty(&fs_info->dead_roots)) {
+		struct btrfs_root *root = list_first_entry(&fs_info->dead_roots,
+							   struct btrfs_root,
+							   root_list);
+		if (test_bit(BTRFS_ROOT_UNFINISHED_DROP, &root->state)) {
+			spin_unlock(&fs_info->trans_lock);
+			return;
+		}
+	}
+	spin_unlock(&fs_info->trans_lock);
+
+	btrfs_wake_unfinished_drop(fs_info);
+}
+
 /*
  * dead roots are old snapshots that need to be deleted.  This allocates
  * a dirty root struct and adds it into the list of dead roots that need to
@@ -1321,7 +1377,12 @@ void btrfs_add_dead_root(struct btrfs_root *root)
 	spin_lock(&fs_info->trans_lock);
 	if (list_empty(&root->root_list)) {
 		btrfs_grab_root(root);
-		list_add_tail(&root->root_list, &fs_info->dead_roots);
+
+		/* We want to process the partially complete drops first. */
+		if (test_bit(BTRFS_ROOT_UNFINISHED_DROP, &root->state))
+			list_add(&root->root_list, &fs_info->dead_roots);
+		else
+			list_add_tail(&root->root_list, &fs_info->dead_roots);
 	}
 	spin_unlock(&fs_info->trans_lock);
 }
@@ -2013,16 +2074,24 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
 static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 {
 	/*
-	 * We use writeback_inodes_sb here because if we used
+	 * We use try_to_writeback_inodes_sb() here because if we used
 	 * btrfs_start_delalloc_roots we would deadlock with fs freeze.
 	 * Currently are holding the fs freeze lock, if we do an async flush
 	 * we'll do btrfs_join_transaction() and deadlock because we need to
 	 * wait for the fs freeze lock.  Using the direct flushing we benefit
 	 * from already being in a transaction and our join_transaction doesn't
 	 * have to re-take the fs freeze lock.
+	 *
+	 * Note that try_to_writeback_inodes_sb() will only trigger writeback
+	 * if it can read lock sb->s_umount. It will always be able to lock it,
+	 * except when the filesystem is being unmounted or being frozen, but in
+	 * those cases sync_filesystem() is called, which results in calling
+	 * writeback_inodes_sb() while holding a write lock on sb->s_umount.
+	 * Note that we don't call writeback_inodes_sb() directly, because it
+	 * will emit a warning if sb->s_umount is not locked.
 	 */
 	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
-		writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
+		try_to_writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
 	return 0;
 }
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index eba07b8119bb..0ded32bbd001 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -217,6 +217,7 @@ int btrfs_wait_for_commit(struct btrfs_fs_info *fs_info, u64 transid);
 
 void btrfs_add_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root);
+void btrfs_maybe_wake_unfinished_drop(struct btrfs_fs_info *fs_info);
 int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6993dcdba6f1..f5371c4653cd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1357,6 +1357,15 @@ static int unlink_old_inode_refs(struct btrfs_trans_handle *trans,
 						 inode, name, namelen);
 			kfree(name);
 			iput(dir);
+			/*
+			 * Whenever we need to check if a name exists or not, we
+			 * check the subvolume tree. So after an unlink we must
+			 * run delayed items, so that future checks for a name
+			 * during log replay see that the name does not exists
+			 * anymore.
+			 */
+			if (!ret)
+				ret = btrfs_run_delayed_items(trans);
 			if (ret)
 				goto out;
 			goto again;
@@ -1609,6 +1618,15 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 				 */
 				if (!ret && inode->i_nlink == 0)
 					inc_nlink(inode);
+				/*
+				 * Whenever we need to check if a name exists or
+				 * not, we check the subvolume tree. So after an
+				 * unlink we must run delayed items, so that future
+				 * checks for a name during log replay see that the
+				 * name does not exists anymore.
+				 */
+				if (!ret)
+					ret = btrfs_run_delayed_items(trans);
 			}
 			if (ret < 0)
 				goto out;
@@ -4658,7 +4676,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 
 /*
  * Log all prealloc extents beyond the inode's i_size to make sure we do not
- * lose them after doing a fast fsync and replaying the log. We scan the
+ * lose them after doing a full/fast fsync and replaying the log. We scan the
  * subvolume's root instead of iterating the inode's extent map tree because
  * otherwise we can log incorrect extent items based on extent map conversion.
  * That can happen due to the fact that extent maps are merged when they
@@ -5437,6 +5455,7 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 				   struct btrfs_log_ctx *ctx,
 				   bool *need_log_inode_item)
 {
+	const u64 i_size = i_size_read(&inode->vfs_inode);
 	struct btrfs_root *root = inode->root;
 	int ins_start_slot = 0;
 	int ins_nr = 0;
@@ -5457,13 +5476,21 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 		if (min_key->type > max_key->type)
 			break;
 
-		if (min_key->type == BTRFS_INODE_ITEM_KEY)
+		if (min_key->type == BTRFS_INODE_ITEM_KEY) {
 			*need_log_inode_item = false;
-
-		if ((min_key->type == BTRFS_INODE_REF_KEY ||
-		     min_key->type == BTRFS_INODE_EXTREF_KEY) &&
-		    inode->generation == trans->transid &&
-		    !recursive_logging) {
+		} else if (min_key->type == BTRFS_EXTENT_DATA_KEY &&
+			   min_key->offset >= i_size) {
+			/*
+			 * Extents at and beyond eof are logged with
+			 * btrfs_log_prealloc_extents().
+			 * Only regular files have BTRFS_EXTENT_DATA_KEY keys,
+			 * and no keys greater than that, so bail out.
+			 */
+			break;
+		} else if ((min_key->type == BTRFS_INODE_REF_KEY ||
+			    min_key->type == BTRFS_INODE_EXTREF_KEY) &&
+			   inode->generation == trans->transid &&
+			   !recursive_logging) {
 			u64 other_ino = 0;
 			u64 other_parent = 0;
 
@@ -5494,10 +5521,8 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 				btrfs_release_path(path);
 				goto next_key;
 			}
-		}
-
-		/* Skip xattrs, we log them later with btrfs_log_all_xattrs() */
-		if (min_key->type == BTRFS_XATTR_ITEM_KEY) {
+		} else if (min_key->type == BTRFS_XATTR_ITEM_KEY) {
+			/* Skip xattrs, logged later with btrfs_log_all_xattrs() */
 			if (ins_nr == 0)
 				goto next_slot;
 			ret = copy_items(trans, inode, dst_path, path,
@@ -5550,9 +5575,21 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 			break;
 		}
 	}
-	if (ins_nr)
+	if (ins_nr) {
 		ret = copy_items(trans, inode, dst_path, path, ins_start_slot,
 				 ins_nr, inode_only, logged_isize);
+		if (ret)
+			return ret;
+	}
+
+	if (inode_only == LOG_INODE_ALL && S_ISREG(inode->vfs_inode.i_mode)) {
+		/*
+		 * Release the path because otherwise we might attempt to double
+		 * lock the same leaf with btrfs_log_prealloc_extents() below.
+		 */
+		btrfs_release_path(path);
+		ret = btrfs_log_prealloc_extents(trans, inode, dst_path);
+	}
 
 	return ret;
 }
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index ee3aab3dd4ac..bf861fef2f0c 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -949,6 +949,9 @@ static void populate_new_aces(char *nacl_base,
 		pnntace = (struct cifs_ace *) (nacl_base + nsize);
 		nsize += setup_special_mode_ACE(pnntace, nmode);
 		num_aces++;
+		pnntace = (struct cifs_ace *) (nacl_base + nsize);
+		nsize += setup_authusers_ACE(pnntace);
+		num_aces++;
 		goto set_size;
 	}
 
@@ -1297,7 +1300,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 
 		if (uid_valid(uid)) { /* chown */
 			uid_t id;
-			nowner_sid_ptr = kmalloc(sizeof(struct cifs_sid),
+			nowner_sid_ptr = kzalloc(sizeof(struct cifs_sid),
 								GFP_KERNEL);
 			if (!nowner_sid_ptr) {
 				rc = -ENOMEM;
@@ -1326,7 +1329,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 		}
 		if (gid_valid(gid)) { /* chgrp */
 			gid_t id;
-			ngroup_sid_ptr = kmalloc(sizeof(struct cifs_sid),
+			ngroup_sid_ptr = kzalloc(sizeof(struct cifs_sid),
 								GFP_KERNEL);
 			if (!ngroup_sid_ptr) {
 				rc = -ENOMEM;
@@ -1613,7 +1616,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	nsecdesclen = secdesclen;
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
 		if (mode_from_sid)
-			nsecdesclen += sizeof(struct cifs_ace);
+			nsecdesclen += 2 * sizeof(struct cifs_ace);
 		else /* cifsacl */
 			nsecdesclen += 5 * sizeof(struct cifs_ace);
 	} else { /* chown */
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index dca42aa87d30..99c51391a48d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -908,6 +908,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 
 out_super:
 	deactivate_locked_super(sb);
+	return root;
 out:
 	if (cifs_sb) {
 		kfree(cifs_sb->prepath);
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 6af0191b648f..d890fd34bb2d 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -110,8 +110,7 @@ int __exfat_truncate(struct inode *inode, loff_t new_size)
 	exfat_set_volume_dirty(sb);
 
 	num_clusters_new = EXFAT_B_TO_CLU_ROUND_UP(i_size_read(inode), sbi);
-	num_clusters_phys =
-		EXFAT_B_TO_CLU_ROUND_UP(EXFAT_I(inode)->i_size_ondisk, sbi);
+	num_clusters_phys = EXFAT_B_TO_CLU_ROUND_UP(ei->i_size_ondisk, sbi);
 
 	exfat_chain_set(&clu, ei->start_clu, num_clusters_phys, ei->flags);
 
@@ -228,12 +227,13 @@ void exfat_truncate(struct inode *inode, loff_t size)
 {
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
 	unsigned int blocksize = i_blocksize(inode);
 	loff_t aligned_size;
 	int err;
 
 	mutex_lock(&sbi->s_lock);
-	if (EXFAT_I(inode)->start_clu == 0) {
+	if (ei->start_clu == 0) {
 		/*
 		 * Empty start_clu != ~0 (not allocated)
 		 */
@@ -251,8 +251,8 @@ void exfat_truncate(struct inode *inode, loff_t size)
 	else
 		mark_inode_dirty(inode);
 
-	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1)) &
-			~(sbi->cluster_size - 1)) >> inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
+				inode->i_blkbits;
 write_size:
 	aligned_size = i_size_read(inode);
 	if (aligned_size & (blocksize - 1)) {
@@ -260,11 +260,11 @@ void exfat_truncate(struct inode *inode, loff_t size)
 		aligned_size++;
 	}
 
-	if (EXFAT_I(inode)->i_size_ondisk > i_size_read(inode))
-		EXFAT_I(inode)->i_size_ondisk = aligned_size;
+	if (ei->i_size_ondisk > i_size_read(inode))
+		ei->i_size_ondisk = aligned_size;
 
-	if (EXFAT_I(inode)->i_size_aligned > i_size_read(inode))
-		EXFAT_I(inode)->i_size_aligned = aligned_size;
+	if (ei->i_size_aligned > i_size_read(inode))
+		ei->i_size_aligned = aligned_size;
 	mutex_unlock(&sbi->s_lock);
 }
 
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 1c7aa1ea4724..72a0ccfb616c 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -114,10 +114,9 @@ static int exfat_map_cluster(struct inode *inode, unsigned int clu_offset,
 	unsigned int local_clu_offset = clu_offset;
 	unsigned int num_to_be_allocated = 0, num_clusters = 0;
 
-	if (EXFAT_I(inode)->i_size_ondisk > 0)
+	if (ei->i_size_ondisk > 0)
 		num_clusters =
-			EXFAT_B_TO_CLU_ROUND_UP(EXFAT_I(inode)->i_size_ondisk,
-			sbi);
+			EXFAT_B_TO_CLU_ROUND_UP(ei->i_size_ondisk, sbi);
 
 	if (clu_offset >= num_clusters)
 		num_to_be_allocated = clu_offset - num_clusters + 1;
@@ -416,10 +415,10 @@ static int exfat_write_end(struct file *file, struct address_space *mapping,
 
 	err = generic_write_end(file, mapping, pos, len, copied, pagep, fsdata);
 
-	if (EXFAT_I(inode)->i_size_aligned < i_size_read(inode)) {
+	if (ei->i_size_aligned < i_size_read(inode)) {
 		exfat_fs_error(inode->i_sb,
 			"invalid size(size(%llu) > aligned(%llu)\n",
-			i_size_read(inode), EXFAT_I(inode)->i_size_aligned);
+			i_size_read(inode), ei->i_size_aligned);
 		return -EIO;
 	}
 
@@ -603,8 +602,8 @@ static int exfat_fill_inode(struct inode *inode, struct exfat_dir_entry *info)
 
 	exfat_save_attr(inode, info->attr);
 
-	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1)) &
-		~((loff_t)sbi->cluster_size - 1)) >> inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
+				inode->i_blkbits;
 	inode->i_mtime = info->mtime;
 	inode->i_ctime = info->mtime;
 	ei->i_crtime = info->crtime;
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 24b41103d1cc..9d8ada781250 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -395,9 +395,9 @@ static int exfat_find_empty_entry(struct inode *inode,
 
 		/* directory inode should be updated in here */
 		i_size_write(inode, size);
-		EXFAT_I(inode)->i_size_ondisk += sbi->cluster_size;
-		EXFAT_I(inode)->i_size_aligned += sbi->cluster_size;
-		EXFAT_I(inode)->flags = p_dir->flags;
+		ei->i_size_ondisk += sbi->cluster_size;
+		ei->i_size_aligned += sbi->cluster_size;
+		ei->flags = p_dir->flags;
 		inode->i_blocks += 1 << sbi->sect_per_clus_bits;
 	}
 
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 5539ffc20d16..4b5d02b1df58 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -364,11 +364,11 @@ static int exfat_read_root(struct inode *inode)
 	inode->i_op = &exfat_dir_inode_operations;
 	inode->i_fop = &exfat_dir_operations;
 
-	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1))
-			& ~(sbi->cluster_size - 1)) >> inode->i_blkbits;
-	EXFAT_I(inode)->i_pos = ((loff_t)sbi->root_dir << 32) | 0xffffffff;
-	EXFAT_I(inode)->i_size_aligned = i_size_read(inode);
-	EXFAT_I(inode)->i_size_ondisk = i_size_read(inode);
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
+				inode->i_blkbits;
+	ei->i_pos = ((loff_t)sbi->root_dir << 32) | 0xffffffff;
+	ei->i_size_aligned = i_size_read(inode);
+	ei->i_size_ondisk = i_size_read(inode);
 
 	exfat_save_attr(inode, ATTR_SUBDIR);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d248a01132c3..c2cc9d78915b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1725,9 +1725,9 @@ struct ext4_sb_info {
 	 */
 	struct work_struct s_error_work;
 
-	/* Ext4 fast commit stuff */
+	/* Ext4 fast commit sub transaction ID */
 	atomic_t s_fc_subtid;
-	atomic_t s_fc_ineligible_updates;
+
 	/*
 	 * After commit starts, the main queue gets locked, and the further
 	 * updates get added in the staging queue.
@@ -1747,7 +1747,7 @@ struct ext4_sb_info {
 	spinlock_t s_fc_lock;
 	struct buffer_head *s_fc_bh;
 	struct ext4_fc_stats s_fc_stats;
-	u64 s_fc_avg_commit_time;
+	tid_t s_fc_ineligible_tid;
 #ifdef CONFIG_EXT4_DEBUG
 	int s_fc_debug_max_replay;
 #endif
@@ -1793,10 +1793,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 enum {
 	EXT4_MF_MNTDIR_SAMPLED,
 	EXT4_MF_FS_ABORTED,	/* Fatal error detected */
-	EXT4_MF_FC_INELIGIBLE,	/* Fast commit ineligible */
-	EXT4_MF_FC_COMMITTING	/* File system underoing a fast
-				 * commit.
-				 */
+	EXT4_MF_FC_INELIGIBLE	/* Fast commit ineligible */
 };
 
 static inline void ext4_set_mount_flag(struct super_block *sb, int bit)
@@ -2925,9 +2922,7 @@ void __ext4_fc_track_create(handle_t *handle, struct inode *inode,
 			    struct dentry *dentry);
 void ext4_fc_track_create(handle_t *handle, struct dentry *dentry);
 void ext4_fc_track_inode(handle_t *handle, struct inode *inode);
-void ext4_fc_mark_ineligible(struct super_block *sb, int reason);
-void ext4_fc_start_ineligible(struct super_block *sb, int reason);
-void ext4_fc_stop_ineligible(struct super_block *sb);
+void ext4_fc_mark_ineligible(struct super_block *sb, int reason, handle_t *handle);
 void ext4_fc_start_update(struct inode *inode);
 void ext4_fc_stop_update(struct inode *inode);
 void ext4_fc_del(struct inode *inode);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9b37d16b24ff..d2667189be7e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5342,7 +5342,7 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		ret = PTR_ERR(handle);
 		goto out_mmap;
 	}
-	ext4_fc_start_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_discard_preallocations(inode, 0);
@@ -5381,7 +5381,6 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 
 out_stop:
 	ext4_journal_stop(handle);
-	ext4_fc_stop_ineligible(sb);
 out_mmap:
 	filemap_invalidate_unlock(mapping);
 out_mutex:
@@ -5483,7 +5482,7 @@ static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 		ret = PTR_ERR(handle);
 		goto out_mmap;
 	}
-	ext4_fc_start_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	/* Expand file to avoid data loss if there is error while shifting */
 	inode->i_size += len;
@@ -5558,7 +5557,6 @@ static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 
 out_stop:
 	ext4_journal_stop(handle);
-	ext4_fc_stop_ineligible(sb);
 out_mmap:
 	filemap_invalidate_unlock(mapping);
 out_mutex:
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 3b79fb063c07..aca841470634 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -65,21 +65,11 @@
  *
  * Fast Commit Ineligibility
  * -------------------------
- * Not all operations are supported by fast commits today (e.g extended
- * attributes). Fast commit ineligibility is marked by calling one of the
- * two following functions:
- *
- * - ext4_fc_mark_ineligible(): This makes next fast commit operation to fall
- *   back to full commit. This is useful in case of transient errors.
  *
- * - ext4_fc_start_ineligible() and ext4_fc_stop_ineligible() - This makes all
- *   the fast commits happening between ext4_fc_start_ineligible() and
- *   ext4_fc_stop_ineligible() and one fast commit after the call to
- *   ext4_fc_stop_ineligible() to fall back to full commits. It is important to
- *   make one more fast commit to fall back to full commit after stop call so
- *   that it guaranteed that the fast commit ineligible operation contained
- *   within ext4_fc_start_ineligible() and ext4_fc_stop_ineligible() is
- *   followed by at least 1 full commit.
+ * Not all operations are supported by fast commits today (e.g extended
+ * attributes). Fast commit ineligibility is marked by calling
+ * ext4_fc_mark_ineligible(): This makes next fast commit operation to fall back
+ * to full commit.
  *
  * Atomicity of commits
  * --------------------
@@ -312,60 +302,36 @@ void ext4_fc_del(struct inode *inode)
 }
 
 /*
- * Mark file system as fast commit ineligible. This means that next commit
- * operation would result in a full jbd2 commit.
+ * Mark file system as fast commit ineligible, and record latest
+ * ineligible transaction tid. This means until the recorded
+ * transaction, commit operation would result in a full jbd2 commit.
  */
-void ext4_fc_mark_ineligible(struct super_block *sb, int reason)
+void ext4_fc_mark_ineligible(struct super_block *sb, int reason, handle_t *handle)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	tid_t tid;
 
 	if (!test_opt2(sb, JOURNAL_FAST_COMMIT) ||
 	    (EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY))
 		return;
 
 	ext4_set_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
+	if (handle && !IS_ERR(handle))
+		tid = handle->h_transaction->t_tid;
+	else {
+		read_lock(&sbi->s_journal->j_state_lock);
+		tid = sbi->s_journal->j_running_transaction ?
+				sbi->s_journal->j_running_transaction->t_tid : 0;
+		read_unlock(&sbi->s_journal->j_state_lock);
+	}
+	spin_lock(&sbi->s_fc_lock);
+	if (sbi->s_fc_ineligible_tid < tid)
+		sbi->s_fc_ineligible_tid = tid;
+	spin_unlock(&sbi->s_fc_lock);
 	WARN_ON(reason >= EXT4_FC_REASON_MAX);
 	sbi->s_fc_stats.fc_ineligible_reason_count[reason]++;
 }
 
-/*
- * Start a fast commit ineligible update. Any commits that happen while
- * such an operation is in progress fall back to full commits.
- */
-void ext4_fc_start_ineligible(struct super_block *sb, int reason)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-
-	if (!test_opt2(sb, JOURNAL_FAST_COMMIT) ||
-	    (EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY))
-		return;
-
-	WARN_ON(reason >= EXT4_FC_REASON_MAX);
-	sbi->s_fc_stats.fc_ineligible_reason_count[reason]++;
-	atomic_inc(&sbi->s_fc_ineligible_updates);
-}
-
-/*
- * Stop a fast commit ineligible update. We set EXT4_MF_FC_INELIGIBLE flag here
- * to ensure that after stopping the ineligible update, at least one full
- * commit takes place.
- */
-void ext4_fc_stop_ineligible(struct super_block *sb)
-{
-	if (!test_opt2(sb, JOURNAL_FAST_COMMIT) ||
-	    (EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY))
-		return;
-
-	ext4_set_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
-	atomic_dec(&EXT4_SB(sb)->s_fc_ineligible_updates);
-}
-
-static inline int ext4_fc_is_ineligible(struct super_block *sb)
-{
-	return (ext4_test_mount_flag(sb, EXT4_MF_FC_INELIGIBLE) ||
-		atomic_read(&EXT4_SB(sb)->s_fc_ineligible_updates));
-}
-
 /*
  * Generic fast commit tracking function. If this is the first time this we are
  * called after a full commit, we initialize fast commit fields and then call
@@ -391,7 +357,7 @@ static int ext4_fc_track_template(
 	    (sbi->s_mount_state & EXT4_FC_REPLAY))
 		return -EOPNOTSUPP;
 
-	if (ext4_fc_is_ineligible(inode->i_sb))
+	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
 		return -EINVAL;
 
 	tid = handle->h_transaction->t_tid;
@@ -411,7 +377,8 @@ static int ext4_fc_track_template(
 	spin_lock(&sbi->s_fc_lock);
 	if (list_empty(&EXT4_I(inode)->i_fc_list))
 		list_add_tail(&EXT4_I(inode)->i_fc_list,
-				(ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_COMMITTING)) ?
+				(sbi->s_journal->j_flags & JBD2_FULL_COMMIT_ONGOING ||
+				 sbi->s_journal->j_flags & JBD2_FAST_COMMIT_ONGOING) ?
 				&sbi->s_fc_q[FC_Q_STAGING] :
 				&sbi->s_fc_q[FC_Q_MAIN]);
 	spin_unlock(&sbi->s_fc_lock);
@@ -437,7 +404,7 @@ static int __track_dentry_update(struct inode *inode, void *arg, bool update)
 	mutex_unlock(&ei->i_fc_lock);
 	node = kmem_cache_alloc(ext4_fc_dentry_cachep, GFP_NOFS);
 	if (!node) {
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
 		mutex_lock(&ei->i_fc_lock);
 		return -ENOMEM;
 	}
@@ -450,7 +417,7 @@ static int __track_dentry_update(struct inode *inode, void *arg, bool update)
 		if (!node->fcd_name.name) {
 			kmem_cache_free(ext4_fc_dentry_cachep, node);
 			ext4_fc_mark_ineligible(inode->i_sb,
-				EXT4_FC_REASON_NOMEM);
+				EXT4_FC_REASON_NOMEM, NULL);
 			mutex_lock(&ei->i_fc_lock);
 			return -ENOMEM;
 		}
@@ -464,7 +431,8 @@ static int __track_dentry_update(struct inode *inode, void *arg, bool update)
 	node->fcd_name.len = dentry->d_name.len;
 
 	spin_lock(&sbi->s_fc_lock);
-	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_COMMITTING))
+	if (sbi->s_journal->j_flags & JBD2_FULL_COMMIT_ONGOING ||
+		sbi->s_journal->j_flags & JBD2_FAST_COMMIT_ONGOING)
 		list_add_tail(&node->fcd_list,
 				&sbi->s_fc_dentry_q[FC_Q_STAGING]);
 	else
@@ -552,7 +520,7 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 
 	if (ext4_should_journal_data(inode)) {
 		ext4_fc_mark_ineligible(inode->i_sb,
-					EXT4_FC_REASON_INODE_JOURNAL_DATA);
+					EXT4_FC_REASON_INODE_JOURNAL_DATA, handle);
 		return;
 	}
 
@@ -930,7 +898,6 @@ static int ext4_fc_submit_inode_data_all(journal_t *journal)
 	int ret = 0;
 
 	spin_lock(&sbi->s_fc_lock);
-	ext4_set_mount_flag(sb, EXT4_MF_FC_COMMITTING);
 	list_for_each_entry(ei, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		ext4_set_inode_state(&ei->vfs_inode, EXT4_STATE_FC_COMMITTING);
 		while (atomic_read(&ei->i_fc_updates)) {
@@ -1123,6 +1090,32 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	return ret;
 }
 
+static void ext4_fc_update_stats(struct super_block *sb, int status,
+				 u64 commit_time, int nblks)
+{
+	struct ext4_fc_stats *stats = &EXT4_SB(sb)->s_fc_stats;
+
+	jbd_debug(1, "Fast commit ended with status = %d", status);
+	if (status == EXT4_FC_STATUS_OK) {
+		stats->fc_num_commits++;
+		stats->fc_numblks += nblks;
+		if (likely(stats->s_fc_avg_commit_time))
+			stats->s_fc_avg_commit_time =
+				(commit_time +
+				 stats->s_fc_avg_commit_time * 3) / 4;
+		else
+			stats->s_fc_avg_commit_time = commit_time;
+	} else if (status == EXT4_FC_STATUS_FAILED ||
+		   status == EXT4_FC_STATUS_INELIGIBLE) {
+		if (status == EXT4_FC_STATUS_FAILED)
+			stats->fc_failed_commits++;
+		stats->fc_ineligible_commits++;
+	} else {
+		stats->fc_skipped_commits++;
+	}
+	trace_ext4_fc_commit_stop(sb, nblks, status);
+}
+
 /*
  * The main commit entry point. Performs a fast commit for transaction
  * commit_tid if needed. If it's not possible to perform a fast commit
@@ -1135,18 +1128,15 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int nblks = 0, ret, bsize = journal->j_blocksize;
 	int subtid = atomic_read(&sbi->s_fc_subtid);
-	int reason = EXT4_FC_REASON_OK, fc_bufs_before = 0;
+	int status = EXT4_FC_STATUS_OK, fc_bufs_before = 0;
 	ktime_t start_time, commit_time;
 
 	trace_ext4_fc_commit_start(sb);
 
 	start_time = ktime_get();
 
-	if (!test_opt2(sb, JOURNAL_FAST_COMMIT) ||
-		(ext4_fc_is_ineligible(sb))) {
-		reason = EXT4_FC_REASON_INELIGIBLE;
-		goto out;
-	}
+	if (!test_opt2(sb, JOURNAL_FAST_COMMIT))
+		return jbd2_complete_transaction(journal, commit_tid);
 
 restart_fc:
 	ret = jbd2_fc_begin_commit(journal, commit_tid);
@@ -1155,74 +1145,59 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
 		if (atomic_read(&sbi->s_fc_subtid) <= subtid &&
 			commit_tid > journal->j_commit_sequence)
 			goto restart_fc;
-		reason = EXT4_FC_REASON_ALREADY_COMMITTED;
-		goto out;
+		ext4_fc_update_stats(sb, EXT4_FC_STATUS_SKIPPED, 0, 0);
+		return 0;
 	} else if (ret) {
-		sbi->s_fc_stats.fc_ineligible_reason_count[EXT4_FC_COMMIT_FAILED]++;
-		reason = EXT4_FC_REASON_FC_START_FAILED;
-		goto out;
+		/*
+		 * Commit couldn't start. Just update stats and perform a
+		 * full commit.
+		 */
+		ext4_fc_update_stats(sb, EXT4_FC_STATUS_FAILED, 0, 0);
+		return jbd2_complete_transaction(journal, commit_tid);
+	}
+
+	/*
+	 * After establishing journal barrier via jbd2_fc_begin_commit(), check
+	 * if we are fast commit ineligible.
+	 */
+	if (ext4_test_mount_flag(sb, EXT4_MF_FC_INELIGIBLE)) {
+		status = EXT4_FC_STATUS_INELIGIBLE;
+		goto fallback;
 	}
 
 	fc_bufs_before = (sbi->s_fc_bytes + bsize - 1) / bsize;
 	ret = ext4_fc_perform_commit(journal);
 	if (ret < 0) {
-		sbi->s_fc_stats.fc_ineligible_reason_count[EXT4_FC_COMMIT_FAILED]++;
-		reason = EXT4_FC_REASON_FC_FAILED;
-		goto out;
+		status = EXT4_FC_STATUS_FAILED;
+		goto fallback;
 	}
 	nblks = (sbi->s_fc_bytes + bsize - 1) / bsize - fc_bufs_before;
 	ret = jbd2_fc_wait_bufs(journal, nblks);
 	if (ret < 0) {
-		sbi->s_fc_stats.fc_ineligible_reason_count[EXT4_FC_COMMIT_FAILED]++;
-		reason = EXT4_FC_REASON_FC_FAILED;
-		goto out;
+		status = EXT4_FC_STATUS_FAILED;
+		goto fallback;
 	}
 	atomic_inc(&sbi->s_fc_subtid);
-	jbd2_fc_end_commit(journal);
-out:
-	/* Has any ineligible update happened since we started? */
-	if (reason == EXT4_FC_REASON_OK && ext4_fc_is_ineligible(sb)) {
-		sbi->s_fc_stats.fc_ineligible_reason_count[EXT4_FC_COMMIT_FAILED]++;
-		reason = EXT4_FC_REASON_INELIGIBLE;
-	}
-
-	spin_lock(&sbi->s_fc_lock);
-	if (reason != EXT4_FC_REASON_OK &&
-		reason != EXT4_FC_REASON_ALREADY_COMMITTED) {
-		sbi->s_fc_stats.fc_ineligible_commits++;
-	} else {
-		sbi->s_fc_stats.fc_num_commits++;
-		sbi->s_fc_stats.fc_numblks += nblks;
-	}
-	spin_unlock(&sbi->s_fc_lock);
-	nblks = (reason == EXT4_FC_REASON_OK) ? nblks : 0;
-	trace_ext4_fc_commit_stop(sb, nblks, reason);
-	commit_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
+	ret = jbd2_fc_end_commit(journal);
 	/*
-	 * weight the commit time higher than the average time so we don't
-	 * react too strongly to vast changes in the commit time
+	 * weight the commit time higher than the average time so we
+	 * don't react too strongly to vast changes in the commit time
 	 */
-	if (likely(sbi->s_fc_avg_commit_time))
-		sbi->s_fc_avg_commit_time = (commit_time +
-				sbi->s_fc_avg_commit_time * 3) / 4;
-	else
-		sbi->s_fc_avg_commit_time = commit_time;
-	jbd_debug(1,
-		"Fast commit ended with blks = %d, reason = %d, subtid - %d",
-		nblks, reason, subtid);
-	if (reason == EXT4_FC_REASON_FC_FAILED)
-		return jbd2_fc_end_commit_fallback(journal);
-	if (reason == EXT4_FC_REASON_FC_START_FAILED ||
-		reason == EXT4_FC_REASON_INELIGIBLE)
-		return jbd2_complete_transaction(journal, commit_tid);
-	return 0;
+	commit_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
+	ext4_fc_update_stats(sb, status, commit_time, nblks);
+	return ret;
+
+fallback:
+	ret = jbd2_fc_end_commit_fallback(journal);
+	ext4_fc_update_stats(sb, status, 0, 0);
+	return ret;
 }
 
 /*
  * Fast commit cleanup routine. This is called after every fast commit and
  * full commit. full is true if we are called after a full commit.
  */
-static void ext4_fc_cleanup(journal_t *journal, int full)
+static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1240,7 +1215,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full)
 		list_del_init(&iter->i_fc_list);
 		ext4_clear_inode_state(&iter->vfs_inode,
 				       EXT4_STATE_FC_COMMITTING);
-		ext4_fc_reset_inode(&iter->vfs_inode);
+		if (iter->i_sync_tid <= tid)
+			ext4_fc_reset_inode(&iter->vfs_inode);
 		/* Make sure EXT4_STATE_FC_COMMITTING bit is clear */
 		smp_mb();
 #if (BITS_PER_LONG < 64)
@@ -1269,8 +1245,10 @@ static void ext4_fc_cleanup(journal_t *journal, int full)
 	list_splice_init(&sbi->s_fc_q[FC_Q_STAGING],
 				&sbi->s_fc_q[FC_Q_MAIN]);
 
-	ext4_clear_mount_flag(sb, EXT4_MF_FC_COMMITTING);
-	ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
+	if (tid >= sbi->s_fc_ineligible_tid) {
+		sbi->s_fc_ineligible_tid = 0;
+		ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
+	}
 
 	if (full)
 		sbi->s_fc_bytes = 0;
@@ -2181,7 +2159,7 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
 		"fc stats:\n%ld commits\n%ld ineligible\n%ld numblks\n%lluus avg_commit_time\n",
 		   stats->fc_num_commits, stats->fc_ineligible_commits,
 		   stats->fc_numblks,
-		   div_u64(sbi->s_fc_avg_commit_time, 1000));
+		   div_u64(stats->s_fc_avg_commit_time, 1000));
 	seq_puts(seq, "Ineligible reasons:\n");
 	for (i = 0; i < EXT4_FC_REASON_MAX; i++)
 		seq_printf(seq, "\"%s\":\t%d\n", fc_ineligible_reasons[i],
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index 937c381b4c85..083ad1cb705a 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -71,21 +71,19 @@ struct ext4_fc_tail {
 };
 
 /*
- * Fast commit reason codes
+ * Fast commit status codes
+ */
+enum {
+	EXT4_FC_STATUS_OK = 0,
+	EXT4_FC_STATUS_INELIGIBLE,
+	EXT4_FC_STATUS_SKIPPED,
+	EXT4_FC_STATUS_FAILED,
+};
+
+/*
+ * Fast commit ineligiblity reasons:
  */
 enum {
-	/*
-	 * Commit status codes:
-	 */
-	EXT4_FC_REASON_OK = 0,
-	EXT4_FC_REASON_INELIGIBLE,
-	EXT4_FC_REASON_ALREADY_COMMITTED,
-	EXT4_FC_REASON_FC_START_FAILED,
-	EXT4_FC_REASON_FC_FAILED,
-
-	/*
-	 * Fast commit ineligiblity reasons:
-	 */
 	EXT4_FC_REASON_XATTR = 0,
 	EXT4_FC_REASON_CROSS_RENAME,
 	EXT4_FC_REASON_JOURNAL_FLAG_CHANGE,
@@ -117,7 +115,10 @@ struct ext4_fc_stats {
 	unsigned int fc_ineligible_reason_count[EXT4_FC_REASON_MAX];
 	unsigned long fc_num_commits;
 	unsigned long fc_ineligible_commits;
+	unsigned long fc_failed_commits;
+	unsigned long fc_skipped_commits;
 	unsigned long fc_numblks;
+	u64 s_fc_avg_commit_time;
 };
 
 #define EXT4_FC_REPLAY_REALLOC_INCREMENT	4
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3bdfe010e17f..2f5686dfa30d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -337,7 +337,7 @@ void ext4_evict_inode(struct inode *inode)
 	return;
 no_delete:
 	if (!list_empty(&EXT4_I(inode)->i_fc_list))
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */
 }
 
@@ -5983,7 +5983,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		return PTR_ERR(handle);
 
 	ext4_fc_mark_ineligible(inode->i_sb,
-		EXT4_FC_REASON_JOURNAL_FLAG_CHANGE);
+		EXT4_FC_REASON_JOURNAL_FLAG_CHANGE, handle);
 	err = ext4_mark_inode_dirty(handle, inode);
 	ext4_handle_sync(handle);
 	ext4_journal_stop(handle);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 220a4c8178b5..f61b59045c6d 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -169,7 +169,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		err = -EINVAL;
 		goto err_out;
 	}
-	ext4_fc_start_ineligible(sb, EXT4_FC_REASON_SWAP_BOOT);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_SWAP_BOOT, handle);
 
 	/* Protect extent tree against block allocations via delalloc */
 	ext4_double_down_write_data_sem(inode, inode_bl);
@@ -252,7 +252,6 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 err_out1:
 	ext4_journal_stop(handle);
-	ext4_fc_stop_ineligible(sb);
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
 err_out:
@@ -1076,7 +1075,7 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		err = ext4_resize_fs(sb, n_blocks_count);
 		if (EXT4_SB(sb)->s_journal) {
-			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_RESIZE);
+			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_RESIZE, NULL);
 			jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 			err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal, 0);
 			jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 52c9bd154122..47b9f87dbc6f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3889,7 +3889,7 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		 * dirents in directories.
 		 */
 		ext4_fc_mark_ineligible(old.inode->i_sb,
-			EXT4_FC_REASON_RENAME_DIR);
+			EXT4_FC_REASON_RENAME_DIR, handle);
 	} else {
 		if (new.inode)
 			ext4_fc_track_unlink(handle, new.dentry);
@@ -4049,7 +4049,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (unlikely(retval))
 		goto end_rename;
 	ext4_fc_mark_ineligible(new.inode->i_sb,
-				EXT4_FC_REASON_CROSS_RENAME);
+				EXT4_FC_REASON_CROSS_RENAME, handle);
 	if (old.dir_bh) {
 		retval = ext4_rename_dir_finish(handle, &old, new.dir->i_ino);
 		if (retval)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 24a7ad80353b..32ca34403dce 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4620,14 +4620,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Initialize fast commit stuff */
 	atomic_set(&sbi->s_fc_subtid, 0);
-	atomic_set(&sbi->s_fc_ineligible_updates, 0);
 	INIT_LIST_HEAD(&sbi->s_fc_q[FC_Q_MAIN]);
 	INIT_LIST_HEAD(&sbi->s_fc_q[FC_Q_STAGING]);
 	INIT_LIST_HEAD(&sbi->s_fc_dentry_q[FC_Q_MAIN]);
 	INIT_LIST_HEAD(&sbi->s_fc_dentry_q[FC_Q_STAGING]);
 	sbi->s_fc_bytes = 0;
 	ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
-	ext4_clear_mount_flag(sb, EXT4_MF_FC_COMMITTING);
+	sbi->s_fc_ineligible_tid = 0;
 	spin_lock_init(&sbi->s_fc_lock);
 	memset(&sbi->s_fc_stats, 0, sizeof(sbi->s_fc_stats));
 	sbi->s_fc_replay_state.fc_regions = NULL;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1e0fc1ed845b..042325349098 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2408,7 +2408,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 	}
-	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR);
+	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, handle);
 
 cleanup:
 	brelse(is.iloc.bh);
@@ -2486,7 +2486,7 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 		if (error == 0)
 			error = error2;
 	}
-	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR);
+	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, NULL);
 
 	return error;
 }
@@ -2920,7 +2920,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 					 error);
 			goto cleanup;
 		}
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, handle);
 	}
 	error = 0;
 cleanup:
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 3cc4ab2ba7f4..d188fa913a07 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -1170,7 +1170,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	if (journal->j_commit_callback)
 		journal->j_commit_callback(journal, commit_transaction);
 	if (journal->j_fc_cleanup_callback)
-		journal->j_fc_cleanup_callback(journal, 1);
+		journal->j_fc_cleanup_callback(journal, 1, commit_transaction->t_tid);
 
 	trace_jbd2_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD2: commit %d complete, head %d\n",
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index bd9ac9891604..1f8493ef181d 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -769,7 +769,7 @@ EXPORT_SYMBOL(jbd2_fc_begin_commit);
 static int __jbd2_fc_end_commit(journal_t *journal, tid_t tid, bool fallback)
 {
 	if (journal->j_fc_cleanup_callback)
-		journal->j_fc_cleanup_callback(journal, 0);
+		journal->j_fc_cleanup_callback(journal, 0, tid);
 	write_lock(&journal->j_state_lock);
 	journal->j_flags &= ~JBD2_FAST_COMMIT_ONGOING;
 	if (fallback)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index cbb22354f380..7df985e3cada 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1586,7 +1586,8 @@ static const struct mm_walk_ops pagemap_ops = {
  * Bits 5-54  swap offset if swapped
  * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
  * Bit  56    page exclusively mapped
- * Bits 57-60 zero
+ * Bit  57    pte is uffd-wp write-protected
+ * Bits 58-60 zero
  * Bit  61    page is file-page or shared-anon
  * Bit  62    page swapped
  * Bit  63    page present
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index fd933c45281a..d63b8106796e 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1295,7 +1295,7 @@ struct journal_s
 	 * Clean-up after fast commit or full commit. JBD2 calls this function
 	 * after every commit operation.
 	 */
-	void (*j_fc_cleanup_callback)(struct journal_s *journal, int);
+	void (*j_fc_cleanup_callback)(struct journal_s *journal, int full, tid_t tid);
 
 	/**
 	 * @j_fc_replay_callback:
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 058d7f371e25..8db25fcc1eba 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -54,8 +54,8 @@ extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
 
 extern int sched_fork(unsigned long clone_flags, struct task_struct *p);
-extern void sched_post_fork(struct task_struct *p,
-			    struct kernel_clone_args *kargs);
+extern void sched_cgroup_fork(struct task_struct *p, struct kernel_clone_args *kargs);
+extern void sched_post_fork(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 3271870fd85e..a1093994e5e4 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -497,8 +497,7 @@ static inline struct sk_buff *bt_skb_sendmmsg(struct sock *sk,
 
 		tmp = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
 		if (IS_ERR(tmp)) {
-			kfree_skb(skb);
-			return tmp;
+			return skb;
 		}
 
 		len -= tmp->len;
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 04341d86585d..5e37e5858679 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -487,9 +487,9 @@ int igmp6_late_init(void);
 void igmp6_cleanup(void);
 void igmp6_late_cleanup(void);
 
-int igmp6_event_query(struct sk_buff *skb);
+void igmp6_event_query(struct sk_buff *skb);
 
-int igmp6_event_report(struct sk_buff *skb);
+void igmp6_event_report(struct sk_buff *skb);
 
 
 #ifdef CONFIG_SYSCTL
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 9eed51e920e8..980daa6e1e3a 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -37,7 +37,7 @@ void nf_register_queue_handler(const struct nf_queue_handler *qh);
 void nf_unregister_queue_handler(void);
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
 
-void nf_queue_entry_get_refs(struct nf_queue_entry *entry);
+bool nf_queue_entry_get_refs(struct nf_queue_entry *entry);
 void nf_queue_entry_free(struct nf_queue_entry *entry);
 
 static inline void init_hashrandom(u32 *jhash_initval)
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2b1ce8534993..301a164f17e9 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1567,7 +1567,6 @@ void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index 225ec87d4f22..7989d9483ea7 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -278,7 +278,8 @@
 #define KEY_PAUSECD		201
 #define KEY_PROG3		202
 #define KEY_PROG4		203
-#define KEY_DASHBOARD		204	/* AL Dashboard */
+#define KEY_ALL_APPLICATIONS	204	/* AC Desktop Show All Applications */
+#define KEY_DASHBOARD		KEY_ALL_APPLICATIONS
 #define KEY_SUSPEND		205
 #define KEY_CLOSE		206	/* AC Close */
 #define KEY_PLAY		207
@@ -612,6 +613,7 @@
 #define KEY_ASSISTANT		0x247	/* AL Context-aware desktop assistant */
 #define KEY_KBD_LAYOUT_NEXT	0x248	/* AC Next Keyboard Layout Select */
 #define KEY_EMOJI_PICKER	0x249	/* Show/hide emoji picker (HUTRR101) */
+#define KEY_DICTATE		0x24a	/* Start or Stop Voice Dictation Session (HUTRR99) */
 
 #define KEY_BRIGHTNESS_MIN		0x250	/* Set Brightness to Minimum */
 #define KEY_BRIGHTNESS_MAX		0x251	/* Set Brightness to Maximum */
diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 4e29d7851890..65e13a099b1a 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -511,6 +511,12 @@ struct xfrm_user_offload {
 	int				ifindex;
 	__u8				flags;
 };
+/* This flag was exposed without any kernel code that supporting it.
+ * Unfortunately, strongswan has the code that uses sets this flag,
+ * which makes impossible to reuse this bit.
+ *
+ * So leave it here to make sure that it won't be reused by mistake.
+ */
 #define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 50d02e3103a5..d846dfde6691 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2293,6 +2293,17 @@ static __latent_entropy struct task_struct *copy_process(
 	if (retval)
 		goto bad_fork_put_pidfd;
 
+	/*
+	 * Now that the cgroups are pinned, re-clone the parent cgroup and put
+	 * the new task on the correct runqueue. All this *before* the task
+	 * becomes visible.
+	 *
+	 * This isn't part of ->can_fork() because while the re-cloning is
+	 * cgroup specific, it unconditionally needs to place the task on a
+	 * runqueue.
+	 */
+	sched_cgroup_fork(p, args);
+
 	/*
 	 * From this point on we must avoid any synchronous user-space
 	 * communication until we take the tasklist-lock. In particular, we do
@@ -2402,7 +2413,7 @@ static __latent_entropy struct task_struct *copy_process(
 		fd_install(pidfd, pidfile);
 
 	proc_fork_connector(p);
-	sched_post_fork(p, args);
+	sched_post_fork(p);
 	cgroup_post_fork(p, args);
 	perf_event_fork(p);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d24823b3c3f9..65082cab2906 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4410,6 +4410,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	init_entity_runnable_average(&p->se);
 
+
 #ifdef CONFIG_SCHED_INFO
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -4425,18 +4426,23 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 	return 0;
 }
 
-void sched_post_fork(struct task_struct *p, struct kernel_clone_args *kargs)
+void sched_cgroup_fork(struct task_struct *p, struct kernel_clone_args *kargs)
 {
 	unsigned long flags;
-#ifdef CONFIG_CGROUP_SCHED
-	struct task_group *tg;
-#endif
 
+	/*
+	 * Because we're not yet on the pid-hash, p->pi_lock isn't strictly
+	 * required yet, but lockdep gets upset if rules are violated.
+	 */
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 #ifdef CONFIG_CGROUP_SCHED
-	tg = container_of(kargs->cset->subsys[cpu_cgrp_id],
-			  struct task_group, css);
-	p->sched_task_group = autogroup_task_group(p, tg);
+	if (1) {
+		struct task_group *tg;
+		tg = container_of(kargs->cset->subsys[cpu_cgrp_id],
+				  struct task_group, css);
+		tg = autogroup_task_group(p, tg);
+		p->sched_task_group = tg;
+	}
 #endif
 	rseq_migrate(p);
 	/*
@@ -4447,7 +4453,10 @@ void sched_post_fork(struct task_struct *p, struct kernel_clone_args *kargs)
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+}
 
+void sched_post_fork(struct task_struct *p)
+{
 	uclamp_post_fork(p);
 }
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 1183c88634aa..3812a33b9fcb 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -310,10 +310,20 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	local_irq_restore(flags);
 }
 
-static void blk_trace_free(struct blk_trace *bt)
+static void blk_trace_free(struct request_queue *q, struct blk_trace *bt)
 {
 	relay_close(bt->rchan);
-	debugfs_remove(bt->dir);
+
+	/*
+	 * If 'bt->dir' is not set, then both 'dropped' and 'msg' are created
+	 * under 'q->debugfs_dir', thus lookup and remove them.
+	 */
+	if (!bt->dir) {
+		debugfs_remove(debugfs_lookup("dropped", q->debugfs_dir));
+		debugfs_remove(debugfs_lookup("msg", q->debugfs_dir));
+	} else {
+		debugfs_remove(bt->dir);
+	}
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
 	kfree(bt);
@@ -335,10 +345,10 @@ static void put_probe_ref(void)
 	mutex_unlock(&blk_probe_mutex);
 }
 
-static void blk_trace_cleanup(struct blk_trace *bt)
+static void blk_trace_cleanup(struct request_queue *q, struct blk_trace *bt)
 {
 	synchronize_rcu();
-	blk_trace_free(bt);
+	blk_trace_free(q, bt);
 	put_probe_ref();
 }
 
@@ -352,7 +362,7 @@ static int __blk_trace_remove(struct request_queue *q)
 		return -EINVAL;
 
 	if (bt->trace_state != Blktrace_running)
-		blk_trace_cleanup(bt);
+		blk_trace_cleanup(q, bt);
 
 	return 0;
 }
@@ -572,7 +582,7 @@ static int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	ret = 0;
 err:
 	if (ret)
-		blk_trace_free(bt);
+		blk_trace_free(q, bt);
 	return ret;
 }
 
@@ -1616,7 +1626,7 @@ static int blk_trace_remove_queue(struct request_queue *q)
 
 	put_probe_ref();
 	synchronize_rcu();
-	blk_trace_free(bt);
+	blk_trace_free(q, bt);
 	return 0;
 }
 
@@ -1647,7 +1657,7 @@ static int blk_trace_setup_queue(struct request_queue *q,
 	return 0;
 
 free_bt:
-	blk_trace_free(bt);
+	blk_trace_free(q, bt);
 	return ret;
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bb1505902044..24683115eade 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -235,7 +235,7 @@ static char trace_boot_options_buf[MAX_TRACER_SIZE] __initdata;
 static int __init set_trace_boot_options(char *str)
 {
 	strlcpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
-	return 0;
+	return 1;
 }
 __setup("trace_options=", set_trace_boot_options);
 
@@ -246,7 +246,7 @@ static int __init set_trace_boot_clock(char *str)
 {
 	strlcpy(trace_boot_clock_buf, str, MAX_TRACER_SIZE);
 	trace_boot_clock = trace_boot_clock_buf;
-	return 0;
+	return 1;
 }
 __setup("trace_clock=", set_trace_boot_clock);
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c9124038b140..06d6318ee537 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
  */
 
+#include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/mutex.h>
@@ -654,6 +655,52 @@ DEFINE_EQUALITY_PRED(32);
 DEFINE_EQUALITY_PRED(16);
 DEFINE_EQUALITY_PRED(8);
 
+/* user space strings temp buffer */
+#define USTRING_BUF_SIZE	1024
+
+struct ustring_buffer {
+	char		buffer[USTRING_BUF_SIZE];
+};
+
+static __percpu struct ustring_buffer *ustring_per_cpu;
+
+static __always_inline char *test_string(char *str)
+{
+	struct ustring_buffer *ubuf;
+	char *kstr;
+
+	if (!ustring_per_cpu)
+		return NULL;
+
+	ubuf = this_cpu_ptr(ustring_per_cpu);
+	kstr = ubuf->buffer;
+
+	/* For safety, do not trust the string pointer */
+	if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))
+		return NULL;
+	return kstr;
+}
+
+static __always_inline char *test_ustring(char *str)
+{
+	struct ustring_buffer *ubuf;
+	char __user *ustr;
+	char *kstr;
+
+	if (!ustring_per_cpu)
+		return NULL;
+
+	ubuf = this_cpu_ptr(ustring_per_cpu);
+	kstr = ubuf->buffer;
+
+	/* user space address? */
+	ustr = (char __user *)str;
+	if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
+		return NULL;
+
+	return kstr;
+}
+
 /* Filter predicate for fixed sized arrays of characters */
 static int filter_pred_string(struct filter_pred *pred, void *event)
 {
@@ -667,19 +714,43 @@ static int filter_pred_string(struct filter_pred *pred, void *event)
 	return match;
 }
 
-/* Filter predicate for char * pointers */
-static int filter_pred_pchar(struct filter_pred *pred, void *event)
+static __always_inline int filter_pchar(struct filter_pred *pred, char *str)
 {
-	char **addr = (char **)(event + pred->offset);
 	int cmp, match;
-	int len = strlen(*addr) + 1;	/* including tailing '\0' */
+	int len;
 
-	cmp = pred->regex.match(*addr, &pred->regex, len);
+	len = strlen(str) + 1;	/* including tailing '\0' */
+	cmp = pred->regex.match(str, &pred->regex, len);
 
 	match = cmp ^ pred->not;
 
 	return match;
 }
+/* Filter predicate for char * pointers */
+static int filter_pred_pchar(struct filter_pred *pred, void *event)
+{
+	char **addr = (char **)(event + pred->offset);
+	char *str;
+
+	str = test_string(*addr);
+	if (!str)
+		return 0;
+
+	return filter_pchar(pred, str);
+}
+
+/* Filter predicate for char * pointers in user space*/
+static int filter_pred_pchar_user(struct filter_pred *pred, void *event)
+{
+	char **addr = (char **)(event + pred->offset);
+	char *str;
+
+	str = test_ustring(*addr);
+	if (!str)
+		return 0;
+
+	return filter_pchar(pred, str);
+}
 
 /*
  * Filter predicate for dynamic sized arrays of characters.
@@ -1158,6 +1229,7 @@ static int parse_pred(const char *str, void *data,
 	struct filter_pred *pred = NULL;
 	char num_buf[24];	/* Big enough to hold an address */
 	char *field_name;
+	bool ustring = false;
 	char q;
 	u64 val;
 	int len;
@@ -1192,6 +1264,12 @@ static int parse_pred(const char *str, void *data,
 		return -EINVAL;
 	}
 
+	/* See if the field is a user space string */
+	if ((len = str_has_prefix(str + i, ".ustring"))) {
+		ustring = true;
+		i += len;
+	}
+
 	while (isspace(str[i]))
 		i++;
 
@@ -1320,8 +1398,20 @@ static int parse_pred(const char *str, void *data,
 
 		} else if (field->filter_type == FILTER_DYN_STRING)
 			pred->fn = filter_pred_strloc;
-		else
-			pred->fn = filter_pred_pchar;
+		else {
+
+			if (!ustring_per_cpu) {
+				/* Once allocated, keep it around for good */
+				ustring_per_cpu = alloc_percpu(struct ustring_buffer);
+				if (!ustring_per_cpu)
+					goto err_mem;
+			}
+
+			if (ustring)
+				pred->fn = filter_pred_pchar_user;
+			else
+				pred->fn = filter_pred_pchar;
+		}
 		/* go past the last quote */
 		i++;
 
@@ -1387,6 +1477,9 @@ static int parse_pred(const char *str, void *data,
 err_free:
 	kfree(pred);
 	return -EINVAL;
+err_mem:
+	kfree(pred);
+	return -ENOMEM;
 }
 
 enum {
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index e697bfedac2f..8fa373d4de39 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2273,9 +2273,9 @@ parse_field(struct hist_trigger_data *hist_data, struct trace_event_file *file,
 			/*
 			 * For backward compatibility, if field_name
 			 * was "cpu", then we treat this the same as
-			 * common_cpu.
+			 * common_cpu. This also works for "CPU".
 			 */
-			if (strcmp(field_name, "cpu") == 0) {
+			if (field && field->filter_type == FILTER_CPU) {
 				*flags |= HIST_FIELD_FL_CPU;
 			} else {
 				hist_err(tr, HIST_ERR_FIELD_NOT_FOUND,
@@ -4816,7 +4816,7 @@ static int create_tracing_map_fields(struct hist_trigger_data *hist_data)
 
 			if (hist_field->flags & HIST_FIELD_FL_STACKTRACE)
 				cmp_fn = tracing_map_cmp_none;
-			else if (!field)
+			else if (!field || hist_field->flags & HIST_FIELD_FL_CPU)
 				cmp_fn = tracing_map_cmp_num(hist_field->size,
 							     hist_field->is_signed);
 			else if (is_string_field(field))
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1bb85f7a4593..bc2a2bc5a453 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -31,7 +31,7 @@ static int __init set_kprobe_boot_events(char *str)
 	strlcpy(kprobe_boot_events_buf, str, COMMAND_LINE_SIZE);
 	disable_tracing_selftest("running kprobe events");
 
-	return 0;
+	return 1;
 }
 __setup("kprobe_event=", set_kprobe_boot_events);
 
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 6b2e3ca7ee99..5481ba44a8d6 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -58,6 +58,18 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
 	cred->user_ns = user_ns;
 }
 
+static unsigned long enforced_nproc_rlimit(void)
+{
+	unsigned long limit = RLIM_INFINITY;
+
+	/* Is RLIMIT_NPROC currently enforced? */
+	if (!uid_eq(current_uid(), GLOBAL_ROOT_UID) ||
+	    (current_user_ns() != &init_user_ns))
+		limit = rlimit(RLIMIT_NPROC);
+
+	return limit;
+}
+
 /*
  * Create a new user namespace, deriving the creator from the user in the
  * passed credentials, and replacing that user with the new root user for the
@@ -122,7 +134,7 @@ int create_user_ns(struct cred *new)
 	for (i = 0; i < MAX_PER_NAMESPACE_UCOUNTS; i++) {
 		ns->ucount_max[i] = INT_MAX;
 	}
-	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC));
+	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, enforced_nproc_rlimit());
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MSGQUEUE, rlimit(RLIMIT_MSGQUEUE));
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_SIGPENDING, rlimit(RLIMIT_SIGPENDING));
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MEMLOCK, rlimit(RLIMIT_MEMLOCK));
diff --git a/mm/memfd.c b/mm/memfd.c
index 9f80f162791a..08f5f8304746 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -31,20 +31,28 @@
 static void memfd_tag_pins(struct xa_state *xas)
 {
 	struct page *page;
-	unsigned int tagged = 0;
+	int latency = 0;
+	int cache_count;
 
 	lru_add_drain();
 
 	xas_lock_irq(xas);
 	xas_for_each(xas, page, ULONG_MAX) {
-		if (xa_is_value(page))
-			continue;
-		page = find_subpage(page, xas->xa_index);
-		if (page_count(page) - page_mapcount(page) > 1)
+		cache_count = 1;
+		if (!xa_is_value(page) &&
+		    PageTransHuge(page) && !PageHuge(page))
+			cache_count = HPAGE_PMD_NR;
+
+		if (!xa_is_value(page) &&
+		    page_count(page) - total_mapcount(page) != cache_count)
 			xas_set_mark(xas, MEMFD_TAG_PINNED);
+		if (cache_count != 1)
+			xas_set(xas, page->index + cache_count);
 
-		if (++tagged % XA_CHECK_SCHED)
+		latency += cache_count;
+		if (latency < XA_CHECK_SCHED)
 			continue;
+		latency = 0;
 
 		xas_pause(xas);
 		xas_unlock_irq(xas);
@@ -73,7 +81,8 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 
 	error = 0;
 	for (scan = 0; scan <= LAST_SCAN; scan++) {
-		unsigned int tagged = 0;
+		int latency = 0;
+		int cache_count;
 
 		if (!xas_marked(&xas, MEMFD_TAG_PINNED))
 			break;
@@ -87,10 +96,14 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 		xas_lock_irq(&xas);
 		xas_for_each_marked(&xas, page, ULONG_MAX, MEMFD_TAG_PINNED) {
 			bool clear = true;
-			if (xa_is_value(page))
-				continue;
-			page = find_subpage(page, xas.xa_index);
-			if (page_count(page) - page_mapcount(page) != 1) {
+
+			cache_count = 1;
+			if (!xa_is_value(page) &&
+			    PageTransHuge(page) && !PageHuge(page))
+				cache_count = HPAGE_PMD_NR;
+
+			if (!xa_is_value(page) && cache_count !=
+			    page_count(page) - total_mapcount(page)) {
 				/*
 				 * On the last scan, we clean up all those tags
 				 * we inserted; but make a note that we still
@@ -103,8 +116,11 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 			}
 			if (clear)
 				xas_clear_mark(&xas, MEMFD_TAG_PINNED);
-			if (++tagged % XA_CHECK_SCHED)
+
+			latency += cache_count;
+			if (latency < XA_CHECK_SCHED)
 				continue;
+			latency = 0;
 
 			xas_pause(&xas);
 			xas_unlock_irq(&xas);
diff --git a/mm/util.c b/mm/util.c
index 741ba32a43ac..c8261c4ca58b 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -594,8 +594,10 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 		return ret;
 
 	/* Don't even allow crazy sizes */
-	if (WARN_ON_ONCE(size > INT_MAX))
+	if (unlikely(size > INT_MAX)) {
+		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
 		return NULL;
+	}
 
 	return __vmalloc_node(size, 1, flags, node,
 			__builtin_return_address(0));
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 8a2b78f9c4b2..35fadb924849 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -149,22 +149,25 @@ static bool batadv_is_on_batman_iface(const struct net_device *net_dev)
 	struct net *net = dev_net(net_dev);
 	struct net_device *parent_dev;
 	struct net *parent_net;
+	int iflink;
 	bool ret;
 
 	/* check if this is a batman-adv mesh interface */
 	if (batadv_softif_is_valid(net_dev))
 		return true;
 
-	/* no more parents..stop recursion */
-	if (dev_get_iflink(net_dev) == 0 ||
-	    dev_get_iflink(net_dev) == net_dev->ifindex)
+	iflink = dev_get_iflink(net_dev);
+	if (iflink == 0)
 		return false;
 
 	parent_net = batadv_getlink_net(net_dev, net);
 
+	/* iflink to itself, most likely physical device */
+	if (net == parent_net && iflink == net_dev->ifindex)
+		return false;
+
 	/* recurse over the parent device */
-	parent_dev = __dev_get_by_index((struct net *)parent_net,
-					dev_get_iflink(net_dev));
+	parent_dev = __dev_get_by_index((struct net *)parent_net, iflink);
 	/* if we got a NULL parent_dev there is something broken.. */
 	if (!parent_dev) {
 		pr_err("Cannot find parent device\n");
@@ -214,14 +217,15 @@ static struct net_device *batadv_get_real_netdevice(struct net_device *netdev)
 	struct net_device *real_netdev = NULL;
 	struct net *real_net;
 	struct net *net;
-	int ifindex;
+	int iflink;
 
 	ASSERT_RTNL();
 
 	if (!netdev)
 		return NULL;
 
-	if (netdev->ifindex == dev_get_iflink(netdev)) {
+	iflink = dev_get_iflink(netdev);
+	if (iflink == 0) {
 		dev_hold(netdev);
 		return netdev;
 	}
@@ -231,9 +235,16 @@ static struct net_device *batadv_get_real_netdevice(struct net_device *netdev)
 		goto out;
 
 	net = dev_net(hard_iface->soft_iface);
-	ifindex = dev_get_iflink(netdev);
 	real_net = batadv_getlink_net(netdev, net);
-	real_netdev = dev_get_by_index(real_net, ifindex);
+
+	/* iflink to itself, most likely physical device */
+	if (net == real_net && netdev->ifindex == iflink) {
+		real_netdev = netdev;
+		dev_hold(real_netdev);
+		goto out;
+	}
+
+	real_netdev = dev_get_by_index(real_net, iflink);
 
 out:
 	batadv_hardif_put(hard_iface);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f78969d8d816..56e23333e708 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3854,6 +3854,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		list_skb = list_skb->next;
 
 		err = 0;
+		delta_truesize += nskb->truesize;
 		if (skb_shared(nskb)) {
 			tmp = skb_clone(nskb, GFP_ATOMIC);
 			if (tmp) {
@@ -3878,7 +3879,6 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		tail = nskb;
 
 		delta_len += nskb->len;
-		delta_truesize += nskb->truesize;
 
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 8eb671c827f9..929a2b096b04 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1153,7 +1153,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 	struct sk_psock *psock;
 	struct bpf_prog *prog;
 	int ret = __SK_DROP;
-	int len = skb->len;
+	int len = orig_len;
 
 	/* clone here so sk_eat_skb() in tcp_read_sock does not drop our data */
 	skb = skb_clone(skb, GFP_ATOMIC);
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index b441ab330fd3..dc4fb699b56c 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -2073,8 +2073,52 @@ u8 dcb_ieee_getapp_default_prio_mask(const struct net_device *dev)
 }
 EXPORT_SYMBOL(dcb_ieee_getapp_default_prio_mask);
 
+static void dcbnl_flush_dev(struct net_device *dev)
+{
+	struct dcb_app_type *itr, *tmp;
+
+	spin_lock_bh(&dcb_lock);
+
+	list_for_each_entry_safe(itr, tmp, &dcb_app_list, list) {
+		if (itr->ifindex == dev->ifindex) {
+			list_del(&itr->list);
+			kfree(itr);
+		}
+	}
+
+	spin_unlock_bh(&dcb_lock);
+}
+
+static int dcbnl_netdevice_event(struct notifier_block *nb,
+				 unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		if (!dev->dcbnl_ops)
+			return NOTIFY_DONE;
+
+		dcbnl_flush_dev(dev);
+
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static struct notifier_block dcbnl_nb __read_mostly = {
+	.notifier_call  = dcbnl_netdevice_event,
+};
+
 static int __init dcbnl_init(void)
 {
+	int err;
+
+	err = register_netdevice_notifier(&dcbnl_nb);
+	if (err)
+		return err;
+
 	rtnl_register(PF_UNSPEC, RTM_GETDCB, dcb_doit, NULL, 0);
 	rtnl_register(PF_UNSPEC, RTM_SETDCB, dcb_doit, NULL, 0);
 
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 851f542928a3..e1b1d080e908 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -671,7 +671,7 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6652d96329a0..7c78e1215ae3 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3732,6 +3732,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifa, *tmp;
 	bool keep_addr = false;
+	bool was_ready;
 	int state, i;
 
 	ASSERT_RTNL();
@@ -3797,7 +3798,10 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 
 	addrconf_del_rs_timer(idev);
 
-	/* Step 2: clear flags for stateless addrconf */
+	/* Step 2: clear flags for stateless addrconf, repeated down
+	 *         detection
+	 */
+	was_ready = idev->if_flags & IF_READY;
 	if (!unregister)
 		idev->if_flags &= ~(IF_RS_SENT|IF_RA_RCVD|IF_READY);
 
@@ -3871,7 +3875,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 	if (unregister) {
 		ipv6_ac_destroy_dev(idev);
 		ipv6_mc_destroy_dev(idev);
-	} else {
+	} else if (was_ready) {
 		ipv6_mc_down(idev);
 	}
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index f0bac6f7ab6b..883b53fd7846 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -708,7 +708,7 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 22bf8fb61716..61970fd839c3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1408,8 +1408,6 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 		if (np->frag_size)
 			mtu = np->frag_size;
 	}
-	if (mtu < IPV6_MIN_MTU)
-		return -EINVAL;
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
@@ -1471,8 +1469,6 @@ static int __ip6_append_data(struct sock *sk,
 
 	fragheaderlen = sizeof(struct ipv6hdr) + rt->rt6i_nfheader_len +
 			(opt ? opt->opt_nflen : 0);
-	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
-		     sizeof(struct frag_hdr);
 
 	headersize = sizeof(struct ipv6hdr) +
 		     (opt ? opt->opt_flen + opt->opt_nflen : 0) +
@@ -1480,6 +1476,13 @@ static int __ip6_append_data(struct sock *sk,
 		      sizeof(struct frag_hdr) : 0) +
 		     rt->rt6i_nfheader_len;
 
+	if (mtu < fragheaderlen ||
+	    ((mtu - fragheaderlen) & ~7) + fragheaderlen < sizeof(struct frag_hdr))
+		goto emsgsize;
+
+	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
+		     sizeof(struct frag_hdr);
+
 	/* as per RFC 7112 section 5, the entire IPv6 Header Chain must fit
 	 * the first fragment
 	 */
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index a8861db52c18..909f937befd7 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1371,27 +1371,23 @@ static void mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_query(struct sk_buff *skb)
+void igmp6_event_query(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 
-	if (!idev)
-		return -EINVAL;
-
-	if (idev->dead) {
-		kfree_skb(skb);
-		return -ENODEV;
-	}
+	if (!idev || idev->dead)
+		goto out;
 
 	spin_lock_bh(&idev->mc_query_lock);
 	if (skb_queue_len(&idev->mc_query_queue) < MLD_MAX_SKBS) {
 		__skb_queue_tail(&idev->mc_query_queue, skb);
 		if (!mod_delayed_work(mld_wq, &idev->mc_query_work, 0))
 			in6_dev_hold(idev);
+		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_query_lock);
-
-	return 0;
+out:
+	kfree_skb(skb);
 }
 
 static void __mld_query_work(struct sk_buff *skb)
@@ -1542,27 +1538,23 @@ static void mld_query_work(struct work_struct *work)
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_report(struct sk_buff *skb)
+void igmp6_event_report(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 
-	if (!idev)
-		return -EINVAL;
-
-	if (idev->dead) {
-		kfree_skb(skb);
-		return -ENODEV;
-	}
+	if (!idev || idev->dead)
+		goto out;
 
 	spin_lock_bh(&idev->mc_report_lock);
 	if (skb_queue_len(&idev->mc_report_queue) < MLD_MAX_SKBS) {
 		__skb_queue_tail(&idev->mc_report_queue, skb);
 		if (!mod_delayed_work(mld_wq, &idev->mc_report_work, 0))
 			in6_dev_hold(idev);
+		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_report_lock);
-
-	return 0;
+out:
+	kfree_skb(skb);
 }
 
 static void __mld_report_work(struct sk_buff *skb)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 482c98ede19b..3354a3b905b8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -376,7 +376,7 @@ struct ieee80211_mgd_auth_data {
 
 	u8 key[WLAN_KEY_LEN_WEP104];
 	u8 key_len, key_idx;
-	bool done;
+	bool done, waiting;
 	bool peer_confirmed;
 	bool timeout_started;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 311b4d934495..404b84650161 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -37,6 +37,7 @@
 #define IEEE80211_AUTH_TIMEOUT_SAE	(HZ * 2)
 #define IEEE80211_AUTH_MAX_TRIES	3
 #define IEEE80211_AUTH_WAIT_ASSOC	(HZ * 5)
+#define IEEE80211_AUTH_WAIT_SAE_RETRY	(HZ * 2)
 #define IEEE80211_ASSOC_TIMEOUT		(HZ / 5)
 #define IEEE80211_ASSOC_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
@@ -3009,8 +3010,15 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		    (status_code == WLAN_STATUS_ANTI_CLOG_REQUIRED ||
 		     (auth_transaction == 1 &&
 		      (status_code == WLAN_STATUS_SAE_HASH_TO_ELEMENT ||
-		       status_code == WLAN_STATUS_SAE_PK))))
+		       status_code == WLAN_STATUS_SAE_PK)))) {
+			/* waiting for userspace now */
+			ifmgd->auth_data->waiting = true;
+			ifmgd->auth_data->timeout =
+				jiffies + IEEE80211_AUTH_WAIT_SAE_RETRY;
+			ifmgd->auth_data->timeout_started = true;
+			run_again(sdata, ifmgd->auth_data->timeout);
 			goto notify_driver;
+		}
 
 		sdata_info(sdata, "%pM denied authentication (status %d)\n",
 			   mgmt->sa, status_code);
@@ -4597,10 +4605,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 	if (ifmgd->auth_data && ifmgd->auth_data->timeout_started &&
 	    time_after(jiffies, ifmgd->auth_data->timeout)) {
-		if (ifmgd->auth_data->done) {
+		if (ifmgd->auth_data->done || ifmgd->auth_data->waiting) {
 			/*
-			 * ok ... we waited for assoc but userspace didn't,
-			 * so let's just kill the auth data
+			 * ok ... we waited for assoc or continuation but
+			 * userspace didn't do it, so kill the auth data
 			 */
 			ieee80211_destroy_auth_data(sdata, false);
 		} else if (ieee80211_auth(sdata)) {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d2e8b84ed283..2225b6b8689f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2602,7 +2602,8 @@ static void ieee80211_deliver_skb_to_local_stack(struct sk_buff *skb,
 		 * address, so that the authenticator (e.g. hostapd) will see
 		 * the frame, but bridge won't forward it anywhere else. Note
 		 * that due to earlier filtering, the only other address can
-		 * be the PAE group address.
+		 * be the PAE group address, unless the hardware allowed them
+		 * through in 802.3 offloaded mode.
 		 */
 		if (unlikely(skb->protocol == sdata->control_port_protocol &&
 			     !ether_addr_equal(ehdr->h_dest, sdata->vif.addr)))
@@ -2917,13 +2918,13 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    ether_addr_equal(sdata->vif.addr, hdr->addr3))
 		return RX_CONTINUE;
 
-	ac = ieee80211_select_queue_80211(sdata, skb, hdr);
+	ac = ieee802_1d_to_ac[skb->priority];
 	q = sdata->vif.hw_queue[ac];
 	if (ieee80211_queue_stopped(&local->hw, q)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
 		return RX_DROP_MONITOR;
 	}
-	skb_set_queue_mapping(skb, q);
+	skb_set_queue_mapping(skb, ac);
 
 	if (!--mesh_hdr->ttl) {
 		if (!is_multicast_ether_addr(hdr->addr1))
@@ -4509,12 +4510,7 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 
 	/* deliver to local stack */
 	skb->protocol = eth_type_trans(skb, fast_rx->dev);
-	memset(skb->cb, 0, sizeof(skb->cb));
-	if (rx->list)
-		list_add_tail(&skb->list, rx->list);
-	else
-		netif_receive_skb(skb);
-
+	ieee80211_deliver_skb_to_local_stack(skb, rx);
 }
 
 static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0cd55e4c30fa..7566c9dc6681 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -464,9 +464,12 @@ static bool mptcp_pending_data_fin(struct sock *sk, u64 *seq)
 static void mptcp_set_datafin_timeout(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	u32 retransmits;
 
-	mptcp_sk(sk)->timer_ival = min(TCP_RTO_MAX,
-				       TCP_RTO_MIN << icsk->icsk_retransmits);
+	retransmits = min_t(u32, icsk->icsk_retransmits,
+			    ilog2(TCP_RTO_MAX / TCP_RTO_MIN));
+
+	mptcp_sk(sk)->timer_ival = TCP_RTO_MIN << retransmits;
 }
 
 static void __mptcp_set_timeout(struct sock *sk, long tout)
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 6dec9cd395f1..c3634744e37b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -428,14 +428,15 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	p = nf_entry_dereference(*pp);
 	new_hooks = nf_hook_entries_grow(p, reg);
 
-	if (!IS_ERR(new_hooks))
+	if (!IS_ERR(new_hooks)) {
+		hooks_validate(new_hooks);
 		rcu_assign_pointer(*pp, new_hooks);
+	}
 
 	mutex_unlock(&nf_hook_mutex);
 	if (IS_ERR(new_hooks))
 		return PTR_ERR(new_hooks);
 
-	hooks_validate(new_hooks);
 #ifdef CONFIG_NETFILTER_INGRESS
 	if (nf_ingress_hook(reg, pf))
 		net_inc_ingress_queue();
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 6d12afabfe8a..63d1516816b1 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -46,6 +46,15 @@ void nf_unregister_queue_handler(void)
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 
+static void nf_queue_sock_put(struct sock *sk)
+{
+#ifdef CONFIG_INET
+	sock_gen_put(sk);
+#else
+	sock_put(sk);
+#endif
+}
+
 static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
@@ -54,7 +63,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	dev_put(state->in);
 	dev_put(state->out);
 	if (state->sk)
-		sock_put(state->sk);
+		nf_queue_sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	dev_put(entry->physin);
@@ -87,19 +96,21 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 }
 
 /* Bump dev refs so they don't vanish while packet is out */
-void nf_queue_entry_get_refs(struct nf_queue_entry *entry)
+bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
 
+	if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
+		return false;
+
 	dev_hold(state->in);
 	dev_hold(state->out);
-	if (state->sk)
-		sock_hold(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	dev_hold(entry->physin);
 	dev_hold(entry->physout);
 #endif
+	return true;
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
@@ -169,6 +180,18 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		break;
 	}
 
+	if (skb_sk_is_prefetched(skb)) {
+		struct sock *sk = skb->sk;
+
+		if (!sk_is_refcounted(sk)) {
+			if (!refcount_inc_not_zero(&sk->sk_refcnt))
+				return -ENOTCONN;
+
+			/* drop refcount on skb_orphan */
+			skb->destructor = sock_edemux;
+		}
+	}
+
 	entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
@@ -187,7 +210,10 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 
 	__nf_queue_entry_init_physdevs(entry);
 
-	nf_queue_entry_get_refs(entry);
+	if (!nf_queue_entry_get_refs(entry)) {
+		kfree(entry);
+		return -ENOTCONN;
+	}
 
 	switch (entry->state.pf) {
 	case AF_INET:
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a65b530975f5..2b2e0210a7f9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4486,7 +4486,7 @@ static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
 	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
 		list_del_rcu(&catchall->list);
 		nft_set_elem_destroy(set, catchall->elem, true);
-		kfree_rcu(catchall);
+		kfree_rcu(catchall, rcu);
 	}
 }
 
@@ -5653,7 +5653,7 @@ static void nft_setelem_catchall_remove(const struct net *net,
 	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
 		if (catchall->elem == elem->priv) {
 			list_del_rcu(&catchall->list);
-			kfree_rcu(catchall);
+			kfree_rcu(catchall, rcu);
 			break;
 		}
 	}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f0b9e21a2452..ff79c267d10c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -710,9 +710,15 @@ static struct nf_queue_entry *
 nf_queue_entry_dup(struct nf_queue_entry *e)
 {
 	struct nf_queue_entry *entry = kmemdup(e, e->size, GFP_ATOMIC);
-	if (entry)
-		nf_queue_entry_get_refs(entry);
-	return entry;
+
+	if (!entry)
+		return NULL;
+
+	if (nf_queue_entry_get_refs(entry))
+		return entry;
+
+	kfree(entry);
+	return NULL;
 }
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 10d2d81f9337..a0fb596459a3 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -183,7 +183,7 @@ static int smc_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
-	int rc = 0;
+	int old_state, rc = 0;
 
 	if (!sk)
 		goto out;
@@ -191,8 +191,10 @@ static int smc_release(struct socket *sock)
 	sock_hold(sk); /* sock_put below */
 	smc = smc_sk(sk);
 
+	old_state = sk->sk_state;
+
 	/* cleanup for a dangling non-blocking connect */
-	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
+	if (smc->connect_nonblock && old_state == SMC_INIT)
 		tcp_abort(smc->clcsock->sk, ECONNABORTED);
 
 	if (cancel_work_sync(&smc->connect_work))
@@ -206,6 +208,10 @@ static int smc_release(struct socket *sock)
 	else
 		lock_sock(sk);
 
+	if (old_state == SMC_INIT && sk->sk_state == SMC_ACTIVE &&
+	    !smc->use_fallback)
+		smc_close_active_abort(smc);
+
 	rc = __smc_release(smc);
 
 	/* detach socket */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 6dddcfd6cf73..d1cdc891c211 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1132,8 +1132,8 @@ void smc_conn_free(struct smc_connection *conn)
 			cancel_work_sync(&conn->abort_work);
 	}
 	if (!list_empty(&lgr->list)) {
-		smc_lgr_unregister_conn(conn);
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
+		smc_lgr_unregister_conn(conn);
 	}
 
 	if (!lgr->conns_num)
@@ -1783,7 +1783,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		    (ini->smcd_version == SMC_V2 ||
 		     lgr->vlan_id == ini->vlan_id) &&
 		    (role == SMC_CLNT || ini->is_smcd ||
-		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
+		    (lgr->conns_num < SMC_RMBS_PER_LGR_MAX &&
+		      !bitmap_full(lgr->rtokens_used_mask, SMC_RMBS_PER_LGR_MAX)))) {
 			/* link group found */
 			ini->first_contact_local = 0;
 			conn->lgr = lgr;
diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index d293614d5fc6..b5074957e881 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2287,7 +2287,7 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	struct tipc_crypto *tx = tipc_net(rx->net)->crypto_tx;
 	struct tipc_aead_key *skey = NULL;
 	u16 key_gen = msg_key_gen(hdr);
-	u16 size = msg_data_sz(hdr);
+	u32 size = msg_data_sz(hdr);
 	u8 *data = msg_data(hdr);
 	unsigned int keylen;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a27b3b5fa210..f73251828782 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13379,6 +13379,9 @@ static int handle_nan_filter(struct nlattr *attr_filter,
 	i = 0;
 	nla_for_each_nested(attr, attr_filter, rem) {
 		filter[i].filter = nla_memdup(attr, GFP_KERNEL);
+		if (!filter[i].filter)
+			goto err;
+
 		filter[i].len = nla_len(attr);
 		i++;
 	}
@@ -13391,6 +13394,15 @@ static int handle_nan_filter(struct nlattr *attr_filter,
 	}
 
 	return 0;
+
+err:
+	i = 0;
+	nla_for_each_nested(attr, attr_filter, rem) {
+		kfree(filter[i].filter);
+		i++;
+	}
+	kfree(filter);
+	return -ENOMEM;
 }
 
 static int nl80211_nan_add_func(struct sk_buff *skb,
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index e843b0d9e2a6..c255aac6b816 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -223,6 +223,9 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	if (x->encap || x->tfcpad)
 		return -EINVAL;
 
+	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND))
+		return -EINVAL;
+
 	dev = dev_get_by_index(net, xuo->ifindex);
 	if (!dev) {
 		if (!(xuo->flags & XFRM_OFFLOAD_INBOUND)) {
@@ -261,7 +264,8 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	xso->dev = dev;
 	xso->real_dev = dev;
 	xso->num_exthdrs = 1;
-	xso->flags = xuo->flags;
+	/* Don't forward bit that is not implemented */
+	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 57448fc519fc..4e3c62d1ad9e 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -673,12 +673,12 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 	struct net *net = xi->net;
 	struct xfrm_if_parms p = {};
 
+	xfrmi_netlink_parms(data, &p);
 	if (!p.if_id) {
 		NL_SET_ERR_MSG(extack, "if_id must be non zero");
 		return -EINVAL;
 	}
 
-	xfrmi_netlink_parms(data, &p);
 	xi = xfrmi_locate(net, &p);
 	if (!xi) {
 		xi = netdev_priv(dev);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 78d51399a0f4..100b4b3723e7 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2571,7 +2571,7 @@ void xfrm_state_delete_tunnel(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(xfrm_state_delete_tunnel);
 
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
+u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 {
 	const struct xfrm_type *type = READ_ONCE(x->type);
 	struct crypto_aead *aead;
@@ -2602,17 +2602,7 @@ u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
 	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
 		 net_adj) & ~(blksize - 1)) + net_adj - 2;
 }
-EXPORT_SYMBOL_GPL(__xfrm_state_mtu);
-
-u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
-{
-	mtu = __xfrm_state_mtu(x, mtu);
-
-	if (x->props.family == AF_INET6 && mtu < IPV6_MIN_MTU)
-		return IPV6_MIN_MTU;
-
-	return mtu;
-}
+EXPORT_SYMBOL_GPL(xfrm_state_mtu);
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {
diff --git a/sound/soc/codecs/cs4265.c b/sound/soc/codecs/cs4265.c
index cffd6111afac..b49cb92d7b9e 100644
--- a/sound/soc/codecs/cs4265.c
+++ b/sound/soc/codecs/cs4265.c
@@ -150,7 +150,6 @@ static const struct snd_kcontrol_new cs4265_snd_controls[] = {
 	SOC_SINGLE("E to F Buffer Disable Switch", CS4265_SPDIF_CTL1,
 				6, 1, 0),
 	SOC_ENUM("C Data Access", cam_mode_enum),
-	SOC_SINGLE("SPDIF Switch", CS4265_SPDIF_CTL2, 5, 1, 1),
 	SOC_SINGLE("Validity Bit Control Switch", CS4265_SPDIF_CTL2,
 				3, 1, 0),
 	SOC_ENUM("SPDIF Mono/Stereo", spdif_mono_stereo_enum),
@@ -186,7 +185,7 @@ static const struct snd_soc_dapm_widget cs4265_dapm_widgets[] = {
 
 	SND_SOC_DAPM_SWITCH("Loopback", SND_SOC_NOPM, 0, 0,
 			&loopback_ctl),
-	SND_SOC_DAPM_SWITCH("SPDIF", SND_SOC_NOPM, 0, 0,
+	SND_SOC_DAPM_SWITCH("SPDIF", CS4265_SPDIF_CTL2, 5, 1,
 			&spdif_switch),
 	SND_SOC_DAPM_SWITCH("DAC", CS4265_PWRCTL, 1, 1,
 			&dac_switch),
diff --git a/sound/soc/codecs/rt5668.c b/sound/soc/codecs/rt5668.c
index fb09715bf932..5b12cbf2ba21 100644
--- a/sound/soc/codecs/rt5668.c
+++ b/sound/soc/codecs/rt5668.c
@@ -1022,11 +1022,13 @@ static void rt5668_jack_detect_handler(struct work_struct *work)
 		container_of(work, struct rt5668_priv, jack_detect_work.work);
 	int val, btn_type;
 
-	while (!rt5668->component)
-		usleep_range(10000, 15000);
-
-	while (!rt5668->component->card->instantiated)
-		usleep_range(10000, 15000);
+	if (!rt5668->component || !rt5668->component->card ||
+	    !rt5668->component->card->instantiated) {
+		/* card not yet ready, try later */
+		mod_delayed_work(system_power_efficient_wq,
+				 &rt5668->jack_detect_work, msecs_to_jiffies(15));
+		return;
+	}
 
 	mutex_lock(&rt5668->calibrate_mutex);
 
diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 7e6e2f26accd..e3643ae6de66 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -1092,11 +1092,13 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 	struct snd_soc_dapm_context *dapm;
 	int val, btn_type;
 
-	while (!rt5682->component)
-		usleep_range(10000, 15000);
-
-	while (!rt5682->component->card->instantiated)
-		usleep_range(10000, 15000);
+	if (!rt5682->component || !rt5682->component->card ||
+	    !rt5682->component->card->instantiated) {
+		/* card not yet ready, try later */
+		mod_delayed_work(system_power_efficient_wq,
+				 &rt5682->jack_detect_work, msecs_to_jiffies(15));
+		return;
+	}
 
 	dapm = snd_soc_component_get_dapm(rt5682->component);
 
diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index d49a4f68566d..d79b548d23fa 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -824,11 +824,13 @@ static void rt5682s_jack_detect_handler(struct work_struct *work)
 		container_of(work, struct rt5682s_priv, jack_detect_work.work);
 	int val, btn_type;
 
-	while (!rt5682s->component)
-		usleep_range(10000, 15000);
-
-	while (!rt5682s->component->card->instantiated)
-		usleep_range(10000, 15000);
+	if (!rt5682s->component || !rt5682s->component->card ||
+	    !rt5682s->component->card->instantiated) {
+		/* card not yet ready, try later */
+		mod_delayed_work(system_power_efficient_wq,
+				 &rt5682s->jack_detect_work, msecs_to_jiffies(15));
+		return;
+	}
 
 	mutex_lock(&rt5682s->jdet_mutex);
 	mutex_lock(&rt5682s->calibrate_mutex);
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 53457a0d466d..ee3782ecd7e3 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -317,7 +317,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 		mask = BIT(sign_bit + 1) - 1;
 
 	val = ucontrol->value.integer.value[0];
-	if (mc->platform_max && val > mc->platform_max)
+	if (mc->platform_max && ((int)val + min) > mc->platform_max)
 		return -EINVAL;
 	if (val > max - min)
 		return -EINVAL;
@@ -330,7 +330,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	val = val << shift;
 	if (snd_soc_volsw_is_stereo(mc)) {
 		val2 = ucontrol->value.integer.value[1];
-		if (mc->platform_max && val2 > mc->platform_max)
+		if (mc->platform_max && ((int)val2 + min) > mc->platform_max)
 			return -EINVAL;
 		if (val2 > max - min)
 			return -EINVAL;
diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index 378826312abe..7aa947274900 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -1261,7 +1261,7 @@ static int had_pcm_mmap(struct snd_pcm_substream *substream,
 {
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	return remap_pfn_range(vma, vma->vm_start,
-			substream->dma_buffer.addr >> PAGE_SHIFT,
+			substream->runtime->dma_addr >> PAGE_SHIFT,
 			vma->vm_end - vma->vm_start, vma->vm_page_prot);
 }
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index bcb110e830ce..dea33dc93790 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -50,8 +50,8 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 			else
 				log_test "'$current_test' [$profile] overflow $target"
 			fi
+			RET_FIN=$(( RET_FIN || RET ))
 		done
-		RET_FIN=$(( RET_FIN || RET ))
 	done
 done
 current_test=""
diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
index 3e3e06ea5703..86e787895f78 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
@@ -60,7 +60,8 @@ __tc_police_test()
 
 	tc_police_rules_create $count $should_fail
 
-	offload_count=$(tc filter show dev $swp1 ingress | grep in_hw | wc -l)
+	offload_count=$(tc -j filter show dev $swp1 ingress |
+			jq "[.[] | select(.options.in_hw == true)] | length")
 	((offload_count == count))
 	check_err_fail $should_fail $? "tc police offload count"
 }
diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
index e96e279e0533..25432b8cd5bd 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
@@ -19,7 +19,7 @@ fail() { # mesg
 
 FILTER=set_ftrace_filter
 FUNC1="schedule"
-FUNC2="do_softirq"
+FUNC2="scheduler_tick"
 
 ALL_FUNCS="#### all functions enabled ####"
 
diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
index 0ebfe8b0e147..585f7a0c10cb 100644
--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall
+CFLAGS += -Wl,-no-as-needed -Wall -isystem ../../../../usr/include/
 LDFLAGS += -lpthread
 
 TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark
