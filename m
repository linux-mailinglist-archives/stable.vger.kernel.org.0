Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6621BA0B8D
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 22:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfH1Uc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 16:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfH1Uc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 16:32:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C67A022CED;
        Wed, 28 Aug 2019 20:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567024346;
        bh=IwMAe9LiAvAfkm2kMq8E28YuLf+UWOZVAqNdjscg6Jc=;
        h=Subject:To:From:Date:From;
        b=aV3B/9U2+jtJG2y4xsAbCWzi6jevWyPZu1pYc0ftAGAe310Tc+E6d2oqGJ6ibf3Pm
         Rh+zcrpkfSPFwb1xqGkaVEopNK8A9DghY+FL2C2omTVrsM9ofHKHXjZEn2lVxpV9wa
         TFLa0NimSAVaHceTZ5J1+rNEHqjHNvVoI4j9Zl4g=
Subject: patch "mei: me: add Tiger Lake point LP device ID" added to char-misc-linus
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Aug 2019 22:32:23 +0200
Message-ID: <156702434337101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add Tiger Lake point LP device ID

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 587f17407741a5be07f8a2d1809ec946c8120962 Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Mon, 19 Aug 2019 13:32:10 +0300
Subject: mei: me: add Tiger Lake point LP device ID

Add Tiger Lake Point device ID for TGP LP.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190819103210.32748-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 2 ++
 drivers/misc/mei/pci-me.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 6c0173772162..77f7dff7098d 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -81,6 +81,8 @@
 
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
+#define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
+
 #define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
 #define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 57cb68f5cc64..541538eff8b1 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -98,6 +98,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH12_CFG)},
+
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC, MEI_ME_PCH12_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MCC_4, MEI_ME_PCH8_CFG)},
 
-- 
2.23.0


