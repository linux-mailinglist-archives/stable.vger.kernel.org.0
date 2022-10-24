Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E96609B25
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 09:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiJXHR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 03:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiJXHRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 03:17:53 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817804F3B0
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 00:17:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc+gUC8QPJHHTKOoDNttRsPFkWy32wJY1P0rVmlUYZN7WEFXehi8XrzrsTLW7h2qClNZ/bG6iC0VaXYYi3+51OBrdoHNGPG3yRHtqxsau2lr1SdNcZDOBRAQiHZy8HVotqOmQeZGOEGBMwsZ35JX2Z+0n4r3br59+nY1n28+Ug9Lj8OioXs6cR8Fw+RWodxvTL2P7HOgQ8wP2SsdDt8w8lyBm7dQNKq3R50uOCR3JVrDZI/OULzjcMNf48R+oLoDrRHtUb7iN6V06lZydmTiEI2+k2+mn2nXUS/E+26Q7oco0ddvPU3T8/B33n89mgaLkjT5AUYxFUtduVkRo3gPfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V+d9rgsmThmOvMfjTGEowicfrLtVcnuHyicer6XnB6E=;
 b=C/mCQ2ZgPlV4++TLgjdYBM4o4aj50NosKfqPWpXCnmzwsz2N+ORSlJYtN1dYTbZ+p3elw4PyL7IvcpHvSNY9P4KD02tWiWT+NuPZMljrlpl0xzKeBs1bqkgbfeZuVFXsn7yeuj2a8VGo8F6ue/qMf0sYt/mMWWpWcp+S8Dhd4pp/3WJHlkmkBMD2BWkEefUcZFG8cRAJxhGJ3rw80vCYy2qZz/AdgQ0A6Q8BkbSTiqsiMW70dZ01iCzKNVtRb5CXodUoeWvAnFSUjvvTnmM/Bx2VCONvtHOm6Fhj7uV4V5HmkQS6h1IlBtKIto72mbAWsoJP/KBZ+JqOueq/zM73OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+d9rgsmThmOvMfjTGEowicfrLtVcnuHyicer6XnB6E=;
 b=j+LSp2OI+8yL5kwE5qhBeGwP+FbgLpdcRQ9oCY2zQ7k4MI7ZzdT5//lICfmp8DwAtgAw9fd1VRJJ6DBvGQ6w+4/DKdJKDPNuN1HecYPxvCmWSqTpJiFkIuzwdLf6v1duccorIvXLfxnAA0k6y3mad+2sDgyhvVA0IAF5jd1mlsc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) by
 CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Mon, 24 Oct 2022 07:17:46 +0000
Received: from DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::d309:77d2:93d8:2425]) by DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::d309:77d2:93d8:2425%7]) with mapi id 15.20.5746.026; Mon, 24 Oct 2022
 07:17:45 +0000
Message-ID: <eb403eac-7f8f-30a9-c60c-152ef33e8f1f@amd.com>
Date:   Mon, 24 Oct 2022 03:17:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/2] drm/sched: add DRM_SCHED_FENCE_DONT_PIPELINE flag
Content-Language: en-CA
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
References: <20221014081553.114899-1-christian.koenig@amd.com>
From:   Luben Tuikov <luben.tuikov@amd.com>
In-Reply-To: <20221014081553.114899-1-christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT3PR01CA0066.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::17) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|CY5PR12MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: 13b48fb3-0183-44a8-89d8-08dab58fd940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ax0qTH3A/XAvpo26Q56BxZQX8nz42WTQ0/hJNSJf/EL8X4kcFuLmzbGsRHB1N6rXlsEqubg2wnb94D3WCpaW2C4y0HY58P9p9ICQ6BGtA/FAYRKo4lVZjWBG4cGF9eD/9Ss15HWrS0I0izDwCSpYdzHFr3FJsNfF+iXsl2IQzjSWuveNW5FqAsFVmC5Px/XFpQDzVjsOfDA+LUdI5arRrVuSQHHUlcEJzsmTmN0HWZO61qv6eeAIWDAh1x8nc/YRvxkOMHqnEKJXgM89FRe5Zc1UAvIerpWS3hTYCaG4fU0bYgeiRyVrIJrpqWjthUzonjpMFSQ/vV6asmKReLsttUCMgRe1W1pjGXZ7G0tAKRHwlCNd+9Llot7bJrvPXy4dhTzwJj9Ai3XfBk6y22bvOjlc1Hy45q/XkGdEXasrhv5KDrqlld2xuaSmL9r3SQS2dF+XyQVBsDrG2FX9RA9yYwAK6WgRetvVu/q6u+KXVQrwv/2myVegHpfgeJQZs19dIT6bTUeaSS99TjRmXz9KCxKFjkw3GUqKoSghYLKmbGruAv1ICpElADMU0BAkS5jB/4mU5y3Qb+eewk4CDwDBXAmOKlCGBIcMyLf1W9EI23oP4Cj6pKmALbfQeKnbMI/lxB3KuqxlHxnh1QVeY7pU/fh6qN2qC+Q4gKqYecuaa0pj5mUonCapeukHAaeAFxXSzZz5j/f3ccEoxgGczhvjVVV1ux4lmJKpyUcB5Eff4wkBZybgr+V4/eNbPfbLFtfd1RfHWnMJic/WEQhC0l93JYgbbvDzAraJr/dXAV9jnbA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199015)(2616005)(6506007)(31686004)(186003)(83380400001)(26005)(53546011)(6512007)(6666004)(8676002)(41300700001)(31696002)(4326008)(86362001)(5660300002)(478600001)(6486002)(66574015)(316002)(4001150100001)(2906002)(36756003)(44832011)(66556008)(66946007)(66476007)(8936002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NC94Q3VsaHc1WGdBRHdSODc5aWhJQTZVR1Vuay9XTEoyUXkyUEs1SEhCaDhi?=
 =?utf-8?B?ZW1hTVpGMmY1ZmQrQ2R0NVdSbCtDbHZGMkRHZ2Z1UlBWak1rY1Zoa09ZYUhz?=
 =?utf-8?B?MWV5REtIRWhIOEtveGhCM3VicjlubmEyRnVqWGJLYTZ5RDNySXJlcU50UWZt?=
 =?utf-8?B?OHlUOS9KWkxjTXJjTDM5cDhUY3RpaVpYb2RxOGRRbEJFc0ticko5bFZ5QmZU?=
 =?utf-8?B?dzMwYy9hUTJjZldja0pwNjVpeWpXdkN2YTVQdkZleUxvdkgvR3lHNGZUb2FD?=
 =?utf-8?B?UTFBSXB5OTdMOUhtaHBwbzFyQ2NJSGV2bUV1WTFvcDR4WFppbDBmcGgrUC84?=
 =?utf-8?B?MTVDbEhSRlpjRFg1b1ZZWDBKR0ZORHBKVFh0VDlyOGlBeXk4SFU0OTYveE5W?=
 =?utf-8?B?ZGdwZUhUdmdjczRDbnBFeENwTmxZS1M5bGFYSXk2czJpQ1VLd253QWIzWXJz?=
 =?utf-8?B?d0NFSnhxR2QxZXlTYUliZm9Bc2R6MXFYS0Y0U3hJbG1Cd0xUQmZPL3N1emlR?=
 =?utf-8?B?c054dDQ3L2RNNFdkcEQ2aGhOVnBCNDc1WDFIYzJXZ0FkR21sdVU5d3krM3dy?=
 =?utf-8?B?bkk0TG1Uek5YR1ZXVTdJUk5vcVh2cVV5d0ZOelM1RytaNzNvN051OXFjWjhw?=
 =?utf-8?B?MkFZbW1abldJZm52YjBOMjdZNi93K3I0MFVZSjFmR1BZMFZXOGxEYVRHRThW?=
 =?utf-8?B?QUVZS2V1eEZqb21TVDYvcTRhWm05WGMwTEttdTJYZCtXK0VBYlI1clFQZHpn?=
 =?utf-8?B?algvd252RVN3RUNUYTRDWU1SWm00VmM3emE4L0J5ZFJmTnQzWTlJQ2lDVzEw?=
 =?utf-8?B?SzdrQWlaWkltSmdSNzZPeVdjekVZY0NWT0E1WnBkMzFWbmk0TVNHWndxVGVJ?=
 =?utf-8?B?bHNZN0FwM3RIcWtVc1VjbElydzRMbWpBS2RHRmNySmVIbEVUM05MeUYwdlFz?=
 =?utf-8?B?RmFxWVBYVjNwM204RXptQm56UjZGT2JrbkYycTZCbGE5cTFvV3VsL3VHMHU1?=
 =?utf-8?B?OFNXU1RXUGlNTnhJMHdJdVBYQ1UwcDFQaDQ1bGlnME83VGp5K0VBVm5mY3ph?=
 =?utf-8?B?emNKeGprVGZta0pMQUpUaHo5cFJUVGJKK0ViOGduQUhhUXQ2cHg4eTI1K1Z1?=
 =?utf-8?B?UnlPT2FvYnZaMGxkM1JVWVlzOVNMS1BiUUFZWmFvUks1TVBFaFFjSGdVVHQ0?=
 =?utf-8?B?di83dkI3REQyVmE5Vk12YjlIR0ZZTEw1dkUydEFKcmM5c0VDOHlsYzVOcklS?=
 =?utf-8?B?bGV5NDc3Vm5uOTZLWjBEZGZQaE9DcEtmWGxnbFVDN1BPejlCYUFEWWo0S3Ny?=
 =?utf-8?B?ZmNRV2g3aXFOWEU3L3V5dmZ4MHFWN0tsV1drU2lKc2FHMXRIUyszOXV0U3Jk?=
 =?utf-8?B?amZsQ3V2VkVnNnJuMDRWb2VSSkRnckhRU2R5c2pqVEhZRHM3a3VWRW5SeXNF?=
 =?utf-8?B?QlQ1NE5JQVQ5UzlZS3NrVHluaDZ0elpkcURwc01xS0tOMGFlNXl0cUpETGdv?=
 =?utf-8?B?Q3V0Nmo5SngycmVWbXZpS0lSSzhPMDNhY0ZYUGlRdXVRZ3YzeFo1a2E2QWlE?=
 =?utf-8?B?RnlhcVhQeFdwaWFISm9ZSGdqRmtNRzVwS2RTUk1RK2lNVExtYU5HbWZMeGp3?=
 =?utf-8?B?aEVGUDhxa1kxLzF4Tmo2NG5qMEpIOVNrWHF2a01qM21YcnZMOEJuSG9Vdzdv?=
 =?utf-8?B?bk5pdUZtTG11MWxjcXptQUpJcVZDWG5wdDRzYk9xNU93MGdHaGh3TmFGbDJW?=
 =?utf-8?B?QjZRWmRlS3AxQithUXVxNHNQZEpmR2pVbHliU3M5SElEcFZjbjlZYm1CRSt5?=
 =?utf-8?B?QmNKemh4WThmZkQ4TkJ2a2RiNUMwZGlKeUtFZmFhZjNlWFZXZ1cxcUlPRjIy?=
 =?utf-8?B?Rld2OGV3WGR3a1Vxd0ZzZWxPVzVFeWNGT1BySEh5MDFDR2ZrdmM5UWE3UWpo?=
 =?utf-8?B?NzE1RkxiRWVLaEdUR0crd2RRSHB2bjdjZ2xhNit5UTZWaDlHdWRISDJnQWZX?=
 =?utf-8?B?Q1FVa3BTeVhJcncvTzY5amkxUXRUOGNSakxpL1dPTHlKMmY1Tkpyd21Henpj?=
 =?utf-8?B?VFA3TURYcitGRmZzOEttbXBrazB0SWY3dSt3MkJ2L2N2aFgyT21IdlVBWU9q?=
 =?utf-8?Q?2O1W0oEuZXJ0tHzQ7XEyIwuEn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b48fb3-0183-44a8-89d8-08dab58fd940
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 07:17:45.7588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dqn5eE3HF3DVuZWP7shZXFeh0ZLbySd8kVHqo3U96a+zpjEBh19WQEleJJJnO0aq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-14 04:15, Christian König wrote:
> Setting this flag on a scheduler fence prevents pipelining of jobs
> depending on this fence. In other words we always insert a full CPU
> round trip before dependen jobs are pushed to the pipeline.

"dependent"

> 
> Signed-off-by: Christian König <christian.koenig@amd.com>
> CC: stable@vger.kernel.org # 5.19+
> ---
>  drivers/gpu/drm/scheduler/sched_entity.c | 3 ++-
>  include/drm/gpu_scheduler.h              | 9 +++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
> index 191c56064f19..43d337d8b153 100644
> --- a/drivers/gpu/drm/scheduler/sched_entity.c
> +++ b/drivers/gpu/drm/scheduler/sched_entity.c
> @@ -385,7 +385,8 @@ static bool drm_sched_entity_add_dependency_cb(struct drm_sched_entity *entity)
>  	}
>  
>  	s_fence = to_drm_sched_fence(fence);
> -	if (s_fence && s_fence->sched == sched) {
> +	if (s_fence && s_fence->sched == sched &&
> +	    !test_bit(DRM_SCHED_FENCE_DONT_PIPELINE, &fence->flags)) {
>  
>  		/*
>  		 * Fence is from the same scheduler, only need to wait for
> diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_scheduler.h
> index 0fca8f38bee4..f01d14b231ed 100644
> --- a/include/drm/gpu_scheduler.h
> +++ b/include/drm/gpu_scheduler.h
> @@ -32,6 +32,15 @@
>  
>  #define MAX_WAIT_SCHED_ENTITY_Q_EMPTY msecs_to_jiffies(1000)
>  
> +/**
> + * DRM_SCHED_FENCE_DONT_PIPELINE - Prefent dependency pipelining

"Prevent"

> + *
> + * Setting this flag on a scheduler fence prevents pipelining of jobs depending
> + * on this fence. In other words we always insert a full CPU round trip before
> + * dependen jobs are pushed to the hw queue.

"dependent"

> + */
> +#define DRM_SCHED_FENCE_DONT_PIPELINE	DMA_FENCE_FLAG_USER_BITS
> +
>  struct drm_gem_object;
>  
>  struct drm_gpu_scheduler;

With those corrections,

Acked-by: Luben Tuikov <luben.tuikov@amd.com>

Regards,
Luben

