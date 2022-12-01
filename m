Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D263D63F298
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 15:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiLAOUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 09:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiLAOU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 09:20:29 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAF0ABA0F
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 06:20:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIwfFi9Jtj2qA0LTXAlbaX11n+JEABEsTEGtw5okxI+BNeHGYIh89iEjSBoTGyutjWGcLfmJ3pQG6Bsb6HNp/RSEQqotlev4HtEavp/rq33kuQJh7eK3DWAM/zIK8Ksq0b1zhJ7AorgiDgxY31N+4qZqVVbez9F6bJNqeVhdP9QsnBdo8iIan1UI93kRZzrsKEuINZZuKyQLlsDk/tuUj5f0AmkMfjfGCL9eX4wBc1sm5W2Js/oNJt/Gz3TuoFLgp0ZFvmL0be7h8ATenurNUh6Hd4IMxsBc3nsGVtdZ8+DRmvkGzymIQ/9g8h9MvxjoeA6sm7ywhvcG/nreFXSfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmC0ydptNHgmZDno5qJGdVeJNDgYn5dNZkoTqlSuvgs=;
 b=Tw3Wc8Kc2d/PzA+wBXWDLmyscnWdRFrtiNr9nSm3wN1Nir8+7zqJWmXJAu25Q0xtLJJVrNuCgNyaDWqL8W3XkFkXSv5n57MS0PtG4wn3Q/cUOsdayF2EObZR7N2I4+OSqlCbz3key9PVmmD+JHasYfSDi9gkCmc/Ak0pJokFzERxmJBpYEB60//+wdSwaxMkDe5AcoOGV8efZTXZF1bx63L9IiJ+gBPg9AHHGwgbYY1E0eC2dUVcXViFy/6Ul2zEavXxVf0FUvzbYIGI2akvHpwME4uyPs0AVanYj2HC6hT64/c2soZdw0gl0OOLBymhn0tGC0TS8XSzGD6xvbx3wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmC0ydptNHgmZDno5qJGdVeJNDgYn5dNZkoTqlSuvgs=;
 b=MwDez0zor9cM5uy8jTsY2nswuqfpGl6rXuZ9YB/d3lxUHYWBZdhZNv+DrbEjCaLMWNSsYBQEod2A4Yxsr2ZccLzoYaV03/5xpeG42deeAFpLAgA5fLVhnL0rCO24FPIht1Lzptub6+LbXqFlI1x4Nw/8VLLeCCxYxe728S4hbKU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH8PR12MB7135.namprd12.prod.outlook.com (2603:10b6:510:22c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 14:20:22 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%4]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 14:20:22 +0000
Message-ID: <d7b9a08d-8a82-7ea5-cc57-edeb0a541c93@amd.com>
Date:   Thu, 1 Dec 2022 08:20:20 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the
 s2idle suspend
Content-Language: en-US
To:     Alex Deucher <alexdeucher@gmail.com>,
        Prike Liang <Prike.Liang@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Alexander.Deucher@amd.com,
        Lijo.Lazar@amd.com, stable@vger.kernel.org
References: <20221201075631.983346-1-Prike.Liang@amd.com>
 <CADnq5_MoME88oiE2yr=BPNr-YN+UncNifPJr4Ux+hh+A8vPNwA@mail.gmail.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <CADnq5_MoME88oiE2yr=BPNr-YN+UncNifPJr4Ux+hh+A8vPNwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:806:27::25) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|PH8PR12MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 8813be68-0d87-4034-51b5-08dad3a72e7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I7DWcN/lJmo4pa/9MValEg4hm3WgzySJA1W2UZCqsMULYvzR901moFbdVmZb656b0d78p03yM3vx96/bVW7vPPiVqpJvzO//hNctqBU94iZuZrmNgrn6S0EnVOqOT5hAAWzXmlwWCyvXD0IDZxlg8kMqmEhPdrHGCtzzQX+t3IRtttnaWZOS0XLwFDiOkK41KQO0ZMgTDlRgYhYKFA3zQcCYfaXh4NYNjRMWXnqR7IdcgGy1usQEhGWocC2z9Aq1XOgq4fI3asKYFMaxVlMET+VbKOf/7iYTBXHCsbhBr09O4ijnccbAf+THnsdAha06XAh//blYiWb2b8dOncTKhbhfU9a2aH8TUB0ZscaTv15Za19vfM3Cftl3lB9+1H/2ygF/aQMR2ee1LKjZxdlQta5P3w+8takblNMfrO4ztIk4vSR7S7qMhEl3iW55KZIPtbsb5O2nOAOxVCZY1TikFLJoTbl9uO3o1/gpng2GGcephyDwrYFfoGZvMuYG0cedHD6mPrXx5aJ5CQdcFsy6OKXSFlM+zWQqjk4Jqnm/YQVzizaUj6z8bj/tY0BgLQGe/UySG88KpltFc7PkNly6+dhVpVMk69ANEVBOktim1P0QSN52PW1UOQJuwW0Db83zHZulpirSTjvP47hnHZ/0GXqfLJchwl16XBdN/bmk+FJTJ88/IpUbeksZrTFYFsGq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(966005)(6486002)(45080400002)(53546011)(5660300002)(478600001)(6506007)(83380400001)(36756003)(186003)(38100700002)(2616005)(26005)(8936002)(6512007)(41300700001)(2906002)(31686004)(316002)(66946007)(6636002)(66556008)(110136005)(8676002)(4326008)(31696002)(86362001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmFXVVo0ZERVNCtIS3RiRUhRS3FLQ2tGRjNMVjNqRHVKWVVZQmJsdUg4N2ZY?=
 =?utf-8?B?S1FsbkpqMXlkTVdrMFB3N3h0Z1ZJSExGQVpTbDF2MHRzZ2xHY29UVTB6cUYy?=
 =?utf-8?B?WHNYOFVZd1VkNXdUenZPUnlLZmJCQWs4M1RYd29vcHovdlhyWC9UZnVmcUZv?=
 =?utf-8?B?L1l0M0gzRVBtSjNSTlpVRkw4Tkh6WUxzdnJxT1NzWHVkS0FGRHBuNUcxTWpO?=
 =?utf-8?B?Qk1CMklNY0RvTm1wT3hpOEFGL0JWUGw1dDFSQWd5amwwbkZpTy9MTnJZQjdW?=
 =?utf-8?B?UnRlNms2YUo1a1RhODZrbXRZRVZZMEJZSXlWRG94QzQ5L29uQTd3SHBJY2dO?=
 =?utf-8?B?NWJrazZQR253UkY2K2NkTFFRajcxSFRjaTN2QmRLZjdjUDg4cnlOaUMzYTNu?=
 =?utf-8?B?WXZOYnpzck9jcDJkOGQwbDJOTklzVGtsT0NEaEF3c3VpbTZNeSsvcUlSVFUw?=
 =?utf-8?B?aU50NHA2OE1FK1ZBVHhNbVZMcCtObURUWVFucm8xVzFEakozaVlrSnJQaVRU?=
 =?utf-8?B?MldTUFFFTnVZWTJLQjgrU1VqMmNTb3FBQ3Q5akxQS1Ura1Q5VmR1dEQyNGlM?=
 =?utf-8?B?aWZwZktKajhzUDlraTVBY01jazZPWDdnc2hKeDRFOTk3UGxYZzZQZ084RnI3?=
 =?utf-8?B?THdiaVVIMXZVanZzZm9XbkRtSVlkc1JidzQ2RHpOaFNYbTgvckM1SldqanRB?=
 =?utf-8?B?RExsdEM3MWNwTjV1cmdvcFpmU1JMV3NnUWJXSDhvcUVTWjdVSS95TmxObTdD?=
 =?utf-8?B?V1lJNzlyMEhpSnZ3R2FvaTQ3VmxzT3Z6MkdvWXRzVnZ2ZCtudkh5aDJmUVpR?=
 =?utf-8?B?MXhGS3VvSzREK2d5SmFRbVZxNncwOGRrN0N6bXNtcUtlbmR5VmdnV0wyUTRt?=
 =?utf-8?B?eG5tYVRob0lLS0xvODk0R3MwUU4rTmt3blZNTDlRMkVWNEczMVVQTDlQellm?=
 =?utf-8?B?bkhDOU9EaGNzby9tb1RmYlluVGtKSVVVYkk1bXdlbnVjMFczNXQwT0V5L29O?=
 =?utf-8?B?OXU2V1Rsa3FoV1dYblRzZGN5TWl3a0dwbDkybmw5dmptcGlQWFNwMXh1REFa?=
 =?utf-8?B?amlqbVdvaGRFa2xHUGppUUUybzF4UklqZFQzOXljZ2VlWXZzc1VtWStUZzdY?=
 =?utf-8?B?TzkyQ1ZFOXpZMlhZZ1VSQzQrRVBvOEdoTnlqdFJ6U2x4Mzg3aE5mUDlKQy90?=
 =?utf-8?B?ZUFVU2txNkFFTno5NWVPanBlczcreWkwdkNyT0JNWVFYM0VacFptN1ZmQTlt?=
 =?utf-8?B?QjlGQWpvRnhjNUY5ZjNEampNZ0xVblpIRTA3NzZOd3FkOGRweWVVQ0h2dU0y?=
 =?utf-8?B?cnlqM3NmZFNGQW13ZmNXVmZTb3UvbzZIcWxSQzhrL1psc3VsWUlmdmFYYXho?=
 =?utf-8?B?T082Q3dGS2RTN084TU95SWtJSC9jUFpndnBmOHFEZmY0MFVkZGZCWkM0SXBh?=
 =?utf-8?B?b1BUOUNUQkJ0RzRxYWJ3b0NjcUtxQldRNFcwWEtNT0ZNUFRXQ1Fmd0wvZExq?=
 =?utf-8?B?ZWdNN0lFclRSQlJwcG5UaFJMUWMzNEFGcEUybTk4MzdwSGsvT3lmbTRiSzBu?=
 =?utf-8?B?UWY0Q0ZZSFMzS25qcGVvbEJEU3dCUUVjZXBwMDRxMmRxL0xnblVvRC82ODV0?=
 =?utf-8?B?aTNEWGROSmNZZDlLdXBqbDdXNkQxV1EwYmsweXIvTHZDaXc0VmRLR0Rwc3lC?=
 =?utf-8?B?a1pLQU1FZzRzczd6MFkxVUprajVONE5rRC9abzl6TzdGL2hwSDFLbXFlYWx3?=
 =?utf-8?B?YlJPYlZNR0tIRmI4L0Vxam5ibnZtY2RHeFQxMWp0MXRsZVlodUtDZ3FhUndC?=
 =?utf-8?B?V1IzQnNKQU5uTGZvdDdSOVhsVzlzWjhBamwwd28wamJkR0NWSmJBdUVVZGRn?=
 =?utf-8?B?V3NRdzVhRmJpWE5NT3BGck8wN1V5RGxwUTAwQWdCK2RXaDVpcFNkYTZTVEpX?=
 =?utf-8?B?Wk80aFlXTmRTRnNpaElMeHlsSlRQZXZ6blVLdCtQM1lCai9SYzN3MlV3R0ZV?=
 =?utf-8?B?MUgyR05haWk0SnVjZThtZkVRL3VPRVd1bVRySGdFK2hENmd1UWF6RTR6NmRk?=
 =?utf-8?B?MEkzSnpDaW5FR2dBdGFaSktzekhtSWE3NWpudHhkQ1czSHhHd082aCt0TGZ6?=
 =?utf-8?Q?rG1Lw86o5xJXnmrXF6I0Gg+1x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8813be68-0d87-4034-51b5-08dad3a72e7a
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 14:20:22.0832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eaTJ1pQ8qzracDt1yNrFTY8qVlcHOHwlC4v7Td9JKrSQSLXNzx4a9GFDif0ZrA96Zi8eWzpJADUpSiU/qws/5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7135
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/1/2022 07:39, Alex Deucher wrote:
> On Thu, Dec 1, 2022 at 2:56 AM Prike Liang <Prike.Liang@amd.com> wrote:
>>
>> In the SDMA s0ix save process requires to turn off SDMA ring buffer for
>> avoiding the SDMA in-flight request, otherwise will suffer from SDMA page
>> fault which causes by page request from in-flight SDMA ring accessing at
>> SDMA restore phase.
>>
>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fdrm%2Famd%2F-%2Fissues%2F2248&amp;data=05%7C01%7CMario.Limonciello%40amd.com%7Cf85681a1e6704044f60708dad3a17d61%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638054987793833283%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=mUTB99mZYEenu1iBYJSuNRIVClonl5bXtS7jhMJJj30%3D&amp;reserved=0
>> Cc: stable@vger.kernel.org # 6.0 >> Fixes: f8f4e2a51834 ("drm/amdgpu: skipping SDMA hw_init and hw_fini 
for S0ix.")

I double checked and f8f4e2a51834 got backported to 5.15.y too as 
960c8a55016b.

So this should be:

Cc: stable@vger.kernel.org # 5.15

>>
>> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> 
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

Tested-by: Mario Limonciello <mario.limonciello@amd.com>

> 
>> ---
>> -v2: change the name sdma_v4_0_gfx_stop() to sdma_v4_0_gfx_enable() (Lijo)
>> ---
>>   drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c | 24 +++++++++++++++---------
>>   1 file changed, 15 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
>> index 1122bd4eae98..4d780e4430e7 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
>> @@ -907,13 +907,13 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
>>
>>
>>   /**
>> - * sdma_v4_0_gfx_stop - stop the gfx async dma engines
>> + * sdma_v4_0_gfx_enable - enable the gfx async dma engines
>>    *
>>    * @adev: amdgpu_device pointer
>> - *
>> - * Stop the gfx async dma ring buffers (VEGA10).
>> + * @enable: enable SDMA RB/IB
>> + * control the gfx async dma ring buffers (VEGA10).
>>    */
>> -static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
>> +static void sdma_v4_0_gfx_enable(struct amdgpu_device *adev, bool enable)
>>   {
>>          u32 rb_cntl, ib_cntl;
>>          int i;
>> @@ -922,10 +922,10 @@ static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
>>
>>          for (i = 0; i < adev->sdma.num_instances; i++) {
>>                  rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
>> -               rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
>> +               rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, enable ? 1 : 0);
>>                  WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
>>                  ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
>> -               ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
>> +               ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, enable ? 1 : 0);
>>                  WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
>>          }
>>   }
>> @@ -1044,7 +1044,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
>>          int i;
>>
>>          if (!enable) {
>> -               sdma_v4_0_gfx_stop(adev);
>> +               sdma_v4_0_gfx_enable(adev, enable);
>>                  sdma_v4_0_rlc_stop(adev);
>>                  if (adev->sdma.has_page_queue)
>>                          sdma_v4_0_page_stop(adev);
>> @@ -1960,8 +1960,10 @@ static int sdma_v4_0_suspend(void *handle)
>>          struct amdgpu_device *adev = (struct amdgpu_device *)handle;
>>
>>          /* SMU saves SDMA state for us */
>> -       if (adev->in_s0ix)
>> +       if (adev->in_s0ix) {
>> +               sdma_v4_0_gfx_enable(adev, false);
>>                  return 0;
>> +       }
>>
>>          return sdma_v4_0_hw_fini(adev);
>>   }
>> @@ -1971,8 +1973,12 @@ static int sdma_v4_0_resume(void *handle)
>>          struct amdgpu_device *adev = (struct amdgpu_device *)handle;
>>
>>          /* SMU restores SDMA state for us */
>> -       if (adev->in_s0ix)
>> +       if (adev->in_s0ix) {
>> +               sdma_v4_0_enable(adev, true);
>> +               sdma_v4_0_gfx_enable(adev, true);
>> +               amdgpu_ttm_set_buffer_funcs_status(adev, true);
>>                  return 0;
>> +       }
>>
>>          return sdma_v4_0_hw_init(adev);
>>   }
>> --
>> 2.25.1
>>

