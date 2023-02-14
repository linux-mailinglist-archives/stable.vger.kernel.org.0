Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333B669660F
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbjBNOK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbjBNOKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:10:46 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053452A154;
        Tue, 14 Feb 2023 06:10:15 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id k16so8836516ejv.10;
        Tue, 14 Feb 2023 06:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wlhNVngokcMAaPIU9YsiNMvp+CICZXJFUIQaHO3ObSo=;
        b=HS6vt8v8FJ4bXQy/YZe5flTG49HKxTKB1pLjucGq+lUFeWZcdClLvjWzIVJvSplQVI
         7PA2I2gzFZ4I0F6hJT27YGypLzagHMBp6I7feTyiKmoeUhRjWEL4VRBZeKUce/SwMUle
         4D7qF0ZesQzsGxkkgbZQ1ta1kNx2nrkHfDwy7I9+F0ofKMaqK16t+3LoUNBrde/NjyQs
         az5U6ZZE8zHE8HizqQGScI2J+SMjKIiZTGtRITqAPDzyv3N7ZtU5S0+MLaHQpDz8FZYZ
         LF4qHa6oV1SUR/cJmfSs6pQergQrwvDGFJ4hT4mzztx43dwNnHH25Piw+wMcBWyYpzez
         wxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlhNVngokcMAaPIU9YsiNMvp+CICZXJFUIQaHO3ObSo=;
        b=si3WTI3S0YLluzbVdDJoqeWZjGnUo1dAFhczgCZLdaRh3Qzgb75T+9gXHCKjfL36qU
         49WvXgLlbeJw8UWdohnY1ntqRjcG9Yb/DzvukcBEAT0eQxwLxBf/MLdI43MSSwwVcw3u
         TdhpYWWW3K7KB3WOdNvHE/kS58CoUBWLDu6/lEThcIuTwlEq+LP2cbPX1ypKyuV1HBPW
         A4LQwcjCTu2yZ+cNg7bWshLCK2xA1U6zxhtYKtayVS3zsPPaBzig2UW0Xo2JWpY0sUxa
         OwBQNaHnbaj0tGaYQfOZSrCI+cq3C65mXge/Gm9dt1I+7TdMWDQiLWVkbluDsfh+6Q2t
         VTzA==
X-Gm-Message-State: AO0yUKVCbJ2AbZWmG1YxptJjZPPZFwza7DJBzZjb1FmllFggHB1XZrGk
        7ZBhxU3w9JXpftakqQyRiKUxc49AZ66p8Q==
X-Google-Smtp-Source: AK7set8O61hFgKTFZuDfgH32RN6jBC0eEFWlPfzOZWQPCNksB1GIDJF//jlppO0Izpan8+U5ZnXmQw==
X-Received: by 2002:a17:906:5512:b0:8aa:c0d6:2dc6 with SMTP id r18-20020a170906551200b008aac0d62dc6mr3098791ejp.29.1676383803683;
        Tue, 14 Feb 2023 06:10:03 -0800 (PST)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id n11-20020a1709065e0b00b008b13814f804sm332241eju.186.2023.02.14.06.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:10:03 -0800 (PST)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, rick.wertenbroek@heig-vd.ch,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 4/9] PCI: rockchip: Add poll and timeout to wait for PHY PLLs to be locked
Date:   Tue, 14 Feb 2023 15:08:52 +0100
Message-Id: <20230214140858.1133292-5-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 drivers/pci/controller/pcie-rockchip.c | 16 ++++++++++++++++
 drivers/pci/controller/pcie-rockchip.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip.c b/drivers/pci/controller/pcie-rockchip.c
index 990a00e08..5f2e2dd5d 100644
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
@@ -254,6 +261,15 @@ int rockchip_pcie_init_port(struct rockchip_pcie *rockchip)
 		}
 	}
 
+	err = readx_poll_timeout(rockchip_pcie_read_addr, PCIE_CLIENT_SIDE_BAND_STATUS,
+		regs, !(regs & PCIE_CLIENT_PHY_ST), RK_PHY_PLL_LOCK_SLEEP_US,
+		RK_PHY_PLL_LOCK_TIMEOUT_US);
+
+	if (err) {
+		dev_err(dev, "PHY PLLs could not lock, %d\n", err);
+		goto err_power_off_phy;
+	}
+
 	/*
 	 * Please don't reorder the deassert sequence of the following
 	 * four reset pins.
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index 51a123e5c..f3a5ff1cf 100644
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

