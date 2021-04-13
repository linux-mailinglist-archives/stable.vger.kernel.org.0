Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7457435D832
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 08:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhDMGoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 02:44:32 -0400
Received: from mail-dm6nam11on2048.outbound.protection.outlook.com ([40.107.223.48]:62976
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229873AbhDMGo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 02:44:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4JjIrkSN2A9aJffhn3078IChXqOF7uN5WUSPWNZwEd/MUINhBrptcvL7lpbUx3wOcqGxeXnjRknCBUEev6WdDMc60V94SqNjUH53QChfCV1lAlsyBQZW+KaRlqYqi+BeHBreOHmFLvor+l8DotPSbAaFq4anY1wMwR8QZO2FbUY8aaf78NfmAxBYwH6NP1TIKGdxC9Ya8QNZYQi0Akkm02danwoZ1kZ9JzRQerYGH8+BI6bnpo0rYxZHFX+wl6bB7nCVFuSMd5kHox9tu6AgcTIhdfADiUTu3vARM4HMaZvTbDkdJKkmrZovIOM7LDnxNpZ2MFLr6YDzrD/ohWBsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+XuXAjyn9gJSC216S/ew5Cm3PPN92f1tDAEBzaRrsE=;
 b=FLhCRuAbJDDS64pEOH80jikmHXcd6AmFivl5Sz1lduQyt2sFeKdNHE6BK2oVNSJcu80kVMNJrOhJNhorA3vPKZXgsOk6z/2wnOLn8QzYdMRmqvJ5WGDVKxuNOFwj+ktodVsXdEHPvw0xuUpvJv4OCW78buCYwqc5GH/U43ZDBcnttICbBZ0O+J6vKalc0D9dcx1Ap6UXriya8X/idkLYs4iNWg5E6cg7VvPODZt1sc9KDquXE+RoSUDAotFOuT4kVYWQYzbKGQvjh04cQlJgqYGQAJxa1s3YFQzZ+HaRHetdGVnwmkDWvYNFmA0KTOhSN0z4eCNp1MGbeH2CMtOu5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+XuXAjyn9gJSC216S/ew5Cm3PPN92f1tDAEBzaRrsE=;
 b=a9j9i84QLGJem1jlRPU89BJgykR14f3uu77wRZYa3FcWuWUTvEgTlImnHUF+URIu1yG1ijhBWmdHJ3mbDxU9DQsNRdifHVaOGzD6O3dGb/DJ857kc+HTdsvKj0WWDbxq3qmT1UHpi6ieSrg3mCjuHGnJnguk+FSu04c8S1LeXZs=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB4306.namprd12.prod.outlook.com (2603:10b6:a03:206::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Tue, 13 Apr
 2021 06:44:08 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 06:44:08 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Subject: RE: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Thread-Topic: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Thread-Index: AQHXMCvPNI8o+14yDEWiSRS19TAo8qqx/XaAgAABOTA=
Date:   Tue, 13 Apr 2021 06:44:08 +0000
Message-ID: <BYAPR12MB3238FAD129CF0E7F0DAAF205FB4F9@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1618294221-11528-1-git-send-email-Prike.Liang@amd.com>
 <YHU7M7ThQiAsOCSG@kroah.com>
In-Reply-To: <YHU7M7ThQiAsOCSG@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=1d395750-7d04-48d2-96da-0d5fef424e4e;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-04-13T06:39:07Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [139.227.235.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fced3f3-470c-4a29-7678-08d8fe478a29
x-ms-traffictypediagnostic: BY5PR12MB4306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB43069DA7AD8FD0385B92669FFB4F9@BY5PR12MB4306.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xv7wkb3PyO6fqshopVKH41Lwc0chU4xkNjBluiJ3GXSEHU9mxhl9/3GLjFmF6Cl3QJEELWGqThjbNf8Tv1rpvCQ/jaY0kv9tzPB32LKNQfSosJFElwhSe8bZf4P2vYsZKuqDgqMCYpa67l25jrexJeSmW2NlTatE/zG2YQTOl60B1JCPcYjM7jO/MJMF4mDdFXq1rZlB1NWZY1IgG/V4F/Pqg8AFHA2/uJExMEsPfiPY9uKvd9O+x91wmHJrE1d+x/f4UC5XMLwJa1Z+V1mSZXmT17/goHE9psYkQUQQUR0XYiRs4FjgPxosS/VPw5LNTPaMTDNpbKz4xCpLpodEHfY419VDFDNM5tSmv2Q/YnQu8by4+vr8vliwwZks+73vgqwUPvrUp01rO0PLFnaRvqMNHAT40tBeTfnUJKO5p0g7BKZpE06eKAV+a63lG9+oSSYmkHZL/Nun1WmGlluYj3pJpYJq3i0/Ew9EwNCmSJ+nkmwmHIEKfjI68Kg+3m+I32v0FY7PcExwswIFDIuTSC+Xj1Dpw0DgbykN/lVR/THyOtYFSFoFyMMxfVHBSZL2BsZR4Z9ofnui4+hW1fMAmW15d6/tlWtW8KqKTkSXVN4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(110136005)(64756008)(4326008)(2906002)(15650500001)(52536014)(54906003)(316002)(86362001)(9686003)(55016002)(6506007)(186003)(26005)(76116006)(8676002)(71200400001)(66946007)(83380400001)(5660300002)(66476007)(478600001)(33656002)(7696005)(8936002)(38100700002)(66446008)(66556008)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1/QIJKlcBYsBycyTwa2q4nUVH+Up+lu6Pplp7Laeu5z8YebEwDMwaP37Xujl?=
 =?us-ascii?Q?VOqnx6SDyuwpX1uA305uJwP4vCJb+02289iv9A1OI0acyjDX/L5iwJp5Dp03?=
 =?us-ascii?Q?VhzxJgVXr4KgwrTdQyAFFLH3PFzhYyYECIRvHPO8V3ZAyPJ6aeJ6X+jy9ir6?=
 =?us-ascii?Q?eLTOwjvt3Zggg4p88o2fDNvr/rEdcpvOUzOyz46r03e5QocOaf+X5mjpnAMy?=
 =?us-ascii?Q?i8OKAw68yCXWVB2GkGp0PQdgRzQXrtSehKepv0htGEDehx2wsCSuoNMT313n?=
 =?us-ascii?Q?f7BLkqWqw35eClM8Tz2Oi/fF5lF6koO+FiKNLAsWLm+moerCMyMlGaGWC8xD?=
 =?us-ascii?Q?+U2G8bKD9MpDUZgCEcW7PvOVN/XwgKeJNd3WzuxpJLbLR1+CNYadqINCfwft?=
 =?us-ascii?Q?EJ8hRLTWTRnh4Sr4kE+d3DaIlXKcEEremNfvcxQwtuSZJVcudD8bPbrTSnIz?=
 =?us-ascii?Q?x6w/0oiOdhxOgKrPiBwVUI8IswVwMa2UKFTw50Bxq7VoNCIqC5RxCXFSX6jA?=
 =?us-ascii?Q?gOWEfJlLnz+5TuxT4PtctlliiqnDMZAZPvImu+8LRZB0MJrko8Ek2uJifSlR?=
 =?us-ascii?Q?Eyko4Y2/+TMJ2+PWaKc98ngtaJTDCzNDxZROoOQfVS/YlILByIVK7aYRXM+R?=
 =?us-ascii?Q?BzPiqnAkIe2CRgcos3mk+2fbVa/NnpkbismT+0s9sDJ7WsPSAMZimDtjGlA7?=
 =?us-ascii?Q?xBhgKU1f4xhmFT521dMgijC/jW/2jPSvB9UKW9sQ8+eNtO1SFxT+mXHBKY6Q?=
 =?us-ascii?Q?7WUfJNcd7XNd3/jTy0E3cacjV/o34os6YgsCt8aK89zp2hcMy7nttQCKzTGc?=
 =?us-ascii?Q?U+bPkpKuNAWYKxrDF0Fnoa1KmYATZoTXqj9+vqV2fv0DVDFIrvTCPlSsSCsS?=
 =?us-ascii?Q?pIlueegYkAIWFPuAvqEzDaMAvci8d5Mov3MbgljHFHDmnnTGgenoDPqjW46f?=
 =?us-ascii?Q?50dAghoBeqebVZZ545EnNannUS3y6J6MgmxKb0ja0gOxPNJuZge5xqSsEUHH?=
 =?us-ascii?Q?6j0seaPYqzBmFK/0O7ZjtvEAKxH70AygcO5OQF8hCWOfBP+aQ+z/wPXZVkNd?=
 =?us-ascii?Q?x6j+dCjUYW7Ie8u/f+tBMICnE32OA7eKDo0c7M6ImR1wyYLizoILJXcdMikY?=
 =?us-ascii?Q?s+/cOYVE3jO+vE3VNGI93KMhjKpziZ4zK67iVLVaX37idBVxX91T+qgjonbP?=
 =?us-ascii?Q?6XkYWhop8YR91VC6usEa9RiBTA9Or+C2h86FufipM9Vls5Ww2jVQfr6/Dk36?=
 =?us-ascii?Q?r1hgitmUI1yzDWBnxjDgHYVedsNyiEvqmXr1rI/rcfNQXhudpDaNNve/cxbV?=
 =?us-ascii?Q?K5kXEi53gWpg6GR/waIi42EH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fced3f3-470c-4a29-7678-08d8fe478a29
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 06:44:08.4892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q+3vMSN/FuVpzTK/0dYuS2aWVDsb+RFKxyE3L1F/wSsBAOxca+BzCoobPaptgcW0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4306
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

>
> On Tue, Apr 13, 2021 at 02:10:21PM +0800, Prike Liang wrote:
> > The NVME device pluged in some AMD PCIE root port will resume timeout
> > from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> > This issue can be workaround by using PCIe power set with simple
> > suspend/resume process path instead of APST. In the onwards ASIC will
> > try do the NVME shutdown save and restore in the BIOS and still need
> > PCIe power setting to resume from RTD3 for s2idle.
> >
> > Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > Cc: <stable@vger.kernel.org> # 5.11+
> > ---
> >  drivers/nvme/host/pci.c |  5 +++++
> >  drivers/pci/quirks.c    | 11 +++++++++++
> >  include/linux/pci.h     |  2 ++
> >  include/linux/pci_ids.h |  2 ++
> >  4 files changed, 20 insertions(+)
> >
> > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c index
> > 6bad4d4..dd46d9e 100644
> > --- a/drivers/nvme/host/pci.c
> > +++ b/drivers/nvme/host/pci.c
> > @@ -2832,6 +2832,7 @@ static bool nvme_acpi_storage_d3(struct pci_dev
> > *dev)  {
> >  struct acpi_device *adev;
> >  struct pci_dev *root;
> > +struct pci_dev *rdev;
> >  acpi_handle handle;
> >  acpi_status status;
> >  u8 val;
> > @@ -2845,6 +2846,10 @@ static bool nvme_acpi_storage_d3(struct
> pci_dev *dev)
> >  if (!root)
> >  return false;
> >
> > +rdev =3D pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
> > +if (rdev->dev_flags &
> PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND)
> > +return NVME_QUIRK_SIMPLE_SUSPEND;
> > +
> >  adev =3D ACPI_COMPANION(&root->dev);
> >  if (!adev)
> >  return false;
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> > 653660e3..b7e19bb 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -312,6 +312,17 @@ static void quirk_nopciamd(struct pci_dev *dev)
> > }
> >  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> PCI_DEVICE_ID_AMD_8151_0,quirk_nopciamd);
> >
> > +static void quirk_amd_nvme_fixup(struct pci_dev *dev) {
> > +struct pci_dev *rdev;
> > +
> > +dev->dev_flags |=3D PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND;
> > +pci_info(dev, "AMD simple suspend opt enabled\n");
> > +
> > +}
> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> PCI_DEVICE_ID_AMD_CZN_RP,
> > +quirk_amd_nvme_fixup);
> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> > +PCI_DEVICE_ID_AMD_RN_RP, quirk_amd_nvme_fixup);
> > +
> >  /* Triton requires workarounds to be used by the drivers */  static
> > void quirk_triton(struct pci_dev *dev)  { diff --git
> > a/include/linux/pci.h b/include/linux/pci.h index 53f4904..a6e1b1b
> > 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -227,6 +227,8 @@ enum pci_dev_flags {
> >  PCI_DEV_FLAGS_NO_FLR_RESET =3D (__force pci_dev_flags_t) (1 << 10),
> >  /* Don't use Relaxed Ordering for TLPs directed at this device */
> >  PCI_DEV_FLAGS_NO_RELAXED_ORDERING =3D (__force pci_dev_flags_t)
> (1 <<
> > 11),
> > +/* AMD simple suspend opt quirk */
> > +PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND =3D (__force
> pci_dev_flags_t) (1
> > +<< 12),
> >  };
> >
> >  enum pci_irq_reroute_variant {
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h index
> > d8156a5..7f6340c 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -602,6 +602,8 @@
> >  #define PCI_DEVICE_ID_AMD_HUDSON2_SMBUS0x780b
> >  #define PCI_DEVICE_ID_AMD_HUDSON2_IDE0x780c
> >  #define PCI_DEVICE_ID_AMD_KERNCZ_SMBUS  0x790b
> > +#define PCI_DEVICE_ID_AMD_CZN_RP0x1630
> > +#define PCI_DEVICE_ID_AMD_RN_RP
> PCI_DEVICE_ID_AMD_CZN_RP
>
> If the pci ids are identical, why do you need different entries for it?
> Haven't you above just listed the same thing twice in the quirk entry?
>
> thanks,
>
> greg k-h
[Prike] Use the different entries for identifying the RN/CZN respectively a=
nd that will clearly imply which ASIC need this quirk. Anyway we can use th=
e one DID for RN/CZN to avoid the PCI ID retrieved twice.
