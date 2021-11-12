Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D2D44EACE
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 16:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhKLPtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 10:49:40 -0500
Received: from mail-dm6nam11on2040.outbound.protection.outlook.com ([40.107.223.40]:12704
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234508AbhKLPth (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 10:49:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQGRpnstL9QICZBG/W9zC+6mCrJ/t9/p4I/z3UuejKhSHUzTNCN2MA1y14bifPzq1reDTavYJNlqVlITrW28EOJ7t2Oajv9wX0MnLIbuRJ/bp0VeOz0c1bz3W7Zujn1cDt1x3fI+ZAMW4ExyJmURC/TBZ7YwnODzMa3KsYKK83RZFW0Y+vu2POghB/IfLSoF3i776BpGZ6Hp4m8zS5Hbtul25rEy4Tx92U9PbuC7il6k145nHmB/Gaz9PNk7COuXNmW6GKgZ25fij1H/VFXwbzRdVMSHo7rWp/8UPNrml0B/Wco/gf2Q7uy//+XvVHsKoNSxtCuTHFOiI4RmxqaoTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tO8OSKHsi4KJzgfdWQ3EruNLFfbl50VEiM0JRnwm4Eo=;
 b=FsjV1ibYPbyjM4Tgwf5X+sJlGr4e2bENiIrbLohaLCbogW6udI2IaZgirVBLA0qUUbk61GlXW5MoW52tkCzlgtOjIo3QGJyLdqPV9pz0gYPCRpXLo0sviDORWNKdYVQyyvFGvIdYDa28Y70J9c36sDJpeb6qMKLpuNLPnRLwbN3YkLgBFuNvMJFZElgER4gedEhfn0eQyjpuKXXNv2KmtNNdxkD7HFSSYKIiWjpqRjt3shMHnQpWOfms8ymgyUWJnykBo67Xfim6wyAsWdzIfaDaEdCJh25KBVH9yxs5VNon8scJWfGLZYbBYHPmIWdA1X9xE/VXBnDNYpyPymAdVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tO8OSKHsi4KJzgfdWQ3EruNLFfbl50VEiM0JRnwm4Eo=;
 b=ZnFXC75XCsniGtcsv7IcPJO7DUuEg85NdDzfgB259w0bAyrHp8Np2ZdpQuk48VuFdp9bNWdOqzUv243XKBUVzLB7ZBIlVS0+JpKkN1ZaTOz5h+fHq6c8P/zeix3lFJ37YJLgmkLWc0FPFP9vMKNP/RqYHyUcfGGzQeOv/Te0V+9wdbhfpzgSjZbmdNShvMFnbDk6o28Gksgy9CHmOl9uE2E9FQtJdWAb42KeLa734HmP55GNv9j06zvsOf028Jx24bYXpH3f4m9QQwCO4hvxnnODrpPx+A/utzBN5OWqmlIYAT/AAxl6LEOhAdUkbkmWQNV74QTIgEQVvwl8VD7p5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB5566.namprd12.prod.outlook.com (2603:10b6:5:20d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.16; Fri, 12 Nov 2021 15:46:46 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86%9]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 15:46:45 +0000
Subject: Re: [PATCH 5.15 00/26] 5.15.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org
References: <20211110182003.700594531@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <d4e67469-4be7-ef8e-8e57-e0f599d0dd2d@nvidia.com>
Date:   Fri, 12 Nov 2021 15:46:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0302CA0006.eurprd03.prod.outlook.com
 (2603:10a6:205:2::19) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by AM4PR0302CA0006.eurprd03.prod.outlook.com (2603:10a6:205:2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17 via Frontend Transport; Fri, 12 Nov 2021 15:46:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef7e7cda-81af-44d8-31ef-08d9a5f3a17f
X-MS-TrafficTypeDiagnostic: DM6PR12MB5566:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5566E86884FEBB08026A742CD9959@DM6PR12MB5566.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fy5NJsZjMpouvwtuk4tgTkrd8DimaWmiSUPZYkkuHa7XZGKw2p70T6nmUQ6U80PWOS3Su7+cdASZ6frQZO4GlMQCcEyl/5VowVWEhnHtPTNDn0K3WHjt44QNl8WNr0v34SxpGbeD4TLaNcqYYHHA+tk0Vy1dDwDrQeUGa7uHfahxFize3rBrbVOa7iFFaTtr8KPM3nt4fAZ3csonsMMIc2FT83vi9akHlcvre8gVvuteJuwD3friMBHoUowUJ4z2Vl8nxflXx71zPTSfRS2Gluj2R9OZpMmG9BPfajphI+Ei9sm+ttbl52uP3mGxYsfkEVzg0bYMT3cGnkUAHzRKC27mGaNljoHsn30vBiR0wAVGmvrdqGeJBRLfiB3KTkZ8jC8tPeKlNybSFmbyCnCxkPO5eTQl7JPT3ZrWoepeZLXIj8f30pOlcEmM0paOWnq2jERY0K+Wk8UO4LtPwFtIT4sYQpX8+Y0VGTYX2RmwlO4ig52xS5HVD+ue9RQ0xLEvSM7hWyDJOV8YDWdC1SHZBAobavRXWeFUs58Ir7qHWv+enrGeGcanzMhUFlzx+X7x6b7f5bbC+Rswk/coLD1POvPxKhj2MJ0fow1ff4soZfTGx4ccyQR7x750Ppcxa2FQB0n1Gw8hCagV6EvQIB9gnCiOKtX0su7zck1LppdHv3yMZSIWQyMvRLLNrW4QCNtNVzV3/aDPqgpRK+lOKr6jXG37bogrYLZMm5AxbvoiAGGtW+qknfgmH1QqpYKqP1sSZ2+u6+t2pP8sGuWQunEppLEdMnKh3vZ55B0Pl2ZjOwA/624Og6mmELk9bTgamIOJtcZeUmmN6cUK0YGpYOiUAY2V1a3iUOkNJrbNT9KsGIs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(316002)(36756003)(2906002)(53546011)(6666004)(16576012)(66946007)(83380400001)(2616005)(66476007)(66556008)(7416002)(8676002)(508600001)(6486002)(5660300002)(8936002)(956004)(4326008)(26005)(55236004)(31696002)(966005)(86362001)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zmp6alBONGtkaDUrTXZNd1piTjFGTmtvOGFsOUphQnREbXl6OExYUHI5R3Rs?=
 =?utf-8?B?T3dURDdUaVVKeDA3THk0SlZ4OEtJYXAxTDRVcko0TDBVcXYzTnBxSkZoSVFU?=
 =?utf-8?B?T2hyVDMydXljZFpqekM1SDBURVZremNLUW1mQklOK1hzcFFPNGU2cjNmVFJE?=
 =?utf-8?B?SXhCcHNBV1Nnd2RBRlhOWFZlRTkwd3B2Mnd5SHJSWWQwYmcwck85YVRSOHRB?=
 =?utf-8?B?KzJKSlorUEc3YzBGamJwRUxWQ1FCQXRocXliR1VpSVk2NVVZOXRpVkdZVEtj?=
 =?utf-8?B?c0ZFTThCSWVNSGEycnhqc2hySFdSdExpTkFzTFdiZXNPMkR1bWRiUjhZblNZ?=
 =?utf-8?B?ZWVuMWZFa1A1ZXNHSVlhY1hmWXpxL0VIbGNmM0dPT2o3V1ZjckI3Y0hvSXRQ?=
 =?utf-8?B?WUdWUWZxaENVcjJ4cEV0QkUwdWxySG9ZYlFMM01UY1pMY0tkaVJDdzkwb25X?=
 =?utf-8?B?M3ZwdkN2WTFFSW9nYTFBbzZ0LzdpTGkwL3hwcUdLdEx2Tk4vTHFzUGErK3pq?=
 =?utf-8?B?OVh0Z3owUHd4RGl4R0dwVzdLZm5rN2tVR0hvRTUwcEVnTE10WFNqakpOdnpF?=
 =?utf-8?B?SzFLMi9WN2Jlc0NzNXd1WjNlNW5rZ1RQQ05uZFp1WktPdTdaZzRqSHY2TzNt?=
 =?utf-8?B?U1BmbTBZYXg2TjJObkdFc0JFVHA1VlhNb0FRNHpkaUZNM1VjY21xK2F0UUJK?=
 =?utf-8?B?NnlqOFh6UzB6aUU3bkRqd2VhejQzTC9FbFJkM3RNQngwOTZ5VXJLTzVXNXZS?=
 =?utf-8?B?My90SHlQVlc4ZE84aFJBS3crbWhUQlh1U0JYc3pxbldvemFRUExhSlY5OHQw?=
 =?utf-8?B?SGphRHRoa2h2Y2Vwc2srK0NQb3laaTQvTTdOWXZhbkRCVDJoWkRXL2lCZ2pK?=
 =?utf-8?B?dWNreVVsV2hTTjNlS0Q2UWpXQmdDZHdwNWpaRTlPTWhxb2lFR2J5N2E4WlJI?=
 =?utf-8?B?a1RtbEg2bG1rd3dsTGdoa1p6bnNFR2lZbjg1S3g0RzZsTEwyY2s0YW1qbGNU?=
 =?utf-8?B?dis2Ylc4T0pRVjY2VEoyRmtIZlc3QXc3ajEyMmxQOG50bkF4eDV5SnY5dHpr?=
 =?utf-8?B?M0k3WmVHMFZ3YVFJYVVsVzlRR1VubjVjZ3VQVUROZ05iL2RobU5YYUtMUkt1?=
 =?utf-8?B?d2VYbVZ5c0MvUUl3NVVpYjZPa1lFWDN0bmUvK09jQ2g4UUl0MmhIT1BuR3Ba?=
 =?utf-8?B?YjhqSVJacC9BUGk3dTc2eGJwUXF6Rlh4UkJxYU9QeDBKN1dsY1U3bFpCVjVO?=
 =?utf-8?B?MkFsQ252bEExMkZkRjZ1NVAzYnduLzBIczR3SVpQVWl1eVBra2lRK1hCK1pB?=
 =?utf-8?B?UGw2YWthM25VaTIyVkwrOHhhV1FJWFA1YytKWTRpaUZQcVFDbnBKZTA4M0dG?=
 =?utf-8?B?a0xQckxFa0JjaVY5U1JYMUNDWWNrSVhPL3d3RlJHTU92U0JUWGR2TkZDWGty?=
 =?utf-8?B?MEpYbDl3VFJ0ay9DSmdON25adzZHSnJlbmNvZys2VCtSWlFWdGdVZ2tBVDB1?=
 =?utf-8?B?WWtJNGRtMVo4aE93SkFSMlNaZVRzY0VDSUlWeHpGTmQvay9JUm9yK3cxbzJr?=
 =?utf-8?B?RHRyM3RmVmJ1ODBMQnRQTjY5QVQ3ZjZYMWd3QnpCRXdLMEgvcTFCNXhVR3pw?=
 =?utf-8?B?TlkvYktSQ2lMM0hvV2ppTWVHb21uRU14aWgwVk9zME9XOXZVanRQSlpITDg5?=
 =?utf-8?B?cmdpcENzdWkvTWpmWjBXSTl5ZnQ4eWF0N29CUkNhcHovbFpxK0Rsc1NZb2pH?=
 =?utf-8?B?Mjc2aXR6ZzE1cmRZUHNXR0V4R0tGVVBVa2VQUEZ4bC9TQm9FdmFkTEUxMWVo?=
 =?utf-8?B?MzhXazE1Q24vekIzWklhWFBPS1p5bG5NeFhNQUlHMjNRcG9kYWpJWmZ5Y1dn?=
 =?utf-8?B?Y2tqY2ZrVlZIdy9hejhvSkhWM083N3RXd2ZBQmltWE9GV29VYTd3Y3BYL0Ur?=
 =?utf-8?B?NE03NFpIcUlFRVRUQkQ3bjRsWFZDR0hVU3JQTCtkQXdPUmxRaGhFSEF4Tmo5?=
 =?utf-8?B?MjBPWm1KNk5odzNqcHFncUwvU2F1dzlXcVIxdnhSNzBKQmxDb0ZSbHhQYi9F?=
 =?utf-8?B?WlRmdTRFeEhLc1Jxckp4bWx6QlZLell3M201TktmM2J1YjQzNVFsQ1F2NldZ?=
 =?utf-8?B?d2JlM3NseUtUSkZwVjlxbHo2UUxTMVdLdTl0bWVtU1owWDZheDlnTWp5MzV5?=
 =?utf-8?Q?lQr3SrM+dgg5Cm4StZfIsKU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7e7cda-81af-44d8-31ef-08d9a5f3a17f
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:46:45.8761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFRMztG2wJyfTy/feNgIaf+/LIPJPbUB+4tKriTnZ5edAl44vrxx+AJb+5NFfwBAxtQBNlBUJIiYLHt5uGZ7UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5566
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/11/2021 18:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


We are still seeing some failures for v5.15, but these are not regressions
and so can be ignored. So this update looks good to me.

Tested-by: Jon Hunter <jonathanh@nvidia.com>

I have now sent a revert of the offending change [0] and once this is
merged into the mainline, I will send a request for stable.

Jon


Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     114 tests:	108 pass, 6 fail

Linux version:	5.15.2-rc1-g12d0445d66e0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py
                 tegra194-p2972-0000: tegra-audio-boot-sanity.sh
                 tegra194-p2972-0000: tegra-audio-hda-playback.sh
                 tegra194-p3509-0000+p3668-0000: devices
                 tegra194-p3509-0000+p3668-0000: tegra-audio-boot-sanity.sh
                 tegra194-p3509-0000+p3668-0000: tegra-audio-hda-playback.sh

[0] https://patchwork.ozlabs.org/project/linux-tegra/patch/20211112112712.21587-1-jonathanh@nvidia.com/

-- 
nvpublic
