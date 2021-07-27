Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220903D722D
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 11:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbhG0JmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 05:42:22 -0400
Received: from mail-bn8nam11on2074.outbound.protection.outlook.com ([40.107.236.74]:8801
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235979AbhG0JmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 05:42:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDgJDylaO6yH4E0eqyxZNPOXjPH/Zr2qvyXFTIQqLKlcORZkc+5h1+DZwH5kyQpC76THBrc3bSZEfXkc7cAQHJOB74wCWvNUgAme3+lVXKFaTqyxy3i9Sph/vYKD74Gdbg3Yy+MH5djTy0TJUL7f3uinK4Czna9lPSdS66nm7kI7/42UUG9LnJ6W8gV7I0shmmVtjwDh1hmUPDy6FJkN8UgU7jDTjabM8hB2oIk/KbmcTn7LrhsVMHYJRaPq4z3Yx6nLk9B3g+Kbmpg3l+xgT2Ksqj9HsqcAB+Bk8XGDoLxG/ooVe93kaH8ofI8pCDrG6EBczVsV5Gg9tbctkryUSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVXiR4CDVHGw1iynzS9iAn0VqXb3t44sC6/DarI1RXY=;
 b=KRe4uGDfyBS9hNvD4543t1orvQ5+DznTAQdKz9AbopxEXsKTQ4sGl3jB8y7hp5U5mQurQ/uwFHYfANXUVuDQXUFuzZQ93GBlXjCwZ9y/wKl+RdBOUXkFi3lW/AkjyratFlqvV0ZHxYihJc69DsEijWEPHmUsQnE7QUVy8vHXRqNWdW9kx967MGF0Rt0AQCpGibTq3dDMIqCCsdwqbcwBuhm+UkCmpq8Y7kXvdSAUmXn2kHV62H5trxvKSwC9dTKFtvr+WGghyfLzWRpfFt821nY5Lb58I7Z1VFF0qmNJWJ2JUbfg0wuB+raTz4ns/BGVU/helPKM1ygUB9BnZUnY/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVXiR4CDVHGw1iynzS9iAn0VqXb3t44sC6/DarI1RXY=;
 b=KxaivF0i1+f3KDw/Vdk6+/ChU7RNMXXVDC/Dm/ZgLdRudY8qpHSqXCZXfgUC1zTTje+T1A80V+qknu/hI7Ypc4I/WzuQoCZoQ6iHIIsFM7kKhah5Mzlg0fl7XbXDL/Du3nzEzRVdyAR4/Xx9vXxzkZHpL2wPAXIhZTaICU9ykgZ0oMei6IPznvs1Azf5U6qU7x63RdtQR4KQB0j1eWXmwWDOrcsUxKysdrdPriWyZDKzPb+N/p21RNtRfRlkdyl98s55+UP8KjGjBgc9j4Nf7749+lpyUuF8RBcyqHAHsuBC5VfyqbPGJoar9mDoNNr2BZCK211Tj8qlRNnRlGRTpg==
Received: from BN6PR19CA0092.namprd19.prod.outlook.com (2603:10b6:404:133::30)
 by MN2PR12MB4549.namprd12.prod.outlook.com (2603:10b6:208:268::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 09:42:19 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:133:cafe::65) by BN6PR19CA0092.outlook.office365.com
 (2603:10b6:404:133::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Tue, 27 Jul 2021 09:42:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 09:42:19 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Jul
 2021 09:42:18 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Jul 2021 09:42:18 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/81] 4.14.241-rc2 review
In-Reply-To: <20210727061353.216979013@linuxfoundation.org>
References: <20210727061353.216979013@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c1ebff4030da408388c323129d303f4f@HQMAIL107.nvidia.com>
Date:   Tue, 27 Jul 2021 09:42:18 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3db2cb30-c062-45e7-876d-08d950e2d3de
X-MS-TrafficTypeDiagnostic: MN2PR12MB4549:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4549FC615F0F75093F3D4C6DD9E99@MN2PR12MB4549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3adE0ZydEFdHo6n5UCuISQYog6TV5uhgxLJN/G2iD3nYKfirZWzOg+y6ofrNmdeJ6tq7c3SE+Lec3p+0Vuxm4s34MenzRgQOiojCLQg6KyQfNif1PhhmIgK21pF+CzK6WiG6yJnehKh2pGRjtHNdFCW5peiNi5T/ntgJNukGQi5GYs20CMv+rLN5biixduGDUqGK9F859Rpklj+kLONQsSI2wzW3MerYysdL5k9VpIUE+0IOHQqCkCmdBROchNqK3TqbCkqjFBonfA7zxhb1OM+4S2+9y4OYuRiiDgAIGPxle3GVcga91wtE/AbIspullhPkHFpuuOLF2Id2Xv2F5OY8kvA9NEQ3X4LMThVreKVUYRg6dnVaJnnhJKdF9zgKedvl8LJbU5fnScyvR1RRisWFwRcC8ep4loVed4Etpdbr/4BUeDl8ZK7wMtsVy/H4lUKgM9sDHV6b+11WF0x/twkXhVxk/GtXuMq7uE+mF4rlz9nVSxrFF1aJgeq5kPa+qTv4YpUs4YDorKP3XkUXcoyyWIzqUwBjff3C2jWmL5zeDeLO6kKBH9Bs4soqbBFrN2st/nVNCII45nClmGJff5i08tA1eR6j+OJN3g1Wf99X4+c/7tTj75PWJw5KgfPbq+L9W6GpttQIMcAXsdpukf64taCUFtsd/XMrf3e9vhYzO9KjjnHmIwy9yk4Buq2xUk5tPkBkNZ6SUoAcgmaR+vyeSNy1ZsFeBaQlAhliMtzah5tKiLo1JezqrnvWvD6lRP4mSY7b4lduMolVay7BiCsjlcu/DNZmNdsfLMgqlp4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966006)(36840700001)(7416002)(70586007)(316002)(186003)(966005)(108616005)(478600001)(8936002)(26005)(36860700001)(8676002)(2906002)(7636003)(82310400003)(36906005)(47076005)(426003)(24736004)(82740400003)(54906003)(6916009)(356005)(4326008)(5660300002)(86362001)(70206006)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 09:42:19.4924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3db2cb30-c062-45e7-876d-08d950e2d3de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4549
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Jul 2021 08:14:15 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.241 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 06:13:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.241-rc2.gz
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

Linux version:	4.14.241-rc2-g44bb6f3b2f37
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
