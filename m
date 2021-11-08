Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC71449CAD
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 20:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbhKHTvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 14:51:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:54125 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237645AbhKHTvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 14:51:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="232260303"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="232260303"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 11:48:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="491348499"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 08 Nov 2021 11:48:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 8 Nov 2021 11:48:29 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 8 Nov 2021 11:48:29 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 8 Nov 2021 11:48:29 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 8 Nov 2021 11:48:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfyXM/yluzrcHU8DeExpNyYXwU/uIsMHWk0X4m0DC2WyjZek6JH7tbW6PK9IGuWBrVzXTyJqXiyULfHIS4/eg0xW/4Bbv2zCzFBVvyBhllruKGljIQBfFQLZpv+618lxApC3wd/JPk29ZPefcywGNkZ7b9kHHYXx7Kn67SQnt6PAfQ8s1m6rghUWH7wnHRYeW21Mh/GAnPYBoG+L31EigYmiSmVOaZBNCx7WjLjdi5w67YC25hd2pg62u7uw6SPHDU/YpT5/JAyoq3ixGWdXpDJO7sejjLv1Hn+giBVROgj2RDoXXbVeT8h5TgH6VnkJaG4DdlDSvW6+OTO+eySghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yb09ejPVreLVJbX0ZsGjoGr3pOPsixSlKijuBjm2LL8=;
 b=P/6FPXnSmcn1tpde/lViLf2cZWfWcxF2AMnsIyZcQtjlIqAEGUOsOpqkOxQ+koSLM6sGzPzZkQ4VKj7UBZet0FUAvZAsDlk1eSiDOIluLI3gPcIwPWHEVQphgXI82KkyiKZDAukksSyJPgVVu1t9UdVUg0HtqizrL/87Mlcq/txYlyw+N7/bd56HEUo230lzwKnsP9RDubAhu1iCC5pyKpiVzx/a2b88nTJXq4UTQpx+r8h7KphPH1OaaNTgZ5dAgB+hM5MBC5Z6Hb/zR2SBVxD6WDYW5DrM6cu0RTs8CY77QFQSMhO2DJe2uqbkBg0Wr2ReMdrmx11lKB8pvOSbCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yb09ejPVreLVJbX0ZsGjoGr3pOPsixSlKijuBjm2LL8=;
 b=AtoeElJ2nbAsTwaeBaO3o7WzrKR28LiVKT7V7v3+SdJ4Ov7eqtZ4vMjk/unjKRlWWBJzE3gskReZhi6mqU7V8VJ+TFSwtuRVpyhj0Rr4A6GSz/acl/bIkbpoZadd36Dr59dQMLOQvcO5FY5oVbcZ12sNv1rRBJTUh59+v2q5tXE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN8PR11MB3553.namprd11.prod.outlook.com (2603:10b6:408:81::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Mon, 8 Nov
 2021 19:48:22 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::494d:4194:b64e:c672]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::494d:4194:b64e:c672%8]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 19:48:22 +0000
Message-ID: <d7a6dedb-03c5-fad1-e112-c912473c7214@intel.com>
Date:   Mon, 8 Nov 2021 11:48:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <dave.hansen@linux.intel.com>,
        <tglx@linutronix.de>, <bp@alien8.de>, <mingo@redhat.com>,
        <linux-sgx@vger.kernel.org>, <x86@kernel.org>
CC:     <seanjc@google.com>, <tony.luck@intel.com>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
 <6e51fdacc2c1d834258f00ad8cc268b8d782eca7.camel@kernel.org>
 <2a0b84575733e4aaee13926387d997c35ac23130.camel@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <2a0b84575733e4aaee13926387d997c35ac23130.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1201CA0006.namprd12.prod.outlook.com
 (2603:10b6:301:4a::16) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
Received: from [192.168.1.221] (71.238.111.198) by MWHPR1201CA0006.namprd12.prod.outlook.com (2603:10b6:301:4a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Mon, 8 Nov 2021 19:48:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3434b01-1045-4ada-34d7-08d9a2f0b870
X-MS-TrafficTypeDiagnostic: BN8PR11MB3553:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN8PR11MB35536AD43987B82C118B263BF8919@BN8PR11MB3553.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZQZHsvotbiR+E54EVFQPYLcYBvzlFX1O7vmzvj9bs3BwfRP6ryAtbAtdMoir0n7m2TaQqPn3owfuug9eGKWCMXnqZxbCi2qn7hEpK8PZ75pgVC2wC7qzfXa7ma8vX+/0QarfyuxuC0pPARDssnWpjXnCug2BZ7nt90kBrifLNBs5cEJAbI9aGiMNp7LkEuAHiMaEmDIwfiYaY+vpa6PcrUfh/sUa7bBJYFaHoBI2YKHpTVS3FHQ2NaklWdMs46zQRMgAVZl1Acuj0GwrsWvh707Oewrx+M2yZBwnArtAShNCk2EzXZ1zaoOJxW2Px8JmBs1dov0h/SJDAF5T2nPy0XnmTEszRX4FC12Ts9zJlJXvj3YomzgebCdGg7ZFvu4cWKYvolmV3HO3PUA0Ur467kCY09Fxt5n3vYHZgpnU0mNeCXPktcm4gpXKcNgfnU4emUhnN+2C+ru3DOVWd9cfBfr0/c3qZnsVBDTU+/BzHzeYUYWn1UoVdQPV0d9F8ddQMtJF6YFqQNvG6onkCemRgJFnFJCM9OPG4QpX24JkpAMfzYfUXvW+5iILl/Ej3lWHiO9xIHv7fQl9BBB5EtyPIEv4hGeKUW12ELF7yFweyhdUbZ8/v5RC63+phBeZ0zdDPyXdX7nMTE82eVYcO0YmefxTDzpeDXAv2vtrs0F6I/C5fxa7Sf6tpupmGM/K38bTRBrmbxRWJyUtHvXjMUFYQNYM0OLEz/h3hfC15d77Z/Lg9yqPfTxZ0+Wn2jBWgN5RfFk8jmiDqRKAgzRoLY8AR16sptJ539jBXUx29veNO7KagK3JRCEot8HdMUKJX9Py
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(8676002)(31686004)(15650500001)(6486002)(66946007)(26005)(8936002)(5660300002)(66476007)(36756003)(44832011)(82960400001)(186003)(2906002)(66556008)(966005)(7416002)(38100700002)(83380400001)(956004)(316002)(86362001)(2616005)(53546011)(31696002)(4326008)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c21XRFp5dEgrNU03QXpONVZhUEQyWmtteTZRNlV0RHlsTzRwTTBtNGhIdXp5?=
 =?utf-8?B?em5oZVU4djNQdGxCSXNWSGNBWnlvcnpTeHRqUUlpV1BiY3oyN2RMY2hpUkYv?=
 =?utf-8?B?ZS9yYUFFUmtMdVdIb1NIUjBEMVpZNm9NY2J1UGNnYUZEbndwaVk1MU5BK3V1?=
 =?utf-8?B?M09UUjZESWFMdUJ1ZlhPL1M2c1ZxNWY2bks1ZzltT3BrbW1VOThrcWJIVFNV?=
 =?utf-8?B?MUsralBEb1dOQmtyckRrSE9MY1JIVEJxTVl0ODBqRTJ2aDJBQ2dpdGE0WUFR?=
 =?utf-8?B?TVNSMlNZWWFCSkRNMW1kTzdtd3pBTEl1cGY2cExPYWZKZG5DbFpOZnExNHg1?=
 =?utf-8?B?NVlaaE9uM1NMcDJ5bWtYb0l6VjJBcHdqR1ZyM2Rnd1FRVGNCM01jbThUTVIw?=
 =?utf-8?B?VFVZdjdZc2k4WVhxM2l0Q2hSUFZGbG04N0J2UXdsSTJ3a2NKMjlqS05zY2Vp?=
 =?utf-8?B?R0RvaU0yNXpSYmFvcHoyMzNBK1ZKRUhjOUthaVpBUjNYOHdRRzhrZ3FmNG5k?=
 =?utf-8?B?bkFTaUxJQTNwRkNkQlpUSHNLMVN6NWZjL2JSRnc2L2M2azJ6dnR3UUp4ZWFE?=
 =?utf-8?B?RGlJa0FOZGFpYm51bHcwdWdwckFMcEFaWWd2eFRPbHgya1JjcHVQVWVyeTVW?=
 =?utf-8?B?QldQeUhvQ2Z5M1graXdRaWttdW8vd3ROVzdta1U0NG1DVnF5RXMzOHV1WXpa?=
 =?utf-8?B?c0IxWkJmU08rTjFVZ3ZOcUV2T29kTGhxMXhZd0wrNE50akdnVEZIS1VEazll?=
 =?utf-8?B?dmRlb0NGdTNhTFJDSkttRGxOVkN5ZElWbjBLY0JubEpEcEo5MGlaZy9HUmRt?=
 =?utf-8?B?OGRZdWI4Vm04Q0prUUFCYXQ5ZzBCMDNTc0FHUzdmWTdHT2J1bS9sT2hUaEJB?=
 =?utf-8?B?NHFYVkgyY2V0Ny83YTRtMXFyVjRURi9pSTlmNjlwZ2ZvT29DcGxSNEVlZnpo?=
 =?utf-8?B?M2MzZU12RUU0YnNTbUVLUStmUzJMWmJRRzBJMk0zK0xRaTN3VlhyVVc4SjA3?=
 =?utf-8?B?eER4ejliVGhTREpMSjE5SzljQnRoOU51dTcydW9IQmZpUWl2U2h5WnFNWGYy?=
 =?utf-8?B?N2tUc0krbzNYWlQxajZhcnU5SFowbk5HSDJmckpHT2ZKbVZxOGtLM0FvWHVT?=
 =?utf-8?B?UlZqOE5RcUJQNE9BWG9QV29CMGQzc083N0tLcFVHK0wrc21TYlRMTUFTVkZ2?=
 =?utf-8?B?UXVSVjVjMUlucVN0dm1RZGFTZktCZElkUGkvWVBJMW9ReDFxcWc2L0U1bG1t?=
 =?utf-8?B?VW5QRlRjeVA0M0NHVGcvckl2N0Nxd0NOa3g5NndQMVg1bmh6Q1JMT2ZQTThN?=
 =?utf-8?B?aWxCdHp3MXowTHVVbHoxZkhmOFRTZXcvenFCYXpFUFFQU0htdmF5WTFzWnFq?=
 =?utf-8?B?NlRJOWVERUZOaFdkb1R1Mkd0VkdTQ0g5d0FwNFpDQlV6WllTWlpDR2hVM29J?=
 =?utf-8?B?QUp2dkNGMlVUdUtWQ2FqU1g4ZEVUb2I1c1pGUzZEU2lvUkp5ZVBiUnVMQlpx?=
 =?utf-8?B?MHAvS1BGb2IvOHphWi9oUGVQZUUzMWVGQmhqUHYrcGFiVTRIdXVtcjFvM2Ru?=
 =?utf-8?B?K3BuenhlT3dDY3hVZml6R2h4TytRQjQ2ZW1wSHZxR01DREVGRlJESnVrQjlx?=
 =?utf-8?B?TzRyTlFwL09wMVRPL3BDUll3eU1sYlVJRG5rM09YbC9NMU10dFcxSVA0S1J6?=
 =?utf-8?B?OEwwZVZQWVRrbVMzbmNyZ2FKbXBXQlFydGhEakNKM1BWR3NOOWh2SEdXaVBh?=
 =?utf-8?B?RVZmc002WUlBQ3hpR1pWazZSRG82RjQ0RW4wZkFVQmtXanNMWllCTGhBTXY4?=
 =?utf-8?B?Z1BBc3p4SXVLU2FvbWdWV2JRWGVtdFVaeFN3ajc5djA4Rnl0UlFYS216SlJr?=
 =?utf-8?B?ZTloTFlUeXA1aEVHTXkvT0FEZG1qeTJRTlNpeEZDczlMc096SUNrdWVQcmhz?=
 =?utf-8?B?ZW94cGZ3d2tHZ1prVjZMOEQzOCs0NnFsUkRiRGRRMVFLajRNeVJMZys1Rm84?=
 =?utf-8?B?Y2lQdml6VlFvY2FhaldhdlQ3TlY5T2RWRWJTUlppdE1DTVRqYUZoeS9SZGRC?=
 =?utf-8?B?bXZOempqejRORDBTcklIcUJXZU5wYjNsekFVNkFsQkVwVE9HSjZ5c0hZcHBW?=
 =?utf-8?B?cUhIMzN0eVAvOXphZE9FczdBRzZsbEw5TFp2ZjRYTVJSL0VhbWY3bklwTTdN?=
 =?utf-8?B?WEpOTU1uRk9GV0dvNWxKRTlseFZ1VVV0QXhvV2tuRG9sVEtLRmNHNkF0N2gz?=
 =?utf-8?B?MjlWeHFVeWx5ZlZjcmFKVVRnVDNRPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3434b01-1045-4ada-34d7-08d9a2f0b870
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 19:48:22.1600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKDQsfx2wjPJEN48Ol6WAIvlvQfSBh9p+PTsAV+3VMwN8DP41SAt6UdpA/WRXtWYjVPBarfhqwCuuQNA1/ze1Uk7lkAIcJr8FsRg93lKKHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3553
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

On 11/7/2021 8:47 AM, Jarkko Sakkinen wrote:
> On Sun, 2021-11-07 at 18:45 +0200, Jarkko Sakkinen wrote:
>> On Thu, 2021-11-04 at 11:28 -0700, Reinette Chatre wrote:
>>> The consequence of sgx_nr_free_pages not being protected is that
>>> its value may not accurately reflect the actual number of free
>>> pages on the system, impacting the availability of free pages in
>>> support of many flows. The problematic scenario is when the
>>> reclaimer never runs because it believes there to be sufficient
>>> free pages while any attempt to allocate a page fails because there
>>> are no free pages available. The worst scenario observed was a
>>> user space hang because of repeated page faults caused by
>>> no free pages ever made available.
>>
>> Can you go in detail with the "concrete scenario" in the commit
>> message? It does not have to describe all the possible scenarios
>> but at least one sequence of events.


I provided significant detail regarding the "concrete scenario" in a 
separate response to Greg:
https://lore.kernel.org/lkml/a636290d-db04-be16-1c86-a8dcc3719b39@intel.com/

That message details the test that was run (the test hangs before the 
fix and can complete after the fix), the traces captured at the time the 
test hung, analysis of the traces with root cause of why the system is 
hung, traces after fix applied demonstrating why user space is able to 
make progress and explaining why the test can complete.

Unfortunately the traces I provided wrapped and are not easy to read. 
The essential message from the two traces are that the first trace 
(before the fix) shows that the system is stuck (almost 100%) in the SGX 
page fault handler and not able to make any progress and user space 
hangs. The second trace (after the fix) shows that the system splits its 
time between the SGX page fault handler and the reclaimer enabling user 
space to make progress and the test can complete.

 > I.e. I don't have anything fundamentally against changing it to
 > atomic but the commit message is completely lacking the stimulus
 > of changing anything.

The problem needing to be fixed is that sgx_nr_free_pages is not updated 
safely on systems with more than one NUMA node.

Reinette
