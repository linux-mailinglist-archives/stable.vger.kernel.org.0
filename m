Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6303D431C97
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhJRNmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233637AbhJRNkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 698C3613A6;
        Mon, 18 Oct 2021 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563998;
        bh=1vCC8JmW3qUGBvIvH+VBwtplxGM1bASbw/+PNV10B94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORhz78yWVQ+EVp3m/EoA/ZYZOzXaze2eHbeTL8qBwtpOkJnRyVnTOQTeh/tXzm9ys
         O0Tj7qvxg3bHgjNkr9krzCuDR2RnmgJnjRoSPYP7pz27XD+aR6iBAlvYg5MplzXgmU
         miChLUYG/02s1g/pMIGQhPMioTBiJu3+YeXx2AB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 026/103] mei: me: add Ice Lake-N device id.
Date:   Mon, 18 Oct 2021 15:24:02 +0200
Message-Id: <20211018132335.590361709@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 75c10c5e7a715550afdd51ef8cfd1d975f48f9e1 upstream.

Add Ice Lake-N device ID.

The device can be found on MacBookPro16,2 [1].

[1]: https://linux-hardware.org/?probe=f1c5cf0c43

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211001173644.16068-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -92,6 +92,7 @@
 #define MEI_DEV_ID_CDF        0x18D3  /* Cedar Fork */
 
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
+#define MEI_DEV_ID_ICP_N      0x38E0  /* Ice Lake Point N */
 
 #define MEI_DEV_ID_JSP_N      0x4DE0  /* Jasper Lake Point N */
 
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -96,6 +96,7 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_H_3, MEI_ME_PCH8_ITOUCH_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_N, MEI_ME_PCH12_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_H, MEI_ME_PCH15_SPS_CFG)},


