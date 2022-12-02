Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85432640B55
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 17:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiLBQza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 11:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiLBQzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 11:55:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F26D678A;
        Fri,  2 Dec 2022 08:55:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3404162356;
        Fri,  2 Dec 2022 16:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C23CC433C1;
        Fri,  2 Dec 2022 16:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670000113;
        bh=rgJ8se7DuhBrEIqum4z/PxPHKA5HRXQ6zx6PfDbaihM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiEhogtLyCe3CuPR6dJWQq69x/+ktg7/gr2jdPkyco9zvrxKwcxEzLXyl15xn1pSK
         hXhrr+1QHsd8SkNfu7z7jWPgKgBHsh/drTEcth8E0y62uIkFu2oQ0t2p3ZVPMciM8p
         Cs78vfGwqGJJZjD9EtqmJk3l0157eVWTXxvhDwi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.157
Date:   Fri,  2 Dec 2022 17:55:04 +0100
Message-Id: <167000010319927@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <167000010318239@kroah.com>
References: <167000010318239@kroah.com>
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
index 166f87bdc190..bf22df29c4d8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 156
+SUBLEVEL = 157
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm/boot/dts/am335x-pcm-953.dtsi b/arch/arm/boot/dts/am335x-pcm-953.dtsi
index 6c547c83e5dd..fc465f0d7e18 100644
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
index a8d363568fd6..3fc761c8d550 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -203,7 +203,7 @@ &sdmmc {
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
 
diff --git a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
index 60846e88ae4b..dddabfbbc7a9 100644
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
index 926ab3960f9e..c92b55a0ec1c 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -28,6 +28,9 @@ obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 
 obj-y += vdso.o vdso-syms.o
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+ifneq ($(filter vgettimeofday, $(vdso-syms)),)
+CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
+endif
 
 # Disable -pg to prevent insert call site
 CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE)
diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index e6f558bca71b..b3e58402c342 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -64,9 +64,11 @@ VERSION
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
index 76762dc67ca9..f292c3e10671 100644
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2b7528821577..c34ba034ca11 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -305,12 +305,6 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
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
@@ -1357,6 +1351,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
@@ -3115,15 +3110,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 91e61dbba3e0..88cb537ccdea 100644
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
diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index be6733558b83..badb90352bf3 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -611,6 +611,10 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
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
index cfb1393a0891..4473adef2f5a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2008,15 +2008,21 @@ static void binder_cleanup_transaction(struct binder_transaction *t,
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
@@ -2026,10 +2032,16 @@ static size_t binder_get_object(struct binder_proc *proc,
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
@@ -2102,7 +2114,7 @@ static struct binder_buffer_object *binder_validate_ptr(
 					  b, buffer_offset,
 					  sizeof(object_offset)))
 		return NULL;
-	object_size = binder_get_object(proc, b, object_offset, object);
+	object_size = binder_get_object(proc, NULL, b, object_offset, object);
 	if (!object_size || object->hdr.type != BINDER_TYPE_PTR)
 		return NULL;
 	if (object_offsetp)
@@ -2167,7 +2179,8 @@ static bool binder_validate_fixup(struct binder_proc *proc,
 		unsigned long buffer_offset;
 		struct binder_object last_object;
 		struct binder_buffer_object *last_bbo;
-		size_t object_size = binder_get_object(proc, b, last_obj_offset,
+		size_t object_size = binder_get_object(proc, NULL, b,
+						       last_obj_offset,
 						       &last_object);
 		if (object_size != sizeof(*last_bbo))
 			return false;
@@ -2282,7 +2295,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		if (!binder_alloc_copy_from_buffer(&proc->alloc, &object_offset,
 						   buffer, buffer_offset,
 						   sizeof(object_offset)))
-			object_size = binder_get_object(proc, buffer,
+			object_size = binder_get_object(proc, NULL, buffer,
 							object_offset, &object);
 		if (object_size == 0) {
 			pr_err("transaction release %d bad object at offset %lld, size %zd\n",
@@ -2620,16 +2633,266 @@ static int binder_translate_fd(u32 fd, binder_size_t fd_offset,
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
@@ -2653,19 +2916,25 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
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
@@ -2675,7 +2944,8 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
 	return 0;
 }
 
-static int binder_fixup_parent(struct binder_transaction *t,
+static int binder_fixup_parent(struct list_head *pf_head,
+			       struct binder_transaction *t,
 			       struct binder_thread *thread,
 			       struct binder_buffer_object *bp,
 			       binder_size_t off_start_offset,
@@ -2721,14 +2991,7 @@ static int binder_fixup_parent(struct binder_transaction *t,
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
@@ -2848,6 +3111,7 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_size_t off_start_offset, off_end_offset;
 	binder_size_t off_min;
 	binder_size_t sg_buf_offset, sg_buf_end_offset;
+	binder_size_t user_offset = 0;
 	struct binder_proc *target_proc = NULL;
 	struct binder_thread *target_thread = NULL;
 	struct binder_node *target_node = NULL;
@@ -2862,6 +3126,12 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -3173,19 +3443,6 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -3230,6 +3487,7 @@ static void binder_transaction(struct binder_proc *proc,
 		size_t object_size;
 		struct binder_object object;
 		binder_size_t object_offset;
+		binder_size_t copy_size;
 
 		if (binder_alloc_copy_from_buffer(&target_proc->alloc,
 						  &object_offset,
@@ -3241,8 +3499,27 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -3254,6 +3531,11 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -3316,6 +3598,8 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_FDA: {
 			struct binder_object ptr_object;
 			binder_size_t parent_offset;
+			struct binder_object user_object;
+			size_t user_parent_size;
 			struct binder_fd_array_object *fda =
 				to_binder_fd_array_object(hdr);
 			size_t num_valid = (buffer_offset - off_start_offset) /
@@ -3347,11 +3631,35 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -3373,19 +3681,14 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -3394,7 +3697,8 @@ static void binder_transaction(struct binder_proc *proc,
 
 			num_valid = (buffer_offset - off_start_offset) /
 					sizeof(binder_size_t);
-			ret = binder_fixup_parent(t, thread, bp,
+			ret = binder_fixup_parent(&pf_head, t,
+						  thread, bp,
 						  off_start_offset,
 						  num_valid,
 						  last_fixup_obj_off,
@@ -3421,6 +3725,30 @@ static void binder_transaction(struct binder_proc *proc,
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
 
@@ -3487,6 +3815,7 @@ static void binder_transaction(struct binder_proc *proc,
 err_bad_offset:
 err_bad_parent:
 err_copy_data_failed:
+	binder_cleanup_deferred_txn_lists(&sgc_head, &pf_head);
 	binder_free_txn_fixups(t);
 	trace_binder_transaction_failed_buffer_release(t->buffer);
 	binder_transaction_buffer_release(target_proc, NULL, t->buffer,
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 459ece666c62..f1755efd30a2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4032,44 +4032,51 @@ void ata_scsi_dump_cdb(struct ata_port *ap, struct scsi_cmnd *cmd)
 
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
diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index 798f86fcd50f..dcbb023acc45 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -209,18 +209,6 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
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
@@ -259,13 +247,27 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index e8c76bd8c501..6aa9fd9cb83b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -341,11 +341,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
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
diff --git a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
index 8f362e8c1787..be6d43c9979c 100644
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
diff --git a/drivers/gpu/drm/drm_dp_dual_mode_helper.c b/drivers/gpu/drm/drm_dp_dual_mode_helper.c
index 1c9ea9f7fdaf..f2ff0bfdf54d 100644
--- a/drivers/gpu/drm/drm_dp_dual_mode_helper.c
+++ b/drivers/gpu/drm/drm_dp_dual_mode_helper.c
@@ -62,23 +62,45 @@
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
@@ -205,18 +227,6 @@ enum drm_dp_dual_mode_type drm_dp_dual_mode_detect(struct i2c_adapter *adapter)
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
 	DRM_DEBUG_KMS("DP dual mode adaptor ID: %02x (err %zd)\n",
@@ -231,11 +241,10 @@ enum drm_dp_dual_mode_type drm_dp_dual_mode_detect(struct i2c_adapter *adapter)
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
 			DRM_ERROR("Unexpected DP dual mode adaptor ID %02x\n",
 				  adaptor_id);
 
@@ -339,10 +348,8 @@ EXPORT_SYMBOL(drm_dp_dual_mode_get_tmds_output);
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
index a33887f2464f..5f86d9aacb8a 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -745,6 +745,10 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
+		if (INTEL_GEN(i915) == 12 && (engine->class == VIDEO_DECODE_CLASS ||
+		    engine->class == VIDEO_ENHANCEMENT_CLASS))
+			rb.bit = _MASKED_BIT_ENABLE(rb.bit);
+
 		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 	}
 
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 2c6ebc328b24..318692ad9680 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1042,6 +1042,10 @@ static bool host1x_drm_wants_iommu(struct host1x_device *dev)
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
index 8659558b518d..9f674a8d5009 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -198,6 +198,10 @@ static void host1x_setup_sid_table(struct host1x *host)
 
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
index 10188b1a6a08..5b902adb0d1b 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -501,13 +501,17 @@ static void vmbus_add_channel_work(struct work_struct *work)
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
index 514279dac7cb..e99400f3ae1d 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2020,6 +2020,7 @@ int vmbus_device_register(struct hv_device *child_device_obj)
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
index 9afb3fcc74e6..4a7ccf268ebf 100644
--- a/drivers/iio/light/apds9960.c
+++ b/drivers/iio/light/apds9960.c
@@ -53,9 +53,6 @@
 #define APDS9960_REG_CONTROL_PGAIN_MASK_SHIFT	2
 
 #define APDS9960_REG_CONFIG_2	0x90
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK	0x60
-#define APDS9960_REG_CONFIG_2_GGAIN_MASK_SHIFT	5
-
 #define APDS9960_REG_ID		0x92
 
 #define APDS9960_REG_STATUS	0x93
@@ -76,6 +73,9 @@
 #define APDS9960_REG_GCONF_1_GFIFO_THRES_MASK_SHIFT	6
 
 #define APDS9960_REG_GCONF_2	0xa3
+#define APDS9960_REG_GCONF_2_GGAIN_MASK			0x60
+#define APDS9960_REG_GCONF_2_GGAIN_MASK_SHIFT		5
+
 #define APDS9960_REG_GOFFSET_U	0xa4
 #define APDS9960_REG_GOFFSET_D	0xa5
 #define APDS9960_REG_GPULSE	0xa6
@@ -395,9 +395,9 @@ static int apds9960_set_pxs_gain(struct apds9960_data *data, int val)
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
index 82577095e175..f1013b950d57 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -191,6 +191,7 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index b23abde5d7db..b7f87ad4b9a9 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -1059,6 +1059,7 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
 	input_set_abs_params(ts->input_dev, ABS_MT_WIDTH_MAJOR, 0, 255, 0, 0);
 	input_set_abs_params(ts->input_dev, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
 
+retry_read_config:
 	/* Read configuration and apply touchscreen parameters */
 	goodix_read_config(ts);
 
@@ -1066,6 +1067,16 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
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
index 42b295337baf..d8cb5bcd6b10 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1615,7 +1615,7 @@ static int its_select_cpu(struct irq_data *d,
 
 		cpu = cpumask_pick_least_loaded(d, tmpmask);
 	} else {
-		cpumask_and(tmpmask, irq_data_get_affinity_mask(d), cpu_online_mask);
+		cpumask_copy(tmpmask, aff_mask);
 
 		/* If we cannot cross sockets, limit the search to that node */
 		if ((its_dev->its->flags & ITS_FLAGS_WORKAROUND_CAVIUM_23144) &&
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 835b1f3464d0..2156a2d5ac70 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -254,6 +254,7 @@ struct dm_integrity_c {
 
 	struct completion crypto_backoff;
 
+	bool wrote_to_journal;
 	bool journal_uptodate;
 	bool just_formatted;
 	bool recalculate_flag;
@@ -2256,6 +2257,8 @@ static void integrity_commit(struct work_struct *w)
 	if (!commit_sections)
 		goto release_flush_bios;
 
+	ic->wrote_to_journal = true;
+
 	i = commit_start;
 	for (n = 0; n < commit_sections; n++) {
 		for (j = 0; j < ic->journal_section_entries; j++) {
@@ -2470,10 +2473,6 @@ static void integrity_writer(struct work_struct *w)
 
 	unsigned prev_free_sectors;
 
-	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_post_suspending(ic->ti)) && !ic->meta_dev)
-		return;
-
 	spin_lock_irq(&ic->endio_wait.lock);
 	write_start = ic->committed_section;
 	write_sections = ic->n_committed_sections;
@@ -2980,10 +2979,17 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
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
@@ -3011,6 +3017,8 @@ static void dm_integrity_resume(struct dm_target *ti)
 
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
diff --git a/drivers/net/arcnet/arc-rimi.c b/drivers/net/arcnet/arc-rimi.c
index 98df38fe553c..12d085405bd0 100644
--- a/drivers/net/arcnet/arc-rimi.c
+++ b/drivers/net/arcnet/arc-rimi.c
@@ -332,7 +332,7 @@ static int __init arc_rimi_init(void)
 		dev->irq = 9;
 
 	if (arcrimi_probe(dev)) {
-		free_netdev(dev);
+		free_arcdev(dev);
 		return -EIO;
 	}
 
@@ -349,7 +349,7 @@ static void __exit arc_rimi_exit(void)
 	iounmap(lp->mem_start);
 	release_mem_region(dev->mem_start, dev->mem_end - dev->mem_start + 1);
 	free_irq(dev->irq, dev);
-	free_netdev(dev);
+	free_arcdev(dev);
 }
 
 #ifndef MODULE
diff --git a/drivers/net/arcnet/arcdevice.h b/drivers/net/arcnet/arcdevice.h
index 22a49c6d7ae6..5d4a4c7efbbf 100644
--- a/drivers/net/arcnet/arcdevice.h
+++ b/drivers/net/arcnet/arcdevice.h
@@ -298,6 +298,10 @@ struct arcnet_local {
 
 	int excnak_pending;    /* We just got an excesive nak interrupt */
 
+	/* RESET flag handling */
+	int reset_in_progress;
+	struct work_struct reset_work;
+
 	struct {
 		uint16_t sequence;	/* sequence number (incs with each packet) */
 		__be16 aborted_seq;
@@ -350,7 +354,9 @@ void arcnet_dump_skb(struct net_device *dev, struct sk_buff *skb, char *desc)
 
 void arcnet_unregister_proto(struct ArcProto *proto);
 irqreturn_t arcnet_interrupt(int irq, void *dev_id);
+
 struct net_device *alloc_arcdev(const char *name);
+void free_arcdev(struct net_device *dev);
 
 int arcnet_open(struct net_device *dev);
 int arcnet_close(struct net_device *dev);
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index e04efc0a5c97..d76dd7d14299 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -387,10 +387,44 @@ static void arcnet_timer(struct timer_list *t)
 	struct arcnet_local *lp = from_timer(lp, t, timer);
 	struct net_device *dev = lp->dev;
 
-	if (!netif_carrier_ok(dev)) {
+	spin_lock_irq(&lp->lock);
+
+	if (!lp->reset_in_progress && !netif_carrier_ok(dev)) {
 		netif_carrier_on(dev);
 		netdev_info(dev, "link up\n");
 	}
+
+	spin_unlock_irq(&lp->lock);
+}
+
+static void reset_device_work(struct work_struct *work)
+{
+	struct arcnet_local *lp;
+	struct net_device *dev;
+
+	lp = container_of(work, struct arcnet_local, reset_work);
+	dev = lp->dev;
+
+	/* Do not bring the network interface back up if an ifdown
+	 * was already done.
+	 */
+	if (!netif_running(dev) || !lp->reset_in_progress)
+		return;
+
+	rtnl_lock();
+
+	/* Do another check, in case of an ifdown that was triggered in
+	 * the small race window between the exit condition above and
+	 * acquiring RTNL.
+	 */
+	if (!netif_running(dev) || !lp->reset_in_progress)
+		goto out;
+
+	dev_close(dev);
+	dev_open(dev, NULL);
+
+out:
+	rtnl_unlock();
 }
 
 static void arcnet_reply_tasklet(unsigned long data)
@@ -452,12 +486,25 @@ struct net_device *alloc_arcdev(const char *name)
 		lp->dev = dev;
 		spin_lock_init(&lp->lock);
 		timer_setup(&lp->timer, arcnet_timer, 0);
+		INIT_WORK(&lp->reset_work, reset_device_work);
 	}
 
 	return dev;
 }
 EXPORT_SYMBOL(alloc_arcdev);
 
+void free_arcdev(struct net_device *dev)
+{
+	struct arcnet_local *lp = netdev_priv(dev);
+
+	/* Do not cancel this at ->ndo_close(), as the workqueue itself
+	 * indirectly calls the ifdown path through dev_close().
+	 */
+	cancel_work_sync(&lp->reset_work);
+	free_netdev(dev);
+}
+EXPORT_SYMBOL(free_arcdev);
+
 /* Open/initialize the board.  This is called sometime after booting when
  * the 'ifconfig' program is run.
  *
@@ -587,6 +634,10 @@ int arcnet_close(struct net_device *dev)
 
 	/* shut down the card */
 	lp->hw.close(dev);
+
+	/* reset counters */
+	lp->reset_in_progress = 0;
+
 	module_put(lp->hw.owner);
 	return 0;
 }
@@ -820,6 +871,9 @@ irqreturn_t arcnet_interrupt(int irq, void *dev_id)
 
 	spin_lock_irqsave(&lp->lock, flags);
 
+	if (lp->reset_in_progress)
+		goto out;
+
 	/* RESET flag was enabled - if device is not running, we must
 	 * clear it right away (but nothing else).
 	 */
@@ -852,11 +906,14 @@ irqreturn_t arcnet_interrupt(int irq, void *dev_id)
 		if (status & RESETflag) {
 			arc_printk(D_NORMAL, dev, "spurious reset (status=%Xh)\n",
 				   status);
-			arcnet_close(dev);
-			arcnet_open(dev);
+
+			lp->reset_in_progress = 1;
+			netif_stop_queue(dev);
+			netif_carrier_off(dev);
+			schedule_work(&lp->reset_work);
 
 			/* get out of the interrupt handler! */
-			break;
+			goto out;
 		}
 		/* RX is inhibited - we must have received something.
 		 * Prepare to receive into the next buffer.
@@ -1052,6 +1109,7 @@ irqreturn_t arcnet_interrupt(int irq, void *dev_id)
 	udelay(1);
 	lp->hw.intmask(dev, lp->intmask);
 
+out:
 	spin_unlock_irqrestore(&lp->lock, flags);
 	return retval;
 }
diff --git a/drivers/net/arcnet/com20020-isa.c b/drivers/net/arcnet/com20020-isa.c
index f983c4ce6b07..be618e4b9ed5 100644
--- a/drivers/net/arcnet/com20020-isa.c
+++ b/drivers/net/arcnet/com20020-isa.c
@@ -169,7 +169,7 @@ static int __init com20020_init(void)
 		dev->irq = 9;
 
 	if (com20020isa_probe(dev)) {
-		free_netdev(dev);
+		free_arcdev(dev);
 		return -EIO;
 	}
 
@@ -182,7 +182,7 @@ static void __exit com20020_exit(void)
 	unregister_netdev(my_dev);
 	free_irq(my_dev->irq, my_dev);
 	release_region(my_dev->base_addr, ARCNET_TOTAL_SIZE);
-	free_netdev(my_dev);
+	free_arcdev(my_dev);
 }
 
 #ifndef MODULE
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 9f44e2e458df..b4f8798d8c50 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -294,7 +294,7 @@ static void com20020pci_remove(struct pci_dev *pdev)
 
 		unregister_netdev(dev);
 		free_irq(dev->irq, dev);
-		free_netdev(dev);
+		free_arcdev(dev);
 	}
 }
 
diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
index cf607ffcf358..e0c7720bd5da 100644
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
@@ -177,7 +184,7 @@ static void com20020_detach(struct pcmcia_device *link)
 		dev = info->dev;
 		if (dev) {
 			dev_dbg(&link->dev, "kfree...\n");
-			free_netdev(dev);
+			free_arcdev(dev);
 		}
 		dev_dbg(&link->dev, "kfree2...\n");
 		kfree(info);
diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
index cf214b730671..3856b447d38e 100644
--- a/drivers/net/arcnet/com90io.c
+++ b/drivers/net/arcnet/com90io.c
@@ -396,7 +396,7 @@ static int __init com90io_init(void)
 	err = com90io_probe(dev);
 
 	if (err) {
-		free_netdev(dev);
+		free_arcdev(dev);
 		return err;
 	}
 
@@ -419,7 +419,7 @@ static void __exit com90io_exit(void)
 
 	free_irq(dev->irq, dev);
 	release_region(dev->base_addr, ARCNET_TOTAL_SIZE);
-	free_netdev(dev);
+	free_arcdev(dev);
 }
 
 module_init(com90io_init)
diff --git a/drivers/net/arcnet/com90xx.c b/drivers/net/arcnet/com90xx.c
index 3dc3d533cb19..d8dfb9ea0de8 100644
--- a/drivers/net/arcnet/com90xx.c
+++ b/drivers/net/arcnet/com90xx.c
@@ -554,7 +554,7 @@ static int __init com90xx_found(int ioaddr, int airq, u_long shmem,
 err_release_mem:
 	release_mem_region(dev->mem_start, dev->mem_end - dev->mem_start + 1);
 err_free_dev:
-	free_netdev(dev);
+	free_arcdev(dev);
 	return -EIO;
 }
 
@@ -672,7 +672,7 @@ static void __exit com90xx_exit(void)
 		release_region(dev->base_addr, ARCNET_TOTAL_SIZE);
 		release_mem_region(dev->mem_start,
 				   dev->mem_end - dev->mem_start + 1);
-		free_netdev(dev);
+		free_arcdev(dev);
 	}
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 08437eaacbb9..ac327839eed9 100644
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
index c4dc6e2ccd6b..eefb25bcf57f 100644
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
index 8ff28ed04b7f..f0e48b9373d6 100644
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
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index ca62c72eb772..975762ccb66f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1212,7 +1212,7 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	/* enable Tx ints by setting pkt thr to 1 */
 	enetc_txbdr_wr(hw, idx, ENETC_TBICR0, ENETC_TBICR0_ICEN | 0x1);
 
-	tbmr = ENETC_TBMR_EN;
+	tbmr = ENETC_TBMR_EN | ENETC_TBMR_SET_PRIO(tx_ring->prio);
 	if (tx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
 		tbmr |= ENETC_TBMR_VIH;
 
@@ -1272,13 +1272,14 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 
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
@@ -1311,13 +1312,14 @@ static void enetc_clear_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 
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
@@ -1325,13 +1327,13 @@ static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
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
@@ -1419,13 +1421,14 @@ static void enetc_setup_interrupts(struct enetc_ndev_priv *priv)
 
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
@@ -1565,6 +1568,7 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_bdr *tx_ring;
 	u8 num_tc;
 	int i;
@@ -1579,7 +1583,8 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
 			tx_ring = priv->tx_ring[i];
-			enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, 0);
+			tx_ring->prio = 0;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
 		}
 
 		return 0;
@@ -1598,7 +1603,8 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	 */
 	for (i = 0; i < num_tc; i++) {
 		tx_ring = priv->tx_ring[i];
-		enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, i);
+		tx_ring->prio = i;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
 	}
 
 	/* Reset the number of netdev queues based on the TC count */
@@ -1679,19 +1685,21 @@ static int enetc_set_rss(struct net_device *ndev, int en)
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
index 00386c5d3cde..725c3d1cbb19 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -58,6 +58,7 @@ struct enetc_bdr {
 		void __iomem *rcir;
 	};
 	u16 index;
+	u16 prio;
 	int bd_count; /* # of BDs */
 	int next_to_use;
 	int next_to_clean;
@@ -338,19 +339,20 @@ int enetc_set_psfp(struct net_device *ndev, bool en);
 
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
index 6904e10dd46b..515db7e6e649 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -748,9 +748,6 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
-	if (si->hw_features & ENETC_SI_F_QBV)
-		priv->active_offloads |= ENETC_F_QBV;
-
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
 		ndev->features |= NETIF_F_HW_TC;
@@ -996,7 +993,8 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	struct enetc_ndev_priv *priv;
 
 	priv = netdev_priv(pf->si->ndev);
-	if (priv->active_offloads & ENETC_F_QBV)
+
+	if (pf->si->hw_features & ENETC_SI_F_QBV)
 		enetc_sched_speed_set(priv, speed);
 
 	if (!phylink_autoneg_inband(mode) &&
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 62efe1aebf86..5841721c8119 100644
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
@@ -39,16 +40,15 @@ void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 	}
 
 	priv->speed = speed;
-	enetc_port_wr(&priv->si->hw, ENETC_PMR,
-		      (enetc_port_rd(&priv->si->hw, ENETC_PMR)
-		      & (~ENETC_PMR_PSPEED_MASK))
-		      | pspeed);
+	tmp = enetc_port_rd(hw, ENETC_PMR);
+	enetc_port_wr(hw, ENETC_PMR, (tmp & ~ENETC_PMR_PSPEED_MASK) | pspeed);
 }
 
 static int enetc_setup_taprio(struct net_device *ndev,
 			      struct tc_taprio_qopt_offload *admin_conf)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct tgs_gcl_conf *gcl_config;
 	struct tgs_gcl_data *gcl_data;
@@ -60,15 +60,16 @@ static int enetc_setup_taprio(struct net_device *ndev,
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
 
@@ -123,18 +124,18 @@ static int enetc_setup_taprio(struct net_device *ndev,
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
 
 	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
 	kfree(gcl_data);
 
+	if (!err)
+		priv->active_offloads |= ENETC_F_QBV;
+
 	return err;
 }
 
@@ -142,6 +143,8 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_bdr *tx_ring;
 	int err;
 	int i;
 
@@ -150,18 +153,20 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
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
@@ -182,7 +187,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	struct tc_cbs_qopt_offload *cbs = type_data;
 	u32 port_transmit_rate = priv->speed;
 	u8 tc_nums = netdev_get_num_tc(ndev);
-	struct enetc_si *si = priv->si;
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 hi_credit_bit, hi_credit_reg;
 	u32 max_interference_size;
 	u32 port_frame_max_size;
@@ -203,15 +208,15 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
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
@@ -228,13 +233,13 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
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
@@ -243,7 +248,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 	}
 
-	enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
+	enetc_port_rd(hw, ENETC_PTCMSDUR(tc));
 
 	/* For top prio TC, the max_interfrence_size is maxSizedFrame.
 	 *
@@ -263,8 +268,8 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		u32 m0, ma, r0, ra;
 
 		m0 = port_frame_max_size * 8;
-		ma = enetc_port_rd(&si->hw, ENETC_PTCMSDUR(prio_top)) * 8;
-		ra = enetc_get_cbs_bw(&si->hw, prio_top) *
+		ma = enetc_port_rd(hw, ENETC_PTCMSDUR(prio_top)) * 8;
+		ra = enetc_get_cbs_bw(hw, prio_top) *
 			port_transmit_rate * 10000ULL;
 		r0 = port_transmit_rate * 1000000ULL;
 		max_interference_size = m0 + ma +
@@ -284,10 +289,10 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	hi_credit_reg = (u32)div_u64((ENETC_CLK * 100ULL) * hi_credit_bit,
 				     port_transmit_rate * 1000000ULL);
 
-	enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
+	enetc_port_wr(hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
 
 	/* Set bw register and enable this traffic class */
-	enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
+	enetc_port_wr(hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
 
 	return 0;
 }
@@ -297,6 +302,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_etf_qopt_offload *qopt = type_data;
 	u8 tc_nums = netdev_get_num_tc(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int tc;
 
 	if (!tc_nums)
@@ -312,12 +318,11 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
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
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c7aff89141e1..217dc67c48fa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2299,7 +2299,10 @@ static int mtk_open(struct net_device *dev)
 		int err = mtk_start_dma(eth);
 
 		if (err)
+		if (err) {
+			phylink_disconnect_phy(mac->phylink);
 			return err;
+		}
 
 		mtk_gdm_config(eth, MTK_GDMA_TO_PDMA);
 
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
index cf07318048df..c838d8698eab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -959,6 +959,7 @@ static void cmd_work_handler(struct work_struct *work)
 		cmd_ent_get(ent);
 	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
+	cmd_ent_get(ent); /* for the _real_ FW event on completion */
 	/* Skip sending command to fw if internal error */
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
 		u8 status = 0;
@@ -972,7 +973,6 @@ static void cmd_work_handler(struct work_struct *work)
 		return;
 	}
 
-	cmd_ent_get(ent); /* for the _real_ FW event on completion */
 	/* ring doorbell after the descriptor is valid */
 	mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 << ent->idx);
 	wmb();
@@ -1586,8 +1586,8 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				cmd_ent_put(ent); /* timeout work was canceled */
 
 			if (!forced || /* Real FW completion */
-			    pci_channel_offline(dev->pdev) || /* FW is inaccessible */
-			    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
+			     !opcode_allowed(cmd, ent->op))
 				cmd_ent_put(ent);
 
 			ent->ts2 = ktime_get_ns();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index e8a4adccd2b2..f800e1ca5ba6 100644
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
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 7a8187458724..24578c48f075 100644
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
index 3977aa2f59bd..311873ff57e3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1225,6 +1225,9 @@ nfp_port_get_module_info(struct net_device *netdev,
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	if (!port)
+		return -EOPNOTSUPP;
+
 	/* update port state to get latest interface */
 	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 2942102efd48..bde32f0845ca 100644
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
@@ -2481,6 +2482,7 @@ static void pch_gbe_remove(struct pci_dev *pdev)
 	unregister_netdev(netdev);
 
 	pch_gbe_phy_hw_reset(&adapter->hw);
+	pci_dev_put(adapter->ptp_pdev);
 
 	free_netdev(netdev);
 }
@@ -2562,7 +2564,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	/* setup the private structure */
 	ret = pch_gbe_sw_init(adapter);
 	if (ret)
-		goto err_free_netdev;
+		goto err_put_dev;
 
 	/* Initialize PHY */
 	ret = pch_gbe_init_phy(adapter);
@@ -2620,6 +2622,8 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 
 err_free_adapter:
 	pch_gbe_phy_hw_reset(&adapter->hw);
+err_put_dev:
+	pci_dev_put(adapter->ptp_pdev);
 err_free_netdev:
 	free_netdev(netdev);
 	return ret;
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 2219e4c59ae6..99fd35a8ca75 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2475,6 +2475,7 @@ static netdev_tx_t ql3xxx_send(struct sk_buff *skb,
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
index f84e3cc0d3ec..3e564158c401 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2648,11 +2648,6 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	if (ret)
 		goto rollback;
 
-	/* Force features update, since they are different for SW MACSec and
-	 * HW offloading cases.
-	 */
-	netdev_update_features(dev);
-
 	rtnl_unlock();
 	return 0;
 
@@ -3420,16 +3415,9 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
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
@@ -3446,12 +3434,8 @@ static int macsec_dev_init(struct net_device *dev)
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
@@ -3480,10 +3464,7 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 
-	if (macsec_is_offloaded(macsec))
-		return REAL_DEV_FEATURES(real_dev);
-
-	features &= (real_dev->features & SW_MACSEC_FEATURES) |
+	features &= (real_dev->features & MACSEC_FEATURES) |
 		    NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES;
 	features |= NETIF_F_LLTX;
 
@@ -3832,7 +3813,6 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
-		int ret;
 
 		ops = macsec_get_ops(netdev_priv(dev), &ctx);
 		if (!ops) {
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index a1c9233e264d..7313e6e03c12 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1292,6 +1292,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x103a, 0)}, /* Telit LE910C4-WWX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 0569f37e9ed5..8c9c6bfbaeee 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5236,7 +5236,7 @@ static int get_wep_tx_idx(struct airo_info *ai)
 	return -1;
 }
 
-static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
+static int set_wep_key(struct airo_info *ai, u16 index, const u8 *key,
 		       u16 keylen, int perm, int lock)
 {
 	static const unsigned char macaddr[ETH_ALEN] = { 0x01, 0, 0, 0, 0, 0 };
@@ -5287,7 +5287,7 @@ static void proc_wepkey_on_close(struct inode *inode, struct file *file)
 	struct net_device *dev = PDE_DATA(inode);
 	struct airo_info *ai = dev->ml_priv;
 	int i, rc;
-	char key[16];
+	u8 key[16];
 	u16 index = 0;
 	int j = 0;
 
@@ -5315,12 +5315,22 @@ static void proc_wepkey_on_close(struct inode *inode, struct file *file)
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
index a6d4ff4760ad..255286b2324e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -775,6 +775,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *cb;
 
 	if (!vp->assoc)
 		return;
@@ -796,6 +797,10 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
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
index 6be5ac8ba518..dd26f2086180 100644
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
index d025a3093015..b25847799138 100644
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
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 807eae04c1e3..37d397aae9b9 100644
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
 
@@ -340,8 +340,10 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 
 		/* Check next byte is PARAMETERS tag (82) */
 		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
+			devm_kfree(dev, transaction);
 			return -EPROTO;
+		}
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
 		memcpy(transaction->params, skb->data +
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 65f4bf880608..089f39103584 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3252,6 +3252,10 @@ static const struct pci_device_id nvme_id_table[] = {
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
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 8e696262215f..ebec49957ed0 100644
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
index 39e1a6396e08..db369cf26111 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1212,6 +1212,8 @@ static void asus_wmi_set_xusb2pr(struct asus_wmi *asus)
 	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
 				cpu_to_le32(ports_available));
 
+	pci_dev_put(xhci_pdev);
+
 	pr_info("set USB_INTEL_XUSB2PR old: 0x%04x, new: 0x%04x\n",
 			orig_ports_available, ports_available);
 }
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 519b2ab84a63..6642d09b17b5 100644
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
diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index ab6a9369649d..110ff1e6ef81 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -756,6 +756,22 @@ static const struct ts_dmi_data predia_basic_data = {
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
@@ -1341,6 +1357,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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
index bf8ba73d6c7c..eb083b26ab4f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4928,6 +4928,7 @@ static void regulator_dev_release(struct device *dev)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
+	debugfs_remove_recursive(rdev->debugfs);
 	kfree(rdev->constraints);
 	of_node_put(rdev->dev.of_node);
 	kfree(rdev);
@@ -5401,11 +5402,15 @@ regulator_register(const struct regulator_desc *regulator_desc,
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
@@ -5434,7 +5439,6 @@ void regulator_unregister(struct regulator_dev *rdev)
 
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
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f6d6539c657f..b793e342ab7c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -635,8 +635,13 @@ static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 		memset(vhost->async_crq.msgs, 0, PAGE_SIZE);
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
@@ -2822,9 +2827,12 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
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
index 261b915835b4..cc20621bb49d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1878,6 +1878,13 @@ static int resp_readcap16(struct scsi_cmnd *scp,
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
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 4a96fb05731d..c6256fdc24b1 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -716,12 +716,17 @@ int sas_phy_add(struct sas_phy *phy)
 	int error;
 
 	error = device_add(&phy->dev);
-	if (!error) {
-		transport_add_device(&phy->dev);
-		transport_configure_device(&phy->dev);
+	if (error)
+		return error;
+
+	error = transport_add_device(&phy->dev);
+	if (error) {
+		device_del(&phy->dev);
+		return error;
 	}
+	transport_configure_device(&phy->dev);
 
-	return error;
+	return 0;
 }
 EXPORT_SYMBOL(sas_phy_add);
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 7ac1090d4379..3fa8a0c94bdc 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -356,16 +356,21 @@ enum storvsc_request_type {
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
@@ -995,38 +1000,25 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
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
@@ -1049,6 +1041,13 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
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
index 651a6510fb54..9ec37cf10c01 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -443,7 +443,7 @@ static int stm32_spi_prepare_mbr(struct stm32_spi *spi, u32 speed_hz,
 	u32 div, mbrdiv;
 
 	/* Ensure spi->clk_rate is even */
-	div = DIV_ROUND_UP(spi->clk_rate & ~0x1, speed_hz);
+	div = DIV_ROUND_CLOSEST(spi->clk_rate & ~0x1, speed_hz);
 
 	/*
 	 * SPI framework set xfer->speed_hz to master->max_speed_hz if
diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
index 031806468af4..60ffc54da003 100644
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
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 3f7379f16a36..483fff3a95c9 100644
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
diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index 6eeb7ed8e91f..8fe7420de033 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -97,13 +97,23 @@ static int cdns3_core_init_role(struct cdns3 *cdns)
 	 * can be restricted later depending on strap pin configuration.
 	 */
 	if (dr_mode == USB_DR_MODE_UNKNOWN) {
-		if (IS_ENABLED(CONFIG_USB_CDNS3_HOST) &&
-		    IS_ENABLED(CONFIG_USB_CDNS3_GADGET))
-			dr_mode = USB_DR_MODE_OTG;
-		else if (IS_ENABLED(CONFIG_USB_CDNS3_HOST))
-			dr_mode = USB_DR_MODE_HOST;
-		else if (IS_ENABLED(CONFIG_USB_CDNS3_GADGET))
-			dr_mode = USB_DR_MODE_PERIPHERAL;
+		if (cdns->version == CDNSP_CONTROLLER_V2) {
+			if (IS_ENABLED(CONFIG_USB_CDNSP_HOST) &&
+			    IS_ENABLED(CONFIG_USB_CDNSP_GADGET))
+				dr_mode = USB_DR_MODE_OTG;
+			else if (IS_ENABLED(CONFIG_USB_CDNSP_HOST))
+				dr_mode = USB_DR_MODE_HOST;
+			else if (IS_ENABLED(CONFIG_USB_CDNSP_GADGET))
+				dr_mode = USB_DR_MODE_PERIPHERAL;
+		} else {
+			if (IS_ENABLED(CONFIG_USB_CDNS3_HOST) &&
+			    IS_ENABLED(CONFIG_USB_CDNS3_GADGET))
+				dr_mode = USB_DR_MODE_OTG;
+			else if (IS_ENABLED(CONFIG_USB_CDNS3_HOST))
+				dr_mode = USB_DR_MODE_HOST;
+			else if (IS_ENABLED(CONFIG_USB_CDNS3_GADGET))
+				dr_mode = USB_DR_MODE_PERIPHERAL;
+		}
 	}
 
 	/*
diff --git a/drivers/usb/cdns3/core.h b/drivers/usb/cdns3/core.h
index 3176f924293a..0d87871499ea 100644
--- a/drivers/usb/cdns3/core.h
+++ b/drivers/usb/cdns3/core.h
@@ -55,7 +55,9 @@ struct cdns3_platform_data {
  * @otg_res: the resource for otg
  * @otg_v0_regs: pointer to base of v0 otg registers
  * @otg_v1_regs: pointer to base of v1 otg registers
+ * @otg_cdnsp_regs: pointer to base of CDNSP otg registers
  * @otg_regs: pointer to base of otg registers
+ * @otg_irq_regs: pointer to interrupt registers
  * @otg_irq: irq number for otg controller
  * @dev_irq: irq number for device controller
  * @wakeup_irq: irq number for wakeup event, it is optional
@@ -86,9 +88,12 @@ struct cdns3 {
 	struct resource			otg_res;
 	struct cdns3_otg_legacy_regs	*otg_v0_regs;
 	struct cdns3_otg_regs		*otg_v1_regs;
+	struct cdnsp_otg_regs		*otg_cdnsp_regs;
 	struct cdns3_otg_common_regs	*otg_regs;
+	struct cdns3_otg_irq_regs	*otg_irq_regs;
 #define CDNS3_CONTROLLER_V0	0
 #define CDNS3_CONTROLLER_V1	1
+#define CDNSP_CONTROLLER_V2	2
 	u32				version;
 	bool				phyrst_a_enable;
 
diff --git a/drivers/usb/cdns3/drd.c b/drivers/usb/cdns3/drd.c
index 38ccd29e4cde..95863d44e3e0 100644
--- a/drivers/usb/cdns3/drd.c
+++ b/drivers/usb/cdns3/drd.c
@@ -2,13 +2,12 @@
 /*
  * Cadence USBSS DRD Driver.
  *
- * Copyright (C) 2018-2019 Cadence.
+ * Copyright (C) 2018-2020 Cadence.
  * Copyright (C) 2019 Texas Instruments
  *
  * Author: Pawel Laszczak <pawell@cadence.com>
  *         Roger Quadros <rogerq@ti.com>
  *
- *
  */
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
@@ -28,8 +27,9 @@
  *
  * Returns 0 on success otherwise negative errno
  */
-int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode)
+static int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode)
 {
+	u32 __iomem *override_reg;
 	u32 reg;
 
 	switch (mode) {
@@ -39,11 +39,24 @@ int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode)
 		break;
 	case USB_DR_MODE_OTG:
 		dev_dbg(cdns->dev, "Set controller to OTG mode\n");
-		if (cdns->version == CDNS3_CONTROLLER_V1) {
-			reg = readl(&cdns->otg_v1_regs->override);
+
+		if (cdns->version == CDNSP_CONTROLLER_V2)
+			override_reg = &cdns->otg_cdnsp_regs->override;
+		else if (cdns->version == CDNS3_CONTROLLER_V1)
+			override_reg = &cdns->otg_v1_regs->override;
+		else
+			override_reg = &cdns->otg_v0_regs->ctrl1;
+
+		reg = readl(override_reg);
+
+		if (cdns->version != CDNS3_CONTROLLER_V0)
 			reg |= OVERRIDE_IDPULLUP;
-			writel(reg, &cdns->otg_v1_regs->override);
+		else
+			reg |= OVERRIDE_IDPULLUP_V0;
 
+		writel(reg, override_reg);
+
+		if (cdns->version == CDNS3_CONTROLLER_V1) {
 			/*
 			 * Enable work around feature built into the
 			 * controller to address issue with RX Sensitivity
@@ -55,10 +68,6 @@ int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode)
 				reg |= PHYRST_CFG_PHYRST_A_ENABLE;
 				writel(reg, &cdns->otg_v1_regs->phyrst_cfg);
 			}
-		} else {
-			reg = readl(&cdns->otg_v0_regs->ctrl1);
-			reg |= OVERRIDE_IDPULLUP_V0;
-			writel(reg, &cdns->otg_v0_regs->ctrl1);
 		}
 
 		/*
@@ -123,7 +132,7 @@ bool cdns3_is_device(struct cdns3 *cdns)
  */
 static void cdns3_otg_disable_irq(struct cdns3 *cdns)
 {
-	writel(0, &cdns->otg_regs->ien);
+	writel(0, &cdns->otg_irq_regs->ien);
 }
 
 /**
@@ -133,7 +142,7 @@ static void cdns3_otg_disable_irq(struct cdns3 *cdns)
 static void cdns3_otg_enable_irq(struct cdns3 *cdns)
 {
 	writel(OTGIEN_ID_CHANGE_INT | OTGIEN_VBUSVALID_RISE_INT |
-	       OTGIEN_VBUSVALID_FALL_INT, &cdns->otg_regs->ien);
+	       OTGIEN_VBUSVALID_FALL_INT, &cdns->otg_irq_regs->ien);
 }
 
 /**
@@ -144,16 +153,21 @@ static void cdns3_otg_enable_irq(struct cdns3 *cdns)
  */
 int cdns3_drd_host_on(struct cdns3 *cdns)
 {
-	u32 val;
+	u32 val, ready_bit;
 	int ret;
 
 	/* Enable host mode. */
 	writel(OTGCMD_HOST_BUS_REQ | OTGCMD_OTG_DIS,
 	       &cdns->otg_regs->cmd);
 
+	if (cdns->version == CDNSP_CONTROLLER_V2)
+		ready_bit = OTGSTS_CDNSP_XHCI_READY;
+	else
+		ready_bit = OTGSTS_CDNS3_XHCI_READY;
+
 	dev_dbg(cdns->dev, "Waiting till Host mode is turned on\n");
 	ret = readl_poll_timeout_atomic(&cdns->otg_regs->sts, val,
-					val & OTGSTS_XHCI_READY, 1, 100000);
+					val & ready_bit, 1, 100000);
 
 	if (ret)
 		dev_err(cdns->dev, "timeout waiting for xhci_ready\n");
@@ -189,17 +203,22 @@ void cdns3_drd_host_off(struct cdns3 *cdns)
  */
 int cdns3_drd_gadget_on(struct cdns3 *cdns)
 {
-	int ret, val;
 	u32 reg = OTGCMD_OTG_DIS;
+	u32 ready_bit;
+	int ret, val;
 
 	/* switch OTG core */
 	writel(OTGCMD_DEV_BUS_REQ | reg, &cdns->otg_regs->cmd);
 
 	dev_dbg(cdns->dev, "Waiting till Device mode is turned on\n");
 
+	if (cdns->version == CDNSP_CONTROLLER_V2)
+		ready_bit = OTGSTS_CDNSP_DEV_READY;
+	else
+		ready_bit = OTGSTS_CDNS3_DEV_READY;
+
 	ret = readl_poll_timeout_atomic(&cdns->otg_regs->sts, val,
-					val & OTGSTS_DEV_READY,
-					1, 100000);
+					val & ready_bit, 1, 100000);
 	if (ret) {
 		dev_err(cdns->dev, "timeout waiting for dev_ready\n");
 		return ret;
@@ -244,7 +263,7 @@ static int cdns3_init_otg_mode(struct cdns3 *cdns)
 
 	cdns3_otg_disable_irq(cdns);
 	/* clear all interrupts */
-	writel(~0, &cdns->otg_regs->ivect);
+	writel(~0, &cdns->otg_irq_regs->ivect);
 
 	ret = cdns3_set_mode(cdns, USB_DR_MODE_OTG);
 	if (ret)
@@ -313,7 +332,7 @@ static irqreturn_t cdns3_drd_irq(int irq, void *data)
 	if (cdns->in_lpm)
 		return ret;
 
-	reg = readl(&cdns->otg_regs->ivect);
+	reg = readl(&cdns->otg_irq_regs->ivect);
 
 	if (!reg)
 		return IRQ_NONE;
@@ -332,7 +351,7 @@ static irqreturn_t cdns3_drd_irq(int irq, void *data)
 		ret = IRQ_WAKE_THREAD;
 	}
 
-	writel(~0, &cdns->otg_regs->ivect);
+	writel(~0, &cdns->otg_irq_regs->ivect);
 	return ret;
 }
 
@@ -347,28 +366,43 @@ int cdns3_drd_init(struct cdns3 *cdns)
 		return PTR_ERR(regs);
 
 	/* Detection of DRD version. Controller has been released
-	 * in two versions. Both are similar, but they have same changes
-	 * in register maps.
-	 * The first register in old version is command register and it's read
-	 * only, so driver should read 0 from it. On the other hand, in v1
-	 * the first register contains device ID number which is not set to 0.
-	 * Driver uses this fact to detect the proper version of
+	 * in three versions. All are very similar and are software compatible,
+	 * but they have same changes in register maps.
+	 * The first register in oldest version is command register and it's
+	 * read only. Driver should read 0 from it. On the other hand, in v1
+	 * and v2 the first register contains device ID number which is not
+	 * set to 0. Driver uses this fact to detect the proper version of
 	 * controller.
 	 */
 	cdns->otg_v0_regs = regs;
 	if (!readl(&cdns->otg_v0_regs->cmd)) {
 		cdns->version  = CDNS3_CONTROLLER_V0;
 		cdns->otg_v1_regs = NULL;
+		cdns->otg_cdnsp_regs = NULL;
 		cdns->otg_regs = regs;
+		cdns->otg_irq_regs = (struct cdns3_otg_irq_regs *)
+				     &cdns->otg_v0_regs->ien;
 		writel(1, &cdns->otg_v0_regs->simulate);
 		dev_dbg(cdns->dev, "DRD version v0 (%08x)\n",
 			 readl(&cdns->otg_v0_regs->version));
 	} else {
 		cdns->otg_v0_regs = NULL;
 		cdns->otg_v1_regs = regs;
+		cdns->otg_cdnsp_regs = regs;
+
 		cdns->otg_regs = (void *)&cdns->otg_v1_regs->cmd;
-		cdns->version  = CDNS3_CONTROLLER_V1;
-		writel(1, &cdns->otg_v1_regs->simulate);
+
+		if (cdns->otg_cdnsp_regs->did == OTG_CDNSP_DID) {
+			cdns->otg_irq_regs = (struct cdns3_otg_irq_regs *)
+					      &cdns->otg_cdnsp_regs->ien;
+			cdns->version  = CDNSP_CONTROLLER_V2;
+		} else {
+			cdns->otg_irq_regs = (struct cdns3_otg_irq_regs *)
+					      &cdns->otg_v1_regs->ien;
+			writel(1, &cdns->otg_v1_regs->simulate);
+			cdns->version  = CDNS3_CONTROLLER_V1;
+		}
+
 		dev_dbg(cdns->dev, "DRD version v1 (ID: %08x, rev: %08x)\n",
 			 readl(&cdns->otg_v1_regs->did),
 			 readl(&cdns->otg_v1_regs->rid));
@@ -378,10 +412,17 @@ int cdns3_drd_init(struct cdns3 *cdns)
 
 	/* Update dr_mode according to STRAP configuration. */
 	cdns->dr_mode = USB_DR_MODE_OTG;
-	if (state == OTGSTS_STRAP_HOST) {
+
+	if ((cdns->version == CDNSP_CONTROLLER_V2 &&
+	     state == OTGSTS_CDNSP_STRAP_HOST) ||
+	    (cdns->version != CDNSP_CONTROLLER_V2 &&
+	     state == OTGSTS_STRAP_HOST)) {
 		dev_dbg(cdns->dev, "Controller strapped to HOST\n");
 		cdns->dr_mode = USB_DR_MODE_HOST;
-	} else if (state == OTGSTS_STRAP_GADGET) {
+	} else if ((cdns->version == CDNSP_CONTROLLER_V2 &&
+		    state == OTGSTS_CDNSP_STRAP_GADGET) ||
+		   (cdns->version != CDNSP_CONTROLLER_V2 &&
+		    state == OTGSTS_STRAP_GADGET)) {
 		dev_dbg(cdns->dev, "Controller strapped to PERIPHERAL\n");
 		cdns->dr_mode = USB_DR_MODE_PERIPHERAL;
 	}
diff --git a/drivers/usb/cdns3/drd.h b/drivers/usb/cdns3/drd.h
index f1ccae285a16..a767b6893938 100644
--- a/drivers/usb/cdns3/drd.h
+++ b/drivers/usb/cdns3/drd.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Cadence USB3 DRD header file.
+ * Cadence USB3 and USBSSP DRD header file.
  *
- * Copyright (C) 2018-2019 Cadence.
+ * Copyright (C) 2018-2020 Cadence.
  *
  * Author: Pawel Laszczak <pawell@cadence.com>
  */
@@ -13,7 +13,7 @@
 #include <linux/phy/phy.h>
 #include "core.h"
 
-/*  DRD register interface for version v1. */
+/*  DRD register interface for version v1 of cdns3 driver. */
 struct cdns3_otg_regs {
 	__le32 did;
 	__le32 rid;
@@ -38,7 +38,7 @@ struct cdns3_otg_regs {
 	__le32 ctrl2;
 };
 
-/*  DRD register interface for version v0. */
+/*  DRD register interface for version v0 of cdns3 driver. */
 struct cdns3_otg_legacy_regs {
 	__le32 cmd;
 	__le32 sts;
@@ -57,14 +57,45 @@ struct cdns3_otg_legacy_regs {
 	__le32 ctrl1;
 };
 
+/* DRD register interface for cdnsp driver */
+struct cdnsp_otg_regs {
+	__le32 did;
+	__le32 rid;
+	__le32 cfgs1;
+	__le32 cfgs2;
+	__le32 cmd;
+	__le32 sts;
+	__le32 state;
+	__le32 ien;
+	__le32 ivect;
+	__le32 tmr;
+	__le32 simulate;
+	__le32 adpbc_sts;
+	__le32 adp_ramp_time;
+	__le32 adpbc_ctrl1;
+	__le32 adpbc_ctrl2;
+	__le32 override;
+	__le32 vbusvalid_dbnc_cfg;
+	__le32 sessvalid_dbnc_cfg;
+	__le32 susp_timing_ctrl;
+};
+
+#define OTG_CDNSP_DID	0x0004034E
+
 /*
- * Common registers interface for both version of DRD.
+ * Common registers interface for both CDNS3 and CDNSP version of DRD.
  */
 struct cdns3_otg_common_regs {
 	__le32 cmd;
 	__le32 sts;
 	__le32 state;
-	__le32 different1;
+};
+
+/*
+ * Interrupt related registers. This registers are mapped in different
+ * location for CDNSP controller.
+ */
+struct cdns3_otg_irq_regs {
 	__le32 ien;
 	__le32 ivect;
 };
@@ -92,9 +123,9 @@ struct cdns3_otg_common_regs {
 #define OTGCMD_DEV_BUS_DROP		BIT(8)
 /* Drop the bus for Host mode*/
 #define OTGCMD_HOST_BUS_DROP		BIT(9)
-/* Power Down USBSS-DEV. */
+/* Power Down USBSS-DEV - only for CDNS3.*/
 #define OTGCMD_DEV_POWER_OFF		BIT(11)
-/* Power Down CDNSXHCI. */
+/* Power Down CDNSXHCI - only for CDNS3. */
 #define OTGCMD_HOST_POWER_OFF		BIT(12)
 
 /* OTGIEN - bitmasks */
@@ -123,20 +154,31 @@ struct cdns3_otg_common_regs {
 #define OTGSTS_OTG_NRDY_MASK		BIT(11)
 #define OTGSTS_OTG_NRDY(p)		((p) & OTGSTS_OTG_NRDY_MASK)
 /*
- * Value of the strap pins.
+ * Value of the strap pins for:
+ * CDNS3:
  * 000 - no default configuration
  * 010 - Controller initiall configured as Host
  * 100 - Controller initially configured as Device
+ * CDNSP:
+ * 000 - No default configuration.
+ * 010 - Controller initiall configured as Host.
+ * 100 - Controller initially configured as Device.
  */
 #define OTGSTS_STRAP(p)			(((p) & GENMASK(14, 12)) >> 12)
 #define OTGSTS_STRAP_NO_DEFAULT_CFG	0x00
 #define OTGSTS_STRAP_HOST_OTG		0x01
 #define OTGSTS_STRAP_HOST		0x02
 #define OTGSTS_STRAP_GADGET		0x04
+#define OTGSTS_CDNSP_STRAP_HOST		0x01
+#define OTGSTS_CDNSP_STRAP_GADGET	0x02
+
 /* Host mode is turned on. */
-#define OTGSTS_XHCI_READY		BIT(26)
+#define OTGSTS_CDNS3_XHCI_READY		BIT(26)
+#define OTGSTS_CDNSP_XHCI_READY		BIT(27)
+
 /* "Device mode is turned on .*/
-#define OTGSTS_DEV_READY		BIT(27)
+#define OTGSTS_CDNS3_DEV_READY		BIT(27)
+#define OTGSTS_CDNSP_DEV_READY		BIT(26)
 
 /* OTGSTATE- bitmasks */
 #define OTGSTATE_DEV_STATE_MASK		GENMASK(2, 0)
@@ -152,6 +194,8 @@ struct cdns3_otg_common_regs {
 #define OVERRIDE_IDPULLUP		BIT(0)
 /* Only for CDNS3_CONTROLLER_V0 version */
 #define OVERRIDE_IDPULLUP_V0		BIT(24)
+/* Vbusvalid/Sesvalid override select. */
+#define OVERRIDE_SESS_VLD_SEL		BIT(10)
 
 /* PHYRST_CFG - bitmasks */
 #define PHYRST_CFG_PHYRST_A_ENABLE     BIT(0)
@@ -170,6 +214,5 @@ int cdns3_drd_gadget_on(struct cdns3 *cdns);
 void cdns3_drd_gadget_off(struct cdns3 *cdns);
 int cdns3_drd_host_on(struct cdns3 *cdns);
 void cdns3_drd_host_off(struct cdns3 *cdns);
-int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode);
 
 #endif /* __LINUX_CDNS3_DRD */
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 90bb022737da..ee7b71827216 100644
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
index 347ba7e4bd81..a9a43d649478 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -752,7 +752,7 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
 	return 0;
 }
 
-static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep)
+static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep, int status)
 {
 	struct dwc3_request		*req;
 
@@ -762,19 +762,19 @@ static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep)
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
 
@@ -803,18 +803,18 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
+	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
+
+	dep->stream_capable = false;
+	dep->type = 0;
+	dep->flags = 0;
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
-	dep->flags = 0;
-
 	return 0;
 }
 
@@ -2067,7 +2067,7 @@ static void dwc3_stop_active_transfers(struct dwc3 *dwc)
 		if (!dep)
 			continue;
 
-		dwc3_remove_requests(dwc, dep);
+		dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 	}
 }
 
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 9db557b76511..804d8f4d0e73 100644
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
index b5e9bfe884c4..d0c31651ec80 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2811,6 +2811,8 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
 		}
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
 		ret = -EFAULT;
 
@@ -2903,6 +2905,8 @@ static int btrfs_ioctl_get_subvol_rootref(struct file *file, void __user *argp)
 	}
 
 out:
+	btrfs_free_path(path);
+
 	if (!ret || ret == -EOVERFLOW) {
 		rootrefs->num_items = found;
 		/* update min_treeid for next search */
@@ -2914,7 +2918,6 @@ static int btrfs_ioctl_get_subvol_rootref(struct file *file, void __user *argp)
 	}
 
 	kfree(rootrefs);
-	btrfs_free_path(path);
 
 	return ret;
 }
@@ -3878,6 +3881,8 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 		ipath->fspath->val[i] = rel_ptr;
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	ret = copy_to_user((void __user *)(unsigned long)ipa->fspath,
 			   ipath->fspath, size);
 	if (ret) {
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3bb6b688ece5..ecf190286377 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1767,8 +1767,11 @@ int __init btrfs_init_sysfs(void)
 
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
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 76e43a487bc6..51562d36fa83 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2294,6 +2294,7 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
  */
 static int unsafe_request_wait(struct inode *inode)
 {
+	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
 	int ret, err = 0;
@@ -2313,6 +2314,76 @@ static int unsafe_request_wait(struct inode *inode)
 	}
 	spin_unlock(&ci->i_unsafe_lock);
 
+	/*
+	 * Trigger to flush the journal logs in all the relevant MDSes
+	 * manually, or in the worst case we must wait at most 5 seconds
+	 * to wait the journal logs to be flushed by the MDSes periodically.
+	 */
+	if (req1 || req2) {
+		struct ceph_mds_request *req;
+		struct ceph_mds_session **sessions;
+		struct ceph_mds_session *s;
+		unsigned int max_sessions;
+		int i;
+
+		mutex_lock(&mdsc->mutex);
+		max_sessions = mdsc->max_sessions;
+
+		sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
+		if (!sessions) {
+			mutex_unlock(&mdsc->mutex);
+			err = -ENOMEM;
+			goto out;
+		}
+
+		spin_lock(&ci->i_unsafe_lock);
+		if (req1) {
+			list_for_each_entry(req, &ci->i_unsafe_dirops,
+					    r_unsafe_dir_item) {
+				s = req->r_session;
+				if (!s)
+					continue;
+				if (!sessions[s->s_mds]) {
+					s = ceph_get_mds_session(s);
+					sessions[s->s_mds] = s;
+				}
+			}
+		}
+		if (req2) {
+			list_for_each_entry(req, &ci->i_unsafe_iops,
+					    r_unsafe_target_item) {
+				s = req->r_session;
+				if (!s)
+					continue;
+				if (!sessions[s->s_mds]) {
+					s = ceph_get_mds_session(s);
+					sessions[s->s_mds] = s;
+				}
+			}
+		}
+		spin_unlock(&ci->i_unsafe_lock);
+
+		/* the auth MDS */
+		spin_lock(&ci->i_ceph_lock);
+		if (ci->i_auth_cap) {
+			s = ci->i_auth_cap->session;
+			if (!sessions[s->s_mds])
+				sessions[s->s_mds] = ceph_get_mds_session(s);
+		}
+		spin_unlock(&ci->i_ceph_lock);
+		mutex_unlock(&mdsc->mutex);
+
+		/* send flush mdlog request to MDSes */
+		for (i = 0; i < max_sessions; i++) {
+			s = sessions[i];
+			if (s) {
+				send_flush_mdlog(s);
+				ceph_put_mds_session(s);
+			}
+		}
+		kfree(sessions);
+	}
+
 	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
 	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
 	if (req1) {
@@ -2320,15 +2391,19 @@ static int unsafe_request_wait(struct inode *inode)
 					ceph_timeout_jiffies(req1->r_timeout));
 		if (ret)
 			err = -EIO;
-		ceph_mdsc_put_request(req1);
 	}
 	if (req2) {
 		ret = !wait_for_completion_timeout(&req2->r_safe_completion,
 					ceph_timeout_jiffies(req2->r_timeout));
 		if (ret)
 			err = -EIO;
-		ceph_mdsc_put_request(req2);
 	}
+
+out:
+	if (req1)
+		ceph_mdsc_put_request(req1);
+	if (req2)
+		ceph_mdsc_put_request(req2);
 	return err;
 }
 
@@ -4310,33 +4385,9 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
 	dout("flush_dirty_caps done\n");
 }
 
-static void iterate_sessions(struct ceph_mds_client *mdsc,
-			     void (*cb)(struct ceph_mds_session *))
-{
-	int mds;
-
-	mutex_lock(&mdsc->mutex);
-	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
-		struct ceph_mds_session *s;
-
-		if (!mdsc->sessions[mds])
-			continue;
-
-		s = ceph_get_mds_session(mdsc->sessions[mds]);
-		if (!s)
-			continue;
-
-		mutex_unlock(&mdsc->mutex);
-		cb(s);
-		ceph_put_mds_session(s);
-		mutex_lock(&mdsc->mutex);
-	}
-	mutex_unlock(&mdsc->mutex);
-}
-
 void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
 {
-	iterate_sessions(mdsc, flush_dirty_session_caps);
+	ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, true);
 }
 
 void __ceph_touch_fmode(struct ceph_inode_info *ci,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 6859967df2b1..fa51872ff850 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -809,6 +809,33 @@ static void put_request_session(struct ceph_mds_request *req)
 	}
 }
 
+void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
+				void (*cb)(struct ceph_mds_session *),
+				bool check_state)
+{
+	int mds;
+
+	mutex_lock(&mdsc->mutex);
+	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
+		struct ceph_mds_session *s;
+
+		s = __ceph_lookup_mds_session(mdsc, mds);
+		if (!s)
+			continue;
+
+		if (check_state && !check_session_state(s)) {
+			ceph_put_mds_session(s);
+			continue;
+		}
+
+		mutex_unlock(&mdsc->mutex);
+		cb(s);
+		ceph_put_mds_session(s);
+		mutex_lock(&mdsc->mutex);
+	}
+	mutex_unlock(&mdsc->mutex);
+}
+
 void ceph_mdsc_release_request(struct kref *kref)
 {
 	struct ceph_mds_request *req = container_of(kref,
@@ -1157,7 +1184,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 /*
  * session messages
  */
-static struct ceph_msg *create_session_msg(u32 op, u64 seq)
+struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq)
 {
 	struct ceph_msg *msg;
 	struct ceph_mds_session_head *h;
@@ -1165,7 +1192,8 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h), GFP_NOFS,
 			   false);
 	if (!msg) {
-		pr_err("create_session_msg ENOMEM creating msg\n");
+		pr_err("ENOMEM creating session %s msg\n",
+		       ceph_session_op_name(op));
 		return NULL;
 	}
 	h = msg->front.iov_base;
@@ -1299,7 +1327,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
 			   GFP_NOFS, false);
 	if (!msg) {
-		pr_err("create_session_msg ENOMEM creating msg\n");
+		pr_err("ENOMEM creating session open msg\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	p = msg->front.iov_base;
@@ -1833,8 +1861,8 @@ static int send_renew_caps(struct ceph_mds_client *mdsc,
 
 	dout("send_renew_caps to mds%d (%s)\n", session->s_mds,
 		ceph_mds_state_name(state));
-	msg = create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
-				 ++session->s_renew_seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
+				      ++session->s_renew_seq);
 	if (!msg)
 		return -ENOMEM;
 	ceph_con_send(&session->s_con, msg);
@@ -1848,7 +1876,7 @@ static int send_flushmsg_ack(struct ceph_mds_client *mdsc,
 
 	dout("send_flushmsg_ack to mds%d (%s)s seq %lld\n",
 	     session->s_mds, ceph_session_state_name(session->s_state), seq);
-	msg = create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
 	if (!msg)
 		return -ENOMEM;
 	ceph_con_send(&session->s_con, msg);
@@ -1900,7 +1928,8 @@ static int request_close_session(struct ceph_mds_session *session)
 	dout("request_close_session mds%d state %s seq %lld\n",
 	     session->s_mds, ceph_session_state_name(session->s_state),
 	     session->s_seq);
-	msg = create_session_msg(CEPH_SESSION_REQUEST_CLOSE, session->s_seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_CLOSE,
+				      session->s_seq);
 	if (!msg)
 		return -ENOMEM;
 	ceph_con_send(&session->s_con, msg);
@@ -4375,24 +4404,12 @@ void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
 }
 
 /*
- * lock unlock sessions, to wait ongoing session activities
+ * lock unlock the session, to wait ongoing session activities
  */
-static void lock_unlock_sessions(struct ceph_mds_client *mdsc)
+static void lock_unlock_session(struct ceph_mds_session *s)
 {
-	int i;
-
-	mutex_lock(&mdsc->mutex);
-	for (i = 0; i < mdsc->max_sessions; i++) {
-		struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
-		if (!s)
-			continue;
-		mutex_unlock(&mdsc->mutex);
-		mutex_lock(&s->s_mutex);
-		mutex_unlock(&s->s_mutex);
-		ceph_put_mds_session(s);
-		mutex_lock(&mdsc->mutex);
-	}
-	mutex_unlock(&mdsc->mutex);
+	mutex_lock(&s->s_mutex);
+	mutex_unlock(&s->s_mutex);
 }
 
 static void maybe_recover_session(struct ceph_mds_client *mdsc)
@@ -4647,6 +4664,30 @@ static void wait_requests(struct ceph_mds_client *mdsc)
 	dout("wait_requests done\n");
 }
 
+void send_flush_mdlog(struct ceph_mds_session *s)
+{
+	struct ceph_msg *msg;
+
+	/*
+	 * Pre-luminous MDS crashes when it sees an unknown session request
+	 */
+	if (!CEPH_HAVE_FEATURE(s->s_con.peer_features, SERVER_LUMINOUS))
+		return;
+
+	mutex_lock(&s->s_mutex);
+	dout("request mdlog flush to mds%d (%s)s seq %lld\n", s->s_mds,
+	     ceph_session_state_name(s->s_state), s->s_seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_FLUSH_MDLOG,
+				      s->s_seq);
+	if (!msg) {
+		pr_err("failed to request mdlog flush to mds%d (%s) seq %lld\n",
+		       s->s_mds, ceph_session_state_name(s->s_state), s->s_seq);
+	} else {
+		ceph_con_send(&s->s_con, msg);
+	}
+	mutex_unlock(&s->s_mutex);
+}
+
 /*
  * called before mount is ro, and before dentries are torn down.
  * (hmm, does this still race with new lookups?)
@@ -4656,7 +4697,8 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 	dout("pre_umount\n");
 	mdsc->stopping = 1;
 
-	lock_unlock_sessions(mdsc);
+	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
+	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
 	ceph_flush_dirty_caps(mdsc);
 	wait_requests(mdsc);
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index acf33d7192bb..a92e42e8a9f8 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -518,6 +518,11 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
 	kref_put(&req->r_kref, ceph_mdsc_release_request);
 }
 
+extern void send_flush_mdlog(struct ceph_mds_session *s);
+extern void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
+				       void (*cb)(struct ceph_mds_session *),
+				       bool check_state);
+extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
 extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
 				    struct ceph_cap *cap);
 extern void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 0369f672a76f..734873be56a7 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -697,9 +697,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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
 
@@ -707,6 +708,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
+	realm = NULL;
+	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
 	p += sizeof(*ri);
@@ -730,7 +733,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	err = adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
 	if (err < 0)
 		goto fail;
-	invalidate += err;
+	rebuild_snapcs += err;
 
 	if (le64_to_cpu(ri->seq) > realm->seq) {
 		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
@@ -755,22 +758,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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
diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
index 4a79f3632260..573bb9556fb5 100644
--- a/fs/ceph/strings.c
+++ b/fs/ceph/strings.c
@@ -46,6 +46,7 @@ const char *ceph_session_op_name(int op)
 	case CEPH_SESSION_FLUSHMSG_ACK: return "flushmsg_ack";
 	case CEPH_SESSION_FORCE_RO: return "force_ro";
 	case CEPH_SESSION_REJECT: return "reject";
+	case CEPH_SESSION_REQUEST_FLUSH_MDLOG: return "flush_mdlog";
 	}
 	return "???";
 }
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 30add5a3df3d..54750b7c162d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5182,6 +5182,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	 * and it is decreased till we reach start.
 	 */
 again:
+	ret = 0;
 	if (SHIFT == SHIFT_LEFT)
 		iterator = &start;
 	else
@@ -5225,14 +5226,21 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
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
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 253308fcb047..504389568dac 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3275,10 +3275,9 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		.mode = mode
 	};
 	int err;
-	bool lock_inode = !(mode & FALLOC_FL_KEEP_SIZE) ||
-			   (mode & FALLOC_FL_PUNCH_HOLE);
-
-	bool block_faults = FUSE_IS_DAX(inode) && lock_inode;
+	bool block_faults = FUSE_IS_DAX(inode) &&
+		(!(mode & FALLOC_FL_KEEP_SIZE) ||
+		 (mode & FALLOC_FL_PUNCH_HOLE));
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
@@ -3286,22 +3285,20 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (fm->fc->no_fallocate)
 		return -EOPNOTSUPP;
 
-	if (lock_inode) {
-		inode_lock(inode);
-		if (block_faults) {
-			down_write(&fi->i_mmap_sem);
-			err = fuse_dax_break_layouts(inode, 0, 0);
-			if (err)
-				goto out;
-		}
+	inode_lock(inode);
+	if (block_faults) {
+		down_write(&fi->i_mmap_sem);
+		err = fuse_dax_break_layouts(inode, 0, 0);
+		if (err)
+			goto out;
+	}
 
-		if (mode & FALLOC_FL_PUNCH_HOLE) {
-			loff_t endbyte = offset + length - 1;
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
@@ -3351,8 +3348,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (block_faults)
 		up_write(&fi->i_mmap_sem);
 
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
index bf5cb6efb8c0..475d23a4f8da 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -440,14 +440,22 @@ static void __zonefs_io_error(struct inode *inode, bool write)
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
@@ -1364,6 +1372,14 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
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
@@ -1406,11 +1422,11 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
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
@@ -1435,7 +1451,7 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
 dput:
 	dput(dentry);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 struct zonefs_zone_data {
@@ -1455,7 +1471,7 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
 	struct blk_zone *zone, *next, *end;
 	const char *zgroup_name;
 	char *file_name;
-	struct dentry *dir;
+	struct dentry *dir, *dent;
 	unsigned int n = 0;
 	int ret;
 
@@ -1473,8 +1489,8 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
 		zgroup_name = "seq";
 
 	dir = zonefs_create_inode(sb->s_root, zgroup_name, NULL, type);
-	if (!dir) {
-		ret = -ENOMEM;
+	if (IS_ERR(dir)) {
+		ret = PTR_ERR(dir);
 		goto free;
 	}
 
@@ -1520,8 +1536,9 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
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
 
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 455e9b9e2adf..8287382d3d1d 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -288,6 +288,7 @@ enum {
 	CEPH_SESSION_FLUSHMSG_ACK,
 	CEPH_SESSION_FORCE_RO,
 	CEPH_SESSION_REJECT,
+	CEPH_SESSION_REQUEST_FLUSH_MDLOG,
 };
 
 extern const char *ceph_session_op_name(int op);
diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index ab192720e2d6..53c9a17ecb3e 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -198,6 +198,9 @@ struct ip_set_region {
 	u32 elements;		/* Number of elements vs timeout */
 };
 
+/* Max range where every element is added/deleted in one step */
+#define IPSET_MAX_RANGE		(1<<20)
+
 /* The core set type structure */
 struct ip_set_type {
 	struct list_head list;
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 8528015590e4..afdf8bd1b4fe 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -38,6 +38,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_PORT_MROUTER,
 	SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME,
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
+	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
@@ -57,6 +58,7 @@ struct switchdev_attr {
 		bool mrouter;				/* PORT_MROUTER */
 		clock_t ageing_time;			/* BRIDGE_AGEING_TIME */
 		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
+		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
 		bool mc_disabled;			/* MC_DISABLED */
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
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
index cd2d8279a5e4..cb4e8e6e86a9 100644
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
index 22912631d79b..eba883d6d9ed 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -71,7 +71,7 @@ config CC_HAS_ASM_GOTO_OUTPUT
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	depends on CC_HAS_ASM_GOTO_OUTPUT
 	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
-	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
+	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
 
 config TOOLS_SUPPORT_RELR
 	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
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
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 92d94615cbbb..3cb29835632f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -223,11 +223,16 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
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
@@ -249,24 +254,34 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
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
index d217acc9f71b..b47d95b68ac1 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -456,6 +456,13 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
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
index f2817e80a1ab..51ccd80e70b6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2439,8 +2439,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	enum lru_list lru;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	bool proportional_reclaim;
 	struct blk_plug plug;
-	bool scan_adjusted;
 
 	get_scan_count(lruvec, sc, nr);
 
@@ -2458,8 +2458,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	 * abort proportional reclaim if either the file or anon lru has already
 	 * dropped to zero at the first pass.
 	 */
-	scan_adjusted = (!cgroup_reclaim(sc) && !current_is_kswapd() &&
-			 sc->priority == DEF_PRIORITY);
+	proportional_reclaim = (!cgroup_reclaim(sc) && !current_is_kswapd() &&
+				sc->priority == DEF_PRIORITY);
 
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
@@ -2479,7 +2479,7 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 
 		cond_resched();
 
-		if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
+		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
 			continue;
 
 		/*
@@ -2530,8 +2530,6 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		nr_scanned = targets[lru] - nr[lru];
 		nr[lru] = targets[lru] * (100 - percentage) / 100;
 		nr[lru] -= min(nr[lru], nr_scanned);
-
-		scan_adjusted = true;
 	}
 	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index fec6c800c898..400219801e63 100644
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
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 852f4b54e881..1dc5db07650c 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -855,26 +855,37 @@ EXPORT_SYMBOL_GPL(br_vlan_get_proto);
 
 int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 {
+	struct switchdev_attr attr = {
+		.orig_dev = br->dev,
+		.id = SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
+		.flags = SWITCHDEV_F_SKIP_EOPNOTSUPP,
+		.u.vlan_protocol = ntohs(proto),
+	};
 	int err = 0;
 	struct net_bridge_port *p;
 	struct net_bridge_vlan *vlan;
 	struct net_bridge_vlan_group *vg;
-	__be16 oldproto;
+	__be16 oldproto = br->vlan_proto;
 
 	if (br->vlan_proto == proto)
 		return 0;
 
+	err = switchdev_port_attr_set(br->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	/* Add VLANs for the new proto to the device filter. */
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
 		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			err = vlan_vid_add(p->dev, proto, vlan->vid);
 			if (err)
 				goto err_filt;
 		}
 	}
 
-	oldproto = br->vlan_proto;
 	br->vlan_proto = proto;
 
 	recalculate_group_addr(br);
@@ -883,20 +894,32 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 	/* Delete VLANs for the old proto from the device filter. */
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			vlan_vid_del(p->dev, oldproto, vlan->vid);
+		}
 	}
 
 	return 0;
 
 err_filt:
-	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
+	attr.u.vlan_protocol = ntohs(oldproto);
+	switchdev_port_attr_set(br->dev, &attr);
+
+	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist) {
+		if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+			continue;
 		vlan_vid_del(p->dev, proto, vlan->vid);
+	}
 
 	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			vlan_vid_del(p->dev, proto, vlan->vid);
+		}
 	}
 
 	return err;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index ed120828c7e2..b8d082f55718 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -263,7 +263,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
 	key->ct_zone = ct->zone.id;
 #endif
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
-	key->ct_mark = ct->mark;
+	key->ct_mark = READ_ONCE(ct->mark);
 #endif
 
 	cl = nf_ct_labels_find(ct);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 2455b0c0e486..a2a8b952b3c5 100644
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
index 2be5c69824f9..21c61a9c3b15 100644
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
index 3450c9ba2728..84257678160a 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -312,6 +312,9 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 			xo->seq.low += skb_shinfo(skb)->gso_segs;
 	}
 
+	if (xo->seq.low < seq)
+		xo->seq.hi++;
+
 	esp.seqno = cpu_to_be64(seq + ((u64)xo->seq.hi << 32));
 
 	ip_hdr(skb)->tot_len = htons(skb->len);
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index a28f525e2c47..d11fb16234a6 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1331,8 +1331,10 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 
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
index c0de655fffd7..c68a1dae25ca 100644
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
index f6b3237e88ca..eccd7897e7aa 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -361,6 +361,11 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
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
index 1088564d4dbc..77e3b67e8790 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -424,7 +424,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 	switch (ctinfo) {
 	case IP_CT_NEW:
-		ct->mark = hash;
+		WRITE_ONCE(ct->mark, hash);
 		break;
 	case IP_CT_RELATED:
 	case IP_CT_RELATED_REPLY:
@@ -441,7 +441,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 #ifdef DEBUG
 	nf_ct_dump_tuple_ip(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
-	pr_debug("hash=%u ct_hash=%u ", hash, ct->mark);
+	pr_debug("hash=%u ct_hash=%u ", hash, READ_ONCE(ct->mark));
 	if (!clusterip_responsible(cipinfo->config, hash)) {
 		pr_debug("not responsible\n");
 		return NF_DROP;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 31a8009f74ee..8bd7b1ec3b6a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -322,6 +322,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * if necessary.
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 1c3f02d05d2b..7608be04d0f5 100644
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
index a558dd9d177b..c599e14be414 100644
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
index 05e271098888..8bc7d399987b 100644
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
index 73893025922f..ae90ac3be59a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1349,8 +1349,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
@@ -1420,8 +1422,10 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
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
index 870c8eafef92..c2b051e0610a 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -718,7 +718,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
 			     struct sk_buff *skb)
 {
-	kfree_skb(skb);
+	ieee80211_free_txskb(&sdata->local->hw, skb);
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
 
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 5d6d68eaf6a9..d7a81b2250e7 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -131,8 +131,11 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (ip_to == 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -143,18 +146,20 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
 
-	if (retried) {
+	/* 64bit division is not allowed on 32bit */
+	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
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
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index aba1df617d6e..eefce34a34f0 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -120,6 +120,8 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	e.mark = ntohl(nla_get_be32(tb[IPSET_ATTR_MARK]));
 	e.mark &= h->markmask;
+	if (e.mark == 0 && e.ip == 0)
+		return -IPSET_ERR_HASH_ELEM;
 
 	if (adt == IPSET_TEST ||
 	    !(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_CIDR])) {
@@ -132,8 +134,11 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (e.mark == 0 && ip_to == 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -142,6 +147,9 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
+	if (((u64)ip_to - ip + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 1ff228717e29..4a54e9e8ae59 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -172,6 +172,9 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index fa88afd812fa..09737de5ecc3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -179,6 +179,9 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index eef6ecfcb409..02685371a682 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -252,6 +252,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 136cf0781d3a..9d1beaacb973 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -139,7 +139,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = { .cidr = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0;
+	u32 ip = 0, ip_to = 0, ipn, n = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -187,6 +187,15 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index be5e95a0d876..c3ada9c63fa3 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -201,7 +201,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0;
+	u32 ip = 0, ip_to = 0, ipn, n = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -255,6 +255,14 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index da4ef910b12d..b1411bc91a40 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -167,7 +167,8 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0;
-	u32 ip2 = 0, ip2_from = 0, ip2_to = 0;
+	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, ipn;
+	u64 n = 0, m = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -243,6 +244,19 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn = ip2_from;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 34448df80fb9..d26d13528fe8 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -157,7 +157,8 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 port, port_to, p = 0, ip = 0, ip_to = 0;
+	u32 port, port_to, p = 0, ip = 0, ip_to = 0, ipn;
+	u64 n = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -234,6 +235,14 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 934c1712cba8..6446f4fccc72 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -181,7 +181,8 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2;
+	u32 ip2_from = 0, ip2_to = 0, ip2, ipn;
+	u64 n = 0, m = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -283,6 +284,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn = ip2_from;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8369af0c50ea..193a18bfddc0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1598,7 +1598,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-			ct->mark = exp->master->mark;
+			ct->mark = READ_ONCE(exp->master->mark);
 #endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 			ct->secmark = exp->master->secmark;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9e6898164199..c402283e7545 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -317,9 +317,9 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_mark(struct sk_buff *skb, u32 mark)
 {
-	if (nla_put_be32(skb, CTA_MARK, htonl(ct->mark)))
+	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
 		goto nla_put_failure;
 	return 0;
 
@@ -532,7 +532,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, READ_ONCE(ct->mark)) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -711,6 +711,7 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
+	u32 mark;
 	int err;
 
 	if (events & (1 << IPCT_DESTROY)) {
@@ -811,8 +812,9 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
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
@@ -1099,7 +1101,7 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((ct->mark & filter->mark.mask) != filter->mark.val)
+	if ((READ_ONCE(ct->mark) & filter->mark.mask) != filter->mark.val)
 		goto ignore_entry;
 #endif
 
@@ -1979,9 +1981,9 @@ static void ctnetlink_change_mark(struct nf_conn *ct,
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
 
@@ -2669,6 +2671,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
+	u32 mark;
 
 	zone = nf_ct_zone(ct);
 
@@ -2726,7 +2729,8 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (ct->mark && ctnetlink_dump_mark(skb, ct) < 0)
+	mark = READ_ONCE(ct->mark);
+	if (mark && ctnetlink_dump_mark(skb, mark) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 313d1c8ff066..a7f88cdf3f87 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -360,7 +360,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	seq_printf(s, "mark=%u ", ct->mark);
+	seq_printf(s, "mark=%u ", READ_ONCE(ct->mark));
 #endif
 
 	ct_show_secctx(s, ct);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index d1862782be45..28306cb66719 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -910,6 +910,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	struct flow_block_cb *block_cb, *next;
 	int err = 0;
 
+	down_write(&flowtable->flow_block_lock);
 	switch (cmd) {
 	case FLOW_BLOCK_BIND:
 		list_splice(&bo->cb_list, &flowtable->flow_block.cb_list);
@@ -924,6 +925,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 		WARN_ON_ONCE(1);
 		err = -EOPNOTSUPP;
 	}
+	up_write(&flowtable->flow_block_lock);
 
 	return err;
 }
@@ -980,7 +982,9 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
+	down_write(&flowtable->flow_block_lock);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
+	up_write(&flowtable->flow_block_lock);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 781118465d46..14093d86e682 100644
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
@@ -294,8 +294,8 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
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
index 2cfff70f70e0..ed9019d807c7 100644
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
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 41f248895a87..0f0f380e81a4 100644
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
@@ -336,9 +336,9 @@ static int ovs_ct_set_mark(struct nf_conn *ct, struct sw_flow_key *key,
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
index 41671af6b33f..0354f90dc93a 100644
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
index ccb65412b670..d86894a1c35d 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -14,14 +14,6 @@
 #include <net/af_rxrpc.h>
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
@@ -86,7 +78,7 @@ struct rxrpc_net {
 	struct work_struct	client_conn_reaper;
 	struct timer_list	client_conn_reap_timer;
 
-	struct list_head	local_endpoints;
+	struct hlist_head	local_endpoints;
 	struct mutex		local_mutex;	/* Lock for ->local_endpoints */
 
 	DECLARE_HASHTABLE	(peer_hash, 10);
@@ -264,9 +256,9 @@ struct rxrpc_security {
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
@@ -289,7 +281,7 @@ struct rxrpc_local {
  */
 struct rxrpc_peer {
 	struct rcu_head		rcu;		/* This must be first */
-	atomic_t		usage;
+	refcount_t		ref;
 	unsigned long		hash_key;
 	struct hlist_node	hash_link;
 	struct rxrpc_local	*local;
@@ -391,7 +383,8 @@ enum rxrpc_conn_proto_state {
  */
 struct rxrpc_bundle {
 	struct rxrpc_conn_parameters params;
-	atomic_t		usage;
+	refcount_t		ref;
+	atomic_t		active;		/* Number of active users */
 	unsigned int		debug_id;
 	bool			try_upgrade;	/* True if the bundle is attempting upgrade */
 	bool			alloc_conn;	/* True if someone's getting a conn */
@@ -412,7 +405,7 @@ struct rxrpc_connection {
 	struct rxrpc_conn_proto	proto;
 	struct rxrpc_conn_parameters params;
 
-	atomic_t		usage;
+	refcount_t		ref;
 	struct rcu_head		rcu;
 	struct list_head	cache_link;
 
@@ -592,7 +585,7 @@ struct rxrpc_call {
 	int			error;		/* Local error incurred */
 	enum rxrpc_call_state	state;		/* current state of call */
 	enum rxrpc_call_completion completion;	/* Call completion condition */
-	atomic_t		usage;
+	refcount_t		ref;
 	u16			service_id;	/* service ID */
 	u8			security_ix;	/* Security type */
 	enum rxrpc_interruptibility interruptibility; /* At what point call may be interrupted */
@@ -1001,6 +994,7 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *);
 extern const struct seq_operations rxrpc_call_seq_ops;
 extern const struct seq_operations rxrpc_connection_seq_ops;
 extern const struct seq_operations rxrpc_peer_seq_ops;
+extern const struct seq_operations rxrpc_local_seq_ops;
 
 /*
  * recvmsg.c
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index a0b033954cea..2a14d69b171f 100644
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
index 150cd7b2154c..10dad2834d5b 100644
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
index f5fb223aba82..f5fa5f3083bd 100644
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
@@ -199,7 +205,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	key_get(conn->params.key);
 
 	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_client,
-			 atomic_read(&conn->usage),
+			 refcount_read(&conn->ref),
 			 __builtin_return_address(0));
 
 	atomic_inc(&rxnet->nr_client_conns);
@@ -341,6 +347,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	rxrpc_free_bundle(candidate);
 found_bundle:
 	rxrpc_get_bundle(bundle);
+	atomic_inc(&bundle->active);
 	spin_unlock(&local->client_bundles_lock);
 	_leave(" = %u [found]", bundle->debug_id);
 	return bundle;
@@ -438,6 +445,7 @@ static void rxrpc_add_conn_to_bundle(struct rxrpc_bundle *bundle, gfp_t gfp)
 			if (old)
 				trace_rxrpc_client(old, -1, rxrpc_client_replace);
 			candidate->bundle_shift = shift;
+			atomic_inc(&bundle->active);
 			bundle->conns[i] = candidate;
 			for (j = 0; j < RXRPC_MAXCALLS; j++)
 				set_bit(shift + j, &bundle->avail_chans);
@@ -728,6 +736,7 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 	smp_rmb();
 
 out_put_bundle:
+	rxrpc_deactivate_bundle(bundle);
 	rxrpc_put_bundle(bundle);
 out:
 	_leave(" = %d", ret);
@@ -903,9 +912,8 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 {
 	struct rxrpc_bundle *bundle = conn->bundle;
-	struct rxrpc_local *local = bundle->params.local;
 	unsigned int bindex;
-	bool need_drop = false, need_put = false;
+	bool need_drop = false;
 	int i;
 
 	_enter("C=%x", conn->debug_id);
@@ -924,15 +932,22 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
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
@@ -942,10 +957,6 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 		if (need_put)
 			rxrpc_put_bundle(bundle);
 	}
-
-	if (need_drop)
-		rxrpc_put_connection(conn);
-	_leave("");
 }
 
 /*
@@ -972,14 +983,13 @@ void rxrpc_put_client_conn(struct rxrpc_connection *conn)
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
index 3ef05a0e90ad..d829b97550cc 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -105,7 +105,7 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 			goto not_found;
 		*_peer = peer;
 		conn = rxrpc_find_service_conn_rcu(peer, skb);
-		if (!conn || atomic_read(&conn->usage) == 0)
+		if (!conn || refcount_read(&conn->ref) == 0)
 			goto not_found;
 		_leave(" = %p", conn);
 		return conn;
@@ -115,7 +115,7 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 		 */
 		conn = idr_find(&rxrpc_client_conn_ids,
 				sp->hdr.cid >> RXRPC_CIDSHIFT);
-		if (!conn || atomic_read(&conn->usage) == 0) {
+		if (!conn || refcount_read(&conn->ref) == 0) {
 			_debug("no conn");
 			goto not_found;
 		}
@@ -264,11 +264,12 @@ void rxrpc_kill_connection(struct rxrpc_connection *conn)
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
@@ -281,7 +282,7 @@ void rxrpc_see_connection(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
 	if (conn) {
-		int n = atomic_read(&conn->usage);
+		int n = refcount_read(&conn->ref);
 
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_seen, n, here);
 	}
@@ -293,9 +294,10 @@ void rxrpc_see_connection(struct rxrpc_connection *conn)
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
 
@@ -306,11 +308,11 @@ struct rxrpc_connection *
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
@@ -334,12 +336,11 @@ void rxrpc_put_service_conn(struct rxrpc_connection *conn)
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
@@ -352,9 +353,9 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 	struct rxrpc_connection *conn =
 		container_of(rcu, struct rxrpc_connection, rcu);
 
-	_enter("{%d,u=%d}", conn->debug_id, atomic_read(&conn->usage));
+	_enter("{%d,u=%d}", conn->debug_id, refcount_read(&conn->ref));
 
-	ASSERTCMP(atomic_read(&conn->usage), ==, 0);
+	ASSERTCMP(refcount_read(&conn->ref), ==, 0);
 
 	_net("DESTROY CONN %d", conn->debug_id);
 
@@ -394,8 +395,8 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 
 	write_lock(&rxnet->conn_lock);
 	list_for_each_entry_safe(conn, _p, &rxnet->service_conns, link) {
-		ASSERTCMP(atomic_read(&conn->usage), >, 0);
-		if (likely(atomic_read(&conn->usage) > 1))
+		ASSERTCMP(refcount_read(&conn->ref), >, 0);
+		if (likely(refcount_read(&conn->ref) > 1))
 			continue;
 		if (conn->state == RXRPC_CONN_SERVICE_PREALLOC)
 			continue;
@@ -407,7 +408,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 				expire_at = idle_timestamp + rxrpc_closed_conn_expiry * HZ;
 
 			_debug("reap CONN %d { u=%d,t=%ld }",
-			       conn->debug_id, atomic_read(&conn->usage),
+			       conn->debug_id, refcount_read(&conn->ref),
 			       (long)expire_at - (long)now);
 
 			if (time_before(now, expire_at)) {
@@ -420,7 +421,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 		/* The usage count sits at 1 whilst the object is unused on the
 		 * list; we reduce that to 0 to make the object unavailable.
 		 */
-		if (atomic_cmpxchg(&conn->usage, 1, 0) != 1)
+		if (!refcount_dec_if_one(&conn->ref))
 			continue;
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_reap_service, 0, NULL);
 
@@ -444,7 +445,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 				  link);
 		list_del_init(&conn->link);
 
-		ASSERTCMP(atomic_read(&conn->usage), ==, 0);
+		ASSERTCMP(refcount_read(&conn->ref), ==, 0);
 		rxrpc_kill_connection(conn);
 	}
 
@@ -472,7 +473,7 @@ void rxrpc_destroy_all_connections(struct rxrpc_net *rxnet)
 	write_lock(&rxnet->conn_lock);
 	list_for_each_entry_safe(conn, _p, &rxnet->service_conns, link) {
 		pr_err("AF_RXRPC: Leaked conn %p {%d}\n",
-		       conn, atomic_read(&conn->usage));
+		       conn, refcount_read(&conn->ref));
 		leak = true;
 	}
 	write_unlock(&rxnet->conn_lock);
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 6c847720494f..68508166bbc0 100644
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
index 1145cb14d86f..e9178115a744 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1163,8 +1163,6 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
  */
 static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 {
-	CHECK_SLAB_OKAY(&local->usage);
-
 	if (rxrpc_get_local_maybe(local)) {
 		skb_queue_tail(&local->reject_queue, skb);
 		rxrpc_queue_local(local);
@@ -1422,7 +1420,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		}
 	}
 
-	if (!call || atomic_read(&call->usage) == 0) {
+	if (!call || refcount_read(&call->ref) == 0) {
 		if (rxrpc_to_client(sp) ||
 		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
 			goto bad_message;
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index ebbf1b03b62c..2c66ee981f39 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -78,10 +78,10 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 
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
@@ -199,7 +199,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 {
 	struct rxrpc_local *local;
 	struct rxrpc_net *rxnet = rxrpc_net(net);
-	struct list_head *cursor;
+	struct hlist_node *cursor;
 	const char *age;
 	long diff;
 	int ret;
@@ -209,16 +209,12 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 
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
@@ -230,9 +226,10 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
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
@@ -249,10 +246,12 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
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
@@ -285,10 +284,10 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
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
 
@@ -298,12 +297,12 @@ struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *local)
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
@@ -317,10 +316,10 @@ void rxrpc_queue_local(struct rxrpc_local *local)
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
@@ -332,15 +331,16 @@ void rxrpc_put_local(struct rxrpc_local *local)
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
@@ -393,7 +393,7 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 	local->dead = true;
 
 	mutex_lock(&rxnet->local_mutex);
-	list_del_init(&local->link);
+	hlist_del_init_rcu(&local->link);
 	mutex_unlock(&rxnet->local_mutex);
 
 	rxrpc_clean_up_local_conns(local);
@@ -428,7 +428,7 @@ static void rxrpc_local_processor(struct work_struct *work)
 		return;
 
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
-			  atomic_read(&local->usage), NULL);
+			  refcount_read(&local->ref), NULL);
 
 	do {
 		again = false;
@@ -480,11 +480,11 @@ void rxrpc_destroy_all_locals(struct rxrpc_net *rxnet)
 
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
index cc7e30733feb..34f389975a7d 100644
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
index e2f990754f88..8967201fd8e5 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -107,7 +107,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   call->cid,
 		   call->call_id,
 		   rxrpc_is_service_call(call) ? "Svc" : "Clt",
-		   atomic_read(&call->usage),
+		   refcount_read(&call->ref),
 		   rxrpc_call_states[call->state],
 		   call->abort_code,
 		   call->debug_id,
@@ -189,7 +189,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		   conn->service_id,
 		   conn->proto.cid,
 		   rxrpc_conn_is_service(conn) ? "Svc" : "Clt",
-		   atomic_read(&conn->usage),
+		   refcount_read(&conn->ref),
 		   rxrpc_conn_states[conn->state],
 		   key_serial(conn->params.key),
 		   atomic_read(&conn->serial),
@@ -239,7 +239,7 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 		   " %3u %5u %6llus %8u %8u\n",
 		   lbuff,
 		   rbuff,
-		   atomic_read(&peer->usage),
+		   refcount_read(&peer->ref),
 		   peer->cong_cwnd,
 		   peer->mtu,
 		   now - peer->last_tx_at,
@@ -334,3 +334,72 @@ const struct seq_operations rxrpc_peer_seq_ops = {
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
index d762e89ab74f..bc4e5da76fa6 100644
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
index e19885d7fe2c..31d268eedf3f 100644
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
index f7e88d7466c3..2d41d866de3e 100644
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
@@ -843,9 +843,9 @@ static void tcf_ct_act_set_mark(struct nf_conn *ct, u32 mark, u32 mask)
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
index b20c8ce59905..06c74f22ab98 100644
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
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index 2ae268b67465..2730310249e3 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -210,7 +210,10 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
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
index 561e709ae06a..89d8a2bd30cd 100644
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
index c6a4338a0d08..65d009e3b6bb 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -657,7 +657,7 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
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
 
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index f066e016a874..edde0323799a 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1797,6 +1797,7 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 {
 	struct sgtl5000_priv *sgtl5000 = i2c_get_clientdata(client);
 
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_CLK_CTRL, SGTL5000_CHIP_CLK_CTRL_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_DIG_POWER, SGTL5000_DIG_POWER_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_ANA_POWER, SGTL5000_ANA_POWER_DEFAULT);
 
diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 7ed869bf1a92..81269ed5a2aa 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -450,6 +450,13 @@ static const struct dmi_system_id byt_cht_es8316_quirk_table[] = {
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
index 8b8a9aca2912..0e2261ee07b6 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -723,11 +723,6 @@ static int soc_pcm_open(struct snd_pcm_substream *substream)
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
diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index 006b5bd99c08..525d810b10b8 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -901,3 +901,39 @@
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
