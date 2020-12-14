Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AEF2D9CA6
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 17:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgLNQ1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 11:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439874AbgLNQ1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 11:27:50 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE62C0613D3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 08:27:09 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id e25so15821523wme.0
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 08:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i4uX+vBWuFlq5QIU0xx8imFS0+I7nNCYUdqltoQpQRE=;
        b=P7X/BEB1WN9a+Q2eI62CRNkqX2MC1PZcCmuh2WoGnEbwGzAYXsY3sncJFeK5Nr22Ou
         eCdSMFvDiUPodJ5o1nUBiLP7+Ng5fEfvY2umG2D7yQB8DqOtvJ/vVhDrnITRHIu7rz4R
         dQ0xPsdBB+sOIWAkfiQ8vunsiqlAiK+ciFIV09LU+nLp8zOaMxhEWm4LJnr7TLKCOKoJ
         ADJa1YqqRoW1v5boQN5swuYYqq9a2ih26D4EFvrURhvxSpiUf8oJiB5RqFgyal8k8nSP
         EWuFoHNzhStVfTgXQfn4/Q0RpSgNGP736SKx7NpphBHdU7dpWaDiZ9yhpwQ0AoIjBJlT
         NpKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i4uX+vBWuFlq5QIU0xx8imFS0+I7nNCYUdqltoQpQRE=;
        b=A+GTEpsMseT31EGuL5X9Kwd8knojEZtBBUfRvdZahngouQcS4IW0cJ2uEaFeXeLg2x
         NbsUm6+HCK+gv5fTiAqlIWf2OJiASUfptb32eG9P+n2G2aXrkIkQkA347TOe8D9VhkAM
         /o79iZLspQZ7E/JL0UzyzSQNdGgjonG0c6RSUIty6lGz30Dp7HP0QOUm2DszFzKLXzCT
         UW2wG4/+F1Qa4ihTVlqJ0yXGxpFqXrBx6WD7YjraididbP5qskkM/G7Y0J8ZQ+WDLzjG
         9APpmgHZT3VWDNfswwvJjsd2EZXSWGHR/g95oI3GnrE6cDcpavYMG+CdbGJH6jLUMIwo
         rgMg==
X-Gm-Message-State: AOAM5316Pao8wiXJeRYfVe5DNc9E9xYihWd3GVMDNddtUfLP4N4WFu2R
        SWSSpM9ailUfvsxuao+y9mM=
X-Google-Smtp-Source: ABdhPJzaZE+U662/cIHgz2uNQc9II6jKuXgKrqNIbfMOq+T8JqdceUW7OQoHa13eIRTqz5ufXtQWBg==
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr28966468wmj.168.1607963228572;
        Mon, 14 Dec 2020 08:27:08 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id w8sm9722964wrl.91.2020.12.14.08.27.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 08:27:08 -0800 (PST)
Date:   Mon, 14 Dec 2020 16:27:06 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ansuelsmth@gmail.com, lorenzo.pieralisi@arm.com,
        p.zabel@pengutronix.de, robh@kernel.org, smuthayy@codeaurora.org,
        svarbanov@mm-sol.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: qcom: Add missing reset for ipq806x"
 failed to apply to 4.14-stable tree
Message-ID: <20201214162706.irbocuetsvmq3sb3@debian>
References: <159783260833162@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fqfffr6ut6lirpmz"
Content-Disposition: inline
In-Reply-To: <159783260833162@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fqfffr6ut6lirpmz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Aug 19, 2020 at 12:23:28PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--fqfffr6ut6lirpmz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-PCI-qcom-Add-missing-reset-for-ipq806x.patch"

From 99b3d2739ac9bf775284136755b41da4e0c9b2b9 Mon Sep 17 00:00:00 2001
From: Ansuel Smith <ansuelsmth@gmail.com>
Date: Mon, 15 Jun 2020 23:06:00 +0200
Subject: [PATCH] PCI: qcom: Add missing reset for ipq806x

commit ee367e2cdd2202b5714982739e684543cd2cee0e upstream

Add missing ext reset used by ipq8064 SoC in PCIe qcom driver.

Link: https://lore.kernel.org/r/20200615210608.21469-5-ansuelsmth@gmail.com
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org # v4.5+
[sudip: manual backport]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/pci/dwc/pcie-qcom.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/dwc/pcie-qcom.c b/drivers/pci/dwc/pcie-qcom.c
index ce7ba5b7552a..b84603f52dc1 100644
--- a/drivers/pci/dwc/pcie-qcom.c
+++ b/drivers/pci/dwc/pcie-qcom.c
@@ -96,6 +96,7 @@ struct qcom_pcie_resources_2_1_0 {
 	struct reset_control *ahb_reset;
 	struct reset_control *por_reset;
 	struct reset_control *phy_reset;
+	struct reset_control *ext_reset;
 	struct regulator *vdda;
 	struct regulator *vdda_phy;
 	struct regulator *vdda_refclk;
@@ -265,6 +266,10 @@ static int qcom_pcie_get_resources_2_1_0(struct qcom_pcie *pcie)
 	if (IS_ERR(res->por_reset))
 		return PTR_ERR(res->por_reset);
 
+	res->ext_reset = devm_reset_control_get_optional_exclusive(dev, "ext");
+	if (IS_ERR(res->ext_reset))
+		return PTR_ERR(res->ext_reset);
+
 	res->phy_reset = devm_reset_control_get_exclusive(dev, "phy");
 	return PTR_ERR_OR_ZERO(res->phy_reset);
 }
@@ -277,6 +282,7 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
 	reset_control_assert(res->axi_reset);
 	reset_control_assert(res->ahb_reset);
 	reset_control_assert(res->por_reset);
+	reset_control_assert(res->ext_reset);
 	reset_control_assert(res->pci_reset);
 	clk_disable_unprepare(res->iface_clk);
 	clk_disable_unprepare(res->core_clk);
@@ -342,6 +348,12 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
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
2.11.0


--fqfffr6ut6lirpmz--
