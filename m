Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4D22F20C1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 21:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404179AbhAKU0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 15:26:20 -0500
Received: from mga07.intel.com ([134.134.136.100]:58024 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404024AbhAKU0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 15:26:19 -0500
IronPort-SDR: dL93BXtB+hBy4pgmk4CP/WwCr3UJIh53Q63swueIZOAON6NvMB7LaNzwmWss9A9RPM66bKuQWy
 rdf0ryiWobaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="242003441"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="242003441"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 12:25:38 -0800
IronPort-SDR: CqTtWbtLoNukADcN7pgMDLLaX30FoC3mDlquBEqIuaXixkoCYkdK34blmVDPlVPocFTXi2xDCm
 kQ4MPtmcsN4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="352740107"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 11 Jan 2021 12:25:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 Jan 2021 12:25:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 11 Jan 2021 12:25:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 11 Jan 2021 12:25:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrdYzVC4K4qVi/Dpb+5vH6/O5vgh2qqCXQS/uyovEW4gvg6thEuwmPEwAh4qNMSMaCYMCu1Y5OxLfiMfBzAikqkvPA/Foab8PSPi21LvVwsxuqD9CteFiLeT5PfN+OiW35SfwnpRMWVH3+EKOH2AHngNiC48UihTksNvX6W/bVZXO0l4d+gpCeXwThpVIdCD28mX+yeQNhwYCUaNKdeBw3QjIESCzQE/TyFPr5ru9CvGvRNNVvedvOeyAcdjxN35P2pKnIdHv3MZHhS7bPoSD6thE67bE4g2sYtPBAn+QyxtsgfkmDrRWcwd6Sn4KxNx2M7ub4s6ecLTIEmGhSQZ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/WeizlN06O/pMINQqHts00iMKv7cCia1hO/cPOFpGE=;
 b=KDwclGy30Izoi3DkX2GntygFZph5/Dw6IdjHpbKsY6mUF14KUeFtT4miH3SWVYJfoNggGl8kviXNbZQPZl1t7xZ54yrFx2Aj0ZO/zAXGbGS1a+g+l+XI2Fke2on5Jvd6FzGKnMPoPCAP15IngFazaIdQxzplUChnMhNxQzxhZpanMgJMQyiDGa/r42NexuwJd72G6psyKHqDFZpNVRRPzFEoQU2QDrm8i9sSvs0gbWFhV9WhvpsZrwrN85CitdHy51KVC0RuwG04YlaVAAoyRdB3Tt3xx+vv6o6sPsKPQ0RVTMJYI4jLW9vM0DBv5Bi0kj9FkVttMIXFe2+olgFcYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/WeizlN06O/pMINQqHts00iMKv7cCia1hO/cPOFpGE=;
 b=AWRv52ARMWgx+6QvFhiF/xaXj5T7k1dUpPI2JNy1Z+2fz8j0Pp1OEOadEcz6mSow0Xdpz+5cBnUT5l3YaMnkBhCNJhmd10tIdcldktri1jnZZ6BmbCOXgpcq2cHA/DPM5q5miP1ecVf/msq6t7CIrLR1bYmpp4Ft9tb8yM4ShFA=
Received: from BYAPR11MB3799.namprd11.prod.outlook.com (2603:10b6:a03:fb::19)
 by BYAPR11MB2645.namprd11.prod.outlook.com (2603:10b6:a02:c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 20:25:34 +0000
Received: from BYAPR11MB3799.namprd11.prod.outlook.com
 ([fe80::d152:da83:422f:6d53]) by BYAPR11MB3799.namprd11.prod.outlook.com
 ([fe80::d152:da83:422f:6d53%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 20:25:34 +0000
From:   "Abodunrin, Akeem G" <akeem.g.abodunrin@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        "Kumar Valsan, Prathap" <prathap.kumar.valsan@intel.com>,
        "Bloomfield, Jon" <jon.bloomfield@intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "Randy Wright" <rwright@hpe.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/3] drm/i915/gt: Limit VFE threads based on GT
Thread-Topic: [PATCH 1/3] drm/i915/gt: Limit VFE threads based on GT
Thread-Index: AQHW5p8pB5+Xm475Y0+OQiuuXpQrK6oi4XAg
Date:   Mon, 11 Jan 2021 20:25:34 +0000
Message-ID: <BYAPR11MB3799F7F212E15B8F61A30FF5A9AB0@BYAPR11MB3799.namprd11.prod.outlook.com>
References: <20210109154931.10098-1-chris@chris-wilson.co.uk>
In-Reply-To: <20210109154931.10098-1-chris@chris-wilson.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: chris-wilson.co.uk; dkim=none (message not signed)
 header.d=none;chris-wilson.co.uk; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [207.109.37.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b4fa3d7-861c-4f79-2237-08d8b66f0cfd
x-ms-traffictypediagnostic: BYAPR11MB2645:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB264571F2237964129AA9D28BA9AB0@BYAPR11MB2645.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NgC2IBPwophn7rDxxN5l/3SUgSUifzHdfBHSuO1GDUeXxQKLER1NPY5u82ycQhS5q3IwEzBpScD7KVOqaq4QxuEfX2U63JoZEnyI5tzVN6jb1ZX+s6TR3SU3lY2JpgbjDGX+1MOrL4pq27Vhe2imxb5EIt8HdRMzcjUJYVcTnE2VZZzt6xCulXX7cUDr0aKVp0rVywfOPrZsqk1KO/sKN8a+2KTPeG3oE8XbUmzQrGFNKudXVruQ8hJmGixvubeFTGQ0XVzot175B/f1EPHmFc0ymBdl4llYDRLObewaxUGQJG+jGh+SXHSKrYbkggK6u8/gzjYSWJr8+JIO4Xk7TwfHx5Ff08BFBWdlKWN34lz5LvorW6kJR0/zq7aD55rfFfNI3xl8njIb5ADNskoJ6UEPq+fSryLDV8oLWhWuQ+g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3799.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(5660300002)(52536014)(66556008)(9686003)(4326008)(110136005)(7696005)(26005)(86362001)(6506007)(966005)(478600001)(8676002)(8936002)(66446008)(83380400001)(186003)(66946007)(54906003)(55016002)(76116006)(53546011)(71200400001)(2906002)(33656002)(66476007)(316002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uu7fajfp+clCjTq2gOrYfSh1Cz87hGyuC1qnq774EV5vyrk667Sl9r+FbDC5?=
 =?us-ascii?Q?b7By3EEZw4/utXXHXfXP7ODb76HU6PYkUALSBqHyY0zryXvtTnljpIJC4W7y?=
 =?us-ascii?Q?IAJ0EyplngK1cVe+FV051+0lqHDcymKFaMQM7BBjFapIX0nv+OIZNlk+7vlk?=
 =?us-ascii?Q?BLcA2v9bFG7ce5DIQNg3wtsKseDje+WuUTKfvzGgPQgj8cxY2a3RCiaOx0dl?=
 =?us-ascii?Q?SxhxGmUYJQ2aT3+AU9IU/7x13ljiYrqyCgiO1/t5+HrK0Slqyj/c++nYWl0F?=
 =?us-ascii?Q?UWpsG51CAg8jWgwDbY7cQCwKtxSlYrdpl3nu4vT/HhE4YQcOQs6Z+mf2A8Ps?=
 =?us-ascii?Q?oxcN/MjfxdXylAs+4KQKjgmVL2QURFG39Flx5VKoJSSvF+rAT+Ozj45DeoqH?=
 =?us-ascii?Q?d6A4W2s3rd+i62of5n3L/8SuO58TxTIiryaNwfKkLJIDDkSqhMBkv7WkcQA5?=
 =?us-ascii?Q?jNulU3Mo60/lkuek7IQ4BjpO6cmW4B0NiZlpHgHGC1iTcuhnQFP6MPeF/Scb?=
 =?us-ascii?Q?wZJN8HHZ97JTU4cRNuimPYxZ6cuOc4zBBbvyEqPWWQNI87GbsFHN85XxqWyg?=
 =?us-ascii?Q?ybIwoHZ2xQqYTN79Ouc3/FxMpYNkkdOASpgQDtfZePs3zaF+McNJSXDUOr8W?=
 =?us-ascii?Q?kU6ZDLqedDLWDVLtP+AlX/JFanmyXYn5Vw4Pj+x48hVmCb5tJFq1XzVmAJ/p?=
 =?us-ascii?Q?XI56xB69o5HCJLhD4hdz8gBBLPEV8AJbj8cqNrvGAZ9HRtHG+ytRrzI1auyQ?=
 =?us-ascii?Q?YqMUeTIDIxnCLTXfGsItlkDVdVkL44y0VCRnos8ngLQU7EA2MYyjKBDxgP3F?=
 =?us-ascii?Q?yMfp/pl8MctcXIhcTAE+a5yEucJ3TnQSmcVFWUsOBOvF8yQfnM1IJPPbuoMI?=
 =?us-ascii?Q?ysCcr0N+2oPGGb77zOErY53mxi6kdNDuzilcFIaA5mPRilZat/43/fnymZGO?=
 =?us-ascii?Q?LTWLj5rAN+vWM7v0n3lHaD17QFU9cV19TRQ+MCjSVzs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3799.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4fa3d7-861c-4f79-2237-08d8b66f0cfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 20:25:34.6597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xonOgZMlKKFe4I3xTPWLr/DDwCDrusBu1gUVnNdNne+zS40vZmvYEJiiol25ibGRye5WFhVWJIxoyg7zQ+jYGLgH3sczYVQXpbEfe9q7l8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2645
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Sent: Saturday, January 09, 2021 7:49 AM
> To: intel-gfx@lists.freedesktop.org
> Cc: Chris Wilson <chris@chris-wilson.co.uk>; Mika Kuoppala
> <mika.kuoppala@linux.intel.com>; Kumar Valsan, Prathap
> <prathap.kumar.valsan@intel.com>; Abodunrin, Akeem G
> <akeem.g.abodunrin@intel.com>; Bloomfield, Jon
> <jon.bloomfield@intel.com>; Vivi, Rodrigo <rodrigo.vivi@intel.com>; Randy
> Wright <rwright@hpe.com>; stable@vger.kernel.org
> Subject: [PATCH 1/3] drm/i915/gt: Limit VFE threads based on GT
>=20
> MEDIA_STATE_VFE only accepts the 'maximum number of threads' in the
> range [0, n-1] where n is #EU * (#threads/EU) with the number of threads
> based on plaform and the number of EU based on the number of slices and
> subslices. This is a fixed number per platform/gt, so appropriately limit=
 the
> number of threads we spawn to match the device.
>=20
> v2: Oversaturate the system with tasks to force execution on every HW
> thread; if the thread idles it is returned to the pool and may be reused =
again
> before an unused thread.
>=20
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2024
> Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
> Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
> Cc: Jon Bloomfield <jon.bloomfield@intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Randy Wright <rwright@hpe.com>
> Cc: stable@vger.kernel.org # v5.7+
> ---
>  drivers/gpu/drm/i915/gt/gen7_renderclear.c | 91 ++++++++++++----------
>  1 file changed, 49 insertions(+), 42 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> index d93d85cd3027..3ea7c9cc0f3d 100644
> --- a/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> +++ b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> @@ -7,8 +7,6 @@
>  #include "i915_drv.h"
>  #include "intel_gpu_commands.h"
>=20
> -#define MAX_URB_ENTRIES 64
> -#define STATE_SIZE (4 * 1024)
>  #define GT3_INLINE_DATA_DELAYS 0x1E00
>  #define batch_advance(Y, CS) GEM_BUG_ON((Y)->end !=3D (CS))
>=20
> @@ -34,38 +32,57 @@ struct batch_chunk {  };
>=20
>  struct batch_vals {
> -	u32 max_primitives;
> -	u32 max_urb_entries;
> -	u32 cmd_size;
> -	u32 state_size;
> +	u32 max_threads;
>  	u32 state_start;
> -	u32 batch_size;
> +	u32 surface_start;
>  	u32 surface_height;
>  	u32 surface_width;
> -	u32 scratch_size;
> -	u32 max_size;
> +	u32 size;
>  };
>=20
> +static inline int num_primitives(const struct batch_vals *bv) {
> +	/*
> +	 * We need to oversaturate the GPU with work in order to dispatch
> +	 * a shader on every HW thread.
> +	 */
> +	return bv->max_threads + 2;
> +}
> +
>  static void
>  batch_get_defaults(struct drm_i915_private *i915, struct batch_vals *bv)=
  {
>  	if (IS_HASWELL(i915)) {
> -		bv->max_primitives =3D 280;
> -		bv->max_urb_entries =3D MAX_URB_ENTRIES;
> +		switch (INTEL_INFO(i915)->gt) {
> +		default:
> +		case 1:
> +			bv->max_threads =3D 70;
> +			break;
> +		case 2:
> +			bv->max_threads =3D 140;
> +			break;
> +		case 3:
> +			bv->max_threads =3D 280;
> +			break;
> +		}
>  		bv->surface_height =3D 16 * 16;
>  		bv->surface_width =3D 32 * 2 * 16;
>  	} else {
> -		bv->max_primitives =3D 128;
> -		bv->max_urb_entries =3D MAX_URB_ENTRIES / 2;
> +		switch (INTEL_INFO(i915)->gt) {
> +		default:
> +		case 1: /* including vlv */
> +			bv->max_threads =3D 36;
> +			break;
> +		case 2:
> +			bv->max_threads =3D 128;
> +			break;
> +		}
Do we really need to hardcode max number of threads per gt/platform? Why no=
t calculating the number of active threads from the no_of_slices * 1024? - =
Also, is "64" not the minimum number of threads supported?

Thanks,
~Akeem
