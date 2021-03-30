Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8934E485
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 11:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhC3JfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 05:35:13 -0400
Received: from mail-dm6nam08on2042.outbound.protection.outlook.com ([40.107.102.42]:51009
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231789AbhC3JfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 05:35:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/XF6SPkbieIASzcs5uLTSwV8bdaLre7+gRY1ExIbZ1qpzaG0SzEVy5+3aLCCOxwGdAiIaKs5rzxA4Au2a4PYG+TDmn0rcgZdr9fw19DIHazVsenBy/M+U2b9BIVb3d3t5TsQmw+rQuqPYXbP9lWu9gwQ0kaRC47HEjELJcD/9g4NQQ2DsVb3IXwB+sI47Mg1jl9jl2OboYeRZHLISjDii8vzgigPVvI5pLjk3KPY8CMhmLHxGMa0bF480Nqx4mk2GsyMumtAU+eYU5nBT5bMkzLeY/DC6zR8OTlRcZokGqNm8fdkY0TDPKOlNgwaXWcsikAhVWsyqy6R6Kzq8Qaiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5CGJYUSRnBbGgqCqhNtaqFPdu2yYuMidwFwYUzsrOo=;
 b=nW0PkQ/C+LNEdh9sO5i1f2gHpwmFguixSqKH9GBLBCPW8ExmtaB/Z9HFS622TGwc9AK50YUmuoRhKruAO4ymRzvDaA9qIi6Nsc8xiulP6FUvslZMk5iUHfo2nuTg6CGpeR3qM1z8dbDeLzB6u3wqgCbYQWKzrqTGH8dZ/PI3v09gabsSExD4I2OVYgm6p3oPTHFZDJsKWD6eSDyYJHEBME/Lmf0wp1cbhMBBjiFBRukpy4A25XxyGfllcdVkhsBGHyGIl/z0W5gx3B4vy9LnYu2y8Safew9T02+bsKKQyYyZqvXLWnrvoLHvBpnKw962rXO21SzJuHGrrS2HCrhOCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5CGJYUSRnBbGgqCqhNtaqFPdu2yYuMidwFwYUzsrOo=;
 b=CfJZprmcPMnnqk2wy03+/KWD1rBophN018P+Xbp2KWqm2ChyjY3vAAWrEcmJz5kMyHdWhO4wpX5NIBHzNyI9zDTfhp+fvzFMy8ZSM5AKVpXS0a1eo83q3K375Bvrikzfe8DBGbdFJdTEO/naiadWr00dynsS8eoW7gjeiTHY5ris4mJvFypuSahhbo2B7lLvNKADhfDhTEsQzDtxPh1Ig7Gb71bB1W56bJrtkSt49Qy/Mfmx7gv6hQNL44PpjF9RJ2Yj07QoTD5QysjqVtsXW8p18DTUlxa26KePBRK/GBNEDt6WG3ms/tDzJ8pbT3N7VhnJasJkolX1vVGD9PDP5Q==
Received: from DM3PR08CA0022.namprd08.prod.outlook.com (2603:10b6:0:52::32) by
 DM5PR12MB1546.namprd12.prod.outlook.com (2603:10b6:4:8::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.29; Tue, 30 Mar 2021 09:35:05 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:52:cafe::7d) by DM3PR08CA0022.outlook.office365.com
 (2603:10b6:0:52::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Tue, 30 Mar 2021 09:35:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 09:35:03 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 09:35:01 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 30 Mar 2021 02:35:00 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/59] 4.14.228-rc1 review
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <591dcad5e5f7438b94c3a3b7b28556be@HQMAIL109.nvidia.com>
Date:   Tue, 30 Mar 2021 02:35:00 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca4c6fa7-8038-4bba-8fd8-08d8f35f18bd
X-MS-TrafficTypeDiagnostic: DM5PR12MB1546:
X-Microsoft-Antispam-PRVS: <DM5PR12MB15462545A415E7A45AFC8AE6D97D9@DM5PR12MB1546.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PcjDxLsoe7tlug8Y8wMeN0utM/4UOkhbZpKZ7AAArebXaJxG5mITCpVpici7pWfat4fRsqvL1kJg7xmBsbgDGW+ONH9hT/1UvtO7zeUS+ehfPVEAQ4fX1ycjurZpRXjmEqpQVVgdpZzOTiVVOiRmxa6cN4gasrymEkPPxvm4uzGC6oXZ6k6P5pQ008UpvZ3me0Db/b3ViugeIUlQg+6PN8++qPsXUVC6KUgmuxUfqyc/ho0WI5+wZr0kUwbEC/OGLQjwnLlNwMe9wS0hkg8RzAvbaIdQBesIGoB6bvVJcs2rF8gVEoi51sVo0LHut0RVcAXzwkhbB5hnLC8FPL/WPlQmbHraVf/gy6muCKC20Pu/BP6vPMmGX0wv6eSbNcYuTHCutTomSNtCAuQBIaZPaPE5AFDGeBeXSBVz5cwMDXcHvuiAam2xMoRJuVVu/LPy/E7cmOkxyf0KBE7Z3jWDuH1vcSnwi4x7/XESoa5V+5U08C3dG2cRhoND7xs1PaP8dAD/+f24/kzujRjtYAcV2vzv2Itt3+O927L1MraHeHCUmywFL4Gl5n9xgK8jAISHRsPvBbIlGe2iJ34cmY6Obk1B3elL6fNJ8kd2UmLn9w1IRwc7t/6E1xPP8IKpApWA246wlAdRkHVM2mPhERWClrgmRFESmd0IJgJNC19v9aJzsC7spV6IDcimGbUrncTVCyHwhTCxtv1B8DL3WiIcB3FTfOEV3/k3yK4IwvR2ckw=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(36840700001)(46966006)(336012)(6916009)(26005)(186003)(47076005)(8936002)(82310400003)(7636003)(7416002)(2906002)(70206006)(356005)(316002)(82740400003)(8676002)(426003)(478600001)(5660300002)(36906005)(36860700001)(86362001)(4326008)(24736004)(966005)(54906003)(108616005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 09:35:03.4334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4c6fa7-8038-4bba-8fd8-08d8f35f18bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1546
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 09:57:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.228 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.228-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.228-rc1-g4cee23773c6e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
