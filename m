Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EDB118B57
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 15:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfLJOmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 09:42:52 -0500
Received: from mail-eopbgr1410134.outbound.protection.outlook.com ([40.107.141.134]:33389
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727519AbfLJOmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 09:42:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjNAgSUOb68cThJXNQctGAjRz6zEfBD3HUW3i+d07MJiLjaC4cdULJZdgvQsBi3lZcxCGOQ0R2QH1t5L9yTabWnE6+NjOcxS7ZNu9GfBkZ7BYiT9a0GMOw0kVbZBcGkcN0SC//sY+znhzGW9BI4cvZ6mfuu+M69WtMSvoouyCx20+pb68N0zq6OCcW0T+/B3RzVefzMFv3aYdwJA109Kyod/S9XCx8m0eTXOkJMkn63jEX+t5dgOAhvxGdq+rRPGScrlDMwu2uPXviwoUwLuaDuOiFAY+mi+Lo1yNul3kSajvwKdpXM7Zh2iYIxFQW9Rluk7cnhTtayqUr/R5gZ/VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HkwLyopdZjJS/yP4TZP+OQraKes54nUGsXZvI01w7E=;
 b=jSQS38O43y8IJ/332NFkj1s3CfALH/E5hVmN5Ix5J9p0ooZwvVlVJdoy6oVr5IybhLBL1U04D+31fg/i+gJ+lk3sjXt5Eyrot1DXfYXF7pFdQLPjotBCd+veheZ3E6yuX31ZOC2/YXyQswXteYvAE6voKG2KXFVPHiHA341lZLYrrHRDZgNsrtm/vnPr6xTNpVle69zA7lPwC8QqRsEJ95mdQPJNR/onKcyiNIxjwyDINdE3TDiHy6ESB+5pjAVVBeAsRI5hZ0E7JX2qavWtdcQN9fpreHjl2l8Ivv1FWuqITz1/RoIaMlk5pPeqNhKFxfM1v13W2LPjFkcK6U0oNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HkwLyopdZjJS/yP4TZP+OQraKes54nUGsXZvI01w7E=;
 b=K2WGk63QWaT2UunLTgfovlsd0glCJyu0ZppFBzc7Ava+T8fHp/ajJYjX1cpXVe/rsSGvi6altU0r9x89/TKVIwZvMNQGVl2HM5Iif07lKWo1SzS1rE0fXwcfV2tBygvcfX6ixjWOvpjctP8QRTX+BUCI8IBEg2X1uR4E889vnIk=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB4030.jpnprd01.prod.outlook.com (20.178.138.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Tue, 10 Dec 2019 14:42:45 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 14:42:45 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: RE: Linux 4.19.89-rc1 5944fcdd errors
Thread-Topic: Linux 4.19.89-rc1 5944fcdd errors
Thread-Index: AdWuq27YYqoiVr7aSmCEQeiV9xd6BQAC8Y6AAAjR8vAAFHfgAAALJekQ
Date:   Tue, 10 Dec 2019 14:42:45 +0000
Message-ID: <TYAPR01MB2285B5834B1FBA71F8DA512BB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209173637.GF1290729@kroah.com>
 <TYAPR01MB2285135B15E6A152163E1A1AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210073514.GB3077639@kroah.com>
In-Reply-To: <20191210073514.GB3077639@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b94c6fc9-1c45-46b7-7f5a-08d77d7f3870
x-ms-traffictypediagnostic: TYAPR01MB4030:
x-microsoft-antispam-prvs: <TYAPR01MB403028A83BEE4708C565E144B75B0@TYAPR01MB4030.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(189003)(199004)(54906003)(86362001)(966005)(76116006)(6506007)(7696005)(71200400001)(498600001)(52536014)(9686003)(8676002)(81166006)(33656002)(81156014)(4326008)(55016002)(66556008)(26005)(66946007)(66476007)(30864003)(186003)(5660300002)(2906002)(8936002)(64756008)(66446008)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB4030;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W8iFpc21DXnWH0vkEuAtyK3ijkTyH8tYKkwUz/R2XB1itIaUu8utu4QfKqc2kgdUjIUFEd6cCf1EPYv79QnJMqqbVOu/23g7CzFtfs5MpNUH9vRkkqcd9zy+4GqTLAPhjaCKJu0dn4a6Xo9IFECdB3HslaWIQW18wbARS15H82AA0Y6fzUenvGSRvB7/UHxuWsrIRjWCfjfn+nFzTs/un1jVz7jkHkTk5qGf0uK+qZ/l5PYmNAne5ICcLmrNtwNl0DR7iZAY5TSaga/hotUlnV+YAoN/9o5+pJOUbaV+euTjNCwx7a+3kc3XQ9GmtGrrIS3hOE5PvIihpMehxeaKtINYLDkLM6vm3uag6Li1n0X3uvLusollZehVhUKdEe+aK5Jg+33d2Kcf1GYWT4xsgYkBhRip9t0g7QyVjxdeyPr15Afx1qp2dDAZIa9K3o768Yqk+ONajVcw1czVSri5zKxMbIFpCTP7US3HaHV0h/4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b94c6fc9-1c45-46b7-7f5a-08d77d7f3870
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 14:42:45.6120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3BS2m+VEl1l4+R5qKF6TTWMsnv+F/uc4STRHZqTlOWBZx/IBTRDMHujAVEtVxh2uLoErfIK+r9gI/FpxpBrg9aqUF+GsxoczVD++QHThNZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4030
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 10 December 2019 07:35
>=20
> On Mon, Dec 09, 2019 at 09:56:29PM +0000, Chris Paterson wrote:
> > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > > Behalf Of Greg Kroah-Hartman
> > > Sent: 09 December 2019 17:37
> > >
> > > On Mon, Dec 09, 2019 at 04:29:22PM +0000, Chris Paterson wrote:
> > > > 3)
> > > > Config: arm shmobile_defconfig
> > > > Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> > > /jobs/373484089#L2249
> > > > Probable culprit: 984d7a8bff57 ("pinctrl: sh-pfc: r8a7792: Fix VIN =
versioned
> > > groups")
> > > > Issue log:
> > > > 2249 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro
> > > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > > 2250   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > > > 2251                                       ^
> > > > 2252 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error:
> > > 'VIN_DATA_PIN_GROUP' undeclared here (not in a function); did you mea=
n
> > > 'PIN_MAP_TYPE_MUX_GROUP'?
> > > > 2253   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > > > 2254   ^~~~~~~~~~~~~~~~~~
> > > > 2255   PIN_MAP_TYPE_MUX_GROUP
> > > > 2256 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro
> > > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > > 2257   VIN_DATA_PIN_GROUP(vin1_data, 20, _b),
> > > > 2258                                       ^
> > > > 2259 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro
> > > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > > 2260   VIN_DATA_PIN_GROUP(vin1_data, 16, _b),
> > > > 2261                                       ^
> > >
> > > Now dropped for 4.19, 4.14, and 4.9 (2 patches for 4.19 here.)
> >
> > Latest 4.19 now building, but I'm seeing a number of warnings and error=
s when
> trying to build the arm64 defconfig dtbs.
> > https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/374092442

> > arm/juno.dtb
7150 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /etf@20010000/=
ports/port@1: graph node unit address error, expected "0"
7151 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /funnel@200400=
00/ports/port@1: graph node unit address error, expected "0"
7152 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /funnel@200400=
00/ports/port@2: graph node unit address error, expected "1"
7153 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /funnel@200400=
00/ports/port@3: graph node unit address error, expected "2"
7154 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /funnel@220c00=
00/ports/port@1: graph node unit address error, expected "0"
7155 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /funnel@220c00=
00/ports/port@2: graph node unit address error, expected "1"
7156 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /funnel@230c00=
00/ports/port@1: graph node unit address error, expected "0"
7157 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /funnel@230c00=
00/ports/port@2: graph node unit address error, expected "1"
7158 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /funnel@230c00=
00/ports/port@3: graph node unit address error, expected "2"
7159 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /funnel@230c00=
00/ports/port@4: graph node unit address error, expected "3"
7160 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port): /replicator@20=
120000/ports/port@2: graph node unit address error, expected "0"

> > qcom/apq8016-sbc.dtb
7173 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port): /soc/f=
unnel@821000/ports/port@8: graph node unit address error, expected "0"
7174 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port): /soc/r=
eplicator@824000/ports/port@2: graph node unit address error, expected "0"
7175 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port): /soc/e=
tf@825000/ports/port@1: graph node unit address error, expected "0"
7176 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port): /soc/f=
unnel@841000/ports/port@4: graph node unit address error, expected "0"

> > arm/juno-r2.dtb
7181 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /etf@200100=
00/ports/port@1: graph node unit address error, expected "0"
7182 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@200=
40000/ports/port@1: graph node unit address error, expected "0"
7183 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@200=
40000/ports/port@2: graph node unit address error, expected "1"
7184 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@220=
c0000/ports/port@1: graph node unit address error, expected "0"
7185 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@220=
c0000/ports/port@2: graph node unit address error, expected "1"
7186 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@230=
c0000/ports/port@1: graph node unit address error, expected "0"
7187 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@230=
c0000/ports/port@2: graph node unit address error, expected "1"
7188 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@230=
c0000/ports/port@3: graph node unit address error, expected "2"
7189 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@230=
c0000/ports/port@4: graph node unit address error, expected "3"
7190 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /replicator=
@20120000/ports/port@2: graph node unit address error, expected "0"
7191 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@201=
30000/ports/port@1: graph node unit address error, expected "0"
7192 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /etf@201400=
00/ports/port@1: graph node unit address error, expected "0"
7193 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@201=
50000/ports/port@1: graph node unit address error, expected "0"
7194 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port): /funnel@201=
50000/ports/port@2: graph node unit address error, expected "1"

> > arm/juno-r1.dtb
7195 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /etf@200100=
00/ports/port@1: graph node unit address error, expected "0"
7196 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@200=
40000/ports/port@1: graph node unit address error, expected "0"
7197 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@200=
40000/ports/port@2: graph node unit address error, expected "1"
7198 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@220=
c0000/ports/port@1: graph node unit address error, expected "0"
7199 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@220=
c0000/ports/port@2: graph node unit address error, expected "1"
7200 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@230=
c0000/ports/port@1: graph node unit address error, expected "0"
7201 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@230=
c0000/ports/port@2: graph node unit address error, expected "1"
7202 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@230=
c0000/ports/port@3: graph node unit address error, expected "2"
7203 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@230=
c0000/ports/port@4: graph node unit address error, expected "3"
7204 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /replicator=
@20120000/ports/port@2: graph node unit address error, expected "0"
7205 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@201=
30000/ports/port@1: graph node unit address error, expected "0"
7206 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /etf@201400=
00/ports/port@1: graph node unit address error, expected "0"
7207 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@201=
50000/ports/port@1: graph node unit address error, expected "0"
7208 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port): /funnel@201=
50000/ports/port@2: graph node unit address error, expected "1"

> > hisilicon/hi6220-hikey.dtb
7209 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/funnel@f6401000/ports/port@1: graph node unit address error, expected =
"0"
7210 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/etf@f6402000/ports/port@1: graph node unit address error, expected "0"
7211 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/replicator/ports/port@1: graph node unit address error, expected "0"
7212 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/replicator/ports/port@2: graph node unit address error, expected "1"
7213 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/funnel@f6501000/ports/port@1: graph node unit address error, expected =
"0"
7214 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/funnel@f6501000/ports/port@2: graph node unit address error, expected =
"1"
7215 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/funnel@f6501000/ports/port@3: graph node unit address error, expected =
"2"
7216 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/funnel@f6501000/ports/port@4: graph node unit address error, expected =
"3"
7217 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/funnel@f6501000/ports/port@5: graph node unit address error, expected =
"4"
7218 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/funnel@f6501000/ports/port@6: graph node unit address error, expected =
"5"
7219 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/funnel@f6501000/ports/port@7: graph node unit address error, expected =
"6"
7220 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port): =
/soc/funnel@f6501000/ports/port@8: graph node unit address error, expected =
"7"

> > allwinner/sun50i-a64-pinebook.dtb
7248 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:82.1-7 La=
bel or path codec not found
7249 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:86.1-14 L=
abel or path codec_analog not found
7250 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:91.1-5 La=
bel or path dai not found
7251 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:297.1-7 L=
abel or path sound not found

> > qcom/msm8916-mtp.dtb
7256 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port): /soc/f=
unnel@821000/ports/port@8: graph node unit address error, expected "0"
7257 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port): /soc/r=
eplicator@824000/ports/port@2: graph node unit address error, expected "0"
7258 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port): /soc/e=
tf@825000/ports/port@1: graph node unit address error, expected "0"
7259 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port): /soc/f=
unnel@841000/ports/port@4: graph node unit address error, expected "0"

> > qcom/sdm845-mtp.dtb
7284 Error: arch/arm64/boot/dts/qcom/sdm845-mtp.dts:26.22-23 syntax error

>=20
> What are those warnings?

Sorry for being lazy, was in a rush last night.

Chris

