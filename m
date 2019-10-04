Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3557BCBB7B
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387952AbfJDNSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 09:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387917AbfJDNSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 09:18:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 483F6215EA;
        Fri,  4 Oct 2019 13:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570195129;
        bh=4qrUsSRueHNHKZVWSRTEWTBvTTCtbbVBsKQOxuHrSIg=;
        h=Subject:To:From:Date:From;
        b=OG4hYEcJKpv2E0TzA/2sdqQDWeW3KLa3ZBAK9uu0pruPwLqSisP0k06kb7gYic2Jn
         IUi7iqnhvPyiqIcbbtVkijPe8QCve7bM0wW5BMFIfWhE8+l5xjtMb/FShE9GLvENiJ
         jfTrWHHNCMKhAMFaV5oYf2DWZXdoqN5dt8ipq/Ew=
Subject: patch "mei: me: add comet point (lake) LP device ids" added to char-misc-linus
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 15:18:47 +0200
Message-ID: <1570195127106170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add comet point (lake) LP device ids

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4d86dfd38285c83a6df01093b8547f742e3b2470 Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Wed, 2 Oct 2019 02:59:57 +0300
Subject: mei: me: add comet point (lake) LP device ids

Add Comet Point devices IDs for Comet Lake U platforms.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191001235958.19979-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 3 +++
 drivers/misc/mei/pci-me.c     | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 77f7dff7098d..c09f8bb49495 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -79,6 +79,9 @@
 #define MEI_DEV_ID_CNP_H      0xA360  /* Cannon Point H */
 #define MEI_DEV_ID_CNP_H_4    0xA364  /* Cannon Point H 4 (iTouch) */
 
+#define MEI_DEV_ID_CMP_LP     0x02e0  /* Comet Point LP */
+#define MEI_DEV_ID_CMP_LP_3   0x02e4  /* Comet Point LP 3 (iTouch) */
+
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
 
 #define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index d5a92c6eadb3..775a2090c2ac 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -96,6 +96,9 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_H, MEI_ME_PCH12_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_H_4, MEI_ME_PCH8_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP_3, MEI_ME_PCH8_CFG)},
+
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH12_CFG)},
-- 
2.23.0


