Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97E733BA15
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCOOH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233669AbhCOOCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22D6D64F1E;
        Mon, 15 Mar 2021 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816931;
        bh=OOca3kBORgZR7pDsF6UQXxGFhNJsYMQXZVOqWCCcrdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGq9Jt+WMrJ6aU95vjG1YPOaEkSQxRy33idTEe9eaFDzZt0tr9LBqtYETzaw8ThD5
         /mHbBOLRxTWLu8zkdwAJHWZZLoqMrg6cseJBz8R+CJ4cF2EA+L+KXcBjM7EgiCB/0+
         mJIH74/0N9/n79Syd5fQL68bNwKT4JjkvzBHGLI8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Karan Singhal <karan.singhal@acuitybrands.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 210/306] USB: serial: cp210x: add ID for Acuity Brands nLight Air Adapter
Date:   Mon, 15 Mar 2021 14:54:33 +0100
Message-Id: <20210315135514.726000470@linuxfoundation.org>
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

From: Karan Singhal <karan.singhal@acuitybrands.com>

commit ca667a33207daeaf9c62b106815728718def60ec upstream.

IDs of nLight Air Adapter, Acuity Brands, Inc.:
vid: 10c4
pid: 88d8

Signed-off-by: Karan Singhal <karan.singhal@acuitybrands.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -146,6 +146,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x8857) },	/* CEL EM357 ZigBee USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
+	{ USB_DEVICE(0x10C4, 0x88D8) }, /* Acuity Brands nLight Air Adapter */
 	{ USB_DEVICE(0x10C4, 0x88FB) }, /* CESINEL MEDCAL STII Network Analyzer */
 	{ USB_DEVICE(0x10C4, 0x8938) }, /* CESINEL MEDCAL S II Network Analyzer */
 	{ USB_DEVICE(0x10C4, 0x8946) }, /* Ketra N1 Wireless Interface */


