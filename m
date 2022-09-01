Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3F55AA327
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 00:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbiIAWeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 18:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiIAWeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 18:34:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB735F83;
        Thu,  1 Sep 2022 15:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662071662; x=1693607662;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GTxNO5+2cFkg1rsjctWTb2l1oTsL4H0JRMZ8J6VSM0k=;
  b=Js71ka1qMUJb+ldmxck4laWq+ws9buO+Pna8qkoDLyW+cKbgf+/c/AWY
   hsa2ig6vZYeg33jok5BJMAu05R6s44OM5U2TUSnVLN725BzZM99cU5rba
   RmSz9nS4icsMuQaVmcyp0q+nSMLpDxoceZYF+QEN+u8p1dm/hdtoO+N6Q
   WbA1hDKULNLZVAAgumjLbLBpVK/ExYlVM50XnzF+Vv4GqbrJzxbBbCCmY
   3h/fwADsXlBx2IgaU/FqPSpu0mUmTaBj42mv/Nwb7Dq9dY1Qvf//S24xr
   060v5//8HRhV0mtUBNdyizTGjHRrX5HySvamBla8NeGgUjrRPa76bbb6P
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="293420796"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="293420796"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 15:34:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="642583139"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 01 Sep 2022 15:34:21 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 15:34:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 15:34:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 15:34:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZjt2rN9paKIqV99g/ObGPCfBj/yMp+eNg8AT/0iZt/IPUrLqKVL//MkKYWtdsgMRFKJW+d3Ijxp61RDFC2baRQsOpJjoq4Rxcj8L82qu03NKUw3GAjmenyRetWc3Saux+PseJminmir7mfdexKObgQrGHccJ6bjqDOSQVrnBDLxO3jpDwRM2aswVo57aDr2NUg4A4B4xrEeASUDgnoDljo/Wi6aROaMI7d/1PGgCwintc9HV4hx/Bwy8j3XNYB6tNIr72QNiU7cbvfbYD2B+3Tl2Hf54DMVLFkDZGvpLirZuBhEe0Mr8TTgd3JsfOgyegtigUcT3scNVUdAF4q6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onkhyCH7zaOSMfcZOSImPWlxfvJPyt/8e3JXTXSNHW0=;
 b=FbF8vV/fx+oKpmvXtDD737CGKlbQ6L+uu938KYFG0UX+TomeuNP43TP+3qtMwnKq3kPobzc6pjB0wxXbpGKw5PWOewfR4yB5aqgSexckBaKAVwePr2oUCSJRJ/dikEW3ZxpUfA2BKWvLFtKS998Wo30IFlVkQSHxovQAf0u4CLscpTuM0klvY/4eKAfIfKKXrMuzM5pSBdZUsqAoVGG5X2J6BNj/HFH/FKZ/5rfthubzpmtFYtGNz+l+n0qVoPpB1hZJHp7hrtbDQPqxYjyGkSGS5OX+Y9K5zv5Pep7C14KFa8DrDPQB9ziVWsKjLbHs4uuiFG1seHu9iqHu0u68Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by BN8PR11MB3572.namprd11.prod.outlook.com (2603:10b6:408:82::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 22:34:13 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743%11]) with mapi id 15.20.5566.023; Thu, 1 Sep 2022
 22:34:13 +0000
Message-ID: <84b8eb06-7b77-675f-5bc8-292fe27dd2f5@intel.com>
Date:   Thu, 1 Sep 2022 15:34:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.0
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <linux-sgx@vger.kernel.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <YxEp8Ji+ukLBoNE+@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YxEp8Ji+ukLBoNE+@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::16) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a19f658a-d5ae-4858-1fc3-08da8c6a189f
X-MS-TrafficTypeDiagnostic: BN8PR11MB3572:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m6xBxQdRKngbFG5BO4XSRc1OY9QitTV5yAZVpraRzCMAM3Eo9OG56JvOuh8CaYhSBoe3Sa0OYAd3/5XRJkoNKKH1nc4FALNCa3AfKIUItk4u6zEcfZntXAwAjtB8b9517kvULaP7eJEhaHz6DFkycJ1DymWMjOFKt+82AXNpiiSVIS5bk7jMm9OPQi9WTJf3zDU5VxXmsvugTBS5qOmOjP/MPnbISawgq1clFqagRCvrYPi2OdkG2AL/wGGu4a+qB12lRu1ZT+wWdStlJpX+T3HQ8icbXKBJyvoVBTSsUdTw1mO1KIueggGkjNssuUtQEg/vu7nxtxMbAvSiENSDP5DRGdCXR3P9g3pfI/JSvaDEUIPj5kmuisdnmAmtlJtqyq45ORXrykju+07sYtZckNOOWPrBMUXtbykejnHXWIGgqsDh+okXRR76Hza1QU7ewIh27snE+wSgQTlj1Tx1Sqfz3e6vWFevKfwyuyAgzkYJuSX3Z8TqXj8avu/hq4xcj197FcX7QddqowDo/qDzVcxV05Occk0DEhH9mXas0Kp7OHiAK2Zv6JhxYeGaK8PNEL3KYzbnOgsgra81sDbT+jl4WHn32uRo0aebraT/ttzNmAYRR5/GYsD80NHjLQOwc7WD2ekOEtc6msmYNq4P7ZQ453RERqH4LUn5aecA8dr2gK6fIavbQ2ZBUa5u2/lJf1EpIF4ySDDE7Vt0q187ZZpQobby1wE//ODXjHyqPLwCl5B2wXP08yTUbmIDhgnx+IWZiR43HW3biq2j9G2ksb4wOQuBxD/LQlsbYSnRLGw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(136003)(39860400002)(376002)(396003)(53546011)(6506007)(86362001)(26005)(36756003)(41300700001)(2616005)(31686004)(186003)(82960400001)(31696002)(6486002)(6512007)(83380400001)(478600001)(54906003)(316002)(7416002)(8676002)(6916009)(66476007)(66556008)(38100700002)(66946007)(8936002)(5660300002)(4326008)(44832011)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M01VazF0eFJNK0QzU3BDTUlQUm5sWmlWbzI4Y1dldkRlY29haXdoek5xWmxF?=
 =?utf-8?B?SzMvN1k2SjJHbi9jMnpWSzJIQzNvZkFGTVdRYTRIUlhORjVIUXBtRm11MENP?=
 =?utf-8?B?RjZZajUvQ2RyM0R6WnZZV053ZzhDWmprMFRPN2xxMmhodVZqYUNtd0UyY1J4?=
 =?utf-8?B?dzVXVllXcE9DaUFnT0NDR295SlZoM1U4dnBzazNGdUo1c1NrV3h2bHFGT2dj?=
 =?utf-8?B?bTdEUkNLTUpZbFBjZHNIK1UyOGo3Q1VjUEtGcXdERVNZdXdRdEhSYkJiejQ1?=
 =?utf-8?B?YXNROFlJd2dLaWF3V2pOODlxRlQ3bGRWamJXcHdWVU15NkROMGxzc3NWOFdY?=
 =?utf-8?B?WDhGQkdRN2ZlTStWZFhpRW1BZTVyejByNWZqSmxuVGZ1YWtaY2NjMjJvdmd0?=
 =?utf-8?B?M2VZYi9GVWE2WDZ4c21wREdNU0VNWFdnM2tIL0w4WEtPVE5taEo3dTRUc3FI?=
 =?utf-8?B?bCs2L3NRWExDNG5SSk9uT2ExOVh1dlRRQ09Hc1JjQng0NEFSNUd2dTdtczIv?=
 =?utf-8?B?Y3F0QVRGcUZpbGdGMkZjMFpVZ1hrSFFUMXozcnJKT3VlZHlwbXBNcE8xWjMy?=
 =?utf-8?B?cTNvTmJWVS9zRC9tMWR2RTVPdFdqdG14d1RoVFVuOHc5K0pVdVZ6Tk5JdlQr?=
 =?utf-8?B?RnZUWEo4Y05ZV0NmU1A0VDdkRCtSVDY4SkUwemVlMHJER1JuNDRxQTE2RnZV?=
 =?utf-8?B?NWF6YWxuTkw4Z2hDV2JlNk5vTnV3NkVuSE9pYUZLdjRuRUNDNTNpb2NoclZK?=
 =?utf-8?B?VEVuMGNmT0VFQ1A1UzRjM2E5WE8xT3Z3RStGTlVqc1JvK2pQQWFMMDY1RUN6?=
 =?utf-8?B?dHRVWkFMc1JXdEJ6bjlmRytpWXlsdXg5cDl1YlI2TWJLU2c0emNOQkJPRkRa?=
 =?utf-8?B?SXBUdUhQa3Y2RlMyYk5aeG53M1F0UlMyaU81OWZBeVk2clpFYlhZTzcwd3N2?=
 =?utf-8?B?NUtNa2ZjV2tsVkZsSnRhWnMzTFRoQWpNVkl5NVc3aVhESWRrc3p0dzJiNG80?=
 =?utf-8?B?RWJHZ3Z3Zk1wdUVZLzBSOE11U2FFWWErVTJZcEc3d2tFM0diUDJ6dmN6ZGRs?=
 =?utf-8?B?YmpoZ0FXaXJQTFBnWnQwZGZWbnp5VkZiRzZDUkh5OWgxemQ0bUwrZCs1UE1D?=
 =?utf-8?B?YnhmRVVKR083OTN5TjF5cXBrU2ZZaldDTkUzS0lZUitiVzVIOWh5RXVWWUMy?=
 =?utf-8?B?QllkWTgzaCtvNVM5WVBSSHFxS2IzS3hGUTFPbzZTeVJua2h3eCthNVZXWlFC?=
 =?utf-8?B?d1BSQ0tDRWM1dnpKNmQvVi8vOEdIRTlwaUVSNlB4Q0V6K3YwVU44OURHN0lS?=
 =?utf-8?B?RkZ4UXBCNTVrcDB3eUNtWjFCS2VKQ2czTC9HSWlTWElhMmtJZHg4eW42NWJx?=
 =?utf-8?B?aG1GVmVsSHFPMU42ejVmL29COTFFZW5xVjdmUVZsaytUMU5IRSt4NnYvalRQ?=
 =?utf-8?B?NGdrOUgrOVk5WFk0cjcxY0IyL0ttNHJVKzFUdnRINWVlcXZvS0hIUXlMVThK?=
 =?utf-8?B?bHUxdm5tK2ZaRm43cmI3cUR3QlhvdmZXQ3FvN09ON0ovaDEzMytacFM5Z1R1?=
 =?utf-8?B?MlhjVkhJcVBpdURrajJqc1dQS3NyUE95aUFlMnBMd2J6YzRtUm9Jck9mYktu?=
 =?utf-8?B?YjVPUWtVUXJGNmFzREltdkZnS05zamNiY2drVzZLZ0NCL1c4cUZINENvLzhl?=
 =?utf-8?B?TnVFd21hdG96WnMyOUtJS2pURjRXSEJCNXdHT1FuSGluZmIzcDZzeTBHcWsw?=
 =?utf-8?B?Z2RRSGhoYUQ2ZE9Pa1RPNElsZDFudS9YUWpTQkRmUlpwL2NsS0pXOU1HU0RJ?=
 =?utf-8?B?NXJ3TUVMd3JkYjNBaURxSWs4eVJaOUp4b2xCUGx4cmRwQ0pvWTR2VnZOcHlh?=
 =?utf-8?B?c1lUZHFSd0dYVXVKYkF6enhPamFQa0JvSUorakxyUlZrRkgreGpJVm1OZHV1?=
 =?utf-8?B?bFRvYXY5QjBSOHJTaUY2dnNrUUtDdjh4RjIzdDZheFJtYWdKRFRqWnJ2WE9v?=
 =?utf-8?B?NitQN1JlZ0F2UEQ1QUtKQ0ZEbFJmYTh6SWpMbzUwUEhrbmFQRGZ5V3ZUYnJO?=
 =?utf-8?B?QVRGQXlpVm9Mb1Y0Z0pSemlvUUx5OHZMRTFVckh6VmExb29JMjBjNmJuaURN?=
 =?utf-8?B?ekQ2N25CVUNhMDhzdGQ5elU4WVZjK3NkNDhmNmpSSXpMcEVpMEw0OFJSUmcx?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a19f658a-d5ae-4858-1fc3-08da8c6a189f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 22:34:13.5412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Flb1lGiTam958TqikzeJxXTJ6MiZbA7rxZtgOcDNSHf55EHU8zKsrUiXRDnvTjptR+Mo/yX2Q/Tqd8UiKd4ZaRCHgfYRR1/5q+iggJ1TOvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3572
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

On 9/1/2022 2:53 PM, Jarkko Sakkinen wrote:
> On Wed, Aug 31, 2022 at 01:39:53PM -0700, Reinette Chatre wrote:
>> On 8/31/2022 10:38 AM, Jarkko Sakkinen wrote:

>> I think I am missing something here. A lot of logic is added here but I
>> do not see why it is necessary.  ksgxd() knows via kthread_should_stop() if
>> the reclaimer was canceled. I am thus wondering, could the above not be
>> simplified to something similar to V1:
>>
>> @@ -388,6 +393,8 @@ void sgx_reclaim_direct(void)
>>  
>>  static int ksgxd(void *p)
>>  {
>> +	unsigned long left_dirty;
>> +
>>  	set_freezable();
>>  
>>  	/*
>> @@ -395,10 +402,10 @@ static int ksgxd(void *p)
>>  	 * required for SECS pages, whose child pages blocked EREMOVE.
>>  	 */
>>  	__sgx_sanitize_pages(&sgx_dirty_page_list);
> 
> IMHO, would make sense also to have here:
> 
>         if (!kthread_should_stop())
>                 return 0;
> 

Would this not prematurely stop the thread when it should not be?

>> -	__sgx_sanitize_pages(&sgx_dirty_page_list);
>>  
>> -	/* sanity check: */
>> -	WARN_ON(!list_empty(&sgx_dirty_page_list));
>> +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
>> +	if (left_dirty && !kthread_should_stop())
>> +		pr_err("%lu unsanitized pages\n", left_dirty);
> 
> That would be incorrect, if the function returned
> because of kthread stopped.


I should have highlighted this but in my example I changed
left_dirty to be "unsigned long" with the intention that the
"return -ECANCELED" is replaced with "return 0".

__sgx_sanitize_pages() returns 0 when it exits because of
kthread stopped.

To elaborate I was thinking about:

+static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
 {
+	unsigned long left_dirty = 0;
 	struct sgx_epc_page *page;
 	LIST_HEAD(dirty);
 	int ret;
 
-	/* dirty_page_list is thread-local, no need for a lock: */
 	while (!list_empty(dirty_page_list)) {
 		if (kthread_should_stop())
-			return;
+			return 0;
 
 		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
 
@@ -92,12 +95,14 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 		} else {
 			/* The page is not yet clean - move to the dirty list. */
 			list_move_tail(&page->list, &dirty);
+			left_dirty++;
 		}
 
 		cond_resched();
 	}
 
 	list_splice(&dirty, dirty_page_list);
+	return left_dirty;
 }


and then with what I had in previous email the checks should work:

@@ -388,6 +393,8 @@ void sgx_reclaim_direct(void)
 
 static int ksgxd(void *p)
 {
+	unsigned long left_dirty;
+
 	set_freezable();
 
 	/*
@@ -395,10 +402,10 @@ static int ksgxd(void *p)
 	 * required for SECS pages, whose child pages blocked EREMOVE.
 	 */
 	__sgx_sanitize_pages(&sgx_dirty_page_list);
-	__sgx_sanitize_pages(&sgx_dirty_page_list);
 
-	/* sanity check: */
-	WARN_ON(!list_empty(&sgx_dirty_page_list));
+	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
+	if (left_dirty && !kthread_should_stop())
+		pr_err("%lu unsanitized pages\n", left_dirty);
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())


> 
> If you do the check here you already have a window
> where kthread could have been stopped anyhow.
> 
> So even this would be less correct:
> 
>         if (kthreas_should_stop()) {
>                 return 0;
>         }  else if (left_dirty) {
>                 pr_err("%lu unsanitized pages\n", left_dirty);
>         }
> 
> So in the end you end as complicated and less correct
> fix. This all is explained in the commit message.
> 
> If you unconditionally print error, you don't have
> a meaning for the number of unsanitized pags.

Understood that the goal is to only print the
number of unsanitized pages if ksgxd has not been
stopped prematurely.

Reinette 

