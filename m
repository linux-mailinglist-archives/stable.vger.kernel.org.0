Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CD5226919
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732724AbgGTQDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731994AbgGTQDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:03:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24FBC20672;
        Mon, 20 Jul 2020 16:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260993;
        bh=1vh0gccBO5E8zyO6PG9oR09WipYYJAhhq0ytHAR8VZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgHur857fLqwdN6DmWfvxwixbQb22zxh1JM+cnE2+QEg1oWEJKlr7cPn3NbaNSoVH
         NI231gM15qaBJlYXRUfQmA8Z5/tYsO+wpmh7c7fbzxQ2Rah6fy0ZEvurEsJCx0wZik
         ZLKpXO/1WOVHF9OSDWmefy/ZO2HP/P/5bU2UhkEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 163/215] USB: serial: option: add Quectel EG95 LTE modem
Date:   Mon, 20 Jul 2020 17:37:25 +0200
Message-Id: <20200720152827.934538009@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>

commit da6902e5b6dbca9081e3d377f9802d4fd0c5ea59 upstream.

Add support for Quectel Wireless Solutions Co., Ltd. EG95 LTE modem

T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#=  5 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=0195 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -245,6 +245,7 @@ static void option_instat_callback(struc
 /* These Quectel products use Quectel's vendor ID */
 #define QUECTEL_PRODUCT_EC21			0x0121
 #define QUECTEL_PRODUCT_EC25			0x0125
+#define QUECTEL_PRODUCT_EG95			0x0195
 #define QUECTEL_PRODUCT_BG96			0x0296
 #define QUECTEL_PRODUCT_EP06			0x0306
 #define QUECTEL_PRODUCT_EM12			0x0512
@@ -1097,6 +1098,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25),
 	  .driver_info = RSVD(4) },
+	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95),
+	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_BG96),
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0xff, 0xff),


