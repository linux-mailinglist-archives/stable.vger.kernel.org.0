Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BF12C9573
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 03:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgLAC56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 21:57:58 -0500
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:49126
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725859AbgLAC56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 21:57:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c51aJ2GzWSR2OV49KQ7P0mVj6vFfqekHvsHrX1ekxPnoGnBNKkh3kzfDT52iInBiBPN9c3+xIwo6kOM+cp54nptQ+1JpMETStx7wg75ybF3pLqaPaKvDMxgU7hLPV9TD2SWpiGlRpWvu9VgtJ0+KLlkznAquD4n8wKlnFkYCrFdNNqAKl/s7bhCEZ3VXYyfEz5uveWevHYRVqgStkDApfxuwHEc2Gj26HVCCU+LDktzArCzlrpTfzA0bsZUhNsa6m5LdozpeJ2EjCYQ26LUXHMxHKdkKB0jsiqGX5mciZcY5RxMTf2EKNSRNgAHEXOUGBgniNHB9wOjGnv+94XvwUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHPftpjLs7b0cb+2CtSM5Vw8323QUJ2LtOhEqqu25zU=;
 b=j+X2eq0NDeGC5W2pA6vx4LWhkCHTVD30YoQkGOrdxZtxFA2HTrejvHiX47uChZVsm3cOQSe//WfALB/q/HV3DoNgbdWnH+fxgn93G+3pTXgr5xv1z3bIAGZ+ymu3KX+H0ASg8NGpz2kTxtHd+2r0Is7Dc1U0Bkr6O5+13XLb2ipn3v3J2Nim28sB/ioAln8kVxZ91zlzKIegqb0rABrHpNTJ6xPbF2YtR552voiFBiQd2Fd8c2TUNh7ya68GU4OuixM4WsJepsOdv9dGR1lxmfVfmQxe6HQGoO+0DZ4V8luFXVJeAJDbJHNF2BS+0YAtfmhSszrdPmvvmvLFz96cxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHPftpjLs7b0cb+2CtSM5Vw8323QUJ2LtOhEqqu25zU=;
 b=ppKmOCeBh4sJrgcPvMEArdFMhNA/n0Ul2gwYbE9Q83NQRpxGtsrhH6v/eVQzs/w5RwTz6U+0/fo8V0dZQW52tIa0yaPaEZaS9RkX+InqdPX7ssBs6XoqsfcA22+wlUPA/IDRQwbpdIIMQxIHu5wxWdKJsajzCjX7jKPj8kYb9pQ=
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com (2603:10a6:10:1ec::9)
 by DBAPR04MB7222.eurprd04.prod.outlook.com (2603:10a6:10:1af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Tue, 1 Dec
 2020 02:57:08 +0000
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c]) by DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c%5]) with mapi id 15.20.3611.031; Tue, 1 Dec 2020
 02:57:08 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: chipidea: ci_hdrc_imx: Pass
 DISABLE_DEVICE_STREAMING flag to imx6ul
Thread-Topic: [PATCH v2] usb: chipidea: ci_hdrc_imx: Pass
 DISABLE_DEVICE_STREAMING flag to imx6ul
Thread-Index: AQHWxwxFchVR00Q6iUer2IB/+RVOsqnhjRWA
Date:   Tue, 1 Dec 2020 02:57:08 +0000
Message-ID: <20201201025639.GB11393@b29397-desktop>
References: <20201130113047.9659-1-festevam@gmail.com>
In-Reply-To: <20201130113047.9659-1-festevam@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.9.4 (2018-02-28)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c512b617-2e05-4929-80b8-08d895a4cb18
x-ms-traffictypediagnostic: DBAPR04MB7222:
x-microsoft-antispam-prvs: <DBAPR04MB7222876C35B957886CA720E08BF40@DBAPR04MB7222.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g8aZwxZ9EDgxYAxYzxYuJf3UwO0jWo2RImPtvxOGz5DYl0IpZBNvCbjBsxGjt/S0xTNYeul0BWbTX8KOBrngHjd4KCp6a3YrWyyhrzzHO7LjHSF8vRWaxkZPg4zn0vXH0itn2oi7OOz6Rxt1ckMQIoXTnhQCxyfavncrMi65WPB1irtNIfqgY9i5CzW4lNBSAY02MxTG/mqJyJsdNUPj9RbBgv2uS5co6CF+20oyAdhQnidkzEg1bjn0Dd+Xe3o7P1eCvlLyIgFctLLSX6KK3p2Del9slvvUQ99ISStTy3J8oHgs//Bh50CvL78XGqxbDAJt8tiQzOFuLdoFsX6m0ZantKm1IrwIWRuz4ZTzlqxbJFQLA0y/UYm3A88GjpZ3QFWD7Y8UG5i8qEPk07h4+LFi27J/kpg3z4ldz8PV/cdekS75Y8eFnUMWmbMuIH+1b/omXAs5VKGnPtIZei/hnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7979.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39850400004)(136003)(396003)(366004)(346002)(376002)(66446008)(44832011)(6512007)(54906003)(6506007)(2906002)(66556008)(91956017)(316002)(9686003)(86362001)(966005)(4326008)(64756008)(186003)(66476007)(71200400001)(53546011)(66946007)(76116006)(8936002)(83380400001)(26005)(5660300002)(33716001)(33656002)(45080400002)(478600001)(6486002)(6916009)(8676002)(1076003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aL6WWAehIQ/rxuqBxfP8RjDZxqzTwSVzaR0wYJEBqyKTOtjQbam5icpQm+HO?=
 =?us-ascii?Q?U2HbGhkk3RKSj8aj05FhZTlWJBBZjTQL4a0eZQFmC3R/Ts5NoIoiIQ2fnj0p?=
 =?us-ascii?Q?vFGXqnpMVXmN1JvgbYJUZdpazpf2W22BD5ABA6GEr6S6hFjAQzNagkQv2ye3?=
 =?us-ascii?Q?HLYIA1prBu62WVgIOTnBeEYWCSPr7+5cFtticLJNzVNq9nyRoQ8oWYf3B4zK?=
 =?us-ascii?Q?DUw+GPvDdqJADU+uhSfIGgu8+1cMgUOps13cdJuxZHod3GgxOExelud9jZb3?=
 =?us-ascii?Q?yGdM74YHCm/MRRsAbNPzQuVnH1gy2MFHF7aCC5RPcbW0QSCZbewM2VJXTzo2?=
 =?us-ascii?Q?YtFNcNQuoPxVj/0SyJ/s53oArMts2lj7wElMT7YtIURKYOolLJ5cPcAv4/ca?=
 =?us-ascii?Q?HI0BKYUzoyRel4DiGWkYHMGA9m4E6/v/EuRkHhdgUQqItS1GFMNnBKFUhOBe?=
 =?us-ascii?Q?J2O8ct91LBShtBekL9hl3r9NBZWrm09dw/7D+W4MLyGeyJafauNzGWlGsCgx?=
 =?us-ascii?Q?7SmZCXTdmacax/ijVm/NHmGGbFgT7n9WyQNMXO+8k9qYG7rU06UmaE4Rt+Jv?=
 =?us-ascii?Q?pB2/sHy0IjELEAJ0XNlXsSN6kZe+OuGidO6yGhofhlosKMwKjyV1Ov9eTIzW?=
 =?us-ascii?Q?PC86V1mURD1PgalXx3W1QyUGKRZA58HLCAAB0sgeqIRzP58S4FJoMcSyK+66?=
 =?us-ascii?Q?CBiyrDT40GGwAZp5hBSLDeZgwvILrkjmEsIiZnJq2Nb66lIkTPhY3rnbElLJ?=
 =?us-ascii?Q?PxiWZUvnd1M+U7wlJGqG1T0w1D9dmWu3Oo7E1LXO6zVbT019PK5AZwaqROgx?=
 =?us-ascii?Q?O0/C/803kO62XtW98dbHcY3vawkoiKwjOq/ohTuRV/YkCJN3Hr+Pb/J6DWw4?=
 =?us-ascii?Q?xSXdZoppP3xkF2qX8Oq9lH71EZmiVkrntuN8KKbtDC03OhiHQzE1+JtM1vt1?=
 =?us-ascii?Q?+T73bPeXz0OvYvnbXEkwH6p2tfqBU/J8Ff+hlvOmZ6TgacmD4Yn0M6X27rT6?=
 =?us-ascii?Q?NdBN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EC5CD9739A6B034DB602512E5F6CFE36@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7979.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c512b617-2e05-4929-80b8-08d895a4cb18
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 02:57:08.6196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O9fQeOqaMITAOvyHdtj9s29vGnArTLMMDIntbRVL/+mYkDUZyzoByVm8jgILbDStcwenE3lCco2L/Yv2Fyrwdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7222
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-11-30 08:30:47, Fabio Estevam wrote:
> According to the i.MX6UL Errata document:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.n=
xp.com%2Fdocs%2Fen%2Ferrata%2FIMX6ULCE.pdf&amp;data=3D04%7C01%7CPeter.Chen%=
40nxp.com%7C2d4f5ecc4fbf4100891808d89523674c%7C686ea1d3bc2b4c6fa92cd99c5c30=
1635%7C0%7C1%7C637423326572381531%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM=
DAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C2000&amp;sdata=3DlIBiWv=
deey56ihYUwT8nE%2B26GTykl67aQ2liekzOYt0%3D&amp;reserved=3D0
>=20
> ERR007881 also affects i.MX6UL, so pass the
> CI_HDRC_DISABLE_DEVICE_STREAMING flag to workaround the issue.
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 52fe568e5d71 ("usb: chipidea: imx: add imx6ul usb support")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
> Changes since v1:
> - Use the CI_HDRC_DISABLE_DEVICE_STREAMING flag instead - Peter
>=20
>  drivers/usb/chipidea/ci_hdrc_imx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci=
_hdrc_imx.c
> index 25c65accf089..5e07a0a86d11 100644
> --- a/drivers/usb/chipidea/ci_hdrc_imx.c
> +++ b/drivers/usb/chipidea/ci_hdrc_imx.c
> @@ -57,7 +57,8 @@ static const struct ci_hdrc_imx_platform_flag imx6sx_us=
b_data =3D {
> =20
>  static const struct ci_hdrc_imx_platform_flag imx6ul_usb_data =3D {
>  	.flags =3D CI_HDRC_SUPPORTS_RUNTIME_PM |
> -		CI_HDRC_TURN_VBUS_EARLY_ON,
> +		CI_HDRC_TURN_VBUS_EARLY_ON |
> +		CI_HDRC_DISABLE_DEVICE_STREAMING,
>  };
> =20
>  static const struct ci_hdrc_imx_platform_flag imx7d_usb_data =3D {
> --=20

Applied, thanks.

--=20

Thanks,
Peter Chen=
