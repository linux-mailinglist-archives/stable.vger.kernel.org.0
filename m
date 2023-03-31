Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF56D1816
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 09:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjCaHG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 03:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCaHGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 03:06:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E415191CB
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 00:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680246395; x=1711782395;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TO5ui8+sdfq9sxUepo1JRSpd4fwTmX/xNRkcG0uneUQ=;
  b=EnonnzYJ07w598V1+T0UYyd3NxsJctkTCEeE1HiJyD51Jwxw+l9F9D4t
   JRkxENA7SJXaFYnot/vNrRRiqud44lIbqcf3wbjIJ5gBfETHIfhJNb2qs
   1rwn1TOxTYnhqAw2lK31BPrFgXYBHTsYbkSx3M4DEZDQF4vh/X8v5Py6E
   D+OdKb0E0YcDfdXV0rRkj9CU+2jtSQnczYVjfniN/uKExr/gLmg5e5O0j
   SPZ8HPlSj71IrWukd3Mw31D2afGEKNUioNX8usU6BDvx7akHKPnbouKeq
   smsurZjBimacXSi6TA2YfucY3xNo7W1UE6TdOBkCDAMtyPoehD6OjdMNl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="341391157"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="341391157"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 00:05:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="717600276"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="717600276"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 31 Mar 2023 00:05:21 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 00:05:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 31 Mar 2023 00:05:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 31 Mar 2023 00:05:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xv/2ePyi1KY0puDdUfigk6B27wbv4DyqVT/Kc2TlWxaHozcl3dSkJCPCpquBxhJCU5C/9zQzTXXWZP/hPofBu/mMBsHHVfkYrFG6AsCc6cXHEfJwWw6g2w8E60C4HJkluHwNngESvfzEb9MJi1a+HGvaXRfsveb8+l0YZbbpXtPruQJOFt1vq1MwTBlg0m+bUjH0f+Pg72zs1qS9N/jZl+NTYtHnkHMkSAFyvUhHXYlBw2OJdlSMgoLi2lY1dKly2mzTy4usEjA6ZZEkJrC9HRkPNtXPq9XA5Sw3lI4glcd6/7H8AaXDulj6O7CMhOmBMEtum/QQ9Sd0BX8TtOQqLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMPd65jiyGCWW+0kJSVtoSuBbFMBnHBAf+56lF2EWNA=;
 b=CGsVPBtXtXvEiPjoF20NbSmTE2Srrok9Os96YV882TQb40HJKIkWVlQ3VMOnUVGt6vB0mqSPmruao+sDq572CKo7kR+C7VD55QIgolLSQbQHUAlRDd8VRYl6taM/c/yQ9xVw6cyFLVnkZD4ZBMoB7inpXEtv8Aqk/vG4c+NlanGxC/iUnujZBjIjBoHYFjRjMSyIbnPm3X8D/vMiRVlk0vVRwJ/0MqMPERpnZj647xDsRtbaSIyK14klgOAe5i9Oh8B5/O8LRa/RLMq/lWxeUouo9NyOLwGxd1CPh38aXz3Lnes4JCL9nYSp4pVrVeWXDwoQqwRo7vbHOtfT+fdBXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2907.namprd11.prod.outlook.com (2603:10b6:5:64::33) by
 SJ2PR11MB8348.namprd11.prod.outlook.com (2603:10b6:a03:53a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Fri, 31 Mar
 2023 07:05:19 +0000
Received: from DM6PR11MB2907.namprd11.prod.outlook.com
 ([fe80::22a6:927d:6b03:69ee]) by DM6PR11MB2907.namprd11.prod.outlook.com
 ([fe80::22a6:927d:6b03:69ee%7]) with mapi id 15.20.6254.022; Fri, 31 Mar 2023
 07:05:18 +0000
Message-ID: <c2ea8625-7f46-e05e-4b71-6d5bf9d22deb@intel.com>
Date:   Fri, 31 Mar 2023 12:35:09 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable sampler indirect state in
 bindless heap
Content-Language: en-US
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
 <5a4a00f4-9641-0c8b-c0f8-2fc47dd91cff@intel.com>
 <ZCNvAOM7AuvpsRsL@msatwood-mobl>
 <e2aab6c0-4cdf-f122-aa10-648191d06cc6@intel.com>
From:   "Kalvala, Haridhar" <haridhar.kalvala@intel.com>
In-Reply-To: <e2aab6c0-4cdf-f122-aa10-648191d06cc6@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0176.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::18) To DM6PR11MB2907.namprd11.prod.outlook.com
 (2603:10b6:5:64::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2907:EE_|SJ2PR11MB8348:EE_
X-MS-Office365-Filtering-Correlation-Id: f51d77d5-36aa-402a-da20-08db31b64917
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MPthluM5I7LbkGtknc1LJv81tqAql/UUThKKeV5DICmxn5gFTbF6ldH+1GNnqizM6nqMoCAA+s5btqsfC0bhS4OUjclpODzB9ZqWm6ayPZvAb+/ADxuJF+P+H/ZEm9rACDVpTK2eWpiBMls8JjuaiUf2O/bx5Qn3q2XKJfWeoBVzSWHXRheF7bI5cRnHqmErxioHFLW2BjfMvoOedNDiuDEpuej5e+r86xTSEAEJJoTnqKiIozkNH8TgYD0afINd6metXIvDK92g0VVrBlwtLZnf01KKGPsE76lGGTp07KtCHSGXsfoZZrHFbds1diVdfFtqkxZ+YrM6YIFtWQ1K7vy/6PQ8RL/FNpNmksi4diOFe+43T/CrX5mydgvCLv4iwhlbgMBpPKVy5KN+Nd2vqflmHyYjiOKx2cuxt467bCvOlM+tigoMwEyJpOaPFibX0r1BCkQ+XbUccPe7HQXD87c4b3/bd8hZ1ohKTtDw/VHTSWi2GZ9dsrQt9sY+3DkdpwFCjU5Usgp+hVuf0q9R28FohRMxJfFSDL8Hwg70iIrkW4mCkeMaZosoIWGHYr42bK/YAAoDt4iuWtOPaXPdDXiSx+RbbhRQJwpkYAUXFB27ZdOyXBiSOAJvVhAc6jq7zWG8Gj5jvkdt5QvbZNfZ9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2907.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199021)(316002)(6512007)(186003)(6666004)(53546011)(6506007)(110136005)(26005)(31686004)(2616005)(83380400001)(38100700002)(6486002)(478600001)(8936002)(86362001)(5660300002)(31696002)(66556008)(66946007)(41300700001)(8676002)(66476007)(2906002)(4326008)(36756003)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUNNTlBCUjhIbVF5NHJhdGR0dlNycU83L1ZRaE1tcS9OSk1GV0xiWWpCQ0E3?=
 =?utf-8?B?ZXFWdTJmT1RnQTZqaXhsNTVWYm5GNzUrS1djVk9vQU1qRHNxc0ZRZEN2UkhT?=
 =?utf-8?B?QXNlMzRWZXN0OWFmaTVITXFrYzVCVDU3MkR4WUpXOHdhUjJkQzVJaVFtajlk?=
 =?utf-8?B?SXdxQSswN0k1d29zaWZFWm5aT05KNXphYmZjVHVKYkJ3VzIyK2hPaWs5QkFq?=
 =?utf-8?B?amZOSDFNMkJubk9pVkpMVzBEcmQvMzIxTDMrSWQ2QXBQMm9raXRQbGJUMmls?=
 =?utf-8?B?anRqOXduU3pkMXAvOVhvaytrWTFHOTdYc0o0bTNlQ2JVWDg5NWZLVlF6RkhV?=
 =?utf-8?B?N0VOZTFjamdGdndlTXZ4V2lHU3l4dDROYXFnSHBRM2ZXRzBhVnJ2cUdFL3Vu?=
 =?utf-8?B?Ui9Hb1dmbWVoSlFNMjFmY3dLaTdIQ29tTU9pdnpzTEdsd3VBV2Y2eXhJRFdO?=
 =?utf-8?B?bEVuOGg4OHJGZUdZQWM4UTVNdjJadTNMOTRPTzBNSEhONGNWWWZ2dUZtU3By?=
 =?utf-8?B?aWZ1SjV2dFNwUHNXVmJtUzhFYXlhQnRBTDhVZzRIakxjNE4yTC9za1lFSjlW?=
 =?utf-8?B?dEFjTlRldVZYZVBPd3lHUVN5UGlzamxQYjNabythcm4yeFNmcldQNWViclhT?=
 =?utf-8?B?U3FPTnA4c2huNU9aaDVweDdCeW9KRlk1bTZRczcraW5QVFovVkkwU2VQQnVD?=
 =?utf-8?B?c1VWS2cvTXZPbHNzbVBtcTFjM3ZReHFHdER6WjVYclNLdWVSL3NrdHoxaGtO?=
 =?utf-8?B?dHhUc1Vmd2hyZHZaMmJUZ2lCT29zTmZaaHcxSW5nT1B4b0szQWtibnYrWFZC?=
 =?utf-8?B?MkdzMkdsMzVFMlJDQkJzTHVVeEFVUHp5bEtyNG9yZGlTT3F0NUcwbHlKb0xq?=
 =?utf-8?B?Tk44NkVMVGw5QXFmYW5kQ29Da1ptQXRDWUhMTGNSQXcrTTVINDhUcDkrSll1?=
 =?utf-8?B?MnY4Ly9qbFJBejE3K1F2eERqQVhTaUF0c2tCNlhWc3AycUI1OFVtcjNsRC9h?=
 =?utf-8?B?UklDUXpIUUxncithNXFRYnA3K0RUV2VyVlJoNloraXBndStMdVh5K1dUSjkx?=
 =?utf-8?B?dTk1SVhnaklqZUZJRlJMZnJ5SzNFUGRkZTVoVjVsZkNUcko4YysrU2FqdkFm?=
 =?utf-8?B?SnJyZDUxZVROb1puVnB4MzJHZlpldng4M21GdlVML205bzlGY082ZFV2VTl4?=
 =?utf-8?B?b2Vic2dEL1lNN2ZTWHJrZDQrMXNwV0hlMzgxTWlXNUFrNHZ0emVnYm8vbHFD?=
 =?utf-8?B?Tkc2QndHRFArNmNtWVRWbnNDK2lFUUJOaDVQOEdlQzNOeG5tU3EzWEthNHAx?=
 =?utf-8?B?cThXSUlGeUZWYzdmUjNCS01xNk0xQXZheXRmQ05mblR0d01Ud2ZjU2JFT0Y5?=
 =?utf-8?B?K0o2QjBEaVRjRXl1aHJjbFR2Y0xmSTFRVENTSzlYUEZFaGdjR3pxczV6RTN4?=
 =?utf-8?B?aWdvTVVnSzFuK3ZoUk9JejAvNkZOMkJuaGsrbmhDRDlWd0FyZkxGTEwxbFpN?=
 =?utf-8?B?TnZQVG0yMFI5T2FycWgwaFQ4RnJYU0R4QVpYQmorOEhoci82dXlmSGZ6MW41?=
 =?utf-8?B?ZEVRblcxVlJDOGs3UXN6SjlsV2ovVWEvQ3BvVHVZVGVtODJFV2tKZ3pHQnh3?=
 =?utf-8?B?NzlCNVFIckJQVE5GWkMvWjhLY0QvYk9JYWFVelh0UW9aUXR0OTJOUGhwaEM5?=
 =?utf-8?B?NjJCcmhvQk1uOGJUZVhPN1V6Uk5Gc0ZIWVRjNVJGdEFBLzZpYTQxditjc2h0?=
 =?utf-8?B?RHpSWm94TjVacno5cGFRL0ZrNlFNTC9BZ2MwcFVSYzQrUDIyKzlGRklYSUNT?=
 =?utf-8?B?TUwydnBZRzdQZ2xNUkJyMENkVktPRTVLTGMyTWc0b1FDdTBENnZ6ME5jeUZm?=
 =?utf-8?B?RzRvNTFsanVDT1ZvcUZNWS9jbGJOd0Q2UElkS3ljV2YrYWx2Q1dnQ1ZJbk1q?=
 =?utf-8?B?Q3JSSlpVRFhFNVIwcXE5TDRnMXBWN3ZTUWYyYUVqeU1MREJUbGROcGNzTStv?=
 =?utf-8?B?S3RpY0U4bHFwUHE5TGZhOFlPWGxKT0JMZll1eFhQWkhOMnVncW4rRE1icnpK?=
 =?utf-8?B?VVRveWFLQWI0eEMwNmp6MDQ0Q2VtYlNacnp3N0ZzZ1h1WjUyelM4RTdmblhI?=
 =?utf-8?B?aVlFTW1ZdThJcjFUVElwUldxU3V3WllRcVJISHpYWWRqOVNXNENsTytrczFt?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f51d77d5-36aa-402a-da20-08db31b64917
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2907.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 07:05:18.7566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+Vt5J0kMWwv3hbsLFpdv2ESsq1by00gkqQF1V5l464afO9lvt7iyUc9phdqrt2TrcjJi+DCV8KJqG8NyVhyFkHO6muJ2wKzBsg3i6q20Tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8348
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/30/2023 10:49 PM, Lionel Landwerlin wrote:
> On 29/03/2023 01:49, Matt Atwood wrote:
>> On Tue, Mar 28, 2023 at 04:14:33PM +0530, Kalvala, Haridhar wrote:
>>> On 3/9/2023 8:56 PM, Lionel Landwerlin wrote:
>>>> By default the indirect state sampler data (border colors) are stored
>>>> in the same heap as the SAMPLER_STATE structure. For userspace drivers
>>>> that can be 2 different heaps (dynamic state heap & bindless sampler
>>>> state heap). This means that border colors have to copied in 2
>>>> different places so that the same SAMPLER_STATE structure find the
>>>> right data.
>>>>
>>>> This change is forcing the indirect state sampler data to only be in
>>>> the dynamic state pool (more convinient for userspace drivers, they
>>>> only have to have one copy of the border colors). This is reproducing
>>>> the behavior of the Windows drivers.
>>>>
>> Bspec:46052
>
>
> Sorry, missed your answer.
>
>
> Should I just add the Bspec number to the commit message ?
>
>
> Thanks,
>
>
> -Lionel
>
>
>>>> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>>>> Cc: stable@vger.kernel.org
>>>> ---
>>>>    drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>>>>    drivers/gpu/drm/i915/gt/intel_workarounds.c | 17 +++++++++++++++++
>>>>    2 files changed, 18 insertions(+)
>>>>
>>>> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h 
>>>> b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>>> index 08d76aa06974c..1aaa471d08c56 100644
>>>> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>>> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>>> @@ -1141,6 +1141,7 @@
>>>>    #define   ENABLE_SMALLPL            REG_BIT(15)
>>>>    #define   SC_DISABLE_POWER_OPTIMIZATION_EBB    REG_BIT(9)
>>>>    #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG    REG_BIT(5)
>>>> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE REG_BIT(0)
>>>>    #define GEN9_HALF_SLICE_CHICKEN7        MCR_REG(0xe194)
>>>>    #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA REG_BIT(15)
>>>> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c 
>>>> b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>>> index 32aa1647721ae..734b64e714647 100644
>>>> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>>> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>>> @@ -2542,6 +2542,23 @@ rcs_engine_wa_init(struct intel_engine_cs 
>>>> *engine, struct i915_wa_list *wal)
>>>>                     ENABLE_SMALLPL);
>>>>        }
>>>> +    if (GRAPHICS_VER(i915) >= 11) {
>>> Hi Lionel,
>>>
>>> Not sure should this implementation be part of "rcs_engine_wa_init" or
>>> "general_render_compute_wa_init" ?

>>>> +        /* This is not a Wa (although referred to as
>>>> +         * WaSetInidrectStateOverride in places), this allows
>>>> +         * applications that reference sampler states through
>>>> +         * the BindlessSamplerStateBaseAddress to have their
>>>> +         * border color relative to DynamicStateBaseAddress
>>>> +         * rather than BindlessSamplerStateBaseAddress.
>>>> +         *
>>>> +         * Otherwise SAMPLER_STATE border colors have to be
>>>> +         * copied in multiple heaps (DynamicStateBaseAddress &
>>>> +         * BindlessSamplerStateBaseAddress)
>>>> +         */
>>>> +        wa_mcr_masked_en(wal,
>>>> +                 GEN10_SAMPLER_MODE,
>>>   since we checking the condition for GEN11 or above, can this 
>>> register be
>>> defined as GEN11_SAMPLER_MODE
>> We use the name of the first time the register was introduced, gen 10 is
>> fine here.
ok
>>>> + GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
>>>> +    }
>>>> +
>>>>        if (GRAPHICS_VER(i915) == 11) {
>>>>            /* This is not an Wa. Enable for better image quality */
>>>>            wa_masked_en(wal,
>>> -- 
>>> Regards,
>>> Haridhar Kalvala
>>>
>> Regards,
>> MattA
>
>
-- 
Regards,
Haridhar Kalvala

