Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566A24C7884
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 20:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiB1TNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 14:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiB1TNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 14:13:50 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1ACCB67B
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 11:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646075590; x=1677611590;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0vFbyHEEoQ6Iq+I0R46Bq7Ex78zIBogr+Unef/NpVIc=;
  b=UQE8gkBIUO3JRJ2bEcnY+o+ndmkEtDOeM0m++C4d9Xr4q3YLrJF2nED1
   8p87e003u+5CO2ZQSF6QOmAqtECpnzp6/JNytVotIi4hFH80p3XomJFjG
   7dPyPpyFHaNcGHfLPVk+WfoIJiLK6Br5pekPbUz9GICU44EJv2nu/e5jt
   zYxjT/OVZDdXhEup2V17KQ559KFifV2FKpfDnAwbaMijf6ctix2ar20h2
   kkOmj5hUPJ2nTP7eXHcByTShmfI7h/QzpgKxUHjeowDEIDFgVigSlV/0I
   AHHeXc0g2FGIujnpOZzWGQJuQWguZRRN6vNBok5RFWckcYonGN6PsS+gm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="250548174"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="250548174"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 11:13:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="510206276"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 28 Feb 2022 11:13:07 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 11:13:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 28 Feb 2022 11:13:07 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 28 Feb 2022 11:13:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzCqsZ3nSGEmNz9rPHPwoR1hfXjYC2BbY32I3StoLbcinJEz5V6Nrh3mdr1txtbUdoHNPUagZGO6c7MzncvBzRXGJqV79Q6fLlnkbXphVVmEr4OFza2YLfjFIiOiXZMj/xXFI3wLJuxw6yKTxgMRqx50tFBiF3TNqaAZJz7ArH/HnUSiOKogFdbNfnkc9VuRG1liwXh7nO+ZnVV1epzfqWi/CkXbJDAaidxh3H5kL7rHDXuoBE256K2G94egWd4ote0CZMiSe1/iEAsd4aC6tktJVGTLodcJhsftlo7ETXNzxFsHQDSPr+Dq3whaJCG2e13klOzAw+9MNZH/kEaCmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vFbyHEEoQ6Iq+I0R46Bq7Ex78zIBogr+Unef/NpVIc=;
 b=Z3Zgc0Am2Zs7UbQCVSBF+FspAVRDUP3gEa6CrgxycRd6hjGiyvzHpSkYw635Woh1trqdgRVjJ+yTQ24mc7dxC4fOAUpWj8he9fgP5mkro75IBtH3ikwKhrY7K3tNkfIYRX43L7jLWSC8jq9QW4n9g+RokHm/yyWU3Mb2zyn3nT88CH+lyvQtn6aC3ysolln3GBZfeaPUDirEm+skMK8W46Sx2JqvoxWpXs7tHoHPdjArsJGhn3zXE2jWmFM9xbi4EOV2vY4RG3MYGKBnc9u5wsbkvjsTsJ5IqJ0cvIkQYp9g5m6IVQGr+52Sazp6/nEu5qVKB4BhJklRI67+to+w4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY4PR11MB1992.namprd11.prod.outlook.com (2603:10b6:903:2f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:13:04 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a%8]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:13:04 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Brett Creeley <brett.creeley@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Topic: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Index: AQHYKoV1oS8OxtgVzUaACL1TTVzKm6yo0oAAgACGzZA=
Date:   Mon, 28 Feb 2022 19:13:04 +0000
Message-ID: <CO1PR11MB5089BAFBF10CE97D0B1D8C5AD6019@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220225202101.4077712-1-jacob.e.keller@intel.com>
 <YhytnJGxStO0Gai9@kroah.com>
In-Reply-To: <YhytnJGxStO0Gai9@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28afb35c-164e-45f5-4e9f-08d9faee58b1
x-ms-traffictypediagnostic: CY4PR11MB1992:EE_
x-microsoft-antispam-prvs: <CY4PR11MB19920AD78A8ADF90CD956839D6019@CY4PR11MB1992.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gEcSHZ27dAVIX29T5BZ51K2Zf5vuLsGq7h69mYZb587GpYXL4ihqjGm9JNFWh6tERvihEBoDieemH+L5fqluCBWsmYtHXpQ+miC0eyvwcAh1bkFhFCLZVttOiB5tkLicPqywWhDdyBXipcEEnlA+MLIEbq7YM3+EGGfEs5ul2JTAOVeyWr7HUw/fWQhz3VmlfG3D++l3VAbuBHzy3w8SvcajiBWisW5iiCC+LULEvnq6apM2HLH96doMTgn3bAaKOVwyGvwj1DzpLTwn7lfua0qhtEzvdAENMcQAWRCC2Pv3PGmZNpcce6gHjxzjZJ3hZFv3/mLh4K3aCY5xBhIUVSb9xdVN88JaW2yuRSGV4pxX10X/gPhW0f5VZc6ucXXh2kCFOnOxhQFG4jrV366gSSOV6a3v1qBE7MPPEP2uaGktg2uEI+9raRf0Cik2TO3Rx1+tse124m3wgsgzA2u2V+QsY1flvXX6lPfknnQfpJmGR4dPSYogzcYGwIeMnJlDSRTJncOhgqGqJQBgQIk4DpgbxDtQ+nD/eUe0j+Xl7Hh5VCJqziej0+eEfdjXT3Cyr0InM5bLTJM5aYfV0FPdouLD+8Qi5rkHP80/VpBA2kgKSdYZmF4GPuRgUyDJ32kA/TwYUsYnHY6wFqpEBto+m23mpcfJNl5gZCqMnG3nOXBW7h9I9+Rw1/Or6aGySx2S3sYoJUg8uozK4/dZzOY++A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(71200400001)(53546011)(6506007)(7696005)(54906003)(6916009)(316002)(82960400001)(122000001)(64756008)(66446008)(66476007)(8676002)(4326008)(66556008)(4744005)(8936002)(38100700002)(76116006)(33656002)(66946007)(107886003)(55016003)(9686003)(38070700005)(186003)(86362001)(2906002)(52536014)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CUwCeLkZf6AQS3T7RHcK3npKgkt8p8kHLvTHi4ZuixsHHPVtFdTyCHBbN7x3?=
 =?us-ascii?Q?n043S9JtCN99qY8W7LjfnLlQRSN5q6bGMoxc7DtZC93DB+0vS2c6FPVeNAe+?=
 =?us-ascii?Q?kZhBCokW6ILFFZZ1UiB1hKe01LubsPDwiwRr4VrIPZ2S6j1lIjCEV4Qx6Das?=
 =?us-ascii?Q?hvFsOZpwu3UbzrivJGTDNhaKFj2OQzKOd1JuPQJ3HNwO26Kkl3yUAZi47kkE?=
 =?us-ascii?Q?b3zAUXGdEE/nYdPJMs0hTxZGsMI/FdKbh4aNEKeMlJ+fGT1MOtQzhMzCQ/6Z?=
 =?us-ascii?Q?wOND5IyHEIi8cagdiFlS5IfOd3iV4t7eBPBYgt//fqStC/t1L9rOTUThrq/y?=
 =?us-ascii?Q?hpEtiyIqRxxfPpP5ZCDCBVUWtcYKR33etmDvZo7dNfYCzWKi+UsnAfj4rvI8?=
 =?us-ascii?Q?PHIIuTPwmDZ2lCx15DZ8e1HzKAIVv1EVpqZ6rLneFouVx//xf09U0r/MMQ9y?=
 =?us-ascii?Q?sqKgpaFhYRkx9/4QtU+fqtSPK3Ri+zlmm2+Wo0z3iP+O2DmoCb0AuQaOEg5W?=
 =?us-ascii?Q?sdGsQQkgi4Sm5H5azmcLQHt0qJqf1VETufxqmsAt3dVjtLOVZkdQuekwH3Gl?=
 =?us-ascii?Q?k+W+y/mc+et1qBFPIB6eUHp/rCp5b6pIeXFRPh0xlgEgAWL5jkq7XENo4vBZ?=
 =?us-ascii?Q?0cL904GxZPzk6JqVyai84bQ5LLZEQ9egx3ATF5LzDbznmPJl2r54FCp83DSS?=
 =?us-ascii?Q?6fEsSbihyy7QBfQGVE8xpmAPo2AIZRHXFSappWP+DHumlGCq4kj0213c0UXR?=
 =?us-ascii?Q?lU0r8IprbMxS4lQQHLIab1zC/rDE6bzCqaY1hrxhLurfFG4xeECI8a7YviBb?=
 =?us-ascii?Q?/XNBdKyOKrLOYBttym5xYG7SJ5EqG/ZcfancnQKwl2XvmOKhxbPbRMDj1pt5?=
 =?us-ascii?Q?ggkuC9QVM5R9p0mQ2w37WmCW1kZMrfo23dodcrOsYCa1/BwVrlc5u/cAm9bN?=
 =?us-ascii?Q?qCAt/EHueGcVb3lnX9koDqiG1S22auhWJC42KjaHt2Pl9H0QSKNZpFOUJvyM?=
 =?us-ascii?Q?HR7JgL2uHI2prLNXXCd3FJLvrA75VLPKFoNn63ZTwGZZ6w9+hLP1IPQ0xhcl?=
 =?us-ascii?Q?YEG4kaLUwwVYqBciOssh2IDzxGXpdvhiOhwQrd8VvsWhMyidPvQU9zR/aVvJ?=
 =?us-ascii?Q?IYYMibWVnoyZcsKPb0ww81xNp+YG05oulMif8jLbGAN0V75Au+/wDPm8YnZs?=
 =?us-ascii?Q?W2Z/kkbbCGNPBCBjKQg9NunqYAc7xN0mwD9TjpLe6+vYkcgdrM3mBJ20mZRS?=
 =?us-ascii?Q?nxEakrOMw707KdlvTe3y6we1B7t3FxX7XspNodoeSMHCf6pIRFtfpIOExETa?=
 =?us-ascii?Q?S7LYFUPLgpuE3MGGqdq5sTBhXQ/gY5awx6NR+36ZthTPXAFx8JlLUWNIcLXf?=
 =?us-ascii?Q?FbY8hsQAfCpGrAodoFdDJcFIjmhwlxPdR/NiTiuFnuGBJu2PlWlwdxKQyGhp?=
 =?us-ascii?Q?rVRy1zbH+P6qbNF4IgUYUZUMh2MQrlXvSgO8tHcMiLTg47YCTdU4Mj+t0OLY?=
 =?us-ascii?Q?I4n4M101oUL7H6V21Ia1D2fY4PPOpfdNamHZVoVIUbMOUIb77lhhgnjb8230?=
 =?us-ascii?Q?zhXf+8GwbRaiQB8iSS24gA0RzA77S8n+3JisSLa+LqYmLvw47tQw9HghyVDo?=
 =?us-ascii?Q?mb8xC9Jt3lWKYKCNdwTFfozrweLcUa/hbbFJ5NGPpK1mwaogRG/eXx4d45Qr?=
 =?us-ascii?Q?IhxjZA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28afb35c-164e-45f5-4e9f-08d9faee58b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 19:13:04.6186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OEyP49h2ikL9+3BK3FBGoyTBdJsNwHlFU5S24JVX9CrAkO3yybLF9QewSKGAh4gsqWtK0PFR//xELGiDaKHpuxDUwW5Hw0Uk7UZ2/PSzmzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1992
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Monday, February 28, 2022 3:10 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: stable@vger.kernel.org; Brett Creeley <brett.creeley@intel.com>; Jank=
owski,
> Konrad0 <konrad0.jankowski@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handli=
ng and VF
> ndo ops
>=20
> On Fri, Feb 25, 2022 at 12:21:00PM -0800, Jacob Keller wrote:
> > From: Brett Creeley <brett.creeley@intel.com>
> >
> > commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> >
> > [I had to fix the cherry-pick manually as the patch added a line around
> > some context that was missing.]
>=20
> What stable tree(s) is this for?
>=20

Ah, yea this only applied to 5.15

> Thanks,
>=20
> greg k-h
