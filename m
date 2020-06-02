Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC1A1EBAF1
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 13:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgFBLyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 07:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgFBLyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 07:54:46 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B02C061A0E;
        Tue,  2 Jun 2020 04:54:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so3129578wrp.2;
        Tue, 02 Jun 2020 04:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z+l2SJlxwdbSAeCvbGCXrANrMH1wFyQWwIwcm1pjtOc=;
        b=DbXaFmpOXaej68wvKy6x7avnN34Acp0tItjNhciOy2gXjpPK/BsXdfZLGIuxK1zqMT
         xdokpN7xBSVhM1CTECVDQyNH9ibiyHvdbPPE8tekOxUyhj5AL4gn1fqd3jmYCZGmtngP
         1GJjf95ohwo27YTjHfvBRqD0haQY1TEtYJvwamzcAoRx28sdSZ8YUL/tARjw0TOLfXvE
         KuzMPTGtH0ZdkXXDaLR3SDFxGY/913jVo8ViS+Kdb8DVqmqUuKkMEQWTivoV3I3Xt46y
         2qn8iv31U1Qc2NVxfRvg7mlLR+InYxwytfSXJH2eyoEi6SUT28xh1LsRALk+sJx0o578
         wTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z+l2SJlxwdbSAeCvbGCXrANrMH1wFyQWwIwcm1pjtOc=;
        b=X23IR+MolW2vttpsuyOMcvfD7zmzzDs++ZjU19w7aznpa/v0JrVmTqh94s0QHTvRr4
         0SuhNsA2FhHfZH1MrI3Tp0E0/fxvqWoKrwsr07HxM/lUfznGLkTED6qC2Z8rByQ4GvqZ
         7FBD64zikyDPGhjdVx8a5iuhKth7gPAdFfeNoOk2KDjj5lxoa2eXaAr5dZYxe/fs0ztX
         PwcPizHBurk2kMyTsE1XyN8I8n/kk5ql9M0EBj+D1idpIPeeyNjRvAeheI/Ijy+tgQ8d
         s+k6O2sxOpYctVMEnlsRMaYEJzmbdfdNHOBYkO9VzHlmr9RARcXP9MJIc2StceeDSfVK
         ANNw==
X-Gm-Message-State: AOAM5336j+AmVFCXz/Wlp/2hvW2V/EJWYAZw38eCEZRfdxBZ5R6ymc7Z
        1yPAPQEXcPeJAEAGn3EZZZ4=
X-Google-Smtp-Source: ABdhPJxP9xFEYNyePNazFXlEVaWP1HSQ84aDSR/HnYH3YOSvCQMEtWfyCzfyqtGx14wv2IxeIriI8Q==
X-Received: by 2002:a5d:54c7:: with SMTP id x7mr22768920wrv.162.1591098884594;
        Tue, 02 Jun 2020 04:54:44 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host9-254-dynamic.3-87-r.retail.telecomitalia.it. [87.3.254.9])
        by smtp.googlemail.com with ESMTPSA id b18sm3273777wrn.88.2020.06.02.04.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 04:54:44 -0700 (PDT)
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
Subject: [PATCH v5 08/11] PCI: qcom: Add support for tx term offset for rev 2.1.0
Date:   Tue,  2 Jun 2020 13:53:49 +0200
Message-Id: <20200602115353.20143-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200602115353.20143-1-ansuelsmth@gmail.com>
References: <20200602115353.20143-1-ansuelsmth@gmail.com>
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
 drivers/pci/controller/dwc/pcie-qcom.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index f5398b0d270c..2cd6d1456210 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -45,6 +45,9 @@
 #define PCIE_CAP_CPL_TIMEOUT_DISABLE		0x10
 
 #define PCIE20_PARF_PHY_CTRL			0x40
+#define PHY_CTRL_PHY_TX0_TERM_OFFSET_MASK	GENMASK(20, 16)
+#define PHY_CTRL_PHY_TX0_TERM_OFFSET(x)		((x) << 16)
+
 #define PCIE20_PARF_PHY_REFCLK			0x4C
 #define PHY_REFCLK_SSP_EN			BIT(16)
 #define PHY_REFCLK_USE_PAD			BIT(12)
@@ -374,9 +377,18 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
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

