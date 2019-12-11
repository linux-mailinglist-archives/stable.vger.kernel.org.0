Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E6F11A949
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 11:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfLKKws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 05:52:48 -0500
Received: from mail-eopbgr1410129.outbound.protection.outlook.com ([40.107.141.129]:16664
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726119AbfLKKws (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 05:52:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMRr4Z2dO9VKcGET7mX80x6OzWzySSQ/0Cr9zT64gvtP0xxbeISxkWeYVaVGwvNqBadXTsP3SH5QCM/6bCavDbq8hAzkurM8+8r04JgRyIQ31swSLUSe8Z/9zEwWgrtjVuisLqJYkRliUHQkpH9daKtoSM4e+GYdiU25S6BmFCxFX5tzMlWX4Qjc7naSWWdzpeGlCwmg6W1Et1ZO7RmDNBwY3VyxHYlZ5VFc7R12z6BhO52oiquG7ze9rAExl/vdY9WAsAG83qwRffAD1nN37C60m2q1DJBrKXTec5KVzdRyEuQw6aCsmqkNR7jzKiYkOL7bn/QoOGjq6dVZACcLpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmlc3TYmyPQvybPRefeN6KIwmrzzHuDRF6dE9Deikcw=;
 b=WFqaKRUEZW6YYsaxbAHb/z+xpr/V7OIbdh3x+9g9AafC0QZEmEyVjaOc0IkHnpdyxcNLy1JKnavdY/If1kiN2E7zIYvv8bqeB1ItYwgkx23107sTCrUQEf/EWryMysEeceWwjF9JYFHd6+5kr7vX9dJ453EMVP7LG3ufEDzY+r1tM/iYbVDU9RUmblD4UM8zHEvR15xyepWVGPxkhP9nXfNfqfRg3rB6OvHTgh0uGI67N4xiZON6lKL+l+2SY86r8MH0+SBTqILnnm8ORT7d4b7ys5LQlge3cuGzQyKmJcECv82er99+URRjm92CeJeb8+Kj9rxX6AH+2tNoa6R1Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmlc3TYmyPQvybPRefeN6KIwmrzzHuDRF6dE9Deikcw=;
 b=ca/BEJZv9XZOH/0XEf89FZtZSnVV387bGF9UwOtr417nXP8aruIZS4guXE1BNFiENcmf24qFChKz0LpvgcGYOHiYcEjH49QYOu7JHcbZOQSFv7fPua1LQfIWqgoR1HR6TzWt3MZX6W0CWd1taE1GAZTFKywpdf3dIDkSrwoXfgI=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB4047.jpnprd01.prod.outlook.com (20.178.140.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.18; Wed, 11 Dec 2019 10:52:44 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 10:52:44 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: RE: Linux 4.19.89-rc1 5944fcdd errors
Thread-Topic: Linux 4.19.89-rc1 5944fcdd errors
Thread-Index: AdWuq27YYqoiVr7aSmCEQeiV9xd6BQAC8Y6AAAjR8vAAFHfgAAALJekQAAQ6FQAAAMbvMAAL8uiAABoXtlA=
Date:   Wed, 11 Dec 2019 10:52:44 +0000
Message-ID: <TYAPR01MB22852454802BAB486871D944B75A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209173637.GF1290729@kroah.com>
 <TYAPR01MB2285135B15E6A152163E1A1AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210073514.GB3077639@kroah.com>
 <TYAPR01MB2285B5834B1FBA71F8DA512BB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210145528.GA4012363@kroah.com>
 <TYAPR01MB2285433EA1E6DF9EC621E31AB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210205951.GA4081499@kroah.com>
In-Reply-To: <20191210205951.GA4081499@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [90.218.76.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f17ee99b-bcc9-459f-5596-08d77e28407a
x-ms-traffictypediagnostic: TYAPR01MB4047:
x-microsoft-antispam-prvs: <TYAPR01MB4047B62BDF43344E80C7A326B75A0@TYAPR01MB4047.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(199004)(189003)(8936002)(7696005)(64756008)(8676002)(52536014)(81156014)(81166006)(6506007)(186003)(54906003)(26005)(55236004)(6916009)(478600001)(76116006)(9686003)(4744005)(66476007)(55016002)(4326008)(86362001)(71200400001)(2906002)(66946007)(316002)(66556008)(5660300002)(66446008)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB4047;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6wEJOTPJrFeAKjPjtMikeiJw02zI0py6xEUrZs7Wqc31MJa4DXOzyVc2aONJl/ck0pZo1QXYANdAuBcXXs02kK2RZSuWVZosuTwbqzRc7/wky7tblQ83GHrz8ckvdjz57hRjA92yINBJBi6CQ3uwXybPz0J7tk3K5in/omYWXk10JCJCDL+88D4rOnJTrH8d5UbuW+bwF+3+G6zGalktzSBe34TsKZqLHY5H+mGaLXqA1i0c4e/LtJ5oeb4NJx0i0EN7I6qn3HxFuQ4PquZ2O25AYjAfTG6A3ULogIZh9XUp1hgDnKvLXuKmlEMAqwjy4LRo/V+XlgdkXT7GwF0xBaKxXRVtuWSZtGeKBr4KH3ojKcMmVXlKO0Ql3E+zJxRNErNt7zeH5MogTN5dL4FisWd8OYnbS/a2o0Hd16K4uTO9fCNmFkXIsuJOifrw/DSN
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f17ee99b-bcc9-459f-5596-08d77e28407a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 10:52:44.0715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QClPJ46u+zxGN4Nz+ngmYQaC2/GHWE4gwvovgZbH9zjTleTf/Xi8yhmt/0VQtZwuvcYNw5Fhe+0enPglbe12vbV03xNw+aXf7AU7c0Xyweo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4047
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

[...]

> > > That's a lot, are these all new?
> >
> > I've only just started building with this config in our CI setup, but
> > building the dtbs locally with v4.19.88 didn't produce these results
> > for me (and building locally with v4.19.89-rc1 does result in the
> > above issues).
>=20
> Any chance you can run 'git bisect' to track down the offending patch?

The two dtbs that fail to build are fixed by reverting by the patches below=
:

> allwinner/sun50i-a64-pinebook.dtb
ea03518a3123 ("arm64: dts: allwinner: a64: enable sound on Pinebook")
> qcom/sdm845-mtp.dtb
d0a925e2060d ("arm64: dts: qcom: sdm845-mtp: Mark protected gcc clocks")

The rest of the dtbs just had warnings, all produced by the patch below:

> arm/juno.dtb
> qcom/apq8016-sbc.dtb
> arm/juno-r2.dtb
> arm/juno-r1.dtb
> hisilicon/hi6220-hikey.dtb
> qcom/msm8916-mtp.dtb
> qcom/msm8916-mtp.dtb
3fa6a276a4bd ("kbuild: Enable dtc graph_port warning by default")

Kind regards, Chris
