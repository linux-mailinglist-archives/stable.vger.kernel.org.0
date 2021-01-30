Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364833092F2
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 10:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhA3JLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 04:11:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230469AbhA3JKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 04:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF5964E12;
        Sat, 30 Jan 2021 09:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611997767;
        bh=GO1x/ZTpFiMxF68Yd4VaP2Vuz7LQK81Ed/Nlm2xbyJw=;
        h=Subject:To:From:Date:From;
        b=uZg1aSk+57bYswbPo3k3NwA4Q4kqjdK6l6Nyy0cwzSUjyxLOomBJfPmg+K1LvLrd6
         Yczu7gf0J7H+GdenfbzKRIwNja7ihf5Ujoz2n8dgK2pyDxurRPWRtSzc6MprSUSqcP
         s05soEWDN4aHkmDGcTdeO/WfRINX9okQjxOw47wc=
Subject: patch "mei: me: emmitsburg workstation DID" added to char-misc-next
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jan 2021 10:09:11 +0100
Message-ID: <16119977515181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: emmitsburg workstation DID

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 372726cb3957dbd69ded9a4e3419d5c6c3bc648e Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Fri, 29 Jan 2021 14:07:50 +0200
Subject: mei: me: emmitsburg workstation DID

Add Emmitsburg workstation DID.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210129120752.850325-5-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 2 ++
 drivers/misc/mei/pci-me.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 9cf8d8f60cfe..a368849278b2 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -101,6 +101,8 @@
 #define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
 #define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
 
+#define MEI_DEV_ID_EBG        0x1BE0  /* Emmitsburg WS */
+
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1de9ef7a272b..12dc99ee4b58 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -107,6 +107,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CDF, MEI_ME_PCH8_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_EBG, MEI_ME_PCH15_SPS_CFG)},
+
 	/* required last entry */
 	{0, }
 };
-- 
2.30.0


