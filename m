Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3572B68C5A8
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 19:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjBFSXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 13:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjBFSXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 13:23:15 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C242940C;
        Mon,  6 Feb 2023 10:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675707793; x=1707243793;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uQ2FO9wTlSGQ1+q3BdYmhUvZOuwN7w2YdzWlEnlt7iY=;
  b=Hpf7p0KGLUjHEkDTZEHky1Qutexm+kKxdoLeWupjCffarLBtvXLBlZxI
   7jGtU7Y6PIjuW2T0Oim3FVbM/ualObyo4mlCjvyGG84aWNiABf7gEgvvo
   dF6n0gJz98Kjhuqp1pArIq/tcJcbgvj//smt/sA4bqIY7/VHksoZg4PqZ
   mh/0ETtVEMiC6Yj8F9334t+GLovMGuKFTXz53zPaQxzDCkyZ22aXnPat7
   vBgE9kbDxEp5/SvDY6jHjmLMgFf6twykrAZIm6DtGXRvJ9JqHZCkU3ByP
   ApiU6c6blne+pQoIeiCSkp5OB7kRCqeZD8EHCEvgY+xbw6kivRabMVGuu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="329293953"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="329293953"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 10:23:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="775242503"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="775242503"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 06 Feb 2023 10:23:11 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 10:23:11 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 10:23:11 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 10:23:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czr/7A4ro2hSl2iDTbv2ZQOZTEYReedELwAirrBrvauygVr7bg/+IvUSBt2eJXWRnHYLefceZrclxh5PjNtckfl4MZ5pGIXeVfGsjB6FSbMP6cQ3Fc3LAcIw/79yC1h5aaKiQdlO8O8BoFzG/6EMZMUS2O8kvNbpOaPM7g6YvrjbSgAArylMN5gg5sUutfs2aNd6WPGWyTMKWNs+zsyk3zO1SX/TWH1/G5qf2Xx0tapKvOT4fT/ADt7GcWb7msJxxZSpNh3TAD5mJwCbJ/faNemcWUmImL3EASo42J+4hrwxgn79wuSECRk841f4wOygqbBTWYZrAUo1c8Q/wE4PQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=asGvQGdSsWBwqEkbl2YWX4tWKihttGE9zQlihRkPAL8=;
 b=JAtxBNZa5Sz9jm/vUTUmcijemNbp9TsxOz/iwjytkTPQB+lvt+KYo1ae24tPsKcSSO7RrwCUa8egVXRB+XllngbjkAc91zoBSUzvu6MbCbYRM7MObTNdyq45KaH3A9DcJ0Yg4uax2TpCoyKgOjpH5M36KTSI2OnOkPunMNShloIVxHSX/T6RlcgBJpRz8Hxd8nor2HEXjvwqhOsRte0XnWWIkHmbjBw4P1FfCtYIPe7nRYaIPWit1olxQdt4Y6Vi+JVCXRIFUpMgqalTwjUHCVM42Y1+Of1BsqmvaKjW6OnL2e7PaH5S74wg2pnpSdl7pRItvclnAF1i6rCe2UMA0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7034.namprd11.prod.outlook.com (2603:10b6:930:52::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 18:23:06 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 18:23:06 +0000
Date:   Mon, 6 Feb 2023 10:23:04 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     Davidlohr Bueso <dave@stgolabs.net>,
        Gregory Price <gregory.price@memverge.com>
CC:     Dan Williams <dan.j.williams@intel.com>,
        <linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Michal Hocko" <mhocko@suse.com>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <63e1458816604_e3dae2948d@dwillia2-xfh.jf.intel.com.notmuch>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <Y+CRyz0eFKfERZLD@memverge.com>
 <20230206164056.a4ifv3k4juadlazl@offworld>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230206164056.a4ifv3k4juadlazl@offworld>
X-ClientProxiedBy: SJ0PR05CA0145.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7034:EE_
X-MS-Office365-Filtering-Correlation-Id: 49faa50e-d3a3-4d08-6aa4-08db086f3129
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+q31PuIQ0R+z4o7DiYMK3UuVKrdd19WsYJbQp0Q5HL/Ajuei5MeAde/LcmFWVsUsBdJ0e+xzFvmrdV6DV5SKT2fZRAtBO89/ppKKTArXlgMH8e96tw3/zxI7PD9COcDsmlxZBmdE0lXBsxqzbovwMfnFOQs1a3g5nTuca+fKEbTNnzg7+s+N/VLo51RAQmNeItn/r9pkPJZtzAD5SLH7tg0vjMCQcmMQh/8Cl6ff0jorEE+MPocn3Gbl/J5xNzc56PPoDt4SUwpSZI1ZJ6PDVekg6ZxogwBsnAeZMtg1ERu4BmxdRZUiLCXPZhNinZf+iBkvtzXCSiOa/n7z2S0NH/okVGIGo08YuO3r1B4sDFBgdYJ08+y3BtQlrpMBdkuQZhVsIsjGKyie7zZqKdex3pwJjqfn8IZokAlpD7zOm9mRXqK3c7DXfPRrsAQQZW47XMyQzF+4KVw5/j6xl9P2eaNrQK5ceuok8p1WmbVlaFIHAFT4HhskNH3skakvTPbMe2m2Zg64H1iVb1GFU46S0+J7sbpNaBoFPkbe3zbiMlG1bvSRAvqn+Nc7Ez3unI4fdkwW+d6unbLrR2UuW4rIIx2mXT6J7hkYmwSvx3dKVDeCGzF2jT9uIHXEPsMnSCGxr79q5ckrJA4TxrayrWSTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199018)(5660300002)(7416002)(8936002)(41300700001)(83380400001)(2906002)(66476007)(316002)(66946007)(66556008)(110136005)(26005)(9686003)(6512007)(186003)(8676002)(4326008)(82960400001)(38100700002)(86362001)(54906003)(478600001)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UEpzlcnjDFt0Zq3lEesAcB/4JL5PkcbVdndJAz6HOY+wz/ND+dQy/G+Vr/QH?=
 =?us-ascii?Q?OqhVq9AKsbrl6dol6cIQUUP6Sxf6Ovz28Si48yZsNA2E0ckgSEYoK0zMkZ4l?=
 =?us-ascii?Q?k5LYRoERS1lZK42Kw7MuvrFuDm06VHyt69Vpbxds3Kt6koUKHGGjaqCP4e4Q?=
 =?us-ascii?Q?8h2UIraTXYoSAE2eFjIbQPphffKLK1DyXW2LYjiftKAg1FGppWP6CDe9y4Et?=
 =?us-ascii?Q?VN/wHdBKCXS4TY1gcaBG1P9/7ByFOrQ52Ev16uSxsoFxjPu6PtKAiAoFHlG7?=
 =?us-ascii?Q?0rUbWlF6k8Q7hGQzSEdHd3PpvPI8P0GugXY4WgmIdEfaJmMMoih6wZW+HG9N?=
 =?us-ascii?Q?f1O9fwHoRuXLx4L3ZKIsY0CPruB2NtI6fcwgQeaQmPxm4Dq4Qz5RMc9uyiE7?=
 =?us-ascii?Q?Zp4rdGq9ns7ZUdbpokaG9l9oz5HbjjeAz2WXghsNrNp9Q6UdCbWwP5klb0aj?=
 =?us-ascii?Q?dfbhvgIFeErj/oEtwUezsTUjqOOC9yVwQoqTK/qEnA3EuWGpsiWKQCuBNSeY?=
 =?us-ascii?Q?4r50SkUdj9uwGg4M3SfnUd4LaPcooccZSD6qVdq4L0jjRN9iPXOcrYuzZP4C?=
 =?us-ascii?Q?YRilYu/xcScG/0ssf3SNgjG9goq4lRteJILOw1V1T+ow7yXPs6ozFfoUS9Uj?=
 =?us-ascii?Q?T4noMjAnrTKa2Eg3pMf01c/OEXMfo4+JTcRXVLb7CGtjt4ZUhOBYxiHdjJGo?=
 =?us-ascii?Q?/3uus7o3RYJraSNb6T9IkAIdYGWIwsVhXowM7qDxox9bpyzatiPa6Jdvibk/?=
 =?us-ascii?Q?Nyo46+QAeAA0NiMRd5twNPalwxhz9JuNTyJq2j3Gt8wTMULQQHcWI7G/WRpl?=
 =?us-ascii?Q?d4jNk/MZtj3wgCJ7kHmVMlKaOAKtI59ADft+9cn1WY9f25dr22Q1gs5za210?=
 =?us-ascii?Q?bYlYVBJQlS33COAdUa9BFo4GN/ur8zD+Kmq2T6YT9SzulV/hEmyEYo0mZtqF?=
 =?us-ascii?Q?8LgAAVc2+nrctKSRreV9YZnBLe7RVbbENNvd9i5ya6ArgPHOJGlPRC67jiYn?=
 =?us-ascii?Q?htfkjihlJzHAsGOoc8ZA6ho620HD8zhaebRKF6J5e8fZhyCtTROOdFIMVmE7?=
 =?us-ascii?Q?7GDWnW6u14WYZW6BZzFPHaKHHt3P3ruLWw3/cnaOJVddQG9Ffm6r3xPzHDHG?=
 =?us-ascii?Q?Uy5SKC4yGrNTT8m/UEwpJRH05AEUM9D9i/nDHlyipf1luVwj9BGY0AKeEWdj?=
 =?us-ascii?Q?1iw0LW0bVfsbyS80Kt/GyFixx22QdCl1CNIXZG/8OsBWTBLpgOJed2opYauG?=
 =?us-ascii?Q?96N6/va5GvJRcRPFlQg2U6mIYoz7X6DjUQATI13ag49CSXoGReR8UnYAyuw0?=
 =?us-ascii?Q?FBmye1MzY6+3p9kKmrmZSrOTisAjmNEHhyeFUMB96XR9FPd/5S1W/5ISuXSE?=
 =?us-ascii?Q?gedMx1KaJnjWkDP9EExPhx0HTWoQkaamnEJmb7q47F8aLdsH5rNQ+c/OMuUm?=
 =?us-ascii?Q?uPNF3Kfu4us/d74PA29aZQljoBoOJRmf8iVwbhoCOqbFFJ0ML+aRwvE31A0a?=
 =?us-ascii?Q?LsR1vJwXum+kVMfh1fKJXGNrveFGwGM7v6+iSgIOW5vCVlyKyTU735ydhSTH?=
 =?us-ascii?Q?fvTizSJwUvBrIN+Y1Ok4KBU97hXf7m2lqPxxpMgwhZ7GLAm5M1byF8BhzsKU?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49faa50e-d3a3-4d08-6aa4-08db086f3129
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 18:23:06.4122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yk0SS87ys93x06dJ4Y7tEzvY4GMDvKh2KnCx+jvL1uAGA0W3H2NRlTD6WvnYClKnbuxUNAT6173s1zo4fJoXA/hCxqZMHfWURvdu4KorNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7034
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Davidlohr Bueso wrote:
> On Mon, 06 Feb 2023, Gregory Price wrote:
> 
> >On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:
> >> Summary:
> >> --------
> >>
> >> CXL RAM support allows for the dynamic provisioning of new CXL RAM
> >> regions, and more routinely, assembling a region from an existing
> >> configuration established by platform-firmware. The latter is motivated
> >> by CXL memory RAS (Reliability, Availability and Serviceability)
> >> support, that requires associating device events with System Physical
> >> Address ranges and vice versa.
> >>
> >> The 'Soft Reserved' policy rework arranges for performance
> >> differentiated memory like CXL attached DRAM, or high-bandwidth memory,
> >> to be designated for 'System RAM' by default, rather than the device-dax
> >> dedicated access mode. That current device-dax default is confusing and
> >> surprising for the Pareto of users that do not expect memory to be
> >> quarantined for dedicated access by default. Most users expect all
> >> 'System RAM'-capable memory to show up in FREE(1).
> >
> >Leverage the same QEMU branch, machine, and configuration as my prior
> >tests, i'm now experiencing a kernel panic on boot.  Will debug a bit
> >in the morning, but here is the stack trace i'm seeing
> >
> >Saw this in both 1 and 2 root port configurations
> 
> I also see it in "regular" pmem setups, and narrowed it down to this
> change in the last patch:
> 
> -module_init(cxl_acpi_init);
> +/* load before dax_hmem sees 'Soft Reserved' CXL ranges */
> +subsys_initcall(cxl_acpi_init);

Yeah, I need to add some CONFIG_CXL_ACPI=y and CONFIG_CXL_BUS=y configs
to my tests. Typically I only run module builds.
