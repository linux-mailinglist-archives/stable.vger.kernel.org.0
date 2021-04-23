Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D769A369664
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhDWPxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:53:30 -0400
Received: from mail-mw2nam10on2065.outbound.protection.outlook.com ([40.107.94.65]:5472
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229691AbhDWPx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:53:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qm2emFvpatDd1/aimMUkFd0EEiRKOcKN+rWec0nxkkOi+T16rjYLHCnzXtsneqGuII5B6oGoe8LiIeQ8oxCBy1PxjDjc1jXwk4Gb5DysX8cLbcsPCVNQpF/hczLgJs9kJbjft+I/YHPcwpWTs8D+rEK74iHEs273yo1OKHsolwkfpGAtg/yGPDd0TGBQOOiqc3WjeZ4EQgP7OTyiBUOTjtBAVKPGhwYcQaHlCnoAtnqVu+fcGxLeyWAQNP+o+uFE8Ff9CHFrxoyWn8hpBbci+K+JsCDokXMAUFuQ9/uTLjNawSXUexh1nje2QjLlenjcovRedldPNw0+Q1ze3DlCnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTCE1wCE8ilD8ptwSSOzEotnlVsHuE+KD0vzgginR0A=;
 b=FlgXZjvvdSfWJ2jjROaFni1tUecJdQsSbVtjGxZvHF6ysmW9Oe1S1fC5SbxeTKArbZzl0+EPFScqzs/laR1ZdvxPZ2sbPoJTF+B65f8IzWJ4McSb3iVTnHLfw927M8sIFCtO4xJ0rBKnSKNZhT81jwbA5D7Mpp4k6Y1Y7nb3CffZCEvADsE2ZbK5cp/y9iMD4Q/IoJHv/csTFGsr8DOaQUip1nH7PlSbhClAt8lQHyMtAwixU/9vlMHNeoy8aljpkGzhoZqAEVANNDCzORapjuMP028FeO5BqfrttUBFiojy5mZ9BChXsA741A133sWQJmYvb1rLnbGChv8hLWz6mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTCE1wCE8ilD8ptwSSOzEotnlVsHuE+KD0vzgginR0A=;
 b=gnQYAM/pvS6FByp+zsnZVJWfmQwLx6sWNUqVEnkHNdSvQnhXI6gxw5mGCmrpvd1BDtlOCgIiZ/vAvWIG4QI6znvVNEsSI6dGa4aYQTkgzDq3uAJMcr9BrdpqDEBl0yD0eFoR9hETbV/beHadGrcV9feLLumktXlyGg64DhwXx68=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2619.namprd12.prod.outlook.com (2603:10b6:5:45::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.21; Fri, 23 Apr 2021 15:52:48 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4065.023; Fri, 23 Apr
 2021 15:52:48 +0000
Subject: Re: [PATCH v3] crypto: ccp: Annotate SEV Firmware file names
To:     Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
References: <20210423150052.25080-1-joro@8bytes.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f446ae4d-8356-0e3e-5058-f6522569c38f@amd.com>
Date:   Fri, 23 Apr 2021 10:52:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210423150052.25080-1-joro@8bytes.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:806:24::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0098.namprd13.prod.outlook.com (2603:10b6:806:24::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.15 via Frontend Transport; Fri, 23 Apr 2021 15:52:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bb1b324-bb23-4b98-df6f-08d9066fd7e2
X-MS-TrafficTypeDiagnostic: DM6PR12MB2619:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB26191710B9480B8430BF640EEC459@DM6PR12MB2619.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtqYyK26J3fIM4zkbmguijcLdwIMnXn/34qssKy6DBFDw8AEjfryD4WG49zuB+6Ik6z6eYINTKAazyxFm9QkWV2AaEQkckpT9pHrNkCJevfAJpGCK+5Stue7IR+YZMSut1aiRCA/DI1dC8+QYAEZL9mQnzonCXQGneOqnSs+/a5knyZ6hzFE23XcDyQqp+mzmawcUNOIo21AqP4EayRwesF35fN0sTRp7wrApAqydywhExU2sS/0Lkn0jebev0qmrC6lK2aIVNLlrkU1eAeyXjxGVVntkAWEWmLyV2ute3Xwqhjao4MUfEuOdEqRqvYhNx1XSrf+UfAWhb+bYPxS7oq8FwIADxX+VJpXj7F6QF3M6Gg11LW7ceeJbFMsizTz62K7rNdouYn0Fve+ve0LQkIULHP4qrEPEIMz8JxNQlZUGFnuTPw0wcZs9+jTUOcH6WSVAOSc0pAFlGpNvQYKTkSIDkiiXuI+CS85hfhNBfU1gRG66KTNbfa1YDHrP5kBLUqUCrstPKW5B8VqdW6j2+Nh3WHIniEsQFMkVQclihyROKqJTKFvYrVCwmRPOv7PQ8XGFktc139GvpawiMm9Rlcim4GQcYFaT8zJFGSLHS0x16zTj899SGIfwq8FrZ5izgaMPMWFsb5tCArPexaJiQuOKhRGwVCD/cslEdK30uNuxl7Njkj4R6qPNYXDX+dE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(2616005)(478600001)(6486002)(16526019)(956004)(31696002)(53546011)(4326008)(86362001)(6512007)(6506007)(8676002)(8936002)(186003)(6636002)(38100700002)(66556008)(66476007)(31686004)(66946007)(316002)(110136005)(54906003)(36756003)(2906002)(5660300002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZXlCSHhXek5qV29sVHlsV1B1eGkrd0w1UlFKYnBocmdRUEpsS3BmTmkwL2pX?=
 =?utf-8?B?bVRacURCSU9ldDNOOEVnZ3gySFc3L2FwNmhSM20rMWxNalRpMS9ZSGhhTlMy?=
 =?utf-8?B?cTNyUmdkQWZEeFRnNkg4cXRuQm9lTXF4UzNySFdJM2dRek9zMEQ4V25sQ3VZ?=
 =?utf-8?B?em10U1dhZk5CMmVKM2pjVkVDc2dNekluSC9tUm93WDRhaFQ5L2paU0hUS1dT?=
 =?utf-8?B?aVYyMnJES1FpdzFiaXYvS012emNzTXRXc2NXc2JpUS85Z2RXbEFabXNKTlpK?=
 =?utf-8?B?VWRQcnBxNTEzbHpoaWR1di85Y3E4Z2p3VjRocG95ckJEOEYyellnd1pyOHlO?=
 =?utf-8?B?bzdhUnRyWWNoWnFnYUFGUWZzbVQvTVplYys4TFp2K3E2NlVxYjRRS3FOdm4z?=
 =?utf-8?B?MGp0L2VkUVVQd3BvMXJ5N1JLaFg1dUV5R2t1ZysrVUhvby9QZjlBTWJDalFS?=
 =?utf-8?B?dTU5TzJMK0JaMUpEdS8xWmxKS3dTMUJ2NS9NMHZZdVA4czZtR3BWVzhFSUVq?=
 =?utf-8?B?RUk1RWZETk1UV0NNTFhVeGtyMmNkd0tEcDMyOUlPVTNxM2xYaDdsdWZHaDcz?=
 =?utf-8?B?V1BMekIzb3drMVlXYitYNUtuK0pOaDEvR1NaUmxsVDhGWTVkeDFnWXlKMytu?=
 =?utf-8?B?YWRBUlErMkhxMFFKdmNnUTQvQkxoZXhGeG9SQ3dPM0U2VS9FQlMvSWV0WWZT?=
 =?utf-8?B?UUFEdjhDWCtEQ3lUcEo5Z0hIVG9MVktnU3RRQkpWbkVGcVNLa1dqQzd0Q2RP?=
 =?utf-8?B?cDhWeVQvMlo3YmFGYmpURXUyZDl1b0Z1UVFIN0ZpL3pRZkNVRG96SGQ1SWoz?=
 =?utf-8?B?YU45Y3kySUJlbnVnWmxVR3kwSmtQTXF2RXdJYmdJeWs3dmxub1ZEb1U3aXFF?=
 =?utf-8?B?VjlQYTU3MHVqQUkwcklBQnVUYnhHOFozd2hIUFBDRElkY1NVNERNRHA5VWRE?=
 =?utf-8?B?WHV3d2NHRU80VzV4YVNXK0JVWUFvakJ0T28zWkQxb1RJSE1GUGRQVkU3NDc2?=
 =?utf-8?B?aTBUdlNldnp5RTROVzhiWWFEQlFzb1F6a1RiK3lMdllBNllTc1NKY1pCMFZt?=
 =?utf-8?B?UWJmbUVCcUFXa0t5T2R3bm1oMStyNG5YTi82bEp2azA3MitUZzZpcUNueHl5?=
 =?utf-8?B?b3lzREc1ZEh2a2paWGpOZGNKSDI0VDVpZnQ5VHlBZldTSDVSWkhpbnFFQkJt?=
 =?utf-8?B?R1A3MEdDMGRZQ00wUWZQRkZlNEJxcGlxbmY1YWVhKzU2Y0xLalJmb1BUR3Zh?=
 =?utf-8?B?RU9sNnZwUVQ4RllXWFJoeHBHb3Nmclora1pGSm5DM1dzMExZSEdWVy9pMmdn?=
 =?utf-8?B?YjRqbmQxUVNLMzFmSEZSd01KV21WalFxd0xkMUltR29TZ0czWXpDMmpXdzZi?=
 =?utf-8?B?RUppSHJ3Q3JWcG9ENit6dHh3Z3AyVWNPRDB3MFdWZkl2b2xmb1ozRnVNYjJ3?=
 =?utf-8?B?LzFobVZMb0Z0a2Q3NkxyTnUvWXZXaE1qU0tWRGFhZUJyZ3NQTmw3WER3NEtC?=
 =?utf-8?B?bDlkYWJaSjBGNGM0ZituVjQ5WDdpTGp0bjNUOG5OelI2MHlUVk9CdC9Yc2Fr?=
 =?utf-8?B?djY5aVdDbzNaL3VkVUFIMzhxNVdiVU03YjlZWWwzYkd0UTZWa2ZQK0xSVUNO?=
 =?utf-8?B?L1d6M3FEbURYQm5ENDIwT0VpV3hOWEV0ZXg3QU9iT1MyNHpHY3d6Y3VUSzhW?=
 =?utf-8?B?akxDa0pEVFBjWVA4enBCVFJEVGwzUlFzUVFzdnBqTjV5Y0hrRncxK1QyRWtJ?=
 =?utf-8?Q?a1J95V4eiO2DF8owYWX1yeRtU+7tXzPEnnBE7ye?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb1b324-bb23-4b98-df6f-08d9066fd7e2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:52:48.4291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qdAO62l8a1z4mT3tviM6U8GZAlk+aK3dmETkUrWQey6a8sBX0rQXPSG2/kyR/AgtCUxu0DH7FSoo3LWPDBMV1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2619
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/23/21 10:00 AM, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Annotate the firmware files CCP might need using MODULE_FIRMWARE().
> This will get them included into an initrd when CCP is also included
> there. Otherwise the CCP module will not find its firmware when loaded
> before the root-fs is mounted.
> This can cause problems when the pre-loaded SEV firmware is too old to
> support current SEV and SEV-ES virtualization features.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Do we want a Fixes: tag?

Fixes: e93720606efd ("crypto: ccp - Allow SEV firmware to be chosen based on Family and Model")

No need to go back farther than when that firmware filename format was
introduced.

Otherwise,

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index cb9b4c4e371e..675ff925a59d 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -42,6 +42,10 @@ static int psp_probe_timeout = 5;
>  module_param(psp_probe_timeout, int, 0644);
>  MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
>  
> +MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
> +MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
> +MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
> +
>  static bool psp_dead;
>  static int psp_timeout;
>  
> 
