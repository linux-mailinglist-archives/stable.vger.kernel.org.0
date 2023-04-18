Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9ED6E5ADF
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 09:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjDRHsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 03:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjDRHsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 03:48:20 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FE559E4;
        Tue, 18 Apr 2023 00:48:05 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a5so14294128ejb.6;
        Tue, 18 Apr 2023 00:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681804084; x=1684396084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSECFHZy2WzIyUV0vaXLu82osKPT1cFDVUnkNRe7B6U=;
        b=Agas9d41DbbQbx7zymI5eZoxSH9X/KqC7/0aKqFz2yduuFEPOidHwD0EJraRvFuRR8
         1q7559x5KUim90/QyTj/IaZHwpjk8Qjdlfz4mANK9bRkW7VNgPABAJuOdQiDSvOEZY9D
         PFxLEA9kvj9YITO+PrGsVwbON3FIOqkDgC42bbNGYqPp+PNvVr8tDUJhcwVCf6FP3ueA
         tPGMsNhAi2R3SbcQ5x8xSv6e4A7hpVw9khr9vZa73X7YG1Z4xh/9/w7pKmGQSyUoH8jL
         6eIe3aE/HeWbh3kyE3QroOwasmk/oKqpPV0q87UMsAdOo8ivB+JlaJAwbpqL0+jeXNX5
         bnkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681804084; x=1684396084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSECFHZy2WzIyUV0vaXLu82osKPT1cFDVUnkNRe7B6U=;
        b=cNk1QGSyr3pa6OlWoCOsxecGFuy+PjDyd3W2DpjwwG7GABaunlNalcmdbnm2L37g/1
         N/djCizWLIbHGPBb9f8eq5azYJrYqnfELhpLAss/srUnagmsCd1lP7PK1F3ZkrS1geGi
         8nQlLUdMj4Fp6suI5yESGz3kMEaV5x93Mlf9rd+gEtYPMX2D8H3l6VnbDZ5Jgdl/WSFn
         HJWkugjQTk4VmfHNJ4E0UrV9zfubM8NxeHdimLatbv9w18s5JXEgsSi5c26yzIUJVyPq
         ls/V0yvDtGoNWQ5wKRGfbEo2KWcHMZOZuKbuKYvdsTarmw7j0BJ4C5LEtOsNSNUoSE/P
         HwKA==
X-Gm-Message-State: AAQBX9foS+Is8JsD3fK2uBvSPpQnz0Fnj7+hJQ8Ciki5querBnji8A2d
        XmJ4+4NSRFhkIgIKYW27zXg=
X-Google-Smtp-Source: AKy350aXYDhM9xZy8L1Rv/vq7O+EsDHywHBUmZXhV29RAi673qRyykQKtBn2DgYLvzWhGykXVqxKgA==
X-Received: by 2002:a17:906:5809:b0:94e:f862:e0ac with SMTP id m9-20020a170906580900b0094ef862e0acmr8660740ejq.17.1681804084016;
        Tue, 18 Apr 2023 00:48:04 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id gs8-20020a1709072d0800b0094f694e4ecbsm3048545ejc.146.2023.04.18.00.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 00:48:03 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, dlemoal@kernel.org,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Corentin Labbe <clabbe@baylibre.com>,
        Caleb Connolly <kc@postmarketos.org>,
        Brian Norris <briannorris@chromium.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 07/11] PCI: rockchip: Fix legacy IRQ generation for RK3399 PCIe endpoint core
Date:   Tue, 18 Apr 2023 09:46:54 +0200
Message-Id: <20230418074700.1083505-8-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418074700.1083505-1-rick.wertenbroek@gmail.com>
References: <20230418074700.1083505-1-rick.wertenbroek@gmail.com>
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

Fix legacy IRQ generation for RK3399 PCIe endpoint core according to
the technical reference manual (TRM). Assert and deassert legacy
interrupt (INTx) through the legacy interrupt control register
("PCIE_CLIENT_LEGACY_INT_CTRL") instead of manually generating a PCIe
message. The generation of the legacy interrupt was tested and validated
with the PCIe endpoint test driver.

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 45 ++++++-----------------
 drivers/pci/controller/pcie-rockchip.h    |  6 ++-
 2 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index d00baed65eba..d6d4b0f2e733 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -337,48 +337,25 @@ static int rockchip_pcie_ep_get_msi(struct pci_epc *epc, u8 fn, u8 vfn)
 }
 
 static void rockchip_pcie_ep_assert_intx(struct rockchip_pcie_ep *ep, u8 fn,
-					 u8 intx, bool is_asserted)
+					 u8 intx, bool do_assert)
 {
 	struct rockchip_pcie *rockchip = &ep->rockchip;
-	u32 r = ep->max_regions - 1;
-	u32 offset;
-	u32 status;
-	u8 msg_code;
-
-	if (unlikely(ep->irq_pci_addr != ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR ||
-		     ep->irq_pci_fn != fn)) {
-		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, r,
-					     AXI_WRAPPER_NOR_MSG,
-					     ep->irq_phys_addr, 0, 0);
-		ep->irq_pci_addr = ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR;
-		ep->irq_pci_fn = fn;
-	}
 
 	intx &= 3;
-	if (is_asserted) {
+
+	if (do_assert) {
 		ep->irq_pending |= BIT(intx);
-		msg_code = ROCKCHIP_PCIE_MSG_CODE_ASSERT_INTA + intx;
+		rockchip_pcie_write(rockchip,
+				    PCIE_CLIENT_INT_IN_ASSERT |
+				    PCIE_CLIENT_INT_PEND_ST_PEND,
+				    PCIE_CLIENT_LEGACY_INT_CTRL);
 	} else {
 		ep->irq_pending &= ~BIT(intx);
-		msg_code = ROCKCHIP_PCIE_MSG_CODE_DEASSERT_INTA + intx;
+		rockchip_pcie_write(rockchip,
+				    PCIE_CLIENT_INT_IN_DEASSERT |
+				    PCIE_CLIENT_INT_PEND_ST_NORMAL,
+				    PCIE_CLIENT_LEGACY_INT_CTRL);
 	}
-
-	status = rockchip_pcie_read(rockchip,
-				    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
-				    ROCKCHIP_PCIE_EP_CMD_STATUS);
-	status &= ROCKCHIP_PCIE_EP_CMD_STATUS_IS;
-
-	if ((status != 0) ^ (ep->irq_pending != 0)) {
-		status ^= ROCKCHIP_PCIE_EP_CMD_STATUS_IS;
-		rockchip_pcie_write(rockchip, status,
-				    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
-				    ROCKCHIP_PCIE_EP_CMD_STATUS);
-	}
-
-	offset =
-	   ROCKCHIP_PCIE_MSG_ROUTING(ROCKCHIP_PCIE_MSG_ROUTING_LOCAL_INTX) |
-	   ROCKCHIP_PCIE_MSG_CODE(msg_code) | ROCKCHIP_PCIE_MSG_NO_DATA;
-	writel(0, ep->irq_cpu_addr + offset);
 }
 
 static int rockchip_pcie_ep_send_legacy_irq(struct rockchip_pcie_ep *ep, u8 fn,
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index f3a5ff1cf7f4..ffc68a3a5fee 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -38,6 +38,11 @@
 #define   PCIE_CLIENT_MODE_EP            HIWORD_UPDATE(0x0040, 0)
 #define   PCIE_CLIENT_GEN_SEL_1		  HIWORD_UPDATE(0x0080, 0)
 #define   PCIE_CLIENT_GEN_SEL_2		  HIWORD_UPDATE_BIT(0x0080)
+#define PCIE_CLIENT_LEGACY_INT_CTRL	(PCIE_CLIENT_BASE + 0x0c)
+#define   PCIE_CLIENT_INT_IN_ASSERT		HIWORD_UPDATE_BIT(0x0002)
+#define   PCIE_CLIENT_INT_IN_DEASSERT		HIWORD_UPDATE(0x0002, 0)
+#define   PCIE_CLIENT_INT_PEND_ST_PEND		HIWORD_UPDATE_BIT(0x0001)
+#define   PCIE_CLIENT_INT_PEND_ST_NORMAL	HIWORD_UPDATE(0x0001, 0)
 #define PCIE_CLIENT_SIDE_BAND_STATUS	(PCIE_CLIENT_BASE + 0x20)
 #define   PCIE_CLIENT_PHY_ST			BIT(12)
 #define PCIE_CLIENT_DEBUG_OUT_0		(PCIE_CLIENT_BASE + 0x3c)
@@ -227,7 +232,6 @@
 #define   ROCKCHIP_PCIE_EP_MSI_CTRL_ME				BIT(16)
 #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MASK_MSI_CAP	BIT(24)
 #define ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR				0x1
-#define ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR		0x3
 #define ROCKCHIP_PCIE_EP_FUNC_BASE(fn)	(((fn) << 12) & GENMASK(19, 12))
 #define ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR0(fn, bar) \
 	(PCIE_RC_RP_ATS_BASE + 0x0840 + (fn) * 0x0040 + (bar) * 0x0008)
-- 
2.25.1

