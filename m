Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA061A78
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 07:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfGHFzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 01:55:05 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:57365 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbfGHFzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 01:55:05 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id D54FF886BF;
        Mon,  8 Jul 2019 17:55:01 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1562565301;
        bh=qC+ZsnV65qEsv89jlR1nAH5vNZinq9tDubETd//AR7I=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=QRrT7SRIHTXTleahxzKwWbJ5Zl9k2fY1Tk0KIsaetaSy06GgaqZF7HP1pzp5214zm
         MUZ8tY/pOG1jJKxSrGvghyolk6u1IjCv1c1+0sO81xIGqCMBUTUnTIUwI5nf+QfEb1
         g218k25FPoXS8ocrRDRQlsId7d9pfN8lcLcUXr8WrFPYczvMINtOc+f5fvc/6ImkPG
         SlHFol8EcvSdA5uJVsnDKJIUmKrdYXXF/hJHgDuwZZ0s2RSv7RRhhaxtDniXq3UMvN
         Be+MWUW6qusZevSTOxZxwcbK6dYq+UbwgCCt/Bj9UdMkKG25tTHAA1gK7Snp95VKJw
         Mpx1v+zUKX/ug==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d22dab60001>; Mon, 08 Jul 2019 17:55:02 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1156.6; Mon, 8 Jul 2019 17:55:01 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Mon, 8 Jul 2019 17:55:01 +1200
From:   Joshua Scott <Joshua.Scott@alliedtelesis.co.nz>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart
 serial node" has been added to the 4.14-stable tree
Thread-Topic: Patch "ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart
 serial node" has been added to the 4.14-stable tree
Thread-Index: AQHVMxACed/vz2aduEix0kGQuG0pAKbAOpet
Date:   Mon, 8 Jul 2019 05:55:00 +0000
Message-ID: <1562565301017.49476@alliedtelesis.co.nz>
References: <156231715780108@kroah.com>
In-Reply-To: <156231715780108@kroah.com>
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

Hi,=0A=
=0A=
I do not think this patch alone will work on 4.14.=0A=
=0A=
An earlier pair of patches which implements the "marvell,armada-38x-uart" q=
uirk is present on the other kernel versions, but I do see it as far back a=
s 4.14.=0A=
=0A=
The following two patches are the ones which add support for that compatibl=
e string:=0A=
=0A=
b7639b0b15dd serial: 8250_dw: Limit dw8250_tx_wait_empty quirk to armada-38=
x devices=0A=
914eaf935ec7 serial: 8250_dw: Allow TX FIFO to drain before writing to UART=
_LCR=0A=
=0A=
=0A=
Cheers,=0A=
Joshua Scott=0A=
________________________________________=0A=
From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>=0A=
Sent: Friday, 5 July 2019 8:59 p.m.=0A=
To: andrew@lunn.ch; gregkh@linuxfoundation.org; gregory.clement@bootlin.com=
; Joshua Scott=0A=
Cc: stable-commits@vger.kernel.org=0A=
Subject: Patch "ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart ser=
ial node" has been added to the 4.14-stable tree=0A=
=0A=
This is a note to let you know that I've just added the patch titled=0A=
=0A=
    ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node=0A=
=0A=
to the 4.14-stable tree which can be found at:=0A=
    http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.git=
;a=3Dsummary=0A=
=0A=
The filename of the patch is:=0A=
     arm-dts-armada-xp-98dx3236-switch-to-armada-38x-uart-serial-node.patch=
=0A=
and it can be found in the queue-4.14 subdirectory.=0A=
=0A=
If you, or anyone else, feels it should not be added to the stable tree,=0A=
please let <stable@vger.kernel.org> know about it.=0A=
=0A=
=0A=
From 80031361747aec92163464f2ee08870fec33bcb0 Mon Sep 17 00:00:00 2001=0A=
From: Joshua Scott <joshua.scott@alliedtelesis.co.nz>=0A=
Date: Wed, 26 Jun 2019 10:11:08 +1200=0A=
Subject: ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial nod=
e=0A=
=0A=
From: Joshua Scott <joshua.scott@alliedtelesis.co.nz>=0A=
=0A=
commit 80031361747aec92163464f2ee08870fec33bcb0 upstream.=0A=
=0A=
Switch to the "marvell,armada-38x-uart" driver variant to empty=0A=
the UART buffer before writing to the UART_LCR register.=0A=
=0A=
Signed-off-by: Joshua Scott <joshua.scott@alliedtelesis.co.nz>=0A=
Tested-by: Andrew Lunn <andrew@lunn.ch>=0A=
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>.=0A=
Cc: stable@vger.kernel.org=0A=
Fixes: 43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for armada-xp-9=
8dx3236")=0A=
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>=0A=
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
=0A=
---=0A=
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi |    8 ++++++++=0A=
 1 file changed, 8 insertions(+)=0A=
=0A=
--- a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi=0A=
+++ b/arch/arm/boot/dts/armada-xp-98dx3236.dtsi=0A=
@@ -360,3 +360,11 @@=0A=
        status =3D "disabled";=0A=
 };=0A=
=0A=
+&uart0 {=0A=
+       compatible =3D "marvell,armada-38x-uart";=0A=
+};=0A=
+=0A=
+&uart1 {=0A=
+       compatible =3D "marvell,armada-38x-uart";=0A=
+};=0A=
+=0A=
=0A=
=0A=
Patches currently in stable-queue which might be from joshua.scott@alliedte=
lesis.co.nz are=0A=
=0A=
queue-4.14/arm-dts-armada-xp-98dx3236-switch-to-armada-38x-uart-serial-node=
.patch=0A=
