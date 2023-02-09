Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3123690F47
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 18:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjBIRaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 12:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjBIRaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 12:30:16 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765BC68ADB;
        Thu,  9 Feb 2023 09:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675963807; x=1707499807;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zltXDZQkBoIwdwAnrkKsTdfw1uXH8CqLZ7ZzMVQQhRE=;
  b=Y847sN8+Oui4Dw1ZAZFBebmOkc/Q1WFlqF1hSIMZ2BvYgyAq69qC3r+g
   X4IqtvSn53MirNgJyvGRJYvq4um9QShM9/CXLNZeWxByGhEpJe2021ZjP
   UEKf51jGboV+RMtr+PXf9RWXQS5kOc+AYMzSwsyVqRc/QcT1Zqlr8Gm0X
   LIWo97pECmkEIik854ftkLtX3fFS3P+GHRwp306XXaxrLIVUqn6C7unCO
   qISw7IaS3NFTN8a/twwGM6rAT58+xSjMDT6k0lP44xttEfE3/UsgNdnlD
   dq2zQ3SrTLQmNrY8Z+OOlDMJVrnJM8eogqvHNQDTpJ385UAg30bXMqgXG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="394783417"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="394783417"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="669674739"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="669674739"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 09 Feb 2023 09:30:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 09:30:05 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 09:30:05 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 09:30:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6ctvYJYhT8jdZC91v4GRZ1ITDTQP7vNVHET9Ik9SAc9MmXvYzyGOrTzNSzgPRWSac4quC1sitf+TXY8AX/51H9OXpCF/9EwPBIvL82okAcHUoC8mhpCXMlOvO2lhuhoswNpRSq95IJapE+/RytJNc0EfeQnriuYrs+HT3u8RxDbYQeFB5MFXZMzG7iwyJutjDZzLq9qllaCKZxf/N+vpRlB2rpamlMraABNgbUGAoZG6W+kp0EGzM0dk4bviNQdm4XCjrQikZUEktkUFqSfgv1D3YWhyoreydAge2noFPYWkIGL4OdE04Qu+FHiBzqJa3LTWZs0x3iEWt3i+nu1Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADbA2md8gksYSCJgHZuoV0CTGcf0tCXd9H116dNh0Xc=;
 b=kg/tdKFSpR9ZWbnHKKT6RyhcaWF8Z2idnXr6p06ihryUMjsEeENlIYgVcmsQxelnLmMmgXNtgA5KxhF4ZyfRtd/jGcedEb5guUxeuP5iX2m378FpbDozFnlfTXcjaZo23p4cdnoHkg8Vuolc+lHPikPuWoYoZzCEl8FtZH1IebEx6Xng2/KcP7NyvSuS/lgeSg8I0QhMMteeBLaBkcwiTHxUGhKSP0vpk1ZqxN22PA8MtNnr6MaLzT6xkA34wwxv2gvBOdb/pch7TM3rB6+mKpONvYLCOeTInhk7i07dfcHpEehFiiYqSK9+FjzukNvzkF2LpTMZsWA7+1Y04LWU5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN2PR11MB4581.namprd11.prod.outlook.com (2603:10b6:208:26c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 17:30:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::ee6a:b9b2:6f37:86a1]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::ee6a:b9b2:6f37:86a1%9]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 17:30:02 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
CC:     Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Xu, Feng F" <feng.f.xu@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] EDAC/skx: Fix overflows on the DRAM row address
 mapping arrays
Thread-Topic: [PATCH 1/1] EDAC/skx: Fix overflows on the DRAM row address
 mapping arrays
Thread-Index: AQHZPIrF3XH5dmXuJ0mF/10OMnsMRq7G3fkg
Date:   Thu, 9 Feb 2023 17:30:02 +0000
Message-ID: <SJ1PR11MB6083CC9171E90537D09CB9B4FCD99@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20230209133023.39825-1-qiuxu.zhuo@intel.com>
In-Reply-To: <20230209133023.39825-1-qiuxu.zhuo@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MN2PR11MB4581:EE_
x-ms-office365-filtering-correlation-id: f0a1d199-e766-4aaa-9a38-08db0ac346e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IkWMJwLTEgJtu14pfcVRVT8cVbWFMc/GIzHRjIKmE8xmgbA0mB6p1fSApspTjVrQq+uuLQZ+mSfKUyTefGs3qebegK26xCx2VEwW/EqbvWt5DBV/OPPNGRiaMTesYB4eKftx8ecxMmlSrSWuFu9SgjSl2pDlgPDc5Wi3tfaBV4IiWqSFeuClcOzDlabAZBsiKwytJOIJ96FEd5DRNKa1DsNFQCE4bTJaalJzrFmD4AzoLOnTXv1z0YbGTUgg57uS7o4Ljxa+3f1wmeh5B7aHJmsJINdKSxCpQNNtrnIud8qtjLHDHhJroXk3Q1MQ53Gkuehqmzbe4dKeb54w93il/UVsH2zHn3UAtXNiBaypNTpaHqA2kaiNSlgKSCpO8uQ1b4madjBqKEs32hkQXlTjrvq4XMJqirT5WRiOLhczPUKbWfKy/4XXr34Ub5pAAX96oV6z6hL0hXXtPhVjFX9E+gOM/2t6KwLuYJjQa6O/G9Sk8w8ILnNhNg18d7lslmQeDgeHCUO19Q1XohrpDavfB6X0X0jhiA9rf09t5UtIQ8YJYkxoDl/oZ9vuiFrZoarh+TbaT4N7KwOts4aWbqtwYRrWs6hT8ChpMQ0xylEDe4BeyAkdIwynVje8S0+k3oUYIo/+aRg7Ut5PdK73My90ADaAK22yVXr6mevML5h8zxz9QVwp9tDN9e5PyK+ZahVFqtE/a1YzNb41DhQcYCBAeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199018)(7696005)(2906002)(4744005)(38100700002)(122000001)(82960400001)(86362001)(71200400001)(9686003)(26005)(186003)(6506007)(55016003)(38070700005)(33656002)(66946007)(66446008)(54906003)(83380400001)(64756008)(6636002)(316002)(66476007)(66556008)(76116006)(478600001)(41300700001)(4326008)(52536014)(8936002)(5660300002)(8676002)(6862004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UIYGvgTpmwn0DHZpuU7RE585DopjJLhrpamDBtW9ScYRhFFCZKsBL5NnA1xn?=
 =?us-ascii?Q?aek3cJqkvd0JgHY++3yoZz7TIqDiR6P2vW5bYxoGrodYgXkXoOGDyOsiSsQY?=
 =?us-ascii?Q?EFAhkhGU9At4FSwbQdwFSVTzRx3e+sPs6n547i4hQHAUVcofwoI9tSwL+BJP?=
 =?us-ascii?Q?vJwP7tkhb7W4l2xs4EDceDrzV9dLRdQIR96nb6/ZDNpOOK99oqAw5S6Dv5kb?=
 =?us-ascii?Q?kuFxE0jD7aoh23/UBNOmkztUjDMjo3VWXtvnW2DRGVjXnSkyT7HjeeCCQTqA?=
 =?us-ascii?Q?x1O6MRS1ysEHrT88/0X1UIEHMHrfi6WMXaHnaCMmCORom3fIK22IrmiXA7dF?=
 =?us-ascii?Q?I/0wHuxi9ETWyJXnJEbSHrBnAkDB79/aGfJcBeNnh4sA5o01pd8hCrbgMfKt?=
 =?us-ascii?Q?Tf4ATbe16bQzcgolb04/7bR0JGKnhsSQOPytjP2krOoVzOOHeKIrm2SD8y4B?=
 =?us-ascii?Q?HEBUyDVs/ofCLJcgcSHCgFrAxYnythVaaDf8Dn9GVVeLndbIUwqfEx8PpI/i?=
 =?us-ascii?Q?oHP6nVtm1tJeSnfoDAns75NJfVLDCCEkQOjjC9+jRJWdpgDggfG77UeDfUwY?=
 =?us-ascii?Q?MWaIT5c87+OHoBd+gRdtH9EDyjZ2iILMfoUcX/SmO9GHKRvoONqAnPUulY2e?=
 =?us-ascii?Q?TL/2g5OA9AlPf9MqckoN0sUt1/UXB+eE431zSsM549Olc7N9R7PWMnC6wIgA?=
 =?us-ascii?Q?RUmT/Ag5Ldyj6Hg/D8dUirYCcjypJKVvJutMVsuclkvKfcxkYgIKfMTInZSs?=
 =?us-ascii?Q?ttGFiNL54OKsDn03MPf/TxM3f6Tb/baFgaIDgE+f6VN5x8iHGH4sUW30lU18?=
 =?us-ascii?Q?cjASFF/cZnXRQwI1P3VR7oE71sTcJpVm4WputyESA+pGI7XMEP56MmBEWQYE?=
 =?us-ascii?Q?PKRPRuValDpm+BK+jPHYND0U8xF8Y3pVbR3KF9ddPEIVaIRampN3sCmCCmNw?=
 =?us-ascii?Q?+jMp7A3oCR8LOknUV1dD4tvQ8rEpU254W+/DCr3+O+1/DKR278o/mpVCIohi?=
 =?us-ascii?Q?bgnrlJqlPsULUnf3tgLswmi7wykm4Gr25Dt1hocUqSCqKwNquCj21gwSloCP?=
 =?us-ascii?Q?Ar8qiK0j/Ev8V+CZuIBER2VIE9AAHgllQ2lzhSImel7De3Bh9dWDJjRIkts8?=
 =?us-ascii?Q?YRlrh5DdNY3WB5IWCJPOJ8cyHGHHbaIU7ungMeb6YxtfmbGliv2Lgkbz7gIp?=
 =?us-ascii?Q?MYrkuIIQMNV254fmBPQH5b0X8MDXDzlWQm2jRam+/34P11xqE9U+Ry14q9XM?=
 =?us-ascii?Q?u05ndOJDR9VBJfUAwkjqXwI02GvFFN6TUidmzYvYc/prxGJCmpCjk2q07boc?=
 =?us-ascii?Q?utz/RVdaEoUTPJmHhoKs0bOyHbpEo1NizK8uzh/I+iKMVlk58HlUsaKEXq/v?=
 =?us-ascii?Q?x2hmHkc9QjWUQH4mjgYpUldHgVXzurWQWWiXYEdGED1X0xFikRxw4ynfc1dC?=
 =?us-ascii?Q?ZsM623PTTaWnrSPeuAYadnK7pC2EsCzf9zVy1uqF+KYflAm016aSwfLcC13l?=
 =?us-ascii?Q?u3yCamxkhM9/Ht8dWGiYb8x9N4uDpuD3Ntl9KtixhejiliDikWEbDo7JhL4S?=
 =?us-ascii?Q?OH/Nf/NAYsVKYBOGzt4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a1d199-e766-4aaa-9a38-08db0ac346e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 17:30:02.6900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kfkGzB5/CPWyzYIaNEXXPBkOUz0mYnmTN7zjc4Jq/2Cw3DZ+rQD4REVjc8+gILtL9P+F+VnJZuAy1uDp4OoUlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4581
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Fixes: 98f2fc829e3b ("EDAC, skx_edac: Delete duplicated code")

Please explain this Fixes tag. Looking at that commit I see that the=20
skx_close_row[] and skx_open_row[] arrays were moved from one
file to another in that commit. But neither had the "34" entry that
you are adding in this patch. They both stopped at "33".

> static u8 skx_close_row[] =3D {
> -	15, 16, 17, 18, 20, 21, 22, 28, 10, 11, 12, 13, 29, 30, 31, 32, 33
> +	15, 16, 17, 18, 20, 21, 22, 28, 10, 11, 12, 13, 29, 30, 31, 32, 33, 34
>  };
=20
> static u8 skx_open_row[] =3D {
> -	14, 15, 16, 20, 28, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33
> +	14, 15, 16, 20, 28, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33, 34
>  };

-Tony

