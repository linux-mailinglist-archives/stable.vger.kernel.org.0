Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5FE33BA17
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhCOOH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233671AbhCOOCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 778E764F2E;
        Mon, 15 Mar 2021 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816932;
        bh=IRd2fbfWB7PxKr72oQAlufixyevhTRLq+lbOG35j/Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNxUBgnU/6PH8riaEhkhOaVlM0ebMs4Rr+7wieFmATG+frPy1yki7PpPcrefOKVvv
         RYz7vRxQ0PeUEAr4TksbUGtr0dMqV+zR13cdK6tYyx7ITShr46HnYumk0v40bfzaja
         W211p4X5u4OLnMlA8ANllTHhCDoK3v61wQ9n5s3g=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 211/306] USB: serial: cp210x: add some more GE USB IDs
Date:   Mon, 15 Mar 2021 14:54:34 +0100
Message-Id: <20210315135514.759909335@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Sebastian Reichel <sebastian.reichel@collabora.com>

commit 42213a0190b535093a604945db05a4225bf43885 upstream.

GE CS1000 has some more custom USB IDs for CP2102N; add them
to the driver to have working auto-probing.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -203,6 +203,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1901, 0x0194) },	/* GE Healthcare Remote Alarm Box */
 	{ USB_DEVICE(0x1901, 0x0195) },	/* GE B850/B650/B450 CP2104 DP UART interface */
 	{ USB_DEVICE(0x1901, 0x0196) },	/* GE B850 CP2105 DP UART interface */
+	{ USB_DEVICE(0x1901, 0x0197) }, /* GE CS1000 Display serial interface */
+	{ USB_DEVICE(0x1901, 0x0198) }, /* GE CS1000 M.2 Key E serial interface */
 	{ USB_DEVICE(0x199B, 0xBA30) }, /* LORD WSDA-200-USB */
 	{ USB_DEVICE(0x19CF, 0x3000) }, /* Parrot NMEA GPS Flight Recorder */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */


