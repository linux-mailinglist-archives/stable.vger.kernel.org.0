Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DAA3136BE
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhBHPOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231135AbhBHPKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:10:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B816964E7B;
        Mon,  8 Feb 2021 15:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796818;
        bh=A364bXZdWi1002bX3BY8uzR3nENEzhVI+q4l0kdEzxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRcOPP356+0W2Madax6VWUk7+VPs06t/A4pHiMNmX9NQn+nGw7x/wEk8mwWO/iz6X
         XlgSfRtLDkVpofPnnYPXbpSdqDKqdDQ7G1NxJmi0zQ+12EOaZSyYgWGgeYNgkRCJRs
         nKoF2IsiFqjxPVUZ1TTxVT0nyx7KwXPasgxVQUKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Schemmel <christoph.schemmel@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 03/30] USB: serial: option: Adding support for Cinterion MV31
Date:   Mon,  8 Feb 2021 16:00:49 +0100
Message-Id: <20210208145805.397008787@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
References: <20210208145805.239714726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Schemmel <christoph.schemmel@gmail.com>

commit e478d6029dca9d8462f426aee0d32896ef64f10f upstream.

Adding support for Cinterion device MV31 for enumeration with
PID 0x00B3 and 0x00B7.

usb-devices output for 0x00B3
T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  6 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=1e2d ProdID=00b3 Rev=04.14
S:  Manufacturer=Cinterion
S:  Product=Cinterion PID 0x00B3 USB Mobile Broadband
S:  SerialNumber=b3246eed
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=cdc_wdm
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

usb-devices output for 0x00B7
T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  5 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=1e2d ProdID=00b7 Rev=04.14
S:  Manufacturer=Cinterion
S:  Product=Cinterion PID 0x00B3 USB Mobile Broadband
S:  SerialNumber=b3246eed
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

Signed-off-by: Christoph Schemmel <christoph.schemmel@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -428,6 +428,8 @@ static void option_instat_callback(struc
 #define CINTERION_PRODUCT_AHXX_2RMNET		0x0084
 #define CINTERION_PRODUCT_AHXX_AUDIO		0x0085
 #define CINTERION_PRODUCT_CLS8			0x00b0
+#define CINTERION_PRODUCT_MV31_MBIM		0x00b3
+#define CINTERION_PRODUCT_MV31_RMNET		0x00b7
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1917,6 +1919,10 @@ static const struct usb_device_id option
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, /* HC28 enumerates with Siemens or Cinterion VID depending on FW revision */
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_MBIM, 0xff),
+	  .driver_info = RSVD(3)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_RMNET, 0xff),
+	  .driver_info = RSVD(0)},
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100),
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD120),


