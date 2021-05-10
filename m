Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABA63779B0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 03:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhEJBTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 21:19:12 -0400
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:64736
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229941AbhEJBTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 May 2021 21:19:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDTPQkZIcERnwrm5o6ItASzf1bFr6faUgQp1327mlqAYMOdQZaJuFpU3pU7EbiIl6tT15y/hXq0ZKJjFZwZTIdv8JhonfW2w79KYHs/s7VkifuQoPoSKrjccq3i7TfHzhN+4211pLy2Kgzle4PmXjAqVHV2TIwyp74C1nOBrYCwWDy5lnAWKnXawavf10BZbA8hj5MuJTmiTm1HN8i4vyodPUHKJPA195VO6ZOWnMI5pZCWW4BK5EuEq7NauUsI3dWXVVnjko9A9oCqwNa6N8++xfEX+QZbl4ys10mSMsfCRywbiuXf4ujplzPJOzU/zqNGqwM/bYa3p+rDGNSXKrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlHl8/+3XPO4Ga971+9zE78sAb0YheuTZEBvrmtV+vA=;
 b=R+sizXVuaumX6YJ5RH4Kp5TMugmsI7+51/gSOMxSBNLx6Gsr9lL4wsmXPGGR4FIhnbarxMaVflbE+0TjssJC/yi8ZMM0yQu3uLcgBdB5MWcWUhy34yZNpCFmIlcIQpLC6Pmlxh/Obg33uiv405heNfGJcG76wKgoUNrACn/Xaueo60JxLMYDGOpSylawcj3kRloTeA+NtmD4yhqGo/KWYKHst2qFNlzp8iyw6Gm2/zKfHA5DFQji72Uf9/31tGKwDEMSlL1SAfsJb9cKybzE6QkWqmqIanhJH2MGu92AEp6k7Nx/VYpRm8KAE+WxkjMy0sPObg5wwnwoSIzagFYudQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlHl8/+3XPO4Ga971+9zE78sAb0YheuTZEBvrmtV+vA=;
 b=uMvzZeWs1goU3a7Sgf4gHBQ6vZ+pPIQqLitAJw+HKLasjYqE7qE3T9Q7J3WdJfHoKqdvoenkAtaOnj+TmBrhqZ8p4+88gWQLGw5jTHivw/DK3P0y8epKQX3Cp9cOWcKZN7H1TgHax8x+yYponnmEK31xCTohiB5xgCidObDHCMw=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB3126.namprd12.prod.outlook.com (2603:10b6:a03:df::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Mon, 10 May
 2021 01:18:02 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7%7]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 01:18:02 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Subject: RE: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Topic: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Index: AQHXNxWH1Fw7MhW0Jk+r7qWA/iB7larV2E7AgAYt8lA=
Date:   Mon, 10 May 2021 01:18:01 +0000
Message-ID: <BYAPR12MB3238F57DD9B277403B24D0AEFB549@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1619054346-4566-1-git-send-email-Prike.Liang@amd.com>
 <1619054346-4566-2-git-send-email-Prike.Liang@amd.com>
 <BYAPR12MB32380567348D5E7C7921C218FB589@BYAPR12MB3238.namprd12.prod.outlook.com>
In-Reply-To: <BYAPR12MB32380567348D5E7C7921C218FB589@BYAPR12MB3238.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=0d4e7755-f8fa-42c9-9639-90b79b0773f0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-05-06T02:55:20Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [139.227.235.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea4e8cd3-eec2-483c-fe7a-08d9135174a9
x-ms-traffictypediagnostic: BYAPR12MB3126:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3126D395D11EF3C0738E2617FB549@BYAPR12MB3126.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:792;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XkLxqItutY3D8jCVLmLaNRM4f/gsVdVrkOOUcBMYbbuLQf2IFx7dNPHlSydz1UIcCeZPc4a4xOJEjeQwqC05UVb8BlIPyVxTMkWOi7IEcXG21IVma9Y8o4VUGYgqg02cfBAQSEyl6fT6joRJL7Ks9MovQuhuTjrHs5aXttzseIpFd9D2Amg4xN73Up7N+1bhm/axKNfoAOgfq3TH2hVkf7qvaoiaPAFt9eeDSK/VZi5+m1UryMr8TuYdfOcx/ktky/KGwZRYEYiXMGcgu7ZaQ7HevPIyxJ9TZd60iZ8fnmJTHIdTZ5DV4b+OnEqjtP0GeV8tbWeVZx+VrfFu+bOvsAl+O76g9VcG8lQsjeRBEGX56E5ptFc/5dbDf8nqQaMHUJBgpzZjdzlV9kMMj44vwrkLhmA/8ZUv2lsX3TTlaEm0ykWfXzprCLEfZQ+ohB+UA2wtkLjniqtO7d/gmYpQQcBZnFACJNzNNzDtOS3nTB9c8DIuvribyCGwxcUZ3Ns1wjYk8tsIdEZJ6ZVJfe1iLumNsamt0kqTb+iJeZ6X6ELsVLNN9kPb3tXVoiQZ4mgyxw3IlBQL2l5HolVHJuzpXfTDN6UOYH3Hoc6KcTavnFo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(52536014)(110136005)(83380400001)(122000001)(66446008)(66476007)(186003)(64756008)(66556008)(7696005)(26005)(4326008)(478600001)(33656002)(38100700002)(55016002)(2906002)(76116006)(71200400001)(316002)(9686003)(8936002)(66946007)(54906003)(8676002)(86362001)(6506007)(53546011)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UrtnCt0HYRGgR9yVAUY2tthmo9ei964shADu8EFVCO9BlVWHKn7v4ciXf+cp?=
 =?us-ascii?Q?LQSeapBMC5WIPx0K6vDgyzyMGWsTKSF6k1UgQAqy8pZ+lElA6AFKFBiLCjov?=
 =?us-ascii?Q?HwG+g0lkUuO7JLgNmzj4POQMdcoKjucqHq/nGpnYy0tkcsK/b56UIXDqdZHa?=
 =?us-ascii?Q?/RRlwnVrs3+kLFxp6H6IYRu2CHPCjFJtAtn10bRgnWOE8xfkHDa3fR0a727o?=
 =?us-ascii?Q?/eENSlxhYpYpO52iYUs0ZdrUgB6fg1w0VkhQ8EE9+mi1BePPhBrFCMGI14Or?=
 =?us-ascii?Q?k2SB8hB5Ssnhym1KM4LGufRZvOiM6e0J7Y1CIqfcNiYi/93/jmfDwxU0t42V?=
 =?us-ascii?Q?UbUyfJWivHlmjigi8Kv2S5aVnK/BHX+wpuMwupHZT02OpR/H2ngm5igLJHGi?=
 =?us-ascii?Q?BHuV+boin6FfvxBQBjGhf6QOPLqVKN4KFjouOG5ooWMgFAlW9PkdJYWyBiW9?=
 =?us-ascii?Q?AcX8n6TR7Pmb10mJl4z/WEE+RQ545SLU+uvgEIHwQD19icQn1fsOZwVw4+gx?=
 =?us-ascii?Q?uAS6yHEzrkzoJVwhf8NZmLsccUPNonhrskkfI0t6UXQVZngTKrOzEZZrDk3Y?=
 =?us-ascii?Q?E2rvrMwlBIn1mitaLCicXSlx/ZHLbbO5NkvmGXlRoSRlw9qxueXSwBgn1mAS?=
 =?us-ascii?Q?DL/TuV29mPu8dryWTboTkj7LgW5RTVA18h9OMKWGtedmww0xb8EOdjOeLy4M?=
 =?us-ascii?Q?M8pFpIRHCPQ8/K+xNLnYAvz1WFDcku/nMBXBpd23jqPsESuVKNcq65BOh5Oy?=
 =?us-ascii?Q?QRlUHnyYqx1QE7v3ustANPQV37VNl8n/TjAD7uCyyE5cgrHZHSIltiwyrtXT?=
 =?us-ascii?Q?ickfn4jI/eyYm5UJ3HpS6WnUjCikddFkb4K0bxDyFU92omoxq8Ny/3P8l1QD?=
 =?us-ascii?Q?toZFuaaSUaH4cqqJNHlwP0bpl+2sM6CIvlPQpYjgLjBUPMea1C536v8d0QY8?=
 =?us-ascii?Q?aEdcEWjiqYWAhPlWxGLkMv7oB7jZyqvXXy3nL0u3VP9abq8/MYRcjf1XVEB4?=
 =?us-ascii?Q?IPtDKIaiqCOrB3/ggu3D/VXklNMAk97pcKbvGDTD3joHPEw2BJYZEvlemUBG?=
 =?us-ascii?Q?kB0WaodYgXV7L8LzAGnrZznwhrcrny0+rv3KtGWJFRP+bSku+uxx/OTp188o?=
 =?us-ascii?Q?cduSr1vmb7IC+kjpBiedTfQFkzqA/+YMNnzI6fnndUxpiMMxr1odlk1xIeB2?=
 =?us-ascii?Q?H+uydh3bS8/BYX+bMdHQWGsjQ+lpYk5z5TovyOFn5PDZO78fHdWa1eQ40H1Y?=
 =?us-ascii?Q?31H+tb6cRXw7k2fhtU4zkqwHt37j1VVzJI8P8o3h+TbkjETebqJLC7thXCAQ?=
 =?us-ascii?Q?gi05/YUNLxug16Y8fmcJE2X6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4e8cd3-eec2-483c-fe7a-08d9135174a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2021 01:18:01.8893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ScNxjLB6kAAr1L+JNkhfofId3Qv3tcdUtHSqt6D+c86Hq5oy2WMdacp8SBTm+m5D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3126
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

Ping... Could I get some comments or RB on this latest series.


Thanks,
Prike
> -----Original Message-----
> From: Liang, Prike
> Sent: Thursday, May 6, 2021 11:08 AM
> To: linux-nvme@lists.infradead.org; kbusch@kernel.org; hch@infradead.org;
> Chaitanya.Kulkarni@wdc.com; gregkh@linuxfoundation.org; linux-
> pci@vger.kernel.org; Bjorn Helgaas <helgaas@kernel.org>
> Cc: stable@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>; S-k, Shyam-sundar <Shyam-sundar.S-
> k@amd.com>; Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>;
> rjw@rjwysocki.net
> Subject: RE: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
>
> + linux-pci for further review.
>
> Thanks,
> > -----Original Message-----
> > From: Liang, Prike <Prike.Liang@amd.com>
> > Sent: Thursday, April 22, 2021 9:19 AM
> > To: linux-nvme@lists.infradead.org; kbusch@kernel.org;
> > hch@infradead.org; Chaitanya.Kulkarni@wdc.com;
> > gregkh@linuxfoundation.org
> > Cc: stable@vger.kernel.org; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; S-k, Shyam-sundar <Shyam-sundar.S-
> > k@amd.com>; Liang, Prike <Prike.Liang@amd.com>; Chaitanya Kulkarni
> > <chaitanya.kulkarni@wdc.com>
> > Subject: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
> >
> > In the NVMe controller default suspend-resume seems only save/restore
> > the NVMe link state by APST opt and the NVMe remains in D0 during this
> time.
> > Then the NVMe device will be shutdown by SMU firmware in the s2idle
> > entry and then will lost the NVMe power context during s2idle
> > resume.Finally, the NVMe command queue request will be processed
> > abnormally and result in access timeout.This issue can be settled by
> > using PCIe power set with simple suspend-resume process path instead of
> APST get/set opt.
> >
> > In this patch prepare a PCIe RC bus flag to identify the platform
> > whether need the quirk.
> >
> > Cc: <stable@vger.kernel.org> # 5.10+
> > Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > [ck: split patches for nvme and pcie]
> > Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > Suggested-by: Keith Busch <kbusch@kernel.org>
> > Acked-by: Keith Busch <kbusch@kernel.org>
> > ---
> > Changes in v2:
> > Fix the patch format and check chip root complex DID instead of PCIe
> > RP to avoid the storage device plugged in internal PCIe RP by USB adapt=
or.
> >
> > Changes in v3:
> > According to Christoph Hellwig do NVME PCIe related identify opt
> > better in PCIe quirk driver rather than in NVME module.
> >
> > Changes in v4:
> > Split the fix to PCIe and NVMe part and then call the pci_dev_put()
> > put the device reference count and finally refine the commit info.
> >
> > Changes in v5:
> > According to Christoph Hellwig and Keith Busch better use a
> > passthrough
> > device(bus) gloable flag to identify the NVMe shutdown opt rather than
> > look up the device BDF.
> > ---
> >  drivers/pci/probe.c  | 5 ++++-
> >  drivers/pci/quirks.c | 7 +++++++
> >  include/linux/pci.h  | 2 ++
> >  3 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c index
> > 953f15a..34ba691e 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -558,10 +558,13 @@ static struct pci_bus *pci_alloc_bus(struct
> > pci_bus
> > *parent)
> >     INIT_LIST_HEAD(&b->resources);
> >     b->max_bus_speed =3D PCI_SPEED_UNKNOWN;
> >     b->cur_bus_speed =3D PCI_SPEED_UNKNOWN;
> > +   if (parent) {
> >  #ifdef CONFIG_PCI_DOMAINS_GENERIC
> > -   if (parent)
> >             b->domain_nr =3D parent->domain_nr;
> >  #endif
> > +           if (parent->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
> > +                   b->bus_flags |=3D PCI_BUS_FLAGS_DISABLE_ON_S2I;
> > +   }
> >     return b;
> >  }
> >
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> > 653660e3..7c4bb8e 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -312,6 +312,13 @@ static void quirk_nopciamd(struct pci_dev *dev)
> > }  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> >     PCI_DEVICE_ID_AMD_8151_0,       quirk_nopciamd);
> >
> > +static void quirk_amd_s2i_fixup(struct pci_dev *dev) {
> > +   dev->bus->bus_flags |=3D PCI_BUS_FLAGS_DISABLE_ON_S2I;
> > +   pci_info(dev, "AMD simple suspend opt enabled\n"); }
> > +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1630,
> > +quirk_amd_s2i_fixup);
> > +
> >  /* Triton requires workarounds to be used by the drivers */  static
> > void quirk_triton(struct pci_dev *dev)  { diff --git
> > a/include/linux/pci.h b/include/linux/pci.h index 53f4904..dc65219
> > 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -240,6 +240,8 @@ enum pci_bus_flags {
> >     PCI_BUS_FLAGS_NO_MMRBC  =3D (__force pci_bus_flags_t) 2,
> >     PCI_BUS_FLAGS_NO_AERSID =3D (__force pci_bus_flags_t) 4,
> >     PCI_BUS_FLAGS_NO_EXTCFG =3D (__force pci_bus_flags_t) 8,
> > +   /* Driver must pci_disable_device() for suspend-to-idle */
> > +   PCI_BUS_FLAGS_DISABLE_ON_S2I    =3D (__force pci_bus_flags_t) 16,
> >  };
> >
> >  /* Values from Link Status register, PCIe r3.1, sec 7.8.8 */
> > --
> > 2.7.4

