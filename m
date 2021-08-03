Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C593DF0BF
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhHCOu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:50:28 -0400
Received: from mail-mw2nam10on2079.outbound.protection.outlook.com ([40.107.94.79]:22785
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236701AbhHCOu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 10:50:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5/nv4q2f+ET4Y6sqIDjQrfRJHtW0svgJEu14KLW8jvZulv10E9WMPVRfOb8WVW6+Kx7g6BEgHHkQCDwOg5/zdrmt5+s9UGcFwld7Rc5fsZG+bvjEXiLjyQBM2B0I8Vra+S7rm5IWgN49tq7IEoSF5kArrSRIRiqqcOTz78wkprdhw2dLhJQZOK5MaQOi1qwXmOOT8OWT7t0ssaKqB7XiyaPSX66MYT+RuC6+xzZizyfWoEglmwWOsYdCcg7EGHQFOerKQ0QS9su501kjLDUI2EnYC7qPikhadUEf0FkeWJIobzhIYc0jdM/iV3Kf6L01EakmRMwk3jKkAz1vtkLIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d32tpsklI6yzNvYR/HqAUTUyjLzQJ/zalQqa8EH0sTg=;
 b=V06/uH2jk7ol7HAfVY8t6X6YPR5+ai4Gkj/U6/qWBoVyc04aL4eusSpt9FSaxdPwGXe7qLoE3Ki10pPuSznTrVnjje7gRFkfCiSVUEISbJxwmMMMwJYWOK4fCSEQ4z1qqBd4RrmmP/iQM4sdpTCrwxcaswr3MEx6S4rUk3tL4Ihdw9oggvtONWQGHGEPUmQ4xz6FoFj5E7+0VyauwZvwX9XOREmybeH5ZOTwVWZky300Ps0hgbiPr0Gmf/MVTv4Voxapau6kZB3E6KnRxhaA425usetiSHIoUxjaGONgkPWZWKUcs1O61jmDORlGoCVUeUi9oNTqoU0xkkXPlfzI0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d32tpsklI6yzNvYR/HqAUTUyjLzQJ/zalQqa8EH0sTg=;
 b=RMDXxtVfEewporc3rM30aW0tTPpku6mfb3N6OPHS0tF1hFdSimLt4uydSbF4WItRTUsK1elvprAFOzo0ennlBbNiZh8sogIuH7/3Jov2+zeKzkImsxPreC8NIbA5tBXVnEPC6KsEveP5xPHOP3RRR5va5tslnWDaz51MuoqV/7XzPuzyqicRX+35ftknJMr4Qp01PVVIz/mCo7RfB8GfLG702BPu2zTsjxAYuaDeHzSO0QnyCqVP3hQdrGBZ9gMamyZ2iaJusRT31z8cQoraQ3onD7gRASZjNUXKZT5UOBpT4imOSK0sgvS4QhzQa8SNWuNLGQC47yautk5a9M1deg==
Received: from MWHPR18CA0042.namprd18.prod.outlook.com (2603:10b6:320:31::28)
 by BYAPR12MB2968.namprd12.prod.outlook.com (2603:10b6:a03:ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 14:50:14 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::b6) by MWHPR18CA0042.outlook.office365.com
 (2603:10b6:320:31::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:50:14 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 14:50:12 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/30] 4.19.201-rc1 review
In-Reply-To: <20210802134334.081433902@linuxfoundation.org>
References: <20210802134334.081433902@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3bd9b8c78df64985bd60caebeb81cf0e@HQMAIL101.nvidia.com>
Date:   Tue, 3 Aug 2021 14:50:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4edfa957-e675-4f5e-20aa-08d9568e0097
X-MS-TrafficTypeDiagnostic: BYAPR12MB2968:
X-Microsoft-Antispam-PRVS: <BYAPR12MB29682CD0F0D0C68A868B2E9FD9F09@BYAPR12MB2968.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MiObDtCxAY1RNwqCW98ojvDhM/r6bKVirPNOshz2pd7w4p0wNA+vhBNgIGMZOPu/ZtZ7ZUjfS/iAxUOhueplT4DDcKTzRj+ImGVQe6Dch3N1KrOS0gREmDoky2A6ffurNtCX2LDlUtGBQdLakcSaSMWtA2+aO2GRrfQwbCiZlp61T8pGZXe9J4vza8Bznb/g/WeXrDd/P82LYLRrWe/k223bYYr6hglTZf5h3fFVHihFSw3xwuGR1kr68vyNEVtPsx5osjsvztSOwJmRFND4c6Du5dxb94aP1SpPat+YPZXLsW0uJeWHtb1iZWNVji5PX/OAH4+HKcZcRrXKLkqp0pZeO2cyT9dbhlX/V01Jh5YQqkDKQdWAt/R7n5oIvW7Dzbz75etvh+iWy8ChonWyh+8YNFweqOw11l7yms5v5M+4YMNmy0lRHArKfGrTvv/XcTGe4eRToq5+CFj6sblhaEuhYtytmGeHY9otL7nEqmQ5Uuba2HUCglnV13dBlcV1zXhEaG4aYI87cAEpDIoF+JiZ3Y3wh4j8b5+NClRJrzTIMqQbwtckOHN5ZSpuX0GkxY+tSCo61XrmtI/Yl8XzXcAIE75Y5YYfyhPA0rgf7y7yKs6/EnqcEu3xDcTI97W5DuW7VSUsxICWRSCVETKA4BEAzbb4mEkXQOtJWt95oHieSPfxUnhOO0az7mL0aK+9y3vGkWSPAwiM3v9Si9bJ8occ8tSa5QBuxzh/jx/CIsu6KjvAu/jEB5+FrPpBrFu3pMYPm85sxo5Bj5cym/t5JLW/WbMO55IN78UIAsJXpaU=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(46966006)(36840700001)(36906005)(2906002)(316002)(8936002)(336012)(54906003)(82310400003)(7416002)(8676002)(26005)(108616005)(47076005)(24736004)(186003)(36860700001)(478600001)(82740400003)(6916009)(7636003)(70206006)(86362001)(70586007)(426003)(356005)(966005)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:50:14.3595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4edfa957-e675-4f5e-20aa-08d9568e0097
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2968
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Aug 2021 15:44:38 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.201 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.201-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.201-rc1-g7d0b2cf6631f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
