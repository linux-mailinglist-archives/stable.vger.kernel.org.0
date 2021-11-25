Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3541845D923
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhKYLZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:25:21 -0500
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:64801
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236758AbhKYLXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:23:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTLCKpnT/LruJgXxZj+iW3uejULtTHSn+qZmPXxiCuIb3ZsknibNMbwxr0/hFT1cHxyba/Y9ZJbhAiSeFzC3UguPuome/1E6vbYbvVk5lS3XJvZMoD5jckLbcVk7A5IN/bIDvsXw2BnekJZE9G8ZCaNT2uJMYquUF+OmJeDtr5E+Kd+ksHbWQan0Ae3/Sx5udpOIFNlVuLIGafZuwcj4/HdfN67DOVmH1IENT7cweaLvp8qPZ9rwKxCW8GJ5j4sTf/eSkcVkzOdfZZrCcMOKQ3evJ+jt6SRq27i9Z7fUkLvwqOQhOB/OZUZn0+rRoJ5BoG9ZaIIr9HCVtDiNCQXb2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rrmHQjjF3VRg4uHoUakYuxfpbIBVZ4ul5W0dozw1Sk=;
 b=FEixD1Ar2Sc5r2LL2JpLS0E0dJeM5yujqxAZ5i37O0oqfmxY+s+apm9q7Dt0uFhFhxOzVy56g5v/Vftf5Zh9Mvf4GIg0f6dxY046l0XzR034BWbJ0j1OyCKztD5FnnKE/T8y4d3nqlm21QcILaeEi052Q4xzrU6HeZRI/HfQ+tyX/gNb8wlxzcmY7iZ4fEeQnonCtzSGFK7ulpyhFWOxOtjjoe7DaAncKTmTcLfsfzDsRWQexQdRqGor2rqBQdMV3d+FoGh9DYZSYBDyEcQvoP1WLJcef7Um7tfBb05c5rY0luLF2T8FUpbROZQy1Rqi7jxjUTxUtrqzZHRyQgyqPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rrmHQjjF3VRg4uHoUakYuxfpbIBVZ4ul5W0dozw1Sk=;
 b=Y2sLevEzzL1czgrY5rflKDbN7o37nCxOj/m30pfw+y2TtNzw9vSNWTu9EL1/q17e4IWDrr9/hmQXs078v31apbg9OWIeh4RpPFsGjECBPdGuQTVpXEOct51Y9wpS/tcuSL77ybPMmofmmZZJtFEw1BUYKuF2nz+k50A8tVwz69Wt6IXXntH5duTJn8kGOIg8ZwopC+w/fz8AMySBCjd8qpkJzyMh+WzWxX4PZkdWmFCN4Fy71/SOGsrrPw526bgeMTcq6tKIw2JkqU75dwsQs6Z+YK/eZd6hhcmUgU5FjXNpvd9tiNcHGp+4wrD6sI1qUXq11n+YbFf7aCWZyrt96A==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MW4PR12MB5583.namprd12.prod.outlook.com (2603:10b6:303:183::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 25 Nov
 2021 11:20:07 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%5]) with mapi id 15.20.4713.024; Thu, 25 Nov 2021
 11:20:07 +0000
Subject: Re: [PATCH 5.15 000/279] 5.15.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211124115718.776172708@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9bcb76d9-38af-0179-6aae-50515e75d857@nvidia.com>
Date:   Thu, 25 Nov 2021 11:19:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0008.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::21) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by AM6P191CA0008.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 11:20:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c540a61-e496-4142-72e8-08d9b005891d
X-MS-TrafficTypeDiagnostic: MW4PR12MB5583:
X-Microsoft-Antispam-PRVS: <MW4PR12MB55838623FD890B1E30F53DEDD9629@MW4PR12MB5583.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UifqMzBhocgxKzWdKNuFkWpgg3wAzqwdbaJIMxBsn+d2ejqbhW8LTO//x05DPQCB0nYn0IL1EBLbdhHwbuYGO0LKCpKaBFSd8J/5uRvoM1N7G4kxht/GOyqskzmc6BJAM4CiwYiXago9LX0MCY8sHMj609B2NZFPgekK0Hf5zqVMXjCRTdJbdzB3l2dTlGL6RoZsnsQDT8LPtpIEbQm09hR/4o7PtsuNWXYInWnuFUaiH6FZygES6/ba8hInYglBQPzqaFkfbA6x6p1b1zkTs18iJYzWVb0SOLWcGcRi0FuDiw4dAPzU5gYS1h+LKuzgneL9B07irPWjjhGaXIXvrSxttSllRxNDEBcqL4h0X1HyOoaw5uMlEzmJi1xxwJDOyK1sBOqme6Rt2slSlVCd7lwCkGS/jp8zrAw+yPMsUekzfM2lMtOlBiM7gwGcXMxYM/+4U56U+E3vIrRA+EgJwwwj981E/i3XTkGwcEWdpKYa68hfEeFH9k39WeToSMbvuBeG+bsRj8qmgGe7APjBZuXyPBys2pvdDNCxDaaKd/Mrv2YDk8h40zrrVLR1ry34eJ7NRbGOGlk+TekMhxhYtEBj31pQG4YDWVX3TbMK2pNKseD0nNAluhngiO2EcBL2F+C76q7BnfpzBAlhBXgm45mAAUz3N7yHO6Q8Suhst3u3U1oAmJwSBGlNdlKd30mqHb1epP8oJH2+oEdPc4RlT94ke+ugFoVEfCnVIs7rSA09yKXgP33RepTiwVtUaSkSaPzN6zPhSB44qbhwxn67FU098fTjVW8WaIXleRPpLZ7d0hkvp/1Ndl+Sa0KIlZg24X4T2trVrdiYGMgx2vmXTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(55236004)(53546011)(36756003)(966005)(16576012)(6486002)(86362001)(83380400001)(7416002)(6666004)(38100700002)(316002)(31686004)(66476007)(508600001)(66946007)(66556008)(4326008)(31696002)(956004)(5660300002)(2616005)(8676002)(186003)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzZPM3hMQ3hlSkxMWjlRM09xWUlsTzQyR2JabWJTRU40SnNXSmJUQWI5MTJK?=
 =?utf-8?B?Q29vRU0vNW5NOVZXTUdpV2xYOWFabWZPT1h6eFBUblJqMnNSUWxxeGlWYnBB?=
 =?utf-8?B?N3NjczVZZittOFJVNitqTGR5bWVxbjBRU3R1MVFzcFpLc2E5WEJTa3BBYTZM?=
 =?utf-8?B?NDU4d1RsQkhUN1JLTCtRN2M5S2t1NVYwWWlKSW9PQmswRnZqSVFwMCsyUytV?=
 =?utf-8?B?a0lFWnZkVUhuMU1LbkpXYTE4YXh6eEsxd1JNcWl4QTdIS2lYd0pRRzYwN01E?=
 =?utf-8?B?SkFuaERhM0grZjFHRTRXUk5zQUxXeGVCVGF0Z0dWYk9yLzdzbmYzMGJsa2xF?=
 =?utf-8?B?bmdmMlZhS2ZMMWJtR0tVVElpRVRybUdCcmhXRlFDV3ZZNGtHa0J5L0RKOWV5?=
 =?utf-8?B?OFdYcFhVWGdocmVRTUZURmRGeVB2N09pZDRybXFkOVZDcXUrNUozN3VXeXBL?=
 =?utf-8?B?Z3p2djFZcGlsRkFZNU53bGNjVVBlMlBESzJyTER2aEswdUdKbmVteURZVm1z?=
 =?utf-8?B?dXpUdGRTc0pBdEhiLys0WG90SzE3N2c0eTlac3EraXd0UEZ4YzZnUU9QRmg4?=
 =?utf-8?B?aENlWGIwQlJVb2tVb0I4U2Y1Y2tubVpXNFg5R2MySVNNdWJvRzRXd0RFWTl4?=
 =?utf-8?B?M1hsTVZqeDhyVFhPN0R2aWVzeFM1RFJncnlNSVRSVVBrbzhVUXQxNFRyNXI1?=
 =?utf-8?B?RTF4bEpBMVdJWXRWV1E0S2hZeE5qMkxEVHJJNnlldDdFS0JKL0d6SnlOc3JZ?=
 =?utf-8?B?Rk00NlA2TldCR1B2VWo0SVlUQzdnV0k4bVAycG9lZkdJNXpQYTAybGlKZ3N0?=
 =?utf-8?B?R3NRbERsUE5mcHZVM3pzb2Z4U2NrbVJ1eXpFcVlJNE5HRk9ZQkU5dkU0enhv?=
 =?utf-8?B?SFhqMmM5d29CdzI5S09oMU94YSttSnRvNWJ6Q3JkQjN4UEZ1cVRVM012Y2s3?=
 =?utf-8?B?TXZ2bWFHUkRZVzkvOGVyb2o2Z0tiV0hXV0t2emtKYU1qdExBaXR3V0RLSno5?=
 =?utf-8?B?bnpGVE15QjhMYmNEZ1NmeWdwVFg4KzNQQy9CUWNaeDBibVhwMURzSU9ZTzlF?=
 =?utf-8?B?OEZBZ0txR2dTODAwSk9taGsya1RvSEtxKyt5eUcvTGxWK09rbWFHSnEwbXRj?=
 =?utf-8?B?eXdqejhUcURWSml3YktTM3FEV3hvanAyWVRTZEgzYUtZR05iTmszeGVwVWNv?=
 =?utf-8?B?UzBxejhOU1B5QWMrdThJL2xlemlzM3Y4SU1jSjNtbkhCVVdEUnhCaVYwYWp2?=
 =?utf-8?B?MmxzTUJrZDFNT0d4dSs5Q01wMkM5WFBPa2RxeXpxRllRMHNSS3B6T29MMERW?=
 =?utf-8?B?Z1FRRDJodTdDRHdZbnFWME1COVoyTzNDeVNFc0dBVDNmcnRTdGtFYTlFcjdK?=
 =?utf-8?B?YW1rZjlMZ1l5TGhkeTBpOXFuQTRlYWppREtxV0haUmRkdWg2Nis2YUJWdDNO?=
 =?utf-8?B?QjdLSXJpYUVtMk1hcW4vZnlVL2MrdlovdHEwOFg0ekRmWXk3MFNGTzRSVUlw?=
 =?utf-8?B?aENydWVMZmpVbGFPM2lFTFl3NFdPenhUQzFFOWFEZXhJNG92aTNWcnRXZmoz?=
 =?utf-8?B?NDBMQXVTZGdFWWdXWGRZL084VE1yQkJlR2gyL3RkUGdMU1V3VUxiNUJ2VTRt?=
 =?utf-8?B?eEd3bmo0TTYybzlJRXh1L3FRT2xhK0FEM1V6YW9PNWdyUm1QaDUxdnFndnZO?=
 =?utf-8?B?WDdFTnRwdFFUaWNabjRDM1BxYkZRVTRVM3lDVkZndUIxM2dNMHZLL1pIcEdS?=
 =?utf-8?Q?iBywlykKM8WEiKEAS9qxREKL+crh8lX4kQXkH7y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c540a61-e496-4142-72e8-08d9b005891d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:20:07.4903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAoJxzvKEfO6zVbn9Mf4gMcleEdo2OwCwcUJGiX13bmdSu1X6LU/Uy4Ibf5UeW8st3a2C/net33jztyBq9znDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5583
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/11/2021 11:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.5 release.
> There are 279 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.5-rc1.gz
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

Linux version:	5.15.5-rc1-ge3bb2e602026
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
