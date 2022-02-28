Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F754C7B34
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 22:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiB1U6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiB1U6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:58:33 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39982BB01
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 12:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646081873; x=1677617873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JpsgJA06jTVSC70q0idvq9G4jDv7L/XErRpXVbj0HFQ=;
  b=SgM7Wx1097NRg/K0a/RP95g6wnPMk+QuYbo8VB4P8mgj+QQDUM3fvDBk
   Wj/q4pGX47k6Qr9Z1FbzVr78sbIkErHiFX4uiPzBbsOio9leV7fuMVlac
   Xc35qzcfJZq8zQiQggYEVE3m1guNs+zxj38M/+5QGcG3cCw1djR5jgukd
   Mq0qiY5O4sm10BYug+y0nYq8HwZT9qoHjspATpHQ6wkrTHzhQVBsVzNH5
   ocwa1coDpL8Uu48zGjqhAjq8LvIHuw9jxEwMZV8rpB5gy09wsol/E3Rom
   FUKvqMuN5PUd37Abd1xVilM/sawGp5qTqRrFKJityWg26wZjpdTrV61Rz
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="277647352"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="277647352"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:57:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="544862105"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 28 Feb 2022 12:57:53 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 12:57:53 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 28 Feb 2022 12:57:53 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 28 Feb 2022 12:57:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2UdB01isx4gfgYbRAwhc4+8J1UVVPTVqD4cDWsr9lsiTL0j0Mn9mkxuxdgoEM08VEUOMNfOmfsELjcOk0cYpwKLEGEr9SRWimjo001c17BUFfB1ns5I4TtiIPVy9RDjq9zLzvIdUQQSQzZMObpXrShsCgqjdVmi6G03C/3l7eelsBUWdlJlpDNW5AUb8NzaB3ntwr3vhBuspPCKXXkjhu2/Bf4iCYPfXqHpnrO78SGCBBt5DLjrAASA+yg8yzvPkEwSz6CU/WgNCeYHLdY3KDhOa47L1h6ANzESOQGfke+CSq40Na7Ja00RH06S9PvsYQ1oRWkNEQ4AXsKSjisE9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPdcRX0dVwJrakN+mMDp4jzUNIGHhsuDZqOrGhv859s=;
 b=MkUOg7KeCbLEXo/6tMxyl0aXswnCrdAEkj1L9hpbB7D3bIyWaGYTXUhbPBxb1JClQxv/pf4E8FmoKGUAU1mcEOirdjg53a3g4WmLjBIJ5GyzeJJDCjdGMsWCOPTNfzMN47MEzqBfmMA/57zD8DRCKCNxKDDgt3X6S5YrJVtXQRmx5xyXx+RIYor0V5rmQwaspBBi2n+I0gue7wE3FsAJmRgfgAZ2Q8sgnBojCKNzv5JHllbu7ToR7LFcszygz8jlaTKN7MX2QuaOEPdB0E6d3g+aHlCGFgstBFmQfW6+ADYkaIiI6SjCjbbvwudoLMe0nRCNxJMm9FyxIvN34rgHZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN6PR11MB2877.namprd11.prod.outlook.com (2603:10b6:805:5b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Mon, 28 Feb
 2022 20:57:50 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a%8]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 20:57:50 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Topic: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Index: AQHYKoV1oS8OxtgVzUaACL1TTVzKm6yo0oAAgAADzICAAJ7yYA==
Date:   Mon, 28 Feb 2022 20:57:50 +0000
Message-ID: <CO1PR11MB508937A170C114A274CBE809D6019@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220225202101.4077712-1-jacob.e.keller@intel.com>
 <YhytnJGxStO0Gai9@kroah.com> <Yhywy/LYW38Aavxt@kroah.com>
In-Reply-To: <Yhywy/LYW38Aavxt@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c160198c-4b4b-4df0-4ab9-08d9fafcfb1d
x-ms-traffictypediagnostic: SN6PR11MB2877:EE_
x-microsoft-antispam-prvs: <SN6PR11MB287753314AC16916EC065482D6019@SN6PR11MB2877.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eKOZL5ykF7H8zvgGMFepB234UNfebLH2rvMNrfe5KKnzqk3hO4n1czMCgcBa4ZL1wMaJLz6TrFz3F5fbe3MguQ4yCNfThfY5kdNc3LMebgwkCe0IFlu5BQSnCqon+4PeLNOkoVpB+1NR+N5tkxniVtYN8BV+UOxv3baRxlDgtVse5cFVm5bXImFM9AKGQI25f0p/ewpQjepYtie6hSo1kvtpKmp+QStTZC21xxJ7+YGmmiiqTZ4YBlBToiIwIcqSTXBvErKR0CMKXK1A9L0aQR1yfMLBJ/yNLj7evn/EGzkVbOaD/itD1zPxsjhYtnzegZDnzJpPwGTf/pnG9kN123m2OR034qp8hptya2vJDPpZGdI4QT2osuId4avEZS+6fov1N2YxHlgRcfgsgYaEt2trfoA1xF81fh6jz6LMqFw7A+gVTP7mbAp+/vbAWro3wmxnksp65iC5YLmg2Kca4QuugYGtQnLjUxFVCrW7z0gIAusPAdzhVUmHWoZmBd6e0/D7N3AgHfcJXryLVaGnDvfHxK19UU84fcyaXMvCJgDNBNNQY509Unr7yxo/UpWO5yVRo27/iwRzxUkGKzCPfwk45Qhw6dwh/K2RUNxsRHeclt0DkeF1IeR8ZWKsU+jOIsnughI2BKkVZqZ7XwjNlf0q81xyeXLglahIKHqbPC9KPUf7bV0MmXYn2XMrZqNaAs7JX7IOfUqWyLUq6AjsvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(86362001)(122000001)(107886003)(4326008)(508600001)(66476007)(8676002)(66946007)(76116006)(26005)(186003)(82960400001)(38100700002)(6916009)(316002)(54906003)(71200400001)(33656002)(53546011)(66446008)(64756008)(83380400001)(2906002)(55016003)(8936002)(38070700005)(5660300002)(52536014)(6506007)(9686003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?INwVBGkmMjyq7LHSZmFl0nry9l2ioAipdzlJLq2pPMr7Mo9QYLKDWteN9AVI?=
 =?us-ascii?Q?W3MFvdR+kcsy5cjbiFOECJnAM1SLtv1kadEyDu2f9GzydqVXc2BKYq4RuzfH?=
 =?us-ascii?Q?rugeScsAtXgV2c5s+jvW3RRa28SEY2st6gndhlfRhKYH4NQXnbSrV1iaIldZ?=
 =?us-ascii?Q?9IFnxZHy9G16He18BbDl6/Wns1NFfswOOlrNCRGnb3cmnvTsJ5r8Z4CI/8RY?=
 =?us-ascii?Q?UC7Ip/IGg92/ZNhayyzg1cz/Ynem50fi+5BVhED3LxR/+RaptQf8R4wcXN+b?=
 =?us-ascii?Q?OBxG9jEOZSG6OBL6IEJLzWg/KnTLnZEj5nrlTvQBVqkJCwETBp8nl9JIF/On?=
 =?us-ascii?Q?tBSl6WDg0muGa4NTmWiZ0rRc6IY9H3pe3IvAo6rmsTKFJwxSzCLCZrT953Av?=
 =?us-ascii?Q?eOj1l9o/wqIL64lu7zlE+9BI3tc9lfWgrh0aW/c8oMCIOQxhGzxd2tJ/B/DJ?=
 =?us-ascii?Q?uQqVhnxFv/o2EhYsEdAAeAFYQWRCMgEA1QYHPbuVHCQXmDNCrG8BKx45OxMf?=
 =?us-ascii?Q?EVDjuVi0y7pFGeEjKa97aPMd/LkNYAO63g3OO6yXliNyCdJWOZNKN0MJ57Y3?=
 =?us-ascii?Q?DMngCixCNXVVVkGQdRzVsV+0ItDpO8Y+p/fKAUfj37GFh5INLXVza+s91e0D?=
 =?us-ascii?Q?SF1iHpYMoMYLSnUChIRkBy2k+tkHP6vbLoH54wQufKJungyO+yWnZqN4EWf7?=
 =?us-ascii?Q?l5RXXNEVAfhbw3o4YrGHTJrHuITrA8CVYI7shFwIVVzcxSLCrax92FkxrGas?=
 =?us-ascii?Q?ME7JZ0UFYUrfb0vg9ueVK/ciu3uM6JbMuO8U8dsfMeTqGYSpIrjFzpRiLJvk?=
 =?us-ascii?Q?gsgduS+3p+CtRosjZNNkJGiV8h4CeYIj0l/VRA/g6JduLVkelMK6gySOZJmP?=
 =?us-ascii?Q?76317i73YkA1BbCMQH5UU4UqOjB4LtJCpxXtF9XCo1PnrlXrJE6eBgzza2Ld?=
 =?us-ascii?Q?3r1z6rH5FtMgbYgsf8nnTCUAIb+44cFebc9JGJVbTg+/4MVQHarxmyGJVJmv?=
 =?us-ascii?Q?yRwvcJ0ul13g+dN14ro34wc5vZr2T0aKx7g8u9nDRRJGttmYjALJ95r75Wl8?=
 =?us-ascii?Q?JUZNHq1HXayJJpDnaebn9Mz8+FDYAKIXXvml6yRBKPp4L8FUEdyMRexDq856?=
 =?us-ascii?Q?EOfFVfHAM99L8DM1U5xLBuxtk7yPzBlTu9uA0/vfrvyWihYwxDCu6TjchmWl?=
 =?us-ascii?Q?R1sN9aSpasKSRZ0+Kz9a65f6GrxL+uZseGBNC/eiKmSXZowlvb7p8UBmo08l?=
 =?us-ascii?Q?wNlMrIjpyusaWCrlJDjIlr2JZcopsZZBBiveHuzokYVwg/SgUifxwEPX59kB?=
 =?us-ascii?Q?prLhPPVjCSJ58GQOwBAnXGVELvkiDHZvJNLQNmHlW5NT30p7RoTmPQFTDIxq?=
 =?us-ascii?Q?B+adiS8PdFg6QoeiHGu3mgWUW+K4sbeWceCEl3pxrQhd2vBwd15ncbf/1MFT?=
 =?us-ascii?Q?PKIa0mMcoL11WyCCH26xyX96/AGYZMK/dYg1yKsV2P5pglkgEoZwH7p0eSXy?=
 =?us-ascii?Q?IUhLsSa1TJaUOQB8hwsAu6IcVJoKsM3jIxmlfLndn8C7Qir7+CXnR8NqFVqn?=
 =?us-ascii?Q?sfH4nVHPQdCEYN183EvG7m450cHvCsZheBCh0B6q9ztoA1Qv0ZgdtF0J1zUu?=
 =?us-ascii?Q?BmZazKlYbFTVnXwwr58qqldMT2oh04jRwet1ECytkAPfM6zo/qS0V9X3eBTZ?=
 =?us-ascii?Q?Xk5I4Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c160198c-4b4b-4df0-4ab9-08d9fafcfb1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 20:57:50.0558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lzr1sHhuvXLF2XSF9LPY6R6cZ52v61IJyymYVNtisxuNgnYpgAEsXNmVkuydZUT8ySSihjLpC+GPPWM837yjAXSfzdipbMmTHnF0fgtAtLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2877
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Monday, February 28, 2022 3:24 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: stable@vger.kernel.org; Brett Creeley <brett.creeley@intel.com>; Jank=
owski,
> Konrad0 <konrad0.jankowski@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handli=
ng and VF
> ndo ops
>=20
> On Mon, Feb 28, 2022 at 12:10:20PM +0100, Greg KH wrote:
> > On Fri, Feb 25, 2022 at 12:21:00PM -0800, Jacob Keller wrote:
> > > From: Brett Creeley <brett.creeley@intel.com>
> > >
> > > commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> > >
> > > [I had to fix the cherry-pick manually as the patch added a line arou=
nd
> > > some context that was missing.]
> >
> > What stable tree(s) is this for?$
>=20
> Looks like it applied only to 5.15.y.  Can you also provide backports
> for the other older kernels that these are needed for?
>=20

Hi Greg!

I sent a series that should apply from v5.8 through 5.12 (excepting one pat=
ch that was already on 5.10 but not the other trees, for some reason). I al=
so sent a series for 5.13 and one for 5.14.

The code prior to 5.8 still has this bug, going back to the first release w=
ith ice, (4.20), but it is different enough that I had trouble determining =
what the correct patch is. Especially for the first patch which is necessar=
y for the later fixes, since it introduces the lock we need. I'm going to s=
pend a bit more time later this evening to see if I can sort it out. If not=
, we may have to live without the fixes on those trees.

Thanks,
Jake
