Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F13A40CA79
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhIOQk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 12:40:57 -0400
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:23521
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229465AbhIOQk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 12:40:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1jLW5uOdMHFWm0QL3iHEZVrcdXGACh123rvikPNZQvWV5k1hXjuT3eGFBLbDMlgZ9D/D0X+z5+FF5o1/GYszI8Q/WBr4wq3iYtaJFCS6kKvJWAJbX1M9nhnHINnJSgNCmtoSqTuxJ5vUDkG093qjJy4nmga7gtHQqTrmp+dgCrDpmoTiIspEbogEP25ygT524WaT0kj7dvMYNFUO51E1zpbHGcl3orFGfW+TJqYcwhJQIBEWLPiGIEMNqNHiLQIc+r2JOxOXwGhSnZisnK4Fw59YaKJg9dkeW7LzlZm8USgVzta+IFoX8vr07nC4lKaHP+7dBCiQtzUCMkrCjGKaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=O+n6gFDHGNcyI5NawLMoWWbx1eXZI/lzUPkGxNtRsJ8=;
 b=f6kLQCNJYa3Rjd+W6Ux5lkPpUQvwYqu67bRq3xVKTZm6RgHCwPoVM3hBrojqMZ/+5uRyND0GEMr+dh5Dh80gwLFIh8UJIiJqg28ibyncRAsQK+6xxC0BbMlZgbh+53njgm3oVOHCTgPQMZ/kPg3zNTnGHnGJadmd/1EjqO8Vg2Tbnk0j6FnWbvjfu9ZR/alYzXMb+KFUa/1/kp1/CEBWbOZaKpyoylM/yTawlcjK0MRFqpJ4WkA5MzQIGsOLhjgd2AZV50Pj4DtbFsvKkbIUOflUikd2vmfgCkavaBy1ZFvupgD3yI6cWr/UATlmj9l8cnp4Z6CcXN+X34cMynABwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+n6gFDHGNcyI5NawLMoWWbx1eXZI/lzUPkGxNtRsJ8=;
 b=bfIMVbzS57L6vM3YWf5+QBR+TUgB7OOL4v5ZwwzF5D2L943gzdkokpUGcfjAoauH+wTJmYo192Mlaa008a0igcC6Uec5c8gq9dnIYyBWXCfYZNIef+wFrMAIGxzkWrrkMRfS737ogpJbU2wjkAeagHKXZYbIHMSdvXO8chfdXU8=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL1PR12MB5352.namprd12.prod.outlook.com (2603:10b6:208:314::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 16:39:37 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a%8]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 16:39:37 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "Quan, Evan" <Evan.Quan@amd.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] PCI: Create device links for AMD integrated USB xHCI and
 UCSI controllers
Thread-Topic: [PATCH] PCI: Create device links for AMD integrated USB xHCI and
 UCSI controllers
Thread-Index: AQHXoI2e5hBCwlRbskaRr8ZQ4rfisKujuUoAgAGlOMA=
Date:   Wed, 15 Sep 2021 16:39:36 +0000
Message-ID: <BL1PR12MB51440CACA2F90377687A1C12F7DB9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20210903063311.3606226-1-evan.quan@amd.com>
 <20210914152842.GA1429517@bjorn-Precision-5520>
In-Reply-To: <20210914152842.GA1429517@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-09-15T16:39:34Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=5bece904-1bed-4daa-a89e-f0d16bb4bba7;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01947b7a-59b3-4bba-89db-08d9786767f4
x-ms-traffictypediagnostic: BL1PR12MB5352:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL1PR12MB5352E1BC7B1731BE1C6CD04AF7DB9@BL1PR12MB5352.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MsdCXmfTZXVHWuB3K+f/11Fz9bv7R5qro3FKlKwTGrayyAOV+mevC/9gtPyFWtDA0cMk0cgLOvxaOyz8QbfLXwAawWRKCmPwp9ePtjTYaJeDSQkCHKu9ZBLGxKBV+PmfD0e/m2ezompCfvovPFCEt/5Yx4bQggsNxxtqQ7RfBxXVcxVk9xcwqQo0ZyinYh8V9fGI1Yc89wHWoOLixRbTtPH2ux8snRisF821QvqeLX7dZJIDQhfO4nrW2Gy133J8sfugWrxECJyJSzkAQFWjnSOuXQY2IMCEGlXfNiUR/QkeyrzAnYUqgXrbQzD/8aX5Cwypv5+Lu12VdX7dd1w35y3aGAHENQ4cltPLa+PHYNvuYQY0JPFJ5Ue4XGVNe/RycTp0bITs9dOqDBIph0Px/Dii9RRmQFAC6neRIBrjcYSHa0xsUJW6JmULfa9jCTLeN0cwbHUJWMS+tjCTwUloBofv6gWXDjBoW+VLKzmVeR6n0pigbJZAPzfSRgfmBKdHqutK5J8dHrOJkKMQJSUgiO+5VWO/JVhRHP6LcthW0Cm+y2dKjSvSHXP+51xXYqXM529WJetdD8zPtacQssRxeDWfv01i0/MMJ2utgC0NmPJ40UjLd+MBtfOTsdTOHE8ZSFg6ahNiavSfptIWnAzjiV9VVFlZ4jqpm9PrkVcABA+AAx/q5xsOaswvkdzXGouhKaPgRCqqH1ezjgFSQVWbzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(966005)(66946007)(66556008)(64756008)(66446008)(71200400001)(2906002)(76116006)(66476007)(6506007)(38100700002)(8936002)(83380400001)(6636002)(53546011)(7696005)(8676002)(26005)(33656002)(186003)(9686003)(54906003)(110136005)(316002)(55016002)(122000001)(5660300002)(86362001)(478600001)(38070700005)(52536014)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4JSfKKgaQbkv9vnxE1gthwkZTMYZrZwU7RoMsCgbpnewoDM6ff0VrY2GxoID?=
 =?us-ascii?Q?mEyeQPebCJysr4snSdByFAVP1YuQdQ0CTm/DkQ2TbjdhtwIYJhs40NI3cZbm?=
 =?us-ascii?Q?Hv5JlU6XL9OTg1JhseJHWdiw+/8bDsXiNBWc9j4uKkR1jg2RPj4p6oY0CK74?=
 =?us-ascii?Q?SkTvZgokIjOGNTanI/sY6/UJBndLwURo2DSbNGwW84fivQeTsnqD2DqFbE/X?=
 =?us-ascii?Q?hJFBUgmtDTr1BcAX9fGJ0+Zpn8wrpDgvvcipeeW0n5cSJG8xj79b4+xYzX0F?=
 =?us-ascii?Q?YyCfAKL2ntP6epQMqcDd1uZVPKneiAMNqhiUi9z9gi++EvVk0yezAEfAqUV8?=
 =?us-ascii?Q?b+tmgQy2u5k9/euO9ZsdsDRSdwByeZPXzRg63QAXXOOce9vgGG8BkLkVnypH?=
 =?us-ascii?Q?+3Ue86WEz/88emGTkn5O6HlKt8q138knoxgOG+OLvzcTdkZBMPF9v/OVFJw8?=
 =?us-ascii?Q?z0QP4beqtDcC1k5CL6Wz+TENRHrzZFEyA4ZXaDVYnmWjX5mOtn0dWbCgLMZQ?=
 =?us-ascii?Q?mqdCNhBcTIXfTz9fY1u2cAR0r2AtUTvQirKwyTyGm4bTR+iyKSiMpc+aN+lA?=
 =?us-ascii?Q?p+plyJUWwQUh/xdeB/fcIyUcAKgWUMeuipk+H3vA61TbE4UmnSUdls6zLn59?=
 =?us-ascii?Q?vx7xSshrY9rhRQZf8szUarWXQkN8fyY8M6aRyQVCZkAh1Jdjnl1sgqOi2y20?=
 =?us-ascii?Q?GjYbbtJRo+GN/Fbv9XN6jQp/Sj8FvxJY0kGvrpS6KSebPY5l78m1ATJPEKot?=
 =?us-ascii?Q?T1/y1ZOOM+v5JcV8Ew2EpZOhtgwJ+vBCkB9t6ZdUZB/qZDYkONtD1yfBrtsQ?=
 =?us-ascii?Q?79NcItBSm46B5z0KykK2cy4QU8hyxm2R1ahtUMOYDAcMVCthPG99fu1eOBXQ?=
 =?us-ascii?Q?euEwl3RJhXVv73CRY0Vl4LAuh/5e8oYDjRn+HXa43rROID0sZKIa3vrckEgy?=
 =?us-ascii?Q?pQX3lxr3gNwLY+WXyTa8fSrR7YK4kdN6KcHw8BUp3uMi0KDQ/+ZncCpcFtTh?=
 =?us-ascii?Q?wkOr4YRRTC1DKuU5K/iXgneVFtT0ZlLdYFPPpaBOLIf5TEUTT/BvOn099ySw?=
 =?us-ascii?Q?3Ux/FRzHqPQbagOrK/OT3JMV5ta2LbVZepUQ36/xZG0O2BsrNbEtKtXJNN7w?=
 =?us-ascii?Q?w302AhKCCt7MT1qodhzrB3CRGJ9s9GBJjEUnqr4eZskaEcT1K155yA5q9feP?=
 =?us-ascii?Q?e5FntQfg/HPRHoMnxNnY1paymiRJfgsRbjSSGRSZvdIi9ralCEKtsRE8UR6C?=
 =?us-ascii?Q?J4IkF2KIZimCuA6ifFXYs/cGvhqEKAnnXHyDVe33NZ2M2I2YJM6Zdx9YPx8v?=
 =?us-ascii?Q?lr1AEBmUNLFhANWblegluEfS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01947b7a-59b3-4bba-89db-08d9786767f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 16:39:36.7872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BjfrneMMOXXx7CTDURvqYf//pSXD2Agb24w7Mqj1K5m57jUYck6cF9fQgDboefgQS9unNuZORLbVXHVhUfTyhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5352
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Tuesday, September 14, 2021 11:29 AM
> To: Quan, Evan <Evan.Quan@amd.com>
> Cc: linux-pci@vger.kernel.org; bhelgaas@google.com; Deucher, Alexander
> <Alexander.Deucher@amd.com>; stable@vger.kernel.org
> Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI
> and UCSI controllers
>=20
> On Fri, Sep 03, 2021 at 02:33:11PM +0800, Evan Quan wrote:
> > Latest AMD GPUs have built-in USB xHCI and UCSI controllers. Add
> > device link support for them.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Evan Quan <evan.quan@amd.com>
>=20
> Applied to pci/pm for v5.16, thanks!

Any chance we can get this applied for 5.15/stable?  This fixes runtime pm =
problems on GPU boards with integrated USB.
https://gitlab.freedesktop.org/drm/amd/-/issues/1704

Thanks,

Alex

>=20
> > ---
> >  drivers/pci/quirks.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> > dea10d62d5b9..f0c5dd3406a1 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -5338,7 +5338,7 @@
> DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
> >  			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8,
> quirk_gpu_hda);
> >
> >  /*
> > - * Create device link for NVIDIA GPU with integrated USB xHCI Host
> > + * Create device link for GPUs with integrated USB xHCI Host
> >   * controller to VGA.
> >   */
> >  static void quirk_gpu_usb(struct pci_dev *usb) @@ -5347,9 +5347,11 @@
> > static void quirk_gpu_usb(struct pci_dev *usb)  }
> > DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA,
> PCI_ANY_ID,
> >  			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
> > +DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> > +			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
> >
> >  /*
> > - * Create device link for NVIDIA GPU with integrated Type-C UCSI
> > controller
> > + * Create device link for GPUs with integrated Type-C UCSI controller
> >   * to VGA. Currently there is no class code defined for UCSI device ov=
er PCI
> >   * so using UNKNOWN class for now and it will be updated when UCSI
> >   * over PCI gets a class code.
> > @@ -5362,6 +5364,9 @@ static void quirk_gpu_usb_typec_ucsi(struct
> > pci_dev *ucsi)
> DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
> >  			      PCI_CLASS_SERIAL_UNKNOWN, 8,
> >  			      quirk_gpu_usb_typec_ucsi);
> > +DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> > +			      PCI_CLASS_SERIAL_UNKNOWN, 8,
> > +			      quirk_gpu_usb_typec_ucsi);
> >
> >  /*
> >   * Enable the NVIDIA GPU integrated HDA controller if the BIOS left
> > it
> > --
> > 2.29.0
> >
