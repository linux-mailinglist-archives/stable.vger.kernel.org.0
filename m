Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B38336D6C
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhCKIAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:00:07 -0500
Received: from mail-mw2nam08on2048.outbound.protection.outlook.com ([40.107.101.48]:11489
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230158AbhCKIAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 03:00:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CilRM7ZfAooYJQhSrW5F4HLJ2bnARaHk8efgpnScVeBB5EYdGFdOVT9w0t4Dg9gmBIgqh/FitLYByOmuq74WONuf6i1FjLthAzISfvsY37K39reKLEDVyunXA8OK5a/v8AIRFns2Nefpv6Zz+Q8nVobAxD2LY97YdwI/BnojeabVAWThaIw04kI/3PvJfp0LdkKleZWP/RxiztJs+0ZFWLXWsgaC36sCpiPcHqO3/DO7h3VaO6v5McJgMgsOnfPCd/MIDb7kStSRv/5fgKt2iiJIZ2Jxom0PFYK3R7BHHrjE6AVD9vD5OS/CY+MNQzCRA2Dzqh7Gs5+q8MDVQ1shhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPQ/R/DGTRzlsSoobtBxFsgSEaETwrK9TOYgo63mjRA=;
 b=SpCCZjJh6OcuA0nhKEcHqYvG1q/8OR7kQGw5n67chKgnskNEPkMDPPMxRjf0Z9k7TBMQ/TBBC4P8cj/+S/EZwrZiD0MXQUBmCLn4oLxdiHCnSK3Gsm5m57VY7ur7lz4VQ1EAtYjtIeBMv2oVvENxAkm+Avvzs9zXNGh3GAexlnjqSvkWUZCNyzENDp7VJ7I/Zn65Zaz7neHME1DjBiD1brElczX04qPysNruO8apGj9Rhxq4Ak0sAX/TlB6ZFzULXmn/VEJ78Im44gufqOyBwTvhq7s8PWQDSMPMfnPca3L+Wq1C14Bjo9ulrazzrDp0CZ4mdkOlw9VEzNvTaXPdkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPQ/R/DGTRzlsSoobtBxFsgSEaETwrK9TOYgo63mjRA=;
 b=hHCItfW3u+rNuNbJKNs4gKbNSpzUSXXoMlErHoO4Dm2ivmMDZEBOpfbfedlx9X3Rz7ipTowKtbf3Gmynn3AHuPS1hKjfCyG7bKJLLjvXcPBY0UkOf5Cd2W1NzEqRCV+Bt+R1akqEvAGyjT9zqvVUE8y8709dphhcTyPA4o2JFqZypQcOYf51nGBCUcjIHlJaire6+u8aPudNvKxr2MvjiOOHq5fPwiulnvoDnxuBTCaR31+1MbN7JDsAFTdBZCJHpcGzoVxCRltLfd2JNpNipVfBH6CRHlCHY+UMkoMT9JRltaXSlGw5xtfdduHrNZdPAPML+L+x1gxXs6zOOMKEcA==
Received: from BN1PR12CA0012.namprd12.prod.outlook.com (2603:10b6:408:e1::17)
 by BN6PR1201MB0195.namprd12.prod.outlook.com (2603:10b6:405:53::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 11 Mar
 2021 07:59:59 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::ca) by BN1PR12CA0012.outlook.office365.com
 (2603:10b6:408:e1::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 07:59:59 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 07:59:56 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:56 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8b96ff67bd3d4e5ea9ea3d695eb5ba2d@HQMAIL107.nvidia.com>
Date:   Thu, 11 Mar 2021 07:59:56 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7182950a-f89a-4c16-6e08-08d8e463aad8
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0195:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0195E60F82B9A9A020492DF1D9909@BN6PR1201MB0195.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7KYLM0Zc3UJLN5BjXnhp5gxwihs/nS5In/kYQMkIMdm0jN3GUtd6BI15ht/GLpHplPymSG1Wjhtq1dYeAM66EJfRq3GeW+xErmtjEw1j1GY7gLoULheReZgQUgE/st3QSnk1axKtFj7FFromXVdxL6LVJo+709I07R5R4Uqq5K8Fwc5EoKvXJhhd/vPr2GZrvoWIHdx71B0S3gHDcvQqGegjW14cjKcGFcAb2jD7xcscB9ZyUtNgYaKopIv9e/URE+Wi7wdRG6WDGny+BH5iBDrVjbaqNdwFtXh8QGwhPBRl+420npytwClxCyaUh3Ym88U1gZj3xxXhImEA2bZJCSnPPaYKXpNu7YjkB7z8GX76fM59xe2RM7ng3hGOgfvnowMMg4141kw9V5m3KKHLYmh4KJ+1Rkur/O7g1FNmLoA0EDCpKSk73rBs16gcDtWTRY0QtAQFMTJxct7pxAx/hJofuTPNsiRxZ6VAgs2k4e6uqCmpSGOdDZKpqY1j8W9M9UqNSWu2Yxb1UKzd7l0hSU76cobC8GMEm7dIkDgUQ7CdsJ68eUwD/qUkZwVjOa0zs5yFItkoKTC24m2RkdGcNxbghJQ/lX7yNpMDaP3JOv6dM4w0r/X4ifpA7jgJgq6dqjZEPt5DE5dnmlgIyegE759fxIHuL+5OBKbV64tWtF0Rc+FPfBWt78eRlBISwmPXOL/hNfj+t6ORFna2VGcfcjIiyen1UPejHLE8BlgGRISgIBgJx0tH38ufTpbwIfIvNP7nfi9PRPgDbOgR4h6/og==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(36840700001)(46966006)(82740400003)(47076005)(356005)(6916009)(8936002)(26005)(2906002)(36860700001)(7636003)(86362001)(186003)(34070700002)(70206006)(7416002)(966005)(336012)(108616005)(70586007)(24736004)(8676002)(4326008)(5660300002)(426003)(478600001)(54906003)(82310400003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 07:59:59.0571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7182950a-f89a-4c16-6e08-08d8e463aad8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0195
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 14:23:13 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.11.6 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.6-rc1.gz
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
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.11.6-rc1-g4107fbb88ee5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
