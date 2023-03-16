Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8F36BC85F
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 09:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjCPILo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 04:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjCPILm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 04:11:42 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B394BB32AF
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 01:11:36 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s8so503882pfk.5
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 01:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678954296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vS8hfidRbkXx+WU7nlobVXwnuTS8kKT/thUC53f5Tfk=;
        b=Nnjn8PYmWqQ++sIgye0d2wCU3iwsPG03PgdfrKKyKHByELD3UZf8s8f1ysJWQDyuVS
         M1x8JKxAyJHdPpAslaBfS4meLs8ekxASJxhX3+XEhqF/gUwIOjQT48wbMGIu1ZSZLXGL
         RbsHnz9Kife58jkPXM2UYlyyQ9yKfbuuuHWW2atRy8i5m6rjZtjlHEPqcFw8pwiT+UP4
         LpFKQZL3p8NT2U2bgRpuumcU7RGiN93T4VjFSyEqzaxRlZ7YVu9xn3SZmH5p3p9IkDSu
         PiJakb5Dy9OU/+j/BefeJ8IHCqHOTlhB4aLV2b4wTD+vHzg+J7zBaQmMgBgIpaRtRSDo
         uvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678954296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vS8hfidRbkXx+WU7nlobVXwnuTS8kKT/thUC53f5Tfk=;
        b=h37Cv+IoIKhd3npWMwmlJUJV568HvB67/Pb5zIixkxN4vfsVcDXlFA1B3syXXuMy0w
         KB+eb14UfI0E09pFjmfw7QIUou1zmOnornJADgdYK0H+Ch4hfinUE/0QlwMR+v3UzU9h
         2KsKXAW/fkimf1fV8XDf141yn1wVv9RaPpW8zKmTYFDERPwUDf+S1Rl64tDCswZmRGdE
         miIl/AwImU8l21s0sQS4QeuZH0Pb5/9MpyuSE+opYSGQ2qZEiboSd+g/R0qck+ast9ab
         GOYLst05kEPjlzn4Ff5tgjM09vBJdrljjUnZO/p3y+RRnDaps7mNcrWuaIywoZzyq/Zn
         I2kQ==
X-Gm-Message-State: AO0yUKVvSuOLosIoV3BetO5/wAJcE+GD71De5XRNdxDKlTRe0VZBAkDg
        9PeJfuk5ssTHoSQB6vHJyl3T
X-Google-Smtp-Source: AK7set+s31rDEyaboCcssiS3+KoVpXo2emMr7Dufg9T5IRC/CnuQpBl7ucPbwnqoYEW/Zm610zXCng==
X-Received: by 2002:a62:1b12:0:b0:626:444:bfa6 with SMTP id b18-20020a621b12000000b006260444bfa6mr125095pfb.26.1678954296213;
        Thu, 16 Mar 2023 01:11:36 -0700 (PDT)
Received: from localhost.localdomain ([117.207.30.24])
        by smtp.gmail.com with ESMTPSA id 13-20020aa7910d000000b005d9984a947bsm4804422pfh.139.2023.03.16.01.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 01:11:35 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, lpieralisi@kernel.org, kw@linux.com,
        krzysztof.kozlowski+dt@linaro.org, robh@kernel.org
Cc:     konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_srichara@quicinc.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v5 01/19] PCI: qcom: Fix the incorrect register usage in v2.7.0 config
Date:   Thu, 16 Mar 2023 13:40:59 +0530
Message-Id: <20230316081117.14288-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230316081117.14288-1-manivannan.sadhasivam@linaro.org>
References: <20230316081117.14288-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Qcom PCIe IP version v2.7.0 and its derivatives don't contain the
PCIE20_PARF_AXI_MSTR_WR_ADDR_HALT register. Instead, they have the new
PCIE20_PARF_AXI_MSTR_WR_ADDR_HALT_V2 register. So fix the incorrect
register usage which is modifying a different register.

Also in this IP version, this register change doesn't depend on MSI
being enabled. So remove that check also.

Cc: <stable@vger.kernel.org> # 5.6+
Fixes: ed8cc3b1fc84 ("PCI: qcom: Add support for SDM845 PCIe controller")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index a232b04af048..89d748cc4b8a 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1279,11 +1279,9 @@ static int qcom_pcie_init_2_7_0(struct qcom_pcie *pcie)
 	val &= ~REQ_NOT_ENTR_L1;
 	writel(val, pcie->parf + PCIE20_PARF_PM_CTRL);
 
-	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		val = readl(pcie->parf + PCIE20_PARF_AXI_MSTR_WR_ADDR_HALT);
-		val |= BIT(31);
-		writel(val, pcie->parf + PCIE20_PARF_AXI_MSTR_WR_ADDR_HALT);
-	}
+	val = readl(pcie->parf + PCIE20_PARF_AXI_MSTR_WR_ADDR_HALT_V2);
+	val |= BIT(31);
+	writel(val, pcie->parf + PCIE20_PARF_AXI_MSTR_WR_ADDR_HALT_V2);
 
 	return 0;
 err_disable_clocks:
-- 
2.25.1

