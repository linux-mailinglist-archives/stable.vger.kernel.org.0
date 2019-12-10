Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4281118C5E
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfLJPU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:20:28 -0500
Received: from mail-eopbgr1400104.outbound.protection.outlook.com ([40.107.140.104]:11904
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727272AbfLJPU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 10:20:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBKgd+TjRrDMftNtCDSQr+0ecT+Xunt+STdkJKGh58wlsiEJ2+Ebmqi47l2K54cV7Cx/VsQVOqHOVRcs5mXX9WskTtyKhFHGvwQ0ljAAqxmkjAqIf/2J5CfYYUZOOGMDCqUdAf8spT+uLiRbwPMOLbcPZQkpAngQl7VZJgvc09y6nn9roGNZW5lZOMO2WMjy6ol7a2xnPDYKV/lZrPQ81qf+0h8twITPTgy5MTd+aAVG+G2Pscq+lx1gdO4cV+nJsuvZV6PXC8+DLZ9aIWq0a4ZkIMzmvkv1B94/zZ33mEZlvqslOp6Jj7zZ2iHtRKldOpqHSCBTCbwfVPJWBLZlzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A60XTFIOC6gaKYg2os1dgMGe8UsguPgcrVzDth3MRK0=;
 b=htluuNZGMqI3L+2okSiufNLD4ZEowaUWQlOrYIybGlY2GaqweWI0+by/5w0d+goDhm9FQoZJkX5ieuLG3hF/yc3Vr417DRm587glYTmZGsJAEp4Ddt3UKYDdE2zG28v18kTaYDjU7hxvFyREN3B9uj8v/IugUWY6tZT51kDmoplzILxcSs2MkCvFRw07yetyFDVOCdKs1s+kuEvrU32lMPF6vC98SPwmZaYwJgL2LZ95Imx8gHTSbGq9vS/rTNpn2wqC9iKlQ2mzdWCHN6LTDoOIUWZXAjic8aNnNOtv1BsvvJNClV6dJvOCvgEFW1VMizlCkPSZoNDjaDaXGcAoVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A60XTFIOC6gaKYg2os1dgMGe8UsguPgcrVzDth3MRK0=;
 b=DAQs/6F+IpV+8aCouHgcJB1jKpz81ScHde+YP72sb6ObpbFtCNTFJNQYQZJOBmlD5iSnSYtB13LGx9ilkwz0u18utAO1ZW0JjwDL8EHtSYy75BG+RM2xHtPrHAtoMPZRepMk7Jk+mxyxL4hS9PQlZlI8IdrrEiX+qXBHFf+vKUg=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB2112.jpnprd01.prod.outlook.com (52.133.176.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 15:20:23 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 15:20:23 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: RE: Linux 4.19.89-rc1 5944fcdd errors
Thread-Topic: Linux 4.19.89-rc1 5944fcdd errors
Thread-Index: AdWuq27YYqoiVr7aSmCEQeiV9xd6BQAC8Y6AAAjR8vAAFHfgAAALJekQAAQ6FQAAAMbvMA==
Date:   Tue, 10 Dec 2019 15:20:22 +0000
Message-ID: <TYAPR01MB2285433EA1E6DF9EC621E31AB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209173637.GF1290729@kroah.com>
 <TYAPR01MB2285135B15E6A152163E1A1AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210073514.GB3077639@kroah.com>
 <TYAPR01MB2285B5834B1FBA71F8DA512BB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210145528.GA4012363@kroah.com>
In-Reply-To: <20191210145528.GA4012363@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 347cff9b-a2f5-4c73-947d-08d77d8479eb
x-ms-traffictypediagnostic: TYAPR01MB2112:
x-microsoft-antispam-prvs: <TYAPR01MB2112B4BD2955FDCEA7E853CCB75B0@TYAPR01MB2112.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(189003)(199004)(2906002)(30864003)(66556008)(966005)(26005)(4326008)(76116006)(64756008)(71200400001)(55016002)(9686003)(66446008)(186003)(81166006)(6506007)(478600001)(7696005)(66476007)(54906003)(33656002)(66946007)(86362001)(8676002)(110136005)(52536014)(316002)(5660300002)(8936002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB2112;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UdnaSLOCMv2OWLEX7VlicBb76V/F/BjSDuinDnAEGikVZ6KVZCAX+b+NIHJ4V3fE/gIc6cgL5XeWRS4OkxOQcmkw90dWPxXScClgbr8pvg0UFneT2/oBhSmfRT3mVCVqIRtqmK+CqvWlS6bVXU73JRIzc6ROtPrLYtEUOoPtS1p8EH/s1o0j2wCJzp34tcqYHsDiMOQKdbTUszdQylm7by2Qp3578UXTUVPyT1zCmliqfwMO9Wn6C74Lig5aLIyNzEih2LCAWt2cYBTYgDLYOx41gmDx/cD6Slvxx2JO92JDt5ggI1Ejeu3VaLGNTM4Jl0BdD4N9ZFBbFahG8NwhaiBukAlK2h2SSWArVKsnDlCUJTKoAm6RDpS2KhpvhDz5Ijk2aveRFoyXAxwhsS34Vo4BBGCG081v84KAIBvKRDZ8tgkP5q5MGrDW+keJqOYBZOMuWguL1M1wrpDZPVDMlq9Dz6uhnPEz/bijgdTxW5g=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 347cff9b-a2f5-4c73-947d-08d77d8479eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 15:20:22.9012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GrlEcgl2LJXNf4RGuAztEajKbDdfdC/jo793Rc79OQBF36q6+mEOpLxt/gl/9oG1NQ0NLywpDPJP5ijwh6NtiAK2arIPOFFGk4FzdMWSfHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2112
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 10 December 2019 14:55
>=20
> On Tue, Dec 10, 2019 at 02:42:45PM +0000, Chris Paterson wrote:
> > Hello,
> >
> > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > > Behalf Of Greg Kroah-Hartman
> > > Sent: 10 December 2019 07:35
> > >
> > > On Mon, Dec 09, 2019 at 09:56:29PM +0000, Chris Paterson wrote:
> > > > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org>
> On
> > > > > Behalf Of Greg Kroah-Hartman
> > > > > Sent: 09 December 2019 17:37
> > > > >
> > > > > On Mon, Dec 09, 2019 at 04:29:22PM +0000, Chris Paterson wrote:
> > > > > > 3)
> > > > > > Config: arm shmobile_defconfig
> > > > > > Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> > > > > /jobs/373484089#L2249
> > > > > > Probable culprit: 984d7a8bff57 ("pinctrl: sh-pfc: r8a7792: Fix =
VIN
> versioned
> > > > > groups")
> > > > > > Issue log:
> > > > > > 2249 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro
> > > > > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > > > > 2250   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > > > > > 2251                                       ^
> > > > > > 2252 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error:
> > > > > 'VIN_DATA_PIN_GROUP' undeclared here (not in a function); did you
> mean
> > > > > 'PIN_MAP_TYPE_MUX_GROUP'?
> > > > > > 2253   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > > > > > 2254   ^~~~~~~~~~~~~~~~~~
> > > > > > 2255   PIN_MAP_TYPE_MUX_GROUP
> > > > > > 2256 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro
> > > > > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > > > > 2257   VIN_DATA_PIN_GROUP(vin1_data, 20, _b),
> > > > > > 2258                                       ^
> > > > > > 2259 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro
> > > > > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > > > > 2260   VIN_DATA_PIN_GROUP(vin1_data, 16, _b),
> > > > > > 2261                                       ^
> > > > >
> > > > > Now dropped for 4.19, 4.14, and 4.9 (2 patches for 4.19 here.)
> > > >
> > > > Latest 4.19 now building, but I'm seeing a number of warnings and e=
rrors
> when
> > > trying to build the arm64 defconfig dtbs.
> > > > https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/3740924=
42
> >
> > > > arm/juno.dtb
> > 7150 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /etf@20010000/ports/port@1: graph node unit address error, expected "0"
> > 7151 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /funnel@20040000/ports/port@1: graph node unit address error, expected "0=
"
> > 7152 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /funnel@20040000/ports/port@2: graph node unit address error, expected "1=
"
> > 7153 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /funnel@20040000/ports/port@3: graph node unit address error, expected "2=
"
> > 7154 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /funnel@220c0000/ports/port@1: graph node unit address error, expected "0=
"
> > 7155 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /funnel@220c0000/ports/port@2: graph node unit address error, expected "1=
"
> > 7156 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@1: graph node unit address error, expected "0=
"
> > 7157 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@2: graph node unit address error, expected "1=
"
> > 7158 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@3: graph node unit address error, expected "2=
"
> > 7159 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@4: graph node unit address error, expected "3=
"
> > 7160 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> /replicator@20120000/ports/port@2: graph node unit address error, expecte=
d
> "0"
> >
> > > > qcom/apq8016-sbc.dtb
> > 7173 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port):
> /soc/funnel@821000/ports/port@8: graph node unit address error, expected
> "0"
> > 7174 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port):
> /soc/replicator@824000/ports/port@2: graph node unit address error,
> expected "0"
> > 7175 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port):
> /soc/etf@825000/ports/port@1: graph node unit address error, expected "0"
> > 7176 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port):
> /soc/funnel@841000/ports/port@4: graph node unit address error, expected
> "0"
> >
> > > > arm/juno-r2.dtb
> > 7181 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /etf@20010000/ports/port@1: graph node unit address error, expected "0"
> > 7182 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@20040000/ports/port@1: graph node unit address error, expected "0=
"
> > 7183 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@20040000/ports/port@2: graph node unit address error, expected "1=
"
> > 7184 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@220c0000/ports/port@1: graph node unit address error, expected "0=
"
> > 7185 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@220c0000/ports/port@2: graph node unit address error, expected "1=
"
> > 7186 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@1: graph node unit address error, expected "0=
"
> > 7187 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@2: graph node unit address error, expected "1=
"
> > 7188 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@3: graph node unit address error, expected "2=
"
> > 7189 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@4: graph node unit address error, expected "3=
"
> > 7190 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /replicator@20120000/ports/port@2: graph node unit address error, expecte=
d
> "0"
> > 7191 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@20130000/ports/port@1: graph node unit address error, expected "0=
"
> > 7192 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /etf@20140000/ports/port@1: graph node unit address error, expected "0"
> > 7193 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@20150000/ports/port@1: graph node unit address error, expected "0=
"
> > 7194 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> /funnel@20150000/ports/port@2: graph node unit address error, expected "1=
"
> >
> > > > arm/juno-r1.dtb
> > 7195 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /etf@20010000/ports/port@1: graph node unit address error, expected "0"
> > 7196 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@20040000/ports/port@1: graph node unit address error, expected "0=
"
> > 7197 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@20040000/ports/port@2: graph node unit address error, expected "1=
"
> > 7198 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@220c0000/ports/port@1: graph node unit address error, expected "0=
"
> > 7199 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@220c0000/ports/port@2: graph node unit address error, expected "1=
"
> > 7200 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@1: graph node unit address error, expected "0=
"
> > 7201 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@2: graph node unit address error, expected "1=
"
> > 7202 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@3: graph node unit address error, expected "2=
"
> > 7203 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@230c0000/ports/port@4: graph node unit address error, expected "3=
"
> > 7204 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /replicator@20120000/ports/port@2: graph node unit address error, expecte=
d
> "0"
> > 7205 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@20130000/ports/port@1: graph node unit address error, expected "0=
"
> > 7206 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /etf@20140000/ports/port@1: graph node unit address error, expected "0"
> > 7207 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@20150000/ports/port@1: graph node unit address error, expected "0=
"
> > 7208 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> /funnel@20150000/ports/port@2: graph node unit address error, expected "1=
"
> >
> > > > hisilicon/hi6220-hikey.dtb
> > 7209 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/funnel@f6401000/ports/port@1: graph node unit address error, expecte=
d
> "0"
> > 7210 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/etf@f6402000/ports/port@1: graph node unit address error, expected "=
0"
> > 7211 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/replicator/ports/port@1: graph node unit address error, expected "0"
> > 7212 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/replicator/ports/port@2: graph node unit address error, expected "1"
> > 7213 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/funnel@f6501000/ports/port@1: graph node unit address error, expecte=
d
> "0"
> > 7214 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/funnel@f6501000/ports/port@2: graph node unit address error, expecte=
d
> "1"
> > 7215 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/funnel@f6501000/ports/port@3: graph node unit address error, expecte=
d
> "2"
> > 7216 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/funnel@f6501000/ports/port@4: graph node unit address error, expecte=
d
> "3"
> > 7217 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/funnel@f6501000/ports/port@5: graph node unit address error, expecte=
d
> "4"
> > 7218 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/funnel@f6501000/ports/port@6: graph node unit address error, expecte=
d
> "5"
> > 7219 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/funnel@f6501000/ports/port@7: graph node unit address error, expecte=
d
> "6"
> > 7220 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_por=
t):
> /soc/funnel@f6501000/ports/port@8: graph node unit address error, expecte=
d
> "7"
> >
> > > > allwinner/sun50i-a64-pinebook.dtb
> > 7248 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:82.1-=
7
> Label or path codec not found
> > 7249 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:86.1-=
14
> Label or path codec_analog not found
> > 7250 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:91.1-=
5
> Label or path dai not found
> > 7251 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:297.1=
-7
> Label or path sound not found
> >
> > > > qcom/msm8916-mtp.dtb
> > 7256 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port):
> /soc/funnel@821000/ports/port@8: graph node unit address error, expected
> "0"
> > 7257 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port):
> /soc/replicator@824000/ports/port@2: graph node unit address error,
> expected "0"
> > 7258 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port):
> /soc/etf@825000/ports/port@1: graph node unit address error, expected "0"
> > 7259 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port):
> /soc/funnel@841000/ports/port@4: graph node unit address error, expected
> "0"
> >
> > > > qcom/sdm845-mtp.dtb
> > 7284 Error: arch/arm64/boot/dts/qcom/sdm845-mtp.dts:26.22-23 syntax
> error
>=20
>=20
> That's a lot, are these all new?

I've only just started building with this config in our CI setup, but build=
ing the dtbs locally with v4.19.88 didn't produce these results for me (and=
 building locally with v4.19.89-rc1 does result in the above issues).

Regards, Chris

>=20
> Sasha, any ideas?
>=20
> greg k-h
