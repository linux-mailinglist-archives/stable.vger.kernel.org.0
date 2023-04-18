Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ED96E5AF0
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 09:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjDRHtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 03:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjDRHsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 03:48:24 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432256A47;
        Tue, 18 Apr 2023 00:48:16 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dm2so70934571ejc.8;
        Tue, 18 Apr 2023 00:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681804096; x=1684396096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1lVyO1SYBMr6W0537PjqdrmuSbOOyZSR3u+HScE/D6o=;
        b=qUu7XSNfCvyBIn1vxrIKZuYJaBFIFsyIPsyLSjwO2FHMbpXn3KFltwfhqhw+rMCtTI
         nrxLIOCzuunVLK/TAqeCH46lLv5VDGWZsap+Wy+KtM+et7vjOX2HAyUjmEfNppDE01WZ
         ZP3vSDnN5wTYZLcMbx153kWX/PEBy3WOGDS6DznA5iVtqobXisucqH+9qg1+0xI7/X5c
         xwcI0SGjLTQWxCyPRrV1RstIVmJs58lIn2eNVqrX6Sn2gXXYcQlOoVTxGSynUKe2Ovp1
         gn+Q6tPxxsxJrcnk1aDX5YRmmPtftprF2uGe8JwshKqh7SDcq7hoCBdhxNFCQkX04IRR
         +/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681804096; x=1684396096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1lVyO1SYBMr6W0537PjqdrmuSbOOyZSR3u+HScE/D6o=;
        b=cqrHCSQz6CI4LBCiSg2Y3okrgsNtMM/xI0sZJILSb8T95PS1DT1gFbF55azIDOLL7Y
         fwN8BOhtpjDeXAWY46LEGvc0rdnhzliebj0mb3E+8jlTJkRX195//zqKKgZRNk0hy0Xm
         L8KJAlDkaQulgErA10xfNK8daJcJn2Lhp4brYnylcwXz1Vu8UtR1Ce2rCWTyZwLRFwh0
         t0RAVUQEUVCeq1PNub3SymYX9aCi6eGmm+AeQgdCoB1cHGMx3IUMmO0750I45K81s/TB
         iEm1uoGXHv6ZLCLeVt7mEi86au4TvAm6axKia8S025w+vdtyQ7Z4O1TwSCOsV1l/lTpy
         ibIg==
X-Gm-Message-State: AAQBX9ctefUGMecvhYsl3UUv9Tmp9OI7S/9vBkhQ3v0cvf0TYCIbEvVq
        wo0GcLJCLTjI/uviyRlzX5g=
X-Google-Smtp-Source: AKy350ajUWbsomQPoHsGOHcaodVySW3+FMBrhALdcwTdkwGPZi4aqkNlY9auHqUYa4foHg3CgZ6N8w==
X-Received: by 2002:a17:906:b190:b0:94a:5911:b475 with SMTP id w16-20020a170906b19000b0094a5911b475mr11751268ejy.52.1681804095474;
        Tue, 18 Apr 2023 00:48:15 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id gs8-20020a1709072d0800b0094f694e4ecbsm3048545ejc.146.2023.04.18.00.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 00:48:15 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, dlemoal@kernel.org, stable@vger.kernel.org,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Corentin Labbe <clabbe@baylibre.com>,
        Caleb Connolly <kc@postmarketos.org>,
        Brian Norris <briannorris@chromium.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 11/11] PCI: rockchip: Set address alignment for endpoint mode
Date:   Tue, 18 Apr 2023 09:46:58 +0200
Message-Id: <20230418074700.1083505-12-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418074700.1083505-1-rick.wertenbroek@gmail.com>
References: <20230418074700.1083505-1-rick.wertenbroek@gmail.com>
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

From: Damien Le Moal <dlemoal@kernel.org>

The address translation unit of the rockchip EP controller does not use
the lower 8 bits of a PCIe-space address to map local memory. Thus we
must set the align feature field to 256 to let the user know about this
constraint.

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index edfced311a9f..0af0e965fb57 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -442,6 +442,7 @@ static const struct pci_epc_features rockchip_pcie_epc_features = {
 	.linkup_notifier = false,
 	.msi_capable = true,
 	.msix_capable = false,
+	.align = 256,
 };
 
 static const struct pci_epc_features*
-- 
2.25.1

