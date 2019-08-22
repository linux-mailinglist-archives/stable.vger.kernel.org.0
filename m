Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C2A99B75
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391801AbfHVRZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391796AbfHVRZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:00 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 687422341E;
        Thu, 22 Aug 2019 17:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494699;
        bh=NHbac2QxJ6V8IXj/hcuj/yaFWVSBPxszMbXr9ajtCOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKLMXgR1qa6Az0xcork8SL4mVbFmtWhRNBM/uHV01zS2jLMsS0G0857oBaFAgWIpp
         8Lw3jUrbK5/YKUUzwQWEx6zxmPW4PmjWCoUXSS27n3vVvgUBuHxg3nbGOhO1CIZEZ6
         UTcw9i34MY/yXB0x4kRe1YUrrfOXe+Ejfs/5G6l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Ham <bob.ham@puri.sm>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 52/71] USB: serial: option: add the BroadMobi BM818 card
Date:   Thu, 22 Aug 2019 10:19:27 -0700
Message-Id: <20190822171730.075776705@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
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
@@ -1962,6 +1962,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x7e11, 0xff, 0xff, 0xff) },	/* D-Link DWM-156/A3 */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x2031, 0xff),			/* Olicard 600 */
 	  .driver_info = RSVD(4) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x2060, 0xff),			/* BroadMobi BM818 */
+	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x4000, 0xff) },			/* OLICARD300 - MT6225 */
 	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
 	{ USB_DEVICE(VIATELECOM_VENDOR_ID, VIATELECOM_PRODUCT_CDS7) },


