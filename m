Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BD8533843
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 10:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiEYIUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 04:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiEYIUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 04:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A6181998;
        Wed, 25 May 2022 01:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B4CC61820;
        Wed, 25 May 2022 08:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58284C385B8;
        Wed, 25 May 2022 08:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653466833;
        bh=/W4h63Z5yaPg8i+6kUo4qaYWuYkrqMDaiZoX5TTrx2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1pLkvM2NS4MchaEr23iPXUFxnRUCdZcVztoz6PSDPmPVa1wShxKzb0HtUJRgzmZO
         jNf29neNV1C3cvoGnN0kHbxG50WNtJt1EtlRg74ioT/G9cNTT6On8V4VhoDq/uoA9h
         ng36qmajF+YFB3rwAWPIu7lRGMgdVFgz3164k9l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.42
Date:   Wed, 25 May 2022 10:20:22 +0200
Message-Id: <1653466821185167@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165346682110712@kroah.com>
References: <165346682110712@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index d410a47ffa57..7c1750bcc5bd 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -163,6 +163,9 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo4xx Silver  | N/A             | ARM64_ERRATUM_1024718       |
 +----------------+-----------------+-----------------+-----------------------------+
+| Qualcomm Tech. | Kryo4xx Gold    | N/A             | ARM64_ERRATUM_1286807       |
++----------------+-----------------+-----------------+-----------------------------+
+
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | A64FX           | E#010001        | FUJITSU_ERRATUM_010001      |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
index ad2866c99738..fcd82df3aebb 100644
--- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
@@ -58,7 +58,7 @@ patternProperties:
           $ref: "/schemas/types.yaml#/definitions/string"
           enum: [ ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15, ADC2,
                   ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMCG1, EMMCG4,
-                  EMMCG8, ESPI, ESPIALT, FSI1, FSI2, FWSPIABR, FWSPID, FWQSPID, FWSPIWP,
+                  EMMCG8, ESPI, ESPIALT, FSI1, FSI2, FWSPIABR, FWSPID, FWSPIWP,
                   GPIT0, GPIT1, GPIT2, GPIT3, GPIT4, GPIT5, GPIT6, GPIT7, GPIU0, GPIU1,
                   GPIU2, GPIU3, GPIU4, GPIU5, GPIU6, GPIU7, HVI3C3, HVI3C4, I2C1, I2C10,
                   I2C11, I2C12, I2C13, I2C14, I2C15, I2C16, I2C2, I2C3, I2C4, I2C5,
diff --git a/Makefile b/Makefile
index c940e6542c8f..6ad7aabaa7d6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 41
+SUBLEVEL = 42
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
index 2efd70666738..af7ea7cab8cf 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
@@ -231,6 +231,21 @@ led-pcieslot-power {
 			gpios = <&gpio0 ASPEED_GPIO(P, 4) GPIO_ACTIVE_LOW>;
 		};
 	};
+
+	iio-hwmon {
+		compatible = "iio-hwmon";
+		io-channels = <&adc1 7>;
+	};
+};
+
+&adc1 {
+	status = "okay";
+	aspeed,int-vref-microvolt = <2500000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_adc8_default &pinctrl_adc9_default
+				 &pinctrl_adc10_default &pinctrl_adc11_default
+				 &pinctrl_adc12_default &pinctrl_adc13_default
+				 &pinctrl_adc14_default &pinctrl_adc15_default>;
 };
 
 &gpio0 {
diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
index 6419c9762c0b..6c9f34396a3a 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
@@ -246,6 +246,21 @@ fan5-presence {
 			linux,code = <11>;
 		};
 	};
+
+	iio-hwmon {
+		compatible = "iio-hwmon";
+		io-channels = <&adc1 7>;
+	};
+};
+
+&adc1 {
+	status = "okay";
+	aspeed,int-vref-microvolt = <2500000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_adc8_default &pinctrl_adc9_default
+		&pinctrl_adc10_default &pinctrl_adc11_default
+		&pinctrl_adc12_default &pinctrl_adc13_default
+		&pinctrl_adc14_default &pinctrl_adc15_default>;
 };
 
 &ehci1 {
diff --git a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
index e4775bbceecc..ac07c240419a 100644
--- a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
@@ -117,11 +117,6 @@ pinctrl_fwspid_default: fwspid_default {
 		groups = "FWSPID";
 	};
 
-	pinctrl_fwqspid_default: fwqspid_default {
-		function = "FWSPID";
-		groups = "FWQSPID";
-	};
-
 	pinctrl_fwspiwp_default: fwspiwp_default {
 		function = "FWSPIWP";
 		groups = "FWSPIWP";
@@ -653,12 +648,12 @@ pinctrl_pwm9g1_default: pwm9g1_default {
 	};
 
 	pinctrl_qspi1_default: qspi1_default {
-		function = "QSPI1";
+		function = "SPI1";
 		groups = "QSPI1";
 	};
 
 	pinctrl_qspi2_default: qspi2_default {
-		function = "QSPI2";
+		function = "SPI2";
 		groups = "QSPI2";
 	};
 
diff --git a/arch/arm/boot/dts/aspeed-g6.dtsi b/arch/arm/boot/dts/aspeed-g6.dtsi
index 1b47be1704f8..e5724b1a2e20 100644
--- a/arch/arm/boot/dts/aspeed-g6.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6.dtsi
@@ -364,6 +364,41 @@ xdma: xdma@1e6e7000 {
 				status = "disabled";
 			};
 
+			adc0: adc@1e6e9000 {
+				compatible = "aspeed,ast2600-adc0";
+				reg = <0x1e6e9000 0x100>;
+				clocks = <&syscon ASPEED_CLK_APB2>;
+				resets = <&syscon ASPEED_RESET_ADC>;
+				interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+				#io-channel-cells = <1>;
+				status = "disabled";
+			};
+
+			adc1: adc@1e6e9100 {
+				compatible = "aspeed,ast2600-adc1";
+				reg = <0x1e6e9100 0x100>;
+				clocks = <&syscon ASPEED_CLK_APB2>;
+				resets = <&syscon ASPEED_RESET_ADC>;
+				interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+				#io-channel-cells = <1>;
+				status = "disabled";
+			};
+
+			sbc: secure-boot-controller@1e6f2000 {
+				compatible = "aspeed,ast2600-sbc";
+				reg = <0x1e6f2000 0x1000>;
+			};
+
+			video: video@1e700000 {
+				compatible = "aspeed,ast2600-video-engine";
+				reg = <0x1e700000 0x1000>;
+				clocks = <&syscon ASPEED_CLK_GATE_VCLK>,
+					 <&syscon ASPEED_CLK_GATE_ECLK>;
+				clock-names = "vclk", "eclk";
+				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+				status = "disabled";
+			};
+
 			gpio0: gpio@1e780000 {
 				#gpio-cells = <2>;
 				gpio-controller;
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 46b697dfa4cf..68261a83b7ad 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1038,7 +1038,7 @@ vector_bhb_loop8_\name:
 
 	@ bhb workaround
 	mov	r0, #8
-3:	b	. + 4
+3:	W(b)	. + 4
 	subs	r0, r0, #1
 	bne	3b
 	dsb
diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index db798eac7431..824774999825 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -53,17 +53,17 @@ int notrace unwind_frame(struct stackframe *frame)
 		return -EINVAL;
 
 	frame->sp = frame->fp;
-	frame->fp = *(unsigned long *)(fp);
-	frame->pc = *(unsigned long *)(fp + 4);
+	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
+	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 4));
 #else
 	/* check current frame pointer is within bounds */
 	if (fp < low + 12 || fp > high - 4)
 		return -EINVAL;
 
 	/* restore the registers from the stack frame */
-	frame->fp = *(unsigned long *)(fp - 12);
-	frame->sp = *(unsigned long *)(fp - 8);
-	frame->pc = *(unsigned long *)(fp - 4);
+	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 12));
+	frame->sp = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 8));
+	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 4));
 #endif
 
 	return 0;
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 06dbfb968182..fb9f3eb6bf48 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -288,6 +288,7 @@ void cpu_v7_ca15_ibe(void)
 {
 	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0)))
 		cpu_v7_spectre_v2_init();
+	cpu_v7_spectre_bhb_init();
 }
 
 void cpu_v7_bugs_init(void)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a33d7b8f3b93..c67c19d70159 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -208,6 +208,8 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1286807
 	{
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 0),
+		/* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
+		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},
 #endif
 	{},
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index e5e801bc5312..7c1c82c8115c 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -73,6 +73,9 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
 	}
+
+	/* ensure the tags are visible before the PTE is set */
+	smp_wmb();
 }
 
 int memcmp_pages(struct page *page1, struct page *page2)
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 75fed4460407..57c7c211f8c7 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -35,7 +35,7 @@ static u64 native_steal_clock(int cpu)
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
 
 struct pv_time_stolen_time_region {
-	struct pvclock_vcpu_stolen_time *kaddr;
+	struct pvclock_vcpu_stolen_time __rcu *kaddr;
 };
 
 static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
@@ -52,7 +52,9 @@ early_param("no-steal-acc", parse_no_stealacc);
 /* return stolen time in ns by asking the hypervisor */
 static u64 para_steal_clock(int cpu)
 {
+	struct pvclock_vcpu_stolen_time *kaddr = NULL;
 	struct pv_time_stolen_time_region *reg;
+	u64 ret = 0;
 
 	reg = per_cpu_ptr(&stolen_time_region, cpu);
 
@@ -61,28 +63,37 @@ static u64 para_steal_clock(int cpu)
 	 * online notification callback runs. Until the callback
 	 * has run we just return zero.
 	 */
-	if (!reg->kaddr)
+	rcu_read_lock();
+	kaddr = rcu_dereference(reg->kaddr);
+	if (!kaddr) {
+		rcu_read_unlock();
 		return 0;
+	}
 
-	return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
+	ret = le64_to_cpu(READ_ONCE(kaddr->stolen_time));
+	rcu_read_unlock();
+	return ret;
 }
 
 static int stolen_time_cpu_down_prepare(unsigned int cpu)
 {
+	struct pvclock_vcpu_stolen_time *kaddr = NULL;
 	struct pv_time_stolen_time_region *reg;
 
 	reg = this_cpu_ptr(&stolen_time_region);
 	if (!reg->kaddr)
 		return 0;
 
-	memunmap(reg->kaddr);
-	memset(reg, 0, sizeof(*reg));
+	kaddr = rcu_replace_pointer(reg->kaddr, NULL, true);
+	synchronize_rcu();
+	memunmap(kaddr);
 
 	return 0;
 }
 
 static int stolen_time_cpu_online(unsigned int cpu)
 {
+	struct pvclock_vcpu_stolen_time *kaddr = NULL;
 	struct pv_time_stolen_time_region *reg;
 	struct arm_smccc_res res;
 
@@ -93,17 +104,19 @@ static int stolen_time_cpu_online(unsigned int cpu)
 	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
 		return -EINVAL;
 
-	reg->kaddr = memremap(res.a0,
+	kaddr = memremap(res.a0,
 			      sizeof(struct pvclock_vcpu_stolen_time),
 			      MEMREMAP_WB);
 
+	rcu_assign_pointer(reg->kaddr, kaddr);
+
 	if (!reg->kaddr) {
 		pr_warn("Failed to map stolen time data structure\n");
 		return -ENOMEM;
 	}
 
-	if (le32_to_cpu(reg->kaddr->revision) != 0 ||
-	    le32_to_cpu(reg->kaddr->attributes) != 0) {
+	if (le32_to_cpu(kaddr->revision) != 0 ||
+	    le32_to_cpu(kaddr->attributes) != 0) {
 		pr_warn_once("Unexpected revision or attributes in stolen time data\n");
 		return -ENXIO;
 	}
diff --git a/arch/mips/lantiq/falcon/sysctrl.c b/arch/mips/lantiq/falcon/sysctrl.c
index 42222f849bd2..446a2536999b 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -167,6 +167,8 @@ static inline void clkdev_add_sys(const char *dev, unsigned int module,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev;
 	clk->cl.con_id = NULL;
 	clk->cl.clk = clk;
diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
index 3d5683e75cf1..200fe9ff641d 100644
--- a/arch/mips/lantiq/xway/gptu.c
+++ b/arch/mips/lantiq/xway/gptu.c
@@ -122,6 +122,8 @@ static inline void clkdev_add_gptu(struct device *dev, const char *con,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev_name(dev);
 	clk->cl.con_id = con;
 	clk->cl.clk = clk;
diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index 917fac1636b7..084f6caba5f2 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -315,6 +315,8 @@ static void clkdev_add_pmu(const char *dev, const char *con, bool deactivate,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev;
 	clk->cl.con_id = con;
 	clk->cl.clk = clk;
@@ -338,6 +340,8 @@ static void clkdev_add_cgu(const char *dev, const char *con,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev;
 	clk->cl.con_id = con;
 	clk->cl.clk = clk;
@@ -356,24 +360,28 @@ static void clkdev_add_pci(void)
 	struct clk *clk_ext = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
 	/* main pci clock */
-	clk->cl.dev_id = "17000000.pci";
-	clk->cl.con_id = NULL;
-	clk->cl.clk = clk;
-	clk->rate = CLOCK_33M;
-	clk->rates = valid_pci_rates;
-	clk->enable = pci_enable;
-	clk->disable = pmu_disable;
-	clk->module = 0;
-	clk->bits = PMU_PCI;
-	clkdev_add(&clk->cl);
+	if (clk) {
+		clk->cl.dev_id = "17000000.pci";
+		clk->cl.con_id = NULL;
+		clk->cl.clk = clk;
+		clk->rate = CLOCK_33M;
+		clk->rates = valid_pci_rates;
+		clk->enable = pci_enable;
+		clk->disable = pmu_disable;
+		clk->module = 0;
+		clk->bits = PMU_PCI;
+		clkdev_add(&clk->cl);
+	}
 
 	/* use internal/external bus clock */
-	clk_ext->cl.dev_id = "17000000.pci";
-	clk_ext->cl.con_id = "external";
-	clk_ext->cl.clk = clk_ext;
-	clk_ext->enable = pci_ext_enable;
-	clk_ext->disable = pci_ext_disable;
-	clkdev_add(&clk_ext->cl);
+	if (clk_ext) {
+		clk_ext->cl.dev_id = "17000000.pci";
+		clk_ext->cl.con_id = "external";
+		clk_ext->cl.clk = clk_ext;
+		clk_ext->enable = pci_ext_enable;
+		clk_ext->disable = pci_ext_disable;
+		clkdev_add(&clk_ext->cl);
+	}
 }
 
 /* xway socs can generate clocks on gpio pins */
@@ -393,9 +401,15 @@ static void clkdev_add_clkout(void)
 		char *name;
 
 		name = kzalloc(sizeof("clkout0"), GFP_KERNEL);
+		if (!name)
+			continue;
 		sprintf(name, "clkout%d", i);
 
 		clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
+		if (!clk) {
+			kfree(name);
+			continue;
+		}
 		clk->cl.dev_id = "1f103000.cgu";
 		clk->cl.con_id = name;
 		clk->cl.clk = clk;
diff --git a/arch/riscv/boot/dts/sifive/fu540-c000.dtsi b/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
index 7db861053483..64c06c9b41dc 100644
--- a/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
@@ -166,7 +166,7 @@ uart0: serial@10010000 {
 			clocks = <&prci PRCI_CLK_TLCLK>;
 			status = "disabled";
 		};
-		dma: dma@3000000 {
+		dma: dma-controller@3000000 {
 			compatible = "sifive,fu540-c000-pdma";
 			reg = <0x0 0x3000000 0x0 0x8000>;
 			interrupt-parent = <&plic0>;
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 12d28ff5281f..4044826d72ae 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -142,10 +142,10 @@ static inline void do_fp_trap(struct pt_regs *regs, __u32 fpc)
 	do_trap(regs, SIGFPE, si_code, "floating point exception");
 }
 
-static void translation_exception(struct pt_regs *regs)
+static void translation_specification_exception(struct pt_regs *regs)
 {
 	/* May never happen. */
-	panic("Translation exception");
+	panic("Translation-Specification Exception");
 }
 
 static void illegal_op(struct pt_regs *regs)
@@ -374,7 +374,7 @@ static void (*pgm_check_table[128])(struct pt_regs *regs) = {
 	[0x0f]		= hfp_divide_exception,
 	[0x10]		= do_dat_exception,
 	[0x11]		= do_dat_exception,
-	[0x12]		= translation_exception,
+	[0x12]		= translation_specification_exception,
 	[0x13]		= special_op_exception,
 	[0x14]		= default_trap_handler,
 	[0x15]		= operand_exception,
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index b833155ce838..639924d98331 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -69,6 +69,7 @@ struct zpci_dev *get_zdev_by_fid(u32 fid)
 	list_for_each_entry(tmp, &zpci_list, entry) {
 		if (tmp->fid == fid) {
 			zdev = tmp;
+			zpci_zdev_get(zdev);
 			break;
 		}
 	}
diff --git a/arch/s390/pci/pci_bus.h b/arch/s390/pci/pci_bus.h
index e359d2686178..ecef3a9e16c0 100644
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -19,7 +19,8 @@ void zpci_bus_remove_device(struct zpci_dev *zdev, bool set_error);
 void zpci_release_device(struct kref *kref);
 static inline void zpci_zdev_put(struct zpci_dev *zdev)
 {
-	kref_put(&zdev->kref, zpci_release_device);
+	if (zdev)
+		kref_put(&zdev->kref, zpci_release_device);
 }
 
 static inline void zpci_zdev_get(struct zpci_dev *zdev)
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index be077b39da33..5011d27461fd 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -22,6 +22,8 @@
 #include <asm/clp.h>
 #include <uapi/asm/clp.h>
 
+#include "pci_bus.h"
+
 bool zpci_unique_uid;
 
 void update_uid_checking(bool new)
@@ -403,8 +405,11 @@ static void __clp_add(struct clp_fh_list_entry *entry, void *data)
 		return;
 
 	zdev = get_zdev_by_fid(entry->fid);
-	if (!zdev)
-		zpci_create_device(entry->fid, entry->fh, entry->config_state);
+	if (zdev) {
+		zpci_zdev_put(zdev);
+		return;
+	}
+	zpci_create_device(entry->fid, entry->fh, entry->config_state);
 }
 
 int clp_scan_pci_devices(void)
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index 5b8d647523f9..6d57625b8ed9 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -62,10 +62,12 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
 	       pdev ? pci_name(pdev) : "n/a", ccdf->pec, ccdf->fid);
 
 	if (!pdev)
-		return;
+		goto no_pdev;
 
 	pdev->error_state = pci_channel_io_perm_failure;
 	pci_dev_put(pdev);
+no_pdev:
+	zpci_zdev_put(zdev);
 }
 
 void zpci_event_error(void *data)
@@ -94,6 +96,7 @@ static void zpci_event_hard_deconfigured(struct zpci_dev *zdev, u32 fh)
 static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 {
 	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
+	bool existing_zdev = !!zdev;
 	enum zpci_state state;
 
 	zpci_err("avail CCDF:\n");
@@ -156,6 +159,8 @@ static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 	default:
 		break;
 	}
+	if (existing_zdev)
+		zpci_zdev_put(zdev);
 }
 
 void zpci_event_availability(void *data)
diff --git a/arch/x86/crypto/chacha-avx512vl-x86_64.S b/arch/x86/crypto/chacha-avx512vl-x86_64.S
index 946f74dd6fba..259383e1ad44 100644
--- a/arch/x86/crypto/chacha-avx512vl-x86_64.S
+++ b/arch/x86/crypto/chacha-avx512vl-x86_64.S
@@ -172,7 +172,7 @@ SYM_FUNC_START(chacha_2block_xor_avx512vl)
 	# xor remaining bytes from partial register into output
 	mov		%rcx,%rax
 	and		$0xf,%rcx
-	jz		.Ldone8
+	jz		.Ldone2
 	mov		%rax,%r9
 	and		$~0xf,%r9
 
@@ -438,7 +438,7 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 	# xor remaining bytes from partial register into output
 	mov		%rcx,%rax
 	and		$0xf,%rcx
-	jz		.Ldone8
+	jz		.Ldone4
 	mov		%rax,%r9
 	and		$~0xf,%r9
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 806f9d42bcce..c5fd00945e75 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5590,6 +5590,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	int nr_zapped, batch = 0;
+	bool unstable;
 
 restart:
 	list_for_each_entry_safe_reverse(sp, node,
@@ -5621,11 +5622,12 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 			goto restart;
 		}
 
-		if (__kvm_mmu_prepare_zap_page(kvm, sp,
-				&kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
-			batch += nr_zapped;
+		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
+				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
+		batch += nr_zapped;
+
+		if (unstable)
 			goto restart;
-		}
 	}
 
 	/*
diff --git a/arch/x86/um/shared/sysdep/syscalls_64.h b/arch/x86/um/shared/sysdep/syscalls_64.h
index 8a7d5e1da98e..1e6875b4ffd8 100644
--- a/arch/x86/um/shared/sysdep/syscalls_64.h
+++ b/arch/x86/um/shared/sysdep/syscalls_64.h
@@ -10,13 +10,12 @@
 #include <linux/msg.h>
 #include <linux/shm.h>
 
-typedef long syscall_handler_t(void);
+typedef long syscall_handler_t(long, long, long, long, long, long);
 
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	(((long (*)(long, long, long, long, long, long)) \
-	  (*sys_call_table[syscall]))(UPT_SYSCALL_ARG1(&regs->regs), \
+	(((*sys_call_table[syscall]))(UPT_SYSCALL_ARG1(&regs->regs), \
 		 		      UPT_SYSCALL_ARG2(&regs->regs), \
 				      UPT_SYSCALL_ARG3(&regs->regs), \
 				      UPT_SYSCALL_ARG4(&regs->regs), \
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 548e0dd53528..6db0333b5b7a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -171,7 +171,7 @@ void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 		unsigned int set_size)
 {
 	struct drbd_request *r;
-	struct drbd_request *req = NULL;
+	struct drbd_request *req = NULL, *tmp = NULL;
 	int expect_epoch = 0;
 	int expect_size = 0;
 
@@ -225,8 +225,11 @@ void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 	 * to catch requests being barrier-acked "unexpectedly".
 	 * It usually should find the same req again, or some READ preceding it. */
 	list_for_each_entry(req, &connection->transfer_log, tl_requests)
-		if (req->epoch == expect_epoch)
+		if (req->epoch == expect_epoch) {
+			tmp = req;
 			break;
+		}
+	req = list_prepare_entry(tmp, &connection->transfer_log, tl_requests);
 	list_for_each_entry_safe_from(req, r, &connection->transfer_log, tl_requests) {
 		if (req->epoch != expect_epoch)
 			break;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 1c152b542a52..db0b3e8982fe 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -509,8 +509,8 @@ static unsigned long fdc_busy;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
-/* Errors during formatting are counted here. */
-static int format_errors;
+/* errors encountered on the current (or last) request */
+static int floppy_errors;
 
 /* Format request descriptor. */
 static struct format_descr format_req;
@@ -530,7 +530,6 @@ static struct format_descr format_req;
 static char *floppy_track_buffer;
 static int max_buffer_sectors;
 
-static int *errors;
 typedef void (*done_f)(int);
 static const struct cont_t {
 	void (*interrupt)(void);
@@ -1455,7 +1454,7 @@ static int interpret_errors(void)
 			if (drive_params[current_drive].flags & FTD_MSG)
 				DPRINT("Over/Underrun - retrying\n");
 			bad = 0;
-		} else if (*errors >= drive_params[current_drive].max_errors.reporting) {
+		} else if (floppy_errors >= drive_params[current_drive].max_errors.reporting) {
 			print_errors();
 		}
 		if (reply_buffer[ST2] & ST2_WC || reply_buffer[ST2] & ST2_BC)
@@ -2095,7 +2094,7 @@ static void bad_flp_intr(void)
 		if (!next_valid_format(current_drive))
 			return;
 	}
-	err_count = ++(*errors);
+	err_count = ++floppy_errors;
 	INFBOUND(write_errors[current_drive].badness, err_count);
 	if (err_count > drive_params[current_drive].max_errors.abort)
 		cont->done(0);
@@ -2241,9 +2240,8 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
 		return -EINVAL;
 	}
 	format_req = *tmp_format_req;
-	format_errors = 0;
 	cont = &format_cont;
-	errors = &format_errors;
+	floppy_errors = 0;
 	ret = wait_til_done(redo_format, true);
 	if (ret == -EINTR)
 		return -EINTR;
@@ -2761,10 +2759,11 @@ static int set_next_request(void)
 	current_req = list_first_entry_or_null(&floppy_reqs, struct request,
 					       queuelist);
 	if (current_req) {
-		current_req->error_count = 0;
+		floppy_errors = 0;
 		list_del_init(&current_req->queuelist);
+		return 1;
 	}
-	return current_req != NULL;
+	return 0;
 }
 
 /* Starts or continues processing request. Will automatically unlock the
@@ -2823,7 +2822,6 @@ static void redo_fd_request(void)
 		_floppy = floppy_type + drive_params[current_drive].autodetect[drive_state[current_drive].probed_format];
 	} else
 		probing = 0;
-	errors = &(current_req->error_count);
 	tmp = make_raw_rw_request();
 	if (tmp < 2) {
 		request_done(tmp);
diff --git a/drivers/clk/at91/clk-generated.c b/drivers/clk/at91/clk-generated.c
index b656d25a9767..fe772baeb15f 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -106,6 +106,10 @@ static void clk_generated_best_diff(struct clk_rate_request *req,
 		tmp_rate = parent_rate;
 	else
 		tmp_rate = parent_rate / div;
+
+	if (tmp_rate < req->min_rate || tmp_rate > req->max_rate)
+		return;
+
 	tmp_diff = abs(req->rate - tmp_rate);
 
 	if (*best_diff < 0 || *best_diff >= tmp_diff) {
diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 11f30fd48c14..031b5f701a0a 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -65,6 +65,7 @@ static int qcom_rng_read(struct qcom_rng *rng, u8 *data, unsigned int max)
 		} else {
 			/* copy only remaining bytes */
 			memcpy(data, &val, max - currsize);
+			break;
 		}
 	} while (currsize < max);
 
diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index be1bf39a317d..90a920e7f664 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -384,8 +384,10 @@ static int stm32_crc_remove(struct platform_device *pdev)
 	struct stm32_crc *crc = platform_get_drvdata(pdev);
 	int ret = pm_runtime_get_sync(crc->dev);
 
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(crc->dev);
 		return ret;
+	}
 
 	spin_lock(&crc_list.lock);
 	list_del(&crc->list);
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index a1f09437b2b4..f9217e300eea 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -436,6 +436,7 @@ static inline int is_dma_buf_file(struct file *file)
 
 static struct file *dma_buf_getfile(struct dma_buf *dmabuf, int flags)
 {
+	static atomic64_t dmabuf_inode = ATOMIC64_INIT(0);
 	struct file *file;
 	struct inode *inode = alloc_anon_inode(dma_buf_mnt->mnt_sb);
 
@@ -445,6 +446,13 @@ static struct file *dma_buf_getfile(struct dma_buf *dmabuf, int flags)
 	inode->i_size = dmabuf->size;
 	inode_set_bytes(inode, dmabuf->size);
 
+	/*
+	 * The ->i_ino acquired from get_next_ino() is not unique thus
+	 * not suitable for using it as dentry name by dmabuf stats.
+	 * Override ->i_ino with the unique and dmabuffs specific
+	 * value.
+	 */
+	inode->i_ino = atomic64_add_return(1, &dmabuf_inode);
 	file = alloc_file_pseudo(inode, dma_buf_mnt, "dmabuf",
 				 flags, &dma_buf_fops);
 	if (IS_ERR(file))
diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index ad8822da7c27..1448dc874dfc 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -707,6 +707,9 @@ static int mvebu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long flags;
 	unsigned int on, off;
 
+	if (state->polarity != PWM_POLARITY_NORMAL)
+		return -EINVAL;
+
 	val = (unsigned long long) mvpwm->clk_rate * state->duty_cycle;
 	do_div(val, NSEC_PER_SEC);
 	if (val > UINT_MAX + 1ULL)
diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index e0f2b67558e7..47e191e11c69 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -125,9 +125,13 @@ static int vf610_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
 {
 	struct vf610_gpio_port *port = gpiochip_get_data(chip);
 	unsigned long mask = BIT(gpio);
+	u32 val;
 
-	if (port->sdata && port->sdata->have_paddr)
-		vf610_gpio_writel(mask, port->gpio_base + GPIO_PDDR);
+	if (port->sdata && port->sdata->have_paddr) {
+		val = vf610_gpio_readl(port->gpio_base + GPIO_PDDR);
+		val |= mask;
+		vf610_gpio_writel(val, port->gpio_base + GPIO_PDDR);
+	}
 
 	vf610_gpio_set(chip, gpio, value);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 7e73ac6fb21d..2eebefd26fa8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1411,9 +1411,11 @@ static inline int amdgpu_acpi_smart_shift_update(struct drm_device *dev,
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
 bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev);
+bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev);
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
 #else
 static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
+static inline bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev) { return false; }
 static inline bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev) { return false; }
 #endif
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 0e12315fa0cb..98ac53ee6bb5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1045,6 +1045,20 @@ bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev)
 		(pm_suspend_target_state == PM_SUSPEND_MEM);
 }
 
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
+	return pm_suspend_target_state != PM_SUSPEND_TO_IDLE;
+}
+
 /**
  * amdgpu_acpi_is_s0ix_active
  *
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 2bd7b9fe6005..129661f728bf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2259,7 +2259,7 @@ static int amdgpu_pmops_suspend_noirq(struct device *dev)
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 
-	if (!adev->in_s0ix)
+	if (amdgpu_acpi_should_gpu_reset(adev))
 		return amdgpu_asic_reset(adev);
 
 	return 0;
diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 86d13d6bc463..b3e3babe18c0 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4834,6 +4834,7 @@ static void fetch_monitor_name(struct drm_dp_mst_topology_mgr *mgr,
 
 	mst_edid = drm_dp_mst_get_edid(port->connector, mgr, port);
 	drm_edid_get_monitor_name(mst_edid, name, namelen);
+	kfree(mst_edid);
 }
 
 /**
diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c b/drivers/gpu/drm/i915/display/intel_dmc.c
index 73076737add7..0e04d4dd1c13 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -375,6 +375,44 @@ static void dmc_set_fw_offset(struct intel_dmc *dmc,
 	}
 }
 
+static bool dmc_mmio_addr_sanity_check(struct intel_dmc *dmc,
+				       const u32 *mmioaddr, u32 mmio_count,
+				       int header_ver, u8 dmc_id)
+{
+	struct drm_i915_private *i915 = container_of(dmc, typeof(*i915), dmc);
+	u32 start_range, end_range;
+	int i;
+
+	if (dmc_id >= DMC_FW_MAX) {
+		drm_warn(&i915->drm, "Unsupported firmware id %u\n", dmc_id);
+		return false;
+	}
+
+	if (header_ver == 1) {
+		start_range = DMC_MMIO_START_RANGE;
+		end_range = DMC_MMIO_END_RANGE;
+	} else if (dmc_id == DMC_FW_MAIN) {
+		start_range = TGL_MAIN_MMIO_START;
+		end_range = TGL_MAIN_MMIO_END;
+	} else if (DISPLAY_VER(i915) >= 13) {
+		start_range = ADLP_PIPE_MMIO_START;
+		end_range = ADLP_PIPE_MMIO_END;
+	} else if (DISPLAY_VER(i915) >= 12) {
+		start_range = TGL_PIPE_MMIO_START(dmc_id);
+		end_range = TGL_PIPE_MMIO_END(dmc_id);
+	} else {
+		drm_warn(&i915->drm, "Unknown mmio range for sanity check");
+		return false;
+	}
+
+	for (i = 0; i < mmio_count; i++) {
+		if (mmioaddr[i] < start_range || mmioaddr[i] > end_range)
+			return false;
+	}
+
+	return true;
+}
+
 static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 			       const struct intel_dmc_header_base *dmc_header,
 			       size_t rem_size, u8 dmc_id)
@@ -444,6 +482,12 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 		return 0;
 	}
 
+	if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count,
+					dmc_header->header_ver, dmc_id)) {
+		drm_err(&i915->drm, "DMC firmware has Wrong MMIO Addresses\n");
+		return 0;
+	}
+
 	for (i = 0; i < mmio_count; i++) {
 		dmc_info->mmioaddr[i] = _MMIO(mmioaddr[i]);
 		dmc_info->mmiodata[i] = mmiodata[i];
diff --git a/drivers/gpu/drm/i915/display/intel_opregion.c b/drivers/gpu/drm/i915/display/intel_opregion.c
index 08c20869d7e9..f7f49b69830f 100644
--- a/drivers/gpu/drm/i915/display/intel_opregion.c
+++ b/drivers/gpu/drm/i915/display/intel_opregion.c
@@ -376,21 +376,6 @@ int intel_opregion_notify_encoder(struct intel_encoder *intel_encoder,
 		return -EINVAL;
 	}
 
-	/*
-	 * The port numbering and mapping here is bizarre. The now-obsolete
-	 * swsci spec supports ports numbered [0..4]. Port E is handled as a
-	 * special case, but port F and beyond are not. The functionality is
-	 * supposed to be obsolete for new platforms. Just bail out if the port
-	 * number is out of bounds after mapping.
-	 */
-	if (port > 4) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "[ENCODER:%d:%s] port %c (index %u) out of bounds for display power state notification\n",
-			    intel_encoder->base.base.id, intel_encoder->base.name,
-			    port_name(intel_encoder->port), port);
-		return -EINVAL;
-	}
-
 	if (!enable)
 		parm |= 4 << 8;
 
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index bb64e7baa1cc..3c70aa5229e5 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7818,6 +7818,22 @@ enum {
 /* MMIO address range for DMC program (0x80000 - 0x82FFF) */
 #define DMC_MMIO_START_RANGE	0x80000
 #define DMC_MMIO_END_RANGE	0x8FFFF
+#define DMC_V1_MMIO_START_RANGE	0x80000
+#define TGL_MAIN_MMIO_START	0x8F000
+#define TGL_MAIN_MMIO_END	0x8FFFF
+#define _TGL_PIPEA_MMIO_START	0x92000
+#define _TGL_PIPEA_MMIO_END	0x93FFF
+#define _TGL_PIPEB_MMIO_START	0x96000
+#define _TGL_PIPEB_MMIO_END	0x97FFF
+#define ADLP_PIPE_MMIO_START	0x5F000
+#define ADLP_PIPE_MMIO_END	0x5FFFF
+
+#define TGL_PIPE_MMIO_START(dmc_id)	_PICK_EVEN(((dmc_id) - 1), _TGL_PIPEA_MMIO_START,\
+						_TGL_PIPEB_MMIO_START)
+
+#define TGL_PIPE_MMIO_END(dmc_id)	_PICK_EVEN(((dmc_id) - 1), _TGL_PIPEA_MMIO_END,\
+						_TGL_PIPEB_MMIO_END)
+
 #define SKL_DMC_DC3_DC5_COUNT	_MMIO(0x80030)
 #define SKL_DMC_DC5_DC6_COUNT	_MMIO(0x8002C)
 #define BXT_DMC_DC3_DC5_COUNT	_MMIO(0x80038)
diff --git a/drivers/i2c/busses/i2c-mt7621.c b/drivers/i2c/busses/i2c-mt7621.c
index 45fe4a7fe0c0..901f0fb04fee 100644
--- a/drivers/i2c/busses/i2c-mt7621.c
+++ b/drivers/i2c/busses/i2c-mt7621.c
@@ -304,7 +304,8 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 
 	if (i2c->bus_freq == 0) {
 		dev_warn(i2c->dev, "clock-frequency 0 not supported\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_disable_clk;
 	}
 
 	adap = &i2c->adap;
@@ -322,10 +323,15 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 
 	ret = i2c_add_adapter(adap);
 	if (ret < 0)
-		return ret;
+		goto err_disable_clk;
 
 	dev_info(&pdev->dev, "clock %u kHz\n", i2c->bus_freq / 1000);
 
+	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(i2c->clk);
+
 	return ret;
 }
 
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 8c1b31ed0c42..ac8e7d60672a 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -77,6 +77,7 @@
 
 /* SB800 constants */
 #define SB800_PIIX4_SMB_IDX		0xcd6
+#define SB800_PIIX4_SMB_MAP_SIZE	2
 
 #define KERNCZ_IMC_IDX			0x3e
 #define KERNCZ_IMC_DATA			0x3f
@@ -97,6 +98,9 @@
 #define SB800_PIIX4_PORT_IDX_MASK_KERNCZ	0x18
 #define SB800_PIIX4_PORT_IDX_SHIFT_KERNCZ	3
 
+#define SB800_PIIX4_FCH_PM_ADDR			0xFED80300
+#define SB800_PIIX4_FCH_PM_SIZE			8
+
 /* insmod parameters */
 
 /* If force is set to anything different from 0, we forcibly enable the
@@ -155,6 +159,12 @@ static const char *piix4_main_port_names_sb800[PIIX4_MAX_ADAPTERS] = {
 };
 static const char *piix4_aux_port_name_sb800 = " port 1";
 
+struct sb800_mmio_cfg {
+	void __iomem *addr;
+	struct resource *res;
+	bool use_mmio;
+};
+
 struct i2c_piix4_adapdata {
 	unsigned short smba;
 
@@ -162,8 +172,75 @@ struct i2c_piix4_adapdata {
 	bool sb800_main;
 	bool notify_imc;
 	u8 port;		/* Port number, shifted */
+	struct sb800_mmio_cfg mmio_cfg;
 };
 
+static int piix4_sb800_region_request(struct device *dev,
+				      struct sb800_mmio_cfg *mmio_cfg)
+{
+	if (mmio_cfg->use_mmio) {
+		struct resource *res;
+		void __iomem *addr;
+
+		res = request_mem_region_muxed(SB800_PIIX4_FCH_PM_ADDR,
+					       SB800_PIIX4_FCH_PM_SIZE,
+					       "sb800_piix4_smb");
+		if (!res) {
+			dev_err(dev,
+				"SMBus base address memory region 0x%x already in use.\n",
+				SB800_PIIX4_FCH_PM_ADDR);
+			return -EBUSY;
+		}
+
+		addr = ioremap(SB800_PIIX4_FCH_PM_ADDR,
+			       SB800_PIIX4_FCH_PM_SIZE);
+		if (!addr) {
+			release_resource(res);
+			dev_err(dev, "SMBus base address mapping failed.\n");
+			return -ENOMEM;
+		}
+
+		mmio_cfg->res = res;
+		mmio_cfg->addr = addr;
+
+		return 0;
+	}
+
+	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE,
+				  "sb800_piix4_smb")) {
+		dev_err(dev,
+			"SMBus base address index region 0x%x already in use.\n",
+			SB800_PIIX4_SMB_IDX);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void piix4_sb800_region_release(struct device *dev,
+				       struct sb800_mmio_cfg *mmio_cfg)
+{
+	if (mmio_cfg->use_mmio) {
+		iounmap(mmio_cfg->addr);
+		release_resource(mmio_cfg->res);
+		return;
+	}
+
+	release_region(SB800_PIIX4_SMB_IDX, SB800_PIIX4_SMB_MAP_SIZE);
+}
+
+static bool piix4_sb800_use_mmio(struct pci_dev *PIIX4_dev)
+{
+	/*
+	 * cd6h/cd7h port I/O accesses can be disabled on AMD processors
+	 * w/ SMBus PCI revision ID 0x51 or greater. MMIO is supported on
+	 * the same processors and is the recommended access method.
+	 */
+	return (PIIX4_dev->vendor == PCI_VENDOR_ID_AMD &&
+		PIIX4_dev->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS &&
+		PIIX4_dev->revision >= 0x51);
+}
+
 static int piix4_setup(struct pci_dev *PIIX4_dev,
 		       const struct pci_device_id *id)
 {
@@ -263,12 +340,61 @@ static int piix4_setup(struct pci_dev *PIIX4_dev,
 	return piix4_smba;
 }
 
+static int piix4_setup_sb800_smba(struct pci_dev *PIIX4_dev,
+				  u8 smb_en,
+				  u8 aux,
+				  u8 *smb_en_status,
+				  unsigned short *piix4_smba)
+{
+	struct sb800_mmio_cfg mmio_cfg;
+	u8 smba_en_lo;
+	u8 smba_en_hi;
+	int retval;
+
+	mmio_cfg.use_mmio = piix4_sb800_use_mmio(PIIX4_dev);
+	retval = piix4_sb800_region_request(&PIIX4_dev->dev, &mmio_cfg);
+	if (retval)
+		return retval;
+
+	if (mmio_cfg.use_mmio) {
+		smba_en_lo = ioread8(mmio_cfg.addr);
+		smba_en_hi = ioread8(mmio_cfg.addr + 1);
+	} else {
+		outb_p(smb_en, SB800_PIIX4_SMB_IDX);
+		smba_en_lo = inb_p(SB800_PIIX4_SMB_IDX + 1);
+		outb_p(smb_en + 1, SB800_PIIX4_SMB_IDX);
+		smba_en_hi = inb_p(SB800_PIIX4_SMB_IDX + 1);
+	}
+
+	piix4_sb800_region_release(&PIIX4_dev->dev, &mmio_cfg);
+
+	if (!smb_en) {
+		*smb_en_status = smba_en_lo & 0x10;
+		*piix4_smba = smba_en_hi << 8;
+		if (aux)
+			*piix4_smba |= 0x20;
+	} else {
+		*smb_en_status = smba_en_lo & 0x01;
+		*piix4_smba = ((smba_en_hi << 8) | smba_en_lo) & 0xffe0;
+	}
+
+	if (!*smb_en_status) {
+		dev_err(&PIIX4_dev->dev,
+			"SMBus Host Controller not enabled!\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 			     const struct pci_device_id *id, u8 aux)
 {
 	unsigned short piix4_smba;
-	u8 smba_en_lo, smba_en_hi, smb_en, smb_en_status, port_sel;
+	u8 smb_en, smb_en_status, port_sel;
 	u8 i2ccfg, i2ccfg_offset = 0x10;
+	struct sb800_mmio_cfg mmio_cfg;
+	int retval;
 
 	/* SB800 and later SMBus does not support forcing address */
 	if (force || force_addr) {
@@ -290,35 +416,11 @@ static int piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 	else
 		smb_en = (aux) ? 0x28 : 0x2c;
 
-	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, 2, "sb800_piix4_smb")) {
-		dev_err(&PIIX4_dev->dev,
-			"SMB base address index region 0x%x already in use.\n",
-			SB800_PIIX4_SMB_IDX);
-		return -EBUSY;
-	}
-
-	outb_p(smb_en, SB800_PIIX4_SMB_IDX);
-	smba_en_lo = inb_p(SB800_PIIX4_SMB_IDX + 1);
-	outb_p(smb_en + 1, SB800_PIIX4_SMB_IDX);
-	smba_en_hi = inb_p(SB800_PIIX4_SMB_IDX + 1);
+	retval = piix4_setup_sb800_smba(PIIX4_dev, smb_en, aux, &smb_en_status,
+					&piix4_smba);
 
-	release_region(SB800_PIIX4_SMB_IDX, 2);
-
-	if (!smb_en) {
-		smb_en_status = smba_en_lo & 0x10;
-		piix4_smba = smba_en_hi << 8;
-		if (aux)
-			piix4_smba |= 0x20;
-	} else {
-		smb_en_status = smba_en_lo & 0x01;
-		piix4_smba = ((smba_en_hi << 8) | smba_en_lo) & 0xffe0;
-	}
-
-	if (!smb_en_status) {
-		dev_err(&PIIX4_dev->dev,
-			"SMBus Host Controller not enabled!\n");
-		return -ENODEV;
-	}
+	if (retval)
+		return retval;
 
 	if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
 		return -ENODEV;
@@ -371,10 +473,11 @@ static int piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 			piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
 		}
 	} else {
-		if (!request_muxed_region(SB800_PIIX4_SMB_IDX, 2,
-					  "sb800_piix4_smb")) {
+		mmio_cfg.use_mmio = piix4_sb800_use_mmio(PIIX4_dev);
+		retval = piix4_sb800_region_request(&PIIX4_dev->dev, &mmio_cfg);
+		if (retval) {
 			release_region(piix4_smba, SMBIOSIZE);
-			return -EBUSY;
+			return retval;
 		}
 
 		outb_p(SB800_PIIX4_PORT_IDX_SEL, SB800_PIIX4_SMB_IDX);
@@ -384,7 +487,7 @@ static int piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 				       SB800_PIIX4_PORT_IDX;
 		piix4_port_mask_sb800 = SB800_PIIX4_PORT_IDX_MASK;
 		piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
-		release_region(SB800_PIIX4_SMB_IDX, 2);
+		piix4_sb800_region_release(&PIIX4_dev->dev, &mmio_cfg);
 	}
 
 	dev_info(&PIIX4_dev->dev,
@@ -662,6 +765,29 @@ static void piix4_imc_wakeup(void)
 	release_region(KERNCZ_IMC_IDX, 2);
 }
 
+static int piix4_sb800_port_sel(u8 port, struct sb800_mmio_cfg *mmio_cfg)
+{
+	u8 smba_en_lo, val;
+
+	if (mmio_cfg->use_mmio) {
+		smba_en_lo = ioread8(mmio_cfg->addr + piix4_port_sel_sb800);
+		val = (smba_en_lo & ~piix4_port_mask_sb800) | port;
+		if (smba_en_lo != val)
+			iowrite8(val, mmio_cfg->addr + piix4_port_sel_sb800);
+
+		return (smba_en_lo & piix4_port_mask_sb800);
+	}
+
+	outb_p(piix4_port_sel_sb800, SB800_PIIX4_SMB_IDX);
+	smba_en_lo = inb_p(SB800_PIIX4_SMB_IDX + 1);
+
+	val = (smba_en_lo & ~piix4_port_mask_sb800) | port;
+	if (smba_en_lo != val)
+		outb_p(val, SB800_PIIX4_SMB_IDX + 1);
+
+	return (smba_en_lo & piix4_port_mask_sb800);
+}
+
 /*
  * Handles access to multiple SMBus ports on the SB800.
  * The port is selected by bits 2:1 of the smb_en register (0x2c).
@@ -678,12 +804,12 @@ static s32 piix4_access_sb800(struct i2c_adapter *adap, u16 addr,
 	unsigned short piix4_smba = adapdata->smba;
 	int retries = MAX_TIMEOUT;
 	int smbslvcnt;
-	u8 smba_en_lo;
-	u8 port;
+	u8 prev_port;
 	int retval;
 
-	if (!request_muxed_region(SB800_PIIX4_SMB_IDX, 2, "sb800_piix4_smb"))
-		return -EBUSY;
+	retval = piix4_sb800_region_request(&adap->dev, &adapdata->mmio_cfg);
+	if (retval)
+		return retval;
 
 	/* Request the SMBUS semaphore, avoid conflicts with the IMC */
 	smbslvcnt  = inb_p(SMBSLVCNT);
@@ -738,18 +864,12 @@ static s32 piix4_access_sb800(struct i2c_adapter *adap, u16 addr,
 		}
 	}
 
-	outb_p(piix4_port_sel_sb800, SB800_PIIX4_SMB_IDX);
-	smba_en_lo = inb_p(SB800_PIIX4_SMB_IDX + 1);
-
-	port = adapdata->port;
-	if ((smba_en_lo & piix4_port_mask_sb800) != port)
-		outb_p((smba_en_lo & ~piix4_port_mask_sb800) | port,
-		       SB800_PIIX4_SMB_IDX + 1);
+	prev_port = piix4_sb800_port_sel(adapdata->port, &adapdata->mmio_cfg);
 
 	retval = piix4_access(adap, addr, flags, read_write,
 			      command, size, data);
 
-	outb_p(smba_en_lo, SB800_PIIX4_SMB_IDX + 1);
+	piix4_sb800_port_sel(prev_port, &adapdata->mmio_cfg);
 
 	/* Release the semaphore */
 	outb_p(smbslvcnt | 0x20, SMBSLVCNT);
@@ -758,7 +878,7 @@ static s32 piix4_access_sb800(struct i2c_adapter *adap, u16 addr,
 		piix4_imc_wakeup();
 
 release:
-	release_region(SB800_PIIX4_SMB_IDX, 2);
+	piix4_sb800_region_release(&adap->dev, &adapdata->mmio_cfg);
 	return retval;
 }
 
@@ -836,6 +956,7 @@ static int piix4_add_adapter(struct pci_dev *dev, unsigned short smba,
 		return -ENOMEM;
 	}
 
+	adapdata->mmio_cfg.use_mmio = piix4_sb800_use_mmio(dev);
 	adapdata->smba = smba;
 	adapdata->sb800_main = sb800_main;
 	adapdata->port = port << piix4_port_shift_sb800;
diff --git a/drivers/input/input.c b/drivers/input/input.c
index ccaeb2426385..ba246fabc6c1 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -47,6 +47,17 @@ static DEFINE_MUTEX(input_mutex);
 
 static const struct input_value input_value_sync = { EV_SYN, SYN_REPORT, 1 };
 
+static const unsigned int input_max_code[EV_CNT] = {
+	[EV_KEY] = KEY_MAX,
+	[EV_REL] = REL_MAX,
+	[EV_ABS] = ABS_MAX,
+	[EV_MSC] = MSC_MAX,
+	[EV_SW] = SW_MAX,
+	[EV_LED] = LED_MAX,
+	[EV_SND] = SND_MAX,
+	[EV_FF] = FF_MAX,
+};
+
 static inline int is_event_supported(unsigned int code,
 				     unsigned long *bm, unsigned int max)
 {
@@ -2074,6 +2085,14 @@ EXPORT_SYMBOL(input_get_timestamp);
  */
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code)
 {
+	if (type < EV_CNT && input_max_code[type] &&
+	    code > input_max_code[type]) {
+		pr_err("%s: invalid code %u for type %u\n", __func__, code,
+		       type);
+		dump_stack();
+		return;
+	}
+
 	switch (type) {
 	case EV_KEY:
 		__set_bit(code, dev->keybit);
diff --git a/drivers/input/touchscreen/ili210x.c b/drivers/input/touchscreen/ili210x.c
index 30576a5f2f04..f437eefec94a 100644
--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -420,9 +420,9 @@ static int ili210x_i2c_probe(struct i2c_client *client,
 		if (error)
 			return error;
 
-		usleep_range(50, 100);
+		usleep_range(12000, 15000);
 		gpiod_set_value_cansleep(reset_gpio, 0);
-		msleep(100);
+		msleep(160);
 	}
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
diff --git a/drivers/input/touchscreen/stmfts.c b/drivers/input/touchscreen/stmfts.c
index bc11203c9cf7..72e0b767e1ba 100644
--- a/drivers/input/touchscreen/stmfts.c
+++ b/drivers/input/touchscreen/stmfts.c
@@ -339,11 +339,11 @@ static int stmfts_input_open(struct input_dev *dev)
 
 	err = pm_runtime_get_sync(&sdata->client->dev);
 	if (err < 0)
-		return err;
+		goto out;
 
 	err = i2c_smbus_write_byte(sdata->client, STMFTS_MS_MT_SENSE_ON);
 	if (err)
-		return err;
+		goto out;
 
 	mutex_lock(&sdata->mutex);
 	sdata->running = true;
@@ -366,7 +366,9 @@ static int stmfts_input_open(struct input_dev *dev)
 				 "failed to enable touchkey\n");
 	}
 
-	return 0;
+out:
+	pm_runtime_put_noidle(&sdata->client->dev);
+	return err;
 }
 
 static void stmfts_input_close(struct input_dev *dev)
diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index b56a54d6c5a9..8f184a852a0a 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -18,14 +18,9 @@
 
 #define M_CAN_PCI_MMIO_BAR		0
 
+#define M_CAN_CLOCK_FREQ_EHL		200000000
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
-struct m_can_pci_config {
-	const struct can_bittiming_const *bit_timing;
-	const struct can_bittiming_const *data_timing;
-	unsigned int clock_freq;
-};
-
 struct m_can_pci_priv {
 	struct m_can_classdev cdev;
 
@@ -89,40 +84,9 @@ static struct m_can_ops m_can_pci_ops = {
 	.read_fifo = iomap_read_fifo,
 };
 
-static const struct can_bittiming_const m_can_bittiming_const_ehl = {
-	.name = KBUILD_MODNAME,
-	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
-	.tseg1_max = 64,
-	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
-	.tseg2_max = 128,
-	.sjw_max = 128,
-	.brp_min = 1,
-	.brp_max = 512,
-	.brp_inc = 1,
-};
-
-static const struct can_bittiming_const m_can_data_bittiming_const_ehl = {
-	.name = KBUILD_MODNAME,
-	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
-	.tseg1_max = 16,
-	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
-	.tseg2_max = 8,
-	.sjw_max = 4,
-	.brp_min = 1,
-	.brp_max = 32,
-	.brp_inc = 1,
-};
-
-static const struct m_can_pci_config m_can_pci_ehl = {
-	.bit_timing = &m_can_bittiming_const_ehl,
-	.data_timing = &m_can_data_bittiming_const_ehl,
-	.clock_freq = 200000000,
-};
-
 static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 {
 	struct device *dev = &pci->dev;
-	const struct m_can_pci_config *cfg;
 	struct m_can_classdev *mcan_class;
 	struct m_can_pci_priv *priv;
 	void __iomem *base;
@@ -150,8 +114,6 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (!mcan_class)
 		return -ENOMEM;
 
-	cfg = (const struct m_can_pci_config *)id->driver_data;
-
 	priv = cdev_to_priv(mcan_class);
 
 	priv->base = base;
@@ -163,9 +125,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
 	mcan_class->pm_clock_support = 1;
-	mcan_class->bit_timing = cfg->bit_timing;
-	mcan_class->data_timing = cfg->data_timing;
-	mcan_class->can.clock.freq = cfg->clock_freq;
+	mcan_class->can.clock.freq = id->driver_data;
 	mcan_class->ops = &m_can_pci_ops;
 
 	pci_set_drvdata(pci, mcan_class);
@@ -218,8 +178,8 @@ static SIMPLE_DEV_PM_OPS(m_can_pci_pm_ops,
 			 m_can_pci_suspend, m_can_pci_resume);
 
 static const struct pci_device_id m_can_pci_id_table[] = {
-	{ PCI_VDEVICE(INTEL, 0x4bc1), (kernel_ulong_t)&m_can_pci_ehl, },
-	{ PCI_VDEVICE(INTEL, 0x4bc2), (kernel_ulong_t)&m_can_pci_ehl, },
+	{ PCI_VDEVICE(INTEL, 0x4bc1), M_CAN_CLOCK_FREQ_EHL, },
+	{ PCI_VDEVICE(INTEL, 0x4bc2), M_CAN_CLOCK_FREQ_EHL, },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, m_can_pci_id_table);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 72f8751784c3..e9c6f1fa0b1a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -345,7 +345,6 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		     int budget)
 {
 	struct net_device *ndev = aq_nic_get_ndev(self->aq_nic);
-	bool is_rsc_completed = true;
 	int err = 0;
 
 	for (; (self->sw_head != self->hw_head) && budget;
@@ -363,12 +362,17 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			continue;
 
 		if (!buff->is_eop) {
+			unsigned int frag_cnt = 0U;
 			buff_ = buff;
 			do {
+				bool is_rsc_completed = true;
+
 				if (buff_->next >= self->size) {
 					err = -EIO;
 					goto err_exit;
 				}
+
+				frag_cnt++;
 				next_ = buff_->next,
 				buff_ = &self->buff_ring[next_];
 				is_rsc_completed =
@@ -376,18 +380,17 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 							    next_,
 							    self->hw_head);
 
-				if (unlikely(!is_rsc_completed))
-					break;
+				if (unlikely(!is_rsc_completed) ||
+						frag_cnt > MAX_SKB_FRAGS) {
+					err = 0;
+					goto err_exit;
+				}
 
 				buff->is_error |= buff_->is_error;
 				buff->is_cso_err |= buff_->is_cso_err;
 
 			} while (!buff_->is_eop);
 
-			if (!is_rsc_completed) {
-				err = 0;
-				goto err_exit;
-			}
 			if (buff->is_error ||
 			    (buff->is_lro && buff->is_cso_err)) {
 				buff_ = buff;
@@ -445,7 +448,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		       ALIGN(hdr_len, sizeof(long)));
 
 		if (buff->len - hdr_len > 0) {
-			skb_add_rx_frag(skb, 0, buff->rxdata.page,
+			skb_add_rx_frag(skb, i++, buff->rxdata.page,
 					buff->rxdata.pg_off + hdr_len,
 					buff->len - hdr_len,
 					AQ_CFG_RX_FRAME_MAX);
@@ -454,7 +457,6 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 
 		if (!buff->is_eop) {
 			buff_ = buff;
-			i = 1U;
 			do {
 				next_ = buff_->next;
 				buff_ = &self->buff_ring[next_];
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 9f1b15077e7d..45c17c585d74 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -889,6 +889,13 @@ int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 		err = -ENXIO;
 		goto err_exit;
 	}
+
+	/* Validate that the new hw_head_ is reasonable. */
+	if (hw_head_ >= ring->size) {
+		err = -ENXIO;
+		goto err_exit;
+	}
+
 	ring->hw_head = hw_head_;
 	err = aq_hw_err_from_flags(self);
 
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 0877b3d7f88c..ae541a9d1eee 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2585,8 +2585,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 		device_set_wakeup_capable(&pdev->dev, 1);
 
 	priv->wol_clk = devm_clk_get_optional(&pdev->dev, "sw_sysportwol");
-	if (IS_ERR(priv->wol_clk))
-		return PTR_ERR(priv->wol_clk);
+	if (IS_ERR(priv->wol_clk)) {
+		ret = PTR_ERR(priv->wol_clk);
+		goto err_deregister_fixed_link;
+	}
 
 	/* Set the needed headroom once and for all */
 	BUILD_BUG_ON(sizeof(struct bcm_tsb) != 8);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 217c1a0f8940..2fd3dd4b8b81 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1250,7 +1250,6 @@ static void gem_rx_refill(struct macb_queue *queue)
 		/* Make hw descriptor updates visible to CPU */
 		rmb();
 
-		queue->rx_prepared_head++;
 		desc = macb_rx_desc(queue, entry);
 
 		if (!queue->rx_skbuff[entry]) {
@@ -1289,6 +1288,7 @@ static void gem_rx_refill(struct macb_queue *queue)
 			dma_wmb();
 			desc->addr &= ~MACB_BIT(RX_USED);
 		}
+		queue->rx_prepared_head++;
 	}
 
 	/* Make descriptor updates visible to hardware */
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index fcedd733bacb..834a3f8c80da 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1398,8 +1398,10 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* alloc_etherdev ensures aligned and zeroed private structures */
 	dev = alloc_etherdev (sizeof (*tp));
-	if (!dev)
+	if (!dev) {
+		pci_disable_device(pdev);
 		return -ENOMEM;
+	}
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	if (pci_resource_len (pdev, 0) < tulip_tbl[chip_idx].io_size) {
@@ -1778,6 +1780,7 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_free_netdev:
 	free_netdev (dev);
+	pci_disable_device(pdev);
 	return -ENODEV;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index f74610442bda..533a953f15ac 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -115,6 +115,8 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
 	q_vector->rx.itr_setting = ICE_DFLT_RX_ITR;
 	q_vector->tx.itr_mode = ITR_DYNAMIC;
 	q_vector->rx.itr_mode = ITR_DYNAMIC;
+	q_vector->tx.type = ICE_TX_CONTAINER;
+	q_vector->rx.type = ICE_RX_CONTAINER;
 
 	if (vsi->type == ICE_VSI_VF)
 		goto out;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 38c2d9a5574a..19f115402969 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3466,15 +3466,9 @@ static int ice_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 	return 0;
 }
 
-enum ice_container_type {
-	ICE_RX_CONTAINER,
-	ICE_TX_CONTAINER,
-};
-
 /**
  * ice_get_rc_coalesce - get ITR values for specific ring container
  * @ec: ethtool structure to fill with driver's coalesce settings
- * @c_type: container type, Rx or Tx
  * @rc: ring container that the ITR values will come from
  *
  * Query the device for ice_ring_container specific ITR values. This is
@@ -3484,13 +3478,12 @@ enum ice_container_type {
  * Returns 0 on success, negative otherwise.
  */
 static int
-ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
-		    struct ice_ring_container *rc)
+ice_get_rc_coalesce(struct ethtool_coalesce *ec, struct ice_ring_container *rc)
 {
 	if (!rc->ring)
 		return -EINVAL;
 
-	switch (c_type) {
+	switch (rc->type) {
 	case ICE_RX_CONTAINER:
 		ec->use_adaptive_rx_coalesce = ITR_IS_DYNAMIC(rc);
 		ec->rx_coalesce_usecs = rc->itr_setting;
@@ -3501,7 +3494,7 @@ ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		ec->tx_coalesce_usecs = rc->itr_setting;
 		break;
 	default:
-		dev_dbg(ice_pf_to_dev(rc->ring->vsi->back), "Invalid c_type %d\n", c_type);
+		dev_dbg(ice_pf_to_dev(rc->ring->vsi->back), "Invalid c_type %d\n", rc->type);
 		return -EINVAL;
 	}
 
@@ -3522,18 +3515,18 @@ static int
 ice_get_q_coalesce(struct ice_vsi *vsi, struct ethtool_coalesce *ec, int q_num)
 {
 	if (q_num < vsi->num_rxq && q_num < vsi->num_txq) {
-		if (ice_get_rc_coalesce(ec, ICE_RX_CONTAINER,
+		if (ice_get_rc_coalesce(ec,
 					&vsi->rx_rings[q_num]->q_vector->rx))
 			return -EINVAL;
-		if (ice_get_rc_coalesce(ec, ICE_TX_CONTAINER,
+		if (ice_get_rc_coalesce(ec,
 					&vsi->tx_rings[q_num]->q_vector->tx))
 			return -EINVAL;
 	} else if (q_num < vsi->num_rxq) {
-		if (ice_get_rc_coalesce(ec, ICE_RX_CONTAINER,
+		if (ice_get_rc_coalesce(ec,
 					&vsi->rx_rings[q_num]->q_vector->rx))
 			return -EINVAL;
 	} else if (q_num < vsi->num_txq) {
-		if (ice_get_rc_coalesce(ec, ICE_TX_CONTAINER,
+		if (ice_get_rc_coalesce(ec,
 					&vsi->tx_rings[q_num]->q_vector->tx))
 			return -EINVAL;
 	} else {
@@ -3585,7 +3578,6 @@ ice_get_per_q_coalesce(struct net_device *netdev, u32 q_num,
 
 /**
  * ice_set_rc_coalesce - set ITR values for specific ring container
- * @c_type: container type, Rx or Tx
  * @ec: ethtool structure from user to update ITR settings
  * @rc: ring container that the ITR values will come from
  * @vsi: VSI associated to the ring container
@@ -3597,10 +3589,10 @@ ice_get_per_q_coalesce(struct net_device *netdev, u32 q_num,
  * Returns 0 on success, negative otherwise.
  */
 static int
-ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
+ice_set_rc_coalesce(struct ethtool_coalesce *ec,
 		    struct ice_ring_container *rc, struct ice_vsi *vsi)
 {
-	const char *c_type_str = (c_type == ICE_RX_CONTAINER) ? "rx" : "tx";
+	const char *c_type_str = (rc->type == ICE_RX_CONTAINER) ? "rx" : "tx";
 	u32 use_adaptive_coalesce, coalesce_usecs;
 	struct ice_pf *pf = vsi->back;
 	u16 itr_setting;
@@ -3608,7 +3600,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 	if (!rc->ring)
 		return -EINVAL;
 
-	switch (c_type) {
+	switch (rc->type) {
 	case ICE_RX_CONTAINER:
 		if (ec->rx_coalesce_usecs_high > ICE_MAX_INTRL ||
 		    (ec->rx_coalesce_usecs_high &&
@@ -3641,7 +3633,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 		break;
 	default:
 		dev_dbg(ice_pf_to_dev(pf), "Invalid container type %d\n",
-			c_type);
+			rc->type);
 		return -EINVAL;
 	}
 
@@ -3690,22 +3682,22 @@ static int
 ice_set_q_coalesce(struct ice_vsi *vsi, struct ethtool_coalesce *ec, int q_num)
 {
 	if (q_num < vsi->num_rxq && q_num < vsi->num_txq) {
-		if (ice_set_rc_coalesce(ICE_RX_CONTAINER, ec,
+		if (ice_set_rc_coalesce(ec,
 					&vsi->rx_rings[q_num]->q_vector->rx,
 					vsi))
 			return -EINVAL;
 
-		if (ice_set_rc_coalesce(ICE_TX_CONTAINER, ec,
+		if (ice_set_rc_coalesce(ec,
 					&vsi->tx_rings[q_num]->q_vector->tx,
 					vsi))
 			return -EINVAL;
 	} else if (q_num < vsi->num_rxq) {
-		if (ice_set_rc_coalesce(ICE_RX_CONTAINER, ec,
+		if (ice_set_rc_coalesce(ec,
 					&vsi->rx_rings[q_num]->q_vector->rx,
 					vsi))
 			return -EINVAL;
 	} else if (q_num < vsi->num_txq) {
-		if (ice_set_rc_coalesce(ICE_TX_CONTAINER, ec,
+		if (ice_set_rc_coalesce(ec,
 					&vsi->tx_rings[q_num]->q_vector->tx,
 					vsi))
 			return -EINVAL;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 653996e8fd30..4417238b0e64 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2980,8 +2980,8 @@ ice_vsi_rebuild_get_coalesce(struct ice_vsi *vsi,
 	ice_for_each_q_vector(vsi, i) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
 
-		coalesce[i].itr_tx = q_vector->tx.itr_setting;
-		coalesce[i].itr_rx = q_vector->rx.itr_setting;
+		coalesce[i].itr_tx = q_vector->tx.itr_settings;
+		coalesce[i].itr_rx = q_vector->rx.itr_settings;
 		coalesce[i].intrl = q_vector->intrl;
 
 		if (i < vsi->num_txq)
@@ -3037,21 +3037,21 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 		 */
 		if (i < vsi->alloc_rxq && coalesce[i].rx_valid) {
 			rc = &vsi->q_vectors[i]->rx;
-			rc->itr_setting = coalesce[i].itr_rx;
+			rc->itr_settings = coalesce[i].itr_rx;
 			ice_write_itr(rc, rc->itr_setting);
 		} else if (i < vsi->alloc_rxq) {
 			rc = &vsi->q_vectors[i]->rx;
-			rc->itr_setting = coalesce[0].itr_rx;
+			rc->itr_settings = coalesce[0].itr_rx;
 			ice_write_itr(rc, rc->itr_setting);
 		}
 
 		if (i < vsi->alloc_txq && coalesce[i].tx_valid) {
 			rc = &vsi->q_vectors[i]->tx;
-			rc->itr_setting = coalesce[i].itr_tx;
+			rc->itr_settings = coalesce[i].itr_tx;
 			ice_write_itr(rc, rc->itr_setting);
 		} else if (i < vsi->alloc_txq) {
 			rc = &vsi->q_vectors[i]->tx;
-			rc->itr_setting = coalesce[0].itr_tx;
+			rc->itr_settings = coalesce[0].itr_tx;
 			ice_write_itr(rc, rc->itr_setting);
 		}
 
@@ -3065,12 +3065,12 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 	for (; i < vsi->num_q_vectors; i++) {
 		/* transmit */
 		rc = &vsi->q_vectors[i]->tx;
-		rc->itr_setting = coalesce[0].itr_tx;
+		rc->itr_settings = coalesce[0].itr_tx;
 		ice_write_itr(rc, rc->itr_setting);
 
 		/* receive */
 		rc = &vsi->q_vectors[i]->rx;
-		rc->itr_setting = coalesce[0].itr_rx;
+		rc->itr_settings = coalesce[0].itr_rx;
 		ice_write_itr(rc, rc->itr_setting);
 
 		vsi->q_vectors[i]->intrl = coalesce[0].intrl;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 27b5c75ce386..188abf36a5b2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5656,9 +5656,10 @@ static int ice_up_complete(struct ice_vsi *vsi)
 		netif_carrier_on(vsi->netdev);
 	}
 
-	/* clear this now, and the first stats read will be used as baseline */
-	vsi->stat_offsets_loaded = false;
-
+	/* Perform an initial read of the statistics registers now to
+	 * set the baseline so counters are ready when interface is up
+	 */
+	ice_update_eth_stats(vsi);
 	ice_service_task_schedule(pf);
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ef26ff351b57..9b50e9e6042a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -254,12 +254,19 @@ ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
  * This function must be called periodically to ensure that the cached value
  * is never more than 2 seconds old. It must also be called whenever the PHC
  * time has been changed.
+ *
+ * Return:
+ * * 0 - OK, successfully updated
+ * * -EAGAIN - PF was busy, need to reschedule the update
  */
-static void ice_ptp_update_cached_phctime(struct ice_pf *pf)
+static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
 {
 	u64 systime;
 	int i;
 
+	if (test_and_set_bit(ICE_CFG_BUSY, pf->state))
+		return -EAGAIN;
+
 	/* Read the current PHC time */
 	systime = ice_ptp_read_src_clk_reg(pf, NULL);
 
@@ -282,6 +289,9 @@ static void ice_ptp_update_cached_phctime(struct ice_pf *pf)
 			WRITE_ONCE(vsi->rx_rings[j]->cached_phctime, systime);
 		}
 	}
+	clear_bit(ICE_CFG_BUSY, pf->state);
+
+	return 0;
 }
 
 /**
@@ -1418,17 +1428,18 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 {
 	struct ice_ptp *ptp = container_of(work, struct ice_ptp, work.work);
 	struct ice_pf *pf = container_of(ptp, struct ice_pf, ptp);
+	int err;
 
 	if (!test_bit(ICE_FLAG_PTP, pf->flags))
 		return;
 
-	ice_ptp_update_cached_phctime(pf);
+	err = ice_ptp_update_cached_phctime(pf);
 
 	ice_ptp_tx_tstamp_cleanup(&pf->hw, &pf->ptp.port.tx);
 
-	/* Run twice a second */
+	/* Run twice a second or reschedule if phc update failed */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
-				   msecs_to_jiffies(500));
+				   msecs_to_jiffies(err ? 10 : 500));
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 7c2328529ff8..4adc3dff04ba 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -332,6 +332,11 @@ static inline bool ice_ring_is_xdp(struct ice_ring *ring)
 	return !!(ring->flags & ICE_TX_FLAGS_RING_XDP);
 }
 
+enum ice_container_type {
+	ICE_RX_CONTAINER,
+	ICE_TX_CONTAINER,
+};
+
 struct ice_ring_container {
 	/* head of linked-list of rings */
 	struct ice_ring *ring;
@@ -340,9 +345,15 @@ struct ice_ring_container {
 	/* this matches the maximum number of ITR bits, but in usec
 	 * values, so it is shifted left one bit (bit zero is ignored)
 	 */
-	u16 itr_setting:13;
-	u16 itr_reserved:2;
-	u16 itr_mode:1;
+	union {
+		struct {
+			u16 itr_setting:13;
+			u16 itr_reserved:2;
+			u16 itr_mode:1;
+		};
+		u16 itr_settings;
+	};
+	enum ice_container_type type;
 };
 
 struct ice_coalesce_stored {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index bf8ef81f6c0e..b88303351484 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5505,7 +5505,8 @@ static void igb_watchdog_task(struct work_struct *work)
 				break;
 			}
 
-			if (adapter->link_speed != SPEED_1000)
+			if (adapter->link_speed != SPEED_1000 ||
+			    !hw->phy.ops.read_reg)
 				goto no_wait;
 
 			/* wait for Remote receiver status OK */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 01301bee420c..7efb898e9f96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3542,6 +3542,13 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		}
 	}
 
+	if (params->xdp_prog) {
+		if (features & NETIF_F_LRO) {
+			netdev_warn(netdev, "LRO is incompatible with XDP\n");
+			features &= ~NETIF_F_LRO;
+		}
+	}
+
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
 		features &= ~NETIF_F_RXHASH;
 		if (netdev->features & NETIF_F_RXHASH)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index a5b9f65db23c..897c7f852123 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -846,7 +846,8 @@ struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
 				   u32 num_of_dests,
-				   bool ignore_flow_level)
+				   bool ignore_flow_level,
+				   u32 flow_source)
 {
 	struct mlx5dr_cmd_flow_destination_hw_info *hw_dests;
 	struct mlx5dr_action **ref_actions;
@@ -914,7 +915,8 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				      reformat_req,
 				      &action->dest_tbl->fw_tbl.id,
 				      &action->dest_tbl->fw_tbl.group_id,
-				      ignore_flow_level);
+				      ignore_flow_level,
+				      flow_source);
 	if (ret)
 		goto free_action;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 0d6f86eb248b..c74083de1801 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -104,7 +104,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    bool reformat_req,
 			    u32 *tbl_id,
 			    u32 *group_id,
-			    bool ignore_flow_level)
+			    bool ignore_flow_level,
+			    u32 flow_source)
 {
 	struct mlx5dr_cmd_create_flow_table_attr ft_attr = {};
 	struct mlx5dr_cmd_fte_info fte_info = {};
@@ -139,6 +140,7 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 	fte_info.val = val;
 	fte_info.dest_arr = dest;
 	fte_info.ignore_flow_level = ignore_flow_level;
+	fte_info.flow_context.flow_source = flow_source;
 
 	ret = mlx5dr_cmd_set_fte(dmn->mdev, 0, 0, &ft_info, *group_id, &fte_info);
 	if (ret) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 3d4e035698dd..bc206836af6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1394,7 +1394,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    bool reformat_req,
 			    u32 *tbl_id,
 			    u32 *group_id,
-			    bool ignore_flow_level);
+			    bool ignore_flow_level,
+			    u32 flow_source);
 void mlx5dr_fw_destroy_md_tbl(struct mlx5dr_domain *dmn, u32 tbl_id,
 			      u32 group_id);
 #endif  /* _DR_TYPES_H_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 7e58f4e594b7..ae4597118f8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -492,11 +492,13 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	} else if (num_term_actions > 1) {
 		bool ignore_flow_level =
 			!!(fte->action.flags & FLOW_ACT_IGNORE_FLOW_LEVEL);
+		u32 flow_source = fte->flow_context.flow_source;
 
 		tmp_action = mlx5dr_action_create_mult_dest_tbl(domain,
 								term_actions,
 								num_term_actions,
-								ignore_flow_level);
+								ignore_flow_level,
+								flow_source);
 		if (!tmp_action) {
 			err = -EOPNOTSUPP;
 			goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 5ef199543479..7806e5c05b67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -96,7 +96,8 @@ struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
 				   u32 num_of_dests,
-				   bool ignore_flow_level);
+				   bool ignore_flow_level,
+				   u32 flow_source);
 
 struct mlx5dr_action *mlx5dr_action_create_drop(void);
 
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 4eb9ea280474..40d14d80f6f1 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3612,7 +3612,8 @@ static void ql_reset_work(struct work_struct *work)
 		qdev->mem_map_registers;
 	unsigned long hw_flags;
 
-	if (test_bit((QL_RESET_PER_SCSI | QL_RESET_START), &qdev->flags)) {
+	if (test_bit(QL_RESET_PER_SCSI, &qdev->flags) ||
+	    test_bit(QL_RESET_START, &qdev->flags)) {
 		clear_bit(QL_LINK_MASTER, &qdev->flags);
 
 		/*
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index fcf17d8a0494..644bb54f5f02 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -181,7 +181,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	/* Enable pci device */
-	ret = pci_enable_device(pdev);
+	ret = pcim_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n",
 			__func__);
@@ -241,8 +241,6 @@ static void stmmac_pci_remove(struct pci_dev *pdev)
 		pcim_iounmap_regions(pdev, BIT(i));
 		break;
 	}
-
-	pci_disable_device(pdev);
 }
 
 static int __maybe_unused stmmac_pci_suspend(struct device *dev)
diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index a2fcdb1abdb9..a734e5576729 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1370,9 +1370,10 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 	struct gsi_event *event_done;
 	struct gsi_event *event;
 	struct gsi_trans *trans;
+	u32 trans_count = 0;
 	u32 byte_count = 0;
-	u32 old_index;
 	u32 event_avail;
+	u32 old_index;
 
 	trans_info = &channel->trans_info;
 
@@ -1393,6 +1394,7 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 	do {
 		trans->len = __le16_to_cpu(event->len);
 		byte_count += trans->len;
+		trans_count++;
 
 		/* Move on to the next event and transaction */
 		if (--event_avail)
@@ -1404,7 +1406,7 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 
 	/* We record RX bytes when they are received */
 	channel->byte_count += byte_count;
-	channel->trans_count++;
+	channel->trans_count += trans_count;
 }
 
 /* Initialize a ring, including allocating DMA memory for its entries */
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 3619520340b7..e172743948ed 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -988,6 +988,7 @@ static int pppoe_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->encap.proto = htons(ETH_P_PPP_SES);
 	path->encap.id = be16_to_cpu(po->num);
 	memcpy(path->encap.h_dest, po->pppoe_pa.remote, ETH_ALEN);
+	memcpy(ctx->daddr, po->pppoe_pa.remote, ETH_ALEN);
 	path->dev = ctx->dev;
 	ctx->dev = dev;
 
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 5b0215b7c176..bc3192cf48e3 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -589,6 +589,7 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
 					dev_kfree_skb_any(rbi->skb);
+					rbi->skb = NULL;
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
@@ -613,6 +614,7 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
 					put_page(rbi->page);
+					rbi->page = NULL;
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
@@ -1666,6 +1668,10 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 	u32 i, ring_idx;
 	struct Vmxnet3_RxDesc *rxd;
 
+	/* ring has already been cleaned up */
+	if (!rq->rx_ring[0].base)
+		return;
+
 	for (ring_idx = 0; ring_idx < 2; ring_idx++) {
 		for (i = 0; i < rq->rx_ring[ring_idx].size; i++) {
 #ifdef __BIG_ENDIAN_BITFIELD
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
index 7d7d43a5422f..93d0cc1827d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
@@ -118,109 +118,6 @@ static void mt7921_dma_prefetch(struct mt7921_dev *dev)
 	mt76_wr(dev, MT_WFDMA0_TX_RING17_EXT_CTRL, PREFETCH(0x380, 0x4));
 }
 
-static u32 __mt7921_reg_addr(struct mt7921_dev *dev, u32 addr)
-{
-	static const struct {
-		u32 phys;
-		u32 mapped;
-		u32 size;
-	} fixed_map[] = {
-		{ 0x00400000, 0x80000, 0x10000}, /* WF_MCU_SYSRAM */
-		{ 0x00410000, 0x90000, 0x10000}, /* WF_MCU_SYSRAM (configure register) */
-		{ 0x40000000, 0x70000, 0x10000}, /* WF_UMAC_SYSRAM */
-		{ 0x54000000, 0x02000, 0x1000 }, /* WFDMA PCIE0 MCU DMA0 */
-		{ 0x55000000, 0x03000, 0x1000 }, /* WFDMA PCIE0 MCU DMA1 */
-		{ 0x58000000, 0x06000, 0x1000 }, /* WFDMA PCIE1 MCU DMA0 (MEM_DMA) */
-		{ 0x59000000, 0x07000, 0x1000 }, /* WFDMA PCIE1 MCU DMA1 */
-		{ 0x7c000000, 0xf0000, 0x10000 }, /* CONN_INFRA */
-		{ 0x7c020000, 0xd0000, 0x10000 }, /* CONN_INFRA, WFDMA */
-		{ 0x7c060000, 0xe0000, 0x10000}, /* CONN_INFRA, conn_host_csr_top */
-		{ 0x80020000, 0xb0000, 0x10000 }, /* WF_TOP_MISC_OFF */
-		{ 0x81020000, 0xc0000, 0x10000 }, /* WF_TOP_MISC_ON */
-		{ 0x820c0000, 0x08000, 0x4000 }, /* WF_UMAC_TOP (PLE) */
-		{ 0x820c8000, 0x0c000, 0x2000 }, /* WF_UMAC_TOP (PSE) */
-		{ 0x820cc000, 0x0e000, 0x2000 }, /* WF_UMAC_TOP (PP) */
-		{ 0x820ce000, 0x21c00, 0x0200 }, /* WF_LMAC_TOP (WF_SEC) */
-		{ 0x820cf000, 0x22000, 0x1000 }, /* WF_LMAC_TOP (WF_PF) */
-		{ 0x820d0000, 0x30000, 0x10000 }, /* WF_LMAC_TOP (WF_WTBLON) */
-		{ 0x820e0000, 0x20000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
-		{ 0x820e1000, 0x20400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_TRB) */
-		{ 0x820e2000, 0x20800, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_AGG) */
-		{ 0x820e3000, 0x20c00, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_ARB) */
-		{ 0x820e4000, 0x21000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_TMAC) */
-		{ 0x820e5000, 0x21400, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_RMAC) */
-		{ 0x820e7000, 0x21e00, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_DMA) */
-		{ 0x820e9000, 0x23400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_WTBLOFF) */
-		{ 0x820ea000, 0x24000, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_ETBF) */
-		{ 0x820eb000, 0x24200, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_LPON) */
-		{ 0x820ec000, 0x24600, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_INT) */
-		{ 0x820ed000, 0x24800, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_MIB) */
-		{ 0x820f0000, 0xa0000, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_CFG) */
-		{ 0x820f1000, 0xa0600, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_TRB) */
-		{ 0x820f2000, 0xa0800, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_AGG) */
-		{ 0x820f3000, 0xa0c00, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_ARB) */
-		{ 0x820f4000, 0xa1000, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_TMAC) */
-		{ 0x820f5000, 0xa1400, 0x0800 }, /* WF_LMAC_TOP BN1 (WF_RMAC) */
-		{ 0x820f7000, 0xa1e00, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_DMA) */
-		{ 0x820f9000, 0xa3400, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_WTBLOFF) */
-		{ 0x820fa000, 0xa4000, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_ETBF) */
-		{ 0x820fb000, 0xa4200, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_LPON) */
-		{ 0x820fc000, 0xa4600, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_INT) */
-		{ 0x820fd000, 0xa4800, 0x0800 }, /* WF_LMAC_TOP BN1 (WF_MIB) */
-	};
-	int i;
-
-	if (addr < 0x100000)
-		return addr;
-
-	for (i = 0; i < ARRAY_SIZE(fixed_map); i++) {
-		u32 ofs;
-
-		if (addr < fixed_map[i].phys)
-			continue;
-
-		ofs = addr - fixed_map[i].phys;
-		if (ofs > fixed_map[i].size)
-			continue;
-
-		return fixed_map[i].mapped + ofs;
-	}
-
-	if ((addr >= 0x18000000 && addr < 0x18c00000) ||
-	    (addr >= 0x70000000 && addr < 0x78000000) ||
-	    (addr >= 0x7c000000 && addr < 0x7c400000))
-		return mt7921_reg_map_l1(dev, addr);
-
-	dev_err(dev->mt76.dev, "Access currently unsupported address %08x\n",
-		addr);
-
-	return 0;
-}
-
-static u32 mt7921_rr(struct mt76_dev *mdev, u32 offset)
-{
-	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
-	u32 addr = __mt7921_reg_addr(dev, offset);
-
-	return dev->bus_ops->rr(mdev, addr);
-}
-
-static void mt7921_wr(struct mt76_dev *mdev, u32 offset, u32 val)
-{
-	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
-	u32 addr = __mt7921_reg_addr(dev, offset);
-
-	dev->bus_ops->wr(mdev, addr, val);
-}
-
-static u32 mt7921_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
-{
-	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
-	u32 addr = __mt7921_reg_addr(dev, offset);
-
-	return dev->bus_ops->rmw(mdev, addr, mask, val);
-}
-
 static int mt7921_dma_disable(struct mt7921_dev *dev, bool force)
 {
 	if (force) {
@@ -380,20 +277,8 @@ int mt7921_wpdma_reinit_cond(struct mt7921_dev *dev)
 
 int mt7921_dma_init(struct mt7921_dev *dev)
 {
-	struct mt76_bus_ops *bus_ops;
 	int ret;
 
-	dev->bus_ops = dev->mt76.bus;
-	bus_ops = devm_kmemdup(dev->mt76.dev, dev->bus_ops, sizeof(*bus_ops),
-			       GFP_KERNEL);
-	if (!bus_ops)
-		return -ENOMEM;
-
-	bus_ops->rr = mt7921_rr;
-	bus_ops->wr = mt7921_wr;
-	bus_ops->rmw = mt7921_rmw;
-	dev->mt76.bus = bus_ops;
-
 	mt76_dma_attach(&dev->mt76);
 
 	ret = mt7921_dma_disable(dev, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 506a1909ce6d..4119f8efd896 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1306,8 +1306,6 @@ int mt7921_mcu_sta_update(struct mt7921_dev *dev, struct ieee80211_sta *sta,
 
 int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 {
-	struct mt76_phy *mphy = &dev->mt76.phy;
-	struct mt76_connac_pm *pm = &dev->pm;
 	int i, err = 0;
 
 	for (i = 0; i < MT7921_DRV_OWN_RETRY_COUNT; i++) {
@@ -1320,16 +1318,8 @@ int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 	if (i == MT7921_DRV_OWN_RETRY_COUNT) {
 		dev_err(dev->mt76.dev, "driver own failed\n");
 		err = -EIO;
-		goto out;
 	}
 
-	mt7921_wpdma_reinit_cond(dev);
-	clear_bit(MT76_STATE_PM, &mphy->state);
-
-	pm->stats.last_wake_event = jiffies;
-	pm->stats.doze_time += pm->stats.last_wake_event -
-			       pm->stats.last_doze_event;
-out:
 	return err;
 }
 
@@ -1345,6 +1335,16 @@ int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 		goto out;
 
 	err = __mt7921_mcu_drv_pmctrl(dev);
+        if (err < 0)
+            goto out;
+
+	mt7921_wpdma_reinit_cond(dev);
+	clear_bit(MT76_STATE_PM, &mphy->state);
+
+	pm->stats.last_wake_event = jiffies;
+	pm->stats.doze_time += pm->stats.last_wake_event -
+			       pm->stats.last_doze_event;
+
 out:
 	mutex_unlock(&pm->mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index c3905bcab360..7d9b23a00238 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -88,6 +88,110 @@ static void mt7921_irq_tasklet(unsigned long data)
 		napi_schedule(&dev->mt76.napi[MT_RXQ_MAIN]);
 }
 
+static u32 __mt7921_reg_addr(struct mt7921_dev *dev, u32 addr)
+{
+	static const struct {
+		u32 phys;
+		u32 mapped;
+		u32 size;
+	} fixed_map[] = {
+		{ 0x00400000, 0x80000, 0x10000}, /* WF_MCU_SYSRAM */
+		{ 0x00410000, 0x90000, 0x10000}, /* WF_MCU_SYSRAM (configure register) */
+		{ 0x40000000, 0x70000, 0x10000}, /* WF_UMAC_SYSRAM */
+		{ 0x54000000, 0x02000, 0x1000 }, /* WFDMA PCIE0 MCU DMA0 */
+		{ 0x55000000, 0x03000, 0x1000 }, /* WFDMA PCIE0 MCU DMA1 */
+		{ 0x58000000, 0x06000, 0x1000 }, /* WFDMA PCIE1 MCU DMA0 (MEM_DMA) */
+		{ 0x59000000, 0x07000, 0x1000 }, /* WFDMA PCIE1 MCU DMA1 */
+		{ 0x7c000000, 0xf0000, 0x10000 }, /* CONN_INFRA */
+		{ 0x7c020000, 0xd0000, 0x10000 }, /* CONN_INFRA, WFDMA */
+		{ 0x7c060000, 0xe0000, 0x10000}, /* CONN_INFRA, conn_host_csr_top */
+		{ 0x80020000, 0xb0000, 0x10000 }, /* WF_TOP_MISC_OFF */
+		{ 0x81020000, 0xc0000, 0x10000 }, /* WF_TOP_MISC_ON */
+		{ 0x820c0000, 0x08000, 0x4000 }, /* WF_UMAC_TOP (PLE) */
+		{ 0x820c8000, 0x0c000, 0x2000 }, /* WF_UMAC_TOP (PSE) */
+		{ 0x820cc000, 0x0e000, 0x2000 }, /* WF_UMAC_TOP (PP) */
+		{ 0x820ce000, 0x21c00, 0x0200 }, /* WF_LMAC_TOP (WF_SEC) */
+		{ 0x820cf000, 0x22000, 0x1000 }, /* WF_LMAC_TOP (WF_PF) */
+		{ 0x820d0000, 0x30000, 0x10000 }, /* WF_LMAC_TOP (WF_WTBLON) */
+		{ 0x820e0000, 0x20000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
+		{ 0x820e1000, 0x20400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_TRB) */
+		{ 0x820e2000, 0x20800, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_AGG) */
+		{ 0x820e3000, 0x20c00, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_ARB) */
+		{ 0x820e4000, 0x21000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_TMAC) */
+		{ 0x820e5000, 0x21400, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_RMAC) */
+		{ 0x820e7000, 0x21e00, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_DMA) */
+		{ 0x820e9000, 0x23400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_WTBLOFF) */
+		{ 0x820ea000, 0x24000, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_ETBF) */
+		{ 0x820eb000, 0x24200, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_LPON) */
+		{ 0x820ec000, 0x24600, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_INT) */
+		{ 0x820ed000, 0x24800, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_MIB) */
+		{ 0x820f0000, 0xa0000, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_CFG) */
+		{ 0x820f1000, 0xa0600, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_TRB) */
+		{ 0x820f2000, 0xa0800, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_AGG) */
+		{ 0x820f3000, 0xa0c00, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_ARB) */
+		{ 0x820f4000, 0xa1000, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_TMAC) */
+		{ 0x820f5000, 0xa1400, 0x0800 }, /* WF_LMAC_TOP BN1 (WF_RMAC) */
+		{ 0x820f7000, 0xa1e00, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_DMA) */
+		{ 0x820f9000, 0xa3400, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_WTBLOFF) */
+		{ 0x820fa000, 0xa4000, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_ETBF) */
+		{ 0x820fb000, 0xa4200, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_LPON) */
+		{ 0x820fc000, 0xa4600, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_INT) */
+		{ 0x820fd000, 0xa4800, 0x0800 }, /* WF_LMAC_TOP BN1 (WF_MIB) */
+	};
+	int i;
+
+	if (addr < 0x100000)
+		return addr;
+
+	for (i = 0; i < ARRAY_SIZE(fixed_map); i++) {
+		u32 ofs;
+
+		if (addr < fixed_map[i].phys)
+			continue;
+
+		ofs = addr - fixed_map[i].phys;
+		if (ofs > fixed_map[i].size)
+			continue;
+
+		return fixed_map[i].mapped + ofs;
+	}
+
+	if ((addr >= 0x18000000 && addr < 0x18c00000) ||
+	    (addr >= 0x70000000 && addr < 0x78000000) ||
+	    (addr >= 0x7c000000 && addr < 0x7c400000))
+		return mt7921_reg_map_l1(dev, addr);
+
+	dev_err(dev->mt76.dev, "Access currently unsupported address %08x\n",
+		addr);
+
+	return 0;
+}
+
+static u32 mt7921_rr(struct mt76_dev *mdev, u32 offset)
+{
+	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+	u32 addr = __mt7921_reg_addr(dev, offset);
+
+	return dev->bus_ops->rr(mdev, addr);
+}
+
+static void mt7921_wr(struct mt76_dev *mdev, u32 offset, u32 val)
+{
+	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+	u32 addr = __mt7921_reg_addr(dev, offset);
+
+	dev->bus_ops->wr(mdev, addr, val);
+}
+
+static u32 mt7921_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
+{
+	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+	u32 addr = __mt7921_reg_addr(dev, offset);
+
+	return dev->bus_ops->rmw(mdev, addr, mask, val);
+}
+
+
 static int mt7921_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -110,6 +214,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 		.sta_remove = mt7921_mac_sta_remove,
 		.update_survey = mt7921_update_channel,
 	};
+	struct mt76_bus_ops *bus_ops;
 	struct mt7921_dev *dev;
 	struct mt76_dev *mdev;
 	int ret;
@@ -145,6 +250,22 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 
 	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
 	tasklet_init(&dev->irq_tasklet, mt7921_irq_tasklet, (unsigned long)dev);
+
+	dev->bus_ops = dev->mt76.bus;
+	bus_ops = devm_kmemdup(dev->mt76.dev, dev->bus_ops, sizeof(*bus_ops),
+			       GFP_KERNEL);
+	if (!bus_ops)
+		return -ENOMEM;
+
+	bus_ops->rr = mt7921_rr;
+	bus_ops->wr = mt7921_wr;
+	bus_ops->rmw = mt7921_rmw;
+	dev->mt76.bus = bus_ops;
+
+	ret = __mt7921_mcu_drv_pmctrl(dev);
+	if (ret)
+		return ret;
+
 	mdev->rev = (mt7921_l1_rr(dev, MT_HW_CHIPID) << 16) |
 		    (mt7921_l1_rr(dev, MT_HW_REV) & 0xff);
 	dev_err(mdev->dev, "ASIC revision: %04x\n", mdev->rev);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f2bb57615762..87877397d1ad 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4358,6 +4358,7 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 	if (ctrl->queue_count > 1) {
 		nvme_queue_scan(ctrl);
 		nvme_start_queues(ctrl);
+		nvme_mpath_update(ctrl);
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_start_ctrl);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index e9301b51db76..064acad505d3 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -574,8 +574,17 @@ static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 	ns->ana_grpid = le32_to_cpu(desc->grpid);
 	ns->ana_state = desc->state;
 	clear_bit(NVME_NS_ANA_PENDING, &ns->flags);
-
-	if (nvme_state_is_live(ns->ana_state))
+	/*
+	 * nvme_mpath_set_live() will trigger I/O to the multipath path device
+	 * and in turn to this path device.  However we cannot accept this I/O
+	 * if the controller is not live.  This may deadlock if called from
+	 * nvme_mpath_init_identify() and the ctrl will never complete
+	 * initialization, preventing I/O from completing.  For this case we
+	 * will reprocess the ANA log page in nvme_mpath_update() once the
+	 * controller is ready.
+	 */
+	if (nvme_state_is_live(ns->ana_state) &&
+	    ns->ctrl->state == NVME_CTRL_LIVE)
 		nvme_mpath_set_live(ns);
 }
 
@@ -662,6 +671,18 @@ static void nvme_ana_work(struct work_struct *work)
 	nvme_read_ana_log(ctrl);
 }
 
+void nvme_mpath_update(struct nvme_ctrl *ctrl)
+{
+	u32 nr_change_groups = 0;
+
+	if (!ctrl->ana_log_buf)
+		return;
+
+	mutex_lock(&ctrl->ana_lock);
+	nvme_parse_ana_log(ctrl, &nr_change_groups, nvme_update_ana_state);
+	mutex_unlock(&ctrl->ana_lock);
+}
+
 static void nvme_anatt_timeout(struct timer_list *t)
 {
 	struct nvme_ctrl *ctrl = from_timer(ctrl, t, anatt_timer);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index f1e5c7564cae..72bcd7e5716e 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -776,6 +776,7 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 int nvme_mpath_init_identify(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id);
 void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl);
+void nvme_mpath_update(struct nvme_ctrl *ctrl);
 void nvme_mpath_uninit(struct nvme_ctrl *ctrl);
 void nvme_mpath_stop(struct nvme_ctrl *ctrl);
 bool nvme_mpath_clear_current_path(struct nvme_ns *ns);
@@ -850,6 +851,9 @@ static inline int nvme_mpath_init_identify(struct nvme_ctrl *ctrl,
 "Please enable CONFIG_NVME_MULTIPATH for full support of multi-port devices.\n");
 	return 0;
 }
+static inline void nvme_mpath_update(struct nvme_ctrl *ctrl)
+{
+}
 static inline void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 {
 }
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d7695bdbde8d..e6f55cf6e494 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3379,7 +3379,10 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_128_BYTES_SQES |
 				NVME_QUIRK_SHARED_TAGS |
 				NVME_QUIRK_SKIP_CID_GEN },
-
+	{ PCI_DEVICE(0x144d, 0xa808),   /* Samsung X5 */
+		.driver_data =  NVME_QUIRK_DELAY_BEFORE_CHK_RDY|
+				NVME_QUIRK_NO_DEEPEST_PS |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index aa6d84d8848e..52bb262d267a 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -978,7 +978,7 @@ void nvmet_execute_async_event(struct nvmet_req *req)
 	ctrl->async_event_cmds[ctrl->nr_async_event_cmds++] = req;
 	mutex_unlock(&ctrl->lock);
 
-	schedule_work(&ctrl->async_event_work);
+	queue_work(nvmet_wq, &ctrl->async_event_work);
 }
 
 void nvmet_execute_keep_alive(struct nvmet_req *req)
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 496d775c6770..cea30e4f5053 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1554,7 +1554,7 @@ static void nvmet_port_release(struct config_item *item)
 	struct nvmet_port *port = to_nvmet_port(item);
 
 	/* Let inflight controllers teardown complete */
-	flush_scheduled_work();
+	flush_workqueue(nvmet_wq);
 	list_del(&port->global_entry);
 
 	kfree(port->ana_state);
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index b8425fa34300..a8dafe8670f2 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -20,6 +20,9 @@ struct workqueue_struct *zbd_wq;
 static const struct nvmet_fabrics_ops *nvmet_transports[NVMF_TRTYPE_MAX];
 static DEFINE_IDA(cntlid_ida);
 
+struct workqueue_struct *nvmet_wq;
+EXPORT_SYMBOL_GPL(nvmet_wq);
+
 /*
  * This read/write semaphore is used to synchronize access to configuration
  * information on a target system that will result in discovery log page
@@ -205,7 +208,7 @@ void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
 	list_add_tail(&aen->entry, &ctrl->async_events);
 	mutex_unlock(&ctrl->lock);
 
-	schedule_work(&ctrl->async_event_work);
+	queue_work(nvmet_wq, &ctrl->async_event_work);
 }
 
 static void nvmet_add_to_changed_ns_log(struct nvmet_ctrl *ctrl, __le32 nsid)
@@ -385,7 +388,7 @@ static void nvmet_keep_alive_timer(struct work_struct *work)
 	if (reset_tbkas) {
 		pr_debug("ctrl %d reschedule traffic based keep-alive timer\n",
 			ctrl->cntlid);
-		schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
+		queue_delayed_work(nvmet_wq, &ctrl->ka_work, ctrl->kato * HZ);
 		return;
 	}
 
@@ -403,7 +406,7 @@ void nvmet_start_keep_alive_timer(struct nvmet_ctrl *ctrl)
 	pr_debug("ctrl %d start keep-alive timer for %d secs\n",
 		ctrl->cntlid, ctrl->kato);
 
-	schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
+	queue_delayed_work(nvmet_wq, &ctrl->ka_work, ctrl->kato * HZ);
 }
 
 void nvmet_stop_keep_alive_timer(struct nvmet_ctrl *ctrl)
@@ -1477,7 +1480,7 @@ void nvmet_ctrl_fatal_error(struct nvmet_ctrl *ctrl)
 	mutex_lock(&ctrl->lock);
 	if (!(ctrl->csts & NVME_CSTS_CFS)) {
 		ctrl->csts |= NVME_CSTS_CFS;
-		schedule_work(&ctrl->fatal_err_work);
+		queue_work(nvmet_wq, &ctrl->fatal_err_work);
 	}
 	mutex_unlock(&ctrl->lock);
 }
@@ -1617,9 +1620,15 @@ static int __init nvmet_init(void)
 		goto out_free_zbd_work_queue;
 	}
 
+	nvmet_wq = alloc_workqueue("nvmet-wq", WQ_MEM_RECLAIM, 0);
+	if (!nvmet_wq) {
+		error = -ENOMEM;
+		goto out_free_buffered_work_queue;
+	}
+
 	error = nvmet_init_discovery();
 	if (error)
-		goto out_free_work_queue;
+		goto out_free_nvmet_work_queue;
 
 	error = nvmet_init_configfs();
 	if (error)
@@ -1628,7 +1637,9 @@ static int __init nvmet_init(void)
 
 out_exit_discovery:
 	nvmet_exit_discovery();
-out_free_work_queue:
+out_free_nvmet_work_queue:
+	destroy_workqueue(nvmet_wq);
+out_free_buffered_work_queue:
 	destroy_workqueue(buffered_io_wq);
 out_free_zbd_work_queue:
 	destroy_workqueue(zbd_wq);
@@ -1640,6 +1651,7 @@ static void __exit nvmet_exit(void)
 	nvmet_exit_configfs();
 	nvmet_exit_discovery();
 	ida_destroy(&cntlid_ida);
+	destroy_workqueue(nvmet_wq);
 	destroy_workqueue(buffered_io_wq);
 	destroy_workqueue(zbd_wq);
 
diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 22b5108168a6..c43bc5e1c7a2 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1491,7 +1491,7 @@ __nvmet_fc_free_assocs(struct nvmet_fc_tgtport *tgtport)
 	list_for_each_entry_rcu(assoc, &tgtport->assoc_list, a_list) {
 		if (!nvmet_fc_tgt_a_get(assoc))
 			continue;
-		if (!schedule_work(&assoc->del_work))
+		if (!queue_work(nvmet_wq, &assoc->del_work))
 			/* already deleting - release local reference */
 			nvmet_fc_tgt_a_put(assoc);
 	}
@@ -1546,7 +1546,7 @@ nvmet_fc_invalidate_host(struct nvmet_fc_target_port *target_port,
 			continue;
 		assoc->hostport->invalid = 1;
 		noassoc = false;
-		if (!schedule_work(&assoc->del_work))
+		if (!queue_work(nvmet_wq, &assoc->del_work))
 			/* already deleting - release local reference */
 			nvmet_fc_tgt_a_put(assoc);
 	}
@@ -1592,7 +1592,7 @@ nvmet_fc_delete_ctrl(struct nvmet_ctrl *ctrl)
 		nvmet_fc_tgtport_put(tgtport);
 
 		if (found_ctrl) {
-			if (!schedule_work(&assoc->del_work))
+			if (!queue_work(nvmet_wq, &assoc->del_work))
 				/* already deleting - release local reference */
 				nvmet_fc_tgt_a_put(assoc);
 			return;
@@ -2060,7 +2060,7 @@ nvmet_fc_rcv_ls_req(struct nvmet_fc_target_port *target_port,
 	iod->rqstdatalen = lsreqbuf_len;
 	iod->hosthandle = hosthandle;
 
-	schedule_work(&iod->work);
+	queue_work(nvmet_wq, &iod->work);
 
 	return 0;
 }
diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 54606f1872b4..5c16372f3b53 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -360,7 +360,7 @@ fcloop_h2t_ls_req(struct nvme_fc_local_port *localport,
 		spin_lock(&rport->lock);
 		list_add_tail(&rport->ls_list, &tls_req->ls_list);
 		spin_unlock(&rport->lock);
-		schedule_work(&rport->ls_work);
+		queue_work(nvmet_wq, &rport->ls_work);
 		return ret;
 	}
 
@@ -393,7 +393,7 @@ fcloop_h2t_xmt_ls_rsp(struct nvmet_fc_target_port *targetport,
 		spin_lock(&rport->lock);
 		list_add_tail(&rport->ls_list, &tls_req->ls_list);
 		spin_unlock(&rport->lock);
-		schedule_work(&rport->ls_work);
+		queue_work(nvmet_wq, &rport->ls_work);
 	}
 
 	return 0;
@@ -448,7 +448,7 @@ fcloop_t2h_ls_req(struct nvmet_fc_target_port *targetport, void *hosthandle,
 		spin_lock(&tport->lock);
 		list_add_tail(&tport->ls_list, &tls_req->ls_list);
 		spin_unlock(&tport->lock);
-		schedule_work(&tport->ls_work);
+		queue_work(nvmet_wq, &tport->ls_work);
 		return ret;
 	}
 
@@ -480,7 +480,7 @@ fcloop_t2h_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 		spin_lock(&tport->lock);
 		list_add_tail(&tport->ls_list, &tls_req->ls_list);
 		spin_unlock(&tport->lock);
-		schedule_work(&tport->ls_work);
+		queue_work(nvmet_wq, &tport->ls_work);
 	}
 
 	return 0;
@@ -520,7 +520,7 @@ fcloop_tgt_discovery_evt(struct nvmet_fc_target_port *tgtport)
 	tgt_rscn->tport = tgtport->private;
 	INIT_WORK(&tgt_rscn->work, fcloop_tgt_rscn_work);
 
-	schedule_work(&tgt_rscn->work);
+	queue_work(nvmet_wq, &tgt_rscn->work);
 }
 
 static void
@@ -739,7 +739,7 @@ fcloop_fcp_req(struct nvme_fc_local_port *localport,
 	INIT_WORK(&tfcp_req->tio_done_work, fcloop_tgt_fcprqst_done_work);
 	kref_init(&tfcp_req->ref);
 
-	schedule_work(&tfcp_req->fcp_rcv_work);
+	queue_work(nvmet_wq, &tfcp_req->fcp_rcv_work);
 
 	return 0;
 }
@@ -921,7 +921,7 @@ fcloop_fcp_req_release(struct nvmet_fc_target_port *tgtport,
 {
 	struct fcloop_fcpreq *tfcp_req = tgt_fcp_req_to_fcpreq(tgt_fcpreq);
 
-	schedule_work(&tfcp_req->tio_done_work);
+	queue_work(nvmet_wq, &tfcp_req->tio_done_work);
 }
 
 static void
@@ -976,7 +976,7 @@ fcloop_fcp_abort(struct nvme_fc_local_port *localport,
 
 	if (abortio)
 		/* leave the reference while the work item is scheduled */
-		WARN_ON(!schedule_work(&tfcp_req->abort_rcv_work));
+		WARN_ON(!queue_work(nvmet_wq, &tfcp_req->abort_rcv_work));
 	else  {
 		/*
 		 * as the io has already had the done callback made,
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index df7e033dd273..228871d48106 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -292,7 +292,7 @@ static void nvmet_file_execute_flush(struct nvmet_req *req)
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_flush_work);
-	schedule_work(&req->f.work);
+	queue_work(nvmet_wq, &req->f.work);
 }
 
 static void nvmet_file_execute_discard(struct nvmet_req *req)
@@ -352,7 +352,7 @@ static void nvmet_file_execute_dsm(struct nvmet_req *req)
 	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_dsm_work);
-	schedule_work(&req->f.work);
+	queue_work(nvmet_wq, &req->f.work);
 }
 
 static void nvmet_file_write_zeroes_work(struct work_struct *w)
@@ -382,7 +382,7 @@ static void nvmet_file_execute_write_zeroes(struct nvmet_req *req)
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_write_zeroes_work);
-	schedule_work(&req->f.work);
+	queue_work(nvmet_wq, &req->f.work);
 }
 
 u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 0285ccc7541f..2553f487c9f2 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -166,7 +166,7 @@ static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		iod->req.transfer_len = blk_rq_payload_bytes(req);
 	}
 
-	schedule_work(&iod->work);
+	queue_work(nvmet_wq, &iod->work);
 	return BLK_STS_OK;
 }
 
@@ -187,7 +187,7 @@ static void nvme_loop_submit_async_event(struct nvme_ctrl *arg)
 		return;
 	}
 
-	schedule_work(&iod->work);
+	queue_work(nvmet_wq, &iod->work);
 }
 
 static int nvme_loop_init_iod(struct nvme_loop_ctrl *ctrl,
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 7143c7fa7464..dbeb0b8c1194 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -365,6 +365,7 @@ struct nvmet_req {
 
 extern struct workqueue_struct *buffered_io_wq;
 extern struct workqueue_struct *zbd_wq;
+extern struct workqueue_struct *nvmet_wq;
 
 static inline void nvmet_set_result(struct nvmet_req *req, u32 result)
 {
diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index f0efb3537989..6220e1dd961a 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -281,7 +281,7 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
 	if (req->p.use_workqueue || effects) {
 		INIT_WORK(&req->p.work, nvmet_passthru_execute_cmd_work);
 		req->p.rq = rq;
-		schedule_work(&req->p.work);
+		queue_work(nvmet_wq, &req->p.work);
 	} else {
 		rq->end_io_data = req;
 		blk_execute_rq_nowait(ns ? ns->disk : NULL, rq, 0,
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index f1eedbf493d5..18e082091c82 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1583,7 +1583,7 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 
 	if (queue->host_qid == 0) {
 		/* Let inflight controller teardown complete */
-		flush_scheduled_work();
+		flush_workqueue(nvmet_wq);
 	}
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
@@ -1668,7 +1668,7 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 
 	if (disconnect) {
 		rdma_disconnect(queue->cm_id);
-		schedule_work(&queue->release_work);
+		queue_work(nvmet_wq, &queue->release_work);
 	}
 }
 
@@ -1698,7 +1698,7 @@ static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
 	mutex_unlock(&nvmet_rdma_queue_mutex);
 
 	pr_err("failed to connect queue %d\n", queue->idx);
-	schedule_work(&queue->release_work);
+	queue_work(nvmet_wq, &queue->release_work);
 }
 
 /**
@@ -1772,7 +1772,7 @@ static int nvmet_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		if (!queue) {
 			struct nvmet_rdma_port *port = cm_id->context;
 
-			schedule_delayed_work(&port->repair_work, 0);
+			queue_delayed_work(nvmet_wq, &port->repair_work, 0);
 			break;
 		}
 		fallthrough;
@@ -1902,7 +1902,7 @@ static void nvmet_rdma_repair_port_work(struct work_struct *w)
 	nvmet_rdma_disable_port(port);
 	ret = nvmet_rdma_enable_port(port);
 	if (ret)
-		schedule_delayed_work(&port->repair_work, 5 * HZ);
+		queue_delayed_work(nvmet_wq, &port->repair_work, 5 * HZ);
 }
 
 static int nvmet_rdma_add_port(struct nvmet_port *nport)
@@ -2046,7 +2046,7 @@ static void nvmet_rdma_remove_one(struct ib_device *ib_device, void *client_data
 	}
 	mutex_unlock(&nvmet_rdma_queue_mutex);
 
-	flush_scheduled_work();
+	flush_workqueue(nvmet_wq);
 }
 
 static struct ib_client nvmet_rdma_ib_client = {
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 2b8bab28417b..f592e5f7f5f3 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1251,7 +1251,7 @@ static void nvmet_tcp_schedule_release_queue(struct nvmet_tcp_queue *queue)
 	spin_lock(&queue->state_lock);
 	if (queue->state != NVMET_TCP_Q_DISCONNECTING) {
 		queue->state = NVMET_TCP_Q_DISCONNECTING;
-		schedule_work(&queue->release_work);
+		queue_work(nvmet_wq, &queue->release_work);
 	}
 	spin_unlock(&queue->state_lock);
 }
@@ -1662,7 +1662,7 @@ static void nvmet_tcp_listen_data_ready(struct sock *sk)
 		goto out;
 
 	if (sk->sk_state == TCP_LISTEN)
-		schedule_work(&port->accept_work);
+		queue_work(nvmet_wq, &port->accept_work);
 out:
 	read_unlock_bh(&sk->sk_callback_lock);
 }
@@ -1793,7 +1793,7 @@ static u16 nvmet_tcp_install_queue(struct nvmet_sq *sq)
 
 	if (sq->qid == 0) {
 		/* Let inflight controller teardown complete */
-		flush_scheduled_work();
+		flush_workqueue(nvmet_wq);
 	}
 
 	queue->nr_cmds = sq->size * 2;
@@ -1854,12 +1854,12 @@ static void __exit nvmet_tcp_exit(void)
 
 	nvmet_unregister_transport(&nvmet_tcp_ops);
 
-	flush_scheduled_work();
+	flush_workqueue(nvmet_wq);
 	mutex_lock(&nvmet_tcp_queue_mutex);
 	list_for_each_entry(queue, &nvmet_tcp_queue_list, queue_list)
 		kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	mutex_unlock(&nvmet_tcp_queue_mutex);
-	flush_scheduled_work();
+	flush_workqueue(nvmet_wq);
 
 	destroy_workqueue(nvmet_tcp_wq);
 }
diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index ff45052cf48d..7cc2c54daad0 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -272,7 +272,6 @@ struct advk_pcie {
 		u32 actions;
 	} wins[OB_WIN_COUNT];
 	u8 wins_count;
-	int irq;
 	struct irq_domain *rp_irq_domain;
 	struct irq_domain *irq_domain;
 	struct irq_chip irq_chip;
@@ -1572,26 +1571,21 @@ static void advk_pcie_handle_int(struct advk_pcie *pcie)
 	}
 }
 
-static void advk_pcie_irq_handler(struct irq_desc *desc)
+static irqreturn_t advk_pcie_irq_handler(int irq, void *arg)
 {
-	struct advk_pcie *pcie = irq_desc_get_handler_data(desc);
-	struct irq_chip *chip = irq_desc_get_chip(desc);
-	u32 val, mask, status;
+	struct advk_pcie *pcie = arg;
+	u32 status;
 
-	chained_irq_enter(chip, desc);
+	status = advk_readl(pcie, HOST_CTRL_INT_STATUS_REG);
+	if (!(status & PCIE_IRQ_CORE_INT))
+		return IRQ_NONE;
 
-	val = advk_readl(pcie, HOST_CTRL_INT_STATUS_REG);
-	mask = advk_readl(pcie, HOST_CTRL_INT_MASK_REG);
-	status = val & ((~mask) & PCIE_IRQ_ALL_MASK);
+	advk_pcie_handle_int(pcie);
 
-	if (status & PCIE_IRQ_CORE_INT) {
-		advk_pcie_handle_int(pcie);
+	/* Clear interrupt */
+	advk_writel(pcie, PCIE_IRQ_CORE_INT, HOST_CTRL_INT_STATUS_REG);
 
-		/* Clear interrupt */
-		advk_writel(pcie, PCIE_IRQ_CORE_INT, HOST_CTRL_INT_STATUS_REG);
-	}
-
-	chained_irq_exit(chip, desc);
+	return IRQ_HANDLED;
 }
 
 static int advk_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
@@ -1673,7 +1667,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	struct advk_pcie *pcie;
 	struct pci_host_bridge *bridge;
 	struct resource_entry *entry;
-	int ret;
+	int ret, irq;
 
 	bridge = devm_pci_alloc_host_bridge(dev, sizeof(struct advk_pcie));
 	if (!bridge)
@@ -1759,9 +1753,17 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	if (IS_ERR(pcie->base))
 		return PTR_ERR(pcie->base);
 
-	pcie->irq = platform_get_irq(pdev, 0);
-	if (pcie->irq < 0)
-		return pcie->irq;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_irq(dev, irq, advk_pcie_irq_handler,
+			       IRQF_SHARED | IRQF_NO_THREAD, "advk-pcie",
+			       pcie);
+	if (ret) {
+		dev_err(dev, "Failed to register interrupt\n");
+		return ret;
+	}
 
 	pcie->reset_gpio = devm_gpiod_get_from_of_node(dev, dev->of_node,
 						       "reset-gpios", 0,
@@ -1818,15 +1820,12 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	irq_set_chained_handler_and_data(pcie->irq, advk_pcie_irq_handler, pcie);
-
 	bridge->sysdata = pcie;
 	bridge->ops = &advk_pcie_ops;
 	bridge->map_irq = advk_pcie_map_irq;
 
 	ret = pci_host_probe(bridge);
 	if (ret < 0) {
-		irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 		advk_pcie_remove_rp_irq_domain(pcie);
 		advk_pcie_remove_msi_irq_domain(pcie);
 		advk_pcie_remove_irq_domain(pcie);
@@ -1875,9 +1874,6 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	advk_writel(pcie, PCIE_ISR1_ALL_MASK, PCIE_ISR1_REG);
 	advk_writel(pcie, PCIE_IRQ_ALL_MASK, HOST_CTRL_INT_STATUS_REG);
 
-	/* Remove IRQ handler */
-	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
-
 	/* Remove IRQ domains */
 	advk_pcie_remove_rp_irq_domain(pcie);
 	advk_pcie_remove_msi_irq_domain(pcie);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a101faf3e88a..0380543d10fd 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2888,6 +2888,16 @@ static const struct dmi_system_id bridge_d3_blacklist[] = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
 			DMI_MATCH(DMI_BOARD_NAME, "X299 DESIGNARE EX-CF"),
 		},
+		/*
+		 * Downstream device is not accessible after putting a root port
+		 * into D3cold and back into D0 on Elo i2.
+		 */
+		.ident = "Elo i2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Elo Touch Solutions"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Elo i2"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "RevB"),
+		},
 	},
 #endif
 	{ }
diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
index a3fa03bcd9a3..54064714d73f 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
@@ -1236,18 +1236,12 @@ FUNC_GROUP_DECL(SALT8, AA12);
 FUNC_GROUP_DECL(WDTRST4, AA12);
 
 #define AE12 196
-SIG_EXPR_LIST_DECL_SEMG(AE12, FWSPIDQ2, FWQSPID, FWSPID,
-			SIG_DESC_SET(SCU438, 4));
 SIG_EXPR_LIST_DECL_SESG(AE12, GPIOY4, GPIOY4);
-PIN_DECL_(AE12, SIG_EXPR_LIST_PTR(AE12, FWSPIDQ2),
-	  SIG_EXPR_LIST_PTR(AE12, GPIOY4));
+PIN_DECL_(AE12, SIG_EXPR_LIST_PTR(AE12, GPIOY4));
 
 #define AF12 197
-SIG_EXPR_LIST_DECL_SEMG(AF12, FWSPIDQ3, FWQSPID, FWSPID,
-			SIG_DESC_SET(SCU438, 5));
 SIG_EXPR_LIST_DECL_SESG(AF12, GPIOY5, GPIOY5);
-PIN_DECL_(AF12, SIG_EXPR_LIST_PTR(AF12, FWSPIDQ3),
-	  SIG_EXPR_LIST_PTR(AF12, GPIOY5));
+PIN_DECL_(AF12, SIG_EXPR_LIST_PTR(AF12, GPIOY5));
 
 #define AC12 198
 SSSF_PIN_DECL(AC12, GPIOY6, FWSPIABR, SIG_DESC_SET(SCU438, 6));
@@ -1520,9 +1514,8 @@ SIG_EXPR_LIST_DECL_SEMG(Y4, EMMCDAT7, EMMCG8, EMMC, SIG_DESC_SET(SCU404, 3));
 PIN_DECL_3(Y4, GPIO18E3, FWSPIDMISO, VBMISO, EMMCDAT7);
 
 GROUP_DECL(FWSPID, Y1, Y2, Y3, Y4);
-GROUP_DECL(FWQSPID, Y1, Y2, Y3, Y4, AE12, AF12);
 GROUP_DECL(EMMCG8, AB4, AA4, AC4, AA5, Y5, AB5, AB6, AC5, Y1, Y2, Y3, Y4);
-FUNC_DECL_2(FWSPID, FWSPID, FWQSPID);
+FUNC_DECL_1(FWSPID, FWSPID);
 FUNC_GROUP_DECL(VB, Y1, Y2, Y3, Y4);
 FUNC_DECL_3(EMMC, EMMCG1, EMMCG4, EMMCG8);
 /*
@@ -1918,7 +1911,6 @@ static const struct aspeed_pin_group aspeed_g6_groups[] = {
 	ASPEED_PINCTRL_GROUP(FSI2),
 	ASPEED_PINCTRL_GROUP(FWSPIABR),
 	ASPEED_PINCTRL_GROUP(FWSPID),
-	ASPEED_PINCTRL_GROUP(FWQSPID),
 	ASPEED_PINCTRL_GROUP(FWSPIWP),
 	ASPEED_PINCTRL_GROUP(GPIT0),
 	ASPEED_PINCTRL_GROUP(GPIT1),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8365.c b/drivers/pinctrl/mediatek/pinctrl-mt8365.c
index 79b1fee5a1eb..ddee0db72d26 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8365.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8365.c
@@ -259,7 +259,7 @@ static const struct mtk_pin_ies_smt_set mt8365_ies_set[] = {
 	MTK_PIN_IES_SMT_SPEC(104, 104, 0x420, 13),
 	MTK_PIN_IES_SMT_SPEC(105, 109, 0x420, 14),
 	MTK_PIN_IES_SMT_SPEC(110, 113, 0x420, 15),
-	MTK_PIN_IES_SMT_SPEC(114, 112, 0x420, 16),
+	MTK_PIN_IES_SMT_SPEC(114, 116, 0x420, 16),
 	MTK_PIN_IES_SMT_SPEC(117, 119, 0x420, 17),
 	MTK_PIN_IES_SMT_SPEC(120, 122, 0x420, 18),
 	MTK_PIN_IES_SMT_SPEC(123, 125, 0x420, 19),
diff --git a/drivers/platform/chrome/cros_ec_debugfs.c b/drivers/platform/chrome/cros_ec_debugfs.c
index 272c89837d74..0dbceee87a4b 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -25,6 +25,9 @@
 
 #define CIRC_ADD(idx, size, value)	(((idx) + (value)) & ((size) - 1))
 
+/* waitqueue for log readers */
+static DECLARE_WAIT_QUEUE_HEAD(cros_ec_debugfs_log_wq);
+
 /**
  * struct cros_ec_debugfs - EC debugging information.
  *
@@ -33,7 +36,6 @@
  * @log_buffer: circular buffer for console log information
  * @read_msg: preallocated EC command and buffer to read console log
  * @log_mutex: mutex to protect circular buffer
- * @log_wq: waitqueue for log readers
  * @log_poll_work: recurring task to poll EC for new console log data
  * @panicinfo_blob: panicinfo debugfs blob
  */
@@ -44,7 +46,6 @@ struct cros_ec_debugfs {
 	struct circ_buf log_buffer;
 	struct cros_ec_command *read_msg;
 	struct mutex log_mutex;
-	wait_queue_head_t log_wq;
 	struct delayed_work log_poll_work;
 	/* EC panicinfo */
 	struct debugfs_blob_wrapper panicinfo_blob;
@@ -107,7 +108,7 @@ static void cros_ec_console_log_work(struct work_struct *__work)
 			buf_space--;
 		}
 
-		wake_up(&debug_info->log_wq);
+		wake_up(&cros_ec_debugfs_log_wq);
 	}
 
 	mutex_unlock(&debug_info->log_mutex);
@@ -141,7 +142,7 @@ static ssize_t cros_ec_console_log_read(struct file *file, char __user *buf,
 
 		mutex_unlock(&debug_info->log_mutex);
 
-		ret = wait_event_interruptible(debug_info->log_wq,
+		ret = wait_event_interruptible(cros_ec_debugfs_log_wq,
 					CIRC_CNT(cb->head, cb->tail, LOG_SIZE));
 		if (ret < 0)
 			return ret;
@@ -173,7 +174,7 @@ static __poll_t cros_ec_console_log_poll(struct file *file,
 	struct cros_ec_debugfs *debug_info = file->private_data;
 	__poll_t mask = 0;
 
-	poll_wait(file, &debug_info->log_wq, wait);
+	poll_wait(file, &cros_ec_debugfs_log_wq, wait);
 
 	mutex_lock(&debug_info->log_mutex);
 	if (CIRC_CNT(debug_info->log_buffer.head,
@@ -377,7 +378,6 @@ static int cros_ec_create_console_log(struct cros_ec_debugfs *debug_info)
 	debug_info->log_buffer.tail = 0;
 
 	mutex_init(&debug_info->log_mutex);
-	init_waitqueue_head(&debug_info->log_wq);
 
 	debugfs_create_file("console_log", S_IFREG | 0444, debug_info->dir,
 			    debug_info, &cros_ec_console_log_fops);
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index f77bc089eb6b..0aef7df2ea70 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -26,6 +26,15 @@ struct class *rtc_class;
 static void rtc_device_release(struct device *dev)
 {
 	struct rtc_device *rtc = to_rtc_device(dev);
+	struct timerqueue_head *head = &rtc->timerqueue;
+	struct timerqueue_node *node;
+
+	mutex_lock(&rtc->ops_lock);
+	while ((node = timerqueue_getnext(head)))
+		timerqueue_del(head, node);
+	mutex_unlock(&rtc->ops_lock);
+
+	cancel_work_sync(&rtc->irqwork);
 
 	ida_simple_remove(&rtc_ida, rtc->id);
 	mutex_destroy(&rtc->ops_lock);
diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 8abac672f3cb..f3f5a87fe376 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -146,6 +146,17 @@ int mc146818_get_time(struct rtc_time *time)
 }
 EXPORT_SYMBOL_GPL(mc146818_get_time);
 
+/* AMD systems don't allow access to AltCentury with DV1 */
+static bool apply_amd_register_a_behavior(void)
+{
+#ifdef CONFIG_X86
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+	    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
+		return true;
+#endif
+	return false;
+}
+
 /* Set the current date and time in the real time clock. */
 int mc146818_set_time(struct rtc_time *time)
 {
@@ -219,7 +230,10 @@ int mc146818_set_time(struct rtc_time *time)
 	save_control = CMOS_READ(RTC_CONTROL);
 	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
 	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
-	CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
+	if (apply_amd_register_a_behavior())
+		CMOS_WRITE((save_freq_select & ~RTC_AMD_BANK_SELECT), RTC_FREQ_SELECT);
+	else
+		CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
 
 #ifdef CONFIG_MACH_DECSTATION
 	CMOS_WRITE(real_yrs, RTC_DEC_YEAR);
diff --git a/drivers/rtc/rtc-pcf2127.c b/drivers/rtc/rtc-pcf2127.c
index 56c58b055dff..43f801107095 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -374,7 +374,8 @@ static int pcf2127_watchdog_init(struct device *dev, struct pcf2127 *pcf2127)
 static int pcf2127_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct pcf2127 *pcf2127 = dev_get_drvdata(dev);
-	unsigned int buf[5], ctrl2;
+	u8 buf[5];
+	unsigned int ctrl2;
 	int ret;
 
 	ret = regmap_read(pcf2127->regmap, PCF2127_REG_CTRL2, &ctrl2);
diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index adec1b14a8de..c551ebf0ac00 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -138,7 +138,7 @@ struct sun6i_rtc_dev {
 	const struct sun6i_rtc_clk_data *data;
 	void __iomem *base;
 	int irq;
-	unsigned long alarm;
+	time64_t alarm;
 
 	struct clk_hw hw;
 	struct clk_hw *int_osc;
@@ -510,10 +510,8 @@ static int sun6i_rtc_setalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	struct sun6i_rtc_dev *chip = dev_get_drvdata(dev);
 	struct rtc_time *alrm_tm = &wkalrm->time;
 	struct rtc_time tm_now;
-	unsigned long time_now = 0;
-	unsigned long time_set = 0;
-	unsigned long time_gap = 0;
-	int ret = 0;
+	time64_t time_now, time_set;
+	int ret;
 
 	ret = sun6i_rtc_gettime(dev, &tm_now);
 	if (ret < 0) {
@@ -528,9 +526,7 @@ static int sun6i_rtc_setalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 		return -EINVAL;
 	}
 
-	time_gap = time_set - time_now;
-
-	if (time_gap > U32_MAX) {
+	if ((time_set - time_now) > U32_MAX) {
 		dev_err(dev, "Date too far in the future\n");
 		return -EINVAL;
 	}
@@ -539,7 +535,7 @@ static int sun6i_rtc_setalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	writel(0, chip->base + SUN6I_ALRM_COUNTER);
 	usleep_range(100, 300);
 
-	writel(time_gap, chip->base + SUN6I_ALRM_COUNTER);
+	writel(time_set - time_now, chip->base + SUN6I_ALRM_COUNTER);
 	chip->alarm = time_set;
 
 	sun6i_rtc_setaie(wkalrm->enabled, chip);
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 37d06f993b76..1d9be771f3ee 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1172,9 +1172,8 @@ static blk_status_t alua_prep_fn(struct scsi_device *sdev, struct request *req)
 	case SCSI_ACCESS_STATE_OPTIMAL:
 	case SCSI_ACCESS_STATE_ACTIVE:
 	case SCSI_ACCESS_STATE_LBA:
-		return BLK_STS_OK;
 	case SCSI_ACCESS_STATE_TRANSITIONING:
-		return BLK_STS_AGAIN;
+		return BLK_STS_OK;
 	default:
 		req->rq_flags |= RQF_QUIET;
 		return BLK_STS_IOERR;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index f5d32d830a9b..ae5eaa4a9283 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3837,6 +3837,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
+		if (cmd->sg_mapped)
+			qlt_unmap_sg(vha, cmd);
+
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/*
 		 * It's normal to see 2 calls in this path:
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index f7eaf64293a4..14300896c57f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1257,6 +1257,13 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	struct utp_hpb_rsp *rsp_field = &lrbp->ucd_rsp_ptr->hr;
 	int data_seg_len;
 
+	data_seg_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
+		& MASK_RSP_UPIU_DATA_SEG_LEN;
+
+	/* If data segment length is zero, rsp_field is not valid */
+	if (!data_seg_len)
+		return;
+
 	if (unlikely(lrbp->lun != rsp_field->lun)) {
 		struct scsi_device *sdev;
 		bool found = false;
@@ -1291,18 +1298,6 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		return;
 	}
 
-	data_seg_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
-		& MASK_RSP_UPIU_DATA_SEG_LEN;
-
-	/* To flush remained rsp_list, we queue the map_work task */
-	if (!data_seg_len) {
-		if (!ufshpb_is_general_lun(hpb->lun))
-			return;
-
-		ufshpb_kick_map_work(hpb);
-		return;
-	}
-
 	BUILD_BUG_ON(sizeof(struct utp_hpb_rsp) != UTP_HPB_RSP_SIZE);
 
 	if (!ufshpb_is_hpb_rsp_valid(hba, lrbp, rsp_field))
diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index d86c3a36441e..3427ce37a5c5 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -145,6 +145,7 @@ enum dev_state {
 	STATE_DEV_INVALID = 0,
 	STATE_DEV_OPENED,
 	STATE_DEV_INITIALIZED,
+	STATE_DEV_REGISTERING,
 	STATE_DEV_RUNNING,
 	STATE_DEV_CLOSED,
 	STATE_DEV_FAILED
@@ -508,6 +509,7 @@ static int raw_ioctl_run(struct raw_dev *dev, unsigned long value)
 		ret = -EINVAL;
 		goto out_unlock;
 	}
+	dev->state = STATE_DEV_REGISTERING;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	ret = usb_gadget_probe_driver(&dev->driver);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 792ab5f23647..297b5db47454 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1450,13 +1450,9 @@ static struct socket *get_raw_socket(int fd)
 	return ERR_PTR(r);
 }
 
-static struct ptr_ring *get_tap_ptr_ring(int fd)
+static struct ptr_ring *get_tap_ptr_ring(struct file *file)
 {
 	struct ptr_ring *ring;
-	struct file *file = fget(fd);
-
-	if (!file)
-		return NULL;
 	ring = tun_get_tx_ring(file);
 	if (!IS_ERR(ring))
 		goto out;
@@ -1465,7 +1461,6 @@ static struct ptr_ring *get_tap_ptr_ring(int fd)
 		goto out;
 	ring = NULL;
 out:
-	fput(file);
 	return ring;
 }
 
@@ -1552,8 +1547,12 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		r = vhost_net_enable_vq(n, vq);
 		if (r)
 			goto err_used;
-		if (index == VHOST_NET_VQ_RX)
-			nvq->rx_ring = get_tap_ptr_ring(fd);
+		if (index == VHOST_NET_VQ_RX) {
+			if (sock)
+				nvq->rx_ring = get_tap_ptr_ring(sock->file);
+			else
+				nvq->rx_ring = NULL;
+		}
 
 		oldubufs = nvq->ubufs;
 		nvq->ubufs = ubufs;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index d62f05d056b7..299a99532618 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -97,8 +97,11 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 		return;
 
 	irq = ops->get_vq_irq(vdpa, qid);
+	if (irq < 0)
+		return;
+
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	if (!vq->call_ctx.ctx || irq < 0)
+	if (!vq->call_ctx.ctx)
 		return;
 
 	vq->call_ctx.producer.token = vq->call_ctx.ctx;
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 8e38a7a5cf2f..0371ad233fdf 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1436,10 +1436,7 @@ fb_release(struct inode *inode, struct file *file)
 __acquires(&info->lock)
 __releases(&info->lock)
 {
-	struct fb_info * const info = file_fb_info(file);
-
-	if (!info)
-		return -ENODEV;
+	struct fb_info * const info = file->private_data;
 
 	lock_fb_info(info);
 	if (info->fbops->fb_release)
diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index 65dae05fff8e..ce699396d6ba 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -80,6 +80,10 @@ void framebuffer_release(struct fb_info *info)
 {
 	if (!info)
 		return;
+
+	if (WARN_ON(refcount_read(&info->count)))
+		return;
+
 	kfree(info->apertures);
 	kfree(info);
 }
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index a730ecbf78cd..4820af929a82 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -48,7 +48,7 @@
 /* internal variables */
 
 enum tco_reg_layout {
-	sp5100, sb800, efch
+	sp5100, sb800, efch, efch_mmio
 };
 
 struct sp5100_tco {
@@ -85,6 +85,10 @@ static enum tco_reg_layout tco_reg_layout(struct pci_dev *dev)
 	    dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS &&
 	    dev->revision < 0x40) {
 		return sp5100;
+	} else if (dev->vendor == PCI_VENDOR_ID_AMD &&
+	    sp5100_tco_pci->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS &&
+	    sp5100_tco_pci->revision >= AMD_ZEN_SMBUS_PCI_REV) {
+		return efch_mmio;
 	} else if (dev->vendor == PCI_VENDOR_ID_AMD &&
 	    ((dev->device == PCI_DEVICE_ID_AMD_HUDSON2_SMBUS &&
 	     dev->revision >= 0x41) ||
@@ -201,6 +205,8 @@ static void tco_timer_enable(struct sp5100_tco *tco)
 					  ~EFCH_PM_WATCHDOG_DISABLE,
 					  EFCH_PM_DECODEEN_SECOND_RES);
 		break;
+	default:
+		break;
 	}
 }
 
@@ -215,14 +221,195 @@ static u32 sp5100_tco_read_pm_reg32(u8 index)
 	return val;
 }
 
+static u32 sp5100_tco_request_region(struct device *dev,
+				     u32 mmio_addr,
+				     const char *dev_name)
+{
+	if (!devm_request_mem_region(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE,
+				     dev_name)) {
+		dev_dbg(dev, "MMIO address 0x%08x already in use\n", mmio_addr);
+		return 0;
+	}
+
+	return mmio_addr;
+}
+
+static u32 sp5100_tco_prepare_base(struct sp5100_tco *tco,
+				   u32 mmio_addr,
+				   u32 alt_mmio_addr,
+				   const char *dev_name)
+{
+	struct device *dev = tco->wdd.parent;
+
+	dev_dbg(dev, "Got 0x%08x from SBResource_MMIO register\n", mmio_addr);
+
+	if (!mmio_addr && !alt_mmio_addr)
+		return -ENODEV;
+
+	/* Check for MMIO address and alternate MMIO address conflicts */
+	if (mmio_addr)
+		mmio_addr = sp5100_tco_request_region(dev, mmio_addr, dev_name);
+
+	if (!mmio_addr && alt_mmio_addr)
+		mmio_addr = sp5100_tco_request_region(dev, alt_mmio_addr, dev_name);
+
+	if (!mmio_addr) {
+		dev_err(dev, "Failed to reserve MMIO or alternate MMIO region\n");
+		return -EBUSY;
+	}
+
+	tco->tcobase = devm_ioremap(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE);
+	if (!tco->tcobase) {
+		dev_err(dev, "MMIO address 0x%08x failed mapping\n", mmio_addr);
+		devm_release_mem_region(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE);
+		return -ENOMEM;
+	}
+
+	dev_info(dev, "Using 0x%08x for watchdog MMIO address\n", mmio_addr);
+
+	return 0;
+}
+
+static int sp5100_tco_timer_init(struct sp5100_tco *tco)
+{
+	struct watchdog_device *wdd = &tco->wdd;
+	struct device *dev = wdd->parent;
+	u32 val;
+
+	val = readl(SP5100_WDT_CONTROL(tco->tcobase));
+	if (val & SP5100_WDT_DISABLED) {
+		dev_err(dev, "Watchdog hardware is disabled\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Save WatchDogFired status, because WatchDogFired flag is
+	 * cleared here.
+	 */
+	if (val & SP5100_WDT_FIRED)
+		wdd->bootstatus = WDIOF_CARDRESET;
+
+	/* Set watchdog action to reset the system */
+	val &= ~SP5100_WDT_ACTION_RESET;
+	writel(val, SP5100_WDT_CONTROL(tco->tcobase));
+
+	/* Set a reasonable heartbeat before we stop the timer */
+	tco_timer_set_timeout(wdd, wdd->timeout);
+
+	/*
+	 * Stop the TCO before we change anything so we don't race with
+	 * a zeroed timer.
+	 */
+	tco_timer_stop(wdd);
+
+	return 0;
+}
+
+static u8 efch_read_pm_reg8(void __iomem *addr, u8 index)
+{
+	return readb(addr + index);
+}
+
+static void efch_update_pm_reg8(void __iomem *addr, u8 index, u8 reset, u8 set)
+{
+	u8 val;
+
+	val = readb(addr + index);
+	val &= reset;
+	val |= set;
+	writeb(val, addr + index);
+}
+
+static void tco_timer_enable_mmio(void __iomem *addr)
+{
+	efch_update_pm_reg8(addr, EFCH_PM_DECODEEN3,
+			    ~EFCH_PM_WATCHDOG_DISABLE,
+			    EFCH_PM_DECODEEN_SECOND_RES);
+}
+
+static int sp5100_tco_setupdevice_mmio(struct device *dev,
+				       struct watchdog_device *wdd)
+{
+	struct sp5100_tco *tco = watchdog_get_drvdata(wdd);
+	const char *dev_name = SB800_DEVNAME;
+	u32 mmio_addr = 0, alt_mmio_addr = 0;
+	struct resource *res;
+	void __iomem *addr;
+	int ret;
+	u32 val;
+
+	res = request_mem_region_muxed(EFCH_PM_ACPI_MMIO_PM_ADDR,
+				       EFCH_PM_ACPI_MMIO_PM_SIZE,
+				       "sp5100_tco");
+
+	if (!res) {
+		dev_err(dev,
+			"Memory region 0x%08x already in use\n",
+			EFCH_PM_ACPI_MMIO_PM_ADDR);
+		return -EBUSY;
+	}
+
+	addr = ioremap(EFCH_PM_ACPI_MMIO_PM_ADDR, EFCH_PM_ACPI_MMIO_PM_SIZE);
+	if (!addr) {
+		dev_err(dev, "Address mapping failed\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * EFCH_PM_DECODEEN_WDT_TMREN is dual purpose. This bitfield
+	 * enables sp5100_tco register MMIO space decoding. The bitfield
+	 * also starts the timer operation. Enable if not already enabled.
+	 */
+	val = efch_read_pm_reg8(addr, EFCH_PM_DECODEEN);
+	if (!(val & EFCH_PM_DECODEEN_WDT_TMREN)) {
+		efch_update_pm_reg8(addr, EFCH_PM_DECODEEN, 0xff,
+				    EFCH_PM_DECODEEN_WDT_TMREN);
+	}
+
+	/* Error if the timer could not be enabled */
+	val = efch_read_pm_reg8(addr, EFCH_PM_DECODEEN);
+	if (!(val & EFCH_PM_DECODEEN_WDT_TMREN)) {
+		dev_err(dev, "Failed to enable the timer\n");
+		ret = -EFAULT;
+		goto out;
+	}
+
+	mmio_addr = EFCH_PM_WDT_ADDR;
+
+	/* Determine alternate MMIO base address */
+	val = efch_read_pm_reg8(addr, EFCH_PM_ISACONTROL);
+	if (val & EFCH_PM_ISACONTROL_MMIOEN)
+		alt_mmio_addr = EFCH_PM_ACPI_MMIO_ADDR +
+			EFCH_PM_ACPI_MMIO_WDT_OFFSET;
+
+	ret = sp5100_tco_prepare_base(tco, mmio_addr, alt_mmio_addr, dev_name);
+	if (!ret) {
+		tco_timer_enable_mmio(addr);
+		ret = sp5100_tco_timer_init(tco);
+	}
+
+out:
+	if (addr)
+		iounmap(addr);
+
+	release_resource(res);
+
+	return ret;
+}
+
 static int sp5100_tco_setupdevice(struct device *dev,
 				  struct watchdog_device *wdd)
 {
 	struct sp5100_tco *tco = watchdog_get_drvdata(wdd);
 	const char *dev_name;
 	u32 mmio_addr = 0, val;
+	u32 alt_mmio_addr = 0;
 	int ret;
 
+	if (tco->tco_reg_layout == efch_mmio)
+		return sp5100_tco_setupdevice_mmio(dev, wdd);
+
 	/* Request the IO ports used by this driver */
 	if (!request_muxed_region(SP5100_IO_PM_INDEX_REG,
 				  SP5100_PM_IOPORTS_SIZE, "sp5100_tco")) {
@@ -239,138 +426,55 @@ static int sp5100_tco_setupdevice(struct device *dev,
 		dev_name = SP5100_DEVNAME;
 		mmio_addr = sp5100_tco_read_pm_reg32(SP5100_PM_WATCHDOG_BASE) &
 								0xfffffff8;
+
+		/*
+		 * Secondly, find the watchdog timer MMIO address
+		 * from SBResource_MMIO register.
+		 */
+
+		/* Read SBResource_MMIO from PCI config(PCI_Reg: 9Ch) */
+		pci_read_config_dword(sp5100_tco_pci,
+				      SP5100_SB_RESOURCE_MMIO_BASE,
+				      &val);
+
+		/* Verify MMIO is enabled and using bar0 */
+		if ((val & SB800_ACPI_MMIO_MASK) == SB800_ACPI_MMIO_DECODE_EN)
+			alt_mmio_addr = (val & ~0xfff) + SB800_PM_WDT_MMIO_OFFSET;
 		break;
 	case sb800:
 		dev_name = SB800_DEVNAME;
 		mmio_addr = sp5100_tco_read_pm_reg32(SB800_PM_WATCHDOG_BASE) &
 								0xfffffff8;
+
+		/* Read SBResource_MMIO from AcpiMmioEn(PM_Reg: 24h) */
+		val = sp5100_tco_read_pm_reg32(SB800_PM_ACPI_MMIO_EN);
+
+		/* Verify MMIO is enabled and using bar0 */
+		if ((val & SB800_ACPI_MMIO_MASK) == SB800_ACPI_MMIO_DECODE_EN)
+			alt_mmio_addr = (val & ~0xfff) + SB800_PM_WDT_MMIO_OFFSET;
 		break;
 	case efch:
 		dev_name = SB800_DEVNAME;
-		/*
-		 * On Family 17h devices, the EFCH_PM_DECODEEN_WDT_TMREN bit of
-		 * EFCH_PM_DECODEEN not only enables the EFCH_PM_WDT_ADDR memory
-		 * region, it also enables the watchdog itself.
-		 */
-		if (boot_cpu_data.x86 == 0x17) {
-			val = sp5100_tco_read_pm_reg8(EFCH_PM_DECODEEN);
-			if (!(val & EFCH_PM_DECODEEN_WDT_TMREN)) {
-				sp5100_tco_update_pm_reg8(EFCH_PM_DECODEEN, 0xff,
-							  EFCH_PM_DECODEEN_WDT_TMREN);
-			}
-		}
 		val = sp5100_tco_read_pm_reg8(EFCH_PM_DECODEEN);
 		if (val & EFCH_PM_DECODEEN_WDT_TMREN)
 			mmio_addr = EFCH_PM_WDT_ADDR;
+
+		val = sp5100_tco_read_pm_reg8(EFCH_PM_ISACONTROL);
+		if (val & EFCH_PM_ISACONTROL_MMIOEN)
+			alt_mmio_addr = EFCH_PM_ACPI_MMIO_ADDR +
+				EFCH_PM_ACPI_MMIO_WDT_OFFSET;
 		break;
 	default:
 		return -ENODEV;
 	}
 
-	/* Check MMIO address conflict */
-	if (!mmio_addr ||
-	    !devm_request_mem_region(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE,
-				     dev_name)) {
-		if (mmio_addr)
-			dev_dbg(dev, "MMIO address 0x%08x already in use\n",
-				mmio_addr);
-		switch (tco->tco_reg_layout) {
-		case sp5100:
-			/*
-			 * Secondly, Find the watchdog timer MMIO address
-			 * from SBResource_MMIO register.
-			 */
-			/* Read SBResource_MMIO from PCI config(PCI_Reg: 9Ch) */
-			pci_read_config_dword(sp5100_tco_pci,
-					      SP5100_SB_RESOURCE_MMIO_BASE,
-					      &mmio_addr);
-			if ((mmio_addr & (SB800_ACPI_MMIO_DECODE_EN |
-					  SB800_ACPI_MMIO_SEL)) !=
-						  SB800_ACPI_MMIO_DECODE_EN) {
-				ret = -ENODEV;
-				goto unreg_region;
-			}
-			mmio_addr &= ~0xFFF;
-			mmio_addr += SB800_PM_WDT_MMIO_OFFSET;
-			break;
-		case sb800:
-			/* Read SBResource_MMIO from AcpiMmioEn(PM_Reg: 24h) */
-			mmio_addr =
-				sp5100_tco_read_pm_reg32(SB800_PM_ACPI_MMIO_EN);
-			if ((mmio_addr & (SB800_ACPI_MMIO_DECODE_EN |
-					  SB800_ACPI_MMIO_SEL)) !=
-						  SB800_ACPI_MMIO_DECODE_EN) {
-				ret = -ENODEV;
-				goto unreg_region;
-			}
-			mmio_addr &= ~0xFFF;
-			mmio_addr += SB800_PM_WDT_MMIO_OFFSET;
-			break;
-		case efch:
-			val = sp5100_tco_read_pm_reg8(EFCH_PM_ISACONTROL);
-			if (!(val & EFCH_PM_ISACONTROL_MMIOEN)) {
-				ret = -ENODEV;
-				goto unreg_region;
-			}
-			mmio_addr = EFCH_PM_ACPI_MMIO_ADDR +
-				    EFCH_PM_ACPI_MMIO_WDT_OFFSET;
-			break;
-		}
-		dev_dbg(dev, "Got 0x%08x from SBResource_MMIO register\n",
-			mmio_addr);
-		if (!devm_request_mem_region(dev, mmio_addr,
-					     SP5100_WDT_MEM_MAP_SIZE,
-					     dev_name)) {
-			dev_dbg(dev, "MMIO address 0x%08x already in use\n",
-				mmio_addr);
-			ret = -EBUSY;
-			goto unreg_region;
-		}
-	}
-
-	tco->tcobase = devm_ioremap(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE);
-	if (!tco->tcobase) {
-		dev_err(dev, "failed to get tcobase address\n");
-		ret = -ENOMEM;
-		goto unreg_region;
-	}
-
-	dev_info(dev, "Using 0x%08x for watchdog MMIO address\n", mmio_addr);
-
-	/* Setup the watchdog timer */
-	tco_timer_enable(tco);
-
-	val = readl(SP5100_WDT_CONTROL(tco->tcobase));
-	if (val & SP5100_WDT_DISABLED) {
-		dev_err(dev, "Watchdog hardware is disabled\n");
-		ret = -ENODEV;
-		goto unreg_region;
+	ret = sp5100_tco_prepare_base(tco, mmio_addr, alt_mmio_addr, dev_name);
+	if (!ret) {
+		/* Setup the watchdog timer */
+		tco_timer_enable(tco);
+		ret = sp5100_tco_timer_init(tco);
 	}
 
-	/*
-	 * Save WatchDogFired status, because WatchDogFired flag is
-	 * cleared here.
-	 */
-	if (val & SP5100_WDT_FIRED)
-		wdd->bootstatus = WDIOF_CARDRESET;
-	/* Set watchdog action to reset the system */
-	val &= ~SP5100_WDT_ACTION_RESET;
-	writel(val, SP5100_WDT_CONTROL(tco->tcobase));
-
-	/* Set a reasonable heartbeat before we stop the timer */
-	tco_timer_set_timeout(wdd, wdd->timeout);
-
-	/*
-	 * Stop the TCO before we change anything so we don't race with
-	 * a zeroed timer.
-	 */
-	tco_timer_stop(wdd);
-
-	release_region(SP5100_IO_PM_INDEX_REG, SP5100_PM_IOPORTS_SIZE);
-
-	return 0;
-
-unreg_region:
 	release_region(SP5100_IO_PM_INDEX_REG, SP5100_PM_IOPORTS_SIZE);
 	return ret;
 }
diff --git a/drivers/watchdog/sp5100_tco.h b/drivers/watchdog/sp5100_tco.h
index adf015aa4126..6a0986d2c94b 100644
--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -58,6 +58,7 @@
 #define SB800_PM_WATCHDOG_SECOND_RES	GENMASK(1, 0)
 #define SB800_ACPI_MMIO_DECODE_EN	BIT(0)
 #define SB800_ACPI_MMIO_SEL		BIT(1)
+#define SB800_ACPI_MMIO_MASK		GENMASK(1, 0)
 
 #define SB800_PM_WDT_MMIO_OFFSET	0xB00
 
@@ -82,4 +83,10 @@
 #define EFCH_PM_ISACONTROL_MMIOEN	BIT(1)
 
 #define EFCH_PM_ACPI_MMIO_ADDR		0xfed80000
+#define EFCH_PM_ACPI_MMIO_PM_OFFSET	0x00000300
 #define EFCH_PM_ACPI_MMIO_WDT_OFFSET	0x00000b00
+
+#define EFCH_PM_ACPI_MMIO_PM_ADDR	(EFCH_PM_ACPI_MMIO_ADDR +	\
+					 EFCH_PM_ACPI_MMIO_PM_OFFSET)
+#define EFCH_PM_ACPI_MMIO_PM_SIZE	8
+#define AMD_ZEN_SMBUS_PCI_REV		0x51
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 8fcffea2daf5..a47666ba48f5 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -728,10 +728,22 @@ int afs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 {
 	struct inode *inode = d_inode(path->dentry);
 	struct afs_vnode *vnode = AFS_FS_I(inode);
-	int seq = 0;
+	struct key *key;
+	int ret, seq = 0;
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
+	if (!(query_flags & AT_STATX_DONT_SYNC) &&
+	    !test_bit(AFS_VNODE_CB_PROMISED, &vnode->flags)) {
+		key = afs_request_key(vnode->volume->cell);
+		if (IS_ERR(key))
+			return PTR_ERR(key);
+		ret = afs_validate(vnode, key);
+		key_put(key);
+		if (ret < 0)
+			return ret;
+	}
+
 	do {
 		read_seqbegin_or_lock(&vnode->cb_lock, &seq);
 		generic_fillattr(&init_user_ns, inode, stat);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index eb5ea0262f3c..60390f9dc31f 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -963,14 +963,16 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			return ret;
 		iocb->ki_flags &= ~IOCB_DIRECT;
 	}
+	pagefault_disable();
 	iocb->ki_flags |= IOCB_NOIO;
 	ret = generic_file_read_iter(iocb, to);
 	iocb->ki_flags &= ~IOCB_NOIO;
+	pagefault_enable();
 	if (ret >= 0) {
 		if (!iov_iter_count(to))
 			return ret;
 		written = ret;
-	} else {
+	} else if (ret != -EFAULT) {
 		if (ret != -EAGAIN)
 			return ret;
 		if (iocb->ki_flags & IOCB_NOWAIT)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7aad4bde92e9..b8e6398d9430 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5662,7 +5662,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
-	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
@@ -5672,7 +5671,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		return IO_APOLL_ABORTED;
 
 	if (def->pollin) {
-		rw = READ;
 		mask |= POLLIN | POLLRDNORM;
 
 		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
@@ -5680,14 +5678,9 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
 			mask &= ~POLLIN;
 	} else {
-		rw = WRITE;
 		mask |= POLLOUT | POLLWRNORM;
 	}
 
-	/* if we can't nonblock try, then no point in arming a poll handler */
-	if (!io_file_supports_nowait(req, rw))
-		return IO_APOLL_ABORTED;
-
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 504e69578112..e0a3455f9a0f 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -173,7 +173,7 @@ int fiemap_prep(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 	if (*len == 0)
 		return -EINVAL;
-	if (start > maxbytes)
+	if (start >= maxbytes)
 		return -EFBIG;
 
 	/*
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 4391fd3abd8f..e00e184b1261 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -20,6 +20,23 @@
 #include "page.h"
 #include "btnode.h"
 
+
+/**
+ * nilfs_init_btnc_inode - initialize B-tree node cache inode
+ * @btnc_inode: inode to be initialized
+ *
+ * nilfs_init_btnc_inode() sets up an inode for B-tree node cache.
+ */
+void nilfs_init_btnc_inode(struct inode *btnc_inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(btnc_inode);
+
+	btnc_inode->i_mode = S_IFREG;
+	ii->i_flags = 0;
+	memset(&ii->i_bmap_data, 0, sizeof(struct nilfs_bmap));
+	mapping_set_gfp_mask(btnc_inode->i_mapping, GFP_NOFS);
+}
+
 void nilfs_btnode_cache_clear(struct address_space *btnc)
 {
 	invalidate_mapping_pages(btnc, 0, -1);
@@ -29,7 +46,7 @@ void nilfs_btnode_cache_clear(struct address_space *btnc)
 struct buffer_head *
 nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 {
-	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct inode *inode = btnc->host;
 	struct buffer_head *bh;
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
@@ -57,7 +74,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 			      struct buffer_head **pbh, sector_t *submit_ptr)
 {
 	struct buffer_head *bh;
-	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct inode *inode = btnc->host;
 	struct page *page;
 	int err;
 
@@ -157,7 +174,7 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 				    struct nilfs_btnode_chkey_ctxt *ctxt)
 {
 	struct buffer_head *obh, *nbh;
-	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct inode *inode = btnc->host;
 	__u64 oldkey = ctxt->oldkey, newkey = ctxt->newkey;
 	int err;
 
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 0f88dbc9bcb3..05ab64d354dc 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -30,6 +30,7 @@ struct nilfs_btnode_chkey_ctxt {
 	struct buffer_head *newbh;
 };
 
+void nilfs_init_btnc_inode(struct inode *btnc_inode);
 void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
 					      __u64 blocknr);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index ab9ec073330f..2301b57ca17f 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -58,7 +58,8 @@ static void nilfs_btree_free_path(struct nilfs_btree_path *path)
 static int nilfs_btree_get_new_block(const struct nilfs_bmap *btree,
 				     __u64 ptr, struct buffer_head **bhp)
 {
-	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
+	struct address_space *btnc = btnc_inode->i_mapping;
 	struct buffer_head *bh;
 
 	bh = nilfs_btnode_create_block(btnc, ptr);
@@ -470,7 +471,8 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 				   struct buffer_head **bhp,
 				   const struct nilfs_btree_readahead_info *ra)
 {
-	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
+	struct address_space *btnc = btnc_inode->i_mapping;
 	struct buffer_head *bh, *ra_bh;
 	sector_t submit_ptr = 0;
 	int ret;
@@ -1741,6 +1743,10 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *btree, __u64 key,
 		dat = nilfs_bmap_get_dat(btree);
 	}
 
+	ret = nilfs_attach_btree_node_cache(&NILFS_BMAP_I(btree)->vfs_inode);
+	if (ret < 0)
+		return ret;
+
 	ret = nilfs_bmap_prepare_alloc_ptr(btree, dreq, dat);
 	if (ret < 0)
 		return ret;
@@ -1913,7 +1919,7 @@ static int nilfs_btree_prepare_update_v(struct nilfs_bmap *btree,
 		path[level].bp_ctxt.newkey = path[level].bp_newreq.bpr_ptr;
 		path[level].bp_ctxt.bh = path[level].bp_bh;
 		ret = nilfs_btnode_prepare_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		if (ret < 0) {
 			nilfs_dat_abort_update(dat,
@@ -1939,7 +1945,7 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 
 	if (buffer_nilfs_node(path[level].bp_bh)) {
 		nilfs_btnode_commit_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		path[level].bp_bh = path[level].bp_ctxt.bh;
 	}
@@ -1958,7 +1964,7 @@ static void nilfs_btree_abort_update_v(struct nilfs_bmap *btree,
 			       &path[level].bp_newreq.bpr_req);
 	if (buffer_nilfs_node(path[level].bp_bh))
 		nilfs_btnode_abort_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 }
 
@@ -2134,7 +2140,8 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_bmap *btree,
 static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *btree,
 					     struct list_head *listp)
 {
-	struct address_space *btcache = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
+	struct address_space *btcache = btnc_inode->i_mapping;
 	struct list_head lists[NILFS_BTREE_LEVEL_MAX];
 	struct pagevec pvec;
 	struct buffer_head *bh, *head;
@@ -2188,12 +2195,12 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 		path[level].bp_ctxt.newkey = blocknr;
 		path[level].bp_ctxt.bh = *bh;
 		ret = nilfs_btnode_prepare_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		if (ret < 0)
 			return ret;
 		nilfs_btnode_commit_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		*bh = path[level].bp_ctxt.bh;
 	}
@@ -2398,6 +2405,10 @@ int nilfs_btree_init(struct nilfs_bmap *bmap)
 
 	if (nilfs_btree_root_broken(nilfs_btree_get_root(bmap), bmap->b_inode))
 		ret = -EIO;
+	else
+		ret = nilfs_attach_btree_node_cache(
+			&NILFS_BMAP_I(bmap)->vfs_inode);
+
 	return ret;
 }
 
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 8bccdf1158fc..1a3d183027b9 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -497,7 +497,9 @@ int nilfs_dat_read(struct super_block *sb, size_t entry_size,
 	di = NILFS_DAT_I(dat);
 	lockdep_set_class(&di->mi.mi_sem, &dat_lock_key);
 	nilfs_palloc_setup_cache(dat, &di->palloc_cache);
-	nilfs_mdt_setup_shadow_map(dat, &di->shadow);
+	err = nilfs_mdt_setup_shadow_map(dat, &di->shadow);
+	if (err)
+		goto failed;
 
 	err = nilfs_read_inode_common(dat, raw_inode);
 	if (err)
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 448320496856..aadea660c66c 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -126,9 +126,10 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 				   __u64 vbn, struct buffer_head **out_bh)
 {
+	struct inode *btnc_inode = NILFS_I(inode)->i_assoc_inode;
 	int ret;
 
-	ret = nilfs_btnode_submit_block(&NILFS_I(inode)->i_btnode_cache,
+	ret = nilfs_btnode_submit_block(btnc_inode->i_mapping,
 					vbn ? : pbn, pbn, REQ_OP_READ, 0,
 					out_bh, &pbn);
 	if (ret == -EEXIST) /* internal code (cache hit) */
@@ -170,7 +171,7 @@ int nilfs_init_gcinode(struct inode *inode)
 	ii->i_flags = 0;
 	nilfs_bmap_init_gc(ii->i_bmap);
 
-	return 0;
+	return nilfs_attach_btree_node_cache(inode);
 }
 
 /**
@@ -185,7 +186,7 @@ void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs)
 		ii = list_first_entry(head, struct nilfs_inode_info, i_dirty);
 		list_del_init(&ii->i_dirty);
 		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
-		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+		nilfs_btnode_cache_clear(ii->i_assoc_inode->i_mapping);
 		iput(&ii->vfs_inode);
 	}
 }
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2e8eb263cf0f..2466f8b8be95 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -29,12 +29,16 @@
  * @cno: checkpoint number
  * @root: pointer on NILFS root object (mounted checkpoint)
  * @for_gc: inode for GC flag
+ * @for_btnc: inode for B-tree node cache flag
+ * @for_shadow: inode for shadowed page cache flag
  */
 struct nilfs_iget_args {
 	u64 ino;
 	__u64 cno;
 	struct nilfs_root *root;
-	int for_gc;
+	bool for_gc;
+	bool for_btnc;
+	bool for_shadow;
 };
 
 static int nilfs_iget_test(struct inode *inode, void *opaque);
@@ -314,7 +318,8 @@ static int nilfs_insert_inode_locked(struct inode *inode,
 				     unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+		.ino = ino, .root = root, .cno = 0, .for_gc = false,
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return insert_inode_locked4(inode, ino, nilfs_iget_test, &args);
@@ -527,6 +532,19 @@ static int nilfs_iget_test(struct inode *inode, void *opaque)
 		return 0;
 
 	ii = NILFS_I(inode);
+	if (test_bit(NILFS_I_BTNC, &ii->i_state)) {
+		if (!args->for_btnc)
+			return 0;
+	} else if (args->for_btnc) {
+		return 0;
+	}
+	if (test_bit(NILFS_I_SHADOW, &ii->i_state)) {
+		if (!args->for_shadow)
+			return 0;
+	} else if (args->for_shadow) {
+		return 0;
+	}
+
 	if (!test_bit(NILFS_I_GCINODE, &ii->i_state))
 		return !args->for_gc;
 
@@ -538,15 +556,17 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 	struct nilfs_iget_args *args = opaque;
 
 	inode->i_ino = args->ino;
-	if (args->for_gc) {
+	NILFS_I(inode)->i_cno = args->cno;
+	NILFS_I(inode)->i_root = args->root;
+	if (args->root && args->ino == NILFS_ROOT_INO)
+		nilfs_get_root(args->root);
+
+	if (args->for_gc)
 		NILFS_I(inode)->i_state = BIT(NILFS_I_GCINODE);
-		NILFS_I(inode)->i_cno = args->cno;
-		NILFS_I(inode)->i_root = NULL;
-	} else {
-		if (args->root && args->ino == NILFS_ROOT_INO)
-			nilfs_get_root(args->root);
-		NILFS_I(inode)->i_root = args->root;
-	}
+	if (args->for_btnc)
+		NILFS_I(inode)->i_state |= BIT(NILFS_I_BTNC);
+	if (args->for_shadow)
+		NILFS_I(inode)->i_state |= BIT(NILFS_I_SHADOW);
 	return 0;
 }
 
@@ -554,7 +574,8 @@ struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
 			    unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+		.ino = ino, .root = root, .cno = 0, .for_gc = false,
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return ilookup5(sb, ino, nilfs_iget_test, &args);
@@ -564,7 +585,8 @@ struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 				unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+		.ino = ino, .root = root, .cno = 0, .for_gc = false,
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
@@ -595,7 +617,8 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 				__u64 cno)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = NULL, .cno = cno, .for_gc = 1
+		.ino = ino, .root = NULL, .cno = cno, .for_gc = true,
+		.for_btnc = false, .for_shadow = false
 	};
 	struct inode *inode;
 	int err;
@@ -615,6 +638,113 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 	return inode;
 }
 
+/**
+ * nilfs_attach_btree_node_cache - attach a B-tree node cache to the inode
+ * @inode: inode object
+ *
+ * nilfs_attach_btree_node_cache() attaches a B-tree node cache to @inode,
+ * or does nothing if the inode already has it.  This function allocates
+ * an additional inode to maintain page cache of B-tree nodes one-on-one.
+ *
+ * Return Value: On success, 0 is returned. On errors, one of the following
+ * negative error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+int nilfs_attach_btree_node_cache(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct inode *btnc_inode;
+	struct nilfs_iget_args args;
+
+	if (ii->i_assoc_inode)
+		return 0;
+
+	args.ino = inode->i_ino;
+	args.root = ii->i_root;
+	args.cno = ii->i_cno;
+	args.for_gc = test_bit(NILFS_I_GCINODE, &ii->i_state) != 0;
+	args.for_btnc = true;
+	args.for_shadow = test_bit(NILFS_I_SHADOW, &ii->i_state) != 0;
+
+	btnc_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
+				  nilfs_iget_set, &args);
+	if (unlikely(!btnc_inode))
+		return -ENOMEM;
+	if (btnc_inode->i_state & I_NEW) {
+		nilfs_init_btnc_inode(btnc_inode);
+		unlock_new_inode(btnc_inode);
+	}
+	NILFS_I(btnc_inode)->i_assoc_inode = inode;
+	NILFS_I(btnc_inode)->i_bmap = ii->i_bmap;
+	ii->i_assoc_inode = btnc_inode;
+
+	return 0;
+}
+
+/**
+ * nilfs_detach_btree_node_cache - detach the B-tree node cache from the inode
+ * @inode: inode object
+ *
+ * nilfs_detach_btree_node_cache() detaches the B-tree node cache and its
+ * holder inode bound to @inode, or does nothing if @inode doesn't have it.
+ */
+void nilfs_detach_btree_node_cache(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct inode *btnc_inode = ii->i_assoc_inode;
+
+	if (btnc_inode) {
+		NILFS_I(btnc_inode)->i_assoc_inode = NULL;
+		ii->i_assoc_inode = NULL;
+		iput(btnc_inode);
+	}
+}
+
+/**
+ * nilfs_iget_for_shadow - obtain inode for shadow mapping
+ * @inode: inode object that uses shadow mapping
+ *
+ * nilfs_iget_for_shadow() allocates a pair of inodes that holds page
+ * caches for shadow mapping.  The page cache for data pages is set up
+ * in one inode and the one for b-tree node pages is set up in the
+ * other inode, which is attached to the former inode.
+ *
+ * Return Value: On success, a pointer to the inode for data pages is
+ * returned. On errors, one of the following negative error code is returned
+ * in a pointer type.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+struct inode *nilfs_iget_for_shadow(struct inode *inode)
+{
+	struct nilfs_iget_args args = {
+		.ino = inode->i_ino, .root = NULL, .cno = 0, .for_gc = false,
+		.for_btnc = false, .for_shadow = true
+	};
+	struct inode *s_inode;
+	int err;
+
+	s_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
+			       nilfs_iget_set, &args);
+	if (unlikely(!s_inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(s_inode->i_state & I_NEW))
+		return inode;
+
+	NILFS_I(s_inode)->i_flags = 0;
+	memset(NILFS_I(s_inode)->i_bmap, 0, sizeof(struct nilfs_bmap));
+	mapping_set_gfp_mask(s_inode->i_mapping, GFP_NOFS);
+
+	err = nilfs_attach_btree_node_cache(s_inode);
+	if (unlikely(err)) {
+		iget_failed(s_inode);
+		return ERR_PTR(err);
+	}
+	unlock_new_inode(s_inode);
+	return s_inode;
+}
+
 void nilfs_write_inode_common(struct inode *inode,
 			      struct nilfs_inode *raw_inode, int has_bmap)
 {
@@ -762,7 +892,8 @@ static void nilfs_clear_inode(struct inode *inode)
 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
 		nilfs_bmap_clear(ii->i_bmap);
 
-	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+	if (!test_bit(NILFS_I_BTNC, &ii->i_state))
+		nilfs_detach_btree_node_cache(inode);
 
 	if (ii->i_root && inode->i_ino == NILFS_ROOT_INO)
 		nilfs_put_root(ii->i_root);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 97769fe4d588..131b5add32ee 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -470,9 +470,18 @@ int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 void nilfs_mdt_clear(struct inode *inode)
 {
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+	struct nilfs_shadow_map *shadow = mdi->mi_shadow;
 
 	if (mdi->mi_palloc_cache)
 		nilfs_palloc_destroy_cache(inode);
+
+	if (shadow) {
+		struct inode *s_inode = shadow->inode;
+
+		shadow->inode = NULL;
+		iput(s_inode);
+		mdi->mi_shadow = NULL;
+	}
 }
 
 /**
@@ -506,12 +515,15 @@ int nilfs_mdt_setup_shadow_map(struct inode *inode,
 			       struct nilfs_shadow_map *shadow)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+	struct inode *s_inode;
 
 	INIT_LIST_HEAD(&shadow->frozen_buffers);
-	address_space_init_once(&shadow->frozen_data);
-	nilfs_mapping_init(&shadow->frozen_data, inode);
-	address_space_init_once(&shadow->frozen_btnodes);
-	nilfs_mapping_init(&shadow->frozen_btnodes, inode);
+
+	s_inode = nilfs_iget_for_shadow(inode);
+	if (IS_ERR(s_inode))
+		return PTR_ERR(s_inode);
+
+	shadow->inode = s_inode;
 	mi->mi_shadow = shadow;
 	return 0;
 }
@@ -525,14 +537,15 @@ int nilfs_mdt_save_to_shadow_map(struct inode *inode)
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
+	struct inode *s_inode = shadow->inode;
 	int ret;
 
-	ret = nilfs_copy_dirty_pages(&shadow->frozen_data, inode->i_mapping);
+	ret = nilfs_copy_dirty_pages(s_inode->i_mapping, inode->i_mapping);
 	if (ret)
 		goto out;
 
-	ret = nilfs_copy_dirty_pages(&shadow->frozen_btnodes,
-				     &ii->i_btnode_cache);
+	ret = nilfs_copy_dirty_pages(NILFS_I(s_inode)->i_assoc_inode->i_mapping,
+				     ii->i_assoc_inode->i_mapping);
 	if (ret)
 		goto out;
 
@@ -548,7 +561,7 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int blkbits = inode->i_blkbits;
 
-	page = grab_cache_page(&shadow->frozen_data, bh->b_page->index);
+	page = grab_cache_page(shadow->inode->i_mapping, bh->b_page->index);
 	if (!page)
 		return -ENOMEM;
 
@@ -580,7 +593,7 @@ nilfs_mdt_get_frozen_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int n;
 
-	page = find_lock_page(&shadow->frozen_data, bh->b_page->index);
+	page = find_lock_page(shadow->inode->i_mapping, bh->b_page->index);
 	if (page) {
 		if (page_has_buffers(page)) {
 			n = bh_offset(bh) >> inode->i_blkbits;
@@ -621,10 +634,11 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 		nilfs_palloc_clear_cache(inode);
 
 	nilfs_clear_dirty_pages(inode->i_mapping, true);
-	nilfs_copy_back_pages(inode->i_mapping, &shadow->frozen_data);
+	nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping);
 
-	nilfs_clear_dirty_pages(&ii->i_btnode_cache, true);
-	nilfs_copy_back_pages(&ii->i_btnode_cache, &shadow->frozen_btnodes);
+	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
+	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
+			      NILFS_I(shadow->inode)->i_assoc_inode->i_mapping);
 
 	nilfs_bmap_restore(ii->i_bmap, &shadow->bmap_store);
 
@@ -639,10 +653,11 @@ void nilfs_mdt_clear_shadow_map(struct inode *inode)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
+	struct inode *shadow_btnc_inode = NILFS_I(shadow->inode)->i_assoc_inode;
 
 	down_write(&mi->mi_sem);
 	nilfs_release_frozen_buffers(shadow);
-	truncate_inode_pages(&shadow->frozen_data, 0);
-	truncate_inode_pages(&shadow->frozen_btnodes, 0);
+	truncate_inode_pages(shadow->inode->i_mapping, 0);
+	truncate_inode_pages(shadow_btnc_inode->i_mapping, 0);
 	up_write(&mi->mi_sem);
 }
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index e77aea4bb921..9d8ac0d27c16 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -18,14 +18,12 @@
 /**
  * struct nilfs_shadow_map - shadow mapping of meta data file
  * @bmap_store: shadow copy of bmap state
- * @frozen_data: shadowed dirty data pages
- * @frozen_btnodes: shadowed dirty b-tree nodes' pages
+ * @inode: holder of page caches used in shadow mapping
  * @frozen_buffers: list of frozen buffers
  */
 struct nilfs_shadow_map {
 	struct nilfs_bmap_store bmap_store;
-	struct address_space frozen_data;
-	struct address_space frozen_btnodes;
+	struct inode *inode;
 	struct list_head frozen_buffers;
 };
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 60b21b6eeac0..7dcb77d38759 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -28,7 +28,7 @@
  * @i_xattr: <TODO>
  * @i_dir_start_lookup: page index of last successful search
  * @i_cno: checkpoint number for GC inode
- * @i_btnode_cache: cached pages of b-tree nodes
+ * @i_assoc_inode: associated inode (B-tree node cache holder or back pointer)
  * @i_dirty: list for connecting dirty files
  * @xattr_sem: semaphore for extended attributes processing
  * @i_bh: buffer contains disk inode
@@ -43,7 +43,7 @@ struct nilfs_inode_info {
 	__u64 i_xattr;	/* sector_t ??? */
 	__u32 i_dir_start_lookup;
 	__u64 i_cno;		/* check point number for GC inode */
-	struct address_space i_btnode_cache;
+	struct inode *i_assoc_inode;
 	struct list_head i_dirty;	/* List for connecting dirty files */
 
 #ifdef CONFIG_NILFS_XATTR
@@ -75,13 +75,6 @@ NILFS_BMAP_I(const struct nilfs_bmap *bmap)
 	return container_of(bmap, struct nilfs_inode_info, i_bmap_data);
 }
 
-static inline struct inode *NILFS_BTNC_I(struct address_space *btnc)
-{
-	struct nilfs_inode_info *ii =
-		container_of(btnc, struct nilfs_inode_info, i_btnode_cache);
-	return &ii->vfs_inode;
-}
-
 /*
  * Dynamic state flags of NILFS on-memory inode (i_state)
  */
@@ -98,6 +91,8 @@ enum {
 	NILFS_I_INODE_SYNC,		/* dsync is not allowed for inode */
 	NILFS_I_BMAP,			/* has bmap and btnode_cache */
 	NILFS_I_GCINODE,		/* inode for GC, on memory only */
+	NILFS_I_BTNC,			/* inode for btree node cache */
+	NILFS_I_SHADOW,			/* inode for shadowed page cache */
 };
 
 /*
@@ -267,6 +262,9 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 			 unsigned long ino);
 extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
 				       unsigned long ino, __u64 cno);
+int nilfs_attach_btree_node_cache(struct inode *inode);
+void nilfs_detach_btree_node_cache(struct inode *inode);
+struct inode *nilfs_iget_for_shadow(struct inode *inode);
 extern void nilfs_update_inode(struct inode *, struct buffer_head *, int);
 extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 171fb5cd427f..d1a148f0cae3 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -448,10 +448,9 @@ void nilfs_mapping_init(struct address_space *mapping, struct inode *inode)
 /*
  * NILFS2 needs clear_page_dirty() in the following two cases:
  *
- * 1) For B-tree node pages and data pages of the dat/gcdat, NILFS2 clears
- *    page dirty flags when it copies back pages from the shadow cache
- *    (gcdat->{i_mapping,i_btnode_cache}) to its original cache
- *    (dat->{i_mapping,i_btnode_cache}).
+ * 1) For B-tree node pages and data pages of DAT file, NILFS2 clears dirty
+ *    flag of pages when it copies back pages from shadow cache to the
+ *    original cache.
  *
  * 2) Some B-tree operations like insertion or deletion may dispose buffers
  *    in dirty state, and this needs to cancel the dirty state of their pages.
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 686c8ee7b29c..314a23a16689 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -733,15 +733,18 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
 					    struct list_head *listp)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct address_space *mapping = &ii->i_btnode_cache;
+	struct inode *btnc_inode = ii->i_assoc_inode;
 	struct pagevec pvec;
 	struct buffer_head *bh, *head;
 	unsigned int i;
 	pgoff_t index = 0;
 
+	if (!btnc_inode)
+		return;
+
 	pagevec_init(&pvec);
 
-	while (pagevec_lookup_tag(&pvec, mapping, &index,
+	while (pagevec_lookup_tag(&pvec, btnc_inode->i_mapping, &index,
 					PAGECACHE_TAG_DIRTY)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			bh = head = page_buffers(pvec.pages[i]);
@@ -2410,7 +2413,7 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 			continue;
 		list_del_init(&ii->i_dirty);
 		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
-		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+		nilfs_btnode_cache_clear(ii->i_assoc_inode->i_mapping);
 		iput(&ii->vfs_inode);
 	}
 }
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f6b2d280aab5..2883ab625f61 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -157,7 +157,8 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 	ii->i_bh = NULL;
 	ii->i_state = 0;
 	ii->i_cno = 0;
-	nilfs_mapping_init(&ii->i_btnode_cache, &ii->vfs_inode);
+	ii->i_assoc_inode = NULL;
+	ii->i_bmap = &ii->i_bmap_data;
 	return &ii->vfs_inode;
 }
 
@@ -1377,8 +1378,6 @@ static void nilfs_inode_init_once(void *obj)
 #ifdef CONFIG_NILFS_XATTR
 	init_rwsem(&ii->xattr_sem);
 #endif
-	address_space_init_once(&ii->i_btnode_cache);
-	ii->i_bmap = &ii->i_bmap_data;
 	inode_init_once(&ii->vfs_inode);
 }
 
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 83fa08a06507..787fff5ec7f5 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -287,6 +287,9 @@ struct ceph_osd_linger_request {
 	rados_watcherrcb_t errcb;
 	void *data;
 
+	struct ceph_pagelist *request_pl;
+	struct page **notify_id_pages;
+
 	struct page ***preply_pages;
 	size_t *preply_len;
 };
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 8359c50f9988..ec5f71f7135b 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -262,6 +262,8 @@ resource_union(struct resource *r1, struct resource *r2, struct resource *r)
 #define request_muxed_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), IORESOURCE_MUXED)
 #define __request_mem_region(start,n,name, excl) __request_region(&iomem_resource, (start), (n), (name), excl)
 #define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
+#define request_mem_region_muxed(start, n, name) \
+	__request_region(&iomem_resource, (start), (n), (name), IORESOURCE_MUXED)
 #define request_mem_region_exclusive(start,n,name) \
 	__request_region(&iomem_resource, (start), (n), (name), IORESOURCE_EXCLUSIVE)
 #define rename_region(region, newname) do { (region)->name = (newname); } while (0)
diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index 37c74e25f53d..3038124c6115 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -86,6 +86,8 @@ struct cmos_rtc_board_info {
    /* 2 values for divider stage reset, others for "testing purposes only" */
 #  define RTC_DIV_RESET1	0x60
 #  define RTC_DIV_RESET2	0x70
+   /* In AMD BKDG bit 5 and 6 are reserved, bit 4 is for select dv0 bank */
+#  define RTC_AMD_BANK_SELECT	0x10
   /* Periodic intr. / Square wave rate select. 0=none, 1=32.8kHz,... 15=2Hz */
 # define RTC_RATE_SELECT 	0x0F
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 62ff09467776..39f1893ecac0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -887,7 +887,7 @@ struct net_device_path_stack {
 
 struct net_device_path_ctx {
 	const struct net_device *dev;
-	const u8		*daddr;
+	u8			daddr[ETH_ALEN];
 
 	int			num_vlans;
 	struct {
diff --git a/include/linux/security.h b/include/linux/security.h
index 46a02ce34d00..da184e7b361f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -121,10 +121,12 @@ enum lockdown_reason {
 	LOCKDOWN_DEBUGFS,
 	LOCKDOWN_XMON_WR,
 	LOCKDOWN_BPF_WRITE_USER,
+	LOCKDOWN_DBG_WRITE_KERNEL,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
 	LOCKDOWN_BPF_READ_KERNEL,
+	LOCKDOWN_DBG_READ_KERNEL,
 	LOCKDOWN_PERF,
 	LOCKDOWN_TRACEFS,
 	LOCKDOWN_XMON_RW,
diff --git a/include/net/ip.h b/include/net/ip.h
index 0106c6590ee7..a77a9e1c6c04 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -55,6 +55,7 @@ struct inet_skb_parm {
 #define IPSKB_DOREDIRECT	BIT(5)
 #define IPSKB_FRAG_PMTU		BIT(6)
 #define IPSKB_L3SLAVE		BIT(7)
+#define IPSKB_NOPOLICY		BIT(8)
 
 	u16			frag_max_size;
 };
diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 947733a639a6..bd7c3be4af5d 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -66,11 +66,7 @@ struct netns_xfrm {
 	int			sysctl_larval_drop;
 	u32			sysctl_acq_expires;
 
-	u8			policy_default;
-#define XFRM_POL_DEFAULT_IN	1
-#define XFRM_POL_DEFAULT_OUT	2
-#define XFRM_POL_DEFAULT_FWD	4
-#define XFRM_POL_DEFAULT_MASK	7
+	u8			policy_default[XFRM_POLICY_MAX];
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_hdr;
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 358dfe6fefef..65242172e41c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1080,24 +1080,29 @@ xfrm_state_addr_cmp(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x, un
 }
 
 #ifdef CONFIG_XFRM
-static inline bool
-xfrm_default_allow(struct net *net, int dir)
-{
-	u8 def = net->xfrm.policy_default;
-
-	switch (dir) {
-	case XFRM_POLICY_IN:
-		return def & XFRM_POL_DEFAULT_IN ? false : true;
-	case XFRM_POLICY_OUT:
-		return def & XFRM_POL_DEFAULT_OUT ? false : true;
-	case XFRM_POLICY_FWD:
-		return def & XFRM_POL_DEFAULT_FWD ? false : true;
-	}
+int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
+			unsigned short family);
+
+static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
+					 int dir)
+{
+	if (!net->xfrm.policy_count[dir] && !secpath_exists(skb))
+		return net->xfrm.policy_default[dir] == XFRM_USERPOLICY_ACCEPT;
+
 	return false;
 }
 
-int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
-			unsigned short family);
+static inline bool __xfrm_check_dev_nopolicy(struct sk_buff *skb,
+					     int dir, unsigned short family)
+{
+	if (dir != XFRM_POLICY_OUT && family == AF_INET) {
+		/* same dst may be used for traffic originating from
+		 * devices with different policy settings.
+		 */
+		return IPCB(skb)->flags & IPSKB_NOPOLICY;
+	}
+	return skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY);
+}
 
 static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 				       struct sk_buff *skb,
@@ -1109,13 +1114,9 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 	if (sk && sk->sk_policy[XFRM_POLICY_IN])
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
-	if (xfrm_default_allow(net, dir))
-		return (!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
-		       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
-		       __xfrm_policy_check(sk, ndir, skb, family);
-	else
-		return (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
-		       __xfrm_policy_check(sk, ndir, skb, family);
+	return __xfrm_check_nopolicy(net, skb, dir) ||
+	       __xfrm_check_dev_nopolicy(skb, dir, family) ||
+	       __xfrm_policy_check(sk, ndir, skb, family);
 }
 
 static inline int xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb, unsigned short family)
@@ -1167,13 +1168,12 @@ static inline int xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 {
 	struct net *net = dev_net(skb->dev);
 
-	if (xfrm_default_allow(net, XFRM_POLICY_OUT))
-		return !net->xfrm.policy_count[XFRM_POLICY_OUT] ||
-			(skb_dst(skb)->flags & DST_NOXFRM) ||
-			__xfrm_route_forward(skb, family);
-	else
-		return (skb_dst(skb)->flags & DST_NOXFRM) ||
-			__xfrm_route_forward(skb, family);
+	if (!net->xfrm.policy_count[XFRM_POLICY_OUT] &&
+	    net->xfrm.policy_default[XFRM_POLICY_OUT] == XFRM_USERPOLICY_ACCEPT)
+		return true;
+
+	return (skb_dst(skb)->flags & DST_NOXFRM) ||
+	       __xfrm_route_forward(skb, family);
 }
 
 static inline int xfrm4_route_forward(struct sk_buff *skb)
diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
index 8e4a2ca0bcbf..b1523cb8ab30 100644
--- a/include/uapi/linux/dma-buf.h
+++ b/include/uapi/linux/dma-buf.h
@@ -92,7 +92,7 @@ struct dma_buf_sync {
  * between them in actual uapi, they're just different numbers.
  */
 #define DMA_BUF_SET_NAME	_IOW(DMA_BUF_BASE, 1, const char *)
-#define DMA_BUF_SET_NAME_A	_IOW(DMA_BUF_BASE, 1, u32)
-#define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, u64)
+#define DMA_BUF_SET_NAME_A	_IOW(DMA_BUF_BASE, 1, __u32)
+#define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
 
 #endif
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index da06a5553835..7beceb447211 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -53,6 +53,7 @@
 #include <linux/vmacache.h>
 #include <linux/rcupdate.h>
 #include <linux/irq.h>
+#include <linux/security.h>
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -752,6 +753,29 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
 				continue;
 			kgdb_connected = 0;
 		} else {
+			/*
+			 * This is a brutal way to interfere with the debugger
+			 * and prevent gdb being used to poke at kernel memory.
+			 * This could cause trouble if lockdown is applied when
+			 * there is already an active gdb session. For now the
+			 * answer is simply "don't do that". Typically lockdown
+			 * *will* be applied before the debug core gets started
+			 * so only developers using kgdb for fairly advanced
+			 * early kernel debug can be biten by this. Hopefully
+			 * they are sophisticated enough to take care of
+			 * themselves, especially with help from the lockdown
+			 * message printed on the console!
+			 */
+			if (security_locked_down(LOCKDOWN_DBG_WRITE_KERNEL)) {
+				if (IS_ENABLED(CONFIG_KGDB_KDB)) {
+					/* Switch back to kdb if possible... */
+					dbg_kdb_mode = 1;
+					continue;
+				} else {
+					/* ... otherwise just bail */
+					break;
+				}
+			}
 			error = gdb_serial_stub(ks);
 		}
 
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 0852a537dad4..ead4da947127 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -45,6 +45,7 @@
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/security.h>
 #include "kdb_private.h"
 
 #undef	MODULE_PARAM_PREFIX
@@ -166,10 +167,62 @@ struct task_struct *kdb_curr_task(int cpu)
 }
 
 /*
- * Check whether the flags of the current command and the permissions
- * of the kdb console has allow a command to be run.
+ * Update the permissions flags (kdb_cmd_enabled) to match the
+ * current lockdown state.
+ *
+ * Within this function the calls to security_locked_down() are "lazy". We
+ * avoid calling them if the current value of kdb_cmd_enabled already excludes
+ * flags that might be subject to lockdown. Additionally we deliberately check
+ * the lockdown flags independently (even though read lockdown implies write
+ * lockdown) since that results in both simpler code and clearer messages to
+ * the user on first-time debugger entry.
+ *
+ * The permission masks during a read+write lockdown permits the following
+ * flags: INSPECT, SIGNAL, REBOOT (and ALWAYS_SAFE).
+ *
+ * The INSPECT commands are not blocked during lockdown because they are
+ * not arbitrary memory reads. INSPECT covers the backtrace family (sometimes
+ * forcing them to have no arguments) and lsmod. These commands do expose
+ * some kernel state but do not allow the developer seated at the console to
+ * choose what state is reported. SIGNAL and REBOOT should not be controversial,
+ * given these are allowed for root during lockdown already.
+ */
+static void kdb_check_for_lockdown(void)
+{
+	const int write_flags = KDB_ENABLE_MEM_WRITE |
+				KDB_ENABLE_REG_WRITE |
+				KDB_ENABLE_FLOW_CTRL;
+	const int read_flags = KDB_ENABLE_MEM_READ |
+			       KDB_ENABLE_REG_READ;
+
+	bool need_to_lockdown_write = false;
+	bool need_to_lockdown_read = false;
+
+	if (kdb_cmd_enabled & (KDB_ENABLE_ALL | write_flags))
+		need_to_lockdown_write =
+			security_locked_down(LOCKDOWN_DBG_WRITE_KERNEL);
+
+	if (kdb_cmd_enabled & (KDB_ENABLE_ALL | read_flags))
+		need_to_lockdown_read =
+			security_locked_down(LOCKDOWN_DBG_READ_KERNEL);
+
+	/* De-compose KDB_ENABLE_ALL if required */
+	if (need_to_lockdown_write || need_to_lockdown_read)
+		if (kdb_cmd_enabled & KDB_ENABLE_ALL)
+			kdb_cmd_enabled = KDB_ENABLE_MASK & ~KDB_ENABLE_ALL;
+
+	if (need_to_lockdown_write)
+		kdb_cmd_enabled &= ~write_flags;
+
+	if (need_to_lockdown_read)
+		kdb_cmd_enabled &= ~read_flags;
+}
+
+/*
+ * Check whether the flags of the current command, the permissions of the kdb
+ * console and the lockdown state allow a command to be run.
  */
-static inline bool kdb_check_flags(kdb_cmdflags_t flags, int permissions,
+static bool kdb_check_flags(kdb_cmdflags_t flags, int permissions,
 				   bool no_args)
 {
 	/* permissions comes from userspace so needs massaging slightly */
@@ -1180,6 +1233,9 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		kdb_curr_task(raw_smp_processor_id());
 
 	KDB_DEBUG_STATE("kdb_local 1", reason);
+
+	kdb_check_for_lockdown();
+
 	kdb_go_count = 0;
 	if (reason == KDB_REASON_DEBUG) {
 		/* special case below */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7c891a8eb323..565910de92e9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12283,6 +12283,9 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * Do not allow to attach to a group in a different task
 		 * or CPU context. If we're moving SW events, we'll fix
 		 * this up later, so allow that.
+		 *
+		 * Racy, not holding group_leader->ctx->mutex, see comment with
+		 * perf_event_ctx_lock().
 		 */
 		if (!move_group && group_leader->ctx != ctx)
 			goto err_context;
@@ -12348,6 +12351,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			} else {
 				perf_event_ctx_unlock(group_leader, gctx);
 				move_group = 0;
+				goto not_move_group;
 			}
 		}
 
@@ -12364,7 +12368,17 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	} else {
 		mutex_lock(&ctx->mutex);
+
+		/*
+		 * Now that we hold ctx->lock, (re)validate group_leader->ctx == ctx,
+		 * see the group_leader && !move_group test earlier.
+		 */
+		if (group_leader && group_leader->ctx != ctx) {
+			err = -EINVAL;
+			goto err_locked;
+		}
 	}
+not_move_group:
 
 	if (ctx->task == TASK_TOMBSTONE) {
 		err = -ESRCH;
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 66076d8742b7..d25202766fbb 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -510,6 +510,7 @@ static bool __init kfence_init_pool(void)
 	unsigned long addr = (unsigned long)__kfence_pool;
 	struct page *pages;
 	int i;
+	char *p;
 
 	if (!__kfence_pool)
 		return false;
@@ -592,6 +593,16 @@ static bool __init kfence_init_pool(void)
 	 * fails for the first page, and therefore expect addr==__kfence_pool in
 	 * most failure cases.
 	 */
+	for (p = (char *)addr; p < __kfence_pool + KFENCE_POOL_SIZE; p += PAGE_SIZE) {
+		struct page *page = virt_to_page(p);
+
+		if (!PageSlab(page))
+			continue;
+#ifdef CONFIG_MEMCG
+		page->memcg_data = 0;
+#endif
+		__ClearPageSlab(page);
+	}
 	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
 	__kfence_pool = NULL;
 	return false;
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index b50382f957c1..6743c8a0fe8e 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -39,6 +39,13 @@ static int br_pass_frame_up(struct sk_buff *skb)
 	dev_sw_netstats_rx_add(brdev, skb->len);
 
 	vg = br_vlan_group_rcu(br);
+
+	/* Reset the offload_fwd_mark because there could be a stacked
+	 * bridge above, and it should not think this bridge it doing
+	 * that bridge's work forwarding out its ports.
+	 */
+	br_switchdev_frame_unmark(skb);
+
 	/* Bridge is just like any other port.  Make sure the
 	 * packet is allowed except in promisc mode when someone
 	 * may be running packet capture.
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ff8624a7c964..f6b7436458ae 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -537,43 +537,6 @@ static void request_init(struct ceph_osd_request *req)
 	target_init(&req->r_t);
 }
 
-/*
- * This is ugly, but it allows us to reuse linger registration and ping
- * requests, keeping the structure of the code around send_linger{_ping}()
- * reasonable.  Setting up a min_nr=2 mempool for each linger request
- * and dealing with copying ops (this blasts req only, watch op remains
- * intact) isn't any better.
- */
-static void request_reinit(struct ceph_osd_request *req)
-{
-	struct ceph_osd_client *osdc = req->r_osdc;
-	bool mempool = req->r_mempool;
-	unsigned int num_ops = req->r_num_ops;
-	u64 snapid = req->r_snapid;
-	struct ceph_snap_context *snapc = req->r_snapc;
-	bool linger = req->r_linger;
-	struct ceph_msg *request_msg = req->r_request;
-	struct ceph_msg *reply_msg = req->r_reply;
-
-	dout("%s req %p\n", __func__, req);
-	WARN_ON(kref_read(&req->r_kref) != 1);
-	request_release_checks(req);
-
-	WARN_ON(kref_read(&request_msg->kref) != 1);
-	WARN_ON(kref_read(&reply_msg->kref) != 1);
-	target_destroy(&req->r_t);
-
-	request_init(req);
-	req->r_osdc = osdc;
-	req->r_mempool = mempool;
-	req->r_num_ops = num_ops;
-	req->r_snapid = snapid;
-	req->r_snapc = snapc;
-	req->r_linger = linger;
-	req->r_request = request_msg;
-	req->r_reply = reply_msg;
-}
-
 struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 					       struct ceph_snap_context *snapc,
 					       unsigned int num_ops,
@@ -918,14 +881,30 @@ EXPORT_SYMBOL(osd_req_op_xattr_init);
  * @watch_opcode: CEPH_OSD_WATCH_OP_*
  */
 static void osd_req_op_watch_init(struct ceph_osd_request *req, int which,
-				  u64 cookie, u8 watch_opcode)
+				  u8 watch_opcode, u64 cookie, u32 gen)
 {
 	struct ceph_osd_req_op *op;
 
 	op = osd_req_op_init(req, which, CEPH_OSD_OP_WATCH, 0);
 	op->watch.cookie = cookie;
 	op->watch.op = watch_opcode;
-	op->watch.gen = 0;
+	op->watch.gen = gen;
+}
+
+/*
+ * prot_ver, timeout and notify payload (may be empty) should already be
+ * encoded in @request_pl
+ */
+static void osd_req_op_notify_init(struct ceph_osd_request *req, int which,
+				   u64 cookie, struct ceph_pagelist *request_pl)
+{
+	struct ceph_osd_req_op *op;
+
+	op = osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
+	op->notify.cookie = cookie;
+
+	ceph_osd_data_pagelist_init(&op->notify.request_data, request_pl);
+	op->indata_len = request_pl->length;
 }
 
 /*
@@ -2727,10 +2706,13 @@ static void linger_release(struct kref *kref)
 	WARN_ON(!list_empty(&lreq->pending_lworks));
 	WARN_ON(lreq->osd);
 
-	if (lreq->reg_req)
-		ceph_osdc_put_request(lreq->reg_req);
-	if (lreq->ping_req)
-		ceph_osdc_put_request(lreq->ping_req);
+	if (lreq->request_pl)
+		ceph_pagelist_release(lreq->request_pl);
+	if (lreq->notify_id_pages)
+		ceph_release_page_vector(lreq->notify_id_pages, 1);
+
+	ceph_osdc_put_request(lreq->reg_req);
+	ceph_osdc_put_request(lreq->ping_req);
 	target_destroy(&lreq->t);
 	kfree(lreq);
 }
@@ -2999,6 +2981,12 @@ static void linger_commit_cb(struct ceph_osd_request *req)
 	struct ceph_osd_linger_request *lreq = req->r_priv;
 
 	mutex_lock(&lreq->lock);
+	if (req != lreq->reg_req) {
+		dout("%s lreq %p linger_id %llu unknown req (%p != %p)\n",
+		     __func__, lreq, lreq->linger_id, req, lreq->reg_req);
+		goto out;
+	}
+
 	dout("%s lreq %p linger_id %llu result %d\n", __func__, lreq,
 	     lreq->linger_id, req->r_result);
 	linger_reg_commit_complete(lreq, req->r_result);
@@ -3022,6 +3010,7 @@ static void linger_commit_cb(struct ceph_osd_request *req)
 		}
 	}
 
+out:
 	mutex_unlock(&lreq->lock);
 	linger_put(lreq);
 }
@@ -3044,6 +3033,12 @@ static void linger_reconnect_cb(struct ceph_osd_request *req)
 	struct ceph_osd_linger_request *lreq = req->r_priv;
 
 	mutex_lock(&lreq->lock);
+	if (req != lreq->reg_req) {
+		dout("%s lreq %p linger_id %llu unknown req (%p != %p)\n",
+		     __func__, lreq, lreq->linger_id, req, lreq->reg_req);
+		goto out;
+	}
+
 	dout("%s lreq %p linger_id %llu result %d last_error %d\n", __func__,
 	     lreq, lreq->linger_id, req->r_result, lreq->last_error);
 	if (req->r_result < 0) {
@@ -3053,46 +3048,64 @@ static void linger_reconnect_cb(struct ceph_osd_request *req)
 		}
 	}
 
+out:
 	mutex_unlock(&lreq->lock);
 	linger_put(lreq);
 }
 
 static void send_linger(struct ceph_osd_linger_request *lreq)
 {
-	struct ceph_osd_request *req = lreq->reg_req;
-	struct ceph_osd_req_op *op = &req->r_ops[0];
+	struct ceph_osd_client *osdc = lreq->osdc;
+	struct ceph_osd_request *req;
+	int ret;
 
-	verify_osdc_wrlocked(req->r_osdc);
+	verify_osdc_wrlocked(osdc);
+	mutex_lock(&lreq->lock);
 	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
 
-	if (req->r_osd)
-		cancel_linger_request(req);
+	if (lreq->reg_req) {
+		if (lreq->reg_req->r_osd)
+			cancel_linger_request(lreq->reg_req);
+		ceph_osdc_put_request(lreq->reg_req);
+	}
+
+	req = ceph_osdc_alloc_request(osdc, NULL, 1, true, GFP_NOIO);
+	BUG_ON(!req);
 
-	request_reinit(req);
 	target_copy(&req->r_t, &lreq->t);
 	req->r_mtime = lreq->mtime;
 
-	mutex_lock(&lreq->lock);
 	if (lreq->is_watch && lreq->committed) {
-		WARN_ON(op->op != CEPH_OSD_OP_WATCH ||
-			op->watch.cookie != lreq->linger_id);
-		op->watch.op = CEPH_OSD_WATCH_OP_RECONNECT;
-		op->watch.gen = ++lreq->register_gen;
+		osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_RECONNECT,
+				      lreq->linger_id, ++lreq->register_gen);
 		dout("lreq %p reconnect register_gen %u\n", lreq,
-		     op->watch.gen);
+		     req->r_ops[0].watch.gen);
 		req->r_callback = linger_reconnect_cb;
 	} else {
-		if (!lreq->is_watch)
+		if (lreq->is_watch) {
+			osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_WATCH,
+					      lreq->linger_id, 0);
+		} else {
 			lreq->notify_id = 0;
-		else
-			WARN_ON(op->watch.op != CEPH_OSD_WATCH_OP_WATCH);
+
+			refcount_inc(&lreq->request_pl->refcnt);
+			osd_req_op_notify_init(req, 0, lreq->linger_id,
+					       lreq->request_pl);
+			ceph_osd_data_pages_init(
+			    osd_req_op_data(req, 0, notify, response_data),
+			    lreq->notify_id_pages, PAGE_SIZE, 0, false, false);
+		}
 		dout("lreq %p register\n", lreq);
 		req->r_callback = linger_commit_cb;
 	}
-	mutex_unlock(&lreq->lock);
+
+	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
+	BUG_ON(ret);
 
 	req->r_priv = linger_get(lreq);
 	req->r_linger = true;
+	lreq->reg_req = req;
+	mutex_unlock(&lreq->lock);
 
 	submit_request(req, true);
 }
@@ -3102,6 +3115,12 @@ static void linger_ping_cb(struct ceph_osd_request *req)
 	struct ceph_osd_linger_request *lreq = req->r_priv;
 
 	mutex_lock(&lreq->lock);
+	if (req != lreq->ping_req) {
+		dout("%s lreq %p linger_id %llu unknown req (%p != %p)\n",
+		     __func__, lreq, lreq->linger_id, req, lreq->ping_req);
+		goto out;
+	}
+
 	dout("%s lreq %p linger_id %llu result %d ping_sent %lu last_error %d\n",
 	     __func__, lreq, lreq->linger_id, req->r_result, lreq->ping_sent,
 	     lreq->last_error);
@@ -3117,6 +3136,7 @@ static void linger_ping_cb(struct ceph_osd_request *req)
 		     lreq->register_gen, req->r_ops[0].watch.gen);
 	}
 
+out:
 	mutex_unlock(&lreq->lock);
 	linger_put(lreq);
 }
@@ -3124,8 +3144,8 @@ static void linger_ping_cb(struct ceph_osd_request *req)
 static void send_linger_ping(struct ceph_osd_linger_request *lreq)
 {
 	struct ceph_osd_client *osdc = lreq->osdc;
-	struct ceph_osd_request *req = lreq->ping_req;
-	struct ceph_osd_req_op *op = &req->r_ops[0];
+	struct ceph_osd_request *req;
+	int ret;
 
 	if (ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD)) {
 		dout("%s PAUSERD\n", __func__);
@@ -3137,19 +3157,26 @@ static void send_linger_ping(struct ceph_osd_linger_request *lreq)
 	     __func__, lreq, lreq->linger_id, lreq->ping_sent,
 	     lreq->register_gen);
 
-	if (req->r_osd)
-		cancel_linger_request(req);
+	if (lreq->ping_req) {
+		if (lreq->ping_req->r_osd)
+			cancel_linger_request(lreq->ping_req);
+		ceph_osdc_put_request(lreq->ping_req);
+	}
 
-	request_reinit(req);
-	target_copy(&req->r_t, &lreq->t);
+	req = ceph_osdc_alloc_request(osdc, NULL, 1, true, GFP_NOIO);
+	BUG_ON(!req);
 
-	WARN_ON(op->op != CEPH_OSD_OP_WATCH ||
-		op->watch.cookie != lreq->linger_id ||
-		op->watch.op != CEPH_OSD_WATCH_OP_PING);
-	op->watch.gen = lreq->register_gen;
+	target_copy(&req->r_t, &lreq->t);
+	osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_PING, lreq->linger_id,
+			      lreq->register_gen);
 	req->r_callback = linger_ping_cb;
+
+	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
+	BUG_ON(ret);
+
 	req->r_priv = linger_get(lreq);
 	req->r_linger = true;
+	lreq->ping_req = req;
 
 	ceph_osdc_get_request(req);
 	account_request(req);
@@ -3165,12 +3192,6 @@ static void linger_submit(struct ceph_osd_linger_request *lreq)
 
 	down_write(&osdc->lock);
 	linger_register(lreq);
-	if (lreq->is_watch) {
-		lreq->reg_req->r_ops[0].watch.cookie = lreq->linger_id;
-		lreq->ping_req->r_ops[0].watch.cookie = lreq->linger_id;
-	} else {
-		lreq->reg_req->r_ops[0].notify.cookie = lreq->linger_id;
-	}
 
 	calc_target(osdc, &lreq->t, false);
 	osd = lookup_create_osd(osdc, lreq->t.osd, true);
@@ -3202,9 +3223,9 @@ static void cancel_linger_map_check(struct ceph_osd_linger_request *lreq)
  */
 static void __linger_cancel(struct ceph_osd_linger_request *lreq)
 {
-	if (lreq->is_watch && lreq->ping_req->r_osd)
+	if (lreq->ping_req && lreq->ping_req->r_osd)
 		cancel_linger_request(lreq->ping_req);
-	if (lreq->reg_req->r_osd)
+	if (lreq->reg_req && lreq->reg_req->r_osd)
 		cancel_linger_request(lreq->reg_req);
 	cancel_linger_map_check(lreq);
 	unlink_linger(lreq->osd, lreq);
@@ -4653,43 +4674,6 @@ void ceph_osdc_sync(struct ceph_osd_client *osdc)
 }
 EXPORT_SYMBOL(ceph_osdc_sync);
 
-static struct ceph_osd_request *
-alloc_linger_request(struct ceph_osd_linger_request *lreq)
-{
-	struct ceph_osd_request *req;
-
-	req = ceph_osdc_alloc_request(lreq->osdc, NULL, 1, false, GFP_NOIO);
-	if (!req)
-		return NULL;
-
-	ceph_oid_copy(&req->r_base_oid, &lreq->t.base_oid);
-	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
-	return req;
-}
-
-static struct ceph_osd_request *
-alloc_watch_request(struct ceph_osd_linger_request *lreq, u8 watch_opcode)
-{
-	struct ceph_osd_request *req;
-
-	req = alloc_linger_request(lreq);
-	if (!req)
-		return NULL;
-
-	/*
-	 * Pass 0 for cookie because we don't know it yet, it will be
-	 * filled in by linger_submit().
-	 */
-	osd_req_op_watch_init(req, 0, 0, watch_opcode);
-
-	if (ceph_osdc_alloc_messages(req, GFP_NOIO)) {
-		ceph_osdc_put_request(req);
-		return NULL;
-	}
-
-	return req;
-}
-
 /*
  * Returns a handle, caller owns a ref.
  */
@@ -4719,18 +4703,6 @@ ceph_osdc_watch(struct ceph_osd_client *osdc,
 	lreq->t.flags = CEPH_OSD_FLAG_WRITE;
 	ktime_get_real_ts64(&lreq->mtime);
 
-	lreq->reg_req = alloc_watch_request(lreq, CEPH_OSD_WATCH_OP_WATCH);
-	if (!lreq->reg_req) {
-		ret = -ENOMEM;
-		goto err_put_lreq;
-	}
-
-	lreq->ping_req = alloc_watch_request(lreq, CEPH_OSD_WATCH_OP_PING);
-	if (!lreq->ping_req) {
-		ret = -ENOMEM;
-		goto err_put_lreq;
-	}
-
 	linger_submit(lreq);
 	ret = linger_reg_commit_wait(lreq);
 	if (ret) {
@@ -4768,8 +4740,8 @@ int ceph_osdc_unwatch(struct ceph_osd_client *osdc,
 	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
 	req->r_flags = CEPH_OSD_FLAG_WRITE;
 	ktime_get_real_ts64(&req->r_mtime);
-	osd_req_op_watch_init(req, 0, lreq->linger_id,
-			      CEPH_OSD_WATCH_OP_UNWATCH);
+	osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_UNWATCH,
+			      lreq->linger_id, 0);
 
 	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
 	if (ret)
@@ -4855,35 +4827,6 @@ int ceph_osdc_notify_ack(struct ceph_osd_client *osdc,
 }
 EXPORT_SYMBOL(ceph_osdc_notify_ack);
 
-static int osd_req_op_notify_init(struct ceph_osd_request *req, int which,
-				  u64 cookie, u32 prot_ver, u32 timeout,
-				  void *payload, u32 payload_len)
-{
-	struct ceph_osd_req_op *op;
-	struct ceph_pagelist *pl;
-	int ret;
-
-	op = osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
-	op->notify.cookie = cookie;
-
-	pl = ceph_pagelist_alloc(GFP_NOIO);
-	if (!pl)
-		return -ENOMEM;
-
-	ret = ceph_pagelist_encode_32(pl, 1); /* prot_ver */
-	ret |= ceph_pagelist_encode_32(pl, timeout);
-	ret |= ceph_pagelist_encode_32(pl, payload_len);
-	ret |= ceph_pagelist_append(pl, payload, payload_len);
-	if (ret) {
-		ceph_pagelist_release(pl);
-		return -ENOMEM;
-	}
-
-	ceph_osd_data_pagelist_init(&op->notify.request_data, pl);
-	op->indata_len = pl->length;
-	return 0;
-}
-
 /*
  * @timeout: in seconds
  *
@@ -4902,7 +4845,6 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 		     size_t *preply_len)
 {
 	struct ceph_osd_linger_request *lreq;
-	struct page **pages;
 	int ret;
 
 	WARN_ON(!timeout);
@@ -4915,41 +4857,35 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 	if (!lreq)
 		return -ENOMEM;
 
-	lreq->preply_pages = preply_pages;
-	lreq->preply_len = preply_len;
-
-	ceph_oid_copy(&lreq->t.base_oid, oid);
-	ceph_oloc_copy(&lreq->t.base_oloc, oloc);
-	lreq->t.flags = CEPH_OSD_FLAG_READ;
-
-	lreq->reg_req = alloc_linger_request(lreq);
-	if (!lreq->reg_req) {
+	lreq->request_pl = ceph_pagelist_alloc(GFP_NOIO);
+	if (!lreq->request_pl) {
 		ret = -ENOMEM;
 		goto out_put_lreq;
 	}
 
-	/*
-	 * Pass 0 for cookie because we don't know it yet, it will be
-	 * filled in by linger_submit().
-	 */
-	ret = osd_req_op_notify_init(lreq->reg_req, 0, 0, 1, timeout,
-				     payload, payload_len);
-	if (ret)
+	ret = ceph_pagelist_encode_32(lreq->request_pl, 1); /* prot_ver */
+	ret |= ceph_pagelist_encode_32(lreq->request_pl, timeout);
+	ret |= ceph_pagelist_encode_32(lreq->request_pl, payload_len);
+	ret |= ceph_pagelist_append(lreq->request_pl, payload, payload_len);
+	if (ret) {
+		ret = -ENOMEM;
 		goto out_put_lreq;
+	}
 
 	/* for notify_id */
-	pages = ceph_alloc_page_vector(1, GFP_NOIO);
-	if (IS_ERR(pages)) {
-		ret = PTR_ERR(pages);
+	lreq->notify_id_pages = ceph_alloc_page_vector(1, GFP_NOIO);
+	if (IS_ERR(lreq->notify_id_pages)) {
+		ret = PTR_ERR(lreq->notify_id_pages);
+		lreq->notify_id_pages = NULL;
 		goto out_put_lreq;
 	}
-	ceph_osd_data_pages_init(osd_req_op_data(lreq->reg_req, 0, notify,
-						 response_data),
-				 pages, PAGE_SIZE, 0, false, true);
 
-	ret = ceph_osdc_alloc_messages(lreq->reg_req, GFP_NOIO);
-	if (ret)
-		goto out_put_lreq;
+	lreq->preply_pages = preply_pages;
+	lreq->preply_len = preply_len;
+
+	ceph_oid_copy(&lreq->t.base_oid, oid);
+	ceph_oloc_copy(&lreq->t.base_oloc, oloc);
+	lreq->t.flags = CEPH_OSD_FLAG_READ;
 
 	linger_submit(lreq);
 	ret = linger_reg_commit_wait(lreq);
diff --git a/net/core/dev.c b/net/core/dev.c
index 804aba2228c2..5907212c00f3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -741,11 +741,11 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 	const struct net_device *last_dev;
 	struct net_device_path_ctx ctx = {
 		.dev	= dev,
-		.daddr	= daddr,
 	};
 	struct net_device_path *path;
 	int ret = 0;
 
+	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
 	stack->num_paths = 0;
 	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
 		last_dev = ctx.dev;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e4badc189e37..7ef0f5a8ab03 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3873,7 +3873,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 	unsigned int delta_len = 0;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *nskb, *tmp;
-	int err;
+	int len_diff, err;
 
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
@@ -3913,9 +3913,11 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 
 		skb_release_head_state(nskb);
+		len_diff = skb_network_header_len(nskb) - skb_network_header_len(skb);
 		__copy_skb_header(nskb, skb);
 
 		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
+		nskb->transport_header += len_diff;
 		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
 						 nskb->data - tnl_hlen,
 						 offset + tnl_hlen);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6e8020a3bd67..1db2fda22830 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1727,6 +1727,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	unsigned int flags = RTCF_MULTICAST;
 	struct rtable *rth;
+	bool no_policy;
 	u32 itag = 0;
 	int err;
 
@@ -1737,8 +1738,12 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (our)
 		flags |= RTCF_LOCAL;
 
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	rth = rt_dst_alloc(dev_net(dev)->loopback_dev, flags, RTN_MULTICAST,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
+			   no_policy, false);
 	if (!rth)
 		return -ENOBUFS;
 
@@ -1797,7 +1802,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	struct rtable *rth;
 	int err;
 	struct in_device *out_dev;
-	bool do_cache;
+	bool do_cache, no_policy;
 	u32 itag = 0;
 
 	/* get a working reference to the output device */
@@ -1842,6 +1847,10 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	fnhe = find_exception(nhc, daddr);
 	if (do_cache) {
 		if (fnhe)
@@ -1854,8 +1863,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
-	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY),
+	rth = rt_dst_alloc(out_dev->dev, 0, res->type, no_policy,
 			   IN_DEV_ORCONF(out_dev, NOXFRM));
 	if (!rth) {
 		err = -ENOBUFS;
@@ -2230,6 +2238,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct rtable	*rth;
 	struct flowi4	fl4;
 	bool do_cache = true;
+	bool no_policy;
 
 	/* IP on this device is disabled. */
 
@@ -2347,6 +2356,10 @@ out:	return err;
 	RT_CACHE_STAT_INC(in_brd);
 
 local_input:
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	do_cache &= res->fi && !itag;
 	if (do_cache) {
 		struct fib_nh_common *nhc = FIB_RES_NHC(*res);
@@ -2361,7 +2374,7 @@ out:	return err;
 
 	rth = rt_dst_alloc(ip_rt_get_dev(net, res),
 			   flags | RTCF_LOCAL, res->type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
+			   no_policy, false);
 	if (!rth)
 		goto e_nobufs;
 
diff --git a/net/key/af_key.c b/net/key/af_key.c
index fd51db3be91c..92e9d75dba2f 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2826,8 +2826,10 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
 	void *ext_hdrs[SADB_EXT_MAX];
 	int err;
 
-	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
-			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
+	err = pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
+			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
+	if (err)
+		return err;
 
 	memset(ext_hdrs, 0, sizeof(ext_hdrs));
 	err = parse_exthdrs(skb, hdr, ext_hdrs);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index eab6283b3479..743e97ba352c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1400,8 +1400,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 		goto dont_reorder;
 
 	/* not part of a BA session */
-	if (ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK &&
-	    ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)
+	if (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
 		goto dont_reorder;
 
 	/* new, potentially un-ordered, ampdu frame - process it */
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index e515ba9ccb5d..193f0fcce8d8 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -107,7 +107,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			ptr += 2;
 		}
 		if (opsize == TCPOLEN_MPTCP_MPC_ACK_DATA_CSUM) {
-			mp_opt->csum = (__force __sum16)get_unaligned_be16(ptr);
+			mp_opt->csum = get_unaligned((__force __sum16 *)ptr);
 			mp_opt->suboptions |= OPTION_MPTCP_CSUMREQD;
 			ptr += 2;
 		}
@@ -221,7 +221,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 
 			if (opsize == expected_opsize + TCPOLEN_MPTCP_DSS_CHECKSUM) {
 				mp_opt->suboptions |= OPTION_MPTCP_CSUMREQD;
-				mp_opt->csum = (__force __sum16)get_unaligned_be16(ptr);
+				mp_opt->csum = get_unaligned((__force __sum16 *)ptr);
 				ptr += 2;
 			}
 
@@ -1214,7 +1214,7 @@ static void mptcp_set_rwin(const struct tcp_sock *tp)
 		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
 }
 
-static u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __sum16 sum)
+__sum16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum)
 {
 	struct csum_pseudo_header header;
 	__wsum csum;
@@ -1229,14 +1229,24 @@ static u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __sum1
 	header.data_len = htons(data_len);
 	header.csum = 0;
 
-	csum = csum_partial(&header, sizeof(header), ~csum_unfold(sum));
-	return (__force u16)csum_fold(csum);
+	csum = csum_partial(&header, sizeof(header), sum);
+	return csum_fold(csum);
 }
 
-static u16 mptcp_make_csum(const struct mptcp_ext *mpext)
+static __sum16 mptcp_make_csum(const struct mptcp_ext *mpext)
 {
 	return __mptcp_make_csum(mpext->data_seq, mpext->subflow_seq, mpext->data_len,
-				 mpext->csum);
+				 ~csum_unfold(mpext->csum));
+}
+
+static void put_len_csum(u16 len, __sum16 csum, void *data)
+{
+	__sum16 *sumptr = data + 2;
+	__be16 *ptr = data;
+
+	put_unaligned_be16(len, ptr);
+
+	put_unaligned(csum, sumptr);
 }
 
 void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
@@ -1315,8 +1325,9 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			put_unaligned_be32(mpext->subflow_seq, ptr);
 			ptr += 1;
 			if (opts->csum_reqd) {
-				put_unaligned_be32(mpext->data_len << 16 |
-						   mptcp_make_csum(mpext), ptr);
+				put_len_csum(mpext->data_len,
+					     mptcp_make_csum(mpext),
+					     ptr);
 			} else {
 				put_unaligned_be32(mpext->data_len << 16 |
 						   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
@@ -1364,11 +1375,12 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			goto mp_capable_done;
 
 		if (opts->csum_reqd) {
-			put_unaligned_be32(opts->data_len << 16 |
-					   __mptcp_make_csum(opts->data_seq,
-							     opts->subflow_seq,
-							     opts->data_len,
-							     opts->csum), ptr);
+			put_len_csum(opts->data_len,
+				     __mptcp_make_csum(opts->data_seq,
+						       opts->subflow_seq,
+						       opts->data_len,
+						       ~csum_unfold(opts->csum)),
+				     ptr);
 		} else {
 			put_unaligned_be32(opts->data_len << 16 |
 					   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 82c5dc4d6b49..72a259a74b57 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -718,6 +718,7 @@ void mptcp_token_destroy(struct mptcp_sock *msk);
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
 
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
+__sum16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum);
 
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6172f380dfb7..9c7deffe7cb6 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -845,9 +845,8 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 					      bool csum_reqd)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
-	struct csum_pseudo_header header;
 	u32 offset, seq, delta;
-	__wsum csum;
+	__sum16 csum;
 	int len;
 
 	if (!csum_reqd)
@@ -908,13 +907,11 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 	 * while the pseudo header requires the original DSS data len,
 	 * including that
 	 */
-	header.data_seq = cpu_to_be64(subflow->map_seq);
-	header.subflow_seq = htonl(subflow->map_subflow_seq);
-	header.data_len = htons(subflow->map_data_len + subflow->map_data_fin);
-	header.csum = 0;
-
-	csum = csum_partial(&header, sizeof(header), subflow->map_data_csum);
-	if (unlikely(csum_fold(csum))) {
+	csum = __mptcp_make_csum(subflow->map_seq,
+				 subflow->map_subflow_seq,
+				 subflow->map_data_len + subflow->map_data_fin,
+				 subflow->map_data_csum);
+	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
 		subflow->send_mp_fail = 1;
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b90eca7a2f22..9fb407084c50 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -173,12 +173,11 @@ EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
 static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 {
-	tcp->state = TCP_CONNTRACK_ESTABLISHED;
 	tcp->seen[0].td_maxwin = 0;
 	tcp->seen[1].td_maxwin = 0;
 }
 
-static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
+static void flow_offload_fixup_ct(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
@@ -187,7 +186,9 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
 
-		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
+		flow_offload_fixup_tcp(&ct->proto.tcp);
+
+		timeout = tn->timeouts[ct->proto.tcp.state];
 		timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
@@ -205,18 +206,6 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
 }
 
-static void flow_offload_fixup_ct_state(struct nf_conn *ct)
-{
-	if (nf_ct_protonum(ct) == IPPROTO_TCP)
-		flow_offload_fixup_tcp(&ct->proto.tcp);
-}
-
-static void flow_offload_fixup_ct(struct nf_conn *ct)
-{
-	flow_offload_fixup_ct_state(ct);
-	flow_offload_fixup_ct_timeout(ct);
-}
-
 static void flow_offload_route_release(struct flow_offload *flow)
 {
 	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
@@ -329,8 +318,10 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	u32 timeout;
 
 	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
-	if (READ_ONCE(flow->timeout) != timeout)
+	if (timeout - READ_ONCE(flow->timeout) > HZ)
 		WRITE_ONCE(flow->timeout, timeout);
+	else
+		return;
 
 	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
@@ -353,22 +344,14 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
-
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-
-	if (nf_flow_has_expired(flow))
-		flow_offload_fixup_ct(flow->ct);
-	else
-		flow_offload_fixup_ct_timeout(flow->ct);
-
 	flow_offload_free(flow);
 }
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
+	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-
-	flow_offload_fixup_ct_state(flow->ct);
+	flow_offload_fixup_ct(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -399,7 +382,8 @@ EXPORT_SYMBOL_GPL(flow_offload_lookup);
 
 static int
 nf_flow_table_iterate(struct nf_flowtable *flow_table,
-		      void (*iter)(struct flow_offload *flow, void *data),
+		      void (*iter)(struct nf_flowtable *flowtable,
+				   struct flow_offload *flow, void *data),
 		      void *data)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
@@ -423,7 +407,7 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
-		iter(flow, data);
+		iter(flow_table, flow, data);
 	}
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
@@ -431,34 +415,12 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 	return err;
 }
 
-static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
+static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
+				    struct flow_offload *flow, void *data)
 {
-	struct dst_entry *dst;
-
-	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
-	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
-		dst = tuple->dst_cache;
-		if (!dst_check(dst, tuple->dst_cookie))
-			return true;
-	}
-
-	return false;
-}
-
-static bool nf_flow_has_stale_dst(struct flow_offload *flow)
-{
-	return flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
-	       flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple);
-}
-
-static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
-{
-	struct nf_flowtable *flow_table = data;
-
 	if (nf_flow_has_expired(flow) ||
-	    nf_ct_is_dying(flow->ct) ||
-	    nf_flow_has_stale_dst(flow))
-		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
+	    nf_ct_is_dying(flow->ct))
+		flow_offload_teardown(flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
@@ -479,7 +441,7 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
 	struct nf_flowtable *flow_table;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
@@ -595,7 +557,8 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_init);
 
-static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
+static void nf_flow_table_do_cleanup(struct nf_flowtable *flow_table,
+				     struct flow_offload *flow, void *data)
 {
 	struct net_device *dev = data;
 
@@ -637,11 +600,10 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	nf_flow_table_offload_flush(flow_table);
 	if (nf_flowtable_hw_offload(flow_table))
-		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step,
-				      flow_table);
+		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 6257d87c3a56..28026467b54c 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -227,6 +227,15 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
+static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
+{
+	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
+	    tuple->xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
+		return true;
+
+	return dst_check(tuple->dst_cache, tuple->dst_cookie);
+}
+
 static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      const struct nf_hook_state *state,
 				      struct dst_entry *dst)
@@ -346,6 +355,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
+	if (!nf_flow_dst_check(&tuplehash->tuple)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
@@ -582,6 +596,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
 		return NF_ACCEPT;
 
+	if (!nf_flow_dst_check(&tuplehash->tuple)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 0af34ad41479..aac6db8680d4 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -36,6 +36,15 @@ static void nft_default_forward_path(struct nf_flow_route *route,
 	route->tuple[dir].xmit_type	= nft_xmit_type(dst_cache);
 }
 
+static bool nft_is_valid_ether_device(const struct net_device *dev)
+{
+	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
+	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
+		return false;
+
+	return true;
+}
+
 static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 				     const struct dst_entry *dst_cache,
 				     const struct nf_conn *ct,
@@ -47,6 +56,9 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 	struct neighbour *n;
 	u8 nud_state;
 
+	if (!nft_is_valid_ether_device(dev))
+		goto out;
+
 	n = dst_neigh_lookup(dst_cache, daddr);
 	if (!n)
 		return -1;
@@ -60,6 +72,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 	if (!(nud_state & NUD_VALID))
 		return -1;
 
+out:
 	return dev_fill_forward_path(dev, ha, stack);
 }
 
@@ -78,15 +91,6 @@ struct nft_forward_info {
 	enum flow_offload_xmit_type xmit_type;
 };
 
-static bool nft_is_valid_ether_device(const struct net_device *dev)
-{
-	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
-	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
-		return false;
-
-	return true;
-}
-
 static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			      struct nft_forward_info *info,
 			      unsigned char *ha, struct nf_flowtable *flowtable)
@@ -119,7 +123,8 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->indev = NULL;
 				break;
 			}
-			info->outdev = path->dev;
+			if (!info->outdev)
+				info->outdev = path->dev;
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
@@ -293,7 +298,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	case IPPROTO_TCP:
 		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
 					  sizeof(_tcph), &_tcph);
-		if (unlikely(!tcph || tcph->fin || tcph->rst))
+		if (unlikely(!tcph || tcph->fin || tcph->rst ||
+			     !nf_conntrack_tcp_established(ct)))
 			goto out;
 		break;
 	case IPPROTO_UDP:
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 6055dc9a82aa..aa5e712adf07 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -118,7 +118,7 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 
 		skb_frag = nci_skb_alloc(ndev,
 					 (NCI_DATA_HDR_SIZE + frag_len),
-					 GFP_KERNEL);
+					 GFP_ATOMIC);
 		if (skb_frag == NULL) {
 			rc = -ENOMEM;
 			goto free_exit;
diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index e199912ee1e5..85b808fdcbc3 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -153,7 +153,7 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 
 	i = 0;
 	skb = nci_skb_alloc(ndev, conn_info->max_pkt_payload_len +
-			    NCI_DATA_HDR_SIZE, GFP_KERNEL);
+			    NCI_DATA_HDR_SIZE, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -184,7 +184,7 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 		if (i < data_len) {
 			skb = nci_skb_alloc(ndev,
 					    conn_info->max_pkt_payload_len +
-					    NCI_DATA_HDR_SIZE, GFP_KERNEL);
+					    NCI_DATA_HDR_SIZE, GFP_ATOMIC);
 			if (!skb)
 				return -ENOMEM;
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index cfadd613644a..1262a84b725f 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -232,6 +232,10 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	for (i = 0; i < p->tcfp_nkeys; ++i) {
 		u32 cur = p->tcfp_keys[i].off;
 
+		/* sanitize the shift value for any later use */
+		p->tcfp_keys[i].shift = min_t(size_t, BITS_PER_TYPE(int) - 1,
+					      p->tcfp_keys[i].shift);
+
 		/* The AT option can read a single byte, we can bound the actual
 		 * value with uchar max.
 		 */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fe9cade6b4fb..7c65ad17bf50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3080,6 +3080,15 @@ int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	} else if (attrs[NL80211_ATTR_CHANNEL_WIDTH]) {
 		chandef->width =
 			nla_get_u32(attrs[NL80211_ATTR_CHANNEL_WIDTH]);
+		if (chandef->chan->band == NL80211_BAND_S1GHZ) {
+			/* User input error for channel width doesn't match channel  */
+			if (chandef->width != ieee80211_s1g_channel_width(chandef->chan)) {
+				NL_SET_ERR_MSG_ATTR(extack,
+						    attrs[NL80211_ATTR_CHANNEL_WIDTH],
+						    "bad channel width");
+				return -EINVAL;
+			}
+		}
 		if (attrs[NL80211_ATTR_CENTER_FREQ1]) {
 			chandef->center_freq1 =
 				nla_get_u32(attrs[NL80211_ATTR_CENTER_FREQ1]);
@@ -11332,18 +11341,23 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	struct cfg80211_bitrate_mask mask;
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	if (!rdev->ops->set_bitrate_mask)
 		return -EOPNOTSUPP;
 
+	wdev_lock(wdev);
 	err = nl80211_parse_tx_bitrate_mask(info, info->attrs,
 					    NL80211_ATTR_TX_RATES, &mask,
 					    dev, true);
 	if (err)
-		return err;
+		goto out;
 
-	return rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
+	err = rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
+out:
+	wdev_unlock(wdev);
+	return err;
 }
 
 static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 02099d113a0a..a6271b955e11 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3160,7 +3160,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 
 nopol:
 	if (!(dst_orig->dev->flags & IFF_LOOPBACK) &&
-	    !xfrm_default_allow(net, dir)) {
+	    net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
 		err = -EPERM;
 		goto error;
 	}
@@ -3572,7 +3572,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	}
 
 	if (!pol) {
-		if (!xfrm_default_allow(net, dir)) {
+		if (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOPOLS);
 			return 0;
 		}
@@ -3632,7 +3632,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 		xfrm_nr = ti;
 
-		if (!xfrm_default_allow(net, dir) && !xfrm_nr) {
+		if (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK &&
+		    !xfrm_nr) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOSTATES);
 			goto reject;
 		}
@@ -4121,6 +4122,9 @@ static int __net_init xfrm_net_init(struct net *net)
 	spin_lock_init(&net->xfrm.xfrm_policy_lock);
 	seqcount_spinlock_init(&net->xfrm.xfrm_policy_hash_generation, &net->xfrm.xfrm_policy_lock);
 	mutex_init(&net->xfrm.xfrm_cfg_mutex);
+	net->xfrm.policy_default[XFRM_POLICY_IN] = XFRM_USERPOLICY_ACCEPT;
+	net->xfrm.policy_default[XFRM_POLICY_FWD] = XFRM_USERPOLICY_ACCEPT;
+	net->xfrm.policy_default[XFRM_POLICY_OUT] = XFRM_USERPOLICY_ACCEPT;
 
 	rv = xfrm_statistics_init(net);
 	if (rv < 0)
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 2acba159327c..5fba82757ce5 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1993,12 +1993,9 @@ static int xfrm_notify_userpolicy(struct net *net)
 	}
 
 	up = nlmsg_data(nlh);
-	up->in = net->xfrm.policy_default & XFRM_POL_DEFAULT_IN ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
-	up->fwd = net->xfrm.policy_default & XFRM_POL_DEFAULT_FWD ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
-	up->out = net->xfrm.policy_default & XFRM_POL_DEFAULT_OUT ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
+	up->in = net->xfrm.policy_default[XFRM_POLICY_IN];
+	up->fwd = net->xfrm.policy_default[XFRM_POLICY_FWD];
+	up->out = net->xfrm.policy_default[XFRM_POLICY_OUT];
 
 	nlmsg_end(skb, nlh);
 
@@ -2009,26 +2006,26 @@ static int xfrm_notify_userpolicy(struct net *net)
 	return err;
 }
 
+static bool xfrm_userpolicy_is_valid(__u8 policy)
+{
+	return policy == XFRM_USERPOLICY_BLOCK ||
+	       policy == XFRM_USERPOLICY_ACCEPT;
+}
+
 static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 			    struct nlattr **attrs)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
 
-	if (up->in == XFRM_USERPOLICY_BLOCK)
-		net->xfrm.policy_default |= XFRM_POL_DEFAULT_IN;
-	else if (up->in == XFRM_USERPOLICY_ACCEPT)
-		net->xfrm.policy_default &= ~XFRM_POL_DEFAULT_IN;
+	if (xfrm_userpolicy_is_valid(up->in))
+		net->xfrm.policy_default[XFRM_POLICY_IN] = up->in;
 
-	if (up->fwd == XFRM_USERPOLICY_BLOCK)
-		net->xfrm.policy_default |= XFRM_POL_DEFAULT_FWD;
-	else if (up->fwd == XFRM_USERPOLICY_ACCEPT)
-		net->xfrm.policy_default &= ~XFRM_POL_DEFAULT_FWD;
+	if (xfrm_userpolicy_is_valid(up->fwd))
+		net->xfrm.policy_default[XFRM_POLICY_FWD] = up->fwd;
 
-	if (up->out == XFRM_USERPOLICY_BLOCK)
-		net->xfrm.policy_default |= XFRM_POL_DEFAULT_OUT;
-	else if (up->out == XFRM_USERPOLICY_ACCEPT)
-		net->xfrm.policy_default &= ~XFRM_POL_DEFAULT_OUT;
+	if (xfrm_userpolicy_is_valid(up->out))
+		net->xfrm.policy_default[XFRM_POLICY_OUT] = up->out;
 
 	rt_genid_bump_all(net);
 
@@ -2058,13 +2055,9 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	r_up = nlmsg_data(r_nlh);
-
-	r_up->in = net->xfrm.policy_default & XFRM_POL_DEFAULT_IN ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
-	r_up->fwd = net->xfrm.policy_default & XFRM_POL_DEFAULT_FWD ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
-	r_up->out = net->xfrm.policy_default & XFRM_POL_DEFAULT_OUT ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
+	r_up->in = net->xfrm.policy_default[XFRM_POLICY_IN];
+	r_up->fwd = net->xfrm.policy_default[XFRM_POLICY_FWD];
+	r_up->out = net->xfrm.policy_default[XFRM_POLICY_OUT];
 	nlmsg_end(r_skb, r_nlh);
 
 	return nlmsg_unicast(net->xfrm.nlsk, r_skb, portid);
diff --git a/security/security.c b/security/security.c
index da631339e969..7b9f9d3fffe5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -59,10 +59,12 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_DEBUGFS] = "debugfs access",
 	[LOCKDOWN_XMON_WR] = "xmon write access",
 	[LOCKDOWN_BPF_WRITE_USER] = "use of bpf to write user RAM",
+	[LOCKDOWN_DBG_WRITE_KERNEL] = "use of kgdb/kdb to write kernel RAM",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
 	[LOCKDOWN_BPF_READ_KERNEL] = "use of bpf to read kernel RAM",
+	[LOCKDOWN_DBG_READ_KERNEL] = "use of kgdb/kdb to read kernel RAM",
 	[LOCKDOWN_PERF] = "unsafe use of perf",
 	[LOCKDOWN_TRACEFS] = "use of tracefs",
 	[LOCKDOWN_XMON_RW] = "xmon read and write access",
diff --git a/security/selinux/ss/hashtab.c b/security/selinux/ss/hashtab.c
index a91fb0ed00de..298098bb9c06 100644
--- a/security/selinux/ss/hashtab.c
+++ b/security/selinux/ss/hashtab.c
@@ -178,7 +178,8 @@ int hashtab_duplicate(struct hashtab *new, struct hashtab *orig,
 			kmem_cache_free(hashtab_node_cachep, cur);
 		}
 	}
-	kmem_cache_free(hashtab_node_cachep, new);
+	kfree(new->htable);
+	memset(new, 0, sizeof(*new));
 	return -ENOMEM;
 }
 
diff --git a/sound/isa/wavefront/wavefront_synth.c b/sound/isa/wavefront/wavefront_synth.c
index 69cbc79fbb71..2aaaa6807174 100644
--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -1094,7 +1094,8 @@ wavefront_send_sample (snd_wavefront_t *dev,
 
 			if (dataptr < data_end) {
 		
-				__get_user (sample_short, dataptr);
+				if (get_user(sample_short, dataptr))
+					return -EFAULT;
 				dataptr += skip;
 		
 				if (data_is_unsigned) { /* GUS ? */
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 30295283512c..040825ea9a08 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -932,6 +932,9 @@ static int alc_init(struct hda_codec *codec)
 	return 0;
 }
 
+#define alc_free	snd_hda_gen_free
+
+#ifdef CONFIG_PM
 static inline void alc_shutup(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -945,9 +948,6 @@ static inline void alc_shutup(struct hda_codec *codec)
 		alc_shutup_pins(codec);
 }
 
-#define alc_free	snd_hda_gen_free
-
-#ifdef CONFIG_PM
 static void alc_power_eapd(struct hda_codec *codec)
 {
 	alc_auto_setup_eapd(codec, false);
@@ -961,9 +961,7 @@ static int alc_suspend(struct hda_codec *codec)
 		spec->power_hook(codec);
 	return 0;
 }
-#endif
 
-#ifdef CONFIG_PM
 static int alc_resume(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -9076,6 +9074,14 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
 	SND_PCI_QUIRK(0x1d05, 0x1132, "TongFang PHxTxX1", ALC256_FIXUP_SET_COEF_DEFAULTS),
+	SND_PCI_QUIRK(0x1d05, 0x1096, "TongFang GMxMRxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x1100, "TongFang GKxNRxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x1111, "TongFang GMxZGxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x1119, "TongFang GMxZGxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x1129, "TongFang GMxZGxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x1147, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
@@ -10946,6 +10952,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
+	SND_PCI_QUIRK(0x17aa, 0x1057, "Lenovo P360", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32ca, "Lenovo ThinkCentre M80", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cb, "Lenovo ThinkCentre M70", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cf, "Lenovo ThinkCentre M950", ALC897_FIXUP_HEADSET_MIC_PIN),
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 0ea39565e623..40a5e3eb4ef2 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3235,6 +3235,15 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/* Rane SL-1 */
+{
+	USB_DEVICE(0x13e5, 0x0001),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_AUDIO_STANDARD_INTERFACE
+        }
+},
+
 /* disabled due to regression for other devices;
  * see https://bugzilla.kernel.org/show_bug.cgi?id=199905
  */
diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 88dd7db55d38..6abde487bba1 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -97,6 +97,7 @@ FEATURE_TESTS_EXTRA :=                  \
          llvm-version                   \
          clang                          \
          libbpf                         \
+         libbpf-btf__load_from_kernel_by_id \
          libpfm4                        \
          libdebuginfod			\
          clang-bpf-co-re
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 0e6d685b8617..69a43d9ea331 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -56,6 +56,7 @@ FILES=                                          \
          test-lzma.bin                          \
          test-bpf.bin                           \
          test-libbpf.bin                        \
+         test-libbpf-btf__load_from_kernel_by_id.bin	\
          test-get_cpuid.bin                     \
          test-sdt.bin                           \
          test-cxx.bin                           \
@@ -283,6 +284,9 @@ $(OUTPUT)test-bpf.bin:
 $(OUTPUT)test-libbpf.bin:
 	$(BUILD) -lbpf
 
+$(OUTPUT)test-libbpf-btf__load_from_kernel_by_id.bin:
+	$(BUILD) -lbpf
+
 $(OUTPUT)test-sdt.bin:
 	$(BUILD)
 
diff --git a/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c b/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c
new file mode 100644
index 000000000000..f7c084428735
--- /dev/null
+++ b/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <bpf/libbpf.h>
+
+int main(void)
+{
+	return btf__load_from_kernel_by_id(20151128, NULL);
+}
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index a92f0f025ec7..e0660bc76b7b 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -548,9 +548,16 @@ ifndef NO_LIBELF
         ifeq ($(feature-libbpf), 1)
           EXTLIBS += -lbpf
           $(call detected,CONFIG_LIBBPF_DYNAMIC)
+
+          $(call feature_check,libbpf-btf__load_from_kernel_by_id)
+          ifeq ($(feature-libbpf-btf__load_from_kernel_by_id), 1)
+            CFLAGS += -DHAVE_LIBBPF_BTF__LOAD_FROM_KERNEL_BY_ID
+          endif
         else
           dummy := $(error Error: No libbpf devel library found, please install libbpf-devel);
         endif
+      else
+	CFLAGS += -DHAVE_LIBBPF_BTF__LOAD_FROM_KERNEL_BY_ID
       endif
     endif
 
diff --git a/tools/perf/arch/x86/util/perf_regs.c b/tools/perf/arch/x86/util/perf_regs.c
index 207c56805c55..0ed177991ad0 100644
--- a/tools/perf/arch/x86/util/perf_regs.c
+++ b/tools/perf/arch/x86/util/perf_regs.c
@@ -9,6 +9,8 @@
 #include "../../../util/perf_regs.h"
 #include "../../../util/debug.h"
 #include "../../../util/event.h"
+#include "../../../util/pmu.h"
+#include "../../../util/pmu-hybrid.h"
 
 const struct sample_reg sample_reg_masks[] = {
 	SMPL_REG(AX, PERF_REG_X86_AX),
@@ -284,12 +286,22 @@ uint64_t arch__intr_reg_mask(void)
 		.disabled 		= 1,
 		.exclude_kernel		= 1,
 	};
+	struct perf_pmu *pmu;
 	int fd;
 	/*
 	 * In an unnamed union, init it here to build on older gcc versions
 	 */
 	attr.sample_period = 1;
 
+	if (perf_pmu__has_hybrid()) {
+		/*
+		 * The same register set is supported among different hybrid PMUs.
+		 * Only check the first available one.
+		 */
+		pmu = list_first_entry(&perf_pmu__hybrid_pmus, typeof(*pmu), hybrid_list);
+		attr.config |= (__u64)pmu->type << PERF_PMU_TYPE_SHIFT;
+	}
+
 	event_attr_init(&attr);
 
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index f2640179ada9..c2c81567afa5 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1672,7 +1672,7 @@ static int __bench_numa(const char *name)
 		"GB/sec,", "total-speed",	"GB/sec total speed");
 
 	if (g->p.show_details >= 2) {
-		char tname[14 + 2 * 10 + 1];
+		char tname[14 + 2 * 11 + 1];
 		struct thread_data *td;
 		for (p = 0; p < g->p.nr_proc; p++) {
 			for (t = 0; t < g->p.nr_threads; t++) {
diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 16ad0e6e9e9c..cf1b9f6ec0db 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -21,7 +21,8 @@
 #include "record.h"
 #include "util/synthetic-events.h"
 
-struct btf * __weak btf__load_from_kernel_by_id(__u32 id)
+#ifndef HAVE_LIBBPF_BTF__LOAD_FROM_KERNEL_BY_ID
+struct btf *btf__load_from_kernel_by_id(__u32 id)
 {
        struct btf *btf;
 #pragma GCC diagnostic push
@@ -31,6 +32,7 @@ struct btf * __weak btf__load_from_kernel_by_id(__u32 id)
 
        return err ? ERR_PTR(err) : btf;
 }
+#endif
 
 #define ptr_to_u64(ptr)    ((__u64)(unsigned long)(ptr))
 
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index aec9e784d0b4..91f54112167f 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -803,10 +803,16 @@ ipv4_ping()
 	setup
 	set_sysctl net.ipv4.raw_l3mdev_accept=1 2>/dev/null
 	ipv4_ping_novrf
+	setup
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv4_ping_novrf
 
 	log_subsection "With VRF"
 	setup "yes"
 	ipv4_ping_vrf
+	setup "yes"
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv4_ping_vrf
 }
 
 ################################################################################
@@ -2324,10 +2330,16 @@ ipv6_ping()
 	log_subsection "No VRF"
 	setup
 	ipv6_ping_novrf
+	setup
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv6_ping_novrf
 
 	log_subsection "With VRF"
 	setup "yes"
 	ipv6_ping_vrf
+	setup "yes"
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv6_ping_vrf
 }
 
 ################################################################################
diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index 0d7bbe49359d..1b25cc7c64bb 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -5,7 +5,8 @@ virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
 CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
-LDFLAGS += -lpthread
+CFLAGS += -pthread
+LDFLAGS += -pthread
 vpath %.c ../../drivers/virtio ../../drivers/vhost
 mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test V=${V}
