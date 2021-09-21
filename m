Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D446413400
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhIUN02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:26:28 -0400
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:13248
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231658AbhIUN01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 09:26:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evkkSfIpSBKSsuHzThfbFfj9IutXNsiCyRfEGgldqup3vLkBTIxRvU9Z5jkcqxl7dRdPl087rynlwyIogfU1LwHclmA7jnZrvSCmW89uWn5q0zNIL7wlFz7dfhbJv+fSHDp7sDs8G++Ycq/xzt7dc++6VHP4MruwdWmIXn9UL8Vaze8LlFzi0bQvL+rkFj0TuKDnt89tiIn3Nuw2ao+K8WP6a3QOvDfBJ4oVkiF0+r0RTu9nOV2jGOU32YUyI3AyE/AIfrvPrZajYM8e6oHTDfOEeBrTNnCjSB73e1jNS7z80S78fkUpZCwK5E220qkS0csubV9SEjyikJmfXE59lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=M7oAqGaak4nBraZCBTI6l13pZTZiIl2huw0LLDiNzuU=;
 b=eVM8zK1gOWRwn/7vQG0GAtfgSFgYwPuAnCa3kiGAvkQd9LjYOvi5+s6jzj8h6ngqk7q6XWMjncqnlcBecSQJyc7wxXZRPv+mBM1eh0lCsEQfGlJ8oNUkYL24oN80eukYdOvYQmflkP+YUWATeKgzA+YSZJxYszUzSPt3mP3g6SymMeyfhnc6YBXFrUwJkyOu0h17Rxs+EQq2lyIRarac2A84UiW7K+PcvaLf7vq7U+hXqgxgmUqsMFGWCI6h0cQrkWR/Va1gYGUhWmL6d7Nrim7AaB1ANSeHm7jrd7+oNSLBan5KEm/8S1sU9HICKGJUO02LPwfYpFo1q5C8a4d0Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7oAqGaak4nBraZCBTI6l13pZTZiIl2huw0LLDiNzuU=;
 b=j34JHECnsKcEnBCR8+UhX8Faih0OGdTrWUA1tIsoSOkemnIseW71I7aop3ho77SyewRKyG+3wWnhdupdMAT56d8FaDilQFsko6UygW6e6zuKEStGi0odIv21HOaOccauqk/Un68TDMzsyk+b5hp4V9jzq2dKMVNx1c6X0iBP18lvojUmms+7y6qYm+H8sX0QyCe+J5dIwFZARydASclCiq68Xg6Ym1d5oCj3NZSjLBhmvPATmm77tufoQ7/1sdiFpJQLBLP3PBU4xPuvjEMnmlc1QNQKIumKTiQWkZ+Bj99Oz/AaKJ0pSMJLgy/RTTgpuNwWF6Cjx6X0IZOXqwhqpQ==
Received: from DM5PR15CA0048.namprd15.prod.outlook.com (2603:10b6:4:4b::34) by
 BL1PR12MB5272.namprd12.prod.outlook.com (2603:10b6:208:319::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 13:24:57 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::ef) by DM5PR15CA0048.outlook.office365.com
 (2603:10b6:4:4b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Tue, 21 Sep 2021 13:24:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 13:24:57 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Sep
 2021 13:24:57 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 21 Sep 2021 13:24:56 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/133] 4.4.284-rc1 review
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <bd563e82c2a84fbc987164fbcc1ac0e5@HQMAIL111.nvidia.com>
Date:   Tue, 21 Sep 2021 13:24:56 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32c1f391-4361-41bb-3df5-08d97d0334dd
X-MS-TrafficTypeDiagnostic: BL1PR12MB5272:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52725621617636D28C469CDFD9A19@BL1PR12MB5272.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /jVkTVwatvGphh8JDmEsfxgPNEHLOX0nUw5900dWKwOpW0SCrfM+SohFuCM2RHIz0e7sHQ+XtkylAqaM6DBuB3PpuPN2dAPfG8RW5rOYe9DohgVuhodjOl0iAZCR2EGjqSrwBl1vJ0xIBKbCLFts0xIiJh8MfeZP85MhnTXjGQ4i+BEm2bEjlJl71I91jz/HNNJnorRlSxqSoFWvG7OnMq9rxutyT9/KYJKHiE8E1kB6YFLPN5txbnZcOi7TO2hjrbe4RiqPJhJZ8eEsXnEoArabBGt/6vcJGUqveQd7Mt520UgpncIF+Cvs1u4v757NUAPNTfm5mBNxmQrgthjJFu21ICKgU9ltkziW4OgG3BZf/fDGrdqwuoBvh3nLN8z53o1Cklr9ISwMj2gO0a6yf5NgZODc591uwzQKX/ilj1aFNnKzF1NcpfmR4JVV/5l1rPCHVZebrCFUOpZ2Z7No1GMoFMesUOMvwervyZE/JDcBIOWylUPztnQ3KH9ZzKJIgltTT83MBO06DRCZYttk2wssAqUFyx6hgYxyHaNgpSG0Jc6s5WL1kOqry4syzcY4fq4r6Zro8ZiMOHsHxdGvRfNPY67TxPcHfU2MVHdT0/Wk0MaJZUB3Vi4mOvAUPgOafKjYLjz+SmzwUuhZRMp8/z4jZP7GWmeNi1r1cK47jn/2H+hVzWJBSfKi7gdTZ5KT14omjbat2WNDW4I7OmsM/9uIxp1sdvPqggWyH6U6GoAXBR+6yfUnEAhJK8MVB7jDHWg3e52WqNU90d4KVqICqgzfJTB3j8zoFqJPhPu643k=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(108616005)(82310400003)(26005)(2906002)(7416002)(966005)(47076005)(36860700001)(70586007)(6916009)(36906005)(7636003)(24736004)(336012)(186003)(508600001)(316002)(4326008)(5660300002)(86362001)(426003)(54906003)(356005)(70206006)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 13:24:57.3906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c1f391-4361-41bb-3df5-08d97d0334dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5272
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 18:41:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.284 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.284-rc1.gz
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

Linux version:	4.4.284-rc1-g3e654ce9098d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
