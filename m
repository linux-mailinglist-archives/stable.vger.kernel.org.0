Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1238476287
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 21:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhLOUCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 15:02:07 -0500
Received: from mail-mw2nam10on2040.outbound.protection.outlook.com ([40.107.94.40]:17888
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229699AbhLOUCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 15:02:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8873xawGJ1nitdQYF+D4X2aoOOSY44kD/FuG50rKQAzh1RyvGcR0kyCKj/EYSx6H3HmJYwbfU3InWExIlYAVdGtFyfgTq3ElqbqqCdto2fcFAaMcpswUI8TkL89u1o2/DIgOJZIM+jdERuNGP961KvGNTkb0sAYWNuYlgIUd3kJkGVaq3X/XcbKZ0GVJ1zMHhYOdmDdQFZaFLfkWRI6dqr/PoKut250J51WMvP1gPVqW0W8xqVK7/6PKivviNE9cQu2vkkIn9h+PHAA6JKHB9pp1unF+qYzEZF7j9XWmkyTIC9Z3CWlcoN9/EM5r4lVsAEsocH2uqhDuofY/k3zlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkYLlvmqiKhjieIHA+wpBt4872dl6QDnMAfwgqhemAE=;
 b=HmDULD40gjidr2dt4srPPXL4mB2q8AIQCcXQ24KM2+YH0VPvzGI9vWCd8ntZ86bK2/9Sa+P3Tt+xgsqzhb2jKpFRPtTfrrRKAoy6yNKg5TomT4QnD7BGeLIhMakFGGM7tf/emNmiaMf5da1aXEwl5eS7lpoWDtbUgmYjumZX3k3fx/QKIjcZHzJ3Sa/IZQCOS8mn4e6ZqRG0wfRxdoo1LhgjDX64qW0YFujCo2Yi7VPHuoXXc0vwTCAduaqa9N29UQT7G/JcF33EZEzG9WTp/CKuzgS1uUG/QHNFnFdQ82obZozgrgUgKVIy5ZtizK+nacbiHWnjKp9IXIe5F00zVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkYLlvmqiKhjieIHA+wpBt4872dl6QDnMAfwgqhemAE=;
 b=Zzugf7ExPUSzc5xQy0ZpF3m+i8yKFimlCKloDDTjRSwkBtrcCduTAO6Zw1PtYgDbCC+U0t8SDqfs7Olto2cA0zOAie8EzwcDlmvHgb2xL8zKt4EVMwQ0Hc0xSNyDUE9lXBZBZii2ZNYZk650rRsXhl5gysnV+DctVR7/mzum1xhgOwrg6Oudv4we+ceSIX/BD4JxyglXq7TfRSVxK5YLz4IzVui8IRG9Hx3HaAT7tNsuRrKiWS5gj0sGmpmOxGpf61HhGYgz7RAcRyAym2KwO3g21eVkZ2/2hSY0laNs+bS/kGo/6XfpRD0KTvPTR+GQpHczCDzoikIroxqMC9hEvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CO6PR12MB5457.namprd12.prod.outlook.com (2603:10b6:5:355::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Wed, 15 Dec 2021 20:02:05 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%5]) with mapi id 15.20.4755.028; Wed, 15 Dec 2021
 20:02:04 +0000
Subject: Re: [PATCH 5.15 00/42] 5.15.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211215172026.641863587@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ef697d12-f14f-d78a-66bb-f4297941aefe@nvidia.com>
Date:   Wed, 15 Dec 2021 20:01:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::44) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 15 Dec 2021 20:02:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2dc2a44-009e-49ab-0d38-08d9c005c3f6
X-MS-TrafficTypeDiagnostic: CO6PR12MB5457:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5457168D2F112E58B5AB67EFD9769@CO6PR12MB5457.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkhPmtInfJPHOUrdhSo7f/rxhOuP/BrHbrxaeLmCYCo8KltAQWXGZW9aTRCEwYGZVWaB57PFI6RZsiBGs2Zl5AIT8hOPyX4AD70a64RSbHiDhQ6xzPTJbBzvXUqAZJRqF/sxfkcgizYqB136aYbedNsDC7zIEpSHKsbLmm//o4JIC/kWax0nsAgVtEU54w28ysLmDb97OoczGET/2abjJGgdY/f7JVgHj/oJytACUf9b/6z1jfHl77WxmXKF/OFfai561pZijzcKJbhgKSp4szs4FL+4r6We7Lxzna9vK6FnXpFoVy87vXrtZrUsq9C9oTSAfcfRWzoYOITi5EORyOA9fMDdyKfdTf+VaXJsMOjSkSRu7xMlozwtiSiVzUZwbnEVVbH0c+9rFnzvpn27BZXJcpb+GgNY6Lf701UoJzwy8/KRcpy69a5wyJwXfLSopgJ177BzdNqv5GmklCw0IGpxulqrfrDTffcGliY9jeX7vUOQ+opES+oLTbkVjAE6TvwpnKec4bqBgWbIKZgHsH6pbTCZm6cV1h/eDmFYNttnJPs7jT1O5wakz16qTK3Lo/2aCkg4/WTLZUop3FBiWWoKYymrZSemdc3mulRS13pL+weg+lFvkClgtV4XboFOBdgPJKxhoEZlbm6za3PyOGO3ZhQON8LdogZBoWKPUGejUxYqWnxLzRaGrOjXsHgeOtg561KmgQ33AwiS9heO3wLiSUyRfr+TmczGbhjLLA94ejr0vx1o7w/2VWcwcI0GZDAWBMZ0UU8JfjVv+VH+SQbVExFshzwbo0kFyK0zNIB3JHc/UXrO1pxtRRpXACyA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(5660300002)(7416002)(2616005)(86362001)(2906002)(83380400001)(31696002)(4326008)(55236004)(6486002)(66946007)(8676002)(966005)(26005)(186003)(53546011)(316002)(38100700002)(66556008)(6666004)(66476007)(508600001)(16576012)(31686004)(8936002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUkvS2MrdWxseko5L3RtcS9ZUFRuUTduN01NQ3BVaURQdUJLaWxkZGpCVTV1?=
 =?utf-8?B?bGh5RW1lNVh5YmxpT3hUdzYwQldjWU00Y3FWMWR1U0xNcHhBaUFML2FnNDFq?=
 =?utf-8?B?bk52anIxcnBmSTIzUnB3ZzFaajE2Zmtoem1OMG1hMVdRa0plWXlLdU95YzFC?=
 =?utf-8?B?ZmEvQk52eHd5Zm90NTQ3M2MvZ2w4b05KaTRzK1RvOHZnM3FSZzBmbFAyekNs?=
 =?utf-8?B?V1lqbDlFTVZUdHM1dFE2TjdQMG15VEk2VzdFUVRXTTRjWWphTFJZL1ZPb0wz?=
 =?utf-8?B?OS9RVGR2Tm5oOW14UlVNUG8vOTJ4aExzekt0ZEYxL0lyTWI3TnVmT3dTSmZh?=
 =?utf-8?B?cHVQMVBqb3FMVUVuU1g2YVg3Um1TMEwwM1JOT2hLK1M3S2NlQzZ0S1ZsZXNR?=
 =?utf-8?B?U3YwdkRYZ294RXY2dVp2N1Vjc1BEeTdxenUzSjhQMTNsbCtqTEgyWUJLMEJy?=
 =?utf-8?B?cXhtK0dVbTlRRnpqMlErQ29Fc0VCdkRrclc0NlNpUWQ0Y0M3ZlhaTm9tZER0?=
 =?utf-8?B?am1wclROdDFMS3JUUGJPYkI2Q0I3YWNtZldYYWRNdSsvMVNHRHo3ZFA5VVpt?=
 =?utf-8?B?dVRlOWhtZytNdEE3THdXQXZKOXBlZVhNWlhFbkRIWVFSYmZUQTZOckdKQktI?=
 =?utf-8?B?ekRNWmhNY3VoMk5XQWoxT3BSYXIwNWFFdklZMHdubUJRVmtEOGZiWkRHMS8y?=
 =?utf-8?B?OUdmZDlGb0ZXYTRpRG9OY1luQVBJRC9NUFdDZUkvVW5iOUloUjFURytyNlkw?=
 =?utf-8?B?RVlSMDR5WDA3UEcranpqN0VZY3hCMTZkQ1B3Qm9GU2FEemZwZDRIN21jWXls?=
 =?utf-8?B?cFpNVzVmYkVhYXlhaFJZaGovQlpnMHc3a3o5MlF2K09oaWRPWnJkc0V6cVo2?=
 =?utf-8?B?c3NHY1MydkFQOHh3TFRaKy8rbjdCZnRMU2IwS00zYkJFQTFnckVkdWlESmtJ?=
 =?utf-8?B?Ri8yY3JvRnc3SkU1VkNCNTBKemFFRFNBQmUzZ0E5N3JQeDhFNnBiaUxMc0l5?=
 =?utf-8?B?MjFTRkI4Qk50Y1RibnVSVnN4NStNcCtOVVZaZ3E4QzVBdGdaOGJWQWZkZTBH?=
 =?utf-8?B?YjJkWEQzZktHUk1janRDVEdjUzRCdkJYTEtYTjVyS0dLN0tqTUNRbmNGRGpW?=
 =?utf-8?B?eStFTmtvci9KNFVzcEpaTDd6UEs0a0pDY09Tcnk4VU02K2VCQnRxSDU4b1RU?=
 =?utf-8?B?ZUpBZGlET2dOVEphQlFaYzhpQm1GRllGUktSbkVlSEljZFZkeU82a21ieHJt?=
 =?utf-8?B?OTBxc1BOcTJHTzZjWnRqN1JXZ1VSeFE0VjlyNzdsMndvcnQrdFRwS3JkOThW?=
 =?utf-8?B?bG82NjNBc0ZXS25sYkJMOHZadkdLdTBManIraEh2WkhvRlFsZGw5L2EraWlw?=
 =?utf-8?B?TUdUcThFV3phNlc4ME1nTVFON0VxVFBwMXNnR1dyMGRVSFFCeFFWeTlXK09m?=
 =?utf-8?B?SjlUNW1WUE5ZeTVjODJRR2NvNmtoYk9PSXBiSHVuSkJ5eG9lWm9TcEg5VG0y?=
 =?utf-8?B?dWwxQzdLV1Q5N0g3UFZ0TWNBQkVTd3RzY1d0N1JTazBsQzNHdCtLbGo5LzR0?=
 =?utf-8?B?bEFQa25aZ004akhyN1hYT3VsN1Y1YWsxcTFsVFRxVGZlbWM4ZGp1MHB2OHlv?=
 =?utf-8?B?VXlrelBTMitMN29STDVVenFnZUl6elJ5Mm9EOHBaU0ppS2xpU1NHaWpRQndy?=
 =?utf-8?B?c0JtZVdkZzVyVXltTi9YOVlLQWh2YUtXYnJkRFJoQ2FhOFY0NW1KY0xlbU5D?=
 =?utf-8?B?QkdNcGkzSGZJdHQ1RDl0RGlWeUlRT3A2S2RZT3laVnZaWUhVb2dPWUk4TFBw?=
 =?utf-8?B?bEJ0WXp3S2lSeDF5RkUyUUZ0TGhnM2JWOWpZVXBhZkY0M1MvZ01IdEk3QWRU?=
 =?utf-8?B?c0x2L1ZVWHJpMlduTDU0MW1HekV1aTJSLzF0YVBjUkZHdDVoVHQ0RkszeXpz?=
 =?utf-8?B?QnZobzJNUVpTYzNxZHJTVC9oS0cvbnlHWEpUeTR3WmR3QjJHdGEvazR0ejJk?=
 =?utf-8?B?WDFnZFUzdms3dktFUDd5Y0JyS3Iwbmt6MDFVNExkMDkyMTlzejBoWjZ1aUlC?=
 =?utf-8?B?OFY0ZWV5bHZYK3FCWi9iQk50SEk0ZWo1ZWZyMysxeExyYTBkMXRBbStLNkRy?=
 =?utf-8?B?SzJkYUFRN0pKNlp3bTJvb2wxc0FIblhKWlR4bWJLNnlPVk1ZTlh5UGF0V0Vl?=
 =?utf-8?Q?9xMaSadd328r1rEEk2Dux9I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2dc2a44-009e-49ab-0d38-08d9c005c3f6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 20:02:04.7266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83gZdn5wB6XcxkEs+OdNvniK36v0y+zXBFTD275hUCgNjUQpbo3QaF2pstT+Fgmck19+B8Nz7hCM43FHbumrcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5457
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/12/2021 17:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.9 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions.

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     106 tests:	100 pass, 6 fail

Linux version:	5.15.9-rc1-g1388dadc57b7
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

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
