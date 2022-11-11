Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163C16260E4
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 19:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbiKKSLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 13:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiKKSLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 13:11:12 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB58663BB5
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 10:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668190271; x=1699726271;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GpqWEj9OOEHZuxJUPA4oerTAtzOhi/xUR9RfzRKmpY8=;
  b=nN7zzubJwHMFcpJB6HB4M4tm2VS4RqCRPjyoXcyfPI6AnPi2zo4VMwQP
   swCRQ41L251B2iekQbvH5dTRq+7p3cRxIzDOgOc57WC6d4P+j28Lk3d+o
   lXDAdC/f9jGeO4OCK9irr20mQvaZT2iAO4j+e+IuLIabT4r/iozlOOYuA
   7TcIcXGKhEjyy7LG+bEbrKIr3KLAc+gpGMvY/rm4hv0ji5uD+Ci3edtt2
   Gur2KGFFeRRdxdHLLMtOhDp5pHp76sMc40naYmyF6nTcvCGU+zo4R9tH9
   thGe2dBzi9DSLV1rW9ZK8GZy+D0//K2cSyL3H5LPDt4JYXNDCHoMwXTBW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="309269796"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="309269796"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 10:11:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="743360907"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="743360907"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 11 Nov 2022 10:11:11 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 10:11:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 11 Nov 2022 10:11:11 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 11 Nov 2022 10:11:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLXX4pcMX4uZc/jzeJxGqgvC5DsUzWKo7kMEKL0h1+z4pNC559s73Umg+uDhUbZBkSqxvWMHGBeCY8ZVFEUypqOHcjmuDytpL9RSAbiuycj9ETGkyUB1m6IjyImgfdeP19OjW15pjHOhNkBYtFooZy5IA2jcZSrwAmEOuhNrM7GyIXL17dL0GFMFRJdX5fnD4ViGYBCqyzG2q+/53j0DtN6l8pRKmfbmryZmhLpJ4b1fdSjKNg3VufrH+xiN/G0c+FSszumj2sQJmDXpcp37GLOiPdysS1nOfG2Ga/zjlsxvJbp//5JfLPzFSfq7UXO3UJeDa/4w1Tpw9OXAACcylg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfKcLJcfuN68eKiYFqD6hyb6iMXlMqr7gIp0fSHTzsQ=;
 b=XOfkagjurzXE/RZQNb/MiErwwSfU6sIYezgsomlMPXauW3kLiv6HpyIJnbRLwJvfzulpCU33QZ3eEsckGA03nPe1QfMMVEKxAA6YmHehlSgrnsp4vrTjodOtQFgzIcDhyTLu/x2yGSIjRcB2k/2plExFaYsBOpUm2V8TrKSO0nE7UN2x/jwrajMBN013B50yk/kjSxzuLCRfheYbFeWHzKPtb1lCrqY7FY791ktpMxfPlWs0/AWAMOcWsQSxB77xjsXukABZPCY/uVncRtnWibMbqDklCiMTN1kAtzAp3diyGftvNrd2RqUcCdQJzip2fl+r7gHcGPmAEJ3Xursp+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6952.namprd11.prod.outlook.com (2603:10b6:510:224::13)
 by CY5PR11MB6162.namprd11.prod.outlook.com (2603:10b6:930:29::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Fri, 11 Nov
 2022 18:11:09 +0000
Received: from PH8PR11MB6952.namprd11.prod.outlook.com
 ([fe80::d060:bf4d:10ad:3713]) by PH8PR11MB6952.namprd11.prod.outlook.com
 ([fe80::d060:bf4d:10ad:3713%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 18:11:08 +0000
Date:   Fri, 11 Nov 2022 10:11:06 -0800
From:   Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
To:     Matthew Auld <matthew.auld@intel.com>
CC:     <intel-gfx@lists.freedesktop.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/ttm: never purge busy objects
Message-ID: <Y26QOh1RO0RBK7yt@nvishwa1-DESK>
References: <20221107133027.38740-1-matthew.auld@intel.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20221107133027.38740-1-matthew.auld@intel.com>
X-ClientProxiedBy: BYAPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::22) To PH8PR11MB6952.namprd11.prod.outlook.com
 (2603:10b6:510:224::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6952:EE_|CY5PR11MB6162:EE_
X-MS-Office365-Filtering-Correlation-Id: 879657ae-05ae-4a5a-8c02-08dac4101b8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fo5wDg2JMF36j5VPMeMOX1zeBXEjPG8XBcrf1dWytr7L8NeJm9HesAWjba+gxoGOZZznq2b7uxrFBejgHjHJ/Nf33Cd0jZRNFn0sEUulhh4nmI/ju/K9wlSXPWC4kpheRQjHLu7+R6OD/KRO+U6TLqOHCkVLhq63R6v35wXXdztF3qCRS0XaMAuiJ/uNxkFFsL8+v+g8syGPVxViyuiQLhn27qLnEsbdHuHY5c54IDz+8GqUWrUfIkTqZWcTrrz1uQl7Bou2MExWoYFJqfMs/4Ws+COt6KE6qjwyNOmLzG2v7P78ABsMdNma66Bt/lUQoxxLmY9g7olE5B/HUj1kTsYxbTyle4VfS1ExGNXhxpTiOb3sPzePkJvIgtsB6LMhSPZa+le7COC2jBQ0/hJwfkU+gSb6n+O5roZJfYPcP7+FAqOh/R5mxVDCOw4Y2MIp2ItfmDI4FLF/xw58f+rXEYD3a1kN7Q8br0cERylehHFGz5kY/S/SHBz70OgiQCNd4Fa6YKr3gYRGDQHvZf0CogRN8n9pL4F8mWpvD66DjI0+sKZVMVwBJP0jtIV9GVnlo35HMfQKO8n1oGm+jZeqtDIM+l4VU8RVYuUnMyEy06qDOtBaV6wAb7+O28yybBtAfDYlO/YiwtyWL0KrWjxPiny7Ip2wQEW76pg8y8EdPxfX8CrpicIlw0bkWB/UB42hPNCNp9aFW7fIzgh3X7YoUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(33716001)(6862004)(6636002)(66946007)(54906003)(66556008)(316002)(41300700001)(66476007)(8676002)(4326008)(86362001)(8936002)(82960400001)(38100700002)(5660300002)(83380400001)(6512007)(478600001)(26005)(6506007)(9686003)(6486002)(44832011)(2906002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3VzvJsuVF4ur+FiAdO7u2m/4YeGHPLdrkhYF8s0Ygr5Ed5VgDAgPXw78xWCk?=
 =?us-ascii?Q?IXPjnfkFxIPiEEvcT/9qOuBI1fNYWpGfBGNC/6IFDO954rwJ9qdyPi3Jqj9L?=
 =?us-ascii?Q?G7V0fASuQTiKZ6s3QDPjXnaI+RzLHEJjsPw8gsBdcpspfXaQtUW58XZYxF0W?=
 =?us-ascii?Q?c77VM3ZVJGuU/KlwoJO1HdR7LFHrq5RDprD/wwyWyOIEme/8uKxxh4voUI8W?=
 =?us-ascii?Q?l6uVd3DkCz51QunGCH16lNRHhbgLKqrDo5vh9gMxUFFZv8p62IR4yttgljEK?=
 =?us-ascii?Q?iHzg9r1KzDaLSfUJtapatr1O8tqPuA44tKxrscCCysZh+bUzUaD4M56nb/lD?=
 =?us-ascii?Q?PVv4f4FAxrKwa5m75xqvVsOeQn2V+8qVsB6aZULuwBUPTeKQJQPMtDT+R8gN?=
 =?us-ascii?Q?WYoQTtZ44VzQ2oP7ZO7ZX7owjNYvCg+BUFOaw4ad3JIGI24y0oQ0zn0knTGF?=
 =?us-ascii?Q?DbeJ3CLCVRp3VxrEcJNGmPp6HrSi/uLnrjsujw1IlUHDfIkqrvCL8g50kK2s?=
 =?us-ascii?Q?dc2h25uWNoGT1j1fmORndHjpveb2IThjrqGDqKul/UPUyu/yl0oHe4NnmaDW?=
 =?us-ascii?Q?pgPjxHNZKrQNnkVyX0TJ86Sv3/L4uw4Es5kUiehlfx3ptHg7G0kzotH0ll+4?=
 =?us-ascii?Q?ali5VKLPZ+M1eba1dXN70u3UZiOPnrBJHsjs85oQqGO1hZRq8Aen96vUYfq/?=
 =?us-ascii?Q?nLfcw1IT2UeNUn0vTRKCaFD8+kc/JGOhCB8QmN/b0CEw7BeZqYpLwA5Z/OyJ?=
 =?us-ascii?Q?RErJmMEQ6Pey1tXV20/ohSr2dz06sAiOirUZgrPQ3XQONN2+L6hVWJiWnFX8?=
 =?us-ascii?Q?XhnEfSYwIlirxR9P56cuYo4oEQe7wIsr9CEdzaSoB7Vi1L3XGtPTCysdOAol?=
 =?us-ascii?Q?lev+UlXQBgOzvB5KDepnr+ZmNZivgK8yvLWEJ4cr4VQGMRVGvyEw+wtxTwQ7?=
 =?us-ascii?Q?Vswj6++6KpMzQXZIABXMRtWTtDP5TkrHnGyI1srqcPGidDlS+qRlFMjGGHDc?=
 =?us-ascii?Q?HH+5qwgFqCPHdfCojn0rA/ftNTXQiYq2vrNrDLQkWP1UejZTvSCxb2WSEw+w?=
 =?us-ascii?Q?ZMSagiZB6q3jFAwLM32/xIJyB/Whv1hlY9ty8pKJyKznU4yk6CXOEKeNEiXD?=
 =?us-ascii?Q?eztIL0K1Nc3sIOzFFZ75e1vVyuJC5QUG8ij+6w+2+ewOVFPQpxYgqnFnnG/A?=
 =?us-ascii?Q?1DwnxhLYGjER4iVxv0cXdfq35dhyBQhs97V3lA3c4klWVh5mP3HmRgJGiNrk?=
 =?us-ascii?Q?+TVlPZB6N0PmFHTla4s/j7OBg9Tiq+JjSJP0LQ2Zh6/Efht8BMfgB+01mdN0?=
 =?us-ascii?Q?++JJHZox6V3jr+U7WQ+q/nRIHz/ImTqj7bpge0Lc6KkZcEMTEVfhRm/dCmdy?=
 =?us-ascii?Q?0OFsm7NzkptIokWOY1rAHuYcSKS2BpZtrO99x1jZcrRwZifZXvJjv9zIPrT+?=
 =?us-ascii?Q?0NmmjFj3UnNA0IM6gyUIwrv3Z0QQiTtlLOoyfh5gza1NRQI1h6XGZrtxvGWF?=
 =?us-ascii?Q?mm6qKdmGkb6STo8eaoYzl7jO79d/OGzDfj4cWZvXSuE4y89ubds9XaU2rAvS?=
 =?us-ascii?Q?Yyaov6L8RzqhjAmFZ2is2JaBBEz0+2A9shw4c03dPWmrGgGGWIvUOCEajSVE?=
 =?us-ascii?Q?43o3fqxyOS1VwPQYEV09ZJE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 879657ae-05ae-4a5a-8c02-08dac4101b8d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 18:11:08.8222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNTXpydMo6sy0BL7aOildDSSDvIDzFjyCJMfADRijePMgOogs7aigGRcDNmZTduPA3lS+ETtdfcN/uqzGHjYV56lK+gCPddTTzI0b84d6vuiH+vkZdsEU0tXLCqYZaDZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6162
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 01:30:27PM +0000, Matthew Auld wrote:
>In i915_gem_madvise_ioctl() we immediately purge the object is not
>currently used, like when the mm.pages are NULL.  With shmem the pages
>might still be hanging around or are perhaps swapped out. Similarly with
>ttm we might still have the pages hanging around on the ttm resource,
>like with lmem or shmem, but here we need to be extra careful since
>async unbinds are possible as well as in-progress kernel moves. In
>i915_ttm_purge() we expect the pipeline-gutting to nuke the ttm resource
>for us, however if it's busy the memory is only moved to a ghost object,
>which then leads to broken behaviour when for example clearing the
>i915_tt->filp, since the actual ttm_tt is still alive and populated,
>even though it's been moved to the ghost object.  When we later destroy
>the ghost object we hit the following, since the filp is now NULL:
>
>[  +0.006982] #PF: supervisor read access in kernel mode
>[  +0.005149] #PF: error_code(0x0000) - not-present page
>[  +0.005147] PGD 11631d067 P4D 11631d067 PUD 115972067 PMD 0
>[  +0.005676] Oops: 0000 [#1] PREEMPT SMP NOPTI
>[  +0.012962] Workqueue: events ttm_device_delayed_workqueue [ttm]
>[  +0.006022] RIP: 0010:i915_ttm_tt_unpopulate+0x3a/0x70 [i915]
>[  +0.005879] Code: 89 fb 48 85 f6 74 11 8b 55 4c 48 8b 7d 30 45 31 c0 31 c9 e8 18 6a e5 e0 80 7d 60 00 74 20 48 8b 45 68
>8b 55 08 4c 89 e7 5b 5d <48> 8b 40 20 83 e2 01 41 5c 89 d1 48 8b 70
> 30 e9 42 b2 ff ff 4c 89
>[  +0.018782] RSP: 0000:ffffc9000bf6fd70 EFLAGS: 00010202
>[  +0.005244] RAX: 0000000000000000 RBX: ffff8883e12ae380 RCX: 0000000000000000
>[  +0.007150] RDX: 000000008000000e RSI: ffffffff823559b4 RDI: ffff8883e12ae3c0
>[  +0.007142] RBP: ffff888103b65d48 R08: 0000000000000001 R09: 0000000000000001
>[  +0.007144] R10: 0000000000000001 R11: ffff88829c2c8040 R12: ffff8883e12ae3c0
>[  +0.007148] R13: 0000000000000001 R14: ffff888115184140 R15: ffff888115184248
>[  +0.007154] FS:  0000000000000000(0000) GS:ffff88844db00000(0000) knlGS:0000000000000000
>[  +0.008108] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[  +0.005763] CR2: 0000000000000020 CR3: 000000013fdb4004 CR4: 00000000003706e0
>[  +0.007152] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>[  +0.007145] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>[  +0.007154] Call Trace:
>[  +0.002459]  <TASK>
>[  +0.002126]  ttm_tt_unpopulate.part.0+0x17/0x70 [ttm]
>[  +0.005068]  ttm_bo_tt_destroy+0x1c/0x50 [ttm]
>[  +0.004464]  ttm_bo_cleanup_memtype_use+0x25/0x40 [ttm]
>[  +0.005244]  ttm_bo_cleanup_refs+0x90/0x2c0 [ttm]
>[  +0.004721]  ttm_bo_delayed_delete+0x235/0x250 [ttm]
>[  +0.004981]  ttm_device_delayed_workqueue+0x13/0x40 [ttm]
>[  +0.005422]  process_one_work+0x248/0x560
>[  +0.004028]  worker_thread+0x4b/0x390
>[  +0.003682]  ? process_one_work+0x560/0x560
>[  +0.004199]  kthread+0xeb/0x120
>[  +0.003163]  ? kthread_complete_and_exit+0x20/0x20
>[  +0.004815]  ret_from_fork+0x1f/0x30
>
>Fixes: 213d50927763 ("drm/i915/ttm: Introduce a TTM i915 gem object backend")
>Reported-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
>Signed-off-by: Matthew Auld <matthew.auld@intel.com>
>Cc: Andrzej Hajda <andrzej.hajda@intel.com>
>Cc: Nirmoy Das <nirmoy.das@intel.com>
>Cc: <stable@vger.kernel.org> # v5.15+
>---
> drivers/gpu/drm/i915/gem/i915_gem_ttm.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
>diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
>index 25129af70f70..fb452a388b5e 100644
>--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
>+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
>@@ -599,10 +599,18 @@ i915_ttm_resource_get_st(struct drm_i915_gem_object *obj,
> static int i915_ttm_truncate(struct drm_i915_gem_object *obj)
> {
> 	struct ttm_buffer_object *bo = i915_gem_to_ttm(obj);
>+	struct ttm_operation_ctx ctx = {
>+		.interruptible = true,
>+		.no_wait_gpu = false,
>+	};
> 	int err;
>
> 	WARN_ON_ONCE(obj->mm.madv == I915_MADV_WILLNEED);
>
>+	err = ttm_bo_wait_ctx(bo, &ctx);
>+	if (err)
>+		return err;
>+

We probably can call ttm_bo_wait() directly without the ctx?

Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

> 	err = i915_ttm_move_notify(bo);
> 	if (err)
> 		return err;
>-- 
>2.38.1
>
