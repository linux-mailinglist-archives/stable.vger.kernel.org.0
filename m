Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CDB45D912
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhKYLW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:22:58 -0500
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:64833
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239845AbhKYLU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:20:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbOT5smqZNYuN+DtqwUcBuqXiNGTgfCSXabBZrLLYvhc5V8KPLhnC3HKwDcutdcSnAepX5gtCrJHz2e2emwEeXwe8ZlHmvmUgGIKa9iuPputikMhWyI/ZXqsg/jJpYwntJxPvEE6qBFcWESGNZ0xZw6tHIFKjY1+F31H+0N2fqdFdMzW02vCCDX+ZQHfpuXxD62Cb/xmtzegL05SsqNkbEOinpC0zo6FQssmZPCl5CRXB1x/YX+dSNbaGZsNTadc20T+Pvb/48NqqrlqkIyQNeGv6YTJLiNRfrfa28uQ3ArhF+DwhtWEyA9e9hy/F6pF7mVRIiBVnkgOXl9MByx1BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1X9bsj3f2xV+FvnqpCJbDemG0ehQCvoRD9byeYSjGG8=;
 b=Ln9IrSHWbwZfNs4PMrnD3ntzMjMNx99rgvp9aTh07AuJg0wGvoXh5mNaHyOm3gqH0KQbNhCcdFFBLm5B3fag1IhcXo3xVl6jVpw+loKe/GDn8ZDHmSvQuqo2GMF+qy7W3h+ozH8wvwRGYTRqBMcLFbRW3w37kzwQC6Jpt1AezSwaPQ8oOYuYPVYHq0sfoOSXDZPn/UEU9jEtliKtHRcV2cGp7lSN+g/CUE2LiTa13ZumUzBeqIK45iB6a15FBPhZOte7lSbhKp16kVvRt/qzNfwcMS51wwg3ktCdzqxvpm2I2hcnOszAgy0+jrcmlga2vhMe9Ps7TURvinEaTN75OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1X9bsj3f2xV+FvnqpCJbDemG0ehQCvoRD9byeYSjGG8=;
 b=PdBp6jwgzENC7Yvx+dhfF5xpidWIVjfvqC88DdH/DVu+9aMAbcm6CEPs7ExAZfLHPB4wfxdPbMsBafJ+HaIBE4rQB+YEZqSgBLTeHVQZyJEeezHlAu+B+yeUX+2QAAT6Xnk0zr3mCVwCylUKvyJrUy/xgyNP94qcfvI9Ec6GkBdE2Tp3IuSy2f1nP0dwLlKnyWp7vIC0/G/l2U9JFUKu7fL+RYG1/Nr71TJYN2G0oFBNBUr5trRuVhPkt6BGiRsBuvwACsLq+5p2MM29gCj3m+ZHepxV1Kohq+IEU59UzTyjd4O9zB8tiGZA7Pnqe2a0ROlB6yGrkbbDZnNSL95fgg==
Received: from BN0PR04CA0015.namprd04.prod.outlook.com (2603:10b6:408:ee::20)
 by SA0PR12MB4576.namprd12.prod.outlook.com (2603:10b6:806:93::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 25 Nov
 2021 11:17:43 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::30) by BN0PR04CA0015.outlook.office365.com
 (2603:10b6:408:ee::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Thu, 25 Nov 2021 11:17:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 11:17:43 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 03:17:42 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 11:17:42 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/323] 4.19.218-rc1 review
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <706b4a40d9ef47a3a928d752922797ca@HQMAIL101.nvidia.com>
Date:   Thu, 25 Nov 2021 11:17:42 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d808c6f1-0e08-4737-6826-08d9b005338e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4576:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4576826EE4144A2F03CCF163D9629@SA0PR12MB4576.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2KPex5QNuppgxTjjOijIxh7T0i4yIhaK+qus62eMg9PUjS9ph2yV72aiFt/0WdPsI0ehMybEnA4HMHLKHP1N5xUY0D3CwXuh3Zlp10TyPqthJIQUxenSBVCHC918/P8bHhfToENMJVy6mrSE4xaKtrDzvxrE5w+5bHQD2CDGivYmGHgFPbykU2W1JpOYiZcXvptNCHvJYTkZnYPwtXLcet9wqFxle9Ri7FqAGXiQckTS/g3EalOlPdpUoyNAL9zrkp3tWZccwLjqtMC8gBIMepb3ULbA84r7lp0okrBMTxYyrNdOUMK4v3+Q0NoRTXLcqoXZLF44TTipqeJEXmMq+hbUA37Wi4enEubyLOSgfdl0LDTWQo3HZyy+2ulBXJAtg2KfoJbzJHsMSLDscsy2O6uOqbrjf7cfkOHrDi97beVeL02VN6siAnJ9Ariynrjc6EoSxVKZb/CLLPn2Dm7d/BdFOtOLGAjqrdm+gLD3jDRbCqfTIPd+bu1ckLsucSoJYFXcEgv3FXbSWw47RXxM5MhuQWdhODUD2VAZzwLqflNjuYdX96vqVVkPjvMMThJGk5pZTVWxUpXUSFuJ48fKpktjtYSUtxNQh8edbfwT6vsKsQeiyf/gIpH/++gWPCqjAKUtg7sBaC54AHQ42pWzzfCLnIj7tOk+ga9eg8azQWzj8bz1dlrSC3oSxuXhv9IawW2rNEPB+kneMyiY9tZ6MIn8cioWlayyryfgiZ07WCYq5qn7ILjcPVGnSiilyrTZfm37ITw8PkfKRep9V/bjS2mAajWf7IsbMgFrgSOmpkE=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(4326008)(70206006)(7636003)(6916009)(336012)(966005)(356005)(508600001)(7416002)(26005)(186003)(426003)(54906003)(108616005)(47076005)(24736004)(36860700001)(5660300002)(8936002)(86362001)(82310400004)(2906002)(316002)(70586007)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:17:43.4352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d808c6f1-0e08-4737-6826-08d9b005338e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4576
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 12:53:10 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.218 release.
> There are 323 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.218-rc1.gz
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

Linux version:	4.19.218-rc1-g451ddd7eb93b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
