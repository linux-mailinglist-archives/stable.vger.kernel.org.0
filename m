Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F69C226C44
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgGTQrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbgGTPjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:39:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC1A622D0B;
        Mon, 20 Jul 2020 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259543;
        bh=X8PR27mtiDVSOjoj6WXm/0kCnqOW2iEJDp/FO2s/w4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfyo6ZU4+hwaMDZo/Lm0k3J4YgfzBtqnlU6aEGO5zW8wH1b7SMGY486o5uqX5y1Ly
         a+qV5a2bJBodQfM9GnQl6kHoEFiDUeH6LIMC92ZtbV5sB9lWx9IJAFFSez0MsUzSPB
         +XKeg7mg9X1T65W8uwRo84X1VYzahwPGaB74Gr4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=B6rgen=20Storvist?= <jorgen.storvist@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 47/58] USB: serial: option: add GosunCn GM500 series
Date:   Mon, 20 Jul 2020 17:37:03 +0200
Message-Id: <20200720152749.585556745@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jörgen Storvist <jorgen.storvist@gmail.com>

commit 08d4ef5cc9203a113702f24725f6cf4db476c958 upstream.

Add USB IDs for GosunCn GM500 series cellular modules.

RNDIS config:
usb-devices
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 12 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=305a ProdID=1404 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
S:  SerialNumber=
C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=e0(wlcon) Sub=01 Prot=03 Driver=rndis_host
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
I:  If#=0x2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option

MBIM config:
usb-devices
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 11 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=305a ProdID=1405 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
S:  SerialNumber=
C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x4 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim

ECM config:
usb-devices
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 13 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=305a ProdID=1406 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
S:  SerialNumber=
C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 1 Cls=02(commc) Sub=06 Prot=00 Driver=cdc_ether
I:  If#=0x4 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_ether

Signed-off-by: Jörgen Storvist <jorgen.storvist@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2019,6 +2019,9 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(4) | RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0105, 0xff),			/* Fibocom NL678 series */
 	  .driver_info = RSVD(6) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1404, 0xff) },			/* GosunCn GM500 RNDIS */
+	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */
+	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1406, 0xff) },			/* GosunCn GM500 ECM/NCM */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


