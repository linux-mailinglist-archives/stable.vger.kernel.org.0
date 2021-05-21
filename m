Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2732C38BDF8
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 07:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhEUFtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 01:49:22 -0400
Received: from mail-co1nam11on2089.outbound.protection.outlook.com ([40.107.220.89]:61444
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233880AbhEUFtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 01:49:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WX9Dezzdyf0m0CMQdvjuYVk/N4GSdd+MXsxR8/5lGr8PJOsBvlscVAD3fS059q5PTKDmOVG3uzIrHM8T+KQ2rakLQjFr/QJtI7JInWMwTMeERAprqjZZA1AFNVg6nEQhsYZPZrq4b4cF/Eca+gnzqtWKh+Ic/mO8uLZG85FY9Ds/snZcMLZotCNDaC3EUE4ziHYLw/VVHjWw+lR1Cvye3e4GlPhUEEISq2BZERe2cyzswQ3uRMFXmcU2naERIGcYsHTkFQ66THJYmsM9PdT5tB/USRrkeiQkeuuCHQLswnldj5TUggUVnJuGYkpHRUWpImtfMe1oYujhZgSTNi/nJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ft+TuA5UToTPwq5mRL/NrJk8ux65JpCahXp0lTrEPE=;
 b=H/+afys9giKbmUp6nmV8Z97mXPqZgikt0UoqmGA2WzOdbEtTn7+KBPlA3ca52Enom7bkuAyDBil0TFw99oP3tNKhDaJhOu40fXGJLdMAqBhhHWHVYPKBWkT/ArfaI3PXMnVDzazagQnGrfsLVIujIC+Cjty/UhnBsCYsgAd7YPBrBCnqN+c7HVemOueO75aOF35ovieif209zL10B5rJZRWhoJIhgLnaEGxklGR5ILCdnVCwc6g3BOU81gz2IMpq31pGAUu9SJcxidn+exp12sjNZVSp/aRLa2X8bYs+EA3ko2PjIiRmDYdUI2vJuVj889pnRZ9Us1Lq67MdLm5qqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ft+TuA5UToTPwq5mRL/NrJk8ux65JpCahXp0lTrEPE=;
 b=iIQyQmjuzTyN7z/2mi3cXcggSYCW59zZOQ0Q56xoG3ShKV7+oejzzg/jhy3KTFKwVFI+PELpzcxBe/W0cf252hkzae+ebNhrynNTiZFGIqfNYfT73Iar1cKVptAQXQggmZl5YUbkvnLkeVWn56PdaxNVxqrotm1roL6LGtUx2k8=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB3780.namprd12.prod.outlook.com (2603:10b6:a03:1a2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 21 May
 2021 05:47:56 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7%7]) with mapi id 15.20.4150.025; Fri, 21 May 2021
 05:47:56 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Keith Busch <kbusch@kernel.org>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
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
Thread-Index: AQHXS40NwJGcnl+fXEefhkrBDeVCF6rrVkGAgABQJnCAAPVMAIAAC8MAgAAGYICAAAdcgIAAIqgAgACaSwA=
Date:   Fri, 21 May 2021 05:47:56 +0000
Message-ID: <BYAPR12MB323873A2C12C3B9A045A38DAFB299@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <BYAPR12MB3238055D4B08CC91D9ABFD39FB2A9@BYAPR12MB3238.namprd12.prod.outlook.com>
 <20210520165848.GA324094@bjorn-Precision-5520>
 <MN2PR12MB4488F16CE50BFD4E1F453CFAF72A9@MN2PR12MB4488.namprd12.prod.outlook.com>
 <20210520180343.GA3783@C02WT3WMHTD6>
 <MN2PR12MB4488F011F9B018C9B52A862CF72A9@MN2PR12MB4488.namprd12.prod.outlook.com>
 <BYAPR12MB26934FF6403A77E9A0F15C1CE22A9@BYAPR12MB2693.namprd12.prod.outlook.com>
In-Reply-To: <BYAPR12MB26934FF6403A77E9A0F15C1CE22A9@BYAPR12MB2693.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=13524a12-4f1f-48ad-a87a-d74984e9ad48;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP
 2.0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-05-21T05:46:29Z;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [139.226.130.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fb4e4ac-b49a-4bb6-23b3-08d91c1bfc07
x-ms-traffictypediagnostic: BY5PR12MB3780:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB37802D271AD280B58FBDD54CFB299@BY5PR12MB3780.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BkijLvdy0ZzzdiO8hb5KT/ov5lcO6suSENBEljaH2QxlXtAtWM8n9WVFzs4IhWNnQ2p3GoKVFayRDimX+j7r1mwZ4delXYNhtvVE+dJ122gNJug0nRWE5dcxvhd4WPoUYScfrnhmaL/lfQKa6DWuEGUOaD2SnJRzssX1ui8xkqd+is5/sYV7UfT9j5hKPm0Hv6lJiP9N1fC1dAVVNDjH8TE7Iy9X0yWkIu/7jsivH1RKHBwImvRNWsTcWT3mW0+tmx4lRhOdPDqWoVx8TOmzzdS00/7cw7RNfbqXYyF6a3lspFFKU2bDPDliSNkb2viWcknV9NFI8IfE+BteYLPkh2nXX04rdSF4bSb5XRyXal5yaaAbeIB6asWJMJEgQRpdO0hfQ3mpiPfhG8FCnMkMbVnl9tEKxHcW6LLDxnMQbcOmRa6jttFlvdwM8g4iOIniaqu1TbbqiQy9mkGmYVRlFUhhsKloX8l9osY9ZvwNZnjvEg7TFggn4cvu3II5eesKoZmQ8HwFqZiH7CgWWFzzm2uo/twYMrDXiYfUk/DEcFQe8+4l+rcBG5zgSJurmpSXu+LFozaPJ9NzTHICkIg/gD+YvB+yboTTJJseraibBpg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(38100700002)(86362001)(5660300002)(83380400001)(2906002)(52536014)(33656002)(71200400001)(8936002)(110136005)(55016002)(478600001)(9686003)(6506007)(26005)(122000001)(53546011)(8676002)(66946007)(76116006)(66446008)(186003)(66476007)(66556008)(7696005)(316002)(7416002)(64756008)(4326008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NoF7qSfuXfhEvQ6KqxN2MkWJgfRKUXgFwGCdxL8AJK2008o0ksehHuisHbhj?=
 =?us-ascii?Q?UEZ4AUMDJxU3BO9WqfynoChKtekJF+XXHkKfGtDZWbd0azCQprqo/4PM3m0v?=
 =?us-ascii?Q?jnjJgFK6DvXo088snobBoA6OoeAZ/HfM7DAUsUBJKNCwGWk1dZrjLmcnwB6w?=
 =?us-ascii?Q?hglvOXNTb8cAidBNh3tu3Wr6bLgRcJ2EfAV0uEF8JmFJUJCFkl32qjOBOZjo?=
 =?us-ascii?Q?e6uwqAL9xOynrtly+L9V4fvbHWlswJaeVTubbo9SdN5prBY1HXbTeT0PFg3v?=
 =?us-ascii?Q?Gct+F6iyr8r61Fu2VQAG5548DOj84/phquEVd0mXJMC2l37QNbSm0IOAuOZ1?=
 =?us-ascii?Q?gTaxZe7op8HEePkknxcetmy+vhqtLQ7GShpdNINZv/yIXREtQtP3HM0sy/M8?=
 =?us-ascii?Q?EIG4dajc1sxzTElFGvsB6bWL1IW6UeOedJg80CNfqRFmZZUEfuNx9VrfW2/L?=
 =?us-ascii?Q?YW8152HhxC3sYL3CIc+Sfe3gM4HT6EYH1vBp+arRyUVIzkW/bjvx3Xo08R2g?=
 =?us-ascii?Q?kmuwblmRA0LyyZXGPziriqj4sWS9XzZBgewzXN9VOkSfNfEVZLuOt42lbFWl?=
 =?us-ascii?Q?qT6m3b9Lu3LKadQpZdwdO1/JX74v/x58gPKDn2rKtP6zZjtFS2prSfWy71hd?=
 =?us-ascii?Q?F3uS6LvI9ZvHgAzb9cMl/Q2SAVXVgcgt1QGWuMsHZ6U9iQlW1QHCuMDebbGu?=
 =?us-ascii?Q?Odtqc5QhLQbCTUpM2W4UHsmDZ/N+UNf5xBTVJNPsUSclLgn2bS2Dvv2cVHk1?=
 =?us-ascii?Q?RClHeYhvLXHs3W2uv9HIOrW7r2MWaDhTauwuS0kmikX5kUUXtI2lF/bZ8l9h?=
 =?us-ascii?Q?Ey89vyskapJT2Atuwy97Vpljutz1K51gmW/Mx3vClESgeAcxNbJeXgj1HOmd?=
 =?us-ascii?Q?XyXkN458CPQMYa/BeaLMnlKFkW2zaabMCZpK7zvnecF5yctqDhWo2kYoacPl?=
 =?us-ascii?Q?c0RJcJ5ywUWFRYEoFp/OOdjQcljRi/lgfIIFKlyUQgUB8qJo6DjmTGVs/t8R?=
 =?us-ascii?Q?1yPYX4766e3Ay1anfFmlR6kdNnF1ewVEHhuW9NHGWVPcLCHXXJ45LrLXGXmb?=
 =?us-ascii?Q?TpwEhICZjCMvTThcWH1P7xNhRuKNRGMba0ewbrpEGsecJXQICXk1e3EyXJHo?=
 =?us-ascii?Q?fitWxLzBLynD8YvzhNkFdq04LgA/RU7jwLJ1TYlFJuSFy28c7JyTdJvx3UJl?=
 =?us-ascii?Q?WwsvCcPaePeDpy1WX4lm6DJZR2fd5xYbXnMsdg75SYdtMMhSfeoewsfgMECU?=
 =?us-ascii?Q?lLKMq0A4lM22dUsvD9JjmiWWOuBOeRPgOlZV17YME/TR70CODTr1w6T/BAZD?=
 =?us-ascii?Q?vXIE7UcfoRnWhbg/PWoiZZBD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fb4e4ac-b49a-4bb6-23b3-08d91c1bfc07
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 05:47:56.5568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G4B1vQ6hcHrJD9VgeijUlrlevJ8zYm9LDnEsOaBa7vf+vgL7mocG3mUPPwrDUIpv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3780
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Limonciello, Mario <Mario.Limonciello@amd.com>
> Sent: Friday, May 21, 2021 4:34 AM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>; Keith Busch
> <kbusch@kernel.org>
> Cc: Bjorn Helgaas <helgaas@kernel.org>; Liang, Prike
> <Prike.Liang@amd.com>; linux-pci@vger.kernel.org; axboe@fb.com;
> hch@lst.de; sagi@grimberg.me; linux-nvme@lists.infradead.org;
> stable@vger.kernel.org; S-k, Shyam-sundar <Shyam-sundar.S-k@amd.com>;
> Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>; Rafael J. Wysocki
> <rjw@rjwysocki.net>; linux-pm@vger.kernel.org
> Subject: RE: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
>
> [AMD Public Use]
>
> > > -----Original Message-----
> > > From: Keith Busch <kbusch@kernel.org>
> > > Sent: Thursday, May 20, 2021 2:04 PM
> > > To: Deucher, Alexander <Alexander.Deucher@amd.com>
> > > Cc: Bjorn Helgaas <helgaas@kernel.org>; Liang, Prike
> > > <Prike.Liang@amd.com>; linux-pci@vger.kernel.org; axboe@fb.com;
> > > hch@lst.de; sagi@grimberg.me; linux-nvme@lists.infradead.org;
> > > stable@vger.kernel.org; S-k, Shyam-sundar <Shyam-sundar.S-
> > k@amd.com>;
> > > Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>; Rafael J. Wysocki
> > > <rjw@rjwysocki.net>; linux-pm@vger.kernel.org
> > > Subject: Re: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme
> > > shutdown
> > opt
> > >
> > > On Thu, May 20, 2021 at 05:40:54PM +0000, Deucher, Alexander wrote:
> > > > It doesn't really have anything to do with PCI.  The PCI link is
> > > > just a proxy for specific AMD platforms.  It's platform firmware
> > > > behavior we are catering to.  This was originally posted as an
> > > > nvme quirk, but during the review it was recommended to move the
> > > > quirk into PCI because the quirk is not specific a particular NVMe
> > > > device, but rather a set of AMD platforms.  Lots of other
> > > > platforms seems to do similar things in the nvme driver based on
> > > > ACPI or DMI flags, etc.  On our hardware this nvme flag is required=
 for
> all cezanne and renoir platforms.
> > >
> > > The quirk was initially presented as specific to the pci root. Does
> > > it make more sense for nvme to recognize the limitation from
> > > querying a different platform component instead of the pci bus?
> >
> > Maybe.  I'm not sure what the best way to tie this to a specific platfo=
rm is.
> > @Limonciello, Mario?
> >
>
> I'll just remind folks that Prike mentioned this is a problem specific to=
 the
> Renoir and Cezanne ASICs.  These were the first ones that S2idle was used=
.
> "Future" designs the problems that cause the need for this change should =
be
> fixed.
>
> With that in mind, I can see the argument from Bjorn to not over-engineer=
 it
> and claim a PCI quirk that applies to all the downstream PCIe devices whe=
n
> this is just needed for NVME devices.  The PCI device id selected (0x1630=
) is
> the root complex associated specifically to these ASICs.
>
> Since these are mobile platforms that don't contain any way to connect ot=
her
> external PCIe devices I think another way to safely do it could be an if =
#ifdef
> CONFIG_X86 and then check if set for doing s2i and if so do a
> x86_cpu_match() to the model and families matching the CPUs.
>
> To me this seems like a fine compromise given there is a precedent for
> dmi_match on OEM platforms and enumerating "all" of the OEM platforms
> that contain CZN/RN and enable S2I may be an exercise in futility.

Thanks for all proposal and will draft a new patch for this.


