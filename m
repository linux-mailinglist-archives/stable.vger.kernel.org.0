Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81F24459ED
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhKDSsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 14:48:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:11636 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232418AbhKDSsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 14:48:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10158"; a="255416143"
X-IronPort-AV: E=Sophos;i="5.87,209,1631602800"; 
   d="scan'208";a="255416143"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 11:45:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,209,1631602800"; 
   d="scan'208";a="450545963"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 04 Nov 2021 11:45:32 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 4 Nov 2021 11:45:31 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 4 Nov 2021 11:45:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 4 Nov 2021 11:45:31 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 4 Nov 2021 11:45:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqZUQN1XGFVbw7TNC5jI4C971FWECJ01oasGHylN+gS56pUN9auNZ2zoNCqwwWnwlrdWhG4XqCPIp79vBAeO/kGXwkuNkLA56WlijmzaEATyRKaMMOhKxW9v2MMeEaQv9XEk5fVOzX4qyOQ7AzPbT2TdDNF8cwLZZSmHJtQuZLJSA4c7yJTRHlGXvhWarEgA6E02nip3FbHtdoBBfRR5wp0aBm+HsqqY/urSHk9wtso4mwlnSCnKUSTBobwcB+NiAQS37yZMEcOW2+p3bH6bxed4wd3KkEN0WUnb6dVwxq8cw4SBhMukIdIiwBAPUO97Xw2pwkzI7Oj+g2ysRAreYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMZbhYkpozSp/EYJKYj0Rsdbev5a2IiBom75V003YKw=;
 b=RK1IjalUcG8vEtjNuB4QuPhVN5X6cxorm2T6i0chB211mMM3cM8fnDPSt6tBlqt/5V93fs9iaFgWkZOgUadzrIHqt/mTy5Ye7XcVFALfbEAhoAeJEB5pmEYaEjcPm3xUZID76xPcOdG6btq23B0FvggWj2ce16mJipHL9J1M3v6MLoAQal1GjX3AmoLf/nuCAbLLzPQhLZ64cq2A1RrdgP+GAYOX+FnYlX/c5TGYJ4yx6eRM3otp7UIZCxgfsbL9rpTlsyOTTAU8vvMlIhFL8dz/SlyuVgbCALUEqhNVq0cbIo/sUWMyM60HHGQkprJ9/KZw0/XjtusQgo3Y9zj81Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMZbhYkpozSp/EYJKYj0Rsdbev5a2IiBom75V003YKw=;
 b=y8v8JaG4CdYiy7wOHY3P8RUt0nlwlIwRln+zcyiGOWjlCs9qaERKi8jdbpYqE2qE7uVNrv7sycQipr8gZ1ANy/SjhliK3xpC6hgqfQiJUcs6bul4yaF+uGQB4Jj27XOIDIEIVYqVsGy/wMsvnBBktA5e57csR/ND3RGc6sII4NA=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5740.namprd11.prod.outlook.com (2603:10b6:610:101::7)
 by CH2PR11MB4502.namprd11.prod.outlook.com (2603:10b6:610:43::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 18:44:58 +0000
Received: from CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::6956:8f27:7ee8:90e]) by CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::6956:8f27:7ee8:90e%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 18:44:58 +0000
Message-ID: <ad812781-af6a-102c-0900-c4277284f2ab@intel.com>
Date:   Thu, 4 Nov 2021 11:44:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.1
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
Content-Language: en-US
To:     "Luck, Tony" <tony.luck@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
 <9f96f71fe67042a89cd1a8f79a1840fa@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <9f96f71fe67042a89cd1a8f79a1840fa@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0055.namprd15.prod.outlook.com
 (2603:10b6:101:1f::23) To CH0PR11MB5740.namprd11.prod.outlook.com
 (2603:10b6:610:101::7)
MIME-Version: 1.0
Received: from [192.168.1.221] (71.238.111.198) by CO1PR15CA0055.namprd15.prod.outlook.com (2603:10b6:101:1f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 18:44:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e134c99c-0a2a-4ec7-ace9-08d99fc33379
X-MS-TrafficTypeDiagnostic: CH2PR11MB4502:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CH2PR11MB45027EC2D23D2C4D6561A42AF88D9@CH2PR11MB4502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TN5WMm6aq2XOX2FNAknwrfp1aSsIYKNXnxU/W/RP/JOIvsdxIWms0YyqjUHnOCgdAqg+Og/Tb/t7i5IrLtewdbB9zYbpAgDm941ZHTICco9AiLisDaWjo5KNV1YA6mf2OoMYvyAhPr8tYUWyNr2x1FRMC80+0u4ZK8uSHWU4uQo+hq3b8Zui6DA1eBZXIt57lANbjyj0KLbcVDtk99h8Apyaf6Nb4itrevF3I3/wT48T1yrl3hzxCYfKVbSF0R56/PEzTDmMSTbLL3yJJPtY7TE9XpN9qtaRlRODDL+X+Wq2VIc3WHLYiSv9xXU/e2bQvCSNAtKx358qspD1k0qz77PM75Dp/8HoFkO0lRn2gyzsEjXPawqksoSwUMQbZbU85Nq/bDqrqI86xQL0PI+Ix7uqCT7iH8O1yZLUGBo20NRiANwEcBVOQeiO9GjWmSOuDVRwOw7LCRR2gKjB6PMU8cIQqDktB75LjL0hoOBuS4TDMCbGUUOPVO29qAfw/rORw8xDOUkHC0xHVZ4fNmuXD9vHEs+TfzaC92vQIhPxFPwW94JAUd6pZ5G/0FdzN6DZnyQjm3d/dnFI3i4JZMXiv/vOEeCu78N8igDBdauxRy23zqljv6rotsJ/ykV2MxRYs7YLOEAAhw+PrWQRB/ro9De9wA4r2LVd8dUcZrSClaUhF8eIMvBo6b/FRtPppx4mbN+FtBMhLkQvnLnHp01GLdBn5Xtxay/URzKyrIrl+2s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5740.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(31696002)(6486002)(66476007)(6666004)(956004)(53546011)(4744005)(16576012)(2906002)(38100700002)(8676002)(66946007)(2616005)(110136005)(86362001)(316002)(508600001)(54906003)(44832011)(7416002)(82960400001)(36756003)(4326008)(8936002)(31686004)(26005)(186003)(5660300002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3ROVURmaDZWMHZNVGJScXJDcDRpeCtPWkRFNk00WlJNdTlvY0pidjVEbHg3?=
 =?utf-8?B?SFljRU9WQmp2M2VmUE1CS3NjR3N5ZE44NmlleHJPZitRZ08yMSs3cXh3Ny9E?=
 =?utf-8?B?amhxdEd6RTdFRGVzWXd3Tnd0UnJwT0hheTFEYXFCa1pjR2FrS21XUytHTFF1?=
 =?utf-8?B?d3lrOXROR2NCOXkvRHhYbFg5ZndDb0JzVWVvY2tCdHpEQndIalU4V0Nsc3JP?=
 =?utf-8?B?T2ZqcnFJMnJ3U1hWaXRzb0NiZVpWZEhaemZoSEc0S1EyZ013emkzRUNWTklN?=
 =?utf-8?B?NkoraUNPU00vWjQ2bTlac0VXSE5CVS9OQjhsMGVLRGNaQ0hGRGI4N2VXY2dO?=
 =?utf-8?B?N0Fldy9UdUdpNkw4aG5jZU5ibVFCRFI5WFpudW53S3FPaFN4RXg1enpEZmo5?=
 =?utf-8?B?WWkzVWpnY2dseTM0dy9OaXR0NlN6ak82OFhxcDE5UkJuMmN5RUNiQVJOOVNE?=
 =?utf-8?B?emJ3UW0xWmFkUW5ieWxRbEVXeHp5ZStSOXZ2c2YyWVZmQjRTVkxTSjMraCt1?=
 =?utf-8?B?ZmtqVVR2UDl0TjJHSlRkRkhpSFRqYUw5Q1BIRldack95d2ttSGJha2F6Nkow?=
 =?utf-8?B?d0o3TDNnY0FLV2U3Z01PY1RIaXlDeC9vZUN5TnNrVXBYa3E5REE1UnB1WjRs?=
 =?utf-8?B?RmRoMjNJQWZ0RHh3UFpMVklrOUM2WFFqYTdRMDNiU0VWeHBQcHl2VEEzWCtw?=
 =?utf-8?B?MFNyVC9WMHVMSGQzNGtmVVJ0bk9yNUlyYVFDTnVOQzIvNmxoYkY2YUhma0Fn?=
 =?utf-8?B?TWYrSWVtN0xYR1NqNW54cDRqWXB3R3J6OTN6TmNCVlRpR2k1bkVVbnpuNjhu?=
 =?utf-8?B?Wkl6VXZ1ZXI3eUtxdmR3R3BtWVBDS2tJWnRlelJwZ2RIa2NmTGJBMUo2RGV0?=
 =?utf-8?B?anpCUUtWVHZnSEJwOHBUN29lRk9udWVsOW1xVUQrUE1oQWdHcTgyNSsyeDVH?=
 =?utf-8?B?bHBTYytaM21DT21pM1hpbkdUQXJUVWJzY2NlRFVHdUlycHNXVnRJVTJkVTJS?=
 =?utf-8?B?YlhlL0FiaTdMSjFYdnhkSEord0RrREVpSUZTZVF1aHUzc3R5b2R5Umt2UWhU?=
 =?utf-8?B?L3F6U0d4NmNFbGw5a25oRGlXN2QyS2k2RW9wb0lzR01Wc1NHbG1ySnRWYTNB?=
 =?utf-8?B?Si90dTRUcXh4bi9uTlo5Q0pSMldJRDZPUGQ0WnBwRFhUdVdCWllBT1FKb3NP?=
 =?utf-8?B?UE5kbVJYVExmSTh2UDRmeEptT0daMEl5WHRZRHFjazhHZGpDSHlNcmNhMjZx?=
 =?utf-8?B?MG9ZR0xOUitBck9UWXUrdjJ5cFY5azZVNGJzM21iZVYrYWpZbFVtMlVnanM5?=
 =?utf-8?B?SmZYazVoaWtiYWlZMWR6a3Z4dW5tT2hsT1lzVVFIQ0lYcDI0ekJqaVNINnJC?=
 =?utf-8?B?djJ3azh2K1RUV1VQTnVLQW5GK0N5UklBSlZLMUl3YURIcHJuTVhKcWphRUFa?=
 =?utf-8?B?SDVqcDV6RjVjeGVpSTlsZklrcnByMWtCMm1HbmYzbmJIdXozMmRpNkJQYVF0?=
 =?utf-8?B?bmtQNlEwZ1M5QTNqR0htWVFRQS9aa3ZNYVI4WDlUVkFIRnVGVVhpNDRtU21F?=
 =?utf-8?B?YmNiN2dJV3ZYcDZSVmhySmFXTjM2YWtSNm5UOG5TSUZZeEpIQWkvZWJJOC9O?=
 =?utf-8?B?SUVmcy9seVFicnFnTEUvaDBSZkU1QVhtQzcxWm5qMDhRTXlObWVmTWdnNk55?=
 =?utf-8?B?MjVjSEJiYWJyTXNDY095T2tDWEl4eE1ueGp6a2hJSzhqem1FYVJDMjlhbTBu?=
 =?utf-8?B?UDFwKzBIa2JOUDBnSWloMW5aV1hBYkFKTHVhT251dCtYbk1wVHNkWkpWd0hn?=
 =?utf-8?B?bDBzVlllMnJXU2xOc3RvbDJZd3hVU1BCNURxdWYxejJnK0RjSXNlQ0dUREdT?=
 =?utf-8?B?dkdQRkJjM0o1Z2dGdDZUUlcwdDFldVJMY21yQ2cwSFMxZXExWGs3K1lVNU1t?=
 =?utf-8?B?UGt5WUI3SFN0NDhrTUxvKytvVjFIMTFsTTU5dkp6ZlUxbTREcHY3MStVZytV?=
 =?utf-8?B?cTdmMkVoL0dHcFh0aTFtV2Zna3lHRDdFRUhOdEU1TDFFVzhuWFJPd2lFckJZ?=
 =?utf-8?B?Y0ZLdTRkd0lOV3U5Yk9WanB6cEpFTjNvRXJPMVNqbHdHNzN0M1BlbUFrR09m?=
 =?utf-8?B?YnhpbU9PNnR4am9FcUZlYUZFZ00yeFRoME1YWHdQK2VzNHJnaEdhQzRGN0c1?=
 =?utf-8?B?UjFUTDNmelMwNlJobm1FL2kxT29tcTFqbDZuakVvV0VrSkJ6TUZqWTJxL1Jj?=
 =?utf-8?B?YVQyL0Ywd2N0azRhT1lWM1greEd3PT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e134c99c-0a2a-4ec7-ace9-08d99fc33379
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5740.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 18:44:58.2369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wIv4Kk3JrMGbDCfUKCAmM+o13ieLEyJlLqfbPMmLPnyg0Dkbmho96eLgxsu6ZIjhK1lEebi4O/4TUGJxRy0Dxg0x0WYVBRngRldDTAQDUUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4502
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tony,

On 11/4/2021 11:36 AM, Luck, Tony wrote:
>> -/* The free page list lock protected variables prepend the lock. */
>> -static unsigned long sgx_nr_free_pages;
>> +atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
> 
> You accidentally lost the "static" here. This is still only accessed within this
> one source file.

Thank you very much for catching this. Will fix.

> 
> Otherwise:
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> 

Thank you very much.

Reinette
