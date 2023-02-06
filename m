Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AE868BBC4
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 12:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBFLgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 06:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBFLgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 06:36:38 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB5D13527
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 03:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675683398; x=1707219398;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0QsQY6F0vTVIL0nQL8a8DiDR+9jKN0hEcO7fKvUQea0=;
  b=A/+w+tug8BbVilgVE+aduxjweEiLLEvPKqHBp7yijYJ/YDMgEuQjGQzQ
   He2ArPqu0q84MxS6nX1tR8lQuE7L8C4FCDZDMGdCZKEYGafeMzhMNZDLL
   1AAo9W7i5yluYvk7eCaKVhK0Kqk7JkgQNN+E+HrpfsdNdfhUq2gj7N7mq
   AGUo6irpVmjvAPNAE8UdmR4nv9qbniYwlvA8YXqttMvXVSpm/+AuFPfg8
   ndeePtyQo9tMI9/pFoR+xpqpwwBSRkRwEQdcDJ4+sDpoO7hY5xgyfPUb2
   JDhioqhUWtlYVusflw0Ynzxr4ERBdaC9TJ+P08FukJTbwsb+2PZhKHKEo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="312838626"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="312838626"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 03:36:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="616410710"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616410710"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 03:36:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 03:36:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 03:36:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 03:36:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 03:36:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZMxGSisRXlNZX7r26wufcn4aqaIUaoDKp5IclyRRv3CdWxu9SPVPJy/8B5eGG801vUBl6ik7i/9NicCkdAXXIgJGXZpAvHASKMFBupK/Z4bSSPtpZoUP/8bz9nYx94t4XqEm1BzHnwKoITthsqIBFCa5DlAmGvfXz8xnAfbunbAjZn0kLNvPq37danoWMff5iGYxI9kk5melBGegr8kNexrXuFhbSJodOX0iYqhlOycI4SKe37uB4j/3UJtLZnv7rx0wRCNR0sg9c8G5wGBrcoxnsOsR8AN/BVXGO0sA3iav90RllExEID9PV3+A6MudscOee/YRSAs4ewda4vvkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJfcw7zTJ24zHGByqf4CL7eW9Ty8ETW7MUqIWv8Tr4Y=;
 b=QAGnb1Sb/g+d3QPrhtKN/5MvGSmW5Vw2XkBLz79AqYGZXlIrYH9WN2oagO+A83hNcOHhHiQvWVVA+uNLnjBL00qWC1H6SqlaeElFCsEc32G8qLfIOkC/mdu7heCRodJZ5tXONLTbTYXzNzbZ7x3Za2R9fEviEXzqK60Hy/Yfc7nz6fFzQf7uw6K7jCNDbBiOvJ9kte5NqtmkHiH3qLosSrEkdAMr8VJSp+wqr+sDONfkihpMMF9qAefbo3DmvC2F6LB8UAxH0RJK94U8qva+nM9/aNcKUIEaQR28mtKHSX0twli+Ti9fvHL/WGRt5NRd4xxQyQ0X9BHBuqJ7eH3CRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5474.namprd11.prod.outlook.com (2603:10b6:610:d5::8)
 by DS7PR11MB6150.namprd11.prod.outlook.com (2603:10b6:8:9d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 11:36:35 +0000
Received: from CH0PR11MB5474.namprd11.prod.outlook.com
 ([fe80::5362:6125:375d:5a9b]) by CH0PR11MB5474.namprd11.prod.outlook.com
 ([fe80::5362:6125:375d:5a9b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 11:36:35 +0000
Message-ID: <b89d68c0-f7a3-8bad-f35d-fd7d83790a4f@intel.com>
Date:   Mon, 6 Feb 2023 17:06:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: Initialize the obj flags for
 shmem objects
Content-Language: en-US
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        Matthew Auld <matthew.auld@intel.com>
References: <20230203135205.4051149-1-aravind.iddamsetty@intel.com>
 <f761df58-fd0d-4f08-649f-365e55b41f7b@linux.intel.com>
From:   "Iddamsetty, Aravind" <aravind.iddamsetty@intel.com>
In-Reply-To: <f761df58-fd0d-4f08-649f-365e55b41f7b@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN0PR01CA0034.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::15) To CH0PR11MB5474.namprd11.prod.outlook.com
 (2603:10b6:610:d5::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5474:EE_|DS7PR11MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 385beb78-f240-4df6-fe2b-08db083666a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: St0eYVf6Jkc8g03qNP7bIYJWbtNifK+ns+yxQ9/ERs5EhKmSW95y0NungVenaznP9F/yBMf1kcS01qbyCwmqzyT3r/M3BQNfY4d0iJGEg+14Vm6tHn5uGR4IhLamiIG8jqz/F7RAxwO+t4NjeE8TudaHr1aYdJjU2qCUl42Cc8AvbiewCZPkpSVB6jduq+mO7CmDKiFFwf+4Ie9SgzCtlrPVQEx/k1Wr98Sc2PbmIYJY3WqW77dKzL+BfGJmDbb3Z6zK3LgwoJJh8DAqfq1Yth/iBiW+FIv7z1Rfqi9kOjjOfChmi9ewZU9ek6Dvhs4Ihxih9FEh+8nqJZiq/TPFiJuEIhjjlE88hN6xzNLhWaM1BLNzfv8sZNERIn0MgkkmWOiR5mBiRwFV2pKXuVjG6wWXjopXzYzybuq4RaZz46kRqsI+off0cZkz80DDX35KD74dGEZvmcQruS/oQOrYbaNZo4L6A09FT+TwJlx4LHHBfZIzHPcC7OghL7Ut5x2/rWsfVEduqUAM6C7w0xOnA1xW6Qu2Ju/EWAbrJnwzdo15f2WTEH0GKOJETWGPfW5YvWP8kkH+C9xmxBwWgVK5tNPGPaCIe7CDUwcwB8Svqk0hD96EpIPfzBb4hBppWfC4xVu0lZQePqz91tMze6uolL6uLe7eo1hyF3kl3fAyIB02KwJ1QvDI0q6vfwliXsQ/U1n7WFcAzAGD1WkGVCmQz9RKkCu6/rgc5IEt18poevc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5474.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(5660300002)(31696002)(31686004)(36756003)(2906002)(41300700001)(86362001)(8936002)(26005)(316002)(6512007)(38100700002)(66556008)(66476007)(186003)(66946007)(478600001)(8676002)(82960400001)(4326008)(2616005)(6666004)(6486002)(83380400001)(53546011)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXJ4UnByK0xFcWlIQ0wvNGkxcmFCc1drQi9PTnhhYXRxVlJuUCs4dGNlSS9a?=
 =?utf-8?B?N3ZqU2Y3M2tXZ01vczhLT2lUc3BUdThpQThsU2diWTN3UE5mL3dlNHFrbVoz?=
 =?utf-8?B?Z0pVZ0tob2U4QWMvVGJIb2hweXUrSkNCQ1VJcmh5bGl4QmRaMURCWmJRRWE3?=
 =?utf-8?B?dEZOcUpYY3hGcUtrVmJkaVgyKzdpVG9DVVBDcFNkbkU0Tkx6eThqWGZIazRk?=
 =?utf-8?B?Q216dVo0dWFDeHlFdnM5YnpwNXNSc3FyY1BhNWFtNUxiS1IremFQb1VCNFd5?=
 =?utf-8?B?RDRaRC9xcDBTZkNZVWJNNUhCQkl3M2R4U0xCL2txZ2dNTWZYVU95M0dOUlp5?=
 =?utf-8?B?ZitVbTVqSm02K2oyYmRObXdWcWlGYlEvb3ozV0pFWENIWnR0ZjdOb3F6Uzdw?=
 =?utf-8?B?VGV5K3M0ays2bFMvQVJQTnlZODEzT2wwUXhJZ3NYcU5hRTJRRFdHeVZ5dWdQ?=
 =?utf-8?B?WnNyWUhLSmRxUVRQS2E4RlZ4enM2bDR5MUtnbFJwV3IzelBCdXZ5Z2ZDL1Vv?=
 =?utf-8?B?cTRwWjhFTGZ4cUkxL1FXUGtrT2ZmcTMvd0hQaWsrNFpUUEFnc3Q4TVd3UzZZ?=
 =?utf-8?B?TmdIbXFuK205UUpuaWY0UzBnK0gwMmVqWldNSWxZYzZnR2xyRnY0QmxRWDEw?=
 =?utf-8?B?TEdnRGlOK1huZk5ubXBJZi95Tmh2dDVjR0oxalZFN3hGdm1zZmxGb0Zodlpp?=
 =?utf-8?B?dXdnU3FESVVkVzhmOGI2eGx3cm5KT1M3KzY2akt2SFhPSTF2Rmt6WTlmQ0FQ?=
 =?utf-8?B?VkdLUDhmc2xtK2hsaFBpS3ZvNzNBRDhFeTVpMUxWTTRnSzV1SkdVK082b01a?=
 =?utf-8?B?Z1hpQ3prcTNEN0pCRkJQQ3NiWDJEdkhueVBYVWd3djFYOXhXWEZ6WlhTSFR0?=
 =?utf-8?B?bGlRM0VrenhVOTRNd0NUbTg3ckgraFBaVU9vbjV0Wk9Pbk45WTl0T0dQOUQ2?=
 =?utf-8?B?cTE0YjZWa1JTRVkxNkM0ajJlSWc5QXdoQytHSlBDKytnNWNCTUllSDI0WWhM?=
 =?utf-8?B?NDlDY0VHd1Nuc1FCOEJ5M2F2RUFoU1Z5VUx1RkdIdFVLYnB6dURVdGZnTTEx?=
 =?utf-8?B?TUhSclUxZmJIMGxnRk1PTC9UaHNlMGRPNTIxMlM2dHNqdkdxcHBsR1pRUjZD?=
 =?utf-8?B?UFdHRGRzUjV0OVlwNjNibGIrK0RvMFpNYmF5bGtTakoxa09pclMwWUdPRkwx?=
 =?utf-8?B?Mi9XSzluV3ZyVEJzNXEzYUlsTVBmdnJ2dVhIM2JLanZRL1JEU3Y4TkhyU0VH?=
 =?utf-8?B?dTFkclIrQzR3UjcyRm81dzdwM0FLRnhXUXJjRjBrUlBHRVN2Nm5UY0I3RnFJ?=
 =?utf-8?B?UzhBd1FNZE1UbGhmUjY0SUN0RlpScEpxeVYrdUFZZktDVlp4dDdFd2tvaUFN?=
 =?utf-8?B?dmRMbjNwcmhvT0pGYnpiRkdZV1NSOWM4a3duZXg0NFo4QkVNc24ySVFVYllX?=
 =?utf-8?B?L0RmVW1RM1czU0VzMjZLV200YlM2c1prVElWTFFhWTNod3c2VXlVTlZGeis0?=
 =?utf-8?B?Y2xGcTNJamJGSHQ1OGZjUW01ZVBWOE5kd1lIUmVLS1p4dCtzVUVRdzBDc3lJ?=
 =?utf-8?B?TWRtSTdnb1hsMHc4M0U4Nlp4Q0VORnBsak5ITnVTb0JxQWYycEVseDZvYjBW?=
 =?utf-8?B?c29zTVFWNSsrRjVCUEU5ZnlZWS84enlhWVEwYUo4cFViVFJFYk5JLytWcjQx?=
 =?utf-8?B?bEhEUFlBa1RCQlhyNWFCYmdmVWZ3UndJNnd6RWl1SG1iOW42V1ZxSGV1Y2NB?=
 =?utf-8?B?WW44ajRKVXpScHJTU0FnckEreUo4TUZRd0ZueTk4L29YbkZpQjRwR3NFbDE0?=
 =?utf-8?B?Z1R6Z05lWTI1c20xTngwTjZoZTdJUmFPbDFhRWZwdTdBcGZRb2Z6b2lCK25D?=
 =?utf-8?B?QWNOVHhLRDRjQ3dsazQya0orSGIwS2Y5V1YvcGZhQThnMGFldHBzRmovMzA1?=
 =?utf-8?B?S01mcjNyMlJ1V0pOVXhIeHQ3Z1hvTFh2VFF1MkdsR1VEUEgzeEtVaHc0dGph?=
 =?utf-8?B?S0hjbUVzWXF4RVNYMFhxRHVxZHV1d1FiUFo1VzIwa2NFbGpkNVNVeHdwMEt6?=
 =?utf-8?B?cHRibWtsU2pQaTZzYldQaW5Kb2pjSTJQRG9GMW94SnhTN25wUFhPSXE3RW5H?=
 =?utf-8?B?enNxS2xpYUxrbDJVR0VqeVZnZFBNNGlxZnhlS3hwa09Db2ovc3REVVRYd3hs?=
 =?utf-8?Q?jC/6fYHnBh9nFcEQYkeLaxg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 385beb78-f240-4df6-fe2b-08db083666a0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5474.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 11:36:34.9439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSsZ1GQSCIwje5Yy1R0Iow+bKTpQlGcjwA6jNzi8sFIn04zR9wFtRh0UQf8CAD8POPq8VE9EKrQMS3T3s0HIlYyJOtMeHBh/rl9EjwYXzbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6150
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 06-02-2023 15:21, Tvrtko Ursulin wrote:
> 
> 
> On 03/02/2023 13:52, Aravind Iddamsetty wrote:
>> Obj flags for shmem objects is not being set correctly. Fixes in setting
>> BO_ALLOC_USER flag which applies to shmem objs as well.
>>
>> Fixes: 13d29c823738 ("drm/i915/ehl: unconditionally flush the pages on
>> acquire")
>> Cc: <stable@vger.kernel.org> # v5.15+
> 
> These tags should have been grouped with the ones below in one block.
> 
> I have tidied this while pushing, thanks for the fix and review!
Thanks Tvrtko.

Regards,
Aravind.
> 
> Regards,
> 
> Tvrtko
> 
>> v2: Add fixes tag (Tvrtko, Matt A)
>>
>> Cc: Matthew Auld <matthew.auld@intel.com>
>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>> Reviewed-by: Matthew Auld <matthew.auld@intel.com>
>> Signed-off-by: Aravind Iddamsetty <aravind.iddamsetty@intel.com>
>> ---
>>   drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
>> b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
>> index 114443096841..37d1efcd3ca6 100644
>> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
>> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
>> @@ -596,7 +596,7 @@ static int shmem_object_init(struct
>> intel_memory_region *mem,
>>       mapping_set_gfp_mask(mapping, mask);
>>       GEM_BUG_ON(!(mapping_gfp_mask(mapping) & __GFP_RECLAIM));
>>   -    i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, 0);
>> +    i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, flags);
>>       obj->mem_flags |= I915_BO_FLAG_STRUCT_PAGE;
>>       obj->write_domain = I915_GEM_DOMAIN_CPU;
>>       obj->read_domains = I915_GEM_DOMAIN_CPU;
