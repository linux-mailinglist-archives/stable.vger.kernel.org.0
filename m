Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16F31FA26B
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 23:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbgFOVGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 17:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbgFOVGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 17:06:34 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B676C08C5C2;
        Mon, 15 Jun 2020 14:06:34 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l12so18936334ejn.10;
        Mon, 15 Jun 2020 14:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XXtSQJBIW6XHl2mmAvdBVlZsx0pGkGe1gW4agfhCEW4=;
        b=Hh7ygWMI54L92HxNwNvnIIekrr9bNGN4aOX4EvV/CRXkpF3cAAHXTCW7/C28HIL9TN
         2NixDLCUilIJAE8JO4S/ymAgVgzmccHOxHi+05kzq0uSqOSSj9OJy60M0i/Q9Tvckn66
         YfxGNZmq2CdKSLItbQnKB0z/dsyCXTcdxaFYVCPkHS6snrrbxqDRZK91n1QCeRoWLMVX
         8+LhsnBKFbXIPhDgU2rCh8RhQPNFr0gHyl8bHTS786ra8Ezkv0U6hDlcwRMb0jag0/A0
         D47DfyA0T8xIjWTG+g6dJscZdhr6fx8sdT5BpIHqLpECFxqOEJ2Igon5cocekEe8RGv/
         qowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XXtSQJBIW6XHl2mmAvdBVlZsx0pGkGe1gW4agfhCEW4=;
        b=UdZ5UxrGmkyCETif1BXAnRtIR3cePk33sPRXRLKauwjaHKNLLoFuycW57QQB+/1u0F
         2jrLvWGkOQ5V+XlzzRyAVIOeNAn07eVHaGc3+f2SNQ8oINWWwud5Jtko6wHNc+cSvlDO
         pEgKLz05kCykoj5yDG5wmRtcziC850JBUfJr1/U5IiFJu2/O4G5+ouLkroxrvcdDPqBn
         bZjLDo55hIxdjBVxPp5DF5vxMNAIEAQXOLli3YHQgnTsJ3XgCvEVq57E+ZdvnJOsO+wZ
         FtxyYfN+mWA/pzPxzcfNPhs68r6fp6Ymc14H1UVZqlU+/7I+odR9hN5p/pn7M7MagQQp
         qS0g==
X-Gm-Message-State: AOAM532ZxVrL4EWmbPGivvsk8hI1thhfIT228MYoDC7oyAMXfRd63ky9
        65wzWjroA8bfKBiq2p/3tcA=
X-Google-Smtp-Source: ABdhPJySz+Kup6XcqBB5A5BBhr4P7TC2i+Q/m8tdRaHGIqWCNS4e+uCUvk0CGqtGxKqb3EL9CIE+QA==
X-Received: by 2002:a17:906:470b:: with SMTP id y11mr28271687ejq.182.1592255192688;
        Mon, 15 Jun 2020 14:06:32 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host-95-238-254-39.retail.telecomitalia.it. [95.238.254.39])
        by smtp.googlemail.com with ESMTPSA id d5sm9662226ejr.78.2020.06.15.14.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 14:06:32 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Vinod Koul <vkoul@kernel.org>, Ansuel Smith <ansuelsmth@gmail.com>,
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
Subject: [PATCH v7 08/12] PCI: qcom: Add support for tx term offset for rev 2.1.0
Date:   Mon, 15 Jun 2020 23:06:04 +0200
Message-Id: <20200615210608.21469-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0
In-Reply-To: <20200615210608.21469-1-ansuelsmth@gmail.com>
References: <20200615210608.21469-1-ansuelsmth@gmail.com>
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
2.27.0.rc0

