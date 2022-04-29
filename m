Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701F95155DF
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 22:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357449AbiD2UnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 16:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381038AbiD2Um6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 16:42:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27DA83B19
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 13:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651264744; x=1682800744;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EuIlrKJALH7qzbOWN5CiPolqTFjPi+yWalSqzjVRnvA=;
  b=oIUX9LrZ00oToC6fFFfpi98RFipWF5WQkbq5XgWwFdWVh9Ptq2gPXy3V
   SxW0TMZUEFNlMcPPE8dskKfG3/7ExjIf15Z7NI79o3xsBj5DdTkqmllwQ
   7+2Vz9C8DnUBTDW5OQWXPG9j1U9YzdB53+U5aRCsuBzXF+jHNg/XQTNku
   iEY/M4AjSYqpo2CzgUNdR6TT0BVc51bCmUSqgnt//I7Mtg9rkt8xjKsV5
   CQfCw6vP0ndD+X4k57RJ+FCH3/NHbRTYF9QRrdrqr4rBedIq/NP/4uPew
   n3qdUH09fp13YlNv1weY9SiW91yylYuD4iTO+M2jKJr7+VnnZ3naOkFdU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="353197508"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="353197508"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 13:39:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582386396"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 29 Apr 2022 13:39:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 13:39:03 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 13:39:03 -0700
Received: from fmsmsx611.amr.corp.intel.com ([10.18.126.91]) by
 fmsmsx611.amr.corp.intel.com ([10.18.126.91]) with mapi id 15.01.2308.027;
 Fri, 29 Apr 2022 13:39:03 -0700
From:   "Srivatsa, Anusha" <anusha.srivatsa@intel.com>
To:     "De Marchi, Lucas" <lucas.demarchi@intel.com>
CC:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/i915/dmc: Add MMIO range restrictions
Thread-Topic: [PATCH] drm/i915/dmc: Add MMIO range restrictions
Thread-Index: AQHYWc8n/YW/smHiiEyLf6QvALD3Aa0DtLoAgAOpCOA=
Date:   Fri, 29 Apr 2022 20:39:03 +0000
Message-ID: <93b22db44cf7494086285212d5d7615a@intel.com>
References: <20220427003509.267683-1-anusha.srivatsa@intel.com>
 <20220427054154.mrila5bwwk2durvv@ldmartin-desk2>
In-Reply-To: <20220427054154.mrila5bwwk2durvv@ldmartin-desk2>
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
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: De Marchi, Lucas <lucas.demarchi@intel.com>
> Sent: Tuesday, April 26, 2022 10:42 PM
> To: Srivatsa, Anusha <anusha.srivatsa@intel.com>
> Cc: intel-gfx@lists.freedesktop.org; stable@vger.kernel.org
> Subject: Re: [PATCH] drm/i915/dmc: Add MMIO range restrictions
>=20
> On Tue, Apr 26, 2022 at 05:35:09PM -0700, Anusha Srivatsa wrote:
> >Bspec has added some steps that check forDMC MMIO range before
> >programming them
> >
> >v2: Fix for CI
> >v3: move register defines to .h (Anusha)
> >- Check MMIO restrictions per pipe
> >- Add MMIO restricton for v1 dmc header as well (Lucas)
> >
> >BSpec: 49193
> >
> >Cc: <stable@vger.kernel.org>
> >Cc: Lucas De Marchi <lucas.demarchi@intel.com>
> >Signed-off-by: Anusha Srivatsa <anusha.srivatsa@intel.com>
> >---
> > drivers/gpu/drm/i915/display/intel_dmc.c      | 48 ++++++++++++++++---
> > drivers/gpu/drm/i915/display/intel_dmc_regs.h | 31 ++++++++++++
> > 2 files changed, 72 insertions(+), 7 deletions(-)
> >
> >diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c
> >b/drivers/gpu/drm/i915/display/intel_dmc.c
> >index 257cf662f9f4..ac7896835bfa 100644
> >--- a/drivers/gpu/drm/i915/display/intel_dmc.c
> >+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
> >@@ -97,13 +97,6 @@ MODULE_FIRMWARE(SKL_DMC_PATH);
> > #define BXT_DMC_MAX_FW_SIZE		0x3000
> > MODULE_FIRMWARE(BXT_DMC_PATH);
> >
> >-#define DMC_DEFAULT_FW_OFFSET		0xFFFFFFFF
> >-#define PACKAGE_MAX_FW_INFO_ENTRIES	20
> >-#define PACKAGE_V2_MAX_FW_INFO_ENTRIES	32
> >-#define DMC_V1_MAX_MMIO_COUNT		8
> >-#define DMC_V3_MAX_MMIO_COUNT		20
> >-#define DMC_V1_MMIO_START_RANGE		0x80000
> >-
> > struct intel_css_header {
> > 	/* 0x09 for DMC */
> > 	u32 module_type;
> >@@ -374,6 +367,43 @@ static void dmc_set_fw_offset(struct intel_dmc
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
> >+	int i;
> >+
> >+	if (header_ver =3D=3D 1) {
> >+		for (i =3D 0; i < mmio_count; i++) {
> >+			if (mmioaddr[i] < DMC_MMIO_START_RANGE ||
> mmioaddr[i] > DMC_MMIO_END_RANGE)
> >+				return false;
> >+		}
>=20
> return missing here
>=20
> >+	}
> >+
> >+	/* Main DMC MMIO check */
> >+	if (dmc_id =3D=3D DMC_FW_MAIN) {
> >+		for (i =3D 0; i < mmio_count; i++) {
> >+			if (mmioaddr[i] < TGL_DMC_MMIO_START(dmc_id)
> || mmioaddr[i] > TGL_DMC_MMIO_END(dmc_id))
> >+				return false;
> >+		}
> >+	}
> >+
> >+	/* Pipe DMC MMIO check */
> >+	if (IS_DG2(i915) || IS_ALDERLAKE_P(i915)) {
> >+		for (i =3D 0; i < mmio_count; i++) {
> >+			if (mmioaddr[i] < ADLP_PIPE_MMIO_START &&
> mmioaddr[i] > ADLP_PIPE_MMIO_END)
> >+				return false;
> >+		}
>=20
> for DG2, main should use TGL_DMC_MMIO_START? and then fail here
> because of another missing return above?
>=20
> >+	} else if (IS_TIGERLAKE(i915) || IS_DG1(i915) ||
> IS_ALDERLAKE_S(i915)) {
> >+		for (i =3D 0; i < mmio_count; i++) {
> >+			if (mmioaddr[i] < TGL_DMC_MMIO_START(dmc_id)
> || mmioaddr[i] > TGL_DMC_MMIO_END(dmc_id))
> >+				return false;
>=20
> this is handling DMC_FW_MAIN twice.
>=20
>=20
> Maybe something like this:
>=20
> 	u32 start, end;
>=20
> 	if (header_ver =3D=3D 1) {
> 		start =3D DMC_MMIO_START_RANGE;
> 		end =3D DMC_MMIO_END_RANGE;
> 	} else if (dmc_id =3D=3D DMC_FW_MAIN || IS_TIGERLAKE(i915) ||
> IS_DG1(i915) || IS_ALDERLAKE_S(i915)) {
> 		start =3D TGL_DMC_MMIO_START(dmc_id);
> 		end =3D TGL_DMC_MMIO_END(dmc_id);
> 	} else if (IS_DG2(i915) || IS_ALDERLAKE_P(i915)) {
> 		start =3D ADLP_PIPE_MMIO_START;
> 		end =3D ADLP_PIPE_MMIO_END;
> 	} else {
> 		drm_warn(&i915->drm, "Unknown mmio range for sanity
> check");
> 		return false;
> 	}
>=20
> 	for (i =3D 0; i < mmio_count; i++)
> 		if (mmioaddr[i] < start || mmioaddr[i] > end)
> 			return false;
>=20
> 	return true;
>=20
>=20
> ... untested, and may need tweaks depending on the answer to the question
> above on what range to use for ADL-P/DG2 on main DMC.
The above approach is definitely neater.
The main DMC offset is the same for all platforms.

> >+		}
> >+	}
> >+
> >+	return true;
> >+}
> >+
> > static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
> > 			       const struct intel_dmc_header_base
> *dmc_header,
> > 			       size_t rem_size, u8 dmc_id)
> >@@ -443,6 +473,10 @@ static u32 parse_dmc_fw_header(struct intel_dmc
> *dmc,
> > 		return 0;
> > 	}
> >
> >+	if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count,
> dmc_header->header_ver, dmc_id))
> >+		drm_err(&i915->drm, "DMC firmware has Wrong MMIO
> Addresses\n");
> >+		return 0;
>=20
> you don't like DMC and decided to fail it for all platforms?

<facepalm>

> >+
> > 	for (i =3D 0; i < mmio_count; i++) {
> > 		dmc_info->mmioaddr[i] =3D _MMIO(mmioaddr[i]);
> > 		dmc_info->mmiodata[i] =3D mmiodata[i]; diff --git
> >a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
> >b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
> >index d65e698832eb..235d1b721334 100644
> >--- a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
> >+++ b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
> >@@ -11,12 +11,43 @@
> > #define DMC_PROGRAM(addr, i)	_MMIO((addr) + (i) * 4)
> > #define DMC_SSP_BASE_ADDR_GEN9	0x00002FC0
> > #define DMC_HTP_ADDR_SKL	0x00500034
> >+#define DMC_DEFAULT_FW_OFFSET	0xFFFFFFFF
> > #define DMC_SSP_BASE		_MMIO(0x8F074)
> > #define DMC_HTP_SKL		_MMIO(0x8F004)
> > #define DMC_LAST_WRITE		_MMIO(0x8F034)
> > #define DMC_LAST_WRITE_VALUE	0xc003b400
> > #define DMC_MMIO_START_RANGE	0x80000
> > #define DMC_MMIO_END_RANGE	0x8FFFF
> >+#define PACKAGE_MAX_FW_INFO_ENTRIES	20
> >+#define PACKAGE_V2_MAX_FW_INFO_ENTRIES	32
> >+#define DMC_V1_MAX_MMIO_COUNT		8
> >+#define DMC_V3_MAX_MMIO_COUNT		20
>=20
>=20
> why are you moving these to _regs?  these describe the DMC header/blob

Yeah my mistake. While making the change they seemed like the right thing t=
o do.
=20
>=20
> >+#define DMC_V1_MMIO_START_RANGE		0x80000
> >+#define _TGL_MAIN_MMIO_START		0x8F000
> >+#define _TGL_MAIN_MMIO_END		0x8FFFF
> >+#define _TGL_PIPEA_MMIO_START		0x92000
> >+#define _TGL_PIPEA_MMIO_END		0x93FFF
> >+#define _TGL_PIPEB_MMIO_START		0x96000
> >+#define _TGL_PIPEB_MMIO_END		0x97FFF
> >+#define _TGL_PIPEC_MMIO_START		0x9A000
> >+#define _TGL_PIPEC_MMIO_END		0x9BFFF
> >+#define _TGL_PIPED_MMIO_START		0x9E000
> >+#define _TGL_PIPED_MMIO_END		0x9FFFF
> >+#define ADLP_PIPE_MMIO_START		0x5F000
> >+#define ADLP_PIPE_MMIO_END		0x5FFFF
> >+
> >+#define TGL_DMC_MMIO_START(pipe)	_PICK(pipe,
> _TGL_MAIN_MMIO_START,\
>=20
> _PICK?  Did you miss my previous review?

No. the thing is Main DMC with the Pipe DMCs are not evenly spaced. So usin=
g PICK_EVEN is not the right choice here. We also don't need to do _MMIO re=
ally.....
Unless I am missing something, this seems like the right approach.

Anusha

> Lucas De Marchi
>=20
> >+					      _TGL_PIPEA_MMIO_START,\
> >+					      _TGL_PIPEB_MMIO_START,\
> >+					      _TGL_PIPEC_MMIO_START,\
> >+					      _TGL_PIPEB_MMIO_START)
> >+
> >+#define TGL_DMC_MMIO_END(pipe)		_PICK(pipe,
> _TGL_MAIN_MMIO_END,\
> >+					      _TGL_PIPEA_MMIO_END,\
> >+					      _TGL_PIPEB_MMIO_END,\
> >+					      _TGL_PIPEC_MMIO_END,\
> >+					      _TGL_PIPEB_MMIO_END)
> >+
> > #define SKL_DMC_DC3_DC5_COUNT	_MMIO(0x80030)
> > #define SKL_DMC_DC5_DC6_COUNT	_MMIO(0x8002C)
> > #define BXT_DMC_DC3_DC5_COUNT	_MMIO(0x80038)
> >--
> >2.25.1
> >
