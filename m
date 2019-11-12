Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D933F9540
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 17:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKLQMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 11:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfKLQMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 11:12:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48F04206BB;
        Tue, 12 Nov 2019 16:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573575130;
        bh=Tb/IU1NPKoOZlk5QRAsAWeBWIh7wXPztp9Sgjt6EBrY=;
        h=Subject:To:From:Date:From;
        b=Kzme8rat4x2pU5phl08KRR7kRI8KjeIoZbSPbibSyGphpg/V+8jCWAnpZb9AakVNY
         aw8N0Rqzb37zrSafH++CHFax+IRiMUPipveYVrhWbM1h1rFiI5DZlR46RKqrxYZwt0
         5oxMan045+GsF/lgtCN061yRjGbUCq7iQGDZY7cE=
Subject: patch "USBIP: add config dependency for SGL_ALLOC" added to usb-testing
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 Nov 2019 17:12:08 +0100
Message-ID: <157357512816890@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USBIP: add config dependency for SGL_ALLOC

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From eaed19addbc9e60062a26b33c79059f5bb74968b Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 12 Nov 2019 16:49:39 +0100
Subject: USBIP: add config dependency for SGL_ALLOC

USBIP uses lib/scatterlist.h
Hence it needs to set CONFIG_SGL_ALLOC

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191112154939.21217-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/usbip/Kconfig b/drivers/usb/usbip/Kconfig
index 2f86b28fa3da..7bbae7a08642 100644
--- a/drivers/usb/usbip/Kconfig
+++ b/drivers/usb/usbip/Kconfig
@@ -4,6 +4,7 @@ config USBIP_CORE
 	tristate "USB/IP support"
 	depends on NET
 	select USB_COMMON
+	select SGL_ALLOC
 	---help---
 	  This enables pushing USB packets over IP to allow remote
 	  machines direct access to USB devices. It provides the
-- 
2.24.0


