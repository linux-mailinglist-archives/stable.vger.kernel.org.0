Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A92453B13
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 21:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhKPUnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:43:37 -0500
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:2784
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229614AbhKPUnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 15:43:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0X5tKUUPqWINYiOObaD8wJT2jtxV7dbOSG2rL9KryWGB7j4eeM1UXNSBgWzvQsPDuq37Lbtm/mb6I2bw34BheF2ZtqAsg4DfKV8OR8eWmIo/6IkL/E/ycFUTAHAjwy9LE5dQ7qUiwZvZfKmbaOrTWOfnHUBGRreGlv/uGfIbfnclWKDnNQi8TQBSwgfdj8Z8H1h55mFgnlNXzlxveN64m8zL0cbaxvR1NmoORtbRK01nszIuVNZZ13JDnuuDx36mWGbpW0IOceQdG032ehKrkRXzKkfKhazkj+2BxtXt8p5AdqQDOa1dsBR4WMM/dzq/vA8gOx4QR+2orxZ6WIMjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DkGH2DRxxCx8SGVlP8WnOW/MEAIxYQnmajXirLk098M=;
 b=NtgLhBK9gDnkOsERTX7Z64mUdAnUp45dlTyZGEcq6J0cSI76apJK24iy9Q09u0+FRpq8gp8kMJM2jhU9Ysqps0Q7771MMchBs4HAZ0k3Md+UzxTJjshwfnsnpsivDuMsRW/CXjuzNLwl/TDT6bm55IaGWtdsxTiNVG8Y7pdjnZjQw2VR/PjIaTBLFTq+VEj+CI+GpY7IiDsVaZXLIbMjCQOAyJINT5GT6IOz6fRphii4Q+uBqgJCHwQJd9f/NS1lr4WR1BuzuwEAARFYJMSnehKicAzcvB1KJdCbMtPazZjDZZ0Epwkx/+Z1ta/TLpZogD4h0JjHDpWaUQDWUSzslg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkGH2DRxxCx8SGVlP8WnOW/MEAIxYQnmajXirLk098M=;
 b=SttEXe9PY82+gstACro/PBTvRmYQNv6tZd+JC+Lx+ftVxjHReYBGYloCLchF05hrRvCGe/ZKchTEw5jmO3UrsYSWpbFgjd6gJodrmsyJlYWu1B2OX6UFhZ3wUosYgzu1bNyuTsOSra+h9D3qFLF1HeG8DAfvIN/jPWX7ay4K6aqMrIgsPRzMKaomu3yj+BpsxT6jBUgMRttwoh/lHrV4ihssAdKW3g6YLeayUkqTjOFgziGYI6lactTXI+2VCGGVEhbmOujWP+g45lugRVrSHopuR1dSijaYPreZqLJpnr8uNCeOGbyRaRvjUdIIn+x1CIivLDA35hgQhw8Pd3Dc/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5216.namprd12.prod.outlook.com (2603:10b6:5:398::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.19; Tue, 16 Nov 2021 20:40:38 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86%9]) with mapi id 15.20.4669.016; Tue, 16 Nov 2021
 20:40:38 +0000
Subject: Re: [PATCH 5.14 000/857] 5.14.19-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org
References: <20211116142622.081299270@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <af1e8687-7e6b-1599-a4f0-116d0da616f5@nvidia.com>
Date:   Tue, 16 Nov 2021 20:40:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211116142622.081299270@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0180.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::23) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
Received: from [IPv6:2a00:23c7:b086:2f00:5a53:1500:28ae:ff6a] (2a00:23c7:b086:2f00:5a53:1500:28ae:ff6a) by LO4P123CA0180.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 16 Nov 2021 20:40:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29a90467-9cbc-4e28-353f-08d9a9415925
X-MS-TrafficTypeDiagnostic: DM4PR12MB5216:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5216B680FA30185FFFFC40D0D9999@DM4PR12MB5216.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQwyk0SenQeA7I0ia9CLDolZ9Zarxe0P67PMu+/wifINvV/aDIOaJwACglVhB6GyAYoqQTf7x74o3tYnJG65mxUTFj5eAVK3O5YNvN/kjB0E6qQxY18ROz2gA2j9qMN2zkhN3JE7Cp7+mSb3YRZagLwYbgQmw/iASKF1qSLeVueGlSRujixmLqyb9ZlZ4MqrDFX1QcTomNBx8CyUks6372wqhyuFt3o+LGxAP8PEfMQsT36ib22+Go12hjSWLqt9cXSMHCH94BwL/jjmoDcPF976zG5RQrlRx6VFSrbNkgMFj7QtQgxx4FFzLWloAxUgPHEaL4s9EWjILV+nV64jzvV6Fle9M1q/xlTc+lGBBlQ724cNTWHy2l3aq1mEF7mZq68J9exuRPVCqfEmz/bCwVPB5GtJu6xUdjDrYcKG5+QvzNu437wDOccaYwcgM1Qno7ESqZ6VmZrwklqPTnLNvT7RJldBxevyvvTrjJpzObW8WaHwXnlEadOiuQ2KyOdXaRVhYqlDffKAvjwp72JDvFhsvbtph+4nL5SXqwq2eTUV6HMUjm9RMQyoalJf7TimC4bE3746t8qKCBNy4nsmHdyyPqFOU7aCTSDtJmH8/4VAM0o45wHJoV31qHre5m+QVxwNcfqJY9407hXLR2toIfZi9mQeorgzE4J4i6eOCLDoeHW6dIj6ipxom1nHt6Hq96K9wYPA+4a3j+WhnvyfKQx9GIvJij4w3Qxw06JcupydjrL26zkpdhnMoArBAz3qF6LO0ZPztFdrBSBMFwj1kDUH2KdRUCVxr8Cmi5s/mZBiilY5nHjb3yFt2l/IPT+np1NCkyKSkE0zNxHNCwHZbcQ3xPEuCa4RxYiuzhaORQYXBL0MndqcwmZSVo3Cwl//
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(4326008)(2616005)(86362001)(5660300002)(508600001)(83380400001)(53546011)(8676002)(2906002)(36756003)(38100700002)(186003)(66946007)(6486002)(316002)(66556008)(7416002)(6666004)(31686004)(66476007)(966005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjhZRXZWQlJ3OUJwemo0bzRKb0ZCWlY5U2czeDBLQWpKZU15UnUwV20ra2dV?=
 =?utf-8?B?bUVBK2ZrRk9lYkJ6NDNDL0pvd0ZnUDQ4Ty9XNU1JMEpGeWtOdExsdVRzN2tm?=
 =?utf-8?B?Z3NRMWNVdWRtM1pVdzdabFFmVktnaVVqVHV3NU8zOEwzWGJHQzBKY0NNR2tv?=
 =?utf-8?B?NU1Ib3RRd3ZqcjRTeUVjc0drUS91WGQ2WXFyV3NsSGVUSjIweFZIaEkyNTNu?=
 =?utf-8?B?WVVCZlBJc25JZW9HTUZnMzlmUEYvSS8zK0JwQ2EyeUdpUnhYMUtmMlNjRnNY?=
 =?utf-8?B?VzJ1ZHBTZGxrQlJSNlorQlFDdXZxUWY3OVlMU1hKZkJHWFozcHUyMklWOGxG?=
 =?utf-8?B?SmppRjJJVjZQT2xHUnJVOTVDdkJxeDliN2lPSlRndjQ0cjBYelA1SzY2azhP?=
 =?utf-8?B?c25sQ1FSZWMrU1NaeTdwRlJRekpsM2tHYTcwQi91Znk0K0xXWFpZZ3RhYnNB?=
 =?utf-8?B?MzJCcjBzZTN0d3RSc0VzSFhGUm43WGRyd1pRUHVvdUo1dkpCTzFPQTN6b2ZD?=
 =?utf-8?B?dkdPa2pvVmVuZXgzaGxUdU94MjJVSS9wcTBnVHdDenlNYmtmay9pYVdnQmdT?=
 =?utf-8?B?Wi9aRUQ5NjBOdDFoUWN3THZ5OGtXVUUwZHpyUG4yRHR1OGtJcUgxSGl4MkJi?=
 =?utf-8?B?Z0tPZk9kRis3MkM0RUI0V043SGorTjVYNHpIQlJtU3lEV0dqc3dGY0sxbVZa?=
 =?utf-8?B?L0FGMGNaQW9GQm1ydm9xajBHdm9vOEs0aDN5MUlUc3B4dmJlT3AyU0tCNXhh?=
 =?utf-8?B?c3k0cWNHRit6MjFHM3UrRU1hWnNybnBuTVNJT1ZlNDlyRWJUS04wWVNrNHRQ?=
 =?utf-8?B?OW9nVEs4elI3OUgzWHRsTlBPT0RlRFBHWHhuaDhXMk5GZDV6eDRsNXpkcXJr?=
 =?utf-8?B?czFpb1JQZmpYYzc1RnNPb1dqOE9CUzF0dmZ5d2U0bC94YVpCNDE5YnM4a3Qw?=
 =?utf-8?B?TUhDVlVuaDJVUjduSTFXTTlmT1VETXAxeVNzVTNEQUh4Vm0rVnRGQjBwc1VT?=
 =?utf-8?B?VFlLN2R1TXJCZGFuQyt1aGNtR2xLMUhRN0VaczlJQWM3TTRNZXArY3RDTmNI?=
 =?utf-8?B?czFybWNFdFU1cmRSK0ROVGhBajRvYklkRUZCVmxoaXFwclRNVkFQdjVOUDBN?=
 =?utf-8?B?aUFkamsrLzNXcEYvbi9VU1ptTm9RcDJDVVFXWmlkTkxlbEtUTld3OUZPcEhr?=
 =?utf-8?B?WFpsbzR0cUIrUGxPN25Hb0Exc3Bnc0w0ZjAvWVFHNWdrRzZTTkpUNUY0SE1s?=
 =?utf-8?B?V0txc05aZWhRNEJSUHZ5dGhadnVvWDR3MU1PYmhNam5aNWdmU3Z3NWdoZWxq?=
 =?utf-8?B?cU9YS0NDenlJV0p2ZzI3ekhOSHNkakxNbnozVWRHYjhZUS9VQVhSYnFmZ1dn?=
 =?utf-8?B?QndDaTdHRlVPQkFKYis4eTFzQ2VGUkx0VmNHR0ZOaXlJZ1dNNG1WekJoczV0?=
 =?utf-8?B?Q3c3Mncrem9UVnFXdldkZGNCSFFCU1J4WlBFRXo4L1BNMzU5UktZcXkzanpq?=
 =?utf-8?B?cjFhdWNDQ3lTdmlnQjJUcWRjNy9uM2xMb204bjd2bHB3aUQ2TU5WbU9mZi9s?=
 =?utf-8?B?V0FqeFI4UHdKSFFXVHpaYkp3K2lzTmZCcHpET3RzL0I2enpEQ1g5U2RYM1I5?=
 =?utf-8?B?R0lKSTgwT2RtV3B3Ty9FZkE4SmNTN2FlWDBHc2J2RGMzUGlZWTl5VlIwTDV3?=
 =?utf-8?B?VDE5VDdUY2xlWlZMdk5Gbi9TcTNUMXdHQUt4OEwyL25FNkROOG1NNzVRWUpQ?=
 =?utf-8?B?YUZVYWZKeDIwOVNMaFdvUXp6ZVpmSzdZcnFRcEs3c3ZQeFp4a1FFaUNQemZp?=
 =?utf-8?B?NExPRW1xTnhYQXR2YUZ0b0o4Q3VVRG1ZSXVGNFBxOXp4cGlQWUx6ekQ5L1Zo?=
 =?utf-8?B?b3RLNVM0cVBxY1dWbFhRMWp0QnlNZHpEd1pOWCtpdVFNSGdqRWExMFlMbE1K?=
 =?utf-8?B?OXBqKzFPeUtnOS81cURCOWR1ZUR0SnZHeXlYa051SW4vdTEvZ1FhZzdWMkgx?=
 =?utf-8?B?Q0xFSUJ6a3ZvZFdaQXIyZkZxM2hrRjNaMGJacnVGRHk1SnNLbG93bEYwQ3FB?=
 =?utf-8?B?NklkUkJ0UXRVSzRwOEtPZFkrSlhWcjdoTFdNT3ZVTFZDa1ZpbFZMYlRoMm9G?=
 =?utf-8?B?VmVvZTM0eFhLRnk5eFNBeHpvVGlyLzcvZUtBVExJTC9qM0dxWTZIWkxnNVU2?=
 =?utf-8?B?Sy9nZEZHN0gwRTRuVVFkUGFscjdNd0ZIY0YrSW40dkUyQ25ORGk3U21nYi9y?=
 =?utf-8?Q?g0FbRRruZkzbsTOED4bF3xRDNdM6ofvT35oyaAipzE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a90467-9cbc-4e28-353f-08d9a9415925
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 20:40:38.6062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSEGZPYahhdR+rzU8c6gA6LpiNMVChT+w1KlfpYRMOtYLK5CxJQiRQ5nBjENXddR5fHbyQfPlPY508QV3wIkCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5216
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/11/2021 15:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.19 release.
> There are 857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Mark Brown <broonie@kernel.org>
>      spi: Check we have a spi_device_id for each DT compatible


The above commit generates some new warnings ...

  WARNING KERN SPI driver mtd_dataflash has no spi_device_id for atmel,at45
  WARNING KERN SPI driver mtd_dataflash has no spi_device_id for atmel,dataflash
  WARNING KERN SPI driver mmc_spi has no spi_device_id for mmc-spi-slot

This is causing a boot test to fail on Tegra. I have posted
fixes for these [0][1], but they are yet to be picked up for
mainline.

Jon

Test results for stable-v5.14:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     114 tests:	113 pass, 1 fail

Linux version:	5.14.19-rc2-gc82fd5d7547b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


[0] https://lore.kernel.org/linux-mtd/20211115113655.237785-1-jonathanh@nvidia.com/
[1] https://lore.kernel.org/all/20211115113813.238044-1-jonathanh@nvidia.com/
-- 
nvpublic
