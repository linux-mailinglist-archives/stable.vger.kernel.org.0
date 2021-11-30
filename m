Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E15C462F2C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhK3JFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:05:42 -0500
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:12609
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235424AbhK3JFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 04:05:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXdxwC/31iMDB5CUBeiGK4e9ZgUZNbjA3OGbvH3jEQ7Wiie7/+17s858s8uvVqONY4N/3wmJpp9/q7WgUWFyJr/OJhOjiHyUC1Ss8y3EsjRcHhTPfiiSDej+hY9Dz064Y3Ii9ZqRrcaH7WEEsRLOHHCUmRtkFKB++5hOgxEARhloW767Mp75Sfsbx66RrgKdzuP3ts28mqgIuD5HCnvjEKk/cXd3K8dDQtJy1fSZs+oT+e8pyFCQtNV1V9lwbuAzQdMvXyK1sX+Qk3DKxtflxAw8+D4HkhoM9oaUlbC10eG7xRcz1LPfBahfhPHGM0Nhe0qaG4cT9gFLzFXo9/nQDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vwaj+bYmBWqVIaQ93Fc6cUTH7zXvo0yE835XTA6TpF8=;
 b=gdXsTbCZcURD2VaLX33si33Vdu18V8Gx9zSXmWubwS32UE6EVlzlejGGsw8iSRHQOtSZDaOgHIhQsAVLtR/KMH4hCXmSkwbgzvD4/mbr9g4az0SqxgoXFR7bjekqVcf1l6xOiX57Fmi1MpJc/4wdymlfBeLmcIRvjBanxBYOmIWIXS+cm71fl7BanbWbLOuq94ac6rRQdihRgqhjAdDsryt9Qh8pofdYBfnJlz3cbPJFHObD0UzlgSNpyiREMd3miqMJfhHvEofzgBvvuWs3kPMvogAyJio7uEKSHDOz8M+YW9n4l6pjXODmdGnyvqzubI7ZrLCFcG83OrWezQWY+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vwaj+bYmBWqVIaQ93Fc6cUTH7zXvo0yE835XTA6TpF8=;
 b=Qtd1vU4ugSft5Eiaj1Ofjb9+5vdSah2LgbVFtkIeOPkwFn3ErMOoPq2SrxcbyLXE86dvSwFbg3f8hx3kZeTEPvA9JOU1MePhvVXD7WpR/2dtgEgkCu8VcHTZkF/IuyVi0P18MrUdByVAvejJaWO6ei73ZhBQXTgZ4+PIEBboHXcxu3g6/hRGkaY1nHstDqJueh88vrLt0ilpkXa/zYd4b9PZzSwpnHjir2mUPH2NiB3es6WsyrX1iPv73ZUe63DN4AOdYUVhesA15ttzZf6yEu8KyNq3lwSMY1MZcwGcwEwJSzA86G7LidSqXATlLtjvhsUSitSL6i+Z1ibJiIByyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Tue, 30 Nov 2021 09:02:21 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%4]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 09:02:21 +0000
Subject: Re: [PATCH 5.15 000/179] 5.15.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211129181718.913038547@linuxfoundation.org>
 <3210f340-f3a0-2cf1-8b3b-59db6e58e65e@nvidia.com>
 <YaXm25djaWxAerRm@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <605f51dd-670d-f560-5fa5-eaa7c891e5c5@nvidia.com>
Date:   Tue, 30 Nov 2021 09:02:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YaXm25djaWxAerRm@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0108.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::49) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by AM0PR01CA0108.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 09:02:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa05d1ab-d714-4496-08a5-08d9b3e01e4e
X-MS-TrafficTypeDiagnostic: CO6PR12MB5427:
X-Microsoft-Antispam-PRVS: <CO6PR12MB54273F16A2F7288185DC79AFD9679@CO6PR12MB5427.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRgPz0WLKy1tmPCYkiSVNBnCDR8tAqTUDXvupBb/PkR1gCTo01UEv+dU80jbbizKjtTcQJajK2UuFKCPY3TNR2Aqob4NvjMxMDxQxYSbuhDyQgBeqzN4u6p8FxaSXWI0LpNdVSiNvLKs94Z40SsEyLh5rCbzOY95Xzp9VBs2bxvAWBJpw0GKPHua/hDs09mSDNG3gEO/n+UJ/GRl5T++F3VfRuU/+O6EuCzsFX1CVHWXGVZVGkFUJqny4+VkiXq03/el53bHD71nQWVJHsb6la1P+ICh8splngwmLJ1GL6mtufNcMqD9Y00YCusaaiMUuR3kO5dZZRhc/LdjweQFJ5xSUJp8wDvZc6Otol5P9vSHpVYTYf7LYvfN47R+CJFIY7nmuTUg39yQMoxKUMsodKmOPjBqtbq3F7vrJ78B6674FgbwwKXiEAGQG08IXj6TABLFHNajYUKOhIr5WGo4+XiChWN020CR8xduarjvnsAdF9iewzkEK7XQu6m621YQXRBb//ucqTg9rLM0IRzeF0bJCaioSf4xQ4J+o1XGc5fYlVN231INgPjc8aqamQoYheVo0cysKY3jXXDRnc/suHmtC9Me8vp3m3PucmagnPkrQsCtmjzvP9uJES92FItByLBuxl6i5NO5P8nn6bMiESo32Ys9VEtG/ZgDjYSGzY6G+GhM2rfQA+XJvUMCsf/IvGLexrTlgdneQHsJeNQ21B6Y3u6J3gDf4NQ/2EpWhMPVlI+qEcT10LqWKRyyGoGA9+8ASJyXQcGLAEHjOEQ17Lim/5WFrs/qJSAd5RJaSmU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(16576012)(31696002)(55236004)(53546011)(7416002)(4326008)(86362001)(6666004)(36756003)(316002)(6916009)(66476007)(66946007)(6486002)(66556008)(2616005)(5660300002)(8676002)(83380400001)(956004)(508600001)(966005)(26005)(38100700002)(8936002)(2906002)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2RIUnZyTkhGSTNvMEdUQldPakw0Qis0NmxaRk1IMVpXa2Q2WXA1Nzh2eVdP?=
 =?utf-8?B?UXV5eElRMklKdWpvQWpRRW1PcEp6MVpraC9FQXJ2Z1RRbFdrYlZSY1JZbWFQ?=
 =?utf-8?B?Q1VVTjNDWlJ5cU1wSThRZHpNS2lrWng4bHNhS1drVW45SVdFSUttZ2wwOTJ6?=
 =?utf-8?B?c21BRHpmYkZUM3BUdGZyWHVXMndMTzFvOG5ESjhZaWtPNjBQK2NFbXVCRHgy?=
 =?utf-8?B?b09DNWpGSlgxejd5TTc4R1dqcUQxRTFtVDlIdVdaSkZlNUc0NEp5dWtPWlJK?=
 =?utf-8?B?MzFSV1ZwYmpHUllKMmZ4VloxQmZIMjgxMUtVVjVia2l1TjdmMlJVeTNLY053?=
 =?utf-8?B?RlRoVHRlWGtRa1BGeHBSeVBLMHMwUDYvYlVOR0FRNjF3dkIzQlo2WUI3UnBz?=
 =?utf-8?B?MlREcVJ4TFJibW5Rem9jT1JCRXo1R1dHZEtHTzN3OFVuckVqcEM0NlN2OHpx?=
 =?utf-8?B?d21yb3EwODMxbTRLd1JtQ1FTMGx2WGQyV2RGdlJvWUxtWWovUk1jeXhicXpn?=
 =?utf-8?B?QXVGc2k1SGxnVDY4NXl4cHorNmRMR0drTXlsb1RlQU95eWpKend4Y0FRL3px?=
 =?utf-8?B?ZllMV0hCaHYzQ0ZWZS9rNkRUalpuaW5iV2xSMjNQSllOdlZoT3pIOU9nV1VJ?=
 =?utf-8?B?cTRhbGxydTdtTWZaZWJSa0xNcU4zWTd5Zi9UV1prQzhoWUU3UUlYTlYxNHRl?=
 =?utf-8?B?WGMyZ1MwR1N3YnFFcEk0anNqRi9YUGx6OXhLWjdKR3lLRGNPNitlaUY0aEZm?=
 =?utf-8?B?U3RtRzMzUDg1Q0JFQXdGOGs4VzhNZUpDbXhTa1lqa2l0bWZNSGN0MlVpVVJZ?=
 =?utf-8?B?eUN1RlBJazl2bTM5UWxVTFVxSTRndE9PUElZbytvVWx5RU1qc2RhREtRV3dT?=
 =?utf-8?B?UWc0NkFQVis1Z1hqZ1lYaUJQeUJOZW9NQmdIWWRrYm9SVzVwNHkzUWVUR2JH?=
 =?utf-8?B?aG9GNURBemYzc01QZ1MvdVhMZGNmNm1EZUVwMmE2MmIraVA0WmM4dU42Y2Zt?=
 =?utf-8?B?YS9abnBzR2oydUhxa2w3VnN4ZDJUVmlRNmFlZ2VFVTRzaDFTZVg0SGdtUU4v?=
 =?utf-8?B?eitaZmZMbTY5dS8xUmF6Kzc2ZFFIaCt6ODY0Y0JZR2g2MUR6M2NWTjJ3Y3B0?=
 =?utf-8?B?MEZvZnV1bVNDL2IyOTNERGFUN1Q3TW1KQ0ZsSEVyWmtvaStPMDJTTjliTDk4?=
 =?utf-8?B?NHdMSG9scStBZjhrYjBodUF1Z0Zqc083bWdOdEVQTWNaU3ZVcWJ2bkMySjlp?=
 =?utf-8?B?N2d4ZytJeFk0dUZvL0EvWXI2bjhmV2J2cWxuSW5Pb0xRVVJjSGpwZUZURGdR?=
 =?utf-8?B?VEdXVkJnclUzZVg5Nmk1MldkY2tWUmxBNkVVU0pDeExDeDhyRXl3am1CTTdu?=
 =?utf-8?B?eEVVZndOWHBFa00yeU9Pdld2V0lSa21BcFdPU2NmWWVBRS9nMzVWd2NCWUNn?=
 =?utf-8?B?RFhvSzRqSVdDK0ZkazlZV253NjBvdFJIZlRZakViaGNUOE5HYVRKSXp2bHFr?=
 =?utf-8?B?SzM3dk5EcVM1Z0lBT1JidkQrZ3k2RDJVTlhPdzFJbU9haDlXR1NidjZJN0pM?=
 =?utf-8?B?b1lPanRTcndEY2I1UUJlVlA4ZXNVeW0xb1NUVHMwcWVXTUpuMm1RR0RMY2Mz?=
 =?utf-8?B?TmRvc25GT0luRVBvamIrTXlNcVp5Q0hCUlNMOVJKZkI1bVJKVkx4ZjJUYWVq?=
 =?utf-8?B?cHpyaUFpRE1YeDZsRXpqeDJ2aldJMm1jcHFqMHQxTEFRSGN3TktRSjYrd3hz?=
 =?utf-8?B?eFZBM3JZdis2TnRKTGU2Qm0ydEpLTWV4dDFQY2R0dkh0T0E2ZlZwMUJCVnc2?=
 =?utf-8?B?bzJPeEd1TUFPT2FMaGZYdXpLSll6K2crbkcrY0IyTVVSeldDMzRMejdid0Nj?=
 =?utf-8?B?WG05alNpVDNJMS9BNHZKejV2NVRBaDFKSExTN2gxSXFyV0FrdW9CanJZQ3dI?=
 =?utf-8?B?TTRwNk1UWldWUTlmTmt0Um5hL3RoWVR0VFRXN0ZoUlA5TWZRRThUOURJWnNL?=
 =?utf-8?B?TzhHd2tiNUdoL1VaeWp2K3J1bU85cE9YTndGYVFwMWlybG5NcHhXbTYvSTVZ?=
 =?utf-8?B?L2Y4N04xRTNtbk1EQkNUMURHRkg2b0xsTTc5ZEZaNXBNZEVWZ2s5ZW4wSUJz?=
 =?utf-8?B?Yy91UHR4RVBXcTAxTHBSOFBxVTk0YkQwbWRYWW90R1FyclhFUVMxVXZJRHdE?=
 =?utf-8?Q?fV0eAzolqyC2/P9KiHOFRhc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa05d1ab-d714-4496-08a5-08d9b3e01e4e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 09:02:21.3645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZPkNe3MGLM2N01PxA8Tm+v8uAFEiP2MxvntFzcjjQLcVY2T41rzCzR3A/0nbej+eMtGDKh7kQ59imyoZtoY4VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5427
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/11/2021 08:54, Greg Kroah-Hartman wrote:
> On Tue, Nov 30, 2021 at 08:48:00AM +0000, Jon Hunter wrote:
>>
>> On 29/11/2021 18:16, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.6 release.
>>> There are 179 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.6-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> No new regressions.
>>
>> Test results for stable-v5.15:
>>      10 builds:	10 pass, 0 fail
>>      28 boots:	28 pass, 0 fail
>>      114 tests:	108 pass, 6 fail
>>
>> Linux version:	5.15.6-rc1-ga6dab1fb6f7d
>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>                  tegra20-ventana, tegra210-p2371-2180,
>>                  tegra210-p3450-0000, tegra30-cardhu-a04
>>
>> Test failures:	tegra194-p2972-0000: boot.py
>>                  tegra194-p2972-0000: tegra-audio-boot-sanity.sh
>>                  tegra194-p2972-0000: tegra-audio-hda-playback.sh
>>                  tegra194-p3509-0000+p3668-0000: devices
>>                  tegra194-p3509-0000+p3668-0000: tegra-audio-boot-sanity.sh
>>                  tegra194-p3509-0000+p3668-0000: tegra-audio-hda-playback.sh
> 
> Any word on fixes for these failures?


They are in -next and just waiting for them to hit the mainline. There 
are 3 fixes in total. The following is now in the mainline, however, I 
have been waiting for the equivalent MTD fix to hit main, because the 
above boot.py failure will still occur until both are merged.

commit 5f719948b5d43eb39356e94e8d0b462568915381
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Mon Nov 15 11:38:13 2021 +0000

     mmc: spi: Add device-tree SPI IDs

Jon

-- 
nvpublic
