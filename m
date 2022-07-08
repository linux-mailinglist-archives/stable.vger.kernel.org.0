Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE71356C2FC
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiGHW2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 18:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239372AbiGHW2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 18:28:12 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E99113B458;
        Fri,  8 Jul 2022 15:28:10 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v16so83507wrd.13;
        Fri, 08 Jul 2022 15:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EIKl0L/6XyzwPBWrn8iMPtQb4hMXI8B9L0xH/4E3HCY=;
        b=MgDq5RMsQmJt9tw/jQx7WxD1GQkperIilUkq33xlccftDqAO0jIIoVfCwEGcNyijdE
         BsAMfGSutmB9peyEQZf+hcJzgO5sYT3Khxte88s1AStzx5SX0+znI7sH7hScQRu9SH1y
         kNOAHEMN6LvqjYrUofYrgZCwhZtbJ27oD20w+O3FXL6jvATCOwJWdTUp+h3YExNK/k+X
         QzsCqjHPLj8T/qQVJY2HN0Bc3a3dP5e5ey4NJy1U3zNbvzgTn88S/0nD8GXs9fcSAppk
         s+/tpJEfRGtEpkg3LuFr+UeYqL8IFKYqogUaaIM49gVl8rACQj8BV19rHLVRFVqAdN/e
         5+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EIKl0L/6XyzwPBWrn8iMPtQb4hMXI8B9L0xH/4E3HCY=;
        b=eoc6cQOtLuR4bkQpDSQqAz9baH+qoGePJzbukhd11VFA8I1+atwBZyCCUhKmDaTe9O
         fM9hGcpZoXlbpT3n+SxgRxLoTO06l08CcE94nyKn5JTsGkX1XxJVqjsJCKTED4s/PKkP
         4mLDBVRKF/CgwWF55rTNLPGgRNmi0tZb6BSDg3LrMUiCs/wzH1FciH7krhpXkeuvoISx
         RHQr7amF49A+UjZLRweU0Wwwn5YNfDuQDwrSkc0eSuhZZ73RzpLQFX6dxDX1iFiI+XLv
         wYm9aHBEWCabb8rpWEkxvLPBbd04M451gGG2mF3zzv7lndNkT+L2SAPJWdGwpamvdG5k
         NwOw==
X-Gm-Message-State: AJIora9P7qvBmYV/RArRnXQSNteZc/sHhavy/iVXUWOtWzjcUa6xc0gH
        +B2uQsdfOByPS8w9p/gnyNqBChuofKc=
X-Google-Smtp-Source: AGRyM1sy7iGlWXrLjM6rZEjw7qCKnbPfNyNZ37jI2gkj9+26YLYamSTZGZEsORMFjUilPbc+4UGxQw==
X-Received: by 2002:a05:6000:114e:b0:21d:6cd1:695d with SMTP id d14-20020a056000114e00b0021d6cd1695dmr5386806wrx.474.1657319288365;
        Fri, 08 Jul 2022 15:28:08 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id e36-20020a05600c4ba400b0039c54bb28f2sm3031596wmp.36.2022.07.08.15.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 15:28:07 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] PCI: qcom: Enable clocks only after PARF_PHY setup for rev 2.1.0
Date:   Sat,  9 Jul 2022 00:27:43 +0200
Message-Id: <20220708222743.27019-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We currently enable clocks BEFORE we write to PARF_PHY_CTRL reg to
enable clocks and resets. This case the driver to never set to a ready
state with the error 'Phy link never came up'.

This in fact is caused by the phy clock getting enabled before setting
the required bits in the PARF regs.

A workaround for this was set but with this new discovery we can drop
the workaround and use a proper solution to the problem by just enabling
the clock only AFTER the PARF_PHY_CTRL bit is set.

This correctly setup the pcie line and makes it usable even when a
bootloader leave the pcie line to a underfined state.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 2ea13750b492..da13a66ced14 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -337,8 +337,6 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	reset_control_assert(res->ext_reset);
 	reset_control_assert(res->phy_reset);
 
-	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
-
 	ret = regulator_bulk_enable(ARRAY_SIZE(res->supplies), res->supplies);
 	if (ret < 0) {
 		dev_err(dev, "cannot enable regulators\n");
@@ -381,15 +379,15 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		goto err_deassert_axi;
 	}
 
-	ret = clk_bulk_prepare_enable(ARRAY_SIZE(res->clks), res->clks);
-	if (ret)
-		goto err_clks;
-
 	/* enable PCIe clocks and resets */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_CTRL);
 	val &= ~BIT(0);
 	writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
 
+	ret = clk_bulk_prepare_enable(ARRAY_SIZE(res->clks), res->clks);
+	if (ret)
+		goto err_clks;
+
 	if (of_device_is_compatible(node, "qcom,pcie-ipq8064") ||
 	    of_device_is_compatible(node, "qcom,pcie-ipq8064-v2")) {
 		writel(PCS_DEEMPH_TX_DEEMPH_GEN1(24) |
-- 
2.36.1

