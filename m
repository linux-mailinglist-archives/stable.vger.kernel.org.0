Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A985210DAA8
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfK2UwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:52:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36897 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfK2UwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:52:19 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so5699244wru.4
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 12:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZnbFhiHX2AATT56JpA0lebgcGOUiDTKjsS7embABJ80=;
        b=gCYAfGsE1/lwA8d0JCWs6XVU7tQlqXy1EXTCyEkFUr+yvjaYFgOAlV4P5B4LucoO57
         VYa0bnRT/mJYMp9SQk9yuEkxKrdafJqB6z4R785FDUsYFmJSKuJ5KBfgacn+QlPEh+wY
         dqTX7GRqDAdoiNLw0xwW2FFziR+b5t24t32jqApf/ZSk/Hc9eAYOPwiC8HYpSCpGtOJ4
         7+s3PGL/hN7fvGZN2Q7uoUNYmirzIVgnjp+tQ55R99etVWZa3HuzwQYVGeltXx7TkFfV
         +6+S/dAIhaLPe3dkABMavXn45Y1JOmweHdPKII/fKXKYsok+MnDQqqJODdougTUBPmK7
         BOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZnbFhiHX2AATT56JpA0lebgcGOUiDTKjsS7embABJ80=;
        b=PjWb9bUPwBYOuR3xZUV0vRACEP1wipYoCm8M7AORwCnsB4GubZHuCobtorMBzpr9Iy
         pm3Bz7VRVEHUR+I4UyPARh1NuU6ImcfTES2wxO7LumMWvUjOzsBYqbc0DoCQUKY6ZUxV
         7ZFpP6qlS7izn4IG+fXHaxCnVvvChokXb7MRV61kda5aFmaKUTUZx054Ej4EX71v/6P7
         /dmYEGnboy7t9IW7DrUt8rgTUpifqKXSpORjZSzODAHXNh/mn0S1gySJiApg8JSDAUyt
         SO8o86+RmbrAyuqxyryck2SKA5c1vk12aG9mrsLLGp59IGLchttvKszkngRqEHT2VkQD
         B3fg==
X-Gm-Message-State: APjAAAVNuW5O9Ma3+uNF5jWm28XqFZz0XSlYaV9jECHJ4FfGh+dH5ZAm
        fFBNfSXuBnOLZb0VZrsXoyq7rJCY
X-Google-Smtp-Source: APXvYqxEyBzuv+8eDXT5e0FiXs9eap/u5Dklm/GjKtF0sOH+iqEf7MQNETqC6Jyw9Hm2i+eIq4YL/Q==
X-Received: by 2002:adf:e387:: with SMTP id e7mr41126967wrm.180.1575060736637;
        Fri, 29 Nov 2019 12:52:16 -0800 (PST)
Received: from debian64.daheim (p5B0D764B.dip0.t-ipconnect.de. [91.13.118.75])
        by smtp.gmail.com with ESMTPSA id a184sm5729319wmf.29.2019.11.29.12.52.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 12:52:15 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.93-RC5)
        (envelope-from <chunkeey@gmail.com>)
        id 1ianFO-000Bpc-Ig
        for stable@vger.kernel.org; Fri, 29 Nov 2019 21:52:14 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     stable@vger.kernel.org
Subject: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1) detection
Date:   Fri, 29 Nov 2019 21:52:14 +0100
Message-ID: <5688116.JcRxOpqE2I@debian64>
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
Subject: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1) detection
To: linux-wireless@vger.kernel.org,
    ath10k@lists.infradead.org
Cc: Kalle Valo <kvalo@codeaurora.org>

This patch restores the old behavior that read
the chip_id on the QCA988x before resetting the
chip. This needs to be done in this order since
the unsupported QCA988x AR1A chips fall off the
bus when resetted. Otherwise the next MMIO Op
after the reset causes a BUS ERROR and panic.

Cc: stable@vger.kernel.org # 4.19
Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 36 +++++++++++++++++++--------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
--- a/drivers/net/wireless/ath/ath10k/pci.c	2019-09-08 00:07:21.374565470 +0200
+++ b/drivers/net/wireless/ath/ath10k/pci.c	2019-09-08 00:17:15.365912133 +0200
@@ -3483,7 +3483,7 @@ static int ath10k_pci_probe(struct pci_d
 	struct ath10k_pci *ar_pci;
 	enum ath10k_hw_rev hw_rev;
 	u32 chip_id;
-	bool pci_ps;
+	bool pci_ps, is_qca988x = false;
 	int (*pci_soft_reset)(struct ath10k *ar);
 	int (*pci_hard_reset)(struct ath10k *ar);
 	u32 (*targ_cpu_to_ce_addr)(struct ath10k *ar, u32 addr);
@@ -3493,6 +3493,7 @@ static int ath10k_pci_probe(struct pci_d
 	case QCA988X_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA988X;
 		pci_ps = false;
+		is_qca988x = true;
 		pci_soft_reset = ath10k_pci_warm_reset;
 		pci_hard_reset = ath10k_pci_qca988x_chip_reset;
 		targ_cpu_to_ce_addr = ath10k_pci_qca988x_targ_cpu_to_ce_addr;
@@ -3612,6 +3613,19 @@ static int ath10k_pci_probe(struct pci_d
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
@@ -3624,11 +3638,8 @@ static int ath10k_pci_probe(struct pci_d
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
@@ -3638,6 +3649,10 @@ static int ath10k_pci_probe(struct pci_d
 
 	return 0;
 
+err_unsupported:
+	ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
+		   pdev->device, bus_params.chip_id);
+
 err_free_irq:
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_rx_retry_sync(ar);



