Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A491178EA
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 22:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLIV4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 16:56:33 -0500
Received: from mail-eopbgr1410117.outbound.protection.outlook.com ([40.107.141.117]:33703
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726483AbfLIV4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 16:56:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDEZZYMnguNU6ggHJUjjJUX9D6fvnK33PHoaJyiAkYOYceccqKs61EQYv4kTPSOWaY5JEQKIRYT5h7ffZN2GBFugEyt5qE/hS6KJXJIVT9AMEDo8EpXspEkJggy+j7PefirISWM4NNStPYmj3Rs7nUTdzHeds05duqwlnIeKz7sxroMzFw09bBjrxJKs94EWIfob77vCp05mjXzM89MUI/qYbNZuJSTsTy3wuDwz95SsAwpCgYvafxPJYb8SApHIgJUhW+NT8zRWIwRFe4DAR2wTwHTqaDSTNsa01ZwG1yv/M1dJ8M4w702P4yLrHIMqqt+rcI22Nu7ov5zhi70iig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pLAbRmeqHvqn1e0GPEEzjbjxxpRs9HfiR22RMfkrr8=;
 b=P3LYF3Puvx08lK/gM6h6NezFFRaC0PUs5JNcXwqxDfpg0swxhoQ32qFV2EP2oXfLhs5tZlcl0qAoRyYKxu0FAfgWIWdZ2LzH5t4uvQqs3Vc5GtR9ID1IunDgi5GptySzT7f9+Sjbnigq3o7Z48ZI9CWW9MsoFfno5Hf3jfqDkCOm1LBa+r68dGasncfyHEfnpkyTD7A4+7lIEAZLCC23ygBFc/N9OKqbPHulwKemsoxYjf+BjvDDp/k2HOEb8ObbvQj3sjB2tWYK6C7Ti70ZRbNJrbww8OdfutVgBnjTHG3VNKN0TZJF02OjjSTIrbIyXwbmI3yJC7FA16I5vFvpLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pLAbRmeqHvqn1e0GPEEzjbjxxpRs9HfiR22RMfkrr8=;
 b=rCgzgHlhjbuPgwmzByrORu9U0plnn1ABZP4iT9nnmKhMEQoRiTPVQlhC4N+ZWFuNXElQ9jVqsJrUWLC/pEhqf4aWmoUcshdVkRMyZ8xkPFBN5kGT0TYIss54e0+R9A7mNswNfsibaa18/W36rL20t33M5bjOi4rFi3z1kSyu9bc=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB3629.jpnprd01.prod.outlook.com (20.178.137.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Mon, 9 Dec 2019 21:56:30 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 21:56:29 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: RE: Linux 4.19.89-rc1 5944fcdd errors
Thread-Topic: Linux 4.19.89-rc1 5944fcdd errors
Thread-Index: AdWuq27YYqoiVr7aSmCEQeiV9xd6BQAC8Y6AAAjR8vA=
Date:   Mon, 9 Dec 2019 21:56:29 +0000
Message-ID: <TYAPR01MB2285135B15E6A152163E1A1AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209173637.GF1290729@kroah.com>
In-Reply-To: <20191209173637.GF1290729@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [90.218.76.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f162a77b-ead7-4209-8da0-08d77cf2a5aa
x-ms-traffictypediagnostic: TYAPR01MB3629:
x-microsoft-antispam-prvs: <TYAPR01MB3629B6700D0C0ED2D6EFCC99B7580@TYAPR01MB3629.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39850400004)(136003)(366004)(376002)(346002)(199004)(189003)(54906003)(316002)(71200400001)(33656002)(2906002)(966005)(478600001)(52536014)(6506007)(71190400001)(5660300002)(55236004)(26005)(64756008)(66446008)(86362001)(66476007)(186003)(66946007)(55016002)(76116006)(9686003)(66556008)(8936002)(4326008)(305945005)(229853002)(81156014)(7696005)(8676002)(81166006)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3629;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a/w9kuo6SWz5b2vB4WssgYHr8s5/FD8FQ22WirICz8IgsAgZud6Wp9CtvD++P2UDQ7tbs3uc5K2bgvZg3C37q22SjHuiy//ow4vnFI/7pXtqfX7RYne1NFXlWNztLGqklbzFtMswkwJGmZ7aqNxI7aJ/W9lk39j8XXCR6hEfEu6pZ/z9ZA4HhSntiFa4MqbAIFuqaAqjmB+K+Eb2+zijGTZbxYHpwkHb0ZtLvFv+T7cSlUWjnr/iiCNZQWcQOjeLzadvAlB11HhlzSv3sCbv0/hRgSMYKBIcX7mg0bGXkl+NsYtPWNPX62Jxzqm7iA/yFkiOxfiSyzkIYtifc08jcFRhxeW2tin+FXOD+mjOGGvoXs43DKwI8bcCPj8Zl5ZxjrU+UFNtDoqQF8p9imRjJx3xRmrQ8bRpMn9abl10IAT3Hs7jIOmV1aDEbVko/fhS/m+zmMdzxcbLByAYBmhEIXdJsHwJYE5b9wbYjkklR7s=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f162a77b-ead7-4209-8da0-08d77cf2a5aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 21:56:29.7703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Zzf7v3KRfkEWDBqED21O2DIoUoJpDMkCXA7dyRLHtDqxXbYMSIqZI25WspL5OKiKfQqjS7yOPceI48dxK/xSku/A9aj81wMqcOSGSxHoic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3629
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 09 December 2019 17:37
>=20
> On Mon, Dec 09, 2019 at 04:29:22PM +0000, Chris Paterson wrote:
> > 3)
> > Config: arm shmobile_defconfig
> > Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> /jobs/373484089#L2249
> > Probable culprit: 984d7a8bff57 ("pinctrl: sh-pfc: r8a7792: Fix VIN vers=
ioned
> groups")
> > Issue log:
> > 2249 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro
> "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > 2250   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > 2251                                       ^
> > 2252 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error:
> 'VIN_DATA_PIN_GROUP' undeclared here (not in a function); did you mean
> 'PIN_MAP_TYPE_MUX_GROUP'?
> > 2253   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > 2254   ^~~~~~~~~~~~~~~~~~
> > 2255   PIN_MAP_TYPE_MUX_GROUP
> > 2256 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro
> "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > 2257   VIN_DATA_PIN_GROUP(vin1_data, 20, _b),
> > 2258                                       ^
> > 2259 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro
> "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > 2260   VIN_DATA_PIN_GROUP(vin1_data, 16, _b),
> > 2261                                       ^
>=20
> Now dropped for 4.19, 4.14, and 4.9 (2 patches for 4.19 here.)

Latest 4.19 now building, but I'm seeing a number of warnings and errors wh=
en trying to build the arm64 defconfig dtbs.
https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/374092442
arm/juno.dtb
qcom/apq8016-sbc.dtb
arm/juno-r2.dtb
arm/juno-r1.dtb
hisilicon/hi6220-hikey.dtb
allwinner/sun50i-a64-pinebook.dtb
qcom/msm8916-mtp.dtb
qcom/msm8916-mtp.dtb
qcom/sdm845-mtp.dtb

Kind regards, Chris

>=20
> thanks,
>=20
> greg k-h
