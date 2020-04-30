Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5DC1C09E8
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 00:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgD3WGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 18:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgD3WGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 18:06:38 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9BDC035494;
        Thu, 30 Apr 2020 15:06:36 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id q8so6016072eja.2;
        Thu, 30 Apr 2020 15:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OqdsL6oVEYDsaU2ajghqSTycB/dhWD7JVGPrizA/d1E=;
        b=bk6sNZJ87amcVdfIb232iw1yidtULT6ThRortjgOydN9S//dH/QOGsc0rHLvYSzQD7
         J+KGwzZyTa6q4jZNBsXkewjvCDVpxxQvpmHIYL0tm7I65sBPrqgrNXf8VQ8sUJrJsLhO
         MyRbJklX6Y7xzb26M5+D1SGps/Y8DVEbqi+mbSDTjcL1zlV0wXovsOhHB9WWFGtYBeHh
         YyG6HD4myO1FCt9bA+cF1+D835PhXO0K1Uka11HdNR7/K2mQrP4rcCEUWxcgEcLks4En
         NTY4Gszr0e3RLDXPFJiTdMqibOKVl6Mm9Vbbx6DbjytMTBPZ3S2MDsXcUnqgYSSvKAhj
         7HJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OqdsL6oVEYDsaU2ajghqSTycB/dhWD7JVGPrizA/d1E=;
        b=hVcrwZEEoEB2UFNVdm6dmi+7CdLGle2Ix7C0fI1oS4JWO9V1zgfNWBYuVv3LCnWqo3
         Bm+CSOPQ1skTLbiVzwoloTPEKv3Lk9lwts1QtLq16bFVQ5ZmM/FBLJc9fIBuiUY4nyTo
         yxvDIhnZ2pT7lZeWd4d11MadKsRqrjdA/pxQH8kg5IHaKsXmNcAPwEap5TZQqmxRi0Vl
         /UqGbD99DjJ9z/oDAb7xcvB/SbNe3zJuftN+Z3QP0yAXJOPy7dRpZZkDOHfbbbGy40iP
         zLNHWS8bollmWos4Q3D+w9F2ur7RYTF6PegVR4MjnLE6Q1/4Vm3qgIUinEsudJzzz36R
         Qf4g==
X-Gm-Message-State: AGi0PuaxAOSGpUi/nUbd6Tm031o0OeD2CCjgj9VRmPQGeNmUEWaT5iKW
        /IcgdXNc/cJinRZs3U7HK0M=
X-Google-Smtp-Source: APiQypItPxjgwbSyRlXSixiFqHQbhHHGoPoMPlzjtd7ZlRMtNHvSfTkDOsdKKHiWxy7IK+enwCBH9w==
X-Received: by 2002:a17:906:13d1:: with SMTP id g17mr596971ejc.162.1588284394952;
        Thu, 30 Apr 2020 15:06:34 -0700 (PDT)
Received: from Ansuel-XPS.localdomain ([79.37.253.240])
        by smtp.googlemail.com with ESMTPSA id t17sm54185edq.88.2020.04.30.15.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 15:06:34 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        stable@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/11] PCI: qcom: add missing ipq806x clocks in PCIe driver
Date:   Fri,  1 May 2020 00:06:08 +0200
Message-Id: <20200430220619.3169-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200430220619.3169-1-ansuelsmth@gmail.com>
References: <20200430220619.3169-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Aux and Ref clk are missing in PCIe qcom driver.
Add support in the driver to fix PCIe initialization in ipq806x.

Fixes: 82a823833f4e PCI: qcom: Add Qualcomm PCIe controller driver
Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v4.5+
---
 drivers/pci/controller/dwc/pcie-qcom.c | 44 ++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 5ea527a6bd9f..2a39dfdccfc8 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -88,6 +88,8 @@ struct qcom_pcie_resources_2_1_0 {
 	struct clk *iface_clk;
 	struct clk *core_clk;
 	struct clk *phy_clk;
+	struct clk *aux_clk;
+	struct clk *ref_clk;
 	struct reset_control *pci_reset;
 	struct reset_control *axi_reset;
 	struct reset_control *ahb_reset;
@@ -246,6 +248,14 @@ static int qcom_pcie_get_resources_2_1_0(struct qcom_pcie *pcie)
 	if (IS_ERR(res->phy_clk))
 		return PTR_ERR(res->phy_clk);
 
+	res->aux_clk = devm_clk_get_optional(dev, "aux");
+	if (IS_ERR(res->aux_clk))
+		return PTR_ERR(res->aux_clk);
+
+	res->ref_clk = devm_clk_get_optional(dev, "ref");
+	if (IS_ERR(res->ref_clk))
+		return PTR_ERR(res->ref_clk);
+
 	res->pci_reset = devm_reset_control_get_exclusive(dev, "pci");
 	if (IS_ERR(res->pci_reset))
 		return PTR_ERR(res->pci_reset);
@@ -278,6 +288,8 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
 	clk_disable_unprepare(res->iface_clk);
 	clk_disable_unprepare(res->core_clk);
 	clk_disable_unprepare(res->phy_clk);
+	clk_disable_unprepare(res->aux_clk);
+	clk_disable_unprepare(res->ref_clk);
 	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
 }
 
@@ -307,16 +319,32 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		goto err_assert_ahb;
 	}
 
+	ret = clk_prepare_enable(res->core_clk);
+	if (ret) {
+		dev_err(dev, "cannot prepare/enable core clock\n");
+		goto err_clk_core;
+	}
+
 	ret = clk_prepare_enable(res->phy_clk);
 	if (ret) {
 		dev_err(dev, "cannot prepare/enable phy clock\n");
 		goto err_clk_phy;
 	}
 
-	ret = clk_prepare_enable(res->core_clk);
-	if (ret) {
-		dev_err(dev, "cannot prepare/enable core clock\n");
-		goto err_clk_core;
+	if (res->aux_clk) {
+		ret = clk_prepare_enable(res->aux_clk);
+		if (ret) {
+			dev_err(dev, "cannot prepare/enable aux clock\n");
+			goto err_clk_aux;
+		}
+	}
+
+	if (res->ref_clk) {
+		ret = clk_prepare_enable(res->ref_clk);
+		if (ret) {
+			dev_err(dev, "cannot prepare/enable ref clock\n");
+			goto err_clk_ref;
+		}
 	}
 
 	ret = reset_control_deassert(res->ahb_reset);
@@ -372,10 +400,14 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	return 0;
 
 err_deassert_ahb:
-	clk_disable_unprepare(res->core_clk);
-err_clk_core:
+	clk_disable_unprepare(res->ref_clk);
+err_clk_ref:
+	clk_disable_unprepare(res->aux_clk);
+err_clk_aux:
 	clk_disable_unprepare(res->phy_clk);
 err_clk_phy:
+	clk_disable_unprepare(res->core_clk);
+err_clk_core:
 	clk_disable_unprepare(res->iface_clk);
 err_assert_ahb:
 	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
-- 
2.25.1

