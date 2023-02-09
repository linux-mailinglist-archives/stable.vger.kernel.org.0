Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2322168FF90
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 05:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBIE5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 23:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBIE5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 23:57:01 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71442144AB;
        Wed,  8 Feb 2023 20:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675918620; x=1707454620;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0Pj/TBQcxvKYD3MI5eAXfp0ftPnt4gJzCZQR9R2rPxU=;
  b=SYbHZ9ev+cEkCS4qjrXV2yrbIDhzVTVsVQZlVVra5PkkZbeCemPs7nK+
   QMnHaergyvUWPXyIW2dpHp1zg3iJs8TTv+VLfs3ugSKvTvRUJjYRb78JP
   xeccVi2CjxQ3Rpr5egFR8xX6in9g3CWeGBeS5hZjy5U5s8FJiXXwAiSkj
   ktlLxvzlanYTYUW1Gp8JM2ColeYai3H8ZzE8TLnDO1yxyGzvZSb/VqZ6s
   oeLvUMRqys/0tlz83r1ovs9QsWxC+bxitFt/an2CRJS5baugYZqYvoT0I
   rGLK7JBYFQtLrVsVNnCQoaS11RWpL+Xel1vBTRbCUnrEECg9CTj7f5sMO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="309662636"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="309662636"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 20:57:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="697899332"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="697899332"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 08 Feb 2023 20:56:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 20:56:58 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 20:56:58 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 20:56:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbwxTGAkN9aYfVkzjU3x4KpV+Q0nq5Jx3Zdd6LX9h/Gv24E+gUBNCu5ftcFSXv7s8zSSZVMYKL5WH4WoKW9ER68dXDL7B7wBmzSGjh+QhvpljKyQRR4bftbGmKzZczCkexbIfi1GfsBR5WWc7g3MnK0Bhu3xYk3b7cFB/u9zR0w+xp3uSyKAzwGgXyTZccnWHxOgVVe6tgttpHZU6T0l/1n4Mces8ZxmjwlwVdQcnNcCwotGkVjiGJNDhLG5RXAy1ORzu2FI5n8a5k99+XCWYg7BHPldf3wcwXoMr2kO/ygsZGQ0Upco6s35BhLOuoqrfc6eSp6tBZqEry3F79jfeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLt9ZQAI7bWNrVzXCwzeN+XZNK1oWemvOEylBq8feNY=;
 b=YiIumb5ewNWkTOBh0aG/QvHyxSKZTnVeP6bsJNXZsjDVlbFCWyNw4UTL+GrE4J5abrxVMxaWF7ubHMp6Pen0cmEU0PVeAxAkZT9GRDtGiTdaZVRwdm6x76E5cFrjl6y/jOAR/yUp8WC3/OIsmvHA9AtuJU+Ybk74F5LCvImMW+6Ddy1BYcDiugkbinrl1TVAg43WulUi2wrLw0LDwLOHUV3z2Zd7uKVP5VvtVrEwQY8I6m9m8mgoD9kn8EjUdZRxp+Q18z8woqsvKdWh4vK4PuufgNMCLcrbjObPcfM1hxMQhWEaWb59yuJClnrq3gG4mDSGfsrYwGrG3Z3cO6OBmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB7991.namprd11.prod.outlook.com (2603:10b6:510:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 9 Feb
 2023 04:56:50 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.036; Thu, 9 Feb 2023
 04:56:49 +0000
Date:   Wed, 8 Feb 2023 20:56:45 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     Fan Ni <fan.ni@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "David Hildenbrand" <david@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        "dave@stgolabs.net" <dave@stgolabs.net>
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <63e47d0dcbe55_36c729476@dwillia2-xfh.jf.intel.com.notmuch>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <CGME20230208173730uscas1p2af3a9eeb8946dfa607b190c079a49653@uscas1p2.samsung.com>
 <20230208173720.GA709329@bgt-140510-bm03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230208173720.GA709329@bgt-140510-bm03>
X-ClientProxiedBy: SJ0PR03CA0299.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::34) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eed0023-e12c-4055-1812-08db0a5a0d82
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9ft6gOfv+cF7Oht/LaP5Rwqpjty/aV8yc4I+deIEvfc1T17eLM3VNVCjGJGq9cZSab95Dynbig8PrJdaC3Uc9NesfEarV8PRdqxv0qXPfRklOMgdD9S/rqPeub/xuGW51pY4kxxa+xnByD10yA7k1JG8huIyFSMG7J4+VqdecbNRH5B0/6gD8+pWEvRtRmtbvi32pJ9faULWve4o/+UEOk+4E5DrD7J/L9HTkjuNvTpyU+iOoMjvab2Bwtl+/TIXUEqeBj6dL+g7t80JKCBwoMm+0GHf/r6sHADSdnuGbu1OLPhiLw4UmqrACpFEhhMWqjvIpRjo44oWKmdxaPMoFHSB7oKnr7URiwB9cY6+phI/SiZlKABu+7B5Ve5tzgYJht3qU2KGhaEtUHd1Go+beB8D60Rs67F/CofoQBt08Z5OIb6fdtKSxN5kMvretb5zvpftDMB2pFowl1/kwjfjUuFuPPqVlRWtjXC1B/E9zzA1mZEUixFh9a8B0oF6TAGDUIaSpLiJmEZ6ZnHNBFvAtx02u5/by3huw1LQyW+iAvNaIkKRhAqrIV+U6c/RBMjYVpXv6pm4+J0weX7nEsldTXjS5AXMxhoyfYv2ZLIAfGOhVhl/MFCtlKYKJTCHa5RuFsGdQ8VlIQD4HUy5izfMrp3n3YJ6ss8JloRQBVg1tKtGITz43Ixz1NJBZzPGTO1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(376002)(39860400002)(346002)(366004)(451199018)(6486002)(966005)(478600001)(82960400001)(2906002)(54906003)(38100700002)(110136005)(86362001)(316002)(41300700001)(66946007)(186003)(26005)(66476007)(6512007)(66556008)(9686003)(4326008)(6506007)(5660300002)(7416002)(83380400001)(8676002)(6666004)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zy8iLf7QPd10KX3eNSpXLF0AGD6C5Zf+3wwcjDegavoUgGG7Fzo7gZXCszgo?=
 =?us-ascii?Q?ByAbzaQHpPQ6Yv71wK0Zb+T7dqJrbEp80nhsLxnqflHq4EC+EHDqbZZq3Etg?=
 =?us-ascii?Q?e6XrZ32divBegNPj+Fl94dDuQz9Z9GvIB413/Q5LkNp3MEkqgCHEwMJCUGsR?=
 =?us-ascii?Q?skfjIKZjLs5w7IAdAHxmicbsGGkyqzng+Bsl+K4FYkJFRLVZJTe+HKG4gNYS?=
 =?us-ascii?Q?lBUnb1uPNAGFUir3mOULj6u0q0f8fWV5NybtyB5OIRnuXIRZc30GkuoUKY7X?=
 =?us-ascii?Q?khHkVfuGGZ7Wyc1Z8iwpbJMossDu4oq1nnTiONi6o3by+Hy8Dge0NUsjjY9R?=
 =?us-ascii?Q?mIZBqhsk5w/O64cPxUeZUHwp0CLtFIFyWIAlxl8OuMdo31qTJC9XSWO1GXoQ?=
 =?us-ascii?Q?gty48ePZN9NayVzKnTste5aPypzFy1vUZ1Z2OSx2IVlOWtPBQh0fNd5smvxJ?=
 =?us-ascii?Q?a6US0c4hobO0+DLJhI8SLwSaODvTWAHfaYW+6W5zaI+I4uvoQegJegm6W/Da?=
 =?us-ascii?Q?IS+34GlIGry/crYtqVTh6Tm3dMBin0z6lPmKUybx0EqVK003Me2q8k4UP/2+?=
 =?us-ascii?Q?X81L6w1EDy5+Wad3x/KsvLLViuOmNGG7S4i7kkcvXI4a521m+8BYAd39PqFr?=
 =?us-ascii?Q?ZRFd9tLCIo2un2+aMMqZx3XsxnWkpxm746yW02Q6FAeIXtr1R2W/dcJ5VV33?=
 =?us-ascii?Q?tQCPNQcW0R3wyT8KAgfGeLvrUzrQcxcQjib4Zk9kwJfzJI2Z3WMlU7ym9HZJ?=
 =?us-ascii?Q?JYu5MDTOOP6zdc9VJ2ZrA7bZSJRxlLo1NVwXbqigRoPaQC1+dLLvVAfN2ASp?=
 =?us-ascii?Q?RcUWdwj1Uq0zlIiB6jB+JMyPuueULZM0tFYO4WnDIBehQzFjZvID9huaaqys?=
 =?us-ascii?Q?G8wM9lFEvy3sldtbU782GyrwuInnDO1zY7kjtfO8M0QEvj0QX9/ZGrkpGtu8?=
 =?us-ascii?Q?RSNX7EIVUf6aA1sFfMOz1ZKEnxIJRAeK8pKK5C8jkpVg7SWEujU/1u4k08iF?=
 =?us-ascii?Q?yggXElEiBF0Ne/Pdr2rPrwIprv813LPrHLr9fmbJdysrVLNOo+I/MyltxsCn?=
 =?us-ascii?Q?9/zg9UOQgqHyi5a8zTe32yovpisEOl/J9HadA3JOBSHGofiNiwciuFg0rYZm?=
 =?us-ascii?Q?hNz0bri2Stqfgu4q1vFCADQ9TUIFoWQxJx99PwESdyZQpI/AjEva0pwraX2T?=
 =?us-ascii?Q?GWtCngcxu7uRQ0xuJV4v7NPXubXduIV2hYPsZN98hhslDd543hm2AgP+JOth?=
 =?us-ascii?Q?LxEH2gCAu22OCz2eoRtb28Cty28hAJB2TUVLoiDJE0LH/y0blBt10iGrGjkW?=
 =?us-ascii?Q?ZfClGdHTs4lwGRBsBSCTGA69zSj9Z6Ip8E8uOCx61HqkqEqgMtsnNvMiRRHH?=
 =?us-ascii?Q?Sdccv4/8AYiC6LYFaviAC+qBUcViEdO5IuvbowHqb5XzEeKX5LJiuXVrsA1E?=
 =?us-ascii?Q?KtLS9lT8KtU/bzf3Iz1hXVRfLSMVqUxDSVBw8k08E3UUEHb5Mg1/hb1DyEWa?=
 =?us-ascii?Q?evxUY18svdDrdGtsKWMirndTKOMq650OguWLroErzu/XD7ZkAh5dIDtTSnjl?=
 =?us-ascii?Q?vA9JRa43EUNR8uI31LNPgEx2r5Ypin7x61DPI6LVpw8dgrh+/apzncptg06m?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eed0023-e12c-4055-1812-08db0a5a0d82
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 04:56:49.5208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgVoV1YvFSfp4aF4Woeh5j8pQAzhLGKmwefvzJ5/wAJTSEr1gIP3preC55I+RLvIq0zK3QH6zfytWIppMTh/iknJbpRIRskHynj1xhERYEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7991
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fan Ni wrote:
> On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:
> 
> 
> > Summary:
> > --------
> > 
> > CXL RAM support allows for the dynamic provisioning of new CXL RAM
> > regions, and more routinely, assembling a region from an existing
> > configuration established by platform-firmware. The latter is motivated
> > by CXL memory RAS (Reliability, Availability and Serviceability)
> > support, that requires associating device events with System Physical
> > Address ranges and vice versa.
> > 
> > The 'Soft Reserved' policy rework arranges for performance
> > differentiated memory like CXL attached DRAM, or high-bandwidth memory,
> > to be designated for 'System RAM' by default, rather than the device-dax
> > dedicated access mode. That current device-dax default is confusing and
> > surprising for the Pareto of users that do not expect memory to be
> > quarantined for dedicated access by default. Most users expect all
> > 'System RAM'-capable memory to show up in FREE(1).
> > 
> > 
> > Details:
> > --------
> > 
> > Recall that the Linux 'Soft Reserved' designation for memory is a
> > reaction to platform-firmware, like EFI EDK2, delineating memory with
> > the EFI Specific Purpose Memory attribute (EFI_MEMORY_SP). An
> > alternative way to think of that attribute is that it specifies the
> > *not* general-purpose memory pool. It is memory that may be too precious
> > for general usage or not performant enough for some hot data structures.
> > However, in the absence of explicit policy it should just be 'System
> > RAM' by default.
> > 
> > Rather than require every distribution to ship a udev policy to assign
> > dax devices to dax_kmem (the device-memory hotplug driver) just make
> > that the kernel default. This is similar to the rationale in:
> > 
> > commit 8604d9e534a3 ("memory_hotplug: introduce CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE")
> > 
> > With this change the relatively niche use case of accessing this memory
> > via mapping a device-dax instance can be achieved by building with
> > CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=n, or specifying
> > memhp_default_state=offline at boot, and then use:
> > 
> >     daxctl reconfigure-device $device -m devdax --force
> > 
> > ...to shift the corresponding address range to device-dax access.
> > 
> > The process of assembling a device-dax instance for a given CXL region
> > device configuration is similar to the process of assembling a
> > Device-Mapper or MDRAID storage-device array. Specifically, asynchronous
> > probing by the PCI and driver core enumerates all CXL endpoints and
> > their decoders. Then, once enough decoders have arrived to a describe a
> > given region, that region is passed to the device-dax subsystem where it
> > is subject to the above 'dax_kmem' policy. This assignment and policy
> > choice is only possible if memory is set aside by the 'Soft Reserved'
> > designation. Otherwise, CXL that is mapped as 'System RAM' becomes
> > immutable by CXL driver mechanisms, but is still enumerated for RAS
> > purposes.
> > 
> > This series is also available via:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-6.3/cxl-ram-region
> > 
> > ...and has gone through some preview testing in various forms.
> > 
> > ---
> 
> Tested-by: Fan Ni <fan.ni@samsung.com>
> 
> 
> Run the following tests with the patch (with the volatile support at qemu).
> Note: cxl related code are compiled as modules and loaded before used.
> 
> For pmem setup, tried three topologies (1HB1RP1Mem, 1HB2RP2Mem, 1HB2RP4Mem with
> a cxl switch). The memdev is either provided in the command line when launching
> qemu or hot added to the guest with device_add command in qemu monitor.
> 
> The following operations are performed,
> 1. create-region with cxl cmd
> 2. create name-space with ndctl cmd
> 3. convert cxl mem to ram with daxctl cmd
> 4. online the memory with daxctl cmd
> 5. Let app use the memory (numactl --membind=1 htop)
> 
> Results: No regression.
> 
> For volatile memory (hot add with device_add command), mainly tested 1HB1RP1Mem
> case (passthrough).
> 1. the device can be correctly discovered after hot add (cxl list, may need
> cxl enable-memdev)
> 2. creating ram region (cxl create-region) succeeded, after creating the
> region, a dax device under /dev/ is shown.
> 3. online the memory passes, and the memory is shown on another NUMA node.
> 4. Let app use the memory (numactl --membind=1 htop) passed.

Thank you, Fan!
