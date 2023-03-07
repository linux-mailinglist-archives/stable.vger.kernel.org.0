Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58F96AF50D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbjCGTVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbjCGTV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:21:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698ABB0BB7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 231D9B8117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729EBC433EF;
        Tue,  7 Mar 2023 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215968;
        bh=wKE2iqs79eYbVdbVS4F56T087VNF7PH+AEolygeRKkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cq2/cSjEF0VLVYH/4BYQyhgMVNcaKEPo9O+wJo12AJsZX1uedC2wkVu2tmUFNVp5l
         fis9+Et1M/OG8TH26o3qSVHKGTKh3QSNLPfl4fbBx9AWNuNOBsWVQ5DiDr/tSfWYhM
         uOPoegOXjwzvOqeUuIFCfVP8VINkEtEMo2N6Bm+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moises Cardona <moisesmcardona@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/567] Bluetooth: btusb: Add VID:PID 13d3:3529 for Realtek RTL8821CE
Date:   Tue,  7 Mar 2023 18:02:16 +0100
Message-Id: <20230307165923.175315611@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moises Cardona <moisesmcardona@gmail.com>

[ Upstream commit 1eec3b95b5ce7fb2cdd273ac4f8b24b1ed6776a1 ]

This patch adds VID:PID 13d3:3529 to the btusb.c file.

This VID:PID is found in the Realtek RTL8821CE module
(M.2 module AW-CB304NF on an ASUS E210MA laptop)

Output of /sys/kernel/debug/usb/devices:

T:  Bus=01 Lev=01 Prnt=01 Port=07 Cnt=02 Dev#=  3 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3529 Rev= 1.10
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Moises Cardona <moisesmcardona@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9c32263f872b9..9eb2267bd3a02 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -400,6 +400,10 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_IGNORE },
 
+	/* Realtek 8821CE Bluetooth devices */
+	{ USB_DEVICE(0x13d3, 0x3529), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xb00c), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-- 
2.39.2



