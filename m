Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3566510DAAD
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfK2Uxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:53:54 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37124 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfK2Uxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:53:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so5702716wru.4
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 12:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6uCZJnOoBvG87xYv2Nu8va74ssaFmNjcSC5DmT7LeGo=;
        b=PJ1FseyfHHoND5vm5LQXO8vgxMAMy4qLWtmWhOGK2zZzNjdYHoUVNtOxwPjfl3qi00
         rJ3PBfJEJc2J5o8aj9Wr27wYgrw855GCsNsC2mTVlcSHdBY2lcdKCCqltKVmOyoRtSCZ
         Lblfjl46i9aKpX33KzPGljRVz1vxj3d1fsYCkmffJv0SQ46ZGfpHJHQ2lS8swLSPh8m0
         5vgW3I56TGgVieMOU3UkxDJsSUMn17fre0dyTt3YMyusoOX8CbzvszLV/gI8nxOhijoj
         3X/DWR+0rktdzfVkuF7uvRekb3wL98vGRD/YL7VsniPbXAlBJzwAAEozDg4twIFoElvc
         VreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6uCZJnOoBvG87xYv2Nu8va74ssaFmNjcSC5DmT7LeGo=;
        b=Gd9yGxxNQyPXdQG+sCbHZH3jRSFs5J1z4AIGVUHv8oNjqopGDDw4pIo2Zwb5FDlfSU
         FwbUdKGkHFQiRSTQadfEpCuPkOn1vgNTBaB0105a96hZkw93ktjUowYVHhJEuPPxtJYA
         RXXH7zAqWOnQK7dWtXMB4hPdEBSlckGbt+xrt68oA4gErwUNFxF2B684BvD92dPuz84j
         RsA6BKC/hA0hy27COY7/yyCP0f3gbEN9KOneCfYKjtjJpOT4rKFh0Z4ymHaYQaq/pphK
         G6ye7emCCBpXcmBMFAmOgNGNCdiOPvITRFwwL9oJXmUAlIhnprE1hpVv1TTnIo3uVtSn
         wOgg==
X-Gm-Message-State: APjAAAUBAB6FA55M4A0I4sDPcasl1Cxu18xdVAi3x4ZJ0tp8VsFwT099
        4yYdibbm5ZL76AkbfngdX6E48K02
X-Google-Smtp-Source: APXvYqxZEEZFaSMbKT3sG2BlrxpJ4SMcAYUOdGW863rOxjY4l1bsotluHCYMJnhjTTrkI75IvD69pw==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr42262777wrt.15.1575060831694;
        Fri, 29 Nov 2019 12:53:51 -0800 (PST)
Received: from debian64.daheim (p5B0D764B.dip0.t-ipconnect.de. [91.13.118.75])
        by smtp.gmail.com with ESMTPSA id x13sm14208034wmc.19.2019.11.29.12.53.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 12:53:51 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.93-RC5)
        (envelope-from <chunkeey@gmail.com>)
        id 1ianGw-000Brr-NT
        for stable@vger.kernel.org; Fri, 29 Nov 2019 21:53:50 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     stable@vger.kernel.org
Subject: [PATCH for-4.4-stable] ath10k: restore QCA9880-AR1A (v1) detection
Date:   Fri, 29 Nov 2019 21:53:50 +0100
Message-ID: <2379623.yQyDp7EeDN@debian64>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 upstream
---
From f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 Mon Sep 17 00:00:00 2001
From: Christian Lamparter <chunkeey@gmail.com>
Date: Mon, 25 Mar 2019 13:50:19 +0100
Subject: [PATCH 4.4] ath10k: restore QCA9880-AR1A (v1) detection
To: linux-wireless@vger.kernel.org,
    ath10k@lists.infradead.org
Cc: Kalle Valo <kvalo@codeaurora.org>

This patch restores the old behavior that read
the chip_id on the QCA988x before resetting the
chip. This needs to be done in this order since
the unsupported QCA988x AR1A chips fall off the
bus when resetted. Otherwise the next MMIO Op
after the reset causes a BUS ERROR and panic.

Cc: stable@vger.kernel.org # 4.4
Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 36 +++++++++++++++++++--------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
--- a/drivers/net/wireless/ath/ath10k/pci.c	2019-09-08 00:07:21.374565470 +0200
+++ b/drivers/net/wireless/ath/ath10k/pci.c	2019-09-08 00:17:15.365912133 +0200
@@ -2988,12 +2988,13 @@ static int ath10k_pci_probe(struct pci_d
 	struct ath10k_pci *ar_pci;
 	enum ath10k_hw_rev hw_rev;
 	u32 chip_id;
-	bool pci_ps;
+	bool pci_ps, is_qca988x = false;
 
 	switch (pci_dev->device) {
 	case QCA988X_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA988X;
 		pci_ps = false;
+		is_qca988x = true;
 		break;
 	case QCA6164_2_1_DEVICE_ID:
 	case QCA6174_2_1_DEVICE_ID:
@@ -3087,6 +3088,19 @@ static int ath10k_pci_probe(struct pci_d
 		goto err_deinit_irq;
 	}
 
+	/* Read CHIP_ID before reset to catch QCA9880-AR1A v1 devices that
+	 * fall off the bus during chip_reset. These chips have the same pci
+	 * device id as the QCA9880 BR4A or 2R4E. So that's why the check.
+	 */
+	if (is_qca988x) {
+		chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
+		if (chip_id != 0xffffffff) {
+			if (!ath10k_pci_chip_is_supported(pdev->device,
+							  chip_id))
+				goto err_unsupported;
+		}
+	}
+
 	ret = ath10k_pci_chip_reset(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to reset chip: %d\n", ret);
@@ -3099,11 +3113,8 @@ static int ath10k_pci_probe(struct pci_d
 		goto err_free_irq;
 	}
 
-	if (!ath10k_pci_chip_is_supported(pdev->device, chip_id)) {
-		ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
-			   pdev->device, chip_id);
-		goto err_free_irq;
-	}
+	if (!ath10k_pci_chip_is_supported(pdev->device, chip_id))
+		goto err_unsupported;
 
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
@@ -3113,6 +3124,10 @@ static int ath10k_pci_probe(struct pci_d
 
 	return 0;
 
+err_unsupported:
+	ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
+		   pdev->device, bus_params.chip_id);
+
 err_free_irq:
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);



