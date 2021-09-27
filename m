Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4BA419A83
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbhI0RJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236075AbhI0RId (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:08:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 561F861205;
        Mon, 27 Sep 2021 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762406;
        bh=mzdbePaieiHmIvDiCquG0lPil8zrri334tBIs2xTySk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikY18oT0BzSUtFgo1IPhhpjIS6vsQyGXUHreaMFHvKK2Bw4ni7JUhM4VEab/V1CMb
         Inr9WHW0JwPFHV/N7+dbHUCLFfhTFl1u50i7MhhtmjedAT/Wjsr6utp4/xUlDiEg2u
         N/SFscRs2v9b4dhroswNr+jWiyvjrXH7s9hnpi68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Uwe Brandt <uwe.brandt@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 011/103] USB: serial: cp210x: add ID for GW Instek GDM-834x Digital Multimeter
Date:   Mon, 27 Sep 2021 19:01:43 +0200
Message-Id: <20210927170226.103518576@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Brandt <uwe.brandt@gmail.com>

commit 3bd18ba7d859eb1fbef3beb1e80c24f6f7d7596c upstream.

Add the USB serial device ID for the GW Instek GDM-834x Digital Multimeter.

Signed-off-by: Uwe Brandt <uwe.brandt@gmail.com>
Link: https://lore.kernel.org/r/YUxFl3YUCPGJZd8Y@hovoldconsulting.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -237,6 +237,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1FB9, 0x0602) }, /* Lake Shore Model 648 Magnet Power Supply */
 	{ USB_DEVICE(0x1FB9, 0x0700) }, /* Lake Shore Model 737 VSM Controller */
 	{ USB_DEVICE(0x1FB9, 0x0701) }, /* Lake Shore Model 776 Hall Matrix */
+	{ USB_DEVICE(0x2184, 0x0030) }, /* GW Instek GDM-834x Digital Multimeter */
 	{ USB_DEVICE(0x2626, 0xEA60) }, /* Aruba Networks 7xxx USB Serial Console */
 	{ USB_DEVICE(0x3195, 0xF190) }, /* Link Instruments MSO-19 */
 	{ USB_DEVICE(0x3195, 0xF280) }, /* Link Instruments MSO-28 */


