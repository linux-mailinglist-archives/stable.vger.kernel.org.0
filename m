Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57076D5AC2
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 10:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbjDDIZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 04:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbjDDIZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 04:25:10 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8251BFB;
        Tue,  4 Apr 2023 01:25:09 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id cn12so127311846edb.4;
        Tue, 04 Apr 2023 01:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680596708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1KieLp2SnNCkcNVzhL5on0X9p6T2oILFqI3zJbVKVE0=;
        b=DfuQveiBa0LxS77gl+Rl1CWKORlrqkFw6RqoDjxce+ccxFFAs9L/hPnx7e5uk1tznA
         WmvqfJPHWR3TvxPic7IcX1TvoymUXUygNdM4itenRL5bWRclKqs7gTWUt3dqs84EI52s
         0UjpYft+7w6xENZfZaH8dq/ktQuJC1cQP37tabVSoDUQ8LbJGanwPWIu29Qs7kAccR5f
         6O/LajzOKeNpPVcn/a4KOcZQNAkZq2oAaX5RVvSdLfyrsFPP+r5CSljYvt9yI6y0EdvL
         2s3p3FrPikJ4Cjj3meQimnQjIDw3dpfVnX8uzdBKKrx3XtL6UZJSyeOGmQ87lo7G058w
         OgBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680596708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1KieLp2SnNCkcNVzhL5on0X9p6T2oILFqI3zJbVKVE0=;
        b=Dfzy25QPmhQDYDmrQpTknl4K4/cBWULefAMF1FOxeduiIlJkEkgxd7ac6PTVsZ+SIq
         fX9citpbvk+AJo/C/KB59xp27wyTj8y1p/Hhc6ZGzizfPsm2JhdQd7c8y3s8CxH1uxcy
         mi39uZzFuqXl3YNZ5MZ1Zibbern3ba3HF61zoyhK3jcgmS/VlrlZvUBviVQ1SLkpiXqo
         AhbKYFP2MTKw1gXXgl3EzK/Ii5rC0VdTH8C1hd8/f5gYPSKYJbNKf3kMYCquqNyV8MxU
         5RvfpS9N6fQYzi329F0rqv0oqqLkkowceICktodr4MQRcR9JDoQYlxPf7FQtlmmVpGFp
         zzCA==
X-Gm-Message-State: AAQBX9fX+1nLscflIUV6lD4yK3iOd21beUpdVuiUPBfwPb2SgPEc3Cmt
        xl2QnBDEoew4hrPY1lwNcag=
X-Google-Smtp-Source: AKy350YOQwqlb1+ARj72z2o90Q5PEeI1B0Q03zcNEyWeTwo7YTYxTPKGar1Kccq2New8JxSwG4BZhQ==
X-Received: by 2002:a17:906:3b95:b0:926:8f9:735c with SMTP id u21-20020a1709063b9500b0092608f9735cmr1784857ejf.32.1680596708617;
        Tue, 04 Apr 2023 01:25:08 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id s5-20020a170906454500b008e54ac90de1sm5640652ejq.74.2023.04.04.01.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 01:25:08 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     damien.lemoal@opensource.wdc.com, xxm@rock-chips.com,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Johan Jonker <jbx6244@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Caleb Connolly <kc@postmarketos.org>,
        Lin Huang <hl@rock-chips.com>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/11] PCI: rockchip: Add poll and timeout to wait for PHY PLLs to be locked
Date:   Tue,  4 Apr 2023 10:24:17 +0200
Message-Id: <20230404082426.3880812-5-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230404082426.3880812-1-rick.wertenbroek@gmail.com>
References: <20230404082426.3880812-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The RK3399 PCIe controller should wait until the PHY PLLs are locked.
Add poll and timeout to wait for PHY PLLs to be locked. If they cannot
be locked generate error message and jump to error handler. Accessing
registers in the PHY clock domain when PLLs are not locked causes hang
The PHY PLLs status is checked through a side channel register.
This is documented in the TRM section 17.5.8.1 "PCIe Initialization
Sequence".

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/pci/controller/pcie-rockchip.c | 17 +++++++++++++++++
 drivers/pci/controller/pcie-rockchip.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip.c b/drivers/pci/controller/pcie-rockchip.c
index 990a00e08bc5..1aa84035a8bc 100644
--- a/drivers/pci/controller/pcie-rockchip.c
+++ b/drivers/pci/controller/pcie-rockchip.c
@@ -14,6 +14,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
+#include <linux/iopoll.h>
 #include <linux/of_pci.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
@@ -153,6 +154,12 @@ int rockchip_pcie_parse_dt(struct rockchip_pcie *rockchip)
 }
 EXPORT_SYMBOL_GPL(rockchip_pcie_parse_dt);
 
+#define rockchip_pcie_read_addr(addr) rockchip_pcie_read(rockchip, addr)
+/* 100 ms max wait time for PHY PLLs to lock */
+#define RK_PHY_PLL_LOCK_TIMEOUT_US 100000
+/* Sleep should be less than 20ms */
+#define RK_PHY_PLL_LOCK_SLEEP_US 1000
+
 int rockchip_pcie_init_port(struct rockchip_pcie *rockchip)
 {
 	struct device *dev = rockchip->dev;
@@ -254,6 +261,16 @@ int rockchip_pcie_init_port(struct rockchip_pcie *rockchip)
 		}
 	}
 
+	err = readx_poll_timeout(rockchip_pcie_read_addr,
+				 PCIE_CLIENT_SIDE_BAND_STATUS,
+				 regs, !(regs & PCIE_CLIENT_PHY_ST),
+				 RK_PHY_PLL_LOCK_SLEEP_US,
+				 RK_PHY_PLL_LOCK_TIMEOUT_US);
+	if (err) {
+		dev_err(dev, "PHY PLLs could not lock, %d\n", err);
+		goto err_power_off_phy;
+	}
+
 	/*
 	 * Please don't reorder the deassert sequence of the following
 	 * four reset pins.
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index 51a123e5c0cf..f3a5ff1cf7f4 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -38,6 +38,8 @@
 #define   PCIE_CLIENT_MODE_EP            HIWORD_UPDATE(0x0040, 0)
 #define   PCIE_CLIENT_GEN_SEL_1		  HIWORD_UPDATE(0x0080, 0)
 #define   PCIE_CLIENT_GEN_SEL_2		  HIWORD_UPDATE_BIT(0x0080)
+#define PCIE_CLIENT_SIDE_BAND_STATUS	(PCIE_CLIENT_BASE + 0x20)
+#define   PCIE_CLIENT_PHY_ST			BIT(12)
 #define PCIE_CLIENT_DEBUG_OUT_0		(PCIE_CLIENT_BASE + 0x3c)
 #define   PCIE_CLIENT_DEBUG_LTSSM_MASK		GENMASK(5, 0)
 #define   PCIE_CLIENT_DEBUG_LTSSM_L1		0x18
-- 
2.25.1

