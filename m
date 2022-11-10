Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5048B6242CB
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 14:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiKJNEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 08:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiKJNEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 08:04:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECA11A388
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 05:04:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7pWKPpT8osd204sSDENg+eUe4bJk2EjyJsfDS/KFEVD018MECW8IvXzrluXOsJh+f7bNpQI3WpRmPq7Jh0p/8PyyfkyfD18d6tijA9IP5tmwmaH4ageIkqSwfBEvbFzoghFZKJPUzSB/4D/ZxFrGG5r/YwodAUjtFDkRaWbyTYoX8pn5Ge+DGTbhyJqon+Stc92XqKSL/812Rg0H7FCgCX66wnE2h/DQUsUDZh6TpGOblvWexSA39e3cmaFSg2hZuRmaEIWznYW2i6GyCT5dq5tW9NaRayQ9v/YTN+D1K8hJxnT9WYjwkf9wkZfBbzbnmW/VXIrt+UxSQvZdhyntA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ddNEXkogtQpJgQHw/vBBnn/ssIvfauWJsKfmxxDkruk=;
 b=H4p21C1i+M6dXtKLqOkM0X3S2nW9laan0aDOEhCTpTefhxeHPaKz1psNoPOheWwIagQjJbKGgM78dIiJccK840HYz6YCkJZRfkKr7MM449xJfEq8SQq+BH35gqvrIg96hhlzJjdYgy1Ryl6vr3QGuMRooTkmzRzAwg1qLYR8R8qwr3ZA8+vNusgJ5/80SIRhwWfpiFW6cyWq3qwBm8dfEZ1HClWeCOxDABVyO+woCU9Gf0qAEcQ2YyCd2ocHp3hic+5a8aC2SkyVNrwYGkL/KAfvKAn2ZSRTX3ctMGT1aA9Lb0EKwMmEVW33YXVeSJczb/pdTyTpwAbYdrXRTNNj0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddNEXkogtQpJgQHw/vBBnn/ssIvfauWJsKfmxxDkruk=;
 b=YsQNMNx5/OpfoDNryBR3RzDhA+aBYuqsPHtTqDoZS14RLu1P4RnYriF22chi9QwIh/0JfVtmTqG5gBeFNCcXHxImV+KHtokub4jF10WMKAbn0ww78yKUFr7K47B4kjhSuif33H3CVL/8kz5esxRnVy8dI6x1wUrUbx5Lvn5zvZI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 13:04:35 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421%7]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 13:04:35 +0000
Message-ID: <006f24cb-e1fc-824c-91b4-cb6c514e8e8a@amd.com>
Date:   Thu, 10 Nov 2022 14:04:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/4] drm/amdgpu: always register an MMU notifier for
 userptr
Content-Language: en-US
To:     stable <stable@vger.kernel.org>
References: <20221110130009.1835-1-christian.koenig@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20221110130009.1835-1-christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0159.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::19) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|DM6PR12MB4340:EE_
X-MS-Office365-Filtering-Correlation-Id: 32864826-5686-47db-685f-08dac31c1dc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGQv3zrqGQVndFODVfVXSOvO3xjZ7TMVjE1//uaMvRBDyKAjo2IOadg6RqU77XCrDs5UFtqtVV3430O8N1f2WjJk99fIcH7yM42Ij7hMcbCjX1pASqmZ/kpwSTrnG164f3LehJbR8yi538ndgqptpvYh4fREGF8pO1t4Pe/JyS5U/LZn2k+hGPEd7TV61Mu2ZStxsH125wLjF6l41a3JcXJJq5CM+6Wi8TSRK9YFUCoMa9k9Mg6W0evVmLkOiGMA0MzSyMhZdmKEdsNs+BzRmat1WONp0uhzbA94d8lTrA7WtIsj/2sYcxwZ21ND9oAFAbElifjadMRRWagzoY0qP+9Rhxud14dnD2SKMO2kQm/13PV6xjmiR/P8igC1CObcDxMnhQRQ0GIZ6RWOC3QNSWf7XhUXbSDDtwhd90HHD9hQzOAYwQyBgxI0JKcHbQ71EmnekIWWBCio1BP8Y+s/U0RpFxYaQM/PKkJbZKD+zQyLXqPgKkBk2AQQubrTrRgV7XK2wXqK32mn/ryUFxxq398KBPosmq/CW9nw9uufTKJoLd4HBMP9+hvso/LmU0n2Jle6W3tHTA5bpWBygUsuIDB08RUv5Gjz0uJkbZQIqQ/sQUSKCdyrd3ow/07KAAPtXXUdMxbbx54Vkh4nOC+SMoSMLdbITMLpMafMuQhSQIU9+sY43imipsXkb3WkNHwV5SwY8Jf9Lhk64iXU3dssyZSSuqstaBjEdK1j2g0ezqFi5phDTp7eJL9QRbygWPuuJl9p2L/qJQX4IXVi9Vjp/vdFp+1+7xzetJ7UdxuLWVQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199015)(31686004)(2906002)(6666004)(6506007)(38100700002)(31696002)(86362001)(5660300002)(66574015)(83380400001)(41300700001)(36756003)(186003)(316002)(66476007)(6916009)(66946007)(2616005)(26005)(6512007)(478600001)(8936002)(6486002)(66556008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S28xVENpSkwyR3NpM3ZCWXdraks1VHJGazE4elRIQWlhTktUTXZzdFBnZ0V2?=
 =?utf-8?B?K2hqZTRHbzhZVnIyOG9wK3FXSkxBb0VoWk5TemI5Q1RPeDJaTm9hc2dEWEtk?=
 =?utf-8?B?NE5zd056aWNXdVk4OTBKVXd3dkpPMVRSbkZBd3V3VEEwa21Lcjk5NXJ1RlpU?=
 =?utf-8?B?bURwVTZtMTF5SU1DNUUvQ0FhNzk0R2JoalpYbEhNVjlZVnd2Q3NkMkxSZEpa?=
 =?utf-8?B?UGRmNjNYTms5OVJUV0FKS0lXY2pzOU5oSXd4ajBtRjRWRlBYcThzbitLdG9w?=
 =?utf-8?B?OU1XSi9FbEQxNE4xeVlPM2t6dzFVWEZvRzF2d3ZNTEx2N2RLM1ErOFBRNTM4?=
 =?utf-8?B?RGlJUHlLK1JhdkdlNkxzaVJtMVJsV0JWRFBTOWVZVXhuWTJsdnB1U0RYTnJ2?=
 =?utf-8?B?dkhEcThxWjJDSzVkKzJUSzRWcUJWaEtWT3hoeDdqQ055Z3d0T1h1VVVkUHBa?=
 =?utf-8?B?VWNCT2NjODlaSHV1TXd2MWRPU1E3bVFPdHlJVVJhYm5TcTJRNnhSRVlWNDlH?=
 =?utf-8?B?dzNndGk4M1YvU2YxVkI2U1kvbzY3WjNSYnV1M2tsK3BGODlSalRNWGROUmNX?=
 =?utf-8?B?ZTg2eXZkSVdVbUNEU1o2ZWorZmRTNmhRalpSV2E3TmlvNVU5TkJhcUtnV2lN?=
 =?utf-8?B?eUVUbEtKWnBzUnZZSXlhMS9VVER4WWZib0hqM0FCT2NOelc5eUswNVh0UDNZ?=
 =?utf-8?B?aXp0UWhPS1dPaVBSOG9WdXhwbllyRjd2encrWWdhUWs2R0lVLzJFUDhoYU5n?=
 =?utf-8?B?ZTFVaFVPc0k4RE0rMEhHRWxwLzY1VHlvbHNCNzJ0OTE2NDhKVzZZMEQxajdq?=
 =?utf-8?B?RFQyZEtyVWpMNlhIbDFCcFExaEUwV1NJWGxtYm9oc3I0cGhodkV5NzlQTjlR?=
 =?utf-8?B?a0NGaWZtTlIwUmQrK1NBSnpkSWVkMmNITFErckJHNkVDb1RUK05mZldvRkF3?=
 =?utf-8?B?aGY0Q250blhuZnJON2JvbGx5b3RBR292a3RCMmYzbVNXNmhjYmRJU0ZGUGFs?=
 =?utf-8?B?WTdNTmtRVGY0dXZINFhsdVAvOFRvSzFXUGNuSGNuYUpTM0RkRGk3VFZvY2dF?=
 =?utf-8?B?azRXSG1vOWJwWlNwS0p1ZjRQOHRiU1Z3Y2JhSjBoRHliNUtiSG55NnJTZVBa?=
 =?utf-8?B?OXkyekpoemJHM1NaK2pPaGdvVldFdlFydzVBenBNMlR0MmRNQkRuS1pkSCtD?=
 =?utf-8?B?T3dQVUhsSGVYRXo4ZzQzL25rV2ZWWDV5WWtveXhJeWNxV3BnanBNMUo1aWdw?=
 =?utf-8?B?bnNIZG55UjJJZklMY3Zad0NHZDBmd0ZTcDhKL1JmblUxOEhFVGtIazc1alR5?=
 =?utf-8?B?MmVkRzdaZkpjS1JkaldLNmc4U09wa0RjT011R3JWZSszWGhUSjhZMXN3WUtl?=
 =?utf-8?B?dENHb2gweFhQTWJHVHI3ek1UcE5Bd1BYZHc5emo5ODVSdktnV2ZtUUI3TE1U?=
 =?utf-8?B?ZE42RlZwV2xPS2RGSWl6V0lrTVdOZm85UlRIMmN3VVZPQkpsUWJOb1hudEZF?=
 =?utf-8?B?V0QrVzBTUStzN0hoZ1lJOW00bC92ZUhwWEZrVU90R0dOZ0tWMUZoTUJtTU1P?=
 =?utf-8?B?SVdOZ3VOdHlFU2RKemJIUXNIYStUa096NlVoRm1RSElFOStVK1Bpa01MM3NP?=
 =?utf-8?B?Ni9BVGwxYWhtV3FwUzVBZDZKcXBJTm1kSGJVelJ5R3dwNGpiSUhsZ0ZUS2d4?=
 =?utf-8?B?dXVmaHV2SzZ4MDJBZCtNQ2oxQzJDWlFLbmxuM2tWVTBDTnJ4c1hkMTUwZW9j?=
 =?utf-8?B?alRydGNGR080ZklJQldtYi9VSytDVHBpTUYwTWFxWG1WVlNGVWphVDU4bS8v?=
 =?utf-8?B?M2JZcXZMSDdVZnRZZnZkc2tHYW9ZaVY1dENwRnNuWlJFak80LzRvNHRvM3dr?=
 =?utf-8?B?cm85SzVQdTViSzhJbkhoV2ZjcFlXYVFOSGNBTGJDWS8xMHptWEVNZlMrclhz?=
 =?utf-8?B?bWZldXltR3NGTW1SYmthMFNQVUNOWFVYUzc2dXBxQnpPSzlOOFJKdEpoRENo?=
 =?utf-8?B?aFpYWXVDUFFVSEE3K1loRzJsZlNMb2FZUU5hMXk4Ny9WelBRT2RjVHNaR0tk?=
 =?utf-8?B?TVY3K3l0dzRWK24wdWVhb243dUxtQzJ3L3hKNFFEZklGc2lZaVBFajgvWjRt?=
 =?utf-8?Q?KQdUgqa/8Re9/4LYZF4ma+qPD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32864826-5686-47db-685f-08dac31c1dc7
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 13:04:35.4954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fZwjWVXHKE0g2LGcEs9HWlEalQk8LZ0yhJuQ6p1qoueazlmnFntil09xN0WwG/p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable maintainers,

please ignore this serious, it was just send to stable@vger.kernel.org 
because of a mis-configured git send-email.

Sorry for the noise,
Christian.

Am 10.11.22 um 14:00 schrieb Christian König:
> Since switching to HMM we always need that because we no longer grab
> references to the pages.
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> CC: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> index 8ef31d687ef3..111484ceb47d 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> @@ -413,11 +413,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
>   	if (r)
>   		goto release_object;
>   
> -	if (args->flags & AMDGPU_GEM_USERPTR_REGISTER) {
> -		r = amdgpu_mn_register(bo, args->addr);
> -		if (r)
> -			goto release_object;
> -	}
> +	r = amdgpu_mn_register(bo, args->addr);
> +	if (r)
> +		goto release_object;
>   
>   	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
>   		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);

