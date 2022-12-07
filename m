Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B554C645444
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 07:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiLGGvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 01:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiLGGvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 01:51:48 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED472FC2A
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 22:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670395908; x=1701931908;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UVNr43OUPnCRV2dWHx5efCCsvgXOPwKUXn9kXSM9Kcs=;
  b=facw/x8FzLwf7rxaa2xcTTssCJLgQxPFxyFt/gON0bTd9TLQaIlBnVNo
   E7Fvigx390PjagqFWSgpSLOMLI2AHiwaO/duNdD+1E9FX/AlWU4iprKwD
   plblwpnyPJmEqs3E20UhKtdV8qLn+CqIRyjT0f+OFC47opmr1IuhlmGhM
   2XxaaavifRjX96wPt5hOLDpKcuayZucXMtuYAZgCac03D6I8b5RQd6/5F
   fyG7nr6lEO5WT9KKc683CGM6t1Ih9ddECmVcmJnbPynpNY1dJirCvwCbO
   uTXhrBzkQKj2LD2dlf/oxpsfgb/RG6uPyxPZr+ws0c1MAh2g4a/qiBXBj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="315533039"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="315533039"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 22:51:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="648612777"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="648612777"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 06 Dec 2022 22:51:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 6 Dec 2022 22:51:47 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 6 Dec 2022 22:51:47 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 6 Dec 2022 22:51:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHPvn6xR7fPTNQU3ucz9ObE0BNSwztFyU8ultYCvMifA6z0vXlH0i3GfJlnQGDksRi6dbS/5mVAWyFgqE/I/uXDWylLET7TKPtFXPU0RJlrlPT5hHcPhYGYsCbJK2aWNSKVAI3IU+FCZo965YpesSM87G3PQzBdGL/5WvQMyeulT2EAi7jIWSchbFadQd3ZR2cFum9/QzDgp9Npzcst7pog857lj4u8fUJesxXBcDmqOoMl1Iwrnk7dF3bJflvz12ZFwt/5ZTt3wdVmeflCWN+n/yhrZvGS93ZKtk1MTf/laU2aAN5/a/T7E1mQa1N793SfvKCuRLtK71ovtNburvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/1iYcuz+u+MUmyeXM9zAMm8hWRSQOEjEEa7Ui+XMvo=;
 b=Tqlprx28Odhbh4Nk97TNGfcT3CGInxB4AZ5hdukBY3oF8u95dBYZF/g7CPKLoZNF3Ld/KO5X3DwboCeeJA2yO1RkGNOAMCK09AFZEQxG6Woc3ps8ttAPRDLCsrJScgtg66ke1gSQIpL2olqBQlWGT+g3iKjnxGLNKSHsUVZLytRFb3mxJOHpTCdoqPDhJ0wiiBNhjuU+V+d/DFv/I2HpSNsbLg38WNFpQgVwdNh2fKZ50FTyWMXRcUiVHQCKtQLuOL5S9G2cGsbcnq1C/9wwnWuvi0+aUsbQ3Yecvbpz4YPaIQ0Om/5MqHaNVVhbOoOgXY4Z3C73uwgyAwtuLrjY1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5857.namprd11.prod.outlook.com (2603:10b6:303:19d::17)
 by PH7PR11MB6497.namprd11.prod.outlook.com (2603:10b6:510:1f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 06:51:45 +0000
Received: from MW5PR11MB5857.namprd11.prod.outlook.com
 ([fe80::c2b4:f5ba:6fdd:7ea1]) by MW5PR11MB5857.namprd11.prod.outlook.com
 ([fe80::c2b4:f5ba:6fdd:7ea1%9]) with mapi id 15.20.5880.013; Wed, 7 Dec 2022
 06:51:45 +0000
From:   "Chen, Kane" <kane.chen@intel.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm time
Thread-Topic: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm time
Thread-Index: AQHZCe/9fwtilz/470SQy9wHf2p7La5h4VWAgAAClKA=
Date:   Wed, 7 Dec 2022 06:51:45 +0000
Message-ID: <MW5PR11MB5857D26C66FA084280709384E01A9@MW5PR11MB5857.namprd11.prod.outlook.com>
References: <20221207035722.15749-1-kane.chen@intel.com>
 <Y5Ag6YhxcPPbs4Jr@sashalap>
In-Reply-To: <Y5Ag6YhxcPPbs4Jr@sashalap>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5857:EE_|PH7PR11MB6497:EE_
x-ms-office365-filtering-correlation-id: 654b480f-b56f-4f95-d3a4-08dad81f8175
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SxlnGYizaumAf2VufRW1Z8Ufm19x0VUXrkayygr1xIsN2FjPO3JBVxlrTdv46k1Hiz4oCxMiP9cxFPM4thJHyCa0s+SbPGbHep9BxQUyspYNQYVh/LfIKxUKzmZ9Caq9204RfRWY3nWcahgovkX76gLQlMt8lq9vQgf9eEtGlnpQg8mImP83GG2Wr6ktQq35zYcpArE/5xweBOCSS7PPMf3WCNShcCwB2ame5pwe+gpxYm9Q/l9Uvi3vaJT/8cy8LImNCddjxg7JES40Z1tJWWLQpcjCepltUkLB5zJgACPyjHTdR5WA1HO1irAcf616DoMWWfop+ZICRmzbbwLZ0LhjIXwH/BJGaCwddoVYi5cFZaoL0XNRD8eh5LpDpd9u/pijREqxxdXVsj0fQyVGPdgUlgais3sUbb/qftsJvULNI/KllcT6DT+jw8YM+T0zChHd/xwPjs41pDrHpLoJeUjln1fxodhPquXloFkT8abgGEc9Kz/o143DmVLcyhWjIzm16gAtYYW75OmUlAL6YCgSJ3uc4sWPbnv0xTymSnUcaQBhU8TIy1L/enVjL6DH9Jzc76vob86DjH7fxQu6CYlQZmc2jFa2ph6b2nTZi8UnH3bwYhBdL0G/3kVTSBwcwTQ6Mzls3RbIWyJEWLIcPtc8ii5yZPv0lMFYX0e0qyS7tWa+oOMqVpibwi8ciCNPyYbWxzjPP5R+UKE2w5V1Sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5857.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(346002)(39860400002)(136003)(451199015)(186003)(41300700001)(38070700005)(478600001)(52536014)(66446008)(6506007)(66476007)(122000001)(66556008)(6916009)(55016003)(8676002)(64756008)(33656002)(38100700002)(7696005)(66946007)(4326008)(76116006)(82960400001)(8936002)(53546011)(71200400001)(83380400001)(86362001)(9686003)(2906002)(316002)(26005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GluwVaHz2HaPEfe1eYAkgHIWN9vhZQGzJBC2qfug7Q8a+bof2B4S+d6D/t1o?=
 =?us-ascii?Q?Mla0XQv/o1mjg0faTysqwWRfm99S+u+Tn4qo9G7gDXHN9GOhI3v+rEgYWq7d?=
 =?us-ascii?Q?GTa9jb+ppMkmDh5NKck/jCGydntn/W/mx9hgbosySR5f4vYDZMD7Wck+TaxS?=
 =?us-ascii?Q?oD0EtY74okpFV4sfHCiRoZO+TPMITppxmoGB9hPhcP4ry5IG0otRZRgVC+Ok?=
 =?us-ascii?Q?q/hVFf/GhUeseAfZUbg0zQbSDTnVvtl+ZnabTDFUIdoY+T7NufJkwnoGvMGa?=
 =?us-ascii?Q?tXlZ/nodroy8UvQg/iXOgmOgv3HHi2PhAEsr46SHbznCzyX1+bc4OASnfZLv?=
 =?us-ascii?Q?2fr1VXP9JkX57VeZ4gOlqrogQtnNV2XvDv7hhR8SsXWyAzQiw2KT92fZLxVl?=
 =?us-ascii?Q?g83BCQjJeYub+Qc0RhutfDgJBCM6lAlCn6ZcsBRPq2ai01IgJQcgJdtTzaBQ?=
 =?us-ascii?Q?xx6LXUQT4bELDSpyMLn6gpkhTaRna9T+JpUT/8KeIntxm2Q4GQ7mHNL4YdBY?=
 =?us-ascii?Q?rfKmdNUZ5kHUT6tOHD0kErf988cti5j1MPgx40sD+iZH5JYVCa66XPWOEL6c?=
 =?us-ascii?Q?Jsh4Jlqc8sb+EnSbzASKK9qc2yAKzXoWIbzsdurIIguKvE/P7yY9O/owmOAe?=
 =?us-ascii?Q?qQLZW3HRJZTn/BjnnaydUi/ilsS4ibyoUHtMFz1OhLmUPK0e7qGDqrH0nWMp?=
 =?us-ascii?Q?VfKUX+GYdANr5tfVJi1ZUxDVLXEzf+sQ8BqjAzJyLWhj0DlX0qWTtUU4leSB?=
 =?us-ascii?Q?MJLlryefEr8y8R4syPyyycRslRIPzYN32kxuSvpzypPqIWP0NlwZxq9gTXpc?=
 =?us-ascii?Q?FHpbaXf2SG/GUUHuDC9tyg1af9sNe9dzhsB3cF918+RCqovqeMwPZRm9XScv?=
 =?us-ascii?Q?VdvPVLF6G/ZRyE2Iuz4RxP6WrE3qSfgXpQd4SFTOboZ2dmFniv4qpgPV5dV1?=
 =?us-ascii?Q?0kqo9KlPt6fSgAEiR6KgzXRqzyE3d0MwSckNjaJfcIR2Rx1RtoPjt5S77XXi?=
 =?us-ascii?Q?5L3PEPCxSi9AcivCFRusGFCOe5olLq1Wq5j1xX3wmtGCiJ7i95GSVw1EWZTB?=
 =?us-ascii?Q?XbD6Xb5zXg75ZxvWH+HIGuUjc1vlQ0eNAV2qCEtBhcFkm9qkc4rgQLWWDwPW?=
 =?us-ascii?Q?DND7hdpMeH1ehFC2EneIEXqOFFYa4FbkOFDdufiNRYnwP/3QT5N27VwTLqTf?=
 =?us-ascii?Q?P5O7M9xazUOgZGdhiMUm/BMzY1JEJgFgw1EGQWFUPhIh5Kc1vp921/wjhrRf?=
 =?us-ascii?Q?5G+TuGD42ATwsVw+DtvgVnESnyUsIZuGE9q+sihyIxovZdEdzZktAzkFCZco?=
 =?us-ascii?Q?d0iMHUABOXjbJMrlfefmf92SglSRpCJSoC7BVp9/HReiaLuE0DuTd1x0abJy?=
 =?us-ascii?Q?HhWYAY6YAgMtWlUPzCqywqUs+UmDYb7pCFEAuBMP0Hh4thXukrQTwydHpjTv?=
 =?us-ascii?Q?aJLcuxwbRe6sj3rcA6LXm0jitC9WH0VvctcOryArAoLlf7nu5bZdik0GPUIQ?=
 =?us-ascii?Q?LWJwA7KTctANwYH4lr4Qz+YloapB4UaZIXcjUawQaD6vxwa0mM7E7asbOiuX?=
 =?us-ascii?Q?kUMcY8R30iSMQgFNlAnq6MZ3c1qBP732iXBZvdSx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5857.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654b480f-b56f-4f95-d3a4-08dad81f8175
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 06:51:45.3603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6HpSirb752OzFhP9csXQL3gJPijQmDSkYrgg8z54NtlpEx9fNPwzfvt1ZBKENugYWjH1ZgWbAASYf3UdXygu4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6497
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Wednesday, December 7, 2022 1:13 PM
> To: Chen, Kane <kane.chen@intel.com>
> Cc: stable@vger.kernel.org
> Subject: Re: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm t=
ime
>=20
> On Wed, Dec 07, 2022 at 11:57:22AM +0800, Kane Chen wrote:
> >While runnings s0ix cycling test based on rtc alarm wakeup on ADL-P
> >devices, We found the data from CMOS_READ is not reasonable and causes
> RTC wake up fail.
> >
> >With the below changes, we don't see unreasonable data from cmos and
> issue is gone.
>=20
> Thanks for the analysis, I can queue most of these up. There are two whic=
h
> won't go in:
>=20
> >cd17420: rtc: cmos: avoid UIP when writing alarm time
> >cdedc45: rtc: cmos: avoid UIP when reading alarm time
> >ec5895c: rtc: mc146818-lib: extract mc146818_avoid_UIP
> >ea6fa49: rtc: mc146818-lib: fix RTC presence check
> >13be2ef: rtc: cmos: Disable irq around direct invocation of
> >cmos_interrupt()
> >0dd8d6c: rtc: Check return value from mc146818_get_time()
> >e1aba37: rtc: cmos: remove stale REVISIT comments
> >6950d04: rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard
> >IRQ
>=20
> This one fixes a commit which isn't in the 5.10 tree.
>=20
> >d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()
> >ebb22a0: rtc: mc146818: Dont test for bit 0-5 in Register D
> >211e5db: rtc: mc146818: Detect and handle broken RTCs
> >dcf257e: rtc: mc146818: Reduce spinlock section in mc146818_set_time()
>=20
> This one looks like an optimization.
>=20
> --

I'm sorry,
I thought dcf257e and  6950d04, 13be2ef  are also required to avoid cherry-=
pick conflict
After checking again, dcf257e, 6950d04, 13be2ef are not needed.

Here is the list I would like to pick
cd17420: rtc: cmos: avoid UIP when writing alarm time
cdedc45: rtc: cmos: avoid UIP when reading alarm time
ec5895c: rtc: mc146818-lib: extract mc146818_avoid_UIP
ea6fa49: rtc: mc146818-lib: fix RTC presence check
0dd8d6c: rtc: Check return value from mc146818_get_time()
e1aba37: rtc: cmos: remove stale REVISIT comments
d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()
ebb22a0: rtc: mc146818: Dont test for bit 0-5 in Register D
211e5db: rtc: mc146818: Detect and handle broken RTCs
05a0302: rtc: mc146818: Prevent reading garbage

Thanks a lot

> Thanks,
> Sasha
