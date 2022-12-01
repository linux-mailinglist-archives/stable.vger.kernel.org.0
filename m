Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A7063EA57
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 08:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLAHcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 02:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLAHcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 02:32:35 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2344010E0
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 23:32:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TY17WC9EpcYZyDgJNPfQKsrCVbOjoJzT1disrxE0zVV+3Ymyzl65V8M7VSE6SKwbGhBuuSAGzUFnRh4b7UDdR/w6asycTKqXiMcXwooRI9Y275JNBTNZ7TIxbspvfYWiTR7KA8E8luftG8kacusjLxGRUXn9aDDQ2egpFMrKweA6Gqv1owns0L3Fzg/jGsX6jA4XHCXJ32d/kJjuhyoKc+s4E675RbD+Mv06LVaGhmEHjz4dfdTEyh570DJvSafcvayri5uX9uFborwXSa/MXRTwMgky09xxFjUWXY2moToyv2PZnUJuEHMNFIKV+eqeFpmR85d7g6LPVLMCd7yWXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVXn1XBR8veS94hLd4JM0QG3z0gKaH5XeFkn1O27bLk=;
 b=BhA62OkSJEaZLz2qV/AkMQV4kdLd3p6zvfQfYKG56iN1IX+cqQsF/o8SXN5UjGMtdAdurAZK0CqKWdcsgk1y6b6yAdRQCmQJhZODbyWGX5W3I5ezlQi3gT2j15SjK9UiKIVHhUJa6O28fgawRHf+R7+x1rie2I0BIk/prMvLpAg3X3SL7kxZQH0M2pdPPLOVvHEh4+6bCXK21jTFqFHMlgP56XhdswmdgFXiA2qpwR4t8W2MqNQh+bZFanE06BJzzSDV6DEdnLy65mP05VZHLSJxDdfF6fxMH70eszmw7nsBt5vjA5xttc1HdQ/J4C5b/ovTIF9Ihh5hBsOtegLulQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVXn1XBR8veS94hLd4JM0QG3z0gKaH5XeFkn1O27bLk=;
 b=VrQ/1JO+tXDppD6+mebjSM5tRZGxdGTJ7H0xNDU6A9Dtuxcsfjv1mvojlByU/ji41IypbVfXEahL7K3BIRZJZD/w5LBHk9BE+6I1HZK2W3Pm+EHDkcCH10KzlAtglxOuIb3nObrCNb4f4MYik9zyMVtvQdCrWbRXpQ4QbNtafGM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by MW4PR12MB6950.namprd12.prod.outlook.com (2603:10b6:303:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 07:32:26 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::bc0:e01b:6da0:9f24]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::bc0:e01b:6da0:9f24%4]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 07:32:26 +0000
Message-ID: <2252113f-c731-c515-ab8c-e589207f538f@amd.com>
Date:   Thu, 1 Dec 2022 13:02:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the
 s2idle suspend
Content-Language: en-US
To:     "Liang, Prike" <Prike.Liang@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
Cc:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20221201062242.979864-1-Prike.Liang@amd.com>
 <3a683d79-5526-6b3a-d770-5fa34592b940@amd.com>
 <DS7PR12MB60054AC0B4BC08C790A30DEAFB149@DS7PR12MB6005.namprd12.prod.outlook.com>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <DS7PR12MB60054AC0B4BC08C790A30DEAFB149@DS7PR12MB6005.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0228.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::16) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB4614:EE_|MW4PR12MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: 61e009e3-9b97-4066-ea28-08dad36e31a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZA0Z+tpGjseZv67IkACr/ozxevKOwmCozLWaRDgiQ/3OAl9PDRQANWqQ0/yUEwWVpctl+1wvcHmg93ImPkYruz76218w5UghfLlyVQcNMxQFfNeY9ASjRdgxSo98JZ5RXeWf+PeTMCKvW7rF2luePGH7m8zjWm6EP3kzRsKchxomBJcwpzZ92PjhK00XeC3gppnbZ889FOdhII1DhuwQi79ffUy3FbhEjOH/+dJ02ZQ28dwKoZOuPx0/7juo3ult4d086g0qLDkl8x38Ti2ng80as/BWb9Zv4sgFSgIAhTFhmFrKwmw+Jv11frPeynNn6RHJ9n9b+0vFWgYLStwCZObatK5qAfaSK1LYc/BYc+OsC5baFMvot4+9J3CE80/113GxTEJG+R3MalCPjz5XuOv8YKOO9Oj4wFaR0sU3YZJ5ocHK6siNDd90n/eDDajWfCBwh2MOW6o7QvFOOwFKopT5157pM7XxklnuwZ6s0lYCVD3W742OBYi9xFinOCGLIwHP3i1zM47S3gogUlsIEM9fCjF3eu/A4uB+zJfGRS5iJ/XMeXuUZGAvFqboh55V6JGs2dwxXejeN67tV7O9W36E8oHnbJUZ9TYtH0QjrHFZilaDTaSHsWKKhpmbC79qo5/DrAn+hFICEAwd5poQPfTpo59Ipr70jiO6qY65T/Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199015)(2906002)(15650500001)(83380400001)(31686004)(2616005)(41300700001)(186003)(36756003)(86362001)(31696002)(38100700002)(53546011)(54906003)(110136005)(6512007)(26005)(8936002)(5660300002)(4326008)(8676002)(66476007)(66946007)(66556008)(6486002)(478600001)(316002)(6506007)(6666004)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1ErTU5wdGR1dDhlK3NCQnA1b2tKSlhlWTRZZ3hWYjBJNlFxaURRSDAwZG1Y?=
 =?utf-8?B?SUlhMjd6eUNCMXJtTjFYNDBzalZqL3h5M2lxNmhuUnZSUUdyajdlRkM4OHNh?=
 =?utf-8?B?dUJHb3NteE9TcndyVFVxUmR4MkJHZVF4K3hrVlJnNnVNOXBBSE1XcnFNL2hT?=
 =?utf-8?B?dytGZytvQTRtZ2p2a1ptTmpJSGpjcmd1T0E2ZnBtV0JEWis1eWpZTGd1anlG?=
 =?utf-8?B?aGJrd2t1RCt4ZlNhN09IWVlzMEh3QndPbGNnd1dZa2wxK1czMDNNVTgzNmdC?=
 =?utf-8?B?bjFFV084M3NIVTIzVVNzVWtBaUFZTmZqQnNUeEp4enBMQUlPNU4yOXdWU3Vl?=
 =?utf-8?B?cW55L0pKWTFmT2VKVW0wdXpBRklaTFFkR3g1SEtqc2NGQWtWaUU1MHZYYlpx?=
 =?utf-8?B?bkRxay9uQWJnczRSamtNN3V3dkZwSVdhdjgvY1VRRGthazZTTE9QaHpHZXV5?=
 =?utf-8?B?R0hKYWhSYkdMOEhvalNyZ1dqd3Rqa1BRamFNdjNDZzF6bzlPdU9nV3V0L2Ew?=
 =?utf-8?B?MmxRZmRodFdWamNZdXpDNFp5R1VJRTcwZ09qNW4yZXUyL2dramRVZlNmZlk0?=
 =?utf-8?B?eEZzOXVqazBQY3RvbXNZK2pFQ3FnV0ZGQmwwa0IrdHlCUVFxVHhjUWJyN3pD?=
 =?utf-8?B?bWtWazg5R1VIQzN1Slp0L3NkMUxUeXFUQ1ZXSDZIcWZKdlp5RGpza3VQVnM1?=
 =?utf-8?B?dVUrUVhDMXhJTm1nWVFwaXJoK2JZb0ZVQmRnTTl3SzVMMXpSNHVMeUJyS2pw?=
 =?utf-8?B?bzdBby83OXJnMG10Ny94c0FsekgwWFFiMXNjYk1CWUZYeWtDakxza1U5aTNk?=
 =?utf-8?B?dTNwRWhSVlNvbXZ5cCtIeHMzdzlFd2RweUxaYXpadTQwM1creU1tTFI2NUo1?=
 =?utf-8?B?b1lkRHZIdVdGajY5QW92anhIT2dqRzRxVXlHNXU5d0VRQ3JlSkpEdXc5S2lU?=
 =?utf-8?B?dWxFRmFkeUxVaGtyTWxOR0RLeEY2OXdydmo2TGlZcTZLVHJFSk5hWExaRXRZ?=
 =?utf-8?B?MzJ0bjFmMWVtRUJSSnpla01CeUtTN1BxQlhqNkx4NlV3NDl1TzRSR1hCdFpY?=
 =?utf-8?B?V1Z5QkQwVHVYa1JmZXJRQ1ZOREVTWVM3R0ZNd3lBWlZZMUNWUkdhdUtKTW9T?=
 =?utf-8?B?R2JYNXdkcms1QVNQeVBZcHQxSVNWODhIL3A4ZW1UUWxKc3RKdVVIT0V1enht?=
 =?utf-8?B?UkM0bGVyUy9yWnIrVlY5c2g2T1NFK0JWZldzVTd4TkRWaTNYYW82Vi9IQXFD?=
 =?utf-8?B?OGtSR2YvWlo2NzVRU1paSThQRThkc04xcnljZU5nQm5ZWU80S3JmOGJBRUxI?=
 =?utf-8?B?c28rTEhtTDhBMW5MRTI0Y1plZTU5N2h3MjRuekk5eDRBUXVyYTVDcXFVa0Jq?=
 =?utf-8?B?VnhoRUtmMTRIYlZzSnR2QlFLSjJaaUJjT2REY1B1QzZSanhWb2kyTFBxT0sv?=
 =?utf-8?B?d2xGVExacTBmMjFoZGg4YXRQTkxVdmpvcHAyek5mblZ0Vy8vdW5jRVRFbjJG?=
 =?utf-8?B?bDNnMlBicVlBc3dtK2VqdUUzNnF5Y09rRDFBeDdVMFZPd0JnNVFQT0wxMlV2?=
 =?utf-8?B?Qlhtcm1RbFBhSWFDUXFmSGw4ZmV1TzI1cC84UnNRN0hmVjBuN2Q1ay9mWDdT?=
 =?utf-8?B?aGhqdXRCY1FRS05EcU9ob0dmUm9Mck1VZ1BmWVB6UGVQMUFmWHlnZ2l6UFF1?=
 =?utf-8?B?UzNSQ1p0UlBPTnhQQzJhUzRxcmhLTHNGZDdYZW9rdTBFOEdsUlhGc2Y3Y2NS?=
 =?utf-8?B?bFpqR21ENGJvZ25BbUFBNWhybWlWc0xtYW1RQ0FBU0xyMkUrN0oyZDAySVdH?=
 =?utf-8?B?aUgyK1hGWm9OMWYyUEN1dFB5RlVnVUZMNE1ZWkFINFNRYXlYdTR0bWhqSFh5?=
 =?utf-8?B?aU5ndi8vTi9JZitoeHpoZHhWUnJBYTN5MTVDamxyOE1wNFBwNHoxbzh5ZVUx?=
 =?utf-8?B?VkxXR2ZWZGhmNDVIR003MGNoSmRJQzdtQUJtenNBNC81QjNuTzhJcFFodkRM?=
 =?utf-8?B?Ykx4ODFJeHd1bm1OVVdkSUJ6VjJRSzBIOHdHT3AxRHE4bGkreHZSbTYvMmJr?=
 =?utf-8?B?RVVEaGZ6bDRxVEtKRlZBUWY0RWY1eTFBT0xycXdMZzZicFM5YjVGamx1bmhU?=
 =?utf-8?Q?WjJPttaH0BQXhaYZFJRnx17d+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e009e3-9b97-4066-ea28-08dad36e31a2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 07:32:26.2094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tfkVjIXc92hM7u68i00X8xm0LeovZxqo8PGPMIawwjCJmidusT8lxhMVzG4V+Gtq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6950
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/1/2022 12:52 PM, Liang, Prike wrote:
> [Public]
> 
> -----Original Message-----
> From: Lazar, Lijo <Lijo.Lazar@amd.com>
> Sent: Thursday, December 1, 2022 2:39 PM
> To: Liang, Prike <Prike.Liang@amd.com>; amd-gfx@lists.freedesktop.org
> Cc: Deucher, Alexander <Alexander.Deucher@amd.com>; Limonciello, Mario <Mario.Limonciello@amd.com>; stable@vger.kernel.org
> Subject: Re: [PATCH] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the s2idle suspend
> 
> 
> 
> On 12/1/2022 11:52 AM, Prike Liang wrote:
>> In the SDMA s0ix save process requires to turn off SDMA ring buffer
>> for avoiding the SDMA in-flight request, otherwise will suffer from
>> SDMA page fault which causes by page request from in-flight SDMA ring
>> accessing at SDMA restore phase.
>>
>> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2248
>> Cc: stable@vger.kernel.org # 6.0
>> Fixes: f8f4e2a51834 ("drm/amdgpu: skipping SDMA hw_init and hw_fini
>> for S0ix.")
>>
>> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
>> ---
>>    drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c | 18 ++++++++++++------
>>    1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
>> b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
>> index 1122bd4eae98..2b9fe9f00343 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
>> @@ -913,7 +913,7 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
>>     *
>>     * Stop the gfx async dma ring buffers (VEGA10).
>>     */
>> -static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
>> +static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev, bool stop)
> 
> Better to rename as sdma_v4_0_gfx_enable(struct amdgpu_device *adev, bool enable).
> 
> Thanks,
> Lijo
> 
> Ah, before this version I do use the sdma_v4_0_gfx_enable() name in the primary draft, but choose the sdma_v4_0_gfx_stop() for re-using the function name and comment info at the patch clean up.
> AFAICS, use the _enable() name may can match well with the function job which does the SDMA ring enable bit setting, any other reason require to change the name here?

Right, enable() matches better and it's easier to read the code in 
resume function with enable(true), rather than stop(false) :)

Thanks,
Lijo

> 
>>    {
>>        u32 rb_cntl, ib_cntl;
>>        int i;
>> @@ -922,10 +922,10 @@ static void sdma_v4_0_gfx_stop(struct
>> amdgpu_device *adev)
>>
>>        for (i = 0; i < adev->sdma.num_instances; i++) {
>>                rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
>> -             rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
>> +             rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, stop
>> +? 0 : 1);
>>                WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
>>                ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
>> -             ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
>> +             ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, stop
>> +? 0 : 1);
>>                WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
>>        }
>>    }
>> @@ -1044,7 +1044,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
>>        int i;
>>
>>        if (!enable) {
>> -             sdma_v4_0_gfx_stop(adev);
>> +             sdma_v4_0_gfx_stop(adev, true);
>>                sdma_v4_0_rlc_stop(adev);
>>                if (adev->sdma.has_page_queue)
>>                        sdma_v4_0_page_stop(adev);
>> @@ -1960,8 +1960,10 @@ static int sdma_v4_0_suspend(void *handle)
>>        struct amdgpu_device *adev = (struct amdgpu_device *)handle;
>>
>>        /* SMU saves SDMA state for us */
>> -     if (adev->in_s0ix)
>> +     if (adev->in_s0ix) {
>> +             sdma_v4_0_gfx_stop(adev, true);
>>                return 0;
>> +     }
>>
>>        return sdma_v4_0_hw_fini(adev);
>>    }
>> @@ -1971,8 +1973,12 @@ static int sdma_v4_0_resume(void *handle)
>>        struct amdgpu_device *adev = (struct amdgpu_device *)handle;
>>
>>        /* SMU restores SDMA state for us */
>> -     if (adev->in_s0ix)
>> +     if (adev->in_s0ix) {
>> +             sdma_v4_0_enable(adev, true);
>> +             sdma_v4_0_gfx_stop(adev, false);
>> +             amdgpu_ttm_set_buffer_funcs_status(adev, true);
>>                return 0;
>> +     }
>>
>>        return sdma_v4_0_hw_init(adev);
>>    }
