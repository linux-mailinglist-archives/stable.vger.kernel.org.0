Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990371C09FC
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 00:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgD3WGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 18:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgD3WGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 18:06:54 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB50BC035494;
        Thu, 30 Apr 2020 15:06:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gr25so5993830ejb.10;
        Thu, 30 Apr 2020 15:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0fkUJMBdFal40rBs7rtc2OpGG15AYOz1Qr+RHMHFzg=;
        b=agIJz6xxdv5fpQ00hpqSrhBa7lz7Qbxc7OxLHBljF+YfHjZG3rFWohLZYgWLGtfa8C
         6a7nOEDuectluGxfouvEMzv2UeStA8voJcIrYcQUMgqIaSdFW5Y/jaUWscafm32ZRvUw
         /bWgHYlytxX5Dnx636gCPtG4vnrzccV9MJIpbQqNlbh1ljyJ/0Vzmrz4orTflrq1pZcB
         j5Ml9F3x2QjOFMNSklEwxZUltVX7R30Ffz8m0+xlOcwTkT7EpPNk5qno9RxSb6CMnfN9
         t/kt0dCXJ3wo1obDzZXSnGa7vHp74TBGJBMEpCD+wLIhIhSYCgbT+GltQmRaGCAy2U0m
         HrLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0fkUJMBdFal40rBs7rtc2OpGG15AYOz1Qr+RHMHFzg=;
        b=lxY4do22Zhs4nXXHuC4W4k4OILJUnctEUuecluRPgXyVct+EPdG/8V9gJTMe/+5oab
         AYYLnCKK5SU/686olb5XLwuU/Nz6s8+ovbtenJn7KV00uyV8o6csBVVVHqCuK2tZF5Vv
         1j61UPUo5laDIlSb9TuWlWb2P+mPABWJMjmnmlw2Qjrbb1g+iO5qXoT5N8+4FYRjNdDd
         a0DdYG6ultICrr8oAN3ddswTEY5k7Ga0neqJxG9p/cWyogoXaZKyd/0GlitiT5CuJDU9
         9mfFqFQfTDkqHnbWWZhHxg/mt9c/kPOgZtuRwOWNzxO658S1eXgELBOYHj4ZlgHXT8KW
         B38g==
X-Gm-Message-State: AGi0PuY2sITru/kQHi44jYnEYBIoPpyssq42l5CiLDTmpjor/Fmh2l3t
        aqs17z9TwobWDUUmvA+/e3c=
X-Google-Smtp-Source: APiQypLOXRJf5iIfx72iQWrXo/VOvuT8bdMzp9X2RxLhB5EEdcb3Ce3il0Zr0B6dBXKgsU+mWsrAfQ==
X-Received: by 2002:a17:906:6411:: with SMTP id d17mr559183ejm.109.1588284412512;
        Thu, 30 Apr 2020 15:06:52 -0700 (PDT)
Received: from Ansuel-XPS.localdomain ([79.37.253.240])
        by smtp.googlemail.com with ESMTPSA id t17sm54185edq.88.2020.04.30.15.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 15:06:51 -0700 (PDT)
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
Subject: [PATCH v3 07/11] PCI: qcom: add support for defining some PARF params
Date:   Fri,  1 May 2020 00:06:14 +0200
Message-Id: <20200430220619.3169-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200430220619.3169-1-ansuelsmth@gmail.com>
References: <20200430220619.3169-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add support for Tx De-Emphasis, Tx Swing and Rx equalization definition
needed on some ipq8064 based device (Netgear R7800 for example). This
cause a total lock of the system on kernel load.

Fixes: 82a823833f4e PCI: qcom: Add Qualcomm PCIe controller driver
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v4.5+
---
 drivers/pci/controller/dwc/pcie-qcom.c | 47 ++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index a4fd5baada34..da8058fd1925 100644
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
@@ -97,6 +112,12 @@ struct qcom_pcie_resources_2_1_0 {
 	struct reset_control *phy_reset;
 	struct reset_control *ext_reset;
 	struct regulator_bulk_data supplies[QCOM_PCIE_2_1_0_MAX_SUPPLY];
+	u32 tx_deemph_gen1;
+	u32 tx_deemph_gen2_3p5db;
+	u32 tx_deemph_gen2_6db;
+	u32 tx_swing_full;
+	u32 tx_swing_low;
+	u32 rx0_eq;
 };
 
 struct qcom_pcie_resources_1_0_0 {
@@ -234,8 +255,21 @@ static int qcom_pcie_get_resources_2_1_0(struct qcom_pcie *pcie)
 	struct qcom_pcie_resources_2_1_0 *res = &pcie->res.v2_1_0;
 	struct dw_pcie *pci = pcie->pci;
 	struct device *dev = pci->dev;
+	struct device_node *node = dev->of_node;
 	int ret;
 
+	of_property_read_u32(node, "qcom,tx-deemph-gen1",
+			     &res->tx_deemph_gen1);
+	of_property_read_u32(node, "qcom,tx-deemph-gen2-3p5db",
+			     &res->tx_deemph_gen2_3p5db);
+	of_property_read_u32(node, "qcom,tx-deemph-gen2-6db",
+			     &res->tx_deemph_gen2_6db);
+	of_property_read_u32(node, "qcom,tx-swing-full",
+			     &res->tx_swing_full);
+	of_property_read_u32(node, "qcom,tx-swing-low",
+			     &res->tx_swing_low);
+	of_property_read_u32(node, "qcom,rx0-eq", &res->rx0_eq);
+
 	res->supplies[0].supply = "vdda";
 	res->supplies[1].supply = "vdda_phy";
 	res->supplies[2].supply = "vdda_refclk";
@@ -368,9 +402,18 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	/* enable PCIe clocks and resets */
 	qcom_clear_and_set_dword(pcie->parf + PCIE20_PARF_PHY_CTRL, BIT(0), 0);
 
+	writel(PCS_DEEMPH_TX_DEEMPH_GEN1(res->tx_deemph_gen1) |
+	       PCS_DEEMPH_TX_DEEMPH_GEN2_3_5DB(res->tx_deemph_gen2_3p5db) |
+	       PCS_DEEMPH_TX_DEEMPH_GEN2_6DB(res->tx_deemph_gen2_6db),
+	       pcie->parf + PCIE20_PARF_PCS_DEEMPH);
+	writel(PCS_SWING_TX_SWING_FULL(res->tx_swing_full) |
+	       PCS_SWING_TX_SWING_LOW(res->tx_swing_low),
+	       pcie->parf + PCIE20_PARF_PCS_SWING);
+	writel(PHY_RX0_EQ(res->rx0_eq), pcie->parf + PCIE20_PARF_CONFIG_BITS);
+
 	/* enable external reference clock */
-	qcom_clear_and_set_dword(pcie->parf + PCIE20_PARF_PHY_REFCLK, 0,
-				 BIT(16));
+	qcom_clear_and_set_dword(pcie->parf + PCIE20_PARF_PHY_REFCLK,
+				 PHY_REFCLK_USE_PAD, PHY_REFCLK_SSP_EN;
 
 	ret = reset_control_deassert(res->phy_reset);
 	if (ret) {
-- 
2.25.1

