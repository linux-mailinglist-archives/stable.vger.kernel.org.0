Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6747D449D50
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 21:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhKHU7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 15:59:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:51618 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236925AbhKHU7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 15:59:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="212354131"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="212354131"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 12:56:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="563693934"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 08 Nov 2021 12:56:29 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 8 Nov 2021 12:56:28 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 8 Nov 2021 12:56:28 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 8 Nov 2021 12:56:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5GtwzvstMsNMHil2DLrD2UhNEYJLidtnc88x2WC0Drbju/3j7iW/+y+Xp1IEA7OBtMSOKmhIWwx6xIIzEPYomRYHKi0+FmzMNxeGe6uRnBQqVTYCy5JJbncfHYsOak28vkaQNswGkdYsUlYfeSI0/aT46eqhMSn+htTSTn1BQHiRbbkEGHuDgEpiij+blakHWiVHPI7/590zHgGhP5Jx1dhMWOtAIWyZPpa25zpJpnBEEp7Y9HkQi3gAW9UynWy/tcwEaxqS4wpa2oIsnk3npHd0a8xL+hq9eDkrhLbxvwDRkxaxck+JwLxe6MvmLHM7+voROhJ5FmMpI97SjHH7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1aQg4LwHlzDQU+svdYn7HrE48wV6sOmDDRBgz1npRA=;
 b=bVJuq6hI0a10tNhrxlSe0ityW1I1CAZXoRuFBrTi3mee/7EKGH55TJxHxX0mibrD5Qop+tPK0S7NXafaWcNQjn5rUnFqrVjv2RgBwcPsDK/LmE7iVtVe8FV6GGj0DvsaCGF4NgDrXnYMAQQytCnc2ueDiEyww3xE8cACsoPmK1q4tFZgdllUAWJWtk4xQ6e2kWK6e9WmsgIAOfZOvyWlPqTkT7RLpgGjATJfbjw+/OJackCBJtK0wAJPEN6wLTL3ghVt/rQaI5kOR8WUslYkpdj6AZaMTeQvM7XIQTIMvC5CLOu5eJzTOXh8l8pXg/layyDVnuzAShvryH2Pr/L4/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1aQg4LwHlzDQU+svdYn7HrE48wV6sOmDDRBgz1npRA=;
 b=l2alRLG7uRTSlCkmRgkin6f3PUKqhT+ISxe5iv8CvbMtn/2tfwahO/SFNuxTJTN7bSWivUph+L3qrsgE5oXO8qLPe2elnHo+54tJyyvvtp1gvn3Zss1G6/mQruDm2aAzDpk3kl0z3VJhI1JoQ+1kaqrrzKuLdpCtQ0S1S+AGGF0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN6PR11MB1443.namprd11.prod.outlook.com (2603:10b6:405:8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Mon, 8 Nov
 2021 20:56:25 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::494d:4194:b64e:c672]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::494d:4194:b64e:c672%8]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 20:56:25 +0000
Message-ID: <ced9786a-b8ac-2575-02b0-04323c83ca4e@intel.com>
Date:   Mon, 8 Nov 2021 12:56:21 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <dave.hansen@linux.intel.com>, <tglx@linutronix.de>,
        <bp@alien8.de>, <mingo@redhat.com>, <linux-sgx@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <tony.luck@intel.com>,
        <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
 <6e51fdacc2c1d834258f00ad8cc268b8d782eca7.camel@kernel.org>
 <2a0b84575733e4aaee13926387d997c35ac23130.camel@kernel.org>
 <d7a6dedb-03c5-fad1-e112-c912473c7214@intel.com> <YYmEwobYw+jGBSwV@iki.fi>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YYmEwobYw+jGBSwV@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::20) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
Received: from [192.168.1.221] (71.238.111.198) by MW4P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16 via Frontend Transport; Mon, 8 Nov 2021 20:56:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c593f32-5ba2-4cd7-89b1-08d9a2fa3a45
X-MS-TrafficTypeDiagnostic: BN6PR11MB1443:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB14434127091451312BE6F5FCF8919@BN6PR11MB1443.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mq+9X850r/7Qdo0z0/GaP3zzxfZE/O+jwdat0i7wOOmcQl4+Pa7dgqWNKkXppQMoRIkU/5N4XiQhIlAkNyQfQMPok7TIa4jJZQm3bYa8E5Wu17vL/putx4s17W8haffu/LTz5dWojR8QoeroVudiv1rrz+Ls74yVKAKn0yDC8Eb7wvKu9q/LbEfs9QDvzc/lr6BQe9K52EQvOJ6Q4liFjqIxw1r1Bd/NbWUwrqvaV0ESZiXK+B3+ObALDjYhhQU79Q06i0WLb4hDQXoDN0El3F5bMSK041svwyzASOCQKnwoTb85Y7FeJNRCFsXnAlooCiFyeLnLG3CiuahWF+c/Rb8v+9iIYJS3sj5uqOWiNpLYcPLOViX7JyOHPXqTVqme2wsSgRY5FDk2/irRtZuaEbGVI+CLDKDsu/sqDoxJVTwamhgFu8gOguALbQp5TFN8kUcovCyhf1B1LryQRxixrmOdtvrrjYqU/nR2JCVB2aoIp3CzYzsCw2dQwWhBUDhhsGPqjhjUILFeqWzPcSi1sz2hV4c910xfUX6QRQG1rpho5/Ks+Gr3ifVeT13Aq5tB4LyVhMK/FrEq4GX8qnJvzthYQZC4z7dzPb2uotJYX1ZsFJ1X2/ZaLl8eQEyKjw3TAQwc4NXl4pQlDmnvXEIwHp18Rk83q1/Yic/EQb7ZogH5UOsbYFyYqtsXAheHhX5Rdpxi42xFyKXk1id7vA8KKoXr6x+3Ur1N3Pazv3cZitYotuXJPuqCHIsT6kykrYA26t2aLuyErksTlGo2eCMMC/w20TFPR7vls7jAc4ZWTzbcgp5p7JIe+8lsItiUX2PJl7qZpz5Qx0Ragc4IXnrNsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(15650500001)(7416002)(6486002)(86362001)(4326008)(316002)(36756003)(6666004)(6916009)(508600001)(5660300002)(2906002)(44832011)(956004)(2616005)(66476007)(16576012)(8676002)(8936002)(26005)(66556008)(966005)(38100700002)(53546011)(186003)(31686004)(66946007)(82960400001)(31696002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q09FeFZwTVdPRVlQaDBBRExnbFZseUZ6aGRXZElnUDFIdDg1WTczZVBVY1l2?=
 =?utf-8?B?TGVTa3hUcU45ZS9rZFdiV2F4bWJTWGVsWS8wWmg5dy9SL2FLT3Z4VDNodER2?=
 =?utf-8?B?Zkx3MGNjUFF5NUJOWjNLL1hzV2xYeDk5OFVPYWJFanJBTmQvbGtNdXBiaXhX?=
 =?utf-8?B?UmJnbXBYcHBLY2s0L0QvdkJYTld2b0tFYWR0RGVJN0dBOGtHNHJZcjdqeUNv?=
 =?utf-8?B?cUNtWEZucCtldVRPOGVQWXN4YUsyWmJMbnlQanVUUmRsNERlUHFlNXkwTHJT?=
 =?utf-8?B?QkRKTlk1bHZic1FQSTVtd1V6REUxeW50K09zVXVqN0tPWWMxaVFQOVREamJM?=
 =?utf-8?B?VmR0eGtCd3haN1VVejR0MUpXcmJnZjJXU0RRUHZnczIxTkEyYllKQlYxMDJn?=
 =?utf-8?B?VmVNenYxcXlYUXRPcFpkQ2YxYmlpaTJiRDdKNkIvb1JPaENKbDVXN1R1bFJ0?=
 =?utf-8?B?MjdhUHE5bVBTUFpyS0dreWV2UXpidDE4VnE1RmN6SVF0ZjNJU055cWdUU0V4?=
 =?utf-8?B?L1ljWmdZKzYva0YvTkNxMytydTU1RytTSVBkTVdJRDljbjlWUEZuQ2wyT1Av?=
 =?utf-8?B?dkFDVzNMRGR4bWxpZ2VMbGI0QUU3OG9yWG5QakVQaWRidGl2eEJNOGlCcFV5?=
 =?utf-8?B?ams5MjF6WWZsM1h1alR0VDZzMmo0WFZzc0t4bHNxYXRWZm9mbDJ3ZUFDL3FF?=
 =?utf-8?B?TmNERiszYU0yRU9ZZ1lROExhUWdLVEIvVFJCQ2J2ZnNoZ00zWWovL3ZQWjlt?=
 =?utf-8?B?Nmx1OExHWlNUR0ZoZjFadGs5WVQzL1F3aGNOV20rYi9oRGYyUUNuR0d2MmUz?=
 =?utf-8?B?eWVtdFhnakNlV2pqZjdhdnFvSEloYnA2T1QwRk40SkszL3poRVBBMDBDamdX?=
 =?utf-8?B?Y2V5ZFIzNEE5alVOajBHTzQ5dWZ0U2V6ZE9uWGFibHRyc29GMzlFbmtnQUZY?=
 =?utf-8?B?TmxMdmZVTU5QdnlFNmJrSTVyb0s2bzlIV3ZFTXlrSDV3UTJ6bm1RRDFHVGZX?=
 =?utf-8?B?ekxLV1YwSUo2cWYyOHhoNW1Cb0RKSXJGUjhTd3lpYWltSlg1QWtRUGU1Y0wr?=
 =?utf-8?B?SExpdnJEdnRmYXJjNFdBZW9BQWRiMG05QUdsdUFKYnZLVXdFMzU0UVlpQVlX?=
 =?utf-8?B?SHUraUZRbi9uUmViWll1V0JCdzZaZXdoQ29OdURiOXVlcVlaQ2lmY211V3I1?=
 =?utf-8?B?RkVYYVFhK3ZiR0lKZVFsemw1SW5oNTlBdVI2VkU0Vitkd2JNcm1aYzd1dkFI?=
 =?utf-8?B?WnB3SDhybkFqN2ZzOXY3VCtYMUFxYUM0NThiZnp2dkRUUnZrZmw0WjdMWEJw?=
 =?utf-8?B?VHRyRVVYL3RrbWYxUUNtTFhRZUV5R1NGRkNjTHdpRWtBTlJCZDZrMURQdktQ?=
 =?utf-8?B?aEhpNW5IV1dWVWE0TFJIUVc2NWlrZUlzT24yU3FBeWVDV3luTm9MSlcwcmpP?=
 =?utf-8?B?UmZNc3dySnJ5bnBPVDRjVkVEeXBxR2dOK2JxNGJNQUhFU3RyaU5ubGtlTVlF?=
 =?utf-8?B?a0tFMWRGTWJDK0xQZy9iYzlYU3lvVXZjbzZrUXU5SlRLVUlhcllSQXQvdmpo?=
 =?utf-8?B?NHZnUnpoOHhVYTk2UCt1SXFXM3FRWUdLOHh2dWt3dC9acXdhWGR1Wmk0UFRY?=
 =?utf-8?B?NzVIMkZmck5UN0dGb0I1YWtGdkV3WmZ4SGpuQ0E5SDI3bU4rZVljankrSEpn?=
 =?utf-8?B?S1VmTWR1bGt0Zy9KWFVrenBtMVNlUXAyeDVOOUJGR3RFUGQ3WGpwZzJEbXVJ?=
 =?utf-8?B?aW5WeTZUQ0tEeUdjRXhER2pQM0pTeGJiSTJHUS9LSGd3ODVqcWVQVjRDeDJh?=
 =?utf-8?B?aWt1MXRzOEhMbXozT0NZa285TnJrYkZrUlFCTi9FQ0xlU0szdkYwYW9SWWl4?=
 =?utf-8?B?VnhCTXFZU2wvdjM0NGhQOWVKQkNtbDE4UEdaR3pnMllXOERnOTVVVENxYzV4?=
 =?utf-8?B?MWpRcVhMcTdMcmVNTzhsSkxralpZVFZyRVJ6bnF5VHE1bm5xOEs2YXV6T1Rr?=
 =?utf-8?B?alRMMlNZUndNNE12V2EvR0Fxc2JRYm1CakU0dkNaZ0JIVXhLNGZOSXg5a0xz?=
 =?utf-8?B?OWJvVFZObE1mN2dHeWMwam1ReWpSTy9UbCtBL3pTUERXWEJxNnhKV2V5OXpq?=
 =?utf-8?B?REJHb0J3SURsUFVMV281cUwvZmRUSDRPTXBlcXZHQ2hjTVVDSDJPQTQ5N0lD?=
 =?utf-8?B?cGUrYm1LdWJ1bGJRdFV2NFZPc0wxeXZ6QlF6aVFmZjBFVVlCaEdxZndyNTNn?=
 =?utf-8?Q?/mkTZBP/QqO3ia9S+gVWDLyef+rjhh1yZQEURviZsY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c593f32-5ba2-4cd7-89b1-08d9a2fa3a45
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 20:56:25.5344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /yY5DbToPVimL6C+yXOBBtIjICTRX5sHYMPvoClhrb2CabL6MDzgc+/ROrH69BNvYaIU90UmSYj6o0rkkdw3kjST+1Qb2j9WnuHTBK6HhmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1443
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

On 11/8/2021 12:12 PM, Jarkko Sakkinen wrote:
> On Mon, Nov 08, 2021 at 11:48:18AM -0800, Reinette Chatre wrote:
>> Hi Jarkko,
>>
>> On 11/7/2021 8:47 AM, Jarkko Sakkinen wrote:
>>> On Sun, 2021-11-07 at 18:45 +0200, Jarkko Sakkinen wrote:
>>>> On Thu, 2021-11-04 at 11:28 -0700, Reinette Chatre wrote:
>>>>> The consequence of sgx_nr_free_pages not being protected is that
>>>>> its value may not accurately reflect the actual number of free
>>>>> pages on the system, impacting the availability of free pages in
>>>>> support of many flows. The problematic scenario is when the
>>>>> reclaimer never runs because it believes there to be sufficient
>>>>> free pages while any attempt to allocate a page fails because there
>>>>> are no free pages available. The worst scenario observed was a
>>>>> user space hang because of repeated page faults caused by
>>>>> no free pages ever made available.
>>>>
>>>> Can you go in detail with the "concrete scenario" in the commit
>>>> message? It does not have to describe all the possible scenarios
>>>> but at least one sequence of events.
>>
>>
>> I provided significant detail regarding the "concrete scenario" in a
>> separate response to Greg:
>> https://lore.kernel.org/lkml/a636290d-db04-be16-1c86-a8dcc3719b39@intel.com/
>>
>> That message details the test that was run (the test hangs before the fix
>> and can complete after the fix), the traces captured at the time the test
>> hung, analysis of the traces with root cause of why the system is hung,
>> traces after fix applied demonstrating why user space is able to make
>> progress and explaining why the test can complete.
> 
> For me that sequence looks like something that you could "abstract"
> a bit and get a rough description of the concurrency scenario.
> 
> It is as important in this type of patch, as the code change itself,
> not least because it helps with maintaining in the future to have
> that info in some level of detail in the commit log.

My apologies. I understood your comment to be a concern with the change 
itself instead of just the commit message. I will add more detail about 
the failing scenario encountered to the commit message.

Reinette
