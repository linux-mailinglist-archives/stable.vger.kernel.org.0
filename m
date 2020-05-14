Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C291D3E8A
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 22:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgENUHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 16:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729294AbgENUHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 16:07:40 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F132C061A0C;
        Thu, 14 May 2020 13:07:40 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id x20so3854670ejb.11;
        Thu, 14 May 2020 13:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0T+25FzC3m+ZCfSnTnyTsPpwm0TEOUYS6HI+FaVLFf0=;
        b=ivFOECzR1EGPm3sEMB0b9aXpLh1nqfiBK4/EUzm3KMuREnuv2O7eObttZ2MUQmoHG4
         gA3VWiLHUvfal2vI8e4Fc8sptW7Y0H0sxYLbIF3u6CzKt8Q9mg2Jh4PIEdqUOJIDeGYo
         ipBqrxgdfcPYXilPro4P0w9lHHyKa3zjbNrkrYzcNJ9Xj/0W4+ed+OYyokdLBP3wfyVz
         OAGn6d+kzPfRa42CxOQnrdzSBap5Ybn4IGhgWsk5g24tJ5rIDd4lehT/P8AObHtjROAi
         3lhNizah2FKgHaa/GynOXuzb/dtEaGRNajzp5OgrDCbLV0b9gy6mnqj8iXIGxzUjYLzi
         YyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0T+25FzC3m+ZCfSnTnyTsPpwm0TEOUYS6HI+FaVLFf0=;
        b=kafsiFBoAw/cge+Qvc1adaZwMlPU3AZ5Q5kJ4A48vdBekuZSCPADe6eKTLdEH6OMpO
         eD//PaPWvb+awqYfD7JxGiWt8vV1LTAE06np/ZICl7V+9lhuC8eURu6F1DJDbGCwAjCH
         gEJR2uhzBgcYwMOSdTurdeOvPEI5EkbCPj2KWHrE4E5b/2IWRUy1K2miyV3/le7qekqT
         69r1TozTzAAf7H/L9OlZVpy96djKuCdyHj61kY5ztvzATjP0Gb3g+O0SsztRvpY8V+yL
         JR0e+cPSRgh5wxDxS7LSY/wr8uPyrp0yglqHReCXYNF114lQrj1t6ZUBTFhEGKlWPNq1
         QERg==
X-Gm-Message-State: AOAM531K7bQb835g8urfhZ288KoGXTMtFcYPeyZfYOOfpGFCxGs8wvTs
        LD+d285zSitOODRoueYAU7CWrSstCJvvzMaP
X-Google-Smtp-Source: ABdhPJwRo3REn1J6uKtGQRAGV8lTL3qHbWJLe82J96U1+0lPiZamxVZZZEKxk9Hpzvj7VfXnz9LVLw==
X-Received: by 2002:a17:906:81c6:: with SMTP id e6mr5380925ejx.241.1589486859144;
        Thu, 14 May 2020 13:07:39 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host122-89-dynamic.247-95-r.retail.telecomitalia.it. [95.247.89.122])
        by smtp.googlemail.com with ESMTPSA id bd10sm1472edb.10.2020.05.14.13.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 13:07:38 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Andy Gross <agross@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/10] PCI: qcom: Add missing reset for ipq806x
Date:   Thu, 14 May 2020 22:07:05 +0200
Message-Id: <20200514200712.12232-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200514200712.12232-1-ansuelsmth@gmail.com>
References: <20200514200712.12232-1-ansuelsmth@gmail.com>
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

