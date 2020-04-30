Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696FC1BF15A
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 09:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgD3H3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 03:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbgD3H3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 03:29:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1023920757;
        Thu, 30 Apr 2020 07:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588231761;
        bh=qtZEYxaRcxDerPo1Uxaf/LVHKKfUT7RSE444sJ/fnl0=;
        h=Subject:To:From:Date:From;
        b=uha5PtXVaElPUUt6kaEXXbAGazrwvU93FiW4XJvizDh4wIbNoZmyJzrA/yk6Rn/rD
         dtuUgOphTe6A+fNcB0swbk6yjLOsaX2KY13TALa0xSrTmk8e/TIELfZd2nMLPbfL9S
         CcyhXeuaqzmJx562Tpmwu/rcA+2icTdxzxpKhKDI=
Subject: patch "USB: uas: add quirk for LaCie 2Big Quadra" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org, julian.g@posteo.de,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Apr 2020 09:29:19 +0200
Message-ID: <1588231759202104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: uas: add quirk for LaCie 2Big Quadra

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9f04db234af691007bb785342a06abab5fb34474 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Wed, 29 Apr 2020 17:52:18 +0200
Subject: USB: uas: add quirk for LaCie 2Big Quadra
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This device needs US_FL_NO_REPORT_OPCODES to avoid going
through prolonged error handling on enumeration.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: Julian Groß <julian.g@posteo.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200429155218.7308-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 1b23741036ee..37157ed9a881 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -28,6 +28,13 @@
  * and don't forget to CC: the USB development list <linux-usb@vger.kernel.org>
  */
 
+/* Reported-by: Julian Groß <julian.g@posteo.de> */
+UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
+		"LaCie",
+		"2Big Quadra USB3",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there others?
-- 
2.26.2


