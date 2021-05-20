Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C39C389E73
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 08:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhETG7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 02:59:07 -0400
Received: from mail-mw2nam12on2067.outbound.protection.outlook.com ([40.107.244.67]:46209
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230444AbhETG7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 02:59:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcMzCnWviq3klZwzVfrxO4Kfa7QyEaPXru9xLU8SF/KLh2KLFHA5SvS1Kzsa+eMmVVnzCZ1VEBgLw1GMTou5ClnEAOPopNj7SyCUmUshgNqlzT1D71niQYO00T2n3f2WbTQbTH/YpQX3mg47Y3gU6So97L5qsy/NEqmN/v8DmLKUKyAtFEyJkWv+bQlnQZHp9ksVY+DGfNGp4QDzVwYQ1Ewr5Qx0A2mOOs8t3UCRHX+lQgaQ2BkArv1apbyDlewC6QVib52pMrOvXmH/lOj6oSRzQfhf4sbykumKQqPuHTI30oGv2JVhXEcibQSVNovlDxrT5w3KmtT7xkgZg2h7PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBZ7fC0VkonSv2xqxrQY3G46zVdjEtBFIccIWSeii/k=;
 b=mZikNoML5PwQjLssYTWy5fVclQSVmjUeCvhIh4KXdpJjKFfib8OHWYlYQyNG7O/1QtboULGVGL5ziyw0/WzvKNwGo88DVysx+j24uwAwaIM5rAR4w99F09O0G+8LDBtMzta42xF4qJPzFjiIsb+pC4QHQtmH9/K9bI2vWQ8bFnx+7khHl1uyfuXr1n/pBOAm6goxjXoKrawHC8VWbQYPneneT5+A/pG+ie2GalEMj06e+PwcFtxQQz6fntKxwsoFfPuaLqY/go6as1JYA3zvaxQXANQkW9vORvMq2d9il+DWw3Zng0tdQVOIng+RpuN7JMdzQvA3MUyo/Q8frjqzFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBZ7fC0VkonSv2xqxrQY3G46zVdjEtBFIccIWSeii/k=;
 b=LoHaF2A1wDo7tphEMI/xvVgqCiv82TqXqmcANVLnxZjx81ju7YJW2WxlbdVDzbsFrzZYWneWfchQh7TTq7hvCXAbzQ5e8mIu/WNvOlCY94XOOFH8XhqAhReLFDv141Ip+vicvn9HEqebRT2v2qmfK6aKue3m9A2lGr50zDT1Hyk=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB2838.namprd12.prod.outlook.com (2603:10b6:a03:6f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 06:57:42 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7%7]) with mapi id 15.20.4129.034; Thu, 20 May 2021
 06:57:41 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Topic: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Index: AQHXS40NwJGcnl+fXEefhkrBDeVCF6rrVkGAgABQJnA=
Date:   Thu, 20 May 2021 06:57:41 +0000
Message-ID: <BYAPR12MB3238055D4B08CC91D9ABFD39FB2A9@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1621304675-17874-2-git-send-email-Prike.Liang@amd.com>
 <20210519213359.GA256663@bjorn-Precision-5520>
In-Reply-To: <20210519213359.GA256663@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=e64b5bf4-3dbc-4dda-90e3-6fd45c730f33;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP
 2.0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-05-20T02:21:01Z;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-originating-ip: [139.226.130.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2926611d-9fe1-4047-b23c-08d91b5c902c
x-ms-traffictypediagnostic: BYAPR12MB2838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB283807F3FC904A219205F19DFB2A9@BYAPR12MB2838.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q7EQeIZrZqGzZIx/P7qoL1poku5FxaNetjiJ4yBaG+eLDBbKmrsi4K67ajQFHDKTZ78TRQ+vVlQHQjYaUqcZpJZ75dRWa862PCRE64ticLLCNgTudnv9kwOtHptuH8YCXdaoFjabuS1Y7n03Ij7n/ces+vPQ2b0MfvsHAhFoWnBZBNd24DGmoWYCJdYNGEt8mXdcT0c/ESY3kH7/vWyGICew5bg8VX4b/oQ3Gn+CdduLnThCKQMCgPiKRXlRH7f1XY48epWMvh10FP6GNsgOA4eqaTwz3jOOFhY/oIxtHG8s8jDP9oC2nNB6iUQ6njBDgcxzXdoo/r6QlKRXIhLcALOzcdcwWfg5g/4yJ45qGRWdoZ492GRdIeFxBVZPXhNjaj3DXFAFuulM1kXYARqCdk1ALdLRZAY82mFFOE0LlMo4rkUH+Yw8C+OMe1Q+jjDPCqQltz/FzpuSjx8JEDZOzz9HlHpuDowDtOLpf+bFCQ5lpCDBiOJKlbdXA754qnkK5ULTaaADxR2c7FmtX49+X/qk/nkcP9o5souvTqJpCWN3OiwenpDRqJsFh+u/SQciY+h3BrvRX8ux4HuVUkWMdRVZRpbMCPc0jA+pAmEqNk0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(478600001)(4326008)(122000001)(38100700002)(66446008)(33656002)(6506007)(53546011)(66476007)(64756008)(5660300002)(66556008)(76116006)(52536014)(66946007)(26005)(8936002)(8676002)(7416002)(6916009)(86362001)(186003)(54906003)(2906002)(316002)(55016002)(7696005)(71200400001)(83380400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Sgiq/k4AeVVAXkdKr3FWy/iHxXW4vDnGl4YXFCqa6QU+nJ5Q8ynVPPdJqjRS?=
 =?us-ascii?Q?vt0RnrXPWWPkxjhHPlPieYHq/ydBztxt7k9kHWugsJzFM452lQOOpnc+q21a?=
 =?us-ascii?Q?emYalAziV84DJZ95APB6YuW2ciwyYfNy8BgKp8pHxXS2SKvO2EpUe6eO7dPu?=
 =?us-ascii?Q?58ibUR/VAQoHw30qwtdMU7BiEBpnjXfuGM7n4bPukxke6J1HGhDCxL5XPuek?=
 =?us-ascii?Q?HqJPjA14J+Ny24KueYg6EjxQxsOQGOoqEmLttMT+j8vx6rgIFKqj4WOhDt0H?=
 =?us-ascii?Q?W70fVCSp4Ow1ROdPApV9XkPAr++sShfk+LPiCwGRcYXya/TeFoSlf+B3a0FM?=
 =?us-ascii?Q?chn0riKnyrn/BcUfqiFjeveTTjWI3shRCA9g+rHhPV5J6YfVIHBz1l1/H0Kw?=
 =?us-ascii?Q?AUfS+NPd9JOBz1vF89EwJbtctFPC+p66iOasBL7xGz4ga/rhiMvIjpglXzpd?=
 =?us-ascii?Q?OC0taSz/Yrm3PIiEsZOHv6HY7e6ameeMzVZk8vXSfcU6HRRRtG4jvf0tU74u?=
 =?us-ascii?Q?BCgJmNtT845WAOHUuLQBHsnR/bwRJkY2HlFaSQ8cMBrNQXhyPZrnHb2um3ew?=
 =?us-ascii?Q?tmtvyInT0qSom/OFSTLNjfK2qJu1gl0ARVpeXDNf0bishgFfyDsqNPvna1JV?=
 =?us-ascii?Q?Kwemi4rWbkg3apAkJTJ4Qk2lO/pDEanFOtrMIagNIZxW07odpiG75Z2a5SCw?=
 =?us-ascii?Q?Jq7mDBnm57d4AYyzUe7zFGC9kSvaeYU+phVLC4JfCvNdv0Zd+E+ZJNTQF1Cu?=
 =?us-ascii?Q?Tq8Hm0c1k7U0xDCiZrxu5+epB7ea8sKs3LuJKOAze9MTSlX9R51gRPyPKKcZ?=
 =?us-ascii?Q?uEf2c3JjG6gKChqBlYdh5BO5ucX8wAGqb67DKu8EUUnwQFZsppkBwbAYJWhZ?=
 =?us-ascii?Q?TrbqLJIdjgu7/qobli6f5ByOQ3wgf9vnEHRn2RvRgEGX2ZjnNxmYdHvQd1yM?=
 =?us-ascii?Q?ZXAKAobg2XLIyHfMB2R5nvIrB2592YkAT4Y9h/5+R6+ZEJ3wD9S/24uGl7t2?=
 =?us-ascii?Q?4T8mlmUQRYtekS7qxaDrfXN9xtLFod4feVudUaEc9LT7mYndL+SY3DhDw80E?=
 =?us-ascii?Q?Jmmf0xzKh3Uw/7z+3f4KJZ2HPMfhrqwEWc4dqV9XaEdtiwq/k26BauF2JJzg?=
 =?us-ascii?Q?h7Wz+Nqy//+0/pSzw3KudaMYu5rcTOjXF/FT2YoxLCxL8Ob51+BHqljuueKk?=
 =?us-ascii?Q?HywP/OMtymMLYBfC5ERkU+8HZzKwRTMZRmwdZaKlLyDA0+1l8CJDWdz67O7Y?=
 =?us-ascii?Q?se0EDN7mN8+53viodWrlyDmnKZZzsTuYa+9g9z594gLfF4b0LqX9kJe/Jdr7?=
 =?us-ascii?Q?FvIPNotugxwHanAxDtkIxDaQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2926611d-9fe1-4047-b23c-08d91b5c902c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 06:57:41.7976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d5WPgS1KErgL2l0nIXKlZrycdr6mjXZu3pxluFfJ3VL2QDfr9Z9a5DrJeJLwxvr+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2838
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Thursday, May 20, 2021 5:34 AM
> To: Liang, Prike <Prike.Liang@amd.com>
> Cc: linux-pci@vger.kernel.org; kbusch@kernel.org; axboe@fb.com;
> hch@lst.de; sagi@grimberg.me; linux-nvme@lists.infradead.org; Deucher,
> Alexander <Alexander.Deucher@amd.com>; stable@vger.kernel.org; S-k,
> Shyam-sundar <Shyam-sundar.S-k@amd.com>; Chaitanya Kulkarni
> <chaitanya.kulkarni@wdc.com>; Rafael J. Wysocki <rjw@rjwysocki.net>;
> linux-pm@vger.kernel.org
> Subject: Re: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
>
> [+cc Rafael (probably nothing of interest to you), linux-pm]
>
> On Tue, May 18, 2021 at 10:24:34AM +0800, Prike Liang wrote:
> > In the NVMe controller default suspend-resume seems only save/restore
> > the NVMe link state by APST opt and the NVMe remains in D0 during this
> time.
> > Then the NVMe device will be shutdown by SMU firmware in the s2idle
> > entry and then will lost the NVMe power context during s2idle
> > resume.Finally, the NVMe command queue request will be processed
> > abnormally and result in access timeout.This issue can be settled by
> > using PCIe power set with simple suspend-resume process path instead of
> APST get/set opt.
>
> I can't parse the paragraph above, sorry.  I'm sure this means something =
to
> NVMe developers, but since you're adding this to the PCI core, not the NV=
Me
> core, it needs to be intelligible to ordinary PCI folks.
>
[Prike]  I'm sorry to make confusion here. Those patches addressed a s2idle=
 resume broken problem
that the NVMe driver's default suspend-resume policy of using NVMe APST dur=
ing suspend-to-idle
prevents the PCI root port from going to D3.

> For example, since you only use this flag in the NVMe driver, you should
> explain why the PCI core needs to keep track of the flag for you.  Normal=
ly I
> would assume the driver could figure this out in its
> .probe() function.
>
[Prike] Yeah, we can assign the quirk flag in the .probe function or add it=
 in nvme_id_table and this also
the primary solution we tried out. However, that seems not possible to enum=
erate every uncertain NVMe device then assign quirk flag to them. In this c=
ase, in order to handle various NVMe device we can use the root complex dev=
ice ID to identify the question platform.

> Quirks are usually used to work around a defect in a device.  What's the
> defect in this case?  Ideally we can point to a section of the PCIe spec =
with a
> requirement that the device violates.
>
[Prike] In this case the quirk is only used to identify the question platfo=
rm which requires the NVMe
device go to D3 in the s2idle suspend.
> What does "opt" mean?
>
[Prike] I'm also not dedicate working on the NVMe driver, but from the soft=
ware perspective the APST
opt is used for handling the power state S&R without PCI interfering during=
 s2idle legacy suspend-resume.

> What is SMU firmware?  Why is it relevant?
>
[Prike] SMU firmware is a proprietary micro component which responsible for=
 device power management. Without the quirk flag, NVMe device will not ente=
r D3 during s2idle suspend then SMU firmware will shut down the NVMe device=
, unfortunately since NVMe is a third-party device the SMU firmware only re=
store NVMe root port power state during s2ilde wake up process. Eventually,=
 the NVMe device power state will be lost when back to OS s2idle resume  an=
d then result in NVMe command request failed.

> Is this a problem only with s2idle?  Why or why not?
>
[Prike] Yeah, this issue is only found in the s2idle scenario, and that's b=
ecause s2idle will check whether
each device will enter its own minimum power level defined in the LPI const=
rains table.

> The quirk applies to [1022:1630].  An lspci I found on the web says this =
is a
> "00:00.0 Host bridge: AMD Renoir Root Complex" device.  So it looks like =
this
> will result in PCI_BUS_FLAGS_DISABLE_ON_S2I being set for every PCI bus i=
n
> the entire system.  But the description talks about an issue specifically=
 with
> NVMe.
>
> Is there a defect in this AMD PCIe controller that affects all devices?
>
[Prike] In this solution by checking root complex DID to identify the quest=
ion platform which need
the quirk flag. So far, only NVMe device need check this flag for special p=
rocessing of NVMe
s2idle suspend.

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
> > passthrough device(bus) gloable flag to identify the NVMe shutdown opt
> rather than look up the device BDF.
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
> pci_bus *parent)
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
> > }
> >  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
>       PCI_DEVICE_ID_AMD_8151_0,       quirk_nopciamd);
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
> >
