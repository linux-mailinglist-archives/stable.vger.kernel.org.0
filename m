Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3A16E4D14
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 17:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDQP0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 11:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjDQP0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 11:26:00 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9984CC148;
        Mon, 17 Apr 2023 08:25:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1sgzki8fNMm7UgKDBHCuXRlHaOUa7NTwSA+FWb2Ywdi/qLdrdhNyLYPhE/HfVlkWGtJcUqQN8hmsjA5933c8j8HkGkQiiuHDaVfuHLCbVyd3FzeHjrKd4kRFzY3Qe9TO8JvX+DATc/7wFa8zKFFqSr1AYIm38jNmav3AzYzImZhTHuabkKtRROg9lwvXKHWPtjGG8EuUVjl6FCqiP0pr7ahjsOruEDuOJ+KAQiDJhb9SVfT74r0cygqVKz1UFqLBTBy5sge52EYAqzblpoxPw1BMkR1bhFOOS9mdOCR1ZShSefEYIULK67MvMdkWu1ncQYor5ey/M+ex+lp0zrXKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3LYBjLhjKTa9Z6Ur5ecMm7h/kC4ttjbjgGjO1ZxVm0=;
 b=ljYz+Z/lm2VrvXuKbcnpgEQISmzHS+5Kz9tTHuP0aENilRoy8MrHfbtaFGmAD5VgCxDp21PlN9L4t/tHq5TiQqMPz+3/bXgmB7ZQpjSdlhUkMhJS3bpSGR59r7jp8Zm+vGOpxoUxWYflXqlF1PN2edBDq0ReOyVvc2bJsZK02Qin3I/7tv7sm4OtmbhdN+a/5Ra0J67RTpUe8W9GFTRbqCb2zRL7LlsiEZl4t8DJjJ7Yx2OH1iXhlyZorQ2XiawqUayQZOABhjXfPRK47xM/bbk1VJPT82d7tjkjNZWjloiefUgqew5c/+DWSy0umCLcOJzLQHU63F1BVtNqaYdUcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3LYBjLhjKTa9Z6Ur5ecMm7h/kC4ttjbjgGjO1ZxVm0=;
 b=kWMHZJ3b8pPI5njyjvZTUsJjylGlQrihWs1CI89uvxvzKPNnPE7dFBlmcEwgRtw0kAyMjHQFxfQ1OEOArSi6+hicbbZwu/ucwh1JUiY4PiJjepeikWbfGjk4uT0iZnaK+yX03pF/ipeqUwRLmMwz9l7woONfioV+CrB+SUTlhJ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) by
 IA1PR12MB6387.namprd12.prod.outlook.com (2603:10b6:208:389::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.35; Mon, 17 Apr 2023 15:24:30 +0000
Received: from DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::fe53:2742:10f9:b8f1]) by DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::fe53:2742:10f9:b8f1%9]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 15:24:30 +0000
Message-ID: <b112c88a-c3b2-67a2-b401-8d8962bbe01b@amd.com>
Date:   Mon, 17 Apr 2023 11:25:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] drm/amd/display: fix flickering caused by S/G mode
Content-Language: en-US
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230414193331.199598-1-hamza.mahfooz@amd.com>
 <4207e848-4e79-29a7-2bb0-44f74a2d62c7@amd.com>
 <23ebe744-bd4b-c411-99f1-c4ae9dc132f7@amd.com>
 <d9fd286d-7f06-be80-7b81-b2aa2c074f1f@amd.com>
From:   Hamza Mahfooz <hamza.mahfooz@amd.com>
In-Reply-To: <d9fd286d-7f06-be80-7b81-b2aa2c074f1f@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQBPR01CA0100.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::36) To DM4PR12MB6280.namprd12.prod.outlook.com
 (2603:10b6:8:a2::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6280:EE_|IA1PR12MB6387:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a4b761c-abe2-4de0-17c7-08db3f57d6ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2FBh5AzonW9GyW7xzxuxUvCNLCwLaaCyHjZBgwqvM1FAyfjHYIWeaD3f69IeAsPSbe8ExjwWmOBoetZ4b0MvfntklytGdWRTqH0NUMD/369MvAOsX/+qIyjANxUmCAPcj9oIjFmy1RvZX7WyYsgL/5Kd/keUCS2tcaZJ5KFIbwUdux3MMLFY+IpOPw988a+FMQVUv+V+qE/DhpeylZxbYiuGfmNxNEylqRW7JUg2MW5nt8q9HhzeSkDkgTFDnZ1dPicu8UuJyBdrZX4kis7hqkz2kdV3xuTOEbYttjBLuex4QU+f3lyMnyt+xrQWlkYGCXsdIgCInKCRiQBmt4ZRJGbcjHpOgbPCpiuddPJ2fz7/e77sSBP75cJhVEA09y/68XRwHRWRV1C1a6QPwI3xwN+Wma5O00sPPSliqF7x0Mh6ShrPpx1C2Q76sSajmJUeVl1BInGu2VSDfBeWGpW3GuxskeXQuFDZI6bGnGw3gZ2qV+tLYxPwTx0tvUbeMlhpuZHXKMyYUxplyfQ6sIfmzJS/u0PTWLCQCHHSo5RfNMdRPKEz51RiIr1WYeU3hwsJeAoJIx98Oqtw8xdK3dpYnwn6e+8L7xA7uz+zla31k9JOEyuNor4Vbq4L4CpiGWY7A54ijpwRb3V+3rD+T6Gc3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6280.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199021)(31686004)(6666004)(478600001)(83380400001)(36756003)(38100700002)(66574015)(4326008)(31696002)(2616005)(86362001)(44832011)(316002)(6486002)(8676002)(26005)(5660300002)(6512007)(6506007)(186003)(53546011)(66476007)(2906002)(8936002)(41300700001)(54906003)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkxsVmNiRWZicmZYRU9GVy9kNFRnU20rcHhFc2xjZHF5b1pDcXY0STFkLy9q?=
 =?utf-8?B?NGV2YXRrb05kVDQ0Q3pSNDlyNGIyMEZkQjBacGxuQ1MvWWVQa2R6L1JWb0pl?=
 =?utf-8?B?VEhNN0FzMmlwMUV0ak53N0dpVWR5Rjdmb2F5blBNNGU2WkJkR1E2OFRNSWRU?=
 =?utf-8?B?OW40V2wxb2xZQVV4SjFoQnhBQ1VpWWtRNStGc3FIZklCeFMrNmVkOVhXVDhk?=
 =?utf-8?B?OUR6VlNzYmpacjE1cTdMN2dqL3NpWWxEUDBiaEtsUVh2Vk1rWkRiTkpPRDFw?=
 =?utf-8?B?MXV6ZmN6cnhUUU1lak50TVJjWWRSblpSQ2RPRlpJZjZGOW5Nc0dlSjFmVSs4?=
 =?utf-8?B?alJZOWpBdkVpWWtQZVF1YnlCNThBbzE0YlZUUTZCY05mT1R0aWw4VEZnL2lk?=
 =?utf-8?B?VWJNTUZZak1kL2R2cms1Ymd4dGRmU3hYMmpMR0dpSEVtempRUVBySFQ3aWJ2?=
 =?utf-8?B?VUR1K2t6dUNmWEptL2RVdERWaEZnTnNvMEc1Qm0rK04yQWJDRUVGUXlCQVls?=
 =?utf-8?B?NWcxYkR0WHVXWklTTTNSaHZWaUlWN3liY1FvZFRiY1VxeVdpbWQ5Tk1aS2ZQ?=
 =?utf-8?B?bDZ1V0lLUEkzYXc2WGZ4UDJJemw0VEFRT055ZFU0TDFQSFpZSWQ3VzBvdnFH?=
 =?utf-8?B?Z3hrY2NoaDNXdUNtakFtL01NdCt1eXp2SzhjS1VLY1J2MGZYN0FvVlpwUHJu?=
 =?utf-8?B?ZnRvQXo5OTlRNk95Z2hqTHBFMzQzeVM3TVM2dlVZUmFvRE81R2YyZ2t4TjZT?=
 =?utf-8?B?dTQvWmpGSE1PMnA3OG1uMHJURWl5L084elZSZTlFZ1duZ0hwZ09jTjdBNGNk?=
 =?utf-8?B?M0JqMU80THZGSS96MXF0YkVvUXQ3OVBhYzBSOGpsdysydUhadi9ScmU5V0Qx?=
 =?utf-8?B?YWxzUFEvN01PTENpSzkvZnhJK2M2eGMwNmdOSENvNEJNQW1RNG1TczNXU0Fx?=
 =?utf-8?B?VnlDR2tCbHJ2dnhRQzA5cG1pbG8rdjNVbStXeC9IdXYxYkdNUVJqdkxjY3B2?=
 =?utf-8?B?VVRYdXV6SyszaW1QZllteVFNZ0hyeGNEc0dRRXFSQ0kxWTBoZU1hTHJVOE9x?=
 =?utf-8?B?djEvMEw4RlhMMzE4V3Q4N1NCY0hUL2VBbDRRRjFCZU5rYUlHWUdOUjlpV3lK?=
 =?utf-8?B?S1pzR2NkRVREWnFOU1d3TklIWlRJNklaNXJqRUZPT1NEMmNjcjdrNnYwZitx?=
 =?utf-8?B?Z3dRaDRWN0lWSC9HSHFlbWUwTzNibVRMSDVrRy9qYmlVcjdDc0FFT1hKQUhV?=
 =?utf-8?B?ZTJJZ2FBUXJhMVRSYm9sMzJKSnFaS1dLR0Y4VE5PUWRWbGh3c09ZUzduN1Nz?=
 =?utf-8?B?WDAwaHU2aVQ5T0txK09ENitSMDNJT1dUYldCbFNEOGFSd2tqeXo1dFZzeFpq?=
 =?utf-8?B?Y3FDRGxwcm9mcGdBT250NFJIOEpTNG9lT1F0M1FkMW9RSlpYRnM4VjNGN1RQ?=
 =?utf-8?B?SjlyaGt3Mmk2dmFPUWxlbnJFd0M5OEhvWE9tUm9PeE1lVnlVclV5OTNtdFRs?=
 =?utf-8?B?WlBkQi9acGlnd01ySGJDWXRMVmFwanp3bjFFY2N5a1JhV0t3REM3T1Axc2dR?=
 =?utf-8?B?dVg5OE9KRUhOc01yMkJtNmpVZmlxNmNML3dBTGdlU2dEWVJsVXpIUHVhQVla?=
 =?utf-8?B?MWlsZ3NqbVRxNVZ2VUFlTlcyQUF0eERQTFhxUkRXeG1XVWRUWnJkUTNCTldt?=
 =?utf-8?B?MTU2ckYvdXhEcWdpTmRJZk5ycmh2bndSZFFSRzNKUVhEaTZ6b1RSZi9BR3Fr?=
 =?utf-8?B?NlIvRlpzbDVGY2p1ZjJ1bmk5SVk0Ry9hTTcxYllWSDR0dzNZS0VWOUtWaTJh?=
 =?utf-8?B?YUJrU0FPYi9QV1pOVFdMVGh5ai9vSllIRnBENHhCS2RrcXhZTjRpNkdVWjNs?=
 =?utf-8?B?WXowS3gyQ042VC93UUJMNFl3QlNDRG9JSTVSUFkyQ3JJeWtwOW15U3NTVzVj?=
 =?utf-8?B?S09RajRFc21TZHlkQ0ZjcFhEb3dsTU1XMGtvL0dxWkpUZGcvbHk0TmFPYlF6?=
 =?utf-8?B?bkxvTU5Pdjk4cThsTmM5MFZDKzlaeGpDMFViaHhTbHVPWE9McjhlaWN2clFu?=
 =?utf-8?B?MFMwUTFPOGcxRFljNmxhV0pvVExCOWN5ZFR3OFJEZzIvYTBpeGxHTmRjbSs4?=
 =?utf-8?Q?BcTGs39LrYbgWh+8X7KH8XYkI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a4b761c-abe2-4de0-17c7-08db3f57d6ef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6280.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 15:24:30.5848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQK7FAekqynfXGlMaGpk9fH/hdY7+p3HV2a0zDVcOYT/BpyVJXGwa9yCDFGBHXSO0I5btGlqpIUjo0R0fKCDUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6387
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/17/23 11:03, Christian König wrote:
> Am 17.04.23 um 16:51 schrieb Hamza Mahfooz:
>>
>> On 4/17/23 01:59, Christian König wrote:
>>> Am 14.04.23 um 21:33 schrieb Hamza Mahfooz:
>>>> Currently, we allow the framebuffer for a given plane to move between
>>>> memory domains, however when that happens it causes the screen to
>>>> flicker, it is even possible for the framebuffer to change memory
>>>> domains on every plane update (causing a continuous flicker effect). 
>>>> So,
>>>> to fix this, don't perform an immediate flip in the aforementioned 
>>>> case.
>>>
>>> That sounds strongly like you just forget to wait for the move to 
>>> finish!
>>>
>>> What is the order of things done here? E.g. who calls amdgpu_bo_pin() 
>>> and who waits for fences for finish signaling? Is that maybe just in 
>>> the wrong order?
>>
>> The pinning logic is in dm_plane_helper_prepare_fb(). Also, it seems
>> like we wait for the fences in amdgpu_dm_atomic_commit_tail(), using
>> drm_atomic_helper_wait_for_fences(). The ordering should be fine as
>> well, since prepare_fb() is always called before atomic_commit_tail().
> 
> Ok, then why is there any flickering?
> 
> BTW reserving a fence slot is completely unnecessary. That looks like 
> you copy&pasted the code from somewhere else without checking what it 
> actually does.

It seemed like it was necessary to read `tbo.resource` since the
documentation for `struct ttm_buffer_object` makes mention of a
"bo::resv::reserved" lock.

> 
> Regards,
> Christian.
> 
>>
>>>
>>> Regards,
>>> Christian.
>>>
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible 
>>>> (v2)")
>>>> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
>>>> ---
>>>>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 41 
>>>> ++++++++++++++++++-
>>>>   1 file changed, 39 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c 
>>>> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>> index da3045fdcb6d..9a4e7408384a 100644
>>>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>> @@ -7897,6 +7897,34 @@ static void amdgpu_dm_commit_cursors(struct 
>>>> drm_atomic_state *state)
>>>>               amdgpu_dm_plane_handle_cursor_update(plane, 
>>>> old_plane_state);
>>>>   }
>>>> +static inline uint32_t get_mem_type(struct amdgpu_device *adev,
>>>> +                    struct drm_gem_object *obj,
>>>> +                    bool check_domain)
>>>> +{
>>>> +    struct amdgpu_bo *abo = gem_to_amdgpu_bo(obj);
>>>> +    uint32_t mem_type;
>>>> +
>>>> +    if (unlikely(amdgpu_bo_reserve(abo, true)))
>>>> +        return 0;
>>>> +
>>>> +    if (unlikely(dma_resv_reserve_fences(abo->tbo.base.resv, 1)))
>>>> +        goto err;
>>>> +
>>>> +    if (check_domain &&
>>>> +        amdgpu_display_supported_domains(adev, abo->flags) !=
>>>> +        (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT))
>>>> +        goto err;
>>>> +
>>>> +    mem_type = abo->tbo.resource->mem_type;
>>>> +    amdgpu_bo_unreserve(abo);
>>>> +
>>>> +    return mem_type;
>>>> +
>>>> +err:
>>>> +    amdgpu_bo_unreserve(abo);
>>>> +    return 0;
>>>> +}
>>>> +
>>>>   static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>>>>                       struct dc_state *dc_state,
>>>>                       struct drm_device *dev,
>>>> @@ -7916,6 +7944,7 @@ static void amdgpu_dm_commit_planes(struct 
>>>> drm_atomic_state *state,
>>>> to_dm_crtc_state(drm_atomic_get_old_crtc_state(state, pcrtc));
>>>>       int planes_count = 0, vpos, hpos;
>>>>       unsigned long flags;
>>>> +    uint32_t mem_type;
>>>>       u32 target_vblank, last_flip_vblank;
>>>>       bool vrr_active = amdgpu_dm_crtc_vrr_active(acrtc_state);
>>>>       bool cursor_update = false;
>>>> @@ -8035,13 +8064,21 @@ static void amdgpu_dm_commit_planes(struct 
>>>> drm_atomic_state *state,
>>>>               }
>>>>           }
>>>> +        mem_type = get_mem_type(dm->adev, old_plane_state->fb->obj[0],
>>>> +                    true);
>>>> +
>>>>           /*
>>>>            * Only allow immediate flips for fast updates that don't
>>>> -         * change FB pitch, DCC state, rotation or mirroing.
>>>> +         * change memory domain, FB pitch, DCC state, rotation or
>>>> +         * mirroring.
>>>>            */
>>>>           bundle->flip_addrs[planes_count].flip_immediate =
>>>>               crtc->state->async_flip &&
>>>> -            acrtc_state->update_type == UPDATE_TYPE_FAST;
>>>> +            acrtc_state->update_type == UPDATE_TYPE_FAST &&
>>>> +            (!mem_type || (mem_type && get_mem_type(dm->adev,
>>>> +                                fb->obj[0],
>>>> +                                false) ==
>>>> +                       mem_type));
>>>>           timestamp_ns = ktime_get_ns();
>>>> bundle->flip_addrs[planes_count].flip_timestamp_in_us = 
>>>> div_u64(timestamp_ns, 1000);
>>>
> 
-- 
Hamza

