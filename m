Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670041578C6
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgBJMjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729346AbgBJMjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:11 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C13620842;
        Mon, 10 Feb 2020 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338350;
        bh=lUrQunh0+ei5Hfb26Ok1sojhY0Gsu0vIGOsf4QwGHeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDPt7tCzH1xDwWaix7PGUV7BS32knY1wITTHpe4kebh74g8Y+jZunSO+l1gHKIK61
         tQnk4eh6ax+Gl8KnYi/E35DY+vIeBqZJ70LQplGNwCr6j1jVhxAdIexKRpmAJznIIR
         oEdDog7e9k4O1onNiw3VQyZnrf3XtO7lya0mY8sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Razvan Stefanescu <razvan.stefanescu@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 268/309] net: dsa: microchip: enable module autoprobe
Date:   Mon, 10 Feb 2020 04:33:44 -0800
Message-Id: <20200210122432.417664343@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Razvan Stefanescu <razvan.stefanescu@microchip.com>

[ Upstream commit f8c2afa66d5397b0b9293c4347dac6dabb327685 ]

This matches /sys/devices/.../spi1.0/modalias content.

Fixes: 9b2d9f05cddf ("net: dsa: microchip: add ksz9567 to ksz9477 driver")
Fixes: d9033ae95cf4 ("net: dsa: microchip: add KSZ8563 compatibility string")
Fixes: 8c29bebb1f8a ("net: dsa: microchip: add KSZ9893 switch support")
Fixes: 45316818371d ("net: dsa: add support for ksz9897 ethernet switch")
Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz9477_spi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -101,6 +101,12 @@ static struct spi_driver ksz9477_spi_dri
 
 module_spi_driver(ksz9477_spi_driver);
 
+MODULE_ALIAS("spi:ksz9477");
+MODULE_ALIAS("spi:ksz9897");
+MODULE_ALIAS("spi:ksz9893");
+MODULE_ALIAS("spi:ksz9563");
+MODULE_ALIAS("spi:ksz8563");
+MODULE_ALIAS("spi:ksz9567");
 MODULE_AUTHOR("Woojung Huh <Woojung.Huh@microchip.com>");
 MODULE_DESCRIPTION("Microchip KSZ9477 Series Switch SPI access Driver");
 MODULE_LICENSE("GPL");


