Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C8C374843
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 20:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhEESzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 14:55:51 -0400
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:48864
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235016AbhEESzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 14:55:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ae663WY3ZBzMD5ljbTSTvk9XeHI0a9HaLHTO1eYKr1HHKtR7tg63i/B+PsZdd8bENLZv8aUL058fZJnVeye47zDuAPuVBdWlzn2grECVHGMXz5c3E4wjAzWJPs1homslK0fUgnjvniWYjuO1RqmaLGx3lcd6fAKKN5KyotPfn2q25nfZfbXDmz1/eiwiGBuwUu+r8d1kUA9ZeUUCoBURsbgXWDvOcOI29N96np7cORIGJkTMLTWpSvloYaVQZZRmm82SH9fG0iQvAS9vf+YEW/qvptj1A0SzQHXPrN+qULQHSOZbdQnNtIL/5PXex98SAsY4Nto8a6ToXcaFI3oLnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxRmqkBMIaVnOZu2TaM4p8CJh1zL84SZpAePK5B2geY=;
 b=Z81nIl7FW1QqWD5tHaEY5sPxhbDb4gFW/hrMfXhSH2w83cIYSSa083lDZrrn074O9QufosajVqzwvyINZ2jWpXokDG1SdTwxeoFGP0xfa7km/Bjs6C3MrLK3Ve49rk9IN7ljnVDrm6+Pl4iwuilAI+qPNZr6GZxnCSrzYG9QKK5G7YE16FlqKFn0BJwBtzG83Tu5y8n0WOxQXCj7SLwc447KhxXf7VJuZSbnDFDZVkSgs0CbzEfN8Ik1f3dO0htk/TarGAmy0dZSkwe6TfRExgItzqA2T/yO1TVuBGQAVav5oNI54YMJiC7xn0Qk5K7d8Gr56ywGgGnOwPwWRrPaxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxRmqkBMIaVnOZu2TaM4p8CJh1zL84SZpAePK5B2geY=;
 b=dRzfd8vZFfRNGZOGo/6Xg0Xv+VtyOnOGKs0zgAtIXK/z+WunXnX0jxn/E2pt9ibQd9zz1omiav8JiXx7mx2RFtfskjRTTBrxMDyowFX/JLWZ2KXPXN23RFjrjhHHd1gnKrE4gdfMp1igBWC/1qUtInx+XaxaOVBLg2A7HG8Rk2hlKXaIWXfsFT3p4JXJClPOq/si+SaOwsUNyYDEYMFkmq+kZhwSIHyhIa3Rn/VRZZMvZNs8FHN+baqGJxJNRQCN5RA4OoHF95kjl9p9lcKmAdWoYtDwS04J3f2H4xa7w1vgEe92/miURThN85WGX4QJFKCL3iCLQ8aqzpDNM2dFtA==
Received: from CO2PR04CA0136.namprd04.prod.outlook.com (2603:10b6:104::14) by
 DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.25; Wed, 5 May 2021 18:54:53 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::b8) by CO2PR04CA0136.outlook.office365.com
 (2603:10b6:104::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 5 May 2021 18:54:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 18:54:52 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 May
 2021 18:54:51 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 May
 2021 18:54:51 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 5 May 2021 18:54:51 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 00/31] 5.11.19-rc1 review
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2c7a69ac743847a08aaa981e4e71a1c7@HQMAIL107.nvidia.com>
Date:   Wed, 5 May 2021 18:54:51 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67645472-7e7e-4fef-e32c-08d90ff74482
X-MS-TrafficTypeDiagnostic: DM4PR12MB5133:
X-Microsoft-Antispam-PRVS: <DM4PR12MB51331C8D39BA13ADD7EE7C8AD9599@DM4PR12MB5133.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Ql9wyuzQCc7l5aclq7IuSHZSUdz1lBjM/oZ443UootKQhDHUzNZhFF/HOhw2bGHjI++LBm2sEQn2MWBSWshwjjlzGZw8ryMcZwohRWsXOOtgTscBp0GPpSns2pVuUm7Y3qQUEBgVvO3mQy6R5uaXFfJyB9SmZvHPf6CuAS0dkkk/rvVtpTLO98/oz4RnEfuPfLLXnYbKJtiO5Uw4GbEMN7fojVolBFw2TGmENoc+WyDuvpc/WVVjJbYLi1W9TmsY+mhCIpPHsiN5tNBpLiGMrSxtSPMMJOyZf+a44ixXEE7BT1wBtAIn42O+4XAyAp2ZkZ6OnQTgOwaPIEOe1UCxXXe7kOB2kBHrvw31EXjhIMvVegJjXTXG3kKsyU+H7yn+3ayez8gC092r7JQnzc3UO24DsU9EWAcVbkdGB5ik1jjFIaXWgMsKf9jXeySFv/G0+W9fCoEukZ0H2ya1nH4aTA5Z9QfXS+xx5X1d8NOGPHaPbdnc0H9EdvlHGxHxsTrdyO83l0jonQCwgXpt2kjVwzPNzu6YI+5m0oJ1fzyvRAVLe8vV9SrJXv9KIfkEqNLOWEITaFWpfihsFO7vyQG1xSPR5wzPBmIIKywwMDkH5dLrwdk1Ax1EFTVD3A8MNhJBfoTO9bJxleK0YOEg6Apj+vSdpthadvsH0eKyPRP5qk8ByGZXooMNqXA0dVsVqf9O93IFcRsrFqjNhfrOopsv7Lt/LC9T3cPSi7W0VrqK3o=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(46966006)(36840700001)(54906003)(5660300002)(82310400003)(86362001)(966005)(186003)(47076005)(108616005)(24736004)(2906002)(70206006)(82740400003)(478600001)(8676002)(8936002)(36906005)(26005)(426003)(6916009)(7416002)(336012)(356005)(36860700001)(4326008)(70586007)(316002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 18:54:52.9373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67645472-7e7e-4fef-e32c-08d90ff74482
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 May 2021 14:05:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.19 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.11.19-rc1-gcffd2a415e64
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
