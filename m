Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436A2DA14B
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392799AbfJPWVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437493AbfJPVxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:30 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B5FC21A49;
        Wed, 16 Oct 2019 21:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262810;
        bh=LUKjsPCWEtNH3HLndgOLDUzg8Vj0lrrvdvXlTRZPOks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJiT0/dui/+4uIlxOyyavLowX3mMHJLIdVX2ayl1Mda67q+XUyJUBjoDUlyJ5cXCV
         aSjtff1VEHPIVhVnec+cJCxkw6yeWd5+rhgrzoLAC0F6Nt6LCa8qM05FxlscNtWg0b
         qItJzFaBOZI98WMSvIvhHvgMtLmwnMl9CPUoSMMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reinhard Speyerer <rspmn@arcor.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 52/79] USB: serial: option: add support for Cinterion CLS8 devices
Date:   Wed, 16 Oct 2019 14:50:27 -0700
Message-Id: <20191016214815.156641132@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinhard Speyerer <rspmn@arcor.de>

commit dfbac2f4da6a0c4a8f6b4d715a4077a7b8df53ad upstream.

Add support for the serial ports of Cinterion CLS8 devices.

T:  Bus=01 Lev=03 Prnt=05 Port=01 Cnt=02 Dev#= 25 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1e2d ProdID=00b0 Rev= 3.18
S:  Manufacturer=GEMALTO
S:  Product=USB Modem
C:* #Ifs= 5 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=89(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -421,6 +421,7 @@ static void option_instat_callback(struc
 #define CINTERION_PRODUCT_PH8_AUDIO		0x0083
 #define CINTERION_PRODUCT_AHXX_2RMNET		0x0084
 #define CINTERION_PRODUCT_AHXX_AUDIO		0x0085
+#define CINTERION_PRODUCT_CLS8			0x00b0
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1850,6 +1851,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHXX_2RMNET, 0xff) },
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHXX_AUDIO, 0xff) },
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_CLS8, 0xff),
+	  .driver_info = RSVD(0) | RSVD(4) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },


