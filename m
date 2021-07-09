Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B8D3C2817
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 19:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhGIROM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 13:14:12 -0400
Received: from mail-bn1nam07on2044.outbound.protection.outlook.com ([40.107.212.44]:52211
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229606AbhGIROL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 13:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLrMDz1X0zIn0CRbrDs9SCAdTFoP39xENKZNcVmMXew7dqQE8Tki2Ry+nU12S7uU9GWJuWSx053HQKBt2s+6Ud5YwAlFcmr0teZOGk38PKLyejhdaeL6esORwRmil/ukeHcH/KacvTrBFj0hLAAtVl5wycxhylqKmbuJJEkTTLf18VCHD4H5FUO1WrBDkPyJuBDV92C9GA+aV9ph/AyAlXpPJSODCX+P6QyZmQWF45B0CxF8yFOE1QPyoGvoLYyT0eVjuJ/BlWkSdI64G5OjZaYstIcR/n4n68yLM4dMeA4THdC5zLoHemDIKTqQC10j3pdtTlNAccLjdJfK/zJd1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRw5nLvAhVE/Gx+w55ADZ+gHwQuO2STQhP3XmCbYhiU=;
 b=GUOqanjC665VkQlj9wZfy7gDfswAc1NLGpSNd5sPMUHOmumEbKIe18VzQwFr/mKUt5eQUYyfnoa4DqqzvFl6MmxCWFMKmXDUTi7STqLvpI/KZyqW14FKQZQswYj5etusWSAlMm+17ROPbddjyVXXrTEEO0iUmI2FV7sQlCFdrkagEg7AxO35VxEoUuN8OX0BqYNAg9vz7DNxaAGHs+i/XZqH4Wv9V8rhyVZfpxLubf5ywyGJcsRWdnHqEEjiCcLyHcI5LkVRtfQiNi6LSaH/n/fvLGSMC2IGGMzeKqv2bWbQGBAV6uPdQJBqrEJnG/6VoWz/p/mJKCfPrfFPUa10Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRw5nLvAhVE/Gx+w55ADZ+gHwQuO2STQhP3XmCbYhiU=;
 b=orIn1H0Kp9KwP+uZ1PV/QBOCPsPEuEsAw3dwqbXzb7W9POtWo4n9uCmLLT7myOIWX4p82bB0mLJxVgYvQ4Rq+jlDW1EpQhZFVYYYu1Py8GbgmT0FYNr7K/hFQoVMoVLWIseac+cJIZGdP8ZmQVpINhyfmOhlFd07BD+9w5ta0QZChBeQTv9FNV9Vd6N/N3/cyBwqnEjlebaJfqEyCzWAPzP0fo7LS7wjxw+gMk2oFMq1wyXyCDuuXZ8y5wSXmuklmZGtovf/ORrLZLwu+Oc2A2HBRpWISfFYps8QAsbn1rLL6SoqWW4s1xH7q+TuJd7frXIGE/NULX71BIdiwdBiMA==
Received: from CO1PR15CA0099.namprd15.prod.outlook.com (2603:10b6:101:21::19)
 by SN6PR12MB2670.namprd12.prod.outlook.com (2603:10b6:805:6b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Fri, 9 Jul
 2021 17:11:26 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::5d) by CO1PR15CA0099.outlook.office365.com
 (2603:10b6:101:21::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 17:11:25 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 17:11:24 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 00/11] 5.12.16-rc1 review
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6dab8c8c3ea74de7ba09b1ad231510d0@HQMAIL105.nvidia.com>
Date:   Fri, 9 Jul 2021 17:11:24 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83475437-1fa7-4305-7cf3-08d942fc953d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2670:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2670312242415251653EC2A3D9189@SN6PR12MB2670.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2HBoAYPvsFHv4C4Vhmsf1tgjWXaitz5DC4j36ejrtzOGR5+BCVYlv8YcksP6qVG6O531Q6f6aD8VEWSyqrokrAsuNAvF+W0y6WrLm875CwkSN3q6JCX2SxQ39jPtXiA4Hv+JinnF3KrrWWZGw4dfNv3Z0KaZqHc9ohcuhpYC/7e/E4MFeSTcwgF3XGWD5X6MolytNwzu6cPmoFj1dR9Nt8SYUKU1rhYz/XgpAsDHnab1NUDMkKM7glMrT91s1/xr4sYAFWhpBVDr87BsiV7AybGwbyIv2F9QBqyLlD9j7FNuIi/aitLUgu2mx5sNOG5vZpzj77yRg/lfbjFELveX4czuMNwHJej/u+GtaR6am2jmk2F5yRcOIC3Pa4kFK98LWUPlE2D8+uyzHlTh58aHojq0v030WZo9sv+LLzoKi3U1SsMYqGW+qPLTsDrwIKm7M7jVSNUBxoRt04JNkSxmNjM1TEtnfpItOVwsmlLjcYrqJR7SfgQXa9n0yQQBz60xVrS+xylEGK9nxmGxnwf1yl5uUJX7XGfHDJcPddt/HzOAyZ5e4Mj09uOnRzTRiHO5M0BAta5HbY/GPmL3jubThewxsE3GQYLWgUQZVbikudWLEAhmOxoh1UJrFR+k8xT78tuqeI4riHRob5EUCwlay0s/37MmWZgoS5j5UjylNTsH/22jVwBAXv5a5sSGsmKl2I/M6kmu44sH9jxHlvEXnvld1RzfGXfbJIrQsSFQSm066CYhtyPbb1X4+Ef5MxgF7iVnqz7keUlwN210WYflcuEhG3aHwPIX0a6S7u0HX14twM1UkPdbAGAIMfHTl5X
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(46966006)(36840700001)(26005)(86362001)(186003)(8936002)(70586007)(7636003)(966005)(2906002)(70206006)(356005)(83380400001)(7416002)(8676002)(316002)(478600001)(54906003)(47076005)(336012)(36860700001)(6916009)(82740400003)(5660300002)(82310400003)(24736004)(34070700002)(108616005)(426003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 17:11:25.1663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83475437-1fa7-4305-7cf3-08d942fc953d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2670
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 09 Jul 2021 15:21:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.16 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.12.16-rc1
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7921: get rid of mcu_reset function pointer
> 
> Sean Wang <sean.wang@mediatek.com>
>     mt76: mt7921: abort uncompleted scan by wifi reset
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7921: add wifi reset support
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: dma: export mt76_dma_rx_cleanup routine
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: dma: introduce mt76_dma_queue_reset routine
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7921: introduce __mt7921_start utility routine
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7921: introduce mt7921_run_firmware utility routine.
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7921: check mcu returned values in mt7921_start
> 
> Sid Manning <sidneym@codeaurora.org>
>     Hexagon: change jumps to must-extend in futex_atomic_*
> 
> Sid Manning <sidneym@codeaurora.org>
>     Hexagon: add target builtins to kernel
> 
> Sid Manning <sidneym@codeaurora.org>
>     Hexagon: fix build errors
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                                           |   4 +-
>  arch/hexagon/Makefile                              |   6 +-
>  arch/hexagon/include/asm/futex.h                   |   4 +-
>  arch/hexagon/include/asm/timex.h                   |   3 +-
>  arch/hexagon/kernel/hexagon_ksyms.c                |   8 +-
>  arch/hexagon/kernel/ptrace.c                       |   4 +-
>  arch/hexagon/lib/Makefile                          |   3 +-
>  arch/hexagon/lib/divsi3.S                          |  67 +++++++
>  arch/hexagon/lib/memcpy_likely_aligned.S           |  56 ++++++
>  arch/hexagon/lib/modsi3.S                          |  46 +++++
>  arch/hexagon/lib/udivsi3.S                         |  38 ++++
>  arch/hexagon/lib/umodsi3.S                         |  36 ++++
>  drivers/net/wireless/mediatek/mt76/dma.c           |  47 +++--
>  drivers/net/wireless/mediatek/mt76/mt76.h          |   8 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   3 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 209 +++++++++++++++------
>  drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  38 ++--
>  drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  36 ++--
>  drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   6 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |   4 +
>  20 files changed, 508 insertions(+), 118 deletions(-)
> 
> 
> 

All tests passing for Tegra ...

Test results for stable-v5.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.16-rc1-g45d72f8b4c4f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
