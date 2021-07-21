Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DE73D0DD8
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbhGUKxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 06:53:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239632AbhGUKT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 06:19:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A2A608FE;
        Wed, 21 Jul 2021 10:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626864993;
        bh=R4UHaF8rCJwMyvxt2JM7z0jG/U4CvzvB2MMQ+bOOLzw=;
        h=Subject:To:From:Date:From;
        b=zCsFmIsDCYNtIOxZPSb33a5wlcGdpJfG/WMvlbHQKV9n1jMGjEaWLyOhNG2LS3X+X
         oyYKBF4AaxMEShKrpvWlN2OZm3YpidfN39Q7oPxS97ZxdxJ1oDtb4dPH3yPoctMo3u
         P2KICcmW9YL0U/8j2FgdKhPdMoz+Z8RVJlwhmZMc=
Subject: patch "serial: 8250_pci: Enumerate Elkhart Lake UARTs via dedicated driver" added to tty-linus
To:     andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 12:56:31 +0200
Message-ID: <1626864991139225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_pci: Enumerate Elkhart Lake UARTs via dedicated driver

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7f0909db761535aefafa77031062603a71557267 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 13 Jul 2021 13:17:39 +0300
Subject: serial: 8250_pci: Enumerate Elkhart Lake UARTs via dedicated driver

Elkhart Lake UARTs are PCI enumerated Synopsys DesignWare v4.0+ UART
integrated with Intel iDMA 32-bit DMA controller. There is a specific
driver to handle them, i.e. 8250_lpss. Hence, disable 8250_pci
enumeration for these UARTs.

Fixes: 1b91d97c66ef ("serial: 8250_lpss: Add ->setup() for Elkhart Lake ports")
Fixes: 4f912b898dc2 ("serial: 8250_lpss: Enable HS UART on Elkhart Lake")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210713101739.36962-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 75827b608fdb..02985cf90ef2 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -3836,6 +3836,12 @@ static const struct pci_device_id blacklist[] = {
 	{ PCI_VDEVICE(INTEL, 0x0f0c), },
 	{ PCI_VDEVICE(INTEL, 0x228a), },
 	{ PCI_VDEVICE(INTEL, 0x228c), },
+	{ PCI_VDEVICE(INTEL, 0x4b96), },
+	{ PCI_VDEVICE(INTEL, 0x4b97), },
+	{ PCI_VDEVICE(INTEL, 0x4b98), },
+	{ PCI_VDEVICE(INTEL, 0x4b99), },
+	{ PCI_VDEVICE(INTEL, 0x4b9a), },
+	{ PCI_VDEVICE(INTEL, 0x4b9b), },
 	{ PCI_VDEVICE(INTEL, 0x9ce3), },
 	{ PCI_VDEVICE(INTEL, 0x9ce4), },
 
-- 
2.32.0


