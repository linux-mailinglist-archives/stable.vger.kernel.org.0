Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D1A226A8E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbgGTPxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbgGTPxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:53:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02B5E2064B;
        Mon, 20 Jul 2020 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260424;
        bh=0ji6eib8q5U3rhb+GUmn2EAz5zZ5tEvF5B1C7t3NArA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaDvpjexoqE1xaAf9QOUmVekDkthS+C78ulEUO+a8P/cgpZxqyplhCBMPNgze0tp1
         B9cxmrkPst+HQ6lPlTEDNrwjsYL5oT4/PM0rn1T1amJOnOee06gdGsvKplTWLdoeMN
         fWer79OCpHb8Jw9PSouxurK0cVzFVyaZvj+fWgpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Moura <imphilippini@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 096/133] USB: serial: ch341: add new Product ID for CH340
Date:   Mon, 20 Jul 2020 17:37:23 +0200
Message-Id: <20200720152808.368425348@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
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
@@ -81,6 +81,7 @@
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
+	{ USB_DEVICE(0x1a86, 0x7522) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
 	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ },


