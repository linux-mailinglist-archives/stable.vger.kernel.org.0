Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AFC449C4C
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 20:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbhKHTWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 14:22:51 -0500
Received: from mga17.intel.com ([192.55.52.151]:60632 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237013AbhKHTWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 14:22:50 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="213040106"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="213040106"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 11:19:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="503162617"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 08 Nov 2021 11:19:30 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 8 Nov 2021 11:19:29 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 8 Nov 2021 11:19:29 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 8 Nov 2021 11:19:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6GzIwk4n8IFvYApr8ww+bMH75q6OBntkzHoOcCfaeeNg9maGuqyqxbhd8xxFsWyWXcYjV8lu+aO7y5kD2WrDjnssBpCvs4vssi0OXTwtxfFC/tprcPj9NvsjR3RMFWdyPEO8g2WPg5ySoxJcQ7CGsnv4VbomYPURoHMoruaGATGXN+alPI/d53/E8gg4tTaWq0SMxxUU5u6hjEwIdHSziHNJKW0yygnlvEQ9rJbo0pVMvi45pVwF3lBo1CW/wTzGGCpv1QbQ9USc1kKZ+GcCg/8MOzwwKBn7XQzmC3bip8Uo0cRcn2yM94dkEjJDT35hJWQ/Dpl2+Yu9cb57karog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2QxL3BXK4P2VVHcJnuK06p0wDUBp3u4Y5CW8RrY1R4=;
 b=FELIleeNLy6UhOFmdkOkzjp+LoXlZ3N/n3avOoyohn5GIe07qiukj3lx3CnfEcbmoO0jbBpNWQUZoamq1jPkJaM8LS7Rli+8234fNTlGelNHkKFtnQS2nYxsN1AATRN8IvMKcfQqj6xydu1V5dCtZgN1yPmzsVSUXjG1pnM1LM+lHZ6I3UzmKjbhtQYq776La4fnBbjnu9pYIJG7JPTAIIwA0yqsi8v/iEyYsb88PwIqxV641ikiuuA2+cBerfAqR0TckCzdo6fBfViMzT8ak33yy4KeVSy6gDjU8w+vCLbwkEiu/lm6athmLI+EhPFQj2+iH8Jpw3kK9D8Vkl3n2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2QxL3BXK4P2VVHcJnuK06p0wDUBp3u4Y5CW8RrY1R4=;
 b=UxirgljNewmkEE7pk1uAC10l50yDsDFVR9GThsFm0Uu3U7UjhmD/3gClI1f3ZWb9G+Mk8Wfe7Xlgc4EBabOtyxFCBxPM0jDLmN7TgvotFxLeHBvyIt+B9rM6NrLxad7V5xlb8eInY5zdhGBlhZr1/q0Mcpn6hJqIVy3m87ZcK5Q=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN9PR11MB5308.namprd11.prod.outlook.com (2603:10b6:408:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Mon, 8 Nov
 2021 19:19:27 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::494d:4194:b64e:c672]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::494d:4194:b64e:c672%8]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 19:19:27 +0000
Message-ID: <1943c7d5-1840-9e27-ae03-96489ab8766a@intel.com>
Date:   Mon, 8 Nov 2021 11:19:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <dave.hansen@linux.intel.com>, <jarkko@kernel.org>,
        <tglx@linutronix.de>, <bp@alien8.de>, <mingo@redhat.com>,
        <linux-sgx@vger.kernel.org>, <x86@kernel.org>, <seanjc@google.com>,
        <tony.luck@intel.com>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
 <YYQsc0kktaOdOXb0@kroah.com> <a636290d-db04-be16-1c86-a8dcc3719b39@intel.com>
 <YYTY60T7YzycEAmp@kroah.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YYTY60T7YzycEAmp@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:300:4b::17) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
Received: from [192.168.1.221] (71.238.111.198) by MWHPR02CA0007.namprd02.prod.outlook.com (2603:10b6:300:4b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Mon, 8 Nov 2021 19:19:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34d4837d-b1a4-4ac3-8529-08d9a2ecae6a
X-MS-TrafficTypeDiagnostic: BN9PR11MB5308:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN9PR11MB5308A258F5553724068AA97EF8919@BN9PR11MB5308.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sXZpcTKvHRtjlR0V0K+o9a8r1qxc6snpMg5H4Z2oFhI2QiduLtzNLXW1OwrrDHVdUWqt/IXS2og6jrwRbOKkX+x0guap4FTbGuch1JRWM35kE98PcbSyeGXlireZKZi807pzUjVtOZY7kCaSaGNHgdp7t+RVVypqBRJ7t7AC030rXSwlkKAECpxoa1nGkrs/Agepbxxpknb/PjYn5gZh4f4l0bSsSSyset9BEs/aACelIxi7xR4AnJSdJg9Ktceu+9GkRCB09QrlXpU4mA69thL7EfybbIrRHwG7TJq8+j+sfkhpMpkAvAFcugGWaBgNEQSQEEiOY/orYMqOMar/KPqsp/GWm8vC3fXcyOQk6omqAgfug8AwigPIAoM2RQc8tDSpMu++On3uehDMt+2VHiPiM3Kw0+yLAYQ+1sxEVF6Fd3KjCdGuGxibeSnDcgxVnvizE6nc4dEuoc/rJ3UCD3jYkJwEuWIeCGFXMT5d7iIStQY0Olf7kJAj8U9wJEPf9k8C4PZI4BHbGQ8N6zorCPmbcZtbXikMFzYXva2JPUICOlvAB2lZaVYUH3lEVduTIkkozPFOsTlbdP8YnzR8o9apVmW5T191/9n5t7pRiRD4wAeZ+W6E9CCZZqsC8Lrt6zNVUdHcp2bUDnsNgONbvpNkLXhE5RHt/lSvRefSf4st36fsIly8XIvpUbQwVna+nb/IWZjEKbc2VBL7X56Wtobmte9XA6pIEIgm+kaHE58=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(316002)(4326008)(6486002)(36756003)(16576012)(66476007)(66556008)(8936002)(66946007)(31696002)(53546011)(15650500001)(7416002)(31686004)(86362001)(2906002)(8676002)(6916009)(508600001)(26005)(186003)(83380400001)(38100700002)(44832011)(2616005)(82960400001)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajJwNXQ1VUtKNk5sajEzYUtiRkdoRklvMDM0bzU0WlpRSlhZbDd0TTJCaVAv?=
 =?utf-8?B?NzA3cUtCSU1hYlpQdGcwN0ZOY0NlK0VQUll0enY1cERhKy9Oc3VYdmUxWDZh?=
 =?utf-8?B?UFVldmkzS1NNNjRTRTU3eSsxZ0FGTytGcGtrNXhRZ2Ztek5ZbDBKdjFzMzRW?=
 =?utf-8?B?NkNHQ2c2dDdCQ0dQWHNHOTBkNG15OGYvVEJiZS9BRUZ1VGJBNFZuMjdtUklF?=
 =?utf-8?B?VFJub0FqbXQzbFdZNnZaS0gvOGpWOU9uY2JQTGp4alU3OWJxTWUvcjcvaGRH?=
 =?utf-8?B?Ry9NNEFHWTRVVW5qSmwvUzJCQ3E4RG9NUHVYT3VtV09nR1JNWXg0VHh0ZDF4?=
 =?utf-8?B?bHU1RFM3amJNRWZUVlI2VVUrd0I4dmdDTUpOTkMwRTF4NFVjRjFVbElmY08w?=
 =?utf-8?B?ZWpmM01tRVVhNW1YaCswSnFncTJ5VmUzdnB2eDhBRS9nUnlEMzN2VEdyS2dw?=
 =?utf-8?B?UXRmb0w5cHVWbm5iWi9GalJTcXJrWnFVUURmUGRSdFFjalBRM3A3a3QrU2pG?=
 =?utf-8?B?L09pZFRMZkM0Uk5Zdk5KaFNPbXhQUW5tNTZGdVZVcmxQemY5Ymcrait3MVk2?=
 =?utf-8?B?d1BDYXNyeVZxZ0dZU01GYjlSR3E5SkVpZDhpNFVIRW1uVngzQ1F0bEhiOENM?=
 =?utf-8?B?WHZPbjhrRnZCQ0dqYXorSWZoWWtQTE8rNmMwU3BVT0hzMTlJRm5UNS9yS1Q3?=
 =?utf-8?B?eENSdGo5VWQzdkpNTXgzSDc3V1A5RnQ4M0Q1MDFNSWxpaGY4dEVtNTZSQ1h0?=
 =?utf-8?B?Z1dISm9adDB1YU11WnNwWWtiYkJVYml6c3ZrR1FCTnFDd1ArZ2lHYWRBTlNx?=
 =?utf-8?B?YlcrMW1URGUyT3ZlU3NqZmNXVzVSVGl2eFV5UERFV05mcmdidlVydEFrQ3pB?=
 =?utf-8?B?UXFWcEFrTmQrcFpMU3FDSVBDTmF0cURBbnFSdjZYVThyVjM0SEZSeHBLSktm?=
 =?utf-8?B?ZkVOSXFIclltV1I2a1ZtYjhsSGt4QS9WMmpIYmQ2Ny9OTERYaGw5d0Z5VXd2?=
 =?utf-8?B?dGg3OEVidGNtUXdQT09ScURyQzZtenBZMGpjMGcxdHNXRFVKSDUyU0lsMUp4?=
 =?utf-8?B?bU1QWGhla1JnWWQzUzVSRjZ1MG5BeGJTWGthVHAvVWZYTjdUazU1NDl5d1Fo?=
 =?utf-8?B?ZkdsZHEzd3dIa2ViaTh0NXc1V3o3bkJYQnI4S2JOWVF2ZmtGUi80OFNweERC?=
 =?utf-8?B?bUpmZVhVQnNmR0NqMFNPd0Vsazl4a0pYNXJzN1hDbWcvVDdkNU9PTml2NWlj?=
 =?utf-8?B?bnFYYWN5MHJKYXRKUUhjYmdHNGNsT0hYMSt3WjJEYlllUmtpbUZ1bDRLRG9T?=
 =?utf-8?B?V01ucDFHTE1Xc25idm9PaU1oZHcvRHA5V2ZXamtPYTlEQ2lmQmVocUtGV3do?=
 =?utf-8?B?cWNtREUzZTRadDZHcHRBYWVRa0N3L2FaMWl4dGRuTTF1SU5kWEp0Rng0WnhJ?=
 =?utf-8?B?dmtYVU91TFlKTTNsR2I2UUo4QmhVb3AwQXUvcE9hZThJdHo4bWYzWmMvVmNS?=
 =?utf-8?B?SDlMU3o4dlZUVXlvSnBsTzhQNURpcXpBTEltUGowdDlqSWt1RkMwMlQ2MDcz?=
 =?utf-8?B?YVVSUjdXeElhdG9HUitNUGIyOFEycUQ3NWp4R3UwTmt1bWt2emJGWUZtUXRH?=
 =?utf-8?B?aDFGTldIMnpoaE1VaVBxdi9NMGhuTXUwRGFObndQYnBCUDBVaUV2OHo4WVRN?=
 =?utf-8?B?ei9LTy90WHJpTFc3YVY2elV3ckR0dDNCT0hUUGo4YkVaK2pjTUxTUjB1dHBQ?=
 =?utf-8?B?eEdBOUxCVkNqRXdpcmliU0pMaDdGMXVrbnZzR0pvdmtBekZXSFRYeWo0cjIr?=
 =?utf-8?B?Z1NVTlU1THQ2VmtIVjFuS2N1TXdpTWRFVmxyamhDMnluTjZ3RC9UK0lLNVcx?=
 =?utf-8?B?MEVqR2g2TUE2b3JKTzFLVXp5M3hOVlNud2s2MFcxZnBWc2t0Q1FkeWxwZTNR?=
 =?utf-8?B?c2hQYWp1MHhTZnFMbTdvVlRDaHhMbGtrb3pOOVZLc2Q3M09xZ3JwZWlab055?=
 =?utf-8?B?Zk9xZDl4Z05QTmVveWlqZWRtVWNucnRNZW8wU3hwOUpJeDF5NlRwdWZmK0F2?=
 =?utf-8?B?dnFrYkV6NG5tcEg3SFRQU0dsOXY4SjZHUGhwUEx3eDcvS2ttMHBNUUV0bWd3?=
 =?utf-8?B?bmNJSC9lWnZSM1c3ZzlxMlg5bm9XUitkS1Q5YjR3SlJpRnVxN0FtZDJjOHdT?=
 =?utf-8?B?VHpCUG5uTkxwOUtYWWtORTgzcDdNNmVtQlZSdFJSd1A0aEdlNFRjWlFHVDcr?=
 =?utf-8?B?dm5qUGw5Wk5KazZxNGhDdFBDWmdRPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d4837d-b1a4-4ac3-8529-08d9a2ecae6a
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 19:19:27.5019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22vnEOjbwppB/NdTxyKBj/VWXChjYt9OdqQb+vxU5Ztbm8KWHwYkuzAbYtyk2Oy8XLw0vZYWYxE+ErclrrA3jRaVyI1g8yezUploznRAyzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5308
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 11/5/2021 12:10 AM, Greg KH wrote:
> On Thu, Nov 04, 2021 at 01:57:31PM -0700, Reinette Chatre wrote:
>> Hi Greg,
>>
>> On 11/4/2021 11:54 AM, Greg KH wrote:
>>> On Thu, Nov 04, 2021 at 11:28:54AM -0700, Reinette Chatre wrote:
>>>> The SGX driver maintains a single global free page counter,
>>>> sgx_nr_free_pages, that reflects the number of free pages available
>>>> across all NUMA nodes. Correspondingly, a list of free pages is
>>>> associated with each NUMA node and sgx_nr_free_pages is updated
>>>> every time a page is added or removed from any of the free page
>>>> lists. The main usage of sgx_nr_free_pages is by the reclaimer
>>>> that will run when the total free pages go below a watermark to
>>>> ensure that there are always some free pages available to, for
>>>> example, support efficient page faults.
>>>>
>>>> With sgx_nr_free_pages accessed and modified from a few places
>>>> it is essential to ensure that these accesses are done safely but
>>>> this is not the case. sgx_nr_free_pages is sometimes accessed
>>>> without any protection and when it is protected it is done
>>>> inconsistently with any one of the spin locks associated with the
>>>> individual NUMA nodes.
>>>>
>>>> The consequence of sgx_nr_free_pages not being protected is that
>>>> its value may not accurately reflect the actual number of free
>>>> pages on the system, impacting the availability of free pages in
>>>> support of many flows. The problematic scenario is when the
>>>> reclaimer never runs because it believes there to be sufficient
>>>> free pages while any attempt to allocate a page fails because there
>>>> are no free pages available. The worst scenario observed was a
>>>> user space hang because of repeated page faults caused by
>>>> no free pages ever made available.
>>>>
>>>> Change the global free page counter to an atomic type that
>>>> ensures simultaneous updates are done safely. While doing so, move
>>>> the updating of the variable outside of the spin lock critical
>>>> section to which it does not belong.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
>>>> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>>>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>>>> ---
>>>>    arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
>>>>    1 file changed, 6 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
>>>> index 63d3de02bbcc..8558d7d5f3e7 100644
>>>> --- a/arch/x86/kernel/cpu/sgx/main.c
>>>> +++ b/arch/x86/kernel/cpu/sgx/main.c
>>>> @@ -28,8 +28,7 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
>>>>    static LIST_HEAD(sgx_active_page_list);
>>>>    static DEFINE_SPINLOCK(sgx_reclaimer_lock);
>>>> -/* The free page list lock protected variables prepend the lock. */
>>>> -static unsigned long sgx_nr_free_pages;
>>>> +atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
>>>>    /* Nodes with one or more EPC sections. */
>>>>    static nodemask_t sgx_numa_mask;
>>>> @@ -403,14 +402,15 @@ static void sgx_reclaim_pages(void)
>>>>    		spin_lock(&node->lock);
>>>>    		list_add_tail(&epc_page->list, &node->free_page_list);
>>>> -		sgx_nr_free_pages++;
>>>>    		spin_unlock(&node->lock);
>>>> +		atomic_long_inc(&sgx_nr_free_pages);
>>>>    	}
>>>>    }
>>>>    static bool sgx_should_reclaim(unsigned long watermark)
>>>>    {
>>>> -	return sgx_nr_free_pages < watermark && !list_empty(&sgx_active_page_list);
>>>> +	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
>>>> +	       !list_empty(&sgx_active_page_list);

...

>>> The value changes were happening safely, it was just the reading of the
>>> value that was not.  You have not changed the fact that the value can
>>> change right after reading given that there was not going to be a
>>> problem with reading a stale value before.
>>
>> I am testing on a two socket system and I am seeing that the value of
>> sgx_nr_free_pages does not accurately reflect the actual free pages.
>>
>> It does not look to me like the value is updated safely as it is updated
>> with inconsistent protection on a system like this. There is a spin lock
>> associated with each NUMA node and which lock is used to update the variable
>> depends on which NUMA node memory is being modified - it is not always
>> protected with the same lock:
>>
>> spin_lock(&node->lock);
>> sgx_nr_free_pages++;
>> spin_unlock(&node->lock);
> 
> Ah, I missed that the original code was using a different lock for every
> call place, while now you are just using a single lock (the atomic value
> itself.)  That makes more sense, sorry for the noise.
> 
> But isn't this going to cause more thrashing and slow things down as you
> are hitting the "global" lock for this variable for every allocation?
> Or is this not in the hot path?

I do see this as being in the hot path as it is in the page fault 
handling flow. A global lock does seem to be required since it is a 
single free page count that directs the reclaimer and that counter needs 
to be updated safely.

I obtained access to another two socket system where I can test this 
issue. Since this system also has two NUMA nodes it updates the global 
counter unsafely but on this system I am not encountering the user space 
hang and can thus test how much things are being slowed down by this fix.

Interesting is that without the fix the test is actually slightly 
_slower_ than with the fix. I am speculating now that the issue is 
indeed also encountered on this system also but not noticed because the 
global counter can correct itself after some time and not get stuck as 
on the other system from which I sent the long traces.

Here are four runs without the fix:
real    0m47.024s 0m47.433s 0m47.547s 0m47.569s
user    0m7.204s  0m7.292s  0m7.265s  0m7.388s
sys     0m39.806s 0m40.129s 0m40.271s 0m40.168s

Here are four runs with the fix:
real    0m46.893s 0m47.328s 0m46.786s 0m46.635s
user    0m7.351s  0m7.252s  0m7.130s  0m7.170s
sys     0m39.528s 0m40.063s 0m39.642s 0m39.452s


>> Here is the perf top trace before this patch is applied showing how user
>> space is stuck hitting page faults over and over:
>>     PerfTop:    4569 irqs/sec  kernel:25.0%  exact: 100.0% lost: 0/0 drop:
>> 0/0 [4000Hz cycles],  (all, 224 CPUs)
> 
> <ascii art that line-wrapped snipped>

Sorry about that.

> 
>> With this patch the test is able to complete and the tracing shows that the
>> reclaimer is getting a chance to run. Previously the system was spending
>> almost all its time in page faults but now the time is split between the
>> page faults and the reclaimer.
>>
>>
>>     PerfTop:    7432 irqs/sec  kernel:81.5%  exact: 100.0% lost: 0/0 drop:
>> 0/0 [4000Hz cycles],  (all, 224 CPUs)
> 
> Ok, that's better, you need the reclaim in order to make forward
> progress.
> 
> Thanks for the detailed explaination, no objection from me, sorry for
> the misunderstanding.

Thank you very much for taking a look. It is much appreciated.

Reinette
