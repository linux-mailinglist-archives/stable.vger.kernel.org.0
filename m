Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C488DC9D87
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 13:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbfJCLk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 07:40:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57475 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729820AbfJCLk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 07:40:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BEC7E21C28;
        Thu,  3 Oct 2019 07:40:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 07:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=B33xXl
        LhMgdsWYkneZaakDgA2BCJjXCrggESPQVabHE=; b=x4xBVjxIHgg4Xi9EXHzD7y
        DyzMYQjT+nDpkzWhW0EUEtmYOSKKKPeV/VpNMbKdD+ehkvMzbUhHAPg6kqkGL2Le
        XaNc7E58exUhOlwMOyDlNZV2JX3qrkHeuyBEFIjh1lS5hYq5MVyPdxlR8kDW8KMG
        h4HA/mg38lgGTsrApfK5tkCh712axQhhKmf2iORnpnOiy1GdIoJXf27IpfNpawBO
        qz2EgY2DUx9tJR9XR7/uylQJXXDbJuWDg4PWKlDKF7oIZFTj4rhck99/UoBcgWb3
        aRHH7jb4BZqvvmqQGbnAfI6SIOKNz6Hy+E0+axoGF7q3dBRPDRO08EpGP1hHE1jA
        ==
X-ME-Sender: <xms:SN6VXYfuh6TGXGA9FBitrvdd84xq8URlv5WT5maQqL7ct6oaqWBqbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:SN6VXQgiC7j-6Vh5kdAGLOTk8Mp_cyWBfOJESEpUT-DE-en0W60T6w>
    <xmx:SN6VXfgiPZ68pzTR7M8931rszeZ2KJKZLi7SwmtAFIshIslzgiHBWg>
    <xmx:SN6VXbRUD_kxs9BTtEdtWkDwwNd8HLAbS4uI3rlbj_4OMQPrAfk0kA>
    <xmx:SN6VXRSvizm0m3yzCmGhWsd9mo7vwMRFU14TEE4fy3aduR_1z-gbAg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3FA5F80061;
        Thu,  3 Oct 2019 07:40:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mt76: mt7615: fix mt7615 firmware path definitions" failed to apply to 5.3-stable tree
To:     lorenzo@kernel.org, kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 13:40:47 +0200
Message-ID: <157010284795216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
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

