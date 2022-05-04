Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD905192DF
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 02:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242162AbiEDAjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 20:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbiEDAjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 20:39:46 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD0E37A06
        for <stable@vger.kernel.org>; Tue,  3 May 2022 17:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651624571; x=1683160571;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TATU6Gb4GipKDgddeeNd1WSbENH3Dl3x8Gu0Eh3vUd0=;
  b=beSy91gChZbI6Jx9l1ratjmQ1nzxsCfL3xdjdkksq1V+z+MLEHm5YvkU
   uWS/Km/+/NXIMjanmT8/FmAvQ42V28xxkWXtXcJDjQZv9178I94EutNtD
   AGLuxA/HKlm7Ikbxdv5Okqg9s6vmK5zod0KemqhAh0M3SrkhN5MgPQWYJ
   OJOTCw4tOJIkmNQGrxrumxxDprHEuEqsDt22ee+rYbEJ/7phyyOXsXA7P
   QFN2crmQpKutXt07snfNo1ftEfWwA36PAjIeiLQITJCEmdOVuqFOjmBw/
   qbYXrorwK+sBiHtzGb6DxikTcM1jPnKplXKiK5SGIjOYa6dvyDHFhcBPu
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267508648"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267508648"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 17:36:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="536597544"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 03 May 2022 17:36:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 3 May 2022 17:36:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 3 May 2022 17:36:10 -0700
Received: from fmsmsx611.amr.corp.intel.com ([10.18.126.91]) by
 fmsmsx611.amr.corp.intel.com ([10.18.126.91]) with mapi id 15.01.2308.027;
 Tue, 3 May 2022 17:36:10 -0700
From:   "Srivatsa, Anusha" <anusha.srivatsa@intel.com>
To:     "De Marchi, Lucas" <lucas.demarchi@intel.com>
CC:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/i915/dmc: Add MMIO range restrictions
Thread-Topic: [PATCH] drm/i915/dmc: Add MMIO range restrictions
Thread-Index: AQHYX0xUPuwnq8o+jk2fuKY1pj8BN60OU1CA//+Lm1A=
Date:   Wed, 4 May 2022 00:36:10 +0000
Message-ID: <3dd28d33bbcc440791b8cdfa30fd4b4b@intel.com>
References: <20220504001346.667825-1-anusha.srivatsa@intel.com>
 <20220504003123.7z4cpxdae43tnuor@ldmartin-desk2>
In-Reply-To: <20220504003123.7z4cpxdae43tnuor@ldmartin-desk2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: De Marchi, Lucas <lucas.demarchi@intel.com>
> Sent: Tuesday, May 3, 2022 5:31 PM
> To: Srivatsa, Anusha <anusha.srivatsa@intel.com>
> Cc: intel-gfx@lists.freedesktop.org; stable@vger.kernel.org
> Subject: Re: [PATCH] drm/i915/dmc: Add MMIO range restrictions
>=20
> On Tue, May 03, 2022 at 05:13:46PM -0700, Anusha Srivatsa wrote:
> >Bspec has added some steps that check forDMC MMIO range before
> >programming them
> >
> >v2: Fix for CI
> >v3: move register defines to .h (Anusha)
> >- Check MMIO restrictions per pipe
> >- Add MMIO restricton for v1 dmc header as well (Lucas)
> >v4: s/_PICK/_PICK_EVEN and use it only for Pipe DMC scenario.
> >- clean up sanity check logic.(Lucas)
> >- Add MMIO range for RKL as well.(Anusha)
> >
> >BSpec: 49193
> >
> >Cc: <stable@vger.kernel.org>
> >Cc: Lucas De Marchi <lucas.demarchi@intel.com>
> >Signed-off-by: Anusha Srivatsa <anusha.srivatsa@intel.com>
> >---
> > drivers/gpu/drm/i915/display/intel_dmc.c      | 43 +++++++++++++++++++
> > drivers/gpu/drm/i915/display/intel_dmc_regs.h | 18 +++++++-
> > 2 files changed, 60 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c
> >b/drivers/gpu/drm/i915/display/intel_dmc.c
> >index 257cf662f9f4..e37ba75e68da 100644
> >--- a/drivers/gpu/drm/i915/display/intel_dmc.c
> >+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
> >@@ -374,6 +374,44 @@ static void dmc_set_fw_offset(struct intel_dmc
> *dmc,
> > 	}
> > }
> >
> >+static bool dmc_mmio_addr_sanity_check(struct intel_dmc *dmc, const
> u32 *mmioaddr,
> >+				       u32 mmio_count, int header_ver, u8
> dmc_id) {
> >+	struct drm_i915_private *i915 =3D container_of(dmc, typeof(*i915),
> dmc);
> >+	u32 start_range, end_range;
> >+	int i;
> >+
> >+	if (dmc_id >=3D DMC_FW_MAX || dmc_id < DMC_FW_MAIN) {
>=20
> dmc_id is unsigned and DMC_FW_MAIN is 0. dmc_id < DMC_FW_MAIN can't
> ever possibly happen so you can remove it.
>=20
> >+		drm_warn(&i915->drm, "Unsupported firmware id %u\n",
> dmc_id);
> >+		return false;
> >+	}
> >+
> >+	if (header_ver =3D=3D 1) {
> >+		start_range =3D DMC_MMIO_START_RANGE;
> >+		end_range =3D DMC_MMIO_END_RANGE;
> >+	} else if (dmc_id =3D=3D DMC_FW_MAIN) {
> >+		start_range =3D TGL_MAIN_MMIO_START;
> >+		end_range =3D TGL_MAIN_MMIO_END;
> >+	} else if (IS_DG2(i915) || IS_ALDERLAKE_P(i915)) {
>=20
> 	} else if (DISPLAY_VER(i915) >=3D 13) {
>=20
> ?
>=20
> >+		start_range =3D ADLP_PIPE_MMIO_START;
> >+		end_range =3D ADLP_PIPE_MMIO_END;
> >+	} else if (IS_TIGERLAKE(i915) || IS_DG1(i915) ||
> IS_ALDERLAKE_S(i915) ||
> >+		   IS_ROCKETLAKE(i915)) {
>=20
> 	} else if (DISPLAY_VER(i915) >=3D 12) {
>=20
> ?
>=20
> maintaining the if/else ladder fine grained by platform is somewhat painf=
ul.

Agreed.

> >+		start_range =3D TGL_PIPE_MMIO_START(dmc_id);
> >+		end_range =3D TGL_PIPE_MMIO_END(dmc_id);
> >+	} else {
> >+		drm_warn(&i915->drm, "Unknown mmio range for sanity
> check");
> >+		return false;
> >+	}
> >+
> >+	for (i =3D 0; i < mmio_count; i++) {
> >+		if (mmioaddr[i] < start_range || mmioaddr[i] > end_range)
> >+			return false;
> >+	}
> >+
> >+	return true;
> >+}
> >+
> > static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
> > 			       const struct intel_dmc_header_base
> *dmc_header,
> > 			       size_t rem_size, u8 dmc_id)
> >@@ -443,6 +481,11 @@ static u32 parse_dmc_fw_header(struct intel_dmc
> *dmc,
> > 		return 0;
> > 	}
> >
> >+	if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count,
> dmc_header->header_ver, dmc_id)) {
> >+		drm_err(&i915->drm, "DMC firmware has Wrong MMIO
> Addresses\n");
> >+		return 0;
> >+	}
> >+
> > 	for (i =3D 0; i < mmio_count; i++) {
> > 		dmc_info->mmioaddr[i] =3D _MMIO(mmioaddr[i]);
> > 		dmc_info->mmiodata[i] =3D mmiodata[i]; diff --git
> >a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
> >b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
> >index d65e698832eb..67e14eb96a7a 100644
> >--- a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
> >+++ b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
> >@@ -16,7 +16,23 @@
> > #define DMC_LAST_WRITE		_MMIO(0x8F034)
> > #define DMC_LAST_WRITE_VALUE	0xc003b400
> > #define DMC_MMIO_START_RANGE	0x80000
> >-#define DMC_MMIO_END_RANGE	0x8FFFF
> >+#define DMC_MMIO_END_RANGE     0x8FFFF
> >+#define DMC_V1_MMIO_START_RANGE		0x80000
> >+#define TGL_MAIN_MMIO_START		0x8F000
> >+#define TGL_MAIN_MMIO_END		0x8FFFF
> >+#define _TGL_PIPEA_MMIO_START		0x92000
> >+#define _TGL_PIPEA_MMIO_END		0x93FFF
> >+#define _TGL_PIPEB_MMIO_START		0x96000
> >+#define _TGL_PIPEB_MMIO_END		0x97FFF
> >+#define ADLP_PIPE_MMIO_START		0x5F000
> >+#define ADLP_PIPE_MMIO_END		0x5FFFF
>=20
> don't we have per-pipe range for ADLP_? Or is there only pipe A?
>=20
We don't have per-pipe range. We have one big chunk of range for all pipe D=
MC MMIOs.

> with the above fixes, feel free to add my Reviewed-by: Lucas De Marchi
> <lucas.demarchi@intel.com> in the next version.

Thanks!
=20
> Lucas De Marchi
>=20
> >+
> >+#define TGL_PIPE_MMIO_START(dmc_id)	_PICK_EVEN(((dmc_id) - 1),
> _TGL_PIPEA_MMIO_START,\
> >+					      _TGL_PIPEB_MMIO_START)
> >+
> >+#define TGL_PIPE_MMIO_END(dmc_id)	_PICK_EVEN(((dmc_id) - 1),
> _TGL_PIPEA_MMIO_END,\
> >+					      _TGL_PIPEB_MMIO_END)
> >+
> > #define SKL_DMC_DC3_DC5_COUNT	_MMIO(0x80030)
> > #define SKL_DMC_DC5_DC6_COUNT	_MMIO(0x8002C)
> > #define BXT_DMC_DC3_DC5_COUNT	_MMIO(0x80038)
> >--
> >2.25.1
> >
