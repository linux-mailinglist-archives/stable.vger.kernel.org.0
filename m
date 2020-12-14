Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2A12D9CA2
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 17:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440244AbgLNQ1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 11:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440241AbgLNQ07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 11:26:59 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76272C0613D3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 08:26:19 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r7so17030739wrc.5
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 08:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xKWvkxf6M0uNMyHpbbSegr0X/MG9V3Xktheqwtr3eyE=;
        b=KwBM4+m6kp9Y3+4Sdhxkq0ngDTTboV4oex2z3MhggnRjEBiqrCGZYvkLqsTwZGopAU
         XoP4BhQUPaAtMGlFCwMgbeU1UUpHl2+3ek1llzr04lFToLkM3sLx6FeEl3Vc98TPe5Qs
         YxtsM9q5SK7LJTwkHcnrHvq+iiAcrheGw1648nu9svG8jD8vMmlfQ3CihcfvPtA4vOx9
         qb2b2VMfXhl8gq2w6CTEWWGmjq+LP8MGX/i8hLlU6gMnwTjWtbLWHqUXJOTSM5ttauPU
         s1V1DGsl4ORMtw9X1w4xtSmhe2SJpcDoBDxiaYjJy/irQucadMkUACezifl9xmBs4OOa
         9jBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xKWvkxf6M0uNMyHpbbSegr0X/MG9V3Xktheqwtr3eyE=;
        b=TwMbgaUtbuEz9E+udvdDY//VA6+bCPrzY7hKAccOb0xuyMYhCsQaJrvs5iopAFUHEg
         NsGQwLtK2z472xmN/MPHZDXwl6CohVjI5t3FQcl0I1g9voFrPynLbB80H2AcErALkPi9
         0rzXIMs196dusOBkOVY2kO+hdMgqLYd2sCJZGKkG2OrYz7bev6G8uvf5xRDYanZyr+ZN
         F9XEZWm7cQo0fCyWr7xE2WQ25uLAxZpI+Jb3MPfl+zhmiSIv4ZPL0h9UzOPeirOJ2JMm
         rm8TV8AMVAZWfE+TdQ1fy7YXp00aXkzxrrFv4P9PInPX4vPKIOMXZBB0CG0Om3bFqrvP
         7rAA==
X-Gm-Message-State: AOAM53184z5fTITusxOAN78E05M0Tv+eNWJGWp1761v2dUw7P0kBp4FI
        odFmjYTHDtRkT39wMqswh4E=
X-Google-Smtp-Source: ABdhPJxWHwqInn4xM8gSc8ntavfYo+9Jtt/UfIdfE9YSjuorZJhO1RRHYcF8MlMWYAAPoTkJkUjhOQ==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr29546889wrn.322.1607963178276;
        Mon, 14 Dec 2020 08:26:18 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id f7sm35045701wmc.1.2020.12.14.08.26.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 08:26:17 -0800 (PST)
Date:   Mon, 14 Dec 2020 16:26:15 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ansuelsmth@gmail.com, lorenzo.pieralisi@arm.com,
        p.zabel@pengutronix.de, robh@kernel.org, smuthayy@codeaurora.org,
        svarbanov@mm-sol.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: qcom: Add missing reset for ipq806x"
 failed to apply to 4.19-stable tree
Message-ID: <20201214162615.pes4lzpib4et3544@debian>
References: <159783260710161@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="knpidmqpsgkxdrzd"
Content-Disposition: inline
In-Reply-To: <159783260710161@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--knpidmqpsgkxdrzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Aug 19, 2020 at 12:23:27PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--knpidmqpsgkxdrzd
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-PCI-qcom-Add-missing-reset-for-ipq806x.patch"

From f3d5bb8cc9d5331355a794460a975a04978fd2a9 Mon Sep 17 00:00:00 2001
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 1bdac298a943..791d6b671ee0 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -108,6 +108,7 @@ struct qcom_pcie_resources_2_1_0 {
 	struct reset_control *ahb_reset;
 	struct reset_control *por_reset;
 	struct reset_control *phy_reset;
+	struct reset_control *ext_reset;
 	struct regulator_bulk_data supplies[QCOM_PCIE_2_1_0_MAX_SUPPLY];
 };
 
@@ -269,6 +270,10 @@ static int qcom_pcie_get_resources_2_1_0(struct qcom_pcie *pcie)
 	if (IS_ERR(res->por_reset))
 		return PTR_ERR(res->por_reset);
 
+	res->ext_reset = devm_reset_control_get_optional_exclusive(dev, "ext");
+	if (IS_ERR(res->ext_reset))
+		return PTR_ERR(res->ext_reset);
+
 	res->phy_reset = devm_reset_control_get_exclusive(dev, "phy");
 	return PTR_ERR_OR_ZERO(res->phy_reset);
 }
@@ -281,6 +286,7 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
 	reset_control_assert(res->axi_reset);
 	reset_control_assert(res->ahb_reset);
 	reset_control_assert(res->por_reset);
+	reset_control_assert(res->ext_reset);
 	reset_control_assert(res->pci_reset);
 	clk_disable_unprepare(res->iface_clk);
 	clk_disable_unprepare(res->core_clk);
@@ -333,6 +339,12 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
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


--knpidmqpsgkxdrzd--
