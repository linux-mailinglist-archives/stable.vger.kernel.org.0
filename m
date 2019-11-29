Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C94F10DAAA
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfK2UwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:52:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53184 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfK2UwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:52:24 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so351895wmc.2
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 12:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UCSLA0Lp9PuuVCJfQNZxd7gfK/2l9DWr56ay/T24uXI=;
        b=F6+cdiwnxSOrDKvTzVYF+I3i8XnqULVWwl4z86LXhopKW1EnVJhbp0NFiviMFazre2
         ocQDhzEEw1kXTwZkm5P7dQudN13i5JHg8g6YEOPKKRnAZywuEfA8sS4GlFpnbvoA6S32
         QnvXGu1RAUwxm30jRvKSQgUm5kYvhyozTzf7b8AfrftlvgtxBwsYfik1Z8Hqr4khgx6M
         bx7FPQ6ydB4XYR7PFARDsqU4you4N/BfFMqaIKIKKP900VFlAdaSnZdVPu8om1rAzzRU
         TvQmcKXArlzzAJH4TN2CSzVyFx3tWtVSc11ynWCsFMU7wugTRdFUoIz1gpkKqlbz01AI
         U76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UCSLA0Lp9PuuVCJfQNZxd7gfK/2l9DWr56ay/T24uXI=;
        b=ZLmFKeaXMvXasY5BB/AE30wcQNOPf3L/5Vx+an1C0eP7P5ck468d1jC2mLA+64cph4
         XCtQIz8qWcPd6dYDUUSiHjdUqXf5LeKhj/H4dzykKWC1SN5dKILCx1UxPn072n63XFyV
         47yTNnF4f9LhPdNyK7nPyNs6ScJhm6Vyi2munA2C1BlVU4NqtwhTRg0+rFrmwFYwxhbP
         vpjsWshzLfupDW5gc587SZCywzRhepVNGemj5y0Ph2IuaueTN+kM+1vlr1idvjAPExuW
         sspJuDfCHUxAIdQzXFBlXXzArs1hPDSKyrW/xM9lZPs27lq2mMseDo/aCtbZChXQ5GqO
         EMRA==
X-Gm-Message-State: APjAAAWYc9SUhTk9irFQ8jlsuqPqDGmKrYetRo6/UtsN+oEkLXtKsBku
        yxyxvK/2yEnUVlCy5/fHfcm0tOr5
X-Google-Smtp-Source: APXvYqzLMX69y9gCJKd2pKpLuqzAtFhlRu/gCmGSgeLG/hdxNYvyFzCoCt8qhUJEtML92fvAhJtILQ==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr15747541wmc.49.1575060742288;
        Fri, 29 Nov 2019 12:52:22 -0800 (PST)
Received: from debian64.daheim (p5B0D764B.dip0.t-ipconnect.de. [91.13.118.75])
        by smtp.gmail.com with ESMTPSA id g184sm15931141wma.8.2019.11.29.12.52.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 12:52:21 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.93-RC5)
        (envelope-from <chunkeey@gmail.com>)
        id 1ianFV-000Bq7-9d
        for stable@vger.kernel.org; Fri, 29 Nov 2019 21:52:21 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     stable@vger.kernel.org
Subject: [PATCH for-4.9-stable] ath10k: restore QCA9880-AR1A (v1) detection
Date:   Fri, 29 Nov 2019 21:52:21 +0100
Message-ID: <1716553.tKVfJXaoeT@debian64>
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
Subject: [PATCH 4.9] ath10k: restore QCA9880-AR1A (v1) detection
To: linux-wireless@vger.kernel.org,
    ath10k@lists.infradead.org
Cc: Kalle Valo <kvalo@codeaurora.org>

This patch restores the old behavior that read
the chip_id on the QCA988x before resetting the
chip. This needs to be done in this order since
the unsupported QCA988x AR1A chips fall off the
bus when resetted. Otherwise the next MMIO Op
after the reset causes a BUS ERROR and panic.

Cc: stable@vger.kernel.org # 4.9
Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 36 +++++++++++++++++++--------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
--- a/drivers/net/wireless/ath/ath10k/pci.c	2019-09-08 00:07:21.374565470 +0200
+++ b/drivers/net/wireless/ath/ath10k/pci.c	2019-09-08 00:17:15.365912133 +0200
@@ -3172,7 +3172,7 @@ static int ath10k_pci_probe(struct pci_d
 	struct ath10k_pci *ar_pci;
 	enum ath10k_hw_rev hw_rev;
 	u32 chip_id;
-	bool pci_ps;
+	bool pci_ps, is_qca988x = false;
 	int (*pci_soft_reset)(struct ath10k *ar);
 	int (*pci_hard_reset)(struct ath10k *ar);
 	u32 (*targ_cpu_to_ce_addr)(struct ath10k *ar, u32 addr);
@@ -3181,6 +3181,7 @@ static int ath10k_pci_probe(struct pci_d
 	case QCA988X_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA988X;
 		pci_ps = false;
+		is_qca988x = true;
 		pci_soft_reset = ath10k_pci_warm_reset;
 		pci_hard_reset = ath10k_pci_qca988x_chip_reset;
 		targ_cpu_to_ce_addr = ath10k_pci_qca988x_targ_cpu_to_ce_addr;
@@ -3300,6 +3301,19 @@ static int ath10k_pci_probe(struct pci_d
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
@@ -3312,11 +3326,8 @@ static int ath10k_pci_probe(struct pci_d
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
@@ -3326,6 +3337,10 @@ static int ath10k_pci_probe(struct pci_d
 
 	return 0;
 
+err_unsupported:
+	ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
+		   pdev->device, bus_params.chip_id);
+
 err_free_irq:
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_rx_retry_sync(ar);



