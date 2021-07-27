Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2193D7230
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 11:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhG0JmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 05:42:24 -0400
Received: from mail-sn1anam02on2040.outbound.protection.outlook.com ([40.107.96.40]:4186
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235897AbhG0JmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 05:42:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xm0Vh6lRpg2hwiR3HtTSQ848X+X6SP+tFjONgi7ql+Zadi7M+mcOep2iYY0T1CaDZt5RobBUNQ4mg5o03iBq8h91O9a9jjgjW7LIYR5Pb+8rjOxeiW/rE/h5N9Pzr3TFLx5osq+SrvdGbnYOc4poH3KIGD5RkAbge6UUGk00WrqLhhgLu7rYUOcG638zWGgIfKk4FFaVEqGPBJq/2/vNIphFPGVTjNjiXzp/9Gq45z82aZ0aPrE1HEwT4SIsCMBmoDiQR1JBz2eMW30XcfCJZhP6KnMfgvqSoWEvUR6ehKXSz9ymohcXlQyiMWTM06AaygPscNf9FjZAKrG6raHMwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9c69FB5L5uMvqbBnI6HwFN/MT3d38S0ODzTWYS5UG7M=;
 b=adEFxP0zddfQbqh5ft8Qjf25djV7GcFop5ArhUGutGjQzDcX9B3KJvO0oFSzR+dCZJw8UkRKd1b+1nGyp5vO+v0bIDWkRolwTF8sJ8Zn6fhb/bU5W5jyAi/Q/gPYeg0T5MThivx00XqPY2GOjOIxJo6ZB+2ssWI9HzRiuyUXliqd/kWiZ6+Guja2Q1+p2N2Xc0rzcyy7Gr/FnP7YYlhK0OhrYoE9r8VxDW2364Luo5BYez/10FVWjWX3eFeN5gyf4NOuw0W4HQ/pqQ5qEFWvT9xlFN6U9REtx5yzl0lXtmmttWg58RT/pZvkcmyBzgVyxNBTZSyBSKb4YIohc0SJaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9c69FB5L5uMvqbBnI6HwFN/MT3d38S0ODzTWYS5UG7M=;
 b=Om+E8qjBS3XL8JuNzsincUFpuvtKLRiupS4YAUzTTw40pJbjiVqtccYl0gIrtdfTtSDrgK0Q2TnS8PXb8NHhlcNU7EyxSFAva9q9PEhYSpcDyFv2qhIL86xAbxVX6+74IhcGX3IlzZfe9N8kCo0RZUj3AU/0K8s6HMY1Z2OIRkGLzQiCJ9YMtUJTo9x3DaqUmNTKQTHlRG9DnBssFqJFfJZXEkEFRb6OvnbqbKFyunb1lBg6OurG1MtbSsH4fEa153elFij9JtxQPDI3Pmikv6w8GoSYZarmM15iei1ghJcSky0mdBYmbFhMXWhPbUyvd0+tZIwI9U4Jyjoc0h2gbQ==
Received: from DM6PR13CA0027.namprd13.prod.outlook.com (2603:10b6:5:bc::40) by
 MW3PR12MB4474.namprd12.prod.outlook.com (2603:10b6:303:2e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.28; Tue, 27 Jul 2021 09:42:18 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::f) by DM6PR13CA0027.outlook.office365.com
 (2603:10b6:5:bc::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend
 Transport; Tue, 27 Jul 2021 09:42:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 09:42:17 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Jul
 2021 09:42:17 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Jul 2021 09:42:17 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/46] 4.4.277-rc2 review
In-Reply-To: <20210727061334.372078412@linuxfoundation.org>
References: <20210727061334.372078412@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <63cd0e4a0e654418a8bdb57a40751fe7@HQMAIL107.nvidia.com>
Date:   Tue, 27 Jul 2021 09:42:17 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b11c328e-2d49-40ac-8f41-08d950e2d2c6
X-MS-TrafficTypeDiagnostic: MW3PR12MB4474:
X-Microsoft-Antispam-PRVS: <MW3PR12MB447477186EA8BE9E4E37B997D9E99@MW3PR12MB4474.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MrsLojPDwzdUSZhTWjmti+sddnAbAdOGP1gE+5nBIccDsPe0w63a0e+PWGgTdhqUfeLXntVffHclRSFudIzGUJNgT+Wgvtm0Dzz9h/7AHU0neH8LzSsE93B+Th+dI3AuMLF/6qKe2GFGvQDPx62vwxVWNPUibonaK5U4xij73d/ag84hrZmLJ1pl+LLL0/NRqo1QIUqIKulVBJBwQco7q4l8AT2X2AyFdd4iC1NexLRJ331gSU/IGIuKO7GPv6BzVwgzwDhjyhJ5mlwh/MmRaDifr0WEY8x1H9+nxpKVSHEQYJ412vvX6GDX1eKrmVFhbS34j4dvP1UbJjzrxrxeOnevXQdjrjQq2x+LEDbmLs0SuUXrzWSlOLCC2iEs4a2+/j4k8qXNIgAJ/admOX5V5fZyesc1Xj9fjbsLqfS3ztUKoh04dP6KoUI+1D3QIeohfk6Lz7hqSgG2OBichj6RFUY8bzLK5F0SS8PqtVqbtULaXz51g2Gdgr9F1UQz6OwlJVFImSC+rfaE1Eo6W7XR6BH0q6o3fvgrW0F+5i2Jk0YVIZDoxKudJB9XIRNeBSZUk9Njd4Cn9jfbFgwq2tBeZLYEku2DVSvpTVNApWttCm4uD10WCA/o+6TZVg3Ge6Ot5RAoSdq3np6Y15F3RoVGlGhzyKXv4HQCH4Hi5y6RvKE5jukbRflfCLyiyLxW5fAZOLc+7F48gf0QuSdDCIUZdzn6CwlcFEk8rEIY4i7GnevY9qMtySGCr4eOhTQnWvPgAG7WMyoCJCGtjgDfnQKQva3HcalnEcgHsEnMmpEQYpw=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(36840700001)(82310400003)(70586007)(70206006)(36860700001)(7636003)(2906002)(186003)(47076005)(426003)(8936002)(336012)(316002)(82740400003)(54906003)(6916009)(7416002)(26005)(86362001)(36906005)(966005)(5660300002)(4326008)(8676002)(356005)(108616005)(478600001)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 09:42:17.7645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b11c328e-2d49-40ac-8f41-08d950e2d2c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4474
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Jul 2021 08:13:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.277 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 06:13:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.277-rc2.gz
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

Linux version:	4.4.277-rc2-g33db885afa37
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
