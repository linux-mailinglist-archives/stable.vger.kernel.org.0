Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054E23935E8
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 21:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhE0TE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 15:04:57 -0400
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:20448
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233625AbhE0TE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 15:04:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aB7BGHjmXG8fD+wteisaTetXzCRgBPD/L0dT8pBWLb+wKv5G0tWWN/1CPFwJN3d7Oa86uj4bzJ1Q1xk8Qi9xUw7eNHT6hjU8j00YqmPsgU+UK7F2zItK0fBtlsKhMzk3J/d6CewUbTzNNPjlJSGU/+r7ywo94p+4Z2OBRtASLYlWN2NnLn9GpMLZUrXOy6ruIn4Sx+lyQWL8zLVHZ9SWal3izSi/TsGP/sfyADH2BxPVFvCJDfvxc/8/ykNGfitT/Crj8054rZFufy5fGqFipmohzEtBeAOb5FfsX6BT0dvVx8qfvnc2R43qr0t0LO3oL85gepBiksQvl9e49GCf0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOrddU/Xj4owUSUwBv3H3jXCphzJPlfu+Kj4RspaaVg=;
 b=bNvopTWW0vGdAh+wTqLSzqgWdaDmgYVq3wV5pIxf//MPeuavBGBYIklcCd/WEraWJVVigVVAowatoUVh6dudcZvhFuEHP1Xeh5oxT7HYhmbQimbbiJBjKwg/TJnwQslx8/SeyXAId4h9UdR8k7TMtbKnpKXu13FJVyKgVMY0VISySshPX0xlQc/eWxt9JYF5p6WkCmEv8ZN8Kc23OO1LfHp7YBeirswRBeNlgZwUZdidbSHQaCrFZbblUtVKHwai/1miL8kVjh5Tz6Mq6Z8A9yroGpUb3IBasKJ/rQDurKYGcgh+E1jZl0fmRVk2I3iVgsfhzQikUIGIhpS6IXBTdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOrddU/Xj4owUSUwBv3H3jXCphzJPlfu+Kj4RspaaVg=;
 b=iDvEVkMxheCEu8o6ai9chz9b4YvMqYP+8J2FgAxTGBBzizJzZ2dAmBEFaVao3pVf6iIuZ8EUJ7mPDlnopT3PQKo7i+ljd6Y9s9h8SlDK6KkIbE8kj3EXbXiYiH8kEM0c/GC3r3ytGJ2qgn3XAtfP91AWbXQQiil2F7l9sSAA9ZihSPAaYzcWn3I122EWpuwxYjrxbGyEv/D4+dpblBI2Z6Yp3GRmCIeVBQBCZMw4etVJgSUcs5MPGp81orQew2alwD/Aupe19APRiBKWYX9S3xROTyQIJeubiM8q9l+0tv4mjcXxVOYa3tknhrQMm2DQKAdptfizNEn95SLFoliDgQ==
Received: from DM5PR13CA0029.namprd13.prod.outlook.com (2603:10b6:3:7b::15) by
 BYAPR12MB3045.namprd12.prod.outlook.com (2603:10b6:a03:ac::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.27; Thu, 27 May 2021 19:03:22 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::7d) by DM5PR13CA0029.outlook.office365.com
 (2603:10b6:3:7b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend
 Transport; Thu, 27 May 2021 19:03:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 27 May 2021 19:03:20 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 12:03:20 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 27 May 2021 19:03:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 0/7] 5.12.8-rc1 review
In-Reply-To: <20210527151139.241267495@linuxfoundation.org>
References: <20210527151139.241267495@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5ab76a05fede4574b6f68c0101454652@HQMAIL107.nvidia.com>
Date:   Thu, 27 May 2021 19:03:20 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9b88f0b-387c-4371-319d-08d92142185f
X-MS-TrafficTypeDiagnostic: BYAPR12MB3045:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3045424E1C395ED7EC619478D9239@BYAPR12MB3045.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T6yHSC5naGb1GkCIYufK9lJSd90d1L6hCmfH9JO/R1ZCB4ixXEmhXUsZN7rkNTZrhkZo7Kde/ztEcrPT59uK9kmaJVHrSumFnpg9bY+FIl+lo/HPxq8R+LkwB+xroK7GhnOBG05PwduMwpQaRYn6VpVbzS3vaW5noI55mG8ozviHnKAdpJZJ6BFYFRFa2xu7QuHiz5tIjMHCWeud2HLYcP80VZQMan5Dp5pS738spCacpMGZGFyXTFqECpqR015ErHrjMVbDZjsxPxNEgcCOLd+4yFweJlPzhhcRwxCxuJjE0bUsW8YHn6HtX9NMFTJGo2am9epNmLpxclMlE4leK8AjqMPqhk4PD0gC6DZoHZ29K1D2Gs5DezkUqA5bRnoo2XeAAZNx3k2whIPY+iCEbzQV68AIIr+VkNjZstkDdPMj8QMmt6ZvSZ333VzkJ0G9ByHypJnJHC1eYz60zR4hkId0jStd/1hrcsSmdZa4hTG31srIdgroK24c1vvVt36wpb6PG58Wy0sDkCIJsv1TFAuiFNxCPQpORwXTEN3ZdEgvq9+LpxLro9YxRHrHiEDfYUau5D05CViWcq9Uwo5WTcCqhVLa11zAsLm0jJmZ7XQt7OiqD5ybfpYbqLA35R1+/dtdPIRo1G4h2DIopl55oUuTuKC7y3i/xtxmKZUqQ8guLRivc2jU5jScf8s4VQaz5Znr2+j53lg6SCB/lxOY3xwvqOv2/OcxIBwlEtMsCUl0SVfdCXjACtMLqEWT0Gt1s+xSBg+Kb3+Px8CABgcyQw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(46966006)(966005)(70586007)(186003)(4326008)(70206006)(47076005)(8676002)(426003)(82310400003)(8936002)(36860700001)(6916009)(26005)(5660300002)(336012)(478600001)(54906003)(7636003)(24736004)(356005)(2906002)(7416002)(108616005)(86362001)(82740400003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 19:03:20.8136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b88f0b-387c-4371-319d-08d92142185f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3045
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 May 2021 17:13:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.8 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.8-rc1-g6fc814b4a8b3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
