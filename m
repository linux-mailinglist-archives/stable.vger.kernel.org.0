Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B84D06B0
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 19:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiCGSkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 13:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbiCGSkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 13:40:13 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEAC4B1CC
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 10:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646678358; x=1678214358;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nJIO6jtleNGUghjKyKvOWoGsYdum/4O9pijs0CBNmO8=;
  b=CoIjVdJFWXK4Fd5IA80S7JuS+cV7qajquk6IJ6CFKhWU1m27lmdsHP+6
   CXLHdaClGNhRwYZ5mhT8OPcmqoos2D1Ds9mHZXLidjQgcQDwCmMvVCzb+
   KAcArYaLOYT7v/4F1q11Tm06tLE7KlSiaKTs+jx6csBkXymXU3GprESWC
   +p/XFBYLenpgNKATAfj7nvq+a3Jv5nGGWPWDnthaVVQ9xT/TyGbeyrX6C
   DCzAVsOlkimLWIVbmwQgyvuZMXkwwQy43xbv4JUhb8sPm3hBiKapyU/1f
   YOiqxYrapJdtKDNxMX/My1qzlVI3NSROeJUVTzHjQKGU4QJ7UFzBOfCsE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254198345"
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="254198345"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 10:38:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="595598430"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 07 Mar 2022 10:38:53 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 10:38:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 7 Mar 2022 10:38:53 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 7 Mar 2022 10:38:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BM63qJYw1CaCN5TYU9/Ae4X7l+PqpABHMHR0hiQ+JLg/0NP34CN4ocQrZFV1BuvKM8xxNs9lZxpw4wpOof74+mdOHgaAcTKysRz7JyDX7rK47/Mjg0SBrNxbTxbMGtTru5cf7b5FocmGq0k1k7HLQTwIA2U7VB8gOa9b0HbB5Mxx9gOlykiY8vaze+FxlQN8ozAEiTCPmQx1VTAAc3SJmhuJ8lMIhDINLDZV9/2IRMm9Rl3ayBA0SomoP/Di/vl3ZYiwig4UI/f40aTTmWuyC/r3Vt4O+cYfRFzrjDGstcCPe+C9w788rGeM+JTcawGdvKOvfsA6ZxZK6wP3EMrjPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H342DQNRv4B7YBPmX5HhAn+Ew7ckc4gYSJUgsv7Btnc=;
 b=TolX86t79zbEra0SL8+ch9owxb7qMsobzmYWt9EEPaQJmibpGP+2coDEhL7P+th2wVkw/DBSg0/1lQZbdKvtMJGU5tiA+TXuhmqfH+WkA78XgWl2TWDUOBzBbQUKYxLfF0XhLqYpQonNbRcLbPQMhmQN6Ef2zzU4MIxefMbg1er0izIZm5Xcexx4MTMf+1kWzHR/n0CR8Fe9Kzh19SNFiQWyiKh6xpQh/FsMroTVy0MMaYumZeX0WzAgbpvxNp+JLuIiZiXI65Vdt8fIq/LlcHeEDFKNZRDwsbE7e5ZfRWdfgUtQZ6uokr+xjQYQTy3DoOmpDS6VrEktgZ7Pt9lkig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5382.namprd11.prod.outlook.com (2603:10b6:208:31c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 18:38:45 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a%9]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 18:38:45 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Topic: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Index: AQHYKoV1oS8OxtgVzUaACL1TTVzKm6yo0oAAgAADzICAAJ7yYIAHY7QAgAN3GIA=
Date:   Mon, 7 Mar 2022 18:38:45 +0000
Message-ID: <CO1PR11MB50892E8184B6A45C27F15604D6089@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220225202101.4077712-1-jacob.e.keller@intel.com>
 <YhytnJGxStO0Gai9@kroah.com> <Yhywy/LYW38Aavxt@kroah.com>
 <CO1PR11MB508937A170C114A274CBE809D6019@CO1PR11MB5089.namprd11.prod.outlook.com>
 <YiNpANXX8hi1enjc@kroah.com>
In-Reply-To: <YiNpANXX8hi1enjc@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab2664ed-a156-48e8-7372-08da0069b603
x-ms-traffictypediagnostic: BL1PR11MB5382:EE_
x-microsoft-antispam-prvs: <BL1PR11MB5382769BC682A83E6D30FF79D6089@BL1PR11MB5382.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 52d7TVHaUYhPVj7NqiwYZRatRucGRXOMkkH7ZryITe0yhCDnSUZWXh1lsrQvFeZZByG9NduZ+bptDQ3kOxrKQ+cPhI6+9IjzDBY3Zd1GIwFCF7BZThy6/hkjktf/Mor7kPgEkhDoRGBhsxk9tIWxNvKoO+Zx/Xd06N5LGlcSY0XkK0y6fpRe8fPT4VtoVXtJOrJNTNQFCo1H4cmEtWYkZcnqj6k9GA0XoZQFp5vaWWS0H6St8OoPnOtuArCA+711WlvnEw6Ycz3Xjxx445v+bP3FbEPLE/QVsy6RdeIu2XE8D7F9PBLiht50/0dyJqOAR4GRZjJdMY+4+hronPWfYP/ORzCQLF5PXVKZW+/iHDJ+g4VH6iiBfp0uzltzjv9XRxcZslrT4zsVWvJeNt4YxYbelvMEYoWLR8iRWyhSroMiX10mrZrgj4P4k4F+JR2+qsRGaZG5l0hhV8eNlu9LVfykVzHN+O9spsTkv+PmLZ7oRqZOohUTcOOLucVqkB7D7JgRtpe0lgOYOYmt4UFm+t63f0omU708iX2fzsA7BUb66n7eOwtNMegDbODH+vPk0K9NPPf8oysiDH0goXL/JknZnuegdlwbYGz0jGsyFdpydj7+/vVLnIkfcpsvNF8ANjqamANAy1Wwqemo4uCtd5RdHTzDoVFyCoNYV1QiLX02jcqUqx01Nlno6JurL8rV4Ny7HH1DhzwnxkHsQTOTFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(66556008)(316002)(54906003)(66946007)(66476007)(4326008)(8676002)(64756008)(38100700002)(86362001)(38070700005)(6916009)(52536014)(8936002)(82960400001)(122000001)(5660300002)(2906002)(9686003)(76116006)(26005)(186003)(508600001)(53546011)(6506007)(7696005)(107886003)(71200400001)(55016003)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vfzQg7IiXr1JN+5mcRRCRlSWDjbZQjQyjvLa7PJXLwOV+LjG41lgMscmURMe?=
 =?us-ascii?Q?JYf/Kfi8ZZE71tdBxc4vlRB7cCT8krL7iVOqlLr4ycsVXmkV0jFrOnd3rlte?=
 =?us-ascii?Q?RmJPFdqU18a7WoSvwrMddvBfpqyEGeiONuxNacVAgCbp+Qi7N+tF/OCWJEEO?=
 =?us-ascii?Q?NE40a+oZYyUitVBRReV234oXO1zykLDgYn00r0e1YDfyoMiIMxjSIyPO3MRz?=
 =?us-ascii?Q?Sj88WTY+rFrO78zaVieM0uJuun+Pl5gsJsw/QN7yz7FbFfKvchTAkcQhB9St?=
 =?us-ascii?Q?+btskSFTc0kYySUmv+p8ALgZoG6QCwFTGF0Mcxdcmxgmiu1JLzkgxyy20V7l?=
 =?us-ascii?Q?r2k1WjEuWDy2GZjJOIDqjlxJV2ryuXyfQSUu9j3m7nOUr+gZBUOflVsecNAm?=
 =?us-ascii?Q?UshkzUyhUILTCo0+5I5OJdmIRsI1fOhmNngtA8tCK6Qj53qYPPJV2csnDPpv?=
 =?us-ascii?Q?TSq2V95DsM/b5yiG2n0zxz05xhKc9qGYVGgE+BDCVbi3ezmbKOyEbWU1kCYA?=
 =?us-ascii?Q?fhBY6tQ89Pr+jrJ3N0o1a1GLijf0RA1GpUzqp0sebjuJzSCzidfATmt8EQTZ?=
 =?us-ascii?Q?TxlqizXDurD2e+G6FzYRGqCSjYiK1rDYwdM7wcgfuQ/4FCxMMVl4HSeaHj4l?=
 =?us-ascii?Q?EEunPkxVYM9Gg4dH0rFRk5+QF6FvRSL7gxdVCOHs//KUhMdF4oa11nt18MYa?=
 =?us-ascii?Q?QhOKiP41p3tAnwoyZCx0J4nkkyciF87lbLMaakHjCwEPkyuBJJ0Sbkmx3YwH?=
 =?us-ascii?Q?tyVS9WgohhNUcDPL+Vk4ETeIV2enWPYirCA1tKk6mdY4zCm8zZeBBrITxMD8?=
 =?us-ascii?Q?USRexgRA8R+UXL+++82TvvRfhleN+GGk+aeqSoYGSHkRdzgARUoE5mUFpukR?=
 =?us-ascii?Q?ZcbCxdrroqt2GuJyj26/MDf/HVPsAgMQi28NwBajB7wcck65CnvWXtLhYDxJ?=
 =?us-ascii?Q?BfY0HbmusqbVfNootcHUCdLDI1zCFWTd8cjN/H4ILVZunkVpqSdx3s1hv4w/?=
 =?us-ascii?Q?/Ffm9RD2GJSaIq3xJED2W0l1pnXDy+XyQRh/doBqqA9d3EtwM3AB6s65kgur?=
 =?us-ascii?Q?kHEnHyz15hHgwuknhcEo3tiUC8NdMXsQF/93x+bYGBX+GyIWpRdngHfqX/yo?=
 =?us-ascii?Q?A4Ug92eL4T9A8GkU55Zci8GYFUchIuhp8zuMML4vIEiV2cxuIp7Lv6rvlNGo?=
 =?us-ascii?Q?svl0+JjiSFEYXLGC50mIXqULPO+/UPSPmyCt9oMktsk3YBk/4UM0zt4NoMtI?=
 =?us-ascii?Q?+MedG5XLz0t2HeJrNvVbo40jZDghGIcpb5RVc3j1MG2nkD4ikVGVxj+OVRKN?=
 =?us-ascii?Q?xxwQqYpZDgHgA+pSx70sCrL0jOFUBwZ7fur4W6PnSQh/8RSBe948o64CL8mu?=
 =?us-ascii?Q?6NL0Dsbk9azzSukA5u0a6JS0nNJpfNbkzcqKODNu7otJm9D4tFfIWz4xibrp?=
 =?us-ascii?Q?sJ/RJiC5PxOgd3CuB6N3rJT69myvhNvrqj6rEE8IqHGo4ugv+ou269IpbwyG?=
 =?us-ascii?Q?2DnbBk43LUpN5z+cmJwYyox8CN9CNfiKjevRWpBdWEGdriLB6jf45Mk9qQTl?=
 =?us-ascii?Q?IMMWY7l2kpnaYO5kPNxRX8wU2gvJdt6GwwVn6Wfvk93dk7Fp/OK26CWRE8dw?=
 =?us-ascii?Q?HcTwmchkmcgd5TMeDsjHK2P2w0HcsJx6RCmXTEO77r1Czop4s4v5vEarY6Ip?=
 =?us-ascii?Q?QL4IpQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab2664ed-a156-48e8-7372-08da0069b603
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 18:38:45.0342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iSgftIUI83YYjoMJWOnPidx/xQUSGHL4GpwMU4DOuP7oHdr17MzCHF22egRYs32FB+KcLvgxZiuexaOTFxpIoWSvQ7uybFN672vwutT/KHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5382
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Saturday, March 05, 2022 5:43 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: stable@vger.kernel.org; Jankowski, Konrad0
> <konrad0.jankowski@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handli=
ng and VF
> ndo ops
>=20
> On Mon, Feb 28, 2022 at 08:57:50PM +0000, Keller, Jacob E wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Sent: Monday, February 28, 2022 3:24 AM
> > > To: Keller, Jacob E <jacob.e.keller@intel.com>
> > > Cc: stable@vger.kernel.org; Brett Creeley <brett.creeley@intel.com>;
> Jankowski,
> > > Konrad0 <konrad0.jankowski@intel.com>; Nguyen, Anthony L
> > > <anthony.l.nguyen@intel.com>
> > > Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl ha=
ndling
> and VF
> > > ndo ops
> > >
> > > On Mon, Feb 28, 2022 at 12:10:20PM +0100, Greg KH wrote:
> > > > On Fri, Feb 25, 2022 at 12:21:00PM -0800, Jacob Keller wrote:
> > > > > From: Brett Creeley <brett.creeley@intel.com>
> > > > >
> > > > > commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> > > > >
> > > > > [I had to fix the cherry-pick manually as the patch added a line =
around
> > > > > some context that was missing.]
> > > >
> > > > What stable tree(s) is this for?$
> > >
> > > Looks like it applied only to 5.15.y.  Can you also provide backports
> > > for the other older kernels that these are needed for?
> > >
> >
> > Hi Greg!
> >
> > I sent a series that should apply from v5.8 through 5.12 (excepting one=
 patch
> that was already on 5.10 but not the other trees, for some reason). I als=
o sent a
> series for 5.13 and one for 5.14.
> >
> > The code prior to 5.8 still has this bug, going back to the first relea=
se with ice,
> (4.20), but it is different enough that I had trouble determining what th=
e correct
> patch is. Especially for the first patch which is necessary for the later=
 fixes, since it
> introduces the lock we need. I'm going to spend a bit more time later thi=
s evening
> to see if I can sort it out. If not, we may have to live without the fixe=
s on those
> trees.
>=20
> I've applied the 2 missing changes to the 5.10.y tree.  The other ones
> are all end-of-life, sorry.
>=20
> thanks,
>=20
> greg k-h

Thanks Greg!

-Jake
