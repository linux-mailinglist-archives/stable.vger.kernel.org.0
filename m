Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA4C3092F4
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 10:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhA3JLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 04:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233710AbhA3JKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 04:10:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5E7E64E1B;
        Sat, 30 Jan 2021 09:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611997773;
        bh=ZJTTSaM3ekAyk7y6S7itgenmYSPXJVcp46LJD1F9onI=;
        h=Subject:To:From:Date:From;
        b=AAvZNfjg1CxtPyjQZa+mCYQGXHl13MbsseJc0GL/Of/DAzBXCeE6Q/yNSimZea3DE
         p5iEVfqtYD2224IGAbFZ6yn+IwAa/nLxrZ8/WnpucsP8wam+uvGSICIiFho7C3SiBk
         E8EAZCpFRDlMh/xNp3qzxfPv0Q1WJwiOMBpZgEdQ=
Subject: patch "mei: me: add adler lake point LP DID" added to char-misc-next
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jan 2021 10:09:13 +0100
Message-ID: <161199775364180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add adler lake point LP DID

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 930c922a987a02936000f15ea62988b7a39c27f5 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Fri, 29 Jan 2021 14:07:52 +0200
Subject: mei: me: add adler lake point LP DID

Add Adler Lake LP device id.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210129120752.850325-7-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 1 +
 drivers/misc/mei/pci-me.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 50a82a38e66d..14be76d4c2e6 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -104,6 +104,7 @@
 #define MEI_DEV_ID_EBG        0x1BE0  /* Emmitsburg WS */
 
 #define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
+#define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
 
 /*
  * MEI HW Section
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 94c122007504..a7e179626b63 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -110,6 +110,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_EBG, MEI_ME_PCH15_SPS_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }
-- 
2.30.0


