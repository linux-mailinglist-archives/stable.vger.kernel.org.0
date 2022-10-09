Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1805F9086
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiJIWZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiJIWX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:23:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0953C164;
        Sun,  9 Oct 2022 15:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C10D7B80DE2;
        Sun,  9 Oct 2022 22:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A843AC433C1;
        Sun,  9 Oct 2022 22:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353648;
        bh=6I0oFww5l0V1IzzU+8y7drAJe30wzaT6tIKTcnOoUOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyAlKiCw+0n3cmNf5R9fMhwW89zySgAAwKzrzbD+I+/jadNa6BN+mmMZDgEiABfL5
         607EQ48RhMxrOaqAYKFvbQFoas4LH+gJmNMjuKG3LuC9BdugWbzQkD7gtwnlhh6V5C
         Vp0DIyavOl3aexUoJWKUFfBy5NCA4CroYLAKCbeZeutLJLC48F/T13u4MCsEs2PQN8
         ZAlFMuvCst+8YdfUnJ6SNdR9aZQsok6ZJgplZHzVLS6Tn8vo0xhbDVX1GiE3MrZYXz
         3U9ugCv2vp64B3es3l9M9HOeha0ZQ5R7jzrHJGYrKwdiq/kknuz5SfFGLNvlQQyMN7
         rfy1JQ1ffAIug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 74/77] i2c: designware-pci: Group AMD NAVI quirk parts together
Date:   Sun,  9 Oct 2022 18:07:51 -0400
Message-Id: <20221009220754.1214186-74-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 65769162ae4b7f2d82e54998be446226b05fcd8f ]

The code is ogranized in a way that all related parts
to the certain platform quirk go together. This is not
the case for AMD NAVI. Shuffle code to make it happen.

While at it, drop the frequency definition and use
hard coded value as it's done for other platforms and
add a comment to the PCI ID list.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 30 +++++++++++-----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 608e61209455..ca368482b246 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -27,7 +27,6 @@
 #include "i2c-ccgx-ucsi.h"
 
 #define DRIVER_NAME "i2c-designware-pci"
-#define AMD_CLK_RATE_HZ	100000
 
 enum dw_pci_ctl_id_t {
 	medfield,
@@ -100,11 +99,6 @@ static u32 mfld_get_clk_rate_khz(struct dw_i2c_dev *dev)
 	return 25000;
 }
 
-static u32 navi_amd_get_clk_rate_khz(struct dw_i2c_dev *dev)
-{
-	return AMD_CLK_RATE_HZ;
-}
-
 static int mfld_setup(struct pci_dev *pdev, struct dw_pci_controller *c)
 {
 	struct dw_i2c_dev *dev = dev_get_drvdata(&pdev->dev);
@@ -126,15 +120,6 @@ static int mfld_setup(struct pci_dev *pdev, struct dw_pci_controller *c)
 	return -ENODEV;
 }
 
-static int navi_amd_setup(struct pci_dev *pdev, struct dw_pci_controller *c)
-{
-	struct dw_i2c_dev *dev = dev_get_drvdata(&pdev->dev);
-
-	dev->flags |= MODEL_AMD_NAVI_GPU;
-	dev->timings.bus_freq_hz = I2C_MAX_STANDARD_MODE_FREQ;
-	return 0;
-}
-
 static int mrfld_setup(struct pci_dev *pdev, struct dw_pci_controller *c)
 {
 	/*
@@ -159,6 +144,20 @@ static u32 ehl_get_clk_rate_khz(struct dw_i2c_dev *dev)
 	return 100000;
 }
 
+static u32 navi_amd_get_clk_rate_khz(struct dw_i2c_dev *dev)
+{
+	return 100000;
+}
+
+static int navi_amd_setup(struct pci_dev *pdev, struct dw_pci_controller *c)
+{
+	struct dw_i2c_dev *dev = dev_get_drvdata(&pdev->dev);
+
+	dev->flags |= MODEL_AMD_NAVI_GPU;
+	dev->timings.bus_freq_hz = I2C_MAX_STANDARD_MODE_FREQ;
+	return 0;
+}
+
 static struct dw_pci_controller dw_pci_controllers[] = {
 	[medfield] = {
 		.bus_num = -1,
@@ -389,6 +388,7 @@ static const struct pci_device_id i2_designware_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x4bbe), elkhartlake },
 	{ PCI_VDEVICE(INTEL, 0x4bbf), elkhartlake },
 	{ PCI_VDEVICE(INTEL, 0x4bc0), elkhartlake },
+	/* AMD NAVI */
 	{ PCI_VDEVICE(ATI,  0x7314), navi_amd },
 	{ PCI_VDEVICE(ATI,  0x73a4), navi_amd },
 	{ PCI_VDEVICE(ATI,  0x73e4), navi_amd },
-- 
2.35.1

