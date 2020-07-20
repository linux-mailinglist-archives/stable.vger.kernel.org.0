Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD87226845
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388050AbgGTQM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388046AbgGTQM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:12:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544022176B;
        Mon, 20 Jul 2020 16:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261577;
        bh=C1U1PmMo0YTldV1XKI6BtQHf31Kwn3NBrgyuxgxwsqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+UTIC6KDYtZSjSPPhMDL6W5GBEwe5k420EHEKAIHtUPxg6bAs4vgDGwxBD+JvqrL
         Yy0Vmdu2JoBZT2oA5q/kgCaa2xRFNBJZiNCriYkMTHdHC2qvXho10PHPTCLhGul9jF
         /FDq6DmhDiVq96tIQM/QmxoJ56tS0wCU95I5pPqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Moura <imphilippini@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.7 166/244] USB: serial: ch341: add new Product ID for CH340
Date:   Mon, 20 Jul 2020 17:37:17 +0200
Message-Id: <20200720152833.738122288@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Moura <imphilippini@gmail.com>

commit 5d0136f8e79f8287e6a36780601f0ce797cf11c2 upstream.

Add PID for CH340 that's found on some ESP8266 dev boards made by
LilyGO. The specific device that contains such serial converter can be
seen here: https://github.com/LilyGO/LILYGO-T-OI.

Apparently, it's a regular CH340, but I've confirmed with others that
also bought this board that the PID found on this device (0x7522)
differs from other devices with the "same" converter (0x7523).
Simply adding its PID to the driver and rebuilding it made it work
as expected.

Signed-off-by: Igor Moura <imphilippini@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ch341.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -77,6 +77,7 @@
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
+	{ USB_DEVICE(0x1a86, 0x7522) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
 	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ },


