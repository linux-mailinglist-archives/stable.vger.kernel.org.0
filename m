Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50D6631FFD
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiKULMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiKULMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:12:09 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79F0BA58F;
        Mon, 21 Nov 2022 03:08:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPB4BfoKnZS/lmzll43namEWjcY2NvRaqkl/8QhSDAQ6F1rpLrx/xymE/r9lv6WKWlGdieXrFyVO8LfMHV7bYlu06fhCy7722CF9fRjeCvdA3gW/aK07dr1yJboH2+mEVFnR4AgZAFWjg/MNtjQ+8t9H/TzOBl69TAVd8zSxJAL2aLU1Fka75FeaWbnLkh80NAuSAM+KR+/+LsJD40fLio6mrtW0wkeUI6tSrrnle+tvI0MJZlbSQ2eQdSeiqMIPzXi6lgSD43a4+cEUEq79a9rWNjjinzxEve2g2DUqmlz7mODHOeG0xcsRIT8AxvDIbrtdDbYHCc53XDqTTEyJ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OhYESem0zy1fPSEHzSf/MD1Jlfbs2fUilziKTwR3I4=;
 b=k3sOYwdn60pTy8IH1/VDIEp7r42Nvd2UDtRywB+exWZXf43yjjz6l+L+HWm2gznA6qk96TYNqZQJ9G//FmvitpuILx5SNUOcRzbZTAN/gQDiWzuIRv88jpcQ10G3kB4SuxIfo57TzkMJ8fzS2degeiI6tMkedtHpFca57zUKgdAc3XEeD8dLMJiUA8l++DOAeBFxtD/3XJ5pOe4b5Qjp+QGP06WpAyYumkyq50QTpRujKsbU6ENNWrFFtH2rJg9WY6MaPyBu1Ry6vj6BFMgjHsWGE8zxFHYhf9AOE0GOJFjhiqUovunZgLkjNRygZOuBd6+WQZnIHfIVMg3lXMxNnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OhYESem0zy1fPSEHzSf/MD1Jlfbs2fUilziKTwR3I4=;
 b=THgk+Ob2di2+EYg2yopzBkgUbB9HvMaYZjehbN740/DW/ahwRO6H+fs6iIJRjPzz4QGbP0IFqSD0pXH9eExemueqVWf4w7PJnP5WGYn3qdPJm7+XG0Qs5n8dQvdrFylY3bRaHTPAiMb1KtqNVCzEmV5DuEqhb6u7N07zDcjdTaE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by SJ2PR12MB8033.namprd12.prod.outlook.com (2603:10b6:a03:4c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 11:07:46 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421%7]) with mapi id 15.20.5834.009; Mon, 21 Nov 2022
 11:07:46 +0000
Message-ID: <0916abd9-265d-e4ed-819b-9dfa05e8d746@amd.com>
Date:   Mon, 21 Nov 2022 12:07:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH AUTOSEL 6.0 38/44] drm/amdgpu: Unlock bo_list_mutex after
 error handling
Content-Language: en-US
To:     =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@mailbox.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>, Xinhui.Pan@amd.com,
        amd-gfx@lists.freedesktop.org, luben.tuikov@amd.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        Alex Deucher <alexander.deucher@amd.com>, airlied@gmail.com
References: <20221119021124.1773699-1-sashal@kernel.org>
 <20221119021124.1773699-38-sashal@kernel.org>
 <e08c0d60-45d1-85a6-9c55-38c8e87b56c3@mailbox.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <e08c0d60-45d1-85a6-9c55-38c8e87b56c3@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0043.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::16) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|SJ2PR12MB8033:EE_
X-MS-Office365-Filtering-Correlation-Id: cbea118f-285d-42bc-bf7d-08dacbb09e8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 575/dNStLYR/0Dr5CvQwqt+h8aifRgZJLItLLDGxeW7aaeEXwB3DVWITPT7Hcry4cH0n7fykoIC0Ps0Rnfjzo+DS+MTYqCUzHYbcSXppk7J/t0NWEAX5HQqGW8ALRD7R6002GNAVJNZhFGGLHXS6PcWWfbNEEKTrAWrlsjchax7bzFHDcP8W9x9oxtAMGErgXtT8CDpKaQYh4e1+2jH/HRhpbVLnKrE4pMUarkWZGeTvbdYZOzXcsIQzh5GOf6w9zfpQ+poaW+/W1MwGIVx3TgWXa1fhTGYy5x2wXEL1NhfIIUF517IRQvRYet8s6CThzeVwH8lYxz1xlv+kIUVY+4O+OGsO9bhUVoaUs/5VWrWn77phGQo7u57uqDcBjefjrLYDROKfl7CGZ/uLY9zo/S1rb9n3xWLYctZTCfitiv+07I/JSRtKupML5+Zg7cwBHEz5Ucc0PDvZD4jufaQaK36C0XqfMK1ilVbMviU7xSkjX0/DEswNqcg0OZeN15YhCZWBxZAd+M6sM2j7YinUvWb5b7DonLAcnccHcz7jN3k101xmwx95r/WND2kqRHVqbnJntvb0qAg7TuZJPK9FgSpamo0ia6u5U1G135voBjzDzPcBQlsSndPeFdRcqpzUN0IihPuPDT3Yv/XrXErVqNFyBVvPwIhszOJyba3Qb+K8SwepWy28h/rxO5u6nxGYfK8eWF8QHA2K926ZOwOX9xeVsIGo6eFc3VE9dV0Okck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199015)(53546011)(26005)(6486002)(6666004)(478600001)(4326008)(8676002)(6506007)(66946007)(66476007)(66556008)(110136005)(41300700001)(316002)(38100700002)(6512007)(66574015)(54906003)(186003)(2616005)(83380400001)(8936002)(2906002)(5660300002)(31686004)(36756003)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ai9wa3VlVGZJL2IrbGZadkhHYlh4N3FYOS9sdnZsRnN5WnpkWjg5czF6YnRV?=
 =?utf-8?B?bVFKNHBoMXl6VFBHQ1pWTzhvTXFncVp5RXQxU3JHajRJN1doSjZzTlhwcVRT?=
 =?utf-8?B?WDM0bm5JMFBZeU9La25ZaGZaZTllWkRlL1ZzRXJzZVdkRWpwZUVESU5yT1A2?=
 =?utf-8?B?bWkyYmpQRURGLzNUUkVYWnhVYWRLYStpdVJ0MWZieUU3b0Q5OEppY3VsT1ZG?=
 =?utf-8?B?RlV3eGJGano1ZHBZY0pJL1FSMjhDUlkzc2V4dzlnaTZtSFZnaE5XOFZzWDFJ?=
 =?utf-8?B?cHhHTVo3blBCNXR5UXZ4MjdmOHJsQmtqV09udjBLS3FKM3BSbWZmZGN0L2ZG?=
 =?utf-8?B?VVd6UTZrVUw2MXhHWE16SDQyUm5UbnFlYmVlOFVNRGljdWF3dnlkcUR2WmVz?=
 =?utf-8?B?L1daRE5EeUFMODlpQUw3V1F1WGVpMFJmd2JIZ1NwcVZXRzNHUzRIRzlHK3lq?=
 =?utf-8?B?N0t0RHRYTE02NHZ0eU9yV2NRMVBtQmVLWHorQkI2TFpweDBJdVJUcFhlTDl1?=
 =?utf-8?B?bHRCYk9LVkx1LzhFeGdxb2g4NEdlZldxaGRTaU1GS013elpiaWJ0emJ4VDdr?=
 =?utf-8?B?WkdDNHY5b3JYeVRHZnN4T3pNUUgveUwxdmErUG9STjBoOXBXakxMbHVpOXBa?=
 =?utf-8?B?VHY3QXY0SVRWTHprbGNnd0lTUVZtZWF6WklRb1A4WFhmWnNMRjJOYnJYakFW?=
 =?utf-8?B?ODgwK3M3UTB3T2NtU1ZKc243dytlaThBWFVhYUJNeFRzRVBFb3R2NjZmbTNT?=
 =?utf-8?B?bngvVVBpUzVJejFEN3Z6aXdKU3ZTZWlQenVWdXJmZDAvTFlydTN3aE16Tms0?=
 =?utf-8?B?UjdkbjExc3phSVhWcExJczhxYWVEdWlXVEFiQ2c4aVEwWUd0dXJRV05CWkhn?=
 =?utf-8?B?VmVMblBHMGRBb3VIRG00RHZGTTFWd3BiaVJTeDhFbHF6NmsvNjhBZkZobmpa?=
 =?utf-8?B?TnYxV0FhK3IyVVhRek1vLzRGZjRKWEpIWUo1aEhxZm4xNGlNaGp5cmlyc25j?=
 =?utf-8?B?MzMyNVhrZTZ6QmdVS01TZU5nMkxXWFJhenpNb2xVSkhnZ2NZMmhLUXdXRlNF?=
 =?utf-8?B?Rk1JMnBGUERFVTZKRDYzOXpFWEYwdDZaRGVIME42L2FpZHh0ZFVMREZKRUVx?=
 =?utf-8?B?VXArd0R3bnFXVzZJVUFMTjBDQUhyb2trOWEwQkhBUHAzNTk0OHZ1ci94bFlJ?=
 =?utf-8?B?dTh6cUFQMXBPOUVrajVZNE81TzdGSEhhazdCOTQyUTJPVnQ4ZEloZ1pTOHc1?=
 =?utf-8?B?RjdFNjI3WTJ0QjlkSjBSMlovSzU1Mm13VmNNWWNOd0tzS0pDQkFaSkFCaXNY?=
 =?utf-8?B?eVNMcnVMcmc0RzVZb0xPR1VKaWVFQ01sREg1WENJVithTGw2djlSV0J4Skx2?=
 =?utf-8?B?QXk1NUtVdTJEWHVVbFp0THhCNGNNaVVGT3hVSEtsUktxaHZodDBUUzY3WjJP?=
 =?utf-8?B?MGpNa1YrNUxkd2N2aFp6QXlDa1UyZ0J5M0xVRDd2UDlKQzdjSHZFRjhvb3Zw?=
 =?utf-8?B?ZnVyVjAzdUdodnM3TTRMaDVKaGFhZTlSbHNKeG1UUGhNZXFKdGpXemhWdnEz?=
 =?utf-8?B?ZndnUGgwNlRWVWMzajgyRjZpcjkrS3lQZkgvbHNqZGJ6Kzc4WmIyb1kvR3k3?=
 =?utf-8?B?TWxNYUxuRExmSGcxZDR4T3hyMlJoVzZDb0plY1lvZjlGazRVNjh2OWt3bzJt?=
 =?utf-8?B?blE3NVo2eE5RL2phYmIyaDlCVm1ua0t3SkVveEtaUlJjRHcvd2tGKzNBL215?=
 =?utf-8?B?cUZMaElrVXdjbmVUM0dOT2NsZmtKaUpFb1ZxTDl6VnZxWmVUeExFNjUrTU1H?=
 =?utf-8?B?OUR4NHlzZVZlU0hRNlBQNE1mNC82TW5PK2tOMzU4S0F1V2d6VlFTMmg3THov?=
 =?utf-8?B?Rk9OVmxyWWdOUDlXdUZTMDJEaE42by95N1dHdVVMZ1ZQemRSQ0pqUm0ySVVv?=
 =?utf-8?B?ay90cFpxVjk0V2tuanlucDlPekZFQ2V3eVU1L1MzMmFMOGxWNG9MN21mbDZp?=
 =?utf-8?B?M1BEUUR4eHFQRXNQK1JEUmdFODJHdG5lYmkrUnFaWWhoamRJNHJrWUEwcDR3?=
 =?utf-8?B?M1RkMHlBZlRYVVhocXFJRXVVR05NbS9EenJMakd4OUNmTlc2eXpaSFRBcTFW?=
 =?utf-8?Q?rVYw=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbea118f-285d-42bc-bf7d-08dacbb09e8a
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 11:07:46.3578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rp5YvrSKlzYCCgOnRcW/dIsFYjRVP9fdRyA2YZpKa+VnqxuUvrlaS34a3DHZE2/C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8033
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 21.11.22 um 10:57 schrieb Michel Dänzer:
> On 11/19/22 03:11, Sasha Levin wrote:
>> From: Philip Yang <Philip.Yang@amd.com>
>>
>> [ Upstream commit 64f65135c41a75f933d3bca236417ad8e9eb75de ]
>>
>> Get below kernel WARNING backtrace when pressing ctrl-C to kill kfdtest
>> application.
>>
>> If amdgpu_cs_parser_bos returns error after taking bo_list_mutex, as
>> caller amdgpu_cs_ioctl will not unlock bo_list_mutex, this generates the
>> kernel WARNING.
>>
>> Add unlock bo_list_mutex after amdgpu_cs_parser_bos error handling to
>> cleanup bo_list userptr bo.
>>
>>   WARNING: kfdtest/2930 still has locks held!
>>   1 lock held by kfdtest/2930:
>>    (&list->bo_list_mutex){+.+.}-{3:3}, at: amdgpu_cs_ioctl+0xce5/0x1f10 [amdgpu]
>>    stack backtrace:
>>     dump_stack_lvl+0x44/0x57
>>     get_signal+0x79f/0xd00
>>     arch_do_signal_or_restart+0x36/0x7b0
>>     exit_to_user_mode_prepare+0xfd/0x1b0
>>     syscall_exit_to_user_mode+0x19/0x40
>>     do_syscall_64+0x40/0x80
>>
>> Signed-off-by: Philip Yang <Philip.Yang@amd.com>
>> Reviewed-by: Christian König <christian.koenig@amd.com>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
>> index b7bae833c804..9d59f83c8faa 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
>> @@ -655,6 +655,7 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
>>   		}
>>   		mutex_unlock(&p->bo_list->bo_list_mutex);
>>   	}
>> +	mutex_unlock(&p->bo_list->bo_list_mutex);
>>   	return r;
>>   }
>>   
> Looks doubtful that this is a correct backport — there's an identical mutex_unlock call just above.


Oh, yes good point. This patch doesn't needs to be backported at all 
because it just fixes a problem introduced in the same cycle:

commit 4953b6b22ab9d7f64706631a027b1ed1130ce4c8
Author: Christian König <christian.koenig@amd.com>
Date:   Tue Sep 13 09:52:13 2022 +0200

     drm/amdgpu: cleanup error handling in amdgpu_cs_parser_bos

     Return early on success and so remove all those "if (r)" in the error
     path.

     Signed-off-by: Christian König <christian.koenig@amd.com>
     Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

Regards,
Christian.
