Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D558147974
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 09:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgAXIeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 03:34:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgAXIeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 03:34:05 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE1F82071A;
        Fri, 24 Jan 2020 08:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579854844;
        bh=NX0q/lFRCiROwdikjPb7SPYAvIOXYM7OX9K5hpe9Pd4=;
        h=Subject:To:From:Date:From;
        b=iniGyLSUMokJCf9L6tbsLyoYD31Ltc0uvOtV0v6/KLK6/ymgXnoE2wmesfykXOedS
         IvIkIQjktIQaT9SdLophNugRv0ZMJu2MQja29y7arOGO3eP8whsHeSJyuTQU5aTXHD
         SvmW8ElSerq6f+/USOtYT2Sxryk8uCndFgbiXzVE=
Subject: patch "mei: me: add jasper point DID" added to char-misc-testing
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 Jan 2020 09:34:01 +0100
Message-ID: <1579854841247107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add jasper point DID

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 0db4a15d4c2787b1112001790d4f95bd2c5fed6f Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Fri, 24 Jan 2020 02:14:55 +0200
Subject: mei: me: add jasper point DID

Add Jasper Point (Jasper Lake) device id for MEI

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200124001455.24176-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 2 ++
 drivers/misc/mei/pci-me.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 9d24db38e8bc..87a0201ba6b3 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -89,6 +89,8 @@
 
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
+#define MEI_DEV_ID_JSP_N      0x4DE0  /* Jasper Lake Point N */
+
 #define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
 
 #define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index c14261d735db..2711451b3d87 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -106,6 +106,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_JSP_N, MEI_ME_PCH15_CFG)},
+
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC_4, MEI_ME_PCH8_CFG)},
 
-- 
2.25.0


