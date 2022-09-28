Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50E65EDA8C
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 12:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbiI1Kve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 06:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbiI1Kuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 06:50:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DB51A38D;
        Wed, 28 Sep 2022 03:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8C4361E0E;
        Wed, 28 Sep 2022 10:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1390DC433D7;
        Wed, 28 Sep 2022 10:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664362182;
        bh=yCCBEWDRL76AGqfzkeahL4+kBPEkKzs004SAmvBWEkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vo+hu7tSOf/0hUrl5IDd6cIKunFDTUxpPYG/xOZkDbk1tngChC7oW+hXmEJdaQxmV
         SiVgfwk6dk0PG6/ybOt0JDzDdAEm1nmFer/WD4g94tUfKQe2L/PsBNHha36lep9NUs
         dIHnGttvpKKrwHXhgUQrBG/qiU0fQzhcYfXD/LJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.71
Date:   Wed, 28 Sep 2022 12:49:27 +0200
Message-Id: <1664362166852@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <166436216672194@kroah.com>
References: <166436216672194@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index e815677ec011..4c06cbe89ece 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 70
+SUBLEVEL = 71
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi b/arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi
index 7249871530ab..5eecbefa8a33 100644
--- a/arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-engicam-px30-core.dtsi
@@ -2,8 +2,8 @@
 /*
  * Copyright (c) 2020 Fuzhou Rockchip Electronics Co., Ltd
  * Copyright (c) 2020 Engicam srl
- * Copyright (c) 2020 Amarula Solutons
- * Copyright (c) 2020 Amarula Solutons(India)
+ * Copyright (c) 2020 Amarula Solutions
+ * Copyright (c) 2020 Amarula Solutions(India)
  */
 
 #include <dt-bindings/gpio/gpio.h>
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts b/arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts
index e6c1c94c8d69..07737b65d7a3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts
@@ -87,3 +87,8 @@ h1_int_od_l: h1-int-od-l {
 		};
 	};
 };
+
+&wlan_host_wake_l {
+	/* Kevin has an external pull up, but Bob does not. */
+	rockchip,pins = <0 RK_PB0 RK_FUNC_GPIO &pcfg_pull_up>;
+};
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
index 1384dabbdf40..739937f70f8d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -237,6 +237,14 @@ &cdn_dp {
 &edp {
 	status = "okay";
 
+	/*
+	 * eDP PHY/clk don't sync reliably at anything other than 24 MHz. Only
+	 * set this here, because rk3399-gru.dtsi ensures we can generate this
+	 * off GPLL=600MHz, whereas some other RK3399 boards may not.
+	 */
+	assigned-clocks = <&cru PCLK_EDP>;
+	assigned-clock-rates = <24000000>;
+
 	ports {
 		edp_out: port@1 {
 			reg = <1>;
@@ -395,6 +403,7 @@ wifi_perst_l: wifi-perst-l {
 	};
 
 	wlan_host_wake_l: wlan-host-wake-l {
+		/* Kevin has an external pull up, but Bob does not */
 		rockchip,pins = <0 RK_PB0 RK_FUNC_GPIO &pcfg_pull_none>;
 	};
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 08fa00364b42..7b27079fd611 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -62,7 +62,6 @@ vcc3v3_sys: vcc3v3-sys {
 	vcc5v0_host: vcc5v0-host-regulator {
 		compatible = "regulator-fixed";
 		gpio = <&gpio4 RK_PA3 GPIO_ACTIVE_LOW>;
-		enable-active-low;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc5v0_host_en>;
 		regulator-name = "vcc5v0_host";
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index acf67ef4c505..d844b5317d2d 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -249,7 +249,7 @@ static void amu_fie_setup(const struct cpumask *cpus)
 	for_each_cpu(cpu, cpus) {
 		if (!freq_counters_valid(cpu) ||
 		    freq_inv_set_max_ratio(cpu,
-					   cpufreq_get_hw_max_freq(cpu) * 1000,
+					   cpufreq_get_hw_max_freq(cpu) * 1000ULL,
 					   arch_timer_get_rate()))
 			return;
 	}
diff --git a/arch/mips/lantiq/clk.c b/arch/mips/lantiq/clk.c
index 7a623684d9b5..2d5a0bcb0cec 100644
--- a/arch/mips/lantiq/clk.c
+++ b/arch/mips/lantiq/clk.c
@@ -50,6 +50,7 @@ struct clk *clk_get_io(void)
 {
 	return &cpu_clk_generic[2];
 }
+EXPORT_SYMBOL_GPL(clk_get_io);
 
 struct clk *clk_get_ppe(void)
 {
diff --git a/arch/mips/loongson32/common/platform.c b/arch/mips/loongson32/common/platform.c
index 794c96c2a4cd..311dc1580bbd 100644
--- a/arch/mips/loongson32/common/platform.c
+++ b/arch/mips/loongson32/common/platform.c
@@ -98,7 +98,7 @@ int ls1x_eth_mux_init(struct platform_device *pdev, void *priv)
 	if (plat_dat->bus_id) {
 		__raw_writel(__raw_readl(LS1X_MUX_CTRL0) | GMAC1_USE_UART1 |
 			     GMAC1_USE_UART0, LS1X_MUX_CTRL0);
-		switch (plat_dat->interface) {
+		switch (plat_dat->phy_interface) {
 		case PHY_INTERFACE_MODE_RGMII:
 			val &= ~(GMAC1_USE_TXCLK | GMAC1_USE_PWM23);
 			break;
@@ -107,12 +107,12 @@ int ls1x_eth_mux_init(struct platform_device *pdev, void *priv)
 			break;
 		default:
 			pr_err("unsupported mii mode %d\n",
-			       plat_dat->interface);
+			       plat_dat->phy_interface);
 			return -ENOTSUPP;
 		}
 		val &= ~GMAC1_SHUT;
 	} else {
-		switch (plat_dat->interface) {
+		switch (plat_dat->phy_interface) {
 		case PHY_INTERFACE_MODE_RGMII:
 			val &= ~(GMAC0_USE_TXCLK | GMAC0_USE_PWM01);
 			break;
@@ -121,7 +121,7 @@ int ls1x_eth_mux_init(struct platform_device *pdev, void *priv)
 			break;
 		default:
 			pr_err("unsupported mii mode %d\n",
-			       plat_dat->interface);
+			       plat_dat->phy_interface);
 			return -ENOTSUPP;
 		}
 		val &= ~GMAC0_SHUT;
@@ -131,7 +131,7 @@ int ls1x_eth_mux_init(struct platform_device *pdev, void *priv)
 	plat_dat = dev_get_platdata(&pdev->dev);
 
 	val &= ~PHY_INTF_SELI;
-	if (plat_dat->interface == PHY_INTERFACE_MODE_RMII)
+	if (plat_dat->phy_interface == PHY_INTERFACE_MODE_RMII)
 		val |= 0x4 << PHY_INTF_SELI_SHIFT;
 	__raw_writel(val, LS1X_MUX_CTRL1);
 
@@ -146,9 +146,9 @@ static struct plat_stmmacenet_data ls1x_eth0_pdata = {
 	.bus_id			= 0,
 	.phy_addr		= -1,
 #if defined(CONFIG_LOONGSON1_LS1B)
-	.interface		= PHY_INTERFACE_MODE_MII,
+	.phy_interface		= PHY_INTERFACE_MODE_MII,
 #elif defined(CONFIG_LOONGSON1_LS1C)
-	.interface		= PHY_INTERFACE_MODE_RMII,
+	.phy_interface		= PHY_INTERFACE_MODE_RMII,
 #endif
 	.mdio_bus_data		= &ls1x_mdio_bus_data,
 	.dma_cfg		= &ls1x_eth_dma_cfg,
@@ -186,7 +186,7 @@ struct platform_device ls1x_eth0_pdev = {
 static struct plat_stmmacenet_data ls1x_eth1_pdata = {
 	.bus_id			= 1,
 	.phy_addr		= -1,
-	.interface		= PHY_INTERFACE_MODE_MII,
+	.phy_interface		= PHY_INTERFACE_MODE_MII,
 	.mdio_bus_data		= &ls1x_mdio_bus_data,
 	.dma_cfg		= &ls1x_eth_dma_cfg,
 	.has_gmac		= 1,
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index c2d5ecbe5526..f8fb85dc94b7 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -121,6 +121,8 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
+	regs->cause = -1UL;
+
 	return regs->a0;
 
 badframe:
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 960f5c35ad1b..8dc7ab1f3cd4 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -31,7 +31,7 @@
 #include <os.h>
 
 #define DEFAULT_COMMAND_LINE_ROOT "root=98:0"
-#define DEFAULT_COMMAND_LINE_CONSOLE "console=tty"
+#define DEFAULT_COMMAND_LINE_CONSOLE "console=tty0"
 
 /* Changed in add_arg and setup_arch, which run before SMP is started */
 static char __initdata command_line[COMMAND_LINE_SIZE] = { 0 };
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8496ffc67c32..3b4e1d8d239a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4122,6 +4122,9 @@ static int em_xsetbv(struct x86_emulate_ctxt *ctxt)
 {
 	u32 eax, ecx, edx;
 
+	if (!(ctxt->ops->get_cr(ctxt, 4) & X86_CR4_OSXSAVE))
+		return emulate_ud(ctxt);
+
 	eax = reg_read(ctxt, VCPU_REGS_RAX);
 	edx = reg_read(ctxt, VCPU_REGS_RDX);
 	ecx = reg_read(ctxt, VCPU_REGS_RCX);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f267cca9fe09..ba1749a770eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1071,20 +1071,6 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	return kvm_mmu_memory_cache_nr_free_objects(mc);
 }
 
-static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
-{
-	struct kvm_memory_slot *slot;
-	struct kvm_mmu_page *sp;
-	struct kvm_rmap_head *rmap_head;
-
-	sp = sptep_to_sp(spte);
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	return pte_list_add(vcpu, spte, rmap_head);
-}
-
-
 static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
 	struct kvm_memslots *slots;
@@ -1097,9 +1083,9 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 
 	/*
-	 * Unlike rmap_add and rmap_recycle, rmap_remove does not run in the
-	 * context of a vCPU so have to determine which memslots to use based
-	 * on context information in sp->role.
+	 * Unlike rmap_add, rmap_remove does not run in the context of a vCPU
+	 * so we have to determine which memslots to use based on context
+	 * information in sp->role.
 	 */
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 
@@ -1639,19 +1625,24 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
-	struct kvm_rmap_head *rmap_head;
 	struct kvm_mmu_page *sp;
+	struct kvm_rmap_head *rmap_head;
+	int rmap_count;
 
 	sp = sptep_to_sp(spte);
+	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_count = pte_list_add(vcpu, spte, rmap_head);
 
-	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
-	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
+	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
+		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		kvm_flush_remote_tlbs_with_address(
+				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+	}
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -2718,7 +2709,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			bool host_writable)
 {
 	int was_rmapped = 0;
-	int rmap_count;
 	int set_spte_ret;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
@@ -2778,9 +2768,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (!was_rmapped) {
 		kvm_update_page_stats(vcpu->kvm, level, 1);
-		rmap_count = rmap_add(vcpu, sptep, gfn);
-		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-			rmap_recycle(vcpu, sptep, gfn);
+		rmap_add(vcpu, sptep, gfn);
 	}
 
 	return ret;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 11e73d02fb3a..8648799d48f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1021,6 +1021,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
+	/* Note, #UD due to CR4.OSXSAVE=0 has priority over the intercept. */
 	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
 	    __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
 		kvm_inject_gp(vcpu, 0);
diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
index cb6401c9e9a4..acf31cc1dbcc 100644
--- a/drivers/dax/hmem/device.c
+++ b/drivers/dax/hmem/device.c
@@ -15,6 +15,7 @@ void hmem_register_device(int target_nid, struct resource *r)
 		.start = r->start,
 		.end = r->end,
 		.flags = IORESOURCE_MEM,
+		.desc = IORES_DESC_SOFT_RESERVED,
 	};
 	struct platform_device *pdev;
 	struct memregion_info info;
diff --git a/drivers/dma/ti/k3-udma-private.c b/drivers/dma/ti/k3-udma-private.c
index aada84f40723..3257b2f5157c 100644
--- a/drivers/dma/ti/k3-udma-private.c
+++ b/drivers/dma/ti/k3-udma-private.c
@@ -31,14 +31,14 @@ struct udma_dev *of_xudma_dev_get(struct device_node *np, const char *property)
 	}
 
 	pdev = of_find_device_by_node(udma_node);
+	if (np != udma_node)
+		of_node_put(udma_node);
+
 	if (!pdev) {
 		pr_debug("UDMA device not found\n");
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-	if (np != udma_node)
-		of_node_put(udma_node);
-
 	ud = platform_get_drvdata(pdev);
 	if (!ud) {
 		pr_debug("UDMA has not been probed\n");
diff --git a/drivers/firmware/arm_scmi/reset.c b/drivers/firmware/arm_scmi/reset.c
index 9bf2478ec6d1..e80a78205845 100644
--- a/drivers/firmware/arm_scmi/reset.c
+++ b/drivers/firmware/arm_scmi/reset.c
@@ -152,9 +152,13 @@ static int scmi_domain_reset(const struct scmi_protocol_handle *ph, u32 domain,
 	struct scmi_xfer *t;
 	struct scmi_msg_reset_domain_reset *dom;
 	struct scmi_reset_info *pi = ph->get_priv(ph);
-	struct reset_dom_info *rdom = pi->dom_info + domain;
+	struct reset_dom_info *rdom;
 
-	if (rdom->async_reset)
+	if (domain >= pi->num_domains)
+		return -EINVAL;
+
+	rdom = pi->dom_info + domain;
+	if (rdom->async_reset && flags & AUTONOMOUS_RESET)
 		flags |= ASYNCHRONOUS_RESET;
 
 	ret = ph->xops->xfer_get_init(ph, RESET, sizeof(*dom), 0, &t);
@@ -166,7 +170,7 @@ static int scmi_domain_reset(const struct scmi_protocol_handle *ph, u32 domain,
 	dom->flags = cpu_to_le32(flags);
 	dom->reset_state = cpu_to_le32(state);
 
-	if (rdom->async_reset)
+	if (flags & ASYNCHRONOUS_RESET)
 		ret = ph->xops->do_xfer_with_response(ph, t);
 	else
 		ret = ph->xops->do_xfer(ph, t);
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 8a18930f3eb6..516f4f0069bd 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -14,7 +14,7 @@
 
 /* SHIM variables */
 static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
-static const efi_char16_t shim_MokSBState_name[] = L"MokSBState";
+static const efi_char16_t shim_MokSBState_name[] = L"MokSBStateRT";
 
 static efi_status_t get_var(efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
 			    unsigned long *data_size, void *data)
@@ -43,8 +43,8 @@ enum efi_secureboot_mode efi_get_secureboot(void)
 
 	/*
 	 * See if a user has put the shim into insecure mode. If so, and if the
-	 * variable doesn't have the runtime attribute set, we might as well
-	 * honor that.
+	 * variable doesn't have the non-volatile attribute set, we might as
+	 * well honor that.
 	 */
 	size = sizeof(moksbstate);
 	status = get_efi_var(shim_MokSBState_name, &shim_guid,
@@ -53,7 +53,7 @@ enum efi_secureboot_mode efi_get_secureboot(void)
 	/* If it fails, we don't care why. Default to secure */
 	if (status != EFI_SUCCESS)
 		goto secure_boot_enabled;
-	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
+	if (!(attr & EFI_VARIABLE_NON_VOLATILE) && moksbstate == 1)
 		return efi_secureboot_mode_disabled;
 
 secure_boot_enabled:
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index f14c4ff5839f..72162645b553 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -414,6 +414,13 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	hdr->ramdisk_image = 0;
 	hdr->ramdisk_size = 0;
 
+	/*
+	 * Disregard any setup data that was provided by the bootloader:
+	 * setup_data could be pointing anywhere, and we have no way of
+	 * authenticating or validating the payload.
+	 */
+	hdr->setup_data = 0;
+
 	efi_stub_entry(handle, sys_table_arg, boot_params);
 	/* not reached */
 
diff --git a/drivers/gpio/gpio-mockup.c b/drivers/gpio/gpio-mockup.c
index 369a832d9620..0bded5853c41 100644
--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -554,8 +554,10 @@ static int __init gpio_mockup_register_chip(int idx)
 	}
 
 	fwnode = fwnode_create_software_node(properties, NULL);
-	if (IS_ERR(fwnode))
+	if (IS_ERR(fwnode)) {
+		kfree_strarray(line_names, ngpio);
 		return PTR_ERR(fwnode);
+	}
 
 	pdevinfo.name = "gpio-mockup";
 	pdevinfo.id = idx;
@@ -618,9 +620,9 @@ static int __init gpio_mockup_init(void)
 
 static void __exit gpio_mockup_exit(void)
 {
+	gpio_mockup_unregister_pdevs();
 	debugfs_remove_recursive(gpio_mockup_dbg_dir);
 	platform_driver_unregister(&gpio_mockup_driver);
-	gpio_mockup_unregister_pdevs();
 }
 
 module_init(gpio_mockup_init);
diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index ffa0256cad5a..937e7a8dd8a9 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1784,7 +1784,6 @@ static int lineevent_create(struct gpio_device *gdev, void __user *ip)
 		ret = -ENODEV;
 		goto out_free_le;
 	}
-	le->irq = irq;
 
 	if (eflags & GPIOEVENT_REQUEST_RISING_EDGE)
 		irqflags |= test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
@@ -1798,7 +1797,7 @@ static int lineevent_create(struct gpio_device *gdev, void __user *ip)
 	init_waitqueue_head(&le->wait);
 
 	/* Request a thread to read the events */
-	ret = request_threaded_irq(le->irq,
+	ret = request_threaded_irq(irq,
 				   lineevent_irq_handler,
 				   lineevent_irq_thread,
 				   irqflags,
@@ -1807,6 +1806,8 @@ static int lineevent_create(struct gpio_device *gdev, void __user *ip)
 	if (ret)
 		goto out_free_le;
 
+	le->irq = irq;
+
 	fd = get_unused_fd_flags(O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		ret = fd;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d1af709cc7dc..0e3137fd5c35 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2388,8 +2388,20 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 		}
 		adev->ip_blocks[i].status.sw = true;
 
-		/* need to do gmc hw init early so we can allocate gpu mem */
-		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
+		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_COMMON) {
+			/* need to do common hw init early so everything is set up for gmc */
+			r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
+			if (r) {
+				DRM_ERROR("hw_init %d failed %d\n", i, r);
+				goto init_failed;
+			}
+			adev->ip_blocks[i].status.hw = true;
+		} else if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
+			/* need to do gmc hw init early so we can allocate gpu mem */
+			/* Try to reserve bad pages early */
+			if (amdgpu_sriov_vf(adev))
+				amdgpu_virt_exchange_data(adev);
+
 			r = amdgpu_device_vram_scratch_init(adev);
 			if (r) {
 				DRM_ERROR("amdgpu_vram_scratch_init failed %d\n", r);
@@ -3033,8 +3045,8 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
 	int i, r;
 
 	static enum amd_ip_block_type ip_order[] = {
-		AMD_IP_BLOCK_TYPE_GMC,
 		AMD_IP_BLOCK_TYPE_COMMON,
+		AMD_IP_BLOCK_TYPE_GMC,
 		AMD_IP_BLOCK_TYPE_PSP,
 		AMD_IP_BLOCK_TYPE_IH,
 	};
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 5c08047adb59..d3d2c214554e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -35,6 +35,8 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <drm/drm_crtc_helper.h>
+#include <drm/drm_damage_helper.h>
+#include <drm/drm_drv.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -492,6 +494,12 @@ static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
 	.create_handle = drm_gem_fb_create_handle,
 };
 
+static const struct drm_framebuffer_funcs amdgpu_fb_funcs_atomic = {
+	.destroy = drm_gem_fb_destroy,
+	.create_handle = drm_gem_fb_create_handle,
+	.dirty = drm_atomic_helper_dirtyfb,
+};
+
 uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,
 					  uint64_t bo_flags)
 {
@@ -1109,7 +1117,10 @@ int amdgpu_display_gem_fb_verify_and_init(
 	if (ret)
 		goto err;
 
-	ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs);
+	if (drm_drv_uses_atomic_modeset(dev))
+		ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs_atomic);
+	else
+		ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs);
 	if (ret)
 		goto err;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 16787c675f35..a0803425b456 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -614,16 +614,34 @@ void amdgpu_virt_fini_data_exchange(struct amdgpu_device *adev)
 
 void amdgpu_virt_init_data_exchange(struct amdgpu_device *adev)
 {
-	uint64_t bp_block_offset = 0;
-	uint32_t bp_block_size = 0;
-	struct amd_sriov_msg_pf2vf_info *pf2vf_v2 = NULL;
-
 	adev->virt.fw_reserve.p_pf2vf = NULL;
 	adev->virt.fw_reserve.p_vf2pf = NULL;
 	adev->virt.vf2pf_update_interval_ms = 0;
 
 	if (adev->mman.fw_vram_usage_va != NULL) {
-		adev->virt.vf2pf_update_interval_ms = 2000;
+		/* go through this logic in ip_init and reset to init workqueue*/
+		amdgpu_virt_exchange_data(adev);
+
+		INIT_DELAYED_WORK(&adev->virt.vf2pf_work, amdgpu_virt_update_vf2pf_work_item);
+		schedule_delayed_work(&(adev->virt.vf2pf_work), msecs_to_jiffies(adev->virt.vf2pf_update_interval_ms));
+	} else if (adev->bios != NULL) {
+		/* got through this logic in early init stage to get necessary flags, e.g. rlcg_acc related*/
+		adev->virt.fw_reserve.p_pf2vf =
+			(struct amd_sriov_msg_pf2vf_info_header *)
+			(adev->bios + (AMD_SRIOV_MSG_PF2VF_OFFSET_KB << 10));
+
+		amdgpu_virt_read_pf2vf_data(adev);
+	}
+}
+
+
+void amdgpu_virt_exchange_data(struct amdgpu_device *adev)
+{
+	uint64_t bp_block_offset = 0;
+	uint32_t bp_block_size = 0;
+	struct amd_sriov_msg_pf2vf_info *pf2vf_v2 = NULL;
+
+	if (adev->mman.fw_vram_usage_va != NULL) {
 
 		adev->virt.fw_reserve.p_pf2vf =
 			(struct amd_sriov_msg_pf2vf_info_header *)
@@ -649,22 +667,10 @@ void amdgpu_virt_init_data_exchange(struct amdgpu_device *adev)
 				if (adev->virt.ras_init_done)
 					amdgpu_virt_add_bad_page(adev, bp_block_offset, bp_block_size);
 			}
-	} else if (adev->bios != NULL) {
-		adev->virt.fw_reserve.p_pf2vf =
-			(struct amd_sriov_msg_pf2vf_info_header *)
-			(adev->bios + (AMD_SRIOV_MSG_PF2VF_OFFSET_KB << 10));
-
-		amdgpu_virt_read_pf2vf_data(adev);
-
-		return;
-	}
-
-	if (adev->virt.vf2pf_update_interval_ms != 0) {
-		INIT_DELAYED_WORK(&adev->virt.vf2pf_work, amdgpu_virt_update_vf2pf_work_item);
-		schedule_delayed_work(&(adev->virt.vf2pf_work), adev->virt.vf2pf_update_interval_ms);
 	}
 }
 
+
 void amdgpu_detect_virtualization(struct amdgpu_device *adev)
 {
 	uint32_t reg;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 8d4c20bb71c5..9adfb8d63280 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -308,6 +308,7 @@ int amdgpu_virt_alloc_mm_table(struct amdgpu_device *adev);
 void amdgpu_virt_free_mm_table(struct amdgpu_device *adev);
 void amdgpu_virt_release_ras_err_handler_data(struct amdgpu_device *adev);
 void amdgpu_virt_init_data_exchange(struct amdgpu_device *adev);
+void amdgpu_virt_exchange_data(struct amdgpu_device *adev);
 void amdgpu_virt_fini_data_exchange(struct amdgpu_device *adev);
 void amdgpu_detect_virtualization(struct amdgpu_device *adev);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index e3d9f1decdfc..518672a2450f 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -6658,8 +6658,7 @@ static double CalculateUrgentLatency(
 	return ret;
 }
 
-
-static void UseMinimumDCFCLK(
+static noinline_for_stack void UseMinimumDCFCLK(
 		struct display_mode_lib *mode_lib,
 		int MaxInterDCNTileRepeaters,
 		int MaxPrefetchMode,
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
index d58925cff420..aa0507e01792 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
@@ -259,33 +259,13 @@ static void CalculateRowBandwidth(
 
 static void CalculateFlipSchedule(
 		struct display_mode_lib *mode_lib,
+		unsigned int k,
 		double HostVMInefficiencyFactor,
 		double UrgentExtraLatency,
 		double UrgentLatency,
-		unsigned int GPUVMMaxPageTableLevels,
-		bool HostVMEnable,
-		unsigned int HostVMMaxNonCachedPageTableLevels,
-		bool GPUVMEnable,
-		double HostVMMinPageSize,
 		double PDEAndMetaPTEBytesPerFrame,
 		double MetaRowBytes,
-		double DPTEBytesPerRow,
-		double BandwidthAvailableForImmediateFlip,
-		unsigned int TotImmediateFlipBytes,
-		enum source_format_class SourcePixelFormat,
-		double LineTime,
-		double VRatio,
-		double VRatioChroma,
-		double Tno_bw,
-		bool DCCEnable,
-		unsigned int dpte_row_height,
-		unsigned int meta_row_height,
-		unsigned int dpte_row_height_chroma,
-		unsigned int meta_row_height_chroma,
-		double *DestinationLinesToRequestVMInImmediateFlip,
-		double *DestinationLinesToRequestRowInImmediateFlip,
-		double *final_flip_bw,
-		bool *ImmediateFlipSupportedForPipe);
+		double DPTEBytesPerRow);
 static double CalculateWriteBackDelay(
 		enum source_format_class WritebackPixelFormat,
 		double WritebackHRatio,
@@ -319,64 +299,28 @@ static void CalculateVupdateAndDynamicMetadataParameters(
 static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 		struct display_mode_lib *mode_lib,
 		unsigned int PrefetchMode,
-		unsigned int NumberOfActivePlanes,
-		unsigned int MaxLineBufferLines,
-		unsigned int LineBufferSize,
-		unsigned int WritebackInterfaceBufferSize,
 		double DCFCLK,
 		double ReturnBW,
-		bool SynchronizedVBlank,
-		unsigned int dpte_group_bytes[],
-		unsigned int MetaChunkSize,
 		double UrgentLatency,
 		double ExtraLatency,
-		double WritebackLatency,
-		double WritebackChunkSize,
 		double SOCCLK,
-		double DRAMClockChangeLatency,
-		double SRExitTime,
-		double SREnterPlusExitTime,
-		double SRExitZ8Time,
-		double SREnterPlusExitZ8Time,
 		double DCFCLKDeepSleep,
 		unsigned int DETBufferSizeY[],
 		unsigned int DETBufferSizeC[],
 		unsigned int SwathHeightY[],
 		unsigned int SwathHeightC[],
-		unsigned int LBBitPerPixel[],
 		double SwathWidthY[],
 		double SwathWidthC[],
-		double HRatio[],
-		double HRatioChroma[],
-		unsigned int vtaps[],
-		unsigned int VTAPsChroma[],
-		double VRatio[],
-		double VRatioChroma[],
-		unsigned int HTotal[],
-		double PixelClock[],
-		unsigned int BlendingAndTiming[],
 		unsigned int DPPPerPlane[],
 		double BytePerPixelDETY[],
 		double BytePerPixelDETC[],
-		double DSTXAfterScaler[],
-		double DSTYAfterScaler[],
-		bool WritebackEnable[],
-		enum source_format_class WritebackPixelFormat[],
-		double WritebackDestinationWidth[],
-		double WritebackDestinationHeight[],
-		double WritebackSourceHeight[],
 		bool UnboundedRequestEnabled,
 		int unsigned CompressedBufferSizeInkByte,
 		enum clock_change_support *DRAMClockChangeSupport,
-		double *UrgentWatermark,
-		double *WritebackUrgentWatermark,
-		double *DRAMClockChangeWatermark,
-		double *WritebackDRAMClockChangeWatermark,
 		double *StutterExitWatermark,
 		double *StutterEnterPlusExitWatermark,
 		double *Z8StutterExitWatermark,
-		double *Z8StutterEnterPlusExitWatermark,
-		double *MinActiveDRAMClockChangeLatencySupported);
+		double *Z8StutterEnterPlusExitWatermark);
 
 static void CalculateDCFCLKDeepSleep(
 		struct display_mode_lib *mode_lib,
@@ -2959,33 +2903,13 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 			for (k = 0; k < v->NumberOfActivePlanes; ++k) {
 				CalculateFlipSchedule(
 						mode_lib,
+						k,
 						HostVMInefficiencyFactor,
 						v->UrgentExtraLatency,
 						v->UrgentLatency,
-						v->GPUVMMaxPageTableLevels,
-						v->HostVMEnable,
-						v->HostVMMaxNonCachedPageTableLevels,
-						v->GPUVMEnable,
-						v->HostVMMinPageSize,
 						v->PDEAndMetaPTEBytesFrame[k],
 						v->MetaRowByte[k],
-						v->PixelPTEBytesPerRow[k],
-						v->BandwidthAvailableForImmediateFlip,
-						v->TotImmediateFlipBytes,
-						v->SourcePixelFormat[k],
-						v->HTotal[k] / v->PixelClock[k],
-						v->VRatio[k],
-						v->VRatioChroma[k],
-						v->Tno_bw[k],
-						v->DCCEnable[k],
-						v->dpte_row_height[k],
-						v->meta_row_height[k],
-						v->dpte_row_height_chroma[k],
-						v->meta_row_height_chroma[k],
-						&v->DestinationLinesToRequestVMInImmediateFlip[k],
-						&v->DestinationLinesToRequestRowInImmediateFlip[k],
-						&v->final_flip_bw[k],
-						&v->ImmediateFlipSupportedForPipe[k]);
+						v->PixelPTEBytesPerRow[k]);
 			}
 
 			v->total_dcn_read_bw_with_flip = 0.0;
@@ -3072,64 +2996,28 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 		CalculateWatermarksAndDRAMSpeedChangeSupport(
 				mode_lib,
 				PrefetchMode,
-				v->NumberOfActivePlanes,
-				v->MaxLineBufferLines,
-				v->LineBufferSize,
-				v->WritebackInterfaceBufferSize,
 				v->DCFCLK,
 				v->ReturnBW,
-				v->SynchronizedVBlank,
-				v->dpte_group_bytes,
-				v->MetaChunkSize,
 				v->UrgentLatency,
 				v->UrgentExtraLatency,
-				v->WritebackLatency,
-				v->WritebackChunkSize,
 				v->SOCCLK,
-				v->DRAMClockChangeLatency,
-				v->SRExitTime,
-				v->SREnterPlusExitTime,
-				v->SRExitZ8Time,
-				v->SREnterPlusExitZ8Time,
 				v->DCFCLKDeepSleep,
 				v->DETBufferSizeY,
 				v->DETBufferSizeC,
 				v->SwathHeightY,
 				v->SwathHeightC,
-				v->LBBitPerPixel,
 				v->SwathWidthY,
 				v->SwathWidthC,
-				v->HRatio,
-				v->HRatioChroma,
-				v->vtaps,
-				v->VTAPsChroma,
-				v->VRatio,
-				v->VRatioChroma,
-				v->HTotal,
-				v->PixelClock,
-				v->BlendingAndTiming,
 				v->DPPPerPlane,
 				v->BytePerPixelDETY,
 				v->BytePerPixelDETC,
-				v->DSTXAfterScaler,
-				v->DSTYAfterScaler,
-				v->WritebackEnable,
-				v->WritebackPixelFormat,
-				v->WritebackDestinationWidth,
-				v->WritebackDestinationHeight,
-				v->WritebackSourceHeight,
 				v->UnboundedRequestEnabled,
 				v->CompressedBufferSizeInkByte,
 				&DRAMClockChangeSupport,
-				&v->UrgentWatermark,
-				&v->WritebackUrgentWatermark,
-				&v->DRAMClockChangeWatermark,
-				&v->WritebackDRAMClockChangeWatermark,
 				&v->StutterExitWatermark,
 				&v->StutterEnterPlusExitWatermark,
 				&v->Z8StutterExitWatermark,
-				&v->Z8StutterEnterPlusExitWatermark,
-				&v->MinActiveDRAMClockChangeLatencySupported);
+				&v->Z8StutterEnterPlusExitWatermark);
 
 		for (k = 0; k < v->NumberOfActivePlanes; ++k) {
 			if (v->WritebackEnable[k] == true) {
@@ -3741,61 +3629,43 @@ static void CalculateRowBandwidth(
 
 static void CalculateFlipSchedule(
 		struct display_mode_lib *mode_lib,
+		unsigned int k,
 		double HostVMInefficiencyFactor,
 		double UrgentExtraLatency,
 		double UrgentLatency,
-		unsigned int GPUVMMaxPageTableLevels,
-		bool HostVMEnable,
-		unsigned int HostVMMaxNonCachedPageTableLevels,
-		bool GPUVMEnable,
-		double HostVMMinPageSize,
 		double PDEAndMetaPTEBytesPerFrame,
 		double MetaRowBytes,
-		double DPTEBytesPerRow,
-		double BandwidthAvailableForImmediateFlip,
-		unsigned int TotImmediateFlipBytes,
-		enum source_format_class SourcePixelFormat,
-		double LineTime,
-		double VRatio,
-		double VRatioChroma,
-		double Tno_bw,
-		bool DCCEnable,
-		unsigned int dpte_row_height,
-		unsigned int meta_row_height,
-		unsigned int dpte_row_height_chroma,
-		unsigned int meta_row_height_chroma,
-		double *DestinationLinesToRequestVMInImmediateFlip,
-		double *DestinationLinesToRequestRowInImmediateFlip,
-		double *final_flip_bw,
-		bool *ImmediateFlipSupportedForPipe)
+		double DPTEBytesPerRow)
 {
+	struct vba_vars_st *v = &mode_lib->vba;
 	double min_row_time = 0.0;
 	unsigned int HostVMDynamicLevelsTrips;
 	double TimeForFetchingMetaPTEImmediateFlip;
 	double TimeForFetchingRowInVBlankImmediateFlip;
 	double ImmediateFlipBW;
+	double LineTime = v->HTotal[k] / v->PixelClock[k];
 
-	if (GPUVMEnable == true && HostVMEnable == true) {
-		HostVMDynamicLevelsTrips = HostVMMaxNonCachedPageTableLevels;
+	if (v->GPUVMEnable == true && v->HostVMEnable == true) {
+		HostVMDynamicLevelsTrips = v->HostVMMaxNonCachedPageTableLevels;
 	} else {
 		HostVMDynamicLevelsTrips = 0;
 	}
 
-	if (GPUVMEnable == true || DCCEnable == true) {
-		ImmediateFlipBW = (PDEAndMetaPTEBytesPerFrame + MetaRowBytes + DPTEBytesPerRow) * BandwidthAvailableForImmediateFlip / TotImmediateFlipBytes;
+	if (v->GPUVMEnable == true || v->DCCEnable[k] == true) {
+		ImmediateFlipBW = (PDEAndMetaPTEBytesPerFrame + MetaRowBytes + DPTEBytesPerRow) * v->BandwidthAvailableForImmediateFlip / v->TotImmediateFlipBytes;
 	}
 
-	if (GPUVMEnable == true) {
+	if (v->GPUVMEnable == true) {
 		TimeForFetchingMetaPTEImmediateFlip = dml_max3(
-				Tno_bw + PDEAndMetaPTEBytesPerFrame * HostVMInefficiencyFactor / ImmediateFlipBW,
-				UrgentExtraLatency + UrgentLatency * (GPUVMMaxPageTableLevels * (HostVMDynamicLevelsTrips + 1) - 1),
+				v->Tno_bw[k] + PDEAndMetaPTEBytesPerFrame * HostVMInefficiencyFactor / ImmediateFlipBW,
+				UrgentExtraLatency + UrgentLatency * (v->GPUVMMaxPageTableLevels * (HostVMDynamicLevelsTrips + 1) - 1),
 				LineTime / 4.0);
 	} else {
 		TimeForFetchingMetaPTEImmediateFlip = 0;
 	}
 
-	*DestinationLinesToRequestVMInImmediateFlip = dml_ceil(4.0 * (TimeForFetchingMetaPTEImmediateFlip / LineTime), 1) / 4.0;
-	if ((GPUVMEnable == true || DCCEnable == true)) {
+	v->DestinationLinesToRequestVMInImmediateFlip[k] = dml_ceil(4.0 * (TimeForFetchingMetaPTEImmediateFlip / LineTime), 1) / 4.0;
+	if ((v->GPUVMEnable == true || v->DCCEnable[k] == true)) {
 		TimeForFetchingRowInVBlankImmediateFlip = dml_max3(
 				(MetaRowBytes + DPTEBytesPerRow * HostVMInefficiencyFactor) / ImmediateFlipBW,
 				UrgentLatency * (HostVMDynamicLevelsTrips + 1),
@@ -3804,54 +3674,54 @@ static void CalculateFlipSchedule(
 		TimeForFetchingRowInVBlankImmediateFlip = 0;
 	}
 
-	*DestinationLinesToRequestRowInImmediateFlip = dml_ceil(4.0 * (TimeForFetchingRowInVBlankImmediateFlip / LineTime), 1) / 4.0;
+	v->DestinationLinesToRequestRowInImmediateFlip[k] = dml_ceil(4.0 * (TimeForFetchingRowInVBlankImmediateFlip / LineTime), 1) / 4.0;
 
-	if (GPUVMEnable == true) {
-		*final_flip_bw = dml_max(
-				PDEAndMetaPTEBytesPerFrame * HostVMInefficiencyFactor / (*DestinationLinesToRequestVMInImmediateFlip * LineTime),
-				(MetaRowBytes + DPTEBytesPerRow * HostVMInefficiencyFactor) / (*DestinationLinesToRequestRowInImmediateFlip * LineTime));
-	} else if ((GPUVMEnable == true || DCCEnable == true)) {
-		*final_flip_bw = (MetaRowBytes + DPTEBytesPerRow * HostVMInefficiencyFactor) / (*DestinationLinesToRequestRowInImmediateFlip * LineTime);
+	if (v->GPUVMEnable == true) {
+		v->final_flip_bw[k] = dml_max(
+				PDEAndMetaPTEBytesPerFrame * HostVMInefficiencyFactor / (v->DestinationLinesToRequestVMInImmediateFlip[k] * LineTime),
+				(MetaRowBytes + DPTEBytesPerRow * HostVMInefficiencyFactor) / (v->DestinationLinesToRequestRowInImmediateFlip[k] * LineTime));
+	} else if ((v->GPUVMEnable == true || v->DCCEnable[k] == true)) {
+		v->final_flip_bw[k] = (MetaRowBytes + DPTEBytesPerRow * HostVMInefficiencyFactor) / (v->DestinationLinesToRequestRowInImmediateFlip[k] * LineTime);
 	} else {
-		*final_flip_bw = 0;
+		v->final_flip_bw[k] = 0;
 	}
 
-	if (SourcePixelFormat == dm_420_8 || SourcePixelFormat == dm_420_10 || SourcePixelFormat == dm_rgbe_alpha) {
-		if (GPUVMEnable == true && DCCEnable != true) {
-			min_row_time = dml_min(dpte_row_height * LineTime / VRatio, dpte_row_height_chroma * LineTime / VRatioChroma);
-		} else if (GPUVMEnable != true && DCCEnable == true) {
-			min_row_time = dml_min(meta_row_height * LineTime / VRatio, meta_row_height_chroma * LineTime / VRatioChroma);
+	if (v->SourcePixelFormat[k] == dm_420_8 || v->SourcePixelFormat[k] == dm_420_10 || v->SourcePixelFormat[k] == dm_rgbe_alpha) {
+		if (v->GPUVMEnable == true && v->DCCEnable[k] != true) {
+			min_row_time = dml_min(v->dpte_row_height[k] * LineTime / v->VRatio[k], v->dpte_row_height_chroma[k] * LineTime / v->VRatioChroma[k]);
+		} else if (v->GPUVMEnable != true && v->DCCEnable[k] == true) {
+			min_row_time = dml_min(v->meta_row_height[k] * LineTime / v->VRatio[k], v->meta_row_height_chroma[k] * LineTime / v->VRatioChroma[k]);
 		} else {
 			min_row_time = dml_min4(
-					dpte_row_height * LineTime / VRatio,
-					meta_row_height * LineTime / VRatio,
-					dpte_row_height_chroma * LineTime / VRatioChroma,
-					meta_row_height_chroma * LineTime / VRatioChroma);
+					v->dpte_row_height[k] * LineTime / v->VRatio[k],
+					v->meta_row_height[k] * LineTime / v->VRatio[k],
+					v->dpte_row_height_chroma[k] * LineTime / v->VRatioChroma[k],
+					v->meta_row_height_chroma[k] * LineTime / v->VRatioChroma[k]);
 		}
 	} else {
-		if (GPUVMEnable == true && DCCEnable != true) {
-			min_row_time = dpte_row_height * LineTime / VRatio;
-		} else if (GPUVMEnable != true && DCCEnable == true) {
-			min_row_time = meta_row_height * LineTime / VRatio;
+		if (v->GPUVMEnable == true && v->DCCEnable[k] != true) {
+			min_row_time = v->dpte_row_height[k] * LineTime / v->VRatio[k];
+		} else if (v->GPUVMEnable != true && v->DCCEnable[k] == true) {
+			min_row_time = v->meta_row_height[k] * LineTime / v->VRatio[k];
 		} else {
-			min_row_time = dml_min(dpte_row_height * LineTime / VRatio, meta_row_height * LineTime / VRatio);
+			min_row_time = dml_min(v->dpte_row_height[k] * LineTime / v->VRatio[k], v->meta_row_height[k] * LineTime / v->VRatio[k]);
 		}
 	}
 
-	if (*DestinationLinesToRequestVMInImmediateFlip >= 32 || *DestinationLinesToRequestRowInImmediateFlip >= 16
+	if (v->DestinationLinesToRequestVMInImmediateFlip[k] >= 32 || v->DestinationLinesToRequestRowInImmediateFlip[k] >= 16
 			|| TimeForFetchingMetaPTEImmediateFlip + 2 * TimeForFetchingRowInVBlankImmediateFlip > min_row_time) {
-		*ImmediateFlipSupportedForPipe = false;
+		v->ImmediateFlipSupportedForPipe[k] = false;
 	} else {
-		*ImmediateFlipSupportedForPipe = true;
+		v->ImmediateFlipSupportedForPipe[k] = true;
 	}
 
 #ifdef __DML_VBA_DEBUG__
-	dml_print("DML::%s: DestinationLinesToRequestVMInImmediateFlip = %f\n", __func__, *DestinationLinesToRequestVMInImmediateFlip);
-	dml_print("DML::%s: DestinationLinesToRequestRowInImmediateFlip = %f\n", __func__, *DestinationLinesToRequestRowInImmediateFlip);
+	dml_print("DML::%s: DestinationLinesToRequestVMInImmediateFlip = %f\n", __func__, v->DestinationLinesToRequestVMInImmediateFlip[k]);
+	dml_print("DML::%s: DestinationLinesToRequestRowInImmediateFlip = %f\n", __func__, v->DestinationLinesToRequestRowInImmediateFlip[k]);
 	dml_print("DML::%s: TimeForFetchingMetaPTEImmediateFlip = %f\n", __func__, TimeForFetchingMetaPTEImmediateFlip);
 	dml_print("DML::%s: TimeForFetchingRowInVBlankImmediateFlip = %f\n", __func__, TimeForFetchingRowInVBlankImmediateFlip);
 	dml_print("DML::%s: min_row_time = %f\n", __func__, min_row_time);
-	dml_print("DML::%s: ImmediateFlipSupportedForPipe = %d\n", __func__, *ImmediateFlipSupportedForPipe);
+	dml_print("DML::%s: ImmediateFlipSupportedForPipe = %d\n", __func__, v->ImmediateFlipSupportedForPipe[k]);
 #endif
 
 }
@@ -5477,33 +5347,13 @@ void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 					for (k = 0; k < v->NumberOfActivePlanes; k++) {
 						CalculateFlipSchedule(
 								mode_lib,
+								k,
 								HostVMInefficiencyFactor,
 								v->ExtraLatency,
 								v->UrgLatency[i],
-								v->GPUVMMaxPageTableLevels,
-								v->HostVMEnable,
-								v->HostVMMaxNonCachedPageTableLevels,
-								v->GPUVMEnable,
-								v->HostVMMinPageSize,
 								v->PDEAndMetaPTEBytesPerFrame[i][j][k],
 								v->MetaRowBytes[i][j][k],
-								v->DPTEBytesPerRow[i][j][k],
-								v->BandwidthAvailableForImmediateFlip,
-								v->TotImmediateFlipBytes,
-								v->SourcePixelFormat[k],
-								v->HTotal[k] / v->PixelClock[k],
-								v->VRatio[k],
-								v->VRatioChroma[k],
-								v->Tno_bw[k],
-								v->DCCEnable[k],
-								v->dpte_row_height[k],
-								v->meta_row_height[k],
-								v->dpte_row_height_chroma[k],
-								v->meta_row_height_chroma[k],
-								&v->DestinationLinesToRequestVMInImmediateFlip[k],
-								&v->DestinationLinesToRequestRowInImmediateFlip[k],
-								&v->final_flip_bw[k],
-								&v->ImmediateFlipSupportedForPipe[k]);
+								v->DPTEBytesPerRow[i][j][k]);
 					}
 					v->total_dcn_read_bw_with_flip = 0.0;
 					for (k = 0; k < v->NumberOfActivePlanes; k++) {
@@ -5561,64 +5411,28 @@ void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 			CalculateWatermarksAndDRAMSpeedChangeSupport(
 					mode_lib,
 					v->PrefetchModePerState[i][j],
-					v->NumberOfActivePlanes,
-					v->MaxLineBufferLines,
-					v->LineBufferSize,
-					v->WritebackInterfaceBufferSize,
 					v->DCFCLKState[i][j],
 					v->ReturnBWPerState[i][j],
-					v->SynchronizedVBlank,
-					v->dpte_group_bytes,
-					v->MetaChunkSize,
 					v->UrgLatency[i],
 					v->ExtraLatency,
-					v->WritebackLatency,
-					v->WritebackChunkSize,
 					v->SOCCLKPerState[i],
-					v->DRAMClockChangeLatency,
-					v->SRExitTime,
-					v->SREnterPlusExitTime,
-					v->SRExitZ8Time,
-					v->SREnterPlusExitZ8Time,
 					v->ProjectedDCFCLKDeepSleep[i][j],
 					v->DETBufferSizeYThisState,
 					v->DETBufferSizeCThisState,
 					v->SwathHeightYThisState,
 					v->SwathHeightCThisState,
-					v->LBBitPerPixel,
 					v->SwathWidthYThisState,
 					v->SwathWidthCThisState,
-					v->HRatio,
-					v->HRatioChroma,
-					v->vtaps,
-					v->VTAPsChroma,
-					v->VRatio,
-					v->VRatioChroma,
-					v->HTotal,
-					v->PixelClock,
-					v->BlendingAndTiming,
 					v->NoOfDPPThisState,
 					v->BytePerPixelInDETY,
 					v->BytePerPixelInDETC,
-					v->DSTXAfterScaler,
-					v->DSTYAfterScaler,
-					v->WritebackEnable,
-					v->WritebackPixelFormat,
-					v->WritebackDestinationWidth,
-					v->WritebackDestinationHeight,
-					v->WritebackSourceHeight,
 					UnboundedRequestEnabledThisState,
 					CompressedBufferSizeInkByteThisState,
 					&v->DRAMClockChangeSupport[i][j],
-					&v->UrgentWatermark,
-					&v->WritebackUrgentWatermark,
-					&v->DRAMClockChangeWatermark,
-					&v->WritebackDRAMClockChangeWatermark,
-					&dummy,
 					&dummy,
 					&dummy,
 					&dummy,
-					&v->MinActiveDRAMClockChangeLatencySupported);
+					&dummy);
 		}
 	}
 
@@ -5743,64 +5557,28 @@ void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 		struct display_mode_lib *mode_lib,
 		unsigned int PrefetchMode,
-		unsigned int NumberOfActivePlanes,
-		unsigned int MaxLineBufferLines,
-		unsigned int LineBufferSize,
-		unsigned int WritebackInterfaceBufferSize,
 		double DCFCLK,
 		double ReturnBW,
-		bool SynchronizedVBlank,
-		unsigned int dpte_group_bytes[],
-		unsigned int MetaChunkSize,
 		double UrgentLatency,
 		double ExtraLatency,
-		double WritebackLatency,
-		double WritebackChunkSize,
 		double SOCCLK,
-		double DRAMClockChangeLatency,
-		double SRExitTime,
-		double SREnterPlusExitTime,
-		double SRExitZ8Time,
-		double SREnterPlusExitZ8Time,
 		double DCFCLKDeepSleep,
 		unsigned int DETBufferSizeY[],
 		unsigned int DETBufferSizeC[],
 		unsigned int SwathHeightY[],
 		unsigned int SwathHeightC[],
-		unsigned int LBBitPerPixel[],
 		double SwathWidthY[],
 		double SwathWidthC[],
-		double HRatio[],
-		double HRatioChroma[],
-		unsigned int vtaps[],
-		unsigned int VTAPsChroma[],
-		double VRatio[],
-		double VRatioChroma[],
-		unsigned int HTotal[],
-		double PixelClock[],
-		unsigned int BlendingAndTiming[],
 		unsigned int DPPPerPlane[],
 		double BytePerPixelDETY[],
 		double BytePerPixelDETC[],
-		double DSTXAfterScaler[],
-		double DSTYAfterScaler[],
-		bool WritebackEnable[],
-		enum source_format_class WritebackPixelFormat[],
-		double WritebackDestinationWidth[],
-		double WritebackDestinationHeight[],
-		double WritebackSourceHeight[],
 		bool UnboundedRequestEnabled,
 		int unsigned CompressedBufferSizeInkByte,
 		enum clock_change_support *DRAMClockChangeSupport,
-		double *UrgentWatermark,
-		double *WritebackUrgentWatermark,
-		double *DRAMClockChangeWatermark,
-		double *WritebackDRAMClockChangeWatermark,
 		double *StutterExitWatermark,
 		double *StutterEnterPlusExitWatermark,
 		double *Z8StutterExitWatermark,
-		double *Z8StutterEnterPlusExitWatermark,
-		double *MinActiveDRAMClockChangeLatencySupported)
+		double *Z8StutterEnterPlusExitWatermark)
 {
 	struct vba_vars_st *v = &mode_lib->vba;
 	double EffectiveLBLatencyHidingY;
@@ -5820,103 +5598,103 @@ static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 	double TotalPixelBW = 0.0;
 	int k, j;
 
-	*UrgentWatermark = UrgentLatency + ExtraLatency;
+	v->UrgentWatermark = UrgentLatency + ExtraLatency;
 
 #ifdef __DML_VBA_DEBUG__
 	dml_print("DML::%s: UrgentLatency = %f\n", __func__, UrgentLatency);
 	dml_print("DML::%s: ExtraLatency = %f\n", __func__, ExtraLatency);
-	dml_print("DML::%s: UrgentWatermark = %f\n", __func__, *UrgentWatermark);
+	dml_print("DML::%s: UrgentWatermark = %f\n", __func__, v->UrgentWatermark);
 #endif
 
-	*DRAMClockChangeWatermark = DRAMClockChangeLatency + *UrgentWatermark;
+	v->DRAMClockChangeWatermark = v->DRAMClockChangeLatency + v->UrgentWatermark;
 
 #ifdef __DML_VBA_DEBUG__
-	dml_print("DML::%s: DRAMClockChangeLatency = %f\n", __func__, DRAMClockChangeLatency);
-	dml_print("DML::%s: DRAMClockChangeWatermark = %f\n", __func__, *DRAMClockChangeWatermark);
+	dml_print("DML::%s: v->DRAMClockChangeLatency = %f\n", __func__, v->DRAMClockChangeLatency);
+	dml_print("DML::%s: DRAMClockChangeWatermark = %f\n", __func__, v->DRAMClockChangeWatermark);
 #endif
 
 	v->TotalActiveWriteback = 0;
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
-		if (WritebackEnable[k] == true) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
+		if (v->WritebackEnable[k] == true) {
 			v->TotalActiveWriteback = v->TotalActiveWriteback + 1;
 		}
 	}
 
 	if (v->TotalActiveWriteback <= 1) {
-		*WritebackUrgentWatermark = WritebackLatency;
+		v->WritebackUrgentWatermark = v->WritebackLatency;
 	} else {
-		*WritebackUrgentWatermark = WritebackLatency + WritebackChunkSize * 1024.0 / 32.0 / SOCCLK;
+		v->WritebackUrgentWatermark = v->WritebackLatency + v->WritebackChunkSize * 1024.0 / 32.0 / SOCCLK;
 	}
 
 	if (v->TotalActiveWriteback <= 1) {
-		*WritebackDRAMClockChangeWatermark = DRAMClockChangeLatency + WritebackLatency;
+		v->WritebackDRAMClockChangeWatermark = v->DRAMClockChangeLatency + v->WritebackLatency;
 	} else {
-		*WritebackDRAMClockChangeWatermark = DRAMClockChangeLatency + WritebackLatency + WritebackChunkSize * 1024.0 / 32.0 / SOCCLK;
+		v->WritebackDRAMClockChangeWatermark = v->DRAMClockChangeLatency + v->WritebackLatency + v->WritebackChunkSize * 1024.0 / 32.0 / SOCCLK;
 	}
 
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
 		TotalPixelBW = TotalPixelBW
-				+ DPPPerPlane[k] * (SwathWidthY[k] * BytePerPixelDETY[k] * VRatio[k] + SwathWidthC[k] * BytePerPixelDETC[k] * VRatioChroma[k])
-						/ (HTotal[k] / PixelClock[k]);
+				+ DPPPerPlane[k] * (SwathWidthY[k] * BytePerPixelDETY[k] * v->VRatio[k] + SwathWidthC[k] * BytePerPixelDETC[k] * v->VRatioChroma[k])
+						/ (v->HTotal[k] / v->PixelClock[k]);
 	}
 
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
 		double EffectiveDETBufferSizeY = DETBufferSizeY[k];
 
 		v->LBLatencyHidingSourceLinesY = dml_min(
-				(double) MaxLineBufferLines,
-				dml_floor(LineBufferSize / LBBitPerPixel[k] / (SwathWidthY[k] / dml_max(HRatio[k], 1.0)), 1)) - (vtaps[k] - 1);
+				(double) v->MaxLineBufferLines,
+				dml_floor(v->LineBufferSize / v->LBBitPerPixel[k] / (SwathWidthY[k] / dml_max(v->HRatio[k], 1.0)), 1)) - (v->vtaps[k] - 1);
 
 		v->LBLatencyHidingSourceLinesC = dml_min(
-				(double) MaxLineBufferLines,
-				dml_floor(LineBufferSize / LBBitPerPixel[k] / (SwathWidthC[k] / dml_max(HRatioChroma[k], 1.0)), 1)) - (VTAPsChroma[k] - 1);
+				(double) v->MaxLineBufferLines,
+				dml_floor(v->LineBufferSize / v->LBBitPerPixel[k] / (SwathWidthC[k] / dml_max(v->HRatioChroma[k], 1.0)), 1)) - (v->VTAPsChroma[k] - 1);
 
-		EffectiveLBLatencyHidingY = v->LBLatencyHidingSourceLinesY / VRatio[k] * (HTotal[k] / PixelClock[k]);
+		EffectiveLBLatencyHidingY = v->LBLatencyHidingSourceLinesY / v->VRatio[k] * (v->HTotal[k] / v->PixelClock[k]);
 
-		EffectiveLBLatencyHidingC = v->LBLatencyHidingSourceLinesC / VRatioChroma[k] * (HTotal[k] / PixelClock[k]);
+		EffectiveLBLatencyHidingC = v->LBLatencyHidingSourceLinesC / v->VRatioChroma[k] * (v->HTotal[k] / v->PixelClock[k]);
 
 		if (UnboundedRequestEnabled) {
 			EffectiveDETBufferSizeY = EffectiveDETBufferSizeY
-					+ CompressedBufferSizeInkByte * 1024 * SwathWidthY[k] * BytePerPixelDETY[k] * VRatio[k] / (HTotal[k] / PixelClock[k]) / TotalPixelBW;
+					+ CompressedBufferSizeInkByte * 1024 * SwathWidthY[k] * BytePerPixelDETY[k] * v->VRatio[k] / (v->HTotal[k] / v->PixelClock[k]) / TotalPixelBW;
 		}
 
 		LinesInDETY[k] = (double) EffectiveDETBufferSizeY / BytePerPixelDETY[k] / SwathWidthY[k];
 		LinesInDETYRoundedDownToSwath[k] = dml_floor(LinesInDETY[k], SwathHeightY[k]);
-		FullDETBufferingTimeY = LinesInDETYRoundedDownToSwath[k] * (HTotal[k] / PixelClock[k]) / VRatio[k];
+		FullDETBufferingTimeY = LinesInDETYRoundedDownToSwath[k] * (v->HTotal[k] / v->PixelClock[k]) / v->VRatio[k];
 		if (BytePerPixelDETC[k] > 0) {
 			LinesInDETC = v->DETBufferSizeC[k] / BytePerPixelDETC[k] / SwathWidthC[k];
 			LinesInDETCRoundedDownToSwath = dml_floor(LinesInDETC, SwathHeightC[k]);
-			FullDETBufferingTimeC = LinesInDETCRoundedDownToSwath * (HTotal[k] / PixelClock[k]) / VRatioChroma[k];
+			FullDETBufferingTimeC = LinesInDETCRoundedDownToSwath * (v->HTotal[k] / v->PixelClock[k]) / v->VRatioChroma[k];
 		} else {
 			LinesInDETC = 0;
 			FullDETBufferingTimeC = 999999;
 		}
 
 		ActiveDRAMClockChangeLatencyMarginY = EffectiveLBLatencyHidingY + FullDETBufferingTimeY
-				- ((double) DSTXAfterScaler[k] / HTotal[k] + DSTYAfterScaler[k]) * HTotal[k] / PixelClock[k] - *UrgentWatermark - *DRAMClockChangeWatermark;
+				- ((double) v->DSTXAfterScaler[k] / v->HTotal[k] + v->DSTYAfterScaler[k]) * v->HTotal[k] / v->PixelClock[k] - v->UrgentWatermark - v->DRAMClockChangeWatermark;
 
-		if (NumberOfActivePlanes > 1) {
+		if (v->NumberOfActivePlanes > 1) {
 			ActiveDRAMClockChangeLatencyMarginY = ActiveDRAMClockChangeLatencyMarginY
-					- (1 - 1.0 / NumberOfActivePlanes) * SwathHeightY[k] * HTotal[k] / PixelClock[k] / VRatio[k];
+					- (1 - 1.0 / v->NumberOfActivePlanes) * SwathHeightY[k] * v->HTotal[k] / v->PixelClock[k] / v->VRatio[k];
 		}
 
 		if (BytePerPixelDETC[k] > 0) {
 			ActiveDRAMClockChangeLatencyMarginC = EffectiveLBLatencyHidingC + FullDETBufferingTimeC
-					- ((double) DSTXAfterScaler[k] / HTotal[k] + DSTYAfterScaler[k]) * HTotal[k] / PixelClock[k] - *UrgentWatermark - *DRAMClockChangeWatermark;
+					- ((double) v->DSTXAfterScaler[k] / v->HTotal[k] + v->DSTYAfterScaler[k]) * v->HTotal[k] / v->PixelClock[k] - v->UrgentWatermark - v->DRAMClockChangeWatermark;
 
-			if (NumberOfActivePlanes > 1) {
+			if (v->NumberOfActivePlanes > 1) {
 				ActiveDRAMClockChangeLatencyMarginC = ActiveDRAMClockChangeLatencyMarginC
-						- (1 - 1.0 / NumberOfActivePlanes) * SwathHeightC[k] * HTotal[k] / PixelClock[k] / VRatioChroma[k];
+						- (1 - 1.0 / v->NumberOfActivePlanes) * SwathHeightC[k] * v->HTotal[k] / v->PixelClock[k] / v->VRatioChroma[k];
 			}
 			v->ActiveDRAMClockChangeLatencyMargin[k] = dml_min(ActiveDRAMClockChangeLatencyMarginY, ActiveDRAMClockChangeLatencyMarginC);
 		} else {
 			v->ActiveDRAMClockChangeLatencyMargin[k] = ActiveDRAMClockChangeLatencyMarginY;
 		}
 
-		if (WritebackEnable[k] == true) {
-			WritebackDRAMClockChangeLatencyHiding = WritebackInterfaceBufferSize * 1024
-					/ (WritebackDestinationWidth[k] * WritebackDestinationHeight[k] / (WritebackSourceHeight[k] * HTotal[k] / PixelClock[k]) * 4);
-			if (WritebackPixelFormat[k] == dm_444_64) {
+		if (v->WritebackEnable[k] == true) {
+			WritebackDRAMClockChangeLatencyHiding = v->WritebackInterfaceBufferSize * 1024
+					/ (v->WritebackDestinationWidth[k] * v->WritebackDestinationHeight[k] / (v->WritebackSourceHeight[k] * v->HTotal[k] / v->PixelClock[k]) * 4);
+			if (v->WritebackPixelFormat[k] == dm_444_64) {
 				WritebackDRAMClockChangeLatencyHiding = WritebackDRAMClockChangeLatencyHiding / 2;
 			}
 			WritebackDRAMClockChangeLatencyMargin = WritebackDRAMClockChangeLatencyHiding - v->WritebackDRAMClockChangeWatermark;
@@ -5926,14 +5704,14 @@ static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 
 	v->MinActiveDRAMClockChangeMargin = 999999;
 	PlaneWithMinActiveDRAMClockChangeMargin = 0;
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
 		if (v->ActiveDRAMClockChangeLatencyMargin[k] < v->MinActiveDRAMClockChangeMargin) {
 			v->MinActiveDRAMClockChangeMargin = v->ActiveDRAMClockChangeLatencyMargin[k];
-			if (BlendingAndTiming[k] == k) {
+			if (v->BlendingAndTiming[k] == k) {
 				PlaneWithMinActiveDRAMClockChangeMargin = k;
 			} else {
-				for (j = 0; j < NumberOfActivePlanes; ++j) {
-					if (BlendingAndTiming[k] == j) {
+				for (j = 0; j < v->NumberOfActivePlanes; ++j) {
+					if (v->BlendingAndTiming[k] == j) {
 						PlaneWithMinActiveDRAMClockChangeMargin = j;
 					}
 				}
@@ -5941,11 +5719,11 @@ static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 		}
 	}
 
-	*MinActiveDRAMClockChangeLatencySupported = v->MinActiveDRAMClockChangeMargin + DRAMClockChangeLatency;
+	v->MinActiveDRAMClockChangeLatencySupported = v->MinActiveDRAMClockChangeMargin + v->DRAMClockChangeLatency ;
 
 	SecondMinActiveDRAMClockChangeMarginOneDisplayInVBLank = 999999;
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
-		if (!((k == PlaneWithMinActiveDRAMClockChangeMargin) && (BlendingAndTiming[k] == k)) && !(BlendingAndTiming[k] == PlaneWithMinActiveDRAMClockChangeMargin)
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
+		if (!((k == PlaneWithMinActiveDRAMClockChangeMargin) && (v->BlendingAndTiming[k] == k)) && !(v->BlendingAndTiming[k] == PlaneWithMinActiveDRAMClockChangeMargin)
 				&& v->ActiveDRAMClockChangeLatencyMargin[k] < SecondMinActiveDRAMClockChangeMarginOneDisplayInVBLank) {
 			SecondMinActiveDRAMClockChangeMarginOneDisplayInVBLank = v->ActiveDRAMClockChangeLatencyMargin[k];
 		}
@@ -5953,25 +5731,25 @@ static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 
 	v->TotalNumberOfActiveOTG = 0;
 
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
-		if (BlendingAndTiming[k] == k) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
+		if (v->BlendingAndTiming[k] == k) {
 			v->TotalNumberOfActiveOTG = v->TotalNumberOfActiveOTG + 1;
 		}
 	}
 
 	if (v->MinActiveDRAMClockChangeMargin > 0 && PrefetchMode == 0) {
 		*DRAMClockChangeSupport = dm_dram_clock_change_vactive;
-	} else if ((SynchronizedVBlank == true || v->TotalNumberOfActiveOTG == 1
+	} else if ((v->SynchronizedVBlank == true || v->TotalNumberOfActiveOTG == 1
 			|| SecondMinActiveDRAMClockChangeMarginOneDisplayInVBLank > 0) && PrefetchMode == 0) {
 		*DRAMClockChangeSupport = dm_dram_clock_change_vblank;
 	} else {
 		*DRAMClockChangeSupport = dm_dram_clock_change_unsupported;
 	}
 
-	*StutterExitWatermark = SRExitTime + ExtraLatency + 10 / DCFCLKDeepSleep;
-	*StutterEnterPlusExitWatermark = (SREnterPlusExitTime + ExtraLatency + 10 / DCFCLKDeepSleep);
-	*Z8StutterExitWatermark = SRExitZ8Time + ExtraLatency + 10 / DCFCLKDeepSleep;
-	*Z8StutterEnterPlusExitWatermark = SREnterPlusExitZ8Time + ExtraLatency + 10 / DCFCLKDeepSleep;
+	*StutterExitWatermark = v->SRExitTime + ExtraLatency + 10 / DCFCLKDeepSleep;
+	*StutterEnterPlusExitWatermark = (v->SREnterPlusExitTime + ExtraLatency + 10 / DCFCLKDeepSleep);
+	*Z8StutterExitWatermark = v->SRExitZ8Time + ExtraLatency + 10 / DCFCLKDeepSleep;
+	*Z8StutterEnterPlusExitWatermark = v->SREnterPlusExitZ8Time + ExtraLatency + 10 / DCFCLKDeepSleep;
 
 #ifdef __DML_VBA_DEBUG__
 	dml_print("DML::%s: StutterExitWatermark = %f\n", __func__, *StutterExitWatermark);
diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index ef742d95ef05..c707c9bfed43 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1597,6 +1597,7 @@ static void interpolate_user_regamma(uint32_t hw_points_num,
 	struct fixed31_32 lut2;
 	struct fixed31_32 delta_lut;
 	struct fixed31_32 delta_index;
+	const struct fixed31_32 one = dc_fixpt_from_int(1);
 
 	i = 0;
 	/* fixed_pt library has problems handling too small values */
@@ -1625,6 +1626,9 @@ static void interpolate_user_regamma(uint32_t hw_points_num,
 			} else
 				hw_x = coordinates_x[i].x;
 
+			if (dc_fixpt_le(one, hw_x))
+				hw_x = one;
+
 			norm_x = dc_fixpt_mul(norm_factor, hw_x);
 			index = dc_fixpt_floor(norm_x);
 			if (index < 0 || index > 255)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 79976921dc46..c71d50e82168 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -358,6 +358,17 @@ static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 		smu_baco->platform_support =
 			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :
 									false;
+
+		/*
+		 * Disable BACO entry/exit completely on below SKUs to
+		 * avoid hardware intermittent failures.
+		 */
+		if (((adev->pdev->device == 0x73A1) &&
+		    (adev->pdev->revision == 0x00)) ||
+		    ((adev->pdev->device == 0x73BF) &&
+		    (adev->pdev->revision == 0xCF)))
+			smu_baco->platform_support = false;
+
 	}
 }
 
diff --git a/drivers/gpu/drm/gma500/gma_display.c b/drivers/gpu/drm/gma500/gma_display.c
index b03f7b8241f2..7162f4c946af 100644
--- a/drivers/gpu/drm/gma500/gma_display.c
+++ b/drivers/gpu/drm/gma500/gma_display.c
@@ -529,15 +529,18 @@ int gma_crtc_page_flip(struct drm_crtc *crtc,
 		WARN_ON(drm_crtc_vblank_get(crtc) != 0);
 
 		gma_crtc->page_flip_event = event;
+		spin_unlock_irqrestore(&dev->event_lock, flags);
 
 		/* Call this locked if we want an event at vblank interrupt. */
 		ret = crtc_funcs->mode_set_base(crtc, crtc->x, crtc->y, old_fb);
 		if (ret) {
-			gma_crtc->page_flip_event = NULL;
-			drm_crtc_vblank_put(crtc);
+			spin_lock_irqsave(&dev->event_lock, flags);
+			if (gma_crtc->page_flip_event) {
+				gma_crtc->page_flip_event = NULL;
+				drm_crtc_vblank_put(crtc);
+			}
+			spin_unlock_irqrestore(&dev->event_lock, flags);
 		}
-
-		spin_unlock_irqrestore(&dev->event_lock, flags);
 	} else {
 		ret = crtc_funcs->mode_set_base(crtc, crtc->x, crtc->y, old_fb);
 	}
diff --git a/drivers/gpu/drm/hisilicon/hibmc/Kconfig b/drivers/gpu/drm/hisilicon/hibmc/Kconfig
index 43943e980203..4e41c144a290 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/Kconfig
+++ b/drivers/gpu/drm/hisilicon/hibmc/Kconfig
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config DRM_HISI_HIBMC
 	tristate "DRM Support for Hisilicon Hibmc"
-	depends on DRM && PCI && ARM64
+	depends on DRM && PCI && (ARM64 || COMPILE_TEST)
+	depends on MMU
 	select DRM_KMS_HELPER
 	select DRM_VRAM_HELPER
 	select DRM_TTM
diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index ac14e598a14f..a6d28533f1b1 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -673,6 +673,16 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
 	if (--dsi->refcount != 0)
 		return;
 
+	/*
+	 * mtk_dsi_stop() and mtk_dsi_start() is asymmetric, since
+	 * mtk_dsi_stop() should be called after mtk_drm_crtc_atomic_disable(),
+	 * which needs irq for vblank, and mtk_dsi_stop() will disable irq.
+	 * mtk_dsi_start() needs to be called in mtk_output_dsi_enable(),
+	 * after dsi is fully set.
+	 */
+	mtk_dsi_stop(dsi);
+
+	mtk_dsi_switch_to_cmd_mode(dsi, VM_DONE_INT_FLAG, 500);
 	mtk_dsi_reset_engine(dsi);
 	mtk_dsi_lane0_ulp_mode_enter(dsi);
 	mtk_dsi_clk_ulp_mode_enter(dsi);
@@ -723,17 +733,6 @@ static void mtk_output_dsi_disable(struct mtk_dsi *dsi)
 	if (!dsi->enabled)
 		return;
 
-	/*
-	 * mtk_dsi_stop() and mtk_dsi_start() is asymmetric, since
-	 * mtk_dsi_stop() should be called after mtk_drm_crtc_atomic_disable(),
-	 * which needs irq for vblank, and mtk_dsi_stop() will disable irq.
-	 * mtk_dsi_start() needs to be called in mtk_output_dsi_enable(),
-	 * after dsi is fully set.
-	 */
-	mtk_dsi_stop(dsi);
-
-	mtk_dsi_switch_to_cmd_mode(dsi, VM_DONE_INT_FLAG, 500);
-
 	dsi->enabled = false;
 }
 
@@ -796,10 +795,13 @@ static void mtk_dsi_bridge_atomic_post_disable(struct drm_bridge *bridge,
 
 static const struct drm_bridge_funcs mtk_dsi_bridge_funcs = {
 	.attach = mtk_dsi_bridge_attach,
+	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
 	.atomic_disable = mtk_dsi_bridge_atomic_disable,
+	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
 	.atomic_enable = mtk_dsi_bridge_atomic_enable,
 	.atomic_pre_enable = mtk_dsi_bridge_atomic_pre_enable,
 	.atomic_post_disable = mtk_dsi_bridge_atomic_post_disable,
+	.atomic_reset = drm_atomic_helper_bridge_reset,
 	.mode_set = mtk_dsi_bridge_mode_set,
 };
 
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 8dd7013c75f2..1a9685eb8002 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2579,7 +2579,7 @@ static const struct panel_desc innolux_g121i1_l01 = {
 		.enable = 200,
 		.disable = 20,
 	},
-	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
diff --git a/drivers/gpu/drm/rockchip/cdn-dp-core.c b/drivers/gpu/drm/rockchip/cdn-dp-core.c
index 13c6b857158f..6b5d0722afa6 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -277,8 +277,9 @@ static int cdn_dp_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int cdn_dp_connector_mode_valid(struct drm_connector *connector,
-				       struct drm_display_mode *mode)
+static enum drm_mode_status
+cdn_dp_connector_mode_valid(struct drm_connector *connector,
+			    struct drm_display_mode *mode)
 {
 	struct cdn_dp_device *dp = connector_to_dp(connector);
 	struct drm_display_info *display_info = &dp->connector.display_info;
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 50d9113f5402..ecfc299834e1 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2340,7 +2340,7 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
 			bool fb_overlap_ok)
 {
 	struct resource *iter, *shadow;
-	resource_size_t range_min, range_max, start;
+	resource_size_t range_min, range_max, start, end;
 	const char *dev_n = dev_name(&device_obj->device);
 	int retval;
 
@@ -2375,6 +2375,14 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
 		range_max = iter->end;
 		start = (range_min + align - 1) & ~(align - 1);
 		for (; start + size - 1 <= range_max; start += align) {
+			end = start + size - 1;
+
+			/* Skip the whole fb_mmio region if not fb_overlap_ok */
+			if (!fb_overlap_ok && fb_mmio &&
+			    (((start >= fb_mmio->start) && (start <= fb_mmio->end)) ||
+			     ((end >= fb_mmio->start) && (end <= fb_mmio->end))))
+				continue;
+
 			shadow = __request_region(iter, start, size, NULL,
 						  IORESOURCE_BUSY);
 			if (!shadow)
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 3f40995c0ca9..2e4d05040e50 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1496,7 +1496,7 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	if (i2c_imx->dma)
 		i2c_imx_dma_free(i2c_imx);
 
-	if (ret == 0) {
+	if (ret >= 0) {
 		/* setup chip registers to defaults */
 		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
 		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
diff --git a/drivers/i2c/busses/i2c-mlxbf.c b/drivers/i2c/busses/i2c-mlxbf.c
index 8716032f030a..ad5efd7497d1 100644
--- a/drivers/i2c/busses/i2c-mlxbf.c
+++ b/drivers/i2c/busses/i2c-mlxbf.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
@@ -63,13 +64,14 @@
  */
 #define MLXBF_I2C_TYU_PLL_OUT_FREQ  (400 * 1000 * 1000)
 /* Reference clock for Bluefield - 156 MHz. */
-#define MLXBF_I2C_PLL_IN_FREQ       (156 * 1000 * 1000)
+#define MLXBF_I2C_PLL_IN_FREQ       156250000ULL
 
 /* Constant used to determine the PLL frequency. */
-#define MLNXBF_I2C_COREPLL_CONST    16384
+#define MLNXBF_I2C_COREPLL_CONST    16384ULL
+
+#define MLXBF_I2C_FREQUENCY_1GHZ  1000000000ULL
 
 /* PLL registers. */
-#define MLXBF_I2C_CORE_PLL_REG0         0x0
 #define MLXBF_I2C_CORE_PLL_REG1         0x4
 #define MLXBF_I2C_CORE_PLL_REG2         0x8
 
@@ -181,22 +183,15 @@
 #define MLXBF_I2C_COREPLL_FREQ          MLXBF_I2C_TYU_PLL_OUT_FREQ
 
 /* Core PLL TYU configuration. */
-#define MLXBF_I2C_COREPLL_CORE_F_TYU_MASK   GENMASK(12, 0)
-#define MLXBF_I2C_COREPLL_CORE_OD_TYU_MASK  GENMASK(3, 0)
-#define MLXBF_I2C_COREPLL_CORE_R_TYU_MASK   GENMASK(5, 0)
-
-#define MLXBF_I2C_COREPLL_CORE_F_TYU_SHIFT  3
-#define MLXBF_I2C_COREPLL_CORE_OD_TYU_SHIFT 16
-#define MLXBF_I2C_COREPLL_CORE_R_TYU_SHIFT  20
+#define MLXBF_I2C_COREPLL_CORE_F_TYU_MASK   GENMASK(15, 3)
+#define MLXBF_I2C_COREPLL_CORE_OD_TYU_MASK  GENMASK(19, 16)
+#define MLXBF_I2C_COREPLL_CORE_R_TYU_MASK   GENMASK(25, 20)
 
 /* Core PLL YU configuration. */
 #define MLXBF_I2C_COREPLL_CORE_F_YU_MASK    GENMASK(25, 0)
 #define MLXBF_I2C_COREPLL_CORE_OD_YU_MASK   GENMASK(3, 0)
-#define MLXBF_I2C_COREPLL_CORE_R_YU_MASK    GENMASK(5, 0)
+#define MLXBF_I2C_COREPLL_CORE_R_YU_MASK    GENMASK(31, 26)
 
-#define MLXBF_I2C_COREPLL_CORE_F_YU_SHIFT   0
-#define MLXBF_I2C_COREPLL_CORE_OD_YU_SHIFT  1
-#define MLXBF_I2C_COREPLL_CORE_R_YU_SHIFT   26
 
 /* Core PLL frequency. */
 static u64 mlxbf_i2c_corepll_frequency;
@@ -479,8 +474,6 @@ static struct mutex mlxbf_i2c_bus_lock;
 #define MLXBF_I2C_MASK_8    GENMASK(7, 0)
 #define MLXBF_I2C_MASK_16   GENMASK(15, 0)
 
-#define MLXBF_I2C_FREQUENCY_1GHZ  1000000000
-
 /*
  * Function to poll a set of bits at a specific address; it checks whether
  * the bits are equal to zero when eq_zero is set to 'true', and not equal
@@ -669,7 +662,7 @@ static int mlxbf_i2c_smbus_enable(struct mlxbf_i2c_priv *priv, u8 slave,
 	/* Clear status bits. */
 	writel(0x0, priv->smbus->io + MLXBF_I2C_SMBUS_MASTER_STATUS);
 	/* Set the cause data. */
-	writel(~0x0, priv->smbus->io + MLXBF_I2C_CAUSE_OR_CLEAR);
+	writel(~0x0, priv->mst_cause->io + MLXBF_I2C_CAUSE_OR_CLEAR);
 	/* Zero PEC byte. */
 	writel(0x0, priv->smbus->io + MLXBF_I2C_SMBUS_MASTER_PEC);
 	/* Zero byte count. */
@@ -738,6 +731,9 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 		if (flags & MLXBF_I2C_F_WRITE) {
 			write_en = 1;
 			write_len += operation->length;
+			if (data_idx + operation->length >
+					MLXBF_I2C_MASTER_DATA_DESC_SIZE)
+				return -ENOBUFS;
 			memcpy(data_desc + data_idx,
 			       operation->buffer, operation->length);
 			data_idx += operation->length;
@@ -1407,24 +1403,19 @@ static int mlxbf_i2c_init_master(struct platform_device *pdev,
 	return 0;
 }
 
-static u64 mlxbf_calculate_freq_from_tyu(struct mlxbf_i2c_resource *corepll_res)
+static u64 mlxbf_i2c_calculate_freq_from_tyu(struct mlxbf_i2c_resource *corepll_res)
 {
-	u64 core_frequency, pad_frequency;
+	u64 core_frequency;
 	u8 core_od, core_r;
 	u32 corepll_val;
 	u16 core_f;
 
-	pad_frequency = MLXBF_I2C_PLL_IN_FREQ;
-
 	corepll_val = readl(corepll_res->io + MLXBF_I2C_CORE_PLL_REG1);
 
 	/* Get Core PLL configuration bits. */
-	core_f = rol32(corepll_val, MLXBF_I2C_COREPLL_CORE_F_TYU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_F_TYU_MASK;
-	core_od = rol32(corepll_val, MLXBF_I2C_COREPLL_CORE_OD_TYU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_OD_TYU_MASK;
-	core_r = rol32(corepll_val, MLXBF_I2C_COREPLL_CORE_R_TYU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_R_TYU_MASK;
+	core_f = FIELD_GET(MLXBF_I2C_COREPLL_CORE_F_TYU_MASK, corepll_val);
+	core_od = FIELD_GET(MLXBF_I2C_COREPLL_CORE_OD_TYU_MASK, corepll_val);
+	core_r = FIELD_GET(MLXBF_I2C_COREPLL_CORE_R_TYU_MASK, corepll_val);
 
 	/*
 	 * Compute PLL output frequency as follow:
@@ -1436,31 +1427,26 @@ static u64 mlxbf_calculate_freq_from_tyu(struct mlxbf_i2c_resource *corepll_res)
 	 * Where PLL_OUT_FREQ and PLL_IN_FREQ refer to CoreFrequency
 	 * and PadFrequency, respectively.
 	 */
-	core_frequency = pad_frequency * (++core_f);
+	core_frequency = MLXBF_I2C_PLL_IN_FREQ * (++core_f);
 	core_frequency /= (++core_r) * (++core_od);
 
 	return core_frequency;
 }
 
-static u64 mlxbf_calculate_freq_from_yu(struct mlxbf_i2c_resource *corepll_res)
+static u64 mlxbf_i2c_calculate_freq_from_yu(struct mlxbf_i2c_resource *corepll_res)
 {
 	u32 corepll_reg1_val, corepll_reg2_val;
-	u64 corepll_frequency, pad_frequency;
+	u64 corepll_frequency;
 	u8 core_od, core_r;
 	u32 core_f;
 
-	pad_frequency = MLXBF_I2C_PLL_IN_FREQ;
-
 	corepll_reg1_val = readl(corepll_res->io + MLXBF_I2C_CORE_PLL_REG1);
 	corepll_reg2_val = readl(corepll_res->io + MLXBF_I2C_CORE_PLL_REG2);
 
 	/* Get Core PLL configuration bits */
-	core_f = rol32(corepll_reg1_val, MLXBF_I2C_COREPLL_CORE_F_YU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_F_YU_MASK;
-	core_r = rol32(corepll_reg1_val, MLXBF_I2C_COREPLL_CORE_R_YU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_R_YU_MASK;
-	core_od = rol32(corepll_reg2_val,  MLXBF_I2C_COREPLL_CORE_OD_YU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_OD_YU_MASK;
+	core_f = FIELD_GET(MLXBF_I2C_COREPLL_CORE_F_YU_MASK, corepll_reg1_val);
+	core_r = FIELD_GET(MLXBF_I2C_COREPLL_CORE_R_YU_MASK, corepll_reg1_val);
+	core_od = FIELD_GET(MLXBF_I2C_COREPLL_CORE_OD_YU_MASK, corepll_reg2_val);
 
 	/*
 	 * Compute PLL output frequency as follow:
@@ -1472,7 +1458,7 @@ static u64 mlxbf_calculate_freq_from_yu(struct mlxbf_i2c_resource *corepll_res)
 	 * Where PLL_OUT_FREQ and PLL_IN_FREQ refer to CoreFrequency
 	 * and PadFrequency, respectively.
 	 */
-	corepll_frequency = (pad_frequency * core_f) / MLNXBF_I2C_COREPLL_CONST;
+	corepll_frequency = (MLXBF_I2C_PLL_IN_FREQ * core_f) / MLNXBF_I2C_COREPLL_CONST;
 	corepll_frequency /= (++core_r) * (++core_od);
 
 	return corepll_frequency;
@@ -2180,14 +2166,14 @@ static struct mlxbf_i2c_chip_info mlxbf_i2c_chip[] = {
 			[1] = &mlxbf_i2c_corepll_res[MLXBF_I2C_CHIP_TYPE_1],
 			[2] = &mlxbf_i2c_gpio_res[MLXBF_I2C_CHIP_TYPE_1]
 		},
-		.calculate_freq = mlxbf_calculate_freq_from_tyu
+		.calculate_freq = mlxbf_i2c_calculate_freq_from_tyu
 	},
 	[MLXBF_I2C_CHIP_TYPE_2] = {
 		.type = MLXBF_I2C_CHIP_TYPE_2,
 		.shared_res = {
 			[0] = &mlxbf_i2c_corepll_res[MLXBF_I2C_CHIP_TYPE_2]
 		},
-		.calculate_freq = mlxbf_calculate_freq_from_yu
+		.calculate_freq = mlxbf_i2c_calculate_freq_from_yu
 	}
 };
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 2affdccb58e4..71a932017772 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -539,7 +539,7 @@ static unsigned long __iommu_calculate_sagaw(struct intel_iommu *iommu)
 {
 	unsigned long fl_sagaw, sl_sagaw;
 
-	fl_sagaw = BIT(2) | (cap_fl1gp_support(iommu->cap) ? BIT(3) : 0);
+	fl_sagaw = BIT(2) | (cap_5lp_support(iommu->cap) ? BIT(3) : 0);
 	sl_sagaw = cap_sagaw(iommu->cap);
 
 	/* Second level only. */
diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index bfeb92d93de3..8ab1be03e731 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -511,7 +511,7 @@ static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 
 	if (fc_usb->uintf->cur_altsetting->desc.bNumEndpoints < 1)
 		return -ENODEV;
-	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[1].desc))
+	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[0].desc))
 		return -ENODEV;
 
 	switch (fc_usb->udev->speed) {
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 1f0120cbe9e8..8ad095c19f27 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -87,8 +87,9 @@ static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
 static u16 ad_ticks_per_sec;
 static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
 
-static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
-	MULTICAST_LACPDU_ADDR;
+const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned = {
+	0x01, 0x80, 0xC2, 0x00, 0x00, 0x02
+};
 
 /* ================= main 802.3ad protocol functions ================== */
 static int ad_lacpdu_send(struct port *port);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cd0d7b24f014..402dffc508ef 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -862,12 +862,8 @@ static void bond_hw_addr_flush(struct net_device *bond_dev,
 	dev_uc_unsync(slave_dev, bond_dev);
 	dev_mc_unsync(slave_dev, bond_dev);
 
-	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-		/* del lacpdu mc addr from mc list */
-		u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
-
-		dev_mc_del(slave_dev, lacpdu_multicast);
-	}
+	if (BOND_MODE(bond) == BOND_MODE_8023AD)
+		dev_mc_del(slave_dev, lacpdu_mcast_addr);
 }
 
 /*--------------------------- Active slave change ---------------------------*/
@@ -887,7 +883,8 @@ static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
 		if (bond->dev->flags & IFF_ALLMULTI)
 			dev_set_allmulti(old_active->dev, -1);
 
-		bond_hw_addr_flush(bond->dev, old_active->dev);
+		if (bond->dev->flags & IFF_UP)
+			bond_hw_addr_flush(bond->dev, old_active->dev);
 	}
 
 	if (new_active) {
@@ -898,10 +895,12 @@ static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
 		if (bond->dev->flags & IFF_ALLMULTI)
 			dev_set_allmulti(new_active->dev, 1);
 
-		netif_addr_lock_bh(bond->dev);
-		dev_uc_sync(new_active->dev, bond->dev);
-		dev_mc_sync(new_active->dev, bond->dev);
-		netif_addr_unlock_bh(bond->dev);
+		if (bond->dev->flags & IFF_UP) {
+			netif_addr_lock_bh(bond->dev);
+			dev_uc_sync(new_active->dev, bond->dev);
+			dev_mc_sync(new_active->dev, bond->dev);
+			netif_addr_unlock_bh(bond->dev);
+		}
 	}
 }
 
@@ -2134,16 +2133,14 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			}
 		}
 
-		netif_addr_lock_bh(bond_dev);
-		dev_mc_sync_multiple(slave_dev, bond_dev);
-		dev_uc_sync_multiple(slave_dev, bond_dev);
-		netif_addr_unlock_bh(bond_dev);
-
-		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-			/* add lacpdu mc addr to mc list */
-			u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
+		if (bond_dev->flags & IFF_UP) {
+			netif_addr_lock_bh(bond_dev);
+			dev_mc_sync_multiple(slave_dev, bond_dev);
+			dev_uc_sync_multiple(slave_dev, bond_dev);
+			netif_addr_unlock_bh(bond_dev);
 
-			dev_mc_add(slave_dev, lacpdu_multicast);
+			if (BOND_MODE(bond) == BOND_MODE_8023AD)
+				dev_mc_add(slave_dev, lacpdu_mcast_addr);
 		}
 	}
 
@@ -2415,7 +2412,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 		if (old_flags & IFF_ALLMULTI)
 			dev_set_allmulti(slave_dev, -1);
 
-		bond_hw_addr_flush(bond_dev, slave_dev);
+		if (old_flags & IFF_UP)
+			bond_hw_addr_flush(bond_dev, slave_dev);
 	}
 
 	slave_disable_netpoll(slave);
@@ -3932,6 +3930,12 @@ static int bond_open(struct net_device *bond_dev)
 	struct list_head *iter;
 	struct slave *slave;
 
+	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN && !bond->rr_tx_counter) {
+		bond->rr_tx_counter = alloc_percpu(u32);
+		if (!bond->rr_tx_counter)
+			return -ENOMEM;
+	}
+
 	/* reset slave->backup and slave->inactive */
 	if (bond_has_slaves(bond)) {
 		bond_for_each_slave(bond, slave, iter) {
@@ -3969,6 +3973,9 @@ static int bond_open(struct net_device *bond_dev)
 		/* register to receive LACPDUs */
 		bond->recv_probe = bond_3ad_lacpdu_recv;
 		bond_3ad_initiate_agg_selection(bond, 1);
+
+		bond_for_each_slave(bond, slave, iter)
+			dev_mc_add(slave->dev, lacpdu_mcast_addr);
 	}
 
 	if (bond_mode_can_use_xmit_hash(bond))
@@ -3980,6 +3987,7 @@ static int bond_open(struct net_device *bond_dev)
 static int bond_close(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *slave;
 
 	bond_work_cancel_all(bond);
 	bond->send_peer_notif = 0;
@@ -3987,6 +3995,19 @@ static int bond_close(struct net_device *bond_dev)
 		bond_alb_deinitialize(bond);
 	bond->recv_probe = NULL;
 
+	if (bond_uses_primary(bond)) {
+		rcu_read_lock();
+		slave = rcu_dereference(bond->curr_active_slave);
+		if (slave)
+			bond_hw_addr_flush(bond_dev, slave->dev);
+		rcu_read_unlock();
+	} else {
+		struct list_head *iter;
+
+		bond_for_each_slave(bond, slave, iter)
+			bond_hw_addr_flush(bond_dev, slave->dev);
+	}
+
 	return 0;
 }
 
@@ -5892,15 +5913,6 @@ static int bond_init(struct net_device *bond_dev)
 	if (!bond->wq)
 		return -ENOMEM;
 
-	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN) {
-		bond->rr_tx_counter = alloc_percpu(u32);
-		if (!bond->rr_tx_counter) {
-			destroy_workqueue(bond->wq);
-			bond->wq = NULL;
-			return -ENOMEM;
-		}
-	}
-
 	spin_lock_init(&bond->stats_lock);
 	netdev_lockdep_set_classes(bond_dev);
 
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 18d7bb99ec1b..837bca734759 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1036,11 +1036,6 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 	u32 reg_ctrl, reg_id, reg_iflag1;
 	int i;
 
-	if (unlikely(drop)) {
-		skb = ERR_PTR(-ENOBUFS);
-		goto mark_as_read;
-	}
-
 	mb = flexcan_get_mb(priv, n);
 
 	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
@@ -1069,6 +1064,11 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 		reg_ctrl = priv->read(&mb->can_ctrl);
 	}
 
+	if (unlikely(drop)) {
+		skb = ERR_PTR(-ENOBUFS);
+		goto mark_as_read;
+	}
+
 	if (reg_ctrl & FLEXCAN_MB_CNT_EDL)
 		skb = alloc_canfd_skb(offload->dev, &cfd);
 	else
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index e26b3d6f5b48..5a43e542b302 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -680,6 +680,7 @@ static int gs_can_open(struct net_device *netdev)
 		flags |= GS_CAN_MODE_TRIPLE_SAMPLE;
 
 	/* finally start device */
+	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 	dm->mode = cpu_to_le32(GS_CAN_MODE_START);
 	dm->flags = cpu_to_le32(flags);
 	rc = usb_control_msg(interface_to_usbdev(dev->iface),
@@ -696,13 +697,12 @@ static int gs_can_open(struct net_device *netdev)
 	if (rc < 0) {
 		netdev_err(netdev, "Couldn't start device (err=%d)\n", rc);
 		kfree(dm);
+		dev->can.state = CAN_STATE_STOPPED;
 		return rc;
 	}
 
 	kfree(dm);
 
-	dev->can.state = CAN_STATE_ERROR_ACTIVE;
-
 	parent->active_channels++;
 	if (!(dev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY))
 		netif_start_queue(netdev);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6962abe2358b..a6ca7ba5276c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -709,7 +709,6 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 
 	for (i = 0; i < nr_pkts; i++) {
 		struct bnxt_sw_tx_bd *tx_buf;
-		bool compl_deferred = false;
 		struct sk_buff *skb;
 		int j, last;
 
@@ -718,6 +717,8 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		skb = tx_buf->skb;
 		tx_buf->skb = NULL;
 
+		tx_bytes += skb->len;
+
 		if (tx_buf->is_push) {
 			tx_buf->is_push = 0;
 			goto next_tx_int;
@@ -738,8 +739,9 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		}
 		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
 			if (bp->flags & BNXT_FLAG_CHIP_P5) {
+				/* PTP worker takes ownership of the skb */
 				if (!bnxt_get_tx_ts_p5(bp, skb))
-					compl_deferred = true;
+					skb = NULL;
 				else
 					atomic_inc(&bp->ptp_cfg->tx_avail);
 			}
@@ -748,9 +750,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 next_tx_int:
 		cons = NEXT_TX(cons);
 
-		tx_bytes += skb->len;
-		if (!compl_deferred)
-			dev_kfree_skb_any(skb);
+		dev_kfree_skb_any(skb);
 	}
 
 	netdev_tx_completed_queue(txq, nr_pkts, tx_bytes);
diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
index a139f2e9d59f..e0e8dfd13793 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -9,7 +9,6 @@ fsl-enetc-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
 obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
 fsl-enetc-vf-y := enetc_vf.o $(common-objs)
-fsl-enetc-vf-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
 obj-$(CONFIG_FSL_ENETC_IERB) += fsl-enetc-ierb.o
 fsl-enetc-ierb-y := enetc_ierb.o
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 042327b9981f..c0265a6f10c0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2142,7 +2142,7 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
 
-static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
@@ -2196,25 +2196,6 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	return 0;
 }
 
-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-		   void *type_data)
-{
-	switch (type) {
-	case TC_SETUP_QDISC_MQPRIO:
-		return enetc_setup_tc_mqprio(ndev, type_data);
-	case TC_SETUP_QDISC_TAPRIO:
-		return enetc_setup_tc_taprio(ndev, type_data);
-	case TC_SETUP_QDISC_CBS:
-		return enetc_setup_tc_cbs(ndev, type_data);
-	case TC_SETUP_QDISC_ETF:
-		return enetc_setup_tc_txtime(ndev, type_data);
-	case TC_SETUP_BLOCK:
-		return enetc_setup_tc_psfp(ndev, type_data);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int enetc_setup_xdp_prog(struct net_device *dev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
@@ -2307,29 +2288,6 @@ static int enetc_set_rss(struct net_device *ndev, int en)
 	return 0;
 }
 
-static int enetc_set_psfp(struct net_device *ndev, int en)
-{
-	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	int err;
-
-	if (en) {
-		err = enetc_psfp_enable(priv);
-		if (err)
-			return err;
-
-		priv->active_offloads |= ENETC_F_QCI;
-		return 0;
-	}
-
-	err = enetc_psfp_disable(priv);
-	if (err)
-		return err;
-
-	priv->active_offloads &= ~ENETC_F_QCI;
-
-	return 0;
-}
-
 static void enetc_enable_rxvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -2348,11 +2306,9 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 		enetc_bdr_enable_txvlan(&priv->si->hw, i, en);
 }
 
-int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features)
+void enetc_set_features(struct net_device *ndev, netdev_features_t features)
 {
 	netdev_features_t changed = ndev->features ^ features;
-	int err = 0;
 
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
@@ -2364,11 +2320,6 @@ int enetc_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_HW_VLAN_CTAG_TX)
 		enetc_enable_txvlan(ndev,
 				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
-
-	if (changed & NETIF_F_HW_TC)
-		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
-
-	return err;
 }
 
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 08b283347d9c..f304cdb854ec 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -385,11 +385,9 @@ void enetc_start(struct net_device *ndev);
 void enetc_stop(struct net_device *ndev);
 netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev);
 struct net_device_stats *enetc_get_stats(struct net_device *ndev);
-int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features);
+void enetc_set_features(struct net_device *ndev, netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-		   void *type_data);
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data);
 int enetc_setup_bpf(struct net_device *dev, struct netdev_bpf *xdp);
 int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 		   struct xdp_frame **frames, u32 flags);
@@ -421,6 +419,7 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data);
 int enetc_psfp_init(struct enetc_ndev_priv *priv);
 int enetc_psfp_clean(struct enetc_ndev_priv *priv);
+int enetc_set_psfp(struct net_device *ndev, bool en);
 
 static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 {
@@ -496,4 +495,9 @@ static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
 {
 	return 0;
 }
+
+static inline int enetc_set_psfp(struct net_device *ndev, bool en)
+{
+	return 0;
+}
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index d522bd5c90b4..3615357cc60f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -708,6 +708,13 @@ static int enetc_pf_set_features(struct net_device *ndev,
 {
 	netdev_features_t changed = ndev->features ^ features;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int err;
+
+	if (changed & NETIF_F_HW_TC) {
+		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
+		if (err)
+			return err;
+	}
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		struct enetc_pf *pf = enetc_si_priv(priv->si);
@@ -721,7 +728,28 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_LOOPBACK)
 		enetc_set_loopback(ndev, !!(features & NETIF_F_LOOPBACK));
 
-	return enetc_set_features(ndev, features);
+	enetc_set_features(ndev, features);
+
+	return 0;
+}
+
+static int enetc_pf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			     void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return enetc_setup_tc_mqprio(ndev, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return enetc_setup_tc_taprio(ndev, type_data);
+	case TC_SETUP_QDISC_CBS:
+		return enetc_setup_tc_cbs(ndev, type_data);
+	case TC_SETUP_QDISC_ETF:
+		return enetc_setup_tc_txtime(ndev, type_data);
+	case TC_SETUP_BLOCK:
+		return enetc_setup_tc_psfp(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
 }
 
 static const struct net_device_ops enetc_ndev_ops = {
@@ -738,7 +766,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_vf_spoofchk	= enetc_pf_set_vf_spoofchk,
 	.ndo_set_features	= enetc_pf_set_features,
 	.ndo_eth_ioctl		= enetc_ioctl,
-	.ndo_setup_tc		= enetc_setup_tc,
+	.ndo_setup_tc		= enetc_pf_setup_tc,
 	.ndo_bpf		= enetc_setup_bpf,
 	.ndo_xdp_xmit		= enetc_xdp_xmit,
 };
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index d779dde522c8..6b236e0fd806 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1529,6 +1529,29 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+int enetc_set_psfp(struct net_device *ndev, bool en)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int err;
+
+	if (en) {
+		err = enetc_psfp_enable(priv);
+		if (err)
+			return err;
+
+		priv->active_offloads |= ENETC_F_QCI;
+		return 0;
+	}
+
+	err = enetc_psfp_disable(priv);
+	if (err)
+		return err;
+
+	priv->active_offloads &= ~ENETC_F_QCI;
+
+	return 0;
+}
+
 int enetc_psfp_init(struct enetc_ndev_priv *priv)
 {
 	if (epsfp.psfp_sfi_bitmap)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 1a9d1e8b772c..acd4a3167ed6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -88,7 +88,20 @@ static int enetc_vf_set_mac_addr(struct net_device *ndev, void *addr)
 static int enetc_vf_set_features(struct net_device *ndev,
 				 netdev_features_t features)
 {
-	return enetc_set_features(ndev, features);
+	enetc_set_features(ndev, features);
+
+	return 0;
+}
+
+static int enetc_vf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			     void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return enetc_setup_tc_mqprio(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
 }
 
 /* Probing/ Init */
@@ -100,7 +113,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_mac_address	= enetc_vf_set_mac_addr,
 	.ndo_set_features	= enetc_vf_set_features,
 	.ndo_eth_ioctl		= enetc_ioctl,
-	.ndo_setup_tc		= enetc_setup_tc,
+	.ndo_setup_tc		= enetc_vf_setup_tc,
 };
 
 static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ce6eea7a6002..5922520fdb01 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5766,6 +5766,26 @@ static int i40e_get_link_speed(struct i40e_vsi *vsi)
 	}
 }
 
+/**
+ * i40e_bw_bytes_to_mbits - Convert max_tx_rate from bytes to mbits
+ * @vsi: Pointer to vsi structure
+ * @max_tx_rate: max TX rate in bytes to be converted into Mbits
+ *
+ * Helper function to convert units before send to set BW limit
+ **/
+static u64 i40e_bw_bytes_to_mbits(struct i40e_vsi *vsi, u64 max_tx_rate)
+{
+	if (max_tx_rate < I40E_BW_MBPS_DIVISOR) {
+		dev_warn(&vsi->back->pdev->dev,
+			 "Setting max tx rate to minimum usable value of 50Mbps.\n");
+		max_tx_rate = I40E_BW_CREDIT_DIVISOR;
+	} else {
+		do_div(max_tx_rate, I40E_BW_MBPS_DIVISOR);
+	}
+
+	return max_tx_rate;
+}
+
 /**
  * i40e_set_bw_limit - setup BW limit for Tx traffic based on max_tx_rate
  * @vsi: VSI to be configured
@@ -5788,10 +5808,10 @@ int i40e_set_bw_limit(struct i40e_vsi *vsi, u16 seid, u64 max_tx_rate)
 			max_tx_rate, seid);
 		return -EINVAL;
 	}
-	if (max_tx_rate && max_tx_rate < 50) {
+	if (max_tx_rate && max_tx_rate < I40E_BW_CREDIT_DIVISOR) {
 		dev_warn(&pf->pdev->dev,
 			 "Setting max tx rate to minimum usable value of 50Mbps.\n");
-		max_tx_rate = 50;
+		max_tx_rate = I40E_BW_CREDIT_DIVISOR;
 	}
 
 	/* Tx rate credits are in values of 50Mbps, 0 is disabled */
@@ -8082,9 +8102,9 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 
 	if (i40e_is_tc_mqprio_enabled(pf)) {
 		if (vsi->mqprio_qopt.max_rate[0]) {
-			u64 max_tx_rate = vsi->mqprio_qopt.max_rate[0];
+			u64 max_tx_rate = i40e_bw_bytes_to_mbits(vsi,
+						  vsi->mqprio_qopt.max_rate[0]);
 
-			do_div(max_tx_rate, I40E_BW_MBPS_DIVISOR);
 			ret = i40e_set_bw_limit(vsi, vsi->seid, max_tx_rate);
 			if (!ret) {
 				u64 credits = max_tx_rate;
@@ -10829,10 +10849,10 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	}
 
 	if (vsi->mqprio_qopt.max_rate[0]) {
-		u64 max_tx_rate = vsi->mqprio_qopt.max_rate[0];
+		u64 max_tx_rate = i40e_bw_bytes_to_mbits(vsi,
+						  vsi->mqprio_qopt.max_rate[0]);
 		u64 credits = 0;
 
-		do_div(max_tx_rate, I40E_BW_MBPS_DIVISOR);
 		ret = i40e_set_bw_limit(vsi, vsi->seid, max_tx_rate);
 		if (ret)
 			goto end_unlock;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index d78ac5e7f658..c078fbaf19fd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2038,6 +2038,25 @@ static void i40e_del_qch(struct i40e_vf *vf)
 	}
 }
 
+/**
+ * i40e_vc_get_max_frame_size
+ * @vf: pointer to the VF
+ *
+ * Max frame size is determined based on the current port's max frame size and
+ * whether a port VLAN is configured on this VF. The VF is not aware whether
+ * it's in a port VLAN so the PF needs to account for this in max frame size
+ * checks and sending the max frame size to the VF.
+ **/
+static u16 i40e_vc_get_max_frame_size(struct i40e_vf *vf)
+{
+	u16 max_frame_size = vf->pf->hw.phy.link_info.max_frame_size;
+
+	if (vf->port_vlan_id)
+		max_frame_size -= VLAN_HLEN;
+
+	return max_frame_size;
+}
+
 /**
  * i40e_vc_get_vf_resources_msg
  * @vf: pointer to the VF info
@@ -2139,6 +2158,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 	vfres->max_vectors = pf->hw.func_caps.num_msix_vectors_vf;
 	vfres->rss_key_size = I40E_HKEY_ARRAY_SIZE;
 	vfres->rss_lut_size = I40E_VF_HLUT_ARRAY_SIZE;
+	vfres->max_mtu = i40e_vc_get_max_frame_size(vf);
 
 	if (vf->lan_vsi_idx) {
 		vfres->vsi_res[0].vsi_id = vf->lan_vsi_id;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 5448ed0e0357..e76e3df3e2d9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -114,8 +114,11 @@ u32 iavf_get_tx_pending(struct iavf_ring *ring, bool in_sw)
 {
 	u32 head, tail;
 
+	/* underlying hardware might not allow access and/or always return
+	 * 0 for the head/tail registers so just use the cached values
+	 */
 	head = ring->next_to_clean;
-	tail = readl(ring->tail);
+	tail = ring->next_to_use;
 
 	if (head != tail)
 		return (head < tail) ?
@@ -1355,7 +1358,7 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 #endif
 	struct sk_buff *skb;
 
-	if (!rx_buffer)
+	if (!rx_buffer || !size)
 		return NULL;
 	/* prefetch first cache line of first page */
 	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
@@ -1513,7 +1516,7 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
-			if (rx_buffer)
+			if (rx_buffer && size)
 				rx_buffer->pagecnt_bias++;
 			break;
 		}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 7013769fc038..c6eb0d0748ea 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -244,11 +244,14 @@ int iavf_get_vf_config(struct iavf_adapter *adapter)
 void iavf_configure_queues(struct iavf_adapter *adapter)
 {
 	struct virtchnl_vsi_queue_config_info *vqci;
-	struct virtchnl_queue_pair_info *vqpi;
+	int i, max_frame = adapter->vf_res->max_mtu;
 	int pairs = adapter->num_active_queues;
-	int i, max_frame = IAVF_MAX_RXBUFFER;
+	struct virtchnl_queue_pair_info *vqpi;
 	size_t len;
 
+	if (max_frame > IAVF_MAX_RXBUFFER || !max_frame)
+		max_frame = IAVF_MAX_RXBUFFER;
+
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
 		/* bail because we already have a command pending */
 		dev_err(&adapter->pdev->dev, "Cannot configure queues, command %d pending\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 63ae4674d200..ffbba5f6b7a5 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2255,8 +2255,6 @@ int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset)
 		return -EBUSY;
 	}
 
-	ice_unplug_aux_dev(pf);
-
 	switch (reset) {
 	case ICE_RESET_PFR:
 		set_bit(ICE_PFR_REQ, pf->state);
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index f979ba7e5eff..caa4380ada13 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -178,6 +178,9 @@ static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int phy_reg)
 	/* Only return ad bits of the gw register */
 	ret &= MLXBF_GIGE_MDIO_GW_AD_MASK;
 
+	/* The MDIO lock is set on read. To release it, clear gw register */
+	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+
 	return ret;
 }
 
@@ -201,6 +204,9 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 	ret = readl_poll_timeout_atomic(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET,
 					temp, !(temp & MLXBF_GIGE_MDIO_GW_BUSY_MASK), 100, 1000000);
 
+	/* The MDIO lock is set on read. To release it, clear gw register */
+	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index cee75b561f59..f577507f522b 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -368,6 +368,11 @@ static void mana_gd_process_eq_events(void *arg)
 			break;
 		}
 
+		/* Per GDMA spec, rmb is necessary after checking owner_bits, before
+		 * reading eqe.
+		 */
+		rmb();
+
 		mana_gd_process_eqe(eq);
 
 		eq->head++;
@@ -1096,6 +1101,11 @@ static int mana_gd_read_cqe(struct gdma_queue *cq, struct gdma_comp *comp)
 	if (WARN_ON_ONCE(owner_bits != new_bits))
 		return -1;
 
+	/* Per GDMA spec, rmb is necessary after checking owner_bits, before
+	 * reading completion info
+	 */
+	rmb();
+
 	comp->wq_num = cqe->cqe_info.wq_num;
 	comp->is_sq = cqe->cqe_info.is_sq;
 	memcpy(comp->cqe_data, cqe->cqe_data, GDMA_COMP_DATA_SIZE);
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4e08b7219403..12420239c8ca 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1115,6 +1115,8 @@ static int ravb_phy_init(struct net_device *ndev)
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
 
+	/* Indicate that the MAC is responsible for managing PHY PM */
+	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 1374faa229a2..4e190f5e32c3 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2033,6 +2033,8 @@ static int sh_eth_phy_init(struct net_device *ndev)
 		}
 	}
 
+	/* Indicate that the MAC is responsible for managing PHY PM */
+	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index b1657e03a74f..450fcedb7042 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -329,7 +329,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
-		efx->tx_channel_offset = 1;
+		efx->tx_channel_offset = efx_separate_tx_channels ? 1 : 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 6983799e1c05..e0bc2c1dc81a 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -548,7 +548,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 		 * previous packets out.
 		 */
 		if (!netdev_xmit_more())
-			efx_tx_send_pending(tx_queue->channel);
+			efx_tx_send_pending(efx_get_tx_channel(efx, index));
 		return NETDEV_TX_OK;
 	}
 
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index b05ee2e0e305..735f24a70626 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2039,9 +2039,9 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 
 			skb_reserve(copy_skb, 2);
 			skb_put(copy_skb, len);
-			dma_sync_single_for_cpu(hp->dma_dev, dma_addr, len, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(hp->dma_dev, dma_addr, len + 2, DMA_FROM_DEVICE);
 			skb_copy_from_linear_data(skb, copy_skb->data, len);
-			dma_sync_single_for_device(hp->dma_dev, dma_addr, len, DMA_FROM_DEVICE);
+			dma_sync_single_for_device(hp->dma_dev, dma_addr, len + 2, DMA_FROM_DEVICE);
 			/* Reuse original ring buffer. */
 			hme_write_rxd(hp, this,
 				      (RXFLAG_OWN|((RX_BUF_ALLOC_SIZE-RX_OFFSET)<<16)),
diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 90f3aec55b36..b84baedda5f6 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -308,12 +308,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE);
 	req.v4_route_tbl_info_valid = 1;
 	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v4_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v4_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE);
 	req.v6_route_tbl_info_valid = 1;
 	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v6_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v6_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER);
 	req.v4_filter_tbl_start_valid = 1;
@@ -352,7 +352,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v4_hash_route_tbl_info_valid = 1;
 		req.v4_hash_route_tbl_info.start =
 				ipa->mem_offset + mem->offset;
-		req.v4_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v4_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE_HASHED);
@@ -360,7 +360,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v6_hash_route_tbl_info_valid = 1;
 		req.v6_hash_route_tbl_info.start =
 			ipa->mem_offset + mem->offset;
-		req.v6_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v6_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER_HASHED);
diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
index 6838e8065072..75d3fc0092e9 100644
--- a/drivers/net/ipa/ipa_qmi_msg.c
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -311,7 +311,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x12,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v4_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
@@ -332,7 +332,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x13,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v6_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
@@ -496,7 +496,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x1b,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v4_hash_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
@@ -517,7 +517,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x1c,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v6_hash_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
index 3233d145fd87..51b39ffe020e 100644
--- a/drivers/net/ipa/ipa_qmi_msg.h
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -86,9 +86,11 @@ enum ipa_platform_type {
 	IPA_QMI_PLATFORM_TYPE_MSM_QNX_V01	= 0x5,	/* QNX MSM */
 };
 
-/* This defines the start and end offset of a range of memory.  Both
- * fields are offsets relative to the start of IPA shared memory.
- * The end value is the last addressable byte *within* the range.
+/* This defines the start and end offset of a range of memory.  The start
+ * value is a byte offset relative to the start of IPA shared memory.  The
+ * end value is the last addressable unit *within* the range.  Typically
+ * the end value is in units of bytes, however it can also be a maximum
+ * array index value.
  */
 struct ipa_mem_bounds {
 	u32 start;
@@ -129,18 +131,19 @@ struct ipa_init_modem_driver_req {
 	u8			hdr_tbl_info_valid;
 	struct ipa_mem_bounds	hdr_tbl_info;
 
-	/* Routing table information.  These define the location and size of
-	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	/* Routing table information.  These define the location and maximum
+	 * *index* (not byte) for the modem portion of non-hashable IPv4 and
+	 * IPv6 routing tables.  The start values are byte offsets relative
+	 * to the start of IPA shared memory.
 	 */
 	u8			v4_route_tbl_info_valid;
-	struct ipa_mem_array	v4_route_tbl_info;
+	struct ipa_mem_bounds	v4_route_tbl_info;
 	u8			v6_route_tbl_info_valid;
-	struct ipa_mem_array	v6_route_tbl_info;
+	struct ipa_mem_bounds	v6_route_tbl_info;
 
 	/* Filter table information.  These define the location of the
 	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	 * byte offsets relative to the start of IPA shared memory.
 	 */
 	u8			v4_filter_tbl_start_valid;
 	u32			v4_filter_tbl_start;
@@ -181,18 +184,20 @@ struct ipa_init_modem_driver_req {
 	u8			zip_tbl_info_valid;
 	struct ipa_mem_bounds	zip_tbl_info;
 
-	/* Routing table information.  These define the location and size
-	 * of hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	/* Routing table information.  These define the location and maximum
+	 * *index* (not byte) for the modem portion of hashable IPv4 and IPv6
+	 * routing tables (if supported by hardware).  The start values are
+	 * byte offsets relative to the start of IPA shared memory.
 	 */
 	u8			v4_hash_route_tbl_info_valid;
-	struct ipa_mem_array	v4_hash_route_tbl_info;
+	struct ipa_mem_bounds	v4_hash_route_tbl_info;
 	u8			v6_hash_route_tbl_info_valid;
-	struct ipa_mem_array	v6_hash_route_tbl_info;
+	struct ipa_mem_bounds	v6_hash_route_tbl_info;
 
 	/* Filter table information.  These define the location and size
-	 * of hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	 * of hashable IPv4 and IPv6 filter tables (if supported by hardware).
+	 * The start values are byte offsets relative to the start of IPA
+	 * shared memory.
 	 */
 	u8			v4_hash_filter_tbl_start_valid;
 	u32			v4_hash_filter_tbl_start;
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 1da334f54944..6bf486d2b679 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -108,8 +108,6 @@
 
 /* Assignment of route table entries to the modem and AP */
 #define IPA_ROUTE_MODEM_MIN		0
-#define IPA_ROUTE_MODEM_COUNT		8
-
 #define IPA_ROUTE_AP_MIN		IPA_ROUTE_MODEM_COUNT
 #define IPA_ROUTE_AP_COUNT \
 		(IPA_ROUTE_COUNT_MAX - IPA_ROUTE_MODEM_COUNT)
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index b6a9a0d79d68..1538e2e1732f 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -13,6 +13,9 @@ struct ipa;
 /* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
 #define IPA_FILTER_COUNT_MAX	14
 
+/* The number of route table entries allotted to the modem */
+#define IPA_ROUTE_MODEM_COUNT	8
+
 /* The maximum number of route table entries (IPv4, IPv6; hashed or not) */
 #define IPA_ROUTE_COUNT_MAX	15
 
diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 6cd50106e611..d7fb6302d699 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -496,7 +496,6 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 
 static int ipvlan_process_outbound(struct sk_buff *skb)
 {
-	struct ethhdr *ethh = eth_hdr(skb);
 	int ret = NET_XMIT_DROP;
 
 	/* The ipvlan is a pseudo-L2 device, so the packets that we receive
@@ -506,6 +505,8 @@ static int ipvlan_process_outbound(struct sk_buff *skb)
 	if (skb_mac_header_was_set(skb)) {
 		/* In this mode we dont care about
 		 * multicast and broadcast traffic */
+		struct ethhdr *ethh = eth_hdr(skb);
+
 		if (is_multicast_ether_addr(ethh->h_dest)) {
 			pr_debug_ratelimited(
 				"Dropped {multi|broad}cast of type=[%x]\n",
@@ -590,7 +591,7 @@ static int ipvlan_xmit_mode_l3(struct sk_buff *skb, struct net_device *dev)
 static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
 {
 	const struct ipvl_dev *ipvlan = netdev_priv(dev);
-	struct ethhdr *eth = eth_hdr(skb);
+	struct ethhdr *eth = skb_eth_hdr(skb);
 	struct ipvl_addr *addr;
 	void *lyr3h;
 	int addr_type;
@@ -620,6 +621,7 @@ static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
 		return dev_forward_skb(ipvlan->phy_dev, skb);
 
 	} else if (is_multicast_ether_addr(eth->h_dest)) {
+		skb_reset_mac_header(skb);
 		ipvlan_skb_crossing_ns(skb, NULL);
 		ipvlan_multicast_enqueue(ipvlan->port, skb, true);
 		return NET_XMIT_SUCCESS;
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 9e3c815a070f..796e9c7857d0 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -231,6 +231,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	return 0;
 
 unregister:
+	of_node_put(child);
 	mdiobus_unregister(mdio);
 	return rc;
 }
diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 3221224525ac..2f2765d7f84c 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -90,6 +90,9 @@
 #define VEND1_GLOBAL_FW_ID_MAJOR		GENMASK(15, 8)
 #define VEND1_GLOBAL_FW_ID_MINOR		GENMASK(7, 0)
 
+#define VEND1_GLOBAL_GEN_STAT2			0xc831
+#define VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG	BIT(15)
+
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
 #define VEND1_GLOBAL_RSVD_STAT1_PROV_ID		GENMASK(3, 0)
@@ -124,6 +127,12 @@
 #define VEND1_GLOBAL_INT_VEND_MASK_GLOBAL2	BIT(1)
 #define VEND1_GLOBAL_INT_VEND_MASK_GLOBAL3	BIT(0)
 
+/* Sleep and timeout for checking if the Processor-Intensive
+ * MDIO operation is finished
+ */
+#define AQR107_OP_IN_PROG_SLEEP		1000
+#define AQR107_OP_IN_PROG_TIMEOUT	100000
+
 struct aqr107_hw_stat {
 	const char *name;
 	int reg;
@@ -598,16 +607,52 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
 		phydev_info(phydev, "Aquantia 1000Base-T2 mode active\n");
 }
 
+static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
+{
+	int val, err;
+
+	/* The datasheet notes to wait at least 1ms after issuing a
+	 * processor intensive operation before checking.
+	 * We cannot use the 'sleep_before_read' parameter of read_poll_timeout
+	 * because that just determines the maximum time slept, not the minimum.
+	 */
+	usleep_range(1000, 5000);
+
+	err = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
+					VEND1_GLOBAL_GEN_STAT2, val,
+					!(val & VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG),
+					AQR107_OP_IN_PROG_SLEEP,
+					AQR107_OP_IN_PROG_TIMEOUT, false);
+	if (err) {
+		phydev_err(phydev, "timeout: processor-intensive MDIO operation\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static int aqr107_suspend(struct phy_device *phydev)
 {
-	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
-				MDIO_CTRL1_LPOWER);
+	int err;
+
+	err = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
+			       MDIO_CTRL1_LPOWER);
+	if (err)
+		return err;
+
+	return aqr107_wait_processor_intensive_op(phydev);
 }
 
 static int aqr107_resume(struct phy_device *phydev)
 {
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
-				  MDIO_CTRL1_LPOWER);
+	int err;
+
+	err = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
+				 MDIO_CTRL1_LPOWER);
+	if (err)
+		return err;
+
+	return aqr107_wait_processor_intensive_op(phydev);
 }
 
 static int aqr107_probe(struct phy_device *phydev)
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index dd7917cab2b1..ab8f5097d3b0 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1270,10 +1270,12 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		}
 	}
 
-	netif_addr_lock_bh(dev);
-	dev_uc_sync_multiple(port_dev, dev);
-	dev_mc_sync_multiple(port_dev, dev);
-	netif_addr_unlock_bh(dev);
+	if (dev->flags & IFF_UP) {
+		netif_addr_lock_bh(dev);
+		dev_uc_sync_multiple(port_dev, dev);
+		dev_mc_sync_multiple(port_dev, dev);
+		netif_addr_unlock_bh(dev);
+	}
 
 	port->index = -1;
 	list_add_tail_rcu(&port->list, &team->port_list);
@@ -1344,8 +1346,10 @@ static int team_port_del(struct team *team, struct net_device *port_dev)
 	netdev_rx_handler_unregister(port_dev);
 	team_port_disable_netpoll(port);
 	vlan_vids_del_by_dev(port_dev, dev);
-	dev_uc_unsync(port_dev, dev);
-	dev_mc_unsync(port_dev, dev);
+	if (dev->flags & IFF_UP) {
+		dev_uc_unsync(port_dev, dev);
+		dev_mc_unsync(port_dev, dev);
+	}
 	dev_close(port_dev);
 	team_port_leave(team, port);
 
@@ -1695,6 +1699,14 @@ static int team_open(struct net_device *dev)
 
 static int team_close(struct net_device *dev)
 {
+	struct team *team = netdev_priv(dev);
+	struct team_port *port;
+
+	list_for_each_entry(port, &team->port_list, list) {
+		dev_uc_unsync(port->dev, dev);
+		dev_mc_unsync(port->dev, dev);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index d0f3b6d7f408..5c804bcabfe6 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -436,14 +436,13 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 	if (attrs[WGPEER_A_ENDPOINT]) {
 		struct sockaddr *addr = nla_data(attrs[WGPEER_A_ENDPOINT]);
 		size_t len = nla_len(attrs[WGPEER_A_ENDPOINT]);
+		struct endpoint endpoint = { { { 0 } } };
 
-		if ((len == sizeof(struct sockaddr_in) &&
-		     addr->sa_family == AF_INET) ||
-		    (len == sizeof(struct sockaddr_in6) &&
-		     addr->sa_family == AF_INET6)) {
-			struct endpoint endpoint = { { { 0 } } };
-
-			memcpy(&endpoint.addr, addr, len);
+		if (len == sizeof(struct sockaddr_in) && addr->sa_family == AF_INET) {
+			endpoint.addr4 = *(struct sockaddr_in *)addr;
+			wg_socket_set_peer_endpoint(peer, &endpoint);
+		} else if (len == sizeof(struct sockaddr_in6) && addr->sa_family == AF_INET6) {
+			endpoint.addr6 = *(struct sockaddr_in6 *)addr;
 			wg_socket_set_peer_endpoint(peer, &endpoint);
 		}
 	}
diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/selftest/ratelimiter.c
index ba87d294604f..d4bb40a695ab 100644
--- a/drivers/net/wireguard/selftest/ratelimiter.c
+++ b/drivers/net/wireguard/selftest/ratelimiter.c
@@ -6,29 +6,28 @@
 #ifdef DEBUG
 
 #include <linux/jiffies.h>
-#include <linux/hrtimer.h>
 
 static const struct {
 	bool result;
-	u64 nsec_to_sleep_before;
+	unsigned int msec_to_sleep_before;
 } expected_results[] __initconst = {
 	[0 ... PACKETS_BURSTABLE - 1] = { true, 0 },
 	[PACKETS_BURSTABLE] = { false, 0 },
-	[PACKETS_BURSTABLE + 1] = { true, NSEC_PER_SEC / PACKETS_PER_SECOND },
+	[PACKETS_BURSTABLE + 1] = { true, MSEC_PER_SEC / PACKETS_PER_SECOND },
 	[PACKETS_BURSTABLE + 2] = { false, 0 },
-	[PACKETS_BURSTABLE + 3] = { true, (NSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
+	[PACKETS_BURSTABLE + 3] = { true, (MSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
 	[PACKETS_BURSTABLE + 4] = { true, 0 },
 	[PACKETS_BURSTABLE + 5] = { false, 0 }
 };
 
 static __init unsigned int maximum_jiffies_at_index(int index)
 {
-	u64 total_nsecs = 2 * NSEC_PER_SEC / PACKETS_PER_SECOND / 3;
+	unsigned int total_msecs = 2 * MSEC_PER_SEC / PACKETS_PER_SECOND / 3;
 	int i;
 
 	for (i = 0; i <= index; ++i)
-		total_nsecs += expected_results[i].nsec_to_sleep_before;
-	return nsecs_to_jiffies(total_nsecs);
+		total_msecs += expected_results[i].msec_to_sleep_before;
+	return msecs_to_jiffies(total_msecs);
 }
 
 static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
@@ -43,12 +42,8 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
 	loop_start_time = jiffies;
 
 	for (i = 0; i < ARRAY_SIZE(expected_results); ++i) {
-		if (expected_results[i].nsec_to_sleep_before) {
-			ktime_t timeout = ktime_add(ktime_add_ns(ktime_get_coarse_boottime(), TICK_NSEC * 4 / 3),
-						    ns_to_ktime(expected_results[i].nsec_to_sleep_before));
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_hrtimeout_range_clock(&timeout, 0, HRTIMER_MODE_ABS, CLOCK_BOOTTIME);
-		}
+		if (expected_results[i].msec_to_sleep_before)
+			msleep(expected_results[i].msec_to_sleep_before);
 
 		if (time_is_before_jiffies(loop_start_time +
 					   maximum_jiffies_at_index(i)))
@@ -132,7 +127,7 @@ bool __init wg_ratelimiter_selftest(void)
 	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_UBSAN))
 		return true;
 
-	BUILD_BUG_ON(NSEC_PER_SEC % PACKETS_PER_SECOND != 0);
+	BUILD_BUG_ON(MSEC_PER_SEC % PACKETS_PER_SECOND != 0);
 
 	if (wg_ratelimiter_init())
 		goto out;
@@ -172,7 +167,7 @@ bool __init wg_ratelimiter_selftest(void)
 	++test;
 #endif
 
-	for (trials = TRIALS_BEFORE_GIVING_UP;;) {
+	for (trials = TRIALS_BEFORE_GIVING_UP; IS_ENABLED(DEBUG_RATELIMITER_TIMINGS);) {
 		int test_count = 0, ret;
 
 		ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 8f4a5d4929e0..9ba7963a89f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1038,7 +1038,7 @@ u32 mt7615_mac_get_sta_tid_sn(struct mt7615_dev *dev, int wcid, u8 tid)
 	offset %= 32;
 
 	val = mt76_rr(dev, addr);
-	val >>= (tid % 32);
+	val >>= offset;
 
 	if (offset > 20) {
 		addr += 4;
diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index dc78a523a69f..b6b938aa6615 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -675,12 +675,12 @@ int dasd_alias_remove_device(struct dasd_device *device)
 struct dasd_device *dasd_alias_get_start_dev(struct dasd_device *base_device)
 {
 	struct dasd_eckd_private *alias_priv, *private = base_device->private;
-	struct alias_pav_group *group = private->pavgroup;
 	struct alias_lcu *lcu = private->lcu;
 	struct dasd_device *alias_device;
+	struct alias_pav_group *group;
 	unsigned long flags;
 
-	if (!group || !lcu)
+	if (!lcu)
 		return NULL;
 	if (lcu->pav == NO_PAV ||
 	    lcu->flags & (NEED_UAC_UPDATE | UPDATE_PENDING))
@@ -697,6 +697,11 @@ struct dasd_device *dasd_alias_get_start_dev(struct dasd_device *base_device)
 	}
 
 	spin_lock_irqsave(&lcu->lock, flags);
+	group = private->pavgroup;
+	if (!group) {
+		spin_unlock_irqrestore(&lcu->lock, flags);
+		return NULL;
+	}
 	alias_device = group->next;
 	if (!alias_device) {
 		if (list_empty(&group->aliaslist)) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index fafa9fbf3b10..be024b2b6bd4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3005,7 +3005,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 
 	if (ioc->is_mcpu_endpoint ||
 	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-	    dma_get_required_mask(&pdev->dev) <= 32)
+	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
 		ioc->dma_mask = 32;
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
 	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b86f6e1f21b5..4b4ca2a9524d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2166,8 +2166,10 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 
 	abort_cmd = ha->tgt.tgt_ops->find_cmd_by_tag(sess,
 				le32_to_cpu(abts->exchange_addr_to_abort));
-	if (!abort_cmd)
+	if (!abort_cmd) {
+		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
 		return -EIO;
+	}
 	mcmd->unpacked_lun = abort_cmd->se_cmd.orig_fe_lun;
 
 	if (abort_cmd->qpair) {
diff --git a/drivers/staging/r8188eu/os_dep/usb_intf.c b/drivers/staging/r8188eu/os_dep/usb_intf.c
index bb85ab77fd26..640f1ca2d985 100644
--- a/drivers/staging/r8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/r8188eu/os_dep/usb_intf.c
@@ -30,7 +30,7 @@ static struct usb_device_id rtw_usb_id_tbl[] = {
 	/*=== Realtek demoboard ===*/
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8179)}, /* 8188EUS */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0x0179)}, /* 8188ETV */
-	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xf179)}, /* 8188FU */
+	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill USB-N150 Nano */
 	/*=== Customer ID ===*/
 	/****** 8188EUS ********/
 	{USB_DEVICE(0x07B8, 0x8179)}, /* Abocom - Abocom */
diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index 6255f1ef9599..69eead8a6015 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2522,6 +2522,7 @@ struct tb *icm_probe(struct tb_nhi *nhi)
 		tb->cm_ops = &icm_icl_ops;
 		break;
 
+	case PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_2C_NHI:
 	case PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_4C_NHI:
 		icm->is_supported = icm_tgl_is_supported;
 		icm->get_mode = icm_ar_get_mode;
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 69083aab2736..5091677b3f4b 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -55,6 +55,7 @@ extern const struct tb_nhi_ops icl_nhi_ops;
  * need for the PCI quirk anymore as we will use ICM also on Apple
  * hardware.
  */
+#define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_2C_NHI		0x1134
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_4C_NHI		0x1137
 #define PCI_DEVICE_ID_INTEL_WIN_RIDGE_2C_NHI            0x157d
 #define PCI_DEVICE_ID_INTEL_WIN_RIDGE_2C_BRIDGE         0x157e
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index bf11ffafcad5..b6548b910d94 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2726,14 +2726,15 @@ static int lpuart_probe(struct platform_device *pdev)
 		lpuart_reg.cons = LPUART_CONSOLE;
 		handler = lpuart_int;
 	}
-	ret = uart_add_one_port(&lpuart_reg, &sport->port);
-	if (ret)
-		goto failed_attach_port;
 
 	ret = lpuart_global_reset(sport);
 	if (ret)
 		goto failed_reset;
 
+	ret = uart_add_one_port(&lpuart_reg, &sport->port);
+	if (ret)
+		goto failed_attach_port;
+
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
@@ -2756,9 +2757,9 @@ static int lpuart_probe(struct platform_device *pdev)
 
 failed_irq_request:
 failed_get_rs485:
-failed_reset:
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
+failed_reset:
 	lpuart_disable_clks(sport);
 	return ret;
 }
diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index b6223fab0687..d4dba298de7a 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -525,7 +525,7 @@ static void tegra_uart_tx_dma_complete(void *args)
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
 	spin_lock_irqsave(&tup->uport.lock, flags);
-	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uart_xmit_advance(&tup->uport, count);
 	tup->tx_in_progress = 0;
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&tup->uport);
@@ -613,7 +613,6 @@ static unsigned int tegra_uart_tx_empty(struct uart_port *u)
 static void tegra_uart_stop_tx(struct uart_port *u)
 {
 	struct tegra_uart_port *tup = to_tegra_uport(u);
-	struct circ_buf *xmit = &tup->uport.state->xmit;
 	struct dma_tx_state state;
 	unsigned int count;
 
@@ -624,7 +623,7 @@ static void tegra_uart_stop_tx(struct uart_port *u)
 	dmaengine_tx_status(tup->tx_dma_chan, tup->tx_cookie, &state);
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
-	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uart_xmit_advance(&tup->uport, count);
 	tup->tx_in_progress = 0;
 }
 
diff --git a/drivers/tty/serial/tegra-tcu.c b/drivers/tty/serial/tegra-tcu.c
index 4877c54c613d..889b701ba7c6 100644
--- a/drivers/tty/serial/tegra-tcu.c
+++ b/drivers/tty/serial/tegra-tcu.c
@@ -101,7 +101,7 @@ static void tegra_tcu_uart_start_tx(struct uart_port *port)
 			break;
 
 		tegra_tcu_write(tcu, &xmit->buf[xmit->tail], count);
-		xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+		uart_xmit_advance(port, count);
 	}
 
 	uart_write_wakeup(port);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 23896c8e018a..98bdae4ac314 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -6044,7 +6044,7 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
  *
  * Return: The same as for usb_reset_and_verify_device().
  * However, if a reset is already in progress (for instance, if a
- * driver doesn't have pre_ or post_reset() callbacks, and while
+ * driver doesn't have pre_reset() or post_reset() callbacks, and while
  * being unbound or re-bound during the ongoing reset its disconnect()
  * or probe() routine tries to perform a second, nested reset), the
  * routine returns -EINPROGRESS.
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 9c24cf46b9a0..c32ca691bcc7 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -114,8 +114,6 @@ void dwc3_set_prtcap(struct dwc3 *dwc, u32 mode)
 	dwc->current_dr_role = mode;
 }
 
-static int dwc3_core_soft_reset(struct dwc3 *dwc);
-
 static void __dwc3_set_mode(struct work_struct *work)
 {
 	struct dwc3 *dwc = work_to_dwc(work);
@@ -265,7 +263,7 @@ u32 dwc3_core_fifo_space(struct dwc3_ep *dep, u8 type)
  * dwc3_core_soft_reset - Issues core soft reset and PHY reset
  * @dwc: pointer to our context structure
  */
-static int dwc3_core_soft_reset(struct dwc3 *dwc)
+int dwc3_core_soft_reset(struct dwc3 *dwc)
 {
 	u32		reg;
 	int		retries = 1000;
@@ -1572,12 +1570,6 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	dwc3_get_properties(dwc);
 
-	if (!dwc->sysdev_is_parent) {
-		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
-		if (ret)
-			return ret;
-	}
-
 	dwc->reset = devm_reset_control_array_get_optional_shared(dev);
 	if (IS_ERR(dwc->reset))
 		return PTR_ERR(dwc->reset);
@@ -1614,6 +1606,13 @@ static int dwc3_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dwc);
 	dwc3_cache_hwparams(dwc);
 
+	if (!dwc->sysdev_is_parent &&
+	    DWC3_GHWPARAMS0_AWIDTH(dwc->hwparams.hwparams0) == 64) {
+		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
+		if (ret)
+			goto disable_clks;
+	}
+
 	spin_lock_init(&dwc->lock);
 	mutex_init(&dwc->mutex);
 
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index fd5d42ec5350..077d03a33388 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1028,6 +1028,7 @@ struct dwc3_scratchpad_array {
  * @tx_fifo_resize_max_num: max number of fifos allocated during txfifo resize
  * @hsphy_interface: "utmi" or "ulpi"
  * @connected: true when we're connected to a host, false otherwise
+ * @softconnect: true when gadget connect is called, false when disconnect runs
  * @delayed_status: true when gadget driver asks for delayed status
  * @ep0_bounced: true when we used bounce buffer
  * @ep0_expect_in: true when we expect a DATA IN transfer
@@ -1247,6 +1248,7 @@ struct dwc3 {
 	const char		*hsphy_interface;
 
 	unsigned		connected:1;
+	unsigned		softconnect:1;
 	unsigned		delayed_status:1;
 	unsigned		ep0_bounced:1;
 	unsigned		ep0_expect_in:1;
@@ -1508,6 +1510,8 @@ bool dwc3_has_imod(struct dwc3 *dwc);
 int dwc3_event_buffers_setup(struct dwc3 *dwc);
 void dwc3_event_buffers_cleanup(struct dwc3 *dwc);
 
+int dwc3_core_soft_reset(struct dwc3 *dwc);
+
 #if IS_ENABLED(CONFIG_USB_DWC3_HOST) || IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE)
 int dwc3_host_init(struct dwc3 *dwc);
 void dwc3_host_exit(struct dwc3 *dwc);
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 322754a7f91c..14dcdb923f40 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2435,14 +2435,42 @@ static void dwc3_gadget_disable_irq(struct dwc3 *dwc);
 static void __dwc3_gadget_stop(struct dwc3 *dwc);
 static int __dwc3_gadget_start(struct dwc3 *dwc);
 
+static int dwc3_gadget_soft_disconnect(struct dwc3 *dwc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dwc->lock, flags);
+	dwc->connected = false;
+
+	/*
+	 * In the Synopsys DesignWare Cores USB3 Databook Rev. 3.30a
+	 * Section 4.1.8 Table 4-7, it states that for a device-initiated
+	 * disconnect, the SW needs to ensure that it sends "a DEPENDXFER
+	 * command for any active transfers" before clearing the RunStop
+	 * bit.
+	 */
+	dwc3_stop_active_transfers(dwc);
+	__dwc3_gadget_stop(dwc);
+	spin_unlock_irqrestore(&dwc->lock, flags);
+
+	/*
+	 * Note: if the GEVNTCOUNT indicates events in the event buffer, the
+	 * driver needs to acknowledge them before the controller can halt.
+	 * Simply let the interrupt handler acknowledges and handle the
+	 * remaining event generated by the controller while polling for
+	 * DSTS.DEVCTLHLT.
+	 */
+	return dwc3_gadget_run_stop(dwc, false, false);
+}
+
 static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 {
 	struct dwc3		*dwc = gadget_to_dwc(g);
-	unsigned long		flags;
 	int			ret;
 
 	is_on = !!is_on;
 
+	dwc->softconnect = is_on;
 	/*
 	 * Per databook, when we want to stop the gadget, if a control transfer
 	 * is still in process, complete it and get the core into setup phase.
@@ -2478,50 +2506,27 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 		return 0;
 	}
 
-	/*
-	 * Synchronize and disable any further event handling while controller
-	 * is being enabled/disabled.
-	 */
-	disable_irq(dwc->irq_gadget);
-
-	spin_lock_irqsave(&dwc->lock, flags);
+	if (dwc->pullups_connected == is_on) {
+		pm_runtime_put(dwc->dev);
+		return 0;
+	}
 
 	if (!is_on) {
-		u32 count;
-
-		dwc->connected = false;
+		ret = dwc3_gadget_soft_disconnect(dwc);
+	} else {
 		/*
-		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
-		 * Section 4.1.8 Table 4-7, it states that for a device-initiated
-		 * disconnect, the SW needs to ensure that it sends "a DEPENDXFER
-		 * command for any active transfers" before clearing the RunStop
-		 * bit.
+		 * In the Synopsys DWC_usb31 1.90a programming guide section
+		 * 4.1.9, it specifies that for a reconnect after a
+		 * device-initiated disconnect requires a core soft reset
+		 * (DCTL.CSftRst) before enabling the run/stop bit.
 		 */
-		dwc3_stop_active_transfers(dwc);
-		__dwc3_gadget_stop(dwc);
+		dwc3_core_soft_reset(dwc);
 
-		/*
-		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
-		 * Section 1.3.4, it mentions that for the DEVCTRLHLT bit, the
-		 * "software needs to acknowledge the events that are generated
-		 * (by writing to GEVNTCOUNTn) while it is waiting for this bit
-		 * to be set to '1'."
-		 */
-		count = dwc3_readl(dwc->regs, DWC3_GEVNTCOUNT(0));
-		count &= DWC3_GEVNTCOUNT_MASK;
-		if (count > 0) {
-			dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), count);
-			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
-						dwc->ev_buf->length;
-		}
-	} else {
+		dwc3_event_buffers_setup(dwc);
 		__dwc3_gadget_start(dwc);
+		ret = dwc3_gadget_run_stop(dwc, true, false);
 	}
 
-	ret = dwc3_gadget_run_stop(dwc, is_on, false);
-	spin_unlock_irqrestore(&dwc->lock, flags);
-	enable_irq(dwc->irq_gadget);
-
 	pm_runtime_put(dwc->dev);
 
 	return ret;
@@ -4421,7 +4426,7 @@ int dwc3_gadget_resume(struct dwc3 *dwc)
 {
 	int			ret;
 
-	if (!dwc->gadget_driver)
+	if (!dwc->gadget_driver || !dwc->softconnect)
 		return 0;
 
 	ret = __dwc3_gadget_start(dwc);
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index a5e8374a8d71..697683e3fbff 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -256,6 +256,7 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_EM060K			0x030b
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
+#define QUECTEL_PRODUCT_RM520N			0x0801
 #define QUECTEL_PRODUCT_EC200S_CN		0x6002
 #define QUECTEL_PRODUCT_EC200T			0x6026
 #define QUECTEL_PRODUCT_RM500K			0x7001
@@ -1138,6 +1139,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0, 0) },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, 0x0203, 0xff), /* BG95-M3 */
+	  .driver_info = ZLP },
 	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_BG96),
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0xff, 0xff),
@@ -1159,6 +1162,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x10),
 	  .driver_info = ZLP },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c76c360bece5..f4015556cafa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4297,6 +4297,17 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 
 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
 
+	/*
+	 * If we had UNFINISHED_DROPS we could still be processing them, so
+	 * clear that bit and wake up relocation so it can stop.
+	 * We must do this before stopping the block group reclaim task, because
+	 * at btrfs_relocate_block_group() we wait for this bit, and after the
+	 * wait we stop with -EINTR if btrfs_fs_closing() returns non-zero - we
+	 * have just set BTRFS_FS_CLOSING_START, so btrfs_fs_closing() will
+	 * return 1.
+	 */
+	btrfs_wake_unfinished_drop(fs_info);
+
 	/*
 	 * We may have the reclaim task running and relocating a data block group,
 	 * in which case it may create delayed iputs. So stop it before we park
@@ -4315,12 +4326,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 */
 	kthread_park(fs_info->cleaner_kthread);
 
-	/*
-	 * If we had UNFINISHED_DROPS we could still be processing them, so
-	 * clear that bit and wake up relocation so it can stop.
-	 */
-	btrfs_wake_unfinished_drop(fs_info);
-
 	/* wait for the qgroup rescan worker to stop */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 
@@ -4343,6 +4348,31 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_cleanup_defrag_inodes(fs_info);
 
+	/*
+	 * After we parked the cleaner kthread, ordered extents may have
+	 * completed and created new delayed iputs. If one of the async reclaim
+	 * tasks is running and in the RUN_DELAYED_IPUTS flush state, then we
+	 * can hang forever trying to stop it, because if a delayed iput is
+	 * added after it ran btrfs_run_delayed_iputs() and before it called
+	 * btrfs_wait_on_delayed_iputs(), it will hang forever since there is
+	 * no one else to run iputs.
+	 *
+	 * So wait for all ongoing ordered extents to complete and then run
+	 * delayed iputs. This works because once we reach this point no one
+	 * can either create new ordered extents nor create delayed iputs
+	 * through some other means.
+	 *
+	 * Also note that btrfs_wait_ordered_roots() is not safe here, because
+	 * it waits for BTRFS_ORDERED_COMPLETE to be set on an ordered extent,
+	 * but the delayed iput for the respective inode is made only when doing
+	 * the final btrfs_put_ordered_extent() (which must happen at
+	 * btrfs_finish_ordered_io() when we are unmounting).
+	 */
+	btrfs_flush_workqueue(fs_info->endio_write_workers);
+	/* Ordered extents for free space inodes. */
+	btrfs_flush_workqueue(fs_info->endio_freespace_worker);
+	btrfs_run_delayed_iputs(fs_info);
+
 	cancel_work_sync(&fs_info->async_reclaim_work);
 	cancel_work_sync(&fs_info->async_data_reclaim_work);
 	cancel_work_sync(&fs_info->preempt_reclaim_work);
diff --git a/fs/dax.c b/fs/dax.c
index 1d0658cf9dcf..4ab1c493c73f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1279,6 +1279,9 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t done = 0;
 	int ret;
 
+	if (!iomi.len)
+		return 0;
+
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 29be8783b9a6..725607520e84 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -460,6 +460,10 @@ static int __ext4_ext_check(const char *function, unsigned int line,
 		error_msg = "invalid eh_entries";
 		goto corrupted;
 	}
+	if (unlikely((eh->eh_entries == 0) && (depth > 0))) {
+		error_msg = "eh_entries is 0 but eh_depth is > 0";
+		goto corrupted;
+	}
 	if (!ext4_valid_extent_entries(inode, eh, lblk, &pblk, depth)) {
 		error_msg = "invalid extent entries";
 		goto corrupted;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f73e5eb43eae..208b87ce8858 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -510,7 +510,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 		goto fallback;
 	}
 
-	max_dirs = ndirs / ngroups + inodes_per_group / 16;
+	max_dirs = ndirs / ngroups + inodes_per_group*flex_size / 16;
 	min_inodes = avefreei - inodes_per_group*flex_size / 4;
 	if (min_inodes < 1)
 		min_inodes = 1;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ad78bddfb637..0c7498a59943 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1052,8 +1052,10 @@ static void ext4_mb_choose_next_group(struct ext4_allocation_context *ac,
 {
 	*new_cr = ac->ac_criteria;
 
-	if (!should_optimize_scan(ac) || ac->ac_groups_linear_remaining)
+	if (!should_optimize_scan(ac) || ac->ac_groups_linear_remaining) {
+		*group = next_linear_group(ac, *group, ngroups);
 		return;
+	}
 
 	if (*new_cr == 0) {
 		ext4_mb_choose_next_group_cr0(ac, new_cr, group, ngroups);
@@ -1078,23 +1080,25 @@ mb_set_largest_free_order(struct super_block *sb, struct ext4_group_info *grp)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int i;
 
-	if (test_opt2(sb, MB_OPTIMIZE_SCAN) && grp->bb_largest_free_order >= 0) {
+	for (i = MB_NUM_ORDERS(sb) - 1; i >= 0; i--)
+		if (grp->bb_counters[i] > 0)
+			break;
+	/* No need to move between order lists? */
+	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) ||
+	    i == grp->bb_largest_free_order) {
+		grp->bb_largest_free_order = i;
+		return;
+	}
+
+	if (grp->bb_largest_free_order >= 0) {
 		write_lock(&sbi->s_mb_largest_free_orders_locks[
 					      grp->bb_largest_free_order]);
 		list_del_init(&grp->bb_largest_free_order_node);
 		write_unlock(&sbi->s_mb_largest_free_orders_locks[
 					      grp->bb_largest_free_order]);
 	}
-	grp->bb_largest_free_order = -1; /* uninit */
-
-	for (i = MB_NUM_ORDERS(sb) - 1; i >= 0; i--) {
-		if (grp->bb_counters[i] > 0) {
-			grp->bb_largest_free_order = i;
-			break;
-		}
-	}
-	if (test_opt2(sb, MB_OPTIMIZE_SCAN) &&
-	    grp->bb_largest_free_order >= 0 && grp->bb_free) {
+	grp->bb_largest_free_order = i;
+	if (grp->bb_largest_free_order >= 0 && grp->bb_free) {
 		write_lock(&sbi->s_mb_largest_free_orders_locks[
 					      grp->bb_largest_free_order]);
 		list_add_tail(&grp->bb_largest_free_order_node,
@@ -2633,7 +2637,7 @@ static noinline_for_stack int
 ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
 	ext4_group_t prefetch_grp = 0, ngroups, group, i;
-	int cr = -1;
+	int cr = -1, new_cr;
 	int err = 0, first_err = 0;
 	unsigned int nr = 0, prefetch_ios = 0;
 	struct ext4_sb_info *sbi;
@@ -2708,13 +2712,11 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		ac->ac_groups_linear_remaining = sbi->s_mb_max_linear_groups;
 		prefetch_grp = group;
 
-		for (i = 0; i < ngroups; group = next_linear_group(ac, group, ngroups),
-			     i++) {
-			int ret = 0, new_cr;
+		for (i = 0, new_cr = cr; i < ngroups; i++,
+		     ext4_mb_choose_next_group(ac, &new_cr, &group, ngroups)) {
+			int ret = 0;
 
 			cond_resched();
-
-			ext4_mb_choose_next_group(ac, &new_cr, &group, ngroups);
 			if (new_cr != cr) {
 				cr = new_cr;
 				goto repeat;
@@ -5167,6 +5169,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	int bsbits = ac->ac_sb->s_blocksize_bits;
 	loff_t size, isize;
+	bool inode_pa_eligible, group_pa_eligible;
 
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return;
@@ -5174,25 +5177,27 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
 		return;
 
+	group_pa_eligible = sbi->s_mb_group_prealloc > 0;
+	inode_pa_eligible = true;
 	size = ac->ac_o_ex.fe_logical + EXT4_C2B(sbi, ac->ac_o_ex.fe_len);
 	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
 		>> bsbits;
 
+	/* No point in using inode preallocation for closed files */
 	if ((size == isize) && !ext4_fs_is_busy(sbi) &&
-	    !inode_is_open_for_write(ac->ac_inode)) {
-		ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
-		return;
-	}
-
-	if (sbi->s_mb_group_prealloc <= 0) {
-		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
-		return;
-	}
+	    !inode_is_open_for_write(ac->ac_inode))
+		inode_pa_eligible = false;
 
-	/* don't use group allocation for large files */
 	size = max(size, isize);
-	if (size > sbi->s_mb_stream_request) {
-		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
+	/* Don't use group allocation for large files */
+	if (size > sbi->s_mb_stream_request)
+		group_pa_eligible = false;
+
+	if (!group_pa_eligible) {
+		if (inode_pa_eligible)
+			ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
+		else
+			ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
 		return;
 	}
 
@@ -5539,6 +5544,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	ext4_fsblk_t block = 0;
 	unsigned int inquota = 0;
 	unsigned int reserv_clstrs = 0;
+	int retries = 0;
 	u64 seq;
 
 	might_sleep();
@@ -5641,7 +5647,8 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 			ar->len = ac->ac_b_ex.fe_len;
 		}
 	} else {
-		if (ext4_mb_discard_preallocations_should_retry(sb, ac, &seq))
+		if (++retries < 3 &&
+		    ext4_mb_discard_preallocations_should_retry(sb, ac, &seq))
 			goto repeat;
 		/*
 		 * If block allocation fails then the pa allocated above
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 11118398f495..7c9eb679dbdb 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -755,11 +755,13 @@ int nfs4_inode_return_delegation(struct inode *inode)
 	struct nfs_delegation *delegation;
 
 	delegation = nfs_start_delegation_return(nfsi);
-	/* Synchronous recall of any application leases */
-	break_lease(inode, O_WRONLY | O_RDWR);
-	nfs_wb_all(inode);
-	if (delegation != NULL)
+	if (delegation != NULL) {
+		/* Synchronous recall of any application leases */
+		break_lease(inode, O_WRONLY | O_RDWR);
+		if (S_ISREG(inode->i_mode))
+			nfs_wb_all(inode);
 		return nfs_end_delegation_return(inode, delegation, 1);
+	}
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3932b4ebf903..f84d3fbb9d3d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -337,19 +337,36 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	mode_t			mode = be16_to_cpu(dip->di_mode);
+	uint32_t		fork_size = XFS_DFORK_SIZE(dip, mp, whichfork);
+	uint32_t		fork_format = XFS_DFORK_FORMAT(dip, whichfork);
 
-	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
+	/*
+	 * For fork types that can contain local data, check that the fork
+	 * format matches the size of local data contained within the fork.
+	 *
+	 * For all types, check that when the size says the should be in extent
+	 * or btree format, the inode isn't claiming it is in local format.
+	 */
+	if (whichfork == XFS_DATA_FORK) {
+		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
+		if (be64_to_cpu(dip->di_size) > fork_size &&
+		    fork_format == XFS_DINODE_FMT_LOCAL)
+			return __this_address;
+	}
+
+	switch (fork_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
-		 * no local regular files yet
+		 * No local regular files yet.
 		 */
-		if (whichfork == XFS_DATA_FORK) {
-			if (S_ISREG(be16_to_cpu(dip->di_mode)))
-				return __this_address;
-			if (be64_to_cpu(dip->di_size) >
-					XFS_DFORK_SIZE(dip, mp, whichfork))
-				return __this_address;
-		}
+		if (S_ISREG(mode) && whichfork == XFS_DATA_FORK)
+			return __this_address;
 		if (di_nextents)
 			return __this_address;
 		break;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fb7a97cdf99f..b2ea85318214 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2599,14 +2599,13 @@ xfs_ifree_cluster(
 }
 
 /*
- * This is called to return an inode to the inode free list.
- * The inode should already be truncated to 0 length and have
- * no pages associated with it.  This routine also assumes that
- * the inode is already a part of the transaction.
+ * This is called to return an inode to the inode free list.  The inode should
+ * already be truncated to 0 length and have no pages associated with it.  This
+ * routine also assumes that the inode is already a part of the transaction.
  *
- * The on-disk copy of the inode will have been added to the list
- * of unlinked inodes in the AGI. We need to remove the inode from
- * that list atomically with respect to freeing it here.
+ * The on-disk copy of the inode will have been added to the list of unlinked
+ * inodes in the AGI. We need to remove the inode from that list atomically with
+ * respect to freeing it here.
  */
 int
 xfs_ifree(
@@ -2628,13 +2627,16 @@ xfs_ifree(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
 	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_iunlink_remove(tp, pag, ip);
+	error = xfs_difree(tp, pag, ip->i_ino, &xic);
 	if (error)
 		goto out;
 
-	error = xfs_difree(tp, pag, ip->i_ino, &xic);
+	error = xfs_iunlink_remove(tp, pag, ip);
 	if (error)
 		goto out;
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f2984af2b85b..9eac202fbcfd 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -549,10 +549,9 @@
  */
 #ifdef CONFIG_CFI_CLANG
 #define TEXT_CFI_JT							\
-		. = ALIGN(PMD_SIZE);					\
+		ALIGN_FUNCTION();					\
 		__cfi_jt_start = .;					\
 		*(.text..L.cfi.jumptable .text..L.cfi.jumptable.*)	\
-		. = ALIGN(PMD_SIZE);					\
 		__cfi_jt_end = .;
 #else
 #define TEXT_CFI_JT
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 054e654f06de..b3c230dea071 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -1057,9 +1057,10 @@ cpumap_print_list_to_buf(char *buf, const struct cpumask *mask,
  * cover a worst-case of every other cpu being on one of two nodes for a
  * very large NR_CPUS.
  *
- *  Use PAGE_SIZE as a minimum for smaller configurations.
+ *  Use PAGE_SIZE as a minimum for smaller configurations while avoiding
+ *  unsigned comparison to -1.
  */
-#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32 - 1) > PAGE_SIZE) \
+#define CPUMAP_FILE_MAX_BYTES  (((NR_CPUS * 9)/32 > PAGE_SIZE) \
 					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
 #define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 6d07b5f9e3b8..8757b4a6be31 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -300,6 +300,23 @@ struct uart_state {
 /* number of characters left in xmit buffer before we ask for more */
 #define WAKEUP_CHARS		256
 
+/**
+ * uart_xmit_advance - Advance xmit buffer and account Tx'ed chars
+ * @up: uart_port structure describing the port
+ * @chars: number of characters sent
+ *
+ * This function advances the tail of circular xmit buffer by the number of
+ * @chars transmitted and handles accounting of transmitted bytes (into
+ * @up's icount.tx).
+ */
+static inline void uart_xmit_advance(struct uart_port *up, unsigned int chars)
+{
+	struct circ_buf *xmit = &up->state->xmit;
+
+	xmit->tail = (xmit->tail + chars) & (UART_XMIT_SIZE - 1);
+	up->icount.tx += chars;
+}
+
 struct module;
 struct tty_driver;
 
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index 184105d68294..f2273bd5a4c5 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -15,8 +15,6 @@
 #define PKT_TYPE_LACPDU         cpu_to_be16(ETH_P_SLOW)
 #define AD_TIMER_INTERVAL       100 /*msec*/
 
-#define MULTICAST_LACPDU_ADDR    {0x01, 0x80, 0xC2, 0x00, 0x00, 0x02}
-
 #define AD_LACP_SLOW 0
 #define AD_LACP_FAST 1
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 15e083e18f75..8c18c6b01634 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -757,6 +757,9 @@ extern struct rtnl_link_ops bond_link_ops;
 /* exported from bond_sysfs_slave.c */
 extern const struct sysfs_ops slave_sysfs_ops;
 
+/* exported from bond_3ad.c */
+extern const u8 lacpdu_mcast_addr[];
+
 static inline netdev_tx_t bond_tx_drop(struct net_device *dev, struct sk_buff *skb)
 {
 	atomic_long_inc(&dev->tx_dropped);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3f4d27668576..f5fa7be8d17e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3083,10 +3083,8 @@ static bool __flush_work(struct work_struct *work, bool from_cancel)
 	if (WARN_ON(!work->func))
 		return false;
 
-	if (!from_cancel) {
-		lock_map_acquire(&work->lockdep_map);
-		lock_map_release(&work->lockdep_map);
-	}
+	lock_map_acquire(&work->lockdep_map);
+	lock_map_release(&work->lockdep_map);
 
 	if (start_flush_work(work, &barr, from_cancel)) {
 		wait_for_completion(&barr.done);
diff --git a/mm/slub.c b/mm/slub.c
index 519bbbad7b2f..f95ae136a069 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -308,6 +308,11 @@ static inline void stat(const struct kmem_cache *s, enum stat_item si)
  */
 static nodemask_t slab_nodes;
 
+/*
+ * Workqueue used for flush_cpu_slab().
+ */
+static struct workqueue_struct *flushwq;
+
 /********************************************************************
  * 			Core slab cache functions
  *******************************************************************/
@@ -2688,7 +2693,7 @@ static void flush_all_cpus_locked(struct kmem_cache *s)
 		INIT_WORK(&sfw->work, flush_cpu_slab);
 		sfw->skip = false;
 		sfw->s = s;
-		schedule_work_on(cpu, &sfw->work);
+		queue_work_on(cpu, flushwq, &sfw->work);
 	}
 
 	for_each_online_cpu(cpu) {
@@ -4850,6 +4855,8 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
+	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
+	WARN_ON(!flushwq);
 }
 
 struct kmem_cache *
@@ -4920,6 +4927,8 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 	/* Honor the call site pointer we received. */
 	trace_kmalloc(caller, ret, size, s->size, gfpflags);
 
+	ret = kasan_kmalloc(s, ret, size, gfpflags);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
@@ -4951,6 +4960,8 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	/* Honor the call site pointer we received. */
 	trace_kmalloc_node(caller, ret, size, s->size, gfpflags, node);
 
+	ret = kasan_kmalloc(s, ret, size, gfpflags);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller);
@@ -5865,7 +5876,8 @@ static char *create_unique_id(struct kmem_cache *s)
 	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
 	char *p = name;
 
-	BUG_ON(!name);
+	if (!name)
+		return ERR_PTR(-ENOMEM);
 
 	*p++ = ':';
 	/*
@@ -5923,6 +5935,8 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		 * for the symlinks.
 		 */
 		name = create_unique_id(s);
+		if (IS_ERR(name))
+			return PTR_ERR(name);
 	}
 
 	s->kobj.kset = kset;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 8905fe2fe023..16774559c52c 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1040,8 +1040,10 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_iterate;
 	}
 
-	if (repl->valid_hooks != t->valid_hooks)
+	if (repl->valid_hooks != t->valid_hooks) {
+		ret = -EINVAL;
 		goto free_unlock;
+	}
 
 	if (repl->num_counters && repl->num_counters != t->private->nentries) {
 		ret = -EINVAL;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index bc50bd331d5b..1c34e2266578 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1519,9 +1519,8 @@ static inline void __flow_hash_consistentify(struct flow_keys *keys)
 
 	switch (keys->control.addr_type) {
 	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
-		addr_diff = (__force u32)keys->addrs.v4addrs.dst -
-			    (__force u32)keys->addrs.v4addrs.src;
-		if (addr_diff < 0)
+		if ((__force u32)keys->addrs.v4addrs.dst <
+		    (__force u32)keys->addrs.v4addrs.src)
 			swap(keys->addrs.v4addrs.src, keys->addrs.v4addrs.dst);
 
 		if ((__force u16)keys->ports.dst <
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 18b90e334b5b..159e1e4441a4 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -151,15 +151,37 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	data = ib_ptr;
 	data_limit = ib_ptr + skb->len - dataoff;
 
-	/* strlen("\1DCC SENT t AAAAAAAA P\1\n")=24
-	 * 5+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=14 */
-	while (data < data_limit - (19 + MINMATCHLEN)) {
-		if (memcmp(data, "\1DCC ", 5)) {
+	/* Skip any whitespace */
+	while (data < data_limit - 10) {
+		if (*data == ' ' || *data == '\r' || *data == '\n')
+			data++;
+		else
+			break;
+	}
+
+	/* strlen("PRIVMSG x ")=10 */
+	if (data < data_limit - 10) {
+		if (strncasecmp("PRIVMSG ", data, 8))
+			goto out;
+		data += 8;
+	}
+
+	/* strlen(" :\1DCC SENT t AAAAAAAA P\1\n")=26
+	 * 7+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=26
+	 */
+	while (data < data_limit - (21 + MINMATCHLEN)) {
+		/* Find first " :", the start of message */
+		if (memcmp(data, " :", 2)) {
 			data++;
 			continue;
 		}
+		data += 2;
+
+		/* then check that place only for the DCC command */
+		if (memcmp(data, "\1DCC ", 5))
+			goto out;
 		data += 5;
-		/* we have at least (19+MINMATCHLEN)-5 bytes valid data left */
+		/* we have at least (21+MINMATCHLEN)-(2+5) bytes valid data left */
 
 		iph = ip_hdr(skb);
 		pr_debug("DCC found in master %pI4:%u %pI4:%u\n",
@@ -175,7 +197,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			pr_debug("DCC %s detected\n", dccprotos[i]);
 
 			/* we have at least
-			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
+			 * (21+MINMATCHLEN)-7-dccprotos[i].matchlen bytes valid
 			 * data left (== 14/13 bytes) */
 			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index b83dc9bf0a5d..78fd9122b70c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -477,7 +477,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 				return ret;
 			if (ret == 0)
 				break;
-			dataoff += *matchoff;
+			dataoff = *matchoff;
 		}
 		*in_header = 0;
 	}
@@ -489,7 +489,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 			break;
 		if (ret == 0)
 			return ret;
-		dataoff += *matchoff;
+		dataoff = *matchoff;
 	}
 
 	if (in_header)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d35d09df83fe..460ad341d160 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2103,7 +2103,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
-	struct nft_stats __percpu *stats = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_base_chain *basechain;
 	struct net *net = ctx->net;
@@ -2117,6 +2116,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		return -EOVERFLOW;
 
 	if (nla[NFTA_CHAIN_HOOK]) {
+		struct nft_stats __percpu *stats = NULL;
 		struct nft_chain_hook hook;
 
 		if (flags & NFT_CHAIN_BINDING)
@@ -2148,8 +2148,11 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (err < 0) {
 			nft_chain_release_hook(&hook);
 			kfree(basechain);
+			free_percpu(stats);
 			return err;
 		}
+		if (stats)
+			static_branch_inc(&nft_counters_enabled);
 	} else {
 		if (flags & NFT_CHAIN_BASE)
 			return -EINVAL;
@@ -2224,9 +2227,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err_unregister_hook;
 	}
 
-	if (stats)
-		static_branch_inc(&nft_counters_enabled);
-
 	table->use++;
 
 	return 0;
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 0fa2e2030427..ee6840bd5933 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -269,6 +269,7 @@ bool nf_osf_find(const struct sk_buff *skb,
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
 	struct tcphdr _tcph;
+	bool found = false;
 
 	memset(&ctx, 0, sizeof(ctx));
 
@@ -283,10 +284,11 @@ bool nf_osf_find(const struct sk_buff *skb,
 
 		data->genre = f->genre;
 		data->version = f->version;
+		found = true;
 		break;
 	}
 
-	return true;
+	return found;
 }
 EXPORT_SYMBOL_GPL(nf_osf_find);
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 4b552c10e7b9..62ce6981942b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2117,6 +2117,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 
 	if (chain->tmplt_ops && chain->tmplt_ops != tp->ops) {
+		tfilter_put(tp, fh);
 		NL_SET_ERR_MSG(extack, "Chain template is set to a different filter kind");
 		err = -EINVAL;
 		goto errout;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 474ba4db5de2..ae7ca68f2cf9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -66,6 +66,7 @@ struct taprio_sched {
 	u32 flags;
 	enum tk_offsets tk_offset;
 	int clockid;
+	bool offloaded;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
 				    */
@@ -1278,6 +1279,8 @@ static int taprio_enable_offload(struct net_device *dev,
 		goto done;
 	}
 
+	q->offloaded = true;
+
 done:
 	taprio_offload_free(offload);
 
@@ -1292,12 +1295,9 @@ static int taprio_disable_offload(struct net_device *dev,
 	struct tc_taprio_qopt_offload *offload;
 	int err;
 
-	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
+	if (!q->offloaded)
 		return 0;
 
-	if (!ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
-
 	offload = taprio_offload_alloc(0);
 	if (!offload) {
 		NL_SET_ERR_MSG(extack,
@@ -1313,6 +1313,8 @@ static int taprio_disable_offload(struct net_device *dev,
 		goto out;
 	}
 
+	q->offloaded = false;
+
 out:
 	taprio_offload_free(offload);
 
@@ -1948,12 +1950,14 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 {
-	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	unsigned int ntx = cl - 1;
 
-	if (!dev_queue)
+	if (ntx >= dev->num_tx_queues)
 		return NULL;
 
-	return dev_queue->qdisc_sleeping;
+	return q->qdiscs[ntx];
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 7401ec67ebcf..2eafefa15a1a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1980,7 +1980,7 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 				     struct smc_buf_desc *buf_desc, bool is_rmb)
 {
-	int i, rc = 0;
+	int i, rc = 0, cnt = 0;
 
 	/* protect against parallel link reconfiguration */
 	mutex_lock(&lgr->llc_conf_mutex);
@@ -1993,9 +1993,12 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 			rc = -ENOMEM;
 			goto out;
 		}
+		cnt++;
 	}
 out:
 	mutex_unlock(&lgr->llc_conf_mutex);
+	if (!rc && !cnt)
+		rc = -EINVAL;
 	return rc;
 }
 
diff --git a/sound/core/init.c b/sound/core/init.c
index 362588e3a275..7b3618997d34 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -178,10 +178,8 @@ int snd_card_new(struct device *parent, int idx, const char *xid,
 		return -ENOMEM;
 
 	err = snd_card_init(card, parent, idx, xid, module, extra_size);
-	if (err < 0) {
-		kfree(card);
-		return err;
-	}
+	if (err < 0)
+		return err; /* card is freed by error handler */
 
 	*card_ret = card;
 	return 0;
@@ -231,7 +229,7 @@ int snd_devm_card_new(struct device *parent, int idx, const char *xid,
 	card->managed = true;
 	err = snd_card_init(card, parent, idx, xid, module, extra_size);
 	if (err < 0) {
-		devres_free(card);
+		devres_free(card); /* in managed mode, we need to free manually */
 		return err;
 	}
 
@@ -293,6 +291,8 @@ static int snd_card_init(struct snd_card *card, struct device *parent,
 		mutex_unlock(&snd_card_mutex);
 		dev_err(parent, "cannot find the slot for index %d (range 0-%i), error: %d\n",
 			 idx, snd_ecards_limit - 1, err);
+		if (!card->managed)
+			kfree(card); /* manually free here, as no destructor called */
 		return err;
 	}
 	set_bit(idx, snd_cards_lock);		/* lock it */
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 9e36f992605a..cc94da9151c3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2519,6 +2519,8 @@ static const struct pci_device_id azx_ids[] = {
 	/* 5 Series/3400 */
 	{ PCI_DEVICE(0x8086, 0x3b56),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
+	{ PCI_DEVICE(0x8086, 0x3b57),
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Poulsbo */
 	{ PCI_DEVICE(0x8086, 0x811b),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 24da843f39a1..d19bc2b9f778 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3868,6 +3868,7 @@ static int patch_tegra_hdmi(struct hda_codec *codec)
 	if (err)
 		return err;
 
+	codec->depop_delay = 10;
 	codec->patch_ops.build_pcms = tegra_hdmi_build_pcms;
 	spec = codec->spec;
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 45b8ebda284d..c4b3f2d3c7e3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6879,6 +6879,8 @@ enum {
 	ALC294_FIXUP_ASUS_GU502_HP,
 	ALC294_FIXUP_ASUS_GU502_PINS,
 	ALC294_FIXUP_ASUS_GU502_VERBS,
+	ALC294_FIXUP_ASUS_G513_PINS,
+	ALC285_FIXUP_ASUS_G533Z_PINS,
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_GPIO_LED,
@@ -8205,6 +8207,24 @@ static const struct hda_fixup alc269_fixups[] = {
 	[ALC294_FIXUP_ASUS_GU502_HP] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc294_fixup_gu502_hp,
+	},
+	 [ALC294_FIXUP_ASUS_G513_PINS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+				{ 0x19, 0x03a11050 }, /* front HP mic */
+				{ 0x1a, 0x03a11c30 }, /* rear external mic */
+				{ 0x21, 0x03211420 }, /* front HP out */
+				{ }
+		},
+	},
+	[ALC285_FIXUP_ASUS_G533Z_PINS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170120 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_G513_PINS,
 	},
 	[ALC294_FIXUP_ASUS_COEF_1B] = {
 		.type = HDA_FIXUP_VERBS,
@@ -8816,6 +8836,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0872, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0873, "Dell Precision 3930", ALC255_FIXUP_DUMMY_LINEOUT_VERB),
+	SND_PCI_QUIRK(0x1028, 0x087d, "Dell Precision 5530", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x08ad, "Dell WYSE AIO", ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ae, "Dell WYSE NB", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0935, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),
@@ -8831,6 +8852,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0a9d, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0a9e, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0b19, "Dell XPS 15 9520", ALC289_FIXUP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0b1a, "Dell Precision 5570", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
@@ -8983,10 +9005,11 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x13b0, "ASUS Z550SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
+	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
+	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
-	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
@@ -9001,14 +9024,16 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1b13, "Asus U41SV", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1bbd, "ASUS Z550MA", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
+	SND_PCI_QUIRK(0x1043, 0x1e5e, "ASUS ROG Strix G513", ALC294_FIXUP_ASUS_G513_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1c52, "ASUS Zephyrus G15 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
-	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
-	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),
@@ -9205,6 +9230,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
+	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
 	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),
 	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 11fa7745c017..743b8287cfcd 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -731,8 +731,7 @@ bool snd_usb_endpoint_compatible(struct snd_usb_audio *chip,
  * The endpoint needs to be closed via snd_usb_endpoint_close() later.
  *
  * Note that this function doesn't configure the endpoint.  The substream
- * needs to set it up later via snd_usb_endpoint_set_params() and
- * snd_usb_endpoint_prepare().
+ * needs to set it up later via snd_usb_endpoint_configure().
  */
 struct snd_usb_endpoint *
 snd_usb_endpoint_open(struct snd_usb_audio *chip,
@@ -1255,13 +1254,12 @@ static int sync_ep_set_params(struct snd_usb_endpoint *ep)
 /*
  * snd_usb_endpoint_set_params: configure an snd_usb_endpoint
  *
- * It's called either from hw_params callback.
  * Determine the number of URBs to be used on this endpoint.
  * An endpoint must be configured before it can be started.
  * An endpoint that is already running can not be reconfigured.
  */
-int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
-				struct snd_usb_endpoint *ep)
+static int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
+				       struct snd_usb_endpoint *ep)
 {
 	const struct audioformat *fmt = ep->cur_audiofmt;
 	int err;
@@ -1317,18 +1315,18 @@ int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
 }
 
 /*
- * snd_usb_endpoint_prepare: Prepare the endpoint
+ * snd_usb_endpoint_configure: Configure the endpoint
  *
  * This function sets up the EP to be fully usable state.
- * It's called either from prepare callback.
+ * It's called either from hw_params or prepare callback.
  * The function checks need_setup flag, and performs nothing unless needed,
  * so it's safe to call this multiple times.
  *
  * This returns zero if unchanged, 1 if the configuration has changed,
  * or a negative error code.
  */
-int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
-			     struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
+			       struct snd_usb_endpoint *ep)
 {
 	bool iface_first;
 	int err = 0;
@@ -1350,6 +1348,9 @@ int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
 			if (err < 0)
 				goto unlock;
 		}
+		err = snd_usb_endpoint_set_params(chip, ep);
+		if (err < 0)
+			goto unlock;
 		goto done;
 	}
 
@@ -1377,6 +1378,10 @@ int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
 	if (err < 0)
 		goto unlock;
 
+	err = snd_usb_endpoint_set_params(chip, ep);
+	if (err < 0)
+		goto unlock;
+
 	err = snd_usb_select_mode_quirk(chip, ep->cur_audiofmt);
 	if (err < 0)
 		goto unlock;
diff --git a/sound/usb/endpoint.h b/sound/usb/endpoint.h
index e67ea28faa54..6a9af04cf175 100644
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -17,10 +17,8 @@ snd_usb_endpoint_open(struct snd_usb_audio *chip,
 		      bool is_sync_ep);
 void snd_usb_endpoint_close(struct snd_usb_audio *chip,
 			    struct snd_usb_endpoint *ep);
-int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
-				struct snd_usb_endpoint *ep);
-int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
-			     struct snd_usb_endpoint *ep);
+int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
+			       struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_get_clock_rate(struct snd_usb_audio *chip, int clock);
 
 bool snd_usb_endpoint_compatible(struct snd_usb_audio *chip,
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 2d60e6d1f8df..b6cd43c5ea3e 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -443,17 +443,17 @@ static int configure_endpoints(struct snd_usb_audio *chip,
 		if (stop_endpoints(subs, false))
 			sync_pending_stops(subs);
 		if (subs->sync_endpoint) {
-			err = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);
+			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
 			if (err < 0)
 				return err;
 		}
-		err = snd_usb_endpoint_prepare(chip, subs->data_endpoint);
+		err = snd_usb_endpoint_configure(chip, subs->data_endpoint);
 		if (err < 0)
 			return err;
 		snd_usb_set_format_quirk(subs, subs->cur_audiofmt);
 	} else {
 		if (subs->sync_endpoint) {
-			err = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);
+			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
 			if (err < 0)
 				return err;
 		}
@@ -551,13 +551,7 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 	subs->cur_audiofmt = fmt;
 	mutex_unlock(&chip->mutex);
 
-	if (subs->sync_endpoint) {
-		ret = snd_usb_endpoint_set_params(chip, subs->sync_endpoint);
-		if (ret < 0)
-			goto unlock;
-	}
-
-	ret = snd_usb_endpoint_set_params(chip, subs->data_endpoint);
+	ret = configure_endpoints(chip, subs);
 
  unlock:
 	if (ret < 0)
diff --git a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
index 292c430768b5..c72f8ad96f75 100644
--- a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
+++ b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
@@ -176,7 +176,7 @@ static int bperf_cgroup_count(void)
 }
 
 // This will be attached to cgroup-switches event for each cpu
-SEC("perf_events")
+SEC("perf_event")
 int BPF_PROG(on_cgrp_switch)
 {
 	return bperf_cgroup_count();
diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
index 953338b9e887..02cd9f75e3d2 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -251,6 +251,7 @@ jit_write_elf(int fd, uint64_t load_addr, const char *sym,
 	Elf_Data *d;
 	Elf_Scn *scn;
 	Elf_Ehdr *ehdr;
+	Elf_Phdr *phdr;
 	Elf_Shdr *shdr;
 	uint64_t eh_frame_base_offset;
 	char *strsym = NULL;
@@ -285,6 +286,19 @@ jit_write_elf(int fd, uint64_t load_addr, const char *sym,
 	ehdr->e_version = EV_CURRENT;
 	ehdr->e_shstrndx= unwinding ? 4 : 2; /* shdr index for section name */
 
+	/*
+	 * setup program header
+	 */
+	phdr = elf_newphdr(e, 1);
+	phdr[0].p_type = PT_LOAD;
+	phdr[0].p_offset = 0;
+	phdr[0].p_vaddr = 0;
+	phdr[0].p_paddr = 0;
+	phdr[0].p_filesz = csize;
+	phdr[0].p_memsz = csize;
+	phdr[0].p_flags = PF_X | PF_R;
+	phdr[0].p_align = 8;
+
 	/*
 	 * setup text section
 	 */
diff --git a/tools/perf/util/genelf.h b/tools/perf/util/genelf.h
index d4137559be05..ac638945b4cb 100644
--- a/tools/perf/util/genelf.h
+++ b/tools/perf/util/genelf.h
@@ -50,8 +50,10 @@ int jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_ent
 
 #if GEN_ELF_CLASS == ELFCLASS64
 #define elf_newehdr	elf64_newehdr
+#define elf_newphdr	elf64_newphdr
 #define elf_getshdr	elf64_getshdr
 #define Elf_Ehdr	Elf64_Ehdr
+#define Elf_Phdr	Elf64_Phdr
 #define Elf_Shdr	Elf64_Shdr
 #define Elf_Sym		Elf64_Sym
 #define ELF_ST_TYPE(a)	ELF64_ST_TYPE(a)
@@ -59,8 +61,10 @@ int jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_ent
 #define ELF_ST_VIS(a)	ELF64_ST_VISIBILITY(a)
 #else
 #define elf_newehdr	elf32_newehdr
+#define elf_newphdr	elf32_newphdr
 #define elf_getshdr	elf32_getshdr
 #define Elf_Ehdr	Elf32_Ehdr
+#define Elf_Phdr	Elf32_Phdr
 #define Elf_Shdr	Elf32_Shdr
 #define Elf_Sym		Elf32_Sym
 #define ELF_ST_TYPE(a)	ELF32_ST_TYPE(a)
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index cb7b24493782..6c183df191aa 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -2091,8 +2091,8 @@ static int kcore_copy__compare_file(const char *from_dir, const char *to_dir,
  * unusual.  One significant peculiarity is that the mapping (start -> pgoff)
  * is not the same for the kernel map and the modules map.  That happens because
  * the data is copied adjacently whereas the original kcore has gaps.  Finally,
- * kallsyms and modules files are compared with their copies to check that
- * modules have not been loaded or unloaded while the copies were taking place.
+ * kallsyms file is compared with its copy to check that modules have not been
+ * loaded or unloaded while the copies were taking place.
  *
  * Return: %0 on success, %-1 on failure.
  */
@@ -2155,9 +2155,6 @@ int kcore_copy(const char *from_dir, const char *to_dir)
 			goto out_extract_close;
 	}
 
-	if (kcore_copy__compare_file(from_dir, to_dir, "modules"))
-		goto out_extract_close;
-
 	if (kcore_copy__compare_file(from_dir, to_dir, "kallsyms"))
 		goto out_extract_close;
 
diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index a7e981b2d7de..c69ad7a1a6a7 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -367,13 +367,24 @@ static void perf_record_mmap2__read_build_id(struct perf_record_mmap2 *event,
 					     bool is_kernel)
 {
 	struct build_id bid;
+	struct nsinfo *nsi;
+	struct nscookie nc;
 	int rc;
 
-	if (is_kernel)
+	if (is_kernel) {
 		rc = sysfs__read_build_id("/sys/kernel/notes", &bid);
-	else
-		rc = filename__read_build_id(event->filename, &bid) > 0 ? 0 : -1;
+		goto out;
+	}
+
+	nsi = nsinfo__new(event->pid);
+	nsinfo__mountns_enter(nsi, &nc);
 
+	rc = filename__read_build_id(event->filename, &bid) > 0 ? 0 : -1;
+
+	nsinfo__mountns_exit(&nc);
+	nsinfo__put(nsi);
+
+out:
 	if (rc == 0) {
 		memcpy(event->build_id, bid.data, sizeof(bid.data));
 		event->build_id_size = (u8) bid.size;
diff --git a/tools/testing/selftests/net/forwarding/sch_red.sh b/tools/testing/selftests/net/forwarding/sch_red.sh
index e714bae473fb..81f31179ac88 100755
--- a/tools/testing/selftests/net/forwarding/sch_red.sh
+++ b/tools/testing/selftests/net/forwarding/sch_red.sh
@@ -1,3 +1,4 @@
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # This test sends one stream of traffic from H1 through a TBF shaper, to a RED
