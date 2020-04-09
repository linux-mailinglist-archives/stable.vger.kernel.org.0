Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30DA1A2E0E
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 05:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDIDmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 23:42:47 -0400
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:2558
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726559AbgDIDmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 23:42:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvHr+FK7V8axWxYFKii3LQAT9w4OkV8x1Gtzy8V0SwAC2uiMHdnujbnjsuqOU6OWDNvDP/EEiSCVLTTEuzVk2xl/qZuoTjGwDWBgjsR5bh/3S4Mo6OMSf9RGk/KK/0SxNM7NHONmLSE9las1y2tS4ZqY5/riQQD36FAdW2Q+0UOhPEl8+spAxLftppPmIVX8PlZxzwm/tJoi2K1gSbNK4y1Ucch+epguq3AaEAwsyVaafpG6wXNjATW1arq+E/cV+3t7uuLZ+WjbOP3sgqXB3m46K4nGxDk40MqTTBlnNC2VrUkkH+AvmwRJy/LsiuVPOlc/b5dnfiEAcdZgZGCyxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RsAptbR+DA+iwTj8lo2lvoXS/0ukVxdVg3rxZ+CIFc=;
 b=eei+OdwJ1G8bFsZdPKMvGr9pa0hovLxzj4BkoMMfH7G4qhpVpljDp2aORBwQ/109MgnzxSfeYErJ3h4Cuh0XpkK6BI8g5qbukN9WarZhB3VB/TlDX/qpiSR4E1jptx7NR3bCeD86wpdZ1e+4Og3aKlW++Cq/qzdaCrbCvwwC4G3AXbt0ckixw1EclRTPM0++eGDICvpKTkr3Aaw91wDYFOnnfud5lws4ggBZdyaoVTU06/UYKU8aiWz67otbGV01uvMGs0cH/LvNMb7dgWqe9+kd9+Sh4TS3YBb/3gCMdBHLOfy6HPrYrf5n7kRz5iJuwC/qjx7VTThSqZYwA6Xo0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RsAptbR+DA+iwTj8lo2lvoXS/0ukVxdVg3rxZ+CIFc=;
 b=Q9nnSEpgQdIjbDIo51FVnkCUrL8k9BlUukAPsBB5Wgdz+STdgqt89wYwlYUTWm6FHKl6PPn0Zwg+i/FIqM0PgcAIEyrsIS2sejl8tuc0MM9slPTwcn58V5nui5njDNZeiOHQK1xxnYMtYjGNx84NFjUD27ne872oLR3UHGUFwsE=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7SPR01MB0007.eurprd04.prod.outlook.com (2603:10a6:20b:141::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Thu, 9 Apr
 2020 03:42:44 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 03:42:44 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Daniel Walker (danielwa)" <danielwa@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Shyam More (shymore)" <shymore@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>
Subject: RE: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Topic: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Index: AQHWB532KYmmzOSk9kuuDMNOQaxK86hjtsqggACt1YCACYEGgIAA3RmAgACjZICAAMfzoA==
Date:   Thu, 9 Apr 2020 03:42:44 +0000
Message-ID: <AM7PR04MB6885C60315AC6D59093CC439F8C10@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200331205007.GZ823@zorba>
 <AM7PR04MB6885CDDD1ECEEAE7111C6201F8C90@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200401152635.GA823@zorba> <20200407163443.GK823@zorba>
 <AM7PR04MB6885EBF5DA973DA083EF0E6BF8C00@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200408153037.GA27944@zorba>
In-Reply-To: <20200408153037.GA27944@zorba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ca38d4d2-9d04-48b3-9db5-08d7dc381008
x-ms-traffictypediagnostic: AM7SPR01MB0007:
x-microsoft-antispam-prvs: <AM7SPR01MB0007067C4BB2154E4E673A68F8C10@AM7SPR01MB0007.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(5660300002)(86362001)(2906002)(52536014)(8676002)(9686003)(54906003)(8936002)(110136005)(6506007)(316002)(81156014)(7696005)(53546011)(4326008)(478600001)(55016002)(71200400001)(64756008)(76116006)(33656002)(186003)(26005)(66446008)(66476007)(66946007)(81166007)(66556008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uj4O+4ePjr4lSuJof+zEUAvuG9xfnsm9OczdCnfjyP6wDROyMeagyE1QXTkFeOpiwrPaNagNigyeIR7GKzTbls6i4BbGDLYy9aH8eZxkZKTDzKxr91T/yctZHkALzsxKL6AfIKDOCVA8Zw7MVJbIVDw639gHThBypkPRpWmk+lhSV2oDJWWVz6i4Nhe+Lu0iA5yFLA2FGLzk4OhFotsEXhCu1W4oqsAWniSvY1R+N2w84ZVOO/5tIomPRYmQ9Zl+SZovgCx899u5VClfPx+6QilVEN1hF6GD4kbpYYHAqrCCxdnS3oT8wIQFkZiophkuUzEcpZOj9W8/n1bPDuTdRgB9HR/852RbYsP4PXQHpgeZqaL8NZjB+bJqUCF4fC3POonBQFu4IVEcHiIQhpH5yV4vve5S3Lr0xvNHCBZHBRHs9bq3YwYttKxJxsZkblT3
x-ms-exchange-antispam-messagedata: sRC1ecJ7MxakGxsl1h6MlNZuyw0P1CoLaC4S15Z7kkCeXdi+yRBaAaVQcGyuO4XPaNdZdxs2x20P5FQ2bpFHcLVLkGQUF5yktBlY1npwUlTgGh2+Adr9eE1rKEKPNXYVXy0DApsxAWD+G2xAE0nB4A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca38d4d2-9d04-48b3-9db5-08d7dc381008
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 03:42:44.0876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LaMebb+NAQ2IOT/Xs35WWOXCQGrA2srfS1Jewh7D5WsTpXrKtZQPjWVRUMYxpzRPc1QCdNKp8p+J4mCq8n5pZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7SPR01MB0007
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Daniel for pointing out it.

Hi Uffe,

As Daniel reported, below commit introduced issue on P2020 platform.
fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling

And the fix-up for the issue is,
2aa3d82 mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller ver=
sions

It seemed fe0acab was applied to linux-stable for 5.5, 5.4, 4.19, 4.14, 4.9=
, and 4.4, without the fix-up 2aa3d82.
I tried to cherry-pick the fix-up to all these stable branches, but got man=
y conflicts except 5.5 and 5.4.

May I have your suggestion from safe perspective should I rework the fix-up=
 for these branches, or request to just revert fe0acab.
The patch fe0acab is just for errata handling while the errata are hard to =
trigger. It is not strongly required.

Thanks a lot.

Best regards,
Yangbo Lu

> -----Original Message-----
> From: Daniel Walker (danielwa) <danielwa@cisco.com>
> Sent: Wednesday, April 8, 2020 11:31 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: stable@vger.kernel.org; Shyam More (shymore) <shymore@cisco.com>;
> xe-linux-external(mailer list) <xe-linux-external@cisco.com>; Ulf Hansson
> <ulf.hansson@linaro.org>
> Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
>=20
> On Wed, Apr 08, 2020 at 05:53:52AM +0000, Y.b. Lu wrote:
> > Hi Daniel,
> >
> > > -----Original Message-----
> > > From: Daniel Walker (danielwa) <danielwa@cisco.com>
> > > Sent: Wednesday, April 8, 2020 12:35 AM
> > > To: Y.b. Lu <yangbo.lu@nxp.com>
> > > Cc: stable@vger.kernel.org; Shyam More (shymore)
> <shymore@cisco.com>;
> > > xe-linux-external(mailer list) <xe-linux-external@cisco.com>; Ulf Han=
sson
> > > <ulf.hansson@linaro.org>
> > > Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
> > >
> > > On Wed, Apr 01, 2020 at 03:26:35PM +0000, Daniel Walker (danielwa)
> wrote:
> > > > On Wed, Apr 01, 2020 at 05:12:44AM +0000, Y.b. Lu wrote:
> > > > > Hi Daniel,
> > > > >
> > > > > Sorry for the trouble.
> > > > > I think you were saying below patch introduced issue for you.
> > > > > fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling
> > > >
> > > > Yes, this patch cased mmc to stop functioning on p2020.
> > > >
> > >
> > > Have you investigated this ?
> >
> > As I said, this patch was proper fix-up, fixing mistake which used
> host->quirks2. It was host->quirks that should be used.
> > But after this patch, the other potential issues for P2020 appeared.
>=20
> Your including a change into stable which breaks p2020, that's not accept=
able.
> If
> more changes are needed to make p2020 stable can you send those additiona=
l
> patches to stable also ?
>=20
> Otherwise we need to revert your current patch.
>=20
> Daniel
