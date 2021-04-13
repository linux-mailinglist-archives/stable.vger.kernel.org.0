Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1DF35DB28
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 11:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhDMJai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 05:30:38 -0400
Received: from mail-mw2nam12on2051.outbound.protection.outlook.com ([40.107.244.51]:54464
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240613AbhDMJaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 05:30:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dr1ughq9PJpmlHo8CzV0/x1BQ2KHjVwml6aWOgqS1bUOzVgnOjyoJT1+Z2BbQSRdXFby6x7vUOqm6F3l7MvrIKlPC2UY4rO/46XWBUCxn6uPMhXL2q6U5WSIsNTtxVxPO2W9GV+8uiRF7Vf1LLtUnx3QYOSQDE+cVkZ/yvTC5t+SK7lYQqRB1PH1/qSC5Fz9JXZt1Tx2QFqUsAvHpQQIL9m/FOsI7Q1+S0N89HS8DEcWuxmFChuplEotl5980VLo9ZL14fR1+Fo4p9SmI8243CQ+NeS0Uc5WX4e0Q0r/at0yuDExbFgWmBw97P+Jbk8X5v6+Tc+/yV1pbpigm9Oqyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CpQ2uGsKJTaA9M14UKUbZqDZre7zLRHfW/duabXWlA=;
 b=SDIJtRfr2xo4mluUeQ1PEfnOr9SRsTpJ2lImiUY4OAjPvlJUPQZHgbR1w/OglR43GnWFqFKHcCBw9Eluz29LCEGUYPdA51hnJ/aL1L3doBQA0i3B4mUMiMXqxdxcJpEU4wBWw4ECmbCvJ+dt5EBbiwvLyrD1+0sXzPUY8y/axZhLkub7mNIzyRkHOA7XhJv2vxC3YX/3O5+Nt1eLUth4Vpk6gbI5bfqqgD/ffGekrlBmhLxvKpxUQ8SkI+eEqPjc1jfrH6rcdrw+gMzpkHanC+K6zJih2mAofFt7BL8nKi9sgPhAK+TL/srC2XLObhXDtjb3nvXCIdXqK+agAZ4vag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CpQ2uGsKJTaA9M14UKUbZqDZre7zLRHfW/duabXWlA=;
 b=wNoK+Ly7O5Mt9SkChFhWbBRUFtNmhlQu2aXTtchhykVbZn80WmHB5xnRS0H629rEzy5UwkbYLiBSNOwRAae3g9s3luZ2drss2nsM/1UVR8kNR7hIGK/Tu8O5RWmW23zjhWu1qWk91Zti5H7ZlFERvSBCiFw+Sntr5MaddjuEfPs=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB4129.namprd12.prod.outlook.com (2603:10b6:a03:213::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 09:30:14 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 09:30:14 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: RE: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Thread-Topic: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Thread-Index: AQHXMEObn/NiQ25mJEKxb9/5LZUzg6qyKbOAgAADxIA=
Date:   Tue, 13 Apr 2021 09:30:13 +0000
Message-ID: <BYAPR12MB3238ECDDDE0239CF06249D4AFB4F9@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1618304441-12550-1-git-send-email-Prike.Liang@amd.com>
 <YHVgd+dOAGWIl3+m@kroah.com>
In-Reply-To: <YHVgd+dOAGWIl3+m@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=2b34e2c8-5f46-4df2-89b4-2ccb6dcb11e8;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-04-13T09:25:58Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [139.227.235.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd959d45-48f9-4a90-cf99-08d8fe5ebe12
x-ms-traffictypediagnostic: BY5PR12MB4129:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB412916BC0DBD61DAB8F6F1E7FB4F9@BY5PR12MB4129.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UPLA3n+EzmSeW44BqlTWwmwa7p4Yu0eSVyNtxusnGHDv1WGnqODY4sjJu8uDXrzAOohNTyzaaHJR+kyp/YQ7NXXfv0XLmDJE2Kl/U2mZrqn04jlkppG0akVGc8a84aRpPNkbpO6o/qJUtaBuGxMs1+PEh0aQFDbK45K3/ns6Qz2mBceF3JYGnR54HdUwno79jVBmHQfUKIm0dwiN80D0maWNPH68f3mWhsPjCpTOFz2/EdluKW//l7uTsdR2t5gQaB4Zd0ZYz3wHvbmkhy89qN6LzuHktF+BZafSzJSZD4cxCm+9NUFNWSPJVLtnU7Wegf5Itg93OX8Ku3ne169C8OZvGwziEIgrycALjcLY8vmVYY+5NkRds0x7S0cSFPf8bEnhzH9qzt+vaAXHjpSagq26AWnv93RmaIY9lREWLJy5QWR3mRONUOvHiV9byRkgzYomDceHiikTyphGT0/88TMb65KpT4CKtHhP2cKNZYbwZJHTld1koHrRq4DyDCq42ccEbgmr2KnzBBdhf8cpKG1pmO/eeYkfw09Y4px56GNCChAQDx6+7HYJO24z6xgFmXcrbvKI587J+e+Xnv9gk3iWlXD7VSunWDF8ihm4Bfs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(53546011)(15650500001)(186003)(7696005)(38100700002)(33656002)(4326008)(2906002)(55016002)(122000001)(6506007)(66446008)(26005)(54906003)(71200400001)(66946007)(86362001)(76116006)(66556008)(8676002)(52536014)(8936002)(64756008)(66476007)(9686003)(478600001)(5660300002)(83380400001)(6916009)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SlaA1SKdXdP8b580jagZfW3WYDCiaOPIh9KEm1WDe7lTZ6koWS0loJ/nlS8M?=
 =?us-ascii?Q?cUiFBJiPuCmZG4trO5ealnlk0/BhWui3eaeHWsWDwCbKcVHl9URbmfyw8ybL?=
 =?us-ascii?Q?/4UqZENEKs/kmDDtpxxy7GvbeUEL9wOwSWnNiwjdxLarA0WtG6iWfuApsoDu?=
 =?us-ascii?Q?OlLXMeWw3RnxGIRJq9l/cVlln720rVPghhpjXwAqcSC3TvYRgnxCAz+9iLa3?=
 =?us-ascii?Q?jFmpX2XqoLbsnGMDSZ0jVrl7t9oVNIC7YWaF21LrtBpzc8H6UD9rBQkz8WXZ?=
 =?us-ascii?Q?wxhOJ2+/zlgUkZjIweNCcFaIUgDoJGcfVbZ8KIXh1iOyHTHS0s1csP9DKBXh?=
 =?us-ascii?Q?aG/YYmSsvNjYQHHh0fgZgLRy8+5B7JXCRibVF3O4IUabMP8yWJ0Unwt45zOV?=
 =?us-ascii?Q?QLQyE31nqbrTIxpIwGyG5Egxhsu/o5fMhnMZaQe7tzjWrPVdkIFwUtMNZTKT?=
 =?us-ascii?Q?d3EszPXk1nik9xc9/lepiWU1rhRu5w1pajsrF4dqzgE6VfzE4O1kZC98b7XI?=
 =?us-ascii?Q?pfXL9bpow+/Bjvv/koQ559XP6jsQit4b51QMv5unLEy6BtPr8k9IWHRISfqg?=
 =?us-ascii?Q?PcyyPdHvGs1zyez+7R+X8RFdDAXT6ePUWV5/17TbTmVF0DB2d7cbmy7nF6va?=
 =?us-ascii?Q?7Lz9mCWqAe8M1VCIFK5K9E2JmqszciMdZ/R9D9ETtRHFlR0Gb4JlQujRufD1?=
 =?us-ascii?Q?AXno3u0LdCwXHwjwc+lqdf2rPyjOjsWmNZFLwYFsvqleK0RCzySNf07n4/w0?=
 =?us-ascii?Q?slAFztmVjppUbEz0wcSwfAAFBq+1CK48LQWpTiFg4XJbBRdJ8Tt4eJ2Zq02o?=
 =?us-ascii?Q?MFJAytt6M17mqZBQjfO9YItyH5bVy6YNlIECwyvy+S/q3b9kjyKplsmz9hv9?=
 =?us-ascii?Q?uMCfzdI4art52L0BosJ24tBqQ8n239gNcUKAFSiHVTaMEMDsBIyLl7JbO645?=
 =?us-ascii?Q?QsFISCQ6LNk9si3AkNcbjd53BO4l+5MRO2rlauHEPK7nuAV/o8efpYo1t4uH?=
 =?us-ascii?Q?6nmRKcDtFFFPP3FHIWdK9JmTwPYWNvj0ay00ZsWhHvHINEBIhI81pSjLbswF?=
 =?us-ascii?Q?7J/23cW5WfjfJ5oHXl8UeqPDayMPfIa6oJ6j7tqyTRi8h/T8XmzwVocjyqVI?=
 =?us-ascii?Q?gO3AbEzG77IIK5n6ia46REf/WGmROnj7xZBO4CeL6ZwnCgs1eNH4xouG4KCE?=
 =?us-ascii?Q?5UBtyxLx8ZNrWmWlBlT/jb2ZiypSBvmL+2U4nDqkWxT6MMaOr6GbHwoAsFWZ?=
 =?us-ascii?Q?ypD8cnj7MCFGDhR1E3xk23m7JA9vhf4PtJ7WCJ/asXPVDEKh8ic/XAGvJNB0?=
 =?us-ascii?Q?3kkE1cb5Qk9l/y9l36PJG+YY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd959d45-48f9-4a90-cf99-08d8fe5ebe12
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 09:30:14.0171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jBB6CsSTRKN0NS7fi+gladidhNp2xZpaYLcUoYVVz4sZHXg3ucGJDAETeByplz7W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4129
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, April 13, 2021 5:12 PM
> To: Liang, Prike <Prike.Liang@amd.com>
> Cc: linux-nvme@lists.infradead.org; kbusch@kernel.org;
> Chaitanya.Kulkarni@wdc.com; stable@vger.kernel.org; S-k, Shyam-sundar
> <Shyam-sundar.S-k@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: Re: [PATCH] nvme: put some AMD PCIE downstream NVME device to
> simple suspend/resume path
>
> On Tue, Apr 13, 2021 at 05:00:41PM +0800, Prike Liang wrote:
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
> >  drivers/pci/quirks.c    | 10 ++++++++++
> >  include/linux/pci.h     |  2 ++
> >  include/linux/pci_ids.h |  1 +
> >  4 files changed, 18 insertions(+)
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
> > 653660e3..0b175ce 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -312,6 +312,16 @@ static void quirk_nopciamd(struct pci_dev *dev)
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
> > d8156a5..a82443f 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -602,6 +602,7 @@
> >  #define PCI_DEVICE_ID_AMD_HUDSON2_SMBUS0x780b
> >  #define PCI_DEVICE_ID_AMD_HUDSON2_IDE0x780c
> >  #define PCI_DEVICE_ID_AMD_KERNCZ_SMBUS  0x790b
> > +#define PCI_DEVICE_ID_AMD_CZN_RP0x1630
>
> Why add this here when it is not needed in this file?  Please read the to=
p of
> the file...
>
[Prike]  I'm sorry can't get you meaning before. Do you mean the pci_id hea=
der used only for the global PCI ID definition and in this case only need p=
ut the 0x1630 DID in the quirk entry directly?

> thanks,
>
> greg k-h
