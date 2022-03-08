Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FF44D201A
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349573AbiCHSXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349704AbiCHSXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:23:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E7056C24;
        Tue,  8 Mar 2022 10:22:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6556159A;
        Tue,  8 Mar 2022 18:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1506BC340EB;
        Tue,  8 Mar 2022 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646763741;
        bh=pPtRn4piWM0v70kzRCVmnk5G6Mf5Ln9C93cMNSa+Sow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXyd4kjkVczGaSatiFrU5tZgzz9aaRXSyPad6Ley8PGAH7U493NWqMYtugkGMWEfs
         0GUda51BJpZgwRIUbzeC6PQwoKAoZxC8663EDIAdg4++WpYbcllcinwB7D9fPluHyM
         aSOzGbrXjfm492rsHzR0JB5+t4rVGVQHEY0pUD7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.27
Date:   Tue,  8 Mar 2022 19:22:11 +0100
Message-Id: <164676373085214@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <16467637300120@kroah.com>
References: <16467637300120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index fb578fbbb76c..49857ce1cd03 100644
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
diff --git a/Documentation/gpu/i915.rst b/Documentation/gpu/i915.rst
index 204ebdaadb45..03021dfa0dd8 100644
--- a/Documentation/gpu/i915.rst
+++ b/Documentation/gpu/i915.rst
@@ -183,25 +183,25 @@ Frame Buffer Compression (FBC)
 Display Refresh Rate Switching (DRRS)
 -------------------------------------
 
-.. kernel-doc:: drivers/gpu/drm/i915/display/intel_dp.c
+.. kernel-doc:: drivers/gpu/drm/i915/display/intel_drrs.c
    :doc: Display Refresh Rate Switching (DRRS)
 
-.. kernel-doc:: drivers/gpu/drm/i915/display/intel_dp.c
+.. kernel-doc:: drivers/gpu/drm/i915/display/intel_drrs.c
    :functions: intel_dp_set_drrs_state
 
-.. kernel-doc:: drivers/gpu/drm/i915/display/intel_dp.c
+.. kernel-doc:: drivers/gpu/drm/i915/display/intel_drrs.c
    :functions: intel_edp_drrs_enable
 
-.. kernel-doc:: drivers/gpu/drm/i915/display/intel_dp.c
+.. kernel-doc:: drivers/gpu/drm/i915/display/intel_drrs.c
    :functions: intel_edp_drrs_disable
 
-.. kernel-doc:: drivers/gpu/drm/i915/display/intel_dp.c
+.. kernel-doc:: drivers/gpu/drm/i915/display/intel_drrs.c
    :functions: intel_edp_drrs_invalidate
 
-.. kernel-doc:: drivers/gpu/drm/i915/display/intel_dp.c
+.. kernel-doc:: drivers/gpu/drm/i915/display/intel_drrs.c
    :functions: intel_edp_drrs_flush
 
-.. kernel-doc:: drivers/gpu/drm/i915/display/intel_dp.c
+.. kernel-doc:: drivers/gpu/drm/i915/display/intel_drrs.c
    :functions: intel_dp_drrs_init
 
 DPIO
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
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 3b79fd441dde..c8103e57a70b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7024,7 +7024,6 @@ F:	drivers/net/mdio/fwnode_mdio.c
 F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
-F:	drivers/of/of_net.c
 F:	include/dt-bindings/net/qca-ar803x.h
 F:	include/linux/*mdio*.h
 F:	include/linux/mdio/*.h
@@ -7036,6 +7035,7 @@ F:	include/linux/platform_data/mdio-gpio.h
 F:	include/trace/events/mdio.h
 F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
+F:	net/core/of_net.c
 
 EXFAT FILE SYSTEM
 M:	Namjae Jeon <linkinjeon@kernel.org>
diff --git a/Makefile b/Makefile
index 9479b440d708..6a422b34582a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 26
+SUBLEVEL = 27
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/omap3-devkit8000-common.dtsi b/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
index 2c19d6e255bd..6883ccb45600 100644
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
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
index c1bcc8ca3769..2f8e11710969 100644
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
 
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index b5ec010c481f..309a27553c87 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -36,7 +36,7 @@ void *module_alloc(unsigned long size)
 		module_alloc_end = MODULES_END;
 
 	p = __vmalloc_node_range(size, MODULE_ALIGN, module_alloc_base,
-				module_alloc_end, gfp_mask, PAGE_KERNEL, 0,
+				module_alloc_end, gfp_mask, PAGE_KERNEL, VM_DEFER_KMEMLEAK,
 				NUMA_NO_NODE, __builtin_return_address(0));
 
 	if (!p && IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
@@ -58,7 +58,7 @@ void *module_alloc(unsigned long size)
 				PAGE_KERNEL, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 
-	if (p && (kasan_module_alloc(p, size) < 0)) {
+	if (p && (kasan_module_alloc(p, size, gfp_mask) < 0)) {
 		vfree(p);
 		return NULL;
 	}
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 8982a2b78acf..3b8dc538a4c4 100644
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
diff --git a/arch/mips/include/asm/local.h b/arch/mips/include/asm/local.h
index ecda7295ddcd..3fa634090388 100644
--- a/arch/mips/include/asm/local.h
+++ b/arch/mips/include/asm/local.h
@@ -5,6 +5,7 @@
 #include <linux/percpu.h>
 #include <linux/bitops.h>
 #include <linux/atomic.h>
+#include <asm/asm.h>
 #include <asm/cmpxchg.h>
 #include <asm/compiler.h>
 #include <asm/war.h>
@@ -39,7 +40,7 @@ static __inline__ long local_add_return(long i, local_t * l)
 		"	.set	arch=r4000				\n"
 			__SYNC(full, loongson3_war) "			\n"
 		"1:"	__LL	"%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
+			__stringify(LONG_ADDU)	"	%0, %1, %3	\n"
 			__SC	"%0, %2					\n"
 		"	beqzl	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
@@ -55,7 +56,7 @@ static __inline__ long local_add_return(long i, local_t * l)
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
 			__SYNC(full, loongson3_war) "			\n"
 		"1:"	__LL	"%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
+			__stringify(LONG_ADDU)	"	%0, %1, %3	\n"
 			__SC	"%0, %2					\n"
 		"	beqz	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
@@ -88,7 +89,7 @@ static __inline__ long local_sub_return(long i, local_t * l)
 		"	.set	arch=r4000				\n"
 			__SYNC(full, loongson3_war) "			\n"
 		"1:"	__LL	"%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
+			__stringify(LONG_SUBU)	"	%0, %1, %3	\n"
 			__SC	"%0, %2					\n"
 		"	beqzl	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
@@ -104,7 +105,7 @@ static __inline__ long local_sub_return(long i, local_t * l)
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
 			__SYNC(full, loongson3_war) "			\n"
 		"1:"	__LL	"%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
+			__stringify(LONG_SUBU)	"	%0, %1, %3	\n"
 			__SC	"%0, %2					\n"
 		"	beqz	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
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
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5e7decd87525..3de593b26850 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -451,6 +451,7 @@ static uintptr_t __init best_map_size(phys_addr_t base, phys_addr_t size)
 }
 
 #ifdef CONFIG_XIP_KERNEL
+#define phys_ram_base  (*(phys_addr_t *)XIP_FIXUP(&phys_ram_base))
 /* called from head.S with MMU off */
 asmlinkage void __init __copy_data(void)
 {
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
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index a805ea5cb92d..b032e556eeb7 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -37,14 +37,15 @@
 
 void *module_alloc(unsigned long size)
 {
+	gfp_t gfp_mask = GFP_KERNEL;
 	void *p;
 
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	p = __vmalloc_node_range(size, MODULE_ALIGN, MODULES_VADDR, MODULES_END,
-				 GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				 gfp_mask, PAGE_KERNEL_EXEC, VM_DEFER_KMEMLEAK, NUMA_NO_NODE,
 				 __builtin_return_address(0));
-	if (p && (kasan_module_alloc(p, size) < 0)) {
+	if (p && (kasan_module_alloc(p, size, gfp_mask) < 0)) {
 		vfree(p);
 		return NULL;
 	}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 9a8c086528f5..402597f9d050 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3447,7 +3447,7 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 	/* do not poll with more than halt_poll_max_steal percent of steal time */
 	if (S390_lowcore.avg_steal_timer * 100 / (TICK_USEC << 12) >=
-	    halt_poll_max_steal) {
+	    READ_ONCE(halt_poll_max_steal)) {
 		vcpu->stat.halt_no_poll_steal++;
 		return true;
 	}
diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
index bd13736d0c05..0ad2378fe6ad 100644
--- a/arch/x86/hyperv/mmu.c
+++ b/arch/x86/hyperv/mmu.c
@@ -68,15 +68,6 @@ static void hyperv_flush_tlb_multi(const struct cpumask *cpus,
 
 	local_irq_save(flags);
 
-	/*
-	 * Only check the mask _after_ interrupt has been disabled to avoid the
-	 * mask changing under our feet.
-	 */
-	if (cpumask_empty(cpus)) {
-		local_irq_restore(flags);
-		return;
-	}
-
 	flush_pcpu = (struct hv_tlb_flush **)
 		     this_cpu_ptr(hyperv_pcpu_input_arg);
 
@@ -115,7 +106,9 @@ static void hyperv_flush_tlb_multi(const struct cpumask *cpus,
 		 * must. We will also check all VP numbers when walking the
 		 * supplied CPU set to remain correct in all cases.
 		 */
-		if (hv_cpu_number_to_vp_number(cpumask_last(cpus)) >= 64)
+		cpu = cpumask_last(cpus);
+
+		if (cpu < nr_cpumask_bits && hv_cpu_number_to_vp_number(cpu) >= 64)
 			goto do_ex_hypercall;
 
 		for_each_cpu(cpu, cpus) {
@@ -131,6 +124,12 @@ static void hyperv_flush_tlb_multi(const struct cpumask *cpus,
 			__set_bit(vcpu, (unsigned long *)
 				  &flush->processor_mask);
 		}
+
+		/* nothing to flush if 'processor_mask' ends up being empty */
+		if (!flush->processor_mask) {
+			local_irq_restore(flags);
+			return;
+		}
 	}
 
 	/*
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 5e9a34b5bd74..867a341a0c7e 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -67,6 +67,7 @@ static unsigned long int get_module_load_offset(void)
 
 void *module_alloc(unsigned long size)
 {
+	gfp_t gfp_mask = GFP_KERNEL;
 	void *p;
 
 	if (PAGE_ALIGN(size) > MODULES_LEN)
@@ -74,10 +75,10 @@ void *module_alloc(unsigned long size)
 
 	p = __vmalloc_node_range(size, MODULE_ALIGN,
 				    MODULES_VADDR + get_module_load_offset(),
-				    MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
+				    MODULES_END, gfp_mask,
+				    PAGE_KERNEL, VM_DEFER_KMEMLEAK, NUMA_NO_NODE,
 				    __builtin_return_address(0));
-	if (p && (kasan_module_alloc(p, size) < 0)) {
+	if (p && (kasan_module_alloc(p, size, gfp_mask) < 0)) {
 		vfree(p);
 		return NULL;
 	}
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ccb9aa571b03..2297dd90fe4a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3579,7 +3579,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
 
-	return 0;
+	return r;
 }
 
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 21ea58d25771..46fb83d6a286 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -51,7 +51,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* The full case.  */
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		dest = cpu_physical_id(cpu);
 
@@ -104,7 +104,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	unsigned int dest;
 
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 		WARN(old.nv != POSTED_INTR_WAKEUP_VECTOR,
 		     "Wakeup handler not enabled while the VCPU is blocked\n");
 
@@ -147,7 +147,8 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!vmx_can_use_vtd_pi(vcpu->kvm))
+	if (!vmx_can_use_vtd_pi(vcpu->kvm) ||
+	    vmx_interrupt_blocked(vcpu))
 		return 0;
 
 	WARN_ON(irqs_disabled());
@@ -162,7 +163,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	}
 
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		WARN((pi_desc->sn == 1),
 		     "Warning: SN field of posted-interrupts "
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33cb06518124..8213f7fb71a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -848,6 +848,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 	vcpu->arch.pdptrs_from_userspace = false;
 
 out:
@@ -7998,7 +7999,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * updating interruptibility state and injecting single-step #DBs.
 	 */
 	if (emulation_type & EMULTYPE_SKIP) {
-		kvm_rip_write(vcpu, ctxt->_eip);
+		if (ctxt->mode != X86EMUL_MODE_PROT64)
+			ctxt->eip = (u32)ctxt->_eip;
+		else
+			ctxt->eip = ctxt->_eip;
+
+		kvm_rip_write(vcpu, ctxt->eip);
 		if (ctxt->eflags & X86_EFLAGS_RF)
 			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
 		return 1;
@@ -8062,6 +8068,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			writeback = false;
 		r = 0;
 		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
+	} else if (vcpu->arch.complete_userspace_io) {
+		writeback = false;
+		r = 0;
 	} else if (r == EMULATION_RESTART)
 		goto restart;
 	else
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
index c00ae30fde89..92f9d32bfae5 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -79,6 +79,7 @@
 #include <linux/ioprio.h>
 #include <linux/blk-cgroup.h>
 #include <linux/sched/mm.h>
+#include <linux/statfs.h>
 
 #include "loop.h"
 
@@ -939,8 +940,13 @@ static void loop_config_discard(struct loop_device *lo)
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
diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index 0c05b79870f9..83f02bd51dda 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -124,10 +124,11 @@ static int cma_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
 	struct cma_heap_buffer *buffer = dmabuf->priv;
 	struct dma_heap_attachment *a;
 
+	mutex_lock(&buffer->lock);
+
 	if (buffer->vmap_cnt)
 		invalidate_kernel_vmap_range(buffer->vaddr, buffer->len);
 
-	mutex_lock(&buffer->lock);
 	list_for_each_entry(a, &buffer->attachments, list) {
 		if (!a->mapped)
 			continue;
@@ -144,10 +145,11 @@ static int cma_heap_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
 	struct cma_heap_buffer *buffer = dmabuf->priv;
 	struct dma_heap_attachment *a;
 
+	mutex_lock(&buffer->lock);
+
 	if (buffer->vmap_cnt)
 		flush_kernel_vmap_range(buffer->vaddr, buffer->len);
 
-	mutex_lock(&buffer->lock);
 	list_for_each_entry(a, &buffer->attachments, list) {
 		if (!a->mapped)
 			continue;
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index a8465e3195a6..5a7fef324c82 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -891,6 +891,717 @@ MODULE_PARM_DESC(smu_pptable_id,
 	"specify pptable id to be used (-1 = auto(default) value, 0 = use pptable from vbios, > 0 = soft pptable id)");
 module_param_named(smu_pptable_id, amdgpu_smu_pptable_id, int, 0444);
 
+/* These devices are not supported by amdgpu.
+ * They are supported by the mach64, r128, radeon drivers
+ */
+static const u16 amdgpu_unsupported_pciidlist[] = {
+	/* mach64 */
+	0x4354,
+	0x4358,
+	0x4554,
+	0x4742,
+	0x4744,
+	0x4749,
+	0x474C,
+	0x474D,
+	0x474E,
+	0x474F,
+	0x4750,
+	0x4751,
+	0x4752,
+	0x4753,
+	0x4754,
+	0x4755,
+	0x4756,
+	0x4757,
+	0x4758,
+	0x4759,
+	0x475A,
+	0x4C42,
+	0x4C44,
+	0x4C47,
+	0x4C49,
+	0x4C4D,
+	0x4C4E,
+	0x4C50,
+	0x4C51,
+	0x4C52,
+	0x4C53,
+	0x5654,
+	0x5655,
+	0x5656,
+	/* r128 */
+	0x4c45,
+	0x4c46,
+	0x4d46,
+	0x4d4c,
+	0x5041,
+	0x5042,
+	0x5043,
+	0x5044,
+	0x5045,
+	0x5046,
+	0x5047,
+	0x5048,
+	0x5049,
+	0x504A,
+	0x504B,
+	0x504C,
+	0x504D,
+	0x504E,
+	0x504F,
+	0x5050,
+	0x5051,
+	0x5052,
+	0x5053,
+	0x5054,
+	0x5055,
+	0x5056,
+	0x5057,
+	0x5058,
+	0x5245,
+	0x5246,
+	0x5247,
+	0x524b,
+	0x524c,
+	0x534d,
+	0x5446,
+	0x544C,
+	0x5452,
+	/* radeon */
+	0x3150,
+	0x3151,
+	0x3152,
+	0x3154,
+	0x3155,
+	0x3E50,
+	0x3E54,
+	0x4136,
+	0x4137,
+	0x4144,
+	0x4145,
+	0x4146,
+	0x4147,
+	0x4148,
+	0x4149,
+	0x414A,
+	0x414B,
+	0x4150,
+	0x4151,
+	0x4152,
+	0x4153,
+	0x4154,
+	0x4155,
+	0x4156,
+	0x4237,
+	0x4242,
+	0x4336,
+	0x4337,
+	0x4437,
+	0x4966,
+	0x4967,
+	0x4A48,
+	0x4A49,
+	0x4A4A,
+	0x4A4B,
+	0x4A4C,
+	0x4A4D,
+	0x4A4E,
+	0x4A4F,
+	0x4A50,
+	0x4A54,
+	0x4B48,
+	0x4B49,
+	0x4B4A,
+	0x4B4B,
+	0x4B4C,
+	0x4C57,
+	0x4C58,
+	0x4C59,
+	0x4C5A,
+	0x4C64,
+	0x4C66,
+	0x4C67,
+	0x4E44,
+	0x4E45,
+	0x4E46,
+	0x4E47,
+	0x4E48,
+	0x4E49,
+	0x4E4A,
+	0x4E4B,
+	0x4E50,
+	0x4E51,
+	0x4E52,
+	0x4E53,
+	0x4E54,
+	0x4E56,
+	0x5144,
+	0x5145,
+	0x5146,
+	0x5147,
+	0x5148,
+	0x514C,
+	0x514D,
+	0x5157,
+	0x5158,
+	0x5159,
+	0x515A,
+	0x515E,
+	0x5460,
+	0x5462,
+	0x5464,
+	0x5548,
+	0x5549,
+	0x554A,
+	0x554B,
+	0x554C,
+	0x554D,
+	0x554E,
+	0x554F,
+	0x5550,
+	0x5551,
+	0x5552,
+	0x5554,
+	0x564A,
+	0x564B,
+	0x564F,
+	0x5652,
+	0x5653,
+	0x5657,
+	0x5834,
+	0x5835,
+	0x5954,
+	0x5955,
+	0x5974,
+	0x5975,
+	0x5960,
+	0x5961,
+	0x5962,
+	0x5964,
+	0x5965,
+	0x5969,
+	0x5a41,
+	0x5a42,
+	0x5a61,
+	0x5a62,
+	0x5b60,
+	0x5b62,
+	0x5b63,
+	0x5b64,
+	0x5b65,
+	0x5c61,
+	0x5c63,
+	0x5d48,
+	0x5d49,
+	0x5d4a,
+	0x5d4c,
+	0x5d4d,
+	0x5d4e,
+	0x5d4f,
+	0x5d50,
+	0x5d52,
+	0x5d57,
+	0x5e48,
+	0x5e4a,
+	0x5e4b,
+	0x5e4c,
+	0x5e4d,
+	0x5e4f,
+	0x6700,
+	0x6701,
+	0x6702,
+	0x6703,
+	0x6704,
+	0x6705,
+	0x6706,
+	0x6707,
+	0x6708,
+	0x6709,
+	0x6718,
+	0x6719,
+	0x671c,
+	0x671d,
+	0x671f,
+	0x6720,
+	0x6721,
+	0x6722,
+	0x6723,
+	0x6724,
+	0x6725,
+	0x6726,
+	0x6727,
+	0x6728,
+	0x6729,
+	0x6738,
+	0x6739,
+	0x673e,
+	0x6740,
+	0x6741,
+	0x6742,
+	0x6743,
+	0x6744,
+	0x6745,
+	0x6746,
+	0x6747,
+	0x6748,
+	0x6749,
+	0x674A,
+	0x6750,
+	0x6751,
+	0x6758,
+	0x6759,
+	0x675B,
+	0x675D,
+	0x675F,
+	0x6760,
+	0x6761,
+	0x6762,
+	0x6763,
+	0x6764,
+	0x6765,
+	0x6766,
+	0x6767,
+	0x6768,
+	0x6770,
+	0x6771,
+	0x6772,
+	0x6778,
+	0x6779,
+	0x677B,
+	0x6840,
+	0x6841,
+	0x6842,
+	0x6843,
+	0x6849,
+	0x684C,
+	0x6850,
+	0x6858,
+	0x6859,
+	0x6880,
+	0x6888,
+	0x6889,
+	0x688A,
+	0x688C,
+	0x688D,
+	0x6898,
+	0x6899,
+	0x689b,
+	0x689c,
+	0x689d,
+	0x689e,
+	0x68a0,
+	0x68a1,
+	0x68a8,
+	0x68a9,
+	0x68b0,
+	0x68b8,
+	0x68b9,
+	0x68ba,
+	0x68be,
+	0x68bf,
+	0x68c0,
+	0x68c1,
+	0x68c7,
+	0x68c8,
+	0x68c9,
+	0x68d8,
+	0x68d9,
+	0x68da,
+	0x68de,
+	0x68e0,
+	0x68e1,
+	0x68e4,
+	0x68e5,
+	0x68e8,
+	0x68e9,
+	0x68f1,
+	0x68f2,
+	0x68f8,
+	0x68f9,
+	0x68fa,
+	0x68fe,
+	0x7100,
+	0x7101,
+	0x7102,
+	0x7103,
+	0x7104,
+	0x7105,
+	0x7106,
+	0x7108,
+	0x7109,
+	0x710A,
+	0x710B,
+	0x710C,
+	0x710E,
+	0x710F,
+	0x7140,
+	0x7141,
+	0x7142,
+	0x7143,
+	0x7144,
+	0x7145,
+	0x7146,
+	0x7147,
+	0x7149,
+	0x714A,
+	0x714B,
+	0x714C,
+	0x714D,
+	0x714E,
+	0x714F,
+	0x7151,
+	0x7152,
+	0x7153,
+	0x715E,
+	0x715F,
+	0x7180,
+	0x7181,
+	0x7183,
+	0x7186,
+	0x7187,
+	0x7188,
+	0x718A,
+	0x718B,
+	0x718C,
+	0x718D,
+	0x718F,
+	0x7193,
+	0x7196,
+	0x719B,
+	0x719F,
+	0x71C0,
+	0x71C1,
+	0x71C2,
+	0x71C3,
+	0x71C4,
+	0x71C5,
+	0x71C6,
+	0x71C7,
+	0x71CD,
+	0x71CE,
+	0x71D2,
+	0x71D4,
+	0x71D5,
+	0x71D6,
+	0x71DA,
+	0x71DE,
+	0x7200,
+	0x7210,
+	0x7211,
+	0x7240,
+	0x7243,
+	0x7244,
+	0x7245,
+	0x7246,
+	0x7247,
+	0x7248,
+	0x7249,
+	0x724A,
+	0x724B,
+	0x724C,
+	0x724D,
+	0x724E,
+	0x724F,
+	0x7280,
+	0x7281,
+	0x7283,
+	0x7284,
+	0x7287,
+	0x7288,
+	0x7289,
+	0x728B,
+	0x728C,
+	0x7290,
+	0x7291,
+	0x7293,
+	0x7297,
+	0x7834,
+	0x7835,
+	0x791e,
+	0x791f,
+	0x793f,
+	0x7941,
+	0x7942,
+	0x796c,
+	0x796d,
+	0x796e,
+	0x796f,
+	0x9400,
+	0x9401,
+	0x9402,
+	0x9403,
+	0x9405,
+	0x940A,
+	0x940B,
+	0x940F,
+	0x94A0,
+	0x94A1,
+	0x94A3,
+	0x94B1,
+	0x94B3,
+	0x94B4,
+	0x94B5,
+	0x94B9,
+	0x9440,
+	0x9441,
+	0x9442,
+	0x9443,
+	0x9444,
+	0x9446,
+	0x944A,
+	0x944B,
+	0x944C,
+	0x944E,
+	0x9450,
+	0x9452,
+	0x9456,
+	0x945A,
+	0x945B,
+	0x945E,
+	0x9460,
+	0x9462,
+	0x946A,
+	0x946B,
+	0x947A,
+	0x947B,
+	0x9480,
+	0x9487,
+	0x9488,
+	0x9489,
+	0x948A,
+	0x948F,
+	0x9490,
+	0x9491,
+	0x9495,
+	0x9498,
+	0x949C,
+	0x949E,
+	0x949F,
+	0x94C0,
+	0x94C1,
+	0x94C3,
+	0x94C4,
+	0x94C5,
+	0x94C6,
+	0x94C7,
+	0x94C8,
+	0x94C9,
+	0x94CB,
+	0x94CC,
+	0x94CD,
+	0x9500,
+	0x9501,
+	0x9504,
+	0x9505,
+	0x9506,
+	0x9507,
+	0x9508,
+	0x9509,
+	0x950F,
+	0x9511,
+	0x9515,
+	0x9517,
+	0x9519,
+	0x9540,
+	0x9541,
+	0x9542,
+	0x954E,
+	0x954F,
+	0x9552,
+	0x9553,
+	0x9555,
+	0x9557,
+	0x955f,
+	0x9580,
+	0x9581,
+	0x9583,
+	0x9586,
+	0x9587,
+	0x9588,
+	0x9589,
+	0x958A,
+	0x958B,
+	0x958C,
+	0x958D,
+	0x958E,
+	0x958F,
+	0x9590,
+	0x9591,
+	0x9593,
+	0x9595,
+	0x9596,
+	0x9597,
+	0x9598,
+	0x9599,
+	0x959B,
+	0x95C0,
+	0x95C2,
+	0x95C4,
+	0x95C5,
+	0x95C6,
+	0x95C7,
+	0x95C9,
+	0x95CC,
+	0x95CD,
+	0x95CE,
+	0x95CF,
+	0x9610,
+	0x9611,
+	0x9612,
+	0x9613,
+	0x9614,
+	0x9615,
+	0x9616,
+	0x9640,
+	0x9641,
+	0x9642,
+	0x9643,
+	0x9644,
+	0x9645,
+	0x9647,
+	0x9648,
+	0x9649,
+	0x964a,
+	0x964b,
+	0x964c,
+	0x964e,
+	0x964f,
+	0x9710,
+	0x9711,
+	0x9712,
+	0x9713,
+	0x9714,
+	0x9715,
+	0x9802,
+	0x9803,
+	0x9804,
+	0x9805,
+	0x9806,
+	0x9807,
+	0x9808,
+	0x9809,
+	0x980A,
+	0x9900,
+	0x9901,
+	0x9903,
+	0x9904,
+	0x9905,
+	0x9906,
+	0x9907,
+	0x9908,
+	0x9909,
+	0x990A,
+	0x990B,
+	0x990C,
+	0x990D,
+	0x990E,
+	0x990F,
+	0x9910,
+	0x9913,
+	0x9917,
+	0x9918,
+	0x9919,
+	0x9990,
+	0x9991,
+	0x9992,
+	0x9993,
+	0x9994,
+	0x9995,
+	0x9996,
+	0x9997,
+	0x9998,
+	0x9999,
+	0x999A,
+	0x999B,
+	0x999C,
+	0x999D,
+	0x99A0,
+	0x99A2,
+	0x99A4,
+	/* radeon secondary ids */
+	0x3171,
+	0x3e70,
+	0x4164,
+	0x4165,
+	0x4166,
+	0x4168,
+	0x4170,
+	0x4171,
+	0x4172,
+	0x4173,
+	0x496e,
+	0x4a69,
+	0x4a6a,
+	0x4a6b,
+	0x4a70,
+	0x4a74,
+	0x4b69,
+	0x4b6b,
+	0x4b6c,
+	0x4c6e,
+	0x4e64,
+	0x4e65,
+	0x4e66,
+	0x4e67,
+	0x4e68,
+	0x4e69,
+	0x4e6a,
+	0x4e71,
+	0x4f73,
+	0x5569,
+	0x556b,
+	0x556d,
+	0x556f,
+	0x5571,
+	0x5854,
+	0x5874,
+	0x5940,
+	0x5941,
+	0x5b72,
+	0x5b73,
+	0x5b74,
+	0x5b75,
+	0x5d44,
+	0x5d45,
+	0x5d6d,
+	0x5d6f,
+	0x5d72,
+	0x5d77,
+	0x5e6b,
+	0x5e6d,
+	0x7120,
+	0x7124,
+	0x7129,
+	0x712e,
+	0x712f,
+	0x7162,
+	0x7163,
+	0x7166,
+	0x7167,
+	0x7172,
+	0x7173,
+	0x71a0,
+	0x71a1,
+	0x71a3,
+	0x71a7,
+	0x71bb,
+	0x71e0,
+	0x71e1,
+	0x71e2,
+	0x71e6,
+	0x71e7,
+	0x71f2,
+	0x7269,
+	0x726b,
+	0x726e,
+	0x72a0,
+	0x72a8,
+	0x72b1,
+	0x72b3,
+	0x793f,
+};
+
 static const struct pci_device_id pciidlist[] = {
 #ifdef  CONFIG_DRM_AMDGPU_SI
 	{0x1002, 0x6780, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
@@ -1273,7 +1984,7 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 	struct drm_device *ddev;
 	struct amdgpu_device *adev;
 	unsigned long flags = ent->driver_data;
-	int ret, retry = 0;
+	int ret, retry = 0, i;
 	bool supports_atomic = false;
 	bool is_fw_fb;
 	resource_size_t base, size;
@@ -1281,6 +1992,12 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 	if (amdgpu_aspm == -1 && !pcie_aspm_enabled(pdev))
 		amdgpu_aspm = 0;
 
+	/* skip devices which are owned by radeon */
+	for (i = 0; i < ARRAY_SIZE(amdgpu_unsupported_pciidlist); i++) {
+		if (amdgpu_unsupported_pciidlist[i] == pdev->device)
+			return -ENODEV;
+	}
+
 	if (amdgpu_virtual_display ||
 	    amdgpu_device_asic_has_dc_support(flags & AMD_ASIC_MASK))
 		supports_atomic = true;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
index ac9a8cd21c4b..7d58bf410be0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -142,15 +142,16 @@ static void amdgpu_vkms_crtc_atomic_disable(struct drm_crtc *crtc,
 static void amdgpu_vkms_crtc_atomic_flush(struct drm_crtc *crtc,
 					  struct drm_atomic_state *state)
 {
+	unsigned long flags;
 	if (crtc->state->event) {
-		spin_lock(&crtc->dev->event_lock);
+		spin_lock_irqsave(&crtc->dev->event_lock, flags);
 
 		if (drm_crtc_vblank_get(crtc) != 0)
 			drm_crtc_send_vblank_event(crtc, crtc->state->event);
 		else
 			drm_crtc_arm_vblank_event(crtc, crtc->state->event);
 
-		spin_unlock(&crtc->dev->event_lock);
+		spin_unlock_irqrestore(&crtc->dev->event_lock, flags);
 
 		crtc->state->event = NULL;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 6b15cad78de9..fd37bb39774c 100644
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
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index cfedfb1e8596..c33d689f29e8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1060,6 +1060,9 @@ static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink,
 			return -ENODEV;
 		/* same everything but the other direction */
 		props2 = kmemdup(props, sizeof(*props2), GFP_KERNEL);
+		if (!props2)
+			return -ENOMEM;
+
 		props2->node_from = id_to;
 		props2->node_to = id_from;
 		props2->kobj = NULL;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 5ae9b8133d6d..cd611444ad17 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1279,9 +1279,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	adev_to_drm(adev)->mode_config.cursor_width = adev->dm.dc->caps.max_cursor_size;
 	adev_to_drm(adev)->mode_config.cursor_height = adev->dm.dc->caps.max_cursor_size;
 
-	/* Disable vblank IRQs aggressively for power-saving */
-	adev_to_drm(adev)->vblank_disable_immediate = true;
-
 	if (drm_vblank_init(adev_to_drm(adev), adev->dm.display_indexes_num)) {
 		DRM_ERROR(
 		"amdgpu: failed to initialize sw for display support.\n");
@@ -3815,6 +3812,9 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 	}
 #endif
 
+	/* Disable vblank IRQs aggressively for power-saving. */
+	adev_to_drm(adev)->vblank_disable_immediate = true;
+
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
@@ -3861,6 +3861,12 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 				update_connector_ext_caps(aconnector);
 			if (amdgpu_dc_feature_mask & DC_PSR_MASK)
 				amdgpu_dm_set_psr_caps(link);
+
+			/* TODO: Fix vblank control helpers to delay PSR entry to allow this when
+			 * PSR is also supported.
+			 */
+			if (link->psr_settings.psr_feature_enabled)
+				adev_to_drm(adev)->vblank_disable_immediate = false;
 		}
 
 
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
index 7046da14bb2a..329ce4e84b83 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
@@ -582,32 +582,32 @@ static struct wm_table lpddr5_wm_table = {
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 5.32,
-			.sr_enter_plus_exit_time_us = 6.38,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.82,
-			.sr_enter_plus_exit_time_us = 11.196,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.89,
-			.sr_enter_plus_exit_time_us = 11.24,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.748,
-			.sr_enter_plus_exit_time_us = 11.102,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 93c20844848c..605b96873d8c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3650,7 +3650,9 @@ bool dp_retrieve_lttpr_cap(struct dc_link *link)
 				lttpr_dpcd_data,
 				sizeof(lttpr_dpcd_data));
 		if (status != DC_OK) {
-			dm_error("%s: Read LTTPR caps data failed.\n", __func__);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+			DC_LOG_DP2("%s: Read LTTPR caps data failed.\n", __func__);
+#endif
 			return false;
 		}
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index e94546187cf1..7ae409f7dcf8 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1799,9 +1799,6 @@ enum dc_status dc_remove_stream_from_ctx(
 				dc->res_pool,
 			del_pipe->stream_res.stream_enc,
 			false);
-	/* Release link encoder from stream in new dc_state. */
-	if (dc->res_pool->funcs->link_enc_unassign)
-		dc->res_pool->funcs->link_enc_unassign(new_ctx, del_pipe->stream);
 
 	if (del_pipe->stream_res.audio)
 		update_audio_usage(
diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index 26ebe00a55f6..dea358b01791 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1622,12 +1622,106 @@ static void dcn301_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *b
 	dml_init_instance(&dc->dml, &dcn3_01_soc, &dcn3_01_ip, DML_PROJECT_DCN30);
 }
 
+static void calculate_wm_set_for_vlevel(
+		int vlevel,
+		struct wm_range_table_entry *table_entry,
+		struct dcn_watermarks *wm_set,
+		struct display_mode_lib *dml,
+		display_e2e_pipe_params_st *pipes,
+		int pipe_cnt)
+{
+	double dram_clock_change_latency_cached = dml->soc.dram_clock_change_latency_us;
+
+	ASSERT(vlevel < dml->soc.num_states);
+	/* only pipe 0 is read for voltage and dcf/soc clocks */
+	pipes[0].clks_cfg.voltage = vlevel;
+	pipes[0].clks_cfg.dcfclk_mhz = dml->soc.clock_limits[vlevel].dcfclk_mhz;
+	pipes[0].clks_cfg.socclk_mhz = dml->soc.clock_limits[vlevel].socclk_mhz;
+
+	dml->soc.dram_clock_change_latency_us = table_entry->pstate_latency_us;
+	dml->soc.sr_exit_time_us = table_entry->sr_exit_time_us;
+	dml->soc.sr_enter_plus_exit_time_us = table_entry->sr_enter_plus_exit_time_us;
+
+	wm_set->urgent_ns = get_wm_urgent(dml, pipes, pipe_cnt) * 1000;
+	wm_set->cstate_pstate.cstate_enter_plus_exit_ns = get_wm_stutter_enter_exit(dml, pipes, pipe_cnt) * 1000;
+	wm_set->cstate_pstate.cstate_exit_ns = get_wm_stutter_exit(dml, pipes, pipe_cnt) * 1000;
+	wm_set->cstate_pstate.pstate_change_ns = get_wm_dram_clock_change(dml, pipes, pipe_cnt) * 1000;
+	wm_set->pte_meta_urgent_ns = get_wm_memory_trip(dml, pipes, pipe_cnt) * 1000;
+	wm_set->frac_urg_bw_nom = get_fraction_of_urgent_bandwidth(dml, pipes, pipe_cnt) * 1000;
+	wm_set->frac_urg_bw_flip = get_fraction_of_urgent_bandwidth_imm_flip(dml, pipes, pipe_cnt) * 1000;
+	wm_set->urgent_latency_ns = get_urgent_latency(dml, pipes, pipe_cnt) * 1000;
+	dml->soc.dram_clock_change_latency_us = dram_clock_change_latency_cached;
+
+}
+
+static void dcn301_calculate_wm_and_dlg(
+		struct dc *dc, struct dc_state *context,
+		display_e2e_pipe_params_st *pipes,
+		int pipe_cnt,
+		int vlevel_req)
+{
+	int i, pipe_idx;
+	int vlevel, vlevel_max;
+	struct wm_range_table_entry *table_entry;
+	struct clk_bw_params *bw_params = dc->clk_mgr->bw_params;
+
+	ASSERT(bw_params);
+
+	vlevel_max = bw_params->clk_table.num_entries - 1;
+
+	/* WM Set D */
+	table_entry = &bw_params->wm_table.entries[WM_D];
+	if (table_entry->wm_type == WM_TYPE_RETRAINING)
+		vlevel = 0;
+	else
+		vlevel = vlevel_max;
+	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.d,
+						&context->bw_ctx.dml, pipes, pipe_cnt);
+	/* WM Set C */
+	table_entry = &bw_params->wm_table.entries[WM_C];
+	vlevel = min(max(vlevel_req, 2), vlevel_max);
+	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.c,
+						&context->bw_ctx.dml, pipes, pipe_cnt);
+	/* WM Set B */
+	table_entry = &bw_params->wm_table.entries[WM_B];
+	vlevel = min(max(vlevel_req, 1), vlevel_max);
+	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.b,
+						&context->bw_ctx.dml, pipes, pipe_cnt);
+
+	/* WM Set A */
+	table_entry = &bw_params->wm_table.entries[WM_A];
+	vlevel = min(vlevel_req, vlevel_max);
+	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.a,
+						&context->bw_ctx.dml, pipes, pipe_cnt);
+
+	for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
+		if (!context->res_ctx.pipe_ctx[i].stream)
+			continue;
+
+		pipes[pipe_idx].clks_cfg.dispclk_mhz = get_dispclk_calculated(&context->bw_ctx.dml, pipes, pipe_cnt);
+		pipes[pipe_idx].clks_cfg.dppclk_mhz = get_dppclk_calculated(&context->bw_ctx.dml, pipes, pipe_cnt, pipe_idx);
+
+		if (dc->config.forced_clocks) {
+			pipes[pipe_idx].clks_cfg.dispclk_mhz = context->bw_ctx.dml.soc.clock_limits[0].dispclk_mhz;
+			pipes[pipe_idx].clks_cfg.dppclk_mhz = context->bw_ctx.dml.soc.clock_limits[0].dppclk_mhz;
+		}
+		if (dc->debug.min_disp_clk_khz > pipes[pipe_idx].clks_cfg.dispclk_mhz * 1000)
+			pipes[pipe_idx].clks_cfg.dispclk_mhz = dc->debug.min_disp_clk_khz / 1000.0;
+		if (dc->debug.min_dpp_clk_khz > pipes[pipe_idx].clks_cfg.dppclk_mhz * 1000)
+			pipes[pipe_idx].clks_cfg.dppclk_mhz = dc->debug.min_dpp_clk_khz / 1000.0;
+
+		pipe_idx++;
+	}
+
+	dcn20_calculate_dlg_params(dc, context, pipes, pipe_cnt, vlevel);
+}
+
 static struct resource_funcs dcn301_res_pool_funcs = {
 	.destroy = dcn301_destroy_resource_pool,
 	.link_enc_create = dcn301_link_encoder_create,
 	.panel_cntl_create = dcn301_panel_cntl_create,
 	.validate_bandwidth = dcn30_validate_bandwidth,
-	.calculate_wm_and_dlg = dcn30_calculate_wm_and_dlg,
+	.calculate_wm_and_dlg = dcn301_calculate_wm_and_dlg,
 	.update_soc_for_wm_a = dcn30_update_soc_for_wm_a,
 	.populate_dml_pipes = dcn30_populate_dml_pipes_from_context,
 	.acquire_idle_pipe_for_layer = dcn20_acquire_idle_pipe_for_layer,
diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index 56055df2e8d2..9009b92490f3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -70,6 +70,7 @@ CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_mode_vba_30.o := $(dml_ccflags) $(fram
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_rq_dlg_calc_30.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn31/display_mode_vba_31.o := $(dml_ccflags) $(frame_warn_flag)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn31/display_rq_dlg_calc_31.o := $(dml_ccflags)
+CFLAGS_$(AMDDALPATH)/dc/dml/dsc/rc_calc_fpu.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_lib.o := $(dml_ccflags)
 CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/display_mode_vba.o := $(dml_rcflags)
 CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn2x/dcn2x.o := $(dml_rcflags)
@@ -84,6 +85,7 @@ CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn30/display_rq_dlg_calc_30.o := $(dml_rcfla
 CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn31/display_mode_vba_31.o := $(dml_rcflags)
 CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn31/display_rq_dlg_calc_31.o := $(dml_rcflags)
 CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/display_mode_lib.o := $(dml_rcflags)
+CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dsc/rc_calc_fpu.o  := $(dml_rcflags)
 endif
 CFLAGS_$(AMDDALPATH)/dc/dml/dml1_display_rq_dlg_calc.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/display_rq_dlg_helpers.o := $(dml_ccflags)
@@ -99,6 +101,7 @@ DML += dcn20/display_rq_dlg_calc_20v2.o dcn20/display_mode_vba_20v2.o
 DML += dcn21/display_rq_dlg_calc_21.o dcn21/display_mode_vba_21.o
 DML += dcn30/display_mode_vba_30.o dcn30/display_rq_dlg_calc_30.o
 DML += dcn31/display_mode_vba_31.o dcn31/display_rq_dlg_calc_31.o
+DML += dsc/rc_calc_fpu.o
 endif
 
 AMD_DAL_DML = $(addprefix $(AMDDALPATH)/dc/dml/,$(DML))
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dsc/qp_tables.h b/drivers/gpu/drm/amd/display/dc/dml/dsc/qp_tables.h
new file mode 100644
index 000000000000..e5fac9f4181d
--- /dev/null
+++ b/drivers/gpu/drm/amd/display/dc/dml/dsc/qp_tables.h
@@ -0,0 +1,704 @@
+
+/*
+ * Copyright 2017 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: AMD
+ *
+ */
+
+
+const qp_table   qp_table_422_10bpc_min = {
+	{   6, { 0, 4, 5, 6, 6, 6, 6, 7, 7, 8, 9, 9, 9, 12, 16} },
+	{ 6.5, { 0, 4, 5, 6, 6, 6, 6, 7, 7, 8, 9, 9, 9, 12, 16} },
+	{   7, { 0, 4, 5, 6, 6, 6, 6, 7, 7, 7, 9, 9, 9, 11, 15} },
+	{ 7.5, { 0, 2, 4, 6, 6, 6, 6, 7, 7, 7, 8, 9, 9, 11, 15} },
+	{   8, { 0, 2, 3, 5, 5, 6, 6, 7, 7, 7, 8, 8, 9, 11, 14} },
+	{ 8.5, { 0, 2, 3, 4, 5, 5, 5, 6, 6, 7, 8, 8, 9, 11, 14} },
+	{   9, { 0, 2, 3, 4, 5, 5, 5, 6, 6, 7, 8, 8, 9, 11, 13} },
+	{ 9.5, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 7, 8, 8, 9, 11, 13} },
+	{  10, { 0, 2, 2, 3, 4, 5, 5, 6, 6, 7, 8, 8, 9, 11, 12} },
+	{10.5, { 0, 2, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9, 11, 12} },
+	{  11, { 0, 2, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9, 10, 11} },
+	{11.5, { 0, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 8, 8, 10, 11} },
+	{  12, { 0, 2, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10} },
+	{12.5, { 0, 1, 2, 2, 4, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10} },
+	{  13, { 0, 1, 2, 2, 4, 4, 4, 5, 5, 6, 6, 6, 8, 8, 9} },
+	{13.5, { 0, 1, 2, 2, 3, 4, 4, 4, 5, 6, 6, 6, 7, 8, 9} },
+	{  14, { 0, 1, 2, 2, 3, 4, 4, 4, 4, 5, 5, 6, 7, 7, 8} },
+	{14.5, { 0, 1, 1, 2, 3, 3, 4, 4, 4, 5, 5, 6, 6, 7, 8} },
+	{  15, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 6, 6, 6, 8} },
+	{15.5, { 0, 0, 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 5, 6, 7} },
+	{  16, { 0, 0, 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 5, 5, 7} },
+	{16.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6} },
+	{  17, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 6} },
+	{17.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5} },
+	{  18, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 5} },
+	{18.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 5} },
+	{  19, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 4} },
+	{19.5, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 4} },
+	{  20, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 3} }
+};
+
+
+const qp_table   qp_table_444_8bpc_max = {
+	{   6, { 4, 6, 8, 8, 9, 9, 9, 10, 11, 12, 12, 12, 12, 13, 15} },
+	{ 6.5, { 4, 6, 7, 8, 8, 8, 9, 10, 11, 11, 12, 12, 12, 13, 15} },
+	{   7, { 4, 5, 7, 7, 8, 8, 8, 9, 10, 11, 11, 12, 12, 13, 14} },
+	{ 7.5, { 4, 5, 6, 7, 7, 8, 8, 9, 10, 10, 11, 11, 12, 13, 14} },
+	{   8, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
+	{ 8.5, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
+	{   9, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 11, 13} },
+	{ 9.5, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 11, 13} },
+	{  10, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 11, 12} },
+	{10.5, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 10, 11, 12} },
+	{  11, { 2, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 10, 10, 11} },
+	{11.5, { 2, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 9, 10, 11} },
+	{  12, { 2, 3, 4, 5, 6, 6, 7, 8, 8, 9, 9, 9, 9, 10, 11} },
+	{12.5, { 2, 3, 4, 5, 6, 6, 6, 7, 7, 8, 8, 9, 9, 10, 11} },
+	{  13, { 1, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8, 8, 8, 9, 10} },
+	{13.5, { 1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 10} },
+	{  14, { 1, 2, 2, 3, 4, 4, 4, 5, 6, 6, 7, 8, 8, 8, 10} },
+	{14.5, { 0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 9} },
+	{  15, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
+	{15.5, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
+	{  16, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 8} },
+	{16.5, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 8} },
+	{  17, { 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 8} },
+	{17.5, { 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 8} },
+	{  18, { 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 7} },
+	{18.5, { 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 7} },
+	{  19, { 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 6} },
+	{19.5, { 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 6} },
+	{  20, { 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 6} },
+	{20.5, { 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 6} },
+	{  21, { 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5} },
+	{21.5, { 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5} },
+	{  22, { 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 5} },
+	{22.5, { 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 4} },
+	{  23, { 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4} },
+	{23.5, { 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4} },
+	{  24, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 4} }
+};
+
+
+const qp_table   qp_table_420_12bpc_max = {
+	{   4, {11, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 21, 22} },
+	{ 4.5, {10, 11, 12, 13, 14, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
+	{   5, { 9, 11, 12, 13, 14, 15, 15, 16, 17, 17, 18, 18, 19, 20, 21} },
+	{ 5.5, { 8, 10, 11, 12, 13, 14, 15, 16, 16, 17, 17, 18, 18, 19, 20} },
+	{   6, { 6, 9, 11, 12, 13, 14, 15, 16, 16, 17, 17, 17, 17, 18, 19} },
+	{ 6.5, { 6, 8, 10, 11, 11, 13, 14, 15, 15, 16, 16, 17, 17, 18, 19} },
+	{   7, { 5, 7, 9, 10, 10, 12, 13, 14, 14, 15, 16, 16, 17, 17, 18} },
+	{ 7.5, { 5, 7, 8, 9, 9, 11, 12, 13, 14, 14, 15, 15, 16, 16, 17} },
+	{   8, { 4, 6, 7, 8, 8, 10, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
+	{ 8.5, { 3, 6, 6, 7, 7, 10, 11, 12, 13, 13, 14, 14, 15, 15, 16} },
+	{   9, { 3, 5, 6, 7, 7, 10, 11, 12, 12, 13, 13, 14, 14, 14, 15} },
+	{ 9.5, { 2, 5, 6, 6, 7, 9, 10, 11, 12, 12, 13, 13, 13, 14, 15} },
+	{  10, { 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 13, 13, 13, 15} },
+	{10.5, { 2, 3, 5, 5, 6, 7, 8, 9, 11, 11, 12, 12, 12, 12, 14} },
+	{  11, { 1, 3, 4, 5, 6, 6, 7, 9, 10, 11, 11, 11, 12, 12, 13} },
+	{11.5, { 1, 2, 3, 4, 5, 6, 6, 8, 9, 10, 10, 11, 11, 11, 13} },
+	{  12, { 1, 1, 3, 3, 4, 5, 6, 7, 8, 9, 9, 10, 10, 10, 12} },
+	{12.5, { 1, 1, 2, 3, 4, 5, 6, 7, 8, 8, 9, 9, 9, 10, 11} },
+	{  13, { 1, 1, 1, 2, 4, 4, 6, 6, 7, 8, 8, 9, 9, 9, 11} },
+	{13.5, { 1, 1, 1, 2, 3, 4, 5, 5, 6, 7, 8, 8, 8, 9, 11} },
+	{  14, { 1, 1, 1, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 8, 10} },
+	{14.5, { 0, 1, 1, 1, 2, 3, 4, 4, 5, 5, 6, 7, 7, 7, 9} },
+	{  15, { 0, 1, 1, 1, 1, 2, 3, 3, 5, 5, 5, 6, 6, 7, 9} },
+	{15.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 8} },
+	{  16, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 7} },
+	{16.5, { 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 4, 4, 5, 7} },
+	{  17, { 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 6} },
+	{17.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 6} },
+	{  18, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 5} }
+};
+
+
+const qp_table   qp_table_444_10bpc_min = {
+	{   6, { 0, 4, 7, 7, 9, 9, 9, 9, 9, 10, 10, 10, 10, 12, 18} },
+	{ 6.5, { 0, 4, 6, 7, 8, 8, 9, 9, 9, 9, 10, 10, 10, 12, 18} },
+	{   7, { 0, 4, 6, 6, 8, 8, 8, 8, 8, 9, 9, 10, 10, 12, 17} },
+	{ 7.5, { 0, 4, 6, 6, 7, 8, 8, 8, 8, 8, 9, 9, 10, 12, 17} },
+	{   8, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 8, 9, 9, 9, 12, 16} },
+	{ 8.5, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 8, 9, 9, 9, 12, 16} },
+	{   9, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 16} },
+	{ 9.5, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 16} },
+	{  10, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 15} },
+	{10.5, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 15} },
+	{  11, { 0, 3, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 11, 14} },
+	{11.5, { 0, 3, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 11, 14} },
+	{  12, { 0, 2, 4, 4, 6, 6, 7, 7, 7, 7, 9, 9, 9, 11, 14} },
+	{12.5, { 0, 2, 4, 4, 6, 6, 7, 7, 7, 7, 8, 9, 9, 11, 14} },
+	{  13, { 0, 2, 4, 4, 5, 6, 7, 7, 7, 7, 8, 9, 9, 11, 13} },
+	{13.5, { 0, 2, 3, 4, 5, 6, 6, 7, 7, 7, 8, 9, 9, 11, 13} },
+	{  14, { 0, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 9, 9, 11, 13} },
+	{14.5, { 0, 2, 3, 4, 5, 5, 6, 6, 6, 7, 7, 8, 9, 11, 12} },
+	{  15, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 8, 9, 11, 12} },
+	{15.5, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 8, 9, 11, 12} },
+	{  16, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 8, 8, 10, 11} },
+	{16.5, { 0, 1, 2, 3, 4, 5, 5, 6, 6, 6, 7, 8, 8, 10, 11} },
+	{  17, { 0, 1, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 8, 9, 11} },
+	{17.5, { 0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9, 11} },
+	{  18, { 0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10} },
+	{18.5, { 0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10} },
+	{  19, { 0, 1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 7, 7, 8, 9} },
+	{19.5, { 0, 1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 7, 7, 8, 9} },
+	{  20, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 9} },
+	{20.5, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 9} },
+	{  21, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 6, 6, 7, 9} },
+	{21.5, { 0, 1, 1, 2, 2, 2, 3, 4, 4, 4, 5, 6, 6, 7, 8} },
+	{  22, { 0, 0, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 8} },
+	{22.5, { 0, 0, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 7} },
+	{  23, { 0, 0, 1, 2, 2, 2, 3, 3, 3, 3, 5, 5, 5, 5, 7} },
+	{23.5, { 0, 0, 0, 2, 2, 2, 3, 3, 3, 3, 5, 5, 5, 5, 7} },
+	{  24, { 0, 0, 0, 1, 1, 2, 3, 3, 3, 3, 4, 4, 4, 5, 7} },
+	{24.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 7} },
+	{  25, { 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 6} },
+	{25.5, { 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 6} },
+	{  26, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 5} },
+	{26.5, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 5} },
+	{  27, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 5} },
+	{27.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 5} },
+	{  28, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 4} },
+	{28.5, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 4} },
+	{  29, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3} },
+	{29.5, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3} },
+	{  30, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3} }
+};
+
+
+const qp_table   qp_table_420_8bpc_max = {
+	{   4, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 13, 14} },
+	{ 4.5, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
+	{   5, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 12, 13} },
+	{ 5.5, { 3, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 10, 10, 11, 12} },
+	{   6, { 2, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 9, 10, 11} },
+	{ 6.5, { 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 11} },
+	{   7, { 1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 8, 8, 9, 9, 10} },
+	{ 7.5, { 1, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7, 7, 8, 8, 9} },
+	{   8, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
+	{ 8.5, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 7, 8} },
+	{   9, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7} },
+	{ 9.5, { 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 7} },
+	{  10, { 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6} },
+	{10.5, { 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 6} },
+	{  11, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5} },
+	{11.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5} },
+	{  12, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 4} }
+};
+
+
+const qp_table   qp_table_444_8bpc_min = {
+	{   6, { 0, 1, 3, 3, 5, 5, 5, 5, 5, 6, 6, 6, 6, 9, 14} },
+	{ 6.5, { 0, 1, 2, 3, 4, 4, 5, 5, 5, 5, 6, 6, 6, 9, 14} },
+	{   7, { 0, 0, 2, 2, 4, 4, 4, 4, 4, 5, 5, 6, 6, 9, 13} },
+	{ 7.5, { 0, 0, 2, 2, 3, 4, 4, 4, 4, 4, 5, 5, 6, 9, 13} },
+	{   8, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 4, 5, 5, 5, 8, 12} },
+	{ 8.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 4, 5, 5, 5, 8, 12} },
+	{   9, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 12} },
+	{ 9.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 12} },
+	{  10, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
+	{10.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
+	{  11, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
+	{11.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
+	{  12, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
+	{12.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 4, 5, 5, 7, 10} },
+	{  13, { 0, 0, 1, 1, 2, 3, 3, 3, 3, 3, 4, 5, 5, 7, 9} },
+	{13.5, { 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 4, 5, 5, 7, 9} },
+	{  14, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 4, 5, 5, 7, 9} },
+	{14.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 4, 4, 5, 7, 8} },
+	{  15, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
+	{15.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
+	{  16, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
+	{16.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
+	{  17, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 7} },
+	{17.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 7} },
+	{  18, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 6} },
+	{18.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 6} },
+	{  19, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 5} },
+	{19.5, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 5} },
+	{  20, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 3, 5} },
+	{20.5, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 3, 5} },
+	{  21, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 4} },
+	{21.5, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 4} },
+	{  22, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 4} },
+	{22.5, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3} },
+	{  23, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3} },
+	{23.5, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3} },
+	{  24, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3} }
+};
+
+
+const qp_table   qp_table_444_12bpc_min = {
+	{   6, { 0, 5, 11, 11, 13, 13, 13, 13, 13, 14, 14, 14, 14, 17, 22} },
+	{ 6.5, { 0, 5, 10, 11, 12, 12, 13, 13, 13, 13, 14, 14, 14, 17, 22} },
+	{   7, { 0, 5, 10, 10, 12, 12, 12, 12, 12, 13, 13, 14, 14, 17, 21} },
+	{ 7.5, { 0, 5, 9, 10, 11, 12, 12, 12, 12, 12, 13, 13, 14, 17, 21} },
+	{   8, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 12, 13, 13, 13, 16, 20} },
+	{ 8.5, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 12, 13, 13, 13, 16, 20} },
+	{   9, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 20} },
+	{ 9.5, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 20} },
+	{  10, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
+	{10.5, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
+	{  11, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
+	{11.5, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
+	{  12, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
+	{12.5, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
+	{  13, { 0, 4, 7, 8, 9, 11, 11, 11, 11, 11, 13, 13, 13, 15, 17} },
+	{13.5, { 0, 3, 6, 7, 9, 10, 10, 11, 11, 11, 12, 13, 13, 15, 17} },
+	{  14, { 0, 3, 5, 6, 9, 9, 9, 10, 11, 11, 12, 13, 13, 15, 17} },
+	{14.5, { 0, 2, 5, 6, 8, 9, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
+	{  15, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
+	{15.5, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
+	{  16, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 11, 12, 12, 14, 15} },
+	{16.5, { 0, 2, 3, 5, 7, 8, 9, 10, 11, 11, 11, 12, 12, 14, 15} },
+	{  17, { 0, 2, 3, 5, 5, 6, 9, 9, 10, 10, 11, 11, 12, 13, 15} },
+	{17.5, { 0, 2, 3, 5, 5, 6, 8, 9, 10, 10, 11, 11, 12, 13, 15} },
+	{  18, { 0, 2, 3, 5, 5, 6, 8, 9, 10, 10, 11, 11, 12, 13, 14} },
+	{18.5, { 0, 2, 3, 5, 5, 6, 8, 9, 10, 10, 11, 11, 12, 13, 14} },
+	{  19, { 0, 1, 2, 4, 5, 5, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
+	{19.5, { 0, 1, 2, 4, 5, 5, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
+	{  20, { 0, 1, 2, 3, 4, 5, 7, 8, 8, 8, 9, 10, 10, 11, 13} },
+	{20.5, { 0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 10, 10, 11, 13} },
+	{  21, { 0, 1, 2, 3, 4, 5, 5, 7, 7, 8, 9, 10, 10, 11, 13} },
+	{21.5, { 0, 1, 2, 3, 3, 4, 5, 7, 7, 8, 9, 10, 10, 11, 12} },
+	{  22, { 0, 0, 1, 3, 3, 4, 5, 6, 7, 8, 9, 9, 9, 10, 12} },
+	{22.5, { 0, 0, 1, 3, 3, 4, 5, 6, 7, 8, 9, 9, 9, 10, 11} },
+	{  23, { 0, 0, 1, 3, 3, 4, 5, 6, 6, 7, 9, 9, 9, 9, 11} },
+	{23.5, { 0, 0, 1, 3, 3, 4, 5, 6, 6, 7, 9, 9, 9, 9, 11} },
+	{  24, { 0, 0, 1, 2, 3, 4, 5, 6, 6, 7, 8, 8, 8, 9, 11} },
+	{24.5, { 0, 0, 1, 2, 3, 4, 4, 6, 6, 7, 8, 8, 8, 9, 11} },
+	{  25, { 0, 0, 1, 2, 3, 4, 4, 5, 6, 7, 8, 8, 8, 8, 10} },
+	{25.5, { 0, 0, 1, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 8, 10} },
+	{  26, { 0, 0, 1, 2, 2, 3, 4, 5, 5, 6, 7, 7, 7, 7, 9} },
+	{26.5, { 0, 0, 1, 2, 2, 3, 4, 5, 5, 5, 7, 7, 7, 7, 9} },
+	{  27, { 0, 0, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 7, 9} },
+	{27.5, { 0, 0, 1, 1, 2, 2, 4, 4, 4, 5, 6, 7, 7, 7, 9} },
+	{  28, { 0, 0, 0, 1, 1, 2, 3, 4, 4, 4, 6, 6, 6, 7, 9} },
+	{28.5, { 0, 0, 0, 1, 1, 2, 3, 3, 4, 4, 5, 6, 6, 6, 8} },
+	{  29, { 0, 0, 0, 1, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 8} },
+	{29.5, { 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 5, 5, 6, 6, 7} },
+	{  30, { 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 5, 5, 5, 5, 7} },
+	{30.5, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 4, 4, 5, 7} },
+	{  31, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 4, 4, 5, 7} },
+	{31.5, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 7} },
+	{  32, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 4, 6} },
+	{32.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 3, 3, 3, 4, 6} },
+	{  33, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 5} },
+	{33.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 5} },
+	{  34, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 5} },
+	{34.5, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 3, 5} },
+	{  35, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 4} },
+	{35.5, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 4} },
+	{  36, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3} }
+};
+
+
+const qp_table   qp_table_420_12bpc_min = {
+	{   4, { 0, 4, 9, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 21} },
+	{ 4.5, { 0, 4, 8, 9, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 20} },
+	{   5, { 0, 4, 8, 9, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 20} },
+	{ 5.5, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
+	{   6, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
+	{ 6.5, { 0, 4, 6, 8, 9, 10, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
+	{   7, { 0, 3, 5, 7, 9, 10, 10, 11, 11, 11, 13, 13, 13, 15, 17} },
+	{ 7.5, { 0, 3, 5, 7, 8, 9, 10, 10, 11, 11, 12, 13, 13, 15, 16} },
+	{   8, { 0, 2, 4, 6, 7, 9, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
+	{ 8.5, { 0, 2, 4, 6, 6, 9, 9, 10, 11, 11, 12, 12, 13, 14, 15} },
+	{   9, { 0, 2, 4, 6, 6, 9, 9, 10, 10, 11, 11, 12, 13, 13, 14} },
+	{ 9.5, { 0, 2, 4, 5, 6, 8, 8, 9, 10, 10, 11, 12, 12, 13, 14} },
+	{  10, { 0, 2, 3, 5, 6, 7, 8, 8, 9, 10, 10, 12, 12, 12, 14} },
+	{10.5, { 0, 2, 3, 4, 5, 6, 7, 8, 9, 9, 10, 11, 11, 11, 13} },
+	{  11, { 0, 2, 3, 4, 5, 5, 6, 8, 8, 9, 9, 10, 11, 11, 12} },
+	{11.5, { 0, 1, 2, 3, 4, 5, 5, 7, 8, 8, 9, 10, 10, 10, 12} },
+	{  12, { 0, 0, 2, 2, 3, 4, 5, 6, 7, 8, 8, 9, 9, 9, 11} },
+	{12.5, { 0, 0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 8, 8, 9, 10} },
+	{  13, { 0, 0, 0, 1, 3, 3, 5, 5, 6, 7, 7, 8, 8, 8, 10} },
+	{13.5, { 0, 0, 0, 1, 2, 3, 4, 4, 5, 6, 7, 7, 7, 8, 10} },
+	{  14, { 0, 0, 0, 1, 2, 3, 3, 4, 5, 5, 6, 7, 7, 7, 9} },
+	{14.5, { 0, 0, 0, 0, 1, 2, 3, 3, 4, 4, 5, 6, 6, 6, 8} },
+	{  15, { 0, 0, 0, 0, 0, 1, 2, 2, 4, 4, 4, 5, 5, 6, 8} },
+	{15.5, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 7} },
+	{  16, { 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 6} },
+	{16.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 6} },
+	{  17, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 5} },
+	{17.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 3, 5} },
+	{  18, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 4} }
+};
+
+
+const qp_table   qp_table_422_12bpc_min = {
+	{   6, { 0, 4, 9, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 16, 20} },
+	{ 6.5, { 0, 4, 9, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 16, 20} },
+	{   7, { 0, 4, 9, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
+	{ 7.5, { 0, 4, 8, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
+	{   8, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
+	{ 8.5, { 0, 3, 6, 8, 9, 10, 10, 11, 11, 11, 12, 13, 13, 15, 18} },
+	{   9, { 0, 3, 5, 8, 9, 10, 10, 10, 11, 11, 12, 13, 13, 15, 17} },
+	{ 9.5, { 0, 3, 5, 7, 8, 9, 10, 10, 11, 11, 12, 13, 13, 15, 17} },
+	{  10, { 0, 2, 4, 6, 7, 9, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
+	{10.5, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
+	{  11, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 12, 12, 13, 14, 15} },
+	{11.5, { 0, 2, 4, 6, 7, 7, 9, 9, 10, 11, 11, 12, 12, 14, 15} },
+	{  12, { 0, 2, 4, 6, 6, 6, 8, 8, 9, 9, 11, 11, 12, 13, 14} },
+	{12.5, { 0, 1, 4, 5, 6, 6, 7, 8, 8, 9, 10, 11, 11, 13, 14} },
+	{  13, { 0, 1, 3, 4, 5, 5, 7, 8, 8, 9, 10, 10, 11, 12, 13} },
+	{13.5, { 0, 1, 3, 3, 4, 5, 7, 7, 8, 8, 10, 10, 10, 12, 13} },
+	{  14, { 0, 0, 2, 3, 4, 5, 6, 6, 7, 7, 9, 10, 10, 11, 12} },
+	{14.5, { 0, 0, 1, 3, 4, 4, 6, 6, 6, 7, 9, 9, 9, 11, 12} },
+	{  15, { 0, 0, 1, 3, 3, 4, 5, 6, 6, 6, 8, 9, 9, 10, 12} },
+	{15.5, { 0, 0, 1, 2, 3, 4, 5, 5, 6, 6, 8, 8, 8, 10, 11} },
+	{  16, { 0, 0, 1, 2, 3, 4, 5, 5, 6, 6, 8, 8, 8, 9, 11} },
+	{16.5, { 0, 0, 0, 2, 2, 3, 4, 5, 5, 5, 6, 7, 7, 9, 10} },
+	{  17, { 0, 0, 0, 1, 2, 2, 4, 4, 4, 5, 6, 6, 6, 8, 10} },
+	{17.5, { 0, 0, 0, 1, 2, 2, 3, 4, 4, 4, 5, 6, 6, 8, 9} },
+	{  18, { 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 5, 5, 6, 7, 9} },
+	{18.5, { 0, 0, 0, 1, 2, 2, 3, 3, 3, 3, 5, 5, 5, 7, 9} },
+	{  19, { 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 6, 8} },
+	{19.5, { 0, 0, 0, 1, 1, 1, 2, 3, 3, 3, 4, 4, 4, 6, 8} },
+	{  20, { 0, 0, 0, 1, 1, 1, 2, 3, 3, 3, 4, 4, 4, 5, 7} },
+	{20.5, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 7} },
+	{  21, { 0, 0, 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 6} },
+	{21.5, { 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 6} },
+	{  22, { 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 6} },
+	{22.5, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 5} },
+	{  23, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 5} },
+	{23.5, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 4} },
+	{  24, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 4} }
+};
+
+
+const qp_table   qp_table_422_12bpc_max = {
+	{   6, {12, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
+	{ 6.5, {12, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
+	{   7, {11, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20} },
+	{ 7.5, { 9, 10, 12, 14, 15, 15, 15, 16, 16, 17, 17, 18, 18, 19, 20} },
+	{   8, { 6, 9, 10, 12, 14, 15, 15, 16, 16, 17, 17, 17, 17, 18, 19} },
+	{ 8.5, { 6, 8, 9, 11, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 19} },
+	{   9, { 5, 7, 8, 10, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 18} },
+	{ 9.5, { 5, 7, 7, 9, 10, 12, 12, 13, 14, 14, 15, 15, 16, 17, 18} },
+	{  10, { 4, 6, 6, 8, 9, 11, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
+	{10.5, { 4, 6, 6, 8, 9, 10, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
+	{  11, { 4, 5, 6, 8, 9, 10, 11, 12, 13, 13, 14, 14, 15, 15, 16} },
+	{11.5, { 3, 5, 6, 8, 9, 9, 11, 11, 12, 13, 13, 14, 14, 15, 16} },
+	{  12, { 3, 5, 6, 8, 8, 8, 10, 10, 11, 11, 13, 13, 14, 14, 15} },
+	{12.5, { 3, 4, 6, 7, 8, 8, 9, 10, 10, 11, 12, 13, 13, 14, 15} },
+	{  13, { 2, 4, 5, 6, 7, 7, 9, 10, 10, 11, 12, 12, 13, 13, 14} },
+	{13.5, { 2, 4, 5, 5, 6, 7, 9, 9, 10, 10, 12, 12, 12, 13, 14} },
+	{  14, { 2, 3, 4, 5, 6, 7, 8, 8, 9, 9, 11, 12, 12, 12, 13} },
+	{14.5, { 2, 3, 3, 5, 6, 6, 8, 8, 8, 9, 11, 11, 11, 12, 13} },
+	{  15, { 2, 3, 3, 5, 5, 6, 7, 8, 8, 8, 10, 11, 11, 11, 13} },
+	{15.5, { 2, 2, 3, 4, 5, 6, 7, 7, 8, 8, 10, 10, 10, 11, 12} },
+	{  16, { 2, 2, 3, 4, 5, 6, 7, 7, 8, 8, 10, 10, 10, 10, 12} },
+	{16.5, { 1, 2, 2, 4, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 11} },
+	{  17, { 1, 1, 2, 3, 4, 4, 6, 6, 6, 7, 8, 8, 8, 9, 11} },
+	{17.5, { 1, 1, 2, 3, 4, 4, 5, 6, 6, 6, 7, 8, 8, 9, 10} },
+	{  18, { 1, 1, 1, 2, 3, 3, 5, 5, 5, 6, 7, 7, 8, 8, 10} },
+	{18.5, { 1, 1, 1, 2, 3, 3, 5, 5, 5, 5, 7, 7, 7, 8, 10} },
+	{  19, { 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 7, 9} },
+	{19.5, { 1, 1, 1, 2, 2, 2, 4, 5, 5, 5, 6, 6, 6, 7, 9} },
+	{  20, { 1, 1, 1, 2, 2, 2, 4, 5, 5, 5, 6, 6, 6, 6, 8} },
+	{20.5, { 0, 0, 0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 8} },
+	{  21, { 0, 0, 0, 1, 1, 2, 3, 3, 4, 4, 4, 5, 5, 5, 7} },
+	{21.5, { 0, 0, 0, 0, 1, 1, 2, 3, 3, 3, 4, 4, 4, 5, 7} },
+	{  22, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 5, 7} },
+	{22.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 6} },
+	{  23, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 3, 4, 6} },
+	{23.5, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 5} },
+	{  24, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 5} }
+};
+
+
+const qp_table   qp_table_444_12bpc_max = {
+	{   6, {12, 14, 16, 16, 17, 17, 17, 18, 19, 20, 20, 20, 20, 21, 23} },
+	{ 6.5, {12, 14, 15, 16, 16, 16, 17, 18, 19, 19, 20, 20, 20, 21, 23} },
+	{   7, {12, 13, 15, 15, 16, 16, 16, 17, 18, 19, 19, 20, 20, 21, 22} },
+	{ 7.5, {12, 13, 14, 15, 15, 16, 16, 17, 18, 18, 19, 19, 20, 21, 22} },
+	{   8, {12, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
+	{ 8.5, {12, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
+	{   9, {11, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 21} },
+	{ 9.5, {11, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 21} },
+	{  10, {11, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20} },
+	{10.5, {10, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 18, 19, 20} },
+	{  11, { 9, 11, 13, 14, 15, 15, 15, 16, 16, 17, 17, 17, 18, 18, 19} },
+	{11.5, { 9, 11, 13, 14, 15, 15, 15, 16, 16, 17, 17, 17, 17, 18, 19} },
+	{  12, { 6, 9, 12, 13, 14, 14, 15, 16, 16, 17, 17, 17, 17, 18, 19} },
+	{12.5, { 6, 9, 12, 13, 14, 14, 14, 15, 15, 16, 16, 17, 17, 18, 19} },
+	{  13, { 5, 9, 12, 13, 13, 14, 14, 15, 15, 16, 16, 16, 16, 17, 18} },
+	{13.5, { 5, 8, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 18} },
+	{  14, { 5, 8, 10, 11, 12, 12, 12, 13, 14, 14, 15, 16, 16, 16, 18} },
+	{14.5, { 4, 7, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17} },
+	{  15, { 4, 7, 9, 10, 10, 11, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
+	{15.5, { 4, 7, 9, 10, 10, 11, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
+	{  16, { 4, 7, 9, 10, 10, 11, 11, 12, 13, 13, 13, 14, 14, 15, 16} },
+	{16.5, { 4, 5, 7, 8, 10, 11, 11, 12, 13, 13, 13, 14, 14, 15, 16} },
+	{  17, { 4, 5, 7, 8, 8, 9, 11, 11, 12, 12, 12, 13, 13, 14, 16} },
+	{17.5, { 3, 5, 7, 8, 8, 9, 10, 11, 12, 12, 12, 13, 13, 14, 16} },
+	{  18, { 3, 5, 7, 8, 8, 9, 10, 11, 12, 12, 12, 13, 13, 14, 15} },
+	{18.5, { 3, 5, 7, 8, 8, 9, 10, 11, 12, 12, 12, 13, 13, 14, 15} },
+	{  19, { 3, 4, 6, 7, 8, 8, 9, 10, 11, 11, 11, 12, 12, 13, 14} },
+	{19.5, { 3, 4, 6, 7, 8, 8, 9, 10, 11, 11, 11, 12, 12, 13, 14} },
+	{  20, { 2, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11, 11, 12, 14} },
+	{20.5, { 2, 3, 5, 5, 7, 8, 8, 8, 9, 10, 10, 11, 11, 12, 14} },
+	{  21, { 2, 3, 5, 5, 7, 7, 7, 8, 8, 9, 10, 11, 11, 12, 14} },
+	{21.5, { 2, 3, 5, 5, 6, 6, 7, 8, 8, 9, 10, 11, 11, 12, 13} },
+	{  22, { 2, 2, 4, 5, 6, 6, 7, 7, 8, 9, 10, 10, 10, 11, 13} },
+	{22.5, { 2, 2, 4, 5, 5, 6, 7, 7, 8, 9, 10, 10, 10, 11, 12} },
+	{  23, { 2, 2, 4, 5, 5, 6, 7, 7, 7, 8, 10, 10, 10, 10, 12} },
+	{23.5, { 2, 2, 3, 5, 5, 6, 7, 7, 7, 8, 10, 10, 10, 10, 12} },
+	{  24, { 2, 2, 3, 4, 4, 5, 7, 7, 7, 8, 9, 9, 9, 10, 12} },
+	{24.5, { 1, 2, 3, 4, 4, 5, 6, 7, 7, 8, 9, 9, 9, 10, 12} },
+	{  25, { 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 9, 9, 11} },
+	{25.5, { 1, 1, 3, 3, 4, 5, 6, 6, 7, 7, 8, 9, 9, 9, 11} },
+	{  26, { 1, 1, 3, 3, 3, 4, 5, 6, 6, 7, 8, 8, 8, 8, 10} },
+	{26.5, { 1, 1, 2, 3, 3, 4, 5, 6, 6, 6, 8, 8, 8, 8, 10} },
+	{  27, { 1, 1, 2, 3, 3, 4, 5, 5, 6, 6, 7, 8, 8, 8, 10} },
+	{27.5, { 1, 1, 2, 2, 3, 3, 5, 5, 5, 6, 7, 8, 8, 8, 10} },
+	{  28, { 0, 1, 1, 2, 2, 3, 4, 5, 5, 5, 7, 7, 7, 8, 10} },
+	{28.5, { 0, 1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 7, 9} },
+	{  29, { 0, 1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 9} },
+	{29.5, { 0, 1, 1, 2, 2, 2, 3, 3, 4, 5, 6, 6, 7, 7, 8} },
+	{  30, { 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 6, 6, 6, 6, 8} },
+	{30.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 8} },
+	{  31, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 8} },
+	{31.5, { 0, 0, 0, 0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 8} },
+	{  32, { 0, 0, 0, 0, 1, 2, 2, 3, 3, 4, 4, 4, 4, 5, 7} },
+	{32.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 4, 4, 4, 5, 7} },
+	{  33, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 6} },
+	{33.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 6} },
+	{  34, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 3, 4, 6} },
+	{34.5, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 3, 3, 3, 3, 4, 6} },
+	{  35, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 5} },
+	{35.5, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 5} },
+	{  36, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 4} }
+};
+
+
+const qp_table   qp_table_420_8bpc_min = {
+	{   4, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 9, 13} },
+	{ 4.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 8, 12} },
+	{   5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 8, 12} },
+	{ 5.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
+	{   6, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
+	{ 6.5, { 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 4, 5, 5, 7, 10} },
+	{   7, { 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 4, 5, 5, 7, 9} },
+	{ 7.5, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 4, 4, 5, 7, 8} },
+	{   8, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
+	{ 8.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
+	{   9, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6} },
+	{ 9.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 6} },
+	{  10, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5} },
+	{10.5, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 3, 5} },
+	{  11, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4} },
+	{11.5, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 4} },
+	{  12, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 3} }
+};
+
+
+const qp_table   qp_table_422_8bpc_min = {
+	{   6, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 8, 12} },
+	{ 6.5, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 8, 12} },
+	{   7, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
+	{ 7.5, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
+	{   8, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
+	{ 8.5, { 0, 0, 1, 2, 2, 2, 2, 3, 3, 3, 4, 5, 5, 7, 10} },
+	{   9, { 0, 0, 0, 1, 2, 2, 2, 2, 2, 3, 4, 5, 5, 7, 9} },
+	{ 9.5, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 9} },
+	{  10, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
+	{10.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
+	{  11, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
+	{11.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
+	{  12, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 5, 6} },
+	{12.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 6} },
+	{  13, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 4, 4, 5} },
+	{13.5, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 4, 5} },
+	{  14, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4} },
+	{14.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 4} },
+	{  15, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 4} },
+	{15.5, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3} },
+	{  16, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3} }
+};
+
+
+const qp_table   qp_table_422_10bpc_max = {
+	{   6, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
+	{ 6.5, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
+	{   7, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 15, 16} },
+	{ 7.5, { 5, 6, 8, 10, 11, 11, 11, 12, 12, 13, 13, 14, 14, 15, 16} },
+	{   8, { 4, 6, 7, 9, 10, 11, 11, 12, 12, 13, 13, 13, 13, 14, 15} },
+	{ 8.5, { 4, 5, 6, 8, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 15} },
+	{   9, { 3, 4, 5, 7, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14} },
+	{ 9.5, { 3, 4, 4, 6, 6, 8, 8, 9, 10, 10, 11, 11, 12, 13, 14} },
+	{  10, { 2, 3, 3, 5, 5, 7, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
+	{10.5, { 2, 3, 3, 5, 5, 6, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
+	{  11, { 2, 3, 3, 5, 5, 6, 7, 8, 9, 9, 10, 10, 11, 11, 12} },
+	{11.5, { 2, 3, 3, 5, 5, 5, 7, 7, 8, 9, 9, 10, 10, 11, 12} },
+	{  12, { 2, 3, 3, 5, 5, 5, 7, 7, 8, 8, 9, 9, 10, 10, 11} },
+	{12.5, { 2, 2, 3, 4, 5, 5, 6, 7, 7, 8, 8, 9, 9, 10, 11} },
+	{  13, { 1, 2, 3, 4, 5, 5, 6, 7, 7, 8, 8, 8, 9, 9, 10} },
+	{13.5, { 1, 2, 3, 3, 4, 5, 6, 6, 7, 7, 8, 8, 8, 9, 10} },
+	{  14, { 1, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 8, 8, 8, 9} },
+	{14.5, { 1, 2, 2, 3, 4, 4, 5, 5, 5, 6, 7, 7, 7, 8, 9} },
+	{  15, { 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 7, 7, 7, 9} },
+	{15.5, { 1, 1, 2, 2, 3, 4, 4, 4, 5, 5, 6, 6, 6, 7, 8} },
+	{  16, { 1, 1, 2, 2, 3, 4, 4, 4, 5, 5, 6, 6, 6, 6, 8} },
+	{16.5, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 6, 7} },
+	{  17, { 0, 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 7} },
+	{17.5, { 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6} },
+	{  18, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 6} },
+	{18.5, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 6} },
+	{  19, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 5} },
+	{19.5, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 5} },
+	{  20, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 4} }
+};
+
+
+const qp_table qp_table_420_10bpc_max = {
+	{   4, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 17, 18} },
+	{ 4.5, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
+	{   5, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 16, 17} },
+	{ 5.5, { 6, 7, 8, 9, 10, 10, 11, 12, 12, 13, 13, 14, 14, 15, 16} },
+	{   6, { 4, 6, 8, 9, 10, 10, 11, 12, 12, 13, 13, 13, 13, 14, 15} },
+	{ 6.5, { 4, 5, 7, 8, 8, 9, 10, 11, 11, 12, 12, 13, 13, 14, 15} },
+	{   7, { 3, 4, 6, 7, 7, 8, 9, 10, 10, 11, 12, 12, 13, 13, 14} },
+	{ 7.5, { 3, 4, 5, 6, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12, 13} },
+	{   8, { 2, 3, 4, 5, 5, 6, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
+	{ 8.5, { 1, 3, 3, 4, 4, 6, 7, 8, 9, 9, 10, 10, 11, 11, 12} },
+	{   9, { 1, 3, 3, 4, 4, 6, 7, 8, 8, 9, 9, 10, 10, 10, 11} },
+	{ 9.5, { 1, 3, 3, 3, 4, 5, 6, 7, 8, 8, 9, 9, 9, 10, 11} },
+	{  10, { 1, 2, 3, 3, 4, 4, 5, 6, 7, 8, 8, 9, 9, 9, 11} },
+	{10.5, { 1, 1, 3, 3, 3, 4, 5, 5, 7, 7, 8, 8, 8, 8, 10} },
+	{  11, { 0, 1, 2, 3, 3, 3, 4, 5, 6, 7, 7, 7, 8, 8, 9} },
+	{11.5, { 0, 1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 7, 7, 7, 9} },
+	{  12, { 0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 6, 8} },
+	{12.5, { 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 7} },
+	{  13, { 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 4, 5, 5, 5, 7} },
+	{13.5, { 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 6} },
+	{  14, { 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 6} },
+	{14.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 5} },
+	{  15, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 5} }
+};
+
+
+const qp_table   qp_table_420_10bpc_min = {
+	{   4, { 0, 4, 4, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 13, 17} },
+	{ 4.5, { 0, 4, 4, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 16} },
+	{   5, { 0, 4, 4, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 16} },
+	{ 5.5, { 0, 3, 3, 4, 6, 7, 7, 7, 7, 7, 9, 9, 9, 11, 15} },
+	{   6, { 0, 2, 3, 4, 6, 7, 7, 7, 7, 7, 9, 9, 9, 11, 14} },
+	{ 6.5, { 0, 2, 3, 4, 5, 6, 6, 7, 7, 7, 8, 9, 9, 11, 14} },
+	{   7, { 0, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 11, 13} },
+	{ 7.5, { 0, 2, 3, 4, 4, 5, 5, 6, 7, 7, 8, 8, 9, 11, 12} },
+	{   8, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 7, 8, 8, 9, 11, 12} },
+	{ 8.5, { 0, 2, 2, 3, 3, 5, 5, 6, 6, 7, 8, 8, 9, 10, 11} },
+	{   9, { 0, 2, 2, 3, 3, 5, 5, 6, 6, 7, 7, 8, 9, 9, 10} },
+	{ 9.5, { 0, 2, 2, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9, 10} },
+	{  10, { 0, 1, 2, 2, 3, 3, 4, 4, 5, 6, 6, 8, 8, 8, 10} },
+	{10.5, { 0, 0, 2, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 7, 9} },
+	{  11, { 0, 0, 1, 2, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 8} },
+	{11.5, { 0, 0, 0, 1, 2, 2, 2, 3, 4, 4, 5, 6, 6, 6, 8} },
+	{  12, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 4, 5, 5, 5, 7} },
+	{12.5, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 6} },
+	{  13, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 6} },
+	{13.5, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 3, 5} },
+	{  14, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 5} },
+	{14.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 4} },
+	{  15, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 4} }
+};
+
+
+const qp_table   qp_table_444_10bpc_max = {
+	{   6, { 8, 10, 12, 12, 13, 13, 13, 14, 15, 16, 16, 16, 16, 17, 19} },
+	{ 6.5, { 8, 10, 11, 12, 12, 12, 13, 14, 15, 15, 16, 16, 16, 17, 19} },
+	{   7, { 8, 9, 11, 11, 12, 12, 12, 13, 14, 15, 15, 16, 16, 17, 18} },
+	{ 7.5, { 8, 9, 10, 11, 11, 12, 12, 13, 14, 14, 15, 15, 16, 17, 18} },
+	{   8, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
+	{ 8.5, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
+	{   9, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 15, 17} },
+	{ 9.5, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 15, 17} },
+	{  10, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 15, 16} },
+	{10.5, { 6, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 14, 15, 16} },
+	{  11, { 5, 7, 9, 10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15} },
+	{11.5, { 5, 7, 9, 10, 11, 11, 11, 12, 12, 13, 13, 13, 13, 14, 15} },
+	{  12, { 4, 6, 8, 9, 10, 10, 11, 12, 12, 13, 13, 13, 13, 14, 15} },
+	{12.5, { 4, 6, 8, 9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 15} },
+	{  13, { 3, 6, 8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 13, 14} },
+	{13.5, { 3, 5, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14} },
+	{  14, { 3, 5, 6, 7, 8, 8, 8, 9, 10, 10, 11, 12, 12, 12, 14} },
+	{14.5, { 2, 4, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 13} },
+	{  15, { 2, 4, 5, 6, 6, 7, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
+	{15.5, { 2, 4, 5, 6, 6, 7, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
+	{  16, { 2, 4, 5, 6, 6, 7, 7, 8, 9, 9, 9, 10, 10, 11, 12} },
+	{16.5, { 2, 3, 4, 5, 6, 7, 7, 8, 9, 9, 9, 10, 10, 11, 12} },
+	{  17, { 2, 3, 4, 5, 5, 6, 7, 7, 8, 8, 8, 9, 9, 10, 12} },
+	{17.5, { 1, 3, 4, 5, 5, 6, 6, 7, 8, 8, 8, 9, 9, 10, 12} },
+	{  18, { 1, 3, 4, 5, 5, 6, 6, 7, 8, 8, 8, 9, 9, 10, 11} },
+	{18.5, { 1, 3, 4, 5, 5, 6, 6, 7, 8, 8, 8, 9, 9, 10, 11} },
+	{  19, { 1, 2, 3, 4, 5, 5, 5, 6, 7, 7, 7, 8, 8, 9, 10} },
+	{19.5, { 1, 2, 3, 4, 5, 5, 5, 6, 7, 7, 7, 8, 8, 9, 10} },
+	{  20, { 1, 2, 3, 3, 4, 5, 5, 6, 6, 6, 6, 7, 7, 8, 10} },
+	{20.5, { 1, 2, 3, 3, 4, 5, 5, 5, 5, 6, 6, 7, 7, 8, 10} },
+	{  21, { 1, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 7, 7, 8, 10} },
+	{21.5, { 1, 2, 3, 3, 3, 3, 4, 5, 5, 5, 6, 7, 7, 8, 9} },
+	{  22, { 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 9} },
+	{22.5, { 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 8} },
+	{  23, { 1, 1, 2, 3, 3, 3, 4, 4, 4, 4, 6, 6, 6, 6, 8} },
+	{23.5, { 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 6, 6, 6, 6, 8} },
+	{  24, { 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 5, 5, 5, 6, 8} },
+	{24.5, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 8} },
+	{  25, { 0, 1, 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 5, 5, 7} },
+	{25.5, { 0, 0, 1, 1, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 7} },
+	{  26, { 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 4, 4, 4, 6} },
+	{26.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 6} },
+	{  27, { 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 6} },
+	{27.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 6} },
+	{  28, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 5} },
+	{28.5, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 5} },
+	{  29, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4} },
+	{29.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4} },
+	{  30, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 4} }
+};
+
+
+const qp_table   qp_table_422_8bpc_max = {
+	{   6, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
+	{ 6.5, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
+	{   7, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 11, 12} },
+	{ 7.5, { 3, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 10, 10, 11, 12} },
+	{   8, { 2, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 9, 10, 11} },
+	{ 8.5, { 2, 3, 4, 5, 6, 6, 6, 7, 7, 8, 8, 9, 9, 10, 11} },
+	{   9, { 1, 2, 3, 4, 5, 5, 5, 6, 6, 7, 7, 8, 8, 9, 10} },
+	{ 9.5, { 1, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7, 7, 8, 9, 10} },
+	{  10, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
+	{10.5, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
+	{  11, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 7, 8} },
+	{11.5, { 0, 1, 1, 2, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 8} },
+	{  12, { 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7} },
+	{12.5, { 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7} },
+	{  13, { 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6} },
+	{13.5, { 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5, 6} },
+	{  14, { 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5} },
+	{14.5, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 5} },
+	{  15, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 5} },
+	{15.5, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 4} },
+	{  16, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 4} }
+};
+
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
new file mode 100644
index 000000000000..3ee858f311d1
--- /dev/null
+++ b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
@@ -0,0 +1,291 @@
+/*
+ * Copyright 2021 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: AMD
+ *
+ */
+
+#include "rc_calc_fpu.h"
+
+#include "qp_tables.h"
+#include "amdgpu_dm/dc_fpu.h"
+
+#define table_hash(mode, bpc, max_min) ((mode << 16) | (bpc << 8) | max_min)
+
+#define MODE_SELECT(val444, val422, val420) \
+	(cm == CM_444 || cm == CM_RGB) ? (val444) : (cm == CM_422 ? (val422) : (val420))
+
+
+#define TABLE_CASE(mode, bpc, max)   case (table_hash(mode, BPC_##bpc, max)): \
+	table = qp_table_##mode##_##bpc##bpc_##max; \
+	table_size = sizeof(qp_table_##mode##_##bpc##bpc_##max)/sizeof(*qp_table_##mode##_##bpc##bpc_##max); \
+	break
+
+static int median3(int a, int b, int c)
+{
+	if (a > b)
+		swap(a, b);
+	if (b > c)
+		swap(b, c);
+	if (a > b)
+		swap(b, c);
+
+	return b;
+}
+
+static double dsc_roundf(double num)
+{
+	if (num < 0.0)
+		num = num - 0.5;
+	else
+		num = num + 0.5;
+
+	return (int)(num);
+}
+
+static double dsc_ceil(double num)
+{
+	double retval = (int)num;
+
+	if (retval != num && num > 0)
+		retval = num + 1;
+
+	return (int)retval;
+}
+
+static void get_qp_set(qp_set qps, enum colour_mode cm, enum bits_per_comp bpc,
+		       enum max_min max_min, float bpp)
+{
+	int mode = MODE_SELECT(444, 422, 420);
+	int sel = table_hash(mode, bpc, max_min);
+	int table_size = 0;
+	int index;
+	const struct qp_entry *table = 0L;
+
+	// alias enum
+	enum { min = DAL_MM_MIN, max = DAL_MM_MAX };
+	switch (sel) {
+		TABLE_CASE(444,  8, max);
+		TABLE_CASE(444,  8, min);
+		TABLE_CASE(444, 10, max);
+		TABLE_CASE(444, 10, min);
+		TABLE_CASE(444, 12, max);
+		TABLE_CASE(444, 12, min);
+		TABLE_CASE(422,  8, max);
+		TABLE_CASE(422,  8, min);
+		TABLE_CASE(422, 10, max);
+		TABLE_CASE(422, 10, min);
+		TABLE_CASE(422, 12, max);
+		TABLE_CASE(422, 12, min);
+		TABLE_CASE(420,  8, max);
+		TABLE_CASE(420,  8, min);
+		TABLE_CASE(420, 10, max);
+		TABLE_CASE(420, 10, min);
+		TABLE_CASE(420, 12, max);
+		TABLE_CASE(420, 12, min);
+	}
+
+	if (table == 0)
+		return;
+
+	index = (bpp - table[0].bpp) * 2;
+
+	/* requested size is bigger than the table */
+	if (index >= table_size) {
+		dm_error("ERROR: Requested rc_calc to find a bpp entry that exceeds the table size\n");
+		return;
+	}
+
+	memcpy(qps, table[index].qps, sizeof(qp_set));
+}
+
+static void get_ofs_set(qp_set ofs, enum colour_mode mode, float bpp)
+{
+	int   *p = ofs;
+
+	if (mode == CM_444 || mode == CM_RGB) {
+		*p++ = (bpp <=  6) ? (0) : ((((bpp >=  8) && (bpp <= 12))) ? (2) : ((bpp >= 15) ? (10) : ((((bpp > 6) && (bpp < 8))) ? (0 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (2 + dsc_roundf((bpp - 12) * (8 / 3.0))))));
+		*p++ = (bpp <=  6) ? (-2) : ((((bpp >=  8) && (bpp <= 12))) ? (0) : ((bpp >= 15) ? (8) : ((((bpp > 6) && (bpp < 8))) ? (-2 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (0 + dsc_roundf((bpp - 12) * (8 / 3.0))))));
+		*p++ = (bpp <=  6) ? (-2) : ((((bpp >=  8) && (bpp <= 12))) ? (0) : ((bpp >= 15) ? (6) : ((((bpp > 6) && (bpp < 8))) ? (-2 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (0 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
+		*p++ = (bpp <=  6) ? (-4) : ((((bpp >=  8) && (bpp <= 12))) ? (-2) : ((bpp >= 15) ? (4) : ((((bpp > 6) && (bpp < 8))) ? (-4 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (-2 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
+		*p++ = (bpp <=  6) ? (-6) : ((((bpp >=  8) && (bpp <= 12))) ? (-4) : ((bpp >= 15) ? (2) : ((((bpp > 6) && (bpp < 8))) ? (-6 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (-4 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
+		*p++ = (bpp <= 12) ? (-6) : ((bpp >= 15) ? (0) : (-6 + dsc_roundf((bpp - 12) * (6 / 3.0))));
+		*p++ = (bpp <= 12) ? (-8) : ((bpp >= 15) ? (-2) : (-8 + dsc_roundf((bpp - 12) * (6 / 3.0))));
+		*p++ = (bpp <= 12) ? (-8) : ((bpp >= 15) ? (-4) : (-8 + dsc_roundf((bpp - 12) * (4 / 3.0))));
+		*p++ = (bpp <= 12) ? (-8) : ((bpp >= 15) ? (-6) : (-8 + dsc_roundf((bpp - 12) * (2 / 3.0))));
+		*p++ = (bpp <= 12) ? (-10) : ((bpp >= 15) ? (-8) : (-10 + dsc_roundf((bpp - 12) * (2 / 3.0))));
+		*p++ = -10;
+		*p++ = (bpp <=  6) ? (-12) : ((bpp >=  8) ? (-10) : (-12 + dsc_roundf((bpp -  6) * (2 / 2.0))));
+		*p++ = -12;
+		*p++ = -12;
+		*p++ = -12;
+	} else if (mode == CM_422) {
+		*p++ = (bpp <=  8) ? (2) : ((bpp >= 10) ? (10) : (2 + dsc_roundf((bpp -  8) * (8 / 2.0))));
+		*p++ = (bpp <=  8) ? (0) : ((bpp >= 10) ? (8) : (0 + dsc_roundf((bpp -  8) * (8 / 2.0))));
+		*p++ = (bpp <=  8) ? (0) : ((bpp >= 10) ? (6) : (0 + dsc_roundf((bpp -  8) * (6 / 2.0))));
+		*p++ = (bpp <=  8) ? (-2) : ((bpp >= 10) ? (4) : (-2 + dsc_roundf((bpp -  8) * (6 / 2.0))));
+		*p++ = (bpp <=  8) ? (-4) : ((bpp >= 10) ? (2) : (-4 + dsc_roundf((bpp -  8) * (6 / 2.0))));
+		*p++ = (bpp <=  8) ? (-6) : ((bpp >= 10) ? (0) : (-6 + dsc_roundf((bpp -  8) * (6 / 2.0))));
+		*p++ = (bpp <=  8) ? (-8) : ((bpp >= 10) ? (-2) : (-8 + dsc_roundf((bpp -  8) * (6 / 2.0))));
+		*p++ = (bpp <=  8) ? (-8) : ((bpp >= 10) ? (-4) : (-8 + dsc_roundf((bpp -  8) * (4 / 2.0))));
+		*p++ = (bpp <=  8) ? (-8) : ((bpp >= 10) ? (-6) : (-8 + dsc_roundf((bpp -  8) * (2 / 2.0))));
+		*p++ = (bpp <=  8) ? (-10) : ((bpp >= 10) ? (-8) : (-10 + dsc_roundf((bpp -  8) * (2 / 2.0))));
+		*p++ = -10;
+		*p++ = (bpp <=  6) ? (-12) : ((bpp >= 7) ? (-10) : (-12 + dsc_roundf((bpp -  6) * (2.0 / 1))));
+		*p++ = -12;
+		*p++ = -12;
+		*p++ = -12;
+	} else {
+		*p++ = (bpp <=  6) ? (2) : ((bpp >=  8) ? (10) : (2 + dsc_roundf((bpp -  6) * (8 / 2.0))));
+		*p++ = (bpp <=  6) ? (0) : ((bpp >=  8) ? (8) : (0 + dsc_roundf((bpp -  6) * (8 / 2.0))));
+		*p++ = (bpp <=  6) ? (0) : ((bpp >=  8) ? (6) : (0 + dsc_roundf((bpp -  6) * (6 / 2.0))));
+		*p++ = (bpp <=  6) ? (-2) : ((bpp >=  8) ? (4) : (-2 + dsc_roundf((bpp -  6) * (6 / 2.0))));
+		*p++ = (bpp <=  6) ? (-4) : ((bpp >=  8) ? (2) : (-4 + dsc_roundf((bpp -  6) * (6 / 2.0))));
+		*p++ = (bpp <=  6) ? (-6) : ((bpp >=  8) ? (0) : (-6 + dsc_roundf((bpp -  6) * (6 / 2.0))));
+		*p++ = (bpp <=  6) ? (-8) : ((bpp >=  8) ? (-2) : (-8 + dsc_roundf((bpp -  6) * (6 / 2.0))));
+		*p++ = (bpp <=  6) ? (-8) : ((bpp >=  8) ? (-4) : (-8 + dsc_roundf((bpp -  6) * (4 / 2.0))));
+		*p++ = (bpp <=  6) ? (-8) : ((bpp >=  8) ? (-6) : (-8 + dsc_roundf((bpp -  6) * (2 / 2.0))));
+		*p++ = (bpp <=  6) ? (-10) : ((bpp >=  8) ? (-8) : (-10 + dsc_roundf((bpp -  6) * (2 / 2.0))));
+		*p++ = -10;
+		*p++ = (bpp <=  4) ? (-12) : ((bpp >=  5) ? (-10) : (-12 + dsc_roundf((bpp -  4) * (2 / 1.0))));
+		*p++ = -12;
+		*p++ = -12;
+		*p++ = -12;
+	}
+}
+
+void _do_calc_rc_params(struct rc_params *rc,
+		enum colour_mode cm,
+		enum bits_per_comp bpc,
+		u16 drm_bpp,
+		bool is_navite_422_or_420,
+		int slice_width,
+		int slice_height,
+		int minor_version)
+{
+	float bpp;
+	float bpp_group;
+	float initial_xmit_delay_factor;
+	int padding_pixels;
+	int i;
+
+	dc_assert_fp_enabled();
+
+	bpp = ((float)drm_bpp / 16.0);
+	/* in native_422 or native_420 modes, the bits_per_pixel is double the
+	 * target bpp (the latter is what calc_rc_params expects)
+	 */
+	if (is_navite_422_or_420)
+		bpp /= 2.0;
+
+	rc->rc_quant_incr_limit0 = ((bpc == BPC_8) ? 11 : (bpc == BPC_10 ? 15 : 19)) - ((minor_version == 1 && cm == CM_444) ? 1 : 0);
+	rc->rc_quant_incr_limit1 = ((bpc == BPC_8) ? 11 : (bpc == BPC_10 ? 15 : 19)) - ((minor_version == 1 && cm == CM_444) ? 1 : 0);
+
+	bpp_group = MODE_SELECT(bpp, bpp * 2.0, bpp * 2.0);
+
+	switch (cm) {
+	case CM_420:
+		rc->initial_fullness_offset = (bpp >=  6) ? (2048) : ((bpp <=  4) ? (6144) : ((((bpp >  4) && (bpp <=  5))) ? (6144 - dsc_roundf((bpp - 4) * (512))) : (5632 - dsc_roundf((bpp -  5) * (3584)))));
+		rc->first_line_bpg_offset   = median3(0, (12 + (int) (0.09 *  min(34, slice_height - 8))), (int)((3 * bpc * 3) - (3 * bpp_group)));
+		rc->second_line_bpg_offset  = median3(0, 12, (int)((3 * bpc * 3) - (3 * bpp_group)));
+		break;
+	case CM_422:
+		rc->initial_fullness_offset = (bpp >=  8) ? (2048) : ((bpp <=  7) ? (5632) : (5632 - dsc_roundf((bpp - 7) * (3584))));
+		rc->first_line_bpg_offset   = median3(0, (12 + (int) (0.09 *  min(34, slice_height - 8))), (int)((3 * bpc * 4) - (3 * bpp_group)));
+		rc->second_line_bpg_offset  = 0;
+		break;
+	case CM_444:
+	case CM_RGB:
+		rc->initial_fullness_offset = (bpp >= 12) ? (2048) : ((bpp <=  8) ? (6144) : ((((bpp >  8) && (bpp <= 10))) ? (6144 - dsc_roundf((bpp - 8) * (512 / 2))) : (5632 - dsc_roundf((bpp - 10) * (3584 / 2)))));
+		rc->first_line_bpg_offset   = median3(0, (12 + (int) (0.09 *  min(34, slice_height - 8))), (int)(((3 * bpc + (cm == CM_444 ? 0 : 2)) * 3) - (3 * bpp_group)));
+		rc->second_line_bpg_offset  = 0;
+		break;
+	}
+
+	initial_xmit_delay_factor = (cm == CM_444 || cm == CM_RGB) ? 1.0 : 2.0;
+	rc->initial_xmit_delay = dsc_roundf(8192.0/2.0/bpp/initial_xmit_delay_factor);
+
+	if (cm == CM_422 || cm == CM_420)
+		slice_width /= 2;
+
+	padding_pixels = ((slice_width % 3) != 0) ? (3 - (slice_width % 3)) * (rc->initial_xmit_delay / slice_width) : 0;
+	if (3 * bpp_group >= (((rc->initial_xmit_delay + 2) / 3) * (3 + (cm == CM_422)))) {
+		if ((rc->initial_xmit_delay + padding_pixels) % 3 == 1)
+			rc->initial_xmit_delay++;
+	}
+
+	rc->flatness_min_qp     = ((bpc == BPC_8) ?  (3) : ((bpc == BPC_10) ? (7)  : (11))) - ((minor_version == 1 && cm == CM_444) ? 1 : 0);
+	rc->flatness_max_qp     = ((bpc == BPC_8) ? (12) : ((bpc == BPC_10) ? (16) : (20))) - ((minor_version == 1 && cm == CM_444) ? 1 : 0);
+	rc->flatness_det_thresh = 2 << (bpc - 8);
+
+	get_qp_set(rc->qp_min, cm, bpc, DAL_MM_MIN, bpp);
+	get_qp_set(rc->qp_max, cm, bpc, DAL_MM_MAX, bpp);
+	if (cm == CM_444 && minor_version == 1) {
+		for (i = 0; i < QP_SET_SIZE; ++i) {
+			rc->qp_min[i] = rc->qp_min[i] > 0 ? rc->qp_min[i] - 1 : 0;
+			rc->qp_max[i] = rc->qp_max[i] > 0 ? rc->qp_max[i] - 1 : 0;
+		}
+	}
+	get_ofs_set(rc->ofs, cm, bpp);
+
+	/* fixed parameters */
+	rc->rc_model_size    = 8192;
+	rc->rc_edge_factor   = 6;
+	rc->rc_tgt_offset_hi = 3;
+	rc->rc_tgt_offset_lo = 3;
+
+	rc->rc_buf_thresh[0] = 896;
+	rc->rc_buf_thresh[1] = 1792;
+	rc->rc_buf_thresh[2] = 2688;
+	rc->rc_buf_thresh[3] = 3584;
+	rc->rc_buf_thresh[4] = 4480;
+	rc->rc_buf_thresh[5] = 5376;
+	rc->rc_buf_thresh[6] = 6272;
+	rc->rc_buf_thresh[7] = 6720;
+	rc->rc_buf_thresh[8] = 7168;
+	rc->rc_buf_thresh[9] = 7616;
+	rc->rc_buf_thresh[10] = 7744;
+	rc->rc_buf_thresh[11] = 7872;
+	rc->rc_buf_thresh[12] = 8000;
+	rc->rc_buf_thresh[13] = 8064;
+}
+
+u32 _do_bytes_per_pixel_calc(int slice_width,
+		u16 drm_bpp,
+		bool is_navite_422_or_420)
+{
+	float bpp;
+	u32 bytes_per_pixel;
+	double d_bytes_per_pixel;
+
+	dc_assert_fp_enabled();
+
+	bpp = ((float)drm_bpp / 16.0);
+	d_bytes_per_pixel = dsc_ceil(bpp * slice_width / 8.0) / slice_width;
+	// TODO: Make sure the formula for calculating this is precise (ceiling
+	// vs. floor, and at what point they should be applied)
+	if (is_navite_422_or_420)
+		d_bytes_per_pixel /= 2;
+
+	bytes_per_pixel = (u32)dsc_ceil(d_bytes_per_pixel * 0x10000000);
+
+	return bytes_per_pixel;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.h b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.h
new file mode 100644
index 000000000000..b93b95409fbe
--- /dev/null
+++ b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright 2021 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: AMD
+ *
+ */
+
+#ifndef __RC_CALC_FPU_H__
+#define __RC_CALC_FPU_H__
+
+#include "os_types.h"
+#include <drm/drm_dsc.h>
+
+#define QP_SET_SIZE 15
+
+typedef int qp_set[QP_SET_SIZE];
+
+struct rc_params {
+	int      rc_quant_incr_limit0;
+	int      rc_quant_incr_limit1;
+	int      initial_fullness_offset;
+	int      initial_xmit_delay;
+	int      first_line_bpg_offset;
+	int      second_line_bpg_offset;
+	int      flatness_min_qp;
+	int      flatness_max_qp;
+	int      flatness_det_thresh;
+	qp_set   qp_min;
+	qp_set   qp_max;
+	qp_set   ofs;
+	int      rc_model_size;
+	int      rc_edge_factor;
+	int      rc_tgt_offset_hi;
+	int      rc_tgt_offset_lo;
+	int      rc_buf_thresh[QP_SET_SIZE - 1];
+};
+
+enum colour_mode {
+	CM_RGB,   /* 444 RGB */
+	CM_444,   /* 444 YUV or simple 422 */
+	CM_422,   /* native 422 */
+	CM_420    /* native 420 */
+};
+
+enum bits_per_comp {
+	BPC_8  =  8,
+	BPC_10 = 10,
+	BPC_12 = 12
+};
+
+enum max_min {
+	DAL_MM_MIN = 0,
+	DAL_MM_MAX = 1
+};
+
+struct qp_entry {
+	float         bpp;
+	const qp_set  qps;
+};
+
+typedef struct qp_entry qp_table[];
+
+u32 _do_bytes_per_pixel_calc(int slice_width,
+		u16 drm_bpp,
+		bool is_navite_422_or_420);
+
+void _do_calc_rc_params(struct rc_params *rc,
+		enum colour_mode cm,
+		enum bits_per_comp bpc,
+		u16 drm_bpp,
+		bool is_navite_422_or_420,
+		int slice_width,
+		int slice_height,
+		int minor_version);
+
+#endif
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/Makefile b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
index 8d31eb75c6a6..a2537229ee88 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
@@ -1,35 +1,6 @@
 # SPDX-License-Identifier: MIT
 #
 # Makefile for the 'dsc' sub-component of DAL.
-
-ifdef CONFIG_X86
-dsc_ccflags := -mhard-float -msse
-endif
-
-ifdef CONFIG_PPC64
-dsc_ccflags := -mhard-float -maltivec
-endif
-
-ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
-IS_OLD_GCC = 1
-endif
-endif
-
-ifdef CONFIG_X86
-ifdef IS_OLD_GCC
-# Stack alignment mismatch, proceed with caution.
-# GCC < 7.1 cannot compile code using `double` and -mpreferred-stack-boundary=3
-# (8B stack alignment).
-dsc_ccflags += -mpreferred-stack-boundary=4
-else
-dsc_ccflags += -msse2
-endif
-endif
-
-CFLAGS_$(AMDDALPATH)/dc/dsc/rc_calc.o := $(dsc_ccflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dsc/rc_calc.o := $(dsc_rcflags)
-
 DSC = dc_dsc.o rc_calc.o rc_calc_dpi.o
 
 AMD_DAL_DSC = $(addprefix $(AMDDALPATH)/dc/dsc/,$(DSC))
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/qp_tables.h b/drivers/gpu/drm/amd/display/dc/dsc/qp_tables.h
deleted file mode 100644
index e5fac9f4181d..000000000000
--- a/drivers/gpu/drm/amd/display/dc/dsc/qp_tables.h
+++ /dev/null
@@ -1,704 +0,0 @@
-
-/*
- * Copyright 2017 Advanced Micro Devices, Inc.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- *
- * Authors: AMD
- *
- */
-
-
-const qp_table   qp_table_422_10bpc_min = {
-	{   6, { 0, 4, 5, 6, 6, 6, 6, 7, 7, 8, 9, 9, 9, 12, 16} },
-	{ 6.5, { 0, 4, 5, 6, 6, 6, 6, 7, 7, 8, 9, 9, 9, 12, 16} },
-	{   7, { 0, 4, 5, 6, 6, 6, 6, 7, 7, 7, 9, 9, 9, 11, 15} },
-	{ 7.5, { 0, 2, 4, 6, 6, 6, 6, 7, 7, 7, 8, 9, 9, 11, 15} },
-	{   8, { 0, 2, 3, 5, 5, 6, 6, 7, 7, 7, 8, 8, 9, 11, 14} },
-	{ 8.5, { 0, 2, 3, 4, 5, 5, 5, 6, 6, 7, 8, 8, 9, 11, 14} },
-	{   9, { 0, 2, 3, 4, 5, 5, 5, 6, 6, 7, 8, 8, 9, 11, 13} },
-	{ 9.5, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 7, 8, 8, 9, 11, 13} },
-	{  10, { 0, 2, 2, 3, 4, 5, 5, 6, 6, 7, 8, 8, 9, 11, 12} },
-	{10.5, { 0, 2, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9, 11, 12} },
-	{  11, { 0, 2, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9, 10, 11} },
-	{11.5, { 0, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 8, 8, 10, 11} },
-	{  12, { 0, 2, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10} },
-	{12.5, { 0, 1, 2, 2, 4, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10} },
-	{  13, { 0, 1, 2, 2, 4, 4, 4, 5, 5, 6, 6, 6, 8, 8, 9} },
-	{13.5, { 0, 1, 2, 2, 3, 4, 4, 4, 5, 6, 6, 6, 7, 8, 9} },
-	{  14, { 0, 1, 2, 2, 3, 4, 4, 4, 4, 5, 5, 6, 7, 7, 8} },
-	{14.5, { 0, 1, 1, 2, 3, 3, 4, 4, 4, 5, 5, 6, 6, 7, 8} },
-	{  15, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 6, 6, 6, 8} },
-	{15.5, { 0, 0, 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 5, 6, 7} },
-	{  16, { 0, 0, 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 5, 5, 7} },
-	{16.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6} },
-	{  17, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 6} },
-	{17.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5} },
-	{  18, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 5} },
-	{18.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 5} },
-	{  19, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 4} },
-	{19.5, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 4} },
-	{  20, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 3} }
-};
-
-
-const qp_table   qp_table_444_8bpc_max = {
-	{   6, { 4, 6, 8, 8, 9, 9, 9, 10, 11, 12, 12, 12, 12, 13, 15} },
-	{ 6.5, { 4, 6, 7, 8, 8, 8, 9, 10, 11, 11, 12, 12, 12, 13, 15} },
-	{   7, { 4, 5, 7, 7, 8, 8, 8, 9, 10, 11, 11, 12, 12, 13, 14} },
-	{ 7.5, { 4, 5, 6, 7, 7, 8, 8, 9, 10, 10, 11, 11, 12, 13, 14} },
-	{   8, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
-	{ 8.5, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
-	{   9, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 11, 13} },
-	{ 9.5, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 11, 13} },
-	{  10, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 11, 12} },
-	{10.5, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 10, 11, 12} },
-	{  11, { 2, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 10, 10, 11} },
-	{11.5, { 2, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 9, 10, 11} },
-	{  12, { 2, 3, 4, 5, 6, 6, 7, 8, 8, 9, 9, 9, 9, 10, 11} },
-	{12.5, { 2, 3, 4, 5, 6, 6, 6, 7, 7, 8, 8, 9, 9, 10, 11} },
-	{  13, { 1, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8, 8, 8, 9, 10} },
-	{13.5, { 1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 10} },
-	{  14, { 1, 2, 2, 3, 4, 4, 4, 5, 6, 6, 7, 8, 8, 8, 10} },
-	{14.5, { 0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 9} },
-	{  15, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
-	{15.5, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
-	{  16, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 8} },
-	{16.5, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 8} },
-	{  17, { 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 8} },
-	{17.5, { 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 8} },
-	{  18, { 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 7} },
-	{18.5, { 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 7} },
-	{  19, { 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 6} },
-	{19.5, { 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 6} },
-	{  20, { 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 6} },
-	{20.5, { 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 6} },
-	{  21, { 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5} },
-	{21.5, { 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5} },
-	{  22, { 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 5} },
-	{22.5, { 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 4} },
-	{  23, { 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4} },
-	{23.5, { 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4} },
-	{  24, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 4} }
-};
-
-
-const qp_table   qp_table_420_12bpc_max = {
-	{   4, {11, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 21, 22} },
-	{ 4.5, {10, 11, 12, 13, 14, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
-	{   5, { 9, 11, 12, 13, 14, 15, 15, 16, 17, 17, 18, 18, 19, 20, 21} },
-	{ 5.5, { 8, 10, 11, 12, 13, 14, 15, 16, 16, 17, 17, 18, 18, 19, 20} },
-	{   6, { 6, 9, 11, 12, 13, 14, 15, 16, 16, 17, 17, 17, 17, 18, 19} },
-	{ 6.5, { 6, 8, 10, 11, 11, 13, 14, 15, 15, 16, 16, 17, 17, 18, 19} },
-	{   7, { 5, 7, 9, 10, 10, 12, 13, 14, 14, 15, 16, 16, 17, 17, 18} },
-	{ 7.5, { 5, 7, 8, 9, 9, 11, 12, 13, 14, 14, 15, 15, 16, 16, 17} },
-	{   8, { 4, 6, 7, 8, 8, 10, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
-	{ 8.5, { 3, 6, 6, 7, 7, 10, 11, 12, 13, 13, 14, 14, 15, 15, 16} },
-	{   9, { 3, 5, 6, 7, 7, 10, 11, 12, 12, 13, 13, 14, 14, 14, 15} },
-	{ 9.5, { 2, 5, 6, 6, 7, 9, 10, 11, 12, 12, 13, 13, 13, 14, 15} },
-	{  10, { 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 13, 13, 13, 15} },
-	{10.5, { 2, 3, 5, 5, 6, 7, 8, 9, 11, 11, 12, 12, 12, 12, 14} },
-	{  11, { 1, 3, 4, 5, 6, 6, 7, 9, 10, 11, 11, 11, 12, 12, 13} },
-	{11.5, { 1, 2, 3, 4, 5, 6, 6, 8, 9, 10, 10, 11, 11, 11, 13} },
-	{  12, { 1, 1, 3, 3, 4, 5, 6, 7, 8, 9, 9, 10, 10, 10, 12} },
-	{12.5, { 1, 1, 2, 3, 4, 5, 6, 7, 8, 8, 9, 9, 9, 10, 11} },
-	{  13, { 1, 1, 1, 2, 4, 4, 6, 6, 7, 8, 8, 9, 9, 9, 11} },
-	{13.5, { 1, 1, 1, 2, 3, 4, 5, 5, 6, 7, 8, 8, 8, 9, 11} },
-	{  14, { 1, 1, 1, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 8, 10} },
-	{14.5, { 0, 1, 1, 1, 2, 3, 4, 4, 5, 5, 6, 7, 7, 7, 9} },
-	{  15, { 0, 1, 1, 1, 1, 2, 3, 3, 5, 5, 5, 6, 6, 7, 9} },
-	{15.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 8} },
-	{  16, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 7} },
-	{16.5, { 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 4, 4, 5, 7} },
-	{  17, { 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 6} },
-	{17.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 6} },
-	{  18, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 5} }
-};
-
-
-const qp_table   qp_table_444_10bpc_min = {
-	{   6, { 0, 4, 7, 7, 9, 9, 9, 9, 9, 10, 10, 10, 10, 12, 18} },
-	{ 6.5, { 0, 4, 6, 7, 8, 8, 9, 9, 9, 9, 10, 10, 10, 12, 18} },
-	{   7, { 0, 4, 6, 6, 8, 8, 8, 8, 8, 9, 9, 10, 10, 12, 17} },
-	{ 7.5, { 0, 4, 6, 6, 7, 8, 8, 8, 8, 8, 9, 9, 10, 12, 17} },
-	{   8, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 8, 9, 9, 9, 12, 16} },
-	{ 8.5, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 8, 9, 9, 9, 12, 16} },
-	{   9, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 16} },
-	{ 9.5, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 16} },
-	{  10, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 15} },
-	{10.5, { 0, 4, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 15} },
-	{  11, { 0, 3, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 11, 14} },
-	{11.5, { 0, 3, 5, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 11, 14} },
-	{  12, { 0, 2, 4, 4, 6, 6, 7, 7, 7, 7, 9, 9, 9, 11, 14} },
-	{12.5, { 0, 2, 4, 4, 6, 6, 7, 7, 7, 7, 8, 9, 9, 11, 14} },
-	{  13, { 0, 2, 4, 4, 5, 6, 7, 7, 7, 7, 8, 9, 9, 11, 13} },
-	{13.5, { 0, 2, 3, 4, 5, 6, 6, 7, 7, 7, 8, 9, 9, 11, 13} },
-	{  14, { 0, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 9, 9, 11, 13} },
-	{14.5, { 0, 2, 3, 4, 5, 5, 6, 6, 6, 7, 7, 8, 9, 11, 12} },
-	{  15, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 8, 9, 11, 12} },
-	{15.5, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 8, 9, 11, 12} },
-	{  16, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 8, 8, 10, 11} },
-	{16.5, { 0, 1, 2, 3, 4, 5, 5, 6, 6, 6, 7, 8, 8, 10, 11} },
-	{  17, { 0, 1, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 8, 9, 11} },
-	{17.5, { 0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9, 11} },
-	{  18, { 0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10} },
-	{18.5, { 0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10} },
-	{  19, { 0, 1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 7, 7, 8, 9} },
-	{19.5, { 0, 1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 7, 7, 8, 9} },
-	{  20, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 9} },
-	{20.5, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 9} },
-	{  21, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 6, 6, 7, 9} },
-	{21.5, { 0, 1, 1, 2, 2, 2, 3, 4, 4, 4, 5, 6, 6, 7, 8} },
-	{  22, { 0, 0, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 8} },
-	{22.5, { 0, 0, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 7} },
-	{  23, { 0, 0, 1, 2, 2, 2, 3, 3, 3, 3, 5, 5, 5, 5, 7} },
-	{23.5, { 0, 0, 0, 2, 2, 2, 3, 3, 3, 3, 5, 5, 5, 5, 7} },
-	{  24, { 0, 0, 0, 1, 1, 2, 3, 3, 3, 3, 4, 4, 4, 5, 7} },
-	{24.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 7} },
-	{  25, { 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 6} },
-	{25.5, { 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 6} },
-	{  26, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 5} },
-	{26.5, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 5} },
-	{  27, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 5} },
-	{27.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 5} },
-	{  28, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 4} },
-	{28.5, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 4} },
-	{  29, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3} },
-	{29.5, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3} },
-	{  30, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3} }
-};
-
-
-const qp_table   qp_table_420_8bpc_max = {
-	{   4, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 13, 14} },
-	{ 4.5, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
-	{   5, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 12, 13} },
-	{ 5.5, { 3, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 10, 10, 11, 12} },
-	{   6, { 2, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 9, 10, 11} },
-	{ 6.5, { 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 11} },
-	{   7, { 1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 8, 8, 9, 9, 10} },
-	{ 7.5, { 1, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7, 7, 8, 8, 9} },
-	{   8, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
-	{ 8.5, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 7, 8} },
-	{   9, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7} },
-	{ 9.5, { 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 7} },
-	{  10, { 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6} },
-	{10.5, { 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 6} },
-	{  11, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5} },
-	{11.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5} },
-	{  12, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 4} }
-};
-
-
-const qp_table   qp_table_444_8bpc_min = {
-	{   6, { 0, 1, 3, 3, 5, 5, 5, 5, 5, 6, 6, 6, 6, 9, 14} },
-	{ 6.5, { 0, 1, 2, 3, 4, 4, 5, 5, 5, 5, 6, 6, 6, 9, 14} },
-	{   7, { 0, 0, 2, 2, 4, 4, 4, 4, 4, 5, 5, 6, 6, 9, 13} },
-	{ 7.5, { 0, 0, 2, 2, 3, 4, 4, 4, 4, 4, 5, 5, 6, 9, 13} },
-	{   8, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 4, 5, 5, 5, 8, 12} },
-	{ 8.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 4, 5, 5, 5, 8, 12} },
-	{   9, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 12} },
-	{ 9.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 12} },
-	{  10, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
-	{10.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
-	{  11, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
-	{11.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
-	{  12, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
-	{12.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 4, 5, 5, 7, 10} },
-	{  13, { 0, 0, 1, 1, 2, 3, 3, 3, 3, 3, 4, 5, 5, 7, 9} },
-	{13.5, { 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 4, 5, 5, 7, 9} },
-	{  14, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 4, 5, 5, 7, 9} },
-	{14.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 4, 4, 5, 7, 8} },
-	{  15, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
-	{15.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
-	{  16, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
-	{16.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
-	{  17, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 7} },
-	{17.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 7} },
-	{  18, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 6} },
-	{18.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 6} },
-	{  19, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 5} },
-	{19.5, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 5} },
-	{  20, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 3, 5} },
-	{20.5, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 3, 5} },
-	{  21, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 4} },
-	{21.5, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 4} },
-	{  22, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 4} },
-	{22.5, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3} },
-	{  23, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3} },
-	{23.5, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3} },
-	{  24, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3} }
-};
-
-
-const qp_table   qp_table_444_12bpc_min = {
-	{   6, { 0, 5, 11, 11, 13, 13, 13, 13, 13, 14, 14, 14, 14, 17, 22} },
-	{ 6.5, { 0, 5, 10, 11, 12, 12, 13, 13, 13, 13, 14, 14, 14, 17, 22} },
-	{   7, { 0, 5, 10, 10, 12, 12, 12, 12, 12, 13, 13, 14, 14, 17, 21} },
-	{ 7.5, { 0, 5, 9, 10, 11, 12, 12, 12, 12, 12, 13, 13, 14, 17, 21} },
-	{   8, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 12, 13, 13, 13, 16, 20} },
-	{ 8.5, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 12, 13, 13, 13, 16, 20} },
-	{   9, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 20} },
-	{ 9.5, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 20} },
-	{  10, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
-	{10.5, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
-	{  11, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
-	{11.5, { 0, 4, 8, 9, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
-	{  12, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
-	{12.5, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
-	{  13, { 0, 4, 7, 8, 9, 11, 11, 11, 11, 11, 13, 13, 13, 15, 17} },
-	{13.5, { 0, 3, 6, 7, 9, 10, 10, 11, 11, 11, 12, 13, 13, 15, 17} },
-	{  14, { 0, 3, 5, 6, 9, 9, 9, 10, 11, 11, 12, 13, 13, 15, 17} },
-	{14.5, { 0, 2, 5, 6, 8, 9, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
-	{  15, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
-	{15.5, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
-	{  16, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 11, 12, 12, 14, 15} },
-	{16.5, { 0, 2, 3, 5, 7, 8, 9, 10, 11, 11, 11, 12, 12, 14, 15} },
-	{  17, { 0, 2, 3, 5, 5, 6, 9, 9, 10, 10, 11, 11, 12, 13, 15} },
-	{17.5, { 0, 2, 3, 5, 5, 6, 8, 9, 10, 10, 11, 11, 12, 13, 15} },
-	{  18, { 0, 2, 3, 5, 5, 6, 8, 9, 10, 10, 11, 11, 12, 13, 14} },
-	{18.5, { 0, 2, 3, 5, 5, 6, 8, 9, 10, 10, 11, 11, 12, 13, 14} },
-	{  19, { 0, 1, 2, 4, 5, 5, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
-	{19.5, { 0, 1, 2, 4, 5, 5, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
-	{  20, { 0, 1, 2, 3, 4, 5, 7, 8, 8, 8, 9, 10, 10, 11, 13} },
-	{20.5, { 0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 10, 10, 11, 13} },
-	{  21, { 0, 1, 2, 3, 4, 5, 5, 7, 7, 8, 9, 10, 10, 11, 13} },
-	{21.5, { 0, 1, 2, 3, 3, 4, 5, 7, 7, 8, 9, 10, 10, 11, 12} },
-	{  22, { 0, 0, 1, 3, 3, 4, 5, 6, 7, 8, 9, 9, 9, 10, 12} },
-	{22.5, { 0, 0, 1, 3, 3, 4, 5, 6, 7, 8, 9, 9, 9, 10, 11} },
-	{  23, { 0, 0, 1, 3, 3, 4, 5, 6, 6, 7, 9, 9, 9, 9, 11} },
-	{23.5, { 0, 0, 1, 3, 3, 4, 5, 6, 6, 7, 9, 9, 9, 9, 11} },
-	{  24, { 0, 0, 1, 2, 3, 4, 5, 6, 6, 7, 8, 8, 8, 9, 11} },
-	{24.5, { 0, 0, 1, 2, 3, 4, 4, 6, 6, 7, 8, 8, 8, 9, 11} },
-	{  25, { 0, 0, 1, 2, 3, 4, 4, 5, 6, 7, 8, 8, 8, 8, 10} },
-	{25.5, { 0, 0, 1, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 8, 10} },
-	{  26, { 0, 0, 1, 2, 2, 3, 4, 5, 5, 6, 7, 7, 7, 7, 9} },
-	{26.5, { 0, 0, 1, 2, 2, 3, 4, 5, 5, 5, 7, 7, 7, 7, 9} },
-	{  27, { 0, 0, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 7, 9} },
-	{27.5, { 0, 0, 1, 1, 2, 2, 4, 4, 4, 5, 6, 7, 7, 7, 9} },
-	{  28, { 0, 0, 0, 1, 1, 2, 3, 4, 4, 4, 6, 6, 6, 7, 9} },
-	{28.5, { 0, 0, 0, 1, 1, 2, 3, 3, 4, 4, 5, 6, 6, 6, 8} },
-	{  29, { 0, 0, 0, 1, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 8} },
-	{29.5, { 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 5, 5, 6, 6, 7} },
-	{  30, { 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 5, 5, 5, 5, 7} },
-	{30.5, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 4, 4, 5, 7} },
-	{  31, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 4, 4, 5, 7} },
-	{31.5, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 7} },
-	{  32, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 4, 6} },
-	{32.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 3, 3, 3, 4, 6} },
-	{  33, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 5} },
-	{33.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 5} },
-	{  34, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 5} },
-	{34.5, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 3, 5} },
-	{  35, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 4} },
-	{35.5, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 4} },
-	{  36, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3} }
-};
-
-
-const qp_table   qp_table_420_12bpc_min = {
-	{   4, { 0, 4, 9, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 21} },
-	{ 4.5, { 0, 4, 8, 9, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 20} },
-	{   5, { 0, 4, 8, 9, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 20} },
-	{ 5.5, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
-	{   6, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
-	{ 6.5, { 0, 4, 6, 8, 9, 10, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
-	{   7, { 0, 3, 5, 7, 9, 10, 10, 11, 11, 11, 13, 13, 13, 15, 17} },
-	{ 7.5, { 0, 3, 5, 7, 8, 9, 10, 10, 11, 11, 12, 13, 13, 15, 16} },
-	{   8, { 0, 2, 4, 6, 7, 9, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
-	{ 8.5, { 0, 2, 4, 6, 6, 9, 9, 10, 11, 11, 12, 12, 13, 14, 15} },
-	{   9, { 0, 2, 4, 6, 6, 9, 9, 10, 10, 11, 11, 12, 13, 13, 14} },
-	{ 9.5, { 0, 2, 4, 5, 6, 8, 8, 9, 10, 10, 11, 12, 12, 13, 14} },
-	{  10, { 0, 2, 3, 5, 6, 7, 8, 8, 9, 10, 10, 12, 12, 12, 14} },
-	{10.5, { 0, 2, 3, 4, 5, 6, 7, 8, 9, 9, 10, 11, 11, 11, 13} },
-	{  11, { 0, 2, 3, 4, 5, 5, 6, 8, 8, 9, 9, 10, 11, 11, 12} },
-	{11.5, { 0, 1, 2, 3, 4, 5, 5, 7, 8, 8, 9, 10, 10, 10, 12} },
-	{  12, { 0, 0, 2, 2, 3, 4, 5, 6, 7, 8, 8, 9, 9, 9, 11} },
-	{12.5, { 0, 0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 8, 8, 9, 10} },
-	{  13, { 0, 0, 0, 1, 3, 3, 5, 5, 6, 7, 7, 8, 8, 8, 10} },
-	{13.5, { 0, 0, 0, 1, 2, 3, 4, 4, 5, 6, 7, 7, 7, 8, 10} },
-	{  14, { 0, 0, 0, 1, 2, 3, 3, 4, 5, 5, 6, 7, 7, 7, 9} },
-	{14.5, { 0, 0, 0, 0, 1, 2, 3, 3, 4, 4, 5, 6, 6, 6, 8} },
-	{  15, { 0, 0, 0, 0, 0, 1, 2, 2, 4, 4, 4, 5, 5, 6, 8} },
-	{15.5, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 7} },
-	{  16, { 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 6} },
-	{16.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 6} },
-	{  17, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 5} },
-	{17.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 3, 5} },
-	{  18, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 4} }
-};
-
-
-const qp_table   qp_table_422_12bpc_min = {
-	{   6, { 0, 4, 9, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 16, 20} },
-	{ 6.5, { 0, 4, 9, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 16, 20} },
-	{   7, { 0, 4, 9, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
-	{ 7.5, { 0, 4, 8, 10, 11, 11, 11, 11, 11, 11, 13, 13, 13, 15, 19} },
-	{   8, { 0, 4, 7, 8, 10, 11, 11, 11, 11, 11, 13, 13, 13, 15, 18} },
-	{ 8.5, { 0, 3, 6, 8, 9, 10, 10, 11, 11, 11, 12, 13, 13, 15, 18} },
-	{   9, { 0, 3, 5, 8, 9, 10, 10, 10, 11, 11, 12, 13, 13, 15, 17} },
-	{ 9.5, { 0, 3, 5, 7, 8, 9, 10, 10, 11, 11, 12, 13, 13, 15, 17} },
-	{  10, { 0, 2, 4, 6, 7, 9, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
-	{10.5, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 12, 13, 13, 15, 16} },
-	{  11, { 0, 2, 4, 6, 7, 8, 9, 10, 11, 11, 12, 12, 13, 14, 15} },
-	{11.5, { 0, 2, 4, 6, 7, 7, 9, 9, 10, 11, 11, 12, 12, 14, 15} },
-	{  12, { 0, 2, 4, 6, 6, 6, 8, 8, 9, 9, 11, 11, 12, 13, 14} },
-	{12.5, { 0, 1, 4, 5, 6, 6, 7, 8, 8, 9, 10, 11, 11, 13, 14} },
-	{  13, { 0, 1, 3, 4, 5, 5, 7, 8, 8, 9, 10, 10, 11, 12, 13} },
-	{13.5, { 0, 1, 3, 3, 4, 5, 7, 7, 8, 8, 10, 10, 10, 12, 13} },
-	{  14, { 0, 0, 2, 3, 4, 5, 6, 6, 7, 7, 9, 10, 10, 11, 12} },
-	{14.5, { 0, 0, 1, 3, 4, 4, 6, 6, 6, 7, 9, 9, 9, 11, 12} },
-	{  15, { 0, 0, 1, 3, 3, 4, 5, 6, 6, 6, 8, 9, 9, 10, 12} },
-	{15.5, { 0, 0, 1, 2, 3, 4, 5, 5, 6, 6, 8, 8, 8, 10, 11} },
-	{  16, { 0, 0, 1, 2, 3, 4, 5, 5, 6, 6, 8, 8, 8, 9, 11} },
-	{16.5, { 0, 0, 0, 2, 2, 3, 4, 5, 5, 5, 6, 7, 7, 9, 10} },
-	{  17, { 0, 0, 0, 1, 2, 2, 4, 4, 4, 5, 6, 6, 6, 8, 10} },
-	{17.5, { 0, 0, 0, 1, 2, 2, 3, 4, 4, 4, 5, 6, 6, 8, 9} },
-	{  18, { 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 5, 5, 6, 7, 9} },
-	{18.5, { 0, 0, 0, 1, 2, 2, 3, 3, 3, 3, 5, 5, 5, 7, 9} },
-	{  19, { 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 6, 8} },
-	{19.5, { 0, 0, 0, 1, 1, 1, 2, 3, 3, 3, 4, 4, 4, 6, 8} },
-	{  20, { 0, 0, 0, 1, 1, 1, 2, 3, 3, 3, 4, 4, 4, 5, 7} },
-	{20.5, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 7} },
-	{  21, { 0, 0, 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 6} },
-	{21.5, { 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 6} },
-	{  22, { 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 6} },
-	{22.5, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 5} },
-	{  23, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 5} },
-	{23.5, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 4} },
-	{  24, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 4} }
-};
-
-
-const qp_table   qp_table_422_12bpc_max = {
-	{   6, {12, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
-	{ 6.5, {12, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
-	{   7, {11, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20} },
-	{ 7.5, { 9, 10, 12, 14, 15, 15, 15, 16, 16, 17, 17, 18, 18, 19, 20} },
-	{   8, { 6, 9, 10, 12, 14, 15, 15, 16, 16, 17, 17, 17, 17, 18, 19} },
-	{ 8.5, { 6, 8, 9, 11, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 19} },
-	{   9, { 5, 7, 8, 10, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 18} },
-	{ 9.5, { 5, 7, 7, 9, 10, 12, 12, 13, 14, 14, 15, 15, 16, 17, 18} },
-	{  10, { 4, 6, 6, 8, 9, 11, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
-	{10.5, { 4, 6, 6, 8, 9, 10, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
-	{  11, { 4, 5, 6, 8, 9, 10, 11, 12, 13, 13, 14, 14, 15, 15, 16} },
-	{11.5, { 3, 5, 6, 8, 9, 9, 11, 11, 12, 13, 13, 14, 14, 15, 16} },
-	{  12, { 3, 5, 6, 8, 8, 8, 10, 10, 11, 11, 13, 13, 14, 14, 15} },
-	{12.5, { 3, 4, 6, 7, 8, 8, 9, 10, 10, 11, 12, 13, 13, 14, 15} },
-	{  13, { 2, 4, 5, 6, 7, 7, 9, 10, 10, 11, 12, 12, 13, 13, 14} },
-	{13.5, { 2, 4, 5, 5, 6, 7, 9, 9, 10, 10, 12, 12, 12, 13, 14} },
-	{  14, { 2, 3, 4, 5, 6, 7, 8, 8, 9, 9, 11, 12, 12, 12, 13} },
-	{14.5, { 2, 3, 3, 5, 6, 6, 8, 8, 8, 9, 11, 11, 11, 12, 13} },
-	{  15, { 2, 3, 3, 5, 5, 6, 7, 8, 8, 8, 10, 11, 11, 11, 13} },
-	{15.5, { 2, 2, 3, 4, 5, 6, 7, 7, 8, 8, 10, 10, 10, 11, 12} },
-	{  16, { 2, 2, 3, 4, 5, 6, 7, 7, 8, 8, 10, 10, 10, 10, 12} },
-	{16.5, { 1, 2, 2, 4, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 11} },
-	{  17, { 1, 1, 2, 3, 4, 4, 6, 6, 6, 7, 8, 8, 8, 9, 11} },
-	{17.5, { 1, 1, 2, 3, 4, 4, 5, 6, 6, 6, 7, 8, 8, 9, 10} },
-	{  18, { 1, 1, 1, 2, 3, 3, 5, 5, 5, 6, 7, 7, 8, 8, 10} },
-	{18.5, { 1, 1, 1, 2, 3, 3, 5, 5, 5, 5, 7, 7, 7, 8, 10} },
-	{  19, { 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 7, 9} },
-	{19.5, { 1, 1, 1, 2, 2, 2, 4, 5, 5, 5, 6, 6, 6, 7, 9} },
-	{  20, { 1, 1, 1, 2, 2, 2, 4, 5, 5, 5, 6, 6, 6, 6, 8} },
-	{20.5, { 0, 0, 0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 8} },
-	{  21, { 0, 0, 0, 1, 1, 2, 3, 3, 4, 4, 4, 5, 5, 5, 7} },
-	{21.5, { 0, 0, 0, 0, 1, 1, 2, 3, 3, 3, 4, 4, 4, 5, 7} },
-	{  22, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 5, 7} },
-	{22.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 6} },
-	{  23, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 3, 4, 6} },
-	{23.5, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 5} },
-	{  24, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 5} }
-};
-
-
-const qp_table   qp_table_444_12bpc_max = {
-	{   6, {12, 14, 16, 16, 17, 17, 17, 18, 19, 20, 20, 20, 20, 21, 23} },
-	{ 6.5, {12, 14, 15, 16, 16, 16, 17, 18, 19, 19, 20, 20, 20, 21, 23} },
-	{   7, {12, 13, 15, 15, 16, 16, 16, 17, 18, 19, 19, 20, 20, 21, 22} },
-	{ 7.5, {12, 13, 14, 15, 15, 16, 16, 17, 18, 18, 19, 19, 20, 21, 22} },
-	{   8, {12, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
-	{ 8.5, {12, 12, 13, 14, 15, 15, 15, 16, 17, 18, 18, 19, 19, 20, 21} },
-	{   9, {11, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 21} },
-	{ 9.5, {11, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 21} },
-	{  10, {11, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20} },
-	{10.5, {10, 12, 13, 14, 15, 15, 15, 16, 17, 17, 18, 18, 18, 19, 20} },
-	{  11, { 9, 11, 13, 14, 15, 15, 15, 16, 16, 17, 17, 17, 18, 18, 19} },
-	{11.5, { 9, 11, 13, 14, 15, 15, 15, 16, 16, 17, 17, 17, 17, 18, 19} },
-	{  12, { 6, 9, 12, 13, 14, 14, 15, 16, 16, 17, 17, 17, 17, 18, 19} },
-	{12.5, { 6, 9, 12, 13, 14, 14, 14, 15, 15, 16, 16, 17, 17, 18, 19} },
-	{  13, { 5, 9, 12, 13, 13, 14, 14, 15, 15, 16, 16, 16, 16, 17, 18} },
-	{13.5, { 5, 8, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 18} },
-	{  14, { 5, 8, 10, 11, 12, 12, 12, 13, 14, 14, 15, 16, 16, 16, 18} },
-	{14.5, { 4, 7, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 17} },
-	{  15, { 4, 7, 9, 10, 10, 11, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
-	{15.5, { 4, 7, 9, 10, 10, 11, 11, 12, 13, 13, 14, 15, 15, 16, 17} },
-	{  16, { 4, 7, 9, 10, 10, 11, 11, 12, 13, 13, 13, 14, 14, 15, 16} },
-	{16.5, { 4, 5, 7, 8, 10, 11, 11, 12, 13, 13, 13, 14, 14, 15, 16} },
-	{  17, { 4, 5, 7, 8, 8, 9, 11, 11, 12, 12, 12, 13, 13, 14, 16} },
-	{17.5, { 3, 5, 7, 8, 8, 9, 10, 11, 12, 12, 12, 13, 13, 14, 16} },
-	{  18, { 3, 5, 7, 8, 8, 9, 10, 11, 12, 12, 12, 13, 13, 14, 15} },
-	{18.5, { 3, 5, 7, 8, 8, 9, 10, 11, 12, 12, 12, 13, 13, 14, 15} },
-	{  19, { 3, 4, 6, 7, 8, 8, 9, 10, 11, 11, 11, 12, 12, 13, 14} },
-	{19.5, { 3, 4, 6, 7, 8, 8, 9, 10, 11, 11, 11, 12, 12, 13, 14} },
-	{  20, { 2, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11, 11, 12, 14} },
-	{20.5, { 2, 3, 5, 5, 7, 8, 8, 8, 9, 10, 10, 11, 11, 12, 14} },
-	{  21, { 2, 3, 5, 5, 7, 7, 7, 8, 8, 9, 10, 11, 11, 12, 14} },
-	{21.5, { 2, 3, 5, 5, 6, 6, 7, 8, 8, 9, 10, 11, 11, 12, 13} },
-	{  22, { 2, 2, 4, 5, 6, 6, 7, 7, 8, 9, 10, 10, 10, 11, 13} },
-	{22.5, { 2, 2, 4, 5, 5, 6, 7, 7, 8, 9, 10, 10, 10, 11, 12} },
-	{  23, { 2, 2, 4, 5, 5, 6, 7, 7, 7, 8, 10, 10, 10, 10, 12} },
-	{23.5, { 2, 2, 3, 5, 5, 6, 7, 7, 7, 8, 10, 10, 10, 10, 12} },
-	{  24, { 2, 2, 3, 4, 4, 5, 7, 7, 7, 8, 9, 9, 9, 10, 12} },
-	{24.5, { 1, 2, 3, 4, 4, 5, 6, 7, 7, 8, 9, 9, 9, 10, 12} },
-	{  25, { 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 9, 9, 11} },
-	{25.5, { 1, 1, 3, 3, 4, 5, 6, 6, 7, 7, 8, 9, 9, 9, 11} },
-	{  26, { 1, 1, 3, 3, 3, 4, 5, 6, 6, 7, 8, 8, 8, 8, 10} },
-	{26.5, { 1, 1, 2, 3, 3, 4, 5, 6, 6, 6, 8, 8, 8, 8, 10} },
-	{  27, { 1, 1, 2, 3, 3, 4, 5, 5, 6, 6, 7, 8, 8, 8, 10} },
-	{27.5, { 1, 1, 2, 2, 3, 3, 5, 5, 5, 6, 7, 8, 8, 8, 10} },
-	{  28, { 0, 1, 1, 2, 2, 3, 4, 5, 5, 5, 7, 7, 7, 8, 10} },
-	{28.5, { 0, 1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 7, 9} },
-	{  29, { 0, 1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 9} },
-	{29.5, { 0, 1, 1, 2, 2, 2, 3, 3, 4, 5, 6, 6, 7, 7, 8} },
-	{  30, { 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 6, 6, 6, 6, 8} },
-	{30.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 8} },
-	{  31, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 6, 8} },
-	{31.5, { 0, 0, 0, 0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 8} },
-	{  32, { 0, 0, 0, 0, 1, 2, 2, 3, 3, 4, 4, 4, 4, 5, 7} },
-	{32.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 4, 4, 4, 5, 7} },
-	{  33, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 6} },
-	{33.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 6} },
-	{  34, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 3, 4, 6} },
-	{34.5, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 3, 3, 3, 3, 4, 6} },
-	{  35, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 5} },
-	{35.5, { 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 5} },
-	{  36, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 4} }
-};
-
-
-const qp_table   qp_table_420_8bpc_min = {
-	{   4, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 9, 13} },
-	{ 4.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 8, 12} },
-	{   5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 8, 12} },
-	{ 5.5, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
-	{   6, { 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
-	{ 6.5, { 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 4, 5, 5, 7, 10} },
-	{   7, { 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 4, 5, 5, 7, 9} },
-	{ 7.5, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 4, 4, 5, 7, 8} },
-	{   8, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
-	{ 8.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
-	{   9, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6} },
-	{ 9.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 6} },
-	{  10, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5} },
-	{10.5, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 3, 5} },
-	{  11, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4} },
-	{11.5, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 4} },
-	{  12, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 3} }
-};
-
-
-const qp_table   qp_table_422_8bpc_min = {
-	{   6, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 8, 12} },
-	{ 6.5, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 8, 12} },
-	{   7, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
-	{ 7.5, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 11} },
-	{   8, { 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 7, 10} },
-	{ 8.5, { 0, 0, 1, 2, 2, 2, 2, 3, 3, 3, 4, 5, 5, 7, 10} },
-	{   9, { 0, 0, 0, 1, 2, 2, 2, 2, 2, 3, 4, 5, 5, 7, 9} },
-	{ 9.5, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 9} },
-	{  10, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
-	{10.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 7, 8} },
-	{  11, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
-	{11.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7} },
-	{  12, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 5, 6} },
-	{12.5, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 6} },
-	{  13, { 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 4, 4, 5} },
-	{13.5, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 4, 5} },
-	{  14, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4} },
-	{14.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 4} },
-	{  15, { 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 4} },
-	{15.5, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3} },
-	{  16, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3} }
-};
-
-
-const qp_table   qp_table_422_10bpc_max = {
-	{   6, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
-	{ 6.5, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
-	{   7, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 15, 16} },
-	{ 7.5, { 5, 6, 8, 10, 11, 11, 11, 12, 12, 13, 13, 14, 14, 15, 16} },
-	{   8, { 4, 6, 7, 9, 10, 11, 11, 12, 12, 13, 13, 13, 13, 14, 15} },
-	{ 8.5, { 4, 5, 6, 8, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 15} },
-	{   9, { 3, 4, 5, 7, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14} },
-	{ 9.5, { 3, 4, 4, 6, 6, 8, 8, 9, 10, 10, 11, 11, 12, 13, 14} },
-	{  10, { 2, 3, 3, 5, 5, 7, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
-	{10.5, { 2, 3, 3, 5, 5, 6, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
-	{  11, { 2, 3, 3, 5, 5, 6, 7, 8, 9, 9, 10, 10, 11, 11, 12} },
-	{11.5, { 2, 3, 3, 5, 5, 5, 7, 7, 8, 9, 9, 10, 10, 11, 12} },
-	{  12, { 2, 3, 3, 5, 5, 5, 7, 7, 8, 8, 9, 9, 10, 10, 11} },
-	{12.5, { 2, 2, 3, 4, 5, 5, 6, 7, 7, 8, 8, 9, 9, 10, 11} },
-	{  13, { 1, 2, 3, 4, 5, 5, 6, 7, 7, 8, 8, 8, 9, 9, 10} },
-	{13.5, { 1, 2, 3, 3, 4, 5, 6, 6, 7, 7, 8, 8, 8, 9, 10} },
-	{  14, { 1, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7, 8, 8, 8, 9} },
-	{14.5, { 1, 2, 2, 3, 4, 4, 5, 5, 5, 6, 7, 7, 7, 8, 9} },
-	{  15, { 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 7, 7, 7, 9} },
-	{15.5, { 1, 1, 2, 2, 3, 4, 4, 4, 5, 5, 6, 6, 6, 7, 8} },
-	{  16, { 1, 1, 2, 2, 3, 4, 4, 4, 5, 5, 6, 6, 6, 6, 8} },
-	{16.5, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 6, 7} },
-	{  17, { 0, 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 7} },
-	{17.5, { 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6} },
-	{  18, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 6} },
-	{18.5, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 6} },
-	{  19, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 5} },
-	{19.5, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 5} },
-	{  20, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 4} }
-};
-
-
-const qp_table qp_table_420_10bpc_max = {
-	{   4, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 17, 18} },
-	{ 4.5, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
-	{   5, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 16, 17} },
-	{ 5.5, { 6, 7, 8, 9, 10, 10, 11, 12, 12, 13, 13, 14, 14, 15, 16} },
-	{   6, { 4, 6, 8, 9, 10, 10, 11, 12, 12, 13, 13, 13, 13, 14, 15} },
-	{ 6.5, { 4, 5, 7, 8, 8, 9, 10, 11, 11, 12, 12, 13, 13, 14, 15} },
-	{   7, { 3, 4, 6, 7, 7, 8, 9, 10, 10, 11, 12, 12, 13, 13, 14} },
-	{ 7.5, { 3, 4, 5, 6, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12, 13} },
-	{   8, { 2, 3, 4, 5, 5, 6, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
-	{ 8.5, { 1, 3, 3, 4, 4, 6, 7, 8, 9, 9, 10, 10, 11, 11, 12} },
-	{   9, { 1, 3, 3, 4, 4, 6, 7, 8, 8, 9, 9, 10, 10, 10, 11} },
-	{ 9.5, { 1, 3, 3, 3, 4, 5, 6, 7, 8, 8, 9, 9, 9, 10, 11} },
-	{  10, { 1, 2, 3, 3, 4, 4, 5, 6, 7, 8, 8, 9, 9, 9, 11} },
-	{10.5, { 1, 1, 3, 3, 3, 4, 5, 5, 7, 7, 8, 8, 8, 8, 10} },
-	{  11, { 0, 1, 2, 3, 3, 3, 4, 5, 6, 7, 7, 7, 8, 8, 9} },
-	{11.5, { 0, 1, 1, 2, 3, 3, 3, 4, 5, 6, 6, 7, 7, 7, 9} },
-	{  12, { 0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 6, 8} },
-	{12.5, { 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 7} },
-	{  13, { 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 4, 5, 5, 5, 7} },
-	{13.5, { 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 6} },
-	{  14, { 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 6} },
-	{14.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 5} },
-	{  15, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 5} }
-};
-
-
-const qp_table   qp_table_420_10bpc_min = {
-	{   4, { 0, 4, 4, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 13, 17} },
-	{ 4.5, { 0, 4, 4, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 16} },
-	{   5, { 0, 4, 4, 5, 7, 7, 7, 7, 7, 7, 9, 9, 9, 12, 16} },
-	{ 5.5, { 0, 3, 3, 4, 6, 7, 7, 7, 7, 7, 9, 9, 9, 11, 15} },
-	{   6, { 0, 2, 3, 4, 6, 7, 7, 7, 7, 7, 9, 9, 9, 11, 14} },
-	{ 6.5, { 0, 2, 3, 4, 5, 6, 6, 7, 7, 7, 8, 9, 9, 11, 14} },
-	{   7, { 0, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 11, 13} },
-	{ 7.5, { 0, 2, 3, 4, 4, 5, 5, 6, 7, 7, 8, 8, 9, 11, 12} },
-	{   8, { 0, 2, 3, 4, 4, 5, 5, 6, 6, 7, 8, 8, 9, 11, 12} },
-	{ 8.5, { 0, 2, 2, 3, 3, 5, 5, 6, 6, 7, 8, 8, 9, 10, 11} },
-	{   9, { 0, 2, 2, 3, 3, 5, 5, 6, 6, 7, 7, 8, 9, 9, 10} },
-	{ 9.5, { 0, 2, 2, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9, 10} },
-	{  10, { 0, 1, 2, 2, 3, 3, 4, 4, 5, 6, 6, 8, 8, 8, 10} },
-	{10.5, { 0, 0, 2, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 7, 9} },
-	{  11, { 0, 0, 1, 2, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 8} },
-	{11.5, { 0, 0, 0, 1, 2, 2, 2, 3, 4, 4, 5, 6, 6, 6, 8} },
-	{  12, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 4, 5, 5, 5, 7} },
-	{12.5, { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 6} },
-	{  13, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 6} },
-	{13.5, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 3, 5} },
-	{  14, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 5} },
-	{14.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 4} },
-	{  15, { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 4} }
-};
-
-
-const qp_table   qp_table_444_10bpc_max = {
-	{   6, { 8, 10, 12, 12, 13, 13, 13, 14, 15, 16, 16, 16, 16, 17, 19} },
-	{ 6.5, { 8, 10, 11, 12, 12, 12, 13, 14, 15, 15, 16, 16, 16, 17, 19} },
-	{   7, { 8, 9, 11, 11, 12, 12, 12, 13, 14, 15, 15, 16, 16, 17, 18} },
-	{ 7.5, { 8, 9, 10, 11, 11, 12, 12, 13, 14, 14, 15, 15, 16, 17, 18} },
-	{   8, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
-	{ 8.5, { 8, 8, 9, 10, 11, 11, 11, 12, 13, 14, 14, 15, 15, 16, 17} },
-	{   9, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 15, 17} },
-	{ 9.5, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 15, 17} },
-	{  10, { 7, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 15, 15, 16} },
-	{10.5, { 6, 8, 9, 10, 11, 11, 11, 12, 13, 13, 14, 14, 14, 15, 16} },
-	{  11, { 5, 7, 9, 10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15} },
-	{11.5, { 5, 7, 9, 10, 11, 11, 11, 12, 12, 13, 13, 13, 13, 14, 15} },
-	{  12, { 4, 6, 8, 9, 10, 10, 11, 12, 12, 13, 13, 13, 13, 14, 15} },
-	{12.5, { 4, 6, 8, 9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 15} },
-	{  13, { 3, 6, 8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 13, 14} },
-	{13.5, { 3, 5, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14} },
-	{  14, { 3, 5, 6, 7, 8, 8, 8, 9, 10, 10, 11, 12, 12, 12, 14} },
-	{14.5, { 2, 4, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 13} },
-	{  15, { 2, 4, 5, 6, 6, 7, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
-	{15.5, { 2, 4, 5, 6, 6, 7, 7, 8, 9, 9, 10, 11, 11, 12, 13} },
-	{  16, { 2, 4, 5, 6, 6, 7, 7, 8, 9, 9, 9, 10, 10, 11, 12} },
-	{16.5, { 2, 3, 4, 5, 6, 7, 7, 8, 9, 9, 9, 10, 10, 11, 12} },
-	{  17, { 2, 3, 4, 5, 5, 6, 7, 7, 8, 8, 8, 9, 9, 10, 12} },
-	{17.5, { 1, 3, 4, 5, 5, 6, 6, 7, 8, 8, 8, 9, 9, 10, 12} },
-	{  18, { 1, 3, 4, 5, 5, 6, 6, 7, 8, 8, 8, 9, 9, 10, 11} },
-	{18.5, { 1, 3, 4, 5, 5, 6, 6, 7, 8, 8, 8, 9, 9, 10, 11} },
-	{  19, { 1, 2, 3, 4, 5, 5, 5, 6, 7, 7, 7, 8, 8, 9, 10} },
-	{19.5, { 1, 2, 3, 4, 5, 5, 5, 6, 7, 7, 7, 8, 8, 9, 10} },
-	{  20, { 1, 2, 3, 3, 4, 5, 5, 6, 6, 6, 6, 7, 7, 8, 10} },
-	{20.5, { 1, 2, 3, 3, 4, 5, 5, 5, 5, 6, 6, 7, 7, 8, 10} },
-	{  21, { 1, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 7, 7, 8, 10} },
-	{21.5, { 1, 2, 3, 3, 3, 3, 4, 5, 5, 5, 6, 7, 7, 8, 9} },
-	{  22, { 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 9} },
-	{22.5, { 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 8} },
-	{  23, { 1, 1, 2, 3, 3, 3, 4, 4, 4, 4, 6, 6, 6, 6, 8} },
-	{23.5, { 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 6, 6, 6, 6, 8} },
-	{  24, { 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 5, 5, 5, 6, 8} },
-	{24.5, { 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 8} },
-	{  25, { 0, 1, 1, 1, 2, 3, 3, 3, 4, 4, 5, 5, 5, 5, 7} },
-	{25.5, { 0, 0, 1, 1, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 7} },
-	{  26, { 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 4, 4, 4, 6} },
-	{26.5, { 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 6} },
-	{  27, { 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 6} },
-	{27.5, { 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 6} },
-	{  28, { 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 5} },
-	{28.5, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 5} },
-	{  29, { 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4} },
-	{29.5, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4} },
-	{  30, { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 4} }
-};
-
-
-const qp_table   qp_table_422_8bpc_max = {
-	{   6, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
-	{ 6.5, { 4, 4, 5, 6, 7, 7, 7, 8, 9, 10, 10, 11, 11, 12, 13} },
-	{   7, { 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 10, 10, 11, 11, 12} },
-	{ 7.5, { 3, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 10, 10, 11, 12} },
-	{   8, { 2, 4, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 9, 10, 11} },
-	{ 8.5, { 2, 3, 4, 5, 6, 6, 6, 7, 7, 8, 8, 9, 9, 10, 11} },
-	{   9, { 1, 2, 3, 4, 5, 5, 5, 6, 6, 7, 7, 8, 8, 9, 10} },
-	{ 9.5, { 1, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7, 7, 8, 9, 10} },
-	{  10, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
-	{10.5, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9} },
-	{  11, { 0, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 7, 8} },
-	{11.5, { 0, 1, 1, 2, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 8} },
-	{  12, { 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7} },
-	{12.5, { 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7} },
-	{  13, { 0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6} },
-	{13.5, { 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5, 6} },
-	{  14, { 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5} },
-	{14.5, { 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 5} },
-	{  15, { 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 5} },
-	{15.5, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 4} },
-	{  16, { 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 4} }
-};
-
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
index 7b294f637881..b19d3aeb5962 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
@@ -23,266 +23,7 @@
  * Authors: AMD
  *
  */
-#include <drm/drm_dsc.h>
-
-#include "os_types.h"
 #include "rc_calc.h"
-#include "qp_tables.h"
-
-#define table_hash(mode, bpc, max_min) ((mode << 16) | (bpc << 8) | max_min)
-
-#define MODE_SELECT(val444, val422, val420) \
-	(cm == CM_444 || cm == CM_RGB) ? (val444) : (cm == CM_422 ? (val422) : (val420))
-
-
-#define TABLE_CASE(mode, bpc, max)   case (table_hash(mode, BPC_##bpc, max)): \
-	table = qp_table_##mode##_##bpc##bpc_##max; \
-	table_size = sizeof(qp_table_##mode##_##bpc##bpc_##max)/sizeof(*qp_table_##mode##_##bpc##bpc_##max); \
-	break
-
-
-static void get_qp_set(qp_set qps, enum colour_mode cm, enum bits_per_comp bpc,
-		       enum max_min max_min, float bpp)
-{
-	int mode = MODE_SELECT(444, 422, 420);
-	int sel = table_hash(mode, bpc, max_min);
-	int table_size = 0;
-	int index;
-	const struct qp_entry *table = 0L;
-
-	// alias enum
-	enum { min = DAL_MM_MIN, max = DAL_MM_MAX };
-	switch (sel) {
-		TABLE_CASE(444,  8, max);
-		TABLE_CASE(444,  8, min);
-		TABLE_CASE(444, 10, max);
-		TABLE_CASE(444, 10, min);
-		TABLE_CASE(444, 12, max);
-		TABLE_CASE(444, 12, min);
-		TABLE_CASE(422,  8, max);
-		TABLE_CASE(422,  8, min);
-		TABLE_CASE(422, 10, max);
-		TABLE_CASE(422, 10, min);
-		TABLE_CASE(422, 12, max);
-		TABLE_CASE(422, 12, min);
-		TABLE_CASE(420,  8, max);
-		TABLE_CASE(420,  8, min);
-		TABLE_CASE(420, 10, max);
-		TABLE_CASE(420, 10, min);
-		TABLE_CASE(420, 12, max);
-		TABLE_CASE(420, 12, min);
-	}
-
-	if (table == 0)
-		return;
-
-	index = (bpp - table[0].bpp) * 2;
-
-	/* requested size is bigger than the table */
-	if (index >= table_size) {
-		dm_error("ERROR: Requested rc_calc to find a bpp entry that exceeds the table size\n");
-		return;
-	}
-
-	memcpy(qps, table[index].qps, sizeof(qp_set));
-}
-
-static double dsc_roundf(double num)
-{
-	if (num < 0.0)
-		num = num - 0.5;
-	else
-		num = num + 0.5;
-
-	return (int)(num);
-}
-
-static double dsc_ceil(double num)
-{
-	double retval = (int)num;
-
-	if (retval != num && num > 0)
-		retval = num + 1;
-
-	return (int)retval;
-}
-
-static void get_ofs_set(qp_set ofs, enum colour_mode mode, float bpp)
-{
-	int   *p = ofs;
-
-	if (mode == CM_444 || mode == CM_RGB) {
-		*p++ = (bpp <=  6) ? (0) : ((((bpp >=  8) && (bpp <= 12))) ? (2) : ((bpp >= 15) ? (10) : ((((bpp > 6) && (bpp < 8))) ? (0 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (2 + dsc_roundf((bpp - 12) * (8 / 3.0))))));
-		*p++ = (bpp <=  6) ? (-2) : ((((bpp >=  8) && (bpp <= 12))) ? (0) : ((bpp >= 15) ? (8) : ((((bpp > 6) && (bpp < 8))) ? (-2 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (0 + dsc_roundf((bpp - 12) * (8 / 3.0))))));
-		*p++ = (bpp <=  6) ? (-2) : ((((bpp >=  8) && (bpp <= 12))) ? (0) : ((bpp >= 15) ? (6) : ((((bpp > 6) && (bpp < 8))) ? (-2 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (0 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
-		*p++ = (bpp <=  6) ? (-4) : ((((bpp >=  8) && (bpp <= 12))) ? (-2) : ((bpp >= 15) ? (4) : ((((bpp > 6) && (bpp < 8))) ? (-4 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (-2 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
-		*p++ = (bpp <=  6) ? (-6) : ((((bpp >=  8) && (bpp <= 12))) ? (-4) : ((bpp >= 15) ? (2) : ((((bpp > 6) && (bpp < 8))) ? (-6 + dsc_roundf((bpp -  6) * (2 / 2.0))) : (-4 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
-		*p++ = (bpp <= 12) ? (-6) : ((bpp >= 15) ? (0) : (-6 + dsc_roundf((bpp - 12) * (6 / 3.0))));
-		*p++ = (bpp <= 12) ? (-8) : ((bpp >= 15) ? (-2) : (-8 + dsc_roundf((bpp - 12) * (6 / 3.0))));
-		*p++ = (bpp <= 12) ? (-8) : ((bpp >= 15) ? (-4) : (-8 + dsc_roundf((bpp - 12) * (4 / 3.0))));
-		*p++ = (bpp <= 12) ? (-8) : ((bpp >= 15) ? (-6) : (-8 + dsc_roundf((bpp - 12) * (2 / 3.0))));
-		*p++ = (bpp <= 12) ? (-10) : ((bpp >= 15) ? (-8) : (-10 + dsc_roundf((bpp - 12) * (2 / 3.0))));
-		*p++ = -10;
-		*p++ = (bpp <=  6) ? (-12) : ((bpp >=  8) ? (-10) : (-12 + dsc_roundf((bpp -  6) * (2 / 2.0))));
-		*p++ = -12;
-		*p++ = -12;
-		*p++ = -12;
-	} else if (mode == CM_422) {
-		*p++ = (bpp <=  8) ? (2) : ((bpp >= 10) ? (10) : (2 + dsc_roundf((bpp -  8) * (8 / 2.0))));
-		*p++ = (bpp <=  8) ? (0) : ((bpp >= 10) ? (8) : (0 + dsc_roundf((bpp -  8) * (8 / 2.0))));
-		*p++ = (bpp <=  8) ? (0) : ((bpp >= 10) ? (6) : (0 + dsc_roundf((bpp -  8) * (6 / 2.0))));
-		*p++ = (bpp <=  8) ? (-2) : ((bpp >= 10) ? (4) : (-2 + dsc_roundf((bpp -  8) * (6 / 2.0))));
-		*p++ = (bpp <=  8) ? (-4) : ((bpp >= 10) ? (2) : (-4 + dsc_roundf((bpp -  8) * (6 / 2.0))));
-		*p++ = (bpp <=  8) ? (-6) : ((bpp >= 10) ? (0) : (-6 + dsc_roundf((bpp -  8) * (6 / 2.0))));
-		*p++ = (bpp <=  8) ? (-8) : ((bpp >= 10) ? (-2) : (-8 + dsc_roundf((bpp -  8) * (6 / 2.0))));
-		*p++ = (bpp <=  8) ? (-8) : ((bpp >= 10) ? (-4) : (-8 + dsc_roundf((bpp -  8) * (4 / 2.0))));
-		*p++ = (bpp <=  8) ? (-8) : ((bpp >= 10) ? (-6) : (-8 + dsc_roundf((bpp -  8) * (2 / 2.0))));
-		*p++ = (bpp <=  8) ? (-10) : ((bpp >= 10) ? (-8) : (-10 + dsc_roundf((bpp -  8) * (2 / 2.0))));
-		*p++ = -10;
-		*p++ = (bpp <=  6) ? (-12) : ((bpp >= 7) ? (-10) : (-12 + dsc_roundf((bpp -  6) * (2.0 / 1))));
-		*p++ = -12;
-		*p++ = -12;
-		*p++ = -12;
-	} else {
-		*p++ = (bpp <=  6) ? (2) : ((bpp >=  8) ? (10) : (2 + dsc_roundf((bpp -  6) * (8 / 2.0))));
-		*p++ = (bpp <=  6) ? (0) : ((bpp >=  8) ? (8) : (0 + dsc_roundf((bpp -  6) * (8 / 2.0))));
-		*p++ = (bpp <=  6) ? (0) : ((bpp >=  8) ? (6) : (0 + dsc_roundf((bpp -  6) * (6 / 2.0))));
-		*p++ = (bpp <=  6) ? (-2) : ((bpp >=  8) ? (4) : (-2 + dsc_roundf((bpp -  6) * (6 / 2.0))));
-		*p++ = (bpp <=  6) ? (-4) : ((bpp >=  8) ? (2) : (-4 + dsc_roundf((bpp -  6) * (6 / 2.0))));
-		*p++ = (bpp <=  6) ? (-6) : ((bpp >=  8) ? (0) : (-6 + dsc_roundf((bpp -  6) * (6 / 2.0))));
-		*p++ = (bpp <=  6) ? (-8) : ((bpp >=  8) ? (-2) : (-8 + dsc_roundf((bpp -  6) * (6 / 2.0))));
-		*p++ = (bpp <=  6) ? (-8) : ((bpp >=  8) ? (-4) : (-8 + dsc_roundf((bpp -  6) * (4 / 2.0))));
-		*p++ = (bpp <=  6) ? (-8) : ((bpp >=  8) ? (-6) : (-8 + dsc_roundf((bpp -  6) * (2 / 2.0))));
-		*p++ = (bpp <=  6) ? (-10) : ((bpp >=  8) ? (-8) : (-10 + dsc_roundf((bpp -  6) * (2 / 2.0))));
-		*p++ = -10;
-		*p++ = (bpp <=  4) ? (-12) : ((bpp >=  5) ? (-10) : (-12 + dsc_roundf((bpp -  4) * (2 / 1.0))));
-		*p++ = -12;
-		*p++ = -12;
-		*p++ = -12;
-	}
-}
-
-static int median3(int a, int b, int c)
-{
-	if (a > b)
-		swap(a, b);
-	if (b > c)
-		swap(b, c);
-	if (a > b)
-		swap(b, c);
-
-	return b;
-}
-
-static void _do_calc_rc_params(struct rc_params *rc, enum colour_mode cm,
-			       enum bits_per_comp bpc, u16 drm_bpp,
-			       bool is_navite_422_or_420,
-			       int slice_width, int slice_height,
-			       int minor_version)
-{
-	float bpp;
-	float bpp_group;
-	float initial_xmit_delay_factor;
-	int padding_pixels;
-	int i;
-
-	bpp = ((float)drm_bpp / 16.0);
-	/* in native_422 or native_420 modes, the bits_per_pixel is double the
-	 * target bpp (the latter is what calc_rc_params expects)
-	 */
-	if (is_navite_422_or_420)
-		bpp /= 2.0;
-
-	rc->rc_quant_incr_limit0 = ((bpc == BPC_8) ? 11 : (bpc == BPC_10 ? 15 : 19)) - ((minor_version == 1 && cm == CM_444) ? 1 : 0);
-	rc->rc_quant_incr_limit1 = ((bpc == BPC_8) ? 11 : (bpc == BPC_10 ? 15 : 19)) - ((minor_version == 1 && cm == CM_444) ? 1 : 0);
-
-	bpp_group = MODE_SELECT(bpp, bpp * 2.0, bpp * 2.0);
-
-	switch (cm) {
-	case CM_420:
-		rc->initial_fullness_offset = (bpp >=  6) ? (2048) : ((bpp <=  4) ? (6144) : ((((bpp >  4) && (bpp <=  5))) ? (6144 - dsc_roundf((bpp - 4) * (512))) : (5632 - dsc_roundf((bpp -  5) * (3584)))));
-		rc->first_line_bpg_offset   = median3(0, (12 + (int) (0.09 *  min(34, slice_height - 8))), (int)((3 * bpc * 3) - (3 * bpp_group)));
-		rc->second_line_bpg_offset  = median3(0, 12, (int)((3 * bpc * 3) - (3 * bpp_group)));
-		break;
-	case CM_422:
-		rc->initial_fullness_offset = (bpp >=  8) ? (2048) : ((bpp <=  7) ? (5632) : (5632 - dsc_roundf((bpp - 7) * (3584))));
-		rc->first_line_bpg_offset   = median3(0, (12 + (int) (0.09 *  min(34, slice_height - 8))), (int)((3 * bpc * 4) - (3 * bpp_group)));
-		rc->second_line_bpg_offset  = 0;
-		break;
-	case CM_444:
-	case CM_RGB:
-		rc->initial_fullness_offset = (bpp >= 12) ? (2048) : ((bpp <=  8) ? (6144) : ((((bpp >  8) && (bpp <= 10))) ? (6144 - dsc_roundf((bpp - 8) * (512 / 2))) : (5632 - dsc_roundf((bpp - 10) * (3584 / 2)))));
-		rc->first_line_bpg_offset   = median3(0, (12 + (int) (0.09 *  min(34, slice_height - 8))), (int)(((3 * bpc + (cm == CM_444 ? 0 : 2)) * 3) - (3 * bpp_group)));
-		rc->second_line_bpg_offset  = 0;
-		break;
-	}
-
-	initial_xmit_delay_factor = (cm == CM_444 || cm == CM_RGB) ? 1.0 : 2.0;
-	rc->initial_xmit_delay = dsc_roundf(8192.0/2.0/bpp/initial_xmit_delay_factor);
-
-	if (cm == CM_422 || cm == CM_420)
-		slice_width /= 2;
-
-	padding_pixels = ((slice_width % 3) != 0) ? (3 - (slice_width % 3)) * (rc->initial_xmit_delay / slice_width) : 0;
-	if (3 * bpp_group >= (((rc->initial_xmit_delay + 2) / 3) * (3 + (cm == CM_422)))) {
-		if ((rc->initial_xmit_delay + padding_pixels) % 3 == 1)
-			rc->initial_xmit_delay++;
-	}
-
-	rc->flatness_min_qp     = ((bpc == BPC_8) ?  (3) : ((bpc == BPC_10) ? (7)  : (11))) - ((minor_version == 1 && cm == CM_444) ? 1 : 0);
-	rc->flatness_max_qp     = ((bpc == BPC_8) ? (12) : ((bpc == BPC_10) ? (16) : (20))) - ((minor_version == 1 && cm == CM_444) ? 1 : 0);
-	rc->flatness_det_thresh = 2 << (bpc - 8);
-
-	get_qp_set(rc->qp_min, cm, bpc, DAL_MM_MIN, bpp);
-	get_qp_set(rc->qp_max, cm, bpc, DAL_MM_MAX, bpp);
-	if (cm == CM_444 && minor_version == 1) {
-		for (i = 0; i < QP_SET_SIZE; ++i) {
-			rc->qp_min[i] = rc->qp_min[i] > 0 ? rc->qp_min[i] - 1 : 0;
-			rc->qp_max[i] = rc->qp_max[i] > 0 ? rc->qp_max[i] - 1 : 0;
-		}
-	}
-	get_ofs_set(rc->ofs, cm, bpp);
-
-	/* fixed parameters */
-	rc->rc_model_size    = 8192;
-	rc->rc_edge_factor   = 6;
-	rc->rc_tgt_offset_hi = 3;
-	rc->rc_tgt_offset_lo = 3;
-
-	rc->rc_buf_thresh[0] = 896;
-	rc->rc_buf_thresh[1] = 1792;
-	rc->rc_buf_thresh[2] = 2688;
-	rc->rc_buf_thresh[3] = 3584;
-	rc->rc_buf_thresh[4] = 4480;
-	rc->rc_buf_thresh[5] = 5376;
-	rc->rc_buf_thresh[6] = 6272;
-	rc->rc_buf_thresh[7] = 6720;
-	rc->rc_buf_thresh[8] = 7168;
-	rc->rc_buf_thresh[9] = 7616;
-	rc->rc_buf_thresh[10] = 7744;
-	rc->rc_buf_thresh[11] = 7872;
-	rc->rc_buf_thresh[12] = 8000;
-	rc->rc_buf_thresh[13] = 8064;
-}
-
-static u32 _do_bytes_per_pixel_calc(int slice_width, u16 drm_bpp,
-				    bool is_navite_422_or_420)
-{
-	float bpp;
-	u32 bytes_per_pixel;
-	double d_bytes_per_pixel;
-
-	bpp = ((float)drm_bpp / 16.0);
-	d_bytes_per_pixel = dsc_ceil(bpp * slice_width / 8.0) / slice_width;
-	// TODO: Make sure the formula for calculating this is precise (ceiling
-	// vs. floor, and at what point they should be applied)
-	if (is_navite_422_or_420)
-		d_bytes_per_pixel /= 2;
-
-	bytes_per_pixel = (u32)dsc_ceil(d_bytes_per_pixel * 0x10000000);
-
-	return bytes_per_pixel;
-}
 
 /**
  * calc_rc_params - reads the user's cmdline mode
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
index 262f06afcbf9..c2340e001b57 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
+++ b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
@@ -27,55 +27,7 @@
 #ifndef __RC_CALC_H__
 #define __RC_CALC_H__
 
-
-#define QP_SET_SIZE 15
-
-typedef int qp_set[QP_SET_SIZE];
-
-struct rc_params {
-	int      rc_quant_incr_limit0;
-	int      rc_quant_incr_limit1;
-	int      initial_fullness_offset;
-	int      initial_xmit_delay;
-	int      first_line_bpg_offset;
-	int      second_line_bpg_offset;
-	int      flatness_min_qp;
-	int      flatness_max_qp;
-	int      flatness_det_thresh;
-	qp_set   qp_min;
-	qp_set   qp_max;
-	qp_set   ofs;
-	int      rc_model_size;
-	int      rc_edge_factor;
-	int      rc_tgt_offset_hi;
-	int      rc_tgt_offset_lo;
-	int      rc_buf_thresh[QP_SET_SIZE - 1];
-};
-
-enum colour_mode {
-	CM_RGB,   /* 444 RGB */
-	CM_444,   /* 444 YUV or simple 422 */
-	CM_422,   /* native 422 */
-	CM_420    /* native 420 */
-};
-
-enum bits_per_comp {
-	BPC_8  =  8,
-	BPC_10 = 10,
-	BPC_12 = 12
-};
-
-enum max_min {
-	DAL_MM_MIN = 0,
-	DAL_MM_MAX = 1
-};
-
-struct qp_entry {
-	float         bpp;
-	const qp_set  qps;
-};
-
-typedef struct qp_entry qp_table[];
+#include "dml/dsc/rc_calc_fpu.h"
 
 void calc_rc_params(struct rc_params *rc, const struct drm_dsc_config *pps);
 u32 calc_dsc_bytes_per_pixel(const struct drm_dsc_config *pps);
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c
index ef830aded5b1..1e19dd674e5a 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c
@@ -22,7 +22,6 @@
  * Authors: AMD
  *
  */
-#include "os_types.h"
 #include <drm/drm_dsc.h>
 #include "dscc_types.h"
 #include "rc_calc.h"
diff --git a/drivers/gpu/drm/amd/display/include/logger_types.h b/drivers/gpu/drm/amd/display/include/logger_types.h
index 571fcf23cea9..a3a9ea077f50 100644
--- a/drivers/gpu/drm/amd/display/include/logger_types.h
+++ b/drivers/gpu/drm/amd/display/include/logger_types.h
@@ -72,6 +72,9 @@
 #define DC_LOG_DSC(...) DRM_DEBUG_KMS(__VA_ARGS__)
 #define DC_LOG_SMU(...) pr_debug("[SMU_MSG]:"__VA_ARGS__)
 #define DC_LOG_DWB(...) DRM_DEBUG_KMS(__VA_ARGS__)
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+#define DC_LOG_DP2(...) DRM_DEBUG_KMS(__VA_ARGS__)
+#endif
 
 struct dal_logger;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index b8896882b6f0..574a9d7f7a5e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -1308,21 +1308,37 @@ static int sienna_cichlid_populate_umd_state_clk(struct smu_context *smu)
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
index 4d08246f930c..45a5f1e48f0e 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -1473,6 +1473,7 @@ static inline void ti_sn_gpio_unregister(void) {}
 
 static void ti_sn65dsi86_runtime_disable(void *data)
 {
+	pm_runtime_dont_use_autosuspend(data);
 	pm_runtime_disable(data);
 }
 
@@ -1532,11 +1533,11 @@ static int ti_sn65dsi86_probe(struct i2c_client *client,
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
 
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 2c0c6ec92820..ff2bc9a11801 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1001,7 +1001,7 @@ crtc_needs_disable(struct drm_crtc_state *old_state,
 	 * it's in self refresh mode and needs to be fully disabled.
 	 */
 	return old_state->active ||
-	       (old_state->self_refresh_active && !new_state->enable) ||
+	       (old_state->self_refresh_active && !new_state->active) ||
 	       new_state->self_refresh_active;
 }
 
diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 335ba9f43d8f..26cf75422945 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -211,6 +211,8 @@ i915-y += \
 	display/intel_dpio_phy.o \
 	display/intel_dpll.o \
 	display/intel_dpll_mgr.o \
+	display/intel_dpt.o \
+	display/intel_drrs.o \
 	display/intel_dsb.o \
 	display/intel_fb.o \
 	display/intel_fbc.o \
diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 82e5064b4ce7..f61901e26409 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -40,6 +40,7 @@
 #include "intel_dp_link_training.h"
 #include "intel_dp_mst.h"
 #include "intel_dpio_phy.h"
+#include "intel_drrs.h"
 #include "intel_dsi.h"
 #include "intel_fdi.h"
 #include "intel_fifo_underrun.h"
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 17f44ffea586..625ce6975eeb 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -84,6 +84,7 @@
 #include "intel_display_types.h"
 #include "intel_dmc.h"
 #include "intel_dp_link_training.h"
+#include "intel_dpt.h"
 #include "intel_fbc.h"
 #include "intel_fdi.h"
 #include "intel_fbdev.h"
@@ -126,182 +127,6 @@ static void ilk_pfit_enable(const struct intel_crtc_state *crtc_state);
 static void intel_modeset_setup_hw_state(struct drm_device *dev,
 					 struct drm_modeset_acquire_ctx *ctx);
 
-struct i915_dpt {
-	struct i915_address_space vm;
-
-	struct drm_i915_gem_object *obj;
-	struct i915_vma *vma;
-	void __iomem *iomem;
-};
-
-#define i915_is_dpt(vm) ((vm)->is_dpt)
-
-static inline struct i915_dpt *
-i915_vm_to_dpt(struct i915_address_space *vm)
-{
-	BUILD_BUG_ON(offsetof(struct i915_dpt, vm));
-	GEM_BUG_ON(!i915_is_dpt(vm));
-	return container_of(vm, struct i915_dpt, vm);
-}
-
-#define dpt_total_entries(dpt) ((dpt)->vm.total >> PAGE_SHIFT)
-
-static void gen8_set_pte(void __iomem *addr, gen8_pte_t pte)
-{
-	writeq(pte, addr);
-}
-
-static void dpt_insert_page(struct i915_address_space *vm,
-			    dma_addr_t addr,
-			    u64 offset,
-			    enum i915_cache_level level,
-			    u32 flags)
-{
-	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
-	gen8_pte_t __iomem *base = dpt->iomem;
-
-	gen8_set_pte(base + offset / I915_GTT_PAGE_SIZE,
-		     vm->pte_encode(addr, level, flags));
-}
-
-static void dpt_insert_entries(struct i915_address_space *vm,
-			       struct i915_vma *vma,
-			       enum i915_cache_level level,
-			       u32 flags)
-{
-	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
-	gen8_pte_t __iomem *base = dpt->iomem;
-	const gen8_pte_t pte_encode = vm->pte_encode(0, level, flags);
-	struct sgt_iter sgt_iter;
-	dma_addr_t addr;
-	int i;
-
-	/*
-	 * Note that we ignore PTE_READ_ONLY here. The caller must be careful
-	 * not to allow the user to override access to a read only page.
-	 */
-
-	i = vma->node.start / I915_GTT_PAGE_SIZE;
-	for_each_sgt_daddr(addr, sgt_iter, vma->pages)
-		gen8_set_pte(&base[i++], pte_encode | addr);
-}
-
-static void dpt_clear_range(struct i915_address_space *vm,
-			    u64 start, u64 length)
-{
-}
-
-static void dpt_bind_vma(struct i915_address_space *vm,
-			 struct i915_vm_pt_stash *stash,
-			 struct i915_vma *vma,
-			 enum i915_cache_level cache_level,
-			 u32 flags)
-{
-	struct drm_i915_gem_object *obj = vma->obj;
-	u32 pte_flags;
-
-	/* Applicable to VLV (gen8+ do not support RO in the GGTT) */
-	pte_flags = 0;
-	if (vma->vm->has_read_only && i915_gem_object_is_readonly(obj))
-		pte_flags |= PTE_READ_ONLY;
-	if (i915_gem_object_is_lmem(obj))
-		pte_flags |= PTE_LM;
-
-	vma->vm->insert_entries(vma->vm, vma, cache_level, pte_flags);
-
-	vma->page_sizes.gtt = I915_GTT_PAGE_SIZE;
-
-	/*
-	 * Without aliasing PPGTT there's no difference between
-	 * GLOBAL/LOCAL_BIND, it's all the same ptes. Hence unconditionally
-	 * upgrade to both bound if we bind either to avoid double-binding.
-	 */
-	atomic_or(I915_VMA_GLOBAL_BIND | I915_VMA_LOCAL_BIND, &vma->flags);
-}
-
-static void dpt_unbind_vma(struct i915_address_space *vm, struct i915_vma *vma)
-{
-	vm->clear_range(vm, vma->node.start, vma->size);
-}
-
-static void dpt_cleanup(struct i915_address_space *vm)
-{
-	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
-
-	i915_gem_object_put(dpt->obj);
-}
-
-static struct i915_address_space *
-intel_dpt_create(struct intel_framebuffer *fb)
-{
-	struct drm_gem_object *obj = &intel_fb_obj(&fb->base)->base;
-	struct drm_i915_private *i915 = to_i915(obj->dev);
-	struct drm_i915_gem_object *dpt_obj;
-	struct i915_address_space *vm;
-	struct i915_dpt *dpt;
-	size_t size;
-	int ret;
-
-	if (intel_fb_needs_pot_stride_remap(fb))
-		size = intel_remapped_info_size(&fb->remapped_view.gtt.remapped);
-	else
-		size = DIV_ROUND_UP_ULL(obj->size, I915_GTT_PAGE_SIZE);
-
-	size = round_up(size * sizeof(gen8_pte_t), I915_GTT_PAGE_SIZE);
-
-	if (HAS_LMEM(i915))
-		dpt_obj = i915_gem_object_create_lmem(i915, size, 0);
-	else
-		dpt_obj = i915_gem_object_create_stolen(i915, size);
-	if (IS_ERR(dpt_obj))
-		return ERR_CAST(dpt_obj);
-
-	ret = i915_gem_object_set_cache_level(dpt_obj, I915_CACHE_NONE);
-	if (ret) {
-		i915_gem_object_put(dpt_obj);
-		return ERR_PTR(ret);
-	}
-
-	dpt = kzalloc(sizeof(*dpt), GFP_KERNEL);
-	if (!dpt) {
-		i915_gem_object_put(dpt_obj);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	vm = &dpt->vm;
-
-	vm->gt = &i915->gt;
-	vm->i915 = i915;
-	vm->dma = i915->drm.dev;
-	vm->total = (size / sizeof(gen8_pte_t)) * I915_GTT_PAGE_SIZE;
-	vm->is_dpt = true;
-
-	i915_address_space_init(vm, VM_CLASS_DPT);
-
-	vm->insert_page = dpt_insert_page;
-	vm->clear_range = dpt_clear_range;
-	vm->insert_entries = dpt_insert_entries;
-	vm->cleanup = dpt_cleanup;
-
-	vm->vma_ops.bind_vma    = dpt_bind_vma;
-	vm->vma_ops.unbind_vma  = dpt_unbind_vma;
-	vm->vma_ops.set_pages   = ggtt_set_pages;
-	vm->vma_ops.clear_pages = clear_pages;
-
-	vm->pte_encode = gen8_ggtt_pte_encode;
-
-	dpt->obj = dpt_obj;
-
-	return &dpt->vm;
-}
-
-static void intel_dpt_destroy(struct i915_address_space *vm)
-{
-	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
-
-	i915_vm_close(&dpt->vm);
-}
-
 /* returns HPLL frequency in kHz */
 int vlv_get_hpll_vco(struct drm_i915_private *dev_priv)
 {
@@ -1879,49 +1704,6 @@ static void intel_plane_disable_noatomic(struct intel_crtc *crtc,
 	intel_wait_for_vblank(dev_priv, crtc->pipe);
 }
 
-static struct i915_vma *intel_dpt_pin(struct i915_address_space *vm)
-{
-	struct drm_i915_private *i915 = vm->i915;
-	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
-	intel_wakeref_t wakeref;
-	struct i915_vma *vma;
-	void __iomem *iomem;
-
-	wakeref = intel_runtime_pm_get(&i915->runtime_pm);
-	atomic_inc(&i915->gpu_error.pending_fb_pin);
-
-	vma = i915_gem_object_ggtt_pin(dpt->obj, NULL, 0, 4096,
-				       HAS_LMEM(i915) ? 0 : PIN_MAPPABLE);
-	if (IS_ERR(vma))
-		goto err;
-
-	iomem = i915_vma_pin_iomap(vma);
-	i915_vma_unpin(vma);
-	if (IS_ERR(iomem)) {
-		vma = iomem;
-		goto err;
-	}
-
-	dpt->vma = vma;
-	dpt->iomem = iomem;
-
-	i915_vma_get(vma);
-
-err:
-	atomic_dec(&i915->gpu_error.pending_fb_pin);
-	intel_runtime_pm_put(&i915->runtime_pm, wakeref);
-
-	return vma;
-}
-
-static void intel_dpt_unpin(struct i915_address_space *vm)
-{
-	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
-
-	i915_vma_unpin_iomap(dpt->vma);
-	i915_vma_put(dpt->vma);
-}
-
 static bool
 intel_reuse_initial_plane_obj(struct drm_i915_private *i915,
 			      const struct intel_initial_plane_config *plane_config,
diff --git a/drivers/gpu/drm/i915/display/intel_display_debugfs.c b/drivers/gpu/drm/i915/display/intel_display_debugfs.c
index 8fdacb252bb1..b136a0fc0963 100644
--- a/drivers/gpu/drm/i915/display/intel_display_debugfs.c
+++ b/drivers/gpu/drm/i915/display/intel_display_debugfs.c
@@ -13,6 +13,7 @@
 #include "intel_display_types.h"
 #include "intel_dmc.h"
 #include "intel_dp.h"
+#include "intel_drrs.h"
 #include "intel_fbc.h"
 #include "intel_hdcp.h"
 #include "intel_hdmi.h"
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index d55363f1fa10..dbff4b6aa22b 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -56,6 +56,7 @@
 #include "intel_dp_mst.h"
 #include "intel_dpio_phy.h"
 #include "intel_dpll.h"
+#include "intel_drrs.h"
 #include "intel_fifo_underrun.h"
 #include "intel_hdcp.h"
 #include "intel_hdmi.h"
@@ -1610,46 +1611,6 @@ intel_dp_compute_hdr_metadata_infoframe_sdp(struct intel_dp *intel_dp,
 		intel_hdmi_infoframe_enable(HDMI_PACKET_TYPE_GAMUT_METADATA);
 }
 
-static void
-intel_dp_drrs_compute_config(struct intel_dp *intel_dp,
-			     struct intel_crtc_state *pipe_config,
-			     int output_bpp, bool constant_n)
-{
-	struct intel_connector *intel_connector = intel_dp->attached_connector;
-	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
-	int pixel_clock;
-
-	if (pipe_config->vrr.enable)
-		return;
-
-	/*
-	 * DRRS and PSR can't be enable together, so giving preference to PSR
-	 * as it allows more power-savings by complete shutting down display,
-	 * so to guarantee this, intel_dp_drrs_compute_config() must be called
-	 * after intel_psr_compute_config().
-	 */
-	if (pipe_config->has_psr)
-		return;
-
-	if (!intel_connector->panel.downclock_mode ||
-	    dev_priv->drrs.type != SEAMLESS_DRRS_SUPPORT)
-		return;
-
-	pipe_config->has_drrs = true;
-
-	pixel_clock = intel_connector->panel.downclock_mode->clock;
-	if (pipe_config->splitter.enable)
-		pixel_clock /= pipe_config->splitter.link_count;
-
-	intel_link_compute_m_n(output_bpp, pipe_config->lane_count, pixel_clock,
-			       pipe_config->port_clock, &pipe_config->dp_m2_n2,
-			       constant_n, pipe_config->fec_enable);
-
-	/* FIXME: abstract this better */
-	if (pipe_config->splitter.enable)
-		pipe_config->dp_m2_n2.gmch_m *= pipe_config->splitter.link_count;
-}
-
 int
 intel_dp_compute_config(struct intel_encoder *encoder,
 			struct intel_crtc_state *pipe_config,
@@ -4737,432 +4698,6 @@ intel_dp_add_properties(struct intel_dp *intel_dp, struct drm_connector *connect
 		drm_connector_attach_vrr_capable_property(connector);
 }
 
-/**
- * intel_dp_set_drrs_state - program registers for RR switch to take effect
- * @dev_priv: i915 device
- * @crtc_state: a pointer to the active intel_crtc_state
- * @refresh_rate: RR to be programmed
- *
- * This function gets called when refresh rate (RR) has to be changed from
- * one frequency to another. Switches can be between high and low RR
- * supported by the panel or to any other RR based on media playback (in
- * this case, RR value needs to be passed from user space).
- *
- * The caller of this function needs to take a lock on dev_priv->drrs.
- */
-static void intel_dp_set_drrs_state(struct drm_i915_private *dev_priv,
-				    const struct intel_crtc_state *crtc_state,
-				    int refresh_rate)
-{
-	struct intel_dp *intel_dp = dev_priv->drrs.dp;
-	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
-	enum drrs_refresh_rate_type index = DRRS_HIGH_RR;
-
-	if (refresh_rate <= 0) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "Refresh rate should be positive non-zero.\n");
-		return;
-	}
-
-	if (intel_dp == NULL) {
-		drm_dbg_kms(&dev_priv->drm, "DRRS not supported.\n");
-		return;
-	}
-
-	if (!crtc) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "DRRS: intel_crtc not initialized\n");
-		return;
-	}
-
-	if (dev_priv->drrs.type < SEAMLESS_DRRS_SUPPORT) {
-		drm_dbg_kms(&dev_priv->drm, "Only Seamless DRRS supported.\n");
-		return;
-	}
-
-	if (drm_mode_vrefresh(intel_dp->attached_connector->panel.downclock_mode) ==
-			refresh_rate)
-		index = DRRS_LOW_RR;
-
-	if (index == dev_priv->drrs.refresh_rate_type) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "DRRS requested for previously set RR...ignoring\n");
-		return;
-	}
-
-	if (!crtc_state->hw.active) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "eDP encoder disabled. CRTC not Active\n");
-		return;
-	}
-
-	if (DISPLAY_VER(dev_priv) >= 8 && !IS_CHERRYVIEW(dev_priv)) {
-		switch (index) {
-		case DRRS_HIGH_RR:
-			intel_dp_set_m_n(crtc_state, M1_N1);
-			break;
-		case DRRS_LOW_RR:
-			intel_dp_set_m_n(crtc_state, M2_N2);
-			break;
-		case DRRS_MAX_RR:
-		default:
-			drm_err(&dev_priv->drm,
-				"Unsupported refreshrate type\n");
-		}
-	} else if (DISPLAY_VER(dev_priv) > 6) {
-		i915_reg_t reg = PIPECONF(crtc_state->cpu_transcoder);
-		u32 val;
-
-		val = intel_de_read(dev_priv, reg);
-		if (index > DRRS_HIGH_RR) {
-			if (IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv))
-				val |= PIPECONF_EDP_RR_MODE_SWITCH_VLV;
-			else
-				val |= PIPECONF_EDP_RR_MODE_SWITCH;
-		} else {
-			if (IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv))
-				val &= ~PIPECONF_EDP_RR_MODE_SWITCH_VLV;
-			else
-				val &= ~PIPECONF_EDP_RR_MODE_SWITCH;
-		}
-		intel_de_write(dev_priv, reg, val);
-	}
-
-	dev_priv->drrs.refresh_rate_type = index;
-
-	drm_dbg_kms(&dev_priv->drm, "eDP Refresh Rate set to : %dHz\n",
-		    refresh_rate);
-}
-
-static void
-intel_edp_drrs_enable_locked(struct intel_dp *intel_dp)
-{
-	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
-
-	dev_priv->drrs.busy_frontbuffer_bits = 0;
-	dev_priv->drrs.dp = intel_dp;
-}
-
-/**
- * intel_edp_drrs_enable - init drrs struct if supported
- * @intel_dp: DP struct
- * @crtc_state: A pointer to the active crtc state.
- *
- * Initializes frontbuffer_bits and drrs.dp
- */
-void intel_edp_drrs_enable(struct intel_dp *intel_dp,
-			   const struct intel_crtc_state *crtc_state)
-{
-	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
-
-	if (!crtc_state->has_drrs)
-		return;
-
-	drm_dbg_kms(&dev_priv->drm, "Enabling DRRS\n");
-
-	mutex_lock(&dev_priv->drrs.mutex);
-
-	if (dev_priv->drrs.dp) {
-		drm_warn(&dev_priv->drm, "DRRS already enabled\n");
-		goto unlock;
-	}
-
-	intel_edp_drrs_enable_locked(intel_dp);
-
-unlock:
-	mutex_unlock(&dev_priv->drrs.mutex);
-}
-
-static void
-intel_edp_drrs_disable_locked(struct intel_dp *intel_dp,
-			      const struct intel_crtc_state *crtc_state)
-{
-	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
-
-	if (dev_priv->drrs.refresh_rate_type == DRRS_LOW_RR) {
-		int refresh;
-
-		refresh = drm_mode_vrefresh(intel_dp->attached_connector->panel.fixed_mode);
-		intel_dp_set_drrs_state(dev_priv, crtc_state, refresh);
-	}
-
-	dev_priv->drrs.dp = NULL;
-}
-
-/**
- * intel_edp_drrs_disable - Disable DRRS
- * @intel_dp: DP struct
- * @old_crtc_state: Pointer to old crtc_state.
- *
- */
-void intel_edp_drrs_disable(struct intel_dp *intel_dp,
-			    const struct intel_crtc_state *old_crtc_state)
-{
-	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
-
-	if (!old_crtc_state->has_drrs)
-		return;
-
-	mutex_lock(&dev_priv->drrs.mutex);
-	if (!dev_priv->drrs.dp) {
-		mutex_unlock(&dev_priv->drrs.mutex);
-		return;
-	}
-
-	intel_edp_drrs_disable_locked(intel_dp, old_crtc_state);
-	mutex_unlock(&dev_priv->drrs.mutex);
-
-	cancel_delayed_work_sync(&dev_priv->drrs.work);
-}
-
-/**
- * intel_edp_drrs_update - Update DRRS state
- * @intel_dp: Intel DP
- * @crtc_state: new CRTC state
- *
- * This function will update DRRS states, disabling or enabling DRRS when
- * executing fastsets. For full modeset, intel_edp_drrs_disable() and
- * intel_edp_drrs_enable() should be called instead.
- */
-void
-intel_edp_drrs_update(struct intel_dp *intel_dp,
-		      const struct intel_crtc_state *crtc_state)
-{
-	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
-
-	if (dev_priv->drrs.type != SEAMLESS_DRRS_SUPPORT)
-		return;
-
-	mutex_lock(&dev_priv->drrs.mutex);
-
-	/* New state matches current one? */
-	if (crtc_state->has_drrs == !!dev_priv->drrs.dp)
-		goto unlock;
-
-	if (crtc_state->has_drrs)
-		intel_edp_drrs_enable_locked(intel_dp);
-	else
-		intel_edp_drrs_disable_locked(intel_dp, crtc_state);
-
-unlock:
-	mutex_unlock(&dev_priv->drrs.mutex);
-}
-
-static void intel_edp_drrs_downclock_work(struct work_struct *work)
-{
-	struct drm_i915_private *dev_priv =
-		container_of(work, typeof(*dev_priv), drrs.work.work);
-	struct intel_dp *intel_dp;
-
-	mutex_lock(&dev_priv->drrs.mutex);
-
-	intel_dp = dev_priv->drrs.dp;
-
-	if (!intel_dp)
-		goto unlock;
-
-	/*
-	 * The delayed work can race with an invalidate hence we need to
-	 * recheck.
-	 */
-
-	if (dev_priv->drrs.busy_frontbuffer_bits)
-		goto unlock;
-
-	if (dev_priv->drrs.refresh_rate_type != DRRS_LOW_RR) {
-		struct drm_crtc *crtc = dp_to_dig_port(intel_dp)->base.base.crtc;
-
-		intel_dp_set_drrs_state(dev_priv, to_intel_crtc(crtc)->config,
-			drm_mode_vrefresh(intel_dp->attached_connector->panel.downclock_mode));
-	}
-
-unlock:
-	mutex_unlock(&dev_priv->drrs.mutex);
-}
-
-/**
- * intel_edp_drrs_invalidate - Disable Idleness DRRS
- * @dev_priv: i915 device
- * @frontbuffer_bits: frontbuffer plane tracking bits
- *
- * This function gets called everytime rendering on the given planes start.
- * Hence DRRS needs to be Upclocked, i.e. (LOW_RR -> HIGH_RR).
- *
- * Dirty frontbuffers relevant to DRRS are tracked in busy_frontbuffer_bits.
- */
-void intel_edp_drrs_invalidate(struct drm_i915_private *dev_priv,
-			       unsigned int frontbuffer_bits)
-{
-	struct intel_dp *intel_dp;
-	struct drm_crtc *crtc;
-	enum pipe pipe;
-
-	if (dev_priv->drrs.type == DRRS_NOT_SUPPORTED)
-		return;
-
-	cancel_delayed_work(&dev_priv->drrs.work);
-
-	mutex_lock(&dev_priv->drrs.mutex);
-
-	intel_dp = dev_priv->drrs.dp;
-	if (!intel_dp) {
-		mutex_unlock(&dev_priv->drrs.mutex);
-		return;
-	}
-
-	crtc = dp_to_dig_port(intel_dp)->base.base.crtc;
-	pipe = to_intel_crtc(crtc)->pipe;
-
-	frontbuffer_bits &= INTEL_FRONTBUFFER_ALL_MASK(pipe);
-	dev_priv->drrs.busy_frontbuffer_bits |= frontbuffer_bits;
-
-	/* invalidate means busy screen hence upclock */
-	if (frontbuffer_bits && dev_priv->drrs.refresh_rate_type == DRRS_LOW_RR)
-		intel_dp_set_drrs_state(dev_priv, to_intel_crtc(crtc)->config,
-					drm_mode_vrefresh(intel_dp->attached_connector->panel.fixed_mode));
-
-	mutex_unlock(&dev_priv->drrs.mutex);
-}
-
-/**
- * intel_edp_drrs_flush - Restart Idleness DRRS
- * @dev_priv: i915 device
- * @frontbuffer_bits: frontbuffer plane tracking bits
- *
- * This function gets called every time rendering on the given planes has
- * completed or flip on a crtc is completed. So DRRS should be upclocked
- * (LOW_RR -> HIGH_RR). And also Idleness detection should be started again,
- * if no other planes are dirty.
- *
- * Dirty frontbuffers relevant to DRRS are tracked in busy_frontbuffer_bits.
- */
-void intel_edp_drrs_flush(struct drm_i915_private *dev_priv,
-			  unsigned int frontbuffer_bits)
-{
-	struct intel_dp *intel_dp;
-	struct drm_crtc *crtc;
-	enum pipe pipe;
-
-	if (dev_priv->drrs.type == DRRS_NOT_SUPPORTED)
-		return;
-
-	cancel_delayed_work(&dev_priv->drrs.work);
-
-	mutex_lock(&dev_priv->drrs.mutex);
-
-	intel_dp = dev_priv->drrs.dp;
-	if (!intel_dp) {
-		mutex_unlock(&dev_priv->drrs.mutex);
-		return;
-	}
-
-	crtc = dp_to_dig_port(intel_dp)->base.base.crtc;
-	pipe = to_intel_crtc(crtc)->pipe;
-
-	frontbuffer_bits &= INTEL_FRONTBUFFER_ALL_MASK(pipe);
-	dev_priv->drrs.busy_frontbuffer_bits &= ~frontbuffer_bits;
-
-	/* flush means busy screen hence upclock */
-	if (frontbuffer_bits && dev_priv->drrs.refresh_rate_type == DRRS_LOW_RR)
-		intel_dp_set_drrs_state(dev_priv, to_intel_crtc(crtc)->config,
-					drm_mode_vrefresh(intel_dp->attached_connector->panel.fixed_mode));
-
-	/*
-	 * flush also means no more activity hence schedule downclock, if all
-	 * other fbs are quiescent too
-	 */
-	if (!dev_priv->drrs.busy_frontbuffer_bits)
-		schedule_delayed_work(&dev_priv->drrs.work,
-				msecs_to_jiffies(1000));
-	mutex_unlock(&dev_priv->drrs.mutex);
-}
-
-/**
- * DOC: Display Refresh Rate Switching (DRRS)
- *
- * Display Refresh Rate Switching (DRRS) is a power conservation feature
- * which enables swtching between low and high refresh rates,
- * dynamically, based on the usage scenario. This feature is applicable
- * for internal panels.
- *
- * Indication that the panel supports DRRS is given by the panel EDID, which
- * would list multiple refresh rates for one resolution.
- *
- * DRRS is of 2 types - static and seamless.
- * Static DRRS involves changing refresh rate (RR) by doing a full modeset
- * (may appear as a blink on screen) and is used in dock-undock scenario.
- * Seamless DRRS involves changing RR without any visual effect to the user
- * and can be used during normal system usage. This is done by programming
- * certain registers.
- *
- * Support for static/seamless DRRS may be indicated in the VBT based on
- * inputs from the panel spec.
- *
- * DRRS saves power by switching to low RR based on usage scenarios.
- *
- * The implementation is based on frontbuffer tracking implementation.  When
- * there is a disturbance on the screen triggered by user activity or a periodic
- * system activity, DRRS is disabled (RR is changed to high RR).  When there is
- * no movement on screen, after a timeout of 1 second, a switch to low RR is
- * made.
- *
- * For integration with frontbuffer tracking code, intel_edp_drrs_invalidate()
- * and intel_edp_drrs_flush() are called.
- *
- * DRRS can be further extended to support other internal panels and also
- * the scenario of video playback wherein RR is set based on the rate
- * requested by userspace.
- */
-
-/**
- * intel_dp_drrs_init - Init basic DRRS work and mutex.
- * @connector: eDP connector
- * @fixed_mode: preferred mode of panel
- *
- * This function is  called only once at driver load to initialize basic
- * DRRS stuff.
- *
- * Returns:
- * Downclock mode if panel supports it, else return NULL.
- * DRRS support is determined by the presence of downclock mode (apart
- * from VBT setting).
- */
-static struct drm_display_mode *
-intel_dp_drrs_init(struct intel_connector *connector,
-		   struct drm_display_mode *fixed_mode)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct drm_display_mode *downclock_mode = NULL;
-
-	INIT_DELAYED_WORK(&dev_priv->drrs.work, intel_edp_drrs_downclock_work);
-	mutex_init(&dev_priv->drrs.mutex);
-
-	if (DISPLAY_VER(dev_priv) <= 6) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "DRRS supported for Gen7 and above\n");
-		return NULL;
-	}
-
-	if (dev_priv->vbt.drrs_type != SEAMLESS_DRRS_SUPPORT) {
-		drm_dbg_kms(&dev_priv->drm, "VBT doesn't support DRRS\n");
-		return NULL;
-	}
-
-	downclock_mode = intel_panel_edid_downclock_mode(connector, fixed_mode);
-	if (!downclock_mode) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "Downclock mode is not found. DRRS not supported\n");
-		return NULL;
-	}
-
-	dev_priv->drrs.type = dev_priv->vbt.drrs_type;
-
-	dev_priv->drrs.refresh_rate_type = DRRS_HIGH_RR;
-	drm_dbg_kms(&dev_priv->drm,
-		    "seamless DRRS supported for eDP panel.\n");
-	return downclock_mode;
-}
-
 static bool intel_edp_init_connector(struct intel_dp *intel_dp,
 				     struct intel_connector *intel_connector)
 {
diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
index 2121aaa9b8db..3dd6ebc2f6b1 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -70,17 +70,6 @@ int intel_dp_max_link_rate(struct intel_dp *intel_dp);
 int intel_dp_max_lane_count(struct intel_dp *intel_dp);
 int intel_dp_rate_select(struct intel_dp *intel_dp, int rate);
 
-void intel_edp_drrs_enable(struct intel_dp *intel_dp,
-			   const struct intel_crtc_state *crtc_state);
-void intel_edp_drrs_disable(struct intel_dp *intel_dp,
-			    const struct intel_crtc_state *crtc_state);
-void intel_edp_drrs_update(struct intel_dp *intel_dp,
-			   const struct intel_crtc_state *crtc_state);
-void intel_edp_drrs_invalidate(struct drm_i915_private *dev_priv,
-			       unsigned int frontbuffer_bits);
-void intel_edp_drrs_flush(struct drm_i915_private *dev_priv,
-			  unsigned int frontbuffer_bits);
-
 void intel_dp_compute_rate(struct intel_dp *intel_dp, int port_clock,
 			   u8 *link_bw, u8 *rate_select);
 bool intel_dp_source_supports_hbr2(struct intel_dp *intel_dp);
diff --git a/drivers/gpu/drm/i915/display/intel_dpt.c b/drivers/gpu/drm/i915/display/intel_dpt.c
new file mode 100644
index 000000000000..22acd945a9e4
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_dpt.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright © 2021 Intel Corporation
+ */
+
+#include "i915_drv.h"
+#include "intel_display_types.h"
+#include "intel_dpt.h"
+#include "intel_fb.h"
+#include "gt/gen8_ppgtt.h"
+
+struct i915_dpt {
+	struct i915_address_space vm;
+
+	struct drm_i915_gem_object *obj;
+	struct i915_vma *vma;
+	void __iomem *iomem;
+};
+
+#define i915_is_dpt(vm) ((vm)->is_dpt)
+
+static inline struct i915_dpt *
+i915_vm_to_dpt(struct i915_address_space *vm)
+{
+	BUILD_BUG_ON(offsetof(struct i915_dpt, vm));
+	GEM_BUG_ON(!i915_is_dpt(vm));
+	return container_of(vm, struct i915_dpt, vm);
+}
+
+#define dpt_total_entries(dpt) ((dpt)->vm.total >> PAGE_SHIFT)
+
+static void gen8_set_pte(void __iomem *addr, gen8_pte_t pte)
+{
+	writeq(pte, addr);
+}
+
+static void dpt_insert_page(struct i915_address_space *vm,
+			    dma_addr_t addr,
+			    u64 offset,
+			    enum i915_cache_level level,
+			    u32 flags)
+{
+	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
+	gen8_pte_t __iomem *base = dpt->iomem;
+
+	gen8_set_pte(base + offset / I915_GTT_PAGE_SIZE,
+		     vm->pte_encode(addr, level, flags));
+}
+
+static void dpt_insert_entries(struct i915_address_space *vm,
+			       struct i915_vma *vma,
+			       enum i915_cache_level level,
+			       u32 flags)
+{
+	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
+	gen8_pte_t __iomem *base = dpt->iomem;
+	const gen8_pte_t pte_encode = vm->pte_encode(0, level, flags);
+	struct sgt_iter sgt_iter;
+	dma_addr_t addr;
+	int i;
+
+	/*
+	 * Note that we ignore PTE_READ_ONLY here. The caller must be careful
+	 * not to allow the user to override access to a read only page.
+	 */
+
+	i = vma->node.start / I915_GTT_PAGE_SIZE;
+	for_each_sgt_daddr(addr, sgt_iter, vma->pages)
+		gen8_set_pte(&base[i++], pte_encode | addr);
+}
+
+static void dpt_clear_range(struct i915_address_space *vm,
+			    u64 start, u64 length)
+{
+}
+
+static void dpt_bind_vma(struct i915_address_space *vm,
+			 struct i915_vm_pt_stash *stash,
+			 struct i915_vma *vma,
+			 enum i915_cache_level cache_level,
+			 u32 flags)
+{
+	struct drm_i915_gem_object *obj = vma->obj;
+	u32 pte_flags;
+
+	/* Applicable to VLV (gen8+ do not support RO in the GGTT) */
+	pte_flags = 0;
+	if (vma->vm->has_read_only && i915_gem_object_is_readonly(obj))
+		pte_flags |= PTE_READ_ONLY;
+	if (i915_gem_object_is_lmem(obj))
+		pte_flags |= PTE_LM;
+
+	vma->vm->insert_entries(vma->vm, vma, cache_level, pte_flags);
+
+	vma->page_sizes.gtt = I915_GTT_PAGE_SIZE;
+
+	/*
+	 * Without aliasing PPGTT there's no difference between
+	 * GLOBAL/LOCAL_BIND, it's all the same ptes. Hence unconditionally
+	 * upgrade to both bound if we bind either to avoid double-binding.
+	 */
+	atomic_or(I915_VMA_GLOBAL_BIND | I915_VMA_LOCAL_BIND, &vma->flags);
+}
+
+static void dpt_unbind_vma(struct i915_address_space *vm, struct i915_vma *vma)
+{
+	vm->clear_range(vm, vma->node.start, vma->size);
+}
+
+static void dpt_cleanup(struct i915_address_space *vm)
+{
+	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
+
+	i915_gem_object_put(dpt->obj);
+}
+
+struct i915_vma *intel_dpt_pin(struct i915_address_space *vm)
+{
+	struct drm_i915_private *i915 = vm->i915;
+	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
+	intel_wakeref_t wakeref;
+	struct i915_vma *vma;
+	void __iomem *iomem;
+
+	wakeref = intel_runtime_pm_get(&i915->runtime_pm);
+	atomic_inc(&i915->gpu_error.pending_fb_pin);
+
+	vma = i915_gem_object_ggtt_pin(dpt->obj, NULL, 0, 4096,
+				       HAS_LMEM(i915) ? 0 : PIN_MAPPABLE);
+	if (IS_ERR(vma))
+		goto err;
+
+	iomem = i915_vma_pin_iomap(vma);
+	i915_vma_unpin(vma);
+	if (IS_ERR(iomem)) {
+		vma = iomem;
+		goto err;
+	}
+
+	dpt->vma = vma;
+	dpt->iomem = iomem;
+
+	i915_vma_get(vma);
+
+err:
+	atomic_dec(&i915->gpu_error.pending_fb_pin);
+	intel_runtime_pm_put(&i915->runtime_pm, wakeref);
+
+	return vma;
+}
+
+void intel_dpt_unpin(struct i915_address_space *vm)
+{
+	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
+
+	i915_vma_unpin_iomap(dpt->vma);
+	i915_vma_put(dpt->vma);
+}
+
+struct i915_address_space *
+intel_dpt_create(struct intel_framebuffer *fb)
+{
+	struct drm_gem_object *obj = &intel_fb_obj(&fb->base)->base;
+	struct drm_i915_private *i915 = to_i915(obj->dev);
+	struct drm_i915_gem_object *dpt_obj;
+	struct i915_address_space *vm;
+	struct i915_dpt *dpt;
+	size_t size;
+	int ret;
+
+	if (intel_fb_needs_pot_stride_remap(fb))
+		size = intel_remapped_info_size(&fb->remapped_view.gtt.remapped);
+	else
+		size = DIV_ROUND_UP_ULL(obj->size, I915_GTT_PAGE_SIZE);
+
+	size = round_up(size * sizeof(gen8_pte_t), I915_GTT_PAGE_SIZE);
+
+	if (HAS_LMEM(i915))
+		dpt_obj = i915_gem_object_create_lmem(i915, size, 0);
+	else
+		dpt_obj = i915_gem_object_create_stolen(i915, size);
+	if (IS_ERR(dpt_obj))
+		return ERR_CAST(dpt_obj);
+
+	ret = i915_gem_object_set_cache_level(dpt_obj, I915_CACHE_NONE);
+	if (ret) {
+		i915_gem_object_put(dpt_obj);
+		return ERR_PTR(ret);
+	}
+
+	dpt = kzalloc(sizeof(*dpt), GFP_KERNEL);
+	if (!dpt) {
+		i915_gem_object_put(dpt_obj);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	vm = &dpt->vm;
+
+	vm->gt = &i915->gt;
+	vm->i915 = i915;
+	vm->dma = i915->drm.dev;
+	vm->total = (size / sizeof(gen8_pte_t)) * I915_GTT_PAGE_SIZE;
+	vm->is_dpt = true;
+
+	i915_address_space_init(vm, VM_CLASS_DPT);
+
+	vm->insert_page = dpt_insert_page;
+	vm->clear_range = dpt_clear_range;
+	vm->insert_entries = dpt_insert_entries;
+	vm->cleanup = dpt_cleanup;
+
+	vm->vma_ops.bind_vma    = dpt_bind_vma;
+	vm->vma_ops.unbind_vma  = dpt_unbind_vma;
+	vm->vma_ops.set_pages   = ggtt_set_pages;
+	vm->vma_ops.clear_pages = clear_pages;
+
+	vm->pte_encode = gen8_ggtt_pte_encode;
+
+	dpt->obj = dpt_obj;
+
+	return &dpt->vm;
+}
+
+void intel_dpt_destroy(struct i915_address_space *vm)
+{
+	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
+
+	i915_vm_close(&dpt->vm);
+}
diff --git a/drivers/gpu/drm/i915/display/intel_dpt.h b/drivers/gpu/drm/i915/display/intel_dpt.h
new file mode 100644
index 000000000000..45142b8f849f
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_dpt.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2021 Intel Corporation
+ */
+
+#ifndef __INTEL_DPT_H__
+#define __INTEL_DPT_H__
+
+struct i915_address_space;
+struct i915_vma;
+struct intel_framebuffer;
+
+void intel_dpt_destroy(struct i915_address_space *vm);
+struct i915_vma *intel_dpt_pin(struct i915_address_space *vm);
+void intel_dpt_unpin(struct i915_address_space *vm);
+struct i915_address_space *
+intel_dpt_create(struct intel_framebuffer *fb);
+
+#endif /* __INTEL_DPT_H__ */
diff --git a/drivers/gpu/drm/i915/display/intel_drrs.c b/drivers/gpu/drm/i915/display/intel_drrs.c
new file mode 100644
index 000000000000..3c7d6bf57948
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_drrs.c
@@ -0,0 +1,485 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright © 2021 Intel Corporation
+ */
+
+#include "i915_drv.h"
+#include "intel_atomic.h"
+#include "intel_de.h"
+#include "intel_display_types.h"
+#include "intel_drrs.h"
+#include "intel_panel.h"
+
+/**
+ * DOC: Display Refresh Rate Switching (DRRS)
+ *
+ * Display Refresh Rate Switching (DRRS) is a power conservation feature
+ * which enables swtching between low and high refresh rates,
+ * dynamically, based on the usage scenario. This feature is applicable
+ * for internal panels.
+ *
+ * Indication that the panel supports DRRS is given by the panel EDID, which
+ * would list multiple refresh rates for one resolution.
+ *
+ * DRRS is of 2 types - static and seamless.
+ * Static DRRS involves changing refresh rate (RR) by doing a full modeset
+ * (may appear as a blink on screen) and is used in dock-undock scenario.
+ * Seamless DRRS involves changing RR without any visual effect to the user
+ * and can be used during normal system usage. This is done by programming
+ * certain registers.
+ *
+ * Support for static/seamless DRRS may be indicated in the VBT based on
+ * inputs from the panel spec.
+ *
+ * DRRS saves power by switching to low RR based on usage scenarios.
+ *
+ * The implementation is based on frontbuffer tracking implementation.  When
+ * there is a disturbance on the screen triggered by user activity or a periodic
+ * system activity, DRRS is disabled (RR is changed to high RR).  When there is
+ * no movement on screen, after a timeout of 1 second, a switch to low RR is
+ * made.
+ *
+ * For integration with frontbuffer tracking code, intel_edp_drrs_invalidate()
+ * and intel_edp_drrs_flush() are called.
+ *
+ * DRRS can be further extended to support other internal panels and also
+ * the scenario of video playback wherein RR is set based on the rate
+ * requested by userspace.
+ */
+
+void
+intel_dp_drrs_compute_config(struct intel_dp *intel_dp,
+			     struct intel_crtc_state *pipe_config,
+			     int output_bpp, bool constant_n)
+{
+	struct intel_connector *intel_connector = intel_dp->attached_connector;
+	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
+	int pixel_clock;
+
+	if (pipe_config->vrr.enable)
+		return;
+
+	/*
+	 * DRRS and PSR can't be enable together, so giving preference to PSR
+	 * as it allows more power-savings by complete shutting down display,
+	 * so to guarantee this, intel_dp_drrs_compute_config() must be called
+	 * after intel_psr_compute_config().
+	 */
+	if (pipe_config->has_psr)
+		return;
+
+	if (!intel_connector->panel.downclock_mode ||
+	    dev_priv->drrs.type != SEAMLESS_DRRS_SUPPORT)
+		return;
+
+	pipe_config->has_drrs = true;
+
+	pixel_clock = intel_connector->panel.downclock_mode->clock;
+	if (pipe_config->splitter.enable)
+		pixel_clock /= pipe_config->splitter.link_count;
+
+	intel_link_compute_m_n(output_bpp, pipe_config->lane_count, pixel_clock,
+			       pipe_config->port_clock, &pipe_config->dp_m2_n2,
+			       constant_n, pipe_config->fec_enable);
+
+	/* FIXME: abstract this better */
+	if (pipe_config->splitter.enable)
+		pipe_config->dp_m2_n2.gmch_m *= pipe_config->splitter.link_count;
+}
+
+/**
+ * intel_dp_set_drrs_state - program registers for RR switch to take effect
+ * @dev_priv: i915 device
+ * @crtc_state: a pointer to the active intel_crtc_state
+ * @refresh_rate: RR to be programmed
+ *
+ * This function gets called when refresh rate (RR) has to be changed from
+ * one frequency to another. Switches can be between high and low RR
+ * supported by the panel or to any other RR based on media playback (in
+ * this case, RR value needs to be passed from user space).
+ *
+ * The caller of this function needs to take a lock on dev_priv->drrs.
+ */
+static void intel_dp_set_drrs_state(struct drm_i915_private *dev_priv,
+				    const struct intel_crtc_state *crtc_state,
+				    int refresh_rate)
+{
+	struct intel_dp *intel_dp = dev_priv->drrs.dp;
+	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	enum drrs_refresh_rate_type index = DRRS_HIGH_RR;
+
+	if (refresh_rate <= 0) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "Refresh rate should be positive non-zero.\n");
+		return;
+	}
+
+	if (intel_dp == NULL) {
+		drm_dbg_kms(&dev_priv->drm, "DRRS not supported.\n");
+		return;
+	}
+
+	if (!crtc) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "DRRS: intel_crtc not initialized\n");
+		return;
+	}
+
+	if (dev_priv->drrs.type < SEAMLESS_DRRS_SUPPORT) {
+		drm_dbg_kms(&dev_priv->drm, "Only Seamless DRRS supported.\n");
+		return;
+	}
+
+	if (drm_mode_vrefresh(intel_dp->attached_connector->panel.downclock_mode) ==
+			refresh_rate)
+		index = DRRS_LOW_RR;
+
+	if (index == dev_priv->drrs.refresh_rate_type) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "DRRS requested for previously set RR...ignoring\n");
+		return;
+	}
+
+	if (!crtc_state->hw.active) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "eDP encoder disabled. CRTC not Active\n");
+		return;
+	}
+
+	if (DISPLAY_VER(dev_priv) >= 8 && !IS_CHERRYVIEW(dev_priv)) {
+		switch (index) {
+		case DRRS_HIGH_RR:
+			intel_dp_set_m_n(crtc_state, M1_N1);
+			break;
+		case DRRS_LOW_RR:
+			intel_dp_set_m_n(crtc_state, M2_N2);
+			break;
+		case DRRS_MAX_RR:
+		default:
+			drm_err(&dev_priv->drm,
+				"Unsupported refreshrate type\n");
+		}
+	} else if (DISPLAY_VER(dev_priv) > 6) {
+		i915_reg_t reg = PIPECONF(crtc_state->cpu_transcoder);
+		u32 val;
+
+		val = intel_de_read(dev_priv, reg);
+		if (index > DRRS_HIGH_RR) {
+			if (IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv))
+				val |= PIPECONF_EDP_RR_MODE_SWITCH_VLV;
+			else
+				val |= PIPECONF_EDP_RR_MODE_SWITCH;
+		} else {
+			if (IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv))
+				val &= ~PIPECONF_EDP_RR_MODE_SWITCH_VLV;
+			else
+				val &= ~PIPECONF_EDP_RR_MODE_SWITCH;
+		}
+		intel_de_write(dev_priv, reg, val);
+	}
+
+	dev_priv->drrs.refresh_rate_type = index;
+
+	drm_dbg_kms(&dev_priv->drm, "eDP Refresh Rate set to : %dHz\n",
+		    refresh_rate);
+}
+
+static void
+intel_edp_drrs_enable_locked(struct intel_dp *intel_dp)
+{
+	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
+
+	dev_priv->drrs.busy_frontbuffer_bits = 0;
+	dev_priv->drrs.dp = intel_dp;
+}
+
+/**
+ * intel_edp_drrs_enable - init drrs struct if supported
+ * @intel_dp: DP struct
+ * @crtc_state: A pointer to the active crtc state.
+ *
+ * Initializes frontbuffer_bits and drrs.dp
+ */
+void intel_edp_drrs_enable(struct intel_dp *intel_dp,
+			   const struct intel_crtc_state *crtc_state)
+{
+	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
+
+	if (!crtc_state->has_drrs)
+		return;
+
+	drm_dbg_kms(&dev_priv->drm, "Enabling DRRS\n");
+
+	mutex_lock(&dev_priv->drrs.mutex);
+
+	if (dev_priv->drrs.dp) {
+		drm_warn(&dev_priv->drm, "DRRS already enabled\n");
+		goto unlock;
+	}
+
+	intel_edp_drrs_enable_locked(intel_dp);
+
+unlock:
+	mutex_unlock(&dev_priv->drrs.mutex);
+}
+
+static void
+intel_edp_drrs_disable_locked(struct intel_dp *intel_dp,
+			      const struct intel_crtc_state *crtc_state)
+{
+	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
+
+	if (dev_priv->drrs.refresh_rate_type == DRRS_LOW_RR) {
+		int refresh;
+
+		refresh = drm_mode_vrefresh(intel_dp->attached_connector->panel.fixed_mode);
+		intel_dp_set_drrs_state(dev_priv, crtc_state, refresh);
+	}
+
+	dev_priv->drrs.dp = NULL;
+}
+
+/**
+ * intel_edp_drrs_disable - Disable DRRS
+ * @intel_dp: DP struct
+ * @old_crtc_state: Pointer to old crtc_state.
+ *
+ */
+void intel_edp_drrs_disable(struct intel_dp *intel_dp,
+			    const struct intel_crtc_state *old_crtc_state)
+{
+	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
+
+	if (!old_crtc_state->has_drrs)
+		return;
+
+	mutex_lock(&dev_priv->drrs.mutex);
+	if (!dev_priv->drrs.dp) {
+		mutex_unlock(&dev_priv->drrs.mutex);
+		return;
+	}
+
+	intel_edp_drrs_disable_locked(intel_dp, old_crtc_state);
+	mutex_unlock(&dev_priv->drrs.mutex);
+
+	cancel_delayed_work_sync(&dev_priv->drrs.work);
+}
+
+/**
+ * intel_edp_drrs_update - Update DRRS state
+ * @intel_dp: Intel DP
+ * @crtc_state: new CRTC state
+ *
+ * This function will update DRRS states, disabling or enabling DRRS when
+ * executing fastsets. For full modeset, intel_edp_drrs_disable() and
+ * intel_edp_drrs_enable() should be called instead.
+ */
+void
+intel_edp_drrs_update(struct intel_dp *intel_dp,
+		      const struct intel_crtc_state *crtc_state)
+{
+	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
+
+	if (dev_priv->drrs.type != SEAMLESS_DRRS_SUPPORT)
+		return;
+
+	mutex_lock(&dev_priv->drrs.mutex);
+
+	/* New state matches current one? */
+	if (crtc_state->has_drrs == !!dev_priv->drrs.dp)
+		goto unlock;
+
+	if (crtc_state->has_drrs)
+		intel_edp_drrs_enable_locked(intel_dp);
+	else
+		intel_edp_drrs_disable_locked(intel_dp, crtc_state);
+
+unlock:
+	mutex_unlock(&dev_priv->drrs.mutex);
+}
+
+static void intel_edp_drrs_downclock_work(struct work_struct *work)
+{
+	struct drm_i915_private *dev_priv =
+		container_of(work, typeof(*dev_priv), drrs.work.work);
+	struct intel_dp *intel_dp;
+
+	mutex_lock(&dev_priv->drrs.mutex);
+
+	intel_dp = dev_priv->drrs.dp;
+
+	if (!intel_dp)
+		goto unlock;
+
+	/*
+	 * The delayed work can race with an invalidate hence we need to
+	 * recheck.
+	 */
+
+	if (dev_priv->drrs.busy_frontbuffer_bits)
+		goto unlock;
+
+	if (dev_priv->drrs.refresh_rate_type != DRRS_LOW_RR) {
+		struct drm_crtc *crtc = dp_to_dig_port(intel_dp)->base.base.crtc;
+
+		intel_dp_set_drrs_state(dev_priv, to_intel_crtc(crtc)->config,
+					drm_mode_vrefresh(intel_dp->attached_connector->panel.downclock_mode));
+	}
+
+unlock:
+	mutex_unlock(&dev_priv->drrs.mutex);
+}
+
+/**
+ * intel_edp_drrs_invalidate - Disable Idleness DRRS
+ * @dev_priv: i915 device
+ * @frontbuffer_bits: frontbuffer plane tracking bits
+ *
+ * This function gets called everytime rendering on the given planes start.
+ * Hence DRRS needs to be Upclocked, i.e. (LOW_RR -> HIGH_RR).
+ *
+ * Dirty frontbuffers relevant to DRRS are tracked in busy_frontbuffer_bits.
+ */
+void intel_edp_drrs_invalidate(struct drm_i915_private *dev_priv,
+			       unsigned int frontbuffer_bits)
+{
+	struct intel_dp *intel_dp;
+	struct drm_crtc *crtc;
+	enum pipe pipe;
+
+	if (dev_priv->drrs.type == DRRS_NOT_SUPPORTED)
+		return;
+
+	cancel_delayed_work(&dev_priv->drrs.work);
+
+	mutex_lock(&dev_priv->drrs.mutex);
+
+	intel_dp = dev_priv->drrs.dp;
+	if (!intel_dp) {
+		mutex_unlock(&dev_priv->drrs.mutex);
+		return;
+	}
+
+	crtc = dp_to_dig_port(intel_dp)->base.base.crtc;
+	pipe = to_intel_crtc(crtc)->pipe;
+
+	frontbuffer_bits &= INTEL_FRONTBUFFER_ALL_MASK(pipe);
+	dev_priv->drrs.busy_frontbuffer_bits |= frontbuffer_bits;
+
+	/* invalidate means busy screen hence upclock */
+	if (frontbuffer_bits && dev_priv->drrs.refresh_rate_type == DRRS_LOW_RR)
+		intel_dp_set_drrs_state(dev_priv, to_intel_crtc(crtc)->config,
+					drm_mode_vrefresh(intel_dp->attached_connector->panel.fixed_mode));
+
+	mutex_unlock(&dev_priv->drrs.mutex);
+}
+
+/**
+ * intel_edp_drrs_flush - Restart Idleness DRRS
+ * @dev_priv: i915 device
+ * @frontbuffer_bits: frontbuffer plane tracking bits
+ *
+ * This function gets called every time rendering on the given planes has
+ * completed or flip on a crtc is completed. So DRRS should be upclocked
+ * (LOW_RR -> HIGH_RR). And also Idleness detection should be started again,
+ * if no other planes are dirty.
+ *
+ * Dirty frontbuffers relevant to DRRS are tracked in busy_frontbuffer_bits.
+ */
+void intel_edp_drrs_flush(struct drm_i915_private *dev_priv,
+			  unsigned int frontbuffer_bits)
+{
+	struct intel_dp *intel_dp;
+	struct drm_crtc *crtc;
+	enum pipe pipe;
+
+	if (dev_priv->drrs.type == DRRS_NOT_SUPPORTED)
+		return;
+
+	cancel_delayed_work(&dev_priv->drrs.work);
+
+	mutex_lock(&dev_priv->drrs.mutex);
+
+	intel_dp = dev_priv->drrs.dp;
+	if (!intel_dp) {
+		mutex_unlock(&dev_priv->drrs.mutex);
+		return;
+	}
+
+	crtc = dp_to_dig_port(intel_dp)->base.base.crtc;
+	pipe = to_intel_crtc(crtc)->pipe;
+
+	frontbuffer_bits &= INTEL_FRONTBUFFER_ALL_MASK(pipe);
+	dev_priv->drrs.busy_frontbuffer_bits &= ~frontbuffer_bits;
+
+	/* flush means busy screen hence upclock */
+	if (frontbuffer_bits && dev_priv->drrs.refresh_rate_type == DRRS_LOW_RR)
+		intel_dp_set_drrs_state(dev_priv, to_intel_crtc(crtc)->config,
+					drm_mode_vrefresh(intel_dp->attached_connector->panel.fixed_mode));
+
+	/*
+	 * flush also means no more activity hence schedule downclock, if all
+	 * other fbs are quiescent too
+	 */
+	if (!dev_priv->drrs.busy_frontbuffer_bits)
+		schedule_delayed_work(&dev_priv->drrs.work,
+				      msecs_to_jiffies(1000));
+	mutex_unlock(&dev_priv->drrs.mutex);
+}
+
+/**
+ * intel_dp_drrs_init - Init basic DRRS work and mutex.
+ * @connector: eDP connector
+ * @fixed_mode: preferred mode of panel
+ *
+ * This function is  called only once at driver load to initialize basic
+ * DRRS stuff.
+ *
+ * Returns:
+ * Downclock mode if panel supports it, else return NULL.
+ * DRRS support is determined by the presence of downclock mode (apart
+ * from VBT setting).
+ */
+struct drm_display_mode *
+intel_dp_drrs_init(struct intel_connector *connector,
+		   struct drm_display_mode *fixed_mode)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_encoder *encoder = connector->encoder;
+	struct drm_display_mode *downclock_mode = NULL;
+
+	INIT_DELAYED_WORK(&dev_priv->drrs.work, intel_edp_drrs_downclock_work);
+	mutex_init(&dev_priv->drrs.mutex);
+
+	if (DISPLAY_VER(dev_priv) <= 6) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "DRRS supported for Gen7 and above\n");
+		return NULL;
+	}
+
+	if ((DISPLAY_VER(dev_priv) < 8 && !HAS_GMCH(dev_priv)) &&
+	    encoder->port != PORT_A) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "DRRS only supported on eDP port A\n");
+		return NULL;
+	}
+
+	if (dev_priv->vbt.drrs_type != SEAMLESS_DRRS_SUPPORT) {
+		drm_dbg_kms(&dev_priv->drm, "VBT doesn't support DRRS\n");
+		return NULL;
+	}
+
+	downclock_mode = intel_panel_edid_downclock_mode(connector, fixed_mode);
+	if (!downclock_mode) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "Downclock mode is not found. DRRS not supported\n");
+		return NULL;
+	}
+
+	dev_priv->drrs.type = dev_priv->vbt.drrs_type;
+
+	dev_priv->drrs.refresh_rate_type = DRRS_HIGH_RR;
+	drm_dbg_kms(&dev_priv->drm,
+		    "seamless DRRS supported for eDP panel.\n");
+	return downclock_mode;
+}
diff --git a/drivers/gpu/drm/i915/display/intel_drrs.h b/drivers/gpu/drm/i915/display/intel_drrs.h
new file mode 100644
index 000000000000..ffa175b4cf4f
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_drrs.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2021 Intel Corporation
+ */
+
+#ifndef __INTEL_DRRS_H__
+#define __INTEL_DRRS_H__
+
+#include <linux/types.h>
+
+struct drm_i915_private;
+struct intel_crtc_state;
+struct intel_connector;
+struct intel_dp;
+
+void intel_edp_drrs_enable(struct intel_dp *intel_dp,
+			   const struct intel_crtc_state *crtc_state);
+void intel_edp_drrs_disable(struct intel_dp *intel_dp,
+			    const struct intel_crtc_state *crtc_state);
+void intel_edp_drrs_update(struct intel_dp *intel_dp,
+			   const struct intel_crtc_state *crtc_state);
+void intel_edp_drrs_invalidate(struct drm_i915_private *dev_priv,
+			       unsigned int frontbuffer_bits);
+void intel_edp_drrs_flush(struct drm_i915_private *dev_priv,
+			  unsigned int frontbuffer_bits);
+void intel_dp_drrs_compute_config(struct intel_dp *intel_dp,
+				  struct intel_crtc_state *pipe_config,
+				  int output_bpp, bool constant_n);
+struct drm_display_mode *intel_dp_drrs_init(struct intel_connector *connector,
+					    struct drm_display_mode *fixed_mode);
+
+#endif /* __INTEL_DRRS_H__ */
diff --git a/drivers/gpu/drm/i915/display/intel_frontbuffer.c b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
index 8e75debcce1a..e4834d84ce5e 100644
--- a/drivers/gpu/drm/i915/display/intel_frontbuffer.c
+++ b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
@@ -62,6 +62,7 @@
 #include "intel_display_types.h"
 #include "intel_fbc.h"
 #include "intel_frontbuffer.h"
+#include "intel_drrs.h"
 #include "intel_psr.h"
 
 /**
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index 8d6c38a62201..9053cea3395a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -162,7 +162,6 @@ int i915_gem_object_pin_pages_unlocked(struct drm_i915_gem_object *obj)
 /* Immediately discard the backing storage */
 void i915_gem_object_truncate(struct drm_i915_gem_object *obj)
 {
-	drm_gem_free_mmap_offset(&obj->base);
 	if (obj->ops->truncate)
 		obj->ops->truncate(obj);
 }
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
diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 93b40c245f00..5d90d2eb0019 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -11,6 +11,7 @@
 #include <linux/of_platform.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 
 #include <video/mipi_display.h>
 #include <video/videomode.h>
@@ -980,8 +981,10 @@ static int mtk_dsi_bind(struct device *dev, struct device *master, void *data)
 	struct mtk_dsi *dsi = dev_get_drvdata(dev);
 
 	ret = mtk_dsi_encoder_init(drm, dsi);
+	if (ret)
+		return ret;
 
-	return ret;
+	return device_reset_optional(dev);
 }
 
 static void mtk_dsi_unbind(struct device *dev, struct device *master,
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_kms.c b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
index 89dd618d78f3..988bc4fbd78d 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -361,7 +361,17 @@ static void mxsfb_crtc_atomic_enable(struct drm_crtc *crtc,
 		bridge_state =
 			drm_atomic_get_new_bridge_state(state,
 							mxsfb->bridge);
-		bus_format = bridge_state->input_bus_cfg.format;
+		if (!bridge_state)
+			bus_format = MEDIA_BUS_FMT_FIXED;
+		else
+			bus_format = bridge_state->input_bus_cfg.format;
+
+		if (bus_format == MEDIA_BUS_FMT_FIXED) {
+			dev_warn_once(drm->dev,
+				      "Bridge does not provide bus format, assuming MEDIA_BUS_FMT_RGB888_1X24.\n"
+				      "Please fix bridge driver by handling atomic_get_input_bus_fmts.\n");
+			bus_format = MEDIA_BUS_FMT_RGB888_1X24;
+		}
 	}
 
 	/* If there is no bridge, use bus format from connector */
diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
index b64d93da651d..5e2b0175df36 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -658,8 +658,10 @@ int sun8i_hdmi_phy_get(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
 		return -EPROBE_DEFER;
 
 	phy = platform_get_drvdata(pdev);
-	if (!phy)
+	if (!phy) {
+		put_device(&pdev->dev);
 		return -EPROBE_DEFER;
+	}
 
 	hdmi->phy = phy;
 
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index f7a4eaf3a2e0..561bb27f42b1 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -88,6 +88,44 @@ static void amd_stop_all_sensor_v2(struct amd_mp2_dev *privdata)
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
@@ -192,6 +230,8 @@ static void amd_mp2_pci_remove(void *privdata)
 	struct amd_mp2_dev *mp2 = privdata;
 	amd_sfh_hid_client_deinit(privdata);
 	mp2->mp2_ops->stop_all(mp2);
+	pci_intx(mp2->pdev, false);
+	amd_sfh_clear_intr(mp2);
 }
 
 static const struct amd_mp2_ops amd_sfh_ops_v2 = {
@@ -199,6 +239,8 @@ static const struct amd_mp2_ops amd_sfh_ops_v2 = {
 	.stop = amd_stop_sensor_v2,
 	.stop_all = amd_stop_all_sensor_v2,
 	.response = amd_sfh_wait_response_v2,
+	.clear_intr = amd_sfh_clear_intr_v2,
+	.init_intr = amd_sfh_irq_init_v2,
 };
 
 static const struct amd_mp2_ops amd_sfh_ops = {
@@ -224,6 +266,14 @@ static void mp2_select_ops(struct amd_mp2_dev *privdata)
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
@@ -257,9 +307,20 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 
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
@@ -287,6 +348,9 @@ static int __maybe_unused amd_mp2_pci_resume(struct device *dev)
 		}
 	}
 
+	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
+	amd_sfh_clear_intr(mp2);
+
 	return 0;
 }
 
@@ -310,6 +374,9 @@ static int __maybe_unused amd_mp2_pci_suspend(struct device *dev)
 		}
 	}
 
+	cancel_delayed_work_sync(&cl_data->work_buffer);
+	amd_sfh_clear_intr(mp2);
+
 	return 0;
 }
 
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index 9c9119227135..00fc083dc123 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -140,5 +140,7 @@ struct amd_mp2_ops {
 	 void (*stop)(struct amd_mp2_dev *privdata, u16 sensor_idx);
 	 void (*stop_all)(struct amd_mp2_dev *privdata);
 	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
+	 void (*clear_intr)(struct amd_mp2_dev *privdata);
+	 int (*init_intr)(struct amd_mp2_dev *privdata);
 };
 #endif
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index fa57d05badf7..f48d3534e020 100644
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
index 3d33c0c06cbb..3172987a9ebd 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -991,6 +991,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x0cd: map_key_clear(KEY_PLAYPAUSE);	break;
 		case 0x0cf: map_key_clear(KEY_VOICECOMMAND);	break;
 
+		case 0x0d8: map_key_clear(KEY_DICTATE);		break;
 		case 0x0d9: map_key_clear(KEY_EMOJI_PICKER);	break;
 
 		case 0x0e0: map_abs_clear(ABS_VOLUME);		break;
@@ -1082,6 +1083,8 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 
 		case 0x29d: map_key_clear(KEY_KBD_LAYOUT_NEXT);	break;
 
+		case 0x2a2: map_key_clear(KEY_ALL_APPLICATIONS);	break;
+
 		case 0x2c7: map_key_clear(KEY_KBDINPUTASSIST_PREV);		break;
 		case 0x2c8: map_key_clear(KEY_KBDINPUTASSIST_NEXT);		break;
 		case 0x2c9: map_key_clear(KEY_KBDINPUTASSIST_PREVGROUP);		break;
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index e17790fe35a7..fea403431f22 100644
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
@@ -677,7 +677,7 @@ config I2C_IMG
 
 config I2C_IMX
 	tristate "IMX I2C interface"
-	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE
+	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE || COMPILE_TEST
 	select I2C_SLAVE
 	help
 	  Say Y here if you want to use the IIC bus controller on
@@ -921,7 +921,7 @@ config I2C_QCOM_GENI
 
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
diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index c3b4c677b442..dfe18dcd008d 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -343,7 +343,8 @@ struct bus_type i3c_bus_type = {
 static enum i3c_addr_slot_status
 i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
 {
-	int status, bitpos = addr * 2;
+	unsigned long status;
+	int bitpos = addr * 2;
 
 	if (addr > I2C_MAX_ADDR)
 		return I3C_ADDR_SLOT_RSVD;
diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 03a368da51b9..51a8608203de 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -793,6 +793,10 @@ static int dw_i3c_master_daa(struct i3c_master_controller *m)
 		return -ENOMEM;
 
 	pos = dw_i3c_master_get_free_pos(master);
+	if (pos < 0) {
+		dw_i3c_master_free_xfer(xfer);
+		return pos;
+	}
 	cmd = &xfer->cmds[0];
 	cmd->cmd_hi = 0x1;
 	cmd->cmd_lo = COMMAND_PORT_DEV_COUNT(master->maxdevs - pos) |
diff --git a/drivers/i3c/master/mipi-i3c-hci/dat_v1.c b/drivers/i3c/master/mipi-i3c-hci/dat_v1.c
index 783e551a2c85..97bb49ff5b53 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dat_v1.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dat_v1.c
@@ -160,9 +160,7 @@ static int hci_dat_v1_get_index(struct i3c_hci *hci, u8 dev_addr)
 	unsigned int dat_idx;
 	u32 dat_w0;
 
-	for (dat_idx = find_first_bit(hci->DAT_data, hci->DAT_entries);
-	     dat_idx < hci->DAT_entries;
-	     dat_idx = find_next_bit(hci->DAT_data, hci->DAT_entries, dat_idx)) {
+	for_each_set_bit(dat_idx, hci->DAT_data, hci->DAT_entries) {
 		dat_w0 = dat_w0_read(dat_idx);
 		if (FIELD_GET(DAT_0_DYNAMIC_ADDRESS, dat_w0) == dev_addr)
 			return dat_idx;
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
index e75650e98c9e..e402915cc0c0 100644
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
diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 83e685557a19..cfc943423241 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -131,7 +131,8 @@ static void titsc_step_config(struct titsc *ts_dev)
 	u32 stepenable;
 
 	config = STEPCONFIG_MODE_HWSYNC |
-			STEPCONFIG_AVG_16 | ts_dev->bit_xp;
+			STEPCONFIG_AVG_16 | ts_dev->bit_xp |
+			STEPCONFIG_INM_ADCREFM;
 	switch (ts_dev->wires) {
 	case 4:
 		config |= STEPCONFIG_INP(ts_dev->inp_yp) | ts_dev->bit_xn;
@@ -195,7 +196,10 @@ static void titsc_step_config(struct titsc *ts_dev)
 			STEPCONFIG_OPENDLY);
 
 	end_step++;
-	config |= STEPCONFIG_INP(ts_dev->inp_yn);
+	config = STEPCONFIG_MODE_HWSYNC |
+			STEPCONFIG_AVG_16 | ts_dev->bit_yp |
+			ts_dev->bit_xn | STEPCONFIG_INM_ADCREFM |
+			STEPCONFIG_INP(ts_dev->inp_yn);
 	titsc_writel(ts_dev, REG_STEPCONFIG(end_step), config);
 	titsc_writel(ts_dev, REG_STEPDELAY(end_step),
 			STEPCONFIG_OPENDLY);
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
index 8394c2787ff8..b6e0bf186cf5 100644
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
index 72cad85e5e5f..204ed33c56dc 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -655,6 +655,16 @@ static int __init alloc_command_buffer(struct amd_iommu *iommu)
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
index 1722bb161841..f46eb7397021 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -742,7 +742,8 @@ amd_iommu_set_pci_msi_domain(struct device *dev, struct amd_iommu *iommu) { }
 #endif /* !CONFIG_IRQ_REMAP */
 
 #define AMD_IOMMU_INT_MASK	\
-	(MMIO_STATUS_EVT_INT_MASK | \
+	(MMIO_STATUS_EVT_OVERFLOW_INT_MASK | \
+	 MMIO_STATUS_EVT_INT_MASK | \
 	 MMIO_STATUS_PPR_INT_MASK | \
 	 MMIO_STATUS_GALOG_INT_MASK)
 
@@ -752,7 +753,7 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data)
 	u32 status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 
 	while (status & AMD_IOMMU_INT_MASK) {
-		/* Enable EVT and PPR and GA interrupts again */
+		/* Enable interrupt sources again */
 		writel(AMD_IOMMU_INT_MASK,
 			iommu->mmio_base + MMIO_STATUS_OFFSET);
 
@@ -773,6 +774,11 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data)
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
index 78f8c8e6803e..0b3076144beb 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2651,7 +2651,7 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
 	/* PASID table is mandatory for a PCI device in scalable mode. */
-	if (dev && dev_is_pci(dev) && sm_supported(iommu)) {
+	if (sm_supported(iommu) && !dev_is_real_dma_subdevice(dev)) {
 		ret = intel_pasid_alloc_table(dev);
 		if (ret) {
 			dev_err(dev, "PASID table allocation failed\n");
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 0a281833f611..abbdaeb4bf8f 100644
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
diff --git a/drivers/mtd/spi-nor/xilinx.c b/drivers/mtd/spi-nor/xilinx.c
index 1138bdbf4199..75dd13a39040 100644
--- a/drivers/mtd/spi-nor/xilinx.c
+++ b/drivers/mtd/spi-nor/xilinx.c
@@ -66,7 +66,8 @@ static int xilinx_nor_setup(struct spi_nor *nor,
 		/* Flash in Power of 2 mode */
 		nor->page_size = (nor->page_size == 264) ? 256 : 512;
 		nor->mtd.writebufsize = nor->page_size;
-		nor->mtd.size = 8 * nor->page_size * nor->info->n_sectors;
+		nor->params->size = 8 * nor->page_size * nor->info->n_sectors;
+		nor->mtd.size = nor->params->size;
 		nor->mtd.erasesize = 8 * nor->page_size;
 	} else {
 		/* Flash in Default addressing mode */
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 3c8f665c1558..28dccbc0e8d8 100644
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
index 24627ab14626..cd4e7f356e48 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1794,7 +1794,7 @@ static int es58x_open(struct net_device *netdev)
 	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
 	int ret;
 
-	if (atomic_inc_return(&es58x_dev->opened_channel_cnt) == 1) {
+	if (!es58x_dev->opened_channel_cnt) {
 		ret = es58x_alloc_rx_urbs(es58x_dev);
 		if (ret)
 			return ret;
@@ -1812,12 +1812,13 @@ static int es58x_open(struct net_device *netdev)
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
@@ -1852,7 +1853,8 @@ static int es58x_stop(struct net_device *netdev)
 
 	es58x_flush_pending_tx_msg(netdev);
 
-	if (atomic_dec_and_test(&es58x_dev->opened_channel_cnt))
+	es58x_dev->opened_channel_cnt--;
+	if (!es58x_dev->opened_channel_cnt)
 		es58x_free_urbs(es58x_dev);
 
 	return 0;
@@ -2221,7 +2223,6 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
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
index 8dcdd5162ecf..d68d698f2606 100644
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
 
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index de1d34a1f1e4..05e4e75c0107 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -10,6 +10,7 @@
 #include <linux/pcs-lynx.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
+#include <linux/of_mdio.h>
 #include "felix.h"
 
 #define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
@@ -1110,7 +1111,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
 
 	/* Needed in order to initialize the bus mutex lock */
-	rc = mdiobus_register(bus);
+	rc = devm_of_mdiobus_register(dev, bus, NULL);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
@@ -1162,7 +1163,8 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 		mdio_device_free(pcs->mdio);
 		lynx_pcs_destroy(pcs);
 	}
-	mdiobus_unregister(felix->imdio);
+
+	/* mdiobus_unregister and mdiobus_free handled by devres */
 }
 
 static const struct felix_info seville_info_vsc9953 = {
diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index 4786f0504691..899c8a2a34b6 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -168,7 +168,7 @@ config SUNLANCE
 
 config AMD_XGBE
 	tristate "AMD 10GbE Ethernet driver"
-	depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM
+	depends on (OF_ADDRESS || ACPI || PCI) && HAS_IOMEM
 	depends on X86 || ARM64 || COMPILE_TEST
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select BITREVERSE
diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index 92a79c4ffa2c..0a67612af228 100644
--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -26,7 +26,7 @@ config ARC_EMAC_CORE
 config ARC_EMAC
 	tristate "ARC EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET
+	depends on OF_IRQ
 	depends on ARC || COMPILE_TEST
 	help
 	  On some legacy ARC (Synopsys) FPGA boards such as ARCAngel4/ML50x
@@ -36,7 +36,7 @@ config ARC_EMAC
 config EMAC_ROCKCHIP
 	tristate "Rockchip EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET && REGULATOR
+	depends on OF_IRQ && REGULATOR
 	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	help
 	  Support for Rockchip RK3036/RK3066/RK3188 EMAC ethernet controllers.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f92bea4faa01..ce36ee5a250f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8617,6 +8617,9 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 	vnic->uc_filter_count = 1;
 
 	vnic->rx_mask = 0;
+	if (test_bit(BNXT_STATE_HALF_OPEN, &bp->state))
+		goto skip_rx_mask;
+
 	if (bp->dev->flags & IFF_BROADCAST)
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_BCAST;
 
@@ -8637,6 +8640,7 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 	if (rc)
 		goto err_out;
 
+skip_rx_mask:
 	rc = bnxt_hwrm_set_coal(bp);
 	if (rc)
 		netdev_warn(bp->dev, "HWRM set coalescing failure rc: %x\n",
@@ -10302,8 +10306,10 @@ int bnxt_half_open_nic(struct bnxt *bp)
 		netdev_err(bp->dev, "bnxt_alloc_mem err: %x\n", rc);
 		goto half_open_err;
 	}
+	set_bit(BNXT_STATE_HALF_OPEN, &bp->state);
 	rc = bnxt_init_nic(bp, true);
 	if (rc) {
+		clear_bit(BNXT_STATE_HALF_OPEN, &bp->state);
 		netdev_err(bp->dev, "bnxt_init_nic err: %x\n", rc);
 		goto half_open_err;
 	}
@@ -10324,6 +10330,7 @@ void bnxt_half_close_nic(struct bnxt *bp)
 	bnxt_hwrm_resource_free(bp, false, true);
 	bnxt_free_skbs(bp);
 	bnxt_free_mem(bp, true);
+	clear_bit(BNXT_STATE_HALF_OPEN, &bp->state);
 }
 
 static void bnxt_reenable_sriov(struct bnxt *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 0a5137c1f6d4..ca6fdf03e586 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1840,6 +1840,7 @@ struct bnxt {
 #define BNXT_STATE_DRV_REGISTERED	7
 #define BNXT_STATE_PCI_CHANNEL_IO_FROZEN	8
 #define BNXT_STATE_NAPI_DISABLED	9
+#define BNXT_STATE_HALF_OPEN		15	/* For offline ethtool tests */
 
 #define BNXT_NO_FW_ACCESS(bp)					\
 	(test_bit(BNXT_STATE_FW_FATAL_COND, &(bp)->state) ||	\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index da3ee22e8a16..af7de9ee66cf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3409,7 +3409,7 @@ static int bnxt_run_loopback(struct bnxt *bp)
 	if (!skb)
 		return -ENOMEM;
 	data = skb_put(skb, pkt_size);
-	eth_broadcast_addr(data);
+	ether_addr_copy(&data[i], bp->dev->dev_addr);
 	i += ETH_ALEN;
 	ether_addr_copy(&data[i], bp->dev->dev_addr);
 	i += ETH_ALEN;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index 7ff31d1026fb..e0d34e64fc6c 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -3678,6 +3678,8 @@ int t3_prep_adapter(struct adapter *adapter, const struct adapter_info *ai,
 	    MAC_STATS_ACCUM_SECS : (MAC_STATS_ACCUM_SECS * 10);
 	adapter->params.pci.vpd_cap_addr =
 	    pci_find_capability(adapter->pdev, PCI_CAP_ID_VPD);
+	if (!adapter->params.pci.vpd_cap_addr)
+		return -ENODEV;
 	ret = get_vpd_params(adapter, &adapter->params.vpd);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/ethernet/ezchip/Kconfig b/drivers/net/ethernet/ezchip/Kconfig
index 38aa824efb25..9241b9b1c7a3 100644
--- a/drivers/net/ethernet/ezchip/Kconfig
+++ b/drivers/net/ethernet/ezchip/Kconfig
@@ -18,7 +18,7 @@ if NET_VENDOR_EZCHIP
 
 config EZCHIP_NPS_MANAGEMENT_ENET
 	tristate "EZchip NPS management enet support"
-	depends on OF_IRQ && OF_NET
+	depends on OF_IRQ
 	depends on HAS_IOMEM
 	help
 	  Simple LAN device for debug or management purposes.
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 629d8ed08fc6..97431969a488 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -450,6 +450,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		skb_set_hash(skb, be32_to_cpu(rx_desc->rss_hash),
 			     gve_rss_type(rx_desc->flags_seq));
 
+	skb_record_rx_queue(skb, rx->q_num);
 	if (skb_is_nonlinear(skb))
 		napi_gro_frags(napi);
 	else
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 14a729ba737a..404921418f42 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -108,6 +108,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter);
 static int send_query_phys_parms(struct ibmvnic_adapter *adapter);
 static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 					 struct ibmvnic_sub_crq_queue *tx_scrq);
+static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -1245,7 +1246,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
 	if (rc) {
 		ibmvnic_napi_disable(adapter);
-		release_resources(adapter);
+		ibmvnic_disable_irqs(adapter);
 		return rc;
 	}
 
@@ -1295,7 +1296,6 @@ static int ibmvnic_open(struct net_device *netdev)
 		rc = init_resources(adapter);
 		if (rc) {
 			netdev_err(netdev, "failed to initialize resources\n");
-			release_resources(adapter);
 			goto out;
 		}
 	}
@@ -1312,6 +1312,11 @@ static int ibmvnic_open(struct net_device *netdev)
 		adapter->state = VNIC_OPEN;
 		rc = 0;
 	}
+
+	if (rc) {
+		release_resources(adapter);
+	}
+
 	return rc;
 }
 
@@ -2552,12 +2557,23 @@ static void __ibmvnic_delayed_reset(struct work_struct *work)
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
 
@@ -2600,10 +2616,9 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
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
@@ -5138,9 +5153,9 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			}
 
 			if (!completion_done(&adapter->init_done)) {
-				complete(&adapter->init_done);
 				if (!adapter->init_done_rc)
 					adapter->init_done_rc = -EAGAIN;
+				complete(&adapter->init_done);
 			}
 
 			break;
@@ -5163,6 +5178,13 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
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
@@ -5627,12 +5649,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
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
@@ -5645,6 +5661,14 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
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
 	return 0;
 
 ibmvnic_register_fail:
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
index af2029bb43e3..ce48e630fe55 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6992,8 +6992,21 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
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
@@ -7015,6 +7028,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct e1000_hw *hw = &adapter->hw;
+	u16 phy_data;
 	int rc;
 
 	/* Introduce S0ix implementation */
@@ -7025,6 +7040,17 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
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
index 0ae6da2992d0..9a122aea6979 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -178,6 +178,7 @@ enum iavf_state_t {
 	__IAVF_INIT_VERSION_CHECK,	/* aq msg sent, awaiting reply */
 	__IAVF_INIT_GET_RESOURCES,	/* aq msg sent, awaiting reply */
 	__IAVF_INIT_SW,		/* got resources, setting up structs */
+	__IAVF_INIT_FAILED,	/* init failed, restarting procedure */
 	__IAVF_RESETTING,		/* in reset */
 	__IAVF_COMM_FAILED,		/* communication with PF failed */
 	/* Below here, watchdog is running */
@@ -187,6 +188,10 @@ enum iavf_state_t {
 	__IAVF_RUNNING,		/* opened, working */
 };
 
+enum iavf_critical_section_t {
+	__IAVF_IN_REMOVE_TASK,	/* device being removed */
+};
+
 #define IAVF_CLOUD_FIELD_OMAC		0x01
 #define IAVF_CLOUD_FIELD_IMAC		0x02
 #define IAVF_CLOUD_FIELD_IVLAN	0x04
@@ -226,14 +231,12 @@ struct iavf_adapter {
 	struct work_struct reset_task;
 	struct work_struct adminq_task;
 	struct delayed_work client_task;
-	struct delayed_work init_task;
 	wait_queue_head_t down_waitqueue;
 	struct iavf_q_vector *q_vectors;
 	struct list_head vlan_filter_list;
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
@@ -314,6 +318,7 @@ struct iavf_adapter {
 	struct iavf_hw hw; /* defined in iavf_type.h */
 
 	enum iavf_state_t state;
+	enum iavf_state_t last_state;
 	unsigned long crit_section;
 
 	struct delayed_work watchdog_task;
@@ -395,6 +400,51 @@ struct iavf_device {
 extern char iavf_driver_name[];
 extern struct workqueue_struct *iavf_wq;
 
+static inline const char *iavf_state_str(enum iavf_state_t state)
+{
+	switch (state) {
+	case __IAVF_STARTUP:
+		return "__IAVF_STARTUP";
+	case __IAVF_REMOVE:
+		return "__IAVF_REMOVE";
+	case __IAVF_INIT_VERSION_CHECK:
+		return "__IAVF_INIT_VERSION_CHECK";
+	case __IAVF_INIT_GET_RESOURCES:
+		return "__IAVF_INIT_GET_RESOURCES";
+	case __IAVF_INIT_SW:
+		return "__IAVF_INIT_SW";
+	case __IAVF_INIT_FAILED:
+		return "__IAVF_INIT_FAILED";
+	case __IAVF_RESETTING:
+		return "__IAVF_RESETTING";
+	case __IAVF_COMM_FAILED:
+		return "__IAVF_COMM_FAILED";
+	case __IAVF_DOWN:
+		return "__IAVF_DOWN";
+	case __IAVF_DOWN_PENDING:
+		return "__IAVF_DOWN_PENDING";
+	case __IAVF_TESTING:
+		return "__IAVF_TESTING";
+	case __IAVF_RUNNING:
+		return "__IAVF_RUNNING";
+	default:
+		return "__IAVF_UNKNOWN_STATE";
+	}
+}
+
+static inline void iavf_change_state(struct iavf_adapter *adapter,
+				     enum iavf_state_t state)
+{
+	if (adapter->state != state) {
+		adapter->last_state = adapter->state;
+		adapter->state = state;
+	}
+	dev_dbg(&adapter->pdev->dev,
+		"state transition from:%s to:%s\n",
+		iavf_state_str(adapter->last_state),
+		iavf_state_str(adapter->state));
+}
+
 int iavf_up(struct iavf_adapter *adapter);
 void iavf_down(struct iavf_adapter *adapter);
 int iavf_process_config(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 6502c8056a8e..711e8c7f62de 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -14,7 +14,7 @@
 static int iavf_setup_all_tx_resources(struct iavf_adapter *adapter);
 static int iavf_setup_all_rx_resources(struct iavf_adapter *adapter);
 static int iavf_close(struct net_device *netdev);
-static int iavf_init_get_resources(struct iavf_adapter *adapter);
+static void iavf_init_get_resources(struct iavf_adapter *adapter);
 static int iavf_check_reset_complete(struct iavf_hw *hw);
 
 char iavf_driver_name[] = "iavf";
@@ -51,6 +51,15 @@ MODULE_LICENSE("GPL v2");
 static const struct net_device_ops iavf_netdev_ops;
 struct workqueue_struct *iavf_wq;
 
+/**
+ * iavf_pdev_to_adapter - go from pci_dev to adapter
+ * @pdev: pci_dev pointer
+ */
+static struct iavf_adapter *iavf_pdev_to_adapter(struct pci_dev *pdev)
+{
+	return netdev_priv(pci_get_drvdata(pdev));
+}
+
 /**
  * iavf_allocate_dma_mem_d - OS specific memory alloc for shared code
  * @hw:   pointer to the HW structure
@@ -293,8 +302,9 @@ static irqreturn_t iavf_msix_aq(int irq, void *data)
 	rd32(hw, IAVF_VFINT_ICR01);
 	rd32(hw, IAVF_VFINT_ICR0_ENA1);
 
-	/* schedule work on the private workqueue */
-	queue_work(iavf_wq, &adapter->adminq_task);
+	if (adapter->state != __IAVF_REMOVE)
+		/* schedule work on the private workqueue */
+		queue_work(iavf_wq, &adapter->adminq_task);
 
 	return IRQ_HANDLED;
 }
@@ -990,7 +1000,7 @@ static void iavf_configure(struct iavf_adapter *adapter)
  **/
 static void iavf_up_complete(struct iavf_adapter *adapter)
 {
-	adapter->state = __IAVF_RUNNING;
+	iavf_change_state(adapter, __IAVF_RUNNING);
 	clear_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 
 	iavf_napi_enable_all(adapter);
@@ -1063,8 +1073,7 @@ void iavf_down(struct iavf_adapter *adapter)
 		rss->state = IAVF_ADV_RSS_DEL_REQUEST;
 	spin_unlock_bh(&adapter->adv_rss_lock);
 
-	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) &&
-	    adapter->state != __IAVF_RESETTING) {
+	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)) {
 		/* cancel any current operation */
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		/* Schedule operations to close down the HW. Don't wait
@@ -1722,9 +1731,9 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
  *
  * Function process __IAVF_STARTUP driver state.
  * When success the state is changed to __IAVF_INIT_VERSION_CHECK
- * when fails it returns -EAGAIN
+ * when fails the state is changed to __IAVF_INIT_FAILED
  **/
-static int iavf_startup(struct iavf_adapter *adapter)
+static void iavf_startup(struct iavf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct iavf_hw *hw = &adapter->hw;
@@ -1763,9 +1772,10 @@ static int iavf_startup(struct iavf_adapter *adapter)
 		iavf_shutdown_adminq(hw);
 		goto err;
 	}
-	adapter->state = __IAVF_INIT_VERSION_CHECK;
+	iavf_change_state(adapter, __IAVF_INIT_VERSION_CHECK);
+	return;
 err:
-	return err;
+	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
 
 /**
@@ -1774,9 +1784,9 @@ static int iavf_startup(struct iavf_adapter *adapter)
  *
  * Function process __IAVF_INIT_VERSION_CHECK driver state.
  * When success the state is changed to __IAVF_INIT_GET_RESOURCES
- * when fails it returns -EAGAIN
+ * when fails the state is changed to __IAVF_INIT_FAILED
  **/
-static int iavf_init_version_check(struct iavf_adapter *adapter)
+static void iavf_init_version_check(struct iavf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct iavf_hw *hw = &adapter->hw;
@@ -1787,7 +1797,7 @@ static int iavf_init_version_check(struct iavf_adapter *adapter)
 	if (!iavf_asq_done(hw)) {
 		dev_err(&pdev->dev, "Admin queue command never completed\n");
 		iavf_shutdown_adminq(hw);
-		adapter->state = __IAVF_STARTUP;
+		iavf_change_state(adapter, __IAVF_STARTUP);
 		goto err;
 	}
 
@@ -1810,10 +1820,10 @@ static int iavf_init_version_check(struct iavf_adapter *adapter)
 			err);
 		goto err;
 	}
-	adapter->state = __IAVF_INIT_GET_RESOURCES;
-
+	iavf_change_state(adapter, __IAVF_INIT_GET_RESOURCES);
+	return;
 err:
-	return err;
+	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
 
 /**
@@ -1823,9 +1833,9 @@ static int iavf_init_version_check(struct iavf_adapter *adapter)
  * Function process __IAVF_INIT_GET_RESOURCES driver state and
  * finishes driver initialization procedure.
  * When success the state is changed to __IAVF_DOWN
- * when fails it returns -EAGAIN
+ * when fails the state is changed to __IAVF_INIT_FAILED
  **/
-static int iavf_init_get_resources(struct iavf_adapter *adapter)
+static void iavf_init_get_resources(struct iavf_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
@@ -1853,7 +1863,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 		 */
 		iavf_shutdown_adminq(hw);
 		dev_err(&pdev->dev, "Unable to get VF config due to PF error condition, not retrying\n");
-		return 0;
+		return;
 	}
 	if (err) {
 		dev_err(&pdev->dev, "Unable to get VF config (%d)\n", err);
@@ -1927,7 +1937,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 	if (netdev->features & NETIF_F_GRO)
 		dev_info(&pdev->dev, "GRO is enabled\n");
 
-	adapter->state = __IAVF_DOWN;
+	iavf_change_state(adapter, __IAVF_DOWN);
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 	rtnl_unlock();
 
@@ -1945,7 +1955,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 	else
 		iavf_init_rss(adapter);
 
-	return err;
+	return;
 err_mem:
 	iavf_free_rss(adapter);
 err_register:
@@ -1956,7 +1966,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 	kfree(adapter->vf_res);
 	adapter->vf_res = NULL;
 err:
-	return err;
+	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
 
 /**
@@ -1971,14 +1981,80 @@ static void iavf_watchdog_task(struct work_struct *work)
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
-		adapter->state = __IAVF_COMM_FAILED;
+		iavf_change_state(adapter, __IAVF_COMM_FAILED);
+
+	if (adapter->flags & IAVF_FLAG_RESET_NEEDED) {
+		adapter->aq_required = 0;
+		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+		mutex_unlock(&adapter->crit_lock);
+		queue_work(iavf_wq, &adapter->reset_task);
+		return;
+	}
 
 	switch (adapter->state) {
+	case __IAVF_STARTUP:
+		iavf_startup(adapter);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(30));
+		return;
+	case __IAVF_INIT_VERSION_CHECK:
+		iavf_init_version_check(adapter);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(30));
+		return;
+	case __IAVF_INIT_GET_RESOURCES:
+		iavf_init_get_resources(adapter);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(1));
+		return;
+	case __IAVF_INIT_FAILED:
+		if (test_bit(__IAVF_IN_REMOVE_TASK,
+			     &adapter->crit_section)) {
+			/* Do not update the state and do not reschedule
+			 * watchdog task, iavf_remove should handle this state
+			 * as it can loop forever
+			 */
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
+		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
+			dev_err(&adapter->pdev->dev,
+				"Failed to communicate with PF; waiting before retry\n");
+			adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
+			iavf_shutdown_adminq(hw);
+			mutex_unlock(&adapter->crit_lock);
+			queue_delayed_work(iavf_wq,
+					   &adapter->watchdog_task, (5 * HZ));
+			return;
+		}
+		/* Try again from failed step*/
+		iavf_change_state(adapter, adapter->last_state);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ);
+		return;
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
@@ -1986,23 +2062,20 @@ static void iavf_watchdog_task(struct work_struct *work)
 			/* A chance for redemption! */
 			dev_err(&adapter->pdev->dev,
 				"Hardware came out of reset. Attempting reinit.\n");
-			adapter->state = __IAVF_STARTUP;
-			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
-			queue_delayed_work(iavf_wq, &adapter->init_task, 10);
-			mutex_unlock(&adapter->crit_lock);
-			/* Don't reschedule the watchdog, since we've restarted
-			 * the init task. When init_task contacts the PF and
+			/* When init task contacts the PF and
 			 * gets everything set up again, it'll restart the
 			 * watchdog for us. Down, boy. Sit. Stay. Woof.
 			 */
-			return;
+			iavf_change_state(adapter, __IAVF_STARTUP);
+			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
-		goto watchdog_done;
+		return;
 	case __IAVF_RESETTING:
 		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
@@ -2025,15 +2098,16 @@ static void iavf_watchdog_task(struct work_struct *work)
 			    adapter->state == __IAVF_RUNNING)
 				iavf_request_stats(adapter);
 		}
+		if (adapter->state == __IAVF_RUNNING)
+			iavf_detect_recover_hung(&adapter->vsi);
 		break;
 	case __IAVF_REMOVE:
+	default:
 		mutex_unlock(&adapter->crit_lock);
 		return;
-	default:
-		goto restart_watchdog;
 	}
 
-		/* check for hw reset */
+	/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
@@ -2041,22 +2115,22 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
 		queue_work(iavf_wq, &adapter->reset_task);
-		goto watchdog_done;
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq,
+				   &adapter->watchdog_task, HZ * 2);
+		return;
 	}
 
 	schedule_delayed_work(&adapter->client_task, msecs_to_jiffies(5));
-watchdog_done:
-	if (adapter->state == __IAVF_RUNNING ||
-	    adapter->state == __IAVF_COMM_FAILED)
-		iavf_detect_recover_hung(&adapter->vsi);
 	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
+	if (adapter->state >= __IAVF_DOWN)
+		queue_work(iavf_wq, &adapter->adminq_task);
 	if (adapter->aq_required)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(20));
 	else
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
-	queue_work(iavf_wq, &adapter->adminq_task);
 }
 
 static void iavf_disable_vf(struct iavf_adapter *adapter)
@@ -2115,7 +2189,7 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	adapter->netdev->flags &= ~IFF_UP;
 	mutex_unlock(&adapter->crit_lock);
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
-	adapter->state = __IAVF_DOWN;
+	iavf_change_state(adapter, __IAVF_DOWN);
 	wake_up(&adapter->down_waitqueue);
 	dev_info(&adapter->pdev->dev, "Reset task did not complete, VF disabled\n");
 }
@@ -2145,13 +2219,13 @@ static void iavf_reset_task(struct work_struct *work)
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
@@ -2206,6 +2280,7 @@ static void iavf_reset_task(struct work_struct *work)
 			reg_val);
 		iavf_disable_vf(adapter);
 		mutex_unlock(&adapter->client_lock);
+		mutex_unlock(&adapter->crit_lock);
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
 
@@ -2214,8 +2289,7 @@ static void iavf_reset_task(struct work_struct *work)
 	 * ndo_open() returning, so we can't assume it means all our open
 	 * tasks have finished, since we're not holding the rtnl_lock here.
 	 */
-	running = ((adapter->state == __IAVF_RUNNING) ||
-		   (adapter->state == __IAVF_RESETTING));
+	running = adapter->state == __IAVF_RUNNING;
 
 	if (running) {
 		netif_carrier_off(netdev);
@@ -2225,7 +2299,7 @@ static void iavf_reset_task(struct work_struct *work)
 	}
 	iavf_irq_disable(adapter);
 
-	adapter->state = __IAVF_RESETTING;
+	iavf_change_state(adapter, __IAVF_RESETTING);
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
 
 	/* free the Tx/Rx rings and descriptors, might be better to just
@@ -2319,11 +2393,14 @@ static void iavf_reset_task(struct work_struct *work)
 
 		iavf_configure(adapter);
 
+		/* iavf_up_complete() will switch device back
+		 * to __IAVF_RUNNING
+		 */
 		iavf_up_complete(adapter);
 
 		iavf_irq_enable(adapter, true);
 	} else {
-		adapter->state = __IAVF_DOWN;
+		iavf_change_state(adapter, __IAVF_DOWN);
 		wake_up(&adapter->down_waitqueue);
 	}
 	mutex_unlock(&adapter->client_lock);
@@ -2333,6 +2410,8 @@ static void iavf_reset_task(struct work_struct *work)
 reset_err:
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
+	if (running)
+		iavf_change_state(adapter, __IAVF_RUNNING);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 	iavf_close(netdev);
 }
@@ -2355,13 +2434,19 @@ static void iavf_adminq_task(struct work_struct *work)
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
@@ -2377,6 +2462,18 @@ static void iavf_adminq_task(struct work_struct *work)
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
@@ -3259,6 +3356,13 @@ static int iavf_open(struct net_device *netdev)
 		goto err_unlock;
 	}
 
+	if (adapter->state == __IAVF_RUNNING &&
+	    !test_bit(__IAVF_VSI_DOWN, adapter->vsi.state)) {
+		dev_dbg(&adapter->pdev->dev, "VF is already open.\n");
+		err = 0;
+		goto err_unlock;
+	}
+
 	/* allocate transmit descriptors */
 	err = iavf_setup_all_tx_resources(adapter);
 	if (err)
@@ -3322,18 +3426,19 @@ static int iavf_close(struct net_device *netdev)
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
 		adapter->flags |= IAVF_FLAG_CLIENT_NEEDS_CLOSE;
 
 	iavf_down(adapter);
-	adapter->state = __IAVF_DOWN_PENDING;
+	iavf_change_state(adapter, __IAVF_DOWN_PENDING);
 	iavf_free_traffic_irqs(adapter);
 
 	mutex_unlock(&adapter->crit_lock);
@@ -3373,8 +3478,11 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
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
@@ -3672,72 +3780,14 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	return 0;
 }
 
-/**
- * iavf_init_task - worker thread to perform delayed initialization
- * @work: pointer to work_struct containing our data
- *
- * This task completes the work that was begun in probe. Due to the nature
- * of VF-PF communications, we may need to wait tens of milliseconds to get
- * responses back from the PF. Rather than busy-wait in probe and bog down the
- * whole system, we'll do it in a task so we can sleep.
- * This task only runs during driver init. Once we've established
- * communications with the PF driver and set up our netdev, the watchdog
- * takes over.
- **/
-static void iavf_init_task(struct work_struct *work)
-{
-	struct iavf_adapter *adapter = container_of(work,
-						    struct iavf_adapter,
-						    init_task.work);
-	struct iavf_hw *hw = &adapter->hw;
-
-	if (iavf_lock_timeout(&adapter->crit_lock, 5000)) {
-		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
-		return;
-	}
-	switch (adapter->state) {
-	case __IAVF_STARTUP:
-		if (iavf_startup(adapter) < 0)
-			goto init_failed;
-		break;
-	case __IAVF_INIT_VERSION_CHECK:
-		if (iavf_init_version_check(adapter) < 0)
-			goto init_failed;
-		break;
-	case __IAVF_INIT_GET_RESOURCES:
-		if (iavf_init_get_resources(adapter) < 0)
-			goto init_failed;
-		goto out;
-	default:
-		goto init_failed;
-	}
-
-	queue_delayed_work(iavf_wq, &adapter->init_task,
-			   msecs_to_jiffies(30));
-	goto out;
-init_failed:
-	if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
-		dev_err(&adapter->pdev->dev,
-			"Failed to communicate with PF; waiting before retry\n");
-		adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
-		iavf_shutdown_adminq(hw);
-		adapter->state = __IAVF_STARTUP;
-		queue_delayed_work(iavf_wq, &adapter->init_task, HZ * 5);
-		goto out;
-	}
-	queue_delayed_work(iavf_wq, &adapter->init_task, HZ);
-out:
-	mutex_unlock(&adapter->crit_lock);
-}
-
 /**
  * iavf_shutdown - Shutdown the device in preparation for a reboot
  * @pdev: pci device structure
  **/
 static void iavf_shutdown(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
+	struct net_device *netdev = adapter->netdev;
 
 	netif_device_detach(netdev);
 
@@ -3747,7 +3797,7 @@ static void iavf_shutdown(struct pci_dev *pdev)
 	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
 		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 	/* Prevent the watchdog from running. */
-	adapter->state = __IAVF_REMOVE;
+	iavf_change_state(adapter, __IAVF_REMOVE);
 	adapter->aq_required = 0;
 	mutex_unlock(&adapter->crit_lock);
 
@@ -3820,7 +3870,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw->back = adapter;
 
 	adapter->msg_enable = BIT(DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
-	adapter->state = __IAVF_STARTUP;
+	iavf_change_state(adapter, __IAVF_STARTUP);
 
 	/* Call save state here because it relies on the adapter struct. */
 	pci_save_state(pdev);
@@ -3845,7 +3895,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	mutex_init(&adapter->crit_lock);
 	mutex_init(&adapter->client_lock);
-	mutex_init(&adapter->remove_lock);
 	mutex_init(&hw->aq.asq_mutex);
 	mutex_init(&hw->aq.arq_mutex);
 
@@ -3864,8 +3913,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_WORK(&adapter->adminq_task, iavf_adminq_task);
 	INIT_DELAYED_WORK(&adapter->watchdog_task, iavf_watchdog_task);
 	INIT_DELAYED_WORK(&adapter->client_task, iavf_client_task);
-	INIT_DELAYED_WORK(&adapter->init_task, iavf_init_task);
-	queue_delayed_work(iavf_wq, &adapter->init_task,
+	queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 			   msecs_to_jiffies(5 * (pdev->devfn & 0x07)));
 
 	/* Setup the wait queue for indicating transition to down status */
@@ -3922,10 +3970,11 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 static int __maybe_unused iavf_resume(struct device *dev_d)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_d);
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_adapter *adapter;
 	u32 err;
 
+	adapter = iavf_pdev_to_adapter(pdev);
+
 	pci_set_master(pdev);
 
 	rtnl_lock();
@@ -3944,7 +3993,7 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 
 	queue_work(iavf_wq, &adapter->reset_task);
 
-	netif_device_attach(netdev);
+	netif_device_attach(adapter->netdev);
 
 	return err;
 }
@@ -3960,8 +4009,8 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
  **/
 static void iavf_remove(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
+	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
 	struct iavf_adv_rss *rss, *rsstmp;
@@ -3969,14 +4018,30 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_cloud_filter *cf, *cftmp;
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
-	/* Indicate we are in remove and not to run reset_task */
-	mutex_lock(&adapter->remove_lock);
-	cancel_delayed_work_sync(&adapter->init_task);
-	cancel_work_sync(&adapter->reset_task);
-	cancel_delayed_work_sync(&adapter->client_task);
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
+	cancel_delayed_work_sync(&adapter->watchdog_task);
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
@@ -3985,6 +4050,10 @@ static void iavf_remove(struct pci_dev *pdev)
 				 err);
 	}
 
+	mutex_lock(&adapter->crit_lock);
+	dev_info(&adapter->pdev->dev, "Remove device\n");
+	iavf_change_state(adapter, __IAVF_REMOVE);
+
 	iavf_request_reset(adapter);
 	msleep(50);
 	/* If the FW isn't responding, kick it once, but only once. */
@@ -3992,24 +4061,24 @@ static void iavf_remove(struct pci_dev *pdev)
 		iavf_request_reset(adapter);
 		msleep(50);
 	}
-	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 
+	iavf_misc_irq_disable(adapter);
 	/* Shut down all the garbage mashers on the detention level */
-	adapter->state = __IAVF_REMOVE;
+	cancel_work_sync(&adapter->reset_task);
+	cancel_delayed_work_sync(&adapter->watchdog_task);
+	cancel_work_sync(&adapter->adminq_task);
+	cancel_delayed_work_sync(&adapter->client_task);
+
 	adapter->aq_required = 0;
 	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
+
 	iavf_free_all_tx_resources(adapter);
 	iavf_free_all_rx_resources(adapter);
-	iavf_misc_irq_disable(adapter);
 	iavf_free_misc_irq(adapter);
+
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_q_vectors(adapter);
 
-	cancel_delayed_work_sync(&adapter->watchdog_task);
-
-	cancel_work_sync(&adapter->adminq_task);
-
 	iavf_free_rss(adapter);
 
 	if (hw->aq.asq.count)
@@ -4021,8 +4090,6 @@ static void iavf_remove(struct pci_dev *pdev)
 	mutex_destroy(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 	mutex_destroy(&adapter->crit_lock);
-	mutex_unlock(&adapter->remove_lock);
-	mutex_destroy(&adapter->remove_lock);
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 08302ab35d68..8a1c293b8c7a 100644
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
@@ -1776,7 +1764,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		iavf_free_all_tx_resources(adapter);
 		iavf_free_all_rx_resources(adapter);
 		if (adapter->state == __IAVF_DOWN_PENDING) {
-			adapter->state = __IAVF_DOWN;
+			iavf_change_state(adapter, __IAVF_DOWN);
 			wake_up(&adapter->down_waitqueue);
 		}
 		break;
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
index b1d22e4d5ec9..e3bf024717ed 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -388,12 +388,14 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
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
 
diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
index 63bf01d28f0c..04345b929d8e 100644
--- a/drivers/net/ethernet/litex/Kconfig
+++ b/drivers/net/ethernet/litex/Kconfig
@@ -17,7 +17,7 @@ if NET_VENDOR_LITEX
 
 config LITEX_LITEETH
 	tristate "LiteX Ethernet support"
-	depends on OF_NET
+	depends on OF && HAS_IOMEM
 	help
 	  If you wish to compile a kernel for hardware with a LiteX LiteEth
 	  device then you should answer Y to this.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 34a089b71e55..6b335139abe7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -838,9 +838,6 @@ void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
 	if (!cgx)
 		return;
 
-	if (is_dev_rpm(cgx))
-		return;
-
 	if (enable) {
 		/* Enable inbound PTP timestamping */
 		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
@@ -1545,9 +1542,11 @@ static int cgx_lmac_exit(struct cgx *cgx)
 static void cgx_populate_features(struct cgx *cgx)
 {
 	if (is_dev_rpm(cgx))
-		cgx->hw_features =  (RVU_MAC_RPM | RVU_LMAC_FEAT_FC);
+		cgx->hw_features = (RVU_LMAC_FEAT_DMACF | RVU_MAC_RPM |
+				    RVU_LMAC_FEAT_FC | RVU_LMAC_FEAT_PTP);
 	else
-		cgx->hw_features = (RVU_LMAC_FEAT_FC | RVU_LMAC_FEAT_PTP);
+		cgx->hw_features = (RVU_LMAC_FEAT_FC  | RVU_LMAC_FEAT_HIGIG2 |
+				    RVU_LMAC_FEAT_PTP | RVU_LMAC_FEAT_DMACF);
 }
 
 static struct mac_ops	cgx_mac_ops    = {
@@ -1571,6 +1570,9 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_get_pause_frm_status =	cgx_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		cgx_lmac_enadis_pause_frm,
 	.mac_pause_frm_config =		cgx_lmac_pause_frm_config,
+	.mac_enadis_ptp_config =	cgx_lmac_ptp_config,
+	.mac_rx_tx_enable =		cgx_lmac_rx_tx_enable,
+	.mac_tx_enable =		cgx_lmac_tx_enable,
 };
 
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index c38306b3384a..b33e7d1d0851 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -102,6 +102,14 @@ struct mac_ops {
 	void			(*mac_pause_frm_config)(void  *cgxd,
 							int lmac_id,
 							bool enable);
+
+	/* Enable/Disable Inbound PTP */
+	void			(*mac_enadis_ptp_config)(void  *cgxd,
+							 int lmac_id,
+							 bool enable);
+
+	int			(*mac_rx_tx_enable)(void *cgxd, int lmac_id, bool enable);
+	int			(*mac_tx_enable)(void *cgxd, int lmac_id, bool enable);
 };
 
 struct cgx {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 26ad71842b3b..c6643c7db1fc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -84,7 +84,7 @@ struct mbox_msghdr {
 #define OTX2_MBOX_REQ_SIG (0xdead)
 #define OTX2_MBOX_RSP_SIG (0xbeef)
 	u16 sig;         /* Signature, for validating corrupted msgs */
-#define OTX2_MBOX_VERSION (0x0009)
+#define OTX2_MBOX_VERSION (0x000a)
 	u16 ver;         /* Version of msg's structure for this ID */
 	u16 next_msgoff; /* Offset of next msg within mailbox region */
 	int rc;          /* Msg process'ed response code */
@@ -154,23 +154,23 @@ M(CGX_PTP_RX_ENABLE,	0x20C, cgx_ptp_rx_enable, msg_req, msg_rsp)	\
 M(CGX_PTP_RX_DISABLE,	0x20D, cgx_ptp_rx_disable, msg_req, msg_rsp)	\
 M(CGX_CFG_PAUSE_FRM,	0x20E, cgx_cfg_pause_frm, cgx_pause_frm_cfg,	\
 			       cgx_pause_frm_cfg)			\
-M(CGX_FEC_SET,		0x210, cgx_set_fec_param, fec_mode, fec_mode)   \
-M(CGX_FEC_STATS,	0x211, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
-M(CGX_GET_PHY_FEC_STATS, 0x212, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
-M(CGX_FW_DATA_GET,	0x213, cgx_get_aux_link_info, msg_req, cgx_fw_data) \
-M(CGX_SET_LINK_MODE,	0x214, cgx_set_link_mode, cgx_set_link_mode_req,\
-			       cgx_set_link_mode_rsp)	\
-M(CGX_FEATURES_GET,	0x215, cgx_features_get, msg_req,		\
-			       cgx_features_info_msg)			\
-M(RPM_STATS,		0x216, rpm_stats, msg_req, rpm_stats_rsp)	\
-M(CGX_MAC_ADDR_ADD,	0x217, cgx_mac_addr_add, cgx_mac_addr_add_req,    \
-			       cgx_mac_addr_add_rsp)		\
-M(CGX_MAC_ADDR_DEL,	0x218, cgx_mac_addr_del, cgx_mac_addr_del_req,    \
+M(CGX_FW_DATA_GET,	0x20F, cgx_get_aux_link_info, msg_req, cgx_fw_data) \
+M(CGX_FEC_SET,		0x210, cgx_set_fec_param, fec_mode, fec_mode) \
+M(CGX_MAC_ADDR_ADD,	0x211, cgx_mac_addr_add, cgx_mac_addr_add_req,    \
+				cgx_mac_addr_add_rsp)		\
+M(CGX_MAC_ADDR_DEL,	0x212, cgx_mac_addr_del, cgx_mac_addr_del_req,    \
 			       msg_rsp)		\
-M(CGX_MAC_MAX_ENTRIES_GET, 0x219, cgx_mac_max_entries_get, msg_req,    \
+M(CGX_MAC_MAX_ENTRIES_GET, 0x213, cgx_mac_max_entries_get, msg_req,    \
 				  cgx_max_dmac_entries_get_rsp)		\
-M(CGX_MAC_ADDR_RESET,	0x21A, cgx_mac_addr_reset, msg_req, msg_rsp)	\
-M(CGX_MAC_ADDR_UPDATE,	0x21B, cgx_mac_addr_update, cgx_mac_addr_update_req, \
+M(CGX_FEC_STATS,	0x217, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
+M(CGX_SET_LINK_MODE,	0x218, cgx_set_link_mode, cgx_set_link_mode_req,\
+			       cgx_set_link_mode_rsp)	\
+M(CGX_GET_PHY_FEC_STATS, 0x219, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
+M(CGX_FEATURES_GET,	0x21B, cgx_features_get, msg_req,		\
+			       cgx_features_info_msg)			\
+M(RPM_STATS,		0x21C, rpm_stats, msg_req, rpm_stats_rsp)	\
+M(CGX_MAC_ADDR_RESET,	0x21D, cgx_mac_addr_reset, msg_req, msg_rsp)	\
+M(CGX_MAC_ADDR_UPDATE,	0x21E, cgx_mac_addr_update, cgx_mac_addr_update_req, \
 			       msg_rsp)					\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
@@ -229,6 +229,8 @@ M(NPC_DELETE_FLOW,	  0x600e, npc_delete_flow,			\
 M(NPC_MCAM_READ_ENTRY,	  0x600f, npc_mcam_read_entry,			\
 				  npc_mcam_read_entry_req,		\
 				  npc_mcam_read_entry_rsp)		\
+M(NPC_SET_PKIND,        0x6010,   npc_set_pkind,                        \
+				  npc_set_pkind, msg_rsp)               \
 M(NPC_MCAM_READ_BASE_RULE, 0x6011, npc_read_base_steer_rule,            \
 				   msg_req, npc_mcam_read_base_rule_rsp)  \
 M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
@@ -575,10 +577,13 @@ struct cgx_mac_addr_update_req {
 };
 
 #define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
-#define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precision time protocol */
-#define RVU_MAC_VERSION			BIT_ULL(2)
-#define RVU_MAC_CGX			BIT_ULL(3)
-#define RVU_MAC_RPM			BIT_ULL(4)
+#define	RVU_LMAC_FEAT_HIGIG2		BIT_ULL(1)
+			/* flow control from physical link higig2 messages */
+#define RVU_LMAC_FEAT_PTP		BIT_ULL(2) /* precison time protocol */
+#define RVU_LMAC_FEAT_DMACF		BIT_ULL(3) /* DMAC FILTER */
+#define RVU_MAC_VERSION			BIT_ULL(4)
+#define RVU_MAC_CGX			BIT_ULL(5)
+#define RVU_MAC_RPM			BIT_ULL(6)
 
 struct cgx_features_info_msg {
 	struct mbox_msghdr hdr;
@@ -593,6 +598,22 @@ struct rpm_stats_rsp {
 	u64 tx_stats[RPM_TX_STATS_COUNT];
 };
 
+struct npc_set_pkind {
+	struct mbox_msghdr hdr;
+#define OTX2_PRIV_FLAGS_DEFAULT  BIT_ULL(0)
+#define OTX2_PRIV_FLAGS_CUSTOM   BIT_ULL(63)
+	u64 mode;
+#define PKIND_TX		BIT_ULL(0)
+#define PKIND_RX		BIT_ULL(1)
+	u8 dir;
+	u8 pkind; /* valid only in case custom flag */
+	u8 var_len_off; /* Offset of custom header length field.
+			 * Valid only for pkind NPC_RX_CUSTOM_PRE_L2_PKIND
+			 */
+	u8 var_len_off_mask; /* Mask for length with in offset */
+	u8 shift_dir; /* shift direction to get length of the header at var_len_off */
+};
+
 /* NPA mbox message formats */
 
 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3a819b24accc..6e1192f52608 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -31,9 +31,9 @@ enum npc_kpu_la_ltype {
 	NPC_LT_LA_HIGIG2_ETHER,
 	NPC_LT_LA_IH_NIX_HIGIG2_ETHER,
 	NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-	NPC_LT_LA_CH_LEN_90B_ETHER,
 	NPC_LT_LA_CPT_HDR,
 	NPC_LT_LA_CUSTOM_L2_24B_ETHER,
+	NPC_LT_LA_CUSTOM_PRE_L2_ETHER,
 	NPC_LT_LA_CUSTOM0 = 0xE,
 	NPC_LT_LA_CUSTOM1 = 0xF,
 };
@@ -148,10 +148,11 @@ enum npc_kpu_lh_ltype {
  * Software assigns pkind for each incoming port such as CGX
  * Ethernet interfaces, LBK interfaces, etc.
  */
-#define NPC_UNRESERVED_PKIND_COUNT NPC_RX_VLAN_EXDSA_PKIND
+#define NPC_UNRESERVED_PKIND_COUNT NPC_RX_CUSTOM_PRE_L2_PKIND
 
 enum npc_pkind_type {
 	NPC_RX_LBK_PKIND = 0ULL,
+	NPC_RX_CUSTOM_PRE_L2_PKIND = 55ULL,
 	NPC_RX_VLAN_EXDSA_PKIND = 56ULL,
 	NPC_RX_CHLEN24B_PKIND = 57ULL,
 	NPC_RX_CPT_HDR_PKIND,
@@ -162,6 +163,10 @@ enum npc_pkind_type {
 	NPC_TX_DEF_PKIND,	/* NIX-TX PKIND */
 };
 
+enum npc_interface_type {
+	NPC_INTF_MODE_DEF,
+};
+
 /* list of known and supported fields in packet header and
  * fields present in key structure.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 588822a0cf21..695123e32ba8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -176,9 +176,8 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU1_EXDSA,
 	NPC_S_KPU1_HIGIG2,
 	NPC_S_KPU1_IH_NIX_HIGIG2,
-	NPC_S_KPU1_CUSTOM_L2_90B,
+	NPC_S_KPU1_CUSTOM_PRE_L2,
 	NPC_S_KPU1_CPT_HDR,
-	NPC_S_KPU1_CUSTOM_L2_24B,
 	NPC_S_KPU1_VLAN_EXDSA,
 	NPC_S_KPU2_CTAG,
 	NPC_S_KPU2_CTAG2,
@@ -187,7 +186,8 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU2_ETAG,
 	NPC_S_KPU2_PREHEADER,
 	NPC_S_KPU2_EXDSA,
-	NPC_S_KPU2_NGIO,
+	NPC_S_KPU2_CPT_CTAG,
+	NPC_S_KPU2_CPT_QINQ,
 	NPC_S_KPU3_CTAG,
 	NPC_S_KPU3_STAG,
 	NPC_S_KPU3_QINQ,
@@ -212,6 +212,7 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU5_NSH,
 	NPC_S_KPU5_CPT_IP,
 	NPC_S_KPU5_CPT_IP6,
+	NPC_S_KPU5_NGIO,
 	NPC_S_KPU6_IP6_EXT,
 	NPC_S_KPU6_IP6_HOP_DEST,
 	NPC_S_KPU6_IP6_ROUT,
@@ -979,8 +980,8 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		12, 16, 20, 0, 0,
-		NPC_S_KPU1_ETHER, 0, 0,
-		NPC_LID_LA, NPC_LT_NA,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0, 1,
+		NPC_LID_LA, NPC_LT_LA_CUSTOM_PRE_L2_ETHER,
 		0,
 		0, 0, 0, 0,
 
@@ -996,27 +997,27 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		36, 40, 44, 0, 0,
-		NPC_S_KPU1_CUSTOM_L2_24B, 0, 0,
-		NPC_LID_LA, NPC_LT_NA,
+		12, 16, 20, 0, 0,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 24, 1,
+		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
 		0,
 		0, 0, 0, 0,
 
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		40, 54, 58, 0, 0,
-		NPC_S_KPU1_CPT_HDR, 0, 0,
+		12, 16, 20, 0, 0,
+		NPC_S_KPU1_CPT_HDR, 40, 0,
 		NPC_LID_LA, NPC_LT_NA,
 		0,
-		0, 0, 0, 0,
+		7, 7, 0, 0,
 
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		102, 106, 110, 0, 0,
-		NPC_S_KPU1_CUSTOM_L2_90B, 0, 0,
-		NPC_LID_LA, NPC_LT_NA,
+		12, 16, 20, 0, 0,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 90, 1,
+		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
 		0,
 		0, 0, 0, 0,
 
@@ -1116,15 +1117,6 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
-	{
-		NPC_S_KPU1_ETHER, 0xff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		NPC_ETYPE_NGIO,
-		0xffff,
-		0x0000,
-		0x0000,
-	},
 	{
 		NPC_S_KPU1_ETHER, 0xff,
 		NPC_ETYPE_CTAG,
@@ -1711,7 +1703,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_IP,
 		0xffff,
 		0x0000,
@@ -1720,7 +1712,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_IP6,
 		0xffff,
 		0x0000,
@@ -1729,7 +1721,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_ARP,
 		0xffff,
 		0x0000,
@@ -1738,7 +1730,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_RARP,
 		0xffff,
 		0x0000,
@@ -1747,7 +1739,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_PTP,
 		0xffff,
 		0x0000,
@@ -1756,7 +1748,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_FCOE,
 		0xffff,
 		0x0000,
@@ -1765,7 +1757,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_CTAG,
 		0xffff,
 		NPC_ETYPE_CTAG,
@@ -1774,7 +1766,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_CTAG,
 		0xffff,
 		0x0000,
@@ -1783,7 +1775,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_SBTAG,
 		0xffff,
 		0x0000,
@@ -1792,7 +1784,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_QINQ,
 		0xffff,
 		0x0000,
@@ -1801,7 +1793,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_ETAG,
 		0xffff,
 		0x0000,
@@ -1810,7 +1802,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_MPLSU,
 		0xffff,
 		0x0000,
@@ -1819,7 +1811,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_MPLSM,
 		0xffff,
 		0x0000,
@@ -1828,7 +1820,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_NSH,
 		0xffff,
 		0x0000,
@@ -1837,7 +1829,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		0x0000,
 		0x0000,
 		0x0000,
@@ -1847,150 +1839,24 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
 		NPC_ETYPE_IP,
 		0xffff,
 		0x0000,
 		0x0000,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		NPC_ETYPE_IP6,
-		0xffff,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		NPC_ETYPE_QINQ,
-		0xffff,
 		0x0000,
 		0x0000,
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		0x0000,
-		0x0000,
-		NPC_ETYPE_IP,
-		0xffff,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		0x0000,
-		0x0000,
 		NPC_ETYPE_IP6,
 		0xffff,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		0x0000,
 		0x0000,
-		NPC_ETYPE_CTAG,
-		0xffff,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
 		0x0000,
-		0xffff,
 		0x0000,
 		0x0000,
-		NPC_ETYPE_QINQ,
-		0xffff,
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_IP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_IP6,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_ARP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_RARP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_PTP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_FCOE,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
 		NPC_ETYPE_CTAG,
 		0xffff,
 		0x0000,
@@ -1999,16 +1865,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_SBTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
+		NPC_S_KPU1_CPT_HDR, 0xff,
 		NPC_ETYPE_QINQ,
 		0xffff,
 		0x0000,
@@ -2016,51 +1873,6 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_ETAG,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_MPLSU,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_MPLSM,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_NSH,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
 	{
 		NPC_S_KPU1_VLAN_EXDSA, 0xff,
 		NPC_ETYPE_CTAG,
@@ -2165,6 +1977,15 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
+	{
+		NPC_S_KPU2_CTAG, 0xff,
+		NPC_ETYPE_NGIO,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
 	{
 		NPC_S_KPU2_CTAG, 0xff,
 		NPC_ETYPE_PPPOE,
@@ -3057,11 +2878,38 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU2_NGIO, 0xff,
+		NPC_S_KPU2_CPT_CTAG, 0xff,
+		NPC_ETYPE_IP,
+		0xffff,
 		0x0000,
 		0x0000,
 		0x0000,
 		0x0000,
+	},
+	{
+		NPC_S_KPU2_CPT_CTAG, 0xff,
+		NPC_ETYPE_IP6,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU2_CPT_QINQ, 0xff,
+		NPC_ETYPE_CTAG,
+		0xffff,
+		NPC_ETYPE_IP,
+		0xffff,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU2_CPT_QINQ, 0xff,
+		NPC_ETYPE_CTAG,
+		0xffff,
+		NPC_ETYPE_IP6,
+		0xffff,
 		0x0000,
 		0x0000,
 	},
@@ -5348,6 +5196,15 @@ static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
+	{
+		NPC_S_KPU5_NGIO, 0xff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
 	{
 		NPC_S_NA, 0X00,
 		0x0000,
@@ -8642,14 +8499,6 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 12, 0, 0, 0,
-		NPC_S_KPU2_NGIO, 12, 1,
-		NPC_LID_LA, NPC_LT_LA_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 12, 0, 0, 0,
@@ -9192,159 +9041,127 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 3, 0,
-		NPC_S_KPU5_IP, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_IP, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		6, 0, 0, 3, 0,
-		NPC_S_KPU5_IP6, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_IP6, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 3, 0,
-		NPC_S_KPU5_ARP, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_ARP, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 3, 0,
-		NPC_S_KPU5_RARP, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_RARP, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 3, 0,
-		NPC_S_KPU5_PTP, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_PTP, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 3, 0,
-		NPC_S_KPU5_FCOE, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_FCOE, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 12, 0, 0, 0,
-		NPC_S_KPU2_CTAG2, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
+		NPC_S_KPU2_CTAG2, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
+		NPC_S_KPU2_CTAG, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 22, 0, 0,
-		NPC_S_KPU2_SBTAG, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
+		NPC_S_KPU2_SBTAG, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
+		NPC_S_KPU2_QINQ, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 12, 26, 0, 0,
-		NPC_S_KPU2_ETAG, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_ETAG,
+		NPC_S_KPU2_ETAG, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 6, 10, 2, 0,
-		NPC_S_KPU4_MPLS, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_L_WITH_MPLS,
+		NPC_S_KPU4_MPLS, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 6, 10, 2, 0,
-		NPC_S_KPU4_MPLS, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_L_WITH_MPLS,
+		NPC_S_KPU4_MPLS, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 0, 0, 2, 0,
-		NPC_S_KPU4_NSH, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_L_WITH_NSH,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_L_UNK_ETYPE,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 0, 6, 3, 0,
-		NPC_S_KPU5_CPT_IP, 56, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
+		NPC_S_KPU4_NSH, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		6, 0, 0, 3, 0,
-		NPC_S_KPU5_CPT_IP6, 56, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 54, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 54, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 3, 0,
-		NPC_S_KPU5_CPT_IP, 60, 1,
+		NPC_S_KPU5_CPT_IP, 14, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		0,
 		0, 0, 0, 0,
@@ -9352,7 +9169,7 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		6, 0, 0, 3, 0,
-		NPC_S_KPU5_CPT_IP6, 60, 1,
+		NPC_S_KPU5_CPT_IP6, 14, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		0,
 		0, 0, 0, 0,
@@ -9360,7 +9177,7 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 58, 1,
+		NPC_S_KPU2_CPT_CTAG, 12, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
 		0, 0, 0, 0,
@@ -9368,139 +9185,11 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 58, 1,
+		NPC_S_KPU2_CPT_QINQ, 12, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		NPC_F_LA_L_UNK_ETYPE,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 0, 6, 3, 0,
-		NPC_S_KPU5_IP, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		6, 0, 0, 3, 0,
-		NPC_S_KPU5_IP6, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 3, 0,
-		NPC_S_KPU5_ARP, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 3, 0,
-		NPC_S_KPU5_RARP, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 3, 0,
-		NPC_S_KPU5_PTP, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 3, 0,
-		NPC_S_KPU5_FCOE, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 12, 0, 0, 0,
-		NPC_S_KPU2_CTAG2, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 22, 0, 0,
-		NPC_S_KPU2_SBTAG, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 12, 26, 0, 0,
-		NPC_S_KPU2_ETAG, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_ETAG,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 10, 2, 0,
-		NPC_S_KPU4_MPLS, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_L_WITH_MPLS,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 10, 2, 0,
-		NPC_S_KPU4_MPLS, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_L_WITH_MPLS,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 0, 0, 2, 0,
-		NPC_S_KPU4_NSH, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_L_WITH_NSH,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_L_UNK_ETYPE,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		12, 0, 0, 1, 0,
@@ -9594,6 +9283,14 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 2, 0,
+		NPC_S_KPU5_NGIO, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_CTAG,
+		0,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
@@ -10388,12 +10085,36 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LC, NPC_LT_LC_NGIO,
+		8, 0, 6, 2, 0,
+		NPC_S_KPU5_CPT_IP, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_CTAG,
+		0,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		6, 0, 0, 2, 0,
+		NPC_S_KPU5_CPT_IP6, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_CTAG,
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		8, 0, 6, 2, 0,
+		NPC_S_KPU5_CPT_IP, 10, 1,
+		NPC_LID_LB, NPC_LT_LB_STAG_QINQ,
+		NPC_F_LB_U_MORE_TAG | NPC_F_LB_L_WITH_CTAG,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		6, 0, 0, 2, 0,
+		NPC_S_KPU5_CPT_IP6, 10, 1,
+		NPC_LID_LB, NPC_LT_LB_STAG_QINQ,
+		NPC_F_LB_U_MORE_TAG | NPC_F_LB_L_WITH_CTAG,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_LB, NPC_EC_L2_K3,
 		0, 0, 0, 0, 1,
@@ -12425,6 +12146,14 @@ static struct npc_kpu_profile_action kpu5_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 1,
+		NPC_LID_LC, NPC_LT_LC_NGIO,
+		0,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_LC, NPC_EC_UNK,
 		0, 0, 0, 0, 1,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index b3803577324e..9ea2f6ac38ec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -29,6 +29,9 @@ static struct mac_ops	rpm_mac_ops   = {
 	.mac_get_pause_frm_status =	rpm_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
 	.mac_pause_frm_config =		rpm_lmac_pause_frm_config,
+	.mac_enadis_ptp_config =	rpm_lmac_ptp_config,
+	.mac_rx_tx_enable =		rpm_lmac_rx_tx_enable,
+	.mac_tx_enable =		rpm_lmac_tx_enable,
 };
 
 struct mac_ops *rpm_get_mac_ops(void)
@@ -53,6 +56,43 @@ int rpm_get_nr_lmacs(void *rpmd)
 	return hweight8(rpm_read(rpm, 0, CGXX_CMRX_RX_LMACS) & 0xFULL);
 }
 
+int rpm_lmac_tx_enable(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg, last;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	last = cfg;
+	if (enable)
+		cfg |= RPM_TX_EN;
+	else
+		cfg &= ~(RPM_TX_EN);
+
+	if (cfg != last)
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	return !!(last & RPM_TX_EN);
+}
+
+int rpm_lmac_rx_tx_enable(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	if (enable)
+		cfg |= RPM_RX_EN | RPM_TX_EN;
+	else
+		cfg &= ~(RPM_RX_EN | RPM_TX_EN);
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	return 0;
+}
+
 void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable)
 {
 	rpm_t *rpm = rpmd;
@@ -267,3 +307,19 @@ int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable)
 
 	return 0;
 }
+
+void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_CMRX_CFG);
+	if (enable)
+		cfg |= RPMX_RX_TS_PREPEND;
+	else
+		cfg &= ~RPMX_RX_TS_PREPEND;
+	rpm_write(rpm, lmac_id, RPMX_CMRX_CFG, cfg);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index f0b069442dcc..ff580311edd0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -14,6 +14,8 @@
 #define PCI_DEVID_CN10K_RPM		0xA060
 
 /* Registers */
+#define RPMX_CMRX_CFG			0x00
+#define RPMX_RX_TS_PREPEND              BIT_ULL(22)
 #define RPMX_CMRX_SW_INT                0x180
 #define RPMX_CMRX_SW_INT_W1S            0x188
 #define RPMX_CMRX_SW_INT_ENA_W1S        0x198
@@ -41,6 +43,8 @@
 #define RPMX_MTI_STAT_DATA_HI_CDC            0x10038
 
 #define RPM_LMAC_FWI			0xa
+#define RPM_TX_EN			BIT_ULL(0)
+#define RPM_RX_EN			BIT_ULL(1)
 
 /* Function Declarations */
 int rpm_get_nr_lmacs(void *rpmd);
@@ -54,4 +58,7 @@ int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 			      u8 rx_pause);
 int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat);
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat);
+void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable);
+int rpm_lmac_rx_tx_enable(void *rpmd, int lmac_id, bool enable);
+int rpm_lmac_tx_enable(void *rpmd, int lmac_id, bool enable);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 1d9411232f1d..a7213db38804 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -220,6 +220,7 @@ struct rvu_pfvf {
 	u16		maxlen;
 	u16		minlen;
 
+	bool		hw_rx_tstamp_en; /* Is rx_tstamp enabled */
 	u8		mac_addr[ETH_ALEN]; /* MAC address of this PF/VF */
 	u8		default_mac[ETH_ALEN]; /* MAC address from FWdata */
 
@@ -237,6 +238,7 @@ struct rvu_pfvf {
 	bool	cgx_in_use; /* this PF/VF using CGX? */
 	int	cgx_users;  /* number of cgx users - used only by PFs */
 
+	int     intf_mode;
 	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
 	u8	nix_rx_intf; /* NIX0_RX/NIX1_RX interface to NPC */
 	u8	nix_tx_intf; /* NIX0_TX/NIX1_TX interface to NPC */
@@ -794,10 +796,12 @@ void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			 int blkaddr, u16 src, struct mcam_entry *entry,
 			 u8 *intf, u8 *ena);
+bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc);
 bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
 u32  rvu_cgx_get_fifolen(struct rvu *rvu);
 void *rvu_first_cgx_pdata(struct rvu *rvu);
 int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id);
+int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable);
 
 int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
@@ -827,4 +831,7 @@ void rvu_switch_enable(struct rvu *rvu);
 void rvu_switch_disable(struct rvu *rvu);
 void rvu_switch_update_rules(struct rvu *rvu, u16 pcifunc);
 
+int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
+			   u64 pkind, u8 var_len_off, u8 var_len_off_mask,
+			   u8 shift_dir);
 #endif /* RVU_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 81e8ea9ee30e..28ff67819566 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -411,7 +411,7 @@ int rvu_cgx_exit(struct rvu *rvu)
  * VF's of mapped PF and other PFs are not allowed. This fn() checks
  * whether a PFFUNC is permitted to do the config or not.
  */
-static bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
+inline bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
 {
 	if ((pcifunc & RVU_PFVF_FUNC_MASK) ||
 	    !is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc)))
@@ -442,16 +442,26 @@ void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable)
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 {
 	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
+	void *cgxd;
 
 	if (!is_cgx_config_permitted(rvu, pcifunc))
 		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+	mac_ops = get_mac_ops(cgxd);
 
-	cgx_lmac_rx_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, start);
+	return mac_ops->mac_rx_tx_enable(cgxd, lmac_id, start);
+}
 
-	return 0;
+int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable)
+{
+	struct mac_ops *mac_ops;
+
+	mac_ops = get_mac_ops(cgxd);
+	return mac_ops->mac_tx_enable(cgxd, lmac_id, enable);
 }
 
 void rvu_cgx_disable_dmac_entries(struct rvu *rvu, u16 pcifunc)
@@ -694,7 +704,9 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 
 static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 {
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
 	void *cgxd;
 
@@ -711,13 +723,16 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgxd = rvu_cgx_pdata(cgx_id, rvu);
 
-	cgx_lmac_ptp_config(cgxd, lmac_id, enable);
+	mac_ops = get_mac_ops(cgxd);
+	mac_ops->mac_enadis_ptp_config(cgxd, lmac_id, true);
 	/* If PTP is enabled then inform NPC that packets to be
 	 * parsed by this PF will have their data shifted by 8 bytes
 	 * and if PTP is disabled then no shift is required
 	 */
 	if (npc_config_ts_kpuaction(rvu, pf, pcifunc, enable))
 		return -EINVAL;
+	/* This flag is required to clean up CGX conf if app gets killed */
+	pfvf->hw_rx_tstamp_en = enable;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 959266894cf1..603361c94786 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2068,8 +2068,8 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	/* enable cgx tx if disabled */
 	if (is_pf_cgxmapped(rvu, pf)) {
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-		restore_tx_en = !cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu),
-						    lmac_id, true);
+		restore_tx_en = !rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu),
+						   lmac_id, true);
 	}
 
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
@@ -2092,7 +2092,7 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	rvu_cgx_enadis_rx_bp(rvu, pf, true);
 	/* restore cgx tx state */
 	if (restore_tx_en)
-		cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
+		rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
 	return err;
 }
 
@@ -3878,7 +3878,7 @@ nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
 	/* Enable cgx tx if disabled for credits to be back */
 	if (is_pf_cgxmapped(rvu, pf)) {
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-		restore_tx_en = !cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu),
+		restore_tx_en = !rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu),
 						    lmac_id, true);
 	}
 
@@ -3918,7 +3918,7 @@ nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
 
 	/* Restore state of cgx tx */
 	if (restore_tx_en)
-		cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
+		rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
 
 	mutex_unlock(&rvu->rsrc_lock);
 	return rc;
@@ -4519,6 +4519,10 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct hwctx_disable_req ctx_req;
+	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
+	u8 cgx_id, lmac_id;
+	void *cgxd;
 	int err;
 
 	ctx_req.hdr.pcifunc = pcifunc;
@@ -4555,6 +4559,22 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 			dev_err(rvu->dev, "CQ ctx disable failed\n");
 	}
 
+	/* reset HW config done for Switch headers */
+	rvu_npc_set_parse_mode(rvu, pcifunc, OTX2_PRIV_FLAGS_DEFAULT,
+			       (PKIND_TX | PKIND_RX), 0, 0, 0, 0);
+
+	/* Disabling CGX and NPC config done for PTP */
+	if (pfvf->hw_rx_tstamp_en) {
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+		cgxd = rvu_cgx_pdata(cgx_id, rvu);
+		mac_ops = get_mac_ops(cgxd);
+		mac_ops->mac_enadis_ptp_config(cgxd, lmac_id, false);
+		/* Undo NPC config done for PTP */
+		if (npc_config_ts_kpuaction(rvu, pf, pcifunc, false))
+			dev_err(rvu->dev, "NPC config for PTP failed\n");
+		pfvf->hw_rx_tstamp_en = false;
+	}
+
 	nix_ctx_free(rvu, pfvf);
 
 	nix_free_all_bandprof(rvu, pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 87f18e32b463..fbb573c40c1a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -3183,6 +3183,102 @@ int rvu_mbox_handler_npc_get_kex_cfg(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+static int
+npc_set_var_len_offset_pkind(struct rvu *rvu, u16 pcifunc, u64 pkind,
+			     u8 var_len_off, u8 var_len_off_mask, u8 shift_dir)
+{
+	struct npc_kpu_action0 *act0;
+	u8 shift_count = 0;
+	int blkaddr;
+	u64 val;
+
+	if (!var_len_off_mask)
+		return -EINVAL;
+
+	if (var_len_off_mask != 0xff) {
+		if (shift_dir)
+			shift_count = __ffs(var_len_off_mask);
+		else
+			shift_count = (8 - __fls(var_len_off_mask));
+	}
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, pcifunc);
+	if (blkaddr < 0) {
+		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
+		return -EINVAL;
+	}
+	val = rvu_read64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind));
+	act0 = (struct npc_kpu_action0 *)&val;
+	act0->var_len_shift = shift_count;
+	act0->var_len_right = shift_dir;
+	act0->var_len_mask = var_len_off_mask;
+	act0->var_len_offset = var_len_off;
+	rvu_write64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind), val);
+	return 0;
+}
+
+int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
+			   u64 pkind, u8 var_len_off, u8 var_len_off_mask,
+			   u8 shift_dir)
+
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int blkaddr, nixlf, rc, intf_mode;
+	int pf = rvu_get_pf(pcifunc);
+	u64 rxpkind, txpkind;
+	u8 cgx_id, lmac_id;
+
+	/* use default pkind to disable edsa/higig */
+	rxpkind = rvu_npc_get_pkind(rvu, pf);
+	txpkind = NPC_TX_DEF_PKIND;
+	intf_mode = NPC_INTF_MODE_DEF;
+
+	if (mode & OTX2_PRIV_FLAGS_CUSTOM) {
+		if (pkind == NPC_RX_CUSTOM_PRE_L2_PKIND) {
+			rc = npc_set_var_len_offset_pkind(rvu, pcifunc, pkind,
+							  var_len_off,
+							  var_len_off_mask,
+							  shift_dir);
+			if (rc)
+				return rc;
+		}
+		rxpkind = pkind;
+		txpkind = pkind;
+	}
+
+	if (dir & PKIND_RX) {
+		/* rx pkind set req valid only for cgx mapped PFs */
+		if (!is_cgx_config_permitted(rvu, pcifunc))
+			return 0;
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+		rc = cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
+				   rxpkind);
+		if (rc)
+			return rc;
+	}
+
+	if (dir & PKIND_TX) {
+		/* Tx pkind set request valid if PCIFUNC has NIXLF attached */
+		rc = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+		if (rc)
+			return rc;
+
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf),
+			    txpkind);
+	}
+
+	pfvf->intf_mode = intf_mode;
+	return 0;
+}
+
+int rvu_mbox_handler_npc_set_pkind(struct rvu *rvu, struct npc_set_pkind *req,
+				   struct msg_rsp *rsp)
+{
+	return rvu_npc_set_parse_mode(rvu, req->hdr.pcifunc, req->mode,
+				      req->dir, req->pkind, req->var_len_off,
+				      req->var_len_off_mask, req->shift_dir);
+}
+
 int rvu_mbox_handler_npc_read_base_steer_rule(struct rvu *rvu,
 					      struct msg_req *req,
 					      struct npc_mcam_read_base_rule_rsp *rsp)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 5120a59361e6..428881e0adcb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -127,6 +127,28 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
+static inline bool
+mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+				  struct mlx5_wqe_eth_seg *eseg)
+{
+	u8 inner_ipproto;
+
+	if (!mlx5e_ipsec_eseg_meta(eseg))
+		return false;
+
+	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
+	inner_ipproto = xfrm_offload(skb)->inner_ipproto;
+	if (inner_ipproto) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L3_INNER_CSUM;
+		if (inner_ipproto == IPPROTO_TCP || inner_ipproto == IPPROTO_UDP)
+			eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM;
+	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
+		sq->stats->csum_partial_inner++;
+	}
+
+	return true;
+}
 #else
 static inline
 void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
@@ -143,6 +165,13 @@ static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false;
 static inline netdev_features_t
 mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 { return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK); }
+
+static inline bool
+mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+				  struct mlx5_wqe_eth_seg *eseg)
+{
+	return false;
+}
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
 #endif /* __MLX5E_IPSEC_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 188994d091c5..7fd33b356cc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -38,6 +38,7 @@
 #include "en/txrx.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
+#include "en_accel/ipsec_rxtx.h"
 #include "en/ptp.h"
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
@@ -213,30 +214,13 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
 }
 
-static void
-ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-			    struct mlx5_wqe_eth_seg *eseg)
-{
-	struct xfrm_offload *xo = xfrm_offload(skb);
-
-	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
-	if (xo->inner_ipproto) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM | MLX5_ETH_WQE_L3_INNER_CSUM;
-	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
-		sq->stats->csum_partial_inner++;
-	}
-}
-
 static inline void
 mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			    struct mlx5e_accel_tx_state *accel,
 			    struct mlx5_wqe_eth_seg *eseg)
 {
-	if (unlikely(mlx5e_ipsec_eseg_meta(eseg))) {
-		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
+	if (unlikely(mlx5e_ipsec_txwqe_build_eseg_csum(sq, skb, eseg)))
 		return;
-	}
 
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
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
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index b6a73d151dec..8dd8c7f425d2 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -28,7 +28,7 @@ config MSCC_OCELOT_SWITCH
 	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
-	depends on OF_NET
+	depends on OF
 	select MSCC_OCELOT_SWITCH_LIB
 	select GENERIC_PHY
 	help
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 6781aa636d58..1b415fe6f9b9 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2282,18 +2282,18 @@ static int __init sxgbe_cmdline_opt(char *str)
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
index e6af26b2dcb8..9376c4e28626 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2268,6 +2268,23 @@ static void stmmac_stop_tx_dma(struct stmmac_priv *priv, u32 chan)
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
@@ -2903,8 +2920,10 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
 
 	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
+	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+	}
 
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
@@ -3667,7 +3686,7 @@ static int stmmac_request_irq(struct net_device *dev)
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-int stmmac_open(struct net_device *dev)
+static int stmmac_open(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int mode = priv->plat->phy_interface;
@@ -3756,6 +3775,7 @@ int stmmac_open(struct net_device *dev)
 
 	stmmac_enable_all_queues(priv);
 	netif_tx_start_all_queues(priv->dev);
+	stmmac_enable_all_dma_irq(priv);
 
 	return 0;
 
@@ -3791,7 +3811,7 @@ static void stmmac_fpe_stop_wq(struct stmmac_priv *priv)
  *  Description:
  *  This is the stop entry point of the driver.
  */
-int stmmac_release(struct net_device *dev)
+static int stmmac_release(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
@@ -6456,6 +6476,143 @@ void stmmac_enable_tx_queue(struct stmmac_priv *priv, u32 queue)
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
@@ -7320,6 +7477,7 @@ int stmmac_resume(struct device *dev)
 	stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
 
 	stmmac_enable_all_queues(priv);
+	stmmac_enable_all_dma_irq(priv);
 
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
@@ -7336,7 +7494,7 @@ static int __init stmmac_cmdline_opt(char *str)
 	char *opt;
 
 	if (!str || !*str)
-		return -EINVAL;
+		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
 		if (!strncmp(opt, "debug:", 6)) {
 			if (kstrtoint(opt + 6, 0, &debug))
@@ -7367,11 +7525,11 @@ static int __init stmmac_cmdline_opt(char *str)
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
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 35728f1af6a6..763d435a9564 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -31,6 +31,8 @@
 
 #define AX_MTU		236
 
+/* some arch define END as assembly function ending, just undef it */
+#undef	END
 /* SLIP/KISS protocol characters. */
 #define END             0300		/* indicates end of frame	*/
 #define ESC             0333		/* indicates byte stuffing	*/
diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index d037682fb7ad..3e0da1e76471 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -2,6 +2,7 @@ config QCOM_IPA
 	tristate "Qualcomm IPA support"
 	depends on NET && QCOM_SMEM
 	depends on ARCH_QCOM || COMPILE_TEST
+	depends on INTERCONNECT
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM
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
index 5dc39fbb74d6..d398a06b2656 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
 #include <linux/vmalloc.h>
+#include <linux/err.h>
 #include <linux/ieee80211.h>
 #include <linux/netdevice.h>
 
@@ -2044,7 +2045,6 @@ void iwl_mvm_sta_add_debugfs(struct ieee80211_hw *hw,
 void iwl_mvm_dbgfs_register(struct iwl_mvm *mvm)
 {
 	struct dentry *bcast_dir __maybe_unused;
-	char buf[100];
 
 	spin_lock_init(&mvm->drv_stats_lock);
 
@@ -2140,6 +2140,11 @@ void iwl_mvm_dbgfs_register(struct iwl_mvm *mvm)
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
index 0adae76eb8df..0aeb1e1ec93f 100644
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
@@ -3641,6 +3650,10 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
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
index 8126e08f11a9..73d388cbcd69 100644
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
diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index 4c6eb61a6ac6..ec9cb6c81eda 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -419,8 +419,8 @@ static void switchtec_ntb_part_link_speed(struct switchtec_ntb *sndev,
 					  enum ntb_width *width)
 {
 	struct switchtec_dev *stdev = sndev->stdev;
-
-	u32 pff = ioread32(&stdev->mmio_part_cfg[partition].vep_pff_inst_id);
+	u32 pff =
+		ioread32(&stdev->mmio_part_cfg_all[partition].vep_pff_inst_id);
 	u32 linksta = ioread32(&stdev->mmio_pff_csr[pff].pci_cap_region[13]);
 
 	if (speed)
@@ -840,7 +840,6 @@ static int switchtec_ntb_init_sndev(struct switchtec_ntb *sndev)
 	u64 tpart_vec;
 	int self;
 	u64 part_map;
-	int bit;
 
 	sndev->ntb.pdev = sndev->stdev->pdev;
 	sndev->ntb.topo = NTB_TOPO_SWITCH;
@@ -861,29 +860,28 @@ static int switchtec_ntb_init_sndev(struct switchtec_ntb *sndev)
 	part_map = ioread64(&sndev->mmio_ntb->ep_map);
 	part_map &= ~(1 << sndev->self_partition);
 
-	if (!ffs(tpart_vec)) {
+	if (!tpart_vec) {
 		if (sndev->stdev->partition_count != 2) {
 			dev_err(&sndev->stdev->dev,
 				"ntb target partition not defined\n");
 			return -ENODEV;
 		}
 
-		bit = ffs(part_map);
-		if (!bit) {
+		if (!part_map) {
 			dev_err(&sndev->stdev->dev,
 				"peer partition is not NT partition\n");
 			return -ENODEV;
 		}
 
-		sndev->peer_partition = bit - 1;
+		sndev->peer_partition = __ffs64(part_map);
 	} else {
-		if (ffs(tpart_vec) != fls(tpart_vec)) {
+		if (__ffs64(tpart_vec) != (fls64(tpart_vec) - 1)) {
 			dev_err(&sndev->stdev->dev,
 				"ntb driver only supports 1 pair of 1-1 ntb mapping\n");
 			return -ENODEV;
 		}
 
-		sndev->peer_partition = ffs(tpart_vec) - 1;
+		sndev->peer_partition = __ffs64(tpart_vec);
 		if (!(part_map & (1ULL << sndev->peer_partition))) {
 			dev_err(&sndev->stdev->dev,
 				"ntb target partition is not NT partition\n");
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 3dfeae8912df..80b5fd44ab1c 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -70,10 +70,6 @@ config OF_IRQ
 	def_bool y
 	depends on !SPARC && IRQ_DOMAIN
 
-config OF_NET
-	depends on NETDEVICES
-	def_bool y
-
 config OF_RESERVED_MEM
 	def_bool OF_EARLY_FLATTREE
 
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index c13b982084a3..e0360a44306e 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_OF_EARLY_FLATTREE) += fdt_address.o
 obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
-obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_UNITTEST) += unittest.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
 obj-$(CONFIG_OF_RESOLVE)  += resolver.o
diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
deleted file mode 100644
index dbac3a172a11..000000000000
--- a/drivers/of/of_net.c
+++ /dev/null
@@ -1,145 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * OF helpers for network devices.
- *
- * Initially copied out of arch/powerpc/kernel/prom_parse.c
- */
-#include <linux/etherdevice.h>
-#include <linux/kernel.h>
-#include <linux/of_net.h>
-#include <linux/of_platform.h>
-#include <linux/phy.h>
-#include <linux/export.h>
-#include <linux/device.h>
-#include <linux/nvmem-consumer.h>
-
-/**
- * of_get_phy_mode - Get phy mode for given device_node
- * @np:	Pointer to the given device_node
- * @interface: Pointer to the result
- *
- * The function gets phy interface string from property 'phy-mode' or
- * 'phy-connection-type'. The index in phy_modes table is set in
- * interface and 0 returned. In case of error interface is set to
- * PHY_INTERFACE_MODE_NA and an errno is returned, e.g. -ENODEV.
- */
-int of_get_phy_mode(struct device_node *np, phy_interface_t *interface)
-{
-	const char *pm;
-	int err, i;
-
-	*interface = PHY_INTERFACE_MODE_NA;
-
-	err = of_property_read_string(np, "phy-mode", &pm);
-	if (err < 0)
-		err = of_property_read_string(np, "phy-connection-type", &pm);
-	if (err < 0)
-		return err;
-
-	for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++)
-		if (!strcasecmp(pm, phy_modes(i))) {
-			*interface = i;
-			return 0;
-		}
-
-	return -ENODEV;
-}
-EXPORT_SYMBOL_GPL(of_get_phy_mode);
-
-static int of_get_mac_addr(struct device_node *np, const char *name, u8 *addr)
-{
-	struct property *pp = of_find_property(np, name, NULL);
-
-	if (pp && pp->length == ETH_ALEN && is_valid_ether_addr(pp->value)) {
-		memcpy(addr, pp->value, ETH_ALEN);
-		return 0;
-	}
-	return -ENODEV;
-}
-
-static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
-{
-	struct platform_device *pdev = of_find_device_by_node(np);
-	struct nvmem_cell *cell;
-	const void *mac;
-	size_t len;
-	int ret;
-
-	/* Try lookup by device first, there might be a nvmem_cell_lookup
-	 * associated with a given device.
-	 */
-	if (pdev) {
-		ret = nvmem_get_mac_address(&pdev->dev, addr);
-		put_device(&pdev->dev);
-		return ret;
-	}
-
-	cell = of_nvmem_cell_get(np, "mac-address");
-	if (IS_ERR(cell))
-		return PTR_ERR(cell);
-
-	mac = nvmem_cell_read(cell, &len);
-	nvmem_cell_put(cell);
-
-	if (IS_ERR(mac))
-		return PTR_ERR(mac);
-
-	if (len != ETH_ALEN || !is_valid_ether_addr(mac)) {
-		kfree(mac);
-		return -EINVAL;
-	}
-
-	memcpy(addr, mac, ETH_ALEN);
-	kfree(mac);
-
-	return 0;
-}
-
-/**
- * of_get_mac_address()
- * @np:		Caller's Device Node
- * @addr:	Pointer to a six-byte array for the result
- *
- * Search the device tree for the best MAC address to use.  'mac-address' is
- * checked first, because that is supposed to contain to "most recent" MAC
- * address. If that isn't set, then 'local-mac-address' is checked next,
- * because that is the default address. If that isn't set, then the obsolete
- * 'address' is checked, just in case we're using an old device tree. If any
- * of the above isn't set, then try to get MAC address from nvmem cell named
- * 'mac-address'.
- *
- * Note that the 'address' property is supposed to contain a virtual address of
- * the register set, but some DTS files have redefined that property to be the
- * MAC address.
- *
- * All-zero MAC addresses are rejected, because those could be properties that
- * exist in the device tree, but were not set by U-Boot.  For example, the
- * DTS could define 'mac-address' and 'local-mac-address', with zero MAC
- * addresses.  Some older U-Boots only initialized 'local-mac-address'.  In
- * this case, the real MAC is in 'local-mac-address', and 'mac-address' exists
- * but is all zeros.
- *
- * Return: 0 on success and errno in case of error.
-*/
-int of_get_mac_address(struct device_node *np, u8 *addr)
-{
-	int ret;
-
-	if (!np)
-		return -ENODEV;
-
-	ret = of_get_mac_addr(np, "mac-address", addr);
-	if (!ret)
-		return 0;
-
-	ret = of_get_mac_addr(np, "local-mac-address", addr);
-	if (!ret)
-		return 0;
-
-	ret = of_get_mac_addr(np, "address", addr);
-	if (!ret)
-		return 0;
-
-	return of_get_mac_addr_nvmem(np, addr);
-}
-EXPORT_SYMBOL(of_get_mac_address);
diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index a945f0c0e73d..3254f60d1713 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -671,10 +671,11 @@ void dw_pcie_iatu_detect(struct dw_pcie *pci)
 		if (!pci->atu_base) {
 			struct resource *res =
 				platform_get_resource_byname(pdev, IORESOURCE_MEM, "atu");
-			if (res)
+			if (res) {
 				pci->atu_size = resource_size(res);
-			pci->atu_base = devm_ioremap_resource(dev, res);
-			if (IS_ERR(pci->atu_base))
+				pci->atu_base = devm_ioremap_resource(dev, res);
+			}
+			if (!pci->atu_base || IS_ERR(pci->atu_base))
 				pci->atu_base = pci->dbi_base + DEFAULT_DBI_ATU_OFFSET;
 		}
 
diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 85323cbc4888..b2217e2b3efd 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1537,8 +1537,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		 * only PIO for issuing configuration transfers which does
 		 * not use PCIe window configuration.
 		 */
-		if (type != IORESOURCE_MEM && type != IORESOURCE_MEM_64 &&
-		    type != IORESOURCE_IO)
+		if (type != IORESOURCE_MEM && type != IORESOURCE_IO)
 			continue;
 
 		/*
@@ -1546,8 +1545,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		 * configuration is set to transparent memory access so it
 		 * does not need window configuration.
 		 */
-		if ((type == IORESOURCE_MEM || type == IORESOURCE_MEM_64) &&
-		    entry->offset == 0)
+		if (type == IORESOURCE_MEM && entry->offset == 0)
 			continue;
 
 		/*
diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index 2dc6890dbcaa..2a3bf82aa4e2 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -51,10 +51,14 @@
 	 PCIE_CONF_FUNC(PCI_FUNC(devfn)) | PCIE_CONF_REG(where) | \
 	 PCIE_CONF_ADDR_EN)
 #define PCIE_CONF_DATA_OFF	0x18fc
+#define PCIE_INT_CAUSE_OFF	0x1900
+#define  PCIE_INT_PM_PME		BIT(28)
 #define PCIE_MASK_OFF		0x1910
 #define  PCIE_MASK_ENABLE_INTS          0x0f000000
 #define PCIE_CTRL_OFF		0x1a00
 #define  PCIE_CTRL_X1_MODE		0x0001
+#define  PCIE_CTRL_RC_MODE		BIT(1)
+#define  PCIE_CTRL_MASTER_HOT_RESET	BIT(24)
 #define PCIE_STAT_OFF		0x1a04
 #define  PCIE_STAT_BUS                  0xff00
 #define  PCIE_STAT_DEV                  0x1f0000
@@ -125,6 +129,11 @@ static bool mvebu_pcie_link_up(struct mvebu_pcie_port *port)
 	return !(mvebu_readl(port, PCIE_STAT_OFF) & PCIE_STAT_LINK_DOWN);
 }
 
+static u8 mvebu_pcie_get_local_bus_nr(struct mvebu_pcie_port *port)
+{
+	return (mvebu_readl(port, PCIE_STAT_OFF) & PCIE_STAT_BUS) >> 8;
+}
+
 static void mvebu_pcie_set_local_bus_nr(struct mvebu_pcie_port *port, int nr)
 {
 	u32 stat;
@@ -213,18 +222,21 @@ static void mvebu_pcie_setup_wins(struct mvebu_pcie_port *port)
 
 static void mvebu_pcie_setup_hw(struct mvebu_pcie_port *port)
 {
-	u32 cmd, mask;
+	u32 ctrl, cmd, mask;
 
-	/* Point PCIe unit MBUS decode windows to DRAM space. */
-	mvebu_pcie_setup_wins(port);
+	/* Setup PCIe controller to Root Complex mode. */
+	ctrl = mvebu_readl(port, PCIE_CTRL_OFF);
+	ctrl |= PCIE_CTRL_RC_MODE;
+	mvebu_writel(port, ctrl, PCIE_CTRL_OFF);
 
-	/* Master + slave enable. */
+	/* Disable Root Bridge I/O space, memory space and bus mastering. */
 	cmd = mvebu_readl(port, PCIE_CMD_OFF);
-	cmd |= PCI_COMMAND_IO;
-	cmd |= PCI_COMMAND_MEMORY;
-	cmd |= PCI_COMMAND_MASTER;
+	cmd &= ~(PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
 	mvebu_writel(port, cmd, PCIE_CMD_OFF);
 
+	/* Point PCIe unit MBUS decode windows to DRAM space. */
+	mvebu_pcie_setup_wins(port);
+
 	/* Enable interrupt lines A-D. */
 	mask = mvebu_readl(port, PCIE_MASK_OFF);
 	mask |= PCIE_MASK_ENABLE_INTS;
@@ -371,8 +383,7 @@ static void mvebu_pcie_handle_iobase_change(struct mvebu_pcie_port *port)
 
 	/* Are the new iobase/iolimit values invalid? */
 	if (conf->iolimit < conf->iobase ||
-	    conf->iolimitupper < conf->iobaseupper ||
-	    !(conf->command & PCI_COMMAND_IO)) {
+	    conf->iolimitupper < conf->iobaseupper) {
 		mvebu_pcie_set_window(port, port->io_target, port->io_attr,
 				      &desired, &port->iowin);
 		return;
@@ -409,8 +420,7 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 	struct pci_bridge_emul_conf *conf = &port->bridge.conf;
 
 	/* Are the new membase/memlimit values invalid? */
-	if (conf->memlimit < conf->membase ||
-	    !(conf->command & PCI_COMMAND_MEMORY)) {
+	if (conf->memlimit < conf->membase) {
 		mvebu_pcie_set_window(port, port->mem_target, port->mem_attr,
 				      &desired, &port->memwin);
 		return;
@@ -430,6 +440,54 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 			      &port->memwin);
 }
 
+static pci_bridge_emul_read_status_t
+mvebu_pci_bridge_emul_base_conf_read(struct pci_bridge_emul *bridge,
+				     int reg, u32 *value)
+{
+	struct mvebu_pcie_port *port = bridge->data;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		*value = mvebu_readl(port, PCIE_CMD_OFF);
+		break;
+
+	case PCI_PRIMARY_BUS: {
+		/*
+		 * From the whole 32bit register we support reading from HW only
+		 * secondary bus number which is mvebu local bus number.
+		 * Other bits are retrieved only from emulated config buffer.
+		 */
+		__le32 *cfgspace = (__le32 *)&bridge->conf;
+		u32 val = le32_to_cpu(cfgspace[PCI_PRIMARY_BUS / 4]);
+		val &= ~0xff00;
+		val |= mvebu_pcie_get_local_bus_nr(port) << 8;
+		*value = val;
+		break;
+	}
+
+	case PCI_INTERRUPT_LINE: {
+		/*
+		 * From the whole 32bit register we support reading from HW only
+		 * one bit: PCI_BRIDGE_CTL_BUS_RESET.
+		 * Other bits are retrieved only from emulated config buffer.
+		 */
+		__le32 *cfgspace = (__le32 *)&bridge->conf;
+		u32 val = le32_to_cpu(cfgspace[PCI_INTERRUPT_LINE / 4]);
+		if (mvebu_readl(port, PCIE_CTRL_OFF) & PCIE_CTRL_MASTER_HOT_RESET)
+			val |= PCI_BRIDGE_CTL_BUS_RESET << 16;
+		else
+			val &= ~(PCI_BRIDGE_CTL_BUS_RESET << 16);
+		*value = val;
+		break;
+	}
+
+	default:
+		return PCI_BRIDGE_EMUL_NOT_HANDLED;
+	}
+
+	return PCI_BRIDGE_EMUL_HANDLED;
+}
+
 static pci_bridge_emul_read_status_t
 mvebu_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 				     int reg, u32 *value)
@@ -442,9 +500,7 @@ mvebu_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 		break;
 
 	case PCI_EXP_DEVCTL:
-		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL) &
-				 ~(PCI_EXP_DEVCTL_URRE | PCI_EXP_DEVCTL_FERE |
-				   PCI_EXP_DEVCTL_NFERE | PCI_EXP_DEVCTL_CERE);
+		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL);
 		break;
 
 	case PCI_EXP_LNKCAP:
@@ -468,6 +524,18 @@ mvebu_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 		*value = mvebu_readl(port, PCIE_RC_RTSTA);
 		break;
 
+	case PCI_EXP_DEVCAP2:
+		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCAP2);
+		break;
+
+	case PCI_EXP_DEVCTL2:
+		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL2);
+		break;
+
+	case PCI_EXP_LNKCTL2:
+		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_LNKCTL2);
+		break;
+
 	default:
 		return PCI_BRIDGE_EMUL_NOT_HANDLED;
 	}
@@ -484,26 +552,16 @@ mvebu_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 
 	switch (reg) {
 	case PCI_COMMAND:
-	{
-		if (!mvebu_has_ioport(port))
-			conf->command &= ~PCI_COMMAND_IO;
-
-		if ((old ^ new) & PCI_COMMAND_IO)
-			mvebu_pcie_handle_iobase_change(port);
-		if ((old ^ new) & PCI_COMMAND_MEMORY)
-			mvebu_pcie_handle_membase_change(port);
+		if (!mvebu_has_ioport(port)) {
+			conf->command = cpu_to_le16(
+				le16_to_cpu(conf->command) & ~PCI_COMMAND_IO);
+			new &= ~PCI_COMMAND_IO;
+		}
 
+		mvebu_writel(port, new, PCIE_CMD_OFF);
 		break;
-	}
 
 	case PCI_IO_BASE:
-		/*
-		 * We keep bit 1 set, it is a read-only bit that
-		 * indicates we support 32 bits addressing for the
-		 * I/O
-		 */
-		conf->iobase |= PCI_IO_RANGE_TYPE_32;
-		conf->iolimit |= PCI_IO_RANGE_TYPE_32;
 		mvebu_pcie_handle_iobase_change(port);
 		break;
 
@@ -516,7 +574,19 @@ mvebu_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 		break;
 
 	case PCI_PRIMARY_BUS:
-		mvebu_pcie_set_local_bus_nr(port, conf->secondary_bus);
+		if (mask & 0xff00)
+			mvebu_pcie_set_local_bus_nr(port, conf->secondary_bus);
+		break;
+
+	case PCI_INTERRUPT_LINE:
+		if (mask & (PCI_BRIDGE_CTL_BUS_RESET << 16)) {
+			u32 ctrl = mvebu_readl(port, PCIE_CTRL_OFF);
+			if (new & (PCI_BRIDGE_CTL_BUS_RESET << 16))
+				ctrl |= PCIE_CTRL_MASTER_HOT_RESET;
+			else
+				ctrl &= ~PCIE_CTRL_MASTER_HOT_RESET;
+			mvebu_writel(port, ctrl, PCIE_CTRL_OFF);
+		}
 		break;
 
 	default:
@@ -532,13 +602,6 @@ mvebu_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 
 	switch (reg) {
 	case PCI_EXP_DEVCTL:
-		/*
-		 * Armada370 data says these bits must always
-		 * be zero when in root complex mode.
-		 */
-		new &= ~(PCI_EXP_DEVCTL_URRE | PCI_EXP_DEVCTL_FERE |
-			 PCI_EXP_DEVCTL_NFERE | PCI_EXP_DEVCTL_CERE);
-
 		mvebu_writel(port, new, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL);
 		break;
 
@@ -555,12 +618,31 @@ mvebu_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 		break;
 
 	case PCI_EXP_RTSTA:
-		mvebu_writel(port, new, PCIE_RC_RTSTA);
+		/*
+		 * PME Status bit in Root Status Register (PCIE_RC_RTSTA)
+		 * is read-only and can be cleared only by writing 0b to the
+		 * Interrupt Cause RW0C register (PCIE_INT_CAUSE_OFF). So
+		 * clear PME via Interrupt Cause.
+		 */
+		if (new & PCI_EXP_RTSTA_PME)
+			mvebu_writel(port, ~PCIE_INT_PM_PME, PCIE_INT_CAUSE_OFF);
+		break;
+
+	case PCI_EXP_DEVCTL2:
+		mvebu_writel(port, new, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL2);
+		break;
+
+	case PCI_EXP_LNKCTL2:
+		mvebu_writel(port, new, PCIE_CAP_PCIEXP + PCI_EXP_LNKCTL2);
+		break;
+
+	default:
 		break;
 	}
 }
 
 static struct pci_bridge_emul_ops mvebu_pci_bridge_emul_ops = {
+	.read_base = mvebu_pci_bridge_emul_base_conf_read,
 	.write_base = mvebu_pci_bridge_emul_base_conf_write,
 	.read_pcie = mvebu_pci_bridge_emul_pcie_conf_read,
 	.write_pcie = mvebu_pci_bridge_emul_pcie_conf_write,
@@ -570,7 +652,7 @@ static struct pci_bridge_emul_ops mvebu_pci_bridge_emul_ops = {
  * Initialize the configuration space of the PCI-to-PCI bridge
  * associated with the given PCIe interface.
  */
-static void mvebu_pci_bridge_emul_init(struct mvebu_pcie_port *port)
+static int mvebu_pci_bridge_emul_init(struct mvebu_pcie_port *port)
 {
 	struct pci_bridge_emul *bridge = &port->bridge;
 	u32 pcie_cap = mvebu_readl(port, PCIE_CAP_PCIEXP);
@@ -597,7 +679,7 @@ static void mvebu_pci_bridge_emul_init(struct mvebu_pcie_port *port)
 	bridge->data = port;
 	bridge->ops = &mvebu_pci_bridge_emul_ops;
 
-	pci_bridge_emul_init(bridge, PCI_BRIDGE_EMUL_NO_PREFETCHABLE_BAR);
+	return pci_bridge_emul_init(bridge, PCI_BRIDGE_EMUL_NO_PREFETCHABLE_BAR);
 }
 
 static inline struct mvebu_pcie *sys_to_pcie(struct pci_sys_data *sys)
@@ -1120,9 +1202,94 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 			continue;
 		}
 
+		ret = mvebu_pci_bridge_emul_init(port);
+		if (ret < 0) {
+			dev_err(dev, "%s: cannot init emulated bridge\n",
+				port->name);
+			devm_iounmap(dev, port->base);
+			port->base = NULL;
+			mvebu_pcie_powerdown(port);
+			continue;
+		}
+
+		/*
+		 * PCIe topology exported by mvebu hw is quite complicated. In
+		 * reality has something like N fully independent host bridges
+		 * where each host bridge has one PCIe Root Port (which acts as
+		 * PCI Bridge device). Each host bridge has its own independent
+		 * internal registers, independent access to PCI config space,
+		 * independent interrupt lines, independent window and memory
+		 * access configuration. But additionally there is some kind of
+		 * peer-to-peer support between PCIe devices behind different
+		 * host bridges limited just to forwarding of memory and I/O
+		 * transactions (forwarding of error messages and config cycles
+		 * is not supported). So we could say there are N independent
+		 * PCIe Root Complexes.
+		 *
+		 * For this kind of setup DT should have been structured into
+		 * N independent PCIe controllers / host bridges. But instead
+		 * structure in past was defined to put PCIe Root Ports of all
+		 * host bridges into one bus zero, like in classic multi-port
+		 * Root Complex setup with just one host bridge.
+		 *
+		 * This means that pci-mvebu.c driver provides "virtual" bus 0
+		 * on which registers all PCIe Root Ports (PCI Bridge devices)
+		 * specified in DT by their BDF addresses and virtually routes
+		 * PCI config access of each PCI bridge device to specific PCIe
+		 * host bridge.
+		 *
+		 * Normally PCI Bridge should choose between Type 0 and Type 1
+		 * config requests based on primary and secondary bus numbers
+		 * configured on the bridge itself. But because mvebu PCI Bridge
+		 * does not have registers for primary and secondary bus numbers
+		 * in its config space, it determinates type of config requests
+		 * via its own custom way.
+		 *
+		 * There are two options how mvebu determinate type of config
+		 * request.
+		 *
+		 * 1. If Secondary Bus Number Enable bit is not set or is not
+		 * available (applies for pre-XP PCIe controllers) then Type 0
+		 * is used if target bus number equals Local Bus Number (bits
+		 * [15:8] in register 0x1a04) and target device number differs
+		 * from Local Device Number (bits [20:16] in register 0x1a04).
+		 * Type 1 is used if target bus number differs from Local Bus
+		 * Number. And when target bus number equals Local Bus Number
+		 * and target device equals Local Device Number then request is
+		 * routed to Local PCI Bridge (PCIe Root Port).
+		 *
+		 * 2. If Secondary Bus Number Enable bit is set (bit 7 in
+		 * register 0x1a2c) then mvebu hw determinate type of config
+		 * request like compliant PCI Bridge based on primary bus number
+		 * which is configured via Local Bus Number (bits [15:8] in
+		 * register 0x1a04) and secondary bus number which is configured
+		 * via Secondary Bus Number (bits [7:0] in register 0x1a2c).
+		 * Local PCI Bridge (PCIe Root Port) is available on primary bus
+		 * as device with Local Device Number (bits [20:16] in register
+		 * 0x1a04).
+		 *
+		 * Secondary Bus Number Enable bit is disabled by default and
+		 * option 2. is not available on pre-XP PCIe controllers. Hence
+		 * this driver always use option 1.
+		 *
+		 * Basically it means that primary and secondary buses shares
+		 * one virtual number configured via Local Bus Number bits and
+		 * Local Device Number bits determinates if accessing primary
+		 * or secondary bus. Set Local Device Number to 1 and redirect
+		 * all writes of PCI Bridge Secondary Bus Number register to
+		 * Local Bus Number (bits [15:8] in register 0x1a04).
+		 *
+		 * So when accessing devices on buses behind secondary bus
+		 * number it would work correctly. And also when accessing
+		 * device 0 at secondary bus number via config space would be
+		 * correctly routed to secondary bus. Due to issues described
+		 * in mvebu_pcie_setup_hw(), PCI Bridges at primary bus (zero)
+		 * are not accessed directly via PCI config space but rarher
+		 * indirectly via kernel emulated PCI bridge driver.
+		 */
 		mvebu_pcie_setup_hw(port);
 		mvebu_pcie_set_local_dev_nr(port, 1);
-		mvebu_pci_bridge_emul_init(port);
+		mvebu_pcie_set_local_bus_nr(port, 0);
 	}
 
 	pcie->nports = i;
diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index 17c59b0d6978..21207df680cc 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -79,6 +79,9 @@
 #define PCIE_ICMD_PM_REG		0x198
 #define PCIE_TURN_OFF_LINK		BIT(4)
 
+#define PCIE_MISC_CTRL_REG		0x348
+#define PCIE_DISABLE_DVFSRC_VLT_REQ	BIT(1)
+
 #define PCIE_TRANS_TABLE_BASE_REG	0x800
 #define PCIE_ATR_SRC_ADDR_MSB_OFFSET	0x4
 #define PCIE_ATR_TRSL_ADDR_LSB_OFFSET	0x8
@@ -297,6 +300,11 @@ static int mtk_pcie_startup_port(struct mtk_pcie_port *port)
 	val &= ~PCIE_INTX_ENABLE;
 	writel_relaxed(val, port->base + PCIE_INT_ENABLE_REG);
 
+	/* Disable DVFSRC voltage request */
+	val = readl_relaxed(port->base + PCIE_MISC_CTRL_REG);
+	val |= PCIE_DISABLE_DVFSRC_VLT_REQ;
+	writel_relaxed(val, port->base + PCIE_MISC_CTRL_REG);
+
 	/* Assert all reset signals */
 	val = readl_relaxed(port->base + PCIE_RST_CTRL_REG);
 	val |= PCIE_MAC_RSTB | PCIE_PHY_RSTB | PCIE_BRG_RSTB | PCIE_PE_RSTB;
diff --git a/drivers/pci/controller/pcie-rcar-host.c b/drivers/pci/controller/pcie-rcar-host.c
index 8f3131844e77..bfb13f358d07 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -52,10 +52,10 @@ struct rcar_msi {
  */
 static void __iomem *pcie_base;
 /*
- * Static copy of bus clock pointer, so we can check whether the clock
- * is enabled or not.
+ * Static copy of PCIe device pointer, so we can check whether the
+ * device is runtime suspended or not.
  */
-static struct clk *pcie_bus_clk;
+static struct device *pcie_dev;
 #endif
 
 /* Structure representing the PCIe interface */
@@ -794,7 +794,7 @@ static int rcar_pcie_get_resources(struct rcar_pcie_host *host)
 #ifdef CONFIG_ARM
 	/* Cache static copy for L1 link state fixup hook on aarch32 */
 	pcie_base = pcie->base;
-	pcie_bus_clk = host->bus_clk;
+	pcie_dev = pcie->dev;
 #endif
 
 	return 0;
@@ -1064,7 +1064,7 @@ static int rcar_pcie_aarch32_abort_handler(unsigned long addr,
 
 	spin_lock_irqsave(&pmsr_lock, flags);
 
-	if (!pcie_base || !__clk_is_enabled(pcie_bus_clk)) {
+	if (!pcie_base || pm_runtime_suspended(pcie_dev)) {
 		ret = 1;
 		goto unlock_exit;
 	}
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
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ca6caba8a191..46e76b5b21ef 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -6010,9 +6010,8 @@ core_initcall(regulator_init);
 static int regulator_late_cleanup(struct device *dev, void *data)
 {
 	struct regulator_dev *rdev = dev_to_rdev(dev);
-	const struct regulator_ops *ops = rdev->desc->ops;
 	struct regulation_constraints *c = rdev->constraints;
-	int enabled, ret;
+	int ret;
 
 	if (c && c->always_on)
 		return 0;
@@ -6025,14 +6024,8 @@ static int regulator_late_cleanup(struct device *dev, void *data)
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
index d5e9a5f2c087..75eabfb916cb 100644
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
 	struct resource *res;
 	const struct fsl_soc_die_attr *soc_die;
@@ -161,8 +160,14 @@ static int fsl_guts_probe(struct platform_device *pdev)
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
@@ -197,7 +202,6 @@ static int fsl_guts_probe(struct platform_device *pdev)
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
diff --git a/drivers/thermal/thermal_netlink.c b/drivers/thermal/thermal_netlink.c
index 1234dbe95895..41c8d47805c4 100644
--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -418,11 +418,12 @@ static int thermal_genl_cmd_tz_get_trip(struct param *p)
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
index 200cd293d14d..810a1b0b6520 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -421,10 +421,22 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
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
index 1b223cba4c2c..3279b4767424 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1829,8 +1829,9 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	spin_lock_irq (&dev->lock);
 	value = -EINVAL;
 	if (dev->buf) {
+		spin_unlock_irq(&dev->lock);
 		kfree(kbuf);
-		goto fail;
+		return value;
 	}
 	dev->buf = kbuf;
 
@@ -1877,8 +1878,8 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 
 	value = usb_gadget_probe_driver(&gadgetfs_driver);
 	if (value != 0) {
-		kfree (dev->buf);
-		dev->buf = NULL;
+		spin_lock_irq(&dev->lock);
+		goto fail;
 	} else {
 		/* at this point "good" hardware has for the first time
 		 * let the USB the host see us.  alternatively, if users
@@ -1895,6 +1896,9 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	return value;
 
 fail:
+	dev->config = NULL;
+	dev->hs_config = NULL;
+	dev->dev = NULL;
 	spin_unlock_irq (&dev->lock);
 	pr_debug ("%s: %s fail %zd, %p\n", shortname, __func__, value, dev);
 	kfree (dev->buf);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ae06ad559353..b46409801647 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -593,6 +593,9 @@ enum {
 	/* Indicate whether there are any tree modification log users */
 	BTRFS_FS_TREE_MOD_LOG_USERS,
 
+	/* Indicate we have half completed snapshot deletions pending. */
+	BTRFS_FS_UNFINISHED_DROPS,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
@@ -1098,8 +1101,15 @@ enum {
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
index 2c3e106a0270..2180fcef56ca 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3659,6 +3659,10 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	set_bit(BTRFS_FS_OPEN, &fs_info->flags);
 
+	/* Kick the cleaner thread so it'll start deleting snapshots. */
+	if (test_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags))
+		wake_up_process(fs_info->cleaner_kthread);
+
 clear_oneshot:
 	btrfs_clear_oneshot_options(fs_info);
 	return 0;
@@ -4340,6 +4344,12 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
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
index 87c23c5c0f26..514adc83577f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5541,6 +5541,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref, int for_reloc)
 	int ret;
 	int level;
 	bool root_dropped = false;
+	bool unfinished_drop = false;
 
 	btrfs_debug(fs_info, "Drop subvolume %llu", root->root_key.objectid);
 
@@ -5583,6 +5584,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref, int for_reloc)
 	 * already dropped.
 	 */
 	set_bit(BTRFS_ROOT_DELETING, &root->state);
+	unfinished_drop = test_bit(BTRFS_ROOT_UNFINISHED_DROP, &root->state);
+
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		level = btrfs_header_level(root->node);
 		path->nodes[level] = btrfs_lock_root_node(root);
@@ -5757,6 +5760,13 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref, int for_reloc)
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
index 250fd3c146ac..50a5cc4fd25b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -6801,14 +6801,24 @@ static void assert_eb_page_uptodate(const struct extent_buffer *eb,
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
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e92f0b0afe9e..58053b5f0ce1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,8 +60,6 @@ struct btrfs_iget_args {
 };
 
 struct btrfs_dio_data {
-	u64 reserve;
-	loff_t length;
 	ssize_t submitted;
 	struct extent_changeset *data_reserved;
 };
@@ -7763,6 +7761,10 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_map *em = *map;
+	int type;
+	u64 block_start, orig_start, orig_block_len, ram_bytes;
+	bool can_nocow = false;
+	bool space_reserved = false;
 	int ret = 0;
 
 	/*
@@ -7777,9 +7779,6 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
 	    ((BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
 	     em->block_start != EXTENT_MAP_HOLE)) {
-		int type;
-		u64 block_start, orig_start, orig_block_len, ram_bytes;
-
 		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
 			type = BTRFS_ORDERED_PREALLOC;
 		else
@@ -7789,53 +7788,92 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 
 		if (can_nocow_extent(inode, start, &len, &orig_start,
 				     &orig_block_len, &ram_bytes, false) == 1 &&
-		    btrfs_inc_nocow_writers(fs_info, block_start)) {
-			struct extent_map *em2;
+		    btrfs_inc_nocow_writers(fs_info, block_start))
+			can_nocow = true;
+	}
 
-			em2 = btrfs_create_dio_extent(BTRFS_I(inode), start, len,
-						      orig_start, block_start,
-						      len, orig_block_len,
-						      ram_bytes, type);
+	if (can_nocow) {
+		struct extent_map *em2;
+
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
 
@@ -7877,18 +7915,6 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
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
 
 
@@ -7981,14 +8007,8 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
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
 
@@ -8018,14 +8038,8 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
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
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 24fb17d5b28f..2c803108ea94 100644
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
index d81bee621d37..a050f9748fa7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3967,6 +3967,19 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
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
index db37a3799649..1fa0e5e2e350 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -280,6 +280,21 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 
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
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f1ae5a5b79c6..9a6009108ea5 100644
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
@@ -1310,6 +1340,32 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
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
@@ -1322,7 +1378,12 @@ void btrfs_add_dead_root(struct btrfs_root *root)
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
@@ -2014,16 +2075,24 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
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
index b79da8917cbf..8ef65073ce8c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1329,6 +1329,15 @@ static int unlink_old_inode_refs(struct btrfs_trans_handle *trans,
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
@@ -1580,6 +1589,15 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
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
@@ -4423,7 +4441,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 
 /*
  * Log all prealloc extents beyond the inode's i_size to make sure we do not
- * lose them after doing a fast fsync and replaying the log. We scan the
+ * lose them after doing a full/fast fsync and replaying the log. We scan the
  * subvolume's root instead of iterating the inode's extent map tree because
  * otherwise we can log incorrect extent items based on extent map conversion.
  * That can happen due to the fact that extent maps are merged when they
@@ -5208,6 +5226,7 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 				   struct btrfs_log_ctx *ctx,
 				   bool *need_log_inode_item)
 {
+	const u64 i_size = i_size_read(&inode->vfs_inode);
 	struct btrfs_root *root = inode->root;
 	int ins_start_slot = 0;
 	int ins_nr = 0;
@@ -5228,13 +5247,21 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
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
 
@@ -5265,10 +5292,8 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
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
@@ -5321,9 +5346,21 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
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
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 905a901f7f80..248a8f973cf9 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -414,12 +414,14 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				   from_kuid(&init_user_ns, ses->linux_uid),
 				   from_kuid(&init_user_ns, ses->cred_uid));
 
+			spin_lock(&ses->chan_lock);
 			if (ses->chan_count > 1) {
 				seq_printf(m, "\n\n\tExtra Channels: %zu ",
 					   ses->chan_count-1);
 				for (j = 1; j < ses->chan_count; j++)
 					cifs_dump_channel(m, j, &ses->chans[j]);
 			}
+			spin_unlock(&ses->chan_lock);
 
 			seq_puts(m, "\n\n\tShares: ");
 			j = 0;
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
index 9fa930dfd78d..21bf82fc2278 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -909,6 +909,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 
 out_super:
 	deactivate_locked_super(sb);
+	return root;
 out:
 	if (cifs_sb) {
 		kfree(cifs_sb->prepath);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3e5b8e177cfa..b33835b2943e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -934,16 +934,21 @@ struct cifs_ses {
 	 * iface_lock should be taken when accessing any of these fields
 	 */
 	spinlock_t iface_lock;
+	/* ========= begin: protected by iface_lock ======== */
 	struct cifs_server_iface *iface_list;
 	size_t iface_count;
 	unsigned long iface_last_update; /* jiffies */
+	/* ========= end: protected by iface_lock ======== */
 
+	spinlock_t chan_lock;
+	/* ========= begin: protected by chan_lock ======== */
 #define CIFS_MAX_CHANNELS 16
 	struct cifs_chan chans[CIFS_MAX_CHANNELS];
 	struct cifs_chan *binding_chan;
 	size_t chan_count;
 	size_t chan_max;
 	atomic_t chan_seq; /* round robin state */
+	/* ========= end: protected by chan_lock ======== */
 };
 
 /*
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 439f02f1886c..70da1d27be3d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1526,8 +1526,12 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	 * If an existing session is limited to less channels than
 	 * requested, it should not be reused
 	 */
-	if (ses->chan_max < ctx->max_channels)
+	spin_lock(&ses->chan_lock);
+	if (ses->chan_max < ctx->max_channels) {
+		spin_unlock(&ses->chan_lock);
 		return 0;
+	}
+	spin_unlock(&ses->chan_lock);
 
 	switch (ses->sectype) {
 	case Kerberos:
@@ -1662,6 +1666,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 void cifs_put_smb_ses(struct cifs_ses *ses)
 {
 	unsigned int rc, xid;
+	unsigned int chan_count;
 	struct TCP_Server_Info *server = ses->server;
 	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
 
@@ -1703,12 +1708,24 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	list_del_init(&ses->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	spin_lock(&ses->chan_lock);
+	chan_count = ses->chan_count;
+	spin_unlock(&ses->chan_lock);
+
 	/* close any extra channels */
-	if (ses->chan_count > 1) {
+	if (chan_count > 1) {
 		int i;
 
-		for (i = 1; i < ses->chan_count; i++)
+		for (i = 1; i < chan_count; i++) {
+			/*
+			 * note: for now, we're okay accessing ses->chans
+			 * without chan_lock. But when chans can go away, we'll
+			 * need to introduce ref counting to make sure that chan
+			 * is not freed from under us.
+			 */
 			cifs_put_tcp_session(ses->chans[i].server, 0);
+			ses->chans[i].server = NULL;
+		}
 	}
 
 	sesInfoFree(ses);
@@ -1959,9 +1976,11 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	mutex_lock(&ses->session_mutex);
 
 	/* add server as first channel */
+	spin_lock(&ses->chan_lock);
 	ses->chans[0].server = server;
 	ses->chan_count = 1;
 	ses->chan_max = ctx->multichannel ? ctx->max_channels:1;
+	spin_unlock(&ses->chan_lock);
 
 	rc = cifs_negotiate_protocol(xid, ses);
 	if (!rc)
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index bb1185fff8cc..0a0d0724c429 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -75,6 +75,7 @@ sesInfoAlloc(void)
 		INIT_LIST_HEAD(&ret_buf->tcon_list);
 		mutex_init(&ret_buf->session_mutex);
 		spin_lock_init(&ret_buf->iface_lock);
+		spin_lock_init(&ret_buf->chan_lock);
 	}
 	return ret_buf;
 }
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 23e02db7923f..5500ea783784 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -54,32 +54,43 @@ bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface)
 {
 	int i;
 
+	spin_lock(&ses->chan_lock);
 	for (i = 0; i < ses->chan_count; i++) {
-		if (is_server_using_iface(ses->chans[i].server, iface))
+		if (is_server_using_iface(ses->chans[i].server, iface)) {
+			spin_unlock(&ses->chan_lock);
 			return true;
+		}
 	}
+	spin_unlock(&ses->chan_lock);
 	return false;
 }
 
 /* returns number of channels added */
 int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 {
-	int old_chan_count = ses->chan_count;
-	int left = ses->chan_max - ses->chan_count;
+	int old_chan_count, new_chan_count;
+	int left;
 	int i = 0;
 	int rc = 0;
 	int tries = 0;
 	struct cifs_server_iface *ifaces = NULL;
 	size_t iface_count;
 
+	spin_lock(&ses->chan_lock);
+
+	new_chan_count = old_chan_count = ses->chan_count;
+	left = ses->chan_max - ses->chan_count;
+
 	if (left <= 0) {
 		cifs_dbg(FYI,
 			 "ses already at max_channels (%zu), nothing to open\n",
 			 ses->chan_max);
+		spin_unlock(&ses->chan_lock);
 		return 0;
 	}
 
 	if (ses->server->dialect < SMB30_PROT_ID) {
+		spin_unlock(&ses->chan_lock);
 		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.0 or above\n");
 		return 0;
 	}
@@ -87,8 +98,10 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	if (!(ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
 		cifs_dbg(VFS, "server %s does not support multichannel\n", ses->server->hostname);
 		ses->chan_max = 1;
+		spin_unlock(&ses->chan_lock);
 		return 0;
 	}
+	spin_unlock(&ses->chan_lock);
 
 	/*
 	 * Make a copy of the iface list at the time and use that
@@ -142,10 +155,11 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 		cifs_dbg(FYI, "successfully opened new channel on iface#%d\n",
 			 i);
 		left--;
+		new_chan_count++;
 	}
 
 	kfree(ifaces);
-	return ses->chan_count - old_chan_count;
+	return new_chan_count - old_chan_count;
 }
 
 /*
@@ -157,10 +171,14 @@ cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server)
 {
 	int i;
 
+	spin_lock(&ses->chan_lock);
 	for (i = 0; i < ses->chan_count; i++) {
-		if (ses->chans[i].server == server)
+		if (ses->chans[i].server == server) {
+			spin_unlock(&ses->chan_lock);
 			return &ses->chans[i];
+		}
 	}
+	spin_unlock(&ses->chan_lock);
 	return NULL;
 }
 
@@ -168,6 +186,7 @@ static int
 cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 		     struct cifs_server_iface *iface)
 {
+	struct TCP_Server_Info *chan_server;
 	struct cifs_chan *chan;
 	struct smb3_fs_context ctx = {NULL};
 	static const char unc_fmt[] = "\\%s\\foo";
@@ -240,15 +259,20 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	       SMB2_CLIENT_GUID_SIZE);
 	ctx.use_client_guid = true;
 
-	mutex_lock(&ses->session_mutex);
+	chan_server = cifs_get_tcp_session(&ctx);
 
+	mutex_lock(&ses->session_mutex);
+	spin_lock(&ses->chan_lock);
 	chan = ses->binding_chan = &ses->chans[ses->chan_count];
-	chan->server = cifs_get_tcp_session(&ctx);
+	chan->server = chan_server;
 	if (IS_ERR(chan->server)) {
 		rc = PTR_ERR(chan->server);
 		chan->server = NULL;
+		spin_unlock(&ses->chan_lock);
 		goto out;
 	}
+	spin_unlock(&ses->chan_lock);
+
 	spin_lock(&cifs_tcp_ses_lock);
 	chan->server->is_channel = true;
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -283,8 +307,11 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	 * ses to the new server.
 	 */
 
+	spin_lock(&ses->chan_lock);
 	ses->chan_count++;
 	atomic_set(&ses->chan_seq, 0);
+	spin_unlock(&ses->chan_lock);
+
 out:
 	ses->binding = false;
 	ses->binding_chan = NULL;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b7379329b741..61ea3d3f95b4 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1044,14 +1044,17 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 	if (!ses)
 		return NULL;
 
+	spin_lock(&ses->chan_lock);
 	if (!ses->binding) {
 		/* round robin */
 		if (ses->chan_count > 1) {
 			index = (uint)atomic_inc_return(&ses->chan_seq);
 			index %= ses->chan_count;
 		}
+		spin_unlock(&ses->chan_lock);
 		return ses->chans[index].server;
 	} else {
+		spin_unlock(&ses->chan_lock);
 		return cifs_ses_server(ses);
 	}
 }
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
index 7ebc816ae39f..db981619f6c8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1724,9 +1724,9 @@ struct ext4_sb_info {
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
@@ -1746,7 +1746,7 @@ struct ext4_sb_info {
 	spinlock_t s_fc_lock;
 	struct buffer_head *s_fc_bh;
 	struct ext4_fc_stats s_fc_stats;
-	u64 s_fc_avg_commit_time;
+	tid_t s_fc_ineligible_tid;
 #ifdef CONFIG_EXT4_DEBUG
 	int s_fc_debug_max_replay;
 #endif
@@ -1792,10 +1792,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
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
@@ -2924,9 +2921,7 @@ void __ext4_fc_track_create(handle_t *handle, struct inode *inode,
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
index c35cb6d9b7b5..b81c008e6675 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5340,7 +5340,7 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		ret = PTR_ERR(handle);
 		goto out_mmap;
 	}
-	ext4_fc_start_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_discard_preallocations(inode, 0);
@@ -5379,7 +5379,6 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 
 out_stop:
 	ext4_journal_stop(handle);
-	ext4_fc_stop_ineligible(sb);
 out_mmap:
 	filemap_invalidate_unlock(mapping);
 out_mutex:
@@ -5481,7 +5480,7 @@ static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 		ret = PTR_ERR(handle);
 		goto out_mmap;
 	}
-	ext4_fc_start_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	/* Expand file to avoid data loss if there is error while shifting */
 	inode->i_size += len;
@@ -5556,7 +5555,6 @@ static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 
 out_stop:
 	ext4_journal_stop(handle);
-	ext4_fc_stop_ineligible(sb);
 out_mmap:
 	filemap_invalidate_unlock(mapping);
 out_mutex:
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 7bcd3be07ee4..285c91b0166c 100644
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
 
@@ -928,7 +896,6 @@ static int ext4_fc_submit_inode_data_all(journal_t *journal)
 	int ret = 0;
 
 	spin_lock(&sbi->s_fc_lock);
-	ext4_set_mount_flag(sb, EXT4_MF_FC_COMMITTING);
 	list_for_each_entry(ei, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		ext4_set_inode_state(&ei->vfs_inode, EXT4_STATE_FC_COMMITTING);
 		while (atomic_read(&ei->i_fc_updates)) {
@@ -1121,6 +1088,32 @@ static int ext4_fc_perform_commit(journal_t *journal)
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
@@ -1133,18 +1126,15 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
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
@@ -1153,74 +1143,59 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
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
@@ -1238,7 +1213,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full)
 		list_del_init(&iter->i_fc_list);
 		ext4_clear_inode_state(&iter->vfs_inode,
 				       EXT4_STATE_FC_COMMITTING);
-		ext4_fc_reset_inode(&iter->vfs_inode);
+		if (iter->i_sync_tid <= tid)
+			ext4_fc_reset_inode(&iter->vfs_inode);
 		/* Make sure EXT4_STATE_FC_COMMITTING bit is clear */
 		smp_mb();
 #if (BITS_PER_LONG < 64)
@@ -1267,8 +1243,10 @@ static void ext4_fc_cleanup(journal_t *journal, int full)
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
@@ -2174,7 +2152,7 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
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
index b6746cc86cee..22a5140546fb 100644
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
 
@@ -5969,7 +5969,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
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
index da7698341d7d..192ea90e757c 100644
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
index 877c5c17e61f..fd4d34deb9fc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4613,14 +4613,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
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
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cdfb1ae78a3f..54c4e0b0dda4 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -409,10 +409,11 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end)
 	struct vm_area_struct *vma;
 
 	/*
-	 * end == 0 indicates that the entire range after
-	 * start should be unmapped.
+	 * end == 0 indicates that the entire range after start should be
+	 * unmapped.  Note, end is exclusive, whereas the interval tree takes
+	 * an inclusive "last".
 	 */
-	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
+	vma_interval_tree_foreach(vma, root, start, end ? end - 1 : ULONG_MAX) {
 		unsigned long v_offset;
 		unsigned long v_end;
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d7e49e87b49b..156c54ebb62b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6573,11 +6573,14 @@ static bool io_drain_req(struct io_kiocb *req)
 	}
 
 	/* Still need defer if there is pending req in defer list. */
+	spin_lock(&ctx->completion_lock);
 	if (likely(list_empty_careful(&ctx->defer_list) &&
 		!(req->flags & REQ_F_IO_DRAIN))) {
+		spin_unlock(&ctx->completion_lock);
 		ctx->drain_active = false;
 		return false;
 	}
+	spin_unlock(&ctx->completion_lock);
 
 	seq = io_get_sequence(req);
 	/* Still a chance to pass the sequence check */
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
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 9918d6ad23ec..b540489ea240 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -210,17 +210,12 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 
 	fh_copy(&resp->fh, &argp->fh);
 	resp->committed = argp->stable;
-	nvecs = svc_fill_write_vector(rqstp, rqstp->rq_arg.pages,
-				      &argp->first, cnt);
-	if (!nvecs) {
-		resp->status = nfserr_io;
-		goto out;
-	}
+	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
+
 	resp->status = nfsd_write(rqstp, &resp->fh, argp->offset,
 				  rqstp->rq_vec, nvecs, &cnt,
 				  resp->committed, resp->verf);
 	resp->count = cnt;
-out:
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 7a900131d20c..48d4f99b7f90 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -487,11 +487,6 @@ svcxdr_encode_wcc_data(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	return true;
 }
 
-static bool fs_supports_change_attribute(struct super_block *sb)
-{
-	return sb->s_flags & SB_I_VERSION || sb->s_export_op->fetch_iversion;
-}
-
 /*
  * Fill in the pre_op attr for the wcc data
  */
@@ -500,26 +495,24 @@ void fill_pre_wcc(struct svc_fh *fhp)
 	struct inode    *inode;
 	struct kstat	stat;
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
+	__be32 err;
 
 	if (fhp->fh_no_wcc || fhp->fh_pre_saved)
 		return;
 	inode = d_inode(fhp->fh_dentry);
-	if (fs_supports_change_attribute(inode->i_sb) || !v4) {
-		__be32 err = fh_getattr(fhp, &stat);
-
-		if (err) {
-			/* Grab the times from inode anyway */
-			stat.mtime = inode->i_mtime;
-			stat.ctime = inode->i_ctime;
-			stat.size  = inode->i_size;
-		}
-		fhp->fh_pre_mtime = stat.mtime;
-		fhp->fh_pre_ctime = stat.ctime;
-		fhp->fh_pre_size  = stat.size;
+	err = fh_getattr(fhp, &stat);
+	if (err) {
+		/* Grab the times from inode anyway */
+		stat.mtime = inode->i_mtime;
+		stat.ctime = inode->i_ctime;
+		stat.size  = inode->i_size;
 	}
 	if (v4)
 		fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
 
+	fhp->fh_pre_mtime = stat.mtime;
+	fhp->fh_pre_ctime = stat.ctime;
+	fhp->fh_pre_size  = stat.size;
 	fhp->fh_pre_saved = true;
 }
 
@@ -530,6 +523,7 @@ void fill_post_wcc(struct svc_fh *fhp)
 {
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
 	struct inode *inode = d_inode(fhp->fh_dentry);
+	__be32 err;
 
 	if (fhp->fh_no_wcc)
 		return;
@@ -537,16 +531,12 @@ void fill_post_wcc(struct svc_fh *fhp)
 	if (fhp->fh_post_saved)
 		printk("nfsd: inode locked twice during operation.\n");
 
-	fhp->fh_post_saved = true;
-
-	if (fs_supports_change_attribute(inode->i_sb) || !v4) {
-		__be32 err = fh_getattr(fhp, &fhp->fh_post_attr);
-
-		if (err) {
-			fhp->fh_post_saved = false;
-			fhp->fh_post_attr.ctime = inode->i_ctime;
-		}
-	}
+	err = fh_getattr(fhp, &fhp->fh_post_attr);
+	if (err) {
+		fhp->fh_post_saved = false;
+		fhp->fh_post_attr.ctime = inode->i_ctime;
+	} else
+		fhp->fh_post_saved = true;
 	if (v4)
 		fhp->fh_post_change =
 			nfsd4_change_attribute(&fhp->fh_post_attr, inode);
@@ -621,9 +611,6 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_writeargs *args = rqstp->rq_argp;
 	u32 max_blocksize = svc_max_payload(rqstp);
-	struct kvec *head = rqstp->rq_arg.head;
-	struct kvec *tail = rqstp->rq_arg.tail;
-	size_t remaining;
 
 	if (!svcxdr_decode_nfs_fh3(xdr, &args->fh))
 		return 0;
@@ -641,17 +628,12 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 	/* request sanity */
 	if (args->count != args->len)
 		return 0;
-	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
-	remaining -= xdr_stream_pos(xdr);
-	if (remaining < xdr_align_size(args->len))
-		return 0;
 	if (args->count > max_blocksize) {
 		args->count = max_blocksize;
 		args->len = max_blocksize;
 	}
-
-	args->first.iov_base = xdr->p;
-	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
+	if (!xdr_stream_subsegment(xdr, &args->payload, args->count))
+		return 0;
 
 	return 1;
 }
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 4b9a3b90a41f..65200910107f 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1038,8 +1038,7 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	write->wr_how_written = write->wr_stable_how;
 
-	nvecs = svc_fill_write_vector(rqstp, write->wr_payload.pages,
-				      write->wr_payload.head, write->wr_buflen);
+	nvecs = svc_fill_write_vector(rqstp, &write->wr_payload);
 	WARN_ON_ONCE(nvecs > ARRAY_SIZE(rqstp->rq_vec));
 
 	status = nfsd_vfs_write(rqstp, &cstate->current_fh, nf,
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 97090ddcfc94..db4a47a280dc 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6042,7 +6042,11 @@ nfs4_preprocess_stateid_op(struct svc_rqst *rqstp,
 		*nfp = NULL;
 
 	if (ZERO_STATEID(stateid) || ONE_STATEID(stateid)) {
-		status = check_special_stateids(net, fhp, stateid, flags);
+		if (cstid)
+			status = nfserr_bad_stateid;
+		else
+			status = check_special_stateids(net, fhp, stateid,
+									flags);
 		goto done;
 	}
 
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 19c568b8a527..312fd289be58 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -234,12 +234,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		SVCFH_fmt(&argp->fh),
 		argp->len, argp->offset);
 
-	nvecs = svc_fill_write_vector(rqstp, rqstp->rq_arg.pages,
-				      &argp->first, cnt);
-	if (!nvecs) {
-		resp->status = nfserr_io;
-		goto out;
-	}
+	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
 
 	resp->status = nfsd_write(rqstp, fh_copy(&resp->fh, &argp->fh),
 				  argp->offset, rqstp->rq_vec, nvecs,
@@ -248,7 +243,6 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
 		return rpc_drop_reply;
-out:
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index a06c05fe3b42..26a42f87c240 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -325,10 +325,7 @@ nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_writeargs *args = rqstp->rq_argp;
-	struct kvec *head = rqstp->rq_arg.head;
-	struct kvec *tail = rqstp->rq_arg.tail;
 	u32 beginoffset, totalcount;
-	size_t remaining;
 
 	if (!svcxdr_decode_fhandle(xdr, &args->fh))
 		return 0;
@@ -346,12 +343,8 @@ nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 		return 0;
 	if (args->len > NFSSVC_MAXBLKSIZE_V2)
 		return 0;
-	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
-	remaining -= xdr_stream_pos(xdr);
-	if (remaining < xdr_align_size(args->len))
+	if (!xdr_stream_subsegment(xdr, &args->payload, args->len))
 		return 0;
-	args->first.iov_base = xdr->p;
-	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
 
 	return 1;
 }
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 78df03843412..271f7c15d6e5 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -993,6 +993,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
 	if (flags & RWF_SYNC) {
 		down_write(&nf->nf_rwsem);
+		if (verf)
+			nfsd_copy_boot_verifier(verf,
+					net_generic(SVC_NET(rqstp),
+					nfsd_net_id));
 		host_err = vfs_iter_write(file, &iter, &pos, flags);
 		if (host_err < 0)
 			nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index f45b4bc93f52..80fd6d7f3404 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -33,7 +33,7 @@ struct nfsd_writeargs {
 	svc_fh			fh;
 	__u32			offset;
 	int			len;
-	struct kvec		first;
+	struct xdr_buf		payload;
 };
 
 struct nfsd_createargs {
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 933008382bbe..712c117300cb 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -40,7 +40,7 @@ struct nfsd3_writeargs {
 	__u32			count;
 	int			stable;
 	__u32			len;
-	struct kvec		first;
+	struct xdr_buf		payload;
 };
 
 struct nfsd3_createargs {
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 958fce7aee63..79ca4d69dfd6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1582,7 +1582,8 @@ static const struct mm_walk_ops pagemap_ops = {
  * Bits 5-54  swap offset if swapped
  * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
  * Bit  56    page exclusively mapped
- * Bits 57-60 zero
+ * Bit  57    pte is uffd-wp write-protected
+ * Bits 58-60 zero
  * Bit  61    page is file-page or shared-anon
  * Bit  62    page swapped
  * Bit  63    page present
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 849524b55d89..3fad741df53e 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -94,7 +94,7 @@ struct ethtool_link_ext_state_info {
 		enum ethtool_link_ext_substate_link_logical_mismatch link_logical_mismatch;
 		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
 		enum ethtool_link_ext_substate_cable_issue cable_issue;
-		u8 __link_ext_substate;
+		u32 __link_ext_substate;
 	};
 };
 
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1611dc9d4420..a9956b681f09 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -554,9 +554,9 @@ struct bpf_binary_header {
 };
 
 struct bpf_prog_stats {
-	u64 cnt;
-	u64 nsecs;
-	u64 misses;
+	u64_stats_t cnt;
+	u64_stats_t nsecs;
+	u64_stats_t misses;
 	struct u64_stats_sync syncp;
 } __aligned(2 * sizeof(u64));
 
@@ -618,8 +618,8 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
 		stats = this_cpu_ptr(prog->stats);
 		flags = u64_stats_update_begin_irqsave(&stats->syncp);
-		stats->cnt++;
-		stats->nsecs += sched_clock() - start;
+		u64_stats_inc(&stats->cnt);
+		u64_stats_add(&stats->nsecs, sched_clock() - start);
 		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	} else {
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
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
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index dd874a1ee862..f407e937241a 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -461,12 +461,12 @@ static inline void kasan_release_vmalloc(unsigned long start,
  * allocations with real shadow memory. With KASAN vmalloc, the special
  * case is unnecessary, as the work is handled in the generic case.
  */
-int kasan_module_alloc(void *addr, size_t size);
+int kasan_module_alloc(void *addr, size_t size, gfp_t gfp_mask);
 void kasan_free_shadow(const struct vm_struct *vm);
 
 #else /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
 
-static inline int kasan_module_alloc(void *addr, size_t size) { return 0; }
+static inline int kasan_module_alloc(void *addr, size_t size, gfp_t gfp_mask) { return 0; }
 static inline void kasan_free_shadow(const struct vm_struct *vm) {}
 
 #endif /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index daef3b0d9270..55460ecfa50a 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -8,7 +8,7 @@
 
 #include <linux/phy.h>
 
-#ifdef CONFIG_OF_NET
+#if defined(CONFIG_OF) && defined(CONFIG_NET)
 #include <linux/of.h>
 
 struct net_device;
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
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 064c96157d1f..6263410c948a 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -532,8 +532,7 @@ int		   svc_encode_result_payload(struct svc_rqst *rqstp,
 					     unsigned int offset,
 					     unsigned int length);
 unsigned int	   svc_fill_write_vector(struct svc_rqst *rqstp,
-					 struct page **pages,
-					 struct kvec *first, size_t total);
+					 struct xdr_buf *payload);
 char		  *svc_fill_symlink_pathname(struct svc_rqst *rqstp,
 					     struct kvec *first, void *p,
 					     size_t total);
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 671d402c3778..4fe9e885bbfa 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -28,6 +28,13 @@ struct notifier_block;		/* in notifier.h */
 #define VM_MAP_PUT_PAGES	0x00000200	/* put pages and free array in vfree */
 #define VM_NO_HUGE_VMAP		0x00000400	/* force PAGE_SIZE pte mapping */
 
+#if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
+	!defined(CONFIG_KASAN_VMALLOC)
+#define VM_DEFER_KMEMLEAK	0x00000800	/* defer kmemleak object creation */
+#else
+#define VM_DEFER_KMEMLEAK	0
+#endif
+
 /*
  * VM_KASAN is used slightly differently depending on CONFIG_KASAN_VMALLOC.
  *
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 38e4094960ce..e97ef508664f 100644
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
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index daaf407e9e49..7c48613c1830 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1727,10 +1727,11 @@ TRACE_EVENT(svc_xprt_create_err,
 		const char *program,
 		const char *protocol,
 		struct sockaddr *sap,
+		size_t salen,
 		const struct svc_xprt *xprt
 	),
 
-	TP_ARGS(program, protocol, sap, xprt),
+	TP_ARGS(program, protocol, sap, salen, xprt),
 
 	TP_STRUCT__entry(
 		__field(long, error)
@@ -1743,7 +1744,7 @@ TRACE_EVENT(svc_xprt_create_err,
 		__entry->error = PTR_ERR(xprt);
 		__assign_str(program, program);
 		__assign_str(protocol, protocol);
-		memcpy(__entry->addr, sap, sizeof(__entry->addr));
+		memcpy(__entry->addr, sap, min(salen, sizeof(__entry->addr)));
 	),
 
 	TP_printk("addr=%pISpc program=%s protocol=%s error=%ld",
@@ -2111,17 +2112,17 @@ DECLARE_EVENT_CLASS(svcsock_accept_class,
 	TP_STRUCT__entry(
 		__field(long, status)
 		__string(service, service)
-		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+		__field(unsigned int, netns_ino)
 	),
 
 	TP_fast_assign(
 		__entry->status = status;
 		__assign_str(service, service);
-		memcpy(__entry->addr, &xprt->xpt_local, sizeof(__entry->addr));
+		__entry->netns_ino = xprt->xpt_net->ns.inum;
 	),
 
-	TP_printk("listener=%pISpc service=%s status=%ld",
-		__entry->addr, __get_str(service), __entry->status
+	TP_printk("addr=listener service=%s status=%ld",
+		__get_str(service), __entry->status
 	)
 );
 
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
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 53384622e8da..42490c39dfbf 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1824,8 +1824,14 @@ static int bpf_prog_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+struct bpf_prog_kstats {
+	u64 nsecs;
+	u64 cnt;
+	u64 misses;
+};
+
 static void bpf_prog_get_stats(const struct bpf_prog *prog,
-			       struct bpf_prog_stats *stats)
+			       struct bpf_prog_kstats *stats)
 {
 	u64 nsecs = 0, cnt = 0, misses = 0;
 	int cpu;
@@ -1838,9 +1844,9 @@ static void bpf_prog_get_stats(const struct bpf_prog *prog,
 		st = per_cpu_ptr(prog->stats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&st->syncp);
-			tnsecs = st->nsecs;
-			tcnt = st->cnt;
-			tmisses = st->misses;
+			tnsecs = u64_stats_read(&st->nsecs);
+			tcnt = u64_stats_read(&st->cnt);
+			tmisses = u64_stats_read(&st->misses);
 		} while (u64_stats_fetch_retry_irq(&st->syncp, start));
 		nsecs += tnsecs;
 		cnt += tcnt;
@@ -1856,7 +1862,7 @@ static void bpf_prog_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_prog *prog = filp->private_data;
 	char prog_tag[sizeof(prog->tag) * 2 + 1] = { };
-	struct bpf_prog_stats stats;
+	struct bpf_prog_kstats stats;
 
 	bpf_prog_get_stats(prog, &stats);
 	bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
@@ -3595,7 +3601,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	struct bpf_prog_info __user *uinfo = u64_to_user_ptr(attr->info.info);
 	struct bpf_prog_info info;
 	u32 info_len = attr->info.info_len;
-	struct bpf_prog_stats stats;
+	struct bpf_prog_kstats stats;
 	char __user *uinsns;
 	u32 ulen;
 	int err;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index d3a307a8c42b..2660fbced9ad 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -541,11 +541,12 @@ static u64 notrace bpf_prog_start_time(void)
 static void notrace inc_misses_counter(struct bpf_prog *prog)
 {
 	struct bpf_prog_stats *stats;
+	unsigned int flags;
 
 	stats = this_cpu_ptr(prog->stats);
-	u64_stats_update_begin(&stats->syncp);
-	stats->misses++;
-	u64_stats_update_end(&stats->syncp);
+	flags = u64_stats_update_begin_irqsave(&stats->syncp);
+	u64_stats_inc(&stats->misses);
+	u64_stats_update_end_irqrestore(&stats->syncp, flags);
 }
 
 /* The logic is similar to bpf_prog_run(), but with an explicit
@@ -589,8 +590,8 @@ static void notrace update_prog_stats(struct bpf_prog *prog,
 
 		stats = this_cpu_ptr(prog->stats);
 		flags = u64_stats_update_begin_irqsave(&stats->syncp);
-		stats->cnt++;
-		stats->nsecs += sched_clock() - start;
+		u64_stats_inc(&stats->cnt);
+		u64_stats_add(&stats->nsecs, sched_clock() - start);
 		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	}
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 28aee1a8875b..89475c994ca9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2296,6 +2296,17 @@ static __latent_entropy struct task_struct *copy_process(
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
@@ -2405,7 +2416,7 @@ static __latent_entropy struct task_struct *copy_process(
 		fd_install(pidfd, pidfile);
 
 	proc_fork_connector(p);
-	sched_post_fork(p, args);
+	sched_post_fork(p);
 	cgroup_post_fork(p, args);
 	perf_event_fork(p);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c2dec6ce9809..a0747eaa2dba 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4376,6 +4376,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	init_entity_runnable_average(&p->se);
 
+
 #ifdef CONFIG_SCHED_INFO
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -4391,18 +4392,23 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
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
@@ -4413,7 +4419,10 @@ void sched_post_fork(struct task_struct *p, struct kernel_clone_args *kargs)
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+}
 
+void sched_post_fork(struct task_struct *p)
+{
 	uclamp_post_fork(p);
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index aea93d6a5520..6e3dbb3d1217 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2710,19 +2710,19 @@ bool get_signal(struct ksignal *ksig)
 		goto relock;
 	}
 
-	/* Has this task already been marked for death? */
-	if (signal_group_exit(signal)) {
-		ksig->info.si_signo = signr = SIGKILL;
-		sigdelset(&current->pending.signal, SIGKILL);
-		trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
-				&sighand->action[SIGKILL - 1]);
-		recalc_sigpending();
-		goto fatal;
-	}
-
 	for (;;) {
 		struct k_sigaction *ka;
 
+		/* Has this task already been marked for death? */
+		if (signal_group_exit(signal)) {
+			ksig->info.si_signo = signr = SIGKILL;
+			sigdelset(&current->pending.signal, SIGKILL);
+			trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
+				&sighand->action[SIGKILL - 1]);
+			recalc_sigpending();
+			goto fatal;
+		}
+
 		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
 		    do_signal_stop(0))
 			goto relock;
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index fa91f398f28b..c42ff77eb6cc 100644
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
 
@@ -1615,7 +1625,7 @@ static int blk_trace_remove_queue(struct request_queue *q)
 
 	put_probe_ref();
 	synchronize_rcu();
-	blk_trace_free(bt);
+	blk_trace_free(q, bt);
 	return 0;
 }
 
@@ -1646,7 +1656,7 @@ static int blk_trace_setup_queue(struct request_queue *q,
 	return 0;
 
 free_bt:
-	blk_trace_free(bt);
+	blk_trace_free(q, bt);
 	return ret;
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 618c20ce2479..86fb77c2ace5 100644
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
index 918f969dffcf..ea168d42c8a2 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2049,9 +2049,9 @@ parse_field(struct hist_trigger_data *hist_data, struct trace_event_file *file,
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
@@ -4478,7 +4478,7 @@ static int create_tracing_map_fields(struct hist_trigger_data *hist_data)
 
 			if (hist_field->flags & HIST_FIELD_FL_STACKTRACE)
 				cmp_fn = tracing_map_cmp_none;
-			else if (!field)
+			else if (!field || hist_field->flags & HIST_FIELD_FL_CPU)
 				cmp_fn = tracing_map_cmp_num(hist_field->size,
 							     hist_field->is_signed);
 			else if (is_string_field(field))
diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 22db3ce95e74..8c26092db8de 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -2053,6 +2053,13 @@ static int create_synth_event(const char *raw_command)
 
 	last_cmd_set(raw_command);
 
+	name = raw_command;
+
+	/* Don't try to process if not our system */
+	if (name[0] != 's' || name[1] != ':')
+		return -ECANCELED;
+	name += 2;
+
 	p = strpbrk(raw_command, " \t");
 	if (!p) {
 		synth_err(SYNTH_ERR_INVALID_CMD, 0);
@@ -2061,12 +2068,6 @@ static int create_synth_event(const char *raw_command)
 
 	fields = skip_spaces(p);
 
-	name = raw_command;
-
-	if (name[0] != 's' || name[1] != ':')
-		return -ECANCELED;
-	name += 2;
-
 	/* This interface accepts group name prefix */
 	if (strchr(name, '/')) {
 		len = str_has_prefix(name, SYNTH_SYSTEM "/");
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 385981c293ba..39ee60725519 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -31,7 +31,7 @@ static int __init set_kprobe_boot_events(char *str)
 	strlcpy(kprobe_boot_events_buf, str, COMMAND_LINE_SIZE);
 	disable_tracing_selftest("running kprobe events");
 
-	return 0;
+	return 1;
 }
 __setup("kprobe_event=", set_kprobe_boot_events);
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 3ed2a3f37297..bb4605b60de7 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -356,6 +356,8 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 		return -EINVAL;
 	}
 	*pbuf = kstrndup(str, len - 1, GFP_KERNEL);
+	if (!*pbuf)
+		return -ENOMEM;
 	return 0;
 }
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index f5f0039d31e5..78ec1c16ccf4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1619,6 +1619,11 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 	tu->path = path;
 	tu->ref_ctr_offset = ref_ctr_offset;
 	tu->filename = kstrdup(name, GFP_KERNEL);
+	if (!tu->filename) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	init_trace_event_call(tu);
 
 	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
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
diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index d8ccff4c1275..47ed4fc33a29 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -132,11 +132,22 @@ static void *qlink_to_object(struct qlist_node *qlink, struct kmem_cache *cache)
 static void qlink_free(struct qlist_node *qlink, struct kmem_cache *cache)
 {
 	void *object = qlink_to_object(qlink, cache);
+	struct kasan_free_meta *meta = kasan_get_free_meta(cache, object);
 	unsigned long flags;
 
 	if (IS_ENABLED(CONFIG_SLAB))
 		local_irq_save(flags);
 
+	/*
+	 * If init_on_free is enabled and KASAN's free metadata is stored in
+	 * the object, zero the metadata. Otherwise, the object's memory will
+	 * not be properly zeroed, as KASAN saves the metadata after the slab
+	 * allocator zeroes the object.
+	 */
+	if (slab_want_init_on_free(cache) &&
+	    cache->kasan_info.free_meta_offset == 0)
+		memzero_explicit(meta, sizeof(*meta));
+
 	/*
 	 * As the object now gets freed from the quarantine, assume that its
 	 * free track is no longer valid.
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 8d95ee52d019..dd79840e6096 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -493,7 +493,7 @@ void kasan_release_vmalloc(unsigned long start, unsigned long end,
 
 #else /* CONFIG_KASAN_VMALLOC */
 
-int kasan_module_alloc(void *addr, size_t size)
+int kasan_module_alloc(void *addr, size_t size, gfp_t gfp_mask)
 {
 	void *ret;
 	size_t scaled_size;
@@ -515,9 +515,14 @@ int kasan_module_alloc(void *addr, size_t size)
 			__builtin_return_address(0));
 
 	if (ret) {
+		struct vm_struct *vm = find_vm_area(addr);
 		__memset(ret, KASAN_SHADOW_INIT, shadow_size);
-		find_vm_area(addr)->flags |= VM_KASAN;
+		vm->flags |= VM_KASAN;
 		kmemleak_ignore(ret);
+
+		if (vm->flags & VM_DEFER_KMEMLEAK)
+			kmemleak_vmalloc(vm, size, gfp_mask);
+
 		return 0;
 	}
 
diff --git a/mm/memfd.c b/mm/memfd.c
index 081dd33e6a61..475d095dd7f5 100644
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
index bacabe446906..ea09dd33ab59 100644
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
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e8a807c78110..8375eecc55de 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3032,7 +3032,8 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	clear_vm_uninitialized_flag(area);
 
 	size = PAGE_ALIGN(size);
-	kmemleak_vmalloc(area, size, gfp_mask);
+	if (!(vm_flags & VM_DEFER_KMEMLEAK))
+		kmemleak_vmalloc(area, size, gfp_mask);
 
 	return addr;
 
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
diff --git a/net/core/Makefile b/net/core/Makefile
index 35ced6201814..4268846f2f47 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
+obj-$(CONFIG_OF)	+= of_net.o
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index a4ae65263384..d7f9ee830d34 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1927,7 +1927,7 @@ static struct class net_class __ro_after_init = {
 	.get_ownership = net_get_ownership,
 };
 
-#ifdef CONFIG_OF_NET
+#ifdef CONFIG_OF
 static int of_dev_node_match(struct device *dev, const void *data)
 {
 	for (; dev; dev = dev->parent) {
diff --git a/net/core/of_net.c b/net/core/of_net.c
new file mode 100644
index 000000000000..dbac3a172a11
--- /dev/null
+++ b/net/core/of_net.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * OF helpers for network devices.
+ *
+ * Initially copied out of arch/powerpc/kernel/prom_parse.c
+ */
+#include <linux/etherdevice.h>
+#include <linux/kernel.h>
+#include <linux/of_net.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/export.h>
+#include <linux/device.h>
+#include <linux/nvmem-consumer.h>
+
+/**
+ * of_get_phy_mode - Get phy mode for given device_node
+ * @np:	Pointer to the given device_node
+ * @interface: Pointer to the result
+ *
+ * The function gets phy interface string from property 'phy-mode' or
+ * 'phy-connection-type'. The index in phy_modes table is set in
+ * interface and 0 returned. In case of error interface is set to
+ * PHY_INTERFACE_MODE_NA and an errno is returned, e.g. -ENODEV.
+ */
+int of_get_phy_mode(struct device_node *np, phy_interface_t *interface)
+{
+	const char *pm;
+	int err, i;
+
+	*interface = PHY_INTERFACE_MODE_NA;
+
+	err = of_property_read_string(np, "phy-mode", &pm);
+	if (err < 0)
+		err = of_property_read_string(np, "phy-connection-type", &pm);
+	if (err < 0)
+		return err;
+
+	for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++)
+		if (!strcasecmp(pm, phy_modes(i))) {
+			*interface = i;
+			return 0;
+		}
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(of_get_phy_mode);
+
+static int of_get_mac_addr(struct device_node *np, const char *name, u8 *addr)
+{
+	struct property *pp = of_find_property(np, name, NULL);
+
+	if (pp && pp->length == ETH_ALEN && is_valid_ether_addr(pp->value)) {
+		memcpy(addr, pp->value, ETH_ALEN);
+		return 0;
+	}
+	return -ENODEV;
+}
+
+static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
+{
+	struct platform_device *pdev = of_find_device_by_node(np);
+	struct nvmem_cell *cell;
+	const void *mac;
+	size_t len;
+	int ret;
+
+	/* Try lookup by device first, there might be a nvmem_cell_lookup
+	 * associated with a given device.
+	 */
+	if (pdev) {
+		ret = nvmem_get_mac_address(&pdev->dev, addr);
+		put_device(&pdev->dev);
+		return ret;
+	}
+
+	cell = of_nvmem_cell_get(np, "mac-address");
+	if (IS_ERR(cell))
+		return PTR_ERR(cell);
+
+	mac = nvmem_cell_read(cell, &len);
+	nvmem_cell_put(cell);
+
+	if (IS_ERR(mac))
+		return PTR_ERR(mac);
+
+	if (len != ETH_ALEN || !is_valid_ether_addr(mac)) {
+		kfree(mac);
+		return -EINVAL;
+	}
+
+	memcpy(addr, mac, ETH_ALEN);
+	kfree(mac);
+
+	return 0;
+}
+
+/**
+ * of_get_mac_address()
+ * @np:		Caller's Device Node
+ * @addr:	Pointer to a six-byte array for the result
+ *
+ * Search the device tree for the best MAC address to use.  'mac-address' is
+ * checked first, because that is supposed to contain to "most recent" MAC
+ * address. If that isn't set, then 'local-mac-address' is checked next,
+ * because that is the default address. If that isn't set, then the obsolete
+ * 'address' is checked, just in case we're using an old device tree. If any
+ * of the above isn't set, then try to get MAC address from nvmem cell named
+ * 'mac-address'.
+ *
+ * Note that the 'address' property is supposed to contain a virtual address of
+ * the register set, but some DTS files have redefined that property to be the
+ * MAC address.
+ *
+ * All-zero MAC addresses are rejected, because those could be properties that
+ * exist in the device tree, but were not set by U-Boot.  For example, the
+ * DTS could define 'mac-address' and 'local-mac-address', with zero MAC
+ * addresses.  Some older U-Boots only initialized 'local-mac-address'.  In
+ * this case, the real MAC is in 'local-mac-address', and 'mac-address' exists
+ * but is all zeros.
+ *
+ * Return: 0 on success and errno in case of error.
+*/
+int of_get_mac_address(struct device_node *np, u8 *addr)
+{
+	int ret;
+
+	if (!np)
+		return -ENODEV;
+
+	ret = of_get_mac_addr(np, "mac-address", addr);
+	if (!ret)
+		return 0;
+
+	ret = of_get_mac_addr(np, "local-mac-address", addr);
+	if (!ret)
+		return 0;
+
+	ret = of_get_mac_addr(np, "address", addr);
+	if (!ret)
+		return 0;
+
+	return of_get_mac_addr_nvmem(np, addr);
+}
+EXPORT_SYMBOL(of_get_mac_address);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 449a96e358ad..6cb7ec85c9a1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3853,6 +3853,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		list_skb = list_skb->next;
 
 		err = 0;
+		delta_truesize += nskb->truesize;
 		if (skb_shared(nskb)) {
 			tmp = skb_clone(nskb, GFP_ATOMIC);
 			if (tmp) {
@@ -3877,7 +3878,6 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
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
index c6e1989ab2ed..e852bbc839dd 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3730,6 +3730,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifa, *tmp;
 	bool keep_addr = false;
+	bool was_ready;
 	int state, i;
 
 	ASSERT_RTNL();
@@ -3795,7 +3796,10 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 
 	addrconf_del_rs_timer(idev);
 
-	/* Step 2: clear flags for stateless addrconf */
+	/* Step 2: clear flags for stateless addrconf, repeated down
+	 *         detection
+	 */
+	was_ready = idev->if_flags & IF_READY;
 	if (!unregister)
 		idev->if_flags &= ~(IF_RS_SENT|IF_RA_RCVD|IF_READY);
 
@@ -3869,7 +3873,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
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
index e43804c9387e..6a88195e5abe 100644
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
index 215948fb0d35..6c8505edce75 100644
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
@@ -2994,8 +2995,15 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
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
@@ -4557,10 +4565,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
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
index 92ce173dd0c1..eab6283b3479 100644
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
@@ -4518,12 +4519,7 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 
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
index 4c889552cde7..d6def23b8cba 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -406,9 +406,12 @@ static bool mptcp_pending_data_fin(struct sock *sk, u64 *seq)
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
index 63d032191e62..60332fdb6dd4 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -406,14 +406,15 @@ static int __nf_register_net_hook(struct net *net, int pf,
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
index 959527708e38..8787d0613ad8 100644
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
index eff22065e197..5c4c0320e822 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -182,7 +182,7 @@ static int smc_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
-	int rc = 0;
+	int old_state, rc = 0;
 
 	if (!sk)
 		goto out;
@@ -190,8 +190,10 @@ static int smc_release(struct socket *sock)
 	sock_hold(sk); /* sock_put below */
 	smc = smc_sk(sk);
 
+	old_state = sk->sk_state;
+
 	/* cleanup for a dangling non-blocking connect */
-	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
+	if (smc->connect_nonblock && old_state == SMC_INIT)
 		tcp_abort(smc->clcsock->sk, ECONNABORTED);
 
 	if (cancel_work_sync(&smc->connect_work))
@@ -205,6 +207,10 @@ static int smc_release(struct socket *sock)
 	else
 		lock_sock(sk);
 
+	if (old_state == SMC_INIT && sk->sk_state == SMC_ACTIVE &&
+	    !smc->use_fallback)
+		smc_close_active_abort(smc);
+
 	rc = __smc_release(smc);
 
 	/* detach socket */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 36e93a3f284d..dee336eef6d2 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1061,8 +1061,8 @@ void smc_conn_free(struct smc_connection *conn)
 			cancel_work_sync(&conn->abort_work);
 	}
 	if (!list_empty(&lgr->list)) {
-		smc_lgr_unregister_conn(conn);
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
+		smc_lgr_unregister_conn(conn);
 	}
 
 	if (!lgr->conns_num)
@@ -1701,7 +1701,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		    (ini->smcd_version == SMC_V2 ||
 		     lgr->vlan_id == ini->vlan_id) &&
 		    (role == SMC_CLNT || ini->is_smcd ||
-		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
+		    (lgr->conns_num < SMC_RMBS_PER_LGR_MAX &&
+		      !bitmap_full(lgr->rtokens_used_mask, SMC_RMBS_PER_LGR_MAX)))) {
 			/* link group found */
 			ini->first_contact_local = 0;
 			conn->lgr = lgr;
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index a3bbe5ce4570..08ca797bb8a4 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1676,16 +1676,17 @@ EXPORT_SYMBOL_GPL(svc_encode_result_payload);
 /**
  * svc_fill_write_vector - Construct data argument for VFS write call
  * @rqstp: svc_rqst to operate on
- * @pages: list of pages containing data payload
- * @first: buffer containing first section of write payload
- * @total: total number of bytes of write payload
+ * @payload: xdr_buf containing only the write data payload
  *
  * Fills in rqstp::rq_vec, and returns the number of elements.
  */
-unsigned int svc_fill_write_vector(struct svc_rqst *rqstp, struct page **pages,
-				   struct kvec *first, size_t total)
+unsigned int svc_fill_write_vector(struct svc_rqst *rqstp,
+				   struct xdr_buf *payload)
 {
+	struct page **pages = payload->pages;
+	struct kvec *first = payload->head;
 	struct kvec *vec = rqstp->rq_vec;
+	size_t total = payload->len;
 	unsigned int i;
 
 	/* Some types of transport can present the write payload
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 6316bd2b8f37..d4b663401be1 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -243,7 +243,7 @@ static struct svc_xprt *__svc_xpo_create(struct svc_xprt_class *xcl,
 	xprt = xcl->xcl_ops->xpo_create(serv, net, sap, len, flags);
 	if (IS_ERR(xprt))
 		trace_svc_xprt_create_err(serv->sv_program->pg_name,
-					  xcl->xcl_name, sap, xprt);
+					  xcl->xcl_name, sap, len, xprt);
 	return xprt;
 }
 
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
index 16b3d0cc0bdb..99564db14aa1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13177,6 +13177,9 @@ static int handle_nan_filter(struct nlattr *attr_filter,
 	i = 0;
 	nla_for_each_nested(attr, attr_filter, rem) {
 		filter[i].filter = nla_memdup(attr, GFP_KERNEL);
+		if (!filter[i].filter)
+			goto err;
+
 		filter[i].len = nla_len(attr);
 		i++;
 	}
@@ -13189,6 +13192,15 @@ static int handle_nan_filter(struct nlattr *attr_filter,
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
index 6ab1a8bc3735..1186ceb5a978 100644
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
index 757d1362b5f4..6ad3159eceb9 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -1090,11 +1090,13 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		container_of(work, struct rt5682_priv, jack_detect_work.work);
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
 
 	mutex_lock(&rt5682->calibrate_mutex);
 
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
 
diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index de6365b53c9c..45e0d640618a 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -166,7 +166,7 @@ static struct btf_id *btf_id__find(struct rb_root *root, const char *name)
 	return NULL;
 }
 
-static struct btf_id*
+static struct btf_id *
 btf_id__add(struct rb_root *root, char *name, bool unique)
 {
 	struct rb_node **p = &root->rb_node;
@@ -720,7 +720,8 @@ int main(int argc, const char **argv)
 		if (no_fail)
 			return 0;
 		pr_err("FAILED to find needed sections\n");
-		return -1;
+		err = 0;
+		goto out;
 	}
 
 	if (symbols_collect(&obj))
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index 685dfb3478b3..b9b8274643de 100755
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
diff --git a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
index fe8fcfb334e0..a5cb4b09a46c 100644
--- a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
@@ -24,19 +24,23 @@ if [[ "$1" == "-cgroup-v2" ]]; then
   reservation_usage_file=rsvd.current
 fi
 
-cgroup_path=/dev/cgroup/memory
-if [[ ! -e $cgroup_path ]]; then
-  mkdir -p $cgroup_path
-  if [[ $cgroup2 ]]; then
+if [[ $cgroup2 ]]; then
+  cgroup_path=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  if [[ -z "$cgroup_path" ]]; then
+    cgroup_path=/dev/cgroup/memory
     mount -t cgroup2 none $cgroup_path
-  else
+    do_umount=1
+  fi
+  echo "+hugetlb" >$cgroup_path/cgroup.subtree_control
+else
+  cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  if [[ -z "$cgroup_path" ]]; then
+    cgroup_path=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $cgroup_path
+    do_umount=1
   fi
 fi
-
-if [[ $cgroup2 ]]; then
-  echo "+hugetlb" >/dev/cgroup/memory/cgroup.subtree_control
-fi
+export cgroup_path
 
 function cleanup() {
   if [[ $cgroup2 ]]; then
@@ -108,7 +112,7 @@ function setup_cgroup() {
 
 function wait_for_hugetlb_memory_to_get_depleted() {
   local cgroup="$1"
-  local path="/dev/cgroup/memory/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
   # Wait for hugetlbfs memory to get depleted.
   while [ $(cat $path) != 0 ]; do
     echo Waiting for hugetlb memory to get depleted.
@@ -121,7 +125,7 @@ function wait_for_hugetlb_memory_to_get_reserved() {
   local cgroup="$1"
   local size="$2"
 
-  local path="/dev/cgroup/memory/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
   # Wait for hugetlbfs memory to get written.
   while [ $(cat $path) != $size ]; do
     echo Waiting for hugetlb memory reservation to reach size $size.
@@ -134,7 +138,7 @@ function wait_for_hugetlb_memory_to_get_written() {
   local cgroup="$1"
   local size="$2"
 
-  local path="/dev/cgroup/memory/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
   # Wait for hugetlbfs memory to get written.
   while [ $(cat $path) != $size ]; do
     echo Waiting for hugetlb memory to reach size $size.
@@ -574,5 +578,7 @@ for populate in "" "-o"; do
   done     # populate
 done       # method
 
-umount $cgroup_path
-rmdir $cgroup_path
+if [[ $do_umount ]]; then
+  umount $cgroup_path
+  rmdir $cgroup_path
+fi
diff --git a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
index 4a9a3afe9fd4..bf2d2a684edf 100644
--- a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
@@ -18,19 +18,24 @@ if [[ "$1" == "-cgroup-v2" ]]; then
   usage_file=current
 fi
 
-CGROUP_ROOT='/dev/cgroup/memory'
-MNT='/mnt/huge/'
 
-if [[ ! -e $CGROUP_ROOT ]]; then
-  mkdir -p $CGROUP_ROOT
-  if [[ $cgroup2 ]]; then
+if [[ $cgroup2 ]]; then
+  CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  if [[ -z "$CGROUP_ROOT" ]]; then
+    CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup2 none $CGROUP_ROOT
-    sleep 1
-    echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
-  else
+    do_umount=1
+  fi
+  echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
+else
+  CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  if [[ -z "$CGROUP_ROOT" ]]; then
+    CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $CGROUP_ROOT
+    do_umount=1
   fi
 fi
+MNT='/mnt/huge/'
 
 function get_machine_hugepage_size() {
   hpz=$(grep -i hugepagesize /proc/meminfo)
diff --git a/tools/testing/selftests/vm/write_hugetlb_memory.sh b/tools/testing/selftests/vm/write_hugetlb_memory.sh
index d3d0d108924d..70a02301f4c2 100644
--- a/tools/testing/selftests/vm/write_hugetlb_memory.sh
+++ b/tools/testing/selftests/vm/write_hugetlb_memory.sh
@@ -14,7 +14,7 @@ want_sleep=$8
 reserve=$9
 
 echo "Putting task in cgroup '$cgroup'"
-echo $$ > /dev/cgroup/memory/"$cgroup"/cgroup.procs
+echo $$ > ${cgroup_path:-/dev/cgroup/memory}/"$cgroup"/cgroup.procs
 
 echo "Method is $method"
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13aff136e6ee..f8b42e19bc77 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3222,6 +3222,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
  */
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
+	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	ktime_t start, cur, poll_end;
 	bool waited = false;
 	u64 block_ns;
@@ -3229,7 +3230,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_blocking(vcpu);
 
 	start = cur = poll_end = ktime_get();
-	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
+	if (vcpu->halt_poll_ns && halt_poll_allowed) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
 		++vcpu->stat.generic.halt_attempted_poll;
@@ -3284,7 +3285,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	update_halt_poll_stats(
 		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
 
-	if (!kvm_arch_no_poll(vcpu)) {
+	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
 		} else if (vcpu->kvm->max_halt_poll_ns) {
