Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B927F0407
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 18:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbfKERWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 12:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728399AbfKERWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 12:22:00 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D21D3214B2;
        Tue,  5 Nov 2019 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572974518;
        bh=JgjlL/oHDItjKCK1eUG4BFdCFpcYYQyc/vcIlLxBVyY=;
        h=Subject:To:From:Date:From;
        b=dd9GilEwYqYJIcGY2YuC/o77pYh+eYdceERLsFuWXCeOYKkyK6ereOpKAJIPq8+09
         MguQrp3n/KXcXnl1U/6ZHWAlVCmFzBrwRk/pMgNv8rbSsa7hShWbviOpTJ6P4v+FIn
         VE9g8GDb8mkGmccvckAUIYNWaTRHKV9hcaHqJHxw=
Subject: patch "mei: me: add comet point V device id" added to char-misc-testing
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Nov 2019 18:21:29 +0100
Message-ID: <157297448959131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add comet point V device id

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 82b29b9f72afdccb40ea5f3c13c6a3cb65a597bc Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Tue, 5 Nov 2019 17:05:14 +0200
Subject: mei: me: add comet point V device id

Comet Point (Comet Lake) V device id.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191105150514.14010-2-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 1 +
 drivers/misc/mei/pci-me.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index c09f8bb49495..b359f06f05e7 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -81,6 +81,7 @@
 
 #define MEI_DEV_ID_CMP_LP     0x02e0  /* Comet Point LP */
 #define MEI_DEV_ID_CMP_LP_3   0x02e4  /* Comet Point LP 3 (iTouch) */
+#define MEI_DEV_ID_CMP_V      0xA3BA  /* Comet Point Lake V */
 
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 3dca63eddaa0..ce43415a536c 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -98,6 +98,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP, MEI_ME_PCH12_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP_3, MEI_ME_PCH8_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_V, MEI_ME_PCH12_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
-- 
2.23.0


