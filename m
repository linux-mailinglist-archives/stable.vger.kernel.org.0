Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6C162FE6D
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 20:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiKRTzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 14:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiKRTzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 14:55:07 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2076.outbound.protection.outlook.com [40.107.102.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C81BCE7C;
        Fri, 18 Nov 2022 11:54:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHxSgyUhKAQ5Ow/CQee690i3JIrytliRWXr0KloQB9/UQs5yj5HGNayC1h67wUTH5GtI1iXrHrvxcOFcaeuG362R4p1/dCOR7uavnB6dxp9KQ1dPul/lOZFHCCYZHZBONfakl2FHe56VzAiYIgO3XWqrtC8v7Uw3wd2FdT/8NR9xeEsUD4Rpsnr6Bsvi7BS1u6IY6tElEVqrHJbjs005rbMHqx51AVOjpsB1TrdrY6uI/AQnVSmvgRBkvi9YTxIKDmvqtDpljF3GyxITcnxrpEq7ibw8SoQ+J0Ab5Z5uYJ25lkTB4KPHa2edJfvhM3b08+wG2BkHGOtvvyNHK+QmvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1stBbGphxxZ/osU8ujAHu57Cj0yygFdv5T6ddX4UME=;
 b=ZwMIAbJO7RFPYPqtt3BzCHEELTSmEDEKW24WCujH3xMchbkri21ZrLFX5rQHVJtkIf0eZavBaZcL30eWwbsgaDwBvSCE0DMUAZfZs3U3ZvyGQdYW72y+5Ge1akTbyJNuGHm9G8BRQQ3q67a6IDpZ2i0u3LeBnikEifQFbTz6xzv+3WHVGumf7NTCB/PFstDwqtqlVn1qY+3cHWwNjTIRgXZ6+MCAQzyOtgxd3R5qtyzrEfKeFsdkLAl4VGK5UMwJP+sUpLIGUk63tsBoi4sVIzu32+s+Xdtg4MKWJAAAlRlsLFFAe53cwbdP81WpurNhnS+MChE4lxfPiQIBKLeeZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1stBbGphxxZ/osU8ujAHu57Cj0yygFdv5T6ddX4UME=;
 b=RDR7+u4C+IsqgzoH3uCEI1VPmIFavLeDL6mqUplbuuChTb0LflI62VEB74P1fI6eckSPTn+Q41dHZhP67Ln0DF6zIlGFIynTqGsrMJYkGfmIIq0HjkEn1e9FP1XezmNUEUvI6yBy4aoXRPhJ2YDAtKBEeM8QkhZOWcukqQGHtdw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL1PR12MB5851.namprd12.prod.outlook.com (2603:10b6:208:396::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 19:54:42 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::44a:a337:ac31:d657]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::44a:a337:ac31:d657%4]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 19:54:42 +0000
Message-ID: <3cc891d9-f136-2381-cc8e-016a2ad9a967@amd.com>
Date:   Fri, 18 Nov 2022 13:54:39 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [v3] drm/amdgpu/mst: Stop ignoring error codes and deadlocking
To:     Lyude Paul <lyude@redhat.com>, amd-gfx@lists.freedesktop.org
Cc:     Wenjing Liu <Wenjing.Liu@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        David Airlie <airlied@gmail.com>,
        David Francis <David.Francis@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Hung <alex.hung@amd.com>, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>, Leo Li <sunpeng.li@amd.com>,
        hersen wu <hersenxs.wu@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>, Roman Li <roman.li@amd.com>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
References: <20221118192546.87475-1-lyude@redhat.com>
Content-Language: en-US
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20221118192546.87475-1-lyude@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:806:6e::7) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|BL1PR12MB5851:EE_
X-MS-Office365-Filtering-Correlation-Id: 26efe3b1-871e-48ae-0899-08dac99ebbcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HlR2fh5OKAJz74/35QJ8YDKhCdCy3IHmHyAXl+jcMEn9HhQX+UUc7EAReXK2aB/NQ5Rb7OA3AZEbsQjrKXjU2TZcKazb0AUAIvkxnLsdKV0+v/9OQdeghv5OrwLS1O2W49yWUbuUwAFi9TrAgzW0qtTxOTEDdrHRUnsY8QmWunZn8eJH62Lw7oZCKfK1DTwmbl6O5hS6oAU/0E6QkMKuZnfOwb5pc/sHqizwtKcVe8CXRA63+A1EC/AbQP+HiSjLpZMnAeDbQT+hQWUEMjuUompCGeK8pJoHrg8TWR9IgyLAwp8af28rR0aliDw8DwWU3lO5+ZRnu+3/BNz0RTsQC25qFCALx0rPuNvjOaodrILFcB5VmdUyVWg24FWMMIBPN9BrzL/J8zvuc9HKSkuOtc97dk1Yoiz2n7tJPq+B2j/sNZmdcIFTdir7Gs0sn04R5yk1tqxnphNkoc4nyKBY/eYio64Rp+Zc5JQtASuIYk3DwfhG/eIRvwmvh3z6NbmLM/M6jkogLmbuwS64bJHHO+I5F/QTn8QfUqVqh9zZHbntIv6v0GwjUO7IT8eB/mDJ9dhmv92QjwJHQOxyAbqMVp+J0O5X5j88vXw5HydGK4h1TND0sB/oWqPgx4qKQIP34nCBQWUbFSAqEA4/QV0Qryx5st8jL9SJXA9kuv7M5M4ZtctPZpajFxRowcALf3rEiQy9X9Y3JitPwfF8KUZTGK6ug7jp7ZLXjmo3C7U0KQw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(6506007)(54906003)(478600001)(316002)(6666004)(6512007)(66946007)(53546011)(31686004)(66476007)(8676002)(66556008)(4326008)(6486002)(41300700001)(186003)(8936002)(2616005)(5660300002)(2906002)(83380400001)(30864003)(38100700002)(86362001)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1IxZXJkdWYvZzdEQW8rTUpJVWdQUURNWkM4RjdyM3diZWlpRkI5MUhGalp2?=
 =?utf-8?B?MzdzKzUyS1Q4ZGx5aHBZT05NeG5GSWNzcUozZUxYNjR2STVkQXVpTk81Nk5K?=
 =?utf-8?B?YXdjdW94NFd5b25SVFpOUjlvNEZCNGdSK1IvWW9RMDEwM3UzcXJsRjVvcG5k?=
 =?utf-8?B?VFkxbmpMbngreEZpNjQ4UFhoc3VCNmM4OTgxTVB1ZFJJdjE5OFlPWmx2aDU3?=
 =?utf-8?B?M3pneCtBUFZSZVRXSlhwc2NOT0FrWHI2cjVHVHMxYnBDamUreHVPY3Z4TUZP?=
 =?utf-8?B?LzczWnhnWWk2RkpwSVduRjNhWHFzb0Zpamx3TTlrWlpUYlpXTkpPc3RKUkQ5?=
 =?utf-8?B?cHhmNXlPV05qNXpnbG5DYXQ1T2RIK1FXZlhBUFo0RzZBc1hPK0pwaVMyVFRi?=
 =?utf-8?B?a2VOTEU1aTJMeXJXZkRFa0JZcklyUEp4MDhuZitMUUxOb2tYRGlYZ1dpeUlE?=
 =?utf-8?B?SzVqdDh3SGR0cG96MVY5bS9IMUxXZVFXYWk0RzBXbGJnQTdPOHMvWFJHQzlx?=
 =?utf-8?B?cDBWOHJNdEFqVXBXR3djUzhETW9VYitRRmFXTXJpdUhlQ2dzcmlLanZrbndJ?=
 =?utf-8?B?cFM5b1l2RXN1cStpN2tVd2hiNjNLR0NJNGJMcHhTdHFqbzdtOWpkekxVakl1?=
 =?utf-8?B?TmR2THdtWjAzSWFyWDhHL0JuYmxNdU1BamtMbVFjbE5vWjBCOVYzUmpFV3M1?=
 =?utf-8?B?WkF1Q01iUXlmWWZmT01OdmIzdTQ3WDM1MnJuZ1VwTkJuU2xiMU9HN3FISy93?=
 =?utf-8?B?eHRtZW5ONHdkNnh2MlpkL05LRVM5S0VYUDRzQ3lqbnY3dDNqMmdicDZqd1Fk?=
 =?utf-8?B?SGhwZEp4M1I2S3hqS0tNVmRCYm0yQWxEd2ZONDNmRTBEQXM3N0ptUlU0cTIz?=
 =?utf-8?B?ZnowdzNEY1VIdmtpNTNqTUJlYnJOYlRqV1dWemNpVmlRbmV0TWpPZEJlZ3gv?=
 =?utf-8?B?WWhvS29ZUkJ2L1MrMVliZ0FEMHpRNEovLzF6K2JIR2lUK1lzZFNvVW03dXZK?=
 =?utf-8?B?Qnk1elpyZFdiVHVlL1oyVmw1MSsrNHUzUXdNbW9BSkRpanhFMzRDVFhWNmNn?=
 =?utf-8?B?NksxRFp4Q0VIN20zeVFNRmhJekZKSGxJUXNpd096c0pjc2pNT1k1RzNqU3dx?=
 =?utf-8?B?WWU5dDZ0NERSTlgvY3QzcStBK24rYkgwcTlTRG5TRnlTWkJjRjA3QWxpR1pT?=
 =?utf-8?B?WEVaa2hkVXZ4Wkg1OTN3TnNLN3I0WlJkdUsrdUxSZHVlbFdRR3NNTEhYdVFQ?=
 =?utf-8?B?Mm5tQk4xNy9NRHBoSVppZU03SnRIaVNDMzc5OHZBbkNOTEI3MDRXVmhnNEo0?=
 =?utf-8?B?ejJXZmhpeWpSTG9JTkZjSmlSOFk5cmNZbERCZk0ya2lMeHF6L2VIV1g1RWJU?=
 =?utf-8?B?U1dvaXBaNlpOcTNIc05Ca2lLbWlnZzN0K3JZMEw4dDhaZUVYclh5bU1qdEVX?=
 =?utf-8?B?YVNubzRQSk44bkw1aWZjL3ZxSXNxWW9tNEtiZjFCUkZVSjF0TFVuK25BZDRM?=
 =?utf-8?B?aU8rQXI2dzg1blloRDVPRGRRN04rQ3RTRzhXdFJ5c0dLTkNwcS9RYnpuMmFV?=
 =?utf-8?B?Z3I2ODlkd2MxRWJLNHNyMkJtVmpoZ29KZFpDTXhlNUwrQjFLNTF6S3JjRzg5?=
 =?utf-8?B?VzBZSFN4VDRhTldRT3AxYlJmMzR1M1IyVXhVamVVT0xKanpMZ3FmeTl5MUdW?=
 =?utf-8?B?VmtoYWczYVF1WEZiOFFyNmlqeGJrazk5QlVtRXNDQS9ia2dsUUFxaW9OQ2hS?=
 =?utf-8?B?dUdsZWZWTzJVeGVtM0puVFFJd1RuV1hTb0N5Tm9lS0VpYTd5Q01qUEVlNWc0?=
 =?utf-8?B?RkZFMnNyVEhwWjhxUGlnU2VXZ3pHcFo0R3AzaFMyeEZmQXVieFlVU2l5Q21N?=
 =?utf-8?B?Mi9CaHNXT2lRNzJPSkk3bTVRRnFiNHRLM0hNbWlsYmtyQjhBcjFIdGdJVTAz?=
 =?utf-8?B?aHl2ZldGdGkvbmFqT3pRWXFGYUtDRFJhR2UzemxiTTNJUnB2Nk54djh5TGtY?=
 =?utf-8?B?azZ1ckpkWWs4Wk1rWjVCaFpwRXpFYW9wNGdFQnFCVks3NXRLQ21jWkwwNFVK?=
 =?utf-8?B?dkc0RktMSzJUUkZKajM3RzRXWExEYVhUOWFmZUQzSlJhZkJSMGQyUkU5UG1L?=
 =?utf-8?B?NCszN21mWFhjY3ErRkphWGFib1lBdW1JYlhwZW5kQ3BRdzZORkhyanMza2JH?=
 =?utf-8?Q?fkWhCnulazic+Va0Jl5zc0d5vC+6wIOOUzMQ8N4qkUte?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26efe3b1-871e-48ae-0899-08dac99ebbcd
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 19:54:42.1325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKYO6K0E/tG9SgQHEeGj23ufkiDYJ8a7bYMBlFeZ1ptSUmHzKhU/u31pZIzOnTYj9LY7l4G/CcGZbQjmGJqq3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5851
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/18/2022 13:25, Lyude Paul wrote:
> It appears that amdgpu makes the mistake of completely ignoring the return
> values from the DP MST helpers, and instead just returns a simple
> true/false. In this case, it seems to have come back to bite us because as
> a result of simply returning false from
> compute_mst_dsc_configs_for_state(), amdgpu had no way of telling when a
> deadlock happened from these helpers. This could definitely result in some
> kernel splats.
> 
> V2:
> * Address Wayne's comments (fix another bunch of spots where we weren't
>    passing down return codes)
> V3:
> * Fix uninitialized var in pre_compute_mst_dsc_configs_for_state()

FYI v2 was just merged recently, it's in the 6.2 pull request that was 
sent out and Alex planned to add it to 6.1-fixes next week too.

Can you send just the delta from v2->v3 as another patch so it can layer 
in cleanly?
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
> Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  18 +-
>   .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 235 ++++++++++--------
>   .../display/amdgpu_dm/amdgpu_dm_mst_types.h   |  12 +-
>   3 files changed, 147 insertions(+), 118 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 0db2a88cd4d7..852a2100c6b3 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -6462,7 +6462,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
>   	struct drm_connector_state *new_con_state;
>   	struct amdgpu_dm_connector *aconnector;
>   	struct dm_connector_state *dm_conn_state;
> -	int i, j;
> +	int i, j, ret;
>   	int vcpi, pbn_div, pbn, slot_num = 0;
>   
>   	for_each_new_connector_in_state(state, connector, new_con_state, i) {
> @@ -6509,8 +6509,11 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
>   			dm_conn_state->pbn = pbn;
>   			dm_conn_state->vcpi_slots = slot_num;
>   
> -			drm_dp_mst_atomic_enable_dsc(state, aconnector->port, dm_conn_state->pbn,
> -						     false);
> +			ret = drm_dp_mst_atomic_enable_dsc(state, aconnector->port,
> +							   dm_conn_state->pbn, false);
> +			if (ret < 0)
> +				return ret;
> +
>   			continue;
>   		}
>   
> @@ -9523,10 +9526,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
>   
>   #if defined(CONFIG_DRM_AMD_DC_DCN)
>   	if (dc_resource_is_dsc_encoding_supported(dc)) {
> -		if (!pre_validate_dsc(state, &dm_state, vars)) {
> -			ret = -EINVAL;
> +		ret = pre_validate_dsc(state, &dm_state, vars);
> +		if (ret != 0)
>   			goto fail;
> -		}
>   	}
>   #endif
>   
> @@ -9621,9 +9623,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
>   		}
>   
>   #if defined(CONFIG_DRM_AMD_DC_DCN)
> -		if (!compute_mst_dsc_configs_for_state(state, dm_state->context, vars)) {
> +		ret = compute_mst_dsc_configs_for_state(state, dm_state->context, vars);
> +		if (ret) {
>   			DRM_DEBUG_DRIVER("compute_mst_dsc_configs_for_state() failed\n");
> -			ret = -EINVAL;
>   			goto fail;
>   		}
>   
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> index 6ff96b4bdda5..2f72745660fb 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> @@ -703,13 +703,13 @@ static int bpp_x16_from_pbn(struct dsc_mst_fairness_params param, int pbn)
>   	return dsc_config.bits_per_pixel;
>   }
>   
> -static bool increase_dsc_bpp(struct drm_atomic_state *state,
> -			     struct drm_dp_mst_topology_state *mst_state,
> -			     struct dc_link *dc_link,
> -			     struct dsc_mst_fairness_params *params,
> -			     struct dsc_mst_fairness_vars *vars,
> -			     int count,
> -			     int k)
> +static int increase_dsc_bpp(struct drm_atomic_state *state,
> +			    struct drm_dp_mst_topology_state *mst_state,
> +			    struct dc_link *dc_link,
> +			    struct dsc_mst_fairness_params *params,
> +			    struct dsc_mst_fairness_vars *vars,
> +			    int count,
> +			    int k)
>   {
>   	int i;
>   	bool bpp_increased[MAX_PIPES];
> @@ -719,6 +719,7 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
>   	int remaining_to_increase = 0;
>   	int link_timeslots_used;
>   	int fair_pbn_alloc;
> +	int ret = 0;
>   
>   	for (i = 0; i < count; i++) {
>   		if (vars[i + k].dsc_enabled) {
> @@ -757,52 +758,60 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
>   
>   		if (initial_slack[next_index] > fair_pbn_alloc) {
>   			vars[next_index].pbn += fair_pbn_alloc;
> -			if (drm_dp_atomic_find_time_slots(state,
> -							  params[next_index].port->mgr,
> -							  params[next_index].port,
> -							  vars[next_index].pbn) < 0)
> -				return false;
> -			if (!drm_dp_mst_atomic_check(state)) {
> +			ret = drm_dp_atomic_find_time_slots(state,
> +							    params[next_index].port->mgr,
> +							    params[next_index].port,
> +							    vars[next_index].pbn);
> +			if (ret < 0)
> +				return ret;
> +
> +			ret = drm_dp_mst_atomic_check(state);
> +			if (ret == 0) {
>   				vars[next_index].bpp_x16 = bpp_x16_from_pbn(params[next_index], vars[next_index].pbn);
>   			} else {
>   				vars[next_index].pbn -= fair_pbn_alloc;
> -				if (drm_dp_atomic_find_time_slots(state,
> -								  params[next_index].port->mgr,
> -								  params[next_index].port,
> -								  vars[next_index].pbn) < 0)
> -					return false;
> +				ret = drm_dp_atomic_find_time_slots(state,
> +								    params[next_index].port->mgr,
> +								    params[next_index].port,
> +								    vars[next_index].pbn);
> +				if (ret < 0)
> +					return ret;
>   			}
>   		} else {
>   			vars[next_index].pbn += initial_slack[next_index];
> -			if (drm_dp_atomic_find_time_slots(state,
> -							  params[next_index].port->mgr,
> -							  params[next_index].port,
> -							  vars[next_index].pbn) < 0)
> -				return false;
> -			if (!drm_dp_mst_atomic_check(state)) {
> +			ret = drm_dp_atomic_find_time_slots(state,
> +							    params[next_index].port->mgr,
> +							    params[next_index].port,
> +							    vars[next_index].pbn);
> +			if (ret < 0)
> +				return ret;
> +
> +			ret = drm_dp_mst_atomic_check(state);
> +			if (ret == 0) {
>   				vars[next_index].bpp_x16 = params[next_index].bw_range.max_target_bpp_x16;
>   			} else {
>   				vars[next_index].pbn -= initial_slack[next_index];
> -				if (drm_dp_atomic_find_time_slots(state,
> -								  params[next_index].port->mgr,
> -								  params[next_index].port,
> -								  vars[next_index].pbn) < 0)
> -					return false;
> +				ret = drm_dp_atomic_find_time_slots(state,
> +								    params[next_index].port->mgr,
> +								    params[next_index].port,
> +								    vars[next_index].pbn);
> +				if (ret < 0)
> +					return ret;
>   			}
>   		}
>   
>   		bpp_increased[next_index] = true;
>   		remaining_to_increase--;
>   	}
> -	return true;
> +	return 0;
>   }
>   
> -static bool try_disable_dsc(struct drm_atomic_state *state,
> -			    struct dc_link *dc_link,
> -			    struct dsc_mst_fairness_params *params,
> -			    struct dsc_mst_fairness_vars *vars,
> -			    int count,
> -			    int k)
> +static int try_disable_dsc(struct drm_atomic_state *state,
> +			   struct dc_link *dc_link,
> +			   struct dsc_mst_fairness_params *params,
> +			   struct dsc_mst_fairness_vars *vars,
> +			   int count,
> +			   int k)
>   {
>   	int i;
>   	bool tried[MAX_PIPES];
> @@ -810,6 +819,7 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
>   	int max_kbps_increase;
>   	int next_index;
>   	int remaining_to_try = 0;
> +	int ret;
>   
>   	for (i = 0; i < count; i++) {
>   		if (vars[i + k].dsc_enabled
> @@ -840,49 +850,52 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
>   			break;
>   
>   		vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps);
> -		if (drm_dp_atomic_find_time_slots(state,
> -						  params[next_index].port->mgr,
> -						  params[next_index].port,
> -						  vars[next_index].pbn) < 0)
> -			return false;
> +		ret = drm_dp_atomic_find_time_slots(state,
> +						    params[next_index].port->mgr,
> +						    params[next_index].port,
> +						    vars[next_index].pbn);
> +		if (ret < 0)
> +			return ret;
>   
> -		if (!drm_dp_mst_atomic_check(state)) {
> +		ret = drm_dp_mst_atomic_check(state);
> +		if (ret == 0) {
>   			vars[next_index].dsc_enabled = false;
>   			vars[next_index].bpp_x16 = 0;
>   		} else {
>   			vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.max_kbps);
> -			if (drm_dp_atomic_find_time_slots(state,
> -							  params[next_index].port->mgr,
> -							  params[next_index].port,
> -							  vars[next_index].pbn) < 0)
> -				return false;
> +			ret = drm_dp_atomic_find_time_slots(state,
> +							    params[next_index].port->mgr,
> +							    params[next_index].port,
> +							    vars[next_index].pbn);
> +			if (ret < 0)
> +				return ret;
>   		}
>   
>   		tried[next_index] = true;
>   		remaining_to_try--;
>   	}
> -	return true;
> +	return 0;
>   }
>   
> -static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
> -					     struct dc_state *dc_state,
> -					     struct dc_link *dc_link,
> -					     struct dsc_mst_fairness_vars *vars,
> -					     struct drm_dp_mst_topology_mgr *mgr,
> -					     int *link_vars_start_index)
> +static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
> +					    struct dc_state *dc_state,
> +					    struct dc_link *dc_link,
> +					    struct dsc_mst_fairness_vars *vars,
> +					    struct drm_dp_mst_topology_mgr *mgr,
> +					    int *link_vars_start_index)
>   {
>   	struct dc_stream_state *stream;
>   	struct dsc_mst_fairness_params params[MAX_PIPES];
>   	struct amdgpu_dm_connector *aconnector;
>   	struct drm_dp_mst_topology_state *mst_state = drm_atomic_get_mst_topology_state(state, mgr);
>   	int count = 0;
> -	int i, k;
> +	int i, k, ret;
>   	bool debugfs_overwrite = false;
>   
>   	memset(params, 0, sizeof(params));
>   
>   	if (IS_ERR(mst_state))
> -		return false;
> +		return PTR_ERR(mst_state);
>   
>   	mst_state->pbn_div = dm_mst_get_pbn_divider(dc_link);
>   #if defined(CONFIG_DRM_AMD_DC_DCN)
> @@ -933,7 +946,7 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
>   
>   	if (count == 0) {
>   		ASSERT(0);
> -		return true;
> +		return 0;
>   	}
>   
>   	/* k is start index of vars for current phy link used by mst hub */
> @@ -947,13 +960,17 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
>   		vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
>   		vars[i + k].dsc_enabled = false;
>   		vars[i + k].bpp_x16 = 0;
> -		if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr, params[i].port,
> -						  vars[i + k].pbn) < 0)
> -			return false;
> +		ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr, params[i].port,
> +						    vars[i + k].pbn);
> +		if (ret < 0)
> +			return ret;
>   	}
> -	if (!drm_dp_mst_atomic_check(state) && !debugfs_overwrite) {
> +	ret = drm_dp_mst_atomic_check(state);
> +	if (ret == 0 && !debugfs_overwrite) {
>   		set_dsc_configs_from_fairness_vars(params, vars, count, k);
> -		return true;
> +		return 0;
> +	} else if (ret != -ENOSPC) {
> +		return ret;
>   	}
>   
>   	/* Try max compression */
> @@ -962,31 +979,36 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
>   			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.min_kbps);
>   			vars[i + k].dsc_enabled = true;
>   			vars[i + k].bpp_x16 = params[i].bw_range.min_target_bpp_x16;
> -			if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> -							  params[i].port, vars[i + k].pbn) < 0)
> -				return false;
> +			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> +							    params[i].port, vars[i + k].pbn);
> +			if (ret < 0)
> +				return ret;
>   		} else {
>   			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
>   			vars[i + k].dsc_enabled = false;
>   			vars[i + k].bpp_x16 = 0;
> -			if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> -							  params[i].port, vars[i + k].pbn) < 0)
> -				return false;
> +			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
> +							    params[i].port, vars[i + k].pbn);
> +			if (ret < 0)
> +				return ret;
>   		}
>   	}
> -	if (drm_dp_mst_atomic_check(state))
> -		return false;
> +	ret = drm_dp_mst_atomic_check(state);
> +	if (ret != 0)
> +		return ret;
>   
>   	/* Optimize degree of compression */
> -	if (!increase_dsc_bpp(state, mst_state, dc_link, params, vars, count, k))
> -		return false;
> +	ret = increase_dsc_bpp(state, mst_state, dc_link, params, vars, count, k);
> +	if (ret < 0)
> +		return ret;
>   
> -	if (!try_disable_dsc(state, dc_link, params, vars, count, k))
> -		return false;
> +	ret = try_disable_dsc(state, dc_link, params, vars, count, k);
> +	if (ret < 0)
> +		return ret;
>   
>   	set_dsc_configs_from_fairness_vars(params, vars, count, k);
>   
> -	return true;
> +	return 0;
>   }
>   
>   static bool is_dsc_need_re_compute(
> @@ -1087,15 +1109,16 @@ static bool is_dsc_need_re_compute(
>   	return is_dsc_need_re_compute;
>   }
>   
> -bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> -				       struct dc_state *dc_state,
> -				       struct dsc_mst_fairness_vars *vars)
> +int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> +				      struct dc_state *dc_state,
> +				      struct dsc_mst_fairness_vars *vars)
>   {
>   	int i, j;
>   	struct dc_stream_state *stream;
>   	bool computed_streams[MAX_PIPES];
>   	struct amdgpu_dm_connector *aconnector;
>   	int link_vars_start_index = 0;
> +	int ret = 0;
>   
>   	for (i = 0; i < dc_state->stream_count; i++)
>   		computed_streams[i] = false;
> @@ -1118,17 +1141,19 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
>   			continue;
>   
>   		if (dcn20_remove_stream_from_ctx(stream->ctx->dc, dc_state, stream) != DC_OK)
> -			return false;
> +			return -EINVAL;
>   
>   		if (!is_dsc_need_re_compute(state, dc_state, stream->link))
>   			continue;
>   
>   		mutex_lock(&aconnector->mst_mgr.lock);
> -		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
> -						      &aconnector->mst_mgr,
> -						      &link_vars_start_index)) {
> +
> +		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
> +						       &aconnector->mst_mgr,
> +						       &link_vars_start_index);
> +		if (ret != 0) {
>   			mutex_unlock(&aconnector->mst_mgr.lock);
> -			return false;
> +			return ret;
>   		}
>   		mutex_unlock(&aconnector->mst_mgr.lock);
>   
> @@ -1143,22 +1168,22 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
>   
>   		if (stream->timing.flags.DSC == 1)
>   			if (dc_stream_add_dsc_to_resource(stream->ctx->dc, dc_state, stream) != DC_OK)
> -				return false;
> +				return -EINVAL;
>   	}
>   
> -	return true;
> +	return ret;
>   }
>   
> -static bool
> -	pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> -					      struct dc_state *dc_state,
> -					      struct dsc_mst_fairness_vars *vars)
> +static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> +						 struct dc_state *dc_state,
> +						 struct dsc_mst_fairness_vars *vars)
>   {
>   	int i, j;
>   	struct dc_stream_state *stream;
>   	bool computed_streams[MAX_PIPES];
>   	struct amdgpu_dm_connector *aconnector;
>   	int link_vars_start_index = 0;
> +	int ret = 0;
>   
>   	for (i = 0; i < dc_state->stream_count; i++)
>   		computed_streams[i] = false;
> @@ -1184,11 +1209,12 @@ static bool
>   			continue;
>   
>   		mutex_lock(&aconnector->mst_mgr.lock);
> -		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
> -						      &aconnector->mst_mgr,
> -						      &link_vars_start_index)) {
> +		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
> +						       &aconnector->mst_mgr,
> +						       &link_vars_start_index);
> +		if (ret != 0) {
>   			mutex_unlock(&aconnector->mst_mgr.lock);
> -			return false;
> +			return ret;
>   		}
>   		mutex_unlock(&aconnector->mst_mgr.lock);
>   
> @@ -1198,7 +1224,7 @@ static bool
>   		}
>   	}
>   
> -	return true;
> +	return ret;
>   }
>   
>   static int find_crtc_index_in_state_by_stream(struct drm_atomic_state *state,
> @@ -1253,9 +1279,9 @@ static bool is_dsc_precompute_needed(struct drm_atomic_state *state)
>   	return ret;
>   }
>   
> -bool pre_validate_dsc(struct drm_atomic_state *state,
> -		      struct dm_atomic_state **dm_state_ptr,
> -		      struct dsc_mst_fairness_vars *vars)
> +int pre_validate_dsc(struct drm_atomic_state *state,
> +		     struct dm_atomic_state **dm_state_ptr,
> +		     struct dsc_mst_fairness_vars *vars)
>   {
>   	int i;
>   	struct dm_atomic_state *dm_state;
> @@ -1264,11 +1290,12 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
>   
>   	if (!is_dsc_precompute_needed(state)) {
>   		DRM_INFO_ONCE("DSC precompute is not needed.\n");
> -		return true;
> +		return 0;
>   	}
> -	if (dm_atomic_get_state(state, dm_state_ptr)) {
> +	ret = dm_atomic_get_state(state, dm_state_ptr);
> +	if (ret != 0) {
>   		DRM_INFO_ONCE("dm_atomic_get_state() failed\n");
> -		return false;
> +		return ret;
>   	}
>   	dm_state = *dm_state_ptr;
>   
> @@ -1280,7 +1307,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
>   
>   	local_dc_state = kmemdup(dm_state->context, sizeof(struct dc_state), GFP_KERNEL);
>   	if (!local_dc_state)
> -		return false;
> +		return -ENOMEM;
>   
>   	for (i = 0; i < local_dc_state->stream_count; i++) {
>   		struct dc_stream_state *stream = dm_state->context->streams[i];
> @@ -1316,9 +1343,9 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
>   	if (ret != 0)
>   		goto clean_exit;
>   
> -	if (!pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars)) {
> +	ret = pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars);
> +	if (ret != 0) {
>   		DRM_INFO_ONCE("pre_compute_mst_dsc_configs_for_state() failed\n");
> -		ret = -EINVAL;
>   		goto clean_exit;
>   	}
>   
> @@ -1349,7 +1376,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
>   
>   	kfree(local_dc_state);
>   
> -	return (ret == 0);
> +	return ret;
>   }
>   
>   static unsigned int kbps_from_pbn(unsigned int pbn)
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> index b92a7c5671aa..97fd70df531b 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> @@ -53,15 +53,15 @@ struct dsc_mst_fairness_vars {
>   	struct amdgpu_dm_connector *aconnector;
>   };
>   
> -bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> -				       struct dc_state *dc_state,
> -				       struct dsc_mst_fairness_vars *vars);
> +int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> +				      struct dc_state *dc_state,
> +				      struct dsc_mst_fairness_vars *vars);
>   
>   bool needs_dsc_aux_workaround(struct dc_link *link);
>   
> -bool pre_validate_dsc(struct drm_atomic_state *state,
> -		      struct dm_atomic_state **dm_state_ptr,
> -		      struct dsc_mst_fairness_vars *vars);
> +int pre_validate_dsc(struct drm_atomic_state *state,
> +		     struct dm_atomic_state **dm_state_ptr,
> +		     struct dsc_mst_fairness_vars *vars);
>   
>   enum dc_status dm_dp_mst_is_port_support_mode(
>   	struct amdgpu_dm_connector *aconnector,

