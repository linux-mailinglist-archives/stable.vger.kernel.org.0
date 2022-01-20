Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBDE495254
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 17:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243956AbiATQ2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 11:28:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:19256 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232075AbiATQ2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jan 2022 11:28:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642696124; x=1674232124;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rzk9LcBlZAXibW7NCbTeCgQzNaWoJYGP9QvJx/atpIc=;
  b=Mz6IAD7dncghuFFQp83Mt6aovEyh+AgJ26HUKe/e40gTjnVmlUPpDVbM
   XAF8VvXJzCJ7TEt2CpzEE69MKkhMHPv4SMf5P56qhqOTzSzNJKL5UI7BF
   LOqji/CNlNQzfy34S4ltYMIKX8IlQ67IUHdd0SfTpYc2nPcip5380Nvwq
   KyPmTfWpZ94Tgh8xGTinqAcmtC2NxePFLYC7Q0b5454vx3a95/aX9C45g
   +yAiOo0glgY43/gM7WhwwxiiKwQPqH3IDC1DjTM4GGW9jsnrvrn3B5jEG
   v595dcWuReQAxAo3Dj7byRnF1SwQQkGvEHUSzj7qaGQ1bYGHQY0zuUMom
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="226066963"
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="226066963"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 08:28:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="672580940"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jan 2022 08:28:43 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 08:28:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 20 Jan 2022 08:28:43 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 20 Jan 2022 08:28:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSpfl3PGbHi793OKvZrdk7PWRN5NnHB83vqFWxdcUojKwdVYc6+qwEbv2kPaANa352CLQ0vEjw0Eon/Q60MGGV6B5Ki/DzJydTyvkqExU0KuwzMRpx3+PY7yEGkM81TwuvjltWFtb9lh42khTxdgYR5/tnD+KTSZHUNAyPYOeYkar/Zck7J2ibhTRfTw4oi8zXsqZvpKhMF6e2SPAEyreYYnwAtf+NIQX4tzOGufSBOYTt9qqh5VpFNTcriH6lM/BnC8CgL71XFD7vwqdV3z58IbwbExaXGYPKDt83ANBM3zYbjZcodT7Zl/8ikFwbH8XXRjYFPtf4bCwBbhnau4yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zolg9M6qyvTf0dvcZEHzl1kipxbvme+4ovCbYYqnk18=;
 b=f3sDaD6D6swK3b0bgS2zwRAmkBODZsOoGpahrfJqupZjmnecT/WmKaTox5AmC4RTwu+rq6sXKllUr4Ptg7uiUzS97PJVvJFuAxFLpqpSS8VEg+dSlIti9dUWU407ocqn0oplXV4vLFO/xdKuZ9f70gnx67JGcmIqClouEpXKwbokM8NlbJL+cdIJZh9Pr1ESWGLxzVw8kIVYoTYGwt3GhhRozf3ngGdMBpPT6BT2068ZOnomvFNeRKpTfDa6IDMlRj55HqQtojtDHiu0JhvNMAeI2Qc70mu58x5pFCrWRjmhR2bSBu2p4xGsmqJ4jDLxnc9nrFbJFYxjJFhyCSo6Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BY5PR11MB3911.namprd11.prod.outlook.com (2603:10b6:a03:18d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 16:28:41 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::a113:192a:3201:1e0]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::a113:192a:3201:1e0%9]) with mapi id 15.20.4909.011; Thu, 20 Jan 2022
 16:28:41 +0000
Message-ID: <71032a38-e1ab-ac73-09f7-9eefffd53674@intel.com>
Date:   Thu, 20 Jan 2022 08:28:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH] x86/sgx: Silence softlockup detection when releasing
 large enclaves
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <dave.hansen@linux.intel.com>,
        <tglx@linutronix.de>, <bp@alien8.de>, <luto@kernel.org>,
        <mingo@redhat.com>, <linux-sgx@vger.kernel.org>, <x86@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <1aa037705e5aa209d8b7a075873c6b4190327436.1642530802.git.reinette.chatre@intel.com>
 <e4e8fbe757860cd24e2f66b25be60d76663935d8.camel@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <e4e8fbe757860cd24e2f66b25be60d76663935d8.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR22CA0061.namprd22.prod.outlook.com
 (2603:10b6:300:12a::23) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bab4e46e-5550-42cb-e534-08d9dc31eb31
X-MS-TrafficTypeDiagnostic: BY5PR11MB3911:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BY5PR11MB3911D22E174EB0FE7C0422A5F85A9@BY5PR11MB3911.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Djy9Fl8WIziiTaXVyJVUW0G9pM5dtnvs5Oee9Q5Q4MP7xUsyFh08ANEv0eZhzZMoAykTtqaVJDILEm6u6JhxzEWMhBCe4VKpzi3VkFLSDlyY9IM490FEQdKsCeT6uMXpzo/Bet86wWznivMcQlWudGFn/jh6r0JVIDcQ+eCWS86gAp6tFzPIFjVd6cCz92yljBCs85d+mZXhTqRA7Q0U+yY4YX2yQxzSOFGGUOdzY+TnaJpu6QgaDeNiViJu3Xtik95yOTqPYxaHlOK5ppSWMLLCHBHx4zf7xiK/EGzsogaVRmouV1KPBEowK0fpEDRyXPZVTI+3/NnX8v2oWG0Hs1FXWyKzH0SeJNc4I7gygLobjVU8deXrY2DLjNlgkmxjeWlySsj5Gko/tPQXLPucB7TlLueZykmFvMKBuOwvhgeWaGoJEi49LpLXn//5xBP8wNfBKwWKoBVI2v7pukLL9pPs0g3ZAZpUPAU/8vQLvfYAeEQ3AODek7mcjPwc8jcyysCUEnqkjONV7AEBVW4Lqf+oBJMSLJkyJOfZO9vMklQ02dnQA87w/bH/ib4LyiN78/lyDCRtT25FX2Llp9WQHufIk12QVlz7jzOOEzhko3z6EkHrIhzItuGILYbISM8XIOh4LWUow4WQlQ2qK5vUlisDrfx1/MpeSCoCBEuT5J+TF0bc+SM0ykk8jDQnASBAvwiQn4VQ94hv1Hq7plxEkrCi69uDrM5HM1eKMqMwtWtVF5540FOT/YVU7NswhHS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(86362001)(8676002)(31686004)(508600001)(36756003)(26005)(186003)(38100700002)(66556008)(66476007)(316002)(6512007)(5660300002)(4326008)(7416002)(2616005)(6486002)(6666004)(31696002)(2906002)(82960400001)(53546011)(83380400001)(6506007)(66946007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U28yMmR2L0NoNGY1UmVNYnNHWTFGZ1p0R05XWHV3bEVISFJkMk44bFhGamRs?=
 =?utf-8?B?RWkrNG1wSXpScXE4V1Y2Y0VzMEtodUEwdTFrK1RIcUEwZkdqVTZRanMrY2tv?=
 =?utf-8?B?SXFvWVJTTFdiRVpvZ0FzODRpVU04NXRWeFpmOVFMWWxZbWI5QlF5WitOQjNB?=
 =?utf-8?B?QzBaVEd3aGhlMWlSUmpMSm5xVDBUdW15eXd3QXBqaDJrb2pMYkxlZUNOYlBz?=
 =?utf-8?B?TnRiMEo1WE5taWo0SjFBTTBUdE5BYkJTcVRjNytPZGNVN0h6UTFNTEY4cW50?=
 =?utf-8?B?UnVjZDFKZUNKd0gwTmJLV3QwcFRHZ0JOaW9tdG8xemo4WCtmcVVQc2hjNUdX?=
 =?utf-8?B?TEpldlhTVFllOTlTWVFzTkVVNGlKM0JiellyRXZSdFJ2eWxsMXRodjgvQXdv?=
 =?utf-8?B?Qmt4T2JzbTR2d1dtcmdZZytuMG5JQ3IwOFhuWmQycm1vcmt5TEZDWDBSWXNW?=
 =?utf-8?B?SHNQRm1WVEhEd1JKSzQ2ZFQwOTI3T2p3NUpOWGZXbGorNFgvS050d0pYUGsz?=
 =?utf-8?B?bEJLMENTNkFnSHdaeHVaUThmYVlpbDI4cTJxSE51TTVVQmtEQm5oVXd0SGFK?=
 =?utf-8?B?MWhJK2JZNk9yRmxzT0N3cmNNQmRvbm9ac2lxTVdXZ3RreC9tS0U2V2ROQlhL?=
 =?utf-8?B?S1N3eld2WjJuTWl4dXZpQWRQeGx3eUg2WHQ3cWdFREN4NHRtc0xFM3lnTmZT?=
 =?utf-8?B?UHRGUDJxZTREbDhFckUrMWJTWGMwWU96amtsV0kxVjhBNnJaQjhwRjV3aHNU?=
 =?utf-8?B?Y2IydmVWVTJ5d0RZRHU0dkxRNHRFdmh6MXpSb1ArYk1SYUQ4d0paNjhrVDd1?=
 =?utf-8?B?Y2pVaXNxM2Jlc0RCbEk4NXZDUlpTN3R6RVlCdjJ2MU01Zk4zY1drcmlPQXJU?=
 =?utf-8?B?T3g3cEZmbDRNa1JZelk4WkFmT0tSMVlDdE0vZGhTMUtLS1RYcjN6bFM3ZzNt?=
 =?utf-8?B?ckovNTc5VEZZZWFMUkt6VEVLT3g2aXRONEI5OXEwekVrUWpzWWhQOTUzQXZ3?=
 =?utf-8?B?cHNiRTRGbTJ4QjIyNkxuSUx5eTY5WU1YTmdLS0VRR1FSbmJZUUF0UFl2bWZG?=
 =?utf-8?B?RXBNQkovNG56L2lxdDFUTzRlN3NsUzR0N093dlJpekdNeFVLWkwvVmRWSFJl?=
 =?utf-8?B?WjNWejVkRmJ0S0Y5OTZRYmRnbWtLWGhwWGNiZ2VJN3dBc0FndXg4Umk1RmRB?=
 =?utf-8?B?WGo3eFVPN2Z5UXFHSkRRQzhiT0pTTXVVVUFZODMxcFk1UnUwQ25kRFYvUllj?=
 =?utf-8?B?cjNFTGRUM3UvUURkeU1IRWp5ejJpQWcyU0hING9zT1lDM0ZWUkQxendlNW0z?=
 =?utf-8?B?bWdvd3gwTUhFSis3S3ZqeEU0Q1F5aVAwYTdERW5YZkJ6eStWMkFsOU92ZSts?=
 =?utf-8?B?MmYxTEtKM2NMTTQ0Z0FsNGNianlHbXQ4Tm5SNlhvbGRucGo1MlhMMmdncEZT?=
 =?utf-8?B?cUtJdEJneElhZzRCWFNsVzdWcFduWUZWK21FbWVYckRjYlVoaUF4Z3YzeHpr?=
 =?utf-8?B?RHRNYmZ0RU13V1NqRk94S0xpUVRXVEJVeW9JU21nb3VzWnZlVGZLMy9ZNUls?=
 =?utf-8?B?c2JYcWkxb1dRQmIvSkNPQUNhaUpaM1VST0NhY2ZkMUVZL3p6RWJVOFZWU1pz?=
 =?utf-8?B?TVNSVGY3UTVYSVJuYXJ6YWlLYnh2UW5HUi9vb3g4L3JYUFNBbEtWM1ZBSHJq?=
 =?utf-8?B?b3hDNnBzZFROcld2S2NCVnNRZHJWeWlQSGdSMVlZTkNpNVBTK01YTFdjQmlK?=
 =?utf-8?B?K0h3UDJYeTErd1AzTmtYKzZrakFQdmNHNWo4VHdUK1Zwdm1ZcHc4TS83VkQ0?=
 =?utf-8?B?Snk1andOaVNwbTRQaVJ4WWZxMU9RWjZTQ3lpazZLdkZhY0tZT2xmbmFZRjlO?=
 =?utf-8?B?cXBYcXJPM2ROZzU5VTFyMm01SGx1MExnSGNvUnNmaEYzN1NGcXVUbDF0MUF2?=
 =?utf-8?B?ODNRb2Z5dyt1bit3NnhiN0VQZUMvRWZhYnpMN2J5ZTlQMkM1Ynp6Z3ZOYVlr?=
 =?utf-8?B?QmJMTGxnNUpJUHBPdk95M1VXOUtORWRINXc0V2NLQ01CNVY2RVd5QUFXVlQw?=
 =?utf-8?B?SXBkcjZyZVBmc0JLZlFCRFE3cm1aOG95bnZ4ZTNNOHN1U3pCVnVVY1Z4QXJO?=
 =?utf-8?B?cHBla002Zndua3p3YXdDV1FvcmNhcitEZjRvLzJSQVhaTzArei82K1cyYmRy?=
 =?utf-8?B?MkNhRjBwSTZZU3ZCOXpKSjBPcUxrS3BJS3VkdGpWQUpXVmhCdlRRL3pRdk9R?=
 =?utf-8?Q?+o834+boowQDrlGirP6cAeyHDQtCmAp5imXOBIVMSI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bab4e46e-5550-42cb-e534-08d9dc31eb31
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 16:28:40.9871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwhv+MJWQqOjmIEuIP/9aaiiDx9+WyIiGw++WPbKkBKT2KGWINHp4cB6qcgjkVF7pitc96vxkmEnIIahfU5vc4dewz772+RKeIUNcTfT+HM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3911
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

On 1/20/2022 5:01 AM, Jarkko Sakkinen wrote:
> On Tue, 2022-01-18 at 11:14 -0800, Reinette Chatre wrote:
>> Vijay reported that the "unclobbered_vdso_oversubscribed" selftest
>> triggers the softlockup detector.
>>
>> Actual SGX systems have 128GB of enclave memory or more.  The
>> "unclobbered_vdso_oversubscribed" selftest creates one enclave which
>> consumes all of the enclave memory on the system. Tearing down such a
>> large enclave takes around a minute, most of it in the loop where
>> the EREMOVE instruction is applied to each individual 4k enclave
>> page.
>>
>> Spending one minute in a loop triggers the softlockup detector.
>>
>> Add a cond_resched() to give other tasks a chance to run and placate
>> the softlockup detector.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
>> Reported-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
>> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>> Softlockup message:
>> watchdog: BUG: soft lockup - CPU#7 stuck for 22s! [test_sgx:11502]
>> Kernel panic - not syncing: softlockup: hung tasks
>> <snip>
>> sgx_encl_release+0x86/0x1c0
>> sgx_release+0x11c/0x130
>> __fput+0xb0/0x280
>> ____fput+0xe/0x10
>> task_work_run+0x6c/0xc0
>> exit_to_user_mode_prepare+0x1eb/0x1f0
>> syscall_exit_to_user_mode+0x1d/0x50
>> do_syscall_64+0x46/0xb0
>> entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>>  arch/x86/kernel/cpu/sgx/encl.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/encl.c
>> b/arch/x86/kernel/cpu/sgx/encl.c
>> index 001808e3901c..ab2b79327a8a 100644
>> --- a/arch/x86/kernel/cpu/sgx/encl.c
>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
>> @@ -410,6 +410,7 @@ void sgx_encl_release(struct kref *ref)
>>                 }
>>  
>>                 kfree(entry);
>> +               cond_resched();
>>         }
>>  
>>         xa_destroy(&encl->page_array);
> 
> I'd add a comment, e.g.
> 
> /* Invoke scheduler to prevent soft lockups. */

I could do that. I would like to point out though that there are already
six other usages of cond_resched() in the driver and it does indeed
seem to be the common pattern. When adding this comment to the now
seventh usage it would be the first comment documenting the usage of
cond_resched() in the driver.

> 
> Other than that makes sense.

Thank you very much for taking a look.

Reinette
