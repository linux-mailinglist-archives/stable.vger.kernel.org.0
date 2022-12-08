Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA5E646CD7
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 11:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiLHKcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 05:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiLHKbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 05:31:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC287DA71;
        Thu,  8 Dec 2022 02:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 211B6B82374;
        Thu,  8 Dec 2022 10:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5950C433B5;
        Thu,  8 Dec 2022 10:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670495477;
        bh=LgFMPRDQQYsMJ706mUaCR9FLnVXe4L3Juwl/4KSO1g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFZrw/9p6vgtgM8LzwhG53DDYMNKwyJCnVEkNQqRPVpCC7XFzEU/DvYDoXtWMUHq2
         CmfAakh9TUARu7GjP0Ofd7z3p0rdv5Lycy/q03OCPr22J/SxhxXqeW8Gd/ISxzbcIp
         2DQ4r15AChUjAKFsKd+1TprpugVOpNV9L2qx3dCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.226
Date:   Thu,  8 Dec 2022 11:31:08 +0100
Message-Id: <167049546857149@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <167049546812338@kroah.com>
References: <167049546812338@kroah.com>
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
index bf33b3febbbc..78a64488b28c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 225
+SUBLEVEL = 226
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/arch/arm/boot/dts/am335x-pcm-953.dtsi b/arch/arm/boot/dts/am335x-pcm-953.dtsi
index 9bfa032bcada..f2d9145b3c6a 100644
--- a/arch/arm/boot/dts/am335x-pcm-953.dtsi
+++ b/arch/arm/boot/dts/am335x-pcm-953.dtsi
@@ -12,22 +12,20 @@
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
index 287566e09a67..3d694b60d452 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -38,6 +38,13 @@
 
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
@@ -83,6 +90,8 @@
 			};
 
 			usb1: gadget@fffa4000 {
+				pinctrl-0 = <&pinctrl_usb1_vbus_gpio>;
+				pinctrl-names = "default";
 				atmel,vbus-gpio = <&pioC 5 GPIO_ACTIVE_HIGH>;
 				status = "okay";
 			};
diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index c109f47e9cbc..a687e83ad604 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -387,8 +387,10 @@ static void __init mxs_machine_init(void)
 
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
index d80d6b726820..d29937e4a606 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -203,7 +203,7 @@
 	cap-sd-highspeed;
 	cd-gpios = <&gpio0 RK_PA7 GPIO_ACTIVE_LOW>;
 	disable-wp;
-	max-frequency = <150000000>;
+	max-frequency = <40000000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc_clk &sdmmc_cmd &sdmmc_cd &sdmmc_bus4>;
 	vmmc-supply = <&vcc3v3_baseboard>;
diff --git a/arch/arm64/include/asm/syscall_wrapper.h b/arch/arm64/include/asm/syscall_wrapper.h
index 06d880b3526c..43a20888bf19 100644
--- a/arch/arm64/include/asm/syscall_wrapper.h
+++ b/arch/arm64/include/asm/syscall_wrapper.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_SYSCALL_WRAPPER_H
 #define __ASM_SYSCALL_WRAPPER_H
 
-struct pt_regs;
+#include <asm/ptrace.h>
 
 #define SC_ARM64_REGS_TO_ARGS(x, ...)				\
 	__MAP(x,__SC_ARGS					\
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 4c7545cf5a02..b18f307a3c59 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -170,9 +170,12 @@ static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
 	}
 
-	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
-	__this_cpu_write(bp_hardening_data.fn, fn);
-	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
+	if (fn != __this_cpu_read(bp_hardening_data.fn)) {
+		__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
+		__this_cpu_write(bp_hardening_data.fn, fn);
+		__this_cpu_write(bp_hardening_data.template_start,
+				 hyp_vecs_start);
+	}
 	raw_spin_unlock(&bp_lock);
 }
 #else
@@ -1320,8 +1323,11 @@ static void kvm_setup_bhb_slot(const char *hyp_vecs_start)
 		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
 	}
 
-	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
-	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
+	if (hyp_vecs_start != __this_cpu_read(bp_hardening_data.template_start)) {
+		__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
+		__this_cpu_write(bp_hardening_data.template_start,
+				 hyp_vecs_start);
+	}
 	raw_spin_unlock(&bp_lock);
 }
 #else
@@ -1357,7 +1363,13 @@ void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
 	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
 		switch (spectre_bhb_loop_affected(SCOPE_SYSTEM)) {
 		case 8:
-			kvm_setup_bhb_slot(__spectre_bhb_loop_k8_start);
+			/*
+			 * A57/A72-r0 will already have selected the
+			 * spectre-indirect vector, which is sufficient
+			 * for BHB too.
+			 */
+			if (!__this_cpu_read(bp_hardening_data.fn))
+				kvm_setup_bhb_slot(__spectre_bhb_loop_k8_start);
 			break;
 		case 24:
 			kvm_setup_bhb_slot(__spectre_bhb_loop_k24_start);
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
index 8c236738b5ee..5d48408f84b1 100644
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
 
 	uart_base = ioremap_nocache(PIC32_BASE_UART, 0xc00);
 
 	baud = get_baud_from_cmdline(arch_cmdline);
-	if (port == -1)
-		port = get_port_from_cmdline(arch_cmdline);
+	port = get_port_from_cmdline(arch_cmdline);
 
 	if (port == -1)
 		port = EARLY_CONSOLE_PORT;
diff --git a/arch/mips/pic32/pic32mzda/init.c b/arch/mips/pic32/pic32mzda/init.c
index f232c77ff526..488c0bee7ebf 100644
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -60,7 +60,7 @@ void __init plat_mem_setup(void)
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
 
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index a4ee3a0e7d20..c533ac869aa2 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -20,6 +20,9 @@ obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 
 obj-y += vdso.o vdso-syms.o
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+ifneq ($(filter vgettimeofday, $(vdso-syms)),)
+CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
+endif
 
 # Disable gcov profiling for VDSO code
 GCOV_PROFILE := n
diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index f66a091cb890..4c45adf23259 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -62,9 +62,11 @@ VERSION
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
index f96a5857bbfd..01d7c281087f 100644
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
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2ec85d7bfdff..3e360dc07bae 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -290,6 +290,7 @@
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
+#define X86_FEATURE_MSR_TSX_CTRL	(11*32+18) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 8c898eed2894..c8819358a332 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -312,7 +312,7 @@ static inline void indirect_branch_prediction_barrier(void)
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
 DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
-extern void write_spec_ctrl_current(u64 val, bool force);
+extern void update_spec_ctrl_cond(u64 val);
 extern u64 spec_ctrl_current(void);
 
 /*
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index cf5a18e261e3..69d92ed52e4c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -58,11 +58,18 @@ EXPORT_SYMBOL_GPL(x86_spec_ctrl_current);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
+/* Update SPEC_CTRL MSR and its cached copy unconditionally */
+static void update_spec_ctrl(u64 val)
+{
+	this_cpu_write(x86_spec_ctrl_current, val);
+	wrmsrl(MSR_IA32_SPEC_CTRL, val);
+}
+
 /*
  * Keep track of the SPEC_CTRL MSR value for the current task, which may differ
  * from x86_spec_ctrl_base due to STIBP/SSB in __speculation_ctrl_update().
  */
-void write_spec_ctrl_current(u64 val, bool force)
+void update_spec_ctrl_cond(u64 val)
 {
 	if (this_cpu_read(x86_spec_ctrl_current) == val)
 		return;
@@ -73,7 +80,7 @@ void write_spec_ctrl_current(u64 val, bool force)
 	 * When KERNEL_IBRS this MSR is written on return-to-user, unless
 	 * forced the update can be delayed until that time.
 	 */
-	if (force || !cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
+	if (!cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
 		wrmsrl(MSR_IA32_SPEC_CTRL, val);
 }
 
@@ -1194,7 +1201,7 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 
 	if (ia32_cap & ARCH_CAP_RRSBA) {
 		x86_spec_ctrl_base |= SPEC_CTRL_RRSBA_DIS_S;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 	}
 }
 
@@ -1315,7 +1322,7 @@ static void __init spectre_v2_select_mitigation(void)
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 	}
 
 	switch (mode) {
@@ -1419,7 +1426,7 @@ static void __init spectre_v2_select_mitigation(void)
 static void update_stibp_msr(void * __unused)
 {
 	u64 val = spec_ctrl_current() | (x86_spec_ctrl_base & SPEC_CTRL_STIBP);
-	write_spec_ctrl_current(val, true);
+	update_spec_ctrl(val);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1652,7 +1659,7 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			write_spec_ctrl_current(x86_spec_ctrl_base, true);
+			update_spec_ctrl(x86_spec_ctrl_base);
 		}
 	}
 
@@ -1869,7 +1876,7 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 032509adf9de..88a553ee7704 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -55,24 +55,6 @@ void tsx_enable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-static bool __init tsx_ctrl_is_supported(void)
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
@@ -86,9 +68,22 @@ void __init tsx_init(void)
 	char arg[5] = {};
 	int ret;
 
-	if (!tsx_ctrl_is_supported())
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
+	if (!(x86_read_arch_cap_msr() & ARCH_CAP_TSX_CTRL_MSR))
 		return;
 
+	setup_force_cpu_cap(X86_FEATURE_MSR_TSX_CTRL);
+
 	ret = cmdline_find_option(boot_command_line, "tsx", arg, sizeof(arg));
 	if (ret >= 0) {
 		if (!strcmp(arg, "on")) {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 87cfd2ee9ca0..b8de27bb6e09 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -449,7 +449,7 @@ static __always_inline void __speculation_ctrl_update(unsigned long tifp,
 	}
 
 	if (updmsr)
-		write_spec_ctrl_current(msr, false);
+		update_spec_ctrl_cond(msr);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index a353f88d299d..137714df879e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -214,9 +214,15 @@ __ioremap_caller(resource_size_t phys_addr, unsigned long size,
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
 	retval = reserve_memtype(phys_addr, (u64)phys_addr + size,
 						pcm, &new_pcm);
 	if (retval) {
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 313ce4ce7908..44dd7ac084ca 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -522,16 +522,23 @@ static int pm_cpu_check(const struct x86_cpu_id *c)
 
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
index 09d721b1f6ac..59fd1b10b5f3 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -594,6 +594,10 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 	struct bfq_group *bfqg;
 
 	while (blkg) {
+		if (!blkg->online) {
+			blkg = blkg->parent;
+			continue;
+		}
 		bfqg = blkg_to_bfqg(blkg);
 		if (bfqg->online) {
 			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 807ee9725479..4b96742f0fe5 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2013,15 +2013,21 @@ static void binder_cleanup_transaction(struct binder_transaction *t,
 /**
  * binder_get_object() - gets object and checks for valid metadata
  * @proc:	binder_proc owning the buffer
+ * @u:		sender's user pointer to base of buffer
  * @buffer:	binder_buffer that we're parsing.
  * @offset:	offset in the @buffer at which to validate an object.
  * @object:	struct binder_object to read into
  *
- * Return:	If there's a valid metadata object at @offset in @buffer, the
+ * Copy the binder object at the given offset into @object. If @u is
+ * provided then the copy is from the sender's buffer. If not, then
+ * it is copied from the target's @buffer.
+ *
+ * Return:	If there's a valid metadata object at @offset, the
  *		size of that object. Otherwise, it returns zero. The object
  *		is read into the struct binder_object pointed to by @object.
  */
 static size_t binder_get_object(struct binder_proc *proc,
+				const void __user *u,
 				struct binder_buffer *buffer,
 				unsigned long offset,
 				struct binder_object *object)
@@ -2031,10 +2037,16 @@ static size_t binder_get_object(struct binder_proc *proc,
 	size_t object_size = 0;
 
 	read_size = min_t(size_t, sizeof(*object), buffer->data_size - offset);
-	if (offset > buffer->data_size || read_size < sizeof(*hdr) ||
-	    binder_alloc_copy_from_buffer(&proc->alloc, object, buffer,
-					  offset, read_size))
+	if (offset > buffer->data_size || read_size < sizeof(*hdr))
 		return 0;
+	if (u) {
+		if (copy_from_user(object, u + offset, read_size))
+			return 0;
+	} else {
+		if (binder_alloc_copy_from_buffer(&proc->alloc, object, buffer,
+						  offset, read_size))
+			return 0;
+	}
 
 	/* Ok, now see if we read a complete object. */
 	hdr = &object->hdr;
@@ -2107,7 +2119,7 @@ static struct binder_buffer_object *binder_validate_ptr(
 					  b, buffer_offset,
 					  sizeof(object_offset)))
 		return NULL;
-	object_size = binder_get_object(proc, b, object_offset, object);
+	object_size = binder_get_object(proc, NULL, b, object_offset, object);
 	if (!object_size || object->hdr.type != BINDER_TYPE_PTR)
 		return NULL;
 	if (object_offsetp)
@@ -2172,7 +2184,8 @@ static bool binder_validate_fixup(struct binder_proc *proc,
 		unsigned long buffer_offset;
 		struct binder_object last_object;
 		struct binder_buffer_object *last_bbo;
-		size_t object_size = binder_get_object(proc, b, last_obj_offset,
+		size_t object_size = binder_get_object(proc, NULL, b,
+						       last_obj_offset,
 						       &last_object);
 		if (object_size != sizeof(*last_bbo))
 			return false;
@@ -2285,7 +2298,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		if (!binder_alloc_copy_from_buffer(&proc->alloc, &object_offset,
 						   buffer, buffer_offset,
 						   sizeof(object_offset)))
-			object_size = binder_get_object(proc, buffer,
+			object_size = binder_get_object(proc, NULL, buffer,
 							object_offset, &object);
 		if (object_size == 0) {
 			pr_err("transaction release %d bad object at offset %lld, size %zd\n",
@@ -2623,16 +2636,266 @@ static int binder_translate_fd(u32 fd, binder_size_t fd_offset,
 	return ret;
 }
 
-static int binder_translate_fd_array(struct binder_fd_array_object *fda,
+/**
+ * struct binder_ptr_fixup - data to be fixed-up in target buffer
+ * @offset	offset in target buffer to fixup
+ * @skip_size	bytes to skip in copy (fixup will be written later)
+ * @fixup_data	data to write at fixup offset
+ * @node	list node
+ *
+ * This is used for the pointer fixup list (pf) which is created and consumed
+ * during binder_transaction() and is only accessed locally. No
+ * locking is necessary.
+ *
+ * The list is ordered by @offset.
+ */
+struct binder_ptr_fixup {
+	binder_size_t offset;
+	size_t skip_size;
+	binder_uintptr_t fixup_data;
+	struct list_head node;
+};
+
+/**
+ * struct binder_sg_copy - scatter-gather data to be copied
+ * @offset		offset in target buffer
+ * @sender_uaddr	user address in source buffer
+ * @length		bytes to copy
+ * @node		list node
+ *
+ * This is used for the sg copy list (sgc) which is created and consumed
+ * during binder_transaction() and is only accessed locally. No
+ * locking is necessary.
+ *
+ * The list is ordered by @offset.
+ */
+struct binder_sg_copy {
+	binder_size_t offset;
+	const void __user *sender_uaddr;
+	size_t length;
+	struct list_head node;
+};
+
+/**
+ * binder_do_deferred_txn_copies() - copy and fixup scatter-gather data
+ * @alloc:	binder_alloc associated with @buffer
+ * @buffer:	binder buffer in target process
+ * @sgc_head:	list_head of scatter-gather copy list
+ * @pf_head:	list_head of pointer fixup list
+ *
+ * Processes all elements of @sgc_head, applying fixups from @pf_head
+ * and copying the scatter-gather data from the source process' user
+ * buffer to the target's buffer. It is expected that the list creation
+ * and processing all occurs during binder_transaction() so these lists
+ * are only accessed in local context.
+ *
+ * Return: 0=success, else -errno
+ */
+static int binder_do_deferred_txn_copies(struct binder_alloc *alloc,
+					 struct binder_buffer *buffer,
+					 struct list_head *sgc_head,
+					 struct list_head *pf_head)
+{
+	int ret = 0;
+	struct binder_sg_copy *sgc, *tmpsgc;
+	struct binder_ptr_fixup *tmppf;
+	struct binder_ptr_fixup *pf =
+		list_first_entry_or_null(pf_head, struct binder_ptr_fixup,
+					 node);
+
+	list_for_each_entry_safe(sgc, tmpsgc, sgc_head, node) {
+		size_t bytes_copied = 0;
+
+		while (bytes_copied < sgc->length) {
+			size_t copy_size;
+			size_t bytes_left = sgc->length - bytes_copied;
+			size_t offset = sgc->offset + bytes_copied;
+
+			/*
+			 * We copy up to the fixup (pointed to by pf)
+			 */
+			copy_size = pf ? min(bytes_left, (size_t)pf->offset - offset)
+				       : bytes_left;
+			if (!ret && copy_size)
+				ret = binder_alloc_copy_user_to_buffer(
+						alloc, buffer,
+						offset,
+						sgc->sender_uaddr + bytes_copied,
+						copy_size);
+			bytes_copied += copy_size;
+			if (copy_size != bytes_left) {
+				BUG_ON(!pf);
+				/* we stopped at a fixup offset */
+				if (pf->skip_size) {
+					/*
+					 * we are just skipping. This is for
+					 * BINDER_TYPE_FDA where the translated
+					 * fds will be fixed up when we get
+					 * to target context.
+					 */
+					bytes_copied += pf->skip_size;
+				} else {
+					/* apply the fixup indicated by pf */
+					if (!ret)
+						ret = binder_alloc_copy_to_buffer(
+							alloc, buffer,
+							pf->offset,
+							&pf->fixup_data,
+							sizeof(pf->fixup_data));
+					bytes_copied += sizeof(pf->fixup_data);
+				}
+				list_del(&pf->node);
+				kfree(pf);
+				pf = list_first_entry_or_null(pf_head,
+						struct binder_ptr_fixup, node);
+			}
+		}
+		list_del(&sgc->node);
+		kfree(sgc);
+	}
+	list_for_each_entry_safe(pf, tmppf, pf_head, node) {
+		BUG_ON(pf->skip_size == 0);
+		list_del(&pf->node);
+		kfree(pf);
+	}
+	BUG_ON(!list_empty(sgc_head));
+
+	return ret > 0 ? -EINVAL : ret;
+}
+
+/**
+ * binder_cleanup_deferred_txn_lists() - free specified lists
+ * @sgc_head:	list_head of scatter-gather copy list
+ * @pf_head:	list_head of pointer fixup list
+ *
+ * Called to clean up @sgc_head and @pf_head if there is an
+ * error.
+ */
+static void binder_cleanup_deferred_txn_lists(struct list_head *sgc_head,
+					      struct list_head *pf_head)
+{
+	struct binder_sg_copy *sgc, *tmpsgc;
+	struct binder_ptr_fixup *pf, *tmppf;
+
+	list_for_each_entry_safe(sgc, tmpsgc, sgc_head, node) {
+		list_del(&sgc->node);
+		kfree(sgc);
+	}
+	list_for_each_entry_safe(pf, tmppf, pf_head, node) {
+		list_del(&pf->node);
+		kfree(pf);
+	}
+}
+
+/**
+ * binder_defer_copy() - queue a scatter-gather buffer for copy
+ * @sgc_head:		list_head of scatter-gather copy list
+ * @offset:		binder buffer offset in target process
+ * @sender_uaddr:	user address in source process
+ * @length:		bytes to copy
+ *
+ * Specify a scatter-gather block to be copied. The actual copy must
+ * be deferred until all the needed fixups are identified and queued.
+ * Then the copy and fixups are done together so un-translated values
+ * from the source are never visible in the target buffer.
+ *
+ * We are guaranteed that repeated calls to this function will have
+ * monotonically increasing @offset values so the list will naturally
+ * be ordered.
+ *
+ * Return: 0=success, else -errno
+ */
+static int binder_defer_copy(struct list_head *sgc_head, binder_size_t offset,
+			     const void __user *sender_uaddr, size_t length)
+{
+	struct binder_sg_copy *bc = kzalloc(sizeof(*bc), GFP_KERNEL);
+
+	if (!bc)
+		return -ENOMEM;
+
+	bc->offset = offset;
+	bc->sender_uaddr = sender_uaddr;
+	bc->length = length;
+	INIT_LIST_HEAD(&bc->node);
+
+	/*
+	 * We are guaranteed that the deferred copies are in-order
+	 * so just add to the tail.
+	 */
+	list_add_tail(&bc->node, sgc_head);
+
+	return 0;
+}
+
+/**
+ * binder_add_fixup() - queue a fixup to be applied to sg copy
+ * @pf_head:	list_head of binder ptr fixup list
+ * @offset:	binder buffer offset in target process
+ * @fixup:	bytes to be copied for fixup
+ * @skip_size:	bytes to skip when copying (fixup will be applied later)
+ *
+ * Add the specified fixup to a list ordered by @offset. When copying
+ * the scatter-gather buffers, the fixup will be copied instead of
+ * data from the source buffer. For BINDER_TYPE_FDA fixups, the fixup
+ * will be applied later (in target process context), so we just skip
+ * the bytes specified by @skip_size. If @skip_size is 0, we copy the
+ * value in @fixup.
+ *
+ * This function is called *mostly* in @offset order, but there are
+ * exceptions. Since out-of-order inserts are relatively uncommon,
+ * we insert the new element by searching backward from the tail of
+ * the list.
+ *
+ * Return: 0=success, else -errno
+ */
+static int binder_add_fixup(struct list_head *pf_head, binder_size_t offset,
+			    binder_uintptr_t fixup, size_t skip_size)
+{
+	struct binder_ptr_fixup *pf = kzalloc(sizeof(*pf), GFP_KERNEL);
+	struct binder_ptr_fixup *tmppf;
+
+	if (!pf)
+		return -ENOMEM;
+
+	pf->offset = offset;
+	pf->fixup_data = fixup;
+	pf->skip_size = skip_size;
+	INIT_LIST_HEAD(&pf->node);
+
+	/* Fixups are *mostly* added in-order, but there are some
+	 * exceptions. Look backwards through list for insertion point.
+	 */
+	list_for_each_entry_reverse(tmppf, pf_head, node) {
+		if (tmppf->offset < pf->offset) {
+			list_add(&pf->node, &tmppf->node);
+			return 0;
+		}
+	}
+	/*
+	 * if we get here, then the new offset is the lowest so
+	 * insert at the head
+	 */
+	list_add(&pf->node, pf_head);
+	return 0;
+}
+
+static int binder_translate_fd_array(struct list_head *pf_head,
+				     struct binder_fd_array_object *fda,
+				     const void __user *sender_ubuffer,
 				     struct binder_buffer_object *parent,
+				     struct binder_buffer_object *sender_uparent,
 				     struct binder_transaction *t,
 				     struct binder_thread *thread,
 				     struct binder_transaction *in_reply_to)
 {
 	binder_size_t fdi, fd_buf_size;
 	binder_size_t fda_offset;
+	const void __user *sender_ufda_base;
 	struct binder_proc *proc = thread->proc;
-	struct binder_proc *target_proc = t->to_proc;
+	int ret;
+
+	if (fda->num_fds == 0)
+		return 0;
 
 	fd_buf_size = sizeof(u32) * fda->num_fds;
 	if (fda->num_fds >= SIZE_MAX / sizeof(u32)) {
@@ -2656,19 +2919,25 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
 	 */
 	fda_offset = (parent->buffer - (uintptr_t)t->buffer->user_data) +
 		fda->parent_offset;
-	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32))) {
+	sender_ufda_base = (void __user *)(uintptr_t)sender_uparent->buffer +
+				fda->parent_offset;
+
+	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32)) ||
+	    !IS_ALIGNED((unsigned long)sender_ufda_base, sizeof(u32))) {
 		binder_user_error("%d:%d parent offset not aligned correctly.\n",
 				  proc->pid, thread->pid);
 		return -EINVAL;
 	}
+	ret = binder_add_fixup(pf_head, fda_offset, 0, fda->num_fds * sizeof(u32));
+	if (ret)
+		return ret;
+
 	for (fdi = 0; fdi < fda->num_fds; fdi++) {
 		u32 fd;
-		int ret;
 		binder_size_t offset = fda_offset + fdi * sizeof(fd);
+		binder_size_t sender_uoffset = fdi * sizeof(fd);
 
-		ret = binder_alloc_copy_from_buffer(&target_proc->alloc,
-						    &fd, t->buffer,
-						    offset, sizeof(fd));
+		ret = copy_from_user(&fd, sender_ufda_base + sender_uoffset, sizeof(fd));
 		if (!ret)
 			ret = binder_translate_fd(fd, offset, t, thread,
 						  in_reply_to);
@@ -2678,7 +2947,8 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
 	return 0;
 }
 
-static int binder_fixup_parent(struct binder_transaction *t,
+static int binder_fixup_parent(struct list_head *pf_head,
+			       struct binder_transaction *t,
 			       struct binder_thread *thread,
 			       struct binder_buffer_object *bp,
 			       binder_size_t off_start_offset,
@@ -2724,14 +2994,7 @@ static int binder_fixup_parent(struct binder_transaction *t,
 	}
 	buffer_offset = bp->parent_offset +
 			(uintptr_t)parent->buffer - (uintptr_t)b->user_data;
-	if (binder_alloc_copy_to_buffer(&target_proc->alloc, b, buffer_offset,
-					&bp->buffer, sizeof(bp->buffer))) {
-		binder_user_error("%d:%d got transaction with invalid parent offset\n",
-				  proc->pid, thread->pid);
-		return -EINVAL;
-	}
-
-	return 0;
+	return binder_add_fixup(pf_head, buffer_offset, bp->buffer, 0);
 }
 
 /**
@@ -2852,6 +3115,7 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_size_t off_start_offset, off_end_offset;
 	binder_size_t off_min;
 	binder_size_t sg_buf_offset, sg_buf_end_offset;
+	binder_size_t user_offset = 0;
 	struct binder_proc *target_proc = NULL;
 	struct binder_thread *target_thread = NULL;
 	struct binder_node *target_node = NULL;
@@ -2866,6 +3130,12 @@ static void binder_transaction(struct binder_proc *proc,
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	char *secctx = NULL;
 	u32 secctx_sz = 0;
+	struct list_head sgc_head;
+	struct list_head pf_head;
+	const void __user *user_buffer = (const void __user *)
+				(uintptr_t)tr->data.ptr.buffer;
+	INIT_LIST_HEAD(&sgc_head);
+	INIT_LIST_HEAD(&pf_head);
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -3177,19 +3447,6 @@ static void binder_transaction(struct binder_proc *proc,
 	t->buffer->clear_on_free = !!(t->flags & TF_CLEAR_BUF);
 	trace_binder_transaction_alloc_buf(t->buffer);
 
-	if (binder_alloc_copy_user_to_buffer(
-				&target_proc->alloc,
-				t->buffer, 0,
-				(const void __user *)
-					(uintptr_t)tr->data.ptr.buffer,
-				tr->data_size)) {
-		binder_user_error("%d:%d got transaction with invalid data ptr\n",
-				proc->pid, thread->pid);
-		return_error = BR_FAILED_REPLY;
-		return_error_param = -EFAULT;
-		return_error_line = __LINE__;
-		goto err_copy_data_failed;
-	}
 	if (binder_alloc_copy_user_to_buffer(
 				&target_proc->alloc,
 				t->buffer,
@@ -3234,6 +3491,7 @@ static void binder_transaction(struct binder_proc *proc,
 		size_t object_size;
 		struct binder_object object;
 		binder_size_t object_offset;
+		binder_size_t copy_size;
 
 		if (binder_alloc_copy_from_buffer(&target_proc->alloc,
 						  &object_offset,
@@ -3245,8 +3503,27 @@ static void binder_transaction(struct binder_proc *proc,
 			return_error_line = __LINE__;
 			goto err_bad_offset;
 		}
-		object_size = binder_get_object(target_proc, t->buffer,
-						object_offset, &object);
+
+		/*
+		 * Copy the source user buffer up to the next object
+		 * that will be processed.
+		 */
+		copy_size = object_offset - user_offset;
+		if (copy_size && (user_offset > object_offset ||
+				binder_alloc_copy_user_to_buffer(
+					&target_proc->alloc,
+					t->buffer, user_offset,
+					user_buffer + user_offset,
+					copy_size))) {
+			binder_user_error("%d:%d got transaction with invalid data ptr\n",
+					proc->pid, thread->pid);
+			return_error = BR_FAILED_REPLY;
+			return_error_param = -EFAULT;
+			return_error_line = __LINE__;
+			goto err_copy_data_failed;
+		}
+		object_size = binder_get_object(target_proc, user_buffer,
+				t->buffer, object_offset, &object);
 		if (object_size == 0 || object_offset < off_min) {
 			binder_user_error("%d:%d got transaction with invalid offset (%lld, min %lld max %lld) or object.\n",
 					  proc->pid, thread->pid,
@@ -3258,6 +3535,11 @@ static void binder_transaction(struct binder_proc *proc,
 			return_error_line = __LINE__;
 			goto err_bad_offset;
 		}
+		/*
+		 * Set offset to the next buffer fragment to be
+		 * copied
+		 */
+		user_offset = object_offset + object_size;
 
 		hdr = &object.hdr;
 		off_min = object_offset + object_size;
@@ -3320,6 +3602,8 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_FDA: {
 			struct binder_object ptr_object;
 			binder_size_t parent_offset;
+			struct binder_object user_object;
+			size_t user_parent_size;
 			struct binder_fd_array_object *fda =
 				to_binder_fd_array_object(hdr);
 			size_t num_valid = (buffer_offset - off_start_offset) /
@@ -3351,11 +3635,35 @@ static void binder_transaction(struct binder_proc *proc,
 				return_error_line = __LINE__;
 				goto err_bad_parent;
 			}
-			ret = binder_translate_fd_array(fda, parent, t, thread,
-							in_reply_to);
-			if (ret < 0) {
+			/*
+			 * We need to read the user version of the parent
+			 * object to get the original user offset
+			 */
+			user_parent_size =
+				binder_get_object(proc, user_buffer, t->buffer,
+						  parent_offset, &user_object);
+			if (user_parent_size != sizeof(user_object.bbo)) {
+				binder_user_error("%d:%d invalid ptr object size: %zd vs %zd\n",
+						  proc->pid, thread->pid,
+						  user_parent_size,
+						  sizeof(user_object.bbo));
+				return_error = BR_FAILED_REPLY;
+				return_error_param = -EINVAL;
+				return_error_line = __LINE__;
+				goto err_bad_parent;
+			}
+			ret = binder_translate_fd_array(&pf_head, fda,
+							user_buffer, parent,
+							&user_object.bbo, t,
+							thread, in_reply_to);
+			if (!ret)
+				ret = binder_alloc_copy_to_buffer(&target_proc->alloc,
+								  t->buffer,
+								  object_offset,
+								  fda, sizeof(*fda));
+			if (ret) {
 				return_error = BR_FAILED_REPLY;
-				return_error_param = ret;
+				return_error_param = ret > 0 ? -EINVAL : ret;
 				return_error_line = __LINE__;
 				goto err_translate_failed;
 			}
@@ -3377,19 +3685,14 @@ static void binder_transaction(struct binder_proc *proc,
 				return_error_line = __LINE__;
 				goto err_bad_offset;
 			}
-			if (binder_alloc_copy_user_to_buffer(
-						&target_proc->alloc,
-						t->buffer,
-						sg_buf_offset,
-						(const void __user *)
-							(uintptr_t)bp->buffer,
-						bp->length)) {
-				binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
-						  proc->pid, thread->pid);
-				return_error_param = -EFAULT;
+			ret = binder_defer_copy(&sgc_head, sg_buf_offset,
+				(const void __user *)(uintptr_t)bp->buffer,
+				bp->length);
+			if (ret) {
 				return_error = BR_FAILED_REPLY;
+				return_error_param = ret;
 				return_error_line = __LINE__;
-				goto err_copy_data_failed;
+				goto err_translate_failed;
 			}
 			/* Fixup buffer pointer to target proc address space */
 			bp->buffer = (uintptr_t)
@@ -3398,7 +3701,8 @@ static void binder_transaction(struct binder_proc *proc,
 
 			num_valid = (buffer_offset - off_start_offset) /
 					sizeof(binder_size_t);
-			ret = binder_fixup_parent(t, thread, bp,
+			ret = binder_fixup_parent(&pf_head, t,
+						  thread, bp,
 						  off_start_offset,
 						  num_valid,
 						  last_fixup_obj_off,
@@ -3425,6 +3729,30 @@ static void binder_transaction(struct binder_proc *proc,
 			goto err_bad_object_type;
 		}
 	}
+	/* Done processing objects, copy the rest of the buffer */
+	if (binder_alloc_copy_user_to_buffer(
+				&target_proc->alloc,
+				t->buffer, user_offset,
+				user_buffer + user_offset,
+				tr->data_size - user_offset)) {
+		binder_user_error("%d:%d got transaction with invalid data ptr\n",
+				proc->pid, thread->pid);
+		return_error = BR_FAILED_REPLY;
+		return_error_param = -EFAULT;
+		return_error_line = __LINE__;
+		goto err_copy_data_failed;
+	}
+
+	ret = binder_do_deferred_txn_copies(&target_proc->alloc, t->buffer,
+					    &sgc_head, &pf_head);
+	if (ret) {
+		binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
+				  proc->pid, thread->pid);
+		return_error = BR_FAILED_REPLY;
+		return_error_param = ret;
+		return_error_line = __LINE__;
+		goto err_copy_data_failed;
+	}
 	tcomplete->type = BINDER_WORK_TRANSACTION_COMPLETE;
 	t->work.type = BINDER_WORK_TRANSACTION;
 
@@ -3491,6 +3819,7 @@ static void binder_transaction(struct binder_proc *proc,
 err_bad_offset:
 err_bad_parent:
 err_copy_data_failed:
+	binder_cleanup_deferred_txn_lists(&sgc_head, &pf_head);
 	binder_free_txn_fixups(t);
 	trace_binder_transaction_failed_buffer_release(t->buffer);
 	binder_transaction_buffer_release(target_proc, NULL, t->buffer,
diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 9b1a5e62417c..f8c29b888e6b 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -268,6 +268,9 @@ EXPORT_SYMBOL_GPL(sunxi_rsb_driver_register);
 /* common code that starts a transfer */
 static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 {
+	u32 int_mask, status;
+	bool timeout;
+
 	if (readl(rsb->regs + RSB_CTRL) & RSB_CTRL_START_TRANS) {
 		dev_dbg(rsb->dev, "RSB transfer still in progress\n");
 		return -EBUSY;
@@ -275,13 +278,23 @@ static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 
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
@@ -293,18 +306,18 @@ static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
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
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index b86ee5b18855..7736c637848a 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -396,13 +396,14 @@ int tpm_pm_suspend(struct device *dev)
 	if (chip->flags & TPM_CHIP_FLAG_ALWAYS_POWERED)
 		return 0;
 
-	if (!tpm_chip_start(chip)) {
+	rc = tpm_try_get_ops(chip);
+	if (!rc) {
 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
 			tpm2_shutdown(chip, TPM2_SU_STATE);
 		else
 			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
 
-		tpm_chip_stop(chip);
+		tpm_put_ops(chip);
 	}
 
 	return rc;
diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index e3be5c2f57b8..4b04ffbe5e7e 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -26,7 +26,7 @@ static int riscv_clock_next_event(unsigned long delta,
 
 static DEFINE_PER_CPU(struct clock_event_device, riscv_clock_event) = {
 	.name			= "riscv_timer_clockevent",
-	.features		= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP,
+	.features		= CLOCK_EVT_FEAT_ONESHOT,
 	.rating			= 100,
 	.set_next_event		= riscv_clock_next_event,
 };
diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index 8d132e4f008a..568074148f62 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -152,20 +152,22 @@ static int coreboot_table_probe(struct platform_device *pdev)
 	if (!ptr)
 		return -ENOMEM;
 
-	ret = bus_register(&coreboot_bus_type);
-	if (!ret) {
-		ret = coreboot_table_populate(dev, ptr);
-		if (ret)
-			bus_unregister(&coreboot_bus_type);
-	}
+	ret = coreboot_table_populate(dev, ptr);
+
 	memunmap(ptr);
 
 	return ret;
 }
 
+static int __cb_dev_unregister(struct device *dev, void *dummy)
+{
+	device_unregister(dev);
+	return 0;
+}
+
 static int coreboot_table_remove(struct platform_device *pdev)
 {
-	bus_unregister(&coreboot_bus_type);
+	bus_for_each_dev(&coreboot_bus_type, NULL, NULL, __cb_dev_unregister);
 	return 0;
 }
 
@@ -195,6 +197,32 @@ static struct platform_driver coreboot_table_driver = {
 		.of_match_table = of_match_ptr(coreboot_of_match),
 	},
 };
-module_platform_driver(coreboot_table_driver);
+
+static int __init coreboot_table_driver_init(void)
+{
+	int ret;
+
+	ret = bus_register(&coreboot_bus_type);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&coreboot_table_driver);
+	if (ret) {
+		bus_unregister(&coreboot_bus_type);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit coreboot_table_driver_exit(void)
+{
+	platform_driver_unregister(&coreboot_table_driver);
+	bus_unregister(&coreboot_bus_type);
+}
+
+module_init(coreboot_table_driver_init);
+module_exit(coreboot_table_driver_exit);
+
 MODULE_AUTHOR("Google, Inc.");
 MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index cf80da354ba1..fac43a9f553c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -316,8 +316,10 @@ static void amdgpu_connector_get_edid(struct drm_connector *connector)
 	if (!amdgpu_connector->edid) {
 		/* some laptops provide a hardcoded edid in rom for LCDs */
 		if (((connector->connector_type == DRM_MODE_CONNECTOR_LVDS) ||
-		     (connector->connector_type == DRM_MODE_CONNECTOR_eDP)))
+		     (connector->connector_type == DRM_MODE_CONNECTOR_eDP))) {
 			amdgpu_connector->edid = amdgpu_connector_get_hardcoded_edid(adev);
+			drm_connector_update_edid_property(connector, amdgpu_connector->edid);
+		}
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 9d61d1b7a569..858e2a8a9b71 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -329,11 +329,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
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
index de33864af70b..fe9c135fee0e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1436,13 +1436,12 @@ amdgpu_dm_update_connector_after_detect(struct amdgpu_dm_connector *aconnector)
 			aconnector->edid =
 				(struct edid *)sink->dc_edid.raw_edid;
 
-			drm_connector_update_edid_property(connector,
-							   aconnector->edid);
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,
 						    aconnector->edid);
 		}
 
+		drm_connector_update_edid_property(connector, aconnector->edid);
 		amdgpu_dm_update_freesync_caps(connector, aconnector->edid);
 
 	} else {
diff --git a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
index 7c52f7f9196c..3c096ad39096 100644
--- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
@@ -340,7 +340,8 @@ static const struct dce_audio_registers audio_regs[] = {
 	audio_regs(2),
 	audio_regs(3),
 	audio_regs(4),
-	audio_regs(5)
+	audio_regs(5),
+	audio_regs(6),
 };
 
 #define DCE120_AUD_COMMON_MASK_SH_LIST(mask_sh)\
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
index f6d7f5d307d7..b1ba08e3e101 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -348,6 +348,10 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
+		if (INTEL_GEN(i915) == 12 && (engine->class == VIDEO_DECODE_CLASS ||
+		    engine->class == VIDEO_ENHANCEMENT_CLASS))
+			rb.bit = _MASKED_BIT_ENABLE(rb.bit);
+
 		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 	}
 
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 9260ad47350f..3adf4fae452a 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -493,13 +493,17 @@ static void vmbus_add_channel_work(struct work_struct *work)
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
index d4c5efc6e157..a1cfa7596853 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1863,6 +1863,7 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	ret = device_register(&child_device_obj->device);
 	if (ret) {
 		pr_err("Unable to register child device\n");
+		put_device(&child_device_obj->device);
 		return ret;
 	}
 
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index d2530f581186..7a64ff6a8779 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -242,10 +242,13 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 	 */
 	if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL) {
 		for (i = 0; i < ARRAY_SIZE(tjmax_pci_table); i++) {
-			if (host_bridge->device == tjmax_pci_table[i].device)
+			if (host_bridge->device == tjmax_pci_table[i].device) {
+				pci_dev_put(host_bridge);
 				return tjmax_pci_table[i].tjmax;
+			}
 		}
 	}
+	pci_dev_put(host_bridge);
 
 	for (i = 0; i < ARRAY_SIZE(tjmax_table); i++) {
 		if (strstr(c->x86_model_id, tjmax_table[i].id))
@@ -533,6 +536,10 @@ static void coretemp_remove_core(struct platform_data *pdata, int indx)
 {
 	struct temp_data *tdata = pdata->core_data[indx];
 
+	/* if we errored on add then this is already gone */
+	if (!tdata)
+		return;
+
 	/* Remove the sysfs attributes */
 	sysfs_remove_group(&pdata->hwmon_dev->kobj, &tdata->attr_group);
 
diff --git a/drivers/hwmon/i5500_temp.c b/drivers/hwmon/i5500_temp.c
index 360f5aee1394..d4be03f43fb4 100644
--- a/drivers/hwmon/i5500_temp.c
+++ b/drivers/hwmon/i5500_temp.c
@@ -108,7 +108,7 @@ static int i5500_temp_probe(struct pci_dev *pdev,
 	u32 tstimer;
 	s8 tsfsc;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to enable device\n");
 		return err;
diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index b2ab83c9fd9a..fe90f0536d76 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -502,6 +502,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 	return;
 
 out_register:
+	list_del(&data->list);
 	hwmon_device_unregister(data->hwmon_dev);
 out_user:
 	ipmi_destroy_user(data->user);
diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
index 29104656a537..3fdaf3104cce 100644
--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -245,14 +245,14 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
 			    int *val, int *val2, long mask)
 {
 	struct afe4403_data *afe = iio_priv(indio_dev);
-	unsigned int reg = afe4403_channel_values[chan->address];
-	unsigned int field = afe4403_channel_leds[chan->address];
+	unsigned int reg, field;
 	int ret;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			reg = afe4403_channel_values[chan->address];
 			ret = afe4403_read(afe, reg, val);
 			if (ret)
 				return ret;
@@ -262,6 +262,7 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			field = afe4403_channel_leds[chan->address];
 			ret = regmap_field_read(afe->fields[field], val);
 			if (ret)
 				return ret;
diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
index cebb1fd4d0b1..7780e9b312b3 100644
--- a/drivers/iio/health/afe4404.c
+++ b/drivers/iio/health/afe4404.c
@@ -250,20 +250,20 @@ static int afe4404_read_raw(struct iio_dev *indio_dev,
 			    int *val, int *val2, long mask)
 {
 	struct afe4404_data *afe = iio_priv(indio_dev);
-	unsigned int value_reg = afe4404_channel_values[chan->address];
-	unsigned int led_field = afe4404_channel_leds[chan->address];
-	unsigned int offdac_field = afe4404_channel_offdacs[chan->address];
+	unsigned int value_reg, led_field, offdac_field;
 	int ret;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			value_reg = afe4404_channel_values[chan->address];
 			ret = regmap_read(afe->regmap, value_reg, val);
 			if (ret)
 				return ret;
 			return IIO_VAL_INT;
 		case IIO_CHAN_INFO_OFFSET:
+			offdac_field = afe4404_channel_offdacs[chan->address];
 			ret = regmap_field_read(afe->fields[offdac_field], val);
 			if (ret)
 				return ret;
@@ -273,6 +273,7 @@ static int afe4404_read_raw(struct iio_dev *indio_dev,
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			led_field = afe4404_channel_leds[chan->address];
 			ret = regmap_field_read(afe->fields[led_field], val);
 			if (ret)
 				return ret;
@@ -295,19 +296,20 @@ static int afe4404_write_raw(struct iio_dev *indio_dev,
 			     int val, int val2, long mask)
 {
 	struct afe4404_data *afe = iio_priv(indio_dev);
-	unsigned int led_field = afe4404_channel_leds[chan->address];
-	unsigned int offdac_field = afe4404_channel_offdacs[chan->address];
+	unsigned int led_field, offdac_field;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_OFFSET:
+			offdac_field = afe4404_channel_offdacs[chan->address];
 			return regmap_field_write(afe->fields[offdac_field], val);
 		}
 		break;
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			led_field = afe4404_channel_leds[chan->address];
 			return regmap_field_write(afe->fields[led_field], val);
 		}
 		break;
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
diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index 42b64b85d06c..83885f6c93cd 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -239,6 +239,8 @@ config RPR0521
 	tristate "ROHM RPR0521 ALS and proximity sensor driver"
 	depends on I2C
 	select REGMAP_I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y here if you want to build support for ROHM's RPR0521
 	  ambient light and proximity sensor device.
diff --git a/drivers/iio/light/apds9960.c b/drivers/iio/light/apds9960.c
index c5dfb9a6b5a1..2403911fdbd9 100644
--- a/drivers/iio/light/apds9960.c
+++ b/drivers/iio/light/apds9960.c
@@ -55,9 +55,6 @@
 #define APDS9960_REG_CONTROL_PGAIN_MASK_SHIFT	2
 
 #define APDS9960_REG_CONFIG_2	0x90
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK	0x60
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK_SHIFT	5
-
 #define APDS9960_REG_ID		0x92
 
 #define APDS9960_REG_STATUS	0x93
@@ -78,6 +75,9 @@
 #define APDS9960_REG_GCONF_1_GFIFO_THRES_MASK_SHIFT	6
 
 #define APDS9960_REG_GCONF_2	0xa3
+#define APDS9960_REG_GCONF_2_GGAIN_MASK			0x60
+#define APDS9960_REG_GCONF_2_GGAIN_MASK_SHIFT		5
+
 #define APDS9960_REG_GOFFSET_U	0xa4
 #define APDS9960_REG_GOFFSET_D	0xa5
 #define APDS9960_REG_GPULSE	0xa6
@@ -397,9 +397,9 @@ static int apds9960_set_pxs_gain(struct apds9960_data *data, int val)
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
index f5db9fa086f3..511ebdeafbe4 100644
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
index 8089c59adce5..3175816e657f 100644
--- a/drivers/iio/pressure/ms5611_i2c.c
+++ b/drivers/iio/pressure/ms5611_i2c.c
@@ -18,17 +18,15 @@
 
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
@@ -55,11 +53,10 @@ static int ms5611_i2c_read_adc(struct ms5611_state *st, s32 *val)
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
index c3854594cd26..6e9cab61bc32 100644
--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -13,18 +13,17 @@
 
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
@@ -35,11 +34,10 @@ static int ms5611_spi_read_prom_word(struct device *dev, int index, u16 *word)
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
@@ -50,11 +48,10 @@ static int ms5611_spi_read_adc(struct device *dev, s32 *val)
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
@@ -66,7 +63,7 @@ static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
 		return ret;
 
 	usleep_range(osr->conv_usec, osr->conv_usec + (osr->conv_usec / 10UL));
-	ret = ms5611_spi_read_adc(dev, temp);
+	ret = ms5611_spi_read_adc(st, temp);
 	if (ret < 0)
 		return ret;
 
@@ -76,7 +73,7 @@ static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
 		return ret;
 
 	usleep_range(osr->conv_usec, osr->conv_usec + (osr->conv_usec / 10UL));
-	return ms5611_spi_read_adc(dev, pressure);
+	return ms5611_spi_read_adc(st, pressure);
 }
 
 static int ms5611_spi_probe(struct spi_device *spi)
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 4b81b2d0fe06..05b007d0a89b 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -189,6 +189,7 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 9f881fc102f7..36900d65386f 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -794,6 +794,7 @@ int __init dmar_dev_scope_init(void)
 			info = dmar_alloc_pci_notify_info(dev,
 					BUS_NOTIFY_ADD_DEVICE);
 			if (!info) {
+				pci_dev_put(dev);
 				return dmar_dev_scope_status;
 			} else {
 				dmar_pci_bus_add_dev(info);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index acbda91e7643..32f36810c3c9 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2346,10 +2346,6 @@ static void integrity_writer(struct work_struct *w)
 
 	unsigned prev_free_sectors;
 
-	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_post_suspending(ic->ti)) && !ic->meta_dev)
-		return;
-
 	spin_lock_irq(&ic->endio_wait.lock);
 	write_start = ic->committed_section;
 	write_sections = ic->n_committed_sections;
@@ -2858,8 +2854,7 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 	drain_workqueue(ic->commit_wq);
 
 	if (ic->mode == 'J') {
-		if (ic->meta_dev)
-			queue_work(ic->writer_wq, &ic->writer_work);
+		queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
 		dm_integrity_flush_buffers(ic, true);
 	}
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 5ff4f179204a..7caf9ef27d22 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1556,6 +1556,11 @@ void mmc_init_erase(struct mmc_card *card)
 		card->pref_erase = 0;
 }
 
+static bool is_trim_arg(unsigned int arg)
+{
+	return (arg & MMC_TRIM_OR_DISCARD_ARGS) && arg != MMC_DISCARD_ARG;
+}
+
 static unsigned int mmc_mmc_erase_timeout(struct mmc_card *card,
 				          unsigned int arg, unsigned int qty)
 {
@@ -1887,7 +1892,7 @@ int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN))
 		return -EOPNOTSUPP;
 
-	if (mmc_card_mmc(card) && (arg & MMC_TRIM_ARGS) &&
+	if (mmc_card_mmc(card) && is_trim_arg(arg) &&
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN))
 		return -EOPNOTSUPP;
 
@@ -1917,7 +1922,7 @@ int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 	 * identified by the card->eg_boundary flag.
 	 */
 	rem = card->erase_size - (from % card->erase_size);
-	if ((arg & MMC_TRIM_ARGS) && (card->eg_boundary) && (nr > rem)) {
+	if ((arg & MMC_TRIM_OR_DISCARD_ARGS) && card->eg_boundary && nr > rem) {
 		err = mmc_do_erase(card, from, from + rem - 1, arg);
 		from += rem;
 		if ((err) || (to <= from))
diff --git a/drivers/mmc/core/mmc_test.c b/drivers/mmc/core/mmc_test.c
index 492dd4596314..cd64e0f23ae5 100644
--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -3167,7 +3167,8 @@ static int __mmc_test_register_dbgfs_file(struct mmc_card *card,
 	struct mmc_test_dbgfs_file *df;
 
 	if (card->debugfs_root)
-		debugfs_create_file(name, mode, card->debugfs_root, card, fops);
+		file = debugfs_create_file(name, mode, card->debugfs_root,
+					   card, fops);
 
 	df = kmalloc(sizeof(*df), GFP_KERNEL);
 	if (!df) {
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index d97c19ef7583..96cad561e1d8 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1302,7 +1302,7 @@ static void esdhc_cqe_enable(struct mmc_host *mmc)
 	 * system resume back.
 	 */
 	cqhci_writel(cq_host, 0, CQHCI_CTL);
-	if (cqhci_readl(cq_host, CQHCI_CTL) && CQHCI_HALT)
+	if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT)
 		dev_err(mmc_dev(host->mmc),
 			"failed to exit halt state when enable CQE\n");
 
diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index 4e2d6a25f200..ccbf016dc3fd 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -431,7 +431,7 @@ static int sdhci_sprd_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)
 	}
 
 	if (IS_ERR(sprd_host->pinctrl))
-		return 0;
+		goto reset;
 
 	switch (ios->signal_voltage) {
 	case MMC_SIGNAL_VOLTAGE_180:
@@ -459,6 +459,8 @@ static int sdhci_sprd_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	/* Wait for 300 ~ 500 us for pin state stable */
 	usleep_range(300, 500);
+
+reset:
 	sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 
 	return 0;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index deafcc56adee..115feb9aa236 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -9,6 +9,7 @@
  *     - JMicron (hardware and technical support)
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/ktime.h>
 #include <linux/highmem.h>
@@ -331,6 +332,7 @@ static void sdhci_init(struct sdhci_host *host, int soft)
 	if (soft) {
 		/* force clock reconfiguration */
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	}
 }
@@ -1570,10 +1572,9 @@ u16 sdhci_calc_clk(struct sdhci_host *host, unsigned int clock,
 
 			clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
 			pre_val = sdhci_get_preset_value(host);
-			div = (pre_val & SDHCI_PRESET_SDCLK_FREQ_MASK)
-				>> SDHCI_PRESET_SDCLK_FREQ_SHIFT;
+			div = FIELD_GET(SDHCI_PRESET_SDCLK_FREQ_MASK, pre_val);
 			if (host->clk_mul &&
-				(pre_val & SDHCI_PRESET_CLKGEN_SEL_MASK)) {
+				(pre_val & SDHCI_PRESET_CLKGEN_SEL)) {
 				clk = SDHCI_PROG_CLOCK_MODE;
 				real_div = div + 1;
 				clk_mul = host->clk_mul;
@@ -1911,11 +1912,46 @@ void sdhci_set_uhs_signaling(struct sdhci_host *host, unsigned timing)
 }
 EXPORT_SYMBOL_GPL(sdhci_set_uhs_signaling);
 
+static bool sdhci_timing_has_preset(unsigned char timing)
+{
+	switch (timing) {
+	case MMC_TIMING_UHS_SDR12:
+	case MMC_TIMING_UHS_SDR25:
+	case MMC_TIMING_UHS_SDR50:
+	case MMC_TIMING_UHS_SDR104:
+	case MMC_TIMING_UHS_DDR50:
+	case MMC_TIMING_MMC_DDR52:
+		return true;
+	};
+	return false;
+}
+
+static bool sdhci_preset_needed(struct sdhci_host *host, unsigned char timing)
+{
+	return !(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
+	       sdhci_timing_has_preset(timing);
+}
+
+static bool sdhci_presetable_values_change(struct sdhci_host *host, struct mmc_ios *ios)
+{
+	/*
+	 * Preset Values are: Driver Strength, Clock Generator and SDCLK/RCLK
+	 * Frequency. Check if preset values need to be enabled, or the Driver
+	 * Strength needs updating. Note, clock changes are handled separately.
+	 */
+	return !host->preset_enabled &&
+	       (sdhci_preset_needed(host, ios->timing) || host->drv_type != ios->drv_type);
+}
+
 void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
+	bool reinit_uhs = host->reinit_uhs;
+	bool turning_on_clk = false;
 	u8 ctrl;
 
+	host->reinit_uhs = false;
+
 	if (ios->power_mode == MMC_POWER_UNDEFINED)
 		return;
 
@@ -1941,6 +1977,8 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		sdhci_enable_preset_value(host, false);
 
 	if (!ios->clock || ios->clock != host->clock) {
+		turning_on_clk = ios->clock && !host->clock;
+
 		host->ops->set_clock(host, ios->clock);
 		host->clock = ios->clock;
 
@@ -1967,6 +2005,17 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	host->ops->set_bus_width(host, ios->bus_width);
 
+	/*
+	 * Special case to avoid multiple clock changes during voltage
+	 * switching.
+	 */
+	if (!reinit_uhs &&
+	    turning_on_clk &&
+	    host->timing == ios->timing &&
+	    host->version >= SDHCI_SPEC_300 &&
+	    !sdhci_presetable_values_change(host, ios))
+		return;
+
 	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 
 	if (!(host->quirks & SDHCI_QUIRK_NO_HISPD_BIT)) {
@@ -2010,6 +2059,7 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			}
 
 			sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
+			host->drv_type = ios->drv_type;
 		} else {
 			/*
 			 * According to SDHC Spec v3.00, if the Preset Value
@@ -2037,19 +2087,14 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->ops->set_uhs_signaling(host, ios->timing);
 		host->timing = ios->timing;
 
-		if (!(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
-				((ios->timing == MMC_TIMING_UHS_SDR12) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR25) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR50) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR104) ||
-				 (ios->timing == MMC_TIMING_UHS_DDR50) ||
-				 (ios->timing == MMC_TIMING_MMC_DDR52))) {
+		if (sdhci_preset_needed(host, ios->timing)) {
 			u16 preset;
 
 			sdhci_enable_preset_value(host, true);
 			preset = sdhci_get_preset_value(host);
-			ios->drv_type = (preset & SDHCI_PRESET_DRV_MASK)
-				>> SDHCI_PRESET_DRV_SHIFT;
+			ios->drv_type = FIELD_GET(SDHCI_PRESET_DRV_MASK,
+						  preset);
+			host->drv_type = ios->drv_type;
 		}
 
 		/* Re-enable SD Clock */
@@ -3327,6 +3372,7 @@ int sdhci_resume_host(struct sdhci_host *host)
 		sdhci_init(host, 0);
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	} else {
 		sdhci_init(host, (host->mmc->pm_flags & MMC_PM_KEEP_POWER));
@@ -3389,6 +3435,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host, int soft_reset)
 		/* Force clock and power re-program */
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->start_signal_voltage_switch(mmc, &mmc->ios);
 		mmc->ops->set_ios(mmc, &mmc->ios);
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 54f9d6720f13..00df46a75be5 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -9,6 +9,7 @@
 #ifndef __SDHCI_HW_H
 #define __SDHCI_HW_H
 
+#include <linux/bits.h>
 #include <linux/scatterlist.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
@@ -268,12 +269,9 @@
 #define SDHCI_PRESET_FOR_SDR104        0x6C
 #define SDHCI_PRESET_FOR_DDR50 0x6E
 #define SDHCI_PRESET_FOR_HS400 0x74 /* Non-standard */
-#define SDHCI_PRESET_DRV_MASK  0xC000
-#define SDHCI_PRESET_DRV_SHIFT  14
-#define SDHCI_PRESET_CLKGEN_SEL_MASK   0x400
-#define SDHCI_PRESET_CLKGEN_SEL_SHIFT	10
-#define SDHCI_PRESET_SDCLK_FREQ_MASK   0x3FF
-#define SDHCI_PRESET_SDCLK_FREQ_SHIFT	0
+#define SDHCI_PRESET_DRV_MASK		GENMASK(15, 14)
+#define SDHCI_PRESET_CLKGEN_SEL		BIT(10)
+#define SDHCI_PRESET_SDCLK_FREQ_MASK	GENMASK(9, 0)
 
 #define SDHCI_SLOT_INT_STATUS	0xFC
 
@@ -530,6 +528,8 @@ struct sdhci_host {
 
 	unsigned int clock;	/* Current clock (MHz) */
 	u8 pwr;			/* Current voltage */
+	u8 drv_type;		/* Current UHS-I driver type */
+	bool reinit_uhs;	/* Force UHS-related re-initialization */
 
 	bool runtime_suspended;	/* Host is runtime suspended */
 	bool bus_on;		/* Bus power prevents runtime suspend */
diff --git a/drivers/net/can/cc770/cc770_isa.c b/drivers/net/can/cc770/cc770_isa.c
index b9047d8110d5..910e8c309a67 100644
--- a/drivers/net/can/cc770/cc770_isa.c
+++ b/drivers/net/can/cc770/cc770_isa.c
@@ -264,22 +264,24 @@ static int cc770_isa_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev,
 			"couldn't register device (err=%d)\n", err);
-		goto exit_unmap;
+		goto exit_free;
 	}
 
 	dev_info(&pdev->dev, "device registered (reg_base=0x%p, irq=%d)\n",
 		 priv->reg_base, dev->irq);
 	return 0;
 
- exit_unmap:
+exit_free:
+	free_cc770dev(dev);
+exit_unmap:
 	if (mem[idx])
 		iounmap(base);
- exit_release:
+exit_release:
 	if (mem[idx])
 		release_mem_region(mem[idx], iosize);
 	else
 		release_region(port[idx], iosize);
- exit:
+exit:
 	return err;
 }
 
diff --git a/drivers/net/can/sja1000/sja1000_isa.c b/drivers/net/can/sja1000/sja1000_isa.c
index 1c4d32d1a542..fe8441be716b 100644
--- a/drivers/net/can/sja1000/sja1000_isa.c
+++ b/drivers/net/can/sja1000/sja1000_isa.c
@@ -202,22 +202,24 @@ static int sja1000_isa_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
 			DRV_NAME, err);
-		goto exit_unmap;
+		goto exit_free;
 	}
 
 	dev_info(&pdev->dev, "%s device registered (reg_base=0x%p, irq=%d)\n",
 		 DRV_NAME, priv->reg_base, dev->irq);
 	return 0;
 
- exit_unmap:
+exit_free:
+	free_sja1000dev(dev);
+exit_unmap:
 	if (mem[idx])
 		iounmap(base);
- exit_release:
+exit_release:
 	if (mem[idx])
 		release_mem_region(mem[idx], iosize);
 	else
 		release_region(port[idx], iosize);
- exit:
+exit:
 	return err;
 }
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 4b9d5b0ce416..e981b0184077 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -957,7 +957,7 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
 	{ .offset = LAN9303_MAC_TX_BRDCST_CNT_0, .name = "TxBroad", },
 	{ .offset = LAN9303_MAC_TX_PAUSE_CNT_0, .name = "TxPause", },
 	{ .offset = LAN9303_MAC_TX_MULCST_CNT_0, .name = "TxMulti", },
-	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "TxUnderRun", },
+	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "RxShort", },
 	{ .offset = LAN9303_MAC_TX_64_CNT_0, .name = "Tx64Byte", },
 	{ .offset = LAN9303_MAC_TX_127_CNT_0, .name = "Tx128Byte", },
 	{ .offset = LAN9303_MAC_TX_255_CNT_0, .name = "Tx256Byte", },
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 4630998d47fd..d920bb8dae77 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -807,16 +807,20 @@ static void bnx2x_vf_enable_traffic(struct bnx2x *bp, struct bnx2x_virtf *vf)
 
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
index 69878589213a..ab86240e4532 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1836,7 +1836,7 @@ static int liquidio_open(struct net_device *netdev)
 
 	ifstate_set(lio, LIO_IFSTATE_RUNNING);
 
-	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on)) {
+	if (!OCTEON_CN23XX_PF(oct) || !oct->msix_on) {
 		ret = setup_tx_poll_fn(netdev);
 		if (ret)
 			goto err_poll;
@@ -1866,7 +1866,7 @@ static int liquidio_open(struct net_device *netdev)
 	return 0;
 
 err_rx_ctrl:
-	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on))
+	if (!OCTEON_CN23XX_PF(oct) || !oct->msix_on)
 		cleanup_tx_poll_fn(netdev);
 err_poll:
 	if (lio->ptp_clock) {
diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index 76ff42ec3ae5..a34c33e8a8ad 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1438,8 +1438,10 @@ static acpi_status bgx_acpi_match_id(acpi_handle handle, u32 lvl,
 		return AE_OK;
 	}
 
-	if (strncmp(string.pointer, bgx_sel, 4))
+	if (strncmp(string.pointer, bgx_sel, 4)) {
+		kfree(string.pointer);
 		return AE_OK;
+	}
 
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
 			    bgx_acpi_register_phy, NULL, bgx, NULL);
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 427e7a31862c..d7f2890c254f 100644
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
index e00a8eb7716f..93a6597366f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1417,8 +1417,8 @@ static ssize_t outlen_write(struct file *filp, const char __user *buf,
 		return -EFAULT;
 
 	err = sscanf(outlen_str, "%d", &outlen);
-	if (err < 0)
-		return err;
+	if (err != 1)
+		return -EINVAL;
 
 	ptr = kzalloc(outlen, GFP_KERNEL);
 	if (!ptr)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index f8144ce7e476..db9ecc3a8c67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -636,7 +636,7 @@ static void mlx5_tracer_handle_timestamp_trace(struct mlx5_fw_tracer *tracer,
 			trace_timestamp = (timestamp_event.timestamp & MASK_52_7) |
 					  (str_frmt->timestamp & MASK_6_0);
 		else
-			trace_timestamp = ((timestamp_event.timestamp & MASK_52_7) - 1) |
+			trace_timestamp = ((timestamp_event.timestamp - 1) & MASK_52_7) |
 					  (str_frmt->timestamp & MASK_6_0);
 
 		mlx5_tracer_print_trace(str_frmt, dev, trace_timestamp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 366bda1bb1c3..c9115c0407ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -267,6 +267,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	for (curr_dest = 0; curr_dest < num_vport_dests; curr_dest++) {
 		struct mlx5_termtbl_handle *tt = attr->dests[curr_dest].termtbl;
 
+		attr->dests[curr_dest].termtbl = NULL;
+
 		/* search for the destination associated with the
 		 * current term table
 		 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index e178d8d3dbc9..077b4bec1b13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -9,7 +9,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 	struct mlx5dr_matcher *last_matcher = NULL;
 	struct mlx5dr_htbl_connect_info info;
 	struct mlx5dr_ste_htbl *last_htbl;
-	int ret;
+	int ret = -EOPNOTSUPP;
 
 	if (action && action->action_type != DR_ACTION_TYP_FT)
 		return -EOPNOTSUPP;
@@ -68,6 +68,9 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 		}
 	}
 
+	if (ret)
+		goto out;
+
 	/* Release old action */
 	if (tbl->miss_action)
 		refcount_dec(&tbl->miss_action->refcount);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 46d6988829ff..ff8810357181 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1127,6 +1127,9 @@ nfp_port_get_module_info(struct net_device *netdev,
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	if (!port)
+		return -EOPNOTSUPP;
+
 	/* update port state to get latest interface */
 	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index ffd44edfffbf..acb25b8c9458 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -249,25 +249,26 @@ static void nixge_hw_dma_bd_release(struct net_device *ndev)
 	struct sk_buff *skb;
 	int i;
 
-	for (i = 0; i < RX_BD_NUM; i++) {
-		phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
-						     phys);
-
-		dma_unmap_single(ndev->dev.parent, phys_addr,
-				 NIXGE_MAX_JUMBO_FRAME_SIZE,
-				 DMA_FROM_DEVICE);
-
-		skb = (struct sk_buff *)(uintptr_t)
-			nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
-						 sw_id_offset);
-		dev_kfree_skb(skb);
-	}
+	if (priv->rx_bd_v) {
+		for (i = 0; i < RX_BD_NUM; i++) {
+			phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
+							     phys);
+
+			dma_unmap_single(ndev->dev.parent, phys_addr,
+					 NIXGE_MAX_JUMBO_FRAME_SIZE,
+					 DMA_FROM_DEVICE);
+
+			skb = (struct sk_buff *)(uintptr_t)
+				nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
+							 sw_id_offset);
+			dev_kfree_skb(skb);
+		}
 
-	if (priv->rx_bd_v)
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(*priv->rx_bd_v) * RX_BD_NUM,
 				  priv->rx_bd_v,
 				  priv->rx_bd_p);
+	}
 
 	if (priv->tx_skb)
 		devm_kfree(ndev->dev.parent, priv->tx_skb);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 8ff4c616f0ad..45b7f0f419c9 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1166,6 +1166,7 @@ static void pch_gbe_tx_queue(struct pch_gbe_adapter *adapter,
 		buffer_info->dma = 0;
 		buffer_info->time_stamp = 0;
 		tx_ring->next_to_use = ring_num;
+		dev_kfree_skb_any(skb);
 		return;
 	}
 	buffer_info->mapped = true;
@@ -2480,6 +2481,7 @@ static void pch_gbe_remove(struct pci_dev *pdev)
 	unregister_netdev(netdev);
 
 	pch_gbe_phy_hw_reset(&adapter->hw);
+	pci_dev_put(adapter->ptp_pdev);
 
 	free_netdev(netdev);
 }
@@ -2561,7 +2563,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	/* setup the private structure */
 	ret = pch_gbe_sw_init(adapter);
 	if (ret)
-		goto err_free_netdev;
+		goto err_put_dev;
 
 	/* Initialize PHY */
 	ret = pch_gbe_init_phy(adapter);
@@ -2619,6 +2621,8 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 
 err_free_adapter:
 	pch_gbe_phy_hw_reset(&adapter->hw);
+err_put_dev:
+	pci_dev_put(adapter->ptp_pdev);
 err_free_netdev:
 	free_netdev(netdev);
 	return ret;
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 5e81cd317a32..11616aca0e6a 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2476,6 +2476,7 @@ static netdev_tx_t ql3xxx_send(struct sk_buff *skb,
 					     skb_shinfo(skb)->nr_frags);
 	if (tx_cb->seg_count == -1) {
 		netdev_err(ndev, "%s: invalid segment count!\n", __func__);
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index df43d364e6a4..e6538f38b056 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -2993,7 +2993,7 @@ static void qlcnic_83xx_recover_driver_lock(struct qlcnic_adapter *adapter)
 		QLCWRX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK, val);
 		dev_info(&adapter->pdev->dev,
 			 "%s: lock recovery initiated\n", __func__);
-		msleep(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
 		val = QLCRDX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK);
 		id = ((val >> 2) & 0xF);
 		if (id == adapter->portnum) {
@@ -3029,7 +3029,7 @@ int qlcnic_83xx_lock_driver(struct qlcnic_adapter *adapter)
 		if (status)
 			break;
 
-		msleep(QLC_83XX_DRV_LOCK_WAIT_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_WAIT_DELAY);
 		i++;
 
 		if (i == 1)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9208a72fe17e..95fd1f2d5439 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2327,6 +2327,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 		ret = ravb_open(ndev);
 		if (ret < 0)
 			return ret;
+		ravb_set_rx_mode(ndev);
 		netif_device_attach(ndev);
 	}
 
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index a5bab614ff84..1b7d588ff3c5 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -484,7 +484,14 @@ static int __init ntb_netdev_init_module(void)
 	rc = ntb_transport_register_client_dev(KBUILD_MODNAME);
 	if (rc)
 		return rc;
-	return ntb_transport_register_client(&ntb_netdev_client);
+
+	rc = ntb_transport_register_client(&ntb_netdev_client);
+	if (rc) {
+		ntb_transport_unregister_client_dev(KBUILD_MODNAME);
+		return rc;
+	}
+
+	return 0;
 }
 module_init(ntb_netdev_init_module);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 78b918dcd547..388799985720 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1312,6 +1312,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 error_module_put:
 	module_put(d->driver->owner);
+	d->driver = NULL;
 error_put_device:
 	put_device(d);
 	if (ndev_owner != bus->owner)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f01db73dab05..957e6051c535 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -742,7 +742,6 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		if (tun)
 			xdp_rxq_info_unreg(&tfile->xdp_rxq);
 		ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
-		sock_put(&tfile->sk);
 	}
 }
 
@@ -758,6 +757,9 @@ static void tun_detach(struct tun_file *tfile, bool clean)
 	if (dev)
 		netdev_state_change(dev);
 	rtnl_unlock();
+
+	if (clean)
+		sock_put(&tfile->sk);
 }
 
 static void tun_detach_all(struct net_device *dev)
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6f82436ff72f..7f0e3b09f776 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1314,6 +1314,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x103a, 0)}, /* Telit LE910C4-WWX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3a3a5a570694..f80b1d57d6c3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -663,6 +663,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *cb;
 
 	if (!vp->assoc)
 		return;
@@ -684,6 +685,10 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	memcpy(hdr->addr2, mac, ETH_ALEN);
 	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
 
+	cb = IEEE80211_SKB_CB(skb);
+	cb->control.rates[0].count = 1;
+	cb->control.rates[1].idx = -1;
+
 	rcu_read_lock();
 	mac80211_hwsim_tx_frame(data->hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index f25f1ec5f9e9..0cd70cd680dc 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -327,7 +327,7 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		 * AID          81      5 to 16
 		 * PARAMETERS   82      0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
@@ -341,8 +341,10 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 
 		/* Check next byte is PARAMETERS tag (82) */
 		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
+			devm_kfree(dev, transaction);
 			return -EPROTO;
+		}
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
 		memcpy(transaction->params, skb->data +
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 6627fb531f33..3b5e5fb158be 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3027,11 +3027,17 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		dev_warn(ctrl->device, "resetting controller\n");
 		return nvme_reset_ctrl_sync(ctrl);
 	case NVME_IOCTL_SUBSYS_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		return nvme_reset_subsystem(ctrl);
 	case NVME_IOCTL_RESCAN:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		nvme_queue_scan(ctrl);
 		return 0;
 	default:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 81a5b968253f..17c0d6ae3eee 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -422,11 +422,23 @@ static inline void nvme_fault_inject_fini(struct nvme_fault_inject *fault_inj)
 static inline void nvme_should_fail(struct request *req) {}
 #endif
 
+bool nvme_wait_reset(struct nvme_ctrl *ctrl);
+int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
+
 static inline int nvme_reset_subsystem(struct nvme_ctrl *ctrl)
 {
+	int ret;
+
 	if (!ctrl->subsystem)
 		return -ENOTTY;
-	return ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (!nvme_wait_reset(ctrl))
+		return -EBUSY;
+
+	ret = ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (ret)
+		return ret;
+
+	return nvme_try_sched_reset(ctrl);
 }
 
 /*
@@ -473,7 +485,6 @@ void nvme_cancel_tagset(struct nvme_ctrl *ctrl);
 void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
-bool nvme_wait_reset(struct nvme_ctrl *ctrl);
 int nvme_disable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_enable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_shutdown_ctrl(struct nvme_ctrl *ctrl);
@@ -525,7 +536,6 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl_sync(struct nvme_ctrl *ctrl);
-int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
 int nvme_delete_ctrl(struct nvme_ctrl *ctrl);
 
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp,
diff --git a/drivers/of/property.c b/drivers/of/property.c
index d7fa75e31f22..f6010ec0f67b 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -918,8 +918,10 @@ of_fwnode_get_reference_args(const struct fwnode_handle *fwnode,
 						       nargs, index, &of_args);
 	if (ret < 0)
 		return ret;
-	if (!args)
+	if (!args) {
+		of_node_put(of_args.np);
 		return 0;
+	}
 
 	args->nargs = of_args.args_count;
 	args->fwnode = of_fwnode_handle(of_args.np);
diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 4e89bbf6b76a..e0cb76f7e540 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -459,9 +459,14 @@ static void __intel_gpio_set_direction(void __iomem *padcfg0, bool input)
 	writel(value, padcfg0);
 }
 
+static int __intel_gpio_get_gpio_mode(u32 value)
+{
+	return (value & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+}
+
 static int intel_gpio_get_gpio_mode(void __iomem *padcfg0)
 {
-	return (readl(padcfg0) & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+	return __intel_gpio_get_gpio_mode(readl(padcfg0));
 }
 
 static void intel_gpio_set_gpio_mode(void __iomem *padcfg0)
@@ -1508,6 +1513,7 @@ EXPORT_SYMBOL_GPL(intel_pinctrl_probe_by_uid);
 static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
+	u32 value;
 
 	if (!pd || !intel_pad_usable(pctrl, pin))
 		return false;
@@ -1522,6 +1528,25 @@ static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int
 	    gpiochip_line_is_irq(&pctrl->chip, intel_pin_to_gpio(pctrl, pin)))
 		return true;
 
+	/*
+	 * The firmware on some systems may configure GPIO pins to be
+	 * an interrupt source in so called "direct IRQ" mode. In such
+	 * cases the GPIO controller driver has no idea if those pins
+	 * are being used or not. At the same time, there is a known bug
+	 * in the firmwares that don't restore the pin settings correctly
+	 * after suspend, i.e. by an unknown reason the Rx value becomes
+	 * inverted.
+	 *
+	 * Hence, let's save and restore the pins that are configured
+	 * as GPIOs in the input mode with GPIROUTIOXAPIC bit set.
+	 *
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=214749.
+	 */
+	value = readl(intel_get_padcfg(pctrl, pin, PADCFG0));
+	if ((value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
+	    (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO))
+		return true;
+
 	return false;
 }
 
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index fb1c8965cb99..20c89023d312 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -703,7 +703,7 @@ static int pcs_allocate_pin_table(struct pcs_device *pcs)
 
 	mux_bytes = pcs->width / BITS_PER_BYTE;
 
-	if (pcs->bits_per_mux) {
+	if (pcs->bits_per_mux && pcs->fmask) {
 		pcs->bits_per_pin = fls(pcs->fmask);
 		nr_pins = (pcs->size * BITS_PER_BYTE) / pcs->bits_per_pin;
 		num_pins_in_register = pcs->width / pcs->bits_per_pin;
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index e88bd54ff8bd..d6c4cd4262df 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -536,6 +536,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
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
index ed83fb135bab..761cab698c75 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1195,6 +1195,8 @@ static void asus_wmi_set_xusb2pr(struct asus_wmi *asus)
 	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
 				cpu_to_le32(ports_available));
 
+	pci_dev_put(xhci_pdev);
+
 	pr_info("set USB_INTEL_XUSB2PR old: 0x%04x, new: 0x%04x\n",
 			orig_ports_available, ports_available);
 }
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index a67773eca3ac..d3a329b201b1 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -63,6 +63,7 @@ enum hp_wmi_event_ids {
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
 	HPWMI_SANITIZATION_MODE		= 0x17,
+	HPWMI_SMART_EXPERIENCE_APP	= 0x21,
 };
 
 struct bios_args {
@@ -632,6 +633,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		break;
 	case HPWMI_SANITIZATION_MODE:
 		break;
+	case HPWMI_SMART_EXPERIENCE_APP:
+		break;
 	default:
 		pr_info("Unknown event_id - %d - 0x%x\n", event_id, event_data);
 		break;
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6ba3f6e7ea4f..7d15312d6792 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4802,6 +4802,7 @@ static void regulator_dev_release(struct device *dev)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
+	debugfs_remove_recursive(rdev->debugfs);
 	kfree(rdev->constraints);
 	of_node_put(rdev->dev.of_node);
 	kfree(rdev);
@@ -5269,11 +5270,15 @@ regulator_register(const struct regulator_desc *regulator_desc,
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
@@ -5302,7 +5307,6 @@ void regulator_unregister(struct regulator_dev *rdev)
 
 	mutex_lock(&regulator_list_mutex);
 
-	debugfs_remove_recursive(rdev->debugfs);
 	WARN_ON(rdev->open_count);
 	regulator_remove_coupling(rdev);
 	unset_regulator_supplies(rdev);
diff --git a/drivers/regulator/twl6030-regulator.c b/drivers/regulator/twl6030-regulator.c
index b8100c3cedad..4ffb32ffec35 100644
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
index 7749deb614d7..53d22975a32f 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -4627,7 +4627,6 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_raw(struct dasd_device *startdev,
 	struct dasd_device *basedev;
 	struct req_iterator iter;
 	struct dasd_ccw_req *cqr;
-	unsigned int first_offs;
 	unsigned int trkcount;
 	unsigned long *idaws;
 	unsigned int size;
@@ -4661,7 +4660,6 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_raw(struct dasd_device *startdev,
 	last_trk = (blk_rq_pos(req) + blk_rq_sectors(req) - 1) /
 		DASD_RAW_SECTORS_PER_TRACK;
 	trkcount = last_trk - first_trk + 1;
-	first_offs = 0;
 
 	if (rq_data_dir(req) == READ)
 		cmd = DASD_ECKD_CCW_READ_TRACK;
@@ -4705,13 +4703,13 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_raw(struct dasd_device *startdev,
 
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
 
diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 474d5a7fa95e..9d593675257e 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -431,8 +431,7 @@ static unsigned int mx51_ecspi_clkdiv(struct spi_imx_data *spi_imx,
 	unsigned int pre, post;
 	unsigned int fin = spi_imx->spi_clk;
 
-	if (unlikely(fspi > fin))
-		return 0;
+	fspi = min(fspi, fin);
 
 	post = fls(fin) - fls(fspi);
 	if (fin > fspi << post)
diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index a1961a973839..e843e9453c71 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -444,7 +444,7 @@ static int stm32_spi_prepare_mbr(struct stm32_spi *spi, u32 speed_hz,
 	u32 div, mbrdiv;
 
 	/* Ensure spi->clk_rate is even */
-	div = DIV_ROUND_UP(spi->clk_rate & ~0x1, speed_hz);
+	div = DIV_ROUND_CLOSEST(spi->clk_rate & ~0x1, speed_hz);
 
 	/*
 	 * SPI framework set xfer->speed_hz to master->max_speed_hz if
diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
index acff7dd677d6..71c491cbb0c5 100644
--- a/drivers/tee/optee/device.c
+++ b/drivers/tee/optee/device.c
@@ -89,7 +89,7 @@ static int optee_register_device(const uuid_t *device_uuid, u32 device_id)
 	rc = device_register(&optee_device->dev);
 	if (rc) {
 		pr_err("device registration failed, err: %d\n", rc);
-		kfree(optee_device);
+		put_device(&optee_device->dev);
 	}
 
 	return rc;
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 3d6a159c87f4..928b35b87dcf 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -251,6 +251,7 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 {
 	struct omap8250_priv *priv = up->port.private_data;
 	struct uart_8250_dma	*dma = up->dma;
+	u8 mcr = serial8250_in_MCR(up);
 
 	if (dma && dma->tx_running) {
 		/*
@@ -267,7 +268,7 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	serial_out(up, UART_EFR, UART_EFR_ECB);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
-	serial8250_out_MCR(up, UART_MCR_TCRTLR);
+	serial8250_out_MCR(up, mcr | UART_MCR_TCRTLR);
 	serial_out(up, UART_FCR, up->fcr);
 
 	omap8250_update_scr(up, priv);
@@ -283,7 +284,8 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	serial_out(up, UART_LCR, 0);
 
 	/* drop TCR + TLR access, we setup XON/XOFF later */
-	serial8250_out_MCR(up, up->mcr);
+	serial8250_out_MCR(up, mcr);
+
 	serial_out(up, UART_IER, up->ier);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
@@ -594,7 +596,6 @@ static int omap_8250_startup(struct uart_port *port)
 
 	pm_runtime_get_sync(port->dev);
 
-	up->mcr = 0;
 	serial_out(up, UART_FCR, UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
 
 	serial_out(up, UART_LCR, UART_LCR_WLEN8);
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index c1e9ea621f41..c594e3ebdbfe 100644
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
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index c45646450135..e1cb277a9e16 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -137,7 +137,7 @@ static int platform_pci_probe(struct pci_dev *pdev,
 		if (ret) {
 			dev_warn(&pdev->dev, "Unable to set the evtchn callback "
 					 "err=%d\n", ret);
-			goto out;
+			goto irq_out;
 		}
 	}
 
@@ -145,13 +145,16 @@ static int platform_pci_probe(struct pci_dev *pdev,
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
diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index 51ee3dd79700..e9282e025912 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -92,8 +92,8 @@ void afs_fileserver_probe_result(struct afs_call *call)
 		}
 	}
 
-	if (rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us) &&
-	    rtt_us < server->probe.rtt) {
+	rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us);
+	if (rtt_us < server->probe.rtt) {
 		server->probe.rtt = rtt_us;
 		alist->preferred = index;
 		have_result = true;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 675112aa998f..8553bd4361dd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2824,6 +2824,8 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
 		}
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
 		ret = -EFAULT;
 
@@ -2914,6 +2916,8 @@ static int btrfs_ioctl_get_subvol_rootref(struct file *file, void __user *argp)
 	}
 
 out:
+	btrfs_free_path(path);
+
 	if (!ret || ret == -EOVERFLOW) {
 		rootrefs->num_items = found;
 		/* update min_treeid for next search */
@@ -2925,7 +2929,6 @@ static int btrfs_ioctl_get_subvol_rootref(struct file *file, void __user *argp)
 	}
 
 	kfree(rootrefs);
-	btrfs_free_path(path);
 
 	return ret;
 }
@@ -4515,6 +4518,8 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 		ipath->fspath->val[i] = rel_ptr;
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	ret = copy_to_user((void __user *)(unsigned long)ipa->fspath,
 			   ipath->fspath, size);
 	if (ret) {
@@ -4585,21 +4590,20 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		size = min_t(u32, loi->size, SZ_16M);
 	}
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
-		inodes = NULL;
-		goto out;
+		goto out_loi;
 	}
 
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
 					  build_ino_list, inodes, ignore_offset);
+	btrfs_free_path(path);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
@@ -4611,7 +4615,6 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		ret = -EFAULT;
 
 out:
-	btrfs_free_path(path);
 	kvfree(inodes);
 out_loi:
 	kfree(loi);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 84a102347490..5c8507e74bc1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2824,14 +2824,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
 		dstgroup->rsv_excl = inherit->lim.rsv_excl;
 
-		ret = update_qgroup_limit_item(trans, dstgroup);
-		if (ret) {
-			fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-			btrfs_info(fs_info,
-				   "unable to update quota limit for %llu",
-				   dstgroup->qgroupid);
-			goto unlock;
-		}
+		qgroup_dirty(fs_info, dstgroup);
 	}
 
 	if (srcid) {
@@ -3203,7 +3196,8 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
 static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
 {
 	return btrfs_fs_closing(fs_info) ||
-		test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
+		test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state) ||
+		!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 }
 
 static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
@@ -3233,11 +3227,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			err = PTR_ERR(trans);
 			break;
 		}
-		if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
-			err = -EINTR;
-		} else {
-			err = qgroup_rescan_leaf(trans, path);
-		}
+
+		err = qgroup_rescan_leaf(trans, path);
+
 		if (err > 0)
 			btrfs_commit_transaction(trans);
 		else
@@ -3251,7 +3243,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	if (err > 0 &&
 	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-	} else if (err < 0) {
+	} else if (err < 0 || stopped) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	}
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 5c299e1f2297..356f2274c8eb 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1154,8 +1154,11 @@ int __init btrfs_init_sysfs(void)
 
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
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index e1b9b224fcb2..97ce1bd13bad 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -694,9 +694,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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
 
@@ -704,6 +705,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
+	realm = NULL;
+	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
 	p += sizeof(*ri);
@@ -727,7 +730,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	err = adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
 	if (err < 0)
 		goto fail;
-	invalidate += err;
+	rebuild_snapcs += err;
 
 	if (le64_to_cpu(ri->seq) > realm->seq) {
 		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
@@ -752,22 +755,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 7e11135bc915..877f9f61a4e8 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1905,53 +1905,67 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		init_wait(&wait);
 		wait.func = ep_autoremove_wake_function;
 		write_lock_irq(&ep->lock);
-		__add_wait_queue_exclusive(&ep->wq, &wait);
-		write_unlock_irq(&ep->lock);
-
 		/*
-		 * We don't want to sleep if the ep_poll_callback() sends us
-		 * a wakeup in between. That's why we set the task state
-		 * to TASK_INTERRUPTIBLE before doing the checks.
+		 * Barrierless variant, waitqueue_active() is called under
+		 * the same lock on wakeup ep_poll_callback() side, so it
+		 * is safe to avoid an explicit barrier.
 		 */
-		set_current_state(TASK_INTERRUPTIBLE);
+		__set_current_state(TASK_INTERRUPTIBLE);
+
 		/*
-		 * Always short-circuit for fatal signals to allow
-		 * threads to make a timely exit without the chance of
-		 * finding more events available and fetching
-		 * repeatedly.
+		 * Do the final check under the lock. ep_scan_ready_list()
+		 * plays with two lists (->rdllist and ->ovflist) and there
+		 * is always a race when both lists are empty for short
+		 * period of time although events are pending, so lock is
+		 * important.
 		 */
-		if (fatal_signal_pending(current)) {
-			res = -EINTR;
-			break;
-		}
-
 		eavail = ep_events_available(ep);
-		if (eavail)
-			break;
-		if (signal_pending(current)) {
-			res = -EINTR;
-			break;
+		if (!eavail) {
+			if (signal_pending(current))
+				res = -EINTR;
+			else
+				__add_wait_queue_exclusive(&ep->wq, &wait);
 		}
+		write_unlock_irq(&ep->lock);
 
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
-			timed_out = 1;
-			break;
-		}
+		if (!eavail && !res)
+			timed_out = !schedule_hrtimeout_range(to, slack,
+							      HRTIMER_MODE_ABS);
 
-		/* We were woken up, thus go and try to harvest some events */
+		/*
+		 * We were woken up, thus go and try to harvest some events.
+		 * If timed out and still on the wait queue, recheck eavail
+		 * carefully under lock, below.
+		 */
 		eavail = 1;
-
 	} while (0);
 
 	__set_current_state(TASK_RUNNING);
 
 	if (!list_empty_careful(&wait.entry)) {
 		write_lock_irq(&ep->lock);
+		/*
+		 * If the thread timed out and is not on the wait queue, it
+		 * means that the thread was woken up after its timeout expired
+		 * before it could reacquire the lock. Thus, when wait.entry is
+		 * empty, it needs to harvest events.
+		 */
+		if (timed_out)
+			eavail = list_empty(&wait.entry);
 		__remove_wait_queue(&ep->wq, &wait);
 		write_unlock_irq(&ep->lock);
 	}
 
 send_events:
+	if (fatal_signal_pending(current)) {
+		/*
+		 * Always short-circuit for fatal signals to allow
+		 * threads to make a timely exit without the chance of
+		 * finding more events available and fetching
+		 * repeatedly.
+		 */
+		res = -EINTR;
+	}
 	/*
 	 * Try to transfer events to user space. In case we get 0 events and
 	 * there's still timeout left over, we go trying again in search of
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 8c799250ff39..74e8fdc85f82 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3212,24 +3212,19 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		.mode = mode
 	};
 	int err;
-	bool lock_inode = !(mode & FALLOC_FL_KEEP_SIZE) ||
-			   (mode & FALLOC_FL_PUNCH_HOLE);
-
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
 	if (fc->no_fallocate)
 		return -EOPNOTSUPP;
 
-	if (lock_inode) {
-		inode_lock(inode);
-		if (mode & FALLOC_FL_PUNCH_HOLE) {
-			loff_t endbyte = offset + length - 1;
+	inode_lock(inode);
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
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
@@ -3276,8 +3271,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
-	if (lock_inode)
-		inode_unlock(inode);
+	inode_unlock(inode);
 
 	return err;
 }
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index a3523a243e11..e2a5320f2718 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -111,6 +111,13 @@ static void nilfs_dat_commit_free(struct inode *dat,
 	kunmap_atomic(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
+
+	if (unlikely(req->pr_desc_bh == NULL || req->pr_bitmap_bh == NULL)) {
+		nilfs_error(dat->i_sb,
+			    "state inconsistency probably due to duplicate use of vblocknr = %llu",
+			    (unsigned long long)req->pr_entry_nr);
+		return;
+	}
 	nilfs_palloc_commit_free_entry(dat, req);
 }
 
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index bf3f8f05c89b..150845a43225 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -498,14 +498,22 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
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
 
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 897a87c4c827..77192c3fc544 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -434,7 +434,7 @@ static inline bool mmc_op_multi(u32 opcode)
 #define MMC_SECURE_TRIM1_ARG		0x80000001
 #define MMC_SECURE_TRIM2_ARG		0x80008000
 #define MMC_SECURE_ARGS			0x80000000
-#define MMC_TRIM_ARGS			0x00008001
+#define MMC_TRIM_OR_DISCARD_ARGS	0x00008003
 
 #define mmc_driver_type_mask(n)		(1 << (n))
 
diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 5d0767cb424a..4ed52879ce55 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -38,7 +38,7 @@ void dump_mm(const struct mm_struct *mm);
 		}							\
 	} while (0)
 #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
-	static bool __section(".data.once") __warned;			\
+	static bool __section(.data.once) __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
 	if (unlikely(__ret_warn_once && !__warned)) {			\
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 1a40277b512c..b73950772299 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -99,7 +99,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 
 int ring_buffer_wait(struct ring_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table);
+			  struct file *filp, poll_table *poll_table, int full);
 
 
 #define RING_BUFFER_ALL_CPUS -1
diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index 01a70b27e026..65058faea4db 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -26,6 +26,8 @@ struct sctp_sched_ops {
 	int (*init)(struct sctp_stream *stream);
 	/* Init a stream */
 	int (*init_sid)(struct sctp_stream *stream, __u16 sid, gfp_t gfp);
+	/* free a stream */
+	void (*free_sid)(struct sctp_stream *stream, __u16 sid);
 	/* Frees the entire thing */
 	void (*free)(struct sctp_stream *stream);
 
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index c89c6495983d..a79f8c285a10 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -179,7 +179,7 @@
 #define AUDIT_MAX_KEY_LEN  256
 #define AUDIT_BITMASK_SIZE 64
 #define AUDIT_WORD(nr) ((__u32)((nr)/32))
-#define AUDIT_BIT(nr)  (1 << ((nr) - AUDIT_WORD(nr)*32))
+#define AUDIT_BIT(nr)  (1U << ((nr) - AUDIT_WORD(nr)*32))
 
 #define AUDIT_SYSCALL_CLASSES 16
 #define AUDIT_CLASS_DIR_WRITE 0
diff --git a/init/Kconfig b/init/Kconfig
index 74f44b753d61..f641518f4ac5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -36,7 +36,7 @@ config CC_HAS_ASM_GOTO
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	depends on CC_HAS_ASM_GOTO_OUTPUT
 	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
-	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
+	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
 
 config CC_HAS_ASM_GOTO_OUTPUT
 	depends on CC_HAS_ASM_GOTO
diff --git a/ipc/sem.c b/ipc/sem.c
index bd907ed2ce00..31cfe0f5fa8d 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2171,6 +2171,7 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
 		 * scenarios where we were awakened externally, during the
 		 * window between wake_q_add() and wake_up_q().
 		 */
+		rcu_read_lock();
 		error = READ_ONCE(queue.status);
 		if (error != -EINTR) {
 			/*
@@ -2180,10 +2181,10 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
 			 * overwritten by the previous owner of the semaphore.
 			 */
 			smp_mb();
+			rcu_read_unlock();
 			goto out_free;
 		}
 
-		rcu_read_lock();
 		locknum = sem_lock(sma, sops, nsops);
 
 		if (!ipc_valid_object(&sma->sem_perm))
diff --git a/kernel/gcov/clang.c b/kernel/gcov/clang.c
index c466c7fbdece..ea6b45d0fa0d 100644
--- a/kernel/gcov/clang.c
+++ b/kernel/gcov/clang.c
@@ -327,6 +327,8 @@ void gcov_info_add(struct gcov_info *dst, struct gcov_info *src)
 
 		for (i = 0; i < sfn_ptr->num_counters; i++)
 			dfn_ptr->counters[i] += sfn_ptr->counters[i];
+
+		sfn_ptr = list_next_entry(sfn_ptr, head);
 	}
 }
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6f971807bf79..decabf5714c0 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2156,13 +2156,14 @@ int proc_dostring(struct ctl_table *table, int write,
 			       (char __user *)buffer, lenp, ppos);
 }
 
-static size_t proc_skip_spaces(char **buf)
+static void proc_skip_spaces(char **buf, size_t *size)
 {
-	size_t ret;
-	char *tmp = skip_spaces(*buf);
-	ret = tmp - *buf;
-	*buf = tmp;
-	return ret;
+	while (*size) {
+		if (!isspace(**buf))
+			break;
+		(*size)--;
+		(*buf)++;
+	}
 }
 
 static void proc_skip_char(char **buf, size_t *size, const char v)
@@ -2231,13 +2232,12 @@ static int proc_get_long(char **buf, size_t *size,
 			  unsigned long *val, bool *neg,
 			  const char *perm_tr, unsigned perm_tr_len, char *tr)
 {
-	int len;
 	char *p, tmp[TMPBUFLEN];
+	ssize_t len = *size;
 
-	if (!*size)
+	if (len <= 0)
 		return -EINVAL;
 
-	len = *size;
 	if (len > TMPBUFLEN - 1)
 		len = TMPBUFLEN - 1;
 
@@ -2400,7 +2400,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		bool neg;
 
 		if (write) {
-			left -= proc_skip_spaces(&p);
+			proc_skip_spaces(&p, &left);
 
 			if (!left)
 				break;
@@ -2431,7 +2431,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 	if (!write && !first && left && !err)
 		err = proc_put_char(&buffer, &left, '\n');
 	if (write && !err && left)
-		left -= proc_skip_spaces(&p);
+		proc_skip_spaces(&p, &left);
 	if (write) {
 		kfree(kbuf);
 		if (first)
@@ -2480,7 +2480,7 @@ static int do_proc_douintvec_w(unsigned int *tbl_data,
 	if (IS_ERR(kbuf))
 		return -EINVAL;
 
-	left -= proc_skip_spaces(&p);
+	proc_skip_spaces(&p, &left);
 	if (!left) {
 		err = -EINVAL;
 		goto out_free;
@@ -2500,7 +2500,7 @@ static int do_proc_douintvec_w(unsigned int *tbl_data,
 	}
 
 	if (!err && left)
-		left -= proc_skip_spaces(&p);
+		proc_skip_spaces(&p, &left);
 
 out_free:
 	kfree(kbuf);
@@ -2914,7 +2914,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 		if (write) {
 			bool neg;
 
-			left -= proc_skip_spaces(&p);
+			proc_skip_spaces(&p, &left);
 			if (!left)
 				break;
 
@@ -2947,7 +2947,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 	if (!write && !first && left && !err)
 		err = proc_put_char(&buffer, &left, '\n');
 	if (write && !err)
-		left -= proc_skip_spaces(&p);
+		proc_skip_spaces(&p, &left);
 	if (write) {
 		kfree(kbuf);
 		if (first)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c4234430afea..176d858903bd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -566,6 +566,21 @@ size_t ring_buffer_nr_dirty_pages(struct ring_buffer *buffer, int cpu)
 	return cnt - read;
 }
 
+static __always_inline bool full_hit(struct ring_buffer *buffer, int cpu, int full)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	size_t nr_pages;
+	size_t dirty;
+
+	nr_pages = cpu_buffer->nr_pages;
+	if (!nr_pages || !full)
+		return true;
+
+	dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
+
+	return (dirty * 100) > (full * nr_pages);
+}
+
 /*
  * rb_wake_up_waiters - wake up tasks waiting for ring buffer input
  *
@@ -661,22 +676,20 @@ int ring_buffer_wait(struct ring_buffer *buffer, int cpu, int full)
 		    !ring_buffer_empty_cpu(buffer, cpu)) {
 			unsigned long flags;
 			bool pagebusy;
-			size_t nr_pages;
-			size_t dirty;
+			bool done;
 
 			if (!full)
 				break;
 
 			raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 			pagebusy = cpu_buffer->reader_page == cpu_buffer->commit_page;
-			nr_pages = cpu_buffer->nr_pages;
-			dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
+			done = !pagebusy && full_hit(buffer, cpu, full);
+
 			if (!cpu_buffer->shortest_full ||
 			    cpu_buffer->shortest_full > full)
 				cpu_buffer->shortest_full = full;
 			raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-			if (!pagebusy &&
-			    (!nr_pages || (dirty * 100) > full * nr_pages))
+			if (done)
 				break;
 		}
 
@@ -697,6 +710,7 @@ int ring_buffer_wait(struct ring_buffer *buffer, int cpu, int full)
  * @cpu: the cpu buffer to wait on
  * @filp: the file descriptor
  * @poll_table: The poll descriptor
+ * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
  *
  * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
  * as data is added to any of the @buffer's cpu buffers. Otherwise
@@ -706,14 +720,14 @@ int ring_buffer_wait(struct ring_buffer *buffer, int cpu, int full)
  * zero otherwise.
  */
 __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table)
+			  struct file *filp, poll_table *poll_table, int full)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct rb_irq_work *work;
 
-	if (cpu == RING_BUFFER_ALL_CPUS)
+	if (cpu == RING_BUFFER_ALL_CPUS) {
 		work = &buffer->irq_work;
-	else {
+	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
 			return -EINVAL;
 
@@ -721,8 +735,14 @@ __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
 		work = &cpu_buffer->irq_work;
 	}
 
-	poll_wait(filp, &work->waiters, poll_table);
-	work->waiters_pending = true;
+	if (full) {
+		poll_wait(filp, &work->full_waiters, poll_table);
+		work->full_waiters_pending = true;
+	} else {
+		poll_wait(filp, &work->waiters, poll_table);
+		work->waiters_pending = true;
+	}
+
 	/*
 	 * There's a tight race between setting the waiters_pending and
 	 * checking if the ring buffer is empty.  Once the waiters_pending bit
@@ -738,6 +758,9 @@ __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
 	 */
 	smp_mb();
 
+	if (full)
+		return full_hit(buffer, cpu, full) ? EPOLLIN | EPOLLRDNORM : 0;
+
 	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
 	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
 		return EPOLLIN | EPOLLRDNORM;
@@ -2640,10 +2663,6 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 static __always_inline void
 rb_wakeups(struct ring_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 {
-	size_t nr_pages;
-	size_t dirty;
-	size_t full;
-
 	if (buffer->irq_work.waiters_pending) {
 		buffer->irq_work.waiters_pending = false;
 		/* irq_work_queue() supplies it's own memory barriers */
@@ -2667,10 +2686,7 @@ rb_wakeups(struct ring_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 
 	cpu_buffer->last_pages_touch = local_read(&cpu_buffer->pages_touched);
 
-	full = cpu_buffer->shortest_full;
-	nr_pages = cpu_buffer->nr_pages;
-	dirty = ring_buffer_nr_dirty_pages(buffer, cpu_buffer->cpu);
-	if (full && nr_pages && (dirty * 100) <= full * nr_pages)
+	if (!full_hit(buffer, cpu_buffer->cpu, cpu_buffer->shortest_full))
 		return;
 
 	cpu_buffer->irq_work.wakeup_full = true;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 62fd8798b0c4..42f45665e059 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5993,7 +5993,7 @@ trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_tabl
 		return EPOLLIN | EPOLLRDNORM;
 	else
 		return ring_buffer_poll_wait(iter->trace_buffer->buffer, iter->cpu_file,
-					     filp, poll_table);
+					     filp, poll_table, iter->tr->buffer_percent);
 }
 
 static __poll_t
diff --git a/kernel/trace/trace_dynevent.c b/kernel/trace/trace_dynevent.c
index 89779eb84a07..2dafeab6a270 100644
--- a/kernel/trace/trace_dynevent.c
+++ b/kernel/trace/trace_dynevent.c
@@ -70,6 +70,7 @@ int dyn_event_release(int argc, char **argv, struct dyn_event_operations *type)
 		if (ret)
 			break;
 	}
+	tracing_reset_all_online_cpus();
 	mutex_unlock(&event_mutex);
 
 	return ret;
@@ -165,6 +166,7 @@ int dyn_events_release_all(struct dyn_event_operations *type)
 			break;
 	}
 out:
+	tracing_reset_all_online_cpus();
 	mutex_unlock(&event_mutex);
 
 	return ret;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 047a89b815a3..8f2cbc9ebb6e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2351,7 +2351,10 @@ static int probe_remove_event_call(struct trace_event_call *call)
 		 * TRACE_REG_UNREGISTER.
 		 */
 		if (file->flags & EVENT_FILE_FL_ENABLED)
-			return -EBUSY;
+			goto busy;
+
+		if (file->flags & EVENT_FILE_FL_WAS_ENABLED)
+			tr->clear_trace = true;
 		/*
 		 * The do_for_each_event_file_safe() is
 		 * a double loop. After finding the call for this
@@ -2364,6 +2367,12 @@ static int probe_remove_event_call(struct trace_event_call *call)
 	__trace_remove_event_call(call);
 
 	return 0;
+ busy:
+	/* No need to clear the trace now */
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		tr->clear_trace = false;
+	}
+	return -EBUSY;
 }
 
 /* Remove an event_call */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dd7044aa1a12..6d79e7c3219c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -253,8 +253,10 @@ config FRAME_WARN
 	int "Warn for stack frames larger than (needs gcc 4.4)"
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1280 if (!64BIT && PARISC)
-	default 1024 if (!64BIT && !PARISC)
+	default 2048 if PARISC
+	default 1536 if (!64BIT && XTENSA)
+	default 1280 if KASAN && !64BIT
+	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
 	  Tell gcc to warn at build time for stack frames larger than this.
@@ -1525,8 +1527,14 @@ config NETDEV_NOTIFIER_ERROR_INJECT
 	  If unsure, say N.
 
 config FUNCTION_ERROR_INJECTION
-	def_bool y
+	bool "Fault-injections of functions"
 	depends on HAVE_FUNCTION_ERROR_INJECTION && KPROBES
+	help
+	  Add fault injections into various functions that are annotated with
+	  ALLOW_ERROR_INJECTION() in the kernel. BPF may also modify the return
+	  value of theses functions. This is useful to test error paths of code.
+
+	  If unsure, say N
 
 config FAULT_INJECTION
 	bool "Fault-injection framework"
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
diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index c431ca81dad5..5779c1bc6f44 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -37,7 +37,6 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int ret = 0;
-	int err;
 	int locked;
 
 	if (nr_frames == 0)
@@ -74,32 +73,14 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 		vec->is_pfns = false;
 		ret = get_user_pages_locked(start, nr_frames,
 			gup_flags, (struct page **)(vec->ptrs), &locked);
-		goto out;
+		if (likely(ret > 0))
+			goto out;
 	}
 
-	vec->got_ref = false;
-	vec->is_pfns = true;
-	do {
-		unsigned long *nums = frame_vector_pfns(vec);
-
-		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
-			err = follow_pfn(vma, start, &nums[ret]);
-			if (err) {
-				if (ret == 0)
-					ret = err;
-				goto out;
-			}
-			start += PAGE_SIZE;
-			ret++;
-		}
-		/*
-		 * We stop if we have enough pages or if VMA doesn't completely
-		 * cover the tail page.
-		 */
-		if (ret >= nr_frames || start < vma->vm_end)
-			break;
-		vma = find_vma_intersection(mm, start, start + 1);
-	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
+	/* This used to (racily) return non-refcounted pfns. Let people know */
+	WARN_ONCE(1, "get_vaddr_frames() cannot follow VM_IO mapping");
+	vec->nr_frames = 0;
+
 out:
 	if (locked)
 		up_read(&mm->mmap_sem);
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index b691871d9a02..23c1d78ab1e4 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -200,9 +200,11 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 
 	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 
 	spin_unlock(&m->client->lock);
@@ -850,8 +852,10 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
 	struct file *file;
 
 	p = kzalloc(sizeof(struct p9_trans_fd), GFP_KERNEL);
-	if (!p)
+	if (!p) {
+		sock_release(csocket);
 		return -ENOMEM;
+	}
 
 	csocket->sk->sk_allocation = GFP_NOIO;
 	file = sock_alloc_file(csocket, 0, NULL);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index afa7fc55555e..fb2abd0e979a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5571,6 +5571,19 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 	BT_DBG("psm 0x%2.2x scid 0x%4.4x mtu %u mps %u", __le16_to_cpu(psm),
 	       scid, mtu, mps);
 
+	/* BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 3, Part A
+	 * page 1059:
+	 *
+	 * Valid range: 0x0001-0x00ff
+	 *
+	 * Table 4.15: L2CAP_LE_CREDIT_BASED_CONNECTION_REQ SPSM ranges
+	 */
+	if (!psm || __le16_to_cpu(psm) > L2CAP_PSM_LE_DYN_END) {
+		result = L2CAP_CR_LE_BAD_PSM;
+		chan = NULL;
+		goto response;
+	}
+
 	/* Check if we have socket listening on psm */
 	pchan = l2cap_global_chan_by_psm(BT_LISTEN, psm, &conn->hcon->src,
 					 &conn->hcon->dst, LE_LINK);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 7cf903f9e29a..cd59a669b8a7 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -130,6 +130,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * This unhashes the socket and releases the local port, if necessary.
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 7c24927e9c2c..1bf267d36a9c 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -957,6 +957,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index bf3ecf792688..7073724fdfa6 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -198,17 +198,18 @@ static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
 			       struct hsr_node *node_src)
 {
 	bool was_multicast_frame;
-	int res;
+	int res, recv_len;
 
 	was_multicast_frame = (skb->pkt_type == PACKET_MULTICAST);
 	hsr_addr_subst_source(node_src, skb);
 	skb_pull(skb, ETH_HLEN);
+	recv_len = skb->len;
 	res = netif_rx(skb);
 	if (res == NET_RX_DROP) {
 		dev->stats.rx_dropped++;
 	} else {
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += recv_len;
 		if (was_multicast_frame)
 			dev->stats.multicast++;
 	}
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index a926de2e42b5..f5af8c6b2f87 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -389,6 +389,16 @@ config INET_IPCOMP
 
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
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 28da0443f3e9..908913d75847 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -875,13 +875,15 @@ int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 	}
 
+	if (fi->nh) {
+		if (cfg->fc_oif || cfg->fc_gw_family || cfg->fc_mp)
+			return 1;
+		return 0;
+	}
+
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh;
 
-		/* cannot match on nexthop object attributes */
-		if (fi->nh)
-			return 1;
-
 		nh = fib_info_nh(fi, 0);
 		if (cfg->fc_encap) {
 			if (fib_encap_match(cfg->fc_encap_type, cfg->fc_encap,
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index bd3d9ad78e56..25334aa3da04 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -675,13 +675,13 @@ EXPORT_SYMBOL_GPL(inet_unhash);
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
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index eb9c05acf77e..a54505c29a5c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -323,6 +323,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * if necessary.
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 831f779aba7b..e84b79357b2f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -334,6 +334,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
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
index c06cc48c68c9..92f71e8f321c 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2909,7 +2909,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg) && aalg->available)
+		if (aalg_tmpl_set(t, aalg))
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2927,7 +2927,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
+		if (!(ealg_tmpl_set(t, ealg)))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2938,16 +2938,17 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
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
@@ -2975,13 +2976,17 @@ static void dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
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
@@ -3023,8 +3028,11 @@ static void dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
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
@@ -3154,6 +3162,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	struct sadb_x_sec_ctx *sec_ctx;
 	struct xfrm_sec_ctx *xfrm_ctx;
 	int ctx_size = 0;
+	int alg_size = 0;
 
 	sockaddr_size = pfkey_sockaddr_size(x->props.family);
 	if (!sockaddr_size)
@@ -3165,16 +3174,16 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
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
 
@@ -3228,10 +3237,13 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
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
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f215218a88c9..fa2ac02063cf 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1315,8 +1315,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
@@ -1386,8 +1388,10 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
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
index d7ae7415d54d..80a83d0d9550 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -720,7 +720,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
 			     struct sk_buff *skb)
 {
-	kfree_skb(skb);
+	ieee80211_free_txskb(&sdata->local->hw, skb);
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
 
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index b2e922fcc70d..57849baf9294 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -530,7 +530,7 @@ static int nci_open_device(struct nci_dev *ndev)
 		skb_queue_purge(&ndev->tx_q);
 
 		ndev->ops->close(ndev);
-		ndev->flags = 0;
+		ndev->flags &= BIT(NCI_UNREG);
 	}
 
 done:
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index b002e18f38c8..b4548d887489 100644
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
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8f5ef2841199..d76edafb4dff 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2222,8 +2222,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		status |= TP_STATUS_CSUMNOTREADY;
 	else if (skb->pkt_type != PACKET_OUTGOING &&
-		 (skb->ip_summed == CHECKSUM_COMPLETE ||
-		  skb_csum_unnecessary(skb)))
+		 skb_csum_unnecessary(skb))
 		status |= TP_STATUS_CSUM_VALID;
 
 	if (snaplen > res)
@@ -3451,8 +3450,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			aux.tp_status |= TP_STATUS_CSUMNOTREADY;
 		else if (skb->pkt_type != PACKET_OUTGOING &&
-			 (skb->ip_summed == CHECKSUM_COMPLETE ||
-			  skb_csum_unnecessary(skb)))
+			 skb_csum_unnecessary(skb))
 			aux.tp_status |= TP_STATUS_CSUM_VALID;
 
 		aux.tp_len = origlen;
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 56762745d6e4..ca8fdc9abca5 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -52,6 +52,19 @@ static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
 	}
 }
 
+static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_sched_ops *sched;
+
+	if (!SCTP_SO(stream, sid)->ext)
+		return;
+
+	sched = sctp_sched_ops_from_stream(stream);
+	sched->free_sid(stream, sid);
+	kfree(SCTP_SO(stream, sid)->ext);
+	SCTP_SO(stream, sid)->ext = NULL;
+}
+
 /* Migrates chunks from stream queues to new stream queues if needed,
  * but not across associations. Also, removes those chunks to streams
  * higher than the new max.
@@ -70,16 +83,14 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		 * sctp_stream_update will swap ->out pointers.
 		 */
 		for (i = 0; i < outcnt; i++) {
-			kfree(SCTP_SO(new, i)->ext);
+			sctp_stream_free_ext(new, i);
 			SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
 			SCTP_SO(stream, i)->ext = NULL;
 		}
 	}
 
-	for (i = outcnt; i < stream->outcnt; i++) {
-		kfree(SCTP_SO(stream, i)->ext);
-		SCTP_SO(stream, i)->ext = NULL;
-	}
+	for (i = outcnt; i < stream->outcnt; i++)
+		sctp_stream_free_ext(stream, i);
 }
 
 static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
@@ -174,9 +185,9 @@ void sctp_stream_free(struct sctp_stream *stream)
 	struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
 	int i;
 
-	sched->free(stream);
+	sched->unsched_all(stream);
 	for (i = 0; i < stream->outcnt; i++)
-		kfree(SCTP_SO(stream, i)->ext);
+		sctp_stream_free_ext(stream, i);
 	genradix_free(&stream->out);
 	genradix_free(&stream->in);
 }
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index a2e1d34f52c5..33c2630c2496 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -46,6 +46,10 @@ static int sctp_sched_fcfs_init_sid(struct sctp_stream *stream, __u16 sid,
 	return 0;
 }
 
+static void sctp_sched_fcfs_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+}
+
 static void sctp_sched_fcfs_free(struct sctp_stream *stream)
 {
 }
@@ -96,6 +100,7 @@ static struct sctp_sched_ops sctp_sched_fcfs = {
 	.get = sctp_sched_fcfs_get,
 	.init = sctp_sched_fcfs_init,
 	.init_sid = sctp_sched_fcfs_init_sid,
+	.free_sid = sctp_sched_fcfs_free_sid,
 	.free = sctp_sched_fcfs_free,
 	.enqueue = sctp_sched_fcfs_enqueue,
 	.dequeue = sctp_sched_fcfs_dequeue,
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 80b5a2c4cbc7..4fc9f2923ed1 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -204,6 +204,24 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 	return sctp_sched_prio_set(stream, sid, 0, gfp);
 }
 
+static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_stream_priorities *prio = SCTP_SO(stream, sid)->ext->prio_head;
+	int i;
+
+	if (!prio)
+		return;
+
+	SCTP_SO(stream, sid)->ext->prio_head = NULL;
+	for (i = 0; i < stream->outcnt; i++) {
+		if (SCTP_SO(stream, i)->ext &&
+		    SCTP_SO(stream, i)->ext->prio_head == prio)
+			return;
+	}
+
+	kfree(prio);
+}
+
 static void sctp_sched_prio_free(struct sctp_stream *stream)
 {
 	struct sctp_stream_priorities *prio, *n;
@@ -323,6 +341,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
 	.get = sctp_sched_prio_get,
 	.init = sctp_sched_prio_init,
 	.init_sid = sctp_sched_prio_init_sid,
+	.free_sid = sctp_sched_prio_free_sid,
 	.free = sctp_sched_prio_free,
 	.enqueue = sctp_sched_prio_enqueue,
 	.dequeue = sctp_sched_prio_dequeue,
diff --git a/net/sctp/stream_sched_rr.c b/net/sctp/stream_sched_rr.c
index ff425aed62c7..cc444fe0d67c 100644
--- a/net/sctp/stream_sched_rr.c
+++ b/net/sctp/stream_sched_rr.c
@@ -90,6 +90,10 @@ static int sctp_sched_rr_init_sid(struct sctp_stream *stream, __u16 sid,
 	return 0;
 }
 
+static void sctp_sched_rr_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+}
+
 static void sctp_sched_rr_free(struct sctp_stream *stream)
 {
 	sctp_sched_rr_unsched_all(stream);
@@ -177,6 +181,7 @@ static struct sctp_sched_ops sctp_sched_rr = {
 	.get = sctp_sched_rr_get,
 	.init = sctp_sched_rr_init,
 	.init_sid = sctp_sched_rr_init_sid,
+	.free_sid = sctp_sched_rr_free_sid,
 	.free = sctp_sched_rr_free,
 	.enqueue = sctp_sched_rr_enqueue,
 	.dequeue = sctp_sched_rr_dequeue,
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index 0006c9f87199..0436c8f2967d 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -208,7 +208,10 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
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
index 1c5319678f28..88e8e8d69b60 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -177,7 +177,7 @@ static void tipc_conn_close(struct tipc_conn *con)
 	conn_put(con);
 }
 
-static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
+static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s, struct socket *sock)
 {
 	struct tipc_conn *con;
 	int ret;
@@ -203,10 +203,12 @@ static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
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
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 630c64520516..c4c124cb5332 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -291,7 +291,8 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 			 * determine if they are the same ie.
 			 */
 			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
-				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
+				if (tmp_old[1] >= 5 && tmp[1] >= 5 &&
+				    !memcmp(tmp_old + 2, tmp + 2, 5)) {
 					/* same vendor ie, copy from
 					 * subelement
 					 */
diff --git a/scripts/faddr2line b/scripts/faddr2line
index 57099687e5e1..9e730b805e87 100755
--- a/scripts/faddr2line
+++ b/scripts/faddr2line
@@ -73,7 +73,8 @@ command -v ${ADDR2LINE} >/dev/null 2>&1 || die "${ADDR2LINE} isn't installed"
 find_dir_prefix() {
 	local objfile=$1
 
-	local start_kernel_addr=$(${READELF} --symbols --wide $objfile | ${AWK} '$8 == "start_kernel" {printf "0x%s", $2}')
+	local start_kernel_addr=$(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' |
+		${AWK} '$8 == "start_kernel" {printf "0x%s", $2}')
 	[[ -z $start_kernel_addr ]] && return
 
 	local file_line=$(${ADDR2LINE} -e $objfile $start_kernel_addr)
@@ -177,7 +178,7 @@ __faddr2line() {
 				found=2
 				break
 			fi
-		done < <(${READELF} --symbols --wide $objfile | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2)
+		done < <(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2)
 
 		if [[ $found = 0 ]]; then
 			warn "can't find symbol: sym_name: $sym_name sym_sec: $sym_sec sym_addr: $sym_addr sym_elf_size: $sym_elf_size"
@@ -258,7 +259,7 @@ __faddr2line() {
 
 		DONE=1
 
-	done < <(${READELF} --symbols --wide $objfile | ${AWK} -v fn=$sym_name '$4 == "FUNC" && $8 == fn')
+	done < <(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' | ${AWK} -v fn=$sym_name '$4 == "FUNC" && $8 == fn')
 }
 
 [[ $# -lt 2 ]] && usage
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 76d3c0681f37..d2dfc53e30ff 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1788,6 +1788,7 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 {
 	struct sgtl5000_priv *sgtl5000 = i2c_get_clientdata(client);
 
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_CLK_CTRL, SGTL5000_CHIP_CLK_CTRL_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_DIG_POWER, SGTL5000_DIG_POWER_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_ANA_POWER, SGTL5000_ANA_POWER_DEFAULT);
 
diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index ed332177b0f9..57d6d0b48068 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -446,6 +446,13 @@ static const struct dmi_system_id byt_cht_es8316_quirk_table[] = {
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
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 453b61b42dd9..2faf95d4bb75 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -445,7 +445,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.integer.value[0];
 	if (mc->platform_max && val > mc->platform_max)
 		return -EINVAL;
-	if (val > max - min)
+	if (val > max)
 		return -EINVAL;
 	if (val < 0)
 		return -EINVAL;
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 09830b88ec8c..0bdca3a2e673 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -583,6 +583,36 @@ ipv4_fcnal()
 	set +e
 	check_nexthop "dev veth1" ""
 	log_test $? 0 "Nexthops removed on admin down"
+
+	# nexthop route delete warning: route add with nhid and delete
+	# using device
+	run_cmd "$IP li set dev veth1 up"
+	run_cmd "$IP nexthop add id 12 via 172.16.1.3 dev veth1"
+	out1=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	run_cmd "$IP route add 172.16.101.1/32 nhid 12"
+	run_cmd "$IP route delete 172.16.101.1/32 dev veth1"
+	out2=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	[ $out1 -eq $out2 ]
+	rc=$?
+	log_test $rc 0 "Delete nexthop route warning"
+	run_cmd "$IP route delete 172.16.101.1/32 nhid 12"
+	run_cmd "$IP nexthop del id 12"
+
+	run_cmd "$IP nexthop add id 21 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
+	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
+	log_test $? 2 "Delete multipath route with only nh id based entry"
+
+	run_cmd "$IP nexthop add id 22 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.102.0/24 nhid 22"
+	run_cmd "$IP ro del 172.16.102.0/24 dev veth1"
+	log_test $? 2 "Delete route when specifying only nexthop device"
+
+	run_cmd "$IP ro del 172.16.102.0/24 via 172.16.1.6"
+	log_test $? 2 "Delete route when specifying only gateway"
+
+	run_cmd "$IP ro del 172.16.102.0/24"
+	log_test $? 0 "Delete route when not specifying nexthop attributes"
 }
 
 ipv4_grp_fcnal()
diff --git a/tools/vm/slabinfo-gnuplot.sh b/tools/vm/slabinfo-gnuplot.sh
index 26e193ffd2a2..873a892147e5 100644
--- a/tools/vm/slabinfo-gnuplot.sh
+++ b/tools/vm/slabinfo-gnuplot.sh
@@ -150,7 +150,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-loss"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by loss' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4+$2*$3" "$4}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"
@@ -159,7 +159,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-size"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by size' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4" "$4-$2*$3}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"
