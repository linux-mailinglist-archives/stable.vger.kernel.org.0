Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5625DC9D86
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 13:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbfJCLkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 07:40:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40691 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729820AbfJCLkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 07:40:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E9E7821C57;
        Thu,  3 Oct 2019 07:40:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 07:40:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bg791F
        byt7qBKK1sbFyAsKZAVRaaGBCYZXyGc5NVzUw=; b=z52NjHFEauh6pZnyBcyxOn
        i+YRGlEUl6jLR4xgEzDNd3fzDuglyWmmQRqpd9/mO90IxQNlDWO5mlWa1P/p3luT
        eRApHV9YgzEvABvlZrBstvMFmrRE50j14nH0pcvMPPaYLRjGg043dadV3InCHtYv
        pFyh1Ikmpo7ICh14GtMypS9OufMXGVBNrPOeZEml19U1N0zmB34gndOOZPZWnmiR
        htFp1Jq1H3lBpx7U99A0AzalEm/P5S5eU5dTOL0u2Fp2UAelYiOZwzvGJOx0fQ2B
        9unp03gFQIZgCcrsMapNXZY5U41D3Tu26SckqIR/RacN3oB298BXRA1XYmvb66bA
        ==
X-ME-Sender: <xms:QN6VXToUBpEQiVRNKw2GaQkSAN_4K_S8JnPYyZIgRNmxgYzl40HaCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:QN6VXZtpOSRxbw_Orh0o4MlnK5gcP9XayGx5IIrw5itlwHLHHMBbbA>
    <xmx:QN6VXbguph_W939hjLiLlD8Kmy9XlWr79svuCLqiBjTPHAqlh5cyyQ>
    <xmx:QN6VXV2Rx22QoYksA8lfVcZr1NFpOL2-osnAtjsu8Z6ZD6LwQ-MjlQ>
    <xmx:QN6VXUML-iPwT7KLaku7c8dGr9EI8l36iVkT-NoiYdq-sOOnvxDUPQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A71780061;
        Thu,  3 Oct 2019 07:40:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mt76: mt7615: fix mt7615 firmware path definitions" failed to apply to 5.2-stable tree
To:     lorenzo@kernel.org, kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 13:40:46 +0200
Message-ID: <157010284629206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d4d0d06bbf9f7e576b0ebbb2f77672d0fc7f503 Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sun, 22 Sep 2019 15:36:03 +0200
Subject: [PATCH] mt76: mt7615: fix mt7615 firmware path definitions

mt7615 patch/n9/cr4 firmwares are available in mediatek folder in
linux-firmware repository. Because of this mt7615 won't work on regular
distributions like Ubuntu. Fix path definitions.  Moreover remove useless
firmware name pointers and use definitions directly

Fixes: 04b8e65922f6 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 275d5eaed3b7..842cd81704db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -333,7 +333,6 @@ static int mt7615_driver_own(struct mt7615_dev *dev)
 
 static int mt7615_load_patch(struct mt7615_dev *dev)
 {
-	const char *firmware = MT7615_ROM_PATCH;
 	const struct mt7615_patch_hdr *hdr;
 	const struct firmware *fw = NULL;
 	int len, ret, sem;
@@ -349,7 +348,7 @@ static int mt7615_load_patch(struct mt7615_dev *dev)
 		return -EAGAIN;
 	}
 
-	ret = request_firmware(&fw, firmware, dev->mt76.dev);
+	ret = request_firmware(&fw, MT7615_ROM_PATCH, dev->mt76.dev);
 	if (ret)
 		goto out;
 
@@ -447,13 +446,11 @@ mt7615_mcu_send_ram_firmware(struct mt7615_dev *dev,
 
 static int mt7615_load_ram(struct mt7615_dev *dev)
 {
-	const struct firmware *fw;
 	const struct mt7615_fw_trailer *hdr;
-	const char *n9_firmware = MT7615_FIRMWARE_N9;
-	const char *cr4_firmware = MT7615_FIRMWARE_CR4;
+	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, n9_firmware, dev->mt76.dev);
+	ret = request_firmware(&fw, MT7615_FIRMWARE_N9, dev->mt76.dev);
 	if (ret)
 		return ret;
 
@@ -482,7 +479,7 @@ static int mt7615_load_ram(struct mt7615_dev *dev)
 
 	release_firmware(fw);
 
-	ret = request_firmware(&fw, cr4_firmware, dev->mt76.dev);
+	ret = request_firmware(&fw, MT7615_FIRMWARE_CR4, dev->mt76.dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index cef3fd43cb00..7963e302d705 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -26,9 +26,9 @@
 #define MT7615_RX_RING_SIZE		1024
 #define MT7615_RX_MCU_RING_SIZE		512
 
-#define MT7615_FIRMWARE_CR4		"mt7615_cr4.bin"
-#define MT7615_FIRMWARE_N9		"mt7615_n9.bin"
-#define MT7615_ROM_PATCH		"mt7615_rom_patch.bin"
+#define MT7615_FIRMWARE_CR4		"mediatek/mt7615_cr4.bin"
+#define MT7615_FIRMWARE_N9		"mediatek/mt7615_n9.bin"
+#define MT7615_ROM_PATCH		"mediatek/mt7615_rom_patch.bin"
 
 #define MT7615_EEPROM_SIZE		1024
 #define MT7615_TOKEN_SIZE		4096

