Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE43A619C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhFNKtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233976AbhFNKrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A566134F;
        Mon, 14 Jun 2021 10:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667035;
        bh=/Q5WdtpSZfFi/+U+Do3WtbdtGOxfV9Wlx5KDosErhf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0cVRMl7MjFaKEGm0AYkWq/U2IVCHcYPneHwlFJhwPNjsikDUA/kwSswG0FVSmvHnt
         lERwAAwmOKVy9Sa488oaU4PNJOviC2d7AklqUlHGX+F397oy52706T7K8iNyYqvxoc
         Y5wNs0fwgNjuBlV3dBsc6AVsmXvwHLNO5AP9eWaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre GRIVEAUX <agriveaux@deutnet.info>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 43/67] USB: serial: omninet: add device id for Zyxel Omni 56K Plus
Date:   Mon, 14 Jun 2021 12:27:26 +0200
Message-Id: <20210614102645.252748382@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
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
@@ -26,6 +26,7 @@
 
 #define ZYXEL_VENDOR_ID		0x0586
 #define ZYXEL_OMNINET_ID	0x1000
+#define ZYXEL_OMNI_56K_PLUS_ID	0x1500
 /* This one seems to be a re-branded ZyXEL device */
 #define BT_IGNITIONPRO_ID	0x2000
 
@@ -40,6 +41,7 @@ static int omninet_port_remove(struct us
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(ZYXEL_VENDOR_ID, ZYXEL_OMNINET_ID) },
+	{ USB_DEVICE(ZYXEL_VENDOR_ID, ZYXEL_OMNI_56K_PLUS_ID) },
 	{ USB_DEVICE(ZYXEL_VENDOR_ID, BT_IGNITIONPRO_ID) },
 	{ }						/* Terminating entry */
 };


