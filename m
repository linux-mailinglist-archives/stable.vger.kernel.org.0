Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C9A554A38
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348218AbiFVMjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 08:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244742AbiFVMis (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 08:38:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E964E63CD;
        Wed, 22 Jun 2022 05:37:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3511B61952;
        Wed, 22 Jun 2022 12:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35800C34114;
        Wed, 22 Jun 2022 12:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655901472;
        bh=uuJceMncnts23Yll9WN7zPh1AFcBVk2bEAY67txDIws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RT9RniiYd8EpxGMhvTEj4CSANvRSeXTVeA4UsDpv9+y+0wvYEym/uBjiDf0YrK/X
         9jRVOg7BhrNz48W9S2NsCT2l9AvjLVY59CDUIBqRatvuijkrsraFkncGZKWPsaUvV2
         MCYrdNapD02lsQdfglFIKENeVhT8AZ8HSG2Bv8DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.18.6
Date:   Wed, 22 Jun 2022 14:37:37 +0200
Message-Id: <165590145618756@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <1655901456161120@kroah.com>
References: <1655901456161120@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator b/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator
index 42214b4ff14a..90596d8bb51c 100644
--- a/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator
+++ b/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator
@@ -26,6 +26,6 @@ Description:	Read/write the current state of DDR Backup Mode, which controls
 		     DDR Backup Mode must be explicitly enabled by the user,
 		     to invoke step 1.
 
-		See also Documentation/devicetree/bindings/mfd/bd9571mwv.txt.
+		See also Documentation/devicetree/bindings/mfd/rohm,bd9571mwv.yaml.
 Users:		User space applications for embedded boards equipped with a
 		BD9571MWV PMIC.
diff --git a/Documentation/devicetree/bindings/cpufreq/brcm,stb-avs-cpu-freq.txt b/Documentation/devicetree/bindings/cpufreq/brcm,stb-avs-cpu-freq.txt
index 73470ecd1f12..ce91a9197697 100644
--- a/Documentation/devicetree/bindings/cpufreq/brcm,stb-avs-cpu-freq.txt
+++ b/Documentation/devicetree/bindings/cpufreq/brcm,stb-avs-cpu-freq.txt
@@ -16,7 +16,7 @@ has been processed. See [2] for more information on the brcm,l2-intc node.
 firmware. On some SoCs, this firmware supports DFS and DVFS in addition to
 Adaptive Voltage Scaling.
 
-[2] Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
+[2] Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.yaml
 
 
 Node brcm,avs-cpu-data-mem
diff --git a/Documentation/filesystems/netfs_library.rst b/Documentation/filesystems/netfs_library.rst
index 69f00179fdfe..0483abcafcb0 100644
--- a/Documentation/filesystems/netfs_library.rst
+++ b/Documentation/filesystems/netfs_library.rst
@@ -37,30 +37,31 @@ The network filesystem helper library needs a place to store a bit of state for
 its use on each netfs inode it is helping to manage.  To this end, a context
 structure is defined::
 
-	struct netfs_i_context {
+	struct netfs_inode {
+		struct inode inode;
 		const struct netfs_request_ops *ops;
-		struct fscache_cookie	*cache;
+		struct fscache_cookie *cache;
 	};
 
-A network filesystem that wants to use netfs lib must place one of these
-directly after the VFS ``struct inode`` it allocates, usually as part of its
-own struct.  This can be done in a way similar to the following::
+A network filesystem that wants to use netfs lib must place one of these in its
+inode wrapper struct instead of the VFS ``struct inode``.  This can be done in
+a way similar to the following::
 
 	struct my_inode {
-		struct {
-			/* These must be contiguous */
-			struct inode		vfs_inode;
-			struct netfs_i_context  netfs_ctx;
-		};
+		struct netfs_inode netfs; /* Netfslib context and vfs inode */
 		...
 	};
 
-This allows netfslib to find its state by simple offset from the inode pointer,
-thereby allowing the netfslib helper functions to be pointed to directly by the
-VFS/VM operation tables.
+This allows netfslib to find its state by using ``container_of()`` from the
+inode pointer, thereby allowing the netfslib helper functions to be pointed to
+directly by the VFS/VM operation tables.
 
 The structure contains the following fields:
 
+ * ``inode``
+
+   The VFS inode structure.
+
  * ``ops``
 
    The set of operations provided by the network filesystem to netfslib.
@@ -78,14 +79,12 @@ To help deal with the per-inode context, a number helper functions are
 provided.  Firstly, a function to perform basic initialisation on a context and
 set the operations table pointer::
 
-	void netfs_i_context_init(struct inode *inode,
-				  const struct netfs_request_ops *ops);
+	void netfs_inode_init(struct inode *inode,
+			      const struct netfs_request_ops *ops);
 
-then two functions to cast between the VFS inode structure and the netfs
-context::
+then a function to cast from the VFS inode structure to the netfs context::
 
-	struct netfs_i_context *netfs_i_context(struct inode *inode);
-	struct inode *netfs_inode(struct netfs_i_context *ctx);
+	struct netfs_inode *netfs_node(struct inode *inode);
 
 and finally, a function to get the cache cookie pointer from the context
 attached to an inode (or NULL if fscache is disabled)::
diff --git a/Makefile b/Makefile
index 34bfb76d6333..27850d452d65 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 18
-SUBLEVEL = 5
+SUBLEVEL = 6
 EXTRAVERSION =
 NAME = Superb Owl
 
@@ -787,6 +787,7 @@ stackp-flags-$(CONFIG_STACKPROTECTOR_STRONG)      := -fstack-protector-strong
 KBUILD_CFLAGS += $(stackp-flags-y)
 
 KBUILD_CFLAGS-$(CONFIG_WERROR) += -Werror
+KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
 KBUILD_CFLAGS += $(KBUILD_CFLAGS-y) $(CONFIG_CC_IMPLICIT_FALLTHROUGH)
 
 ifdef CONFIG_CC_IS_CLANG
@@ -804,6 +805,9 @@ endif
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
 
+# These result in bogus false positives
+KBUILD_CFLAGS += $(call cc-disable-warning, dangling-pointer)
+
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
index ec3f2c177035..f338a886d811 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
@@ -278,6 +278,7 @@ &uart3 {
 	pinctrl-0 = <&pinctrl_uart3>;
 	assigned-clocks = <&clk IMX8MM_CLK_UART3>;
 	assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_80M>;
+	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -386,6 +387,8 @@ pinctrl_uart3: uart3grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI1_SCLK_UART3_DCE_RX	0x40
 			MX8MM_IOMUXC_ECSPI1_MOSI_UART3_DCE_TX	0x40
+			MX8MM_IOMUXC_ECSPI1_MISO_UART3_DCE_CTS_B	0x40
+			MX8MM_IOMUXC_ECSPI1_SS0_UART3_DCE_RTS_B	0x40
 		>;
 	};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi
index 0f40b43ac091..02f37dcda7ed 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi
@@ -175,6 +175,7 @@ &uart3 {
 	pinctrl-0 = <&pinctrl_uart3>;
 	assigned-clocks = <&clk IMX8MN_CLK_UART3>;
 	assigned-clock-parents = <&clk IMX8MN_SYS_PLL1_80M>;
+	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -258,6 +259,8 @@ pinctrl_uart3: uart3grp {
 		fsl,pins = <
 			MX8MN_IOMUXC_ECSPI1_SCLK_UART3_DCE_RX	0x40
 			MX8MN_IOMUXC_ECSPI1_MOSI_UART3_DCE_TX	0x40
+			MX8MN_IOMUXC_ECSPI1_MISO_UART3_DCE_CTS_B	0x40
+			MX8MN_IOMUXC_ECSPI1_SS0_UART3_DCE_RTS_B	0x40
 		>;
 	};
 
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 4506c4a90ac1..f3184cd81b19 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -78,47 +78,76 @@ static struct plt_entry *get_ftrace_plt(struct module *mod, unsigned long addr)
 }
 
 /*
- * Turn on the call to ftrace_caller() in instrumented function
+ * Find the address the callsite must branch to in order to reach '*addr'.
+ *
+ * Due to the limited range of 'BL' instructions, modules may be placed too far
+ * away to branch directly and must use a PLT.
+ *
+ * Returns true when '*addr' contains a reachable target address, or has been
+ * modified to contain a PLT address. Returns false otherwise.
  */
-int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+static bool ftrace_find_callable_addr(struct dyn_ftrace *rec,
+				      struct module *mod,
+				      unsigned long *addr)
 {
 	unsigned long pc = rec->ip;
-	u32 old, new;
-	long offset = (long)pc - (long)addr;
+	long offset = (long)*addr - (long)pc;
+	struct plt_entry *plt;
 
-	if (offset < -SZ_128M || offset >= SZ_128M) {
-		struct module *mod;
-		struct plt_entry *plt;
+	/*
+	 * When the target is within range of the 'BL' instruction, use 'addr'
+	 * as-is and branch to that directly.
+	 */
+	if (offset >= -SZ_128M && offset < SZ_128M)
+		return true;
 
-		if (!IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
-			return -EINVAL;
+	/*
+	 * When the target is outside of the range of a 'BL' instruction, we
+	 * must use a PLT to reach it. We can only place PLTs for modules, and
+	 * only when module PLT support is built-in.
+	 */
+	if (!IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
+		return false;
 
-		/*
-		 * On kernels that support module PLTs, the offset between the
-		 * branch instruction and its target may legally exceed the
-		 * range of an ordinary relative 'bl' opcode. In this case, we
-		 * need to branch via a trampoline in the module.
-		 *
-		 * NOTE: __module_text_address() must be called with preemption
-		 * disabled, but we can rely on ftrace_lock to ensure that 'mod'
-		 * retains its validity throughout the remainder of this code.
-		 */
+	/*
+	 * 'mod' is only set at module load time, but if we end up
+	 * dealing with an out-of-range condition, we can assume it
+	 * is due to a module being loaded far away from the kernel.
+	 *
+	 * NOTE: __module_text_address() must be called with preemption
+	 * disabled, but we can rely on ftrace_lock to ensure that 'mod'
+	 * retains its validity throughout the remainder of this code.
+	 */
+	if (!mod) {
 		preempt_disable();
 		mod = __module_text_address(pc);
 		preempt_enable();
+	}
 
-		if (WARN_ON(!mod))
-			return -EINVAL;
+	if (WARN_ON(!mod))
+		return false;
 
-		plt = get_ftrace_plt(mod, addr);
-		if (!plt) {
-			pr_err("ftrace: no module PLT for %ps\n", (void *)addr);
-			return -EINVAL;
-		}
-
-		addr = (unsigned long)plt;
+	plt = get_ftrace_plt(mod, *addr);
+	if (!plt) {
+		pr_err("ftrace: no module PLT for %ps\n", (void *)*addr);
+		return false;
 	}
 
+	*addr = (unsigned long)plt;
+	return true;
+}
+
+/*
+ * Turn on the call to ftrace_caller() in instrumented function
+ */
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long pc = rec->ip;
+	u32 old, new;
+
+	if (!ftrace_find_callable_addr(rec, NULL, &addr))
+		return -EINVAL;
+
 	old = aarch64_insn_gen_nop();
 	new = aarch64_insn_gen_branch_imm(pc, addr, AARCH64_INSN_BRANCH_LINK);
 
@@ -132,6 +161,11 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 	unsigned long pc = rec->ip;
 	u32 old, new;
 
+	if (!ftrace_find_callable_addr(rec, NULL, &old_addr))
+		return -EINVAL;
+	if (!ftrace_find_callable_addr(rec, NULL, &addr))
+		return -EINVAL;
+
 	old = aarch64_insn_gen_branch_imm(pc, old_addr,
 					  AARCH64_INSN_BRANCH_LINK);
 	new = aarch64_insn_gen_branch_imm(pc, addr, AARCH64_INSN_BRANCH_LINK);
@@ -181,54 +215,15 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 		    unsigned long addr)
 {
 	unsigned long pc = rec->ip;
-	bool validate = true;
 	u32 old = 0, new;
-	long offset = (long)pc - (long)addr;
 
-	if (offset < -SZ_128M || offset >= SZ_128M) {
-		u32 replaced;
-
-		if (!IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
-			return -EINVAL;
-
-		/*
-		 * 'mod' is only set at module load time, but if we end up
-		 * dealing with an out-of-range condition, we can assume it
-		 * is due to a module being loaded far away from the kernel.
-		 */
-		if (!mod) {
-			preempt_disable();
-			mod = __module_text_address(pc);
-			preempt_enable();
-
-			if (WARN_ON(!mod))
-				return -EINVAL;
-		}
-
-		/*
-		 * The instruction we are about to patch may be a branch and
-		 * link instruction that was redirected via a PLT entry. In
-		 * this case, the normal validation will fail, but we can at
-		 * least check that we are dealing with a branch and link
-		 * instruction that points into the right module.
-		 */
-		if (aarch64_insn_read((void *)pc, &replaced))
-			return -EFAULT;
-
-		if (!aarch64_insn_is_bl(replaced) ||
-		    !within_module(pc + aarch64_get_branch_offset(replaced),
-				   mod))
-			return -EINVAL;
-
-		validate = false;
-	} else {
-		old = aarch64_insn_gen_branch_imm(pc, addr,
-						  AARCH64_INSN_BRANCH_LINK);
-	}
+	if (!ftrace_find_callable_addr(rec, mod, &addr))
+		return -EINVAL;
 
+	old = aarch64_insn_gen_branch_imm(pc, addr, AARCH64_INSN_BRANCH_LINK);
 	new = aarch64_insn_gen_nop();
 
-	return ftrace_modify_code(pc, old, new, validate);
+	return ftrace_modify_code(pc, old, new, true);
 }
 
 void arch_ftrace_update_code(int command)
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 397fdac75cb1..7fe29bf6d193 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -80,6 +80,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
 	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
 
+	vcpu->arch.flags &= ~KVM_ARM64_HOST_SVE_ENABLED;
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index 12e4c223e6b8..54167fcfb605 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -417,11 +417,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
-		NULL, vgic_uaccess_write_spending, 1,
+		vgic_uaccess_read_pending, vgic_uaccess_write_spending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
-		NULL, vgic_uaccess_write_cpending, 1,
+		vgic_uaccess_read_pending, vgic_uaccess_write_cpending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 49837d3a3ef5..dc8c52487e47 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -226,8 +226,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
-				     gpa_t addr, unsigned int len)
+static unsigned long __read_pending(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    bool is_user)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 value = 0;
@@ -248,7 +249,7 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 						    IRQCHIP_STATE_PENDING,
 						    &val);
 			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
-		} else if (vgic_irq_is_mapped_level(irq)) {
+		} else if (!is_user && vgic_irq_is_mapped_level(irq)) {
 			val = vgic_get_phys_line_level(irq);
 		} else {
 			val = irq_is_pending(irq);
@@ -263,6 +264,18 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len)
+{
+	return __read_pending(vcpu, addr, len, false);
+}
+
+unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len)
+{
+	return __read_pending(vcpu, addr, len, true);
+}
+
 static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	return (vgic_irq_is_sgi(irq->intid) &&
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index 3fa696f198a3..6082d4b66d39 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -149,6 +149,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
 unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len);
 
+unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len);
+
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val);
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 0ea6cc25dc66..21c907987080 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -218,8 +218,6 @@ SYM_FUNC_ALIAS(__dma_flush_area, __pi___dma_flush_area)
  */
 SYM_FUNC_START(__pi___dma_map_area)
 	add	x1, x0, x1
-	cmp	w2, #DMA_FROM_DEVICE
-	b.eq	__pi_dcache_inval_poc
 	b	__pi_dcache_clean_poc
 SYM_FUNC_END(__pi___dma_map_area)
 SYM_FUNC_ALIAS(__dma_map_area, __pi___dma_map_area)
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 984813a4d5dc..a75d20f23dac 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -2160,12 +2160,12 @@ static unsigned long ___get_wchan(struct task_struct *p)
 		return 0;
 
 	do {
-		sp = *(unsigned long *)sp;
+		sp = READ_ONCE_NOCHECK(*(unsigned long *)sp);
 		if (!validate_sp(sp, p, STACK_FRAME_OVERHEAD) ||
 		    task_is_running(p))
 			return 0;
 		if (count > 0) {
-			ip = ((unsigned long *)sp)[STACK_FRAME_LR_SAVE];
+			ip = READ_ONCE_NOCHECK(((unsigned long *)sp)[STACK_FRAME_LR_SAVE]);
 			if (!in_sched_functions(ip))
 				return ip;
 		}
diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 96c38f971603..5f81c076621f 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -18,7 +18,6 @@
 #include <asm/prom.h>
 #include <asm/kdump.h>
 #include <mm/mmu_decl.h>
-#include <generated/compile.h>
 #include <generated/utsrelease.h>
 
 struct regions {
@@ -36,10 +35,6 @@ struct regions {
 	int reserved_mem_size_cells;
 };
 
-/* Simplified build-specific string for starting entropy. */
-static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
-
 struct regions __initdata regions;
 
 static __init void kaslr_get_cmdline(void *fdt)
@@ -70,7 +65,8 @@ static unsigned long __init get_boot_seed(void *fdt)
 {
 	unsigned long hash = 0;
 
-	hash = rotate_xor(hash, build_str, sizeof(build_str));
+	/* build-specific string for starting entropy. */
+	hash = rotate_xor(hash, linux_banner, strlen(linux_banner));
 	hash = rotate_xor(hash, fdt, fdt_totalsize(fdt));
 
 	return hash;
diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index cf2f55e1dcb6..f44fce1fe080 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -188,6 +188,15 @@ plic: interrupt-controller@c000000 {
 			riscv,ndev = <186>;
 		};
 
+		pdma: dma-controller@3000000 {
+			compatible = "sifive,fu540-c000-pdma", "sifive,pdma0";
+			reg = <0x0 0x3000000 0x0 0x8000>;
+			interrupt-parent = <&plic>;
+			interrupts = <5 6>, <7 8>, <9 10>, <11 12>;
+			dma-channels = <4>;
+			#dma-cells = <1>;
+		};
+
 		clkcfg: clkcfg@20002000 {
 			compatible = "microchip,mpfs-clkcfg";
 			reg = <0x0 0x20002000 0x0 0x1000>, <0x0 0x3E001000 0x0 0x1000>;
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index e084c72104f8..359b0cc0dc35 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -125,6 +125,7 @@ config S390
 	select CLONE_BACKWARDS2
 	select DMA_OPS if PCI
 	select DYNAMIC_FTRACE if FUNCTION_TRACER
+	select GCC12_NO_ARRAY_BOUNDS
 	select GENERIC_ALLOCATOR
 	select GENERIC_CPU_AUTOPROBE
 	select GENERIC_CPU_VULNERABILITIES
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index df325eacf62d..eba70d585cb2 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -30,15 +30,7 @@ KBUILD_CFLAGS_DECOMPRESSOR += -fno-stack-protector
 KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),-g)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO_DWARF4), $(call cc-option, -gdwarf-4,))
-
-ifdef CONFIG_CC_IS_GCC
-	ifeq ($(call cc-ifversion, -ge, 1200, y), y)
-		ifeq ($(call cc-ifversion, -lt, 1300, y), y)
-			KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
-			KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, array-bounds)
-		endif
-	endif
-endif
+KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_CC_NO_ARRAY_BOUNDS),-Wno-array-bounds)
 
 UTS_MACHINE	:= s390x
 STACK_SIZE	:= $(if $(CONFIG_KASAN),65536,16384)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index c41ef42adbe8..25828e4c6237 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,10 +36,6 @@ KCSAN_SANITIZE := n
 
 OBJECT_FILES_NON_STANDARD_test_nx.o			:= y
 
-ifdef CONFIG_FRAME_POINTER
-OBJECT_FILES_NON_STANDARD_ftrace_$(BITS).o		:= y
-endif
-
 # If instrumentation of this dir is enabled, boot hangs during first second.
 # Probably could be more selective here, but note that files related to irqs,
 # boot, dumpstack/stacktrace, etc are either non-interesting or can lead to
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 4ec13608d3c6..dfeb227de561 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -175,6 +175,7 @@ SYM_INNER_LABEL(ftrace_caller_end, SYM_L_GLOBAL)
 
 	jmp ftrace_epilogue
 SYM_FUNC_END(ftrace_caller);
+STACK_FRAME_NON_STANDARD_FP(ftrace_caller)
 
 SYM_FUNC_START(ftrace_epilogue)
 /*
@@ -282,6 +283,7 @@ SYM_INNER_LABEL(ftrace_regs_caller_end, SYM_L_GLOBAL)
 	jmp	ftrace_epilogue
 
 SYM_FUNC_END(ftrace_regs_caller)
+STACK_FRAME_NON_STANDARD_FP(ftrace_regs_caller)
 
 
 #else /* ! CONFIG_DYNAMIC_FTRACE */
@@ -311,10 +313,14 @@ trace:
 	jmp ftrace_stub
 SYM_FUNC_END(__fentry__)
 EXPORT_SYMBOL(__fentry__)
+STACK_FRAME_NON_STANDARD_FP(__fentry__)
+
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-SYM_FUNC_START(return_to_handler)
+SYM_CODE_START(return_to_handler)
+	UNWIND_HINT_EMPTY
+	ANNOTATE_NOENDBR
 	subq  $16, %rsp
 
 	/* Save the return values */
@@ -339,7 +345,6 @@ SYM_FUNC_START(return_to_handler)
 	int3
 .Ldo_rop:
 	mov %rdi, (%rsp)
-	UNWIND_HINT_FUNC
 	RET
-SYM_FUNC_END(return_to_handler)
+SYM_CODE_END(return_to_handler)
 #endif
diff --git a/block/blk-mq.c b/block/blk-mq.c
index de7fc6957271..631fb87b4976 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -579,6 +579,8 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	if (!blk_mq_hw_queue_mapped(data.hctx))
 		goto out_queue_exit;
 	cpu = cpumask_first_and(data.hctx->cpumask, cpu_online_mask);
+	if (cpu >= nr_cpu_ids)
+		goto out_queue_exit;
 	data.ctx = __blk_mq_get_ctx(q, cpu);
 
 	if (!q->elevator)
diff --git a/certs/blacklist_hashes.c b/certs/blacklist_hashes.c
index 344892337be0..d5961aa3d338 100644
--- a/certs/blacklist_hashes.c
+++ b/certs/blacklist_hashes.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "blacklist.h"
 
-const char __initdata *const blacklist_hashes[] = {
+const char __initconst *const blacklist_hashes[] = {
 #include CONFIG_SYSTEM_BLACKLIST_HASH_LIST
 	, NULL
 };
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 41068811fd0e..b4e00a7a046b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -15,6 +15,7 @@ source "crypto/async_tx/Kconfig"
 #
 menuconfig CRYPTO
 	tristate "Cryptographic API"
+	select LIB_MEMNEQ
 	help
 	  This option provides the core Cryptographic API.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index f754c4d17d6b..a40e6d5fb2c8 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-$(CONFIG_CRYPTO) += crypto.o
-crypto-y := api.o cipher.o compress.o memneq.o
+crypto-y := api.o cipher.o compress.o
 
 obj-$(CONFIG_CRYPTO_ENGINE) += crypto_engine.o
 obj-$(CONFIG_CRYPTO_FIPS) += fips.o
diff --git a/crypto/memneq.c b/crypto/memneq.c
deleted file mode 100644
index fb11608b1ec1..000000000000
--- a/crypto/memneq.c
+++ /dev/null
@@ -1,176 +0,0 @@
-/*
- * Constant-time equality testing of memory regions.
- *
- * Authors:
- *
- *   James Yonan <james@openvpn.net>
- *   Daniel Borkmann <dborkman@redhat.com>
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of OpenVPN Technologies nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <crypto/algapi.h>
-#include <asm/unaligned.h>
-
-#ifndef __HAVE_ARCH_CRYPTO_MEMNEQ
-
-/* Generic path for arbitrary size */
-static inline unsigned long
-__crypto_memneq_generic(const void *a, const void *b, size_t size)
-{
-	unsigned long neq = 0;
-
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-	while (size >= sizeof(unsigned long)) {
-		neq |= get_unaligned((unsigned long *)a) ^
-		       get_unaligned((unsigned long *)b);
-		OPTIMIZER_HIDE_VAR(neq);
-		a += sizeof(unsigned long);
-		b += sizeof(unsigned long);
-		size -= sizeof(unsigned long);
-	}
-#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-	while (size > 0) {
-		neq |= *(unsigned char *)a ^ *(unsigned char *)b;
-		OPTIMIZER_HIDE_VAR(neq);
-		a += 1;
-		b += 1;
-		size -= 1;
-	}
-	return neq;
-}
-
-/* Loop-free fast-path for frequently used 16-byte size */
-static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
-{
-	unsigned long neq = 0;
-
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	if (sizeof(unsigned long) == 8) {
-		neq |= get_unaligned((unsigned long *)a) ^
-		       get_unaligned((unsigned long *)b);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= get_unaligned((unsigned long *)(a + 8)) ^
-		       get_unaligned((unsigned long *)(b + 8));
-		OPTIMIZER_HIDE_VAR(neq);
-	} else if (sizeof(unsigned int) == 4) {
-		neq |= get_unaligned((unsigned int *)a) ^
-		       get_unaligned((unsigned int *)b);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= get_unaligned((unsigned int *)(a + 4)) ^
-		       get_unaligned((unsigned int *)(b + 4));
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= get_unaligned((unsigned int *)(a + 8)) ^
-		       get_unaligned((unsigned int *)(b + 8));
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= get_unaligned((unsigned int *)(a + 12)) ^
-		       get_unaligned((unsigned int *)(b + 12));
-		OPTIMIZER_HIDE_VAR(neq);
-	} else
-#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-	{
-		neq |= *(unsigned char *)(a)    ^ *(unsigned char *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+10) ^ *(unsigned char *)(b+10);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+11) ^ *(unsigned char *)(b+11);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+12) ^ *(unsigned char *)(b+12);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+13) ^ *(unsigned char *)(b+13);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+14) ^ *(unsigned char *)(b+14);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+15) ^ *(unsigned char *)(b+15);
-		OPTIMIZER_HIDE_VAR(neq);
-	}
-
-	return neq;
-}
-
-/* Compare two areas of memory without leaking timing information,
- * and with special optimizations for common sizes.  Users should
- * not call this function directly, but should instead use
- * crypto_memneq defined in crypto/algapi.h.
- */
-noinline unsigned long __crypto_memneq(const void *a, const void *b,
-				       size_t size)
-{
-	switch (size) {
-	case 16:
-		return __crypto_memneq_16(a, b);
-	default:
-		return __crypto_memneq_generic(a, b, size);
-	}
-}
-EXPORT_SYMBOL(__crypto_memneq);
-
-#endif /* __HAVE_ARCH_CRYPTO_MEMNEQ */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3d57fa84e2be..ea9671821258 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5506,7 +5506,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 				      const struct ata_port_info * const * ppi,
 				      int n_ports)
 {
-	const struct ata_port_info *pi;
+	const struct ata_port_info *pi = &ata_dummy_port_info;
 	struct ata_host *host;
 	int i, j;
 
@@ -5514,7 +5514,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 	if (!host)
 		return NULL;
 
-	for (i = 0, j = 0, pi = NULL; i < host->n_ports; i++) {
+	for (i = 0, j = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
 		if (ppi[j])
diff --git a/drivers/base/init.c b/drivers/base/init.c
index d8d0fe687111..397eb9880cec 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/memory.h>
 #include <linux/of.h>
+#include <linux/backing-dev.h>
 
 #include "base.h"
 
@@ -20,6 +21,7 @@
 void __init driver_init(void)
 {
 	/* These are the core pieces */
+	bdi_init(&noop_backing_dev_info);
 	devtmpfs_init();
 	devices_init();
 	buses_init();
diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 8fd4a356a86e..74593a1722fe 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -1236,14 +1236,14 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 static int fsl_mc_bus_remove(struct platform_device *pdev)
 {
 	struct fsl_mc *mc = platform_get_drvdata(pdev);
+	struct fsl_mc_io *mc_io;
 
 	if (!fsl_mc_is_root_dprc(&mc->root_mc_bus_dev->dev))
 		return -EINVAL;
 
+	mc_io = mc->root_mc_bus_dev->mc_io;
 	fsl_mc_device_remove(mc->root_mc_bus_dev);
-
-	fsl_destroy_mc_io(mc->root_mc_bus_dev->mc_io);
-	mc->root_mc_bus_dev->mc_io = NULL;
+	fsl_destroy_mc_io(mc_io);
 
 	bus_unregister_notifier(&fsl_mc_bus_type, &fsl_mc_nb);
 
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 55f48375e3fe..d454428f4981 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -428,28 +428,40 @@ config ADI
 	  driver include crash and makedumpfile.
 
 config RANDOM_TRUST_CPU
-	bool "Trust the CPU manufacturer to initialize Linux's CRNG"
+	bool "Initialize RNG using CPU RNG instructions"
+	default y
 	depends on ARCH_RANDOM
-	default n
 	help
-	Assume that CPU manufacturer (e.g., Intel or AMD for RDSEED or
-	RDRAND, IBM for the S390 and Power PC architectures) is trustworthy
-	for the purposes of initializing Linux's CRNG.  Since this is not
-	something that can be independently audited, this amounts to trusting
-	that CPU manufacturer (perhaps with the insistence or mandate
-	of a Nation State's intelligence or law enforcement agencies)
-	has not installed a hidden back door to compromise the CPU's
-	random number generation facilities. This can also be configured
-	at boot with "random.trust_cpu=on/off".
+	  Initialize the RNG using random numbers supplied by the CPU's
+	  RNG instructions (e.g. RDRAND), if supported and available. These
+	  random numbers are never used directly, but are rather hashed into
+	  the main input pool, and this happens regardless of whether or not
+	  this option is enabled. Instead, this option controls whether the
+	  they are credited and hence can initialize the RNG. Additionally,
+	  other sources of randomness are always used, regardless of this
+	  setting.  Enabling this implies trusting that the CPU can supply high
+	  quality and non-backdoored random numbers.
+
+	  Say Y here unless you have reason to mistrust your CPU or believe
+	  its RNG facilities may be faulty. This may also be configured at
+	  boot time with "random.trust_cpu=on/off".
 
 config RANDOM_TRUST_BOOTLOADER
-	bool "Trust the bootloader to initialize Linux's CRNG"
-	help
-	Some bootloaders can provide entropy to increase the kernel's initial
-	device randomness. Say Y here to assume the entropy provided by the
-	booloader is trustworthy so it will be added to the kernel's entropy
-	pool. Otherwise, say N here so it will be regarded as device input that
-	only mixes the entropy pool. This can also be configured at boot with
-	"random.trust_bootloader=on/off".
+	bool "Initialize RNG using bootloader-supplied seed"
+	default y
+	help
+	  Initialize the RNG using a seed supplied by the bootloader or boot
+	  environment (e.g. EFI or a bootloader-generated device tree). This
+	  seed is not used directly, but is rather hashed into the main input
+	  pool, and this happens regardless of whether or not this option is
+	  enabled. Instead, this option controls whether the seed is credited
+	  and hence can initialize the RNG. Additionally, other sources of
+	  randomness are always used, regardless of this setting. Enabling
+	  this implies trusting that the bootloader can supply high quality and
+	  non-backdoored seeds.
+
+	  Say Y here unless you have reason to mistrust your bootloader or
+	  believe its RNG facilities may be faulty. This may also be configured
+	  at boot time with "random.trust_bootloader=on/off".
 
 endmenu
diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 18f5b7c3ca9d..74dabcdf81ab 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -659,7 +659,7 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_UART2_ROOT] = imx_clk_hw_gate4("uart2_root_clk", "uart2", ccm_base + 0x44a0, 0);
 	hws[IMX8MP_CLK_UART3_ROOT] = imx_clk_hw_gate4("uart3_root_clk", "uart3", ccm_base + 0x44b0, 0);
 	hws[IMX8MP_CLK_UART4_ROOT] = imx_clk_hw_gate4("uart4_root_clk", "uart4", ccm_base + 0x44c0, 0);
-	hws[IMX8MP_CLK_USB_ROOT] = imx_clk_hw_gate4("usb_root_clk", "osc_32k", ccm_base + 0x44d0, 0);
+	hws[IMX8MP_CLK_USB_ROOT] = imx_clk_hw_gate4("usb_root_clk", "hsio_axi", ccm_base + 0x44d0, 0);
 	hws[IMX8MP_CLK_USB_PHY_ROOT] = imx_clk_hw_gate4("usb_phy_root_clk", "usb_phy_ref", ccm_base + 0x44f0, 0);
 	hws[IMX8MP_CLK_USDHC1_ROOT] = imx_clk_hw_gate4("usdhc1_root_clk", "usdhc1", ccm_base + 0x4510, 0);
 	hws[IMX8MP_CLK_USDHC2_ROOT] = imx_clk_hw_gate4("usdhc2_root_clk", "usdhc2", ccm_base + 0x4520, 0);
diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index ff188ab68496..bb47610bbd1c 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -565,4 +565,3 @@ void __init hv_init_clocksource(void)
 	hv_sched_clock_offset = hv_read_reference_counter();
 	hv_setup_sched_clock(read_hv_sched_clock_msr);
 }
-EXPORT_SYMBOL_GPL(hv_init_clocksource);
diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
index 46023adc5395..4536ed43f65b 100644
--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -684,7 +684,7 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
+	size = max(usb_endpoint_maxp(devpriv->ep_tx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;
diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index b0f3aca61974..9467d695a33e 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -652,10 +652,9 @@ static int dwapb_get_clks(struct dwapb_gpio *gpio)
 	gpio->clks[1].id = "db";
 	err = devm_clk_bulk_get_optional(gpio->dev, DWAPB_NR_CLOCKS,
 					 gpio->clks);
-	if (err) {
-		dev_err(gpio->dev, "Cannot get APB/Debounce clocks\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(gpio->dev, err,
+				     "Cannot get APB/Debounce clocks\n");
 
 	err = clk_bulk_prepare_enable(DWAPB_NR_CLOCKS, gpio->clks);
 	if (err) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index cd89d2e46852..f4509656ea8c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1955,9 +1955,6 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct amdgpu_device *adev,
 		return -EINVAL;
 	}
 
-	/* delete kgd_mem from kfd_bo_list to avoid re-validating
-	 * this BO in BO's restoring after eviction.
-	 */
 	mutex_lock(&mem->process_info->lock);
 
 	ret = amdgpu_bo_reserve(bo, true);
@@ -1980,7 +1977,6 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct amdgpu_device *adev,
 
 	amdgpu_amdkfd_remove_eviction_fence(
 		bo, mem->process_info->eviction_fence);
-	list_del_init(&mem->validate_list.head);
 
 	if (size)
 		*size = amdgpu_bo_size(bo);
@@ -2544,12 +2540,15 @@ int amdgpu_amdkfd_gpuvm_restore_process_bos(void *info, struct dma_fence **ef)
 	process_info->eviction_fence = new_fence;
 	*ef = dma_fence_get(&new_fence->base);
 
-	/* Attach new eviction fence to all BOs */
+	/* Attach new eviction fence to all BOs except pinned ones */
 	list_for_each_entry(mem, &process_info->kfd_bo_list,
-		validate_list.head)
+		validate_list.head) {
+		if (mem->bo->tbo.pin_count)
+			continue;
+
 		amdgpu_bo_fence(mem->bo,
 			&process_info->eviction_fence->base, true);
-
+	}
 	/* Attach eviction fence to PD / PT BOs */
 	list_for_each_entry(peer_vm, &process_info->vm_list_head,
 			    vm_list_node) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 28a736c507bb..bd3b32e5ba9e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -625,17 +625,20 @@ int amdgpu_get_gfx_off_status(struct amdgpu_device *adev, uint32_t *value)
 int amdgpu_gfx_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *ras_block)
 {
 	int r;
-	r = amdgpu_ras_block_late_init(adev, ras_block);
-	if (r)
-		return r;
 
 	if (amdgpu_ras_is_supported(adev, ras_block->block)) {
 		if (!amdgpu_persistent_edc_harvesting_supported(adev))
 			amdgpu_ras_reset_error_status(adev, AMDGPU_RAS_BLOCK__GFX);
 
+		r = amdgpu_ras_block_late_init(adev, ras_block);
+		if (r)
+			return r;
+
 		r = amdgpu_irq_get(adev, &adev->gfx.cp_ecc_error_irq, 0);
 		if (r)
 			goto late_fini;
+	} else {
+		amdgpu_ras_feature_enable_on_boot(adev, ras_block, 0);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 6b626c293e72..49c55d82cba8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -634,7 +634,6 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 			    atomic64_read(&adev->visible_pin_size),
 			    vram_gtt.vram_size);
 		vram_gtt.gtt_size = ttm_manager_type(&adev->mman.bdev, TTM_PL_TT)->size;
-		vram_gtt.gtt_size *= PAGE_SIZE;
 		vram_gtt.gtt_size -= atomic64_read(&adev->gart_pin_size);
 		return copy_to_user(out, &vram_gtt,
 				    min((size_t)size, sizeof(vram_gtt))) ? -EFAULT : 0;
@@ -667,7 +666,6 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 			mem.cpu_accessible_vram.usable_heap_size * 3 / 4;
 
 		mem.gtt.total_heap_size = gtt_man->size;
-		mem.gtt.total_heap_size *= PAGE_SIZE;
 		mem.gtt.usable_heap_size = mem.gtt.total_heap_size -
 			atomic64_read(&adev->gart_pin_size);
 		mem.gtt.heap_usage = ttm_resource_manager_usage(gtt_man);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 424c22a841f4..3f96dadf2698 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -195,6 +195,13 @@ static ssize_t amdgpu_ras_debugfs_read(struct file *f, char __user *buf,
 	if (amdgpu_ras_query_error_status(obj->adev, &info))
 		return -EINVAL;
 
+	/* Hardware counter will be reset automatically after the query on Vega20 and Arcturus */
+	if (obj->adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 2) &&
+	    obj->adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 4)) {
+		if (amdgpu_ras_reset_error_status(obj->adev, info.head.block))
+			dev_warn(obj->adev->dev, "Failed to reset error counter and error status");
+	}
+
 	s = snprintf(val, sizeof(val), "%s: %lu\n%s: %lu\n",
 			"ue", info.ue_count,
 			"ce", info.ce_count);
@@ -548,9 +555,10 @@ static ssize_t amdgpu_ras_sysfs_read(struct device *dev,
 	if (amdgpu_ras_query_error_status(obj->adev, &info))
 		return -EINVAL;
 
-	if (obj->adev->asic_type == CHIP_ALDEBARAN) {
+	if (obj->adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 2) &&
+	    obj->adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 4)) {
 		if (amdgpu_ras_reset_error_status(obj->adev, info.head.block))
-			DRM_WARN("Failed to reset error counter and error status");
+			dev_warn(obj->adev->dev, "Failed to reset error counter and error status");
 	}
 
 	return sysfs_emit(buf, "%s: %lu\n%s: %lu\n", "ue", info.ue_count,
@@ -1023,9 +1031,6 @@ int amdgpu_ras_query_error_status(struct amdgpu_device *adev,
 		}
 	}
 
-	if (!amdgpu_persistent_edc_harvesting_supported(adev))
-		amdgpu_ras_reset_error_status(adev, info->head.block);
-
 	return 0;
 }
 
@@ -1145,6 +1150,12 @@ int amdgpu_ras_query_error_count(struct amdgpu_device *adev,
 		if (res)
 			return res;
 
+		if (adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 2) &&
+		    adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 4)) {
+			if (amdgpu_ras_reset_error_status(adev, info.head.block))
+				dev_warn(adev->dev, "Failed to reset error counter and error status");
+		}
+
 		ce += info.ce_count;
 		ue += info.ue_count;
 	}
@@ -1705,6 +1716,12 @@ static void amdgpu_ras_log_on_err_counter(struct amdgpu_device *adev)
 			continue;
 
 		amdgpu_ras_query_error_status(adev, &info);
+
+		if (adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 2) &&
+		    adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 4)) {
+			if (amdgpu_ras_reset_error_status(adev, info.head.block))
+				dev_warn(adev->dev, "Failed to reset error counter and error status");
+		}
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 3b8856b4cece..5979335d7afd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -2286,6 +2286,8 @@ svm_range_cpu_invalidate_pagetables(struct mmu_interval_notifier *mni,
 
 	if (range->event == MMU_NOTIFY_RELEASE)
 		return true;
+	if (!mmget_not_zero(mni->mm))
+		return true;
 
 	start = mni->interval_tree.start;
 	last = mni->interval_tree.last;
@@ -2312,6 +2314,7 @@ svm_range_cpu_invalidate_pagetables(struct mmu_interval_notifier *mni,
 	}
 
 	svm_range_unlock(prange);
+	mmput(mni->mm);
 
 	return true;
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 8dd03de7c277..78a38c3b7d66 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2835,7 +2835,7 @@ static struct drm_mode_config_helper_funcs amdgpu_dm_mode_config_helperfuncs = {
 
 static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 {
-	u32 max_cll, min_cll, max, min, q, r;
+	u32 max_avg, min_cll, max, min, q, r;
 	struct amdgpu_dm_backlight_caps *caps;
 	struct amdgpu_display_manager *dm;
 	struct drm_connector *conn_base;
@@ -2865,7 +2865,7 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 	caps = &dm->backlight_caps[i];
 	caps->ext_caps = &aconnector->dc_link->dpcd_sink_ext_caps;
 	caps->aux_support = false;
-	max_cll = conn_base->hdr_sink_metadata.hdmi_type1.max_cll;
+	max_avg = conn_base->hdr_sink_metadata.hdmi_type1.max_fall;
 	min_cll = conn_base->hdr_sink_metadata.hdmi_type1.min_cll;
 
 	if (caps->ext_caps->bits.oled == 1 /*||
@@ -2893,8 +2893,8 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 	 * The results of the above expressions can be verified at
 	 * pre_computed_values.
 	 */
-	q = max_cll >> 5;
-	r = max_cll % 32;
+	q = max_avg >> 5;
+	r = max_avg % 32;
 	max = (1 << q) * pre_computed_values[r];
 
 	// min luminance: maxLum * (CV/255)^2 / 100
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
index d94fd1010deb..8b12b4111c88 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
@@ -230,9 +230,7 @@ static void enc31_hw_init(struct link_encoder *enc)
 	AUX_RX_PHASE_DETECT_LEN,  [21,20] = 0x3 default is 3
 	AUX_RX_DETECTION_THRESHOLD [30:28] = 1
 */
-	AUX_REG_WRITE(AUX_DPHY_RX_CONTROL0, 0x103d1110);
-
-	AUX_REG_WRITE(AUX_DPHY_TX_CONTROL, 0x21c7a);
+	// dmub will read AUX_DPHY_RX_CONTROL0/AUX_DPHY_TX_CONTROL from vbios table in dp_aux_init
 
 	//AUX_DPHY_TX_REF_CONTROL'AUX_TX_REF_DIV HW default is 0x32;
 	// Set AUX_TX_REF_DIV Divider to generate 2 MHz reference from refclk
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index d71e625cc476..559cf10831be 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -1392,12 +1392,6 @@ static struct stream_encoder *dcn31_stream_encoder_create(
 		return NULL;
 	}
 
-	if (ctx->asic_id.chip_family == FAMILY_YELLOW_CARP &&
-			ctx->asic_id.hw_internal_rev == YELLOW_CARP_B0) {
-		if ((eng_id == ENGINE_ID_DIGC) || (eng_id == ENGINE_ID_DIGD))
-			eng_id = eng_id + 3; // For B0 only. C->F, D->G.
-	}
-
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios,
 					eng_id, vpg, afmt,
 					&stream_enc_regs[eng_id],
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
index c88113044494..9b6fbad47646 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
@@ -154,7 +154,7 @@ __uc_fw_auto_select(struct drm_i915_private *i915, struct intel_uc_fw *uc_fw)
 		[INTEL_UC_FW_TYPE_GUC] = { blobs_guc, ARRAY_SIZE(blobs_guc) },
 		[INTEL_UC_FW_TYPE_HUC] = { blobs_huc, ARRAY_SIZE(blobs_huc) },
 	};
-	static const struct uc_fw_platform_requirement *fw_blobs;
+	const struct uc_fw_platform_requirement *fw_blobs;
 	enum intel_platform p = INTEL_INFO(i915)->platform;
 	u32 fw_count;
 	u8 rev = INTEL_REVID(i915);
diff --git a/drivers/gpu/drm/i915/i915_sysfs.c b/drivers/gpu/drm/i915/i915_sysfs.c
index a4d1759375b9..66a8880eaf19 100644
--- a/drivers/gpu/drm/i915/i915_sysfs.c
+++ b/drivers/gpu/drm/i915/i915_sysfs.c
@@ -432,7 +432,14 @@ static ssize_t error_state_read(struct file *filp, struct kobject *kobj,
 	struct device *kdev = kobj_to_dev(kobj);
 	struct drm_i915_private *i915 = kdev_minor_to_i915(kdev);
 	struct i915_gpu_coredump *gpu;
-	ssize_t ret;
+	ssize_t ret = 0;
+
+	/*
+	 * FIXME: Concurrent clients triggering resets and reading + clearing
+	 * dumps can cause inconsistent sysfs reads when a user calls in with a
+	 * non-zero offset to complete a prior partial read but the
+	 * gpu_coredump has been cleared or replaced.
+	 */
 
 	gpu = i915_first_error_state(i915);
 	if (IS_ERR(gpu)) {
@@ -444,8 +451,10 @@ static ssize_t error_state_read(struct file *filp, struct kobject *kobj,
 		const char *str = "No error state collected\n";
 		size_t len = strlen(str);
 
-		ret = min_t(size_t, count, len - off);
-		memcpy(buf, str + off, ret);
+		if (off < len) {
+			ret = min_t(size_t, count, len - off);
+			memcpy(buf, str + off, ret);
+		}
 	}
 
 	return ret;
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 85a2142c9384..073ff9b6f535 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -637,6 +637,7 @@ static void vmbus_process_offer(struct vmbus_channel *newchannel)
 		 */
 		if (newchannel->offermsg.offer.sub_channel_index == 0) {
 			mutex_unlock(&vmbus_connection.channel_mutex);
+			cpus_read_unlock();
 			/*
 			 * Don't call free_channel(), because newchannel->kobj
 			 * is not initialized yet.
diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 9f8574320eb2..b08e5bc2b64c 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -477,9 +477,6 @@ int i2c_dw_prepare_clk(struct dw_i2c_dev *dev, bool prepare)
 {
 	int ret;
 
-	if (IS_ERR(dev->clk))
-		return PTR_ERR(dev->clk);
-
 	if (prepare) {
 		/* Optional interface clock */
 		ret = clk_prepare_enable(dev->pclk);
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 70ade5306e45..ba043b547393 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -320,8 +320,17 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 		goto exit_reset;
 	}
 
-	dev->clk = devm_clk_get(&pdev->dev, NULL);
-	if (!i2c_dw_prepare_clk(dev, true)) {
+	dev->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(dev->clk)) {
+		ret = PTR_ERR(dev->clk);
+		goto exit_reset;
+	}
+
+	ret = i2c_dw_prepare_clk(dev, true);
+	if (ret)
+		goto exit_reset;
+
+	if (dev->clk) {
 		u64 clk_khz;
 
 		dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index bdecb78bfc26..8e6985354fd5 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1420,17 +1420,22 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"Request I2C IRQ %d fail\n", irq);
-		return ret;
+		goto err_bulk_unprepare;
 	}
 
 	i2c_set_adapdata(&i2c->adap, i2c);
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret)
-		return ret;
+		goto err_bulk_unprepare;
 
 	platform_set_drvdata(pdev, i2c);
 
 	return 0;
+
+err_bulk_unprepare:
+	clk_bulk_unprepare(I2C_MT65XX_CLK_MAX, i2c->clocks);
+
+	return ret;
 }
 
 static int mtk_i2c_remove(struct platform_device *pdev)
diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index c638f2efb97c..743ac20a405c 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -2369,8 +2369,7 @@ static struct platform_driver npcm_i2c_bus_driver = {
 static int __init npcm_i2c_init(void)
 {
 	npcm_i2c_debugfs_dir = debugfs_create_dir("npcm_i2c", NULL);
-	platform_driver_register(&npcm_i2c_bus_driver);
-	return 0;
+	return platform_driver_register(&npcm_i2c_bus_driver);
 }
 module_init(npcm_i2c_init);
 
diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index cbb1599a520e..480476121c01 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -85,13 +85,13 @@ static const struct dmi_system_id dmi_use_low_level_irq[] = {
 	},
 	{
 		/*
-		 * Lenovo Yoga Tab2 1051L, something messes with the home-button
+		 * Lenovo Yoga Tab2 1051F/1051L, something messes with the home-button
 		 * IRQ settings, leading to a non working home-button.
 		 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "60073"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1051L"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1051"),
 		},
 	},
 	{} /* Terminating entry */
diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index 12dd48727a15..5ac83185ff47 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -1035,6 +1035,7 @@ static void build_fiq_affinity(struct aic_irq_chip *ic, struct device_node *aff)
 			continue;
 
 		cpu = of_cpu_node_to_id(cpu_node);
+		of_node_put(cpu_node);
 		if (WARN_ON(cpu < 0))
 			continue;
 
@@ -1143,6 +1144,7 @@ static int __init aic_of_ic_init(struct device_node *node, struct device_node *p
 		for_each_child_of_node(affs, chld)
 			build_fiq_affinity(irqc, chld);
 	}
+	of_node_put(affs);
 
 	set_handle_irq(aic_handle_irq);
 	set_handle_fiq(aic_handle_fiq);
diff --git a/drivers/irqchip/irq-gic-realview.c b/drivers/irqchip/irq-gic-realview.c
index b4c1924f0255..38fab02ffe9d 100644
--- a/drivers/irqchip/irq-gic-realview.c
+++ b/drivers/irqchip/irq-gic-realview.c
@@ -57,6 +57,7 @@ realview_gic_of_init(struct device_node *node, struct device_node *parent)
 
 	/* The PB11MPCore GIC needs to be configured in the syscon */
 	map = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (!IS_ERR(map)) {
 		/* new irq mode with no DCC */
 		regmap_write(map, REALVIEW_SYS_LOCK_OFFSET,
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 1af2b50f36f3..d5420f9d6219 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1922,7 +1922,7 @@ static void __init gic_populate_ppi_partitions(struct device_node *gic_node)
 
 	gic_data.ppi_descs = kcalloc(gic_data.ppi_nr, sizeof(*gic_data.ppi_descs), GFP_KERNEL);
 	if (!gic_data.ppi_descs)
-		return;
+		goto out_put_node;
 
 	nr_parts = of_get_child_count(parts_node);
 
@@ -1963,12 +1963,15 @@ static void __init gic_populate_ppi_partitions(struct device_node *gic_node)
 				continue;
 
 			cpu = of_cpu_node_to_id(cpu_node);
-			if (WARN_ON(cpu < 0))
+			if (WARN_ON(cpu < 0)) {
+				of_node_put(cpu_node);
 				continue;
+			}
 
 			pr_cont("%pOF[%d] ", cpu_node, cpu);
 
 			cpumask_set_cpu(cpu, &part->mask);
+			of_node_put(cpu_node);
 		}
 
 		pr_cont("}\n");
diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 50a56820c99b..56bf502d9c67 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -134,9 +134,9 @@ static int __init map_interrupts(struct device_node *node, struct irq_domain *do
 		if (!cpu_ictl)
 			return -EINVAL;
 		ret = of_property_read_u32(cpu_ictl, "#interrupt-cells", &tmp);
+		of_node_put(cpu_ictl);
 		if (ret || tmp != 1)
 			return -EINVAL;
-		of_node_put(cpu_ictl);
 
 		cpu_int = be32_to_cpup(imap + 2);
 		if (cpu_int > 7 || cpu_int < 2)
diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index a6606736d8c5..2776ca5fc33f 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -121,7 +121,7 @@ mISDN_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (sk->sk_state == MISDN_CLOSED)
 		return 0;
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		return err;
 
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 4277853c7535..3cd78f1e82a4 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -32,6 +32,14 @@ struct dm_kobject_holder {
  * access their members!
  */
 
+/*
+ * For mempools pre-allocation at the table loading time.
+ */
+struct dm_md_mempools {
+	struct bio_set bs;
+	struct bio_set io_bs;
+};
+
 struct mapped_device {
 	struct mutex suspend_lock;
 
@@ -109,8 +117,7 @@ struct mapped_device {
 	/*
 	 * io objects are allocated from here.
 	 */
-	struct bio_set io_bs;
-	struct bio_set bs;
+	struct dm_md_mempools *mempools;
 
 	/* kobject and completion */
 	struct dm_kobject_holder kobj_holder;
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 06f328928a7f..2dda05aada23 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -415,8 +415,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	/*
 	 * Work out how many "unsigned long"s we need to hold the bitset.
 	 */
-	bitset_size = dm_round_up(region_count,
-				  sizeof(*lc->clean_bits) << BYTE_SHIFT);
+	bitset_size = dm_round_up(region_count, BITS_PER_LONG);
 	bitset_size >>= BYTE_SHIFT;
 
 	lc->bitset_uint32_count = bitset_size / sizeof(*lc->clean_bits);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 6087cdcaad46..a83b98a8d2a9 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -319,7 +319,7 @@ static int setup_clone(struct request *clone, struct request *rq,
 {
 	int r;
 
-	r = blk_rq_prep_clone(clone, rq, &tio->md->bs, gfp_mask,
+	r = blk_rq_prep_clone(clone, rq, &tio->md->mempools->bs, gfp_mask,
 			      dm_rq_bio_constructor, tio);
 	if (r)
 		return r;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 03541cfc2317..4b5cf3372699 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1030,17 +1030,6 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 	return 0;
 }
 
-void dm_table_free_md_mempools(struct dm_table *t)
-{
-	dm_free_md_mempools(t->mempools);
-	t->mempools = NULL;
-}
-
-struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t)
-{
-	return t->mempools;
-}
-
 static int setup_indexes(struct dm_table *t)
 {
 	int i;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 82957bd460e8..83dd17abf1af 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -131,14 +131,6 @@ static int get_swap_bios(void)
 	return latch;
 }
 
-/*
- * For mempools pre-allocation at the table loading time.
- */
-struct dm_md_mempools {
-	struct bio_set bs;
-	struct bio_set io_bs;
-};
-
 struct table_device {
 	struct list_head list;
 	refcount_t count;
@@ -551,6 +543,10 @@ static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
 			return;
 		/* Can afford locking given DM_TIO_IS_DUPLICATE_BIO */
 		spin_lock_irqsave(&io->lock, flags);
+		if (dm_io_flagged(io, DM_IO_ACCOUNTED)) {
+			spin_unlock_irqrestore(&io->lock, flags);
+			return;
+		}
 		dm_io_set_flag(io, DM_IO_ACCOUNTED);
 		spin_unlock_irqrestore(&io->lock, flags);
 	}
@@ -569,7 +565,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	struct dm_target_io *tio;
 	struct bio *clone;
 
-	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO, &md->io_bs);
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO, &md->mempools->io_bs);
 
 	tio = clone_to_tio(clone);
 	tio->flags = 0;
@@ -611,7 +607,7 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 		clone = &tio->clone;
 	} else {
 		clone = bio_alloc_clone(ci->bio->bi_bdev, ci->bio,
-					gfp_mask, &ci->io->md->bs);
+					gfp_mask, &ci->io->md->mempools->bs);
 		if (!clone)
 			return NULL;
 
@@ -1771,8 +1767,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
 {
 	if (md->wq)
 		destroy_workqueue(md->wq);
-	bioset_exit(&md->bs);
-	bioset_exit(&md->io_bs);
+	dm_free_md_mempools(md->mempools);
 
 	if (md->dax_dev) {
 		dax_remove_host(md->disk);
@@ -1944,48 +1939,6 @@ static void free_dev(struct mapped_device *md)
 	kvfree(md);
 }
 
-static int __bind_mempools(struct mapped_device *md, struct dm_table *t)
-{
-	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
-	int ret = 0;
-
-	if (dm_table_bio_based(t)) {
-		/*
-		 * The md may already have mempools that need changing.
-		 * If so, reload bioset because front_pad may have changed
-		 * because a different table was loaded.
-		 */
-		bioset_exit(&md->bs);
-		bioset_exit(&md->io_bs);
-
-	} else if (bioset_initialized(&md->bs)) {
-		/*
-		 * There's no need to reload with request-based dm
-		 * because the size of front_pad doesn't change.
-		 * Note for future: If you are to reload bioset,
-		 * prep-ed requests in the queue may refer
-		 * to bio from the old bioset, so you must walk
-		 * through the queue to unprep.
-		 */
-		goto out;
-	}
-
-	BUG_ON(!p ||
-	       bioset_initialized(&md->bs) ||
-	       bioset_initialized(&md->io_bs));
-
-	ret = bioset_init_from_src(&md->bs, &p->bs);
-	if (ret)
-		goto out;
-	ret = bioset_init_from_src(&md->io_bs, &p->io_bs);
-	if (ret)
-		bioset_exit(&md->bs);
-out:
-	/* mempool bind completed, no longer need any mempools in the table */
-	dm_table_free_md_mempools(t);
-	return ret;
-}
-
 /*
  * Bind a table to the device.
  */
@@ -2039,12 +1992,28 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		 * immutable singletons - used to optimize dm_mq_queue_rq.
 		 */
 		md->immutable_target = dm_table_get_immutable_target(t);
-	}
 
-	ret = __bind_mempools(md, t);
-	if (ret) {
-		old_map = ERR_PTR(ret);
-		goto out;
+		/*
+		 * There is no need to reload with request-based dm because the
+		 * size of front_pad doesn't change.
+		 *
+		 * Note for future: If you are to reload bioset, prep-ed
+		 * requests in the queue may refer to bio from the old bioset,
+		 * so you must walk through the queue to unprep.
+		 */
+		if (!md->mempools) {
+			md->mempools = t->mempools;
+			t->mempools = NULL;
+		}
+	} else {
+		/*
+		 * The md may already have mempools that need changing.
+		 * If so, reload bioset because front_pad may have changed
+		 * because a different table was loaded.
+		 */
+		dm_free_md_mempools(md->mempools);
+		md->mempools = t->mempools;
+		t->mempools = NULL;
 	}
 
 	ret = dm_table_set_restrictions(t, md->queue, limits);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 9013dc1a7b00..968199b95fd1 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -71,8 +71,6 @@ struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
 bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
-void dm_table_free_md_mempools(struct dm_table *t);
-struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index d3962d92df18..18acbbed8f0c 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -629,9 +629,9 @@ static void ppl_do_flush(struct ppl_io_unit *io)
 		if (bdev) {
 			struct bio *bio;
 
-			bio = bio_alloc_bioset(bdev, 0, GFP_NOIO,
+			bio = bio_alloc_bioset(bdev, 0,
 					       REQ_OP_WRITE | REQ_PREFLUSH,
-					       &ppl_conf->flush_bs);
+					       GFP_NOIO, &ppl_conf->flush_bs);
 			bio->bi_private = io;
 			bio->bi_end_io = ppl_flush_endio;
 
diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index d6cd5537126c..69f9b0336410 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -232,9 +232,9 @@ static int ssc_probe(struct platform_device *pdev)
 	clk_disable_unprepare(ssc->clk);
 
 	ssc->irq = platform_get_irq(pdev, 0);
-	if (!ssc->irq) {
+	if (ssc->irq < 0) {
 		dev_dbg(&pdev->dev, "could not get irq\n");
-		return -ENXIO;
+		return ssc->irq;
 	}
 
 	mutex_lock(&user_lock);
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index cebcca6d6d3e..cf2b8261da14 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1351,7 +1351,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_CAP_SETUP) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: capabilities response: on shutdown, ignoring\n");
 				return 0;
 			}
diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 64ce3f830262..15e8e2b322b1 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -109,6 +109,8 @@
 #define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
 #define MEI_DEV_ID_ADP_N      0x54E0  /* Alder Lake Point N */
 
+#define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
+
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 33e58821e478..5435604327a7 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -116,6 +116,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_N, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index e6f48786949c..02bd3cf9a260 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -332,7 +332,6 @@ static void bgmac_remove(struct bcma_device *core)
 	bcma_mdio_mii_unregister(bgmac->mii_bus);
 	bgmac_enet_remove(bgmac);
 	bcma_set_drvdata(core, NULL);
-	kfree(bgmac);
 }
 
 static struct bcma_driver bgmac_bcma_driver = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 79c64f4e67d2..3affcdb34c91 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -765,6 +765,7 @@ struct hnae3_tc_info {
 	u8 prio_tc[HNAE3_MAX_USER_PRIO]; /* TC indexed by prio */
 	u16 tqp_count[HNAE3_MAX_TC];
 	u16 tqp_offset[HNAE3_MAX_TC];
+	u8 max_tc; /* Total number of TCs */
 	u8 num_tc; /* Total number of enabled TCs */
 	bool mqprio_active;
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8cebb180c812..c0b4ff73128f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3276,7 +3276,7 @@ static int hclge_tp_port_init(struct hclge_dev *hdev)
 static int hclge_update_port_info(struct hclge_dev *hdev)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
-	int speed = HCLGE_MAC_SPEED_UNKNOWN;
+	int speed;
 	int ret;
 
 	/* get the port info from SFP cmd if not copper port */
@@ -3287,10 +3287,13 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 	if (!hdev->support_sfp_query)
 		return 0;
 
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+		speed = mac->speed;
 		ret = hclge_get_sfp_info(hdev, mac);
-	else
+	} else {
+		speed = HCLGE_MAC_SPEED_UNKNOWN;
 		ret = hclge_get_sfp_speed(hdev, &speed);
+	}
 
 	if (ret == -EOPNOTSUPP) {
 		hdev->support_sfp_query = false;
@@ -3302,6 +3305,8 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		if (mac->speed_type == QUERY_ACTIVE_SPEED) {
 			hclge_update_port_capability(hdev, mac);
+			if (mac->speed != speed)
+				(void)hclge_tm_port_shaper_cfg(hdev);
 			return 0;
 		}
 		return hclge_cfg_mac_speed_dup(hdev, mac->speed,
@@ -3384,6 +3389,12 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
 	link_state_old = vport->vf_info.link_state;
 	vport->vf_info.link_state = link_state;
 
+	/* return success directly if the VF is unalive, VF will
+	 * query link state itself when it starts work.
+	 */
+	if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+		return 0;
+
 	ret = hclge_push_vf_link_status(vport);
 	if (ret) {
 		vport->vf_info.link_state = link_state_old;
@@ -10136,6 +10147,7 @@ static int hclge_modify_port_base_vlan_tag(struct hclge_vport *vport,
 	if (ret)
 		return ret;
 
+	vport->port_base_vlan_cfg.tbl_sta = false;
 	/* remove old VLAN tag */
 	if (old_info->vlan_tag == 0)
 		ret = hclge_set_vf_vlan_common(hdev, vport->vport_id,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 1f87a8a3fe32..2f33b036a47a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -282,8 +282,8 @@ static int hclge_tm_pg_to_pri_map_cfg(struct hclge_dev *hdev,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
-static int hclge_tm_qs_to_pri_map_cfg(struct hclge_dev *hdev,
-				      u16 qs_id, u8 pri)
+static int hclge_tm_qs_to_pri_map_cfg(struct hclge_dev *hdev, u16 qs_id, u8 pri,
+				      bool link_vld)
 {
 	struct hclge_qs_to_pri_link_cmd *map;
 	struct hclge_desc desc;
@@ -294,7 +294,7 @@ static int hclge_tm_qs_to_pri_map_cfg(struct hclge_dev *hdev,
 
 	map->qs_id = cpu_to_le16(qs_id);
 	map->priority = pri;
-	map->link_vld = HCLGE_TM_QS_PRI_LINK_VLD_MSK;
+	map->link_vld = link_vld ? HCLGE_TM_QS_PRI_LINK_VLD_MSK : 0;
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
@@ -420,7 +420,7 @@ static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
-static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
+int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_port_shapping_cmd *shap_cfg_cmd;
 	struct hclge_shaper_ir_para ir_para;
@@ -642,11 +642,13 @@ static void hclge_tm_update_kinfo_rss_size(struct hclge_vport *vport)
 	 * one tc for VF for simplicity. VF's vport_id is non zero.
 	 */
 	if (vport->vport_id) {
+		kinfo->tc_info.max_tc = 1;
 		kinfo->tc_info.num_tc = 1;
 		vport->qs_offset = HNAE3_MAX_TC +
 				   vport->vport_id - HCLGE_VF_VPORT_START_NUM;
 		vport_max_rss_size = hdev->vf_rss_size_max;
 	} else {
+		kinfo->tc_info.max_tc = hdev->tc_max;
 		kinfo->tc_info.num_tc =
 			min_t(u16, vport->alloc_tqps, hdev->tm_info.num_tc);
 		vport->qs_offset = 0;
@@ -679,7 +681,9 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	kinfo->num_tqps = hclge_vport_get_tqp_num(vport);
 	vport->dwrr = 100;  /* 100 percent as init */
 	vport->bw_limit = hdev->tm_info.pg_info[0].bw_limit;
-	hdev->rss_cfg.rss_size = kinfo->rss_size;
+
+	if (vport->vport_id == PF_VPORT_ID)
+		hdev->rss_cfg.rss_size = kinfo->rss_size;
 
 	/* when enable mqprio, the tc_info has been updated. */
 	if (kinfo->tc_info.mqprio_active)
@@ -714,14 +718,22 @@ static void hclge_tm_vport_info_update(struct hclge_dev *hdev)
 
 static void hclge_tm_tc_info_init(struct hclge_dev *hdev)
 {
-	u8 i;
+	u8 i, tc_sch_mode;
+	u32 bw_limit;
+
+	for (i = 0; i < hdev->tc_max; i++) {
+		if (i < hdev->tm_info.num_tc) {
+			tc_sch_mode = HCLGE_SCH_MODE_DWRR;
+			bw_limit = hdev->tm_info.pg_info[0].bw_limit;
+		} else {
+			tc_sch_mode = HCLGE_SCH_MODE_SP;
+			bw_limit = 0;
+		}
 
-	for (i = 0; i < hdev->tm_info.num_tc; i++) {
 		hdev->tm_info.tc_info[i].tc_id = i;
-		hdev->tm_info.tc_info[i].tc_sch_mode = HCLGE_SCH_MODE_DWRR;
+		hdev->tm_info.tc_info[i].tc_sch_mode = tc_sch_mode;
 		hdev->tm_info.tc_info[i].pgid = 0;
-		hdev->tm_info.tc_info[i].bw_limit =
-			hdev->tm_info.pg_info[0].bw_limit;
+		hdev->tm_info.tc_info[i].bw_limit = bw_limit;
 	}
 
 	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
@@ -926,10 +938,13 @@ static int hclge_tm_pri_q_qs_cfg_tc_base(struct hclge_dev *hdev)
 	for (k = 0; k < hdev->num_alloc_vport; k++) {
 		struct hnae3_knic_private_info *kinfo = &vport[k].nic.kinfo;
 
-		for (i = 0; i < kinfo->tc_info.num_tc; i++) {
+		for (i = 0; i < kinfo->tc_info.max_tc; i++) {
+			u8 pri = i < kinfo->tc_info.num_tc ? i : 0;
+			bool link_vld = i < kinfo->tc_info.num_tc;
+
 			ret = hclge_tm_qs_to_pri_map_cfg(hdev,
 							 vport[k].qs_offset + i,
-							 i);
+							 pri, link_vld);
 			if (ret)
 				return ret;
 		}
@@ -949,7 +964,7 @@ static int hclge_tm_pri_q_qs_cfg_vnet_base(struct hclge_dev *hdev)
 		for (i = 0; i < HNAE3_MAX_TC; i++) {
 			ret = hclge_tm_qs_to_pri_map_cfg(hdev,
 							 vport[k].qs_offset + i,
-							 k);
+							 k, true);
 			if (ret)
 				return ret;
 		}
@@ -989,33 +1004,39 @@ static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 {
 	u32 max_tm_rate = hdev->ae_dev->dev_specs.max_tm_rate;
 	struct hclge_shaper_ir_para ir_para;
-	u32 shaper_para;
+	u32 shaper_para_c, shaper_para_p;
 	int ret;
 	u32 i;
 
-	for (i = 0; i < hdev->tm_info.num_tc; i++) {
+	for (i = 0; i < hdev->tc_max; i++) {
 		u32 rate = hdev->tm_info.tc_info[i].bw_limit;
 
-		ret = hclge_shaper_para_calc(rate, HCLGE_SHAPER_LVL_PRI,
-					     &ir_para, max_tm_rate);
-		if (ret)
-			return ret;
+		if (rate) {
+			ret = hclge_shaper_para_calc(rate, HCLGE_SHAPER_LVL_PRI,
+						     &ir_para, max_tm_rate);
+			if (ret)
+				return ret;
+
+			shaper_para_c = hclge_tm_get_shapping_para(0, 0, 0,
+								   HCLGE_SHAPER_BS_U_DEF,
+								   HCLGE_SHAPER_BS_S_DEF);
+			shaper_para_p = hclge_tm_get_shapping_para(ir_para.ir_b,
+								   ir_para.ir_u,
+								   ir_para.ir_s,
+								   HCLGE_SHAPER_BS_U_DEF,
+								   HCLGE_SHAPER_BS_S_DEF);
+		} else {
+			shaper_para_c = 0;
+			shaper_para_p = 0;
+		}
 
-		shaper_para = hclge_tm_get_shapping_para(0, 0, 0,
-							 HCLGE_SHAPER_BS_U_DEF,
-							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_C_BUCKET, i,
-						shaper_para, rate);
+						shaper_para_c, rate);
 		if (ret)
 			return ret;
 
-		shaper_para = hclge_tm_get_shapping_para(ir_para.ir_b,
-							 ir_para.ir_u,
-							 ir_para.ir_s,
-							 HCLGE_SHAPER_BS_U_DEF,
-							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_P_BUCKET, i,
-						shaper_para, rate);
+						shaper_para_p, rate);
 		if (ret)
 			return ret;
 	}
@@ -1125,7 +1146,7 @@ static int hclge_tm_pri_tc_base_dwrr_cfg(struct hclge_dev *hdev)
 	int ret;
 	u32 i, k;
 
-	for (i = 0; i < hdev->tm_info.num_tc; i++) {
+	for (i = 0; i < hdev->tc_max; i++) {
 		pg_info =
 			&hdev->tm_info.pg_info[hdev->tm_info.tc_info[i].pgid];
 		dwrr = pg_info->tc_dwrr[i];
@@ -1135,9 +1156,15 @@ static int hclge_tm_pri_tc_base_dwrr_cfg(struct hclge_dev *hdev)
 			return ret;
 
 		for (k = 0; k < hdev->num_alloc_vport; k++) {
+			struct hnae3_knic_private_info *kinfo = &vport[k].nic.kinfo;
+
+			if (i >= kinfo->tc_info.max_tc)
+				continue;
+
+			dwrr = i < kinfo->tc_info.num_tc ? vport[k].dwrr : 0;
 			ret = hclge_tm_qs_weight_cfg(
 				hdev, vport[k].qs_offset + i,
-				vport[k].dwrr);
+				dwrr);
 			if (ret)
 				return ret;
 		}
@@ -1303,6 +1330,7 @@ static int hclge_tm_schd_mode_tc_base_cfg(struct hclge_dev *hdev, u8 pri_id)
 {
 	struct hclge_vport *vport = hdev->vport;
 	int ret;
+	u8 mode;
 	u16 i;
 
 	ret = hclge_tm_pri_schd_mode_cfg(hdev, pri_id);
@@ -1310,9 +1338,16 @@ static int hclge_tm_schd_mode_tc_base_cfg(struct hclge_dev *hdev, u8 pri_id)
 		return ret;
 
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		struct hnae3_knic_private_info *kinfo = &vport[i].nic.kinfo;
+
+		if (pri_id >= kinfo->tc_info.max_tc)
+			continue;
+
+		mode = pri_id < kinfo->tc_info.num_tc ? HCLGE_SCH_MODE_DWRR :
+		       HCLGE_SCH_MODE_SP;
 		ret = hclge_tm_qs_schd_mode_cfg(hdev,
 						vport[i].qs_offset + pri_id,
-						HCLGE_SCH_MODE_DWRR);
+						mode);
 		if (ret)
 			return ret;
 	}
@@ -1353,7 +1388,7 @@ static int hclge_tm_lvl34_schd_mode_cfg(struct hclge_dev *hdev)
 	u8 i;
 
 	if (hdev->tx_sch_mode == HCLGE_FLAG_TC_BASE_SCH_MODE) {
-		for (i = 0; i < hdev->tm_info.num_tc; i++) {
+		for (i = 0; i < hdev->tc_max; i++) {
 			ret = hclge_tm_schd_mode_tc_base_cfg(hdev, i);
 			if (ret)
 				return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 619cc30a2dfc..d943943912f7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -237,6 +237,7 @@ int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
 void hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
 void hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
 int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate);
+int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev);
 int hclge_tm_get_qset_num(struct hclge_dev *hdev, u16 *qset_num);
 int hclge_tm_get_pri_num(struct hclge_dev *hdev, u8 *pri_num);
 int hclge_tm_get_qset_map_pri(struct hclge_dev *hdev, u16 qset_id, u8 *priority,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index e48499624d22..06c05a6b8b71 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2584,15 +2584,16 @@ static void i40e_diag_test(struct net_device *netdev,
 
 		set_bit(__I40E_TESTING, pf->state);
 
+		if (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state) ||
+		    test_bit(__I40E_RESET_INTR_RECEIVED, pf->state)) {
+			dev_warn(&pf->pdev->dev,
+				 "Cannot start offline testing when PF is in reset state.\n");
+			goto skip_ol_tests;
+		}
+
 		if (i40e_active_vfs(pf) || i40e_active_vmdqs(pf)) {
 			dev_warn(&pf->pdev->dev,
 				 "Please take active VFs and Netqueues offline and restart the adapter before running NIC diagnostics\n");
-			data[I40E_ETH_TEST_REG]		= 1;
-			data[I40E_ETH_TEST_EEPROM]	= 1;
-			data[I40E_ETH_TEST_INTR]	= 1;
-			data[I40E_ETH_TEST_LINK]	= 1;
-			eth_test->flags |= ETH_TEST_FL_FAILED;
-			clear_bit(__I40E_TESTING, pf->state);
 			goto skip_ol_tests;
 		}
 
@@ -2639,9 +2640,17 @@ static void i40e_diag_test(struct net_device *netdev,
 		data[I40E_ETH_TEST_INTR] = 0;
 	}
 
-skip_ol_tests:
-
 	netif_info(pf, drv, netdev, "testing finished\n");
+	return;
+
+skip_ol_tests:
+	data[I40E_ETH_TEST_REG]		= 1;
+	data[I40E_ETH_TEST_EEPROM]	= 1;
+	data[I40E_ETH_TEST_INTR]	= 1;
+	data[I40E_ETH_TEST_LINK]	= 1;
+	eth_test->flags |= ETH_TEST_FL_FAILED;
+	clear_bit(__I40E_TESTING, pf->state);
+	netif_info(pf, drv, netdev, "testing failed\n");
 }
 
 static void i40e_get_wol(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 98871f014994..46bb1169a004 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8537,6 +8537,11 @@ static int i40e_configure_clsflower(struct i40e_vsi *vsi,
 		return -EOPNOTSUPP;
 	}
 
+	if (!tc) {
+		dev_err(&pf->pdev->dev, "Unable to add filter because of invalid destination");
+		return -EINVAL;
+	}
+
 	if (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state) ||
 	    test_bit(__I40E_RESET_INTR_RECEIVED, pf->state))
 		return -EBUSY;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 2606e8f0f19b..033ea71763e3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2282,7 +2282,7 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 	}
 
 	if (vf->adq_enabled) {
-		for (i = 0; i < I40E_MAX_VF_VSI; i++)
+		for (i = 0; i < vf->num_tc; i++)
 			num_qps_all += vf->ch[i].num_qps;
 		if (num_qps_all != qci->num_queue_pairs) {
 			aq_ret = I40E_ERR_PARAM;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 7dfcf78b57fb..f3ecb3bca33d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -984,7 +984,7 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 		list_add_tail(&f->list, &adapter->mac_filter_list);
 		f->add = true;
 		f->is_new_mac = true;
-		f->is_primary = false;
+		f->is_primary = ether_addr_equal(macaddr, adapter->hw.mac.addr);
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
 	} else {
 		f->remove = false;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 963a5f40e071..d069b19f9bf7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5746,25 +5746,38 @@ static netdev_features_t
 ice_fix_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	netdev_features_t supported_vlan_filtering;
-	netdev_features_t requested_vlan_filtering;
-	struct ice_vsi *vsi = np->vsi;
-
-	requested_vlan_filtering = features & NETIF_VLAN_FILTERING_FEATURES;
-
-	/* make sure supported_vlan_filtering works for both SVM and DVM */
-	supported_vlan_filtering = NETIF_F_HW_VLAN_CTAG_FILTER;
-	if (ice_is_dvm_ena(&vsi->back->hw))
-		supported_vlan_filtering |= NETIF_F_HW_VLAN_STAG_FILTER;
-
-	if (requested_vlan_filtering &&
-	    requested_vlan_filtering != supported_vlan_filtering) {
-		if (requested_vlan_filtering & NETIF_F_HW_VLAN_CTAG_FILTER) {
-			netdev_warn(netdev, "cannot support requested VLAN filtering settings, enabling all supported VLAN filtering settings\n");
-			features |= supported_vlan_filtering;
+	netdev_features_t req_vlan_fltr, cur_vlan_fltr;
+	bool cur_ctag, cur_stag, req_ctag, req_stag;
+
+	cur_vlan_fltr = netdev->features & NETIF_VLAN_FILTERING_FEATURES;
+	cur_ctag = cur_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER;
+	cur_stag = cur_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER;
+
+	req_vlan_fltr = features & NETIF_VLAN_FILTERING_FEATURES;
+	req_ctag = req_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER;
+	req_stag = req_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER;
+
+	if (req_vlan_fltr != cur_vlan_fltr) {
+		if (ice_is_dvm_ena(&np->vsi->back->hw)) {
+			if (req_ctag && req_stag) {
+				features |= NETIF_VLAN_FILTERING_FEATURES;
+			} else if (!req_ctag && !req_stag) {
+				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+			} else if ((!cur_ctag && req_ctag && !cur_stag) ||
+				   (!cur_stag && req_stag && !cur_ctag)) {
+				features |= NETIF_VLAN_FILTERING_FEATURES;
+				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been enabled for both types.\n");
+			} else if ((cur_ctag && !req_ctag && cur_stag) ||
+				   (cur_stag && !req_stag && cur_ctag)) {
+				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been disabled for both types.\n");
+			}
 		} else {
-			netdev_warn(netdev, "cannot support requested VLAN filtering settings, clearing all supported VLAN filtering settings\n");
-			features &= ~supported_vlan_filtering;
+			if (req_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER)
+				netdev_warn(netdev, "cannot support requested 802.1ad filtering setting in SVM mode\n");
+
+			if (req_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER)
+				features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 		}
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 662947c882e8..ef9344ef0d8e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2271,7 +2271,7 @@ static int
 ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
 {
 	tx->quad = port / ICE_PORTS_PER_QUAD;
-	tx->quad_offset = tx->quad * INDEX_PER_PORT;
+	tx->quad_offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT;
 	tx->len = INDEX_PER_PORT;
 
 	return ice_ptp_alloc_tx_tracker(tx);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index afd048d69959..10e396abf130 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -49,6 +49,37 @@ struct ice_perout_channel {
  * To allow multiple ports to access the shared register block independently,
  * the blocks are split up so that indexes are assigned to each port based on
  * hardware logical port number.
+ *
+ * The timestamp blocks are handled differently for E810- and E822-based
+ * devices. In E810 devices, each port has its own block of timestamps, while in
+ * E822 there is a need to logically break the block of registers into smaller
+ * chunks based on the port number to avoid collisions.
+ *
+ * Example for port 5 in E810:
+ *  +--------+--------+--------+--------+--------+--------+--------+--------+
+ *  |register|register|register|register|register|register|register|register|
+ *  | block  | block  | block  | block  | block  | block  | block  | block  |
+ *  |  for   |  for   |  for   |  for   |  for   |  for   |  for   |  for   |
+ *  | port 0 | port 1 | port 2 | port 3 | port 4 | port 5 | port 6 | port 7 |
+ *  +--------+--------+--------+--------+--------+--------+--------+--------+
+ *                                               ^^
+ *                                               ||
+ *                                               |---  quad offset is always 0
+ *                                               ---- quad number
+ *
+ * Example for port 5 in E822:
+ * +-----------------------------+-----------------------------+
+ * |  register block for quad 0  |  register block for quad 1  |
+ * |+------+------+------+------+|+------+------+------+------+|
+ * ||port 0|port 1|port 2|port 3|||port 0|port 1|port 2|port 3||
+ * |+------+------+------+------+|+------+------+------+------+|
+ * +-----------------------------+-------^---------------------+
+ *                                ^      |
+ *                                |      --- quad offset*
+ *                                ---- quad number
+ *
+ *   * PHY port 5 is port 1 in quad 1
+ *
  */
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index aefd66a4db80..9790df872c2a 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -504,6 +504,11 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	}
 
 	if (ice_is_vf_disabled(vf)) {
+		vsi = ice_get_vf_vsi(vf);
+		if (WARN_ON(!vsi))
+			return -EINVAL;
+		ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
+		ice_vsi_stop_all_rx_rings(vsi);
 		dev_dbg(dev, "VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
 			vf->vf_id);
 		return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 5405a0e752cf..da7c5ce15be0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1587,35 +1587,27 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
  */
 static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 {
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_vsi_queue_config_info *qci =
 	    (struct virtchnl_vsi_queue_config_info *)msg;
 	struct virtchnl_queue_pair_info *qpi;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
-	int i, q_idx;
+	int i = -1, q_idx;
 
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
 		goto error_param;
-	}
 
-	if (!ice_vc_isvalid_vsi_id(vf, qci->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (!ice_vc_isvalid_vsi_id(vf, qci->vsi_id))
 		goto error_param;
-	}
 
 	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (!vsi)
 		goto error_param;
-	}
 
 	if (qci->num_queue_pairs > ICE_MAX_RSS_QS_PER_VF ||
 	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
 		dev_err(ice_pf_to_dev(pf), "VF-%d requesting more than supported number of queues: %d\n",
 			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
@@ -1628,7 +1620,6 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		    !ice_vc_isvalid_ring_len(qpi->txq.ring_len) ||
 		    !ice_vc_isvalid_ring_len(qpi->rxq.ring_len) ||
 		    !ice_vc_isvalid_q_id(vf, qci->vsi_id, qpi->txq.queue_id)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
 
@@ -1638,7 +1629,6 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		 * for selected "vsi"
 		 */
 		if (q_idx >= vsi->alloc_txq || q_idx >= vsi->alloc_rxq) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
 
@@ -1648,14 +1638,13 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			vsi->tx_rings[i]->count = qpi->txq.ring_len;
 
 			/* Disable any existing queue first */
-			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx))
 				goto error_param;
-			}
 
 			/* Configure a queue with the requested settings */
 			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure TX queue %d\n",
+					 vf->vf_id, i);
 				goto error_param;
 			}
 		}
@@ -1669,17 +1658,13 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			if (qpi->rxq.databuffer_size != 0 &&
 			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
-			     qpi->rxq.databuffer_size < 1024)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			     qpi->rxq.databuffer_size < 1024))
 				goto error_param;
-			}
 			vsi->rx_buf_len = qpi->rxq.databuffer_size;
 			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
 			if (qpi->rxq.max_pkt_size > max_frame_size ||
-			    qpi->rxq.max_pkt_size < 64) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			    qpi->rxq.max_pkt_size < 64)
 				goto error_param;
-			}
 
 			vsi->max_frame = qpi->rxq.max_pkt_size;
 			/* add space for the port VLAN since the VF driver is
@@ -1690,16 +1675,30 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 				vsi->max_frame += VLAN_HLEN;
 
 			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure RX queue %d\n",
+					 vf->vf_id, i);
 				goto error_param;
 			}
 		}
 	}
 
+	/* send the response to the VF */
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
 error_param:
+	/* disable whatever we can */
+	for (; i >= 0; i--) {
+		if (ice_vsi_ctrl_one_rx_ring(vsi, false, i, true))
+			dev_err(ice_pf_to_dev(pf), "VF-%d could not disable RX queue %d\n",
+				vf->vf_id, i);
+		if (ice_vf_vsi_dis_single_txq(vf, vsi, i))
+			dev_err(ice_pf_to_dev(pf), "VF-%d could not disable TX queue %d\n",
+				vf->vf_id, i);
+	}
+
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES, v_ret,
-				     NULL, 0);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				     VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
 }
 
 /**
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a50090e62c8f..c075670bc562 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -778,6 +778,17 @@ static inline bool mtk_rx_get_desc(struct mtk_rx_dma *rxd,
 	return true;
 }
 
+static void *mtk_max_lro_buf_alloc(gfp_t gfp_mask)
+{
+	unsigned int size = mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH);
+	unsigned long data;
+
+	data = __get_free_pages(gfp_mask | __GFP_COMP | __GFP_NOWARN,
+				get_order(size));
+
+	return (void *)data;
+}
+
 /* the qdma core needs scratch memory to be setup */
 static int mtk_init_fq_dma(struct mtk_eth *eth)
 {
@@ -1269,7 +1280,10 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 
 		/* alloc new buffer */
-		new_data = napi_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			new_data = napi_alloc_frag(ring->frag_size);
+		else
+			new_data = mtk_max_lro_buf_alloc(GFP_ATOMIC);
 		if (unlikely(!new_data)) {
 			netdev->stats.rx_dropped++;
 			goto release_desc;
@@ -1683,7 +1697,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
-		ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		else
+			ring->data[i] = mtk_max_lro_buf_alloc(GFP_KERNEL);
 		if (!ring->data[i])
 			return -ENOMEM;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index a8b98242edb1..a1e9d3051533 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -561,7 +561,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
-	struct lag_tracker tracker;
+	struct lag_tracker tracker = { };
 	bool do_bond, roce_lag;
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
index a68d931090dd..15c8d4de8350 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
@@ -8,8 +8,8 @@
 #include "spectrum.h"
 
 enum mlxsw_sp_counter_sub_pool_id {
-	MLXSW_SP_COUNTER_SUB_POOL_FLOW,
 	MLXSW_SP_COUNTER_SUB_POOL_RIF,
+	MLXSW_SP_COUNTER_SUB_POOL_FLOW,
 };
 
 int mlxsw_sp_counter_alloc(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index e172743948ed..ce2cbb5903d7 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1012,8 +1012,7 @@ static int pppoe_recvmsg(struct socket *sock, struct msghdr *m,
 		goto end;
 	}
 
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &error);
+	skb = skb_recv_datagram(sk, flags, &error);
 	if (error < 0)
 		goto end;
 
diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index a99aedff795d..ea7309453096 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -388,13 +388,25 @@ static void nfcmrvl_play_deferred(struct nfcmrvl_usb_drv_data *drv_data)
 	int err;
 
 	while ((urb = usb_get_from_anchor(&drv_data->deferred))) {
+		usb_anchor_urb(urb, &drv_data->tx_anchor);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err)
+		if (err) {
+			kfree(urb->setup_packet);
+			usb_unanchor_urb(urb);
+			usb_free_urb(urb);
 			break;
+		}
 
 		drv_data->tx_in_flight++;
+		usb_free_urb(urb);
+	}
+
+	/* Cleanup the rest deferred urbs. */
+	while ((urb = usb_get_from_anchor(&drv_data->deferred))) {
+		kfree(urb->setup_packet);
+		usb_free_urb(urb);
 	}
-	usb_scuttle_anchored_urbs(&drv_data->deferred);
 }
 
 static int nfcmrvl_resume(struct usb_interface *intf)
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2d6a01853109..1ea85c88d795 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3226,8 +3226,8 @@ static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
 	 * we have no UUID set
 	 */
 	if (uuid_is_null(&ids->uuid)) {
-		printk_ratelimited(KERN_WARNING
-				   "No UUID available providing old NGUID\n");
+		dev_warn_ratelimited(dev,
+			"No UUID available providing old NGUID\n");
 		return sysfs_emit(buf, "%pU\n", ids->nguid);
 	}
 	return sysfs_emit(buf, "%pU\n", &ids->uuid);
diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index d421e1482395..6b51ad01f791 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -17,7 +17,7 @@ menuconfig MIPS_PLATFORM_DEVICES
 if MIPS_PLATFORM_DEVICES
 
 config CPU_HWMON
-	tristate "Loongson-3 CPU HWMon Driver"
+	bool "Loongson-3 CPU HWMon Driver"
 	depends on MACH_LOONGSON64
 	select HWMON
 	default y
diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index e87a931eab1e..78446b1953f7 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
@@ -154,6 +155,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z690M AORUS ELITE AX DDR4"),
 	{ }
 };
 
diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 216d31e3403d..79cff1fc675c 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -122,6 +122,12 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x360 Convertible 15-df0xxx"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go"),
+		},
+	},
 	{ }
 };
 
diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index ac19fcc9abbf..8ee15a7252c7 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1912,6 +1912,7 @@ static const struct x86_cpu_id intel_pmc_core_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ROCKETLAKE,		&tgl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&tgl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_reg_map),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,        &tgl_reg_map),
 	{}
 };
 
diff --git a/drivers/platform/x86/intel/pmt/crashlog.c b/drivers/platform/x86/intel/pmt/crashlog.c
index 34daf9df168b..ace1239bc0a0 100644
--- a/drivers/platform/x86/intel/pmt/crashlog.c
+++ b/drivers/platform/x86/intel/pmt/crashlog.c
@@ -282,7 +282,7 @@ static int pmt_crashlog_probe(struct auxiliary_device *auxdev,
 	auxiliary_set_drvdata(auxdev, priv);
 
 	for (i = 0; i < intel_vsec_dev->num_resources; i++) {
-		struct intel_pmt_entry *entry = &priv->entry[i].entry;
+		struct intel_pmt_entry *entry = &priv->entry[priv->num_entries].entry;
 
 		ret = intel_pmt_dev_create(entry, &pmt_crashlog_ns, intel_vsec_dev, i);
 		if (ret < 0)
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 104bee9b3a9d..00593d8953f1 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9795,7 +9795,7 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 					GFP_KERNEL);
 
 		if (!ioa_cfg->hrrq[i].host_rrq)  {
-			while (--i > 0)
+			while (--i >= 0)
 				dma_free_coherent(&pdev->dev,
 					sizeof(u32) * ioa_cfg->hrrq[i].size,
 					ioa_cfg->hrrq[i].host_rrq,
@@ -10068,7 +10068,7 @@ static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg,
 			ioa_cfg->vectors_info[i].desc,
 			&ioa_cfg->hrrq[i]);
 		if (rc) {
-			while (--i >= 0)
+			while (--i > 0)
 				free_irq(pci_irq_vector(pdev, i),
 					&ioa_cfg->hrrq[i]);
 			return rc;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 892b3da1ba45..9e3899580039 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3035,18 +3035,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		spin_unlock_irq(&ndlp->lock);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
-		lpfc_els_free_iocb(phba, cmdiocb);
-		lpfc_nlp_put(ndlp);
-
-		/* Presume the node was released. */
-		return;
+		goto out_rsrc_free;
 	}
 
 out:
-	/* Driver is done with the IO.  */
-	lpfc_els_free_iocb(phba, cmdiocb);
-	lpfc_nlp_put(ndlp);
-
 	/* At this point, the LOGO processing is complete. NOTE: For a
 	 * pt2pt topology, we are assuming the NPortID will only change
 	 * on link up processing. For a LOGO / PLOGI initiated by the
@@ -3073,6 +3065,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4, tmo,
 				 vport->num_disc_nodes);
+
+		lpfc_els_free_iocb(phba, cmdiocb);
+		lpfc_nlp_put(ndlp);
+
 		lpfc_disc_start(vport);
 		return;
 	}
@@ -3089,6 +3085,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
 	}
+out_rsrc_free:
+	/* Driver is done with the I/O. */
+	lpfc_els_free_iocb(phba, cmdiocb);
+	lpfc_nlp_put(ndlp);
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 02e230ed6280..e7daef550095 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4488,6 +4488,9 @@ struct wqe_common {
 #define wqe_sup_SHIFT         6
 #define wqe_sup_MASK          0x00000001
 #define wqe_sup_WORD          word11
+#define wqe_ffrq_SHIFT         6
+#define wqe_ffrq_MASK          0x00000001
+#define wqe_ffrq_WORD          word11
 #define wqe_wqec_SHIFT        7
 #define wqe_wqec_MASK         0x00000001
 #define wqe_wqec_WORD         word11
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 4b065c51ee1b..f5de88877ffe 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -835,7 +835,8 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_nvmet_invalidate_host(phba, ndlp);
 
 	if (ndlp->nlp_DID == Fabric_DID) {
-		if (vport->port_state <= LPFC_FDISC)
+		if (vport->port_state <= LPFC_FDISC ||
+		    vport->fc_flag & FC_PT2PT)
 			goto out;
 		lpfc_linkdown_port(vport);
 		spin_lock_irq(shost->host_lock);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index d3a542466e98..49f44d9d04ea 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1194,7 +1194,8 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvmeCmd;
-	struct lpfc_iocbq *pwqeq = &(lpfc_ncmd->cur_iocbq);
+	struct nvme_common_command *sqe;
+	struct lpfc_iocbq *pwqeq = &lpfc_ncmd->cur_iocbq;
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	uint32_t req_len;
 
@@ -1251,8 +1252,14 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 		cstat->control_requests++;
 	}
 
-	if (pnode->nlp_nvme_info & NLP_NVME_NSLER)
+	if (pnode->nlp_nvme_info & NLP_NVME_NSLER) {
 		bf_set(wqe_erp, &wqe->generic.wqe_com, 1);
+		sqe = &((struct nvme_fc_cmd_iu *)
+			nCmd->cmdaddr)->sqe.common;
+		if (sqe->opcode == nvme_admin_async_event)
+			bf_set(wqe_ffrq, &wqe->generic.wqe_com, 1);
+	}
+
 	/*
 	 * Finish initializing those WQE fields that are independent
 	 * of the nvme_cmnd request_buffer
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 538d2c0cd971..aa142052ebe4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5368,6 +5368,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
 	Mpi26PCIeIOUnitPage1_t pcie_iounit_pg1;
+	u16 depth;
 	int sz;
 	int rc = 0;
 
@@ -5379,7 +5380,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 		goto out;
 	/* sas iounit page 1 */
 	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData);
-	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
+	sas_iounit_pg1 = kzalloc(sizeof(Mpi2SasIOUnitPage1_t), GFP_KERNEL);
 	if (!sas_iounit_pg1) {
 		pr_err("%s: failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -5392,16 +5393,16 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 		    ioc->name, __FILE__, __LINE__, __func__);
 		goto out;
 	}
-	ioc->max_wideport_qd =
-	    (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
-	    le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth) :
-	    MPT3SAS_SAS_QUEUE_DEPTH;
-	ioc->max_narrowport_qd =
-	    (le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth)) ?
-	    le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth) :
-	    MPT3SAS_SAS_QUEUE_DEPTH;
-	ioc->max_sata_qd = (sas_iounit_pg1->SATAMaxQDepth) ?
-	    sas_iounit_pg1->SATAMaxQDepth : MPT3SAS_SATA_QUEUE_DEPTH;
+
+	depth = le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth);
+	ioc->max_wideport_qd = (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
+
+	depth = le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth);
+	ioc->max_narrowport_qd = (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
+
+	depth = sas_iounit_pg1->SATAMaxQDepth;
+	ioc->max_sata_qd = (depth ? depth : MPT3SAS_SATA_QUEUE_DEPTH);
+
 	/* pcie iounit page 1 */
 	rc = mpt3sas_config_get_pcie_iounit_pg1(ioc, &mpi_reply,
 	    &pcie_iounit_pg1, sizeof(Mpi26PCIeIOUnitPage1_t));
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index fd674ed1febe..6d94837c9049 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4031,7 +4031,7 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 	return 0;
 
 out_unwind:
-	while (--i > 0)
+	while (--i >= 0)
 		free_irq(pci_irq_vector(pdev, i), &pinstance->hrrq_vector[i]);
 	pci_free_irq_vectors(pdev);
 	return rc;
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index 51a82f7803d3..9d16cf925483 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -331,8 +331,8 @@ struct PVSCSIRingReqDesc {
 	u8	tag;
 	u8	bus;
 	u8	target;
-	u8	vcpuHint;
-	u8	unused[59];
+	u16	vcpuHint;
+	u8	unused[58];
 } __packed;
 
 /*
diff --git a/drivers/staging/r8188eu/core/rtw_xmit.c b/drivers/staging/r8188eu/core/rtw_xmit.c
index 2ee92bbe66a0..ea5c88904961 100644
--- a/drivers/staging/r8188eu/core/rtw_xmit.c
+++ b/drivers/staging/r8188eu/core/rtw_xmit.c
@@ -178,8 +178,7 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 
 	pxmitpriv->free_xmit_extbuf_cnt = num_xmit_extbuf;
 
-	res = rtw_alloc_hwxmits(padapter);
-	if (res) {
+	if (rtw_alloc_hwxmits(padapter)) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -1492,19 +1491,10 @@ int rtw_alloc_hwxmits(struct adapter *padapter)
 
 	hwxmits = pxmitpriv->hwxmits;
 
-	if (pxmitpriv->hwxmit_entry == 5) {
-		hwxmits[0] .sta_queue = &pxmitpriv->bm_pending;
-		hwxmits[1] .sta_queue = &pxmitpriv->vo_pending;
-		hwxmits[2] .sta_queue = &pxmitpriv->vi_pending;
-		hwxmits[3] .sta_queue = &pxmitpriv->bk_pending;
-		hwxmits[4] .sta_queue = &pxmitpriv->be_pending;
-	} else if (pxmitpriv->hwxmit_entry == 4) {
-		hwxmits[0] .sta_queue = &pxmitpriv->vo_pending;
-		hwxmits[1] .sta_queue = &pxmitpriv->vi_pending;
-		hwxmits[2] .sta_queue = &pxmitpriv->be_pending;
-		hwxmits[3] .sta_queue = &pxmitpriv->bk_pending;
-	} else {
-	}
+	hwxmits[0].sta_queue = &pxmitpriv->vo_pending;
+	hwxmits[1].sta_queue = &pxmitpriv->vi_pending;
+	hwxmits[2].sta_queue = &pxmitpriv->be_pending;
+	hwxmits[3].sta_queue = &pxmitpriv->bk_pending;
 
 	return 0;
 }
diff --git a/drivers/staging/r8188eu/os_dep/ioctl_linux.c b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
index 60bd1cc2b3af..607c5e1eb320 100644
--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -404,7 +404,7 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
-			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, KeyMaterial);
+			wep_total_len = wep_key_len + sizeof(*pwep);
 			pwep = kzalloc(wep_total_len, GFP_KERNEL);
 			if (!pwep)
 				goto exit;
diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index c7968aecd870..d02de3f0326f 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -426,7 +426,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
 	tty_unregister_device(goldfish_tty_driver, qtty->console.index);
 	iounmap(qtty->base);
 	qtty->base = NULL;
-	free_irq(qtty->irq, pdev);
+	free_irq(qtty->irq, qtty);
 	tty_port_destroy(&qtty->port);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index ea5381dedb07..9f2a8c0e1e33 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -455,7 +455,7 @@ static void gsm_hex_dump_bytes(const char *fname, const u8 *data,
 		return;
 	}
 
-	prefix = kasprintf(GFP_KERNEL, "%s: ", fname);
+	prefix = kasprintf(GFP_ATOMIC, "%s: ", fname);
 	if (!prefix)
 		return;
 	print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_OFFSET, 16, 1, data, len,
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 1fbd5bf264be..7e295d2701b2 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1535,6 +1535,8 @@ static inline void __stop_tx(struct uart_8250_port *p)
 
 	if (em485) {
 		unsigned char lsr = serial_in(p, UART_LSR);
+		p->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+
 		/*
 		 * To provide required timeing and allow FIFO transfer,
 		 * __stop_tx_rs485() must be called only when both FIFO and
diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index e45c3d6e1536..794e413800ae 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1941,13 +1941,16 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		}
 
 		if (enqd_len + trb_buff_len >= full_len) {
-			if (need_zero_pkt)
-				zero_len_trb = !zero_len_trb;
-
-			field &= ~TRB_CHAIN;
-			field |= TRB_IOC;
-			more_trbs_coming = false;
-			preq->td.last_trb = ring->enqueue;
+			if (need_zero_pkt && !zero_len_trb) {
+				zero_len_trb = true;
+			} else {
+				zero_len_trb = false;
+				field &= ~TRB_CHAIN;
+				field |= TRB_IOC;
+				more_trbs_coming = false;
+				need_zero_pkt = false;
+				preq->td.last_trb = ring->enqueue;
+			}
 		}
 
 		/* Only set interrupt on short packet for OUT endpoints. */
@@ -1962,7 +1965,7 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
 
-		cdnsp_queue_trb(pdev, ring, more_trbs_coming | zero_len_trb,
+		cdnsp_queue_trb(pdev, ring, more_trbs_coming,
 				lower_32_bits(send_addr),
 				upper_32_bits(send_addr),
 				length_field,
diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index f63a27d11fac..3f107a06817d 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5190,7 +5190,7 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		retval = -EINVAL;
-		goto error1;
+		goto error2;
 	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index ba51de7dd760..6b018048fe2e 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -127,6 +127,7 @@ static const struct property_entry dwc3_pci_intel_phy_charger_detect_properties[
 	PROPERTY_ENTRY_STRING("dr_mode", "peripheral"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u2_susphy_quirk"),
 	PROPERTY_ENTRY_BOOL("linux,phy_charger_detect"),
+	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
 	{}
 };
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index bf2eaa09d73c..0a6633e7edce 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2984,6 +2984,7 @@ static int dwc3_gadget_init_in_endpoint(struct dwc3_ep *dep)
 	struct dwc3 *dwc = dep->dwc;
 	u32 mdwidth;
 	int size;
+	int maxpacket;
 
 	mdwidth = dwc3_mdwidth(dwc);
 
@@ -2996,21 +2997,24 @@ static int dwc3_gadget_init_in_endpoint(struct dwc3_ep *dep)
 	else
 		size = DWC31_GTXFIFOSIZ_TXFDEP(size);
 
-	/* FIFO Depth is in MDWDITH bytes. Multiply */
-	size *= mdwidth;
-
 	/*
-	 * To meet performance requirement, a minimum TxFIFO size of 3x
-	 * MaxPacketSize is recommended for endpoints that support burst and a
-	 * minimum TxFIFO size of 2x MaxPacketSize for endpoints that don't
-	 * support burst. Use those numbers and we can calculate the max packet
-	 * limit as below.
+	 * maxpacket size is determined as part of the following, after assuming
+	 * a mult value of one maxpacket:
+	 * DWC3 revision 280A and prior:
+	 * fifo_size = mult * (max_packet / mdwidth) + 1;
+	 * maxpacket = mdwidth * (fifo_size - 1);
+	 *
+	 * DWC3 revision 290A and onwards:
+	 * fifo_size = mult * ((max_packet + mdwidth)/mdwidth + 1) + 1
+	 * maxpacket = mdwidth * ((fifo_size - 1) - 1) - mdwidth;
 	 */
-	if (dwc->maximum_speed >= USB_SPEED_SUPER)
-		size /= 3;
+	if (DWC3_VER_IS_PRIOR(DWC3, 290A))
+		maxpacket = mdwidth * (size - 1);
 	else
-		size /= 2;
+		maxpacket = mdwidth * ((size - 1) - 1) - mdwidth;
 
+	/* Functionally, space for one max packet is sufficient */
+	size = min_t(int, maxpacket, 1024);
 	usb_ep_set_maxpacket_limit(&dep->endpoint, size);
 
 	dep->endpoint.max_streams = 16;
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 4585ee3a444a..e0fa4b186ec6 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -122,8 +122,6 @@ struct ffs_ep {
 	struct usb_endpoint_descriptor	*descs[3];
 
 	u8				num;
-
-	int				status;	/* P: epfile->mutex */
 };
 
 struct ffs_epfile {
@@ -227,6 +225,9 @@ struct ffs_io_data {
 	bool use_sg;
 
 	struct ffs_data *ffs;
+
+	int status;
+	struct completion done;
 };
 
 struct ffs_desc_helper {
@@ -707,12 +708,15 @@ static const struct file_operations ffs_ep0_operations = {
 
 static void ffs_epfile_io_complete(struct usb_ep *_ep, struct usb_request *req)
 {
+	struct ffs_io_data *io_data = req->context;
+
 	ENTER();
-	if (req->context) {
-		struct ffs_ep *ep = _ep->driver_data;
-		ep->status = req->status ? req->status : req->actual;
-		complete(req->context);
-	}
+	if (req->status)
+		io_data->status = req->status;
+	else
+		io_data->status = req->actual;
+
+	complete(&io_data->done);
 }
 
 static ssize_t ffs_copy_to_iter(void *data, int data_len, struct iov_iter *iter)
@@ -1050,7 +1054,6 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		WARN(1, "%s: data_len == -EINVAL\n", __func__);
 		ret = -EINVAL;
 	} else if (!io_data->aio) {
-		DECLARE_COMPLETION_ONSTACK(done);
 		bool interrupted = false;
 
 		req = ep->req;
@@ -1066,7 +1069,8 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 		io_data->buf = data;
 
-		req->context  = &done;
+		init_completion(&io_data->done);
+		req->context  = io_data;
 		req->complete = ffs_epfile_io_complete;
 
 		ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
@@ -1075,7 +1079,12 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 		spin_unlock_irq(&epfile->ffs->eps_lock);
 
-		if (wait_for_completion_interruptible(&done)) {
+		if (wait_for_completion_interruptible(&io_data->done)) {
+			spin_lock_irq(&epfile->ffs->eps_lock);
+			if (epfile->ep != ep) {
+				ret = -ESHUTDOWN;
+				goto error_lock;
+			}
 			/*
 			 * To avoid race condition with ffs_epfile_io_complete,
 			 * dequeue the request first then check
@@ -1083,17 +1092,18 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			 * condition with req->complete callback.
 			 */
 			usb_ep_dequeue(ep->ep, req);
-			wait_for_completion(&done);
-			interrupted = ep->status < 0;
+			spin_unlock_irq(&epfile->ffs->eps_lock);
+			wait_for_completion(&io_data->done);
+			interrupted = io_data->status < 0;
 		}
 
 		if (interrupted)
 			ret = -EINTR;
-		else if (io_data->read && ep->status > 0)
-			ret = __ffs_epfile_read_data(epfile, data, ep->status,
+		else if (io_data->read && io_data->status > 0)
+			ret = __ffs_epfile_read_data(epfile, data, io_data->status,
 						     &io_data->data);
 		else
-			ret = ep->status;
+			ret = io_data->status;
 		goto error_mutex;
 	} else if (!(req = usb_ep_alloc_request(ep->ep, GFP_ATOMIC))) {
 		ret = -ENOMEM;
diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 6f5d45ef2e39..f51694f29de9 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -775,9 +775,13 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 	dev->qmult = qmult;
 	snprintf(net->name, sizeof(net->name), "%s%%d", netname);
 
-	if (get_ether_addr(dev_addr, addr))
+	if (get_ether_addr(dev_addr, addr)) {
+		net->addr_assign_type = NET_ADDR_RANDOM;
 		dev_warn(&g->dev,
 			"using random %s ethernet address\n", "self");
+	} else {
+		net->addr_assign_type = NET_ADDR_SET;
+	}
 	eth_hw_addr_set(net, addr);
 	if (get_ether_addr(host_addr, dev->host_mac))
 		dev_warn(&g->dev,
@@ -844,6 +848,10 @@ struct net_device *gether_setup_name_default(const char *netname)
 
 	eth_random_addr(dev->dev_mac);
 	pr_warn("using random %s ethernet address\n", "self");
+
+	/* by default we always have a random MAC address */
+	net->addr_assign_type = NET_ADDR_RANDOM;
+
 	eth_random_addr(dev->host_mac);
 	pr_warn("using random %s ethernet address\n", "host");
 
@@ -871,7 +879,6 @@ int gether_register_netdev(struct net_device *net)
 	dev = netdev_priv(net);
 	g = dev->gadget;
 
-	net->addr_assign_type = NET_ADDR_RANDOM;
 	eth_hw_addr_set(net, dev->dev_mac);
 
 	status = register_netdev(net);
@@ -912,6 +919,7 @@ int gether_set_dev_addr(struct net_device *net, const char *dev_addr)
 	if (get_ether_addr(dev_addr, new_addr))
 		return -EINVAL;
 	memcpy(dev->dev_mac, new_addr, ETH_ALEN);
+	net->addr_assign_type = NET_ADDR_SET;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gether_set_dev_addr);
diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index 6117ae8e7242..cea10cdb83ae 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3016,6 +3016,7 @@ static int lpc32xx_udc_probe(struct platform_device *pdev)
 	}
 
 	udc->isp1301_i2c_client = isp1301_get_client(isp1301_node);
+	of_node_put(isp1301_node);
 	if (!udc->isp1301_i2c_client) {
 		return -EPROBE_DEFER;
 	}
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index a7b3c15957ba..feba2a8d1233 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -166,6 +166,7 @@ static const struct usb_device_id edgeport_2port_id_table[] = {
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_8S) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416B) },
+	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_E5805A) },
 	{ }
 };
 
@@ -204,6 +205,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_8S) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416B) },
+	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_E5805A) },
 	{ }
 };
 
diff --git a/drivers/usb/serial/io_usbvend.h b/drivers/usb/serial/io_usbvend.h
index 52cbc353051f..9a6f742ad3ab 100644
--- a/drivers/usb/serial/io_usbvend.h
+++ b/drivers/usb/serial/io_usbvend.h
@@ -212,6 +212,7 @@
 //
 // Definitions for other product IDs
 #define ION_DEVICE_ID_MT4X56USB			0x1403	// OEM device
+#define ION_DEVICE_ID_E5805A			0x1A01  // OEM device (rebranded Edgeport/4)
 
 
 #define	GENERATION_ID_FROM_USB_PRODUCT_ID(ProductId)				\
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e60425bbf537..ed1e50d83cca 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -432,6 +432,8 @@ static void option_instat_callback(struct urb *urb);
 #define CINTERION_PRODUCT_CLS8			0x00b0
 #define CINTERION_PRODUCT_MV31_MBIM		0x00b3
 #define CINTERION_PRODUCT_MV31_RMNET		0x00b7
+#define CINTERION_PRODUCT_MV31_2_MBIM		0x00b8
+#define CINTERION_PRODUCT_MV31_2_RMNET		0x00b9
 #define CINTERION_PRODUCT_MV32_WA		0x00f1
 #define CINTERION_PRODUCT_MV32_WB		0x00f2
 
@@ -1979,6 +1981,10 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(3)},
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_RMNET, 0xff),
 	  .driver_info = RSVD(0)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_2_MBIM, 0xff),
+	  .driver_info = RSVD(3)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_2_RMNET, 0xff),
+	  .driver_info = RSVD(0)},
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WA, 0xff),
 	  .driver_info = RSVD(3)},
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WB, 0xff),
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 56128b9c46eb..1dd396d4bebb 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -688,6 +688,7 @@ static int vm_cmdline_set(const char *device,
 	if (!vm_cmdline_parent_registered) {
 		err = device_register(&vm_cmdline_parent);
 		if (err) {
+			put_device(&vm_cmdline_parent);
 			pr_err("Failed to register parent device!\n");
 			return err;
 		}
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index d724f676608b..5046efcffb4c 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -254,8 +254,7 @@ void vp_del_vqs(struct virtio_device *vdev)
 
 	if (vp_dev->msix_affinity_masks) {
 		for (i = 0; i < vp_dev->msix_vectors; i++)
-			if (vp_dev->msix_affinity_masks[i])
-				free_cpumask_var(vp_dev->msix_affinity_masks[i]);
+			free_cpumask_var(vp_dev->msix_affinity_masks[i]);
 	}
 
 	if (vp_dev->msix_enabled) {
diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index 1c8dc696d516..cebba4eaa0b5 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -62,12 +62,12 @@ void v9fs_cache_inode_get_cookie(struct inode *inode)
 	version = cpu_to_le32(v9inode->qid.version);
 	path = cpu_to_le64(v9inode->qid.path);
 	v9ses = v9fs_inode2v9ses(inode);
-	v9inode->netfs_ctx.cache =
+	v9inode->netfs.cache =
 		fscache_acquire_cookie(v9fs_session_cache(v9ses),
 				       0,
 				       &path, sizeof(path),
 				       &version, sizeof(version),
-				       i_size_read(&v9inode->vfs_inode));
+				       i_size_read(&v9inode->netfs.inode));
 
 	p9_debug(P9_DEBUG_FSC, "inode %p get cookie %p\n",
 		 inode, v9fs_inode_cookie(v9inode));
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index e28ddf763b3b..0129de2ea31a 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -625,7 +625,7 @@ static void v9fs_inode_init_once(void *foo)
 	struct v9fs_inode *v9inode = (struct v9fs_inode *)foo;
 
 	memset(&v9inode->qid, 0, sizeof(v9inode->qid));
-	inode_init_once(&v9inode->vfs_inode);
+	inode_init_once(&v9inode->netfs.inode);
 }
 
 /**
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index ec0e8df3b2eb..1b219c21d15e 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -109,11 +109,7 @@ struct v9fs_session_info {
 #define V9FS_INO_INVALID_ATTR 0x01
 
 struct v9fs_inode {
-	struct {
-		/* These must be contiguous */
-		struct inode	vfs_inode;	/* the VFS's inode record */
-		struct netfs_i_context netfs_ctx; /* Netfslib context */
-	};
+	struct netfs_inode netfs; /* Netfslib context and vfs inode */
 	struct p9_qid qid;
 	unsigned int cache_validity;
 	struct p9_fid *writeback_fid;
@@ -122,13 +118,13 @@ struct v9fs_inode {
 
 static inline struct v9fs_inode *V9FS_I(const struct inode *inode)
 {
-	return container_of(inode, struct v9fs_inode, vfs_inode);
+	return container_of(inode, struct v9fs_inode, netfs.inode);
 }
 
 static inline struct fscache_cookie *v9fs_inode_cookie(struct v9fs_inode *v9inode)
 {
 #ifdef CONFIG_9P_FSCACHE
-	return netfs_i_cookie(&v9inode->vfs_inode);
+	return netfs_i_cookie(&v9inode->netfs.inode);
 #else
 	return NULL;
 #endif
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 501128188343..595875228672 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -141,7 +141,7 @@ static void v9fs_write_to_cache_done(void *priv, ssize_t transferred_or_error,
 	    transferred_or_error != -ENOBUFS) {
 		version = cpu_to_le32(v9inode->qid.version);
 		fscache_invalidate(v9fs_inode_cookie(v9inode), &version,
-				   i_size_read(&v9inode->vfs_inode), 0);
+				   i_size_read(&v9inode->netfs.inode), 0);
 	}
 }
 
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 55367ecb9442..e660c6348b9d 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -234,7 +234,7 @@ struct inode *v9fs_alloc_inode(struct super_block *sb)
 	v9inode->writeback_fid = NULL;
 	v9inode->cache_validity = 0;
 	mutex_init(&v9inode->v_mutex);
-	return &v9inode->vfs_inode;
+	return &v9inode->netfs.inode;
 }
 
 /**
@@ -252,7 +252,7 @@ void v9fs_free_inode(struct inode *inode)
  */
 static void v9fs_set_netfs_context(struct inode *inode)
 {
-	netfs_i_context_init(inode, &v9fs_req_ops);
+	netfs_inode_init(inode, &v9fs_req_ops);
 }
 
 int v9fs_init_inode(struct v9fs_session_info *v9ses,
diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 1b4d5809808d..a484fa642808 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -30,7 +30,7 @@ void afs_invalidate_mmap_work(struct work_struct *work)
 {
 	struct afs_vnode *vnode = container_of(work, struct afs_vnode, cb_work);
 
-	unmap_mapping_pages(vnode->vfs_inode.i_mapping, 0, 0, false);
+	unmap_mapping_pages(vnode->netfs.inode.i_mapping, 0, 0, false);
 }
 
 void afs_server_init_callback_work(struct work_struct *work)
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index bdac73554e6e..5cbb5234f7ce 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -109,7 +109,7 @@ struct afs_lookup_cookie {
  */
 static void afs_dir_read_cleanup(struct afs_read *req)
 {
-	struct address_space *mapping = req->vnode->vfs_inode.i_mapping;
+	struct address_space *mapping = req->vnode->netfs.inode.i_mapping;
 	struct folio *folio;
 	pgoff_t last = req->nr_pages - 1;
 
@@ -153,7 +153,7 @@ static bool afs_dir_check_folio(struct afs_vnode *dvnode, struct folio *folio,
 		block = kmap_local_folio(folio, offset);
 		if (block->hdr.magic != AFS_DIR_MAGIC) {
 			printk("kAFS: %s(%lx): [%llx] bad magic %zx/%zx is %04hx\n",
-			       __func__, dvnode->vfs_inode.i_ino,
+			       __func__, dvnode->netfs.inode.i_ino,
 			       pos, offset, size, ntohs(block->hdr.magic));
 			trace_afs_dir_check_failed(dvnode, pos + offset, i_size);
 			kunmap_local(block);
@@ -183,7 +183,7 @@ static bool afs_dir_check_folio(struct afs_vnode *dvnode, struct folio *folio,
 static void afs_dir_dump(struct afs_vnode *dvnode, struct afs_read *req)
 {
 	union afs_xdr_dir_block *block;
-	struct address_space *mapping = dvnode->vfs_inode.i_mapping;
+	struct address_space *mapping = dvnode->netfs.inode.i_mapping;
 	struct folio *folio;
 	pgoff_t last = req->nr_pages - 1;
 	size_t offset, size;
@@ -217,7 +217,7 @@ static void afs_dir_dump(struct afs_vnode *dvnode, struct afs_read *req)
  */
 static int afs_dir_check(struct afs_vnode *dvnode, struct afs_read *req)
 {
-	struct address_space *mapping = dvnode->vfs_inode.i_mapping;
+	struct address_space *mapping = dvnode->netfs.inode.i_mapping;
 	struct folio *folio;
 	pgoff_t last = req->nr_pages - 1;
 	int ret = 0;
@@ -269,7 +269,7 @@ static int afs_dir_open(struct inode *inode, struct file *file)
 static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 	__acquires(&dvnode->validate_lock)
 {
-	struct address_space *mapping = dvnode->vfs_inode.i_mapping;
+	struct address_space *mapping = dvnode->netfs.inode.i_mapping;
 	struct afs_read *req;
 	loff_t i_size;
 	int nr_pages, i;
@@ -287,7 +287,7 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 	req->cleanup = afs_dir_read_cleanup;
 
 expand:
-	i_size = i_size_read(&dvnode->vfs_inode);
+	i_size = i_size_read(&dvnode->netfs.inode);
 	if (i_size < 2048) {
 		ret = afs_bad(dvnode, afs_file_error_dir_small);
 		goto error;
@@ -305,7 +305,7 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 	req->actual_len = i_size; /* May change */
 	req->len = nr_pages * PAGE_SIZE; /* We can ask for more than there is */
 	req->data_version = dvnode->status.data_version; /* May change */
-	iov_iter_xarray(&req->def_iter, READ, &dvnode->vfs_inode.i_mapping->i_pages,
+	iov_iter_xarray(&req->def_iter, READ, &dvnode->netfs.inode.i_mapping->i_pages,
 			0, i_size);
 	req->iter = &req->def_iter;
 
@@ -897,7 +897,7 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry,
 
 out_op:
 	if (op->error == 0) {
-		inode = &op->file[1].vnode->vfs_inode;
+		inode = &op->file[1].vnode->netfs.inode;
 		op->file[1].vnode = NULL;
 	}
 
@@ -1139,7 +1139,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	afs_stat_v(dir, n_reval);
 
 	/* search the directory for this vnode */
-	ret = afs_do_lookup_one(&dir->vfs_inode, dentry, &fid, key, &dir_version);
+	ret = afs_do_lookup_one(&dir->netfs.inode, dentry, &fid, key, &dir_version);
 	switch (ret) {
 	case 0:
 		/* the filename maps to something */
@@ -1170,7 +1170,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 			_debug("%pd: file deleted (uq %u -> %u I:%u)",
 			       dentry, fid.unique,
 			       vnode->fid.unique,
-			       vnode->vfs_inode.i_generation);
+			       vnode->netfs.inode.i_generation);
 			goto not_found;
 		}
 		goto out_valid;
@@ -1368,7 +1368,7 @@ static void afs_dir_remove_subdir(struct dentry *dentry)
 	if (d_really_is_positive(dentry)) {
 		struct afs_vnode *vnode = AFS_FS_I(d_inode(dentry));
 
-		clear_nlink(&vnode->vfs_inode);
+		clear_nlink(&vnode->netfs.inode);
 		set_bit(AFS_VNODE_DELETED, &vnode->flags);
 		clear_bit(AFS_VNODE_CB_PROMISED, &vnode->flags);
 		clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
@@ -1487,8 +1487,8 @@ static void afs_dir_remove_link(struct afs_operation *op)
 		/* Already done */
 	} else if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags)) {
 		write_seqlock(&vnode->cb_lock);
-		drop_nlink(&vnode->vfs_inode);
-		if (vnode->vfs_inode.i_nlink == 0) {
+		drop_nlink(&vnode->netfs.inode);
+		if (vnode->netfs.inode.i_nlink == 0) {
 			set_bit(AFS_VNODE_DELETED, &vnode->flags);
 			__afs_break_callback(vnode, afs_cb_break_for_unlink);
 		}
@@ -1504,7 +1504,7 @@ static void afs_dir_remove_link(struct afs_operation *op)
 			op->error = ret;
 	}
 
-	_debug("nlink %d [val %d]", vnode->vfs_inode.i_nlink, op->error);
+	_debug("nlink %d [val %d]", vnode->netfs.inode.i_nlink, op->error);
 }
 
 static void afs_unlink_success(struct afs_operation *op)
@@ -1680,8 +1680,8 @@ static void afs_link_success(struct afs_operation *op)
 	afs_update_dentry_version(op, dvp, op->dentry);
 	if (op->dentry_2->d_parent == op->dentry->d_parent)
 		afs_update_dentry_version(op, dvp, op->dentry_2);
-	ihold(&vp->vnode->vfs_inode);
-	d_instantiate(op->dentry, &vp->vnode->vfs_inode);
+	ihold(&vp->vnode->netfs.inode);
+	d_instantiate(op->dentry, &vp->vnode->netfs.inode);
 }
 
 static void afs_link_put(struct afs_operation *op)
diff --git a/fs/afs/dir_edit.c b/fs/afs/dir_edit.c
index d98e109ecee9..0ab7752d1b75 100644
--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -109,7 +109,7 @@ static void afs_clear_contig_bits(union afs_xdr_dir_block *block,
  */
 static struct folio *afs_dir_get_folio(struct afs_vnode *vnode, pgoff_t index)
 {
-	struct address_space *mapping = vnode->vfs_inode.i_mapping;
+	struct address_space *mapping = vnode->netfs.inode.i_mapping;
 	struct folio *folio;
 
 	folio = __filemap_get_folio(mapping, index,
@@ -216,7 +216,7 @@ void afs_edit_dir_add(struct afs_vnode *vnode,
 
 	_enter(",,{%d,%s},", name->len, name->name);
 
-	i_size = i_size_read(&vnode->vfs_inode);
+	i_size = i_size_read(&vnode->netfs.inode);
 	if (i_size > AFS_DIR_BLOCK_SIZE * AFS_DIR_MAX_BLOCKS ||
 	    (i_size & (AFS_DIR_BLOCK_SIZE - 1))) {
 		clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
@@ -336,7 +336,7 @@ void afs_edit_dir_add(struct afs_vnode *vnode,
 	if (b < AFS_DIR_BLOCKS_WITH_CTR)
 		meta->meta.alloc_ctrs[b] -= need_slots;
 
-	inode_inc_iversion_raw(&vnode->vfs_inode);
+	inode_inc_iversion_raw(&vnode->netfs.inode);
 	afs_stat_v(vnode, n_dir_cr);
 	_debug("Insert %s in %u[%u]", name->name, b, slot);
 
@@ -383,7 +383,7 @@ void afs_edit_dir_remove(struct afs_vnode *vnode,
 
 	_enter(",,{%d,%s},", name->len, name->name);
 
-	i_size = i_size_read(&vnode->vfs_inode);
+	i_size = i_size_read(&vnode->netfs.inode);
 	if (i_size < AFS_DIR_BLOCK_SIZE ||
 	    i_size > AFS_DIR_BLOCK_SIZE * AFS_DIR_MAX_BLOCKS ||
 	    (i_size & (AFS_DIR_BLOCK_SIZE - 1))) {
@@ -463,7 +463,7 @@ void afs_edit_dir_remove(struct afs_vnode *vnode,
 	if (b < AFS_DIR_BLOCKS_WITH_CTR)
 		meta->meta.alloc_ctrs[b] += need_slots;
 
-	inode_set_iversion_raw(&vnode->vfs_inode, vnode->status.data_version);
+	inode_set_iversion_raw(&vnode->netfs.inode, vnode->status.data_version);
 	afs_stat_v(vnode, n_dir_rm);
 	_debug("Remove %s from %u[%u]", name->name, b, slot);
 
diff --git a/fs/afs/dir_silly.c b/fs/afs/dir_silly.c
index 45cfd50a9521..bb5807e87fa4 100644
--- a/fs/afs/dir_silly.c
+++ b/fs/afs/dir_silly.c
@@ -131,7 +131,7 @@ int afs_sillyrename(struct afs_vnode *dvnode, struct afs_vnode *vnode,
 			goto out;
 	} while (!d_is_negative(sdentry));
 
-	ihold(&vnode->vfs_inode);
+	ihold(&vnode->netfs.inode);
 
 	ret = afs_do_silly_rename(dvnode, vnode, dentry, sdentry, key);
 	switch (ret) {
@@ -148,7 +148,7 @@ int afs_sillyrename(struct afs_vnode *dvnode, struct afs_vnode *vnode,
 		d_drop(sdentry);
 	}
 
-	iput(&vnode->vfs_inode);
+	iput(&vnode->netfs.inode);
 	dput(sdentry);
 out:
 	_leave(" = %d", ret);
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index f120bcb8bf73..3a5bbffdf053 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -76,7 +76,7 @@ struct inode *afs_iget_pseudo_dir(struct super_block *sb, bool root)
 	/* there shouldn't be an existing inode */
 	BUG_ON(!(inode->i_state & I_NEW));
 
-	netfs_i_context_init(inode, NULL);
+	netfs_inode_init(inode, NULL);
 	inode->i_size		= 0;
 	inode->i_mode		= S_IFDIR | S_IRUGO | S_IXUGO;
 	if (root) {
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 26292a110a8f..fab8324833ba 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -194,7 +194,7 @@ int afs_release(struct inode *inode, struct file *file)
 		afs_put_wb_key(af->wb);
 
 	if ((file->f_mode & FMODE_WRITE)) {
-		i_size = i_size_read(&vnode->vfs_inode);
+		i_size = i_size_read(&vnode->netfs.inode);
 		afs_set_cache_aux(vnode, &aux);
 		fscache_unuse_cookie(afs_vnode_cache(vnode), &aux, &i_size);
 	} else {
@@ -325,7 +325,7 @@ static void afs_issue_read(struct netfs_io_subrequest *subreq)
 	fsreq->iter	= &fsreq->def_iter;
 
 	iov_iter_xarray(&fsreq->def_iter, READ,
-			&fsreq->vnode->vfs_inode.i_mapping->i_pages,
+			&fsreq->vnode->netfs.inode.i_mapping->i_pages,
 			fsreq->pos, fsreq->len);
 
 	afs_fetch_data(fsreq->vnode, fsreq);
diff --git a/fs/afs/fs_operation.c b/fs/afs/fs_operation.c
index d222dfbe976b..7a3803ce3a22 100644
--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -232,14 +232,14 @@ int afs_put_operation(struct afs_operation *op)
 	if (op->file[1].modification && op->file[1].vnode != op->file[0].vnode)
 		clear_bit(AFS_VNODE_MODIFYING, &op->file[1].vnode->flags);
 	if (op->file[0].put_vnode)
-		iput(&op->file[0].vnode->vfs_inode);
+		iput(&op->file[0].vnode->netfs.inode);
 	if (op->file[1].put_vnode)
-		iput(&op->file[1].vnode->vfs_inode);
+		iput(&op->file[1].vnode->netfs.inode);
 
 	if (op->more_files) {
 		for (i = 0; i < op->nr_files - 2; i++)
 			if (op->more_files[i].put_vnode)
-				iput(&op->more_files[i].vnode->vfs_inode);
+				iput(&op->more_files[i].vnode->netfs.inode);
 		kfree(op->more_files);
 	}
 
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 30b066299d39..22811e9eacf5 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -58,7 +58,7 @@ static noinline void dump_vnode(struct afs_vnode *vnode, struct afs_vnode *paren
  */
 static void afs_set_netfs_context(struct afs_vnode *vnode)
 {
-	netfs_i_context_init(&vnode->vfs_inode, &afs_req_ops);
+	netfs_inode_init(&vnode->netfs.inode, &afs_req_ops);
 }
 
 /*
@@ -96,7 +96,7 @@ static int afs_inode_init_from_status(struct afs_operation *op,
 	inode->i_flags |= S_NOATIME;
 	inode->i_uid = make_kuid(&init_user_ns, status->owner);
 	inode->i_gid = make_kgid(&init_user_ns, status->group);
-	set_nlink(&vnode->vfs_inode, status->nlink);
+	set_nlink(&vnode->netfs.inode, status->nlink);
 
 	switch (status->type) {
 	case AFS_FTYPE_FILE:
@@ -139,7 +139,7 @@ static int afs_inode_init_from_status(struct afs_operation *op,
 	afs_set_netfs_context(vnode);
 
 	vnode->invalid_before	= status->data_version;
-	inode_set_iversion_raw(&vnode->vfs_inode, status->data_version);
+	inode_set_iversion_raw(&vnode->netfs.inode, status->data_version);
 
 	if (!vp->scb.have_cb) {
 		/* it's a symlink we just created (the fileserver
@@ -163,7 +163,7 @@ static void afs_apply_status(struct afs_operation *op,
 {
 	struct afs_file_status *status = &vp->scb.status;
 	struct afs_vnode *vnode = vp->vnode;
-	struct inode *inode = &vnode->vfs_inode;
+	struct inode *inode = &vnode->netfs.inode;
 	struct timespec64 t;
 	umode_t mode;
 	bool data_changed = false;
@@ -246,7 +246,7 @@ static void afs_apply_status(struct afs_operation *op,
 		 * idea of what the size should be that's not the same as
 		 * what's on the server.
 		 */
-		vnode->netfs_ctx.remote_i_size = status->size;
+		vnode->netfs.remote_i_size = status->size;
 		if (change_size) {
 			afs_set_i_size(vnode, status->size);
 			inode->i_ctime = t;
@@ -289,7 +289,7 @@ void afs_vnode_commit_status(struct afs_operation *op, struct afs_vnode_param *v
 		 */
 		if (vp->scb.status.abort_code == VNOVNODE) {
 			set_bit(AFS_VNODE_DELETED, &vnode->flags);
-			clear_nlink(&vnode->vfs_inode);
+			clear_nlink(&vnode->netfs.inode);
 			__afs_break_callback(vnode, afs_cb_break_for_deleted);
 			op->flags &= ~AFS_OPERATION_DIR_CONFLICT;
 		}
@@ -306,8 +306,8 @@ void afs_vnode_commit_status(struct afs_operation *op, struct afs_vnode_param *v
 		if (vp->scb.have_cb)
 			afs_apply_callback(op, vp);
 	} else if (vp->op_unlinked && !(op->flags & AFS_OPERATION_DIR_CONFLICT)) {
-		drop_nlink(&vnode->vfs_inode);
-		if (vnode->vfs_inode.i_nlink == 0) {
+		drop_nlink(&vnode->netfs.inode);
+		if (vnode->netfs.inode.i_nlink == 0) {
 			set_bit(AFS_VNODE_DELETED, &vnode->flags);
 			__afs_break_callback(vnode, afs_cb_break_for_deleted);
 		}
@@ -326,7 +326,7 @@ static void afs_fetch_status_success(struct afs_operation *op)
 	struct afs_vnode *vnode = vp->vnode;
 	int ret;
 
-	if (vnode->vfs_inode.i_state & I_NEW) {
+	if (vnode->netfs.inode.i_state & I_NEW) {
 		ret = afs_inode_init_from_status(op, vp, vnode);
 		op->error = ret;
 		if (ret == 0)
@@ -430,7 +430,7 @@ static void afs_get_inode_cache(struct afs_vnode *vnode)
 	struct afs_vnode_cache_aux aux;
 
 	if (vnode->status.type != AFS_FTYPE_FILE) {
-		vnode->netfs_ctx.cache = NULL;
+		vnode->netfs.cache = NULL;
 		return;
 	}
 
@@ -457,7 +457,7 @@ static void afs_get_inode_cache(struct afs_vnode *vnode)
 struct inode *afs_iget(struct afs_operation *op, struct afs_vnode_param *vp)
 {
 	struct afs_vnode_param *dvp = &op->file[0];
-	struct super_block *sb = dvp->vnode->vfs_inode.i_sb;
+	struct super_block *sb = dvp->vnode->netfs.inode.i_sb;
 	struct afs_vnode *vnode;
 	struct inode *inode;
 	int ret;
@@ -582,10 +582,10 @@ static void afs_zap_data(struct afs_vnode *vnode)
 	/* nuke all the non-dirty pages that aren't locked, mapped or being
 	 * written back in a regular file and completely discard the pages in a
 	 * directory or symlink */
-	if (S_ISREG(vnode->vfs_inode.i_mode))
-		invalidate_remote_inode(&vnode->vfs_inode);
+	if (S_ISREG(vnode->netfs.inode.i_mode))
+		invalidate_remote_inode(&vnode->netfs.inode);
 	else
-		invalidate_inode_pages2(vnode->vfs_inode.i_mapping);
+		invalidate_inode_pages2(vnode->netfs.inode.i_mapping);
 }
 
 /*
@@ -683,8 +683,8 @@ int afs_validate(struct afs_vnode *vnode, struct key *key)
 	       key_serial(key));
 
 	if (unlikely(test_bit(AFS_VNODE_DELETED, &vnode->flags))) {
-		if (vnode->vfs_inode.i_nlink)
-			clear_nlink(&vnode->vfs_inode);
+		if (vnode->netfs.inode.i_nlink)
+			clear_nlink(&vnode->netfs.inode);
 		goto valid;
 	}
 
@@ -826,7 +826,7 @@ void afs_evict_inode(struct inode *inode)
 static void afs_setattr_success(struct afs_operation *op)
 {
 	struct afs_vnode_param *vp = &op->file[0];
-	struct inode *inode = &vp->vnode->vfs_inode;
+	struct inode *inode = &vp->vnode->netfs.inode;
 	loff_t old_i_size = i_size_read(inode);
 
 	op->setattr.old_i_size = old_i_size;
@@ -843,7 +843,7 @@ static void afs_setattr_success(struct afs_operation *op)
 static void afs_setattr_edit_file(struct afs_operation *op)
 {
 	struct afs_vnode_param *vp = &op->file[0];
-	struct inode *inode = &vp->vnode->vfs_inode;
+	struct inode *inode = &vp->vnode->netfs.inode;
 
 	if (op->setattr.attr->ia_valid & ATTR_SIZE) {
 		loff_t size = op->setattr.attr->ia_size;
@@ -875,7 +875,7 @@ int afs_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		ATTR_MTIME | ATTR_MTIME_SET | ATTR_TIMES_SET | ATTR_TOUCH;
 	struct afs_operation *op;
 	struct afs_vnode *vnode = AFS_FS_I(d_inode(dentry));
-	struct inode *inode = &vnode->vfs_inode;
+	struct inode *inode = &vnode->netfs.inode;
 	loff_t i_size;
 	int ret;
 
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 7b7ef945dc78..40518b585760 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -619,12 +619,7 @@ enum afs_lock_state {
  * leak from one inode to another.
  */
 struct afs_vnode {
-	struct {
-		/* These must be contiguous */
-		struct inode	vfs_inode;	/* the VFS's inode record */
-		struct netfs_i_context netfs_ctx; /* Netfslib context */
-	};
-
+	struct netfs_inode	netfs;		/* Netfslib context and vfs inode */
 	struct afs_volume	*volume;	/* volume on which vnode resides */
 	struct afs_fid		fid;		/* the file identifier for this inode */
 	struct afs_file_status	status;		/* AFS status info for this file */
@@ -675,7 +670,7 @@ struct afs_vnode {
 static inline struct fscache_cookie *afs_vnode_cache(struct afs_vnode *vnode)
 {
 #ifdef CONFIG_AFS_FSCACHE
-	return netfs_i_cookie(&vnode->vfs_inode);
+	return netfs_i_cookie(&vnode->netfs.inode);
 #else
 	return NULL;
 #endif
@@ -685,7 +680,7 @@ static inline void afs_vnode_set_cache(struct afs_vnode *vnode,
 				       struct fscache_cookie *cookie)
 {
 #ifdef CONFIG_AFS_FSCACHE
-	vnode->netfs_ctx.cache = cookie;
+	vnode->netfs.cache = cookie;
 #endif
 }
 
@@ -892,7 +887,7 @@ static inline void afs_invalidate_cache(struct afs_vnode *vnode, unsigned int fl
 
 	afs_set_cache_aux(vnode, &aux);
 	fscache_invalidate(afs_vnode_cache(vnode), &aux,
-			   i_size_read(&vnode->vfs_inode), flags);
+			   i_size_read(&vnode->netfs.inode), flags);
 }
 
 /*
@@ -1217,7 +1212,7 @@ static inline struct afs_net *afs_i2net(struct inode *inode)
 
 static inline struct afs_net *afs_v2net(struct afs_vnode *vnode)
 {
-	return afs_i2net(&vnode->vfs_inode);
+	return afs_i2net(&vnode->netfs.inode);
 }
 
 static inline struct afs_net *afs_sock2net(struct sock *sk)
@@ -1593,12 +1588,12 @@ extern void yfs_fs_store_opaque_acl2(struct afs_operation *);
  */
 static inline struct afs_vnode *AFS_FS_I(struct inode *inode)
 {
-	return container_of(inode, struct afs_vnode, vfs_inode);
+	return container_of(inode, struct afs_vnode, netfs.inode);
 }
 
 static inline struct inode *AFS_VNODE_TO_I(struct afs_vnode *vnode)
 {
-	return &vnode->vfs_inode;
+	return &vnode->netfs.inode;
 }
 
 /*
@@ -1621,8 +1616,8 @@ static inline void afs_update_dentry_version(struct afs_operation *op,
  */
 static inline void afs_set_i_size(struct afs_vnode *vnode, u64 size)
 {
-	i_size_write(&vnode->vfs_inode, size);
-	vnode->vfs_inode.i_blocks = ((size + 1023) >> 10) << 1;
+	i_size_write(&vnode->netfs.inode, size);
+	vnode->netfs.inode.i_blocks = ((size + 1023) >> 10) << 1;
 }
 
 /*
diff --git a/fs/afs/super.c b/fs/afs/super.c
index 1fea195b0b27..95d713074dc8 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -659,7 +659,7 @@ static void afs_i_init_once(void *_vnode)
 	struct afs_vnode *vnode = _vnode;
 
 	memset(vnode, 0, sizeof(*vnode));
-	inode_init_once(&vnode->vfs_inode);
+	inode_init_once(&vnode->netfs.inode);
 	mutex_init(&vnode->io_lock);
 	init_rwsem(&vnode->validate_lock);
 	spin_lock_init(&vnode->wb_lock);
@@ -700,8 +700,8 @@ static struct inode *afs_alloc_inode(struct super_block *sb)
 	init_rwsem(&vnode->rmdir_lock);
 	INIT_WORK(&vnode->cb_work, afs_invalidate_mmap_work);
 
-	_leave(" = %p", &vnode->vfs_inode);
-	return &vnode->vfs_inode;
+	_leave(" = %p", &vnode->netfs.inode);
+	return &vnode->netfs.inode;
 }
 
 static void afs_free_inode(struct inode *inode)
diff --git a/fs/afs/write.c b/fs/afs/write.c
index c1bc52ac7de1..270e41ac9af4 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -146,10 +146,10 @@ int afs_write_end(struct file *file, struct address_space *mapping,
 
 	write_end_pos = pos + copied;
 
-	i_size = i_size_read(&vnode->vfs_inode);
+	i_size = i_size_read(&vnode->netfs.inode);
 	if (write_end_pos > i_size) {
 		write_seqlock(&vnode->cb_lock);
-		i_size = i_size_read(&vnode->vfs_inode);
+		i_size = i_size_read(&vnode->netfs.inode);
 		if (write_end_pos > i_size)
 			afs_set_i_size(vnode, write_end_pos);
 		write_sequnlock(&vnode->cb_lock);
@@ -257,7 +257,7 @@ static void afs_redirty_pages(struct writeback_control *wbc,
  */
 static void afs_pages_written_back(struct afs_vnode *vnode, loff_t start, unsigned int len)
 {
-	struct address_space *mapping = vnode->vfs_inode.i_mapping;
+	struct address_space *mapping = vnode->netfs.inode.i_mapping;
 	struct folio *folio;
 	pgoff_t end;
 
@@ -354,7 +354,6 @@ static const struct afs_operation_ops afs_store_data_operation = {
 static int afs_store_data(struct afs_vnode *vnode, struct iov_iter *iter, loff_t pos,
 			  bool laundering)
 {
-	struct netfs_i_context *ictx = &vnode->netfs_ctx;
 	struct afs_operation *op;
 	struct afs_wb_key *wbk = NULL;
 	loff_t size = iov_iter_count(iter);
@@ -385,9 +384,9 @@ static int afs_store_data(struct afs_vnode *vnode, struct iov_iter *iter, loff_t
 	op->store.write_iter = iter;
 	op->store.pos = pos;
 	op->store.size = size;
-	op->store.i_size = max(pos + size, ictx->remote_i_size);
+	op->store.i_size = max(pos + size, vnode->netfs.remote_i_size);
 	op->store.laundering = laundering;
-	op->mtime = vnode->vfs_inode.i_mtime;
+	op->mtime = vnode->netfs.inode.i_mtime;
 	op->flags |= AFS_OPERATION_UNINTR;
 	op->ops = &afs_store_data_operation;
 
@@ -554,7 +553,7 @@ static ssize_t afs_write_back_from_locked_folio(struct address_space *mapping,
 	struct iov_iter iter;
 	unsigned long priv;
 	unsigned int offset, to, len, max_len;
-	loff_t i_size = i_size_read(&vnode->vfs_inode);
+	loff_t i_size = i_size_read(&vnode->netfs.inode);
 	bool new_content = test_bit(AFS_VNODE_NEW_CONTENT, &vnode->flags);
 	bool caching = fscache_cookie_enabled(afs_vnode_cache(vnode));
 	long count = wbc->nr_to_write;
@@ -845,7 +844,7 @@ ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	_enter("{%llx:%llu},{%zu},",
 	       vnode->fid.vid, vnode->fid.vnode, count);
 
-	if (IS_SWAPFILE(&vnode->vfs_inode)) {
+	if (IS_SWAPFILE(&vnode->netfs.inode)) {
 		printk(KERN_INFO
 		       "AFS: Attempt to write to active swap file!\n");
 		return -EBUSY;
@@ -958,8 +957,8 @@ void afs_prune_wb_keys(struct afs_vnode *vnode)
 	/* Discard unused keys */
 	spin_lock(&vnode->wb_lock);
 
-	if (!mapping_tagged(&vnode->vfs_inode.i_data, PAGECACHE_TAG_WRITEBACK) &&
-	    !mapping_tagged(&vnode->vfs_inode.i_data, PAGECACHE_TAG_DIRTY)) {
+	if (!mapping_tagged(&vnode->netfs.inode.i_data, PAGECACHE_TAG_WRITEBACK) &&
+	    !mapping_tagged(&vnode->netfs.inode.i_data, PAGECACHE_TAG_DIRTY)) {
 		list_for_each_entry_safe(wbk, tmp, &vnode->wb_keys, vnode_link) {
 			if (refcount_read(&wbk->usage) == 1)
 				list_move(&wbk->vnode_link, &graveyard);
@@ -1034,6 +1033,6 @@ static void afs_write_to_cache(struct afs_vnode *vnode,
 			       bool caching)
 {
 	fscache_write_to_cache(afs_vnode_cache(vnode),
-			       vnode->vfs_inode.i_mapping, start, len, i_size,
+			       vnode->netfs.inode.i_mapping, start, len, i_size,
 			       afs_write_to_cache_done, vnode, caching);
 }
diff --git a/fs/attr.c b/fs/attr.c
index 66899b6e9bd8..dbe996b0dedf 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -61,9 +61,15 @@ static bool chgrp_ok(struct user_namespace *mnt_userns,
 		     const struct inode *inode, kgid_t gid)
 {
 	kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
-	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode)) &&
-	    (in_group_p(gid) || gid_eq(gid, inode->i_gid)))
-		return true;
+	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode))) {
+		kgid_t mapped_gid;
+
+		if (gid_eq(gid, inode->i_gid))
+			return true;
+		mapped_gid = mapped_kgid_fs(mnt_userns, i_user_ns(inode), gid);
+		if (in_group_p(mapped_gid))
+			return true;
+	}
 	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
 		return true;
 	if (gid_eq(kgid, INVALID_GID) &&
@@ -123,12 +129,20 @@ int setattr_prepare(struct user_namespace *mnt_userns, struct dentry *dentry,
 
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
+		kgid_t mapped_gid;
+
 		if (!inode_owner_or_capable(mnt_userns, inode))
 			return -EPERM;
+
+		if (ia_valid & ATTR_GID)
+			mapped_gid = mapped_kgid_fs(mnt_userns,
+						i_user_ns(inode), attr->ia_gid);
+		else
+			mapped_gid = i_gid_into_mnt(mnt_userns, inode);
+
 		/* Also check the setgid bit! */
-               if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
-                                i_gid_into_mnt(mnt_userns, inode)) &&
-                    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_p(mapped_gid) &&
+		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index adef10a6e5c7..11dbb1133a21 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1795,7 +1795,7 @@ enum {
 static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 				s64 pool, struct ceph_string *pool_ns)
 {
-	struct ceph_fs_client *fsc = ceph_inode_to_client(&ci->vfs_inode);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(&ci->netfs.inode);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_osd_request *rd_req = NULL, *wr_req = NULL;
 	struct rb_node **p, *parent;
@@ -1910,7 +1910,7 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 				     0, false, true);
 	err = ceph_osdc_start_request(&fsc->client->osdc, rd_req, false);
 
-	wr_req->r_mtime = ci->vfs_inode.i_mtime;
+	wr_req->r_mtime = ci->netfs.inode.i_mtime;
 	err2 = ceph_osdc_start_request(&fsc->client->osdc, wr_req, false);
 
 	if (!err)
diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index ddea99922073..177d8e8d73fe 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -29,9 +29,9 @@ void ceph_fscache_register_inode_cookie(struct inode *inode)
 	if (!(inode->i_state & I_NEW))
 		return;
 
-	WARN_ON_ONCE(ci->netfs_ctx.cache);
+	WARN_ON_ONCE(ci->netfs.cache);
 
-	ci->netfs_ctx.cache =
+	ci->netfs.cache =
 		fscache_acquire_cookie(fsc->fscache, 0,
 				       &ci->i_vino, sizeof(ci->i_vino),
 				       &ci->i_version, sizeof(ci->i_version),
diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index 7255b790a4c1..26c6ae06e2f4 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -28,7 +28,7 @@ void ceph_fscache_invalidate(struct inode *inode, bool dio_write);
 
 static inline struct fscache_cookie *ceph_fscache_cookie(struct ceph_inode_info *ci)
 {
-	return netfs_i_cookie(&ci->vfs_inode);
+	return netfs_i_cookie(&ci->netfs.inode);
 }
 
 static inline void ceph_fscache_resize(struct inode *inode, loff_t to)
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5c14ef04e474..a0467bca39fa 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -492,7 +492,7 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
 	struct ceph_mount_options *opt = mdsc->fsc->mount_options;
 	ci->i_hold_caps_max = round_jiffies(jiffies +
 					    opt->caps_wanted_delay_max * HZ);
-	dout("__cap_set_timeouts %p %lu\n", &ci->vfs_inode,
+	dout("__cap_set_timeouts %p %lu\n", &ci->netfs.inode,
 	     ci->i_hold_caps_max - jiffies);
 }
 
@@ -507,7 +507,7 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
 static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
 				struct ceph_inode_info *ci)
 {
-	dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
+	dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->netfs.inode,
 	     ci->i_ceph_flags, ci->i_hold_caps_max);
 	if (!mdsc->stopping) {
 		spin_lock(&mdsc->cap_delay_lock);
@@ -531,7 +531,7 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
 static void __cap_delay_requeue_front(struct ceph_mds_client *mdsc,
 				      struct ceph_inode_info *ci)
 {
-	dout("__cap_delay_requeue_front %p\n", &ci->vfs_inode);
+	dout("__cap_delay_requeue_front %p\n", &ci->netfs.inode);
 	spin_lock(&mdsc->cap_delay_lock);
 	ci->i_ceph_flags |= CEPH_I_FLUSH;
 	if (!list_empty(&ci->i_cap_delay_list))
@@ -548,7 +548,7 @@ static void __cap_delay_requeue_front(struct ceph_mds_client *mdsc,
 static void __cap_delay_cancel(struct ceph_mds_client *mdsc,
 			       struct ceph_inode_info *ci)
 {
-	dout("__cap_delay_cancel %p\n", &ci->vfs_inode);
+	dout("__cap_delay_cancel %p\n", &ci->netfs.inode);
 	if (list_empty(&ci->i_cap_delay_list))
 		return;
 	spin_lock(&mdsc->cap_delay_lock);
@@ -568,7 +568,7 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 	 * Each time we receive FILE_CACHE anew, we increment
 	 * i_rdcache_gen.
 	 */
-	if (S_ISREG(ci->vfs_inode.i_mode) &&
+	if (S_ISREG(ci->netfs.inode.i_mode) &&
 	    (issued & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
 	    (had & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0) {
 		ci->i_rdcache_gen++;
@@ -583,14 +583,14 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 	if ((issued & CEPH_CAP_FILE_SHARED) != (had & CEPH_CAP_FILE_SHARED)) {
 		if (issued & CEPH_CAP_FILE_SHARED)
 			atomic_inc(&ci->i_shared_gen);
-		if (S_ISDIR(ci->vfs_inode.i_mode)) {
-			dout(" marking %p NOT complete\n", &ci->vfs_inode);
+		if (S_ISDIR(ci->netfs.inode.i_mode)) {
+			dout(" marking %p NOT complete\n", &ci->netfs.inode);
 			__ceph_dir_clear_complete(ci);
 		}
 	}
 
 	/* Wipe saved layout if we're losing DIR_CREATE caps */
-	if (S_ISDIR(ci->vfs_inode.i_mode) && (had & CEPH_CAP_DIR_CREATE) &&
+	if (S_ISDIR(ci->netfs.inode.i_mode) && (had & CEPH_CAP_DIR_CREATE) &&
 		!(issued & CEPH_CAP_DIR_CREATE)) {
 	     ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
 	     memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
@@ -771,7 +771,7 @@ static int __cap_is_valid(struct ceph_cap *cap)
 
 	if (cap->cap_gen < gen || time_after_eq(jiffies, ttl)) {
 		dout("__cap_is_valid %p cap %p issued %s "
-		     "but STALE (gen %u vs %u)\n", &cap->ci->vfs_inode,
+		     "but STALE (gen %u vs %u)\n", &cap->ci->netfs.inode,
 		     cap, ceph_cap_string(cap->issued), cap->cap_gen, gen);
 		return 0;
 	}
@@ -797,7 +797,7 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented)
 		if (!__cap_is_valid(cap))
 			continue;
 		dout("__ceph_caps_issued %p cap %p issued %s\n",
-		     &ci->vfs_inode, cap, ceph_cap_string(cap->issued));
+		     &ci->netfs.inode, cap, ceph_cap_string(cap->issued));
 		have |= cap->issued;
 		if (implemented)
 			*implemented |= cap->implemented;
@@ -844,12 +844,12 @@ static void __touch_cap(struct ceph_cap *cap)
 
 	spin_lock(&s->s_cap_lock);
 	if (!s->s_cap_iterator) {
-		dout("__touch_cap %p cap %p mds%d\n", &cap->ci->vfs_inode, cap,
+		dout("__touch_cap %p cap %p mds%d\n", &cap->ci->netfs.inode, cap,
 		     s->s_mds);
 		list_move_tail(&cap->session_caps, &s->s_caps);
 	} else {
 		dout("__touch_cap %p cap %p mds%d NOP, iterating over caps\n",
-		     &cap->ci->vfs_inode, cap, s->s_mds);
+		     &cap->ci->netfs.inode, cap, s->s_mds);
 	}
 	spin_unlock(&s->s_cap_lock);
 }
@@ -867,7 +867,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 
 	if ((have & mask) == mask) {
 		dout("__ceph_caps_issued_mask ino 0x%llx snap issued %s"
-		     " (mask %s)\n", ceph_ino(&ci->vfs_inode),
+		     " (mask %s)\n", ceph_ino(&ci->netfs.inode),
 		     ceph_cap_string(have),
 		     ceph_cap_string(mask));
 		return 1;
@@ -879,7 +879,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 			continue;
 		if ((cap->issued & mask) == mask) {
 			dout("__ceph_caps_issued_mask ino 0x%llx cap %p issued %s"
-			     " (mask %s)\n", ceph_ino(&ci->vfs_inode), cap,
+			     " (mask %s)\n", ceph_ino(&ci->netfs.inode), cap,
 			     ceph_cap_string(cap->issued),
 			     ceph_cap_string(mask));
 			if (touch)
@@ -891,7 +891,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 		have |= cap->issued;
 		if ((have & mask) == mask) {
 			dout("__ceph_caps_issued_mask ino 0x%llx combo issued %s"
-			     " (mask %s)\n", ceph_ino(&ci->vfs_inode),
+			     " (mask %s)\n", ceph_ino(&ci->netfs.inode),
 			     ceph_cap_string(cap->issued),
 			     ceph_cap_string(mask));
 			if (touch) {
@@ -919,7 +919,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
 				   int touch)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->netfs.inode.i_sb);
 	int r;
 
 	r = __ceph_caps_issued_mask(ci, mask, touch);
@@ -950,7 +950,7 @@ int __ceph_caps_revoking_other(struct ceph_inode_info *ci,
 
 int ceph_caps_revoking(struct ceph_inode_info *ci, int mask)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	int ret;
 
 	spin_lock(&ci->i_ceph_lock);
@@ -969,8 +969,8 @@ int __ceph_caps_used(struct ceph_inode_info *ci)
 	if (ci->i_rd_ref)
 		used |= CEPH_CAP_FILE_RD;
 	if (ci->i_rdcache_ref ||
-	    (S_ISREG(ci->vfs_inode.i_mode) &&
-	     ci->vfs_inode.i_data.nrpages))
+	    (S_ISREG(ci->netfs.inode.i_mode) &&
+	     ci->netfs.inode.i_data.nrpages))
 		used |= CEPH_CAP_FILE_CACHE;
 	if (ci->i_wr_ref)
 		used |= CEPH_CAP_FILE_WR;
@@ -993,11 +993,11 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
 	const int WR_SHIFT = ffs(CEPH_FILE_MODE_WR);
 	const int LAZY_SHIFT = ffs(CEPH_FILE_MODE_LAZY);
 	struct ceph_mount_options *opt =
-		ceph_inode_to_client(&ci->vfs_inode)->mount_options;
+		ceph_inode_to_client(&ci->netfs.inode)->mount_options;
 	unsigned long used_cutoff = jiffies - opt->caps_wanted_delay_max * HZ;
 	unsigned long idle_cutoff = jiffies - opt->caps_wanted_delay_min * HZ;
 
-	if (S_ISDIR(ci->vfs_inode.i_mode)) {
+	if (S_ISDIR(ci->netfs.inode.i_mode)) {
 		int want = 0;
 
 		/* use used_cutoff here, to keep dir's wanted caps longer */
@@ -1050,7 +1050,7 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
 int __ceph_caps_wanted(struct ceph_inode_info *ci)
 {
 	int w = __ceph_caps_file_wanted(ci) | __ceph_caps_used(ci);
-	if (S_ISDIR(ci->vfs_inode.i_mode)) {
+	if (S_ISDIR(ci->netfs.inode.i_mode)) {
 		/* we want EXCL if holding caps of dir ops */
 		if (w & CEPH_CAP_ANY_DIR_OPS)
 			w |= CEPH_CAP_FILE_EXCL;
@@ -1116,9 +1116,9 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
+	dout("__ceph_remove_cap %p from %p\n", cap, &ci->netfs.inode);
 
-	mdsc = ceph_inode_to_client(&ci->vfs_inode)->mdsc;
+	mdsc = ceph_inode_to_client(&ci->netfs.inode)->mdsc;
 
 	/* remove from inode's cap rbtree, and clear auth cap */
 	rb_erase(&cap->ci_node, &ci->i_caps);
@@ -1169,7 +1169,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 		 * keep i_snap_realm.
 		 */
 		if (ci->i_wr_ref == 0 && ci->i_snap_realm)
-			ceph_change_snap_realm(&ci->vfs_inode, NULL);
+			ceph_change_snap_realm(&ci->netfs.inode, NULL);
 
 		__cap_delay_cancel(mdsc, ci);
 	}
@@ -1188,11 +1188,11 @@ void ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	fsc = ceph_inode_to_client(&ci->vfs_inode);
+	fsc = ceph_inode_to_client(&ci->netfs.inode);
 	WARN_ON_ONCE(ci->i_auth_cap == cap &&
 		     !list_empty(&ci->i_dirty_item) &&
 		     !fsc->blocklisted &&
-		     !ceph_inode_is_shutdown(&ci->vfs_inode));
+		     !ceph_inode_is_shutdown(&ci->netfs.inode));
 
 	__ceph_remove_cap(cap, queue_release);
 }
@@ -1343,7 +1343,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 		       int flushing, u64 flush_tid, u64 oldest_flush_tid)
 {
 	struct ceph_inode_info *ci = cap->ci;
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	int held, revoking;
 
 	lockdep_assert_held(&ci->i_ceph_lock);
@@ -1440,7 +1440,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 {
 	struct ceph_msg *msg;
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, CAP_MSG_SIZE, GFP_NOFS, false);
 	if (!msg) {
@@ -1528,7 +1528,7 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 		__releases(ci->i_ceph_lock)
 		__acquires(ci->i_ceph_lock)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	struct ceph_mds_client *mdsc = session->s_mdsc;
 	struct ceph_cap_snap *capsnap;
 	u64 oldest_flush_tid = 0;
@@ -1621,7 +1621,7 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 void ceph_flush_snaps(struct ceph_inode_info *ci,
 		      struct ceph_mds_session **psession)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
 	struct ceph_mds_session *session = NULL;
 	int mds;
@@ -1681,8 +1681,8 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 			   struct ceph_cap_flush **pcf)
 {
 	struct ceph_mds_client *mdsc =
-		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
-	struct inode *inode = &ci->vfs_inode;
+		ceph_sb_to_client(ci->netfs.inode.i_sb)->mdsc;
+	struct inode *inode = &ci->netfs.inode;
 	int was = ci->i_dirty_caps;
 	int dirty = 0;
 
@@ -1695,7 +1695,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 		return 0;
 	}
 
-	dout("__mark_dirty_caps %p %s dirty %s -> %s\n", &ci->vfs_inode,
+	dout("__mark_dirty_caps %p %s dirty %s -> %s\n", &ci->netfs.inode,
 	     ceph_cap_string(mask), ceph_cap_string(was),
 	     ceph_cap_string(was | mask));
 	ci->i_dirty_caps |= mask;
@@ -1711,7 +1711,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 				ci->i_snap_realm->cached_context);
 		}
 		dout(" inode %p now dirty snapc %p auth cap %p\n",
-		     &ci->vfs_inode, ci->i_head_snapc, ci->i_auth_cap);
+		     &ci->netfs.inode, ci->i_head_snapc, ci->i_auth_cap);
 		BUG_ON(!list_empty(&ci->i_dirty_item));
 		spin_lock(&mdsc->cap_dirty_lock);
 		list_add(&ci->i_dirty_item, &session->s_cap_dirty);
@@ -1874,7 +1874,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 
 bool __ceph_should_report_size(struct ceph_inode_info *ci)
 {
-	loff_t size = i_size_read(&ci->vfs_inode);
+	loff_t size = i_size_read(&ci->netfs.inode);
 	/* mds will adjust max size according to the reported size */
 	if (ci->i_flushing_caps & CEPH_CAP_FILE_WR)
 		return false;
@@ -1899,7 +1899,7 @@ bool __ceph_should_report_size(struct ceph_inode_info *ci)
 void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		     struct ceph_mds_session *session)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	struct ceph_cap *cap;
 	u64 flush_tid, oldest_flush_tid;
@@ -2446,7 +2446,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 	__releases(ci->i_ceph_lock)
 	__acquires(ci->i_ceph_lock)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	struct ceph_cap *cap;
 	struct ceph_cap_flush *cf;
 	int ret;
@@ -2539,7 +2539,7 @@ void ceph_early_kick_flushing_caps(struct ceph_mds_client *mdsc,
 		cap = ci->i_auth_cap;
 		if (!(cap && cap->session == session)) {
 			pr_err("%p auth cap %p not mds%d ???\n",
-				&ci->vfs_inode, cap, session->s_mds);
+				&ci->netfs.inode, cap, session->s_mds);
 			spin_unlock(&ci->i_ceph_lock);
 			continue;
 		}
@@ -2589,7 +2589,7 @@ void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
 		cap = ci->i_auth_cap;
 		if (!(cap && cap->session == session)) {
 			pr_err("%p auth cap %p not mds%d ???\n",
-				&ci->vfs_inode, cap, session->s_mds);
+				&ci->netfs.inode, cap, session->s_mds);
 			spin_unlock(&ci->i_ceph_lock);
 			continue;
 		}
@@ -2609,7 +2609,7 @@ void ceph_kick_flushing_inode_caps(struct ceph_mds_session *session,
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	dout("%s %p flushing %s\n", __func__, &ci->vfs_inode,
+	dout("%s %p flushing %s\n", __func__, &ci->netfs.inode,
 	     ceph_cap_string(ci->i_flushing_caps));
 
 	if (!list_empty(&ci->i_cap_flush_list)) {
@@ -2652,10 +2652,10 @@ void ceph_take_cap_refs(struct ceph_inode_info *ci, int got,
 	}
 	if (got & CEPH_CAP_FILE_BUFFER) {
 		if (ci->i_wb_ref == 0)
-			ihold(&ci->vfs_inode);
+			ihold(&ci->netfs.inode);
 		ci->i_wb_ref++;
 		dout("%s %p wb %d -> %d (?)\n", __func__,
-		     &ci->vfs_inode, ci->i_wb_ref-1, ci->i_wb_ref);
+		     &ci->netfs.inode, ci->i_wb_ref-1, ci->i_wb_ref);
 	}
 }
 
@@ -2983,7 +2983,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 			return ret;
 		}
 
-		if (S_ISREG(ci->vfs_inode.i_mode) &&
+		if (S_ISREG(ci->netfs.inode.i_mode) &&
 		    ci->i_inline_version != CEPH_INLINE_NONE &&
 		    (_got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
 		    i_size_read(inode) > 0) {
@@ -3073,7 +3073,7 @@ enum put_cap_refs_mode {
 static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 				enum put_cap_refs_mode mode)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	int last = 0, put = 0, flushsnaps = 0, wake = 0;
 	bool check_flushsnaps = false;
 
@@ -3181,7 +3181,7 @@ void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
 void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				struct ceph_snap_context *snapc)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	struct ceph_cap_snap *capsnap = NULL;
 	int put = 0;
 	bool last = false;
@@ -3678,7 +3678,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 				     session->s_mds,
 				     &list_first_entry(&session->s_cap_flushing,
 						struct ceph_inode_info,
-						i_flushing_item)->vfs_inode);
+						i_flushing_item)->netfs.inode);
 			}
 		}
 		mdsc->num_cap_flushing--;
@@ -4326,7 +4326,7 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 			break;
 		list_del_init(&ci->i_cap_delay_list);
 
-		inode = igrab(&ci->vfs_inode);
+		inode = igrab(&ci->netfs.inode);
 		if (inode) {
 			spin_unlock(&mdsc->cap_delay_lock);
 			dout("check_delayed_caps on %p\n", inode);
@@ -4354,7 +4354,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
 	while (!list_empty(&s->s_cap_dirty)) {
 		ci = list_first_entry(&s->s_cap_dirty, struct ceph_inode_info,
 				      i_dirty_item);
-		inode = &ci->vfs_inode;
+		inode = &ci->netfs.inode;
 		ihold(inode);
 		dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
 		spin_unlock(&mdsc->cap_dirty_lock);
@@ -4388,7 +4388,7 @@ void __ceph_touch_fmode(struct ceph_inode_info *ci,
 
 void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
 {
-	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->netfs.inode.i_sb);
 	int bits = (fmode << 1) | 1;
 	bool already_opened = false;
 	int i;
@@ -4422,7 +4422,7 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
  */
 void ceph_put_fmode(struct ceph_inode_info *ci, int fmode, int count)
 {
-	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->netfs.inode.i_sb);
 	int bits = (fmode << 1) | 1;
 	bool is_closed = true;
 	int i;
@@ -4637,7 +4637,7 @@ int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invali
 	lockdep_assert_held(&ci->i_ceph_lock);
 
 	dout("removing cap %p, ci is %p, inode is %p\n",
-	     cap, ci, &ci->vfs_inode);
+	     cap, ci, &ci->netfs.inode);
 
 	is_auth = (cap == ci->i_auth_cap);
 	__ceph_remove_cap(cap, false);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 8c8226c0feac..da59e836a06e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -205,7 +205,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mount_options *opt =
-		ceph_inode_to_client(&ci->vfs_inode)->mount_options;
+		ceph_inode_to_client(&ci->netfs.inode)->mount_options;
 	struct ceph_file_info *fi;
 	int ret;
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 63113e2a4890..f7a99a7e53c2 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -176,7 +176,7 @@ static struct ceph_inode_frag *__get_or_create_frag(struct ceph_inode_info *ci,
 	rb_insert_color(&frag->node, &ci->i_fragtree);
 
 	dout("get_or_create_frag added %llx.%llx frag %x\n",
-	     ceph_vinop(&ci->vfs_inode), f);
+	     ceph_vinop(&ci->netfs.inode), f);
 	return frag;
 }
 
@@ -457,10 +457,10 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	if (!ci)
 		return NULL;
 
-	dout("alloc_inode %p\n", &ci->vfs_inode);
+	dout("alloc_inode %p\n", &ci->netfs.inode);
 
 	/* Set parameters for the netfs library */
-	netfs_i_context_init(&ci->vfs_inode, &ceph_netfs_ops);
+	netfs_inode_init(&ci->netfs.inode, &ceph_netfs_ops);
 
 	spin_lock_init(&ci->i_ceph_lock);
 
@@ -547,7 +547,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	INIT_WORK(&ci->i_work, ceph_inode_work);
 	ci->i_work_mask = 0;
 	memset(&ci->i_btime, '\0', sizeof(ci->i_btime));
-	return &ci->vfs_inode;
+	return &ci->netfs.inode;
 }
 
 void ceph_free_inode(struct inode *inode)
@@ -1977,7 +1977,7 @@ static void ceph_inode_work(struct work_struct *work)
 {
 	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
 						 i_work);
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 
 	if (test_and_clear_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask)) {
 		dout("writeback %p\n", inode);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8c249511344d..3f72ba137ff8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1564,7 +1564,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	p = session->s_caps.next;
 	while (p != &session->s_caps) {
 		cap = list_entry(p, struct ceph_cap, session_caps);
-		inode = igrab(&cap->ci->vfs_inode);
+		inode = igrab(&cap->ci->netfs.inode);
 		if (!inode) {
 			p = p->next;
 			continue;
@@ -1622,7 +1622,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	int iputs;
 
 	dout("removing cap %p, ci is %p, inode is %p\n",
-	     cap, ci, &ci->vfs_inode);
+	     cap, ci, &ci->netfs.inode);
 	spin_lock(&ci->i_ceph_lock);
 	iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
 	spin_unlock(&ci->i_ceph_lock);
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 322ee5add942..864cdaa0d2bd 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -521,7 +521,7 @@ static bool has_new_snaps(struct ceph_snap_context *o,
 static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 				struct ceph_cap_snap **pcapsnap)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	struct ceph_snap_context *old_snapc, *new_snapc;
 	struct ceph_cap_snap *capsnap = *pcapsnap;
 	struct ceph_buffer *old_blob = NULL;
@@ -652,7 +652,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 			    struct ceph_cap_snap *capsnap)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct inode *inode = &ci->netfs.inode;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 
 	BUG_ON(capsnap->writing);
@@ -712,7 +712,7 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 
 	spin_lock(&realm->inodes_with_caps_lock);
 	list_for_each_entry(ci, &realm->inodes_with_caps, i_snap_realm_item) {
-		struct inode *inode = igrab(&ci->vfs_inode);
+		struct inode *inode = igrab(&ci->netfs.inode);
 		if (!inode)
 			continue;
 		spin_unlock(&realm->inodes_with_caps_lock);
@@ -904,7 +904,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	while (!list_empty(&mdsc->snap_flush_list)) {
 		ci = list_first_entry(&mdsc->snap_flush_list,
 				struct ceph_inode_info, i_snap_flush_item);
-		inode = &ci->vfs_inode;
+		inode = &ci->netfs.inode;
 		ihold(inode);
 		spin_unlock(&mdsc->snap_flush_lock);
 		ceph_flush_snaps(ci, &session);
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index e6987d295079..612d8bc73ea9 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -876,7 +876,7 @@ mempool_t *ceph_wb_pagevec_pool;
 static void ceph_inode_init_once(void *foo)
 {
 	struct ceph_inode_info *ci = foo;
-	inode_init_once(&ci->vfs_inode);
+	inode_init_once(&ci->netfs.inode);
 }
 
 static int __init init_caches(void)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 20ceab74e871..755a1ad26016 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -316,11 +316,7 @@ struct ceph_inode_xattrs_info {
  * Ceph inode.
  */
 struct ceph_inode_info {
-	struct {
-		/* These must be contiguous */
-		struct inode vfs_inode;
-		struct netfs_i_context netfs_ctx; /* Netfslib context */
-	};
+	struct netfs_inode netfs; /* Netfslib context and vfs inode */
 	struct ceph_vino i_vino;   /* ceph ino + snap */
 
 	spinlock_t i_ceph_lock;
@@ -436,7 +432,7 @@ struct ceph_inode_info {
 static inline struct ceph_inode_info *
 ceph_inode(const struct inode *inode)
 {
-	return container_of(inode, struct ceph_inode_info, vfs_inode);
+	return container_of(inode, struct ceph_inode_info, netfs.inode);
 }
 
 static inline struct ceph_fs_client *
@@ -1295,7 +1291,7 @@ static inline void __ceph_update_quota(struct ceph_inode_info *ci,
 	has_quota = __ceph_has_any_quota(ci);
 
 	if (had_quota != has_quota)
-		ceph_adjust_quota_realms_count(&ci->vfs_inode, has_quota);
+		ceph_adjust_quota_realms_count(&ci->netfs.inode, has_quota);
 }
 
 extern void ceph_handle_quota(struct ceph_mds_client *mdsc,
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 8c2dc2c762a4..f141f5246163 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -57,7 +57,7 @@ static bool ceph_vxattrcb_layout_exists(struct ceph_inode_info *ci)
 static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 				    size_t size)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->netfs.inode.i_sb);
 	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	struct ceph_string *pool_ns;
 	s64 pool = ci->i_layout.pool_id;
@@ -69,7 +69,7 @@ static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 
 	pool_ns = ceph_try_get_string(ci->i_layout.pool_ns);
 
-	dout("ceph_vxattrcb_layout %p\n", &ci->vfs_inode);
+	dout("ceph_vxattrcb_layout %p\n", &ci->netfs.inode);
 	down_read(&osdc->lock);
 	pool_name = ceph_pg_pool_name_by_id(osdc->osdmap, pool);
 	if (pool_name) {
@@ -161,7 +161,7 @@ static ssize_t ceph_vxattrcb_layout_pool(struct ceph_inode_info *ci,
 					 char *val, size_t size)
 {
 	ssize_t ret;
-	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->netfs.inode.i_sb);
 	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	s64 pool = ci->i_layout.pool_id;
 	const char *pool_name;
@@ -313,7 +313,7 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
 static ssize_t ceph_vxattrcb_cluster_fsid(struct ceph_inode_info *ci,
 					  char *val, size_t size)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->netfs.inode.i_sb);
 
 	return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
 }
@@ -321,7 +321,7 @@ static ssize_t ceph_vxattrcb_cluster_fsid(struct ceph_inode_info *ci,
 static ssize_t ceph_vxattrcb_client_id(struct ceph_inode_info *ci,
 				       char *val, size_t size)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->netfs.inode.i_sb);
 
 	return ceph_fmt_xattr(val, size, "client%lld",
 			      ceph_client_gid(fsc->client));
@@ -629,7 +629,7 @@ static int __set_xattr(struct ceph_inode_info *ci,
 	}
 
 	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s\n",
-	     ceph_vinop(&ci->vfs_inode), xattr, name_len, name, val_len, val);
+	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name, val_len, val);
 
 	return 0;
 }
@@ -871,7 +871,7 @@ struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci)
 	struct ceph_buffer *old_blob = NULL;
 	void *dest;
 
-	dout("__build_xattrs_blob %p\n", &ci->vfs_inode);
+	dout("__build_xattrs_blob %p\n", &ci->netfs.inode);
 	if (ci->i_xattrs.dirty) {
 		int need = __get_required_blob_size(ci, 0, 0);
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9b4fd7686699..26f0210d04bd 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -377,7 +377,7 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode->flags = 0;
 	spin_lock_init(&cifs_inode->writers_lock);
 	cifs_inode->writers = 0;
-	cifs_inode->vfs_inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
+	cifs_inode->netfs.inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
 	cifs_inode->server_eof = 0;
 	cifs_inode->uniqueid = 0;
 	cifs_inode->createtime = 0;
@@ -389,12 +389,12 @@ cifs_alloc_inode(struct super_block *sb)
 	 * Can not set i_flags here - they get immediately overwritten to zero
 	 * by the VFS.
 	 */
-	/* cifs_inode->vfs_inode.i_flags = S_NOATIME | S_NOCMTIME; */
+	/* cifs_inode->netfs.inode.i_flags = S_NOATIME | S_NOCMTIME; */
 	INIT_LIST_HEAD(&cifs_inode->openFileList);
 	INIT_LIST_HEAD(&cifs_inode->llist);
 	INIT_LIST_HEAD(&cifs_inode->deferred_closes);
 	spin_lock_init(&cifs_inode->deferred_lock);
-	return &cifs_inode->vfs_inode;
+	return &cifs_inode->netfs.inode;
 }
 
 static void
@@ -1416,7 +1416,7 @@ cifs_init_once(void *inode)
 {
 	struct cifsInodeInfo *cifsi = inode;
 
-	inode_init_once(&cifsi->vfs_inode);
+	inode_init_once(&cifsi->netfs.inode);
 	init_rwsem(&cifsi->lock_sem);
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a6cade2aebd9..4247910682c4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1414,20 +1414,16 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 #define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
 #define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
 
-#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || (CIFS_SB(cinode->vfs_inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE))
+#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE))
 #define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
-#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->vfs_inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
+#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
 
 /*
  * One of these for each file inode
  */
 
 struct cifsInodeInfo {
-	struct {
-		/* These must be contiguous */
-		struct inode	vfs_inode;	/* the VFS's inode record */
-		struct netfs_i_context netfs_ctx; /* Netfslib context */
-	};
+	struct netfs_inode netfs; /* Netfslib context and vfs inode */
 	bool can_cache_brlcks;
 	struct list_head llist;	/* locks helb by this inode */
 	/*
@@ -1466,7 +1462,7 @@ struct cifsInodeInfo {
 static inline struct cifsInodeInfo *
 CIFS_I(struct inode *inode)
 {
-	return container_of(inode, struct cifsInodeInfo, vfs_inode);
+	return container_of(inode, struct cifsInodeInfo, netfs.inode);
 }
 
 static inline struct cifs_sb_info *
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d511a78383c3..58dce567ceaf 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2004,7 +2004,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 					bool fsuid_only)
 {
 	struct cifsFileInfo *open_file = NULL;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->netfs.inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
@@ -2060,7 +2060,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 		return rc;
 	}
 
-	cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
+	cifs_sb = CIFS_SB(cifs_inode->netfs.inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
@@ -4665,14 +4665,14 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
 		/* This inode is open for write at least once */
 		struct cifs_sb_info *cifs_sb;
 
-		cifs_sb = CIFS_SB(cifsInode->vfs_inode.i_sb);
+		cifs_sb = CIFS_SB(cifsInode->netfs.inode.i_sb);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
 			/* since no page cache to corrupt on directio
 			we can change size safely */
 			return true;
 		}
 
-		if (i_size_read(&cifsInode->vfs_inode) < end_of_file)
+		if (i_size_read(&cifsInode->netfs.inode) < end_of_file)
 			return true;
 
 		return false;
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index a638b29e9062..23ef56f55ce5 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -101,13 +101,13 @@ void cifs_fscache_get_inode_cookie(struct inode *inode)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 
-	cifs_fscache_fill_coherency(&cifsi->vfs_inode, &cd);
+	cifs_fscache_fill_coherency(&cifsi->netfs.inode, &cd);
 
-	cifsi->netfs_ctx.cache =
+	cifsi->netfs.cache =
 		fscache_acquire_cookie(tcon->fscache, 0,
 				       &cifsi->uniqueid, sizeof(cifsi->uniqueid),
 				       &cd, sizeof(cd),
-				       i_size_read(&cifsi->vfs_inode));
+				       i_size_read(&cifsi->netfs.inode));
 }
 
 void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update)
@@ -131,7 +131,7 @@ void cifs_fscache_release_inode_cookie(struct inode *inode)
 	if (cookie) {
 		cifs_dbg(FYI, "%s: (0x%p)\n", __func__, cookie);
 		fscache_relinquish_cookie(cookie, false);
-		cifsi->netfs_ctx.cache = NULL;
+		cifsi->netfs.cache = NULL;
 	}
 }
 
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index 52355c0912ae..ab9a51d0125c 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -52,10 +52,10 @@ void cifs_fscache_fill_coherency(struct inode *inode,
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 
 	memset(cd, 0, sizeof(*cd));
-	cd->last_write_time_sec   = cpu_to_le64(cifsi->vfs_inode.i_mtime.tv_sec);
-	cd->last_write_time_nsec  = cpu_to_le32(cifsi->vfs_inode.i_mtime.tv_nsec);
-	cd->last_change_time_sec  = cpu_to_le64(cifsi->vfs_inode.i_ctime.tv_sec);
-	cd->last_change_time_nsec = cpu_to_le32(cifsi->vfs_inode.i_ctime.tv_nsec);
+	cd->last_write_time_sec   = cpu_to_le64(cifsi->netfs.inode.i_mtime.tv_sec);
+	cd->last_write_time_nsec  = cpu_to_le32(cifsi->netfs.inode.i_mtime.tv_nsec);
+	cd->last_change_time_sec  = cpu_to_le64(cifsi->netfs.inode.i_ctime.tv_sec);
+	cd->last_change_time_nsec = cpu_to_le32(cifsi->netfs.inode.i_ctime.tv_nsec);
 }
 
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 2f9e7d2f81b6..81da81e18553 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -115,7 +115,7 @@ cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 		 __func__, cifs_i->uniqueid);
 	set_bit(CIFS_INO_INVALID_MAPPING, &cifs_i->flags);
 	/* Invalidate fscache cookie */
-	cifs_fscache_fill_coherency(&cifs_i->vfs_inode, &cd);
+	cifs_fscache_fill_coherency(&cifs_i->netfs.inode, &cd);
 	fscache_invalidate(cifs_inode_cookie(inode), &cd, i_size_read(inode), 0);
 }
 
@@ -2499,7 +2499,7 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 		u64 len)
 {
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_i->vfs_inode.i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_i->netfs.inode.i_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifsFileInfo *cfile;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 4abf36b3b345..14e8dfc83c7e 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -535,11 +535,11 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 	if (oplock == OPLOCK_EXCLUSIVE) {
 		cinode->oplock = CIFS_CACHE_WRITE_FLG | CIFS_CACHE_READ_FLG;
 		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
-			 &cinode->vfs_inode);
+			 &cinode->netfs.inode);
 	} else if (oplock == OPLOCK_READ) {
 		cinode->oplock = CIFS_CACHE_READ_FLG;
 		cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
-			 &cinode->vfs_inode);
+			 &cinode->netfs.inode);
 	} else
 		cinode->oplock = 0;
 }
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6e26edbffc48..19f957785a73 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4241,15 +4241,15 @@ smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 	if (oplock == SMB2_OPLOCK_LEVEL_BATCH) {
 		cinode->oplock = CIFS_CACHE_RHW_FLG;
 		cifs_dbg(FYI, "Batch Oplock granted on inode %p\n",
-			 &cinode->vfs_inode);
+			 &cinode->netfs.inode);
 	} else if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 		cinode->oplock = CIFS_CACHE_RW_FLG;
 		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
-			 &cinode->vfs_inode);
+			 &cinode->netfs.inode);
 	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
 		cinode->oplock = CIFS_CACHE_READ_FLG;
 		cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
-			 &cinode->vfs_inode);
+			 &cinode->netfs.inode);
 	} else
 		cinode->oplock = 0;
 }
@@ -4288,7 +4288,7 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 
 	cinode->oplock = new_oplock;
 	cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
-		 &cinode->vfs_inode);
+		 &cinode->netfs.inode);
 }
 
 static void
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 87d85ce04d58..816448041db8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4107,6 +4107,15 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	size = size >> bsbits;
 	start = start_off >> bsbits;
 
+	/*
+	 * For tiny groups (smaller than 8MB) the chosen allocation
+	 * alignment may be larger than group size. Make sure the
+	 * alignment does not move allocation to a different group which
+	 * makes mballoc fail assertions later.
+	 */
+	start = max(start, rounddown(ac->ac_o_ex.fe_logical,
+			(ext4_lblk_t)EXT4_BLOCKS_PER_GROUP(ac->ac_sb)));
+
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {
 		size -= ar->lleft + 1 - start;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e9cba12e5e12..4f0420b1ff3e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1929,7 +1929,8 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			struct dx_hash_info *hinfo)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
-	unsigned count, continued;
+	unsigned continued;
+	int count;
 	struct buffer_head *bh2;
 	ext4_lblk_t newblock;
 	u32 hash2;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 90a941d20dff..8b70a4701293 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -53,6 +53,16 @@ int ext4_resize_begin(struct super_block *sb)
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
+	/*
+	 * If the reserved GDT blocks is non-zero, the resize_inode feature
+	 * should always be set.
+	 */
+	if (EXT4_SB(sb)->s_es->s_reserved_gdt_blocks &&
+	    !ext4_has_feature_resize_inode(sb)) {
+		ext4_error(sb, "resize_inode disabled but reserved GDT blocks non-zero");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * If we are not using the primary superblock/GDT copy don't resize,
          * because the user tools have no way of handling this.  Probably a
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a0c79304f92f..552285de2c7b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5422,14 +5422,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
 					  GFP_KERNEL);
 	}
-	/*
-	 * Update the checksum after updating free space/inode
-	 * counters.  Otherwise the superblock can have an incorrect
-	 * checksum in the buffer cache until it is written out and
-	 * e2fsprogs programs trying to open a file system immediately
-	 * after it is mounted can fail.
-	 */
-	ext4_superblock_csum_set(sb);
 	if (!err)
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 					  ext4_count_dirs(sb), GFP_KERNEL);
@@ -5487,6 +5479,14 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
+	/*
+	 * Update the checksum after updating free space/inode counters and
+	 * ext4_orphan_cleanup. Otherwise the superblock can have an incorrect
+	 * checksum in the buffer cache until it is written out and
+	 * e2fsprogs programs trying to open a file system immediately
+	 * after it is mounted can fail.
+	 */
+	ext4_superblock_csum_set(sb);
 	if (needs_recovery) {
 		ext4_msg(sb, KERN_INFO, "recovery complete");
 		err = ext4_mark_recovery_complete(sb, es);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9e247335e70d..3d123ca028c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -111,7 +111,8 @@
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
+				REQ_F_ASYNC_DATA)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -493,6 +494,7 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
+	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -1186,8 +1188,6 @@ static void io_clean_op(struct io_kiocb *req);
 static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 					     unsigned issue_flags);
 static inline struct file *io_file_get_normal(struct io_kiocb *req, int fd);
-static void io_drop_inflight_file(struct io_kiocb *req);
-static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1435,9 +1435,29 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
 	__must_hold(&req->ctx->timeout_lock)
 {
+	struct io_kiocb *req;
+
 	if (task && head->task != task)
 		return false;
-	return cancel_all;
+	if (cancel_all)
+		return true;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+static bool io_match_linked(struct io_kiocb *head)
+{
+	struct io_kiocb *req;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
 }
 
 /*
@@ -1447,9 +1467,24 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			       bool cancel_all)
 {
+	bool matched;
+
 	if (task && head->task != task)
 		return false;
-	return cancel_all;
+	if (cancel_all)
+		return true;
+
+	if (head->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = head->ctx;
+
+		/* protect against races with linked timeouts */
+		spin_lock_irq(&ctx->timeout_lock);
+		matched = io_match_linked(head);
+		spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		matched = io_match_linked(head);
+	}
+	return matched;
 }
 
 static inline bool req_has_async_data(struct io_kiocb *req)
@@ -1608,6 +1643,14 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
+static inline void io_req_track_inflight(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_INFLIGHT)) {
+		req->flags |= REQ_F_INFLIGHT;
+		atomic_inc(&current->io_uring->inflight_tracked);
+	}
+}
+
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!req->link))
@@ -2516,8 +2559,6 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 
 	WARN_ON_ONCE(!tctx);
 
-	io_drop_inflight_file(req);
-
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	if (priority)
 		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
@@ -5869,10 +5910,6 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = req->apoll_events };
-			unsigned flags = locked ? 0 : IO_URING_F_UNLOCKED;
-
-			if (unlikely(!io_assign_file(req, flags)))
-				return -EBADF;
 			req->result = vfs_poll(req->file, &pt) & req->apoll_events;
 		}
 
@@ -7097,6 +7134,11 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_uring_task *tctx = req->task->io_uring;
+
+		atomic_dec(&tctx->inflight_tracked);
+	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
 	if (req->flags & REQ_F_ASYNC_DATA) {
@@ -7393,19 +7435,6 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	return file;
 }
 
-/*
- * Drop the file for requeue operations. Only used of req->file is the
- * io_uring descriptor itself.
- */
-static void io_drop_inflight_file(struct io_kiocb *req)
-{
-	if (unlikely(req->flags & REQ_F_INFLIGHT)) {
-		fput(req->file);
-		req->file = NULL;
-		req->flags &= ~REQ_F_INFLIGHT;
-	}
-}
-
 static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 {
 	struct file *file = fget(fd);
@@ -7414,7 +7443,7 @@ static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 
 	/* we don't allow fixed io_uring files */
 	if (file && file->f_op == &io_uring_fops)
-		req->flags |= REQ_F_INFLIGHT;
+		io_req_track_inflight(req);
 	return file;
 }
 
@@ -8479,11 +8508,19 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
+	unsigned nr = ctx->nr_user_files;
 	int ret;
 
 	if (!ctx->file_data)
 		return -ENXIO;
+
+	/*
+	 * Quiesce may unlock ->uring_lock, and while it's not held
+	 * prevent new requests using the table.
+	 */
+	ctx->nr_user_files = 0;
 	ret = io_rsrc_ref_quiesce(ctx->file_data, ctx);
+	ctx->nr_user_files = nr;
 	if (!ret)
 		__io_sqe_files_unregister(ctx);
 	return ret;
@@ -9211,6 +9248,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
+	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -9457,12 +9495,19 @@ static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
+	unsigned nr = ctx->nr_user_bufs;
 	int ret;
 
 	if (!ctx->buf_data)
 		return -ENXIO;
 
+	/*
+	 * Quiesce may unlock ->uring_lock, and while it's not held
+	 * prevent new requests using the table.
+	 */
+	ctx->nr_user_bufs = 0;
 	ret = io_rsrc_ref_quiesce(ctx->buf_data, ctx);
+	ctx->nr_user_bufs = nr;
 	if (!ret)
 		__io_sqe_buffers_unregister(ctx);
 	return ret;
@@ -10402,7 +10447,7 @@ static __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
 	if (tracked)
-		return 0;
+		return atomic_read(&tctx->inflight_tracked);
 	return percpu_counter_sum(&tctx->inflight);
 }
 
diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 281a88a5b8dc..e8e3359a4c54 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -155,7 +155,7 @@ static void netfs_rreq_expand(struct netfs_io_request *rreq,
 void netfs_readahead(struct readahead_control *ractl)
 {
 	struct netfs_io_request *rreq;
-	struct netfs_i_context *ctx = netfs_i_context(ractl->mapping->host);
+	struct netfs_inode *ctx = netfs_inode(ractl->mapping->host);
 	int ret;
 
 	_enter("%lx,%x", readahead_index(ractl), readahead_count(ractl));
@@ -216,7 +216,7 @@ int netfs_readpage(struct file *file, struct page *subpage)
 	struct folio *folio = page_folio(subpage);
 	struct address_space *mapping = folio_file_mapping(folio);
 	struct netfs_io_request *rreq;
-	struct netfs_i_context *ctx = netfs_i_context(mapping->host);
+	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	int ret;
 
 	_enter("%lx", folio_index(folio));
@@ -333,7 +333,7 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
 		      struct folio **_folio, void **_fsdata)
 {
 	struct netfs_io_request *rreq;
-	struct netfs_i_context *ctx = netfs_i_context(file_inode(file ));
+	struct netfs_inode *ctx = netfs_inode(file_inode(file ));
 	struct folio *folio;
 	unsigned int fgp_flags;
 	pgoff_t index = pos >> PAGE_SHIFT;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index b7b0e3d18d9e..43fac1b14e40 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -91,7 +91,7 @@ static inline void netfs_stat_d(atomic_t *stat)
 /*
  * Miscellaneous functions.
  */
-static inline bool netfs_is_cache_enabled(struct netfs_i_context *ctx)
+static inline bool netfs_is_cache_enabled(struct netfs_inode *ctx)
 {
 #if IS_ENABLED(CONFIG_FSCACHE)
 	struct fscache_cookie *cookie = ctx->cache;
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index e86107b30ba4..c6afa605b63b 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -18,7 +18,7 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
 {
 	static atomic_t debug_ids;
 	struct inode *inode = file ? file_inode(file) : mapping->host;
-	struct netfs_i_context *ctx = netfs_i_context(inode);
+	struct netfs_inode *ctx = netfs_inode(inode);
 	struct netfs_io_request *rreq;
 	int ret;
 
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index c8520284dda7..c1eda73254e1 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -288,6 +288,7 @@ static u32 initiate_file_draining(struct nfs_client *clp,
 		rv = NFS4_OK;
 		break;
 	case -ENOENT:
+		set_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags);
 		/* Embrace your forgetfulness! */
 		rv = NFS4ERR_NOMATCHING_LAYOUT;
 
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 68a87be3e6f9..41a9b6b58fb9 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -469,6 +469,7 @@ pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 		pnfs_clear_lseg_state(lseg, lseg_list);
 	pnfs_clear_layoutreturn_info(lo);
 	pnfs_free_returned_lsegs(lo, lseg_list, &range, 0);
+	set_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags);
 	if (test_bit(NFS_LAYOUT_RETURN, &lo->plh_flags) &&
 	    !test_and_set_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags))
 		pnfs_clear_layoutreturn_waitbit(lo);
@@ -1917,8 +1918,9 @@ static void nfs_layoutget_begin(struct pnfs_layout_hdr *lo)
 
 static void nfs_layoutget_end(struct pnfs_layout_hdr *lo)
 {
-	if (atomic_dec_and_test(&lo->plh_outstanding))
-		wake_up_var(&lo->plh_outstanding);
+	if (atomic_dec_and_test(&lo->plh_outstanding) &&
+	    test_and_clear_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags))
+		wake_up_bit(&lo->plh_flags, NFS_LAYOUT_DRAIN);
 }
 
 static bool pnfs_is_first_layoutget(struct pnfs_layout_hdr *lo)
@@ -2025,11 +2027,11 @@ pnfs_update_layout(struct inode *ino,
 	 * If the layout segment list is empty, but there are outstanding
 	 * layoutget calls, then they might be subject to a layoutrecall.
 	 */
-	if ((list_empty(&lo->plh_segs) || !pnfs_layout_is_valid(lo)) &&
+	if (test_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags) &&
 	    atomic_read(&lo->plh_outstanding) != 0) {
 		spin_unlock(&ino->i_lock);
-		lseg = ERR_PTR(wait_var_event_killable(&lo->plh_outstanding,
-					!atomic_read(&lo->plh_outstanding)));
+		lseg = ERR_PTR(wait_on_bit(&lo->plh_flags, NFS_LAYOUT_DRAIN,
+					   TASK_KILLABLE));
 		if (IS_ERR(lseg))
 			goto out_put_layout_hdr;
 		pnfs_put_layout_hdr(lo);
@@ -2152,6 +2154,12 @@ pnfs_update_layout(struct inode *ino,
 		case -ERECALLCONFLICT:
 		case -EAGAIN:
 			break;
+		case -ENODATA:
+			/* The server returned NFS4ERR_LAYOUTUNAVAILABLE */
+			pnfs_layout_set_fail_bit(
+				lo, pnfs_iomode_to_fail_bit(iomode));
+			lseg = NULL;
+			goto out_put_layout_hdr;
 		default:
 			if (!nfs_error_is_fatal(PTR_ERR(lseg))) {
 				pnfs_layout_clear_fail_bit(lo, pnfs_iomode_to_fail_bit(iomode));
@@ -2407,7 +2415,8 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 		goto out_forget;
 	}
 
-	if (!pnfs_layout_is_valid(lo) && !pnfs_is_first_layoutget(lo))
+	if (test_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags) &&
+	    !pnfs_is_first_layoutget(lo))
 		goto out_forget;
 
 	if (nfs4_stateid_match_other(&lo->plh_stateid, &res->stateid)) {
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 07f11489e4e9..f331f067691b 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -105,6 +105,7 @@ enum {
 	NFS_LAYOUT_FIRST_LAYOUTGET,	/* Serialize first layoutget */
 	NFS_LAYOUT_INODE_FREEING,	/* The inode is being freed */
 	NFS_LAYOUT_HASHED,		/* The layout visible */
+	NFS_LAYOUT_DRAIN,
 };
 
 enum layoutdriver_policy_flags {
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a74aef99bd3d..09d1307959d0 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -79,6 +79,7 @@
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/blkdev.h>
+#include <linux/sched/mm.h>
 #include "../internal.h" /* ugh */
 
 #include <linux/uaccess.h>
@@ -425,9 +426,11 @@ EXPORT_SYMBOL(mark_info_dirty);
 int dquot_acquire(struct dquot *dquot)
 {
 	int ret = 0, ret2 = 0;
+	unsigned int memalloc;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dquot->dq_lock);
+	memalloc = memalloc_nofs_save();
 	if (!test_bit(DQ_READ_B, &dquot->dq_flags)) {
 		ret = dqopt->ops[dquot->dq_id.type]->read_dqblk(dquot);
 		if (ret < 0)
@@ -458,6 +461,7 @@ int dquot_acquire(struct dquot *dquot)
 	smp_mb__before_atomic();
 	set_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_iolock:
+	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
@@ -469,9 +473,11 @@ EXPORT_SYMBOL(dquot_acquire);
 int dquot_commit(struct dquot *dquot)
 {
 	int ret = 0;
+	unsigned int memalloc;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dquot->dq_lock);
+	memalloc = memalloc_nofs_save();
 	if (!clear_dquot_dirty(dquot))
 		goto out_lock;
 	/* Inactive dquot can be only if there was error during read/init
@@ -481,6 +487,7 @@ int dquot_commit(struct dquot *dquot)
 	else
 		ret = -EIO;
 out_lock:
+	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
@@ -492,9 +499,11 @@ EXPORT_SYMBOL(dquot_commit);
 int dquot_release(struct dquot *dquot)
 {
 	int ret = 0, ret2 = 0;
+	unsigned int memalloc;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dquot->dq_lock);
+	memalloc = memalloc_nofs_save();
 	/* Check whether we are not racing with some other dqget() */
 	if (dquot_is_busy(dquot))
 		goto out_dqlock;
@@ -510,6 +519,7 @@ int dquot_release(struct dquot *dquot)
 	}
 	clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_dqlock:
+	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 87ce24d238f3..8c2eed1b69c1 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -121,6 +121,8 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 
 extern struct backing_dev_info noop_backing_dev_info;
 
+int bdi_init(struct backing_dev_info *bdi);
+
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @wb: bdi_writeback of interest
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index c7bf1eaf51d5..a9c6f73877ec 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -119,9 +119,10 @@ typedef void (*netfs_io_terminated_t)(void *priv, ssize_t transferred_or_error,
 				      bool was_async);
 
 /*
- * Per-inode description.  This must be directly after the inode struct.
+ * Per-inode context.  This wraps the VFS inode.
  */
-struct netfs_i_context {
+struct netfs_inode {
+	struct inode		inode;		/* The VFS inode */
 	const struct netfs_request_ops *ops;
 #if IS_ENABLED(CONFIG_FSCACHE)
 	struct fscache_cookie	*cache;
@@ -255,7 +256,7 @@ struct netfs_cache_ops {
 	 * boundary as appropriate.
 	 */
 	enum netfs_io_source (*prepare_read)(struct netfs_io_subrequest *subreq,
-					       loff_t i_size);
+					     loff_t i_size);
 
 	/* Prepare a write operation, working out what part of the write we can
 	 * actually do.
@@ -287,45 +288,35 @@ extern void netfs_put_subrequest(struct netfs_io_subrequest *subreq,
 extern void netfs_stats_show(struct seq_file *);
 
 /**
- * netfs_i_context - Get the netfs inode context from the inode
+ * netfs_inode - Get the netfs inode context from the inode
  * @inode: The inode to query
  *
  * Get the netfs lib inode context from the network filesystem's inode.  The
  * context struct is expected to directly follow on from the VFS inode struct.
  */
-static inline struct netfs_i_context *netfs_i_context(struct inode *inode)
+static inline struct netfs_inode *netfs_inode(struct inode *inode)
 {
-	return (struct netfs_i_context *)(inode + 1);
+	return container_of(inode, struct netfs_inode, inode);
 }
 
 /**
- * netfs_inode - Get the netfs inode from the inode context
- * @ctx: The context to query
- *
- * Get the netfs inode from the netfs library's inode context.  The VFS inode
- * is expected to directly precede the context struct.
- */
-static inline struct inode *netfs_inode(struct netfs_i_context *ctx)
-{
-	return ((struct inode *)ctx) - 1;
-}
-
-/**
- * netfs_i_context_init - Initialise a netfs lib context
+ * netfs_inode_init - Initialise a netfslib inode context
  * @inode: The inode with which the context is associated
  * @ops: The netfs's operations list
  *
  * Initialise the netfs library context struct.  This is expected to follow on
  * directly from the VFS inode struct.
  */
-static inline void netfs_i_context_init(struct inode *inode,
-					const struct netfs_request_ops *ops)
+static inline void netfs_inode_init(struct inode *inode,
+				    const struct netfs_request_ops *ops)
 {
-	struct netfs_i_context *ctx = netfs_i_context(inode);
+	struct netfs_inode *ctx = netfs_inode(inode);
 
-	memset(ctx, 0, sizeof(*ctx));
 	ctx->ops = ops;
 	ctx->remote_i_size = i_size_read(inode);
+#if IS_ENABLED(CONFIG_FSCACHE)
+	ctx->cache = NULL;
+#endif
 }
 
 /**
@@ -337,7 +328,7 @@ static inline void netfs_i_context_init(struct inode *inode,
  */
 static inline void netfs_resize_file(struct inode *inode, loff_t new_i_size)
 {
-	struct netfs_i_context *ctx = netfs_i_context(inode);
+	struct netfs_inode *ctx = netfs_inode(inode);
 
 	ctx->remote_i_size = new_i_size;
 }
@@ -351,7 +342,7 @@ static inline void netfs_resize_file(struct inode *inode, loff_t new_i_size)
 static inline struct fscache_cookie *netfs_i_cookie(struct inode *inode)
 {
 #if IS_ENABLED(CONFIG_FSCACHE)
-	struct netfs_i_context *ctx = netfs_i_context(inode);
+	struct netfs_inode *ctx = netfs_inode(inode);
 	return ctx->cache;
 #else
 	return NULL;
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 586d35720f13..c81ea2264ad8 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -141,6 +141,12 @@ struct unwind_hint {
 	.popsection
 .endm
 
+.macro STACK_FRAME_NON_STANDARD_FP func:req
+#ifdef CONFIG_FRAME_POINTER
+	STACK_FRAME_NON_STANDARD \func
+#endif
+.endm
+
 .macro ANNOTATE_NOENDBR
 .Lhere_\@:
 	.pushsection .discard.noendbr
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3a30cae8b0a5..2394441fa3dd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3836,8 +3836,7 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
 struct sk_buff *__skb_recv_datagram(struct sock *sk,
 				    struct sk_buff_head *sk_queue,
 				    unsigned int flags, int *off, int *err);
-struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned flags, int noblock,
-				  int *err);
+struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags, int *err);
 __poll_t datagram_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait);
 int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 213612f1680c..023435ce1606 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1019,7 +1019,7 @@ int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr);
 int ip6_append_data(struct sock *sk,
 		    int getfrag(void *from, char *to, int offset, int len,
 				int odd, struct sk_buff *skb),
-		    void *from, int length, int transhdrlen,
+		    void *from, size_t length, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 		    struct rt6_info *rt, unsigned int flags);
 
@@ -1035,7 +1035,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk, struct sk_buff_head *queue,
 struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     struct ipcm6_cookie *ipc6,
 			     struct rt6_info *rt, unsigned int flags,
 			     struct inet_cork_full *cork);
diff --git a/init/Kconfig b/init/Kconfig
index b19e2eeaae80..fa63cc019ebf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -899,6 +899,15 @@ config CC_IMPLICIT_FALLTHROUGH
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
 	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
 
+# Currently, disable gcc-12 array-bounds globally.
+# We may want to target only particular configurations some day.
+config GCC12_NO_ARRAY_BOUNDS
+	def_bool y
+
+config CC_NO_ARRAY_BOUNDS
+	bool
+	default y if CC_IS_GCC && GCC_VERSION >= 120000 && GCC_VERSION < 130000 && GCC12_NO_ARRAY_BOUNDS
+
 #
 # For architectures that know their GCC __int128 support is sound
 #
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f3a2abd6d1a1..3a8c9d744800 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1014,10 +1014,10 @@ static void audit_reset_context(struct audit_context *ctx)
 	ctx->target_comm[0] = '\0';
 	unroll_tree_refs(ctx, NULL, 0);
 	WARN_ON(!list_empty(&ctx->killed_trees));
-	ctx->type = 0;
 	audit_free_module(ctx);
 	ctx->fds[0] = -1;
 	audit_proctitle_free(ctx);
+	ctx->type = 0; /* reset last for audit_free_*() */
 }
 
 static inline struct audit_context *audit_alloc_context(enum audit_state state)
diff --git a/kernel/cfi.c b/kernel/cfi.c
index 9594cfd1cf2c..08102d19ec15 100644
--- a/kernel/cfi.c
+++ b/kernel/cfi.c
@@ -281,6 +281,8 @@ static inline cfi_check_fn find_module_check_fn(unsigned long ptr)
 static inline cfi_check_fn find_check_fn(unsigned long ptr)
 {
 	cfi_check_fn fn = NULL;
+	unsigned long flags;
+	bool rcu_idle;
 
 	if (is_kernel_text(ptr))
 		return __cfi_check;
@@ -290,13 +292,21 @@ static inline cfi_check_fn find_check_fn(unsigned long ptr)
 	 * the shadow and __module_address use RCU, so we need to wake it
 	 * up if necessary.
 	 */
-	RCU_NONIDLE({
-		if (IS_ENABLED(CONFIG_CFI_CLANG_SHADOW))
-			fn = find_shadow_check_fn(ptr);
+	rcu_idle = !rcu_is_watching();
+	if (rcu_idle) {
+		local_irq_save(flags);
+		rcu_irq_enter();
+	}
+
+	if (IS_ENABLED(CONFIG_CFI_CLANG_SHADOW))
+		fn = find_shadow_check_fn(ptr);
+	if (!fn)
+		fn = find_module_check_fn(ptr);
 
-		if (!fn)
-			fn = find_module_check_fn(ptr);
-	});
+	if (rcu_idle) {
+		rcu_irq_exit();
+		local_irq_restore(flags);
+	}
 
 	return fn;
 }
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index ac740630c79c..2caafd13f8aa 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -564,7 +564,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 
 	rc = active_cacheline_insert(entry);
 	if (rc == -ENOMEM) {
-		pr_err("cacheline tracking ENOMEM, dma-debug disabled\n");
+		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)) {
 		err_printk(entry->dev, entry,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e58d894df207..dd11daa7a84b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4755,25 +4755,55 @@ static void do_balance_callbacks(struct rq *rq, struct callback_head *head)
 
 static void balance_push(struct rq *rq);
 
+/*
+ * balance_push_callback is a right abuse of the callback interface and plays
+ * by significantly different rules.
+ *
+ * Where the normal balance_callback's purpose is to be ran in the same context
+ * that queued it (only later, when it's safe to drop rq->lock again),
+ * balance_push_callback is specifically targeted at __schedule().
+ *
+ * This abuse is tolerated because it places all the unlikely/odd cases behind
+ * a single test, namely: rq->balance_callback == NULL.
+ */
 struct callback_head balance_push_callback = {
 	.next = NULL,
 	.func = (void (*)(struct callback_head *))balance_push,
 };
 
-static inline struct callback_head *splice_balance_callbacks(struct rq *rq)
+static inline struct callback_head *
+__splice_balance_callbacks(struct rq *rq, bool split)
 {
 	struct callback_head *head = rq->balance_callback;
 
+	if (likely(!head))
+		return NULL;
+
 	lockdep_assert_rq_held(rq);
-	if (head)
+	/*
+	 * Must not take balance_push_callback off the list when
+	 * splice_balance_callbacks() and balance_callbacks() are not
+	 * in the same rq->lock section.
+	 *
+	 * In that case it would be possible for __schedule() to interleave
+	 * and observe the list empty.
+	 */
+	if (split && head == &balance_push_callback)
+		head = NULL;
+	else
 		rq->balance_callback = NULL;
 
 	return head;
 }
 
+static inline struct callback_head *splice_balance_callbacks(struct rq *rq)
+{
+	return __splice_balance_callbacks(rq, true);
+}
+
 static void __balance_callbacks(struct rq *rq)
 {
-	do_balance_callbacks(rq, splice_balance_callbacks(rq));
+	do_balance_callbacks(rq, __splice_balance_callbacks(rq, false));
 }
 
 static inline void balance_callbacks(struct rq *rq, struct callback_head *head)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0d2b6b758f32..84bba67c92dc 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1686,6 +1686,11 @@ queue_balance_callback(struct rq *rq,
 {
 	lockdep_assert_rq_held(rq);
 
+	/*
+	 * Don't (re)queue an already queued item; nor queue anything when
+	 * balance_push() is active, see the comment with
+	 * balance_push_callback.
+	 */
 	if (unlikely(head->next || rq->balance_callback == &balance_push_callback))
 		return;
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 6b58fc6813df..41d0d9657fa1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2433,7 +2433,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		return -EINVAL;
 
 	size = cnt * sizeof(*addrs);
-	addrs = kvmalloc(size, GFP_KERNEL);
+	addrs = kvmalloc_array(cnt, sizeof(*addrs), GFP_KERNEL);
 	if (!addrs)
 		return -ENOMEM;
 
@@ -2450,7 +2450,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 
 	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
 	if (ucookies) {
-		cookies = kvmalloc(size, GFP_KERNEL);
+		cookies = kvmalloc_array(cnt, sizeof(*addrs), GFP_KERNEL);
 		if (!cookies) {
 			err = -ENOMEM;
 			goto error;
diff --git a/lib/Kconfig b/lib/Kconfig
index 087e06b4cdfd..55f0bba8f8c0 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -120,6 +120,9 @@ config INDIRECT_IOMEM_FALLBACK
 
 source "lib/crypto/Kconfig"
 
+config LIB_MEMNEQ
+	bool
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index 08053df16c7c..60843ab661ba 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -251,6 +251,7 @@ obj-$(CONFIG_DIMLIB) += dim/
 obj-$(CONFIG_SIGNATURE) += digsig.o
 
 lib-$(CONFIG_CLZ_TAB) += clz_tab.o
+lib-$(CONFIG_LIB_MEMNEQ) += memneq.o
 
 obj-$(CONFIG_GENERIC_STRNCPY_FROM_USER) += strncpy_from_user.o
 obj-$(CONFIG_GENERIC_STRNLEN_USER) += strnlen_user.o
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 379a66d7f504..017cba125386 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -71,6 +71,7 @@ config CRYPTO_LIB_CURVE25519
 	tristate "Curve25519 scalar multiplication library"
 	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
+	select LIB_MEMNEQ
 	help
 	  Enable the Curve25519 library interface. This interface may be
 	  fulfilled by either the generic implementation or an arch-specific
diff --git a/lib/memneq.c b/lib/memneq.c
new file mode 100644
index 000000000000..fb11608b1ec1
--- /dev/null
+++ b/lib/memneq.c
@@ -0,0 +1,176 @@
+/*
+ * Constant-time equality testing of memory regions.
+ *
+ * Authors:
+ *
+ *   James Yonan <james@openvpn.net>
+ *   Daniel Borkmann <dborkman@redhat.com>
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of OpenVPN Technologies nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <crypto/algapi.h>
+#include <asm/unaligned.h>
+
+#ifndef __HAVE_ARCH_CRYPTO_MEMNEQ
+
+/* Generic path for arbitrary size */
+static inline unsigned long
+__crypto_memneq_generic(const void *a, const void *b, size_t size)
+{
+	unsigned long neq = 0;
+
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	while (size >= sizeof(unsigned long)) {
+		neq |= get_unaligned((unsigned long *)a) ^
+		       get_unaligned((unsigned long *)b);
+		OPTIMIZER_HIDE_VAR(neq);
+		a += sizeof(unsigned long);
+		b += sizeof(unsigned long);
+		size -= sizeof(unsigned long);
+	}
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+	while (size > 0) {
+		neq |= *(unsigned char *)a ^ *(unsigned char *)b;
+		OPTIMIZER_HIDE_VAR(neq);
+		a += 1;
+		b += 1;
+		size -= 1;
+	}
+	return neq;
+}
+
+/* Loop-free fast-path for frequently used 16-byte size */
+static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
+{
+	unsigned long neq = 0;
+
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (sizeof(unsigned long) == 8) {
+		neq |= get_unaligned((unsigned long *)a) ^
+		       get_unaligned((unsigned long *)b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= get_unaligned((unsigned long *)(a + 8)) ^
+		       get_unaligned((unsigned long *)(b + 8));
+		OPTIMIZER_HIDE_VAR(neq);
+	} else if (sizeof(unsigned int) == 4) {
+		neq |= get_unaligned((unsigned int *)a) ^
+		       get_unaligned((unsigned int *)b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= get_unaligned((unsigned int *)(a + 4)) ^
+		       get_unaligned((unsigned int *)(b + 4));
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= get_unaligned((unsigned int *)(a + 8)) ^
+		       get_unaligned((unsigned int *)(b + 8));
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= get_unaligned((unsigned int *)(a + 12)) ^
+		       get_unaligned((unsigned int *)(b + 12));
+		OPTIMIZER_HIDE_VAR(neq);
+	} else
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+	{
+		neq |= *(unsigned char *)(a)    ^ *(unsigned char *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+10) ^ *(unsigned char *)(b+10);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+11) ^ *(unsigned char *)(b+11);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+12) ^ *(unsigned char *)(b+12);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+13) ^ *(unsigned char *)(b+13);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+14) ^ *(unsigned char *)(b+14);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+15) ^ *(unsigned char *)(b+15);
+		OPTIMIZER_HIDE_VAR(neq);
+	}
+
+	return neq;
+}
+
+/* Compare two areas of memory without leaking timing information,
+ * and with special optimizations for common sizes.  Users should
+ * not call this function directly, but should instead use
+ * crypto_memneq defined in crypto/algapi.h.
+ */
+noinline unsigned long __crypto_memneq(const void *a, const void *b,
+				       size_t size)
+{
+	switch (size) {
+	case 16:
+		return __crypto_memneq_16(a, b);
+	default:
+		return __crypto_memneq_generic(a, b, size);
+	}
+}
+EXPORT_SYMBOL(__crypto_memneq);
+
+#endif /* __HAVE_ARCH_CRYPTO_MEMNEQ */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7176af65b103..e262739a0a23 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -230,20 +230,13 @@ static __init int bdi_class_init(void)
 }
 postcore_initcall(bdi_class_init);
 
-static int bdi_init(struct backing_dev_info *bdi);
-
 static int __init default_bdi_init(void)
 {
-	int err;
-
 	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_UNBOUND |
 				 WQ_SYSFS, 0);
 	if (!bdi_wq)
 		return -ENOMEM;
-
-	err = bdi_init(&noop_backing_dev_info);
-
-	return err;
+	return 0;
 }
 subsys_initcall(default_bdi_init);
 
@@ -782,7 +775,7 @@ static void cgwb_remove_from_bdi_list(struct bdi_writeback *wb)
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
-static int bdi_init(struct backing_dev_info *bdi)
+int bdi_init(struct backing_dev_info *bdi)
 {
 	int ret;
 
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index bf5736c1d458..a06f4d4a6f47 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1753,8 +1753,7 @@ static int atalk_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	int err = 0;
 	struct sk_buff *skb;
 
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-						flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	lock_sock(sk);
 
 	if (!skb)
diff --git a/net/atm/common.c b/net/atm/common.c
index 1cfa9bf1d187..d0c8ab7ff8f6 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -540,7 +540,7 @@ int vcc_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	    !test_bit(ATM_VF_READY, &vcc->flags))
 		return 0;
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &error);
+	skb = skb_recv_datagram(sk, flags, &error);
 	if (!skb)
 		return error;
 
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 289f355e1853..4c7030ed8d33 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1661,9 +1661,12 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags)
 {
 	struct sock *sk = sock->sk;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *last;
+	struct sk_buff_head *sk_queue;
 	int copied;
 	int err = 0;
+	int off = 0;
+	long timeo;
 
 	lock_sock(sk);
 	/*
@@ -1675,11 +1678,29 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		goto out;
 	}
 
-	/* Now we can treat all alike */
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &err);
-	if (skb == NULL)
-		goto out;
+	/*  We need support for non-blocking reads. */
+	sk_queue = &sk->sk_receive_queue;
+	skb = __skb_try_recv_datagram(sk, sk_queue, flags, &off, &err, &last);
+	/* If no packet is available, release_sock(sk) and try again. */
+	if (!skb) {
+		if (err != -EAGAIN)
+			goto out;
+		release_sock(sk);
+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+		while (timeo && !__skb_wait_for_more_packets(sk, sk_queue, &err,
+							     &timeo, last)) {
+			skb = __skb_try_recv_datagram(sk, sk_queue, flags, &off,
+						      &err, &last);
+			if (skb)
+				break;
+
+			if (err != -EAGAIN)
+				goto done;
+		}
+		if (!skb)
+			goto done;
+		lock_sock(sk);
+	}
 
 	if (!sk_to_ax25(sk)->pidincl)
 		skb_pull(skb, 1);		/* Remove PID */
@@ -1726,6 +1747,7 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 out:
 	release_sock(sk);
 
+done:
 	return err;
 }
 
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index a0cb2e3da8d4..62705734343b 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -251,7 +251,6 @@ EXPORT_SYMBOL(bt_accept_dequeue);
 int bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		    int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	size_t copied;
@@ -263,7 +262,7 @@ int bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return 0;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 33b3c0ffc339..189e3115c8c6 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1453,7 +1453,6 @@ static void hci_sock_cmsg(struct sock *sk, struct msghdr *msg,
 static int hci_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 			    size_t len, int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int copied, err;
@@ -1470,7 +1469,7 @@ static int hci_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (sk->sk_state == BT_CLOSED)
 		return 0;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		return err;
 
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 2b8892d502f7..251e666ba9a2 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -282,7 +282,7 @@ static int caif_seqpkt_recvmsg(struct socket *sock, struct msghdr *m,
 	if (flags & MSG_OOB)
 		goto read_error;
 
-	skb = skb_recv_datagram(sk, flags, 0 , &ret);
+	skb = skb_recv_datagram(sk, flags, &ret);
 	if (!skb)
 		goto read_error;
 	copylen = skb->len;
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 95d209b52e6a..64c07e650bb4 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1632,12 +1632,9 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int error = 0;
-	int noblock;
 	int err;
 
-	noblock =  flags & MSG_DONTWAIT;
-	flags   &= ~MSG_DONTWAIT;
-	skb = skb_recv_datagram(sk, flags, noblock, &error);
+	skb = skb_recv_datagram(sk, flags, &error);
 	if (!skb)
 		return error;
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 1e7c6a460ef9..35a1ae61744c 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1055,7 +1055,6 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	struct isotp_sock *so = isotp_sk(sk);
-	int noblock = flags & MSG_DONTWAIT;
 	int ret = 0;
 
 	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
@@ -1064,8 +1063,7 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	if (!so->bound)
 		return -EADDRNOTAVAIL;
 
-	flags &= ~MSG_DONTWAIT;
-	skb = skb_recv_datagram(sk, flags, noblock, &ret);
+	skb = skb_recv_datagram(sk, flags, &ret);
 	if (!skb)
 		return ret;
 
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 6dff4510687a..0bb4fd3f6264 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -802,7 +802,7 @@ static int j1939_sk_recvmsg(struct socket *sock, struct msghdr *msg,
 		return sock_recv_errqueue(sock->sk, msg, size, SOL_CAN_J1939,
 					  SCM_J1939_ERRQUEUE);
 
-	skb = skb_recv_datagram(sk, flags, 0, &ret);
+	skb = skb_recv_datagram(sk, flags, &ret);
 	if (!skb)
 		return ret;
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 7105fa4824e4..0cf728dcff36 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -846,16 +846,12 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int err = 0;
-	int noblock;
-
-	noblock = flags & MSG_DONTWAIT;
-	flags &= ~MSG_DONTWAIT;
 
 	if (flags & MSG_ERRQUEUE)
 		return sock_recv_errqueue(sk, msg, size,
 					  SOL_CAN_RAW, SCM_CAN_RAW_ERRQUEUE);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		return err;
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index ee290776c661..70126d15ca6e 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -310,12 +310,11 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk,
 EXPORT_SYMBOL(__skb_recv_datagram);
 
 struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags,
-				  int noblock, int *err)
+				  int *err)
 {
 	int off = 0;
 
-	return __skb_recv_datagram(sk, &sk->sk_receive_queue,
-				   flags | (noblock ? MSG_DONTWAIT : 0),
+	return __skb_recv_datagram(sk, &sk->sk_receive_queue, flags,
 				   &off, err);
 }
 EXPORT_SYMBOL(skb_recv_datagram);
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 3b2366a88c3c..a725dd9bbda8 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -314,7 +314,8 @@ static int raw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	int err = -EOPNOTSUPP;
 	struct sk_buff *skb;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
@@ -703,7 +704,8 @@ static int dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	struct dgram_sock *ro = dgram_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_ieee802154 *, saddr, msg->msg_name);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index aa9a11b20d18..4e5ceca7ff7f 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -871,7 +871,8 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	if (flags & MSG_ERRQUEUE)
 		return inet_recv_error(sk, msg, len, addr_len);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 9f97b9cbf7b3..c9dd9603f2e7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -769,7 +769,8 @@ static int raw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		goto out;
 	}
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index fa63ef2bd99c..87067e0ddaa3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1428,7 +1428,7 @@ static int __ip6_append_data(struct sock *sk,
 			     struct page_frag *pfrag,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
@@ -1776,7 +1776,7 @@ static int __ip6_append_data(struct sock *sk,
 int ip6_append_data(struct sock *sk,
 		    int getfrag(void *from, char *to, int offset, int len,
 				int odd, struct sk_buff *skb),
-		    void *from, int length, int transhdrlen,
+		    void *from, size_t length, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 		    struct rt6_info *rt, unsigned int flags)
 {
@@ -1973,7 +1973,7 @@ EXPORT_SYMBOL_GPL(ip6_flush_pending_frames);
 struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     struct ipcm6_cookie *ipc6, struct rt6_info *rt,
 			     unsigned int flags, struct inet_cork_full *cork)
 {
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index c51d5ce3711c..8bb41f3b246a 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -477,7 +477,8 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index a1760add5bf1..a0385ddbffcf 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1223,7 +1223,6 @@ static void iucv_process_message_q(struct sock *sk)
 static int iucv_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 			     size_t len, int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
 	unsigned int copied, rlen;
@@ -1242,7 +1241,7 @@ static int iucv_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* receive/dequeue next skb:
 	 * the function understands MSG_PEEK and, thus, does not dequeue skb */
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return 0;
diff --git a/net/key/af_key.c b/net/key/af_key.c
index d93bde657359..c249b84efbb2 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3700,7 +3700,7 @@ static int pfkey_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT))
 		goto out;
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (skb == NULL)
 		goto out;
 
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index b3edafa5fba4..c6a5cc2d88e7 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -526,7 +526,8 @@ static int l2tp_ip_recvmsg(struct sock *sk, struct msghdr *msg,
 	if (flags & MSG_OOB)
 		goto out;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 96f975777438..8f76e647adbb 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -502,14 +502,15 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
 	int transhdrlen = 4; /* zero session-id */
-	int ulen = len + transhdrlen;
+	int ulen;
 	int err;
 
 	/* Rough check on arithmetic overflow,
 	 * better check is made in ip6_append_data().
 	 */
-	if (len > INT_MAX)
+	if (len > INT_MAX - transhdrlen)
 		return -EMSGSIZE;
+	ulen = len + transhdrlen;
 
 	/* Mirror BSD error message compatibility */
 	if (msg->msg_flags & MSG_OOB)
@@ -671,7 +672,8 @@ static int l2tp_ip6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index bf35710127dd..8be1fdc68a0b 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -191,8 +191,7 @@ static int pppol2tp_recvmsg(struct socket *sock, struct msghdr *msg,
 		goto end;
 
 	err = 0;
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto end;
 
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index e22b0cbb2f35..221863afc4b1 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -216,7 +216,7 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
 		return -EOPNOTSUPP;
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &rc);
+	skb = skb_recv_datagram(sk, flags, &rc);
 	if (!skb)
 		return rc;
 
diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index 61205cf40074..24df29e135ed 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -352,7 +352,7 @@ static void mctp_test_route_input_sk(struct kunit *test)
 	if (params->deliver) {
 		KUNIT_EXPECT_EQ(test, rc, 0);
 
-		skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+		skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
 		KUNIT_EXPECT_EQ(test, skb->len, 1);
 
@@ -360,7 +360,7 @@ static void mctp_test_route_input_sk(struct kunit *test)
 
 	} else {
 		KUNIT_EXPECT_NE(test, rc, 0);
-		skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+		skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 		KUNIT_EXPECT_PTR_EQ(test, skb2, NULL);
 	}
 
@@ -423,7 +423,7 @@ static void mctp_test_route_input_sk_reasm(struct kunit *test)
 		rc = mctp_route_input(&rt->rt, skb);
 	}
 
-	skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+	skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 
 	if (params->rx_len) {
 		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
@@ -582,7 +582,7 @@ static void mctp_test_route_input_sk_keys(struct kunit *test)
 	rc = mctp_route_input(&rt->rt, skb);
 
 	/* (potentially) receive message */
-	skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+	skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 
 	if (params->deliver)
 		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 73e9c0a9c187..0cd91f813a3b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1931,7 +1931,6 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	struct scm_cookie scm;
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
-	int noblock = flags & MSG_DONTWAIT;
 	size_t copied;
 	struct sk_buff *skb, *data_skb;
 	int err, ret;
@@ -1941,7 +1940,7 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	copied = 0;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (skb == NULL)
 		goto out;
 
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index fa9dc2ba3941..6f7f4392cffb 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1159,7 +1159,8 @@ static int nr_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	}
 
 	/* Now we can treat all alike */
-	if ((skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT, flags & MSG_DONTWAIT, &er)) == NULL) {
+	skb = skb_recv_datagram(sk, flags, &er);
+	if (!skb) {
 		release_sock(sk);
 		return er;
 	}
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 4ca35791c93b..77642d18a3b4 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -821,7 +821,6 @@ static int llcp_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 static int llcp_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 			     size_t len, int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	unsigned int copied, rlen;
 	struct sk_buff *skb, *cskb;
@@ -842,7 +841,7 @@ static int llcp_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (flags & (MSG_OOB))
 		return -EOPNOTSUPP;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb) {
 		pr_err("Recv datagram failed state %d %d %d",
 		       sk->sk_state, err, sock_error(sk));
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 0ca214ab5aef..8dd569765f96 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -238,7 +238,6 @@ static int rawsock_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 static int rawsock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			   int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int copied;
@@ -246,7 +245,7 @@ static int rawsock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	pr_debug("sock=%p sk=%p len=%zu flags=%d\n", sock, sk, len, flags);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &rc);
+	skb = skb_recv_datagram(sk, flags, &rc);
 	if (!skb)
 		return rc;
 
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 002d2b9c69dd..243566129784 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3426,7 +3426,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	 *	but then it will block.
 	 */
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 
 	/*
 	 *	An error occurred so return it. Because skb_recv_datagram()
diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index 393e6aa7a592..3f2e62b63dd4 100644
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -123,7 +123,8 @@ static int pn_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			MSG_CMSG_COMPAT))
 		goto out_nofree;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &rval);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &rval);
 	if (skb == NULL)
 		goto out_nofree;
 
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 65d463ad8770..441a26706592 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -772,7 +772,8 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 	u8 pipe_handle, enabled, n_sb;
 	u8 aligned = 0;
 
-	skb = skb_recv_datagram(sk, 0, flags & O_NONBLOCK, errp);
+	skb = skb_recv_datagram(sk, (flags & O_NONBLOCK) ? MSG_DONTWAIT : 0,
+				errp);
 	if (!skb)
 		return NULL;
 
@@ -1267,7 +1268,8 @@ static int pep_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			return -EINVAL;
 	}
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	lock_sock(sk);
 	if (skb == NULL) {
 		if (err == -ENOTCONN && sk->sk_state == TCP_CLOSE_WAIT)
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index ec2322529727..5c2fb992803b 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1035,8 +1035,7 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 		return -EADDRNOTAVAIL;
 	}
 
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &rc);
+	skb = skb_recv_datagram(sk, flags, &rc);
 	if (!skb) {
 		release_sock(sk);
 		return rc;
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 30a1cf4c16c6..bf2d986a6bc3 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1230,7 +1230,8 @@ static int rose_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		return -ENOTCONN;
 
 	/* Now we can treat all alike */
-	if ((skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT, flags & MSG_DONTWAIT, &er)) == NULL)
+	skb = skb_recv_datagram(sk, flags, &er);
+	if (!skb)
 		return er;
 
 	qbit = (skb->data[0] & ROSE_Q_BIT) == ROSE_Q_BIT;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index e2c6eca0271b..b6781ada3aa8 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -651,6 +651,7 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	new->cl_discrtry = clnt->cl_discrtry;
 	new->cl_chatty = clnt->cl_chatty;
 	new->cl_principal = clnt->cl_principal;
+	new->cl_max_connect = clnt->cl_max_connect;
 	return new;
 
 out_err:
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4aed12e94221..6114d69b8a2d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1643,7 +1643,8 @@ static int unix_accept(struct socket *sock, struct socket *newsock, int flags,
 	 * so that no locks are necessary.
 	 */
 
-	skb = skb_recv_datagram(sk, 0, flags&O_NONBLOCK, &err);
+	skb = skb_recv_datagram(sk, (flags & O_NONBLOCK) ? MSG_DONTWAIT : 0,
+				&err);
 	if (!skb) {
 		/* This means receive shutdown. */
 		if (err == 0)
@@ -2500,7 +2501,7 @@ static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 		int used, err;
 
 		mutex_lock(&u->iolock);
-		skb = skb_recv_datagram(sk, 0, 1, &err);
+		skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
 		mutex_unlock(&u->iolock);
 		if (!skb)
 			return err;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b17dc9745188..b14f0ed7427b 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1732,19 +1732,16 @@ static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
 					int flags)
 {
 	int err;
-	int noblock;
 	struct vmci_datagram *dg;
 	size_t payload_len;
 	struct sk_buff *skb;
 
-	noblock = flags & MSG_DONTWAIT;
-
 	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
 		return -EOPNOTSUPP;
 
 	/* Retrieve the head sk_buff from the socket's receive queue. */
 	err = 0;
-	skb = skb_recv_datagram(&vsk->sk, flags, noblock, &err);
+	skb = skb_recv_datagram(&vsk->sk, flags, &err);
 	if (!skb)
 		return err;
 
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 3a171828638b..6bc2ac8d8146 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1315,8 +1315,7 @@ static int x25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	} else {
 		/* Now we can treat all alike */
 		release_sock(sk);
-		skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-					flags & MSG_DONTWAIT, &rc);
+		skb = skb_recv_datagram(sk, flags, &rc);
 		lock_sock(sk);
 		if (!skb)
 			goto out;
diff --git a/scripts/faddr2line b/scripts/faddr2line
index 0e6268d59883..94ed98dd899f 100755
--- a/scripts/faddr2line
+++ b/scripts/faddr2line
@@ -95,17 +95,25 @@ __faddr2line() {
 	local print_warnings=$4
 
 	local sym_name=${func_addr%+*}
-	local offset=${func_addr#*+}
-	offset=${offset%/*}
+	local func_offset=${func_addr#*+}
+	func_offset=${func_offset%/*}
 	local user_size=
+	local file_type
+	local is_vmlinux=0
 	[[ $func_addr =~ "/" ]] && user_size=${func_addr#*/}
 
-	if [[ -z $sym_name ]] || [[ -z $offset ]] || [[ $sym_name = $func_addr ]]; then
+	if [[ -z $sym_name ]] || [[ -z $func_offset ]] || [[ $sym_name = $func_addr ]]; then
 		warn "bad func+offset $func_addr"
 		DONE=1
 		return
 	fi
 
+	# vmlinux uses absolute addresses in the section table rather than
+	# section offsets.
+	local file_type=$(${READELF} --file-header $objfile |
+		${AWK} '$1 == "Type:" { print $2; exit }')
+	[[ $file_type = "EXEC" ]] && is_vmlinux=1
+
 	# Go through each of the object's symbols which match the func name.
 	# In rare cases there might be duplicates, in which case we print all
 	# matches.
@@ -114,9 +122,11 @@ __faddr2line() {
 		local sym_addr=0x${fields[1]}
 		local sym_elf_size=${fields[2]}
 		local sym_sec=${fields[6]}
+		local sec_size
+		local sec_name
 
 		# Get the section size:
-		local sec_size=$(${READELF} --section-headers --wide $objfile |
+		sec_size=$(${READELF} --section-headers --wide $objfile |
 			sed 's/\[ /\[/' |
 			${AWK} -v sec=$sym_sec '$1 == "[" sec "]" { print "0x" $6; exit }')
 
@@ -126,6 +136,17 @@ __faddr2line() {
 			return
 		fi
 
+		# Get the section name:
+		sec_name=$(${READELF} --section-headers --wide $objfile |
+			sed 's/\[ /\[/' |
+			${AWK} -v sec=$sym_sec '$1 == "[" sec "]" { print $2; exit }')
+
+		if [[ -z $sec_name ]]; then
+			warn "bad section name: section: $sym_sec"
+			DONE=1
+			return
+		fi
+
 		# Calculate the symbol size.
 		#
 		# Unfortunately we can't use the ELF size, because kallsyms
@@ -174,10 +195,10 @@ __faddr2line() {
 
 		sym_size=0x$(printf %x $sym_size)
 
-		# Calculate the section address from user-supplied offset:
-		local addr=$(($sym_addr + $offset))
+		# Calculate the address from user-supplied offset:
+		local addr=$(($sym_addr + $func_offset))
 		if [[ -z $addr ]] || [[ $addr = 0 ]]; then
-			warn "bad address: $sym_addr + $offset"
+			warn "bad address: $sym_addr + $func_offset"
 			DONE=1
 			return
 		fi
@@ -191,9 +212,9 @@ __faddr2line() {
 		fi
 
 		# Make sure the provided offset is within the symbol's range:
-		if [[ $offset -gt $sym_size ]]; then
+		if [[ $func_offset -gt $sym_size ]]; then
 			[[ $print_warnings = 1 ]] &&
-				echo "skipping $sym_name address at $addr due to size mismatch ($offset > $sym_size)"
+				echo "skipping $sym_name address at $addr due to size mismatch ($func_offset > $sym_size)"
 			continue
 		fi
 
@@ -202,11 +223,13 @@ __faddr2line() {
 		[[ $FIRST = 0 ]] && echo
 		FIRST=0
 
-		echo "$sym_name+$offset/$sym_size:"
+		echo "$sym_name+$func_offset/$sym_size:"
 
 		# Pass section address to addr2line and strip absolute paths
 		# from the output:
-		local output=$(${ADDR2LINE} -fpie $objfile $addr | sed "s; $dir_prefix\(\./\)*; ;")
+		local args="--functions --pretty-print --inlines --exe=$objfile"
+		[[ $is_vmlinux = 0 ]] && args="$args --section=$sec_name"
+		local output=$(${ADDR2LINE} $args $addr | sed "s; $dir_prefix\(\./\)*; ;")
 		[[ -z $output ]] && continue
 
 		# Default output (non --list):
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e9e959343de9..cac9368be4ce 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2600,8 +2600,9 @@ static int selinux_sb_eat_lsm_opts(char *options, void **mnt_opts)
 				}
 			}
 			rc = selinux_add_opt(token, arg, mnt_opts);
+			kfree(arg);
+			arg = NULL;
 			if (unlikely(rc)) {
-				kfree(arg);
 				goto free_opt;
 			}
 		} else {
@@ -2792,17 +2793,13 @@ static int selinux_fs_context_parse_param(struct fs_context *fc,
 					  struct fs_parameter *param)
 {
 	struct fs_parse_result result;
-	int opt, rc;
+	int opt;
 
 	opt = fs_parse(fc, selinux_fs_parameters, param, &result);
 	if (opt < 0)
 		return opt;
 
-	rc = selinux_add_opt(opt, param->string, &fc->security);
-	if (!rc)
-		param->string = NULL;
-
-	return rc;
+	return selinux_add_opt(opt, param->string, &fc->security);
 }
 
 /* inode security operations */
diff --git a/sound/hda/hdac_device.c b/sound/hda/hdac_device.c
index 3e9e9ac804f6..b7e5032b61c9 100644
--- a/sound/hda/hdac_device.c
+++ b/sound/hda/hdac_device.c
@@ -660,6 +660,7 @@ static const struct hda_vendor_id hda_vendor_ids[] = {
 	{ 0x14f1, "Conexant" },
 	{ 0x17e8, "Chrontel" },
 	{ 0x1854, "LG" },
+	{ 0x19e5, "Huawei" },
 	{ 0x1aec, "Wolfson Microelectronics" },
 	{ 0x1af4, "QEMU" },
 	{ 0x434d, "C-Media" },
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 0a83eb6b88b1..a77165bd92a9 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2525,6 +2525,9 @@ static const struct pci_device_id azx_ids[] = {
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	{ PCI_DEVICE(0x8086, 0x51cf),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* Meteorlake-P */
+	{ PCI_DEVICE(0x8086, 0x7e28),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Broxton-P(Apollolake) */
 	{ PCI_DEVICE(0x8086, 0x5a98),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_BROXTON },
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 31fe41795571..6c209cd26c0c 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4554,6 +4554,7 @@ HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281b, "Elkhartlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_adlp_hdmi),
 HDA_CODEC_ENTRY(0x8086281f, "Raptorlake-P HDMI",	patch_i915_adlp_hdmi),
+HDA_CODEC_ENTRY(0x8086281d, "Meteorlake HDMI",	patch_i915_adlp_hdmi),
 HDA_CODEC_ENTRY(0x80862880, "CedarTrail HDMI",	patch_generic_hdmi),
 HDA_CODEC_ENTRY(0x80862882, "Valleyview2 HDMI",	patch_i915_byt_hdmi),
 HDA_CODEC_ENTRY(0x80862883, "Braswell HDMI",	patch_i915_byt_hdmi),
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8d2d29880716..588d4a59c8d9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -443,6 +443,7 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0245:
 	case 0x10ec0255:
 	case 0x10ec0256:
+	case 0x19e58326:
 	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
@@ -580,6 +581,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0286:
 	case 0x10ec0288:
@@ -3247,6 +3249,7 @@ static void alc_disable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x48, 0x0);
 		alc_update_coef_idx(codec, 0x49, 0x0045, 0x0);
 		break;
@@ -3275,6 +3278,7 @@ static void alc_enable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x48, 0xd011);
 		alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
 		break;
@@ -4910,6 +4914,7 @@ static void alc_headset_mode_unplugged(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5025,6 +5030,7 @@ static void alc_headset_mode_mic_in(struct hda_codec *codec, hda_nid_t hp_pin,
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
 		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
 		alc_process_coef_fw(codec, coef0256);
@@ -5175,6 +5181,7 @@ static void alc_headset_mode_default(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
 		alc_write_coef_idx(codec, 0x45, 0xc089);
 		msleep(50);
@@ -5274,6 +5281,7 @@ static void alc_headset_mode_ctia(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5388,6 +5396,7 @@ static void alc_headset_mode_omtp(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5489,6 +5498,7 @@ static void alc_determine_headset_type(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
 		alc_write_coef_idx(codec, 0x06, 0x6104);
 		alc_write_coefex_idx(codec, 0x57, 0x3, 0x09a3);
@@ -5783,6 +5793,7 @@ static void alc255_set_default_jack_type(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, alc256fw);
 		break;
 	}
@@ -6385,6 +6396,7 @@ static void alc_combo_jack_hp_jd_restart(struct hda_codec *codec)
 	case 0x10ec0236:
 	case 0x10ec0255:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_update_coef_idx(codec, 0x1b, 0x8000, 1 << 15); /* Reset HP JD */
 		alc_update_coef_idx(codec, 0x1b, 0x8000, 0 << 15);
 		break;
@@ -10149,6 +10161,7 @@ static int patch_alc269(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		spec->codec_variant = ALC269_TYPE_ALC256;
 		spec->shutup = alc256_shutup;
 		spec->init_hook = alc256_init;
@@ -11599,6 +11612,7 @@ static const struct hda_device_id snd_hda_id_realtek[] = {
 	HDA_CODEC_ENTRY(0x10ec0b00, "ALCS1200A", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1168, "ALC1220", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1220, "ALC1220", patch_alc882),
+	HDA_CODEC_ENTRY(0x19e58326, "HW8326", patch_alc269),
 	{} /* terminator */
 };
 MODULE_DEVICE_TABLE(hdaudio, snd_hda_id_realtek);
diff --git a/sound/soc/codecs/cs35l36.c b/sound/soc/codecs/cs35l36.c
index d83c1b318c1c..0accdb45ed72 100644
--- a/sound/soc/codecs/cs35l36.c
+++ b/sound/soc/codecs/cs35l36.c
@@ -444,7 +444,8 @@ static bool cs35l36_volatile_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static DECLARE_TLV_DB_SCALE(dig_vol_tlv, -10200, 25, 0);
+static const DECLARE_TLV_DB_RANGE(dig_vol_tlv, 0, 912,
+				  TLV_DB_MINMAX_ITEM(-10200, 1200));
 static DECLARE_TLV_DB_SCALE(amp_gain_tlv, 0, 1, 1);
 
 static const char * const cs35l36_pcm_sftramp_text[] =  {
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index e9c3cb4e2bfc..b9c262a15edf 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -146,7 +146,7 @@ static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 			0, 0xA0, 96, adc_att_tlv),
 	SOC_DOUBLE_R_SX_TLV("PGA Volume",
 			CS42L51_ALC_PGA_CTL, CS42L51_ALC_PGB_CTL,
-			0, 0x1A, 30, pga_tlv),
+			0, 0x19, 30, pga_tlv),
 	SOC_SINGLE("Playback Deemphasis Switch", CS42L51_DAC_CTL, 3, 1, 0),
 	SOC_SINGLE("Auto-Mute Switch", CS42L51_DAC_CTL, 2, 1, 0),
 	SOC_SINGLE("Soft Ramp Switch", CS42L51_DAC_CTL, 1, 1, 0),
diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 80161151b3f2..c19ad3c24702 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -137,7 +137,9 @@ static DECLARE_TLV_DB_SCALE(mic_tlv, 1600, 100, 0);
 
 static DECLARE_TLV_DB_SCALE(pga_tlv, -600, 50, 0);
 
-static DECLARE_TLV_DB_SCALE(mix_tlv, -50, 50, 0);
+static DECLARE_TLV_DB_SCALE(pass_tlv, -6000, 50, 0);
+
+static DECLARE_TLV_DB_SCALE(mix_tlv, -5150, 50, 0);
 
 static DECLARE_TLV_DB_SCALE(beep_tlv, -56, 200, 0);
 
@@ -351,7 +353,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 			      CS42L52_SPKB_VOL, 0, 0x40, 0xC0, hl_tlv),
 
 	SOC_DOUBLE_R_SX_TLV("Bypass Volume", CS42L52_PASSTHRUA_VOL,
-			      CS42L52_PASSTHRUB_VOL, 0, 0x88, 0x90, pga_tlv),
+			      CS42L52_PASSTHRUB_VOL, 0, 0x88, 0x90, pass_tlv),
 
 	SOC_DOUBLE("Bypass Mute", CS42L52_MISC_CTL, 4, 5, 1, 0),
 
@@ -364,7 +366,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 			      CS42L52_ADCB_VOL, 0, 0xA0, 0x78, ipd_tlv),
 	SOC_DOUBLE_R_SX_TLV("ADC Mixer Volume",
 			     CS42L52_ADCA_MIXER_VOL, CS42L52_ADCB_MIXER_VOL,
-				0, 0x19, 0x7F, ipd_tlv),
+				0, 0x19, 0x7F, mix_tlv),
 
 	SOC_DOUBLE("ADC Switch", CS42L52_ADC_MISC_CTL, 0, 1, 1, 0),
 
diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 3cf8a0b4478c..b39c25409c23 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -391,9 +391,9 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 	SOC_DOUBLE("ADC Boost Switch", CS42L56_GAIN_BIAS_CTL, 3, 2, 1, 1),
 
 	SOC_DOUBLE_R_SX_TLV("Headphone Volume", CS42L56_HPA_VOLUME,
-			      CS42L56_HPB_VOLUME, 0, 0x84, 0x48, hl_tlv),
+			      CS42L56_HPB_VOLUME, 0, 0x44, 0x48, hl_tlv),
 	SOC_DOUBLE_R_SX_TLV("LineOut Volume", CS42L56_LOA_VOLUME,
-			      CS42L56_LOB_VOLUME, 0, 0x84, 0x48, hl_tlv),
+			      CS42L56_LOB_VOLUME, 0, 0x44, 0x48, hl_tlv),
 
 	SOC_SINGLE_TLV("Bass Shelving Volume", CS42L56_TONE_CTL,
 			0, 0x00, 1, tone_tlv),
diff --git a/sound/soc/codecs/cs53l30.c b/sound/soc/codecs/cs53l30.c
index f2087bd38dbc..c2912ad3851b 100644
--- a/sound/soc/codecs/cs53l30.c
+++ b/sound/soc/codecs/cs53l30.c
@@ -348,22 +348,22 @@ static const struct snd_kcontrol_new cs53l30_snd_controls[] = {
 	SOC_ENUM("ADC2 NG Delay", adc2_ng_delay_enum),
 
 	SOC_SINGLE_SX_TLV("ADC1A PGA Volume",
-		    CS53L30_ADC1A_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC1A_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 	SOC_SINGLE_SX_TLV("ADC1B PGA Volume",
-		    CS53L30_ADC1B_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC1B_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 	SOC_SINGLE_SX_TLV("ADC2A PGA Volume",
-		    CS53L30_ADC2A_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC2A_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 	SOC_SINGLE_SX_TLV("ADC2B PGA Volume",
-		    CS53L30_ADC2B_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC2B_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 
 	SOC_SINGLE_SX_TLV("ADC1A Digital Volume",
-		    CS53L30_ADC1A_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC1A_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 	SOC_SINGLE_SX_TLV("ADC1B Digital Volume",
-		    CS53L30_ADC1B_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC1B_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 	SOC_SINGLE_SX_TLV("ADC2A Digital Volume",
-		    CS53L30_ADC2A_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC2A_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 	SOC_SINGLE_SX_TLV("ADC2B Digital Volume",
-		    CS53L30_ADC2B_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC2B_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 };
 
 static const struct snd_soc_dapm_widget cs53l30_dapm_widgets[] = {
diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index 3f00ead97006..dd53dfd87b04 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -161,13 +161,16 @@ static int es8328_put_deemph(struct snd_kcontrol *kcontrol,
 	if (deemph > 1)
 		return -EINVAL;
 
+	if (es8328->deemph == deemph)
+		return 0;
+
 	ret = es8328_set_deemph(component);
 	if (ret < 0)
 		return ret;
 
 	es8328->deemph = deemph;
 
-	return 0;
+	return 1;
 }
 
 
diff --git a/sound/soc/codecs/nau8822.c b/sound/soc/codecs/nau8822.c
index 58123390c7a3..b436e532993d 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -740,6 +740,8 @@ static int nau8822_set_pll(struct snd_soc_dai *dai, int pll_id, int source,
 		pll_param->pll_int, pll_param->pll_frac,
 		pll_param->mclk_scaler, pll_param->pre_factor);
 
+	snd_soc_component_update_bits(component,
+		NAU8822_REG_POWER_MANAGEMENT_1, NAU8822_PLL_EN_MASK, NAU8822_PLL_OFF);
 	snd_soc_component_update_bits(component,
 		NAU8822_REG_PLL_N, NAU8822_PLLMCLK_DIV2 | NAU8822_PLLN_MASK,
 		(pll_param->pre_factor ? NAU8822_PLLMCLK_DIV2 : 0) |
@@ -757,6 +759,8 @@ static int nau8822_set_pll(struct snd_soc_dai *dai, int pll_id, int source,
 		pll_param->mclk_scaler << NAU8822_MCLKSEL_SFT);
 	snd_soc_component_update_bits(component,
 		NAU8822_REG_CLOCKING, NAU8822_CLKM_MASK, NAU8822_CLKM_PLL);
+	snd_soc_component_update_bits(component,
+		NAU8822_REG_POWER_MANAGEMENT_1, NAU8822_PLL_EN_MASK, NAU8822_PLL_ON);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/nau8822.h b/sound/soc/codecs/nau8822.h
index 489191ff187e..b45d42c15de6 100644
--- a/sound/soc/codecs/nau8822.h
+++ b/sound/soc/codecs/nau8822.h
@@ -90,6 +90,9 @@
 #define NAU8822_REFIMP_3K			0x3
 #define NAU8822_IOBUF_EN			(0x1 << 2)
 #define NAU8822_ABIAS_EN			(0x1 << 3)
+#define NAU8822_PLL_EN_MASK			(0x1 << 5)
+#define NAU8822_PLL_ON				(0x1 << 5)
+#define NAU8822_PLL_OFF				(0x0 << 5)
 
 /* NAU8822_REG_AUDIO_INTERFACE (0x4) */
 #define NAU8822_AIFMT_MASK			(0x3 << 3)
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 2c41d31956aa..f622a6bbd2fb 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3871,6 +3871,7 @@ static int wm8962_runtime_suspend(struct device *dev)
 #endif
 
 static const struct dev_pm_ops wm8962_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(wm8962_runtime_suspend, wm8962_runtime_resume, NULL)
 };
 
diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index e32c8ded181d..9cfd4f18493f 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -333,7 +333,7 @@ int wm_adsp_fw_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	struct wm_adsp *dsp = snd_soc_component_get_drvdata(component);
-	int ret = 0;
+	int ret = 1;
 
 	if (ucontrol->value.enumerated.item[0] == dsp[e->shift_l].fw)
 		return 0;
diff --git a/sound/soc/intel/boards/sof_cirrus_common.c b/sound/soc/intel/boards/sof_cirrus_common.c
index e71d74ec1b0b..f4192df962d6 100644
--- a/sound/soc/intel/boards/sof_cirrus_common.c
+++ b/sound/soc/intel/boards/sof_cirrus_common.c
@@ -54,22 +54,29 @@ static struct snd_soc_dai_link_component cs35l41_components[] = {
 	},
 };
 
+/*
+ * Mapping between ACPI instance id and speaker position.
+ *
+ * Four speakers:
+ *         0: Tweeter left, 1: Woofer left
+ *         2: Tweeter right, 3: Woofer right
+ */
 static struct snd_soc_codec_conf cs35l41_codec_conf[] = {
 	{
 		.dlc = COMP_CODEC_CONF(CS35L41_DEV0_NAME),
-		.name_prefix = "WL",
+		.name_prefix = "TL",
 	},
 	{
 		.dlc = COMP_CODEC_CONF(CS35L41_DEV1_NAME),
-		.name_prefix = "WR",
+		.name_prefix = "WL",
 	},
 	{
 		.dlc = COMP_CODEC_CONF(CS35L41_DEV2_NAME),
-		.name_prefix = "TL",
+		.name_prefix = "TR",
 	},
 	{
 		.dlc = COMP_CODEC_CONF(CS35L41_DEV3_NAME),
-		.name_prefix = "TR",
+		.name_prefix = "WR",
 	},
 };
 
@@ -101,6 +108,21 @@ static int cs35l41_init(struct snd_soc_pcm_runtime *rtd)
 	return ret;
 }
 
+/*
+ * Channel map:
+ *
+ * TL/WL: ASPRX1 on slot 0, ASPRX2 on slot 1 (default)
+ * TR/WR: ASPRX1 on slot 1, ASPRX2 on slot 0
+ */
+static const struct {
+	unsigned int rx[2];
+} cs35l41_channel_map[] = {
+	{.rx = {0, 1}}, /* TL */
+	{.rx = {0, 1}}, /* WL */
+	{.rx = {1, 0}}, /* TR */
+	{.rx = {1, 0}}, /* WR */
+};
+
 static int cs35l41_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
@@ -134,6 +156,16 @@ static int cs35l41_hw_params(struct snd_pcm_substream *substream,
 				ret);
 			return ret;
 		}
+
+		/* setup channel map */
+		ret = snd_soc_dai_set_channel_map(codec_dai, 0, NULL,
+						  ARRAY_SIZE(cs35l41_channel_map[i].rx),
+						  (unsigned int *)cs35l41_channel_map[i].rx);
+		if (ret < 0) {
+			dev_err(codec_dai->dev, "fail to set channel map, ret %d\n",
+				ret);
+			return ret;
+		}
 	}
 
 	return 0;
diff --git a/sound/soc/qcom/lpass-platform.c b/sound/soc/qcom/lpass-platform.c
index 74d62f377dfd..ae2a7837e5cc 100644
--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -898,7 +898,7 @@ static int lpass_platform_cdc_dma_mmap(struct snd_pcm_substream *substream,
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	unsigned long size, offset;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	size = vma->vm_end - vma->vm_start;
 	offset = vma->vm_pgoff << PAGE_SHIFT;
 	return io_remap_pfn_range(vma, vma->vm_start,
diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.h
index 586d35720f13..c81ea2264ad8 100644
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -141,6 +141,12 @@ struct unwind_hint {
 	.popsection
 .endm
 
+.macro STACK_FRAME_NON_STANDARD_FP func:req
+#ifdef CONFIG_FRAME_POINTER
+	STACK_FRAME_NON_STANDARD \func
+#endif
+.endm
+
 .macro ANNOTATE_NOENDBR
 .Lhere_\@:
 	.pushsection .discard.noendbr
