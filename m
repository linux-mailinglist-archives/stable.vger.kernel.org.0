Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764D540AE7E
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 14:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbhINNA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 09:00:27 -0400
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:3904
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233216AbhINNA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 09:00:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4a8RYqfRIHdm9BrRK9UIGvrxuDlKM13xq2v+bGIvhmmLzODoz0EK8Fx/rSNiK3lgqs9xsrY+XV25umK1A7BRwzI7R+QpCk/KCh02j7JA+vJdQIfx83qlgbmptjFAkYdfgOUSJf24J1W/gjD+IukHvbiUmCHwhzq9MlNzIXvG9eQc42n5icmV2WnomQzvDiAcqYsQyEtqCpAX8a7lUJWblMDzSKn8WC7Y+PlVR6YEkXrnQOXCZY4a9xljgEVJoBfanLoRiOpJAhj2Tzomqp7RyZ7plRck5q9Jp+olD0AUOE2viQt5Gf5ljPdwDQrFYpkxgC9aq/SyVdankZAvSsKhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uA2TwovoS4NZ+YOENTjefhKY1E+NCftRc+hRCBEootU=;
 b=duEh1nKhzOflDjvrHKNl3R3MGk+BIrF7iyPJy93m4XrvF+wWCXY5T91MMVpRpl8s6WUo/6W5WHC3qURGOQ5DTOyo518a/Qpv9pW2QidqhSybEGIY3Hb3FYf5d4CAZKNOK+kbNbGoeh07yDvKW5deYscgEx3lrkEFKFOtRvRJqI5rSjftqPilwhAu+CpT46S0XYmn85q/SP/hG9JFVusX/CbEpzLt8RyEkujNpdQB6R1x1bFoHg4pDcroS9dxOUxdGWvW89ePIEFG1BDMCbtSPEuOP6tTojfmmBLDerKDPNGGLDdnsBfk6HBgOlCN+pHXr8j8Q6FQCaZ8NswTmf3JjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uA2TwovoS4NZ+YOENTjefhKY1E+NCftRc+hRCBEootU=;
 b=18HjR9y4H4avxpYfSLFgMgvFs4lAsjHXhYd9g1bfs3DhloJ8HhVTaVpFzS5cyE3FawvZx+dECvfkojK2qPKyNOml1TW0vTzwyEp4GZDYtmavYrH4jgx2MnjS97fIGdrkd1Az2QabjHOkAVS+XpKVRd+vUPm/UXv4MxUv5REEL2s=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 12:59:08 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::7140:d1a:e4:a16a%8]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 12:59:08 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     "Quan, Evan" <Evan.Quan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: RE: [PATCH] PCI: Create device links for AMD integrated USB xHCI and
 UCSI controllers
Thread-Topic: [PATCH] PCI: Create device links for AMD integrated USB xHCI and
 UCSI controllers
Thread-Index: AQHXoI2e5hBCwlRbskaRr8ZQ4rfisKuSuiqAgAYE1qCAAB1RgIAJsP4A
Date:   Tue, 14 Sep 2021 12:59:08 +0000
Message-ID: <BL1PR12MB514448B91AEAEAADB521F427F7DA9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <BL1PR12MB5144184FB2D6686C1B00ADE4F7D39@BL1PR12MB5144.namprd12.prod.outlook.com>
 <20210907173513.GA746796@bjorn-Precision-5520>
In-Reply-To: <20210907173513.GA746796@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-09-14T12:59:03Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=5f62342f-fb73-4e4d-9b79-c87079730117;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de8471d1-f194-45b9-e752-08d9777f70ee
x-ms-traffictypediagnostic: BL1PR12MB5334:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL1PR12MB5334A222455A8E8B46F449AFF7DA9@BL1PR12MB5334.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vj+b9mtUYMCApUoeRvCV9ATZG4f7bJeM7hnCFGq9GSg00aCs6oW5gngFG3Df6oMJpSribGgjmKrzSN2glvQG2qMZtjPY6rZ/wNoI9qCrbcSAYZsRz6RWIV7WYr810JjM/9GMynloWqHLaWf9JKRGcyItPmPXElrXTSn8Q6qn5CKrxOQbki7Z/wy+P/adMJ0Q4sN6B7U2ys6SlqSdw6RFkGAbeBI3ON2Y8Ivs+SAwPLXMlNoJcEBnWMnpkq9rTRmISmuKvRf/nEyYyEuxMfTHfRHMgcv+0Y1js01B3abkxElQYGb2aRDs/woYZLY9mPbfO4KJk+msOFoVWnqWvWUa1u2kU4ph9xAee/QfI35yExlSZgmRXcFNNExv60RQrI6yjE1eXK/zQG+OjJ4ZvzNu9JgYEENzhLReWF2dYo/1mah3KGZK/sQ+ou3OhnQJOnDM6PKUb3B50WZfxWyY4rNlYoiu28NbHtRUel1GUQV69gBlHtjkDCR/OOE6d9FQ1NvSntX4BYYVRkAs/pYn+E5FFlAULHLKrgw33I9YFavkDuZbYTpow3XWjlFsBqHIXDfvL9pcVkBc2jJ6rsmw7sLm2/ssmrQoXv8noIDZogYTtN8iN6HvzdtBmnhcO7KXqbIoL5+KUTZLTrI2uZ30QrvEY5qsrWoc/aznAFtgJxIzuaVCUWG0aNwDjlkAZCwrOIkv9myuLStZp2iQesvuPgqvqL26LPTu4x2gkfLzVgK4esdbjiUL64Ju7PflYWCEUpiXm6eDJDDAayHRMRyatVd6alIwf29oy/Rz41/C2suQSAWcigltK/ZpVlXY0HHYDztIdUkz4H6QS9Fn/Pik4bq7wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(66476007)(64756008)(66446008)(55016002)(9686003)(45080400002)(478600001)(86362001)(83380400001)(33656002)(186003)(76116006)(5660300002)(66556008)(38070700005)(71200400001)(6506007)(52536014)(2906002)(53546011)(966005)(26005)(54906003)(316002)(122000001)(6916009)(38100700002)(8676002)(66946007)(4326008)(7696005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?idEsQp57yTMYNABi+UkgeUlnwr5/J6fDmbJeEuhdSI6WMxGyjgj6s/sC46zl?=
 =?us-ascii?Q?rJ9/n/nxKJjUw5Pm0hbVumPRNb9lwDKqZPwK/dkvJ/holm22VKFMHLWjAhBC?=
 =?us-ascii?Q?yuO7Iet9Eng21lV+2rb+/Rd6TTn7bM+31aSFgb3BybATQOgGGXAcnFndFQtF?=
 =?us-ascii?Q?tj/+XHSyOMPjc0tJX1nxD/SfCbx1+b18Rx49oe3t162XQz8amkWmZ+KF2ZnN?=
 =?us-ascii?Q?V7V/OYXBR5f+JzDHk49JFORrDapRv/uheaCtoZBM5X/PICwhK/xfiiveIUXV?=
 =?us-ascii?Q?zValFAfnGh/3YIDVwtJvLaXxcS1HbrA7EwAS3Qg7EFh3Cpi1Aa3E2ptly0Lo?=
 =?us-ascii?Q?3P9+RiSsl1fQQxft/EPk4oyk/7lXt9FlfSXh6H3plxlNwL3NY5vMgt7dbbGT?=
 =?us-ascii?Q?ZOr+SDxiztIrG+MHhDJJgwpo1NkFCZJoAKqeIVeg18/1JPsfMxBBeBZLJah6?=
 =?us-ascii?Q?VGywNVkpN8v+bCaJ3pjK+eazGLXl+pWo+BQsGs1sCtLC7a0Ygj1vyb8+Gb6g?=
 =?us-ascii?Q?UspwGZP1Xr+vdiVDtyp7M+3OQqx+BXhfIHOe4ngwi5GgK1553faL64g7LB+V?=
 =?us-ascii?Q?fo0H0/z6iFDT5QepAQXTKD9X7+tYTdL2dzBu/EmHub/S/xEDhJ3PSBpsdsy+?=
 =?us-ascii?Q?HHLTrNjAeCt8thPllAlU4btzTDMnnD6L5XI4LMDk9YdPtz5RW7AIdbef962z?=
 =?us-ascii?Q?zydhrlKNuJSWi0I/ew03U6jCbhunw1DHWKeTZmo8iai3L8dpAmT7E8Mg3mxw?=
 =?us-ascii?Q?Zw2XN+BOIddZLj1L3Lmmbw131dKzG3mvVMpkaijkswfBKBv6avVx2jBteUJf?=
 =?us-ascii?Q?Vp3i3SrXcO41r/+7TKfhRf/HiYBUsNTHtsSDvkgpZULOi6tPCktJo54nj2Xo?=
 =?us-ascii?Q?p+A/gtGjdHOgS5FLtrLpdyj7luaoxRWFRpg9NBr8c1Y8IMJwAt+ZIwtPn9Dp?=
 =?us-ascii?Q?2BBUC9q/RI/lHX5zFWEm+83YF1rloeCM3BeIo4zEd794eP2qtjkzfmc0L5n1?=
 =?us-ascii?Q?kY3wSfBAJ2IcvMRViM4D5Dicldo2SCHHg7KnWHLVU1zEM4c7Vso+qu1nu1Y0?=
 =?us-ascii?Q?4s73vpufII95lcWEQec3ZNgyg3TAq7J/LgeO/66iPcnPJocdr8knXjf5tkzx?=
 =?us-ascii?Q?Licws4MRDuQYOem9hrubkQqMrDT/CTt20Ec2tn9x8lU4QodSmr9rwJkJ0t03?=
 =?us-ascii?Q?1bNRKje09BfCDBUwTX3R6ixMXk7bSxkv8IJggQaz9IL9L/Emw/ZgQNLxjS+W?=
 =?us-ascii?Q?8Qae7LRAcdVa2/Ts3D9ifX84e0FpDNfeSE6IvUNr/16ExFS+28rV8L9l3bZA?=
 =?us-ascii?Q?MldBiV0eMNnlLYOYYRugJ2dw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de8471d1-f194-45b9-e752-08d9777f70ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 12:59:08.7707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sNgJRdUWw1QlfNgTUyLHog7VjTJDiGJtY6dY1zysCJjNIYc37zR3K8yyFiFsyyh0FsrllgjvqZiOoElYQCW2rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5334
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Tuesday, September 7, 2021 1:35 PM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: Quan, Evan <Evan.Quan@amd.com>; linux-pci@vger.kernel.org;
> bhelgaas@google.com; stable@vger.kernel.org; Rafael J. Wysocki
> <rjw@rjwysocki.net>
> Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI
> and UCSI controllers
>=20
> [+cc Rafael, beginning of thread:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fall%2F20210903063311.3606226-1-
> evan.quan%40amd.com%2F&amp;data=3D04%7C01%7CAlexander.Deucher%4
> 0amd.com%7C48f3a6f7639343fcad6208d97225da95%7C3dd8961fe4884e608e
> 11a82d994e183d%7C0%7C0%7C637666329177869121%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C1000&amp;sdata=3Dk%2FgSHhtLiS8xS5hNkaP%2BOWWMWqiM
> 4tgQk4bybfumvfM%3D&amp;reserved=3D0]
>=20
> On Tue, Sep 07, 2021 at 04:09:40PM +0000, Deucher, Alexander wrote:
> > > -----Original Message-----
> > > From: Bjorn Helgaas <helgaas@kernel.org>
> > > Sent: Friday, September 3, 2021 3:55 PM
> > > To: Quan, Evan <Evan.Quan@amd.com>
> > > Cc: linux-pci@vger.kernel.org; bhelgaas@google.com; Deucher,
> > > Alexander <Alexander.Deucher@amd.com>; stable@vger.kernel.org
> > > Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB
> > > xHCI and UCSI controllers
> > >
> > > On Fri, Sep 03, 2021 at 02:33:11PM +0800, Evan Quan wrote:
> > > > Latest AMD GPUs have built-in USB xHCI and UCSI controllers. Add
> > > > device link support for them.
> > >
> > > Please comment on
> > >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgi
> > >
> t.k%2F&amp;data=3D04%7C01%7CAlexander.Deucher%40amd.com%7C48f3a6f
> 76393
> > >
> 43fcad6208d97225da95%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0
> %7C63
> > >
> 7666329177869121%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMD
> AiLCJQIjo
> > >
> iV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3D0yxZbS6o
> P56
> > > rXpA5j1wvlMpkp9Ern%2FcSRCPELtv47lM%3D&amp;reserved=3D0
> > >
> ernel.org%2Flinus%2F6d2e369f0d4c&amp;data=3D04%7C01%7CAlexander.Deu
> > >
> cher%40amd.com%7C9fa0d66e5f29424df36b08d96f14c710%7C3dd8961fe488
> > >
> 4e608e11a82d994e183d%7C0%7C0%7C637662957313172831%7CUnknown%7
> > >
> CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwi
> > >
> LCJXVCI6Mn0%3D%7C1000&amp;sdata=3D6IlPLWlcO7iptbTqfh71fe5wmHN7RN
> > > 13OvScyYaWyI8%3D&amp;reserved=3D0 .
> > >
> > > Is there something the PCI core is missing here?  Or is there
> > > something that needs to be added to ACPI or the PCI firmware spec?
> > >
> > > We want a generic way to discover dependencies like this.
> > >
> > > A quirk should not be necessary for spec-compliant devices.
> > > Quirks are an ongoing maintenance burden, and they mean that new
> > > hardware won't work correctly until the OS is patched to know about
> > > it.  That's not what we want.
> > >
> > > I expect we'll still need *this* quirk, but first I'd like to know
> > > whether there's a plan to handle this more generically in the
> > > future.
> >
> > The requirement here is that all of the additional endpoints are
> > dependencies for powering down the GPU.  E.g., the audio controller
> > and USB endpoints need to be in d3 before you put the GPU into d3,
> > otherwise the non-GPU endpoints will be powered down as well behind
> > their drivers' backs.  On newer AMD hardware there is logic in the
> > hardware to wait for all dependent devices to go into d3 before
> > powering down everything or power up everything if anything enters d0,
> > but this requires additional software setup in the GPU driver as well
> > and older versions of the driver didn't set this up correctly, instead
> > relying on software logic via dependencies.  Earlier hardware didn't
> > have that logic and needed software help.  That said, I think all of
> > the relevant drivers expect the hardware state to be powered down when
> > d3 is entered and they may not handle a wake up properly if not all
> > devices entered d3 and hence all of the devices never entered a
> > powered down state.
>=20
> I'm not sure whether this answered my question.  Will we need more quirks
> for future devices?

The existing quirks should cover all devices unless we add some new endpoin=
t to the GPUs in the future.  The quirk for the audio dependency was added =
years ago and hasn't needed to be extended since.  The USB stuff was added =
more recently and requires adding a similar quirk.

>=20
> You said "On newer AMD hardware there is logic to wait for all dependent
> devices to go to d3 ...," which sounds promising, but then it "requires
> additional setup in the GPU driver."
>=20
> So maybe PM works as per PCIe spec, but only after the driver sets things
> up?  I'm not sure what, if any, PM we do before a driver claims the devic=
e.
>=20

I'm not exactly sure what the expectation is with regards to the spec.  The=
re is a single power rail that controls all of the endpoints so all have to=
 be in d3 before the power can be cut.

> The above suggests that if we put some (but not all) functions, in D3, th=
e
> new logic will keep them from entering D3 until later.  That doesn't real=
ly
> *sound* spec-compliant -- if we write D3 to a function's PCI_PM_CTRL and
> then read it back, the function will remain in D0 indefinitely, until we =
put that
> last function in D3?
>=20

It will read back as if the card is in D3, but the power rail stays on unti=
l all devices have been put into D3.

> pci_raw_set_power_state() does this read then write, and it expects
> PCI_PM_CTRL to change to the new state after the delay prescribed by the
> spec, which of course has nothing to do with sibling functions.
>=20
> And if all the functions are in D3, and we write D0 to one function's
> PCI_PM_CTRL, *all* the functions magically go to D0?  That sounds
> potentially confusing.

The will all individually report the correct D state, it's just that they w=
ill be using more power than if they were all in D3.

Alex

>=20
> Bjorn
