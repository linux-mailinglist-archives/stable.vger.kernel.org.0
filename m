Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AA638B558
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 19:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbhETRmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 13:42:19 -0400
Received: from mail-bn1nam07on2069.outbound.protection.outlook.com ([40.107.212.69]:16385
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232607AbhETRmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 13:42:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TG+7CyTaOjhjBZn4Awtf+liCKMdQ8VjTd3ln7ivhnJA7tWCHOR4UBTuKAAMYRC9c8r11gR1iGL4LKhk6NOVbLRW//dJbT3+/qV9n7hNhotFJZ19wQixvpXFlvmSjm4ud0kEYY1PflymxsAGiYFFY8ymbYuEvim+CxHqyJq9ZAkZWQ/1z0i4PcFAg2GjRgOaWHUiERqDmZu9ZUugrTmz7W3tu6PtEkTsyTfv2gw/7Z3bHRr9FPmk263VL7Qu2FKwkOTanWAdoGqUJjo16hswi9WxYC3Y4+7ZyCmTooWPI8PjdEvnzl6HBwURltPYDlDSGPzwj7ecTIYUvMNuGKBPwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13nBPHtWrWPTcG5FAhw8PU0zcfiO7LtQ414dWv69KZs=;
 b=lcbIQaZJO9JgU/Jq7zLE18I37RaZ8uLzLHUI6J/1Nv4KN9ceXLKzAx7uiLTJZ3MqtPIkgbmj5WTwzBauxINiGccqmgT4WYB1kG2FeJxWGeJI3nXQu41Isg/zR3nI3xnP8wu/glf3XGlGRM4h1dT90DKEFTC7qVqFZiIlQgz/VSXOJXQBXmiHqVASQ4Au7YGPBhN3Evh8hrpSHxDad9EPhmoH0r3bx7e5H2a9a+lpSbFBn/6sFS23lHfwJ39yK+ZIenZk2cSYk3baXNHH0Y52A+WvxNOSvMqIr56ZdasSjGT6vQQlJ0tFOwg9Llp3eqHPM8GTpCTfX0dIgBrI0wpmMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13nBPHtWrWPTcG5FAhw8PU0zcfiO7LtQ414dWv69KZs=;
 b=McyR6E9HNmLC3c3b9sax7KTyqkDf5sj5CvTyKFBbyOhJ8fJoCnpgOwhnkDrZjEVUNMOnwdDrUC5jqOtxWNeXNO8LbkvaDP8ZQqPaM9TX2UkeT0RgjXJf56ZY4AcraXzZp1W89bz8D1HDy6giSThj74BuLw7AqWzpcFwSqRl6sHI=
Received: from MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19)
 by BL0PR12MB4851.namprd12.prod.outlook.com (2603:10b6:208:1c1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 17:40:55 +0000
Received: from MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::3d98:cefb:476c:c36e]) by MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::3d98:cefb:476c:c36e%8]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 17:40:54 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "Liang, Prike" <Prike.Liang@amd.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
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
Thread-Index: AQHXS40NYCAeCNVqrkmuKdHrguQgGqrrVkGAgACdf4CAAKfzAIAABtkw
Date:   Thu, 20 May 2021 17:40:54 +0000
Message-ID: <MN2PR12MB4488F16CE50BFD4E1F453CFAF72A9@MN2PR12MB4488.namprd12.prod.outlook.com>
References: <BYAPR12MB3238055D4B08CC91D9ABFD39FB2A9@BYAPR12MB3238.namprd12.prod.outlook.com>
 <20210520165848.GA324094@bjorn-Precision-5520>
In-Reply-To: <20210520165848.GA324094@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=True;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-05-20T17:40:54.384Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=AMD
 Public;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Standard;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-originating-ip: [204.111.139.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6c0d2d4-278d-4da4-43a1-08d91bb66b6d
x-ms-traffictypediagnostic: BL0PR12MB4851:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR12MB485156AA1697E5BC3A22C229F72A9@BL0PR12MB4851.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cRHZ4ns0rNWFylWS1TmIXji3Gr7az5rlXrgdFGEzeFThlTHea5UZFmVHdE2nikA9oXZ/kKmHIZO+LikXX5TQ/5Atlgcn9zRbdcR9d0yZ2zCrn6OFLt+chAVjtFj9OMtCo1hUbi2x+GY/LkrNcjrCr3AAKx34NY/9USwEy5dnYAse0ffOb36WXj1mhlSwm6WdrHpq04US4SPRux8b7lyjmvBnI37yUeZaza7PCjk3CaTCPksJ7S8gHIkNFI4jpJyHSGl6vhcm+IsFIyzfXq2Kz8Zm9O78drDWEUMup02+P7mxEeyR0Newewh5xix0m9KGKIpZMD5rII03r5QB4AiuD1yrMxgDhfkjyCrjiYiAilcYDLqCI/G+Mj/E7O7/e0OalnsV0+8338ylgAZZpeDzL5UsMKX68SrrveU1XkMXvRbxnae1ppkYNWwJRvOrE9NDeCyw7ubJvepZ7HRyVbQNEDVljXgTZAwXDSaP+4DNMHvhUdksl231NT36ZC+rzslC4y43PTnllkBfcNAFXZb/16IhrJ06DvZHn95Uln5asJ0hSNl4Cz2D+WTKI94voiG6NnHJA7eFYmWt9NAh3euDJ2egQmm9Uc+PaGFtnqVkFFij+lU/wgVHVPQA3mlN6O2i66lKZ1Sj5lQpYMbReG0W1dxbr0PoZCD1NMscLlVsRXEk8+f1QgjIubWaM8ojtDpa2feJD0lxyP9EXaBYwfd6NSkZ39sDQAasfy7vcQtifgE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4488.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(71200400001)(83380400001)(33656002)(6636002)(66446008)(64756008)(30864003)(4326008)(76116006)(66946007)(26005)(66556008)(7696005)(110136005)(54906003)(66476007)(316002)(38100700002)(9686003)(6506007)(2906002)(53546011)(966005)(45080400002)(7416002)(86362001)(55016002)(122000001)(52536014)(5660300002)(186003)(478600001)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?y2sHMxjDIUQy2ysf1i8V3Z7yzJMB7e/tvPoBu/0b+dj9U1qkujgsv5YLbi?=
 =?iso-8859-1?Q?3/Eikka04Ps/dkBWCPaAUAyVSNrOMtA7ETOjaTx4ORYaMD7Gk7SVuXcnLt?=
 =?iso-8859-1?Q?U5j0QZhdCkqqnlvsyKPll6c6lTo4FkVQBK8HSaIea2/XG4b3019nheKgm/?=
 =?iso-8859-1?Q?vn5kKYvWtBnSay3WMgVrThZqU/kAGB1m6LJQ6gP72wDUntsmcwNVwBfWiX?=
 =?iso-8859-1?Q?6DEZ+qq20danVw6BCSRJHiJdD3kksv+4VlTj5BsR03yLgiiBu4Ww2XVeZi?=
 =?iso-8859-1?Q?13P2J+hlGSy6kkCePCQcm9/SAC9hWpgIsLa6zfbq/TPTpA2evxqh7fW3nB?=
 =?iso-8859-1?Q?Ds/enlZ2Vbvf1zjamqEsZoXVWJ6piQWHcKau7IMlnu2v3cLXfnanlDG7ON?=
 =?iso-8859-1?Q?/4BvQf0pguXGBs0rx1hapksXUhz6cSTJ2068h3nPWVej6+pATW+ThSLjzZ?=
 =?iso-8859-1?Q?87oeL/8n8jc8/tHqyFo6a38YtUpyy0SjnvAGHmMjcjry4DUJ1q1c6rUi6F?=
 =?iso-8859-1?Q?HsfCog2vUbjFzdHPHVRcfNg1bl6VN/cdwwWYGhAKg0tWXIm6LPMH7DNmGP?=
 =?iso-8859-1?Q?PrpzEJgNsAdzElc/eAqRmw15MDHIg+Tn5IOkCDyg4WI+oqWWXqn7WnWY1R?=
 =?iso-8859-1?Q?aX6sxRivZFbh9sX1L8cpoU4nx1aqR+uHLSRqXGS/YyJimMyz6ZMzNrFmiY?=
 =?iso-8859-1?Q?3B0dlqK1NOdtFI5lrYga+KDFQeiGfll3nF8xd2CempUsYvXmaODi1kqyIH?=
 =?iso-8859-1?Q?tNrX9An4zDjWSIS7gLQQKL4uBpOnp5PP3mXsAlMOszWJxrS3TSDDuHm1wp?=
 =?iso-8859-1?Q?5mp5JcTP4cmkCj+PkLQNYzfv07Iv5MjTGiSKFmwxrm/x3RXjrRMHQ+Qxlb?=
 =?iso-8859-1?Q?ZJce+Zrqk0iLIfJg0FhPqeHHUIc6MXybRWzo3GGcHFr8wD4MuR6gWloX8h?=
 =?iso-8859-1?Q?Mi+X7EXdp8mrPZ/tg5x+iXRQKpabTqos9cmtVtxN71uvPi1sy1kJb27Xp9?=
 =?iso-8859-1?Q?RPCwms3TjUQUyJiD+8EeggVAGtyK3QAZD4VHjX5kbbezLP6FI/aAF+zl0V?=
 =?iso-8859-1?Q?gLsSkk5ZDJsYEMxJXm42sVSCtTrB07I2eeg+FFegUCvLUhX1UaV+Q8IKBX?=
 =?iso-8859-1?Q?sfh1O65JVv6o+sKXyvuRd7J4BxUT98ITY5jmjDHYubkS+DeuEguelByQBD?=
 =?iso-8859-1?Q?EVelRfCS5Z4xIngXEHYs2bvP0Y7LzrtDxDz8FVSXXY5T0MOwR5G0Y+SmPA?=
 =?iso-8859-1?Q?75JD9DwLwbgjQt1Yw+VpylZNisei5RNDARK4QOgvh1A7EwK7mdabe91iOS?=
 =?iso-8859-1?Q?jhLxccGhfXDbWLGhYijZhIahZZrSsegCyM7B9GIMK2liAEMpGNM6LYe/Md?=
 =?iso-8859-1?Q?lT9wQ8LN0W?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4488.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c0d2d4-278d-4da4-43a1-08d91bb66b6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 17:40:54.7397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yEM0BTn0Ya43jmqGKXw+GclacTETDtBIDxTjORJogSLW82DLprKkrnNfkMhrphQjX1p8tJ5l3SbJVujZqlvtIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4851
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Thursday, May 20, 2021 12:59 PM
> To: Liang, Prike <Prike.Liang@amd.com>
> Cc: linux-pci@vger.kernel.org; kbusch@kernel.org; axboe@fb.com;
> hch@lst.de; sagi@grimberg.me; linux-nvme@lists.infradead.org; Deucher,
> Alexander <Alexander.Deucher@amd.com>; stable@vger.kernel.org; S-k,
> Shyam-sundar <Shyam-sundar.S-k@amd.com>; Chaitanya Kulkarni
> <chaitanya.kulkarni@wdc.com>; Rafael J. Wysocki <rjw@rjwysocki.net>;
> linux-pm@vger.kernel.org
> Subject: Re: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
>
> On Thu, May 20, 2021 at 06:57:41AM +0000, Liang, Prike wrote:
> > > From: Bjorn Helgaas <helgaas@kernel.org>
> > > Sent: Thursday, May 20, 2021 5:34 AM
> > > To: Liang, Prike <Prike.Liang@amd.com>
> > > Cc: linux-pci@vger.kernel.org; kbusch@kernel.org; axboe@fb.com;
> > > hch@lst.de; sagi@grimberg.me; linux-nvme@lists.infradead.org;
> > > Deucher, Alexander <Alexander.Deucher@amd.com>;
> > > stable@vger.kernel.org; S-k, Shyam-sundar
> > > <Shyam-sundar.S-k@amd.com>; Chaitanya Kulkarni
> > > <chaitanya.kulkarni@wdc.com>; Rafael J. Wysocki <rjw@rjwysocki.net>;
> > > linux-pm@vger.kernel.org
> > > Subject: Re: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme
> > > shutdown opt
> > >
> > > [+cc Rafael (probably nothing of interest to you), linux-pm]
> > >
> > > On Tue, May 18, 2021 at 10:24:34AM +0800, Prike Liang wrote:
> > > > In the NVMe controller default suspend-resume seems only
> > > > save/restore the NVMe link state by APST opt and the NVMe remains
> > > > in D0 during this time.  Then the NVMe device will be shutdown by
> > > > SMU firmware in the s2idle entry and then will lost the NVMe power
> > > > context during s2idle resume.Finally, the NVMe command queue
> > > > request will be processed abnormally and result in access
> > > > timeout.This issue can be settled by using PCIe power set with
> > > > simple suspend-resume process path instead of APST get/set opt.
> > >
> > > I can't parse the paragraph above, sorry.  I'm sure this means
> > > something to NVMe developers, but since you're adding this to the
> > > PCI core, not the NVMe core, it needs to be intelligible to ordinary
> > > PCI folks.
> > >
> > [Prike]  I'm sorry to make confusion here. Those patches addressed a
> > s2idle resume broken problem that the NVMe driver's default
> > suspend-resume policy of using NVMe APST during suspend-to-idle
> > prevents the PCI root port from going to D3.
> >
> > > For example, since you only use this flag in the NVMe driver, you
> > > should explain why the PCI core needs to keep track of the flag for
> > > you.  Normally I would assume the driver could figure this out in
> > > its .probe() function.
> > >
> > [Prike] Yeah, we can assign the quirk flag in the .probe function or
> > add it in nvme_id_table and this also the primary solution we tried
> > out. However, that seems not possible to enumerate every uncertain
> > NVMe device then assign quirk flag to them. In this case, in order to
> > handle various NVMe device we can use the root complex device ID to
> > identify the question platform.
> >
> > > Quirks are usually used to work around a defect in a device.
> > > What's the defect in this case?  Ideally we can point to a section
> > > of the PCIe spec with a requirement that the device violates.
> >
> > [Prike] In this case the quirk is only used to identify the question
> > platform which requires the NVMe device go to D3 in the s2idle
> > suspend.
> >
> > > What does "opt" mean?
> > >
> > [Prike] I'm also not dedicate working on the NVMe driver, but from the
> > software perspective the APST opt is used for handling the power state
> > S&R without PCI interfering during s2idle legacy suspend-resume.
> >
> > > What is SMU firmware?  Why is it relevant?
> > >
> > [Prike] SMU firmware is a proprietary micro component which
> > responsible for device power management. Without the quirk flag, NVMe
> > device will not enter D3 during s2idle suspend then SMU firmware will
> > shut down the NVMe device, unfortunately since NVMe is a third-party
> > device the SMU firmware only restore NVMe root port power state during
> > s2ilde wake up process. Eventually, the NVMe device power state will
> > be lost when back to OS s2idle resume  and then result in NVMe command
> > request failed.
> >
> > > Is this a problem only with s2idle?  Why or why not?
> > >
> > [Prike] Yeah, this issue is only found in the s2idle scenario, and
> > that's because s2idle will check whether each device will enter its
> > own minimum power level defined in the LPI constrains table.
> >
> > > The quirk applies to [1022:1630].  An lspci I found on the web says
> > > this is a "00:00.0 Host bridge: AMD Renoir Root Complex"
> > > device.  So it looks like this will result in
> > > PCI_BUS_FLAGS_DISABLE_ON_S2I being set for every PCI bus in the
> > > entire system.  But the description talks about an issue
> > > specifically with NVMe.
> > >
> > > Is there a defect in this AMD PCIe controller that affects all
> > > devices?
> > >
> > [Prike] In this solution by checking root complex DID to identify the
> > question platform which need the quirk flag. So far, only NVMe device
> > need check this flag for special processing of NVMe s2idle suspend.
>
> We're really not getting anywhere.  The commit log needs to explain how t=
his
> is related to PCI.  Apparently the issue is related to NVMe APST and NVMe
> device state being lost.  AFAICT, APST has to do with power states of the
> NVMe controller itself.  Those states are internal to NVMe and are not
> directly visible to the Root Port.
>
> Maybe there's a connection with ASPM or the Link state, or putting the
> device in D3cold, or ...?
>
> Ideally it would describe something about this AMD PCIe controller that
> doesn't work according to spec.
>
> It should say something about why this flag needs to apply to *all* devic=
es
> below this controller, even though we currently only use it for NVMe.
>

It doesn't really have anything to do with PCI.  The PCI link is just a pro=
xy for specific AMD platforms.  It's platform firmware behavior we are cate=
ring to.  This was originally posted as an nvme quirk, but during the revie=
w it was recommended to move the quirk into PCI because the quirk is not sp=
ecific a particular NVMe device, but rather a set of AMD platforms.  Lots o=
f other platforms seems to do similar things in the nvme driver based on AC=
PI or DMI flags, etc.  On our hardware this nvme flag is required for all c=
ezanne and renoir platforms.

Here's the original nvme patch discussions:
http://lists.infradead.org/pipermail/linux-nvme/2021-March/023973.html
http://lists.infradead.org/pipermail/linux-nvme/2021-March/024017.html
http://lists.infradead.org/pipermail/linux-nvme/2021-April/024291.html

Alex

> > > > In this patch prepare a PCIe RC bus flag to identify the platform
> > > > whether need the quirk.
> > > >
> > > > Cc: <stable@vger.kernel.org> # 5.10+
> > > > Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > > > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > > > [ck: split patches for nvme and pcie]
> > > > Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > > > Suggested-by: Keith Busch <kbusch@kernel.org>
> > > > Acked-by: Keith Busch <kbusch@kernel.org>
> > > > ---
> > > > Changes in v2:
> > > > Fix the patch format and check chip root complex DID instead of
> > > > PCIe RP to avoid the storage device plugged in internal PCIe RP by =
USB
> adaptor.
> > > >
> > > > Changes in v3:
> > > > According to Christoph Hellwig do NVME PCIe related identify opt
> > > > better in PCIe quirk driver rather than in NVME module.
> > > >
> > > > Changes in v4:
> > > > Split the fix to PCIe and NVMe part and then call the
> > > > pci_dev_put() put the device reference count and finally refine the
> commit info.
> > > >
> > > > Changes in v5:
> > > > According to Christoph Hellwig and Keith Busch better use a
> > > > passthrough device(bus) gloable flag to identify the NVMe shutdown
> > > > opt rather than look up the device BDF.
>
> The changelog above bears little resemblance to reality.  I dug up all th=
e
> previous postings, hoping there was a hint about why this is relevant to =
PCI,
> but I didn't find anything.  For the archives, here are the versions I fo=
und and
> notes about what really changed:
>
>   v1 2021-04-14  2:18
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fr%2F1618366694-14092-1-git-send-email-
> Prike.Liang%40amd.com%2F&amp;data=3D04%7C01%7CAlexander.Deucher%4
> 0amd.com%7C7773f0f2af054b0ab45408d91bb08ad8%7C3dd8961fe4884e608e
> 11a82d994e183d%7C0%7C0%7C637571267348438733%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C1000&amp;sdata=3DKFiTsmHEIbv9Qe7UI4yjKjXr1mWSusA2LYV
> M07GUGAY%3D&amp;reserved=3D0
>
>   v2 2021-04-14  6:19
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fr%2F1618381200-14856-1-git-send-email-
> Prike.Liang%40amd.com%2F&amp;data=3D04%7C01%7CAlexander.Deucher%4
> 0amd.com%7C7773f0f2af054b0ab45408d91bb08ad8%7C3dd8961fe4884e608e
> 11a82d994e183d%7C0%7C0%7C637571267348438733%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C1000&amp;sdata=3DI2rKN%2Bixmn2NcXcZ20seu9LQC%2BekwH
> azH9oqzym7eeE%3D&amp;reserved=3D0
>     (Not tagged as v2 in the posting.)
>     Check result of pci_get_domain_bus_and_slot() for NULL.
>
>   v3 2021-04-14  8:18
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fr%2F1618388281-15629-1-git-send-email-
> Prike.Liang%40amd.com%2F&amp;data=3D04%7C01%7CAlexander.Deucher%4
> 0amd.com%7C7773f0f2af054b0ab45408d91bb08ad8%7C3dd8961fe4884e608e
> 11a82d994e183d%7C0%7C0%7C637571267348438733%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C1000&amp;sdata=3D7T9VcWinB8XQTR4tVKMZ4WkCI5oGKBBuH
> n33wxIZzbI%3D&amp;reserved=3D0
>     (Not tagged as v3 in the posting.)
>     Drop reference acquired by pci_get_domain_bus_and_slot().
>     Return "true" (not NVME_QUIRK_SIMPLE_SUSPEND) from bool
>     nvme_acpi_storage_d3().
>
>   v4 2021-04-15  3:52
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fr%2F1618458725-17164-1-git-send-email-
> Prike.Liang%40amd.com%2F&amp;data=3D04%7C01%7CAlexander.Deucher%4
> 0amd.com%7C7773f0f2af054b0ab45408d91bb08ad8%7C3dd8961fe4884e608e
> 11a82d994e183d%7C0%7C0%7C637571267348438733%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C1000&amp;sdata=3DaTgZtIfWMeoWZ3HoHcjclrJPW8qknIsuoVaz
> hZnoDHo%3D&amp;reserved=3D0
>     Reorder Signed-off-by tags.
>     No code change at all.
>
>   v5 2021-04-16  6:54
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fr%2F1618556075-24589-1-git-send-email-
> Prike.Liang%40amd.com%2F&amp;data=3D04%7C01%7CAlexander.Deucher%4
> 0amd.com%7C7773f0f2af054b0ab45408d91bb08ad8%7C3dd8961fe4884e608e
> 11a82d994e183d%7C0%7C0%7C637571267348438733%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C1000&amp;sdata=3D5yzUyXfIDKxTE%2B%2FJy5fgOS9yCsU10uw
> n4CjGd2mLLc0%3D&amp;reserved=3D0
>     Move flag from pci_dev_flags to pci_bus_flags.
>     Rename flag to PCI_BUS_FLAGS_DISABLE_ON_S2I.
>     Inherit PCI_BUS_FLAGS_DISABLE_ON_S2I in all child buses of AMD
>     0x1630.
>     Check dev->bus->bus_flags instead of using
>     pci_get_domain_bus_and_slot().
>
> > > > ---
> > > >  drivers/pci/probe.c  | 5 ++++-
> > > >  drivers/pci/quirks.c | 7 +++++++
> > > >  include/linux/pci.h  | 2 ++
> > > >  3 files changed, 13 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c index
> > > > 953f15a..34ba691e 100644
> > > > --- a/drivers/pci/probe.c
> > > > +++ b/drivers/pci/probe.c
> > > > @@ -558,10 +558,13 @@ static struct pci_bus *pci_alloc_bus(struct
> > > pci_bus *parent)
> > > >     INIT_LIST_HEAD(&b->resources);
> > > >     b->max_bus_speed =3D PCI_SPEED_UNKNOWN;
> > > >     b->cur_bus_speed =3D PCI_SPEED_UNKNOWN;
> > > > +   if (parent) {
> > > >  #ifdef CONFIG_PCI_DOMAINS_GENERIC
> > > > -   if (parent)
> > > >             b->domain_nr =3D parent->domain_nr;  #endif
> > > > +           if (parent->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
> > > > +                   b->bus_flags |=3D PCI_BUS_FLAGS_DISABLE_ON_S2I;
> > > > +   }
> > > >     return b;
> > > >  }
> > > >
> > > > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> > > > 653660e3..7c4bb8e 100644
> > > > --- a/drivers/pci/quirks.c
> > > > +++ b/drivers/pci/quirks.c
> > > > @@ -312,6 +312,13 @@ static void quirk_nopciamd(struct pci_dev
> > > > *dev) }  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> > >       PCI_DEVICE_ID_AMD_8151_0,       quirk_nopciamd);
> > > >
> > > > +static void quirk_amd_s2i_fixup(struct pci_dev *dev) {
> > > > +   dev->bus->bus_flags |=3D PCI_BUS_FLAGS_DISABLE_ON_S2I;
> > > > +   pci_info(dev, "AMD simple suspend opt enabled\n"); }
> > > > +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1630,
> > > > +quirk_amd_s2i_fixup);
> > > > +
> > > >  /* Triton requires workarounds to be used by the drivers */
> > > > static void quirk_triton(struct pci_dev *dev)  { diff --git
> > > > a/include/linux/pci.h b/include/linux/pci.h index 53f4904..dc65219
> > > > 100644
> > > > --- a/include/linux/pci.h
> > > > +++ b/include/linux/pci.h
> > > > @@ -240,6 +240,8 @@ enum pci_bus_flags {
> > > >     PCI_BUS_FLAGS_NO_MMRBC  =3D (__force pci_bus_flags_t) 2,
> > > >     PCI_BUS_FLAGS_NO_AERSID =3D (__force pci_bus_flags_t) 4,
> > > >     PCI_BUS_FLAGS_NO_EXTCFG =3D (__force pci_bus_flags_t) 8,
> > > > +   /* Driver must pci_disable_device() for suspend-to-idle */
> > > > +   PCI_BUS_FLAGS_DISABLE_ON_S2I    =3D (__force pci_bus_flags_t) 1=
6,
> > > >  };
> > > >
> > > >  /* Values from Link Status register, PCIe r3.1, sec 7.8.8 */
> > > > --
> > > > 2.7.4
> > > >
