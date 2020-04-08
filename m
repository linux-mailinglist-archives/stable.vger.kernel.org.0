Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13B21A1BA2
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 07:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDHFx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 01:53:59 -0400
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:30038
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726494AbgDHFx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 01:53:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhOhaiNIIuYGua6DCwK2/5q5hq4FZEGxyTUN0SA53OF3t8t9f9s+iI6t6ndJXdCzduzoe9i/zyeil5AGycO3lOPe5Yc7CwzLJaFzkjx0hDGYf89FD8Mi0QI3lV9mCqG4t0vZ9WEi4d4lpFhTA3cuslsT7lXifctNVB8ZPqEiTvki1lp/yXC31oIGEAlgDvyjDZwmfuyig1DX0BlGuxoF6zXa136kvU/+Lj3IOboRpxVFpoq9BRoT10hF2sHaIApRYj44mnH1aS5RhQ53qZaWykvePZdHTQNQRF2XEP+0yCLLRGTokFqEo1FooicKHwhNC+zQsMTRdXetVu4FoAqrEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tep6rrSaO3XCnyTF9xB+jScyFgtXmsKnYqpqu9hgbbg=;
 b=W99KszLVfPu6MMP2SruZAcr7iwoaaefySjpF9U3FCBLdGpL61shsKWuSVOhoNswIHRwVZ3e20JWuvboAya/rbc42pjB6CIjWP/emL7EojLdc/CF6mFALA7FdLDFTYTYXwJ5/svSR7JbB7fu5hubOwaypefqp+mIptpoOP6605QgcWmXT+uyLkQyackPQnNNtXm/W+Bd7ezxRvKkDvD2m41YXmuny3kbHUx+mkzGOpiTzbi8LsdXrunJor6gy2lHLSTAxM2C4n5HqKI1svbZEdC8PStWFFK81JWyUc3K8rANYeK3rfqUHCouedzW4q71DjM8MgrReFgzjmQl2NdO5Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tep6rrSaO3XCnyTF9xB+jScyFgtXmsKnYqpqu9hgbbg=;
 b=rop+jO5vHjCXvfJis5TNyXPh23jZLe3QoEPoII30EKXTyOOX0UP//PGOZKa/RlJCwM6TyY0lmfUJdVW2LUpeTuDltMtZ3pp4tssQMfUsbrS/urd2i9qt3F/6iZL3Ca2sBbnnJuimMXuS5ANzZeb4/WvfZFTcL7UtxooLh+3cS5o=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7PR04MB6917.eurprd04.prod.outlook.com (2603:10a6:20b:109::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Wed, 8 Apr
 2020 05:53:52 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2878.022; Wed, 8 Apr 2020
 05:53:52 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Daniel Walker (danielwa)" <danielwa@cisco.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Shyam More (shymore)" <shymore@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: RE: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Topic: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Index: AQHWB532KYmmzOSk9kuuDMNOQaxK86hjtsqggACt1YCACYEGgIAA3RmA
Date:   Wed, 8 Apr 2020 05:53:52 +0000
Message-ID: <AM7PR04MB6885EBF5DA973DA083EF0E6BF8C00@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200331205007.GZ823@zorba>
 <AM7PR04MB6885CDDD1ECEEAE7111C6201F8C90@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200401152635.GA823@zorba> <20200407163443.GK823@zorba>
In-Reply-To: <20200407163443.GK823@zorba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5835dfe9-93eb-4b02-b08b-08d7db813796
x-ms-traffictypediagnostic: AM7PR04MB6917:
x-microsoft-antispam-prvs: <AM7PR04MB69178EEFE3EE422056D2FA71F8C00@AM7PR04MB6917.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(4326008)(8676002)(316002)(6506007)(9686003)(2906002)(66476007)(64756008)(7696005)(66446008)(54906003)(478600001)(186003)(52536014)(81166007)(5660300002)(81156014)(66946007)(55016002)(76116006)(53546011)(71200400001)(86362001)(26005)(8936002)(66556008)(33656002)(6916009);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S2axasCK9PX5W1PPXcAr5ooJFJJEe5M/kMdLAdK1zENPuqRMAXdIhiEzOnmOjPu+oWMNwilkiSClpnNMT1n/3uMnqpb323tNtLAHhn1kZnY5p/YzdeRyly+dODuTAJEDuQIdZYZj4VCpQb7NhqsAyxtKrci0l7QQi648uXbLwBuFiY2mD68ioCROqiVrD8MvbhgjwhzS9+OBZf0w+pljFpTGZub6wEjijnmYe7cnYj7rOxZTbnx06KP6fBNOzp2EZzi99oL5MimDx4G/KkBp9kVeQC+oiEHSWOs6U47pWl/KGDciT2ufvke0Z0jxDw2g5oOCauGJZXgfrosvupc/FMFIaiH07ZyYLwmzg48UCgUtrFUME9T3dWVsPvvoLjp7XgVOaJimG42qxsnbBqG4aIzR8icnX1LYzi3EZNNIZ2cWZ6XbzMxowXmR7Cpp2niH
x-ms-exchange-antispam-messagedata: hDT5MX5r2eXv/MCgVwFkY3xSQDfgTj2trbk5G2RC8CXnjnuTrlDpd/2ywg/8nJ0pOUNh4wX86oC7KQvLKLMfurPxSjUqHzOYyNMIPwuZriEP5N4KfUl/GO6VuNJN9ZwmXx8f84w5EJkUEEKOrk5eYQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5835dfe9-93eb-4b02-b08b-08d7db813796
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 05:53:52.5882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZMTgd1pAORSIvYUZ5MD4nS5NcPvzuWU3gy2jNUesaHrez19/lrHA0YykPajPdm6uE5+/0q+lyBCogerrimiVRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6917
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

> -----Original Message-----
> From: Daniel Walker (danielwa) <danielwa@cisco.com>
> Sent: Wednesday, April 8, 2020 12:35 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: stable@vger.kernel.org; Shyam More (shymore) <shymore@cisco.com>;
> xe-linux-external(mailer list) <xe-linux-external@cisco.com>; Ulf Hansson
> <ulf.hansson@linaro.org>
> Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
>=20
> On Wed, Apr 01, 2020 at 03:26:35PM +0000, Daniel Walker (danielwa) wrote:
> > On Wed, Apr 01, 2020 at 05:12:44AM +0000, Y.b. Lu wrote:
> > > Hi Daniel,
> > >
> > > Sorry for the trouble.
> > > I think you were saying below patch introduced issue for you.
> > > fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling
> >
> > Yes, this patch cased mmc to stop functioning on p2020.
> >
>=20
> Have you investigated this ?

As I said, this patch was proper fix-up, fixing mistake which used host->qu=
irks2. It was host->quirks that should be used.
But after this patch, the other potential issues for P2020 appeared.

I had shared you all other related fix-ups for P2020. If your linux doesn't=
 not have, you need to cherry-pick by yourself.

80c7482 mmc: sdhci-of-esdhc: fix serious issue clock is always disabled
429d939 mmc: sdhci-of-esdhc: fix transfer mode register reading
1b21a70 mmc: sdhci-of-esdhc: fix clock setting for different controller ver=
sions
2aa3d82 mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller ver=
sions
f667216 mmc: sdhci-of-esdhc: re-implement erratum A-009204 workaround

At least, if you try to cherry-pick the two patches, P2020 eSDHC would work=
 again.

2aa3d82 mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller ver=
sions
f667216 mmc: sdhci-of-esdhc: re-implement erratum A-009204 workaround

Thanks.

>=20
> Daniel
