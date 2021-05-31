Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B013961C1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbhEaOpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232139AbhEaOnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:43:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57A1F61C76;
        Mon, 31 May 2021 13:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469268;
        bh=uDpj/P5AG1X7x0A+XoSTTT9exReZKWywYoH9o65yxmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wi6VBEG528t7yyNW0xAfpBg9Gcurssx2vCkDTT4LjRRFF30ha149qdsDZ6VWaBTeG
         zrI+C5LLDFiyTR80S7e7D9fj/Yz3UUSN6LskhASOPrd5Jfj8wU2wbYGpBqTLOOci/M
         CtlleIybL5gjZ62VhEw6JjlPOeG+FMUyld+31iIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 099/296] USB: serial: option: add Telit LE910-S1 compositions 0x7010, 0x7011
Date:   Mon, 31 May 2021 15:12:34 +0200
Message-Id: <20210531130707.241738496@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit e467714f822b5d167a7fb03d34af91b5b6af1827 upstream.

Add support for the following Telit LE910-S1 compositions:

0x7010: rndis, tty, tty, tty
0x7011: ecm, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20210428072634.5091-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1240,6 +1240,10 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1901, 0xff),	/* Telit LN940 (MBIM) */
 	  .driver_info = NCTRL(0) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x7010, 0xff),	/* Telit LE910-S1 (RNDIS) */
+	  .driver_info = NCTRL(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x7011, 0xff),	/* Telit LE910-S1 (ECM) */
+	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9010),				/* Telit SBL FN980 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */


