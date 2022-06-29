Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E96C55F8AB
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 09:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiF2HRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 03:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbiF2HRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 03:17:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F354B33EBA;
        Wed, 29 Jun 2022 00:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1712A61B6B;
        Wed, 29 Jun 2022 07:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A39C34114;
        Wed, 29 Jun 2022 07:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656487040;
        bh=us17YvMQIV7iZBGcFZ/TKxvDGlnFkFoa0luVEL6lStw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNEYbmsUb+c86nqoQiG8w11AdcX5/0GPuXAXeubMYzyPT7o2V02vFrOA4+8m1hZqJ
         xEY7tjVxD/gEIKPVjx1ATBmDWCskLBg6d53A0m6ua8avbPQHO4cqIsRYhsdTjQHYXX
         o+xywDoTo+K55h9MKl7LCKEBRzb6ioQOMZAoCgWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.18.8
Date:   Wed, 29 Jun 2022 09:17:09 +0200
Message-Id: <165648702822853@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <165648702810072@kroah.com>
References: <165648702810072@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/ABI/testing/sysfs-bus-iio-vf610 b/Documentation/ABI/testing/sysfs-bus-iio-vf610
index 308a6756d3bf..491ead804488 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-vf610
+++ b/Documentation/ABI/testing/sysfs-bus-iio-vf610
@@ -1,4 +1,4 @@
-What:		/sys/bus/iio/devices/iio:deviceX/conversion_mode
+What:		/sys/bus/iio/devices/iio:deviceX/in_conversion_mode
 KernelVersion:	4.2
 Contact:	linux-iio@vger.kernel.org
 Description:
diff --git a/Documentation/devicetree/bindings/usb/generic-ehci.yaml b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
index 8913497624de..cb5da1df8d40 100644
--- a/Documentation/devicetree/bindings/usb/generic-ehci.yaml
+++ b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
@@ -135,7 +135,8 @@ properties:
       Phandle of a companion.
 
   phys:
-    maxItems: 1
+    minItems: 1
+    maxItems: 3
 
   phy-names:
     const: usb
diff --git a/Documentation/devicetree/bindings/usb/generic-ohci.yaml b/Documentation/devicetree/bindings/usb/generic-ohci.yaml
index acbf94fa5f74..d5fd3aa53ed2 100644
--- a/Documentation/devicetree/bindings/usb/generic-ohci.yaml
+++ b/Documentation/devicetree/bindings/usb/generic-ohci.yaml
@@ -102,7 +102,8 @@ properties:
       Overrides the detected port count
 
   phys:
-    maxItems: 1
+    minItems: 1
+    maxItems: 3
 
   phy-names:
     const: usb
diff --git a/Documentation/vm/hwpoison.rst b/Documentation/vm/hwpoison.rst
index c742de1769d1..b9d5253c1305 100644
--- a/Documentation/vm/hwpoison.rst
+++ b/Documentation/vm/hwpoison.rst
@@ -120,7 +120,8 @@ Testing
   unpoison-pfn
 	Software-unpoison page at PFN echoed into this file. This way
 	a page can be reused again.  This only works for Linux
-	injected failures, not for real memory failures.
+	injected failures, not for real memory failures. Once any hardware
+	memory failure happens, this feature is disabled.
 
   Note these injection interfaces are not stable and might change between
   kernel versions
diff --git a/MAINTAINERS b/MAINTAINERS
index f468864fd268..8e6622ed6de6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -427,6 +427,7 @@ ACPI VIOT DRIVER
 M:	Jean-Philippe Brucker <jean-philippe@linaro.org>
 L:	linux-acpi@vger.kernel.org
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 F:	drivers/acpi/viot.c
 F:	include/linux/acpi_viot.h
@@ -960,6 +961,7 @@ AMD IOMMU (AMD-VI)
 M:	Joerg Roedel <joro@8bytes.org>
 R:	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 F:	drivers/iommu/amd/
@@ -5898,6 +5900,7 @@ M:	Christoph Hellwig <hch@lst.de>
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
 R:	Robin Murphy <robin.murphy@arm.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 W:	http://git.infradead.org/users/hch/dma-mapping.git
 T:	git git://git.infradead.org/users/hch/dma-mapping.git
@@ -5910,6 +5913,7 @@ F:	kernel/dma/
 DMA MAPPING BENCHMARK
 M:	Xiang Chen <chenxiang66@hisilicon.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 F:	kernel/dma/map_benchmark.c
 F:	tools/testing/selftests/dma/
 
@@ -7476,6 +7480,7 @@ F:	drivers/gpu/drm/exynos/exynos_dp*
 EXYNOS SYSMMU (IOMMU) driver
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 F:	drivers/iommu/exynos-iommu.c
 
@@ -9875,6 +9880,7 @@ INTEL IOMMU (VT-d)
 M:	David Woodhouse <dwmw2@infradead.org>
 M:	Lu Baolu <baolu.lu@linux.intel.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 F:	drivers/iommu/intel/
@@ -10253,6 +10259,7 @@ IOMMU DRIVERS
 M:	Joerg Roedel <joro@8bytes.org>
 M:	Will Deacon <will@kernel.org>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 F:	Documentation/devicetree/bindings/iommu/
@@ -12369,6 +12376,7 @@ F:	drivers/i2c/busses/i2c-mt65xx.c
 MEDIATEK IOMMU DRIVER
 M:	Yong Wu <yong.wu@mediatek.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	Documentation/devicetree/bindings/iommu/mediatek*
@@ -16354,6 +16362,7 @@ F:	drivers/i2c/busses/i2c-qcom-cci.c
 QUALCOMM IOMMU
 M:	Rob Clark <robdclark@gmail.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
 F:	drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -18939,6 +18948,7 @@ F:	arch/x86/boot/video*
 SWIOTLB SUBSYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 W:	http://git.infradead.org/users/hch/dma-mapping.git
 T:	git git://git.infradead.org/users/hch/dma-mapping.git
@@ -21609,6 +21619,7 @@ M:	Juergen Gross <jgross@suse.com>
 M:	Stefano Stabellini <sstabellini@kernel.org>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
diff --git a/Makefile b/Makefile
index 61d63068553c..6ac3335f65af 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 18
-SUBLEVEL = 7
+SUBLEVEL = 8
 EXTRAVERSION =
 NAME = Superb Owl
 
@@ -1139,7 +1139,7 @@ KBUILD_MODULES := 1
 
 autoksyms_recursive: descend modules.order
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/adjust_autoksyms.sh \
-	  "$(MAKE) -f $(srctree)/Makefile vmlinux"
+	  "$(MAKE) -f $(srctree)/Makefile autoksyms_recursive"
 endif
 
 autoksyms_h := $(if $(CONFIG_TRIM_UNUSED_KSYMS), include/generated/autoksyms.h)
diff --git a/arch/arm/boot/dts/bcm2711-rpi-400.dts b/arch/arm/boot/dts/bcm2711-rpi-400.dts
index f4d2fc20397c..c53d9eb0b802 100644
--- a/arch/arm/boot/dts/bcm2711-rpi-400.dts
+++ b/arch/arm/boot/dts/bcm2711-rpi-400.dts
@@ -28,12 +28,12 @@ gpio-poweroff {
 &expgpio {
 	gpio-line-names = "BT_ON",
 			  "WL_ON",
-			  "",
+			  "PWR_LED_OFF",
 			  "GLOBAL_RESET",
 			  "VDD_SD_IO_SEL",
-			  "CAM_GPIO",
+			  "GLOBAL_SHUTDOWN",
 			  "SD_PWR_ON",
-			  "SD_OC_N";
+			  "SHUTDOWN_REQUEST";
 };
 
 &genet_mdio {
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index d27beb47f9a3..652feff33496 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -762,7 +762,7 @@ reg_pu: regulator-vddpu {
 					regulator-name = "vddpu";
 					regulator-min-microvolt = <725000>;
 					regulator-max-microvolt = <1450000>;
-					regulator-enable-ramp-delay = <150>;
+					regulator-enable-ramp-delay = <380>;
 					anatop-reg-offset = <0x140>;
 					anatop-vol-bit-shift = <9>;
 					anatop-vol-bit-width = <5>;
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 5af6d58666f4..9dd525871adf 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -120,6 +120,7 @@ usbphynop3: usbphynop3 {
 		compatible = "usb-nop-xceiv";
 		clocks = <&clks IMX7D_USB_HSIC_ROOT_CLK>;
 		clock-names = "main_clk";
+		power-domains = <&pgc_hsic_phy>;
 		#phy-cells = <0>;
 	};
 
@@ -1153,7 +1154,6 @@ usbh: usb@30b30000 {
 				compatible = "fsl,imx7d-usb", "fsl,imx27-usb";
 				reg = <0x30b30000 0x200>;
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
-				power-domains = <&pgc_hsic_phy>;
 				clocks = <&clks IMX7D_USB_CTRL_CLK>;
 				fsl,usbphy = <&usbphynop3>;
 				fsl,usbmisc = <&usbmisc3 0>;
diff --git a/arch/arm/kernel/crash_dump.c b/arch/arm/kernel/crash_dump.c
index 53cb92435392..938bd932df9a 100644
--- a/arch/arm/kernel/crash_dump.c
+++ b/arch/arm/kernel/crash_dump.c
@@ -14,22 +14,10 @@
 #include <linux/crash_dump.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/uio.h>
 
-/**
- * copy_oldmem_page() - copy one page from old kernel memory
- * @pfn: page frame number to be copied
- * @buf: buffer where the copied page is placed
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page
- * @userbuf: if set, @buf is int he user address space
- *
- * This function copies one page from old kernel memory into buffer pointed by
- * @buf. If @buf is in userspace, set @userbuf to %1. Returns number of bytes
- * copied or negative error in case of failure.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset,
-			 int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void *vaddr;
 
@@ -40,14 +28,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!vaddr)
 		return -ENOMEM;
 
-	if (userbuf) {
-		if (copy_to_user(buf, vaddr + offset, csize)) {
-			iounmap(vaddr);
-			return -EFAULT;
-		}
-	} else {
-		memcpy(buf, vaddr + offset, csize);
-	}
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 
 	iounmap(vaddr);
 	return csize;
diff --git a/arch/arm/mach-axxia/platsmp.c b/arch/arm/mach-axxia/platsmp.c
index 512943eae30a..2e203626eda5 100644
--- a/arch/arm/mach-axxia/platsmp.c
+++ b/arch/arm/mach-axxia/platsmp.c
@@ -39,6 +39,7 @@ static int axxia_boot_secondary(unsigned int cpu, struct task_struct *idle)
 		return -ENOENT;
 
 	syscon = of_iomap(syscon_np, 0);
+	of_node_put(syscon_np);
 	if (!syscon)
 		return -ENOMEM;
 
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index e4f4b20b83a2..3fc4ec830e3a 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -372,6 +372,7 @@ static void __init cns3xxx_init(void)
 		/* De-Asscer SATA Reset */
 		cns3xxx_pwr_soft_rst(CNS3XXX_PWR_SOFTWARE_RST(SATA));
 	}
+	of_node_put(dn);
 
 	dn = of_find_compatible_node(NULL, NULL, "cavium,cns3420-sdhci");
 	if (of_device_is_available(dn)) {
@@ -385,6 +386,7 @@ static void __init cns3xxx_init(void)
 		cns3xxx_pwr_clk_en(CNS3XXX_PWR_CLK_EN(SDIO));
 		cns3xxx_pwr_soft_rst(CNS3XXX_PWR_SOFTWARE_RST(SDIO));
 	}
+	of_node_put(dn);
 
 	pm_power_off = cns3xxx_power_off;
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 8b48326be9fd..51a247ca4da8 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -149,6 +149,7 @@ static void exynos_map_pmu(void)
 	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
 	if (np)
 		pmu_base_addr = of_iomap(np, 0);
+	of_node_put(np);
 }
 
 static void __init exynos_init_irq(void)
diff --git a/arch/arm64/boot/dts/exynos/exynos7885.dtsi b/arch/arm64/boot/dts/exynos/exynos7885.dtsi
index 3170661f5b67..9c233c56558c 100644
--- a/arch/arm64/boot/dts/exynos/exynos7885.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7885.dtsi
@@ -280,8 +280,8 @@ serial_0: serial@13800000 {
 			interrupts = <GIC_SPI 246 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart0_bus>;
-			clocks = <&cmu_peri CLK_GOUT_UART0_EXT_UCLK>,
-				 <&cmu_peri CLK_GOUT_UART0_PCLK>;
+			clocks = <&cmu_peri CLK_GOUT_UART0_PCLK>,
+				 <&cmu_peri CLK_GOUT_UART0_EXT_UCLK>;
 			clock-names = "uart", "clk_uart_baud0";
 			samsung,uart-fifosize = <64>;
 			status = "disabled";
@@ -293,8 +293,8 @@ serial_1: serial@13810000 {
 			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart1_bus>;
-			clocks = <&cmu_peri CLK_GOUT_UART1_EXT_UCLK>,
-				 <&cmu_peri CLK_GOUT_UART1_PCLK>;
+			clocks = <&cmu_peri CLK_GOUT_UART1_PCLK>,
+				 <&cmu_peri CLK_GOUT_UART1_EXT_UCLK>;
 			clock-names = "uart", "clk_uart_baud0";
 			samsung,uart-fifosize = <256>;
 			status = "disabled";
@@ -306,8 +306,8 @@ serial_2: serial@13820000 {
 			interrupts = <GIC_SPI 279 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart2_bus>;
-			clocks = <&cmu_peri CLK_GOUT_UART2_EXT_UCLK>,
-				 <&cmu_peri CLK_GOUT_UART2_PCLK>;
+			clocks = <&cmu_peri CLK_GOUT_UART2_PCLK>,
+				 <&cmu_peri CLK_GOUT_UART2_EXT_UCLK>;
 			clock-names = "uart", "clk_uart_baud0";
 			samsung,uart-fifosize = <256>;
 			status = "disabled";
diff --git a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
index f64b368c6c37..cdb530597c5e 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -456,13 +456,11 @@ sdhci0: mmc@fa10000 {
 		clock-names = "clk_ahb", "clk_xin";
 		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
-		mmc-hs400-1_8v;
 		ti,trm-icp = <0x2>;
 		ti,otap-del-sel-legacy = <0x0>;
 		ti,otap-del-sel-mmc-hs = <0x0>;
 		ti,otap-del-sel-ddr52 = <0x6>;
 		ti,otap-del-sel-hs200 = <0x7>;
-		ti,otap-del-sel-hs400 = <0x4>;
 	};
 
 	sdhci1: mmc@fa00000 {
diff --git a/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
index be7f39299894..19966f72c5b3 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
@@ -33,7 +33,7 @@ gic500: interrupt-controller@1800000 {
 		ranges;
 		#interrupt-cells = <3>;
 		interrupt-controller;
-		reg = <0x00 0x01800000 0x00 0x200000>, /* GICD */
+		reg = <0x00 0x01800000 0x00 0x100000>, /* GICD */
 		      <0x00 0x01900000 0x00 0x100000>, /* GICR */
 		      <0x00 0x6f000000 0x00 0x2000>,   /* GICC */
 		      <0x00 0x6f010000 0x00 0x1000>,   /* GICH */
diff --git a/arch/arm64/kernel/crash_dump.c b/arch/arm64/kernel/crash_dump.c
index 58303a9ec32c..670e4ce81822 100644
--- a/arch/arm64/kernel/crash_dump.c
+++ b/arch/arm64/kernel/crash_dump.c
@@ -9,25 +9,11 @@
 #include <linux/crash_dump.h>
 #include <linux/errno.h>
 #include <linux/io.h>
-#include <linux/memblock.h>
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <asm/memory.h>
 
-/**
- * copy_oldmem_page() - copy one page from old kernel memory
- * @pfn: page frame number to be copied
- * @buf: buffer where the copied page is placed
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page
- * @userbuf: if set, @buf is in a user address space
- *
- * This function copies one page from old kernel memory into buffer pointed by
- * @buf. If @buf is in userspace, set @userbuf to %1. Returns number of bytes
- * copied or negative error in case of failure.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset,
-			 int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void *vaddr;
 
@@ -38,14 +24,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!vaddr)
 		return -ENOMEM;
 
-	if (userbuf) {
-		if (copy_to_user((char __user *)buf, vaddr + offset, csize)) {
-			memunmap(vaddr);
-			return -EFAULT;
-		}
-	} else {
-		memcpy(buf, vaddr + offset, csize);
-	}
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 
 	memunmap(vaddr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a66d83540c15..f88919a793ad 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2011,11 +2011,11 @@ static int finalize_hyp_mode(void)
 		return 0;
 
 	/*
-	 * Exclude HYP BSS from kmemleak so that it doesn't get peeked
-	 * at, which would end badly once the section is inaccessible.
-	 * None of other sections should ever be introspected.
+	 * Exclude HYP sections from kmemleak so that they don't get peeked
+	 * at, which would end badly once inaccessible.
 	 */
 	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
+	kmemleak_free_part(__va(hyp_mem_base), hyp_mem_size);
 	return pkvm_drop_host_privileges();
 }
 
diff --git a/arch/ia64/kernel/crash_dump.c b/arch/ia64/kernel/crash_dump.c
index 0ed3c3dee4cd..4ef68e2aa757 100644
--- a/arch/ia64/kernel/crash_dump.c
+++ b/arch/ia64/kernel/crash_dump.c
@@ -10,42 +10,18 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/crash_dump.h>
-
+#include <linux/uio.h>
 #include <asm/page.h>
-#include <linux/uaccess.h>
 
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
- *
- * Calling copy_to_user() in atomic context is not desirable. Hence first
- * copying the data to a pre-allocated kernel page and then copying to user
- * space in non-atomic context.
- */
-ssize_t
-copy_oldmem_page(unsigned long pfn, char *buf,
-		size_t csize, unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+		size_t csize, unsigned long offset)
 {
 	void  *vaddr;
 
 	if (!csize)
 		return 0;
 	vaddr = __va(pfn<<PAGE_SHIFT);
-	if (userbuf) {
-		if (copy_to_user(buf, (vaddr + offset), csize)) {
-			return -EFAULT;
-		}
-	} else
-		memcpy(buf, (vaddr + offset), csize);
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 	return csize;
 }
 
diff --git a/arch/mips/kernel/crash_dump.c b/arch/mips/kernel/crash_dump.c
index 2e50f55185a6..6e50f4902409 100644
--- a/arch/mips/kernel/crash_dump.c
+++ b/arch/mips/kernel/crash_dump.c
@@ -1,22 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/highmem.h>
 #include <linux/crash_dump.h>
+#include <linux/uio.h>
 
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void  *vaddr;
 
@@ -24,14 +12,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 		return 0;
 
 	vaddr = kmap_local_pfn(pfn);
-
-	if (!userbuf) {
-		memcpy(buf, vaddr + offset, csize);
-	} else {
-		if (copy_to_user(buf, vaddr + offset, csize))
-			csize = -EFAULT;
-	}
-
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 	kunmap_local(vaddr);
 
 	return csize;
diff --git a/arch/mips/vr41xx/common/icu.c b/arch/mips/vr41xx/common/icu.c
index 7b7f25b4b057..9240bcdbe74e 100644
--- a/arch/mips/vr41xx/common/icu.c
+++ b/arch/mips/vr41xx/common/icu.c
@@ -640,8 +640,6 @@ static int icu_get_irq(unsigned int irq)
 
 	printk(KERN_ERR "spurious ICU interrupt: %04x,%04x\n", pend1, pend2);
 
-	atomic_inc(&irq_err_count);
-
 	return -1;
 }
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index bd22578859d0..f3a2044ee402 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -10,6 +10,7 @@ config PARISC
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_STRICT_KERNEL_RWX
+	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_NO_SG_CHAIN
diff --git a/arch/parisc/include/asm/fb.h b/arch/parisc/include/asm/fb.h
index d63a2acb91f2..55d29c4f716e 100644
--- a/arch/parisc/include/asm/fb.h
+++ b/arch/parisc/include/asm/fb.h
@@ -12,7 +12,7 @@ static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
 }
 
-#if defined(CONFIG_STI_CONSOLE) || defined(CONFIG_FB_STI)
+#if defined(CONFIG_FB_STI)
 int fb_is_primary_device(struct fb_info *info);
 #else
 static inline int fb_is_primary_device(struct fb_info *info)
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 0fd04073d4b6..a20c1c47b780 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -722,7 +722,10 @@ void flush_anon_page(struct vm_area_struct *vma, struct page *page, unsigned lon
 		return;
 
 	if (parisc_requires_coherency()) {
-		flush_user_cache_page(vma, vmaddr);
+		if (vma->vm_flags & VM_SHARED)
+			flush_data_cache();
+		else
+			flush_user_cache_page(vma, vmaddr);
 		return;
 	}
 
diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index 5693e1c67c2b..32b4a97f1b79 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -16,7 +16,7 @@
 #include <asm/kdump.h>
 #include <asm/prom.h>
 #include <asm/firmware.h>
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <asm/rtas.h>
 #include <asm/inst.h>
 
@@ -68,33 +68,8 @@ void __init setup_kdump_trampoline(void)
 }
 #endif /* CONFIG_NONSTATIC_KERNEL */
 
-static size_t copy_oldmem_vaddr(void *vaddr, char *buf, size_t csize,
-                               unsigned long offset, int userbuf)
-{
-	if (userbuf) {
-		if (copy_to_user((char __user *)buf, (vaddr + offset), csize))
-			return -EFAULT;
-	} else
-		memcpy(buf, (vaddr + offset), csize);
-
-	return csize;
-}
-
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *      space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *      otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			size_t csize, unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			size_t csize, unsigned long offset)
 {
 	void  *vaddr;
 	phys_addr_t paddr;
@@ -107,10 +82,10 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 
 	if (memblock_is_region_memory(paddr, csize)) {
 		vaddr = __va(paddr);
-		csize = copy_oldmem_vaddr(vaddr, buf, csize, offset, userbuf);
+		csize = copy_to_iter(vaddr + offset, csize, iter);
 	} else {
 		vaddr = ioremap_cache(paddr, PAGE_SIZE);
-		csize = copy_oldmem_vaddr(vaddr, buf, csize, offset, userbuf);
+		csize = copy_to_iter(vaddr + offset, csize, iter);
 		iounmap(vaddr);
 	}
 
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index a75d20f23dac..9be279469a85 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1857,7 +1857,7 @@ void start_thread(struct pt_regs *regs, unsigned long start, unsigned long sp)
 		tm_reclaim_current(0);
 #endif
 
-	memset(regs->gpr, 0, sizeof(regs->gpr));
+	memset(&regs->gpr[1], 0, sizeof(regs->gpr) - sizeof(regs->gpr[0]));
 	regs->ctr = 0;
 	regs->link = 0;
 	regs->xer = 0;
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 6bc89d9ccf63..276b4eb1435b 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1061,7 +1061,7 @@ static struct rtas_filter rtas_filters[] __ro_after_init = {
 	{ "get-time-of-day", -1, -1, -1, -1, -1 },
 	{ "ibm,get-vpd", -1, 0, -1, 1, 2 },
 	{ "ibm,lpar-perftools", -1, 2, 3, -1, -1 },
-	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },
+	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },		/* Special cased */
 	{ "ibm,read-slot-reset-state", -1, -1, -1, -1, -1 },
 	{ "ibm,scan-log-dump", -1, 0, 1, -1, -1 },
 	{ "ibm,set-dynamic-indicator", -1, 2, -1, -1, -1 },
@@ -1110,6 +1110,15 @@ static bool block_rtas_call(int token, int nargs,
 				size = 1;
 
 			end = base + size - 1;
+
+			/*
+			 * Special case for ibm,platform-dump - NULL buffer
+			 * address is used to indicate end of dump processing
+			 */
+			if (!strcmp(f->name, "ibm,platform-dump") &&
+			    base == 0)
+				return false;
+
 			if (!in_rmo_buf(base, end))
 				goto err;
 		}
diff --git a/arch/powerpc/platforms/microwatt/microwatt.h b/arch/powerpc/platforms/microwatt/microwatt.h
new file mode 100644
index 000000000000..335417e95e66
--- /dev/null
+++ b/arch/powerpc/platforms/microwatt/microwatt.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MICROWATT_H
+#define _MICROWATT_H
+
+void microwatt_rng_init(void);
+
+#endif /* _MICROWATT_H */
diff --git a/arch/powerpc/platforms/microwatt/rng.c b/arch/powerpc/platforms/microwatt/rng.c
index 7bc4d1cbfaf0..8ece87d005c8 100644
--- a/arch/powerpc/platforms/microwatt/rng.c
+++ b/arch/powerpc/platforms/microwatt/rng.c
@@ -11,6 +11,7 @@
 #include <asm/archrandom.h>
 #include <asm/cputable.h>
 #include <asm/machdep.h>
+#include "microwatt.h"
 
 #define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
@@ -29,7 +30,7 @@ static int microwatt_get_random_darn(unsigned long *v)
 	return 1;
 }
 
-static __init int rng_init(void)
+void __init microwatt_rng_init(void)
 {
 	unsigned long val;
 	int i;
@@ -37,12 +38,7 @@ static __init int rng_init(void)
 	for (i = 0; i < 10; i++) {
 		if (microwatt_get_random_darn(&val)) {
 			ppc_md.get_random_seed = microwatt_get_random_darn;
-			return 0;
+			return;
 		}
 	}
-
-	pr_warn("Unable to use DARN for get_random_seed()\n");
-
-	return -EIO;
 }
-machine_subsys_initcall(, rng_init);
diff --git a/arch/powerpc/platforms/microwatt/setup.c b/arch/powerpc/platforms/microwatt/setup.c
index 0b02603bdb74..6b32539395a4 100644
--- a/arch/powerpc/platforms/microwatt/setup.c
+++ b/arch/powerpc/platforms/microwatt/setup.c
@@ -16,6 +16,8 @@
 #include <asm/xics.h>
 #include <asm/udbg.h>
 
+#include "microwatt.h"
+
 static void __init microwatt_init_IRQ(void)
 {
 	xics_init();
@@ -32,10 +34,16 @@ static int __init microwatt_populate(void)
 }
 machine_arch_initcall(microwatt, microwatt_populate);
 
+static void __init microwatt_setup_arch(void)
+{
+	microwatt_rng_init();
+}
+
 define_machine(microwatt) {
 	.name			= "microwatt",
 	.probe			= microwatt_probe,
 	.init_IRQ		= microwatt_init_IRQ,
+	.setup_arch		= microwatt_setup_arch,
 	.progress		= udbg_progress,
 	.calibrate_decr		= generic_calibrate_decr,
 };
diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
index e297bf4abfcb..866efdc103fd 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -42,4 +42,6 @@ ssize_t memcons_copy(struct memcons *mc, char *to, loff_t pos, size_t count);
 u32 __init memcons_get_size(struct memcons *mc);
 struct memcons *__init memcons_init(struct device_node *node, const char *mc_prop_name);
 
+void pnv_rng_init(void);
+
 #endif /* _POWERNV_H */
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index e3d44b36ae98..463c78c52cc5 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -17,6 +17,7 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/smp.h>
+#include "powernv.h"
 
 #define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
@@ -28,7 +29,6 @@ struct powernv_rng {
 
 static DEFINE_PER_CPU(struct powernv_rng *, powernv_rng);
 
-
 int powernv_hwrng_present(void)
 {
 	struct powernv_rng *rng;
@@ -98,9 +98,6 @@ static int __init initialise_darn(void)
 			return 0;
 		}
 	}
-
-	pr_warn("Unable to use DARN for get_random_seed()\n");
-
 	return -EIO;
 }
 
@@ -163,32 +160,55 @@ static __init int rng_create(struct device_node *dn)
 
 	rng_init_per_cpu(rng, dn);
 
-	pr_info_once("Registering arch random hook.\n");
-
 	ppc_md.get_random_seed = powernv_get_random_long;
 
 	return 0;
 }
 
-static __init int rng_init(void)
+static int __init pnv_get_random_long_early(unsigned long *v)
 {
 	struct device_node *dn;
-	int rc;
+
+	if (!slab_is_available())
+		return 0;
+
+	if (cmpxchg(&ppc_md.get_random_seed, pnv_get_random_long_early,
+		    NULL) != pnv_get_random_long_early)
+		return 0;
 
 	for_each_compatible_node(dn, NULL, "ibm,power-rng") {
-		rc = rng_create(dn);
-		if (rc) {
-			pr_err("Failed creating rng for %pOF (%d).\n",
-				dn, rc);
+		if (rng_create(dn))
 			continue;
-		}
-
 		/* Create devices for hwrng driver */
 		of_platform_device_create(dn, NULL, NULL);
 	}
 
-	initialise_darn();
+	if (!ppc_md.get_random_seed)
+		return 0;
+	return ppc_md.get_random_seed(v);
+}
+
+void __init pnv_rng_init(void)
+{
+	struct device_node *dn;
 
+	/* Prefer darn over the rest. */
+	if (!initialise_darn())
+		return;
+
+	dn = of_find_compatible_node(NULL, NULL, "ibm,power-rng");
+	if (dn)
+		ppc_md.get_random_seed = pnv_get_random_long_early;
+
+	of_node_put(dn);
+}
+
+static int __init pnv_rng_late_init(void)
+{
+	unsigned long v;
+	/* In case it wasn't called during init for some other reason. */
+	if (ppc_md.get_random_seed == pnv_get_random_long_early)
+		pnv_get_random_long_early(&v);
 	return 0;
 }
-machine_subsys_initcall(powernv, rng_init);
+machine_subsys_initcall(powernv, pnv_rng_late_init);
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 824c3ad7a0fa..dac545aa0308 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -203,6 +203,8 @@ static void __init pnv_setup_arch(void)
 	pnv_check_guarded_cores();
 
 	/* XXX PMCS */
+
+	pnv_rng_init();
 }
 
 static void __init pnv_init(void)
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index af162aeeae86..3f9b51298aa3 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -121,4 +121,6 @@ void pseries_lpar_read_hblkrm_characteristics(void);
 static inline void pseries_lpar_read_hblkrm_characteristics(void) { }
 #endif
 
+void pseries_rng_init(void);
+
 #endif /* _PSERIES_PSERIES_H */
diff --git a/arch/powerpc/platforms/pseries/rng.c b/arch/powerpc/platforms/pseries/rng.c
index 6268545947b8..6ddfdeaace9e 100644
--- a/arch/powerpc/platforms/pseries/rng.c
+++ b/arch/powerpc/platforms/pseries/rng.c
@@ -10,6 +10,7 @@
 #include <asm/archrandom.h>
 #include <asm/machdep.h>
 #include <asm/plpar_wrappers.h>
+#include "pseries.h"
 
 
 static int pseries_get_random_long(unsigned long *v)
@@ -24,19 +25,13 @@ static int pseries_get_random_long(unsigned long *v)
 	return 0;
 }
 
-static __init int rng_init(void)
+void __init pseries_rng_init(void)
 {
 	struct device_node *dn;
 
 	dn = of_find_compatible_node(NULL, NULL, "ibm,random");
 	if (!dn)
-		return -ENODEV;
-
-	pr_info("Registering arch random hook.\n");
-
+		return;
 	ppc_md.get_random_seed = pseries_get_random_long;
-
 	of_node_put(dn);
-	return 0;
 }
-machine_subsys_initcall(pseries, rng_init);
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 955ff8aa1644..f27735f623ba 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -852,6 +852,8 @@ static void __init pSeries_setup_arch(void)
 
 	if (swiotlb_force == SWIOTLB_FORCE)
 		ppc_swiotlb_enable = 1;
+
+	pseries_rng_init();
 }
 
 static void pseries_panic(char *str)
diff --git a/arch/riscv/kernel/crash_dump.c b/arch/riscv/kernel/crash_dump.c
index 86cc0ada5752..ea2158cee97b 100644
--- a/arch/riscv/kernel/crash_dump.c
+++ b/arch/riscv/kernel/crash_dump.c
@@ -7,22 +7,10 @@
 
 #include <linux/crash_dump.h>
 #include <linux/io.h>
+#include <linux/uio.h>
 
-/**
- * copy_oldmem_page() - copy one page from old kernel memory
- * @pfn: page frame number to be copied
- * @buf: buffer where the copied page is placed
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page
- * @userbuf: if set, @buf is in a user address space
- *
- * This function copies one page from old kernel memory into buffer pointed by
- * @buf. If @buf is in userspace, set @userbuf to %1. Returns number of bytes
- * copied or negative error in case of failure.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset,
-			 int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void *vaddr;
 
@@ -33,13 +21,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!vaddr)
 		return -ENOMEM;
 
-	if (userbuf) {
-		if (copy_to_user((char __user *)buf, vaddr + offset, csize)) {
-			memunmap(vaddr);
-			return -EFAULT;
-		}
-	} else
-		memcpy(buf, vaddr + offset, csize);
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 
 	memunmap(vaddr);
 	return csize;
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index 69819b765250..28124d0fa1d5 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/memblock.h>
 #include <linux/elf.h>
+#include <linux/uio.h>
 #include <asm/asm-offsets.h>
 #include <asm/os_info.h>
 #include <asm/elf.h>
@@ -212,20 +213,30 @@ static int copy_oldmem_user(void __user *dst, unsigned long src, size_t count)
 /*
  * Copy one page from "oldmem"
  */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
-			 unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn, size_t csize,
+			 unsigned long offset)
 {
 	unsigned long src;
 	int rc;
 
+	if (!(iter_is_iovec(iter) || iov_iter_is_kvec(iter)))
+		return -EINVAL;
+	/* Multi-segment iterators are not supported */
+	if (iter->nr_segs > 1)
+		return -EINVAL;
 	if (!csize)
 		return 0;
 	src = pfn_to_phys(pfn) + offset;
-	if (userbuf)
-		rc = copy_oldmem_user((void __force __user *) buf, src, csize);
+
+	/* XXX: pass the iov_iter down to a common function */
+	if (iter_is_iovec(iter))
+		rc = copy_oldmem_user(iter->iov->iov_base, src, csize);
 	else
-		rc = copy_oldmem_kernel((void *) buf, src, csize);
-	return rc;
+		rc = copy_oldmem_kernel(iter->kvec->iov_base, src, csize);
+	if (rc < 0)
+		return rc;
+	iov_iter_advance(iter, csize);
+	return csize;
 }
 
 /*
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 483ab5e10164..f7dd3c849e68 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -516,6 +516,26 @@ static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 	return err;
 }
 
+/* Events CPU_CYLCES and INSTRUCTIONS can be submitted with two different
+ * attribute::type values:
+ * - PERF_TYPE_HARDWARE:
+ * - pmu->type:
+ * Handle both type of invocations identical. They address the same hardware.
+ * The result is different when event modifiers exclude_kernel and/or
+ * exclude_user are also set.
+ */
+static int cpumf_pmu_event_type(struct perf_event *event)
+{
+	u64 ev = event->attr.config;
+
+	if (cpumf_generic_events_basic[PERF_COUNT_HW_CPU_CYCLES] == ev ||
+	    cpumf_generic_events_basic[PERF_COUNT_HW_INSTRUCTIONS] == ev ||
+	    cpumf_generic_events_user[PERF_COUNT_HW_CPU_CYCLES] == ev ||
+	    cpumf_generic_events_user[PERF_COUNT_HW_INSTRUCTIONS] == ev)
+		return PERF_TYPE_HARDWARE;
+	return PERF_TYPE_RAW;
+}
+
 static int cpumf_pmu_event_init(struct perf_event *event)
 {
 	unsigned int type = event->attr.type;
@@ -525,7 +545,7 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 		err = __hw_perf_event_init(event, type);
 	else if (event->pmu->type == type)
 		/* Registered as unknown PMU */
-		err = __hw_perf_event_init(event, PERF_TYPE_RAW);
+		err = __hw_perf_event_init(event, cpumf_pmu_event_type(event));
 	else
 		return -ENOENT;
 
diff --git a/arch/sh/kernel/crash_dump.c b/arch/sh/kernel/crash_dump.c
index 5b41b59698c1..19ce6a950aac 100644
--- a/arch/sh/kernel/crash_dump.c
+++ b/arch/sh/kernel/crash_dump.c
@@ -8,23 +8,11 @@
 #include <linux/errno.h>
 #include <linux/crash_dump.h>
 #include <linux/io.h>
+#include <linux/uio.h>
 #include <linux/uaccess.h>
 
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-                               size_t csize, unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void  __iomem *vaddr;
 
@@ -32,15 +20,8 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 		return 0;
 
 	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
-
-	if (userbuf) {
-		if (copy_to_user((void __user *)buf, (vaddr + offset), csize)) {
-			iounmap(vaddr);
-			return -EFAULT;
-		}
-	} else
-	memcpy(buf, (vaddr + offset), csize);
-
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 	iounmap(vaddr);
+
 	return csize;
 }
diff --git a/arch/x86/kernel/crash_dump_32.c b/arch/x86/kernel/crash_dump_32.c
index 5fcac46aaf6b..5f4ae5476e19 100644
--- a/arch/x86/kernel/crash_dump_32.c
+++ b/arch/x86/kernel/crash_dump_32.c
@@ -10,8 +10,7 @@
 #include <linux/errno.h>
 #include <linux/highmem.h>
 #include <linux/crash_dump.h>
-
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 
 static inline bool is_crashed_pfn_valid(unsigned long pfn)
 {
@@ -29,21 +28,8 @@ static inline bool is_crashed_pfn_valid(unsigned long pfn)
 #endif
 }
 
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there might be no pte mapped
- * in the current kernel.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
-			 unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn, size_t csize,
+			 unsigned long offset)
 {
 	void  *vaddr;
 
@@ -54,14 +40,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
 		return -EFAULT;
 
 	vaddr = kmap_local_pfn(pfn);
-
-	if (!userbuf) {
-		memcpy(buf, vaddr + offset, csize);
-	} else {
-		if (copy_to_user(buf, vaddr + offset, csize))
-			csize = -EFAULT;
-	}
-
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 	kunmap_local(vaddr);
 
 	return csize;
diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index 97529552dd24..94fe4aff9694 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -8,12 +8,12 @@
 
 #include <linux/errno.h>
 #include <linux/crash_dump.h>
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <linux/io.h>
 #include <linux/cc_platform.h>
 
-static ssize_t __copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
-				  unsigned long offset, int userbuf,
+static ssize_t __copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+				  size_t csize, unsigned long offset,
 				  bool encrypted)
 {
 	void  *vaddr;
@@ -29,46 +29,27 @@ static ssize_t __copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
 	if (!vaddr)
 		return -ENOMEM;
 
-	if (userbuf) {
-		if (copy_to_user((void __user *)buf, vaddr + offset, csize)) {
-			iounmap((void __iomem *)vaddr);
-			return -EFAULT;
-		}
-	} else
-		memcpy(buf, vaddr + offset, csize);
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 
 	iounmap((void __iomem *)vaddr);
 	return csize;
 }
 
-/**
- * copy_oldmem_page - copy one page of memory
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from the old kernel's memory. For this page, there is no pte
- * mapped in the current kernel. We stitch up a pte, similar to kmap_atomic.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
-			 unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn, size_t csize,
+			 unsigned long offset)
 {
-	return __copy_oldmem_page(pfn, buf, csize, offset, userbuf, false);
+	return __copy_oldmem_page(iter, pfn, csize, offset, false);
 }
 
-/**
+/*
  * copy_oldmem_page_encrypted - same as copy_oldmem_page() above but ioremap the
  * memory with the encryption mask set to accommodate kdump on SME-enabled
  * machines.
  */
-ssize_t copy_oldmem_page_encrypted(unsigned long pfn, char *buf, size_t csize,
-				   unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page_encrypted(struct iov_iter *iter, unsigned long pfn,
+				   size_t csize, unsigned long offset)
 {
-	return __copy_oldmem_page(pfn, buf, csize, offset, userbuf, true);
+	return __copy_oldmem_page(iter, pfn, csize, offset, true);
 }
 
 ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4b7d490c0b63..76e9e6eb71d6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1665,19 +1665,24 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
 	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
 	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
+	struct kvm_vcpu *dst_vcpu, *src_vcpu;
+	struct vcpu_svm *dst_svm, *src_svm;
 	struct kvm_sev_info *mirror;
+	unsigned long i;
 
 	dst->active = true;
 	dst->asid = src->asid;
 	dst->handle = src->handle;
 	dst->pages_locked = src->pages_locked;
 	dst->enc_context_owner = src->enc_context_owner;
+	dst->es_active = src->es_active;
 
 	src->asid = 0;
 	src->active = false;
 	src->handle = 0;
 	src->pages_locked = 0;
 	src->enc_context_owner = NULL;
+	src->es_active = false;
 
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 
@@ -1704,26 +1709,21 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 		list_del(&src->mirror_entry);
 		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
 	}
-}
 
-static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
-{
-	unsigned long i;
-	struct kvm_vcpu *dst_vcpu, *src_vcpu;
-	struct vcpu_svm *dst_svm, *src_svm;
+	kvm_for_each_vcpu(i, dst_vcpu, dst_kvm) {
+		dst_svm = to_svm(dst_vcpu);
 
-	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
-		return -EINVAL;
+		sev_init_vmcb(dst_svm);
 
-	kvm_for_each_vcpu(i, src_vcpu, src) {
-		if (!src_vcpu->arch.guest_state_protected)
-			return -EINVAL;
-	}
+		if (!dst->es_active)
+			continue;
 
-	kvm_for_each_vcpu(i, src_vcpu, src) {
+		/*
+		 * Note, the source is not required to have the same number of
+		 * vCPUs as the destination when migrating a vanilla SEV VM.
+		 */
+		src_vcpu = kvm_get_vcpu(dst_kvm, i);
 		src_svm = to_svm(src_vcpu);
-		dst_vcpu = kvm_get_vcpu(dst, i);
-		dst_svm = to_svm(dst_vcpu);
 
 		/*
 		 * Transfer VMSA and GHCB state to the destination.  Nullify and
@@ -1740,8 +1740,23 @@ static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
 		src_svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 		src_vcpu->arch.guest_state_protected = false;
 	}
-	to_kvm_svm(src)->sev_info.es_active = false;
-	to_kvm_svm(dst)->sev_info.es_active = true;
+}
+
+static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
+{
+	struct kvm_vcpu *src_vcpu;
+	unsigned long i;
+
+	if (!sev_es_guest(src))
+		return 0;
+
+	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
+		return -EINVAL;
+
+	kvm_for_each_vcpu(i, src_vcpu, src) {
+		if (!src_vcpu->arch.guest_state_protected)
+			return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1789,11 +1804,9 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_dst_vcpu;
 
-	if (sev_es_guest(source_kvm)) {
-		ret = sev_es_migrate_from(kvm, source_kvm);
-		if (ret)
-			goto out_source_vcpu;
-	}
+	ret = sev_check_source_vcpus(kvm, source_kvm);
+	if (ret)
+		goto out_source_vcpu;
 
 	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
@@ -2910,7 +2923,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    count, in);
 }
 
-void sev_es_init_vmcb(struct vcpu_svm *svm)
+static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
@@ -2955,6 +2968,15 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
+void sev_init_vmcb(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
+	clr_exception_intercept(svm, UD_VECTOR);
+
+	if (sev_es_guest(svm->vcpu.kvm))
+		sev_es_init_vmcb(svm);
+}
+
 void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0c0a09b43b10..6bfb0b0e66bd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1125,15 +1125,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
-	if (sev_guest(vcpu->kvm)) {
-		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, UD_VECTOR);
-
-		if (sev_es_guest(vcpu->kvm)) {
-			/* Perform SEV-ES specific VMCB updates */
-			sev_es_init_vmcb(svm);
-		}
-	}
+	if (sev_guest(vcpu->kvm))
+		sev_init_vmcb(svm);
 
 	svm_hv_init_vmcb(svm->vmcb);
 	init_vmcb_after_set_cpuid(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 34babf9185fe..8ec8fb58b924 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -616,10 +616,10 @@ void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
+void sev_init_vmcb(struct vcpu_svm *svm);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct vmcb_save_area *hostsa);
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 16b6efacf7c6..4c71fa04e784 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1415,8 +1415,9 @@ st:			if (is_imm8(insn->off))
 		case BPF_JMP | BPF_CALL:
 			func = (u8 *) __bpf_call_base + imm32;
 			if (tail_call_reachable) {
+				/* mov rax, qword ptr [rbp - rounded_stack_depth - 8] */
 				EMIT3_off32(0x48, 0x8B, 0x85,
-					    -(bpf_prog->aux->stack_depth + 8));
+					    -round_up(bpf_prog->aux->stack_depth, 8) - 8);
 				if (!imm32 || emit_call(&prog, func, image + addrs[i - 1] + 7))
 					return -EINVAL;
 			} else {
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index e8ceb1528608..16b8a6273772 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -154,6 +154,7 @@ static void __init calibrate_ccount(void)
 	cpu = of_find_compatible_node(NULL, NULL, "cdns,xtensa-cpu");
 	if (cpu) {
 		clk = of_clk_get(cpu, 0);
+		of_node_put(cpu);
 		if (!IS_ERR(clk)) {
 			ccount_freq = clk_get_rate(clk);
 			return;
diff --git a/arch/xtensa/platforms/xtfpga/setup.c b/arch/xtensa/platforms/xtfpga/setup.c
index 538e6748e85a..c79c1d09ea86 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -133,6 +133,7 @@ static int __init machine_setup(void)
 
 	if ((eth = of_find_compatible_node(eth, NULL, "opencores,ethoc")))
 		update_local_mac(eth);
+	of_node_put(eth);
 	return 0;
 }
 arch_initcall(machine_setup);
diff --git a/block/blk-core.c b/block/blk-core.c
index 84f7b7884d07..a7329475aba2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -322,19 +322,6 @@ void blk_cleanup_queue(struct request_queue *q)
 		blk_mq_exit_queue(q);
 	}
 
-	/*
-	 * In theory, request pool of sched_tags belongs to request queue.
-	 * However, the current implementation requires tag_set for freeing
-	 * requests, so free the pool now.
-	 *
-	 * Queue has become frozen, there can't be any in-queue requests, so
-	 * it is safe to free requests now.
-	 */
-	mutex_lock(&q->sysfs_lock);
-	if (q->elevator)
-		blk_mq_sched_free_rqs(q);
-	mutex_unlock(&q->sysfs_lock);
-
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 631fb87b4976..37caa73bff89 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2777,15 +2777,20 @@ static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
 		return NULL;
 	}
 
-	rq_qos_throttle(q, *bio);
-
 	if (blk_mq_get_hctx_type((*bio)->bi_opf) != rq->mq_hctx->type)
 		return NULL;
 	if (op_is_flush(rq->cmd_flags) != op_is_flush((*bio)->bi_opf))
 		return NULL;
 
-	rq->cmd_flags = (*bio)->bi_opf;
+	/*
+	 * If any qos ->throttle() end up blocking, we will have flushed the
+	 * plug and hence killed the cached_rq list as well. Pop this entry
+	 * before we throttle.
+	 */
 	plug->cached_rq = rq_list_next(rq);
+	rq_qos_throttle(q, *bio);
+
+	rq->cmd_flags = (*bio)->bi_opf;
 	INIT_LIST_HEAD(&rq->queuelist);
 	return rq;
 }
diff --git a/block/genhd.c b/block/genhd.c
index 3008ec213654..13daac1a9aef 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -652,6 +652,17 @@ void del_gendisk(struct gendisk *disk)
 
 	blk_sync_queue(q);
 	blk_flush_integrity();
+	blk_mq_cancel_work_sync(q);
+
+	blk_mq_quiesce_queue(q);
+	if (q->elevator) {
+		mutex_lock(&q->sysfs_lock);
+		elevator_exit(q);
+		mutex_unlock(&q->sysfs_lock);
+	}
+	rq_qos_exit(q);
+	blk_mq_unquiesce_queue(q);
+
 	/*
 	 * Allow using passthrough request again after the queue is torn down.
 	 */
@@ -1120,31 +1131,6 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
-static void disk_release_mq(struct request_queue *q)
-{
-	blk_mq_cancel_work_sync(q);
-
-	/*
-	 * There can't be any non non-passthrough bios in flight here, but
-	 * requests stay around longer, including passthrough ones so we
-	 * still need to freeze the queue here.
-	 */
-	blk_mq_freeze_queue(q);
-
-	/*
-	 * Since the I/O scheduler exit code may access cgroup information,
-	 * perform I/O scheduler exit before disassociating from the block
-	 * cgroup controller.
-	 */
-	if (q->elevator) {
-		mutex_lock(&q->sysfs_lock);
-		elevator_exit(q);
-		mutex_unlock(&q->sysfs_lock);
-	}
-	rq_qos_exit(q);
-	__blk_mq_unfreeze_queue(q, true);
-}
-
 /**
  * disk_release - releases all allocated resources of the gendisk
  * @dev: the device representing this disk
@@ -1166,9 +1152,6 @@ static void disk_release(struct device *dev)
 	might_sleep();
 	WARN_ON_ONCE(disk_live(disk));
 
-	if (queue_is_mq(disk->queue))
-		disk_release_mq(disk->queue);
-
 	blkcg_exit_queue(disk->queue);
 
 	disk_release_events(disk);
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 084d67fd55cc..bc60c9cd3230 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -558,7 +558,7 @@ static ssize_t hard_offline_page_store(struct device *dev,
 	if (kstrtoull(buf, 0, &pfn) < 0)
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
-	ret = memory_failure(pfn, 0);
+	ret = memory_failure(pfn, MF_SW_SIMULATED);
 	if (ret == -EOPNOTSUPP)
 		ret = 0;
 	return ret ? ret : count;
diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 400c7412a7dc..a6db605707b0 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -252,6 +252,7 @@ static void regmap_irq_enable(struct irq_data *data)
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
 	struct regmap *map = d->map;
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
+	unsigned int reg = irq_data->reg_offset / map->reg_stride;
 	unsigned int mask, type;
 
 	type = irq_data->type.type_falling_val | irq_data->type.type_rising_val;
@@ -268,14 +269,14 @@ static void regmap_irq_enable(struct irq_data *data)
 	 * at the corresponding offset in regmap_irq_set_type().
 	 */
 	if (d->chip->type_in_mask && type)
-		mask = d->type_buf[irq_data->reg_offset / map->reg_stride];
+		mask = d->type_buf[reg] & irq_data->mask;
 	else
 		mask = irq_data->mask;
 
 	if (d->chip->clear_on_unmask)
 		d->clear_status = true;
 
-	d->mask_buf[irq_data->reg_offset / map->reg_stride] &= ~mask;
+	d->mask_buf[reg] &= ~mask;
 }
 
 static void regmap_irq_disable(struct irq_data *data)
@@ -386,6 +387,7 @@ static inline int read_sub_irq_data(struct regmap_irq_chip_data *data,
 		subreg = &chip->sub_reg_offsets[b];
 		for (i = 0; i < subreg->num_regs; i++) {
 			unsigned int offset = subreg->offset[i];
+			unsigned int index = offset / map->reg_stride;
 
 			if (chip->not_fixed_stride)
 				ret = regmap_read(map,
@@ -394,7 +396,7 @@ static inline int read_sub_irq_data(struct regmap_irq_chip_data *data,
 			else
 				ret = regmap_read(map,
 						chip->status_base + offset,
-						&data->status_buf[offset]);
+						&data->status_buf[index]);
 
 			if (ret)
 				break;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 003056d4f7f5..966a6bf4c162 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2137,9 +2137,11 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 
 	/* No more blkif_request(). */
-	blk_mq_stop_hw_queues(info->rq);
-	blk_mark_disk_dead(info->gd);
-	set_capacity(info->gd, 0);
+	if (info->rq && info->gd) {
+		blk_mq_stop_hw_queues(info->rq);
+		blk_mark_disk_dead(info->gd);
+		set_capacity(info->gd, 0);
+	}
 
 	for_each_rinfo(info, rinfo, i) {
 		/* No more gnttab callback work. */
@@ -2480,16 +2482,19 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 
 	dev_dbg(&xbdev->dev, "%s removed", xbdev->nodename);
 
-	del_gendisk(info->gd);
+	if (info->gd)
+		del_gendisk(info->gd);
 
 	mutex_lock(&blkfront_mutex);
 	list_del(&info->info_list);
 	mutex_unlock(&blkfront_mutex);
 
 	blkif_free(info, 0);
-	xlbd_release_minors(info->gd->first_minor, info->gd->minors);
-	blk_cleanup_disk(info->gd);
-	blk_mq_free_tag_set(&info->tag_set);
+	if (info->gd) {
+		xlbd_release_minors(info->gd->first_minor, info->gd->minors);
+		blk_cleanup_disk(info->gd);
+		blk_mq_free_tag_set(&info->tag_set);
+	}
 
 	kfree(info);
 	return 0;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1f3072ee6b7c..dd52e948a9a4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -87,7 +87,7 @@ static RAW_NOTIFIER_HEAD(random_ready_chain);
 
 /* Control how we warn userspace. */
 static struct ratelimit_state urandom_warning =
-	RATELIMIT_STATE_INIT("warn_urandom_randomness", HZ, 3);
+	RATELIMIT_STATE_INIT_FLAGS("urandom_warning", HZ, 3, RATELIMIT_MSG_ON_RELEASE);
 static int ratelimit_disable __read_mostly =
 	IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM);
 module_param_named(ratelimit_disable, ratelimit_disable, int, 0644);
@@ -451,7 +451,7 @@ static ssize_t get_random_bytes_user(struct iov_iter *iter)
 
 	/*
 	 * Immediately overwrite the ChaCha key at index 4 with random
-	 * bytes, in case userspace causes copy_to_user() below to sleep
+	 * bytes, in case userspace causes copy_to_iter() below to sleep
 	 * forever, so that we still retain forward secrecy in that case.
 	 */
 	crng_make_state(chacha_state, (u8 *)&chacha_state[4], CHACHA_KEY_SIZE);
@@ -1038,7 +1038,7 @@ void add_interrupt_randomness(int irq)
 	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (new_count < 64 && !time_is_before_jiffies(fast_pool->last + HZ))
+	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
 	if (unlikely(!fast_pool->mix.func))
diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index e7330684d3b8..9631f2fd2faf 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -32,8 +32,11 @@ static vm_fault_t udmabuf_vm_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct udmabuf *ubuf = vma->vm_private_data;
+	pgoff_t pgoff = vmf->pgoff;
 
-	vmf->page = ubuf->pages[vmf->pgoff];
+	if (pgoff >= ubuf->pagecount)
+		return VM_FAULT_SIGBUS;
+	vmf->page = ubuf->pages[pgoff];
 	get_page(vmf->page);
 	return 0;
 }
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index 98cd715ccc33..8d09b619c166 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -217,8 +217,6 @@ static int giu_get_irq(unsigned int irq)
 	printk(KERN_ERR "spurious GIU interrupt: %04x(%04x),%04x(%04x)\n",
 	       maskl, pendl, maskh, pendh);
 
-	atomic_inc(&irq_err_count);
-
 	return -EINVAL;
 }
 
diff --git a/drivers/gpio/gpio-winbond.c b/drivers/gpio/gpio-winbond.c
index 7f8f5b02e31d..4b61d975cc0e 100644
--- a/drivers/gpio/gpio-winbond.c
+++ b/drivers/gpio/gpio-winbond.c
@@ -385,12 +385,13 @@ static int winbond_gpio_get(struct gpio_chip *gc, unsigned int offset)
 	unsigned long *base = gpiochip_get_data(gc);
 	const struct winbond_gpio_info *info;
 	bool val;
+	int ret;
 
 	winbond_gpio_get_info(&offset, &info);
 
-	val = winbond_sio_enter(*base);
-	if (val)
-		return val;
+	ret = winbond_sio_enter(*base);
+	if (ret)
+		return ret;
 
 	winbond_sio_select_logical(*base, info->dev);
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 95b5b5bfa1ff..71b15e2df235 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -944,7 +944,7 @@ static void override_lane_settings(const struct link_training_settings *lt_setti
 
 		return;
 
-	for (lane = 1; lane < LANE_COUNT_DP_MAX; lane++) {
+	for (lane = 0; lane < LANE_COUNT_DP_MAX; lane++) {
 		if (lt_settings->voltage_swing)
 			lane_settings[lane].VOLTAGE_SWING = *lt_settings->voltage_swing;
 		if (lt_settings->pre_emphasis)
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 248602c15f3a..6007b847b54f 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1771,29 +1771,9 @@ void dce110_enable_accelerated_mode(struct dc *dc, struct dc_state *context)
 				break;
 			}
 		}
-
-		/*
-		 * TO-DO: So far the code logic below only addresses single eDP case.
-		 * For dual eDP case, there are a few things that need to be
-		 * implemented first:
-		 *
-		 * 1. Change the fastboot logic above, so eDP link[0 or 1]'s
-		 * stream[0 or 1] will all be checked.
-		 *
-		 * 2. Change keep_edp_vdd_on to an array, and maintain keep_edp_vdd_on
-		 * for each eDP.
-		 *
-		 * Once above 2 things are completed, we can then change the logic below
-		 * correspondingly, so dual eDP case will be fully covered.
-		 */
-
-		// We are trying to enable eDP, don't power down VDD if eDP stream is existing
-		if ((edp_stream_num == 1 && edp_streams[0] != NULL) || can_apply_edp_fast_boot) {
+		// We are trying to enable eDP, don't power down VDD
+		if (can_apply_edp_fast_boot)
 			keep_edp_vdd_on = true;
-			DC_LOG_EVENT_LINK_TRAINING("Keep eDP Vdd on\n");
-		} else {
-			DC_LOG_EVENT_LINK_TRAINING("No eDP stream enabled, turn eDP Vdd off\n");
-		}
 	}
 
 	// Check seamless boot support
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c
index 970b65efeac1..eaa7032f0f1a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c
@@ -212,6 +212,9 @@ static void dpp2_cnv_setup (
 		break;
 	}
 
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	if (is_2bit == 1 && alpha_2bit_lut != NULL) {
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT0, alpha_2bit_lut->lut0);
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT1, alpha_2bit_lut->lut1);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c
index 8b6505b7dca8..f50ab961bc17 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c
@@ -153,6 +153,9 @@ static void dpp201_cnv_setup(
 		break;
 	}
 
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	if (is_2bit == 1 && alpha_2bit_lut != NULL) {
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT0, alpha_2bit_lut->lut0);
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT1, alpha_2bit_lut->lut1);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
index ab3918c0a15b..0dcc07531643 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
@@ -294,6 +294,9 @@ static void dpp3_cnv_setup (
 		break;
 	}
 
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	if (is_2bit == 1 && alpha_2bit_lut != NULL) {
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT0, alpha_2bit_lut->lut0);
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT1, alpha_2bit_lut->lut1);
diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
index 569903d47aea..a76f037001ae 100644
--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -2437,7 +2437,7 @@ static void icl_wrpll_params_populate(struct skl_wrpll_params *params,
 }
 
 /*
- * Display WA #22010492432: ehl, tgl, adl-p
+ * Display WA #22010492432: ehl, tgl, adl-s, adl-p
  * Program half of the nominal DCO divider fraction value.
  */
 static bool
@@ -2445,7 +2445,7 @@ ehl_combo_pll_div_frac_wa_needed(struct drm_i915_private *i915)
 {
 	return ((IS_PLATFORM(i915, INTEL_ELKHARTLAKE) &&
 		 IS_JSL_EHL_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||
-		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_P(i915)) &&
+		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_S(i915) || IS_ALDERLAKE_P(i915)) &&
 		 i915->dpll.ref_clks.nssc == 38400;
 }
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 1219f71629a5..1ced7b108f2c 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -1002,7 +1002,8 @@ void adreno_gpu_cleanup(struct adreno_gpu *adreno_gpu)
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
-	pm_runtime_disable(&priv->gpu_pdev->dev);
+	if (pm_runtime_enabled(&priv->gpu_pdev->dev))
+		pm_runtime_disable(&priv->gpu_pdev->dev);
 
 	msm_gpu_cleanup(&adreno_gpu->base);
 }
diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 3cf476c55158..d92193db7eb2 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -217,6 +217,7 @@ static int mdp4_modeset_init_intf(struct mdp4_kms *mdp4_kms,
 		encoder = mdp4_lcdc_encoder_init(dev, panel_node);
 		if (IS_ERR(encoder)) {
 			DRM_DEV_ERROR(dev->dev, "failed to construct LCDC encoder\n");
+			of_node_put(panel_node);
 			return PTR_ERR(encoder);
 		}
 
@@ -226,6 +227,7 @@ static int mdp4_modeset_init_intf(struct mdp4_kms *mdp4_kms,
 		connector = mdp4_lvds_connector_init(dev, panel_node, encoder);
 		if (IS_ERR(connector)) {
 			DRM_DEV_ERROR(dev->dev, "failed to initialize LVDS connector\n");
+			of_node_put(panel_node);
 			return PTR_ERR(connector);
 		}
 
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index de1974916ad2..499d0bbc442c 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1523,6 +1523,8 @@ static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 	return ret;
 }
 
+static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl);
+
 static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 {
 	int ret = 0;
@@ -1545,7 +1547,7 @@ static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 
 	ret = dp_ctrl_on_link(&ctrl->dp_ctrl);
 	if (!ret)
-		ret = dp_ctrl_on_stream(&ctrl->dp_ctrl);
+		ret = dp_ctrl_on_stream_phy_test_report(&ctrl->dp_ctrl);
 	else
 		DRM_ERROR("failed to enable DP link controller\n");
 
@@ -1800,7 +1802,27 @@ static int dp_ctrl_link_retrain(struct dp_ctrl_private *ctrl)
 	return dp_ctrl_setup_main_link(ctrl, &training_step);
 }
 
-int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
+static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl)
+{
+	int ret;
+	struct dp_ctrl_private *ctrl;
+
+	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
+
+	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
+
+	ret = dp_ctrl_enable_stream_clocks(ctrl);
+	if (ret) {
+		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
+		return ret;
+	}
+
+	dp_ctrl_send_phy_test_pattern(ctrl);
+
+	return 0;
+}
+
+int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl, bool force_link_train)
 {
 	int ret = 0;
 	bool mainlink_ready = false;
@@ -1831,12 +1853,7 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 		goto end;
 	}
 
-	if (ctrl->link->sink_request & DP_TEST_LINK_PHY_TEST_PATTERN) {
-		dp_ctrl_send_phy_test_pattern(ctrl);
-		return 0;
-	}
-
-	if (!dp_ctrl_channel_eq_ok(ctrl))
+	if (force_link_train || !dp_ctrl_channel_eq_ok(ctrl))
 		dp_ctrl_link_retrain(ctrl);
 
 	/* stop txing train pattern to end link training */
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.h b/drivers/gpu/drm/msm/dp/dp_ctrl.h
index 2433edbc70a6..dcc7af21a5f0 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.h
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.h
@@ -20,7 +20,7 @@ struct dp_ctrl {
 };
 
 int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl);
-int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl);
+int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl, bool force_link_train);
 int dp_ctrl_off_link_stream(struct dp_ctrl *dp_ctrl);
 int dp_ctrl_off(struct dp_ctrl *dp_ctrl);
 void dp_ctrl_push_idle(struct dp_ctrl *dp_ctrl);
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 8deb92bddfde..12270bd3cff9 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -308,7 +308,8 @@ static void dp_display_unbind(struct device *dev, struct device *master,
 	struct msm_drm_private *priv = dev_get_drvdata(master);
 
 	/* disable all HPD interrupts */
-	dp_catalog_hpd_config_intr(dp->catalog, DP_DP_HPD_INT_MASK, false);
+	if (dp->core_initialized)
+		dp_catalog_hpd_config_intr(dp->catalog, DP_DP_HPD_INT_MASK, false);
 
 	kthread_stop(dp->ev_tsk);
 
@@ -902,7 +903,7 @@ static int dp_display_enable(struct dp_display_private *dp, u32 data)
 		return 0;
 	}
 
-	rc = dp_ctrl_on_stream(dp->ctrl);
+	rc = dp_ctrl_on_stream(dp->ctrl, data);
 	if (!rc)
 		dp_display->power_on = true;
 
@@ -1589,6 +1590,7 @@ int msm_dp_display_enable(struct msm_dp *dp, struct drm_encoder *encoder)
 	int rc = 0;
 	struct dp_display_private *dp_display;
 	u32 state;
+	bool force_link_train = false;
 
 	dp_display = container_of(dp, struct dp_display_private, dp_display);
 	if (!dp_display->dp_mode.drm_mode.clock) {
@@ -1617,10 +1619,12 @@ int msm_dp_display_enable(struct msm_dp *dp, struct drm_encoder *encoder)
 
 	state =  dp_display->hpd_state;
 
-	if (state == ST_DISPLAY_OFF)
+	if (state == ST_DISPLAY_OFF) {
 		dp_display_host_phy_init(dp_display);
+		force_link_train = true;
+	}
 
-	dp_display_enable(dp_display, 0);
+	dp_display_enable(dp_display, force_link_train);
 
 	rc = dp_display_post_enable(dp);
 	if (rc) {
@@ -1629,10 +1633,6 @@ int msm_dp_display_enable(struct msm_dp *dp, struct drm_encoder *encoder)
 		dp_display_unprepare(dp);
 	}
 
-	/* manual kick off plug event to train link */
-	if (state == ST_DISPLAY_OFF)
-		dp_add_event(dp_display, EV_IRQ_HPD_INT, 0, 0);
-
 	/* completed connection */
 	dp_display->hpd_state = ST_CONNECTED;
 
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index f2c46116df55..b5f6acfe7c6e 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -967,7 +967,7 @@ static const struct drm_driver msm_driver = {
 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
 	.gem_prime_import_sg_table = msm_gem_prime_import_sg_table,
-	.gem_prime_mmap     = drm_gem_prime_mmap,
+	.gem_prime_mmap     = msm_gem_prime_mmap,
 #ifdef CONFIG_DEBUG_FS
 	.debugfs_init       = msm_debugfs_init,
 #endif
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index d661debb50f1..9b985b641319 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -288,6 +288,7 @@ unsigned long msm_gem_shrinker_shrink(struct drm_device *dev, unsigned long nr_t
 void msm_gem_shrinker_init(struct drm_device *dev);
 void msm_gem_shrinker_cleanup(struct drm_device *dev);
 
+int msm_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma);
 struct sg_table *msm_gem_prime_get_sg_table(struct drm_gem_object *obj);
 int msm_gem_prime_vmap(struct drm_gem_object *obj, struct iosys_map *map);
 void msm_gem_prime_vunmap(struct drm_gem_object *obj, struct iosys_map *map);
diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index 94ab705e9b8a..dcc8a573bc76 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -11,6 +11,21 @@
 #include "msm_drv.h"
 #include "msm_gem.h"
 
+int msm_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
+{
+	int ret;
+
+	/* Ensure the mmap offset is initialized.  We lazily initialize it,
+	 * so if it has not been first mmap'd directly as a GEM object, the
+	 * mmap offset will not be already initialized.
+	 */
+	ret = drm_gem_create_mmap_offset(obj);
+	if (ret)
+		return ret;
+
+	return drm_gem_prime_mmap(obj, vma);
+}
+
 struct sg_table *msm_gem_prime_get_sg_table(struct drm_gem_object *obj)
 {
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 58eb3e1662cb..7d27d7cee688 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -664,7 +664,6 @@ static void retire_submit(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 	msm_submit_retire(submit);
 
 	pm_runtime_mark_last_busy(&gpu->pdev->dev);
-	pm_runtime_put_autosuspend(&gpu->pdev->dev);
 
 	spin_lock_irqsave(&ring->submit_lock, flags);
 	list_del(&submit->node);
@@ -678,6 +677,8 @@ static void retire_submit(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 		msm_devfreq_idle(gpu);
 	mutex_unlock(&gpu->active_lock);
 
+	pm_runtime_put_autosuspend(&gpu->pdev->dev);
+
 	msm_gem_submit_put(submit);
 }
 
diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index bcaddbba564d..a54ed354578b 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -58,7 +58,7 @@ static int msm_iommu_pagetable_map(struct msm_mmu *mmu, u64 iova,
 	u64 addr = iova;
 	unsigned int i;
 
-	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+	for_each_sgtable_sg(sgt, sg, i) {
 		size_t size = sg->length;
 		phys_addr_t phys = sg_phys(sg);
 
diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index 6a9ba8a77c77..4b29de65a563 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -73,7 +73,6 @@ static int sun4i_drv_bind(struct device *dev)
 		goto free_drm;
 	}
 
-	dev_set_drvdata(dev, drm);
 	drm->dev_private = drv;
 	INIT_LIST_HEAD(&drv->frontend_list);
 	INIT_LIST_HEAD(&drv->engine_list);
@@ -114,6 +113,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 	drm_fbdev_generic_setup(drm, 32);
 
+	dev_set_drvdata(dev, drm);
+
 	return 0;
 
 finish_poll:
@@ -130,6 +131,7 @@ static void sun4i_drv_unbind(struct device *dev)
 {
 	struct drm_device *drm = dev_get_drvdata(dev);
 
+	dev_set_drvdata(dev, NULL);
 	drm_dev_unregister(drm);
 	drm_kms_helper_poll_fini(drm);
 	drm_atomic_helper_shutdown(drm);
diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 4f73bc827eec..9c9e98578667 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -1006,11 +1006,12 @@ static int bma180_probe(struct i2c_client *client,
 
 		data->trig->ops = &bma180_trigger_ops;
 		iio_trigger_set_drvdata(data->trig, indio_dev);
-		indio_dev->trig = iio_trigger_get(data->trig);
 
 		ret = iio_trigger_register(data->trig);
 		if (ret)
 			goto err_trigger_free;
+
+		indio_dev->trig = iio_trigger_get(data->trig);
 	}
 
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,
diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index ac74cdcd2bc8..748b35c2f0c3 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1554,12 +1554,12 @@ static int kxcjk1013_probe(struct i2c_client *client,
 
 		data->dready_trig->ops = &kxcjk1013_trigger_ops;
 		iio_trigger_set_drvdata(data->dready_trig, indio_dev);
-		indio_dev->trig = data->dready_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = iio_trigger_register(data->dready_trig);
 		if (ret)
 			goto err_poweroff;
 
+		indio_dev->trig = iio_trigger_get(data->dready_trig);
+
 		data->motion_trig->ops = &kxcjk1013_trigger_ops;
 		iio_trigger_set_drvdata(data->motion_trig, indio_dev);
 		ret = iio_trigger_register(data->motion_trig);
diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 9c02c681c84c..f4f835274d75 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1510,10 +1510,14 @@ static int mma8452_reset(struct i2c_client *client)
 	int i;
 	int ret;
 
-	ret = i2c_smbus_write_byte_data(client,	MMA8452_CTRL_REG2,
+	/*
+	 * Find on fxls8471, after config reset bit, it reset immediately,
+	 * and will not give ACK, so here do not check the return value.
+	 * The following code will read the reset register, and check whether
+	 * this reset works.
+	 */
+	i2c_smbus_write_byte_data(client, MMA8452_CTRL_REG2,
 					MMA8452_CTRL_REG2_RST);
-	if (ret < 0)
-		return ret;
 
 	for (i = 0; i < 10; i++) {
 		usleep_range(100, 200);
@@ -1556,11 +1560,13 @@ static int mma8452_probe(struct i2c_client *client,
 	mutex_init(&data->lock);
 
 	data->chip_info = device_get_match_data(&client->dev);
-	if (!data->chip_info && id) {
-		data->chip_info = &mma_chip_info_table[id->driver_data];
-	} else {
-		dev_err(&client->dev, "unknown device model\n");
-		return -ENODEV;
+	if (!data->chip_info) {
+		if (id) {
+			data->chip_info = &mma_chip_info_table[id->driver_data];
+		} else {
+			dev_err(&client->dev, "unknown device model\n");
+			return -ENODEV;
+		}
 	}
 
 	ret = iio_read_mount_matrix(&client->dev, &data->orientation);
diff --git a/drivers/iio/accel/mxc4005.c b/drivers/iio/accel/mxc4005.c
index b3afbf064915..df600d2917c0 100644
--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -456,8 +456,6 @@ static int mxc4005_probe(struct i2c_client *client,
 
 		data->dready_trig->ops = &mxc4005_trigger_ops;
 		iio_trigger_set_drvdata(data->dready_trig, indio_dev);
-		indio_dev->trig = data->dready_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = devm_iio_trigger_register(&client->dev,
 						data->dready_trig);
 		if (ret) {
@@ -465,6 +463,8 @@ static int mxc4005_probe(struct i2c_client *client,
 				"failed to register trigger\n");
 			return ret;
 		}
+
+		indio_dev->trig = iio_trigger_get(data->dready_trig);
 	}
 
 	return devm_iio_device_register(&client->dev, indio_dev);
diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index a73e3c2d212f..a9e655e69eaa 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -322,16 +322,19 @@ static struct adi_axi_adc_client *adi_axi_adc_attach_client(struct device *dev)
 
 		if (!try_module_get(cl->dev->driver->owner)) {
 			mutex_unlock(&registered_clients_lock);
+			of_node_put(cln);
 			return ERR_PTR(-ENODEV);
 		}
 
 		get_device(cl->dev);
 		cl->info = info;
 		mutex_unlock(&registered_clients_lock);
+		of_node_put(cln);
 		return cl;
 	}
 
 	mutex_unlock(&registered_clients_lock);
+	of_node_put(cln);
 
 	return ERR_PTR(-EPROBE_DEFER);
 }
diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index 0793d2474cdc..9341e0e0eb55 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -186,6 +186,7 @@ static int aspeed_adc_set_trim_data(struct iio_dev *indio_dev)
 		return -EOPNOTSUPP;
 	}
 	scu = syscon_node_to_regmap(syscon);
+	of_node_put(syscon);
 	if (IS_ERR(scu)) {
 		dev_warn(data->dev, "Failed to get syscon regmap\n");
 		return -EOPNOTSUPP;
diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index a4b8be5b8f88..580361bd9849 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -196,6 +196,14 @@ static const struct dmi_system_id axp288_adc_ts_bias_override[] = {
 		},
 		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
 	},
+	{
+		/* Nuvision Solo 10 Draw */
+		.matches = {
+		  DMI_MATCH(DMI_SYS_VENDOR, "TMAX"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "TM101W610L"),
+		},
+		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
+	},
 	{}
 };
 
diff --git a/drivers/iio/adc/rzg2l_adc.c b/drivers/iio/adc/rzg2l_adc.c
index 7585144b9715..5b09a93fdf34 100644
--- a/drivers/iio/adc/rzg2l_adc.c
+++ b/drivers/iio/adc/rzg2l_adc.c
@@ -334,11 +334,15 @@ static int rzg2l_adc_parse_properties(struct platform_device *pdev, struct rzg2l
 	i = 0;
 	device_for_each_child_node(&pdev->dev, fwnode) {
 		ret = fwnode_property_read_u32(fwnode, "reg", &channel);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			return ret;
+		}
 
-		if (channel >= RZG2L_ADC_MAX_CHANNELS)
+		if (channel >= RZG2L_ADC_MAX_CHANNELS) {
+			fwnode_handle_put(fwnode);
 			return -EINVAL;
+		}
 
 		chan_array[i].type = IIO_VOLTAGE;
 		chan_array[i].indexed = 1;
diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index 142656232157..3efb8c404ccc 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -64,6 +64,7 @@ struct stm32_adc_priv;
  * @max_clk_rate_hz: maximum analog clock rate (Hz, from datasheet)
  * @has_syscfg: SYSCFG capability flags
  * @num_irqs:	number of interrupt lines
+ * @num_adcs:   maximum number of ADC instances in the common registers
  */
 struct stm32_adc_priv_cfg {
 	const struct stm32_adc_common_regs *regs;
@@ -71,6 +72,7 @@ struct stm32_adc_priv_cfg {
 	u32 max_clk_rate_hz;
 	unsigned int has_syscfg;
 	unsigned int num_irqs;
+	unsigned int num_adcs;
 };
 
 /**
@@ -352,7 +354,7 @@ static void stm32_adc_irq_handler(struct irq_desc *desc)
 	 * before invoking the interrupt handler (e.g. call ISR only for
 	 * IRQ-enabled ADCs).
 	 */
-	for (i = 0; i < priv->cfg->num_irqs; i++) {
+	for (i = 0; i < priv->cfg->num_adcs; i++) {
 		if ((status & priv->cfg->regs->eoc_msk[i] &&
 		     stm32_adc_eoc_enabled(priv, i)) ||
 		     (status & priv->cfg->regs->ovr_msk[i]))
@@ -792,6 +794,7 @@ static const struct stm32_adc_priv_cfg stm32f4_adc_priv_cfg = {
 	.clk_sel = stm32f4_adc_clk_sel,
 	.max_clk_rate_hz = 36000000,
 	.num_irqs = 1,
+	.num_adcs = 3,
 };
 
 static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
@@ -800,14 +803,16 @@ static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
 	.max_clk_rate_hz = 36000000,
 	.has_syscfg = HAS_VBOOSTER,
 	.num_irqs = 1,
+	.num_adcs = 2,
 };
 
 static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
 	.regs = &stm32h7_adc_common_regs,
 	.clk_sel = stm32h7_adc_clk_sel,
-	.max_clk_rate_hz = 40000000,
+	.max_clk_rate_hz = 36000000,
 	.has_syscfg = HAS_VBOOSTER | HAS_ANASWVDD,
 	.num_irqs = 2,
+	.num_adcs = 2,
 };
 
 static const struct of_device_id stm32_adc_of_match[] = {
diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index a68ecbda6480..11ef873d6453 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1365,7 +1365,7 @@ static int stm32_adc_read_raw(struct iio_dev *indio_dev,
 		else
 			ret = -EINVAL;
 
-		if (mask == IIO_CHAN_INFO_PROCESSED && adc->vrefint.vrefint_cal)
+		if (mask == IIO_CHAN_INFO_PROCESSED)
 			*val = STM32_ADC_VREFINT_VOLTAGE * adc->vrefint.vrefint_cal / *val;
 
 		iio_device_release_direct_mode(indio_dev);
@@ -1407,7 +1407,6 @@ static irqreturn_t stm32_adc_threaded_isr(int irq, void *data)
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	const struct stm32_adc_regspec *regs = adc->cfg->regs;
 	u32 status = stm32_adc_readl(adc, regs->isr_eoc.reg);
-	u32 mask = stm32_adc_readl(adc, regs->ier_eoc.reg);
 
 	/* Check ovr status right now, as ovr mask should be already disabled */
 	if (status & regs->isr_ovr.mask) {
@@ -1422,11 +1421,6 @@ static irqreturn_t stm32_adc_threaded_isr(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
-	if (!(status & mask))
-		dev_err_ratelimited(&indio_dev->dev,
-				    "Unexpected IRQ: IER=0x%08x, ISR=0x%08x\n",
-				    mask, status);
-
 	return IRQ_NONE;
 }
 
@@ -1436,10 +1430,6 @@ static irqreturn_t stm32_adc_isr(int irq, void *data)
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	const struct stm32_adc_regspec *regs = adc->cfg->regs;
 	u32 status = stm32_adc_readl(adc, regs->isr_eoc.reg);
-	u32 mask = stm32_adc_readl(adc, regs->ier_eoc.reg);
-
-	if (!(status & mask))
-		return IRQ_WAKE_THREAD;
 
 	if (status & regs->isr_ovr.mask) {
 		/*
@@ -1979,10 +1969,10 @@ static int stm32_adc_populate_int_ch(struct iio_dev *indio_dev, const char *ch_n
 
 	for (i = 0; i < STM32_ADC_INT_CH_NB; i++) {
 		if (!strncmp(stm32_adc_ic[i].name, ch_name, STM32_ADC_CH_SZ)) {
-			adc->int_ch[i] = chan;
-
-			if (stm32_adc_ic[i].idx != STM32_ADC_INT_CH_VREFINT)
-				continue;
+			if (stm32_adc_ic[i].idx != STM32_ADC_INT_CH_VREFINT) {
+				adc->int_ch[i] = chan;
+				break;
+			}
 
 			/* Get calibration data for vrefint channel */
 			ret = nvmem_cell_read_u16(&indio_dev->dev, "vrefint", &vrefint);
@@ -1990,10 +1980,15 @@ static int stm32_adc_populate_int_ch(struct iio_dev *indio_dev, const char *ch_n
 				return dev_err_probe(indio_dev->dev.parent, ret,
 						     "nvmem access error\n");
 			}
-			if (ret == -ENOENT)
-				dev_dbg(&indio_dev->dev, "vrefint calibration not found\n");
-			else
-				adc->vrefint.vrefint_cal = vrefint;
+			if (ret == -ENOENT) {
+				dev_dbg(&indio_dev->dev, "vrefint calibration not found. Skip vrefint channel\n");
+				return ret;
+			} else if (!vrefint) {
+				dev_dbg(&indio_dev->dev, "Null vrefint calibration value. Skip vrefint channel\n");
+				return -ENOENT;
+			}
+			adc->int_ch[i] = chan;
+			adc->vrefint.vrefint_cal = vrefint;
 		}
 	}
 
@@ -2030,7 +2025,9 @@ static int stm32_adc_generic_chan_init(struct iio_dev *indio_dev,
 			}
 			strncpy(adc->chan_name[val], name, STM32_ADC_CH_SZ);
 			ret = stm32_adc_populate_int_ch(indio_dev, name, val);
-			if (ret)
+			if (ret == -ENOENT)
+				continue;
+			else if (ret)
 				goto err;
 		} else if (ret != -EINVAL) {
 			dev_err(&indio_dev->dev, "Invalid label %d\n", ret);
diff --git a/drivers/iio/adc/ti-ads131e08.c b/drivers/iio/adc/ti-ads131e08.c
index 0c2025a22575..80a09817c119 100644
--- a/drivers/iio/adc/ti-ads131e08.c
+++ b/drivers/iio/adc/ti-ads131e08.c
@@ -739,7 +739,7 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 	device_for_each_child_node(dev, node) {
 		ret = fwnode_property_read_u32(node, "reg", &channel);
 		if (ret)
-			return ret;
+			goto err_child_out;
 
 		ret = fwnode_property_read_u32(node, "ti,gain", &tmp);
 		if (ret) {
@@ -747,7 +747,7 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 		} else {
 			ret = ads131e08_pga_gain_to_field_value(st, tmp);
 			if (ret < 0)
-				return ret;
+				goto err_child_out;
 
 			channel_config[i].pga_gain = tmp;
 		}
@@ -758,7 +758,7 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 		} else {
 			ret = ads131e08_validate_channel_mux(st, tmp);
 			if (ret)
-				return ret;
+				goto err_child_out;
 
 			channel_config[i].mux = tmp;
 		}
@@ -784,6 +784,10 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 	st->channel_config = channel_config;
 
 	return 0;
+
+err_child_out:
+	fwnode_handle_put(node);
+	return ret;
 }
 
 static void ads131e08_regulator_disable(void *data)
diff --git a/drivers/iio/adc/xilinx-ams.c b/drivers/iio/adc/xilinx-ams.c
index a55396c1f8b2..a7687706012d 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -1409,7 +1409,7 @@ static int ams_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return ret;
+		return irq;
 
 	ret = devm_request_irq(&pdev->dev, irq, &ams_irq, 0, "ams-irq",
 			       indio_dev);
diff --git a/drivers/iio/afe/iio-rescale.c b/drivers/iio/afe/iio-rescale.c
index 7e511293d6d1..dc426e1484f0 100644
--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -278,7 +278,7 @@ static int rescale_configure_channel(struct device *dev,
 	chan->ext_info = rescale->ext_info;
 	chan->type = rescale->cfg->type;
 
-	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
+	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) &&
 	    iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE)) {
 		dev_info(dev, "using raw+scale source channel\n");
 	} else if (iio_channel_has_info(schan, IIO_CHAN_INFO_PROCESSED)) {
diff --git a/drivers/iio/chemical/ccs811.c b/drivers/iio/chemical/ccs811.c
index 847194fa1e46..80ef1aa9aae3 100644
--- a/drivers/iio/chemical/ccs811.c
+++ b/drivers/iio/chemical/ccs811.c
@@ -499,11 +499,11 @@ static int ccs811_probe(struct i2c_client *client,
 
 		data->drdy_trig->ops = &ccs811_trigger_ops;
 		iio_trigger_set_drvdata(data->drdy_trig, indio_dev);
-		indio_dev->trig = data->drdy_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = iio_trigger_register(data->drdy_trig);
 		if (ret)
 			goto err_poweroff;
+
+		indio_dev->trig = iio_trigger_get(data->drdy_trig);
 	}
 
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,
diff --git a/drivers/iio/gyro/mpu3050-core.c b/drivers/iio/gyro/mpu3050-core.c
index ea387efab62d..f4c2f4cb4834 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -874,6 +874,7 @@ static int mpu3050_power_up(struct mpu3050 *mpu3050)
 	ret = regmap_update_bits(mpu3050->map, MPU3050_PWR_MGM,
 				 MPU3050_PWR_MGM_SLEEP, 0);
 	if (ret) {
+		regulator_bulk_disable(ARRAY_SIZE(mpu3050->regs), mpu3050->regs);
 		dev_err(mpu3050->dev, "error setting power mode\n");
 		return ret;
 	}
diff --git a/drivers/iio/humidity/hts221_buffer.c b/drivers/iio/humidity/hts221_buffer.c
index f29692b9d2db..66b32413cf5e 100644
--- a/drivers/iio/humidity/hts221_buffer.c
+++ b/drivers/iio/humidity/hts221_buffer.c
@@ -135,9 +135,12 @@ int hts221_allocate_trigger(struct iio_dev *iio_dev)
 
 	iio_trigger_set_drvdata(hw->trig, iio_dev);
 	hw->trig->ops = &hts221_trigger_ops;
+
+	err = devm_iio_trigger_register(hw->dev, hw->trig);
+
 	iio_dev->trig = iio_trigger_get(hw->trig);
 
-	return devm_iio_trigger_register(hw->dev, hw->trig);
+	return err;
 }
 
 static int hts221_buffer_preenable(struct iio_dev *iio_dev)
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600.h b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
index c0f5059b13b3..995a9dc06521 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -17,6 +17,7 @@
 #include "inv_icm42600_buffer.h"
 
 enum inv_icm42600_chip {
+	INV_CHIP_INVALID,
 	INV_CHIP_ICM42600,
 	INV_CHIP_ICM42602,
 	INV_CHIP_ICM42605,
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
index 86858da9cc38..ca85fccc9839 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -565,7 +565,7 @@ int inv_icm42600_core_probe(struct regmap *regmap, int chip, int irq,
 	bool open_drain;
 	int ret;
 
-	if (chip < 0 || chip >= INV_CHIP_NB) {
+	if (chip <= INV_CHIP_INVALID || chip >= INV_CHIP_NB) {
 		dev_err(dev, "invalid chip = %d\n", chip);
 		return -ENODEV;
 	}
diff --git a/drivers/iio/magnetometer/yamaha-yas530.c b/drivers/iio/magnetometer/yamaha-yas530.c
index 9ff7b0e56cf6..b2bc637150bf 100644
--- a/drivers/iio/magnetometer/yamaha-yas530.c
+++ b/drivers/iio/magnetometer/yamaha-yas530.c
@@ -639,7 +639,7 @@ static int yas532_get_calibration_data(struct yas5xx *yas5xx)
 	dev_dbg(yas5xx->dev, "calibration data: %*ph\n", 14, data);
 
 	/* Sanity check, is this all zeroes? */
-	if (memchr_inv(data, 0x00, 13)) {
+	if (memchr_inv(data, 0x00, 13) == NULL) {
 		if (!(data[13] & BIT(7)))
 			dev_warn(yas5xx->dev, "calibration is blank!\n");
 	}
diff --git a/drivers/iio/proximity/sx9324.c b/drivers/iio/proximity/sx9324.c
index 70c37f664f6d..63fbcaa4cac8 100644
--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -885,6 +885,9 @@ sx9324_get_default_reg(struct device *dev, int idx,
 			break;
 		ret = device_property_read_u32_array(dev, prop, pin_defs,
 						     ARRAY_SIZE(pin_defs));
+		if (ret)
+			break;
+
 		for (pin = 0; pin < SX9324_NUM_PINS; pin++)
 			raw |= (pin_defs[pin] << (2 * pin)) &
 			       SX9324_REG_AFE_PH0_PIN_MASK(pin);
diff --git a/drivers/iio/test/Kconfig b/drivers/iio/test/Kconfig
index 56ca0ad7e77a..4c66c3f18c34 100644
--- a/drivers/iio/test/Kconfig
+++ b/drivers/iio/test/Kconfig
@@ -6,7 +6,7 @@
 # Keep in alphabetical order
 config IIO_RESCALE_KUNIT_TEST
 	bool "Test IIO rescale conversion functions"
-	depends on KUNIT=y && !IIO_RESCALE
+	depends on KUNIT=y && IIO_RESCALE=y
 	default KUNIT_ALL_TESTS
 	help
 	  If you want to run tests on the iio-rescale code say Y here.
diff --git a/drivers/iio/test/Makefile b/drivers/iio/test/Makefile
index f15ae0a6394f..880360f8d02c 100644
--- a/drivers/iio/test/Makefile
+++ b/drivers/iio/test/Makefile
@@ -4,6 +4,6 @@
 #
 
 # Keep in alphabetical order
-obj-$(CONFIG_IIO_RESCALE_KUNIT_TEST) += iio-test-rescale.o ../afe/iio-rescale.o
+obj-$(CONFIG_IIO_RESCALE_KUNIT_TEST) += iio-test-rescale.o
 obj-$(CONFIG_IIO_TEST_FORMAT) += iio-test-format.o
 CFLAGS_iio-test-format.o += $(DISABLE_STRUCTLEAK_PLUGIN)
diff --git a/drivers/iio/trigger/iio-trig-sysfs.c b/drivers/iio/trigger/iio-trig-sysfs.c
index 2a4b75897910..3d911c24b265 100644
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -191,6 +191,7 @@ static int iio_sysfs_trigger_remove(int id)
 	}
 
 	iio_trigger_unregister(t->trig);
+	irq_work_sync(&t->work);
 	iio_trigger_free(t->trig);
 
 	list_del(&t->l);
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 8fdb84b3642b..1d42084d0276 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -987,7 +987,7 @@ static const struct of_device_id ipmmu_of_ids[] = {
 		.compatible = "renesas,ipmmu-r8a779a0",
 		.data = &ipmmu_features_rcar_gen4,
 	}, {
-		.compatible = "renesas,rcar-gen4-ipmmu",
+		.compatible = "renesas,rcar-gen4-ipmmu-vmsa",
 		.data = &ipmmu_features_rcar_gen4,
 	}, {
 		/* Terminator */
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 1f6bf152b3c7..e92c1afc3677 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1400,7 +1400,7 @@ static void start_worker(struct era *era)
 static void stop_worker(struct era *era)
 {
 	atomic_set(&era->suspended, 1);
-	flush_workqueue(era->wq);
+	drain_workqueue(era->wq);
 }
 
 /*----------------------------------------------------------------
@@ -1570,6 +1570,12 @@ static void era_postsuspend(struct dm_target *ti)
 	}
 
 	stop_worker(era);
+
+	r = metadata_commit(era->md);
+	if (r) {
+		DMERR("%s: metadata_commit failed", __func__);
+		/* FIXME: fail mode */
+	}
 }
 
 static int era_preresume(struct dm_target *ti)
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 2dda05aada23..0c6620e7b7bf 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -615,7 +615,7 @@ static int disk_resume(struct dm_dirty_log *log)
 			log_clear_bit(lc, lc->clean_bits, i);
 
 	/* clear any old bits -- device has shrunk */
-	for (i = lc->region_count; i % (sizeof(*lc->clean_bits) << BYTE_SHIFT); i++)
+	for (i = lc->region_count; i % BITS_PER_LONG; i++)
 		log_clear_bit(lc, lc->clean_bits, i);
 
 	/* copy clean across to sync */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 83dd17abf1af..f01d33bc3613 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -899,9 +899,11 @@ static void dm_io_complete(struct dm_io *io)
 			if (io_error == BLK_STS_AGAIN) {
 				/* io_uring doesn't handle BLK_STS_AGAIN (yet) */
 				queue_io(md, bio);
+				return;
 			}
 		}
-		return;
+		if (io_error == BLK_STS_DM_REQUEUE)
+			return;
 	}
 
 	if (bio_is_flush_with_data(bio)) {
diff --git a/drivers/memory/mtk-smi.c b/drivers/memory/mtk-smi.c
index 86a3d34f418e..4c5154e0bf00 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -404,13 +404,16 @@ static int mtk_smi_device_link_common(struct device *dev, struct device **com_de
 	of_node_put(smi_com_node);
 	if (smi_com_pdev) {
 		/* smi common is the supplier, Make sure it is ready before */
-		if (!platform_get_drvdata(smi_com_pdev))
+		if (!platform_get_drvdata(smi_com_pdev)) {
+			put_device(&smi_com_pdev->dev);
 			return -EPROBE_DEFER;
+		}
 		smi_com_dev = &smi_com_pdev->dev;
 		link = device_link_add(dev, smi_com_dev,
 				       DL_FLAG_PM_RUNTIME | DL_FLAG_STATELESS);
 		if (!link) {
 			dev_err(dev, "Unable to link smi-common dev\n");
+			put_device(&smi_com_pdev->dev);
 			return -ENODEV;
 		}
 		*com_dev = smi_com_dev;
diff --git a/drivers/memory/samsung/exynos5422-dmc.c b/drivers/memory/samsung/exynos5422-dmc.c
index 4733e7898ffe..c491cd549644 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1187,33 +1187,39 @@ static int of_get_dram_timings(struct exynos5_dmc *dmc)
 
 	dmc->timing_row = devm_kmalloc_array(dmc->dev, TIMING_COUNT,
 					     sizeof(u32), GFP_KERNEL);
-	if (!dmc->timing_row)
-		return -ENOMEM;
+	if (!dmc->timing_row) {
+		ret = -ENOMEM;
+		goto put_node;
+	}
 
 	dmc->timing_data = devm_kmalloc_array(dmc->dev, TIMING_COUNT,
 					      sizeof(u32), GFP_KERNEL);
-	if (!dmc->timing_data)
-		return -ENOMEM;
+	if (!dmc->timing_data) {
+		ret = -ENOMEM;
+		goto put_node;
+	}
 
 	dmc->timing_power = devm_kmalloc_array(dmc->dev, TIMING_COUNT,
 					       sizeof(u32), GFP_KERNEL);
-	if (!dmc->timing_power)
-		return -ENOMEM;
+	if (!dmc->timing_power) {
+		ret = -ENOMEM;
+		goto put_node;
+	}
 
 	dmc->timings = of_lpddr3_get_ddr_timings(np_ddr, dmc->dev,
 						 DDR_TYPE_LPDDR3,
 						 &dmc->timings_arr_size);
 	if (!dmc->timings) {
-		of_node_put(np_ddr);
 		dev_warn(dmc->dev, "could not get timings from DT\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 
 	dmc->min_tck = of_lpddr3_get_min_tck(np_ddr, dmc->dev);
 	if (!dmc->min_tck) {
-		of_node_put(np_ddr);
 		dev_warn(dmc->dev, "could not get tck from DT\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 
 	/* Sorted array of OPPs with frequency ascending */
@@ -1227,13 +1233,14 @@ static int of_get_dram_timings(struct exynos5_dmc *dmc)
 					     clk_period_ps);
 	}
 
-	of_node_put(np_ddr);
 
 	/* Take the highest frequency's timings as 'bypass' */
 	dmc->bypass_timing_row = dmc->timing_row[idx - 1];
 	dmc->bypass_timing_data = dmc->timing_data[idx - 1];
 	dmc->bypass_timing_power = dmc->timing_power[idx - 1];
 
+put_node:
+	of_node_put(np_ddr);
 	return ret;
 }
 
diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index e61b0b98065a..b74a0e54e652 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1356,7 +1356,7 @@ static void msdc_data_xfer_next(struct msdc_host *host, struct mmc_request *mrq)
 		msdc_request_done(host, mrq);
 }
 
-static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
+static void msdc_data_xfer_done(struct msdc_host *host, u32 events,
 				struct mmc_request *mrq, struct mmc_data *data)
 {
 	struct mmc_command *stop;
@@ -1376,7 +1376,7 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 	spin_unlock_irqrestore(&host->lock, flags);
 
 	if (done)
-		return true;
+		return;
 	stop = data->stop;
 
 	if (check_data || (stop && stop->error)) {
@@ -1385,12 +1385,15 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 		sdr_set_field(host->base + MSDC_DMA_CTRL, MSDC_DMA_CTRL_STOP,
 				1);
 
+		ret = readl_poll_timeout_atomic(host->base + MSDC_DMA_CTRL, val,
+						!(val & MSDC_DMA_CTRL_STOP), 1, 20000);
+		if (ret)
+			dev_dbg(host->dev, "DMA stop timed out\n");
+
 		ret = readl_poll_timeout_atomic(host->base + MSDC_DMA_CFG, val,
 						!(val & MSDC_DMA_CFG_STS), 1, 20000);
-		if (ret) {
-			dev_dbg(host->dev, "DMA stop timed out\n");
-			return false;
-		}
+		if (ret)
+			dev_dbg(host->dev, "DMA inactive timed out\n");
 
 		sdr_clr_bits(host->base + MSDC_INTEN, data_ints_mask);
 		dev_dbg(host->dev, "DMA stop\n");
@@ -1415,9 +1418,7 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 		}
 
 		msdc_data_xfer_next(host, mrq);
-		done = true;
 	}
-	return done;
 }
 
 static void msdc_set_buswidth(struct msdc_host *host, u32 width)
@@ -2416,6 +2417,9 @@ static void msdc_cqe_disable(struct mmc_host *mmc, bool recovery)
 	if (recovery) {
 		sdr_set_field(host->base + MSDC_DMA_CTRL,
 			      MSDC_DMA_CTRL_STOP, 1);
+		if (WARN_ON(readl_poll_timeout(host->base + MSDC_DMA_CTRL, val,
+			!(val & MSDC_DMA_CTRL_STOP), 1, 3000)))
+			return;
 		if (WARN_ON(readl_poll_timeout(host->base + MSDC_DMA_CFG, val,
 			!(val & MSDC_DMA_CFG_STS), 1, 3000)))
 			return;
diff --git a/drivers/mmc/host/sdhci-pci-o2micro.c b/drivers/mmc/host/sdhci-pci-o2micro.c
index 92c20cb8074a..0d4d343dbb77 100644
--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -152,6 +152,8 @@ static int sdhci_o2_get_cd(struct mmc_host *mmc)
 
 	if (!(sdhci_readw(host, O2_PLL_DLL_WDT_CONTROL1) & O2_PLL_LOCK_STATUS))
 		sdhci_o2_enable_internal_clock(host);
+	else
+		sdhci_o2_wait_card_detect_stable(host);
 
 	return !!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT);
 }
diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 44b14c9dc9a7..375529b7d12e 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -695,7 +695,7 @@ static int gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
 		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
-	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
+	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));
 
 	/*
 	 * Derive NFC ideal delay from {3}:
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 26a6573adf0f..93c7a551264e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3684,9 +3684,11 @@ static void bond_activebackup_arp_mon(struct bonding *bond)
 		if (!rtnl_trylock())
 			return;
 
-		if (should_notify_peers)
+		if (should_notify_peers) {
+			bond->send_peer_notif--;
 			call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
 						 bond->dev);
+		}
 		if (should_notify_rtnl) {
 			bond_slave_state_notify(bond);
 			bond_slave_link_notify(bond);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index f375627174c8..e553e3e6fa0f 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -15,7 +15,7 @@
 
 #define QCA8K_ETHERNET_MDIO_PRIORITY			7
 #define QCA8K_ETHERNET_PHY_PRIORITY			6
-#define QCA8K_ETHERNET_TIMEOUT				100
+#define QCA8K_ETHERNET_TIMEOUT				5
 
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 24cda7e1f916..8aee4ae4cc8c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2191,6 +2191,42 @@ ice_setup_autoneg(struct ice_port_info *p, struct ethtool_link_ksettings *ks,
 	return err;
 }
 
+/**
+ * ice_set_phy_type_from_speed - set phy_types based on speeds
+ * and advertised modes
+ * @ks: ethtool link ksettings struct
+ * @phy_type_low: pointer to the lower part of phy_type
+ * @phy_type_high: pointer to the higher part of phy_type
+ * @adv_link_speed: targeted link speeds bitmap
+ */
+static void
+ice_set_phy_type_from_speed(const struct ethtool_link_ksettings *ks,
+			    u64 *phy_type_low, u64 *phy_type_high,
+			    u16 adv_link_speed)
+{
+	/* Handle 1000M speed in a special way because ice_update_phy_type
+	 * enables all link modes, but having mixed copper and optical
+	 * standards is not supported.
+	 */
+	adv_link_speed &= ~ICE_AQ_LINK_SPEED_1000MB;
+
+	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseT_Full))
+		*phy_type_low |= ICE_PHY_TYPE_LOW_1000BASE_T |
+				 ICE_PHY_TYPE_LOW_1G_SGMII;
+
+	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseKX_Full))
+		*phy_type_low |= ICE_PHY_TYPE_LOW_1000BASE_KX;
+
+	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseX_Full))
+		*phy_type_low |= ICE_PHY_TYPE_LOW_1000BASE_SX |
+				 ICE_PHY_TYPE_LOW_1000BASE_LX;
+
+	ice_update_phy_type(phy_type_low, phy_type_high, adv_link_speed);
+}
+
 /**
  * ice_set_link_ksettings - Set Speed and Duplex
  * @netdev: network interface device structure
@@ -2322,7 +2358,8 @@ ice_set_link_ksettings(struct net_device *netdev,
 		adv_link_speed = curr_link_speed;
 
 	/* Convert the advertise link speeds to their corresponded PHY_TYPE */
-	ice_update_phy_type(&phy_type_low, &phy_type_high, adv_link_speed);
+	ice_set_phy_type_from_speed(ks, &phy_type_low, &phy_type_high,
+				    adv_link_speed);
 
 	if (!autoneg_changed && adv_link_speed == curr_link_speed) {
 		netdev_info(netdev, "Nothing changed, exiting without setting anything.\n");
@@ -3440,6 +3477,16 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 	new_rx = ch->combined_count + ch->rx_count;
 	new_tx = ch->combined_count + ch->tx_count;
 
+	if (new_rx < vsi->tc_cfg.numtc) {
+		netdev_err(dev, "Cannot set less Rx channels, than Traffic Classes you have (%u)\n",
+			   vsi->tc_cfg.numtc);
+		return -EINVAL;
+	}
+	if (new_tx < vsi->tc_cfg.numtc) {
+		netdev_err(dev, "Cannot set less Tx channels, than Traffic Classes you have (%u)\n",
+			   vsi->tc_cfg.numtc);
+		return -EINVAL;
+	}
 	if (new_rx > ice_get_max_rxq(pf)) {
 		netdev_err(dev, "Maximum allowed Rx channels is %d\n",
 			   ice_get_max_rxq(pf));
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 454e01ae09b9..f7f9c973ec54 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -909,7 +909,7 @@ static void ice_set_dflt_vsi_ctx(struct ice_hw *hw, struct ice_vsi_ctx *ctxt)
  * @vsi: the VSI being configured
  * @ctxt: VSI context structure
  */
-static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
+static int ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 {
 	u16 offset = 0, qmap = 0, tx_count = 0, pow = 0;
 	u16 num_txq_per_tc, num_rxq_per_tc;
@@ -982,7 +982,18 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 	else
 		vsi->num_rxq = num_rxq_per_tc;
 
+	if (vsi->num_rxq > vsi->alloc_rxq) {
+		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Rx queues (%u), than were allocated (%u)!\n",
+			vsi->num_rxq, vsi->alloc_rxq);
+		return -EINVAL;
+	}
+
 	vsi->num_txq = tx_count;
+	if (vsi->num_txq > vsi->alloc_txq) {
+		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Tx queues (%u), than were allocated (%u)!\n",
+			vsi->num_txq, vsi->alloc_txq);
+		return -EINVAL;
+	}
 
 	if (vsi->type == ICE_VSI_VF && vsi->num_txq != vsi->num_rxq) {
 		dev_dbg(ice_pf_to_dev(vsi->back), "VF VSI should have same number of Tx and Rx queues. Hence making them equal\n");
@@ -1000,6 +1011,8 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 	 */
 	ctxt->info.q_mapping[0] = cpu_to_le16(vsi->rxq_map[0]);
 	ctxt->info.q_mapping[1] = cpu_to_le16(vsi->num_rxq);
+
+	return 0;
 }
 
 /**
@@ -1187,7 +1200,10 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 	if (vsi->type == ICE_VSI_CHNL) {
 		ice_chnl_vsi_setup_q_map(vsi, ctxt);
 	} else {
-		ice_vsi_setup_q_map(vsi, ctxt);
+		ret = ice_vsi_setup_q_map(vsi, ctxt);
+		if (ret)
+			goto out;
+
 		if (!init_vsi) /* means VSI being updated */
 			/* must to indicate which section of VSI context are
 			 * being modified
@@ -3464,7 +3480,7 @@ void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc)
  *
  * Prepares VSI tc_config to have queue configurations based on MQPRIO options.
  */
-static void
+static int
 ice_vsi_setup_q_map_mqprio(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt,
 			   u8 ena_tc)
 {
@@ -3513,7 +3529,18 @@ ice_vsi_setup_q_map_mqprio(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt,
 
 	/* Set actual Tx/Rx queue pairs */
 	vsi->num_txq = offset + qcount_tx;
+	if (vsi->num_txq > vsi->alloc_txq) {
+		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Tx queues (%u), than were allocated (%u)!\n",
+			vsi->num_txq, vsi->alloc_txq);
+		return -EINVAL;
+	}
+
 	vsi->num_rxq = offset + qcount_rx;
+	if (vsi->num_rxq > vsi->alloc_rxq) {
+		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Rx queues (%u), than were allocated (%u)!\n",
+			vsi->num_rxq, vsi->alloc_rxq);
+		return -EINVAL;
+	}
 
 	/* Setup queue TC[0].qmap for given VSI context */
 	ctxt->info.tc_mapping[0] = cpu_to_le16(qmap);
@@ -3531,6 +3558,8 @@ ice_vsi_setup_q_map_mqprio(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt,
 	dev_dbg(ice_pf_to_dev(vsi->back), "vsi->num_rxq = %d\n",  vsi->num_rxq);
 	dev_dbg(ice_pf_to_dev(vsi->back), "all_numtc %u, all_enatc: 0x%04x, tc_cfg.numtc %u\n",
 		vsi->all_numtc, vsi->all_enatc, vsi->tc_cfg.numtc);
+
+	return 0;
 }
 
 /**
@@ -3580,9 +3609,12 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 
 	if (vsi->type == ICE_VSI_PF &&
 	    test_bit(ICE_FLAG_TC_MQPRIO, pf->flags))
-		ice_vsi_setup_q_map_mqprio(vsi, ctx, ena_tc);
+		ret = ice_vsi_setup_q_map_mqprio(vsi, ctx, ena_tc);
 	else
-		ice_vsi_setup_q_map(vsi, ctx);
+		ret = ice_vsi_setup_q_map(vsi, ctx);
+
+	if (ret)
+		goto out;
 
 	/* must to indicate which section of VSI context are being modified */
 	ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_RXQ_MAP_VALID);
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 3acd9f921c44..2ce2694fcbd7 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -524,6 +524,7 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	 */
 	fltr->rid = rule_added.rid;
 	fltr->rule_id = rule_added.rule_id;
+	fltr->dest_id = rule_added.vsi_handle;
 
 exit:
 	kfree(list);
@@ -994,7 +995,9 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		n_proto_key = ntohs(match.key->n_proto);
 		n_proto_mask = ntohs(match.mask->n_proto);
 
-		if (n_proto_key == ETH_P_ALL || n_proto_key == 0) {
+		if (n_proto_key == ETH_P_ALL || n_proto_key == 0 ||
+		    fltr->tunnel_type == TNL_GTPU ||
+		    fltr->tunnel_type == TNL_GTPC) {
 			n_proto_key = 0;
 			n_proto_mask = 0;
 		} else {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 68be2976f539..c5f04c40284b 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4819,8 +4819,11 @@ static void igb_clean_tx_ring(struct igb_ring *tx_ring)
 	while (i != tx_ring->next_to_use) {
 		union e1000_adv_tx_desc *eop_desc, *tx_desc;
 
-		/* Free all the Tx ring sk_buffs */
-		dev_kfree_skb_any(tx_buffer->skb);
+		/* Free all the Tx ring sk_buffs or xdp frames */
+		if (tx_buffer->type == IGB_TYPE_SKB)
+			dev_kfree_skb_any(tx_buffer->skb);
+		else
+			xdp_return_frame(tx_buffer->xdpf);
 
 		/* unmap skb header data */
 		dma_unmap_single(tx_ring->dev,
@@ -9898,11 +9901,10 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 	struct e1000_hw *hw = &adapter->hw;
 	u32 dmac_thr;
 	u16 hwm;
+	u32 reg;
 
 	if (hw->mac.type > e1000_82580) {
 		if (adapter->flags & IGB_FLAG_DMAC) {
-			u32 reg;
-
 			/* force threshold to 0. */
 			wr32(E1000_DMCTXTH, 0);
 
@@ -9935,7 +9937,6 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			/* Disable BMC-to-OS Watchdog Enable */
 			if (hw->mac.type != e1000_i354)
 				reg &= ~E1000_DMACR_DC_BMC2OSW_EN;
-
 			wr32(E1000_DMACR, reg);
 
 			/* no lower threshold to disable
@@ -9952,12 +9953,12 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			 */
 			wr32(E1000_DMCTXTH, (IGB_MIN_TXPBSIZE -
 			     (IGB_TX_BUF_4096 + adapter->max_frame_size)) >> 6);
+		}
 
-			/* make low power state decision controlled
-			 * by DMA coal
-			 */
+		if (hw->mac.type >= e1000_i210 ||
+		    (adapter->flags & IGB_FLAG_DMAC)) {
 			reg = rd32(E1000_PCIEMISC);
-			reg &= ~E1000_PCIEMISC_LX_DECISION;
+			reg |= E1000_PCIEMISC_LX_DECISION;
 			wr32(E1000_PCIEMISC, reg);
 		} /* endif adapter->dmac is not disabled */
 	} else if (hw->mac.type == e1000_82580) {
diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index a8db1a19011b..c7047f5d7a9b 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -34,6 +34,8 @@
 #define MDIO_AN_VEND_PROV			0xc400
 #define MDIO_AN_VEND_PROV_1000BASET_FULL	BIT(15)
 #define MDIO_AN_VEND_PROV_1000BASET_HALF	BIT(14)
+#define MDIO_AN_VEND_PROV_5000BASET_FULL	BIT(11)
+#define MDIO_AN_VEND_PROV_2500BASET_FULL	BIT(10)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_EN		BIT(4)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_MASK	GENMASK(3, 0)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_DFLT	4
@@ -231,9 +233,20 @@ static int aqr_config_aneg(struct phy_device *phydev)
 			      phydev->advertising))
 		reg |= MDIO_AN_VEND_PROV_1000BASET_HALF;
 
+	/* Handle the case when the 2.5G and 5G speeds are not advertised */
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+			      phydev->advertising))
+		reg |= MDIO_AN_VEND_PROV_2500BASET_FULL;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
+			      phydev->advertising))
+		reg |= MDIO_AN_VEND_PROV_5000BASET_FULL;
+
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_VEND_PROV,
 				     MDIO_AN_VEND_PROV_1000BASET_HALF |
-				     MDIO_AN_VEND_PROV_1000BASET_FULL, reg);
+				     MDIO_AN_VEND_PROV_1000BASET_FULL |
+				     MDIO_AN_VEND_PROV_2500BASET_FULL |
+				     MDIO_AN_VEND_PROV_5000BASET_FULL, reg);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)
diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 6a467e7817a6..59fe356942b5 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -2072,6 +2072,8 @@ static struct phy_driver at803x_driver[] = {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
 	.name			= "Qualcomm Atheros AR9331 built-in PHY",
+	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
@@ -2087,6 +2089,8 @@ static struct phy_driver at803x_driver[] = {
 	/* Qualcomm Atheros QCA9561 */
 	PHY_ID_MATCH_EXACT(QCA9561_PHY_ID),
 	.name			= "Qualcomm Atheros QCA9561 built-in PHY",
+	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
@@ -2151,6 +2155,8 @@ static struct phy_driver at803x_driver[] = {
 	PHY_ID_MATCH_EXACT(QCA8081_PHY_ID),
 	.name			= "Qualcomm QCA8081",
 	.flags			= PHY_POLL_CABLE_TEST,
+	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index eb0121a64d6d..1d1dea07d932 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -312,6 +312,7 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
+	struct netdev_queue *queue = NULL;
 	struct veth_rq *rq = NULL;
 	struct net_device *rcv;
 	int length = skb->len;
@@ -329,6 +330,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	rxq = skb_get_queue_mapping(skb);
 	if (rxq < rcv->real_num_rx_queues) {
 		rq = &rcv_priv->rq[rxq];
+		queue = netdev_get_tx_queue(dev, rxq);
 
 		/* The napi pointer is available when an XDP program is
 		 * attached or when GRO is enabled
@@ -340,6 +342,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 	if (likely(veth_forward_skb(rcv, skb, rq, use_napi) == NET_RX_SUCCESS)) {
+		if (queue)
+			txq_trans_cond_update(queue);
 		if (!use_napi)
 			dev_lstats_add(dev, length);
 	} else {
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index cbba9d2e8f32..10d548b07b9c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2768,7 +2768,6 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 static void virtnet_freeze_down(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int i;
 
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
@@ -2776,14 +2775,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 	netif_tx_lock_bh(vi->dev);
 	netif_device_detach(vi->dev);
 	netif_tx_unlock_bh(vi->dev);
-	cancel_delayed_work_sync(&vi->refill);
-
-	if (netif_running(vi->dev)) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			napi_disable(&vi->rq[i].napi);
-			virtnet_napi_tx_disable(&vi->sq[i].napi);
-		}
-	}
+	if (netif_running(vi->dev))
+		virtnet_close(vi->dev);
 }
 
 static int init_vqs(struct virtnet_info *vi);
@@ -2791,7 +2784,7 @@ static int init_vqs(struct virtnet_info *vi);
 static int virtnet_restore_up(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int err, i;
+	int err;
 
 	err = init_vqs(vi);
 	if (err)
@@ -2800,15 +2793,9 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 	virtio_device_ready(vdev);
 
 	if (netif_running(vi->dev)) {
-		for (i = 0; i < vi->curr_queue_pairs; i++)
-			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
-				schedule_delayed_work(&vi->refill, 0);
-
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
-			virtnet_napi_tx_enable(vi, vi->sq[i].vq,
-					       &vi->sq[i].napi);
-		}
+		err = virtnet_open(vi->dev);
+		if (err)
+			return err;
 	}
 
 	netif_tx_lock_bh(vi->dev);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1ea85c88d795..a2862a56fadc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2487,6 +2487,20 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
 		.vid = 0x1e0f,
 		.mn = "KCD6XVUL6T40",
 		.quirks = NVME_QUIRK_NO_APST,
+	},
+	{
+		/*
+		 * The external Samsung X5 SSD fails initialization without a
+		 * delay before checking if it is ready and has a whole set of
+		 * other problems.  To make this even more interesting, it
+		 * shares the PCI ID with internal Samsung 970 Evo Plus that
+		 * does not need or want these quirks.
+		 */
+		.vid = 0x144d,
+		.mn = "Samsung Portable SSD X5",
+		.quirks = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
+			  NVME_QUIRK_NO_DEEPEST_PS |
+			  NVME_QUIRK_IGNORE_DEV_SUBNQN,
 	}
 };
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 17aeb7d5c485..ddea0fb90c28 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3475,10 +3475,6 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_128_BYTES_SQES |
 				NVME_QUIRK_SHARED_TAGS |
 				NVME_QUIRK_SKIP_CID_GEN },
-	{ PCI_DEVICE(0x144d, 0xa808),   /* Samsung X5 */
-		.driver_data =  NVME_QUIRK_DELAY_BEFORE_CHK_RDY|
-				NVME_QUIRK_NO_DEEPEST_PS |
-				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index d0eab5700dc5..00684e11976b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -160,8 +160,8 @@ static void ibmvfc_npiv_logout(struct ibmvfc_host *);
 static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
-static void ibmvfc_release_sub_crqs(struct ibmvfc_host *);
-static void ibmvfc_init_sub_crqs(struct ibmvfc_host *);
+static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *);
+static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *);
 
 static const char *unknown_error = "unknown error";
 
@@ -917,7 +917,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;
 
-	ibmvfc_release_sub_crqs(vhost);
+	ibmvfc_dereg_sub_crqs(vhost);
 
 	/* Re-enable the CRQ */
 	do {
@@ -936,7 +936,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	ibmvfc_init_sub_crqs(vhost);
+	ibmvfc_reg_sub_crqs(vhost);
 
 	return rc;
 }
@@ -955,7 +955,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
 
-	ibmvfc_release_sub_crqs(vhost);
+	ibmvfc_dereg_sub_crqs(vhost);
 
 	/* Close the CRQ */
 	do {
@@ -988,7 +988,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	ibmvfc_init_sub_crqs(vhost);
+	ibmvfc_reg_sub_crqs(vhost);
 
 	return rc;
 }
@@ -5682,6 +5682,8 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 	queue->cur = 0;
 	queue->fmt = fmt;
 	queue->size = PAGE_SIZE / fmt_size;
+
+	queue->vhost = vhost;
 	return 0;
 }
 
@@ -5757,9 +5759,6 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 
 	ENTER;
 
-	if (ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT))
-		return -ENOMEM;
-
 	rc = h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
 			   &scrq->cookie, &scrq->hw_irq);
 
@@ -5790,7 +5789,6 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 	}
 
 	scrq->hwq_id = index;
-	scrq->vhost = vhost;
 
 	LEAVE;
 	return 0;
@@ -5800,7 +5798,6 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
 	} while (rtas_busy_delay(rc));
 reg_failed:
-	ibmvfc_free_queue(vhost, scrq);
 	LEAVE;
 	return rc;
 }
@@ -5826,12 +5823,50 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
 	if (rc)
 		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
 
-	ibmvfc_free_queue(vhost, scrq);
+	/* Clean out the queue */
+	memset(scrq->msgs.crq, 0, PAGE_SIZE);
+	scrq->cur = 0;
+
+	LEAVE;
+}
+
+static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost)
+{
+	int i, j;
+
+	ENTER;
+	if (!vhost->mq_enabled || !vhost->scsi_scrqs.scrqs)
+		return;
+
+	for (i = 0; i < nr_scsi_hw_queues; i++) {
+		if (ibmvfc_register_scsi_channel(vhost, i)) {
+			for (j = i; j > 0; j--)
+				ibmvfc_deregister_scsi_channel(vhost, j - 1);
+			vhost->do_enquiry = 0;
+			return;
+		}
+	}
+
+	LEAVE;
+}
+
+static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost)
+{
+	int i;
+
+	ENTER;
+	if (!vhost->mq_enabled || !vhost->scsi_scrqs.scrqs)
+		return;
+
+	for (i = 0; i < nr_scsi_hw_queues; i++)
+		ibmvfc_deregister_scsi_channel(vhost, i);
+
 	LEAVE;
 }
 
 static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 {
+	struct ibmvfc_queue *scrq;
 	int i, j;
 
 	ENTER;
@@ -5847,30 +5882,41 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 	}
 
 	for (i = 0; i < nr_scsi_hw_queues; i++) {
-		if (ibmvfc_register_scsi_channel(vhost, i)) {
-			for (j = i; j > 0; j--)
-				ibmvfc_deregister_scsi_channel(vhost, j - 1);
+		scrq = &vhost->scsi_scrqs.scrqs[i];
+		if (ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT)) {
+			for (j = i; j > 0; j--) {
+				scrq = &vhost->scsi_scrqs.scrqs[j - 1];
+				ibmvfc_free_queue(vhost, scrq);
+			}
 			kfree(vhost->scsi_scrqs.scrqs);
 			vhost->scsi_scrqs.scrqs = NULL;
 			vhost->scsi_scrqs.active_queues = 0;
 			vhost->do_enquiry = 0;
-			break;
+			vhost->mq_enabled = 0;
+			return;
 		}
 	}
 
+	ibmvfc_reg_sub_crqs(vhost);
+
 	LEAVE;
 }
 
 static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
 {
+	struct ibmvfc_queue *scrq;
 	int i;
 
 	ENTER;
 	if (!vhost->scsi_scrqs.scrqs)
 		return;
 
-	for (i = 0; i < nr_scsi_hw_queues; i++)
-		ibmvfc_deregister_scsi_channel(vhost, i);
+	ibmvfc_dereg_sub_crqs(vhost);
+
+	for (i = 0; i < nr_scsi_hw_queues; i++) {
+		scrq = &vhost->scsi_scrqs.scrqs[i];
+		ibmvfc_free_queue(vhost, scrq);
+	}
 
 	kfree(vhost->scsi_scrqs.scrqs);
 	vhost->scsi_scrqs.scrqs = NULL;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 3718406e0988..c39a245f43d0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -789,6 +789,7 @@ struct ibmvfc_queue {
 	spinlock_t _lock;
 	spinlock_t *q_lock;
 
+	struct ibmvfc_host *vhost;
 	struct ibmvfc_event_pool evt_pool;
 	struct list_head sent;
 	struct list_head free;
@@ -797,7 +798,6 @@ struct ibmvfc_queue {
 	union ibmvfc_iu cancel_rsp;
 
 	/* Sub-CRQ fields */
-	struct ibmvfc_host *vhost;
 	unsigned long cookie;
 	unsigned long vios_cookie;
 	unsigned long hw_irq;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 592a290e6cfa..6cdd67f2a08e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2788,6 +2788,24 @@ static void zbc_open_zone(struct sdebug_dev_info *devip,
 	}
 }
 
+static inline void zbc_set_zone_full(struct sdebug_dev_info *devip,
+				     struct sdeb_zone_state *zsp)
+{
+	switch (zsp->z_cond) {
+	case ZC2_IMPLICIT_OPEN:
+		devip->nr_imp_open--;
+		break;
+	case ZC3_EXPLICIT_OPEN:
+		devip->nr_exp_open--;
+		break;
+	default:
+		WARN_ONCE(true, "Invalid zone %llu condition %x\n",
+			  zsp->z_start, zsp->z_cond);
+		break;
+	}
+	zsp->z_cond = ZC5_FULL;
+}
+
 static void zbc_inc_wp(struct sdebug_dev_info *devip,
 		       unsigned long long lba, unsigned int num)
 {
@@ -2800,7 +2818,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
 		zsp->z_wp += num;
 		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 		return;
 	}
 
@@ -2819,7 +2837,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 			n = num;
 		}
 		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 
 		num -= n;
 		lba += n;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2c0dd64159b0..5d21f07456c6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -212,7 +212,12 @@ iscsi_create_endpoint(int dd_size)
 		return NULL;
 
 	mutex_lock(&iscsi_ep_idr_mutex);
-	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
+
+	/*
+	 * First endpoint id should be 1 to comply with user space
+	 * applications (iscsid).
+	 */
+	id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
 	if (id < 0) {
 		mutex_unlock(&iscsi_ep_idr_mutex);
 		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9a0bba5a51a7..4b1f1d73eee8 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1916,7 +1916,7 @@ static struct scsi_host_template scsi_driver = {
 	.cmd_per_lun =		2048,
 	.this_id =		-1,
 	/* Ensure there are no gaps in presented sgls */
-	.virt_boundary_mask =	PAGE_SIZE-1,
+	.virt_boundary_mask =	HV_HYP_PAGE_SIZE - 1,
 	.no_write_same =	1,
 	.track_queue_depth =	1,
 	.change_queue_depth =	storvsc_change_queue_depth,
@@ -1970,6 +1970,7 @@ static int storvsc_probe(struct hv_device *device,
 	int max_targets;
 	int max_channels;
 	int max_sub_channels = 0;
+	u32 max_xfer_bytes;
 
 	/*
 	 * Based on the windows host we are running on,
@@ -2059,12 +2060,28 @@ static int storvsc_probe(struct hv_device *device,
 	}
 	/* max cmd length */
 	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
-
 	/*
-	 * set the table size based on the info we got
-	 * from the host.
+	 * Any reasonable Hyper-V configuration should provide
+	 * max_transfer_bytes value aligning to HV_HYP_PAGE_SIZE,
+	 * protecting it from any weird value.
+	 */
+	max_xfer_bytes = round_down(stor_device->max_transfer_bytes, HV_HYP_PAGE_SIZE);
+	/* max_hw_sectors_kb */
+	host->max_sectors = max_xfer_bytes >> 9;
+	/*
+	 * There are 2 requirements for Hyper-V storvsc sgl segments,
+	 * based on which the below calculation for max segments is
+	 * done:
+	 *
+	 * 1. Except for the first and last sgl segment, all sgl segments
+	 *    should be align to HV_HYP_PAGE_SIZE, that also means the
+	 *    maximum number of segments in a sgl can be calculated by
+	 *    dividing the total max transfer length by HV_HYP_PAGE_SIZE.
+	 *
+	 * 2. Except for the first and last, each entry in the SGL must
+	 *    have an offset that is a multiple of HV_HYP_PAGE_SIZE.
 	 */
-	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
+	host->sg_tablesize = (max_xfer_bytes >> HV_HYP_PAGE_SHIFT) + 1;
 	/*
 	 * For non-IDE disks, the host supports multiple channels.
 	 * Set the number of HW queues we are supporting.
diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index 3cbb165d6e30..70ad0f3dce28 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -783,6 +783,7 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	}
 
 	ret = brcmstb_init_sram(dn);
+	of_node_put(dn);
 	if (ret) {
 		pr_err("error setting up SRAM for PM\n");
 		return ret;
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index dc6c96e04bcf..3b8bf6daf7d0 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1048,6 +1048,9 @@ isr_setup_status_complete(struct usb_ep *ep, struct usb_request *req)
 	struct ci_hdrc *ci = req->context;
 	unsigned long flags;
 
+	if (req->status < 0)
+		return;
+
 	if (ci->setaddr) {
 		hw_usb_set_address(ci, ci->address);
 		ci->setaddr = false;
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 7f59a0c47402..4e4a7c312646 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -415,6 +415,9 @@ static void uvcg_video_pump(struct work_struct *work)
 			uvcg_queue_cancel(queue, 0);
 			break;
 		}
+
+		/* Endpoint now owns the request */
+		req = NULL;
 		video->req_int_count++;
 	}
 
diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index e9440f7bf019..ed7c2127fb91 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -11,6 +11,7 @@
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
+#include <linux/idr.h>
 #include <linux/kref.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -36,6 +37,9 @@ MODULE_LICENSE("GPL");
 
 /*----------------------------------------------------------------------*/
 
+static DEFINE_IDA(driver_id_numbers);
+#define DRIVER_DRIVER_NAME_LENGTH_MAX	32
+
 #define RAW_EVENT_QUEUE_SIZE	16
 
 struct raw_event_queue {
@@ -161,6 +165,9 @@ struct raw_dev {
 	/* Reference to misc device: */
 	struct device			*dev;
 
+	/* Make driver names unique */
+	int				driver_id_number;
+
 	/* Protected by lock: */
 	enum dev_state			state;
 	bool				gadget_registered;
@@ -189,6 +196,7 @@ static struct raw_dev *dev_new(void)
 	spin_lock_init(&dev->lock);
 	init_completion(&dev->ep0_done);
 	raw_event_queue_init(&dev->queue);
+	dev->driver_id_number = -1;
 	return dev;
 }
 
@@ -199,6 +207,9 @@ static void dev_free(struct kref *kref)
 
 	kfree(dev->udc_name);
 	kfree(dev->driver.udc_name);
+	kfree(dev->driver.driver.name);
+	if (dev->driver_id_number >= 0)
+		ida_free(&driver_id_numbers, dev->driver_id_number);
 	if (dev->req) {
 		if (dev->ep0_urb_queued)
 			usb_ep_dequeue(dev->gadget->ep0, dev->req);
@@ -419,9 +430,11 @@ static int raw_release(struct inode *inode, struct file *fd)
 static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 {
 	int ret = 0;
+	int driver_id_number;
 	struct usb_raw_init arg;
 	char *udc_driver_name;
 	char *udc_device_name;
+	char *driver_driver_name;
 	unsigned long flags;
 
 	if (copy_from_user(&arg, (void __user *)value, sizeof(arg)))
@@ -440,36 +453,43 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 		return -EINVAL;
 	}
 
+	driver_id_number = ida_alloc(&driver_id_numbers, GFP_KERNEL);
+	if (driver_id_number < 0)
+		return driver_id_number;
+
+	driver_driver_name = kmalloc(DRIVER_DRIVER_NAME_LENGTH_MAX, GFP_KERNEL);
+	if (!driver_driver_name) {
+		ret = -ENOMEM;
+		goto out_free_driver_id_number;
+	}
+	snprintf(driver_driver_name, DRIVER_DRIVER_NAME_LENGTH_MAX,
+				DRIVER_NAME ".%d", driver_id_number);
+
 	udc_driver_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
-	if (!udc_driver_name)
-		return -ENOMEM;
+	if (!udc_driver_name) {
+		ret = -ENOMEM;
+		goto out_free_driver_driver_name;
+	}
 	ret = strscpy(udc_driver_name, &arg.driver_name[0],
 				UDC_NAME_LENGTH_MAX);
-	if (ret < 0) {
-		kfree(udc_driver_name);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_free_udc_driver_name;
 	ret = 0;
 
 	udc_device_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
 	if (!udc_device_name) {
-		kfree(udc_driver_name);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free_udc_driver_name;
 	}
 	ret = strscpy(udc_device_name, &arg.device_name[0],
 				UDC_NAME_LENGTH_MAX);
-	if (ret < 0) {
-		kfree(udc_driver_name);
-		kfree(udc_device_name);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_free_udc_device_name;
 	ret = 0;
 
 	spin_lock_irqsave(&dev->lock, flags);
 	if (dev->state != STATE_DEV_OPENED) {
 		dev_dbg(dev->dev, "fail, device is not opened\n");
-		kfree(udc_driver_name);
-		kfree(udc_device_name);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -484,14 +504,25 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 	dev->driver.suspend = gadget_suspend;
 	dev->driver.resume = gadget_resume;
 	dev->driver.reset = gadget_reset;
-	dev->driver.driver.name = DRIVER_NAME;
+	dev->driver.driver.name = driver_driver_name;
 	dev->driver.udc_name = udc_device_name;
 	dev->driver.match_existing_only = 1;
+	dev->driver_id_number = driver_id_number;
 
 	dev->state = STATE_DEV_INITIALIZED;
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return ret;
 
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);
+out_free_udc_device_name:
+	kfree(udc_device_name);
+out_free_udc_driver_name:
+	kfree(udc_driver_name);
+out_free_driver_driver_name:
+	kfree(driver_driver_name);
+out_free_driver_id_number:
+	ida_free(&driver_id_numbers, driver_id_number);
 	return ret;
 }
 
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index f65f1ba2b592..fc322a9526c8 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -652,7 +652,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 	__must_hold(&xhci->lock)
 {
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index d57c5ff5ae1f..64173010d466 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -61,6 +61,8 @@
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI		0x464e
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI	0x51ed
+#define PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI		0xa71e
+#define PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI		0x7ec0
 
 #define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
@@ -270,7 +272,9 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2be38d9de8df..162d975b648c 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -779,6 +779,8 @@ static void xhci_stop(struct usb_hcd *hcd)
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	unsigned long flags;
+	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -794,12 +796,21 @@ void xhci_shutdown(struct usb_hcd *hcd)
 		del_timer_sync(&xhci->shared_hcd->rh_timer);
 	}
 
-	spin_lock_irq(&xhci->lock);
+	spin_lock_irqsave(&xhci->lock, flags);
 	xhci_halt(xhci);
+
+	/* Power off USB2 ports*/
+	for (i = 0; i < xhci->usb2_rhub.num_ports; i++)
+		xhci_set_port_power(xhci, xhci->main_hcd, i, false, &flags);
+
+	/* Power off USB3 ports*/
+	for (i = 0; i < xhci->usb3_rhub.num_ports; i++)
+		xhci_set_port_power(xhci, xhci->shared_hcd, i, false, &flags);
+
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
-	spin_unlock_irq(&xhci->lock);
+	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	xhci_cleanup_msix(xhci);
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 473a33ce299e..1f3f311d9951 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2172,6 +2172,8 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
+			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ed1e50d83cca..de59fa919540 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -252,10 +252,12 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_EG95			0x0195
 #define QUECTEL_PRODUCT_BG96			0x0296
 #define QUECTEL_PRODUCT_EP06			0x0306
+#define QUECTEL_PRODUCT_EM05G			0x030a
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
 #define QUECTEL_PRODUCT_EC200S_CN		0x6002
 #define QUECTEL_PRODUCT_EC200T			0x6026
+#define QUECTEL_PRODUCT_RM500K			0x7001
 
 #define CMOTECH_VENDOR_ID			0x16d8
 #define CMOTECH_PRODUCT_6001			0x6001
@@ -1134,6 +1136,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0, 0) },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0, 0) },
@@ -1147,6 +1151,7 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
 
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },
@@ -1279,6 +1284,7 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1231, 0xff),	/* Telit LE910Cx (RNDIS) */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x1250, 0xff, 0x00, 0x00) },	/* Telit LE910Cx (rmnet) */
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1260),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1261),
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 3506c47e1eef..40b1ab3d284d 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -436,22 +436,27 @@ static int pl2303_detect_type(struct usb_serial *serial)
 		break;
 	case 0x200:
 		switch (bcdDevice) {
-		case 0x100:
+		case 0x100:	/* GC */
 		case 0x105:
+			return TYPE_HXN;
+		case 0x300:	/* GT / TA */
+			if (pl2303_supports_hx_status(serial))
+				return TYPE_TA;
+			fallthrough;
 		case 0x305:
+		case 0x400:	/* GL */
 		case 0x405:
+			return TYPE_HXN;
+		case 0x500:	/* GE / TB */
+			if (pl2303_supports_hx_status(serial))
+				return TYPE_TB;
+			fallthrough;
+		case 0x505:
+		case 0x600:	/* GS */
 		case 0x605:
-			/*
-			 * Assume it's an HXN-type if the device doesn't
-			 * support the old read request value.
-			 */
-			if (!pl2303_supports_hx_status(serial))
-				return TYPE_HXN;
-			break;
-		case 0x300:
-			return TYPE_TA;
-		case 0x500:
-			return TYPE_TB;
+		case 0x700:	/* GR */
+		case 0x705:
+			return TYPE_HXN;
 		}
 		break;
 	}
diff --git a/drivers/usb/typec/tcpm/Kconfig b/drivers/usb/typec/tcpm/Kconfig
index 557f392fe24d..073fd2ea5e0b 100644
--- a/drivers/usb/typec/tcpm/Kconfig
+++ b/drivers/usb/typec/tcpm/Kconfig
@@ -56,7 +56,6 @@ config TYPEC_WCOVE
 	tristate "Intel WhiskeyCove PMIC USB Type-C PHY driver"
 	depends on ACPI
 	depends on MFD_INTEL_PMC_BXT
-	depends on INTEL_SOC_PMIC
 	depends on BXT_WC_PMIC_OPREGION
 	help
 	  This driver adds support for USB Type-C on Intel Broxton platforms
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index 6a947ff96d6e..19fd3389946d 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -1127,6 +1127,7 @@ int sti_call(const struct sti_struct *sti, unsigned long func,
 	return ret;
 }
 
+#if defined(CONFIG_FB_STI)
 /* check if given fb_info is the primary device */
 int fb_is_primary_device(struct fb_info *info)
 {
@@ -1142,6 +1143,7 @@ int fb_is_primary_device(struct fb_info *info)
 	return (sti->info == info);
 }
 EXPORT_SYMBOL(fb_is_primary_device);
+#endif
 
 MODULE_AUTHOR("Philipp Rumpf, Helge Deller, Thomas Bogendoerfer");
 MODULE_DESCRIPTION("Core STI driver for HP's NGLE series graphics cards in HP PARISC machines");
diff --git a/drivers/xen/features.c b/drivers/xen/features.c
index 7b591443833c..87f1828d40d5 100644
--- a/drivers/xen/features.c
+++ b/drivers/xen/features.c
@@ -42,7 +42,7 @@ void xen_setup_features(void)
 		if (HYPERVISOR_xen_version(XENVER_get_features, &fi) < 0)
 			break;
 		for (j = 0; j < 32; j++)
-			xen_features[i * 32 + j] = !!(fi.submap & 1<<j);
+			xen_features[i * 32 + j] = !!(fi.submap & 1U << j);
 	}
 
 	if (xen_pv_domain()) {
diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
index 20d7d059dadb..40ef379c28ab 100644
--- a/drivers/xen/gntdev-common.h
+++ b/drivers/xen/gntdev-common.h
@@ -16,6 +16,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/types.h>
 #include <xen/interface/event_channel.h>
+#include <xen/grant_table.h>
 
 struct gntdev_dmabuf_priv;
 
@@ -56,6 +57,7 @@ struct gntdev_grant_map {
 	struct gnttab_unmap_grant_ref *unmap_ops;
 	struct gnttab_map_grant_ref   *kmap_ops;
 	struct gnttab_unmap_grant_ref *kunmap_ops;
+	bool *being_removed;
 	struct page **pages;
 	unsigned long pages_vm_start;
 
@@ -73,6 +75,11 @@ struct gntdev_grant_map {
 	/* Needed to avoid allocation in gnttab_dma_free_pages(). */
 	xen_pfn_t *frames;
 #endif
+
+	/* Number of live grants */
+	atomic_t live_grants;
+	/* Needed to avoid allocation in __unmap_grant_pages */
+	struct gntab_unmap_queue_data unmap_data;
 };
 
 struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 59ffea800079..4b56c39f766d 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/refcount.h>
+#include <linux/workqueue.h>
 
 #include <xen/xen.h>
 #include <xen/grant_table.h>
@@ -60,10 +61,11 @@ module_param(limit, uint, 0644);
 MODULE_PARM_DESC(limit,
 	"Maximum number of grants that may be mapped by one mapping request");
 
+/* True in PV mode, false otherwise */
 static int use_ptemod;
 
-static int unmap_grant_pages(struct gntdev_grant_map *map,
-			     int offset, int pages);
+static void unmap_grant_pages(struct gntdev_grant_map *map,
+			      int offset, int pages);
 
 static struct miscdevice gntdev_miscdev;
 
@@ -120,6 +122,7 @@ static void gntdev_free_map(struct gntdev_grant_map *map)
 	kvfree(map->unmap_ops);
 	kvfree(map->kmap_ops);
 	kvfree(map->kunmap_ops);
+	kvfree(map->being_removed);
 	kfree(map);
 }
 
@@ -140,10 +143,13 @@ struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
 	add->unmap_ops = kvmalloc_array(count, sizeof(add->unmap_ops[0]),
 					GFP_KERNEL);
 	add->pages     = kvcalloc(count, sizeof(add->pages[0]), GFP_KERNEL);
+	add->being_removed =
+		kvcalloc(count, sizeof(add->being_removed[0]), GFP_KERNEL);
 	if (NULL == add->grants    ||
 	    NULL == add->map_ops   ||
 	    NULL == add->unmap_ops ||
-	    NULL == add->pages)
+	    NULL == add->pages     ||
+	    NULL == add->being_removed)
 		goto err;
 	if (use_ptemod) {
 		add->kmap_ops   = kvmalloc_array(count, sizeof(add->kmap_ops[0]),
@@ -250,9 +256,36 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 	if (!refcount_dec_and_test(&map->users))
 		return;
 
-	if (map->pages && !use_ptemod)
+	if (map->pages && !use_ptemod) {
+		/*
+		 * Increment the reference count.  This ensures that the
+		 * subsequent call to unmap_grant_pages() will not wind up
+		 * re-entering itself.  It *can* wind up calling
+		 * gntdev_put_map() recursively, but such calls will be with a
+		 * reference count greater than 1, so they will return before
+		 * this code is reached.  The recursion depth is thus limited to
+		 * 1.  Do NOT use refcount_inc() here, as it will detect that
+		 * the reference count is zero and WARN().
+		 */
+		refcount_set(&map->users, 1);
+
+		/*
+		 * Unmap the grants.  This may or may not be asynchronous, so it
+		 * is possible that the reference count is 1 on return, but it
+		 * could also be greater than 1.
+		 */
 		unmap_grant_pages(map, 0, map->count);
 
+		/* Check if the memory now needs to be freed */
+		if (!refcount_dec_and_test(&map->users))
+			return;
+
+		/*
+		 * All pages have been returned to the hypervisor, so free the
+		 * map.
+		 */
+	}
+
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
 		evtchn_put(map->notify.event);
@@ -283,6 +316,7 @@ static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
 
 int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 {
+	size_t alloced = 0;
 	int i, err = 0;
 
 	if (!use_ptemod) {
@@ -331,97 +365,116 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 			map->count);
 
 	for (i = 0; i < map->count; i++) {
-		if (map->map_ops[i].status == GNTST_okay)
+		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-		else if (!err)
+			if (!use_ptemod)
+				alloced++;
+		} else if (!err)
 			err = -EINVAL;
 
 		if (map->flags & GNTMAP_device_map)
 			map->unmap_ops[i].dev_bus_addr = map->map_ops[i].dev_bus_addr;
 
 		if (use_ptemod) {
-			if (map->kmap_ops[i].status == GNTST_okay)
+			if (map->kmap_ops[i].status == GNTST_okay) {
+				if (map->map_ops[i].status == GNTST_okay)
+					alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
-			else if (!err)
+			} else if (!err)
 				err = -EINVAL;
 		}
 	}
+	atomic_add(alloced, &map->live_grants);
 	return err;
 }
 
-static int __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			       int pages)
+static void __unmap_grant_pages_done(int result,
+		struct gntab_unmap_queue_data *data)
 {
-	int i, err = 0;
-	struct gntab_unmap_queue_data unmap_data;
-
-	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
-		int pgno = (map->notify.addr >> PAGE_SHIFT);
-		if (pgno >= offset && pgno < offset + pages) {
-			/* No need for kmap, pages are in lowmem */
-			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
-			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
-			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
-		}
-	}
-
-	unmap_data.unmap_ops = map->unmap_ops + offset;
-	unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
-	unmap_data.pages = map->pages + offset;
-	unmap_data.count = pages;
-
-	err = gnttab_unmap_refs_sync(&unmap_data);
-	if (err)
-		return err;
+	unsigned int i;
+	struct gntdev_grant_map *map = data->data;
+	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
-	for (i = 0; i < pages; i++) {
-		if (map->unmap_ops[offset+i].status)
-			err = -EINVAL;
+	for (i = 0; i < data->count; i++) {
+		WARN_ON(map->unmap_ops[offset+i].status);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			if (map->kunmap_ops[offset+i].status)
-				err = -EINVAL;
+			WARN_ON(map->kunmap_ops[offset+i].status);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);
 			map->kunmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		}
 	}
-	return err;
+	/*
+	 * Decrease the live-grant counter.  This must happen after the loop to
+	 * prevent premature reuse of the grants by gnttab_mmap().
+	 */
+	atomic_sub(data->count, &map->live_grants);
+
+	/* Release reference taken by __unmap_grant_pages */
+	gntdev_put_map(NULL, map);
+}
+
+static void __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			       int pages)
+{
+	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
+		int pgno = (map->notify.addr >> PAGE_SHIFT);
+
+		if (pgno >= offset && pgno < offset + pages) {
+			/* No need for kmap, pages are in lowmem */
+			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
+
+			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
+			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
+		}
+	}
+
+	map->unmap_data.unmap_ops = map->unmap_ops + offset;
+	map->unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
+	map->unmap_data.pages = map->pages + offset;
+	map->unmap_data.count = pages;
+	map->unmap_data.done = __unmap_grant_pages_done;
+	map->unmap_data.data = map;
+	refcount_inc(&map->users); /* to keep map alive during async call below */
+
+	gnttab_unmap_refs_async(&map->unmap_data);
 }
 
-static int unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			     int pages)
+static void unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			      int pages)
 {
-	int range, err = 0;
+	int range;
+
+	if (atomic_read(&map->live_grants) == 0)
+		return; /* Nothing to do */
 
 	pr_debug("unmap %d+%d [%d+%d]\n", map->index, map->count, offset, pages);
 
 	/* It is possible the requested range will have a "hole" where we
 	 * already unmapped some of the grants. Only unmap valid ranges.
 	 */
-	while (pages && !err) {
-		while (pages &&
-		       map->unmap_ops[offset].handle == INVALID_GRANT_HANDLE) {
+	while (pages) {
+		while (pages && map->being_removed[offset]) {
 			offset++;
 			pages--;
 		}
 		range = 0;
 		while (range < pages) {
-			if (map->unmap_ops[offset + range].handle ==
-			    INVALID_GRANT_HANDLE)
+			if (map->being_removed[offset + range])
 				break;
+			map->being_removed[offset + range] = true;
 			range++;
 		}
-		err = __unmap_grant_pages(map, offset, range);
+		if (range)
+			__unmap_grant_pages(map, offset, range);
 		offset += range;
 		pages -= range;
 	}
-
-	return err;
 }
 
 /* ------------------------------------------------------------------ */
@@ -473,7 +526,6 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 	struct gntdev_grant_map *map =
 		container_of(mn, struct gntdev_grant_map, notifier);
 	unsigned long mstart, mend;
-	int err;
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
@@ -494,10 +546,9 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 			map->index, map->count,
 			map->vma->vm_start, map->vma->vm_end,
 			range->start, range->end, mstart, mend);
-	err = unmap_grant_pages(map,
+	unmap_grant_pages(map,
 				(mstart - map->vma->vm_start) >> PAGE_SHIFT,
 				(mend - mstart) >> PAGE_SHIFT);
-	WARN_ON(err);
 
 	return true;
 }
@@ -985,6 +1036,10 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		goto unlock_out;
 	if (use_ptemod && map->vma)
 		goto unlock_out;
+	if (atomic_read(&map->live_grants)) {
+		err = -EAGAIN;
+		goto unlock_out;
+	}
 	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 79df61fe0e59..baf2b152229e 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -152,7 +152,7 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 	const unsigned char **wnames, *uname;
 	int i, n, l, clone, access;
 	struct v9fs_session_info *v9ses;
-	struct p9_fid *fid, *old_fid = NULL;
+	struct p9_fid *fid, *old_fid;
 
 	v9ses = v9fs_dentry2v9ses(dentry);
 	access = v9ses->flags & V9FS_ACCESS_MASK;
@@ -194,13 +194,12 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 		if (IS_ERR(fid))
 			return fid;
 
+		refcount_inc(&fid->count);
 		v9fs_fid_add(dentry->d_sb->s_root, fid);
 	}
 	/* If we are root ourself just return that */
-	if (dentry->d_sb->s_root == dentry) {
-		refcount_inc(&fid->count);
+	if (dentry->d_sb->s_root == dentry)
 		return fid;
-	}
 	/*
 	 * Do a multipath walk with attached root.
 	 * When walking parent we need to make sure we
@@ -212,6 +211,7 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 		fid = ERR_PTR(n);
 		goto err_out;
 	}
+	old_fid = fid;
 	clone = 1;
 	i = 0;
 	while (i < n) {
@@ -221,19 +221,15 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 		 * walk to ensure none of the patch component change
 		 */
 		fid = p9_client_walk(fid, l, &wnames[i], clone);
+		/* non-cloning walk will return the same fid */
+		if (fid != old_fid) {
+			p9_client_clunk(old_fid);
+			old_fid = fid;
+		}
 		if (IS_ERR(fid)) {
-			if (old_fid) {
-				/*
-				 * If we fail, clunk fid which are mapping
-				 * to path component and not the last component
-				 * of the path.
-				 */
-				p9_client_clunk(old_fid);
-			}
 			kfree(wnames);
 			goto err_out;
 		}
-		old_fid = fid;
 		i += l;
 		clone = 0;
 	}
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 595875228672..a58c554b4070 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -58,8 +58,21 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
  */
 static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
+	struct inode *inode = file_inode(file);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 	struct p9_fid *fid = file->private_data;
 
+	BUG_ON(!fid);
+
+	/* we might need to read from a fid that was opened write-only
+	 * for read-modify-write of page cache, use the writeback fid
+	 * for that */
+	if (rreq->origin == NETFS_READ_FOR_WRITE &&
+			(fid->mode & O_ACCMODE) == O_WRONLY) {
+		fid = v9inode->writeback_fid;
+		BUG_ON(!fid);
+	}
+
 	refcount_inc(&fid->count);
 	rreq->netfs_priv = fid;
 	return 0;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e660c6348b9d..d4b705a866ea 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1250,15 +1250,15 @@ static const char *v9fs_vfs_get_link(struct dentry *dentry,
 		return ERR_PTR(-ECHILD);
 
 	v9ses = v9fs_dentry2v9ses(dentry);
-	fid = v9fs_fid_lookup(dentry);
+	if (!v9fs_proto_dotu(v9ses))
+		return ERR_PTR(-EBADF);
+
 	p9_debug(P9_DEBUG_VFS, "%pd\n", dentry);
+	fid = v9fs_fid_lookup(dentry);
 
 	if (IS_ERR(fid))
 		return ERR_CAST(fid);
 
-	if (!v9fs_proto_dotu(v9ses))
-		return ERR_PTR(-EBADF);
-
 	st = p9_client_stat(fid);
 	p9_client_clunk(fid);
 	if (IS_ERR(st))
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index d17502a738a9..b6eb1160296c 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -274,6 +274,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(ofid)) {
 		err = PTR_ERR(ofid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
+		p9_client_clunk(dfid);
 		goto out;
 	}
 
@@ -285,6 +286,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (err) {
 		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	err = p9_client_create_dotl(ofid, name, v9fs_open_to_dotl_flags(flags),
@@ -292,6 +294,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_open_dotl failed in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	v9fs_invalidate_inode_attr(dir);
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 22811e9eacf5..c4c9f6dff0a2 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -745,7 +745,8 @@ int afs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
-	if (!(query_flags & AT_STATX_DONT_SYNC) &&
+	if (vnode->volume &&
+	    !(query_flags & AT_STATX_DONT_SYNC) &&
 	    !test_bit(AFS_VNODE_CB_PROMISED, &vnode->flags)) {
 		key = afs_request_key(vnode->volume->cell);
 		if (IS_ERR(key))
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 30d0bbfdb3bc..6f30413ed9a9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4639,6 +4639,17 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	int ret;
 
 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
+
+	/*
+	 * We may have the reclaim task running and relocating a data block group,
+	 * in which case it may create delayed iputs. So stop it before we park
+	 * the cleaner kthread otherwise we can get new delayed iputs after
+	 * parking the cleaner, and that can make the async reclaim task to hang
+	 * if it's waiting for delayed iputs to complete, since the cleaner is
+	 * parked and can not run delayed iputs - this will make us hang when
+	 * trying to stop the async reclaim task.
+	 */
+	cancel_work_sync(&fs_info->reclaim_bgs_work);
 	/*
 	 * We don't want the cleaner to start new transactions, add more delayed
 	 * iputs, etc. while we're closing. We can't use kthread_stop() yet
@@ -4679,8 +4690,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	cancel_work_sync(&fs_info->async_data_reclaim_work);
 	cancel_work_sync(&fs_info->preempt_reclaim_work);
 
-	cancel_work_sync(&fs_info->reclaim_bgs_work);
-
 	/* Cancel or finish ongoing discard work */
 	btrfs_discard_cleanup(fs_info);
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 380054c94e4b..153920acd226 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2359,25 +2359,62 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_MMAP);
 
-	if (ret != BTRFS_NO_LOG_SYNC) {
+	if (ret == BTRFS_NO_LOG_SYNC) {
+		ret = btrfs_end_transaction(trans);
+		goto out;
+	}
+
+	/* We successfully logged the inode, attempt to sync the log. */
+	if (!ret) {
+		ret = btrfs_sync_log(trans, root, &ctx);
 		if (!ret) {
-			ret = btrfs_sync_log(trans, root, &ctx);
-			if (!ret) {
-				ret = btrfs_end_transaction(trans);
-				goto out;
-			}
-		}
-		if (!full_sync) {
-			ret = btrfs_wait_ordered_range(inode, start, len);
-			if (ret) {
-				btrfs_end_transaction(trans);
-				goto out;
-			}
+			ret = btrfs_end_transaction(trans);
+			goto out;
 		}
-		ret = btrfs_commit_transaction(trans);
-	} else {
+	}
+
+	/*
+	 * At this point we need to commit the transaction because we had
+	 * btrfs_need_log_full_commit() or some other error.
+	 *
+	 * If we didn't do a full sync we have to stop the trans handle, wait on
+	 * the ordered extents, start it again and commit the transaction.  If
+	 * we attempt to wait on the ordered extents here we could deadlock with
+	 * something like fallocate() that is holding the extent lock trying to
+	 * start a transaction while some other thread is trying to commit the
+	 * transaction while we (fsync) are currently holding the transaction
+	 * open.
+	 */
+	if (!full_sync) {
 		ret = btrfs_end_transaction(trans);
+		if (ret)
+			goto out;
+		ret = btrfs_wait_ordered_range(inode, start, len);
+		if (ret)
+			goto out;
+
+		/*
+		 * This is safe to use here because we're only interested in
+		 * making sure the transaction that had the ordered extents is
+		 * committed.  We aren't waiting on anything past this point,
+		 * we're purely getting the transaction and committing it.
+		 */
+		trans = btrfs_attach_transaction_barrier(root);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+
+			/*
+			 * We committed the transaction and there's no currently
+			 * running transaction, this means everything we care
+			 * about made it to disk and we are done.
+			 */
+			if (ret == -ENOENT)
+				ret = 0;
+			goto out;
+		}
 	}
+
+	ret = btrfs_commit_transaction(trans);
 out:
 	ASSERT(list_empty(&ctx.list));
 	err = file_check_and_advance_wb_err(file);
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 313d9d685adb..33461b4f9c8b 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -45,7 +45,6 @@ void __btrfs_tree_read_lock(struct extent_buffer *eb, enum btrfs_lock_nesting ne
 		start_ns = ktime_get_ns();
 
 	down_read_nested(&eb->lock, nest);
-	eb->lock_owner = current->pid;
 	trace_btrfs_tree_read_lock(eb, start_ns);
 }
 
@@ -62,7 +61,6 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 {
 	if (down_read_trylock(&eb->lock)) {
-		eb->lock_owner = current->pid;
 		trace_btrfs_try_tree_read_lock(eb);
 		return 1;
 	}
@@ -90,7 +88,6 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 void btrfs_tree_read_unlock(struct extent_buffer *eb)
 {
 	trace_btrfs_tree_read_unlock(eb);
-	eb->lock_owner = 0;
 	up_read(&eb->lock);
 }
 
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 998e3f180d90..6db7f50de84d 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -344,6 +344,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	int ret;
 	const u64 len = olen_aligned;
 	u64 last_dest_end = destoff;
+	u64 prev_extent_end = off;
 
 	ret = -ENOMEM;
 	buf = kvmalloc(fs_info->nodesize, GFP_KERNEL);
@@ -363,7 +364,6 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	key.offset = off;
 
 	while (1) {
-		u64 next_key_min_offset = key.offset + 1;
 		struct btrfs_file_extent_item *extent;
 		u64 extent_gen;
 		int type;
@@ -431,14 +431,21 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		 * The first search might have left us at an extent item that
 		 * ends before our target range's start, can happen if we have
 		 * holes and NO_HOLES feature enabled.
+		 *
+		 * Subsequent searches may leave us on a file range we have
+		 * processed before - this happens due to a race with ordered
+		 * extent completion for a file range that is outside our source
+		 * range, but that range was part of a file extent item that
+		 * also covered a leading part of our source range.
 		 */
-		if (key.offset + datal <= off) {
+		if (key.offset + datal <= prev_extent_end) {
 			path->slots[0]++;
 			goto process_slot;
 		} else if (key.offset >= off + len) {
 			break;
 		}
-		next_key_min_offset = key.offset + datal;
+
+		prev_extent_end = key.offset + datal;
 		size = btrfs_item_size(leaf, slot);
 		read_extent_buffer(leaf, buf, btrfs_item_ptr_offset(leaf, slot),
 				   size);
@@ -550,7 +557,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			break;
 
 		btrfs_release_path(path);
-		key.offset = next_key_min_offset;
+		key.offset = prev_extent_end;
 
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b228efe8ab6e..0b2a387615f6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -763,6 +763,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				compress_force = false;
 				no_compress++;
 			} else {
+				btrfs_err(info, "unrecognized compression value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -821,8 +823,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_thread_pool:
 			ret = match_int(&args[0], &intarg);
 			if (ret) {
+				btrfs_err(info, "unrecognized thread_pool value %s",
+					  args[0].from);
 				goto out;
 			} else if (intarg == 0) {
+				btrfs_err(info, "invalid value 0 for thread_pool");
 				ret = -EINVAL;
 				goto out;
 			}
@@ -883,8 +888,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			break;
 		case Opt_ratio:
 			ret = match_int(&args[0], &intarg);
-			if (ret)
+			if (ret) {
+				btrfs_err(info, "unrecognized metadata_ratio value %s",
+					  args[0].from);
 				goto out;
+			}
 			info->metadata_ratio = intarg;
 			btrfs_info(info, "metadata ratio %u",
 				   info->metadata_ratio);
@@ -901,6 +909,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_set_and_info(info, DISCARD_ASYNC,
 						   "turning on async discard");
 			} else {
+				btrfs_err(info, "unrecognized discard mode value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -933,6 +943,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_set_and_info(info, FREE_SPACE_TREE,
 						   "enabling free space tree");
 			} else {
+				btrfs_err(info, "unrecognized space_cache value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1014,8 +1026,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			break;
 		case Opt_check_integrity_print_mask:
 			ret = match_int(&args[0], &intarg);
-			if (ret)
+			if (ret) {
+				btrfs_err(info,
+				"unrecognized check_integrity_print_mask value %s",
+					args[0].from);
 				goto out;
+			}
 			info->check_integrity_print_mask = intarg;
 			btrfs_info(info, "check_integrity_print_mask 0x%x",
 				   info->check_integrity_print_mask);
@@ -1030,13 +1046,15 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			goto out;
 #endif
 		case Opt_fatal_errors:
-			if (strcmp(args[0].from, "panic") == 0)
+			if (strcmp(args[0].from, "panic") == 0) {
 				btrfs_set_opt(info->mount_opt,
 					      PANIC_ON_FATAL_ERROR);
-			else if (strcmp(args[0].from, "bug") == 0)
+			} else if (strcmp(args[0].from, "bug") == 0) {
 				btrfs_clear_opt(info->mount_opt,
 					      PANIC_ON_FATAL_ERROR);
-			else {
+			} else {
+				btrfs_err(info, "unrecognized fatal_errors value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1044,8 +1062,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_commit_interval:
 			intarg = 0;
 			ret = match_int(&args[0], &intarg);
-			if (ret)
+			if (ret) {
+				btrfs_err(info, "unrecognized commit_interval value %s",
+					  args[0].from);
+				ret = -EINVAL;
 				goto out;
+			}
 			if (intarg == 0) {
 				btrfs_info(info,
 					   "using default commit interval %us",
@@ -1059,8 +1081,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			break;
 		case Opt_rescue:
 			ret = parse_rescue_options(info, args[0].from);
-			if (ret < 0)
+			if (ret < 0) {
+				btrfs_err(info, "unrecognized rescue value %s",
+					  args[0].from);
 				goto out;
+			}
 			break;
 #ifdef CONFIG_BTRFS_DEBUG
 		case Opt_fragment_all:
@@ -1986,6 +2011,14 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	if (ret)
 		goto restore;
 
+	/* V1 cache is not supported for subpage mount. */
+	if (fs_info->sectorsize < PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
+		btrfs_warn(fs_info,
+	"v1 space cache is not supported for page size %lu with sectorsize %u",
+			   PAGE_SIZE, fs_info->sectorsize);
+		ret = -EINVAL;
+		goto restore;
+	}
 	btrfs_remount_begin(fs_info, old_opts, *flags);
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 179c1630bf56..6a8a00f28b19 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -543,6 +543,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 		      struct TCP_Server_Info *server, unsigned int *total_len)
 {
 	char *pneg_ctxt;
+	char *hostname = NULL;
 	unsigned int ctxt_len, neg_context_count;
 
 	if (*total_len > 200) {
@@ -570,16 +571,24 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	*total_len += ctxt_len;
 	pneg_ctxt += ctxt_len;
 
-	ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
-					server->hostname);
-	*total_len += ctxt_len;
-	pneg_ctxt += ctxt_len;
-
 	build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
 	*total_len += sizeof(struct smb2_posix_neg_context);
 	pneg_ctxt += sizeof(struct smb2_posix_neg_context);
 
-	neg_context_count = 4;
+	/*
+	 * secondary channels don't have the hostname field populated
+	 * use the hostname field in the primary channel instead
+	 */
+	hostname = CIFS_SERVER_IS_CHAN(server) ?
+		server->primary_server->hostname : server->hostname;
+	if (hostname && (hostname[0] != 0)) {
+		ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
+					      hostname);
+		*total_len += ctxt_len;
+		pneg_ctxt += ctxt_len;
+		neg_context_count = 4;
+	} else /* second channels do not have a hostname */
+		neg_context_count = 3;
 
 	if (server->compress_algorithm) {
 		build_compression_ctxt((struct smb2_compression_capabilities_context *)
diff --git a/fs/f2fs/iostat.c b/fs/f2fs/iostat.c
index be599f31d3c4..d84c5f6cc09d 100644
--- a/fs/f2fs/iostat.c
+++ b/fs/f2fs/iostat.c
@@ -91,8 +91,9 @@ static inline void __record_iostat_latency(struct f2fs_sb_info *sbi)
 	unsigned int cnt;
 	struct f2fs_iostat_latency iostat_lat[MAX_IO_TYPE][NR_PAGE_TYPE];
 	struct iostat_lat_info *io_lat = sbi->iostat_io_lat;
+	unsigned long flags;
 
-	spin_lock_bh(&sbi->iostat_lat_lock);
+	spin_lock_irqsave(&sbi->iostat_lat_lock, flags);
 	for (idx = 0; idx < MAX_IO_TYPE; idx++) {
 		for (io = 0; io < NR_PAGE_TYPE; io++) {
 			cnt = io_lat->bio_cnt[idx][io];
@@ -106,7 +107,7 @@ static inline void __record_iostat_latency(struct f2fs_sb_info *sbi)
 			io_lat->bio_cnt[idx][io] = 0;
 		}
 	}
-	spin_unlock_bh(&sbi->iostat_lat_lock);
+	spin_unlock_irqrestore(&sbi->iostat_lat_lock, flags);
 
 	trace_f2fs_iostat_latency(sbi, iostat_lat);
 }
@@ -115,14 +116,15 @@ static inline void f2fs_record_iostat(struct f2fs_sb_info *sbi)
 {
 	unsigned long long iostat_diff[NR_IO_TYPE];
 	int i;
+	unsigned long flags;
 
 	if (time_is_after_jiffies(sbi->iostat_next_period))
 		return;
 
 	/* Need double check under the lock */
-	spin_lock_bh(&sbi->iostat_lock);
+	spin_lock_irqsave(&sbi->iostat_lock, flags);
 	if (time_is_after_jiffies(sbi->iostat_next_period)) {
-		spin_unlock_bh(&sbi->iostat_lock);
+		spin_unlock_irqrestore(&sbi->iostat_lock, flags);
 		return;
 	}
 	sbi->iostat_next_period = jiffies +
@@ -133,7 +135,7 @@ static inline void f2fs_record_iostat(struct f2fs_sb_info *sbi)
 				sbi->prev_rw_iostat[i];
 		sbi->prev_rw_iostat[i] = sbi->rw_iostat[i];
 	}
-	spin_unlock_bh(&sbi->iostat_lock);
+	spin_unlock_irqrestore(&sbi->iostat_lock, flags);
 
 	trace_f2fs_iostat(sbi, iostat_diff);
 
@@ -145,25 +147,27 @@ void f2fs_reset_iostat(struct f2fs_sb_info *sbi)
 	struct iostat_lat_info *io_lat = sbi->iostat_io_lat;
 	int i;
 
-	spin_lock_bh(&sbi->iostat_lock);
+	spin_lock_irq(&sbi->iostat_lock);
 	for (i = 0; i < NR_IO_TYPE; i++) {
 		sbi->rw_iostat[i] = 0;
 		sbi->prev_rw_iostat[i] = 0;
 	}
-	spin_unlock_bh(&sbi->iostat_lock);
+	spin_unlock_irq(&sbi->iostat_lock);
 
-	spin_lock_bh(&sbi->iostat_lat_lock);
+	spin_lock_irq(&sbi->iostat_lat_lock);
 	memset(io_lat, 0, sizeof(struct iostat_lat_info));
-	spin_unlock_bh(&sbi->iostat_lat_lock);
+	spin_unlock_irq(&sbi->iostat_lat_lock);
 }
 
 void f2fs_update_iostat(struct f2fs_sb_info *sbi,
 			enum iostat_type type, unsigned long long io_bytes)
 {
+	unsigned long flags;
+
 	if (!sbi->iostat_enable)
 		return;
 
-	spin_lock_bh(&sbi->iostat_lock);
+	spin_lock_irqsave(&sbi->iostat_lock, flags);
 	sbi->rw_iostat[type] += io_bytes;
 
 	if (type == APP_BUFFERED_IO || type == APP_DIRECT_IO)
@@ -172,7 +176,7 @@ void f2fs_update_iostat(struct f2fs_sb_info *sbi,
 	if (type == APP_BUFFERED_READ_IO || type == APP_DIRECT_READ_IO)
 		sbi->rw_iostat[APP_READ_IO] += io_bytes;
 
-	spin_unlock_bh(&sbi->iostat_lock);
+	spin_unlock_irqrestore(&sbi->iostat_lock, flags);
 
 	f2fs_record_iostat(sbi);
 }
@@ -185,6 +189,7 @@ static inline void __update_iostat_latency(struct bio_iostat_ctx *iostat_ctx,
 	struct f2fs_sb_info *sbi = iostat_ctx->sbi;
 	struct iostat_lat_info *io_lat = sbi->iostat_io_lat;
 	int idx;
+	unsigned long flags;
 
 	if (!sbi->iostat_enable)
 		return;
@@ -202,12 +207,12 @@ static inline void __update_iostat_latency(struct bio_iostat_ctx *iostat_ctx,
 			idx = WRITE_ASYNC_IO;
 	}
 
-	spin_lock_bh(&sbi->iostat_lat_lock);
+	spin_lock_irqsave(&sbi->iostat_lat_lock, flags);
 	io_lat->sum_lat[idx][iotype] += ts_diff;
 	io_lat->bio_cnt[idx][iotype]++;
 	if (ts_diff > io_lat->peak_lat[idx][iotype])
 		io_lat->peak_lat[idx][iotype] = ts_diff;
-	spin_unlock_bh(&sbi->iostat_lat_lock);
+	spin_unlock_irqrestore(&sbi->iostat_lat_lock, flags);
 }
 
 void iostat_update_and_unbind_ctx(struct bio *bio, int rw)
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index fffafd2aa438..3764e12f19db 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -92,8 +92,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 	if (test_opt(sbi, INLINE_XATTR))
 		set_inode_flag(inode, FI_INLINE_XATTR);
 
-	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
-		set_inode_flag(inode, FI_INLINE_DATA);
 	if (f2fs_may_inline_dentry(inode))
 		set_inode_flag(inode, FI_INLINE_DENTRY);
 
@@ -110,10 +108,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 
 	f2fs_init_extent_tree(inode, NULL);
 
-	stat_inc_inline_xattr(inode);
-	stat_inc_inline_inode(inode);
-	stat_inc_inline_dir(inode);
-
 	F2FS_I(inode)->i_flags =
 		f2fs_mask_flags(mode, F2FS_I(dir)->i_flags & F2FS_FL_INHERITED);
 
@@ -130,6 +124,14 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 			set_compress_context(inode);
 	}
 
+	/* Should enable inline_data after compression set */
+	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
+		set_inode_flag(inode, FI_INLINE_DATA);
+
+	stat_inc_inline_xattr(inode);
+	stat_inc_inline_inode(inode);
+	stat_inc_inline_dir(inode);
+
 	f2fs_set_inode_flags(inode);
 
 	trace_f2fs_new_inode(inode, 0);
@@ -328,6 +330,9 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
 		if (!is_extension_exist(name, ext[i], false))
 			continue;
 
+		/* Do not use inline_data with compression */
+		stat_dec_inline_inode(inode);
+		clear_inode_flag(inode, FI_INLINE_DATA);
 		set_compress_context(inode);
 		return;
 	}
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a8d0fa2731cb..aedc3d334113 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1454,7 +1454,9 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 out_err:
 	ClearPageUptodate(page);
 out_put_err:
-	f2fs_handle_page_eio(sbi, page->index, NODE);
+	/* ENOENT comes from read_node_page which is not an error. */
+	if (err != -ENOENT)
+		f2fs_handle_page_eio(sbi, page->index, NODE);
 	f2fs_put_page(page, 1);
 	return ERR_PTR(err);
 }
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 68aab48838e4..e4186635aaa8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -926,7 +926,7 @@ struct io_kiocb {
 		/* used by request caches, completion batching and iopoll */
 		struct io_wq_work_node	comp_list;
 		/* cache ->apoll->events */
-		int apoll_events;
+		__poll_t apoll_events;
 	};
 	atomic_t			refs;
 	atomic_t			poll_refs;
@@ -5984,7 +5984,8 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, ret);
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
+static void __io_poll_execute(struct io_kiocb *req, int mask,
+			      __poll_t __maybe_unused events)
 {
 	req->result = mask;
 	/*
@@ -5993,7 +5994,6 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
 	 * CPU. We want to avoid pulling in req->apoll->events for that
 	 * case.
 	 */
-	req->apoll_events = events;
 	if (req->opcode == IORING_OP_POLL_ADD)
 		req->io_task_work.func = io_poll_task_func;
 	else
@@ -6003,7 +6003,8 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
 	io_req_task_work_add(req, false);
 }
 
-static inline void io_poll_execute(struct io_kiocb *req, int res, int events)
+static inline void io_poll_execute(struct io_kiocb *req, int res,
+		__poll_t events)
 {
 	if (io_poll_get_ownership(req))
 		__io_poll_execute(req, res, events);
@@ -6142,6 +6143,8 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
 
+	req->apoll_events = poll->events;
+
 	ipt->pt._key = mask;
 	ipt->req = req;
 	ipt->error = 0;
@@ -6172,8 +6175,11 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	if (mask) {
 		/* can't multishot if failed, just queue the event we've got */
-		if (unlikely(ipt->error || !ipt->nr_entries))
+		if (unlikely(ipt->error || !ipt->nr_entries)) {
 			poll->events |= EPOLLONESHOT;
+			req->apoll_events |= EPOLLONESHOT;
+			ipt->error = 0;
+		}
 		__io_poll_execute(req, mask, poll->events);
 		return 0;
 	}
@@ -6386,7 +6392,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EINVAL;
 
 	io_req_set_refcount(req);
-	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
+	poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
 
@@ -6399,6 +6405,8 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	ipt.pt._qproc = io_poll_queue_proc;
 
 	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
+	if (!ret && ipt.error)
+		req_set_fail(req);
 	ret = ret ?: ipt.error;
 	if (ret)
 		__io_req_complete(req, issue_flags, ret, 0);
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 6f1b8ddc6f7a..54dda2e19ed1 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -26,6 +26,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <linux/cc_platform.h>
 #include <asm/io.h>
 #include "internal.h"
@@ -128,9 +129,8 @@ static int open_vmcore(struct inode *inode, struct file *file)
 }
 
 /* Reads a page from the oldmem device from given offset. */
-ssize_t read_from_oldmem(char *buf, size_t count,
-			 u64 *ppos, int userbuf,
-			 bool encrypted)
+static ssize_t read_from_oldmem_iter(struct iov_iter *iter, size_t count,
+			 u64 *ppos, bool encrypted)
 {
 	unsigned long pfn, offset;
 	size_t nr_bytes;
@@ -152,29 +152,23 @@ ssize_t read_from_oldmem(char *buf, size_t count,
 
 		/* If pfn is not ram, return zeros for sparse dump files */
 		if (!pfn_is_ram(pfn)) {
-			tmp = 0;
-			if (!userbuf)
-				memset(buf, 0, nr_bytes);
-			else if (clear_user(buf, nr_bytes))
-				tmp = -EFAULT;
+			tmp = iov_iter_zero(nr_bytes, iter);
 		} else {
 			if (encrypted)
-				tmp = copy_oldmem_page_encrypted(pfn, buf,
+				tmp = copy_oldmem_page_encrypted(iter, pfn,
 								 nr_bytes,
-								 offset,
-								 userbuf);
+								 offset);
 			else
-				tmp = copy_oldmem_page(pfn, buf, nr_bytes,
-						       offset, userbuf);
+				tmp = copy_oldmem_page(iter, pfn, nr_bytes,
+						       offset);
 		}
-		if (tmp < 0) {
+		if (tmp < nr_bytes) {
 			srcu_read_unlock(&vmcore_cb_srcu, idx);
-			return tmp;
+			return -EFAULT;
 		}
 
 		*ppos += nr_bytes;
 		count -= nr_bytes;
-		buf += nr_bytes;
 		read += nr_bytes;
 		++pfn;
 		offset = 0;
@@ -184,6 +178,27 @@ ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
+ssize_t read_from_oldmem(char *buf, size_t count,
+			 u64 *ppos, int userbuf,
+			 bool encrypted)
+{
+	struct iov_iter iter;
+	struct iovec iov;
+	struct kvec kvec;
+
+	if (userbuf) {
+		iov.iov_base = (__force void __user *)buf;
+		iov.iov_len = count;
+		iov_iter_init(&iter, READ, &iov, 1, count);
+	} else {
+		kvec.iov_base = buf;
+		kvec.iov_len = count;
+		iov_iter_kvec(&iter, READ, &kvec, 1, count);
+	}
+
+	return read_from_oldmem_iter(&iter, count, ppos, encrypted);
+}
+
 /*
  * Architectures may override this function to allocate ELF header in 2nd kernel
  */
@@ -228,11 +243,10 @@ int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
 /*
  * Architectures which support memory encryption override this.
  */
-ssize_t __weak
-copy_oldmem_page_encrypted(unsigned long pfn, char *buf, size_t csize,
-			   unsigned long offset, int userbuf)
+ssize_t __weak copy_oldmem_page_encrypted(struct iov_iter *iter,
+		unsigned long pfn, size_t csize, unsigned long offset)
 {
-	return copy_oldmem_page(pfn, buf, csize, offset, userbuf);
+	return copy_oldmem_page(iter, pfn, csize, offset);
 }
 
 /*
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 620821549b23..a1cf7d5c03c7 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -24,11 +24,10 @@ extern int remap_oldmem_pfn_range(struct vm_area_struct *vma,
 				  unsigned long from, unsigned long pfn,
 				  unsigned long size, pgprot_t prot);
 
-extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
-						unsigned long, int);
-extern ssize_t copy_oldmem_page_encrypted(unsigned long pfn, char *buf,
-					  size_t csize, unsigned long offset,
-					  int userbuf);
+ssize_t copy_oldmem_page(struct iov_iter *i, unsigned long pfn, size_t csize,
+		unsigned long offset);
+ssize_t copy_oldmem_page_encrypted(struct iov_iter *iter, unsigned long pfn,
+				   size_t csize, unsigned long offset);
 
 void vmcore_cleanup(void);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b0183450e484..da08cce2a9fa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3188,6 +3188,7 @@ enum mf_flags {
 	MF_MUST_KILL = 1 << 2,
 	MF_SOFT_OFFLINE = 1 << 3,
 	MF_UNPOISON = 1 << 4,
+	MF_SW_SIMULATED = 1 << 5,
 };
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
diff --git a/include/linux/ratelimit_types.h b/include/linux/ratelimit_types.h
index c21c7f8103e2..002266693e50 100644
--- a/include/linux/ratelimit_types.h
+++ b/include/linux/ratelimit_types.h
@@ -23,12 +23,16 @@ struct ratelimit_state {
 	unsigned long	flags;
 };
 
-#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) {		\
-		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
-		.interval	= interval_init,			\
-		.burst		= burst_init,				\
+#define RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, flags_init) { \
+		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),		  \
+		.interval	= interval_init,				  \
+		.burst		= burst_init,					  \
+		.flags		= flags_init,					  \
 	}
 
+#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) \
+	RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, 0)
+
 #define RATELIMIT_STATE_INIT_DISABLED					\
 	RATELIMIT_STATE_INIT(ratelimit_state, 0, DEFAULT_RATELIMIT_BURST)
 
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 234d70ae5f4c..48e4c59d85e2 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -252,6 +252,11 @@ struct inet_sock {
 #define IP_CMSG_CHECKSUM	BIT(7)
 #define IP_CMSG_RECVFRAGSIZE	BIT(8)
 
+static inline bool sk_is_inet(struct sock *sk)
+{
+	return sk->sk_family == AF_INET || sk->sk_family == AF_INET6;
+}
+
 /**
  * sk_to_full_sk - Access to a full socket
  * @sk: pointer to a socket
diff --git a/include/trace/events/libata.h b/include/trace/events/libata.h
index d4e631aa976f..6025dd8ba4aa 100644
--- a/include/trace/events/libata.h
+++ b/include/trace/events/libata.h
@@ -288,6 +288,7 @@ DECLARE_EVENT_CLASS(ata_qc_complete_template,
 		__entry->hob_feature	= qc->result_tf.hob_feature;
 		__entry->nsect		= qc->result_tf.nsect;
 		__entry->hob_nsect	= qc->result_tf.hob_nsect;
+		__entry->flags		= qc->flags;
 	),
 
 	TP_printk("ata_port=%u ata_dev=%u tag=%d flags=%s status=%s " \
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index e978f36e6be8..8d0b68a17042 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -357,7 +357,7 @@ void dma_direct_free(struct device *dev, size_t size,
 	} else {
 		if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_CLEAR_UNCACHED))
 			arch_dma_clear_uncached(cpu_addr, size);
-		if (dma_set_encrypted(dev, cpu_addr, 1 << page_order))
+		if (dma_set_encrypted(dev, cpu_addr, size))
 			return;
 	}
 
@@ -392,7 +392,6 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 		struct page *page, dma_addr_t dma_addr,
 		enum dma_data_direction dir)
 {
-	unsigned int page_order = get_order(size);
 	void *vaddr = page_address(page);
 
 	/* If cpu_addr is not from an atomic pool, dma_free_from_pool() fails */
@@ -400,7 +399,7 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	    dma_free_from_pool(dev, vaddr, size))
 		return;
 
-	if (dma_set_encrypted(dev, vaddr, 1 << page_order))
+	if (dma_set_encrypted(dev, vaddr, size))
 		return;
 	__dma_direct_free_pages(dev, page, size);
 }
diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
index b56833700d23..c69d82273ce7 100644
--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -154,6 +154,15 @@ struct rethook_node *rethook_try_get(struct rethook *rh)
 	if (unlikely(!handler))
 		return NULL;
 
+	/*
+	 * This expects the caller will set up a rethook on a function entry.
+	 * When the function returns, the rethook will eventually be reclaimed
+	 * or released in the rethook_recycle() with call_rcu().
+	 * This means the caller must be run in the RCU-availabe context.
+	 */
+	if (unlikely(!rcu_is_watching()))
+		return NULL;
+
 	fn = freelist_try_get(&rh->pool);
 	if (!fn)
 		return NULL;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 47cebef78532..13439743285c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1718,8 +1718,17 @@ static int
 kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	struct kretprobe *rp = get_kretprobe(ri);
-	struct trace_kprobe *tk = container_of(rp, struct trace_kprobe, rp);
+	struct trace_kprobe *tk;
+
+	/*
+	 * There is a small chance that get_kretprobe(ri) returns NULL when
+	 * the kretprobe is unregister on another CPU between kretprobe's
+	 * trampoline_handler and this function.
+	 */
+	if (unlikely(!rp))
+		return 0;
 
+	tk = container_of(rp, struct trace_kprobe, rp);
 	raw_cpu_inc(*tk->nhit);
 
 	if (trace_probe_test_flag(&tk->tp, TP_FLAG_TRACE))
diff --git a/mm/filemap.c b/mm/filemap.c
index 61dd39990fda..be1859a276e1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2385,6 +2385,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
 			continue;
 		if (xas.xa_index > max || xa_is_value(folio))
 			break;
+		if (xa_is_sibling(folio))
+			break;
 		if (!folio_try_get_rcu(folio))
 			goto retry;
 
diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index bb0cea5468cb..f483742e9dea 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -48,7 +48,7 @@ static int hwpoison_inject(void *data, u64 val)
 
 inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
-	err = memory_failure(pfn, 0);
+	err = memory_failure(pfn, MF_SW_SIMULATED);
 	return (err == -EOPNOTSUPP) ? 0 : err;
 }
 
diff --git a/mm/madvise.c b/mm/madvise.c
index 1873616a37d2..4d29a11c18e9 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1101,7 +1101,7 @@ static int madvise_inject_error(int behavior,
 		} else {
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
-			ret = memory_failure(pfn, MF_COUNT_INCREASED);
+			ret = memory_failure(pfn, MF_COUNT_INCREASED | MF_SW_SIMULATED);
 			if (ret == -EOPNOTSUPP)
 				ret = 0;
 		}
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d4a4adcca01f..94dac77f5eba 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -68,6 +68,8 @@ int sysctl_memory_failure_recovery __read_mostly = 1;
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
+static bool hw_memory_failure __read_mostly = false;
+
 static bool __page_handle_poison(struct page *page)
 {
 	int ret;
@@ -1780,6 +1782,9 @@ int memory_failure(unsigned long pfn, int flags)
 
 	mutex_lock(&mf_mutex);
 
+	if (!(flags & MF_SW_SIMULATED))
+		hw_memory_failure = true;
+
 	p = pfn_to_online_page(pfn);
 	if (!p) {
 		res = arch_memory_failure(pfn, flags);
@@ -2138,6 +2143,13 @@ int unpoison_memory(unsigned long pfn)
 
 	mutex_lock(&mf_mutex);
 
+	if (hw_memory_failure) {
+		unpoison_pr_info("Unpoison: Disabled after HW memory failure %#lx\n",
+				 pfn, &unpoison_rs);
+		ret = -EOPNOTSUPP;
+		goto unlock_mutex;
+	}
+
 	if (!PageHWPoison(p)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);
diff --git a/mm/readahead.c b/mm/readahead.c
index 4a60cdb64262..38635af5bab7 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -508,6 +508,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 			new_order--;
 	}
 
+	filemap_invalidate_lock_shared(mapping);
 	while (index <= limit) {
 		unsigned int order = new_order;
 
@@ -534,6 +535,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	}
 
 	read_pages(ractl);
+	filemap_invalidate_unlock_shared(mapping);
 
 	/*
 	 * If there were already pages in the page cache, then we may have
diff --git a/mm/slub.c b/mm/slub.c
index ed5c2c03a47a..46de927322fc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2939,6 +2939,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	if (!freelist) {
 		c->slab = NULL;
+		c->tid = next_tid(c->tid);
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
@@ -2971,6 +2972,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	freelist = c->freelist;
 	c->slab = NULL;
 	c->freelist = NULL;
+	c->tid = next_tid(c->tid);
 	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 	deactivate_slab(s, slab, freelist);
 
diff --git a/mm/swap.c b/mm/swap.c
index 7e320ec08c6a..8a98d21d2786 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -881,7 +881,7 @@ void lru_cache_disable(void)
 	 * lru_disable_count = 0 will have exited the critical
 	 * section when synchronize_rcu() returns.
 	 */
-	synchronize_rcu();
+	synchronize_rcu_expedited();
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
diff --git a/net/core/dev.c b/net/core/dev.c
index 0784c339cd7d..842917883adb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -396,16 +396,18 @@ static void list_netdevice(struct net_device *dev)
 /* Device list removal
  * caller must respect a RCU grace period before freeing/reusing dev
  */
-static void unlist_netdevice(struct net_device *dev)
+static void unlist_netdevice(struct net_device *dev, bool lock)
 {
 	ASSERT_RTNL();
 
 	/* Unlink dev from the device chain */
-	write_lock(&dev_base_lock);
+	if (lock)
+		write_lock(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
 	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
-	write_unlock(&dev_base_lock);
+	if (lock)
+		write_unlock(&dev_base_lock);
 
 	dev_base_seq_inc(dev_net(dev));
 }
@@ -9963,11 +9965,11 @@ int register_netdevice(struct net_device *dev)
 		goto err_uninit;
 
 	ret = netdev_register_kobject(dev);
-	if (ret) {
-		dev->reg_state = NETREG_UNREGISTERED;
+	write_lock(&dev_base_lock);
+	dev->reg_state = ret ? NETREG_UNREGISTERED : NETREG_REGISTERED;
+	write_unlock(&dev_base_lock);
+	if (ret)
 		goto err_uninit;
-	}
-	dev->reg_state = NETREG_REGISTERED;
 
 	__netdev_update_features(dev);
 
@@ -10249,7 +10251,9 @@ void netdev_run_todo(void)
 			continue;
 		}
 
+		write_lock(&dev_base_lock);
 		dev->reg_state = NETREG_UNREGISTERED;
+		write_unlock(&dev_base_lock);
 		linkwatch_forget_dev(dev);
 	}
 
@@ -10727,9 +10731,10 @@ void unregister_netdevice_many(struct list_head *head)
 
 	list_for_each_entry(dev, head, unreg_list) {
 		/* And unlink it from device chain. */
-		unlist_netdevice(dev);
-
+		write_lock(&dev_base_lock);
+		unlist_netdevice(dev, false);
 		dev->reg_state = NETREG_UNREGISTERING;
+		write_unlock(&dev_base_lock);
 	}
 	flush_all_backlogs();
 
@@ -10876,7 +10881,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	dev_close(dev);
 
 	/* And unlink it from device chain */
-	unlist_netdevice(dev);
+	unlist_netdevice(dev, true);
 
 	synchronize_net();
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 8847316ee20e..af1e77f2f24a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6506,10 +6506,21 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 					   ifindex, proto, netns_id, flags);
 
 	if (sk) {
-		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
+		struct sock *sk2 = sk_to_full_sk(sk);
+
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk2))
+			sk2 = NULL;
+		if (sk2 != sk) {
 			sock_gen_put(sk);
-			return NULL;
+			/* Ensure there is no need to bump sk2 refcnt */
+			if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
+				WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
+				return NULL;
+			}
+			sk = sk2;
 		}
 	}
 
@@ -6543,10 +6554,21 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 					 flags);
 
 	if (sk) {
-		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
+		struct sock *sk2 = sk_to_full_sk(sk);
+
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk2))
+			sk2 = NULL;
+		if (sk2 != sk) {
 			sock_gen_put(sk);
-			return NULL;
+			/* Ensure there is no need to bump sk2 refcnt */
+			if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
+				WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
+				return NULL;
+			}
+			sk = sk2;
 		}
 	}
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9cbc1c8289bc..9ee57997354a 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -32,6 +32,7 @@ static const char fmt_dec[] = "%d\n";
 static const char fmt_ulong[] = "%lu\n";
 static const char fmt_u64[] = "%llu\n";
 
+/* Caller holds RTNL or dev_base_lock */
 static inline int dev_isalive(const struct net_device *dev)
 {
 	return dev->reg_state <= NETREG_REGISTERED;
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cc381165ea08..ede0af308f40 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -695,6 +695,11 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 
 	write_lock_bh(&sk->sk_callback_lock);
 
+	if (sk_is_inet(sk) && inet_csk_has_ulp(sk)) {
+		psock = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
 	if (sk->sk_user_data) {
 		psock = ERR_PTR(-EBUSY);
 		goto out;
diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 7e6b37a54add..1c94bb8ea03f 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -36,7 +36,7 @@ static int fallback_set_params(struct eeprom_req_info *request,
 	if (request->page)
 		offset = request->page * ETH_MODULE_EEPROM_PAGE_LEN + offset;
 
-	if (modinfo->type == ETH_MODULE_SFF_8079 &&
+	if (modinfo->type == ETH_MODULE_SFF_8472 &&
 	    request->i2c_address == 0x51)
 		offset += ETH_MODULE_EEPROM_PAGE_LEN * 2;
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index bc8dfdf1c48a..318673517976 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -524,7 +524,6 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	int tunnel_hlen;
 	int version;
 	int nhoff;
-	int thoff;
 
 	tun_info = skb_tunnel_info(skb);
 	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
@@ -558,10 +557,16 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
 
-	thoff = skb_transport_header(skb) - skb_mac_header(skb);
-	if (skb->protocol == htons(ETH_P_IPV6) &&
-	    (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff))
-		truncate = true;
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		int thoff;
+
+		if (skb_transport_header_was_set(skb))
+			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+		else
+			thoff = nhoff + sizeof(struct ipv6hdr);
+		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
+			truncate = true;
+	}
 
 	if (version == 1) {
 		erspan_build_header(skb, ntohl(tunnel_id_to_key32(key->tun_id)),
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 4e5ceca7ff7f..9dccbf863f82 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -319,12 +319,16 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
 			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
+		if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
+			return 0;
+
 		tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ? : tb_id;
 		chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
 
-		if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
-					         addr->sin_addr.s_addr,
-	                                         chk_addr_ret))
+		if (chk_addr_ret == RTN_MULTICAST ||
+		    chk_addr_ret == RTN_BROADCAST ||
+		    (chk_addr_ret != RTN_LOCAL &&
+		     !inet_can_nonlocal_bind(net, isk)))
 			return -EADDRNOTAVAIL;
 
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1cdcb4df0eb7..2c597a4e429a 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -612,9 +612,6 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 		return 0;
 	}
 
-	if (inet_csk_has_ulp(sk))
-		return -EINVAL;
-
 	if (sk->sk_family == AF_INET6) {
 		if (tcp_bpf_assert_proto_ops(psock->sk_proto))
 			return -EINVAL;
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 5136959b3dc5..b996ccaff56e 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -944,7 +944,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	__be16 proto;
 	__u32 mtu;
 	int nhoff;
-	int thoff;
 
 	if (!pskb_inet_may_pull(skb))
 		goto tx_err;
@@ -965,10 +964,16 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
 
-	thoff = skb_transport_header(skb) - skb_mac_header(skb);
-	if (skb->protocol == htons(ETH_P_IPV6) &&
-	    (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff))
-		truncate = true;
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		int thoff;
+
+		if (skb_transport_header_was_set(skb))
+			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+		else
+			thoff = nhoff + sizeof(struct ipv6hdr);
+		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
+			truncate = true;
+	}
 
 	if (skb_cow_head(skb, dev->needed_headroom ?: t->hlen))
 		goto tx_err;
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 7873bd1389c3..a8e2425e43b0 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,14 +13,31 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
-static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
+#define NF_RECURSION_LIMIT	2
+
+static DEFINE_PER_CPU(u8, nf_dup_skb_recursion);
+
+static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
+				enum nf_dev_hooks hook)
 {
-	if (skb_mac_header_was_set(skb))
+	if (__this_cpu_read(nf_dup_skb_recursion) > NF_RECURSION_LIMIT)
+		goto err;
+
+	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
+		if (skb_cow_head(skb, skb->mac_len))
+			goto err;
+
 		skb_push(skb, skb->mac_len);
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
+	__this_cpu_inc(nf_dup_skb_recursion);
 	dev_queue_xmit(skb);
+	__this_cpu_dec(nf_dup_skb_recursion);
+	return;
+err:
+	kfree_skb(skb);
 }
 
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif)
@@ -33,7 +50,7 @@ void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 		return;
 	}
 
-	nf_do_netdev_egress(pkt->skb, dev);
+	nf_do_netdev_egress(pkt->skb, dev, nft_hook(pkt));
 }
 EXPORT_SYMBOL_GPL(nf_fwd_netdev_egress);
 
@@ -48,7 +65,7 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 
 	skb = skb_clone(pkt->skb, GFP_ATOMIC);
 	if (skb)
-		nf_do_netdev_egress(skb, dev);
+		nf_do_netdev_egress(skb, dev, nft_hook(pkt));
 }
 EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ac4859241e17..55d2d49c3425 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -14,6 +14,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/random.h>
 #include <linux/smp.h>
 #include <linux/static_key.h>
 #include <net/dst.h>
@@ -32,8 +33,6 @@
 #define NFT_META_SECS_PER_DAY		86400
 #define NFT_META_DAYS_PER_WEEK		7
 
-static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
-
 static u8 nft_meta_weekday(void)
 {
 	time64_t secs = ktime_get_real_seconds();
@@ -271,13 +270,6 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 	return true;
 }
 
-static noinline u32 nft_prandom_u32(void)
-{
-	struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
-
-	return prandom_u32_state(state);
-}
-
 #ifdef CONFIG_IP_ROUTE_CLASSID
 static noinline bool
 nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
@@ -389,7 +381,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		break;
 #endif
 	case NFT_META_PRANDOM:
-		*dest = nft_prandom_u32();
+		*dest = get_random_u32();
 		break;
 #ifdef CONFIG_XFRM
 	case NFT_META_SECPATH:
@@ -518,7 +510,6 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 	case NFT_META_PRANDOM:
-		prandom_init_once(&nft_prandom_state);
 		len = sizeof(u32);
 		break;
 #ifdef CONFIG_XFRM
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 81b40c663d86..45d3dc9e96f2 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -9,12 +9,11 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/random.h>
 #include <linux/static_key.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 
-static DEFINE_PER_CPU(struct rnd_state, nft_numgen_prandom_state);
-
 struct nft_ng_inc {
 	u8			dreg;
 	u32			modulus;
@@ -135,12 +134,9 @@ struct nft_ng_random {
 	u32			offset;
 };
 
-static u32 nft_ng_random_gen(struct nft_ng_random *priv)
+static u32 nft_ng_random_gen(const struct nft_ng_random *priv)
 {
-	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
-
-	return reciprocal_scale(prandom_u32_state(state), priv->modulus) +
-	       priv->offset;
+	return reciprocal_scale(get_random_u32(), priv->modulus) + priv->offset;
 }
 
 static void nft_ng_random_eval(const struct nft_expr *expr,
@@ -168,8 +164,6 @@ static int nft_ng_random_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	prandom_init_once(&nft_numgen_prandom_state);
-
 	return nft_parse_register_store(ctx, tb[NFTA_NG_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, sizeof(u32));
 }
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 372bf54a0ca9..e20d1a973417 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -407,7 +407,7 @@ static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 	if (flags & IP6_FH_F_FRAG) {
 		if (frag_off) {
 			key->ip.frag = OVS_FRAG_TYPE_LATER;
-			key->ip.proto = nexthdr;
+			key->ip.proto = NEXTHDR_FRAGMENT;
 			return 0;
 		}
 		key->ip.frag = OVS_FRAG_TYPE_FIRST;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index ed4ccef5d6a8..5449ed114e40 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1146,9 +1146,9 @@ static int netem_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tc_netem_rate rate;
 	struct tc_netem_slot slot;
 
-	qopt.latency = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->latency),
+	qopt.latency = min_t(psched_time_t, PSCHED_NS2TICKS(q->latency),
 			     UINT_MAX);
-	qopt.jitter = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->jitter),
+	qopt.jitter = min_t(psched_time_t, PSCHED_NS2TICKS(q->jitter),
 			    UINT_MAX);
 	qopt.limit = q->limit;
 	qopt.loss = q->loss;
diff --git a/net/tipc/core.c b/net/tipc/core.c
index 3f4542e0f065..434e70eabe08 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -109,10 +109,9 @@ static void __net_exit tipc_exit_net(struct net *net)
 	struct tipc_net *tn = tipc_net(net);
 
 	tipc_detach_loopback(net);
+	tipc_net_stop(net);
 	/* Make sure the tipc_net_finalize_work() finished */
 	cancel_work_sync(&tn->work);
-	tipc_net_stop(net);
-
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7b2b0e7ffee4..5c9697840ef7 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -873,6 +873,8 @@ static void tls_update(struct sock *sk, struct proto *p,
 {
 	struct tls_context *ctx;
 
+	WARN_ON_ONCE(sk->sk_prot == p);
+
 	ctx = tls_get_ctx(sk);
 	if (likely(ctx)) {
 		ctx->sk_write_space = write_space;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index d6bcdbfd0fc5..9b12ea3ab85a 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -538,12 +538,6 @@ static int xsk_generic_xmit(struct sock *sk)
 			goto out;
 		}
 
-		skb = xsk_build_skb(xs, &desc);
-		if (IS_ERR(skb)) {
-			err = PTR_ERR(skb);
-			goto out;
-		}
-
 		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
@@ -552,11 +546,19 @@ static int xsk_generic_xmit(struct sock *sk)
 		spin_lock_irqsave(&xs->pool->cq_lock, flags);
 		if (xskq_prod_reserve(xs->pool->cq)) {
 			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
-			kfree_skb(skb);
 			goto out;
 		}
 		spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
+		skb = xsk_build_skb(xs, &desc);
+		if (IS_ERR(skb)) {
+			err = PTR_ERR(skb);
+			spin_lock_irqsave(&xs->pool->cq_lock, flags);
+			xskq_prod_cancel(xs->pool->cq);
+			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
+			goto out;
+		}
+
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b28344fd7408..0005900b19b0 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1115,7 +1115,7 @@ static const struct sectioncheck sectioncheck[] = {
 },
 /* Do not export init/exit functions or data */
 {
-	.fromsec = { "__ksymtab*", NULL },
+	.fromsec = { "___ksymtab*", NULL },
 	.bad_tosec = { INIT_SECTIONS, EXIT_SECTIONS, NULL },
 	.mismatch = EXPORT_TO_INIT_EXIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 15dc7160ba34..8cfdaee77905 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -431,33 +431,17 @@ static const struct snd_malloc_ops snd_dma_iram_ops = {
  */
 static void *snd_dma_dev_alloc(struct snd_dma_buffer *dmab, size_t size)
 {
-	void *p;
-
-	p = dma_alloc_coherent(dmab->dev.dev, size, &dmab->addr, DEFAULT_GFP);
-#ifdef CONFIG_X86
-	if (p && dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC)
-		set_memory_wc((unsigned long)p, PAGE_ALIGN(size) >> PAGE_SHIFT);
-#endif
-	return p;
+	return dma_alloc_coherent(dmab->dev.dev, size, &dmab->addr, DEFAULT_GFP);
 }
 
 static void snd_dma_dev_free(struct snd_dma_buffer *dmab)
 {
-#ifdef CONFIG_X86
-	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC)
-		set_memory_wb((unsigned long)dmab->area,
-			      PAGE_ALIGN(dmab->bytes) >> PAGE_SHIFT);
-#endif
 	dma_free_coherent(dmab->dev.dev, dmab->bytes, dmab->area, dmab->addr);
 }
 
 static int snd_dma_dev_mmap(struct snd_dma_buffer *dmab,
 			    struct vm_area_struct *area)
 {
-#ifdef CONFIG_X86
-	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC)
-		area->vm_page_prot = pgprot_writecombine(area->vm_page_prot);
-#endif
 	return dma_mmap_coherent(dmab->dev.dev, area,
 				 dmab->area, dmab->addr, dmab->bytes);
 }
@@ -471,10 +455,6 @@ static const struct snd_malloc_ops snd_dma_dev_ops = {
 /*
  * Write-combined pages
  */
-#ifdef CONFIG_X86
-/* On x86, share the same ops as the standard dev ops */
-#define snd_dma_wc_ops	snd_dma_dev_ops
-#else /* CONFIG_X86 */
 static void *snd_dma_wc_alloc(struct snd_dma_buffer *dmab, size_t size)
 {
 	return dma_alloc_wc(dmab->dev.dev, size, &dmab->addr, DEFAULT_GFP);
@@ -497,7 +477,6 @@ static const struct snd_malloc_ops snd_dma_wc_ops = {
 	.free = snd_dma_wc_free,
 	.mmap = snd_dma_wc_mmap,
 };
-#endif /* CONFIG_X86 */
 
 #ifdef CONFIG_SND_DMA_SGBUF
 static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size);
diff --git a/sound/hda/hdac_i915.c b/sound/hda/hdac_i915.c
index 3f35972e1cf7..161a9711cd63 100644
--- a/sound/hda/hdac_i915.c
+++ b/sound/hda/hdac_i915.c
@@ -119,21 +119,18 @@ static int i915_component_master_match(struct device *dev, int subcomponent,
 /* check whether Intel graphics is present and reachable */
 static int i915_gfx_present(struct pci_dev *hdac_pci)
 {
-	unsigned int class = PCI_BASE_CLASS_DISPLAY << 16;
 	struct pci_dev *display_dev = NULL;
-	bool match = false;
 
-	do {
-		display_dev = pci_get_class(class, display_dev);
-
-		if (display_dev && display_dev->vendor == PCI_VENDOR_ID_INTEL &&
+	for_each_pci_dev(display_dev) {
+		if (display_dev->vendor == PCI_VENDOR_ID_INTEL &&
+		    (display_dev->class >> 16) == PCI_BASE_CLASS_DISPLAY &&
 		    connectivity_check(display_dev, hdac_pci)) {
 			pci_dev_put(display_dev);
-			match = true;
+			return true;
 		}
-	} while (!match && display_dev);
+	}
 
-	return match;
+	return false;
 }
 
 /**
diff --git a/sound/pci/hda/hda_auto_parser.c b/sound/pci/hda/hda_auto_parser.c
index cd1db943b7e0..7c6b1fe8dfcc 100644
--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -819,7 +819,7 @@ static void set_pin_targets(struct hda_codec *codec,
 		snd_hda_set_pin_ctl_cache(codec, cfg->nid, cfg->val);
 }
 
-static void apply_fixup(struct hda_codec *codec, int id, int action, int depth)
+void __snd_hda_apply_fixup(struct hda_codec *codec, int id, int action, int depth)
 {
 	const char *modelname = codec->fixup_name;
 
@@ -829,7 +829,7 @@ static void apply_fixup(struct hda_codec *codec, int id, int action, int depth)
 		if (++depth > 10)
 			break;
 		if (fix->chained_before)
-			apply_fixup(codec, fix->chain_id, action, depth + 1);
+			__snd_hda_apply_fixup(codec, fix->chain_id, action, depth + 1);
 
 		switch (fix->type) {
 		case HDA_FIXUP_PINS:
@@ -870,6 +870,7 @@ static void apply_fixup(struct hda_codec *codec, int id, int action, int depth)
 		id = fix->chain_id;
 	}
 }
+EXPORT_SYMBOL_GPL(__snd_hda_apply_fixup);
 
 /**
  * snd_hda_apply_fixup - Apply the fixup chain with the given action
@@ -879,7 +880,7 @@ static void apply_fixup(struct hda_codec *codec, int id, int action, int depth)
 void snd_hda_apply_fixup(struct hda_codec *codec, int action)
 {
 	if (codec->fixup_list)
-		apply_fixup(codec, codec->fixup_id, action, 0);
+		__snd_hda_apply_fixup(codec, codec->fixup_id, action, 0);
 }
 EXPORT_SYMBOL_GPL(snd_hda_apply_fixup);
 
diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
index aca592651870..682dca2057db 100644
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -348,6 +348,7 @@ void snd_hda_apply_verbs(struct hda_codec *codec);
 void snd_hda_apply_pincfgs(struct hda_codec *codec,
 			   const struct hda_pintbl *cfg);
 void snd_hda_apply_fixup(struct hda_codec *codec, int action);
+void __snd_hda_apply_fixup(struct hda_codec *codec, int id, int action, int depth);
 void snd_hda_pick_fixup(struct hda_codec *codec,
 			const struct hda_model_fixup *models,
 			const struct snd_pci_quirk *quirk,
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index bce2cef80000..0b7d500249f6 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1079,11 +1079,11 @@ static int patch_conexant_auto(struct hda_codec *codec)
 	if (err < 0)
 		goto error;
 
-	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
+	err = cx_auto_parse_beep(codec);
 	if (err < 0)
 		goto error;
 
-	err = cx_auto_parse_beep(codec);
+	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
 	if (err < 0)
 		goto error;
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 588d4a59c8d9..d3d786de8f4c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2634,6 +2634,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67f1, "Clevo PC70H[PRS]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x67f5, "Clevo PD70PN[NRT]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7715, "Clevo X170KM-G", ALC1220_FIXUP_CLEVO_PB51ED),
@@ -7056,6 +7057,7 @@ enum {
 	ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS,
 	ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
+	ALC298_FIXUP_LENOVO_C940_DUET7,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
@@ -7074,6 +7076,23 @@ enum {
 	ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE,
 };
 
+/* A special fixup for Lenovo C940 and Yoga Duet 7;
+ * both have the very same PCI SSID, and we need to apply different fixups
+ * depending on the codec ID
+ */
+static void alc298_fixup_lenovo_c940_duet7(struct hda_codec *codec,
+					   const struct hda_fixup *fix,
+					   int action)
+{
+	int id;
+
+	if (codec->core.vendor_id == 0x10ec0298)
+		id = ALC298_FIXUP_LENOVO_SPK_VOLUME; /* C940 */
+	else
+		id = ALC287_FIXUP_YOGA7_14ITL_SPEAKERS; /* Duet 7 */
+	__snd_hda_apply_fixup(codec, id, action, 0);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC269_FIXUP_GPIO2] = {
 		.type = HDA_FIXUP_FUNC,
@@ -8773,6 +8792,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE,
 	},
+	[ALC298_FIXUP_LENOVO_C940_DUET7] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc298_fixup_lenovo_c940_duet7,
+	},
 	[ALC287_FIXUP_13S_GEN2_SPEAKERS] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -9074,6 +9097,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8783, "HP ZBook Fury 15 G7 Mobile Workstation",
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
@@ -9239,6 +9263,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x70f3, "Clevo NH77DPQ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f4, "Clevo NH77EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f6, "Clevo NH77DPQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x7716, "Clevo NS50PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8228, "Clevo NR40BU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8520, "Clevo NH50D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8521, "Clevo NH77D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
@@ -9325,7 +9350,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
-	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
+	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3820, "Yoga Duet 7 13ITL6", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3824, "Legion Y9000X 2020", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
@@ -10789,6 +10814,7 @@ enum {
 	ALC668_FIXUP_MIC_DET_COEF,
 	ALC897_FIXUP_LENOVO_HEADSET_MIC,
 	ALC897_FIXUP_HEADSET_MIC_PIN,
+	ALC897_FIXUP_HP_HSMIC_VERB,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -11208,6 +11234,13 @@ static const struct hda_fixup alc662_fixups[] = {
 		.chained = true,
 		.chain_id = ALC897_FIXUP_LENOVO_HEADSET_MIC
 	},
+	[ALC897_FIXUP_HP_HSMIC_VERB] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -11233,6 +11266,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0698, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x069f, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
+	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x885f, "HP 288 Pro G8", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x1043, 0x1080, "Asus UX501VW", ALC668_FIXUP_HEADSET_MODE),
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 773a136161f1..a188901a83bb 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -520,11 +520,11 @@ static int via_parse_auto_config(struct hda_codec *codec)
 	if (err < 0)
 		return err;
 
-	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
+	err = auto_parse_beep(codec);
 	if (err < 0)
 		return err;
 
-	err = auto_parse_beep(codec);
+	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
 	if (err < 0)
 		return err;
 
diff --git a/tools/perf/tests/shell/test_arm_callgraph_fp.sh b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
index 6ffbb27afaba..ec108d45d3c6 100755
--- a/tools/perf/tests/shell/test_arm_callgraph_fp.sh
+++ b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
@@ -43,7 +43,7 @@ CFLAGS="-g -O0 -fno-inline -fno-omit-frame-pointer"
 cc $CFLAGS $TEST_PROGRAM_SOURCE -o $TEST_PROGRAM || exit 1
 
 # Add a 1 second delay to skip samples that are not in the leaf() function
-perf record -o $PERF_DATA --call-graph fp -e cycles//u -D 1000 -- $TEST_PROGRAM 2> /dev/null &
+perf record -o $PERF_DATA --call-graph fp -e cycles//u -D 1000 --user-callchains -- $TEST_PROGRAM 2> /dev/null &
 PID=$!
 
 echo " + Recording (PID=$PID)..."
diff --git a/tools/perf/tests/topology.c b/tools/perf/tests/topology.c
index d23a9e322ff5..0b4f61b6cc6b 100644
--- a/tools/perf/tests/topology.c
+++ b/tools/perf/tests/topology.c
@@ -115,7 +115,7 @@ static int check_cpu_topology(char *path, struct perf_cpu_map *map)
 	 * physical_package_id will be set to -1. Hence skip this
 	 * test if physical_package_id returns -1 for cpu from perf_cpu_map.
 	 */
-	if (strncmp(session->header.env.arch, "powerpc", 7)) {
+	if (!strncmp(session->header.env.arch, "ppc64le", 7)) {
 		if (cpu__get_socket_id(perf_cpu_map__cpu(map, 0)) == -1)
 			return TEST_SKIP;
 	}
diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 1a80151baed9..d040406f3314 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -387,26 +387,16 @@ static int arm_spe__synth_instruction_sample(struct arm_spe_queue *speq,
 	return arm_spe_deliver_synth_event(spe, speq, event, &sample);
 }
 
-#define SPE_MEM_TYPE	(ARM_SPE_L1D_ACCESS | ARM_SPE_L1D_MISS | \
-			 ARM_SPE_LLC_ACCESS | ARM_SPE_LLC_MISS | \
-			 ARM_SPE_REMOTE_ACCESS)
-
-static bool arm_spe__is_memory_event(enum arm_spe_sample_type type)
-{
-	if (type & SPE_MEM_TYPE)
-		return true;
-
-	return false;
-}
-
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record)
 {
 	union perf_mem_data_src	data_src = { 0 };
 
 	if (record->op == ARM_SPE_LD)
 		data_src.mem_op = PERF_MEM_OP_LOAD;
-	else
+	else if (record->op == ARM_SPE_ST)
 		data_src.mem_op = PERF_MEM_OP_STORE;
+	else
+		return 0;
 
 	if (record->type & (ARM_SPE_LLC_ACCESS | ARM_SPE_LLC_MISS)) {
 		data_src.mem_lvl = PERF_MEM_LVL_L3;
@@ -510,7 +500,11 @@ static int arm_spe_sample(struct arm_spe_queue *speq)
 			return err;
 	}
 
-	if (spe->sample_memory && arm_spe__is_memory_event(record->type)) {
+	/*
+	 * When data_src is zero it means the record is not a memory operation,
+	 * skip to synthesize memory sample for this case.
+	 */
+	if (spe->sample_memory && data_src) {
 		err = arm_spe__synth_mem_sample(speq, spe->memory_id, data_src);
 		if (err)
 			return err;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 82f3d46bea70..328668f38c69 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -872,6 +872,30 @@ int build_id_cache__remove_s(const char *sbuild_id)
 	return err;
 }
 
+static int filename__read_build_id_ns(const char *filename,
+				      struct build_id *bid,
+				      struct nsinfo *nsi)
+{
+	struct nscookie nsc;
+	int ret;
+
+	nsinfo__mountns_enter(nsi, &nsc);
+	ret = filename__read_build_id(filename, bid);
+	nsinfo__mountns_exit(&nsc);
+
+	return ret;
+}
+
+static bool dso__build_id_mismatch(struct dso *dso, const char *name)
+{
+	struct build_id bid;
+
+	if (filename__read_build_id_ns(name, &bid, dso->nsinfo) < 0)
+		return false;
+
+	return !dso__build_id_equal(dso, &bid);
+}
+
 static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 			       void *priv __maybe_unused)
 {
@@ -886,6 +910,10 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 		is_kallsyms = true;
 		name = machine->mmap_name;
 	}
+
+	if (!is_kallsyms && dso__build_id_mismatch(dso, name))
+		return 0;
+
 	return build_id_cache__add_b(&dso->bid, name, dso->nsinfo,
 				     is_kallsyms, is_vdso);
 }
diff --git a/tools/testing/selftests/dma/Makefile b/tools/testing/selftests/dma/Makefile
index aa8e8b5b3864..cd8c5ece1cba 100644
--- a/tools/testing/selftests/dma/Makefile
+++ b/tools/testing/selftests/dma/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS += -I../../../../usr/include/
+CFLAGS += -I../../../../include/
 
 TEST_GEN_PROGS := dma_map_benchmark
 
diff --git a/tools/testing/selftests/dma/dma_map_benchmark.c b/tools/testing/selftests/dma/dma_map_benchmark.c
index c3b3c09e995e..5c997f17fcbd 100644
--- a/tools/testing/selftests/dma/dma_map_benchmark.c
+++ b/tools/testing/selftests/dma/dma_map_benchmark.c
@@ -10,8 +10,8 @@
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
-#include <linux/map_benchmark.h>
 #include <linux/types.h>
+#include <linux/map_benchmark.h>
 
 #define NSEC_PER_MSEC	1000000L
 
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 54701c8b0cd7..03b586760164 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -70,6 +70,10 @@ NSB_LO_IP6=2001:db8:2::2
 NL_IP=172.17.1.1
 NL_IP6=2001:db8:4::1
 
+# multicast and broadcast addresses
+MCAST_IP=224.0.0.1
+BCAST_IP=255.255.255.255
+
 MD5_PW=abc123
 MD5_WRONG_PW=abc1234
 
@@ -308,6 +312,9 @@ addr2str()
 	127.0.0.1) echo "loopback";;
 	::1) echo "IPv6 loopback";;
 
+	${BCAST_IP}) echo "broadcast";;
+	${MCAST_IP}) echo "multicast";;
+
 	${NSA_IP})	echo "ns-A IP";;
 	${NSA_IP6})	echo "ns-A IPv6";;
 	${NSA_LO_IP})	echo "ns-A loopback IP";;
@@ -1793,12 +1800,33 @@ ipv4_addr_bind_novrf()
 	done
 
 	#
-	# raw socket with nonlocal bind
+	# tests for nonlocal bind
 	#
 	a=${NL_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${NSA_DEV} -b
-	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after device bind"
+	run_cmd nettest -s -R -f -l ${a} -b
+	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address"
+
+	log_start
+	run_cmd nettest -s -f -l ${a} -b
+	log_test_addr ${a} $? 0 "TCP socket bind to nonlocal address"
+
+	log_start
+	run_cmd nettest -s -D -P icmp -f -l ${a} -b
+	log_test_addr ${a} $? 0 "ICMP socket bind to nonlocal address"
+
+	#
+	# check that ICMP sockets cannot bind to broadcast and multicast addresses
+	#
+	a=${BCAST_IP}
+	log_start
+	run_cmd nettest -s -D -P icmp -l ${a} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address"
+
+	a=${MCAST_IP}
+	log_start
+	run_cmd nettest -s -D -P icmp -l ${a} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address"
 
 	#
 	# tcp sockets
@@ -1850,13 +1878,34 @@ ipv4_addr_bind_vrf()
 	log_test_addr ${a} $? 1 "Raw socket bind to out of scope address after VRF bind"
 
 	#
-	# raw socket with nonlocal bind
+	# tests for nonlocal bind
 	#
 	a=${NL_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${VRF} -b
+	run_cmd nettest -s -R -f -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after VRF bind"
 
+	log_start
+	run_cmd nettest -s -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 0 "TCP socket bind to nonlocal address after VRF bind"
+
+	log_start
+	run_cmd nettest -s -D -P icmp -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 0 "ICMP socket bind to nonlocal address after VRF bind"
+
+	#
+	# check that ICMP sockets cannot bind to broadcast and multicast addresses
+	#
+	a=${BCAST_IP}
+	log_start
+	run_cmd nettest -s -D -P icmp -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address after VRF bind"
+
+	a=${MCAST_IP}
+	log_start
+	run_cmd nettest -s -D -P icmp -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address after VRF bind"
+
 	#
 	# tcp sockets
 	#
@@ -1889,10 +1938,12 @@ ipv4_addr_bind()
 
 	log_subsection "No VRF"
 	setup
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
 	ipv4_addr_bind_novrf
 
 	log_subsection "With VRF"
 	setup "yes"
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
 	ipv4_addr_bind_vrf
 }
 
diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index b35010cc7f6a..a6991877e50c 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -31,7 +31,7 @@ BUGS="flush_remove_add reload"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
-	../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+	../../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
 	pktgen/pktgen_bench_xmit_mode_netif_receive.sh"
 
 # Definition of set types:
