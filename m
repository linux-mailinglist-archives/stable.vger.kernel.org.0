Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5203A38B878
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 22:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbhETUfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 16:35:32 -0400
Received: from mail-mw2nam08on2043.outbound.protection.outlook.com ([40.107.101.43]:22817
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235224AbhETUfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 16:35:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khy0Rd7P9xjEqyII/3vcoFGnucIP2VuOKCZVti6QKtdS/NJkq8P1csmylzoE1pOe8hNuuSBTeT4X5cGGKBoYiKtrLHAK9ys3gBkw2+6jZSMgaxSi/OSEBQ99E9RKtIY5cOVVkGvif16wRTcUihH7uhlCu+hU9bmyxHJSuBqy/chA/bd3m3rwOlcYkPzJwmOKSQyyM0eeg2ZpILa680sqcwfmvWgps4lWLDkL9PR4WayYHp1jDr9wo9b51/rKlHq1bJxgvV1CVGvfseaCDbJY3pAychWk7FSy7jKMIDsOSnoJ/dYhnYRmrC8efDNkZ0vPDJ1LV/1dfkYL2JvQ0tqonQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29+dH5vWpg7JPm450Ln+BbapOUo/n5vfAqTjQ97FLeE=;
 b=AmGcoR3c8jGj97g/dnxHZ8Kr3p6Yp9FpSFXos9pzVXrjCRX0pi5UWFrLH9KsTOdg+zsQl0GgmxSgKpeWZf/ef0ZtHYSTOjc2z3MXnr6VgAzTiBsHjs94wkcRTmB0AeTqZnjKeIgKI/CQjzW9v5que+bFcP8Lo0amszkxKpy2MpfXMS1IpxW3/dxw+GV0p3PNfwpbbfDVqedbCjVcsNpxWFl4spyEEUFHIgiTukDAWnFvhWbLoHspoMppYEOQH4jQ0y6cTJQwNXAB/iEoJ0Ch7pEzFaeQpx0mCDgmnasiSymFutFvmaxmGmjERU/cgWvuSj2pXFXNnVDHGqS6gqM9WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29+dH5vWpg7JPm450Ln+BbapOUo/n5vfAqTjQ97FLeE=;
 b=2Ivjpo6rXgk8/k21Q1J+sADJty2Fb6lOwVp6E+chppftinidtoRqOsHD2NiOxk4TuqGR3ITJCRl8tFIhPEqCRaiwPURt1o30368M/MQicZCts47cYHEZwrb3rVsxjvpd7AYFndm5SYQj9vR3Llr2dzIBThbG3W8QL8CdnycXTT4=
Received: from BYAPR12MB2693.namprd12.prod.outlook.com (2603:10b6:a03:6a::33)
 by BYAPR12MB2614.namprd12.prod.outlook.com (2603:10b6:a03:6b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 20:34:07 +0000
Received: from BYAPR12MB2693.namprd12.prod.outlook.com
 ([fe80::c0c3:7247:a767:f5b6]) by BYAPR12MB2693.namprd12.prod.outlook.com
 ([fe80::c0c3:7247:a767:f5b6%3]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 20:34:07 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Keith Busch <kbusch@kernel.org>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
        "Liang, Prike" <Prike.Liang@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Topic: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Index: AQHXS40NYCAeCNVqrkmuKdHrguQgGqrrVkGAgACdf4CAAKfzAIAABtkwgAALSoCAAAbUsIAAHwKw
Date:   Thu, 20 May 2021 20:34:06 +0000
Message-ID: <BYAPR12MB26934FF6403A77E9A0F15C1CE22A9@BYAPR12MB2693.namprd12.prod.outlook.com>
References: <BYAPR12MB3238055D4B08CC91D9ABFD39FB2A9@BYAPR12MB3238.namprd12.prod.outlook.com>
 <20210520165848.GA324094@bjorn-Precision-5520>
 <MN2PR12MB4488F16CE50BFD4E1F453CFAF72A9@MN2PR12MB4488.namprd12.prod.outlook.com>
 <20210520180343.GA3783@C02WT3WMHTD6>
 <MN2PR12MB4488F011F9B018C9B52A862CF72A9@MN2PR12MB4488.namprd12.prod.outlook.com>
In-Reply-To: <MN2PR12MB4488F011F9B018C9B52A862CF72A9@MN2PR12MB4488.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-05-20T20:34:05Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=46886c5d-354d-46d5-a86f-5cde5ed65eaa;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
authentication-results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [2600:1700:70:f700:d078:904a:dfc0:e7fd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c43f9b88-3782-4017-9ba4-08d91bce9da1
x-ms-traffictypediagnostic: BYAPR12MB2614:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2614AC6943B2219AAF0278AAE22A9@BYAPR12MB2614.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U6cvSC3Ox9xaL3WA9dH/INKJSbnIG6segYJtrqzQWB8ve85I4wx5pKpX2uEbrg7UGWYPo/YXvLZultZSsLqg2Bbn2K52qef+iL44AwipFbkOy9+EUnGt7KWNAbxhnl8Ooag9vSNnpOoUuTVx9xhzBr2IQ/P+uYcGQ2xZ880+whBXryhE+sku9mjQcd/Hu13J1J5tplJZYSnytzT6d8ORaVhRF3TN2jk3h1sTWOl6WqaYTZqhdme65zVt0zjtlWJ4q5iLa8a7+Vdbh2piQuoiZtUAwJAiq29A31SZwdFHuOmJTfWdkmMZ5D9IKnEoYT1IAc6X2fcwismE4vuwIGwBnh4DVH3Vk8PnIUFJ7ZZuvNW8wzy6IsyiNNfDoabWDX2ZIQxevpujRTrIdzwxkn7kUeYuD8TnlRqBlnzEeRe5QdsI4WRcT+8RFu13K8wbNv8AdomwCY/xtNFGccRu9HiK7OdIxk11+TzX+Zil3Cpzdy1XbosP6toVb4CmFWpHDl8ztJEOwWbo6TRMgq9TcD5UscAk3tZv9U0H4qlQgqUYnbP5hDRymkaMIa/FcJ8AIXHxzH+NZF5qnYRkwIBrlDB4YjoLAq7+u4VgG6qd0teW3o0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2693.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(186003)(5660300002)(4326008)(7416002)(71200400001)(86362001)(52536014)(478600001)(7696005)(53546011)(6506007)(33656002)(122000001)(54906003)(110136005)(55016002)(64756008)(8676002)(83380400001)(9686003)(38100700002)(66946007)(8936002)(2906002)(66556008)(66476007)(316002)(76116006)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FOzIutc59FjoZlIU+kI87kl1IF3OxZQnn55obFc2OaNwBc8B+PyoDevXL3ek?=
 =?us-ascii?Q?PBeOPmr3jKojVOWDMvtnYYPuKsOsc4xbRTWm6y1/J7OA7oWromfunyW8ZB2q?=
 =?us-ascii?Q?5pX1Kf4vNhP3GdFGxWU7AeYmV/WyBuJtiK4dwBmrT7K+zKRJfCD8oHmeSUeO?=
 =?us-ascii?Q?HnD5JhQpn9bvXovvgDy0FJOFVDMNcfTO2vmYSeuj2ZGTBTulCW0cHIzHXTcN?=
 =?us-ascii?Q?BW/kZuz9EEmPuVgjaoloErFKdUmYsAUyHRm1iibiDNbzHgVq/oS3sGlsYSn0?=
 =?us-ascii?Q?qrsv/vyyBidTPNh+25rXMy6+0BWJjNWPJaZeWD1tK1BF8FYi5HHHaR7N0DVt?=
 =?us-ascii?Q?LMPQ3UHQzVHEOCPfw+hIsK/7ctZexQYQdMuHt80fXWh9TYPoE1HqliNM6DGT?=
 =?us-ascii?Q?ZCAkDSDYZtw1k9y688XkfvKIrnhcwyBP2khTE3uzpi5Iurx/JalvM7SaUw+7?=
 =?us-ascii?Q?BiPQLYRkm4qu/GZ5f6sbBW36WfuqkrIBkNM1e6aZB0i0g2RNLfp/iP+hxJLB?=
 =?us-ascii?Q?DAfwYLa1a7TKEOELwLi4wJ1onU99WmjgepZPwndWip1W4hbIZ12hHJG5jT4g?=
 =?us-ascii?Q?Po1Ojw8I62qGzyOiP26gHRnrtXT1sizSeTN/e9c0Mvmr32GaMc/uRTbzzsIS?=
 =?us-ascii?Q?Z4ACzA20yxvdlNB2DTLlYS6VAhtT2MKUuLBEV0qiqvGczYH0eeuSLQGPOnkH?=
 =?us-ascii?Q?6hnp7mOAPlz8NVqLfz63YLwRXQYEVTa1bCHqZnk6wwqJ0dF6JNUlwpIpjTlY?=
 =?us-ascii?Q?oYhNmjNe5F3eW5F97pFbjHpunz4AC3hGwSIFLZTjvPkFoty94angcckTzqEU?=
 =?us-ascii?Q?m3HLXEmGv7DETcSQn4/js5GLNTRjI9s+pqMMbz5LMv+5/H3Xcwy5UXBbiB9J?=
 =?us-ascii?Q?NsmDtmP/ZeSu+3jOa9ElZy9EPGnc4uEyVOAx1kiSc4ao3US/PXY3iwj5EArF?=
 =?us-ascii?Q?60rA19m7Zcp0FLAdv7c6QMJgRBPAMvuMOEvOg7KN1VEGLJAs28Ex//scjY3p?=
 =?us-ascii?Q?17DN5hA5corDL8I8f69QLVpjaAkw7OC1wMLhyPkCsSwEbkEnFkOOwTX35ec6?=
 =?us-ascii?Q?petYOoHe1Gt+vPUsNU6IT+2yfcsuGzFWj6x7tTZJI10SWuiV+2RkZGWid0c3?=
 =?us-ascii?Q?Xy9egzhCnekExalxnrxoSY7dJdMcnO4QsO36Rc1rflan+VznK9JcH8AmUFSO?=
 =?us-ascii?Q?HiwjVf1h7B5+9Dj1ld99y3m9gTluptJFSnPHls+BpXH4oLHYCyA1JW9e5ApF?=
 =?us-ascii?Q?HWDZE+BjLiQLCxsup8/ZMgNZCESkAsGxmb4zRjM+wF8Pss58+1uNls3a8uvB?=
 =?us-ascii?Q?PbUZe+HbAxEtndIv1Tdncz+7wrXfhrvRCpWPFzRPqEjRdk8AWgYcOL5m/VUb?=
 =?us-ascii?Q?wgHWu0rgVakZFCg4hGFn0fY1r81K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2693.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c43f9b88-3782-4017-9ba4-08d91bce9da1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 20:34:06.9294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3IGtdnbKoHhmdaLFmUXdc6KDk7EPo+oOyQyVuzACvDKkQkRx2Ft7XQGTqLYSx4mXKc5QoRiofLF9IaVmicOaGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2614
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> > -----Original Message-----
> > From: Keith Busch <kbusch@kernel.org>
> > Sent: Thursday, May 20, 2021 2:04 PM
> > To: Deucher, Alexander <Alexander.Deucher@amd.com>
> > Cc: Bjorn Helgaas <helgaas@kernel.org>; Liang, Prike
> > <Prike.Liang@amd.com>; linux-pci@vger.kernel.org; axboe@fb.com;
> > hch@lst.de; sagi@grimberg.me; linux-nvme@lists.infradead.org;
> > stable@vger.kernel.org; S-k, Shyam-sundar <Shyam-sundar.S-
> k@amd.com>;
> > Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>; Rafael J. Wysocki
> > <rjw@rjwysocki.net>; linux-pm@vger.kernel.org
> > Subject: Re: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown
> opt
> >
> > On Thu, May 20, 2021 at 05:40:54PM +0000, Deucher, Alexander wrote:
> > > It doesn't really have anything to do with PCI.  The PCI link is just
> > > a proxy for specific AMD platforms.  It's platform firmware behavior
> > > we are catering to.  This was originally posted as an nvme quirk, but
> > > during the review it was recommended to move the quirk into PCI
> > > because the quirk is not specific a particular NVMe device, but rathe=
r
> > > a set of AMD platforms.  Lots of other platforms seems to do similar
> > > things in the nvme driver based on ACPI or DMI flags, etc.  On our
> > > hardware this nvme flag is required for all cezanne and renoir platfo=
rms.
> >
> > The quirk was initially presented as specific to the pci root. Does it =
make
> > more sense for nvme to recognize the limitation from querying a differe=
nt
> > platform component instead of the pci bus?
>=20
> Maybe.  I'm not sure what the best way to tie this to a specific platform=
 is.
> @Limonciello, Mario?
>=20

I'll just remind folks that Prike mentioned this is a problem specific to t=
he
Renoir and Cezanne ASICs.  These were the first ones that S2idle was used.
"Future" designs the problems that cause the need for this change should be=
 fixed.

With that in mind, I can see the argument from Bjorn to not over-engineer i=
t and
claim a PCI quirk that applies to all the downstream PCIe devices when this=
 is just
needed for NVME devices.  The PCI device id selected (0x1630) is the root c=
omplex associated
specifically to these ASICs. =20

Since these are mobile platforms that don't contain any way to connect othe=
r external
PCIe devices I think another way to safely do it could be an if #ifdef CONF=
IG_X86 and then
check if set for doing s2i and if so do a x86_cpu_match() to the model and =
families
matching the CPUs.

To me this seems like a fine compromise given there is a precedent for dmi_=
match on
OEM platforms and enumerating "all" of the OEM platforms that contain CZN/R=
N and enable
S2I may be an exercise in futility.
