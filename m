Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBA9598022
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 10:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbiHRIc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 04:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241660AbiHRIc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 04:32:56 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F12B0299;
        Thu, 18 Aug 2022 01:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660811574; x=1692347574;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7xhdMMDhdxU/9N4zScusa7V+Zj0/IEGC9dBmDwnnfeA=;
  b=PJEnUgrHI0OgAaTZGRlN18WPDsE1VHbjiW99D3u1L5dwcRnXFiv8wask
   vExK22zGU1AfNjDkz/6X6sERVWps90ffRr8MXeoThFhIaFZXfJg9ewwTn
   rJ0W8LS8fEkECgKY00zs3YnY41cfHapdWiYdFIDBkBzrkmSva4AD6+8cx
   xzP5sFoS0+e9zAvOnN18YY33bBgRXV1e29l4Iczec/0gjY3VyW/4Bcs5S
   ERICGaxgAhgMe1X2HseZJtCq4QoApu7V9h91ui0No3v9D5oaYjLvLHbzM
   k/yWzS3ApjPX3WbtI5cU+6la9l2J53aOLqJe1oXnN8h6xW4OX4lTGhZpf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="290268174"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="290268174"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 01:32:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="668007979"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 18 Aug 2022 01:32:52 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 01:32:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 01:32:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 01:32:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7PkmZ1aqK+h3690qaohylvhDHkOcv0vTDY8RiMRQeRvSC3BVy/akon9xAk7r0oZPPJnWgXQ4ZbBYEYrjPMtp/+H15eJUjVvUACAxW433XyDmsRdg1oQNfyLt9s+phzMOsjZ5FtiaKIgfy1Axio78jSHPcQ/9FShnF3m3mdHNvqKVo53ZjIm5WYLZJNFDxmwnaIwLWI8LKvGVhiUUp8r66ofTnTB3LmpIeAU16hOZCy2mvSzRuPI5YwVLJhV1V5FQS4tn86vPNdbu89MugWGze4QN6uZIoPfndiGplonSD9JAgHeJVP3kuTXYJOYWT5L1QZevY69108UICumNeILow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sp0g3ZCCv2LJvmR7JHIyVbzr+kn1FHHsbiD4NXjmA4o=;
 b=EfKjSx9cmbTpvf64w/mJm5tPAqxPRVDTTKrr7eXqNKFyaEaT0KLdfA5JJd3SQ2fJ56YI7U6Sz1YTLAgAuwVW/QB9nJecFOg+0uWcvYaZED3WfxzwqAk34J95L5bETtCDKKT0HYo4SgHqCUpOIz911ljiU7nTiZcX66R2o/c/Ztimfxo2NU7lknb5DWHPzsMfMtBQD49qo8bcDF1ZcCcoPnOWaVF4jJH4osLdwGp3mzPcsBYYb87uJuFQN6EddmWjgdLqBFTtM5C/QlVwsBaoOAAxXZvuNmeiQfH3D8T+WNoFW+TWNMWGGoQk/mnCJ5HJPDIK0n100+uhgJraZg/6TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR11MB1612.namprd11.prod.outlook.com (2603:10b6:4:b::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.11; Thu, 18 Aug 2022 08:32:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac%3]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 08:32:50 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        "Jin, Wen" <wen.jin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] iommu/vt-d: Fix kdump kernels boot failure with
 scalable mode
Thread-Topic: [PATCH v2 1/1] iommu/vt-d: Fix kdump kernels boot failure with
 scalable mode
Thread-Index: AQHYsdbqBbnHsu3lH0ihB+4y7/1Txa20VRHg
Date:   Thu, 18 Aug 2022 08:32:50 +0000
Message-ID: <BN9PR11MB5276364739832848F15932B68C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220817011035.3250131-1-baolu.lu@linux.intel.com>
In-Reply-To: <20220817011035.3250131-1-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c42a760-4ac7-4d62-22de-08da80f43c97
x-ms-traffictypediagnostic: DM5PR11MB1612:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nt5N4DMI2WszZqBo81f0D79dujsrF7RN50AanQ6FjDSMalH4b15GF2SW0UUEGEF4L06+iY1BPdAPkpQoJmbTUh6syy9g/Om79rlENNR/ZCQAK1mFNqKLd9OEzEMm1aj2gLlejXl/BWKjjzGpI0eSHet1izdxoepI9PwmJAjYRCrY1ypY4tnVQxdmmvlvZJMAs9LJuOzZPc6OlnE6RNa0FBtlJbvUdD3K6NqDoE6fQDbNvLEYLO1FEWCr/uhkWz3HLtzY/dorlYMNtblXDC81woa1WzDdrBlquBX9P7VmG/3kOm4HRGPX6WD6Oaq69ssLHsYTWPerHdbR7BixRdH/hgvcutdyCylNkgX13OhatgChBhoHN/pL6YY/retI5+mF03jj1CceKRnf/ibrucWhTd+Sp35hzvDd+PNy2bxsB15uj/EGRkz78fTwqJHBQftUYpIohAnVV3vtNdkTr7wedZ3quStTyj4ch86BV6/DWsCSksfgm+VeOp/0OfUYmOlok5okTS1EjakXUazONWxZCHBT4Bx9zAb0r17Ls3YcjCksPCSh54iN3Q5GaWdvWfxd/JmdMcbbPgdonzD+3dkQwN4JDPqCeXY0EnyOU7VXo9+nI3OPpBW4qs1n/9mMbbH+XlbKlRBw7c76vA+yg+JrmpPKHnq1klmQDSPSD1sKOmJInEViESB2csR+bijSMb9P6lr8/yYbuyoNleIO1MFm8brfkxJZoyQt/d0L66sHNs6zzCot4LXQcRAAqe45No3QIVCOeRB5cEKoJE1kQhxtYXWsk2x/WqA6XmeLy2OgRCY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(39860400002)(136003)(186003)(2906002)(6506007)(86362001)(41300700001)(33656002)(5660300002)(52536014)(38070700005)(122000001)(478600001)(7696005)(9686003)(26005)(82960400001)(38100700002)(110136005)(83380400001)(66446008)(55016003)(8676002)(8936002)(54906003)(66556008)(316002)(66476007)(71200400001)(64756008)(4326008)(66946007)(76116006)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/35GeQfhz5peds4Qz8YuCeTEl2YWFDMBV76y5niTinE87iNnkcG+jbXFM+DX?=
 =?us-ascii?Q?lh2+L+z2dRkVIyjNYzrhjbLUcl/LRy+BwRIDbKuEb6t8kUm8n+ws3N8L6aKR?=
 =?us-ascii?Q?faAYhz7ZW6/bAuWDrqVjyIyxL9s/gsylFdFa/HGMkXM5sKL2HgLY5N36WnuE?=
 =?us-ascii?Q?nBM9pJ56mjku3wBjrDkB8tP97peAHU/H8iAr4aiZcryR4rpwoIvDmOHxAOVF?=
 =?us-ascii?Q?WHg5asHRNOgtqWSp+X0AzNbxkRgV2a2+vv+lXTqAYkO9XNAi0fIEEZoR1J7J?=
 =?us-ascii?Q?bvxYaFI0ovH8r1Acsq533FaPoXA2IXWdkBefRb0h0rx4aLOLX7hjDOuiX8w3?=
 =?us-ascii?Q?g1Xhy/5MPam32S4cgRSyQKimb8+DFaNJ2iyY6pDhAkavduKng/TZlUTFjcwa?=
 =?us-ascii?Q?OhnWWdEcVcjwSTZIE0whP1ex4H7qy9Jq7pY6ufGc5nlqRdHJkci0d5bUJAS9?=
 =?us-ascii?Q?3v4oPWgMd2vqoI8kxcEhSAnXfq4L9QD3RlArdkZskFoWoRleU1Zrr37sUvCb?=
 =?us-ascii?Q?de4QlpNJylv517kC3PoDeyHgs6++BLrnKdZgGbfJqzPaVbGpYr28qSdDS2qA?=
 =?us-ascii?Q?iJAOf/5VVyFD61hkkTLfv5YqDYMUeeL6rPFW9H6IAAokaojWAq+/1cmx/kW9?=
 =?us-ascii?Q?I2TNUvVTQ6SjXzoO8VuE616s3yJ+2IN7uRoMtw4NpBAvAzAVVVteflMq4Us0?=
 =?us-ascii?Q?h7xsqmzFK4/FonaIWHIZKGx39qeAXb/7EWb7sXCVvieXVNW0olDLR9SQf7uf?=
 =?us-ascii?Q?vJQL8cROXIvzgNynQ1kq+sTGtrgorP4ZHi46ckAf4BoeADpTlA1DBUU5CV1v?=
 =?us-ascii?Q?hN7dNivwmMxpsF2kzFYhfaAbFqx0oDmcagt5qk88i11cMi6vDLdtJPfocBhe?=
 =?us-ascii?Q?od8sWOOYXBsnQ6dJE8RPGifgeMbCxnFPFb58yzibkoyiJZwa2UO0uWG3pmHZ?=
 =?us-ascii?Q?igVHAu0J9Y9DyaiYhhJhNfDtbYFIJvZwSV62UUA5igwPnBV3jxHjTY5a0sBe?=
 =?us-ascii?Q?BqpF9AhxHkBUVPttGcA/gEEgPLW3CdCQfSYG1vp9POOi6r9t5o8LKIofg8DJ?=
 =?us-ascii?Q?a413QGY5vo5b8UykjaPsL1bYdWGS0JWJm0tUaNPk6p/8TIHSaWssKg9jznwV?=
 =?us-ascii?Q?8RmQyOTnfJFfc6ZyWNxp1CretTeox+NCEisNN5xpLHT5FouCR94acnO8Xt00?=
 =?us-ascii?Q?lZUb8cYVRMZereoZC/U8EComsDJ9zKbBF0/tdaXCYWE5tGW517L1cQVD0WLm?=
 =?us-ascii?Q?HIBboFDaklHTo2bEWs8UgyY1L9RdpCKxgz661GSzGzi39zxJ/fa0Q+0eVell?=
 =?us-ascii?Q?LTrF9jrGm1pPUVgcSEbzJoOrGE5mbNlSCSZGn90yqxhgruLr7wkjAC5PDjUf?=
 =?us-ascii?Q?luYRrM1jNO8bfjsIAgy2SJKjpxkmvn3rTLgQXRtaoBZ1Ubcw07+8uTDo42n7?=
 =?us-ascii?Q?Y8WOXRrdUPciNvMEjl+6k642g4iCEcK4SJYnMOOp5tb1dHSIbSv8X+QJLuqg?=
 =?us-ascii?Q?G9EWj6S/q7e2niH+qgGqtiTbPo43CmYx1A9jBY+AZ6fBZ8w/CzyAv9TYI2a1?=
 =?us-ascii?Q?xHFbOgU7HW0wv8yZRZ1xV9pBCYG/H+mxf3qOrr7v?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c42a760-4ac7-4d62-22de-08da80f43c97
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 08:32:50.3103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0BKmAD660/cnUTuOJ53Ld2ET5E8YqMVW+OfYmmMgQPDgRc8+dx1XdhWms93xB78K2QqBxoc1PRwMM/XAP5oO/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1612
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Wednesday, August 17, 2022 9:11 AM
>=20
> The translation table copying code for kdump kernels is currently based
> on the extended root/context entry formats of ECS mode defined in older
> VT-d v2.5, and doesn't handle the scalable mode formats. This causes
> the kexec capture kernel boot failure with DMAR faults if the IOMMU was
> enabled in scalable mode by the previous kernel.
>=20
> The ECS mode has already been deprecated by the VT-d spec since v3.0 and
> Intel IOMMU driver doesn't support this mode as there's no real hardware
> implementation. Hence this converts ECS checking in copying table code
> into scalable mode.
>=20
> The existing copying code consumes a bit in the context entry as a mark
> of copied entry. This marker needs to work for the old format as well as
> for extended context entries. It's hard to find such a bit for both

The 2nd sentence "This marker..." is misleading. better removed.

> legacy and scalable mode context entries. This replaces it with a per-
> IOMMU bitmap.
>=20
> Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID
> support")
> Cc: stable@vger.kernel.org
> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Tested-by: Wen Jin <wen.jin@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
...
> @@ -2735,8 +2693,8 @@ static int copy_translation_tables(struct
> intel_iommu *iommu)
>  	bool new_ext, ext;
>=20
>  	rtaddr_reg =3D dmar_readq(iommu->reg + DMAR_RTADDR_REG);
> -	ext        =3D !!(rtaddr_reg & DMA_RTADDR_RTT);
> -	new_ext    =3D !!ecap_ecs(iommu->ecap);
> +	ext        =3D !!(rtaddr_reg & DMA_RTADDR_SMT);
> +	new_ext    =3D !!ecap_smts(iommu->ecap);

should be !!sm_supported()

>=20
>  	/*
>  	 * The RTT bit can only be changed when translation is disabled,
> @@ -2747,6 +2705,10 @@ static int copy_translation_tables(struct
> intel_iommu *iommu)
>  	if (new_ext !=3D ext)
>  		return -EINVAL;
>=20
> +	iommu->copied_tables =3D bitmap_zalloc(BIT_ULL(16), GFP_KERNEL);
> +	if (!iommu->copied_tables)
> +		return -ENOMEM;
> +
>  	old_rt_phys =3D rtaddr_reg & VTD_PAGE_MASK;
>  	if (!old_rt_phys)
>  		return -EINVAL;

Out of curiosity. What is the rationale that we copy root table and
context tables but not pasid tables?
