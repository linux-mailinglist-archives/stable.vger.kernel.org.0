Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0534B06B8
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 07:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbiBJGzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 01:55:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbiBJGzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 01:55:24 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2068.outbound.protection.outlook.com [40.107.100.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29901D95
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 22:55:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTdA7dn/qYHEHzGzHjUbiDNXfiuaPhcqijgx31UPo6i6BegdE8mAmXAQ8AvhlWw3Q9L2lZxL0iPc9Y9vt3sW9iV9pAMyfvGLNz94aPt5slB6JmsP8ktt/IIEg9YqCEiXZGcEMZkvRrTuPCMcumT6OoaPw8ryQUFVNRQ7cOMdtQMblmMB5eLqyU8f3ihqQL7zJt71JRU/ApjbNjoyTlJ1cTNNpDJctuTpKH2ZewECRufeq5gTFpIRWHACrIS9EK91g9/RbwMWu6C7td+yp4db9o/0j25OPMxLSC0hxRWn0P0Aa+M2vKEba+/4MgYOiUbNuElP313Yg7WWxGkz8sVUog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVd8EQSH1A2bnOOiEnIF7LfiuUSHHKUr99DqxuohqkY=;
 b=AEcmiOBH29tDRvN9fSwqZdSs/DoflcfFFdtI9HVTUbblyjeu+S4EbJ2UiMIWi7bN90joKscDIdU7U8KFxvtOGNKq1c+23t3zZi2tEQ1L+a6R1pFRBt8Eg2+1/LdIfeky0HJryNE1vARcwnQU6k3y/wjfrvQ40vXjjca78ZSvV6MEV8SfpEeP4zKX243vA5l3O00ehrqjgMLAZHKJ8kfFLvsxf+1PwDnaT2+DDj8nulqXUAAMg5d8w5ljyO0Bxb0hXB+Nx9gJ6EPVCqDoyA9APPGeJFHW5mtsBKnFNKN9ZYxKQS3Xhn61LhlEW9miypmk4NlKcTXqbVd7YycbSJ6fsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVd8EQSH1A2bnOOiEnIF7LfiuUSHHKUr99DqxuohqkY=;
 b=QZLXSY8BWPRxlkBLrzW4TMdEpsH5PYPX/kK4vZUt7NgrCIAWE8rTnzM/RwxiwKnLRL9whl3oEoDkXvdMHykQmJ4EcD2CfEKQEkr5F8aB5L6Tsc7uJ5BEcZY//4HSMEJ0siN8ILBD4HFxsxpFg2eUs13Bqmep/8Q8kbQELU9nstY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by DM6PR12MB4635.namprd12.prod.outlook.com (2603:10b6:5:16b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 06:55:21 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d861:5699:8188:7bd3]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d861:5699:8188:7bd3%3]) with mapi id 15.20.4975.012; Thu, 10 Feb 2022
 06:55:21 +0000
Message-ID: <10fe1264-7b84-4369-efcc-e7b18bc4d65f@amd.com>
Date:   Thu, 10 Feb 2022 07:55:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH for-5.10] drm/amdgpu: Set a suitable
 dev_info.gart_page_size
Content-Language: en-US
To:     Salvatore Bonaccorso <carnil@debian.org>, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Rui Wang <wangr@lemote.com>,
        Huacai Chen <chenhc@lemote.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        =?UTF-8?Q?Dan_Hor=c3=a1k?= <dan@danny.cz>,
        Alex Deucher <alexander.deucher@amd.com>,
        Timothy Pearson <tpearson@raptorengineering.com>
References: <20220209201624.1234062-1-carnil@debian.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20220209201624.1234062-1-carnil@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS8PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::20) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14b84a7b-986e-4e1a-eb48-08d9ec624df2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4635:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB463525D1BB6EAE6536A61193832F9@DM6PR12MB4635.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EgdFRtwBZ49HPxCDZVdZkwGlaP8c2AYBX29+9rDGF6ELBFW8+b6wTr52dbqqC7cTCbbHnQY5PGZbYytTOaIW5y5e2x2IYO2VsCfcsXjF/ampMUSROcqbNT4gwDV/GFN2qS/NGuyoCyOIzjuJSSa/G19nPRwAiNfIiCU7u6N0FWP6d7E6EfqJpGcgcNaMmgM45k07gxGC88ZkpsPEXT4ixcnO+nLVeHpGzFK1v1uQDW9mkOoTPImfEnhbI7I1fuZNMCvPrE7YzTr1C1AqShah94wD2zipcQZ/dD3WtJgWkHS1aRBvpTCTfN9beMrRgKG2waNGAPRhz8RRPr9tMaRBHEVrkSd5nDBWnJ8/DkjpeoZf/hLPDLzVNuY6DkR1cppr29fdOmuspDjXSOjpyRrZg+CytSSCYbt7oBO/qQVnylZRbCGm2Nf0oLlyt03sOkS3IrvceTbux084KK6yPSAbvPXhAnWSZYww6Xxdj+k/+Bqys01hi2bZ5KLHh2c0xCKfGNbD4F/XuCNjUcZY3dYfZ7+HX87qpvm0TatNNU2lG/HP5XWl+tOLI9eWsE+i5m2UZQ77NZEEtTmmkP+lF1Xx3PEetSt7hHlMkCon2x1KHekpsbf3WzhKsWeYkxNHKDGbH9sXh6pGNrmDgPqbby6JhI8cd8sSBH27A7UkXA3j6BkGIM7TtbKaJwhFDx1bny+bSjvzfck6dww6G5Lv72YqX0aV35EVKw8rhOGrFxbnxl0SAGe0Iov2YSV63fjxyab3T1L9KDEBRTAHHfJHhIBY9PO/dlFpMtU264EYOQpXoU4QoYc8j/dpsaSxfSv90IO1p+hXHYTcQHZoMLU4+bZ+Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(66946007)(66556008)(6512007)(6666004)(45080400002)(5660300002)(66476007)(8676002)(508600001)(26005)(2616005)(83380400001)(186003)(36756003)(8936002)(31696002)(31686004)(54906003)(2906002)(966005)(86362001)(38100700002)(6486002)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cldTbE1PVmlqQmlzQk45bWJvRjc0OHRlU3JKdUZkSWFUakMvYk4yYTBWUUpM?=
 =?utf-8?B?VTV4RG9KUkxNVkliM0Q1My9zWExLaHlTSFhQSlNQTDM5SXJkNzVncTBJblcy?=
 =?utf-8?B?dXFVRCtVQkZuWDhlL0ZmUk1RRTllZVgrYTd6Yzk1WTlEVFYvV1BiV09zUi92?=
 =?utf-8?B?VisvQmNORHBVMkp3bjdmR1JYNkkrVk53SEp0cG9BOStDZWFValRHRWxjcTVY?=
 =?utf-8?B?Y1RjWWY2TGpsZ2ltaGtqWE1RV3E0Z3N6R1dIZWVLTUlHNVJObm8zTVNEOWFW?=
 =?utf-8?B?YTVKVEduUzRIUlR6cXl0YkFqQXBJKzlhaUVHSlN0Zy94cWxNeEJ4SURSQUhw?=
 =?utf-8?B?eitPR3ljVkJVdyttY2MraUxMSnAxay9Ta0MwbjdXaTB5Uk0rMzQxZlZlVHZK?=
 =?utf-8?B?QTJ6RU9IUGVrd2J1Y3VnU0hlNXFGbkhXNUhBcjhtWGVuNW5IMDdQVEx4ZEV6?=
 =?utf-8?B?SHVCaHB3emFRRXhhMWhBUUVYclZkckt2Q0luTnRvcW1CMThZaUpsRnZWQyty?=
 =?utf-8?B?VldoS29EOHZRcFVNYjNCZ1U0SU15MW9sUEVITWxTSlV6YVBLa0NwTnNKUkNX?=
 =?utf-8?B?RStmd056NjhIQ09BcytDYUsvWkVmdjM0T243VlVleU9WYWNyWGxRRDgzMS85?=
 =?utf-8?B?UTB6OWkrUXZBNkVuK1NadmwrT0Nsdmw5bXRMbjVjSVZCV3BXQkpxZ3VabWNJ?=
 =?utf-8?B?NStVMVZTZ1VqblBNcWdkdzRWcnFMeGdsS1FKWTlLai9jS1RVclZiWHZHOFZq?=
 =?utf-8?B?bkg4RVV5QjQ3RTVhZGx6TndzUWxsZFk3SjRiL1NCNktZQnZNNFhaN2dmRWg5?=
 =?utf-8?B?ck5qUFg1ZEhSMU1PQU84YWVnOFhUbWlJQ05yTVM4ZmVDb3orTHVITlk3U0FD?=
 =?utf-8?B?YXRvb3VKQnNjY1o2K2I3dnd3VnhRQmF5c0NNSkNuZzlISFlHczhRTmJzQzZF?=
 =?utf-8?B?M0tmamdicTdVYlZaQk4zSUZ6QlFsZGhjYUsvTE12NHdKQTZKS3p5R2RRZnFG?=
 =?utf-8?B?ZHd3dlJKazFSbWFSOTQzSFY0SE9GWk9RN1I5YWFkTk8yMFBJMFBnVjVnTDZr?=
 =?utf-8?B?YkxTWjVVdVNKRkw1dG9iM1NIR0hzbVJhVUlwWjAwdkorTkZtNFg2T1ROUlN6?=
 =?utf-8?B?TGY5OGtaUWJlVWlmRDExOGdWemlYekRYeGtIckZuSTZVRGRNbUZBVnQ0QlJE?=
 =?utf-8?B?ZjVnU29JU0orM3lOQy9yZnpBcHBqZlh4dzY1NjNiWndLUDFNcWo2MnZwbmhI?=
 =?utf-8?B?OWxNeEJHNHlPL1lyQzNodmkzaWUwZHZGL3lqYUlQOUEzY2NCRXk5U1YrMDVQ?=
 =?utf-8?B?MWd6VFpqME1pRTA2bHIxa0IwclFvaGo2N2ZRUU1MM2RiZ1FWMWpXY1hDVXlo?=
 =?utf-8?B?WkN6M2t6WHNxaVVpaWk0bHByY3VBREhhN3RCd00yK2ZDMlRDWXZnWmJWbEdj?=
 =?utf-8?B?VWlIL1hkMWZ5YkdwNlEzdkllZ0FQUm9QOWFUcnpWVWZjWXBBbCtqQlVhMUxY?=
 =?utf-8?B?eVJ3U2FEdDdiZ1Z2WGEwNCt0QXdMbjlNekEyNGRhL3ppaDV1cFF0UmNJd0NO?=
 =?utf-8?B?Q3lhTmFJa21kN1hWRzdTQ2NjVytpbUNvREZCZDhzbHQwWmxoLzdlcGhMY3Jl?=
 =?utf-8?B?cjBmZ1VTK3VlVUJWM0tVcGgyNjNWbGFwRzBLOGRwVWJLMmxoL2V4d3ZIT0lE?=
 =?utf-8?B?VXM5dVg1ZFk3NXAxMmJYS0Rwd1dOZGVER280R3pnR0R2VE5SM1NFSkltMS9z?=
 =?utf-8?B?VGtKTXNITHRTSTk4SjZGSlFaTTFEVmx1SytvamNxekoxczJuSHFkWmdmMDFE?=
 =?utf-8?B?N216RVdtU3BTbWJ6M1FVcVVsdUJveUpKVW9SRTYwYWgvMm96MkxjcTR1TGRa?=
 =?utf-8?B?bnFadG9ieW1xVDd3OWJSNEs5T3VTL1RzMW42ek43dEQ2RWRHNGFmZVBKV3pv?=
 =?utf-8?B?MFBIWWNqQTUra09pTmZ5YU1QUFBPdytKLzYrQTFNUmFFLzVhK1B2ZFAreC9M?=
 =?utf-8?B?b2dSVzh6c0hvaVAvMHJMNGZ6OTBVQ0hLKytQRkVLRjAvTWc0citWSzQrMTVl?=
 =?utf-8?B?eXlGQnErNFh6S3N6aDZIdWJBSVUxR1R4U0VhMk82SVJiUnNjODdkcXE0OHVO?=
 =?utf-8?Q?I3QM=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b84a7b-986e-4e1a-eb48-08d9ec624df2
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 06:55:21.0382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +pnSx4Ap3l53dVcqqX8G7o8b8cU7jo3nSI8CYyBSGIhai8BDcPk/EPs3phcZdIU7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4635
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 09.02.22 um 21:16 schrieb Salvatore Bonaccorso:
> From: Huacai Chen <chenhc@lemote.com>
>
> commit f4d3da72a76a9ce5f57bba64788931686a9dc333 upstream.
>
> In Mesa, dev_info.gart_page_size is used for alignment and it was
> set to AMDGPU_GPU_PAGE_SIZE(4KB). However, the page table of AMDGPU
> driver requires an alignment on CPU pages.  So, for non-4KB page system,
> gart_page_size should be max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE).
>
> Signed-off-by: Rui Wang <wangr@lemote.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Floongson-community%2Flinux-stable%2Fcommit%2Fcaa9c0a1&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7Cb78f6e9d698e43c98f9208d9ec091418%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637800346008209568%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=NC6sHsmTLKCZcsR2drU0y5qqHDbmLlbksCjr2n7M9vU%3D&amp;reserved=0
> [Xi: rebased for drm-next, use max_t for checkpatch,
>       and reworded commit message.]
> Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
> BugLink: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fdrm%2Famd%2F-%2Fissues%2F1549&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7Cb78f6e9d698e43c98f9208d9ec091418%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637800346008209568%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=lCJLm1GpevRtltwOiAWSJoNmXLxsEikVxxYc8oGCoyc%3D&amp;reserved=0
> Tested-by: Dan Horák <dan@danny.cz>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> [Salvatore Bonaccorso: Backport to 5.10.y which does not contain
> a5a52a43eac0 ("drm/amd/amdgpu/amdgpu_kms: Remove 'struct
> drm_amdgpu_info_device dev_info' from the stack") which removes dev_info
> from the stack and places it on the heap.]
> Tested-by: Timothy Pearson <tpearson@raptorengineering.com>
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> index efda38349a03..917b94002f4b 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> @@ -766,9 +766,9 @@ static int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file
>   			dev_info.high_va_offset = AMDGPU_GMC_HOLE_END;
>   			dev_info.high_va_max = AMDGPU_GMC_HOLE_END | vm_size;
>   		}
> -		dev_info.virtual_address_alignment = max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
> +		dev_info.virtual_address_alignment = max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
>   		dev_info.pte_fragment_size = (1 << adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
> -		dev_info.gart_page_size = AMDGPU_GPU_PAGE_SIZE;
> +		dev_info.gart_page_size = max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
>   		dev_info.cu_active_number = adev->gfx.cu_info.number;
>   		dev_info.cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
>   		dev_info.ce_ram_size = adev->gfx.ce_ram_size;

