Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923461F58B1
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 18:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbgFJQIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 12:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730516AbgFJQH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 12:07:26 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288CDC03E96B;
        Wed, 10 Jun 2020 09:07:26 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o15so3161216ejm.12;
        Wed, 10 Jun 2020 09:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQYgSDTotq5c/39ynoudMriyL83LIjVkw0hGmAWFKNE=;
        b=cavjiXggwo0vFzCxAxw+P3TdRlfvsyBHodQC6f7sowYmA+D1x3mGL92MfGpLuyAmR1
         xH/zAHfeVVjOsOe76cGqtIFd8o/UJP1qawtdS5Wxbu1PkjA4CdyP1OUWBO4NkcaQ27KA
         x2vSU5zpbncHz6j5p93XMX/yQdsUZXZq83FrpnbkbFqilyE4mZB8QuQKYLYB3qDX+FV9
         1NUNX2t9HlMLS3ovB0arMBFLorAjimDXWjLMn6YWakR3jHLbZN4/E6g4sterY7/kSD7j
         +FnGqAacrSIIWn83GWhzCxtVh3IBiADhnOggS16d+y8Hb1OklUGCu0PqP143i7vBE6MJ
         067w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQYgSDTotq5c/39ynoudMriyL83LIjVkw0hGmAWFKNE=;
        b=RbM+XY9Ez1TR+X7rUqrml0vpH/C+OwnlmGcqJF2TavGgbbg8gmShGGEOLVE9Fdfuyv
         Crxqe9dfU3gvfVHjYoyBgnJJ1u5QP2SpD2Oddg0/gdktE+SjbE6ZKvBr6euYt5UEgdHn
         fubslMN8xYPmiXKa9dWR2S28yaZ1rrLoJUKMkZYEM7mFoI4e3b84nB2NPNbRT36xA3Is
         mwbMeVGo6Z4nWueaVBXCz6pXdp+8UiTebauAdEOyWSQy7odVM5C8RB2qotHTJpZZZ2Dt
         41BA1l3C8r1yDldM0xRvJmdIlAsVWdbdbnwisvU53Ja0nbuW8b8U3DDpaGBX66Dg7Cvh
         rNzw==
X-Gm-Message-State: AOAM532FnhqFbAIRGqdJxX88e/m4BYim2WuBMpe1jQUvIEZ/A2uRvWdR
        MAWgi+r1BaUlmR1mw65XIy0=
X-Google-Smtp-Source: ABdhPJybsQAvzxQa692WxmMix+SEuqe+73dP+MscVMYrY4v0X3F/kEL+d1AnGnc0Aed6wHQSIVZcmA==
X-Received: by 2002:a17:906:3da1:: with SMTP id y1mr3920586ejh.109.1591805244676;
        Wed, 10 Jun 2020 09:07:24 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host-79-35-249-242.retail.telecomitalia.it. [79.35.249.242])
        by smtp.googlemail.com with ESMTPSA id ce25sm56067edb.45.2020.06.10.09.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 09:07:23 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 07/12] PCI: qcom: Define some PARF params needed for ipq8064 SoC
Date:   Wed, 10 Jun 2020 18:06:49 +0200
Message-Id: <20200610160655.27799-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200610160655.27799-1-ansuelsmth@gmail.com>
References: <20200610160655.27799-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Set some specific value for Tx De-Emphasis, Tx Swing and Rx equalization
needed on some ipq8064 based device (Netgear R7800 for example). Without
this the system locks on kernel load.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v4.5+
Reviewed-by: Rob Herring <robh@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index f2ea1ab6f584..85313493d51b 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -77,6 +77,18 @@
 #define DBI_RO_WR_EN				1
 
 #define PERST_DELAY_US				1000
+/* PARF registers */
+#define PCIE20_PARF_PCS_DEEMPH			0x34
+#define PCS_DEEMPH_TX_DEEMPH_GEN1(x)		((x) << 16)
+#define PCS_DEEMPH_TX_DEEMPH_GEN2_3_5DB(x)	((x) << 8)
+#define PCS_DEEMPH_TX_DEEMPH_GEN2_6DB(x)	((x) << 0)
+
+#define PCIE20_PARF_PCS_SWING			0x38
+#define PCS_SWING_TX_SWING_FULL(x)		((x) << 8)
+#define PCS_SWING_TX_SWING_LOW(x)		((x) << 0)
+
+#define PCIE20_PARF_CONFIG_BITS		0x50
+#define PHY_RX0_EQ(x)				((x) << 24)
 
 #define PCIE20_v3_PARF_SLV_ADDR_SPACE_SIZE	0x358
 #define SLV_ADDR_SPACE_SZ			0x10000000
@@ -293,6 +305,7 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	struct qcom_pcie_resources_2_1_0 *res = &pcie->res.v2_1_0;
 	struct dw_pcie *pci = pcie->pci;
 	struct device *dev = pci->dev;
+	struct device_node *node = dev->of_node;
 	u32 val;
 	int ret;
 
@@ -347,6 +360,17 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	val &= ~BIT(0);
 	writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
 
+	if (of_device_is_compatible(node, "qcom,pcie-ipq8064")) {
+		writel(PCS_DEEMPH_TX_DEEMPH_GEN1(24) |
+			       PCS_DEEMPH_TX_DEEMPH_GEN2_3_5DB(24) |
+			       PCS_DEEMPH_TX_DEEMPH_GEN2_6DB(34),
+		       pcie->parf + PCIE20_PARF_PCS_DEEMPH);
+		writel(PCS_SWING_TX_SWING_FULL(120) |
+			       PCS_SWING_TX_SWING_LOW(120),
+		       pcie->parf + PCIE20_PARF_PCS_SWING);
+		writel(PHY_RX0_EQ(4), pcie->parf + PCIE20_PARF_CONFIG_BITS);
+	}
+
 	/* enable external reference clock */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
 	val |= BIT(16);
-- 
2.25.1

