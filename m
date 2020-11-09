Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611CB2AB940
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbgKINH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:07:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730793AbgKINH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:07:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A4DF20789;
        Mon,  9 Nov 2020 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927244;
        bh=VgnJCjlJ2hf5cNQLvT6/hybYLjxaRj6Ym08C0rN/G0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HH6h0lg8cyq0/tEJp7gAe7gfTQIine4gsoAi5/d5RBP2rSn/dImATNzXFVM0jEQkX
         5IckznPXrUwq4NV5hDNX5n9nIvR3cGS+2HrmWSDEbt3xI0gzoSLIbzOosn1BmQyVIF
         OTrgkp7UzUfp2t3ANO4kV27uGHRfFHIsof16FKbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 42/48] USB: serial: option: add Telit FN980 composition 0x1055
Date:   Mon,  9 Nov 2020 13:55:51 +0100
Message-Id: <20201109125018.836008938@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit db0362eeb22992502764e825c79b922d7467e0eb upstream.

Add the following Telit FN980 composition:

0x1055: tty, adb, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20201103124425.12940-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1194,6 +1194,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1054, 0xff),	/* Telit FT980-KS */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1055, 0xff),	/* Telit FN980 (PCIe) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),


