Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EEA3EB832
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241932AbhHMPLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241740AbhHMPLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:11:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7BCD61151;
        Fri, 13 Aug 2021 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867444;
        bh=zB0RXeS5YUJu8nzfU5POoJUkV7FzZnicIUJ/4k/aB0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRyhn/64SsJPTlaajqX6b+7j8qGeOxi0PTu2Khyt1BIrRDKhljAQorj3TfqjViEOg
         rHJnlrM62muvF4BT4UQR8h10EJwSfN1vuVkDsiJGmZtjD6q67M4WZKysZElf7iX1me
         paCrn3MezHne0dmUwtEqcaK5BMkO6FW7j3WjHU+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 16/42] USB: serial: option: add Telit FD980 composition 0x1056
Date:   Fri, 13 Aug 2021 17:06:42 +0200
Message-Id: <20210813150525.649094437@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 5648c073c33d33a0a19d0cb1194a4eb88efe2b71 upstream.

Add the following Telit FD980 composition 0x1056:

Cfg #1: mass storage
Cfg #2: rndis, tty, adb, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20210803194711.3036-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1206,6 +1206,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1055, 0xff),	/* Telit FN980 (PCIe) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1056, 0xff),	/* Telit FD980 */
+	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),


