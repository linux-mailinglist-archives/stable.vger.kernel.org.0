Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15AC496667
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 21:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiAUUkC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 21 Jan 2022 15:40:02 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:53058 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiAUUkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 15:40:01 -0500
Received: from smtpclient.apple (p4fefca45.dip0.t-ipconnect.de [79.239.202.69])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7A9F9CED17;
        Fri, 21 Jan 2022 21:40:00 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH] Bluetooth: btusb: Add one more Bluetooth part for the
 Realtek RTL8852AE
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220119201837.4135-1-Larry.Finger@lwfinger.net>
Date:   Fri, 21 Jan 2022 21:40:00 +0100
Cc:     "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, Hilda Wu <hildawu@realtek.com>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5E2A1A33-8886-4565-9959-DD115A86D582@holtmann.org>
References: <20220119201837.4135-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Larry,

> This Realtek device has both wifi and BT components. The latter reports
> a USB ID of 0bda:2852, which is not in the table.
> 
> BT device description in /sys/kernel/debug/usb/devices contains the following entries:
> 
> T: Bus=01 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#= 3 Spd=12 MxCh= 0
> D: Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
> P: Vendor=0bda ProdID=2852 Rev= 0.00
> S: Manufacturer=Realtek
> S: Product=Bluetooth Radio
> S: SerialNumber=00e04c000001
> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=81(I) Atr=03(Int.) MxPS= 16 Ivl=1ms
> E: Ad=02(O) Atr=02(Bulk) MxPS= 64 Ivl=0ms
> E: Ad=82(I) Atr=02(Bulk) MxPS= 64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=03(O) Atr=01(Isoc) MxPS= 0 Ivl=1ms
> E: Ad=83(I) Atr=01(Isoc) MxPS= 0 Ivl=1ms
> I: If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=03(O) Atr=01(Isoc) MxPS= 9 Ivl=1ms
> E: Ad=83(I) Atr=01(Isoc) MxPS= 9 Ivl=1ms
> I: If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=03(O) Atr=01(Isoc) MxPS= 17 Ivl=1ms
> E: Ad=83(I) Atr=01(Isoc) MxPS= 17 Ivl=1ms
> I: If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=03(O) Atr=01(Isoc) MxPS= 25 Ivl=1ms
> E: Ad=83(I) Atr=01(Isoc) MxPS= 25 Ivl=1ms
> I: If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=03(O) Atr=01(Isoc) MxPS= 33 Ivl=1ms
> E: Ad=83(I) Atr=01(Isoc) MxPS= 33 Ivl=1ms
> I: If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=03(O) Atr=01(Isoc) MxPS= 49 Ivl=1ms
> E: Ad=83(I) Atr=01(Isoc) MxPS= 49 Ivl=1ms
> 
> The missing USB_ID was reported by user trius65 at https://github.com/lwfinger/rtw89/issues/122
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: stable@vger.kernel.org
> ---
> drivers/bluetooth/btusb.c | 2 ++
> 1 file changed, 2 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

