Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B4F629AAE
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 14:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiKONh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 08:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238340AbiKONh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 08:37:26 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFFA5FA7
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 05:37:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXPrgJUaxu52e9q+UczCLXTzhNSYNsEUe/RXU8G6F8lITJ8SRLgzXQ1D0V25rNib4JGO4s+8rmbJS9AEKeDPBJK+5pV3By2mHWBs0aP528IDfhKkQW+ZxyUjPAT/rMY1zb44XBwphUsmn9zc7XypJpWyaoydvKwPScl1TMrnDcVR00zPhwKguvWg8ennv2jc8VQ1a3QqwvhWoEG4IpvuXeEwTMfb2/CbrNnKY886kA0SjKpgTjyC5c+zSrY5OsT/X6s/MrhqXnUmqZ79VBCLWgvPllohDg2/YW+RiH1wPgMNqroqwNpQWPO3FXlrN5dVnpi7KlpQf/HVZjkVks4++w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HI/tgjW+Xef7E+pd3qJI1kwdqvTdZp2Yd05h3H8qfKs=;
 b=MtEl/sLO7Bs99UW2jc2fMuTZf/nPdFbUPbC+ZKT3IdfFZaokaUFz8MiVZRkiMzwoBJTB7fcVs5/7KtQi+AmijjkANmyGxFRokyWOMzEQu+IFKp8RH1rY9K7Mu5Z1RcCTJclWV5JaoPLX3niE9kxhi/0+0ny7U0oHWpgLAnIXJiTghLgMP+OblCAjva624csoIATzmcuzX7GPe/o/hxI7gaKUDcNnHz/SnplQYriCLtQZeHhOwPyBnMn4yoUiDEwTD0ybLheF1VCBYwfuI2QHRcmw+EuYMbJyNOo81lwdTOxh56HZvQTAo/SZd7dPkWGyhaHXEQXM7bCzEjzV3zqiWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HI/tgjW+Xef7E+pd3qJI1kwdqvTdZp2Yd05h3H8qfKs=;
 b=HzoqthyvgflsvsJw6aNrh4R97+afhWEyzerEv7ZrFjCH6lioKvBsWxEjQJTYzZQ8dgrnABDtFPpI98SZCi9sXAnX/dkG66j5rkNJ3EPZ0+lNPxFPIAwj4h53Qm2dz058vbJQbGt2tQt8RKx+QqImcaMRGBbgSA4tfYsthlNqCNs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 13:37:21 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 13:37:21 +0000
Message-ID: <2093f939-1079-655a-b24c-f47fe1168eac@amd.com>
Date:   Tue, 15 Nov 2022 14:37:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/4] drm/amdgpu: fix userptr HMM range handling
Content-Language: en-US
To:     Felix Kuehling <felix.kuehling@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        Philip.Yang@amd.com, amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20221110130009.1835-1-christian.koenig@amd.com>
 <20221110130009.1835-2-christian.koenig@amd.com>
 <aa3a76c2-e5f3-8e15-717a-a90a1d9c516f@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <aa3a76c2-e5f3-8e15-717a-a90a1d9c516f@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FRYP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::13)
 To BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d055c0-0d3c-4db4-958a-08dac70e85b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UK+BUaV5aMzKZsfOiTKDVDbk6VBlOtaUEWwTB9FuXD5CK9aaeaEhKC2p9V30PCWBEhasenO0+g8iolrLQ21PWMvg/md7weGZ4YGwCfAJ1P5/0bsn0kewjcwh9VUUxiAzKmM4FMnImCDP28f9WGoE3PrNuAMys7NNPGFkYlSgcmudlFCw30vWtBGH/xwTcfLuXQvaD8eVHLSfAePifFZgC9EI8l132x0jEa5tBGxEV5L/YimSbOZjUvhq6GRFUK4xLOQhpIzPt8gZnAkheGrKP6pBecRR+NQ3crpdzbr8YsJpgGa7ThZG3WBYIXF7vdM3NpOzGPLGYPVfEeFXllhYqfXF4jKrFp9vKI9djr3hl8Nihwe54WVdFtVlmRNgxDH9GBGcBKVCkyqR9jwWZQJghcqJZUXzNaRPpv15zwrViLt7TckzsdoabaNL8aHb8ltky8mqHOvgPjgEuNwhcHbrVzvQ7hLQJ4CghWF2blG6KjM6lhQ6md4zMogMO8Lujb3gU7+wEhqnIk//b9mGJXDMjc07d0Qhd4L8Jv5Q6yMDrclO1sKC7gOP7ZcCFM1ppTxzrTbbO4rmaMIbW8R8+1UWk3ur1rZSmj1KMxLH2PtVfZglLtZIGFWkc4f9qfWnwDiKLRbG8WawH39mj2JWOkDZx5ypKVF5bXLGsCYQRmWFpZxhxFEWN4abvGNNzNURh+33jYI+lz/uCnxZIrfgUK764EmR16iXct6m5XTKKTy9B3wBle3ARcsXDbzNOwKRrKoHlg/cDZIRY7YTAGtHiOhXw/Wv/OPSSS7YFJ/Jmb72WWs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199015)(31686004)(2906002)(66946007)(36756003)(66476007)(316002)(5660300002)(66556008)(83380400001)(86362001)(4001150100001)(31696002)(110136005)(30864003)(41300700001)(4326008)(8936002)(8676002)(6486002)(6512007)(66574015)(6666004)(186003)(6506007)(2616005)(38100700002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVBvcStYOTBzMG1aYTBid3p1ZWlubWRQTXQ3UU9Cb092Qkc3VUpyeUlIUnpR?=
 =?utf-8?B?OXhtb2dPNWt0VitLTlNnUG9lV3gwNVJZQUVWZ1N3THk3a3J3NDZmY2N3QTVX?=
 =?utf-8?B?UHhqN2JjSDg2RmFVcUpPZGo1djhWL0tIUHgvd1M5eXNXUU5PaEhPSU9ZK25k?=
 =?utf-8?B?ZVFJU0hjRWZNa0RDOTBnbmJRQVA5djFqUmh0SzBkOGVvUDJ2cUN6NHNXQnUx?=
 =?utf-8?B?NTNJSWorTFY5cUhnR0xmSERjU1B1Z0xmNHFSdkhjdzl3ZklkVEVkQnJlNVBY?=
 =?utf-8?B?aEo3VmkxOUlHaWwySlBGS0E1aElnRWFkb1pmKzM2aXRFcjRlNG9VZHpZOWRH?=
 =?utf-8?B?K2NpbWdaaUs2RFllTllIQkd5UlZFYldsNkFvZlJ2QTI4SHBXMW9QcGNnMjkz?=
 =?utf-8?B?Z2dmTjJmR1F0aDVnWkFXamF6UTBOajExc015NDRMSys2U1Z6NTMzaUlVTXBD?=
 =?utf-8?B?NXIveXVIZFZTRFVQZmtTb01uM2hwVE1TblV5a3NkQ0hxL3IrRCtOK0pwYVBK?=
 =?utf-8?B?TWJudVVrYkJ3dXJGU1FQRHdZcU1qczJMMUJjSGNhMUMwRGJ3SlV0UlZHdVBS?=
 =?utf-8?B?a3Vkakh0SmszU3FUMk44WUtCU21tTUlvbHowVmI2SlJhMU1tR2FZNElGTGpa?=
 =?utf-8?B?M3Qyc1JSTjZWUmJLamRrNVB5ZHlucmMvb0Q3d2loQi9jc1U4UEhtMWpyRjNt?=
 =?utf-8?B?QStVRzByeklqRWNVTEFoaUo5ZFZSSHhzV0E5YlpTdlNaVk5ON3ZsN1BZT3lo?=
 =?utf-8?B?QStlQ1ppbWhMQ0RYMVlLazVUdHlCWkk4bzRzUkszNXhPQkZvMXlxUHBubVVl?=
 =?utf-8?B?cUw4SmIrUUxqQmJFc203US9uZXV3a0hnTWU4RzcwRnp6Z04wamY4WUtNS2lP?=
 =?utf-8?B?ZDF5ZWY2dUlxVXc3b2IyWFNmMmZ4SjlDN1ErQXQ3a2RxMHNZTEw2Q3ZYSEMy?=
 =?utf-8?B?S1M3UldIV1NQNTRSbTlTOUhuOTZvMEU1L1FnRjlaWDZvVmFIVlpmSHdpd0xq?=
 =?utf-8?B?WC9tWWpZVXhpWDhOWG5xWFVHSitsQzZQWmhVZlFkcUp1LzZLNEVyTkhJU3VO?=
 =?utf-8?B?ZWlJMkhlc3NpUUVsaWl5TXk5ZGlJdkJxeFBDNy9MckhuR3o3S3RUVVpXYWxo?=
 =?utf-8?B?VGx2VTkvRUJna0s5U1RGbVRHTU5qOC9hN1JzaXNmY1lLeklJTHlFaklwYVIw?=
 =?utf-8?B?Z1hPMGUrMnlLRTMzY1pDRGRDTzEyNWpDRDh1SDlBcnpmNzZveFdTRit5bWlp?=
 =?utf-8?B?OFNnSUp1S2tuZUF1cDhuK1c3N0w0dktkVUxIbTlqNEdrUUhBNGxPK0UxcmtQ?=
 =?utf-8?B?ZTNyTDJmOVhrL2g3aUZyc2ZNMnQxWDZXeTlpdjJmcEsrWUJCRWhpcjhUbUZP?=
 =?utf-8?B?azNyNE9TejZldHBsYmJveHlQUGtzMXE3QXlBVVRmVzVQaGcvRjR1OVNDejNQ?=
 =?utf-8?B?aG1GQi9acERBbHBxWG1pYjVBVHp6UzdHZk83VmlHeXk3T3NUOXd3TmxQSlJl?=
 =?utf-8?B?NFMrUGYxaTZKVUtYVDgyL2dNWi80dFArNnJZdFJrWm5TdTE0dGUxbmNiOGls?=
 =?utf-8?B?TERLNnhvSXYrd2tqajZBMzNPdFlwNEZsU2gxUGs1YzdVOVdHUThBS3Qvb3NP?=
 =?utf-8?B?TW9mM09KUnF2dk1aOUlDYU5uUHg4M01VSEpiMEIzalJXOXlkT0JzczV2d0Ji?=
 =?utf-8?B?NnFGT1pmWkUvNDFsSVVselJGeDB1cWc3KzZBN3gvcFJnLzVyMzc2QXdHZ2xU?=
 =?utf-8?B?WVVON0d6Um0zOFV3aXFXVTcwcGE4SzhuMDUxMU9BeUQ4dGJQcTkvc2JhdENC?=
 =?utf-8?B?VjFFRjlsTGtaaU8vdTdiU2VLajA3dFpvYzRSZlBqL0h2NzY1U1ZYZzBKT1hh?=
 =?utf-8?B?dmNqNlZCZUl4OHVkR3drQmZ0WDVFdVpJYjAzYmJKR3IzMTNoMVZzZ1dXb09N?=
 =?utf-8?B?MjZwVjhPWG5zS0M2OWJKMUJCOFZnMFR3SmVYeGI1TFFDSXVBeDhYR0wrYS9E?=
 =?utf-8?B?NGFVWjIxMTdKTWRBc2s3U3dDbjNFcWtiZG5VMEJKU1NGS1dLbWJCalVhbDl5?=
 =?utf-8?B?elNROUhkZCtkejU0OWVzUjM3dTRLdDlpR251aG4rVk5XUEdOWmU2aDMzT3dk?=
 =?utf-8?B?Z096amRUeEpNMTE0L2R5SkVaSzFaeDNib3JscEh0b0M5UTZ1czN1NGVONDdr?=
 =?utf-8?Q?ZY7F5DadY4WNtpJaow+4jOLLU797PL6pD+QXO+eGJEQ0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d055c0-0d3c-4db4-958a-08dac70e85b9
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 13:37:21.6316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMyiR0+PkRR1d8PpAO/sBFYlxSVtNU+b5KBeY+8SZHwO6L55bkC6elmNuVpB8ZKp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 10.11.22 um 22:55 schrieb Felix Kuehling:
>
> Am 2022-11-10 um 08:00 schrieb Christian König:
>> The basic problem here is that it's not allowed to page fault while
>> holding the reservation lock.
>>
>> So it can happen that multiple processes try to validate an userptr
>> at the same time.
>>
>> Work around that by putting the HMM range object into the mutex
>> protected bo list for now.
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
>> CC: stable@vger.kernel.org
>> ---
>>   .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 12 +++--
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c   |  1 +
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h   |  3 ++
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c        |  8 +--
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c       |  6 ++-
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       | 50 +++++--------------
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h       | 14 ++++--
>>   7 files changed, 43 insertions(+), 51 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
>> index c5c9bfa2772e..83659e6419a8 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
>> @@ -940,6 +940,7 @@ static int init_user_pages(struct kgd_mem *mem, 
>> uint64_t user_addr,
>>       struct amdkfd_process_info *process_info = mem->process_info;
>>       struct amdgpu_bo *bo = mem->bo;
>>       struct ttm_operation_ctx ctx = { true, false };
>> +    struct hmm_range *range;
>
> I'd feel better if these local hmm_range pointers here and in 
> update_invalid_user_pages and amdgpu_gem_userptr_ioctl were 
> initialized to NULL. amdgpu_ttm_tt_get_user_pages leaves it 
> uninitialized in case of errors and amdgpu_ttm_tt_get_user_pages_done 
> checks for !range.

I've opted to initializing range to NULL in case of an error.

>
> With that fixed, the patch is
>
> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>

Does that still counts?

Thanks,
Christian.

>
>
>>       int ret = 0;
>>         mutex_lock(&process_info->lock);
>> @@ -969,7 +970,7 @@ static int init_user_pages(struct kgd_mem *mem, 
>> uint64_t user_addr,
>>           return 0;
>>       }
>>   -    ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
>> +    ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages, &range);
>>       if (ret) {
>>           pr_err("%s: Failed to get user pages: %d\n", __func__, ret);
>>           goto unregister_out;
>> @@ -987,7 +988,7 @@ static int init_user_pages(struct kgd_mem *mem, 
>> uint64_t user_addr,
>>       amdgpu_bo_unreserve(bo);
>>     release_out:
>> -    amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
>> +    amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
>>   unregister_out:
>>       if (ret)
>>           amdgpu_mn_unregister(bo);
>> @@ -2319,6 +2320,8 @@ static int update_invalid_user_pages(struct 
>> amdkfd_process_info *process_info,
>>       /* Go through userptr_inval_list and update any invalid 
>> user_pages */
>>       list_for_each_entry(mem, &process_info->userptr_inval_list,
>>                   validate_list.head) {
>> +        struct hmm_range *range;
>> +
>>           invalid = atomic_read(&mem->invalid);
>>           if (!invalid)
>>               /* BO hasn't been invalidated since the last
>> @@ -2329,7 +2332,8 @@ static int update_invalid_user_pages(struct 
>> amdkfd_process_info *process_info,
>>           bo = mem->bo;
>>             /* Get updated user pages */
>> -        ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
>> +        ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages,
>> +                           &range);
>>           if (ret) {
>>               pr_debug("Failed %d to get user pages\n", ret);
>>   @@ -2348,7 +2352,7 @@ static int update_invalid_user_pages(struct 
>> amdkfd_process_info *process_info,
>>                * FIXME: Cannot ignore the return code, must hold
>>                * notifier_lock
>>                */
>> -            amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
>> +            amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
>>           }
>>             /* Mark the BO as valid unless it was invalidated
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
>> index 2168163aad2d..252a876b0725 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
>> @@ -209,6 +209,7 @@ void amdgpu_bo_list_get_list(struct 
>> amdgpu_bo_list *list,
>>               list_add_tail(&e->tv.head, &bucket[priority]);
>>             e->user_pages = NULL;
>> +        e->range = NULL;
>>       }
>>         /* Connect the sorted buckets in the output list. */
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
>> index 9caea1688fc3..e4d78491bcc7 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
>> @@ -26,6 +26,8 @@
>>   #include <drm/ttm/ttm_execbuf_util.h>
>>   #include <drm/amdgpu_drm.h>
>>   +struct hmm_range;
>> +
>>   struct amdgpu_device;
>>   struct amdgpu_bo;
>>   struct amdgpu_bo_va;
>> @@ -36,6 +38,7 @@ struct amdgpu_bo_list_entry {
>>       struct amdgpu_bo_va        *bo_va;
>>       uint32_t            priority;
>>       struct page            **user_pages;
>> +    struct hmm_range        *range;
>>       bool                user_invalidated;
>>   };
>>   diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
>> index d371000a5727..7f9cedd8e157 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
>> @@ -910,7 +910,7 @@ static int amdgpu_cs_parser_bos(struct 
>> amdgpu_cs_parser *p,
>>               goto out_free_user_pages;
>>           }
>>   -        r = amdgpu_ttm_tt_get_user_pages(bo, e->user_pages);
>> +        r = amdgpu_ttm_tt_get_user_pages(bo, e->user_pages, &e->range);
>>           if (r) {
>>               kvfree(e->user_pages);
>>               e->user_pages = NULL;
>> @@ -988,9 +988,10 @@ static int amdgpu_cs_parser_bos(struct 
>> amdgpu_cs_parser *p,
>>             if (!e->user_pages)
>>               continue;
>> -        amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
>> +        amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, e->range);
>>           kvfree(e->user_pages);
>>           e->user_pages = NULL;
>> +        e->range = NULL;
>>       }
>>       mutex_unlock(&p->bo_list->bo_list_mutex);
>>       return r;
>> @@ -1265,7 +1266,8 @@ static int amdgpu_cs_submit(struct 
>> amdgpu_cs_parser *p,
>>       amdgpu_bo_list_for_each_userptr_entry(e, p->bo_list) {
>>           struct amdgpu_bo *bo = ttm_to_amdgpu_bo(e->tv.bo);
>>   -        r |= !amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
>> +        r |= !amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, e->range);
>> +        e->range = NULL;
>>       }
>>       if (r) {
>>           r = -EAGAIN;
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
>> index 111484ceb47d..91571b1324f2 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
>> @@ -378,6 +378,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_device 
>> *dev, void *data,
>>       struct amdgpu_device *adev = drm_to_adev(dev);
>>       struct drm_amdgpu_gem_userptr *args = data;
>>       struct drm_gem_object *gobj;
>> +    struct hmm_range *range;
>>       struct amdgpu_bo *bo;
>>       uint32_t handle;
>>       int r;
>> @@ -418,7 +419,8 @@ int amdgpu_gem_userptr_ioctl(struct drm_device 
>> *dev, void *data,
>>           goto release_object;
>>         if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
>> -        r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
>> +        r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages,
>> +                         &range);
>>           if (r)
>>               goto release_object;
>>   @@ -441,7 +443,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_device 
>> *dev, void *data,
>>     user_pages_done:
>>       if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE)
>> -        amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
>> +        amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
>>     release_object:
>>       drm_gem_object_put(gobj);
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
>> index 76a8ebfc9e71..a56d28bd23be 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
>> @@ -642,9 +642,6 @@ struct amdgpu_ttm_tt {
>>       struct task_struct    *usertask;
>>       uint32_t        userflags;
>>       bool            bound;
>> -#if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
>> -    struct hmm_range    *range;
>> -#endif
>>   };
>>     #define ttm_to_amdgpu_ttm_tt(ptr)    container_of(ptr, struct 
>> amdgpu_ttm_tt, ttm)
>> @@ -657,7 +654,8 @@ struct amdgpu_ttm_tt {
>>    * Calling function must call amdgpu_ttm_tt_userptr_range_done() 
>> once and only
>>    * once afterwards to stop HMM tracking
>>    */
>> -int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page 
>> **pages)
>> +int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page 
>> **pages,
>> +                 struct hmm_range **range)
>>   {
>>       struct ttm_tt *ttm = bo->tbo.ttm;
>>       struct amdgpu_ttm_tt *gtt = ttm_to_amdgpu_ttm_tt(ttm);
>> @@ -673,10 +671,6 @@ int amdgpu_ttm_tt_get_user_pages(struct 
>> amdgpu_bo *bo, struct page **pages)
>>           return -EFAULT;
>>       }
>>   -    /* Another get_user_pages is running at the same time?? */
>> -    if (WARN_ON(gtt->range))
>> -        return -EFAULT;
>> -
>>       if (!mmget_not_zero(mm)) /* Happens during process shutdown */
>>           return -ESRCH;
>>   @@ -694,7 +688,7 @@ int amdgpu_ttm_tt_get_user_pages(struct 
>> amdgpu_bo *bo, struct page **pages)
>>         readonly = amdgpu_ttm_tt_is_readonly(ttm);
>>       r = amdgpu_hmm_range_get_pages(&bo->notifier, mm, pages, start,
>> -                       ttm->num_pages, &gtt->range, readonly,
>> +                       ttm->num_pages, range, readonly,
>>                          true, NULL);
>>   out_unlock:
>>       mmap_read_unlock(mm);
>> @@ -712,30 +706,24 @@ int amdgpu_ttm_tt_get_user_pages(struct 
>> amdgpu_bo *bo, struct page **pages)
>>    *
>>    * Returns: true if pages are still valid
>>    */
>> -bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm)
>> +bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
>> +                       struct hmm_range *range)
>>   {
>>       struct amdgpu_ttm_tt *gtt = ttm_to_amdgpu_ttm_tt(ttm);
>> -    bool r = false;
>>   -    if (!gtt || !gtt->userptr)
>> +    if (!gtt || !gtt->userptr || !range)
>>           return false;
>>         DRM_DEBUG_DRIVER("user_pages_done 0x%llx pages 0x%x\n",
>>           gtt->userptr, ttm->num_pages);
>>   -    WARN_ONCE(!gtt->range || !gtt->range->hmm_pfns,
>> -        "No user pages to check\n");
>> +    WARN_ONCE(!range->hmm_pfns, "No user pages to check\n");
>>   -    if (gtt->range) {
>> -        /*
>> -         * FIXME: Must always hold notifier_lock for this, and must
>> -         * not ignore the return code.
>> -         */
>> -        r = amdgpu_hmm_range_get_pages_done(gtt->range);
>> -        gtt->range = NULL;
>> -    }
>> -
>> -    return !r;
>> +    /*
>> +     * FIXME: Must always hold notifier_lock for this, and must
>> +     * not ignore the return code.
>> +     */
>> +    return !amdgpu_hmm_range_get_pages_done(range);
>>   }
>>   #endif
>>   @@ -812,20 +800,6 @@ static void amdgpu_ttm_tt_unpin_userptr(struct 
>> ttm_device *bdev,
>>       /* unmap the pages mapped to the device */
>>       dma_unmap_sgtable(adev->dev, ttm->sg, direction, 0);
>>       sg_free_table(ttm->sg);
>> -
>> -#if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
>> -    if (gtt->range) {
>> -        unsigned long i;
>> -
>> -        for (i = 0; i < ttm->num_pages; i++) {
>> -            if (ttm->pages[i] !=
>> -                hmm_pfn_to_page(gtt->range->hmm_pfns[i]))
>> -                break;
>> -        }
>> -
>> -        WARN((i == ttm->num_pages), "Missing get_user_page_done\n");
>> -    }
>> -#endif
>>   }
>>     static void amdgpu_ttm_gart_bind(struct amdgpu_device *adev,
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
>> index 6a70818039dd..a37207011a69 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
>> @@ -39,6 +39,8 @@
>>     #define AMDGPU_POISON    0xd0bed0be
>>   +struct hmm_range;
>> +
>>   struct amdgpu_gtt_mgr {
>>       struct ttm_resource_manager manager;
>>       struct drm_mm mm;
>> @@ -149,15 +151,19 @@ void amdgpu_ttm_recover_gart(struct 
>> ttm_buffer_object *tbo);
>>   uint64_t amdgpu_ttm_domain_start(struct amdgpu_device *adev, 
>> uint32_t type);
>>     #if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
>> -int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page 
>> **pages);
>> -bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm);
>> +int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page 
>> **pages,
>> +                 struct hmm_range **range);
>> +bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
>> +                       struct hmm_range *range);
>>   #else
>>   static inline int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo,
>> -                           struct page **pages)
>> +                           struct page **pages,
>> +                           struct hmm_range **range)
>>   {
>>       return -EPERM;
>>   }
>> -static inline bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt 
>> *ttm)
>> +static inline bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt 
>> *ttm,
>> +                             struct hmm_range *range)
>>   {
>>       return false;
>>   }

