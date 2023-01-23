Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5C67827C
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 18:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbjAWRD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 12:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjAWRDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 12:03:24 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DEC11EB8
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 09:03:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4EkENdHYKZS8+uaXsg3rXZcN8cLUJZN5wotNia5/FC8xuc+iSnLLzQpLMpRQS0Nd7k+yXU8+VLv/Uldf+q7deM/GdCxfalwy87gZlcEXcODmsnONIf8FMtLaYuOQLZr2ulYhLWJDmkMuo6l1ghqi28MgB2cDubX29lhD0G7t6cZ1tYCrHKwwsVjjBFWoG7v5cG2p4m/ooaxaO861piuse+z49CfLZAXppnb569NVCrGBaNy+RexTW9NbkK+22wWQwgvEaavrH0hRY3i9rF+c1ed0D/yBeEkNhw4TGAZYLD4gAC/N6KCJLu4RD48/PFOEO5KUXiw/J7K2mD/9G+S6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4jc0R8APsUOkLy5/Z5sxZ3b0xpgecr7OyCHwUQnjHU=;
 b=DLHfq8A1hqPKnn0WK3rZA4malEtBFrC/+XaBEQTlmf2brNdXqzer+NNqYbK+I6SM29+S0P7v9+Sk4fMiNAJ34DgbhDDXx5zSHJwq27tItzJ4IO93bLTN4bWojr1xwp8w5p5+VP97aTSoVP2E7qazynswWFRBIiEJ/kb4wDvPgjpVED2Peva3wlDg2treEKR2O4Omdx186gv+nCQjIb9siWZPG0BODlPLcVQo5m/G+67HiP518CMWy3SmJBfCRGyMXlmLjBlkLsH8l4QOgXnJxMXbW9R/QdZ+wbsiomha5hxC8JlprIZMtu5yihns7pgdrZwDllFJzBERaiah14PzkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4jc0R8APsUOkLy5/Z5sxZ3b0xpgecr7OyCHwUQnjHU=;
 b=gEmvwUOBe3nkHvt+/S6G8uVSXg/T5v3nCqXctTab1oTCoNBDoq2I7zcwftYKiWXEtIfehUDzEbXYSkaUr0lVoR8nreK1VT90bTRe0NwvJotnqqjvyspkZFOHo7PdEg6fNq8gi84vH+UgTi/rpAICWts48WxtFuBIWCCKLqciiPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by SJ0PR12MB5662.namprd12.prod.outlook.com (2603:10b6:a03:429::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 17:03:20 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::152b:e615:3d60:2bf0]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::152b:e615:3d60:2bf0%6]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 17:03:20 +0000
Message-ID: <21e6cd4d-cfc3-53eb-1b46-26288dfa509e@amd.com>
Date:   Mon, 23 Jan 2023 12:03:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 0/7] Fix MST on amdgpu
Content-Language: en-US
To:     Lyude Paul <lyude@redhat.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc:     ville.syrjala@linux.intel.com, stanislav.lisovskiy@intel.com,
        bskeggs@redhat.com, jerry.zuo@amd.com, mario.limonciello@amd.com,
        stable@vger.kernel.org, Wayne.Lin@amd.com
References: <20230119235200.441386-1-harry.wentland@amd.com>
 <965500917008cd17b47c1be1f5eeda7ccc4eede6.camel@redhat.com>
From:   Harry Wentland <harry.wentland@amd.com>
In-Reply-To: <965500917008cd17b47c1be1f5eeda7ccc4eede6.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT3PR01CA0007.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::19) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5427:EE_|SJ0PR12MB5662:EE_
X-MS-Office365-Filtering-Correlation-Id: a00156e4-24e4-4e1e-fb09-08dafd63baba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0E0y2wytDB9kgE5gjIXr0alnO8SWBlocJ4CaVzto5mW0terkngOYems/Ywe3OSECYTNywKtyO2dsCQXfJeC6iLna29vp5PyVQi5O7v//SKQO01EIiTf9nr3OQSzyDHnQratGQ+0WbrA1QYuLlu3DO5wRS02atKeFco0HkrVNK2eQgq3n+A4k/qk02wfhXlGHYo/jI0Xk5noYySkAZukNamx877yoC7MlAvvAyqq7xFt3QEbJ7M94BqtwkPaD4SpADC/X4V06ug1hfEcT8LpQaSUfSjasUXnisHOjGjlMxKXuwa7SJ3WOrQVas/+XiBstDt0I3/k/Teo7WK2fuu/Luxhs0i1qewIUcAIT5AzTEOtLCYkgURUj5cDZw/W9E3Bn4XL1O1ZCFfOIukiNNP6/XKRzJhYHepuQmEwFPaFAPGWXBtPmJVMM7PEUMXbpso5kfWuYmHYIn33T+vekO4uqMpVH4WGUML0AUSDEQDTTShkn+Vtyxx4V5P7kWXaIOxXJiaK5gb/RPRz2kx8iISN1P2wguImQpnXHmKXrpDorgu51B5NiD7BYqJEGSJazuHbGzhcJyDm+DZDNbWO5fjb4ZoniFRGpJquK7jgs6wuIceeUwvcufl4ScGMr59OgrAAetU5svcuIXSXcBDRceDbleDygn4C5rAa5WvkzZXNDi79B1af2K5hcTBoZ+UxQBUB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(83380400001)(31696002)(38100700002)(41300700001)(86362001)(2906002)(44832011)(8936002)(5660300002)(4326008)(26005)(8676002)(53546011)(186003)(6506007)(6512007)(6666004)(66476007)(66556008)(316002)(2616005)(66946007)(478600001)(966005)(6486002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1lDcGpJMnR6em02c05NekVvQmVUUGdYTkpUdDdmeW92ZDRFOUE5YlhWcFA4?=
 =?utf-8?B?SEZ4NDcyeEsvVlJ2MjcyK0NEVGVWM20xS1QvNmg5MTRGRU5aSlZEdVQ3dFVT?=
 =?utf-8?B?VnV5SHFMcFA5VDRaaG0wU3R3NUlHOGVBdjZOU2E5QS82WjMvR25RbG1sVXVv?=
 =?utf-8?B?cUNGSFlSMDcrRFB4dGppZlh2MHpXVGlhOGZhK2N0ZmdZeE5UblNkb1VpNVNO?=
 =?utf-8?B?NlhWcHFVTDVUc2pNTUNNM2tuanpuNHY4MWsyWXNSVDEweHRTckVUVXg0Sy9K?=
 =?utf-8?B?dS9jeVBnZzFpVkNTT0d1bXVZNWlmOGpnZWZDTSs3RWJkc0xOQ3JCZVU0d3da?=
 =?utf-8?B?Z2M2djZrWGpvZlBoR1RydDJwK0d5WTZtV0llcm1XY3g1ZUl5VjMrcUJSSGJ2?=
 =?utf-8?B?QkxLajNjZ1o4UCtzaXlUSncvb2F1N3lKWG0wMElGdEIyQkl4c3RiYlorcDUz?=
 =?utf-8?B?eWhIM2l3WnZNNjNrVGFBcm1uUjhLZEJCZU5UM05zdFJsYSs3YW5qcTNWREVY?=
 =?utf-8?B?K0g1c1UxSDhQZHZsWHB2ZDFvQjZTbitNbCtidTZCK0pBclNQYW81cVU3VW5w?=
 =?utf-8?B?eHozbEVJU2xLUXo2SVpueDk5ZU5FdjNNZ2Z5dG5wczFPeG1McmJVTlBaZUZM?=
 =?utf-8?B?ZVNmMjVJdE04OEFaMTllQUJWQUg0SkhIV3dERGswbVNwdzRIY0c1YTN6NXRX?=
 =?utf-8?B?MzBVMjVuek0zaXp3VnUxNDY2anN6c24rR1FEcHpUZit4c1FYaHo2WjFFVXZZ?=
 =?utf-8?B?V1JsM2xLaXRFYmpBUU1zZ1JQZ1Z2aXJNekNvdkF4cG1tSjRxdEo5T2YwMzZN?=
 =?utf-8?B?RkJkaGtVdzkxOVZxNFhXQUpsSUNQUzc5QU5SRit4SmJYOGR5RURtcHBPNUsy?=
 =?utf-8?B?SGR0V0FoMHR2MkRjb0tVdk53L0Mwb2NHM01ady8zUGt1TzRLR1JWcll0dm5Y?=
 =?utf-8?B?TTZjeWJSVEFINkVIOTFlQXJ5Z2ZlU0VmMzVaWXVTNGpmSWZJK0NUTjcrcVZi?=
 =?utf-8?B?em05S0JyZTk3OEVTOU9Md0VSbDRwdjMwWE16M09jWkpPbG1ndGNKSi9hQmV1?=
 =?utf-8?B?UlRsWGtaSmc3c3QvcEY3WUlGaEtlKzZvVkI4NFV4dVNySXVJajBzeEsrNE55?=
 =?utf-8?B?OGxBZk1kazBwKzQ4Y3lod0I1OE10RW5pNjlhZVJXZDZKSk9ZZU5rQzhxc2NM?=
 =?utf-8?B?aUhQekc2bkU2M2dwK3lhK3F3eG5RdWxxREV3L25PQzF2UTh6SFdVK1E5WDI4?=
 =?utf-8?B?S3JxeEZmNEZNU1ZYdjFJQUJvSG92QnhFUzkzYXNVR3lXeFAzZHRvcTRkV05Q?=
 =?utf-8?B?cWhHUXBqdTJaVG5SaTRraFc4MlM3OVNaUmVKUEZ5VHplRytta2VsRmpPUGpI?=
 =?utf-8?B?UWZjUEtReWFOUzRwOTdMUmRKQzBVSXZUS3JvUFF5YTZwemR4V0lHZko4NlZX?=
 =?utf-8?B?MDdWd0dJeHZwOUwxNzZUTGdVV2tvR0pwZ3FaUU1jb05ONEs3WEt6a3cvOVVG?=
 =?utf-8?B?V2FmQ3JoZVFKRGptS0RCRUloYXdVYXRtWGUyZW8valBkeEwrM3VwSW1XZGZx?=
 =?utf-8?B?NkdTd3pqSGc4SFFIbTFlMDFEZWFjUDFWaVRyNkM4em9wSGpuVEdnWVRGcEpr?=
 =?utf-8?B?d1dMaGtnMDd6QmpzNkh4TWdjbzRuQUFSdDBSdjVkTVk4OGwzOEp0ZmdaVS9R?=
 =?utf-8?B?djlqbElvZUZZOVk4YlBRd2ZYWnl6dmJnQXcxRjNYQ1NEQmJDS2x4TjlBY2Ir?=
 =?utf-8?B?UmdVdUprQWpkcE1VY1JiNTZlTU9abkxucVRRbFRVYjVtV1BFb0lYbnNDd0xP?=
 =?utf-8?B?eTFveW9zY0JUdjhZMHFsdWN6R0ZPaGEyREdkNVhKTUszbUQvajgxNGo2dDJB?=
 =?utf-8?B?K041aXgyOWpPVUpDcG01b3BNTzNaaW9WUk94eGhEcGNtMngxWGE1OEFUcngr?=
 =?utf-8?B?bHoyRzF3NkNTSlN6L1JMTFpaUGw3bmhaR2c5WTFEZ2NlWkM1elVIdEZjaGNi?=
 =?utf-8?B?aUlaUUpvaGdUb2g5eTZtaG9yemRtZXpCbTNCZFB0SU00OUFtR1VReDh5ZVFC?=
 =?utf-8?B?QXZiQkhTOGt1amM2QVE0b3h3bGR4QWNFRGVOWGdjcG1MTUMrTHJOQnc1Wjdu?=
 =?utf-8?Q?QVMxNZFqVAeFuv8rLKNY5sTkS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a00156e4-24e4-4e1e-fb09-08dafd63baba
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 17:03:20.5251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gAfEzmKUf8PLQENQ50W+7M5mNB154cDpUH0vwrFDDPSBj8ZeXFzDiGXr5i2mEPEO23rxrw4QfdJx4pEmYi9kEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5662
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/20/23 18:15, Lyude Paul wrote:
> For the whole series:
> 
> Reviewed-by: Lyude Paul <lyude@redhat.com>

Thanks, series is merged to amd-staging-drm-next.

Harry

> 
> So glad to have this fixed finally ♥
> 
> On Thu, 2023-01-19 at 18:51 -0500, Harry Wentland wrote:
>> MST has been broken on amdgpu after a refactor in drm_dp_mst
>> code that was aligning drm_dp_mst more closely with the atomic
>> model.
>>
>> The gitlab issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
>>
>> This series fixes it.
>>
>> It can be found at
>> https://gitlab.freedesktop.org/hwentland/linux/-/tree/mst_regression
>>
>> A stable-6.1.y rebase can be found at
>> https://gitlab.freedesktop.org/hwentland/linux/-/tree/mst_regression_6.1
>>
>> Lyude Paul (1):
>>   drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count
>>     assignments
>>
>> Wayne Lin (6):
>>   drm/amdgpu/display/mst: limit payload to be updated one by one
>>   drm/amdgpu/display/mst: update mst_mgr relevant variable when long HPD
>>   drm/drm_print: correct format problem
>>   drm/display/dp_mst: Correct the kref of port.
>>   drm/amdgpu/display/mst: adjust the naming of mst_port and port of
>>     aconnector
>>   drm/amdgpu/display/mst: adjust the logic in 2nd phase of updating
>>     payload
>>
>>  drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h      |  4 +-
>>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 48 +++++++++---
>>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  4 +-
>>  .../drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c |  2 +-
>>  .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 16 ++--
>>  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 76 +++++++++++++------
>>  .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 53 ++++++-------
>>  drivers/gpu/drm/amd/display/dc/core/dc_link.c | 14 +++-
>>  drivers/gpu/drm/display/drm_dp_mst_topology.c |  4 +-
>>  include/drm/drm_print.h                       |  2 +-
>>  10 files changed, 143 insertions(+), 80 deletions(-)
>>
>> --
>> 2.39.0
>>
> 

