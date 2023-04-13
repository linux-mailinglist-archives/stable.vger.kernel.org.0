Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54666E1126
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 17:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjDMP3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 11:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjDMP3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 11:29:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200B49755
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 08:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681399782; x=1712935782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GMnsS3G5v2+o1ZngzSo89vgnJO9P5x5+OojYCG43a5s=;
  b=bU/4dHhBPHkew6CF3DdY51vqVR6ZUieE8SRudltU+kx61Dp/+so9CVFg
   LFPQEqqrx+ofpgRVQe7vfD+cwlD7289o4A+ayOZPb89jy7eYkKm/qkdME
   lifTpB0sJmbq2LpfgfupuehCOpI2oaK/4CwZhOJRGNJMFQh5KelvTCQYm
   wFhdBanarue4+zsRyToD4mP4EFBI+3FrlOAUm16fPU+OTGIkUIoc4W3Uc
   KggThAgq70fXIAkVs3PVB0pW3/5GyaVDZBfGD8s0Hc00+tUkovdRx2DU8
   qG2arm6sUtwGfW9kZLt3yzaWWBDdltM6wigNgCOrC/iYsc71vvdJGdeaQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="430497560"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="430497560"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 08:29:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="800848846"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="800848846"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 13 Apr 2023 08:29:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 08:29:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 08:29:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 08:29:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtCARWeEwoix2KSeMuVngPxvtZka9zYXXLGOH4wqB6kDEm0FfGscC6p3bc/G0M6UqbzriCH5UIHR2RyF/gu9NYgOxWAg8seJITi3UBKbQPWx4ijBBi/5TViOZAj2UA/t7oEkznpHsyBGbqSD+MZ372a4fPIns2sLPTeowQgvUj8dWu2Xpn3Fs4p2VPsubPg8y8DANC28F0zsJ9IF9/wCVvvsrBww/o+hTSDd1rLTVdmuIW0xKZ+5VMZiFBSfNPRRJt9JG85mlydmhVLI0AXPoBhvppYp9hJj2DvepRgpjBluc/cmOszg2oihEUVKFZbPBgw4RtXoRkZNUxFTTf1Dug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhdDOPcdewTSs9QYsVCV45EKWI4sU7bPYTbQn6ihSDU=;
 b=RUPm4ta6Ft0IAY3rNCcwXvV5rH74z9sXkAOiyVQaf4divfr2vBrgPwiI1v+M7mFiVSJuE3jhPcViQ5lNLX83M8tQrj8vHiws5eqLe2bvV1VB4d7aq7Ybve4RhJXLhLShfsbqrB/fNTWYABziqlHp2Gb/noV9+aeU/5ZY9niT6cvdqoHp0BIpVwhrz5JNOrxZMHxskaDWwlFeejwr3+qX8c8c2vF+GRyrG3RI3R3aqKnm5UOfzaaBN/0JzNJTC93gWcwnSPklGVd5ss/Hg+fd8w7T5vDI60G4pnib3PvB1LFh0/bytX6VmdE7xFXdTLcf/aOdjy2Bf6B/Lyw1v0Ge7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5981.namprd11.prod.outlook.com (2603:10b6:510:1e0::15)
 by SA2PR11MB4906.namprd11.prod.outlook.com (2603:10b6:806:fa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 15:29:34 +0000
Received: from PH7PR11MB5981.namprd11.prod.outlook.com
 ([fe80::963e:a5cc:24d1:e15e]) by PH7PR11MB5981.namprd11.prod.outlook.com
 ([fe80::963e:a5cc:24d1:e15e%5]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 15:29:34 +0000
From:   "Manna, Animesh" <animesh.manna@intel.com>
To:     "Shankar, Uma" <uma.shankar@intel.com>,
        "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/i915/color: Fix typo for Plane CSC indexes
Thread-Topic: [PATCH] drm/i915/color: Fix typo for Plane CSC indexes
Thread-Index: AQHZY0VGRpiDeIA9GUGh4wPJhnbJMa8pcrBQ
Date:   Thu, 13 Apr 2023 15:29:34 +0000
Message-ID: <PH7PR11MB59814311A6E1EEC5B88B3BD5F9989@PH7PR11MB5981.namprd11.prod.outlook.com>
References: <20230330150104.2923519-1-chaitanya.kumar.borah@intel.com>
 <DM4PR11MB6360E30EB49BB7C77C146B14F48E9@DM4PR11MB6360.namprd11.prod.outlook.com>
In-Reply-To: <DM4PR11MB6360E30EB49BB7C77C146B14F48E9@DM4PR11MB6360.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5981:EE_|SA2PR11MB4906:EE_
x-ms-office365-filtering-correlation-id: 9dda8633-901d-483a-0804-08db3c33e2b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qxXgoF1/MPwG5U67/PqyMkwwNq3pDgKCIMlxRHmUlhfxQlN/Js/z79WdztRD1bD618Q+iXFwSm3e0Fdk7wUYgJBksEutMXVJy32XH8cc9DxHj/gvNNkFxMPwxbJ+Qi0Pzd+PcjGu5OdhzQFklfQjoabbxrIbQb3FdqbBgbYjOleK2hxg7OSFh4sHK2LY+hElVc3faCaMdMDpzMRjIo+BS+TNil5XFjiZkOHPx9p935kVQpwHwCv77AHNZYGcHAnN+igQ+CbFIrL1meo44iP4AriwyaZrLuCO0ey/klJOEPonmjZuHhybTZ43WPdW9zyveF9aZx/KQHHY5fkPF8IcMd/THJ7LPg2CV+smbTMxpM45z0LAef//2QpvZhRKG3iulXTquJPqWOifG1uvjlANo4GuO0804R5g1lygvcFwX5Ze/BQIgMrIwMjA9sVoA47j7vSyZ2ZQ+LpmEO862vS4X9vT9PPvC56IHbgJ60RifOAIU3cfas9Jt5rLRSjOlxWY4WHZq1RfncJctGGkQc+kstuVlqN/MHDowwC+aBN3V18oU1Yim5d4+bmNspaXl8zXQlKhwiw+CU1Ig7sCT3/2LInTWe3K2et1BStrshI/1YD0C5CZSyD3X84K7BH6yC0E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5981.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(71200400001)(7696005)(64756008)(66446008)(66476007)(66556008)(66946007)(4326008)(76116006)(110136005)(2906002)(38070700005)(86362001)(122000001)(41300700001)(82960400001)(33656002)(5660300002)(52536014)(8676002)(8936002)(316002)(38100700002)(478600001)(55016003)(55236004)(53546011)(9686003)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ypg9NzQ1Dznp6O2LgongiowCZVZta8LtvJnidzbzkx7sAmvCe4eKk6Kp3XDd?=
 =?us-ascii?Q?w7rlZ7i5pPe4muVQAzuFnE7ws9fP0jArBS+UZF7Fu9Mir7h51eEGv3AS8oRt?=
 =?us-ascii?Q?lL/EWdSt7MP4vQSxkIKu0aWSBFQb01O3fHhxqz9gR+DV7bNICmxmFXPFsLvT?=
 =?us-ascii?Q?VI94FWZ6CcRfwATSQwt7piaLVXYWJufZbi6I8YsbYzurHZhFfkwteryLugtF?=
 =?us-ascii?Q?kKYNSALO4YSfUiYOrgx9Tyrw1aJEMCwdVzSfYZXTNMYgxtz8TfNJL6TK0enM?=
 =?us-ascii?Q?dIY40/ZMfNuE+stEG+0PltjvL1uMm9oUTzUXHmbKeRfdRGIDaNC1kElitF1Z?=
 =?us-ascii?Q?EhxZIhNeC4Lo2YjL57I+miq1AZN7j2abpM2X6S/8JVLUUnLMSQkjQLq3njMk?=
 =?us-ascii?Q?OwZW0wB1WNurcnaD+UYJue8QhxIo9jvaQHg+XTMKs/vgsa17zsGxeUdipPFw?=
 =?us-ascii?Q?Nv/KsUMsncSceiyyIMozAthLwZo4YFL5p+T2YJp21TORLk4JxN8ojCH8ZwJg?=
 =?us-ascii?Q?2KFddvtUnrhLy31JZUFjmLx5vqTe3ElZujbZHsjwNEekW/xZerlJy40kONYO?=
 =?us-ascii?Q?q+HqQhkA4SWs6M/opuhMjb1GAgePfsHih9hgk6GR/RsukNq6WSKs9L4WSSVa?=
 =?us-ascii?Q?f6dAW7H9VKR2I5CEyyhBUjT+DOuyQnudDFXAa48dTNGtiyyzVK+XG9IL3/x7?=
 =?us-ascii?Q?E0xkCVyNX282mOopx3yjjaLDi9DVrbFBb85uhD4vUCcoq0v38XwViCtOU/Ga?=
 =?us-ascii?Q?MUEbYs2jD7DpHom5bRZ8k38Jo3+FSbyMRUTq93JzxDLXEwiu5VB++HHu0zrJ?=
 =?us-ascii?Q?l9bjiO/YcpphSuIYpbRwt3nN2cuI3yJ7aurYqImJ50HP0xXal1kqp9Cofc8z?=
 =?us-ascii?Q?6xVIMW7/0iVFTPJUUA/zK5RzAdg0vLIcdtIcygpInLvsQJvTUZuptqXobAFq?=
 =?us-ascii?Q?A0L/Vpw56ILiiBVAzcUunqribG9zubXtr1xqcOOFSV/s3uo9ufJdr6NduM+O?=
 =?us-ascii?Q?JDE1gtYmCcdTRTYQHfhPX2I40bNUgWgRgScXIyt1TXa7eSZHE274J2wCm1DJ?=
 =?us-ascii?Q?U5KsjABfKBRu9lQDGuyZtjATHlDv+3dA79sUPOzaD4v+CxWKtHHB/KaFwvUf?=
 =?us-ascii?Q?+hjz7NWBkyI/c7KMjwTBx5J7rBnxLhjeSQn6375vOlIewgcGz+Xd484NOtQ1?=
 =?us-ascii?Q?RA0wHL8dK+xKGSBr5ggGp1096TpP5SCBsAIMORx8Prw+3yKFAqXKzS5Wy6q+?=
 =?us-ascii?Q?pECLw9/GBdep8NhGiwUL3XAxyqRG6mcfd85u3a1JEdysciB3yLqKUp2cWO6D?=
 =?us-ascii?Q?qI0CMm9nXYie3Ic7dZAB0vBVPBiC9aoiAoW3M0UzpFbO6u9KHdmOUbLg6FO0?=
 =?us-ascii?Q?phQsDS5PbOUtmpkzq2rWGGcVvaGJpC2PXdocK7gh03dDy1gX42Gq9dCbjBuh?=
 =?us-ascii?Q?5ZpiamLpBtbe0S6xQ2A0XvwoFMuiJD7ZPY8kM2Kd8ihjUzXMwf4m3g4Wu4yL?=
 =?us-ascii?Q?f+i0TrhsftC6ufiimvVxd1p0Uy1mjCnHFRkOCWVq1W1/QjyblCthwSbL3Qpv?=
 =?us-ascii?Q?n6HnliIs3FVRhOKjG9IEePSM9ipm12UVCw9PuRNI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5981.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dda8633-901d-483a-0804-08db3c33e2b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 15:29:34.6988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aBT8Ppe7/GAVDdjOfqO/1CZO7h8Ca92ktY2zCRkmn9WnCP5Y7Yuv7IjqGnkeOsJxAl4Mk1fC1SnTqATcuquIhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4906
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Intel-gfx <intel-gfx-bounces@lists.freedesktop.org> On Behalf Of
> Shankar, Uma
> Sent: Friday, March 31, 2023 1:52 AM
> To: Borah, Chaitanya Kumar <chaitanya.kumar.borah@intel.com>; intel-
> gfx@lists.freedesktop.org
> Cc: stable@vger.kernel.org
> Subject: Re: [Intel-gfx] [PATCH] drm/i915/color: Fix typo for Plane CSC
> indexes
>=20
>=20
>=20
> > -----Original Message-----
> > From: Borah, Chaitanya Kumar <chaitanya.kumar.borah@intel.com>
> > Sent: Thursday, March 30, 2023 8:31 PM
> > To: intel-gfx@lists.freedesktop.org
> > Cc: Shankar, Uma <uma.shankar@intel.com>; Borah, Chaitanya Kumar
> > <chaitanya.kumar.borah@intel.com>; stable@vger.kernel.org
> > Subject: [PATCH] drm/i915/color: Fix typo for Plane CSC indexes
> >
> > Replace _PLANE_INPUT_CSC_RY_GY_2_* with _PLANE_CSC_RY_GY_2_* for
> Plane
> > CSC
> >
> > Fixes: 6eba56f64d5d ("drm/i915/pxp: black pixels on pxp disabled")
>=20
> Looks Good, thanks for catching it.
> Reviewed-by: Uma Shankar <uma.shankar@intel.com>

Pushed the changes to din. Thanks

Regards,
Animesh

>=20
> > Cc: <stable@vger.kernel.org>
> >
> > Signed-off-by: Chaitanya Kumar Borah
> <chaitanya.kumar.borah@intel.com>
> > ---
> >  drivers/gpu/drm/i915/i915_reg.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/i915_reg.h
> > b/drivers/gpu/drm/i915/i915_reg.h index 8e4aca888b7a..85885b01e6ac
> > 100644
> > --- a/drivers/gpu/drm/i915/i915_reg.h
> > +++ b/drivers/gpu/drm/i915/i915_reg.h
> > @@ -7496,8 +7496,8 @@ enum skl_power_gate {
> >
> >  #define _PLANE_CSC_RY_GY_1(pipe)	_PIPE(pipe, _PLANE_CSC_RY_GY_1_A,
> \
> >  					      _PLANE_CSC_RY_GY_1_B)
> > -#define _PLANE_CSC_RY_GY_2(pipe)	_PIPE(pipe,
> > _PLANE_INPUT_CSC_RY_GY_2_A, \
> > -					      _PLANE_INPUT_CSC_RY_GY_2_B)
> > +#define _PLANE_CSC_RY_GY_2(pipe)	_PIPE(pipe,
> _PLANE_CSC_RY_GY_2_A, \
> > +					      _PLANE_CSC_RY_GY_2_B)
> >  #define PLANE_CSC_COEFF(pipe, plane, index)
> 	_MMIO_PLANE(plane, \
> >
> > _PLANE_CSC_RY_GY_1(pipe) +  (index) * 4, \
> >
> > _PLANE_CSC_RY_GY_2(pipe) + (index) * 4)
> > --
> > 2.25.1

