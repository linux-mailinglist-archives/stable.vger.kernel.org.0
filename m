Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18422E9F78
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 22:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbhADVVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 16:21:53 -0500
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:64308
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726124AbhADVVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 16:21:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgntQEqIEzPJSRpcmjT1K5BeeQLhEqYNr+dbKsUYxYpsKMiSFOmU4Aw/RyiYAKWJT6fBxQV9HXQX59wXM6IGSWgtoUiRki4WYKc5a+X+SVr5qcrwrWVOVNCv/m+fXgkrMyC1x4BDDTkvyql8s4eh8TnjB4HbKh7enQXhjsQin0B2w96sTpQ1LVwL93qiaFBnBsa+d222bLkzzrEqYrf8kR3Ntuoz/jR6I3yUx8Mkq7m1fJyoWrNgnWFvfr8hRo9+WWxCfvz5frE7Kzo7BN65AOAZejkFMUiJbUbHFdOx5XitTlh9x47fkpU8VoHEOa3wXQe6ssLzdncYu7wuZBLRZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqdB8fQuLpeSrFrxPyhyLRjF/TOCt+A5eDmSInEFKRY=;
 b=kJmeq0mVsEFqjjZrqSwYGKay+DYre74f4YmQv+ooykXQpSpy45VYtQU8iHYU/X8txWADzKRimL0TBp5X0oScilBH/E5V4h7k5oRVnXDPizg52HGNJrEHKBY5y/XFxPF1veqT7atKus3BkkpVx4N3TJknGZgcsS2haQa4YY4ieGYVJMkNo5a3HtoVgvcd11qOs5yh87rKcn8Y1mDe3tkWPSpQYyx3cv1jMs/F/TQDTH0mpnk6/y5r7Rx9Tt2AjXlqGYl/WYzuG5WK6c5Q+E2gTQJG82RpCflPt3btLhKJwf++N9NQA7Qy+7tY0u5CSQ3+leKM6ZcRCgVpVbAWvn+58w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqdB8fQuLpeSrFrxPyhyLRjF/TOCt+A5eDmSInEFKRY=;
 b=e7IZHH1y7ByaNAsB8cPEjKHeI3YIOXA3op0bSRlHQMU9zmgaReUVS2qVHXimCNdeQbHg/Lpp2tJMZKGV16WfauQ8v0wSlPk8ov0Swf/mvJDeOV5RVtFXxCCTcOUgxWk6dISwb8eVQKRQ7FvRXVhNr36GWdEpa4g2Y7GyoBIDW1Y=
Authentication-Results: basnieuwenhuizen.nl; dkim=none (message not signed)
 header.d=none;basnieuwenhuizen.nl; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3560.namprd12.prod.outlook.com (2603:10b6:a03:ae::10)
 by BY5PR12MB3795.namprd12.prod.outlook.com (2603:10b6:a03:1a9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.22; Mon, 4 Jan
 2021 21:20:58 +0000
Received: from BYAPR12MB3560.namprd12.prod.outlook.com
 ([fe80::c415:a6:f78f:82f5]) by BYAPR12MB3560.namprd12.prod.outlook.com
 ([fe80::c415:a6:f78f:82f5%6]) with mapi id 15.20.3676.035; Mon, 4 Jan 2021
 21:20:58 +0000
Subject: Re: [PATCH AUTOSEL 5.4 006/130] drm/amd/display: Do not silently
 accept DCC for multiplane formats.
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
References: <20201223021813.2791612-1-sashal@kernel.org>
 <20201223021813.2791612-6-sashal@kernel.org>
 <MN2PR12MB448885CD6421AD53DCF46EE8F7D80@MN2PR12MB4488.namprd12.prod.outlook.com>
From:   "Kazlauskas, Nicholas" <nicholas.kazlauskas@amd.com>
Message-ID: <8cc65fcc-626e-6012-8d5e-0a0c5d608fab@amd.com>
Date:   Mon, 4 Jan 2021 16:20:55 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <MN2PR12MB448885CD6421AD53DCF46EE8F7D80@MN2PR12MB4488.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.55.211]
X-ClientProxiedBy: YT1PR01CA0037.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::6) To BYAPR12MB3560.namprd12.prod.outlook.com
 (2603:10b6:a03:ae::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.148.234] (165.204.55.211) by YT1PR01CA0037.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19 via Frontend Transport; Mon, 4 Jan 2021 21:20:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 317d2734-357e-4199-c2c7-08d8b0f6a14d
X-MS-TrafficTypeDiagnostic: BY5PR12MB3795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB3795737559A5A362EDFD7FBEECD20@BY5PR12MB3795.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7W+vMPbmXOo/HEmIOeCmYl4451ppULJ8xJSubLKxCXPnjHsN4pLXOCI5i33yw2h2q/wU8glz8EZUoPKn6NcblWh6MhxSNHqdtbj5YAIod0Sqt6C4YZCJLsDc2SIcdfRT3DNAOUuWTWE3Rc7uQxIYGnGY93D7FcRSd1KNv0NJUZDdQZKNIruDjR4MmL6K5xVP/6ukCFcp5pdlrnlDdFi2xxaugCGpkyHAzC8HLiT1oaZ6pml0ZLoOVvt7qFf355lMe6Q+uQPlr8e3e7GSonzc13hpUIonTykbvQKC8U7H590UulBdAdVvv+rkux1V8FGChH3MwWqeaZaigA6rjk1wGyLBjd83BmDVRXJiuxCcDSdGFEOsjv1lOuIMBJrH2u30RCi95UsOq6vwKymGTSHpAyKKLM86fY1R4ai7vhPV0ARwV2DjvL2yLgtmTFw093XruFUzouCxzaygm7JLe2bZ9PB4KvdXLVaH2Fvvhmqlu/S1/mc8XhzrkmJQDDqJ4P/BvkJy6OmxFOS+SdMLLg+fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(53546011)(45080400002)(26005)(4001150100001)(86362001)(478600001)(5660300002)(8676002)(2906002)(6486002)(16526019)(54906003)(110136005)(52116002)(186003)(8936002)(316002)(2616005)(956004)(31686004)(966005)(16576012)(66476007)(66556008)(31696002)(83380400001)(36756003)(4326008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NEJ4UGZxU29KZWlQa2haTlZKR21WRGNwSWJES3JxOUE1eGpnV3h3T0t5dnJP?=
 =?utf-8?B?MHA4bU50cCtZSktyNzRhYi9IbUlnenpvazVGTllkc1h0aHl3VGs3OU5pWTg0?=
 =?utf-8?B?b202YWVXVzFER0djUmhhV2JNaWxSV29ZRlI4YUZCNlQxZFlDU1BaWndDeDhT?=
 =?utf-8?B?SVBpUVArV0Foa2dQeGpIMVRSM251ZStBOUdRU2MwSlh3OFRNUHRkRWJJeVNZ?=
 =?utf-8?B?RWF6WEpWenE5ZjhvVnM3MkI1dkpDbTdJZm9rL3NWdUhVMEVIOTNRbVZQeEZv?=
 =?utf-8?B?ZFFKMmh0Z2l6NmhCRkhOSFVjcG9JZVMyOTVKODc2Z3BsN2tmOVVTbGdWWEZz?=
 =?utf-8?B?ZlpkdC9kdTNka3owVjhYdDVLZURuQWJpRjBpa2dRb3luNlp1dzYwSnh1d1dw?=
 =?utf-8?B?STBhNlpFUmhEMDVWdVkyUU9MaDI0d2JFM0tnMS96REZQczlOYk5lalZ5WkZ0?=
 =?utf-8?B?WlNldFlxanJHRU1TYjVKRmxnMkJDcGp5Wm44dlRKSkhXeWp5UlpQam9Cckhh?=
 =?utf-8?B?Rk1SZTdjSEFwOGRvMDBiNzlZUks5cFlmWFc5cnZ5ekgwOXIvT3FwcVYxNmM0?=
 =?utf-8?B?YWRCUDRHV2FMWDhNUk1TcGlmd2hzaFN0cm5VOFgxMGppR1Y1OW15ZjR2Wmsz?=
 =?utf-8?B?YUhTM0pGT2ErS3huUEpZRitvbHJ0VkFzb2dBZGxPalF4dzk5RTRUbHRLdXo2?=
 =?utf-8?B?WE53ZVZ5Z1AxcVBzd0czQ3BnOXFSbzNvZndqKytXSWs4R1pMUU56Wk9zaUNZ?=
 =?utf-8?B?NFhRWmJteVRTbmFEMG9NTFZ0NzR0eWdPWEIrQ2dCYWRIaVZsQVVWd2ZNSGlC?=
 =?utf-8?B?ejFoT2NXZWlDYlhHejllZXVyZXhoUy9MNjl6MEVmMjlYQzY1aXFMZjJsVkpV?=
 =?utf-8?B?UjVuSWlDZUovSDJIS1V2OXdPOXZicUhKZ0l1dEh3R1dNUkRjYnZCN0tVZ2hx?=
 =?utf-8?B?N0NBa2MrQkxnc01DaUVmS3NrNisvU0dCVmpneFcyL05mM0dncmF4a1lOVVhH?=
 =?utf-8?B?UHExMngwd0FpUmorYzB1YVFUNHV4dHcrVm5sNnZzUlYyblppeTIwcXo0UXFz?=
 =?utf-8?B?VXh4bThWdEs3UEphdFZWbzhOSUN1a0ZuSkRjVTBvQjlBbVFONzl3ZWxNU2hE?=
 =?utf-8?B?WGorMU9RNjdyejd5Q0VYR0szR2lJd1BkQW95bWhtVUVwemIyaDBVWXhIS2kx?=
 =?utf-8?B?MWdWcDhXWEZ3K09sOHJOVlZENDBNWDdXSHNRSFh3TnV2ZG9iZVRIVUJsM2Nz?=
 =?utf-8?B?U0ZtM2tKZnlpV2pkZklSYXZKSGpMM1VhcjYyMHcvOW5ncno2NW9iWmd6VzBm?=
 =?utf-8?Q?hfE2wKFCmPz2LiRbQqTOJs1Z3sFqEzZAxB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2021 21:20:58.6587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 317d2734-357e-4199-c2c7-08d8b0f6a14d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Bv+KGrIkZ1gXJgIaUJvxsjxRWkOA/SjD7iqHfWXvUmCefM0iUFwlw7YD24bVR8VsCcPlDXfYulz5pMbDkoqiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3795
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-12-29 9:54 a.m., Deucher, Alexander wrote:
> [AMD Public Use]
> 
> 
> I don't know if these fixes related to modifiers make sense in the 
> pre-modifier code base.  Bas, Nick?
> 
> Alex

Mesa should be the only userspace trying to make use of DCC and it 
doesn't do it for video formats. From the kernel side of things we've 
also never supported this and you'd get corruption on the screen if you 
tried.

It's a "fix" for both pre-modifiers and post-modifiers code.

Regards,
Nicholas Kazlauskas

> ------------------------------------------------------------------------
> *From:* amd-gfx <amd-gfx-bounces@lists.freedesktop.org> on behalf of 
> Sasha Levin <sashal@kernel.org>
> *Sent:* Tuesday, December 22, 2020 9:16 PM
> *To:* linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; 
> stable@vger.kernel.org <stable@vger.kernel.org>
> *Cc:* Sasha Levin <sashal@kernel.org>; dri-devel@lists.freedesktop.org 
> <dri-devel@lists.freedesktop.org>; amd-gfx@lists.freedesktop.org 
> <amd-gfx@lists.freedesktop.org>; Bas Nieuwenhuizen 
> <bas@basnieuwenhuizen.nl>; Deucher, Alexander 
> <Alexander.Deucher@amd.com>; Kazlauskas, Nicholas 
> <Nicholas.Kazlauskas@amd.com>
> *Subject:* [PATCH AUTOSEL 5.4 006/130] drm/amd/display: Do not silently 
> accept DCC for multiplane formats.
> From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> 
> [ Upstream commit b35ce7b364ec80b54f48a8fdf9fb74667774d2da ]
> 
> Silently accepting it could result in corruption.
> 
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c 
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index d2dd387c95d86..ce70c42a2c3ec 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -2734,7 +2734,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
>                   return 0;
> 
>           if (format >= SURFACE_PIXEL_FORMAT_VIDEO_BEGIN)
> -               return 0;
> +               return -EINVAL;
> 
>           if (!dc->cap_funcs.get_dcc_compression_cap)
>                   return -EINVAL;
> -- 
> 2.27.0
> 
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flists.freedesktop.org%2Fmailman%2Flistinfo%2Famd-gfx&amp;data=04%7C01%7Calexander.deucher%40amd.com%7Cfb9f2581393f494acd1708d8a6e905fc%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637442867044150000%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=ZYz1FjTl6SoWX1B91t0McdUai%2FzRF9C8uBmE%2BNQNod4%3D&amp;reserved=0 
> <https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flists.freedesktop.org%2Fmailman%2Flistinfo%2Famd-gfx&amp;data=04%7C01%7Calexander.deucher%40amd.com%7Cfb9f2581393f494acd1708d8a6e905fc%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637442867044150000%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=ZYz1FjTl6SoWX1B91t0McdUai%2FzRF9C8uBmE%2BNQNod4%3D&amp;reserved=0>

