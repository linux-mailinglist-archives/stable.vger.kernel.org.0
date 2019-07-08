Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB1D62B52
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 00:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbfGHWHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 18:07:00 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:58263 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732549AbfGHWHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 18:07:00 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id ECAE1886BF;
        Tue,  9 Jul 2019 10:06:55 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1562623615;
        bh=QLCPynRPra6ohUEHMDD48Kw1Eu3mCO/uX2j0Hh4Y9GI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=rb41Aw8Wq1+DjcqHwpMs+bIFQSUCrElKoa+KIFN7xo6uvWHoj9mzJlkJQYMBdTj6a
         2ARretCHwgm0YJnKa1on9M8ecKe76PP4xG6vfotkYPAChRSXRDoiqNZFk+hYNiMOLL
         Prx/3DPWKC8RceQyLFjGisMIQLUBuu2t2TSCipAaI58ffgB6IEx2e4lPbhWeMYq4Ui
         ekg/IdegKTQyYSPa5LC+XbkGgmtQGWWOBLsClTKkx98sICIv2wmWNjhIQX5uQh+Zhi
         kHD/H7exlepo8yhVCrsvMldGxUJu7CHl9IEhNScUGRV59YuW2GJ21KsspwxNKm56fW
         g66l0ooy82RTg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d23be7f0000>; Tue, 09 Jul 2019 10:06:55 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1156.6; Tue, 9 Jul 2019 10:06:50 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Tue, 9 Jul 2019 10:06:50 +1200
From:   Joshua Scott <Joshua.Scott@alliedtelesis.co.nz>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart
 serial node" has been added to the 4.14-stable tree
Thread-Topic: Patch "ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart
 serial node" has been added to the 4.14-stable tree
Thread-Index: AQHVMxACed/vz2aduEix0kGQuG0pAKbAOpet//9BcgCAAcyjMg==
Date:   Mon, 8 Jul 2019 22:06:50 +0000
Message-ID: <1562623610543.71373@alliedtelesis.co.nz>
References: <156231715780108@kroah.com>
 <1562565301017.49476@alliedtelesis.co.nz>,<20190708062332.GA28690@kroah.com>
In-Reply-To: <20190708062332.GA28690@kroah.com>
Accept-Language: en-NZ, en-US
Content-Language: en-NZ
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.10]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,=0A=
=0A=
43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for armada-xp-98dx3236=
") is the patch=0A=
which introduces the armada-xp-98dx3236, and contains the device-tree entry=
 for the driver that does=0A=
not behave correctly with this SoC.=0A=
=0A=
However, the driver quirk that implements the fix does not exist until the =
two patches I mentioned :=0A=
b7639b0b15dd serial: 8250_dw: Limit dw8250_tx_wait_empty quirk to armada-38=
x devices=0A=
914eaf935ec7 serial: 8250_dw: Allow TX FIFO to drain before writing to UART=
_LCR=0A=
=0A=
Before then, there is no "marvell,armada-38x-uart".=0A=
=0A=
The current patch being delivered only changes the .dts to make use of the =
quirk. This won't work=0A=
if it's being delivered to a branch that does not have the above two patche=
s. I had a look at linux-4.14.y=0A=
on kernel.org, and did not see the two patches there.=0A=
=0A=
=0A=
Cheers,=0A=
Joshua=0A=
________________________________________=0A=
From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>=0A=
Sent: Monday, 8 July 2019 6:23 p.m.=0A=
To: Joshua Scott=0A=
Cc: andrew@lunn.ch; gregory.clement@bootlin.com; stable@vger.kernel.org; st=
able-commits@vger.kernel.org=0A=
Subject: Re: Patch "ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart=
 serial node" has been added to the 4.14-stable tree=0A=
=0A=
On Mon, Jul 08, 2019 at 05:55:00AM +0000, Joshua Scott wrote:=0A=
> Hi,=0A=
>=0A=
> I do not think this patch alone will work on 4.14.=0A=
>=0A=
> An earlier pair of patches which implements the=0A=
> "marvell,armada-38x-uart" quirk is present on the other kernel=0A=
> versions, but I do see it as far back as 4.14.=0A=
>=0A=
> The following two patches are the ones which add support for that compati=
ble string:=0A=
>=0A=
> b7639b0b15dd serial: 8250_dw: Limit dw8250_tx_wait_empty quirk to armada-=
38x devices=0A=
> 914eaf935ec7 serial: 8250_dw: Allow TX FIFO to drain before writing to UA=
RT_LCR=0A=
=0A=
But, this patch says:=0A=
        Fixes: 43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for arm=
ada-xp-98dx3236")=0A=
and that commit showed up in 4.12.=0A=
=0A=
If that is not the case, fine, I'll drop this, otherwise I just have to=0A=
go off of what is given to me :)=0A=
=0A=
thanks,=0A=
=0A=
greg k-h=0A=
