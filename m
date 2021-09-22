Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219294140D2
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 06:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhIVEuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 00:50:11 -0400
Received: from mail-sn1anam02on2047.outbound.protection.outlook.com ([40.107.96.47]:41846
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231366AbhIVEuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 00:50:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8R3vm41Wl7EIz6gAx99wxWoIy3iMTY9uXf/iS9YoFYYDSaoZjHAZDh+wdjO0bZg3aVKDyliB3GJg4JDm99D0tSjXwJMZimvvN0g8CQqRRsGU+uaZI/NX1rQ8XX1iavVtzoLrW94YwK9egCjK3ons2LXBORhG8HRpNKF0YJogJVvx3znUxHYRyNtmpqNNxhsOPOdtEajrcDHvwKULeeSb1Ngj2bko6Z94VU+U7yI08e9Vi+i5NpQJt3kKlnB2LWxdLqBX+yVXh8Mhpqc1Iaynh/sJdyalj8f/PyOApJFew3+2fX/kR8qEpElK435gyuYKBimERJRFAuXyV8pthFFWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=b9PBR7p93OD7QS5tPRlypjfqglLDDFpL8IPm0uyItvk=;
 b=m3LrLzO9uyrWvXxeLGIBQH8ZLVZhEkYhcuH7CV+DxgYdHKBN4gzpUc6xXaeWIJQ3KzYGnuESkKedntxOYWTHUG46bgZ9v/YcSSYCrXdVHk1RpQWUer+bdTJ/W4DBLOvRZCMDzBQYAguBIXXEURh4Zb9Ko1hDNmBJeZtHEyobf+x2u9++Rbh6BFPeJkKZlTYpQ0rWy3xqVBsBrCVk/d25yoypPpUpJDG1BB+Vk/wgvPSckuT3wyz0u2KxxXpTz8rUuFbvmKyCe0i8YhYno+7+TYiIzeHyj7vbZsbKwsnWVS7XvnTkObhJISmSke7FT+qRJSPyMCnGIzBsErdVifVb1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9PBR7p93OD7QS5tPRlypjfqglLDDFpL8IPm0uyItvk=;
 b=cLBMBCzFWgCF2qo9KDyhB2yDqEc2Pdu0EBHz9JhIBYLey7ESVW4T5v+zd7sN7WApLuQNGEBnJEwwQ6GKX2aT6Z1rcLS+t4TOyNkcTjfxGsMVHRLpCwt3i/IFdsXVxQUYNKXSVzfATqq/ihmhsozBvRNqzsAIbAmeL6yEr+IMvcKn8vqNPWY/VVRan8QW2tVsmf5xOQZPsbNkUY9273r3J3u5qyrVc5oJG+XzduuGpampwovSuOatiMrSFxVTGmwGWwTyYCn1pHIgck5kMQSNVpYB9jgS+MBdMPoCDV4U9vUcgq2LTsaOfp+332ug8OX1+M9rjMkCZNz5YsFa+eLQ4Q==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 04:48:39 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::6811:59ee:b39f:97b9]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::6811:59ee:b39f:97b9%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 04:48:39 +0000
Message-ID: <fb44af69-6353-e18d-af0e-fd154cef14e8@nvidia.com>
Date:   Tue, 21 Sep 2021 21:48:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v2 1/2] mm/debug: sync up MR_CONTIG_RANGE and
 MR_LONGTERM_PIN
Content-Language: en-US
To:     Weizhao Ouyang <o451686892@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Yang Shi <yang.shi@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Mina Almasry <almasrymina@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Xu <weixugc@google.com>, stable@vger.kernel.org
References: <20210921064553.293905-1-o451686892@gmail.com>
 <20210921064553.293905-2-o451686892@gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20210921064553.293905-2-o451686892@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::7) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
Received: from [10.2.92.177] (216.228.112.22) by BY3PR05CA0032.namprd05.prod.outlook.com (2603:10b6:a03:39b::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend Transport; Wed, 22 Sep 2021 04:48:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd58a446-ece5-4eb3-00ef-08d97d843ed7
X-MS-TrafficTypeDiagnostic: BYAPR12MB3192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB31927CAA3955A041BF41F7C4A8A29@BYAPR12MB3192.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:110;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OAVsOqwFASPZNHitu9R/QKa9t278nZbC7z4dKlU3/+OsCYGClXnm9Sn+Pn/5luYhWVkbwfEc5VUYHsQJoarNUZ4j12MF5IEhrlQu0FJuN5L886Fyqg44bpTUXG3s36oOYzYIAYzmmigJwILSMDR3dReem4pySyTV64lX7agx13KvgD2VDXW5u0xuJg/s6Fah8KPJ+oy8FP9dfmLSsXNTFgRP92WxQysDKbgkVVOM9EQ/dwsruTnD5Aa6r2DPf0vBbZw5CRV7pE0dQ/j1IXxXEk0hPvR9u3e3THGiPSJEYW4LDuRK5l/y9cH6tZqwvNrzAAr2XhtZPxh+z4SbKGpx7VT5kMiGo8tv7PPRtW3X4g2J698T3eWlLH11PD5Oz+rBVtGH9TZztHKZoCBqys7OQVe3GAZvNF6a6HbIqLXAlwE4q18ZJSxIgbiriDKFATP3AWyk7pLtYPfLE3mkDX6Tk9OU33AfHVraHRELbEZ/PYLc8tSCrxJoow1uPUuq5PMc3wJ6cB/bzTue+n5C9+fO0Wm7Pdf9yip1Ug/SgP1PYg7fueMn5X+NccwfUBpzG+1GN+f87M7ljUQORyxNID65utY9gIDmfzfhWiZNG9170VFEDho0JbmykGtO4eS9A98/qt7ObrrBNxcgkig6SRAkvFkqza2Gj2loPPzSpmPHW6jx1GO0EQWOlv7ee0e+Ytdmj0dZ4Ts8n2KsqelJNyit2KMPgsOXkfL95pS3zylUDP0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(2616005)(956004)(16576012)(4744005)(83380400001)(66946007)(6486002)(53546011)(508600001)(66556008)(36756003)(31696002)(110136005)(2906002)(8676002)(7416002)(38100700002)(54906003)(86362001)(8936002)(186003)(316002)(5660300002)(4326008)(31686004)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UU5LYUZDUk5nS00xZlF5YnNIVmFuYTlBVlRURVFqdnV1dHF1RmlSVDkxa3Rq?=
 =?utf-8?B?L1E3TWRLRTUzQWkyNWxLLzJoWllZOVRacTVEWUcwQXhQMEV6RjZSNk93NzBC?=
 =?utf-8?B?TkpWRFhsM1FYNzRKRFpZSXhJUkdJNDFtTktUTmlYM1RmT0Z2OUxLNXRzYkdJ?=
 =?utf-8?B?MVhjMDhPcFM2WkdNZ3F6Q3ZFSWwraVdhbUVYM0ltWU1jZ1EvdmZHL3huTTM3?=
 =?utf-8?B?bUh0aHliUXY5RUFvOGYxeVJaSWlPWU1wZ3JUdTdLZ1RCRDFKUXJhcFVDaHc2?=
 =?utf-8?B?dWRjQUdVc21tWGVrU0xBNXRSV2JKVHZlRTR2d25NeGhKZlhSVjU2dWw1WnBp?=
 =?utf-8?B?RHhsZ2pvVXFIRDJuRGZwVGc4T3M3WGNhTWVrSCt0YktpWVVxcmhLMDE2Uis2?=
 =?utf-8?B?TkszVGZyNmdHcmdIOFRET3MvWTVyUnJsNGRuTnV6Q0c2QWMrT0ZBcmpXWDhZ?=
 =?utf-8?B?TjRLYnMvWm4yNW0vcVJaeC9FMng4STNjZVhlemQ2NkIrdk9vcVArRzFMZWlM?=
 =?utf-8?B?ZFFscVJzMUVjeTkyenhwYmwxdDk3eXFhbW9Nd3JCREZ4TjVhd2Q2bzFmU1lv?=
 =?utf-8?B?YXJwbUZWZHUvcEwzWm1NN3ZWWWFLL1gzdmIxbERlQnpRcnFBSXNBU3R4S2xh?=
 =?utf-8?B?a3RCeDYvcG91VjJvNTlZcHh0bGkyU3MvekZMdXptcFNZM2V4QUtXdlMxQkNC?=
 =?utf-8?B?ZW5SVW1Mc01wbWVSaSt5WExjcEt4SFdqOWIyU3hUUzgvNGhSWVY3bzN2WWFq?=
 =?utf-8?B?VE1lZzJ4MmNGQWFrWEUvMVlzUWlmRDM0SEF6L09haVUvQWVza1ZMSGFKUFVX?=
 =?utf-8?B?cFR3aFlOYTcyWUlGazYzeXJRWlVWdU1GSkJ0RTlxcUJ2djEwMytQUDJjR3lt?=
 =?utf-8?B?K0dCcnM5SXFPS3hzRjVlNlFtcFVheVcxYjhQc2RaN0hRUWhINUtPdUdWclBO?=
 =?utf-8?B?cjBCVko5aGRnMEgzenh0QWxtRVpSZ0Z0L0dQcXRDcWF2ZXgzMU56TUxrZndi?=
 =?utf-8?B?RVpmM3VGendnQnh5MTNiRGhYY2daRGRKcmNVcVFlSktaT1EySGY4MzBlb0V6?=
 =?utf-8?B?cmdhaGRJak5KZWZhVm8vZk5QUmZVZ0d3WEdHQkYrMTNtL1N6c21WVzJINElT?=
 =?utf-8?B?aDZUdytRcVdkWGhqMk1FYVJta24wRnloSzVQQXFXZVZ4TnozaitnSHFLenRa?=
 =?utf-8?B?c2E0am51bHRVSFEzOWwyOVR2WUtRQlkzcVpDYnBYV0ZERUNDRXM5bHhEcjZr?=
 =?utf-8?B?aytPbFh1WkdMNXB0clF2bE16YkJqV2R1NzJEbkVvME40bi9TTGVFZHJoNUV5?=
 =?utf-8?B?eEJaMnRnR2R6N2ord1Rqc1hMejdDcDg3Tm9OOVBORzF5K0pPNytndGEwSSsw?=
 =?utf-8?B?OXBZbmpUcDI2WE5WVVRMdEdsejdiWXpnTGxjYkNFd3Y4UEJOaUIrNG93VHpR?=
 =?utf-8?B?NVZRVTBkWTJoRGs5V1hWdkowZVcycjlhMnF5K2pacTdSbUVEYkFoOFdFdVNj?=
 =?utf-8?B?d3VKS3BEZk9VK09EMFhTQU1tWGFmb21pL1JBdXdRTUlOay9WR2N1aDJVNHhv?=
 =?utf-8?B?YWk5RWxHRlBWQUhUTFRSWFVSTWR0YTNKNGxlYnFFcmtqV1FEcS9pOTgyMTRK?=
 =?utf-8?B?QmFqRlNsSE9pNFpraGRPRTArR1VseHBYb01acS8xQ3FvSzQvMFU1UmpwY3Ux?=
 =?utf-8?B?d2JDSDJOUkRHU0FLRkNpa2dFdDM2N3cyZTBqWXY0WXJSWlVTdWdjR21WbVR1?=
 =?utf-8?Q?2SuwBqLcdYwrv/FhkSANxZUH2yf6kFGvr4xkuPA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd58a446-ece5-4eb3-00ef-08d97d843ed7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:48:39.5408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JK/DY0ylyc60ymfXbSjViYpbckYawwz4kt1A3yiTpNr+9TGmzabJ09XoPmFYQzVPBKTWPh11Yup8MU1s813LLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3192
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 23:45, Weizhao Ouyang wrote:
> Sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN to migrate_reason_names.
> 
> Fixes: 310253514bbf ("mm/migrate: rename migration reason MR_CMA to MR_CONTIG_RANGE")
> Fixes: d1e153fea2a8 ("mm/gup: migrate pinned pages out of movable zone")
> Cc: stable@vger.kernel.org
> Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> ---
>   mm/debug.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/debug.c b/mm/debug.c
> index e73fe0a8ec3d..e61037cded98 100644
> --- a/mm/debug.c
> +++ b/mm/debug.c
> @@ -24,7 +24,8 @@ const char *migrate_reason_names[MR_TYPES] = {
>   	"syscall_or_cpuset",
>   	"mempolicy_mbind",
>   	"numa_misplaced",
> -	"cma",
> +	"contig_range",
> +	"longterm_pin",
>   };
>   
>   const struct trace_print_flags pageflag_names[] = {
> 

Looks good.

Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA
