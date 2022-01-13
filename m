Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B23D48DE0A
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 20:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiAMTOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 14:14:17 -0500
Received: from mga05.intel.com ([192.55.52.43]:21810 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229874AbiAMTOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 14:14:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642101257; x=1673637257;
  h=subject:to:cc:references:from:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZHZx2wJ3HEuX2AjWtr7EIvGfXNX4wszlUBX/AI9y4LI=;
  b=jeJD9hkXa4m4zDwzWMhWSOS5xppybRhqXee5ON3084Cy2waveMe3qVFY
   ytoxwuhZkqbzEkP1LgT7MwIufh0l9VImqTTe6Nzk6VODEdMWppLj+mJ5/
   OkUDNDXh9ObnmMDES5UjR+ZPhKWLFZjHpRPdb5XSfFaCRbs6lCSaV739O
   V8sXtRNlX45v8FlwrRxjqCvk3AYuFuR5iBaMm24BwknUL+20whuqr0GKY
   HNkFXG4gcxwf3LP+mOW0QKErzoz1cP8Q4SWny19mWnw4VCShGyh88nxQ/
   +w+5Z81ks8rv4U9XL6H+VNOIxiGZ/gFaKM7GZ26kbPdRtf7qLNIbX17T7
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="330442273"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="330442273"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 11:14:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="529794538"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 13 Jan 2022 11:14:16 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 11:14:15 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 11:14:15 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 11:14:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTmR3XYKZ+iC7nAQVHhws4p+OxAlirxE3/1pa8AvKowZxZNTkEmuoihgwT+fl9TwRKBk2hIHG9kuMkkqNWKJWX4xT5hfjqCs/1qEo8W9Xo4g4xZswli9kyGYVvk727NVJxgVq8YlKYfC6PSRH1DDL+uzS7Y/TQg9Bv7kQ45sK2dmW6LISZettODIGZGS/T8jrGehOSEbSyUzYUMclhLEX5xke9rvfgjn1EisDznYLnGoUKpVST1Rmn7NbEtM8P0BQrePRzXoeP+0R+VspsBsPLitSNjhwm3H4pumcpevsvfu0Fn2n8d6ya2BMTlHunK1vOxhLVuk17bojhh38tz6yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NJdcef0KGtQ441siinj9th9VFQK16NBYX4aCVEe6Vc=;
 b=foAONKZ1+mIRQrzrNB1hniWzJe9Oh4tCHGa//u34j8XlLS6ZovdXVcXtE3dLj4qLCbT6EjKs2whv/JfgyLe5iDDkuPIXigZIqVNeoD5KCCL5k30LsoOh+UaYMDd6YMvTuc1QnC6i3VltIHMn4as8DCStiGfVrvx0lvCmfUHohFxPuvB1aFoV20sDjg8Pr7vE0QZfYAUZXeixrToLm4FXIckumrJrFMj3LpQ3wHYT1SvIrqQlZP2klntoA3kAHRxvjTG3zZL4f/uwai0ocMKNrbklONFBOjrKJO8fqeWhOlFH01tky4rh5wDFjwnoDZTIB4QH8zmgvLtO16Ni1kdOYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5711.namprd11.prod.outlook.com (2603:10b6:408:14b::23)
 by DM6PR11MB4265.namprd11.prod.outlook.com (2603:10b6:5:1de::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 19:14:14 +0000
Received: from BN0PR11MB5711.namprd11.prod.outlook.com
 ([fe80::e956:687b:f7eb:3707]) by BN0PR11MB5711.namprd11.prod.outlook.com
 ([fe80::e956:687b:f7eb:3707%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 19:14:14 +0000
Subject: Re: [PATCH] drm/i915/display/adlp: Implement new step in the TC
 voltage swing prog sequence
To:     =?UTF-8?Q?Jos=c3=a9_Roberto_de_Souza?= <jose.souza@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Imre Deak" <imre.deak@intel.com>
References: <20220113174826.50272-1-jose.souza@intel.com>
From:   Clint Taylor <Clinton.A.Taylor@intel.com>
Message-ID: <cc1c29b5-3d1d-5bcb-1647-e4bfa1c3d822@intel.com>
Date:   Thu, 13 Jan 2022 11:14:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <20220113174826.50272-1-jose.souza@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR03CA0123.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::8) To BN0PR11MB5711.namprd11.prod.outlook.com
 (2603:10b6:408:14b::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 578d3185-d574-4215-8ce8-08d9d6c8e313
X-MS-TrafficTypeDiagnostic: DM6PR11MB4265:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR11MB426503A34EB162E43D38FCEACE539@DM6PR11MB4265.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:264;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1n+wj5HUqKf83k1VGG7bLdKyRRf97bov/ltNS6Zg4JpF0XUNzeLvhJekHs+q8naiIfNXMMvqh21MhqsFIEYTAS8PmLQkN2oHHmHIsnufQPK5VKKmTcDCUu0BPACaLvWcrLXfaDG9lbHjF1qwfLN40SZfjAG0Rz8ZNf2l9x8GxskhEeXvjSvlG2s3ycX0OkPmkm0rf95nQ3H5H1wuynpWw/3VmwsoeCLuLRZ0KhIM+o7Xm14gGL5IktulREjZxqBntpuiddCuszxZDWjNRQs5ty003IHYdTv4p3RES/zjhnQ/9DHjcjOQ9u88aLzPisC0x/o/WGil8t7fDP4Dhzpf5Gm7nJph4ti9VxhqodYR5GsXmUFLQv56SVXbKRmWlbQYvTO7ck5JinhRUPEmUVfYD590ZO9jiCr8dY9LUhkvxdRMCDCi37C/CxtPjfnIr7zcBfSkQ4S3U0Ql0kLd2326BL0YpQRZGbxtld/3VnpCCRv5GSIRJqQ2buVWXVBbQ9R2m8Lj84kWA2cfnfcIkKN7UKNAEci0gwXDLIxXjsuGoInoZQwoGFJc8YEBDQvZxAQL8WjpgebEANbNoNE0lenKZDTDHDInSketzwd77ZJ0hv6k0p1X8FFsnXo0JhjmXvCYkSghBOw1d2Hq8ZpiNVJUQLaNJoPHzNpBZOxpsuYxUNYmrvBDVXIf/9225wg1N1JXlf+8hFSwUtYb5bmnBiBjH5XWTpw6IvpMjYXjN5WSxCE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5711.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(186003)(82960400001)(6506007)(26005)(66946007)(6486002)(8676002)(66476007)(83380400001)(66556008)(5660300002)(36756003)(2906002)(6512007)(54906003)(316002)(4326008)(31686004)(86362001)(2616005)(38100700002)(31696002)(6666004)(508600001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTJFVVcvbS8wd3d5cCtjRHAvOStiSjFoVkYySDJRT0FnSzY4MS82amNqQmtK?=
 =?utf-8?B?cFRLVlBkSnFJNEpERGdkUzJZRnlqUW9MaWRMeU5hWjVvTzB6SHdtSzc2VG54?=
 =?utf-8?B?aU5abTJpVGVRaVliUlNSbWtscXFkTzFFbVlnRzN2TlFTTG1aYkRxblZsb2VM?=
 =?utf-8?B?NlpGYXFCbTNPc1BOZCtrMUFIekpENjJmaVNCQXF2R3lmL0dDUGVBSkNsR0E3?=
 =?utf-8?B?WmFQbEVhYWV4cG5qVWp1YlJROFMxMGVIa0pVTUxzSFNGOU45djdEU1dydVZI?=
 =?utf-8?B?bTh6MTcxUWZKd1F3RGF4NlN4bWx1SzZKazBQNVViWWxHWHpDb1FKY1BicVFJ?=
 =?utf-8?B?akJ2WVJnUzBYYVA1d1pnV21SNVZwdTVGZzhKUHVuVWhpSGpkUGhYWDBhRk1x?=
 =?utf-8?B?Vy8zbmtGNHY2bWw3U0xyUTdRUU9aRTgya0hVN2luQU4vNSt1YWF2M0owWmdt?=
 =?utf-8?B?WDNkSUtaaGRXaEk0c1o1d0FrdlV1Q1NHQzdUY09TQ2p0OGJxeDRYOUlrM3Fi?=
 =?utf-8?B?cTlXbStuQnZHUjd6LzJZZmlhdU9XdmFhOWpkTlpIUFlYY08rQmlacjVjVnky?=
 =?utf-8?B?ZDRQcDdjck5WdlA0bEtvWm5qSnZGMElzYTJxOFRnQWhXc1FPTGxnMHVsM2E4?=
 =?utf-8?B?QWREWHdzWWZDaUViRWZ6SWdZTEJEZmNaVnlCM0JlMlErdCtUWjhib05xOUZ0?=
 =?utf-8?B?RCtGekJ6Q3FRU2ZCYjMzcWU5Rnp6MkRXREhxcHRvRW1SVDVSZVl1Mkc1N3pv?=
 =?utf-8?B?KzhJUmhJcHFRbFcwR3dDTHZTRVAwMUxDU2M0akNFLzNVTS9ReC9Ya3FaOUh4?=
 =?utf-8?B?NURlK093cFhYTEx5SGpFNjJTV1JEUFhSQlVPei9USXh5aEs4Rjd4bUpab1FQ?=
 =?utf-8?B?US9ZZFdVdWRvd2xKNDllRWJaRVk0LytoZ3l3SnQwcG1ueENCVjRnOTdRejVr?=
 =?utf-8?B?V1BGSEFhQW9rNEI5S2hENDNxRm12aEFPUnl3cFBOcFdvQnRQZjZIc0pZOW4v?=
 =?utf-8?B?ZEJWYU1HYThtamFka1haZnkxSndGUjVPZmdxOTRXbHJtelZOandhampLV2Y1?=
 =?utf-8?B?SlNtSm5rQVlQaHNtNFRuVVBoRVRFWWNpSllhdHN0b0ljNnVjRlRpTEtRTk1D?=
 =?utf-8?B?ZTE1YmdyZ2pKc1N2UGUvMWJkdGRFMmZUckc0aGhiK29selV1OGpjZDgzUmY1?=
 =?utf-8?B?SG9EcnYvRGlqNVQ4VjFCTnFybE5CVXJmNGxmZFFaUTdMRHVNdENJaU1NQU9o?=
 =?utf-8?B?LzUzZmlUQ2hYb2RpY1dPU1JldFNUdGEzV2puY2dGdzNvZUNJd2lmcy8yNEFS?=
 =?utf-8?B?bktkdUY4Z1lETkJRUEEzU2NkUUxPeXkzTURndEIxZkJEcUMydjlJbURCSDBj?=
 =?utf-8?B?TEN2TkxzZVJWY0Q1WlNQWW1vRFlsYWFkR1owUkxmUlVkK29DOEFLTjRlNm5K?=
 =?utf-8?B?VmZzcFkwWnEvSm9MeEZybDRtcW1VUjBXclY3MDRVT0NpRkYwRU5RNHNIbUZk?=
 =?utf-8?B?Myt3OGhld0NBT0d4aE45dU1YOS8yT2FGdnVlMER6QVM2djVEM3UzM0ZlbnZD?=
 =?utf-8?B?QUExeVFUMm5yZzhXMXdGc1pxL3g4NDRzdEJIKzRsSndTYk1LK2MrM0o4aThz?=
 =?utf-8?B?OTFqNGo2eWpSRG1YQ2s4QzFodnRsOENySXJUNzFsc0NvTjJsL1ZBazlxRE1q?=
 =?utf-8?B?eGl2K0EzdjM0Wk5RRHYydGdobS9PWmpOanZpWnpGMjN6OWNwTUZwMkI1TjlF?=
 =?utf-8?B?UW56MENCTmlLQ3BoYnNyUEVDSjdkaXFwSW5xQmxJWDUvWTJ3clF3dFBlaUJl?=
 =?utf-8?B?cU1UK1lTaVNMRStEdCtjd040K2UzTzMyNU1iNnRzSkEyQmtSZFpjaHl3cGRl?=
 =?utf-8?B?aDJudk82N1BpVWs0Z0pzSjJCemlNMU9Sd21qV0FhKy9ac1hhK2t1MVA3aGYr?=
 =?utf-8?B?SnhWUTQvdkxteDZRR1d5Q2tNYmZXT3pKblIxazVkRWVkdk8zcUdlV05nNXJI?=
 =?utf-8?B?NTZINDNydEJnYzBZMkJEM3JrQmliWkt4WEcvb01HRUtRMk8vWUVNS0crVHMv?=
 =?utf-8?B?OHlEQXo5YU9JZjh4R0t5UGFiV3lrbFZadGl4VWE2QzBjS0VjK3hiZ0Q5SFVu?=
 =?utf-8?B?WXhkdmV4MGYvMVFJa0dZNUwrRXNIWG5INGQ0WHdaUVJaVndCYU9DYlV0d0hw?=
 =?utf-8?B?R0NqTUVKNHlEQ1JtS2cvbDRBcnZrd0YrWVdycnh1UHkza2NZeXFKdkRWWWxW?=
 =?utf-8?B?bHVUczFVOG5FdHBRSzQ3VjB5Vnp3PT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 578d3185-d574-4215-8ce8-08d9d6c8e313
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5711.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 19:14:14.3335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Cjz4iz9N7q8u3RBSLutgXISRhms5CWNhIaZEECXRO9O4R4KUI2x2IyhHVrTMpq+1U5hHtAC+XyN7vidkF8HFzroyfHArsieFeiAOALE+wk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4265
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Matches BSPEC for DKL Phy.

Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>

-Clint


On 1/13/22 9:48 AM, José Roberto de Souza wrote:
> TC voltage swing programming sequence was updated with a new step.
>
> BSpec: 54956
> Cc: stable@vger.kernel.org
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Clint Taylor <clinton.a.taylor@intel.com>
> Cc: Imre Deak <imre.deak@intel.com>
> Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
> ---
>   drivers/gpu/drm/i915/display/intel_ddi.c | 22 ++++++++++++++++++++++
>   drivers/gpu/drm/i915/i915_reg.h          |  8 ++++++--
>   2 files changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
> index 6ee0f77b79274..4e93eac926a56 100644
> --- a/drivers/gpu/drm/i915/display/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/display/intel_ddi.c
> @@ -1300,6 +1300,28 @@ static void tgl_dkl_phy_set_signal_levels(struct intel_encoder *encoder,
>   
>   		intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
>   			     DKL_TX_DP20BITMODE, 0);
> +
> +		if (IS_ALDERLAKE_P(dev_priv)) {
> +			u32 val;
> +
> +			if (intel_crtc_has_type(crtc_state, INTEL_OUTPUT_HDMI)) {
> +				if (ln == 0) {
> +					val = DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(0);
> +					val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(2);
> +				} else {
> +					val = DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(3);
> +					val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(3);
> +				}
> +			} else {
> +				val = DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(0);
> +				val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(0);
> +			}
> +
> +			intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
> +				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK |
> +				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK,
> +				     val);
> +		}
>   	}
>   }
>   
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index 7c4013a0db615..ef6bc81800738 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -10085,8 +10085,12 @@ enum skl_power_gate {
>   						     _DKL_PHY2_BASE) + \
>   						     _DKL_TX_DPCNTL1)
>   
> -#define _DKL_TX_DPCNTL2				0x2C8
> -#define  DKL_TX_DP20BITMODE				(1 << 2)
> +#define _DKL_TX_DPCNTL2					0x2C8
> +#define  DKL_TX_DP20BITMODE				REG_BIT(2)
> +#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK	REG_GENMASK(4, 3)
> +#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(val)	REG_FIELD_PREP(DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK, (val))
> +#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK	REG_GENMASK(6, 5)
> +#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(val)	REG_FIELD_PREP(DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK, (val))
>   #define DKL_TX_DPCNTL2(tc_port) _MMIO(_PORT(tc_port, \
>   						     _DKL_PHY1_BASE, \
>   						     _DKL_PHY2_BASE) + \
