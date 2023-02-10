Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98DD69163B
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 02:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBJBaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 20:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBJBao (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 20:30:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099855DC0C;
        Thu,  9 Feb 2023 17:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675992641; x=1707528641;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S6QUHihsPdVAlyxuY7m8FeZC91TjCAjbx71lERsS2ug=;
  b=OX+tnmX5UQiZNegYxvbiQpUBZ5JajxR8KFZW08Z9xXImjyLcSvGCdJ9b
   2bFei8ghsPD3tOWAPeoiR+AM2zUcA244MvjCYadNTtcazLKzKnvcz81dW
   NDDvyGkbU2u2jup0c0g+oM2zVzCfj7iZnCNNvyqoCxERp+z0BIjt5rPgO
   bFGADYoa9etDzOxEy1Ns6k1q9SHulJqYXZIu8+XjCrnDslB1TEj5sQD7j
   kl5SZUgXuVTOR6eDUm/lAMMRZfkXay5ksyAyFKy1GiPHhJmkwIckF0KZi
   XpDzHFiCxivm3xRGgiguip7+r/qMMcHB5JSTLrct2kM+nEHTvk8bYIPAl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="330313689"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="330313689"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 17:30:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="661228841"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="661228841"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 09 Feb 2023 17:30:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 17:30:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 17:30:37 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 17:30:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JG1iniTNFp1nB/TjQr1fBCUS6+aikOt+kT9yTTA2cnCWbocu1jHODCzcHpHnGS7F1UW8bbKaVUoOLvGnSrgmmwdzRurHRMW9sBw64QKzSk65oPNQl1IiwMlHGSqy/IEtnb84szi0M/fZxcUvKSqgDr3iBPhdj4E5v8XNZQyNEdG3q3K62vLaJkGSsOz0foDAjs5AWhRXWexFaNH4mfa1IHNW9ulUVeLlMRPr6vLnbHpCF8kW5gEvPxE1taIB807V3jaK8WaLYaRadijqqzSfFtwXh10OiJx2x9bAr0G7GCCHuJRVdrJw4gooV0uGdFV1ix2PCmyGxitCuj5JMZyIyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lz/RsdV07YgD8jV+vp2rBhRWYymjePrdHoYstNLDkEc=;
 b=a1C8El3NUur9GTpjqEYXOIXNDQ7YN5Jn+XHeL5dH8vq6VBuWMJB1lq73l9tDoR/OukmS2F2sExAXdSlzEgClkr1QnWC09YEX4ueHnIA2DA+On0tqfA+fiyGwxUum7+81fLnWDT/SsyD3VPo8rwoHGtvfWIyXkR98agxAn8FMXINPJPcupnPM9RpVH2u1r2xh52CGrnlHh/kaZsf3FkyCXdJdxsIuTLMR3Fgxh1kKu1mIFxTSi+sLuHpUa5vPE4fzGxD9M6CXHZbuObxQIjbHPhh0rnwbneZ68McJKcxtvmef7obotjR81FNbTDRyEnm52yOPX78jsSnILy/K9c5ULQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5462.namprd11.prod.outlook.com (2603:10b6:208:31e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 01:30:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 01:30:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>
Subject: RE: [PATCH v4] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Topic: [PATCH v4] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Index: AQHZPM0BbN/jZBC9yUC28xpWD6oiIa7HZNWA
Date:   Fri, 10 Feb 2023 01:30:35 +0000
Message-ID: <BN9PR11MB52766B2EBACFEC8DE3CE4A9C8CDE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230209212843.1788125-1-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20230209212843.1788125-1-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5462:EE_
x-ms-office365-filtering-correlation-id: 95e60462-b360-4c71-35df-08db0b066860
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dpDWvRhDKH0DhoDJjWpQnGcz3vb6fuh75bSRMRrna68StNbJ83VxJzVWBxMFyqcbsJcmuke7uZS/2b2F2EoPUxLi0JCZQpYmQG3grfK9ecnYS+UR92ncUwvX5CJvw8iV2GXrXw8NalObWw+sMC34cGg7e0WNdoJAyRN3oo5wYFmnwTjIHReMqaMLWNPemfq5NZm2erM2A74W8sTz8IbqWebyHmJvk7NxVYoTySBPxcVi0cWhYvbiOBW9rltGUUASCh8Vkwgu0HRDa0M+nG+OqRHbPn1cew9gmyx0H9w+31kL+q0VEnyYpqb9Iqyg/AITuJyPamDra7laU2N0vtKpnwlur44NEtXTiSrVbi36OIONr1LsfCKARlNHGJOLlQ5W/8axRCbJYJRSJTcx19HYt3lXnmy+H5cFjimOK+dq18qQ+PD63ijkyQSIl/Psv8T4TGdPJqBkUOO1pKmhp9LjpSO4Xez6YJHUUERkJgkwp26ylFi3WfRGTGvBA6vTkEwhEgSwTr1G2Tz6JddhniSpO1fsyCDjH5w12sEpxKVsPcKpfsTHdwSPHH+HdUd00hJi5WBjit2CDYRch/PUAKaIUzVQhA5WybliS9qThH1IG3IY+3EGeoeXl6/SqPSbFXSvG7CEv5Ot+Ozr4OZg9V4jfH8e4uH/jQLDcCFzwu7G2fE+GhAHIQQ9TZdu9uibpsI+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199018)(83380400001)(8936002)(66476007)(8676002)(76116006)(66946007)(66556008)(316002)(64756008)(54906003)(66446008)(52536014)(5660300002)(41300700001)(110136005)(4326008)(478600001)(186003)(9686003)(26005)(6506007)(33656002)(55016003)(38070700005)(86362001)(2906002)(38100700002)(82960400001)(122000001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JK9B0o1+hkGnzxzmSmN7byO1z8/Myit8h6ilgH1GIQ7MgaCCWJCw7ES3iP1P?=
 =?us-ascii?Q?Ra8Ag95Uh5VlGYJx7/HtNNDm0PxsA4TwML/HaySXZ/uIg4vg5A1hMLZqOJX7?=
 =?us-ascii?Q?zM89knLR8COSeU9yDaC+zXDKkVMQOEsHxakDwcbSjTW153DG70NIE9/GmJIT?=
 =?us-ascii?Q?xZtF8gSSddcHCOToJnP7DtqWDMlo35b0yi75ahSqD2ElCRuatkAp5vvKwrIg?=
 =?us-ascii?Q?KRHB+7yMb5JPWAlJ8v+Mc+4xWo7B9NH+aAEjVxiN4S8zfBuBGG2TMY8IV8OY?=
 =?us-ascii?Q?0IfXntTMHo3SlZy//4O3MBQpw5SkPpSQ6dDGQ+fFAp4BWlUScOM1O4zYnXl7?=
 =?us-ascii?Q?ZsSqjUrOqynxS7Dhs4U4uTJPKIu/D8lXluQr7cwT4rR8JWeV/0il1zW1Jg9b?=
 =?us-ascii?Q?XcV4BNuDrNSLeVKCr6LeLcOfuK85qPAYky/3oi2IAiJhfGjrw3mMvJPN2M1w?=
 =?us-ascii?Q?gszb93elM30V4jMAxYjHTGlUORCZMHeM3+US6G60UyLlgAPfIM1mxA7OpW74?=
 =?us-ascii?Q?niidqhslQD0FTQrtQAHurPpEsaMk8ZzNlKv7Ru0WvUPJeuw+aNOBbzIc6Ocd?=
 =?us-ascii?Q?Y474UqbOXBXhZMY3dYBThyxH96lTXvIKViXUIBSHukymlEANOqgX9NMgNP0w?=
 =?us-ascii?Q?rENN7OJhGw4OjTkBknfhQw23391OS/Jz6kYO/6/oWi0TEfbkxjKo0jOn4Eju?=
 =?us-ascii?Q?5R9bgU9Q+gDg+hI2yF4O4icXMt+BQhQmi9PuMHTcX/FDtDUvz0ldbf/b9z+d?=
 =?us-ascii?Q?lOtMj6Ief2df11hK8g7W4XuleGvoggIHFEuN8JANseMdGjb0NVaAcKB9fD9C?=
 =?us-ascii?Q?2lFhTTyw+lvLU6IvZiFJH4FU9Z+ka0GTJxu7EHE8LPd6qaWx9YuPPs4M1QdL?=
 =?us-ascii?Q?OIspCf7UEYEMjnz7Q02l3u0zRxzRUasYw4tnIM3QvJH4wFDyMF/tYgKe4J2j?=
 =?us-ascii?Q?hl6bkDjj46czjv+nSzlwkj72yR5UjeMd6RQYm4mmpNry5uIBDvGnq8uqmFlc?=
 =?us-ascii?Q?AOByF+t4zIKreMApEu02BlhB71qXfOr+v+mMb7DEr1ufo5fgdZ3Fn9G875Co?=
 =?us-ascii?Q?0k5myx5CJPxmu3Lt9JeVhIKBuINjmPWbcY1HWbR+zElVDW4SAM0846nnoZ5+?=
 =?us-ascii?Q?JvwVSAeqfIZ5rrDUdLolSahfuJo+bKHs9/osymIOJW1DX6W+lSGOnguURBx8?=
 =?us-ascii?Q?fmf9pIxTfjBMoj12P2/TldL+Esi/4o0SdYRyA9X7KJ1Y4rEDmvJknK36MbpK?=
 =?us-ascii?Q?KSrxc3tr7Df5WrC9AWBSjcrcG1yw1NB9+cpfnxWsPfW1T3bhQXWLXpF5TmLC?=
 =?us-ascii?Q?AUrCDlb7ghaTnt0b2xsOheD0fGuezRDz7h5wFwwNxQTtFmp5Jc6oHJQLezs4?=
 =?us-ascii?Q?X2sMFLG6Rf4oQIi8Wh2gSuK4+3pUHckmzFxPoaSkZ75GvhDL2L9shhzuWXpj?=
 =?us-ascii?Q?gQzS57sOV0DyR+60Th5ix92XZXpOcXbbo1rFiup3aQKkr7EkqgPXR+GDXZb9?=
 =?us-ascii?Q?Qg2UHuBNjvL5G5fBj3fla1S3g41ALBKkCp8I2rZgdQrGYwtPglw2WwmRkFMb?=
 =?us-ascii?Q?ABSdlf0aNXm8nGTOvqYd0Ov6i/SLFRl58FSoWTuU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e60462-b360-4c71-35df-08db0b066860
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 01:30:35.1745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T/7Hx1BiJRBJ2MuxAoNtADtgZJAG9oRwHqC2bofI7/VBWisajengfNWfOXKBh89VgZfLL8N8zYTDJRaBnCXgiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5462
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
> Sent: Friday, February 10, 2023 5:29 AM
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
