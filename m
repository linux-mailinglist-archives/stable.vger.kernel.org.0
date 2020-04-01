Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A61719B163
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbgDAQeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387687AbgDAQeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:34:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 551BE20772;
        Wed,  1 Apr 2020 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758876;
        bh=oGFDckR2TBmji8ob8AwdRWoVL7cZrdBE6BwdymPeHfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvzA0zFont59Sf+KfVnfZRpDENVFXOg6s6qVK67Zpt5UOYAuB4TuDdKgLykwy7ow7
         Pb7PN8Im3exVvn0stbo215tQXkvRe69TswJQ1aYjBMU0RnM7S4ZeZwZH/NfKQMXaaZ
         deB2YiW14QXt+0tOIh0hJ5IuU6+nuSqimPdMabok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 010/102] USB: serial: option: add ME910G1 ECM composition 0x110b
Date:   Wed,  1 Apr 2020 18:17:13 +0200
Message-Id: <20200401161533.706422614@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 8e852a7953be2a6ee371449f7257fe15ace6a1fc upstream.

Add ME910G1 ECM composition 0x110b: tty, tty, tty, ecm

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20200304104310.2938-1-dnlplm@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1172,6 +1172,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x110a, 0xff),	/* Telit ME910G1 */
 	  .driver_info = NCTRL(0) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x110b, 0xff),	/* Telit ME910G1 (ECM) */
+	  .driver_info = NCTRL(0) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910_USBCFG4),


