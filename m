Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC071FA25E
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 23:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbgFOVG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 17:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbgFOVGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 17:06:24 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F32C061A0E;
        Mon, 15 Jun 2020 14:06:24 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l12so18935508ejn.10;
        Mon, 15 Jun 2020 14:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rLX+AzNeSNEPYCUgq95CzUacvnfDy5NOCzXpFKlNSv0=;
        b=QdvSU7m/o8PSzkFMBdzi+WQ590JV93QfBttTYeOddMasPz3pOkKug7Oqqk93D8oMwq
         Y+eE2U1ruKyg9Z+MoNC6qPes4qjS12EKKKxuLrP+mnQlCzly+cvzndJftnBbjWvIA2TY
         3E/LkCf5qviSZFH/fy77VzwXJU32Dtfg64Ylu9wHee+H8ADJq3W899JAOkI48OdHcx8o
         gwAiFjyJj4B1IQLUJJlb546GBoU/OMLn/snBe0eMFnV0vJq0YYdjXYIaxMTMtEJSe1un
         DiMuifKhdnB+ZEFIGcXuVlSNHF3kQscr6BzHIjGxR2KNQzyuJ5dBwz8vl0f6vCCEbzdN
         VUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rLX+AzNeSNEPYCUgq95CzUacvnfDy5NOCzXpFKlNSv0=;
        b=UYPFppkRQB50BBh4rQV+oHFRc/d/MwQ2YGfV6D8ovTYf3o5ZxTtGVzDNh5yTJATth6
         tRToVHSpANNIcQqgpbE98F/ZEhpMssu39U8xTtgbqJEgYztWzmJtU8NoVhUF9Zl7oaSV
         H0kQ4tZj64wpL7jxRvjpNDzy8svDNpqDRCJT3LdtZzx38rvk4OoQJ0SHhsMMuwzqUTKj
         deyNj7EhOzuVgXK80Zyw9wI3kZOXL0Lg1kzk1/ZI3WC03U3dvCqOTXg9uNjk4QiTEYDR
         pfTHO/IMH/sRqkYH+yHheqOenRoJ8vaQXEl90Dc0zBMzdom6CcusLEX/1zTVZHa70Ndj
         5kBw==
X-Gm-Message-State: AOAM533ZbX9Pj4DluG7IOXV0ZbJwCtJYXsA1XfvtIi/PJOSctPEDtSqT
        U39gMOfwbk7H8/lbm4sBLfKwAiqmxbzkRrrU
X-Google-Smtp-Source: ABdhPJwz82xWf7NwCjghgzyWXaDjnoL3k8r/qHOrHkeKWlQX4yBINS8dRzmaBSJlG5yvNO1J6OHPtg==
X-Received: by 2002:a17:906:7103:: with SMTP id x3mr24660149ejj.363.1592255183076;
        Mon, 15 Jun 2020 14:06:23 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host-95-238-254-39.retail.telecomitalia.it. [95.238.254.39])
        by smtp.googlemail.com with ESMTPSA id d5sm9662226ejr.78.2020.06.15.14.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 14:06:22 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Vinod Koul <vkoul@kernel.org>, Ansuel Smith <ansuelsmth@gmail.com>,
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
Subject: [PATCH v7 04/12] PCI: qcom: Add missing reset for ipq806x
Date:   Mon, 15 Jun 2020 23:06:00 +0200
Message-Id: <20200615210608.21469-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0
In-Reply-To: <20200615210608.21469-1-ansuelsmth@gmail.com>
References: <20200615210608.21469-1-ansuelsmth@gmail.com>
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
2.27.0.rc0

