Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912E3137D7F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgAKJ62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:58:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729051AbgAKJ62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:58:28 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D29AC2077C;
        Sat, 11 Jan 2020 09:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736707;
        bh=yxO19RkpbpT6xRpMIbMXZhoy5cZeZcVraSfibN4vxIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sg2dfAlM/ZoVcFHTHdnLUQQs7rrt354aMc1KFnAkIudVmhKSrLSnFXeT5CwPe1sF8
         qeL9Y981TkzR0iWkXL4diwRGvtknzOqhdVjUWD18kGp57OU+hOsijUlt22FyNy67S7
         15v5Y/A+hFtBwqzW48PdvRz9vxDWoYPSn3p2HQZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 59/59] USB: serial: option: add Telit ME910G1 0x110a composition
Date:   Sat, 11 Jan 2020 10:50:08 +0100
Message-Id: <20200111094854.319738883@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 0d3010fa442429f8780976758719af05592ff19f upstream.

This patch adds the following Telit ME910G1 composition:

0x110a: tty, tty, tty, rmnet

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1167,6 +1167,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1102, 0xff),	/* Telit ME910 (ECM) */
 	  .driver_info = NCTRL(0) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x110a, 0xff),	/* Telit ME910G1 */
+	  .driver_info = NCTRL(0) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910_USBCFG4),


