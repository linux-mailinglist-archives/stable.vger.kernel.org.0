Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B881B38FCBB
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhEYI2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:28:38 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:18080
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231504AbhEYI2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:28:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWiMaBrvKN5QSYBR5iKSpy6h6ZV9SSTHkZXfNe3rCTG9rSLmSo0z2ChqCmKeVVubek3hrAjKaN4rhCSIG0yyIV5l7xH0MwqzmswZwoWd8DJC5zipcYoM7Azxqrr7GAt+sXJYnUZicda/08n2Mjkh5LXjN0lTI507Hby7iiF25nFRLEo8m5yncGxB4wTG03TaAnQO06ioN2E941Oqabjn8r2uW3CG6nWdYO0sE54x/E1+A/zgZops6ADd7fdqsuAv3FUXVT/vt5UOZwKCewMjAQL6pnnoBqMuX//olkgpX7wMzBlqBeMubrDnKMU2sOwN3MRe59pBDP2JZwnjZdeuLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoaD6oUM6eO3wdxXcg22NQ2KI19bREEQKtgdpQYm5PA=;
 b=Kp3cGBHWmiSzzHzTAk0H11ySLT0fBktoXbiY5mmhZQiEoEJbaiX6J9I6u9FHGWdAEviZnGTD6JNWl/WtnICpeN60xxiQax9ysrFkU8PslhXBAnj663c1U+4ah7D2Y2r8YvbC2Onyj47u/KuTFI3gPNh9qMRuIlwD4dvPvGyX0LjvqoO4pmRgM5ChJaZe1JKz6hk3d13Q/FUmJvpOcDbmA1qOIYEmi3fXnCAp48Y5pJrwHMVlNmL+iZ3p2wcVjKXV964qS7R0r1LnncgmtRbocnjJVFsD28bSdVq9G/sDzaoKOBkl3q4SIQ87JsbNX4JvYb5uVuCaNmJROPc20D7cmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoaD6oUM6eO3wdxXcg22NQ2KI19bREEQKtgdpQYm5PA=;
 b=ta6k7OeaL7BrFslBzSAmXUF3YEjs3UvT2NKdeHJ683SDW1W60GiA3iDzJVM5ahHwv8tWoqe1TOpWTCP97v+uh5kxX/9WukL1T6z6W89R+GxOY66zqHSAcIvG/URHxgo2tWRWsFj8JwJGpBno4/F3bGUTLjEqd9ypmRPscPmjMgVFiDimCl9efU1uVod8RMGospPNbmMKFQJ3+bzjznPgKo0DcVvU8Hzc8J40Th+QHHUhB0WtKi7GqkHvsqomJ0O5rnzF0UEI9mHV5MwTJmR+3qpvpShuFcpX7w9HdO/Qev3u8h6GNwmQR689wIwbaexQbMvpxhbdAeHPMXPv51xFAA==
Received: from MWHPR12CA0035.namprd12.prod.outlook.com (2603:10b6:301:2::21)
 by BL0PR12MB2563.namprd12.prod.outlook.com (2603:10b6:207:4b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Tue, 25 May
 2021 08:27:06 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:2:cafe::4) by MWHPR12CA0035.outlook.office365.com
 (2603:10b6:301:2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Tue, 25 May 2021 08:27:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 08:27:05 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:27:04 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 01:27:04 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/31] 4.4.270-rc1 review
In-Reply-To: <20210524152322.919918360@linuxfoundation.org>
References: <20210524152322.919918360@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <26f1705c8df24f708fae97051bd352b5@HQMAIL109.nvidia.com>
Date:   Tue, 25 May 2021 01:27:04 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14ddb8cc-96cc-4f63-0099-08d91f56e115
X-MS-TrafficTypeDiagnostic: BL0PR12MB2563:
X-Microsoft-Antispam-PRVS: <BL0PR12MB25636940E99FFB89EBEC465AD9259@BL0PR12MB2563.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y7i/5CZKlow1cq5dPNA59+pCdqD8dY2UO8G4I+JesZJBpCA34wio13s6wpHq/EuSJwDlxUX1xP4XtJhTK5mgYmwyZVduS8Uyef9j8dlHBYkTKYF7zhDOR0njV59OCrc9asD1BahmfuRa1c+0AKqFNMXTg0Rar9Z6xpSDlQsvWsQGFA8WB4FJMlXoWppy8rGae6ErtWdGmLzZr5W/5SUf28IAVI2WmJubylUChpoquNna4tQq2H3+0T2OTI/Muvkhe1lWBoq/Ybsx2d1AD2pkpDlPNMU42dZ13qXq6lMXm1GhvX1oWFtlVUKKrneJyUjMU1OnhDtY7TKIPCNYD28lr7SRJ9X20cipq9bvlyGy4GyJQCHuZIyMoQexZisuoz0PqI/BPfu7BEgMFd+jYqfqv6oAnAmzOBquF/kqM5v3D8qfPlYAcfS8ypA/5/ZtsBs5Ze2O9wREbduVvmk8q+HWT5CvLeELjsuKkg4yGBNRIupeYW7sMbaFttP4Met1yeDvIZ2+k4NBQTUjIibWEbcX4cSa8UnhNxiowkxj6E/WKuOxSmNkE+dSuRqG1MpNp3jscSygElzBirlwKvPAb8GeMsn4q25a2YtSBj7RmCsrnslTrbglgchMhtgSEChj2lJ7tDHFN15mkZR7NZL8K5zmbASDuJqmlMAine49n3FmNoVxb+j0glaOyxyuNMpVsFFcioin+UfT4YLCqdBpKNYBbXh2NoNYEyhcmivwgn35LsDqrasNRQFNzY69FWD1kp4BYxX8Y5RlyO2zwDOURn69yQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(36840700001)(46966006)(70206006)(7636003)(478600001)(336012)(966005)(2906002)(47076005)(70586007)(426003)(86362001)(5660300002)(186003)(24736004)(316002)(54906003)(6916009)(36860700001)(8676002)(36906005)(7416002)(26005)(108616005)(8936002)(82740400003)(356005)(4326008)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 08:27:05.1775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ddb8cc-96cc-4f63-0099-08d91f56e115
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2563
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 17:24:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.270 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.270-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.270-rc1-gc86cdd4a598c
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
