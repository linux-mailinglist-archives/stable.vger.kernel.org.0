Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2223FE2E0
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhIATWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:22:21 -0400
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:24353
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229962AbhIATWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:22:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvCJj980+K+DcWjAKGUyxk/dRIHA/5StxaJxVmLdoLyOsmL1xx1B3SFuSHMZPtcT9vCs/sYZEzPXNJlAtnAbyey3nMV3EyBdolTlX5E0F7knzs/PAkVpTMYnphZIemxFEwFM8mvUpkLK//r4xova+qPVa+xztEg+IaTfsxg/Gntljih6r6/SbRetd3eIFYDazFB4HPO3IfutdDTImCMbNkxrTibqZep7egy17DKSw1k+lhDrjjIlWoL1JzeK0ej0fPsAQNqjhwt5Ayu2ZEsaDd+/6fcTXmcb1Nfcv8fiTk8u2KmO8UTMpvxWyxWVCL/c+0KxVhCBVYuogPESYbklFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zET26H5U/7FTjExkbxKUHM8b3SMz55sSS7IcdEtOklI=;
 b=MbYtnRccCsyH7JmuvYcgo9NZoSdfqTyRbixI2egApnx54pHqGkSIkNKHulE9bKhhDNDrHQBa/rLDKkSNdNNx3gZF1M0BuCmaUGqykwJ9q/BG7X/Kw5WkMOAOxH8jURExtJGPB1bn0fZ5l09A8DsQTRTcr4MTOS6IhlD53Y9/tkTKQ0woNAY8pPaFu8V1EhereExEkCorEAgtFRKlkrIgPFAyfTpfVGOzyz8wenWrk6IcJuqpRtSMpfaDR3S/kYdt8dqbXm+siyI7hf1VrxKdjKQ1YvbXqxGHPjQkl7RrkwTSY2Qr2I+kP/ADHxu0z8fekxQy0ypvJ3gpPSoJck7Vng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zET26H5U/7FTjExkbxKUHM8b3SMz55sSS7IcdEtOklI=;
 b=CYo5IZaVXXwd9+5gtZG/lbjplfyKsASjZKxOdtdueNUcAx26dd0vpc1pH07XAkabCzVcS7Mxf5cWBEywahwAQsDmc+D79EC3WZAfVJNhXXqflkeRVYN1cAI9Cmq2z7cD+Dg2g3Vzl3HkexNyPrhx0obk+34GyyxNGpEyQ999od+gr6JKxMCCkGtvu4VEprIoAi5DyC4DrunLBmwAezPOM+ZyOD6PCUSVuObBrlIYbYRrS7XxyNU7puca7FCHGupC4hpqXl28WTmnYxNGi7U6hHaREoHFn4sv1UouXgWUWhtBhr2jc8RIHL5FgWV4lzs1UpaEv5RS6D52YwC2CWmsUg==
Received: from MWHPR07CA0016.namprd07.prod.outlook.com (2603:10b6:300:116::26)
 by SN6PR12MB4704.namprd12.prod.outlook.com (2603:10b6:805:e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Wed, 1 Sep
 2021 19:21:21 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::9f) by MWHPR07CA0016.outlook.office365.com
 (2603:10b6:300:116::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Wed, 1 Sep 2021 19:21:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:21:21 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:21:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:21:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/23] 4.14.246-rc1 review
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
References: <20210901122249.786673285@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1f20b0d78eb2463c9e1fd385d73852d9@HQMAIL107.nvidia.com>
Date:   Wed, 1 Sep 2021 19:21:20 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fe1c690-3b16-49d5-bf3f-08d96d7dae5a
X-MS-TrafficTypeDiagnostic: SN6PR12MB4704:
X-Microsoft-Antispam-PRVS: <SN6PR12MB47041AD6B8E37AC56690B845D9CD9@SN6PR12MB4704.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xk/H+JMKUIFh5X05cCbjsKNw4bIFouMrKm+vZtmpTc3YtYTU6T51mqFgsYNScHz0U1Z57TwgWD+aIu5S7z7PaY2uRvbOLVkyOpaAZBTyWdv6GRkJCVho0ubIGeL8w1qkbCoAKIyrrxcnAoJSx0buzRos1Liwvgcd5zOL6slO664JLXFOnMhhzSxgtFWEWOdrMCqgEcnKb6gXk6Jh+1h4rjzxv/Coavpt1+YQQV1xZjJrTJi8pOHTZZfLvf+MJVGOJM+OFSYUP3J2im7Kf53mD97GvSUMHdmQNm28N2CQEkMhX0TWjmrhfKHDYvm8seFds2lS0Oe31AGyR8B+D/FGCjFb7D2TRa5oL0+nKIftxyj7EUdpGhe3Ml3fccEtMn5d217z5ERquIsYbCHq488GVrYaSKHJcJDz2S6TpQ8gDDI+QM1V0/QnWLvhBaaCjpkjcGm2VXwqj+8/1XyUlCi7elFLwB4IAsBryRYWXFrDdi3Pq3swXlnpqQeC07Mh6CJuQWCxP0EjTMom//8+hlNWxXOUG5AF96eNX7O4YS9hmQoiIl2XxRGqdncAD9GhJitZRMkrvx5A8fGmrkdcUqusN+q0LCQ5WC/xpxRa6FHVV4GbkieLCt6n0gZzZ0hH1vCuySrBZUyRwWjRgN58jeq6iK4E3AFch6GDgxPZnUV/8HoNy4ziO5keUjmSMeH7dRduL6FMvYinpADUe+cXlxW0CKUGV2H5NDVXqKE6S13tBCVTh7pmaPSomUbUln9AgwQ68AH+H+hR2qgmDJxeHIO2ado5rbzQyWTA/zW/CbzNB+s=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7416002)(8676002)(36906005)(316002)(7636003)(8936002)(86362001)(5660300002)(186003)(2906002)(108616005)(24736004)(54906003)(36860700001)(4326008)(6916009)(356005)(82310400003)(47076005)(70586007)(966005)(426003)(508600001)(70206006)(336012)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:21:21.1209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe1c690-3b16-49d5-bf3f-08d96d7dae5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4704
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:26:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.246 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.246-rc1.gz
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

Linux version:	4.14.246-rc1-g8626d0e3c8af
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
