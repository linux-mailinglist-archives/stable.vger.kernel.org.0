Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC412D6608
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404224AbgLJTJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390466AbgLJObA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:31:00 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan-Niklas Burfeind <kernel@aiyionpri.me>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 24/45] USB: serial: ch341: add new Product ID for CH341A
Date:   Thu, 10 Dec 2020 15:26:38 +0100
Message-Id: <20201210142603.554267227@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan-Niklas Burfeind <kernel@aiyionpri.me>

commit 46ee4abb10a07bd8f8ce910ee6b4ae6a947d7f63 upstream.

Add PID for CH340 that's found on a ch341 based Programmer made by keeyees.
The specific device that contains the serial converter is described
here: http://www.keeyees.com/a/Products/ej/36.html

The driver works flawlessly as soon as the new PID (0x5512) is added to
it.

Signed-off-by: Jan-Niklas Burfeind <kernel@aiyionpri.me>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ch341.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -73,6 +73,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7522) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x1a86, 0x5512) },
 	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ },
 };


