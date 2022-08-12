Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909A85912F8
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 17:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiHLPbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 11:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbiHLPbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 11:31:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F85945F4D
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 08:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660318303; x=1691854303;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2l+JoabkkS8HPtI5O5Ok9hfigTaqZ8F3L93Fyn2Pl3c=;
  b=SoNv9QM+pCv4y4Pbka9/5EVewp8uCBRpFPhmU5raGkAA1qcwXKLD/Pca
   3WAATI36JtCaim7HGSw+j8vir+g7d+Hw350T2OIFF65g0pSkQ1eJ+nboh
   noNResuC2B+9J1bKOcPLRJTqDk0/HZ0GZsHDndMQUzVwJr6v9kwYfpjKs
   nLlnV167cCZRMEkZrR8YOjvhUlYE0xr7Fb+yOR4/hgEVQLVe7ML6kh8jE
   ypPZ3AAlDgLfcwR2l7CPfU+pR0qB1O+m9cSNQ0fSTYQKgIBPVZaiNgGPt
   5YI5OYraUs3A+yGZ0a5JlBtKkPMkiXoJ7QimImC+xkRu3fqKnu8RkzOqS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="289186101"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="289186101"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 08:31:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="748227411"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 12 Aug 2022 08:31:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 12 Aug 2022 08:31:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 12 Aug 2022 08:31:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 12 Aug 2022 08:31:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyNP+2aS1QJYeZqljhUoFhslG2ABxDCsIJ707cXB4HY4u0Aawqf099uNElWpscNTLccKAqcXDLmbQv0wWqQwe1O8u/7oDh71ib3w3mv3kYSXSkLzFRSSM9xfE4GAG7OHNxdfnulr+jNG5qPqRgtdiWi/d7Le/JcxBOupqjOlhQqyJucBpjnL+R/GL9gvX0Pa6nPW226HbKcVLPb/cF7kxVkskVGcFpU6+/ZtSei5twLa7KS5nD7DfF7kLD9cwchRhUOMBLuXsyZzI4x+C0tehfPFc5+NX6kdYm4x47ph9WJRHBrl+3zyHNXd4Ly2B9eUxnbVu7i2WVCfLijQhz3C1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QF9aDABlYBVoOk0KFx0K0AP55eNSAvCzCV62EFuFE7E=;
 b=g4SOy0Ja89afiefOtSTDYz199bxKG//FNud7bylQR7c0KaRPDH9DBY0lnnM7DSDhT7/3uqWQWLmwZ/YeyVWLx43EA8M3ohjLIZ/NikZ/cL3x2Y9SrVSzsMoNM2kcYua+RbmAJ8KfRmYxHTc9LuVMx1sN0+R+rSgNPlI/zk+LzjgniEmoCxEdfCH1zKZLrte5OLAw0JA5gXvn/j4whmIReCtdxoizQjJEk+tiTST7Z4TYm+rOn3dneBLBVviLu72kC3GUSbdOQAvj7wGo+3gZVBahOMpXOQSVrmfG7Fye/oqfRTrU2ZMg4EB6CyG+8RRpZ2Dm11s5aPei9+1DGYphtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5488.namprd11.prod.outlook.com (2603:10b6:5:39d::5) by
 BY5PR11MB4021.namprd11.prod.outlook.com (2603:10b6:a03:191::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Fri, 12 Aug
 2022 15:31:37 +0000
Received: from DM4PR11MB5488.namprd11.prod.outlook.com
 ([fe80::1977:59e7:5a28:24e1]) by DM4PR11MB5488.namprd11.prod.outlook.com
 ([fe80::1977:59e7:5a28:24e1%7]) with mapi id 15.20.5525.011; Fri, 12 Aug 2022
 15:31:37 +0000
Message-ID: <c36cf67c-c32f-4883-b56e-9e5322720431@intel.com>
Date:   Fri, 12 Aug 2022 08:31:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915/guc: clear stalled request after a
 reset
Content-Language: en-US
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        Matthew Brost <matthew.brost@intel.com>
References: <20220811210812.3239621-1-daniele.ceraolospurio@intel.com>
 <bd3abbb2-f3e8-b143-a19d-2cbf9463f7b3@linux.intel.com>
From:   "Ceraolo Spurio, Daniele" <daniele.ceraolospurio@intel.com>
In-Reply-To: <bd3abbb2-f3e8-b143-a19d-2cbf9463f7b3@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0057.namprd08.prod.outlook.com
 (2603:10b6:a03:117::34) To DM4PR11MB5488.namprd11.prod.outlook.com
 (2603:10b6:5:39d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8590ee48-f006-4908-3b20-08da7c77becc
X-MS-TrafficTypeDiagnostic: BY5PR11MB4021:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQpNR0Tumtngfs6hx3hgeoIVIpNyhcAGp1p/dW0hsmz/zuOOCaDf6cRGH/G7lmUhYeNNywda56/b1aKbrMcnO1xcgXY5QNQWnqWk/akStCDpM2HW2xGsa8UajWZtd2jxJgIh+VwzuqouJD5C8MoM2STh1Hz6pP7fUUTS4XimVY2M+gblfMZv61r9NF/1jlu6dFhNvjakGYA9kFEW/Obl6EoO4muiE6VmEOD51eAdvnG4gxR+lAvGpJFoDSoeNCYwn3G9zvqC1YM1XFNQQdEhAqZbq9senxY8mDvknDrfjD1Hw73I2CpBt+a/U7DP0vB8B4H0Jueh4fAnlWudyEZc6iuBztrUMabxOed3SqhKWDwL5Y012W2eDzGWQYEBrWQw+alJeVKiqz7a7NuVXJHyfLtzC65UtFiyRoCE0RiFDvQ0ddxs2G6cn1Q5H+D0iNYpJ3OZxvZjq+AFfajH9mIWtPpeEATbeSHsy3FJUC3ppa+J8jDMZnW/iEBfDW6bz2lu8DuAq+ZHPyyKmHRt4PHMMs6obHpUR1SLQ2XvVrGBJe2SJmGUs/ZHiOy3M/RZDpQ+UxdiK4wktBDRF+q3pDxcmvXx1tuJkF/q6GOL/BdwAZCzJs6NbC1vSV3vSawWlm7wEvwoo8uFv1zRZzowt2QIdC2u+jbvC1BxuCvfYPgpZBebTVyCDXr4AL/GziqHJ13e11PLKwP/lSahOrdvmzrRa2kz7llvGcETSsBF/urLkRprbTj31J1wObCmjdOB3V5KzCmMV7NqkGjPq5nepv3KMmTVkPvXS2BFG8GHyG4hpC2HuEgGjlbL4yBk9z+XQX8iduLziI+YbLsq3uVtXsi5Qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(346002)(39860400002)(136003)(6666004)(41300700001)(53546011)(478600001)(6512007)(186003)(83380400001)(6506007)(26005)(2906002)(6486002)(5660300002)(316002)(2616005)(4326008)(8936002)(38100700002)(36756003)(8676002)(66476007)(66556008)(66946007)(31686004)(86362001)(82960400001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWNDdGhHcHpDRWhWQ0QrV1FhMlNaV3BwUTRPUzJGZ3pzN25iNkRLQ29ZL2Jy?=
 =?utf-8?B?aVBLbk5kd1BUcmhMZXpCODZzNXRvemVuU0FQYU9yTC96eGlEd1Uxc2c0R3NO?=
 =?utf-8?B?YzZGWE16U2x5aFhQcWlvaFR6Y0U0cEF5c0dRa1VTdlhBVkVXcU84S2M3V3h4?=
 =?utf-8?B?N1hrUWZGY3RWa2dWL0FXU1ZuQk1xTCtqcm1DQmhqUEMrenIxL25JNnJhRWpy?=
 =?utf-8?B?SERxdFdWckRvdHBYL3NSZXpIeU00TUxLdnhSbEVXbWwrQzIvQ2RnUEJ5ay9r?=
 =?utf-8?B?c1lJRlpaMiswVnAxMjQ3MHZ3ajRJdDd5N1lKTWZaRjVHY1N0MExEYlM1V3FY?=
 =?utf-8?B?OWZRUUR6NENxQXdJUHVnampieG0vY2xmd0hBWTRvTGxWQkVWWjh3ZEc0QlRK?=
 =?utf-8?B?V01XbHpQbVpIWkRkMERsYnlRazVzeXhNdFM4MnhYa2xPSm1ydUlpRndiRk5O?=
 =?utf-8?B?cmlIRlU2RnEreVJJRGhSZmRvdXpMYTd0QlBtaUdqRHY4bmRLbUlLNFJFM1l2?=
 =?utf-8?B?eWpSaHpQZ3RuSnVsd1JtQlo5T0UzOER2VVY1d3hoYWRtb2Rad2JoMkFZNHZD?=
 =?utf-8?B?VTRuUWdyUE1la0EwQTExRXRYc2dheDAyc1R6YVhzdTFnWUtRbXQxTHUzZVhN?=
 =?utf-8?B?VFhNaXpFdlZHS05DbjlzdEtzYkxJcVUvcWFGQUk3ZnpqTFpXNkp0anV0d3Ro?=
 =?utf-8?B?aDZTd2pzeDJucGxiM1B6L1JBTk4wVDVOSUhtbWMrRWdiSWNPeW1naFR1SUxt?=
 =?utf-8?B?b0k0VE42UXUvdUdhNzNIWFZob0hqekFTbzJWVXVwTlUvMGRDWVlRQ0xzdHU5?=
 =?utf-8?B?bmdBZ1d3UDVqcklPTlFpTGE2M0h4YVJXZFZYdzlmTCtCT1EzQ1dVWFNHdWFo?=
 =?utf-8?B?U1pNTWFKRitQR0M1OXcrM1FUN0lpZ2hXc1F3cFF0QzB5TU1CQVU2enFqRE5y?=
 =?utf-8?B?OUMyODJLUVVld0JraXliQXpZT2IxV3hKWXJJYnhnQ0lQUVBHNG1xNHlINzlt?=
 =?utf-8?B?WXFuWUZ5MHYvMVByZG9zd2ErOHdFUHF5cUpRUEVIc3pUN0N0cjZFRkJKSGNO?=
 =?utf-8?B?RHlIK2hBL1R6cFBVVk5mMkY3Y0xPQ3dlak9LRUR5aDdTQVdBN1VKRTlJTUlu?=
 =?utf-8?B?Ti9mVG9ZUG12V2hVT0hDc2VlTFYreUQ2MHFWQWx3d05hR2pTZmJFNXZNYjBi?=
 =?utf-8?B?Yjc0aW85SkJXbDkrSWdsVE94SzhQazBpTVhjUU1rL2srS0NGa3RIZW05SVJP?=
 =?utf-8?B?anp2dUFoaTIyNG15NTVmN2UwbUVOODhMQndLYVpMeGQ5cXVwekRYcllBc3Nj?=
 =?utf-8?B?YXQxOVRzQVZzSzg4TmlxWjhmUUxvZElFYjZEeHVBR0U1V2hBWGw2UUJRUUtn?=
 =?utf-8?B?VGtidEx2dC9TdTFSYXhveFM4SjlTWDRTdWh5Yk9xaUpaM0pTZWVjejViWDBB?=
 =?utf-8?B?dmh2cXdLSmZ4V1A4T25wQ2p2ZkpQSWovMm1CSC9JcllVUDJ3WWhhUEhwQVRS?=
 =?utf-8?B?VXdRekRBTXhaUXoxTEhETkhYMkVRelN5aktqc0tWZXMveFloN1R5eVpZMGZ6?=
 =?utf-8?B?MFZNOXIxL3paSnZvU3hLUnpwWnhiYlNyYkxiNURjUWVPZWFNblFWUjU2VFJv?=
 =?utf-8?B?R0RXNlRlRUZ0SmJmSk95allqcStPeDhtUmEvaWdyRmRNYnVGRFF0TnJrV2JN?=
 =?utf-8?B?YWRmVitCcEQvNHdIMG01QlF4dlpFTzVkRUhrNTB6c2ZaRWhtazRSVHlsemJv?=
 =?utf-8?B?V3Q5Q0RNczJ6bzViL3pzSnRQb1VCN2pjTjlhTUVmSDFKYnFESmMwVFZuQjFL?=
 =?utf-8?B?R1F3R2doUlhqQS8vSkdTazMyUDgyWHhMaFBtbTh0V1BrbFdwTlNDMDUvaU0z?=
 =?utf-8?B?QlYvcjBnd1lXcGtXWU9zbFJWVUgrTUNqd3VSM0lmTnFReXQwWlduQkRISHE3?=
 =?utf-8?B?UksxNzlzTHJVZnRHN1ZRQ1VjaFFSZWExc0xlQ1VSdERNTjE0L0c3cFVsRmNt?=
 =?utf-8?B?MFg2TG02MlhkR2c0K1VqRkhtcHRVbFk1UFFwMWdYUkJZQmU5MnZtWnJOYk1R?=
 =?utf-8?B?K0ZvY3hRbUF3VHlHQ0pab1NuS0NjUkJVdVNYVXV6Zm9WKytIbitkK3MzNVB2?=
 =?utf-8?B?dkN5OEQ2bHRJR2VwdHpkMzUxVXo0SFhSenlENTJIbUdYU21mcHBqcGZRNzJr?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8590ee48-f006-4908-3b20-08da7c77becc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 15:31:37.2385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ys3Vf0hySMep93Q5eCCWQFMphM0s+yki5mHMwxIZBbTkJfZ6sTZa7YTP6GVAVJXcwgPFq9PIxGPDdmlwx6eJJeX0Ph9b2uH44jXhQ5b4/sk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4021
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/12/2022 12:29 AM, Tvrtko Ursulin wrote:
>
> On 11/08/2022 22:08, Daniele Ceraolo Spurio wrote:
>> If the GuC CTs are full and we need to stall the request submission
>> while waiting for space, we save the stalled request and where the stall
>> occurred; when the CTs have space again we pick up the request 
>> submission
>> from where we left off.
>
> How serious is it? Statement always was CT buffers can never get full 
> outside the pathological IGT test cases. So I am wondering if this is 
> in the category of fix for correctness or actually the CT buffers can 
> get full in normal use so it is imperative to fix.

The CT buffers being full is indeed something that is normally only 
observed with IGTs that hammer the submission path, but it is still 
something that a user can do so IMO we do have to fix it. However, the 
bug is still extremely unlikely to happen out in the wild as it needs 2 
relatively rare things to happen:

- We need to hit the pathological case of the GuC CTs being full and the 
stall kicking in
- Something needs to go wrong and escalated to a full GT reset

The bug report that triggered my investigation into this came from what 
look like faulty HW: the HW seems to suddenly just stop with no errors 
anywhere, which leads to the buffers filling up because the GuC is no 
longer processing them, followed by a GT reset as we try to recover the 
HW. To replicate this locally I had to add a debugfs to kill the GuC in 
the middle of the test to simulate this "HW silently dies" scenario.

Daniele

>
> Regards,
>
> Tvrtko
>
>> If a full GT reset occurs, the state of all contexts is cleared and all
>> non-guilty requests are unsubmitted, therefore we need to restart the
>> stalled request submission from scratch. To make sure that we do so,
>> clear the saved request after a reset.
>>
>> Fixes note: the patch that introduced the bug is in 5.15, but no
>> officially supported platform had GuC submission enabled by default
>> in that kernel, so the backport to that particular version (and only
>> that one) can potentially be skipped.
>>
>> Fixes: 925dc1cf58ed ("drm/i915/guc: Implement GuC submission tasklet")
>> Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: John Harrison <john.c.harrison@intel.com>
>> Cc: <stable@vger.kernel.org> # v5.15+
>> ---
>>   drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c 
>> b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
>> index 0d17da77e787..0d56b615bf78 100644
>> --- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
>> +++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
>> @@ -4002,6 +4002,13 @@ static inline void guc_init_lrc_mapping(struct 
>> intel_guc *guc)
>>       /* make sure all descriptors are clean... */
>>       xa_destroy(&guc->context_lookup);
>>   +    /*
>> +     * A reset might have occurred while we had a pending stalled 
>> request,
>> +     * so make sure we clean that up.
>> +     */
>> +    guc->stalled_request = NULL;
>> +    guc->submission_stall_reason = STALL_NONE;
>> +
>>       /*
>>        * Some contexts might have been pinned before we enabled GuC
>>        * submission, so we need to add them to the GuC bookeeping.

