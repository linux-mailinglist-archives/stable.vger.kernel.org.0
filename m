Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1768B1C09F2
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 00:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgD3WGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 18:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgD3WGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 18:06:45 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC38EC035494;
        Thu, 30 Apr 2020 15:06:44 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n4so5986395ejs.11;
        Thu, 30 Apr 2020 15:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NTSEddZV2Ao05kNtBAJHES9gCGwIno9St6PsZ/GXLQk=;
        b=tOwy44aiA+CSH65BAPlP0tMBN460Wj4fc2E5Sa+lUWlcBHi/f8R1OUC26NbCYIPZXm
         AjNfsZdk6ULjoah7oE8V6RZgqHFrBifnbj2LvgNutQ+2YJ8RcmRiWxkw1Ht9RMm/xhdo
         r4DZ1MjSPXaDyJ1bC4xV2YkVpl5yxI1iBPnVLNxh2dt/Ttb6Wp8qnitP44gJ+TLN2ZY3
         HD4Hrbqbv4cBvaXEPx3bH/7rio0lkJEH5r70sPs8Ckt2nwEt2vRZquap47FMGAnwhkp1
         3ZAiwUeHc+ZlC9dWTMuGpxEUhr1bX4AiP9nSioSADZVnZDXHxrmof4XNlad3CLonrKf6
         h1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NTSEddZV2Ao05kNtBAJHES9gCGwIno9St6PsZ/GXLQk=;
        b=PGP9tjFrt6YtQ7iud5iWbrRNFXww9oFQKyPH3oOuf6p5Mos+vXdUWz3aKKC4a850Pl
         5h5GoWOJCMPFnK8eXiiFQEMU9vtxho+1s1DONNzSoahjiQJVRY8An5/CiUV6bFzDMKlE
         QFFvDKXnqpP0J6XbbeNwKzpWwdgsXXv34D87CqbjM2b/7Ff+C3U+bXewS7meFpvvpeer
         sVUIYhn7HeNQFnfO/fdWQuQBjYoc/LIl6mC4XON8JZy2cQH8BrYEedNUdVRetdyXqI8s
         GL1MYIYp0zLtHVa2ZqwMKVaUgByph7SvqGdxj8A2+fI6XLBct2Fvsz5EOxd7qMDVkC8X
         Bo2g==
X-Gm-Message-State: AGi0Pua0hGUq/BFEWrbVgltIvtvQsKnymueuxuNkjbCfN2uJvCHm5VYx
        24kIonsWXPlEGCkFTYfc25k=
X-Google-Smtp-Source: APiQypKFfQymUajfbFD5KRjtUC9vrAeNBUfhZsLjaEQrJzlYX0PM4QcJDNjz0Hgzh5kGjrbanPpOjQ==
X-Received: by 2002:a17:907:2101:: with SMTP id qn1mr567727ejb.207.1588284403507;
        Thu, 30 Apr 2020 15:06:43 -0700 (PDT)
Received: from Ansuel-XPS.localdomain ([79.37.253.240])
        by smtp.googlemail.com with ESMTPSA id t17sm54185edq.88.2020.04.30.15.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 15:06:42 -0700 (PDT)
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
Subject: [PATCH v3 04/11] PCI: qcom: add missing reset for ipq806x
Date:   Fri,  1 May 2020 00:06:11 +0200
Message-Id: <20200430220619.3169-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200430220619.3169-1-ansuelsmth@gmail.com>
References: <20200430220619.3169-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add missing ext reset used by ipq8064 SoC in PCIe qcom driver.

Fixes: 82a823833f4e PCI: qcom: Add Qualcomm PCIe controller driver
Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v4.5+
---
 drivers/pci/controller/dwc/pcie-qcom.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 7a8901efc031..921030a64bab 100644
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
@@ -347,6 +353,12 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		goto err_deassert_ahb;
 	}
 
+	ret = reset_control_deassert(res->ext_reset);
+	if (ret) {
+		dev_err(dev, "cannot assert ext reset\n");
+		goto err_deassert_ahb;
+	}
+
 	/* enable PCIe clocks and resets */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_CTRL);
 	val &= ~BIT(0);
-- 
2.25.1

