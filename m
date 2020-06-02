Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039A71EBB14
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 13:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgFBLzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 07:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbgFBLyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 07:54:32 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E1BC061A0E;
        Tue,  2 Jun 2020 04:54:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f5so2816091wmh.2;
        Tue, 02 Jun 2020 04:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0T+25FzC3m+ZCfSnTnyTsPpwm0TEOUYS6HI+FaVLFf0=;
        b=EpGEXjAVbgpT2SQTvfPorH9Jt3XX4IeCDlZVxZe+PQESUTeCi+9NJVgEq634nwPMrx
         YSOlpYHLH/he0+MC/MOR8WRTorq4lau2zj5+TealPjfnt1kDxk++GJoLGFX5trMfp6qL
         5QJwy2Yfz6rxx2lzwHjFpKnbk01SJvfyqcfGX5c04rnuftniD5s74ZzEKiNLA/fZnh/H
         qNz641jfimWPrZcslMTjTppHhi8tqsfEdCHCUp7U3OqAHNLmjW7UvAAONT5J5ZFdJVbo
         P+HvUONWn5gPydgMw+2wM9HS/PuGcRoCDs4i90kjBS7IG/H+fYBaeguJZBdi40Q9nidU
         3O6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0T+25FzC3m+ZCfSnTnyTsPpwm0TEOUYS6HI+FaVLFf0=;
        b=nJzcifOCSmmV4ODP+lnpIUmw9vYlhX+a4hSL4n7O4WByuj9wBCXIwZOk5nnaidpwP0
         DVGUcxf+kF4CMFKgym7FhoUMcLroM1hSpydnjYYc+iGq7YnKa5ADi4VIDyuqE4kNOhdJ
         aoxUQM3QHoctPuHDGKOhVqpscpACTmKkvqS6itjIMdw5IlIuFAoRgKHLu9gas9NoTWlC
         6CulqWpuwKQNn7WrRoJBx8qQoVLIzFcARl/Fu8lUAVyfFmjt9hNLkFoIkdoFkXOzxCwG
         InKh2iZ+xd5U9VmwvZz/ccJKqsYsHoQH73SxExiMId161oAz9XI1v9E0RhWgFTuSoqzS
         7bZQ==
X-Gm-Message-State: AOAM532IkXlDIFVNn3ChMtHIGkV3ftlarkEW6Ycz99XzIOezM2c7IcdU
        tAtdl6Kgh2ECMtZUXsD4GLc=
X-Google-Smtp-Source: ABdhPJyrLJafVl3fMd4w2rhOS1xKBiSk9UehJodvGQ+/mZWt012vRSkIi5Oupuo+3wj83gvwrLca+g==
X-Received: by 2002:a1c:dfd7:: with SMTP id w206mr3723154wmg.130.1591098871366;
        Tue, 02 Jun 2020 04:54:31 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host9-254-dynamic.3-87-r.retail.telecomitalia.it. [87.3.254.9])
        by smtp.googlemail.com with ESMTPSA id b18sm3273777wrn.88.2020.06.02.04.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 04:54:30 -0700 (PDT)
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
Subject: [PATCH v5 04/11] PCI: qcom: Add missing reset for ipq806x
Date:   Tue,  2 Jun 2020 13:53:45 +0200
Message-Id: <20200602115353.20143-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200602115353.20143-1-ansuelsmth@gmail.com>
References: <20200602115353.20143-1-ansuelsmth@gmail.com>
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

