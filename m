Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E31610DAA9
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfK2UwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:52:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37495 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfK2UwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:52:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id f129so16457558wmf.2
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 12:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MtGIRiipZhbluLTd8mmfs4AlwfBLd2TwZCi4wk+0CoQ=;
        b=dqYxQ758jgrV/D80wO3MOabZ4Vnd9isrxEzZB+x5SuBfRqva6DuMCK7EWiz1Z8ZPrq
         ykiL1P1BdKrlAwfzze23lWar+F1MTH3W7+U436LULf8YYo+mhM83fdydQknJ7WsbNfkN
         aOMho/giX9CIVC+7PEXPpq4TdDNmt7RqFA3n0qH+yCIRvKXlUHVuqN8XjNPX1Z+js4dg
         6NCniOSBJs8BTHVFCma3RK5ybq+D643zyvKNB5uTgsmaPvzQDM8xn725p+UELMVeq7m6
         tfpPaWgQbYCL0O8RtMRqAu+gPBrLsOFIzHKnEclmqGGIMxkktQ/vhpqgWHcWeWW56rxC
         92LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MtGIRiipZhbluLTd8mmfs4AlwfBLd2TwZCi4wk+0CoQ=;
        b=i7tKtqNekYDBU9IuHLHEqBIVKrktlgorgDW/KbRHE5NQ0Bk1KqDXzSgOXUL/fnysqt
         fDqPl2qm3MKAp8kmWYJyGXqH9pOoCDiA9Jf85eU0mViYP1CMj9lDUBsXge9BVSLjWdeK
         773yb/io2ysRbL2NdgbVzaiBo8kAFJWD9Ec+lx4V4qfOXw/B74L8xwe8WLEZgHE+rOgJ
         QT2IwsqtirWdxdWsHz92nX5mdL0frAd9KCI5/kWqC+VEoxuid794hnk7ujtSbMYDoM3x
         X71Py1/eBwYWeYyvK5rZHl0cOpg2bV5LJ07NlDTW6R6ZOIt2X/xD9Aap2m2Jpdplj4dY
         ElFg==
X-Gm-Message-State: APjAAAUsl1GoAhdOuk5T1DjdK4/Zu8i4MU8WrI/tezyaxURmUFngSU9o
        pzRiqqR+3m6RU0xtdH5fL6HNSQJt
X-Google-Smtp-Source: APXvYqyEZdHd3A9Pqe2ErdDoe8/Dv/WCrM6rgrJUFkhTcZ6FulT8W/J43bhPHYy3kwQP60026nYjpQ==
X-Received: by 2002:a1c:3d87:: with SMTP id k129mr17444534wma.26.1575060739923;
        Fri, 29 Nov 2019 12:52:19 -0800 (PST)
Received: from debian64.daheim (p5B0D764B.dip0.t-ipconnect.de. [91.13.118.75])
        by smtp.gmail.com with ESMTPSA id f2sm7651718wmh.46.2019.11.29.12.52.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 12:52:19 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.93-RC5)
        (envelope-from <chunkeey@gmail.com>)
        id 1ianFS-000Bps-Up
        for stable@vger.kernel.org; Fri, 29 Nov 2019 21:52:18 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     stable@vger.kernel.org
Subject: [PATCH for-4.14-stable] ath10k: restore QCA9880-AR1A (v1) detection
Date:   Fri, 29 Nov 2019 21:52:18 +0100
Message-ID: <1720118.fV9XW92F7O@debian64>
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
Subject: [PATCH 4.14] ath10k: restore QCA9880-AR1A (v1) detection
To: linux-wireless@vger.kernel.org,
    ath10k@lists.infradead.org
Cc: Kalle Valo <kvalo@codeaurora.org>

This patch restores the old behavior that read
the chip_id on the QCA988x before resetting the
chip. This needs to be done in this order since
the unsupported QCA988x AR1A chips fall off the
bus when resetted. Otherwise the next MMIO Op
after the reset causes a BUS ERROR and panic.

Cc: stable@vger.kernel.org # 4.14
Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 36 +++++++++++++++++++--------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
--- a/drivers/net/wireless/ath/ath10k/pci.c	2019-09-08 00:07:21.374565470 +0200
+++ b/drivers/net/wireless/ath/ath10k/pci.c	2019-09-08 00:17:15.365912133 +0200
@@ -3202,7 +3202,7 @@ static int ath10k_pci_probe(struct pci_d
 	struct ath10k_pci *ar_pci;
 	enum ath10k_hw_rev hw_rev;
 	u32 chip_id;
-	bool pci_ps;
+	bool pci_ps, is_qca988x = false;
 	int (*pci_soft_reset)(struct ath10k *ar);
 	int (*pci_hard_reset)(struct ath10k *ar);
 	u32 (*targ_cpu_to_ce_addr)(struct ath10k *ar, u32 addr);
@@ -3211,6 +3211,7 @@ static int ath10k_pci_probe(struct pci_d
 	case QCA988X_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA988X;
 		pci_ps = false;
+		is_qca988x = true;
 		pci_soft_reset = ath10k_pci_warm_reset;
 		pci_hard_reset = ath10k_pci_qca988x_chip_reset;
 		targ_cpu_to_ce_addr = ath10k_pci_qca988x_targ_cpu_to_ce_addr;
@@ -3331,6 +3332,19 @@ static int ath10k_pci_probe(struct pci_d
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
@@ -3343,11 +3357,8 @@ static int ath10k_pci_probe(struct pci_d
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
@@ -3357,6 +3368,10 @@ static int ath10k_pci_probe(struct pci_d
 
 	return 0;
 
+err_unsupported:
+	ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
+		   pdev->device, bus_params.chip_id);
+
 err_free_irq:
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_rx_retry_sync(ar);



