Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE026E4BDF
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 16:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDQOuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 10:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjDQOuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 10:50:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881F45FEB;
        Mon, 17 Apr 2023 07:50:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPbSMLtW2YJa5q1fC2Cs8HYZOwT0C4tujyWjp84ERqBem5qWGe+YuQwv76Tr+TzmvSyRIfJrIPTuCeZvIavAJfpKUA1vfSmA+kPsoswvCFBEZ2jKh6fenzRhfpjP0JmFmsqulAYhprS+fcYnqRDuGuuJ1DRh+BZ1yyJ8XvULTshqwX8Lz8Q94kKCAksFesLxgAURt00R6Hwom9Z43FyHUtRRbKMmuRKJU0wwqGMicw2HtItLK9qrbcJKHoQx2GTFC09OYvWIkIIcSUVlM7ZSPyHckK27q758XeZj0hHm2K3en6IFS2NV7gZ/guYmpiPCF5zPIw9TXn4dhmlNUW0cvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqugtRSDp4+qn6TJRtLduMN8tGxJsx6gAidfA8zbH4I=;
 b=nj5InTCbHLLFXxdVF2G9rqkdQAi430LcUuEQk4cUtqe1B/7s2Xc4/ImcB4rMgFgD2JEp+QQpaz1hF40hq3ZibCtPq7rZzHC4RZ+CZz+jx/oN9yoPZR6yLcggbGhB90+IhpPZlMfkYQQN02uVqsRFpDvNGKCzV1AGmvFJ6eYB1quxHmq/JfRg1KdOjXZI8N2Prapr3gUlh/uCpqGTy18qChAx3ilq3tITUBKl8XNeHUgtn5ciN/1TIveqPXIwjME914DFuIAMdGT7OudRpLqt2NbiQi1GoomCXU2ogi87n3WFg9U14qul5PK7DrZQPbXbd2vb8OvWMTzuCGfLfvzKKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqugtRSDp4+qn6TJRtLduMN8tGxJsx6gAidfA8zbH4I=;
 b=4ZbwlieJnUKZpY7Szlxn+UpFNkWlZaU+L/lIWZw3RYWNi47PzeBYsYLDREAti8/TRTqbOxLafeD1bUmPOQ8zxW1rDHhrgObW2A0QfvR1LHUbI8+Ltd1fiMUhAHqLHyYIPWM2DD6TrfKhlZP0cfHNmGoaRk6YO9UPNK1WwTduT+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) by
 BY5PR12MB4918.namprd12.prod.outlook.com (2603:10b6:a03:1df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 14:50:06 +0000
Received: from DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::fe53:2742:10f9:b8f1]) by DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::fe53:2742:10f9:b8f1%9]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 14:50:06 +0000
Message-ID: <23ebe744-bd4b-c411-99f1-c4ae9dc132f7@amd.com>
Date:   Mon, 17 Apr 2023 10:51:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] drm/amd/display: fix flickering caused by S/G mode
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
Content-Language: en-US
From:   Hamza Mahfooz <hamza.mahfooz@amd.com>
In-Reply-To: <4207e848-4e79-29a7-2bb0-44f74a2d62c7@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQBP288CA0019.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::25) To DM4PR12MB6280.namprd12.prod.outlook.com
 (2603:10b6:8:a2::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6280:EE_|BY5PR12MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f7d0758-7dd8-488f-87e8-08db3f5308b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cxtVE93PNwy87R0aE3uurJLT1JsQYPcJewiHWTrqwDApOctP841bFP719374x+QVdDnOPO4/3OlRGMGUaqZJ4a24A/m5pg104QlrZD5WwOpmr5VxHy1/NFtvaFPYIXnVGYfyX/+Ey8Nk28cl7l81JNa1Iwo/3IPMzx49FpvPkXIaUOHFScg0iPJPfMrljNkGwax/voyOhL4k1j6eAZp+rJcJ/nxSIN7SHUgbrIG+ryx79p7gazrr9Swj+oDpHF1AIcDeVxEvZ37f1V2vEponz4rHNvqzQnF+bOTgp40AyFk/EtGIymLp1KFpPcYuIEmT5ciInIHr5yC+HG9XRzaEJmRsCdtjWimxw1SnbPEF5KMcBMbPZJsSHLZSF5KcQ+fgvjDsSAGpgUkY9bNYVu5UrcKaN2qJSXclEIM3rCYr4Gi3TuwNriiqN/tls1fvgPQ6PsToqE3JBOChegYA4TeYJEqs9wIDBllXhW/FKTdoBAdtJwDr+P8HRQCoy78W4tg8ORSrHWVObaH0ZyKUHB16Aojc3s3DjJ+uf6zTiidENi7ZEG9Hk/yPe0Udnr81Twv9WSvgT0Ce2hynZLfczAiKUmqbqMdEH3MSB3kFEnfRP9U1j6yaGCmNBGwXUfpeSV5rUxqU9FB+GkAOgrUPPPC0LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6280.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199021)(5660300002)(44832011)(2616005)(86362001)(31696002)(83380400001)(66574015)(53546011)(186003)(26005)(6506007)(6512007)(38100700002)(8676002)(8936002)(54906003)(478600001)(6666004)(6486002)(316002)(41300700001)(36756003)(66476007)(66556008)(4326008)(66946007)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODVXVmdlMG5Ba2RYMHJjN2UyVVpCRkhvTkVhUmRLN1lDb0FWdHBHNmVBeklr?=
 =?utf-8?B?N1JEc2lNaTN6Q0MzQjZhdm9jQ2Qrb1R1bVJ0Q1hRWkdxdHd3QzY5R1FmNjRV?=
 =?utf-8?B?MU9mdnF5TmNpa1NjWXErM1FPQTlhdGlyOWdyNFNvOUNkSWJRNjJrU2NQbk5v?=
 =?utf-8?B?SVFWM2dKd0t2V2k5ZUdlL2U1Vnc3VUhGWnNidWk0d3RWWDc4eXJXUHhlOGx3?=
 =?utf-8?B?UHh2QmVPVUlrTm1sbHcwWHBDSWNpQUhpcFdPTHE1TUc5VEFrSnFLeUlIT0l1?=
 =?utf-8?B?QnExQXVuMXNNQWl2czVzVnJEQ1N4dFVlOFFJd1dlcEo3MVdZcWlyd25JVDhy?=
 =?utf-8?B?blVBSnBRQ1RhY05yd09UWUxoNEFyUnVZWHFTNzdoYUo5VzZ4NDRGMEhpdGQ0?=
 =?utf-8?B?c0EzR1BrMTF4c0M0a2NWK0gzSE1xU3h2bWM1N2cwYXhjRFdVcTZlWUEwL1Ev?=
 =?utf-8?B?TjZxcXF0Q29iTTV0ZGpTYTVjYUM3bGdvRnpXYk42SDFiK0UwWVVoKzUrRDln?=
 =?utf-8?B?Vkt4cHp4ZVg2RTI3RzVpRWYzdU9zZmlvRkVxeHI2akRXV2gyb3RTV2l3YWxH?=
 =?utf-8?B?RlhRSFdTM3M0MUxMTzNvMUdmOUZNWnN2MGtCSHE2RWhqSTVFbFhmY3pqMUsr?=
 =?utf-8?B?MkRYMytIYU5SeGxSV1FFZFQwLzVhV29mZGxoT1Z3anFTQi8xZ1FZZjdZUTRM?=
 =?utf-8?B?VDd3VEVVVzNJMmNTWWo0YzRPM25YMGxOOUNnMDlRY2dIdkp4Nnk1aUxaTjBv?=
 =?utf-8?B?YU1Ya2d4UDdOMWRmRDlqUFlXV3pIU3N0SHowTzhJM0p2R1p1Rm5KeFcwUzF1?=
 =?utf-8?B?N1VrSDcza3lBZTFEc1diMmlBbmxrZEx3VFQyT0NpNEpPTUplalVRSDlyK0lq?=
 =?utf-8?B?WWZ0RGlaYzVEdmxLYWR4cGN4NnlwYVF5bUl2WTFrVFJvbmlSZUx0YzZyQURY?=
 =?utf-8?B?bFdFcjJBY3lLTFBiZkZuNjhYKzJnZ0dqdGNjeWtrVjJUTW1oQ25lbTRTamVW?=
 =?utf-8?B?MTdYRFVHalNCcXZLZ2JzbGtOWXFacHAxd1hHd2k5b21TZVNDUDZXTlpGODZ2?=
 =?utf-8?B?NjRuNHk2dm00REJIRGpDcmdtUlFBL1g5VWhVODF3SnlwWnpuQnFRdHp0cDRz?=
 =?utf-8?B?NXFHd0Z0V1lhaVhlcm83U2N3ZnhCVDdiK2FqVHZaVzR2cDY3V2RWOCtwWFYz?=
 =?utf-8?B?RnIvUHY5TERxY2NTdkYvb09VZ1d2TDhDV24vcXpIc3MrTDVjZlFlYUVGMDlL?=
 =?utf-8?B?L3pwa3VKK0dxNmNpVE5vaUY2NHJaQjZhZERacmEyck5lVzkrVStBQnZSNGNa?=
 =?utf-8?B?RjhpOG9XaWtGSFpxQjNrWlFMajdob1cvSXZmQWxxN0xsdEVMamVLb0lMbjBZ?=
 =?utf-8?B?NEhZbUl5c05iV0JzL2VkMkpTWUgrQ3NJOWFySksrdkZFZDN4enF0Yk9SSk5Y?=
 =?utf-8?B?TkxCd095VDVxQjhzdXQ0S2hHT1ByWmFpOVZKeXJmSU5kcXd1S2FhRUZNc3E5?=
 =?utf-8?B?ZjN4enBuRGVBSnJvNHNiNHNtbDlJSVhOcWtOTXhEUktkRkFTbWtIVW9rQmdZ?=
 =?utf-8?B?VEQxNkh4aGVvV281V2FBMEx6T0NlUzRKV3lrMTBPOGpESEFSbnYxN2ZkTTVD?=
 =?utf-8?B?blIwa3lmdjBMWHFGL2ZmM21mN2w2Q3QyTXVaUHZkdUU2M08vdHVuQStSWE1P?=
 =?utf-8?B?VzQ3THl5WmdxME12SmFQRlk3RllKemdVSWNnTG5rSWRMa2JMelJBUVNDeWUx?=
 =?utf-8?B?YTg4N3pDZkVweHN4eHJsaTUxSForSDdiTWFvN2RIeGllVE8yOE1zQnZBd0dT?=
 =?utf-8?B?QmZGbE42RzlRM0lrTTBuZS9Xb2NiSnVTMWd1Skg4ZENnU2hGNm1NajJyemZH?=
 =?utf-8?B?SFJuMGhFN1ZHT21NRVpGbW1zdTd3eGhFRXFvTWJNVjRhSzNGbVpJb0ZXUWla?=
 =?utf-8?B?WlF2YWp6Vng0RU9JVmVNMHJUOWpUUWdHSlZpV0xleFQ2MG1RalcrWUdkQVI4?=
 =?utf-8?B?MGtyZDNpTmNlaGNGcWhnSk5WK1hNNzR4Y1BheVQrek5ORW9EaVFWYkpkeWNn?=
 =?utf-8?B?WEprVzR1U3ozeGhFTnY2Q2Q1ZnRIa2Y1QVk2aFl5a3I3U2RIUEd3ZTlreVRx?=
 =?utf-8?Q?ichTVjxVSsgODj8mJsFzCIX9j?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f7d0758-7dd8-488f-87e8-08db3f5308b1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6280.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 14:50:06.5513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cw2CdtEwn1KWPcRX6cpGTDdhOTYvrWL6L9Dlbm86ueBvdKAjGzQtugKYgUluRLEDo724dQWplV6h3PLsc0dCew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4918
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/17/23 01:59, Christian König wrote:
> Am 14.04.23 um 21:33 schrieb Hamza Mahfooz:
>> Currently, we allow the framebuffer for a given plane to move between
>> memory domains, however when that happens it causes the screen to
>> flicker, it is even possible for the framebuffer to change memory
>> domains on every plane update (causing a continuous flicker effect). So,
>> to fix this, don't perform an immediate flip in the aforementioned case.
> 
> That sounds strongly like you just forget to wait for the move to finish!
> 
> What is the order of things done here? E.g. who calls amdgpu_bo_pin() 
> and who waits for fences for finish signaling? Is that maybe just in the 
> wrong order?

The pinning logic is in dm_plane_helper_prepare_fb(). Also, it seems
like we wait for the fences in amdgpu_dm_atomic_commit_tail(), using
drm_atomic_helper_wait_for_fences(). The ordering should be fine as
well, since prepare_fb() is always called before atomic_commit_tail().

> 
> Regards,
> Christian.
> 
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible 
>> (v2)")
>> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
>> ---
>>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 41 ++++++++++++++++++-
>>   1 file changed, 39 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c 
>> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> index da3045fdcb6d..9a4e7408384a 100644
>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> @@ -7897,6 +7897,34 @@ static void amdgpu_dm_commit_cursors(struct 
>> drm_atomic_state *state)
>>               amdgpu_dm_plane_handle_cursor_update(plane, 
>> old_plane_state);
>>   }
>> +static inline uint32_t get_mem_type(struct amdgpu_device *adev,
>> +                    struct drm_gem_object *obj,
>> +                    bool check_domain)
>> +{
>> +    struct amdgpu_bo *abo = gem_to_amdgpu_bo(obj);
>> +    uint32_t mem_type;
>> +
>> +    if (unlikely(amdgpu_bo_reserve(abo, true)))
>> +        return 0;
>> +
>> +    if (unlikely(dma_resv_reserve_fences(abo->tbo.base.resv, 1)))
>> +        goto err;
>> +
>> +    if (check_domain &&
>> +        amdgpu_display_supported_domains(adev, abo->flags) !=
>> +        (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT))
>> +        goto err;
>> +
>> +    mem_type = abo->tbo.resource->mem_type;
>> +    amdgpu_bo_unreserve(abo);
>> +
>> +    return mem_type;
>> +
>> +err:
>> +    amdgpu_bo_unreserve(abo);
>> +    return 0;
>> +}
>> +
>>   static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>>                       struct dc_state *dc_state,
>>                       struct drm_device *dev,
>> @@ -7916,6 +7944,7 @@ static void amdgpu_dm_commit_planes(struct 
>> drm_atomic_state *state,
>>               to_dm_crtc_state(drm_atomic_get_old_crtc_state(state, 
>> pcrtc));
>>       int planes_count = 0, vpos, hpos;
>>       unsigned long flags;
>> +    uint32_t mem_type;
>>       u32 target_vblank, last_flip_vblank;
>>       bool vrr_active = amdgpu_dm_crtc_vrr_active(acrtc_state);
>>       bool cursor_update = false;
>> @@ -8035,13 +8064,21 @@ static void amdgpu_dm_commit_planes(struct 
>> drm_atomic_state *state,
>>               }
>>           }
>> +        mem_type = get_mem_type(dm->adev, old_plane_state->fb->obj[0],
>> +                    true);
>> +
>>           /*
>>            * Only allow immediate flips for fast updates that don't
>> -         * change FB pitch, DCC state, rotation or mirroing.
>> +         * change memory domain, FB pitch, DCC state, rotation or
>> +         * mirroring.
>>            */
>>           bundle->flip_addrs[planes_count].flip_immediate =
>>               crtc->state->async_flip &&
>> -            acrtc_state->update_type == UPDATE_TYPE_FAST;
>> +            acrtc_state->update_type == UPDATE_TYPE_FAST &&
>> +            (!mem_type || (mem_type && get_mem_type(dm->adev,
>> +                                fb->obj[0],
>> +                                false) ==
>> +                       mem_type));
>>           timestamp_ns = ktime_get_ns();
>>           bundle->flip_addrs[planes_count].flip_timestamp_in_us = 
>> div_u64(timestamp_ns, 1000);
> 
-- 
Hamza

