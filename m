Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5C7419B75
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbhI0RTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236874AbhI0RQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:16:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74AA46138D;
        Mon, 27 Sep 2021 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762688;
        bh=8whnz08YUF8Zdni8fKu4wMsjTrTq5rg3b16NwHLBwQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUhSBvmshhCiQ0vkjR5w9B2scOx9ZLkSE9R8mlcDLh3KGeXkI4PZKpisdgMvWdypb
         43bmbqXx7UT9dEbc2FKcQriTE2mF7oMjnsFfN74yJkcE+x10b90zye3kjYUZ0N5Cp3
         /d89R+xTJf7OuXvBvRZvqlOmltnJLbWo2jEAAdqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Uwe Brandt <uwe.brandt@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.14 015/162] USB: serial: cp210x: add ID for GW Instek GDM-834x Digital Multimeter
Date:   Mon, 27 Sep 2021 19:01:01 +0200
Message-Id: <20210927170233.978549354@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
@@ -233,6 +233,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1FB9, 0x0602) }, /* Lake Shore Model 648 Magnet Power Supply */
 	{ USB_DEVICE(0x1FB9, 0x0700) }, /* Lake Shore Model 737 VSM Controller */
 	{ USB_DEVICE(0x1FB9, 0x0701) }, /* Lake Shore Model 776 Hall Matrix */
+	{ USB_DEVICE(0x2184, 0x0030) }, /* GW Instek GDM-834x Digital Multimeter */
 	{ USB_DEVICE(0x2626, 0xEA60) }, /* Aruba Networks 7xxx USB Serial Console */
 	{ USB_DEVICE(0x3195, 0xF190) }, /* Link Instruments MSO-19 */
 	{ USB_DEVICE(0x3195, 0xF280) }, /* Link Instruments MSO-28 */


