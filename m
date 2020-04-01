Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC9919A485
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 07:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgDAFMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 01:12:48 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:56199
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726811AbgDAFMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 01:12:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AP/8KbqKZU6eBog9Ysf8+7cBv/kWjXx3qjEX2Qs0UO0vv77UC1LZDD/xKxkZpw4HqkJ6i90NemPgkDU79TU7JiDybg6CHhvgixlRNBeV7a8I9zCvUXuIuDVnZJnYg6/sbMQT5NF9MFKizW8iB9LmyplUcRxg3w6wI8UJpRtj2xD4B++iO8Go1ZhXsAlT2wR22ld2vjs5CLJBDTGAxwIFTG7rPx82OqINojW1w2TjkzRsyixaNFNDEEABgfgpVbcXklFD8Qd1VQJxRSf+yXfIMb8uyt+AU90Ct8TbKE67amOKd9sA5nMVWxSvUrgqFdV7lzpSdf2nsl8/Bq61BMHZVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEBmU8EJNGxUmD8uVbJhmMmmn2Cm6/NUccNDMd9d7rc=;
 b=HhbMXR6x3SaCnZ9Q7yy/EtQ/Yx/uCMsMF4w9ZDNqJPpQEdKyzx+ts0R4bVRXM5yiobblfEBODlB0UHwWp4J9q/JlgIWIx6apdyDv8KLZXr14jKXUEJRfTUcEb2ajR2xr64C57o0nWSPZQm6Zifwc+zGTQQd1QNHQM9GREAsSaP2iIglYbb4QHfq0iGRCU6E3tkr47T+qNcogM09HndMHryk705SLqjEkw1poow+1FnbNhG9hhyzYrA20mgxQnQWdkvWKWunH8RiFF0q1kfiku4HSEq+kU9+nsWdtuDUeJhWEcrVCK0S7RU3CWFRaJw2QGZS/rysCJc63P/stfrDnUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEBmU8EJNGxUmD8uVbJhmMmmn2Cm6/NUccNDMd9d7rc=;
 b=HVLFbAVGYyhKHtYLqmAVCJevbYrqVIyhWrE08+g3ItSgGsTFrOFpI91/aX/Sh9TNjgeuK2nfQ2woRZGSN5gCRF4A/paG4xYqmcE0Q2+sjVw//1CZPd0taFAZSxbJfYm8nGT2E6fNQTQVoubx5Fq3gHzqB+Qk0tJDpGrRoci2YJc=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB7079.eurprd04.prod.outlook.com (52.135.58.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Wed, 1 Apr 2020 05:12:44 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 05:12:44 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Daniel Walker (danielwa)" <danielwa@cisco.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Shyam More (shymore)" <shymore@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: RE: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Topic: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Index: AQHWB532KYmmzOSk9kuuDMNOQaxK86hjtsqg
Date:   Wed, 1 Apr 2020 05:12:44 +0000
Message-ID: <AM7PR04MB6885CDDD1ECEEAE7111C6201F8C90@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200331205007.GZ823@zorba>
In-Reply-To: <20200331205007.GZ823@zorba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 55be8abe-9580-44d9-a803-08d7d5fb4f7e
x-ms-traffictypediagnostic: AM7PR04MB7079:
x-microsoft-antispam-prvs: <AM7PR04MB7079572D675186BF24C72015F8C90@AM7PR04MB7079.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(71200400001)(316002)(54906003)(55016002)(6916009)(9686003)(81156014)(2906002)(81166006)(478600001)(8936002)(64756008)(186003)(52536014)(76116006)(26005)(8676002)(33656002)(5660300002)(86362001)(53546011)(66946007)(66446008)(6506007)(7696005)(66556008)(4326008)(66476007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hjgs5AEZv9GASIK5FnqNAnY4xdguvFybRvt5rk+YEDWAAsMJyYR3pPnkGF45Wcfj9U1wcjiVfV0vv66o0ehLLAcivBOFUMPdwsBed94bvVR2BenqdNM8XRGZDFJx97DjRGpOGJsRal1ycPCkqjBRhPxUt6qfhqkOUKSHAo+3nCm4FiySGXEVNulLpICUP4dRUldOrMv9Tq0aPuoxdvl8g1eJ4NxHcLvISdwaWMgM+J/cqwYtlny90rDYsAtVxNpK+VvdnDsfaxQtjHajkFJvVrHZpUhd/IEC7ZWKfFO4l1oaQgXYTRaMIGMH6M66vf0tsb1jWoh/FMUCh24PUNPEqeCaqJRvaJut+axOq6SKm5DipA1LDkV/kXCh32/lN9HqtyFE8Rkh9yPDtTR4U9WYWAB+xqXCXrXp7FYkyUByseOB8lYFP3AYzjjSeeWjEnlL
x-ms-exchange-antispam-messagedata: 3k8daXVHtRmaQMhc+93c6uA7Bpk5qzTQUKcNiU8S8slvKw19d/idfSEapRnbkoOHvOhWBx66XkknjNkgWfuLWJHKT68ac76EyvI90fftOAmUjf/D+AJMay2s+ePZyRSPkUTl0H/wa/tUKOAJztsWOg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55be8abe-9580-44d9-a803-08d7d5fb4f7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 05:12:44.3173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JJrq/ETw3DXvFn/rbPzTVFeoCp9tBavDAnIoGJcmI6+7HmU+Gg8W5Ln/Z/HJkrqTSb0685MxsUUkSEDrR0LrYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7079
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

Sorry for the trouble.
I think you were saying below patch introduced issue for you.
fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling

Actually it looked fine from code. Probably it resolved its own issue but c=
aused another.
I don't know which kernel you were using. Could you have a check whether my=
 other fix-up patches which may be related to P2020 in your kernel after th=
at one?
I remembered P2020 should work.

80c7482 mmc: sdhci-of-esdhc: fix serious issue clock is always disabled
429d939 mmc: sdhci-of-esdhc: fix transfer mode register reading
1b21a70 mmc: sdhci-of-esdhc: fix clock setting for different controller ver=
sions
2aa3d82 mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller ver=
sions
f667216 mmc: sdhci-of-esdhc: re-implement erratum A-009204 workaround

Thanks a lot.

Best regards,
Yangbo Lu


> -----Original Message-----
> From: Daniel Walker (danielwa) <danielwa@cisco.com>
> Sent: Wednesday, April 1, 2020 4:50 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: stable@vger.kernel.org; Shyam More (shymore) <shymore@cisco.com>;
> xe-linux-external(mailer list) <xe-linux-external@cisco.com>; Ulf Hansson
> <ulf.hansson@linaro.org>
> Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
>=20
> Hi,
>=20
> We got your patch from stable. On p2020 we had mmc issues, and bisected
> the
> issue to your patch.
>=20
> Both prior patches seems to modify quirks2.
>=20
>     Fixes: 05cb6b2a66fa ("mmc: sdhci-of-esdhc: add erratum eSDHC-A001
> and A-008358 support")
>     Fixes: a46e42712596 ("mmc: sdhci-of-esdhc: add erratum eSDHC5
> support")
>=20
> So I'm not sure if your changes were done correctly.
>=20
>=20
> Daniel
