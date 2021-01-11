Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2A12F1638
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbhAKNJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:09:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729199AbhAKNJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:09:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D097D22795;
        Mon, 11 Jan 2021 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370530;
        bh=3unA2aH1cv86A809m8H2K1/M6D13W8/QeBRBZ1NsYs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtTrer9Qwl4Wbvb1o1Sqz3bsWCsBp0PYFAhfi9Kfyq0x6bTdi+JQDIQgTvlLfflfy
         P2cFmsHG9/340g/mvuISI6p3GTYN/jqJxzZzTd4DuwXwQKkdBmLQIyLec78KKyzNSS
         Xm74chrCokXA/w88GQxdJsAGk7VmRxL3CUQqDYgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 32/77] net: usb: qmi_wwan: add Quectel EM160R-GL
Date:   Mon, 11 Jan 2021 14:01:41 +0100
Message-Id: <20210111130037.942198052@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Bjørn Mork" <bjorn@mork.no>

[ Upstream commit cfd82dfc9799c53ef109343a23af006a0f6860a9 ]

New modem using ff/ff/30 for QCDM, ff/00/00 for  AT and NMEA,
and ff/ff/ff for RMNET/QMI.

T: Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 2 Spd=5000 MxCh= 0
D: Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs= 1
P: Vendor=2c7c ProdID=0620 Rev= 4.09
S: Manufacturer=Quectel
S: Product=EM160R-GL
S: SerialNumber=e31cedc1
C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=896mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=(none)
E: Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E: Ad=83(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
E: Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E: Ad=85(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
E: Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E: Ad=87(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
E: Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E: Ad=88(I) Atr=03(Int.) MxPS= 8 Ivl=32ms
E: Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms

Signed-off-by: BjÃ¸rn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20201230152451.245271-1-bjorn@mork.no
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -995,6 +995,7 @@ static const struct usb_device_id produc
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0620)},	/* Quectel EM160R-GL */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
 
 	/* 3. Combined interface devices matching on interface number */


