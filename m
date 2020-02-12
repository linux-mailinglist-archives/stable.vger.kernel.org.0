Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C69D15AF24
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 18:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgBLRyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 12:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgBLRyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 12:54:45 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968AD20714;
        Wed, 12 Feb 2020 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581530084;
        bh=QcP43nSyC6tGlKs98fqMxDD4HB8KsBu8G3PxwGV+p5Q=;
        h=Subject:To:From:Date:From;
        b=raNYYjsdIzl3nOfG2MpaMu9kDlDBzK39lTyyn+b9qmqvLsSivRFLtlRbXgfdv5L1H
         r/+A8scl9F8hRm9veT62FfXkdQTQvOwcIszf/PJnoRqs8yTJWiJd3DNb4sDBonJLMv
         bsXuAxzR4syuURTSNUEHenZp1pUFpO2BdPHDRs/M=
Subject: patch "USB: Fix novation SourceControl XL after suspend" added to usb-linus
To:     richard.o.dodd@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 09:54:44 -0800
Message-ID: <15815300843460@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Fix novation SourceControl XL after suspend

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b692056db8ecc7f452b934f016c17348282b7699 Mon Sep 17 00:00:00 2001
From: Richard Dodd <richard.o.dodd@gmail.com>
Date: Wed, 12 Feb 2020 14:22:18 +0000
Subject: USB: Fix novation SourceControl XL after suspend

Currently, the SourceControl will stay in power-down mode after resuming
from suspend. This patch resets the device after suspend to power it up.

Signed-off-by: Richard Dodd <richard.o.dodd@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200212142220.36892-1-richard.o.dodd@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index f27468966a3d..2b24336a72e5 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -449,6 +449,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* novation SoundControl XL */
+	{ USB_DEVICE(0x1235, 0x0061), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	{ }  /* terminating entry must be last */
 };
 
-- 
2.25.0


