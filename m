Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8300245DFB6
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349430AbhKYRcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237447AbhKYRaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 12:30:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 017FA610E8;
        Thu, 25 Nov 2021 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637861231;
        bh=fZF8LLrmMiY6B7Z2ZgVKagtr24N2vYI3hCg8jD4c+LQ=;
        h=Subject:To:From:Date:From;
        b=n3ki7dtSwV6I89LHoZjcXUz+pfZbO4F6dbqWBTHTUIFXWWIQlJJRUGUIkurppNT5T
         kMz3JsrjbgXYN1LH6XY7CvtvHFCfqCe2djblQaYzj7TO9+SjausPUCm7DbPZgjGonT
         AnUCXrAY60avoos69wOxY2RpYvad4U0YUIwPn1Ig=
Subject: patch "serial: pl011: Add ACPI SBSA UART match id" added to tty-linus
To:     Pierre.Gondois@arm.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Nov 2021 18:26:58 +0100
Message-ID: <1637861218206210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: pl011: Add ACPI SBSA UART match id

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ac442a077acf9a6bf1db4320ec0c3f303be092b3 Mon Sep 17 00:00:00 2001
From: Pierre Gondois <Pierre.Gondois@arm.com>
Date: Tue, 9 Nov 2021 17:22:48 +0000
Subject: serial: pl011: Add ACPI SBSA UART match id

The document 'ACPI for Arm Components 1.0' defines the following
_HID mappings:
-'Prime cell UART (PL011)': ARMH0011
-'SBSA UART': ARMHB000

Use the sbsa-uart driver when a device is described with
the 'ARMHB000' _HID.

Note:
PL011 devices currently use the sbsa-uart driver instead of the
uart-pl011 driver. Indeed, PL011 devices are not bound to a clock
in ACPI. It is not possible to change their baudrate.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pierre Gondois <Pierre.Gondois@arm.com>
Link: https://lore.kernel.org/r/20211109172248.19061-1-Pierre.Gondois@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index d361cd84ff8c..52518a606c06 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2947,6 +2947,7 @@ MODULE_DEVICE_TABLE(of, sbsa_uart_of_match);
 
 static const struct acpi_device_id __maybe_unused sbsa_uart_acpi_match[] = {
 	{ "ARMH0011", 0 },
+	{ "ARMHB000", 0 },
 	{},
 };
 MODULE_DEVICE_TABLE(acpi, sbsa_uart_acpi_match);
-- 
2.34.0


