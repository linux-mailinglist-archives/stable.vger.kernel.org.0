Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2FCE66D75
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbfGLMaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbfGLMaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:30:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA29F21670;
        Fri, 12 Jul 2019 12:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934605;
        bh=s77BrHJDsy+KnVUeQoS4PPzQPNBJKEn+JM1Jp9LqINs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBN4H+Y9J+BN+fpfz6GuM5JD+jSKUqXT0PxWuFqjR5FfbjEUF+e1c7rghdSz4eCgG
         fopUglDcWWfpBxjuhM05eV1NnX9SaSv5JA67ktBgtKSUanI8gzlCK0lG+R9bCzAAuC
         HtpYvSQDKIMfhJ9jq6532VgJnnn8GJnpXlvNfOVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=B6rgen=20Storvist?= <jorgen.storvist@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.1 109/138] USB: serial: option: add support for GosunCn ME3630 RNDIS mode
Date:   Fri, 12 Jul 2019 14:19:33 +0200
Message-Id: <20190712121632.941823049@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jörgen Storvist <jorgen.storvist@gmail.com>

commit aed2a26283528fb69c38e414f649411aa48fb391 upstream.

Added USB IDs for GosunCn ME3630 cellular module in RNDIS mode.

T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=03 Dev#= 18 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=19d2 ProdID=0601 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
S:  SerialNumber=b950269c
C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=e0(wlcon) Sub=01 Prot=03 Driver=rndis_host
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
I:  If#=0x2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option

Signed-off-by: Jörgen Storvist <jorgen.storvist@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1343,6 +1343,7 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0414, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0417, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_INTERFACE_CLASS(ZTE_VENDOR_ID, 0x0601, 0xff) },	/* GosunCn ZTE WeLink ME3630 (RNDIS mode) */
 	{ USB_DEVICE_INTERFACE_CLASS(ZTE_VENDOR_ID, 0x0602, 0xff) },	/* GosunCn ZTE WeLink ME3630 (MBIM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1008, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(4) },


