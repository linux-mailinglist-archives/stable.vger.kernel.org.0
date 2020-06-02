Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AF61EBB00
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 13:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgFBLyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 07:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgFBLyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 07:54:43 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1EDC061A0E;
        Tue,  2 Jun 2020 04:54:42 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id j198so2090265wmj.0;
        Tue, 02 Jun 2020 04:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bzzvhyMzVv3Z/fV4OGF2FsiFFhxIni2+nKg6tj7GTUk=;
        b=YpNtAv4G1J9EhIQAuvAxQKxZUjgDyaIVEKJka1yRu2puEw14PMLlqrRYCp3Grg+q8d
         cOcnlnxU9wNAsbiDG0ychniBjwGE44wowKoOXH5FmDnghzHSIkPW93KX2KogrL1fkgk0
         IRGaCivEJKhMcGzsnxQQ4nCL8Y5XokFhzEm/sr2nrnJKDWntLpfOrqZyprwSZWhU+WYZ
         1G38fuKvFJ2XGqbG2v4nqjdP+ezaN47WHUeupKNd97du8c/f1WCzYpuJdAFsK3jQKsU8
         gEJeuSyscKEpRj8SpWgWTk03gG0vn/nWAIG8Gk102VLEHMc1j+KPp0RYjhsVTemhEydF
         OzWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bzzvhyMzVv3Z/fV4OGF2FsiFFhxIni2+nKg6tj7GTUk=;
        b=uMj/G7Gas7xMsNIAsdDgyRHLsqK33Z+lPjCEmg9z96poYBcGwZsar8Demz/vNa8AXg
         Rsip69idfDIfCDViORhetyzPKkz0vdB16hvd8AID+AvfaVvj9QnEGwy7TRnbkXFQL1Gj
         2sIPGkAEatUP7GHaTl6jEQx2Zi6hpKJtCQ1XvA+wgRmLnb1CCM9t30apMUQ0xul1D/nQ
         vsh0n00/nJob9/6lxLLGkg8w+tnroC0AszeZcHOFk4zp/tQSGk/O13hxNbMwir+t7aLe
         qN3/yrC3SfKhBnwO/g+h9WTTxmEKQCue5TJzej9eg0Q8XhlzB04B84JLC7nLLvYerjrG
         G1gw==
X-Gm-Message-State: AOAM533z0ZezUJDg7VfU24Fmcz226HwXSKx9xIbYGTYA4QoZXF+y7/VU
        st8dhKZRVXo4vrENXjPEpOc=
X-Google-Smtp-Source: ABdhPJxqAqkvZJ2uNToTjmLSaK+Xexa4SVvEuSg9juTmHudR/Ir4Ow/eSAfYI6Rb4xJAn0viuw0Sfg==
X-Received: by 2002:a7b:c204:: with SMTP id x4mr3762230wmi.22.1591098881483;
        Tue, 02 Jun 2020 04:54:41 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host9-254-dynamic.3-87-r.retail.telecomitalia.it. [87.3.254.9])
        by smtp.googlemail.com with ESMTPSA id b18sm3273777wrn.88.2020.06.02.04.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 04:54:40 -0700 (PDT)
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
Subject: [PATCH v5 07/11] PCI: qcom: Define some PARF params needed for ipq8064 SoC
Date:   Tue,  2 Jun 2020 13:53:48 +0200
Message-Id: <20200602115353.20143-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200602115353.20143-1-ansuelsmth@gmail.com>
References: <20200602115353.20143-1-ansuelsmth@gmail.com>
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
 drivers/pci/controller/dwc/pcie-qcom.c | 27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index f2ea1ab6f584..f5398b0d270c 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -46,6 +46,9 @@
 
 #define PCIE20_PARF_PHY_CTRL			0x40
 #define PCIE20_PARF_PHY_REFCLK			0x4C
+#define PHY_REFCLK_SSP_EN			BIT(16)
+#define PHY_REFCLK_USE_PAD			BIT(12)
+
 #define PCIE20_PARF_DBI_BASE_ADDR		0x168
 #define PCIE20_PARF_SLV_ADDR_SPACE_SIZE		0x16C
 #define PCIE20_PARF_MHI_CLOCK_RESET_CTRL	0x174
@@ -77,6 +80,18 @@
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
@@ -293,6 +308,7 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	struct qcom_pcie_resources_2_1_0 *res = &pcie->res.v2_1_0;
 	struct dw_pcie *pci = pcie->pci;
 	struct device *dev = pci->dev;
+	struct device_node *node = dev->of_node;
 	u32 val;
 	int ret;
 
@@ -347,6 +363,17 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
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

