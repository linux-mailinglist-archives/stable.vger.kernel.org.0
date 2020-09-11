Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F72664F5
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgIKQtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgIKPG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:06:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5626F2242F;
        Fri, 11 Sep 2020 12:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829162;
        bh=EHkMk8FZTwQ6Tit8Vxcyh+qja6txSu8AoOFPongUJ5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/3vDmqfCX4DEyPIm3oLH/FicVDvw6MQPJvm0rnZfYTAOdx4ec2/r4krQB4HUfaiR
         IfmTCxX65S16NlBuki4pPM03D0wsp7hgavGxHz61QWsVn1fXjKtZcfelz/ianagyn5
         xew6eG90JFZacfS1L+bhAzls1/qpgf5YcWPe7W3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamil Lorenc <kamil@re-ws.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 09/12] net: usb: dm9601: Add USB ID of Keenetic Plus DSL
Date:   Fri, 11 Sep 2020 14:47:03 +0200
Message-Id: <20200911122458.866898739@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122458.413137406@linuxfoundation.org>
References: <20200911122458.413137406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamil Lorenc <kamil@re-ws.pl>

[ Upstream commit a609d0259183a841621f252e067f40f8cc25d6f6 ]

Keenetic Plus DSL is a xDSL modem that uses dm9620 as its USB interface.

Signed-off-by: Kamil Lorenc <kamil@re-ws.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/dm9601.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -625,6 +625,10 @@ static const struct usb_device_id produc
 	 USB_DEVICE(0x0a46, 0x1269),	/* DM9621A USB to Fast Ethernet Adapter */
 	 .driver_info = (unsigned long)&dm9601_info,
 	},
+	{
+	 USB_DEVICE(0x0586, 0x3427),	/* ZyXEL Keenetic Plus DSL xDSL modem */
+	 .driver_info = (unsigned long)&dm9601_info,
+	},
 	{},			// END
 };
 


