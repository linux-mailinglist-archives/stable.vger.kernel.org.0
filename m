Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E02472FB5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237111AbhLMOqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:46:16 -0500
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:12512
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234143AbhLMOqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 09:46:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUPd1zIbTKqxCBz9sUghISRzEwK06LJnayWAzp45si+ZbsjMjLt6FCxEoeOsROiglFfBnANH9KO79P5qpb9+ZsZdJw4gRG3zsZ675lJjXR3bzBfvmj4RC3wY1lifICIrvoX5pICBqPARmonrVuzAguZuQScCMkfHIIA4PWAzF7o/Ehm+XFvQHlM1gqNpSOs98HTEjGEN60SJQXPfXlb2g3SLGbTo8qicE4M03eYTmTZA58C1vmOEzu3jShhnFqGmv6TXy4S5YZ2KMcUbl5WEqdPxuFq9Bvpq2n5GVr00EI+cnW21/l8yp7c5GNnJ9ds/oiTe7uN0OyY6OAEBHJnwJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkR3X6rTJw7MzzdqfahNVCniR9QaQlKVwcMGAMpaNos=;
 b=FXSJtC5mNlNQ5sOhYqI00oTbsbJnH4obNnyNziLlxmo8/P90dcdpNy1zSAB6YF1/pczWPteGkIH/I9x1BK2MOvt6gP9h9b/GiYhmEoIVVxQMcdRvi77OKzxZ1u2qTicu4Yk04gQeoV4BJEWMVj3tWuBDGPF1RyFw6bC9LHSEze1lNehUsQ/y4MrxKcPkti/6Lfq72VV6OArdXxtCKfAzmyQ7XbzIkc4ebnSJI9kcbplELRKruIN9YhzFvfa1RwXg/+lVhqcZQLWEKP3vorwspolBgoBZqpu2wVdIJxu0niZQ07ltTG2bnSL3g4g1LW9rw1vKgbBrU6Z2uZRBVsh0kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkR3X6rTJw7MzzdqfahNVCniR9QaQlKVwcMGAMpaNos=;
 b=nDa5Gt1qm2YHTBkNv42GZHiQbwg4s/WMI5jio9UUeHZ/gTfzTb9oV2kvpU+beyoNI1blxveOl9170xTEEMPJfA58NEKvU09u4fH/q8jC3HNyri0VtT7qge/GSaLPAqfgwOxZFt33yChbBtxOP9+dTglg2+c4YDVhkTwtq0Zook2i+q0Kx6Aaf/UiyAsXG1ktM00zeKH9IMzff3f/cT1lQDrvYu7hyIZ4glvRhgzeHpI0JXb2bAUYSu+e7LD1WJ9FdP45Gx2cNsIZS3bUBKedOHuhj1O5TT02ZawXcqxdiy2pRqdJaPLqXrWIVNVwtiUYD6G2XAGaiYfwLP6VLk04rQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Mon, 13 Dec 2021 14:46:14 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%5]) with mapi id 15.20.4755.022; Mon, 13 Dec 2021
 14:46:12 +0000
Subject: Re: [PATCH 5.15 000/171] 5.15.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211213092945.091487407@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9a5ae64c-ed9d-f192-3871-ff5fe3575a8a@nvidia.com>
Date:   Mon, 13 Dec 2021 14:46:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0322.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::21) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by LO4P123CA0322.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:197::21) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 13 Dec 2021 14:46:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9172e23d-bd76-407f-be67-08d9be474ebf
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB54444AEA5D219D5A565A63C2D9749@CO6PR12MB5444.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eZnJ5jZ3y45Rimv/t56Kxpo+nFA6lVIWA67A4wkf4yWwUIw173wC8a1c+8YUgim18GceW1tUWuLKQIC2FDhrxY2omWevkPR3nlHaTOnk687XMBrUvHN/w4FEPcrZatqJ3dRcC+4cW4iKiZtWchQyUUSc1WIMcj4HaK/K2gk1ByCXHlB2Q+w3APZV1rndJmEmFAcAUnOMxaKLkHLGBMSwKCXVHIR2wAySLSh0jZHcmgitl50wwhzyniCs6e76KT6z8xerwivodPGT5VrtP9gF9ZlQjC98b+vZtAE0Dv4yomK+558XdDvZk9IDTtk24MZw6mwIIoGSDIoL46y/qztbsLrpnwiOiNGXaP690PRS9JG+uGWYDqhwTxQhZSzOu7otvNC9ToooIMr73MnP/j6mMIOUTWOUOU/vVQL4kpIJIywsHTVvQor+2HWR4GOTtcorKDUbzqlGN+BahoHoOf29GY3nkGRNl6PC3uj1GDkW26xLlmAdrM9cjlXlyXqTZePLKKf5kc4fWhFc4t5RTINCq2T43s4H20ilNmx1yJElxtlUH1DDZ/K9RgzNxU6st54f/EmOyJq2GWwm5tlOLzAlgApC1SeGVZmv7U0Ki9QGoJLM4wR16H8Q3+blBIt1bmD1XyOShAf2e00XVgXX+10uznRw+vwFis4nmbpQX0x7UIvqDX3+G6qCn4JMCQh+cNzlshJdkLasLzNmf749t84oTV0sNuKcp7bipmw2JTKVkmzbhMfD0qFRJWv1HZ9v4C3V7/kaWeU7Mi85XNIaB9X+nrWevLg6HB3Wbh5RADevCZ5vZ91CmJ2pp/p5IDxDTxXRbVm4RJvnbmbsUDhW8wkcPq6F4y5FhpePN9TmNgmfg3Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(53546011)(8676002)(86362001)(966005)(31686004)(508600001)(316002)(83380400001)(31696002)(4326008)(16576012)(6486002)(2906002)(7416002)(66946007)(8936002)(6666004)(66556008)(55236004)(186003)(2616005)(66476007)(956004)(38100700002)(26005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVAzNUVaeW5zaE5DMDdKOUhrODM5a0RMK212WS9TZzNUckorNCtFUkUxbElF?=
 =?utf-8?B?VjB1eEtMWXIvdmtFNkJ6YUg5Z0tEU0VIbk90MGRvTDRORE5ER2d6cjhBMGRq?=
 =?utf-8?B?MGpOOEVTWkFGR1d6NEFrL2RYRFVSd0JxcW1yZGZlUjFEZ0ZSMElKdjgxVXNW?=
 =?utf-8?B?UHJZMEtvSmRkUExMbENtVlQvMkdJTDI3QnI3UE9Gb2p5Nkl1VmlmOGsvZXpG?=
 =?utf-8?B?ZnQzL1RTeFQ1Ty9aQ3FTOEg2VzBwY3pJZTVBQWUraFVaYnZhVmxSQzIyNzJE?=
 =?utf-8?B?S1o4cjJVenVYaWJZbWxyRDA1dER4OGYwT1pyWXJFUFcyWFcvTFBEM2gwVWt2?=
 =?utf-8?B?TGs3eTVCWnhsL1k4RmdySGkySGEzb0htRWlQUTFYdnNXTmVuV25wcS9DVW9P?=
 =?utf-8?B?dEhKUFNmdmltSmdIOS9kTjBFb1NtQlVVTWRvb3F1SExPT2tRYm1vcGlZOXZq?=
 =?utf-8?B?bzAzZVFMeXJqWEtGWFhHaGFFS0FZTllaaENhMnNzb3E3TUc1aVRXTktkY0Jx?=
 =?utf-8?B?MXorMy8wL1JBUnpvbitHNG13Z2htVkpFTzNsOW96SzN4NWJHWm5takE5TWli?=
 =?utf-8?B?WVVSa3VrYlQxcGk5cDJ4NkcxQThVV0JGWWx3R21BTTFWbmUvZ1lXVTdYRVYz?=
 =?utf-8?B?YU1McnVaL1R2c1A5OHdub2ZKbXlyUlJLenZEdmozRmtSczlzMHN4anF4NlYx?=
 =?utf-8?B?amU2dGlpWnVrT01tMUR3blZxNzlXekVpNjUvVml1N0pGandSYjI2eXFuSnVi?=
 =?utf-8?B?eEF0ZHAzSUlISVI0SkgvaU1va0ljU0dyb0dPOWhtNjN0bk5WV1k3aUZ6bThi?=
 =?utf-8?B?MlFVd1hibXBPanJnY09xSksrSjZwb2xGc2xBaWs1YlRNY3ZJQVNuS0Z3M2cx?=
 =?utf-8?B?eUFlOTEyaVZQN3Rsd2FGTGpmRTg2MjF5dkpHTUZRSEtXVWZUTDlwV0FKOEJU?=
 =?utf-8?B?WkpRN004UlV4cTFGblE5akYwQTVLdldiN2hDSFlvMWlDTVZVTkV5M1A2VDhT?=
 =?utf-8?B?QlBIdXpJcWpTVmVqRnZoNUR4UkZZUlhBeHdDemJJZUNYVWZyL0liSGhDenlh?=
 =?utf-8?B?SmpLM1ZGODhoTVh2d1VVT09PbVg1T1R4YUVvZ20wOWdzMHlqaXhKS3dlQ0RK?=
 =?utf-8?B?RVlkNW05Q3F6YS91STZlMFoxSWgrU1N2V2pIa0ZmNU5Xc0JKVjZ2cDIzeDZ0?=
 =?utf-8?B?VHlZMktjTVE3cHRGWlJzazlnUDNqTDVZUmpGeWdpNmFsanVnTjl6UWdaNjdn?=
 =?utf-8?B?RkJCUGt2N2RGWHdoMHEwVU9QQXpDK2wzSlVtVTdONnIwQWN3MEZWMWhtNmZo?=
 =?utf-8?B?MjkyYmtKT0xKcGY4NWZlU0FTRjlzZ3A1Mmx3R2NlUlBCYlVVcDZtbGd6dGtw?=
 =?utf-8?B?Q2pkRWEwbXplNndEL1pxVDI1V09LUG4vZ2tRakR4MEVNMXUwVEJvbkRwOFNX?=
 =?utf-8?B?dytJRWlLUHpEb2NWdk4xM3JkS0F0dUw1eUhTN1VzWk9jVXhKcUlyczNqb2ZN?=
 =?utf-8?B?Qk1SR0Zqa3dBQ09FRVdVeGZZN0lqOEliblpIWHd4NFdIT2xqMnVUY3NNL2tY?=
 =?utf-8?B?QXBheHNJcWtGVUU1M1ZpOUNtMVBBTFJTSDBxdisxL3l0VTRTN21lOWNjczQ1?=
 =?utf-8?B?bkZaMFpaRUY0VkxRRExPdGo5MlRDeHR0TVkyYWJRc1JXdk53bGJuRDN0K2lH?=
 =?utf-8?B?bTNhbjMyRkgrT0RIVmtrVURqU0hyc2RaTFI1N2lDa1pLeGM2Yy9XSXp5ZVNk?=
 =?utf-8?B?dlhDTkJ6Zms1bEV6cXBWaklwRGhRTUdEZFdXL1pZQ0tGOUtIc2VrcFFicm5K?=
 =?utf-8?B?Z0x6Y3gyQnB1Ymd4NUhEaithVmc1VDJ1RlQ5Ylc5VFJaRXFkUVk0NCtDS2Mz?=
 =?utf-8?B?Q282QWdoRzRlVy94ZmpSRUpzN2RVMDR5ZUczcnBROE5MdlBnQ0hYczBOZ2xr?=
 =?utf-8?B?RWhVUW11akt2OEg2OWUwTGkvUXVNbzN4QUFJcGdXWnM2VWQ2a3BIWDB3Z3JN?=
 =?utf-8?B?d2dKcWxwYmRCOU9lT09pR3JJUW9SdHo3T2JJdXFDdS8rZ1dmc1pUMGtUQm9U?=
 =?utf-8?B?TXEvTzJ6WDJrTWgwaHk0M2o1MGttaGFRMWhDTytES3duRWtoK1QzQm1CY3Z6?=
 =?utf-8?B?czJ1UmFKdzBFZTFDSERvQnJPc1V0YllxeGpicVNVWGZBUUlMTDhURDlIaURQ?=
 =?utf-8?Q?BMSjC79zx4EQxPjnVJpQWmc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9172e23d-bd76-407f-be67-08d9be474ebf
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:46:12.6155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpZnl07WkfOtLXGYaNuM70IMfqp4E2DSx4UNxPsCCsdb1zw8lW4t8YJQmjN/O/cMf/yM8b0olLvS0W7X9vUTQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5444
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/12/2021 09:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.8 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.8-rc1.gz
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
     114 tests:	108 pass, 6 fail

Linux version:	5.15.8-rc1-g5eac0dfa371b
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

Still waiting for one more fix to be merged upstream [0]. I
checked on this today and looks like it was missed, but has
now been picked up. So hopefully it will land soon.

Cheers
Jon

[0] https://lore.kernel.org/linux-arm-kernel/20211119170714.BQFJ7tn39YCcxjxErR9lKorUx6FTJ9inZFOmDd1zR8w@z/T/

-- 
nvpublic
