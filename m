Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D955498088
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 18:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfHUQqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 12:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbfHUQqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 12:46:52 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22E4233A0;
        Wed, 21 Aug 2019 16:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566406012;
        bh=1bz5Ir3S60L3TWFzA0Cdp5dK3FY67hGsbD7HA8HstDs=;
        h=Subject:To:From:Date:From;
        b=bg61HH1yk9ID4oA9h9dCXo925as1rOC2TvSGE/wGrw48ipc/XmFaOCn4bboBjwyP0
         0vRUfQ3Sp9wwVRfraNmCLGphKqT3HY5ooXdtp8ycehWI+E0GzDzbEC1fSKxUiVLNNm
         2KbJsxGt6WlkDoSBGzZ0VnI935t8Pu0y2CkHiWVc=
Subject: patch "usb-storage: Add new JMS567 revision to unusual_devs" added to usb-linus
To:     opensource@henkvdlaan.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Aug 2019 09:46:45 -0700
Message-ID: <156640600517712@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb-storage: Add new JMS567 revision to unusual_devs

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 08d676d1685c2a29e4d0e1b0242324e564d4589e Mon Sep 17 00:00:00 2001
From: Henk van der Laan <opensource@henkvdlaan.com>
Date: Fri, 16 Aug 2019 22:08:47 +0200
Subject: usb-storage: Add new JMS567 revision to unusual_devs

Revision 0x0117 suffers from an identical issue to earlier revisions,
therefore it should be added to the quirks list.

Signed-off-by: Henk van der Laan <opensource@henkvdlaan.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190816200847.21366-1-opensource@henkvdlaan.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index ea0d27a94afe..1cd9b6305b06 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2100,7 +2100,7 @@ UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x0201,
 		US_FL_IGNORE_RESIDUE ),
 
 /* Reported by Michael Büsch <m@bues.ch> */
-UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0116,
+UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0117,
 		"JMicron",
 		"USB to ATA/ATAPI Bridge",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-- 
2.23.0


