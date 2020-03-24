Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494E81905A1
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 07:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCXGSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 02:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727290AbgCXGSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 02:18:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 574CE20663;
        Tue, 24 Mar 2020 06:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585030699;
        bh=pRGf+6QGpDRyff9oF/oQh+kf29KcFfdy1O589+Zuz8I=;
        h=Subject:To:From:Date:From;
        b=Ddb37sdPpsVMJu21jFc4EWRDSL5ZdMrFluk0oJz3Tq6J0SynBQ9FtI6n6AKK07eHK
         Z7XnDPip8QLFcGdINLSTF1QukOSrO0GH9n4qAY2wXktpnlztyzQIHz+dBQ5X6vJP4a
         XaLua3ru11DtoaQfZVcqXT1jN7SNjPp1+1Mb2bTI=
Subject: patch "staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table" added to staging-next
To:     Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, zraetn@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 24 Mar 2020 07:18:07 +0100
Message-ID: <158503068754196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 38ef48f7d4b7342f145a1b4f96023bde99aeb245 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sat, 21 Mar 2020 13:00:11 -0500
Subject: staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

The ASUS USB-N10 Nano B1 has been reported as a new RTL8188EU device.
Add it to the device tables.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: kovi <zraetn@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200321180011.26153-1-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 845c8817281c..f7f09c0d273f 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -32,6 +32,7 @@ static const struct usb_device_id rtw_usb_id_tbl[] = {
 	/****** 8188EUS ********/
 	{USB_DEVICE(0x056e, 0x4008)}, /* Elecom WDC-150SU2M */
 	{USB_DEVICE(0x07b8, 0x8179)}, /* Abocom - Abocom */
+	{USB_DEVICE(0x0B05, 0x18F0)}, /* ASUS USB-N10 Nano B1 */
 	{USB_DEVICE(0x2001, 0x330F)}, /* DLink DWA-125 REV D1 */
 	{USB_DEVICE(0x2001, 0x3310)}, /* Dlink DWA-123 REV D1 */
 	{USB_DEVICE(0x2001, 0x3311)}, /* DLink GO-USB-N150 REV B1 */
-- 
2.25.2


