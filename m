Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119B11F5894
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 18:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgFJQHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 12:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730520AbgFJQH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 12:07:29 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62A3C03E96F;
        Wed, 10 Jun 2020 09:07:28 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so1779923edr.12;
        Wed, 10 Jun 2020 09:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jXtz99iuv/ovCkSGf6u5INPEkSX0yyHnlwxRCUFR+S8=;
        b=f8VFo0RwITPFhS+h5gblSA0oIENLUYtFC6Oex0pL2SmjXwPu4Bs8FyjUc96ACUxTtx
         2w4OtgtcEASS9sAWuPSaTyzXTNskP9/MOmbITNlLphWz8osqrYDd+casl3ABNqgpLnzp
         a+XlYTFXEMVcGTevkIAQ8DxkgykmTAyxr9VOq7WLJ9zuJSi+mm+XfowAzOdVOs7UfYL2
         c2kfDVyrlSweRtRYzqunb+YY+fGKRp+4m1dTAC3ycHqpQRdm0JQyGrjgAKNADrp1RViQ
         HP0GaRIaUP0KDY4RZQHZB6lq5FIGgJwuGqFCYCynP9zaPTwhphGZjbLlRh7OnujW0K/B
         +kCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jXtz99iuv/ovCkSGf6u5INPEkSX0yyHnlwxRCUFR+S8=;
        b=gIWrc48449geZvO4VhAKxgfVOezF0c93hS1sd90+Tt6K7BtHHe7guqvmS3BbBU/R1n
         YY6HDmCVKIxD+cRjPld6RLROJHMSYnus95C0ztQHKITHDWo0aBczui9wZsPh5UAzjKd7
         c4sbR1u/v6aZOGUu9Eps3WnXFyRWP52rTnn11ByXUQGhtrWqPcd6MFj85wkCPCd9m1/8
         452Nlb5p2hyR3++075UbaKrMX1AvaL2ZVBXMxv7Zkp2uRis60eqXgusyxWQWPXcBbYFR
         I8uqHOBmxnlpjkrDSzhZ98Jpc3QsLCZGRD6wP1JNOV8khWHzYng4foAEGjqcq20L/2qA
         TljQ==
X-Gm-Message-State: AOAM5325qjEREsSHP1KOgQG64RhH43wz2XHhVeVaKyu98YeAkAYNUKy2
        NUhw+EV4tAmaBzZAoQq+y3k=
X-Google-Smtp-Source: ABdhPJxNG24XUh5bQCrgMinY31VYsYlwkitpbR8b8nscOm4hE2+AuB+AsLZHKlfWigsidfDlm3KAyA==
X-Received: by 2002:aa7:de08:: with SMTP id h8mr2989096edv.164.1591805247304;
        Wed, 10 Jun 2020 09:07:27 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host-79-35-249-242.retail.telecomitalia.it. [79.35.249.242])
        by smtp.googlemail.com with ESMTPSA id ce25sm56067edb.45.2020.06.10.09.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 09:07:26 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        stable@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 08/12] PCI: qcom: Add support for tx term offset for rev 2.1.0
Date:   Wed, 10 Jun 2020 18:06:50 +0200
Message-Id: <20200610160655.27799-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200610160655.27799-1-ansuelsmth@gmail.com>
References: <20200610160655.27799-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add tx term offset support to pcie qcom driver need in some revision of
the ipq806x SoC. Ipq8064 needs tx term offset set to 7.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v4.5+
---
 drivers/pci/controller/dwc/pcie-qcom.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 85313493d51b..2cd6d1456210 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -45,7 +45,13 @@
 #define PCIE_CAP_CPL_TIMEOUT_DISABLE		0x10
 
 #define PCIE20_PARF_PHY_CTRL			0x40
+#define PHY_CTRL_PHY_TX0_TERM_OFFSET_MASK	GENMASK(20, 16)
+#define PHY_CTRL_PHY_TX0_TERM_OFFSET(x)		((x) << 16)
+
 #define PCIE20_PARF_PHY_REFCLK			0x4C
+#define PHY_REFCLK_SSP_EN			BIT(16)
+#define PHY_REFCLK_USE_PAD			BIT(12)
+
 #define PCIE20_PARF_DBI_BASE_ADDR		0x168
 #define PCIE20_PARF_SLV_ADDR_SPACE_SIZE		0x16C
 #define PCIE20_PARF_MHI_CLOCK_RESET_CTRL	0x174
@@ -371,9 +377,18 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		writel(PHY_RX0_EQ(4), pcie->parf + PCIE20_PARF_CONFIG_BITS);
 	}
 
+	if (of_device_is_compatible(node, "qcom,pcie-ipq8064")) {
+		/* set TX termination offset */
+		val = readl(pcie->parf + PCIE20_PARF_PHY_CTRL);
+		val &= ~PHY_CTRL_PHY_TX0_TERM_OFFSET_MASK;
+		val |= PHY_CTRL_PHY_TX0_TERM_OFFSET(7);
+		writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
+	}
+
 	/* enable external reference clock */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
-	val |= BIT(16);
+	val &= ~PHY_REFCLK_USE_PAD;
+	val |= PHY_REFCLK_SSP_EN;
 	writel(val, pcie->parf + PCIE20_PARF_PHY_REFCLK);
 
 	/* wait for clock acquisition */
-- 
2.25.1

