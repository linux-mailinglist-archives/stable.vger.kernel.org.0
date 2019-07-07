Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1DE6170D
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfGGToq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:44:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57148 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727530AbfGGTiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:07 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0006gU-Nr; Sun, 07 Jul 2019 20:38:02 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0005a9-Bm; Sun, 07 Jul 2019 20:38:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Ivan Mironov" <mironov.ivan@gmail.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.254723399@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 048/129] USB: serial: cp210x: add ID for Ingenico 3070
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Mironov <mironov.ivan@gmail.com>

commit dd9d3d86b08d6a106830364879c42c78db85389c upstream.

Here is how this device appears in kernel log:

	usb 3-1: new full-speed USB device number 18 using xhci_hcd
	usb 3-1: New USB device found, idVendor=0b00, idProduct=3070
	usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
	usb 3-1: Product: Ingenico 3070
	usb 3-1: Manufacturer: Silicon Labs
	usb 3-1: SerialNumber: 0001

Apparently this is a POS terminal with embedded USB-to-Serial converter.

Signed-off-by: Ivan Mironov <mironov.ivan@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -57,6 +57,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
 	{ USB_DEVICE(0x0908, 0x01FF) }, /* Siemens RUGGEDCOM USB Serial Console */
+	{ USB_DEVICE(0x0B00, 0x3070) }, /* Ingenico 3070 */
 	{ USB_DEVICE(0x0BED, 0x1100) }, /* MEI (TM) Cashflow-SC Bill/Voucher Acceptor */
 	{ USB_DEVICE(0x0BED, 0x1101) }, /* MEI series 2000 Combo Acceptor */
 	{ USB_DEVICE(0x0FCF, 0x1003) }, /* Dynastream ANT development board */

