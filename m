Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0026EF312
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 13:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240651AbjDZLGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 07:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240629AbjDZLF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 07:05:56 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2055.outbound.protection.outlook.com [40.107.212.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197035260;
        Wed, 26 Apr 2023 04:05:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2k7Sb4jrUrvKsX/uIoIboM/Z7yMd/Osd3+vwoVYCsQ696yX6/nKJ5jzdHZ5tizN0Fsd+RBV05z4EKDZb0roXxRR0etWpPVjNhi8MAskmQh7ZRRrGRc8FfESqp3v2IqpFpGqzhNNE0KYHn3puBv3+wPmjqJCVtNXR4Wwmu52IAfMoIYHM1ctBDiWNetIs+BT0OJgUuwEz8XAhrqwJqZ2ZqGpOqcz2/9a1wEMUZNDDPMqSPtjpA+S/WM5aQKo+keJWemTgfp3k3nIkvgOR+jI0D5GjCWZje3rsVSFAJU1l70vmmH/jxq5+4SLsPZZ5ZRKRtpaqHR/sSUXqgtVLPNOzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywNiShvSvew1RdPtvzN/ICA4H+dVo4oRdqm1gNJW9ew=;
 b=U58xqs+IujBrcH5bS2/7pPuqBsPXaX8fHZLf5msGsWZDrGOoq2EcHC/3vIX9JlOlC8+AVrohBzrIpx572DgdeMg//GrrRlYd55saO3ja1CvhJIf1APEQ9he+UpkvdHieYUAnUh5abU4pLP1tt1BIRLGv6AwE7Y5yI1Esfa9YDMGzufSGl9NQ1LB3xeW7xz/rqOu3P3aAL80+qMpWf4xBxnQEc0KnBL/1PaPVMFMm7aY3FdSQxMYFvSXU6GKBliIxxCZgAXbROzY+oiR0+ghQa9L/BURBs6T5hrbFRkC7FHKZWoOI/xXiL4S/Hy3Z0mapuf99gdAqd+ByoMBMk4CljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywNiShvSvew1RdPtvzN/ICA4H+dVo4oRdqm1gNJW9ew=;
 b=LdsH9oes/ywKPRQ2xzAHZKHytpnm+BQURD7pmtHs+Y2sT5j/teSH0+3slQ/mjdRXvWodXOUHBTLNF+2BZZLpCBjffcC31apicjjCsHWLRgOJkG1eox8Vpylhq+xKhnvWOVHltZrypS3GGe/V0wNEzkvUqfQLkVFXR1oiGOwNEv0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 11:05:38 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed%3]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 11:05:38 +0000
Message-ID: <f889f994-d2cd-fedc-8c95-9c8501037809@amd.com>
Date:   Wed, 26 Apr 2023 13:05:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] drm/amdgpu: add a missing lock for AMDGPU_SCHED
Content-Language: en-US
To:     Chia-I Wu <olvaffe@gmail.com>, dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <20230426061718.755586-1-olvaffe@gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20230426061718.755586-1-olvaffe@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::23) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|LV2PR12MB5797:EE_
X-MS-Office365-Filtering-Correlation-Id: f44389a1-bcbf-4dcf-e8f6-08db46462a8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3gcxj/seQQO4U/yV6MT7XQwe4lG+fV94ANsafIwtDiqIHtox3Ex4rIpght6eZqnNs8yNPQOttClkl4f+1eher56GlbT7I5U/jqTMlGHGp/3BvLBXD4ZzuBWpPWq4sOa1mw9xw7egdcZ6o7pFOyS3YdURDUeq60MiTsLhNDRiP81lG02C+q4hafFY4uvJeYDew/bddVQqC8Emmv2VozAnwe9GMCMOm5fPqrvUopsLxdlczbXvhQxQ5pSrFfZKXE0gHqnonX4eURZBMRxxi1Km183ikwArbfceElOmzEWyHMVUvgi87MZpCpFzGPKmxwslTDJ4vqGES+bs0FegCZa2dPdRMQgeXdAMncUK7ZkMNptpycmZzyLb96YoCaNM7S8bUGiqN1nbBtg/+kqbS6Os+4YxCNA2y2sfW11CuiLHJelS8/CHiSr+mMsFvTGbm+w4bwqHN+0Y4gzOKuCkGBsidYVahFHrFKnclI9H2U8zzbd94mWah/o20/iyPNjxuBEfoaBOJ7HsyMkCTE1V/yKSdOF1qq/sl6oVPvij4Tpqv0rWveC9mAuz5Do2pGmecaW0HhW7pycH2PLiI4msSzHYyEhMDGc+Nveyd7SHF6ueSoVfFm+hcjCIgzabtOoEm2LHL6XzN++fdmDIrf/y4SZqTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199021)(54906003)(2616005)(66574015)(83380400001)(478600001)(31696002)(6486002)(26005)(6506007)(6512007)(6666004)(66476007)(66556008)(41300700001)(4326008)(316002)(186003)(31686004)(66946007)(5660300002)(8936002)(2906002)(38100700002)(86362001)(8676002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEtaU1lCb004M1JPQmxUU1krbzdMNWhsdmRPdi9PeEw3dFZnVWtDQ1ZnVTFn?=
 =?utf-8?B?VEJHWlhPUktZQUI5VlFSVjlSTGhteS9yWmZJWUl0VFIxbm1XNEpiNS8yQUt0?=
 =?utf-8?B?S3JVMWdMSUsyZDNYNmd4SSs4NkwrRGEzdmxFWEs5OXpacStuSHlQNG9iZ0lp?=
 =?utf-8?B?cXRzMXlGZzVDTWhXakVJTU9SN1lra3BBUTBTSDZPSzBTT0F3ejJNN0FYbnBi?=
 =?utf-8?B?OHBPT3BxVUFocHEwdGpoOUF2aHk5RWZuRERZZUp2Q0wzNnp0ZnN5WVhjNFBo?=
 =?utf-8?B?eWZZbWNPV2dNMTdyaWRkNGgxMDBBZnBTYmNFdTlrejBBNStEeXpHeXpoY2pF?=
 =?utf-8?B?UkpsQ0tTT1gwNkxVd2EzdGo5NGxaL1FzQ3crQ1piNTJUUnlJMEVvTTdHNXFS?=
 =?utf-8?B?Rk5vRFBTbTF2ZnlNWjFJcjBwL2g4ajYzQ2NhWWtmdlJGdXhxTWZzaFhCa01r?=
 =?utf-8?B?a2dkRU1vWFZ3K25XZzNUOVBTcmxhVlQ0QTZJaGU0S0ZUSjVySWdpRG1KR1JI?=
 =?utf-8?B?TTVVa3psY2RhT1hGQjh4Q0F6ZXdvV1kyUVZPajcvQm5NMXRac0Zmc28yWkRF?=
 =?utf-8?B?dE1IaVBXTGFtVytTd01ubUFlTVRyL3pzWmxrWFpoZGFlU2NpcWkzT0dBNUpz?=
 =?utf-8?B?azVJQXVUbCs0dkNFQmlQeHNWaTFoZDdmbU9iQ3BxdWhRditrL0lZbldzRVNz?=
 =?utf-8?B?MG11U25qM2ZhYk1UaHNXckVya2tybjBZYUMwaE11Y2VibnVXS0dicW5MNWlz?=
 =?utf-8?B?QUlLT1k1bXcwZDQrellnWU5lSFZFWlBkdEZSc2Y1V1EvLzVoQ043Ri80U2lM?=
 =?utf-8?B?OUpBOGlBclVtWmI3eGtsd1IrVWRIc3ozZXYyVE5FSzBJMEhlQUhNYVlnZFkz?=
 =?utf-8?B?NisxUHlhMitDMmpnVlM2WndKNFI0YldPQUY3NFJJbUJkOGFkWXR4YkFrZy9u?=
 =?utf-8?B?ZGNSTnVvWGRxWVFMaUFKNkIway8zcGlIUnc0V2QzU2VGN21ZZTg4VlZWem5D?=
 =?utf-8?B?YzRxWEY2VndjUUE2M0FlVG82VDJTUmlUTHZiLzNmY1RSeVMwc3JGWExNNmdU?=
 =?utf-8?B?bVdFZ2M4c1N3WWIxVFROQ3J4U0Zxd0JtNVoyYmMvck1xQ3R2WlVMUkxPanI5?=
 =?utf-8?B?b3FoQnVxcG1uMlIvdWY1NCtEdTlac0ZrVzRnL1BtMFhqemhHRVNYMkU1VGRG?=
 =?utf-8?B?MktsVDNVa1c1bFVGSi80cmpjb0MreTB5VkkxMjEvVDZVOVFQQWJVNE1yaXds?=
 =?utf-8?B?Y1NwSEFuZTJoZG9QSTNQME1aNFR6YXdiNHpvZ2NVcnlQK2pqY0EzWkVzb09q?=
 =?utf-8?B?ajZpQ0htRmV6WkRSdEljRmRENEtEMTZBMXR5WURzVVhQMEtTQnV4QVMySGE4?=
 =?utf-8?B?aUpEekpFM3NNS3g3UU02cHRxNGFoQVdIbTN2S1EzRDJGSGZwT2RvMytYN0tj?=
 =?utf-8?B?Z29ZK2cyaGRWckFzb3dnRklCOUExcnVZcllOVzJGbDBwVzkwZkkrSk1YY25P?=
 =?utf-8?B?alI3emVtT2xwOW9hdXlRaTZZQjVHbkF3dFVHT0ljVWhzdmFQT1RlMHI4WHRD?=
 =?utf-8?B?SEdaVmV6S3BRZEcrMVpMdFlSaTZCQnoxbFFHUkdtWUVaKzJleFUzNHZGVzNW?=
 =?utf-8?B?alpkMmNHUHI2UmF2ZnlDOG1WVGhNa2cvdUNZQTFrMUVmbWt0Y3BScnNBdk9G?=
 =?utf-8?B?YnBUSFhXN1F2ajB3Z0ZpWlliRThmakloWURSaU5YQ2VrU3piNnloanZJZ2Qx?=
 =?utf-8?B?N1I2bUdBTTNOWEpoUGJKMFZOY0d6em9wc1MzMFZGZnRuK2VJeEsyTzdDWWVn?=
 =?utf-8?B?MmZ4ZFBGWTZPdElaWFJ1NFVFNVhzczgzWHBwYWVvbE4vU2gvNmRIZjJMSjRG?=
 =?utf-8?B?V0xyQmFnUUpZVm4ycjFKcm9vbWJZWXd0TzN2Y1B2YUNpaXovdGtoQjY5b1lU?=
 =?utf-8?B?dVp0RGNNRExxNVViRmU1akZaTzNmMmR1Mm15R2VLZFRuY1FPY0tDZ1ZmdTRm?=
 =?utf-8?B?OCtVVHFLQWcxUnp4V0cydkNMR2R2UUhvRStnbGtzaGFHNmZTZWNGQWVGVHVv?=
 =?utf-8?B?L2RZYURqMGw3SWY1R1d6WHd6U0JiR0tpN2RkRmpFMVdpWXNzSGFORFBzZmFn?=
 =?utf-8?Q?tLcc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44389a1-bcbf-4dcf-e8f6-08db46462a8b
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 11:05:38.0692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zdsUST/Vq1M2Y2+f3XC6TkK/KKPFFRMISH+2Fd4WshqEnQGXo7LSzkfxMt98Pe+Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 26.04.23 um 08:17 schrieb Chia-I Wu:
> mgr->ctx_handles should be protected by mgr->lock.
>
> v2: improve commit message
>
> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> Cc: stable@vger.kernel.org

Please don't manually CC stable@vger.kernel.org while sending patches 
out, let us maintainers push that upstream with the appropriate tag and 
Greg picking it up from there.

A Fixes tag and figuring out to which stable versions this needs to be 
backported are nice to have as well, but Alex and I can take care of 
that as well.

Apart from that the technical side of the patch is Reviewed-by: 
Christian König <christian.koenig@amd.com>.

Regards,
Christian.

> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> index e9b45089a28a6..863b2a34b2d64 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> @@ -38,6 +38,7 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
>   {
>   	struct fd f = fdget(fd);
>   	struct amdgpu_fpriv *fpriv;
> +	struct amdgpu_ctx_mgr *mgr;
>   	struct amdgpu_ctx *ctx;
>   	uint32_t id;
>   	int r;
> @@ -51,8 +52,11 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
>   		return r;
>   	}
>   
> -	idr_for_each_entry(&fpriv->ctx_mgr.ctx_handles, ctx, id)
> +	mgr = &fpriv->ctx_mgr;
> +	mutex_lock(&mgr->lock);
> +	idr_for_each_entry(&mgr->ctx_handles, ctx, id)
>   		amdgpu_ctx_priority_override(ctx, priority);
> +	mutex_unlock(&mgr->lock);
>   
>   	fdput(f);
>   	return 0;

