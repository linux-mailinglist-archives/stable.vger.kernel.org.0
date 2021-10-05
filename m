Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AF5422AE7
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 16:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhJEOWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 10:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235927AbhJEOWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 10:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09D1560F4B;
        Tue,  5 Oct 2021 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633443651;
        bh=yh1fij3FlfvWSAbNpA3FVx2PBJ/28VJ1clx2+0pyuMs=;
        h=Subject:To:From:Date:From;
        b=wmBwGK+40U0h0LQ7LIkhUlIoxcsBrMBVR70j0yxwh3Y+UsgHOa56+6qIG61aDquMu
         NOl+2XCNnMqLYn5quTpXYBTtGRsE2QjcTLjxlmzYALzaSjdxdlJgsqBay4NYIuS0Bv
         vHP1GU1kERJk4wUTM9VHv1gbVoAVNjrcFHMZqKfE=
Subject: patch "mei: me: add Ice Lake-N device id." added to char-misc-linus
To:     andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 16:20:49 +0200
Message-ID: <163344364916541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add Ice Lake-N device id.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 75c10c5e7a715550afdd51ef8cfd1d975f48f9e1 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Fri, 1 Oct 2021 20:36:44 +0300
Subject: mei: me: add Ice Lake-N device id.

Add Ice Lake-N device ID.

The device can be found on MacBookPro16,2 [1].

[1]: https://linux-hardware.org/?probe=f1c5cf0c43

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211001173644.16068-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 1 +
 drivers/misc/mei/pci-me.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index cb34925e10f1..67bb6a25fd0a 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -92,6 +92,7 @@
 #define MEI_DEV_ID_CDF        0x18D3  /* Cedar Fork */
 
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
+#define MEI_DEV_ID_ICP_N      0x38E0  /* Ice Lake Point N */
 
 #define MEI_DEV_ID_JSP_N      0x4DE0  /* Jasper Lake Point N */
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index c3393b383e59..3a45aaf002ac 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -96,6 +96,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_H_3, MEI_ME_PCH8_ITOUCH_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_N, MEI_ME_PCH12_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_H, MEI_ME_PCH15_SPS_CFG)},
-- 
2.33.0


