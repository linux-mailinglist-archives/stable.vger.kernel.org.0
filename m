Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109536A2946
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 12:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBYLJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 06:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBYLJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 06:09:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7331631F;
        Sat, 25 Feb 2023 03:09:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7546EB80A49;
        Sat, 25 Feb 2023 11:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937F0C433D2;
        Sat, 25 Feb 2023 11:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677323338;
        bh=QBLrYF/14508cOMqA9ndiIQP+n2nR/WzY/nYdpqC7fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqE1axZSVvRK8MDXe0pxVXiNM8HLlTbm80wxMMwPoafRMHRsaLOlXMea3EfCNqcJn
         p8zPPCRckrEbU1XFDTr2TZoV5N6RQtciPm0b2PcTwwfIu2+8I5iE6qERbkR7FnH8Z1
         b1e2ZqT/jzt+OuvBv7kzr0vESdMN/IfV8Cjvv/Fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.170
Date:   Sat, 25 Feb 2023 12:08:50 +0100
Message-Id: <167732333019761@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <16773233308218@kroah.com>
References: <16773233308218@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index f6c6b403a1b7..6c5efc4013ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3001,7 +3001,7 @@ F:	drivers/net/ieee802154/atusb.h
 AUDIT SUBSYSTEM
 M:	Paul Moore <paul@paul-moore.com>
 M:	Eric Paris <eparis@redhat.com>
-L:	linux-audit@redhat.com (moderated for non-subscribers)
+L:	audit@vger.kernel.org
 S:	Supported
 W:	https://github.com/linux-audit
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git
diff --git a/Makefile b/Makefile
index dbbfaa5d4fe2..028fca7ec5cf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 169
+SUBLEVEL = 170
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
new file mode 100644
index 000000000000..437dab3fc017
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x08: port@88000 {
+		cell-index = <0x8>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x88000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x28: port@a8000 {
+		cell-index = <0x28>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa8000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e0000 {
+		cell-index = <0>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe0000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy0>;
+	};
+
+	mdio@e1000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy0: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
new file mode 100644
index 000000000000..ad116b17850a
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x09: port@89000 {
+		cell-index = <0x9>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x89000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x29: port@a9000 {
+		cell-index = <0x29>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa9000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e2000 {
+		cell-index = <1>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe2000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy1>;
+	};
+
+	mdio@e3000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy1: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index ecbb447920bc..27714dc2f04a 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -609,8 +609,8 @@ usb1: usb@211000 {
 /include/ "qoriq-bman1.dtsi"
 
 /include/ "qoriq-fman3-0.dtsi"
-/include/ "qoriq-fman3-0-1g-0.dtsi"
-/include/ "qoriq-fman3-0-1g-1.dtsi"
+/include/ "qoriq-fman3-0-10g-2.dtsi"
+/include/ "qoriq-fman3-0-10g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-2.dtsi"
 /include/ "qoriq-fman3-0-1g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-4.dtsi"
@@ -659,3 +659,19 @@ L2_1: l2-cache-controller@c20000 {
 		interrupts = <16 2 1 9>;
 	};
 };
+
+&fman0_rx_0x08 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x28 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_rx_0x09 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x29 {
+	/delete-property/ fsl,fman-10g-port;
+};
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c34ba034ca11..5775983fec56 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3480,8 +3480,14 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
-	    to_svm(vcpu)->vmcb->control.exit_info_1)
+	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
+
+	/*
+	 * Note, the next RIP must be provided as SRCU isn't held, i.e. KVM
+	 * can't read guest memory (dereference memslots) to decode the WRMSR.
+	 */
+	if (control->exit_code == SVM_EXIT_MSR && control->exit_info_1 &&
+	    nrips && control->next_rip)
 		return handle_fastpath_set_msr_irqoff(vcpu);
 
 	return EXIT_FASTPATH_NONE;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f15ddf58a5bc..91371b01eae0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4556,6 +4556,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
+	/*
+	 * If IBRS is advertised to the vCPU, KVM must flush the indirect
+	 * branch predictors when transitioning from L2 to L1, as L1 expects
+	 * hardware (KVM in this case) to provide separate predictor modes.
+	 * Bare metal isolates VMX root (host) from VMX non-root (guest), but
+	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
+	 * separate modes for L2 vs L1.
+	 */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		indirect_branch_prediction_barrier();
+
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8f7152e158e2..c37cbd3fdd85 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1431,8 +1431,10 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 
 		/*
 		 * No indirect branch prediction barrier needed when switching
-		 * the active VMCS within a guest, e.g. on nested VM-Enter.
-		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
+		 * the active VMCS within a vCPU, unless IBRS is advertised to
+		 * the vCPU.  To minimize the number of IBPBs executed, KVM
+		 * performs IBPB on nested VM-Exit (a single nested transition
+		 * may switch the active VMCS multiple times).
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
 			indirect_branch_prediction_barrier();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 554d37873c25..0ccc8d1b972c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7534,7 +7534,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 						  write_fault_to_spt,
 						  emulation_type))
 				return 1;
-			if (ctxt->have_exception) {
+
+			if (ctxt->have_exception &&
+			    !(emulation_type & EMULTYPE_SKIP)) {
 				/*
 				 * #UD should result in just EMULATION_FAILED, and trap-like
 				 * exception should not be encountered during decode.
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b0d3dadeb964..dbcd903ba128 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1865,8 +1865,19 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 	if (!netlink_capable(skb, CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (info->attrs[NBD_ATTR_INDEX])
+	if (info->attrs[NBD_ATTR_INDEX]) {
 		index = nla_get_u32(info->attrs[NBD_ATTR_INDEX]);
+
+		/*
+		 * Too big first_minor can cause duplicate creation of
+		 * sysfs files/links, since index << part_shift might overflow, or
+		 * MKDEV() expect that the max bits of first_minor is 20.
+		 */
+		if (index < 0 || index > MINORMASK >> part_shift) {
+			printk(KERN_ERR "nbd: illegal input index %d\n", index);
+			return -EINVAL;
+		}
+	}
 	if (!info->attrs[NBD_ATTR_SOCKETS]) {
 		printk(KERN_ERR "nbd: must specify at least one socket\n");
 		return -EINVAL;
diff --git a/drivers/clk/x86/Kconfig b/drivers/clk/x86/Kconfig
index 69642e15fcc1..ced99e082e3d 100644
--- a/drivers/clk/x86/Kconfig
+++ b/drivers/clk/x86/Kconfig
@@ -1,8 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CLK_LGM_CGU
 	depends on OF && HAS_IOMEM && (X86 || COMPILE_TEST)
+	select MFD_SYSCON
 	select OF_EARLY_FLATTREE
 	bool "Clock driver for Lightning Mountain(LGM) platform"
 	help
-	  Clock Generation Unit(CGU) driver for Intel Lightning Mountain(LGM)
-	  network processor SoC.
+	  Clock Generation Unit(CGU) driver for MaxLinear's x86 based
+	  Lightning Mountain(LGM) network processor SoC.
diff --git a/drivers/clk/x86/clk-cgu-pll.c b/drivers/clk/x86/clk-cgu-pll.c
index 3179557b5f78..409dbf55f4ca 100644
--- a/drivers/clk/x86/clk-cgu-pll.c
+++ b/drivers/clk/x86/clk-cgu-pll.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 
 #include <linux/clk-provider.h>
@@ -40,13 +41,10 @@ static unsigned long lgm_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
 	unsigned int div, mult, frac;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	mult = lgm_get_clk_val(pll->membase, PLL_REF_DIV(pll->reg), 0, 12);
 	div = lgm_get_clk_val(pll->membase, PLL_REF_DIV(pll->reg), 18, 6);
 	frac = lgm_get_clk_val(pll->membase, pll->reg, 2, 24);
-	spin_unlock_irqrestore(&pll->lock, flags);
 
 	if (pll->type == TYPE_LJPLL)
 		div *= 4;
@@ -57,12 +55,9 @@ static unsigned long lgm_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 static int lgm_pll_is_enabled(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 	unsigned int ret;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	ret = lgm_get_clk_val(pll->membase, pll->reg, 0, 1);
-	spin_unlock_irqrestore(&pll->lock, flags);
 
 	return ret;
 }
@@ -70,15 +65,13 @@ static int lgm_pll_is_enabled(struct clk_hw *hw)
 static int lgm_pll_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 	u32 val;
 	int ret;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	lgm_set_clk_val(pll->membase, pll->reg, 0, 1, 1);
-	ret = readl_poll_timeout_atomic(pll->membase + pll->reg,
-					val, (val & 0x1), 1, 100);
-	spin_unlock_irqrestore(&pll->lock, flags);
+	ret = regmap_read_poll_timeout_atomic(pll->membase, pll->reg,
+					      val, (val & 0x1), 1, 100);
+
 
 	return ret;
 }
@@ -86,11 +79,8 @@ static int lgm_pll_enable(struct clk_hw *hw)
 static void lgm_pll_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	lgm_set_clk_val(pll->membase, pll->reg, 0, 1, 0);
-	spin_unlock_irqrestore(&pll->lock, flags);
 }
 
 static const struct clk_ops lgm_pll_ops = {
@@ -121,7 +111,6 @@ lgm_clk_register_pll(struct lgm_clk_provider *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	pll->membase = ctx->membase;
-	pll->lock = ctx->lock;
 	pll->reg = list->reg;
 	pll->flags = list->flags;
 	pll->type = list->type;
diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index 33de600e0c38..89b53f280aee 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 #include <linux/clk-provider.h>
 #include <linux/device.h>
@@ -24,14 +25,10 @@
 static struct clk_hw *lgm_clk_register_fixed(struct lgm_clk_provider *ctx,
 					     const struct lgm_clk_branch *list)
 {
-	unsigned long flags;
 
-	if (list->div_flags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&ctx->lock, flags);
+	if (list->div_flags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(ctx->membase, list->div_off, list->div_shift,
 				list->div_width, list->div_val);
-		spin_unlock_irqrestore(&ctx->lock, flags);
-	}
 
 	return clk_hw_register_fixed_rate(NULL, list->name,
 					  list->parent_data[0].name,
@@ -41,33 +38,27 @@ static struct clk_hw *lgm_clk_register_fixed(struct lgm_clk_provider *ctx,
 static u8 lgm_clk_mux_get_parent(struct clk_hw *hw)
 {
 	struct lgm_clk_mux *mux = to_lgm_clk_mux(hw);
-	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&mux->lock, flags);
 	if (mux->flags & MUX_CLK_SW)
 		val = mux->reg;
 	else
 		val = lgm_get_clk_val(mux->membase, mux->reg, mux->shift,
 				      mux->width);
-	spin_unlock_irqrestore(&mux->lock, flags);
 	return clk_mux_val_to_index(hw, NULL, mux->flags, val);
 }
 
 static int lgm_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 {
 	struct lgm_clk_mux *mux = to_lgm_clk_mux(hw);
-	unsigned long flags;
 	u32 val;
 
 	val = clk_mux_index_to_val(NULL, mux->flags, index);
-	spin_lock_irqsave(&mux->lock, flags);
 	if (mux->flags & MUX_CLK_SW)
 		mux->reg = val;
 	else
 		lgm_set_clk_val(mux->membase, mux->reg, mux->shift,
 				mux->width, val);
-	spin_unlock_irqrestore(&mux->lock, flags);
 
 	return 0;
 }
@@ -90,7 +81,7 @@ static struct clk_hw *
 lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 		     const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->mux_flags;
+	unsigned long cflags = list->mux_flags;
 	struct device *dev = ctx->dev;
 	u8 shift = list->mux_shift;
 	u8 width = list->mux_width;
@@ -111,7 +102,6 @@ lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 	init.num_parents = list->num_parents;
 
 	mux->membase = ctx->membase;
-	mux->lock = ctx->lock;
 	mux->reg = reg;
 	mux->shift = shift;
 	mux->width = width;
@@ -123,11 +113,8 @@ lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&mux->lock, flags);
+	if (cflags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(mux->membase, reg, shift, width, list->mux_val);
-		spin_unlock_irqrestore(&mux->lock, flags);
-	}
 
 	return hw;
 }
@@ -136,13 +123,10 @@ static unsigned long
 lgm_clk_divider_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
-	unsigned long flags;
 	unsigned int val;
 
-	spin_lock_irqsave(&divider->lock, flags);
 	val = lgm_get_clk_val(divider->membase, divider->reg,
 			      divider->shift, divider->width);
-	spin_unlock_irqrestore(&divider->lock, flags);
 
 	return divider_recalc_rate(hw, parent_rate, val, divider->table,
 				   divider->flags, divider->width);
@@ -163,7 +147,6 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 			 unsigned long prate)
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
-	unsigned long flags;
 	int value;
 
 	value = divider_get_val(rate, prate, divider->table,
@@ -171,10 +154,8 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (value < 0)
 		return value;
 
-	spin_lock_irqsave(&divider->lock, flags);
 	lgm_set_clk_val(divider->membase, divider->reg,
 			divider->shift, divider->width, value);
-	spin_unlock_irqrestore(&divider->lock, flags);
 
 	return 0;
 }
@@ -182,12 +163,10 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 static int lgm_clk_divider_enable_disable(struct clk_hw *hw, int enable)
 {
 	struct lgm_clk_divider *div = to_lgm_clk_divider(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&div->lock, flags);
-	lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
-			div->width_gate, enable);
-	spin_unlock_irqrestore(&div->lock, flags);
+	if (div->flags != DIV_CLK_NO_MASK)
+		lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
+				div->width_gate, enable);
 	return 0;
 }
 
@@ -213,7 +192,7 @@ static struct clk_hw *
 lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 			 const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->div_flags;
+	unsigned long cflags = list->div_flags;
 	struct device *dev = ctx->dev;
 	struct lgm_clk_divider *div;
 	struct clk_init_data init = {};
@@ -236,7 +215,6 @@ lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 	init.num_parents = 1;
 
 	div->membase = ctx->membase;
-	div->lock = ctx->lock;
 	div->reg = reg;
 	div->shift = shift;
 	div->width = width;
@@ -251,11 +229,8 @@ lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&div->lock, flags);
+	if (cflags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(div->membase, reg, shift, width, list->div_val);
-		spin_unlock_irqrestore(&div->lock, flags);
-	}
 
 	return hw;
 }
@@ -264,7 +239,6 @@ static struct clk_hw *
 lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 			      const struct lgm_clk_branch *list)
 {
-	unsigned long flags;
 	struct clk_hw *hw;
 
 	hw = clk_hw_register_fixed_factor(ctx->dev, list->name,
@@ -273,12 +247,9 @@ lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 	if (IS_ERR(hw))
 		return ERR_CAST(hw);
 
-	if (list->div_flags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&ctx->lock, flags);
+	if (list->div_flags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(ctx->membase, list->div_off, list->div_shift,
 				list->div_width, list->div_val);
-		spin_unlock_irqrestore(&ctx->lock, flags);
-	}
 
 	return hw;
 }
@@ -286,13 +257,10 @@ lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 static int lgm_clk_gate_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
-	unsigned long flags;
 	unsigned int reg;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_EN(gate->reg);
 	lgm_set_clk_val(gate->membase, reg, gate->shift, 1, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 
 	return 0;
 }
@@ -300,25 +268,19 @@ static int lgm_clk_gate_enable(struct clk_hw *hw)
 static void lgm_clk_gate_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
-	unsigned long flags;
 	unsigned int reg;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_DIS(gate->reg);
 	lgm_set_clk_val(gate->membase, reg, gate->shift, 1, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 }
 
 static int lgm_clk_gate_is_enabled(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
 	unsigned int reg, ret;
-	unsigned long flags;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_STAT(gate->reg);
 	ret = lgm_get_clk_val(gate->membase, reg, gate->shift, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 
 	return ret;
 }
@@ -333,7 +295,7 @@ static struct clk_hw *
 lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 		      const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->gate_flags;
+	unsigned long cflags = list->gate_flags;
 	const char *pname = list->parent_data[0].name;
 	struct device *dev = ctx->dev;
 	u8 shift = list->gate_shift;
@@ -354,7 +316,6 @@ lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 	init.num_parents = pname ? 1 : 0;
 
 	gate->membase = ctx->membase;
-	gate->lock = ctx->lock;
 	gate->reg = reg;
 	gate->shift = shift;
 	gate->flags = cflags;
@@ -366,9 +327,7 @@ lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 		return ERR_PTR(ret);
 
 	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&gate->lock, flags);
 		lgm_set_clk_val(gate->membase, reg, shift, 1, list->gate_val);
-		spin_unlock_irqrestore(&gate->lock, flags);
 	}
 
 	return hw;
@@ -396,8 +355,22 @@ int lgm_clk_register_branches(struct lgm_clk_provider *ctx,
 			hw = lgm_clk_register_fixed_factor(ctx, list);
 			break;
 		case CLK_TYPE_GATE:
-			hw = lgm_clk_register_gate(ctx, list);
+			if (list->gate_flags & GATE_CLK_HW) {
+				hw = lgm_clk_register_gate(ctx, list);
+			} else {
+				/*
+				 * GATE_CLKs can be controlled either from
+				 * CGU clk driver i.e. this driver or directly
+				 * from power management driver/daemon. It is
+				 * dependent on the power policy/profile requirements
+				 * of the end product. To override control of gate
+				 * clks from this driver, provide NULL for this index
+				 * of gate clk provider.
+				 */
+				hw = NULL;
+			}
 			break;
+
 		default:
 			dev_err(ctx->dev, "invalid clk type\n");
 			return -EINVAL;
@@ -443,24 +416,18 @@ lgm_clk_ddiv_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 static int lgm_clk_ddiv_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift_gate,
 			ddiv->width_gate, 1);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 	return 0;
 }
 
 static void lgm_clk_ddiv_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift_gate,
 			ddiv->width_gate, 0);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 }
 
 static int
@@ -497,32 +464,25 @@ lgm_clk_ddiv_set_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
 	u32 div, ddiv1, ddiv2;
-	unsigned long flags;
 
 	div = DIV_ROUND_CLOSEST_ULL((u64)prate, rate);
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		div = DIV_ROUND_CLOSEST_ULL((u64)div, 5);
 		div = div * 2;
 	}
 
-	if (div <= 0) {
-		spin_unlock_irqrestore(&ddiv->lock, flags);
+	if (div <= 0)
 		return -EINVAL;
-	}
 
-	if (lgm_clk_get_ddiv_val(div, &ddiv1, &ddiv2)) {
-		spin_unlock_irqrestore(&ddiv->lock, flags);
+	if (lgm_clk_get_ddiv_val(div, &ddiv1, &ddiv2))
 		return -EINVAL;
-	}
 
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift0, ddiv->width0,
 			ddiv1 - 1);
 
 	lgm_set_clk_val(ddiv->membase, ddiv->reg,  ddiv->shift1, ddiv->width1,
 			ddiv2 - 1);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	return 0;
 }
@@ -533,18 +493,15 @@ lgm_clk_ddiv_round_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
 	u32 div, ddiv1, ddiv2;
-	unsigned long flags;
 	u64 rate64;
 
 	div = DIV_ROUND_CLOSEST_ULL((u64)*prate, rate);
 
 	/* if predivide bit is enabled, modify div by factor of 2.5 */
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		div = div * 2;
 		div = DIV_ROUND_CLOSEST_ULL((u64)div, 5);
 	}
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	if (div <= 0)
 		return *prate;
@@ -558,12 +515,10 @@ lgm_clk_ddiv_round_rate(struct clk_hw *hw, unsigned long rate,
 	do_div(rate64, ddiv2);
 
 	/* if predivide bit is enabled, modify rounded rate by factor of 2.5 */
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		rate64 = rate64 * 2;
 		rate64 = DIV_ROUND_CLOSEST_ULL(rate64, 5);
 	}
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	return rate64;
 }
@@ -600,7 +555,6 @@ int lgm_clk_register_ddiv(struct lgm_clk_provider *ctx,
 		init.num_parents = 1;
 
 		ddiv->membase = ctx->membase;
-		ddiv->lock = ctx->lock;
 		ddiv->reg = list->reg;
 		ddiv->shift0 = list->shift0;
 		ddiv->width0 = list->width0;
diff --git a/drivers/clk/x86/clk-cgu.h b/drivers/clk/x86/clk-cgu.h
index 4e22bfb22312..bcaf8aec94e5 100644
--- a/drivers/clk/x86/clk-cgu.h
+++ b/drivers/clk/x86/clk-cgu.h
@@ -1,28 +1,28 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright(c) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
+ * Copyright (C) 2020 Intel Corporation.
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 
 #ifndef __CLK_CGU_H
 #define __CLK_CGU_H
 
-#include <linux/io.h>
+#include <linux/regmap.h>
 
 struct lgm_clk_mux {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	u8 width;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 struct lgm_clk_divider {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	u8 width;
@@ -30,12 +30,11 @@ struct lgm_clk_divider {
 	u8 width_gate;
 	unsigned long flags;
 	const struct clk_div_table *table;
-	spinlock_t lock;
 };
 
 struct lgm_clk_ddiv {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift0;
 	u8 width0;
@@ -48,16 +47,14 @@ struct lgm_clk_ddiv {
 	unsigned int mult;
 	unsigned int div;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 struct lgm_clk_gate {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 enum lgm_clk_type {
@@ -77,11 +74,10 @@ enum lgm_clk_type {
  * @clk_data: array of hw clocks and clk number.
  */
 struct lgm_clk_provider {
-	void __iomem *membase;
+	struct regmap *membase;
 	struct device_node *np;
 	struct device *dev;
 	struct clk_hw_onecell_data clk_data;
-	spinlock_t lock;
 };
 
 enum pll_type {
@@ -92,11 +88,10 @@ enum pll_type {
 
 struct lgm_clk_pll {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	unsigned long flags;
 	enum pll_type type;
-	spinlock_t lock;
 };
 
 /**
@@ -202,6 +197,8 @@ struct lgm_clk_branch {
 /* clock flags definition */
 #define CLOCK_FLAG_VAL_INIT	BIT(16)
 #define MUX_CLK_SW		BIT(17)
+#define GATE_CLK_HW		BIT(18)
+#define DIV_CLK_NO_MASK		BIT(19)
 
 #define LGM_MUX(_id, _name, _pdata, _f, _reg,		\
 		_shift, _width, _cf, _v)		\
@@ -300,29 +297,32 @@ struct lgm_clk_branch {
 		.div = _d,					\
 	}
 
-static inline void lgm_set_clk_val(void __iomem *membase, u32 reg,
+static inline void lgm_set_clk_val(struct regmap *membase, u32 reg,
 				   u8 shift, u8 width, u32 set_val)
 {
 	u32 mask = (GENMASK(width - 1, 0) << shift);
-	u32 regval;
 
-	regval = readl(membase + reg);
-	regval = (regval & ~mask) | ((set_val << shift) & mask);
-	writel(regval, membase + reg);
+	regmap_update_bits(membase, reg, mask, set_val << shift);
 }
 
-static inline u32 lgm_get_clk_val(void __iomem *membase, u32 reg,
+static inline u32 lgm_get_clk_val(struct regmap *membase, u32 reg,
 				  u8 shift, u8 width)
 {
 	u32 mask = (GENMASK(width - 1, 0) << shift);
 	u32 val;
 
-	val = readl(membase + reg);
+	if (regmap_read(membase, reg, &val)) {
+		WARN_ONCE(1, "Failed to read clk reg: 0x%x\n", reg);
+		return 0;
+	}
+
 	val = (val & mask) >> shift;
 
 	return val;
 }
 
+
+
 int lgm_clk_register_branches(struct lgm_clk_provider *ctx,
 			      const struct lgm_clk_branch *list,
 			      unsigned int nr_clk);
diff --git a/drivers/clk/x86/clk-lgm.c b/drivers/clk/x86/clk-lgm.c
index 020f4e83a5cc..f69455dd1c98 100644
--- a/drivers/clk/x86/clk-lgm.c
+++ b/drivers/clk/x86/clk-lgm.c
@@ -1,10 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 #include <linux/clk-provider.h>
+#include <linux/mfd/syscon.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <dt-bindings/clock/intel,lgm-clk.h>
@@ -253,8 +255,8 @@ static const struct lgm_clk_branch lgm_branch_clks[] = {
 	LGM_FIXED(LGM_CLK_SLIC, "slic", NULL, 0, CGU_IF_CLK1,
 		  8, 2, CLOCK_FLAG_VAL_INIT, 8192000, 2),
 	LGM_FIXED(LGM_CLK_DOCSIS, "v_docsis", NULL, 0, 0, 0, 0, 0, 16000000, 0),
-	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", 0, CGU_PCMCR,
-		25, 3, 0, 0, 0, 0, dcl_div),
+	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", CLK_SET_RATE_PARENT, CGU_PCMCR,
+		25, 3, 0, 0, DIV_CLK_NO_MASK, 0, dcl_div),
 	LGM_MUX(LGM_CLK_PCM, "pcm", pcm_p, 0, CGU_C55_PCMCR,
 		0, 1, CLK_MUX_ROUND_CLOSEST, 0),
 	LGM_FIXED_FACTOR(LGM_CLK_DDR_PHY, "ddr_phy", "ddr",
@@ -433,13 +435,15 @@ static int lgm_cgu_probe(struct platform_device *pdev)
 
 	ctx->clk_data.num = CLK_NR_CLKS;
 
-	ctx->membase = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(ctx->membase))
+	ctx->membase = syscon_node_to_regmap(np);
+	if (IS_ERR(ctx->membase)) {
+		dev_err(dev, "Failed to get clk CGU iomem\n");
 		return PTR_ERR(ctx->membase);
+	}
+
 
 	ctx->np = np;
 	ctx->dev = dev;
-	spin_lock_init(&ctx->lock);
 
 	ret = lgm_clk_register_plls(ctx, lgm_pll_clks,
 				    ARRAY_SIZE(lgm_pll_clks));
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
index 9ba2fe48228f..44fbc0a123bf 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -80,10 +80,10 @@ static int etnaviv_iommu_map(struct etnaviv_iommu_context *context, u32 iova,
 		return -EINVAL;
 
 	for_each_sgtable_dma_sg(sgt, sg, i) {
-		u32 pa = sg_dma_address(sg) - sg->offset;
+		phys_addr_t pa = sg_dma_address(sg) - sg->offset;
 		size_t bytes = sg_dma_len(sg) + sg->offset;
 
-		VERB("map[%d]: %08x %08x(%zx)", i, iova, pa, bytes);
+		VERB("map[%d]: %08x %pap(%zx)", i, iova, &pa, bytes);
 
 		ret = etnaviv_context_map(context, da, pa, bytes, prot);
 		if (ret)
diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index a3a4305eda01..0201f9b5f87e 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1192,10 +1192,8 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	for_each_shadow_entry(sub_spt, &sub_se, sub_index) {
 		ret = intel_gvt_hypervisor_dma_map_guest_page(vgpu,
 				start_gfn + sub_index, PAGE_SIZE, &dma_addr);
-		if (ret) {
-			ppgtt_invalidate_spt(spt);
-			return ret;
-		}
+		if (ret)
+			goto err;
 		sub_se.val64 = se->val64;
 
 		/* Copy the PAT field from PDE. */
@@ -1214,6 +1212,17 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	ops->set_pfn(se, sub_spt->shadow_page.mfn);
 	ppgtt_set_shadow_entry(spt, se, index);
 	return 0;
+err:
+	/* Cancel the existing addess mappings of DMA addr. */
+	for_each_present_shadow_entry(sub_spt, &sub_se, sub_index) {
+		gvt_vdbg_mm("invalidate 4K entry\n");
+		ppgtt_invalidate_pte(sub_spt, &sub_se);
+	}
+	/* Release the new allocated spt. */
+	trace_spt_change(sub_spt->vgpu->id, "release", sub_spt,
+		sub_spt->guest_page.gfn, sub_spt->shadow_page.type);
+	ppgtt_free_spt(sub_spt);
+	return ret;
 }
 
 static int split_64KB_gtt_entry(struct intel_vgpu *vgpu,
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 2764fdd7e84b..233bbfeaa771 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -518,6 +518,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 					    u8 cmd_no, int channel)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -525,6 +526,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	if (channel < 0) {
 		kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -541,7 +543,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -557,6 +559,7 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 {
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
@@ -564,14 +567,14 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd_async(priv, cmd,
-					kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd_async(priv, cmd, cmd_len);
 	if (err)
 		kfree(cmd);
 
@@ -715,6 +718,7 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 {
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	u32 value = 0;
 	u32 mask = 0;
 	u16 cap_cmd_res;
@@ -726,13 +730,14 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_CAPABILITIES_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->cap_req.cap_cmd = cpu_to_le16(cap_cmd_req);
 
 	kvaser_usb_hydra_set_cmd_dest_he(cmd, card_data->hydra.sysdbg_he);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1555,6 +1560,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_usb_net_hydra_priv *hydra = priv->sub_priv;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if (!hydra)
@@ -1565,6 +1571,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1574,7 +1581,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 
 	reinit_completion(&priv->get_busparams_comp);
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		return err;
 
@@ -1601,6 +1608,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -1608,6 +1616,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_nominal, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_nominal));
 
@@ -1616,7 +1625,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1629,6 +1638,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -1636,6 +1646,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_FD_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_data, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_data));
 
@@ -1653,7 +1664,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1781,6 +1792,7 @@ static int kvaser_usb_hydra_get_software_info(struct kvaser_usb *dev)
 static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 	u32 flags;
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
@@ -1790,6 +1802,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_SOFTWARE_DETAILS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->sw_detail_req.use_ext_cmd = 1;
 	kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -1797,7 +1810,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1913,6 +1926,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 {
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if ((priv->can.ctrlmode &
@@ -1928,6 +1942,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_DRIVERMODE_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1937,7 +1952,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 	else
 		cmd->set_ctrlmode.mode = KVASER_USB_HYDRA_CTRLMODE_NORMAL;
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	kfree(cmd);
 
 	return err;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index bde9e4bbfffe..7fb6eef40928 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -485,6 +485,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 };
 
 static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
 	{ }
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9a12f1d38007..2cb86c28d11f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4369,12 +4369,9 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 				  u8 macid, bool connect)
 {
-#ifdef RTL8XXXU_GEN2_REPORT_CONNECT
 	/*
-	 * Barry Day reports this causes issues with 8192eu and 8723bu
-	 * devices reconnecting. The reason for this is unclear, but
-	 * until it is better understood, leave the code in place but
-	 * disabled, so it is not lost.
+	 * The firmware turns on the rate control when it knows it's
+	 * connected to a network.
 	 */
 	struct h2c_cmd h2c;
 
@@ -4387,7 +4384,6 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 		h2c.media_status_rpt.parm &= ~BIT(0);
 
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
-#endif
 }
 
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index f24bef3be48a..ce74cde6d8fa 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -487,6 +487,11 @@ static void ext4_sb_release(struct kobject *kobj)
 	complete(&sbi->s_kobj_unregister);
 }
 
+static void ext4_feat_release(struct kobject *kobj)
+{
+	kfree(kobj);
+}
+
 static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
 	.store	= ext4_attr_store,
@@ -501,7 +506,7 @@ static struct kobj_type ext4_sb_ktype = {
 static struct kobj_type ext4_feat_ktype = {
 	.default_groups = ext4_feat_groups,
 	.sysfs_ops	= &ext4_attr_ops,
-	.release	= (void (*)(struct kobject *))kfree,
+	.release	= ext4_feat_release,
 };
 
 static struct kobject *ext4_root;
diff --git a/include/linux/nospec.h b/include/linux/nospec.h
index c1e79f72cd89..9f0af4f116d9 100644
--- a/include/linux/nospec.h
+++ b/include/linux/nospec.h
@@ -11,6 +11,10 @@
 
 struct task_struct;
 
+#ifndef barrier_nospec
+# define barrier_nospec() do { } while (0)
+#endif
+
 /**
  * array_index_mask_nospec() - generate a ~0 mask when index < size, 0 otherwise
  * @index: array element index
diff --git a/include/linux/random.h b/include/linux/random.h
index 917470c4490a..ed2bac6c7a8a 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -19,14 +19,14 @@ void add_input_randomness(unsigned int type, unsigned int code,
 void add_interrupt_randomness(int irq) __latent_entropy;
 void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
 
-#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
 {
+#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 	add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
-}
 #else
-static inline void add_latent_entropy(void) { }
+	add_device_randomness(NULL, 0);
 #endif
+}
 
 void get_random_bytes(void *buf, size_t len);
 size_t __must_check get_random_bytes_arch(void *buf, size_t len);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index fd2aa6b9909e..73d4b1e32fbd 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -32,6 +32,7 @@
 #include <linux/perf_event.h>
 #include <linux/extable.h>
 #include <linux/log2.h>
+#include <linux/nospec.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -1642,9 +1643,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		 * reuse preexisting logic from Spectre v1 mitigation that
 		 * happens to produce the required code on x86 for v4 as well.
 		 */
-#ifdef CONFIG_X86
 		barrier_nospec();
-#endif
 		CONT;
 #define LDST(SIZEOP, SIZE)						\
 	STX_MEM_##SIZEOP:						\
diff --git a/lib/usercopy.c b/lib/usercopy.c
index 7413dd300516..7ee63df042d7 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -3,6 +3,7 @@
 #include <linux/fault-inject-usercopy.h>
 #include <linux/instrumented.h>
 #include <linux/uaccess.h>
+#include <linux/nospec.h>
 
 /* out-of-line parts */
 
@@ -12,6 +13,12 @@ unsigned long _copy_from_user(void *to, const void __user *from, unsigned long n
 	unsigned long res = n;
 	might_fault();
 	if (!should_fail_usercopy() && likely(access_ok(from, n))) {
+		/*
+		 * Ensure that bad access_ok() speculation will not
+		 * lead to nasty side effects *after* the copy is
+		 * finished:
+		 */
+		barrier_nospec();
 		instrument_copy_from_user(to, from, n);
 		res = raw_copy_from_user(to, from, n);
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 63499db5c63d..bd349ae9ee4b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -644,6 +644,26 @@ struct mesh_csa_settings {
 	struct cfg80211_csa_settings settings;
 };
 
+/**
+ * struct mesh_table
+ *
+ * @known_gates: list of known mesh gates and their mpaths by the station. The
+ * gate's mpath may or may not be resolved and active.
+ * @gates_lock: protects updates to known_gates
+ * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
+ * @walk_head: linked list containing all mesh_path objects
+ * @walk_lock: lock protecting walk_head
+ * @entries: number of entries in the table
+ */
+struct mesh_table {
+	struct hlist_head known_gates;
+	spinlock_t gates_lock;
+	struct rhashtable rhead;
+	struct hlist_head walk_head;
+	spinlock_t walk_lock;
+	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
+};
+
 struct ieee80211_if_mesh {
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
@@ -718,8 +738,8 @@ struct ieee80211_if_mesh {
 	/* offset from skb->data while building IE */
 	int meshconf_offset;
 
-	struct mesh_table *mesh_paths;
-	struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
+	struct mesh_table mesh_paths;
+	struct mesh_table mpp_paths; /* Store paths for MPP&MAP */
 	int mesh_paths_generation;
 	int mpp_paths_generation;
 };
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 40492d1bd8fd..b2b717a78114 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -127,26 +127,6 @@ struct mesh_path {
 	u32 path_change_count;
 };
 
-/**
- * struct mesh_table
- *
- * @known_gates: list of known mesh gates and their mpaths by the station. The
- * gate's mpath may or may not be resolved and active.
- * @gates_lock: protects updates to known_gates
- * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
- * @walk_head: linked list containging all mesh_path objects
- * @walk_lock: lock protecting walk_head
- * @entries: number of entries in the table
- */
-struct mesh_table {
-	struct hlist_head known_gates;
-	spinlock_t gates_lock;
-	struct rhashtable rhead;
-	struct hlist_head walk_head;
-	spinlock_t walk_lock;
-	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
-};
-
 /* Recent multicast cache */
 /* RMC_BUCKETS must be a power of 2, maximum 256 */
 #define RMC_BUCKETS		256
@@ -308,7 +288,7 @@ int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
-int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata);
+void mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata);
 void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata);
 int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr);
 void mesh_path_timer(struct timer_list *t);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index c2b051e0610a..d936ef0c17a3 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -47,32 +47,24 @@ static void mesh_path_rht_free(void *ptr, void *tblptr)
 	mesh_path_free_rcu(tbl, mpath);
 }
 
-static struct mesh_table *mesh_table_alloc(void)
+static void mesh_table_init(struct mesh_table *tbl)
 {
-	struct mesh_table *newtbl;
+	INIT_HLIST_HEAD(&tbl->known_gates);
+	INIT_HLIST_HEAD(&tbl->walk_head);
+	atomic_set(&tbl->entries,  0);
+	spin_lock_init(&tbl->gates_lock);
+	spin_lock_init(&tbl->walk_lock);
 
-	newtbl = kmalloc(sizeof(struct mesh_table), GFP_ATOMIC);
-	if (!newtbl)
-		return NULL;
-
-	INIT_HLIST_HEAD(&newtbl->known_gates);
-	INIT_HLIST_HEAD(&newtbl->walk_head);
-	atomic_set(&newtbl->entries,  0);
-	spin_lock_init(&newtbl->gates_lock);
-	spin_lock_init(&newtbl->walk_lock);
-	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params)) {
-		kfree(newtbl);
-		return NULL;
-	}
-
-	return newtbl;
+	/* rhashtable_init() may fail only in case of wrong
+	 * mesh_rht_params
+	 */
+	WARN_ON(rhashtable_init(&tbl->rhead, &mesh_rht_params));
 }
 
 static void mesh_table_free(struct mesh_table *tbl)
 {
 	rhashtable_free_and_destroy(&tbl->rhead,
 				    mesh_path_rht_free, tbl);
-	kfree(tbl);
 }
 
 /**
@@ -238,13 +230,13 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 struct mesh_path *
 mesh_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(sdata->u.mesh.mesh_paths, dst, sdata);
+	return mpath_lookup(&sdata->u.mesh.mesh_paths, dst, sdata);
 }
 
 struct mesh_path *
 mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(sdata->u.mesh.mpp_paths, dst, sdata);
+	return mpath_lookup(&sdata->u.mesh.mpp_paths, dst, sdata);
 }
 
 static struct mesh_path *
@@ -281,7 +273,7 @@ __mesh_path_lookup_by_idx(struct mesh_table *tbl, int idx)
 struct mesh_path *
 mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	return __mesh_path_lookup_by_idx(sdata->u.mesh.mesh_paths, idx);
+	return __mesh_path_lookup_by_idx(&sdata->u.mesh.mesh_paths, idx);
 }
 
 /**
@@ -296,7 +288,7 @@ mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 struct mesh_path *
 mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	return __mesh_path_lookup_by_idx(sdata->u.mesh.mpp_paths, idx);
+	return __mesh_path_lookup_by_idx(&sdata->u.mesh.mpp_paths, idx);
 }
 
 /**
@@ -309,7 +301,7 @@ int mesh_path_add_gate(struct mesh_path *mpath)
 	int err;
 
 	rcu_read_lock();
-	tbl = mpath->sdata->u.mesh.mesh_paths;
+	tbl = &mpath->sdata->u.mesh.mesh_paths;
 
 	spin_lock_bh(&mpath->state_lock);
 	if (mpath->is_gate) {
@@ -418,7 +410,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	if (!new_mpath)
 		return ERR_PTR(-ENOMEM);
 
-	tbl = sdata->u.mesh.mesh_paths;
+	tbl = &sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
 	mpath = rhashtable_lookup_get_insert_fast(&tbl->rhead,
 						  &new_mpath->rhash,
@@ -460,7 +452,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		return -ENOMEM;
 
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
-	tbl = sdata->u.mesh.mpp_paths;
+	tbl = &sdata->u.mesh.mpp_paths;
 
 	spin_lock_bh(&tbl->walk_lock);
 	ret = rhashtable_lookup_insert_fast(&tbl->rhead,
@@ -489,7 +481,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 void mesh_plink_broken(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mesh_paths;
 	static const u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct mesh_path *mpath;
 
@@ -548,7 +540,7 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mesh_path *mpath)
 void mesh_path_flush_by_nexthop(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mesh_paths;
 	struct mesh_path *mpath;
 	struct hlist_node *n;
 
@@ -563,7 +555,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
 			       const u8 *proxy)
 {
-	struct mesh_table *tbl = sdata->u.mesh.mpp_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mpp_paths;
 	struct mesh_path *mpath;
 	struct hlist_node *n;
 
@@ -597,8 +589,8 @@ static void table_flush_by_iface(struct mesh_table *tbl)
  */
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 {
-	table_flush_by_iface(sdata->u.mesh.mesh_paths);
-	table_flush_by_iface(sdata->u.mesh.mpp_paths);
+	table_flush_by_iface(&sdata->u.mesh.mesh_paths);
+	table_flush_by_iface(&sdata->u.mesh.mpp_paths);
 }
 
 /**
@@ -644,7 +636,7 @@ int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	/* flush relevant mpp entries first */
 	mpp_flush_by_proxy(sdata, addr);
 
-	err = table_path_del(sdata->u.mesh.mesh_paths, sdata, addr);
+	err = table_path_del(&sdata->u.mesh.mesh_paths, sdata, addr);
 	sdata->u.mesh.mesh_paths_generation++;
 	return err;
 }
@@ -682,7 +674,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 	struct mesh_path *gate;
 	bool copy = false;
 
-	tbl = sdata->u.mesh.mesh_paths;
+	tbl = &sdata->u.mesh.mesh_paths;
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(gate, &tbl->known_gates, gate_list) {
@@ -762,29 +754,10 @@ void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop)
 	mesh_path_tx_pending(mpath);
 }
 
-int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
+void mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
 {
-	struct mesh_table *tbl_path, *tbl_mpp;
-	int ret;
-
-	tbl_path = mesh_table_alloc();
-	if (!tbl_path)
-		return -ENOMEM;
-
-	tbl_mpp = mesh_table_alloc();
-	if (!tbl_mpp) {
-		ret = -ENOMEM;
-		goto free_path;
-	}
-
-	sdata->u.mesh.mesh_paths = tbl_path;
-	sdata->u.mesh.mpp_paths = tbl_mpp;
-
-	return 0;
-
-free_path:
-	mesh_table_free(tbl_path);
-	return ret;
+	mesh_table_init(&sdata->u.mesh.mesh_paths);
+	mesh_table_init(&sdata->u.mesh.mpp_paths);
 }
 
 static
@@ -806,12 +779,12 @@ void mesh_path_tbl_expire(struct ieee80211_sub_if_data *sdata,
 
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 {
-	mesh_path_tbl_expire(sdata, sdata->u.mesh.mesh_paths);
-	mesh_path_tbl_expire(sdata, sdata->u.mesh.mpp_paths);
+	mesh_path_tbl_expire(sdata, &sdata->u.mesh.mesh_paths);
+	mesh_path_tbl_expire(sdata, &sdata->u.mesh.mpp_paths);
 }
 
 void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata)
 {
-	mesh_table_free(sdata->u.mesh.mesh_paths);
-	mesh_table_free(sdata->u.mesh.mpp_paths);
+	mesh_table_free(&sdata->u.mesh.mesh_paths);
+	mesh_table_free(&sdata->u.mesh.mpp_paths);
 }
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index e25fe44899ff..2d842f31ec5a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1906,14 +1906,12 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	unsigned int ntx = cl - 1;
+	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
 
-	if (ntx >= dev->num_tx_queues)
+	if (!dev_queue)
 		return NULL;
 
-	return q->qdiscs[ntx];
+	return dev_queue->qdisc_sleeping;
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
