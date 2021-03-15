Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C235E33C37D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhCORHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhCORHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 13:07:19 -0400
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on0621.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::621])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71EBC06175F;
        Mon, 15 Mar 2021 10:07:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfJQ9y8Wh21621CIPibXMHE82zihiMNJ7k2imVmOEcyhly3wQIhKPso8JMyq32xERA2GCGpMLwOZ8k2knmczCdfpw7xaxzyVvHleuOdtrHOI7ixLSkQAJlLYBto9xes0+DGw2Emot5IwmfzqgKbgRnkIHSdlR6oI5NFzV9bJxb6YGKE87eurjuUaLL34yKt3Ff6rFnH4uoEKxWV5xDxlKYT4GEYnsuUoHvX480Rnt/l6kaWjFTsx4K4reL7+suBLRqKRV1m5/YWToNcnb99EKaAjumwMr/pLkEhpgXKVY/5kVG/RLavdEi3f2l2klbwp2oNjo33trskAgKfTetv54g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef0AKzA/H492wQcuRbefZ8bWhWUpYG7PtuO4dZKYgqY=;
 b=Q9mbVPvD0MjmgDjyu8MziFmOwi0SqbN8UsZQ/ujmK71z8Rlpp0w0STk3FveuHxKbr3PKSVnEBFHzyYOW2Nd+q6pwEXrg3+Fm5PDJ3BhG5ygqbUMo6faTY1sV3dE5X20BJRckBA+d/f/R+HZp24NCiDK+2Pe2J6DDoD7Zh2UAky/Jc/l4UtJ+S6zmSTAcezbfk0K4z6WCu+S4Z2mWmMTuIwE2rLAoLzipbWopqFY3QNzkoYYW/RFe2h6IjiXIT7z7FOhGlLR25QvmfIObF/X64zlkxxhlwwaqHjwXY9OdKnzSe7gBklfGzZlI/lYLwaTW2f7bRcu4BivB4AtSPqNlyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef0AKzA/H492wQcuRbefZ8bWhWUpYG7PtuO4dZKYgqY=;
 b=oYP4DjF5c0uRVtavqykHs9Xadp58h05SylI3oL1qMIzaaUKCo/SUaIMk40QfrO2gTes4u2dP7VmS6u0BEPRXeoPqmP3FDXxO9Inmk1+zBd2SK9oNQCAyVEn+cSMzeuqJnuy6LtzAFf+ryNaV+gz70cEEk/Vo2FDDISCGPIKTTm13mSkbHg7LqJ+Q4I/Thtnk0IcZwuus65zIR4k6WjaDgOz3V/FICRQX9oU1KYkw3tRPznmINyqPnvBjhANnMpxbbdiSevOeOif4Pmr/ZSedrs3rQh2I3mYMGglyzxAFTnsW6ST/6tE1PajNLyTliKw9d/KEQxswbm0V3x0v6Ud7/g==
Received: from BN6PR17CA0060.namprd17.prod.outlook.com (2603:10b6:405:75::49)
 by DM5PR1201MB0041.namprd12.prod.outlook.com (2603:10b6:4:56::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 17:07:14 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::bc) by BN6PR17CA0060.outlook.office365.com
 (2603:10b6:405:75::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:07:12 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:07:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/290] 5.10.24-rc1 review
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7dd43a2e2146425c8ee0d5be7c0b6715@HQMAIL111.nvidia.com>
Date:   Mon, 15 Mar 2021 17:07:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66c323ae-7593-4733-1a08-08d8e7d4c6d9
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0041:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0041DA445813A7FD3FCC8EFCD96C9@DM5PR1201MB0041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NpRox6l+Cd9hf7VQyZXjZj3KpEEiVWCNl3W6Wr0lPqMtI9MuwHfuR92W/+G18QJrZzT6m+2S7YzD8fm4I1w8u5mEX8Q8b/rWOpthP2JG/4iDM4C3NCx5AoIk6QVnri0Cqecb7YeU5GB/lTG+mA3njoBd9Iw6ax8xwpGGDS8iw3+6S9VvG5k/Jvs7+CzRmAJMxkF0R1tVCEUhBFSlrOOlvqOBEsg+AolLQ2liEZdnZvRXGNpbLcUJLwSTfNy+QO6L4mjpV1seS740jZO473NGsABRb3Qql4WWJXXc4Q1LjZ6JGcV/LRVL7bt9jqVw9lHKaTwdMvUSpRYra9eHvRS/f1ubz9ZgUq0zh5MxKui2elf3e6eyAvnUYkHY7q9w7udap3AzEZc2A5u1PJIBe12FMWWRe8tYSpXHjM/RuHAhL0qIjyBgrV/jZ5OQ4X3bv7b3K1MhltksP1aDg7e13Eu9xeUFZNiak49vlT/TBHmid6Xzm5t6BBn58URdJeqdAUOeUy1bQiaxzfx3ft9mmucQgCbsf06KDVqZ8uHFMRusMMMt3MrdaxtHIT38Rkxet3yxf4a582wu73ORXVmhID1D8/uWbd2nXD9zIxugcLBF0sIHmnAZkVaVdTj1w2OnCx0Dz4cZpY9IQSNnPVYwUNRb5Sv0QEOzWr+GUwQ83mX0kM7gkcSNlsxMaPkg/o+m/mlma059VZFkSK1MKKu4l1p1krQ9OWXf5Gfc7VK/y6JpVDhexgwcY1/S2bRpEbiytSy8pDobN5cqkKqnP+dLS6hXew==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(46966006)(36840700001)(36860700001)(34020700004)(316002)(108616005)(4326008)(82310400003)(24736004)(47076005)(356005)(966005)(336012)(82740400003)(5660300002)(8936002)(186003)(7636003)(7416002)(54906003)(8676002)(2906002)(478600001)(26005)(426003)(70206006)(86362001)(6916009)(36906005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:07:12.6565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c323ae-7593-4733-1a08-08d8e7d4c6d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0041
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 14:51:33 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.24 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.10.24-rc1-g1dc88c1d74df
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
