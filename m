Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B702454CBA
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 19:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbhKQSGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 13:06:06 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:6432
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239817AbhKQSGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 13:06:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKcm27wFCdz3xS7Ntunp2MF1YsRKU1IP4vl0VZn1VagP3gbuuGt/GerV/zzwOIfyVUrrnUozXgSrv7VYow9bOZJEeWqVlaCL1nd0CPiLYgHtJYbn86LHNpndfiTfLll5bLn40M9jCKyyPw9/9iwwL+5+1v11Cy63oDlxq90dXp/VXK7XkLLT4qemQrWFs1A0T1+cFJJbCUCksSjS/SgcfyqsdLJP+lE2ppSr3PVtml4x97vugISQCfjtmbVy3N6jlpp8z6E+2ldywDAmTlP5BSXfIbXG4V+qaxHGQdKNHFnQmH3NzeguJ94JVZ8AP+EYl08x5xeSUEHLcMm+zwDozw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycj+D3bSsQz1Tm1F74yk/dAVAz9RJNmx+nnLHN4Qrqg=;
 b=PzeHP/iK5X0m49ixP3FkL4S16g2IMlR1/SQNRKPMue3K/bAwq3iHjG8XDy6StmrqDO8UzWsHRRQFv99/NFGdbO8bb11C0u3A+Uj+viAn9p5UwvQse0HNuKsr/JElzQ31/lFOAZ7WQWP7EoOcLl3hJuTEQ55oTmpmP7/p5fktASS+EYwW8CUdvBXYgCpVYLgtiKJwy4XJje+XuYKA1wost4xjJGN8JhW94wtAxi1hxxrljiaLkxr3XEwgYa8z4skPpAwlxygQ04HGicw/l+STemscPIKIvtU917xegb5vgLknN2fd6P03ufHESxpn6jURZXoyG+zMvhjBTcXbM4x1TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycj+D3bSsQz1Tm1F74yk/dAVAz9RJNmx+nnLHN4Qrqg=;
 b=EdJfCj/g20zQcei3GBp43+Q3GfrvsMc65FktLWCGzBDu4/PrtEYAVS8VmMaxwNt1Si2j8j8WDeKwrTBcUqccFDcop6ODOTdNyRRgXF0T1EzMlPgJ7sRgQfyrk1f7XAgT2UfCHuvXajRq8lRkMSNWj+AdAhpDjsGDLAbbS90PqWGGhbToqiXPmLQ3KKenszRSE8MHTwBvSjRyT1PF/OSEZXZGHF046xUBAhFQqiQbBpFZxY5R5P5n2UETvLFAfGMEuz87BVS5iq7KXFsHkFH7r1wwYgqCg8sOjxfUhgIJpvy6lf0ZO/cjlePhfjZ41bJPVKDsKGQWr1eswYBRZiwrcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5230.namprd12.prod.outlook.com (2603:10b6:5:399::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.25; Wed, 17 Nov 2021 18:03:00 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86%9]) with mapi id 15.20.4669.016; Wed, 17 Nov 2021
 18:03:00 +0000
Subject: Re: [PATCH 5.10 000/569] 5.10.80-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211117144602.341592498@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <2d8893be-1d1e-0a2f-eb92-eeac0fb84c4b@nvidia.com>
Date:   Wed, 17 Nov 2021 18:02:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211117144602.341592498@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0069.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::33) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
Received: from [IPv6:2a00:23c7:b086:2f00:fd12:4d15:935b:56c5] (2a00:23c7:b086:2f00:fd12:4d15:935b:56c5) by LO2P265CA0069.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:60::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Wed, 17 Nov 2021 18:02:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23ed6b51-de75-40e8-c3dd-08d9a9f47e0a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5230:
X-Microsoft-Antispam-PRVS: <DM4PR12MB523079962C8F1E17C601D472D99A9@DM4PR12MB5230.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+jCZ7VWEThQsBcuPjIcdec22epHPyWdeCmjXBzyw4aprNdo7sUkLmaFkYaunC7HNT9pvJQsvmOFVsWxXc90ibvM8joW7xtdc8hfik3UI68e54FCnU/WDfg+/IW89Yvkn5vEw4fuMdbKtYutcwnJMOol8HUSQvrW2YM3RpNImm7o0ygA6mg3C8tLStw1Tn5NWffvpG54ti2q/G9kBuzS6IRmedbEAEwDQwtR+/wLbub8lUentdK5AXV3oLzS+/ooTfiQCDi1CUrWostbomtfZ76NgIqS9Eg2YZS30rwn0q82QBsHsG8+wplE6p6lpHYtbiuzj5Gs+bWNGbIbLbuPkeKWAxv+Wns223yuh0/ZRPcV93yZMx1TxwjdojCxPmw6srSKre0LZJQDREztBGbiPCMMxUBDg42CzBbTxG7CshjEQ6ZWMDlyitCmiToeLQoJxDKQ+C6SjVxHZyny7+uEi20lyHsvASfVSefI7CjUNJPuZKrMES8QbJ/zrQ0t81Sglu8XsZ8HalKMgZLUb1Zyjf7YivkUTBM/V98vH1P96bbAnDgK1QDu8ER4Mv/SaF6RJtm6fACfnHlZy5HInzlSAchSunlMswcvzOuyYF+TBheY525u0wYnN5qoNJLc4+u6mzVG7Lb8f7Y7Gr0Rb2uJXDaakXO9lWOnD3v8JNB931XsBQBdoHFJjdR3y7agBt8nLSghy/eti8l3h1H9Mmo0CxmYyyVp2zzE9yvFrUjPn97td8P58z1XVKBSFNOEavz5VIzE7nqq/O+ORHmAAHMKoxDyOEhp18m1D6tc5XDlHdunZiojUXCH9Aw/WAFwpfmftaSUyhtroNP/LwI/o1dLa4owZSpsj3LOqWCgiEAF94gudyy1G7vM+ypgArWw5W+4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(53546011)(36756003)(6666004)(4326008)(966005)(31696002)(38100700002)(2906002)(86362001)(66476007)(7416002)(66946007)(186003)(8936002)(66556008)(8676002)(6486002)(508600001)(316002)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXRSWVMxak8yVk4rS0YyZVZtc203WElNaDVYbm9vQllHWmpUUUFZK3lieVNJ?=
 =?utf-8?B?Y3J1TkttK1lpQlRqOXJoNEw2Q1p0RktmOUZKV1E3SjFOVlAvdU40Z3hPUk9x?=
 =?utf-8?B?ZmIxaUpIMTAzM0RiQU1hbjFxRjV5L2swWTFJRmtKZWdDOHkxWE9mSzZjMjN4?=
 =?utf-8?B?Y2dNT1Qzc3V5c0kxb0s0R0ZHRmEyZDRaM3laOXJUYWpZVGdOZ3U3YzVjQ0wx?=
 =?utf-8?B?TVBKK2NqM3NBaitDSWtPeHdTaktMSHZTWlMzZ3J3cEFSOG1WN0ZxZEJkdDZm?=
 =?utf-8?B?eGQyQ0g2OVh6cFBDb1Bud3BjMzN4QTBzWklFei8xVlZwNkpBT0hyRVd3M3Vl?=
 =?utf-8?B?MkxWSm1UdDNVamNXbWlnRTg2TzY4bGNkcStQS2Z2SFVDU3RtZ2FxK0xJVWxz?=
 =?utf-8?B?R2VmbldQVm1CVlBjalNtazdqc1hjcFF1a1dSVUdxNnlVREl5Y00wRFdBRXBJ?=
 =?utf-8?B?OFVWRVBhenJUWE5RN3RYb3RkamNrYU5xK3QxZE5KQk1TWHFqZUs3czNZK1h1?=
 =?utf-8?B?djl6ekRRK1NyMTdOeFpETDZ2TldWclVockNQc1BUd0pCdTdhamd4Q3dkb202?=
 =?utf-8?B?Z0wreVRXejNFTmNKS21zMXBaSHVpb3dzcVFtREVnd0E2eXBzQTdabWtnR21Q?=
 =?utf-8?B?NTk5VjkrbWhMRFIzZzBJUnpINHR0cUZvaEhMTDRPMFh1MHQ1OVZJT0hDc2Mw?=
 =?utf-8?B?MDdSNEJVSmdjU0U5czkzZ0JLcjJWejlISEl0NlhieXNGa00xdXF5RHI2SHFk?=
 =?utf-8?B?V3JzYUFUc0FmUmcyYUZSVFptdGxFdCtrVENWTFdDdkZwZi9sVkpkMkRxTm9L?=
 =?utf-8?B?aTdNOVRsa0xsbG5QZXFGQ2tjNEhzYnJDN0VaK3gzRTF6Nmtaem14YVJKd2Fo?=
 =?utf-8?B?ZmtGZ2NPbTFWT3U3QWtmWTQyLytXRi9jaGhUQ2FlWDBqdWt6U1dDSCtWaVY4?=
 =?utf-8?B?THJRSFFSc3o2T3pnWVA3TXNqZ1MyVmZVSDJmeks2aDlUZ0hWT2IwM2dRN01W?=
 =?utf-8?B?UG5HUnJTOVZDbW5aNHhDUGJPNEE2eDA5a0EwSW4yU0c4MCtSdUtGa25xdWxh?=
 =?utf-8?B?UTZtUTNLRzBoYTJYcjRoajBta2FSSjV4aDFlU2ZoQXlTTEFzZzFOQ0VkNE8w?=
 =?utf-8?B?L1VlQkhFVmFQajNBcHphS2plb1cwdWJYNmVwcUhDc3hrVDRsNG5Kb21LT05U?=
 =?utf-8?B?MGc2R0JGeC9pNk1VQTlZUmRNZnRlZUJxNlVaR1FNWmFhSHJycEFjMDJSQnpT?=
 =?utf-8?B?Q3lDVzhlKytlVnp6L1p4bzFjOTZBMXdnaUM4cStlalN1UGZpUThVRThKa3dt?=
 =?utf-8?B?N3IvQ254NGJsZEErbGlqWnhhZExFVk1wVG9HNHFJVFEvT2lxVEFJRmsrSVd0?=
 =?utf-8?B?SE9oV0prUXYwUHpRZStRRytnbEx3bzl0azhjeTh6ZEVHdkl4MStHNjh2cnhv?=
 =?utf-8?B?QXdCRGd3WVhuNXRwemRYbXlaK1M2MTdFaFM2dFcrbVVjYWp1Q1RYQ0RxK0dj?=
 =?utf-8?B?VlBma2RtZXM0OThOdGdpUEEraHlJUGh0WU0vRGVyZmhqbUNRdzdqRjFhN2xJ?=
 =?utf-8?B?L1RxTVB2T0RtVENDR2l5SGllZ3MxaVdrSmZCZXdxUEVYL0IvcURNSXd4L2hW?=
 =?utf-8?B?RzJNMitqNHpEL2tEMXVuSWM5bWdlWGZtNUlrZW5CQmJ5Q2hjY0Nmb2Zic0dl?=
 =?utf-8?B?NkZ2TE5UcmVxUWxvUEx2czlJN3U1QVY2RlN1YW9lWFM1eXMybjVXdVBSZ3Ex?=
 =?utf-8?B?NUZLSy9MQThmUkN1cGs2ZTlsMEM3cTAwTjU4K1VIcS8wQXB4Mm5mTjIrZ25J?=
 =?utf-8?B?ejlEZjFjWUFkYUZ4dGtiOFRxVU0wL0twSTIra05JL0c5Tnc2eUhBQlgycHZk?=
 =?utf-8?B?WU1GOHF6TEpxZUh2T0FyV2xGbVYwSFFtdkZpaUtxY2pNNWRkZE5CNEdJQnNN?=
 =?utf-8?B?WWJlaGZISnRWYWhzL1MzQk45QnRaN3d3NTdFdEYzdXpxRTZGUlhmYThTY3cr?=
 =?utf-8?B?TGd6V3R4UmoxdWJDNlUrZG8yM2p4UENsOE9QdXlFQVpwdGJNM0NpZWxkYTFM?=
 =?utf-8?B?em8vTkpOM3BEb3hKMElDY3ZGRGJicmozQy9BelJ5WU9JZVc5Y2luS045R3I0?=
 =?utf-8?B?T0J1aFBaMlVSbnZvWDNHT0RwSS8yOWpFeUNlSHoxaHI2ZGY5anVpeG5BVFo5?=
 =?utf-8?B?bWJyRVhmTElEdm15UUkxQi9lUTIraHorT3JLYjhXUXJ2ek5GUEl5cHFoRngr?=
 =?utf-8?Q?cewqtaUskVfhcDSsbpgNSjP9HpozkREHXPaoigBjYI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ed6b51-de75-40e8-c3dd-08d9a9f47e0a
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 18:03:00.3854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNappUPVn5fq0NBOI2I6M8VMNXiwdXEei7+DTC10lPH3DnfkV2evbyjO+c8f9jHgPYbdPUKbp5w0krfdAy9w8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5230
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 17/11/2021 14:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 14:44:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests passing for Tegra ...

Test results for stable-v5.10:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     75 tests:	75 pass, 0 fail

Linux version:	5.10.80-rc4-g087abd07310f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
