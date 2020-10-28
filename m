Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E220D29D63C
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgJ1WNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:13:00 -0400
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:53248
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730813AbgJ1WM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:12:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DV7EQHlEpHrmqXIwTmf/I7v4z0fGzv88KxTcDm3bbRPv3CBRd32DEiYMEOiqVNTwKiyHnmaK5m9r923CB9IiC2B0NZQxiHOgc6LKrKC0KJtAwWMypnv+7lvqYdiZUI6uuYyyExWxsi0x3kRDKHb2mZV1k/OZyriNCJZrwJCBfP0AiyWamd7ff8Kb97FExWprgS+TPJK6euJ83wSvv6gkrRYkXC/ZdaCuoRxDa92Py/dol9wpgofzxbMBiHtd9HcAy7Kk+mMmYmL1cTk8FU4gp8OT+jPZCLE7MCiVmwuLsRcRKiEA2H731SKVNl41Op1sSs1yMhkC/H3MhQbYINODDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hq2JOW9l8aZmNgK5FcHlbJQrRV+ZFJT2Rh9kERRxf1c=;
 b=SWyeLI6OMyTIbN9aQiaTLW4XybtooVXConliVgXV29QHIxuvqHvoWhEKKLbcczQVFia6zr3lvCGmAH3P0MuHTn9Hm9k+yp2ymWgGwbb6YqErL13hXys6yuETlG7Lxy5AGIVOCVxe4rbLt2tKUukM/89dIU/+mr8igk8PKxbzkJ5o5eRpeTpXftx5NrgESm2HOT661nXdR0FF9UNOHAnamMP1nPqaP4cVjLvPub/GU6VfrMuha2AP5eZSSGbkBLCyV8mTulD4A4EwvktUPN/xiomA6d5TVI4bPmwvdTV2s2KLjVquM7pzeZxL114FX8LQs1KASUH4i01MMFjgRP4IXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hq2JOW9l8aZmNgK5FcHlbJQrRV+ZFJT2Rh9kERRxf1c=;
 b=bUlWykn8oLoK7GFMLfZD5qG1nP3F7cZtKvZZRcDs8BAgoCnSxmjNMPS0UFKzWazUo1mPPrIgtuE9a7cDSAN6UtlWOFWHhqWmXu22gVFbTh183TQGYPv1iI0rsSyu5BQUi0bFmO6ZMstmfsOiZ4iOflkYeIj+qJii7duws6tk480=
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12)
 by AM0PR0402MB3538.eurprd04.prod.outlook.com (2603:10a6:208:1f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Wed, 28 Oct
 2020 06:41:30 +0000
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::b902:6be0:622b:26c2]) by AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::b902:6be0:622b:26c2%4]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 06:41:30 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     Felipe Balbi <balbi@kernel.org>,
        "pawell@cadence.com" <pawell@cadence.com>,
        "rogerq@ti.com" <rogerq@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jun Li <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign
 extension
Thread-Topic: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign
 extension
Thread-Index: AQHWo6WTaRKfd0hXEU6nD+tea3QI1qmrOMeAgAAMjoCAAExEgIAA3u9A
Date:   Wed, 28 Oct 2020 06:41:29 +0000
Message-ID: <AM8PR04MB730012810E26CEE055A4E99C8B170@AM8PR04MB7300.eurprd04.prod.outlook.com>
References: <20201016101659.29482-1-peter.chen@nxp.com>
 <20201016101659.29482-2-peter.chen@nxp.com> <871rhkdori.fsf@kernel.org>
 <20201027094825.GA5940@b29397-desktop>
 <20201027142123.GA1233346@rowland.harvard.edu>
In-Reply-To: <20201027142123.GA1233346@rowland.harvard.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: rowland.harvard.edu; dkim=none (message not signed)
 header.d=none;rowland.harvard.edu; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [180.164.158.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ff2df2df-f7d4-4c8c-d8fd-08d87b0c80af
x-ms-traffictypediagnostic: AM0PR0402MB3538:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0402MB3538DEC7734D4C2A600B71098B170@AM0PR0402MB3538.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ERdITCtAn4eIbyXwYwuf2+5sF6PkqKcVuJkh0bVaTJ8Y7OP4J83O0W+jGpaL4LLEc5V2+jjXp3GKvEqIZWCesn/4IEx9gjcfFrB5DfWN1q3PIfeg19t2vdpJj+SYioTnyRiuenHahQwuDKzjsinuUcWnOEn59oeOaBvkqA1AKibyggWyhY7zvK5ltQu5mRsbCMYBkhcxDpC650W4hy+mEfkMmlf2mjdrJZaZVqvWSpGojhCe69OzHxVs1EdO4xloa+o3tvHt4BKht+k0mde10yTQAvnFfSCqF0Lu2kwiJJXnwqv4AbycyEAJbfHOBjsJhiQEcd8hP5lbhZMT/eIvDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7300.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(478600001)(76116006)(66946007)(9686003)(86362001)(8936002)(66556008)(8676002)(66446008)(64756008)(66476007)(54906003)(316002)(4744005)(6506007)(7696005)(26005)(4326008)(55016002)(33656002)(83380400001)(71200400001)(5660300002)(52536014)(2906002)(44832011)(6916009)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 4B7N212COZtfaq9BNOOdoEIVU31rlDeVK87j/pEjgw/f1YzoztVt1F9Ya5fUuflRz/5jAJ2yxX4Xo/VEwOCgmGPHIGp9EpvI+/B9df9XRYh05m7Olon6WSXIe04H6X7kZwKoQCYLLIPQWlW7Kc7Bcs2STSyaa8CZQiqOffAqOMZS4t74SQKOAXdHEO3Jtob0ndq+P//RnwfS5wwYhQRgDlfIDEIJrYxIhZ5+GtuurfyZQ0raxImiUbt21Y9UxkXNNzS9nKa84pGwRhVCh9lvVVu/yeFoeyuC5tmqU0hEDWMuWr0j3BjRNidpmc4Gd0N5BJbtp/Xpo+/H/z56J5z2GiF0eOjLtHuiRfXAEqq+JELlRjr3Sbi+UR6RXeZWygnc2LccOYsoZ60n95ZiYVv0l0VyLismfeZkjjrceVwBPEM1la6bYvLuHspJxFjdhwmnArrgiW4uAlRU0rFAvt0xQicN6s0uzwrEyhjYo4xW5fBifNtzRFt5426WaqUXhwYS5ZFgJiW6EhCROIx/mJGI5NUvKccMKBdGuvXrL5kC0JDtJRA7WnlbCweTpa0o8b4ZUSXCRU/GuFrswFK8D+hM9Kkcf1CeHyw8Cr7nk8xVR4fq0ZzIWIB7tV8qv1QVHSQ7IV4chEquEQPizDoTMhzHRQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7300.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff2df2df-f7d4-4c8c-d8fd-08d87b0c80af
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2020 06:41:30.0851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7+UBEZPYuyiIU+vdhVNeglWuG8kg9niJvxRbU+hGi6fS24Ua4mHqI/E07GxecrEJ3JFl3Q7N2rudDthAJnVIxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3538
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=20
> That's a separate issue.  I believe (but haven't checked) that the << ope=
rator
> has lower precedence than +, so the compiler interprets the expression as=
:
>=20
> unsigned int k =3D 0x80 << (24 + 0x81);
>=20
> and it's pretty obvious why this causes an error.  Instead, try
> compiling:
>=20
> unsigned int k =3D (0x80 << 24) + 0x81;
>=20
> You may get an error message about signed-integer overflow, but not about
> shift-count overflow.
>=20

Hi Alan,

Your analysis is correct, I did not check the warning message correctly.

Peter
