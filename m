Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A168E99B57
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404008AbfHVRXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391595AbfHVRWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:50 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC7323405;
        Thu, 22 Aug 2019 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494570;
        bh=RNTqVnUJANqfbI3agjnjkPcebkEguYLF7qVyzEhbHDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B31HYN3Y5C2y7YNRRH2eZhWyMhDYxleyfU+XNGgpcDmVj8M/yY5O6jw2pD0Wj3Im0
         xCfky2OOZRj6kOaaWcgmdq4uHhHVQ0Fih5W3ix2kDghd2CtsY74ZtxM9WuG9eRR+Ca
         L9csV+wcgVU957sEhA80/+/B1BNeL9y+zgadegqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hiroyuki Yamamoto <hyamamo@allied-telesis.co.jp>,
        Yoshiaki Okamoto <yokamoto@allied-telesis.co.jp>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 60/78] USB: serial: option: Add support for ZTE MF871A
Date:   Thu, 22 Aug 2019 10:19:04 -0700
Message-Id: <20190822171833.773526204@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshiaki Okamoto <yokamoto@allied-telesis.co.jp>

commit 7e7ae38bf928c5cfa6dd6e9a2cf8b42c84a27c92 upstream.

This patch adds support for MF871A USB modem (aka Speed USB STICK U03)
to option driver. This modem is manufactured by ZTE corporation, and
sold by KDDI.

Interface layout:
0: AT
1: MODEM

usb-devices output:
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  9 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=19d2 ProdID=1481 Rev=52.87
S:  Manufacturer=ZTE,Incorporated
S:  Product=ZTE Technologies MSM
S:  SerialNumber=1234567890ABCDEF
C:  #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option

Co-developed-by: Hiroyuki Yamamoto <hyamamo@allied-telesis.co.jp>
Signed-off-by: Hiroyuki Yamamoto <hyamamo@allied-telesis.co.jp>
Signed-off-by: Yoshiaki Okamoto <yokamoto@allied-telesis.co.jp>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1544,6 +1544,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1428, 0xff, 0xff, 0xff),  /* Telewell TW-LTE 4G v2 */
 	  .driver_info = RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(ZTE_VENDOR_ID, 0x1476, 0xff) },	/* GosunCn ZTE WeLink ME3630 (ECM/NCM mode) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1481, 0xff, 0x00, 0x00) }, /* ZTE MF871A */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1533, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1534, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1535, 0xff, 0xff, 0xff) },


