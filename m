Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441206D02D1
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 13:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjC3LQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 07:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbjC3LQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 07:16:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772229774;
        Thu, 30 Mar 2023 04:16:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA1DF62010;
        Thu, 30 Mar 2023 11:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B662C4339C;
        Thu, 30 Mar 2023 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680174980;
        bh=eoN5O5bKMYHrUGV3z2JvfBHS55dN0cncFsGUhHzeB4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwbTjmgQRWrM6YsnmBQ4tPZ63I9ked25K/TVHhxh3a6WvaDnPMHXs8x2ikB0Gx/Ur
         15o0WNedXStDgQqbGp6dmEHloSzLtbLvARTh7IAsQ3NyjUocqJmQIwyX29HtUnP7yB
         H7h6RXJGSwQLw6SF1rtiJ+NPV9ts9qpxhhrHpvFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.22
Date:   Thu, 30 Mar 2023 13:16:16 +0200
Message-Id: <16801749753216@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <1680174975234192@kroah.com>
References: <1680174975234192@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 0a9f0770bdf3..c3d44de8850c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 21
+SUBLEVEL = 22
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm/boot/dts/e60k02.dtsi b/arch/arm/boot/dts/e60k02.dtsi
index 935e2359f8df..07ae96486385 100644
--- a/arch/arm/boot/dts/e60k02.dtsi
+++ b/arch/arm/boot/dts/e60k02.dtsi
@@ -302,6 +302,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
diff --git a/arch/arm/boot/dts/e70k02.dtsi b/arch/arm/boot/dts/e70k02.dtsi
index 27ef9a62b23c..a1f9fbd6004a 100644
--- a/arch/arm/boot/dts/e70k02.dtsi
+++ b/arch/arm/boot/dts/e70k02.dtsi
@@ -312,6 +312,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
diff --git a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
index 663ee9df79e6..d6eee157c63b 100644
--- a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
+++ b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
@@ -597,6 +597,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
index ca2a43e0cbf6..3af4c7636974 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -99,8 +99,6 @@ &eqos {
 	phy-handle = <&ethphy0>;
 	nvmem-cells = <&fec_mac1>;
 	nvmem-cell-names = "mac-address";
-	snps,reset-gpios = <&pca6416_1 2 GPIO_ACTIVE_LOW>;
-	snps,reset-delays-us = <10 20 200000>;
 	status = "okay";
 
 	mdio {
@@ -113,6 +111,10 @@ ethphy0: ethernet-phy@0 {
 			reg = <0>;
 			eee-broken-1000t;
 			qca,disable-smarteee;
+			qca,disable-hibernation-mode;
+			reset-gpios = <&pca6416_1 2 GPIO_ACTIVE_LOW>;
+			reset-assert-us = <20>;
+			reset-deassert-us = <200000>;
 			vddio-supply = <&vddio0>;
 
 			vddio0: vddio-regulator {
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
index 6357078185ed..0e8f0d7161ad 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
@@ -247,7 +247,7 @@ wm8960: codec@1a {
 		compatible = "wlf,wm8960";
 		reg = <0x1a>;
 		clocks = <&clk IMX8MM_CLK_SAI1_ROOT>;
-		clock-names = "mclk1";
+		clock-names = "mclk";
 		wlf,shared-lrclk;
 		#sound-dai-cells = <0>;
 	};
diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index ba29b5b556ff..37246ca9d907 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -295,6 +295,7 @@ spba2: spba-bus@30000000 {
 				sai2: sai@30020000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30020000 0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI2_IPG>,
 						<&clk IMX8MN_CLK_DUMMY>,
@@ -309,6 +310,7 @@ sai2: sai@30020000 {
 				sai3: sai@30030000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30030000 0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI3_IPG>,
 						 <&clk IMX8MN_CLK_DUMMY>,
@@ -323,6 +325,7 @@ sai3: sai@30030000 {
 				sai5: sai@30050000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30050000 0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI5_IPG>,
 						 <&clk IMX8MN_CLK_DUMMY>,
@@ -339,6 +342,7 @@ sai5: sai@30050000 {
 				sai6: sai@30060000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30060000  0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI6_IPG>,
 						 <&clk IMX8MN_CLK_DUMMY>,
@@ -396,6 +400,7 @@ spdif1: spdif@30090000 {
 				sai7: sai@300b0000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x300b0000 0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI7_IPG>,
 						 <&clk IMX8MN_CLK_DUMMY>,
diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 0247866fc86b..8ab9f8194702 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -150,6 +150,8 @@ system_counter: timer@44290000 {
 			lpi2c1: i2c@44340000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x44340000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C1_GATE>,
 					 <&clk IMX93_CLK_BUS_AON>;
@@ -160,6 +162,8 @@ lpi2c1: i2c@44340000 {
 			lpi2c2: i2c@44350000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x44350000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C2_GATE>,
 					 <&clk IMX93_CLK_BUS_AON>;
@@ -277,6 +281,8 @@ mu2: mailbox@42440000 {
 			lpi2c3: i2c@42530000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x42530000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C3_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -287,6 +293,8 @@ lpi2c3: i2c@42530000 {
 			lpi2c4: i2c@42540000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x42540000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 63 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C4_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -351,6 +359,8 @@ lpuart8: serial@426a0000 {
 			lpi2c5: i2c@426b0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426b0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 195 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C5_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -361,6 +371,8 @@ lpi2c5: i2c@426b0000 {
 			lpi2c6: i2c@426c0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426c0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C6_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -371,6 +383,8 @@ lpi2c6: i2c@426c0000 {
 			lpi2c7: i2c@426d0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426d0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C7_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -381,6 +395,8 @@ lpi2c7: i2c@426d0000 {
 			lpi2c8: i2c@426e0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426e0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C8_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 516e70bf04ce..346da6af51ac 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2077,6 +2077,8 @@ pcie1: pci@1c08000 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&pcie1_clkreq_n>;
 
+			dma-coherent;
+
 			iommus = <&apps_smmu 0x1c80 0x1>;
 
 			iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 4a527a64772b..47e09d96f609 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1810,7 +1810,7 @@ pcie0: pci@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommus = <&apps_smmu 0x1d80 0x7f>;
+			iommus = <&apps_smmu 0x1d80 0x3f>;
 			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
 				    <0x100 &apps_smmu 0x1d81 0x1>;
 
@@ -1909,7 +1909,7 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1e00 0x7f>;
+			iommus = <&apps_smmu 0x1e00 0x3f>;
 			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
 				    <0x100 &apps_smmu 0x1e01 0x1>;
 
diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index df0d888ffc00..4714d7bf03b9 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -3104,6 +3104,7 @@ ufs_mem_hc: ufshc@1d84000 {
 			power-domains = <&gcc UFS_PHY_GDSC>;
 
 			iommus = <&apps_smmu 0xe0 0x0>;
+			dma-coherent;
 
 			interconnects = <&aggre1_noc MASTER_UFS_MEM 0 &mc_virt SLAVE_EBI1 0>,
 					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_UFS_MEM_CFG 0>;
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index 5c8cba0efc63..a700807c9b6d 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/ptrace.h>
 #include <linux/kallsyms.h>
+#include <linux/extable.h>
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
@@ -545,7 +546,8 @@ static inline void bus_error030 (struct frame *fp)
 			errorcode |= 2;
 
 		if (mmusr & (MMU_I | MMU_WP)) {
-			if (ssw & 4) {
+			/* We might have an exception table for this PC */
+			if (ssw & 4 && !search_exception_tables(fp->ptregs.pc)) {
 				pr_err("Data %s fault at %#010lx in %s (pc=%#lx)\n",
 				       ssw & RW ? "read" : "write",
 				       fp->un.fmtb.daddr,
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 2a375637e007..911301224078 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -437,7 +437,7 @@ void __init paging_init(void)
 	}
 
 	min_addr = m68k_memory[0].addr;
-	max_addr = min_addr + m68k_memory[0].size;
+	max_addr = min_addr + m68k_memory[0].size - 1;
 	memblock_add_node(m68k_memory[0].addr, m68k_memory[0].size, 0,
 			  MEMBLOCK_NONE);
 	for (i = 1; i < m68k_num_memory;) {
@@ -452,21 +452,21 @@ void __init paging_init(void)
 		}
 		memblock_add_node(m68k_memory[i].addr, m68k_memory[i].size, i,
 				  MEMBLOCK_NONE);
-		addr = m68k_memory[i].addr + m68k_memory[i].size;
+		addr = m68k_memory[i].addr + m68k_memory[i].size - 1;
 		if (addr > max_addr)
 			max_addr = addr;
 		i++;
 	}
 	m68k_memoffset = min_addr - PAGE_OFFSET;
-	m68k_virt_to_node_shift = fls(max_addr - min_addr - 1) - 6;
+	m68k_virt_to_node_shift = fls(max_addr - min_addr) - 6;
 
 	module_fixup(NULL, __start_fixup, __stop_fixup);
 	flush_icache();
 
-	high_memory = phys_to_virt(max_addr);
+	high_memory = phys_to_virt(max_addr) + 1;
 
 	min_low_pfn = availmem >> PAGE_SHIFT;
-	max_pfn = max_low_pfn = max_addr >> PAGE_SHIFT;
+	max_pfn = max_low_pfn = (max_addr >> PAGE_SHIFT) + 1;
 
 	/* Reserve kernel text/data/bss and the memory allocated in head.S */
 	memblock_reserve(m68k_memory[0].addr, availmem - m68k_memory[0].addr);
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 8e5fd5682018..ae11d5647f9d 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -442,6 +442,28 @@ config TOOLCHAIN_HAS_ZIHINTPAUSE
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zihintpause)
 	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23600
 
+config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
+	def_bool y
+	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
+	depends on AS_IS_GNU && AS_VERSION >= 23800
+	help
+	  Newer binutils versions default to ISA spec version 20191213 which
+	  moves some instructions from the I extension to the Zicsr and Zifencei
+	  extensions.
+
+config TOOLCHAIN_NEEDS_OLD_ISA_SPEC
+	def_bool y
+	depends on TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
+	# https://github.com/llvm/llvm-project/commit/22e199e6afb1263c943c0c0d4498694e15bf8a16
+	depends on CC_IS_CLANG && CLANG_VERSION < 170000
+	help
+	  Certain versions of clang do not support zicsr and zifencei via -march
+	  but newer versions of binutils require it for the reasons noted in the
+	  help text of CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI. This
+	  option causes an older ISA spec compatible with these older versions
+	  of clang to be passed to GAS, which has the same result as passing zicsr
+	  and zifencei to -march.
+
 config FPU
 	bool "FPU support"
 	default y
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 8b4ddccea279..3cb876f83187 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -57,10 +57,12 @@ riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
 
-# Newer binutils versions default to ISA spec version 20191213 which moves some
-# instructions from the I extension to the Zicsr and Zifencei extensions.
-toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
-riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
+ifdef CONFIG_TOOLCHAIN_NEEDS_OLD_ISA_SPEC
+KBUILD_CFLAGS += -Wa,-misa-spec=2.2
+KBUILD_AFLAGS += -Wa,-misa-spec=2.2
+else
+riscv-march-$(CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI) := $(riscv-march-y)_zicsr_zifencei
+endif
 
 # Check if the toolchain supports Zicbom extension
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICBOM) := $(riscv-march-y)_zicbom
diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index 801019381dea..a09196f8de68 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -12,6 +12,8 @@
 #include <asm/errata_list.h>
 
 #ifdef CONFIG_MMU
+extern unsigned long asid_mask;
+
 static inline void local_flush_tlb_all(void)
 {
 	__asm__ __volatile__ ("sfence.vma" : : : "memory");
diff --git a/arch/riscv/include/uapi/asm/setup.h b/arch/riscv/include/uapi/asm/setup.h
new file mode 100644
index 000000000000..66b13a522880
--- /dev/null
+++ b/arch/riscv/include/uapi/asm/setup.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+
+#ifndef _UAPI_ASM_RISCV_SETUP_H
+#define _UAPI_ASM_RISCV_SETUP_H
+
+#define COMMAND_LINE_SIZE	1024
+
+#endif /* _UAPI_ASM_RISCV_SETUP_H */
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index 0f784e3d307b..12e22e7330e7 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -22,7 +22,7 @@ DEFINE_STATIC_KEY_FALSE(use_asid_allocator);
 
 static unsigned long asid_bits;
 static unsigned long num_asids;
-static unsigned long asid_mask;
+unsigned long asid_mask;
 
 static atomic_long_t current_version;
 
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 37ed760d007c..ef701fa83f36 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -42,7 +42,7 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 	/* check if the tlbflush needs to be sent to other CPUs */
 	broadcast = cpumask_any_but(cmask, cpuid) < nr_cpu_ids;
 	if (static_branch_unlikely(&use_asid_allocator)) {
-		unsigned long asid = atomic_long_read(&mm->context.id);
+		unsigned long asid = atomic_long_read(&mm->context.id) & asid_mask;
 
 		if (broadcast) {
 			sbi_remote_sfence_vma_asid(cmask, start, size, asid);
diff --git a/arch/sh/include/asm/processor_32.h b/arch/sh/include/asm/processor_32.h
index 27aebf1e75a2..3ef7adf739c8 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -50,6 +50,7 @@
 #define SR_FD		0x00008000
 #define SR_MD		0x40000000
 
+#define SR_USER_MASK	0x00000303	// M, Q, S, T bits
 /*
  * DSP structure and data
  */
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 90f495d35db2..a6bfc6f37491 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -115,6 +115,7 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p)
 {
 	unsigned int err = 0;
+	unsigned int sr = regs->sr & ~SR_USER_MASK;
 
 #define COPY(x)		err |= __get_user(regs->x, &sc->sc_##x)
 			COPY(regs[1]);
@@ -130,6 +131,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p
 	COPY(sr);	COPY(pc);
 #undef COPY
 
+	regs->sr = (regs->sr & SR_USER_MASK) | sr;
+
 #ifdef CONFIG_SH_FPU
 	if (boot_cpu_data.flags & CPU_HAS_FPU) {
 		int owned_fp;
diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 4386b10682ce..8ca5e827f30b 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -923,6 +923,7 @@ static int amd_pmu_v2_handle_irq(struct pt_regs *regs)
 
 		/* Event overflow */
 		handled++;
+		status &= ~mask;
 		perf_sample_data_init(&data, 0, hwc->last_period);
 
 		if (!x86_perf_event_set_period(event))
@@ -935,8 +936,6 @@ static int amd_pmu_v2_handle_irq(struct pt_regs *regs)
 
 		if (perf_event_overflow(event, &data, regs))
 			x86_pmu_stop(event, 0);
-
-		status &= ~mask;
 	}
 
 	/*
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 714166cc25f2..0bab497c9436 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1118,21 +1118,20 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
 	zerofrom = offsetof(struct xregs_state, extended_state_area);
 
 	/*
-	 * The ptrace buffer is in non-compacted XSAVE format.  In
-	 * non-compacted format disabled features still occupy state space,
-	 * but there is no state to copy from in the compacted
-	 * init_fpstate. The gap tracking will zero these states.
-	 */
-	mask = fpstate->user_xfeatures;
-
-	/*
-	 * Dynamic features are not present in init_fpstate. When they are
-	 * in an all zeros init state, remove those from 'mask' to zero
-	 * those features in the user buffer instead of retrieving them
-	 * from init_fpstate.
+	 * This 'mask' indicates which states to copy from fpstate.
+	 * Those extended states that are not present in fpstate are
+	 * either disabled or initialized:
+	 *
+	 * In non-compacted format, disabled features still occupy
+	 * state space but there is no state to copy from in the
+	 * compacted init_fpstate. The gap tracking will zero these
+	 * states.
+	 *
+	 * The extended features have an all zeroes init state. Thus,
+	 * remove them from 'mask' to zero those features in the user
+	 * buffer instead of retrieving them from init_fpstate.
 	 */
-	if (fpu_state_size_dynamic())
-		mask &= (header.xfeatures | xinit->header.xcomp_bv);
+	mask = header.xfeatures;
 
 	for_each_extended_xfeature(i, mask) {
 		/*
@@ -1151,9 +1150,8 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
 			pkru.pkru = pkru_val;
 			membuf_write(&to, &pkru, sizeof(pkru));
 		} else {
-			copy_feature(header.xfeatures & BIT_ULL(i), &to,
+			membuf_write(&to,
 				     __raw_xsave_addr(xsave, i),
-				     __raw_xsave_addr(xinit, i),
 				     xstate_sizes[i]);
 		}
 		/*
diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index c7afce465a07..e499c60c4579 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -384,29 +384,6 @@ static const struct acpi_device_id amd_hid_ids[] = {
 	{}
 };
 
-static int lps0_prefer_amd(const struct dmi_system_id *id)
-{
-	pr_debug("Using AMD GUID w/ _REV 2.\n");
-	rev_id = 2;
-	return 0;
-}
-static const struct dmi_system_id s2idle_dmi_table[] __initconst = {
-	{
-		/*
-		 * AMD Rembrandt based HP EliteBook 835/845/865 G9
-		 * Contains specialized AML in AMD/_REV 2 path to avoid
-		 * triggering a bug in Qualcomm WLAN firmware. This may be
-		 * removed in the future if that firmware is fixed.
-		 */
-		.callback = lps0_prefer_amd,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
-			DMI_MATCH(DMI_BOARD_NAME, "8990"),
-		},
-	},
-	{}
-};
-
 static int lps0_device_attach(struct acpi_device *adev,
 			      const struct acpi_device_id *not_used)
 {
@@ -586,7 +563,6 @@ static const struct platform_s2idle_ops acpi_s2idle_ops_lps0 = {
 
 void __init acpi_s2idle_setup(void)
 {
-	dmi_check_system(s2idle_dmi_table);
 	acpi_scan_add_handler(&lps0_handler);
 	s2idle_set_ops(&acpi_s2idle_ops_lps0);
 }
diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 4e816bb402f6..e45285d4e62a 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -200,39 +200,28 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
  * a hardcoded allowlist for D3 support, which was used for these platforms.
  *
  * This allows quirking on Linux in a similar fashion.
+ *
+ * Cezanne systems shouldn't *normally* need this as the BIOS includes
+ * StorageD3Enable.  But for two reasons we have added it.
+ * 1) The BIOS on a number of Dell systems have ambiguity
+ *    between the same value used for _ADR on ACPI nodes GPP1.DEV0 and GPP1.NVME.
+ *    GPP1.NVME is needed to get StorageD3Enable node set properly.
+ *    https://bugzilla.kernel.org/show_bug.cgi?id=216440
+ *    https://bugzilla.kernel.org/show_bug.cgi?id=216773
+ *    https://bugzilla.kernel.org/show_bug.cgi?id=217003
+ * 2) On at least one HP system StorageD3Enable is missing on the second NVME
+      disk in the system.
  */
 static const struct x86_cpu_id storage_d3_cpu_ids[] = {
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 96, NULL),	/* Renoir */
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 104, NULL),	/* Lucienne */
-	{}
-};
-
-static const struct dmi_system_id force_storage_d3_dmi[] = {
-	{
-		/*
-		 * _ADR is ambiguous between GPP1.DEV0 and GPP1.NVME
-		 * but .NVME is needed to get StorageD3Enable node
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=216440
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 14 7425 2-in-1"),
-		}
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 16 5625"),
-		}
-	},
+	X86_MATCH_VENDOR_FAM_MODEL(AMD, 25, 80, NULL),	/* Cezanne */
 	{}
 };
 
 bool force_storage_d3(void)
 {
-	const struct dmi_system_id *dmi_id = dmi_first_match(force_storage_d3_dmi);
-
-	return dmi_id || x86_match_cpu(storage_d3_cpu_ids);
+	return x86_match_cpu(storage_d3_cpu_ids);
 }
 
 /*
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 681cb3786794..49cb4537344a 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2909,6 +2909,7 @@ close_card_oam(struct idt77252_dev *card)
 
 				recycle_rx_pool_skb(card, &vc->rcv.rx_pool);
 			}
+			kfree(vc);
 		}
 	}
 }
@@ -2952,6 +2953,15 @@ open_card_ubr0(struct idt77252_dev *card)
 	return 0;
 }
 
+static void
+close_card_ubr0(struct idt77252_dev *card)
+{
+	struct vc_map *vc = card->vcs[0];
+
+	free_scq(card, vc->scq);
+	kfree(vc);
+}
+
 static int
 idt77252_dev_open(struct idt77252_dev *card)
 {
@@ -3001,6 +3011,7 @@ static void idt77252_dev_close(struct atm_dev *dev)
 	struct idt77252_dev *card = dev->dev_data;
 	u32 conf;
 
+	close_card_ubr0(card);
 	close_card_oam(card);
 
 	conf = SAR_CFG_RXPTH |	/* enable receive path           */
diff --git a/drivers/bluetooth/btqcomsmd.c b/drivers/bluetooth/btqcomsmd.c
index 2acb719e596f..11c7e04bf394 100644
--- a/drivers/bluetooth/btqcomsmd.c
+++ b/drivers/bluetooth/btqcomsmd.c
@@ -122,6 +122,21 @@ static int btqcomsmd_setup(struct hci_dev *hdev)
 	return 0;
 }
 
+static int btqcomsmd_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr)
+{
+	int ret;
+
+	ret = qca_set_bdaddr_rome(hdev, bdaddr);
+	if (ret)
+		return ret;
+
+	/* The firmware stops responding for a while after setting the bdaddr,
+	 * causing timeouts for subsequent commands. Sleep a bit to avoid this.
+	 */
+	usleep_range(1000, 10000);
+	return 0;
+}
+
 static int btqcomsmd_probe(struct platform_device *pdev)
 {
 	struct btqcomsmd *btq;
@@ -162,7 +177,7 @@ static int btqcomsmd_probe(struct platform_device *pdev)
 	hdev->close = btqcomsmd_close;
 	hdev->send = btqcomsmd_send;
 	hdev->setup = btqcomsmd_setup;
-	hdev->set_bdaddr = qca_set_bdaddr_rome;
+	hdev->set_bdaddr = btqcomsmd_set_bdaddr;
 
 	ret = hci_register_dev(hdev);
 	if (ret < 0)
diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
index 795be33f2892..02893600db39 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -354,6 +354,7 @@ static void btsdio_remove(struct sdio_func *func)
 
 	BT_DBG("func %p", func);
 
+	cancel_work_sync(&data->work);
 	if (!data)
 		return;
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 952dc9d2404e..90b85dcb138d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1020,21 +1020,11 @@ static int btusb_recv_bulk(struct btusb_data *data, void *buffer, int count)
 		hci_skb_expect(skb) -= len;
 
 		if (skb->len == HCI_ACL_HDR_SIZE) {
-			__u16 handle = __le16_to_cpu(hci_acl_hdr(skb)->handle);
 			__le16 dlen = hci_acl_hdr(skb)->dlen;
-			__u8 type;
 
 			/* Complete ACL header */
 			hci_skb_expect(skb) = __le16_to_cpu(dlen);
 
-			/* Detect if ISO packet has been sent over bulk */
-			if (hci_conn_num(data->hdev, ISO_LINK)) {
-				type = hci_conn_lookup_type(data->hdev,
-							    hci_handle(handle));
-				if (type == ISO_LINK)
-					hci_skb_pkt_type(skb) = HCI_ISODATA_PKT;
-			}
-
 			if (skb_tailroom(skb) < hci_skb_expect(skb)) {
 				kfree_skb(skb);
 				skb = NULL;
diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index 828c66bbaa67..55d917bd1f3f 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -204,8 +204,8 @@ static int weim_parse_dt(struct platform_device *pdev)
 	const struct of_device_id *of_id = of_match_device(weim_id_table,
 							   &pdev->dev);
 	const struct imx_weim_devtype *devtype = of_id->data;
+	int ret = 0, have_child = 0;
 	struct device_node *child;
-	int ret, have_child = 0;
 	struct weim_priv *priv;
 	void __iomem *base;
 	u32 reg;
diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 1e40cb035044..a455f3c0e98b 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -52,6 +52,39 @@ static bool mailbox_chan_available(struct device *dev, int idx)
 					   "#mbox-cells", idx, NULL);
 }
 
+static int mailbox_chan_validate(struct device *cdev)
+{
+	int num_mb, num_sh, ret = 0;
+	struct device_node *np = cdev->of_node;
+
+	num_mb = of_count_phandle_with_args(np, "mboxes", "#mbox-cells");
+	num_sh = of_count_phandle_with_args(np, "shmem", NULL);
+	/* Bail out if mboxes and shmem descriptors are inconsistent */
+	if (num_mb <= 0 || num_sh > 2 || num_mb != num_sh) {
+		dev_warn(cdev, "Invalid channel descriptor for '%s'\n",
+			 of_node_full_name(np));
+		return -EINVAL;
+	}
+
+	if (num_sh > 1) {
+		struct device_node *np_tx, *np_rx;
+
+		np_tx = of_parse_phandle(np, "shmem", 0);
+		np_rx = of_parse_phandle(np, "shmem", 1);
+		/* SCMI Tx and Rx shared mem areas have to be distinct */
+		if (!np_tx || !np_rx || np_tx == np_rx) {
+			dev_warn(cdev, "Invalid shmem descriptor for '%s'\n",
+				 of_node_full_name(np));
+			ret = -EINVAL;
+		}
+
+		of_node_put(np_tx);
+		of_node_put(np_rx);
+	}
+
+	return ret;
+}
+
 static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 			      bool tx)
 {
@@ -64,6 +97,10 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 	resource_size_t size;
 	struct resource res;
 
+	ret = mailbox_chan_validate(cdev);
+	if (ret)
+		return ret;
+
 	smbox = devm_kzalloc(dev, sizeof(*smbox), GFP_KERNEL);
 	if (!smbox)
 		return -ENOMEM;
diff --git a/drivers/firmware/efi/libstub/smbios.c b/drivers/firmware/efi/libstub/smbios.c
index 460418b7f5f5..aadb422b9637 100644
--- a/drivers/firmware/efi/libstub/smbios.c
+++ b/drivers/firmware/efi/libstub/smbios.c
@@ -36,7 +36,7 @@ const u8 *__efi_get_smbios_string(u8 type, int offset, int recsize)
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-	strtable = (u8 *)record + recsize;
+	strtable = (u8 *)record + record->length;
 	for (int i = 1; i < ((u8 *)record)[offset]; i++) {
 		int len = strlen(strtable);
 
diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index f06fdacc9bc8..e76d6803bdd0 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -341,7 +341,7 @@ static const struct fwnode_operations efifb_fwnode_ops = {
 #ifdef CONFIG_EFI
 static struct fwnode_handle efifb_fwnode;
 
-__init void sysfb_apply_efi_quirks(struct platform_device *pd)
+__init void sysfb_apply_efi_quirks(void)
 {
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI ||
 	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
@@ -355,7 +355,10 @@ __init void sysfb_apply_efi_quirks(struct platform_device *pd)
 		screen_info.lfb_height = temp;
 		screen_info.lfb_linelength = 4 * screen_info.lfb_width;
 	}
+}
 
+__init void sysfb_set_efifb_fwnode(struct platform_device *pd)
+{
 	if (screen_info.orig_video_isVGA == VIDEO_TYPE_EFI && IS_ENABLED(CONFIG_PCI)) {
 		fwnode_init(&efifb_fwnode, &efifb_fwnode_ops);
 		pd->dev.fwnode = &efifb_fwnode;
diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
index 3fd3563d962b..3c197db42c9d 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -81,6 +81,8 @@ static __init int sysfb_init(void)
 	if (disabled)
 		goto unlock_mutex;
 
+	sysfb_apply_efi_quirks();
+
 	/* try to create a simple-framebuffer device */
 	compatible = sysfb_parse_mode(si, &mode);
 	if (compatible) {
@@ -107,7 +109,7 @@ static __init int sysfb_init(void)
 		goto unlock_mutex;
 	}
 
-	sysfb_apply_efi_quirks(pd);
+	sysfb_set_efifb_fwnode(pd);
 
 	ret = platform_device_add_data(pd, si, sizeof(*si));
 	if (ret)
diff --git a/drivers/firmware/sysfb_simplefb.c b/drivers/firmware/sysfb_simplefb.c
index a353e27f83f5..ca907f7e76c6 100644
--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -110,7 +110,7 @@ __init struct platform_device *sysfb_create_simplefb(const struct screen_info *s
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
-	sysfb_apply_efi_quirks(pd);
+	sysfb_set_efifb_fwnode(pd);
 
 	ret = platform_device_add_resources(pd, &res, 1);
 	if (ret)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 5f1d0990c6f3..39c5e14b0252 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1263,6 +1263,7 @@ void amdgpu_device_pci_config_reset(struct amdgpu_device *adev);
 int amdgpu_device_pci_reset(struct amdgpu_device *adev);
 bool amdgpu_device_need_post(struct amdgpu_device *adev);
 bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev);
+bool amdgpu_device_aspm_support_quirk(void);
 
 void amdgpu_cs_report_moved_bytes(struct amdgpu_device *adev, u64 num_bytes,
 				  u64 num_vis_bytes);
@@ -1382,10 +1383,12 @@ int amdgpu_acpi_smart_shift_update(struct drm_device *dev, enum amdgpu_ss ss_sta
 int amdgpu_acpi_pcie_notify_device_ready(struct amdgpu_device *adev);
 
 void amdgpu_acpi_get_backlight_caps(struct amdgpu_dm_backlight_caps *caps);
+bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev);
 void amdgpu_acpi_detect(void);
 #else
 static inline int amdgpu_acpi_init(struct amdgpu_device *adev) { return 0; }
 static inline void amdgpu_acpi_fini(struct amdgpu_device *adev) { }
+static inline bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev) { return false; }
 static inline void amdgpu_acpi_detect(void) { }
 static inline bool amdgpu_acpi_is_power_shift_control_supported(void) { return false; }
 static inline int amdgpu_acpi_power_shift_control(struct amdgpu_device *adev,
@@ -1396,11 +1399,9 @@ static inline int amdgpu_acpi_smart_shift_update(struct drm_device *dev,
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
 bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev);
-bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev);
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
 #else
 static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
-static inline bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev) { return false; }
 static inline bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev) { return false; }
 #endif
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index b14800ac179e..435d81d6ffd9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -971,6 +971,29 @@ static bool amdgpu_atcs_pci_probe_handle(struct pci_dev *pdev)
 	return true;
 }
 
+
+/**
+ * amdgpu_acpi_should_gpu_reset
+ *
+ * @adev: amdgpu_device_pointer
+ *
+ * returns true if should reset GPU, false if not
+ */
+bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev)
+{
+	if (adev->flags & AMD_IS_APU)
+		return false;
+
+	if (amdgpu_sriov_vf(adev))
+		return false;
+
+#if IS_ENABLED(CONFIG_SUSPEND)
+	return pm_suspend_target_state != PM_SUSPEND_TO_IDLE;
+#else
+	return true;
+#endif
+}
+
 /*
  * amdgpu_acpi_detect - detect ACPI ATIF/ATCS methods
  *
@@ -1042,24 +1065,6 @@ bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev)
 		(pm_suspend_target_state == PM_SUSPEND_MEM);
 }
 
-/**
- * amdgpu_acpi_should_gpu_reset
- *
- * @adev: amdgpu_device_pointer
- *
- * returns true if should reset GPU, false if not
- */
-bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev)
-{
-	if (adev->flags & AMD_IS_APU)
-		return false;
-
-	if (amdgpu_sriov_vf(adev))
-		return false;
-
-	return pm_suspend_target_state != PM_SUSPEND_TO_IDLE;
-}
-
 /**
  * amdgpu_acpi_is_s0ix_active
  *
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 824b0b356b3c..9ef83f3ab3a7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -78,6 +78,10 @@
 
 #include <drm/drm_drv.h>
 
+#if IS_ENABLED(CONFIG_X86)
+#include <asm/intel-family.h>
+#endif
+
 MODULE_FIRMWARE("amdgpu/vega10_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/vega12_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/raven_gpu_info.bin");
@@ -1353,6 +1357,17 @@ bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev)
 	return pcie_aspm_enabled(adev->pdev);
 }
 
+bool amdgpu_device_aspm_support_quirk(void)
+{
+#if IS_ENABLED(CONFIG_X86)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
+#else
+	return true;
+#endif
+}
+
 /* if we get transitioned to only one device, take VGA back */
 /**
  * amdgpu_device_vga_set_decode - enable/disable vga decode
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index dfbeef2c4a9e..871f481f8432 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2447,7 +2447,10 @@ static int amdgpu_pmops_freeze(struct device *dev)
 	adev->in_s4 = false;
 	if (r)
 		return r;
-	return amdgpu_asic_reset(adev);
+
+	if (amdgpu_acpi_should_gpu_reset(adev))
+		return amdgpu_asic_reset(adev);
+	return 0;
 }
 
 static int amdgpu_pmops_thaw(struct device *dev)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index cfd78c4a45ba..4feedf518a19 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1312,7 +1312,7 @@ void amdgpu_bo_release_notify(struct ttm_buffer_object *bo)
 
 	if (!bo->resource || bo->resource->mem_type != TTM_PL_VRAM ||
 	    !(abo->flags & AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE) ||
-	    adev->in_suspend || adev->shutdown)
+	    adev->in_suspend || drm_dev_is_unplugged(adev_to_drm(adev)))
 		return;
 
 	if (WARN_ON_ONCE(!dma_resv_trylock(bo->base.resv)))
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
index 4b0d563c6522..4ef1fa4603c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
@@ -382,11 +382,6 @@ static void nbio_v7_2_init_registers(struct amdgpu_device *adev)
 		if (def != data)
 			WREG32_PCIE_PORT(SOC15_REG_OFFSET(NBIO, 0, regBIF1_PCIE_MST_CTRL_3), data);
 		break;
-	case IP_VERSION(7, 5, 1):
-		data = RREG32_SOC15(NBIO, 0, regRCC_DEV2_EPF0_STRAP2);
-		data &= ~RCC_DEV2_EPF0_STRAP2__STRAP_NO_SOFT_RESET_DEV2_F0_MASK;
-		WREG32_SOC15(NBIO, 0, regRCC_DEV2_EPF0_STRAP2, data);
-		fallthrough;
 	default:
 		def = data = RREG32_PCIE_PORT(SOC15_REG_OFFSET(NBIO, 0, regPCIE_CONFIG_CNTL));
 		data = REG_SET_FIELD(data, PCIE_CONFIG_CNTL,
@@ -399,6 +394,15 @@ static void nbio_v7_2_init_registers(struct amdgpu_device *adev)
 		break;
 	}
 
+	switch (adev->ip_versions[NBIO_HWIP][0]) {
+	case IP_VERSION(7, 3, 0):
+	case IP_VERSION(7, 5, 1):
+		data = RREG32_SOC15(NBIO, 0, regRCC_DEV2_EPF0_STRAP2);
+		data &= ~RCC_DEV2_EPF0_STRAP2__STRAP_NO_SOFT_RESET_DEV2_F0_MASK;
+		WREG32_SOC15(NBIO, 0, regRCC_DEV2_EPF0_STRAP2, data);
+		break;
+	}
+
 	if (amdgpu_sriov_vf(adev))
 		adev->rmmio_remap.reg_offset = SOC15_REG_OFFSET(NBIO, 0,
 			regBIF_BX_PF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
index df3388e8dec0..877989278290 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -527,7 +527,7 @@ static void nv_pcie_gen3_enable(struct amdgpu_device *adev)
 
 static void nv_program_aspm(struct amdgpu_device *adev)
 {
-	if (!amdgpu_device_should_use_aspm(adev))
+	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_aspm_support_quirk())
 		return;
 
 	if (!(adev->flags & AMD_IS_APU) &&
diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index f6ffd7c96ff9..d6c37c90c628 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -81,10 +81,6 @@
 #include "mxgpu_vi.h"
 #include "amdgpu_dm.h"
 
-#if IS_ENABLED(CONFIG_X86)
-#include <asm/intel-family.h>
-#endif
-
 #define ixPCIE_LC_L1_PM_SUBSTATE	0x100100C6
 #define PCIE_LC_L1_PM_SUBSTATE__LC_L1_SUBSTATES_OVERRIDE_EN_MASK	0x00000001L
 #define PCIE_LC_L1_PM_SUBSTATE__LC_PCI_PM_L1_2_OVERRIDE_MASK	0x00000002L
@@ -1138,24 +1134,13 @@ static void vi_enable_aspm(struct amdgpu_device *adev)
 		WREG32_PCIE(ixPCIE_LC_CNTL, data);
 }
 
-static bool aspm_support_quirk_check(void)
-{
-#if IS_ENABLED(CONFIG_X86)
-	struct cpuinfo_x86 *c = &cpu_data(0);
-
-	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
-#else
-	return true;
-#endif
-}
-
 static void vi_program_aspm(struct amdgpu_device *adev)
 {
 	u32 data, data1, orig;
 	bool bL1SS = false;
 	bool bClkReqSupport = true;
 
-	if (!amdgpu_device_should_use_aspm(adev) || !aspm_support_quirk_check())
+	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_aspm_support_quirk())
 		return;
 
 	if (adev->flags & AMD_IS_APU ||
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index 8bfdfd062ff6..e45c6bc8d10b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -50,16 +50,6 @@ static inline unsigned int get_and_inc_gpu_processor_id(
 	return current_id;
 }
 
-/* Static table to describe GPU Cache information */
-struct kfd_gpu_cache_info {
-	uint32_t	cache_size;
-	uint32_t	cache_level;
-	uint32_t	flags;
-	/* Indicates how many Compute Units share this cache
-	 * within a SA. Value = 1 indicates the cache is not shared
-	 */
-	uint32_t	num_cu_shared;
-};
 
 static struct kfd_gpu_cache_info kaveri_cache_info[] = {
 	{
@@ -891,6 +881,54 @@ static struct kfd_gpu_cache_info gc_10_3_6_cache_info[] = {
 	},
 };
 
+static struct kfd_gpu_cache_info dummy_cache_info[] = {
+	{
+		/* TCP L1 Cache per CU */
+		.cache_size = 16,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 1,
+	},
+	{
+		/* Scalar L1 Instruction Cache per SQC */
+		.cache_size = 32,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_INST_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* Scalar L1 Data Cache per SQC */
+		.cache_size = 16,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* GL1 Data Cache per SA */
+		.cache_size = 128,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 6,
+	},
+	{
+		/* L2 Data Cache per GPU (Total Tex Cache) */
+		.cache_size = 2048,
+		.cache_level = 2,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 6,
+	},
+};
+
 static void kfd_populated_cu_info_cpu(struct kfd_topology_device *dev,
 		struct crat_subtype_computeunit *cu)
 {
@@ -1071,8 +1109,12 @@ static int kfd_parse_subtype_cache(struct crat_subtype_cache *cache,
 			props->cachelines_per_tag = cache->lines_per_tag;
 			props->cache_assoc = cache->associativity;
 			props->cache_latency = cache->cache_latency;
+
 			memcpy(props->sibling_map, cache->sibling_map,
-					sizeof(props->sibling_map));
+					CRAT_SIBLINGMAP_SIZE);
+
+			/* set the sibling_map_size as 32 for CRAT from ACPI */
+			props->sibling_map_size = CRAT_SIBLINGMAP_SIZE;
 
 			if (cache->flags & CRAT_CACHE_FLAGS_DATA_CACHE)
 				props->cache_type |= HSA_CACHE_TYPE_DATA;
@@ -1291,125 +1333,6 @@ int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
 	return ret;
 }
 
-/* Helper function. See kfd_fill_gpu_cache_info for parameter description */
-static int fill_in_l1_pcache(struct crat_subtype_cache *pcache,
-				struct kfd_gpu_cache_info *pcache_info,
-				struct kfd_cu_info *cu_info,
-				int mem_available,
-				int cu_bitmask,
-				int cache_type, unsigned int cu_processor_id,
-				int cu_block)
-{
-	unsigned int cu_sibling_map_mask;
-	int first_active_cu;
-
-	/* First check if enough memory is available */
-	if (sizeof(struct crat_subtype_cache) > mem_available)
-		return -ENOMEM;
-
-	cu_sibling_map_mask = cu_bitmask;
-	cu_sibling_map_mask >>= cu_block;
-	cu_sibling_map_mask &=
-		((1 << pcache_info[cache_type].num_cu_shared) - 1);
-	first_active_cu = ffs(cu_sibling_map_mask);
-
-	/* CU could be inactive. In case of shared cache find the first active
-	 * CU. and incase of non-shared cache check if the CU is inactive. If
-	 * inactive active skip it
-	 */
-	if (first_active_cu) {
-		memset(pcache, 0, sizeof(struct crat_subtype_cache));
-		pcache->type = CRAT_SUBTYPE_CACHE_AFFINITY;
-		pcache->length = sizeof(struct crat_subtype_cache);
-		pcache->flags = pcache_info[cache_type].flags;
-		pcache->processor_id_low = cu_processor_id
-					 + (first_active_cu - 1);
-		pcache->cache_level = pcache_info[cache_type].cache_level;
-		pcache->cache_size = pcache_info[cache_type].cache_size;
-
-		/* Sibling map is w.r.t processor_id_low, so shift out
-		 * inactive CU
-		 */
-		cu_sibling_map_mask =
-			cu_sibling_map_mask >> (first_active_cu - 1);
-
-		pcache->sibling_map[0] = (uint8_t)(cu_sibling_map_mask & 0xFF);
-		pcache->sibling_map[1] =
-				(uint8_t)((cu_sibling_map_mask >> 8) & 0xFF);
-		pcache->sibling_map[2] =
-				(uint8_t)((cu_sibling_map_mask >> 16) & 0xFF);
-		pcache->sibling_map[3] =
-				(uint8_t)((cu_sibling_map_mask >> 24) & 0xFF);
-		return 0;
-	}
-	return 1;
-}
-
-/* Helper function. See kfd_fill_gpu_cache_info for parameter description */
-static int fill_in_l2_l3_pcache(struct crat_subtype_cache *pcache,
-				struct kfd_gpu_cache_info *pcache_info,
-				struct kfd_cu_info *cu_info,
-				int mem_available,
-				int cache_type, unsigned int cu_processor_id)
-{
-	unsigned int cu_sibling_map_mask;
-	int first_active_cu;
-	int i, j, k;
-
-	/* First check if enough memory is available */
-	if (sizeof(struct crat_subtype_cache) > mem_available)
-		return -ENOMEM;
-
-	cu_sibling_map_mask = cu_info->cu_bitmap[0][0];
-	cu_sibling_map_mask &=
-		((1 << pcache_info[cache_type].num_cu_shared) - 1);
-	first_active_cu = ffs(cu_sibling_map_mask);
-
-	/* CU could be inactive. In case of shared cache find the first active
-	 * CU. and incase of non-shared cache check if the CU is inactive. If
-	 * inactive active skip it
-	 */
-	if (first_active_cu) {
-		memset(pcache, 0, sizeof(struct crat_subtype_cache));
-		pcache->type = CRAT_SUBTYPE_CACHE_AFFINITY;
-		pcache->length = sizeof(struct crat_subtype_cache);
-		pcache->flags = pcache_info[cache_type].flags;
-		pcache->processor_id_low = cu_processor_id
-					 + (first_active_cu - 1);
-		pcache->cache_level = pcache_info[cache_type].cache_level;
-		pcache->cache_size = pcache_info[cache_type].cache_size;
-
-		/* Sibling map is w.r.t processor_id_low, so shift out
-		 * inactive CU
-		 */
-		cu_sibling_map_mask =
-			cu_sibling_map_mask >> (first_active_cu - 1);
-		k = 0;
-		for (i = 0; i < cu_info->num_shader_engines; i++) {
-			for (j = 0; j < cu_info->num_shader_arrays_per_engine;
-				j++) {
-				pcache->sibling_map[k] =
-				 (uint8_t)(cu_sibling_map_mask & 0xFF);
-				pcache->sibling_map[k+1] =
-				 (uint8_t)((cu_sibling_map_mask >> 8) & 0xFF);
-				pcache->sibling_map[k+2] =
-				 (uint8_t)((cu_sibling_map_mask >> 16) & 0xFF);
-				pcache->sibling_map[k+3] =
-				 (uint8_t)((cu_sibling_map_mask >> 24) & 0xFF);
-				k += 4;
-				cu_sibling_map_mask =
-					cu_info->cu_bitmap[i % 4][j + i / 4];
-				cu_sibling_map_mask &= (
-				 (1 << pcache_info[cache_type].num_cu_shared)
-				 - 1);
-			}
-		}
-		return 0;
-	}
-	return 1;
-}
-
-#define KFD_MAX_CACHE_TYPES 6
 
 static int kfd_fill_gpu_cache_info_from_gfx_config(struct kfd_dev *kdev,
 						   struct kfd_gpu_cache_info *pcache_info)
@@ -1483,228 +1406,134 @@ static int kfd_fill_gpu_cache_info_from_gfx_config(struct kfd_dev *kdev,
 	return i;
 }
 
-/* kfd_fill_gpu_cache_info - Fill GPU cache info using kfd_gpu_cache_info
- * tables
- *
- *	@kdev - [IN] GPU device
- *	@gpu_processor_id - [IN] GPU processor ID to which these caches
- *			    associate
- *	@available_size - [IN] Amount of memory available in pcache
- *	@cu_info - [IN] Compute Unit info obtained from KGD
- *	@pcache - [OUT] memory into which cache data is to be filled in.
- *	@size_filled - [OUT] amount of data used up in pcache.
- *	@num_of_entries - [OUT] number of caches added
- */
-static int kfd_fill_gpu_cache_info(struct kfd_dev *kdev,
-			int gpu_processor_id,
-			int available_size,
-			struct kfd_cu_info *cu_info,
-			struct crat_subtype_cache *pcache,
-			int *size_filled,
-			int *num_of_entries)
+int kfd_get_gpu_cache_info(struct kfd_dev *kdev, struct kfd_gpu_cache_info **pcache_info)
 {
-	struct kfd_gpu_cache_info *pcache_info;
-	struct kfd_gpu_cache_info cache_info[KFD_MAX_CACHE_TYPES];
 	int num_of_cache_types = 0;
-	int i, j, k;
-	int ct = 0;
-	int mem_available = available_size;
-	unsigned int cu_processor_id;
-	int ret;
-	unsigned int num_cu_shared;
 
 	switch (kdev->adev->asic_type) {
 	case CHIP_KAVERI:
-		pcache_info = kaveri_cache_info;
+		*pcache_info = kaveri_cache_info;
 		num_of_cache_types = ARRAY_SIZE(kaveri_cache_info);
 		break;
 	case CHIP_HAWAII:
-		pcache_info = hawaii_cache_info;
+		*pcache_info = hawaii_cache_info;
 		num_of_cache_types = ARRAY_SIZE(hawaii_cache_info);
 		break;
 	case CHIP_CARRIZO:
-		pcache_info = carrizo_cache_info;
+		*pcache_info = carrizo_cache_info;
 		num_of_cache_types = ARRAY_SIZE(carrizo_cache_info);
 		break;
 	case CHIP_TONGA:
-		pcache_info = tonga_cache_info;
+		*pcache_info = tonga_cache_info;
 		num_of_cache_types = ARRAY_SIZE(tonga_cache_info);
 		break;
 	case CHIP_FIJI:
-		pcache_info = fiji_cache_info;
+		*pcache_info = fiji_cache_info;
 		num_of_cache_types = ARRAY_SIZE(fiji_cache_info);
 		break;
 	case CHIP_POLARIS10:
-		pcache_info = polaris10_cache_info;
+		*pcache_info = polaris10_cache_info;
 		num_of_cache_types = ARRAY_SIZE(polaris10_cache_info);
 		break;
 	case CHIP_POLARIS11:
-		pcache_info = polaris11_cache_info;
+		*pcache_info = polaris11_cache_info;
 		num_of_cache_types = ARRAY_SIZE(polaris11_cache_info);
 		break;
 	case CHIP_POLARIS12:
-		pcache_info = polaris12_cache_info;
+		*pcache_info = polaris12_cache_info;
 		num_of_cache_types = ARRAY_SIZE(polaris12_cache_info);
 		break;
 	case CHIP_VEGAM:
-		pcache_info = vegam_cache_info;
+		*pcache_info = vegam_cache_info;
 		num_of_cache_types = ARRAY_SIZE(vegam_cache_info);
 		break;
 	default:
 		switch (KFD_GC_VERSION(kdev)) {
 		case IP_VERSION(9, 0, 1):
-			pcache_info = vega10_cache_info;
+			*pcache_info = vega10_cache_info;
 			num_of_cache_types = ARRAY_SIZE(vega10_cache_info);
 			break;
 		case IP_VERSION(9, 2, 1):
-			pcache_info = vega12_cache_info;
+			*pcache_info = vega12_cache_info;
 			num_of_cache_types = ARRAY_SIZE(vega12_cache_info);
 			break;
 		case IP_VERSION(9, 4, 0):
 		case IP_VERSION(9, 4, 1):
-			pcache_info = vega20_cache_info;
+			*pcache_info = vega20_cache_info;
 			num_of_cache_types = ARRAY_SIZE(vega20_cache_info);
 			break;
 		case IP_VERSION(9, 4, 2):
-			pcache_info = aldebaran_cache_info;
+			*pcache_info = aldebaran_cache_info;
 			num_of_cache_types = ARRAY_SIZE(aldebaran_cache_info);
 			break;
 		case IP_VERSION(9, 1, 0):
 		case IP_VERSION(9, 2, 2):
-			pcache_info = raven_cache_info;
+			*pcache_info = raven_cache_info;
 			num_of_cache_types = ARRAY_SIZE(raven_cache_info);
 			break;
 		case IP_VERSION(9, 3, 0):
-			pcache_info = renoir_cache_info;
+			*pcache_info = renoir_cache_info;
 			num_of_cache_types = ARRAY_SIZE(renoir_cache_info);
 			break;
 		case IP_VERSION(10, 1, 10):
 		case IP_VERSION(10, 1, 2):
 		case IP_VERSION(10, 1, 3):
 		case IP_VERSION(10, 1, 4):
-			pcache_info = navi10_cache_info;
+			*pcache_info = navi10_cache_info;
 			num_of_cache_types = ARRAY_SIZE(navi10_cache_info);
 			break;
 		case IP_VERSION(10, 1, 1):
-			pcache_info = navi14_cache_info;
+			*pcache_info = navi14_cache_info;
 			num_of_cache_types = ARRAY_SIZE(navi14_cache_info);
 			break;
 		case IP_VERSION(10, 3, 0):
-			pcache_info = sienna_cichlid_cache_info;
+			*pcache_info = sienna_cichlid_cache_info;
 			num_of_cache_types = ARRAY_SIZE(sienna_cichlid_cache_info);
 			break;
 		case IP_VERSION(10, 3, 2):
-			pcache_info = navy_flounder_cache_info;
+			*pcache_info = navy_flounder_cache_info;
 			num_of_cache_types = ARRAY_SIZE(navy_flounder_cache_info);
 			break;
 		case IP_VERSION(10, 3, 4):
-			pcache_info = dimgrey_cavefish_cache_info;
+			*pcache_info = dimgrey_cavefish_cache_info;
 			num_of_cache_types = ARRAY_SIZE(dimgrey_cavefish_cache_info);
 			break;
 		case IP_VERSION(10, 3, 1):
-			pcache_info = vangogh_cache_info;
+			*pcache_info = vangogh_cache_info;
 			num_of_cache_types = ARRAY_SIZE(vangogh_cache_info);
 			break;
 		case IP_VERSION(10, 3, 5):
-			pcache_info = beige_goby_cache_info;
+			*pcache_info = beige_goby_cache_info;
 			num_of_cache_types = ARRAY_SIZE(beige_goby_cache_info);
 			break;
 		case IP_VERSION(10, 3, 3):
-			pcache_info = yellow_carp_cache_info;
+			*pcache_info = yellow_carp_cache_info;
 			num_of_cache_types = ARRAY_SIZE(yellow_carp_cache_info);
 			break;
 		case IP_VERSION(10, 3, 6):
-			pcache_info = gc_10_3_6_cache_info;
+			*pcache_info = gc_10_3_6_cache_info;
 			num_of_cache_types = ARRAY_SIZE(gc_10_3_6_cache_info);
 			break;
 		case IP_VERSION(10, 3, 7):
-			pcache_info = gfx1037_cache_info;
+			*pcache_info = gfx1037_cache_info;
 			num_of_cache_types = ARRAY_SIZE(gfx1037_cache_info);
 			break;
 		case IP_VERSION(11, 0, 0):
 		case IP_VERSION(11, 0, 1):
 		case IP_VERSION(11, 0, 2):
 		case IP_VERSION(11, 0, 3):
-			pcache_info = cache_info;
+		case IP_VERSION(11, 0, 4):
 			num_of_cache_types =
-				kfd_fill_gpu_cache_info_from_gfx_config(kdev, pcache_info);
+				kfd_fill_gpu_cache_info_from_gfx_config(kdev, *pcache_info);
 			break;
 		default:
-			return -EINVAL;
-		}
-	}
-
-	*size_filled = 0;
-	*num_of_entries = 0;
-
-	/* For each type of cache listed in the kfd_gpu_cache_info table,
-	 * go through all available Compute Units.
-	 * The [i,j,k] loop will
-	 *		if kfd_gpu_cache_info.num_cu_shared = 1
-	 *			will parse through all available CU
-	 *		If (kfd_gpu_cache_info.num_cu_shared != 1)
-	 *			then it will consider only one CU from
-	 *			the shared unit
-	 */
-
-	for (ct = 0; ct < num_of_cache_types; ct++) {
-	  cu_processor_id = gpu_processor_id;
-	  if (pcache_info[ct].cache_level == 1) {
-	    for (i = 0; i < cu_info->num_shader_engines; i++) {
-	      for (j = 0; j < cu_info->num_shader_arrays_per_engine; j++) {
-	        for (k = 0; k < cu_info->num_cu_per_sh;
-		  k += pcache_info[ct].num_cu_shared) {
-		  ret = fill_in_l1_pcache(pcache,
-					pcache_info,
-					cu_info,
-					mem_available,
-					cu_info->cu_bitmap[i % 4][j + i / 4],
-					ct,
-					cu_processor_id,
-					k);
-
-		  if (ret < 0)
+			*pcache_info = dummy_cache_info;
+			num_of_cache_types = ARRAY_SIZE(dummy_cache_info);
+			pr_warn("dummy cache info is used temporarily and real cache info need update later.\n");
 			break;
-
-		  if (!ret) {
-				pcache++;
-				(*num_of_entries)++;
-				mem_available -= sizeof(*pcache);
-				(*size_filled) += sizeof(*pcache);
-		  }
-
-		  /* Move to next CU block */
-		  num_cu_shared = ((k + pcache_info[ct].num_cu_shared) <=
-					cu_info->num_cu_per_sh) ?
-					pcache_info[ct].num_cu_shared :
-					(cu_info->num_cu_per_sh - k);
-		  cu_processor_id += num_cu_shared;
 		}
-	      }
-	    }
-	  } else {
-			ret = fill_in_l2_l3_pcache(pcache,
-				pcache_info,
-				cu_info,
-				mem_available,
-				ct,
-				cu_processor_id);
-
-			if (ret < 0)
-				break;
-
-			if (!ret) {
-				pcache++;
-				(*num_of_entries)++;
-				mem_available -= sizeof(*pcache);
-				(*size_filled) += sizeof(*pcache);
-			}
-	  }
 	}
-
-	pr_debug("Added [%d] GPU cache entries\n", *num_of_entries);
-
-	return 0;
+	return num_of_cache_types;
 }
 
 static bool kfd_ignore_crat(void)
@@ -2263,8 +2092,6 @@ static int kfd_create_vcrat_image_gpu(void *pcrat_image,
 	struct kfd_cu_info cu_info;
 	int avail_size = *size;
 	uint32_t total_num_of_cu;
-	int num_of_cache_entries = 0;
-	int cache_mem_filled = 0;
 	uint32_t nid = 0;
 	int ret = 0;
 
@@ -2365,31 +2192,12 @@ static int kfd_create_vcrat_image_gpu(void *pcrat_image,
 	crat_table->length += sizeof(struct crat_subtype_memory);
 	crat_table->total_entries++;
 
-	/* TODO: Fill in cache information. This information is NOT readily
-	 * available in KGD
-	 */
-	sub_type_hdr = (typeof(sub_type_hdr))((char *)sub_type_hdr +
-		sub_type_hdr->length);
-	ret = kfd_fill_gpu_cache_info(kdev, cu->processor_id_low,
-				avail_size,
-				&cu_info,
-				(struct crat_subtype_cache *)sub_type_hdr,
-				&cache_mem_filled,
-				&num_of_cache_entries);
-
-	if (ret < 0)
-		return ret;
-
-	crat_table->length += cache_mem_filled;
-	crat_table->total_entries += num_of_cache_entries;
-	avail_size -= cache_mem_filled;
-
 	/* Fill in Subtype: IO_LINKS
 	 *  Only direct links are added here which is Link from GPU to
 	 *  its NUMA node. Indirect links are added by userspace.
 	 */
 	sub_type_hdr = (typeof(sub_type_hdr))((char *)sub_type_hdr +
-		cache_mem_filled);
+		sub_type_hdr->length);
 	ret = kfd_fill_gpu_direct_io_link_to_cpu(&avail_size, kdev,
 		(struct crat_subtype_iolink *)sub_type_hdr, proximity_domain);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.h b/drivers/gpu/drm/amd/amdkfd/kfd_crat.h
index 482ba84a728d..a8671061a175 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.h
@@ -317,6 +317,18 @@ struct cdit_header {
 
 struct kfd_dev;
 
+/* Static table to describe GPU Cache information */
+struct kfd_gpu_cache_info {
+	uint32_t	cache_size;
+	uint32_t	cache_level;
+	uint32_t	flags;
+	/* Indicates how many Compute Units share this cache
+	 * within a SA. Value = 1 indicates the cache is not shared
+	 */
+	uint32_t	num_cu_shared;
+};
+int kfd_get_gpu_cache_info(struct kfd_dev *kdev, struct kfd_gpu_cache_info **pcache_info);
+
 int kfd_create_crat_image_acpi(void **crat_image, size_t *size);
 void kfd_destroy_crat_image(void *crat_image);
 int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index a75e1af77365..27820f0a282d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -154,6 +154,7 @@ static void kfd_device_info_set_event_interrupt_class(struct kfd_dev *kfd)
 	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
+	case IP_VERSION(11, 0, 4):
 		kfd->device_info.event_interrupt_class = &event_interrupt_class_v11;
 		break;
 	default:
@@ -396,6 +397,7 @@ struct kfd_dev *kgd2kfd_probe(struct amdgpu_device *adev, bool vf)
 			f2g = &gfx_v11_kfd2kgd;
 			break;
 		case IP_VERSION(11, 0, 1):
+		case IP_VERSION(11, 0, 4):
 			gfx_target_version = 110003;
 			f2g = &gfx_v11_kfd2kgd;
 			break;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index 35a9b702508a..713f893d2530 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -364,7 +364,6 @@ static ssize_t kfd_cache_show(struct kobject *kobj, struct attribute *attr,
 
 	/* Making sure that the buffer is an empty string */
 	buffer[0] = 0;
-
 	cache = container_of(attr, struct kfd_cache_properties, attr);
 	if (cache->gpu && kfd_devcgroup_check_permission(cache->gpu))
 		return -EPERM;
@@ -379,12 +378,13 @@ static ssize_t kfd_cache_show(struct kobject *kobj, struct attribute *attr,
 	sysfs_show_32bit_prop(buffer, offs, "association", cache->cache_assoc);
 	sysfs_show_32bit_prop(buffer, offs, "latency", cache->cache_latency);
 	sysfs_show_32bit_prop(buffer, offs, "type", cache->cache_type);
+
 	offs += snprintf(buffer+offs, PAGE_SIZE-offs, "sibling_map ");
-	for (i = 0; i < CRAT_SIBLINGMAP_SIZE; i++)
+	for (i = 0; i < cache->sibling_map_size; i++)
 		for (j = 0; j < sizeof(cache->sibling_map[0])*8; j++)
 			/* Check each bit */
 			offs += snprintf(buffer+offs, PAGE_SIZE-offs, "%d,",
-					 (cache->sibling_map[i] >> j) & 1);
+						(cache->sibling_map[i] >> j) & 1);
 
 	/* Replace the last "," with end of line */
 	buffer[offs-1] = '\n';
@@ -1198,7 +1198,6 @@ static struct kfd_topology_device *kfd_assign_gpu(struct kfd_dev *gpu)
 	struct kfd_iolink_properties *iolink;
 	struct kfd_iolink_properties *p2plink;
 
-	down_write(&topology_lock);
 	list_for_each_entry(dev, &topology_device_list, list) {
 		/* Discrete GPUs need their own topology device list
 		 * entries. Don't assign them to CPU/APU nodes.
@@ -1222,7 +1221,6 @@ static struct kfd_topology_device *kfd_assign_gpu(struct kfd_dev *gpu)
 			break;
 		}
 	}
-	up_write(&topology_lock);
 	return out_dev;
 }
 
@@ -1593,6 +1591,221 @@ static int kfd_dev_create_p2p_links(void)
 	return ret;
 }
 
+
+/* Helper function. See kfd_fill_gpu_cache_info for parameter description */
+static int fill_in_l1_pcache(struct kfd_cache_properties **props_ext,
+				struct kfd_gpu_cache_info *pcache_info,
+				struct kfd_cu_info *cu_info,
+				int cu_bitmask,
+				int cache_type, unsigned int cu_processor_id,
+				int cu_block)
+{
+	unsigned int cu_sibling_map_mask;
+	int first_active_cu;
+	struct kfd_cache_properties *pcache = NULL;
+
+	cu_sibling_map_mask = cu_bitmask;
+	cu_sibling_map_mask >>= cu_block;
+	cu_sibling_map_mask &= ((1 << pcache_info[cache_type].num_cu_shared) - 1);
+	first_active_cu = ffs(cu_sibling_map_mask);
+
+	/* CU could be inactive. In case of shared cache find the first active
+	 * CU. and incase of non-shared cache check if the CU is inactive. If
+	 * inactive active skip it
+	 */
+	if (first_active_cu) {
+		pcache = kfd_alloc_struct(pcache);
+		if (!pcache)
+			return -ENOMEM;
+
+		memset(pcache, 0, sizeof(struct kfd_cache_properties));
+		pcache->processor_id_low = cu_processor_id + (first_active_cu - 1);
+		pcache->cache_level = pcache_info[cache_type].cache_level;
+		pcache->cache_size = pcache_info[cache_type].cache_size;
+
+		if (pcache_info[cache_type].flags & CRAT_CACHE_FLAGS_DATA_CACHE)
+			pcache->cache_type |= HSA_CACHE_TYPE_DATA;
+		if (pcache_info[cache_type].flags & CRAT_CACHE_FLAGS_INST_CACHE)
+			pcache->cache_type |= HSA_CACHE_TYPE_INSTRUCTION;
+		if (pcache_info[cache_type].flags & CRAT_CACHE_FLAGS_CPU_CACHE)
+			pcache->cache_type |= HSA_CACHE_TYPE_CPU;
+		if (pcache_info[cache_type].flags & CRAT_CACHE_FLAGS_SIMD_CACHE)
+			pcache->cache_type |= HSA_CACHE_TYPE_HSACU;
+
+		/* Sibling map is w.r.t processor_id_low, so shift out
+		 * inactive CU
+		 */
+		cu_sibling_map_mask =
+			cu_sibling_map_mask >> (first_active_cu - 1);
+
+		pcache->sibling_map[0] = (uint8_t)(cu_sibling_map_mask & 0xFF);
+		pcache->sibling_map[1] =
+				(uint8_t)((cu_sibling_map_mask >> 8) & 0xFF);
+		pcache->sibling_map[2] =
+				(uint8_t)((cu_sibling_map_mask >> 16) & 0xFF);
+		pcache->sibling_map[3] =
+				(uint8_t)((cu_sibling_map_mask >> 24) & 0xFF);
+
+		pcache->sibling_map_size = 4;
+		*props_ext = pcache;
+
+		return 0;
+	}
+	return 1;
+}
+
+/* Helper function. See kfd_fill_gpu_cache_info for parameter description */
+static int fill_in_l2_l3_pcache(struct kfd_cache_properties **props_ext,
+				struct kfd_gpu_cache_info *pcache_info,
+				struct kfd_cu_info *cu_info,
+				int cache_type, unsigned int cu_processor_id)
+{
+	unsigned int cu_sibling_map_mask;
+	int first_active_cu;
+	int i, j, k;
+	struct kfd_cache_properties *pcache = NULL;
+
+	cu_sibling_map_mask = cu_info->cu_bitmap[0][0];
+	cu_sibling_map_mask &=
+		((1 << pcache_info[cache_type].num_cu_shared) - 1);
+	first_active_cu = ffs(cu_sibling_map_mask);
+
+	/* CU could be inactive. In case of shared cache find the first active
+	 * CU. and incase of non-shared cache check if the CU is inactive. If
+	 * inactive active skip it
+	 */
+	if (first_active_cu) {
+		pcache = kfd_alloc_struct(pcache);
+		if (!pcache)
+			return -ENOMEM;
+
+		memset(pcache, 0, sizeof(struct kfd_cache_properties));
+		pcache->processor_id_low = cu_processor_id
+					+ (first_active_cu - 1);
+		pcache->cache_level = pcache_info[cache_type].cache_level;
+		pcache->cache_size = pcache_info[cache_type].cache_size;
+
+		if (pcache_info[cache_type].flags & CRAT_CACHE_FLAGS_DATA_CACHE)
+			pcache->cache_type |= HSA_CACHE_TYPE_DATA;
+		if (pcache_info[cache_type].flags & CRAT_CACHE_FLAGS_INST_CACHE)
+			pcache->cache_type |= HSA_CACHE_TYPE_INSTRUCTION;
+		if (pcache_info[cache_type].flags & CRAT_CACHE_FLAGS_CPU_CACHE)
+			pcache->cache_type |= HSA_CACHE_TYPE_CPU;
+		if (pcache_info[cache_type].flags & CRAT_CACHE_FLAGS_SIMD_CACHE)
+			pcache->cache_type |= HSA_CACHE_TYPE_HSACU;
+
+		/* Sibling map is w.r.t processor_id_low, so shift out
+		 * inactive CU
+		 */
+		cu_sibling_map_mask = cu_sibling_map_mask >> (first_active_cu - 1);
+		k = 0;
+
+		for (i = 0; i < cu_info->num_shader_engines; i++) {
+			for (j = 0; j < cu_info->num_shader_arrays_per_engine; j++) {
+				pcache->sibling_map[k] = (uint8_t)(cu_sibling_map_mask & 0xFF);
+				pcache->sibling_map[k+1] = (uint8_t)((cu_sibling_map_mask >> 8) & 0xFF);
+				pcache->sibling_map[k+2] = (uint8_t)((cu_sibling_map_mask >> 16) & 0xFF);
+				pcache->sibling_map[k+3] = (uint8_t)((cu_sibling_map_mask >> 24) & 0xFF);
+				k += 4;
+
+				cu_sibling_map_mask = cu_info->cu_bitmap[i % 4][j + i / 4];
+				cu_sibling_map_mask &= ((1 << pcache_info[cache_type].num_cu_shared) - 1);
+			}
+		}
+		pcache->sibling_map_size = k;
+		*props_ext = pcache;
+		return 0;
+	}
+	return 1;
+}
+
+#define KFD_MAX_CACHE_TYPES 6
+
+/* kfd_fill_cache_non_crat_info - Fill GPU cache info using kfd_gpu_cache_info
+ * tables
+ */
+void kfd_fill_cache_non_crat_info(struct kfd_topology_device *dev, struct kfd_dev *kdev)
+{
+	struct kfd_gpu_cache_info *pcache_info = NULL;
+	int i, j, k;
+	int ct = 0;
+	unsigned int cu_processor_id;
+	int ret;
+	unsigned int num_cu_shared;
+	struct kfd_cu_info cu_info;
+	struct kfd_cu_info *pcu_info;
+	int gpu_processor_id;
+	struct kfd_cache_properties *props_ext;
+	int num_of_entries = 0;
+	int num_of_cache_types = 0;
+	struct kfd_gpu_cache_info cache_info[KFD_MAX_CACHE_TYPES];
+
+	amdgpu_amdkfd_get_cu_info(kdev->adev, &cu_info);
+	pcu_info = &cu_info;
+
+	gpu_processor_id = dev->node_props.simd_id_base;
+
+	pcache_info = cache_info;
+	num_of_cache_types = kfd_get_gpu_cache_info(kdev, &pcache_info);
+	if (!num_of_cache_types) {
+		pr_warn("no cache info found\n");
+		return;
+	}
+
+	/* For each type of cache listed in the kfd_gpu_cache_info table,
+	 * go through all available Compute Units.
+	 * The [i,j,k] loop will
+	 *		if kfd_gpu_cache_info.num_cu_shared = 1
+	 *			will parse through all available CU
+	 *		If (kfd_gpu_cache_info.num_cu_shared != 1)
+	 *			then it will consider only one CU from
+	 *			the shared unit
+	 */
+	for (ct = 0; ct < num_of_cache_types; ct++) {
+		cu_processor_id = gpu_processor_id;
+		if (pcache_info[ct].cache_level == 1) {
+			for (i = 0; i < pcu_info->num_shader_engines; i++) {
+				for (j = 0; j < pcu_info->num_shader_arrays_per_engine; j++) {
+					for (k = 0; k < pcu_info->num_cu_per_sh; k += pcache_info[ct].num_cu_shared) {
+
+						ret = fill_in_l1_pcache(&props_ext, pcache_info, pcu_info,
+										pcu_info->cu_bitmap[i % 4][j + i / 4], ct,
+										cu_processor_id, k);
+
+						if (ret < 0)
+							break;
+
+						if (!ret) {
+							num_of_entries++;
+							list_add_tail(&props_ext->list, &dev->cache_props);
+						}
+
+						/* Move to next CU block */
+						num_cu_shared = ((k + pcache_info[ct].num_cu_shared) <=
+							pcu_info->num_cu_per_sh) ?
+							pcache_info[ct].num_cu_shared :
+							(pcu_info->num_cu_per_sh - k);
+						cu_processor_id += num_cu_shared;
+					}
+				}
+			}
+		} else {
+			ret = fill_in_l2_l3_pcache(&props_ext, pcache_info,
+								pcu_info, ct, cu_processor_id);
+
+			if (ret < 0)
+				break;
+
+			if (!ret) {
+				num_of_entries++;
+				list_add_tail(&props_ext->list, &dev->cache_props);
+			}
+		}
+	}
+	dev->node_props.caches_count += num_of_entries;
+	pr_debug("Added [%d] GPU cache entries\n", num_of_entries);
+}
+
 int kfd_topology_add_device(struct kfd_dev *gpu)
 {
 	uint32_t gpu_id;
@@ -1617,9 +1830,9 @@ int kfd_topology_add_device(struct kfd_dev *gpu)
 	 * CRAT to create a new topology device. Once created assign the gpu to
 	 * that topology device
 	 */
+	down_write(&topology_lock);
 	dev = kfd_assign_gpu(gpu);
 	if (!dev) {
-		down_write(&topology_lock);
 		proximity_domain = ++topology_crat_proximity_domain;
 
 		res = kfd_create_crat_image_virtual(&crat_image, &image_size,
@@ -1631,6 +1844,7 @@ int kfd_topology_add_device(struct kfd_dev *gpu)
 			topology_crat_proximity_domain--;
 			return res;
 		}
+
 		res = kfd_parse_crat_table(crat_image,
 					   &temp_topology_device_list,
 					   proximity_domain);
@@ -1644,23 +1858,28 @@ int kfd_topology_add_device(struct kfd_dev *gpu)
 		kfd_topology_update_device_list(&temp_topology_device_list,
 			&topology_device_list);
 
+		dev = kfd_assign_gpu(gpu);
+		if (WARN_ON(!dev)) {
+			res = -ENODEV;
+			goto err;
+		}
+
+		/* Fill the cache affinity information here for the GPUs
+		 * using VCRAT
+		 */
+		kfd_fill_cache_non_crat_info(dev, gpu);
+
 		/* Update the SYSFS tree, since we added another topology
 		 * device
 		 */
 		res = kfd_topology_update_sysfs();
-		up_write(&topology_lock);
-
 		if (!res)
 			sys_props.generation_count++;
 		else
 			pr_err("Failed to update GPU (ID: 0x%x) to sysfs topology. res=%d\n",
 						gpu_id, res);
-		dev = kfd_assign_gpu(gpu);
-		if (WARN_ON(!dev)) {
-			res = -ENODEV;
-			goto err;
-		}
 	}
+	up_write(&topology_lock);
 
 	dev->gpu_id = gpu_id;
 	gpu->id = gpu_id;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.h b/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
index 9f6c949186c1..19283b8b1688 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
@@ -80,6 +80,8 @@ struct kfd_mem_properties {
 	struct attribute	attr;
 };
 
+#define CACHE_SIBLINGMAP_SIZE 64
+
 struct kfd_cache_properties {
 	struct list_head	list;
 	uint32_t		processor_id_low;
@@ -90,10 +92,11 @@ struct kfd_cache_properties {
 	uint32_t		cache_assoc;
 	uint32_t		cache_latency;
 	uint32_t		cache_type;
-	uint8_t			sibling_map[CRAT_SIBLINGMAP_SIZE];
+	uint8_t			sibling_map[CACHE_SIBLINGMAP_SIZE];
 	struct kfd_dev		*gpu;
 	struct kobject		*kobj;
 	struct attribute	attr;
+	uint32_t		sibling_map_size;
 };
 
 struct kfd_iolink_properties {
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
index 24715ca2fa94..01383aac6b41 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
@@ -529,6 +529,19 @@ static struct clk_bw_params vg_bw_params = {
 
 };
 
+static uint32_t find_max_clk_value(const uint32_t clocks[], uint32_t num_clocks)
+{
+	uint32_t max = 0;
+	int i;
+
+	for (i = 0; i < num_clocks; ++i) {
+		if (clocks[i] > max)
+			max = clocks[i];
+	}
+
+	return max;
+}
+
 static unsigned int find_dcfclk_for_voltage(const struct vg_dpm_clocks *clock_table,
 		unsigned int voltage)
 {
@@ -572,12 +585,16 @@ static void vg_clk_mgr_helper_populate_bw_params(
 
 	bw_params->clk_table.num_entries = j + 1;
 
-	for (i = 0; i < bw_params->clk_table.num_entries; i++, j--) {
+	for (i = 0; i < bw_params->clk_table.num_entries - 1; i++, j--) {
 		bw_params->clk_table.entries[i].fclk_mhz = clock_table->DfPstateTable[j].fclk;
 		bw_params->clk_table.entries[i].memclk_mhz = clock_table->DfPstateTable[j].memclk;
 		bw_params->clk_table.entries[i].voltage = clock_table->DfPstateTable[j].voltage;
 		bw_params->clk_table.entries[i].dcfclk_mhz = find_dcfclk_for_voltage(clock_table, clock_table->DfPstateTable[j].voltage);
 	}
+	bw_params->clk_table.entries[i].fclk_mhz = clock_table->DfPstateTable[j].fclk;
+	bw_params->clk_table.entries[i].memclk_mhz = clock_table->DfPstateTable[j].memclk;
+	bw_params->clk_table.entries[i].voltage = clock_table->DfPstateTable[j].voltage;
+	bw_params->clk_table.entries[i].dcfclk_mhz = find_max_clk_value(clock_table->DcfClocks, VG_NUM_DCFCLK_DPM_LEVELS);
 
 	bw_params->vram_type = bios_info->memory_type;
 	bw_params->num_channels = bios_info->ma_channel_number;
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 328c5e33cc66..bf7fcd268cb4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1016,6 +1016,7 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 	struct dc_sink *prev_sink = NULL;
 	struct dpcd_caps prev_dpcd_caps;
 	enum dc_connection_type new_connection_type = dc_connection_none;
+	enum dc_connection_type pre_connection_type = link->type;
 	const uint32_t post_oui_delay = 30; // 30ms
 
 	DC_LOGGER_INIT(link->ctx->logger);
@@ -1118,6 +1119,8 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 			}
 
 			if (!detect_dp(link, &sink_caps, reason)) {
+				link->type = pre_connection_type;
+
 				if (prev_sink)
 					dc_sink_release(prev_sink);
 				return false;
@@ -1349,6 +1352,8 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 	bool is_delegated_to_mst_top_mgr = false;
 	enum dc_connection_type pre_link_type = link->type;
 
+	DC_LOGGER_INIT(link->ctx->logger);
+
 	is_local_sink_detect_success = detect_link_and_local_sink(link, reason);
 
 	if (is_local_sink_detect_success && link->local_sink)
@@ -1359,6 +1364,10 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 			link->dpcd_caps.is_mst_capable)
 		is_delegated_to_mst_top_mgr = discover_dp_mst_topology(link, reason);
 
+	DC_LOG_DC("%s: link_index=%d is_local_sink_detect_success=%d pre_link_type=%d link_type=%d\n", __func__,
+		 link->link_index, is_local_sink_detect_success, pre_link_type, link->type);
+
+
 	if (is_local_sink_detect_success &&
 			pre_link_type == dc_connection_mst_branch &&
 			link->type != dc_connection_mst_branch)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
index e4472c6be6c3..3fb4bcc34353 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
@@ -271,8 +271,7 @@ static void dccg32_set_dpstreamclk(
 	dccg32_set_dtbclk_p_src(dccg, src, otg_inst);
 
 	/* enabled to select one of the DTBCLKs for pipe */
-	switch (otg_inst)
-	{
+	switch (dp_hpo_inst) {
 	case 0:
 		REG_UPDATE_2(DPSTREAMCLK_CNTL,
 			     DPSTREAMCLK0_EN,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index d0b46a3e0155..1a85509c12f2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1174,13 +1174,13 @@ unsigned int dcn32_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsign
 	if (is_dp_128b_132b_signal(pipe_ctx)) {
 		*k1_div = PIXEL_RATE_DIV_BY_1;
 		*k2_div = PIXEL_RATE_DIV_BY_1;
-	} else if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal) || dc_is_dvi_signal(pipe_ctx->stream->signal)) {
+	} else if (dc_is_hdmi_tmds_signal(stream->signal) || dc_is_dvi_signal(stream->signal)) {
 		*k1_div = PIXEL_RATE_DIV_BY_1;
 		if (stream->timing.pixel_encoding == PIXEL_ENCODING_YCBCR420)
 			*k2_div = PIXEL_RATE_DIV_BY_2;
 		else
 			*k2_div = PIXEL_RATE_DIV_BY_4;
-	} else if (dc_is_dp_signal(pipe_ctx->stream->signal)) {
+	} else if (dc_is_dp_signal(stream->signal)) {
 		if (two_pix_per_container) {
 			*k1_div = PIXEL_RATE_DIV_BY_1;
 			*k2_div = PIXEL_RATE_DIV_BY_2;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 26fc5cad7a77..a942e2812183 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -2142,6 +2142,7 @@ static bool dcn32_resource_construct(
 	dc->caps.edp_dsc_support = true;
 	dc->caps.extended_aux_timeout_support = true;
 	dc->caps.dmcub_support = true;
+	dc->caps.seamless_odm = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index a98efef0ba0e..1b74a913f1b8 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -659,8 +659,8 @@ static int lt8912_parse_dt(struct lt8912 *lt)
 
 	lt->hdmi_port = of_drm_find_bridge(port_node);
 	if (!lt->hdmi_port) {
-		dev_err(lt->dev, "%s: Failed to get hdmi port\n", __func__);
-		ret = -ENODEV;
+		ret = -EPROBE_DEFER;
+		dev_err_probe(lt->dev, ret, "%s: Failed to get hdmi port\n", __func__);
 		goto err_free_host_node;
 	}
 
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 4bbb84847ecb..e0d36edd1e3f 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5186,6 +5186,7 @@ intel_crtc_prepare_cleared_state(struct intel_atomic_state *state,
 	 * only fields that are know to not cause problems are preserved. */
 
 	saved_state->uapi = crtc_state->uapi;
+	saved_state->inherited = crtc_state->inherited;
 	saved_state->scaler_state = crtc_state->scaler_state;
 	saved_state->shared_dpll = crtc_state->shared_dpll;
 	saved_state->dpll_hw_state = crtc_state->dpll_hw_state;
diff --git a/drivers/gpu/drm/i915/display/intel_fbdev.c b/drivers/gpu/drm/i915/display/intel_fbdev.c
index 9899b5dcd291..968915000519 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev.c
@@ -175,7 +175,7 @@ static int intelfb_alloc(struct drm_fb_helper *helper,
 	}
 
 	if (IS_ERR(obj)) {
-		drm_err(&dev_priv->drm, "failed to allocate framebuffer\n");
+		drm_err(&dev_priv->drm, "failed to allocate framebuffer (%pe)\n", obj);
 		return PTR_ERR(obj);
 	}
 
@@ -208,6 +208,7 @@ static int intelfb_create(struct drm_fb_helper *helper,
 	bool prealloc = false;
 	void __iomem *vaddr;
 	struct drm_i915_gem_object *obj;
+	struct i915_gem_ww_ctx ww;
 	int ret;
 
 	mutex_lock(&ifbdev->hpd_lock);
@@ -256,7 +257,7 @@ static int intelfb_create(struct drm_fb_helper *helper,
 
 	info = drm_fb_helper_alloc_fbi(helper);
 	if (IS_ERR(info)) {
-		drm_err(&dev_priv->drm, "Failed to allocate fb_info\n");
+		drm_err(&dev_priv->drm, "Failed to allocate fb_info (%pe)\n", info);
 		ret = PTR_ERR(info);
 		goto out_unpin;
 	}
@@ -288,13 +289,24 @@ static int intelfb_create(struct drm_fb_helper *helper,
 		info->fix.smem_len = vma->size;
 	}
 
-	vaddr = i915_vma_pin_iomap(vma);
-	if (IS_ERR(vaddr)) {
-		drm_err(&dev_priv->drm,
-			"Failed to remap framebuffer into virtual memory\n");
-		ret = PTR_ERR(vaddr);
-		goto out_unpin;
+	for_i915_gem_ww(&ww, ret, false) {
+		ret = i915_gem_object_lock(vma->obj, &ww);
+
+		if (ret)
+			continue;
+
+		vaddr = i915_vma_pin_iomap(vma);
+		if (IS_ERR(vaddr)) {
+			drm_err(&dev_priv->drm,
+				"Failed to remap framebuffer into virtual memory (%pe)\n", vaddr);
+			ret = PTR_ERR(vaddr);
+			continue;
+		}
 	}
+
+	if (ret)
+		goto out_unpin;
+
 	info->screen_base = vaddr;
 	info->screen_size = vma->size;
 
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index c7db49749a63..d12ec092e62d 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -691,12 +691,12 @@ int intel_gt_init(struct intel_gt *gt)
 	if (err)
 		goto err_gt;
 
-	intel_uc_init_late(&gt->uc);
-
 	err = i915_inject_probe_error(gt->i915, -EIO);
 	if (err)
 		goto err_gt;
 
+	intel_uc_init_late(&gt->uc);
+
 	intel_migrate_init(&gt->migrate, gt);
 
 	intel_pxp_init(&gt->pxp);
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
index 685ddccc0f26..1e1fa20fb41c 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
@@ -1491,7 +1491,7 @@ int intel_guc_capture_print_engine_node(struct drm_i915_error_state_buf *ebuf,
 
 	if (!ebuf || !ee)
 		return -EINVAL;
-	cap = ee->capture;
+	cap = ee->guc_capture;
 	if (!cap || !ee->engine)
 		return -ENODEV;
 
@@ -1556,13 +1556,34 @@ int intel_guc_capture_print_engine_node(struct drm_i915_error_state_buf *ebuf,
 
 #endif //CONFIG_DRM_I915_CAPTURE_ERROR
 
+static void guc_capture_find_ecode(struct intel_engine_coredump *ee)
+{
+	struct gcap_reg_list_info *reginfo;
+	struct guc_mmio_reg *regs;
+	i915_reg_t reg_ipehr = RING_IPEHR(0);
+	i915_reg_t reg_instdone = RING_INSTDONE(0);
+	int i;
+
+	if (!ee->guc_capture_node)
+		return;
+
+	reginfo = ee->guc_capture_node->reginfo + GUC_CAPTURE_LIST_TYPE_ENGINE_INSTANCE;
+	regs = reginfo->regs;
+	for (i = 0; i < reginfo->num_regs; i++) {
+		if (regs[i].offset == reg_ipehr.reg)
+			ee->ipehr = regs[i].value;
+		else if (regs[i].offset == reg_instdone.reg)
+			ee->instdone.instdone = regs[i].value;
+	}
+}
+
 void intel_guc_capture_free_node(struct intel_engine_coredump *ee)
 {
 	if (!ee || !ee->guc_capture_node)
 		return;
 
-	guc_capture_add_node_to_cachelist(ee->capture, ee->guc_capture_node);
-	ee->capture = NULL;
+	guc_capture_add_node_to_cachelist(ee->guc_capture, ee->guc_capture_node);
+	ee->guc_capture = NULL;
 	ee->guc_capture_node = NULL;
 }
 
@@ -1596,7 +1617,8 @@ void intel_guc_capture_get_matching_node(struct intel_gt *gt,
 		    (ce->lrc.lrca & CTX_GTT_ADDRESS_MASK)) {
 			list_del(&n->link);
 			ee->guc_capture_node = n;
-			ee->capture = guc->capture;
+			ee->guc_capture = guc->capture;
+			guc_capture_find_ecode(ee);
 			return;
 		}
 	}
diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index a9fea115f2d2..8ef93889061a 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -92,8 +92,7 @@ static void debug_active_init(struct i915_active *ref)
 static void debug_active_activate(struct i915_active *ref)
 {
 	lockdep_assert_held(&ref->tree_lock);
-	if (!atomic_read(&ref->count)) /* before the first inc */
-		debug_object_activate(ref, &active_debug_desc);
+	debug_object_activate(ref, &active_debug_desc);
 }
 
 static void debug_active_deactivate(struct i915_active *ref)
diff --git a/drivers/gpu/drm/i915/i915_gpu_error.h b/drivers/gpu/drm/i915/i915_gpu_error.h
index efc75cc2ffdb..56027ffbce51 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.h
+++ b/drivers/gpu/drm/i915/i915_gpu_error.h
@@ -94,7 +94,7 @@ struct intel_engine_coredump {
 	struct intel_instdone instdone;
 
 	/* GuC matched capture-lists info */
-	struct intel_guc_state_capture *capture;
+	struct intel_guc_state_capture *guc_capture;
 	struct __guc_capture_parsed_output *guc_capture_node;
 
 	struct i915_gem_context_coredump {
diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 3b24a924b7b9..eea433ade79d 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -325,23 +325,23 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 	ret = meson_encoder_hdmi_init(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_plane_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_overlay_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_crtc_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = request_irq(priv->vsync_irq, meson_irq, 0, drm->driver->name, drm);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	drm_mode_config_reset(drm);
 
@@ -359,6 +359,9 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 uninstall_irq:
 	free_irq(priv->vsync_irq, drm);
+unbind_all:
+	if (has_components)
+		component_unbind_all(drm->dev, drm);
 exit_afbcd:
 	if (priv->afbcd.ops)
 		priv->afbcd.ops->exit(priv);
diff --git a/drivers/gpu/drm/tiny/cirrus.c b/drivers/gpu/drm/tiny/cirrus.c
index 354d5e854a6f..b27e469e9021 100644
--- a/drivers/gpu/drm/tiny/cirrus.c
+++ b/drivers/gpu/drm/tiny/cirrus.c
@@ -455,7 +455,7 @@ static void cirrus_pipe_update(struct drm_simple_display_pipe *pipe,
 	if (state->fb && cirrus->cpp != cirrus_cpp(state->fb))
 		cirrus_mode_set(cirrus, &crtc->mode, state->fb);
 
-	if (drm_atomic_helper_damage_merged(old_state, state, &rect))
+	if (state->fb && drm_atomic_helper_damage_merged(old_state, state, &rect))
 		cirrus_fb_blit_rect(state->fb, &shadow_plane_state->data[0], &rect);
 }
 
diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 1e16b0fa310d..27cadadda7c9 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1354,6 +1354,7 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	girq->parents = NULL;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_simple_irq;
+	girq->threaded = true;
 
 	ret = gpiochip_add_data(&dev->gc, dev);
 	if (ret < 0) {
diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index fdb66dc06582..e906ee375298 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4378,6 +4378,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb01e) },
 	{ /* MX Master 3 mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb023) },
+	{ /* MX Master 3S mouse over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb034) },
 	{}
 };
 
diff --git a/drivers/hid/intel-ish-hid/ipc/ipc.c b/drivers/hid/intel-ish-hid/ipc/ipc.c
index 15e14239af82..a49c6affd7c4 100644
--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2014-2016, Intel Corporation.
  */
 
+#include <linux/devm-helpers.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
@@ -621,7 +622,6 @@ static void	recv_ipc(struct ishtp_device *dev, uint32_t doorbell_val)
 	case MNG_RESET_NOTIFY:
 		if (!ishtp_dev) {
 			ishtp_dev = dev;
-			INIT_WORK(&fw_reset_work, fw_reset_work_fn);
 		}
 		schedule_work(&fw_reset_work);
 		break;
@@ -940,6 +940,7 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 {
 	struct ishtp_device *dev;
 	int	i;
+	int	ret;
 
 	dev = devm_kzalloc(&pdev->dev,
 			   sizeof(struct ishtp_device) + sizeof(struct ish_hw),
@@ -975,6 +976,12 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 		list_add_tail(&tx_buf->link, &dev->wr_free_list);
 	}
 
+	ret = devm_work_autocancel(&pdev->dev, &fw_reset_work, fw_reset_work_fn);
+	if (ret) {
+		dev_err(dev->devc, "Failed to initialise FW reset work\n");
+		return NULL;
+	}
+
 	dev->ops = &ish_hw_ops;
 	dev->devc = &pdev->dev;
 	dev->mtu = IPC_PAYLOAD_SIZE - sizeof(struct ishtp_msg_hdr);
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 4218750d5a66..9ed34b2e1f49 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -756,6 +756,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	struct hwmon_device *hwdev;
 	const char *label;
 	struct device *hdev;
+	struct device *tdev = dev;
 	int i, err, id;
 
 	/* Complain about invalid characters in hwmon name attribute */
@@ -825,7 +826,9 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	hwdev->name = name;
 	hdev->class = &hwmon_class;
 	hdev->parent = dev;
-	hdev->of_node = dev ? dev->of_node : NULL;
+	while (tdev && !tdev->of_node)
+		tdev = tdev->parent;
+	hdev->of_node = tdev ? tdev->of_node : NULL;
 	hwdev->chip = chip;
 	dev_set_drvdata(hdev, drvdata);
 	dev_set_name(hdev, HWMON_ID_FORMAT, id);
@@ -837,7 +840,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 
 	INIT_LIST_HEAD(&hwdev->tzdata);
 
-	if (dev && dev->of_node && chip && chip->ops->read &&
+	if (hdev->of_node && chip && chip->ops->read &&
 	    chip->info[0]->type == hwmon_chip &&
 	    (chip->info[0]->config[0] & HWMON_C_REGISTER_TZ)) {
 		err = hwmon_thermal_register_sensors(hdev);
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 7bd154ba351b..b45bd3aa5a65 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -486,6 +486,8 @@ static const struct it87_devices it87_devices[] = {
 #define has_pwm_freq2(data)	((data)->features & FEAT_PWM_FREQ2)
 #define has_six_temp(data)	((data)->features & FEAT_SIX_TEMP)
 #define has_vin3_5v(data)	((data)->features & FEAT_VIN3_5V)
+#define has_scaling(data)	((data)->features & (FEAT_12MV_ADC | \
+						     FEAT_10_9MV_ADC))
 
 struct it87_sio_data {
 	int sioaddr;
@@ -3098,7 +3100,7 @@ static int it87_probe(struct platform_device *pdev)
 			 "Detected broken BIOS defaults, disabling PWM interface\n");
 
 	/* Starting with IT8721F, we handle scaling of internal voltages */
-	if (has_12mv_adc(data)) {
+	if (has_scaling(data)) {
 		if (sio_data->internal & BIT(0))
 			data->in_scaled |= BIT(3);	/* in3 is AVCC */
 		if (sio_data->internal & BIT(1))
diff --git a/drivers/i2c/busses/i2c-hisi.c b/drivers/i2c/busses/i2c-hisi.c
index 76c3d8f6fc3c..d30071f29987 100644
--- a/drivers/i2c/busses/i2c-hisi.c
+++ b/drivers/i2c/busses/i2c-hisi.c
@@ -339,7 +339,11 @@ static irqreturn_t hisi_i2c_irq(int irq, void *context)
 		hisi_i2c_read_rx_fifo(ctlr);
 
 out:
-	if (int_stat & HISI_I2C_INT_TRANS_CPLT || ctlr->xfer_err) {
+	/*
+	 * Only use TRANS_CPLT to indicate the completion. On error cases we'll
+	 * get two interrupts, INT_ERR first then TRANS_CPLT.
+	 */
+	if (int_stat & HISI_I2C_INT_TRANS_CPLT) {
 		hisi_i2c_disable_int(ctlr, HISI_I2C_INT_ALL);
 		hisi_i2c_clear_int(ctlr, HISI_I2C_INT_ALL);
 		complete(ctlr->completion);
diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 188f2a36d2fd..9b2f9544c568 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -503,10 +503,14 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 static irqreturn_t lpi2c_imx_isr(int irq, void *dev_id)
 {
 	struct lpi2c_imx_struct *lpi2c_imx = dev_id;
+	unsigned int enabled;
 	unsigned int temp;
 
+	enabled = readl(lpi2c_imx->base + LPI2C_MIER);
+
 	lpi2c_imx_intctrl(lpi2c_imx, 0);
 	temp = readl(lpi2c_imx->base + LPI2C_MSR);
+	temp &= enabled;
 
 	if (temp & MSR_RDF)
 		lpi2c_imx_read_rxfifo(lpi2c_imx);
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index d113bed79545..e0f3b3545cfe 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -171,7 +171,7 @@ static void mxs_i2c_dma_irq_callback(void *param)
 }
 
 static int mxs_i2c_dma_setup_xfer(struct i2c_adapter *adap,
-			struct i2c_msg *msg, uint32_t flags)
+			struct i2c_msg *msg, u8 *buf, uint32_t flags)
 {
 	struct dma_async_tx_descriptor *desc;
 	struct mxs_i2c_dev *i2c = i2c_get_adapdata(adap);
@@ -226,7 +226,7 @@ static int mxs_i2c_dma_setup_xfer(struct i2c_adapter *adap,
 		}
 
 		/* Queue the DMA data transfer. */
-		sg_init_one(&i2c->sg_io[1], msg->buf, msg->len);
+		sg_init_one(&i2c->sg_io[1], buf, msg->len);
 		dma_map_sg(i2c->dev, &i2c->sg_io[1], 1, DMA_FROM_DEVICE);
 		desc = dmaengine_prep_slave_sg(i2c->dmach, &i2c->sg_io[1], 1,
 					DMA_DEV_TO_MEM,
@@ -259,7 +259,7 @@ static int mxs_i2c_dma_setup_xfer(struct i2c_adapter *adap,
 		/* Queue the DMA data transfer. */
 		sg_init_table(i2c->sg_io, 2);
 		sg_set_buf(&i2c->sg_io[0], &i2c->addr_data, 1);
-		sg_set_buf(&i2c->sg_io[1], msg->buf, msg->len);
+		sg_set_buf(&i2c->sg_io[1], buf, msg->len);
 		dma_map_sg(i2c->dev, i2c->sg_io, 2, DMA_TO_DEVICE);
 		desc = dmaengine_prep_slave_sg(i2c->dmach, i2c->sg_io, 2,
 					DMA_MEM_TO_DEV,
@@ -563,6 +563,7 @@ static int mxs_i2c_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg,
 	struct mxs_i2c_dev *i2c = i2c_get_adapdata(adap);
 	int ret;
 	int flags;
+	u8 *dma_buf;
 	int use_pio = 0;
 	unsigned long time_left;
 
@@ -588,13 +589,20 @@ static int mxs_i2c_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg,
 		if (ret && (ret != -ENXIO))
 			mxs_i2c_reset(i2c);
 	} else {
+		dma_buf = i2c_get_dma_safe_msg_buf(msg, 1);
+		if (!dma_buf)
+			return -ENOMEM;
+
 		reinit_completion(&i2c->cmd_complete);
-		ret = mxs_i2c_dma_setup_xfer(adap, msg, flags);
-		if (ret)
+		ret = mxs_i2c_dma_setup_xfer(adap, msg, dma_buf, flags);
+		if (ret) {
+			i2c_put_dma_safe_msg_buf(dma_buf, msg, false);
 			return ret;
+		}
 
 		time_left = wait_for_completion_timeout(&i2c->cmd_complete,
 						msecs_to_jiffies(1000));
+		i2c_put_dma_safe_msg_buf(dma_buf, msg, true);
 		if (!time_left)
 			goto timeout;
 
diff --git a/drivers/i2c/busses/i2c-xgene-slimpro.c b/drivers/i2c/busses/i2c-xgene-slimpro.c
index 63259b3ea5ab..3538d36368a9 100644
--- a/drivers/i2c/busses/i2c-xgene-slimpro.c
+++ b/drivers/i2c/busses/i2c-xgene-slimpro.c
@@ -308,6 +308,9 @@ static int slimpro_i2c_blkwr(struct slimpro_i2c_dev *ctx, u32 chip,
 	u32 msg[3];
 	int rc;
 
+	if (writelen > I2C_SMBUS_BLOCK_MAX)
+		return -EINVAL;
+
 	memcpy(ctx->dma_buffer, data, writelen);
 	paddr = dma_map_single(ctx->dev, ctx->dma_buffer, writelen,
 			       DMA_TO_DEVICE);
diff --git a/drivers/interconnect/qcom/osm-l3.c b/drivers/interconnect/qcom/osm-l3.c
index 333adb21e717..46b538e6c07b 100644
--- a/drivers/interconnect/qcom/osm-l3.c
+++ b/drivers/interconnect/qcom/osm-l3.c
@@ -294,7 +294,7 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
 	qnodes = desc->nodes;
 	num_nodes = desc->num_nodes;
 
-	data = devm_kcalloc(&pdev->dev, num_nodes, sizeof(*node), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, struct_size(data, nodes, num_nodes), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
diff --git a/drivers/interconnect/qcom/qcm2290.c b/drivers/interconnect/qcom/qcm2290.c
index 0da612d6398c..a29cdb4fac03 100644
--- a/drivers/interconnect/qcom/qcm2290.c
+++ b/drivers/interconnect/qcom/qcm2290.c
@@ -147,9 +147,9 @@ static struct qcom_icc_node mas_snoc_bimc_nrt = {
 	.name = "mas_snoc_bimc_nrt",
 	.buswidth = 16,
 	.qos.ap_owned = true,
-	.qos.qos_port = 2,
+	.qos.qos_port = 3,
 	.qos.qos_mode = NOC_QOS_MODE_BYPASS,
-	.mas_rpm_id = 163,
+	.mas_rpm_id = 164,
 	.slv_rpm_id = -1,
 	.num_links = ARRAY_SIZE(mas_snoc_bimc_nrt_links),
 	.links = mas_snoc_bimc_nrt_links,
diff --git a/drivers/interconnect/qcom/sm8450.c b/drivers/interconnect/qcom/sm8450.c
index e3a12e3d6e06..2d7a8e7b85ec 100644
--- a/drivers/interconnect/qcom/sm8450.c
+++ b/drivers/interconnect/qcom/sm8450.c
@@ -1844,100 +1844,6 @@ static const struct qcom_icc_desc sm8450_system_noc = {
 	.num_bcms = ARRAY_SIZE(system_noc_bcms),
 };
 
-static int qnoc_probe(struct platform_device *pdev)
-{
-	const struct qcom_icc_desc *desc;
-	struct icc_onecell_data *data;
-	struct icc_provider *provider;
-	struct qcom_icc_node * const *qnodes;
-	struct qcom_icc_provider *qp;
-	struct icc_node *node;
-	size_t num_nodes, i;
-	int ret;
-
-	desc = device_get_match_data(&pdev->dev);
-	if (!desc)
-		return -EINVAL;
-
-	qnodes = desc->nodes;
-	num_nodes = desc->num_nodes;
-
-	qp = devm_kzalloc(&pdev->dev, sizeof(*qp), GFP_KERNEL);
-	if (!qp)
-		return -ENOMEM;
-
-	data = devm_kcalloc(&pdev->dev, num_nodes, sizeof(*node), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	provider = &qp->provider;
-	provider->dev = &pdev->dev;
-	provider->set = qcom_icc_set;
-	provider->pre_aggregate = qcom_icc_pre_aggregate;
-	provider->aggregate = qcom_icc_aggregate;
-	provider->xlate_extended = qcom_icc_xlate_extended;
-	INIT_LIST_HEAD(&provider->nodes);
-	provider->data = data;
-
-	qp->dev = &pdev->dev;
-	qp->bcms = desc->bcms;
-	qp->num_bcms = desc->num_bcms;
-
-	qp->voter = of_bcm_voter_get(qp->dev, NULL);
-	if (IS_ERR(qp->voter))
-		return PTR_ERR(qp->voter);
-
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(&pdev->dev, "error adding interconnect provider\n");
-		return ret;
-	}
-
-	for (i = 0; i < qp->num_bcms; i++)
-		qcom_icc_bcm_init(qp->bcms[i], &pdev->dev);
-
-	for (i = 0; i < num_nodes; i++) {
-		size_t j;
-
-		if (!qnodes[i])
-			continue;
-
-		node = icc_node_create(qnodes[i]->id);
-		if (IS_ERR(node)) {
-			ret = PTR_ERR(node);
-			goto err;
-		}
-
-		node->name = qnodes[i]->name;
-		node->data = qnodes[i];
-		icc_node_add(node, provider);
-
-		for (j = 0; j < qnodes[i]->num_links; j++)
-			icc_link_create(node, qnodes[i]->links[j]);
-
-		data->nodes[i] = node;
-	}
-	data->num_nodes = num_nodes;
-
-	platform_set_drvdata(pdev, qp);
-
-	return 0;
-err:
-	icc_nodes_remove(provider);
-	icc_provider_del(provider);
-	return ret;
-}
-
-static int qnoc_remove(struct platform_device *pdev)
-{
-	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
-
-	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
-
-	return 0;
-}
-
 static const struct of_device_id qnoc_of_match[] = {
 	{ .compatible = "qcom,sm8450-aggre1-noc",
 	  .data = &sm8450_aggre1_noc},
@@ -1966,8 +1872,8 @@ static const struct of_device_id qnoc_of_match[] = {
 MODULE_DEVICE_TABLE(of, qnoc_of_match);
 
 static struct platform_driver qnoc_driver = {
-	.probe = qnoc_probe,
-	.remove = qnoc_remove,
+	.probe = qcom_icc_rpmh_probe,
+	.remove = qcom_icc_rpmh_remove,
 	.driver = {
 		.name = "qnoc-sm8450",
 		.of_match_table = qnoc_of_match,
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 2653516bcdef..dc2d0d61ade9 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -71,7 +71,9 @@ struct dm_crypt_io {
 	struct crypt_config *cc;
 	struct bio *base_bio;
 	u8 *integrity_metadata;
-	bool integrity_metadata_from_pool;
+	bool integrity_metadata_from_pool:1;
+	bool in_tasklet:1;
+
 	struct work_struct work;
 	struct tasklet_struct tasklet;
 
@@ -1728,6 +1730,7 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
+	io->in_tasklet = false;
 	atomic_set(&io->io_pending, 0);
 }
 
@@ -1773,14 +1776,13 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	 * our tasklet. In this case we need to delay bio_endio()
 	 * execution to after the tasklet is done and dequeued.
 	 */
-	if (tasklet_trylock(&io->tasklet)) {
-		tasklet_unlock(&io->tasklet);
-		bio_endio(base_bio);
+	if (io->in_tasklet) {
+		INIT_WORK(&io->work, kcryptd_io_bio_endio);
+		queue_work(cc->io_queue, &io->work);
 		return;
 	}
 
-	INIT_WORK(&io->work, kcryptd_io_bio_endio);
-	queue_work(cc->io_queue, &io->work);
+	bio_endio(base_bio);
 }
 
 /*
@@ -1933,6 +1935,7 @@ static int dmcrypt_write(void *data)
 			io = crypt_io_from_node(rb_first(&write_tree));
 			rb_erase(&io->rb_node, &write_tree);
 			kcryptd_io_write(io);
+			cond_resched();
 		} while (!RB_EMPTY_ROOT(&write_tree));
 		blk_finish_plug(&plug);
 	}
@@ -2228,6 +2231,7 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 		 * it is being executed with irqs disabled.
 		 */
 		if (in_hardirq() || irqs_disabled()) {
+			io->in_tasklet = true;
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index f105a71915ab..d12ba9bce145 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -188,7 +188,7 @@ static int dm_stat_in_flight(struct dm_stat_shared *shared)
 	       atomic_read(&shared->in_flight[WRITE]);
 }
 
-void dm_stats_init(struct dm_stats *stats)
+int dm_stats_init(struct dm_stats *stats)
 {
 	int cpu;
 	struct dm_stats_last_position *last;
@@ -197,11 +197,16 @@ void dm_stats_init(struct dm_stats *stats)
 	INIT_LIST_HEAD(&stats->list);
 	stats->precise_timestamps = false;
 	stats->last = alloc_percpu(struct dm_stats_last_position);
+	if (!stats->last)
+		return -ENOMEM;
+
 	for_each_possible_cpu(cpu) {
 		last = per_cpu_ptr(stats->last, cpu);
 		last->last_sector = (sector_t)ULLONG_MAX;
 		last->last_rw = UINT_MAX;
 	}
+
+	return 0;
 }
 
 void dm_stats_cleanup(struct dm_stats *stats)
diff --git a/drivers/md/dm-stats.h b/drivers/md/dm-stats.h
index 09c81a1ec057..ee32b099f1cf 100644
--- a/drivers/md/dm-stats.h
+++ b/drivers/md/dm-stats.h
@@ -21,7 +21,7 @@ struct dm_stats_aux {
 	unsigned long long duration_ns;
 };
 
-void dm_stats_init(struct dm_stats *st);
+int dm_stats_init(struct dm_stats *st);
 void dm_stats_cleanup(struct dm_stats *st);
 
 struct mapped_device;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d28c9077d6ed..90df6c3da77a 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3357,6 +3357,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4235,6 +4236,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 	ti->flush_supported = true;
 	ti->accounts_remapped_io = true;
 	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d727ed9cd623..89bf28ed874c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2105,7 +2105,9 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->pending_io)
 		goto bad;
 
-	dm_stats_init(&md->stats);
+	r = dm_stats_init(&md->stats);
+	if (r < 0)
+		goto bad;
 
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);
diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index e968322dfbf0..70887e0aece3 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -263,7 +263,7 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
 		if (of_property_read_u32(of_port, "reg", &reg))
 			continue;
 
-		if (reg < B53_CPU_PORT)
+		if (reg < B53_N_PORTS)
 			pdata->enabled_ports |= BIT(reg);
 	}
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 1757d6a2c72a..38bf760b5b5e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -396,6 +396,9 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 /* Set up switch core clock for MT7530 */
 static void mt7530_pll_setup(struct mt7530_priv *priv)
 {
+	/* Disable core clock */
+	core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
+
 	/* Disable PLL */
 	core_write(priv, CORE_GSWPLL_GRP1, 0);
 
@@ -409,14 +412,19 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 		   RG_GSWPLL_EN_PRE |
 		   RG_GSWPLL_POSDIV_200M(2) |
 		   RG_GSWPLL_FBKDIV_200M(32));
+
+	udelay(20);
+
+	/* Enable core clock */
+	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 }
 
-/* Setup TX circuit including relevant PAD and driving */
+/* Setup port 6 interface mode and TRGMII TX circuit */
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, i, xtal;
+	u32 ncpo1, ssc_delta, trgint, xtal;
 
 	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
 
@@ -433,6 +441,10 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		break;
 	case PHY_INTERFACE_MODE_TRGMII:
 		trgint = 1;
+		if (xtal == HWTRAP_XTAL_25MHZ)
+			ssc_delta = 0x57;
+		else
+			ssc_delta = 0x87;
 		if (priv->id == ID_MT7621) {
 			/* PLL frequency: 150MHz: 1.2GBit */
 			if (xtal == HWTRAP_XTAL_40MHZ)
@@ -452,23 +464,12 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		return -EINVAL;
 	}
 
-	if (xtal == HWTRAP_XTAL_25MHZ)
-		ssc_delta = 0x57;
-	else
-		ssc_delta = 0x87;
-
 	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
 		   P6_INTF_MODE(trgint));
 
 	if (trgint) {
-		/* Lower Tx Driving for TRGMII path */
-		for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
-			mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-				     TD_DM_DRVP(8) | TD_DM_DRVN(8));
-
-		/* Disable MT7530 core and TRGMII Tx clocks */
-		core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
-			   REG_GSWCK_EN | REG_TRGMIICK_EN);
+		/* Disable the MT7530 TRGMII clocks */
+		core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 
 		/* Setup the MT7530 TRGMII Tx Clock */
 		core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
@@ -485,13 +486,8 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 			   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
 			   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
 
-		/* Enable MT7530 core and TRGMII Tx clocks */
-		core_set(priv, CORE_TRGMII_GSW_CLK_CG,
-			 REG_GSWCK_EN | REG_TRGMIICK_EN);
-	} else {
-		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
-			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
-				   RD_TAP_MASK, RD_TAP(16));
+		/* Enable the MT7530 TRGMII clocks */
+		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 	}
 
 	return 0;
@@ -2206,6 +2202,15 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
+	/* Lower Tx driving for TRGMII path */
+	for (i = 0; i < NUM_TRGMII_CTRL; i++)
+		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
+			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
+
+	for (i = 0; i < NUM_TRGMII_CTRL; i++)
+		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
+			   RD_TAP_MASK, RD_TAP(16));
+
 	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 7b9a2d9d9624..38df602f2869 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -535,7 +535,10 @@ static int gve_get_link_ksettings(struct net_device *netdev,
 				  struct ethtool_link_ksettings *cmd)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
-	int err = gve_adminq_report_link_speed(priv);
+	int err = 0;
+
+	if (priv->link_speed == 0)
+		err = gve_adminq_report_link_speed(priv);
 
 	cmd->base.speed = priv->link_speed;
 	return err;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b97c95f89fa0..494775d65bf2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -171,10 +171,10 @@ static char *i40e_create_dummy_packet(u8 *dummy_packet, bool ipv4, u8 l4proto,
 				      struct i40e_fdir_filter *data)
 {
 	bool is_vlan = !!data->vlan_tag;
-	struct vlan_hdr vlan;
-	struct ipv6hdr ipv6;
-	struct ethhdr eth;
-	struct iphdr ip;
+	struct vlan_hdr vlan = {};
+	struct ipv6hdr ipv6 = {};
+	struct ethhdr eth = {};
+	struct iphdr ip = {};
 	u8 *tmp;
 
 	if (ipv4) {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 34e46a23894f..43148c07459f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -661,7 +661,7 @@ struct iavf_rx_ptype_decoded iavf_ptype_lookup[BIT(8)] = {
 	/* Non Tunneled IPv6 */
 	IAVF_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
 	IAVF_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY3),
+	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
 	IAVF_PTT_UNUSED_ENTRY(91),
 	IAVF_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
 	IAVF_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3dad834b9b8e..5f8fff6c701f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -893,6 +893,10 @@ static int iavf_vlan_rx_add_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
+	/* Do not track VLAN 0 filter, always added by the PF on VF init */
+	if (!vid)
+		return 0;
+
 	if (!VLAN_FILTERING_ALLOWED(adapter))
 		return -EIO;
 
@@ -919,6 +923,10 @@ static int iavf_vlan_rx_kill_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
+	/* We do not track VLAN 0 filter */
+	if (!vid)
+		return 0;
+
 	iavf_del_vlan(adapter, IAVF_VLAN(vid, be16_to_cpu(proto)));
 	if (proto == cpu_to_be16(ETH_P_8021Q))
 		clear_bit(vid, adapter->vsi.active_cvlans);
@@ -5078,6 +5086,11 @@ static void iavf_remove(struct pci_dev *pdev)
 			mutex_unlock(&adapter->crit_lock);
 			break;
 		}
+		/* Simply return if we already went through iavf_shutdown */
+		if (adapter->state == __IAVF_REMOVE) {
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
 
 		mutex_unlock(&adapter->crit_lock);
 		usleep_range(500, 1000);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 18b6a702a1d6..e989feda133c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1096,7 +1096,7 @@ static inline void iavf_rx_hash(struct iavf_ring *ring,
 		cpu_to_le64((u64)IAVF_RX_DESC_FLTSTAT_RSS_HASH <<
 			    IAVF_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (!(ring->netdev->features & NETIF_F_RXHASH))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 0752fd67c96e..2c03ca01fdd9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2438,8 +2438,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
 			if (f->is_new_vlan) {
 				f->is_new_vlan = false;
-				if (!f->vlan.vid)
-					continue;
 				if (f->vlan.tpid == ETH_P_8021Q)
 					set_bit(f->vlan.vid,
 						adapter->vsi.active_cvlans);
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 3ba1408c56a9..b3849bc3d4fc 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1384,15 +1384,15 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	struct ice_vf *vf;
 	int ret;
 
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
+		return -EINVAL;
+
 	if (ice_is_eswitch_mode_switchdev(pf)) {
 		dev_info(ice_pf_to_dev(pf), "Trusted VF is forbidden in switchdev mode\n");
 		return -EOPNOTSUPP;
 	}
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
-
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		goto out_put_vf;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index bf4317e47f94..b3aed4e2ca91 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3841,9 +3841,7 @@ static void igb_remove(struct pci_dev *pdev)
 	igb_release_hw_control(adapter);
 
 #ifdef CONFIG_PCI_IOV
-	rtnl_lock();
 	igb_disable_sriov(pdev);
-	rtnl_unlock();
 #endif
 
 	unregister_netdev(netdev);
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 3a32809510fc..72cb1b56e9f2 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1074,7 +1074,7 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 			  igbvf_intr_msix_rx, 0, adapter->rx_ring->name,
 			  netdev);
 	if (err)
-		goto out;
+		goto free_irq_tx;
 
 	adapter->rx_ring->itr_register = E1000_EITR(vector);
 	adapter->rx_ring->itr_val = adapter->current_itr;
@@ -1083,10 +1083,14 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 	err = request_irq(adapter->msix_entries[vector].vector,
 			  igbvf_msix_other, 0, netdev->name, netdev);
 	if (err)
-		goto out;
+		goto free_irq_rx;
 
 	igbvf_configure_msix(adapter);
 	return 0;
+free_irq_rx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
+free_irq_tx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
 out:
 	return err;
 }
diff --git a/drivers/net/ethernet/intel/igbvf/vf.c b/drivers/net/ethernet/intel/igbvf/vf.c
index b8ba3f94c363..a47a2e3e548c 100644
--- a/drivers/net/ethernet/intel/igbvf/vf.c
+++ b/drivers/net/ethernet/intel/igbvf/vf.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2009 - 2018 Intel Corporation. */
 
+#include <linux/etherdevice.h>
+
 #include "vf.h"
 
 static s32 e1000_check_for_link_vf(struct e1000_hw *hw);
@@ -131,11 +133,16 @@ static s32 e1000_reset_hw_vf(struct e1000_hw *hw)
 		/* set our "perm_addr" based on info provided by PF */
 		ret_val = mbx->ops.read_posted(hw, msgbuf, 3);
 		if (!ret_val) {
-			if (msgbuf[0] == (E1000_VF_RESET |
-					  E1000_VT_MSGTYPE_ACK))
+			switch (msgbuf[0]) {
+			case E1000_VF_RESET | E1000_VT_MSGTYPE_ACK:
 				memcpy(hw->mac.perm_addr, addr, ETH_ALEN);
-			else
+				break;
+			case E1000_VF_RESET | E1000_VT_MSGTYPE_NACK:
+				eth_zero_addr(hw->mac.perm_addr);
+				break;
+			default:
 				ret_val = -E1000_ERR_MAC_INIT;
+			}
 		}
 	}
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3b5b36206c44..1d9b70e0ff67 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6000,18 +6000,18 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		if (e->command != TC_TAPRIO_CMD_SET_GATES)
 			return false;
 
-		for (i = 0; i < adapter->num_tx_queues; i++) {
-			if (e->gate_mask & BIT(i))
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			if (e->gate_mask & BIT(i)) {
 				queue_uses[i]++;
 
-			/* There are limitations: A single queue cannot be
-			 * opened and closed multiple times per cycle unless the
-			 * gate stays open. Check for it.
-			 */
-			if (queue_uses[i] > 1 &&
-			    !(prev->gate_mask & BIT(i)))
-				return false;
-		}
+				/* There are limitations: A single queue cannot
+				 * be opened and closed multiple times per cycle
+				 * unless the gate stays open. Check for it.
+				 */
+				if (queue_uses[i] > 1 &&
+				    !(prev->gate_mask & BIT(i)))
+					return false;
+			}
 	}
 
 	return true;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 7f8ffbf79cf7..ab126f8706c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -709,6 +709,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_ptp_destroy:
 	otx2_ptp_destroy(vf);
 err_detach_rsrc:
+	free_percpu(vf->hw.lmt_info);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
 		qmem_free(vf->dev, vf->dync_lmt);
 	otx2_detach_resources(&vf->mbox);
@@ -762,6 +763,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	otx2_shutdown_tc(vf);
 	otx2vf_disable_mbox_intr(vf);
 	otx2_detach_resources(&vf->mbox);
+	free_percpu(vf->hw.lmt_info);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
 		qmem_free(vf->dev, vf->dync_lmt);
 	otx2vf_vfaf_mbox_destroy(vf);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 0c23340bfcc7..0f8f3ce35537 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1412,6 +1412,7 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	struct mlx5e_macsec_aso *aso;
 	struct mlx5_aso_wqe *aso_wqe;
 	struct mlx5_aso *maso;
+	unsigned long expires;
 	int err;
 
 	aso = &macsec->aso;
@@ -1425,7 +1426,13 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	macsec_aso_build_wqe_ctrl_seg(aso, &aso_wqe->aso_ctrl, NULL);
 
 	mlx5_aso_post_wqe(maso, false, &aso_wqe->ctrl);
-	err = mlx5_aso_poll_cq(maso, false);
+	expires = jiffies + msecs_to_jiffies(10);
+	do {
+		err = mlx5_aso_poll_cq(maso, false);
+		if (err)
+			usleep_range(2, 10);
+	} while (err && time_is_after_jiffies(expires));
+
 	if (err)
 		goto err_out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 2449731b7d79..89de92d06483 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -117,12 +117,14 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 	if (!MLX5_CAP_GEN(priv->mdev, ets))
 		return -EOPNOTSUPP;
 
-	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
-	for (i = 0; i < ets->ets_cap; i++) {
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err = mlx5_query_port_prio_tc(mdev, i, &ets->prio_tc[i]);
 		if (err)
 			return err;
+	}
 
+	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
+	for (i = 0; i < ets->ets_cap; i++) {
 		err = mlx5_query_port_tc_group(mdev, i, &tc_group[i]);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 609a49c1e09e..3b5c5064cfaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4081,8 +4081,12 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		}
 	}
 
-	if (mlx5e_is_uplink_rep(priv))
+	if (mlx5e_is_uplink_rep(priv)) {
 		features = mlx5e_fix_uplink_rep_features(netdev, features);
+		features |= NETIF_F_NETNS_LOCAL;
+	} else {
+		features &= ~NETIF_F_NETNS_LOCAL;
+	}
 
 	mutex_unlock(&priv->state_lock);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index a994e71e05c1..db578a7e7008 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -364,8 +364,7 @@ int mlx5_esw_acl_ingress_vport_bond_update(struct mlx5_eswitch *esw, u16 vport_n
 
 	if (WARN_ON_ONCE(IS_ERR(vport))) {
 		esw_warn(esw->dev, "vport(%d) invalid!\n", vport_num);
-		err = PTR_ERR(vport);
-		goto out;
+		return PTR_ERR(vport);
 	}
 
 	esw_acl_ingress_ofld_rules_destroy(esw, vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 43ba00d5e36e..4b9d567c8f47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -916,6 +916,7 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
+	esw_apply_vport_rx_mode(esw, vport, false, false);
 	esw_vport_cleanup(esw, vport);
 	esw->enabled_vports--;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 34790a82a097..64e5b9f29206 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3488,6 +3488,18 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
+static bool esw_offloads_devlink_ns_eq_netdev_ns(struct devlink *devlink)
+{
+	struct net *devl_net, *netdev_net;
+	struct mlx5_eswitch *esw;
+
+	esw = mlx5_devlink_eswitch_get(devlink);
+	netdev_net = dev_net(esw->dev->mlx5e_res.uplink_netdev);
+	devl_net = devlink_net(devlink);
+
+	return net_eq(devl_net, netdev_net);
+}
+
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
@@ -3502,6 +3514,13 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
+	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV &&
+	    !esw_offloads_devlink_ns_eq_netdev_ns(devlink)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't change E-Switch mode to switchdev when netdev net namespace has diverged from the devlink's.");
+		return -EPERM;
+	}
+
 	mlx5_lag_disable_change(esw->dev);
 	err = mlx5_esw_try_lock(esw);
 	if (err < 0) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 987fe5c9d5a3..09ed6e5fa6c3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -36,33 +36,39 @@ enum mlxsw_thermal_trips {
 	MLXSW_THERMAL_TEMP_TRIP_HOT,
 };
 
-struct mlxsw_thermal_trip {
-	int	type;
-	int	temp;
-	int	hyst;
+struct mlxsw_cooling_states {
 	int	min_state;
 	int	max_state;
 };
 
-static const struct mlxsw_thermal_trip default_thermal_trips[] = {
+static const struct thermal_trip default_thermal_trips[] = {
 	{	/* In range - 0-40% PWM */
 		.type		= THERMAL_TRIP_ACTIVE,
-		.temp		= MLXSW_THERMAL_ASIC_TEMP_NORM,
-		.hyst		= MLXSW_THERMAL_HYSTERESIS_TEMP,
-		.min_state	= 0,
-		.max_state	= (4 * MLXSW_THERMAL_MAX_STATE) / 10,
+		.temperature	= MLXSW_THERMAL_ASIC_TEMP_NORM,
+		.hysteresis	= MLXSW_THERMAL_HYSTERESIS_TEMP,
 	},
 	{
 		/* In range - 40-100% PWM */
 		.type		= THERMAL_TRIP_ACTIVE,
-		.temp		= MLXSW_THERMAL_ASIC_TEMP_HIGH,
-		.hyst		= MLXSW_THERMAL_HYSTERESIS_TEMP,
-		.min_state	= (4 * MLXSW_THERMAL_MAX_STATE) / 10,
-		.max_state	= MLXSW_THERMAL_MAX_STATE,
+		.temperature	= MLXSW_THERMAL_ASIC_TEMP_HIGH,
+		.hysteresis	= MLXSW_THERMAL_HYSTERESIS_TEMP,
 	},
 	{	/* Warning */
 		.type		= THERMAL_TRIP_HOT,
-		.temp		= MLXSW_THERMAL_ASIC_TEMP_HOT,
+		.temperature	= MLXSW_THERMAL_ASIC_TEMP_HOT,
+	},
+};
+
+static const struct mlxsw_cooling_states default_cooling_states[] = {
+	{
+		.min_state	= 0,
+		.max_state	= (4 * MLXSW_THERMAL_MAX_STATE) / 10,
+	},
+	{
+		.min_state	= (4 * MLXSW_THERMAL_MAX_STATE) / 10,
+		.max_state	= MLXSW_THERMAL_MAX_STATE,
+	},
+	{
 		.min_state	= MLXSW_THERMAL_MAX_STATE,
 		.max_state	= MLXSW_THERMAL_MAX_STATE,
 	},
@@ -78,7 +84,8 @@ struct mlxsw_thermal;
 struct mlxsw_thermal_module {
 	struct mlxsw_thermal *parent;
 	struct thermal_zone_device *tzdev;
-	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
+	struct thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
+	struct mlxsw_cooling_states cooling_states[MLXSW_THERMAL_NUM_TRIPS];
 	int module; /* Module or gearbox number */
 	u8 slot_index;
 };
@@ -98,8 +105,8 @@ struct mlxsw_thermal {
 	struct thermal_zone_device *tzdev;
 	int polling_delay;
 	struct thermal_cooling_device *cdevs[MLXSW_MFCR_PWMS_MAX];
-	u8 cooling_levels[MLXSW_THERMAL_MAX_STATE + 1];
-	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
+	struct thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
+	struct mlxsw_cooling_states cooling_states[MLXSW_THERMAL_NUM_TRIPS];
 	struct mlxsw_thermal_area line_cards[];
 };
 
@@ -136,9 +143,9 @@ static int mlxsw_get_cooling_device_idx(struct mlxsw_thermal *thermal,
 static void
 mlxsw_thermal_module_trips_reset(struct mlxsw_thermal_module *tz)
 {
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temp = 0;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temp = 0;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temp = 0;
+	tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temperature = 0;
+	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temperature = 0;
+	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temperature = 0;
 }
 
 static int
@@ -180,12 +187,12 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 	 * by subtracting double hysteresis value.
 	 */
 	if (crit_temp >= MLXSW_THERMAL_MODULE_TEMP_SHIFT)
-		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temp = crit_temp -
+		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temperature = crit_temp -
 					MLXSW_THERMAL_MODULE_TEMP_SHIFT;
 	else
-		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temp = crit_temp;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temp = crit_temp;
-	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temp = emerg_temp;
+		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temperature = crit_temp;
+	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temperature = crit_temp;
+	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temperature = emerg_temp;
 
 	return 0;
 }
@@ -202,11 +209,11 @@ static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
 		return 0;
 
 	for (i = 0; i < MLXSW_THERMAL_NUM_TRIPS; i++) {
-		const struct mlxsw_thermal_trip *trip = &thermal->trips[i];
+		const struct mlxsw_cooling_states *state = &thermal->cooling_states[i];
 
 		err = thermal_zone_bind_cooling_device(tzdev, i, cdev,
-						       trip->max_state,
-						       trip->min_state,
+						       state->max_state,
+						       state->min_state,
 						       THERMAL_WEIGHT_DEFAULT);
 		if (err < 0) {
 			dev_err(dev, "Failed to bind cooling device to trip %d\n", i);
@@ -260,61 +267,6 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static int mlxsw_thermal_get_trip_type(struct thermal_zone_device *tzdev,
-				       int trip,
-				       enum thermal_trip_type *p_type)
-{
-	struct mlxsw_thermal *thermal = tzdev->devdata;
-
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
-		return -EINVAL;
-
-	*p_type = thermal->trips[trip].type;
-	return 0;
-}
-
-static int mlxsw_thermal_get_trip_temp(struct thermal_zone_device *tzdev,
-				       int trip, int *p_temp)
-{
-	struct mlxsw_thermal *thermal = tzdev->devdata;
-
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
-		return -EINVAL;
-
-	*p_temp = thermal->trips[trip].temp;
-	return 0;
-}
-
-static int mlxsw_thermal_set_trip_temp(struct thermal_zone_device *tzdev,
-				       int trip, int temp)
-{
-	struct mlxsw_thermal *thermal = tzdev->devdata;
-
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
-		return -EINVAL;
-
-	thermal->trips[trip].temp = temp;
-	return 0;
-}
-
-static int mlxsw_thermal_get_trip_hyst(struct thermal_zone_device *tzdev,
-				       int trip, int *p_hyst)
-{
-	struct mlxsw_thermal *thermal = tzdev->devdata;
-
-	*p_hyst = thermal->trips[trip].hyst;
-	return 0;
-}
-
-static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
-				       int trip, int hyst)
-{
-	struct mlxsw_thermal *thermal = tzdev->devdata;
-
-	thermal->trips[trip].hyst = hyst;
-	return 0;
-}
-
 static struct thermal_zone_params mlxsw_thermal_params = {
 	.no_hwmon = true,
 };
@@ -323,11 +275,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.bind = mlxsw_thermal_bind,
 	.unbind = mlxsw_thermal_unbind,
 	.get_temp = mlxsw_thermal_get_temp,
-	.get_trip_type	= mlxsw_thermal_get_trip_type,
-	.get_trip_temp	= mlxsw_thermal_get_trip_temp,
-	.set_trip_temp	= mlxsw_thermal_set_trip_temp,
-	.get_trip_hyst	= mlxsw_thermal_get_trip_hyst,
-	.set_trip_hyst	= mlxsw_thermal_set_trip_hyst,
 };
 
 static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
@@ -342,11 +289,11 @@ static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
 		return 0;
 
 	for (i = 0; i < MLXSW_THERMAL_NUM_TRIPS; i++) {
-		const struct mlxsw_thermal_trip *trip = &tz->trips[i];
+		const struct mlxsw_cooling_states *state = &tz->cooling_states[i];
 
 		err = thermal_zone_bind_cooling_device(tzdev, i, cdev,
-						       trip->max_state,
-						       trip->min_state,
+						       state->max_state,
+						       state->min_state,
 						       THERMAL_WEIGHT_DEFAULT);
 		if (err < 0)
 			goto err_thermal_zone_bind_cooling_device;
@@ -434,74 +381,10 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
-static int
-mlxsw_thermal_module_trip_type_get(struct thermal_zone_device *tzdev, int trip,
-				   enum thermal_trip_type *p_type)
-{
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
-		return -EINVAL;
-
-	*p_type = tz->trips[trip].type;
-	return 0;
-}
-
-static int
-mlxsw_thermal_module_trip_temp_get(struct thermal_zone_device *tzdev,
-				   int trip, int *p_temp)
-{
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
-		return -EINVAL;
-
-	*p_temp = tz->trips[trip].temp;
-	return 0;
-}
-
-static int
-mlxsw_thermal_module_trip_temp_set(struct thermal_zone_device *tzdev,
-				   int trip, int temp)
-{
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-
-	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
-		return -EINVAL;
-
-	tz->trips[trip].temp = temp;
-	return 0;
-}
-
-static int
-mlxsw_thermal_module_trip_hyst_get(struct thermal_zone_device *tzdev, int trip,
-				   int *p_hyst)
-{
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-
-	*p_hyst = tz->trips[trip].hyst;
-	return 0;
-}
-
-static int
-mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
-				   int hyst)
-{
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-
-	tz->trips[trip].hyst = hyst;
-	return 0;
-}
-
 static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
 	.get_temp	= mlxsw_thermal_module_temp_get,
-	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
-	.get_trip_temp	= mlxsw_thermal_module_trip_temp_get,
-	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
-	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
-	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -531,11 +414,6 @@ static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
 	.get_temp	= mlxsw_thermal_gearbox_temp_get,
-	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
-	.get_trip_temp	= mlxsw_thermal_module_trip_temp_get,
-	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
-	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
-	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,
@@ -589,7 +467,7 @@ static int mlxsw_thermal_set_cur_state(struct thermal_cooling_device *cdev,
 		return idx;
 
 	/* Normalize the state to the valid speed range. */
-	state = thermal->cooling_levels[state];
+	state = max_t(unsigned long, MLXSW_THERMAL_MIN_STATE, state);
 	mlxsw_reg_mfsc_pack(mfsc_pl, idx, mlxsw_state_to_duty(state));
 	err = mlxsw_reg_write(thermal->core, MLXSW_REG(mfsc), mfsc_pl);
 	if (err) {
@@ -617,7 +495,8 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 	else
 		snprintf(tz_name, sizeof(tz_name), "mlxsw-module%d",
 			 module_tz->module + 1);
-	module_tz->tzdev = thermal_zone_device_register(tz_name,
+	module_tz->tzdev = thermal_zone_device_register_with_trips(tz_name,
+							module_tz->trips,
 							MLXSW_THERMAL_NUM_TRIPS,
 							MLXSW_THERMAL_TRIP_MASK,
 							module_tz,
@@ -661,6 +540,8 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 	module_tz->parent = thermal;
 	memcpy(module_tz->trips, default_thermal_trips,
 	       sizeof(thermal->trips));
+	memcpy(module_tz->cooling_states, default_cooling_states,
+	       sizeof(thermal->cooling_states));
 	/* Initialize all trip point. */
 	mlxsw_thermal_module_trips_reset(module_tz);
 	/* Read module temperature and thresholds. */
@@ -756,7 +637,8 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 	else
 		snprintf(tz_name, sizeof(tz_name), "mlxsw-gearbox%d",
 			 gearbox_tz->module + 1);
-	gearbox_tz->tzdev = thermal_zone_device_register(tz_name,
+	gearbox_tz->tzdev = thermal_zone_device_register_with_trips(tz_name,
+						gearbox_tz->trips,
 						MLXSW_THERMAL_NUM_TRIPS,
 						MLXSW_THERMAL_TRIP_MASK,
 						gearbox_tz,
@@ -813,6 +695,8 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 		gearbox_tz = &area->tz_gearbox_arr[i];
 		memcpy(gearbox_tz->trips, default_thermal_trips,
 		       sizeof(thermal->trips));
+		memcpy(gearbox_tz->cooling_states, default_cooling_states,
+		       sizeof(thermal->cooling_states));
 		gearbox_tz->module = i;
 		gearbox_tz->parent = thermal;
 		gearbox_tz->slot_index = area->slot_index;
@@ -928,6 +812,7 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 	thermal->core = core;
 	thermal->bus_info = bus_info;
 	memcpy(thermal->trips, default_thermal_trips, sizeof(thermal->trips));
+	memcpy(thermal->cooling_states, default_cooling_states, sizeof(thermal->cooling_states));
 	thermal->line_cards[0].slot_index = 0;
 
 	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mfcr), mfcr_pl);
@@ -973,15 +858,12 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 		}
 	}
 
-	/* Initialize cooling levels per PWM state. */
-	for (i = 0; i < MLXSW_THERMAL_MAX_STATE; i++)
-		thermal->cooling_levels[i] = max(MLXSW_THERMAL_MIN_STATE, i);
-
 	thermal->polling_delay = bus_info->low_frequency ?
 				 MLXSW_THERMAL_SLOW_POLL_INT :
 				 MLXSW_THERMAL_POLL_INT;
 
-	thermal->tzdev = thermal_zone_device_register("mlxsw",
+	thermal->tzdev = thermal_zone_device_register_with_trips("mlxsw",
+						      thermal->trips,
 						      MLXSW_THERMAL_NUM_TRIPS,
 						      MLXSW_THERMAL_TRIP_MASK,
 						      thermal,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 045a24cacfa5..b6ee2d658b0c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -1354,7 +1354,7 @@ static int mlxsw_sp_fid_8021q_port_vid_map(struct mlxsw_sp_fid *fid,
 					   u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	int err;
 
 	/* In case there are no {Port, VID} => FID mappings on the port,
@@ -1391,7 +1391,7 @@ mlxsw_sp_fid_8021q_port_vid_unmap(struct mlxsw_sp_fid *fid,
 				  struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index d17d1b4f2585..825356ee3492 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -292,7 +292,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
-	if (!laddr) {
+	if (dma_mapping_error(lp->device, laddr)) {
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
@@ -509,7 +509,7 @@ static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
 
 	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
 				   SONIC_RBSIZE, DMA_FROM_DEVICE);
-	if (!*new_addr) {
+	if (dma_mapping_error(lp->device, *new_addr)) {
 		dev_kfree_skb(*new_skb);
 		*new_skb = NULL;
 		return false;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 0848b5529d48..911509c2b17d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4404,6 +4404,9 @@ qed_iov_configure_min_tx_rate(struct qed_dev *cdev, int vfid, u32 rate)
 	}
 
 	vf = qed_iov_get_vf_info(QED_LEADING_HWFN(cdev), (u16)vfid, true);
+	if (!vf)
+		return -EINVAL;
+
 	vport_id = vf->vport_id;
 
 	return qed_configure_vport_wfq(cdev, vport_id, rate);
@@ -5152,7 +5155,7 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 
 		/* Validate that the VF has a configured vport */
 		vf = qed_iov_get_vf_info(hwfn, i, true);
-		if (!vf->vport_instance)
+		if (!vf || !vf->vport_instance)
 			continue;
 
 		memset(&params, 0, sizeof(params));
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 3115b2c12898..eaa50050aa0b 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -724,9 +724,15 @@ static int emac_remove(struct platform_device *pdev)
 	struct net_device *netdev = dev_get_drvdata(&pdev->dev);
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
 	unregister_netdev(netdev);
 	netif_napi_del(&adpt->rx_q.napi);
 
+	free_irq(adpt->irq.irq, &adpt->irq);
+	cancel_work_sync(&adpt->work_thread);
+
 	emac_clks_teardown(adpt);
 
 	put_device(&adpt->phydev->mdio.dev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 6b5d96bced47..ec9c130276d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -418,6 +418,7 @@ struct dma_features {
 	unsigned int frpbs;
 	unsigned int frpes;
 	unsigned int addr64;
+	unsigned int host_dma_width;
 	unsigned int rssen;
 	unsigned int vlhash;
 	unsigned int sphen;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index bd52fb7cf486..0d6a84199fd8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -251,7 +251,7 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 		goto err_parse_dt;
 	}
 
-	plat_dat->addr64 = dwmac->ops->addr_width;
+	plat_dat->host_dma_width = dwmac->ops->addr_width;
 	plat_dat->init = imx_dwmac_init;
 	plat_dat->exit = imx_dwmac_exit;
 	plat_dat->clks_config = imx_dwmac_clks_config;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 7deb1f817dac..13aa919633b4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -684,7 +684,7 @@ static int ehl_pse0_common_data(struct pci_dev *pdev,
 
 	intel_priv->is_pse = true;
 	plat->bus_id = 2;
-	plat->addr64 = 32;
+	plat->host_dma_width = 32;
 
 	plat->clk_ptp_rate = 200000000;
 
@@ -725,7 +725,7 @@ static int ehl_pse1_common_data(struct pci_dev *pdev,
 
 	intel_priv->is_pse = true;
 	plat->bus_id = 3;
-	plat->addr64 = 32;
+	plat->host_dma_width = 32;
 
 	plat->clk_ptp_rate = 200000000;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 2f7d8e4561d9..9ae31e3dc821 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -591,7 +591,7 @@ static int mediatek_dwmac_common_data(struct platform_device *pdev,
 	plat->use_phy_wol = priv_plat->mac_wol ? 0 : 1;
 	plat->riwt_off = 1;
 	plat->maxmtu = ETH_DATA_LEN;
-	plat->addr64 = priv_plat->variant->dma_bit_mask;
+	plat->host_dma_width = priv_plat->variant->dma_bit_mask;
 	plat->bsp_priv = priv_plat;
 	plat->init = mediatek_dwmac_init;
 	plat->clks_config = mediatek_dwmac_clks_config;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3c1d4b27668f..93321437f093 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1429,7 +1429,7 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv,
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
-	if (priv->dma_cap.addr64 <= 32)
+	if (priv->dma_cap.host_dma_width <= 32)
 		gfp |= GFP_DMA32;
 
 	if (!buf->page) {
@@ -4585,7 +4585,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 	unsigned int entry = rx_q->dirty_rx;
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
-	if (priv->dma_cap.addr64 <= 32)
+	if (priv->dma_cap.host_dma_width <= 32)
 		gfp |= GFP_DMA32;
 
 	while (dirty-- > 0) {
@@ -6201,7 +6201,7 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "\tFlexible RX Parser: %s\n",
 		   priv->dma_cap.frpsel ? "Y" : "N");
 	seq_printf(seq, "\tEnhanced Addressing: %d\n",
-		   priv->dma_cap.addr64);
+		   priv->dma_cap.host_dma_width);
 	seq_printf(seq, "\tReceive Side Scaling: %s\n",
 		   priv->dma_cap.rssen ? "Y" : "N");
 	seq_printf(seq, "\tVLAN Hash Filtering: %s\n",
@@ -7171,20 +7171,22 @@ int stmmac_dvr_probe(struct device *device,
 		dev_info(priv->device, "SPH feature enabled\n");
 	}
 
-	/* The current IP register MAC_HW_Feature1[ADDR64] only define
-	 * 32/40/64 bit width, but some SOC support others like i.MX8MP
-	 * support 34 bits but it map to 40 bits width in MAC_HW_Feature1[ADDR64].
-	 * So overwrite dma_cap.addr64 according to HW real design.
+	/* Ideally our host DMA address width is the same as for the
+	 * device. However, it may differ and then we have to use our
+	 * host DMA width for allocation and the device DMA width for
+	 * register handling.
 	 */
-	if (priv->plat->addr64)
-		priv->dma_cap.addr64 = priv->plat->addr64;
+	if (priv->plat->host_dma_width)
+		priv->dma_cap.host_dma_width = priv->plat->host_dma_width;
+	else
+		priv->dma_cap.host_dma_width = priv->dma_cap.addr64;
 
-	if (priv->dma_cap.addr64) {
+	if (priv->dma_cap.host_dma_width) {
 		ret = dma_set_mask_and_coherent(device,
-				DMA_BIT_MASK(priv->dma_cap.addr64));
+				DMA_BIT_MASK(priv->dma_cap.host_dma_width));
 		if (!ret) {
-			dev_info(priv->device, "Using %d bits DMA width\n",
-				 priv->dma_cap.addr64);
+			dev_info(priv->device, "Using %d/%d bits DMA host/device width\n",
+				 priv->dma_cap.host_dma_width, priv->dma_cap.addr64);
 
 			/*
 			 * If more than 32 bits can be addressed, make sure to
@@ -7199,7 +7201,7 @@ int stmmac_dvr_probe(struct device *device,
 				goto error_hw_init;
 			}
 
-			priv->dma_cap.addr64 = 32;
+			priv->dma_cap.host_dma_width = 32;
 		}
 	}
 
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index cf8de8a7a8a1..9d535ae59626 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -317,15 +317,17 @@ static int gelic_card_init_chain(struct gelic_card *card,
 
 	/* set up the hardware pointers in each descriptor */
 	for (i = 0; i < no; i++, descr++) {
+		dma_addr_t cpu_addr;
+
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
-		descr->bus_addr =
-			dma_map_single(ctodev(card), descr,
-				       GELIC_DESCR_SIZE,
-				       DMA_BIDIRECTIONAL);
 
-		if (!descr->bus_addr)
+		cpu_addr = dma_map_single(ctodev(card), descr,
+					  GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
+
+		if (dma_mapping_error(ctodev(card), cpu_addr))
 			goto iommu_error;
 
+		descr->bus_addr = cpu_to_be32(cpu_addr);
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 	}
@@ -365,26 +367,28 @@ static int gelic_card_init_chain(struct gelic_card *card,
  *
  * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
  * Activate the descriptor state-wise
+ *
+ * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the length
+ * must be a multiple of GELIC_NET_RXBUF_ALIGN.
  */
 static int gelic_descr_prepare_rx(struct gelic_card *card,
 				  struct gelic_descr *descr)
 {
+	static const unsigned int rx_skb_size =
+		ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
+		GELIC_NET_RXBUF_ALIGN - 1;
+	dma_addr_t cpu_addr;
 	int offset;
-	unsigned int bufsize;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
 		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
-	/* we need to round up the buffer size to a multiple of 128 */
-	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
 
-	/* and we need to have it 128 byte aligned, therefore we allocate a
-	 * bit more */
-	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
+	descr->skb = netdev_alloc_skb(*card->netdev, rx_skb_size);
 	if (!descr->skb) {
 		descr->buf_addr = 0; /* tell DMAC don't touch memory */
 		return -ENOMEM;
 	}
-	descr->buf_size = cpu_to_be32(bufsize);
+	descr->buf_size = cpu_to_be32(rx_skb_size);
 	descr->dmac_cmd_status = 0;
 	descr->result_size = 0;
 	descr->valid_size = 0;
@@ -395,11 +399,10 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	if (offset)
 		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
 	/* io-mmu-map the skb */
-	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
-						     descr->skb->data,
-						     GELIC_NET_MAX_MTU,
-						     DMA_FROM_DEVICE));
-	if (!descr->buf_addr) {
+	cpu_addr = dma_map_single(ctodev(card), descr->skb->data,
+				  GELIC_NET_MAX_FRAME, DMA_FROM_DEVICE);
+	descr->buf_addr = cpu_to_be32(cpu_addr);
+	if (dma_mapping_error(ctodev(card), cpu_addr)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		dev_info(ctodev(card),
@@ -779,7 +782,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 
 	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
 
-	if (!buf) {
+	if (dma_mapping_error(ctodev(card), buf)) {
 		dev_err(ctodev(card),
 			"dma map 2 failed (%p, %i). Dropping packet\n",
 			skb->data, skb->len);
@@ -915,7 +918,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr *descr,
 	data_error = be32_to_cpu(descr->data_error);
 	/* unmap skb buffer */
 	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
-			 GELIC_NET_MAX_MTU,
+			 GELIC_NET_MAX_FRAME,
 			 DMA_FROM_DEVICE);
 
 	skb_put(skb, be32_to_cpu(descr->valid_size)?
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index 68f324ed4eaf..0d98defb011e 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -19,8 +19,9 @@
 #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
 #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
 
-#define GELIC_NET_MAX_MTU               VLAN_ETH_FRAME_LEN
-#define GELIC_NET_MIN_MTU               VLAN_ETH_ZLEN
+#define GELIC_NET_MAX_FRAME             2312
+#define GELIC_NET_MAX_MTU               2294
+#define GELIC_NET_MIN_MTU               64
 #define GELIC_NET_RXBUF_ALIGN           128
 #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */
 #define GELIC_NET_WATCHDOG_TIMEOUT      5*HZ
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 894e92ef415b..9f505cf02d96 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -503,6 +503,11 @@ static void
 xirc2ps_detach(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+    struct local_info *local = netdev_priv(dev);
+
+    netif_carrier_off(dev);
+    netif_tx_disable(dev);
+    cancel_work_sync(&local->tx_timeout_task);
 
     dev_dbg(&link->dev, "detach\n");
 
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index e1a569b99e4a..0b0c6c0764fe 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1913,6 +1913,8 @@ static int ca8210_skb_tx(
 	 * packet
 	 */
 	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
+	if (mac_len < 0)
+		return mac_len;
 
 	secspec.security_level = header.sec.level;
 	secspec.key_id_mode = header.sec.key_id_mode;
diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
index d77c987fda9c..4630dde01974 100644
--- a/drivers/net/mdio/acpi_mdio.c
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -18,16 +18,18 @@ MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
 
 /**
- * acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
+ * __acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
  * @mdio: pointer to mii_bus structure
  * @fwnode: pointer to fwnode of MDIO bus. This fwnode is expected to represent
+ * @owner: module owning this @mdio object.
  * an ACPI device object corresponding to the MDIO bus and its children are
  * expected to correspond to the PHY devices on that bus.
  *
  * This function registers the mii_bus structure and registers a phy_device
  * for each child node of @fwnode.
  */
-int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+int __acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode,
+			    struct module *owner)
 {
 	struct fwnode_handle *child;
 	u32 addr;
@@ -35,7 +37,7 @@ int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
 
 	/* Mask out all PHYs from auto probing. */
 	mdio->phy_mask = GENMASK(31, 0);
-	ret = mdiobus_register(mdio);
+	ret = __mdiobus_register(mdio, owner);
 	if (ret)
 		return ret;
 
@@ -55,4 +57,4 @@ int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(acpi_mdiobus_register);
+EXPORT_SYMBOL(__acpi_mdiobus_register);
diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index 822d2cdd2f35..394b864aaa37 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -104,6 +104,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		if (i >= ARRAY_SIZE(nexus->buses))
 			break;
 	}
+	fwnode_handle_put(fwn);
 	return 0;
 
 err_release_regions:
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 510822d6d0d9..1e46e39f5f46 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -139,21 +139,23 @@ bool of_mdiobus_child_is_phy(struct device_node *child)
 EXPORT_SYMBOL(of_mdiobus_child_is_phy);
 
 /**
- * of_mdiobus_register - Register mii_bus and create PHYs from the device tree
+ * __of_mdiobus_register - Register mii_bus and create PHYs from the device tree
  * @mdio: pointer to mii_bus structure
  * @np: pointer to device_node of MDIO bus.
+ * @owner: module owning the @mdio object.
  *
  * This function registers the mii_bus structure and registers a phy_device
  * for each child node of @np.
  */
-int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
+int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
+			  struct module *owner)
 {
 	struct device_node *child;
 	bool scanphys = false;
 	int addr, rc;
 
 	if (!np)
-		return mdiobus_register(mdio);
+		return __mdiobus_register(mdio, owner);
 
 	/* Do not continue if the node is disabled */
 	if (!of_device_is_available(np))
@@ -172,7 +174,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
 
 	/* Register the MDIO bus */
-	rc = mdiobus_register(mdio);
+	rc = __mdiobus_register(mdio, owner);
 	if (rc)
 		return rc;
 
@@ -236,7 +238,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	mdiobus_unregister(mdio);
 	return rc;
 }
-EXPORT_SYMBOL(of_mdiobus_register);
+EXPORT_SYMBOL(__of_mdiobus_register);
 
 /**
  * of_mdio_find_device - Given a device tree node, find the mdio_device
diff --git a/drivers/net/phy/mdio_devres.c b/drivers/net/phy/mdio_devres.c
index b560e99695df..69b829e6ab35 100644
--- a/drivers/net/phy/mdio_devres.c
+++ b/drivers/net/phy/mdio_devres.c
@@ -98,13 +98,14 @@ EXPORT_SYMBOL(__devm_mdiobus_register);
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 /**
- * devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
+ * __devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
  * @dev:	Device to register mii_bus for
  * @mdio:	MII bus structure to register
  * @np:		Device node to parse
+ * @owner:	Owning module
  */
-int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
-			     struct device_node *np)
+int __devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			       struct device_node *np, struct module *owner)
 {
 	struct mdiobus_devres *dr;
 	int ret;
@@ -117,7 +118,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 	if (!dr)
 		return -ENOMEM;
 
-	ret = of_mdiobus_register(mdio, np);
+	ret = __of_mdiobus_register(mdio, np, owner);
 	if (ret) {
 		devres_free(dr);
 		return ret;
@@ -127,7 +128,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 	devres_add(dev, dr);
 	return 0;
 }
-EXPORT_SYMBOL(devm_of_mdiobus_register);
+EXPORT_SYMBOL(__devm_of_mdiobus_register);
 #endif /* CONFIG_OF_MDIO */
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e741d8aebffe..d1aea767ed09 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -57,6 +57,18 @@ static const char *phy_state_to_str(enum phy_state st)
 	return NULL;
 }
 
+static void phy_process_state_change(struct phy_device *phydev,
+				     enum phy_state old_state)
+{
+	if (old_state != phydev->state) {
+		phydev_dbg(phydev, "PHY state change %s -> %s\n",
+			   phy_state_to_str(old_state),
+			   phy_state_to_str(phydev->state));
+		if (phydev->drv && phydev->drv->link_change_notify)
+			phydev->drv->link_change_notify(phydev);
+	}
+}
+
 static void phy_link_up(struct phy_device *phydev)
 {
 	phydev->phy_link_change(phydev, true);
@@ -1093,6 +1105,7 @@ EXPORT_SYMBOL(phy_free_interrupt);
 void phy_stop(struct phy_device *phydev)
 {
 	struct net_device *dev = phydev->attached_dev;
+	enum phy_state old_state;
 
 	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
 		WARN(1, "called from state %s\n",
@@ -1101,6 +1114,7 @@ void phy_stop(struct phy_device *phydev)
 	}
 
 	mutex_lock(&phydev->lock);
+	old_state = phydev->state;
 
 	if (phydev->state == PHY_CABLETEST) {
 		phy_abort_cable_test(phydev);
@@ -1111,6 +1125,7 @@ void phy_stop(struct phy_device *phydev)
 		sfp_upstream_stop(phydev->sfp_bus);
 
 	phydev->state = PHY_HALTED;
+	phy_process_state_change(phydev, old_state);
 
 	mutex_unlock(&phydev->lock);
 
@@ -1228,13 +1243,7 @@ void phy_state_machine(struct work_struct *work)
 	if (err < 0)
 		phy_error(phydev);
 
-	if (old_state != phydev->state) {
-		phydev_dbg(phydev, "PHY state change %s -> %s\n",
-			   phy_state_to_str(old_state),
-			   phy_state_to_str(phydev->state));
-		if (phydev->drv && phydev->drv->link_change_notify)
-			phydev->drv->link_change_notify(phydev);
-	}
+	phy_process_state_change(phydev, old_state);
 
 	/* Only re-schedule a PHY state machine change if we are polling the
 	 * PHY, if PHY_MAC_INTERRUPT is set, then we will be moving
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 11f60d32be82..6eacbf17f1c0 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -666,8 +666,9 @@ static int asix_resume(struct usb_interface *intf)
 static int ax88772_init_mdio(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
+	int ret;
 
-	priv->mdio = devm_mdiobus_alloc(&dev->udev->dev);
+	priv->mdio = mdiobus_alloc();
 	if (!priv->mdio)
 		return -ENOMEM;
 
@@ -679,7 +680,20 @@ static int ax88772_init_mdio(struct usbnet *dev)
 	snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
 		 dev->udev->bus->busnum, dev->udev->devnum);
 
-	return devm_mdiobus_register(&dev->udev->dev, priv->mdio);
+	ret = mdiobus_register(priv->mdio);
+	if (ret) {
+		netdev_err(dev->net, "Could not register MDIO bus (err %d)\n", ret);
+		mdiobus_free(priv->mdio);
+		priv->mdio = NULL;
+	}
+
+	return ret;
+}
+
+static void ax88772_mdio_unregister(struct asix_common_private *priv)
+{
+	mdiobus_unregister(priv->mdio);
+	mdiobus_free(priv->mdio);
 }
 
 static int ax88772_init_phy(struct usbnet *dev)
@@ -897,16 +911,23 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	ret = ax88772_init_mdio(dev);
 	if (ret)
-		return ret;
+		goto mdio_err;
 
 	ret = ax88772_phylink_setup(dev);
 	if (ret)
-		return ret;
+		goto phylink_err;
 
 	ret = ax88772_init_phy(dev);
 	if (ret)
-		phylink_destroy(priv->phylink);
+		goto initphy_err;
 
+	return 0;
+
+initphy_err:
+	phylink_destroy(priv->phylink);
+phylink_err:
+	ax88772_mdio_unregister(priv);
+mdio_err:
 	return ret;
 }
 
@@ -927,6 +948,7 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 	phylink_disconnect_phy(priv->phylink);
 	rtnl_unlock();
 	phylink_destroy(priv->phylink);
+	ax88772_mdio_unregister(priv);
 	asix_rx_fixup_common_free(dev->driver_priv);
 }
 
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index c89639381eca..cd4083e0b3b9 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -665,6 +665,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FE990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1081, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 068488890d57..c458c030fadf 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3579,13 +3579,29 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb,
 		size = (rx_cmd_a & RX_CMD_A_LEN_MASK_);
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err rx_cmd_a=0x%08x\n",
+				  rx_cmd_a);
+			return 0;
+		}
+
 		if (unlikely(rx_cmd_a & RX_CMD_A_RED_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x", rx_cmd_a);
 		} else {
-			u32 frame_len = size - ETH_FCS_LEN;
+			u32 frame_len;
 			struct sk_buff *skb2;
 
+			if (unlikely(size < ETH_FCS_LEN)) {
+				netif_dbg(dev, rx_err, dev->net,
+					  "size err rx_cmd_a=0x%08x\n",
+					  rx_cmd_a);
+				return 0;
+			}
+
+			frame_len = size - ETH_FCS_LEN;
+
 			skb2 = napi_alloc_skb(&dev->napi, frame_len);
 			if (!skb2)
 				return 0;
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 554d4e2a84a4..2cc28af52ee2 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1363,6 +1363,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1057, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1080, 2)}, /* Telit FE990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 32d2c60d334d..563ecd27b93e 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1833,6 +1833,12 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (u16)((header & RX_STS_FL_) >> 16);
 		align_count = (4 - ((size + NET_IP_ALIGN) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err header=0x%08x\n", header);
+			return 0;
+		}
+
 		if (unlikely(header & RX_STS_ES_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error header=0x%08x\n", header);
diff --git a/drivers/platform/chrome/cros_ec_chardev.c b/drivers/platform/chrome/cros_ec_chardev.c
index 0de7c255254e..d6de5a294128 100644
--- a/drivers/platform/chrome/cros_ec_chardev.c
+++ b/drivers/platform/chrome/cros_ec_chardev.c
@@ -284,7 +284,7 @@ static long cros_ec_chardev_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
 	    u_cmd.insize > EC_MAX_MSG_BYTES)
 		return -EINVAL;
 
-	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
+	s_cmd = kzalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
 			GFP_KERNEL);
 	if (!s_cmd)
 		return -ENOMEM;
diff --git a/drivers/platform/x86/intel/int3472/tps68470_board_data.c b/drivers/platform/x86/intel/int3472/tps68470_board_data.c
index 309eab9c0558..322237e056f3 100644
--- a/drivers/platform/x86/intel/int3472/tps68470_board_data.c
+++ b/drivers/platform/x86/intel/int3472/tps68470_board_data.c
@@ -159,9 +159,10 @@ static const struct int3472_tps68470_board_data surface_go_tps68470_board_data =
 static const struct int3472_tps68470_board_data surface_go3_tps68470_board_data = {
 	.dev_name = "i2c-INT3472:01",
 	.tps68470_regulator_pdata = &surface_go_tps68470_pdata,
-	.n_gpiod_lookups = 1,
+	.n_gpiod_lookups = 2,
 	.tps68470_gpio_lookup_tables = {
-		&surface_go_int347a_gpios
+		&surface_go_int347a_gpios,
+		&surface_go_int347e_gpios,
 	},
 };
 
diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 2274679c5ddd..d7400b56820d 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -1906,6 +1906,7 @@ static void bq24190_remove(struct i2c_client *client)
 	struct bq24190_dev_info *bdi = i2c_get_clientdata(client);
 	int error;
 
+	cancel_delayed_work_sync(&bdi->input_current_limit_work);
 	error = pm_runtime_resume_and_get(bdi->dev);
 	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
diff --git a/drivers/power/supply/da9150-charger.c b/drivers/power/supply/da9150-charger.c
index f9314cc0cd75..6b987da58655 100644
--- a/drivers/power/supply/da9150-charger.c
+++ b/drivers/power/supply/da9150-charger.c
@@ -662,6 +662,7 @@ static int da9150_charger_remove(struct platform_device *pdev)
 
 	if (!IS_ERR_OR_NULL(charger->usb_phy))
 		usb_unregister_notifier(charger->usb_phy, &charger->otg_nb);
+	cancel_work_sync(&charger->otg_work);
 
 	power_supply_unregister(charger->battery);
 	power_supply_unregister(charger->usb);
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 610a51538f03..0781f991e784 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1117,10 +1117,12 @@ static int alua_activate(struct scsi_device *sdev,
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	if (alua_rtpg_queue(pg, sdev, qdata, true))
+	if (alua_rtpg_queue(pg, sdev, qdata, true)) {
 		fn = NULL;
-	else
+	} else {
+		kfree(qdata);
 		err = SCSI_DH_DEV_OFFLINED;
+	}
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d56b4bfd2767..620dcefe7b6f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2448,8 +2448,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
-	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
-	return 0;
+	return devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 }
 
 static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b535f1fd3010..2f38c8d5a48a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7234,6 +7234,8 @@ lpfc_sli4_cgn_params_read(struct lpfc_hba *phba)
 	/* Find out if the FW has a new set of congestion parameters. */
 	len = sizeof(struct lpfc_cgn_param);
 	pdata = kzalloc(len, GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
 	ret = lpfc_read_object(phba, (char *)LPFC_PORT_CFG_NAME,
 			       pdata, len);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b93c948c4fcc..b44bb3ae22ad 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -21886,20 +21886,20 @@ lpfc_get_io_buf_from_private_pool(struct lpfc_hba *phba,
 static struct lpfc_io_buf *
 lpfc_get_io_buf_from_expedite_pool(struct lpfc_hba *phba)
 {
-	struct lpfc_io_buf *lpfc_ncmd;
+	struct lpfc_io_buf *lpfc_ncmd = NULL, *iter;
 	struct lpfc_io_buf *lpfc_ncmd_next;
 	unsigned long iflag;
 	struct lpfc_epd_pool *epd_pool;
 
 	epd_pool = &phba->epd_pool;
-	lpfc_ncmd = NULL;
 
 	spin_lock_irqsave(&epd_pool->lock, iflag);
 	if (epd_pool->count > 0) {
-		list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+		list_for_each_entry_safe(iter, lpfc_ncmd_next,
 					 &epd_pool->list, list) {
-			list_del(&lpfc_ncmd->list);
+			list_del(&iter->list);
 			epd_pool->count--;
+			lpfc_ncmd = iter;
 			break;
 		}
 	}
@@ -22096,10 +22096,6 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 	struct lpfc_dmabuf *pcmd;
 	u32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW] = {0};
 
-	/* sanity check on queue memory */
-	if (!datap)
-		return -ENODEV;
-
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index bff637702397..d10c6afb7f9c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -886,7 +886,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 			 * each time through the loop.
 			 */
 			*prp_entry = cpu_to_le64(dma_addr);
-			if (*prp1_entry & sgemod_mask) {
+			if (*prp_entry & sgemod_mask) {
 				dprint_bsg_err(mrioc,
 				    "%s: PRP address collides with SGE modifier\n",
 				    __func__);
@@ -895,7 +895,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 			*prp_entry &= ~sgemod_mask;
 			*prp_entry |= sgemod_val;
 			prp_entry++;
-			prp_entry_dma++;
+			prp_entry_dma += prp_size;
 		}
 
 		/*
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 74fa7f90399e..ea9e69fb6282 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1198,7 +1198,7 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
  */
 static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 {
-	u32 ioc_config, ioc_status, timeout;
+	u32 ioc_config, ioc_status, timeout, host_diagnostic;
 	int retval = 0;
 	enum mpi3mr_iocstate ioc_state;
 	u64 base_info;
@@ -1252,6 +1252,23 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			    retval, mpi3mr_iocstate_name(ioc_state));
 	}
 	if (ioc_state != MRIOC_STATE_RESET) {
+		if (ioc_state == MRIOC_STATE_FAULT) {
+			timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
+			mpi3mr_print_fault_info(mrioc);
+			do {
+				host_diagnostic =
+					readl(&mrioc->sysif_regs->host_diagnostic);
+				if (!(host_diagnostic &
+				      MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS))
+					break;
+				if (!pci_device_is_present(mrioc->pdev)) {
+					mrioc->unrecoverable = 1;
+					ioc_err(mrioc, "controller is not present at the bringup\n");
+					goto out_device_not_present;
+				}
+				msleep(100);
+			} while (--timeout);
+		}
 		mpi3mr_print_fault_info(mrioc);
 		ioc_info(mrioc, "issuing soft reset to bring to reset state\n");
 		retval = mpi3mr_issue_reset(mrioc,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 50263ba4f842..5748bd9369ff 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1549,7 +1549,8 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 
 	list_for_each_entry_safe(mr_sas_phy, next_phy,
 	    &mr_sas_port->phy_list, port_siblings) {
-		if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
+		if ((!mrioc->stop_drv_processing) &&
+		    (mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
 			dev_info(&mr_sas_port->port->dev,
 			    "remove: sas_address(0x%016llx), phy(%d)\n",
 			    (unsigned long long)
@@ -2354,15 +2355,16 @@ int mpi3mr_report_tgtdev_to_sas_transport(struct mpi3mr_ioc *mrioc,
 	tgtdev->host_exposed = 1;
 	if (!mpi3mr_sas_port_add(mrioc, tgtdev->dev_handle,
 	    sas_address_parent, hba_port)) {
-		tgtdev->host_exposed = 0;
 		retval = -1;
-	} else if ((!tgtdev->starget)) {
-		if (!mrioc->is_driver_loading)
+		} else if ((!tgtdev->starget) && (!mrioc->is_driver_loading)) {
 			mpi3mr_sas_port_remove(mrioc, sas_address,
 			    sas_address_parent, hba_port);
-		tgtdev->host_exposed = 0;
 		retval = -1;
 	}
+	if (retval) {
+		tgtdev->dev_spec.sas_sata_inf.hba_port = NULL;
+		tgtdev->host_exposed = 0;
+	}
 	return retval;
 }
 
@@ -2391,6 +2393,7 @@ void mpi3mr_remove_tgtdev_from_sas_transport(struct mpi3mr_ioc *mrioc,
 	mpi3mr_sas_port_remove(mrioc, sas_address, sas_address_parent,
 	    hba_port);
 	tgtdev->host_exposed = 0;
+	tgtdev->dev_spec.sas_sata_inf.hba_port = NULL;
 }
 
 /**
@@ -2447,7 +2450,7 @@ static u8 mpi3mr_get_port_id_by_rphy(struct mpi3mr_ioc *mrioc, struct sas_rphy *
 
 		tgtdev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
 			    rphy->identify.sas_address, rphy);
-		if (tgtdev) {
+		if (tgtdev && tgtdev->dev_spec.sas_sata_inf.hba_port) {
 			port_id =
 				tgtdev->dev_spec.sas_sata_inf.hba_port->port_id;
 			mpi3mr_tgtdev_put(tgtdev);
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e3256e721be1..ee54207fc531 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -192,6 +192,7 @@ extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
 extern u32 ql2xnvme_queues;
+extern int ql2xfc2target;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a8d822c4e3ba..93f7f3dd5d82 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1841,7 +1841,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	case RSCN_PORT_ADDR:
 		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 		if (fcport) {
-			if (fcport->flags & FCF_FCP2_DEVICE &&
+			if (ql2xfc2target &&
+			    fcport->flags & FCF_FCP2_DEVICE &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				ql_dbg(ql_dbg_disc, vha, 0x2115,
 				       "Delaying session delete for FCP2 portid=%06x %8phC ",
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index cbbd7014da93..86928a762a7a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1900,6 +1900,8 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 	}
 
 	req->outstanding_cmds[index] = NULL;
+
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	return sp;
 }
 
@@ -3112,7 +3114,6 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	}
 	bsg_reply->reply_payload_rcv_len = 0;
 
-	qla_put_fw_resources(sp->qpair, &sp->iores);
 done:
 	/* Return the vendor specific reply to API */
 	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6e33dc16ce6f..7d2d872bae3c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -360,6 +360,13 @@ MODULE_PARM_DESC(ql2xnvme_queues,
 	"1 - Minimum number of queues supported\n"
 	"8 - Default value");
 
+int ql2xfc2target = 1;
+module_param(ql2xfc2target, int, 0444);
+MODULE_PARM_DESC(qla2xfc2target,
+		  "Enables FC2 Target support. "
+		  "0 - FC2 Target support is disabled. "
+		  "1 - FC2 Target support is enabled (default).");
+
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
 struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
 
@@ -1848,6 +1855,17 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
 		if (sp) {
+			/*
+			 * perform lockless completion during driver unload
+			 */
+			if (qla2x00_chip_is_down(vha)) {
+				req->outstanding_cmds[cnt] = NULL;
+				spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
+				sp->done(sp, res);
+				spin_lock_irqsave(qp->qp_lock_ptr, flags);
+				continue;
+			}
+
 			switch (sp->cmd_type) {
 			case TYPE_SRB:
 				qla2x00_abort_srb(qp, sp, res, &flags);
@@ -4076,7 +4094,8 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
 	    "Mark all dev lost\n");
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-		if (fcport->loop_id != FC_NO_LOOP_ID &&
+		if (ql2xfc2target &&
+		    fcport->loop_id != FC_NO_LOOP_ID &&
 		    (fcport->flags & FCF_FCP2_DEVICE) &&
 		    fcport->port_type == FCT_TARGET &&
 		    !qla2x00_reset_active(vha)) {
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index bc9d280417f6..3fcaf10a9dfe 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -234,6 +234,7 @@ static struct {
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
 	{"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"SKhynix", "H28U74301AMR", NULL, BLIST_SKIP_VPD_PAGES},
 	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 55d6fb452680..a0665bca54b9 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -987,6 +987,22 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 				goto do_work;
 			}
 
+			/*
+			 * Check for "Operating parameters have changed"
+			 * due to Hyper-V changing the VHD/VHDX BlockSize
+			 * when adding/removing a differencing disk. This
+			 * causes discard_granularity to change, so do a
+			 * rescan to pick up the new granularity. We don't
+			 * want scsi_report_sense() to output a message
+			 * that a sysadmin wouldn't know what to do with.
+			 */
+			if ((asc == 0x3f) && (ascq != 0x03) &&
+					(ascq != 0x0e)) {
+				process_err_fn = storvsc_device_scan;
+				set_host_byte(scmnd, DID_REQUEUE);
+				goto do_work;
+			}
+
 			/*
 			 * Otherwise, let upper layer deal with the
 			 * error when sense message is present
diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 82c3cfdcc560..9c6cf2f5d77c 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -170,9 +170,9 @@ static const struct llcc_slice_config sc8280xp_data[] = {
 	{ LLCC_CVP,      28, 512,  3, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
 	{ LLCC_APTCM,    30, 1024, 3, 1, 0x0,   0x1, 1, 0, 0, 1, 0, 0 },
 	{ LLCC_WRCACHE,  31, 1024, 1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
-	{ LLCC_CVPFW,    32, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
-	{ LLCC_CPUSS1,   33, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
-	{ LLCC_CPUHWT,   36, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
+	{ LLCC_CVPFW,    17, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
+	{ LLCC_CPUSS1,   3, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
+	{ LLCC_CPUHWT,   5, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
 };
 
 static const struct llcc_slice_config sdm845_data[] =  {
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 2317fb077db0..557516c642c3 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1262,18 +1262,20 @@ static struct iscsi_param *iscsi_check_key(
 		return param;
 
 	if (!(param->phase & phase)) {
-		pr_err("Key \"%s\" may not be negotiated during ",
-				param->name);
+		char *phase_name;
+
 		switch (phase) {
 		case PHASE_SECURITY:
-			pr_debug("Security phase.\n");
+			phase_name = "Security";
 			break;
 		case PHASE_OPERATIONAL:
-			pr_debug("Operational phase.\n");
+			phase_name = "Operational";
 			break;
 		default:
-			pr_debug("Unknown phase.\n");
+			phase_name = "Unknown";
 		}
+		pr_err("Key \"%s\" may not be negotiated during %s phase.\n",
+				param->name, phase_name);
 		return NULL;
 	}
 
diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index 297dc62bca29..372d64756ed6 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -267,35 +267,34 @@ int amdtee_open_session(struct tee_context *ctx,
 		goto out;
 	}
 
+	/* Open session with loaded TA */
+	handle_open_session(arg, &session_info, param);
+	if (arg->ret != TEEC_SUCCESS) {
+		pr_err("open_session failed %d\n", arg->ret);
+		handle_unload_ta(ta_handle);
+		kref_put(&sess->refcount, destroy_session);
+		goto out;
+	}
+
 	/* Find an empty session index for the given TA */
 	spin_lock(&sess->lock);
 	i = find_first_zero_bit(sess->sess_mask, TEE_NUM_SESSIONS);
-	if (i < TEE_NUM_SESSIONS)
+	if (i < TEE_NUM_SESSIONS) {
+		sess->session_info[i] = session_info;
+		set_session_id(ta_handle, i, &arg->session);
 		set_bit(i, sess->sess_mask);
+	}
 	spin_unlock(&sess->lock);
 
 	if (i >= TEE_NUM_SESSIONS) {
 		pr_err("reached maximum session count %d\n", TEE_NUM_SESSIONS);
+		handle_close_session(ta_handle, session_info);
 		handle_unload_ta(ta_handle);
 		kref_put(&sess->refcount, destroy_session);
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	/* Open session with loaded TA */
-	handle_open_session(arg, &session_info, param);
-	if (arg->ret != TEEC_SUCCESS) {
-		pr_err("open_session failed %d\n", arg->ret);
-		spin_lock(&sess->lock);
-		clear_bit(i, sess->sess_mask);
-		spin_unlock(&sess->lock);
-		handle_unload_ta(ta_handle);
-		kref_put(&sess->refcount, destroy_session);
-		goto out;
-	}
-
-	sess->session_info[i] = session_info;
-	set_session_id(ta_handle, i, &arg->session);
 out:
 	free_pages((u64)ta, get_order(ta_size));
 	return rc;
diff --git a/drivers/thunderbolt/debugfs.c b/drivers/thunderbolt/debugfs.c
index 834bcad42e9f..d89f92032c1c 100644
--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -942,7 +942,8 @@ static void margining_port_remove(struct tb_port *port)
 
 	snprintf(dir_name, sizeof(dir_name), "port%d", port->port);
 	parent = debugfs_lookup(dir_name, port->sw->debugfs_dir);
-	debugfs_remove_recursive(debugfs_lookup("margining", parent));
+	if (parent)
+		debugfs_remove_recursive(debugfs_lookup("margining", parent));
 
 	kfree(port->usb4->margining);
 	port->usb4->margining = NULL;
@@ -967,19 +968,18 @@ static void margining_switch_init(struct tb_switch *sw)
 
 static void margining_switch_remove(struct tb_switch *sw)
 {
+	struct tb_port *upstream, *downstream;
 	struct tb_switch *parent_sw;
-	struct tb_port *downstream;
 	u64 route = tb_route(sw);
 
 	if (!route)
 		return;
 
-	/*
-	 * Upstream is removed with the router itself but we need to
-	 * remove the downstream port margining directory.
-	 */
+	upstream = tb_upstream_port(sw);
 	parent_sw = tb_switch_parent(sw);
 	downstream = tb_port_at(route, parent_sw);
+
+	margining_port_remove(upstream);
 	margining_port_remove(downstream);
 }
 
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 4dce2edd86ea..cfebec107f3f 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -46,7 +46,7 @@
 #define QUIRK_AUTO_CLEAR_INT	BIT(0)
 #define QUIRK_E2E		BIT(1)
 
-static int ring_interrupt_index(struct tb_ring *ring)
+static int ring_interrupt_index(const struct tb_ring *ring)
 {
 	int bit = ring->hop;
 	if (!ring->is_tx)
@@ -63,13 +63,14 @@ static void ring_interrupt_active(struct tb_ring *ring, bool active)
 {
 	int reg = REG_RING_INTERRUPT_BASE +
 		  ring_interrupt_index(ring) / 32 * 4;
-	int bit = ring_interrupt_index(ring) & 31;
-	int mask = 1 << bit;
+	int interrupt_bit = ring_interrupt_index(ring) & 31;
+	int mask = 1 << interrupt_bit;
 	u32 old, new;
 
 	if (ring->irq > 0) {
 		u32 step, shift, ivr, misc;
 		void __iomem *ivr_base;
+		int auto_clear_bit;
 		int index;
 
 		if (ring->is_tx)
@@ -77,18 +78,25 @@ static void ring_interrupt_active(struct tb_ring *ring, bool active)
 		else
 			index = ring->hop + ring->nhi->hop_count;
 
-		if (ring->nhi->quirks & QUIRK_AUTO_CLEAR_INT) {
-			/*
-			 * Ask the hardware to clear interrupt status
-			 * bits automatically since we already know
-			 * which interrupt was triggered.
-			 */
-			misc = ioread32(ring->nhi->iobase + REG_DMA_MISC);
-			if (!(misc & REG_DMA_MISC_INT_AUTO_CLEAR)) {
-				misc |= REG_DMA_MISC_INT_AUTO_CLEAR;
-				iowrite32(misc, ring->nhi->iobase + REG_DMA_MISC);
-			}
-		}
+		/*
+		 * Intel routers support a bit that isn't part of
+		 * the USB4 spec to ask the hardware to clear
+		 * interrupt status bits automatically since
+		 * we already know which interrupt was triggered.
+		 *
+		 * Other routers explicitly disable auto-clear
+		 * to prevent conditions that may occur where two
+		 * MSIX interrupts are simultaneously active and
+		 * reading the register clears both of them.
+		 */
+		misc = ioread32(ring->nhi->iobase + REG_DMA_MISC);
+		if (ring->nhi->quirks & QUIRK_AUTO_CLEAR_INT)
+			auto_clear_bit = REG_DMA_MISC_INT_AUTO_CLEAR;
+		else
+			auto_clear_bit = REG_DMA_MISC_DISABLE_AUTO_CLEAR;
+		if (!(misc & auto_clear_bit))
+			iowrite32(misc | auto_clear_bit,
+				  ring->nhi->iobase + REG_DMA_MISC);
 
 		ivr_base = ring->nhi->iobase + REG_INT_VEC_ALLOC_BASE;
 		step = index / REG_INT_VEC_ALLOC_REGS * REG_INT_VEC_ALLOC_BITS;
@@ -108,7 +116,7 @@ static void ring_interrupt_active(struct tb_ring *ring, bool active)
 
 	dev_dbg(&ring->nhi->pdev->dev,
 		"%s interrupt at register %#x bit %d (%#x -> %#x)\n",
-		active ? "enabling" : "disabling", reg, bit, old, new);
+		active ? "enabling" : "disabling", reg, interrupt_bit, old, new);
 
 	if (new == old)
 		dev_WARN(&ring->nhi->pdev->dev,
@@ -393,14 +401,17 @@ EXPORT_SYMBOL_GPL(tb_ring_poll_complete);
 
 static void ring_clear_msix(const struct tb_ring *ring)
 {
+	int bit;
+
 	if (ring->nhi->quirks & QUIRK_AUTO_CLEAR_INT)
 		return;
 
+	bit = ring_interrupt_index(ring) & 31;
 	if (ring->is_tx)
-		ioread32(ring->nhi->iobase + REG_RING_NOTIFY_BASE);
+		iowrite32(BIT(bit), ring->nhi->iobase + REG_RING_INT_CLEAR);
 	else
-		ioread32(ring->nhi->iobase + REG_RING_NOTIFY_BASE +
-			 4 * (ring->nhi->hop_count / 32));
+		iowrite32(BIT(bit), ring->nhi->iobase + REG_RING_INT_CLEAR +
+			  4 * (ring->nhi->hop_count / 32));
 }
 
 static irqreturn_t ring_msix(int irq, void *data)
diff --git a/drivers/thunderbolt/nhi_regs.h b/drivers/thunderbolt/nhi_regs.h
index 0d4970dcef84..faef165a919c 100644
--- a/drivers/thunderbolt/nhi_regs.h
+++ b/drivers/thunderbolt/nhi_regs.h
@@ -77,12 +77,13 @@ struct ring_desc {
 
 /*
  * three bitfields: tx, rx, rx overflow
- * Every bitfield contains one bit for every hop (REG_HOP_COUNT). Registers are
- * cleared on read. New interrupts are fired only after ALL registers have been
+ * Every bitfield contains one bit for every hop (REG_HOP_COUNT).
+ * New interrupts are fired only after ALL registers have been
  * read (even those containing only disabled rings).
  */
 #define REG_RING_NOTIFY_BASE	0x37800
 #define RING_NOTIFY_REG_COUNT(nhi) ((31 + 3 * nhi->hop_count) / 32)
+#define REG_RING_INT_CLEAR	0x37808
 
 /*
  * two bitfields: rx, tx
@@ -105,6 +106,7 @@ struct ring_desc {
 
 #define REG_DMA_MISC			0x39864
 #define REG_DMA_MISC_INT_AUTO_CLEAR     BIT(2)
+#define REG_DMA_MISC_DISABLE_AUTO_CLEAR	BIT(17)
 
 #define REG_INMAIL_DATA			0x39900
 
diff --git a/drivers/thunderbolt/quirks.c b/drivers/thunderbolt/quirks.c
index b5f2ec79c4d6..ae28a03fa890 100644
--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -20,6 +20,12 @@ static void quirk_dp_credit_allocation(struct tb_switch *sw)
 	}
 }
 
+static void quirk_clx_disable(struct tb_switch *sw)
+{
+	sw->quirks |= QUIRK_NO_CLX;
+	tb_sw_dbg(sw, "disabling CL states\n");
+}
+
 struct tb_quirk {
 	u16 hw_vendor_id;
 	u16 hw_device_id;
@@ -37,6 +43,13 @@ static const struct tb_quirk tb_quirks[] = {
 	 * DP buffers.
 	 */
 	{ 0x8087, 0x0b26, 0x0000, 0x0000, quirk_dp_credit_allocation },
+	/*
+	 * CLx is not supported on AMD USB4 Yellow Carp and Pink Sardine platforms.
+	 */
+	{ 0x0438, 0x0208, 0x0000, 0x0000, quirk_clx_disable },
+	{ 0x0438, 0x0209, 0x0000, 0x0000, quirk_clx_disable },
+	{ 0x0438, 0x020a, 0x0000, 0x0000, quirk_clx_disable },
+	{ 0x0438, 0x020b, 0x0000, 0x0000, quirk_clx_disable },
 };
 
 /**
diff --git a/drivers/thunderbolt/retimer.c b/drivers/thunderbolt/retimer.c
index 56008eb91e2e..9cc28197dbc4 100644
--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -187,6 +187,22 @@ static ssize_t nvm_authenticate_show(struct device *dev,
 	return ret;
 }
 
+static void tb_retimer_set_inbound_sbtx(struct tb_port *port)
+{
+	int i;
+
+	for (i = 1; i <= TB_MAX_RETIMER_INDEX; i++)
+		usb4_port_retimer_set_inbound_sbtx(port, i);
+}
+
+static void tb_retimer_unset_inbound_sbtx(struct tb_port *port)
+{
+	int i;
+
+	for (i = TB_MAX_RETIMER_INDEX; i >= 1; i--)
+		usb4_port_retimer_unset_inbound_sbtx(port, i);
+}
+
 static ssize_t nvm_authenticate_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -213,6 +229,7 @@ static ssize_t nvm_authenticate_store(struct device *dev,
 	rt->auth_status = 0;
 
 	if (val) {
+		tb_retimer_set_inbound_sbtx(rt->port);
 		if (val == AUTHENTICATE_ONLY) {
 			ret = tb_retimer_nvm_authenticate(rt, true);
 		} else {
@@ -232,6 +249,7 @@ static ssize_t nvm_authenticate_store(struct device *dev,
 	}
 
 exit_unlock:
+	tb_retimer_unset_inbound_sbtx(rt->port);
 	mutex_unlock(&rt->tb->lock);
 exit_rpm:
 	pm_runtime_mark_last_busy(&rt->dev);
@@ -440,8 +458,7 @@ int tb_retimer_scan(struct tb_port *port, bool add)
 	 * Enable sideband channel for each retimer. We can do this
 	 * regardless whether there is device connected or not.
 	 */
-	for (i = 1; i <= TB_MAX_RETIMER_INDEX; i++)
-		usb4_port_retimer_set_inbound_sbtx(port, i);
+	tb_retimer_set_inbound_sbtx(port);
 
 	/*
 	 * Before doing anything else, read the authentication status.
@@ -464,6 +481,8 @@ int tb_retimer_scan(struct tb_port *port, bool add)
 			break;
 	}
 
+	tb_retimer_unset_inbound_sbtx(port);
+
 	if (!last_idx)
 		return 0;
 
diff --git a/drivers/thunderbolt/sb_regs.h b/drivers/thunderbolt/sb_regs.h
index 5185cf3e4d97..f37a4320f10a 100644
--- a/drivers/thunderbolt/sb_regs.h
+++ b/drivers/thunderbolt/sb_regs.h
@@ -20,6 +20,7 @@ enum usb4_sb_opcode {
 	USB4_SB_OPCODE_ROUTER_OFFLINE = 0x4e45534c,		/* "LSEN" */
 	USB4_SB_OPCODE_ENUMERATE_RETIMERS = 0x4d554e45,		/* "ENUM" */
 	USB4_SB_OPCODE_SET_INBOUND_SBTX = 0x5055534c,		/* "LSUP" */
+	USB4_SB_OPCODE_UNSET_INBOUND_SBTX = 0x50555355,		/* "USUP" */
 	USB4_SB_OPCODE_QUERY_LAST_RETIMER = 0x5453414c,		/* "LAST" */
 	USB4_SB_OPCODE_GET_NVM_SECTOR_SIZE = 0x53534e47,	/* "GNSS" */
 	USB4_SB_OPCODE_NVM_SET_OFFSET = 0x53504f42,		/* "BOPS" */
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 60da5c23ccaf..9699d167d522 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2959,8 +2959,6 @@ int tb_switch_add(struct tb_switch *sw)
 			dev_warn(&sw->dev, "reading DROM failed: %d\n", ret);
 		tb_sw_dbg(sw, "uid: %#llx\n", sw->uid);
 
-		tb_check_quirks(sw);
-
 		ret = tb_switch_set_uuid(sw);
 		if (ret) {
 			dev_err(&sw->dev, "failed to set UUID\n");
@@ -2979,6 +2977,8 @@ int tb_switch_add(struct tb_switch *sw)
 			}
 		}
 
+		tb_check_quirks(sw);
+
 		tb_switch_default_link_ports(sw);
 
 		ret = tb_switch_update_link_attributes(sw);
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index f9786976f5ec..e11d973a8f9b 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -23,6 +23,11 @@
 #define NVM_MAX_SIZE		SZ_512K
 #define NVM_DATA_DWORDS		16
 
+/* Keep link controller awake during update */
+#define QUIRK_FORCE_POWER_LINK_CONTROLLER		BIT(0)
+/* Disable CLx if not supported */
+#define QUIRK_NO_CLX					BIT(1)
+
 /**
  * struct tb_nvm - Structure holding NVM information
  * @dev: Owner of the NVM
@@ -997,6 +1002,9 @@ static inline bool tb_switch_is_clx_enabled(const struct tb_switch *sw,
  */
 static inline bool tb_switch_is_clx_supported(const struct tb_switch *sw)
 {
+	if (sw->quirks & QUIRK_NO_CLX)
+		return false;
+
 	return tb_switch_is_usb4(sw) || tb_switch_is_titan_ridge(sw);
 }
 
@@ -1212,6 +1220,7 @@ int usb4_port_sw_margin(struct tb_port *port, unsigned int lanes, bool timing,
 int usb4_port_sw_margin_errors(struct tb_port *port, u32 *errors);
 
 int usb4_port_retimer_set_inbound_sbtx(struct tb_port *port, u8 index);
+int usb4_port_retimer_unset_inbound_sbtx(struct tb_port *port, u8 index);
 int usb4_port_retimer_read(struct tb_port *port, u8 index, u8 reg, void *buf,
 			   u8 size);
 int usb4_port_retimer_write(struct tb_port *port, u8 index, u8 reg,
@@ -1254,9 +1263,6 @@ struct usb4_port *usb4_port_device_add(struct tb_port *port);
 void usb4_port_device_remove(struct usb4_port *usb4);
 int usb4_port_device_resume(struct usb4_port *usb4);
 
-/* Keep link controller awake during update */
-#define QUIRK_FORCE_POWER_LINK_CONTROLLER		BIT(0)
-
 void tb_check_quirks(struct tb_switch *sw);
 
 #ifdef CONFIG_ACPI
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index f986854aa207..cf8d4f769579 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -1561,6 +1561,20 @@ int usb4_port_retimer_set_inbound_sbtx(struct tb_port *port, u8 index)
 				    500);
 }
 
+/**
+ * usb4_port_retimer_unset_inbound_sbtx() - Disable sideband channel transactions
+ * @port: USB4 port
+ * @index: Retimer index
+ *
+ * Disables sideband channel transations on SBTX. The reverse of
+ * usb4_port_retimer_set_inbound_sbtx().
+ */
+int usb4_port_retimer_unset_inbound_sbtx(struct tb_port *port, u8 index)
+{
+	return usb4_port_retimer_op(port, index,
+				    USB4_SB_OPCODE_UNSET_INBOUND_SBTX, 500);
+}
+
 /**
  * usb4_port_retimer_read() - Read from retimer sideband registers
  * @port: USB4 port
@@ -2050,18 +2064,30 @@ static int usb4_usb3_port_write_allocated_bandwidth(struct tb_port *port,
 						    int downstream_bw)
 {
 	u32 val, ubw, dbw, scale;
-	int ret;
+	int ret, max_bw;
 
-	/* Read the used scale, hardware default is 0 */
-	ret = tb_port_read(port, &scale, TB_CFG_PORT,
-			   port->cap_adap + ADP_USB3_CS_3, 1);
+	/* Figure out suitable scale */
+	scale = 0;
+	max_bw = max(upstream_bw, downstream_bw);
+	while (scale < 64) {
+		if (mbps_to_usb3_bw(max_bw, scale) < 4096)
+			break;
+		scale++;
+	}
+
+	if (WARN_ON(scale >= 64))
+		return -EINVAL;
+
+	ret = tb_port_write(port, &scale, TB_CFG_PORT,
+			    port->cap_adap + ADP_USB3_CS_3, 1);
 	if (ret)
 		return ret;
 
-	scale &= ADP_USB3_CS_3_SCALE_MASK;
 	ubw = mbps_to_usb3_bw(upstream_bw, scale);
 	dbw = mbps_to_usb3_bw(downstream_bw, scale);
 
+	tb_port_dbg(port, "scaled bandwidth %u/%u, scale %u\n", ubw, dbw, scale);
+
 	ret = tb_port_read(port, &val, TB_CFG_PORT,
 			   port->cap_adap + ADP_USB3_CS_2, 1);
 	if (ret)
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 37809c6c027f..d9d023275328 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -43,6 +43,7 @@ struct xencons_info {
 	int irq;
 	int vtermno;
 	grant_ref_t gntref;
+	spinlock_t ring_lock;
 };
 
 static LIST_HEAD(xenconsoles);
@@ -89,12 +90,15 @@ static int __write_console(struct xencons_info *xencons,
 	XENCONS_RING_IDX cons, prod;
 	struct xencons_interface *intf = xencons->intf;
 	int sent = 0;
+	unsigned long flags;
 
+	spin_lock_irqsave(&xencons->ring_lock, flags);
 	cons = intf->out_cons;
 	prod = intf->out_prod;
 	mb();			/* update queue values before going on */
 
 	if ((prod - cons) > sizeof(intf->out)) {
+		spin_unlock_irqrestore(&xencons->ring_lock, flags);
 		pr_err_once("xencons: Illegal ring page indices");
 		return -EINVAL;
 	}
@@ -104,6 +108,7 @@ static int __write_console(struct xencons_info *xencons,
 
 	wmb();			/* write ring before updating pointer */
 	intf->out_prod = prod;
+	spin_unlock_irqrestore(&xencons->ring_lock, flags);
 
 	if (sent)
 		notify_daemon(xencons);
@@ -146,16 +151,19 @@ static int domU_read_console(uint32_t vtermno, char *buf, int len)
 	int recv = 0;
 	struct xencons_info *xencons = vtermno_to_xencons(vtermno);
 	unsigned int eoiflag = 0;
+	unsigned long flags;
 
 	if (xencons == NULL)
 		return -EINVAL;
 	intf = xencons->intf;
 
+	spin_lock_irqsave(&xencons->ring_lock, flags);
 	cons = intf->in_cons;
 	prod = intf->in_prod;
 	mb();			/* get pointers before reading ring */
 
 	if ((prod - cons) > sizeof(intf->in)) {
+		spin_unlock_irqrestore(&xencons->ring_lock, flags);
 		pr_err_once("xencons: Illegal ring page indices");
 		return -EINVAL;
 	}
@@ -179,10 +187,13 @@ static int domU_read_console(uint32_t vtermno, char *buf, int len)
 		xencons->out_cons = intf->out_cons;
 		xencons->out_cons_same = 0;
 	}
+	if (!recv && xencons->out_cons_same++ > 1) {
+		eoiflag = XEN_EOI_FLAG_SPURIOUS;
+	}
+	spin_unlock_irqrestore(&xencons->ring_lock, flags);
+
 	if (recv) {
 		notify_daemon(xencons);
-	} else if (xencons->out_cons_same++ > 1) {
-		eoiflag = XEN_EOI_FLAG_SPURIOUS;
 	}
 
 	xen_irq_lateeoi(xencons->irq, eoiflag);
@@ -239,6 +250,7 @@ static int xen_hvm_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
+		spin_lock_init(&info->ring_lock);
 	} else if (info->intf != NULL) {
 		/* already configured */
 		return 0;
@@ -275,6 +287,7 @@ static int xen_hvm_console_init(void)
 
 static int xencons_info_pv_init(struct xencons_info *info, int vtermno)
 {
+	spin_lock_init(&info->ring_lock);
 	info->evtchn = xen_start_info->console.domU.evtchn;
 	/* GFN == MFN for PV guest */
 	info->intf = gfn_to_virt(xen_start_info->console.domU.mfn);
@@ -325,6 +338,7 @@ static int xen_initial_domain_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
+		spin_lock_init(&info->ring_lock);
 	}
 
 	info->irq = bind_virq_to_irq(VIRQ_CONSOLE, 0, false);
@@ -482,6 +496,7 @@ static int xencons_probe(struct xenbus_device *dev,
 	info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
+	spin_lock_init(&info->ring_lock);
 	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->vtermno = xenbus_devid_to_vtermno(devid);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index edd34dac91b1..d89ce7fb6b36 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10074,4 +10074,5 @@ module_exit(ufshcd_core_exit);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
diff --git a/drivers/usb/cdns3/cdns3-pci-wrap.c b/drivers/usb/cdns3/cdns3-pci-wrap.c
index deeea618ba33..1f6320d98a76 100644
--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -60,6 +60,11 @@ static struct pci_dev *cdns3_get_second_fun(struct pci_dev *pdev)
 			return NULL;
 	}
 
+	if (func->devfn != PCI_DEV_FN_HOST_DEVICE &&
+	    func->devfn != PCI_DEV_FN_OTG) {
+		return NULL;
+	}
+
 	return func;
 }
 
diff --git a/drivers/usb/cdns3/cdnsp-ep0.c b/drivers/usb/cdns3/cdnsp-ep0.c
index 9b8325f82499..d63d5d92f255 100644
--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -403,20 +403,6 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
 	case USB_REQ_SET_ISOCH_DELAY:
 		ret = cdnsp_ep0_set_isoch_delay(pdev, ctrl);
 		break;
-	case USB_REQ_SET_INTERFACE:
-		/*
-		 * Add request into pending list to block sending status stage
-		 * by libcomposite.
-		 */
-		list_add_tail(&pdev->ep0_preq.list,
-			      &pdev->ep0_preq.pep->pending_list);
-
-		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
-		if (ret == -EBUSY)
-			ret = 0;
-
-		list_del(&pdev->ep0_preq.list);
-		break;
 	default:
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 		break;
@@ -474,9 +460,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 	else
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 
-	if (!len)
-		pdev->ep0_stage = CDNSP_STATUS_STAGE;
-
 	if (ret == USB_GADGET_DELAYED_STATUS) {
 		trace_cdnsp_ep0_status_stage("delayed");
 		return;
@@ -484,6 +467,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 out:
 	if (ret < 0)
 		cdnsp_ep0_stall(pdev);
-	else if (pdev->ep0_stage == CDNSP_STATUS_STAGE)
+	else if (!len && pdev->ep0_stage != CDNSP_STATUS_STAGE)
 		cdnsp_status_stage(pdev);
 }
diff --git a/drivers/usb/cdns3/cdnsp-pci.c b/drivers/usb/cdns3/cdnsp-pci.c
index fe8a114c586c..29f433c5a6f3 100644
--- a/drivers/usb/cdns3/cdnsp-pci.c
+++ b/drivers/usb/cdns3/cdnsp-pci.c
@@ -29,30 +29,23 @@
 #define PLAT_DRIVER_NAME	"cdns-usbssp"
 
 #define CDNS_VENDOR_ID		0x17cd
-#define CDNS_DEVICE_ID		0x0100
+#define CDNS_DEVICE_ID		0x0200
+#define CDNS_DRD_ID		0x0100
 #define CDNS_DRD_IF		(PCI_CLASS_SERIAL_USB << 8 | 0x80)
 
 static struct pci_dev *cdnsp_get_second_fun(struct pci_dev *pdev)
 {
-	struct pci_dev *func;
-
 	/*
 	 * Gets the second function.
-	 * It's little tricky, but this platform has two function.
-	 * The fist keeps resources for Host/Device while the second
-	 * keeps resources for DRD/OTG.
+	 * Platform has two function. The fist keeps resources for
+	 * Host/Device while the secon keeps resources for DRD/OTG.
 	 */
-	func = pci_get_device(pdev->vendor, pdev->device, NULL);
-	if (!func)
-		return NULL;
+	if (pdev->device == CDNS_DEVICE_ID)
+		return  pci_get_device(pdev->vendor, CDNS_DRD_ID, NULL);
+	else if (pdev->device == CDNS_DRD_ID)
+		return pci_get_device(pdev->vendor, CDNS_DEVICE_ID, NULL);
 
-	if (func->devfn == pdev->devfn) {
-		func = pci_get_device(pdev->vendor, pdev->device, func);
-		if (!func)
-			return NULL;
-	}
-
-	return func;
+	return NULL;
 }
 
 static int cdnsp_pci_probe(struct pci_dev *pdev,
@@ -232,6 +225,8 @@ static const struct pci_device_id cdnsp_pci_ids[] = {
 	  PCI_CLASS_SERIAL_USB_DEVICE, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_CDNS, CDNS_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  CDNS_DRD_IF, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_CDNS, CDNS_DRD_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  CDNS_DRD_IF, PCI_ANY_ID },
 	{ 0, }
 };
 
diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index a4a3be049910..85a803c135ab 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -204,6 +204,7 @@ struct hw_bank {
  * @in_lpm: if the core in low power mode
  * @wakeup_int: if wakeup interrupt occur
  * @rev: The revision number for controller
+ * @mutex: protect code from concorrent running when doing role switch
  */
 struct ci_hdrc {
 	struct device			*dev;
@@ -256,6 +257,7 @@ struct ci_hdrc {
 	bool				in_lpm;
 	bool				wakeup_int;
 	enum ci_revision		rev;
+	struct mutex                    mutex;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 6330fa911792..5abdc2b0f506 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -977,9 +977,16 @@ static ssize_t role_store(struct device *dev,
 			     strlen(ci->roles[role]->name)))
 			break;
 
-	if (role == CI_ROLE_END || role == ci->role)
+	if (role == CI_ROLE_END)
 		return -EINVAL;
 
+	mutex_lock(&ci->mutex);
+
+	if (role == ci->role) {
+		mutex_unlock(&ci->mutex);
+		return n;
+	}
+
 	pm_runtime_get_sync(dev);
 	disable_irq(ci->irq);
 	ci_role_stop(ci);
@@ -988,6 +995,7 @@ static ssize_t role_store(struct device *dev,
 		ci_handle_vbus_change(ci);
 	enable_irq(ci->irq);
 	pm_runtime_put_sync(dev);
+	mutex_unlock(&ci->mutex);
 
 	return (ret == 0) ? n : ret;
 }
@@ -1023,6 +1031,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	spin_lock_init(&ci->lock);
+	mutex_init(&ci->mutex);
 	ci->dev = dev;
 	ci->platdata = dev_get_platdata(dev);
 	ci->imx28_write_fix = !!(ci->platdata->flags &
diff --git a/drivers/usb/chipidea/otg.c b/drivers/usb/chipidea/otg.c
index 7b53274ef966..10f8cc44a16d 100644
--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -167,8 +167,10 @@ static int hw_wait_vbus_lower_bsv(struct ci_hdrc *ci)
 
 static void ci_handle_id_switch(struct ci_hdrc *ci)
 {
-	enum ci_role role = ci_otg_role(ci);
+	enum ci_role role;
 
+	mutex_lock(&ci->mutex);
+	role = ci_otg_role(ci);
 	if (role != ci->role) {
 		dev_dbg(ci->dev, "switching from %s to %s\n",
 			ci_role(ci)->name, ci->roles[role]->name);
@@ -198,6 +200,7 @@ static void ci_handle_id_switch(struct ci_hdrc *ci)
 		if (role == CI_ROLE_GADGET)
 			ci_handle_vbus_change(ci);
 	}
+	mutex_unlock(&ci->mutex);
 }
 /**
  * ci_otg_work - perform otg (vbus/id) event handle
diff --git a/drivers/usb/dwc2/drd.c b/drivers/usb/dwc2/drd.c
index d8d6493bc457..a8605b02115b 100644
--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -35,7 +35,8 @@ static void dwc2_ovr_init(struct dwc2_hsotg *hsotg)
 
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 
-	dwc2_force_mode(hsotg, (hsotg->dr_mode == USB_DR_MODE_HOST));
+	dwc2_force_mode(hsotg, (hsotg->dr_mode == USB_DR_MODE_HOST) ||
+				(hsotg->role_sw_default_mode == USB_DR_MODE_HOST));
 }
 
 static int dwc2_ovr_avalid(struct dwc2_hsotg *hsotg, bool valid)
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index ec4ace0107f5..0c02ef7628fd 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -91,13 +91,6 @@ static int dwc2_get_dr_mode(struct dwc2_hsotg *hsotg)
 	return 0;
 }
 
-static void __dwc2_disable_regulators(void *data)
-{
-	struct dwc2_hsotg *hsotg = data;
-
-	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
-}
-
 static int __dwc2_lowlevel_hw_enable(struct dwc2_hsotg *hsotg)
 {
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
@@ -108,11 +101,6 @@ static int __dwc2_lowlevel_hw_enable(struct dwc2_hsotg *hsotg)
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(&pdev->dev,
-				       __dwc2_disable_regulators, hsotg);
-	if (ret)
-		return ret;
-
 	if (hsotg->clk) {
 		ret = clk_prepare_enable(hsotg->clk);
 		if (ret)
@@ -168,7 +156,7 @@ static int __dwc2_lowlevel_hw_disable(struct dwc2_hsotg *hsotg)
 	if (hsotg->clk)
 		clk_disable_unprepare(hsotg->clk);
 
-	return 0;
+	return regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
 }
 
 /**
@@ -607,7 +595,7 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	if (hsotg->params.activate_stm_id_vb_detection)
 		regulator_disable(hsotg->usb33d);
 error:
-	if (hsotg->dr_mode != USB_DR_MODE_PERIPHERAL)
+	if (hsotg->ll_hw_enabled)
 		dwc2_lowlevel_hw_disable(hsotg);
 	return retval;
 }
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index df1ce96fa228..5997d7f943fe 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1689,6 +1689,7 @@ static int __dwc3_gadget_get_frame(struct dwc3 *dwc)
  */
 static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt)
 {
+	struct dwc3 *dwc = dep->dwc;
 	struct dwc3_gadget_ep_cmd_params params;
 	u32 cmd;
 	int ret;
@@ -1712,10 +1713,13 @@ static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool int
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
-	if (!interrupt)
+	if (!interrupt) {
+		if (!DWC3_IP_IS(DWC3) || DWC3_VER_IS_PRIOR(DWC3, 310A))
+			mdelay(1);
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	else if (!ret)
+	} else if (!ret) {
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
+	}
 
 	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	return ret;
@@ -3764,7 +3768,11 @@ void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * enabled, the EndTransfer command will have completed upon
 	 * returning from this function.
 	 *
-	 * This mode is NOT available on the DWC_usb31 IP.
+	 * This mode is NOT available on the DWC_usb31 IP.  In this
+	 * case, if the IOC bit is not set, then delay by 1ms
+	 * after issuing the EndTransfer command.  This allows for the
+	 * controller to handle the command completely before DWC3
+	 * remove requests attempts to unmap USB request buffers.
 	 */
 
 	__dwc3_stop_active_transfer(dep, force, interrupt);
diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index c1f62e91b012..4a42574b4a7f 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -1422,7 +1422,7 @@ void g_audio_cleanup(struct g_audio *g_audio)
 	uac = g_audio->uac;
 	card = uac->card;
 	if (card)
-		snd_card_free(card);
+		snd_card_free_when_closed(card);
 
 	kfree(uac->p_prm.reqs);
 	kfree(uac->c_prm.reqs);
diff --git a/drivers/usb/misc/onboard_usb_hub.c b/drivers/usb/misc/onboard_usb_hub.c
index 044e75ad4d20..832d3ba9368f 100644
--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -406,6 +406,7 @@ static void onboard_hub_usbdev_disconnect(struct usb_device *udev)
 
 static const struct usb_device_id onboard_hub_id_table[] = {
 	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2514) }, /* USB2514B USB 2.0 */
+	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2517) }, /* USB2517 USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x0411) }, /* RTS5411 USB 3.1 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x5411) }, /* RTS5411 USB 2.1 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x0414) }, /* RTS5414 USB 3.2 */
diff --git a/drivers/usb/misc/onboard_usb_hub.h b/drivers/usb/misc/onboard_usb_hub.h
index 34beab8bce3d..2cde54b69eed 100644
--- a/drivers/usb/misc/onboard_usb_hub.h
+++ b/drivers/usb/misc/onboard_usb_hub.h
@@ -24,6 +24,7 @@ static const struct onboard_hub_pdata ti_tusb8041_data = {
 
 static const struct of_device_id onboard_hub_match[] = {
 	{ .compatible = "usb424,2514", .data = &microchip_usb424_data, },
+	{ .compatible = "usb424,2517", .data = &microchip_usb424_data, },
 	{ .compatible = "usb451,8140", .data = &ti_tusb8041_data, },
 	{ .compatible = "usb451,8142", .data = &ti_tusb8041_data, },
 	{ .compatible = "usbbda,411", .data = &realtek_rts5411_data, },
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index c7b763d6d102..1f8c9b16a0fb 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -111,6 +111,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BROKEN_FUA),
 
+/* Reported by: Yaroslav Furman <yaro330@gmail.com> */
+UNUSUAL_DEV(0x152d, 0x0583, 0x0000, 0x9999,
+		"JMicron",
+		"JMS583Gen 2",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
 UNUSUAL_DEV(0x154b, 0xf00b, 0x0000, 0x9999,
 		"PNY",
diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 59b366b5c614..032d21a96779 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1436,10 +1436,18 @@ static int tcpm_ams_start(struct tcpm_port *port, enum tcpm_ams ams)
 static void tcpm_queue_vdm(struct tcpm_port *port, const u32 header,
 			   const u32 *data, int cnt)
 {
+	u32 vdo_hdr = port->vdo_data[0];
+
 	WARN_ON(!mutex_is_locked(&port->lock));
 
-	/* Make sure we are not still processing a previous VDM packet */
-	WARN_ON(port->vdm_state > VDM_STATE_DONE);
+	/* If is sending discover_identity, handle received message first */
+	if (PD_VDO_SVDM(vdo_hdr) && PD_VDO_CMD(vdo_hdr) == CMD_DISCOVER_IDENT) {
+		port->send_discover = true;
+		mod_send_discover_delayed_work(port, SEND_DISCOVER_RETRY_MS);
+	} else {
+		/* Make sure we are not still processing a previous VDM packet */
+		WARN_ON(port->vdm_state > VDM_STATE_DONE);
+	}
 
 	port->vdo_count = cnt + 1;
 	port->vdo_data[0] = header;
@@ -1942,11 +1950,13 @@ static void vdm_run_state_machine(struct tcpm_port *port)
 			switch (PD_VDO_CMD(vdo_hdr)) {
 			case CMD_DISCOVER_IDENT:
 				res = tcpm_ams_start(port, DISCOVER_IDENTITY);
-				if (res == 0)
+				if (res == 0) {
 					port->send_discover = false;
-				else if (res == -EAGAIN)
+				} else if (res == -EAGAIN) {
+					port->vdo_data[0] = 0;
 					mod_send_discover_delayed_work(port,
 								       SEND_DISCOVER_RETRY_MS);
+				}
 				break;
 			case CMD_DISCOVER_SVID:
 				res = tcpm_ams_start(port, DISCOVER_SVIDS);
@@ -2029,6 +2039,7 @@ static void vdm_run_state_machine(struct tcpm_port *port)
 			unsigned long timeout;
 
 			port->vdm_retries = 0;
+			port->vdo_data[0] = 0;
 			port->vdm_state = VDM_STATE_BUSY;
 			timeout = vdm_ready_timeout(vdo_hdr);
 			mod_vdm_delayed_work(port, timeout);
@@ -4547,6 +4558,9 @@ static void run_state_machine(struct tcpm_port *port)
 	case SOFT_RESET:
 		port->message_id = 0;
 		port->rx_msgid = -1;
+		/* remove existing capabilities */
+		usb_power_delivery_unregister_capabilities(port->partner_source_caps);
+		port->partner_source_caps = NULL;
 		tcpm_pd_send_control(port, PD_CTRL_ACCEPT);
 		tcpm_ams_finish(port);
 		if (port->pwr_role == TYPEC_SOURCE) {
@@ -4566,6 +4580,9 @@ static void run_state_machine(struct tcpm_port *port)
 	case SOFT_RESET_SEND:
 		port->message_id = 0;
 		port->rx_msgid = -1;
+		/* remove existing capabilities */
+		usb_power_delivery_unregister_capabilities(port->partner_source_caps);
+		port->partner_source_caps = NULL;
 		if (tcpm_pd_send_control(port, PD_CTRL_SOFT_RESET))
 			tcpm_set_state_cond(port, hard_reset_state(port), 0);
 		else
@@ -4695,6 +4712,9 @@ static void run_state_machine(struct tcpm_port *port)
 		tcpm_set_state(port, SNK_STARTUP, 0);
 		break;
 	case PR_SWAP_SNK_SRC_SINK_OFF:
+		/* will be source, remove existing capabilities */
+		usb_power_delivery_unregister_capabilities(port->partner_source_caps);
+		port->partner_source_caps = NULL;
 		/*
 		 * Prevent vbus discharge circuit from turning on during PR_SWAP
 		 * as this is not a disconnect.
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 1cf8947c6d66..8cbbb002fefe 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1205,7 +1205,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con;
-	u64 command;
+	u64 command, ntfy;
 	int ret;
 	int i;
 
@@ -1217,8 +1217,8 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable basic notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_reset;
@@ -1250,12 +1250,13 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable all notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_ALL;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_ALL;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_unregister;
 
+	ucsi->ntfy = ntfy;
 	return 0;
 
 err_unregister:
diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index ce0c8ef80c04..62206a6b8ea7 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -78,7 +78,7 @@ static int ucsi_acpi_sync_write(struct ucsi *ucsi, unsigned int offset,
 	if (ret)
 		goto out_clear_bit;
 
-	if (!wait_for_completion_timeout(&ua->complete, HZ))
+	if (!wait_for_completion_timeout(&ua->complete, 5 * HZ))
 		ret = -ETIMEDOUT;
 
 out_clear_bit:
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 056f002263db..1b72004136ef 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2099,11 +2099,21 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 		if (!device->bdev)
 			continue;
 
-		if (!zinfo->max_active_zones ||
-		    atomic_read(&zinfo->active_zones_left)) {
+		if (!zinfo->max_active_zones) {
 			ret = true;
 			break;
 		}
+
+		switch (flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+		case 0: /* single */
+			ret = (atomic_read(&zinfo->active_zones_left) >= 1);
+			break;
+		case BTRFS_BLOCK_GROUP_DUP:
+			ret = (atomic_read(&zinfo->active_zones_left) >= 2);
+			break;
+		}
+		if (ret)
+			break;
 	}
 	mutex_unlock(&fs_info->chunk_mutex);
 
diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 75d5e06306ea..bfc964b36c72 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -99,6 +99,23 @@ path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
 	return dentry;
 }
 
+static const char *path_no_prefix(struct cifs_sb_info *cifs_sb,
+				  const char *path)
+{
+	size_t len = 0;
+
+	if (!*path)
+		return path;
+
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+	    cifs_sb->prepath) {
+		len = strlen(cifs_sb->prepath) + 1;
+		if (unlikely(len > strlen(path)))
+			return ERR_PTR(-EINVAL);
+	}
+	return path + len;
+}
+
 /*
  * Open the and cache a directory handle.
  * If error then *cfid is not initialized.
@@ -125,6 +142,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	struct dentry *dentry = NULL;
 	struct cached_fid *cfid;
 	struct cached_fids *cfids;
+	const char *npath;
 
 	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
 	    is_smb1_server(tcon->ses->server))
@@ -160,6 +178,20 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		return 0;
 	}
 
+	/*
+	 * Skip any prefix paths in @path as lookup_positive_unlocked() ends up
+	 * calling ->lookup() which already adds those through
+	 * build_path_from_dentry().  Also, do it earlier as we might reconnect
+	 * below when trying to send compounded request and then potentially
+	 * having a different prefix path (e.g. after DFS failover).
+	 */
+	npath = path_no_prefix(cifs_sb, path);
+	if (IS_ERR(npath)) {
+		rc = PTR_ERR(npath);
+		kfree(utf16_path);
+		return rc;
+	}
+
 	/*
 	 * We do not hold the lock for the open because in case
 	 * SMB2_open needs to reconnect.
@@ -184,6 +216,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
@@ -251,10 +284,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
 
-	if (!path[0])
+	if (!npath[0])
 		dentry = dget(cifs_sb->root);
 	else {
-		dentry = path_to_dentry(cifs_sb, path);
+		dentry = path_to_dentry(cifs_sb, npath);
 		if (IS_ERR(dentry)) {
 			rc = -ENOENT;
 			goto oshr_free;
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 90850da390ae..4952a94e5272 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -175,7 +175,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 
 	seq_puts(m, "# Version:1\n");
 	seq_puts(m, "# Format:\n");
-	seq_puts(m, "# <tree id> <persistent fid> <flags> <count> <pid> <uid>");
+	seq_puts(m, "# <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>");
 #ifdef CONFIG_CIFS_DEBUG2
 	seq_printf(m, " <filename> <mid>\n");
 #else
@@ -188,8 +188,9 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 				spin_lock(&tcon->open_file_lock);
 				list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 					seq_printf(m,
-						"0x%x 0x%llx 0x%x %d %d %d %pd",
+						"0x%x 0x%llx 0x%llx 0x%x %d %d %d %pd",
 						tcon->tid,
+						ses->Suid,
 						cfile->fid.persistent_fid,
 						cfile->f_flags,
 						cfile->count,
@@ -215,6 +216,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
 	struct mid_q_entry *mid_entry;
 	struct TCP_Server_Info *server;
+	struct TCP_Server_Info *chan_server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifs_server_iface *iface;
@@ -458,23 +460,35 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 					seq_puts(m, "\t\t[CONNECTED]\n");
 			}
 			spin_unlock(&ses->iface_lock);
+
+			seq_puts(m, "\n\n\tMIDs: ");
+			spin_lock(&ses->chan_lock);
+			for (j = 0; j < ses->chan_count; j++) {
+				chan_server = ses->chans[j].server;
+				if (!chan_server)
+					continue;
+
+				if (list_empty(&chan_server->pending_mid_q))
+					continue;
+
+				seq_printf(m, "\n\tServer ConnectionId: 0x%llx",
+					   chan_server->conn_id);
+				spin_lock(&chan_server->mid_lock);
+				list_for_each_entry(mid_entry, &chan_server->pending_mid_q, qhead) {
+					seq_printf(m, "\n\t\tState: %d com: %d pid: %d cbdata: %p mid %llu",
+						   mid_entry->mid_state,
+						   le16_to_cpu(mid_entry->command),
+						   mid_entry->pid,
+						   mid_entry->callback_data,
+						   mid_entry->mid);
+				}
+				spin_unlock(&chan_server->mid_lock);
+			}
+			spin_unlock(&ses->chan_lock);
+			seq_puts(m, "\n--\n");
 		}
 		if (i == 0)
 			seq_printf(m, "\n\t\t[NONE]");
-
-		seq_puts(m, "\n\n\tMIDs: ");
-		spin_lock(&server->mid_lock);
-		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
-			seq_printf(m, "\n\tState: %d com: %d pid:"
-					" %d cbdata: %p mid %llu\n",
-					mid_entry->mid_state,
-					le16_to_cpu(mid_entry->command),
-					mid_entry->pid,
-					mid_entry->callback_data,
-					mid_entry->mid);
-		}
-		spin_unlock(&server->mid_lock);
-		seq_printf(m, "\n--\n");
 	}
 	if (c == 0)
 		seq_printf(m, "\n\t[NONE]");
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6094cb2ff099..03e3e95cf25b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -730,13 +730,16 @@ static void cifs_umount_begin(struct super_block *sb)
 	spin_lock(&tcon->tc_lock);
 	if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
 		/* we have other mounts to same share or we have
-		   already tried to force umount this and woken up
+		   already tried to umount this and woken up
 		   all waiting network requests, nothing to do */
 		spin_unlock(&tcon->tc_lock);
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
-	} else if (tcon->tc_count == 1)
-		tcon->status = TID_EXITING;
+	}
+	/*
+	 * can not set tcon->status to TID_EXITING yet since we don't know if umount -f will
+	 * fail later (e.g. due to open files).  TID_EXITING will be set just before tdis req sent
+	 */
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6b8f59912f70..6c6a7fc47f3e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -85,13 +85,11 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 
 	/*
 	 * only tree disconnect, open, and write, (and ulogoff which does not
-	 * have tcon) are allowed as we start force umount
+	 * have tcon) are allowed as we start umount
 	 */
 	spin_lock(&tcon->tc_lock);
 	if (tcon->status == TID_EXITING) {
-		if (smb_command != SMB_COM_WRITE_ANDX &&
-		    smb_command != SMB_COM_OPEN_ANDX &&
-		    smb_command != SMB_COM_TREE_DISCONNECT) {
+		if (smb_command != SMB_COM_TREE_DISCONNECT) {
 			spin_unlock(&tcon->tc_lock);
 			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
 				 smb_command);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0006b1ca0203..7aecb1646b6f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1774,7 +1774,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	return ERR_PTR(rc);
 }
 
-/* this function must be called with ses_lock held */
+/* this function must be called with ses_lock and chan_lock held */
 static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
 	if (ctx->sectype != Unspecified &&
@@ -1785,12 +1785,8 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	 * If an existing session is limited to less channels than
 	 * requested, it should not be reused
 	 */
-	spin_lock(&ses->chan_lock);
-	if (ses->chan_max < ctx->max_channels) {
-		spin_unlock(&ses->chan_lock);
+	if (ses->chan_max < ctx->max_channels)
 		return 0;
-	}
-	spin_unlock(&ses->chan_lock);
 
 	switch (ses->sectype) {
 	case Kerberos:
@@ -1918,10 +1914,13 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 			spin_unlock(&ses->ses_lock);
 			continue;
 		}
+		spin_lock(&ses->chan_lock);
 		if (!match_session(ses, ctx)) {
+			spin_unlock(&ses->chan_lock);
 			spin_unlock(&ses->ses_lock);
 			continue;
 		}
+		spin_unlock(&ses->chan_lock);
 		spin_unlock(&ses->ses_lock);
 
 		++ses->ses_count;
@@ -2365,6 +2364,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	WARN_ON(tcon->tc_count < 0);
 
 	list_del_init(&tcon->tcon_list);
+	tcon->status = TID_EXITING;
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -2741,6 +2741,7 @@ cifs_match_super(struct super_block *sb, void *data)
 
 	spin_lock(&tcp_srv->srv_lock);
 	spin_lock(&ses->ses_lock);
+	spin_lock(&ses->chan_lock);
 	spin_lock(&tcon->tc_lock);
 	if (!match_server(tcp_srv, ctx) ||
 	    !match_session(ses, ctx) ||
@@ -2753,6 +2754,7 @@ cifs_match_super(struct super_block *sb, void *data)
 	rc = compare_mount_options(sb, mnt_data);
 out:
 	spin_unlock(&tcon->tc_lock);
+	spin_unlock(&ses->chan_lock);
 	spin_unlock(&ses->ses_lock);
 	spin_unlock(&tcp_srv->srv_lock);
 
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index bbaee4c2281f..a268896d05d5 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -286,5 +286,5 @@ extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
  * max deferred close timeout (jiffies) - 2^30
  */
 #define SMB3_MAX_DCLOSETIMEO (1 << 30)
-#define SMB3_DEF_DCLOSETIMEO (5 * HZ) /* Can increase later, other clients use larger */
+#define SMB3_DEF_DCLOSETIMEO (1 * HZ) /* even 1 sec enough to help eg open/write/close/open/read */
 #endif
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index d937eedd74fb..c0f101fc1e5d 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -360,6 +360,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
+		.path = path,
 		.desired_access = GENERIC_READ,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
 		.disposition = FILE_OPEN,
@@ -427,6 +428,7 @@ smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
+		.path = path,
 		.desired_access = GENERIC_WRITE,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
 		.disposition = FILE_CREATE,
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 7a2862c10afb..c97e049e29dd 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -106,6 +106,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 
 	vars->oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = full_path,
 		.desired_access = desired_access,
 		.disposition = create_disposition,
 		.create_options = cifs_create_options(cifs_sb, create_options),
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0424876d22e5..ccf311750927 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -530,6 +530,14 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
+	/* do not query too frequently, this time with lock held */
+	if (ses->iface_last_update &&
+	    time_before(jiffies, ses->iface_last_update +
+			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
+		spin_unlock(&ses->iface_lock);
+		return 0;
+	}
+
 	/*
 	 * Go through iface_list and do kref_put to remove
 	 * any unused ifaces. ifaces in use will be removed
@@ -696,6 +704,12 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	struct network_interface_info_ioctl_rsp *out_buf = NULL;
 	struct cifs_ses *ses = tcon->ses;
 
+	/* do not query too frequently */
+	if (ses->iface_last_update &&
+	    time_before(jiffies, ses->iface_last_update +
+			(SMB_INTERFACE_POLL_INTERVAL * HZ)))
+		return 0;
+
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
 			NULL /* no data input */, 0 /* no data input */,
@@ -703,7 +717,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	if (rc == -EOPNOTSUPP) {
 		cifs_dbg(FYI,
 			 "server does not support query network interfaces\n");
-		goto out;
+		ret_data_len = 0;
 	} else if (rc != 0) {
 		cifs_tcon_dbg(VFS, "error %d on ioctl to get interface list\n", rc);
 		goto out;
@@ -731,6 +745,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = "",
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -774,6 +789,7 @@ smb2_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = "",
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -821,6 +837,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = full_path,
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -1105,6 +1122,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = FILE_WRITE_EA,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2096,6 +2114,7 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 	tcon = cifs_sb_master_tcon(cifs_sb);
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2168,6 +2187,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2500,6 +2520,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = desired_access,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2634,6 +2655,7 @@ smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = "",
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2928,6 +2950,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = full_path,
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, create_options),
@@ -3068,6 +3091,7 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = full_path,
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, OPEN_REPARSE_POINT),
@@ -3208,6 +3232,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = READ_CONTROL,
 		.disposition = FILE_OPEN,
 		/*
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 23926f754d2a..6e6e44d8b4c7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -225,13 +225,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_lock(&tcon->tc_lock);
 	if (tcon->status == TID_EXITING) {
 		/*
-		 * only tree disconnect, open, and write,
-		 * (and ulogoff which does not have tcon)
-		 * are allowed as we start force umount.
+		 * only tree disconnect allowed when disconnecting ...
 		 */
-		if ((smb2_command != SMB2_WRITE) &&
-		   (smb2_command != SMB2_CREATE) &&
-		   (smb2_command != SMB2_TREE_DISCONNECT)) {
+		if (smb2_command != SMB2_TREE_DISCONNECT) {
 			spin_unlock(&tcon->tc_lock);
 			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
 				 smb2_command);
@@ -2746,7 +2742,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	rqst.rq_nvec = n_iov;
 
 	/* no need to inc num_remote_opens because we close it just below */
-	trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, CREATE_NOT_FILE,
+	trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, full_path, CREATE_NOT_FILE,
 				    FILE_WRITE_ATTRIBUTES);
 	/* resource #4: response buffer */
 	rc = cifs_send_recv(xid, ses, server,
@@ -3014,7 +3010,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	if (rc)
 		goto creat_exit;
 
-	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid,
+	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->path,
 		oparms->create_options, oparms->desired_access);
 
 	rc = cifs_send_recv(xid, ses, server,
diff --git a/fs/cifs/trace.h b/fs/cifs/trace.h
index 110070ba8b04..d3053bd8ae73 100644
--- a/fs/cifs/trace.h
+++ b/fs/cifs/trace.h
@@ -701,13 +701,15 @@ DECLARE_EVENT_CLASS(smb3_open_enter_class,
 	TP_PROTO(unsigned int xid,
 		__u32	tid,
 		__u64	sesid,
+		const char *full_path,
 		int	create_options,
 		int	desired_access),
-	TP_ARGS(xid, tid, sesid, create_options, desired_access),
+	TP_ARGS(xid, tid, sesid, full_path, create_options, desired_access),
 	TP_STRUCT__entry(
 		__field(unsigned int, xid)
 		__field(__u32, tid)
 		__field(__u64, sesid)
+		__string(path, full_path)
 		__field(int, create_options)
 		__field(int, desired_access)
 	),
@@ -715,11 +717,12 @@ DECLARE_EVENT_CLASS(smb3_open_enter_class,
 		__entry->xid = xid;
 		__entry->tid = tid;
 		__entry->sesid = sesid;
+		__assign_str(path, full_path);
 		__entry->create_options = create_options;
 		__entry->desired_access = desired_access;
 	),
-	TP_printk("xid=%u sid=0x%llx tid=0x%x cr_opts=0x%x des_access=0x%x",
-		__entry->xid, __entry->sesid, __entry->tid,
+	TP_printk("xid=%u sid=0x%llx tid=0x%x path=%s cr_opts=0x%x des_access=0x%x",
+		__entry->xid, __entry->sesid, __entry->tid, __get_str(path),
 		__entry->create_options, __entry->desired_access)
 )
 
@@ -728,9 +731,10 @@ DEFINE_EVENT(smb3_open_enter_class, smb3_##name,  \
 	TP_PROTO(unsigned int xid,		\
 		__u32	tid,			\
 		__u64	sesid,			\
+		const char *full_path,		\
 		int	create_options,		\
 		int	desired_access),	\
-	TP_ARGS(xid, tid, sesid, create_options, desired_access))
+	TP_ARGS(xid, tid, sesid, full_path, create_options, desired_access))
 
 DEFINE_SMB3_OPEN_ENTER_EVENT(open_enter);
 DEFINE_SMB3_OPEN_ENTER_EVENT(posix_mkdir_enter);
diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 6e61b5bc7d86..cead696b656a 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -727,8 +727,9 @@ static int generate_key(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		goto smb3signkey_ret;
 	}
 
-	if (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
-	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+	if (key_size == SMB3_ENC_DEC_KEY_SIZE &&
+	    (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+	     conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L256, 4);
 	else
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L128, 4);
diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 56be077e5d8a..2be9d7460494 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -298,7 +298,7 @@ int ksmbd_conn_handler_loop(void *p)
 		kvfree(conn->request_buf);
 		conn->request_buf = NULL;
 
-		size = t->ops->read(t, hdr_buf, sizeof(hdr_buf));
+		size = t->ops->read(t, hdr_buf, sizeof(hdr_buf), -1);
 		if (size != sizeof(hdr_buf))
 			break;
 
@@ -319,13 +319,10 @@ int ksmbd_conn_handler_loop(void *p)
 		}
 
 		/*
-		 * Check if pdu size is valid (min : smb header size,
-		 * max : 0x00FFFFFF).
+		 * Check maximum pdu size(0x00FFFFFF).
 		 */
-		if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
-		    pdu_size > MAX_STREAM_PROT_LEN) {
+		if (pdu_size > MAX_STREAM_PROT_LEN)
 			break;
-		}
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
@@ -344,7 +341,7 @@ int ksmbd_conn_handler_loop(void *p)
 		 * We already read 4 bytes to find out PDU size, now
 		 * read in PDU
 		 */
-		size = t->ops->read(t, conn->request_buf + 4, pdu_size);
+		size = t->ops->read(t, conn->request_buf + 4, pdu_size, 2);
 		if (size < 0) {
 			pr_err("sock_read failed: %d\n", size);
 			break;
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 3643354a3fa7..0e3a848defaf 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -114,7 +114,8 @@ struct ksmbd_transport_ops {
 	int (*prepare)(struct ksmbd_transport *t);
 	void (*disconnect)(struct ksmbd_transport *t);
 	void (*shutdown)(struct ksmbd_transport *t);
-	int (*read)(struct ksmbd_transport *t, char *buf, unsigned int size);
+	int (*read)(struct ksmbd_transport *t, char *buf,
+		    unsigned int size, int max_retries);
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
 		      int size, bool need_invalidate_rkey,
 		      unsigned int remote_key);
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 0f0f1243a9cb..daaee7a89e05 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2994,8 +2994,11 @@ int smb2_open(struct ksmbd_work *work)
 							sizeof(struct smb_acl) +
 							sizeof(struct smb_ace) * ace_num * 2,
 							GFP_KERNEL);
-					if (!pntsd)
+					if (!pntsd) {
+						posix_acl_release(fattr.cf_acls);
+						posix_acl_release(fattr.cf_dacls);
 						goto err_out;
+					}
 
 					rc = build_sec_desc(user_ns,
 							    pntsd, NULL, 0,
@@ -4951,6 +4954,10 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 		info->Attributes |= cpu_to_le32(server_conf.share_fake_fscaps);
 
+		if (test_share_config_flag(work->tcon->share_conf,
+		    KSMBD_SHARE_FLAG_STREAMS))
+			info->Attributes |= cpu_to_le32(FILE_NAMED_STREAMS);
+
 		info->MaxPathNameComponentLength = cpu_to_le32(stfs.f_namelen);
 		len = smbConvertToUTF16((__le16 *)info->FileSystemName,
 					"NTFS", PATH_MAX, conn->local_nls, 0);
@@ -7457,13 +7464,16 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	if (in_count == 0)
 		return -EINVAL;
 
+	start = le64_to_cpu(qar_req->file_offset);
+	length = le64_to_cpu(qar_req->length);
+
+	if (start < 0 || length < 0)
+		return -EINVAL;
+
 	fp = ksmbd_lookup_fd_fast(work, id);
 	if (!fp)
 		return -ENOENT;
 
-	start = le64_to_cpu(qar_req->file_offset);
-	length = le64_to_cpu(qar_req->length);
-
 	ret = ksmbd_vfs_fqar_lseek(fp, start, length,
 				   qar_rsp, in_count, out_count);
 	if (ret && ret != -E2BIG)
@@ -7764,7 +7774,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 
 		off = le64_to_cpu(zero_data->FileOffset);
 		bfz = le64_to_cpu(zero_data->BeyondFinalZero);
-		if (off > bfz) {
+		if (off < 0 || bfz < 0 || off > bfz) {
 			ret = -EINVAL;
 			goto out;
 		}
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index d96da872d70a..3d9e8d8a5762 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -434,7 +434,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 
 static int __smb2_negotiate(struct ksmbd_conn *conn)
 {
-	return (conn->dialect >= SMB21_PROT_ID &&
+	return (conn->dialect >= SMB20_PROT_ID &&
 		conn->dialect <= SMB311_PROT_ID);
 }
 
@@ -442,9 +442,26 @@ static int smb_handle_negotiate(struct ksmbd_work *work)
 {
 	struct smb_negotiate_rsp *neg_rsp = work->response_buf;
 
-	ksmbd_debug(SMB, "Unsupported SMB protocol\n");
-	neg_rsp->hdr.Status.CifsError = STATUS_INVALID_LOGON_TYPE;
-	return -EINVAL;
+	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
+
+	/*
+	 * Remove 4 byte direct TCP header, add 2 byte bcc and
+	 * 2 byte DialectIndex.
+	 */
+	*(__be32 *)work->response_buf =
+		cpu_to_be32(sizeof(struct smb_hdr) - 4 + 2 + 2);
+	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;
+
+	neg_rsp->hdr.Command = SMB_COM_NEGOTIATE;
+	*(__le32 *)neg_rsp->hdr.Protocol = SMB1_PROTO_NUMBER;
+	neg_rsp->hdr.Flags = SMBFLG_RESPONSE;
+	neg_rsp->hdr.Flags2 = SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS |
+		SMBFLG2_EXT_SEC | SMBFLG2_IS_LONG_NAME;
+
+	neg_rsp->hdr.WordCount = 1;
+	neg_rsp->DialectIndex = cpu_to_le16(work->conn->dialect);
+	neg_rsp->ByteCount = 0;
+	return 0;
 }
 
 int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
@@ -465,7 +482,7 @@ int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
 		}
 	}
 
-	if (command == SMB2_NEGOTIATE_HE && __smb2_negotiate(conn)) {
+	if (command == SMB2_NEGOTIATE_HE) {
 		ret = smb2_handle_negotiate(work);
 		init_smb2_neg_rsp(work);
 		return ret;
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index 318c16fa81da..c1f3006792ff 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -158,8 +158,15 @@
 
 #define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
 #define SMB_COM_NEGOTIATE		0x72
-
 #define SMB1_CLIENT_GUID_SIZE		(16)
+
+#define SMBFLG_RESPONSE 0x80	/* this PDU is a response from server */
+
+#define SMBFLG2_IS_LONG_NAME	cpu_to_le16(0x40)
+#define SMBFLG2_EXT_SEC		cpu_to_le16(0x800)
+#define SMBFLG2_ERR_STATUS	cpu_to_le16(0x4000)
+#define SMBFLG2_UNICODE		cpu_to_le16(0x8000)
+
 struct smb_hdr {
 	__be32 smb_buf_length;
 	__u8 Protocol[4];
@@ -199,28 +206,7 @@ struct smb_negotiate_req {
 struct smb_negotiate_rsp {
 	struct smb_hdr hdr;     /* wct = 17 */
 	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
-	__u8 SecurityMode;
-	__le16 MaxMpxCount;
-	__le16 MaxNumberVcs;
-	__le32 MaxBufferSize;
-	__le32 MaxRawSize;
-	__le32 SessionKey;
-	__le32 Capabilities;    /* see below */
-	__le32 SystemTimeLow;
-	__le32 SystemTimeHigh;
-	__le16 ServerTimeZone;
-	__u8 EncryptionKeyLength;
 	__le16 ByteCount;
-	union {
-		unsigned char EncryptionKey[8]; /* cap extended security off */
-		/* followed by Domain name - if extended security is off */
-		/* followed by 16 bytes of server GUID */
-		/* then security blob if cap_extended_security negotiated */
-		struct {
-			unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
-			unsigned char SecurityBlob[1];
-		} __packed extended_response;
-	} __packed u;
 } __packed;
 
 struct filesystem_attribute_info {
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 096eda9ef873..c06efc020bd9 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -670,7 +670,7 @@ static int smb_direct_post_recv(struct smb_direct_transport *t,
 }
 
 static int smb_direct_read(struct ksmbd_transport *t, char *buf,
-			   unsigned int size)
+			   unsigned int size, int unused)
 {
 	struct smb_direct_recvmsg *recvmsg;
 	struct smb_direct_data_transfer *data_transfer;
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 603893fd87f5..20e85e2701f2 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -291,16 +291,18 @@ static int ksmbd_tcp_run_kthread(struct interface *iface)
 
 /**
  * ksmbd_tcp_readv() - read data from socket in given iovec
- * @t:		TCP transport instance
- * @iov_orig:	base IO vector
- * @nr_segs:	number of segments in base iov
- * @to_read:	number of bytes to read from socket
+ * @t:			TCP transport instance
+ * @iov_orig:		base IO vector
+ * @nr_segs:		number of segments in base iov
+ * @to_read:		number of bytes to read from socket
+ * @max_retries:	maximum retry count
  *
  * Return:	on success return number of bytes read from socket,
  *		otherwise return error number
  */
 static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
-			   unsigned int nr_segs, unsigned int to_read)
+			   unsigned int nr_segs, unsigned int to_read,
+			   int max_retries)
 {
 	int length = 0;
 	int total_read;
@@ -308,7 +310,6 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
 	struct msghdr ksmbd_msg;
 	struct kvec *iov;
 	struct ksmbd_conn *conn = KSMBD_TRANS(t)->conn;
-	int max_retry = 2;
 
 	iov = get_conn_iovec(t, nr_segs);
 	if (!iov)
@@ -335,14 +336,23 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
 		} else if (conn->status == KSMBD_SESS_NEED_RECONNECT) {
 			total_read = -EAGAIN;
 			break;
-		} else if ((length == -ERESTARTSYS || length == -EAGAIN) &&
-			   max_retry) {
+		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
+			/*
+			 * If max_retries is negative, Allow unlimited
+			 * retries to keep connection with inactive sessions.
+			 */
+			if (max_retries == 0) {
+				total_read = length;
+				break;
+			} else if (max_retries > 0) {
+				max_retries--;
+			}
+
 			usleep_range(1000, 2000);
 			length = 0;
-			max_retry--;
 			continue;
 		} else if (length <= 0) {
-			total_read = -EAGAIN;
+			total_read = length;
 			break;
 		}
 	}
@@ -358,14 +368,15 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
  * Return:	on success return number of bytes read from socket,
  *		otherwise return error number
  */
-static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf, unsigned int to_read)
+static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf,
+			  unsigned int to_read, int max_retries)
 {
 	struct kvec iov;
 
 	iov.iov_base = buf;
 	iov.iov_len = to_read;
 
-	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read);
+	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read, max_retries);
 }
 
 static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *iov,
diff --git a/fs/lockd/clnt4xdr.c b/fs/lockd/clnt4xdr.c
index 7df6324ccb8a..8161667c976f 100644
--- a/fs/lockd/clnt4xdr.c
+++ b/fs/lockd/clnt4xdr.c
@@ -261,7 +261,6 @@ static int decode_nlm4_holder(struct xdr_stream *xdr, struct nlm_res *result)
 	u32 exclusive;
 	int error;
 	__be32 *p;
-	s32 end;
 
 	memset(lock, 0, sizeof(*lock));
 	locks_init_lock(fl);
@@ -285,13 +284,7 @@ static int decode_nlm4_holder(struct xdr_stream *xdr, struct nlm_res *result)
 	fl->fl_type  = exclusive != 0 ? F_WRLCK : F_RDLCK;
 	p = xdr_decode_hyper(p, &l_offset);
 	xdr_decode_hyper(p, &l_len);
-	end = l_offset + l_len - 1;
-
-	fl->fl_start = (loff_t)l_offset;
-	if (l_len == 0 || end < 0)
-		fl->fl_end = OFFSET_MAX;
-	else
-		fl->fl_end = (loff_t)end;
+	nlm4svc_set_file_lock_range(fl, l_offset, l_len);
 	error = 0;
 out:
 	return error;
diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 712fdfeb8ef0..5fcbf30cd275 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -33,6 +33,17 @@ loff_t_to_s64(loff_t offset)
 	return res;
 }
 
+void nlm4svc_set_file_lock_range(struct file_lock *fl, u64 off, u64 len)
+{
+	s64 end = off + len - 1;
+
+	fl->fl_start = off;
+	if (len == 0 || end < 0)
+		fl->fl_end = OFFSET_MAX;
+	else
+		fl->fl_end = end;
+}
+
 /*
  * NLM file handles are defined by specification to be a variable-length
  * XDR opaque no longer than 1024 bytes. However, this implementation
@@ -80,7 +91,7 @@ svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 	locks_init_lock(fl);
 	fl->fl_flags = FL_POSIX;
 	fl->fl_type  = F_RDLCK;
-
+	nlm4svc_set_file_lock_range(fl, lock->lock_start, lock->lock_len);
 	return true;
 }
 
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 8ae2c8d1219d..cd970ce62786 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -15,6 +15,7 @@
 #include <linux/stat.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/pagemap.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs_fs.h>
@@ -338,6 +339,7 @@ int nfs_read_folio(struct file *file, struct folio *folio)
 
 	trace_nfs_aop_readpage(inode, page);
 	nfs_inc_stats(inode, NFSIOS_VFSREADPAGE);
+	task_io_account_read(folio_size(folio));
 
 	/*
 	 * Try to flush any pending writes to the file..
@@ -400,6 +402,7 @@ void nfs_readahead(struct readahead_control *ractl)
 
 	trace_nfs_aop_readahead(inode, readahead_pos(ractl), nr_pages);
 	nfs_inc_stats(inode, NFSIOS_VFSREADPAGES);
+	task_io_account_read(readahead_length(ractl));
 
 	ret = -ESTALE;
 	if (NFS_STALE(inode))
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 59f9a8cee012..dc3ba13546dd 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -874,8 +874,15 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct page *last_page;
 
 	last_page = page + (offset + sd->len - 1) / PAGE_SIZE;
-	for (page += offset / PAGE_SIZE; page <= last_page; page++)
+	for (page += offset / PAGE_SIZE; page <= last_page; page++) {
+		/*
+		 * Skip page replacement when extending the contents
+		 * of the current page.
+		 */
+		if (page == *(rqstp->rq_next_page - 1))
+			continue;
 		svc_rqst_replace_page(rqstp, page);
+	}
 	if (rqstp->rq_res.page_len == 0)	// first call
 		rqstp->rq_res.page_base = offset % PAGE_SIZE;
 	rqstp->rq_res.page_len += sd->len;
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b4041d0566a9..ef9f9a2511b7 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -71,7 +71,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
 		return -EINVAL;
 
-	buf = (void *)__get_free_pages(GFP_NOFS, 0);
+	buf = (void *)get_zeroed_page(GFP_NOFS);
 	if (unlikely(!buf))
 		return -ENOMEM;
 	maxmembs = PAGE_SIZE / argv->v_size;
diff --git a/fs/super.c b/fs/super.c
index 4f8a626a35cd..7c140ee60c54 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -476,13 +476,22 @@ void generic_shutdown_super(struct super_block *sb)
 
 		cgroup_writeback_umount();
 
-		/* evict all inodes with zero refcount */
+		/* Evict all inodes with zero refcount. */
 		evict_inodes(sb);
-		/* only nonzero refcount inodes can have marks */
+
+		/*
+		 * Clean up and evict any inodes that still have references due
+		 * to fsnotify or the security policy.
+		 */
 		fsnotify_sb_delete(sb);
-		fscrypt_destroy_keyring(sb);
 		security_sb_delete(sb);
 
+		/*
+		 * Now that all potentially-encrypted inodes have been evicted,
+		 * the fscrypt keyring can be destroyed.
+		 */
+		fscrypt_destroy_keyring(sb);
+
 		if (sb->s_dio_done_wq) {
 			destroy_workqueue(sb->s_dio_done_wq);
 			sb->s_dio_done_wq = NULL;
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index bde8c9b7d25f..e23d382fc94b 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -269,15 +269,15 @@ EXPORT_SYMBOL_GPL(fsverity_enqueue_verify_work);
 int __init fsverity_init_workqueue(void)
 {
 	/*
-	 * Use an unbound workqueue to allow bios to be verified in parallel
-	 * even when they happen to complete on the same CPU.  This sacrifices
-	 * locality, but it's worthwhile since hashing is CPU-intensive.
+	 * Use a high-priority workqueue to prioritize verification work, which
+	 * blocks reads from completing, over regular application tasks.
 	 *
-	 * Also use a high-priority workqueue to prioritize verification work,
-	 * which blocks reads from completing, over regular application tasks.
+	 * For performance reasons, don't use an unbound workqueue.  Using an
+	 * unbound workqueue for crypto operations causes excessive scheduler
+	 * latency on ARM64.
 	 */
 	fsverity_read_workqueue = alloc_workqueue("fsverity_read_queue",
-						  WQ_UNBOUND | WQ_HIGHPRI,
+						  WQ_HIGHPRI,
 						  num_online_cpus());
 	if (!fsverity_read_workqueue)
 		return -ENOMEM;
diff --git a/include/linux/acpi_mdio.h b/include/linux/acpi_mdio.h
index 0a24ab7cb66f..8e2eefa9fbc0 100644
--- a/include/linux/acpi_mdio.h
+++ b/include/linux/acpi_mdio.h
@@ -9,7 +9,14 @@
 #include <linux/phy.h>
 
 #if IS_ENABLED(CONFIG_ACPI_MDIO)
-int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
+int __acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode,
+			    struct module *owner);
+
+static inline int
+acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *handle)
+{
+	return __acpi_mdiobus_register(mdio, handle, THIS_MODULE);
+}
 #else /* CONFIG_ACPI_MDIO */
 static inline int
 acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index d4afa8508a80..3a7909ed5498 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -96,6 +96,7 @@ static inline void user_exit_irqoff(void) { }
 static inline int exception_enter(void) { return 0; }
 static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline int ct_state(void) { return -1; }
+static inline int __ct_state(void) { return -1; }
 static __always_inline bool context_tracking_guest_enter(void) { return false; }
 static inline void context_tracking_guest_exit(void) { }
 #define CT_WARN_ON(cond) do { } while (0)
diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
index 4a4d56f77180..fdd537ea513f 100644
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -46,7 +46,9 @@ struct context_tracking {
 
 #ifdef CONFIG_CONTEXT_TRACKING
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
+#endif
 
+#ifdef CONFIG_CONTEXT_TRACKING_USER
 static __always_inline int __ct_state(void)
 {
 	return arch_atomic_read(this_cpu_ptr(&context_tracking.state)) & CT_STATE_MASK;
diff --git a/include/linux/lockd/xdr4.h b/include/linux/lockd/xdr4.h
index 9a6b55da8fd6..72831e35dca3 100644
--- a/include/linux/lockd/xdr4.h
+++ b/include/linux/lockd/xdr4.h
@@ -22,6 +22,7 @@
 #define	nlm4_fbig		cpu_to_be32(NLM_FBIG)
 #define	nlm4_failed		cpu_to_be32(NLM_FAILED)
 
+void	nlm4svc_set_file_lock_range(struct file_lock *fl, u64 off, u64 len);
 bool	nlm4svc_decode_void(struct svc_rqst *rqstp, struct xdr_stream *xdr);
 bool	nlm4svc_decode_testargs(struct svc_rqst *rqstp, struct xdr_stream *xdr);
 bool	nlm4svc_decode_lockargs(struct svc_rqst *rqstp, struct xdr_stream *xdr);
diff --git a/include/linux/nvme-tcp.h b/include/linux/nvme-tcp.h
index 75470159a194..57ebe1267f7f 100644
--- a/include/linux/nvme-tcp.h
+++ b/include/linux/nvme-tcp.h
@@ -115,8 +115,9 @@ struct nvme_tcp_icresp_pdu {
 struct nvme_tcp_term_pdu {
 	struct nvme_tcp_hdr	hdr;
 	__le16			fes;
-	__le32			fei;
-	__u8			rsvd[8];
+	__le16			feil;
+	__le16			feiu;
+	__u8			rsvd[10];
 };
 
 /**
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index da633d34ab86..8a52ef2e6fa6 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -14,9 +14,25 @@
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 bool of_mdiobus_child_is_phy(struct device_node *child);
-int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
-int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
-			     struct device_node *np);
+int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
+			  struct module *owner);
+
+static inline int of_mdiobus_register(struct mii_bus *mdio,
+				      struct device_node *np)
+{
+	return __of_mdiobus_register(mdio, np, THIS_MODULE);
+}
+
+int __devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			       struct device_node *np, struct module *owner);
+
+static inline int devm_of_mdiobus_register(struct device *dev,
+					   struct mii_bus *mdio,
+					   struct device_node *np)
+{
+	return __devm_of_mdiobus_register(dev, mdio, np, THIS_MODULE);
+}
+
 struct mdio_device *of_mdio_find_device(struct device_node *np);
 struct phy_device *of_phy_find_device(struct device_node *phy_np);
 struct phy_device *
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 313edd19bf54..d82ff9fa1a6e 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -215,7 +215,7 @@ struct plat_stmmacenet_data {
 	int unicast_filter_entries;
 	int tx_fifo_size;
 	int rx_fifo_size;
-	u32 addr64;
+	u32 host_dma_width;
 	u32 rx_queues_to_use;
 	u32 tx_queues_to_use;
 	u8 rx_sched_algorithm;
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
index 8ba8b5be5567..c1ef5fc60a3c 100644
--- a/include/linux/sysfb.h
+++ b/include/linux/sysfb.h
@@ -70,11 +70,16 @@ static inline void sysfb_disable(void)
 #ifdef CONFIG_EFI
 
 extern struct efifb_dmi_info efifb_dmi_list[];
-void sysfb_apply_efi_quirks(struct platform_device *pd);
+void sysfb_apply_efi_quirks(void);
+void sysfb_set_efifb_fwnode(struct platform_device *pd);
 
 #else /* CONFIG_EFI */
 
-static inline void sysfb_apply_efi_quirks(struct platform_device *pd)
+static inline void sysfb_apply_efi_quirks(void)
+{
+}
+
+static inline void sysfb_set_efifb_fwnode(struct platform_device *pd)
 {
 }
 
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 68dfc6936aa7..b80614e7d605 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -19,6 +19,9 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 	unsigned long nr = ctx->file_alloc_end;
 	int ret;
 
+	if (!table->bitmap)
+		return -ENFILE;
+
 	do {
 		ret = find_next_zero_bit(table->bitmap, nr, table->alloc_hint);
 		if (ret != nr)
diff --git a/io_uring/net.c b/io_uring/net.c
index 4fdc2770bbe4..f6d8b02387a9 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -47,6 +47,7 @@ struct io_connect {
 	struct sockaddr __user		*addr;
 	int				addr_len;
 	bool				in_progress;
+	bool				seen_econnaborted;
 };
 
 struct io_sr_msg {
@@ -1404,7 +1405,7 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
-	conn->in_progress = false;
+	conn->in_progress = conn->seen_econnaborted = false;
 	return 0;
 }
 
@@ -1441,18 +1442,24 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __sys_connect_file(req->file, &io->address,
 					connect->addr_len, file_flags);
-	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
+	if ((ret == -EAGAIN || ret == -EINPROGRESS || ret == -ECONNABORTED)
+	    && force_nonblock) {
 		if (ret == -EINPROGRESS) {
 			connect->in_progress = true;
-		} else {
-			if (req_has_async_data(req))
-				return -EAGAIN;
-			if (io_alloc_async_data(req)) {
-				ret = -ENOMEM;
+			return -EAGAIN;
+		}
+		if (ret == -ECONNABORTED) {
+			if (connect->seen_econnaborted)
 				goto out;
-			}
-			memcpy(req->async_data, &__io, sizeof(__io));
+			connect->seen_econnaborted = true;
+		}
+		if (req_has_async_data(req))
+			return -EAGAIN;
+		if (io_alloc_async_data(req)) {
+			ret = -ENOMEM;
+			goto out;
 		}
+		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 185d5dfb7d56..4426d0e15174 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -779,6 +779,7 @@ void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	}
 #endif
 	io_free_file_tables(&ctx->file_table);
+	io_file_table_set_alloc_range(ctx, 0, 0);
 	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 211f63e87c63..64706723624b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -969,7 +969,7 @@ static int __init bpf_jit_charge_init(void)
 {
 	/* Only used as heuristic here to derive limit. */
 	bpf_jit_limit_max = bpf_jit_alloc_exec_limit();
-	bpf_jit_limit = min_t(u64, round_up(bpf_jit_limit_max >> 2,
+	bpf_jit_limit = min_t(u64, round_up(bpf_jit_limit_max >> 1,
 					    PAGE_SIZE), LONG_MAX);
 	return 0;
 }
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 846add8394c4..be61332c66b5 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -21,7 +21,7 @@ static __always_inline void __enter_from_user_mode(struct pt_regs *regs)
 	arch_enter_from_user_mode(regs);
 	lockdep_hardirqs_off(CALLER_ADDR0);
 
-	CT_WARN_ON(ct_state() != CONTEXT_USER);
+	CT_WARN_ON(__ct_state() != CONTEXT_USER);
 	user_exit_irqoff();
 
 	instrumentation_begin();
@@ -192,13 +192,14 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 
 static void exit_to_user_mode_prepare(struct pt_regs *regs)
 {
-	unsigned long ti_work = read_thread_flags();
+	unsigned long ti_work;
 
 	lockdep_assert_irqs_disabled();
 
 	/* Flush pending rcuog wakeup before the last need_resched() check */
 	tick_nohz_user_enter_prepare();
 
+	ti_work = read_thread_flags();
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 227ada724029..2aa286b4151b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3830,7 +3830,7 @@ ctx_sched_in(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		return;
 
-	if (is_active ^ EVENT_TIME) {
+	if (!(is_active & EVENT_TIME)) {
 		/* start ctx time */
 		__update_context_time(ctx, false);
 		perf_cgroup_set_timestamp(cpuctx);
@@ -9009,7 +9009,7 @@ static void perf_event_bpf_output(struct perf_event *event, void *data)
 
 	perf_event_header__init_id(&bpf_event->event_id.header,
 				   &sample, event);
-	ret = perf_output_begin(&handle, data, event,
+	ret = perf_output_begin(&handle, &sample, event,
 				bpf_event->event_id.header.size);
 	if (ret)
 		return;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f730b6fe94a7..9ebfd484189b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2082,6 +2082,9 @@ static inline void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 
 void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
+	if (task_on_rq_migrating(p))
+		flags |= ENQUEUE_MIGRATED;
+
 	enqueue_task(rq, p, flags);
 
 	p->on_rq = TASK_ON_RQ_QUEUED;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2c3d0d49c80e..88821ab009b3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4636,6 +4636,29 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 #endif
 }
 
+static inline bool entity_is_long_sleeper(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq;
+	u64 sleep_time;
+
+	if (se->exec_start == 0)
+		return false;
+
+	cfs_rq = cfs_rq_of(se);
+
+	sleep_time = rq_clock_task(rq_of(cfs_rq));
+
+	/* Happen while migrating because of clock task divergence */
+	if (sleep_time <= se->exec_start)
+		return false;
+
+	sleep_time -= se->exec_start;
+	if (sleep_time > ((1ULL << 63) / scale_load_down(NICE_0_LOAD)))
+		return true;
+
+	return false;
+}
+
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
@@ -4669,8 +4692,29 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		vruntime -= thresh;
 	}
 
-	/* ensure we never gain time by being placed backwards. */
-	se->vruntime = max_vruntime(se->vruntime, vruntime);
+	/*
+	 * Pull vruntime of the entity being placed to the base level of
+	 * cfs_rq, to prevent boosting it if placed backwards.
+	 * However, min_vruntime can advance much faster than real time, with
+	 * the extreme being when an entity with the minimal weight always runs
+	 * on the cfs_rq. If the waking entity slept for a long time, its
+	 * vruntime difference from min_vruntime may overflow s64 and their
+	 * comparison may get inversed, so ignore the entity's original
+	 * vruntime in that case.
+	 * The maximal vruntime speedup is given by the ratio of normal to
+	 * minimal weight: scale_load_down(NICE_0_LOAD) / MIN_SHARES.
+	 * When placing a migrated waking entity, its exec_start has been set
+	 * from a different rq. In order to take into account a possible
+	 * divergence between new and prev rq's clocks task because of irq and
+	 * stolen time, we take an additional margin.
+	 * So, cutting off on the sleep time of
+	 *     2^63 / scale_load_down(NICE_0_LOAD) ~ 104 days
+	 * should be safe.
+	 */
+	if (entity_is_long_sleeper(se))
+		se->vruntime = vruntime;
+	else
+		se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
@@ -4747,6 +4791,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	if (flags & ENQUEUE_WAKEUP)
 		place_entity(cfs_rq, se, 0);
+	/* Entity has migrated, no longer consider this task hot */
+	if (flags & ENQUEUE_MIGRATED)
+		se->exec_start = 0;
 
 	check_schedstat_required();
 	update_stats_enqueue_fair(cfs_rq, se, flags);
@@ -7449,9 +7496,6 @@ static void migrate_task_rq_fair(struct task_struct *p, int new_cpu)
 	/* Tell new CPU we are migrated */
 	se->avg.last_update_time = 0;
 
-	/* We have migrated, no longer consider this task hot */
-	se->exec_start = 0;
-
 	update_scan_period(p, new_cpu);
 }
 
diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index c4945f8adc11..2f37a6e68aa9 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -339,7 +339,7 @@ static void move_to_next_cpu(void)
 	cpumask_clear(current_mask);
 	cpumask_set_cpu(next_cpu, current_mask);
 
-	sched_setaffinity(0, current_mask);
+	set_cpus_allowed_ptr(current, current_mask);
 	return;
 
  change_mode:
@@ -446,7 +446,7 @@ static int start_single_kthread(struct trace_array *tr)
 
 	}
 
-	sched_setaffinity(kthread->pid, current_mask);
+	set_cpus_allowed_ptr(kthread, current_mask);
 
 	kdata->kthread = kthread;
 	wake_up_process(kthread);
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 69cb44b035ec..96be96a1f35d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5088,35 +5088,21 @@ static inline bool mas_rewind_node(struct ma_state *mas)
  */
 static inline bool mas_skip_node(struct ma_state *mas)
 {
-	unsigned char slot, slot_count;
-	unsigned long *pivots;
-	enum maple_type mt;
+	if (mas_is_err(mas))
+		return false;
 
-	mt = mte_node_type(mas->node);
-	slot_count = mt_slots[mt] - 1;
 	do {
 		if (mte_is_root(mas->node)) {
-			slot = mas->offset;
-			if (slot > slot_count) {
+			if (mas->offset >= mas_data_end(mas)) {
 				mas_set_err(mas, -EBUSY);
 				return false;
 			}
 		} else {
 			mas_ascend(mas);
-			slot = mas->offset;
-			mt = mte_node_type(mas->node);
-			slot_count = mt_slots[mt] - 1;
 		}
-	} while (slot > slot_count);
-
-	mas->offset = ++slot;
-	pivots = ma_pivots(mas_mn(mas), mt);
-	if (slot > 0)
-		mas->min = pivots[slot - 1] + 1;
-
-	if (slot <= slot_count)
-		mas->max = pivots[slot];
+	} while (mas->offset >= mas_data_end(mas));
 
+	mas->offset++;
 	return true;
 }
 
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index ec847bf4dcb4..f7364b9fee93 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2602,6 +2602,49 @@ static noinline void check_empty_area_window(struct maple_tree *mt)
 	rcu_read_unlock();
 }
 
+static noinline void check_empty_area_fill(struct maple_tree *mt)
+{
+	const unsigned long max = 0x25D78000;
+	unsigned long size;
+	int loop, shift;
+	MA_STATE(mas, mt, 0, 0);
+
+	mt_set_non_kernel(99999);
+	for (shift = 12; shift <= 16; shift++) {
+		loop = 5000;
+		size = 1 << shift;
+		while (loop--) {
+			mas_set(&mas, 0);
+			mas_lock(&mas);
+			MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != 0);
+			MT_BUG_ON(mt, mas.last != mas.index + size - 1);
+			mas_store_gfp(&mas, (void *)size, GFP_KERNEL);
+			mas_unlock(&mas);
+			mas_reset(&mas);
+		}
+	}
+
+	/* No space left. */
+	size = 0x1000;
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != -EBUSY);
+	rcu_read_unlock();
+
+	/* Fill a depth 3 node to the maximum */
+	for (unsigned long i = 629440511; i <= 629440800; i += 6)
+		mtree_store_range(mt, i, i + 5, (void *)i, GFP_KERNEL);
+	/* Make space in the second-last depth 4 node */
+	mtree_erase(mt, 631668735);
+	/* Make space in the last depth 4 node */
+	mtree_erase(mt, 629506047);
+	mas_reset(&mas);
+	/* Search from just after the gap in the second-last depth 4 */
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area(&mas, 629506048, 690000000, 0x5000) != 0);
+	rcu_read_unlock();
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2854,6 +2897,11 @@ static int maple_tree_seed(void)
 	check_empty_area_window(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_empty_area_fill(&tree);
+	mtree_destroy(&tree);
+
+
 #if defined(BENCH)
 skip:
 #endif
diff --git a/mm/kfence/Makefile b/mm/kfence/Makefile
index 0bb95728a784..2de2a58d11a1 100644
--- a/mm/kfence/Makefile
+++ b/mm/kfence/Makefile
@@ -2,5 +2,5 @@
 
 obj-y := core.o report.o
 
-CFLAGS_kfence_test.o := -g -fno-omit-frame-pointer -fno-optimize-sibling-calls
+CFLAGS_kfence_test.o := -fno-omit-frame-pointer -fno-optimize-sibling-calls
 obj-$(CONFIG_KFENCE_KUNIT_TEST) += kfence_test.o
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 141788858b70..c3d04753806a 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -727,10 +727,14 @@ static const struct seq_operations objects_sops = {
 };
 DEFINE_SEQ_ATTRIBUTE(objects);
 
-static int __init kfence_debugfs_init(void)
+static int kfence_debugfs_init(void)
 {
-	struct dentry *kfence_dir = debugfs_create_dir("kfence", NULL);
+	struct dentry *kfence_dir;
 
+	if (!READ_ONCE(kfence_enabled))
+		return 0;
+
+	kfence_dir = debugfs_create_dir("kfence", NULL);
 	debugfs_create_file("stats", 0444, kfence_dir, NULL, &stats_fops);
 	debugfs_create_file("objects", 0400, kfence_dir, NULL, &objects_fops);
 	return 0;
@@ -893,6 +897,8 @@ static int kfence_init_late(void)
 	}
 
 	kfence_init_enable();
+	kfence_debugfs_init();
+
 	return 0;
 }
 
diff --git a/mm/ksm.c b/mm/ksm.c
index c19fcca9bc03..cb272b6fde59 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -960,9 +960,15 @@ static int unmerge_and_remove_all_rmap_items(void)
 
 		mm = mm_slot->slot.mm;
 		mmap_read_lock(mm);
+
+		/*
+		 * Exit right away if mm is exiting to avoid lockdep issue in
+		 * the maple tree
+		 */
+		if (ksm_test_exit(mm))
+			goto mm_exiting;
+
 		for_each_vma(vmi, vma) {
-			if (ksm_test_exit(mm))
-				break;
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
 			err = unmerge_ksm_pages(vma,
@@ -971,6 +977,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 				goto error;
 		}
 
+mm_exiting:
 		remove_trailing_rmap_items(&mm_slot->rmap_list);
 		mmap_read_unlock(mm);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b2877a84ed19..5cae08963984 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1402,6 +1402,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
+	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
 	bool init = want_init_on_free();
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
@@ -1476,7 +1477,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	if (!should_skip_kasan_poison(page, fpi_flags)) {
+	if (!skip_kasan_poison) {
 		kasan_poison_pages(page, order, init);
 
 		/* Memory is already initialized if KASAN did it internally. */
diff --git a/mm/slab.c b/mm/slab.c
index 59c8e28f7b6a..62869bc3c2f9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -840,7 +840,7 @@ static int init_cache_node(struct kmem_cache *cachep, int node, gfp_t gfp)
 	return 0;
 }
 
-#if (defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)) || defined(CONFIG_SMP)
+#if defined(CONFIG_NUMA) || defined(CONFIG_SMP)
 /*
  * Allocates and initializes node for a node on each slab cache, used for
  * either memory or cpu hotplug.  If memory is being hot-added, the kmem_cache_node
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b65c3aabcd53..334e308451f5 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2871,10 +2871,25 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 		return -ENXIO;
 	}
 
-	if (hci_skb_pkt_type(skb) != HCI_EVENT_PKT &&
-	    hci_skb_pkt_type(skb) != HCI_ACLDATA_PKT &&
-	    hci_skb_pkt_type(skb) != HCI_SCODATA_PKT &&
-	    hci_skb_pkt_type(skb) != HCI_ISODATA_PKT) {
+	switch (hci_skb_pkt_type(skb)) {
+	case HCI_EVENT_PKT:
+		break;
+	case HCI_ACLDATA_PKT:
+		/* Detect if ISO packet has been sent as ACL */
+		if (hci_conn_num(hdev, ISO_LINK)) {
+			__u16 handle = __le16_to_cpu(hci_acl_hdr(skb)->handle);
+			__u8 type;
+
+			type = hci_conn_lookup_type(hdev, hci_handle(handle));
+			if (type == ISO_LINK)
+				hci_skb_pkt_type(skb) = HCI_ISODATA_PKT;
+		}
+		break;
+	case HCI_SCODATA_PKT:
+		break;
+	case HCI_ISODATA_PKT:
+		break;
+	default:
 		kfree_skb(skb);
 		return -EINVAL;
 	}
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 3eec688a88a9..f614f96c5c23 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -643,6 +643,7 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
 	cancel_work_sync(&hdev->cmd_sync_work);
 	cancel_work_sync(&hdev->reenable_adv_work);
 
+	mutex_lock(&hdev->cmd_sync_work_lock);
 	list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_list, list) {
 		if (entry->destroy)
 			entry->destroy(hdev, entry->data, -ECANCELED);
@@ -650,6 +651,7 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
 		list_del(&entry->list);
 		kfree(entry);
 	}
+	mutex_unlock(&hdev->cmd_sync_work_lock);
 }
 
 void __hci_cmd_sync_cancel(struct hci_dev *hdev, int err)
@@ -2367,6 +2369,45 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
 	return err;
 }
 
+static int hci_pause_addr_resolution(struct hci_dev *hdev)
+{
+	int err;
+
+	if (!use_ll_privacy(hdev))
+		return 0;
+
+	if (!hci_dev_test_flag(hdev, HCI_LL_RPA_RESOLUTION))
+		return 0;
+
+	/* Cannot disable addr resolution if scanning is enabled or
+	 * when initiating an LE connection.
+	 */
+	if (hci_dev_test_flag(hdev, HCI_LE_SCAN) ||
+	    hci_lookup_le_connect(hdev)) {
+		bt_dev_err(hdev, "Command not allowed when scan/LE connect");
+		return -EPERM;
+	}
+
+	/* Cannot disable addr resolution if advertising is enabled. */
+	err = hci_pause_advertising_sync(hdev);
+	if (err) {
+		bt_dev_err(hdev, "Pause advertising failed: %d", err);
+		return err;
+	}
+
+	err = hci_le_set_addr_resolution_enable_sync(hdev, 0x00);
+	if (err)
+		bt_dev_err(hdev, "Unable to disable Address Resolution: %d",
+			   err);
+
+	/* Return if address resolution is disabled and RPA is not used. */
+	if (!err && scan_use_rpa(hdev))
+		return err;
+
+	hci_resume_advertising_sync(hdev);
+	return err;
+}
+
 struct sk_buff *hci_read_local_oob_data_sync(struct hci_dev *hdev,
 					     bool extended, struct sock *sk)
 {
@@ -2402,7 +2443,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 	u8 filter_policy;
 	int err;
 
-	/* Pause advertising if resolving list can be used as controllers are
+	/* Pause advertising if resolving list can be used as controllers
 	 * cannot accept resolving list modifications while advertising.
 	 */
 	if (use_ll_privacy(hdev)) {
@@ -3301,6 +3342,7 @@ static const struct hci_init_stage amp_init1[] = {
 	HCI_INIT(hci_read_flow_control_mode_sync),
 	/* HCI_OP_READ_LOCATION_DATA */
 	HCI_INIT(hci_read_location_data_sync),
+	{}
 };
 
 static int hci_init1_sync(struct hci_dev *hdev)
@@ -3335,6 +3377,7 @@ static int hci_init1_sync(struct hci_dev *hdev)
 static const struct hci_init_stage amp_init2[] = {
 	/* HCI_OP_READ_LOCAL_FEATURES */
 	HCI_INIT(hci_read_local_features_sync),
+	{}
 };
 
 /* Read Buffer Size (ACL mtu, max pkt, etc.) */
@@ -5376,27 +5419,12 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 
 	cancel_interleave_scan(hdev);
 
-	/* Pause advertising since active scanning disables address resolution
-	 * which advertising depend on in order to generate its RPAs.
-	 */
-	if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_PRIVACY)) {
-		err = hci_pause_advertising_sync(hdev);
-		if (err) {
-			bt_dev_err(hdev, "pause advertising failed: %d", err);
-			goto failed;
-		}
-	}
-
-	/* Disable address resolution while doing active scanning since the
-	 * accept list shall not be used and all reports shall reach the host
-	 * anyway.
+	/* Pause address resolution for active scan and stop advertising if
+	 * privacy is enabled.
 	 */
-	err = hci_le_set_addr_resolution_enable_sync(hdev, 0x00);
-	if (err) {
-		bt_dev_err(hdev, "Unable to disable Address Resolution: %d",
-			   err);
+	err = hci_pause_addr_resolution(hdev);
+	if (err)
 		goto failed;
-	}
 
 	/* All active scans will be done with either a resolvable private
 	 * address (when privacy feature has been enabled) or non-resolvable
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 2dabef488eaa..cb959e8eac18 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1621,7 +1621,6 @@ static void iso_disconn_cfm(struct hci_conn *hcon, __u8 reason)
 void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 {
 	struct iso_conn *conn = hcon->iso_data;
-	struct hci_iso_data_hdr *hdr;
 	__u16 pb, ts, len;
 
 	if (!conn)
@@ -1643,6 +1642,8 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		}
 
 		if (ts) {
+			struct hci_iso_ts_data_hdr *hdr;
+
 			/* TODO: add timestamp to the packet? */
 			hdr = skb_pull_data(skb, HCI_ISO_TS_DATA_HDR_SIZE);
 			if (!hdr) {
@@ -1650,15 +1651,19 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 				goto drop;
 			}
 
+			len = __le16_to_cpu(hdr->slen);
 		} else {
+			struct hci_iso_data_hdr *hdr;
+
 			hdr = skb_pull_data(skb, HCI_ISO_DATA_HDR_SIZE);
 			if (!hdr) {
 				BT_ERR("Frame is too short (len %d)", skb->len);
 				goto drop;
 			}
+
+			len = __le16_to_cpu(hdr->slen);
 		}
 
-		len    = __le16_to_cpu(hdr->slen);
 		flags  = hci_iso_data_flags(len);
 		len    = hci_iso_data_len(len);
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index da85768b04b7..b6f69d1feeee 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -708,6 +708,17 @@ void l2cap_chan_del(struct l2cap_chan *chan, int err)
 }
 EXPORT_SYMBOL_GPL(l2cap_chan_del);
 
+static void __l2cap_chan_list_id(struct l2cap_conn *conn, u16 id,
+				 l2cap_chan_func_t func, void *data)
+{
+	struct l2cap_chan *chan, *l;
+
+	list_for_each_entry_safe(chan, l, &conn->chan_l, list) {
+		if (chan->ident == id)
+			func(chan, data);
+	}
+}
+
 static void __l2cap_chan_list(struct l2cap_conn *conn, l2cap_chan_func_t func,
 			      void *data)
 {
@@ -775,23 +786,9 @@ static void l2cap_chan_le_connect_reject(struct l2cap_chan *chan)
 
 static void l2cap_chan_ecred_connect_reject(struct l2cap_chan *chan)
 {
-	struct l2cap_conn *conn = chan->conn;
-	struct l2cap_ecred_conn_rsp rsp;
-	u16 result;
-
-	if (test_bit(FLAG_DEFER_SETUP, &chan->flags))
-		result = L2CAP_CR_LE_AUTHORIZATION;
-	else
-		result = L2CAP_CR_LE_BAD_PSM;
-
 	l2cap_state_change(chan, BT_DISCONN);
 
-	memset(&rsp, 0, sizeof(rsp));
-
-	rsp.result  = cpu_to_le16(result);
-
-	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CONN_RSP, sizeof(rsp),
-		       &rsp);
+	__l2cap_ecred_conn_rsp_defer(chan);
 }
 
 static void l2cap_chan_connect_reject(struct l2cap_chan *chan)
@@ -846,7 +843,7 @@ void l2cap_chan_close(struct l2cap_chan *chan, int reason)
 					break;
 				case L2CAP_MODE_EXT_FLOWCTL:
 					l2cap_chan_ecred_connect_reject(chan);
-					break;
+					return;
 				}
 			}
 		}
@@ -3938,43 +3935,86 @@ void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan)
 		       &rsp);
 }
 
-void __l2cap_ecred_conn_rsp_defer(struct l2cap_chan *chan)
+static void l2cap_ecred_list_defer(struct l2cap_chan *chan, void *data)
 {
+	int *result = data;
+
+	if (*result || test_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
+		return;
+
+	switch (chan->state) {
+	case BT_CONNECT2:
+		/* If channel still pending accept add to result */
+		(*result)++;
+		return;
+	case BT_CONNECTED:
+		return;
+	default:
+		/* If not connected or pending accept it has been refused */
+		*result = -ECONNREFUSED;
+		return;
+	}
+}
+
+struct l2cap_ecred_rsp_data {
 	struct {
 		struct l2cap_ecred_conn_rsp rsp;
-		__le16 dcid[5];
+		__le16 scid[L2CAP_ECRED_MAX_CID];
 	} __packed pdu;
+	int count;
+};
+
+static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
+{
+	struct l2cap_ecred_rsp_data *rsp = data;
+
+	if (test_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
+		return;
+
+	/* Reset ident so only one response is sent */
+	chan->ident = 0;
+
+	/* Include all channels pending with the same ident */
+	if (!rsp->pdu.rsp.result)
+		rsp->pdu.rsp.dcid[rsp->count++] = cpu_to_le16(chan->scid);
+	else
+		l2cap_chan_del(chan, ECONNRESET);
+}
+
+void __l2cap_ecred_conn_rsp_defer(struct l2cap_chan *chan)
+{
 	struct l2cap_conn *conn = chan->conn;
-	u16 ident = chan->ident;
-	int i = 0;
+	struct l2cap_ecred_rsp_data data;
+	u16 id = chan->ident;
+	int result = 0;
 
-	if (!ident)
+	if (!id)
 		return;
 
-	BT_DBG("chan %p ident %d", chan, ident);
+	BT_DBG("chan %p id %d", chan, id);
 
-	pdu.rsp.mtu     = cpu_to_le16(chan->imtu);
-	pdu.rsp.mps     = cpu_to_le16(chan->mps);
-	pdu.rsp.credits = cpu_to_le16(chan->rx_credits);
-	pdu.rsp.result  = cpu_to_le16(L2CAP_CR_LE_SUCCESS);
+	memset(&data, 0, sizeof(data));
 
-	mutex_lock(&conn->chan_lock);
+	data.pdu.rsp.mtu     = cpu_to_le16(chan->imtu);
+	data.pdu.rsp.mps     = cpu_to_le16(chan->mps);
+	data.pdu.rsp.credits = cpu_to_le16(chan->rx_credits);
+	data.pdu.rsp.result  = cpu_to_le16(L2CAP_CR_LE_SUCCESS);
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
-		if (chan->ident != ident)
-			continue;
+	/* Verify that all channels are ready */
+	__l2cap_chan_list_id(conn, id, l2cap_ecred_list_defer, &result);
 
-		/* Reset ident so only one response is sent */
-		chan->ident = 0;
+	if (result > 0)
+		return;
 
-		/* Include all channels pending with the same ident */
-		pdu.dcid[i++] = cpu_to_le16(chan->scid);
-	}
+	if (result < 0)
+		data.pdu.rsp.result = cpu_to_le16(L2CAP_CR_LE_AUTHORIZATION);
 
-	mutex_unlock(&conn->chan_lock);
+	/* Build response */
+	__l2cap_chan_list_id(conn, id, l2cap_ecred_rsp_defer, &data);
 
-	l2cap_send_cmd(conn, ident, L2CAP_ECRED_CONN_RSP,
-			sizeof(pdu.rsp) + i * sizeof(__le16), &pdu);
+	l2cap_send_cmd(conn, id, L2CAP_ECRED_CONN_RSP,
+		       sizeof(data.pdu.rsp) + (data.count * sizeof(__le16)),
+		       &data.pdu);
 }
 
 void __l2cap_connect_rsp_defer(struct l2cap_chan *chan)
@@ -6078,6 +6118,7 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
 		chan->ident = cmd->ident;
+		chan->mode = L2CAP_MODE_EXT_FLOWCTL;
 
 		if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 			l2cap_state_change(chan, BT_CONNECT2);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 0dd30a3beb77..fc4ba0884da9 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4627,12 +4627,6 @@ static int set_mgmt_mesh_func(struct sock *sk, struct hci_dev *hdev,
 				       MGMT_OP_SET_EXP_FEATURE,
 				       MGMT_STATUS_INVALID_INDEX);
 
-	/* Changes can only be made when controller is powered down */
-	if (hdev_is_powered(hdev))
-		return mgmt_cmd_status(sk, hdev->id,
-				       MGMT_OP_SET_EXP_FEATURE,
-				       MGMT_STATUS_REJECTED);
-
 	/* Parameters are limited to a single octet */
 	if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
 		return mgmt_cmd_status(sk, hdev->id,
@@ -9352,7 +9346,8 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
 						HCI_MGMT_VAR_LEN },
 	{ add_adv_patterns_monitor_rssi,
-				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE },
+				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE,
+						HCI_MGMT_VAR_LEN },
 	{ set_mesh,                MGMT_SET_MESH_RECEIVER_SIZE,
 						HCI_MGMT_VAR_LEN },
 	{ mesh_features,           MGMT_MESH_READ_FEATURES_SIZE },
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 16889ea3e0a7..a65d62fb9009 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -7,6 +7,7 @@
 
 #include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 
@@ -248,6 +249,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
 static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 					struct net_device *dev)
 {
+	int len = BRCM_LEG_TAG_LEN;
 	int source_port;
 	u8 *brcm_tag;
 
@@ -262,12 +264,16 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
+	/* VLAN tag is added by BCM63xx internal switch */
+	if (netdev_uses_dsa(skb->dev))
+		len += VLAN_HLEN;
+
 	/* Remove Broadcom tag and update checksum */
-	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
+	skb_pull_rcsum(skb, len);
 
 	dsa_default_offload_fwd_mark(skb);
 
-	dsa_strip_etype_header(skb, BRCM_LEG_TAG_LEN);
+	dsa_strip_etype_header(skb, len);
 
 	return skb;
 }
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index cae9f1a4e059..5b8242265617 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -552,7 +552,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -561,7 +561,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index c035a96fba3a..4d5937af08ee 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -981,7 +981,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -990,7 +990,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index ecc1de2e68a5..64430949f685 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -144,12 +144,14 @@ u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 u16 __ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta, struct sk_buff *skb)
 {
+	const struct ethhdr *eth = (void *)skb->data;
 	struct mac80211_qos_map *qos_map;
 	bool qos;
 
 	/* all mesh/ocb stations are required to support WME */
-	if (sta && (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-		    sdata->vif.type == NL80211_IFTYPE_OCB))
+	if ((sdata->vif.type == NL80211_IFTYPE_MESH_POINT &&
+	    !is_multicast_ether_addr(eth->h_dest)) ||
+	    (sdata->vif.type == NL80211_IFTYPE_OCB && sta))
 		qos = true;
 	else if (sta)
 		qos = sta->sta.wme;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 938cccab331d..f0cde2d7233d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -834,7 +834,6 @@ static bool __mptcp_finish_join(struct mptcp_sock *msk, struct sock *ssk)
 	if (sk->sk_socket && !ssk->sk_socket)
 		mptcp_sock_graft(ssk, sk->sk_socket);
 
-	mptcp_propagate_sndbuf((struct sock *)msk, ssk);
 	mptcp_sockopt_sync_locked(msk, ssk);
 	return true;
 }
@@ -2358,7 +2357,6 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		goto out;
 	}
 
-	sock_orphan(ssk);
 	subflow->disposable = 1;
 
 	/* if ssk hit tcp_done(), tcp_cleanup_ulp() cleared the related ops
@@ -2366,14 +2364,22 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	 * reference owned by msk;
 	 */
 	if (!inet_csk(ssk)->icsk_ulp_ops) {
+		WARN_ON_ONCE(!sock_flag(ssk, SOCK_DEAD));
 		kfree_rcu(subflow, rcu);
+	} else if (msk->in_accept_queue && msk->first == ssk) {
+		/* if the first subflow moved to a close state, e.g. due to
+		 * incoming reset and we reach here before inet_child_forget()
+		 * the TCP stack could later try to close it via
+		 * inet_csk_listen_stop(), or deliver it to the user space via
+		 * accept().
+		 * We can't delete the subflow - or risk a double free - nor let
+		 * the msk survive - or will be leaked in the non accept scenario:
+		 * fallback and let TCP cope with the subflow cleanup.
+		 */
+		WARN_ON_ONCE(sock_flag(ssk, SOCK_DEAD));
+		mptcp_subflow_drop_ctx(ssk);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
-		if (ssk->sk_state == TCP_LISTEN) {
-			tcp_set_state(ssk, TCP_CLOSE);
-			mptcp_subflow_queue_clean(sk, ssk);
-			inet_csk_listen_stop(ssk);
-		}
 		__tcp_close(ssk, 0);
 
 		/* close acquired an extra ref */
@@ -2413,9 +2419,10 @@ static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 	return 0;
 }
 
-static void __mptcp_close_subflow(struct mptcp_sock *msk)
+static void __mptcp_close_subflow(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	might_sleep();
 
@@ -2429,7 +2436,15 @@ static void __mptcp_close_subflow(struct mptcp_sock *msk)
 		if (!skb_queue_empty_lockless(&ssk->sk_receive_queue))
 			continue;
 
-		mptcp_close_ssk((struct sock *)msk, ssk, subflow);
+		mptcp_close_ssk(sk, ssk, subflow);
+	}
+
+	/* if the MPC subflow has been closed before the msk is accepted,
+	 * msk will never be accept-ed, close it now
+	 */
+	if (!msk->first && msk->in_accept_queue) {
+		sock_set_flag(sk, SOCK_DEAD);
+		inet_sk_state_store(sk, TCP_CLOSE);
 	}
 }
 
@@ -2638,6 +2653,9 @@ static void mptcp_worker(struct work_struct *work)
 	__mptcp_check_send_data_fin(sk);
 	mptcp_check_data_fin(sk);
 
+	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		__mptcp_close_subflow(sk);
+
 	/* There is no point in keeping around an orphaned sk timedout or
 	 * closed, but we need the msk around to reply to incoming DATA_FIN,
 	 * even if it is orphaned and in FIN_WAIT2 state
@@ -2653,9 +2671,6 @@ static void mptcp_worker(struct work_struct *work)
 		}
 	}
 
-	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
-		__mptcp_close_subflow(msk);
-
 	if (test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		__mptcp_retrans(sk);
 
@@ -3085,6 +3100,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->local_key = subflow_req->local_key;
 	msk->token = subflow_req->token;
 	msk->subflow = NULL;
+	msk->in_accept_queue = 1;
 	WRITE_ONCE(msk->fully_established, false);
 	if (mp_opt->suboptions & OPTION_MPTCP_CSUMREQD)
 		WRITE_ONCE(msk->csum_enabled, true);
@@ -3111,8 +3127,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	security_inet_csk_clone(nsk, req);
 	bh_unlock_sock(nsk);
 
-	/* keep a single reference */
-	__sock_put(nsk);
+	/* note: the newly allocated socket refcount is 2 now */
 	return nsk;
 }
 
@@ -3168,8 +3183,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			goto out;
 		}
 
-		/* acquire the 2nd reference for the owning socket */
-		sock_hold(new_mptcp_sock);
 		newsk = new_mptcp_sock;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
 	} else {
@@ -3727,23 +3740,9 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		struct mptcp_subflow_context *subflow;
 		struct sock *newsk = newsock->sk;
 
-		lock_sock(newsk);
+		msk->in_accept_queue = 0;
 
-		/* PM/worker can now acquire the first subflow socket
-		 * lock without racing with listener queue cleanup,
-		 * we can notify it, if needed.
-		 *
-		 * Even if remote has reset the initial subflow by now
-		 * the refcnt is still at least one.
-		 */
-		subflow = mptcp_subflow_ctx(msk->first);
-		list_add(&subflow->node, &msk->conn_list);
-		sock_hold(msk->first);
-		if (mptcp_is_fully_established(newsk))
-			mptcp_pm_fully_established(msk, msk->first, GFP_KERNEL);
-
-		mptcp_rcv_space_init(msk, msk->first);
-		mptcp_propagate_sndbuf(newsk, msk->first);
+		lock_sock(newsk);
 
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6f22ae13c984..051e8022d661 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -286,7 +286,8 @@ struct mptcp_sock {
 	u8		recvmsg_inq:1,
 			cork:1,
 			nodelay:1,
-			fastopening:1;
+			fastopening:1,
+			in_accept_queue:1;
 	int		connect_flags;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
@@ -614,7 +615,6 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
-void mptcp_subflow_queue_clean(struct sock *sk, struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
@@ -651,6 +651,8 @@ void mptcp_subflow_set_active(struct mptcp_subflow_context *subflow);
 
 bool mptcp_subflow_active(struct mptcp_subflow_context *subflow);
 
+void mptcp_subflow_drop_ctx(struct sock *ssk);
+
 static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 					      struct mptcp_subflow_context *ctx)
 {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 1e10a38ccf9d..fc876c248002 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -355,6 +355,12 @@ void mptcp_subflow_reset(struct sock *ssk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = subflow->conn;
 
+	/* mptcp_mp_fail_no_response() can reach here on an already closed
+	 * socket
+	 */
+	if (ssk->sk_state == TCP_CLOSE)
+		return;
+
 	/* must hold: tcp_done() could drop last reference on parent */
 	sock_hold(sk);
 
@@ -630,9 +636,10 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 
 static void mptcp_force_close(struct sock *sk)
 {
-	/* the msk is not yet exposed to user-space */
+	/* the msk is not yet exposed to user-space, and refcount is 2 */
 	inet_sk_state_store(sk, TCP_CLOSE);
 	sk_common_release(sk);
+	sock_put(sk);
 }
 
 static void subflow_ulp_fallback(struct sock *sk,
@@ -648,7 +655,7 @@ static void subflow_ulp_fallback(struct sock *sk,
 	mptcp_subflow_ops_undo_override(sk);
 }
 
-static void subflow_drop_ctx(struct sock *ssk)
+void mptcp_subflow_drop_ctx(struct sock *ssk)
 {
 	struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(ssk);
 
@@ -685,6 +692,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	struct mptcp_options_received mp_opt;
 	bool fallback, fallback_is_fatal;
 	struct sock *new_msk = NULL;
+	struct mptcp_sock *owner;
 	struct sock *child;
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
@@ -751,7 +759,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 			if (new_msk)
 				mptcp_copy_inaddrs(new_msk, child);
-			subflow_drop_ctx(child);
+			mptcp_subflow_drop_ctx(child);
 			goto out;
 		}
 
@@ -759,6 +767,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		ctx->setsockopt_seq = listener->setsockopt_seq;
 
 		if (ctx->mp_capable) {
+			owner = mptcp_sk(new_msk);
+
 			/* this can't race with mptcp_close(), as the msk is
 			 * not yet exposted to user-space
 			 */
@@ -767,14 +777,14 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			/* record the newly created socket as the first msk
 			 * subflow, but don't link it yet into conn_list
 			 */
-			WRITE_ONCE(mptcp_sk(new_msk)->first, child);
+			WRITE_ONCE(owner->first, child);
 
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */
 			mptcp_sk(new_msk)->setsockopt_seq = ctx->setsockopt_seq;
-			mptcp_pm_new_connection(mptcp_sk(new_msk), child, 1);
-			mptcp_token_accept(subflow_req, mptcp_sk(new_msk));
+			mptcp_pm_new_connection(owner, child, 1);
+			mptcp_token_accept(subflow_req, owner);
 			ctx->conn = new_msk;
 			new_msk = NULL;
 
@@ -782,15 +792,21 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			 * uses the correct data
 			 */
 			mptcp_copy_inaddrs(ctx->conn, child);
+			mptcp_propagate_sndbuf(ctx->conn, child);
+
+			mptcp_rcv_space_init(owner, child);
+			list_add(&ctx->node, &owner->conn_list);
+			sock_hold(child);
 
 			/* with OoO packets we can reach here without ingress
 			 * mpc option
 			 */
-			if (mp_opt.suboptions & OPTIONS_MPTCP_MPC)
+			if (mp_opt.suboptions & OPTIONS_MPTCP_MPC) {
 				mptcp_subflow_fully_established(ctx, &mp_opt);
+				mptcp_pm_fully_established(owner, child, GFP_ATOMIC);
+				ctx->pm_notified = 1;
+			}
 		} else if (ctx->mp_join) {
-			struct mptcp_sock *owner;
-
 			owner = subflow_req->msk;
 			if (!owner) {
 				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);
@@ -834,7 +850,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	return child;
 
 dispose_child:
-	subflow_drop_ctx(child);
+	mptcp_subflow_drop_ctx(child);
 	tcp_rsk(req)->drop_req = true;
 	inet_csk_prepare_for_destroy_sock(child);
 	tcp_done(child);
@@ -1748,79 +1764,6 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
-void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
-{
-	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
-	struct mptcp_sock *msk, *next, *head = NULL;
-	struct request_sock *req;
-
-	/* build a list of all unaccepted mptcp sockets */
-	spin_lock_bh(&queue->rskq_lock);
-	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
-		struct mptcp_subflow_context *subflow;
-		struct sock *ssk = req->sk;
-		struct mptcp_sock *msk;
-
-		if (!sk_is_mptcp(ssk))
-			continue;
-
-		subflow = mptcp_subflow_ctx(ssk);
-		if (!subflow || !subflow->conn)
-			continue;
-
-		/* skip if already in list */
-		msk = mptcp_sk(subflow->conn);
-		if (msk->dl_next || msk == head)
-			continue;
-
-		msk->dl_next = head;
-		head = msk;
-	}
-	spin_unlock_bh(&queue->rskq_lock);
-	if (!head)
-		return;
-
-	/* can't acquire the msk socket lock under the subflow one,
-	 * or will cause ABBA deadlock
-	 */
-	release_sock(listener_ssk);
-
-	for (msk = head; msk; msk = next) {
-		struct sock *sk = (struct sock *)msk;
-		bool do_cancel_work;
-
-		sock_hold(sk);
-		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
-		next = msk->dl_next;
-		msk->first = NULL;
-		msk->dl_next = NULL;
-
-		do_cancel_work = __mptcp_close(sk, 0);
-		release_sock(sk);
-		if (do_cancel_work) {
-			/* lockdep will report a false positive ABBA deadlock
-			 * between cancel_work_sync and the listener socket.
-			 * The involved locks belong to different sockets WRT
-			 * the existing AB chain.
-			 * Using a per socket key is problematic as key
-			 * deregistration requires process context and must be
-			 * performed at socket disposal time, in atomic
-			 * context.
-			 * Just tell lockdep to consider the listener socket
-			 * released here.
-			 */
-			mutex_release(&listener_sk->sk_lock.dep_map, _RET_IP_);
-			mptcp_cancel_work(sk);
-			mutex_acquire(&listener_sk->sk_lock.dep_map,
-				      SINGLE_DEPTH_NESTING, 0, _RET_IP_);
-		}
-		sock_put(sk);
-	}
-
-	/* we are still under the listener msk socket lock */
-	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
-}
-
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -1877,6 +1820,13 @@ static void subflow_ulp_release(struct sock *ssk)
 		 * when the subflow is still unaccepted
 		 */
 		release = ctx->disposable || list_empty(&ctx->node);
+
+		/* inet_child_forget() does not call sk_state_change(),
+		 * explicitly trigger the socket close machinery
+		 */
+		if (!release && !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW,
+						  &mptcp_sk(sk)->flags))
+			mptcp_schedule_work(sk);
 		sock_put(sk);
 	}
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index b8ad6ae282c0..baeae5e5c8f0 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -28,8 +28,8 @@
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
-#define MIRRED_RECURSION_LIMIT    4
-static DEFINE_PER_CPU(unsigned int, mirred_rec_level);
+#define MIRRED_NEST_LIMIT    4
+static DEFINE_PER_CPU(unsigned int, mirred_nest_level);
 
 static bool tcf_mirred_is_act_redirect(int action)
 {
@@ -205,12 +205,19 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
+static bool is_mirred_nested(void)
+{
+	return unlikely(__this_cpu_read(mirred_nest_level) > 1);
+}
+
 static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 {
 	int err;
 
 	if (!want_ingress)
 		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
+	else if (is_mirred_nested())
+		err = netif_rx(skb);
 	else
 		err = netif_receive_skb(skb);
 
@@ -224,7 +231,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	struct sk_buff *skb2 = skb;
 	bool m_mac_header_xmit;
 	struct net_device *dev;
-	unsigned int rec_level;
+	unsigned int nest_level;
 	int retval, err = 0;
 	bool use_reinsert;
 	bool want_ingress;
@@ -235,11 +242,11 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	int mac_len;
 	bool at_nh;
 
-	rec_level = __this_cpu_inc_return(mirred_rec_level);
-	if (unlikely(rec_level > MIRRED_RECURSION_LIMIT)) {
+	nest_level = __this_cpu_inc_return(mirred_nest_level);
+	if (unlikely(nest_level > MIRRED_NEST_LIMIT)) {
 		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
 				     netdev_name(skb->dev));
-		__this_cpu_dec(mirred_rec_level);
+		__this_cpu_dec(mirred_nest_level);
 		return TC_ACT_SHOT;
 	}
 
@@ -308,7 +315,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			err = tcf_mirred_forward(want_ingress, skb);
 			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
-			__this_cpu_dec(mirred_rec_level);
+			__this_cpu_dec(mirred_nest_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
@@ -320,7 +327,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		if (tcf_mirred_is_act_redirect(m_eaction))
 			retval = TC_ACT_SHOT;
 	}
-	__this_cpu_dec(mirred_rec_level);
+	__this_cpu_dec(mirred_nest_level);
 
 	return retval;
 }
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 4681e8e8ad94..02207e852d79 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -150,10 +150,11 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
 
 static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 {
-	u32 npgs_rem, chunk_size = mr->chunk_size, headroom = mr->headroom;
 	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
-	u64 npgs, addr = mr->addr, size = mr->len;
-	unsigned int chunks, chunks_rem;
+	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
+	u64 addr = mr->addr, size = mr->len;
+	u32 chunks_rem, npgs_rem;
+	u64 chunks, npgs;
 	int err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
@@ -188,8 +189,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (npgs > U32_MAX)
 		return -EINVAL;
 
-	chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
-	if (chunks == 0)
+	chunks = div_u64_rem(size, chunk_size, &chunks_rem);
+	if (!chunks || chunks > U32_MAX)
 		return -EINVAL;
 
 	if (!unaligned_chunks && chunks_rem)
@@ -202,7 +203,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->headroom = headroom;
 	umem->chunk_size = chunk_size;
 	umem->chunks = chunks;
-	umem->npgs = (u32)npgs;
+	umem->npgs = npgs;
 	umem->pgs = NULL;
 	umem->user = NULL;
 	umem->flags = mr->flags;
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 2da4404276f0..07a0ef2baacd 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -38,9 +38,12 @@ static void cache_requested_key(struct key *key)
 #ifdef CONFIG_KEYS_REQUEST_CACHE
 	struct task_struct *t = current;
 
-	key_put(t->cached_requested_key);
-	t->cached_requested_key = key_get(key);
-	set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+	/* Do not cache key if it is a kernel thread */
+	if (!(t->flags & PF_KTHREAD)) {
+		key_put(t->cached_requested_key);
+		t->cached_requested_key = key_get(key);
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+	}
 #endif
 }
 
diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 36314753923b..4a69ce702360 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -255,6 +255,20 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "15NBC1011"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A43"),
+		}
+	},
 	{}
 };
 
diff --git a/tools/bootconfig/test-bootconfig.sh b/tools/bootconfig/test-bootconfig.sh
index f68e2e9eef8b..a2c484c243f5 100755
--- a/tools/bootconfig/test-bootconfig.sh
+++ b/tools/bootconfig/test-bootconfig.sh
@@ -87,10 +87,14 @@ xfail grep -i "error" $OUTFILE
 
 echo "Max node number check"
 
-echo -n > $TEMPCONF
-for i in `seq 1 1024` ; do
-   echo "node$i" >> $TEMPCONF
-done
+awk '
+BEGIN {
+  for (i = 0; i < 26; i += 1)
+      printf("%c\n", 65 + i % 26)
+  for (i = 26; i < 8192; i += 1)
+      printf("%c%c%c\n", 65 + i % 26, 65 + (i / 26) % 26, 65 + (i / 26 / 26))
+}
+' > $TEMPCONF
 xpass $BOOTCONF -a $TEMPCONF $INITRD
 
 echo "badnode" >> $TEMPCONF
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 24dd6214394e..d711f4bea98e 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -879,6 +879,34 @@ static struct btf_raw_test raw_tests[] = {
 	.btf_load_err = true,
 	.err_str = "Invalid elem",
 },
+{
+	.descr = "var after datasec, ptr followed by modifier",
+	.raw_types = {
+		/* .bss section */				/* [1] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 2),
+			sizeof(void*)+4),
+		BTF_VAR_SECINFO_ENC(4, 0, sizeof(void*)),
+		BTF_VAR_SECINFO_ENC(6, sizeof(void*), 4),
+		/* int */					/* [2] */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),
+		/* int* */					/* [3] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_PTR, 0, 0), 2),
+		BTF_VAR_ENC(NAME_TBD, 3, 0),			/* [4] */
+		/* const int */					/* [5] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_CONST, 0, 0), 2),
+		BTF_VAR_ENC(NAME_TBD, 5, 0),			/* [6] */
+		BTF_END_RAW,
+	},
+	.str_sec = "\0a\0b\0c\0",
+	.str_sec_size = sizeof("\0a\0b\0c\0"),
+	.map_type = BPF_MAP_TYPE_ARRAY,
+	.map_name = ".bss",
+	.key_size = sizeof(int),
+	.value_size = sizeof(void*)+4,
+	.key_type_id = 0,
+	.value_type_id = 1,
+	.max_entries = 1,
+},
 /* Test member exceeds the size of struct.
  *
  * struct A {
diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index 1e0a62f638fe..919c0dd9fe4b 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -3,7 +3,8 @@
 
 ALL_TESTS="gact_drop_and_ok_test mirred_egress_redirect_test \
 	mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
-	gact_trap_test mirred_egress_to_ingress_test"
+	gact_trap_test mirred_egress_to_ingress_test \
+	mirred_egress_to_ingress_tcp_test"
 NUM_NETIFS=4
 source tc_common.sh
 source lib.sh
@@ -198,6 +199,52 @@ mirred_egress_to_ingress_test()
 	log_test "mirred_egress_to_ingress ($tcflags)"
 }
 
+mirred_egress_to_ingress_tcp_test()
+{
+	local tmpfile=$(mktemp) tmpfile1=$(mktemp)
+
+	RET=0
+	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
+	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
+		$tcflags ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
+			action ct commit nat src addr 192.0.2.2 pipe \
+			action ct clear pipe \
+			action ct commit nat dst addr 192.0.2.1 pipe \
+			action ct clear pipe \
+			action skbedit ptype host pipe \
+			action mirred ingress redirect dev $h1
+	tc filter add dev $h1 protocol ip pref 101 handle 101 egress flower \
+		$tcflags ip_proto icmp \
+			action mirred ingress redirect dev $h1
+	tc filter add dev $h1 protocol ip pref 102 handle 102 ingress flower \
+		ip_proto icmp \
+			action drop
+
+	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1  &
+	local rpid=$!
+	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
+	wait -n $rpid
+	cmp -s $tmpfile $tmpfile1
+	check_err $? "server output check failed"
+
+	$MZ $h1 -c 10 -p 64 -a $h1mac -b $h1mac -A 192.0.2.1 -B 192.0.2.1 \
+		-t icmp "ping,id=42,seq=5" -q
+	tc_check_packets "dev $h1 egress" 101 10
+	check_err $? "didn't mirred redirect ICMP"
+	tc_check_packets "dev $h1 ingress" 102 10
+	check_err $? "didn't drop mirred ICMP"
+	local overlimits=$(tc_rule_stats_get ${h1} 101 egress .overlimits)
+	test ${overlimits} = 10
+	check_err $? "wrong overlimits, expected 10 got ${overlimits}"
+
+	tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
+	tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
+	tc filter del dev $h1 ingress protocol ip pref 102 handle 102 flower
+
+	rm -f $tmpfile $tmpfile1
+	log_test "mirred_egress_to_ingress_tcp ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
diff --git a/tools/testing/selftests/x86/amx.c b/tools/testing/selftests/x86/amx.c
index 625e42901237..d884fd69dd51 100644
--- a/tools/testing/selftests/x86/amx.c
+++ b/tools/testing/selftests/x86/amx.c
@@ -14,8 +14,10 @@
 #include <sys/auxv.h>
 #include <sys/mman.h>
 #include <sys/shm.h>
+#include <sys/ptrace.h>
 #include <sys/syscall.h>
 #include <sys/wait.h>
+#include <sys/uio.h>
 
 #include "../kselftest.h" /* For __cpuid_count() */
 
@@ -583,6 +585,13 @@ static void test_dynamic_state(void)
 	_exit(0);
 }
 
+static inline int __compare_tiledata_state(struct xsave_buffer *xbuf1, struct xsave_buffer *xbuf2)
+{
+	return memcmp(&xbuf1->bytes[xtiledata.xbuf_offset],
+		      &xbuf2->bytes[xtiledata.xbuf_offset],
+		      xtiledata.size);
+}
+
 /*
  * Save current register state and compare it to @xbuf1.'
  *
@@ -599,9 +608,7 @@ static inline bool __validate_tiledata_regs(struct xsave_buffer *xbuf1)
 		fatal_error("failed to allocate XSAVE buffer\n");
 
 	xsave(xbuf2, XFEATURE_MASK_XTILEDATA);
-	ret = memcmp(&xbuf1->bytes[xtiledata.xbuf_offset],
-		     &xbuf2->bytes[xtiledata.xbuf_offset],
-		     xtiledata.size);
+	ret = __compare_tiledata_state(xbuf1, xbuf2);
 
 	free(xbuf2);
 
@@ -826,6 +833,99 @@ static void test_context_switch(void)
 	free(finfo);
 }
 
+/* Ptrace test */
+
+/*
+ * Make sure the ptracee has the expanded kernel buffer on the first
+ * use. Then, initialize the state before performing the state
+ * injection from the ptracer.
+ */
+static inline void ptracee_firstuse_tiledata(void)
+{
+	load_rand_tiledata(stashed_xsave);
+	init_xtiledata();
+}
+
+/*
+ * Ptracer injects the randomized tile data state. It also reads
+ * before and after that, which will execute the kernel's state copy
+ * functions. So, the tester is advised to double-check any emitted
+ * kernel messages.
+ */
+static void ptracer_inject_tiledata(pid_t target)
+{
+	struct xsave_buffer *xbuf;
+	struct iovec iov;
+
+	xbuf = alloc_xbuf();
+	if (!xbuf)
+		fatal_error("unable to allocate XSAVE buffer");
+
+	printf("\tRead the init'ed tiledata via ptrace().\n");
+
+	iov.iov_base = xbuf;
+	iov.iov_len = xbuf_size;
+
+	memset(stashed_xsave, 0, xbuf_size);
+
+	if (ptrace(PTRACE_GETREGSET, target, (uint32_t)NT_X86_XSTATE, &iov))
+		fatal_error("PTRACE_GETREGSET");
+
+	if (!__compare_tiledata_state(stashed_xsave, xbuf))
+		printf("[OK]\tThe init'ed tiledata was read from ptracee.\n");
+	else
+		printf("[FAIL]\tThe init'ed tiledata was not read from ptracee.\n");
+
+	printf("\tInject tiledata via ptrace().\n");
+
+	load_rand_tiledata(xbuf);
+
+	memcpy(&stashed_xsave->bytes[xtiledata.xbuf_offset],
+	       &xbuf->bytes[xtiledata.xbuf_offset],
+	       xtiledata.size);
+
+	if (ptrace(PTRACE_SETREGSET, target, (uint32_t)NT_X86_XSTATE, &iov))
+		fatal_error("PTRACE_SETREGSET");
+
+	if (ptrace(PTRACE_GETREGSET, target, (uint32_t)NT_X86_XSTATE, &iov))
+		fatal_error("PTRACE_GETREGSET");
+
+	if (!__compare_tiledata_state(stashed_xsave, xbuf))
+		printf("[OK]\tTiledata was correctly written to ptracee.\n");
+	else
+		printf("[FAIL]\tTiledata was not correctly written to ptracee.\n");
+}
+
+static void test_ptrace(void)
+{
+	pid_t child;
+	int status;
+
+	child = fork();
+	if (child < 0) {
+		err(1, "fork");
+	} else if (!child) {
+		if (ptrace(PTRACE_TRACEME, 0, NULL, NULL))
+			err(1, "PTRACE_TRACEME");
+
+		ptracee_firstuse_tiledata();
+
+		raise(SIGTRAP);
+		_exit(0);
+	}
+
+	do {
+		wait(&status);
+	} while (WSTOPSIG(status) != SIGTRAP);
+
+	ptracer_inject_tiledata(child);
+
+	ptrace(PTRACE_DETACH, child, NULL, NULL);
+	wait(&status);
+	if (!WIFEXITED(status) || WEXITSTATUS(status))
+		err(1, "ptrace test");
+}
+
 int main(void)
 {
 	/* Check hardware availability at first */
@@ -846,6 +946,8 @@ int main(void)
 	ctxtswtest_config.num_threads = 5;
 	test_context_switch();
 
+	test_ptrace();
+
 	clearhandler(SIGILL);
 	free_stashed_xsave();
 
