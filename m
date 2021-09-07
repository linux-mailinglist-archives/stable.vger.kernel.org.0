Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8E8402CA2
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 18:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhIGQKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 12:10:49 -0400
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:42592
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233616AbhIGQKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 12:10:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOK2tikI21hu7fbvLCunm6kqhoLPsFabAUJmyK6W7x4S2jyM5L1zRPouH4t7gaxpsgOIiqOpswxOSs16lqeIKOiiWhlbky3m97qU9x0zZ8giRK5n8BLzZiw9QoNpMrR+z82VZvPwqOpyvwAmrlG9GQFTyyqIfpZBIz0RbeXZQHKPBtxJBGyJe1oTiiwWX18htwTviDTdpWlUgpyO515Y4QdkBfFGaLKxB59on3Bc+hJkgbItWyxpHh96g4Rp/yRFzFqAW2s8mWECOoSjL8qCkMLHfqlr9iwJLmyaCwEzC5nedi0HxTM2fh7xChPbYrt1hQfpnOLtYv5mFJ17sjmCaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UBQDjouz3xZ5j6uTJxujJjtpGbo4Exk7FZxy6n4nntE=;
 b=c+d1M5pbQbjwO+K0fhs7ha8JQgNk21Ab4F9qlnu2poEVN90lSlH9EBVpw02MHcg7y67Q4uTEIy/Snh4fsa9P3jTjuoM28WzOA7yFtHpC2xVGyQU2FSTGT/Yh7yXjRNZOplVAKIk8GBoQ8ZguKt3DF72c89337hKZ9Zpv2GhNIzk+LTpBBkIiP+n+MyBWgzmQqINpUVRur4WdqFvXLkU8Vt+pfUZ4AN4ptAAL+pHBW73mjIcpWkLTr5uNV2sdsOWZ1vW9SvL0NUJg+vqXAy+4UQ97KJaTfz+2hvTIGY41sayHwbhcXupGZ5RqUH9PcF5GltwEGw2GLTPTpD8mv7YBiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBQDjouz3xZ5j6uTJxujJjtpGbo4Exk7FZxy6n4nntE=;
 b=Et0BtLtJbhcmvt0U/F8DBie2Gv5dguqqkT2CVVKQfGffvIxqc5MCHHTphQkESNL0LH8yg0Isi/UzLV/aHCFwpsY0H7mFwn/JbJ2GVkMTXOhSi4hTYoRhS1sGBuY9p1mwnzNjYBDw6Uz3H9gJqPAS4QbrdtQL1qutshXrOS5495A=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL0PR12MB5524.namprd12.prod.outlook.com (2603:10b6:208:1cd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 7 Sep
 2021 16:09:41 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a%8]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 16:09:40 +0000
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
Thread-Index: AQHXoI2e5hBCwlRbskaRr8ZQ4rfisKuSuiqAgAYE1qA=
Date:   Tue, 7 Sep 2021 16:09:40 +0000
Message-ID: <BL1PR12MB5144184FB2D6686C1B00ADE4F7D39@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20210903063311.3606226-1-evan.quan@amd.com>
 <20210903195525.GA485189@bjorn-Precision-5520>
In-Reply-To: <20210903195525.GA485189@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-09-07T16:03:10Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=61843e0f-0ddd-4724-8dce-805a3a8aae50;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1242bfa1-8922-4c2b-6a14-08d97219e60a
x-ms-traffictypediagnostic: BL0PR12MB5524:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR12MB5524FF57BF2EC6FCA328374EF7D39@BL0PR12MB5524.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GKkabhu9xITeOj6U3XCNE8Ze4pyuJaPRvUABO+3Vt39l2I77bvHmTRqu+ZjZSTPdtz0rpjOrhv+Atept6JHXWSOyOXpktt3+chyj1j5WgLI6a1BUfKC1pPKfeN7YeEia8rC5siD8NLbPpxyy7ow2zT4cwUzCQH+PswbDVjJmzzGLvslI+ZbB5AXIz//xn9SnwiIfOFkm4aslo1f/rpb8ZYdYwXpJU2GAuBLIJAW+wZxOph1RZdIQinIrLvJkSXJlCSWZ0XPFXJde1jpliy6gzRvIDr9ae4N/T/rPv4BH7z33Nk50O+V5DZ9t7a9TcjyFGlbDd9PNtNpnAFcYRcBY5vH178+i8HfvREenmmL1vtiw7hokMOy37Vm3+fN2TEuA8yogLjNJ79NsolmWBJcj2c5lyiDkgypaCmQ7rb9AZh2DaFeFF8jCw8psuRMMHX54SkpYEuF3jO8XVdbSn1WowBw2AZ55+gUYdnXhXO8eduBJQmkiapXXvdlyzWM25bvnRHAz7Cj7e6cvh39YvX3eTuCGv0T27n4vDbPboZgy0h7X6sdSulKlJ46V6cBX09NOKdRMU+57ZdX1PnsTcI9IzubZrf9OYu7heNuETSBcGWOFtg/pn32EdyOwUQW70lIp9IFmAgOjcuV0ZDmpIEZs/2BHbUnCNa3OKbka1V4VI5A+SGpxNHumg7X090U38X10uRrYP1+ehKDUZTHO2Ax1g1+rwdvgIBgQX7dVpb7VRVhWv6kVMSJmMW/9tGFLUnfPS0xTYnV1m9itsMuU7/TJtV+8rYWbpPzpr+8JbQ7YTSM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(33656002)(38070700005)(86362001)(966005)(122000001)(38100700002)(52536014)(7696005)(6506007)(316002)(55016002)(53546011)(9686003)(2906002)(5660300002)(26005)(8936002)(6636002)(8676002)(71200400001)(83380400001)(4326008)(66946007)(66476007)(64756008)(66556008)(66446008)(478600001)(45080400002)(76116006)(54906003)(110136005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ThBmZIdl7YzlFgg195flk3bPEPRQnKofP4kfhK0CGE3OyvE4Ikvmy8uhW+ig?=
 =?us-ascii?Q?CyAKWGN4OgVPX8wOFnCL2nGw9+TmjwecmLdtqMyr56U42fv37lpp0M29q1Vv?=
 =?us-ascii?Q?tvn0Zjlci5q/hxb7pU5jl9ZEG8Jz6K4FuiGw8fV8mM2ojzPe0K3eMqMM7oIf?=
 =?us-ascii?Q?7JQBn27LtkWvNVc6vDZBrqLQ7enoRPqO7xp3tOtcOov5RsXLvpIqWRK/8Y4e?=
 =?us-ascii?Q?SHGmd1Va74WTFmsB4TKFRIYK2nyc6J4+ctk16GU8GWdGC58DZiT/lBnmv0KV?=
 =?us-ascii?Q?3es7j8N7rtXHkI40WxTwtadtUWJ/8e+MjwRyxvuc/ksZZToG2g4f9jtdwPuU?=
 =?us-ascii?Q?ZEZ/NjmBVoffJZdIEUQO/qNd2xgUm73vy8cFEmwv+ThO28R6U02Lqz3QWW6Y?=
 =?us-ascii?Q?XD1PCJxkCX3u/3uPvXos7TgAJpAvcZsXfqYD9CMJETZWgTqijpwVqcnmKSU1?=
 =?us-ascii?Q?BGawg4cvgfK4VifamkLVlcNwWGgN1d8wMwPBbtdeIWaXYNUvaxGns8hUlLwr?=
 =?us-ascii?Q?x2wZcy6cv0+DOwqA7693fOJEa6w0uj17uuatFKymjDS3QNWCGnIEvAbFt2V/?=
 =?us-ascii?Q?NJGvD0EZmfylMvsIMbHOIQIG7Emy7IExM3zBwCUfrSmoyBL6Uf5e2poCesXN?=
 =?us-ascii?Q?VXqV6CRMXPUawaA5m1xg7gHXikErjoq/H43CKGrL3uNYJqee9zDw2r26THEl?=
 =?us-ascii?Q?QtyglDLx9jrivGe/BeDCx5mEEI/4sxSgRFKqtLpBCtJToFojQEHe7AWlau8V?=
 =?us-ascii?Q?tE5gLt3s3Zr1DzJ4xjjA3qJaUJpNLVyw9/QthUnqAf14vuZ7QA75aa9xyXQ8?=
 =?us-ascii?Q?YgM4nEdZOD5u2XZfRYVRkYkSyfvqZh/+D7UqxA/a2RdF2bxTKJs/Yu+dl9S8?=
 =?us-ascii?Q?0oSUulSeBNQ9vS9e3spLPP8k3L4n3yYDunTm7Idf5ePGRufZ5hVLI5Yy6fw6?=
 =?us-ascii?Q?Q7gcOGf5rKbnteWUgkBNNxczt6wPNjYBJT9kcgd+uaXHhC9cFGINvpws8fL/?=
 =?us-ascii?Q?iemu/eaVjC5RsZubQf5QLOB997t7x43cbGbeECersA/xrsw9y9W2dhXIyooe?=
 =?us-ascii?Q?tuFnS77iGmHh5KJQ85Sl+QvlQtt9Aedsk6gWoJgkdy9cZeVnNOUmPI/tlJdS?=
 =?us-ascii?Q?2LCjsQf2IncxApLmrToIlygns0g8h4/smolHJk41TX1EcC4YEV+1S3TP3qvF?=
 =?us-ascii?Q?5xGWCIBBT5B95OtnMyk17CeGUwvIfZcvYgRmU3GJQkvPqSctMq+Hx03sMj4n?=
 =?us-ascii?Q?rzrtaG3t25BqLzZYZUG3c1ujH75uz4un0tI92s/4ljHX6lGIgO8A3VZmeLD0?=
 =?us-ascii?Q?sKps9VNYtFSrUIDx4Ef7NUYY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1242bfa1-8922-4c2b-6a14-08d97219e60a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2021 16:09:40.7691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QmeCfTxotfjixwxQvfVWby41QkIeEJbXPvJGLqBJnFj86mQoZzDun+4xnN6hQCfBGNfseWgY5I7N8alO4PkZZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5524
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Friday, September 3, 2021 3:55 PM
> To: Quan, Evan <Evan.Quan@amd.com>
> Cc: linux-pci@vger.kernel.org; bhelgaas@google.com; Deucher, Alexander
> <Alexander.Deucher@amd.com>; stable@vger.kernel.org
> Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI
> and UCSI controllers
>=20
> On Fri, Sep 03, 2021 at 02:33:11PM +0800, Evan Quan wrote:
> > Latest AMD GPUs have built-in USB xHCI and UCSI controllers. Add
> > device link support for them.
>=20
> Please comment on
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit.k
> ernel.org%2Flinus%2F6d2e369f0d4c&amp;data=3D04%7C01%7CAlexander.Deu
> cher%40amd.com%7C9fa0d66e5f29424df36b08d96f14c710%7C3dd8961fe488
> 4e608e11a82d994e183d%7C0%7C0%7C637662957313172831%7CUnknown%7
> CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwi
> LCJXVCI6Mn0%3D%7C1000&amp;sdata=3D6IlPLWlcO7iptbTqfh71fe5wmHN7RN
> 13OvScyYaWyI8%3D&amp;reserved=3D0 .
>=20
> Is there something the PCI core is missing here?  Or is there something t=
hat
> needs to be added to ACPI or the PCI firmware spec?
>=20
> We want a generic way to discover dependencies like this.
>=20
> A quirk should not be necessary for spec-compliant devices.  Quirks are a=
n
> ongoing maintenance burden, and they mean that new hardware won't
> work correctly until the OS is patched to know about it.  That's not what=
 we
> want.
>=20
> I expect we'll still need *this* quirk, but first I'd like to know whethe=
r there's
> a plan to handle this more generically in the future.

The requirement here is that all of the additional endpoints are dependenci=
es for powering down the GPU.  E.g., the audio controller and USB endpoints=
 need to be in d3 before you put the GPU into d3, otherwise the non-GPU end=
points will be powered down as well behind their drivers' backs.  On newer =
AMD hardware there is logic in the hardware to wait for all dependent devic=
es to go into d3 before powering down everything or power up everything if =
anything enters d0, but this requires additional software setup in the GPU =
driver as well and older versions of the driver didn't set this up correctl=
y, instead relying on software logic via dependencies.  Earlier hardware di=
dn't have that logic and needed software help.  That said, I think all of t=
he relevant drivers expect the hardware state to be powered down when d3 is=
 entered and they may not handle a wake up properly if not all devices ente=
red d3 and hence all of the devices never entered a powered down state. =20

Alex

>=20
> When you repost this, please follow the subject line style of 6d2e369f0d4=
c
> ("PCI: Add NVIDIA GPU multi-function power
> dependencies") so similar patches look similar.
>=20
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Evan Quan <evan.quan@amd.com>
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
