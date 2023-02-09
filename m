Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E1468FCD4
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 03:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjBICIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 21:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjBICIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 21:08:46 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A97869F;
        Wed,  8 Feb 2023 18:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675908525; x=1707444525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hq0qoSXBomXpAsshjH4I0FuSszufPqeMFTdcr0+LsKM=;
  b=KUSrUb+ratxHfEYthBJXsTUQKe9Nnc9SCqSAZRqTj/BW3bBzyuxWuEJQ
   43BOkTvbtv7CKdkX5d2SOnnLkVWB1eOLXo2kWFSW6u6XYpFIgJ5BhckAR
   qZzWj4tUZB2QE3OORJCpV6/3ORsJHETbQhZeqptEFDMkl3JUGon5FrbGK
   CnX3B+192q7HxhZxxF611Vbmxgu3X5mXfPXyqm933M/VOuWQ21yPEQm2b
   hb6POKHNd2DF3LHWE3znlOHG2wFE5oqtwij+nWpxADMZWFODk40pELikl
   0UXXaCx10ME6wzv1wznKjbT0fzJ1vmgKly7cQslir9OMDqU/BqAlaafoN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="332110579"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="332110579"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:08:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="756253047"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="756253047"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Feb 2023 18:08:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 18:08:30 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 18:08:30 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 18:08:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DrrwjnOOn2XDrxs4yutd5MIkrZ76C4Qh75B+FODn4cNcjeij1crAhMA1UWkZfqJRu3Rn6bRfIatZ4WVaXeEY4yYNacDDdDkChx+YNd70f942t2bhLG6yk/D6mZIGf98S6ykYh2geNKhSWaAm6GukQX2ySTvtydnqF4Rv/PjOM9Y0eZ8OumcjrQ3uzR72aAviRQlk0SHU2mBX/BbW+3itGJQHgrcs7ikFuuO2j4n7WTbNlqLzRSS5uvBqM/LKSpcpdor3ZmFEGkRReaVQKIMNV6vPYEMukmpH2JeSVXAAS6WYcR/cHGEtzXLFTLqXnCxK+HsRGeeO1GmPlmknqGWklQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7Ox0WN6oD+AUZ8Lbvu8nqCuu6KtJFZOUIyjyBpnHUs=;
 b=Vj6wn36PRLm6uYuiUtdEuX3CiaqJBSXF9gQYrgcG6nWGFsT3lvBucZ32Z5NEmNj51OA4IkfhuHefjVYhS3hiDIHIUh94UHF6quEWHLVT/MmpMsL5lJxhOtnpe0oQwOojzA9PtfQYDshXAKUiLJa/JMkwgl8UDJPSoFXDWQNe3+08lycYUk9S5EhKP3Mvv+MZHfOgVBtVKEvYbJ2rcWG2AXmd6dsbHD91wMI3ycMJrWoa5mdO0GNf/W3aIhYFhaR7q22xaVLyWSH3Gbb0n8+FjeDlbap5vqWkAS45oHZ+l5oNqfuBvlXCXaUI0xAf0Cg18KNvgGfexR66O5FkTnzeIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB4857.namprd11.prod.outlook.com (2603:10b6:806:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 02:08:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Thu, 9 Feb 2023
 02:08:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     David Woodhouse <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>
Subject: RE: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Topic: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Index: AQHZO+D4ZThepv5sI02CzOKy2NWtpK7F3sww
Date:   Thu, 9 Feb 2023 02:08:23 +0000
Message-ID: <BN9PR11MB52760B2BBE25C23EE445B2C58CD99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230208171902.1580104-1-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20230208171902.1580104-1-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB4857:EE_
x-ms-office365-filtering-correlation-id: 060d4f10-497a-4bfb-c5f5-08db0a42860d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FS9pS3NgmMPjHLErWcHqbIIIjav9/ZzkU/W83ye8TKeRkq4OhhhFaneEkpLetHTy0Rd5SFqVxwnilze5jb81SEEg9BkmgP8Zdvo8uSN6avAj+C59rvBzDiDKoYA3cA14bEibaMS8rHPAk/OkmAGt7/LC8JZLwPYHw63yb/jFutUbLAP5NqHuA1pmpn90mBzmR+E4JbdZtGEkElfbqGJoi3VzTtHmXG+/RuN8M13/hrR+m09+CjStKSofKtr8YCiR7r2bS2WlW75NbZAESs9W8/PlqC1+cd4FjATSjwBgKfVzsmVuO2/r95WkRKO3hWd1L10acggGezGHheQCBcNBpDG1UkENO6wpfFi1/8Ct35TvJxc4IOfYU86PI//8XNO5BaMFJX3DKUpSZvD0dEdH5G9Zr0BWkhwKm3Meq9MABD4a/O61/QZ2Vg5DvOzXeq0k3a5MsoAapYHK3mICnMTP0TXx2b8qPkrc9W9o07S7/ln+CJPMa9ckf7ZbAh98RwrJNy2trOcB03ti1PE1Fwb++60IzSDnFOdNhvebddlKWZ0Hxy5KMEcAsAKSehCTmIGy3qDk9tEXlDF2hnbc1CKHn/bLKI4Qn5ICYAHGYgtsuB5/FocGX4NEjoXeiVb3Vo4ysYAOhCubutXtwc/O+enoYTxjVY67+IG9iNZPq0hqlugBCBpMpS4meAMCtDDjfg7DAjVgylFEPxzN5vsCtDsTJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199018)(55016003)(110136005)(76116006)(38070700005)(54906003)(316002)(2906002)(478600001)(5660300002)(8936002)(86362001)(52536014)(8676002)(66556008)(66946007)(4326008)(41300700001)(6506007)(64756008)(53546011)(66476007)(9686003)(186003)(33656002)(66446008)(7696005)(26005)(82960400001)(38100700002)(71200400001)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+VlIrSl/Q2TC1D7H0ktTnt/K2+JX5Mm+Oa+xgoVvPN9xGsu5jEHcS2u9a/V5?=
 =?us-ascii?Q?mn/ifB6oJVJw6oRSwcYS0Cyphy3+Xqc1K/OVXIQTiaDHcE+e9gHMaRAjTac0?=
 =?us-ascii?Q?qCsPmB33BFWPyHrOq8aNH0MQ1ZLX2w1fjT+TGLrhDDBpepE0Pi3hKFEY2isU?=
 =?us-ascii?Q?/rg38hjWH1ulj0Usgc2SXadCViaPMXIVJlp2cU5FMfWaLb6i3IruDyJUVCPt?=
 =?us-ascii?Q?s+LnaDIHIOpGsoOPN3jF8LOcP3YG1iw7UbMvPgdGn99WEyJiurj3SujX4L3N?=
 =?us-ascii?Q?AsWzbZP7ZANzFm5T5lIvZgzKeq11zzLiCXvEurLjidfh/lxrUoT01C/5deZC?=
 =?us-ascii?Q?3n4UJHr0drWg2zXiKbN84JYHF+pg2C0Ajs3jeojpiu0mLaBqCfIL6ucEhak+?=
 =?us-ascii?Q?9YBv1sHrMhfVXSPHhtGujTi2kHLZPzdzx0yzUjq4tiFiSAX60lzfEYz+AnYt?=
 =?us-ascii?Q?TbdwSQR0HPRVoOD/2bzNEpezXdihQKT5R3n7XFy/+99ETKbbDCvheXM9fk+O?=
 =?us-ascii?Q?X2/rmH0eriJh9gkyIq1DKyJgE8W4e3ASu6a+ZMeu2b0OpOTF14TGhLSCOAoK?=
 =?us-ascii?Q?oy/Ni2dJry38KWemuLNaZb9RRRYELWgx/XK0/+oMb4c7FmBmwrXCOhR/pK02?=
 =?us-ascii?Q?LHvEa/r8In8TS6WyC24SicXO8vtKqeGY60b2DqLEbbgF34qAAl93zGeeB7iH?=
 =?us-ascii?Q?zCWvHEg3WJiph7ao/YIs7zp1+HbE6QJ0NCfzwtIor1AEXMY/q5ghymXh9ucL?=
 =?us-ascii?Q?AfY4hIqoxYe38sefH77YquOdNM9QgZo8Lzc4rQnH/EbzQMgmxhAsNtZo1jV/?=
 =?us-ascii?Q?cR6OobyEreU2EEePNM+vhDtC3Dof3VoXRbzqECD025YrdkBDxwgyUt4QZzW4?=
 =?us-ascii?Q?gtEzl3QDhDN77WH9C255EnctSTc4CVkn7UkWr0YNAJE0Mfjrc8ecx1Mld9nF?=
 =?us-ascii?Q?Hk6KdJCW7zn+od50ypTRh+rE+zBC6KT/XU6sNCUORvoF3dTDadReGZPL0f6t?=
 =?us-ascii?Q?50yXkuRPOp1DRuz/P1MxH/1J08dsl7z8xxjFo7OQlWyDAhr/Ez6FwXrGuf1a?=
 =?us-ascii?Q?+Egxo+c/P21lVpEQWY78K+RhO3Z4N9TXTSUYvVtikAzHsX8wz9AI51HAjL9N?=
 =?us-ascii?Q?pnN8r3hz1Il2d0DYqrbR0bYAE5i3J9Mg1d7VelluHe+rTfvf9d3TCOFzKSI/?=
 =?us-ascii?Q?O5i3PesBHlckE+cFXJYZ8kHlVd2LO1Qg5TkN/YFdQlQiHtAxqjHngok0ErlH?=
 =?us-ascii?Q?8qnAc/goNrG1lM6+N3ED82PIYDLYgEbgvNINcB5GTA6+nKaCuiMBeJJ1IDGo?=
 =?us-ascii?Q?SglKEz35iE9FGjC54NZWLvBxe9d9GeiN1LMQu40Rk0AI0jmEN8W1HcX8b4Kf?=
 =?us-ascii?Q?22NPolKcm7v+Fpur7kflnBUQvm8S1Yd6WAK9nqAWWhxAH+63n3Z7IbNa8ASb?=
 =?us-ascii?Q?sPFYEdswGKG9VX0jc7YW2H6RgaAYaBoKh6gzRVlYNuP5i35nLMVbGLT/Y5Lh?=
 =?us-ascii?Q?Braj9XUmgG1YlVoX4rAUPYgdUYM+AUTyEXsVu1UMjRFbO95zpkwv5n5l4Pl7?=
 =?us-ascii?Q?LBp5tw6JLJZJXfLmKYR23N4T7lEpEGJidv36CFeZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060d4f10-497a-4bfb-c5f5-08db0a42860d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 02:08:23.6069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O3XoxmJP9f1v9G7j9TSEc0ny9q9TPcRxhBcVoFAan1lJUkF8zkEIj0UtDEE9rt5+vEArQNzoWPtI96CsqqxPNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4857
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Thursday, February 9, 2023 1:19 AM
> To: LKML <linux-kernel@vger.kernel.org>; iommu@lists.linux.dev; Lu Baolu
> <baolu.lu@linux.intel.com>; Joerg Roedel <joro@8bytes.org>
> Cc: David Woodhouse <dwmw2@infradead.org>; Raj, Ashok
> <ashok.raj@intel.com>; Tian, Kevin <kevin.tian@intel.com>; Liu, Yi L
> <yi.l.liu@intel.com>; Jacob Pan <jacob.jun.pan@linux.intel.com>;
> stable@vger.kernel.org; Ghorai, Sukumar <sukumar.ghorai@intel.com>
> Subject: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
>=20
> On platforms that do not support IOMMU Extended capability bit 0
> Page-walk Coherency, CPU caches are not snooped when IOMMU is
> accessing
> any translation structures. IOMMU access goes only directly to
> memory. Intel IOMMU code was missing a flush for the PASID table
> directory that resulted in the unrecoverable fault as shown below.
>=20
> This patch adds clflush calls whenever allocating and updating
> a PASID table directory to ensure cache coherency.
>=20
> On the reverse direction, there's no need to clflush the PASID directory
> pointer when we deactivate a context entry in that IOMMU hardware will
> not see the old PASID directory pointer after we clear the context entry.
> PASID directory entries are also never freed once allocated.
>=20
> [    0.555386] DMAR: DRHD: handling fault status reg 3
> [    0.555805] DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault
> addr 0x1026a4000 [fault reason 0x51] SM: Present bit in Directory Entry i=
s
> clear
> [    0.556348] DMAR: Dump dmar1 table entries for IOVA 0x1026a4000
> [    0.556348] DMAR: scalable mode root entry: hi 0x0000000102448001, low
> 0x0000000101b3e001
> [    0.556348] DMAR: context entry: hi 0x0000000000000000, low
> 0x0000000101b4d401
> [    0.556348] DMAR: pasid dir entry: 0x0000000101b4e001
> [    0.556348] DMAR: pasid table entry[0]: 0x0000000000000109
> [    0.556348] DMAR: pasid table entry[1]: 0x0000000000000001
> [    0.556348] DMAR: pasid table entry[2]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[3]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[4]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[5]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[6]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[7]: 0x0000000000000000
> [    0.556348] DMAR: PTE not present at level 4
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
> Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> v3: Add clflush after PASID directory allocation to prevent malicious
> device attack with unauthorized PASIDs. Also flush all the PASID entries
> after directory updates. (Baolu)
> v2: Add clflush to PASID directory update case (Baolu, Kevin review)
> ---
>  drivers/iommu/intel/iommu.c | 2 ++
>  drivers/iommu/intel/pasid.c | 7 +++++++
>  2 files changed, 9 insertions(+)
>=20
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 59df7e42fd53..161342e7149d 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1976,6 +1976,8 @@ static int domain_context_mapping_one(struct
> dmar_domain *domain,
>  		pds =3D context_get_sm_pds(table);
>  		context->lo =3D (u64)virt_to_phys(table->table) |
>  				context_pdts(pds);
> +		if (!ecap_coherent(iommu->ecap))
> +			clflush_cache_range(table->table, sizeof(u64));

this is not required if cache is already flushed when the table is allocate=
d.

>=20
>  		/* Setup the RID_PASID field: */
>  		context_set_sm_rid2pasid(context, PASID_RID2PASID);
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index fb3c7020028d..979f796175b1 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -128,6 +128,9 @@ int intel_pasid_alloc_table(struct device *dev)
>  	pasid_table->max_pasid =3D 1 << (order + PAGE_SHIFT + 3);
>  	info->pasid_table =3D pasid_table;
>=20
> +	if (!ecap_coherent(info->iommu->ecap))
> +		clflush_cache_range(pasid_table->table, size);
> +
>  	return 0;
>  }
>=20
> @@ -215,6 +218,10 @@ static struct pasid_entry
> *intel_pasid_get_entry(struct device *dev, u32 pasid)
>  			free_pgtable_page(entries);
>  			goto retry;
>  		}
> +		if (!ecap_coherent(info->iommu->ecap)) {
> +			clflush_cache_range(entries, VTD_PAGE_SIZE);
> +			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
> +		}
>  	}
>=20
>  	return &entries[index];
> --
> 2.25.1

