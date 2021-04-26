Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A4E36B3BB
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 15:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhDZNFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 09:05:10 -0400
Received: from mail-bn8nam11on2075.outbound.protection.outlook.com ([40.107.236.75]:53089
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231862AbhDZNFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 09:05:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHrTUQ/gVHsOny8SoyqbjQ/5s9nQAJDBndPP9PxPuSuykcNOSHHaQex4i1FO8McFqSZdZKveARJ3pgGjTXISTgkd51Vx8dLg3XHM2YJsXvcFCfuNhVi9Vchi5AraYYSMb8vBMHXOrNG15pWM6Lf/0iJqCs+f6glyFJ4ZzcBpoQDoOryW2yu3LaVbogJn9ZUx3Q/5b5ishggo55LQDZEjrt6OPzvoZBs5uv5Lrv5Nikz+JTnShmtFEcs8hoWm2HJGPp5Gyo+Phxd+eFmdIlqfy4kyD/C5xL/ZFJobJpNIq+1O6B6JVF0zejFzWC8KQCV8Dlxi/o6s210IyAne86RVXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8R53EU/7168o9cgKebJbqASdRNZO1UTpEzQ7pAUFIRI=;
 b=Q4wB5TAyS64kRXu7dRrXvudnYm6dOiW3uxigfz/Ke8MzlLKU9ZRBem9rPUsA7TiBF7KAOpjFjITUnWbbHvWl5rK303c9MeGH7xyXM6fpziihurakFW4bPiTa07h8FSUQyiFDoQu2sh+wgerR5y2eye3sUPceFpjbF4LPC9NvdIaL+brHnsPOZIB3xUM76tYmrAoKMq4PsJ2auN+JpMs133pbsf92jCL9rY/+cMQQ5s3NcqecClxgII68MxOBu02ttBuVfmpZUU5Gt1RPjI3ydThF7EQbU+18xXtra+qOr1iNU3sd6l389lVm6jwgL87xzhYUIBeK7ujwxQ8KkrsxOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8R53EU/7168o9cgKebJbqASdRNZO1UTpEzQ7pAUFIRI=;
 b=m3mduFJDhqCr5MNLMO1UhiX03vwCZWKSL0+QhuSRpkO6uDrmPKqtaZq5C9G+PBWpL27vurze+/gtm6UeikW59nOoZNXOXn52cZfz2y0SmuGjMa8EYnyxvS61FMMaJ/tSTnWJlw6cMkevqkBUciX6JgpxqlWjo7agrOCYXW1ig5H0yq2uQt7Yo6Y+gggF1mPY9uTIe/0cbGOekotzEe1bqoRklP6mVBSr+hHiStW3pkRNUAolmjVcro8tNkQhvAIxlc/L7pq2V11ic1UliU9Zcbvr61UGJfTt9AmYGFFSIuO+kAJWpyshvULrjteNDTSxdfAcayeZqqJPXhunpBBtvA==
Received: from DM5PR18CA0082.namprd18.prod.outlook.com (2603:10b6:3:3::20) by
 SJ0PR12MB5470.namprd12.prod.outlook.com (2603:10b6:a03:3bd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.20; Mon, 26 Apr 2021 13:04:26 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::2c) by DM5PR18CA0082.outlook.office365.com
 (2603:10b6:3:3::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 13:04:24 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 13:04:24 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/49] 4.14.232-rc1 review
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1744b9642a3245dd8c5ada2f814d4cfd@HQMAIL111.nvidia.com>
Date:   Mon, 26 Apr 2021 13:04:24 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18550fc1-c071-4323-c12d-08d908b3d115
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5470:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB547071F49E7926E2382763ACD9429@SJ0PR12MB5470.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHgRRq4X7g4bW1f+d6ORtKqR316mc0MfDGGkisYpZkzMTKxwJwnyFHQL3ACPbDlcsPwr4YaAEcmV2KKcoWkqR0yUIhByhORDhLDBSNjZQ4JVunBiN5pDQlljvJpc4Q0sUwrjPZzcovGAr1+2YkBENIBXFD718AvTj8irJgqcj6i3MlaXSslvHHEqXpwGPt/TRYlXSl4Krg143df2X2cAdU3yuuW8RgeMGcfbjzIRm948wULdg6q2s5/7LxsPPGGvmxhiD+D4HU9HKJHlaDKNf+febTRa2M/rnACFl+MjcghsBBC3ctQqveGEb0cMPsCjz0j3S87bfW5CU/wc36KL8Tb3iLOkEWHnsyYDcx7uJugSOHsOqtj5EHf0AhvWwz30g2KywwcuaRsGaoVZPUAxpRWkyoJ3n5UrFqtnfWsCWndPA3gJ5OCyhACVBatPKofuRN1BmxGod2JwkyWMqR+/OSHsl2zn8AjllpuBlUUzqJ//Q76BIhhFoSvQBzKS4DPhMfiQa4XuexI9wSAizl+JHQWA5BGqGp1eHC/SwGnSAnS5Hjim5YFep13Q1gpVKxvWuzQbvSHIO9MLYJ8m0xVgFsxCcXPcy1rD87uRXL8zILZx6QKC8BToRKBabtXb1LuB4soycuV5LIct7651jEIEJ2btvT8ck4K9g24e7wtMNBF+bwqoY3tHfa9AbJjaG6kkCfHqsZajeEwSc0Lz+33MD7BDuTv9+hX7u6D1NfenuyY=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966006)(36840700001)(86362001)(186003)(70586007)(70206006)(4326008)(356005)(8936002)(7416002)(82740400003)(47076005)(36860700001)(8676002)(478600001)(316002)(966005)(5660300002)(2906002)(82310400003)(54906003)(6916009)(7636003)(24736004)(426003)(336012)(108616005)(36906005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 13:04:24.8488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18550fc1-c071-4323-c12d-08d908b3d115
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5470
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Apr 2021 09:28:56 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.232 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.232-rc1.gz
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

Linux version:	4.14.232-rc1-g3ac46322bf50
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
