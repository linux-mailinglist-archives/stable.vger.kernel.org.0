Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7181033BADB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhCOOKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233971AbhCOOCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72A4B64E83;
        Mon, 15 Mar 2021 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816961;
        bh=ca9is0KLqZQ0AXDogzM4vcSMEYL0KYPeNKI74cKrKiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nrs7WLgdDcgA8W3Xi441vAWOmZ1QAVDF6IK4dZ4aLq3uCYw7McUMgnxxKgyl1ArK6
         OYH6R28g+N6PrJfzSRA+xywJh0GzoWWFe5+C6lqtnWya57dFVzcfjQPOo1o/+KdVpO
         yDW9ZA0DBOYPdhDJxANYALXvYVgN+7Txl2BbFcZI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Karan Singhal <karan.singhal@acuitybrands.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 214/290] USB: serial: cp210x: add ID for Acuity Brands nLight Air Adapter
Date:   Mon, 15 Mar 2021 14:55:07 +0100
Message-Id: <20210315135549.200256261@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
@@ -149,6 +149,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x8857) },	/* CEL EM357 ZigBee USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
+	{ USB_DEVICE(0x10C4, 0x88D8) }, /* Acuity Brands nLight Air Adapter */
 	{ USB_DEVICE(0x10C4, 0x88FB) }, /* CESINEL MEDCAL STII Network Analyzer */
 	{ USB_DEVICE(0x10C4, 0x8938) }, /* CESINEL MEDCAL S II Network Analyzer */
 	{ USB_DEVICE(0x10C4, 0x8946) }, /* Ketra N1 Wireless Interface */


