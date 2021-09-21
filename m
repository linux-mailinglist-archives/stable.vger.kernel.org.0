Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2041357F
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhIUOkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233606AbhIUOkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 10:40:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2062460F6E;
        Tue, 21 Sep 2021 14:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632235114;
        bh=3X9R1GxKu+RVejR/imSEM3k4LoW6cBKqINCxBWYISAM=;
        h=Subject:To:From:Date:From;
        b=r8Ij+dinbDaD5qMtNtcq/guyD9kz7D5ccUDMh7NxNQWqqdi3P3gDSZnwrqYDDwd0U
         QnTiT3LVXfUDvEQ1blp7N1+7MQY08yOOwBAzMaxA90ib80ojiLdpXg+yWVEfClT3/C
         /5azrEfKqBu9kJa5RrFTVOP2LH9D+X7CXlFMqyC4=
Subject: patch "Re-enable UAS for LaCie Rugged USB3-FW with fk quirk" added to usb-linus
To:     belegdol@gmail.com, belegdol+github@gmail.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, oneukum@suse.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Sep 2021 16:38:29 +0200
Message-ID: <163223510958110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Re-enable UAS for LaCie Rugged USB3-FW with fk quirk

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ce1c42b4dacfe7d71c852d8bf3371067ccba865c Mon Sep 17 00:00:00 2001
From: Julian Sikorski <belegdol@gmail.com>
Date: Mon, 13 Sep 2021 20:14:55 +0200
Subject: Re-enable UAS for LaCie Rugged USB3-FW with fk quirk

Further testing has revealed that LaCie Rugged USB3-FW does work with
uas as long as US_FL_NO_REPORT_OPCODES and US_FL_NO_SAME are enabled.

Link: https://lore.kernel.org/linux-usb/2167ea48-e273-a336-a4e0-10a4e883e75e@redhat.com/
Cc: stable <stable@vger.kernel.org>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Julian Sikorski <belegdol+github@gmail.com>
Link: https://lore.kernel.org/r/20210913181454.7365-1-belegdol+github@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index c35a6db993f1..4051c8cd0cd8 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -50,7 +50,7 @@ UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x9999,
 		"LaCie",
 		"Rugged USB3-FW",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_IGNORE_UAS),
+		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
-- 
2.33.0


