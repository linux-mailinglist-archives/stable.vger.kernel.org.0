Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F2F3C5D08
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhGLNRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:17:31 -0400
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:13857
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229479AbhGLNRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 09:17:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c77qZRZy2USH6wFJIL+/4DUO2xtUwwFsYnZRU1d4yInEb389Z4VzQGyQoYZftuD/DM++GDOLxGX69zubqe+ZhLlM67BRujMxbfk4B9IBZ5LAEUMC8D4AXCgXZq/nD3q5QtL4+Si6eS2q5t0ECQBwKTB4/GVv0H5TVsUf4VMKLOXD/gbN+M1EF4tz7baz3n3fy2QXHD73nhSxLMV6BBVDHsZl8MLKhdLDIRpoSejavV3a1q9FDh9iN9tdr/slwvlNSUPS7UMON53q2/yE9SgDnqxwdjLIL77o8IM1Eug/SaauA+dwrc1RuoWL3y3MZtOP6mzZlUED2+hiFaANn23f+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsSq3vqDEYk+yFyucvFJaPqVZ8uc+pHvDcMjaidON10=;
 b=OfYmmcYu2RcHZLyWkwx0hoMufYoTesbZ/njeMWq3CdcBFVcP0fa9NKj9KDokGRD/sWCMhxyYKODg5ruxoubVanwiiewVjY9zDqOISyh4KzwhNntoIXx8OgS3QfmwNHjPMvUMtrilrZImlq0iq+B/vwE6fl6MxDz6C61UJj5Xjd75JwR7XYkxLrg6RtVb3ZsWY9yFhrjioyALRZt6d204BMU8XpwEEodlylvQHw7hJGEAH2d8IXDEOD92HUAYTEwLYNdBIId+vE8UBc4osMi7wjlKjASZBsWvCOYR7Nzw+grW5Y8qxR5CtJJcddy1MA0jy8TRwBANCDTTgocxHaK49g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsSq3vqDEYk+yFyucvFJaPqVZ8uc+pHvDcMjaidON10=;
 b=pm1PLMh1U3iBrU9jrT+tq57NCsEKrfeyC19XRvcZG2LyaPOx8p7G3lmLblDS9XQ39xiyPztKMyNCXj0FHs7+UMHRjhiA1Q2Z8MJvV4cC9HnHL2Q8qIbHDzpAPEyTJ1w/zuuZRPSo2vk58fi2rm+5pGcMfX77Z4/eVa951p366hWUteedHvv8N66/Vae9Lgh/3Y4w9pWvd3xgxVYjy115LQ5mkx6O34z5p7Uw1QNCYJ3bFY2wCKN9SC2nYyU80/dCcPuxDkekYtRWqrTVWbcioMXJglAz+/ZtF05/KAEaHBl/n+YEBYzo0DC5WhLibEzbS6PcTuKOvxoTzBbmDkYMbw==
Received: from MWHPR22CA0068.namprd22.prod.outlook.com (2603:10b6:300:12a::30)
 by SN6PR12MB2637.namprd12.prod.outlook.com (2603:10b6:805:6b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 13:14:40 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::3) by MWHPR22CA0068.outlook.office365.com
 (2603:10b6:300:12a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Mon, 12 Jul 2021 13:14:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 13:14:39 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 13:14:38 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Jul 2021 13:14:38 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <64f7439ed2244a13ab91e618e72ff5a9@HQMAIL105.nvidia.com>
Date:   Mon, 12 Jul 2021 13:14:38 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0401cba-a378-4ea1-7dcd-08d945370165
X-MS-TrafficTypeDiagnostic: SN6PR12MB2637:
X-Microsoft-Antispam-PRVS: <SN6PR12MB26371B6A6B180BA01B37F72BD9159@SN6PR12MB2637.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1mLZX0iH+cZMv6/hE0pwpuI4RTN9O8q8nM6KleRgUVKc+ZNeKQy0fFs+0WZ9iEYJUc3uBIUEPEJd98VRrLkldqy2hSmIh8toHwmc5POrCIt5ghLfO+5qzZnh6EBx+w6WsbPHBx/wc8MBsUgbdhs6PtuZVHyoYjhPNSZ4szRPOh/RFXe8eEwm2folcH+dqx+kTlXSzUukCywMclJSydXjXT18Wqb4tguCDiVgjGoFSrgeWXXh/+QqR3qnT7b/QrtUGe8FX5qwkNdidJ/txoZtwu0B6ipZDQM10jixoFCfmEuT94zvy09hj6iWwJaSdfo/giSjy5rgi4syjJRVCDDpPilUoZHRQHSdcovCCJhLLWX6WAWBV2IzAGL7VdJG32Dp2/0/Zk0CfDjHT0Inwt65MUZq4GciIaZEsJPIcKeKgczQH5Y0YOzJ6sIauuwwtD3WksKZ6fsFDfkFkN9A4V5CEBrB7bqUs0b0tJYKoadNk5+8LGY2zko8O2hJ59sJZx5S0aUf+ZNCt58uxgLzJU5cft7D45IVAo8Jh//pQy6CTcZ1YZG9xS7HnyNKPZbQoPzLH0VSHRnjwGHJCX6FhmccEmmT/EDV1mXMNkbzO5kob8ORp1dImTYCHmIS1Etv3k73SnYTflpOoObBWstN6eiTQYmTp/0IE9ELBQYfEpWa4VnoMc3cSWMHq2ubIA7RROm1F9+f1PrG7qQYzTKsK38FYkeHSCBILaNozQ75Z+L6RPrw7v3ukjC4+6TMBsMW6g5yoTWT+dXXE7I7H6RCySdJimdXTvKTwP80GFVNwmS+/3/1rAQDXSFdpCwehNGQiP6G
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(36840700001)(46966006)(336012)(36860700001)(426003)(966005)(6916009)(478600001)(7636003)(7416002)(47076005)(186003)(34020700004)(8936002)(356005)(82740400003)(82310400003)(24736004)(26005)(86362001)(36906005)(70206006)(2906002)(54906003)(5660300002)(316002)(108616005)(70586007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 13:14:39.7532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0401cba-a378-4ea1-7dcd-08d945370165
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2637
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 08:00:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.2 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.13.2-rc1-ge75ae70be576
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
