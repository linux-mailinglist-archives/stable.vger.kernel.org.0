Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB563BE76C
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 13:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhGGLxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 07:53:11 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:16310
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231358AbhGGLxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 07:53:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cC67TBor7gYnbsPZqrmM7AOv69p1hKoAMlqgk9X+AdOJIY5TX1UV66bAnPBdBx91Ig0X9iQm4nkj0q0oOkBHfXOXOiNDQul+x7DJuVHrX8fkVYJ8Ms0DKZw2/jvoUzggGjSs5f9/uhwYH+Z4vc7NKtgDQ5mjfpUrZ3PpGAgbAv6pJ7C1PC+5J7jEecSQsSUXq9BlQaBT31SQOQzWBe4kxjPpmBvyiFiMl3xqz+7kD3wbKhIwNPKat4AN/+XCBb7KcrTPZURIxM4zGGdS+kJrTfnRedbckgFyeHGBn06hsRooWPFTBrPQNnVQssOCLFLa9u36SRploUcjE2PIhEDjFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq4k0dBFAPIxfM+DrXin9piCMNIMh/ar88tCRObadYo=;
 b=ULDA5M7rSVZ1LX4VEwpYOnJLe3UnZCLaQVFRdABWSh+bEyBgaLOX8YpM7Z8UxgvrYoaOzoURWe0KA0eVaF2xv5fKchhrJzQ5J+93gUrkWPNZz6UEg/lL/YaxsY774h/xtQi9w8W2YA+GXkyRpvvhpiQGvoaMRS7iNmL0t9qwWi1DEAatPTrzprLrxdX1DMR+mjYZ/B2yS4BMyKqboiACWJieexjBctCk8TTbSgAcLgEJRcziZa7nCSx54sUMO2napqJOKmhDJXIh/VbmyFhrZQKhrZD96ZX7TJ9sLSHioE9NU+xwRisTsY2wWokYMMrTnpxFmKYKGzLUiQC4WEorSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq4k0dBFAPIxfM+DrXin9piCMNIMh/ar88tCRObadYo=;
 b=zM3zlXL70GQnM0HsKinnPYjLdL3T09S2joyJB4p6BPH+u7me11kIS2q5M15NIhVqTYoNC2pl5OwBl8iFTS/ZY9Scam7LnWpPBeOqclu7HXDz3BfWHS++J8zcV+0devEV8lnHYhpCzU3aNVvfkYvPh5NBu5eALrASxRkz4RgzeCw=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4191.namprd12.prod.outlook.com (2603:10b6:208:1d3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Wed, 7 Jul
 2021 11:50:27 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::6c9e:1e08:7617:f756]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::6c9e:1e08:7617:f756%5]) with mapi id 15.20.4287.033; Wed, 7 Jul 2021
 11:50:27 +0000
Subject: Re: [PATCH AUTOSEL 5.13 001/189] drm/etnaviv: fix NULL check before
 some freeing functions is not needed
To:     Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
References: <20210706111409.2058071-1-sashal@kernel.org>
 <099ef9f1cd1b865afd9cb8849d5485776ad1b868.camel@pengutronix.de>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <b7de6b13-e193-d303-33d9-05c518517711@amd.com>
Date:   Wed, 7 Jul 2021 13:50:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <099ef9f1cd1b865afd9cb8849d5485776ad1b868.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR1PR01CA0033.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::46) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:7671:3328:2129:96b5] (2a02:908:1252:fb60:7671:3328:2129:96b5) by PR1PR01CA0033.eurprd01.prod.exchangelabs.com (2603:10a6:102::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 7 Jul 2021 11:50:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4128eb38-0657-4c0d-9aa6-08d9413d69ce
X-MS-TrafficTypeDiagnostic: MN2PR12MB4191:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4191A1037CFDD50034A856EA831A9@MN2PR12MB4191.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H508roG/NipN2eFfyrX14GK3n3mVkGNdSXuLRF2Cm5/PuE9CDcZ7DuOIbJG6zpldqZcl08Pd+udAzwccHkepIJjMZTyhKSwBWXoja+roYXH+rIDH2rXCou3Xvu8abOUOaq4ozlzfTTemxM+ma837vSTzUjVzXUsR6/hYAwigrIQXBsKYUbisNKMx4gQOytyeUx9o+YBCfNC2Geo/yl5eYSBYRCjvl1naWJtwg765XoEJASEGpq69ivHh27+FICL2EjPTQzj71IwC+EMuUsHGiBrUsI9tmSDtznH3qa9wRK8QRey8RbFA7m8G55cmKiWPwc23+vfxrikhRXAPp8HdeH9lrVnC5soEX1835xF0w6/tptZlGHSTo78186GTm17ClfXRAEUIdsSaDyFuOD2zh+UP37pdwNVk+kHFa+XIKYwm09jP/ZZZiQEWIyMvIW5LaVxqGJp9GLBAr7WrPIB5SqMkmWJi8E8OaPGVoz1ADsuQw9rAFaZxPW1ECNgP6/iIe6luRdH3HARZ7ii6/VL2sATCh2ygAOeJeP39JBdY8cv/qkkgbVSuwlBNDvVxsS7+LPR50tQhfcIe3Jlf07sd1KZuLGSO1/Vfh4DfaOIK2zFa5C3m8qeExPuhl/gUfZUVBDOpzUHw38We5upf8pczczQWUVS2VdixJ880ZM2o1rq6/fpN6c9j+VFaZoEVSc2f9TPGxvI8wiTebEpXDv94wA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(31696002)(83380400001)(38100700002)(31686004)(6666004)(186003)(86362001)(36756003)(66574015)(5660300002)(110136005)(2906002)(8676002)(4326008)(8936002)(316002)(478600001)(2616005)(6486002)(66556008)(66476007)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3VXR25VdUJuZFpEWm5iYmZNMFJ1aG5BWks0SlY4blM1UlpDd0lVK3gwS2NN?=
 =?utf-8?B?RXgwS0xtNkJ4TlZja3RCUjIxcWhuaXhvWFJvMlh3VGg4Wks2LytDMXhrTlI3?=
 =?utf-8?B?U2tZZEVpa1d5SHFLSVhQaXVoZ0RzTmkzNWlpQ2t2Vnk5b1ZLQXJKY3VYUGx2?=
 =?utf-8?B?Tm5PWnA2amxrTUZDbkhyRUhRNWQzR0xoU2hlN0lxMkpmcTh2bmFxL2ZYd3Bj?=
 =?utf-8?B?ZzJuUFM0NHUwT0ZCZ2tFRjh2U0RORDczZzMwdTRxVFhoK0VQYi9HdW5RZE0z?=
 =?utf-8?B?bDJZbTdhNDJudGs2WGxXdDNDQ0Z6YWI0M2M4UzYrSVAvc3dxSkFMRW9HZmRH?=
 =?utf-8?B?cHZBdzVMOUJ4ei9UYUl6T0RHU3pza00zOUs1WjhCZXJaZWZ0eHQ1K3VqSUlz?=
 =?utf-8?B?bjYzK2t4VHpOc3RkSW5Sd3lpNDdJSWdwbkdsS3F2cWNBOFFqQUFnN1pnQ1dM?=
 =?utf-8?B?anZ0QnIvNmFqOEJUT1N4RjhVZGlvVy9JRUJXY2tzTE1Tb1I4b1ZlbzJqcmJu?=
 =?utf-8?B?VDFLblNpMjZjd0YxQVM3K3U2KzdaWTVGQjFOOHhOdGNsVWpjWlJvbzdVOXpn?=
 =?utf-8?B?RGhva3pmQmFuVWZraHBEUU5lQXQ3S3IybmdSRGl5R3YxRk9zSGJWckFRWHFQ?=
 =?utf-8?B?bDhJd0RlMmYvdDB2Y2loWk9SakVjNGFZWXV3TWJXOTh4bXg5Z3RSKzVCM0p1?=
 =?utf-8?B?TzZTY3BCaE0wWFpwMHB6Y3NZa2ZPVjNSY25jSExmUEE3NElvZ24vaG52Q3Uv?=
 =?utf-8?B?am50azdudmlmMWQ3Wjk2Z2d3amtDMlVKbFAwMVZISXdsbXhaZUdybFRvMXh1?=
 =?utf-8?B?N2VzTmc2SEtBMkEyaFdNT05mUWJMUndYblpOVlVGNjdSUmM4aTNNbW93cTdL?=
 =?utf-8?B?VENFeHNDNkk0MlZnMVoveHk3elVpWUhNdVRYNXJEUEx5a1JscCtCRm9JcjV3?=
 =?utf-8?B?b3ppZjRlZDl3VE4rMnc5ZlBlRzlFL04ydWFiaklkWXUxVURhQ28wRzMvYWd6?=
 =?utf-8?B?dlpUK2xlUTh0WFJmTE1ZUWRRQmc1VUNTL0MyOVBSdk03SE1FWEJScHNhZjhy?=
 =?utf-8?B?cTJzc0V0VFVEU0lFbm5FUlZSODA2UWhlZG1XSDhjMUVwK1Y0YjZUNFpNbExE?=
 =?utf-8?B?TnJtSU03aVAyNmtKWE5oYlp5SWRqdUlmMGdGY29BNDJELzJRWjdxNlhsRXNp?=
 =?utf-8?B?ZjFLMzhPbDluMFFSdXVXalIrNkdjM0FhNjNTWUxqKzlGV3p4SkRBWVV1ZG16?=
 =?utf-8?B?VHZydkc1cEtKd3NLaTN5VjUzdTY4b3RSYXZFUHRUNGVuanJZRGY0aU96bTRk?=
 =?utf-8?B?YTl6QmZTNHdQdHhxVVZxa0RvOUFkTUwvN0Ewd2huWFcyOS9YdW9qTngrMXNo?=
 =?utf-8?B?ZlFJZmhkcENsZS9nUktnZGhiUU91Z3RqbEgzd2p1azRUb3lib2pJcTBqZ05O?=
 =?utf-8?B?aXFvVFdQbG96Z0NSM1RUSldqTXkyMDFLT3U4VHcrRzFTSGZPejU3ZWtVdFk4?=
 =?utf-8?B?SmRUWVNkMjV2ejByZlJXTVhQSHhnN2tDWldHVjRONmQ1a1NuRHBieXhUSWE5?=
 =?utf-8?B?d3RRMmp0S0FZUzNMamw5L0ttT0ZCZ0lzNDZyUWhVZEdlUjR2MlhUZi92b2Zk?=
 =?utf-8?B?enNMWnkxWUlrakJ6RW9YK2FEVUJoWTcrMndDUDRVdEZSNm11V1JUdXB2NHJL?=
 =?utf-8?B?akJ1WDc3b2lMdnVaQlZoWGRXYTE5cnpzbFh4RkMxTVI3R2szcXhrbnk0MzMw?=
 =?utf-8?B?cTZVTjB0YVpEbk5NdUp2bVNmVFY1VVUvRjNLcG93eEdrWGdENmVSaEtCQTB6?=
 =?utf-8?B?MGt4THBBMDFtZWNCdWNMdmdKSFlGczhuMHROYkpwczZuNk5xUEhIbVB4SUdL?=
 =?utf-8?Q?SWlUdX4509iG+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4128eb38-0657-4c0d-9aa6-08d9413d69ce
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 11:50:27.5383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZbch/BfdsFjhkuqu4/8YN0oy1XyUVAWuoYC5o3Q4jNiEuSq5etRpTgdyZcTIWCd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4191
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 07.07.21 um 12:52 schrieb Lucas Stach:
> Am Dienstag, dem 06.07.2021 um 07:11 -0400 schrieb Sasha Levin:
>> From: Tian Tao <tiantao6@hisilicon.com>
>>
>> [ Upstream commit 7d614ab2f20503ed8766363d41f8607337571adf ]
>>
>> fixed the below warning:
>> drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c:84:2-8: WARNING: NULL check
>> before some freeing functions is not needed.
> While the subject contains "fix" this only removes a duplicated NULL
> check, so the code is correct before and after this change.
> Is this really stable material? Doesn't this just add commit noise to
> the stable kernels?

Yeah, agree.

I also had a case where a NULL check was removed in amdgpu and then a 
bit later back ported to stable.

Maybe just use something like "remove superfluous NULL check".

Regards,
Christian.

>
> Regards,
> Lucas
>
>> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
>> Acked-by: Christian König <christian.koenig@amd.com>
>> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
>> index b390dd4d60b7..d741b1d735f7 100644
>> --- a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
>> +++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
>> @@ -80,8 +80,7 @@ static void etnaviv_gem_prime_release(struct etnaviv_gem_object *etnaviv_obj)
>>   	/* Don't drop the pages for imported dmabuf, as they are not
>>   	 * ours, just free the array we allocated:
>>   	 */
>> -	if (etnaviv_obj->pages)
>> -		kvfree(etnaviv_obj->pages);
>> +	kvfree(etnaviv_obj->pages);
>>   
>>   	drm_prime_gem_destroy(&etnaviv_obj->base, etnaviv_obj->sgt);
>>   }
>

