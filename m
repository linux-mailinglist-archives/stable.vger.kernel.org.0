Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBBE72B5D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 11:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfGXJ22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 05:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfGXJ22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 05:28:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30ADB20651;
        Wed, 24 Jul 2019 09:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563960507;
        bh=3qW2Wj/6EalUBF3ENChGWZva0DzQ8E7KPFlNgQ8Eh6I=;
        h=Subject:To:From:Date:From;
        b=Ty23ZXnhfU6KBRNcTQIRH6gjrHyP28OGv6h17y4DnB2BQPKWIBlYgpZynbuVi59ih
         TgVqtfkY5P7u2OpnvFxhfEhZk8iKeuET10R9J0MTB6Ee62nim55VGlQmq3V5cgP1WX
         P7LRuHbff+P+JsgOXzksO/myYEU4tDILv6X+xUGo=
Subject: patch "mei: me: add mule creek canyon (EHL) device ids" added to char-misc-linus
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jul 2019 11:28:25 +0200
Message-ID: <1563960505179217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add mule creek canyon (EHL) device ids

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1be8624a0cbef720e8da39a15971e01abffc865b Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Fri, 12 Jul 2019 12:58:14 +0300
Subject: mei: me: add mule creek canyon (EHL) device ids

Add Mule Creek Canyon (PCH) MEI device ids for Elkhart Lake (EHL) Platform.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190712095814.20746-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 3 +++
 drivers/misc/mei/pci-me.c     | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index d74b182e19f3..6c0173772162 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -81,6 +81,9 @@
 
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
+#define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
+#define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
+
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 7a2b3545a7f9..57cb68f5cc64 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -98,6 +98,9 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC_4, MEI_ME_PCH8_CFG)},
+
 	/* required last entry */
 	{0, }
 };
-- 
2.22.0


