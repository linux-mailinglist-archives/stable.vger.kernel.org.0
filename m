Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB5263C7
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 14:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbfEVM12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 08:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfEVM11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 08:27:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A502173C;
        Wed, 22 May 2019 12:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558528047;
        bh=Vfvgt2d0YFneQ3Uvscjw1lRG6L1fUlWEr2lsflljUKs=;
        h=Subject:To:From:Date:From;
        b=Eolb0NvqAJQ7LMoqzT2951UjvQzw1PVNhi3gtg/0N+pHxWCWxA0HW/GkvmsTUKbBz
         YpYe9IU62YeBFazPGN/M3oHHUgqE1/UlylNcSva7zrE+ulLKzz55Xzd/9huHUD8XQ/
         vUD6+171o+Gvp4ny+1Razo1W0aXBNmIdlphIR0nc=
Subject: patch "media: usb: siano: Fix false-positive "uninitialized variable"" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        lkp@intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 May 2019 14:27:24 +0200
Message-ID: <15585280444124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    media: usb: siano: Fix false-positive "uninitialized variable"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 45457c01171fd1488a7000d1751c06ed8560ee38 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 21 May 2019 11:38:07 -0400
Subject: media: usb: siano: Fix false-positive "uninitialized variable"
 warning

GCC complains about an apparently uninitialized variable recently
added to smsusb_init_device().  It's a false positive, but to silence
the warning this patch adds a trivial initialization.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: kbuild test robot <lkp@intel.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/siano/smsusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 27ad14a3f831..59b3c124b49d 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -400,7 +400,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	struct smsusb_device_t *dev;
 	void *mdev;
 	int i, rc;
-	int in_maxp;
+	int in_maxp = 0;
 
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);
-- 
2.21.0


