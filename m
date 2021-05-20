Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A3138B333
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 17:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhETP1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 11:27:05 -0400
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:43489
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235185AbhETP0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 11:26:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpQrVqvhK21cFLeDIK/cKLlg4rhjwdr/gS3fBvTIpxW9KsWYLxXC/NiajAR2cGUlGhYS703tv5AGYozMK9+07YViBGHNJRQPm/Y8LULNyfWQdCmktXYWgL/jAj0zS8YOUoTr8L09Da7CUzm3VKtTXmCkI66yU5Zj7RE3cJ30EVm31ZhvZlXtCEXzccw3mDPHofKkaC7anpPSobhuG+SoJp+0dEqQa9PDrm9Y/h3t19owj2fad7x7Mb4RPvWzInT4s5EbTIWouLqRAmWXLD1P6p87IVIn77owsjSmFZxJG/WB2aDGaF/7rM92Z5T6Z0n5PBdxCFkhPAqlnk35gs1how==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=811FVJVXp9GvE7PLzaGqRgUX1ZysEMj7Uxnqm/REHL0=;
 b=B+ioHbzhJTCoMXJcdZgHAlV7hWJ4SNShGMdlNrwclZZK98Ewh1gUEZMojnkJ2b3HtvJ8yxTPFpPXyp7fx0JjPyhDxg/Zk1UOxBiILyV97FcqllTRNh0rLQRUL0wu59uv2HIAUlrOzBLE4arExmurAnVxM6LZAiffo1N6uotYnuJtWzI5Sfu4I6yIPNtgmtsY9kaHgUTqUvnlShhwXv0nIi1dbWTsbnp4ggTQljpc7lmOZ08PyplcAx/Fk4snoPySn9WBYgh8KXDCBat6nsxoYIOCZTdmbs3lhHJinjHTWR98BaqTK4XET4ZkGqDhwMIZpjhq3IL2b8S4n8ABVj7sLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=811FVJVXp9GvE7PLzaGqRgUX1ZysEMj7Uxnqm/REHL0=;
 b=b9Og1SFMaNALHMnciOCZFc+Sf5EySRsxBY8eRCpAvMvrOj6GRJkjfwKLOdlE7/L0c3aqTmftkeRC4ui/oPuCdCRwBL9lG5Q38QBgp0Xi+sUtgGSuySaYnfY2itx7b6eosqJtu6NQZ6Th/vQl28lTIs3TyuZdzOG8JrAs3hcNoNkyX+BCODksVZTkjGZB7WP5iF5lu+UiwJuLVSa7ZZxpCfK6L7/yKUWtSAIB8eBD4+eRKiwrhb7FmrL/6HZbs6QEgWvHPnn08JRJZoCvNNhE0bWxt8NLHQYG9s0lxR9kEsaJrQOu7pzi4UuKhfgrOHRlnfPEL6nTmO3v8cCYkuixxA==
Received: from CO2PR07CA0075.namprd07.prod.outlook.com (2603:10b6:100::43) by
 DM6PR12MB3787.namprd12.prod.outlook.com (2603:10b6:5:1c1::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Thu, 20 May 2021 15:25:13 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:100:0:cafe::3e) by CO2PR07CA0075.outlook.office365.com
 (2603:10b6:100::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Thu, 20 May 2021 15:25:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 20 May 2021 15:25:12 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 May
 2021 15:25:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 20 May 2021 15:25:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/425] 4.19.191-rc1 review
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1858b39c61e24f87aafe39937b47c453@HQMAIL101.nvidia.com>
Date:   Thu, 20 May 2021 15:25:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd232808-0e10-47c6-91d8-08d91ba37609
X-MS-TrafficTypeDiagnostic: DM6PR12MB3787:
X-Microsoft-Antispam-PRVS: <DM6PR12MB37876B08E8CB96500BC491E1D92A9@DM6PR12MB3787.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t+Thg0Jr8LARiojCvdJpQTvR0Wjgmxah1Nt193DRz00KmWeEJ0FxBfJu23Za4OTYgKP9MbDzKZZ685PdGUhPYJuaXeN4V6IQ9xGvyqWYe14lDPerH/9kVPIXsPUZRAKdDD8t2cJ7O9ifVDJKRfQ4j4E4KtpNzlyr47r4hIkOEPZRY8AOCNzyffsLWMJCgKH/GyQfJdPmoJdWRsqj6abOOdzCPK55B6B7oprRPPUgMX2lT4TPeEIwhnv98PhupduThTr8p1i+gGPpFHRHIADAqHjTUuHRigOuX/C48sFJSx2KA0F6mpbpx9wrV+pRkelXz+IWhZA6rZ8XrII0Ytgua3q1Yj8pyUpqddsMy4x9N0Jw8exRMwANOHChVGqrtpt10m++SG45dWHRDajlMjFFO2Mu7Y8xOUI+axr/lGWZPP1EcCe1geJWdaCqBeyEIqfza1g2xYU2aXuVAoKh+HcVXXrVCH15izI+BoAYdsuBcv9FmOUXz/3amCSxCSds+BzzGmHT0geOj9RX3vUqDQHMiHz1B7LwwNaDEwfy5bpneUYA7FES1OmuaXhYjmFwNZflNMA3JW8quTwz6qdM1U5sQQP3aUI5NG0uLRxC5n1Ta6vqfzqIjMWl+y70w6BIzrK0CC38kXqXfv24g4w7zgPa/RKUwuFEpeEES+P7ITqzb7xlU3y6Lxg9eGJRFRgXjTAdTLY3YglEs07WQIy9CSBgdXfvdy81jpYUoBhAzr3NA7JzQN/SaRXCbO65VdDnwONmIqyPwvLU2BKp+elxeB59zw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(426003)(2906002)(336012)(86362001)(8936002)(316002)(966005)(4326008)(36906005)(70586007)(478600001)(356005)(70206006)(6916009)(54906003)(7636003)(7416002)(82310400003)(82740400003)(47076005)(8676002)(186003)(36860700001)(108616005)(26005)(24736004)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:25:12.2454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd232808-0e10-47c6-91d8-08d91ba37609
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3787
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 11:16:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.191 release.
> There are 425 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.191-rc1-g06c717b4df3a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
