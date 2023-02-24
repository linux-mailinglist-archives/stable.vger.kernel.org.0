Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BEB6A1B79
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 12:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBXLic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 06:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBXLib (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 06:38:31 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAF2E3BD
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 03:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677238710; x=1708774710;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0RuxI20GrEOxodbINUHST8Zju+dUp5ddnjj7XJoEpAs=;
  b=iKlu4stO93YHy3T+p6F+JKa96Y7NKwfndBfLQqFx/xzK5qzdFG2tgVs9
   tBi9KgfViE4TWqq37wcTBOy8j1mJIa7BrIP6WcPeq/inU66AjU1k7fWFm
   SjH1hokEQ8N7QpuQso41QjOn8sh8Rw3qesKg7bvWkkxbpWVnW4poP4ScY
   y1ChOV/As4k5SkzScsDE2CCLzD9deWfZ+dbQwCIAt7VnNJ7mViOYsljo3
   K6wkm3Yj5AaR+vRZlCtWBsBUw8MRlCuJkjZjQjaODQhPVIXUgSDH3BqJy
   0Le7E3Vj1tEQP/RkoyxR+2gjtuxTwhgzZl9If+20siuTdUL3B1JshIQoX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="321657588"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="321657588"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 03:38:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="846919986"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="846919986"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 24 Feb 2023 03:38:29 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 03:38:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 03:38:29 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 03:38:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNw1GTK5u/Z4oPP3BUaJXmCTU2Vlx/dCDMfa/yaYbSLnWuVxRWeTZ404qF8X9u46tGzIs/J5OopljMtwq7y352JRgASme5M06BnRYX76qMeb2+BOcUACAtKCL7D3xcGeDBiaNbh2ixQKdlln8qRrxUtCSDi4BfcEzR0NGG/9FwFWTRDu5QhL8liAQ3OiR1f4c5Mt/FW8iMYnXR3x5lRdIrw0KcMJij/kjqNP3HS30bs5sOyQPKDbm7ijI7rGKkirvWFfiUhkKUZj4FoOedgR9EX8efoIgJe8inJamWDOhV7bxyG1VkKl6QiGwPRwkyXFrsvATswuUA18ciScGLQyWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgV6gnM6j+RWIz/IB6EdNd5yeLy2dS1izi4nG1+MR3c=;
 b=HRMTZ9Sajn2vM2j20qS2v42Svyve7OB3M0zwM4j0G7lVxyBL0T5WMtzrHa7Xujt/qyDDQimy8t9WBZE7TCQnAb+WxjtdM62SkYQWOVR9yP1FT4x/zfbAEE8Yw3HME2K02asOjli2cCdvfxyP/FSvO3RcuqNZU9HI4gRDW29evpyAZQ/Jm+GxwUTcBLUCQxg3sRPDo7WCBjiQyfrX5UWY+I8Dj9D7Mhc4hmwNniCbx3sDTwQENY2YJXmLFHKgDgNJ6hotFKNQijY18kv5rrb8azouQTICtx+qILmIGQC/1vafM/7fKGS+lJ9q+2F+6WdnyaW2GjySMNb+vbzkXvB2aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6360.namprd11.prod.outlook.com (2603:10b6:8:bd::12) by
 SA3PR11MB8048.namprd11.prod.outlook.com (2603:10b6:806:2fd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.20; Fri, 24 Feb
 2023 11:38:27 +0000
Received: from DM4PR11MB6360.namprd11.prod.outlook.com
 ([fe80::1b38:222d:6496:fdd1]) by DM4PR11MB6360.namprd11.prod.outlook.com
 ([fe80::1b38:222d:6496:fdd1%4]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 11:38:27 +0000
From:   "Shankar, Uma" <uma.shankar@intel.com>
To:     "Shankar, Uma" <uma.shankar@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Nautiyal, Ankit K" <ankit.k.nautiyal@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "Roper, Matthew D" <matthew.d.roper@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Intel-gfx] [PATCH] drm/i915/dg2: Add HDMI pixel clock
 frequencies 267.30 and 319.89 MHz
Thread-Topic: [Intel-gfx] [PATCH] drm/i915/dg2: Add HDMI pixel clock
 frequencies 267.30 and 319.89 MHz
Thread-Index: AQHZR0DHyHgl4FVP1k+wZKb4F1AHGK7cEeNggABgDoCAAAEvkIABhkAg
Date:   Fri, 24 Feb 2023 11:38:26 +0000
Message-ID: <DM4PR11MB6360316C720AC62E145EFC04F4A89@DM4PR11MB6360.namprd11.prod.outlook.com>
References: <20230223043619.3941382-1-ankit.k.nautiyal@intel.com>
 <DM4PR11MB63601AE85E8ACE5DBD2B1570F4AB9@DM4PR11MB6360.namprd11.prod.outlook.com>
 <87sfew37h8.fsf@intel.com>
 <DM4PR11MB63604643667CCE719F236EFAF4AB9@DM4PR11MB6360.namprd11.prod.outlook.com>
In-Reply-To: <DM4PR11MB63604643667CCE719F236EFAF4AB9@DM4PR11MB6360.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB6360:EE_|SA3PR11MB8048:EE_
x-ms-office365-filtering-correlation-id: eac1bd32-1e00-4095-47dd-08db165ba511
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zeS9SbrT1T0i+0BzDRhHMcZuCGqTps/Ui3/Ox7WMcLUa+ZM2pNFpDh0aa0TiXM830sjdBgcyfegq8yXLEySS9KJjwJIUgzbgpDFueet43EXs6eDrRVoYUb0W4p/x9kabfKYkoIN3D/jMyFfuTkjHcWBZwXsY4A3OmOAx9NAV5T3XxH5MAaKXCm1yjECLpkiXrvajw/17po2VAA9+2KPuH2X509htOrlMl8Ew7t8laoJHBwV67w/EknMWPP/mC8rANUNxGeLAdvs0bqP7Pug5DAPklH3PY1PsMDw0jiXr25EqF6xjtzFNfAsRVpLEqJ+0DEl7X1/+HTziKKwwIkbDCwfOiCesmFrncIdmvmulOU/w7zX1mLN/RL973aqURmKbOHVwjqOjOLwdLJwdA9DEjJ9C9z28mYdnRU2KXv2PrYgSUsD1RzLbTvZTZGqp8YSKu9vYAPpMjlxZtEqJoXp8jkMggqPd3xQEH3mq35jkyhB/WPmZERdBPGYzP0YW00bJju2K1Eo10r5A7dZFtrKxE0BTK99rTXP8F9sY8WX+X/WABQQjxXF0aDQTe0J6QXa4eody7UF3y5RAaolV1mqg0L4EXbbtNfwRlms1I4BTSG71Ys8ntmN9IaNDl871oxN/nLz+fF2kef54pvG8fq1GqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199018)(38070700005)(33656002)(86362001)(55016003)(7696005)(71200400001)(316002)(6506007)(54906003)(478600001)(110136005)(83380400001)(186003)(26005)(9686003)(966005)(53546011)(8936002)(5660300002)(82960400001)(41300700001)(38100700002)(66946007)(66556008)(76116006)(66476007)(64756008)(4326008)(122000001)(66446008)(2906002)(8676002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X+X9TKa0tdfbnMEtprw6LKy8YRMwilUA6/HB0dbAc2hKV9Stvyp4g3Flo8p8?=
 =?us-ascii?Q?mnt82N1C7eb9dZchSJcyQMnjVtWZ5NGQUrDM86qXEaYPbAxitAHe/V8JuI/t?=
 =?us-ascii?Q?8Bxe4VcJKf+L393vPA5mvd0SNNCCQlPBeThi/CDBqFA71VnFBaZum82Ec8Kg?=
 =?us-ascii?Q?fX/e8N/wVD6GTU0fRVoDelR76orTIYAy+gc9GCGEl6F2lh4LK90qDcayM8vS?=
 =?us-ascii?Q?c0+CBDUWy08YZstrxDgtOMjTjv2Bs1RII2uv1FMEEMmlg09RDk4d7LsZRt7j?=
 =?us-ascii?Q?x8EvTA6LXaEYKfuTP5CxB0+d7V+skRE0eAfScFauq5C4+kB1OOuTmWfULySl?=
 =?us-ascii?Q?lLuOgYITL5ZG4dmGL13kNDRbv4EzO9unefcp+Fb5erFeUXnkyhZKVcK1KsqS?=
 =?us-ascii?Q?l5pkWB7d6cG/4CGem27rXII+jf4nGYIcX1CilVJua+yZqZfngCedaY/l3t6W?=
 =?us-ascii?Q?1Hb0Hc/CJPi7baMC8ewt7g2EP10IEUrhobQurKqf0Hn7XtKTfxDttXY1CWRA?=
 =?us-ascii?Q?do84Nh85obIekArsVNemIl2aaLOTuDfHeQQf36BJOYCrG/JQKTjXi0rIPftL?=
 =?us-ascii?Q?CoAqFKfQngr4f5eM7C7ebzj1JKGuctfdxBgPpANGUKr1b3e3xwUiKddNdjiu?=
 =?us-ascii?Q?i8RSvJi66FXTMWxiJaio99tmaWRwEyZFYj1uRMWFJxCExDyphaZauNuwhpMD?=
 =?us-ascii?Q?wQIGjxgM3MS1yxT2vzkrslL42EMp/kQi1DYyGvNk0+reQqCPDUen5EQzttIl?=
 =?us-ascii?Q?Fttx+cn46EuEWgtfEtQ2mgSKyQcua46kTxmSqbUj2bmEb94pTrBbSZtifNQd?=
 =?us-ascii?Q?dGjp+zgQGw4AwXbFFA0xWZgk/0P1AZoIHrzZyiuxf7tVui1w/S8nyZgUSA5k?=
 =?us-ascii?Q?3YUEyG21FiLgeEgiTJ3ViaA0KqwBSFe7ch9WvBWvy7LYM/6pPR3hmZCn+LY0?=
 =?us-ascii?Q?vHbViFu8gobLitUsVgAbvfYNAtxwxP/S7uHdXvN1Mpt8BbOuw5qZzDse0oHj?=
 =?us-ascii?Q?+QxsfIicC125oV3/gPVPi3L3wBnCoDX6To/8/VZFpFRlHKF+cm1ZwSJN+OKj?=
 =?us-ascii?Q?txzzTReaXXX2cJy0hYRx9CVUTyGiXcigek8JSPghhu2KkI55mp4NamD4upYM?=
 =?us-ascii?Q?s/mOODCit9X9uA+okx3KemhVGqBYfhzkM7mvSTrMhh87tuaKhucEOMw5qV06?=
 =?us-ascii?Q?zOHvO6CO+B/rse4aRylwEZUDS+Ju2oPtqUjjzqGzIaO2oqLUGsL+YXPMDCWn?=
 =?us-ascii?Q?vrcM/i2nJ39DDpSdZ9sbHQDUK+DItnOvE1+fOGoxg07tIUAFSRJlBa+zNhIT?=
 =?us-ascii?Q?XYEqWCnbMkA8orQztRWxLGThXRyf1xybwYC2flSkJsn9ENtpf3a7xBmDxIrI?=
 =?us-ascii?Q?d6MMuf5QuaTqTlVo/deRv6n7YWe5zzaunFDmKCKSHUJ5uCgHUew2rPVgZpC8?=
 =?us-ascii?Q?/tNA04E5npPQHeJFMcy3leuqUB/qFvq2+Xr+atb/hDCG7VaL8vjw5BuoGxh4?=
 =?us-ascii?Q?qtHbOuQFbzmEGjfEZWf/7dZ/m26NCRezxHZoFqrVp8CCt+44vIfMlg18Ltuy?=
 =?us-ascii?Q?jzJBsThf0EHsfTMsGBLXyfVJaMZn+ZSrQkDLK9rW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac1bd32-1e00-4095-47dd-08db165ba511
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 11:38:26.9953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Beb4BS53RFntbgI0Fv+s4nnytZTtjdEicjFiZUBuy5bEx5K/WqfBQREIGCMYZmXOPnQWnY/Nf1CHXFIN69uVLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8048
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> > On Thu, 23 Feb 2023, "Shankar, Uma" <uma.shankar@intel.com> wrote:
> > >> -----Original Message-----
> > >> From: Nautiyal, Ankit K <ankit.k.nautiyal@intel.com>
> > >> Sent: Thursday, February 23, 2023 10:06 AM
> > >> To: intel-gfx@lists.freedesktop.org
> > >> Cc: Roper, Matthew D <matthew.d.roper@intel.com>; Shankar, Uma
> > >> <uma.shankar@intel.com>; Sharma, Swati2 <swati2.sharma@intel.com>
> > >> Subject: [PATCH] drm/i915/dg2: Add HDMI pixel clock frequencies
> > >> 267.30 and 319.89 MHz
> > >>
> > >> Add snps phy table values for HDMI pixel clocks 267.30 MHz and
> > >> 319.89 MHz. Values are based on the Bspec algorithm for PLL
> > >> programming for HDMI.
> > >
> > > Looks Good to me.
> > > Reviewed-by: Uma Shankar <uma.shankar@intel.com>
> >
> > Needs Cc: stable for some kernels back, when force probe was removed fr=
om DG2.
> > Please check and add while applying.
>=20
> Sure Jani, will do that. Thanks for pointing out.

Change pushed to drm-intel-next, Cc'ed stable. Thanks for the patch.

Regards,
Uma Shankar

> > BR,
> > Jani.
> >
> > >
> > >> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8008
> > >> Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
> > >> ---
> > >>  drivers/gpu/drm/i915/display/intel_snps_phy.c | 62
> > >> +++++++++++++++++++
> > >>  1 file changed, 62 insertions(+)
> > >>
> > >> diff --git a/drivers/gpu/drm/i915/display/intel_snps_phy.c
> > >> b/drivers/gpu/drm/i915/display/intel_snps_phy.c
> > >> index c65c771f5c46..1cfb94b5cedb 100644
> > >> --- a/drivers/gpu/drm/i915/display/intel_snps_phy.c
> > >> +++ b/drivers/gpu/drm/i915/display/intel_snps_phy.c
> > >> @@ -1419,6 +1419,36 @@ static const struct intel_mpllb_state
> > >> dg2_hdmi_262750 =3D {
> > >>  		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),  };
> > >>
> > >> +static const struct intel_mpllb_state dg2_hdmi_267300 =3D {
> > >> +	.clock =3D 267300,
> > >> +	.ref_control =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_REF_CONTROL_REF_RANGE, 3),
> > >> +	.mpllb_cp =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT, 7) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP, 14) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT_GS, 64) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP_GS, 124),
> > >> +	.mpllb_div =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_DIV5_CLK_EN, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_TX_CLK_DIV, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_PMIX_EN, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_V2I, 2) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FREQ_VCO, 3),
> > >> +	.mpllb_div2 =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_REF_CLK_DIV, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_MULTIPLIER, 74) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_HDMI_DIV, 1),
> > >> +	.mpllb_fracn1 =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_CGG_UPDATE_EN, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_EN, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_DEN, 65535),
> > >> +	.mpllb_fracn2 =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_QUOT, 30146) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_REM, 36699),
> > >> +	.mpllb_sscen =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1), };
> > >> +
> > >>  static const struct intel_mpllb_state dg2_hdmi_268500 =3D {
> > >>  	.clock =3D 268500,
> > >>  	.ref_control =3D
> > >> @@ -1509,6 +1539,36 @@ static const struct intel_mpllb_state
> > >> dg2_hdmi_241500 =3D {
> > >>  		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),  };
> > >>
> > >> +static const struct intel_mpllb_state dg2_hdmi_319890 =3D {
> > >> +	.clock =3D 319890,
> > >> +	.ref_control =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_REF_CONTROL_REF_RANGE, 3),
> > >> +	.mpllb_cp =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT, 6) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP, 14) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT_GS, 64) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP_GS, 124),
> > >> +	.mpllb_div =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_DIV5_CLK_EN, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_TX_CLK_DIV, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_PMIX_EN, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_V2I, 2) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FREQ_VCO, 2),
> > >> +	.mpllb_div2 =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_REF_CLK_DIV, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_MULTIPLIER, 94) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_HDMI_DIV, 1),
> > >> +	.mpllb_fracn1 =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_CGG_UPDATE_EN, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_EN, 1) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_DEN, 65535),
> > >> +	.mpllb_fracn2 =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_QUOT, 64094) |
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_REM, 13631),
> > >> +	.mpllb_sscen =3D
> > >> +		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1), };
> > >> +
> > >>  static const struct intel_mpllb_state dg2_hdmi_497750 =3D {
> > >>  	.clock =3D 497750,
> > >>  	.ref_control =3D
> > >> @@ -1696,8 +1756,10 @@ static const struct intel_mpllb_state *
> > >> const dg2_hdmi_tables[] =3D {
> > >>  	&dg2_hdmi_209800,
> > >>  	&dg2_hdmi_241500,
> > >>  	&dg2_hdmi_262750,
> > >> +	&dg2_hdmi_267300,
> > >>  	&dg2_hdmi_268500,
> > >>  	&dg2_hdmi_296703,
> > >> +	&dg2_hdmi_319890,
> > >>  	&dg2_hdmi_497750,
> > >>  	&dg2_hdmi_592000,
> > >>  	&dg2_hdmi_593407,
> > >> --
> > >> 2.25.1
> > >
> >
> > --
> > Jani Nikula, Intel Open Source Graphics Center
