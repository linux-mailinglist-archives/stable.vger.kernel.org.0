Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3231C99B9B
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404597AbfHVR0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404591AbfHVR0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:03 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB239206DD;
        Thu, 22 Aug 2019 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494763;
        bh=Lvq8rNLJsqaM/EklCJ4Ukw7thBl3zII0/AfzDhOLAp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=havpBHlx6Sy7LAfvbbvx+56GkSJdTbxLgqcimbllDjORLqSPF0FZE2sv0HNheEDTU
         /XKCIU4eowHQywLlriVRPQQ42inSfDXxBEI3SpBY/XjGbawycAcgwVIvpiFlmekfi1
         Nc8pZJLaQjJ/uFjT+wYU6n6mjWst3F5UjtGqhfGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Ham <bob.ham@puri.sm>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 65/85] USB: serial: option: add the BroadMobi BM818 card
Date:   Thu, 22 Aug 2019 10:19:38 -0700
Message-Id: <20190822171734.030555831@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Ham <bob.ham@puri.sm>

commit e5d8badf37e6b547842f2fcde10361b29e08bd36 upstream.

Add a VID:PID for the BroadMobi BM818 M.2 card

T:  Bus=01 Lev=03 Prnt=40 Port=03 Cnt=01 Dev#= 44 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2020 ProdID=2060 Rev=00.00
S:  Manufacturer=Qualcomm, Incorporated
S:  Product=Qualcomm CDMA Technologies MSM
C:  #Ifs= 5 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=fe Prot=ff Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

Signed-off-by: Bob Ham <bob.ham@puri.sm>
Signed-off-by: Angus Ainslie (Purism) <angus@akkea.ca>
Cc: stable <stable@vger.kernel.org>
[ johan: use USB_DEVICE_INTERFACE_CLASS() ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1960,6 +1960,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x7e11, 0xff, 0xff, 0xff) },	/* D-Link DWM-156/A3 */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x2031, 0xff),			/* Olicard 600 */
 	  .driver_info = RSVD(4) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x2060, 0xff),			/* BroadMobi BM818 */
+	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x4000, 0xff) },			/* OLICARD300 - MT6225 */
 	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
 	{ USB_DEVICE(VIATELECOM_VENDOR_ID, VIATELECOM_PRODUCT_CDS7) },


