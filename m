Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2971E146246
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 08:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgAWHIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 02:08:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgAWHIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 02:08:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB8CC24655;
        Thu, 23 Jan 2020 07:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579763285;
        bh=cb1qkBYmCjjkEpEjJM4XWu1UHfSgDbHUmV37pBoZrAk=;
        h=Subject:To:From:Date:From;
        b=yLWtLVN+Vic36GwnqMRYSXdDNrCfGkdTg4cLlYMSEAUFMaMUldZs44tziOkxmU4PS
         BtVd5aatGKa4CUBgaia9Orl27sVZ2v7UWMBE9ClfuTdeNvJlsQyo3yhTzgv/pfR3eP
         x32rYkMqohgbsL3L0q4udcVakduTVvQHou4GzGrU=
Subject: patch "mei: me: add comet point (lake) H device ids" added to char-misc-next
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Jan 2020 08:07:26 +0100
Message-ID: <157976324617278@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add comet point (lake) H device ids

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 559e575a8946a6561dfe8880de341d4ef78d5994 Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Sun, 19 Jan 2020 11:42:29 +0200
Subject: mei: me: add comet point (lake) H device ids

Add Comet Point device IDs for Comet Lake H platforms.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20200119094229.20116-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 4 ++++
 drivers/misc/mei/pci-me.c     | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 7cd67fb2365d..9d24db38e8bc 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -81,8 +81,12 @@
 
 #define MEI_DEV_ID_CMP_LP     0x02e0  /* Comet Point LP */
 #define MEI_DEV_ID_CMP_LP_3   0x02e4  /* Comet Point LP 3 (iTouch) */
+
 #define MEI_DEV_ID_CMP_V      0xA3BA  /* Comet Point Lake V */
 
+#define MEI_DEV_ID_CMP_H      0x06e0  /* Comet Lake H */
+#define MEI_DEV_ID_CMP_H_3    0x06e4  /* Comet Lake H 3 (iTouch) */
+
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
 #define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index c845b7e40f26..c14261d735db 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -99,6 +99,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP, MEI_ME_PCH12_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP_3, MEI_ME_PCH8_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_V, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_H, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_H_3, MEI_ME_PCH8_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
-- 
2.25.0


