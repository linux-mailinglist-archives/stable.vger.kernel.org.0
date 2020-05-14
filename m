Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B0B1D3E9D
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 22:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgENUHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 16:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729341AbgENUHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 16:07:48 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECA4C061A0C;
        Thu, 14 May 2020 13:07:47 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id s3so4617eji.6;
        Thu, 14 May 2020 13:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c7s8PI1C4weEkl07MvE9RhRVBEJwMJ9l5BWaz0ggV1E=;
        b=mMfJLANrQoMjmVFz0LsA1WxCOPSD63DvdKi+3nsjWqFyJMyR2ND2+NYvw0u76y7oXP
         gfhXeQIo8IFOy/GmFm61rcgjYrV7gljEGzebEX80Bgi5EAmP9Bc7emc2VStUfR1KPCFL
         8vHv9RHIOCsm49DAplxLQb9egoEKIKWoqleIHDUtSM8+KJiTvJWxntan2+TJzoF3oycI
         Y/lcpCkFaQNf4Npt6RKDhLAsPIDV6nagnhKrvgZzllBIi4yqJ7VqV0jd8rCK+9T8On0B
         2MkcNpv5pjxbNmbEJAg85CpXT6c5ZtrMge0ckCrFg9oHT5LNlVsRoCBDXb5eTrdXjFaT
         PxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c7s8PI1C4weEkl07MvE9RhRVBEJwMJ9l5BWaz0ggV1E=;
        b=L97vmS3Bc4wUPo+uJRRFpZDs8ZmnwsMxRqBqq6crom4QTSeNM1u+VxVxtl5vfrpWYp
         bI4RkzdaIwNz5kh3R4NLak33vQlDu4g1MMrnO0RHdx7e9Lp6IHaA0rYh5RT0gcFmm8D9
         8jx5xpIK3ry0Y53EoF5XUqO/GFRxKDOuBhRtH2DSKIzZ9xwqt4avIz1W3ZXAE94ZdyqT
         OJzk9DkzkbdCUvk2z+tCw26cXF75pM4fwBB8YXeFTFtMOy1g8E4R9n1FyFldUnnIYzs/
         nDLUpvI8dpxweknxnuIrS0rkXoBC/+xjLSqSGE1A2CCD8Cr7BLvpwYRQSyDMIQlcyDkx
         GR3A==
X-Gm-Message-State: AOAM530w6bfy91n4afpxHxcO3S7QESCzs1/3eDCOQVPjKrSEaq90+RJ5
        N4JieS673YHw2MHNwqlAhlA=
X-Google-Smtp-Source: ABdhPJymzN4HIFPWCqToGODe6lRdU+8SC1V1goiAZWdYlI/8xEFUJRgE3qC3l9Cpvq7ObzAhCyWUcg==
X-Received: by 2002:a17:906:770b:: with SMTP id q11mr5435245ejm.224.1589486866213;
        Thu, 14 May 2020 13:07:46 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host122-89-dynamic.247-95-r.retail.telecomitalia.it. [95.247.89.122])
        by smtp.googlemail.com with ESMTPSA id bd10sm1472edb.10.2020.05.14.13.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 13:07:45 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 07/10] PCI: qcom: Define some PARF params needed for ipq8064 SoC
Date:   Thu, 14 May 2020 22:07:08 +0200
Message-Id: <20200514200712.12232-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200514200712.12232-1-ansuelsmth@gmail.com>
References: <20200514200712.12232-1-ansuelsmth@gmail.com>
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

