Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8923A228294
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 16:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgGUOot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 10:44:49 -0400
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:60492 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbgGUOos (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 10:44:48 -0400
Received: from pps.filterd (m0170394.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LEdr51001065;
        Tue, 21 Jul 2020 10:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=casjpSSSWQa8F0tUjxkOK+Kj2EDuGX9LBCfJpRB3E54=;
 b=SOlbCWT4UuMeJN2s4rsiqP4CyElUSJx9+rPXfUP4PRKxeD+d/f5/8NRsnOX27E7cgicA
 Mamb024NDxLnH7OZzP79+ysnkdSBZv4aJtg0Z+td4JY/zn+Yozc/Kbyyyx4So7ofzcs7
 tb3jXXLGAQoRObDcpjIhpTSXtO3LrWVyAPF+haQyufqaiR/5PNBqP7OlIVnqqVHLUJUH
 YSI1Zfek0sUa3BSJCMQsblVyHKUT2cWrrUSBGmtXwsnqmJ1A7AFl16U2tkCyPijnje1R
 rB9HWPKL+Bln5U5e6xvWm7Q3AKyMftUHMibVS2k2PSlwlYbg/kR2y8oOx+0pg5cmylJ9 pA== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 32c1earhug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 10:44:36 -0400
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LEYxQi093980;
        Tue, 21 Jul 2020 10:44:35 -0400
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-00154901.pphosted.com with ESMTP id 32e241rddu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 10:44:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ovv4mbsbn+EUP/6E6sBBmnT1XYlKLL4+n5nfCbQ0EslBUgEuCBH5QxV4RBsScAGLEOchxN/sp/kyoXhikUTsAliYXF+x1tHhRRb4UWPup15Sx9eJcOyP8Zb+a768Jqtor+3NWa0fTMqpEkvUyP9wtyly8mjwUEJ/25FkzPOda6aIoyYu1+NQQKaj7cUIWWXT+DIj0w8Iv40BoWDS0oWBSOeamZVunQiM7vlBrdcYEnBbAUNTxecOupblX1VYn1BwUWyCDgla8IBiADOIpTbLbjeVqok9GR/WE86Ox0ytPOjD+3mm46HgzP5ncovrdsMcJfvtgwcX7Vy1rj7+2u6wRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=casjpSSSWQa8F0tUjxkOK+Kj2EDuGX9LBCfJpRB3E54=;
 b=RmdCgLOcWYua5fNjhwXUkbuBWmf9rJo71UYCdQjxClDtBwlEWtHEAfu7SmvpRHgxVG2jbJ7Zgg+ci64gW2uP9ogeK8GR/GFiUvTpnaPMgdu9eoyZjH8fZqGhkHuMUF3wb8g/fg4aKmlkxO6vaOml6Ta2O/wqgvI/yiW93egacbEzwFtQhvMjLh4N7CCMZSjGoNJG/YWjSbudRbjdeuya340+UNuKB8hqdhrUuzEwJnM8sCK+212YaWv81M5Drf5DNQyTH6bzJ/w9oW/v+b5L8ROL/ckadCV4n4LH7XBKL5ivHjk1/YeGiwKcEJIZmAWmwRQAlzqsw/2nwJdhu2XkcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=casjpSSSWQa8F0tUjxkOK+Kj2EDuGX9LBCfJpRB3E54=;
 b=Swkx8zvsIvCFIga9pfhPeNclhFqlYjnNIMOCGwxr32ac4pNxtOOo2mkyJ8mnRAODZDaxcKfZxYEmH+Ms/F43WpwJhvWkjAvb35l8PpiudLD40x44qgnaeoR5oOIZRaL2l/zZCQhN8RCqbA9LQnWRBQCbYKBlsdfXzRBgVUqhAzc=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DM5PR1901MB2118.namprd19.prod.outlook.com (2603:10b6:4:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Tue, 21 Jul
 2020 14:44:34 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::f1c7:5bf4:a3b:ff40]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::f1c7:5bf4:a3b:ff40%6]) with mapi id 15.20.3195.022; Tue, 21 Jul 2020
 14:44:34 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>
CC:     Ashok Raj <ashok.raj@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Koba Ko <koba.ko@canonical.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH 1/1] iommu/vt-d: Skip TE disabling on quirky gfx dedicated
 iommu
Thread-Topic: [PATCH 1/1] iommu/vt-d: Skip TE disabling on quirky gfx
 dedicated iommu
Thread-Index: AQErn65qGPIxx4/vDRlqxKGcSijyaKpnmsGw
Date:   Tue, 21 Jul 2020 14:44:33 +0000
Message-ID: <DM6PR19MB2636D1CC549743E2113C0EAFFA780@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <20200721001713.24282-1-baolu.lu@linux.intel.com>
In-Reply-To: <20200721001713.24282-1-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-07-21T14:44:31.6369253Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=7bf55830-b9f2-46f1-86e0-ced279ba7c8c;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f50924a6-a02c-4048-e17a-08d82d84958a
x-ms-traffictypediagnostic: DM5PR1901MB2118:
x-microsoft-antispam-prvs: <DM5PR1901MB2118E2E16EFAB4900A97BAF5FA780@DM5PR1901MB2118.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VsdpanehVUVAoCvalWFTA8bcXZKhzMCUChlDKJQaaJq5cvluzflkMPv7PnlI5LJ4IkVYA+3SO3dFkmT0EzY3uolQWL8w0hDy8Ch25GKFhK1/8VVngLnAjy+G15pTFZVxh7h6zIDVlRq+GXKN+tCJeN+Vh9RcJjQbMs/oOwQ0HF61AJ8KXxw2fFZ6NhpFAHJ9ibpc7eH4BM/Dgulkb3y3FSEMe+Cl4f4+IbzcI71Pd4Ij3r1RedSrEmCIwnZsZwitT9yGlmtUKGKc3D/OOdrNSkcGcoyrGgWgswEviCI074rFXZI/DWmUzmS6G1uMrJWXPJHAHJYOU3pq3KYqDXz2DEPc0TNzFPnKVwdAUTj06PIOtzSJqrliD3CbJpax/4Qc+ul20Qzdh6bFoBZu9ZkoCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(376002)(346002)(366004)(396003)(66556008)(86362001)(66476007)(66946007)(76116006)(71200400001)(9686003)(53546011)(6506007)(966005)(7696005)(478600001)(8676002)(8936002)(26005)(55016002)(64756008)(66446008)(83380400001)(186003)(4326008)(110136005)(5660300002)(316002)(786003)(52536014)(54906003)(33656002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SRmwm/UjfJ0aWryBn5yiNgywACLjxLxj5UzB157gEw1FF/Tughm79I8PD3mFtFo8rcKkAiXOkmBOjt787j4wIelnurfrnJTTGraqyjgi91fBrUTXggw1y7fxOt/ZW+wqIcTC98y78fbYypAyfUnYul6ZTRQyIjPSEkezrkfETSQbCZbbiMxWW3G0yvSW3abl+Yq7o7iE1JSVJwHPvGwcW2lkWztOyHBjBAlVI2Kid3BrV76zlTAqbP5FBU1n+kTE7OvYHTwBAhQusqK9KAyaF9Qi9IaYk5mnhlf6VeIm/ABSdZthFYA9IiErtIKstuMSfuIL0H+5dAi+3cbPTLRnJ5hFNQVHnhbayBOPOGdmbT92cM1cjU03+/CYLREOcWo4GskRYi5d2z2s08fR73fS8iRz5ty72W/FeuYG0q8OkHF26CS82lhSQG6NVxwwK6giobsFPehc3DK2nIIqSMx1CkWSgDc6LkEKQHFq+rYCreFn/531b5JfPxXvyb9GL5vy
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f50924a6-a02c-4048-e17a-08d82d84958a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 14:44:33.9755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 91vS9lzSEDsQ9980o9bjNVSKEYZ2nUycUFkWlLN0N4RsuuWU1OTzSoIX2KPAmme4jhD/dUzxq8HuKCN8lzbMIUUdsl7vX+yVCdHy4KKADiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1901MB2118
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_09:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 clxscore=1011
 impostorscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210107
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210107
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: iommu <iommu-bounces@lists.linux-foundation.org> On Behalf Of Lu
> Baolu
> Sent: Monday, July 20, 2020 7:17 PM
> To: Joerg Roedel
> Cc: Ashok Raj; linux-kernel@vger.kernel.org; stable@vger.kernel.org; Koba
> Ko; iommu@lists.linux-foundation.org
> Subject: [PATCH 1/1] iommu/vt-d: Skip TE disabling on quirky gfx dedicate=
d
> iommu
>=20
> The VT-d spec requires (10.4.4 Global Command Register, TE field) that:
>=20
> Hardware implementations supporting DMA draining must drain any in-flight
> DMA read/write requests queued within the Root-Complex before completing
> the translation enable command and reflecting the status of the command
> through the TES field in the Global Status register.
>=20
> Unfortunately, some integrated graphic devices fail to do so after some
> kind of power state transition. As the result, the system might stuck in
> iommu_disable_translation(), waiting for the completion of TE transition.
>=20
> This provides a quirk list for those devices and skips TE disabling if
> the qurik hits.
>=20
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=3D208363
That one is for TGL.

I think you also want to add this one for ICL:
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=3D206571

> Tested-by: Koba Ko <koba.ko@canonical.com>
> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel/dmar.c  |  1 +
>  drivers/iommu/intel/iommu.c | 27 +++++++++++++++++++++++++++
>  include/linux/dmar.h        |  1 +
>  include/linux/intel-iommu.h |  2 ++
>  4 files changed, 31 insertions(+)
>=20
> diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
> index 683b812c5c47..16f47041f1bf 100644
> --- a/drivers/iommu/intel/dmar.c
> +++ b/drivers/iommu/intel/dmar.c
> @@ -1102,6 +1102,7 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
>  	}
>=20
>  	drhd->iommu =3D iommu;
> +	iommu->drhd =3D drhd;
>=20
>  	return 0;
>=20
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 98390a6d8113..11418b14cc3f 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -356,6 +356,7 @@ static int intel_iommu_strict;
>  static int intel_iommu_superpage =3D 1;
>  static int iommu_identity_mapping;
>  static int intel_no_bounce;
> +static int iommu_skip_te_disable;
>=20
>  #define IDENTMAP_GFX		2
>  #define IDENTMAP_AZALIA		4
> @@ -1633,6 +1634,10 @@ static void iommu_disable_translation(struct
> intel_iommu *iommu)
>  	u32 sts;
>  	unsigned long flag;
>=20
> +	if (iommu_skip_te_disable && iommu->drhd->gfx_dedicated &&
> +	    (cap_read_drain(iommu->cap) || cap_write_drain(iommu->cap)))
> +		return;
> +
>  	raw_spin_lock_irqsave(&iommu->register_lock, flag);
>  	iommu->gcmd &=3D ~DMA_GCMD_TE;
>  	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
> @@ -4043,6 +4048,7 @@ static void __init init_no_remapping_devices(void)
>=20
>  		/* This IOMMU has *only* gfx devices. Either bypass it or
>  		   set the gfx_mapped flag, as appropriate */
> +		drhd->gfx_dedicated =3D 1;
>  		if (!dmar_map_gfx) {
>  			drhd->ignored =3D 1;
>  			for_each_active_dev_scope(drhd->devices,
> @@ -6160,6 +6166,27 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,
> 0x0044, quirk_calpella_no_shadow_g
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0062,
> quirk_calpella_no_shadow_gtt);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x006a,
> quirk_calpella_no_shadow_gtt);
>=20
> +static void quirk_igfx_skip_te_disable(struct pci_dev *dev)
> +{
> +	unsigned short ver;
> +
> +	if (!IS_GFX_DEVICE(dev))
> +		return;
> +
> +	ver =3D (dev->device >> 8) & 0xff;
> +	if (ver !=3D 0x45 && ver !=3D 0x46 && ver !=3D 0x4c &&
> +	    ver !=3D 0x4e && ver !=3D 0x8a && ver !=3D 0x98 &&
> +	    ver !=3D 0x9a)
> +		return;
> +
> +	if (risky_device(dev))
> +		return;
> +
> +	pci_info(dev, "Skip IOMMU disabling for graphics\n");
> +	iommu_skip_te_disable =3D 1;
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> quirk_igfx_skip_te_disable);
> +
>  /* On Tylersburg chipsets, some BIOSes have been known to enable the
>     ISOCH DMAR unit for the Azalia sound device, but not give it any
>     TLB entries, which causes it to deadlock. Check for that.  We do
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index d7bf029df737..65565820328a 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -48,6 +48,7 @@ struct dmar_drhd_unit {
>  	u16	segment;		/* PCI domain		*/
>  	u8	ignored:1; 		/* ignore drhd		*/
>  	u8	include_all:1;
> +	u8	gfx_dedicated:1;	/* graphic dedicated	*/
>  	struct intel_iommu *iommu;
>  };
>=20
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index bf6009a344f5..329629e1e9de 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -600,6 +600,8 @@ struct intel_iommu {
>  	struct iommu_device iommu;  /* IOMMU core code handle */
>  	int		node;
>  	u32		flags;      /* Software defined flags */
> +
> +	struct dmar_drhd_unit *drhd;
>  };
>=20
>  /* PCI domain-device relationship */
> --
> 2.17.1
>=20
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

