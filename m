Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE4737003D
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhD3SMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 14:12:13 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:20896
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230329AbhD3SML (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 14:12:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wz9DKr4zw+STncQwVQDqotztrrg/YVBz7DQUg42IyAey2XW9HqzNvh8CygyIQlEMyqu3EidoC81fF5ochaKlzsVgqVWAqo1I/xGjbfD7fPsHY9NJwjF7azQGnh9d9kiw0SdgluM0kwyI2H3kj3C9dUhv1RuOzZVG6WLeqN4YGEIZiNZbEXyRVZDmn5CANwXOxbj2BW0yMC13x7sLFH8nSQtKIvW0lMJHQk/Kkam5+ILKddlWVZ0C6hng6gXQIGhXRgRTChR23jRdnp2TJgEHtWVCOiZZ8LmSpUkFfKaHVmIxvIRDgOQ77s2tpV6kZFCf5axyIplVVpEBv13WSIswnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QdxFmcYw9jCLYGtM2212tczUjZUbtu9D7gzwZzjqhQk=;
 b=SVdjQpX3MVHGaOJ1uqvAWuB0HznLlX/6w8ewc3fbWl0XdpD6EmhWnGdQqxQHam0HZ+jXCZ3AeiMCAxgwwj6cJf1MN19lGT2s+U3xGZysESVTJoO8/tJYQeio4NneImHLqGgBPvjLtTQaWTyFSBrkPe3QAkh5FpQ8c1y4iJ3V1a+cX4TXhiGOfMmjHRyxaWeNqVuMQIV5vLZZDTmcSgTsEjfWcT42CCzRfCwg1PEVqsE8QUuC9OHBWuz+/ngfBLqj+YclGbLe3mMj8kPBrRQfRI995qjjSXDJVAJbMYK917W+fi1+ZB78T46uXr488D2Gx4kZqw25Gb4zbyC4Zphulw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QdxFmcYw9jCLYGtM2212tczUjZUbtu9D7gzwZzjqhQk=;
 b=fF+qyaC7FvzR8oxfPF6DCt+ZxHrl+d2aUvJGBgG3BOEEaeEZxUegwaB0PZAu2nYBXf82rDH2jqBwXVCSZtQtSgO5MobL6xg/bsQMZSMZZIk9FV3D1aQEdsatL6dNigjaFp8wsfZuQTThMjVIWtTZTcNt/E2y+AFkH5zFhh5Lyhbici06gz/vEE4rponsSQY+adyDYZ3z99hIHQ3llbPdo7wjfRrAFWU5Hx4swtZh5+Kw1Zfoq/wdsD8Ihi7GUBrLS9v1plXUJBpMmbkfdI58yFY6rGFToKz9bVx9YXk7E9NoVTKgMObM1sRQT2PMiVPZMSUbLrCm/Ft5HpCIC4TQNA==
Received: from BN9PR03CA0337.namprd03.prod.outlook.com (2603:10b6:408:f6::12)
 by BY5PR12MB3666.namprd12.prod.outlook.com (2603:10b6:a03:1a4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 30 Apr
 2021 18:11:21 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::e7) by BN9PR03CA0337.outlook.office365.com
 (2603:10b6:408:f6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Fri, 30 Apr 2021 18:11:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 18:11:19 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Apr
 2021 18:11:03 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Apr
 2021 18:11:03 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 30 Apr 2021 18:11:03 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 0/2] 5.10.34-rc1 review
In-Reply-To: <20210430141910.473289618@linuxfoundation.org>
References: <20210430141910.473289618@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <65e30b5d26f344baa65b953c37b38177@HQMAIL107.nvidia.com>
Date:   Fri, 30 Apr 2021 18:11:03 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 712cbc74-b0e2-4d73-d902-08d90c035afb
X-MS-TrafficTypeDiagnostic: BY5PR12MB3666:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3666729D967C72129C3A1839D95E9@BY5PR12MB3666.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xnr/Sj3jJCI0KuT7CtmffvsioOMSKfFIRITe7a0EjTQ1D3W6ClNImLiihdVm61/bYeXjTdpo/4byX5Jdrws0f2YE7ZcYkvSlrPzs4yoG+2sw2eLxSIAEf+/fWa8sTvCpnJgiL/D5USDnFqW/9Rwo+B6hqHJR7jKGQLWPyN5LXUzDZ5xC3WF+X335omiWDCVU49VAPdEmix+YHVJWIYziqnOpG0sQ5D1UauB1QCw8kCBRyfast2DE0kT4UMN99UQxJIbvUdWzZk4hyeQNaMfkPAETZY+7xBteP769LIlvZdj9jmpkEB+xq7FJWSECVs9UVMJ5YV5hdN0G8cYwmbgAAt6BJaLfJToAqndr0Ebmmalxo1U93m5g2HJGyny6He8wQ3D2ryb7RfECrgNyVlMGGzx/x/SXN/1R+oRekYcJ3CuXf7BGlInvzOU/FL+03pHUUaeUakH8Gjh+K85pDB7SsymUqD+UdLcR32+pcX1tTHbdl47NwiVh1dX+nlERTiycUIXDQk8C17Ecz5DDyPJRNn7IrobLz18cTPPl4uafioE2zzY8wl8GfkioMuDqdMnmD/FGOTcLtnRVW7lBmxMhoItMZw1fRVWSGvlOJSdV8alxAmgn0tWdvNbZtr+xiMojc1mgDH3v41d1/mCIEeaPzom6DBSV17u11furtdTEbYE4uAjbhh/7gilYc5/ZBA10BmltBGdsaDa0S/2Qn2zqBGHBn9/up3dkFSj6DDEFWek=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(36840700001)(8676002)(24736004)(108616005)(356005)(316002)(7636003)(82310400003)(47076005)(4326008)(8936002)(54906003)(426003)(36906005)(70206006)(6916009)(478600001)(966005)(2906002)(86362001)(336012)(5660300002)(7416002)(70586007)(186003)(82740400003)(36860700001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 18:11:19.8596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 712cbc74-b0e2-4d73-d902-08d90c035afb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3666
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Apr 2021 16:20:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.34 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.34-rc1-g9fe3189f108d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
