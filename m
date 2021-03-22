Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278C534476B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCVOfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:35:25 -0400
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:11488
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229771AbhCVOfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 10:35:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPDVyQTC6WKNOe0hUvGDGnqoudBBjXHoJsZrRU7p1UHDSbmwH6hmkHNcUlPIz3uII+rwmEKEkgy0KEOntIkXLtildqO5nPHeMenX3CGE/wpsOrTfptBSdTgHQYxdcq/WUD27ONMP49/9DKMjCzXI1QFHATm5oIOKYWeqknZRw1+yNoqxVMvprcS8x0m5ee2eqOcbid4F7qcGjTt7bh0NNyC5/oomMueiRRaY0aD6ct9TeW8taFPcxYGAWXk0TjRjqTAqCqjl4k6easOmXTxCYXE3sXeIQ+UH9F2HoBeJb4KwJMZcRw+DKFqEGuWPRyitcqeKC279ZJm4BTRGDtzaCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRMpIar1DCXpwGLR2OIfI0y104eF9i6gE+RQbxcrOQI=;
 b=XW0SGBwxoZhPKCpLon/xzmweNeAOAurTDxNH4am5PdzuQSlvakrXizqcZPZ383xIACqdAfN47rogJv83K7Y2ebKR5yYWv5dnLDQr297D/KpycAqG04HV35nm3nqW9GHFcUUQQKYq2uPRJxeZafGYSRPj/yh/kPDYHAk/IYsD/QFA2UR1IFVqr7s7eLrajKKdjE4H0ZSNkItmxdf1G+4FM+6ayyw8EXc1L5CFBSt3BysxZe/gaq344T0uS3kggK0mbKjaYWvVO3CJ7K8ZH6QfLiMPF0TOpmpYMh7FMg8+VxTJtdDajfuxISt5JOh51Wpw5Fb6qNyLxCVqEDLKeiUfvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRMpIar1DCXpwGLR2OIfI0y104eF9i6gE+RQbxcrOQI=;
 b=be9yWE1DXSJ4odbGiTJg7gjNyuESs+8Rmj8KvgjdzBJi428NqVzoTdAO9bNKMG/z9TwopWnKYEfTiU4QsxfXxvjxlW+kD+8CYI0nXJP8nwbSDnjNjAOeh66r/AACZlqQg9pX1EgbUdBu3bckY2CpuVvLjAl27IpgcajDrKznmFYVS2tpBCdbIsbmbECpXprcnbF604plr44mLzQX442iJBQiPiErNjmOnaMX/Wlpj/xShLo9/l41uVEqgr3PIh9whbZWjepG9bPOTEqLaP558fNlI5gwrmO/yvYWe0HfmHAT6uIGvuZyZH9tiPpNlkPUBoTu/nbAWC2+jOctV1FHFg==
Received: from BN6PR1101CA0015.namprd11.prod.outlook.com
 (2603:10b6:405:4a::25) by MN2PR12MB4064.namprd12.prod.outlook.com
 (2603:10b6:208:1d3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 14:35:16 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::6f) by BN6PR1101CA0015.outlook.office365.com
 (2603:10b6:405:4a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 14:35:16 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 14:35:15 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 07:35:15 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/60] 5.4.108-rc1 review
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <bafb376648464917ab3922633e155767@HQMAIL109.nvidia.com>
Date:   Mon, 22 Mar 2021 07:35:15 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbfd4249-5ea2-4279-8052-08d8ed3fb5df
X-MS-TrafficTypeDiagnostic: MN2PR12MB4064:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4064D7900CBADEAB0BA2C48CD9659@MN2PR12MB4064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a/EPLDgAjUPcpaOT/IbLJnuKiVKAoFeTc4PZJfL1M+pCg49uClMXniDqUE9eAZNToqw4Iw+DLx/C4ZoWbdlxU3kzt15Z3nwzq9UbKY/o9gWNLSKCqGLePkn9OB4pyuHdMgcL/P8/cvOUTGtNR5f36wJEq5ClSjfESkQrFbRmDeslfHc1eibhPew0Hz0Xjq36xuNOHecHiEjFl+HBhket3Vq3QteJPAxjKJI+mA8AX+kTMIrJ/as6Pv37EemkbIO0DxrlidtCpHcldlsOfvzrsPxMCJ/Np4Wdx+gQNzRHgRXxESEcUcnrv3xzekaMU39PwffCbuWedAnFtJujNTucgfuRPSMPv1SpmjR8SYYx+HW3+6DyhzF4RujfWLM8w9kELdi/OG/UAozuggdDMuAGusG2cezUG7wydGAGbLk+U5CJVFZmOMEsah34frRluPEu2TRyD+KToC94hHztZB9DiuBBAX1GzEVaEOhICx/5b0kKJHYdWub1dKFZgfGpq4F0Bq+P24Fi7wa8MUcnKZzGIbr/9rjEiZKz2w/6hliUi5hg2yixHFwg6v98TSKo45D/ZzKLiM1mL5d/QXJssPitb1RJx1YrLFrwKjkOLdKEDo9H2iA4NjzbCPbmlBB0S612hmqJ+S1vIflBOhh5mj8qAV6iGvixdKfwTsri63n2EznyLLpPxZqgDXeBvkyFJGCF+Cqn29/59QZGLOqfDZkR0CUlsZy674UBQu5JH+mNxbo=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(36840700001)(46966006)(426003)(24736004)(82740400003)(108616005)(47076005)(70206006)(316002)(36860700001)(70586007)(82310400003)(2906002)(478600001)(356005)(86362001)(5660300002)(7416002)(4326008)(8936002)(186003)(7636003)(54906003)(36906005)(966005)(26005)(8676002)(6916009)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 14:35:16.1452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbfd4249-5ea2-4279-8052-08d8ed3fb5df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4064
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 13:27:48 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.108 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    66 tests:	66 pass, 0 fail

Linux version:	5.4.108-rc1-g5094cb203da7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
