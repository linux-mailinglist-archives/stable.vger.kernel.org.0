Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708302ABBC7
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbgKINak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:30:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732170AbgKINKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:10:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9607120663;
        Mon,  9 Nov 2020 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927444;
        bh=oIzrjqALwh4CjykziVsw6dBqKuXuoY1y0StWWD4AfAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baq2G7MdUms/bPiYGKGHlYIWOdNzoCJsoF5HLrau1n6Lffrcr+vzPkqZPPv2nmm7X
         M6SpXTeqxo7h+s433CaNg9BAqu9Mrk6GxX/8o7Ul4knl+1KNgkXHOeJ5J1yWI/n456
         J2QdZWkUKpTYj3eaks1wnuwAv0beXjTlWavH5Ci8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ziyi Cao <kernel@septs.pw>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 60/71] USB: serial: option: add Quectel EC200T module support
Date:   Mon,  9 Nov 2020 13:55:54 +0100
Message-Id: <20201109125022.735359786@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyi Cao <kernel@septs.pw>

commit a46b973bced1ba57420752bf38426acd9f6cbfa6 upstream.

Add usb product id of the Quectel EC200T module.

Signed-off-by: Ziyi Cao <kernel@septs.pw>
Link: https://lore.kernel.org/r/17f8a2a3-ce0f-4be7-8544-8fdf286907d0@www.fastmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -250,6 +250,7 @@ static void option_instat_callback(struc
 #define QUECTEL_PRODUCT_EP06			0x0306
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
+#define QUECTEL_PRODUCT_EC200T			0x6026
 
 #define CMOTECH_VENDOR_ID			0x16d8
 #define CMOTECH_PRODUCT_6001			0x6001
@@ -1117,6 +1118,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x10),
 	  .driver_info = ZLP },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
 
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },


