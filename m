Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820753D60F0
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhGZPZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238127AbhGZPYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FA3C60E09;
        Mon, 26 Jul 2021 16:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315514;
        bh=K7OHnJW4BgHZ9a/0E1MMg3L+1ZMi58x/jKseUHUL4T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzXhi2Rvqb0IahDfTB8KzkHLehz4mQjX8M20uiYdhAq1PSbWMnGN6wjMHdBQjtvyX
         Ll4i/sPHLU5cvKXeflTzNwkojpp2UKrzPboGPRtQMgqV2LsCQbZMbDrdr3oLWKKYve
         siXT3EdLa1bb2l5pINPPP+5FEXADxLtd9LV4GpGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Ray <ian.ray@ge.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 127/167] USB: serial: cp210x: fix comments for GE CS1000
Date:   Mon, 26 Jul 2021 17:39:20 +0200
Message-Id: <20210726153843.656905917@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Ray <ian.ray@ge.com>

commit e9db418d4b828dd049caaf5ed65dc86f93bb1a0c upstream.

Fix comments for GE CS1000 CP210x USB ID assignments.

Fixes: 42213a0190b5 ("USB: serial: cp210x: add some more GE USB IDs")
Signed-off-by: Ian Ray <ian.ray@ge.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -206,8 +206,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1901, 0x0194) },	/* GE Healthcare Remote Alarm Box */
 	{ USB_DEVICE(0x1901, 0x0195) },	/* GE B850/B650/B450 CP2104 DP UART interface */
 	{ USB_DEVICE(0x1901, 0x0196) },	/* GE B850 CP2105 DP UART interface */
-	{ USB_DEVICE(0x1901, 0x0197) }, /* GE CS1000 Display serial interface */
-	{ USB_DEVICE(0x1901, 0x0198) }, /* GE CS1000 M.2 Key E serial interface */
+	{ USB_DEVICE(0x1901, 0x0197) }, /* GE CS1000 M.2 Key E serial interface */
+	{ USB_DEVICE(0x1901, 0x0198) }, /* GE CS1000 Display serial interface */
 	{ USB_DEVICE(0x199B, 0xBA30) }, /* LORD WSDA-200-USB */
 	{ USB_DEVICE(0x19CF, 0x3000) }, /* Parrot NMEA GPS Flight Recorder */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */


