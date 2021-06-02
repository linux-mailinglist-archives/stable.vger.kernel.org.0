Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F343339954C
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 23:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhFBVTq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 2 Jun 2021 17:19:46 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41913 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFBVTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 17:19:46 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id D926ECED0C;
        Wed,  2 Jun 2021 23:25:58 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCHv2 2/2] Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU
 (ASUS BT500) device
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210602210702.26038-1-joakim.tjernlund@infinera.com>
Date:   Wed, 2 Jun 2021 23:18:00 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6019220E-9A35-4A80-B29A-446E1D74FDDE@holtmann.org>
References: <20210602210702.26038-1-joakim.tjernlund@infinera.com>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joakim,

> T:  Bus=01 Lev=01 Prnt=01 Port=08 Cnt=04 Dev#= 18 Spd=12   MxCh= 0
> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0b05 ProdID=190e Rev= 2.00
> S:  Manufacturer=Realtek
> S:  Product=ASUS USB-BT500
> S:  SerialNumber=xxxxxxxx
> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
> Cc: stable@vger.kernel.org
> ---
> 
> v2 - fix SPACE
> drivers/bluetooth/btusb.c | 4 ++++
> 1 file changed, 4 insertions(+)

now it doesn’t apply to bluetooth-next anymore.

And please take CC: stable off this since I am pretty sure it depends on the 1/2 change for the firmware as well.

Regards

Marcel

