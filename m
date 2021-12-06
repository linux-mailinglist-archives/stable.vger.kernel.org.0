Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA287469AA8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346795AbhLFPJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:09:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38854 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346796AbhLFPHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:07:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 495A6B81138;
        Mon,  6 Dec 2021 15:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD1AC341C1;
        Mon,  6 Dec 2021 15:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803045;
        bh=pFou4No0NsqNzTd9qobksgHkoogBs1a3o65fi4dOqs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNyQO/bIRM47OeTnbuRlxswo5LxkNhzZAmkZIfeI47fbXNeAc9yH9ba80qDNyLOkO
         fNiq+YlYck7rKDSrXpKJXUqAPrDHKYMsRafGsBrpWnpjcajh4Fn5FWBa7/1rpLod/E
         OH2GXvSXEtYagOE625gsIUyB+h1xUgx4CvnF8b3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 001/106] USB: serial: option: add Telit LE910S1 0x9200 composition
Date:   Mon,  6 Dec 2021 15:55:09 +0100
Message-Id: <20211206145555.449308024@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit e353f3e88720300c3d72f49a4bea54f42db1fa5e upstream.

Add the following Telit LE910S1 composition:

0x9200: tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20211119140319.10448-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1270,6 +1270,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9010),				/* Telit SBL FN980 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
+	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9200),				/* Telit LE910S1 flashing device */
+	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) },


