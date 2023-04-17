Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED596E43CB
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 11:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbjDQJ1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 05:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjDQJ1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 05:27:33 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132E644A4;
        Mon, 17 Apr 2023 02:27:20 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a5so5824940ejb.6;
        Mon, 17 Apr 2023 02:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681723638; x=1684315638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f8MdAEXT1lrDQKdYqluEX5MA1E/so3+0stwP0iAwxyM=;
        b=SUoSYg+r8DYeQ/gn+FARxq0XdjNKv9ay25FoSKrh8vmFmwfuEcIH8DIXGaM4CkYHF/
         mIlrCVDrTa/W3HgcSoVCSIZYcf/o11akJrSc0BsgI3vrQA1mEqZ/D2A7FgAagcOJD3pq
         Bi8NZViuZE7p8PNY0zG7xigHandGY1Rspv4H8loD5pY5A4DERYCGEQc8BCJGb5+fQqls
         CSYwf01skhzT6YYlfCsin1rl7MofnBUGmlUpRS1ddMZsAVfoCz1Wf7VJ3QjZQMFUH8n/
         F7sKC+yo/+ps6jpQmgibdb7lA1f31rolmGFRnYvl12EQ8yoICkGm8u3pm0CFG/tbND4z
         eE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681723638; x=1684315638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f8MdAEXT1lrDQKdYqluEX5MA1E/so3+0stwP0iAwxyM=;
        b=FLQbNcRvy/1vY8h0sTV1rIWoCc8w4GNQHbWYNYncjQYErEBTI0u/etrGqFDj4F3gLm
         Hr1DkFUuG/ZvsukW9o6+tsttc/AK5CW/Hd5hSiAA1fZScUmRA3YukE7Jph9fUCKtBWTy
         bimib2P8icQ/xSka79gckqhT9KjWLqstJ/UZV5T0QOJAHYvZ0iK2VGErLIclN4bflay/
         P9ClErQdAYZ9WrQal5ThdxYFgFT/y8aevgYyzzadG+nMBKu02H/KeIPjGtFwvd6DwVeG
         WSAcfyAA8/+BlXymZ0DVfGuCpmZQw3jEdhELpjPHS0jVOzJOMZzkmweCtTvKATjkHV7T
         ainA==
X-Gm-Message-State: AAQBX9eqnKVclDzL+USiLF2Nxzggnmo/6dD7qsWWiFHjuSP9RTMBx4tZ
        laqaa34ZQHoI91Hs8UDQg3Y=
X-Google-Smtp-Source: AKy350agwgZoq4xHbxPUOneC/M0p+8VXz8kl4JwSvqyvFn1o6/CeBwXkseAclUZ8MGg0GyX96Bv3SQ==
X-Received: by 2002:a17:906:3ac7:b0:94e:5fb0:9af3 with SMTP id z7-20020a1709063ac700b0094e5fb09af3mr6805915ejd.49.1681723638477;
        Mon, 17 Apr 2023 02:27:18 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id p20-20020a170906615400b0094aa087578csm6398596ejl.171.2023.04.17.02.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 02:27:18 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Corentin Labbe <clabbe@baylibre.com>,
        Brian Norris <briannorris@chromium.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Caleb Connolly <kc@postmarketos.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/11] PCI: rockchip: Fix window mapping and address translation for endpoint
Date:   Mon, 17 Apr 2023 11:26:26 +0200
Message-Id: <20230417092631.347976-9-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230417092631.347976-1-rick.wertenbroek@gmail.com>
References: <20230417092631.347976-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The RK3399 PCI endpoint core has 33 windows for PCIe space, now in the
driver up to 32 fixed size (1M) windows are used and pages are allocated
and mapped accordingly. The driver first used a single window and allocated
space inside which caused translation issues (between CPU space and PCI
space) because a window can only have a single translation at a given
time, which if multiple pages are allocated inside will cause conflicts.
Now each window is a single region of 1M which will always guarantee that
the translation is not in conflict.

Set the translation register addresses for physical function. As documented
in the technical reference manual (TRM) section 17.5.5 "PCIe Address
Translation" and section 17.6.8 "Address Translation Registers Description"

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 131 ++++++++++------------
 drivers/pci/controller/pcie-rockchip.h    |  35 +++---
 2 files changed, 77 insertions(+), 89 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 7591a7be78e0..771f1bb93251 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -64,52 +64,29 @@ static void rockchip_pcie_clear_ep_ob_atu(struct rockchip_pcie *rockchip,
 }
 
 static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
-					 u32 r, u32 type, u64 cpu_addr,
-					 u64 pci_addr, size_t size)
+					 u32 r, u64 cpu_addr, u64 pci_addr,
+					 size_t size)
 {
-	u64 sz = 1ULL << fls64(size - 1);
-	int num_pass_bits = ilog2(sz);
-	u32 addr0, addr1, desc0, desc1;
-	bool is_nor_msg = (type == AXI_WRAPPER_NOR_MSG);
+	int num_pass_bits = fls64(size - 1);
+	u32 addr0, addr1, desc0;
 
-	/* The minimal region size is 1MB */
 	if (num_pass_bits < 8)
 		num_pass_bits = 8;
 
-	cpu_addr -= rockchip->mem_res->start;
-	addr0 = ((is_nor_msg ? 0x10 : (num_pass_bits - 1)) &
-		PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
-		(lower_32_bits(cpu_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
-	addr1 = upper_32_bits(is_nor_msg ? cpu_addr : pci_addr);
-	desc0 = ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN(fn) | type;
-	desc1 = 0;
-
-	if (is_nor_msg) {
-		rockchip_pcie_write(rockchip, 0,
-				    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r));
-		rockchip_pcie_write(rockchip, 0,
-				    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR1(r));
-		rockchip_pcie_write(rockchip, desc0,
-				    ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r));
-		rockchip_pcie_write(rockchip, desc1,
-				    ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r));
-	} else {
-		/* PCI bus address region */
-		rockchip_pcie_write(rockchip, addr0,
-				    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r));
-		rockchip_pcie_write(rockchip, addr1,
-				    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR1(r));
-		rockchip_pcie_write(rockchip, desc0,
-				    ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r));
-		rockchip_pcie_write(rockchip, desc1,
-				    ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r));
-
-		addr0 =
-		    ((num_pass_bits - 1) & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
-		    (lower_32_bits(cpu_addr) &
-		     PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
-		addr1 = upper_32_bits(cpu_addr);
-	}
+	addr0 = ((num_pass_bits - 1) & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
+		(lower_32_bits(pci_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
+	addr1 = upper_32_bits(pci_addr);
+	desc0 = ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN(fn) | AXI_WRAPPER_MEM_WRITE;
+
+	/* PCI bus address region */
+	rockchip_pcie_write(rockchip, addr0,
+			    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r));
+	rockchip_pcie_write(rockchip, addr1,
+			    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR1(r));
+	rockchip_pcie_write(rockchip, desc0,
+			    ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r));
+	rockchip_pcie_write(rockchip, 0,
+			    ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r));
 }
 
 static int rockchip_pcie_ep_write_header(struct pci_epc *epc, u8 fn, u8 vfn,
@@ -248,26 +225,20 @@ static void rockchip_pcie_ep_clear_bar(struct pci_epc *epc, u8 fn, u8 vfn,
 			    ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR1(fn, bar));
 }
 
+static inline u32 rockchip_ob_region(phys_addr_t addr)
+{
+	return (addr >> ilog2(SZ_1M)) & 0x1f;
+}
+
 static int rockchip_pcie_ep_map_addr(struct pci_epc *epc, u8 fn, u8 vfn,
 				     phys_addr_t addr, u64 pci_addr,
 				     size_t size)
 {
 	struct rockchip_pcie_ep *ep = epc_get_drvdata(epc);
 	struct rockchip_pcie *pcie = &ep->rockchip;
-	u32 r;
-
-	r = find_first_zero_bit(&ep->ob_region_map, BITS_PER_LONG);
-	/*
-	 * Region 0 is reserved for configuration space and shouldn't
-	 * be used elsewhere per TRM, so leave it out.
-	 */
-	if (r >= ep->max_regions - 1) {
-		dev_err(&epc->dev, "no free outbound region\n");
-		return -EINVAL;
-	}
+	u32 r = rockchip_ob_region(addr);
 
-	rockchip_pcie_prog_ep_ob_atu(pcie, fn, r, AXI_WRAPPER_MEM_WRITE, addr,
-				     pci_addr, size);
+	rockchip_pcie_prog_ep_ob_atu(pcie, fn, r, addr, pci_addr, size);
 
 	set_bit(r, &ep->ob_region_map);
 	ep->ob_addr[r] = addr;
@@ -282,15 +253,11 @@ static void rockchip_pcie_ep_unmap_addr(struct pci_epc *epc, u8 fn, u8 vfn,
 	struct rockchip_pcie *rockchip = &ep->rockchip;
 	u32 r;
 
-	for (r = 0; r < ep->max_regions - 1; r++)
+	for (r = 0; r < ep->max_regions; r++)
 		if (ep->ob_addr[r] == addr)
 			break;
 
-	/*
-	 * Region 0 is reserved for configuration space and shouldn't
-	 * be used elsewhere per TRM, so leave it out.
-	 */
-	if (r == ep->max_regions - 1)
+	if (r == ep->max_regions)
 		return;
 
 	rockchip_pcie_clear_ep_ob_atu(rockchip, r);
@@ -387,7 +354,8 @@ static int rockchip_pcie_ep_send_msi_irq(struct rockchip_pcie_ep *ep, u8 fn,
 	struct rockchip_pcie *rockchip = &ep->rockchip;
 	u16 flags, mme, data, data_mask;
 	u8 msi_count;
-	u64 pci_addr, pci_addr_mask = 0xff;
+	u64 pci_addr;
+	u32 r;
 
 	/* Check MSI enable bit */
 	flags = rockchip_pcie_read(&ep->rockchip,
@@ -421,21 +389,20 @@ static int rockchip_pcie_ep_send_msi_irq(struct rockchip_pcie_ep *ep, u8 fn,
 				       ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
 				       ROCKCHIP_PCIE_EP_MSI_CTRL_REG +
 				       PCI_MSI_ADDRESS_LO);
-	pci_addr &= GENMASK_ULL(63, 2);
 
 	/* Set the outbound region if needed. */
-	if (unlikely(ep->irq_pci_addr != (pci_addr & ~pci_addr_mask) ||
+	if (unlikely(ep->irq_pci_addr != (pci_addr & PCIE_ADDR_MASK) ||
 		     ep->irq_pci_fn != fn)) {
-		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, ep->max_regions - 1,
-					     AXI_WRAPPER_MEM_WRITE,
+		r = rockchip_ob_region(ep->irq_phys_addr);
+		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, r,
 					     ep->irq_phys_addr,
-					     pci_addr & ~pci_addr_mask,
-					     pci_addr_mask + 1);
-		ep->irq_pci_addr = (pci_addr & ~pci_addr_mask);
+					     pci_addr & PCIE_ADDR_MASK,
+					     ~PCIE_ADDR_MASK + 1);
+		ep->irq_pci_addr = (pci_addr & PCIE_ADDR_MASK);
 		ep->irq_pci_fn = fn;
 	}
 
-	writew(data, ep->irq_cpu_addr + (pci_addr & pci_addr_mask));
+	writew(data, ep->irq_cpu_addr + (pci_addr & ~PCIE_ADDR_MASK));
 	return 0;
 }
 
@@ -516,6 +483,8 @@ static int rockchip_pcie_parse_ep_dt(struct rockchip_pcie *rockchip,
 	if (err < 0 || ep->max_regions > MAX_REGION_LIMIT)
 		ep->max_regions = MAX_REGION_LIMIT;
 
+	ep->ob_region_map = 0;
+
 	err = of_property_read_u8(dev->of_node, "max-functions",
 				  &ep->epc->max_functions);
 	if (err < 0)
@@ -536,7 +505,8 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
 	struct rockchip_pcie *rockchip;
 	struct pci_epc *epc;
 	size_t max_regions;
-	int err;
+	struct pci_epc_mem_window *windows = NULL;
+	int err, i;
 
 	ep = devm_kzalloc(dev, sizeof(*ep), GFP_KERNEL);
 	if (!ep)
@@ -583,15 +553,27 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
 	/* Only enable function 0 by default */
 	rockchip_pcie_write(rockchip, BIT(0), PCIE_CORE_PHY_FUNC_CFG);
 
-	err = pci_epc_mem_init(epc, rockchip->mem_res->start,
-			       resource_size(rockchip->mem_res), PAGE_SIZE);
+	windows = devm_kcalloc(dev, ep->max_regions,
+			       sizeof(struct pci_epc_mem_window), GFP_KERNEL);
+	if (!windows) {
+		err = -ENOMEM;
+		goto err_uninit_port;
+	}
+	for (i = 0; i < ep->max_regions; i++) {
+		windows[i].phys_base = rockchip->mem_res->start + (SZ_1M * i);
+		windows[i].size = SZ_1M;
+		windows[i].page_size = SZ_1M;
+	}
+	err = pci_epc_multi_mem_init(epc, windows, ep->max_regions);
+	devm_kfree(dev, windows);
+
 	if (err < 0) {
 		dev_err(dev, "failed to initialize the memory space\n");
 		goto err_uninit_port;
 	}
 
 	ep->irq_cpu_addr = pci_epc_mem_alloc_addr(epc, &ep->irq_phys_addr,
-						  SZ_128K);
+						  SZ_1M);
 	if (!ep->irq_cpu_addr) {
 		dev_err(dev, "failed to reserve memory space for MSI\n");
 		err = -ENOMEM;
@@ -600,7 +582,8 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
 
 	ep->irq_pci_addr = ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR;
 
-	rockchip_pcie_write(rockchip, PCIE_CLIENT_CONF_ENABLE, PCIE_CLIENT_CONFIG);
+	rockchip_pcie_write(rockchip, PCIE_CLIENT_CONF_ENABLE,
+			    PCIE_CLIENT_CONFIG);
 
 	return 0;
 err_epc_mem_exit:
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index ffc68a3a5fee..bef6d7098a2f 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -139,6 +139,7 @@
 
 #define PCIE_RC_RP_ATS_BASE		0x400000
 #define PCIE_RC_CONFIG_NORMAL_BASE	0x800000
+#define PCIE_EP_PF_CONFIG_REGS_BASE	0x800000
 #define PCIE_RC_CONFIG_BASE		0xa00000
 #define PCIE_EP_CONFIG_BASE		0xa00000
 #define PCIE_EP_CONFIG_DID_VID		(PCIE_EP_CONFIG_BASE + 0x00)
@@ -157,10 +158,11 @@
 #define PCIE_RC_CONFIG_THP_CAP		(PCIE_RC_CONFIG_BASE + 0x274)
 #define   PCIE_RC_CONFIG_THP_CAP_NEXT_MASK	GENMASK(31, 20)
 
+#define PCIE_ADDR_MASK			0xffffff00
 #define PCIE_CORE_AXI_CONF_BASE		0xc00000
 #define PCIE_CORE_OB_REGION_ADDR0	(PCIE_CORE_AXI_CONF_BASE + 0x0)
 #define   PCIE_CORE_OB_REGION_ADDR0_NUM_BITS	0x3f
-#define   PCIE_CORE_OB_REGION_ADDR0_LO_ADDR	0xffffff00
+#define   PCIE_CORE_OB_REGION_ADDR0_LO_ADDR	PCIE_ADDR_MASK
 #define PCIE_CORE_OB_REGION_ADDR1	(PCIE_CORE_AXI_CONF_BASE + 0x4)
 #define PCIE_CORE_OB_REGION_DESC0	(PCIE_CORE_AXI_CONF_BASE + 0x8)
 #define PCIE_CORE_OB_REGION_DESC1	(PCIE_CORE_AXI_CONF_BASE + 0xc)
@@ -168,7 +170,7 @@
 #define PCIE_CORE_AXI_INBOUND_BASE	0xc00800
 #define PCIE_RP_IB_ADDR0		(PCIE_CORE_AXI_INBOUND_BASE + 0x0)
 #define   PCIE_CORE_IB_REGION_ADDR0_NUM_BITS	0x3f
-#define   PCIE_CORE_IB_REGION_ADDR0_LO_ADDR	0xffffff00
+#define   PCIE_CORE_IB_REGION_ADDR0_LO_ADDR	PCIE_ADDR_MASK
 #define PCIE_RP_IB_ADDR1		(PCIE_CORE_AXI_INBOUND_BASE + 0x4)
 
 /* Size of one AXI Region (not Region 0) */
@@ -232,13 +234,15 @@
 #define   ROCKCHIP_PCIE_EP_MSI_CTRL_ME				BIT(16)
 #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MASK_MSI_CAP	BIT(24)
 #define ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR				0x1
-#define ROCKCHIP_PCIE_EP_FUNC_BASE(fn)	(((fn) << 12) & GENMASK(19, 12))
+#define ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR		0x3
+#define ROCKCHIP_PCIE_EP_FUNC_BASE(fn) \
+	(PCIE_EP_PF_CONFIG_REGS_BASE + (((fn) << 12) & GENMASK(19, 12)))
+#define ROCKCHIP_PCIE_EP_VIRT_FUNC_BASE(fn) \
+	(PCIE_EP_PF_CONFIG_REGS_BASE + 0x10000 + (((fn) << 12) & GENMASK(19, 12)))
 #define ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR0(fn, bar) \
-	(PCIE_RC_RP_ATS_BASE + 0x0840 + (fn) * 0x0040 + (bar) * 0x0008)
+	(PCIE_CORE_AXI_CONF_BASE + 0x0828 + (fn) * 0x0040 + (bar) * 0x0008)
 #define ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR1(fn, bar) \
-	(PCIE_RC_RP_ATS_BASE + 0x0844 + (fn) * 0x0040 + (bar) * 0x0008)
-#define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r) \
-	(PCIE_RC_RP_ATS_BASE + 0x0000 + ((r) & 0x1f) * 0x0020)
+	(PCIE_CORE_AXI_CONF_BASE + 0x082c + (fn) * 0x0040 + (bar) * 0x0008)
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_DEVFN_MASK	GENMASK(19, 12)
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_DEVFN(devfn) \
 	(((devfn) << 12) & \
@@ -246,20 +250,21 @@
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_BUS_MASK	GENMASK(27, 20)
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_BUS(bus) \
 		(((bus) << 20) & ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_BUS_MASK)
+#define PCIE_RC_EP_ATR_OB_REGIONS_1_32 (PCIE_CORE_AXI_CONF_BASE + 0x0020)
+#define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r) \
+		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0000 + ((r) & 0x1f) * 0x0020)
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR1(r) \
-		(PCIE_RC_RP_ATS_BASE + 0x0004 + ((r) & 0x1f) * 0x0020)
+		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0004 + ((r) & 0x1f) * 0x0020)
 #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0_HARDCODED_RID	BIT(23)
 #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN_MASK	GENMASK(31, 24)
 #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN(devfn) \
 		(((devfn) << 24) & ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN_MASK)
 #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r) \
-		(PCIE_RC_RP_ATS_BASE + 0x0008 + ((r) & 0x1f) * 0x0020)
-#define ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r)	\
-		(PCIE_RC_RP_ATS_BASE + 0x000c + ((r) & 0x1f) * 0x0020)
-#define ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR0(r) \
-		(PCIE_RC_RP_ATS_BASE + 0x0018 + ((r) & 0x1f) * 0x0020)
-#define ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR1(r) \
-		(PCIE_RC_RP_ATS_BASE + 0x001c + ((r) & 0x1f) * 0x0020)
+		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0008 + ((r) & 0x1f) * 0x0020)
+#define ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r) \
+		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x000c + ((r) & 0x1f) * 0x0020)
+#define ROCKCHIP_PCIE_AT_OB_REGION_DESC2(r) \
+		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0010 + ((r) & 0x1f) * 0x0020)
 
 #define ROCKCHIP_PCIE_CORE_EP_FUNC_BAR_CFG0(fn) \
 		(PCIE_CORE_CTRL_MGMT_BASE + 0x0240 + (fn) * 0x0008)
-- 
2.25.1

