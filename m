Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B570E445B5E
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 21:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhKDVAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 17:00:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:26330 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231722AbhKDVAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 17:00:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10158"; a="211844165"
X-IronPort-AV: E=Sophos;i="5.87,209,1631602800"; 
   d="scan'208";a="211844165"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 13:57:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,209,1631602800"; 
   d="scan'208";a="729403736"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 04 Nov 2021 13:57:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 4 Nov 2021 13:57:37 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 4 Nov 2021 13:57:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 4 Nov 2021 13:57:37 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 4 Nov 2021 13:57:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNQi2/h5H7xKiWFBYNXvr3ghpo/AGnofRIUZJXi6Or4o7QxKB+hFok+Jaz+q5hzam9nnfEQ4MaUPwbvczjIJpLnTdbRyozxyvgurb2slVAXYjiiqbjFYdEkKI5DJLVgvmx8s/CP/CZVO+WkOBb4fbraL3JCu84ZyCuutAdyYihEBEtNR4Enh2MbmxUPZgJcrMN++fvyTfDMxrQsMTjkb6g/7P2eMutJYipIym8xxZdKucvg9WINtcOONGwGdKSs+TZXycarbbxYfuajtWqDglw2zpy1T8o8ObnQLaycqdpx1FYdi+q3Cf5ceB5AX069v6eSo2gmeA3xv/oycqrr4dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSb7lfXJKyNQFvsx3MEHjWP90KNnlhZ+qmfIZbQMPNk=;
 b=H3lrNkDbm4Z1SG0IsLlAylQApbKw8Zmo+RQh70meKObnYzsCOCzj6wdEB9MpPkVJm3vMqSxwFSeuCtmisyUcgf+HwtLmeVRdQRyiymX2tRjmUzlgesQUg67r0aVQ5RAhmcOc4eY0z8AJa8Q7f/+bn9p+xFrYOsfWcpbYdVOUpEdn13BGJj6/dBm+s+y58DUFkyPtNYchQ/jHlkAjDe2RYGAuG2loBiQjSaussJLsiJS3J1CaedWyahKwMrRSSPvt2yZifrKtsjgo7JJqKReJUkMpKEGDx3TH+SqAqEPHRE5qW/SB5KYkUghjpqcyJdaa0gV2mjBOTGJpye1TT/OAAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSb7lfXJKyNQFvsx3MEHjWP90KNnlhZ+qmfIZbQMPNk=;
 b=Y24Gg7i20tLZ8o5UuS7NqUSCN4IXwA+v9lZgWNhIaMGGhXOsPoWmGzGdmEck01xm2YLg9Cdp3eF5PepOHqeDxVG8uLeLyPlbsAr/mDsVnb5Wt3AkKQ4PBh2jqIfbK/q+hZoi8YmUlDaZLbRGBVFzS6M0GP/Aq5jBVAr5lK12YLY=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
Received: from CH0PR11MB5740.namprd11.prod.outlook.com (2603:10b6:610:101::7)
 by CH0PR11MB5268.namprd11.prod.outlook.com (2603:10b6:610:e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 20:57:35 +0000
Received: from CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::6956:8f27:7ee8:90e]) by CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::6956:8f27:7ee8:90e%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 20:57:35 +0000
Message-ID: <a636290d-db04-be16-1c86-a8dcc3719b39@intel.com>
Date:   Thu, 4 Nov 2021 13:57:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.1
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <dave.hansen@linux.intel.com>, <jarkko@kernel.org>,
        <tglx@linutronix.de>, <bp@alien8.de>, <mingo@redhat.com>,
        <linux-sgx@vger.kernel.org>, <x86@kernel.org>, <seanjc@google.com>,
        <tony.luck@intel.com>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
 <YYQsc0kktaOdOXb0@kroah.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YYQsc0kktaOdOXb0@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0150.namprd04.prod.outlook.com
 (2603:10b6:303:84::35) To CH0PR11MB5740.namprd11.prod.outlook.com
 (2603:10b6:610:101::7)
MIME-Version: 1.0
Received: from [192.168.1.221] (71.238.111.198) by MW4PR04CA0150.namprd04.prod.outlook.com (2603:10b6:303:84::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 4 Nov 2021 20:57:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0f30178-f62d-42b2-011b-08d99fd5ba6e
X-MS-TrafficTypeDiagnostic: CH0PR11MB5268:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CH0PR11MB526881D5CE2FF811866C2713F88D9@CH0PR11MB5268.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wYaBDWJUAoXmQmpsv8DXrbFovH9vwhTkCeA/iTU12EUqCoLrn2sW21cTLh55FCeczb2TS/wa7xzdcqJlNWRkX4qRYOKVfBo3DIab/dYNU9hfBPyDMa+NsGBXg0iA5XYLqsZ6BOmnLg00ac+UU6m1W0L6x0N1mZ19rSGywKIObD6/NVMRFh1vd5pPVPzOQnxO9+s03pG4ltiR9YGLdVCeQk9GN0C6zU6OeB7D3TV6jJqIuEzOMXEI/sB3vHvQKQ4j4iceUZTLa0d+lCisa3a3VsrMFKCNKUbWXOf5xkbjywbyv1ZNg4r5aqTka/vL8ED3UKI4h2WkHgOgI1SOdgptdd+XWFV3TP1j2R1V/stNQLTlntFhhqUUJ+xAgFlgRHpoE/vOL6ArtMCMZzHUhcjuGkKKx9IOjFDmbUYpAowBO1CsV5YaXEPO9f21dfefgz4F72LbVPS+64kr4iEqGh+OGT1kU3fa6Jyltt9JDZ7fh8lZymE9PFw0CNruJuzGaH2v0cbzWSwRfDRyJQEBzJ9bRXqvQnQpAK6zQQ7ZKo8wHGChPdwA9kdtW1kmhPtb4kT7upcdD1lSOtkiMriM2Hu4DlRexD0LfFNC5CTjQ8OvcE+ms5idz/eN/6HP2nsCkeUE/h9puTK58jzg8HRFiUuybrwSAsQrGJDFKEVcP4OUmOF3SbigPjJwdtuCn4GZpIVzqmwiWnzY1EOLElfckM4dZqqJRMQSUwybjYRtp87g3MiIFyMbAuvuTpOfmXDtPrrWLJCpp289bb70qGz31iY+wBHHlWPwXV/U3Sqpp4UrMsnoZPf2J9HRuHB13x7s3M/P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5740.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(31686004)(36756003)(956004)(186003)(2906002)(66556008)(44832011)(38100700002)(66476007)(2616005)(66946007)(26005)(82960400001)(5660300002)(8936002)(53546011)(16576012)(508600001)(6916009)(86362001)(6486002)(966005)(316002)(30864003)(6666004)(8676002)(15650500001)(4326008)(7416002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2t1VVFXTCsyWERyS2w5dStjWWFOMVRqZVdsV3dWblAzdTViOXFvZERJV3FF?=
 =?utf-8?B?VXNpQ2Fkb3I5bVNHclpUekNrTHp4RmdqOHQzZnBJWk1nRWR3ZXpORzZJTGpP?=
 =?utf-8?B?ZEtKcFVXaXBmQ2JWS2VOK0tZa3VUdGlXUVFyT1BHa04xR3hXU3k0cHVtdVBQ?=
 =?utf-8?B?RTZ0Tzl1TmJkNWRyVmU4L2RXTzZXNHlNWVYwMmhiLzdFQy9rM3dZWWxRaWph?=
 =?utf-8?B?RHlhbmQ0MG5ZREpwdUhrU3NGNlQ3aE8yaEtGVzZDdERsVjVBQXU0ZWdzTWd4?=
 =?utf-8?B?V09yT2xTMGF4UGNXdDBzUTB5cEpJVmhJem4xVGFJOTZ6a1JZdDhWMFpSM0cz?=
 =?utf-8?B?TThsSitrQTdFWTErd1FDczIrRWcvVHNkcFUxQ3RJRFR3TThITmdKWkpucWhq?=
 =?utf-8?B?U0k2b3kwWWloQXNWS2t0TjNuTFVZemJneWpWaVp3Q3EwYjRtUXBoZWVleGYw?=
 =?utf-8?B?alJvZkFreGhGcGlYR2pEUWg0N1lzOHNrZzFjS3cwK0N3OEpwYVN6bXR5Yk93?=
 =?utf-8?B?TWtMQjNYSHVPMGpuU2NmTmxXZnI5U0oxZFZUdDk5RFZjRDNxbEVkenJLYldo?=
 =?utf-8?B?Q280SmhydUkxL3U4MHBPU3lGYVZYQ2tCWVJLc2svR0liU3hRQnZSZGswcUND?=
 =?utf-8?B?a2wvdTdrMWs1RXFRSUZ5TmtQWHM3akRCR0VyTm40ZW1pTGh0dVFwUTVDQ0V6?=
 =?utf-8?B?M1gyUHJoa0doeXRLS3Jzcm5hWDFzck1VWmt1VmVwdWFMOXN6MEtoUExVNCsv?=
 =?utf-8?B?TU5KbWdpcU10N1BPK0hKL0FxemZ1dmRieWR5YTluWExwcWZLWDBFaHZkbVI4?=
 =?utf-8?B?VTI4RGYvM3RFa1NGNCtzT2w5N2hLTGFGWVBySi9pd1RvZDRvZXZWQkhaS3NH?=
 =?utf-8?B?dklSY1hxeStQc0cxR1dkVDI0ZElWUmUrekp0RDlkR0wwTndxWmk3T3dwVis2?=
 =?utf-8?B?VFNrUU1zVUhsN01mMlRqbW5JWFdxMTQ1d3l5V3BZNXNsQkpocTlGNHZkRVNP?=
 =?utf-8?B?MmNTR1g4Wm5LR21Gd04vNG9jc2R3VzA1MkxndUNoRHVpMUIwUHBxVUcrZnBz?=
 =?utf-8?B?UVp0T2tIRUUrS01nTnNYNWNuS2dwRW5Sa3Izazl2Tk5icUEwTUJzazVZY3FL?=
 =?utf-8?B?VlUxdG14Q0h4WGhyM1dpYVRiU0Y0aVd1M3F0WXcyYmpFY1pJeVpoeExUTDlY?=
 =?utf-8?B?eVV0OXNWeVJPTjVGQ3pGZFZGUVdCb000N0NjYUFjWW84UW9WVUZiUmxHUEFC?=
 =?utf-8?B?TElnMnpHSy9xNCtGSFoxVENiS0h1TjBGRENlNEhiMG53ZFFEWmVoVklNOGVr?=
 =?utf-8?B?T2pyNnZ0QVFJR1NGemdQT2pOc0hkd0VZNW1TdWlnUnNNR3djNERsOWF4SFk5?=
 =?utf-8?B?M0RTYkxtYnRCaThPOXFOdHh6RUJhZDBscDhvdW1LR3g3dWR6SUowK3BIbVVI?=
 =?utf-8?B?WDBhWDhzRDQreUh2dGxDTmlTaSthTVdFNkJCaHFDL3ZUK3RHVG1aUGMwZnFN?=
 =?utf-8?B?UDRSR0pDOFRXUDI1WDFDWGpWOGNmajdrOTZBSTVPNWgxN3FncEJvdnM3WTB6?=
 =?utf-8?B?TU1zK0ZaS1pDMlRGbVVuR3p6MGVMNWhkd0hoUWZzVjVtSGtoeDEvU2J1QW9t?=
 =?utf-8?B?MjV3VHNJRWJDdWU1WVNoaXJsNW1kaFBsVG40UFcwaVpxVDhtYkRQVnBOTlR5?=
 =?utf-8?B?VWlFM2N4M2cvdit0b2pZOTg4NnVzSHhOeE82ZEFrdVRWUFBoRzJnLytHTEE5?=
 =?utf-8?B?ZFh6SWY0U0c2aHI2Zlo5WTIrMVV3TjZLODRydUx2VGU5bjBhcmY5UGEra25K?=
 =?utf-8?B?ZFV4ZTcwUzE1VG8xWmc0ZE1CTFNSNDE2d3EzeUJ6S3hZa3NvMVJHWFpVY1Zr?=
 =?utf-8?B?VFJvRy9iZkVXaUtORDNubzJTZmExVE15YUw1QWpIOXJOYWlPRDE3UitKc2hI?=
 =?utf-8?B?b2V5U2RZdFRmSXRDaVhMbzB3MElRdExENy9xSUpucTY4SEExNklYRlhaTm04?=
 =?utf-8?B?V3QwQjNIODVOK2dnWWYvRHp0QWRTbS9QM25YWHJycnQ0bXJqakIrN3dLOEIy?=
 =?utf-8?B?RktGYzZpK2w4bjA3a2I3S0pXdjNwMGMvR0dONzZKdFMwRjdnWS9WZmNYYmhi?=
 =?utf-8?B?aDlTYUNxRXp1MXlBWktGL1M2R3I5bVlNVGU2REEyU1RsVDdrOHhIYlV5TUNV?=
 =?utf-8?B?dTNDREdrYWJiM1U5dTg1TlF6U09nTVc3bHVhdU1FRlJiZFcyQksrY2REY205?=
 =?utf-8?B?TCtEVFNPZ3lxbXZRQms2SDdFeVpBPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f30178-f62d-42b2-011b-08d99fd5ba6e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5740.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 20:57:35.6189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61M6oitFgLteOXYorPO5kWHlEq/VPrAd9bi61soYel2s7GLcqxsRgyF24B0XzkdlxQIrcOzgyGvf2YLroQAZ36gM8Ym8iCp1wFcSePO2I88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5268
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 11/4/2021 11:54 AM, Greg KH wrote:
> On Thu, Nov 04, 2021 at 11:28:54AM -0700, Reinette Chatre wrote:
>> The SGX driver maintains a single global free page counter,
>> sgx_nr_free_pages, that reflects the number of free pages available
>> across all NUMA nodes. Correspondingly, a list of free pages is
>> associated with each NUMA node and sgx_nr_free_pages is updated
>> every time a page is added or removed from any of the free page
>> lists. The main usage of sgx_nr_free_pages is by the reclaimer
>> that will run when the total free pages go below a watermark to
>> ensure that there are always some free pages available to, for
>> example, support efficient page faults.
>>
>> With sgx_nr_free_pages accessed and modified from a few places
>> it is essential to ensure that these accesses are done safely but
>> this is not the case. sgx_nr_free_pages is sometimes accessed
>> without any protection and when it is protected it is done
>> inconsistently with any one of the spin locks associated with the
>> individual NUMA nodes.
>>
>> The consequence of sgx_nr_free_pages not being protected is that
>> its value may not accurately reflect the actual number of free
>> pages on the system, impacting the availability of free pages in
>> support of many flows. The problematic scenario is when the
>> reclaimer never runs because it believes there to be sufficient
>> free pages while any attempt to allocate a page fails because there
>> are no free pages available. The worst scenario observed was a
>> user space hang because of repeated page faults caused by
>> no free pages ever made available.
>>
>> Change the global free page counter to an atomic type that
>> ensures simultaneous updates are done safely. While doing so, move
>> the updating of the variable outside of the spin lock critical
>> section to which it does not belong.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
>> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>   arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
>> index 63d3de02bbcc..8558d7d5f3e7 100644
>> --- a/arch/x86/kernel/cpu/sgx/main.c
>> +++ b/arch/x86/kernel/cpu/sgx/main.c
>> @@ -28,8 +28,7 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
>>   static LIST_HEAD(sgx_active_page_list);
>>   static DEFINE_SPINLOCK(sgx_reclaimer_lock);
>>   
>> -/* The free page list lock protected variables prepend the lock. */
>> -static unsigned long sgx_nr_free_pages;
>> +atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
>>   
>>   /* Nodes with one or more EPC sections. */
>>   static nodemask_t sgx_numa_mask;
>> @@ -403,14 +402,15 @@ static void sgx_reclaim_pages(void)
>>   
>>   		spin_lock(&node->lock);
>>   		list_add_tail(&epc_page->list, &node->free_page_list);
>> -		sgx_nr_free_pages++;
>>   		spin_unlock(&node->lock);
>> +		atomic_long_inc(&sgx_nr_free_pages);
>>   	}
>>   }
>>   
>>   static bool sgx_should_reclaim(unsigned long watermark)
>>   {
>> -	return sgx_nr_free_pages < watermark && !list_empty(&sgx_active_page_list);
>> +	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
>> +	       !list_empty(&sgx_active_page_list);
> 

Thank you very much for taking a look.

> What prevents the value from changing right after you test this?

You are correct. It is indeed possible for the value to change after 
this test. This test decides when to reclaim more pages so an absolute 
accurate value is not required but knowing that the amount of free pages 
are running low is.

>  Why is
> an atomic value somehow solving the problem?

During stress testing it was found that page allocation during hot path 
(for example page fault) is failing because there were no free pages 
available in any of the free page lists while the global counter 
contained a value that does not reflect the actual free pages and was 
higher than the watermark and thus the reclaimer is never run.

Changing it to atomic fixed this issue. I also reverted to how this 
counter was managed before with a spin lock protected free counter per 
free list and that also fixes the issue.

> 
> The value changes were happening safely, it was just the reading of the
> value that was not.  You have not changed the fact that the value can
> change right after reading given that there was not going to be a
> problem with reading a stale value before.

I am testing on a two socket system and I am seeing that the value of 
sgx_nr_free_pages does not accurately reflect the actual free pages.

It does not look to me like the value is updated safely as it is updated 
with inconsistent protection on a system like this. There is a spin lock 
associated with each NUMA node and which lock is used to update the 
variable depends on which NUMA node memory is being modified - it is not 
always protected with the same lock:

spin_lock(&node->lock);
sgx_nr_free_pages++;
spin_unlock(&node->lock);


> In other words, what did you really fix here?  And how did you test it
> to verify it did fix things?

To test this I created a stress test that builds on top of the new 
"oversubscription" test case that we are trying to add to the SGX 
kselftests:
https://lore.kernel.org/lkml/7715db4882ab9fd52d21de6f62bb3b7e94dc4885.1635447301.git.reinette.chatre@intel.com/

In the changed test an enclave is created with as much heap as SGX 
memory. After that all the pages are accessed, their type is changed, 
then the enclave is entered to run EACCEPT on each page, after that the 
pages are removed (EREMOVE).

This test places significant stress on the SGX memory allocation and 
reclaim subsystems. The troublesome part of the test is when the enclave 
is entered so that EACCEPT can be run on each page. During this time, 
because of the oversubscription and previous accesses, there are many 
page faults. During this time a new page needs to be allocated in the 
SGX memory into which the page being faulted needs to be decrypted and 
loaded back into SGX memory. At this point the test hangs.

Below I show the following:
* perf top showing that the test hangs because user space is stuck just 
encountering page faults
* below that I show the code traces explaining why the repeated page 
faults occur (because reclaimer never runs)
* below that shows the perf top traces after this patch is applied 
showing that the reclaimer now gets a chance to run and the test can 
complete


Here is the perf top trace before this patch is applied showing how user 
space is stuck hitting page faults over and over:
    PerfTop:    4569 irqs/sec  kernel:25.0%  exact: 100.0% lost: 0/0 
drop: 0/0 [4000Hz cycles],  (all, 224 CPUs)
------------------------------------------------------------------------------------------------------------------------------------------------------------

     94.34%    68.51%  [vdso]         [.] __vdso_sgx_enter_enclave
             |
             |--68.51%--0x5541f689495641d7
             |          __libc_start_main
             |          main
             |          test_harness_run
             |          __run_test
             | 
wrapper_enclave_unclobbered_vdso_oversubscribed_remove
             |          enclave_unclobbered_vdso_oversubscribed_remove
             |          __vdso_sgx_enter_enclave
             |          |
             |           --68.30%--asm_exc_page_fault
             |
              --7.84%--__vdso_sgx_enter_enclave
                        |
                         --2.58%--asm_exc_page_fault
                                   |
                                    --2.72%--exc_page_fault
                                              |
                                               --3.67%--do_user_addr_fault
                                                         |
 
--6.96%--handle_mm_fault
                                                                    |
 
|--4.37%--__handle_mm_fault
                                                                    | 
        |
                                                                    | 
         --1.65%--__do_fault
                                                                    | 
                   |
                                                                    | 
                    --2.66%--sgx_vma_fault
                                                                    | 
                              |
                                                                    | 
                              |--1.93%--xa_load
                                                                    | 
                              |          |
                                                                    | 
                              |           --1.85%--xas_load
                                                                    | 
                              |
                                                                    | 
                               --1.21%--sgx_encl_load_page
                                                                    |
 
--1.35%--__count_memcg_events

     85.55%     0.17%  [kernel]       [k] asm_exc_page_fault
             |
              --70.81%--asm_exc_page_fault
                        |
                         --2.73%--exc_page_fault
                                   |
                                    --3.71%--do_user_addr_fault
                                              |
                                               --7.00%--handle_mm_fault
                                                         |
 
|--4.42%--__handle_mm_fault
                                                         |          |
                                                         | 
--1.65%--__do_fault
                                                         | 
        |
                                                         | 
         --2.66%--sgx_vma_fault
                                                         | 
                   |
                                                         | 
                   |--1.93%--xa_load
                                                         | 
                   |          |
                                                         | 
                   |           --1.85%--xas_load
                                                         | 
                   |
                                                         | 
                    --1.21%--sgx_encl_load_page
                                                         |
 
--1.35%--__count_memcg_events

     16.83%     0.18%  [kernel]       [k] exc_page_fault
             |
              --2.57%--exc_page_fault
                        |
                         --3.69%--do_user_addr_fault
                                   |
                                    --7.00%--handle_mm_fault
                                              |
                                              |--4.42%--__handle_mm_fault
                                              |          |
                                              | 
--1.65%--__do_fault
                                              |                     |
                                              | 
--2.66%--sgx_vma_fault
                                              | 
        |
                                              | 
        |--1.93%--xa_load
                                              | 
        |          |
                                              | 
        |           --1.85%--xas_load
                                              | 
        |
                                              | 
         --1.21%--sgx_encl_load_page
                                              |
                                               --1.35%--__count_memcg_events

exiting.


What happens above is the following flow is encountered:
sgx_vma_fault()
   sgx_encl_load_page()
     sgx_encl_eldu() //page needs to be loaded from swap
       sgx_alloc_epc_page(..., false) // new EPC page is needed

Taking a closer look at sgx_alloc_epc_page:

struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
{
	struct sgx_epc_page *page;

	for ( ; ; ) {
		page = __sgx_alloc_epc_page(); <--- page == NULL because of no free pages
		if (!IS_ERR(page)) {
			page->owner = owner;
			break;
		}

		if (list_empty(&sgx_active_page_list)) <--- there are plenty of pages 
that can be reclaimed
			return ERR_PTR(-ENOMEM);

		if (!reclaim) { <--- reclaim is false so EBUSY will be returned but an 
attempt is made to wake the reclaimer below
			page = ERR_PTR(-EBUSY);
			break;
		}

		if (signal_pending(current)) {
			page = ERR_PTR(-ERESTARTSYS);
			break;
		}

		sgx_reclaim_pages();
		cond_resched();
	}

	if (sgx_should_reclaim(SGX_NR_LOW_PAGES)) <-- expected to wake up 
reclaimer but this is not happening
		wake_up(&ksgxd_waitq);

	return page;
}

Because the above returns EBUSY sgx_vma_fault() will return 
VM_FAULT_NOPAGE and user space will keep attempting to access the same 
page and trigger the same fault again because there still are no free pages.


static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
{

         ...
         entry = sgx_encl_load_page(encl, addr);
         if (IS_ERR(entry)) {
                 mutex_unlock(&encl->lock);
                 if (PTR_ERR(entry) == -EBUSY)
                         return VM_FAULT_NOPAGE;
         }
         ...
}


I added some tracing and it shows that the value of sgx_nr_free_pages 
was higher than the watermark and thus the reclaimer does not free up 
pages, yet the allocation of memory keeps failing because there are no 
more free pages.

With this patch the test is able to complete and the tracing shows that 
the reclaimer is getting a chance to run. Previously the system was 
spending almost all its time in page faults but now the time is split 
between the page faults and the reclaimer.


    PerfTop:    7432 irqs/sec  kernel:81.5%  exact: 100.0% lost: 0/0 
drop: 0/0 [4000Hz cycles],  (all, 224 CPUs)
------------------------------------------------------------------------------------------------------------------------------------------------------------

     49.62%     0.18%  test_sgx       [.] 
enclave_unclobbered_vdso_oversubscribed_remove
             |
              --14.59%--enclave_unclobbered_vdso_oversubscribed_remove
                        |
                         --20.19%--__vdso_sgx_enter_enclave
                                   |
                                    --11.23%--asm_exc_page_fault
                                              |
                                               --4.82%--exc_page_fault
                                                         |
 
--5.04%--do_user_addr_fault
                                                                    |
 
--5.33%--handle_mm_fault
 
        |
 
         --4.98%--__handle_mm_fault
 
                   |
 
                    --4.59%--__do_fault
 
                              |
 
                               --5.71%--sgx_vma_fault
 
                                         |
 
                                         |--16.71%--sgx_encl_load_page
 
                                         |          |
 
                                         |           --17.05%--sgx_encl_eldu
 
                                         |
 
                                          --5.31%--__mutex_lock.isra.9
 
                                                    |
 
 
--4.92%--mutex_spin_on_owner

     49.46%    14.41%  [vdso]         [.] __vdso_sgx_enter_enclave
             |
             |--5.81%--__vdso_sgx_enter_enclave
             |          |
             |           --4.83%--asm_exc_page_fault
             |                     |
             |                      --4.82%--exc_page_fault
             |                                |
             |                                 --5.04%--do_user_addr_fault
             |                                           |
             | 
--5.33%--handle_mm_fault
             |                                                      |
             | 
--4.98%--__handle_mm_fault
             | 
        |
             | 
         --4.59%--__do_fault
             | 
                   |
             | 
                    --5.71%--sgx_vma_fault
             | 
                              |
             | 
                              |--16.71%--sgx_encl_load_page
             | 
                              |          |
             | 
                              |           --17.05%--sgx_encl_eldu
             | 
                              |
             | 
                               --5.31%--__mutex_lock.isra.9
             | 
                                         |
             | 
                                          --4.92%--mutex_spin_on_owner
             |
              --2.10%--0x5541f689495641d7
                        __libc_start_main
                        main
                        test_harness_run
                        __run_test
 
wrapper_enclave_unclobbered_vdso_oversubscribed_remove
                        |
 
--8.90%--enclave_unclobbered_vdso_oversubscribed_remove
                                   |
                                    --14.39%--__vdso_sgx_enter_enclave
                                              |
                                               --6.39%--asm_exc_page_fault

     45.60%     0.05%  [kernel]       [k] ksgxd
             |
              --10.27%--ksgxd
                        |
                         --13.34%--sgx_reclaim_pages
                                   |
                                   |--19.74%--sgx_encl_ewb
                                   |          |
                                   |           --18.49%--__sgx_encl_ewb
                                   |
                                    --15.73%--__mutex_lock.isra.9
                                              |
                                               --14.77%--mutex_spin_on_owner

exiting.


Reinette
