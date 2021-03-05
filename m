Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B08D32EE3F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 16:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhCEPS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 10:18:27 -0500
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:36576
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229517AbhCEPSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 10:18:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxrbVcqw1lEMFvL/nu0pH7MLZ9uAukVM/VMIXBLS6E8Z5tT8zVDiFTh5S2oMURNh9ojMFZgteXOFMJH7TDzwXA+tDT7MLwQxrXYozOYXdVlTkCmnqPprifpZkDYoGCYUAfgZTv5vCFd/DEUrl4njJ+d9rosFgpfunVQaxkYcLLXPHAwGoB7TL1K2XXo+hgUxYqjapU2+RlE4QySqbrw0DB38CSpNFtETF3eBIR2sMGWkF+ZM0+CrDHHb/gGDDEmGOi9DIUwB7ZwRdvA6LqTn4sOtorAxU8UPzLgqLBxpshJ5+JU+9BXqGKtbglG0uvFOU5/5l1cCvuHxyd5UP9em8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xl2VytWn23t98n1JWJtkhCegNPPSkA/LTLR4d5w+gDs=;
 b=RHwmZP+2Bpl/QtwERsfsJLAXjNPEncJtaZnd0B1wXPFY6Lnp7cuKzbIPc+BzKQA0Yyq0lX3jXxYLl+yl4/GKhK2uzNMI61E/ng/FdZb6U71VGtVEAUNa20H4XhoMWQXVkBH6MDeaEVziwhomR9v4udT16N33xDPp0Afix8elKuH9AcL4e8MpvnbineQufWknjZI+3owpflFidgwtngCLm5VdSMgoafFofmgAvpoPbenPPc/3kX86M34DlvtrQx0bZsNtLxmE/luhupiZLDDcoWvhyObbmoQr75Axrmp25Mtq78iwziBt/INMDQ2NGkdXhSzOofJ79yScRbRY3S9pTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xl2VytWn23t98n1JWJtkhCegNPPSkA/LTLR4d5w+gDs=;
 b=xgy/R2Debt2RLDwINPOI44A44azqCfzW1zLIyLWwrSj6h6sx05f2cqKyqTj1o7MWGmanQmYM5KIC72wXfPEbD5pWwtTo8GYB8k17X0f/tbFtRf1BmrWYg59RybNXGasro0z6rXl1TvRAIM2pJ6fqypy/yLcGTODP6rBkzEPhegU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4848.namprd12.prod.outlook.com (2603:10b6:208:1be::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Fri, 5 Mar
 2021 15:18:06 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3912.023; Fri, 5 Mar 2021
 15:18:05 +0000
Subject: Re: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
 compute queue
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Das, Nirmoy" <Nirmoy.Das@amd.com>, Sasha Levin <sashal@kernel.org>
References: <20210305120903.166929741@linuxfoundation.org>
 <20210305120907.039431314@linuxfoundation.org>
 <23197f54-020a-691c-5733-45ce7e624fec@amd.com>
 <MW3PR12MB44918AD858505706809367F3F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <9f12d4c6-35c8-7466-f1bc-bee31957e11b@amd.com>
Date:   Fri, 5 Mar 2021 16:18:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <MW3PR12MB44918AD858505706809367F3F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:ee4e:e545:33e0:7359]
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:ee4e:e545:33e0:7359] (2a02:908:1252:fb60:ee4e:e545:33e0:7359) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 15:18:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 31d79fee-dd7d-4d6b-28c6-08d8dfe9e041
X-MS-TrafficTypeDiagnostic: MN2PR12MB4848:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB4848779A372A8187234186F083969@MN2PR12MB4848.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o/yn5E7labMhwtx5ASw3VAUnefjRWhJjksUgxnWXiQMJp1gUbZZpyIrnHMTRB9BCe6uDSikW+4mmOeJ4MVj+81NddXKArG56m7+5AErRkW4zaEa/Pa5tmzkStBWgDTkl4/zMjk/8jx9JxXbfMjuGzRNglnDSPNH661A8mP9CiwQiqO8L6MVsE3FIdzQoApZPTYZiJmHv66VlbdqL1pGShqdbkEz5DiMIkn9bTcP6G7y2np6HncGNC06xYs/ch/bwleqDz0BMU59w8Hk6iOZweIwpgPdDkU2HKWXJf+mfEyUc64LhkWBIKOR35eU4x8U01YmrfQeDq1TPZIU3NYTwfRCwxGIYYTgGIPA/oBz97D/cQ2Z9e5lpleJL+N7u/HQKrc4Ma4sGUG1diEwhXGCjrq8B5aZitYJ9YY+nvfR2sJXCrRi8oKNtMLl/JG60XAeoufXs5QUlO+IAtDnw3WncsWWFm6kMGg08t8v2L/7PCG2F5hPHwdik7L/Ut27wUt1ml0SpnZL1Lt1uMv0zRCIPotGvSITIHcRlBT5VLEBsbGLInD4o3G1ift1I7itBooQ8x3o/io2Sbom8VU9k+9uYl4096DAG1N6KrNHD60KH2N0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(83380400001)(53546011)(31686004)(4326008)(2906002)(478600001)(2616005)(8936002)(6666004)(31696002)(186003)(66946007)(16526019)(8676002)(86362001)(5660300002)(66476007)(66556008)(36756003)(6486002)(54906003)(316002)(110136005)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d2x5QTR1T3YwODgrTUJzOTNWMjU0ajJ2OGFhWGluWXhXTGR2RVZVQzBuN0FF?=
 =?utf-8?B?Vkk2Y1JIeXF4clZaYWJyRkxVU3dEQXFBRzFVSzBZMDdxckhnTkUxYU9WZEF2?=
 =?utf-8?B?OEN3YVplQkd6NUt0UDlMb2ZYTlRRUk95ZGhvdWM2Q0tsK2g3ellwRXBQaXRn?=
 =?utf-8?B?aURwY0I1bUdjODZZcW00WGlmK2hHZjVSTktHZDk0NERQMDVnc2JLejFHMXN1?=
 =?utf-8?B?akV3Y2ljUmx6dVczNExCUXNycWM2Tm5HcFJLeGxwQ0Q2UXpSTTFwWnRnREdQ?=
 =?utf-8?B?MGNUTHMxVk92N2l3b012a3FZQ2gwcmg5ZHlLdDVXOHdFbUlpelpObUlTalJR?=
 =?utf-8?B?SU1pYXBQVU1HRXRMVVBoM0ZKSzZua3kydXJQM0RpKzViT0hIWk40OXVBbEIx?=
 =?utf-8?B?R3RCR2c2K3FGNDBuNGt3bXM0azFqdlVlZWF0a1lCN3NOQmNRcE1pakFpWCts?=
 =?utf-8?B?Nkt4RjZiQ0V6MDRGTHFsSzNpQjg4NFZ3ZktZbVp0QnVwQmpDb25DNkZKalE4?=
 =?utf-8?B?MFlvb0JrOWdzU1pNV1J6VHZrN2xPWm1lU09oWml1elV2ZXdLUVROQlFQUSt3?=
 =?utf-8?B?Q2htaEkzeExWV1pTNTBKN0VMS0daOTJGZm1jR2I4bUI5VVJTUmFrUXVqMkp4?=
 =?utf-8?B?Ni9aZFNNL29IRGlFdDl3ZU5xV3ZROU4vOEhKc3hPUzJPRWFqSmk0SEJMcEVS?=
 =?utf-8?B?M1RHR1hzZ096Mk1kVE9wRHZKUGRuQ2JiQ2RrZGtHOFg1M3dTNVBic2tjSWFP?=
 =?utf-8?B?b2NkdVkrV0puRnBudlNsaExEaEUyZlFhMFQwNXE5Q3B4V0JLNnNXUDFDdnNQ?=
 =?utf-8?B?VnpOQU5EeG56WEE5TGFqNDhqUEFvZ3NjOGJSUWM4STk0S0ZIc0lwYThmY1lo?=
 =?utf-8?B?ZjdVWWh4azhXSWNQcGRXcEdFWTcwMHN6dlhzcHRLekM4T2UyU0VFMjdsZWtp?=
 =?utf-8?B?RUZpT1ovS3UyUHJOajdTVjczN3NMMkppcC9XZFFFaGk1cWpjenpVcUhVVkVY?=
 =?utf-8?B?dHMyN0V5NlRaeEFUc3p6cjUyVGdOT0E0LyszUEFSd0preTN0cm9UQXZwZitV?=
 =?utf-8?B?YVpUREtxUXJXSGhGcmpBN3BGNDQ1citRbmtKZnc2akE2UFlQOXhHeHdITDN3?=
 =?utf-8?B?Nm50S3h1a3hHVlFNMmhMemtLQU96WG5TTU1rcVQybjhPTjhha3E5M2wySk5y?=
 =?utf-8?B?cnZaT2hNMmVlUkdpRmhod2FRcXZNZWxIZ0EzbjRnSlh4MkVhVmg5N3NKYTVH?=
 =?utf-8?B?WWpiTnRtRmxHUkRpTjhGaFNYajR6WmdOM05FZUNXSUw0QzBtRzMrTFNLSEFz?=
 =?utf-8?B?V29Ha2laWDNCb2k2bC9ySkVRRXM4STRuekhlTHo0TTlpWWRTRHNnclRlZzl6?=
 =?utf-8?B?YnJNYzJBZGtSRVQvMmxBN000Z3YzWEwreVN4bWtpWUNKOGswcjIxR2J3KzFO?=
 =?utf-8?B?YmtaTHV0RzNwdmU1K0wrdzJNNXA4SCtmZkQxa0R0aUhqOWw4UVN2TFZzYVc0?=
 =?utf-8?B?ZXBSaXRBSHo4Yjc0SmxBVCtCZkU1VnVNNEtMZXVGK1JoaU1NbCtueHhKWXQ1?=
 =?utf-8?B?WTZwNXN6TzJ4Lyt1MkxJcUJLN0xlQ2RYaGNNdWcwWVdPUUxUcFBySklSdDk1?=
 =?utf-8?B?U3ZPa1ljbVVFQVI4VE9RWWxacDFIUnp3bnpqbUlTM0t0dyszQmVCcFhKcHlQ?=
 =?utf-8?B?UEgyY2xwNTJZcldGWWlGNitSNDRFSzdEUHZEaVJac3Y5ZDN3S1JRcndNUHZ6?=
 =?utf-8?B?RGcwUURRVXFvUjJLQnYvL3hjR3RYQW5DcTAyT3cvQ1g5KzQ0bk1DeEltVTUv?=
 =?utf-8?B?VkdhbC90dGJvb3AxdWtjeXhwZjlXM1VDd1p0OEpBcGM4cVc1YWFhVEV1bzJq?=
 =?utf-8?Q?nO+bKjBd5QfuX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d79fee-dd7d-4d6b-28c6-08d8dfe9e041
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 15:18:05.8674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGs75bybuqwt8mHCuQ/ZQEy3s1flOBesH+uzS8lS8kM8EZNUFoTUst53IJwruBGw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4848
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 05.03.21 um 15:48 schrieb Deucher, Alexander:
> [AMD Public Use]
>
>> -----Original Message-----
>> From: Koenig, Christian <Christian.Koenig@amd.com>
>> Sent: Friday, March 5, 2021 8:03 AM
>> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; linux-
>> kernel@vger.kernel.org
>> Cc: stable@vger.kernel.org; Das, Nirmoy <Nirmoy.Das@amd.com>; Deucher,
>> Alexander <Alexander.Deucher@amd.com>; Sasha Levin
>> <sashal@kernel.org>
>> Subject: Re: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
>> compute queue
>>
>> Mhm, I'm not sure this one needs to be backported.
>>
>> Why did you pick it up Greg?
> It was picked up by Sasha's fixes checker.

Well the change who needs this isn't in any earlier kernel, isn't it?

Christian.

>
> Alex
>
>
>> Thanks,
>> Christian.
>>
>> Am 05.03.21 um 13:21 schrieb Greg Kroah-Hartman:
>>> From: Nirmoy Das <nirmoy.das@amd.com>
>>>
>>> [ Upstream commit 8c0225d79273968a65e73a4204fba023ae02714d ]
>>>
>>> For high priority compute to work properly we need to enable wave
>>> limiting on gfx pipe. Wave limiting is done through writing into
>>> mmSPI_WCL_PIPE_PERCENT_GFX register. Enable only one high priority
>>> compute queue to avoid race condition between multiple high priority
>>> compute queues writing that register simultaneously.
>>>
>>> Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
>>> Acked-by: Christian König <christian.koenig@amd.com>
>>> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 15 ++++++++-------
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h |  2 +-
>>>    drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c  |  6 ++----
>>>    drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c   |  6 ++----
>>>    drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c   |  7 ++-----
>>>    5 files changed, 15 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
>>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
>>> index cd2c676a2797..8e0a6c62322e 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
>>> @@ -193,15 +193,16 @@ static bool
>> amdgpu_gfx_is_multipipe_capable(struct amdgpu_device *adev)
>>>    }
>>>
>>>    bool amdgpu_gfx_is_high_priority_compute_queue(struct
>> amdgpu_device *adev,
>>> -					       int pipe, int queue)
>>> +					       struct amdgpu_ring *ring)
>>>    {
>>> -	bool multipipe_policy = amdgpu_gfx_is_multipipe_capable(adev);
>>> -	int cond;
>>> -	/* Policy: alternate between normal and high priority */
>>> -	cond = multipipe_policy ? pipe : queue;
>>> -
>>> -	return ((cond % 2) != 0);
>>> +	/* Policy: use 1st queue as high priority compute queue if we
>>> +	 * have more than one compute queue.
>>> +	 */
>>> +	if (adev->gfx.num_compute_rings > 1 &&
>>> +	    ring == &adev->gfx.compute_ring[0])
>>> +		return true;
>>>
>>> +	return false;
>>>    }
>>>
>>>    void amdgpu_gfx_compute_queue_acquire(struct amdgpu_device
>> *adev)
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
>>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
>>> index 6b5a8f4642cc..72dbcd2bc6a6 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
>>> @@ -380,7 +380,7 @@ void
>> amdgpu_queue_mask_bit_to_mec_queue(struct amdgpu_device *adev, int
>> bit,
>>>    bool amdgpu_gfx_is_mec_queue_enabled(struct amdgpu_device *adev,
>> int mec,
>>>    				     int pipe, int queue);
>>>    bool amdgpu_gfx_is_high_priority_compute_queue(struct
>> amdgpu_device *adev,
>>> -					       int pipe, int queue);
>>> +					       struct amdgpu_ring *ring);
>>>    int amdgpu_gfx_me_queue_to_bit(struct amdgpu_device *adev, int me,
>>>    			       int pipe, int queue);
>>>    void amdgpu_gfx_bit_to_me_queue(struct amdgpu_device *adev, int
>> bit,
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
>>> b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
>>> index e7d6da05011f..3a291befcddc 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
>>> @@ -4495,8 +4495,7 @@ static int gfx_v10_0_compute_ring_init(struct
>> amdgpu_device *adev, int ring_id,
>>>    	irq_type = AMDGPU_CP_IRQ_COMPUTE_MEC1_PIPE0_EOP
>>>    		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
>>>    		+ ring->pipe;
>>> -	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring->pipe,
>>> -							    ring->queue) ?
>>> +	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring) ?
>>>    			AMDGPU_GFX_PIPE_PRIO_HIGH :
>> AMDGPU_GFX_PIPE_PRIO_NORMAL;
>>>    	/* type-2 packets are deprecated on MEC, use type-3 instead */
>>>    	r = amdgpu_ring_init(adev, ring, 1024, @@ -6545,8 +6544,7 @@ static
>>> void gfx_v10_0_compute_mqd_set_priority(struct amdgpu_ring *ring,
>> struct
>>>    	struct amdgpu_device *adev = ring->adev;
>>>
>>>    	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
>>> -		if (amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring->pipe,
>>> -							      ring->queue)) {
>>> +		if (amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring)) {
>>>    			mqd->cp_hqd_pipe_priority =
>> AMDGPU_GFX_PIPE_PRIO_HIGH;
>>>    			mqd->cp_hqd_queue_priority =
>>>
>> 	AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
>>> b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
>>> index 37639214cbbb..b0284c4659ba 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
>>> @@ -1923,8 +1923,7 @@ static int gfx_v8_0_compute_ring_init(struct
>> amdgpu_device *adev, int ring_id,
>>>    		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
>>>    		+ ring->pipe;
>>>
>>> -	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring->pipe,
>>> -							    ring->queue) ?
>>> +	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring) ?
>>>    			AMDGPU_GFX_PIPE_PRIO_HIGH :
>> AMDGPU_RING_PRIO_DEFAULT;
>>>    	/* type-2 packets are deprecated on MEC, use type-3 instead */
>>>    	r = amdgpu_ring_init(adev, ring, 1024, @@ -4442,8 +4441,7 @@ static
>>> void gfx_v8_0_mqd_set_priority(struct amdgpu_ring *ring, struct vi_mqd
>> *m
>>>    	struct amdgpu_device *adev = ring->adev;
>>>
>>>    	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
>>> -		if (amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring->pipe,
>>> -							      ring->queue)) {
>>> +		if (amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring)) {
>>>    			mqd->cp_hqd_pipe_priority =
>> AMDGPU_GFX_PIPE_PRIO_HIGH;
>>>    			mqd->cp_hqd_queue_priority =
>>>
>> 	AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
>>> b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
>>> index 5f4805e4d04a..3e800193a604 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
>>> @@ -2228,8 +2228,7 @@ static int gfx_v9_0_compute_ring_init(struct
>> amdgpu_device *adev, int ring_id,
>>>    	irq_type = AMDGPU_CP_IRQ_COMPUTE_MEC1_PIPE0_EOP
>>>    		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
>>>    		+ ring->pipe;
>>> -	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring->pipe,
>>> -							    ring->queue) ?
>>> +	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring) ?
>>>    			AMDGPU_GFX_PIPE_PRIO_HIGH :
>> AMDGPU_GFX_PIPE_PRIO_NORMAL;
>>>    	/* type-2 packets are deprecated on MEC, use type-3 instead */
>>>    	return amdgpu_ring_init(adev, ring, 1024, @@ -3391,9 +3390,7 @@
>>> static void gfx_v9_0_mqd_set_priority(struct amdgpu_ring *ring, struct
>> v9_mqd *m
>>>    	struct amdgpu_device *adev = ring->adev;
>>>
>>>    	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
>>> -		if (amdgpu_gfx_is_high_priority_compute_queue(adev,
>>> -							      ring->pipe,
>>> -							      ring->queue)) {
>>> +		if (amdgpu_gfx_is_high_priority_compute_queue(adev,
>> ring)) {
>>>    			mqd->cp_hqd_pipe_priority =
>> AMDGPU_GFX_PIPE_PRIO_HIGH;
>>>    			mqd->cp_hqd_queue_priority =
>>>
>> 	AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;

