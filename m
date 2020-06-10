Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D041F588D
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 18:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgFJQHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 12:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730485AbgFJQHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 12:07:19 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798D2C03E96B;
        Wed, 10 Jun 2020 09:07:18 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id p18so1794406eds.7;
        Wed, 10 Jun 2020 09:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0T+25FzC3m+ZCfSnTnyTsPpwm0TEOUYS6HI+FaVLFf0=;
        b=D5avXRJ0CRE/hkpdok7mBnAiikNs9W5NkXT2b9BVl6NYMzgReCYOdrGmGIGvPSBwZl
         nxl4XzLAKjaPSQjkfVl/HZD8DFloH1qiDSKyADt57D5apRKldzZs7BDidQJFY9wcofhq
         PXk6APfsy+7jVgM5MFCVkP/zp35AYMbhXk/lubgfOpZ6HG30lT0PCopglonPazmanWmn
         lhQETTrZ9GrQT4mqGn9tGmsgdrD/yjL0LtKOC7T8FKTYdcIpXV7hsJbYSW6MpLTRJdvX
         dj5evpQ16e0MVlWqg7hZLVhdSTzZJJhniR6UlmhBd8QrrlwZX6hGWALkN4WP4K9Avh6L
         5HUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0T+25FzC3m+ZCfSnTnyTsPpwm0TEOUYS6HI+FaVLFf0=;
        b=mYQksZxnjadvLEVMaCQSfYst33NRdef4PWSuKaNIVDsCF2DabPGwMJObUdHOdGR2bS
         wmq58Y3HycRkUzYwKmXPNPBYpF/IaK4PmoIwEhrU/UNZJXeezQ0TbanyUzu2mz2IqiHN
         PZQfkPDe1FQKzz/FOk+2b4xdDl5hVbMxIXjhjT56EvTlIeP2gXxRk04B3nXu6Np2Tlfs
         PCCNWORX4TcjCUVJwOuJdk0Vv6DEHI/DLkjJLBSHE9qp3Vw/wCviTF6IGzm6PX+R589e
         hjM3+MAdYjtoyujXqs/80XuGQ41nPHep4gGqSTMWhik+wxv8FYo3fT4qx0BBHxItjPQq
         Bn3w==
X-Gm-Message-State: AOAM533kzBc4+GNMbposxlQjpGXQCu6gj3Xj5qdnNySO1FKVPNdeCa6h
        xJwaF+MPWUVuyGfN5Ww73jA=
X-Google-Smtp-Source: ABdhPJw+bu9CjVuWWI4xfytkCvENopNDNd4j1yWIK6dWj7rf/Gzq6rA7aX+qYELKxvGHFPBzRi8Tyg==
X-Received: by 2002:a50:fd05:: with SMTP id i5mr3022459eds.79.1591805237150;
        Wed, 10 Jun 2020 09:07:17 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host-79-35-249-242.retail.telecomitalia.it. [79.35.249.242])
        by smtp.googlemail.com with ESMTPSA id ce25sm56067edb.45.2020.06.10.09.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 09:07:16 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 04/12] PCI: qcom: Add missing reset for ipq806x
Date:   Wed, 10 Jun 2020 18:06:46 +0200
Message-Id: <20200610160655.27799-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200610160655.27799-1-ansuelsmth@gmail.com>
References: <20200610160655.27799-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add missing ext reset used by ipq8064 SoC in PCIe qcom driver.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v4.5+
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 4512c2c5f61c..4dab5ef630cc 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -95,6 +95,7 @@ struct qcom_pcie_resources_2_1_0 {
 	struct reset_control *ahb_reset;
 	struct reset_control *por_reset;
 	struct reset_control *phy_reset;
+	struct reset_control *ext_reset;
 	struct regulator_bulk_data supplies[QCOM_PCIE_2_1_0_MAX_SUPPLY];
 };
 
@@ -272,6 +273,10 @@ static int qcom_pcie_get_resources_2_1_0(struct qcom_pcie *pcie)
 	if (IS_ERR(res->por_reset))
 		return PTR_ERR(res->por_reset);
 
+	res->ext_reset = devm_reset_control_get_optional_exclusive(dev, "ext");
+	if (IS_ERR(res->ext_reset))
+		return PTR_ERR(res->ext_reset);
+
 	res->phy_reset = devm_reset_control_get_exclusive(dev, "phy");
 	return PTR_ERR_OR_ZERO(res->phy_reset);
 }
@@ -285,6 +290,7 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
 	reset_control_assert(res->axi_reset);
 	reset_control_assert(res->ahb_reset);
 	reset_control_assert(res->por_reset);
+	reset_control_assert(res->ext_reset);
 	reset_control_assert(res->phy_reset);
 	clk_disable_unprepare(res->iface_clk);
 	clk_disable_unprepare(res->core_clk);
@@ -343,6 +349,12 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		goto err_deassert_ahb;
 	}
 
+	ret = reset_control_deassert(res->ext_reset);
+	if (ret) {
+		dev_err(dev, "cannot deassert ext reset\n");
+		goto err_deassert_ahb;
+	}
+
 	/* enable PCIe clocks and resets */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_CTRL);
 	val &= ~BIT(0);
-- 
2.25.1

