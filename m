Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B7F3602D1
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 08:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhDOG6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 02:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhDOG6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 02:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09B5C61153;
        Thu, 15 Apr 2021 06:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618469865;
        bh=xf8saM1KqWBC8HK6H5BYcxiqujUxADEyDnLvDWswbG8=;
        h=Subject:To:From:Date:From;
        b=kUHTrzKAAEghL369S7pPTPTT6+D1cNpWN77Cw3wChlFygII2foDcP0Z8OmmYVNtHz
         8ObjL/9aGIlHn7paD9pjbwuoabm6rjzJzTILzs1ABDoaFhn9lNQ58phMTu2WLpTwYF
         vZpKhu5x0NeCRd/uya6wqAUBTR8x4SRqG628KvaY=
Subject: patch "mei: me: add Alder Lake P device id." added to char-misc-next
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 08:57:23 +0200
Message-ID: <16184698433967@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add Alder Lake P device id.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 0df74278faedf20f9696bf2755cf0ce34afa4c3a Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Wed, 14 Apr 2021 07:52:00 +0300
Subject: mei: me: add Alder Lake P device id.

Add Alder Lake P device ID.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210414045200.3498241-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h | 1 +
 drivers/misc/mei/pci-me.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 14be76d4c2e6..cb34925e10f1 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -105,6 +105,7 @@
 
 #define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
 #define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
+#define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
 
 /*
  * MEI HW Section
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a7e179626b63..c3393b383e59 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -111,6 +111,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }
-- 
2.31.1


