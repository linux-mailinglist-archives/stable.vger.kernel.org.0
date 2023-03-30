Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693546D103A
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 22:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjC3UoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 16:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjC3UoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 16:44:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2544B1116E
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 13:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680209025; x=1711745025;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E0eImVKhEqjJKWIKnHh3yrPK1SfiMYmPKo/+HAv37TU=;
  b=iABp5FaijvILYpMbLQ+hs4odtd0jih8sAX9mOKsLQAt3toCNz8VfcSME
   v2P/55F0czgB5lKJsNLCWdM+AVsmYAlBq4RhEqhdvLkQC1vt8wDIMp4Tt
   mWZs9dTZGldsVg12BciBclN7FSh80pHSssfOMo15kVYzkrT5dtoJaRgDC
   N4z+OinaRzgfVsFqN9geE1URYKPvNZHwgOzqNdf4FqAiE8IlbE8Ae2jC5
   rHhe19QlpQENMx9cuPApQMpeMUv6N4b7FuSztMax1njHT1dpF7h49hfCo
   KkYoypNwx24Fg60c1Fz1YEAhQqdsOvK6b4A5DHyyRmT/sX6URmupdPjhD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="321668292"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="321668292"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 13:43:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="635057426"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="635057426"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2023 13:43:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 13:43:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 13:43:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 13:43:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqVooEryJBdgX1rxaocpsO1YyglcbcYhkAXYDD3xw+6I4/yGZaCAW+WBuuwAW8Y+YlWaum9SmKsR7CB3zbNpZ6my4QACYOJHUAi1m5tGMhEhKalLGSc0AI1YUYdCbaCWD0QexMA+J5mibCV6TRBfGIfqBpXjuufQGgggFmkmMSgM7S8nta/6M0XlcWLS4wJZJw50GvDkly5Sptz6TCVu2VYyboL2NxCEffAoFouyWWJzI6ovYvHjXm2SbMMp8jcVsqBN1Aj+uZEPC9E6YiHxL19X5oxpmMGDfDeTE67pusAdb4SZsJFSHAw6eR1EZTMbev/qPdJV8oguSamNs+ZmBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYpZYarSyKc19J1GqhlnlV9TntxYLEc10wv+TOkhis8=;
 b=SpzaIzxEBLne3TNDY3g0nQhiTW+K5cyuTY0JtPc6DUdz3b6BnhephJ4Pa5O6Jv0hZg0fdKF3aoGyOg1NoslRUJhDyMAw/aWBhnXkS03DBQnrTXKhkTvF8T4lGgT97Uq/4eD7PbA/HMw5OV6eEQmO8VjxDazRYWIOXmjld6psQS1H2DUnwlrZVRyl6eiRUe5dWydX94yparTLiCTGlg/zeMKkikPzX4MmBB1m+MPozkt1pTptm/LlVRTuam0v9tVb5oF9O2sLwnggeQEq3L8iywl6O0LgV0tdd0XLY1bib260WAE/eun3k03sTNttPwF46pKAo6tVSguPIcsU8SpeYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN6PR11MB8146.namprd11.prod.outlook.com (2603:10b6:208:470::9)
 by CH3PR11MB7203.namprd11.prod.outlook.com (2603:10b6:610:148::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 20:43:06 +0000
Received: from MN6PR11MB8146.namprd11.prod.outlook.com
 ([fe80::a6ec:a0c7:4dde:aa7f]) by MN6PR11MB8146.namprd11.prod.outlook.com
 ([fe80::a6ec:a0c7:4dde:aa7f%6]) with mapi id 15.20.6254.022; Thu, 30 Mar 2023
 20:43:06 +0000
Message-ID: <b5fb0e45-5f4e-5e3f-6c7a-71ac78709e6e@intel.com>
Date:   Thu, 30 Mar 2023 23:43:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [Intel-gfx] [v2] drm/i915: disable sampler indirect state in
 bindless heap
Content-Language: en-US
To:     Matt Atwood <matthew.s.atwood@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
 <20230330174740.2775776-1-lionel.g.landwerlin@intel.com>
 <ZCXipYU8ULR6eEPc@msatwood-mobl> <ZCXlKkrKkvrG0T4f@msatwood-mobl>
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
In-Reply-To: <ZCXlKkrKkvrG0T4f@msatwood-mobl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::20) To MN6PR11MB8146.namprd11.prod.outlook.com
 (2603:10b6:208:470::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN6PR11MB8146:EE_|CH3PR11MB7203:EE_
X-MS-Office365-Filtering-Correlation-Id: 273d0286-9351-4d4f-1248-08db315f5d10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: er2qSdw0V5DLMtaR0pHdoumUbnXqvFgYlpORe8H6J1Axw9cQHZEy0hYoj6WbchokeBLwkhFxa037L+wOgqwmESHZIBi30fJvO+pB+IehUYLhennWD0USZT3vjDpq7mAaQCjP2XMkg4D6QmwWud597uQSOsahW6dn8ZmXrEqCtfDIJCjHm8u1o7/PYMzahV8MuFxUqRbUnNdkqoyVpMj4UvVKYFAt+REdpYsCXeSMwDHsWBCAULZspXib9PJBpI1aXjm9LZKsDyobB0TSrise7bIfIezobQwTJS9N6irhdyVBuVMycZmGim+pUkw3Lqd5IgSzx+y1i3hrAj1aXiKvMIn5mc9//fkz/O8Y1K9vFe/uU/azZz3c4+ZFT2+CQ1S0ZcMMnHYQo83ajlgJlcZJCKswQ3muvsEFjxCgrOzMbQwjdoiImYm1tjXLJvPxyg46eThKQ7fdl+y/AFHuYUwFsXa8YDgQcGrfmAJ3LtjBD5b/qq/3oKmdiZX3Vfj1ZxUQk5LD4nDcIMoOjmNWCJ5jXieTUJNC4zFXR8Tv3U/+OjEhTsGW7c5w4nfJMzjaHNckNVL6DR05IWxreWz6HCFL7mz2JhY1ZZfpWAfQpIOqS4HlkamQbWqZd2sraFWVAxZIpJgUS+tZrZnmDW4V8BORJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN6PR11MB8146.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(26005)(31686004)(316002)(6486002)(2616005)(478600001)(6506007)(6512007)(31696002)(186003)(83380400001)(66476007)(8676002)(4326008)(66946007)(66556008)(53546011)(38100700002)(8936002)(41300700001)(2906002)(82960400001)(5660300002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnI1d2RscmdaS3dldjZyU2lNMXphMi95M2pvTG53b2pzYmNYWFBGbnlHNm5n?=
 =?utf-8?B?QXFVT2RvQ0R2VEdvajNiZThYYVNyMFQvMTF3V04rTW9EYUNCVi9NZC9Ya082?=
 =?utf-8?B?RTBJMUdNeXNEaUJrQnZhcmRvc0NudmdJT2t4dEt1K2FNVmsvbDNneHgyRFA1?=
 =?utf-8?B?cVFaSE9FQnBzRTl1emU1QXg4QmNSYzBreUVnK2JhV3Q0ZWJraW9LdEgrTzBB?=
 =?utf-8?B?eHNQa3BCVTkzejl5ZGdXOFd1ZXRzZmRoQjJrVi8zMWl2eEo4NHpuSFpMNTNV?=
 =?utf-8?B?bllaV3Y1UllMWHQyRmcwSHVFVG5UZlRLRk9VWmdBaFgxRnZoeFl6S2pQZzRu?=
 =?utf-8?B?VVJzNFJpOG5VVWFkcHJvVGRxRSttMVZ4V0lOT3Rjc2FEMDdmdWZVMkYxSHhH?=
 =?utf-8?B?KzVKMXN1dDdlS1RDWVBsV2J5MHVpOXQ0b1VvdnU5MEpWdkFXbkxQblZSdDJW?=
 =?utf-8?B?dURIblIvdUhUNWx1RENzcTdiVForM1ppMWZHa2lRR3REMmdjZTloT2JSUGpE?=
 =?utf-8?B?UXFpVXkyZ2Q1ZDNNeU9yVW0ycjNMOUdodkxPNVlNOXV1ajhQQ01JVjNIemdx?=
 =?utf-8?B?bWtaZTBLVzRPVTNSdk1zTHhOdnhUb1V6RkZJMjBiNkYvcGVvVElpMEFUREZB?=
 =?utf-8?B?TndNT29tRUVoWmpQRWUrOVY5ckFMb3FJeitTS3hjNW10SEZuSFFCWU8rcklC?=
 =?utf-8?B?THhCdnh0QVdXVTdURGwvVVEyMEdIUWpXa0lXeXpHcW1QbldSSXZRRWpKSHl2?=
 =?utf-8?B?SWZoOVZ1QXBJVDZMT1F1TjdwaXE0T2pVT2hrRVZ5L2JQZWNkVU15b1ZzMHVl?=
 =?utf-8?B?Q2M0Mjc2VjlrVnFQUjUra3NaWDJWbHFkbkdlOS9hbXZnZ3FlbDY1Z09pUjZ5?=
 =?utf-8?B?WEVoNWU3WFMxVWdjUTdrZU54dnliQlE5N0ZMTDAycmMzWnlna1NSM2pOcEM0?=
 =?utf-8?B?SzAyVjBOOUU0SG1FaDBodVU4S0haK3BnZTEwbG00TmVoSnFCMUlEWXM3S1px?=
 =?utf-8?B?ZVUva2NpWkpSSkJWL3FiVG9LSmhNRVVUbVd0cExmUnBPMDlJbGFZZGVWUGdW?=
 =?utf-8?B?bTdyNE9saXZNMUZlVWJmTDRJLy9XQWdxclBCR09vdk9iLzhiUjM5SWRKcDZm?=
 =?utf-8?B?WjRvcTBrYk5SbHBCV0VLTjM4NjFRQi9PUkRYMXFJVjVlS3VaMkdydjhiRTV0?=
 =?utf-8?B?cFB1Z0VxVS9EMkJFNVFDdUxVc3kzZ2JLbDZFb3R3dzVZYzQ5TnJwamVEcElV?=
 =?utf-8?B?MHlkVnhNQi9qU3YvVlBFWGtxVVBrRVJMZWhMcWwvUnQ5Vm9RMmk5bWNBWDh3?=
 =?utf-8?B?Y0RUaUxmbHFyOW12OWZZaDlVYXd2dHp5NDVKZE12UVJRQzY1ZmNrYWJkYlFn?=
 =?utf-8?B?cU5WejZvWGVKVlBTN1VnSkRuNFR0eDArTXdRZTF0Tlo4MkQ3OGF2YlNYVi82?=
 =?utf-8?B?b21JakdBalhobm94M0svRkJZWHhYMWZzdGEyYkhMMXFFYVlIb1h2STlYY3ZH?=
 =?utf-8?B?cTFsS2F4K0pucHBiVW9LelFld3BkRnppYzB4Q0hmVWtOOTk2eEFmalA4bWQ5?=
 =?utf-8?B?TGlsRUluSHNVWnNLM2JwSUlyMGZXaUIxUENzOUpqazdlRGtRb3c3YXF2dC85?=
 =?utf-8?B?K204b2dzOE1iMWtPN3VTMGVkeE11R2dRc1hUSDZVakhJWndEL25vU0FEYlNO?=
 =?utf-8?B?VW5MczZ3L3hKN3V0WlZBQnFMOEhoS3hQbGRDamM4RmYzRGNhaTJuZnNjbnE3?=
 =?utf-8?B?dll3eUo4M2pqbnVHQ2VlNDN6MGJkWnBSV09TNmluakNpRTY4VG9XQUd3SjFN?=
 =?utf-8?B?cHNiYm1EVkFCakFVYnBoazNESm9jTzFiOW5RVmxyK1FmVWVMcTJINEdkUFZx?=
 =?utf-8?B?aDRBdW5Mb21Objl6RjdQSGlLY0UwbFhZTjdrdzI3RDdZRWIwSUEvVWJldXp5?=
 =?utf-8?B?aHRTVVZzUjJXalRuWmE2ZE1XbzA1TGdNN2hsK3dVbXA4Yit5MWdrMmtaYnZs?=
 =?utf-8?B?eWF0QjN6NmhCNTZsWG9ueUFCUWh3L1ZwRW01Z1VWazRUcWQ5K2tZTVhxdkx0?=
 =?utf-8?B?NUJLdVRFNmZyNjVuWjd5aU1SeUxzbWx2RHhzZXlVUU4vMlgzbjV5d3lWUDBN?=
 =?utf-8?B?VDFNMXo1UzgvMEpWdlJYdFRFTXA4bUU5ajhpNHBvRE9RM3BURHVuSTFFbWp2?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 273d0286-9351-4d4f-1248-08db315f5d10
X-MS-Exchange-CrossTenant-AuthSource: MN6PR11MB8146.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 20:43:05.7574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEYmcrKwOXJ5NwFnbcGCsPknh0uLOMJp3s1AiIIbQN5OxRHGzkfivxcMCK/hXZIE699CTbvN520LSDoBuNZulUbjikvFeWS3N+dbJS8e158=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7203
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

On 30/03/2023 22:38, Matt Atwood wrote:
> On Thu, Mar 30, 2023 at 12:27:33PM -0700, Matt Atwood wrote:
>> On Thu, Mar 30, 2023 at 08:47:40PM +0300, Lionel Landwerlin wrote:
>>> By default the indirect state sampler data (border colors) are stored
>>> in the same heap as the SAMPLER_STATE structure. For userspace drivers
>>> that can be 2 different heaps (dynamic state heap & bindless sampler
>>> state heap). This means that border colors have to copied in 2
>>> different places so that the same SAMPLER_STATE structure find the
>>> right data.
>>>
>>> This change is forcing the indirect state sampler data to only be in
>>> the dynamic state pool (more convinient for userspace drivers, they
>> 			       convenient
>>> only have to have one copy of the border colors). This is reproducing
>>> the behavior of the Windows drivers.
>>>
>>> BSpec: 46052
>>>
>> Assuming still good CI results..
>> Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
> My mistake version 3 required. comments inline.
>>> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>   drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>>>   drivers/gpu/drm/i915/gt/intel_workarounds.c | 19 +++++++++++++++++++
>>>   2 files changed, 20 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>> index 4aecb5a7b6318..f298dc461a72f 100644
>>> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>> @@ -1144,6 +1144,7 @@
>>>   #define   ENABLE_SMALLPL			REG_BIT(15)
>>>   #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
>>>   #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
>>> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
>>>   
>>>   #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
>>>   #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
>>> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>> index e7ee24bcad893..0ce1c8c23c631 100644
>>> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>> @@ -2535,6 +2535,25 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
>>>   				 ENABLE_SMALLPL);
>>>   	}
>>>   
> This workaround belongs in general render workarounds not rcs, as per
> the address space in i915_regs.h 0x2xxx.
>
> #define RENDER_RING_BASE        0x02000


Thanks makes sense.


-Lionel


>
>
>>> +	if (GRAPHICS_VER(i915) >= 11) {
>>> +		/* This is not a Wa (although referred to as
>>> +		 * WaSetInidrectStateOverride in places), this allows
>>> +		 * applications that reference sampler states through
>>> +		 * the BindlessSamplerStateBaseAddress to have their
>>> +		 * border color relative to DynamicStateBaseAddress
>>> +		 * rather than BindlessSamplerStateBaseAddress.
>>> +		 *
>>> +		 * Otherwise SAMPLER_STATE border colors have to be
>>> +		 * copied in multiple heaps (DynamicStateBaseAddress &
>>> +		 * BindlessSamplerStateBaseAddress)
>>> +		 *
>>> +		 * BSpec: 46052
>>> +		 */
>>> +		wa_mcr_masked_en(wal,
>>> +				 GEN10_SAMPLER_MODE,
>>> +				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
>>> +	}
>>> +
>>>   	if (GRAPHICS_VER(i915) == 11) {
>>>   		/* This is not an Wa. Enable for better image quality */
>>>   		wa_masked_en(wal,
>>> -- 
>>> 2.34.1
>>>
> MattA


