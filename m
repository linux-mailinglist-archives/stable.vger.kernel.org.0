Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED66B3FE2F3
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344640AbhIATYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:24:19 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:50656
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243766AbhIATYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:24:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KW+UHH+Wu/+97C1czxTRXOjtBVsh++45djFNUSmKHe+urgMaibPMyekxug52+FYq9wfVyGsa6c1OWokPPBK1FF/QfvXzU8PdE5qmRLj4SCTqxrL8goAn8lCPal1hE7XQvzSyRzWLHvn9HIDSUXpT1Vu6zM9Qkl08syP/Z2wY4rlVq2o1pmyNI+ZDbUMMXasuhsrpmr9sr+KmpATq2kG6j7RCOaC659x34ZBGRtKoYyk/HiqLozZUANMvOL6GgIh5XuJpoHhTH0y/nIq4beVmNCIb2dpOQea7Qs4ndov5MHceSR7xEA+yor7JVszPH7M5TCYNUg4vy1agvzZgUwDgQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDvT1C91/jBi/hRu0I22zoMKAk/i8Qk6cToK1P0zS9w=;
 b=ghmth8SfNayzs4eWBPMQNT70gC2IT9gtGMU8VmfY7QPhFH1lulZ9n03Nom2T+S6KVhwQzQtprfzrk53IriWQ2bWD/BSB9vj9Lfr3V3b8IAGRUD/BYAxY1AfcApOoemYqHFPPnvWwhiU/c49p6vBptNur3OSnfFJ3+NtT6plo+uuKnf8/Tx+JruOCma0Qs/HjuaJd5j46LvpwO4w3H93O8A0gocFqwmZZH4ROjMgQ2Omz/LA5YYnsA9ypKmy6rjq6rGbvZ+ITdb4/RKl4PzkKTt1tiTx96lzIHmb5oMoHccCAZ74rU6v1YYJCBj6KaItNnUgCdxCGGgEQQTeVImmJxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDvT1C91/jBi/hRu0I22zoMKAk/i8Qk6cToK1P0zS9w=;
 b=hFDgrB7eMQlbPaz0z+EhTLxhrIsV43v9DvV99eeIvpsYjf57RrsvunfZMMxHtZk6m5M7UcOogt4AbLP6bfT9nyDcSjE5UphT7Ts8vU/gm+tQLM/o76lgPhBkgacuz2QIfDyG/Z7WBO5OMp4jB9gnTYI6f6+5A8HK+bDG93yYgBPqbTizuiaxnMaJ2BDdF434vfHFTcF2fDuB5P1TZN6Oqv0xZ6SIqxbl12PZBlpqA9WfQ6ksrAghtSw2l0TTjek+KGnv2Q0fNcSJhhXpLqGRDeP2OPfQSvOeIx4lgUD/nDl78izURbvjL470bmpr1zNmaXnOp0RWakWEl1AoOokyGw==
Received: from DM5PR07CA0048.namprd07.prod.outlook.com (2603:10b6:3:16::34) by
 DM4PR12MB5389.namprd12.prod.outlook.com (2603:10b6:5:39a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.24; Wed, 1 Sep 2021 19:23:20 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::c0) by DM5PR07CA0048.outlook.office365.com
 (2603:10b6:3:16::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Wed, 1 Sep 2021 19:23:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:23:20 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:23:19 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:23:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/33] 4.19.206-rc1 review
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ef43b4fd12d147d3a81e2fc7cb6d1b46@HQMAIL107.nvidia.com>
Date:   Wed, 1 Sep 2021 19:23:19 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60847c8c-cb1f-4814-f6af-08d96d7df561
X-MS-TrafficTypeDiagnostic: DM4PR12MB5389:
X-Microsoft-Antispam-PRVS: <DM4PR12MB538907B7AA805987CD866CE0D9CD9@DM4PR12MB5389.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pb6ss00jOkCCkAOxD+GIwA6GTVCU6hi3+PUY/2mj07hTdac6mVFQ44gkfr31ungK0HQ+0fe35KCMnEDLsFBN0o9wqTmBboKdQvPDlEgqgSHoZH74aKb/C3bfjPMSHmb+T9NxOVZWlpwpBNj9zpesHLR5/Bq9lCbtsWhshZhJotG4gpcE+qx2OIzhJ/ojr1qL8Wks/QPHCA5kzbHMDXdscciVAQfjnw8ki9DGkC9NLhLL9Z/S8y1q3uY9j8Co8rNzHnVt570xV7QCtyvMYEN7lTlYBHn+JO2ZzJbm+nX5TRfjFB8Mks3G5m5bpPUCIhuBk7VH1lt7Z9/upPQZ7pK9V1L14NUW0r/KHblsH4XrlYFIaPXCG0caAAxb/2wHi2SnrIYEb12Pz8LS/n0sERgF4JWvMoiNmTvwktUIh14IAesGwoPWRY5KKqQjAGnIwZGsBUBQnIOnypkOEUQS8y6Re3Zh8Id0HY8f6a95Su9b6xtbKr1fIFvjtiowIB0INaou6DC2rb4kqBNtCgk00orNdq5PYIfh3e7SF8Q0B3+UgxKXCDUjh/ANB/es8uVZOLux89EntucpQl6R0hEVx/bOUvhsa+wMqaO6FImR/OiWruD0NwBewJ/U+9pDM5/BebI0Tb1kkNuSI6R2Opeaw+u6mM3pEv9Axnmf0iN8ns8J5smcMAiyjgCSC5BC2Ak5DTV6Vru8iUXirACyOLEYYgZRmCaXGCiUqjRNsTVMjHWsw5xg6jAtZOsJp75S3KbQ6CYJTQJ9cmrlVIkWGgopLTSyRfTBFYa8lUb+1jETrrpaDNw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(36840700001)(46966006)(70206006)(70586007)(86362001)(478600001)(426003)(26005)(186003)(336012)(54906003)(7416002)(36906005)(356005)(316002)(966005)(5660300002)(108616005)(7636003)(24736004)(82740400003)(6916009)(4326008)(8676002)(2906002)(82310400003)(36860700001)(47076005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:23:20.3744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60847c8c-cb1f-4814-f6af-08d96d7df561
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5389
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:27:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.206 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.206-rc1.gz
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

Linux version:	4.19.206-rc1-gfc1fd7aed81d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
