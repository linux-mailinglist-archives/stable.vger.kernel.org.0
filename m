Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748911FA26A
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 23:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbgFOVGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 17:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731659AbgFOVGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 17:06:32 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD43DC061A0E;
        Mon, 15 Jun 2020 14:06:31 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id q19so18971644eja.7;
        Mon, 15 Jun 2020 14:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CS8a9xmEYV2zxLnPApYUEQTrSfGGAUQgoBCAgN5bfRg=;
        b=HJO8fxl51MsYSZvPlWvkfVXGvnKbCKu9PsZddDTqeMd7r6CrVrWvHG8oIS94ZnQaPy
         GCUtzizqeUrYBF6cQQ+hksCXRnwgULl6hrW1zbPRavNi33EKR1dCkWjgy4t+PmthP19P
         PLZkXlSp7OgMEYEMe9EaxRHvj5xlkLZ+oYBGJIyKfJyLdNe2/Uei7o6zW06RjDeCM0tR
         Hd4NKxgNWwn6ihfnT+/Rk+DjNEXdM4bsed20as50O6JunMISD5A64GUNGCOZk59qq/K9
         YS+ivTkpAM2JqziTQef0BJ1R2fGMRsUTCoqaX36mgTruW9VQ/m+nkO8YuAZPlG7fEIBD
         hqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CS8a9xmEYV2zxLnPApYUEQTrSfGGAUQgoBCAgN5bfRg=;
        b=sJcemd8FhS3p0pBH9yLkCrw8jlcvxs2DPONMD71GrmAk9/7Ru5qtSbsC6MA3s217vV
         0uU/Del0nYeJYWx9TaJ/60Xf8TXjsT6kkZLso+dccE30Af+sjIUNZB/jINe13975fGl+
         yVtI9VShzLECBbOmtW+hdrxSZivcAHiDE8vESzCjv7f3/pvDmpiUZ2jEpPzfcKAlFZRy
         cZqQAAlkgxgSL/Fmz+2cjr/LUeEynBWSMgSFOLpVS5b/Wa+OPBvF9lbmFVokUsTrXGbY
         oH587/5NfPQE1sccoPBc1P+tph9M0KtP8kiBlzmjuPEHYRm57khKcuegqMZGlYyVHrUL
         8gKQ==
X-Gm-Message-State: AOAM530DSXqXJliWUmqOv3CMx9OMES80chOg2PJ8DxCaxnYTSJXCQvTS
        KgeCvzTKFS28NRWULWXxt0I=
X-Google-Smtp-Source: ABdhPJzxQJYWD2zxH/0Cvmke6amig3FRjV+C5U4aGZUL0XDJK7ocGL62YRx1Ornbtozf2Vj3tcSwDA==
X-Received: by 2002:a17:906:b88c:: with SMTP id hb12mr26824630ejb.483.1592255190309;
        Mon, 15 Jun 2020 14:06:30 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host-95-238-254-39.retail.telecomitalia.it. [95.238.254.39])
        by smtp.googlemail.com with ESMTPSA id d5sm9662226ejr.78.2020.06.15.14.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 14:06:29 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Vinod Koul <vkoul@kernel.org>, Ansuel Smith <ansuelsmth@gmail.com>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 07/12] PCI: qcom: Define some PARF params needed for ipq8064 SoC
Date:   Mon, 15 Jun 2020 23:06:03 +0200
Message-Id: <20200615210608.21469-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0
In-Reply-To: <20200615210608.21469-1-ansuelsmth@gmail.com>
References: <20200615210608.21469-1-ansuelsmth@gmail.com>
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
2.27.0.rc0

