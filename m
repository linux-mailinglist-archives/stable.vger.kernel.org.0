Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAE63A6025
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhFNKbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232926AbhFNKbj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:31:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FECA61004;
        Mon, 14 Jun 2021 10:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666565;
        bh=ffnJT3aMVqI0dolVHoYIXBOTKwyMvCNA5Z8XNCl3N/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k607HOKXJq41WPjwO4J3K4gvbY4UOA4KXvsUD7D0JOg9ic5yrYRnm6zFBZwpXm6Mp
         8Imsk12WClMdc8/uP2X4nTey6DdnOkQU8tHck0UF3UcdJsoiCgmUll96z8sj7P9BvV
         IEyJ1Ylm7uRO+4WwliwI/rpjMNsFjmt/xA8oX3FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre GRIVEAUX <agriveaux@deutnet.info>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 25/34] USB: serial: omninet: add device id for Zyxel Omni 56K Plus
Date:   Mon, 14 Jun 2021 12:27:16 +0200
Message-Id: <20210614102642.387998905@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre GRIVEAUX <agriveaux@deutnet.info>

commit fc0b3dc9a11771c3919eaaaf9d649138b095aa0f upstream.

Add device id for Zyxel Omni 56K Plus modem, this modem include:

USB chip:
NetChip
NET2888

Main chip:
901041A
F721501APGF

Another modem using the same chips is the Zyxel Omni 56K DUO/NEO,
could be added with the right USB ID.

Signed-off-by: Alexandre GRIVEAUX <agriveaux@deutnet.info>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/omninet.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -27,6 +27,7 @@
 
 #define ZYXEL_VENDOR_ID		0x0586
 #define ZYXEL_OMNINET_ID	0x1000
+#define ZYXEL_OMNI_56K_PLUS_ID	0x1500
 /* This one seems to be a re-branded ZyXEL device */
 #define BT_IGNITIONPRO_ID	0x2000
 
@@ -44,6 +45,7 @@ static int omninet_port_remove(struct us
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(ZYXEL_VENDOR_ID, ZYXEL_OMNINET_ID) },
+	{ USB_DEVICE(ZYXEL_VENDOR_ID, ZYXEL_OMNI_56K_PLUS_ID) },
 	{ USB_DEVICE(ZYXEL_VENDOR_ID, BT_IGNITIONPRO_ID) },
 	{ }						/* Terminating entry */
 };


