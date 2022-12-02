Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCDD640B5B
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 17:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiLBQ4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 11:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbiLBQza (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 11:55:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23897DA7FA;
        Fri,  2 Dec 2022 08:55:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 924656232F;
        Fri,  2 Dec 2022 16:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4393C433C1;
        Fri,  2 Dec 2022 16:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670000122;
        bh=gpWanwKQDSsHNkGQ9KYW7VPp+ihaT1eCaBpg8b2achM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b51WRMoP/88PSfSP1VofmF3LzBm04jzW5d0mS5RbYV97WChwCUVEO2vTrRjXNaTVa
         Q9KYUn+c8+xqIzBMeXSDkkTN/ADlb31Flz+a+C4kYQy39nHJC0l1mnkGqyM2j4U3qX
         wFMyhyaCi57ILDf52cwQqpdJSX7RPxsA2UjxlxOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.81
Date:   Fri,  2 Dec 2022 17:55:10 +0100
Message-Id: <167000010923872@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <167000010998241@kroah.com>
References: <167000010998241@kroah.com>
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

diff --git a/Makefile b/Makefile
index b840fe57331f..cc0a1da24943 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 80
+SUBLEVEL = 81
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/am335x-pcm-953.dtsi b/arch/arm/boot/dts/am335x-pcm-953.dtsi
index 124026fa0d09..f207499461b3 100644
--- a/arch/arm/boot/dts/am335x-pcm-953.dtsi
+++ b/arch/arm/boot/dts/am335x-pcm-953.dtsi
@@ -12,22 +12,20 @@ / {
 	compatible = "phytec,am335x-pcm-953", "phytec,am335x-phycore-som", "ti,am33xx";
 
 	/* Power */
-	regulators {
-		vcc3v3: fixedregulator@1 {
-			compatible = "regulator-fixed";
-			regulator-name = "vcc3v3";
-			regulator-min-microvolt = <3300000>;
-			regulator-max-microvolt = <3300000>;
-			regulator-boot-on;
-		};
+	vcc3v3: fixedregulator1 {
+		compatible = "regulator-fixed";
+		regulator-name = "vcc3v3";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
 
-		vcc1v8: fixedregulator@2 {
-			compatible = "regulator-fixed";
-			regulator-name = "vcc1v8";
-			regulator-min-microvolt = <1800000>;
-			regulator-max-microvolt = <1800000>;
-			regulator-boot-on;
-		};
+	vcc1v8: fixedregulator2 {
+		compatible = "regulator-fixed";
+		regulator-name = "vcc1v8";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		regulator-boot-on;
 	};
 
 	/* User IO */
diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index ca03685f0f08..4783e657b4cb 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -39,6 +39,13 @@ pinctrl_pck0_as_mck: pck0_as_mck {
 
 				};
 
+				usb1 {
+					pinctrl_usb1_vbus_gpio: usb1_vbus_gpio {
+						atmel,pins =
+							<AT91_PIOC 5 AT91_PERIPH_GPIO AT91_PINCTRL_DEGLITCH>;	/* PC5 GPIO */
+					};
+				};
+
 				mmc0_slot1 {
 					pinctrl_board_mmc0_slot1: mmc0_slot1-board {
 						atmel,pins =
@@ -84,6 +91,8 @@ macb0: ethernet@fffc4000 {
 			};
 
 			usb1: gadget@fffa4000 {
+				pinctrl-0 = <&pinctrl_usb1_vbus_gpio>;
+				pinctrl-names = "default";
 				atmel,vbus-gpio = <&pioC 5 GPIO_ACTIVE_HIGH>;
 				status = "okay";
 			};
diff --git a/arch/arm/boot/dts/imx6q-prti6q.dts b/arch/arm/boot/dts/imx6q-prti6q.dts
index b4605edfd2ab..d8fa83effd63 100644
--- a/arch/arm/boot/dts/imx6q-prti6q.dts
+++ b/arch/arm/boot/dts/imx6q-prti6q.dts
@@ -364,8 +364,8 @@ wifi {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_wifi>;
 		interrupts-extended = <&gpio1 30 IRQ_TYPE_LEVEL_HIGH>;
-		ref-clock-frequency = "38400000";
-		tcxo-clock-frequency = "19200000";
+		ref-clock-frequency = <38400000>;
+		tcxo-clock-frequency = <19200000>;
 	};
 };
 
diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 25c9d184fa4c..1c57ac401649 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -393,8 +393,10 @@ static void __init mxs_machine_init(void)
 
 	root = of_find_node_by_path("/");
 	ret = of_property_read_string(root, "model", &soc_dev_attr->machine);
-	if (ret)
+	if (ret) {
+		kfree(soc_dev_attr);
 		return;
+	}
 
 	soc_dev_attr->family = "Freescale MXS Family";
 	soc_dev_attr->soc_id = mxs_get_soc_id();
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
index 3ae5d727e367..f07f4b8231f9 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -207,7 +207,7 @@ &sdmmc {
 	cap-sd-highspeed;
 	cd-gpios = <&gpio0 RK_PA7 GPIO_ACTIVE_LOW>;
 	disable-wp;
-	max-frequency = <150000000>;
+	max-frequency = <40000000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc_clk &sdmmc_cmd &sdmmc_cd &sdmmc_bus4>;
 	vmmc-supply = <&vcc3v3_baseboard>;
diff --git a/arch/arm64/include/asm/syscall_wrapper.h b/arch/arm64/include/asm/syscall_wrapper.h
index b383b4802a7b..d30217c21eff 100644
--- a/arch/arm64/include/asm/syscall_wrapper.h
+++ b/arch/arm64/include/asm/syscall_wrapper.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_SYSCALL_WRAPPER_H
 #define __ASM_SYSCALL_WRAPPER_H
 
-struct pt_regs;
+#include <asm/ptrace.h>
 
 #define SC_ARM64_REGS_TO_ARGS(x, ...)				\
 	__MAP(x,__SC_ARGS					\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4cb265e15361..3fe816c244ce 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2000,6 +2000,17 @@ static int pkvm_drop_host_privileges(void)
 	 * once the host stage 2 is installed.
 	 */
 	static_branch_enable(&kvm_protected_mode_initialized);
+
+	/*
+	 * Fixup the boot mode so that we don't take spurious round
+	 * trips via EL2 on cpu_resume. Flush to the PoC for a good
+	 * measure, so that it can be observed by a CPU coming out of
+	 * suspend with the MMU off.
+	 */
+	__boot_cpu_mode[0] = __boot_cpu_mode[1] = BOOT_CPU_MODE_EL1;
+	dcache_clean_poc((unsigned long)__boot_cpu_mode,
+			 (unsigned long)(__boot_cpu_mode + 2));
+
 	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
 	return ret;
 }
diff --git a/arch/mips/include/asm/fw/fw.h b/arch/mips/include/asm/fw/fw.h
index d0ef8b4892bb..d0494ce4b337 100644
--- a/arch/mips/include/asm/fw/fw.h
+++ b/arch/mips/include/asm/fw/fw.h
@@ -26,6 +26,6 @@ extern char *fw_getcmdline(void);
 extern void fw_meminit(void);
 extern char *fw_getenv(char *name);
 extern unsigned long fw_getenvl(char *name);
-extern void fw_init_early_console(char port);
+extern void fw_init_early_console(void);
 
 #endif /* __ASM_FW_H_ */
diff --git a/arch/mips/pic32/pic32mzda/early_console.c b/arch/mips/pic32/pic32mzda/early_console.c
index 25372e62783b..3cd1b408fa1c 100644
--- a/arch/mips/pic32/pic32mzda/early_console.c
+++ b/arch/mips/pic32/pic32mzda/early_console.c
@@ -27,7 +27,7 @@
 #define U_BRG(x)	(UART_BASE(x) + 0x40)
 
 static void __iomem *uart_base;
-static char console_port = -1;
+static int console_port = -1;
 
 static int __init configure_uart_pins(int port)
 {
@@ -47,7 +47,7 @@ static int __init configure_uart_pins(int port)
 	return 0;
 }
 
-static void __init configure_uart(char port, int baud)
+static void __init configure_uart(int port, int baud)
 {
 	u32 pbclk;
 
@@ -60,7 +60,7 @@ static void __init configure_uart(char port, int baud)
 		     uart_base + PIC32_SET(U_STA(port)));
 }
 
-static void __init setup_early_console(char port, int baud)
+static void __init setup_early_console(int port, int baud)
 {
 	if (configure_uart_pins(port))
 		return;
@@ -130,16 +130,15 @@ static int __init get_baud_from_cmdline(char *arch_cmdline)
 	return baud;
 }
 
-void __init fw_init_early_console(char port)
+void __init fw_init_early_console(void)
 {
 	char *arch_cmdline = pic32_getcmdline();
-	int baud = -1;
+	int baud, port;
 
 	uart_base = ioremap(PIC32_BASE_UART, 0xc00);
 
 	baud = get_baud_from_cmdline(arch_cmdline);
-	if (port == -1)
-		port = get_port_from_cmdline(arch_cmdline);
+	port = get_port_from_cmdline(arch_cmdline);
 
 	if (port == -1)
 		port = EARLY_CONSOLE_PORT;
diff --git a/arch/mips/pic32/pic32mzda/init.c b/arch/mips/pic32/pic32mzda/init.c
index 764f2d022fae..429830afff54 100644
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -47,7 +47,7 @@ void __init plat_mem_setup(void)
 		strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 
 #ifdef CONFIG_EARLY_PRINTK
-	fw_init_early_console(-1);
+	fw_init_early_console();
 #endif
 	pic32_config_init();
 }
diff --git a/arch/nios2/boot/Makefile b/arch/nios2/boot/Makefile
index 37dfc7e584bc..0b704c1f379f 100644
--- a/arch/nios2/boot/Makefile
+++ b/arch/nios2/boot/Makefile
@@ -20,7 +20,7 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
 
-$(obj)/vmImage: $(obj)/vmlinux.gz
+$(obj)/vmImage: $(obj)/vmlinux.gz FORCE
 	$(call if_changed,uimage)
 	@$(kecho) 'Kernel: $@ is ready'
 
diff --git a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
index 22f971e97161..2f4d677c9c4f 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
@@ -3,6 +3,8 @@
 
 #include "fu540-c000.dtsi"
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/leds/common.h>
+#include <dt-bindings/pwm/pwm.h>
 
 /* Clock frequency (in Hz) of the PCB crystal for rtcclk */
 #define RTCCLK_FREQ		1000000
@@ -46,6 +48,42 @@ gpio-restart {
 		compatible = "gpio-restart";
 		gpios = <&gpio 10 GPIO_ACTIVE_LOW>;
 	};
+
+	led-controller {
+		compatible = "pwm-leds";
+
+		led-d1 {
+			pwms = <&pwm0 0 7812500 PWM_POLARITY_INVERTED>;
+			active-low;
+			color = <LED_COLOR_ID_GREEN>;
+			max-brightness = <255>;
+			label = "d1";
+		};
+
+		led-d2 {
+			pwms = <&pwm0 1 7812500 PWM_POLARITY_INVERTED>;
+			active-low;
+			color = <LED_COLOR_ID_GREEN>;
+			max-brightness = <255>;
+			label = "d2";
+		};
+
+		led-d3 {
+			pwms = <&pwm0 2 7812500 PWM_POLARITY_INVERTED>;
+			active-low;
+			color = <LED_COLOR_ID_GREEN>;
+			max-brightness = <255>;
+			label = "d3";
+		};
+
+		led-d4 {
+			pwms = <&pwm0 3 7812500 PWM_POLARITY_INVERTED>;
+			active-low;
+			color = <LED_COLOR_ID_GREEN>;
+			max-brightness = <255>;
+			label = "d4";
+		};
+	};
 };
 
 &uart0 {
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 84ac0fe612e7..db6548509bb3 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -28,6 +28,9 @@ obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 
 obj-y += vdso.o
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+ifneq ($(filter vgettimeofday, $(vdso-syms)),)
+CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
+endif
 
 # Disable -pg to prevent insert call site
 CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE)
diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index e9111f700af0..3729cb28aac8 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -65,9 +65,11 @@ VERSION
 	LINUX_4.15 {
 	global:
 		__vdso_rt_sigreturn;
+#ifdef HAS_VGETTIMEOFDAY
 		__vdso_gettimeofday;
 		__vdso_clock_gettime;
 		__vdso_clock_getres;
+#endif
 		__vdso_getcpu;
 		__vdso_flush_icache;
 	local: *;
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index f17ad2daab07..8722bd07c607 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -44,7 +44,7 @@ struct save_area {
 	u64 fprs[16];
 	u32 fpc;
 	u32 prefix;
-	u64 todpreg;
+	u32 todpreg;
 	u64 timer;
 	u64 todcmp;
 	u64 vxrs_low[16];
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index b6d48ca5b0f1..762f10cdfb7a 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -45,7 +45,7 @@ EXPORT_SYMBOL_GPL(hv_vp_assist_page);
 static int hv_cpu_init(unsigned int cpu)
 {
 	union hv_vp_assist_msr_contents msr = { 0 };
-	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
+	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[cpu];
 	int ret;
 
 	ret = hv_common_cpu_init(cpu);
@@ -55,34 +55,32 @@ static int hv_cpu_init(unsigned int cpu)
 	if (!hv_vp_assist_page)
 		return 0;
 
-	if (!*hvp) {
-		if (hv_root_partition) {
-			/*
-			 * For root partition we get the hypervisor provided VP assist
-			 * page, instead of allocating a new page.
-			 */
-			rdmsrl(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
-			*hvp = memremap(msr.pfn <<
-					HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT,
-					PAGE_SIZE, MEMREMAP_WB);
-		} else {
-			/*
-			 * The VP assist page is an "overlay" page (see Hyper-V TLFS's
-			 * Section 5.2.1 "GPA Overlay Pages"). Here it must be zeroed
-			 * out to make sure we always write the EOI MSR in
-			 * hv_apic_eoi_write() *after* the EOI optimization is disabled
-			 * in hv_cpu_die(), otherwise a CPU may not be stopped in the
-			 * case of CPU offlining and the VM will hang.
-			 */
+	if (hv_root_partition) {
+		/*
+		 * For root partition we get the hypervisor provided VP assist
+		 * page, instead of allocating a new page.
+		 */
+		rdmsrl(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
+		*hvp = memremap(msr.pfn << HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT,
+				PAGE_SIZE, MEMREMAP_WB);
+	} else {
+		/*
+		 * The VP assist page is an "overlay" page (see Hyper-V TLFS's
+		 * Section 5.2.1 "GPA Overlay Pages"). Here it must be zeroed
+		 * out to make sure we always write the EOI MSR in
+		 * hv_apic_eoi_write() *after* the EOI optimization is disabled
+		 * in hv_cpu_die(), otherwise a CPU may not be stopped in the
+		 * case of CPU offlining and the VM will hang.
+		 */
+		if (!*hvp)
 			*hvp = __vmalloc(PAGE_SIZE, GFP_KERNEL | __GFP_ZERO);
-			if (*hvp)
-				msr.pfn = vmalloc_to_pfn(*hvp);
-		}
-		WARN_ON(!(*hvp));
-		if (*hvp) {
-			msr.enable = 1;
-			wrmsrl(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
-		}
+		if (*hvp)
+			msr.pfn = vmalloc_to_pfn(*hvp);
+
+	}
+	if (!WARN_ON(!(*hvp))) {
+		msr.enable = 1;
+		wrmsrl(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
 	}
 
 	return 0;
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2b56bfef9917..f3cb8c8bf8d9 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -303,6 +303,9 @@
 #define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
+
+#define X86_FEATURE_MSR_TSX_CTRL	(11*32+20) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
+
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 83df20e3e633..217777c029ee 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -372,6 +372,29 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	return ret;
 }
 
+/*
+ * Ensure user provided offset and length values are valid for
+ * an enclave.
+ */
+static int sgx_validate_offset_length(struct sgx_encl *encl,
+				      unsigned long offset,
+				      unsigned long length)
+{
+	if (!IS_ALIGNED(offset, PAGE_SIZE))
+		return -EINVAL;
+
+	if (!length || !IS_ALIGNED(length, PAGE_SIZE))
+		return -EINVAL;
+
+	if (offset + length < offset)
+		return -EINVAL;
+
+	if (offset + length - PAGE_SIZE >= encl->size)
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * sgx_ioc_enclave_add_pages() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGES
  * @encl:       an enclave pointer
@@ -425,14 +448,10 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	if (copy_from_user(&add_arg, arg, sizeof(add_arg)))
 		return -EFAULT;
 
-	if (!IS_ALIGNED(add_arg.offset, PAGE_SIZE) ||
-	    !IS_ALIGNED(add_arg.src, PAGE_SIZE))
-		return -EINVAL;
-
-	if (!add_arg.length || add_arg.length & (PAGE_SIZE - 1))
+	if (!IS_ALIGNED(add_arg.src, PAGE_SIZE))
 		return -EINVAL;
 
-	if (add_arg.offset + add_arg.length - PAGE_SIZE >= encl->size)
+	if (sgx_validate_offset_length(encl, add_arg.offset, add_arg.length))
 		return -EINVAL;
 
 	if (copy_from_user(&secinfo, (void __user *)add_arg.secinfo,
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index ec7bbac3a9f2..8009c8346d8f 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -58,24 +58,6 @@ static void tsx_enable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-static bool tsx_ctrl_is_supported(void)
-{
-	u64 ia32_cap = x86_read_arch_cap_msr();
-
-	/*
-	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
-	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIES.
-	 *
-	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
-	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
-	 * bit MDS_NO=1. CPUs with MDS_NO=0 are not planned to get
-	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
-	 * tsx= cmdline requests will do nothing on CPUs without
-	 * MSR_IA32_TSX_CTRL support.
-	 */
-	return !!(ia32_cap & ARCH_CAP_TSX_CTRL_MSR);
-}
-
 static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 {
 	if (boot_cpu_has_bug(X86_BUG_TAA))
@@ -135,7 +117,7 @@ static void tsx_clear_cpuid(void)
 		rdmsrl(MSR_TSX_FORCE_ABORT, msr);
 		msr |= MSR_TFA_TSX_CPUID_CLEAR;
 		wrmsrl(MSR_TSX_FORCE_ABORT, msr);
-	} else if (tsx_ctrl_is_supported()) {
+	} else if (cpu_feature_enabled(X86_FEATURE_MSR_TSX_CTRL)) {
 		rdmsrl(MSR_IA32_TSX_CTRL, msr);
 		msr |= TSX_CTRL_CPUID_CLEAR;
 		wrmsrl(MSR_IA32_TSX_CTRL, msr);
@@ -158,7 +140,8 @@ static void tsx_dev_mode_disable(void)
 	u64 mcu_opt_ctrl;
 
 	/* Check if RTM_ALLOW exists */
-	if (!boot_cpu_has_bug(X86_BUG_TAA) || !tsx_ctrl_is_supported() ||
+	if (!boot_cpu_has_bug(X86_BUG_TAA) ||
+	    !cpu_feature_enabled(X86_FEATURE_MSR_TSX_CTRL) ||
 	    !cpu_feature_enabled(X86_FEATURE_SRBDS_CTRL))
 		return;
 
@@ -191,7 +174,20 @@ void __init tsx_init(void)
 		return;
 	}
 
-	if (!tsx_ctrl_is_supported()) {
+	/*
+	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
+	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIES.
+	 *
+	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
+	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
+	 * bit MDS_NO=1. CPUs with MDS_NO=0 are not planned to get
+	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
+	 * tsx= cmdline requests will do nothing on CPUs without
+	 * MSR_IA32_TSX_CTRL support.
+	 */
+	if (x86_read_arch_cap_msr() & ARCH_CAP_TSX_CTRL_MSR) {
+		setup_force_cpu_cap(X86_FEATURE_MSR_TSX_CTRL);
+	} else {
 		tsx_ctrl_state = TSX_CTRL_NOT_SUPPORTED;
 		return;
 	}
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 78f1138753e6..e0b4f88b04b3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -919,6 +919,9 @@ void svm_free_nested(struct vcpu_svm *svm)
 	if (!svm->nested.initialized)
 		return;
 
+	if (WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr))
+		svm_switch_vmcb(svm, &svm->vmcb01);
+
 	svm_vcpu_free_msrpm(svm->nested.msrpm);
 	svm->nested.msrpm = NULL;
 
@@ -937,9 +940,6 @@ void svm_free_nested(struct vcpu_svm *svm)
 	svm->nested.initialized = false;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void svm_leave_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3116d24945c8..773420203305 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -317,12 +317,6 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	return 0;
 }
 
-static int is_external_interrupt(u32 info)
-{
-	info &= SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
-	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
-}
-
 static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1427,6 +1421,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
 	sev_free_vcpu(vcpu);
@@ -3359,15 +3354,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		return 0;
 	}
 
-	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
-	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
-	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
-	    exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
-		printk(KERN_ERR "%s: unexpected exit_int_info 0x%x "
-		       "exit_code 0x%x\n",
-		       __func__, svm->vmcb->control.exit_int_info,
-		       exit_code);
-
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 91b182fafb43..817632d5a118 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6276,9 +6276,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	return kvm_state.size;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void vmx_leave_nested(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c58e23e9b5ec..fcfa3fedf84f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -608,6 +608,12 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
 
+/* Forcibly leave the nested mode in cases like a vCPU reset */
+static void kvm_leave_nested(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops.nested_ops->leave_nested(vcpu);
+}
+
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 	        bool has_payload, unsigned long payload, bool reinject)
@@ -4775,7 +4781,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
 		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
-			kvm_x86_ops.nested_ops->leave_nested(vcpu);
+			kvm_leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
 		}
 
@@ -11111,8 +11117,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	unsigned long new_cr0;
 	u32 eax, dummy;
 
+	/*
+	 * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
+	 * possible to INIT the vCPU while L2 is active.  Force the vCPU back
+	 * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
+	 * bits), i.e. virtualization is disabled.
+	 */
+	if (is_guest_mode(vcpu))
+		kvm_leave_nested(vcpu);
+
 	kvm_lapic_reset(vcpu, init_event);
 
+	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
 	vcpu->arch.hflags = 0;
 
 	vcpu->arch.smi_pending = 0;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 7ce9b8dd8757..5dfa40279f0f 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -216,9 +216,15 @@ __ioremap_caller(resource_size_t phys_addr, unsigned long size,
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PHYSICAL_PAGE_MASK;
+	phys_addr &= PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
+	/*
+	 * Mask out any bits not part of the actual physical
+	 * address, like memory encryption bits.
+	 */
+	phys_addr &= PHYSICAL_PAGE_MASK;
+
 	retval = memtype_reserve(phys_addr, (u64)phys_addr + size,
 						pcm, &new_pcm);
 	if (retval) {
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 3c1eadc5a77a..f5133d620d4e 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -513,16 +513,23 @@ static int pm_cpu_check(const struct x86_cpu_id *c)
 
 static void pm_save_spec_msr(void)
 {
-	u32 spec_msr_id[] = {
-		MSR_IA32_SPEC_CTRL,
-		MSR_IA32_TSX_CTRL,
-		MSR_TSX_FORCE_ABORT,
-		MSR_IA32_MCU_OPT_CTRL,
-		MSR_AMD64_LS_CFG,
-		MSR_AMD64_DE_CFG,
+	struct msr_enumeration {
+		u32 msr_no;
+		u32 feature;
+	} msr_enum[] = {
+		{ MSR_IA32_SPEC_CTRL,	 X86_FEATURE_MSR_SPEC_CTRL },
+		{ MSR_IA32_TSX_CTRL,	 X86_FEATURE_MSR_TSX_CTRL },
+		{ MSR_TSX_FORCE_ABORT,	 X86_FEATURE_TSX_FORCE_ABORT },
+		{ MSR_IA32_MCU_OPT_CTRL, X86_FEATURE_SRBDS_CTRL },
+		{ MSR_AMD64_LS_CFG,	 X86_FEATURE_LS_CFG_SSBD },
+		{ MSR_AMD64_DE_CFG,	 X86_FEATURE_LFENCE_RDTSC },
 	};
+	int i;
 
-	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
+	for (i = 0; i < ARRAY_SIZE(msr_enum); i++) {
+		if (boot_cpu_has(msr_enum[i].feature))
+			msr_build_context(&msr_enum[i].msr_no, 1);
+	}
 }
 
 static int pm_check_save_msr(void)
diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index e2e765a54fe9..a8d0b4c71b05 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -613,6 +613,10 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 	struct bfq_group *bfqg;
 
 	while (blkg) {
+		if (!blkg->online) {
+			blkg = blkg->parent;
+			continue;
+		}
 		bfqg = blkg_to_bfqg(blkg);
 		if (bfqg->online) {
 			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 8ed450125c92..6acfb896b2e5 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -753,6 +753,12 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	const char *failure_string;
 	struct binder_buffer *buffer;
 
+	if (unlikely(vma->vm_mm != alloc->vma_vm_mm)) {
+		ret = -EINVAL;
+		failure_string = "invalid vma->vm_mm";
+		goto err_invalid_mm;
+	}
+
 	mutex_lock(&binder_alloc_mmap_lock);
 	if (alloc->buffer_size) {
 		ret = -EBUSY;
@@ -799,6 +805,7 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	alloc->buffer_size = 0;
 err_already_mapped:
 	mutex_unlock(&binder_alloc_mmap_lock);
+err_invalid_mm:
 	binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
 			   "%s: %d %lx-%lx %s failed %d\n", __func__,
 			   alloc->pid, vma->vm_start, vma->vm_end,
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ef41cb385a0d..061d2f8feeb5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3988,44 +3988,51 @@ void ata_scsi_dump_cdb(struct ata_port *ap, struct scsi_cmnd *cmd)
 
 int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	u8 scsi_op = scmd->cmnd[0];
 	ata_xlat_func_t xlat_func;
-	int rc = 0;
+
+	/*
+	 * scsi_queue_rq() will defer commands if scsi_host_in_recovery().
+	 * However, this check is done without holding the ap->lock (a libata
+	 * specific lock), so we can have received an error irq since then,
+	 * therefore we must check if EH is pending, while holding ap->lock.
+	 */
+	if (ap->pflags & (ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS))
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+
+	if (unlikely(!scmd->cmd_len))
+		goto bad_cdb_len;
 
 	if (dev->class == ATA_DEV_ATA || dev->class == ATA_DEV_ZAC) {
-		if (unlikely(!scmd->cmd_len || scmd->cmd_len > dev->cdb_len))
+		if (unlikely(scmd->cmd_len > dev->cdb_len))
 			goto bad_cdb_len;
 
 		xlat_func = ata_get_xlat_func(dev, scsi_op);
-	} else {
-		if (unlikely(!scmd->cmd_len))
-			goto bad_cdb_len;
+	} else if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
+		/* relay SCSI command to ATAPI device */
+		int len = COMMAND_SIZE(scsi_op);
 
-		xlat_func = NULL;
-		if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
-			/* relay SCSI command to ATAPI device */
-			int len = COMMAND_SIZE(scsi_op);
-			if (unlikely(len > scmd->cmd_len ||
-				     len > dev->cdb_len ||
-				     scmd->cmd_len > ATAPI_CDB_LEN))
-				goto bad_cdb_len;
+		if (unlikely(len > scmd->cmd_len ||
+			     len > dev->cdb_len ||
+			     scmd->cmd_len > ATAPI_CDB_LEN))
+			goto bad_cdb_len;
 
-			xlat_func = atapi_xlat;
-		} else {
-			/* ATA_16 passthru, treat as an ATA command */
-			if (unlikely(scmd->cmd_len > 16))
-				goto bad_cdb_len;
+		xlat_func = atapi_xlat;
+	} else {
+		/* ATA_16 passthru, treat as an ATA command */
+		if (unlikely(scmd->cmd_len > 16))
+			goto bad_cdb_len;
 
-			xlat_func = ata_get_xlat_func(dev, scsi_op);
-		}
+		xlat_func = ata_get_xlat_func(dev, scsi_op);
 	}
 
 	if (xlat_func)
-		rc = ata_scsi_translate(dev, scmd, xlat_func);
-	else
-		ata_scsi_simulate(dev, scmd);
+		return ata_scsi_translate(dev, scmd, xlat_func);
 
-	return rc;
+	ata_scsi_simulate(dev, scmd);
+
+	return 0;
 
  bad_cdb_len:
 	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
diff --git a/drivers/bus/intel-ixp4xx-eb.c b/drivers/bus/intel-ixp4xx-eb.c
index a4388440aca7..91db001eb69a 100644
--- a/drivers/bus/intel-ixp4xx-eb.c
+++ b/drivers/bus/intel-ixp4xx-eb.c
@@ -49,7 +49,7 @@
 #define IXP4XX_EXP_SIZE_SHIFT		10
 #define IXP4XX_EXP_CNFG_0		BIT(9) /* Always zero */
 #define IXP43X_EXP_SYNC_INTEL		BIT(8) /* Only on IXP43x */
-#define IXP43X_EXP_EXP_CHIP		BIT(7) /* Only on IXP43x */
+#define IXP43X_EXP_EXP_CHIP		BIT(7) /* Only on IXP43x, dangerous to touch on IXP42x */
 #define IXP4XX_EXP_BYTE_RD16		BIT(6)
 #define IXP4XX_EXP_HRDY_POL		BIT(5) /* Only on IXP42x */
 #define IXP4XX_EXP_MUX_EN		BIT(4)
@@ -57,8 +57,6 @@
 #define IXP4XX_EXP_WORD			BIT(2) /* Always zero */
 #define IXP4XX_EXP_WR_EN		BIT(1)
 #define IXP4XX_EXP_BYTE_EN		BIT(0)
-#define IXP42X_RESERVED			(BIT(30)|IXP4XX_EXP_CNFG_0|BIT(8)|BIT(7)|IXP4XX_EXP_WORD)
-#define IXP43X_RESERVED			(BIT(30)|IXP4XX_EXP_CNFG_0|BIT(5)|IXP4XX_EXP_WORD)
 
 #define IXP4XX_EXP_CNFG0		0x20
 #define IXP4XX_EXP_CNFG0_MEM_MAP	BIT(31)
@@ -252,10 +250,9 @@ static void ixp4xx_exp_setup_chipselect(struct ixp4xx_eb *eb,
 		cs_cfg |= val << IXP4XX_EXP_CYC_TYPE_SHIFT;
 	}
 
-	if (eb->is_42x)
-		cs_cfg &= ~IXP42X_RESERVED;
 	if (eb->is_43x) {
-		cs_cfg &= ~IXP43X_RESERVED;
+		/* Should always be zero */
+		cs_cfg &= ~IXP4XX_EXP_WORD;
 		/*
 		 * This bit for Intel strata flash is currently unused, but let's
 		 * report it if we find one.
diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 60b082fe2ed0..20ed77f2b949 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -271,6 +271,9 @@ EXPORT_SYMBOL_GPL(sunxi_rsb_driver_register);
 /* common code that starts a transfer */
 static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 {
+	u32 int_mask, status;
+	bool timeout;
+
 	if (readl(rsb->regs + RSB_CTRL) & RSB_CTRL_START_TRANS) {
 		dev_dbg(rsb->dev, "RSB transfer still in progress\n");
 		return -EBUSY;
@@ -278,13 +281,23 @@ static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 
 	reinit_completion(&rsb->complete);
 
-	writel(RSB_INTS_LOAD_BSY | RSB_INTS_TRANS_ERR | RSB_INTS_TRANS_OVER,
-	       rsb->regs + RSB_INTE);
+	int_mask = RSB_INTS_LOAD_BSY | RSB_INTS_TRANS_ERR | RSB_INTS_TRANS_OVER;
+	writel(int_mask, rsb->regs + RSB_INTE);
 	writel(RSB_CTRL_START_TRANS | RSB_CTRL_GLOBAL_INT_ENB,
 	       rsb->regs + RSB_CTRL);
 
-	if (!wait_for_completion_io_timeout(&rsb->complete,
-					    msecs_to_jiffies(100))) {
+	if (irqs_disabled()) {
+		timeout = readl_poll_timeout_atomic(rsb->regs + RSB_INTS,
+						    status, (status & int_mask),
+						    10, 100000);
+		writel(status, rsb->regs + RSB_INTS);
+	} else {
+		timeout = !wait_for_completion_io_timeout(&rsb->complete,
+							  msecs_to_jiffies(100));
+		status = rsb->status;
+	}
+
+	if (timeout) {
 		dev_dbg(rsb->dev, "RSB timeout\n");
 
 		/* abort the transfer */
@@ -296,18 +309,18 @@ static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 		return -ETIMEDOUT;
 	}
 
-	if (rsb->status & RSB_INTS_LOAD_BSY) {
+	if (status & RSB_INTS_LOAD_BSY) {
 		dev_dbg(rsb->dev, "RSB busy\n");
 		return -EBUSY;
 	}
 
-	if (rsb->status & RSB_INTS_TRANS_ERR) {
-		if (rsb->status & RSB_INTS_TRANS_ERR_ACK) {
+	if (status & RSB_INTS_TRANS_ERR) {
+		if (status & RSB_INTS_TRANS_ERR_ACK) {
 			dev_dbg(rsb->dev, "RSB slave nack\n");
 			return -EINVAL;
 		}
 
-		if (rsb->status & RSB_INTS_TRANS_ERR_DATA) {
+		if (status & RSB_INTS_TRANS_ERR_DATA) {
 			dev_dbg(rsb->dev, "RSB transfer data error\n");
 			return -EIO;
 		}
@@ -816,14 +829,6 @@ static int sunxi_rsb_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static void sunxi_rsb_shutdown(struct platform_device *pdev)
-{
-	struct sunxi_rsb *rsb = platform_get_drvdata(pdev);
-
-	pm_runtime_disable(&pdev->dev);
-	sunxi_rsb_hw_exit(rsb);
-}
-
 static const struct dev_pm_ops sunxi_rsb_dev_pm_ops = {
 	SET_RUNTIME_PM_OPS(sunxi_rsb_runtime_suspend,
 			   sunxi_rsb_runtime_resume, NULL)
@@ -839,7 +844,6 @@ MODULE_DEVICE_TABLE(of, sunxi_rsb_of_match_table);
 static struct platform_driver sunxi_rsb_driver = {
 	.probe = sunxi_rsb_probe,
 	.remove	= sunxi_rsb_remove,
-	.shutdown = sunxi_rsb_shutdown,
 	.driver	= {
 		.name = RSB_CTRL_NAME,
 		.of_match_table = sunxi_rsb_of_match_table,
diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index 8f5848aa144f..59d158873f4c 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -233,18 +233,6 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 		return ERR_PTR(-EINVAL);
 	}
 
-	/* check the name is unique */
-	mutex_lock(&heap_list_lock);
-	list_for_each_entry(h, &heap_list, list) {
-		if (!strcmp(h->name, exp_info->name)) {
-			mutex_unlock(&heap_list_lock);
-			pr_err("dma_heap: Already registered heap named %s\n",
-			       exp_info->name);
-			return ERR_PTR(-EINVAL);
-		}
-	}
-	mutex_unlock(&heap_list_lock);
-
 	heap = kzalloc(sizeof(*heap), GFP_KERNEL);
 	if (!heap)
 		return ERR_PTR(-ENOMEM);
@@ -283,13 +271,27 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 		err_ret = ERR_CAST(dev_ret);
 		goto err2;
 	}
-	/* Add heap to the list */
+
 	mutex_lock(&heap_list_lock);
+	/* check the name is unique */
+	list_for_each_entry(h, &heap_list, list) {
+		if (!strcmp(h->name, exp_info->name)) {
+			mutex_unlock(&heap_list_lock);
+			pr_err("dma_heap: Already registered heap named %s\n",
+			       exp_info->name);
+			err_ret = ERR_PTR(-EINVAL);
+			goto err3;
+		}
+	}
+
+	/* Add heap to the list */
 	list_add(&heap->list, &heap_list);
 	mutex_unlock(&heap_list_lock);
 
 	return heap;
 
+err3:
+	device_destroy(dma_heap_class, heap->heap_devt);
 err2:
 	cdev_del(&heap->heap_cdev);
 err1:
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c
index 46cd4ee6bafb..f3743089a1c9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c
@@ -44,5 +44,6 @@ const struct kfd2kgd_calls aldebaran_kfd2kgd = {
 	.get_atc_vmid_pasid_mapping_info =
 				kgd_gfx_v9_get_atc_vmid_pasid_mapping_info,
 	.set_vm_context_page_table_base = kgd_gfx_v9_set_vm_context_page_table_base,
+	.get_cu_occupancy = kgd_gfx_v9_get_cu_occupancy,
 	.program_trap_handler_settings = kgd_gfx_v9_program_trap_handler_settings
 };
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index a1e63ba4c54a..13ca51ff8bd0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -419,11 +419,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 	if (r)
 		goto release_object;
 
-	if (args->flags & AMDGPU_GEM_USERPTR_REGISTER) {
-		r = amdgpu_mn_register(bo, args->addr);
-		if (r)
-			goto release_object;
-	}
+	r = amdgpu_mn_register(bo, args->addr);
+	if (r)
+		goto release_object;
 
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
 		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d9f99212e624..72e9b9b80c22 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1374,7 +1374,44 @@ static const struct dmi_system_id hpd_disconnect_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower Plus 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF Plus 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro Plus 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro 7010"),
+		},
+	},
 	{}
+	/* TODO: refactor this from a fixed table to a dynamic option */
 };
 
 static void retrieve_dmi_info(struct amdgpu_display_manager *dm)
diff --git a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
index c65e4d125c8e..013fca9b9c68 100644
--- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
@@ -361,7 +361,8 @@ static const struct dce_audio_registers audio_regs[] = {
 	audio_regs(2),
 	audio_regs(3),
 	audio_regs(4),
-	audio_regs(5)
+	audio_regs(5),
+	audio_regs(6),
 };
 
 #define DCE120_AUD_COMMON_MASK_SH_LIST(mask_sh)\
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
index dad3e3741a4e..190af79f3236 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
@@ -67,22 +67,21 @@ int vega10_fan_ctrl_get_fan_speed_info(struct pp_hwmgr *hwmgr,
 int vega10_fan_ctrl_get_fan_speed_pwm(struct pp_hwmgr *hwmgr,
 		uint32_t *speed)
 {
-	uint32_t current_rpm;
-	uint32_t percent = 0;
-
-	if (hwmgr->thermal_controller.fanInfo.bNoFan)
-		return 0;
+	struct amdgpu_device *adev = hwmgr->adev;
+	uint32_t duty100, duty;
+	uint64_t tmp64;
 
-	if (vega10_get_current_rpm(hwmgr, &current_rpm))
-		return -1;
+	duty100 = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_FDO_CTRL1),
+				CG_FDO_CTRL1, FMAX_DUTY100);
+	duty = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_THERMAL_STATUS),
+				CG_THERMAL_STATUS, FDO_PWM_DUTY);
 
-	if (hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM != 0)
-		percent = current_rpm * 255 /
-			hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM;
+	if (!duty100)
+		return -EINVAL;
 
-	*speed = MIN(percent, 255);
+	tmp64 = (uint64_t)duty * 255;
+	do_div(tmp64, duty100);
+	*speed = MIN((uint32_t)tmp64, 255);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index ca6fa133993c..82a8c184526d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -368,6 +368,10 @@ static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 		    ((adev->pdev->device == 0x73BF) &&
 		    (adev->pdev->revision == 0xCF)) ||
 		    ((adev->pdev->device == 0x7422) &&
+		    (adev->pdev->revision == 0x00)) ||
+		    ((adev->pdev->device == 0x73A3) &&
+		    (adev->pdev->revision == 0x00)) ||
+		    ((adev->pdev->device == 0x73E3) &&
 		    (adev->pdev->revision == 0x00)))
 			smu_baco->platform_support = false;
 
diff --git a/drivers/gpu/drm/drm_dp_dual_mode_helper.c b/drivers/gpu/drm/drm_dp_dual_mode_helper.c
index 9faf49354cab..cb52a00ae1b1 100644
--- a/drivers/gpu/drm/drm_dp_dual_mode_helper.c
+++ b/drivers/gpu/drm/drm_dp_dual_mode_helper.c
@@ -63,23 +63,45 @@
 ssize_t drm_dp_dual_mode_read(struct i2c_adapter *adapter,
 			      u8 offset, void *buffer, size_t size)
 {
+	u8 zero = 0;
+	char *tmpbuf = NULL;
+	/*
+	 * As sub-addressing is not supported by all adaptors,
+	 * always explicitly read from the start and discard
+	 * any bytes that come before the requested offset.
+	 * This way, no matter whether the adaptor supports it
+	 * or not, we'll end up reading the proper data.
+	 */
 	struct i2c_msg msgs[] = {
 		{
 			.addr = DP_DUAL_MODE_SLAVE_ADDRESS,
 			.flags = 0,
 			.len = 1,
-			.buf = &offset,
+			.buf = &zero,
 		},
 		{
 			.addr = DP_DUAL_MODE_SLAVE_ADDRESS,
 			.flags = I2C_M_RD,
-			.len = size,
+			.len = size + offset,
 			.buf = buffer,
 		},
 	};
 	int ret;
 
+	if (offset) {
+		tmpbuf = kmalloc(size + offset, GFP_KERNEL);
+		if (!tmpbuf)
+			return -ENOMEM;
+
+		msgs[1].buf = tmpbuf;
+	}
+
 	ret = i2c_transfer(adapter, msgs, ARRAY_SIZE(msgs));
+	if (tmpbuf)
+		memcpy(buffer, tmpbuf + offset, size);
+
+	kfree(tmpbuf);
+
 	if (ret < 0)
 		return ret;
 	if (ret != ARRAY_SIZE(msgs))
@@ -208,18 +230,6 @@ enum drm_dp_dual_mode_type drm_dp_dual_mode_detect(const struct drm_device *dev,
 	if (ret)
 		return DRM_DP_DUAL_MODE_UNKNOWN;
 
-	/*
-	 * Sigh. Some (maybe all?) type 1 adaptors are broken and ack
-	 * the offset but ignore it, and instead they just always return
-	 * data from the start of the HDMI ID buffer. So for a broken
-	 * type 1 HDMI adaptor a single byte read will always give us
-	 * 0x44, and for a type 1 DVI adaptor it should give 0x00
-	 * (assuming it implements any registers). Fortunately neither
-	 * of those values will match the type 2 signature of the
-	 * DP_DUAL_MODE_ADAPTOR_ID register so we can proceed with
-	 * the type 2 adaptor detection safely even in the presence
-	 * of broken type 1 adaptors.
-	 */
 	ret = drm_dp_dual_mode_read(adapter, DP_DUAL_MODE_ADAPTOR_ID,
 				    &adaptor_id, sizeof(adaptor_id));
 	drm_dbg_kms(dev, "DP dual mode adaptor ID: %02x (err %zd)\n", adaptor_id, ret);
@@ -233,11 +243,10 @@ enum drm_dp_dual_mode_type drm_dp_dual_mode_detect(const struct drm_device *dev,
 				return DRM_DP_DUAL_MODE_TYPE2_DVI;
 		}
 		/*
-		 * If neither a proper type 1 ID nor a broken type 1 adaptor
-		 * as described above, assume type 1, but let the user know
-		 * that we may have misdetected the type.
+		 * If not a proper type 1 ID, still assume type 1, but let
+		 * the user know that we may have misdetected the type.
 		 */
-		if (!is_type1_adaptor(adaptor_id) && adaptor_id != hdmi_id[0])
+		if (!is_type1_adaptor(adaptor_id))
 			drm_err(dev, "Unexpected DP dual mode adaptor ID %02x\n", adaptor_id);
 
 	}
@@ -343,10 +352,8 @@ EXPORT_SYMBOL(drm_dp_dual_mode_get_tmds_output);
  * @enable: enable (as opposed to disable) the TMDS output buffers
  *
  * Set the state of the TMDS output buffers in the adaptor. For
- * type2 this is set via the DP_DUAL_MODE_TMDS_OEN register. As
- * some type 1 adaptors have problems with registers (see comments
- * in drm_dp_dual_mode_detect()) we avoid touching the register,
- * making this function a no-op on type 1 adaptors.
+ * type2 this is set via the DP_DUAL_MODE_TMDS_OEN register.
+ * Type1 adaptors do not support any register writes.
  *
  * Returns:
  * 0 on success, negative error code on failure
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 083273736c83..ca0fefeaab20 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -128,6 +128,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "One S1003"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Acer Switch V 10 (SW5-017) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SW5-017"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* Anbernic Win600 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Anbernic"),
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index ed8ad3b26395..a09820ada82c 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -982,6 +982,10 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
+		if (GRAPHICS_VER(i915) == 12 && (engine->class == VIDEO_DECODE_CLASS ||
+		    engine->class == VIDEO_ENHANCEMENT_CLASS))
+			rb.bit = _MASKED_BIT_ENABLE(rb.bit);
+
 		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 	}
 
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 611cd8dad46e..4f5affdc6080 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1083,6 +1083,10 @@ static bool host1x_drm_wants_iommu(struct host1x_device *dev)
 	struct host1x *host1x = dev_get_drvdata(dev->dev.parent);
 	struct iommu_domain *domain;
 
+	/* Our IOMMU usage policy doesn't currently play well with GART */
+	if (of_machine_is_compatible("nvidia,tegra20"))
+		return false;
+
 	/*
 	 * If the Tegra DRM clients are backed by an IOMMU, push buffers are
 	 * likely to be allocated beyond the 32-bit boundary if sufficient
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index fc9f54282f7d..c2a4bf2aae61 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -204,6 +204,10 @@ static void host1x_setup_sid_table(struct host1x *host)
 
 static bool host1x_wants_iommu(struct host1x *host1x)
 {
+	/* Our IOMMU usage policy doesn't currently play well with GART */
+	if (of_machine_is_compatible("nvidia,tegra20"))
+		return false;
+
 	/*
 	 * If we support addressing a maximum of 32 bits of physical memory
 	 * and if the host1x firewall is enabled, there's no need to enable
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 07003019263a..d8dc5cc5e3a8 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -531,13 +531,17 @@ static void vmbus_add_channel_work(struct work_struct *work)
 	 * Add the new device to the bus. This will kick off device-driver
 	 * binding which eventually invokes the device driver's AddDevice()
 	 * method.
+	 *
+	 * If vmbus_device_register() fails, the 'device_obj' is freed in
+	 * vmbus_device_release() as called by device_unregister() in the
+	 * error path of vmbus_device_register(). In the outside error
+	 * path, there's no need to free it.
 	 */
 	ret = vmbus_device_register(newchannel->device_obj);
 
 	if (ret != 0) {
 		pr_err("unable to add child device object (relid %d)\n",
 			newchannel->offermsg.child_relid);
-		kfree(newchannel->device_obj);
 		goto err_deq_chan;
 	}
 
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index ecfc299834e1..b906a3a7941c 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2109,6 +2109,7 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	ret = device_register(&child_device_obj->device);
 	if (ret) {
 		pr_err("Unable to register child device\n");
+		put_device(&child_device_obj->device);
 		return ret;
 	}
 
diff --git a/drivers/iio/industrialio-sw-trigger.c b/drivers/iio/industrialio-sw-trigger.c
index 9ae793a70b8b..a7714d32a641 100644
--- a/drivers/iio/industrialio-sw-trigger.c
+++ b/drivers/iio/industrialio-sw-trigger.c
@@ -58,8 +58,12 @@ int iio_register_sw_trigger_type(struct iio_sw_trigger_type *t)
 
 	t->group = configfs_register_default_group(iio_triggers_group, t->name,
 						&iio_trigger_type_group_type);
-	if (IS_ERR(t->group))
+	if (IS_ERR(t->group)) {
+		mutex_lock(&iio_trigger_types_lock);
+		list_del(&t->list);
+		mutex_unlock(&iio_trigger_types_lock);
 		ret = PTR_ERR(t->group);
+	}
 
 	return ret;
 }
diff --git a/drivers/iio/light/apds9960.c b/drivers/iio/light/apds9960.c
index 4141c0fa7bc4..7c4353317337 100644
--- a/drivers/iio/light/apds9960.c
+++ b/drivers/iio/light/apds9960.c
@@ -54,9 +54,6 @@
 #define APDS9960_REG_CONTROL_PGAIN_MASK_SHIFT	2
 
 #define APDS9960_REG_CONFIG_2	0x90
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK	0x60
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK_SHIFT	5
-
 #define APDS9960_REG_ID		0x92
 
 #define APDS9960_REG_STATUS	0x93
@@ -77,6 +74,9 @@
 #define APDS9960_REG_GCONF_1_GFIFO_THRES_MASK_SHIFT	6
 
 #define APDS9960_REG_GCONF_2	0xa3
+#define APDS9960_REG_GCONF_2_GGAIN_MASK			0x60
+#define APDS9960_REG_GCONF_2_GGAIN_MASK_SHIFT		5
+
 #define APDS9960_REG_GOFFSET_U	0xa4
 #define APDS9960_REG_GOFFSET_D	0xa5
 #define APDS9960_REG_GPULSE	0xa6
@@ -396,9 +396,9 @@ static int apds9960_set_pxs_gain(struct apds9960_data *data, int val)
 			}
 
 			ret = regmap_update_bits(data->regmap,
-				APDS9960_REG_CONFIG_2,
-				APDS9960_REG_CONFIG_2_GGAIN_MASK,
-				idx << APDS9960_REG_CONFIG_2_GGAIN_MASK_SHIFT);
+				APDS9960_REG_GCONF_2,
+				APDS9960_REG_GCONF_2_GGAIN_MASK,
+				idx << APDS9960_REG_GCONF_2_GGAIN_MASK_SHIFT);
 			if (!ret)
 				data->pxs_gain = idx;
 			mutex_unlock(&data->lock);
diff --git a/drivers/iio/pressure/ms5611.h b/drivers/iio/pressure/ms5611.h
index bc06271fa38b..5e2d2d4d87b5 100644
--- a/drivers/iio/pressure/ms5611.h
+++ b/drivers/iio/pressure/ms5611.h
@@ -25,13 +25,6 @@ enum {
 	MS5607,
 };
 
-struct ms5611_chip_info {
-	u16 prom[MS5611_PROM_WORDS_NB];
-
-	int (*temp_and_pressure_compensate)(struct ms5611_chip_info *chip_info,
-					    s32 *temp, s32 *pressure);
-};
-
 /*
  * OverSampling Rate descriptor.
  * Warning: cmd MUST be kept aligned on a word boundary (see
@@ -50,12 +43,15 @@ struct ms5611_state {
 	const struct ms5611_osr *pressure_osr;
 	const struct ms5611_osr *temp_osr;
 
-	int (*reset)(struct device *dev);
-	int (*read_prom_word)(struct device *dev, int index, u16 *word);
-	int (*read_adc_temp_and_pressure)(struct device *dev,
+	u16 prom[MS5611_PROM_WORDS_NB];
+
+	int (*reset)(struct ms5611_state *st);
+	int (*read_prom_word)(struct ms5611_state *st, int index, u16 *word);
+	int (*read_adc_temp_and_pressure)(struct ms5611_state *st,
 					  s32 *temp, s32 *pressure);
 
-	struct ms5611_chip_info *chip_info;
+	int (*compensate_temp_and_pressure)(struct ms5611_state *st, s32 *temp,
+					  s32 *pressure);
 	struct regulator *vdd;
 };
 
diff --git a/drivers/iio/pressure/ms5611_core.c b/drivers/iio/pressure/ms5611_core.c
index 214b0d25f598..874a73b3ea9d 100644
--- a/drivers/iio/pressure/ms5611_core.c
+++ b/drivers/iio/pressure/ms5611_core.c
@@ -85,8 +85,7 @@ static int ms5611_read_prom(struct iio_dev *indio_dev)
 	struct ms5611_state *st = iio_priv(indio_dev);
 
 	for (i = 0; i < MS5611_PROM_WORDS_NB; i++) {
-		ret = st->read_prom_word(&indio_dev->dev,
-					 i, &st->chip_info->prom[i]);
+		ret = st->read_prom_word(st, i, &st->prom[i]);
 		if (ret < 0) {
 			dev_err(&indio_dev->dev,
 				"failed to read prom at %d\n", i);
@@ -94,7 +93,7 @@ static int ms5611_read_prom(struct iio_dev *indio_dev)
 		}
 	}
 
-	if (!ms5611_prom_is_valid(st->chip_info->prom, MS5611_PROM_WORDS_NB)) {
+	if (!ms5611_prom_is_valid(st->prom, MS5611_PROM_WORDS_NB)) {
 		dev_err(&indio_dev->dev, "PROM integrity check failed\n");
 		return -ENODEV;
 	}
@@ -108,28 +107,27 @@ static int ms5611_read_temp_and_pressure(struct iio_dev *indio_dev,
 	int ret;
 	struct ms5611_state *st = iio_priv(indio_dev);
 
-	ret = st->read_adc_temp_and_pressure(&indio_dev->dev, temp, pressure);
+	ret = st->read_adc_temp_and_pressure(st, temp, pressure);
 	if (ret < 0) {
 		dev_err(&indio_dev->dev,
 			"failed to read temperature and pressure\n");
 		return ret;
 	}
 
-	return st->chip_info->temp_and_pressure_compensate(st->chip_info,
-							   temp, pressure);
+	return st->compensate_temp_and_pressure(st, temp, pressure);
 }
 
-static int ms5611_temp_and_pressure_compensate(struct ms5611_chip_info *chip_info,
+static int ms5611_temp_and_pressure_compensate(struct ms5611_state *st,
 					       s32 *temp, s32 *pressure)
 {
 	s32 t = *temp, p = *pressure;
 	s64 off, sens, dt;
 
-	dt = t - (chip_info->prom[5] << 8);
-	off = ((s64)chip_info->prom[2] << 16) + ((chip_info->prom[4] * dt) >> 7);
-	sens = ((s64)chip_info->prom[1] << 15) + ((chip_info->prom[3] * dt) >> 8);
+	dt = t - (st->prom[5] << 8);
+	off = ((s64)st->prom[2] << 16) + ((st->prom[4] * dt) >> 7);
+	sens = ((s64)st->prom[1] << 15) + ((st->prom[3] * dt) >> 8);
 
-	t = 2000 + ((chip_info->prom[6] * dt) >> 23);
+	t = 2000 + ((st->prom[6] * dt) >> 23);
 	if (t < 2000) {
 		s64 off2, sens2, t2;
 
@@ -155,17 +153,17 @@ static int ms5611_temp_and_pressure_compensate(struct ms5611_chip_info *chip_inf
 	return 0;
 }
 
-static int ms5607_temp_and_pressure_compensate(struct ms5611_chip_info *chip_info,
+static int ms5607_temp_and_pressure_compensate(struct ms5611_state *st,
 					       s32 *temp, s32 *pressure)
 {
 	s32 t = *temp, p = *pressure;
 	s64 off, sens, dt;
 
-	dt = t - (chip_info->prom[5] << 8);
-	off = ((s64)chip_info->prom[2] << 17) + ((chip_info->prom[4] * dt) >> 6);
-	sens = ((s64)chip_info->prom[1] << 16) + ((chip_info->prom[3] * dt) >> 7);
+	dt = t - (st->prom[5] << 8);
+	off = ((s64)st->prom[2] << 17) + ((st->prom[4] * dt) >> 6);
+	sens = ((s64)st->prom[1] << 16) + ((st->prom[3] * dt) >> 7);
 
-	t = 2000 + ((chip_info->prom[6] * dt) >> 23);
+	t = 2000 + ((st->prom[6] * dt) >> 23);
 	if (t < 2000) {
 		s64 off2, sens2, t2, tmp;
 
@@ -196,7 +194,7 @@ static int ms5611_reset(struct iio_dev *indio_dev)
 	int ret;
 	struct ms5611_state *st = iio_priv(indio_dev);
 
-	ret = st->reset(&indio_dev->dev);
+	ret = st->reset(st);
 	if (ret < 0) {
 		dev_err(&indio_dev->dev, "failed to reset device\n");
 		return ret;
@@ -343,15 +341,6 @@ static int ms5611_write_raw(struct iio_dev *indio_dev,
 
 static const unsigned long ms5611_scan_masks[] = {0x3, 0};
 
-static struct ms5611_chip_info chip_info_tbl[] = {
-	[MS5611] = {
-		.temp_and_pressure_compensate = ms5611_temp_and_pressure_compensate,
-	},
-	[MS5607] = {
-		.temp_and_pressure_compensate = ms5607_temp_and_pressure_compensate,
-	}
-};
-
 static const struct iio_chan_spec ms5611_channels[] = {
 	{
 		.type = IIO_PRESSURE,
@@ -434,7 +423,20 @@ int ms5611_probe(struct iio_dev *indio_dev, struct device *dev,
 	struct ms5611_state *st = iio_priv(indio_dev);
 
 	mutex_init(&st->lock);
-	st->chip_info = &chip_info_tbl[type];
+
+	switch (type) {
+	case MS5611:
+		st->compensate_temp_and_pressure =
+			ms5611_temp_and_pressure_compensate;
+		break;
+	case MS5607:
+		st->compensate_temp_and_pressure =
+			ms5607_temp_and_pressure_compensate;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	st->temp_osr =
 		&ms5611_avail_temp_osr[ARRAY_SIZE(ms5611_avail_temp_osr) - 1];
 	st->pressure_osr =
diff --git a/drivers/iio/pressure/ms5611_i2c.c b/drivers/iio/pressure/ms5611_i2c.c
index 7c04f730430c..cccc40f7df0b 100644
--- a/drivers/iio/pressure/ms5611_i2c.c
+++ b/drivers/iio/pressure/ms5611_i2c.c
@@ -20,17 +20,15 @@
 
 #include "ms5611.h"
 
-static int ms5611_i2c_reset(struct device *dev)
+static int ms5611_i2c_reset(struct ms5611_state *st)
 {
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
-
 	return i2c_smbus_write_byte(st->client, MS5611_RESET);
 }
 
-static int ms5611_i2c_read_prom_word(struct device *dev, int index, u16 *word)
+static int ms5611_i2c_read_prom_word(struct ms5611_state *st, int index,
+				     u16 *word)
 {
 	int ret;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 
 	ret = i2c_smbus_read_word_swapped(st->client,
 			MS5611_READ_PROM_WORD + (index << 1));
@@ -57,11 +55,10 @@ static int ms5611_i2c_read_adc(struct ms5611_state *st, s32 *val)
 	return 0;
 }
 
-static int ms5611_i2c_read_adc_temp_and_pressure(struct device *dev,
+static int ms5611_i2c_read_adc_temp_and_pressure(struct ms5611_state *st,
 						 s32 *temp, s32 *pressure)
 {
 	int ret;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 	const struct ms5611_osr *osr = st->temp_osr;
 
 	ret = i2c_smbus_write_byte(st->client, osr->cmd);
diff --git a/drivers/iio/pressure/ms5611_spi.c b/drivers/iio/pressure/ms5611_spi.c
index f7743ee3318f..3039fe8aa2a2 100644
--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -15,18 +15,17 @@
 
 #include "ms5611.h"
 
-static int ms5611_spi_reset(struct device *dev)
+static int ms5611_spi_reset(struct ms5611_state *st)
 {
 	u8 cmd = MS5611_RESET;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 
 	return spi_write_then_read(st->client, &cmd, 1, NULL, 0);
 }
 
-static int ms5611_spi_read_prom_word(struct device *dev, int index, u16 *word)
+static int ms5611_spi_read_prom_word(struct ms5611_state *st, int index,
+				     u16 *word)
 {
 	int ret;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 
 	ret = spi_w8r16be(st->client, MS5611_READ_PROM_WORD + (index << 1));
 	if (ret < 0)
@@ -37,11 +36,10 @@ static int ms5611_spi_read_prom_word(struct device *dev, int index, u16 *word)
 	return 0;
 }
 
-static int ms5611_spi_read_adc(struct device *dev, s32 *val)
+static int ms5611_spi_read_adc(struct ms5611_state *st, s32 *val)
 {
 	int ret;
 	u8 buf[3] = { MS5611_READ_ADC };
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 
 	ret = spi_write_then_read(st->client, buf, 1, buf, 3);
 	if (ret < 0)
@@ -52,11 +50,10 @@ static int ms5611_spi_read_adc(struct device *dev, s32 *val)
 	return 0;
 }
 
-static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
+static int ms5611_spi_read_adc_temp_and_pressure(struct ms5611_state *st,
 						 s32 *temp, s32 *pressure)
 {
 	int ret;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 	const struct ms5611_osr *osr = st->temp_osr;
 
 	/*
@@ -68,7 +65,7 @@ static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
 		return ret;
 
 	usleep_range(osr->conv_usec, osr->conv_usec + (osr->conv_usec / 10UL));
-	ret = ms5611_spi_read_adc(dev, temp);
+	ret = ms5611_spi_read_adc(st, temp);
 	if (ret < 0)
 		return ret;
 
@@ -78,7 +75,7 @@ static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
 		return ret;
 
 	usleep_range(osr->conv_usec, osr->conv_usec + (osr->conv_usec / 10UL));
-	return ms5611_spi_read_adc(dev, pressure);
+	return ms5611_spi_read_adc(st, pressure);
 }
 
 static int ms5611_spi_probe(struct spi_device *spi)
diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index efffcf0ebd3b..31c02c2019c1 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -18,6 +18,10 @@
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
 
+static bool use_low_level_irq;
+module_param(use_low_level_irq, bool, 0444);
+MODULE_PARM_DESC(use_low_level_irq, "Use low-level triggered IRQ instead of edge triggered");
+
 struct soc_button_info {
 	const char *name;
 	int acpi_index;
@@ -73,6 +77,13 @@ static const struct dmi_system_id dmi_use_low_level_irq[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire SW5-012"),
 		},
 	},
+	{
+		/* Acer Switch V 10 SW5-017, same issue as Acer Switch 10 SW5-012. */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SW5-017"),
+		},
+	},
 	{
 		/*
 		 * Acer One S1003. _LID method messes with power-button GPIO
@@ -164,7 +175,8 @@ soc_button_device_create(struct platform_device *pdev,
 		}
 
 		/* See dmi_use_low_level_irq[] comment */
-		if (!autorepeat && dmi_check_system(dmi_use_low_level_irq)) {
+		if (!autorepeat && (use_low_level_irq ||
+				    dmi_check_system(dmi_use_low_level_irq))) {
 			irq_set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
 			gpio_keys[n_buttons].irq = irq;
 			gpio_keys[n_buttons].gpio = -ENOENT;
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index ffad142801b3..973a4c1d5d09 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -191,6 +191,7 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 4b0201cf71f5..3a41ac9af2e7 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -114,18 +114,18 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* ASUS ZenBook UX425UA */
+		/* ASUS ZenBook UX425UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425UA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
-		/* ASUS ZenBook UM325UA */
+		/* ASUS ZenBook UM325UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
 	},
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 9a9deea51163..0b513fcd51d1 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -1039,6 +1039,7 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
 	input_set_abs_params(ts->input_dev, ABS_MT_WIDTH_MAJOR, 0, 255, 0, 0);
 	input_set_abs_params(ts->input_dev, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
 
+retry_read_config:
 	/* Read configuration and apply touchscreen parameters */
 	goodix_read_config(ts);
 
@@ -1046,6 +1047,16 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
 	touchscreen_parse_properties(ts->input_dev, true, &ts->prop);
 
 	if (!ts->prop.max_x || !ts->prop.max_y || !ts->max_touch_num) {
+		if (!ts->reset_controller_at_probe &&
+		    ts->irq_pin_access_method != IRQ_PIN_ACCESS_NONE) {
+			dev_info(&ts->client->dev, "Config not set, resetting controller\n");
+			/* Retry after a controller reset */
+			ts->reset_controller_at_probe = true;
+			error = goodix_reset(ts);
+			if (error)
+				return error;
+			goto retry_read_config;
+		}
 		dev_err(&ts->client->dev,
 			"Invalid config (%d, %d, %d), using defaults\n",
 			ts->prop.max_x, ts->prop.max_y, ts->max_touch_num);
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index fc1bfffc468f..59a5d06b2d3e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1620,7 +1620,7 @@ static int its_select_cpu(struct irq_data *d,
 
 		cpu = cpumask_pick_least_loaded(d, tmpmask);
 	} else {
-		cpumask_and(tmpmask, irq_data_get_affinity_mask(d), cpu_online_mask);
+		cpumask_copy(tmpmask, aff_mask);
 
 		/* If we cannot cross sockets, limit the search to that node */
 		if ((its_dev->its->flags & ITS_FLAGS_WORKAROUND_CAVIUM_23144) &&
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d5b827086962..9705f3c358dd 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -259,6 +259,7 @@ struct dm_integrity_c {
 
 	struct completion crypto_backoff;
 
+	bool wrote_to_journal;
 	bool journal_uptodate;
 	bool just_formatted;
 	bool recalculate_flag;
@@ -2361,6 +2362,8 @@ static void integrity_commit(struct work_struct *w)
 	if (!commit_sections)
 		goto release_flush_bios;
 
+	ic->wrote_to_journal = true;
+
 	i = commit_start;
 	for (n = 0; n < commit_sections; n++) {
 		for (j = 0; j < ic->journal_section_entries; j++) {
@@ -2575,10 +2578,6 @@ static void integrity_writer(struct work_struct *w)
 
 	unsigned prev_free_sectors;
 
-	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_post_suspending(ic->ti)) && !ic->meta_dev)
-		return;
-
 	spin_lock_irq(&ic->endio_wait.lock);
 	write_start = ic->committed_section;
 	write_sections = ic->n_committed_sections;
@@ -3085,10 +3084,17 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 	drain_workqueue(ic->commit_wq);
 
 	if (ic->mode == 'J') {
-		if (ic->meta_dev)
-			queue_work(ic->writer_wq, &ic->writer_work);
+		queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
 		dm_integrity_flush_buffers(ic, true);
+		if (ic->wrote_to_journal) {
+			init_journal(ic, ic->free_section,
+				     ic->journal_sections - ic->free_section, ic->commit_seq);
+			if (ic->free_section) {
+				init_journal(ic, 0, ic->free_section,
+					     next_commit_seq(ic->commit_seq));
+			}
+		}
 	}
 
 	if (ic->mode == 'B') {
@@ -3116,6 +3122,8 @@ static void dm_integrity_resume(struct dm_target *ti)
 
 	DEBUG_print("resume\n");
 
+	ic->wrote_to_journal = false;
+
 	if (ic->provided_data_sectors != old_provided_data_sectors) {
 		if (ic->provided_data_sectors > old_provided_data_sectors &&
 		    ic->mode == 'B' &&
diff --git a/drivers/mmc/host/sdhci-brcmstb.c b/drivers/mmc/host/sdhci-brcmstb.c
index f24623aac2db..4d42b1810ace 100644
--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -12,28 +12,55 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 #include "cqhci.h"
 
 #define SDHCI_VENDOR 0x78
 #define  SDHCI_VENDOR_ENHANCED_STRB 0x1
+#define  SDHCI_VENDOR_GATE_SDCLK_EN 0x2
 
-#define BRCMSTB_PRIV_FLAGS_NO_64BIT		BIT(0)
-#define BRCMSTB_PRIV_FLAGS_BROKEN_TIMEOUT	BIT(1)
+#define BRCMSTB_MATCH_FLAGS_NO_64BIT		BIT(0)
+#define BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT	BIT(1)
+#define BRCMSTB_MATCH_FLAGS_HAS_CLOCK_GATE	BIT(2)
+
+#define BRCMSTB_PRIV_FLAGS_HAS_CQE		BIT(0)
+#define BRCMSTB_PRIV_FLAGS_GATE_CLOCK		BIT(1)
 
 #define SDHCI_ARASAN_CQE_BASE_ADDR		0x200
 
 struct sdhci_brcmstb_priv {
 	void __iomem *cfg_regs;
-	bool has_cqe;
+	unsigned int flags;
 };
 
 struct brcmstb_match_priv {
 	void (*hs400es)(struct mmc_host *mmc, struct mmc_ios *ios);
 	struct sdhci_ops *ops;
-	unsigned int flags;
+	const unsigned int flags;
 };
 
+static inline void enable_clock_gating(struct sdhci_host *host)
+{
+	u32 reg;
+
+	reg = sdhci_readl(host, SDHCI_VENDOR);
+	reg |= SDHCI_VENDOR_GATE_SDCLK_EN;
+	sdhci_writel(host, reg, SDHCI_VENDOR);
+}
+
+void brcmstb_reset(struct sdhci_host *host, u8 mask)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_brcmstb_priv *priv = sdhci_pltfm_priv(pltfm_host);
+
+	sdhci_and_cqhci_reset(host, mask);
+
+	/* Reset will clear this, so re-enable it */
+	if (priv->flags & BRCMSTB_PRIV_FLAGS_GATE_CLOCK)
+		enable_clock_gating(host);
+}
+
 static void sdhci_brcmstb_hs400es(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
@@ -129,22 +156,23 @@ static struct sdhci_ops sdhci_brcmstb_ops = {
 static struct sdhci_ops sdhci_brcmstb_ops_7216 = {
 	.set_clock = sdhci_brcmstb_set_clock,
 	.set_bus_width = sdhci_set_bus_width,
-	.reset = sdhci_reset,
+	.reset = brcmstb_reset,
 	.set_uhs_signaling = sdhci_brcmstb_set_uhs_signaling,
 };
 
 static struct brcmstb_match_priv match_priv_7425 = {
-	.flags = BRCMSTB_PRIV_FLAGS_NO_64BIT |
-	BRCMSTB_PRIV_FLAGS_BROKEN_TIMEOUT,
+	.flags = BRCMSTB_MATCH_FLAGS_NO_64BIT |
+	BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT,
 	.ops = &sdhci_brcmstb_ops,
 };
 
 static struct brcmstb_match_priv match_priv_7445 = {
-	.flags = BRCMSTB_PRIV_FLAGS_BROKEN_TIMEOUT,
+	.flags = BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT,
 	.ops = &sdhci_brcmstb_ops,
 };
 
 static const struct brcmstb_match_priv match_priv_7216 = {
+	.flags = BRCMSTB_MATCH_FLAGS_HAS_CLOCK_GATE,
 	.hs400es = sdhci_brcmstb_hs400es,
 	.ops = &sdhci_brcmstb_ops_7216,
 };
@@ -176,7 +204,7 @@ static int sdhci_brcmstb_add_host(struct sdhci_host *host,
 	bool dma64;
 	int ret;
 
-	if (!priv->has_cqe)
+	if ((priv->flags & BRCMSTB_PRIV_FLAGS_HAS_CQE) == 0)
 		return sdhci_add_host(host);
 
 	dev_dbg(mmc_dev(host->mmc), "CQE is enabled\n");
@@ -225,7 +253,6 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 	struct sdhci_brcmstb_priv *priv;
 	struct sdhci_host *host;
 	struct resource *iomem;
-	bool has_cqe = false;
 	struct clk *clk;
 	int res;
 
@@ -244,10 +271,6 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 		return res;
 
 	memset(&brcmstb_pdata, 0, sizeof(brcmstb_pdata));
-	if (device_property_read_bool(&pdev->dev, "supports-cqe")) {
-		has_cqe = true;
-		match_priv->ops->irq = sdhci_brcmstb_cqhci_irq;
-	}
 	brcmstb_pdata.ops = match_priv->ops;
 	host = sdhci_pltfm_init(pdev, &brcmstb_pdata,
 				sizeof(struct sdhci_brcmstb_priv));
@@ -258,7 +281,10 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 
 	pltfm_host = sdhci_priv(host);
 	priv = sdhci_pltfm_priv(pltfm_host);
-	priv->has_cqe = has_cqe;
+	if (device_property_read_bool(&pdev->dev, "supports-cqe")) {
+		priv->flags |= BRCMSTB_PRIV_FLAGS_HAS_CQE;
+		match_priv->ops->irq = sdhci_brcmstb_cqhci_irq;
+	}
 
 	/* Map in the non-standard CFG registers */
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -273,6 +299,14 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 	if (res)
 		goto err;
 
+	/*
+	 * Automatic clock gating does not work for SD cards that may
+	 * voltage switch so only enable it for non-removable devices.
+	 */
+	if ((match_priv->flags & BRCMSTB_MATCH_FLAGS_HAS_CLOCK_GATE) &&
+	    (host->mmc->caps & MMC_CAP_NONREMOVABLE))
+		priv->flags |= BRCMSTB_PRIV_FLAGS_GATE_CLOCK;
+
 	/*
 	 * If the chip has enhanced strobe and it's enabled, add
 	 * callback
@@ -287,14 +321,14 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 	 * properties through mmc_of_parse().
 	 */
 	host->caps = sdhci_readl(host, SDHCI_CAPABILITIES);
-	if (match_priv->flags & BRCMSTB_PRIV_FLAGS_NO_64BIT)
+	if (match_priv->flags & BRCMSTB_MATCH_FLAGS_NO_64BIT)
 		host->caps &= ~SDHCI_CAN_64BIT;
 	host->caps1 = sdhci_readl(host, SDHCI_CAPABILITIES_1);
 	host->caps1 &= ~(SDHCI_SUPPORT_SDR50 | SDHCI_SUPPORT_SDR104 |
 			 SDHCI_SUPPORT_DDR50);
 	host->quirks |= SDHCI_QUIRK_MISSING_CAPS;
 
-	if (match_priv->flags & BRCMSTB_PRIV_FLAGS_BROKEN_TIMEOUT)
+	if (match_priv->flags & BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT)
 		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
 	res = sdhci_brcmstb_add_host(host, priv);
diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
index b88a109b3b15..26ee263d8f3a 100644
--- a/drivers/net/arcnet/com20020_cs.c
+++ b/drivers/net/arcnet/com20020_cs.c
@@ -113,6 +113,7 @@ static int com20020_probe(struct pcmcia_device *p_dev)
 	struct com20020_dev *info;
 	struct net_device *dev;
 	struct arcnet_local *lp;
+	int ret = -ENOMEM;
 
 	dev_dbg(&p_dev->dev, "com20020_attach()\n");
 
@@ -142,12 +143,18 @@ static int com20020_probe(struct pcmcia_device *p_dev)
 	info->dev = dev;
 	p_dev->priv = info;
 
-	return com20020_config(p_dev);
+	ret = com20020_config(p_dev);
+	if (ret)
+		goto fail_config;
+
+	return 0;
 
+fail_config:
+	free_arcdev(dev);
 fail_alloc_dev:
 	kfree(info);
 fail_alloc_info:
-	return -ENOMEM;
+	return ret;
 } /* com20020_attach */
 
 static void com20020_detach(struct pcmcia_device *link)
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 215dd17ca790..4059fcc8c832 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -256,6 +256,9 @@ static int sja1105_base_tx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	u32 tmp;
 	int rc;
 
+	if (reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	rc = sja1105_xfer_u32(priv, SPI_READ, regs->mdio_100base_tx + reg,
 			      &tmp, NULL);
 	if (rc < 0)
@@ -272,6 +275,9 @@ static int sja1105_base_tx_mdio_write(struct mii_bus *bus, int phy, int reg,
 	const struct sja1105_regs *regs = priv->info->regs;
 	u32 tmp = val;
 
+	if (reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	return sja1105_xfer_u32(priv, SPI_WRITE, regs->mdio_100base_tx + reg,
 				&tmp, NULL);
 }
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 561395731450..a9f202bbada1 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -795,16 +795,20 @@ static void bnx2x_vf_enable_traffic(struct bnx2x *bp, struct bnx2x_virtf *vf)
 
 static u8 bnx2x_vf_is_pcie_pending(struct bnx2x *bp, u8 abs_vfid)
 {
-	struct pci_dev *dev;
 	struct bnx2x_virtf *vf = bnx2x_vf_by_abs_fid(bp, abs_vfid);
+	struct pci_dev *dev;
+	bool pending;
 
 	if (!vf)
 		return false;
 
 	dev = pci_get_domain_bus_and_slot(vf->domain, vf->bus, vf->devfn);
-	if (dev)
-		return bnx2x_is_pcie_pending(dev);
-	return false;
+	if (!dev)
+		return false;
+	pending = bnx2x_is_pcie_pending(dev);
+	pci_dev_put(dev);
+
+	return pending;
 }
 
 int bnx2x_vf_flr_clnup_epilog(struct bnx2x *bp, u8 abs_vfid)
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7bd97d98afeb..ae68821dd56d 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1798,7 +1798,7 @@ static int liquidio_open(struct net_device *netdev)
 
 	ifstate_set(lio, LIO_IFSTATE_RUNNING);
 
-	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on)) {
+	if (!OCTEON_CN23XX_PF(oct) || !oct->msix_on) {
 		ret = setup_tx_poll_fn(netdev);
 		if (ret)
 			goto err_poll;
@@ -1828,7 +1828,7 @@ static int liquidio_open(struct net_device *netdev)
 	return 0;
 
 err_rx_ctrl:
-	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on))
+	if (!OCTEON_CN23XX_PF(oct) || !oct->msix_on)
 		cleanup_tx_poll_fn(netdev);
 err_poll:
 	if (lio->ptp_clock) {
diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index c36fed9c3d73..daaffae1a89f 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1435,8 +1435,10 @@ static acpi_status bgx_acpi_match_id(acpi_handle handle, u32 lvl,
 		return AE_OK;
 	}
 
-	if (strncmp(string.pointer, bgx_sel, 4))
+	if (strncmp(string.pointer, bgx_sel, 4)) {
+		kfree(string.pointer);
 		return AE_OK;
+	}
 
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
 			    bgx_acpi_register_phy, NULL, bgx, NULL);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 77d765809c1e..222a250fba84 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1768,7 +1768,7 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	/* enable Tx ints by setting pkt thr to 1 */
 	enetc_txbdr_wr(hw, idx, ENETC_TBICR0, ENETC_TBICR0_ICEN | 0x1);
 
-	tbmr = ENETC_TBMR_EN;
+	tbmr = ENETC_TBMR_EN | ENETC_TBMR_SET_PRIO(tx_ring->prio);
 	if (tx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
 		tbmr |= ENETC_TBMR_VIH;
 
@@ -1831,13 +1831,14 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 
 static void enetc_setup_bdrs(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_setup_txbdr(&priv->si->hw, priv->tx_ring[i]);
+		enetc_setup_txbdr(hw, priv->tx_ring[i]);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_setup_rxbdr(&priv->si->hw, priv->rx_ring[i]);
+		enetc_setup_rxbdr(hw, priv->rx_ring[i]);
 }
 
 static void enetc_clear_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
@@ -1870,13 +1871,14 @@ static void enetc_clear_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 
 static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_clear_txbdr(&priv->si->hw, priv->tx_ring[i]);
+		enetc_clear_txbdr(hw, priv->tx_ring[i]);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_clear_rxbdr(&priv->si->hw, priv->rx_ring[i]);
+		enetc_clear_rxbdr(hw, priv->rx_ring[i]);
 
 	udelay(1);
 }
@@ -1884,13 +1886,13 @@ static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
 static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
+	struct enetc_hw *hw = &priv->si->hw;
 	int i, j, err;
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		int irq = pci_irq_vector(pdev, ENETC_BDR_INT_BASE_IDX + i);
 		struct enetc_int_vector *v = priv->int_vector[i];
 		int entry = ENETC_BDR_INT_BASE_IDX + i;
-		struct enetc_hw *hw = &priv->si->hw;
 
 		snprintf(v->name, sizeof(v->name), "%s-rxtx%d",
 			 priv->ndev->name, i);
@@ -1978,13 +1980,14 @@ static void enetc_setup_interrupts(struct enetc_ndev_priv *priv)
 
 static void enetc_clear_interrupts(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_txbdr_wr(&priv->si->hw, i, ENETC_TBIER, 0);
+		enetc_txbdr_wr(hw, i, ENETC_TBIER, 0);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_rxbdr_wr(&priv->si->hw, i, ENETC_RBIER, 0);
+		enetc_rxbdr_wr(hw, i, ENETC_RBIER, 0);
 }
 
 static int enetc_phylink_connect(struct net_device *ndev)
@@ -2151,6 +2154,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_bdr *tx_ring;
 	int num_stack_tx_queues;
 	u8 num_tc;
@@ -2167,7 +2171,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
 			tx_ring = priv->tx_ring[i];
-			enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, 0);
+			tx_ring->prio = 0;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
 		}
 
 		return 0;
@@ -2186,7 +2191,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	 */
 	for (i = 0; i < num_tc; i++) {
 		tx_ring = priv->tx_ring[i];
-		enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, i);
+		tx_ring->prio = i;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
 	}
 
 	/* Reset the number of netdev queues based on the TC count */
@@ -2296,19 +2302,21 @@ static int enetc_set_rss(struct net_device *ndev, int en)
 static void enetc_enable_rxvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_bdr_enable_rxvlan(&priv->si->hw, i, en);
+		enetc_bdr_enable_rxvlan(hw, i, en);
 }
 
 static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_bdr_enable_txvlan(&priv->si->hw, i, en);
+		enetc_bdr_enable_txvlan(hw, i, en);
 }
 
 void enetc_set_features(struct net_device *ndev, netdev_features_t features)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index f304cdb854ec..a3b936375c56 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -91,6 +91,7 @@ struct enetc_bdr {
 		void __iomem *rcir;
 	};
 	u16 index;
+	u16 prio;
 	int bd_count; /* # of BDs */
 	int next_to_use;
 	int next_to_clean;
@@ -423,19 +424,20 @@ int enetc_set_psfp(struct net_device *ndev, bool en);
 
 static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 reg;
 
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PSIDCAPR);
+	reg = enetc_port_rd(hw, ENETC_PSIDCAPR);
 	priv->psfp_cap.max_streamid = reg & ENETC_PSIDCAPR_MSK;
 	/* Port stream filter capability */
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PSFCAPR);
+	reg = enetc_port_rd(hw, ENETC_PSFCAPR);
 	priv->psfp_cap.max_psfp_filter = reg & ENETC_PSFCAPR_MSK;
 	/* Port stream gate capability */
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PSGCAPR);
+	reg = enetc_port_rd(hw, ENETC_PSGCAPR);
 	priv->psfp_cap.max_psfp_gate = (reg & ENETC_PSGCAPR_SGIT_MSK);
 	priv->psfp_cap.max_psfp_gatelist = (reg & ENETC_PSGCAPR_GCL_MSK) >> 16;
 	/* Port flow meter capability */
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PFMCAPR);
+	reg = enetc_port_rd(hw, ENETC_PFMCAPR);
 	priv->psfp_cap.max_psfp_meter = reg & ENETC_PFMCAPR_MSK;
 }
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 3615357cc60f..5efb079ef25f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -800,9 +800,6 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
-	if (si->hw_features & ENETC_SI_F_QBV)
-		priv->active_offloads |= ENETC_F_QBV;
-
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
 		ndev->features |= NETIF_F_HW_TC;
@@ -1053,7 +1050,8 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	int idx;
 
 	priv = netdev_priv(pf->si->ndev);
-	if (priv->active_offloads & ENETC_F_QBV)
+
+	if (pf->si->hw_features & ENETC_SI_F_QBV)
 		enetc_sched_speed_set(priv, speed);
 
 	if (!phylink_autoneg_inband(mode) &&
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 6b236e0fd806..ba51fb381f0c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -17,8 +17,9 @@ static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 old_speed = priv->speed;
-	u32 pspeed;
+	u32 pspeed, tmp;
 
 	if (speed == old_speed)
 		return;
@@ -39,10 +40,8 @@ void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 	}
 
 	priv->speed = speed;
-	enetc_port_wr(&priv->si->hw, ENETC_PMR,
-		      (enetc_port_rd(&priv->si->hw, ENETC_PMR)
-		      & (~ENETC_PMR_PSPEED_MASK))
-		      | pspeed);
+	tmp = enetc_port_rd(hw, ENETC_PMR);
+	enetc_port_wr(hw, ENETC_PMR, (tmp & ~ENETC_PMR_PSPEED_MASK) | pspeed);
 }
 
 #define ENETC_QOS_ALIGN	64
@@ -50,6 +49,7 @@ static int enetc_setup_taprio(struct net_device *ndev,
 			      struct tc_taprio_qopt_offload *admin_conf)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct tgs_gcl_conf *gcl_config;
 	struct tgs_gcl_data *gcl_data;
@@ -62,15 +62,16 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	int err;
 	int i;
 
-	if (admin_conf->num_entries > enetc_get_max_gcl_len(&priv->si->hw))
+	if (admin_conf->num_entries > enetc_get_max_gcl_len(hw))
 		return -EINVAL;
 	gcl_len = admin_conf->num_entries;
 
-	tge = enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET);
+	tge = enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET);
 	if (!admin_conf->enable) {
-		enetc_wr(&priv->si->hw,
-			 ENETC_QBV_PTGCR_OFFSET,
-			 tge & (~ENETC_QBV_TGE));
+		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+
+		priv->active_offloads &= ~ENETC_F_QBV;
+
 		return 0;
 	}
 
@@ -124,18 +125,18 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
-	enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET,
-		 tge | ENETC_QBV_TGE);
+	enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge | ENETC_QBV_TGE);
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
-		enetc_wr(&priv->si->hw,
-			 ENETC_QBV_PTGCR_OFFSET,
-			 tge & (~ENETC_QBV_TGE));
+		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
 
 	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
 			  tmp, dma);
 
+	if (!err)
+		priv->active_offloads |= ENETC_F_QBV;
+
 	return err;
 }
 
@@ -143,6 +144,8 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_bdr *tx_ring;
 	int err;
 	int i;
 
@@ -151,18 +154,20 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 		if (priv->tx_ring[i]->tsd_enable)
 			return -EBUSY;
 
-	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_set_bdr_prio(&priv->si->hw,
-				   priv->tx_ring[i]->index,
-				   taprio->enable ? i : 0);
+	for (i = 0; i < priv->num_tx_rings; i++) {
+		tx_ring = priv->tx_ring[i];
+		tx_ring->prio = taprio->enable ? i : 0;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+	}
 
 	err = enetc_setup_taprio(ndev, taprio);
-
-	if (err)
-		for (i = 0; i < priv->num_tx_rings; i++)
-			enetc_set_bdr_prio(&priv->si->hw,
-					   priv->tx_ring[i]->index,
-					   taprio->enable ? 0 : i);
+	if (err) {
+		for (i = 0; i < priv->num_tx_rings; i++) {
+			tx_ring = priv->tx_ring[i];
+			tx_ring->prio = taprio->enable ? 0 : i;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+		}
+	}
 
 	return err;
 }
@@ -183,7 +188,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	struct tc_cbs_qopt_offload *cbs = type_data;
 	u32 port_transmit_rate = priv->speed;
 	u8 tc_nums = netdev_get_num_tc(ndev);
-	struct enetc_si *si = priv->si;
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 hi_credit_bit, hi_credit_reg;
 	u32 max_interference_size;
 	u32 port_frame_max_size;
@@ -204,15 +209,15 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		 * lower than this TC have been disabled.
 		 */
 		if (tc == prio_top &&
-		    enetc_get_cbs_enable(&si->hw, prio_next)) {
+		    enetc_get_cbs_enable(hw, prio_next)) {
 			dev_err(&ndev->dev,
 				"Disable TC%d before disable TC%d\n",
 				prio_next, tc);
 			return -EINVAL;
 		}
 
-		enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), 0);
-		enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), 0);
+		enetc_port_wr(hw, ENETC_PTCCBSR1(tc), 0);
+		enetc_port_wr(hw, ENETC_PTCCBSR0(tc), 0);
 
 		return 0;
 	}
@@ -229,13 +234,13 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	 * higher than this TC have been enabled.
 	 */
 	if (tc == prio_next) {
-		if (!enetc_get_cbs_enable(&si->hw, prio_top)) {
+		if (!enetc_get_cbs_enable(hw, prio_top)) {
 			dev_err(&ndev->dev,
 				"Enable TC%d first before enable TC%d\n",
 				prio_top, prio_next);
 			return -EINVAL;
 		}
-		bw_sum += enetc_get_cbs_bw(&si->hw, prio_top);
+		bw_sum += enetc_get_cbs_bw(hw, prio_top);
 	}
 
 	if (bw_sum + bw >= 100) {
@@ -244,7 +249,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 	}
 
-	enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
+	enetc_port_rd(hw, ENETC_PTCMSDUR(tc));
 
 	/* For top prio TC, the max_interfrence_size is maxSizedFrame.
 	 *
@@ -264,8 +269,8 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		u32 m0, ma, r0, ra;
 
 		m0 = port_frame_max_size * 8;
-		ma = enetc_port_rd(&si->hw, ENETC_PTCMSDUR(prio_top)) * 8;
-		ra = enetc_get_cbs_bw(&si->hw, prio_top) *
+		ma = enetc_port_rd(hw, ENETC_PTCMSDUR(prio_top)) * 8;
+		ra = enetc_get_cbs_bw(hw, prio_top) *
 			port_transmit_rate * 10000ULL;
 		r0 = port_transmit_rate * 1000000ULL;
 		max_interference_size = m0 + ma +
@@ -285,10 +290,10 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	hi_credit_reg = (u32)div_u64((ENETC_CLK * 100ULL) * hi_credit_bit,
 				     port_transmit_rate * 1000000ULL);
 
-	enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
+	enetc_port_wr(hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
 
 	/* Set bw register and enable this traffic class */
-	enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
+	enetc_port_wr(hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
 
 	return 0;
 }
@@ -298,6 +303,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_etf_qopt_offload *qopt = type_data;
 	u8 tc_nums = netdev_get_num_tc(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int tc;
 
 	if (!tc_nums)
@@ -313,12 +319,11 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 		return -EBUSY;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
-	if (enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
+	if (enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
 		return -EBUSY;
 
 	priv->tx_ring[tc]->tsd_enable = qopt->enable;
-	enetc_port_wr(&priv->si->hw, ENETC_PTCTSDR(tc),
-		      qopt->enable ? ENETC_TSDE : 0);
+	enetc_port_wr(hw, ENETC_PTCTSDR(tc), qopt->enable ? ENETC_TSDE : 0);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 629ebdfa48b8..4b2e99be7ef5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2270,7 +2270,6 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	iavf_free_queues(adapter);
 	memset(adapter->vf_res, 0, IAVF_VIRTCHNL_VF_RESOURCE_SIZE);
 	iavf_shutdown_adminq(&adapter->hw);
-	adapter->netdev->flags &= ~IFF_UP;
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
 	iavf_change_state(adapter, __IAVF_DOWN);
 	wake_up(&adapter->down_waitqueue);
@@ -2369,6 +2368,11 @@ static void iavf_reset_task(struct work_struct *work)
 		iavf_disable_vf(adapter);
 		mutex_unlock(&adapter->client_lock);
 		mutex_unlock(&adapter->crit_lock);
+		if (netif_running(netdev)) {
+			rtnl_lock();
+			dev_close(netdev);
+			rtnl_unlock();
+		}
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
 
@@ -2381,6 +2385,7 @@ static void iavf_reset_task(struct work_struct *work)
 
 	if (running) {
 		netif_carrier_off(netdev);
+		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
 		iavf_napi_disable_all(adapter);
 	}
@@ -2503,6 +2508,16 @@ static void iavf_reset_task(struct work_struct *work)
 
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
+
+	if (netif_running(netdev)) {
+		/* Close device to ensure that Tx queues will not be started
+		 * during netif_device_attach() at the end of the reset task.
+		 */
+		rtnl_lock();
+		dev_close(netdev);
+		rtnl_unlock();
+	}
+
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 reset_finish:
 	rtnl_lock();
@@ -4174,23 +4189,21 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 static void iavf_remove(struct pci_dev *pdev)
 {
 	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
-	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
+	struct iavf_cloud_filter *cf, *cftmp;
 	struct iavf_adv_rss *rss, *rsstmp;
 	struct iavf_mac_filter *f, *ftmp;
-	struct iavf_cloud_filter *cf, *cftmp;
-	struct iavf_hw *hw = &adapter->hw;
+	struct net_device *netdev;
+	struct iavf_hw *hw;
 	int err;
 
-	/* When reboot/shutdown is in progress no need to do anything
-	 * as the adapter is already REMOVE state that was set during
-	 * iavf_shutdown() callback.
-	 */
-	if (adapter->state == __IAVF_REMOVE)
+	netdev = adapter->netdev;
+	hw = &adapter->hw;
+
+	if (test_and_set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
 		return;
 
-	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
 	/* Wait until port initialization is complete.
 	 * There are flows where register/unregister netdev may race.
 	 */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ae586f8895fc..524913c28f3b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7356,6 +7356,7 @@ static int mvpp2_get_sram(struct platform_device *pdev,
 			  struct mvpp2 *priv)
 {
 	struct resource *res;
+	void __iomem *base;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
 	if (!res) {
@@ -7366,9 +7367,12 @@ static int mvpp2_get_sram(struct platform_device *pdev,
 		return 0;
 	}
 
-	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
-	return PTR_ERR_OR_ZERO(priv->cm3_base);
+	priv->cm3_base = base;
+	return 0;
 }
 
 static int mvpp2_probe(struct platform_device *pdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index f001579569a2..66d34699f160 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -441,6 +441,8 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
 		sprintf(lmac, "LMAC%d", lmac_id);
 		seq_printf(filp, "%s\t0x%x\t\tNIX%d\t\t%s\t%s\n",
 			   dev_name(&pdev->dev), pcifunc, blkid, cgx, lmac);
+
+		pci_dev_put(pdev);
 	}
 	return 0;
 }
@@ -2127,6 +2129,7 @@ static int cgx_print_dmac_flt(struct seq_file *s, int lmac_id)
 		}
 	}
 
+	pci_dev_put(pdev);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 603361c94786..09892703cfd4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4832,6 +4832,8 @@ static int nix_setup_ipolicers(struct rvu *rvu,
 		ipolicer->ref_count = devm_kcalloc(rvu->dev,
 						   ipolicer->band_prof.max,
 						   sizeof(u16), GFP_KERNEL);
+		if (!ipolicer->ref_count)
+			return -ENOMEM;
 	}
 
 	/* Set policer timeunit to 2us ie  (19 + 1) * 100 nsec = 2us */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
index b04fb226f708..ae50d56258ec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
@@ -62,15 +62,18 @@ int rvu_sdp_init(struct rvu *rvu)
 		pfvf->sdp_info = devm_kzalloc(rvu->dev,
 					      sizeof(struct sdp_node_info),
 					      GFP_KERNEL);
-		if (!pfvf->sdp_info)
+		if (!pfvf->sdp_info) {
+			pci_dev_put(pdev);
 			return -ENOMEM;
+		}
 
 		dev_info(rvu->dev, "SDP PF number:%d\n", sdp_pf_num[i]);
 
-		put_device(&pdev->dev);
 		i++;
 	}
 
+	pci_dev_put(pdev);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8601ef26c260..cc6a5b2f24e3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2327,8 +2327,10 @@ static int mtk_open(struct net_device *dev)
 		int err;
 
 		err = mtk_start_dma(eth);
-		if (err)
+		if (err) {
+			phylink_disconnect_phy(mac->phylink);
 			return err;
+		}
 
 		if (eth->soc->offload_version && mtk_ppe_start(&eth->ppe) == 0)
 			gdm_config = MTK_GDMA_TO_PPE;
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index b149e601f673..48cfaa7eaf50 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -697,7 +697,8 @@ static int mlx4_create_zones(struct mlx4_dev *dev,
 			err = mlx4_bitmap_init(*bitmap + k, 1,
 					       MLX4_QP_TABLE_RAW_ETH_SIZE - 1, 0,
 					       0);
-			mlx4_bitmap_alloc_range(*bitmap + k, 1, 1, 0);
+			if (!err)
+				mlx4_bitmap_alloc_range(*bitmap + k, 1, 1, 0);
 		}
 
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 98ca5d1ed45d..85190f2f4d50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -971,6 +971,7 @@ static void cmd_work_handler(struct work_struct *work)
 		cmd_ent_get(ent);
 	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
+	cmd_ent_get(ent); /* for the _real_ FW event on completion */
 	/* Skip sending command to fw if internal error */
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
 		u8 status = 0;
@@ -984,7 +985,6 @@ static void cmd_work_handler(struct work_struct *work)
 		return;
 	}
 
-	cmd_ent_get(ent); /* for the _real_ FW event on completion */
 	/* ring doorbell after the descriptor is valid */
 	mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 << ent->idx);
 	wmb();
@@ -1598,8 +1598,8 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				cmd_ent_put(ent); /* timeout work was canceled */
 
 			if (!forced || /* Real FW completion */
-			    pci_channel_offline(dev->pdev) || /* FW is inaccessible */
-			    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
+			     !opcode_allowed(cmd, ent->op))
 				cmd_ent_put(ent);
 
 			ent->ts2 = ktime_get_ns();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index ea46152816f9..326e0b170e36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -638,7 +638,7 @@ static void mlx5_tracer_handle_timestamp_trace(struct mlx5_fw_tracer *tracer,
 			trace_timestamp = (timestamp_event.timestamp & MASK_52_7) |
 					  (str_frmt->timestamp & MASK_6_0);
 		else
-			trace_timestamp = ((timestamp_event.timestamp & MASK_52_7) - 1) |
+			trace_timestamp = ((timestamp_event.timestamp - 1) & MASK_52_7) |
 					  (str_frmt->timestamp & MASK_6_0);
 
 		mlx5_tracer_print_trace(str_frmt, dev, trace_timestamp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d092261e96c3..19c11d33f4b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1608,7 +1608,8 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 	res = state == pci_channel_io_perm_failure ?
 		PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_NEED_RESET;
 
-	mlx5_pci_trace(dev, "Exit, result = %d, %s\n",  res, result2str(res));
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Exit, result = %d, %s\n",
+		       __func__, dev->state, dev->pci_status, res, result2str(res));
 	return res;
 }
 
@@ -1647,7 +1648,8 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_pci_trace(dev, "Enter\n");
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Enter\n",
+		       __func__, dev->state, dev->pci_status);
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
@@ -1669,7 +1671,8 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 
 	res = PCI_ERS_RESULT_RECOVERED;
 out:
-	mlx5_pci_trace(dev, "Exit, err = %d, result = %d, %s\n", err, res, result2str(res));
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Exit, err = %d, result = %d, %s\n",
+		       __func__, dev->state, dev->pci_status, err, res, result2str(res));
 	return res;
 }
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index cb68eaaac881..5c7b21ce64ed 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -83,7 +83,7 @@ static int sparx5_port_open(struct net_device *ndev)
 	err = phylink_of_phy_connect(port->phylink, port->of_node, 0);
 	if (err) {
 		netdev_err(ndev, "Could not attach to PHY\n");
-		return err;
+		goto err_connect;
 	}
 
 	phylink_start(port->phylink);
@@ -95,10 +95,20 @@ static int sparx5_port_open(struct net_device *ndev)
 			err = sparx5_serdes_set(port->sparx5, port, &port->conf);
 		else
 			err = phy_power_on(port->serdes);
-		if (err)
+		if (err) {
 			netdev_err(ndev, "%s failed\n", __func__);
+			goto out_power;
+		}
 	}
 
+	return 0;
+
+out_power:
+	phylink_stop(port->phylink);
+	phylink_disconnect_phy(port->phylink);
+err_connect:
+	sparx5_port_enable(port, false);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index bea978df7713..1647b6b180cc 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -363,7 +363,7 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 		return ret;
 
 	attrs.split = eth_port.is_split;
-	attrs.splittable = !attrs.split;
+	attrs.splittable = eth_port.port_lanes > 1 && !attrs.split;
 	attrs.lanes = eth_port.port_lanes;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = eth_port.label_port;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 865865adfefc..d295942968f3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1219,6 +1219,9 @@ nfp_port_get_module_info(struct net_device *netdev,
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	if (!port)
+		return -EOPNOTSUPP;
+
 	/* update port state to get latest interface */
 	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index ec3e558f890e..d555b4cc6049 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1148,6 +1148,7 @@ static void pch_gbe_tx_queue(struct pch_gbe_adapter *adapter,
 		buffer_info->dma = 0;
 		buffer_info->time_stamp = 0;
 		tx_ring->next_to_use = ring_num;
+		dev_kfree_skb_any(skb);
 		return;
 	}
 	buffer_info->mapped = true;
@@ -2464,6 +2465,7 @@ static void pch_gbe_remove(struct pci_dev *pdev)
 	unregister_netdev(netdev);
 
 	pch_gbe_phy_hw_reset(&adapter->hw);
+	pci_dev_put(adapter->ptp_pdev);
 
 	free_netdev(netdev);
 }
@@ -2539,7 +2541,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	/* setup the private structure */
 	ret = pch_gbe_sw_init(adapter);
 	if (ret)
-		goto err_free_netdev;
+		goto err_put_dev;
 
 	/* Initialize PHY */
 	ret = pch_gbe_init_phy(adapter);
@@ -2597,6 +2599,8 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 
 err_free_adapter:
 	pch_gbe_phy_hw_reset(&adapter->hw);
+err_put_dev:
+	pci_dev_put(adapter->ptp_pdev);
 err_free_netdev:
 	free_netdev(netdev);
 	return ret;
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 40d14d80f6f1..29837e533cee 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2469,6 +2469,7 @@ static netdev_tx_t ql3xxx_send(struct sk_buff *skb,
 					     skb_shinfo(skb)->nr_frags);
 	if (tx_cb->seg_count == -1) {
 		netdev_err(ndev, "%s: invalid segment count!\n", __func__);
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 67fe44db6b61..63a44ee763be 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -200,6 +200,7 @@ static netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
 		   skb->len, skb->data_len, channel->channel);
 	if (!efx->n_channels || !efx->n_tx_channels || !channel) {
 		netif_stop_queue(net_dev);
+		dev_kfree_skb_any(skb);
 		goto err;
 	}
 
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 4811bd1f3d74..aa9d0dfeda5a 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2644,11 +2644,6 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	if (ret)
 		goto rollback;
 
-	/* Force features update, since they are different for SW MACSec and
-	 * HW offloading cases.
-	 */
-	netdev_update_features(dev);
-
 	rtnl_unlock();
 	return 0;
 
@@ -3416,16 +3411,9 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-#define SW_MACSEC_FEATURES \
+#define MACSEC_FEATURES \
 	(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST)
 
-/* If h/w offloading is enabled, use real device features save for
- *   VLAN_FEATURES - they require additional ops
- *   HW_MACSEC - no reason to report it
- */
-#define REAL_DEV_FEATURES(dev) \
-	((dev)->features & ~(NETIF_F_VLAN_FEATURES | NETIF_F_HW_MACSEC))
-
 static int macsec_dev_init(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
@@ -3442,12 +3430,8 @@ static int macsec_dev_init(struct net_device *dev)
 		return err;
 	}
 
-	if (macsec_is_offloaded(macsec)) {
-		dev->features = REAL_DEV_FEATURES(real_dev);
-	} else {
-		dev->features = real_dev->features & SW_MACSEC_FEATURES;
-		dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
-	}
+	dev->features = real_dev->features & MACSEC_FEATURES;
+	dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
 
 	dev->needed_headroom = real_dev->needed_headroom +
 			       MACSEC_NEEDED_HEADROOM;
@@ -3476,10 +3460,7 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 
-	if (macsec_is_offloaded(macsec))
-		return REAL_DEV_FEATURES(real_dev);
-
-	features &= (real_dev->features & SW_MACSEC_FEATURES) |
+	features &= (real_dev->features & MACSEC_FEATURES) |
 		    NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES;
 	features |= NETIF_F_LLTX;
 
@@ -3827,7 +3808,6 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
-		int ret;
 
 		ops = macsec_get_ops(netdev_priv(dev), &ctx);
 		if (!ops) {
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6bf5c75f519d..d886f903e428 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1353,6 +1353,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x103a, 0)}, /* Telit LE910C4-WWX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
diff --git a/drivers/net/wireless/ath/ath11k/qmi.h b/drivers/net/wireless/ath/ath11k/qmi.h
index 3d5930330703..25940b683ea4 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.h
+++ b/drivers/net/wireless/ath/ath11k/qmi.h
@@ -27,7 +27,7 @@
 #define ATH11K_QMI_WLANFW_MAX_NUM_MEM_SEG_V01	52
 #define ATH11K_QMI_CALDB_SIZE			0x480000
 #define ATH11K_QMI_BDF_EXT_STR_LENGTH		0x20
-#define ATH11K_QMI_FW_MEM_REQ_SEGMENT_CNT	3
+#define ATH11K_QMI_FW_MEM_REQ_SEGMENT_CNT	5
 
 #define QMI_WLFW_REQUEST_MEM_IND_V01		0x0035
 #define QMI_WLFW_FW_MEM_READY_IND_V01		0x0037
diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 65dd8cff1b01..fc19ecbc4c08 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5233,7 +5233,7 @@ static int get_wep_tx_idx(struct airo_info *ai)
 	return -1;
 }
 
-static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
+static int set_wep_key(struct airo_info *ai, u16 index, const u8 *key,
 		       u16 keylen, int perm, int lock)
 {
 	static const unsigned char macaddr[ETH_ALEN] = { 0x01, 0, 0, 0, 0, 0 };
@@ -5284,7 +5284,7 @@ static void proc_wepkey_on_close(struct inode *inode, struct file *file)
 	struct net_device *dev = PDE_DATA(inode);
 	struct airo_info *ai = dev->ml_priv;
 	int i, rc;
-	char key[16];
+	u8 key[16];
 	u16 index = 0;
 	int j = 0;
 
@@ -5312,12 +5312,22 @@ static void proc_wepkey_on_close(struct inode *inode, struct file *file)
 	}
 
 	for (i = 0; i < 16*3 && data->wbuffer[i+j]; i++) {
+		int val;
+
+		if (i % 3 == 2)
+			continue;
+
+		val = hex_to_bin(data->wbuffer[i+j]);
+		if (val < 0) {
+			airo_print_err(ai->dev->name, "WebKey passed invalid key hex");
+			return;
+		}
 		switch(i%3) {
 		case 0:
-			key[i/3] = hex_to_bin(data->wbuffer[i+j])<<4;
+			key[i/3] = (u8)val << 4;
 			break;
 		case 1:
-			key[i/3] |= hex_to_bin(data->wbuffer[i+j]);
+			key[i/3] |= (u8)val;
 			break;
 		}
 	}
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b228567b2a73..c3c3b5aa87b0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -845,6 +845,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *cb;
 
 	if (!vp->assoc)
 		return;
@@ -866,6 +867,10 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	memcpy(hdr->addr2, mac, ETH_ALEN);
 	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
 
+	cb = IEEE80211_SKB_CB(skb);
+	cb->control.rates[0].count = 1;
+	cb->control.rates[1].idx = -1;
+
 	rcu_read_lock();
 	mac80211_hwsim_tx_frame(data->hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 87c14969c75f..1688144d7847 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -939,30 +939,52 @@ static inline void wilc_wfi_cfg_parse_ch_attr(u8 *buf, u32 len, u8 sta_ch)
 		return;
 
 	while (index + sizeof(*e) <= len) {
+		u16 attr_size;
+
 		e = (struct wilc_attr_entry *)&buf[index];
-		if (e->attr_type == IEEE80211_P2P_ATTR_CHANNEL_LIST)
+		attr_size = le16_to_cpu(e->attr_len);
+
+		if (index + sizeof(*e) + attr_size > len)
+			return;
+
+		if (e->attr_type == IEEE80211_P2P_ATTR_CHANNEL_LIST &&
+		    attr_size >= (sizeof(struct wilc_attr_ch_list) - sizeof(*e)))
 			ch_list_idx = index;
-		else if (e->attr_type == IEEE80211_P2P_ATTR_OPER_CHANNEL)
+		else if (e->attr_type == IEEE80211_P2P_ATTR_OPER_CHANNEL &&
+			 attr_size == (sizeof(struct wilc_attr_oper_ch) - sizeof(*e)))
 			op_ch_idx = index;
+
 		if (ch_list_idx && op_ch_idx)
 			break;
-		index += le16_to_cpu(e->attr_len) + sizeof(*e);
+
+		index += sizeof(*e) + attr_size;
 	}
 
 	if (ch_list_idx) {
-		u16 attr_size;
-		struct wilc_ch_list_elem *e;
-		int i;
+		unsigned int i;
+		u16 elem_size;
 
 		ch_list = (struct wilc_attr_ch_list *)&buf[ch_list_idx];
-		attr_size = le16_to_cpu(ch_list->attr_len);
-		for (i = 0; i < attr_size;) {
+		/* the number of bytes following the final 'elem' member */
+		elem_size = le16_to_cpu(ch_list->attr_len) -
+			(sizeof(*ch_list) - sizeof(struct wilc_attr_entry));
+		for (i = 0; i < elem_size;) {
+			struct wilc_ch_list_elem *e;
+
 			e = (struct wilc_ch_list_elem *)(ch_list->elem + i);
+
+			i += sizeof(*e);
+			if (i > elem_size)
+				break;
+
+			i += e->no_of_channels;
+			if (i > elem_size)
+				break;
+
 			if (e->op_class == WILC_WLAN_OPERATING_CLASS_2_4GHZ) {
 				memset(e->ch_list, sta_ch, e->no_of_channels);
 				break;
 			}
-			i += e->no_of_channels;
 		}
 	}
 
diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
index a133736a7821..3e5cc947b9b9 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -467,14 +467,25 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 
 	rsn_ie = cfg80211_find_ie(WLAN_EID_RSN, ies->data, ies->len);
 	if (rsn_ie) {
+		int rsn_ie_len = sizeof(struct element) + rsn_ie[1];
 		int offset = 8;
 
-		param->mode_802_11i = 2;
-		param->rsn_found = true;
 		/* extract RSN capabilities */
-		offset += (rsn_ie[offset] * 4) + 2;
-		offset += (rsn_ie[offset] * 4) + 2;
-		memcpy(param->rsn_cap, &rsn_ie[offset], 2);
+		if (offset < rsn_ie_len) {
+			/* skip over pairwise suites */
+			offset += (rsn_ie[offset] * 4) + 2;
+
+			if (offset < rsn_ie_len) {
+				/* skip over authentication suites */
+				offset += (rsn_ie[offset] * 4) + 2;
+
+				if (offset + 1 < rsn_ie_len) {
+					param->mode_802_11i = 2;
+					param->rsn_found = true;
+					memcpy(param->rsn_cap, &rsn_ie[offset], 2);
+				}
+			}
+		}
 	}
 
 	if (param->rsn_found) {
diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 01df23835be0..8b4222b137d1 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -249,7 +249,7 @@ static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 	if (object->integer.value == 3)
 		sleep_state = IPC_PCIE_D3L2;
 
-	kfree(object);
+	ACPI_FREE(object);
 
 default_ret:
 	return sleep_state;
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 5fd89f72969d..04a2cea6d6b6 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -312,6 +312,8 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 	int r = 0;
 	struct device *dev = &ndev->nfc_dev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -325,26 +327,47 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		 * Description  Tag     Length
 		 * AID          81      5 to 16
 		 * PARAMETERS   82      0 to 255
+		 *
+		 * The key differences are aid storage length is variably sized
+		 * in the packet, but fixed in nfc_evt_transaction, and that
+		 * the aid_len is u8 in the packet, but u32 in the structure,
+		 * and the tags in the packet are not included in
+		 * nfc_evt_transaction.
+		 *
+		 * size(b):  1          1       5-16 1             1           0-255
+		 * offset:   0          1       2    aid_len + 2   aid_len + 3 aid_len + 4
+		 * mem name: aid_tag(M) aid_len aid  params_tag(M) params_len  params
+		 * example:  0x81       5-16    X    0x82          0-255       X
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
-		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
+		if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-		transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
-		if (!transaction)
-			return -ENOMEM;
+		aid_len = skb->data[1];
 
-		transaction->aid_len = skb->data[1];
-		memcpy(transaction->aid, &skb->data[2], transaction->aid_len);
+		if (skb->len < aid_len + 4 ||
+		    aid_len > sizeof(transaction->aid))
+			return -EPROTO;
 
-		/* Check next byte is PARAMETERS tag (82) */
-		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		params_len = skb->data[aid_len + 3];
+
+		/* Verify PARAMETERS tag is (82), and final check that there is
+		 * enough space in the packet to read everything.
+		 */
+		if (skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG ||
+		    skb->len < aid_len + 4 + params_len)
 			return -EPROTO;
 
-		transaction->params_len = skb->data[transaction->aid_len + 3];
-		memcpy(transaction->params, skb->data +
-		       transaction->aid_len + 4, transaction->params_len);
+		transaction = devm_kzalloc(dev, sizeof(*transaction) +
+					   params_len, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
+
+		transaction->aid_len = aid_len;
+		transaction->params_len = params_len;
+
+		memcpy(transaction->aid, &skb->data[2], aid_len);
+		memcpy(transaction->params, &skb->data[aid_len + 4],
+		       params_len);
 
 		r = nfc_se_transaction(ndev->nfc_dev, host, transaction);
 		break;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e9f3701dda3f..772bdc6845fb 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3351,6 +3351,10 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1cc1, 0x8201),   /* ADATA SX8200PNP 512GB */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	 { PCI_DEVICE(0x1344, 0x5407), /* Micron Technology Inc NVMe SSD */
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN },
+	 { PCI_DEVICE(0x1344, 0x6001),   /* Micron Nitro NVMe */
+		 .driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
@@ -3361,6 +3365,20 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x2646, 0x5018),   /* KINGSTON OM8SFP4xxxxP OS21012 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x5016),   /* KINGSTON OM3PGP4xxxxP OS21011 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x501A),   /* KINGSTON OM8PGP4xxxxP OS21005 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x501B),   /* KINGSTON OM8PGP4xxxxQ OS21005 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index cea30e4f5053..625038057a76 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1189,6 +1189,7 @@ static ssize_t nvmet_subsys_attr_model_store_locked(struct nvmet_subsys *subsys,
 		const char *page, size_t count)
 {
 	int pos = 0, len;
+	char *val;
 
 	if (subsys->subsys_discovered) {
 		pr_err("Can't set model number. %s is already assigned\n",
@@ -1211,9 +1212,11 @@ static ssize_t nvmet_subsys_attr_model_store_locked(struct nvmet_subsys *subsys,
 			return -EINVAL;
 	}
 
-	subsys->model_number = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!subsys->model_number)
+	val = kmemdup_nul(page, len, GFP_KERNEL);
+	if (!val)
 		return -ENOMEM;
+	kfree(subsys->model_number);
+	subsys->model_number = val;
 	return count;
 }
 
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 8c2a73d5428d..82516796a53b 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -564,6 +564,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = (void *)ACER_CAP_KBD_DOCK,
 	},
+	{
+		.callback = set_force_caps,
+		.ident = "Acer Aspire Switch V 10 SW5-017",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SW5-017"),
+		},
+		.driver_data = (void *)ACER_CAP_KBD_DOCK,
+	},
 	{
 		.callback = set_force_caps,
 		.ident = "Acer One 10 (S1003)",
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index e14fb5fa7324..f030ea97f126 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1511,6 +1511,8 @@ static void asus_wmi_set_xusb2pr(struct asus_wmi *asus)
 	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
 				cpu_to_le32(ports_available));
 
+	pci_dev_put(xhci_pdev);
+
 	pr_info("set USB_INTEL_XUSB2PR old: 0x%04x, new: 0x%04x\n",
 			orig_ports_available, ports_available);
 }
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 5a3a3cd89214..1e390dcee561 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -64,6 +64,7 @@ enum hp_wmi_event_ids {
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
 	HPWMI_SANITIZATION_MODE		= 0x17,
+	HPWMI_SMART_EXPERIENCE_APP	= 0x21,
 };
 
 struct bios_args {
@@ -641,6 +642,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		break;
 	case HPWMI_SANITIZATION_MODE:
 		break;
+	case HPWMI_SMART_EXPERIENCE_APP:
+		break;
 	default:
 		pr_info("Unknown event_id - %d - 0x%x\n", event_id, event_data);
 		break;
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index e7a1299e3776..7c553581e870 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -136,6 +136,7 @@ struct ideapad_private {
 		bool dytc                 : 1;
 		bool fan_mode             : 1;
 		bool fn_lock              : 1;
+		bool set_fn_lock_led      : 1;
 		bool hw_rfkill_switch     : 1;
 		bool kbd_bl               : 1;
 		bool touchpad_ctrl_via_ec : 1;
@@ -1467,6 +1468,9 @@ static void ideapad_wmi_notify(u32 value, void *context)
 		ideapad_input_report(priv, value);
 		break;
 	case 208:
+		if (!priv->features.set_fn_lock_led)
+			break;
+
 		if (!eval_hals(priv->adev->handle, &result)) {
 			bool state = test_bit(HALS_FNLOCK_STATE_BIT, &result);
 
@@ -1480,6 +1484,18 @@ static void ideapad_wmi_notify(u32 value, void *context)
 }
 #endif
 
+/* On some models we need to call exec_sals(SALS_FNLOCK_ON/OFF) to set the LED */
+static const struct dmi_system_id set_fn_lock_led_list[] = {
+	{
+		/* https://bugzilla.kernel.org/show_bug.cgi?id=212671 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Legion R7000P2020H"),
+		}
+	},
+	{}
+};
+
 /*
  * Some ideapads have a hardware rfkill switch, but most do not have one.
  * Reading VPCCMD_R_RF always results in 0 on models without a hardware rfkill,
@@ -1499,15 +1515,39 @@ static const struct dmi_system_id hw_rfkill_list[] = {
 	{}
 };
 
+static const struct dmi_system_id no_touchpad_switch_list[] = {
+	{
+	.ident = "Lenovo Yoga 3 Pro 1370",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo YOGA 3"),
+		},
+	},
+	{
+	.ident = "ZhaoYang K4e-IML",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ZhaoYang K4e-IML"),
+		},
+	},
+	{}
+};
+
 static void ideapad_check_features(struct ideapad_private *priv)
 {
 	acpi_handle handle = priv->adev->handle;
 	unsigned long val;
 
+	priv->features.set_fn_lock_led = dmi_check_system(set_fn_lock_led_list);
 	priv->features.hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
 
 	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
-	priv->features.touchpad_ctrl_via_ec = !acpi_dev_present("ELAN0634", NULL, -1);
+	if (acpi_dev_present("ELAN0634", NULL, -1))
+		priv->features.touchpad_ctrl_via_ec = 0;
+	else if (dmi_check_system(no_touchpad_switch_list))
+		priv->features.touchpad_ctrl_via_ec = 0;
+	else
+		priv->features.touchpad_ctrl_via_ec = 1;
 
 	if (!read_ec_data(handle, VPCCMD_R_FAN, &val))
 		priv->features.fan_mode = true;
diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index d7d6782c40c2..4d1c78635114 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -27,6 +27,9 @@ static const struct acpi_device_id intel_hid_ids[] = {
 	{"INTC1051", 0},
 	{"INTC1054", 0},
 	{"INTC1070", 0},
+	{"INTC1076", 0},
+	{"INTC1077", 0},
+	{"INTC1078", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, intel_hid_ids);
diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
index 659b1073033c..586a5877422b 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
@@ -18,6 +19,7 @@
 #define PMT_XA_START		0
 #define PMT_XA_MAX		INT_MAX
 #define PMT_XA_LIMIT		XA_LIMIT(PMT_XA_START, PMT_XA_MAX)
+#define GUID_SPR_PUNIT		0x9956f43f
 
 /*
  * Early implementations of PMT on client platforms have some
@@ -41,6 +43,29 @@ bool intel_pmt_is_early_client_hw(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(intel_pmt_is_early_client_hw);
 
+static inline int
+pmt_memcpy64_fromio(void *to, const u64 __iomem *from, size_t count)
+{
+	int i, remain;
+	u64 *buf = to;
+
+	if (!IS_ALIGNED((unsigned long)from, 8))
+		return -EFAULT;
+
+	for (i = 0; i < count/8; i++)
+		buf[i] = readq(&from[i]);
+
+	/* Copy any remaining bytes */
+	remain = count % 8;
+	if (remain) {
+		u64 tmp = readq(&from[i]);
+
+		memcpy(&buf[i], &tmp, remain);
+	}
+
+	return count;
+}
+
 /*
  * sysfs
  */
@@ -62,7 +87,11 @@ intel_pmt_read(struct file *filp, struct kobject *kobj,
 	if (count > entry->size - off)
 		count = entry->size - off;
 
-	memcpy_fromio(buf, entry->base + off, count);
+	if (entry->guid == GUID_SPR_PUNIT)
+		/* PUNIT on SPR only supports aligned 64-bit read */
+		count = pmt_memcpy64_fromio(buf, entry->base + off, count);
+	else
+		memcpy_fromio(buf, entry->base + off, count);
 
 	return count;
 }
diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index c608078538a7..3d0790263fa7 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -773,6 +773,22 @@ static const struct ts_dmi_data predia_basic_data = {
 	.properties	= predia_basic_props,
 };
 
+static const struct property_entry rca_cambio_w101_v2_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 4),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 20),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1644),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 874),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-rca-cambio-w101-v2.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data rca_cambio_w101_v2_data = {
+	.acpi_name = "MSSL1680:00",
+	.properties = rca_cambio_w101_v2_props,
+};
+
 static const struct property_entry rwc_nanote_p8_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 46),
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1728),
@@ -1394,6 +1410,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "0E57"),
 		},
 	},
+	{
+		/* RCA Cambio W101 v2 */
+		/* https://github.com/onitake/gsl-firmware/discussions/193 */
+		.driver_data = (void *)&rca_cambio_w101_v2_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "RCA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "W101SA23T1"),
+		},
+	},
 	{
 		/* RWC NANOTE P8 */
 		.driver_data = (void *)&rwc_nanote_p8_data,
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index aa4d78b02483..221ae807b379 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5071,6 +5071,7 @@ static void regulator_dev_release(struct device *dev)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
+	debugfs_remove_recursive(rdev->debugfs);
 	kfree(rdev->constraints);
 	of_node_put(rdev->dev.of_node);
 	kfree(rdev);
@@ -5549,11 +5550,15 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	mutex_lock(&regulator_list_mutex);
 	regulator_ena_gpio_free(rdev);
 	mutex_unlock(&regulator_list_mutex);
+	put_device(&rdev->dev);
+	rdev = NULL;
 clean:
 	if (dangling_of_gpiod)
 		gpiod_put(config->ena_gpiod);
+	if (rdev && rdev->dev.of_node)
+		of_node_put(rdev->dev.of_node);
+	kfree(rdev);
 	kfree(config);
-	put_device(&rdev->dev);
 rinse:
 	if (dangling_cfg_gpiod)
 		gpiod_put(cfg->ena_gpiod);
@@ -5582,7 +5587,6 @@ void regulator_unregister(struct regulator_dev *rdev)
 
 	mutex_lock(&regulator_list_mutex);
 
-	debugfs_remove_recursive(rdev->debugfs);
 	WARN_ON(rdev->open_count);
 	regulator_remove_coupling(rdev);
 	unset_regulator_supplies(rdev);
diff --git a/drivers/regulator/twl6030-regulator.c b/drivers/regulator/twl6030-regulator.c
index 430265c404d6..7c7e3648ea4b 100644
--- a/drivers/regulator/twl6030-regulator.c
+++ b/drivers/regulator/twl6030-regulator.c
@@ -530,6 +530,7 @@ static const struct twlreg_info TWL6030_INFO_##label = { \
 #define TWL6032_ADJUSTABLE_LDO(label, offset) \
 static const struct twlreg_info TWL6032_INFO_##label = { \
 	.base = offset, \
+	.features = TWL6032_SUBCLASS, \
 	.desc = { \
 		.name = #label, \
 		.id = TWL6032_REG_##label, \
@@ -562,6 +563,7 @@ static const struct twlreg_info TWLFIXED_INFO_##label = { \
 #define TWL6032_ADJUSTABLE_SMPS(label, offset) \
 static const struct twlreg_info TWLSMPS_INFO_##label = { \
 	.base = offset, \
+	.features = TWL6032_SUBCLASS, \
 	.desc = { \
 		.name = #label, \
 		.id = TWL6032_REG_##label, \
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index ff7b7d470e96..57dfc92aa756 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -4696,7 +4696,6 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_raw(struct dasd_device *startdev,
 	struct dasd_device *basedev;
 	struct req_iterator iter;
 	struct dasd_ccw_req *cqr;
-	unsigned int first_offs;
 	unsigned int trkcount;
 	unsigned long *idaws;
 	unsigned int size;
@@ -4730,7 +4729,6 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_raw(struct dasd_device *startdev,
 	last_trk = (blk_rq_pos(req) + blk_rq_sectors(req) - 1) /
 		DASD_RAW_SECTORS_PER_TRACK;
 	trkcount = last_trk - first_trk + 1;
-	first_offs = 0;
 
 	if (rq_data_dir(req) == READ)
 		cmd = DASD_ECKD_CCW_READ_TRACK;
@@ -4774,13 +4772,13 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_raw(struct dasd_device *startdev,
 
 	if (use_prefix) {
 		prefix_LRE(ccw++, data, first_trk, last_trk, cmd, basedev,
-			   startdev, 1, first_offs + 1, trkcount, 0, 0);
+			   startdev, 1, 0, trkcount, 0, 0);
 	} else {
 		define_extent(ccw++, data, first_trk, last_trk, cmd, basedev, 0);
 		ccw[-1].flags |= CCW_FLAG_CC;
 
 		data += sizeof(struct DE_eckd_data);
-		locate_record_ext(ccw++, data, first_trk, first_offs + 1,
+		locate_record_ext(ccw++, data, first_trk, 0,
 				  trkcount, cmd, basedev, 0, 0);
 	}
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b3531065a438..45ef78f388dc 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -708,8 +708,13 @@ static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 		memset(vhost->async_crq.msgs.async, 0, PAGE_SIZE);
 		vhost->async_crq.cur = 0;
 
-		list_for_each_entry(tgt, &vhost->targets, queue)
-			ibmvfc_del_tgt(tgt);
+		list_for_each_entry(tgt, &vhost->targets, queue) {
+			if (vhost->client_migrated)
+				tgt->need_login = 1;
+			else
+				ibmvfc_del_tgt(tgt);
+		}
+
 		scsi_block_requests(vhost->host);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
 		vhost->job_step = ibmvfc_npiv_login;
@@ -3235,9 +3240,12 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
 			/* We need to re-setup the interpartition connection */
 			dev_info(vhost->dev, "Partition migrated, Re-enabling adapter\n");
 			vhost->client_migrated = 1;
+
+			scsi_block_requests(vhost->host);
 			ibmvfc_purge_requests(vhost, DID_REQUEUE);
-			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+			ibmvfc_set_host_state(vhost, IBMVFC_LINK_DOWN);
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_REENABLE);
+			wake_up(&vhost->work_wait_q);
 		} else if (crq->format == IBMVFC_PARTNER_FAILED || crq->format == IBMVFC_PARTNER_DEREGISTER) {
 			dev_err(vhost->dev, "Host partner adapter deregistered or failed (rc=%d)\n", crq->format);
 			ibmvfc_purge_requests(vhost, DID_ERROR);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2b5e249f5d5b..0b16061d8da8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1879,6 +1879,13 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 			arr[14] |= 0x40;
 	}
 
+	/*
+	 * Since the scsi_debug READ CAPACITY implementation always reports the
+	 * total disk capacity, set RC BASIS = 1 for host-managed ZBC devices.
+	 */
+	if (devip->zmodel == BLK_ZONED_HM)
+		arr[12] |= 1 << 4;
+
 	arr[15] = sdebug_lowest_aligned & 0xff;
 
 	if (have_dif_prot) {
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f46ae5391758..cc39cbef9d7f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -232,7 +232,7 @@ iscsi_create_endpoint(int dd_size)
 	dev_set_name(&ep->dev, "ep-%d", id);
 	err = device_register(&ep->dev);
         if (err)
-		goto free_id;
+		goto put_dev;
 
 	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
 	if (err)
@@ -246,10 +246,12 @@ iscsi_create_endpoint(int dd_size)
 	device_unregister(&ep->dev);
 	return NULL;
 
-free_id:
+put_dev:
 	mutex_lock(&iscsi_ep_idr_mutex);
 	idr_remove(&iscsi_ep_idr, id);
 	mutex_unlock(&iscsi_ep_idr_mutex);
+	put_device(&ep->dev);
+	return NULL;
 free_ep:
 	kfree(ep);
 	return NULL;
@@ -767,7 +769,7 @@ iscsi_create_iface(struct Scsi_Host *shost, struct iscsi_transport *transport,
 
 	err = device_register(&iface->dev);
 	if (err)
-		goto free_iface;
+		goto put_dev;
 
 	err = sysfs_create_group(&iface->dev.kobj, &iscsi_iface_group);
 	if (err)
@@ -781,9 +783,8 @@ iscsi_create_iface(struct Scsi_Host *shost, struct iscsi_transport *transport,
 	device_unregister(&iface->dev);
 	return NULL;
 
-free_iface:
-	put_device(iface->dev.parent);
-	kfree(iface);
+put_dev:
+	put_device(&iface->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_iface);
@@ -1252,15 +1253,15 @@ iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 
 	err = device_register(&fnode_sess->dev);
 	if (err)
-		goto free_fnode_sess;
+		goto put_dev;
 
 	if (dd_size)
 		fnode_sess->dd_data = &fnode_sess[1];
 
 	return fnode_sess;
 
-free_fnode_sess:
-	kfree(fnode_sess);
+put_dev:
+	put_device(&fnode_sess->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_flashnode_sess);
@@ -1300,15 +1301,15 @@ iscsi_create_flashnode_conn(struct Scsi_Host *shost,
 
 	err = device_register(&fnode_conn->dev);
 	if (err)
-		goto free_fnode_conn;
+		goto put_dev;
 
 	if (dd_size)
 		fnode_conn->dd_data = &fnode_conn[1];
 
 	return fnode_conn;
 
-free_fnode_conn:
-	kfree(fnode_conn);
+put_dev:
+	put_device(&fnode_conn->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
@@ -4838,7 +4839,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	dev_set_name(&priv->dev, "%s", tt->name);
 	err = device_register(&priv->dev);
 	if (err)
-		goto free_priv;
+		goto put_dev;
 
 	err = sysfs_create_group(&priv->dev.kobj, &iscsi_transport_group);
 	if (err)
@@ -4873,8 +4874,8 @@ iscsi_register_transport(struct iscsi_transport *tt)
 unregister_dev:
 	device_unregister(&priv->dev);
 	return NULL;
-free_priv:
-	kfree(priv);
+put_dev:
+	put_device(&priv->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_register_transport);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3d03e1ca5820..6110dfd903f7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -344,16 +344,21 @@ enum storvsc_request_type {
 };
 
 /*
- * SRB status codes and masks; a subset of the codes used here.
+ * SRB status codes and masks. In the 8-bit field, the two high order bits
+ * are flags, while the remaining 6 bits are an integer status code.  The
+ * definitions here include only the subset of the integer status codes that
+ * are tested for in this driver.
  */
-
 #define SRB_STATUS_AUTOSENSE_VALID	0x80
 #define SRB_STATUS_QUEUE_FROZEN		0x40
-#define SRB_STATUS_INVALID_LUN	0x20
-#define SRB_STATUS_SUCCESS	0x01
-#define SRB_STATUS_ABORTED	0x02
-#define SRB_STATUS_ERROR	0x04
-#define SRB_STATUS_DATA_OVERRUN	0x12
+
+/* SRB status integer codes */
+#define SRB_STATUS_SUCCESS		0x01
+#define SRB_STATUS_ABORTED		0x02
+#define SRB_STATUS_ERROR		0x04
+#define SRB_STATUS_INVALID_REQUEST	0x06
+#define SRB_STATUS_DATA_OVERRUN		0x12
+#define SRB_STATUS_INVALID_LUN		0x20
 
 #define SRB_STATUS(status) \
 	(status & ~(SRB_STATUS_AUTOSENSE_VALID | SRB_STATUS_QUEUE_FROZEN))
@@ -1032,38 +1037,25 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	void (*process_err_fn)(struct work_struct *work);
 	struct hv_host_device *host_dev = shost_priv(host);
 
-	/*
-	 * In some situations, Hyper-V sets multiple bits in the
-	 * srb_status, such as ABORTED and ERROR. So process them
-	 * individually, with the most specific bits first.
-	 */
-
-	if (vm_srb->srb_status & SRB_STATUS_INVALID_LUN) {
-		set_host_byte(scmnd, DID_NO_CONNECT);
-		process_err_fn = storvsc_remove_lun;
-		goto do_work;
-	}
+	switch (SRB_STATUS(vm_srb->srb_status)) {
+	case SRB_STATUS_ERROR:
+	case SRB_STATUS_ABORTED:
+	case SRB_STATUS_INVALID_REQUEST:
+		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID) {
+			/* Check for capacity change */
+			if ((asc == 0x2a) && (ascq == 0x9)) {
+				process_err_fn = storvsc_device_scan;
+				/* Retry the I/O that triggered this. */
+				set_host_byte(scmnd, DID_REQUEUE);
+				goto do_work;
+			}
 
-	if (vm_srb->srb_status & SRB_STATUS_ABORTED) {
-		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID &&
-		    /* Capacity data has changed */
-		    (asc == 0x2a) && (ascq == 0x9)) {
-			process_err_fn = storvsc_device_scan;
 			/*
-			 * Retry the I/O that triggered this.
+			 * Otherwise, let upper layer deal with the
+			 * error when sense message is present
 			 */
-			set_host_byte(scmnd, DID_REQUEUE);
-			goto do_work;
-		}
-	}
-
-	if (vm_srb->srb_status & SRB_STATUS_ERROR) {
-		/*
-		 * Let upper layer deal with error when
-		 * sense message is present.
-		 */
-		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID)
 			return;
+		}
 
 		/*
 		 * If there is an error; offline the device since all
@@ -1086,6 +1078,13 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 		default:
 			set_host_byte(scmnd, DID_ERROR);
 		}
+		return;
+
+	case SRB_STATUS_INVALID_LUN:
+		set_host_byte(scmnd, DID_NO_CONNECT);
+		process_err_fn = storvsc_remove_lun;
+		goto do_work;
+
 	}
 	return;
 
diff --git a/drivers/spi/spi-dw-dma.c b/drivers/spi/spi-dw-dma.c
index a09831c62192..32ac8f9068e8 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -127,12 +127,15 @@ static int dw_spi_dma_init_mfld(struct device *dev, struct dw_spi *dws)
 
 	dw_spi_dma_sg_burst_init(dws);
 
+	pci_dev_put(dma_dev);
+
 	return 0;
 
 free_rxchan:
 	dma_release_channel(dws->rxchan);
 	dws->rxchan = NULL;
 err_exit:
+	pci_dev_put(dma_dev);
 	return -EBUSY;
 }
 
diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 96a73f9e2677..3c6f201b5dd8 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -434,7 +434,7 @@ static int stm32_spi_prepare_mbr(struct stm32_spi *spi, u32 speed_hz,
 	u32 div, mbrdiv;
 
 	/* Ensure spi->clk_rate is even */
-	div = DIV_ROUND_UP(spi->clk_rate & ~0x1, speed_hz);
+	div = DIV_ROUND_CLOSEST(spi->clk_rate & ~0x1, speed_hz);
 
 	/*
 	 * SPI framework set xfer->speed_hz to master->max_speed_hz if
diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
index 128a2d2a50a1..a74d82e230e3 100644
--- a/drivers/tee/optee/device.c
+++ b/drivers/tee/optee/device.c
@@ -80,7 +80,7 @@ static int optee_register_device(const uuid_t *device_uuid)
 	rc = device_register(&optee_device->dev);
 	if (rc) {
 		pr_err("device registration failed, err: %d\n", rc);
-		kfree(optee_device);
+		put_device(&optee_device->dev);
 	}
 
 	return rc;
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index c3348d5af922..f3bfaa1a794b 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1016,6 +1016,7 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 		uart->port.throttle	= up->port.throttle;
 		uart->port.unthrottle	= up->port.unthrottle;
 		uart->port.rs485_config	= up->port.rs485_config;
+		uart->port.rs485_supported = up->port.rs485_supported;
 		uart->port.rs485	= up->port.rs485;
 		uart->rs485_start_tx	= up->rs485_start_tx;
 		uart->rs485_stop_tx	= up->rs485_stop_tx;
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 469fdb91830e..078a7028ee5a 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -293,6 +293,7 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 {
 	struct omap8250_priv *priv = up->port.private_data;
 	struct uart_8250_dma	*dma = up->dma;
+	u8 mcr = serial8250_in_MCR(up);
 
 	if (dma && dma->tx_running) {
 		/*
@@ -309,7 +310,7 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	serial_out(up, UART_EFR, UART_EFR_ECB);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
-	serial8250_out_MCR(up, UART_MCR_TCRTLR);
+	serial8250_out_MCR(up, mcr | UART_MCR_TCRTLR);
 	serial_out(up, UART_FCR, up->fcr);
 
 	omap8250_update_scr(up, priv);
@@ -325,7 +326,8 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	serial_out(up, UART_LCR, 0);
 
 	/* drop TCR + TLR access, we setup XON/XOFF later */
-	serial8250_out_MCR(up, up->mcr);
+	serial8250_out_MCR(up, mcr);
+
 	serial_out(up, UART_IER, up->ier);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
@@ -684,7 +686,6 @@ static int omap_8250_startup(struct uart_port *port)
 
 	pm_runtime_get_sync(port->dev);
 
-	up->mcr = 0;
 	serial_out(up, UART_FCR, UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
 
 	serial_out(up, UART_LCR, UART_LCR_WLEN8);
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 44ed4285e1ef..595430aedc0d 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -12,6 +12,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -395,33 +396,6 @@ static unsigned int lpuart_get_baud_clk_rate(struct lpuart_port *sport)
 #define lpuart_enable_clks(x)	__lpuart_enable_clks(x, true)
 #define lpuart_disable_clks(x)	__lpuart_enable_clks(x, false)
 
-static int lpuart_global_reset(struct lpuart_port *sport)
-{
-	struct uart_port *port = &sport->port;
-	void __iomem *global_addr;
-	int ret;
-
-	if (uart_console(port))
-		return 0;
-
-	ret = clk_prepare_enable(sport->ipg_clk);
-	if (ret) {
-		dev_err(sport->port.dev, "failed to enable uart ipg clk: %d\n", ret);
-		return ret;
-	}
-
-	if (is_imx7ulp_lpuart(sport) || is_imx8qxp_lpuart(sport)) {
-		global_addr = port->membase + UART_GLOBAL - IMX_REG_OFF;
-		writel(UART_GLOBAL_RST, global_addr);
-		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
-		writel(0, global_addr);
-		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
-	}
-
-	clk_disable_unprepare(sport->ipg_clk);
-	return 0;
-}
-
 static void lpuart_stop_tx(struct uart_port *port)
 {
 	unsigned char temp;
@@ -2644,6 +2618,59 @@ static struct uart_driver lpuart_reg = {
 	.cons		= LPUART_CONSOLE,
 };
 
+static const struct serial_rs485 lpuart_rs485_supported = {
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RTS_AFTER_SEND,
+	/* delay_rts_* and RX_DURING_TX are not supported */
+};
+
+static int lpuart_global_reset(struct lpuart_port *sport)
+{
+	struct uart_port *port = &sport->port;
+	void __iomem *global_addr;
+	unsigned long ctrl, bd;
+	unsigned int val = 0;
+	int ret;
+
+	ret = clk_prepare_enable(sport->ipg_clk);
+	if (ret) {
+		dev_err(sport->port.dev, "failed to enable uart ipg clk: %d\n", ret);
+		return ret;
+	}
+
+	if (is_imx7ulp_lpuart(sport) || is_imx8qxp_lpuart(sport)) {
+		/*
+		 * If the transmitter is used by earlycon, wait for transmit engine to
+		 * complete and then reset.
+		 */
+		ctrl = lpuart32_read(port, UARTCTRL);
+		if (ctrl & UARTCTRL_TE) {
+			bd = lpuart32_read(&sport->port, UARTBAUD);
+			if (read_poll_timeout(lpuart32_tx_empty, val, val, 1, 100000, false,
+					      port)) {
+				dev_warn(sport->port.dev,
+					 "timeout waiting for transmit engine to complete\n");
+				clk_disable_unprepare(sport->ipg_clk);
+				return 0;
+			}
+		}
+
+		global_addr = port->membase + UART_GLOBAL - IMX_REG_OFF;
+		writel(UART_GLOBAL_RST, global_addr);
+		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
+		writel(0, global_addr);
+		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
+
+		/* Recover the transmitter for earlycon. */
+		if (ctrl & UARTCTRL_TE) {
+			lpuart32_write(port, bd, UARTBAUD);
+			lpuart32_write(port, ctrl, UARTCTRL);
+		}
+	}
+
+	clk_disable_unprepare(sport->ipg_clk);
+	return 0;
+}
+
 static int lpuart_probe(struct platform_device *pdev)
 {
 	const struct lpuart_soc_data *sdata = of_device_get_match_data(&pdev->dev);
@@ -2683,6 +2710,7 @@ static int lpuart_probe(struct platform_device *pdev)
 		sport->port.rs485_config = lpuart32_config_rs485;
 	else
 		sport->port.rs485_config = lpuart_config_rs485;
+	sport->port.rs485_supported = &lpuart_rs485_supported;
 
 	sport->ipg_clk = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(sport->ipg_clk)) {
diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index e85bf768c66d..068ccbd144b2 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -600,11 +600,11 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
 
 	trace_cdnsp_ep_halt(value ? "Set" : "Clear");
 
-	if (value) {
-		ret = cdnsp_cmd_stop_ep(pdev, pep);
-		if (ret)
-			return ret;
+	ret = cdnsp_cmd_stop_ep(pdev, pep);
+	if (ret)
+		return ret;
 
+	if (value) {
 		if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_STOPPED) {
 			cdnsp_queue_halt_endpoint(pdev, pep->idx);
 			cdnsp_ring_cmd_db(pdev);
@@ -613,10 +613,6 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
 
 		pep->ep_state |= EP_HALTED;
 	} else {
-		/*
-		 * In device mode driver can call reset endpoint command
-		 * from any endpoint state.
-		 */
 		cdnsp_queue_reset_ep(pdev, pep->idx);
 		cdnsp_ring_cmd_db(pdev);
 		ret = cdnsp_wait_for_cmd_compl(pdev);
diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 794e413800ae..2f29431f612e 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1763,10 +1763,15 @@ static u32 cdnsp_td_remainder(struct cdnsp_device *pdev,
 			      int trb_buff_len,
 			      unsigned int td_total_len,
 			      struct cdnsp_request *preq,
-			      bool more_trbs_coming)
+			      bool more_trbs_coming,
+			      bool zlp)
 {
 	u32 maxp, total_packet_count;
 
+	/* Before ZLP driver needs set TD_SIZE = 1. */
+	if (zlp)
+		return 1;
+
 	/* One TRB with a zero-length data packet. */
 	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
 	    trb_buff_len == td_total_len)
@@ -1960,7 +1965,8 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		/* Set the TRB length, TD size, and interrupter fields. */
 		remainder = cdnsp_td_remainder(pdev, enqd_len, trb_buff_len,
 					       full_len, preq,
-					       more_trbs_coming);
+					       more_trbs_coming,
+					       zero_len_trb);
 
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
@@ -2025,7 +2031,7 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 
 	if (preq->request.length > 0) {
 		remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
-					       preq->request.length, preq, 1);
+					       preq->request.length, preq, 1, 0);
 
 		length_field = TRB_LEN(preq->request.length) |
 				TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
@@ -2076,7 +2082,8 @@ int cdnsp_cmd_stop_ep(struct cdnsp_device *pdev, struct cdnsp_ep *pep)
 	u32 ep_state = GET_EP_CTX_STATE(pep->out_ctx);
 	int ret = 0;
 
-	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED) {
+	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED ||
+	    ep_state == EP_STATE_HALTED) {
 		trace_cdnsp_ep_stopped_or_disabled(pep->out_ctx);
 		goto ep_stopped;
 	}
@@ -2225,7 +2232,7 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
 		/* Set the TRB length, TD size, & interrupter fields. */
 		remainder = cdnsp_td_remainder(pdev, running_total,
 					       trb_buff_len, td_len, preq,
-					       more_trbs_coming);
+					       more_trbs_coming, 0);
 
 		length_field = TRB_LEN(trb_buff_len) | TRB_INTR_TARGET(0);
 
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 0ecf20eeceee..4be6a873bd07 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -37,15 +37,6 @@ struct dwc3_exynos {
 	struct regulator	*vdd10;
 };
 
-static int dwc3_exynos_remove_child(struct device *dev, void *unused)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static int dwc3_exynos_probe(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos;
@@ -142,7 +133,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 	int i;
 
-	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
+	of_platform_depopulate(&pdev->dev);
 
 	for (i = exynos->num_clks - 1; i >= 0; i--)
 		clk_disable_unprepare(exynos->clks[i]);
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index c38418b4df90..dfa1d9eedde1 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -951,7 +951,7 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
 	return 0;
 }
 
-static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep)
+static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep, int status)
 {
 	struct dwc3_request		*req;
 
@@ -961,19 +961,19 @@ static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep)
 	while (!list_empty(&dep->started_list)) {
 		req = next_request(&dep->started_list);
 
-		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
+		dwc3_gadget_giveback(dep, req, status);
 	}
 
 	while (!list_empty(&dep->pending_list)) {
 		req = next_request(&dep->pending_list);
 
-		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
+		dwc3_gadget_giveback(dep, req, status);
 	}
 
 	while (!list_empty(&dep->cancelled_list)) {
 		req = next_request(&dep->cancelled_list);
 
-		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
+		dwc3_gadget_giveback(dep, req, status);
 	}
 }
 
@@ -1002,18 +1002,18 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
+	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
+
+	dep->stream_capable = false;
+	dep->type = 0;
+	dep->flags &= DWC3_EP_TXFIFO_RESIZED;
+
 	/* Clear out the ep descriptors for non-ep0 */
 	if (dep->number > 1) {
 		dep->endpoint.comp_desc = NULL;
 		dep->endpoint.desc = NULL;
 	}
 
-	dwc3_remove_requests(dwc, dep);
-
-	dep->stream_capable = false;
-	dep->type = 0;
-	dep->flags &= DWC3_EP_TXFIFO_RESIZED;
-
 	return 0;
 }
 
@@ -2288,7 +2288,7 @@ static void dwc3_stop_active_transfers(struct dwc3 *dwc)
 		if (!dep)
 			continue;
 
-		dwc3_remove_requests(dwc, dep);
+		dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 	}
 }
 
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 18f0ed8b1f93..6ebd819338ec 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -144,7 +144,7 @@ static int platform_pci_probe(struct pci_dev *pdev,
 		if (ret) {
 			dev_warn(&pdev->dev, "Unable to set the evtchn callback "
 					 "err=%d\n", ret);
-			goto out;
+			goto irq_out;
 		}
 	}
 
@@ -152,13 +152,16 @@ static int platform_pci_probe(struct pci_dev *pdev,
 	grant_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
 	ret = gnttab_setup_auto_xlat_frames(grant_frames);
 	if (ret)
-		goto out;
+		goto irq_out;
 	ret = gnttab_init();
 	if (ret)
 		goto grant_out;
 	return 0;
 grant_out:
 	gnttab_free_auto_xlat_frames();
+irq_out:
+	if (!xen_have_vector_callback)
+		free_irq(pdev->irq, pdev);
 out:
 	pci_release_region(pdev, 0);
 mem_out:
diff --git a/drivers/xen/xen-pciback/conf_space_capability.c b/drivers/xen/xen-pciback/conf_space_capability.c
index 5e53b4817f16..097316a74126 100644
--- a/drivers/xen/xen-pciback/conf_space_capability.c
+++ b/drivers/xen/xen-pciback/conf_space_capability.c
@@ -190,13 +190,16 @@ static const struct config_field caplist_pm[] = {
 };
 
 static struct msi_msix_field_config {
-	u16          enable_bit; /* bit for enabling MSI/MSI-X */
-	unsigned int int_type;   /* interrupt type for exclusiveness check */
+	u16          enable_bit;   /* bit for enabling MSI/MSI-X */
+	u16          allowed_bits; /* bits allowed to be changed */
+	unsigned int int_type;     /* interrupt type for exclusiveness check */
 } msi_field_config = {
 	.enable_bit	= PCI_MSI_FLAGS_ENABLE,
+	.allowed_bits	= PCI_MSI_FLAGS_ENABLE,
 	.int_type	= INTERRUPT_TYPE_MSI,
 }, msix_field_config = {
 	.enable_bit	= PCI_MSIX_FLAGS_ENABLE,
+	.allowed_bits	= PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL,
 	.int_type	= INTERRUPT_TYPE_MSIX,
 };
 
@@ -229,7 +232,7 @@ static int msi_msix_flags_write(struct pci_dev *dev, int offset, u16 new_value,
 		return 0;
 
 	if (!dev_data->allow_interrupt_control ||
-	    (new_value ^ old_value) & ~field_config->enable_bit)
+	    (new_value ^ old_value) & ~field_config->allowed_bits)
 		return PCIBIOS_SET_FAILED;
 
 	if (new_value & field_config->enable_bit) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b9dcaae7c8d5..d9ff0697132b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2788,6 +2788,8 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
 		}
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
 		ret = -EFAULT;
 
@@ -2880,6 +2882,8 @@ static int btrfs_ioctl_get_subvol_rootref(struct file *file, void __user *argp)
 	}
 
 out:
+	btrfs_free_path(path);
+
 	if (!ret || ret == -EOVERFLOW) {
 		rootrefs->num_items = found;
 		/* update min_treeid for next search */
@@ -2891,7 +2895,6 @@ static int btrfs_ioctl_get_subvol_rootref(struct file *file, void __user *argp)
 	}
 
 	kfree(rootrefs);
-	btrfs_free_path(path);
 
 	return ret;
 }
@@ -3891,6 +3894,8 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 		ipath->fspath->val[i] = rel_ptr;
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	ret = copy_to_user((void __user *)(unsigned long)ipa->fspath,
 			   ipath->fspath, size);
 	if (ret) {
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 25a6f587852b..1c40e5151321 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -2035,8 +2035,11 @@ int __init btrfs_init_sysfs(void)
 
 #ifdef CONFIG_BTRFS_DEBUG
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_debug_feature_attr_group);
-	if (ret)
-		goto out2;
+	if (ret) {
+		sysfs_unmerge_group(&btrfs_kset->kobj,
+				    &btrfs_static_feature_attr_group);
+		goto out_remove_group;
+	}
 #endif
 
 	return 0;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 96958ca474bd..dbb75c2995e9 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -114,7 +114,8 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			super[i] = page_address(page[i]);
 		}
 
-		if (super[0]->generation > super[1]->generation)
+		if (btrfs_super_generation(super[0]) >
+		    btrfs_super_generation(super[1]))
 			sector = zones[1].start;
 		else
 			sector = zones[0].start;
@@ -420,7 +421,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		goto out;
 	}
 
-	zones = kcalloc(BTRFS_REPORT_NR_ZONES, sizeof(struct blk_zone), GFP_KERNEL);
+	zones = kvcalloc(BTRFS_REPORT_NR_ZONES, sizeof(struct blk_zone), GFP_KERNEL);
 	if (!zones) {
 		ret = -ENOMEM;
 		goto out;
@@ -516,7 +517,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	}
 
 
-	kfree(zones);
+	kvfree(zones);
 
 	switch (bdev_zoned_model(bdev)) {
 	case BLK_ZONED_HM:
@@ -548,7 +549,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	return 0;
 
 out:
-	kfree(zones);
+	kvfree(zones);
 out_free_zone_info:
 	btrfs_destroy_dev_zone_info(device);
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 883bb91ee257..be96fe615bec 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2217,7 +2217,6 @@ static int unsafe_request_wait(struct inode *inode)
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
-	unsigned int max_sessions;
 	int ret, err = 0;
 
 	spin_lock(&ci->i_unsafe_lock);
@@ -2235,28 +2234,24 @@ static int unsafe_request_wait(struct inode *inode)
 	}
 	spin_unlock(&ci->i_unsafe_lock);
 
-	/*
-	 * The mdsc->max_sessions is unlikely to be changed
-	 * mostly, here we will retry it by reallocating the
-	 * sessions array memory to get rid of the mdsc->mutex
-	 * lock.
-	 */
-retry:
-	max_sessions = mdsc->max_sessions;
-
 	/*
 	 * Trigger to flush the journal logs in all the relevant MDSes
 	 * manually, or in the worst case we must wait at most 5 seconds
 	 * to wait the journal logs to be flushed by the MDSes periodically.
 	 */
-	if ((req1 || req2) && likely(max_sessions)) {
-		struct ceph_mds_session **sessions = NULL;
-		struct ceph_mds_session *s;
+	if (req1 || req2) {
 		struct ceph_mds_request *req;
+		struct ceph_mds_session **sessions;
+		struct ceph_mds_session *s;
+		unsigned int max_sessions;
 		int i;
 
-		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
+		mutex_lock(&mdsc->mutex);
+		max_sessions = mdsc->max_sessions;
+
+		sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
 		if (!sessions) {
+			mutex_unlock(&mdsc->mutex);
 			err = -ENOMEM;
 			goto out;
 		}
@@ -2268,16 +2263,6 @@ static int unsafe_request_wait(struct inode *inode)
 				s = req->r_session;
 				if (!s)
 					continue;
-				if (unlikely(s->s_mds >= max_sessions)) {
-					spin_unlock(&ci->i_unsafe_lock);
-					for (i = 0; i < max_sessions; i++) {
-						s = sessions[i];
-						if (s)
-							ceph_put_mds_session(s);
-					}
-					kfree(sessions);
-					goto retry;
-				}
 				if (!sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
@@ -2290,16 +2275,6 @@ static int unsafe_request_wait(struct inode *inode)
 				s = req->r_session;
 				if (!s)
 					continue;
-				if (unlikely(s->s_mds >= max_sessions)) {
-					spin_unlock(&ci->i_unsafe_lock);
-					for (i = 0; i < max_sessions; i++) {
-						s = sessions[i];
-						if (s)
-							ceph_put_mds_session(s);
-					}
-					kfree(sessions);
-					goto retry;
-				}
 				if (!sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
@@ -2311,11 +2286,12 @@ static int unsafe_request_wait(struct inode *inode)
 		/* the auth MDS */
 		spin_lock(&ci->i_ceph_lock);
 		if (ci->i_auth_cap) {
-		      s = ci->i_auth_cap->session;
-		      if (!sessions[s->s_mds])
-			      sessions[s->s_mds] = ceph_get_mds_session(s);
+			s = ci->i_auth_cap->session;
+			if (!sessions[s->s_mds])
+				sessions[s->s_mds] = ceph_get_mds_session(s);
 		}
 		spin_unlock(&ci->i_ceph_lock);
+		mutex_unlock(&mdsc->mutex);
 
 		/* send flush mdlog request to MDSes */
 		for (i = 0; i < max_sessions; i++) {
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index b41e6724c591..b512c82f9ccd 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -705,9 +705,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_mds_snap_realm *ri;    /* encoded */
 	__le64 *snaps;                     /* encoded */
 	__le64 *prior_parent_snaps;        /* encoded */
-	struct ceph_snap_realm *realm = NULL;
+	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
-	int invalidate = 0;
+	struct ceph_snap_realm *realm_to_rebuild = NULL;
+	int rebuild_snapcs;
 	int err = -ENOMEM;
 	LIST_HEAD(dirty_realms);
 
@@ -715,6 +716,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
+	realm = NULL;
+	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
 	p += sizeof(*ri);
@@ -738,7 +741,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	err = adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
 	if (err < 0)
 		goto fail;
-	invalidate += err;
+	rebuild_snapcs += err;
 
 	if (le64_to_cpu(ri->seq) > realm->seq) {
 		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
@@ -763,22 +766,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 		if (realm->seq > mdsc->last_snap_seq)
 			mdsc->last_snap_seq = realm->seq;
 
-		invalidate = 1;
+		rebuild_snapcs = 1;
 	} else if (!realm->cached_context) {
 		dout("update_snap_trace %llx %p seq %lld new\n",
 		     realm->ino, realm, realm->seq);
-		invalidate = 1;
+		rebuild_snapcs = 1;
 	} else {
 		dout("update_snap_trace %llx %p seq %lld unchanged\n",
 		     realm->ino, realm, realm->seq);
 	}
 
-	dout("done with %llx %p, invalidated=%d, %p %p\n", realm->ino,
-	     realm, invalidate, p, e);
+	dout("done with %llx %p, rebuild_snapcs=%d, %p %p\n", realm->ino,
+	     realm, rebuild_snapcs, p, e);
+
+	/*
+	 * this will always track the uppest parent realm from which
+	 * we need to rebuild the snapshot contexts _downward_ in
+	 * hierarchy.
+	 */
+	if (rebuild_snapcs)
+		realm_to_rebuild = realm;
 
-	/* invalidate when we reach the _end_ (root) of the trace */
-	if (invalidate && p >= e)
-		rebuild_snap_realms(realm, &dirty_realms);
+	/* rebuild_snapcs when we reach the _end_ (root) of the trace */
+	if (realm_to_rebuild && p >= e)
+		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
 
 	if (!first_realm)
 		first_realm = realm;
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 007427ba75e5..b0864da9ef43 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -307,12 +307,8 @@ static struct vfsmount *cifs_dfs_do_mount(struct dentry *mntpt,
 static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 {
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_ses *ses;
-	struct cifs_tcon *tcon;
 	void *page;
-	char *full_path, *root_path;
-	unsigned int xid;
-	int rc;
+	char *full_path;
 	struct vfsmount *mnt;
 
 	cifs_dbg(FYI, "in %s\n", __func__);
@@ -324,8 +320,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	 * the double backslashes usually used in the UNC. This function
 	 * gives us the latter, so we must adjust the result.
 	 */
-	mnt = ERR_PTR(-ENOMEM);
-
 	cifs_sb = CIFS_SB(mntpt->d_sb);
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) {
 		mnt = ERR_PTR(-EREMOTE);
@@ -341,60 +335,11 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	}
 
 	convert_delimiter(full_path, '\\');
-
 	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
-	if (!cifs_sb_master_tlink(cifs_sb)) {
-		cifs_dbg(FYI, "%s: master tlink is NULL\n", __func__);
-		goto free_full_path;
-	}
-
-	tcon = cifs_sb_master_tcon(cifs_sb);
-	if (!tcon) {
-		cifs_dbg(FYI, "%s: master tcon is NULL\n", __func__);
-		goto free_full_path;
-	}
-
-	root_path = kstrdup(tcon->treeName, GFP_KERNEL);
-	if (!root_path) {
-		mnt = ERR_PTR(-ENOMEM);
-		goto free_full_path;
-	}
-	cifs_dbg(FYI, "%s: root path: %s\n", __func__, root_path);
-
-	ses = tcon->ses;
-	xid = get_xid();
-
-	/*
-	 * If DFS root has been expired, then unconditionally fetch it again to
-	 * refresh DFS referral cache.
-	 */
-	rc = dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
-			    root_path + 1, NULL, NULL);
-	if (!rc) {
-		rc = dfs_cache_find(xid, ses, cifs_sb->local_nls,
-				    cifs_remap(cifs_sb), full_path + 1,
-				    NULL, NULL);
-	}
-
-	free_xid(xid);
-
-	if (rc) {
-		mnt = ERR_PTR(rc);
-		goto free_root_path;
-	}
-	/*
-	 * OK - we were able to get and cache a referral for @full_path.
-	 *
-	 * Now, pass it down to cifs_mount() and it will retry every available
-	 * node server in case of failures - no need to do it here.
-	 */
 	mnt = cifs_dfs_do_mount(mntpt, cifs_sb, full_path);
-	cifs_dbg(FYI, "%s: cifs_dfs_do_mount:%s , mnt:%p\n", __func__,
-		 full_path + 1, mnt);
+	cifs_dbg(FYI, "%s: cifs_dfs_do_mount:%s , mnt:%p\n", __func__, full_path + 1, mnt);
 
-free_root_path:
-	kfree(root_path);
 free_full_path:
 	free_dentry_path(page);
 cdda_exit:
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index f97407520ea1..013a4bd65280 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -61,11 +61,6 @@ struct cifs_sb_info {
 	/* only used when CIFS_MOUNT_USE_PREFIX_PATH is set */
 	char *prepath;
 
-	/*
-	 * Canonical DFS path initially provided by the mount call. We might connect to something
-	 * different via DFS but we want to keep it to do failover properly.
-	 */
-	char *origin_fullpath; /* \\HOST\SHARE\[OPTIONAL PATH] */
 	/* randomly generated 128-bit number for indexing dfs mount groups in referral cache */
 	uuid_t dfs_mount_id;
 	/*
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a97ed30843cf..1ab72c3d0bff 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -693,6 +693,19 @@ struct TCP_Server_Info {
 #endif
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	bool is_dfs_conn; /* if a dfs connection */
+	struct mutex refpath_lock; /* protects leaf_fullpath */
+	/*
+	 * Canonical DFS full paths that were used to chase referrals in mount and reconnect.
+	 *
+	 * origin_fullpath: first or original referral path
+	 * leaf_fullpath: last referral path (might be changed due to nested links in reconnect)
+	 *
+	 * current_fullpath: pointer to either origin_fullpath or leaf_fullpath
+	 * NOTE: cannot be accessed outside cifs_reconnect() and smb2_reconnect()
+	 *
+	 * format: \\HOST\SHARE\[OPTIONAL PATH]
+	 */
+	char *origin_fullpath, *leaf_fullpath, *current_fullpath;
 #endif
 };
 
@@ -1097,7 +1110,6 @@ struct cifs_tcon {
 	struct cached_fid crfid; /* Cached root fid */
 	/* BB add field for back pointer to sb struct(s)? */
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	char *dfs_path; /* canonical DFS path */
 	struct list_head ulist; /* cache update list */
 #endif
 };
@@ -1950,4 +1962,14 @@ static inline bool is_tcon_dfs(struct cifs_tcon *tcon)
 		tcon->share_flags & (SHI1005_FLAGS_DFS | SHI1005_FLAGS_DFS_ROOT);
 }
 
+static inline bool cifs_is_referral_server(struct cifs_tcon *tcon,
+					   const struct dfs_info3_param *ref)
+{
+	/*
+	 * Check if all targets are capable of handling DFS referrals as per
+	 * MS-DFSC 2.2.4 RESP_GET_DFS_REFERRAL.
+	 */
+	return is_tcon_dfs(tcon) || (ref && (ref->flags & DFSREF_REFERRAL_SERVER));
+}
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d0f85b666662..b2697356b5e7 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -607,7 +607,7 @@ int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
 
 struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server);
 void cifs_put_tcp_super(struct super_block *sb);
-int update_super_prepath(struct cifs_tcon *tcon, char *prefix);
+int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix);
 char *extract_hostname(const char *unc);
 char *extract_sharename(const char *unc);
 
@@ -634,4 +634,7 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 		return options;
 }
 
+struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon);
+void cifs_put_tcon_super(struct super_block *sb);
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ad5c935f7f06..c6e2a0ff8f0c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -61,6 +61,20 @@ extern bool disable_legacy_dialects;
 /* Drop the connection to not overload the server */
 #define NUM_STATUS_IO_TIMEOUT   5
 
+struct mount_ctx {
+	struct cifs_sb_info *cifs_sb;
+	struct smb3_fs_context *fs_ctx;
+	unsigned int xid;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	struct cifs_ses *root_ses;
+	uuid_t mount_id;
+	char *origin_fullpath, *leaf_fullpath;
+#endif
+};
+
 static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
@@ -148,131 +162,29 @@ static void cifs_resolve_server(struct work_struct *work)
 	mutex_unlock(&server->srv_mutex);
 }
 
-#ifdef CONFIG_CIFS_DFS_UPCALL
-/* These functions must be called with server->srv_mutex held */
-static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
-				       struct cifs_sb_info *cifs_sb,
-				       struct dfs_cache_tgt_list *tgt_list,
-				       struct dfs_cache_tgt_iterator **tgt_it)
-{
-	const char *name;
-	int rc;
-
-	if (!cifs_sb || !cifs_sb->origin_fullpath)
-		return;
-
-	if (!*tgt_it) {
-		*tgt_it = dfs_cache_get_tgt_iterator(tgt_list);
-	} else {
-		*tgt_it = dfs_cache_get_next_tgt(tgt_list, *tgt_it);
-		if (!*tgt_it)
-			*tgt_it = dfs_cache_get_tgt_iterator(tgt_list);
-	}
-
-	cifs_dbg(FYI, "%s: UNC: %s\n", __func__, cifs_sb->origin_fullpath);
-
-	name = dfs_cache_get_tgt_name(*tgt_it);
-
-	kfree(server->hostname);
-
-	server->hostname = extract_hostname(name);
-	if (IS_ERR(server->hostname)) {
-		cifs_dbg(FYI,
-			 "%s: failed to extract hostname from target: %ld\n",
-			 __func__, PTR_ERR(server->hostname));
-		return;
-	}
-
-	rc = reconn_set_ipaddr_from_hostname(server);
-	if (rc) {
-		cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
-			 __func__, rc);
-	}
-}
-
-static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
-					   struct dfs_cache_tgt_list *tl)
-{
-	if (!cifs_sb->origin_fullpath)
-		return -EOPNOTSUPP;
-	return dfs_cache_noreq_find(cifs_sb->origin_fullpath + 1, NULL, tl);
-}
-#endif
-
-/*
- * cifs tcp session reconnection
+/**
+ * Mark all sessions and tcons for reconnect.
  *
- * mark tcp session as reconnecting so temporarily locked
- * mark all smb sessions as reconnecting for tcp session
- * reconnect tcp session
- * wake up waiters on reconnection? - (not needed currently)
+ * @server needs to be previously set to CifsNeedReconnect.
  */
-int
-cifs_reconnect(struct TCP_Server_Info *server)
+static void cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server)
 {
-	int rc = 0;
 	struct list_head *tmp, *tmp2;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct mid_q_entry *mid_entry;
 	struct list_head retry_list;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	struct super_block *sb = NULL;
-	struct cifs_sb_info *cifs_sb = NULL;
-	struct dfs_cache_tgt_list tgt_list = DFS_CACHE_TGT_LIST_INIT(tgt_list);
-	struct dfs_cache_tgt_iterator *tgt_it = NULL;
-#endif
 
-	spin_lock(&GlobalMid_Lock);
-	server->nr_targets = 1;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	spin_unlock(&GlobalMid_Lock);
-	sb = cifs_get_tcp_super(server);
-	if (IS_ERR(sb)) {
-		rc = PTR_ERR(sb);
-		cifs_dbg(FYI, "%s: will not do DFS failover: rc = %d\n",
-			 __func__, rc);
-		sb = NULL;
-	} else {
-		cifs_sb = CIFS_SB(sb);
-		rc = reconn_setup_dfs_targets(cifs_sb, &tgt_list);
-		if (rc) {
-			cifs_sb = NULL;
-			if (rc != -EOPNOTSUPP) {
-				cifs_server_dbg(VFS, "%s: no target servers for DFS failover\n",
-						__func__);
-			}
-		} else {
-			server->nr_targets = dfs_cache_get_nr_tgts(&tgt_list);
-		}
-	}
-	cifs_dbg(FYI, "%s: will retry %d target(s)\n", __func__,
-		 server->nr_targets);
-	spin_lock(&GlobalMid_Lock);
-#endif
-	if (server->tcpStatus == CifsExiting) {
-		/* the demux thread will exit normally
-		next time through the loop */
-		spin_unlock(&GlobalMid_Lock);
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		dfs_cache_free_tgts(&tgt_list);
-		cifs_put_tcp_super(sb);
-#endif
-		wake_up(&server->response_q);
-		return rc;
-	} else
-		server->tcpStatus = CifsNeedReconnect;
-	spin_unlock(&GlobalMid_Lock);
 	server->maxBuf = 0;
 	server->max_read = 0;
 
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->CurrentMid, server->conn_id, server->hostname);
-
-	/* before reconnecting the tcp session, mark the smb session (uid)
-		and the tid bad so they are not used until reconnected */
-	cifs_dbg(FYI, "%s: marking sessions and tcons for reconnect\n",
-		 __func__);
+	/*
+	 * before reconnecting the tcp session, mark the smb session (uid) and the tid bad so they
+	 * are not used until reconnected.
+	 */
+	cifs_dbg(FYI, "%s: marking sessions and tcons for reconnect\n", __func__);
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &server->smb_ses_list) {
 		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
@@ -290,11 +202,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "%s: tearing down socket\n", __func__);
 	mutex_lock(&server->srv_mutex);
 	if (server->ssocket) {
-		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
-			 server->ssocket->state, server->ssocket->flags);
+		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n", server->ssocket->state,
+			 server->ssocket->flags);
 		kernel_sock_shutdown(server->ssocket, SHUT_WR);
-		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
-			 server->ssocket->state, server->ssocket->flags);
+		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n", server->ssocket->state,
+			 server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
 	}
@@ -333,38 +245,48 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		smbd_destroy(server);
 		mutex_unlock(&server->srv_mutex);
 	}
+}
+
+static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
+{
+	spin_lock(&GlobalMid_Lock);
+	server->nr_targets = num_targets;
+	if (server->tcpStatus == CifsExiting) {
+		/* the demux thread will exit normally next time through the loop */
+		spin_unlock(&GlobalMid_Lock);
+		wake_up(&server->response_q);
+		return false;
+	}
+	server->tcpStatus = CifsNeedReconnect;
+	spin_unlock(&GlobalMid_Lock);
+	return true;
+}
+
+/*
+ * cifs tcp session reconnection
+ *
+ * mark tcp session as reconnecting so temporarily locked
+ * mark all smb sessions as reconnecting for tcp session
+ * reconnect tcp session
+ * wake up waiters on reconnection? - (not needed currently)
+ */
+static int __cifs_reconnect(struct TCP_Server_Info *server)
+{
+	int rc = 0;
+
+	if (!cifs_tcp_ses_needs_reconnect(server, 1))
+		return 0;
+
+	cifs_mark_tcp_ses_conns_for_reconnect(server);
 
 	do {
 		try_to_freeze();
-
 		mutex_lock(&server->srv_mutex);
 
-
 		if (!cifs_swn_set_server_dstaddr(server)) {
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		if (cifs_sb && cifs_sb->origin_fullpath)
-			/*
-			 * Set up next DFS target server (if any) for reconnect. If DFS
-			 * feature is disabled, then we will retry last server we
-			 * connected to before.
-			 */
-			reconn_set_next_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
-		else {
-#endif
-			/*
-			 * Resolve the hostname again to make sure that IP address is up-to-date.
-			 */
+			/* resolve the hostname again to make sure that IP address is up-to-date */
 			rc = reconn_set_ipaddr_from_hostname(server);
-			if (rc) {
-				cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
-						__func__, rc);
-			}
-
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		}
-#endif
-
-
+			cifs_dbg(FYI, "%s: reconn_set_ipaddr_from_hostname: rc=%d\n", __func__, rc);
 		}
 
 		if (cifs_rdma_enabled(server))
@@ -372,8 +294,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		else
 			rc = generic_ip_connect(server);
 		if (rc) {
-			cifs_dbg(FYI, "reconnect error %d\n", rc);
 			mutex_unlock(&server->srv_mutex);
+			cifs_dbg(FYI, "%s: reconnect error %d\n", __func__, rc);
 			msleep(3000);
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
@@ -387,19 +309,128 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		}
 	} while (server->tcpStatus == CifsNeedReconnect);
 
+	if (server->tcpStatus == CifsNeedNegotiate)
+		mod_delayed_work(cifsiod_wq, &server->echo, 0);
+
+	wake_up(&server->response_q);
+	return rc;
+}
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	if (tgt_it) {
-		rc = dfs_cache_noreq_update_tgthint(cifs_sb->origin_fullpath + 1,
-						    tgt_it);
-		if (rc) {
-			cifs_server_dbg(VFS, "%s: failed to update DFS target hint: rc = %d\n",
-				 __func__, rc);
+static int __reconnect_target_unlocked(struct TCP_Server_Info *server, const char *target)
+{
+	int rc;
+	char *hostname;
+
+	if (!cifs_swn_set_server_dstaddr(server)) {
+		if (server->hostname != target) {
+			hostname = extract_hostname(target);
+			if (!IS_ERR(hostname)) {
+				kfree(server->hostname);
+				server->hostname = hostname;
+			} else {
+				cifs_dbg(FYI, "%s: couldn't extract hostname or address from dfs target: %ld\n",
+					 __func__, PTR_ERR(hostname));
+				cifs_dbg(FYI, "%s: default to last target server: %s\n", __func__,
+					 server->hostname);
+			}
+		}
+		/* resolve the hostname again to make sure that IP address is up-to-date. */
+		rc = reconn_set_ipaddr_from_hostname(server);
+		cifs_dbg(FYI, "%s: reconn_set_ipaddr_from_hostname: rc=%d\n", __func__, rc);
+	}
+	/* Reconnect the socket */
+	if (cifs_rdma_enabled(server))
+		rc = smbd_reconnect(server);
+	else
+		rc = generic_ip_connect(server);
+
+	return rc;
+}
+
+static int reconnect_target_unlocked(struct TCP_Server_Info *server, struct dfs_cache_tgt_list *tl,
+				     struct dfs_cache_tgt_iterator **target_hint)
+{
+	int rc;
+	struct dfs_cache_tgt_iterator *tit;
+
+	*target_hint = NULL;
+
+	/* If dfs target list is empty, then reconnect to last server */
+	tit = dfs_cache_get_tgt_iterator(tl);
+	if (!tit)
+		return __reconnect_target_unlocked(server, server->hostname);
+
+	/* Otherwise, try every dfs target in @tl */
+	for (; tit; tit = dfs_cache_get_next_tgt(tl, tit)) {
+		rc = __reconnect_target_unlocked(server, dfs_cache_get_tgt_name(tit));
+		if (!rc) {
+			*target_hint = tit;
+			break;
 		}
-		dfs_cache_free_tgts(&tgt_list);
 	}
+	return rc;
+}
 
-	cifs_put_tcp_super(sb);
-#endif
+static int reconnect_dfs_server(struct TCP_Server_Info *server)
+{
+	int rc = 0;
+	const char *refpath = server->current_fullpath + 1;
+	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
+	struct dfs_cache_tgt_iterator *target_hint = NULL;
+	int num_targets = 0;
+
+	/*
+	 * Determine the number of dfs targets the referral path in @cifs_sb resolves to.
+	 *
+	 * smb2_reconnect() needs to know how long it should wait based upon the number of dfs
+	 * targets (server->nr_targets).  It's also possible that the cached referral was cleared
+	 * through /proc/fs/cifs/dfscache or the target list is empty due to server settings after
+	 * refreshing the referral, so, in this case, default it to 1.
+	 */
+	if (!dfs_cache_noreq_find(refpath, NULL, &tl))
+		num_targets = dfs_cache_get_nr_tgts(&tl);
+	if (!num_targets)
+		num_targets = 1;
+
+	if (!cifs_tcp_ses_needs_reconnect(server, num_targets))
+		return 0;
+
+	cifs_mark_tcp_ses_conns_for_reconnect(server);
+
+	do {
+		try_to_freeze();
+		mutex_lock(&server->srv_mutex);
+
+		rc = reconnect_target_unlocked(server, &tl, &target_hint);
+		if (rc) {
+			/* Failed to reconnect socket */
+			mutex_unlock(&server->srv_mutex);
+			cifs_dbg(FYI, "%s: reconnect error %d\n", __func__, rc);
+			msleep(3000);
+			continue;
+		}
+		/*
+		 * Socket was created.  Update tcp session status to CifsNeedNegotiate so that a
+		 * process waiting for reconnect will know it needs to re-establish session and tcon
+		 * through the reconnected target server.
+		 */
+		atomic_inc(&tcpSesReconnectCount);
+		set_credits(server, 1);
+		spin_lock(&GlobalMid_Lock);
+		if (server->tcpStatus != CifsExiting)
+			server->tcpStatus = CifsNeedNegotiate;
+		spin_unlock(&GlobalMid_Lock);
+		cifs_swn_reset_server_dstaddr(server);
+		mutex_unlock(&server->srv_mutex);
+	} while (server->tcpStatus == CifsNeedReconnect);
+
+	if (target_hint)
+		dfs_cache_noreq_update_tgthint(refpath, target_hint);
+
+	dfs_cache_free_tgts(&tl);
+
+	/* Need to set up echo worker again once connection has been established */
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 
@@ -407,6 +438,25 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	return rc;
 }
 
+int cifs_reconnect(struct TCP_Server_Info *server)
+{
+	/* If tcp session is not an dfs connection, then reconnect to last target server */
+	spin_lock(&cifs_tcp_ses_lock);
+	if (!server->is_dfs_conn || !server->origin_fullpath || !server->leaf_fullpath) {
+		spin_unlock(&cifs_tcp_ses_lock);
+		return __cifs_reconnect(server);
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	return reconnect_dfs_server(server);
+}
+#else
+int cifs_reconnect(struct TCP_Server_Info *server)
+{
+	return __cifs_reconnect(server);
+}
+#endif
+
 static void
 cifs_echo_request(struct work_struct *work)
 {
@@ -789,6 +839,10 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	kfree(server->origin_fullpath);
+	kfree(server->leaf_fullpath);
+#endif
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
@@ -1405,6 +1459,9 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
 	INIT_DELAYED_WORK(&tcp_ses->resolve, cifs_resolve_server);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	mutex_init(&tcp_ses->refpath_lock);
+#endif
 	memcpy(&tcp_ses->srcaddr, &ctx->srcaddr,
 	       sizeof(tcp_ses->srcaddr));
 	memcpy(&tcp_ses->dstaddr, &ctx->dstaddr,
@@ -2869,73 +2926,64 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 }
 
 /* Release all succeed connections */
-static inline void mount_put_conns(struct cifs_sb_info *cifs_sb,
-				   unsigned int xid,
-				   struct TCP_Server_Info *server,
-				   struct cifs_ses *ses, struct cifs_tcon *tcon)
+static inline void mount_put_conns(struct mount_ctx *mnt_ctx)
 {
 	int rc = 0;
 
-	if (tcon)
-		cifs_put_tcon(tcon);
-	else if (ses)
-		cifs_put_smb_ses(ses);
-	else if (server)
-		cifs_put_tcp_session(server, 0);
-	cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_POSIX_PATHS;
-	free_xid(xid);
+	if (mnt_ctx->tcon)
+		cifs_put_tcon(mnt_ctx->tcon);
+	else if (mnt_ctx->ses)
+		cifs_put_smb_ses(mnt_ctx->ses);
+	else if (mnt_ctx->server)
+		cifs_put_tcp_session(mnt_ctx->server, 0);
+	mnt_ctx->cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_POSIX_PATHS;
+	free_xid(mnt_ctx->xid);
 }
 
 /* Get connections for tcp, ses and tcon */
-static int mount_get_conns(struct smb3_fs_context *ctx, struct cifs_sb_info *cifs_sb,
-			   unsigned int *xid,
-			   struct TCP_Server_Info **nserver,
-			   struct cifs_ses **nses, struct cifs_tcon **ntcon)
+static int mount_get_conns(struct mount_ctx *mnt_ctx)
 {
 	int rc = 0;
-	struct TCP_Server_Info *server;
-	struct cifs_ses *ses;
-	struct cifs_tcon *tcon;
-
-	*nserver = NULL;
-	*nses = NULL;
-	*ntcon = NULL;
+	struct TCP_Server_Info *server = NULL;
+	struct cifs_ses *ses = NULL;
+	struct cifs_tcon *tcon = NULL;
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
+	unsigned int xid;
 
-	*xid = get_xid();
+	xid = get_xid();
 
 	/* get a reference to a tcp session */
 	server = cifs_get_tcp_session(ctx);
 	if (IS_ERR(server)) {
 		rc = PTR_ERR(server);
-		return rc;
+		server = NULL;
+		goto out;
 	}
 
-	*nserver = server;
-
 	/* get a reference to a SMB session */
 	ses = cifs_get_smb_ses(server, ctx);
 	if (IS_ERR(ses)) {
 		rc = PTR_ERR(ses);
-		return rc;
+		ses = NULL;
+		goto out;
 	}
 
-	*nses = ses;
-
 	if ((ctx->persistent == true) && (!(ses->server->capabilities &
 					    SMB2_GLOBAL_CAP_PERSISTENT_HANDLES))) {
 		cifs_server_dbg(VFS, "persistent handles not supported by server\n");
-		return -EOPNOTSUPP;
+		rc = -EOPNOTSUPP;
+		goto out;
 	}
 
 	/* search for existing tcon to this server share */
 	tcon = cifs_get_tcon(ses, ctx);
 	if (IS_ERR(tcon)) {
 		rc = PTR_ERR(tcon);
-		return rc;
+		tcon = NULL;
+		goto out;
 	}
 
-	*ntcon = tcon;
-
 	/* if new SMB3.11 POSIX extensions are supported do not remap / and \ */
 	if (tcon->posix_extensions)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_POSIX_PATHS;
@@ -2946,17 +2994,19 @@ static int mount_get_conns(struct smb3_fs_context *ctx, struct cifs_sb_info *cif
 		 * reset of caps checks mount to see if unix extensions disabled
 		 * for just this mount.
 		 */
-		reset_cifs_unix_caps(*xid, tcon, cifs_sb, ctx);
+		reset_cifs_unix_caps(xid, tcon, cifs_sb, ctx);
 		if ((tcon->ses->server->tcpStatus == CifsNeedReconnect) &&
 		    (le64_to_cpu(tcon->fsUnixInfo.Capability) &
-		     CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP))
-			return -EACCES;
+		     CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)) {
+			rc = -EACCES;
+			goto out;
+		}
 	} else
 		tcon->unix_ext = 0; /* server does not support them */
 
 	/* do not care if a following call succeed - informational */
 	if (!tcon->pipe && server->ops->qfs_tcon) {
-		server->ops->qfs_tcon(*xid, tcon, cifs_sb);
+		server->ops->qfs_tcon(xid, tcon, cifs_sb);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE) {
 			if (tcon->fsDevInfo.DeviceCharacteristics &
 			    cpu_to_le32(FILE_READ_ONLY_DEVICE))
@@ -2980,7 +3030,13 @@ static int mount_get_conns(struct smb3_fs_context *ctx, struct cifs_sb_info *cif
 	    (cifs_sb->ctx->rsize > server->ops->negotiate_rsize(tcon, ctx)))
 		cifs_sb->ctx->rsize = server->ops->negotiate_rsize(tcon, ctx);
 
-	return 0;
+out:
+	mnt_ctx->server = server;
+	mnt_ctx->ses = ses;
+	mnt_ctx->tcon = tcon;
+	mnt_ctx->xid = xid;
+
+	return rc;
 }
 
 static int mount_setup_tlink(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
@@ -3010,18 +3066,17 @@ static int mount_setup_tlink(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
-static int mount_get_dfs_conns(struct smb3_fs_context *ctx, struct cifs_sb_info *cifs_sb,
-			       unsigned int *xid, struct TCP_Server_Info **nserver,
-			       struct cifs_ses **nses, struct cifs_tcon **ntcon)
+/* Get unique dfs connections */
+static int mount_get_dfs_conns(struct mount_ctx *mnt_ctx)
 {
 	int rc;
 
-	ctx->nosharesock = true;
-	rc = mount_get_conns(ctx, cifs_sb, xid, nserver, nses, ntcon);
-	if (*nserver) {
+	mnt_ctx->fs_ctx->nosharesock = true;
+	rc = mount_get_conns(mnt_ctx);
+	if (mnt_ctx->server) {
 		cifs_dbg(FYI, "%s: marking tcp session as a dfs connection\n", __func__);
 		spin_lock(&cifs_tcp_ses_lock);
-		(*nserver)->is_dfs_conn = true;
+		mnt_ctx->server->is_dfs_conn = true;
 		spin_unlock(&cifs_tcp_ses_lock);
 	}
 	return rc;
@@ -3063,201 +3118,49 @@ build_unc_path_to_root(const struct smb3_fs_context *ctx,
 }
 
 /*
- * expand_dfs_referral - Perform a dfs referral query and update the cifs_sb
+ * expand_dfs_referral - Update cifs_sb from dfs referral path
  *
- * If a referral is found, cifs_sb->ctx->mount_options will be (re-)allocated
- * to a string containing updated options for the submount.  Otherwise it
- * will be left untouched.
- *
- * Returns the rc from get_dfs_path to the caller, which can be used to
- * determine whether there were referrals.
+ * cifs_sb->ctx->mount_options will be (re-)allocated to a string containing updated options for the
+ * submount.  Otherwise it will be left untouched.
  */
-static int
-expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
-		    struct smb3_fs_context *ctx, struct cifs_sb_info *cifs_sb,
-		    char *ref_path)
+static int expand_dfs_referral(struct mount_ctx *mnt_ctx, const char *full_path,
+			       struct dfs_info3_param *referral)
 {
 	int rc;
-	struct dfs_info3_param referral = {0};
-	char *full_path = NULL, *mdata = NULL;
-
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
-		return -EREMOTE;
-
-	full_path = build_unc_path_to_root(ctx, cifs_sb, true);
-	if (IS_ERR(full_path))
-		return PTR_ERR(full_path);
-
-	rc = dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
-			    ref_path, &referral, NULL);
-	if (!rc) {
-		char *fake_devname = NULL;
-
-		mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
-						   full_path + 1, &referral,
-						   &fake_devname);
-		free_dfs_info_param(&referral);
-
-		if (IS_ERR(mdata)) {
-			rc = PTR_ERR(mdata);
-			mdata = NULL;
-		} else {
-			/*
-			 * We can not clear out the whole structure since we
-			 * no longer have an explicit function to parse
-			 * a mount-string. Instead we need to clear out the
-			 * individual fields that are no longer valid.
-			 */
-			kfree(ctx->prepath);
-			ctx->prepath = NULL;
-			rc = cifs_setup_volume_info(ctx, mdata, fake_devname);
-		}
-		kfree(fake_devname);
-		kfree(cifs_sb->ctx->mount_options);
-		cifs_sb->ctx->mount_options = mdata;
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
+	char *fake_devname = NULL, *mdata = NULL;
+
+	mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options, full_path + 1, referral,
+					   &fake_devname);
+	if (IS_ERR(mdata)) {
+		rc = PTR_ERR(mdata);
+		mdata = NULL;
+	} else {
+		/*
+		 * We can not clear out the whole structure since we no longer have an explicit
+		 * function to parse a mount-string. Instead we need to clear out the individual
+		 * fields that are no longer valid.
+		 */
+		kfree(ctx->prepath);
+		ctx->prepath = NULL;
+		rc = cifs_setup_volume_info(ctx, mdata, fake_devname);
 	}
-	kfree(full_path);
-	return rc;
-}
+	kfree(fake_devname);
+	kfree(cifs_sb->ctx->mount_options);
+	cifs_sb->ctx->mount_options = mdata;
 
-static int get_next_dfs_tgt(struct dfs_cache_tgt_list *tgt_list,
-			    struct dfs_cache_tgt_iterator **tgt_it)
-{
-	if (!*tgt_it)
-		*tgt_it = dfs_cache_get_tgt_iterator(tgt_list);
-	else
-		*tgt_it = dfs_cache_get_next_tgt(tgt_list, *tgt_it);
-	return !*tgt_it ? -EHOSTDOWN : 0;
+	return rc;
 }
+#endif
 
-static int update_vol_info(const struct dfs_cache_tgt_iterator *tgt_it,
-			   struct smb3_fs_context *fake_ctx, struct smb3_fs_context *ctx)
+/* TODO: all callers to this are broken. We are not parsing mount_options here
+ * we should pass a clone of the original context?
+ */
+int
+cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const char *devname)
 {
-	const char *tgt = dfs_cache_get_tgt_name(tgt_it);
-	int len = strlen(tgt) + 2;
-	char *new_unc;
-
-	new_unc = kmalloc(len, GFP_KERNEL);
-	if (!new_unc)
-		return -ENOMEM;
-	scnprintf(new_unc, len, "\\%s", tgt);
-
-	kfree(ctx->UNC);
-	ctx->UNC = new_unc;
-
-	if (fake_ctx->prepath) {
-		kfree(ctx->prepath);
-		ctx->prepath = fake_ctx->prepath;
-		fake_ctx->prepath = NULL;
-	}
-	memcpy(&ctx->dstaddr, &fake_ctx->dstaddr, sizeof(ctx->dstaddr));
-
-	return 0;
-}
-
-static int do_dfs_failover(const char *path, const char *full_path, struct cifs_sb_info *cifs_sb,
-			   struct smb3_fs_context *ctx, struct cifs_ses *root_ses,
-			   unsigned int *xid, struct TCP_Server_Info **server,
-			   struct cifs_ses **ses, struct cifs_tcon **tcon)
-{
-	int rc;
-	char *npath = NULL;
-	struct dfs_cache_tgt_list tgt_list = DFS_CACHE_TGT_LIST_INIT(tgt_list);
-	struct dfs_cache_tgt_iterator *tgt_it = NULL;
-	struct smb3_fs_context tmp_ctx = {NULL};
-
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
-		return -EOPNOTSUPP;
-
-	npath = dfs_cache_canonical_path(path, cifs_sb->local_nls, cifs_remap(cifs_sb));
-	if (IS_ERR(npath))
-		return PTR_ERR(npath);
-
-	cifs_dbg(FYI, "%s: path=%s full_path=%s\n", __func__, npath, full_path);
-
-	rc = dfs_cache_noreq_find(npath, NULL, &tgt_list);
-	if (rc)
-		goto out;
-	/*
-	 * We use a 'tmp_ctx' here because we need pass it down to the mount_{get,put} functions to
-	 * test connection against new DFS targets.
-	 */
-	rc = smb3_fs_context_dup(&tmp_ctx, ctx);
-	if (rc)
-		goto out;
-
-	for (;;) {
-		struct dfs_info3_param ref = {0};
-		char *fake_devname = NULL, *mdata = NULL;
-
-		/* Get next DFS target server - if any */
-		rc = get_next_dfs_tgt(&tgt_list, &tgt_it);
-		if (rc)
-			break;
-
-		rc = dfs_cache_get_tgt_referral(npath, tgt_it, &ref);
-		if (rc)
-			break;
-
-		cifs_dbg(FYI, "%s: old ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
-			 tmp_ctx.prepath);
-
-		mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options, full_path + 1, &ref,
-						   &fake_devname);
-		free_dfs_info_param(&ref);
-
-		if (IS_ERR(mdata)) {
-			rc = PTR_ERR(mdata);
-			mdata = NULL;
-		} else
-			rc = cifs_setup_volume_info(&tmp_ctx, mdata, fake_devname);
-
-		kfree(mdata);
-		kfree(fake_devname);
-
-		if (rc)
-			break;
-
-		cifs_dbg(FYI, "%s: new ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
-			 tmp_ctx.prepath);
-
-		mount_put_conns(cifs_sb, *xid, *server, *ses, *tcon);
-		rc = mount_get_dfs_conns(&tmp_ctx, cifs_sb, xid, server, ses, tcon);
-		if (!rc || (*server && *ses)) {
-			/*
-			 * We were able to connect to new target server. Update current context with
-			 * new target server.
-			 */
-			rc = update_vol_info(tgt_it, &tmp_ctx, ctx);
-			break;
-		}
-	}
-	if (!rc) {
-		cifs_dbg(FYI, "%s: final ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
-			 tmp_ctx.prepath);
-		/*
-		 * Update DFS target hint in DFS referral cache with the target server we
-		 * successfully reconnected to.
-		 */
-		rc = dfs_cache_update_tgthint(*xid, root_ses ? root_ses : *ses, cifs_sb->local_nls,
-					      cifs_remap(cifs_sb), path, tgt_it);
-	}
-
-out:
-	kfree(npath);
-	smb3_cleanup_fs_context_contents(&tmp_ctx);
-	dfs_cache_free_tgts(&tgt_list);
-	return rc;
-}
-#endif
-
-/* TODO: all callers to this are broken. We are not parsing mount_options here
- * we should pass a clone of the original context?
- */
-int
-cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const char *devname)
-{
-	int rc;
+	int rc;
 
 	if (devname) {
 		cifs_dbg(FYI, "%s: devname=%s\n", __func__, devname);
@@ -3353,12 +3256,14 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
  * Check if path is remote (e.g. a DFS share). Return -EREMOTE if it is,
  * otherwise 0.
  */
-static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
-			  const unsigned int xid,
-			  struct TCP_Server_Info *server,
-			  struct cifs_tcon *tcon)
+static int is_path_remote(struct mount_ctx *mnt_ctx)
 {
 	int rc;
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
+	struct TCP_Server_Info *server = mnt_ctx->server;
+	unsigned int xid = mnt_ctx->xid;
+	struct cifs_tcon *tcon = mnt_ctx->tcon;
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	char *full_path;
 
 	if (!server->ops->is_path_accessible)
@@ -3396,280 +3301,298 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
-static void set_root_ses(struct cifs_sb_info *cifs_sb, const uuid_t *mount_id, struct cifs_ses *ses,
-			 struct cifs_ses **root_ses)
+static void set_root_ses(struct mount_ctx *mnt_ctx)
 {
-	if (ses) {
+	if (mnt_ctx->ses) {
 		spin_lock(&cifs_tcp_ses_lock);
-		ses->ses_count++;
+		mnt_ctx->ses->ses_count++;
 		spin_unlock(&cifs_tcp_ses_lock);
-		dfs_cache_add_refsrv_session(mount_id, ses);
+		dfs_cache_add_refsrv_session(&mnt_ctx->mount_id, mnt_ctx->ses);
 	}
-	*root_ses = ses;
+	mnt_ctx->root_ses = mnt_ctx->ses;
 }
 
-/* Set up next dfs prefix path in @dfs_path */
-static int next_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
-			    const unsigned int xid, struct TCP_Server_Info *server,
-			    struct cifs_tcon *tcon, char **dfs_path)
+static int is_dfs_mount(struct mount_ctx *mnt_ctx, bool *isdfs, struct dfs_cache_tgt_list *root_tl)
 {
-	char *path, *npath;
-	int added_treename = is_tcon_dfs(tcon);
 	int rc;
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 
-	path = cifs_build_path_to_root(ctx, cifs_sb, tcon, added_treename);
-	if (!path)
-		return -ENOMEM;
+	*isdfs = true;
 
-	rc = is_path_remote(cifs_sb, ctx, xid, server, tcon);
-	if (rc == -EREMOTE) {
-		struct smb3_fs_context v = {NULL};
-		/* if @path contains a tree name, skip it in the prefix path */
-		if (added_treename) {
-			rc = smb3_parse_devname(path, &v);
-			if (rc)
-				goto out;
-			npath = build_unc_path_to_root(&v, cifs_sb, true);
-			smb3_cleanup_fs_context_contents(&v);
-		} else {
-			v.UNC = ctx->UNC;
-			v.prepath = path + 1;
-			npath = build_unc_path_to_root(&v, cifs_sb, true);
-		}
+	rc = mount_get_conns(mnt_ctx);
+	/*
+	 * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwise unconditionally
+	 * try to get an DFS referral (even cached) to determine whether it is an DFS mount.
+	 *
+	 * Skip prefix path to provide support for DFS referrals from w2k8 servers which don't seem
+	 * to respond with PATH_NOT_COVERED to requests that include the prefix.
+	 */
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
+	    dfs_cache_find(mnt_ctx->xid, mnt_ctx->ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
+			   ctx->UNC + 1, NULL, root_tl)) {
+		if (rc)
+			return rc;
+		/* Check if it is fully accessible and then mount it */
+		rc = is_path_remote(mnt_ctx);
+		if (!rc)
+			*isdfs = false;
+		else if (rc != -EREMOTE)
+			return rc;
+	}
+	return 0;
+}
 
-		if (IS_ERR(npath)) {
-			rc = PTR_ERR(npath);
-			goto out;
-		}
+static int connect_dfs_target(struct mount_ctx *mnt_ctx, const char *full_path,
+			      const char *ref_path, struct dfs_cache_tgt_iterator *tit)
+{
+	int rc;
+	struct dfs_info3_param ref = {};
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
+	char *oldmnt = cifs_sb->ctx->mount_options;
+
+	rc = dfs_cache_get_tgt_referral(ref_path, tit, &ref);
+	if (rc)
+		goto out;
+
+	rc = expand_dfs_referral(mnt_ctx, full_path, &ref);
+	if (rc)
+		goto out;
 
-		kfree(*dfs_path);
-		*dfs_path = npath;
-		rc = -EREMOTE;
+	/* Connect to new target only if we were redirected (e.g. mount options changed) */
+	if (oldmnt != cifs_sb->ctx->mount_options) {
+		mount_put_conns(mnt_ctx);
+		rc = mount_get_dfs_conns(mnt_ctx);
+	}
+	if (!rc) {
+		if (cifs_is_referral_server(mnt_ctx->tcon, &ref))
+			set_root_ses(mnt_ctx);
+		rc = dfs_cache_update_tgthint(mnt_ctx->xid, mnt_ctx->root_ses, cifs_sb->local_nls,
+					      cifs_remap(cifs_sb), ref_path, tit);
 	}
 
 out:
-	kfree(path);
+	free_dfs_info_param(&ref);
 	return rc;
 }
 
-/* Check if resolved targets can handle any DFS referrals */
-static int is_referral_server(const char *ref_path, struct cifs_sb_info *cifs_sb,
-			      struct cifs_tcon *tcon, bool *ref_server)
+static int connect_dfs_root(struct mount_ctx *mnt_ctx, struct dfs_cache_tgt_list *root_tl)
 {
 	int rc;
-	struct dfs_info3_param ref = {0};
+	char *full_path;
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
+	struct dfs_cache_tgt_iterator *tit;
 
-	cifs_dbg(FYI, "%s: ref_path=%s\n", __func__, ref_path);
+	/* Put initial connections as they might be shared with other mounts.  We need unique dfs
+	 * connections per mount to properly failover, so mount_get_dfs_conns() must be used from
+	 * now on.
+	 */
+	mount_put_conns(mnt_ctx);
+	mount_get_dfs_conns(mnt_ctx);
+	set_root_ses(mnt_ctx);
 
-	if (is_tcon_dfs(tcon)) {
-		*ref_server = true;
-	} else {
-		char *npath;
+	full_path = build_unc_path_to_root(ctx, cifs_sb, true);
+	if (IS_ERR(full_path))
+		return PTR_ERR(full_path);
 
-		npath = dfs_cache_canonical_path(ref_path, cifs_sb->local_nls, cifs_remap(cifs_sb));
-		if (IS_ERR(npath))
-			return PTR_ERR(npath);
+	mnt_ctx->origin_fullpath = dfs_cache_canonical_path(ctx->UNC, cifs_sb->local_nls,
+							    cifs_remap(cifs_sb));
+	if (IS_ERR(mnt_ctx->origin_fullpath)) {
+		rc = PTR_ERR(mnt_ctx->origin_fullpath);
+		mnt_ctx->origin_fullpath = NULL;
+		goto out;
+	}
 
-		rc = dfs_cache_noreq_find(npath, &ref, NULL);
-		kfree(npath);
-		if (rc) {
-			cifs_dbg(VFS, "%s: dfs_cache_noreq_find: failed (rc=%d)\n", __func__, rc);
-			return rc;
+	/* Try all dfs root targets */
+	for (rc = -ENOENT, tit = dfs_cache_get_tgt_iterator(root_tl);
+	     tit; tit = dfs_cache_get_next_tgt(root_tl, tit)) {
+		rc = connect_dfs_target(mnt_ctx, full_path, mnt_ctx->origin_fullpath + 1, tit);
+		if (!rc) {
+			mnt_ctx->leaf_fullpath = kstrdup(mnt_ctx->origin_fullpath, GFP_KERNEL);
+			if (!mnt_ctx->leaf_fullpath)
+				rc = -ENOMEM;
+			break;
 		}
-		cifs_dbg(FYI, "%s: ref.flags=0x%x\n", __func__, ref.flags);
-		/*
-		 * Check if all targets are capable of handling DFS referrals as per
-		 * MS-DFSC 2.2.4 RESP_GET_DFS_REFERRAL.
-		 */
-		*ref_server = !!(ref.flags & DFSREF_REFERRAL_SERVER);
-		free_dfs_info_param(&ref);
 	}
-	return 0;
+
+out:
+	kfree(full_path);
+	return rc;
 }
 
-int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
+static int __follow_dfs_link(struct mount_ctx *mnt_ctx)
 {
-	int rc = 0;
-	unsigned int xid;
-	struct TCP_Server_Info *server = NULL;
-	struct cifs_ses *ses = NULL, *root_ses = NULL;
-	struct cifs_tcon *tcon = NULL;
-	int count = 0;
-	uuid_t mount_id = {0};
-	char *ref_path = NULL, *full_path = NULL;
-	char *oldmnt = NULL;
-	bool ref_server = false;
+	int rc;
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
+	char *full_path;
+	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
+	struct dfs_cache_tgt_iterator *tit;
 
-	rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
-	/*
-	 * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwise unconditionally
-	 * try to get an DFS referral (even cached) to determine whether it is an DFS mount.
-	 *
-	 * Skip prefix path to provide support for DFS referrals from w2k8 servers which don't seem
-	 * to respond with PATH_NOT_COVERED to requests that include the prefix.
-	 */
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
-	    dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
-			   NULL)) {
-		if (rc)
-			goto error;
-		/* Check if it is fully accessible and then mount it */
-		rc = is_path_remote(cifs_sb, ctx, xid, server, tcon);
-		if (!rc)
-			goto out;
-		if (rc != -EREMOTE)
-			goto error;
+	full_path = build_unc_path_to_root(ctx, cifs_sb, true);
+	if (IS_ERR(full_path))
+		return PTR_ERR(full_path);
+
+	kfree(mnt_ctx->leaf_fullpath);
+	mnt_ctx->leaf_fullpath = dfs_cache_canonical_path(full_path, cifs_sb->local_nls,
+							  cifs_remap(cifs_sb));
+	if (IS_ERR(mnt_ctx->leaf_fullpath)) {
+		rc = PTR_ERR(mnt_ctx->leaf_fullpath);
+		mnt_ctx->leaf_fullpath = NULL;
+		goto out;
 	}
 
-	mount_put_conns(cifs_sb, xid, server, ses, tcon);
-	/*
-	 * Ignore error check here because we may failover to other targets from cached a
-	 * referral.
-	 */
-	(void)mount_get_dfs_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
+	/* Get referral from dfs link */
+	rc = dfs_cache_find(mnt_ctx->xid, mnt_ctx->root_ses, cifs_sb->local_nls,
+			    cifs_remap(cifs_sb), mnt_ctx->leaf_fullpath + 1, NULL, &tl);
+	if (rc)
+		goto out;
 
-	/* Get path of DFS root */
-	ref_path = build_unc_path_to_root(ctx, cifs_sb, false);
-	if (IS_ERR(ref_path)) {
-		rc = PTR_ERR(ref_path);
-		ref_path = NULL;
-		goto error;
+	/* Try all dfs link targets */
+	for (rc = -ENOENT, tit = dfs_cache_get_tgt_iterator(&tl);
+	     tit; tit = dfs_cache_get_next_tgt(&tl, tit)) {
+		rc = connect_dfs_target(mnt_ctx, full_path, mnt_ctx->leaf_fullpath + 1, tit);
+		if (!rc) {
+			rc = is_path_remote(mnt_ctx);
+			break;
+		}
+	}
+
+out:
+	kfree(full_path);
+	dfs_cache_free_tgts(&tl);
+	return rc;
+}
+
+static int follow_dfs_link(struct mount_ctx *mnt_ctx)
+{
+	int rc;
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
+	char *full_path;
+	int num_links = 0;
+
+	full_path = build_unc_path_to_root(ctx, cifs_sb, true);
+	if (IS_ERR(full_path))
+		return PTR_ERR(full_path);
+
+	kfree(mnt_ctx->origin_fullpath);
+	mnt_ctx->origin_fullpath = dfs_cache_canonical_path(full_path, cifs_sb->local_nls,
+							    cifs_remap(cifs_sb));
+	kfree(full_path);
+
+	if (IS_ERR(mnt_ctx->origin_fullpath)) {
+		rc = PTR_ERR(mnt_ctx->origin_fullpath);
+		mnt_ctx->origin_fullpath = NULL;
+		return rc;
 	}
 
-	uuid_gen(&mount_id);
-	set_root_ses(cifs_sb, &mount_id, ses, &root_ses);
 	do {
-		/* Save full path of last DFS path we used to resolve final target server */
-		kfree(full_path);
-		full_path = build_unc_path_to_root(ctx, cifs_sb, !!count);
-		if (IS_ERR(full_path)) {
-			rc = PTR_ERR(full_path);
-			full_path = NULL;
-			break;
-		}
-		/* Chase referral */
-		oldmnt = cifs_sb->ctx->mount_options;
-		rc = expand_dfs_referral(xid, root_ses, ctx, cifs_sb, ref_path + 1);
-		if (rc)
+		rc = __follow_dfs_link(mnt_ctx);
+		if (!rc || rc != -EREMOTE)
 			break;
-		/* Connect to new DFS target only if we were redirected */
-		if (oldmnt != cifs_sb->ctx->mount_options) {
-			mount_put_conns(cifs_sb, xid, server, ses, tcon);
-			rc = mount_get_dfs_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
-		}
-		if (rc && !server && !ses) {
-			/* Failed to connect. Try to connect to other targets in the referral. */
-			rc = do_dfs_failover(ref_path + 1, full_path, cifs_sb, ctx, root_ses, &xid,
-					     &server, &ses, &tcon);
-		}
-		if (rc == -EACCES || rc == -EOPNOTSUPP || !server || !ses)
-			break;
-		if (!tcon)
-			continue;
+	} while (rc = -ELOOP, ++num_links < MAX_NESTED_LINKS);
 
-		/* Make sure that requests go through new root servers */
-		rc = is_referral_server(ref_path + 1, cifs_sb, tcon, &ref_server);
-		if (rc)
-			break;
-		if (ref_server)
-			set_root_ses(cifs_sb, &mount_id, ses, &root_ses);
+	return rc;
+}
 
-		/* Get next dfs path and then continue chasing them if -EREMOTE */
-		rc = next_dfs_prepath(cifs_sb, ctx, xid, server, tcon, &ref_path);
-		/* Prevent recursion on broken link referrals */
-		if (rc == -EREMOTE && ++count > MAX_NESTED_LINKS)
-			rc = -ELOOP;
-	} while (rc == -EREMOTE);
+/* Set up DFS referral paths for failover */
+static void setup_server_referral_paths(struct mount_ctx *mnt_ctx)
+{
+	struct TCP_Server_Info *server = mnt_ctx->server;
+
+	server->origin_fullpath = mnt_ctx->origin_fullpath;
+	server->leaf_fullpath = mnt_ctx->leaf_fullpath;
+	server->current_fullpath = mnt_ctx->leaf_fullpath;
+	mnt_ctx->origin_fullpath = mnt_ctx->leaf_fullpath = NULL;
+}
 
-	if (rc || !tcon || !ses)
+int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
+{
+	int rc;
+	struct mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
+	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
+	bool isdfs;
+
+	rc = is_dfs_mount(&mnt_ctx, &isdfs, &tl);
+	if (rc)
 		goto error;
+	if (!isdfs)
+		goto out;
 
-	kfree(ref_path);
-	/*
-	 * Store DFS full path in both superblock and tree connect structures.
-	 *
-	 * For DFS root mounts, the prefix path (cifs_sb->prepath) is preserved during reconnect so
-	 * only the root path is set in cifs_sb->origin_fullpath and tcon->dfs_path. And for DFS
-	 * links, the prefix path is included in both and may be changed during reconnect.  See
-	 * cifs_tree_connect().
-	 */
-	ref_path = dfs_cache_canonical_path(full_path, cifs_sb->local_nls, cifs_remap(cifs_sb));
-	kfree(full_path);
-	full_path = NULL;
+	uuid_gen(&mnt_ctx.mount_id);
+	rc = connect_dfs_root(&mnt_ctx, &tl);
+	dfs_cache_free_tgts(&tl);
 
-	if (IS_ERR(ref_path)) {
-		rc = PTR_ERR(ref_path);
-		ref_path = NULL;
+	if (rc)
 		goto error;
-	}
-	cifs_sb->origin_fullpath = ref_path;
 
-	ref_path = kstrdup(cifs_sb->origin_fullpath, GFP_KERNEL);
-	if (!ref_path) {
-		rc = -ENOMEM;
+	rc = is_path_remote(&mnt_ctx);
+	if (rc == -EREMOTE)
+		rc = follow_dfs_link(&mnt_ctx);
+	if (rc)
 		goto error;
-	}
-	spin_lock(&cifs_tcp_ses_lock);
-	tcon->dfs_path = ref_path;
-	ref_path = NULL;
-	spin_unlock(&cifs_tcp_ses_lock);
 
+	setup_server_referral_paths(&mnt_ctx);
 	/*
-	 * After reconnecting to a different server, unique ids won't
-	 * match anymore, so we disable serverino. This prevents
-	 * dentry revalidation to think the dentry are stale (ESTALE).
+	 * After reconnecting to a different server, unique ids won't match anymore, so we disable
+	 * serverino. This prevents dentry revalidation to think the dentry are stale (ESTALE).
 	 */
 	cifs_autodisable_serverino(cifs_sb);
 	/*
-	 * Force the use of prefix path to support failover on DFS paths that
-	 * resolve to targets that have different prefix paths.
+	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
+	 * that have different prefix paths.
 	 */
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	kfree(cifs_sb->prepath);
 	cifs_sb->prepath = ctx->prepath;
 	ctx->prepath = NULL;
-	uuid_copy(&cifs_sb->dfs_mount_id, &mount_id);
+	uuid_copy(&cifs_sb->dfs_mount_id, &mnt_ctx.mount_id);
 
 out:
-	free_xid(xid);
-	cifs_try_adding_channels(cifs_sb, ses);
-	return mount_setup_tlink(cifs_sb, ses, tcon);
+	cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
+	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	if (rc)
+		goto error;
+
+	free_xid(mnt_ctx.xid);
+	return rc;
 
 error:
-	kfree(ref_path);
-	kfree(full_path);
-	kfree(cifs_sb->origin_fullpath);
-	dfs_cache_put_refsrv_sessions(&mount_id);
-	mount_put_conns(cifs_sb, xid, server, ses, tcon);
+	dfs_cache_put_refsrv_sessions(&mnt_ctx.mount_id);
+	kfree(mnt_ctx.origin_fullpath);
+	kfree(mnt_ctx.leaf_fullpath);
+	mount_put_conns(&mnt_ctx);
 	return rc;
 }
 #else
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 {
 	int rc = 0;
-	unsigned int xid;
-	struct cifs_ses *ses;
-	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
+	struct mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
 
-	rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
+	rc = mount_get_conns(&mnt_ctx);
 	if (rc)
 		goto error;
 
-	if (tcon) {
-		rc = is_path_remote(cifs_sb, ctx, xid, server, tcon);
+	if (mnt_ctx.tcon) {
+		rc = is_path_remote(&mnt_ctx);
 		if (rc == -EREMOTE)
 			rc = -EOPNOTSUPP;
 		if (rc)
 			goto error;
 	}
 
-	free_xid(xid);
+	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	if (rc)
+		goto error;
 
-	return mount_setup_tlink(cifs_sb, ses, tcon);
+	free_xid(mnt_ctx.xid);
+	return rc;
 
 error:
-	mount_put_conns(cifs_sb, xid, server, ses, tcon);
+	mount_put_conns(&mnt_ctx);
 	return rc;
 }
 #endif
@@ -3837,7 +3760,6 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	kfree(cifs_sb->prepath);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	dfs_cache_put_refsrv_sessions(&cifs_sb->dfs_mount_id);
-	kfree(cifs_sb->origin_fullpath);
 #endif
 	call_rcu(&cifs_sb->rcu, delayed_free);
 }
@@ -4164,104 +4086,249 @@ cifs_prune_tlinks(struct work_struct *work)
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
-int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const struct nls_table *nlsc)
+static void mark_tcon_tcp_ses_for_reconnect(struct cifs_tcon *tcon)
+{
+	int i;
+
+	for (i = 0; i < tcon->ses->chan_count; i++) {
+		spin_lock(&GlobalMid_Lock);
+		if (tcon->ses->chans[i].server->tcpStatus != CifsExiting)
+			tcon->ses->chans[i].server->tcpStatus = CifsNeedReconnect;
+		spin_unlock(&GlobalMid_Lock);
+	}
+}
+
+/* Update dfs referral path of superblock */
+static int update_server_fullpath(struct TCP_Server_Info *server, struct cifs_sb_info *cifs_sb,
+				  const char *target)
+{
+	int rc = 0;
+	size_t len = strlen(target);
+	char *refpath, *npath;
+
+	if (unlikely(len < 2 || *target != '\\'))
+		return -EINVAL;
+
+	if (target[1] == '\\') {
+		len += 1;
+		refpath = kmalloc(len, GFP_KERNEL);
+		if (!refpath)
+			return -ENOMEM;
+
+		scnprintf(refpath, len, "%s", target);
+	} else {
+		len += sizeof("\\");
+		refpath = kmalloc(len, GFP_KERNEL);
+		if (!refpath)
+			return -ENOMEM;
+
+		scnprintf(refpath, len, "\\%s", target);
+	}
+
+	npath = dfs_cache_canonical_path(refpath, cifs_sb->local_nls, cifs_remap(cifs_sb));
+	kfree(refpath);
+
+	if (IS_ERR(npath)) {
+		rc = PTR_ERR(npath);
+	} else {
+		mutex_lock(&server->refpath_lock);
+		kfree(server->leaf_fullpath);
+		server->leaf_fullpath = npath;
+		mutex_unlock(&server->refpath_lock);
+		server->current_fullpath = server->leaf_fullpath;
+	}
+	return rc;
+}
+
+static int target_share_matches_server(struct TCP_Server_Info *server, const char *tcp_host,
+				       size_t tcp_host_len, char *share, bool *target_match)
+{
+	int rc = 0;
+	const char *dfs_host;
+	size_t dfs_host_len;
+
+	*target_match = true;
+	extract_unc_hostname(share, &dfs_host, &dfs_host_len);
+
+	/* Check if hostnames or addresses match */
+	if (dfs_host_len != tcp_host_len || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
+		cifs_dbg(FYI, "%s: %.*s doesn't match %.*s\n", __func__, (int)dfs_host_len,
+			 dfs_host, (int)tcp_host_len, tcp_host);
+		rc = match_target_ip(server, dfs_host, dfs_host_len, target_match);
+		if (rc)
+			cifs_dbg(VFS, "%s: failed to match target ip: %d\n", __func__, rc);
+	}
+	return rc;
+}
+
+int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tcon,
+			      struct cifs_sb_info *cifs_sb, char *tree,
+			      struct dfs_cache_tgt_list *tl, struct dfs_info3_param *ref)
 {
 	int rc;
 	struct TCP_Server_Info *server = tcon->ses->server;
 	const struct smb_version_operations *ops = server->ops;
-	struct dfs_cache_tgt_list tl;
-	struct dfs_cache_tgt_iterator *it = NULL;
-	char *tree;
+	struct cifs_tcon *ipc = tcon->ses->tcon_ipc;
+	bool islink;
+	char *share = NULL, *prefix = NULL;
 	const char *tcp_host;
 	size_t tcp_host_len;
-	const char *dfs_host;
-	size_t dfs_host_len;
-	char *share = NULL, *prefix = NULL;
-	struct dfs_info3_param ref = {0};
-	bool isroot;
+	struct dfs_cache_tgt_iterator *tit;
+	bool target_match;
 
-	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
-	if (!tree)
-		return -ENOMEM;
+	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
 
-	/* If it is not dfs or there was no cached dfs referral, then reconnect to same share */
-	if (!tcon->dfs_path || dfs_cache_noreq_find(tcon->dfs_path + 1, &ref, &tl)) {
-		if (tcon->ipc) {
-			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
-			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
-		} else {
-			rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
-		}
+	islink = ref->server_type == DFS_TYPE_LINK;
+	free_dfs_info_param(ref);
+
+	tit = dfs_cache_get_tgt_iterator(tl);
+	if (!tit) {
+		rc = -ENOENT;
 		goto out;
 	}
 
-	isroot = ref.server_type == DFS_TYPE_ROOT;
-	free_dfs_info_param(&ref);
-
-	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
-
-	for (it = dfs_cache_get_tgt_iterator(&tl); it; it = dfs_cache_get_next_tgt(&tl, it)) {
-		bool target_match;
+	/* Try to tree connect to all dfs targets */
+	for (; tit; tit = dfs_cache_get_next_tgt(tl, tit)) {
+		const char *target = dfs_cache_get_tgt_name(tit);
+		struct dfs_cache_tgt_list ntl = DFS_CACHE_TGT_LIST_INIT(ntl);
 
 		kfree(share);
 		kfree(prefix);
-		share = NULL;
-		prefix = NULL;
 
-		rc = dfs_cache_get_tgt_share(tcon->dfs_path + 1, it, &share, &prefix);
+		/* Check if share matches with tcp ses */
+		rc = dfs_cache_get_tgt_share(server->current_fullpath + 1, tit, &share, &prefix);
 		if (rc) {
-			cifs_dbg(VFS, "%s: failed to parse target share %d\n",
-				 __func__, rc);
-			continue;
+			cifs_dbg(VFS, "%s: failed to parse target share: %d\n", __func__, rc);
+			break;
 		}
 
-		extract_unc_hostname(share, &dfs_host, &dfs_host_len);
-
-		if (dfs_host_len != tcp_host_len
-		    || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
-			cifs_dbg(FYI, "%s: %.*s doesn't match %.*s\n", __func__, (int)dfs_host_len,
-				 dfs_host, (int)tcp_host_len, tcp_host);
+		rc = target_share_matches_server(server, tcp_host, tcp_host_len, share,
+						 &target_match);
+		if (rc)
+			break;
+		if (!target_match) {
+			rc = -EHOSTUNREACH;
+			continue;
+		}
 
-			rc = match_target_ip(server, dfs_host, dfs_host_len, &target_match);
-			if (rc) {
-				cifs_dbg(VFS, "%s: failed to match target ip: %d\n", __func__, rc);
+		if (ipc->need_reconnect) {
+			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
+			rc = ops->tree_connect(xid, ipc->ses, tree, ipc, cifs_sb->local_nls);
+			if (rc)
 				break;
-			}
+		}
 
-			if (!target_match) {
-				cifs_dbg(FYI, "%s: skipping target\n", __func__);
+		scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
+		if (!islink) {
+			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, cifs_sb->local_nls);
+			break;
+		}
+		/*
+		 * If no dfs referrals were returned from link target, then just do a TREE_CONNECT
+		 * to it.  Otherwise, cache the dfs referral and then mark current tcp ses for
+		 * reconnect so either the demultiplex thread or the echo worker will reconnect to
+		 * newly resolved target.
+		 */
+		if (dfs_cache_find(xid, tcon->ses, cifs_sb->local_nls, cifs_remap(cifs_sb), target,
+				   ref, &ntl)) {
+			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, cifs_sb->local_nls);
+			if (rc)
 				continue;
-			}
+			rc = dfs_cache_noreq_update_tgthint(server->current_fullpath + 1, tit);
+			if (!rc)
+				rc = cifs_update_super_prepath(cifs_sb, prefix);
+			break;
 		}
+		/* Target is another dfs share */
+		rc = update_server_fullpath(server, cifs_sb, target);
+		dfs_cache_free_tgts(tl);
 
-		if (tcon->ipc) {
-			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", share);
-			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
+		if (!rc) {
+			rc = -EREMOTE;
+			list_replace_init(&ntl.tl_list, &tl->tl_list);
 		} else {
-			scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
-			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
-			/* Only handle prefix paths of DFS link targets */
-			if (!rc && !isroot) {
-				rc = update_super_prepath(tcon, prefix);
-				break;
-			}
+			dfs_cache_free_tgts(&ntl);
+			free_dfs_info_param(ref);
 		}
-		if (rc == -EREMOTE)
-			break;
+		break;
 	}
 
+out:
 	kfree(share);
 	kfree(prefix);
 
-	if (!rc) {
-		if (it)
-			rc = dfs_cache_noreq_update_tgthint(tcon->dfs_path + 1, it);
-		else
-			rc = -ENOENT;
+	return rc;
+}
+
+int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tcon,
+			    struct cifs_sb_info *cifs_sb, char *tree,
+			    struct dfs_cache_tgt_list *tl, struct dfs_info3_param *ref)
+{
+	int rc;
+	int num_links = 0;
+	struct TCP_Server_Info *server = tcon->ses->server;
+
+	do {
+		rc = __tree_connect_dfs_target(xid, tcon, cifs_sb, tree, tl, ref);
+		if (!rc || rc != -EREMOTE)
+			break;
+	} while (rc = -ELOOP, ++num_links < MAX_NESTED_LINKS);
+	/*
+	 * If we couldn't tree connect to any targets from last referral path, then retry from
+	 * original referral path.
+	 */
+	if (rc && server->current_fullpath != server->origin_fullpath) {
+		server->current_fullpath = server->origin_fullpath;
+		mark_tcon_tcp_ses_for_reconnect(tcon);
 	}
-	dfs_cache_free_tgts(&tl);
+
+	dfs_cache_free_tgts(tl);
+	return rc;
+}
+
+int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const struct nls_table *nlsc)
+{
+	int rc;
+	struct TCP_Server_Info *server = tcon->ses->server;
+	const struct smb_version_operations *ops = server->ops;
+	struct super_block *sb = NULL;
+	struct cifs_sb_info *cifs_sb;
+	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
+	char *tree;
+	struct dfs_info3_param ref = {0};
+
+	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
+	if (!tree)
+		return -ENOMEM;
+
+	if (tcon->ipc) {
+		scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
+		rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
+		goto out;
+	}
+
+	sb = cifs_get_tcp_super(server);
+	if (IS_ERR(sb)) {
+		rc = PTR_ERR(sb);
+		cifs_dbg(VFS, "%s: could not find superblock: %d\n", __func__, rc);
+		goto out;
+	}
+
+	cifs_sb = CIFS_SB(sb);
+
+	/* If it is not dfs or there was no cached dfs referral, then reconnect to same share */
+	if (!server->current_fullpath ||
+	    dfs_cache_noreq_find(server->current_fullpath + 1, &ref, &tl)) {
+		rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, cifs_sb->local_nls);
+		goto out;
+	}
+
+	rc = tree_connect_dfs_target(xid, tcon, cifs_sb, tree, &tl, &ref);
+
 out:
 	kfree(tree);
+	cifs_put_tcp_super(sb);
+
 	return rc;
 }
 #else
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 283745592844..1f3efa7821a0 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1364,9 +1364,9 @@ static void mark_for_reconnect_if_needed(struct cifs_tcon *tcon, struct dfs_cach
 }
 
 /* Refresh dfs referral of tcon and mark it for reconnect if needed */
-static int refresh_tcon(struct cifs_ses **sessions, struct cifs_tcon *tcon, bool force_refresh)
+static int __refresh_tcon(const char *path, struct cifs_ses **sessions, struct cifs_tcon *tcon,
+			  bool force_refresh)
 {
-	const char *path = tcon->dfs_path + 1;
 	struct cifs_ses *ses;
 	struct cache_entry *ce;
 	struct dfs_info3_param *refs = NULL;
@@ -1422,6 +1422,20 @@ static int refresh_tcon(struct cifs_ses **sessions, struct cifs_tcon *tcon, bool
 	return rc;
 }
 
+static int refresh_tcon(struct cifs_ses **sessions, struct cifs_tcon *tcon, bool force_refresh)
+{
+	struct TCP_Server_Info *server = tcon->ses->server;
+
+	mutex_lock(&server->refpath_lock);
+	if (strcasecmp(server->leaf_fullpath, server->origin_fullpath))
+		__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, force_refresh);
+	mutex_unlock(&server->refpath_lock);
+
+	__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, force_refresh);
+
+	return 0;
+}
+
 /**
  * dfs_cache_remount_fs - remount a DFS share
  *
@@ -1435,6 +1449,7 @@ static int refresh_tcon(struct cifs_ses **sessions, struct cifs_tcon *tcon, bool
 int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 {
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	struct mount_group *mg;
 	struct cifs_ses *sessions[CACHE_MAX_ENTRIES + 1] = {NULL};
 	int rc;
@@ -1443,13 +1458,15 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 		return -EINVAL;
 
 	tcon = cifs_sb_master_tcon(cifs_sb);
-	if (!tcon->dfs_path) {
-		cifs_dbg(FYI, "%s: not a dfs tcon\n", __func__);
+	server = tcon->ses->server;
+
+	if (!server->origin_fullpath) {
+		cifs_dbg(FYI, "%s: not a dfs mount\n", __func__);
 		return 0;
 	}
 
 	if (uuid_is_null(&cifs_sb->dfs_mount_id)) {
-		cifs_dbg(FYI, "%s: tcon has no dfs mount group id\n", __func__);
+		cifs_dbg(FYI, "%s: no dfs mount group id\n", __func__);
 		return -EINVAL;
 	}
 
@@ -1457,7 +1474,7 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	mg = find_mount_group_locked(&cifs_sb->dfs_mount_id);
 	if (IS_ERR(mg)) {
 		mutex_unlock(&mount_group_list_lock);
-		cifs_dbg(FYI, "%s: tcon has ipc session to refresh referral\n", __func__);
+		cifs_dbg(FYI, "%s: no ipc session for refreshing referral\n", __func__);
 		return PTR_ERR(mg);
 	}
 	kref_get(&mg->refcount);
@@ -1498,9 +1515,12 @@ static void refresh_mounts(struct cifs_ses **sessions)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		if (!server->is_dfs_conn)
+			continue;
+
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
-				if (tcon->dfs_path) {
+				if (!tcon->ipc && !tcon->need_reconnect) {
 					tcon->tc_count++;
 					list_add_tail(&tcon->ulist, &tcons);
 				}
@@ -1510,8 +1530,16 @@ static void refresh_mounts(struct cifs_ses **sessions)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, ntcon, &tcons, ulist) {
+		struct TCP_Server_Info *server = tcon->ses->server;
+
 		list_del_init(&tcon->ulist);
-		refresh_tcon(sessions, tcon, false);
+
+		mutex_lock(&server->refpath_lock);
+		if (strcasecmp(server->leaf_fullpath, server->origin_fullpath))
+			__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, false);
+		mutex_unlock(&server->refpath_lock);
+
+		__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, false);
 		cifs_put_tcon(tcon);
 	}
 }
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 699f676ded47..94143d7f58c7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -139,9 +139,6 @@ tconInfoFree(struct cifs_tcon *buf_to_free)
 	kfree(buf_to_free->nativeFileSystem);
 	kfree_sensitive(buf_to_free->password);
 	kfree(buf_to_free->crfid.fid);
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	kfree(buf_to_free->dfs_path);
-#endif
 	kfree(buf_to_free);
 }
 
@@ -1299,69 +1296,20 @@ int match_target_ip(struct TCP_Server_Info *server,
 	return rc;
 }
 
-static void tcon_super_cb(struct super_block *sb, void *arg)
+int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 {
-	struct super_cb_data *sd = arg;
-	struct cifs_tcon *tcon = sd->data;
-	struct cifs_sb_info *cifs_sb;
-
-	if (sd->sb)
-		return;
-
-	cifs_sb = CIFS_SB(sb);
-	if (tcon->dfs_path && cifs_sb->origin_fullpath &&
-	    !strcasecmp(tcon->dfs_path, cifs_sb->origin_fullpath))
-		sd->sb = sb;
-}
-
-static inline struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon)
-{
-	return __cifs_get_super(tcon_super_cb, tcon);
-}
-
-static inline void cifs_put_tcon_super(struct super_block *sb)
-{
-	__cifs_put_super(sb);
-}
-#else
-static inline struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon)
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
-static inline void cifs_put_tcon_super(struct super_block *sb)
-{
-}
-#endif
-
-int update_super_prepath(struct cifs_tcon *tcon, char *prefix)
-{
-	struct super_block *sb;
-	struct cifs_sb_info *cifs_sb;
-	int rc = 0;
-
-	sb = cifs_get_tcon_super(tcon);
-	if (IS_ERR(sb))
-		return PTR_ERR(sb);
-
-	cifs_sb = CIFS_SB(sb);
-
 	kfree(cifs_sb->prepath);
 
 	if (prefix && *prefix) {
 		cifs_sb->prepath = kstrdup(prefix, GFP_ATOMIC);
-		if (!cifs_sb->prepath) {
-			rc = -ENOMEM;
-			goto out;
-		}
+		if (!cifs_sb->prepath)
+			return -ENOMEM;
 
 		convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
 	} else
 		cifs_sb->prepath = NULL;
 
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
-
-out:
-	cifs_put_tcon_super(sb);
-	return rc;
+	return 0;
 }
+#endif
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 53e87466e3b2..5e6526c201fe 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2869,6 +2869,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	struct fsctl_get_dfs_referral_req *dfs_req = NULL;
 	struct get_dfs_referral_rsp *dfs_rsp = NULL;
 	u32 dfs_req_size = 0, dfs_rsp_size = 0;
+	int retry_count = 0;
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, search_name);
 
@@ -2920,11 +2921,14 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 				true /* is_fsctl */,
 				(char *)dfs_req, dfs_req_size, CIFSMaxBufSize,
 				(char **)&dfs_rsp, &dfs_rsp_size);
-	} while (rc == -EAGAIN);
+		if (!is_retryable_error(rc))
+			break;
+		usleep_range(512, 2048);
+	} while (++retry_count < 5);
 
 	if (rc) {
-		if ((rc != -ENOENT) && (rc != -EOPNOTSUPP))
-			cifs_tcon_dbg(VFS, "ioctl error in %s rc=%d\n", __func__, rc);
+		if (!is_retryable_error(rc) && rc != -ENOENT && rc != -EOPNOTSUPP)
+			cifs_tcon_dbg(VFS, "%s: ioctl error: rc=%d\n", __func__, rc);
 		goto out;
 	}
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8aa0372141f5..c0ea2813978b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -156,7 +156,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	if (tcon == NULL)
 		return 0;
 
-	if (smb2_command == SMB2_TREE_CONNECT)
+	/*
+	 * Need to also skip SMB2_IOCTL because it is used for checking nested dfs links in
+	 * cifs_tree_connect().
+	 */
+	if (smb2_command == SMB2_TREE_CONNECT || smb2_command == SMB2_IOCTL)
 		return 0;
 
 	if (tcon->tidStatus == CifsExiting) {
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 725607520e84..9e09caaf9b0b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5190,6 +5190,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	 * and it is decreased till we reach start.
 	 */
 again:
+	ret = 0;
 	if (SHIFT == SHIFT_LEFT)
 		iterator = &start;
 	else
@@ -5233,14 +5234,21 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 					ext4_ext_get_actual_len(extent);
 		} else {
 			extent = EXT_FIRST_EXTENT(path[depth].p_hdr);
-			if (le32_to_cpu(extent->ee_block) > 0)
+			if (le32_to_cpu(extent->ee_block) > start)
 				*iterator = le32_to_cpu(extent->ee_block) - 1;
-			else
-				/* Beginning is reached, end of the loop */
+			else if (le32_to_cpu(extent->ee_block) == start)
 				iterator = NULL;
-			/* Update path extent in case we need to stop */
-			while (le32_to_cpu(extent->ee_block) < start)
+			else {
+				extent = EXT_LAST_EXTENT(path[depth].p_hdr);
+				while (le32_to_cpu(extent->ee_block) >= start)
+					extent--;
+
+				if (extent == EXT_LAST_EXTENT(path[depth].p_hdr))
+					break;
+
 				extent++;
+				iterator = NULL;
+			}
 			path[depth].p_ext = extent;
 		}
 		ret = ext4_ext_shift_path_extents(path, shift, inode,
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2a27f0256fa3..f4a5a0c2858a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1739,18 +1739,26 @@ static int writeback_single_inode(struct inode *inode,
 	wb = inode_to_wb_and_lock_list(inode);
 	spin_lock(&inode->i_lock);
 	/*
-	 * If the inode is now fully clean, then it can be safely removed from
-	 * its writeback list (if any).  Otherwise the flusher threads are
-	 * responsible for the writeback lists.
+	 * If the inode is freeing, its i_io_list shoudn't be updated
+	 * as it can be finally deleted at this moment.
 	 */
-	if (!(inode->i_state & I_DIRTY_ALL))
-		inode_cgwb_move_to_attached(inode, wb);
-	else if (!(inode->i_state & I_SYNC_QUEUED)) {
-		if ((inode->i_state & I_DIRTY))
-			redirty_tail_locked(inode, wb);
-		else if (inode->i_state & I_DIRTY_TIME) {
-			inode->dirtied_when = jiffies;
-			inode_io_list_move_locked(inode, wb, &wb->b_dirty_time);
+	if (!(inode->i_state & I_FREEING)) {
+		/*
+		 * If the inode is now fully clean, then it can be safely
+		 * removed from its writeback list (if any). Otherwise the
+		 * flusher threads are responsible for the writeback lists.
+		 */
+		if (!(inode->i_state & I_DIRTY_ALL))
+			inode_cgwb_move_to_attached(inode, wb);
+		else if (!(inode->i_state & I_SYNC_QUEUED)) {
+			if ((inode->i_state & I_DIRTY))
+				redirty_tail_locked(inode, wb);
+			else if (inode->i_state & I_DIRTY_TIME) {
+				inode->dirtied_when = jiffies;
+				inode_io_list_move_locked(inode,
+							  wb,
+							  &wb->b_dirty_time);
+			}
 		}
 	}
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 307e7dae3ab6..cc95a1c37644 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2937,11 +2937,9 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		.mode = mode
 	};
 	int err;
-	bool lock_inode = !(mode & FALLOC_FL_KEEP_SIZE) ||
-			   (mode & (FALLOC_FL_PUNCH_HOLE |
-				    FALLOC_FL_ZERO_RANGE));
-
-	bool block_faults = FUSE_IS_DAX(inode) && lock_inode;
+	bool block_faults = FUSE_IS_DAX(inode) &&
+		(!(mode & FALLOC_FL_KEEP_SIZE) ||
+		 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 		     FALLOC_FL_ZERO_RANGE))
@@ -2950,22 +2948,20 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (fm->fc->no_fallocate)
 		return -EOPNOTSUPP;
 
-	if (lock_inode) {
-		inode_lock(inode);
-		if (block_faults) {
-			filemap_invalidate_lock(inode->i_mapping);
-			err = fuse_dax_break_layouts(inode, 0, 0);
-			if (err)
-				goto out;
-		}
+	inode_lock(inode);
+	if (block_faults) {
+		filemap_invalidate_lock(inode->i_mapping);
+		err = fuse_dax_break_layouts(inode, 0, 0);
+		if (err)
+			goto out;
+	}
 
-		if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)) {
-			loff_t endbyte = offset + length - 1;
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)) {
+		loff_t endbyte = offset + length - 1;
 
-			err = fuse_writeback_range(inode, offset, endbyte);
-			if (err)
-				goto out;
-		}
+		err = fuse_writeback_range(inode, offset, endbyte);
+		if (err)
+			goto out;
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
@@ -3015,8 +3011,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (block_faults)
 		filemap_invalidate_unlock(inode->i_mapping);
 
-	if (lock_inode)
-		inode_unlock(inode);
+	inode_unlock(inode);
 
 	fuse_flush_time_update(inode);
 
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 63722475e17e..51f4cb060231 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -495,14 +495,22 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 {
 	struct buffer_head *bh;
+	void *kaddr;
+	struct nilfs_segment_usage *su;
 	int ret;
 
+	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
 	if (!ret) {
 		mark_buffer_dirty(bh);
 		nilfs_mdt_mark_dirty(sufile);
+		kaddr = kmap_atomic(bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
+		nilfs_segment_usage_set_dirty(su);
+		kunmap_atomic(kaddr);
 		brelse(bh);
 	}
+	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
 }
 
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index f8feaed0b54d..85a98590b6ef 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -448,14 +448,22 @@ static void __zonefs_io_error(struct inode *inode, bool write)
 	struct super_block *sb = inode->i_sb;
 	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
 	unsigned int noio_flag;
-	unsigned int nr_zones =
-		zi->i_zone_size >> (sbi->s_zone_sectors_shift + SECTOR_SHIFT);
+	unsigned int nr_zones = 1;
 	struct zonefs_ioerr_data err = {
 		.inode = inode,
 		.write = write,
 	};
 	int ret;
 
+	/*
+	 * The only files that have more than one zone are conventional zone
+	 * files with aggregated conventional zones, for which the inode zone
+	 * size is always larger than the device zone size.
+	 */
+	if (zi->i_zone_size > bdev_zone_sectors(sb->s_bdev))
+		nr_zones = zi->i_zone_size >>
+			(sbi->s_zone_sectors_shift + SECTOR_SHIFT);
+
 	/*
 	 * Memory allocations in blkdev_report_zones() can trigger a memory
 	 * reclaim which may in turn cause a recursion into zonefs as well as
@@ -1354,6 +1362,14 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
 	zi->i_ztype = type;
 	zi->i_zsector = zone->start;
 	zi->i_zone_size = zone->len << SECTOR_SHIFT;
+	if (zi->i_zone_size > bdev_zone_sectors(sb->s_bdev) << SECTOR_SHIFT &&
+	    !(sbi->s_features & ZONEFS_F_AGGRCNV)) {
+		zonefs_err(sb,
+			   "zone size %llu doesn't match device's zone sectors %llu\n",
+			   zi->i_zone_size,
+			   bdev_zone_sectors(sb->s_bdev) << SECTOR_SHIFT);
+		return -EINVAL;
+	}
 
 	zi->i_max_size = min_t(loff_t, MAX_LFS_FILESIZE,
 			       zone->capacity << SECTOR_SHIFT);
@@ -1396,11 +1412,11 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
 	struct inode *dir = d_inode(parent);
 	struct dentry *dentry;
 	struct inode *inode;
-	int ret;
+	int ret = -ENOMEM;
 
 	dentry = d_alloc_name(parent, name);
 	if (!dentry)
-		return NULL;
+		return ERR_PTR(ret);
 
 	inode = new_inode(parent->d_sb);
 	if (!inode)
@@ -1425,7 +1441,7 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
 dput:
 	dput(dentry);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 struct zonefs_zone_data {
@@ -1445,7 +1461,7 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
 	struct blk_zone *zone, *next, *end;
 	const char *zgroup_name;
 	char *file_name;
-	struct dentry *dir;
+	struct dentry *dir, *dent;
 	unsigned int n = 0;
 	int ret;
 
@@ -1463,8 +1479,8 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
 		zgroup_name = "seq";
 
 	dir = zonefs_create_inode(sb->s_root, zgroup_name, NULL, type);
-	if (!dir) {
-		ret = -ENOMEM;
+	if (IS_ERR(dir)) {
+		ret = PTR_ERR(dir);
 		goto free;
 	}
 
@@ -1510,8 +1526,9 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
 		 * Use the file number within its group as file name.
 		 */
 		snprintf(file_name, ZONEFS_NAME_MAX - 1, "%u", n);
-		if (!zonefs_create_inode(dir, file_name, zone, type)) {
-			ret = -ENOMEM;
+		dent = zonefs_create_inode(dir, file_name, zone, type);
+		if (IS_ERR(dent)) {
+			ret = PTR_ERR(dent);
 			goto free;
 		}
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 86fa187f6d65..d5b6b1550d59 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -254,6 +254,7 @@ struct uart_port {
 	struct attribute_group	*attr_group;		/* port specific attributes */
 	const struct attribute_group **tty_groups;	/* all attributes (serial core use only) */
 	struct serial_rs485     rs485;
+	const struct serial_rs485	*rs485_supported;	/* Supported mask for serial_rs485 */
 	struct gpio_desc	*rs485_term_gpio;	/* enable RS485 bus termination */
 	struct serial_iso7816   iso7816;
 	void			*private_data;		/* generic platform data pointer */
diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 1c714336b863..221856f2d295 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -583,7 +583,7 @@ TRACE_EVENT(rxrpc_client,
 	    TP_fast_assign(
 		    __entry->conn = conn ? conn->debug_id : 0;
 		    __entry->channel = channel;
-		    __entry->usage = conn ? atomic_read(&conn->usage) : -2;
+		    __entry->usage = conn ? refcount_read(&conn->ref) : -2;
 		    __entry->op = op;
 		    __entry->cid = conn ? conn->proto.cid : 0;
 			   ),
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index daa481729e9b..27799acd0e5e 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -182,7 +182,7 @@
 #define AUDIT_MAX_KEY_LEN  256
 #define AUDIT_BITMASK_SIZE 64
 #define AUDIT_WORD(nr) ((__u32)((nr)/32))
-#define AUDIT_BIT(nr)  (1 << ((nr) - AUDIT_WORD(nr)*32))
+#define AUDIT_BIT(nr)  (1U << ((nr) - AUDIT_WORD(nr)*32))
 
 #define AUDIT_SYSCALL_CLASSES 16
 #define AUDIT_CLASS_DIR_WRITE 0
diff --git a/init/Kconfig b/init/Kconfig
index d19ed66aba3b..a4144393717b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -80,7 +80,7 @@ config CC_HAS_ASM_GOTO_OUTPUT
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	depends on CC_HAS_ASM_GOTO_OUTPUT
 	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
-	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
+	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
 
 config TOOLS_SUPPORT_RELR
 	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
diff --git a/kernel/gcov/clang.c b/kernel/gcov/clang.c
index cbb0bed958ab..7670a811a565 100644
--- a/kernel/gcov/clang.c
+++ b/kernel/gcov/clang.c
@@ -280,6 +280,8 @@ void gcov_info_add(struct gcov_info *dst, struct gcov_info *src)
 
 		for (i = 0; i < sfn_ptr->num_counters; i++)
 			dfn_ptr->counters[i] += sfn_ptr->counters[i];
+
+		sfn_ptr = list_next_entry(sfn_ptr, head);
 	}
 }
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0c3c26fb054f..9862372e0f01 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -222,11 +222,16 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 {
 	struct irq_desc *desc = irq_data_to_desc(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
+	const struct cpumask  *prog_mask;
 	int ret;
 
+	static DEFINE_RAW_SPINLOCK(tmp_mask_lock);
+	static struct cpumask tmp_mask;
+
 	if (!chip || !chip->irq_set_affinity)
 		return -EINVAL;
 
+	raw_spin_lock(&tmp_mask_lock);
 	/*
 	 * If this is a managed interrupt and housekeeping is enabled on
 	 * it check whether the requested affinity mask intersects with
@@ -248,24 +253,34 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	 */
 	if (irqd_affinity_is_managed(data) &&
 	    housekeeping_enabled(HK_FLAG_MANAGED_IRQ)) {
-		const struct cpumask *hk_mask, *prog_mask;
-
-		static DEFINE_RAW_SPINLOCK(tmp_mask_lock);
-		static struct cpumask tmp_mask;
+		const struct cpumask *hk_mask;
 
 		hk_mask = housekeeping_cpumask(HK_FLAG_MANAGED_IRQ);
 
-		raw_spin_lock(&tmp_mask_lock);
 		cpumask_and(&tmp_mask, mask, hk_mask);
 		if (!cpumask_intersects(&tmp_mask, cpu_online_mask))
 			prog_mask = mask;
 		else
 			prog_mask = &tmp_mask;
-		ret = chip->irq_set_affinity(data, prog_mask, force);
-		raw_spin_unlock(&tmp_mask_lock);
 	} else {
-		ret = chip->irq_set_affinity(data, mask, force);
+		prog_mask = mask;
 	}
+
+	/*
+	 * Make sure we only provide online CPUs to the irqchip,
+	 * unless we are being asked to force the affinity (in which
+	 * case we do as we are told).
+	 */
+	cpumask_and(&tmp_mask, prog_mask, cpu_online_mask);
+	if (!force && !cpumask_empty(&tmp_mask))
+		ret = chip->irq_set_affinity(data, &tmp_mask, force);
+	else if (force)
+		ret = chip->irq_set_affinity(data, mask, force);
+	else
+		ret = -EINVAL;
+
+	raw_spin_unlock(&tmp_mask_lock);
+
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
 	case IRQ_SET_MASK_OK_DONE:
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 7f350ae59c5f..d75586dc584f 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -596,6 +596,13 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 			irqd_clr_can_reserve(irq_data);
 			if (domain->flags & IRQ_DOMAIN_MSI_NOMASK_QUIRK)
 				irqd_set_msi_nomask_quirk(irq_data);
+			if ((info->flags & MSI_FLAG_ACTIVATE_EARLY) &&
+				irqd_affinity_is_managed(irq_data) &&
+				!cpumask_intersects(irq_data_get_affinity_mask(irq_data),
+						    cpu_online_mask)) {
+				irqd_set_managed_shutdown(irq_data);
+				continue;
+			}
 		}
 		ret = irq_domain_activate_irq(irq_data, can_reserve);
 		if (ret)
diff --git a/lib/vdso/Makefile b/lib/vdso/Makefile
index c415a685d61b..e814061d6aa0 100644
--- a/lib/vdso/Makefile
+++ b/lib/vdso/Makefile
@@ -17,6 +17,6 @@ $(error ARCH_REL_TYPE_ABS is not set)
 endif
 
 quiet_cmd_vdso_check = VDSOCHK $@
-      cmd_vdso_check = if $(OBJDUMP) -R $@ | egrep -h "$(ARCH_REL_TYPE_ABS)"; \
+      cmd_vdso_check = if $(OBJDUMP) -R $@ | grep -E -h "$(ARCH_REL_TYPE_ABS)"; \
 		       then (echo >&2 "$@: dynamic relocations are not supported"; \
 			     rm -f $@; /bin/false); fi
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 74296c2d1fed..1b63d6155416 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2791,8 +2791,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	enum lru_list lru;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	bool proportional_reclaim;
 	struct blk_plug plug;
-	bool scan_adjusted;
 
 	get_scan_count(lruvec, sc, nr);
 
@@ -2810,8 +2810,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	 * abort proportional reclaim if either the file or anon lru has already
 	 * dropped to zero at the first pass.
 	 */
-	scan_adjusted = (!cgroup_reclaim(sc) && !current_is_kswapd() &&
-			 sc->priority == DEF_PRIORITY);
+	proportional_reclaim = (!cgroup_reclaim(sc) && !current_is_kswapd() &&
+				sc->priority == DEF_PRIORITY);
 
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
@@ -2831,7 +2831,7 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 
 		cond_resched();
 
-		if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
+		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
 			continue;
 
 		/*
@@ -2882,8 +2882,6 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		nr_scanned = targets[lru] - nr[lru];
 		nr[lru] = targets[lru] * (100 - percentage) / 100;
 		nr[lru] -= min(nr[lru], nr_scanned);
-
-		scan_adjusted = true;
 	}
 	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index a8c1f742148c..31f2026514f3 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -204,9 +204,11 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 
 	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 
 	spin_unlock(&m->req_lock);
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 1c34e2266578..1d230f041386 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -270,7 +270,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
 	key->ct_zone = ct->zone.id;
 #endif
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
-	key->ct_mark = ct->mark;
+	key->ct_mark = READ_ONCE(ct->mark);
 #endif
 
 	cl = nf_ct_labels_find(ct);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 0ea29270d7e5..5bcfa1e9a941 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -137,6 +137,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * This unhashes the socket and releases the local port, if necessary.
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index fa663518fa0e..071620622e1e 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -967,6 +967,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 87983e70f03f..23b06063e1a5 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -403,6 +403,16 @@ config INET_IPCOMP
 
 	  If unsure, say Y.
 
+config INET_TABLE_PERTURB_ORDER
+	int "INET: Source port perturbation table size (as power of 2)" if EXPERT
+	default 16
+	help
+	  Source port perturbation table size (as power of 2) for
+	  RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm.
+
+	  The default is almost always what you want.
+	  Only change this if you know what you are doing.
+
 config INET_XFRM_TUNNEL
 	tristate
 	select INET_TUNNEL
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index dad5d29a6a8d..2ddba1e2cf22 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -311,6 +311,9 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 			xo->seq.low += skb_shinfo(skb)->gso_segs;
 	}
 
+	if (xo->seq.low < seq)
+		xo->seq.hi++;
+
 	esp.seqno = cpu_to_be64(seq + ((u64)xo->seq.hi << 32));
 
 	ip_hdr(skb)->tot_len = htons(skb->len);
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 19c6e7b93d3d..52f9f69f57b3 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1375,8 +1375,10 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 
 	/* The alias was already inserted, so the node must exist. */
 	l = l ? l : fib_find_node(t, &tp, key);
-	if (WARN_ON_ONCE(!l))
+	if (WARN_ON_ONCE(!l)) {
+		err = -ENOENT;
 		goto out_free_new_fa;
+	}
 
 	if (fib_find_alias(&l->leaf, new_fa->fa_slen, 0, 0, tb->tb_id, true) ==
 	    new_fa) {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index ce6a3873f89e..0d378da4b1b1 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -721,13 +721,13 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
  * property might be used by clever attacker.
+ *
  * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
- * attacks were since demonstrated, thus we use 65536 instead to really
- * give more isolation and privacy, at the expense of 256kB of kernel
- * memory.
+ * attacks were since demonstrated, thus we use 65536 by default instead
+ * to really give more isolation and privacy, at the expense of 256kB
+ * of kernel memory.
  */
-#define INET_TABLE_PERTURB_SHIFT 16
-#define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
+#define INET_TABLE_PERTURB_SIZE (1 << CONFIG_INET_TABLE_PERTURB_ORDER)
 static u32 *table_perturb;
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 459d7e630cb0..124bf8fdf924 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -364,6 +364,11 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 					   iph->tos, dev);
 		if (unlikely(err))
 			goto drop_error;
+	} else {
+		struct in_device *in_dev = __in_dev_get_rcu(dev);
+
+		if (in_dev && IN_DEV_ORCONF(in_dev, NOPOLICY))
+			IPCB(skb)->flags |= IPSKB_NOPOLICY;
 	}
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index b518f20c9a24..34737b1d6526 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -435,7 +435,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 	switch (ctinfo) {
 	case IP_CT_NEW:
-		ct->mark = hash;
+		WRITE_ONCE(ct->mark, hash);
 		break;
 	case IP_CT_RELATED:
 	case IP_CT_RELATED_REPLY:
@@ -452,7 +452,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 #ifdef DEBUG
 	nf_ct_dump_tuple_ip(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
-	pr_debug("hash=%u ct_hash=%u ", hash, ct->mark);
+	pr_debug("hash=%u ct_hash=%u ", hash, READ_ONCE(ct->mark));
 	if (!clusterip_responsible(cipinfo->config, hash)) {
 		pr_debug("not responsible\n");
 		return NF_DROP;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 42d4af632495..0e1fbad17dbe 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -324,6 +324,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * if necessary.
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 302170882382..4cc19acfc369 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -343,6 +343,9 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 			xo->seq.low += skb_shinfo(skb)->gso_segs;
 	}
 
+	if (xo->seq.low < seq)
+		xo->seq.hi++;
+
 	esp.seqno = cpu_to_be64(xo->seq.low + ((u64)xo->seq.hi << 32));
 
 	len = skb->len - sizeof(struct ipv6hdr);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 51f4d330e820..93b3e7c247ce 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -339,6 +339,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 failure:
 	inet->inet_dport = 0;
 	sk->sk_route_caps = 0;
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index af7a4b8b1e9c..247296e3294b 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -289,9 +289,13 @@ int __init xfrm6_init(void)
 	if (ret)
 		goto out_state;
 
-	register_pernet_subsys(&xfrm6_net_ops);
+	ret = register_pernet_subsys(&xfrm6_net_ops);
+	if (ret)
+		goto out_protocol;
 out:
 	return ret;
+out_protocol:
+	xfrm6_protocol_fini();
 out_state:
 	xfrm6_state_fini();
 out_policy:
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 53cca9019158..1d6ae1df3886 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2905,7 +2905,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg) && aalg->available)
+		if (aalg_tmpl_set(t, aalg))
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2923,7 +2923,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
+		if (!(ealg_tmpl_set(t, ealg)))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2934,16 +2934,17 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg) && aalg->available)
+			if (aalg_tmpl_set(t, aalg))
 				sz += sizeof(struct sadb_comb);
 		}
 	}
 	return sz + sizeof(struct sadb_prop);
 }
 
-static void dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
+static int dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 {
 	struct sadb_prop *p;
+	int sz = 0;
 	int i;
 
 	p = skb_put(skb, sizeof(struct sadb_prop));
@@ -2971,13 +2972,17 @@ static void dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 			c->sadb_comb_soft_addtime = 20*60*60;
 			c->sadb_comb_hard_usetime = 8*60*60;
 			c->sadb_comb_soft_usetime = 7*60*60;
+			sz += sizeof(*c);
 		}
 	}
+
+	return sz + sizeof(*p);
 }
 
-static void dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
+static int dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 {
 	struct sadb_prop *p;
+	int sz = 0;
 	int i, k;
 
 	p = skb_put(skb, sizeof(struct sadb_prop));
@@ -3019,8 +3024,11 @@ static void dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 			c->sadb_comb_soft_addtime = 20*60*60;
 			c->sadb_comb_hard_usetime = 8*60*60;
 			c->sadb_comb_soft_usetime = 7*60*60;
+			sz += sizeof(*c);
 		}
 	}
+
+	return sz + sizeof(*p);
 }
 
 static int key_notify_policy_expire(struct xfrm_policy *xp, const struct km_event *c)
@@ -3150,6 +3158,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	struct sadb_x_sec_ctx *sec_ctx;
 	struct xfrm_sec_ctx *xfrm_ctx;
 	int ctx_size = 0;
+	int alg_size = 0;
 
 	sockaddr_size = pfkey_sockaddr_size(x->props.family);
 	if (!sockaddr_size)
@@ -3161,16 +3170,16 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 		sizeof(struct sadb_x_policy);
 
 	if (x->id.proto == IPPROTO_AH)
-		size += count_ah_combs(t);
+		alg_size = count_ah_combs(t);
 	else if (x->id.proto == IPPROTO_ESP)
-		size += count_esp_combs(t);
+		alg_size = count_esp_combs(t);
 
 	if ((xfrm_ctx = x->security)) {
 		ctx_size = PFKEY_ALIGN8(xfrm_ctx->ctx_len);
 		size +=  sizeof(struct sadb_x_sec_ctx) + ctx_size;
 	}
 
-	skb =  alloc_skb(size + 16, GFP_ATOMIC);
+	skb =  alloc_skb(size + alg_size + 16, GFP_ATOMIC);
 	if (skb == NULL)
 		return -ENOMEM;
 
@@ -3224,10 +3233,13 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	pol->sadb_x_policy_priority = xp->priority;
 
 	/* Set sadb_comb's. */
+	alg_size = 0;
 	if (x->id.proto == IPPROTO_AH)
-		dump_ah_combs(skb, t);
+		alg_size = dump_ah_combs(skb, t);
 	else if (x->id.proto == IPPROTO_ESP)
-		dump_esp_combs(skb, t);
+		alg_size = dump_esp_combs(skb, t);
+
+	hdr->sadb_msg_len += alg_size / 8;
 
 	/* security context */
 	if (xfrm_ctx) {
@@ -3382,7 +3394,7 @@ static int pfkey_send_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr,
 	hdr->sadb_msg_len = size / sizeof(uint64_t);
 	hdr->sadb_msg_errno = 0;
 	hdr->sadb_msg_reserved = 0;
-	hdr->sadb_msg_seq = x->km.seq = get_acqseq();
+	hdr->sadb_msg_seq = x->km.seq;
 	hdr->sadb_msg_pid = 0;
 
 	/* SA */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5311c3cd3050..9617ff8e2714 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1357,8 +1357,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	ieee80211_led_exit(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
-	if (local->wiphy_ciphers_allocated)
+	if (local->wiphy_ciphers_allocated) {
 		kfree(local->hw.wiphy->cipher_suites);
+		local->wiphy_ciphers_allocated = false;
+	}
 	kfree(local->int_scan_req);
 	return result;
 }
@@ -1426,8 +1428,10 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 	mutex_destroy(&local->iflist_mtx);
 	mutex_destroy(&local->mtx);
 
-	if (local->wiphy_ciphers_allocated)
+	if (local->wiphy_ciphers_allocated) {
 		kfree(local->hw.wiphy->cipher_suites);
+		local->wiphy_ciphers_allocated = false;
+	}
 
 	idr_for_each(&local->ack_status_frames,
 		     ieee80211_free_ack_frame, NULL);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index acc1c299f1ae..69d5e1ec6ede 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -710,7 +710,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
 			     struct sk_buff *skb)
 {
-	kfree_skb(skb);
+	ieee80211_free_txskb(&sdata->local->hw, skb);
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
 
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 3adc291d9ce1..7499192af586 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -916,7 +916,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_MULTI
 		if (h->bucketsize >= AHASH_MAX_TUNED)
 			goto set_full;
-		else if (h->bucketsize < multi)
+		else if (h->bucketsize <= multi)
 			h->bucketsize += AHASH_INIT_SIZE;
 #endif
 		if (n->size >= AHASH_MAX(h)) {
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index dd30c03d5a23..75d556d71652 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -151,18 +151,16 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
 		return -ERANGE;
 
-	if (retried) {
+	if (retried)
 		ip = ntohl(h->next.ip);
-		e.ip = htonl(ip);
-	}
 	for (; ip <= ip_to;) {
+		e.ip = htonl(ip);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
 
 		ip += hosts;
-		e.ip = htonl(ip);
-		if (e.ip == 0)
+		if (ip == 0)
 			return 0;
 
 		ret = 0;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9da5ee6c50cd..43ea8cfd374b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1735,7 +1735,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-			ct->mark = exp->master->mark;
+			ct->mark = READ_ONCE(exp->master->mark);
 #endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 			ct->secmark = exp->master->secmark;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ef0a78aa9ba9..1727a4c4764f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -322,9 +322,9 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_mark(struct sk_buff *skb, u32 mark)
 {
-	if (nla_put_be32(skb, CTA_MARK, htonl(ct->mark)))
+	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
 		goto nla_put_failure;
 	return 0;
 
@@ -537,7 +537,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, READ_ONCE(ct->mark)) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -716,6 +716,7 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
+	u32 mark;
 	int err;
 
 	if (events & (1 << IPCT_DESTROY)) {
@@ -820,8 +821,9 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((events & (1 << IPCT_MARK) || ct->mark)
-	    && ctnetlink_dump_mark(skb, ct) < 0)
+	mark = READ_ONCE(ct->mark);
+	if ((events & (1 << IPCT_MARK) || mark) &&
+	    ctnetlink_dump_mark(skb, mark) < 0)
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -1148,7 +1150,7 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((ct->mark & filter->mark.mask) != filter->mark.val)
+	if ((READ_ONCE(ct->mark) & filter->mark.mask) != filter->mark.val)
 		goto ignore_entry;
 #endif
 	status = (u32)READ_ONCE(ct->status);
@@ -2016,9 +2018,9 @@ static void ctnetlink_change_mark(struct nf_conn *ct,
 		mask = ~ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
 
 	mark = ntohl(nla_get_be32(cda[CTA_MARK]));
-	newmark = (ct->mark & mask) ^ mark;
-	if (newmark != ct->mark)
-		ct->mark = newmark;
+	newmark = (READ_ONCE(ct->mark) & mask) ^ mark;
+	if (newmark != READ_ONCE(ct->mark))
+		WRITE_ONCE(ct->mark, newmark);
 }
 #endif
 
@@ -2690,6 +2692,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
+	u32 mark;
 
 	zone = nf_ct_zone(ct);
 
@@ -2751,7 +2754,8 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (ct->mark && ctnetlink_dump_mark(skb, ct) < 0)
+	mark = READ_ONCE(ct->mark);
+	if (mark && ctnetlink_dump_mark(skb, mark) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 55aa55b252b2..4d85368203e0 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -363,7 +363,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	seq_printf(s, "mark=%u ", ct->mark);
+	seq_printf(s, "mark=%u ", READ_ONCE(ct->mark));
 #endif
 
 	ct_show_secctx(s, ct);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c4559fae8acd..66c9a6c2b9cf 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1074,6 +1074,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	struct flow_block_cb *block_cb, *next;
 	int err = 0;
 
+	down_write(&flowtable->flow_block_lock);
 	switch (cmd) {
 	case FLOW_BLOCK_BIND:
 		list_splice(&bo->cb_list, &flowtable->flow_block.cb_list);
@@ -1088,6 +1089,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 		WARN_ON_ONCE(1);
 		err = -EOPNOTSUPP;
 	}
+	up_write(&flowtable->flow_block_lock);
 
 	return err;
 }
@@ -1144,7 +1146,9 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
+	down_write(&flowtable->flow_block_lock);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
+	up_write(&flowtable->flow_block_lock);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 227f03db7ee1..3fac57d66dda 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5813,7 +5813,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					    &timeout);
 		if (err)
 			return err;
-	} else if (set->flags & NFT_SET_TIMEOUT) {
+	} else if (set->flags & NFT_SET_TIMEOUT &&
+		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
 		timeout = set->timeout;
 	}
 
@@ -5879,7 +5880,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			err = -EOPNOTSUPP;
 			goto err_set_elem_expr;
 		}
-	} else if (set->num_exprs > 0) {
+	} else if (set->num_exprs > 0 &&
+		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
 		err = nft_set_elem_expr_clone(ctx, set, expr_array);
 		if (err < 0)
 			goto err_set_elem_expr_clone;
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 9c7472af9e4a..bd468e955a21 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -97,7 +97,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		return;
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
-		*dest = ct->mark;
+		*dest = READ_ONCE(ct->mark);
 		return;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
@@ -296,8 +296,8 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 	switch (priv->key) {
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
-		if (ct->mark != value) {
-			ct->mark = value;
+		if (READ_ONCE(ct->mark) != value) {
+			WRITE_ONCE(ct->mark, value);
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		}
 		break;
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index e5ebc0810675..ad3c033db64e 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -30,6 +30,7 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
 	u_int32_t new_targetmark;
 	struct nf_conn *ct;
 	u_int32_t newmark;
+	u_int32_t oldmark;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct == NULL)
@@ -37,14 +38,15 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
 
 	switch (info->mode) {
 	case XT_CONNMARK_SET:
-		newmark = (ct->mark & ~info->ctmask) ^ info->ctmark;
+		oldmark = READ_ONCE(ct->mark);
+		newmark = (oldmark & ~info->ctmask) ^ info->ctmark;
 		if (info->shift_dir == D_SHIFT_RIGHT)
 			newmark >>= info->shift_bits;
 		else
 			newmark <<= info->shift_bits;
 
-		if (ct->mark != newmark) {
-			ct->mark = newmark;
+		if (READ_ONCE(ct->mark) != newmark) {
+			WRITE_ONCE(ct->mark, newmark);
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		}
 		break;
@@ -55,15 +57,15 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
 		else
 			new_targetmark <<= info->shift_bits;
 
-		newmark = (ct->mark & ~info->ctmask) ^
+		newmark = (READ_ONCE(ct->mark) & ~info->ctmask) ^
 			  new_targetmark;
-		if (ct->mark != newmark) {
-			ct->mark = newmark;
+		if (READ_ONCE(ct->mark) != newmark) {
+			WRITE_ONCE(ct->mark, newmark);
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		}
 		break;
 	case XT_CONNMARK_RESTORE:
-		new_targetmark = (ct->mark & info->ctmask);
+		new_targetmark = (READ_ONCE(ct->mark) & info->ctmask);
 		if (info->shift_dir == D_SHIFT_RIGHT)
 			new_targetmark >>= info->shift_bits;
 		else
@@ -126,7 +128,7 @@ connmark_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (ct == NULL)
 		return false;
 
-	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
+	return ((READ_ONCE(ct->mark) & info->mask) == info->mark) ^ info->invert;
 }
 
 static int connmark_mt_check(const struct xt_mtchk_param *par)
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 189c9f428a3c..7b6cf9a44aea 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -542,7 +542,7 @@ static int nci_open_device(struct nci_dev *ndev)
 		skb_queue_purge(&ndev->tx_q);
 
 		ndev->ops->close(ndev);
-		ndev->flags = 0;
+		ndev->flags &= BIT(NCI_UNREG);
 	}
 
 done:
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index aa5e712adf07..3d36ea5701f0 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -279,8 +279,10 @@ void nci_rx_data_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		 nci_plen(skb->data));
 
 	conn_info = nci_get_conn_info_by_conn_id(ndev, nci_conn_id(skb->data));
-	if (!conn_info)
+	if (!conn_info) {
+		kfree_skb(skb);
 		return;
+	}
 
 	/* strip the nci data header */
 	skb_pull(skb, NCI_DATA_HDR_SIZE);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index dc86f03309c1..7106ce231a2d 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -150,7 +150,7 @@ static u8 ovs_ct_get_state(enum ip_conntrack_info ctinfo)
 static u32 ovs_ct_get_mark(const struct nf_conn *ct)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
-	return ct ? ct->mark : 0;
+	return ct ? READ_ONCE(ct->mark) : 0;
 #else
 	return 0;
 #endif
@@ -338,9 +338,9 @@ static int ovs_ct_set_mark(struct nf_conn *ct, struct sw_flow_key *key,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
 	u32 new_mark;
 
-	new_mark = ct_mark | (ct->mark & ~(mask));
-	if (ct->mark != new_mark) {
-		ct->mark = new_mark;
+	new_mark = ct_mark | (READ_ONCE(ct->mark) & ~(mask));
+	if (READ_ONCE(ct->mark) != new_mark) {
+		WRITE_ONCE(ct->mark, new_mark);
 		if (nf_ct_is_confirmed(ct))
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		key->ct.mark = new_mark;
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 2b5f89713e36..ceba28e9dce6 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -351,7 +351,7 @@ static void rxrpc_dummy_notify_rx(struct sock *sk, struct rxrpc_call *rxcall,
  */
 void rxrpc_kernel_end_call(struct socket *sock, struct rxrpc_call *call)
 {
-	_enter("%d{%d}", call->debug_id, atomic_read(&call->usage));
+	_enter("%d{%d}", call->debug_id, refcount_read(&call->ref));
 
 	mutex_lock(&call->user_mutex);
 	rxrpc_release_call(rxrpc_sk(sock->sk), call);
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index f2e3fb77a02d..e0123efa2a62 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -15,14 +15,6 @@
 #include <keys/rxrpc-type.h>
 #include "protocol.h"
 
-#if 0
-#define CHECK_SLAB_OKAY(X)				     \
-	BUG_ON(atomic_read((X)) >> (sizeof(atomic_t) - 2) == \
-	       (POISON_FREE << 8 | POISON_FREE))
-#else
-#define CHECK_SLAB_OKAY(X) do {} while (0)
-#endif
-
 #define FCRYPT_BSIZE 8
 struct rxrpc_crypt {
 	union {
@@ -88,7 +80,7 @@ struct rxrpc_net {
 	struct work_struct	client_conn_reaper;
 	struct timer_list	client_conn_reap_timer;
 
-	struct list_head	local_endpoints;
+	struct hlist_head	local_endpoints;
 	struct mutex		local_mutex;	/* Lock for ->local_endpoints */
 
 	DECLARE_HASHTABLE	(peer_hash, 10);
@@ -279,9 +271,9 @@ struct rxrpc_security {
 struct rxrpc_local {
 	struct rcu_head		rcu;
 	atomic_t		active_users;	/* Number of users of the local endpoint */
-	atomic_t		usage;		/* Number of references to the structure */
+	refcount_t		ref;		/* Number of references to the structure */
 	struct rxrpc_net	*rxnet;		/* The network ns in which this resides */
-	struct list_head	link;
+	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct work_struct	processor;
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
@@ -304,7 +296,7 @@ struct rxrpc_local {
  */
 struct rxrpc_peer {
 	struct rcu_head		rcu;		/* This must be first */
-	atomic_t		usage;
+	refcount_t		ref;
 	unsigned long		hash_key;
 	struct hlist_node	hash_link;
 	struct rxrpc_local	*local;
@@ -406,7 +398,8 @@ enum rxrpc_conn_proto_state {
  */
 struct rxrpc_bundle {
 	struct rxrpc_conn_parameters params;
-	atomic_t		usage;
+	refcount_t		ref;
+	atomic_t		active;		/* Number of active users */
 	unsigned int		debug_id;
 	bool			try_upgrade;	/* True if the bundle is attempting upgrade */
 	bool			alloc_conn;	/* True if someone's getting a conn */
@@ -427,7 +420,7 @@ struct rxrpc_connection {
 	struct rxrpc_conn_proto	proto;
 	struct rxrpc_conn_parameters params;
 
-	atomic_t		usage;
+	refcount_t		ref;
 	struct rcu_head		rcu;
 	struct list_head	cache_link;
 
@@ -609,7 +602,7 @@ struct rxrpc_call {
 	int			error;		/* Local error incurred */
 	enum rxrpc_call_state	state;		/* current state of call */
 	enum rxrpc_call_completion completion;	/* Call completion condition */
-	atomic_t		usage;
+	refcount_t		ref;
 	u16			service_id;	/* service ID */
 	u8			security_ix;	/* Security type */
 	enum rxrpc_interruptibility interruptibility; /* At what point call may be interrupted */
@@ -1016,6 +1009,7 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *);
 extern const struct seq_operations rxrpc_call_seq_ops;
 extern const struct seq_operations rxrpc_connection_seq_ops;
 extern const struct seq_operations rxrpc_peer_seq_ops;
+extern const struct seq_operations rxrpc_local_seq_ops;
 
 /*
  * recvmsg.c
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 8b24ffbc72ef..99e10eea3732 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -91,7 +91,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 				  (head + 1) & (size - 1));
 
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_service,
-				 atomic_read(&conn->usage), here);
+				 refcount_read(&conn->ref), here);
 	}
 
 	/* Now it gets complicated, because calls get registered with the
@@ -104,7 +104,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	call->state = RXRPC_CALL_SERVER_PREALLOC;
 
 	trace_rxrpc_call(call->debug_id, rxrpc_call_new_service,
-			 atomic_read(&call->usage),
+			 refcount_read(&call->ref),
 			 here, (const void *)user_call_ID);
 
 	write_lock(&rx->call_lock);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index d674d90e7031..6401cdf7a624 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -112,7 +112,7 @@ struct rxrpc_call *rxrpc_find_call_by_user_ID(struct rxrpc_sock *rx,
 found_extant_call:
 	rxrpc_get_call(call, rxrpc_call_got);
 	read_unlock(&rx->call_lock);
-	_leave(" = %p [%d]", call, atomic_read(&call->usage));
+	_leave(" = %p [%d]", call, refcount_read(&call->ref));
 	return call;
 }
 
@@ -160,7 +160,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	spin_lock_init(&call->notify_lock);
 	spin_lock_init(&call->input_lock);
 	rwlock_init(&call->state_lock);
-	atomic_set(&call->usage, 1);
+	refcount_set(&call->ref, 1);
 	call->debug_id = debug_id;
 	call->tx_total_len = -1;
 	call->next_rx_timo = 20 * HZ;
@@ -301,7 +301,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	call->interruptibility = p->interruptibility;
 	call->tx_total_len = p->tx_total_len;
 	trace_rxrpc_call(call->debug_id, rxrpc_call_new_client,
-			 atomic_read(&call->usage),
+			 refcount_read(&call->ref),
 			 here, (const void *)p->user_call_ID);
 	if (p->kernel)
 		__set_bit(RXRPC_CALL_KERNEL, &call->flags);
@@ -354,7 +354,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 		goto error_attached_to_socket;
 
 	trace_rxrpc_call(call->debug_id, rxrpc_call_connected,
-			 atomic_read(&call->usage), here, NULL);
+			 refcount_read(&call->ref), here, NULL);
 
 	rxrpc_start_call_timer(call);
 
@@ -374,7 +374,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
 				    RX_CALL_DEAD, -EEXIST);
 	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
-			 atomic_read(&call->usage), here, ERR_PTR(-EEXIST));
+			 refcount_read(&call->ref), here, ERR_PTR(-EEXIST));
 	rxrpc_release_call(rx, call);
 	mutex_unlock(&call->user_mutex);
 	rxrpc_put_call(call, rxrpc_call_put);
@@ -388,7 +388,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	 */
 error_attached_to_socket:
 	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
-			 atomic_read(&call->usage), here, ERR_PTR(ret));
+			 refcount_read(&call->ref), here, ERR_PTR(ret));
 	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
 				    RX_CALL_DEAD, ret);
@@ -444,8 +444,9 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 bool rxrpc_queue_call(struct rxrpc_call *call)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_fetch_add_unless(&call->usage, 1, 0);
-	if (n == 0)
+	int n;
+
+	if (!__refcount_inc_not_zero(&call->ref, &n))
 		return false;
 	if (rxrpc_queue_work(&call->processor))
 		trace_rxrpc_call(call->debug_id, rxrpc_call_queued, n + 1,
@@ -461,7 +462,7 @@ bool rxrpc_queue_call(struct rxrpc_call *call)
 bool __rxrpc_queue_call(struct rxrpc_call *call)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_read(&call->usage);
+	int n = refcount_read(&call->ref);
 	ASSERTCMP(n, >=, 1);
 	if (rxrpc_queue_work(&call->processor))
 		trace_rxrpc_call(call->debug_id, rxrpc_call_queued_ref, n,
@@ -478,7 +479,7 @@ void rxrpc_see_call(struct rxrpc_call *call)
 {
 	const void *here = __builtin_return_address(0);
 	if (call) {
-		int n = atomic_read(&call->usage);
+		int n = refcount_read(&call->ref);
 
 		trace_rxrpc_call(call->debug_id, rxrpc_call_seen, n,
 				 here, NULL);
@@ -488,11 +489,11 @@ void rxrpc_see_call(struct rxrpc_call *call)
 bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_fetch_add_unless(&call->usage, 1, 0);
+	int n;
 
-	if (n == 0)
+	if (!__refcount_inc_not_zero(&call->ref, &n))
 		return false;
-	trace_rxrpc_call(call->debug_id, op, n, here, NULL);
+	trace_rxrpc_call(call->debug_id, op, n + 1, here, NULL);
 	return true;
 }
 
@@ -502,9 +503,10 @@ bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 void rxrpc_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_inc_return(&call->usage);
+	int n;
 
-	trace_rxrpc_call(call->debug_id, op, n, here, NULL);
+	__refcount_inc(&call->ref, &n);
+	trace_rxrpc_call(call->debug_id, op, n + 1, here, NULL);
 }
 
 /*
@@ -529,10 +531,10 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	struct rxrpc_connection *conn = call->conn;
 	bool put = false;
 
-	_enter("{%d,%d}", call->debug_id, atomic_read(&call->usage));
+	_enter("{%d,%d}", call->debug_id, refcount_read(&call->ref));
 
 	trace_rxrpc_call(call->debug_id, rxrpc_call_release,
-			 atomic_read(&call->usage),
+			 refcount_read(&call->ref),
 			 here, (const void *)call->flags);
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
@@ -621,14 +623,14 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 	struct rxrpc_net *rxnet = call->rxnet;
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = call->debug_id;
+	bool dead;
 	int n;
 
 	ASSERT(call != NULL);
 
-	n = atomic_dec_return(&call->usage);
+	dead = __refcount_dec_and_test(&call->ref, &n);
 	trace_rxrpc_call(debug_id, op, n, here, NULL);
-	ASSERTCMP(n, >=, 0);
-	if (n == 0) {
+	if (dead) {
 		_debug("call %d dead", call->debug_id);
 		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
@@ -718,7 +720,7 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 			list_del_init(&call->link);
 
 			pr_err("Call %p still in use (%d,%s,%lx,%lx)!\n",
-			       call, atomic_read(&call->usage),
+			       call, refcount_read(&call->ref),
 			       rxrpc_call_states[call->state],
 			       call->flags, call->events);
 
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 8120138dac01..bdb335cb2d05 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -40,6 +40,8 @@ __read_mostly unsigned long rxrpc_conn_idle_client_fast_expiry = 2 * HZ;
 DEFINE_IDR(rxrpc_client_conn_ids);
 static DEFINE_SPINLOCK(rxrpc_conn_id_lock);
 
+static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle);
+
 /*
  * Get a connection ID and epoch for a client connection from the global pool.
  * The connection struct pointer is then recorded in the idr radix tree.  The
@@ -102,7 +104,7 @@ void rxrpc_destroy_client_conn_ids(void)
 	if (!idr_is_empty(&rxrpc_client_conn_ids)) {
 		idr_for_each_entry(&rxrpc_client_conn_ids, conn, id) {
 			pr_err("AF_RXRPC: Leaked client conn %p {%d}\n",
-			       conn, atomic_read(&conn->usage));
+			       conn, refcount_read(&conn->ref));
 		}
 		BUG();
 	}
@@ -122,7 +124,8 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
 	if (bundle) {
 		bundle->params = *cp;
 		rxrpc_get_peer(bundle->params.peer);
-		atomic_set(&bundle->usage, 1);
+		refcount_set(&bundle->ref, 1);
+		atomic_set(&bundle->active, 1);
 		spin_lock_init(&bundle->channel_lock);
 		INIT_LIST_HEAD(&bundle->waiting_calls);
 	}
@@ -131,7 +134,7 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
 
 struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle)
 {
-	atomic_inc(&bundle->usage);
+	refcount_inc(&bundle->ref);
 	return bundle;
 }
 
@@ -144,10 +147,13 @@ static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
 void rxrpc_put_bundle(struct rxrpc_bundle *bundle)
 {
 	unsigned int d = bundle->debug_id;
-	unsigned int u = atomic_dec_return(&bundle->usage);
+	bool dead;
+	int r;
+
+	dead = __refcount_dec_and_test(&bundle->ref, &r);
 
-	_debug("PUT B=%x %u", d, u);
-	if (u == 0)
+	_debug("PUT B=%x %d", d, r - 1);
+	if (dead)
 		rxrpc_free_bundle(bundle);
 }
 
@@ -169,7 +175,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	atomic_set(&conn->usage, 1);
+	refcount_set(&conn->ref, 1);
 	conn->bundle		= bundle;
 	conn->params		= bundle->params;
 	conn->out_clientflag	= RXRPC_CLIENT_INITIATED;
@@ -195,7 +201,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	key_get(conn->params.key);
 
 	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_client,
-			 atomic_read(&conn->usage),
+			 refcount_read(&conn->ref),
 			 __builtin_return_address(0));
 
 	atomic_inc(&rxnet->nr_client_conns);
@@ -335,6 +341,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	rxrpc_free_bundle(candidate);
 found_bundle:
 	rxrpc_get_bundle(bundle);
+	atomic_inc(&bundle->active);
 	spin_unlock(&local->client_bundles_lock);
 	_leave(" = %u [found]", bundle->debug_id);
 	return bundle;
@@ -432,6 +439,7 @@ static void rxrpc_add_conn_to_bundle(struct rxrpc_bundle *bundle, gfp_t gfp)
 			if (old)
 				trace_rxrpc_client(old, -1, rxrpc_client_replace);
 			candidate->bundle_shift = shift;
+			atomic_inc(&bundle->active);
 			bundle->conns[i] = candidate;
 			for (j = 0; j < RXRPC_MAXCALLS; j++)
 				set_bit(shift + j, &bundle->avail_chans);
@@ -722,6 +730,7 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 	smp_rmb();
 
 out_put_bundle:
+	rxrpc_deactivate_bundle(bundle);
 	rxrpc_put_bundle(bundle);
 out:
 	_leave(" = %d", ret);
@@ -897,9 +906,8 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 {
 	struct rxrpc_bundle *bundle = conn->bundle;
-	struct rxrpc_local *local = bundle->params.local;
 	unsigned int bindex;
-	bool need_drop = false, need_put = false;
+	bool need_drop = false;
 	int i;
 
 	_enter("C=%x", conn->debug_id);
@@ -918,15 +926,22 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 	}
 	spin_unlock(&bundle->channel_lock);
 
-	/* If there are no more connections, remove the bundle */
-	if (!bundle->avail_chans) {
-		_debug("maybe unbundle");
-		spin_lock(&local->client_bundles_lock);
+	if (need_drop) {
+		rxrpc_deactivate_bundle(bundle);
+		rxrpc_put_connection(conn);
+	}
+}
 
-		for (i = 0; i < ARRAY_SIZE(bundle->conns); i++)
-			if (bundle->conns[i])
-				break;
-		if (i == ARRAY_SIZE(bundle->conns) && !bundle->params.exclusive) {
+/*
+ * Drop the active count on a bundle.
+ */
+static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle)
+{
+	struct rxrpc_local *local = bundle->params.local;
+	bool need_put = false;
+
+	if (atomic_dec_and_lock(&bundle->active, &local->client_bundles_lock)) {
+		if (!bundle->params.exclusive) {
 			_debug("erase bundle");
 			rb_erase(&bundle->local_node, &local->client_bundles);
 			need_put = true;
@@ -936,10 +951,6 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 		if (need_put)
 			rxrpc_put_bundle(bundle);
 	}
-
-	if (need_drop)
-		rxrpc_put_connection(conn);
-	_leave("");
 }
 
 /*
@@ -966,14 +977,13 @@ void rxrpc_put_client_conn(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = conn->debug_id;
-	int n;
+	bool dead;
+	int r;
 
-	n = atomic_dec_return(&conn->usage);
-	trace_rxrpc_conn(debug_id, rxrpc_conn_put_client, n, here);
-	if (n <= 0) {
-		ASSERTCMP(n, >=, 0);
+	dead = __refcount_dec_and_test(&conn->ref, &r);
+	trace_rxrpc_conn(debug_id, rxrpc_conn_put_client, r - 1, here);
+	if (dead)
 		rxrpc_kill_client_conn(conn);
-	}
 }
 
 /*
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 660cd9b1a465..22089e37e97f 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -104,7 +104,7 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 			goto not_found;
 		*_peer = peer;
 		conn = rxrpc_find_service_conn_rcu(peer, skb);
-		if (!conn || atomic_read(&conn->usage) == 0)
+		if (!conn || refcount_read(&conn->ref) == 0)
 			goto not_found;
 		_leave(" = %p", conn);
 		return conn;
@@ -114,7 +114,7 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 		 */
 		conn = idr_find(&rxrpc_client_conn_ids,
 				sp->hdr.cid >> RXRPC_CIDSHIFT);
-		if (!conn || atomic_read(&conn->usage) == 0) {
+		if (!conn || refcount_read(&conn->ref) == 0) {
 			_debug("no conn");
 			goto not_found;
 		}
@@ -263,11 +263,12 @@ void rxrpc_kill_connection(struct rxrpc_connection *conn)
 bool rxrpc_queue_conn(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_fetch_add_unless(&conn->usage, 1, 0);
-	if (n == 0)
+	int r;
+
+	if (!__refcount_inc_not_zero(&conn->ref, &r))
 		return false;
 	if (rxrpc_queue_work(&conn->processor))
-		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_queued, n + 1, here);
+		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_queued, r + 1, here);
 	else
 		rxrpc_put_connection(conn);
 	return true;
@@ -280,7 +281,7 @@ void rxrpc_see_connection(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
 	if (conn) {
-		int n = atomic_read(&conn->usage);
+		int n = refcount_read(&conn->ref);
 
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_seen, n, here);
 	}
@@ -292,9 +293,10 @@ void rxrpc_see_connection(struct rxrpc_connection *conn)
 struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_inc_return(&conn->usage);
+	int r;
 
-	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, n, here);
+	__refcount_inc(&conn->ref, &r);
+	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, r, here);
 	return conn;
 }
 
@@ -305,11 +307,11 @@ struct rxrpc_connection *
 rxrpc_get_connection_maybe(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
+	int r;
 
 	if (conn) {
-		int n = atomic_fetch_add_unless(&conn->usage, 1, 0);
-		if (n > 0)
-			trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, n + 1, here);
+		if (__refcount_inc_not_zero(&conn->ref, &r))
+			trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, r + 1, here);
 		else
 			conn = NULL;
 	}
@@ -333,12 +335,11 @@ void rxrpc_put_service_conn(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = conn->debug_id;
-	int n;
+	int r;
 
-	n = atomic_dec_return(&conn->usage);
-	trace_rxrpc_conn(debug_id, rxrpc_conn_put_service, n, here);
-	ASSERTCMP(n, >=, 0);
-	if (n == 1)
+	__refcount_dec(&conn->ref, &r);
+	trace_rxrpc_conn(debug_id, rxrpc_conn_put_service, r - 1, here);
+	if (r - 1 == 1)
 		rxrpc_set_service_reap_timer(conn->params.local->rxnet,
 					     jiffies + rxrpc_connection_expiry);
 }
@@ -351,9 +352,9 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 	struct rxrpc_connection *conn =
 		container_of(rcu, struct rxrpc_connection, rcu);
 
-	_enter("{%d,u=%d}", conn->debug_id, atomic_read(&conn->usage));
+	_enter("{%d,u=%d}", conn->debug_id, refcount_read(&conn->ref));
 
-	ASSERTCMP(atomic_read(&conn->usage), ==, 0);
+	ASSERTCMP(refcount_read(&conn->ref), ==, 0);
 
 	_net("DESTROY CONN %d", conn->debug_id);
 
@@ -392,8 +393,8 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 
 	write_lock(&rxnet->conn_lock);
 	list_for_each_entry_safe(conn, _p, &rxnet->service_conns, link) {
-		ASSERTCMP(atomic_read(&conn->usage), >, 0);
-		if (likely(atomic_read(&conn->usage) > 1))
+		ASSERTCMP(refcount_read(&conn->ref), >, 0);
+		if (likely(refcount_read(&conn->ref) > 1))
 			continue;
 		if (conn->state == RXRPC_CONN_SERVICE_PREALLOC)
 			continue;
@@ -405,7 +406,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 				expire_at = idle_timestamp + rxrpc_closed_conn_expiry * HZ;
 
 			_debug("reap CONN %d { u=%d,t=%ld }",
-			       conn->debug_id, atomic_read(&conn->usage),
+			       conn->debug_id, refcount_read(&conn->ref),
 			       (long)expire_at - (long)now);
 
 			if (time_before(now, expire_at)) {
@@ -418,7 +419,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 		/* The usage count sits at 1 whilst the object is unused on the
 		 * list; we reduce that to 0 to make the object unavailable.
 		 */
-		if (atomic_cmpxchg(&conn->usage, 1, 0) != 1)
+		if (!refcount_dec_if_one(&conn->ref))
 			continue;
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_reap_service, 0, NULL);
 
@@ -442,7 +443,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 				  link);
 		list_del_init(&conn->link);
 
-		ASSERTCMP(atomic_read(&conn->usage), ==, 0);
+		ASSERTCMP(refcount_read(&conn->ref), ==, 0);
 		rxrpc_kill_connection(conn);
 	}
 
@@ -470,7 +471,7 @@ void rxrpc_destroy_all_connections(struct rxrpc_net *rxnet)
 	write_lock(&rxnet->conn_lock);
 	list_for_each_entry_safe(conn, _p, &rxnet->service_conns, link) {
 		pr_err("AF_RXRPC: Leaked conn %p {%d}\n",
-		       conn, atomic_read(&conn->usage));
+		       conn, refcount_read(&conn->ref));
 		leak = true;
 	}
 	write_unlock(&rxnet->conn_lock);
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index e1966dfc9152..6e6aa02c6f9e 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -9,7 +9,7 @@
 #include "ar-internal.h"
 
 static struct rxrpc_bundle rxrpc_service_dummy_bundle = {
-	.usage		= ATOMIC_INIT(1),
+	.ref		= REFCOUNT_INIT(1),
 	.debug_id	= UINT_MAX,
 	.channel_lock	= __SPIN_LOCK_UNLOCKED(&rxrpc_service_dummy_bundle.channel_lock),
 };
@@ -99,7 +99,7 @@ static void rxrpc_publish_service_conn(struct rxrpc_peer *peer,
 	return;
 
 found_extant_conn:
-	if (atomic_read(&cursor->usage) == 0)
+	if (refcount_read(&cursor->ref) == 0)
 		goto replace_old_connection;
 	write_sequnlock_bh(&peer->service_conn_lock);
 	/* We should not be able to get here.  rxrpc_incoming_connection() is
@@ -132,7 +132,7 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		 * the rxrpc_connections list.
 		 */
 		conn->state = RXRPC_CONN_SERVICE_PREALLOC;
-		atomic_set(&conn->usage, 2);
+		refcount_set(&conn->ref, 2);
 		conn->bundle = rxrpc_get_bundle(&rxrpc_service_dummy_bundle);
 
 		atomic_inc(&rxnet->nr_conns);
@@ -142,7 +142,7 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		write_unlock(&rxnet->conn_lock);
 
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_service,
-				 atomic_read(&conn->usage),
+				 refcount_read(&conn->ref),
 				 __builtin_return_address(0));
 	}
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 3521ebd0ee41..721d847ba92b 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1190,8 +1190,6 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
  */
 static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 {
-	CHECK_SLAB_OKAY(&local->usage);
-
 	if (rxrpc_get_local_maybe(local)) {
 		skb_queue_tail(&local->reject_queue, skb);
 		rxrpc_queue_local(local);
@@ -1449,7 +1447,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		}
 	}
 
-	if (!call || atomic_read(&call->usage) == 0) {
+	if (!call || refcount_read(&call->ref) == 0) {
 		if (rxrpc_to_client(sp) ||
 		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
 			goto bad_message;
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 1d15940f61d7..38ea98ff426b 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -79,10 +79,10 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 
 	local = kzalloc(sizeof(struct rxrpc_local), GFP_KERNEL);
 	if (local) {
-		atomic_set(&local->usage, 1);
+		refcount_set(&local->ref, 1);
 		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
-		INIT_LIST_HEAD(&local->link);
+		INIT_HLIST_NODE(&local->link);
 		INIT_WORK(&local->processor, rxrpc_local_processor);
 		init_rwsem(&local->defrag_sem);
 		skb_queue_head_init(&local->reject_queue);
@@ -181,7 +181,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 {
 	struct rxrpc_local *local;
 	struct rxrpc_net *rxnet = rxrpc_net(net);
-	struct list_head *cursor;
+	struct hlist_node *cursor;
 	const char *age;
 	long diff;
 	int ret;
@@ -191,16 +191,12 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 
 	mutex_lock(&rxnet->local_mutex);
 
-	for (cursor = rxnet->local_endpoints.next;
-	     cursor != &rxnet->local_endpoints;
-	     cursor = cursor->next) {
-		local = list_entry(cursor, struct rxrpc_local, link);
+	hlist_for_each(cursor, &rxnet->local_endpoints) {
+		local = hlist_entry(cursor, struct rxrpc_local, link);
 
 		diff = rxrpc_local_cmp_key(local, srx);
-		if (diff < 0)
+		if (diff != 0)
 			continue;
-		if (diff > 0)
-			break;
 
 		/* Services aren't allowed to share transport sockets, so
 		 * reject that here.  It is possible that the object is dying -
@@ -212,9 +208,10 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 			goto addr_in_use;
 		}
 
-		/* Found a match.  We replace a dying object.  Attempting to
-		 * bind the transport socket may still fail if we're attempting
-		 * to use a local address that the dying object is still using.
+		/* Found a match.  We want to replace a dying object.
+		 * Attempting to bind the transport socket may still fail if
+		 * we're attempting to use a local address that the dying
+		 * object is still using.
 		 */
 		if (!rxrpc_use_local(local))
 			break;
@@ -231,10 +228,12 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 	if (ret < 0)
 		goto sock_error;
 
-	if (cursor != &rxnet->local_endpoints)
-		list_replace_init(cursor, &local->link);
-	else
-		list_add_tail(&local->link, cursor);
+	if (cursor) {
+		hlist_replace_rcu(cursor, &local->link);
+		cursor->pprev = NULL;
+	} else {
+		hlist_add_head_rcu(&local->link, &rxnet->local_endpoints);
+	}
 	age = "new";
 
 found:
@@ -267,10 +266,10 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
-	int n;
+	int r;
 
-	n = atomic_inc_return(&local->usage);
-	trace_rxrpc_local(local->debug_id, rxrpc_local_got, n, here);
+	__refcount_inc(&local->ref, &r);
+	trace_rxrpc_local(local->debug_id, rxrpc_local_got, r + 1, here);
 	return local;
 }
 
@@ -280,12 +279,12 @@ struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *local)
 struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
+	int r;
 
 	if (local) {
-		int n = atomic_fetch_add_unless(&local->usage, 1, 0);
-		if (n > 0)
+		if (__refcount_inc_not_zero(&local->ref, &r))
 			trace_rxrpc_local(local->debug_id, rxrpc_local_got,
-					  n + 1, here);
+					  r + 1, here);
 		else
 			local = NULL;
 	}
@@ -299,10 +298,10 @@ void rxrpc_queue_local(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = local->debug_id;
-	int n = atomic_read(&local->usage);
+	int r = refcount_read(&local->ref);
 
 	if (rxrpc_queue_work(&local->processor))
-		trace_rxrpc_local(debug_id, rxrpc_local_queued, n, here);
+		trace_rxrpc_local(debug_id, rxrpc_local_queued, r + 1, here);
 	else
 		rxrpc_put_local(local);
 }
@@ -314,15 +313,16 @@ void rxrpc_put_local(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id;
-	int n;
+	bool dead;
+	int r;
 
 	if (local) {
 		debug_id = local->debug_id;
 
-		n = atomic_dec_return(&local->usage);
-		trace_rxrpc_local(debug_id, rxrpc_local_put, n, here);
+		dead = __refcount_dec_and_test(&local->ref, &r);
+		trace_rxrpc_local(debug_id, rxrpc_local_put, r, here);
 
-		if (n == 0)
+		if (dead)
 			call_rcu(&local->rcu, rxrpc_local_rcu);
 	}
 }
@@ -375,7 +375,7 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 	local->dead = true;
 
 	mutex_lock(&rxnet->local_mutex);
-	list_del_init(&local->link);
+	hlist_del_init_rcu(&local->link);
 	mutex_unlock(&rxnet->local_mutex);
 
 	rxrpc_clean_up_local_conns(local);
@@ -410,7 +410,7 @@ static void rxrpc_local_processor(struct work_struct *work)
 		return;
 
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
-			  atomic_read(&local->usage), NULL);
+			  refcount_read(&local->ref), NULL);
 
 	do {
 		again = false;
@@ -462,11 +462,11 @@ void rxrpc_destroy_all_locals(struct rxrpc_net *rxnet)
 
 	flush_workqueue(rxrpc_workqueue);
 
-	if (!list_empty(&rxnet->local_endpoints)) {
+	if (!hlist_empty(&rxnet->local_endpoints)) {
 		mutex_lock(&rxnet->local_mutex);
-		list_for_each_entry(local, &rxnet->local_endpoints, link) {
+		hlist_for_each_entry(local, &rxnet->local_endpoints, link) {
 			pr_err("AF_RXRPC: Leaked local %p {%d}\n",
-			       local, atomic_read(&local->usage));
+			       local, refcount_read(&local->ref));
 		}
 		mutex_unlock(&rxnet->local_mutex);
 		BUG();
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index e4d6d432515b..bb4c25d6df64 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -72,7 +72,7 @@ static __net_init int rxrpc_init_net(struct net *net)
 	timer_setup(&rxnet->client_conn_reap_timer,
 		    rxrpc_client_conn_reap_timeout, 0);
 
-	INIT_LIST_HEAD(&rxnet->local_endpoints);
+	INIT_HLIST_HEAD(&rxnet->local_endpoints);
 	mutex_init(&rxnet->local_mutex);
 
 	hash_init(rxnet->peer_hash);
@@ -98,6 +98,9 @@ static __net_init int rxrpc_init_net(struct net *net)
 	proc_create_net("peers", 0444, rxnet->proc_net,
 			&rxrpc_peer_seq_ops,
 			sizeof(struct seq_net_private));
+	proc_create_net("locals", 0444, rxnet->proc_net,
+			&rxrpc_local_seq_ops,
+			sizeof(struct seq_net_private));
 	return 0;
 
 err_proc:
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 0298fe2ad6d3..26d2ae9baaf2 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -121,7 +121,7 @@ static struct rxrpc_peer *__rxrpc_lookup_peer_rcu(
 
 	hash_for_each_possible_rcu(rxnet->peer_hash, peer, hash_link, hash_key) {
 		if (rxrpc_peer_cmp_key(peer, local, srx, hash_key) == 0 &&
-		    atomic_read(&peer->usage) > 0)
+		    refcount_read(&peer->ref) > 0)
 			return peer;
 	}
 
@@ -140,7 +140,7 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *local,
 	peer = __rxrpc_lookup_peer_rcu(local, srx, hash_key);
 	if (peer) {
 		_net("PEER %d {%pISp}", peer->debug_id, &peer->srx.transport);
-		_leave(" = %p {u=%d}", peer, atomic_read(&peer->usage));
+		_leave(" = %p {u=%d}", peer, refcount_read(&peer->ref));
 	}
 	return peer;
 }
@@ -216,7 +216,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 
 	peer = kzalloc(sizeof(struct rxrpc_peer), gfp);
 	if (peer) {
-		atomic_set(&peer->usage, 1);
+		refcount_set(&peer->ref, 1);
 		peer->local = rxrpc_get_local(local);
 		INIT_HLIST_HEAD(&peer->error_targets);
 		peer->service_conns = RB_ROOT;
@@ -378,7 +378,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 
 	_net("PEER %d {%pISp}", peer->debug_id, &peer->srx.transport);
 
-	_leave(" = %p {u=%d}", peer, atomic_read(&peer->usage));
+	_leave(" = %p {u=%d}", peer, refcount_read(&peer->ref));
 	return peer;
 }
 
@@ -388,10 +388,10 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
-	int n;
+	int r;
 
-	n = atomic_inc_return(&peer->usage);
-	trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, n, here);
+	__refcount_inc(&peer->ref, &r);
+	trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, r + 1, here);
 	return peer;
 }
 
@@ -401,11 +401,11 @@ struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *peer)
 struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
+	int r;
 
 	if (peer) {
-		int n = atomic_fetch_add_unless(&peer->usage, 1, 0);
-		if (n > 0)
-			trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, n + 1, here);
+		if (__refcount_inc_not_zero(&peer->ref, &r))
+			trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, r + 1, here);
 		else
 			peer = NULL;
 	}
@@ -436,13 +436,14 @@ void rxrpc_put_peer(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id;
-	int n;
+	bool dead;
+	int r;
 
 	if (peer) {
 		debug_id = peer->debug_id;
-		n = atomic_dec_return(&peer->usage);
-		trace_rxrpc_peer(debug_id, rxrpc_peer_put, n, here);
-		if (n == 0)
+		dead = __refcount_dec_and_test(&peer->ref, &r);
+		trace_rxrpc_peer(debug_id, rxrpc_peer_put, r - 1, here);
+		if (dead)
 			__rxrpc_put_peer(peer);
 	}
 }
@@ -455,11 +456,12 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = peer->debug_id;
-	int n;
+	bool dead;
+	int r;
 
-	n = atomic_dec_return(&peer->usage);
-	trace_rxrpc_peer(debug_id, rxrpc_peer_put, n, here);
-	if (n == 0) {
+	dead = __refcount_dec_and_test(&peer->ref, &r);
+	trace_rxrpc_peer(debug_id, rxrpc_peer_put, r - 1, here);
+	if (dead) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
 		rxrpc_free_peer(peer);
@@ -481,7 +483,7 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
 		hlist_for_each_entry(peer, &rxnet->peer_hash[i], hash_link) {
 			pr_err("Leaked peer %u {%u} %pISp\n",
 			       peer->debug_id,
-			       atomic_read(&peer->usage),
+			       refcount_read(&peer->ref),
 			       &peer->srx.transport);
 		}
 	}
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 5a67955cc00f..245418943e01 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -101,7 +101,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   call->cid,
 		   call->call_id,
 		   rxrpc_is_service_call(call) ? "Svc" : "Clt",
-		   atomic_read(&call->usage),
+		   refcount_read(&call->ref),
 		   rxrpc_call_states[call->state],
 		   call->abort_code,
 		   call->debug_id,
@@ -183,7 +183,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		   conn->service_id,
 		   conn->proto.cid,
 		   rxrpc_conn_is_service(conn) ? "Svc" : "Clt",
-		   atomic_read(&conn->usage),
+		   refcount_read(&conn->ref),
 		   rxrpc_conn_states[conn->state],
 		   key_serial(conn->params.key),
 		   atomic_read(&conn->serial),
@@ -233,7 +233,7 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 		   " %3u %5u %6llus %8u %8u\n",
 		   lbuff,
 		   rbuff,
-		   atomic_read(&peer->usage),
+		   refcount_read(&peer->ref),
 		   peer->cong_cwnd,
 		   peer->mtu,
 		   now - peer->last_tx_at,
@@ -328,3 +328,72 @@ const struct seq_operations rxrpc_peer_seq_ops = {
 	.stop   = rxrpc_peer_seq_stop,
 	.show   = rxrpc_peer_seq_show,
 };
+
+/*
+ * Generate a list of extant virtual local endpoints in /proc/net/rxrpc/locals
+ */
+static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
+{
+	struct rxrpc_local *local;
+	char lbuff[50];
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq,
+			 "Proto Local                                          "
+			 " Use Act\n");
+		return 0;
+	}
+
+	local = hlist_entry(v, struct rxrpc_local, link);
+
+	sprintf(lbuff, "%pISpc", &local->srx.transport);
+
+	seq_printf(seq,
+		   "UDP   %-47.47s %3u %3u\n",
+		   lbuff,
+		   refcount_read(&local->ref),
+		   atomic_read(&local->active_users));
+
+	return 0;
+}
+
+static void *rxrpc_local_seq_start(struct seq_file *seq, loff_t *_pos)
+	__acquires(rcu)
+{
+	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
+	unsigned int n;
+
+	rcu_read_lock();
+
+	if (*_pos >= UINT_MAX)
+		return NULL;
+
+	n = *_pos;
+	if (n == 0)
+		return SEQ_START_TOKEN;
+
+	return seq_hlist_start_rcu(&rxnet->local_endpoints, n - 1);
+}
+
+static void *rxrpc_local_seq_next(struct seq_file *seq, void *v, loff_t *_pos)
+{
+	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
+
+	if (*_pos >= UINT_MAX)
+		return NULL;
+
+	return seq_hlist_next_rcu(v, &rxnet->local_endpoints, _pos);
+}
+
+static void rxrpc_local_seq_stop(struct seq_file *seq, void *v)
+	__releases(rcu)
+{
+	rcu_read_unlock();
+}
+
+const struct seq_operations rxrpc_local_seq_ops = {
+	.start  = rxrpc_local_seq_start,
+	.next   = rxrpc_local_seq_next,
+	.stop   = rxrpc_local_seq_stop,
+	.show   = rxrpc_local_seq_show,
+};
diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
index 0348d2bf6f7d..580a5acffee7 100644
--- a/net/rxrpc/skbuff.c
+++ b/net/rxrpc/skbuff.c
@@ -71,7 +71,6 @@ void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 	const void *here = __builtin_return_address(0);
 	if (skb) {
 		int n;
-		CHECK_SLAB_OKAY(&skb->users);
 		n = atomic_dec_return(select_skb_count(skb));
 		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
 				rxrpc_skb(skb)->rx_flags, here);
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 1e8ab4749c6c..4662a6ce8a7e 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -976,7 +976,7 @@ config NET_ACT_TUNNEL_KEY
 
 config NET_ACT_CT
 	tristate "connection tracking tc action"
-	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
+	depends on NET_CLS_ACT && NF_CONNTRACK && (!NF_NAT || NF_NAT) && NF_FLOW_TABLE
 	help
 	  Say Y here to allow sending the packets to conntrack module.
 
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 94e78ac7a748..032ef927d0eb 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -62,7 +62,7 @@ static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
 
 	c = nf_ct_get(skb, &ctinfo);
 	if (c) {
-		skb->mark = c->mark;
+		skb->mark = READ_ONCE(c->mark);
 		/* using overlimits stats to count how many packets marked */
 		ca->tcf_qstats.overlimits++;
 		goto out;
@@ -82,7 +82,7 @@ static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
 	c = nf_ct_tuplehash_to_ctrack(thash);
 	/* using overlimits stats to count how many packets marked */
 	ca->tcf_qstats.overlimits++;
-	skb->mark = c->mark;
+	skb->mark = READ_ONCE(c->mark);
 	nf_ct_put(c);
 
 out:
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index d85fdefe5730..81a2d6cbfb44 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -177,7 +177,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 	entry = tcf_ct_flow_table_flow_action_get_next(action);
 	entry->id = FLOW_ACTION_CT_METADATA;
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
-	entry->ct_metadata.mark = ct->mark;
+	entry->ct_metadata.mark = READ_ONCE(ct->mark);
 #endif
 	ctinfo = dir == IP_CT_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
 					     IP_CT_ESTABLISHED_REPLY;
@@ -856,9 +856,9 @@ static void tcf_ct_act_set_mark(struct nf_conn *ct, u32 mark, u32 mask)
 	if (!mask)
 		return;
 
-	new_mark = mark | (ct->mark & ~(mask));
-	if (ct->mark != new_mark) {
-		ct->mark = new_mark;
+	new_mark = mark | (READ_ONCE(ct->mark) & ~(mask));
+	if (READ_ONCE(ct->mark) != new_mark) {
+		WRITE_ONCE(ct->mark, new_mark);
 		if (nf_ct_is_confirmed(ct))
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 	}
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 549374a2d008..2d75fe1223ac 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -33,7 +33,7 @@ static void tcf_ctinfo_dscp_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 {
 	u8 dscp, newdscp;
 
-	newdscp = (((ct->mark & cp->dscpmask) >> cp->dscpmaskshift) << 2) &
+	newdscp = (((READ_ONCE(ct->mark) & cp->dscpmask) >> cp->dscpmaskshift) << 2) &
 		     ~INET_ECN_MASK;
 
 	switch (proto) {
@@ -73,7 +73,7 @@ static void tcf_ctinfo_cpmark_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 				  struct sk_buff *skb)
 {
 	ca->stats_cpmark_set++;
-	skb->mark = ct->mark & cp->cpmarkmask;
+	skb->mark = READ_ONCE(ct->mark) & cp->cpmarkmask;
 }
 
 static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
@@ -131,7 +131,7 @@ static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 	if (cp->mode & CTINFO_MODE_DSCP)
-		if (!cp->dscpstatemask || (ct->mark & cp->dscpstatemask))
+		if (!cp->dscpstatemask || (READ_ONCE(ct->mark) & cp->dscpstatemask))
 			tcf_ctinfo_dscp_set(ct, ca, cp, skb, wlen, proto);
 
 	if (cp->mode & CTINFO_MODE_CPMARK)
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index b3950963fc8f..dc29ac0f8d3f 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -384,6 +384,7 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 {
 	struct sctp_outq *q = &asoc->outqueue;
 	struct sctp_chunk *chk, *temp;
+	struct sctp_stream_out *sout;
 
 	q->sched->unsched_all(&asoc->stream);
 
@@ -398,12 +399,14 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		sctp_sched_dequeue_common(q, chk);
 		asoc->sent_cnt_removable--;
 		asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		if (chk->sinfo.sinfo_stream < asoc->stream.outcnt) {
-			struct sctp_stream_out *streamout =
-				SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 
-			streamout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		}
+		sout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
+		sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
+
+		/* clear out_curr if all frag chunks are pruned */
+		if (asoc->stream.out_curr == sout &&
+		    list_is_last(&chk->frag_list, &chk->msg->chunks))
+			asoc->stream.out_curr = NULL;
 
 		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index e8630707901e..e8dcdf267c0c 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -211,7 +211,10 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
 	u32 self;
 	int err;
 
-	skb_linearize(skb);
+	if (skb_linearize(skb)) {
+		kfree_skb(skb);
+		return;
+	}
 	hdr = buf_msg(skb);
 
 	if (caps & TIPC_NODE_ID128)
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index d92ec92f0b71..e3b427a70398 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -176,7 +176,7 @@ static void tipc_conn_close(struct tipc_conn *con)
 	conn_put(con);
 }
 
-static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
+static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s, struct socket *sock)
 {
 	struct tipc_conn *con;
 	int ret;
@@ -202,10 +202,12 @@ static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
 	}
 	con->conid = ret;
 	s->idr_in_use++;
-	spin_unlock_bh(&s->idr_lock);
 
 	set_bit(CF_CONNECTED, &con->flags);
 	con->server = s;
+	con->sock = sock;
+	conn_get(con);
+	spin_unlock_bh(&s->idr_lock);
 
 	return con;
 }
@@ -467,7 +469,7 @@ static void tipc_topsrv_accept(struct work_struct *work)
 		ret = kernel_accept(lsock, &newsock, O_NONBLOCK);
 		if (ret < 0)
 			return;
-		con = tipc_conn_alloc(srv);
+		con = tipc_conn_alloc(srv, newsock);
 		if (IS_ERR(con)) {
 			ret = PTR_ERR(con);
 			sock_release(newsock);
@@ -479,11 +481,11 @@ static void tipc_topsrv_accept(struct work_struct *work)
 		newsk->sk_data_ready = tipc_conn_data_ready;
 		newsk->sk_write_space = tipc_conn_write_space;
 		newsk->sk_user_data = con;
-		con->sock = newsock;
 		write_unlock_bh(&newsk->sk_callback_lock);
 
 		/* Wake up receive process in case of 'SYN+' message */
 		newsk->sk_data_ready(newsk);
+		conn_put(con);
 	}
 }
 
@@ -577,17 +579,17 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 	sub.filter = filter;
 	*(u64 *)&sub.usr_handle = (u64)port;
 
-	con = tipc_conn_alloc(tipc_topsrv(net));
+	con = tipc_conn_alloc(tipc_topsrv(net), NULL);
 	if (IS_ERR(con))
 		return false;
 
 	*conid = con->conid;
-	con->sock = NULL;
 	rc = tipc_conn_rcv_sub(tipc_topsrv(net), con, &sub);
-	if (rc >= 0)
-		return true;
+	if (rc)
+		conn_put(con);
+
 	conn_put(con);
-	return false;
+	return !rc;
 }
 
 void tipc_topsrv_kern_unsubscr(struct net *net, int conid)
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index c255aac6b816..8b8e957a69c3 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -97,6 +97,18 @@ static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 	}
 }
 
+static inline bool xmit_xfrm_check_overflow(struct sk_buff *skb)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	__u32 seq = xo->seq.low;
+
+	seq += skb_shinfo(skb)->gso_segs;
+	if (unlikely(seq < xo->seq.low))
+		return true;
+
+	return false;
+}
+
 struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again)
 {
 	int err;
@@ -134,7 +146,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
-	if (skb_is_gso(skb) && unlikely(x->xso.dev != dev)) {
+	if (skb_is_gso(skb) && (unlikely(x->xso.dev != dev) ||
+				unlikely(xmit_xfrm_check_overflow(skb)))) {
 		struct sk_buff *segs;
 
 		/* Packet got rerouted, fixup features and segment it. */
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 9277d81b344c..49dd788859d8 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -714,7 +714,7 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 			oseq += skb_shinfo(skb)->gso_segs;
 		}
 
-		if (unlikely(oseq < replay_esn->oseq)) {
+		if (unlikely(xo->seq.low < replay_esn->oseq)) {
 			XFRM_SKB_CB(skb)->seq.output.hi = ++oseq_hi;
 			xo->seq.hi = oseq_hi;
 			replay_esn->oseq_hi = oseq_hi;
diff --git a/sound/soc/codecs/hdac_hda.h b/sound/soc/codecs/hdac_hda.h
index d0efc5e254ae..da0ed74758b0 100644
--- a/sound/soc/codecs/hdac_hda.h
+++ b/sound/soc/codecs/hdac_hda.h
@@ -14,7 +14,7 @@ enum {
 	HDAC_HDMI_1_DAI_ID,
 	HDAC_HDMI_2_DAI_ID,
 	HDAC_HDMI_3_DAI_ID,
-	HDAC_LAST_DAI_ID = HDAC_HDMI_3_DAI_ID,
+	HDAC_DAI_ID_NUM
 };
 
 struct hdac_hda_pcm {
@@ -24,7 +24,7 @@ struct hdac_hda_pcm {
 
 struct hdac_hda_priv {
 	struct hda_codec codec;
-	struct hdac_hda_pcm pcm[HDAC_LAST_DAI_ID];
+	struct hdac_hda_pcm pcm[HDAC_DAI_ID_NUM];
 	bool need_display_power;
 };
 
diff --git a/sound/soc/codecs/max98373-i2c.c b/sound/soc/codecs/max98373-i2c.c
index ddb6436835d7..68497a4521dd 100644
--- a/sound/soc/codecs/max98373-i2c.c
+++ b/sound/soc/codecs/max98373-i2c.c
@@ -551,6 +551,10 @@ static int max98373_i2c_probe(struct i2c_client *i2c,
 	max98373->cache = devm_kcalloc(&i2c->dev, max98373->cache_num,
 				       sizeof(*max98373->cache),
 				       GFP_KERNEL);
+	if (!max98373->cache) {
+		ret = -ENOMEM;
+		return ret;
+	}
 
 	for (i = 0; i < max98373->cache_num; i++)
 		max98373->cache[i].reg = max98373_i2c_cache_reg[i];
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index dc56e6c6b668..3c5a4fe2fad6 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1797,6 +1797,7 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 {
 	struct sgtl5000_priv *sgtl5000 = i2c_get_clientdata(client);
 
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_CLK_CTRL, SGTL5000_CHIP_CLK_CTRL_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_DIG_POWER, SGTL5000_DIG_POWER_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_ANA_POWER, SGTL5000_ANA_POWER_DEFAULT);
 
diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 44dcbf49456c..08ca410ef551 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -1226,7 +1226,7 @@ static int fsl_asrc_probe(struct platform_device *pdev)
 	}
 
 	ret = pm_runtime_put_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_asrc_component,
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index bda66b30e063..763f5f0592af 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -1070,7 +1070,7 @@ static int fsl_esai_probe(struct platform_device *pdev)
 	regmap_write(esai_priv->regmap, REG_ESAI_RSMB, 0);
 
 	ret = pm_runtime_put_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	/*
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 38f6362099d5..5ba06df2ace5 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1000,6 +1000,7 @@ static int fsl_sai_runtime_resume(struct device *dev);
 static int fsl_sai_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
 	struct fsl_sai *sai;
 	struct regmap *gpr;
 	struct resource *res;
@@ -1008,12 +1009,12 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	int irq, ret, i;
 	int index;
 
-	sai = devm_kzalloc(&pdev->dev, sizeof(*sai), GFP_KERNEL);
+	sai = devm_kzalloc(dev, sizeof(*sai), GFP_KERNEL);
 	if (!sai)
 		return -ENOMEM;
 
 	sai->pdev = pdev;
-	sai->soc_data = of_device_get_match_data(&pdev->dev);
+	sai->soc_data = of_device_get_match_data(dev);
 
 	sai->is_lsb_first = of_property_read_bool(np, "lsb-first");
 
@@ -1028,18 +1029,18 @@ static int fsl_sai_probe(struct platform_device *pdev)
 			ARRAY_SIZE(fsl_sai_reg_defaults_ofs8);
 	}
 
-	sai->regmap = devm_regmap_init_mmio(&pdev->dev, base, &fsl_sai_regmap_config);
+	sai->regmap = devm_regmap_init_mmio(dev, base, &fsl_sai_regmap_config);
 	if (IS_ERR(sai->regmap)) {
-		dev_err(&pdev->dev, "regmap init failed\n");
+		dev_err(dev, "regmap init failed\n");
 		return PTR_ERR(sai->regmap);
 	}
 
-	sai->bus_clk = devm_clk_get(&pdev->dev, "bus");
+	sai->bus_clk = devm_clk_get(dev, "bus");
 	/* Compatible with old DTB cases */
 	if (IS_ERR(sai->bus_clk) && PTR_ERR(sai->bus_clk) != -EPROBE_DEFER)
-		sai->bus_clk = devm_clk_get(&pdev->dev, "sai");
+		sai->bus_clk = devm_clk_get(dev, "sai");
 	if (IS_ERR(sai->bus_clk)) {
-		dev_err(&pdev->dev, "failed to get bus clock: %ld\n",
+		dev_err(dev, "failed to get bus clock: %ld\n",
 				PTR_ERR(sai->bus_clk));
 		/* -EPROBE_DEFER */
 		return PTR_ERR(sai->bus_clk);
@@ -1047,9 +1048,9 @@ static int fsl_sai_probe(struct platform_device *pdev)
 
 	for (i = 1; i < FSL_SAI_MCLK_MAX; i++) {
 		sprintf(tmp, "mclk%d", i);
-		sai->mclk_clk[i] = devm_clk_get(&pdev->dev, tmp);
+		sai->mclk_clk[i] = devm_clk_get(dev, tmp);
 		if (IS_ERR(sai->mclk_clk[i])) {
-			dev_err(&pdev->dev, "failed to get mclk%d clock: %ld\n",
+			dev_err(dev, "failed to get mclk%d clock: %ld\n",
 					i + 1, PTR_ERR(sai->mclk_clk[i]));
 			sai->mclk_clk[i] = NULL;
 		}
@@ -1064,10 +1065,10 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_irq(&pdev->dev, irq, fsl_sai_isr, IRQF_SHARED,
+	ret = devm_request_irq(dev, irq, fsl_sai_isr, IRQF_SHARED,
 			       np->name, sai);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to claim irq %u\n", irq);
+		dev_err(dev, "failed to claim irq %u\n", irq);
 		return ret;
 	}
 
@@ -1084,7 +1085,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (of_find_property(np, "fsl,sai-synchronous-rx", NULL) &&
 	    of_find_property(np, "fsl,sai-asynchronous", NULL)) {
 		/* error out if both synchronous and asynchronous are present */
-		dev_err(&pdev->dev, "invalid binding for synchronous mode\n");
+		dev_err(dev, "invalid binding for synchronous mode\n");
 		return -EINVAL;
 	}
 
@@ -1105,7 +1106,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	    of_device_is_compatible(np, "fsl,imx6ul-sai")) {
 		gpr = syscon_regmap_lookup_by_compatible("fsl,imx6ul-iomuxc-gpr");
 		if (IS_ERR(gpr)) {
-			dev_err(&pdev->dev, "cannot find iomuxc registers\n");
+			dev_err(dev, "cannot find iomuxc registers\n");
 			return PTR_ERR(gpr);
 		}
 
@@ -1123,23 +1124,23 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	sai->dma_params_tx.maxburst = FSL_SAI_MAXBURST_TX;
 
 	platform_set_drvdata(pdev, sai);
-	pm_runtime_enable(&pdev->dev);
-	if (!pm_runtime_enabled(&pdev->dev)) {
-		ret = fsl_sai_runtime_resume(&pdev->dev);
+	pm_runtime_enable(dev);
+	if (!pm_runtime_enabled(dev)) {
+		ret = fsl_sai_runtime_resume(dev);
 		if (ret)
 			goto err_pm_disable;
 	}
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(&pdev->dev);
+		pm_runtime_put_noidle(dev);
 		goto err_pm_get_sync;
 	}
 
 	/* Get sai version */
-	ret = fsl_sai_check_version(&pdev->dev);
+	ret = fsl_sai_check_version(dev);
 	if (ret < 0)
-		dev_warn(&pdev->dev, "Error reading SAI version: %d\n", ret);
+		dev_warn(dev, "Error reading SAI version: %d\n", ret);
 
 	/* Select MCLK direction */
 	if (of_find_property(np, "fsl,sai-mclk-direction-output", NULL) &&
@@ -1148,8 +1149,8 @@ static int fsl_sai_probe(struct platform_device *pdev)
 				   FSL_SAI_MCTL_MCLK_EN, FSL_SAI_MCTL_MCLK_EN);
 	}
 
-	ret = pm_runtime_put_sync(&pdev->dev);
-	if (ret < 0)
+	ret = pm_runtime_put_sync(dev);
+	if (ret < 0 && ret != -ENOSYS)
 		goto err_pm_get_sync;
 
 	/*
@@ -1161,12 +1162,12 @@ static int fsl_sai_probe(struct platform_device *pdev)
 		if (ret)
 			goto err_pm_get_sync;
 	} else {
-		ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+		ret = devm_snd_dmaengine_pcm_register(dev, NULL, 0);
 		if (ret)
 			goto err_pm_get_sync;
 	}
 
-	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
+	ret = devm_snd_soc_register_component(dev, &fsl_component,
 					      &sai->cpu_dai_drv, 1);
 	if (ret)
 		goto err_pm_get_sync;
@@ -1174,10 +1175,10 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	return ret;
 
 err_pm_get_sync:
-	if (!pm_runtime_status_suspended(&pdev->dev))
-		fsl_sai_runtime_suspend(&pdev->dev);
+	if (!pm_runtime_status_suspended(dev))
+		fsl_sai_runtime_suspend(dev);
 err_pm_disable:
-	pm_runtime_disable(&pdev->dev);
+	pm_runtime_disable(dev);
 
 	return ret;
 }
diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 4d313d0d0f23..950457bcc28f 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -443,6 +443,13 @@ static const struct dmi_system_id byt_cht_es8316_quirk_table[] = {
 					| BYT_CHT_ES8316_INTMIC_IN2_MAP
 					| BYT_CHT_ES8316_JD_INVERTED),
 	},
+	{	/* Nanote UMPC-01 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "RWC CO.,LTD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UMPC-01"),
+		},
+		.driver_data = (void *)BYT_CHT_ES8316_INTMIC_IN1_MAP,
+	},
 	{	/* Teclast X98 Plus II */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "TECLAST"),
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 48f71bb81a2f..f6dc71e8ea87 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -759,11 +759,6 @@ static int soc_pcm_open(struct snd_pcm_substream *substream)
 		ret = snd_soc_dai_startup(dai, substream);
 		if (ret < 0)
 			goto err;
-
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-			dai->tx_mask = 0;
-		else
-			dai->rx_mask = 0;
 	}
 
 	/* Dynamic PCM DAI links compat checks use dynamic capabilities */
diff --git a/sound/soc/stm/stm32_adfsdm.c b/sound/soc/stm/stm32_adfsdm.c
index e6078f50e508..1e9b4b1df69e 100644
--- a/sound/soc/stm/stm32_adfsdm.c
+++ b/sound/soc/stm/stm32_adfsdm.c
@@ -303,6 +303,11 @@ static int stm32_adfsdm_dummy_cb(const void *data, void *private)
 	return 0;
 }
 
+static void stm32_adfsdm_cleanup(void *data)
+{
+	iio_channel_release_all_cb(data);
+}
+
 static struct snd_soc_component_driver stm32_adfsdm_soc_platform = {
 	.open		= stm32_adfsdm_pcm_open,
 	.close		= stm32_adfsdm_pcm_close,
@@ -349,6 +354,12 @@ static int stm32_adfsdm_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->iio_cb))
 		return PTR_ERR(priv->iio_cb);
 
+	ret = devm_add_action_or_reset(&pdev->dev, stm32_adfsdm_cleanup, priv->iio_cb);
+	if (ret < 0)  {
+		dev_err(&pdev->dev, "Unable to add action\n");
+		return ret;
+	}
+
 	component = devm_kzalloc(&pdev->dev, sizeof(*component), GFP_KERNEL);
 	if (!component)
 		return -ENOMEM;
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 3bbc227769d0..092350eb5f4e 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -887,7 +887,8 @@ void snd_usb_endpoint_close(struct snd_usb_audio *chip,
 	usb_audio_dbg(chip, "Closing EP 0x%x (count %d)\n",
 		      ep->ep_num, ep->opened);
 
-	if (!--ep->iface_ref->opened)
+	if (!--ep->iface_ref->opened &&
+		!(chip->quirk_flags & QUIRK_FLAG_IFACE_SKIP_CLOSE))
 		endpoint_set_interface(chip, ep, false);
 
 	if (!--ep->opened) {
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 879d8b1f301c..2ae9ad993ff4 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1884,6 +1884,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x0525, 0xa4ad, /* Hamedal C20 usb camero */
+		   QUIRK_FLAG_IFACE_SKIP_CLOSE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 39c3c61a7e49..ec06f441e890 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -169,6 +169,8 @@ extern bool snd_usb_skip_validation;
  *  Apply the generic implicit feedback sync mode (same as implicit_fb=1 option)
  * QUIRK_FLAG_SKIP_IMPLICIT_FB
  *  Don't apply implicit feedback sync mode
+ * QUIRK_FLAG_IFACE_SKIP_CLOSE
+ *  Don't closed interface during setting sample rate
  */
 
 #define QUIRK_FLAG_GET_SAMPLE_RATE	(1U << 0)
@@ -190,5 +192,6 @@ extern bool snd_usb_skip_validation;
 #define QUIRK_FLAG_SET_IFACE_FIRST	(1U << 16)
 #define QUIRK_FLAG_GENERIC_IMPLICIT_FB	(1U << 17)
 #define QUIRK_FLAG_SKIP_IMPLICIT_FB	(1U << 18)
+#define QUIRK_FLAG_IFACE_SKIP_CLOSE	(1U << 19)
 
 #endif /* __USBAUDIO_H */
diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index 2491c54a5e4f..f8deae4e26a1 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -715,12 +715,12 @@ int main(int argc, char **argv)
 				continue;
 			}
 
-			toread = buf_len;
 		} else {
 			usleep(timedelay);
-			toread = 64;
 		}
 
+		toread = buf_len;
+
 		read_size = read(buf_fd, data, toread * scan_size);
 		if (read_size < 0) {
 			if (errno == EAGAIN) {
diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index 3b6ee009c00b..4a768b130d61 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -905,3 +905,39 @@
 	.result_unpriv = REJECT,
 	.errstr_unpriv = "unknown func",
 },
+{
+	"reference tracking: try to leak released ptr reg",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_0, -4),
+		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+		BPF_EXIT_INSN(),
+		BPF_MOV64_REG(BPF_REG_9, BPF_REG_0),
+
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_MOV64_IMM(BPF_REG_2, 8),
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_ringbuf_reserve),
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+		BPF_EXIT_INSN(),
+		BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
+
+		BPF_MOV64_REG(BPF_REG_1, BPF_REG_8),
+		BPF_MOV64_IMM(BPF_REG_2, 0),
+		BPF_EMIT_CALL(BPF_FUNC_ringbuf_discard),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+
+		BPF_STX_MEM(BPF_DW, BPF_REG_9, BPF_REG_8, 0),
+		BPF_EXIT_INSN()
+	},
+	.fixup_map_array_48b = { 4 },
+	.fixup_map_ringbuf = { 11 },
+	.result = ACCEPT,
+	.result_unpriv = REJECT,
+	.errstr_unpriv = "R8 !read_ok"
+},
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 89c4753c2760..95e81d557b08 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -14,6 +14,7 @@
 #include <strings.h>
 #include <signal.h>
 #include <unistd.h>
+#include <time.h>
 
 #include <sys/poll.h>
 #include <sys/sendfile.h>
@@ -64,6 +65,7 @@ static int cfg_sndbuf;
 static int cfg_rcvbuf;
 static bool cfg_join;
 static bool cfg_remove;
+static unsigned int cfg_time;
 static unsigned int cfg_do_w;
 static int cfg_wait;
 static uint32_t cfg_mark;
@@ -78,9 +80,10 @@ static struct cfg_cmsg_types cfg_cmsg_types;
 static void die_usage(void)
 {
 	fprintf(stderr, "Usage: mptcp_connect [-6] [-u] [-s MPTCP|TCP] [-p port] [-m mode]"
-		"[-l] [-w sec] connect_address\n");
+		"[-l] [-w sec] [-t num] [-T num] connect_address\n");
 	fprintf(stderr, "\t-6 use ipv6\n");
 	fprintf(stderr, "\t-t num -- set poll timeout to num\n");
+	fprintf(stderr, "\t-T num -- set expected runtime to num ms\n");
 	fprintf(stderr, "\t-S num -- set SO_SNDBUF to num\n");
 	fprintf(stderr, "\t-R num -- set SO_RCVBUF to num\n");
 	fprintf(stderr, "\t-p num -- use port num\n");
@@ -448,7 +451,7 @@ static void set_nonblock(int fd)
 	fcntl(fd, F_SETFL, flags | O_NONBLOCK);
 }
 
-static int copyfd_io_poll(int infd, int peerfd, int outfd)
+static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after_out)
 {
 	struct pollfd fds = {
 		.fd = peerfd,
@@ -487,9 +490,11 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 				 */
 				fds.events &= ~POLLIN;
 
-				if ((fds.events & POLLOUT) == 0)
+				if ((fds.events & POLLOUT) == 0) {
+					*in_closed_after_out = true;
 					/* and nothing more to send */
 					break;
+				}
 
 			/* Else, still have data to transmit */
 			} else if (len < 0) {
@@ -547,7 +552,7 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 	}
 
 	/* leave some time for late join/announce */
-	if (cfg_join || cfg_remove)
+	if (cfg_remove)
 		usleep(cfg_wait);
 
 	close(peerfd);
@@ -646,7 +651,7 @@ static int do_sendfile(int infd, int outfd, unsigned int count)
 }
 
 static int copyfd_io_mmap(int infd, int peerfd, int outfd,
-			  unsigned int size)
+			  unsigned int size, bool *in_closed_after_out)
 {
 	int err;
 
@@ -664,13 +669,14 @@ static int copyfd_io_mmap(int infd, int peerfd, int outfd,
 		shutdown(peerfd, SHUT_WR);
 
 		err = do_recvfile(peerfd, outfd);
+		*in_closed_after_out = true;
 	}
 
 	return err;
 }
 
 static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
-			      unsigned int size)
+			      unsigned int size, bool *in_closed_after_out)
 {
 	int err;
 
@@ -685,6 +691,7 @@ static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
 		if (err)
 			return err;
 		err = do_recvfile(peerfd, outfd);
+		*in_closed_after_out = true;
 	}
 
 	return err;
@@ -692,27 +699,62 @@ static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
 
 static int copyfd_io(int infd, int peerfd, int outfd)
 {
+	bool in_closed_after_out = false;
+	struct timespec start, end;
 	int file_size;
+	int ret;
+
+	if (cfg_time && (clock_gettime(CLOCK_MONOTONIC, &start) < 0))
+		xerror("can not fetch start time %d", errno);
 
 	switch (cfg_mode) {
 	case CFG_MODE_POLL:
-		return copyfd_io_poll(infd, peerfd, outfd);
+		ret = copyfd_io_poll(infd, peerfd, outfd, &in_closed_after_out);
+		break;
+
 	case CFG_MODE_MMAP:
 		file_size = get_infd_size(infd);
 		if (file_size < 0)
 			return file_size;
-		return copyfd_io_mmap(infd, peerfd, outfd, file_size);
+		ret = copyfd_io_mmap(infd, peerfd, outfd, file_size, &in_closed_after_out);
+		break;
+
 	case CFG_MODE_SENDFILE:
 		file_size = get_infd_size(infd);
 		if (file_size < 0)
 			return file_size;
-		return copyfd_io_sendfile(infd, peerfd, outfd, file_size);
+		ret = copyfd_io_sendfile(infd, peerfd, outfd, file_size, &in_closed_after_out);
+		break;
+
+	default:
+		fprintf(stderr, "Invalid mode %d\n", cfg_mode);
+
+		die_usage();
+		return 1;
 	}
 
-	fprintf(stderr, "Invalid mode %d\n", cfg_mode);
+	if (ret)
+		return ret;
 
-	die_usage();
-	return 1;
+	if (cfg_time) {
+		unsigned int delta_ms;
+
+		if (clock_gettime(CLOCK_MONOTONIC, &end) < 0)
+			xerror("can not fetch end time %d", errno);
+		delta_ms = (end.tv_sec - start.tv_sec) * 1000 + (end.tv_nsec - start.tv_nsec) / 1000000;
+		if (delta_ms > cfg_time) {
+			xerror("transfer slower than expected! runtime %d ms, expected %d ms",
+			       delta_ms, cfg_time);
+		}
+
+		/* show the runtime only if this end shutdown(wr) before receiving the EOF,
+		 * (that is, if this end got the longer runtime)
+		 */
+		if (in_closed_after_out)
+			fprintf(stderr, "%d", delta_ms);
+	}
+
+	return 0;
 }
 
 static void check_sockaddr(int pf, struct sockaddr_storage *ss,
@@ -1005,12 +1047,11 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6jr:lp:s:hut:m:S:R:w:M:P:c:")) != -1) {
+	while ((c = getopt(argc, argv, "6jr:lp:s:hut:T:m:S:R:w:M:P:c:")) != -1) {
 		switch (c) {
 		case 'j':
 			cfg_join = true;
 			cfg_mode = CFG_MODE_POLL;
-			cfg_wait = 400000;
 			break;
 		case 'r':
 			cfg_remove = true;
@@ -1043,6 +1084,9 @@ static void parse_opts(int argc, char **argv)
 			if (poll_timeout <= 0)
 				poll_timeout = -1;
 			break;
+		case 'T':
+			cfg_time = atoi(optarg);
+			break;
 		case 'm':
 			cfg_mode = parse_mode(optarg);
 			break;
diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 910d8126af8f..7df4900dfaf7 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -51,7 +51,7 @@ setup()
 	sout=$(mktemp)
 	cout=$(mktemp)
 	capout=$(mktemp)
-	size=$((2048 * 4096))
+	size=$((2 * 2048 * 4096))
 	dd if=/dev/zero of=$small bs=4096 count=20 >/dev/null 2>&1
 	dd if=/dev/zero of=$large bs=4096 count=$((size / 4096)) >/dev/null 2>&1
 
@@ -161,17 +161,15 @@ do_transfer()
 
 	timeout ${timeout_test} \
 		ip netns exec ${ns3} \
-			./mptcp_connect -jt ${timeout_poll} -l -p $port \
+			./mptcp_connect -jt ${timeout_poll} -l -p $port -T $time \
 				0.0.0.0 < "$sin" > "$sout" &
 	local spid=$!
 
 	wait_local_port_listen "${ns3}" "${port}"
 
-	local start
-	start=$(date +%s%3N)
 	timeout ${timeout_test} \
 		ip netns exec ${ns1} \
-			./mptcp_connect -jt ${timeout_poll} -p $port \
+			./mptcp_connect -jt ${timeout_poll} -p $port -T $time \
 				10.0.3.3 < "$cin" > "$cout" &
 	local cpid=$!
 
@@ -180,27 +178,20 @@ do_transfer()
 	wait $spid
 	local rets=$?
 
-	local stop
-	stop=$(date +%s%3N)
-
 	if $capture; then
 		sleep 1
 		kill ${cappid_listener}
 		kill ${cappid_connector}
 	fi
 
-	local duration
-	duration=$((stop-start))
-
 	cmp $sin $cout > /dev/null 2>&1
 	local cmps=$?
 	cmp $cin $sout > /dev/null 2>&1
 	local cmpc=$?
 
-	printf "%16s" "$duration max $max_time "
+	printf "%-16s" " max $max_time "
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ] && \
-	   [ $cmpc -eq 0 ] && [ $cmps -eq 0 ] && \
-	   [ $duration -lt $max_time ]; then
+	   [ $cmpc -eq 0 ] && [ $cmps -eq 0 ]; then
 		echo "[ OK ]"
 		cat "$capout"
 		return 0
@@ -244,23 +235,25 @@ run_test()
 	tc -n $ns2 qdisc add dev ns2eth1 root netem rate ${rate1}mbit $delay1
 	tc -n $ns2 qdisc add dev ns2eth2 root netem rate ${rate2}mbit $delay2
 
-	# time is measure in ms
-	local time=$((size * 8 * 1000 / (( $rate1 + $rate2) * 1024 *1024) ))
+	# time is measured in ms, account for transfer size, aggregated link speed
+	# and header overhead (10%)
+	#              ms    byte -> bit   10%        mbit      -> kbit -> bit  10%
+	local time=$((1000 * size  *  8  * 10 / ((rate1 + rate2) * 1000 * 1000 * 9) ))
 
 	# mptcp_connect will do some sleeps to allow the mp_join handshake
-	# completion
-	time=$((time + 1350))
+	# completion (see mptcp_connect): 200ms on each side, add some slack
+	time=$((time + 450))
 
-	printf "%-50s" "$msg"
-	do_transfer $small $large $((time * 11 / 10))
+	printf "%-60s" "$msg"
+	do_transfer $small $large $time
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
 		[ $bail -eq 0 ] || exit $ret
 	fi
 
-	printf "%-50s" "$msg - reverse direction"
-	do_transfer $large $small $((time * 11 / 10))
+	printf "%-60s" "$msg - reverse direction"
+	do_transfer $large $small $time
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
