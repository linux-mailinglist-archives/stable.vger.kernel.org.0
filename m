Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAA11A252A
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 17:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgDHPa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 11:30:56 -0400
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:16997 "EHLO
        rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgDHPa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 11:30:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1432; q=dns/txt; s=iport;
  t=1586359855; x=1587569455;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HNa7OJ2WcJfY1ilgfw6ARB5npT+JoQ/HDDGkoki5fpQ=;
  b=dRwfLlw93qwYCl3oNSiQMJGtJuSwYMUj4xZ+nW5SdZiiH8ZdUdN0wy0C
   vvqVmlCC/F7xtn3/sL5SpCXNnBKAXC5IAQdJdMuSnRDh3xHmKV1Cl3Vni
   PiwqLFubilSdVnLnI9fxg+UD2Uac0ebFObaPMmm8W+SxxZSk/cudqzgik
   w=;
IronPort-PHdr: =?us-ascii?q?9a23=3A4GS7zBEst+9s9Ly4Dn26DJ1GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e4z1Q3SRYuO7fVChqKWqK3mVWEaqbe5+HEZON0pNV?=
 =?us-ascii?q?cejNkO2QkpAcqLE0r+efLjaS03GNtLfFRk5Hq8d0NSHZW2ag=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AYAABb7Y1e/40NJK1mGwEBAQEBAQE?=
 =?us-ascii?q?FAQEBEQEBAwMBAQGBZwYBAQELAYFTUAWBRCAECyoKh1cDhFmGEYJfjyQTiGm?=
 =?us-ascii?q?BLoEkA1QKAQEBDAEBLQIEAQGERAKCByQ0CQ4CAwEBCwEBBQEBAQIBBQRthVY?=
 =?us-ascii?q?MhXABAQEBAxIVEwYBATcBCwQCAQgRBAEBAR4QFB4dCgQOBSKFUAMuAaV+AoE?=
 =?us-ascii?q?5iGKBdDOCfwEBBYUyGIINCRSBJAGMMhqBQT+DbDU+hE6DRIIssTQKgj2XKSk?=
 =?us-ascii?q?Om3qrZwIEAgQFAg4BAQWBUjmBV3AVO4JpUBgNkSIMF4NQg2uGanSBKY0ZAYE?=
 =?us-ascii?q?PAQE?=
X-IronPort-AV: E=Sophos;i="5.72,359,1580774400"; 
   d="scan'208";a="743698732"
Received: from alln-core-8.cisco.com ([173.36.13.141])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Apr 2020 15:30:54 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by alln-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 038FUspN002298
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 8 Apr 2020 15:30:54 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Apr
 2020 10:30:54 -0500
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Apr
 2020 10:30:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 8 Apr 2020 11:30:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVFnCgmu7wQ6SovJKBIvM1amuAaRxw60eZSq3dF454RZ3s9ZXULd9/vM/a3Me69jxVrkINNLmOCwCjfUX8wzB08Ihy0ucR4hBz+d9NXUBUTk9l/r9Bo7W4sOMgDzesVpYUB9qrb3wvOfr/mLv4MxkMGPPepDSAH5a7zU6UPa53Yvnnb35K/nTpCBHm1krjI7aYscQ8rWodaYSS3leYIfgSFwh3iCxzSl2kTSAL50VL7E3RLAr+fSIleTaymXYavj+OlC6R13bscso2dxiqk/YamF4II+dFhBXjXVabrARCZJ/TuI0EIV0Uo8WXGewNTNitrhd9Tk9jSPPo0ZaMXUVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNa7OJ2WcJfY1ilgfw6ARB5npT+JoQ/HDDGkoki5fpQ=;
 b=Nhwxpow0iKPuRjw8nEBaa0hwm4NftXt7f4+nhwVyek6Qi6AEHV70A8A854YBbiOB43zwRaBil38zsHhIA9HR5ikRmhjYSjkky74gv5P1Hnm04ceNMqL82KPITLbK/wULxSkmq46gCt4CTpFrJm8j//V2doOGX1Sr9xZqk8SMyxoCTs6ppP9ZZyalyXFizFz1zrKV6zrvbrgd3cvaxVO8aKNteXkeI3RiU3rpVbVRJKeX+/lZeLo6/Xwp4jvEnk8S3JdzO126O9HRDvo16fxnjOvzmJCFvbMAm0l55EC8BIbFtiMowHo8vKZRbl/zXewlAae5KzDoMi1eXw9cdNWctA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNa7OJ2WcJfY1ilgfw6ARB5npT+JoQ/HDDGkoki5fpQ=;
 b=fMJC8lXBtYt3sjDiIh7fWWund+mxV7Ew4n8BLr4syPbMyr1Lh19E4m/+QgRVZFc6WcVtBC3RRYBLHO12Al/4SU5KD1iqOSeCobaPObn6ld52g9eyioezP1vdprpa1IcaRcsrvgkJu+5MpaT1Ln36BO9A+uUbxywTPqvV/c7vvRI=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (2603:10b6:a03:1e::32)
 by BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Wed, 8 Apr
 2020 15:30:51 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::d015:3039:2595:7222]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::d015:3039:2595:7222%7]) with mapi id 15.20.2878.018; Wed, 8 Apr 2020
 15:30:51 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Shyam More (shymore)" <shymore@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Topic: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Index: AQHWDbqvwpRwv9diC0Cxyuj1OVrTeQ==
Date:   Wed, 8 Apr 2020 15:30:51 +0000
Message-ID: <20200408153037.GA27944@zorba>
References: <20200331205007.GZ823@zorba>
 <AM7PR04MB6885CDDD1ECEEAE7111C6201F8C90@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200401152635.GA823@zorba> <20200407163443.GK823@zorba>
 <AM7PR04MB6885EBF5DA973DA083EF0E6BF8C00@AM7PR04MB6885.eurprd04.prod.outlook.com>
In-Reply-To: <AM7PR04MB6885EBF5DA973DA083EF0E6BF8C00@AM7PR04MB6885.eurprd04.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.9.4 (2018-02-28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.184]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b1b03e7-7075-48df-e827-08d7dbd1d1ed
x-ms-traffictypediagnostic: BYAPR11MB3207:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3207DB22AD759156D338B7C2DDC00@BYAPR11MB3207.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3205.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(33716001)(33656002)(6916009)(86362001)(2906002)(5660300002)(8936002)(64756008)(53546011)(71200400001)(6512007)(76116006)(54906003)(478600001)(66476007)(186003)(9686003)(1076003)(81166007)(26005)(8676002)(66556008)(6486002)(4326008)(6506007)(66446008)(66946007)(316002)(81156014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vy9uHhwqTKHeh7T3g7PPNIip9L0sega26dd+9nJLlBsfKNLE0QBiSEnPNNsl6t1FYnmgHcJeSnjsoI2yIja2tf1/ePml9c2a03GNVMhlkLcAR9aSzPQ2+M6wep+vXgbBzUX0/H++qbvI6rE3QKa+30RuvhxG/WD3NZVlHbLCt14eGVma0Cm1ob0KqclzPZO+gdH9qaUZvT2qzRP56YnXIuHhQQvXcCrey/dyPbXXjVzzIYpCuh1HF1PEz9KQ9C3JLNGDakY5L7rpR+N6P2ay1XsxL/b1fvukehDhM47TqGVAWxR7ieXD8Ami9VFL/PRYD0gFDZk/khyUTzC1V1xGKCzJDTRB/su2bSeoC1FfFplrwi9vS7xJFN3SuJQdDHQhUrgaC1Z4YurlE2xUDviDnPDEBuSUJSyItsq7dpYRUStQM6g0J43/OJWeHeYuGiJm
x-ms-exchange-antispam-messagedata: WgARxNQb/CPbMz22ZoNLdR/Y75hHEhs7BU7QDBoH0ku+TEvtguHki014IH8FsTMsr/CQjlFdWD55jGQO+mHNQAjBaqmWBmhrY4qepgDTR9p1C+WH3cQd3HEcr3BA/WrIhBR/CKBkXBwqdeClBLUxkw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40D166562C727D4087A5B571FB0EEBE1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b1b03e7-7075-48df-e827-08d7dbd1d1ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 15:30:51.1792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sFAcaVcxG2gDcupPyhBxhlmER6T07dVYWFoWXcc76bFyZdXz9atrCUA3EtdGgvTk1Vh88kENIt6Qp5+XkAqLRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3207
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: alln-core-8.cisco.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 05:53:52AM +0000, Y.b. Lu wrote:
> Hi Daniel,
>=20
> > -----Original Message-----
> > From: Daniel Walker (danielwa) <danielwa@cisco.com>
> > Sent: Wednesday, April 8, 2020 12:35 AM
> > To: Y.b. Lu <yangbo.lu@nxp.com>
> > Cc: stable@vger.kernel.org; Shyam More (shymore) <shymore@cisco.com>;
> > xe-linux-external(mailer list) <xe-linux-external@cisco.com>; Ulf Hanss=
on
> > <ulf.hansson@linaro.org>
> > Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
> >=20
> > On Wed, Apr 01, 2020 at 03:26:35PM +0000, Daniel Walker (danielwa) wrot=
e:
> > > On Wed, Apr 01, 2020 at 05:12:44AM +0000, Y.b. Lu wrote:
> > > > Hi Daniel,
> > > >
> > > > Sorry for the trouble.
> > > > I think you were saying below patch introduced issue for you.
> > > > fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling
> > >
> > > Yes, this patch cased mmc to stop functioning on p2020.
> > >
> >=20
> > Have you investigated this ?
>=20
> As I said, this patch was proper fix-up, fixing mistake which used host->=
quirks2. It was host->quirks that should be used.
> But after this patch, the other potential issues for P2020 appeared.
=20
Your including a change into stable which breaks p2020, that's not acceptab=
le. If
more changes are needed to make p2020 stable can you send those additional
patches to stable also ?

Otherwise we need to revert your current patch.

Daniel=
