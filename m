Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF7F289E0
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389550AbfEWTmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389668AbfEWTSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:18:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 047AE2133D;
        Thu, 23 May 2019 19:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639118;
        bh=v3YkPnGp/3MImUx4OfH7TLRcK2183DXdIS1ADBX1z6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMfM/OVEKHPLN/L/y3mRgSbYDEbENxQ6jMnhSg5fF44hcspkJD8PKWl7SWiKc4ThM
         M3GW7saeS/hjFO/UThU9dY2KJ931/ZBG5Xf+MDNS3SXfezh0UvUAua1VE4ErPGNZ+X
         lEpIa5+Hgr51TYcGZEgHRlhkP8r/l22ZGunKn7qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Melin <larsm17@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/114] qmi_wwan: new Wistron, ZTE and D-Link devices
Date:   Thu, 23 May 2019 21:06:40 +0200
Message-Id: <20190523181740.275206076@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 88ef66a28391ea7b624bfb7508a5b015c13b28f3 ]

Adding device entries found in vendor modified versions of this
driver.  Function maps for some of the devices follow:

WNC D16Q1, D16Q5, D18Q1 LTE CAT3 module (1435:0918)

MI_00 Qualcomm HS-USB Diagnostics
MI_01 Android Debug interface
MI_02 Qualcomm HS-USB Modem
MI_03 Qualcomm Wireless HS-USB Ethernet Adapter
MI_04 Qualcomm Wireless HS-USB Ethernet Adapter
MI_05 Qualcomm Wireless HS-USB Ethernet Adapter
MI_06 USB Mass Storage Device

 T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
 D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
 P:  Vendor=1435 ProdID=0918 Rev= 2.32
 S:  Manufacturer=Android
 S:  Product=Android
 S:  SerialNumber=0123456789ABCDEF
 C:* #Ifs= 7 Cfg#= 1 Atr=80 MxPwr=500mA
 I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
 E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
 E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
 E:  Ad=84(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
 E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
 E:  Ad=86(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
 E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
 E:  Ad=88(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
 E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
 E:  Ad=8a(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
 E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

WNC D18 LTE CAT3 module (1435:d182)

MI_00 Qualcomm HS-USB Diagnostics
MI_01 Androd Debug interface
MI_02 Qualcomm HS-USB Modem
MI_03 Qualcomm HS-USB NMEA
MI_04 Qualcomm Wireless HS-USB Ethernet Adapter
MI_05 Qualcomm Wireless HS-USB Ethernet Adapter
MI_06 USB Mass Storage Device

ZM8510/ZM8620/ME3960 (19d2:0396)

MI_00 ZTE Mobile Broadband Diagnostics Port
MI_01 ZTE Mobile Broadband AT Port
MI_02 ZTE Mobile Broadband Modem
MI_03 ZTE Mobile Broadband NDIS Port (qmi_wwan)
MI_04 ZTE Mobile Broadband ADB Port

ME3620_X (19d2:1432)

MI_00 ZTE Diagnostics Device
MI_01 ZTE UI AT Interface
MI_02 ZTE Modem Device
MI_03 ZTE Mobile Broadband Network Adapter
MI_04 ZTE Composite ADB Interface

Reported-by: Lars Melin <larsm17@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 94389c84ede65..366217263d704 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1122,9 +1122,16 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x0846, 0x68d3, 8)},	/* Netgear Aircard 779S */
 	{QMI_FIXED_INTF(0x12d1, 0x140c, 1)},	/* Huawei E173 */
 	{QMI_FIXED_INTF(0x12d1, 0x14ac, 1)},	/* Huawei E1820 */
+	{QMI_FIXED_INTF(0x1435, 0x0918, 3)},	/* Wistron NeWeb D16Q1 */
+	{QMI_FIXED_INTF(0x1435, 0x0918, 4)},	/* Wistron NeWeb D16Q1 */
+	{QMI_FIXED_INTF(0x1435, 0x0918, 5)},	/* Wistron NeWeb D16Q1 */
+	{QMI_FIXED_INTF(0x1435, 0x3185, 4)},	/* Wistron NeWeb M18Q5 */
+	{QMI_FIXED_INTF(0x1435, 0xd111, 4)},	/* M9615A DM11-1 D51QC */
 	{QMI_FIXED_INTF(0x1435, 0xd181, 3)},	/* Wistron NeWeb D18Q1 */
 	{QMI_FIXED_INTF(0x1435, 0xd181, 4)},	/* Wistron NeWeb D18Q1 */
 	{QMI_FIXED_INTF(0x1435, 0xd181, 5)},	/* Wistron NeWeb D18Q1 */
+	{QMI_FIXED_INTF(0x1435, 0xd182, 4)},	/* Wistron NeWeb D18 */
+	{QMI_FIXED_INTF(0x1435, 0xd182, 5)},	/* Wistron NeWeb D18 */
 	{QMI_FIXED_INTF(0x1435, 0xd191, 4)},	/* Wistron NeWeb D19Q1 */
 	{QMI_QUIRK_SET_DTR(0x1508, 0x1001, 4)},	/* Fibocom NL668 series */
 	{QMI_FIXED_INTF(0x16d8, 0x6003, 0)},	/* CMOTech 6003 */
@@ -1180,6 +1187,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x19d2, 0x0265, 4)},	/* ONDA MT8205 4G LTE */
 	{QMI_FIXED_INTF(0x19d2, 0x0284, 4)},	/* ZTE MF880 */
 	{QMI_FIXED_INTF(0x19d2, 0x0326, 4)},	/* ZTE MF821D */
+	{QMI_FIXED_INTF(0x19d2, 0x0396, 3)},	/* ZTE ZM8620 */
 	{QMI_FIXED_INTF(0x19d2, 0x0412, 4)},	/* Telewell TW-LTE 4G */
 	{QMI_FIXED_INTF(0x19d2, 0x1008, 4)},	/* ZTE (Vodafone) K3570-Z */
 	{QMI_FIXED_INTF(0x19d2, 0x1010, 4)},	/* ZTE (Vodafone) K3571-Z */
@@ -1200,7 +1208,9 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x19d2, 0x1425, 2)},
 	{QMI_FIXED_INTF(0x19d2, 0x1426, 2)},	/* ZTE MF91 */
 	{QMI_FIXED_INTF(0x19d2, 0x1428, 2)},	/* Telewell TW-LTE 4G v2 */
+	{QMI_FIXED_INTF(0x19d2, 0x1432, 3)},	/* ZTE ME3620 */
 	{QMI_FIXED_INTF(0x19d2, 0x2002, 4)},	/* ZTE (Vodafone) K3765-Z */
+	{QMI_FIXED_INTF(0x2001, 0x7e16, 3)},	/* D-Link DWM-221 */
 	{QMI_FIXED_INTF(0x2001, 0x7e19, 4)},	/* D-Link DWM-221 B1 */
 	{QMI_FIXED_INTF(0x2001, 0x7e35, 4)},	/* D-Link DWM-222 */
 	{QMI_FIXED_INTF(0x2020, 0x2031, 4)},	/* Olicard 600 */
-- 
2.20.1



